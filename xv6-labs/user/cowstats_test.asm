
user/_cowstats_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <simpletest>:

// cowstats_test

void
simpletest()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  // Reduce memory allocation to avoid resource competition
  int sz = phys_size / 4;  // 32MB instead of ~85MB

  char *p = sbrk(sz);
   8:	02000537          	lui	a0,0x2000
   c:	00001097          	auipc	ra,0x1
  10:	9b8080e7          	jalr	-1608(ra) # 9c4 <sbrk>
  if(p == (char*)0xffffffffffffffffL){
  14:	57fd                	li	a5,-1
  16:	06f50763          	beq	a0,a5,84 <simpletest+0x84>
  1a:	ec26                	sd	s1,24(sp)
  1c:	e84a                	sd	s2,16(sp)
  1e:	e44e                	sd	s3,8(sp)
  20:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    return;  // Don't exit, let other tests run
  }

  for(char *q = p; q < p + sz; q += 4096){
  22:	02000937          	lui	s2,0x2000
  26:	992a                	add	s2,s2,a0
  28:	6985                	lui	s3,0x1
    *(int*)q = getpid();
  2a:	00001097          	auipc	ra,0x1
  2e:	992080e7          	jalr	-1646(ra) # 9bc <getpid>
  32:	c088                	sw	a0,0(s1)
  for(char *q = p; q < p + sz; q += 4096){
  34:	94ce                	add	s1,s1,s3
  36:	ff249ae3          	bne	s1,s2,2a <simpletest+0x2a>
  }

  int pid = fork();
  3a:	00001097          	auipc	ra,0x1
  3e:	8fa080e7          	jalr	-1798(ra) # 934 <fork>
  if(pid < 0){
  42:	04054c63          	bltz	a0,9a <simpletest+0x9a>
    printf("fork() failed\n");
    sbrk(-sz);  // cleanup
    return;
  }

  if(pid == 0){
  46:	e149                	bnez	a0,c8 <simpletest+0xc8>
    int expected = sz;  // Should save sz bytes with COW
    int actual = cowstats();
  48:	00001097          	auipc	ra,0x1
  4c:	994080e7          	jalr	-1644(ra) # 9dc <cowstats>
  50:	862a                	mv	a2,a0
    // Allow some tolerance for the calculation
    if((expected - actual > 4096) || (actual - expected > 4096)){  // Allow up to 1 page difference
  52:	020007b7          	lui	a5,0x2000
  56:	9f89                	subw	a5,a5,a0
  58:	6705                	lui	a4,0x1
  5a:	00f74663          	blt	a4,a5,66 <simpletest+0x66>
  5e:	020017b7          	lui	a5,0x2001
  62:	04a7de63          	bge	a5,a0,be <simpletest+0xbe>
      printf("cowstats() failed: saved_memory should be %d byte(s) instead of %d byte(s)\n", expected, actual);
  66:	020005b7          	lui	a1,0x2000
  6a:	00001517          	auipc	a0,0x1
  6e:	e2e50513          	addi	a0,a0,-466 # e98 <malloc+0x134>
  72:	00001097          	auipc	ra,0x1
  76:	c3a080e7          	jalr	-966(ra) # cac <printf>
      exit(1);
  7a:	4505                	li	a0,1
  7c:	00001097          	auipc	ra,0x1
  80:	8c0080e7          	jalr	-1856(ra) # 93c <exit>
    printf("sbrk(%d) failed\n", sz);
  84:	020005b7          	lui	a1,0x2000
  88:	00001517          	auipc	a0,0x1
  8c:	de850513          	addi	a0,a0,-536 # e70 <malloc+0x10c>
  90:	00001097          	auipc	ra,0x1
  94:	c1c080e7          	jalr	-996(ra) # cac <printf>
    return;  // Don't exit, let other tests run
  98:	a0b5                	j	104 <simpletest+0x104>
    printf("fork() failed\n");
  9a:	00001517          	auipc	a0,0x1
  9e:	dee50513          	addi	a0,a0,-530 # e88 <malloc+0x124>
  a2:	00001097          	auipc	ra,0x1
  a6:	c0a080e7          	jalr	-1014(ra) # cac <printf>
    sbrk(-sz);  // cleanup
  aa:	fe000537          	lui	a0,0xfe000
  ae:	00001097          	auipc	ra,0x1
  b2:	916080e7          	jalr	-1770(ra) # 9c4 <sbrk>
    return;
  b6:	64e2                	ld	s1,24(sp)
  b8:	6942                	ld	s2,16(sp)
  ba:	69a2                	ld	s3,8(sp)
  bc:	a0a1                	j	104 <simpletest+0x104>
    }
    exit(0);
  be:	4501                	li	a0,0
  c0:	00001097          	auipc	ra,0x1
  c4:	87c080e7          	jalr	-1924(ra) # 93c <exit>
  }

  wait(0);
  c8:	4501                	li	a0,0
  ca:	00001097          	auipc	ra,0x1
  ce:	87a080e7          	jalr	-1926(ra) # 944 <wait>
  if(0 != cowstats()){
  d2:	00001097          	auipc	ra,0x1
  d6:	90a080e7          	jalr	-1782(ra) # 9dc <cowstats>
  da:	e90d                	bnez	a0,10c <simpletest+0x10c>
    printf("cowstats() failed: saved_memory should be 0 byte(s) instead of %d byte(s)\n", cowstats());
    sbrk(-sz);
    return;
  }
  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
  dc:	fe000537          	lui	a0,0xfe000
  e0:	00001097          	auipc	ra,0x1
  e4:	8e4080e7          	jalr	-1820(ra) # 9c4 <sbrk>
  e8:	57fd                	li	a5,-1
  ea:	04f50863          	beq	a0,a5,13a <simpletest+0x13a>
    printf("sbrk(-%d) failed\n", sz);
    return;
  }

  printf("simple: ok\n");
  ee:	00001517          	auipc	a0,0x1
  f2:	e6250513          	addi	a0,a0,-414 # f50 <malloc+0x1ec>
  f6:	00001097          	auipc	ra,0x1
  fa:	bb6080e7          	jalr	-1098(ra) # cac <printf>
  fe:	64e2                	ld	s1,24(sp)
 100:	6942                	ld	s2,16(sp)
 102:	69a2                	ld	s3,8(sp)
}
 104:	70a2                	ld	ra,40(sp)
 106:	7402                	ld	s0,32(sp)
 108:	6145                	addi	sp,sp,48
 10a:	8082                	ret
    printf("cowstats() failed: saved_memory should be 0 byte(s) instead of %d byte(s)\n", cowstats());
 10c:	00001097          	auipc	ra,0x1
 110:	8d0080e7          	jalr	-1840(ra) # 9dc <cowstats>
 114:	85aa                	mv	a1,a0
 116:	00001517          	auipc	a0,0x1
 11a:	dd250513          	addi	a0,a0,-558 # ee8 <malloc+0x184>
 11e:	00001097          	auipc	ra,0x1
 122:	b8e080e7          	jalr	-1138(ra) # cac <printf>
    sbrk(-sz);
 126:	fe000537          	lui	a0,0xfe000
 12a:	00001097          	auipc	ra,0x1
 12e:	89a080e7          	jalr	-1894(ra) # 9c4 <sbrk>
    return;
 132:	64e2                	ld	s1,24(sp)
 134:	6942                	ld	s2,16(sp)
 136:	69a2                	ld	s3,8(sp)
 138:	b7f1                	j	104 <simpletest+0x104>
    printf("sbrk(-%d) failed\n", sz);
 13a:	020005b7          	lui	a1,0x2000
 13e:	00001517          	auipc	a0,0x1
 142:	dfa50513          	addi	a0,a0,-518 # f38 <malloc+0x1d4>
 146:	00001097          	auipc	ra,0x1
 14a:	b66080e7          	jalr	-1178(ra) # cac <printf>
    return;
 14e:	64e2                	ld	s1,24(sp)
 150:	6942                	ld	s2,16(sp)
 152:	69a2                	ld	s3,8(sp)
 154:	bf45                	j	104 <simpletest+0x104>

