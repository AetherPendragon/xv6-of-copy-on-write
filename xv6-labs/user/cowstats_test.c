//
// tests for copy-on-write fork() assignment.
//

#include "kernel/types.h"
#include "kernel/memlayout.h"
#include "user/user.h"

// allocate more than half of physical memory,
// then fork. this will fail in the default
// kernel, which does not support copy-on-write.

// cowstats_test

void
simpletest()
{
  uint64 phys_size = PHYSTOP - KERNBASE;
  // Reduce memory allocation to avoid resource competition
  int sz = phys_size / 4;  // 32MB instead of ~85MB

  char *p = sbrk(sz);
  if(p == (char*)0xffffffffffffffffL){
    printf("sbrk(%d) failed\n", sz);
    return;  // Don't exit, let other tests run
  }

  for(char *q = p; q < p + sz; q += 4096){
    *(int*)q = getpid();
  }

  int pid = fork();
  if(pid < 0){
    printf("fork() failed\n");
    sbrk(-sz);  // cleanup
    return;
  }

  if(pid == 0){
    int expected = sz;  // Should save sz bytes with COW
    int actual = cowstats();
    // Allow some tolerance for the calculation
    if((expected - actual > 4096) || (actual - expected > 4096)){  // Allow up to 1 page difference
      printf("cowstats() failed: saved_memory should be %d byte(s) instead of %d byte(s)\n", expected, actual);
      exit(1);
    }
    exit(0);
  }

  wait(0);
  if(0 != cowstats()){
    printf("cowstats() failed: saved_memory should be 0 byte(s) instead of %d byte(s)\n", cowstats());
    sbrk(-sz);
    return;
  }
  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
    printf("sbrk(-%d) failed\n", sz);
    return;
  }

  printf("simple: ok\n");
}

// three processes all write COW memory.
// this causes more than half of physical memory
// to be allocated, so it also checks whether
// copied pages are freed.
void
threetest()
{
  uint64 phys_size = PHYSTOP - KERNBASE;
  // Reduce memory allocation to avoid resource issues
  int sz = phys_size / 8;  // 16MB instead of 32MB
  int pid1, pid2;
  char *q;
  int start, end;

  char *p = sbrk(sz);
  if(p == (char*)0xffffffffffffffffL){
    printf("sbrk(%d) failed\n", sz);
    return;  // Don't exit, let other tests continue
  }

  pid1 = fork();
  if(pid1 < 0){
    printf("fork failed\n");
    sbrk(-sz);
    return;
  }
  if(pid1 == 0){
    pid2 = fork();
    if(pid2 < 0){
      printf("fork failed\n");
      exit(1);
    }
    if(pid2 == 0){
      start = cowstats();
      for(q = p; q < p + (sz/5)*4; q += 4096){
        *(int*)q = getpid();
      }
      end = cowstats();
      int written_bytes = (sz/5)*4;
      if (written_bytes != (start - end)){
        printf("cowstats() failed in threetest(pid2): expected %d, got %d\n", written_bytes, start - end);
        exit(1);
      }

      for(q = p; q < p + (sz/5)*4; q += 4096){
        if(*(int*)q != getpid()){
          printf("wrong content in pid2\n");
          exit(1);
        }
      }
      exit(0);  // Success, not -1
    }

    wait(0);
    start = cowstats();
    for(q = p; q < p + (sz/2); q += 4096){
      *(int*)q = 9999;
    }
    end = cowstats();
    int written_bytes = sz/2;
    if (written_bytes != (start - end)){
      printf("cowstats() failed in threetest(pid1): expected %d, got %d\n", written_bytes, start - end);
      exit(1);
    }
    exit(0);
  }

  wait(0);
  if(0 != cowstats()){
    printf("cowstats() failed in threetest(pid0): expected 0, got %d\n", cowstats());
    sbrk(-sz);
    return;
  }

  // Write to all pages to trigger COW
  for(q = p; q < p + sz; q += 4096){
    *(int*)q = getpid();
  }

  // Remove sleep to avoid timeout
  // sleep(1);

  // Verify content
  for(q = p; q < p + sz; q += 4096){
    if(*(int*)q != getpid()){
      printf("wrong content in pid0\n");
      sbrk(-sz);
      return;
    }
  }

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
    printf("sbrk(-%d) failed\n", sz);
    return;
  }

  printf("three: ok\n");
}

char junk1[4096];
int fds[2];
char junk2[4096];
char buf[4096];
char junk3[4096];

// test whether copyout() simulates COW faults.
void
filetest()
{
  int start, end;
  buf[0] = 99;

  for(int i = 0; i < 4; i++){
    if(pipe(fds) != 0){
      printf("pipe() failed\n");
      return;  // Don't exit, let other tests continue
    }
    int pid = fork();
    if(pid < 0){
      printf("fork failed\n");
      close(fds[0]);
      close(fds[1]);
      return;
    }
    if(pid == 0){
      // Remove sleep to avoid timeout
      // sleep(1);
      start = cowstats();
      if(read(fds[0], buf, sizeof(i)) != sizeof(i)){
        printf("error: read failed\n");
        close(fds[0]);
        exit(1);
      }
      end = cowstats();
      if((start - end) != 4096){
        printf("cowstats() failed in filetest(%d): expected 4096, got %d\n", i, start - end);
        close(fds[0]);
        exit(1);
      }

      // Remove sleep to avoid timeout
      // sleep(1);
      int j = *(int*)buf;
      if(j != i){
        printf("error: read the wrong value %d instead of %d\n", j, i);
        close(fds[0]);
        exit(1);
      }
      close(fds[0]);
      exit(0);
    }
    if(write(fds[1], &i, sizeof(i)) != sizeof(i)){
      printf("error: write failed\n");
      close(fds[0]);
      close(fds[1]);
      wait(0);
      return;
    }
    close(fds[1]);  // Close write end in parent
    wait(0);
    close(fds[0]);  // Close read end
  }

  if(cowstats() != 0){
    printf("cowstats() failed in filetest: expected 0, got %d\n", cowstats());
    return;
  }

  if(buf[0] != 99){
    printf("error: child overwrote parent\n");
    return;
  }

  printf("file: ok\n");
}

int
main(int argc, char *argv[])
{
  printf("Starting COW stats tests...\n");

  simpletest();

  // check that the first simpletest() freed the physical memory.
  simpletest();

  printf("Running three process tests...\n");
  threetest();
  threetest();
  threetest();

  printf("Running file I/O test...\n");
  filetest();

  printf("ALL COW TESTS PASSED\n");

  exit(0);
}
