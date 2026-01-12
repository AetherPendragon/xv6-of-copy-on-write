// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

// Reference count for physical pages
// Indexed by physical address divided by PGSIZE
struct {
  struct spinlock lock;
  int refcount[(PHYSTOP - KERNBASE) / PGSIZE];
} refcount;

// Get index for a physical page address
#define PA2IDX(pa) (((uint64)(pa) - KERNBASE) / PGSIZE)

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  initlock(&refcount.lock, "refcount");
  // Initialize all refcounts to 0
  for(int i = 0; i < (PHYSTOP - KERNBASE) / PGSIZE; i++) {
    refcount.refcount[i] = 0;
  }
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  int idx;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    // During initialization, set refcount to 1 before calling kfree
    idx = PA2IDX((uint64)p);
    if(idx >= 0 && idx < (PHYSTOP - KERNBASE) / PGSIZE) {
      acquire(&refcount.lock);
      refcount.refcount[idx] = 1;
      release(&refcount.lock);
    }
    kfree(p);
  }
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;
  int idx;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  idx = PA2IDX((uint64)pa);
  if(idx < 0 || idx >= (PHYSTOP - KERNBASE) / PGSIZE)
    panic("kfree: bad idx");

  acquire(&refcount.lock);
  if(refcount.refcount[idx] <= 0) {
    release(&refcount.lock);
    panic("kfree: refcount");
  }
  refcount.refcount[idx]--;
  int rc = refcount.refcount[idx];
  release(&refcount.lock);

  // Only free the page if refcount reaches 0
  if(rc > 0)
    return;

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;
  int idx;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;
  release(&kmem.lock);

  if(r) {
    memset((char*)r, 5, PGSIZE); // fill with junk
    idx = PA2IDX((uint64)r);
    if(idx >= 0 && idx < (PHYSTOP - KERNBASE) / PGSIZE) {
      acquire(&refcount.lock);
      refcount.refcount[idx] = 1;
      release(&refcount.lock);
    }
  }
  return (void*)r;
}

// Increment reference count for a physical page
void
krefinc(void *pa)
{
  int idx;
  
  if((uint64)pa < KERNBASE || (uint64)pa >= PHYSTOP)
    panic("krefinc: bad pa");
    
  idx = PA2IDX((uint64)pa);
  if(idx < 0 || idx >= (PHYSTOP - KERNBASE) / PGSIZE)
    panic("krefinc: bad idx");
    
  acquire(&refcount.lock);
  if(refcount.refcount[idx] < 1)
    panic("krefinc: refcount");
  refcount.refcount[idx]++;
  release(&refcount.lock);
}

// Get reference count for a physical page
int
krefcount(void *pa)
{
  int idx, rc;
  
  if((uint64)pa < KERNBASE || (uint64)pa >= PHYSTOP)
    return 0;
    
  idx = PA2IDX((uint64)pa);
  if(idx < 0 || idx >= (PHYSTOP - KERNBASE) / PGSIZE)
    return 0;
    
  acquire(&refcount.lock);
  rc = refcount.refcount[idx];
  release(&refcount.lock);
  
  return rc;
}