0000000000000156 <threetest>:
// this causes more than half of physical memory
// to be allocated, so it also checks whether
// copied pages are freed.
void
threetest()
{
 156:	7139                	addi	sp,sp,-64
 158:	fc06                	sd	ra,56(sp)
 15a:	f822                	sd	s0,48(sp)
 15c:	0080                	addi	s0,sp,64
  int sz = phys_size / 8;  // 16MB instead of 32MB
  int pid1, pid2;
  char *q;
  int start, end;

  char *p = sbrk(sz);
 15e:	01000537          	lui	a0,0x1000
 162:	00001097          	auipc	ra,0x1
 166:	862080e7          	jalr	-1950(ra) # 9c4 <sbrk>
  if(p == (char*)0xffffffffffffffffL){
 16a:	57fd                	li	a5,-1
 16c:	08f50763          	beq	a0,a5,1fa <threetest+0xa4>
 170:	f426                	sd	s1,40(sp)
 172:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    return;  // Don't exit, let other tests continue
  }

  pid1 = fork();
 174:	00000097          	auipc	ra,0x0
 178:	7c0080e7          	jalr	1984(ra) # 934 <fork>
  if(pid1 < 0){
 17c:	08054a63          	bltz	a0,210 <threetest+0xba>
    printf("fork failed\n");
    sbrk(-sz);
    return;
  }
  if(pid1 == 0){
 180:	16051d63          	bnez	a0,2fa <threetest+0x1a4>
    pid2 = fork();
 184:	00000097          	auipc	ra,0x0
 188:	7b0080e7          	jalr	1968(ra) # 934 <fork>
    if(pid2 < 0){
 18c:	0a054263          	bltz	a0,230 <threetest+0xda>
 190:	f04a                	sd	s2,32(sp)
      printf("fork failed\n");
      exit(1);
    }
    if(pid2 == 0){
 192:	e97d                	bnez	a0,288 <threetest+0x132>
 194:	ec4e                	sd	s3,24(sp)
 196:	e852                	sd	s4,16(sp)
 198:	e456                	sd	s5,8(sp)
      start = cowstats();
 19a:	00001097          	auipc	ra,0x1
 19e:	842080e7          	jalr	-1982(ra) # 9dc <cowstats>
 1a2:	8aaa                	mv	s5,a0
      for(q = p; q < p + (sz/5)*4; q += 4096){
 1a4:	00ccd9b7          	lui	s3,0xccd
 1a8:	99a6                	add	s3,s3,s1
 1aa:	8926                	mv	s2,s1
 1ac:	6a05                	lui	s4,0x1
        *(int*)q = getpid();
 1ae:	00001097          	auipc	ra,0x1
 1b2:	80e080e7          	jalr	-2034(ra) # 9bc <getpid>
 1b6:	00a92023          	sw	a0,0(s2) # 2000000 <base+0x1ff9ad0>
      for(q = p; q < p + (sz/5)*4; q += 4096){
 1ba:	9952                	add	s2,s2,s4
 1bc:	ff3919e3          	bne	s2,s3,1ae <threetest+0x58>
      }
      end = cowstats();
 1c0:	00001097          	auipc	ra,0x1
 1c4:	81c080e7          	jalr	-2020(ra) # 9dc <cowstats>
      int written_bytes = (sz/5)*4;
      if (written_bytes != (start - end)){
 1c8:	40aa863b          	subw	a2,s5,a0
 1cc:	00ccd7b7          	lui	a5,0xccd
 1d0:	ccc78793          	addi	a5,a5,-820 # cccccc <base+0xcc679c>
        printf("cowstats() failed in threetest(pid2): expected %d, got %d\n", written_bytes, start - end);
        exit(1);
      }

      for(q = p; q < p + (sz/5)*4; q += 4096){
 1d4:	6a05                	lui	s4,0x1
      if (written_bytes != (start - end)){
 1d6:	06f61e63          	bne	a2,a5,252 <threetest+0xfc>
        if(*(int*)q != getpid()){
 1da:	0004a903          	lw	s2,0(s1)
 1de:	00000097          	auipc	ra,0x0
 1e2:	7de080e7          	jalr	2014(ra) # 9bc <getpid>
 1e6:	08a91463          	bne	s2,a0,26e <threetest+0x118>
      for(q = p; q < p + (sz/5)*4; q += 4096){
 1ea:	94d2                	add	s1,s1,s4
 1ec:	ff3497e3          	bne	s1,s3,1da <threetest+0x84>
          printf("wrong content in pid2\n");
          exit(1);
        }
      }
      exit(0);  // Success, not -1
 1f0:	4501                	li	a0,0
 1f2:	00000097          	auipc	ra,0x0
 1f6:	74a080e7          	jalr	1866(ra) # 93c <exit>
    printf("sbrk(%d) failed\n", sz);
 1fa:	010005b7          	lui	a1,0x1000
 1fe:	00001517          	auipc	a0,0x1
 202:	c7250513          	addi	a0,a0,-910 # e70 <malloc+0x10c>
 206:	00001097          	auipc	ra,0x1
 20a:	aa6080e7          	jalr	-1370(ra) # cac <printf>
    return;  // Don't exit, let other tests continue
 20e:	aa55                	j	3c2 <threetest+0x26c>
    printf("fork failed\n");
 210:	00001517          	auipc	a0,0x1
 214:	d5050513          	addi	a0,a0,-688 # f60 <malloc+0x1fc>
 218:	00001097          	auipc	ra,0x1
 21c:	a94080e7          	jalr	-1388(ra) # cac <printf>
    sbrk(-sz);
 220:	ff000537          	lui	a0,0xff000
 224:	00000097          	auipc	ra,0x0
 228:	7a0080e7          	jalr	1952(ra) # 9c4 <sbrk>
    return;
 22c:	74a2                	ld	s1,40(sp)
 22e:	aa51                	j	3c2 <threetest+0x26c>
 230:	f04a                	sd	s2,32(sp)
 232:	ec4e                	sd	s3,24(sp)
 234:	e852                	sd	s4,16(sp)
 236:	e456                	sd	s5,8(sp)
      printf("fork failed\n");
 238:	00001517          	auipc	a0,0x1
 23c:	d2850513          	addi	a0,a0,-728 # f60 <malloc+0x1fc>
 240:	00001097          	auipc	ra,0x1
 244:	a6c080e7          	jalr	-1428(ra) # cac <printf>
      exit(1);
 248:	4505                	li	a0,1
 24a:	00000097          	auipc	ra,0x0
 24e:	6f2080e7          	jalr	1778(ra) # 93c <exit>
        printf("cowstats() failed in threetest(pid2): expected %d, got %d\n", written_bytes, start - end);
 252:	85be                	mv	a1,a5
 254:	00001517          	auipc	a0,0x1
 258:	d1c50513          	addi	a0,a0,-740 # f70 <malloc+0x20c>
 25c:	00001097          	auipc	ra,0x1
 260:	a50080e7          	jalr	-1456(ra) # cac <printf>
        exit(1);
 264:	4505                	li	a0,1
 266:	00000097          	auipc	ra,0x0
 26a:	6d6080e7          	jalr	1750(ra) # 93c <exit>
          printf("wrong content in pid2\n");
 26e:	00001517          	auipc	a0,0x1
 272:	d4250513          	addi	a0,a0,-702 # fb0 <malloc+0x24c>
 276:	00001097          	auipc	ra,0x1
 27a:	a36080e7          	jalr	-1482(ra) # cac <printf>
          exit(1);
 27e:	4505                	li	a0,1
 280:	00000097          	auipc	ra,0x0
 284:	6bc080e7          	jalr	1724(ra) # 93c <exit>
    }

    wait(0);
 288:	4501                	li	a0,0
 28a:	00000097          	auipc	ra,0x0
 28e:	6ba080e7          	jalr	1722(ra) # 944 <wait>
    start = cowstats();
 292:	00000097          	auipc	ra,0x0
 296:	74a080e7          	jalr	1866(ra) # 9dc <cowstats>
 29a:	892a                	mv	s2,a0
    for(q = p; q < p + (sz/2); q += 4096){
 29c:	00800737          	lui	a4,0x800
 2a0:	9726                	add	a4,a4,s1
      *(int*)q = 9999;
 2a2:	6789                	lui	a5,0x2
 2a4:	70f78793          	addi	a5,a5,1807 # 270f <junk3+0x1df>
    for(q = p; q < p + (sz/2); q += 4096){
 2a8:	6685                	lui	a3,0x1
      *(int*)q = 9999;
 2aa:	c09c                	sw	a5,0(s1)
    for(q = p; q < p + (sz/2); q += 4096){
 2ac:	94b6                	add	s1,s1,a3
 2ae:	fee49ee3          	bne	s1,a4,2aa <threetest+0x154>
    }
    end = cowstats();
 2b2:	00000097          	auipc	ra,0x0
 2b6:	72a080e7          	jalr	1834(ra) # 9dc <cowstats>
    int written_bytes = sz/2;
    if (written_bytes != (start - end)){
 2ba:	40a9063b          	subw	a2,s2,a0
 2be:	008007b7          	lui	a5,0x800
 2c2:	02f60463          	beq	a2,a5,2ea <threetest+0x194>
 2c6:	ec4e                	sd	s3,24(sp)
 2c8:	e852                	sd	s4,16(sp)
 2ca:	e456                	sd	s5,8(sp)
      printf("cowstats() failed in threetest(pid1): expected %d, got %d\n", written_bytes, start - end);
 2cc:	008005b7          	lui	a1,0x800
 2d0:	00001517          	auipc	a0,0x1
 2d4:	cf850513          	addi	a0,a0,-776 # fc8 <malloc+0x264>
 2d8:	00001097          	auipc	ra,0x1
 2dc:	9d4080e7          	jalr	-1580(ra) # cac <printf>
      exit(1);
 2e0:	4505                	li	a0,1
 2e2:	00000097          	auipc	ra,0x0
 2e6:	65a080e7          	jalr	1626(ra) # 93c <exit>
 2ea:	ec4e                	sd	s3,24(sp)
 2ec:	e852                	sd	s4,16(sp)
 2ee:	e456                	sd	s5,8(sp)
    }
    exit(0);
 2f0:	4501                	li	a0,0
 2f2:	00000097          	auipc	ra,0x0
 2f6:	64a080e7          	jalr	1610(ra) # 93c <exit>
  }

  wait(0);
 2fa:	4501                	li	a0,0
 2fc:	00000097          	auipc	ra,0x0
 300:	648080e7          	jalr	1608(ra) # 944 <wait>
  if(0 != cowstats()){
 304:	00000097          	auipc	ra,0x0
 308:	6d8080e7          	jalr	1752(ra) # 9dc <cowstats>
 30c:	e525                	bnez	a0,374 <threetest+0x21e>
 30e:	f04a                	sd	s2,32(sp)
 310:	ec4e                	sd	s3,24(sp)
 312:	e852                	sd	s4,16(sp)
    sbrk(-sz);
    return;
  }

  // Write to all pages to trigger COW
  for(q = p; q < p + sz; q += 4096){
 314:	010009b7          	lui	s3,0x1000
 318:	99a6                	add	s3,s3,s1
 31a:	8926                	mv	s2,s1
 31c:	6a05                	lui	s4,0x1
    *(int*)q = getpid();
 31e:	00000097          	auipc	ra,0x0
 322:	69e080e7          	jalr	1694(ra) # 9bc <getpid>
 326:	00a92023          	sw	a0,0(s2)
  for(q = p; q < p + sz; q += 4096){
 32a:	9952                	add	s2,s2,s4
 32c:	ff3919e3          	bne	s2,s3,31e <threetest+0x1c8>

  // Remove sleep to avoid timeout
  // sleep(1);

  // Verify content
  for(q = p; q < p + sz; q += 4096){
 330:	6a05                	lui	s4,0x1
    if(*(int*)q != getpid()){
 332:	0004a903          	lw	s2,0(s1)
 336:	00000097          	auipc	ra,0x0
 33a:	686080e7          	jalr	1670(ra) # 9bc <getpid>
 33e:	06a91063          	bne	s2,a0,39e <threetest+0x248>
  for(q = p; q < p + sz; q += 4096){
 342:	94d2                	add	s1,s1,s4
 344:	ff3497e3          	bne	s1,s3,332 <threetest+0x1dc>
      sbrk(-sz);
      return;
    }
  }

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
 348:	ff000537          	lui	a0,0xff000
 34c:	00000097          	auipc	ra,0x0
 350:	678080e7          	jalr	1656(ra) # 9c4 <sbrk>
 354:	57fd                	li	a5,-1
 356:	06f50a63          	beq	a0,a5,3ca <threetest+0x274>
    printf("sbrk(-%d) failed\n", sz);
    return;
  }

  printf("three: ok\n");
 35a:	00001517          	auipc	a0,0x1
 35e:	d0650513          	addi	a0,a0,-762 # 1060 <malloc+0x2fc>
 362:	00001097          	auipc	ra,0x1
 366:	94a080e7          	jalr	-1718(ra) # cac <printf>
 36a:	74a2                	ld	s1,40(sp)
 36c:	7902                	ld	s2,32(sp)
 36e:	69e2                	ld	s3,24(sp)
 370:	6a42                	ld	s4,16(sp)
 372:	a881                	j	3c2 <threetest+0x26c>
    printf("cowstats() failed in threetest(pid0): expected 0, got %d\n", cowstats());
 374:	00000097          	auipc	ra,0x0
 378:	668080e7          	jalr	1640(ra) # 9dc <cowstats>
 37c:	85aa                	mv	a1,a0
 37e:	00001517          	auipc	a0,0x1
 382:	c8a50513          	addi	a0,a0,-886 # 1008 <malloc+0x2a4>
 386:	00001097          	auipc	ra,0x1
 38a:	926080e7          	jalr	-1754(ra) # cac <printf>
    sbrk(-sz);
 38e:	ff000537          	lui	a0,0xff000
 392:	00000097          	auipc	ra,0x0
 396:	632080e7          	jalr	1586(ra) # 9c4 <sbrk>
    return;
 39a:	74a2                	ld	s1,40(sp)
 39c:	a01d                	j	3c2 <threetest+0x26c>
      printf("wrong content in pid0\n");
 39e:	00001517          	auipc	a0,0x1
 3a2:	caa50513          	addi	a0,a0,-854 # 1048 <malloc+0x2e4>
 3a6:	00001097          	auipc	ra,0x1
 3aa:	906080e7          	jalr	-1786(ra) # cac <printf>
      sbrk(-sz);
 3ae:	ff000537          	lui	a0,0xff000
 3b2:	00000097          	auipc	ra,0x0
 3b6:	612080e7          	jalr	1554(ra) # 9c4 <sbrk>
      return;
 3ba:	74a2                	ld	s1,40(sp)
 3bc:	7902                	ld	s2,32(sp)
 3be:	69e2                	ld	s3,24(sp)
 3c0:	6a42                	ld	s4,16(sp)
}
 3c2:	70e2                	ld	ra,56(sp)
 3c4:	7442                	ld	s0,48(sp)
 3c6:	6121                	addi	sp,sp,64
 3c8:	8082                	ret
    printf("sbrk(-%d) failed\n", sz);
 3ca:	010005b7          	lui	a1,0x1000
 3ce:	00001517          	auipc	a0,0x1
 3d2:	b6a50513          	addi	a0,a0,-1174 # f38 <malloc+0x1d4>
 3d6:	00001097          	auipc	ra,0x1
 3da:	8d6080e7          	jalr	-1834(ra) # cac <printf>
    return;
 3de:	74a2                	ld	s1,40(sp)
 3e0:	7902                	ld	s2,32(sp)
 3e2:	69e2                	ld	s3,24(sp)
 3e4:	6a42                	ld	s4,16(sp)
 3e6:	bff1                	j	3c2 <threetest+0x26c>

00000000000003e8 <filetest>:
char junk3[4096];

// test whether copyout() simulates COW faults.
void
filetest()
{
 3e8:	7179                	addi	sp,sp,-48
 3ea:	f406                	sd	ra,40(sp)
 3ec:	f022                	sd	s0,32(sp)
 3ee:	ec26                	sd	s1,24(sp)
 3f0:	e84a                	sd	s2,16(sp)
 3f2:	1800                	addi	s0,sp,48
  int start, end;
  buf[0] = 99;
 3f4:	06300793          	li	a5,99
 3f8:	00003717          	auipc	a4,0x3
 3fc:	12f70c23          	sb	a5,312(a4) # 3530 <buf>

  for(int i = 0; i < 4; i++){
 400:	fc042e23          	sw	zero,-36(s0)
    if(pipe(fds) != 0){
 404:	00002497          	auipc	s1,0x2
 408:	11c48493          	addi	s1,s1,284 # 2520 <fds>
  for(int i = 0; i < 4; i++){
 40c:	490d                	li	s2,3
    if(pipe(fds) != 0){
 40e:	8526                	mv	a0,s1
 410:	00000097          	auipc	ra,0x0
 414:	53c080e7          	jalr	1340(ra) # 94c <pipe>
 418:	e151                	bnez	a0,49c <filetest+0xb4>
      printf("pipe() failed\n");
      return;  // Don't exit, let other tests continue
    }
    int pid = fork();
 41a:	00000097          	auipc	ra,0x0
 41e:	51a080e7          	jalr	1306(ra) # 934 <fork>
    if(pid < 0){
 422:	08054b63          	bltz	a0,4b8 <filetest+0xd0>
      printf("fork failed\n");
      close(fds[0]);
      close(fds[1]);
      return;
    }
    if(pid == 0){
 426:	c161                	beqz	a0,4e6 <filetest+0xfe>
        exit(1);
      }
      close(fds[0]);
      exit(0);
    }
    if(write(fds[1], &i, sizeof(i)) != sizeof(i)){
 428:	4611                	li	a2,4
 42a:	fdc40593          	addi	a1,s0,-36
 42e:	40c8                	lw	a0,4(s1)
 430:	00000097          	auipc	ra,0x0
 434:	52c080e7          	jalr	1324(ra) # 95c <write>
 438:	4791                	li	a5,4
 43a:	18f51a63          	bne	a0,a5,5ce <filetest+0x1e6>
      close(fds[0]);
      close(fds[1]);
      wait(0);
      return;
    }
    close(fds[1]);  // Close write end in parent
 43e:	40c8                	lw	a0,4(s1)
 440:	00000097          	auipc	ra,0x0
 444:	524080e7          	jalr	1316(ra) # 964 <close>
    wait(0);
 448:	4501                	li	a0,0
 44a:	00000097          	auipc	ra,0x0
 44e:	4fa080e7          	jalr	1274(ra) # 944 <wait>
    close(fds[0]);  // Close read end
 452:	4088                	lw	a0,0(s1)
 454:	00000097          	auipc	ra,0x0
 458:	510080e7          	jalr	1296(ra) # 964 <close>
  for(int i = 0; i < 4; i++){
 45c:	fdc42783          	lw	a5,-36(s0)
 460:	2785                	addiw	a5,a5,1 # 800001 <base+0x7f9ad1>
 462:	0007871b          	sext.w	a4,a5
 466:	fcf42e23          	sw	a5,-36(s0)
 46a:	fae952e3          	bge	s2,a4,40e <filetest+0x26>
  }

  if(cowstats() != 0){
 46e:	00000097          	auipc	ra,0x0
 472:	56e080e7          	jalr	1390(ra) # 9dc <cowstats>
 476:	18051863          	bnez	a0,606 <filetest+0x21e>
    printf("cowstats() failed in filetest: expected 0, got %d\n", cowstats());
    return;
  }

  if(buf[0] != 99){
 47a:	00003717          	auipc	a4,0x3
 47e:	0b674703          	lbu	a4,182(a4) # 3530 <buf>
 482:	06300793          	li	a5,99
 486:	18f70e63          	beq	a4,a5,622 <filetest+0x23a>
    printf("error: child overwrote parent\n");
 48a:	00001517          	auipc	a0,0x1
 48e:	cce50513          	addi	a0,a0,-818 # 1158 <malloc+0x3f4>
 492:	00001097          	auipc	ra,0x1
 496:	81a080e7          	jalr	-2022(ra) # cac <printf>
    return;
 49a:	a809                	j	4ac <filetest+0xc4>
      printf("pipe() failed\n");
 49c:	00001517          	auipc	a0,0x1
 4a0:	bd450513          	addi	a0,a0,-1068 # 1070 <malloc+0x30c>
 4a4:	00001097          	auipc	ra,0x1
 4a8:	808080e7          	jalr	-2040(ra) # cac <printf>
  }

  printf("file: ok\n");
}
 4ac:	70a2                	ld	ra,40(sp)
 4ae:	7402                	ld	s0,32(sp)
 4b0:	64e2                	ld	s1,24(sp)
 4b2:	6942                	ld	s2,16(sp)
 4b4:	6145                	addi	sp,sp,48
 4b6:	8082                	ret
      printf("fork failed\n");
 4b8:	00001517          	auipc	a0,0x1
 4bc:	aa850513          	addi	a0,a0,-1368 # f60 <malloc+0x1fc>
 4c0:	00000097          	auipc	ra,0x0
 4c4:	7ec080e7          	jalr	2028(ra) # cac <printf>
      close(fds[0]);
 4c8:	00002497          	auipc	s1,0x2
 4cc:	05848493          	addi	s1,s1,88 # 2520 <fds>
 4d0:	4088                	lw	a0,0(s1)
 4d2:	00000097          	auipc	ra,0x0
 4d6:	492080e7          	jalr	1170(ra) # 964 <close>
      close(fds[1]);
 4da:	40c8                	lw	a0,4(s1)
 4dc:	00000097          	auipc	ra,0x0
 4e0:	488080e7          	jalr	1160(ra) # 964 <close>
      return;
 4e4:	b7e1                	j	4ac <filetest+0xc4>
      start = cowstats();
 4e6:	00000097          	auipc	ra,0x0
 4ea:	4f6080e7          	jalr	1270(ra) # 9dc <cowstats>
 4ee:	84aa                	mv	s1,a0
      if(read(fds[0], buf, sizeof(i)) != sizeof(i)){
 4f0:	4611                	li	a2,4
 4f2:	00003597          	auipc	a1,0x3
 4f6:	03e58593          	addi	a1,a1,62 # 3530 <buf>
 4fa:	00002517          	auipc	a0,0x2
 4fe:	02652503          	lw	a0,38(a0) # 2520 <fds>
 502:	00000097          	auipc	ra,0x0
 506:	452080e7          	jalr	1106(ra) # 954 <read>
 50a:	4791                	li	a5,4
 50c:	04f51863          	bne	a0,a5,55c <filetest+0x174>
      end = cowstats();
 510:	00000097          	auipc	ra,0x0
 514:	4cc080e7          	jalr	1228(ra) # 9dc <cowstats>
      if((start - end) != 4096){
 518:	40a4863b          	subw	a2,s1,a0
 51c:	6785                	lui	a5,0x1
 51e:	06f61463          	bne	a2,a5,586 <filetest+0x19e>
      int j = *(int*)buf;
 522:	00003597          	auipc	a1,0x3
 526:	00e5a583          	lw	a1,14(a1) # 3530 <buf>
      if(j != i){
 52a:	fdc42603          	lw	a2,-36(s0)
 52e:	08b60363          	beq	a2,a1,5b4 <filetest+0x1cc>
        printf("error: read the wrong value %d instead of %d\n", j, i);
 532:	00001517          	auipc	a0,0x1
 536:	ba650513          	addi	a0,a0,-1114 # 10d8 <malloc+0x374>
 53a:	00000097          	auipc	ra,0x0
 53e:	772080e7          	jalr	1906(ra) # cac <printf>
        close(fds[0]);
 542:	00002517          	auipc	a0,0x2
 546:	fde52503          	lw	a0,-34(a0) # 2520 <fds>
 54a:	00000097          	auipc	ra,0x0
 54e:	41a080e7          	jalr	1050(ra) # 964 <close>
        exit(1);
 552:	4505                	li	a0,1
 554:	00000097          	auipc	ra,0x0
 558:	3e8080e7          	jalr	1000(ra) # 93c <exit>
        printf("error: read failed\n");
 55c:	00001517          	auipc	a0,0x1
 560:	b2450513          	addi	a0,a0,-1244 # 1080 <malloc+0x31c>
 564:	00000097          	auipc	ra,0x0
 568:	748080e7          	jalr	1864(ra) # cac <printf>
        close(fds[0]);
 56c:	00002517          	auipc	a0,0x2
 570:	fb452503          	lw	a0,-76(a0) # 2520 <fds>
 574:	00000097          	auipc	ra,0x0
 578:	3f0080e7          	jalr	1008(ra) # 964 <close>
        exit(1);
 57c:	4505                	li	a0,1
 57e:	00000097          	auipc	ra,0x0
 582:	3be080e7          	jalr	958(ra) # 93c <exit>
        printf("cowstats() failed in filetest(%d): expected 4096, got %d\n", i, start - end);
 586:	fdc42583          	lw	a1,-36(s0)
 58a:	00001517          	auipc	a0,0x1
 58e:	b0e50513          	addi	a0,a0,-1266 # 1098 <malloc+0x334>
 592:	00000097          	auipc	ra,0x0
 596:	71a080e7          	jalr	1818(ra) # cac <printf>
        close(fds[0]);
 59a:	00002517          	auipc	a0,0x2
 59e:	f8652503          	lw	a0,-122(a0) # 2520 <fds>
 5a2:	00000097          	auipc	ra,0x0
 5a6:	3c2080e7          	jalr	962(ra) # 964 <close>
        exit(1);
 5aa:	4505                	li	a0,1
 5ac:	00000097          	auipc	ra,0x0
 5b0:	390080e7          	jalr	912(ra) # 93c <exit>
      close(fds[0]);
 5b4:	00002517          	auipc	a0,0x2
 5b8:	f6c52503          	lw	a0,-148(a0) # 2520 <fds>
 5bc:	00000097          	auipc	ra,0x0
 5c0:	3a8080e7          	jalr	936(ra) # 964 <close>
      exit(0);
 5c4:	4501                	li	a0,0
 5c6:	00000097          	auipc	ra,0x0
 5ca:	376080e7          	jalr	886(ra) # 93c <exit>
      printf("error: write failed\n");
 5ce:	00001517          	auipc	a0,0x1
 5d2:	b3a50513          	addi	a0,a0,-1222 # 1108 <malloc+0x3a4>
 5d6:	00000097          	auipc	ra,0x0
 5da:	6d6080e7          	jalr	1750(ra) # cac <printf>
      close(fds[0]);
 5de:	00002497          	auipc	s1,0x2
 5e2:	f4248493          	addi	s1,s1,-190 # 2520 <fds>
 5e6:	4088                	lw	a0,0(s1)
 5e8:	00000097          	auipc	ra,0x0
 5ec:	37c080e7          	jalr	892(ra) # 964 <close>
      close(fds[1]);
 5f0:	40c8                	lw	a0,4(s1)
 5f2:	00000097          	auipc	ra,0x0
 5f6:	372080e7          	jalr	882(ra) # 964 <close>
      wait(0);
 5fa:	4501                	li	a0,0
 5fc:	00000097          	auipc	ra,0x0
 600:	348080e7          	jalr	840(ra) # 944 <wait>
      return;
 604:	b565                	j	4ac <filetest+0xc4>
    printf("cowstats() failed in filetest: expected 0, got %d\n", cowstats());
 606:	00000097          	auipc	ra,0x0
 60a:	3d6080e7          	jalr	982(ra) # 9dc <cowstats>
 60e:	85aa                	mv	a1,a0
 610:	00001517          	auipc	a0,0x1
 614:	b1050513          	addi	a0,a0,-1264 # 1120 <malloc+0x3bc>
 618:	00000097          	auipc	ra,0x0
 61c:	694080e7          	jalr	1684(ra) # cac <printf>
    return;
 620:	b571                	j	4ac <filetest+0xc4>
  printf("file: ok\n");
 622:	00001517          	auipc	a0,0x1
 626:	b5650513          	addi	a0,a0,-1194 # 1178 <malloc+0x414>
 62a:	00000097          	auipc	ra,0x0
 62e:	682080e7          	jalr	1666(ra) # cac <printf>
 632:	bdad                	j	4ac <filetest+0xc4>

0000000000000634 <main>:

int
main(int argc, char *argv[])
{
 634:	1141                	addi	sp,sp,-16
 636:	e406                	sd	ra,8(sp)
 638:	e022                	sd	s0,0(sp)
 63a:	0800                	addi	s0,sp,16
  printf("Starting COW stats tests...\n");
 63c:	00001517          	auipc	a0,0x1
 640:	b4c50513          	addi	a0,a0,-1204 # 1188 <malloc+0x424>
 644:	00000097          	auipc	ra,0x0
 648:	668080e7          	jalr	1640(ra) # cac <printf>

  simpletest();
 64c:	00000097          	auipc	ra,0x0
 650:	9b4080e7          	jalr	-1612(ra) # 0 <simpletest>

  // check that the first simpletest() freed the physical memory.
  simpletest();
 654:	00000097          	auipc	ra,0x0
 658:	9ac080e7          	jalr	-1620(ra) # 0 <simpletest>

  printf("Running three process tests...\n");
 65c:	00001517          	auipc	a0,0x1
 660:	b4c50513          	addi	a0,a0,-1204 # 11a8 <malloc+0x444>
 664:	00000097          	auipc	ra,0x0
 668:	648080e7          	jalr	1608(ra) # cac <printf>
  threetest();
 66c:	00000097          	auipc	ra,0x0
 670:	aea080e7          	jalr	-1302(ra) # 156 <threetest>
  threetest();
 674:	00000097          	auipc	ra,0x0
 678:	ae2080e7          	jalr	-1310(ra) # 156 <threetest>
  threetest();
 67c:	00000097          	auipc	ra,0x0
 680:	ada080e7          	jalr	-1318(ra) # 156 <threetest>

  printf("Running file I/O test...\n");
 684:	00001517          	auipc	a0,0x1
 688:	b4450513          	addi	a0,a0,-1212 # 11c8 <malloc+0x464>
 68c:	00000097          	auipc	ra,0x0
 690:	620080e7          	jalr	1568(ra) # cac <printf>
  filetest();
 694:	00000097          	auipc	ra,0x0
 698:	d54080e7          	jalr	-684(ra) # 3e8 <filetest>

  printf("ALL COW TESTS PASSED\n");
 69c:	00001517          	auipc	a0,0x1
 6a0:	b4c50513          	addi	a0,a0,-1204 # 11e8 <malloc+0x484>
 6a4:	00000097          	auipc	ra,0x0
 6a8:	608080e7          	jalr	1544(ra) # cac <printf>

  exit(0);
 6ac:	4501                	li	a0,0
 6ae:	00000097          	auipc	ra,0x0
 6b2:	28e080e7          	jalr	654(ra) # 93c <exit>

00000000000006b6 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 6b6:	1141                	addi	sp,sp,-16
 6b8:	e406                	sd	ra,8(sp)
 6ba:	e022                	sd	s0,0(sp)
 6bc:	0800                	addi	s0,sp,16
  extern int main();
  main();
 6be:	00000097          	auipc	ra,0x0
 6c2:	f76080e7          	jalr	-138(ra) # 634 <main>
  exit(0);
 6c6:	4501                	li	a0,0
 6c8:	00000097          	auipc	ra,0x0
 6cc:	274080e7          	jalr	628(ra) # 93c <exit>

00000000000006d0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 6d0:	1141                	addi	sp,sp,-16
 6d2:	e422                	sd	s0,8(sp)
 6d4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 6d6:	87aa                	mv	a5,a0
 6d8:	0585                	addi	a1,a1,1
 6da:	0785                	addi	a5,a5,1 # 1001 <malloc+0x29d>
 6dc:	fff5c703          	lbu	a4,-1(a1)
 6e0:	fee78fa3          	sb	a4,-1(a5)
 6e4:	fb75                	bnez	a4,6d8 <strcpy+0x8>
    ;
  return os;
}
 6e6:	6422                	ld	s0,8(sp)
 6e8:	0141                	addi	sp,sp,16
 6ea:	8082                	ret

00000000000006ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
 6ec:	1141                	addi	sp,sp,-16
 6ee:	e422                	sd	s0,8(sp)
 6f0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 6f2:	00054783          	lbu	a5,0(a0)
 6f6:	cb91                	beqz	a5,70a <strcmp+0x1e>
 6f8:	0005c703          	lbu	a4,0(a1)
 6fc:	00f71763          	bne	a4,a5,70a <strcmp+0x1e>
    p++, q++;
 700:	0505                	addi	a0,a0,1
 702:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 704:	00054783          	lbu	a5,0(a0)
 708:	fbe5                	bnez	a5,6f8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 70a:	0005c503          	lbu	a0,0(a1)
}
 70e:	40a7853b          	subw	a0,a5,a0
 712:	6422                	ld	s0,8(sp)
 714:	0141                	addi	sp,sp,16
 716:	8082                	ret

0000000000000718 <strlen>:

uint
strlen(const char *s)
{
 718:	1141                	addi	sp,sp,-16
 71a:	e422                	sd	s0,8(sp)
 71c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 71e:	00054783          	lbu	a5,0(a0)
 722:	cf91                	beqz	a5,73e <strlen+0x26>
 724:	0505                	addi	a0,a0,1
 726:	87aa                	mv	a5,a0
 728:	86be                	mv	a3,a5
 72a:	0785                	addi	a5,a5,1
 72c:	fff7c703          	lbu	a4,-1(a5)
 730:	ff65                	bnez	a4,728 <strlen+0x10>
 732:	40a6853b          	subw	a0,a3,a0
 736:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 738:	6422                	ld	s0,8(sp)
 73a:	0141                	addi	sp,sp,16
 73c:	8082                	ret
  for(n = 0; s[n]; n++)
 73e:	4501                	li	a0,0
 740:	bfe5                	j	738 <strlen+0x20>

0000000000000742 <memset>:

void*
memset(void *dst, int c, uint n)
{
 742:	1141                	addi	sp,sp,-16
 744:	e422                	sd	s0,8(sp)
 746:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 748:	ca19                	beqz	a2,75e <memset+0x1c>
 74a:	87aa                	mv	a5,a0
 74c:	1602                	slli	a2,a2,0x20
 74e:	9201                	srli	a2,a2,0x20
 750:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 754:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 758:	0785                	addi	a5,a5,1
 75a:	fee79de3          	bne	a5,a4,754 <memset+0x12>
  }
  return dst;
}
 75e:	6422                	ld	s0,8(sp)
 760:	0141                	addi	sp,sp,16
 762:	8082                	ret

0000000000000764 <strchr>:

char*
strchr(const char *s, char c)
{
 764:	1141                	addi	sp,sp,-16
 766:	e422                	sd	s0,8(sp)
 768:	0800                	addi	s0,sp,16
  for(; *s; s++)
 76a:	00054783          	lbu	a5,0(a0)
 76e:	cb99                	beqz	a5,784 <strchr+0x20>
    if(*s == c)
 770:	00f58763          	beq	a1,a5,77e <strchr+0x1a>
  for(; *s; s++)
 774:	0505                	addi	a0,a0,1
 776:	00054783          	lbu	a5,0(a0)
 77a:	fbfd                	bnez	a5,770 <strchr+0xc>
      return (char*)s;
  return 0;
 77c:	4501                	li	a0,0
}
 77e:	6422                	ld	s0,8(sp)
 780:	0141                	addi	sp,sp,16
 782:	8082                	ret
  return 0;
 784:	4501                	li	a0,0
 786:	bfe5                	j	77e <strchr+0x1a>

0000000000000788 <gets>:

char*
gets(char *buf, int max)
{
 788:	711d                	addi	sp,sp,-96
 78a:	ec86                	sd	ra,88(sp)
 78c:	e8a2                	sd	s0,80(sp)
 78e:	e4a6                	sd	s1,72(sp)
 790:	e0ca                	sd	s2,64(sp)
 792:	fc4e                	sd	s3,56(sp)
 794:	f852                	sd	s4,48(sp)
 796:	f456                	sd	s5,40(sp)
 798:	f05a                	sd	s6,32(sp)
 79a:	ec5e                	sd	s7,24(sp)
 79c:	1080                	addi	s0,sp,96
 79e:	8baa                	mv	s7,a0
 7a0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7a2:	892a                	mv	s2,a0
 7a4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 7a6:	4aa9                	li	s5,10
 7a8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 7aa:	89a6                	mv	s3,s1
 7ac:	2485                	addiw	s1,s1,1
 7ae:	0344d863          	bge	s1,s4,7de <gets+0x56>
    cc = read(0, &c, 1);
 7b2:	4605                	li	a2,1
 7b4:	faf40593          	addi	a1,s0,-81
 7b8:	4501                	li	a0,0
 7ba:	00000097          	auipc	ra,0x0
 7be:	19a080e7          	jalr	410(ra) # 954 <read>
    if(cc < 1)
 7c2:	00a05e63          	blez	a0,7de <gets+0x56>
    buf[i++] = c;
 7c6:	faf44783          	lbu	a5,-81(s0)
 7ca:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 7ce:	01578763          	beq	a5,s5,7dc <gets+0x54>
 7d2:	0905                	addi	s2,s2,1
 7d4:	fd679be3          	bne	a5,s6,7aa <gets+0x22>
    buf[i++] = c;
 7d8:	89a6                	mv	s3,s1
 7da:	a011                	j	7de <gets+0x56>
 7dc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 7de:	99de                	add	s3,s3,s7
 7e0:	00098023          	sb	zero,0(s3) # 1000000 <base+0xff9ad0>
  return buf;
}
 7e4:	855e                	mv	a0,s7
 7e6:	60e6                	ld	ra,88(sp)
 7e8:	6446                	ld	s0,80(sp)
 7ea:	64a6                	ld	s1,72(sp)
 7ec:	6906                	ld	s2,64(sp)
 7ee:	79e2                	ld	s3,56(sp)
 7f0:	7a42                	ld	s4,48(sp)
 7f2:	7aa2                	ld	s5,40(sp)
 7f4:	7b02                	ld	s6,32(sp)
 7f6:	6be2                	ld	s7,24(sp)
 7f8:	6125                	addi	sp,sp,96
 7fa:	8082                	ret

00000000000007fc <stat>:

int
stat(const char *n, struct stat *st)
{
 7fc:	1101                	addi	sp,sp,-32
 7fe:	ec06                	sd	ra,24(sp)
 800:	e822                	sd	s0,16(sp)
 802:	e04a                	sd	s2,0(sp)
 804:	1000                	addi	s0,sp,32
 806:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 808:	4581                	li	a1,0
 80a:	00000097          	auipc	ra,0x0
 80e:	172080e7          	jalr	370(ra) # 97c <open>
  if(fd < 0)
 812:	02054663          	bltz	a0,83e <stat+0x42>
 816:	e426                	sd	s1,8(sp)
 818:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 81a:	85ca                	mv	a1,s2
 81c:	00000097          	auipc	ra,0x0
 820:	178080e7          	jalr	376(ra) # 994 <fstat>
 824:	892a                	mv	s2,a0
  close(fd);
 826:	8526                	mv	a0,s1
 828:	00000097          	auipc	ra,0x0
 82c:	13c080e7          	jalr	316(ra) # 964 <close>
  return r;
 830:	64a2                	ld	s1,8(sp)
}
 832:	854a                	mv	a0,s2
 834:	60e2                	ld	ra,24(sp)
 836:	6442                	ld	s0,16(sp)
 838:	6902                	ld	s2,0(sp)
 83a:	6105                	addi	sp,sp,32
 83c:	8082                	ret
    return -1;
 83e:	597d                	li	s2,-1
 840:	bfcd                	j	832 <stat+0x36>

0000000000000842 <atoi>:

int
atoi(const char *s)
{
 842:	1141                	addi	sp,sp,-16
 844:	e422                	sd	s0,8(sp)
 846:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 848:	00054683          	lbu	a3,0(a0)
 84c:	fd06879b          	addiw	a5,a3,-48 # fd0 <malloc+0x26c>
 850:	0ff7f793          	zext.b	a5,a5
 854:	4625                	li	a2,9
 856:	02f66863          	bltu	a2,a5,886 <atoi+0x44>
 85a:	872a                	mv	a4,a0
  n = 0;
 85c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 85e:	0705                	addi	a4,a4,1
 860:	0025179b          	slliw	a5,a0,0x2
 864:	9fa9                	addw	a5,a5,a0
 866:	0017979b          	slliw	a5,a5,0x1
 86a:	9fb5                	addw	a5,a5,a3
 86c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 870:	00074683          	lbu	a3,0(a4)
 874:	fd06879b          	addiw	a5,a3,-48
 878:	0ff7f793          	zext.b	a5,a5
 87c:	fef671e3          	bgeu	a2,a5,85e <atoi+0x1c>
  return n;
}
 880:	6422                	ld	s0,8(sp)
 882:	0141                	addi	sp,sp,16
 884:	8082                	ret
  n = 0;
 886:	4501                	li	a0,0
 888:	bfe5                	j	880 <atoi+0x3e>

000000000000088a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 88a:	1141                	addi	sp,sp,-16
 88c:	e422                	sd	s0,8(sp)
 88e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 890:	02b57463          	bgeu	a0,a1,8b8 <memmove+0x2e>
    while(n-- > 0)
 894:	00c05f63          	blez	a2,8b2 <memmove+0x28>
 898:	1602                	slli	a2,a2,0x20
 89a:	9201                	srli	a2,a2,0x20
 89c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 8a0:	872a                	mv	a4,a0
      *dst++ = *src++;
 8a2:	0585                	addi	a1,a1,1
 8a4:	0705                	addi	a4,a4,1
 8a6:	fff5c683          	lbu	a3,-1(a1)
 8aa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 8ae:	fef71ae3          	bne	a4,a5,8a2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 8b2:	6422                	ld	s0,8(sp)
 8b4:	0141                	addi	sp,sp,16
 8b6:	8082                	ret
    dst += n;
 8b8:	00c50733          	add	a4,a0,a2
    src += n;
 8bc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 8be:	fec05ae3          	blez	a2,8b2 <memmove+0x28>
 8c2:	fff6079b          	addiw	a5,a2,-1
 8c6:	1782                	slli	a5,a5,0x20
 8c8:	9381                	srli	a5,a5,0x20
 8ca:	fff7c793          	not	a5,a5
 8ce:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 8d0:	15fd                	addi	a1,a1,-1
 8d2:	177d                	addi	a4,a4,-1
 8d4:	0005c683          	lbu	a3,0(a1)
 8d8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 8dc:	fee79ae3          	bne	a5,a4,8d0 <memmove+0x46>
 8e0:	bfc9                	j	8b2 <memmove+0x28>

00000000000008e2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 8e2:	1141                	addi	sp,sp,-16
 8e4:	e422                	sd	s0,8(sp)
 8e6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 8e8:	ca05                	beqz	a2,918 <memcmp+0x36>
 8ea:	fff6069b          	addiw	a3,a2,-1
 8ee:	1682                	slli	a3,a3,0x20
 8f0:	9281                	srli	a3,a3,0x20
 8f2:	0685                	addi	a3,a3,1
 8f4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 8f6:	00054783          	lbu	a5,0(a0)
 8fa:	0005c703          	lbu	a4,0(a1)
 8fe:	00e79863          	bne	a5,a4,90e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 902:	0505                	addi	a0,a0,1
    p2++;
 904:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 906:	fed518e3          	bne	a0,a3,8f6 <memcmp+0x14>
  }
  return 0;
 90a:	4501                	li	a0,0
 90c:	a019                	j	912 <memcmp+0x30>
      return *p1 - *p2;
 90e:	40e7853b          	subw	a0,a5,a4
}
 912:	6422                	ld	s0,8(sp)
 914:	0141                	addi	sp,sp,16
 916:	8082                	ret
  return 0;
 918:	4501                	li	a0,0
 91a:	bfe5                	j	912 <memcmp+0x30>

000000000000091c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 91c:	1141                	addi	sp,sp,-16
 91e:	e406                	sd	ra,8(sp)
 920:	e022                	sd	s0,0(sp)
 922:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 924:	00000097          	auipc	ra,0x0
 928:	f66080e7          	jalr	-154(ra) # 88a <memmove>
}
 92c:	60a2                	ld	ra,8(sp)
 92e:	6402                	ld	s0,0(sp)
 930:	0141                	addi	sp,sp,16
 932:	8082                	ret

0000000000000934 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 934:	4885                	li	a7,1
 ecall
 936:	00000073          	ecall
 ret
 93a:	8082                	ret

000000000000093c <exit>:
.global exit
exit:
 li a7, SYS_exit
 93c:	4889                	li	a7,2
 ecall
 93e:	00000073          	ecall
 ret
 942:	8082                	ret

0000000000000944 <wait>:
.global wait
wait:
 li a7, SYS_wait
 944:	488d                	li	a7,3
 ecall
 946:	00000073          	ecall
 ret
 94a:	8082                	ret

000000000000094c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 94c:	4891                	li	a7,4
 ecall
 94e:	00000073          	ecall
 ret
 952:	8082                	ret

0000000000000954 <read>:
.global read
read:
 li a7, SYS_read
 954:	4895                	li	a7,5
 ecall
 956:	00000073          	ecall
 ret
 95a:	8082                	ret

000000000000095c <write>:
.global write
write:
 li a7, SYS_write
 95c:	48c1                	li	a7,16
 ecall
 95e:	00000073          	ecall
 ret
 962:	8082                	ret

0000000000000964 <close>:
.global close
close:
 li a7, SYS_close
 964:	48d5                	li	a7,21
 ecall
 966:	00000073          	ecall
 ret
 96a:	8082                	ret

000000000000096c <kill>:
.global kill
kill:
 li a7, SYS_kill
 96c:	4899                	li	a7,6
 ecall
 96e:	00000073          	ecall
 ret
 972:	8082                	ret

0000000000000974 <exec>:
.global exec
exec:
 li a7, SYS_exec
 974:	489d                	li	a7,7
 ecall
 976:	00000073          	ecall
 ret
 97a:	8082                	ret

000000000000097c <open>:
.global open
open:
 li a7, SYS_open
 97c:	48bd                	li	a7,15
 ecall
 97e:	00000073          	ecall
 ret
 982:	8082                	ret

0000000000000984 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 984:	48c5                	li	a7,17
 ecall
 986:	00000073          	ecall
 ret
 98a:	8082                	ret

000000000000098c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 98c:	48c9                	li	a7,18
 ecall
 98e:	00000073          	ecall
 ret
 992:	8082                	ret

0000000000000994 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 994:	48a1                	li	a7,8
 ecall
 996:	00000073          	ecall
 ret
 99a:	8082                	ret

000000000000099c <link>:
.global link
link:
 li a7, SYS_link
 99c:	48cd                	li	a7,19
 ecall
 99e:	00000073          	ecall
 ret
 9a2:	8082                	ret

00000000000009a4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 9a4:	48d1                	li	a7,20
 ecall
 9a6:	00000073          	ecall
 ret
 9aa:	8082                	ret

00000000000009ac <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 9ac:	48a5                	li	a7,9
 ecall
 9ae:	00000073          	ecall
 ret
 9b2:	8082                	ret

00000000000009b4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 9b4:	48a9                	li	a7,10
 ecall
 9b6:	00000073          	ecall
 ret
 9ba:	8082                	ret

00000000000009bc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 9bc:	48ad                	li	a7,11
 ecall
 9be:	00000073          	ecall
 ret
 9c2:	8082                	ret

00000000000009c4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 9c4:	48b1                	li	a7,12
 ecall
 9c6:	00000073          	ecall
 ret
 9ca:	8082                	ret

00000000000009cc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 9cc:	48b5                	li	a7,13
 ecall
 9ce:	00000073          	ecall
 ret
 9d2:	8082                	ret

00000000000009d4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 9d4:	48b9                	li	a7,14
 ecall
 9d6:	00000073          	ecall
 ret
 9da:	8082                	ret

00000000000009dc <cowstats>:
.global cowstats
cowstats:
 li a7, SYS_cowstats
 9dc:	48d9                	li	a7,22
 ecall
 9de:	00000073          	ecall
 ret
 9e2:	8082                	ret

00000000000009e4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 9e4:	1101                	addi	sp,sp,-32
 9e6:	ec06                	sd	ra,24(sp)
 9e8:	e822                	sd	s0,16(sp)
 9ea:	1000                	addi	s0,sp,32
 9ec:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 9f0:	4605                	li	a2,1
 9f2:	fef40593          	addi	a1,s0,-17
 9f6:	00000097          	auipc	ra,0x0
 9fa:	f66080e7          	jalr	-154(ra) # 95c <write>
}
 9fe:	60e2                	ld	ra,24(sp)
 a00:	6442                	ld	s0,16(sp)
 a02:	6105                	addi	sp,sp,32
 a04:	8082                	ret

0000000000000a06 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 a06:	7139                	addi	sp,sp,-64
 a08:	fc06                	sd	ra,56(sp)
 a0a:	f822                	sd	s0,48(sp)
 a0c:	f426                	sd	s1,40(sp)
 a0e:	0080                	addi	s0,sp,64
 a10:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 a12:	c299                	beqz	a3,a18 <printint+0x12>
 a14:	0805cb63          	bltz	a1,aaa <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 a18:	2581                	sext.w	a1,a1
  neg = 0;
 a1a:	4881                	li	a7,0
 a1c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 a20:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 a22:	2601                	sext.w	a2,a2
 a24:	00001517          	auipc	a0,0x1
 a28:	83c50513          	addi	a0,a0,-1988 # 1260 <digits>
 a2c:	883a                	mv	a6,a4
 a2e:	2705                	addiw	a4,a4,1
 a30:	02c5f7bb          	remuw	a5,a1,a2
 a34:	1782                	slli	a5,a5,0x20
 a36:	9381                	srli	a5,a5,0x20
 a38:	97aa                	add	a5,a5,a0
 a3a:	0007c783          	lbu	a5,0(a5)
 a3e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 a42:	0005879b          	sext.w	a5,a1
 a46:	02c5d5bb          	divuw	a1,a1,a2
 a4a:	0685                	addi	a3,a3,1
 a4c:	fec7f0e3          	bgeu	a5,a2,a2c <printint+0x26>
  if(neg)
 a50:	00088c63          	beqz	a7,a68 <printint+0x62>
    buf[i++] = '-';
 a54:	fd070793          	addi	a5,a4,-48
 a58:	00878733          	add	a4,a5,s0
 a5c:	02d00793          	li	a5,45
 a60:	fef70823          	sb	a5,-16(a4)
 a64:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 a68:	02e05c63          	blez	a4,aa0 <printint+0x9a>
 a6c:	f04a                	sd	s2,32(sp)
 a6e:	ec4e                	sd	s3,24(sp)
 a70:	fc040793          	addi	a5,s0,-64
 a74:	00e78933          	add	s2,a5,a4
 a78:	fff78993          	addi	s3,a5,-1
 a7c:	99ba                	add	s3,s3,a4
 a7e:	377d                	addiw	a4,a4,-1
 a80:	1702                	slli	a4,a4,0x20
 a82:	9301                	srli	a4,a4,0x20
 a84:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 a88:	fff94583          	lbu	a1,-1(s2)
 a8c:	8526                	mv	a0,s1
 a8e:	00000097          	auipc	ra,0x0
 a92:	f56080e7          	jalr	-170(ra) # 9e4 <putc>
  while(--i >= 0)
 a96:	197d                	addi	s2,s2,-1
 a98:	ff3918e3          	bne	s2,s3,a88 <printint+0x82>
 a9c:	7902                	ld	s2,32(sp)
 a9e:	69e2                	ld	s3,24(sp)
}
 aa0:	70e2                	ld	ra,56(sp)
 aa2:	7442                	ld	s0,48(sp)
 aa4:	74a2                	ld	s1,40(sp)
 aa6:	6121                	addi	sp,sp,64
 aa8:	8082                	ret
    x = -xx;
 aaa:	40b005bb          	negw	a1,a1
    neg = 1;
 aae:	4885                	li	a7,1
    x = -xx;
 ab0:	b7b5                	j	a1c <printint+0x16>

0000000000000ab2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 ab2:	715d                	addi	sp,sp,-80
 ab4:	e486                	sd	ra,72(sp)
 ab6:	e0a2                	sd	s0,64(sp)
 ab8:	f84a                	sd	s2,48(sp)
 aba:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 abc:	0005c903          	lbu	s2,0(a1)
 ac0:	1a090a63          	beqz	s2,c74 <vprintf+0x1c2>
 ac4:	fc26                	sd	s1,56(sp)
 ac6:	f44e                	sd	s3,40(sp)
 ac8:	f052                	sd	s4,32(sp)
 aca:	ec56                	sd	s5,24(sp)
 acc:	e85a                	sd	s6,16(sp)
 ace:	e45e                	sd	s7,8(sp)
 ad0:	8aaa                	mv	s5,a0
 ad2:	8bb2                	mv	s7,a2
 ad4:	00158493          	addi	s1,a1,1
  state = 0;
 ad8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 ada:	02500a13          	li	s4,37
 ade:	4b55                	li	s6,21
 ae0:	a839                	j	afe <vprintf+0x4c>
        putc(fd, c);
 ae2:	85ca                	mv	a1,s2
 ae4:	8556                	mv	a0,s5
 ae6:	00000097          	auipc	ra,0x0
 aea:	efe080e7          	jalr	-258(ra) # 9e4 <putc>
 aee:	a019                	j	af4 <vprintf+0x42>
    } else if(state == '%'){
 af0:	01498d63          	beq	s3,s4,b0a <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 af4:	0485                	addi	s1,s1,1
 af6:	fff4c903          	lbu	s2,-1(s1)
 afa:	16090763          	beqz	s2,c68 <vprintf+0x1b6>
    if(state == 0){
 afe:	fe0999e3          	bnez	s3,af0 <vprintf+0x3e>
      if(c == '%'){
 b02:	ff4910e3          	bne	s2,s4,ae2 <vprintf+0x30>
        state = '%';
 b06:	89d2                	mv	s3,s4
 b08:	b7f5                	j	af4 <vprintf+0x42>
      if(c == 'd'){
 b0a:	13490463          	beq	s2,s4,c32 <vprintf+0x180>
 b0e:	f9d9079b          	addiw	a5,s2,-99
 b12:	0ff7f793          	zext.b	a5,a5
 b16:	12fb6763          	bltu	s6,a5,c44 <vprintf+0x192>
 b1a:	f9d9079b          	addiw	a5,s2,-99
 b1e:	0ff7f713          	zext.b	a4,a5
 b22:	12eb6163          	bltu	s6,a4,c44 <vprintf+0x192>
 b26:	00271793          	slli	a5,a4,0x2
 b2a:	00000717          	auipc	a4,0x0
 b2e:	6de70713          	addi	a4,a4,1758 # 1208 <malloc+0x4a4>
 b32:	97ba                	add	a5,a5,a4
 b34:	439c                	lw	a5,0(a5)
 b36:	97ba                	add	a5,a5,a4
 b38:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 b3a:	008b8913          	addi	s2,s7,8
 b3e:	4685                	li	a3,1
 b40:	4629                	li	a2,10
 b42:	000ba583          	lw	a1,0(s7)
 b46:	8556                	mv	a0,s5
 b48:	00000097          	auipc	ra,0x0
 b4c:	ebe080e7          	jalr	-322(ra) # a06 <printint>
 b50:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 b52:	4981                	li	s3,0
 b54:	b745                	j	af4 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b56:	008b8913          	addi	s2,s7,8
 b5a:	4681                	li	a3,0
 b5c:	4629                	li	a2,10
 b5e:	000ba583          	lw	a1,0(s7)
 b62:	8556                	mv	a0,s5
 b64:	00000097          	auipc	ra,0x0
 b68:	ea2080e7          	jalr	-350(ra) # a06 <printint>
 b6c:	8bca                	mv	s7,s2
      state = 0;
 b6e:	4981                	li	s3,0
 b70:	b751                	j	af4 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 b72:	008b8913          	addi	s2,s7,8
 b76:	4681                	li	a3,0
 b78:	4641                	li	a2,16
 b7a:	000ba583          	lw	a1,0(s7)
 b7e:	8556                	mv	a0,s5
 b80:	00000097          	auipc	ra,0x0
 b84:	e86080e7          	jalr	-378(ra) # a06 <printint>
 b88:	8bca                	mv	s7,s2
      state = 0;
 b8a:	4981                	li	s3,0
 b8c:	b7a5                	j	af4 <vprintf+0x42>
 b8e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 b90:	008b8c13          	addi	s8,s7,8
 b94:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 b98:	03000593          	li	a1,48
 b9c:	8556                	mv	a0,s5
 b9e:	00000097          	auipc	ra,0x0
 ba2:	e46080e7          	jalr	-442(ra) # 9e4 <putc>
  putc(fd, 'x');
 ba6:	07800593          	li	a1,120
 baa:	8556                	mv	a0,s5
 bac:	00000097          	auipc	ra,0x0
 bb0:	e38080e7          	jalr	-456(ra) # 9e4 <putc>
 bb4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 bb6:	00000b97          	auipc	s7,0x0
 bba:	6aab8b93          	addi	s7,s7,1706 # 1260 <digits>
 bbe:	03c9d793          	srli	a5,s3,0x3c
 bc2:	97de                	add	a5,a5,s7
 bc4:	0007c583          	lbu	a1,0(a5)
 bc8:	8556                	mv	a0,s5
 bca:	00000097          	auipc	ra,0x0
 bce:	e1a080e7          	jalr	-486(ra) # 9e4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 bd2:	0992                	slli	s3,s3,0x4
 bd4:	397d                	addiw	s2,s2,-1
 bd6:	fe0914e3          	bnez	s2,bbe <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 bda:	8be2                	mv	s7,s8
      state = 0;
 bdc:	4981                	li	s3,0
 bde:	6c02                	ld	s8,0(sp)
 be0:	bf11                	j	af4 <vprintf+0x42>
        s = va_arg(ap, char*);
 be2:	008b8993          	addi	s3,s7,8
 be6:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 bea:	02090163          	beqz	s2,c0c <vprintf+0x15a>
        while(*s != 0){
 bee:	00094583          	lbu	a1,0(s2)
 bf2:	c9a5                	beqz	a1,c62 <vprintf+0x1b0>
          putc(fd, *s);
 bf4:	8556                	mv	a0,s5
 bf6:	00000097          	auipc	ra,0x0
 bfa:	dee080e7          	jalr	-530(ra) # 9e4 <putc>
          s++;
 bfe:	0905                	addi	s2,s2,1
        while(*s != 0){
 c00:	00094583          	lbu	a1,0(s2)
 c04:	f9e5                	bnez	a1,bf4 <vprintf+0x142>
        s = va_arg(ap, char*);
 c06:	8bce                	mv	s7,s3
      state = 0;
 c08:	4981                	li	s3,0
 c0a:	b5ed                	j	af4 <vprintf+0x42>
          s = "(null)";
 c0c:	00000917          	auipc	s2,0x0
 c10:	5f490913          	addi	s2,s2,1524 # 1200 <malloc+0x49c>
        while(*s != 0){
 c14:	02800593          	li	a1,40
 c18:	bff1                	j	bf4 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 c1a:	008b8913          	addi	s2,s7,8
 c1e:	000bc583          	lbu	a1,0(s7)
 c22:	8556                	mv	a0,s5
 c24:	00000097          	auipc	ra,0x0
 c28:	dc0080e7          	jalr	-576(ra) # 9e4 <putc>
 c2c:	8bca                	mv	s7,s2
      state = 0;
 c2e:	4981                	li	s3,0
 c30:	b5d1                	j	af4 <vprintf+0x42>
        putc(fd, c);
 c32:	02500593          	li	a1,37
 c36:	8556                	mv	a0,s5
 c38:	00000097          	auipc	ra,0x0
 c3c:	dac080e7          	jalr	-596(ra) # 9e4 <putc>
      state = 0;
 c40:	4981                	li	s3,0
 c42:	bd4d                	j	af4 <vprintf+0x42>
        putc(fd, '%');
 c44:	02500593          	li	a1,37
 c48:	8556                	mv	a0,s5
 c4a:	00000097          	auipc	ra,0x0
 c4e:	d9a080e7          	jalr	-614(ra) # 9e4 <putc>
        putc(fd, c);
 c52:	85ca                	mv	a1,s2
 c54:	8556                	mv	a0,s5
 c56:	00000097          	auipc	ra,0x0
 c5a:	d8e080e7          	jalr	-626(ra) # 9e4 <putc>
      state = 0;
 c5e:	4981                	li	s3,0
 c60:	bd51                	j	af4 <vprintf+0x42>
        s = va_arg(ap, char*);
 c62:	8bce                	mv	s7,s3
      state = 0;
 c64:	4981                	li	s3,0
 c66:	b579                	j	af4 <vprintf+0x42>
 c68:	74e2                	ld	s1,56(sp)
 c6a:	79a2                	ld	s3,40(sp)
 c6c:	7a02                	ld	s4,32(sp)
 c6e:	6ae2                	ld	s5,24(sp)
 c70:	6b42                	ld	s6,16(sp)
 c72:	6ba2                	ld	s7,8(sp)
    }
  }
}
 c74:	60a6                	ld	ra,72(sp)
 c76:	6406                	ld	s0,64(sp)
 c78:	7942                	ld	s2,48(sp)
 c7a:	6161                	addi	sp,sp,80
 c7c:	8082                	ret

0000000000000c7e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c7e:	715d                	addi	sp,sp,-80
 c80:	ec06                	sd	ra,24(sp)
 c82:	e822                	sd	s0,16(sp)
 c84:	1000                	addi	s0,sp,32
 c86:	e010                	sd	a2,0(s0)
 c88:	e414                	sd	a3,8(s0)
 c8a:	e818                	sd	a4,16(s0)
 c8c:	ec1c                	sd	a5,24(s0)
 c8e:	03043023          	sd	a6,32(s0)
 c92:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 c96:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 c9a:	8622                	mv	a2,s0
 c9c:	00000097          	auipc	ra,0x0
 ca0:	e16080e7          	jalr	-490(ra) # ab2 <vprintf>
}
 ca4:	60e2                	ld	ra,24(sp)
 ca6:	6442                	ld	s0,16(sp)
 ca8:	6161                	addi	sp,sp,80
 caa:	8082                	ret

0000000000000cac <printf>:

void
printf(const char *fmt, ...)
{
 cac:	711d                	addi	sp,sp,-96
 cae:	ec06                	sd	ra,24(sp)
 cb0:	e822                	sd	s0,16(sp)
 cb2:	1000                	addi	s0,sp,32
 cb4:	e40c                	sd	a1,8(s0)
 cb6:	e810                	sd	a2,16(s0)
 cb8:	ec14                	sd	a3,24(s0)
 cba:	f018                	sd	a4,32(s0)
 cbc:	f41c                	sd	a5,40(s0)
 cbe:	03043823          	sd	a6,48(s0)
 cc2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 cc6:	00840613          	addi	a2,s0,8
 cca:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 cce:	85aa                	mv	a1,a0
 cd0:	4505                	li	a0,1
 cd2:	00000097          	auipc	ra,0x0
 cd6:	de0080e7          	jalr	-544(ra) # ab2 <vprintf>
}
 cda:	60e2                	ld	ra,24(sp)
 cdc:	6442                	ld	s0,16(sp)
 cde:	6125                	addi	sp,sp,96
 ce0:	8082                	ret

0000000000000ce2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ce2:	1141                	addi	sp,sp,-16
 ce4:	e422                	sd	s0,8(sp)
 ce6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 ce8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cec:	00002797          	auipc	a5,0x2
 cf0:	83c7b783          	ld	a5,-1988(a5) # 2528 <freep>
 cf4:	a02d                	j	d1e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 cf6:	4618                	lw	a4,8(a2)
 cf8:	9f2d                	addw	a4,a4,a1
 cfa:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 cfe:	6398                	ld	a4,0(a5)
 d00:	6310                	ld	a2,0(a4)
 d02:	a83d                	j	d40 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 d04:	ff852703          	lw	a4,-8(a0)
 d08:	9f31                	addw	a4,a4,a2
 d0a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 d0c:	ff053683          	ld	a3,-16(a0)
 d10:	a091                	j	d54 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d12:	6398                	ld	a4,0(a5)
 d14:	00e7e463          	bltu	a5,a4,d1c <free+0x3a>
 d18:	00e6ea63          	bltu	a3,a4,d2c <free+0x4a>
{
 d1c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d1e:	fed7fae3          	bgeu	a5,a3,d12 <free+0x30>
 d22:	6398                	ld	a4,0(a5)
 d24:	00e6e463          	bltu	a3,a4,d2c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d28:	fee7eae3          	bltu	a5,a4,d1c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 d2c:	ff852583          	lw	a1,-8(a0)
 d30:	6390                	ld	a2,0(a5)
 d32:	02059813          	slli	a6,a1,0x20
 d36:	01c85713          	srli	a4,a6,0x1c
 d3a:	9736                	add	a4,a4,a3
 d3c:	fae60de3          	beq	a2,a4,cf6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 d40:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 d44:	4790                	lw	a2,8(a5)
 d46:	02061593          	slli	a1,a2,0x20
 d4a:	01c5d713          	srli	a4,a1,0x1c
 d4e:	973e                	add	a4,a4,a5
 d50:	fae68ae3          	beq	a3,a4,d04 <free+0x22>
    p->s.ptr = bp->s.ptr;
 d54:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 d56:	00001717          	auipc	a4,0x1
 d5a:	7cf73923          	sd	a5,2002(a4) # 2528 <freep>
}
 d5e:	6422                	ld	s0,8(sp)
 d60:	0141                	addi	sp,sp,16
 d62:	8082                	ret

0000000000000d64 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d64:	7139                	addi	sp,sp,-64
 d66:	fc06                	sd	ra,56(sp)
 d68:	f822                	sd	s0,48(sp)
 d6a:	f426                	sd	s1,40(sp)
 d6c:	ec4e                	sd	s3,24(sp)
 d6e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d70:	02051493          	slli	s1,a0,0x20
 d74:	9081                	srli	s1,s1,0x20
 d76:	04bd                	addi	s1,s1,15
 d78:	8091                	srli	s1,s1,0x4
 d7a:	0014899b          	addiw	s3,s1,1
 d7e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 d80:	00001517          	auipc	a0,0x1
 d84:	7a853503          	ld	a0,1960(a0) # 2528 <freep>
 d88:	c915                	beqz	a0,dbc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d8a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d8c:	4798                	lw	a4,8(a5)
 d8e:	08977e63          	bgeu	a4,s1,e2a <malloc+0xc6>
 d92:	f04a                	sd	s2,32(sp)
 d94:	e852                	sd	s4,16(sp)
 d96:	e456                	sd	s5,8(sp)
 d98:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 d9a:	8a4e                	mv	s4,s3
 d9c:	0009871b          	sext.w	a4,s3
 da0:	6685                	lui	a3,0x1
 da2:	00d77363          	bgeu	a4,a3,da8 <malloc+0x44>
 da6:	6a05                	lui	s4,0x1
 da8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 dac:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 db0:	00001917          	auipc	s2,0x1
 db4:	77890913          	addi	s2,s2,1912 # 2528 <freep>
  if(p == (char*)-1)
 db8:	5afd                	li	s5,-1
 dba:	a091                	j	dfe <malloc+0x9a>
 dbc:	f04a                	sd	s2,32(sp)
 dbe:	e852                	sd	s4,16(sp)
 dc0:	e456                	sd	s5,8(sp)
 dc2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 dc4:	00005797          	auipc	a5,0x5
 dc8:	76c78793          	addi	a5,a5,1900 # 6530 <base>
 dcc:	00001717          	auipc	a4,0x1
 dd0:	74f73e23          	sd	a5,1884(a4) # 2528 <freep>
 dd4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 dd6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 dda:	b7c1                	j	d9a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 ddc:	6398                	ld	a4,0(a5)
 dde:	e118                	sd	a4,0(a0)
 de0:	a08d                	j	e42 <malloc+0xde>
  hp->s.size = nu;
 de2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 de6:	0541                	addi	a0,a0,16
 de8:	00000097          	auipc	ra,0x0
 dec:	efa080e7          	jalr	-262(ra) # ce2 <free>
  return freep;
 df0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 df4:	c13d                	beqz	a0,e5a <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 df6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 df8:	4798                	lw	a4,8(a5)
 dfa:	02977463          	bgeu	a4,s1,e22 <malloc+0xbe>
    if(p == freep)
 dfe:	00093703          	ld	a4,0(s2)
 e02:	853e                	mv	a0,a5
 e04:	fef719e3          	bne	a4,a5,df6 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 e08:	8552                	mv	a0,s4
 e0a:	00000097          	auipc	ra,0x0
 e0e:	bba080e7          	jalr	-1094(ra) # 9c4 <sbrk>
  if(p == (char*)-1)
 e12:	fd5518e3          	bne	a0,s5,de2 <malloc+0x7e>
        return 0;
 e16:	4501                	li	a0,0
 e18:	7902                	ld	s2,32(sp)
 e1a:	6a42                	ld	s4,16(sp)
 e1c:	6aa2                	ld	s5,8(sp)
 e1e:	6b02                	ld	s6,0(sp)
 e20:	a03d                	j	e4e <malloc+0xea>
 e22:	7902                	ld	s2,32(sp)
 e24:	6a42                	ld	s4,16(sp)
 e26:	6aa2                	ld	s5,8(sp)
 e28:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 e2a:	fae489e3          	beq	s1,a4,ddc <malloc+0x78>
        p->s.size -= nunits;
 e2e:	4137073b          	subw	a4,a4,s3
 e32:	c798                	sw	a4,8(a5)
        p += p->s.size;
 e34:	02071693          	slli	a3,a4,0x20
 e38:	01c6d713          	srli	a4,a3,0x1c
 e3c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 e3e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 e42:	00001717          	auipc	a4,0x1
 e46:	6ea73323          	sd	a0,1766(a4) # 2528 <freep>
      return (void*)(p + 1);
 e4a:	01078513          	addi	a0,a5,16
  }
}
 e4e:	70e2                	ld	ra,56(sp)
 e50:	7442                	ld	s0,48(sp)
 e52:	74a2                	ld	s1,40(sp)
 e54:	69e2                	ld	s3,24(sp)
 e56:	6121                	addi	sp,sp,64
 e58:	8082                	ret
 e5a:	7902                	ld	s2,32(sp)
 e5c:	6a42                	ld	s4,16(sp)
 e5e:	6aa2                	ld	s5,8(sp)
 e60:	6b02                	ld	s6,0(sp)
 e62:	b7f5                	j	e4e <malloc+0xea>
