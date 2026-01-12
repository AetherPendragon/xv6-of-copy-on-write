
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	c5c080e7          	jalr	-932(ra) # 5c6c <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	c4a080e7          	jalr	-950(ra) # 5c6c <open>
    if(fd >= 0){
      2a:	55fd                	li	a1,-1
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	12250513          	addi	a0,a0,290 # 6160 <malloc+0x10c>
      46:	00006097          	auipc	ra,0x6
      4a:	f56080e7          	jalr	-170(ra) # 5f9c <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	bdc080e7          	jalr	-1060(ra) # 5c2c <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	0000c797          	auipc	a5,0xc
      5c:	8b078793          	addi	a5,a5,-1872 # b908 <uninit>
      60:	0000e697          	auipc	a3,0xe
      64:	fb868693          	addi	a3,a3,-72 # e018 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	10050513          	addi	a0,a0,256 # 6180 <malloc+0x12c>
      88:	00006097          	auipc	ra,0x6
      8c:	f14080e7          	jalr	-236(ra) # 5f9c <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	b9a080e7          	jalr	-1126(ra) # 5c2c <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	0f050513          	addi	a0,a0,240 # 6198 <malloc+0x144>
      b0:	00006097          	auipc	ra,0x6
      b4:	bbc080e7          	jalr	-1092(ra) # 5c6c <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	b98080e7          	jalr	-1128(ra) # 5c54 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	0f250513          	addi	a0,a0,242 # 61b8 <malloc+0x164>
      ce:	00006097          	auipc	ra,0x6
      d2:	b9e080e7          	jalr	-1122(ra) # 5c6c <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	0ba50513          	addi	a0,a0,186 # 61a0 <malloc+0x14c>
      ee:	00006097          	auipc	ra,0x6
      f2:	eae080e7          	jalr	-338(ra) # 5f9c <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	b34080e7          	jalr	-1228(ra) # 5c2c <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	0c650513          	addi	a0,a0,198 # 61c8 <malloc+0x174>
     10a:	00006097          	auipc	ra,0x6
     10e:	e92080e7          	jalr	-366(ra) # 5f9c <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	b18080e7          	jalr	-1256(ra) # 5c2c <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	0c450513          	addi	a0,a0,196 # 61f0 <malloc+0x19c>
     134:	00006097          	auipc	ra,0x6
     138:	b48080e7          	jalr	-1208(ra) # 5c7c <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	0b050513          	addi	a0,a0,176 # 61f0 <malloc+0x19c>
     148:	00006097          	auipc	ra,0x6
     14c:	b24080e7          	jalr	-1244(ra) # 5c6c <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	0ac58593          	addi	a1,a1,172 # 6200 <malloc+0x1ac>
     15c:	00006097          	auipc	ra,0x6
     160:	af0080e7          	jalr	-1296(ra) # 5c4c <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	08850513          	addi	a0,a0,136 # 61f0 <malloc+0x19c>
     170:	00006097          	auipc	ra,0x6
     174:	afc080e7          	jalr	-1284(ra) # 5c6c <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	08c58593          	addi	a1,a1,140 # 6208 <malloc+0x1b4>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	ac6080e7          	jalr	-1338(ra) # 5c4c <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	05c50513          	addi	a0,a0,92 # 61f0 <malloc+0x19c>
     19c:	00006097          	auipc	ra,0x6
     1a0:	ae0080e7          	jalr	-1312(ra) # 5c7c <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	aae080e7          	jalr	-1362(ra) # 5c54 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	aa4080e7          	jalr	-1372(ra) # 5c54 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	04650513          	addi	a0,a0,70 # 6210 <malloc+0x1bc>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	dca080e7          	jalr	-566(ra) # 5f9c <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	a50080e7          	jalr	-1456(ra) # 5c2c <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	a5c080e7          	jalr	-1444(ra) # 5c6c <open>
    close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	a3c080e7          	jalr	-1476(ra) # 5c54 <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	a36080e7          	jalr	-1482(ra) # 5c7c <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	fbc50513          	addi	a0,a0,-68 # 6238 <malloc+0x1e4>
     284:	00006097          	auipc	ra,0x6
     288:	9f8080e7          	jalr	-1544(ra) # 5c7c <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	fa8a8a93          	addi	s5,s5,-88 # 6238 <malloc+0x1e4>
      int cc = write(fd, buf, sz);
     298:	0000ea17          	auipc	s4,0xe
     29c:	d80a0a13          	addi	s4,s4,-640 # e018 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <fourteen+0x155>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	9c0080e7          	jalr	-1600(ra) # 5c6c <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	98e080e7          	jalr	-1650(ra) # 5c4c <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	97a080e7          	jalr	-1670(ra) # 5c4c <write>
      if(cc != sz){
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	974080e7          	jalr	-1676(ra) # 5c54 <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	992080e7          	jalr	-1646(ra) # 5c7c <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	f3650513          	addi	a0,a0,-202 # 6248 <malloc+0x1f4>
     31a:	00006097          	auipc	ra,0x6
     31e:	c82080e7          	jalr	-894(ra) # 5f9c <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00006097          	auipc	ra,0x6
     328:	908080e7          	jalr	-1784(ra) # 5c2c <exit>
      if(cc != sz){
     32c:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	f3450513          	addi	a0,a0,-204 # 6268 <malloc+0x214>
     33c:	00006097          	auipc	ra,0x6
     340:	c60080e7          	jalr	-928(ra) # 5f9c <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00006097          	auipc	ra,0x6
     34a:	8e6080e7          	jalr	-1818(ra) # 5c2c <exit>

000000000000034e <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     34e:	7179                	addi	sp,sp,-48
     350:	f406                	sd	ra,40(sp)
     352:	f022                	sd	s0,32(sp)
     354:	ec26                	sd	s1,24(sp)
     356:	e84a                	sd	s2,16(sp)
     358:	e44e                	sd	s3,8(sp)
     35a:	e052                	sd	s4,0(sp)
     35c:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     35e:	00006517          	auipc	a0,0x6
     362:	f2250513          	addi	a0,a0,-222 # 6280 <malloc+0x22c>
     366:	00006097          	auipc	ra,0x6
     36a:	916080e7          	jalr	-1770(ra) # 5c7c <unlink>
     36e:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     372:	00006997          	auipc	s3,0x6
     376:	f0e98993          	addi	s3,s3,-242 # 6280 <malloc+0x22c>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     37a:	5a7d                	li	s4,-1
     37c:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     380:	20100593          	li	a1,513
     384:	854e                	mv	a0,s3
     386:	00006097          	auipc	ra,0x6
     38a:	8e6080e7          	jalr	-1818(ra) # 5c6c <open>
     38e:	84aa                	mv	s1,a0
    if(fd < 0){
     390:	06054b63          	bltz	a0,406 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
     394:	4605                	li	a2,1
     396:	85d2                	mv	a1,s4
     398:	00006097          	auipc	ra,0x6
     39c:	8b4080e7          	jalr	-1868(ra) # 5c4c <write>
    close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00006097          	auipc	ra,0x6
     3a6:	8b2080e7          	jalr	-1870(ra) # 5c54 <close>
    unlink("junk");
     3aa:	854e                	mv	a0,s3
     3ac:	00006097          	auipc	ra,0x6
     3b0:	8d0080e7          	jalr	-1840(ra) # 5c7c <unlink>
  for(int i = 0; i < assumed_free; i++){
     3b4:	397d                	addiw	s2,s2,-1
     3b6:	fc0915e3          	bnez	s2,380 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3ba:	20100593          	li	a1,513
     3be:	00006517          	auipc	a0,0x6
     3c2:	ec250513          	addi	a0,a0,-318 # 6280 <malloc+0x22c>
     3c6:	00006097          	auipc	ra,0x6
     3ca:	8a6080e7          	jalr	-1882(ra) # 5c6c <open>
     3ce:	84aa                	mv	s1,a0
  if(fd < 0){
     3d0:	04054863          	bltz	a0,420 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     3d4:	4605                	li	a2,1
     3d6:	00006597          	auipc	a1,0x6
     3da:	e3258593          	addi	a1,a1,-462 # 6208 <malloc+0x1b4>
     3de:	00006097          	auipc	ra,0x6
     3e2:	86e080e7          	jalr	-1938(ra) # 5c4c <write>
     3e6:	4785                	li	a5,1
     3e8:	04f50963          	beq	a0,a5,43a <badwrite+0xec>
    printf("write failed\n");
     3ec:	00006517          	auipc	a0,0x6
     3f0:	eb450513          	addi	a0,a0,-332 # 62a0 <malloc+0x24c>
     3f4:	00006097          	auipc	ra,0x6
     3f8:	ba8080e7          	jalr	-1112(ra) # 5f9c <printf>
    exit(1);
     3fc:	4505                	li	a0,1
     3fe:	00006097          	auipc	ra,0x6
     402:	82e080e7          	jalr	-2002(ra) # 5c2c <exit>
      printf("open junk failed\n");
     406:	00006517          	auipc	a0,0x6
     40a:	e8250513          	addi	a0,a0,-382 # 6288 <malloc+0x234>
     40e:	00006097          	auipc	ra,0x6
     412:	b8e080e7          	jalr	-1138(ra) # 5f9c <printf>
      exit(1);
     416:	4505                	li	a0,1
     418:	00006097          	auipc	ra,0x6
     41c:	814080e7          	jalr	-2028(ra) # 5c2c <exit>
    printf("open junk failed\n");
     420:	00006517          	auipc	a0,0x6
     424:	e6850513          	addi	a0,a0,-408 # 6288 <malloc+0x234>
     428:	00006097          	auipc	ra,0x6
     42c:	b74080e7          	jalr	-1164(ra) # 5f9c <printf>
    exit(1);
     430:	4505                	li	a0,1
     432:	00005097          	auipc	ra,0x5
     436:	7fa080e7          	jalr	2042(ra) # 5c2c <exit>
  }
  close(fd);
     43a:	8526                	mv	a0,s1
     43c:	00006097          	auipc	ra,0x6
     440:	818080e7          	jalr	-2024(ra) # 5c54 <close>
  unlink("junk");
     444:	00006517          	auipc	a0,0x6
     448:	e3c50513          	addi	a0,a0,-452 # 6280 <malloc+0x22c>
     44c:	00006097          	auipc	ra,0x6
     450:	830080e7          	jalr	-2000(ra) # 5c7c <unlink>

  exit(0);
     454:	4501                	li	a0,0
     456:	00005097          	auipc	ra,0x5
     45a:	7d6080e7          	jalr	2006(ra) # 5c2c <exit>

000000000000045e <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     45e:	715d                	addi	sp,sp,-80
     460:	e486                	sd	ra,72(sp)
     462:	e0a2                	sd	s0,64(sp)
     464:	fc26                	sd	s1,56(sp)
     466:	f84a                	sd	s2,48(sp)
     468:	f44e                	sd	s3,40(sp)
     46a:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     46c:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     46e:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     472:	40000993          	li	s3,1024
    name[0] = 'z';
     476:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     47a:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     47e:	41f4d71b          	sraiw	a4,s1,0x1f
     482:	01b7571b          	srliw	a4,a4,0x1b
     486:	009707bb          	addw	a5,a4,s1
     48a:	4057d69b          	sraiw	a3,a5,0x5
     48e:	0306869b          	addiw	a3,a3,48
     492:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     496:	8bfd                	andi	a5,a5,31
     498:	9f99                	subw	a5,a5,a4
     49a:	0307879b          	addiw	a5,a5,48
     49e:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4a2:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4a6:	fb040513          	addi	a0,s0,-80
     4aa:	00005097          	auipc	ra,0x5
     4ae:	7d2080e7          	jalr	2002(ra) # 5c7c <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4b2:	60200593          	li	a1,1538
     4b6:	fb040513          	addi	a0,s0,-80
     4ba:	00005097          	auipc	ra,0x5
     4be:	7b2080e7          	jalr	1970(ra) # 5c6c <open>
    if(fd < 0){
     4c2:	00054963          	bltz	a0,4d4 <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4c6:	00005097          	auipc	ra,0x5
     4ca:	78e080e7          	jalr	1934(ra) # 5c54 <close>
  for(int i = 0; i < nzz; i++){
     4ce:	2485                	addiw	s1,s1,1
     4d0:	fb3493e3          	bne	s1,s3,476 <outofinodes+0x18>
     4d4:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     4d6:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     4da:	40000993          	li	s3,1024
    name[0] = 'z';
     4de:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4e2:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4e6:	41f4d71b          	sraiw	a4,s1,0x1f
     4ea:	01b7571b          	srliw	a4,a4,0x1b
     4ee:	009707bb          	addw	a5,a4,s1
     4f2:	4057d69b          	sraiw	a3,a5,0x5
     4f6:	0306869b          	addiw	a3,a3,48
     4fa:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     4fe:	8bfd                	andi	a5,a5,31
     500:	9f99                	subw	a5,a5,a4
     502:	0307879b          	addiw	a5,a5,48
     506:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     50a:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     50e:	fb040513          	addi	a0,s0,-80
     512:	00005097          	auipc	ra,0x5
     516:	76a080e7          	jalr	1898(ra) # 5c7c <unlink>
  for(int i = 0; i < nzz; i++){
     51a:	2485                	addiw	s1,s1,1
     51c:	fd3491e3          	bne	s1,s3,4de <outofinodes+0x80>
  }
}
     520:	60a6                	ld	ra,72(sp)
     522:	6406                	ld	s0,64(sp)
     524:	74e2                	ld	s1,56(sp)
     526:	7942                	ld	s2,48(sp)
     528:	79a2                	ld	s3,40(sp)
     52a:	6161                	addi	sp,sp,80
     52c:	8082                	ret

000000000000052e <copyin>:
{
     52e:	715d                	addi	sp,sp,-80
     530:	e486                	sd	ra,72(sp)
     532:	e0a2                	sd	s0,64(sp)
     534:	fc26                	sd	s1,56(sp)
     536:	f84a                	sd	s2,48(sp)
     538:	f44e                	sd	s3,40(sp)
     53a:	f052                	sd	s4,32(sp)
     53c:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     53e:	4785                	li	a5,1
     540:	07fe                	slli	a5,a5,0x1f
     542:	fcf43023          	sd	a5,-64(s0)
     546:	57fd                	li	a5,-1
     548:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     54c:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     550:	00006a17          	auipc	s4,0x6
     554:	d60a0a13          	addi	s4,s4,-672 # 62b0 <malloc+0x25c>
    uint64 addr = addrs[ai];
     558:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     55c:	20100593          	li	a1,513
     560:	8552                	mv	a0,s4
     562:	00005097          	auipc	ra,0x5
     566:	70a080e7          	jalr	1802(ra) # 5c6c <open>
     56a:	84aa                	mv	s1,a0
    if(fd < 0){
     56c:	08054863          	bltz	a0,5fc <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     570:	6609                	lui	a2,0x2
     572:	85ce                	mv	a1,s3
     574:	00005097          	auipc	ra,0x5
     578:	6d8080e7          	jalr	1752(ra) # 5c4c <write>
    if(n >= 0){
     57c:	08055d63          	bgez	a0,616 <copyin+0xe8>
    close(fd);
     580:	8526                	mv	a0,s1
     582:	00005097          	auipc	ra,0x5
     586:	6d2080e7          	jalr	1746(ra) # 5c54 <close>
    unlink("copyin1");
     58a:	8552                	mv	a0,s4
     58c:	00005097          	auipc	ra,0x5
     590:	6f0080e7          	jalr	1776(ra) # 5c7c <unlink>
    n = write(1, (char*)addr, 8192);
     594:	6609                	lui	a2,0x2
     596:	85ce                	mv	a1,s3
     598:	4505                	li	a0,1
     59a:	00005097          	auipc	ra,0x5
     59e:	6b2080e7          	jalr	1714(ra) # 5c4c <write>
    if(n > 0){
     5a2:	08a04963          	bgtz	a0,634 <copyin+0x106>
    if(pipe(fds) < 0){
     5a6:	fb840513          	addi	a0,s0,-72
     5aa:	00005097          	auipc	ra,0x5
     5ae:	692080e7          	jalr	1682(ra) # 5c3c <pipe>
     5b2:	0a054063          	bltz	a0,652 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     5b6:	6609                	lui	a2,0x2
     5b8:	85ce                	mv	a1,s3
     5ba:	fbc42503          	lw	a0,-68(s0)
     5be:	00005097          	auipc	ra,0x5
     5c2:	68e080e7          	jalr	1678(ra) # 5c4c <write>
    if(n > 0){
     5c6:	0aa04363          	bgtz	a0,66c <copyin+0x13e>
    close(fds[0]);
     5ca:	fb842503          	lw	a0,-72(s0)
     5ce:	00005097          	auipc	ra,0x5
     5d2:	686080e7          	jalr	1670(ra) # 5c54 <close>
    close(fds[1]);
     5d6:	fbc42503          	lw	a0,-68(s0)
     5da:	00005097          	auipc	ra,0x5
     5de:	67a080e7          	jalr	1658(ra) # 5c54 <close>
  for(int ai = 0; ai < 2; ai++){
     5e2:	0921                	addi	s2,s2,8
     5e4:	fd040793          	addi	a5,s0,-48
     5e8:	f6f918e3          	bne	s2,a5,558 <copyin+0x2a>
}
     5ec:	60a6                	ld	ra,72(sp)
     5ee:	6406                	ld	s0,64(sp)
     5f0:	74e2                	ld	s1,56(sp)
     5f2:	7942                	ld	s2,48(sp)
     5f4:	79a2                	ld	s3,40(sp)
     5f6:	7a02                	ld	s4,32(sp)
     5f8:	6161                	addi	sp,sp,80
     5fa:	8082                	ret
      printf("open(copyin1) failed\n");
     5fc:	00006517          	auipc	a0,0x6
     600:	cbc50513          	addi	a0,a0,-836 # 62b8 <malloc+0x264>
     604:	00006097          	auipc	ra,0x6
     608:	998080e7          	jalr	-1640(ra) # 5f9c <printf>
      exit(1);
     60c:	4505                	li	a0,1
     60e:	00005097          	auipc	ra,0x5
     612:	61e080e7          	jalr	1566(ra) # 5c2c <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     616:	862a                	mv	a2,a0
     618:	85ce                	mv	a1,s3
     61a:	00006517          	auipc	a0,0x6
     61e:	cb650513          	addi	a0,a0,-842 # 62d0 <malloc+0x27c>
     622:	00006097          	auipc	ra,0x6
     626:	97a080e7          	jalr	-1670(ra) # 5f9c <printf>
      exit(1);
     62a:	4505                	li	a0,1
     62c:	00005097          	auipc	ra,0x5
     630:	600080e7          	jalr	1536(ra) # 5c2c <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     634:	862a                	mv	a2,a0
     636:	85ce                	mv	a1,s3
     638:	00006517          	auipc	a0,0x6
     63c:	cc850513          	addi	a0,a0,-824 # 6300 <malloc+0x2ac>
     640:	00006097          	auipc	ra,0x6
     644:	95c080e7          	jalr	-1700(ra) # 5f9c <printf>
      exit(1);
     648:	4505                	li	a0,1
     64a:	00005097          	auipc	ra,0x5
     64e:	5e2080e7          	jalr	1506(ra) # 5c2c <exit>
      printf("pipe() failed\n");
     652:	00006517          	auipc	a0,0x6
     656:	cde50513          	addi	a0,a0,-802 # 6330 <malloc+0x2dc>
     65a:	00006097          	auipc	ra,0x6
     65e:	942080e7          	jalr	-1726(ra) # 5f9c <printf>
      exit(1);
     662:	4505                	li	a0,1
     664:	00005097          	auipc	ra,0x5
     668:	5c8080e7          	jalr	1480(ra) # 5c2c <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     66c:	862a                	mv	a2,a0
     66e:	85ce                	mv	a1,s3
     670:	00006517          	auipc	a0,0x6
     674:	cd050513          	addi	a0,a0,-816 # 6340 <malloc+0x2ec>
     678:	00006097          	auipc	ra,0x6
     67c:	924080e7          	jalr	-1756(ra) # 5f9c <printf>
      exit(1);
     680:	4505                	li	a0,1
     682:	00005097          	auipc	ra,0x5
     686:	5aa080e7          	jalr	1450(ra) # 5c2c <exit>

000000000000068a <copyout>:
{
     68a:	711d                	addi	sp,sp,-96
     68c:	ec86                	sd	ra,88(sp)
     68e:	e8a2                	sd	s0,80(sp)
     690:	e4a6                	sd	s1,72(sp)
     692:	e0ca                	sd	s2,64(sp)
     694:	fc4e                	sd	s3,56(sp)
     696:	f852                	sd	s4,48(sp)
     698:	f456                	sd	s5,40(sp)
     69a:	f05a                	sd	s6,32(sp)
     69c:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0LL, 0x80000000LL, 0xffffffffffffffff };
     69e:	fa043423          	sd	zero,-88(s0)
     6a2:	4785                	li	a5,1
     6a4:	07fe                	slli	a5,a5,0x1f
     6a6:	faf43823          	sd	a5,-80(s0)
  for(int ai = 0; ai < 2; ai++){
     6aa:	fa840913          	addi	s2,s0,-88
     6ae:	fb840b13          	addi	s6,s0,-72
    int fd = open("README", 0);
     6b2:	00006a17          	auipc	s4,0x6
     6b6:	cbea0a13          	addi	s4,s4,-834 # 6370 <malloc+0x31c>
    n = write(fds[1], "x", 1);
     6ba:	00006a97          	auipc	s5,0x6
     6be:	b4ea8a93          	addi	s5,s5,-1202 # 6208 <malloc+0x1b4>
    uint64 addr = addrs[ai];
     6c2:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     6c6:	4581                	li	a1,0
     6c8:	8552                	mv	a0,s4
     6ca:	00005097          	auipc	ra,0x5
     6ce:	5a2080e7          	jalr	1442(ra) # 5c6c <open>
     6d2:	84aa                	mv	s1,a0
    if(fd < 0){
     6d4:	08054563          	bltz	a0,75e <copyout+0xd4>
    int n = read(fd, (void*)addr, 8192);
     6d8:	6609                	lui	a2,0x2
     6da:	85ce                	mv	a1,s3
     6dc:	00005097          	auipc	ra,0x5
     6e0:	568080e7          	jalr	1384(ra) # 5c44 <read>
    if(n > 0){
     6e4:	08a04a63          	bgtz	a0,778 <copyout+0xee>
    close(fd);
     6e8:	8526                	mv	a0,s1
     6ea:	00005097          	auipc	ra,0x5
     6ee:	56a080e7          	jalr	1386(ra) # 5c54 <close>
    if(pipe(fds) < 0){
     6f2:	fa040513          	addi	a0,s0,-96
     6f6:	00005097          	auipc	ra,0x5
     6fa:	546080e7          	jalr	1350(ra) # 5c3c <pipe>
     6fe:	08054c63          	bltz	a0,796 <copyout+0x10c>
    n = write(fds[1], "x", 1);
     702:	4605                	li	a2,1
     704:	85d6                	mv	a1,s5
     706:	fa442503          	lw	a0,-92(s0)
     70a:	00005097          	auipc	ra,0x5
     70e:	542080e7          	jalr	1346(ra) # 5c4c <write>
    if(n != 1){
     712:	4785                	li	a5,1
     714:	08f51e63          	bne	a0,a5,7b0 <copyout+0x126>
    n = read(fds[0], (void*)addr, 8192);
     718:	6609                	lui	a2,0x2
     71a:	85ce                	mv	a1,s3
     71c:	fa042503          	lw	a0,-96(s0)
     720:	00005097          	auipc	ra,0x5
     724:	524080e7          	jalr	1316(ra) # 5c44 <read>
    if(n > 0){
     728:	0aa04163          	bgtz	a0,7ca <copyout+0x140>
    close(fds[0]);
     72c:	fa042503          	lw	a0,-96(s0)
     730:	00005097          	auipc	ra,0x5
     734:	524080e7          	jalr	1316(ra) # 5c54 <close>
    close(fds[1]);
     738:	fa442503          	lw	a0,-92(s0)
     73c:	00005097          	auipc	ra,0x5
     740:	518080e7          	jalr	1304(ra) # 5c54 <close>
  for(int ai = 0; ai < 2; ai++){
     744:	0921                	addi	s2,s2,8
     746:	f7691ee3          	bne	s2,s6,6c2 <copyout+0x38>
}
     74a:	60e6                	ld	ra,88(sp)
     74c:	6446                	ld	s0,80(sp)
     74e:	64a6                	ld	s1,72(sp)
     750:	6906                	ld	s2,64(sp)
     752:	79e2                	ld	s3,56(sp)
     754:	7a42                	ld	s4,48(sp)
     756:	7aa2                	ld	s5,40(sp)
     758:	7b02                	ld	s6,32(sp)
     75a:	6125                	addi	sp,sp,96
     75c:	8082                	ret
      printf("open(README) failed\n");
     75e:	00006517          	auipc	a0,0x6
     762:	c1a50513          	addi	a0,a0,-998 # 6378 <malloc+0x324>
     766:	00006097          	auipc	ra,0x6
     76a:	836080e7          	jalr	-1994(ra) # 5f9c <printf>
      exit(1);
     76e:	4505                	li	a0,1
     770:	00005097          	auipc	ra,0x5
     774:	4bc080e7          	jalr	1212(ra) # 5c2c <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     778:	862a                	mv	a2,a0
     77a:	85ce                	mv	a1,s3
     77c:	00006517          	auipc	a0,0x6
     780:	c1450513          	addi	a0,a0,-1004 # 6390 <malloc+0x33c>
     784:	00006097          	auipc	ra,0x6
     788:	818080e7          	jalr	-2024(ra) # 5f9c <printf>
      exit(1);
     78c:	4505                	li	a0,1
     78e:	00005097          	auipc	ra,0x5
     792:	49e080e7          	jalr	1182(ra) # 5c2c <exit>
      printf("pipe() failed\n");
     796:	00006517          	auipc	a0,0x6
     79a:	b9a50513          	addi	a0,a0,-1126 # 6330 <malloc+0x2dc>
     79e:	00005097          	auipc	ra,0x5
     7a2:	7fe080e7          	jalr	2046(ra) # 5f9c <printf>
      exit(1);
     7a6:	4505                	li	a0,1
     7a8:	00005097          	auipc	ra,0x5
     7ac:	484080e7          	jalr	1156(ra) # 5c2c <exit>
      printf("pipe write failed\n");
     7b0:	00006517          	auipc	a0,0x6
     7b4:	c1050513          	addi	a0,a0,-1008 # 63c0 <malloc+0x36c>
     7b8:	00005097          	auipc	ra,0x5
     7bc:	7e4080e7          	jalr	2020(ra) # 5f9c <printf>
      exit(1);
     7c0:	4505                	li	a0,1
     7c2:	00005097          	auipc	ra,0x5
     7c6:	46a080e7          	jalr	1130(ra) # 5c2c <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7ca:	862a                	mv	a2,a0
     7cc:	85ce                	mv	a1,s3
     7ce:	00006517          	auipc	a0,0x6
     7d2:	c0a50513          	addi	a0,a0,-1014 # 63d8 <malloc+0x384>
     7d6:	00005097          	auipc	ra,0x5
     7da:	7c6080e7          	jalr	1990(ra) # 5f9c <printf>
      exit(1);
     7de:	4505                	li	a0,1
     7e0:	00005097          	auipc	ra,0x5
     7e4:	44c080e7          	jalr	1100(ra) # 5c2c <exit>

00000000000007e8 <truncate1>:
{
     7e8:	711d                	addi	sp,sp,-96
     7ea:	ec86                	sd	ra,88(sp)
     7ec:	e8a2                	sd	s0,80(sp)
     7ee:	e4a6                	sd	s1,72(sp)
     7f0:	e0ca                	sd	s2,64(sp)
     7f2:	fc4e                	sd	s3,56(sp)
     7f4:	f852                	sd	s4,48(sp)
     7f6:	f456                	sd	s5,40(sp)
     7f8:	1080                	addi	s0,sp,96
     7fa:	8aaa                	mv	s5,a0
  unlink("truncfile");
     7fc:	00006517          	auipc	a0,0x6
     800:	9f450513          	addi	a0,a0,-1548 # 61f0 <malloc+0x19c>
     804:	00005097          	auipc	ra,0x5
     808:	478080e7          	jalr	1144(ra) # 5c7c <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     80c:	60100593          	li	a1,1537
     810:	00006517          	auipc	a0,0x6
     814:	9e050513          	addi	a0,a0,-1568 # 61f0 <malloc+0x19c>
     818:	00005097          	auipc	ra,0x5
     81c:	454080e7          	jalr	1108(ra) # 5c6c <open>
     820:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     822:	4611                	li	a2,4
     824:	00006597          	auipc	a1,0x6
     828:	9dc58593          	addi	a1,a1,-1572 # 6200 <malloc+0x1ac>
     82c:	00005097          	auipc	ra,0x5
     830:	420080e7          	jalr	1056(ra) # 5c4c <write>
  close(fd1);
     834:	8526                	mv	a0,s1
     836:	00005097          	auipc	ra,0x5
     83a:	41e080e7          	jalr	1054(ra) # 5c54 <close>
  int fd2 = open("truncfile", O_RDONLY);
     83e:	4581                	li	a1,0
     840:	00006517          	auipc	a0,0x6
     844:	9b050513          	addi	a0,a0,-1616 # 61f0 <malloc+0x19c>
     848:	00005097          	auipc	ra,0x5
     84c:	424080e7          	jalr	1060(ra) # 5c6c <open>
     850:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     852:	02000613          	li	a2,32
     856:	fa040593          	addi	a1,s0,-96
     85a:	00005097          	auipc	ra,0x5
     85e:	3ea080e7          	jalr	1002(ra) # 5c44 <read>
  if(n != 4){
     862:	4791                	li	a5,4
     864:	0cf51e63          	bne	a0,a5,940 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     868:	40100593          	li	a1,1025
     86c:	00006517          	auipc	a0,0x6
     870:	98450513          	addi	a0,a0,-1660 # 61f0 <malloc+0x19c>
     874:	00005097          	auipc	ra,0x5
     878:	3f8080e7          	jalr	1016(ra) # 5c6c <open>
     87c:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     87e:	4581                	li	a1,0
     880:	00006517          	auipc	a0,0x6
     884:	97050513          	addi	a0,a0,-1680 # 61f0 <malloc+0x19c>
     888:	00005097          	auipc	ra,0x5
     88c:	3e4080e7          	jalr	996(ra) # 5c6c <open>
     890:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     892:	02000613          	li	a2,32
     896:	fa040593          	addi	a1,s0,-96
     89a:	00005097          	auipc	ra,0x5
     89e:	3aa080e7          	jalr	938(ra) # 5c44 <read>
     8a2:	8a2a                	mv	s4,a0
  if(n != 0){
     8a4:	ed4d                	bnez	a0,95e <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8a6:	02000613          	li	a2,32
     8aa:	fa040593          	addi	a1,s0,-96
     8ae:	8526                	mv	a0,s1
     8b0:	00005097          	auipc	ra,0x5
     8b4:	394080e7          	jalr	916(ra) # 5c44 <read>
     8b8:	8a2a                	mv	s4,a0
  if(n != 0){
     8ba:	e971                	bnez	a0,98e <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8bc:	4619                	li	a2,6
     8be:	00006597          	auipc	a1,0x6
     8c2:	baa58593          	addi	a1,a1,-1110 # 6468 <malloc+0x414>
     8c6:	854e                	mv	a0,s3
     8c8:	00005097          	auipc	ra,0x5
     8cc:	384080e7          	jalr	900(ra) # 5c4c <write>
  n = read(fd3, buf, sizeof(buf));
     8d0:	02000613          	li	a2,32
     8d4:	fa040593          	addi	a1,s0,-96
     8d8:	854a                	mv	a0,s2
     8da:	00005097          	auipc	ra,0x5
     8de:	36a080e7          	jalr	874(ra) # 5c44 <read>
  if(n != 6){
     8e2:	4799                	li	a5,6
     8e4:	0cf51d63          	bne	a0,a5,9be <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8e8:	02000613          	li	a2,32
     8ec:	fa040593          	addi	a1,s0,-96
     8f0:	8526                	mv	a0,s1
     8f2:	00005097          	auipc	ra,0x5
     8f6:	352080e7          	jalr	850(ra) # 5c44 <read>
  if(n != 2){
     8fa:	4789                	li	a5,2
     8fc:	0ef51063          	bne	a0,a5,9dc <truncate1+0x1f4>
  unlink("truncfile");
     900:	00006517          	auipc	a0,0x6
     904:	8f050513          	addi	a0,a0,-1808 # 61f0 <malloc+0x19c>
     908:	00005097          	auipc	ra,0x5
     90c:	374080e7          	jalr	884(ra) # 5c7c <unlink>
  close(fd1);
     910:	854e                	mv	a0,s3
     912:	00005097          	auipc	ra,0x5
     916:	342080e7          	jalr	834(ra) # 5c54 <close>
  close(fd2);
     91a:	8526                	mv	a0,s1
     91c:	00005097          	auipc	ra,0x5
     920:	338080e7          	jalr	824(ra) # 5c54 <close>
  close(fd3);
     924:	854a                	mv	a0,s2
     926:	00005097          	auipc	ra,0x5
     92a:	32e080e7          	jalr	814(ra) # 5c54 <close>
}
     92e:	60e6                	ld	ra,88(sp)
     930:	6446                	ld	s0,80(sp)
     932:	64a6                	ld	s1,72(sp)
     934:	6906                	ld	s2,64(sp)
     936:	79e2                	ld	s3,56(sp)
     938:	7a42                	ld	s4,48(sp)
     93a:	7aa2                	ld	s5,40(sp)
     93c:	6125                	addi	sp,sp,96
     93e:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     940:	862a                	mv	a2,a0
     942:	85d6                	mv	a1,s5
     944:	00006517          	auipc	a0,0x6
     948:	ac450513          	addi	a0,a0,-1340 # 6408 <malloc+0x3b4>
     94c:	00005097          	auipc	ra,0x5
     950:	650080e7          	jalr	1616(ra) # 5f9c <printf>
    exit(1);
     954:	4505                	li	a0,1
     956:	00005097          	auipc	ra,0x5
     95a:	2d6080e7          	jalr	726(ra) # 5c2c <exit>
    printf("aaa fd3=%d\n", fd3);
     95e:	85ca                	mv	a1,s2
     960:	00006517          	auipc	a0,0x6
     964:	ac850513          	addi	a0,a0,-1336 # 6428 <malloc+0x3d4>
     968:	00005097          	auipc	ra,0x5
     96c:	634080e7          	jalr	1588(ra) # 5f9c <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     970:	8652                	mv	a2,s4
     972:	85d6                	mv	a1,s5
     974:	00006517          	auipc	a0,0x6
     978:	ac450513          	addi	a0,a0,-1340 # 6438 <malloc+0x3e4>
     97c:	00005097          	auipc	ra,0x5
     980:	620080e7          	jalr	1568(ra) # 5f9c <printf>
    exit(1);
     984:	4505                	li	a0,1
     986:	00005097          	auipc	ra,0x5
     98a:	2a6080e7          	jalr	678(ra) # 5c2c <exit>
    printf("bbb fd2=%d\n", fd2);
     98e:	85a6                	mv	a1,s1
     990:	00006517          	auipc	a0,0x6
     994:	ac850513          	addi	a0,a0,-1336 # 6458 <malloc+0x404>
     998:	00005097          	auipc	ra,0x5
     99c:	604080e7          	jalr	1540(ra) # 5f9c <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     9a0:	8652                	mv	a2,s4
     9a2:	85d6                	mv	a1,s5
     9a4:	00006517          	auipc	a0,0x6
     9a8:	a9450513          	addi	a0,a0,-1388 # 6438 <malloc+0x3e4>
     9ac:	00005097          	auipc	ra,0x5
     9b0:	5f0080e7          	jalr	1520(ra) # 5f9c <printf>
    exit(1);
     9b4:	4505                	li	a0,1
     9b6:	00005097          	auipc	ra,0x5
     9ba:	276080e7          	jalr	630(ra) # 5c2c <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9be:	862a                	mv	a2,a0
     9c0:	85d6                	mv	a1,s5
     9c2:	00006517          	auipc	a0,0x6
     9c6:	aae50513          	addi	a0,a0,-1362 # 6470 <malloc+0x41c>
     9ca:	00005097          	auipc	ra,0x5
     9ce:	5d2080e7          	jalr	1490(ra) # 5f9c <printf>
    exit(1);
     9d2:	4505                	li	a0,1
     9d4:	00005097          	auipc	ra,0x5
     9d8:	258080e7          	jalr	600(ra) # 5c2c <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9dc:	862a                	mv	a2,a0
     9de:	85d6                	mv	a1,s5
     9e0:	00006517          	auipc	a0,0x6
     9e4:	ab050513          	addi	a0,a0,-1360 # 6490 <malloc+0x43c>
     9e8:	00005097          	auipc	ra,0x5
     9ec:	5b4080e7          	jalr	1460(ra) # 5f9c <printf>
    exit(1);
     9f0:	4505                	li	a0,1
     9f2:	00005097          	auipc	ra,0x5
     9f6:	23a080e7          	jalr	570(ra) # 5c2c <exit>

00000000000009fa <writetest>:
{
     9fa:	7139                	addi	sp,sp,-64
     9fc:	fc06                	sd	ra,56(sp)
     9fe:	f822                	sd	s0,48(sp)
     a00:	f426                	sd	s1,40(sp)
     a02:	f04a                	sd	s2,32(sp)
     a04:	ec4e                	sd	s3,24(sp)
     a06:	e852                	sd	s4,16(sp)
     a08:	e456                	sd	s5,8(sp)
     a0a:	e05a                	sd	s6,0(sp)
     a0c:	0080                	addi	s0,sp,64
     a0e:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     a10:	20200593          	li	a1,514
     a14:	00006517          	auipc	a0,0x6
     a18:	a9c50513          	addi	a0,a0,-1380 # 64b0 <malloc+0x45c>
     a1c:	00005097          	auipc	ra,0x5
     a20:	250080e7          	jalr	592(ra) # 5c6c <open>
  if(fd < 0){
     a24:	0a054d63          	bltz	a0,ade <writetest+0xe4>
     a28:	892a                	mv	s2,a0
     a2a:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a2c:	00006997          	auipc	s3,0x6
     a30:	aac98993          	addi	s3,s3,-1364 # 64d8 <malloc+0x484>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a34:	00006a97          	auipc	s5,0x6
     a38:	adca8a93          	addi	s5,s5,-1316 # 6510 <malloc+0x4bc>
  for(i = 0; i < N; i++){
     a3c:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a40:	4629                	li	a2,10
     a42:	85ce                	mv	a1,s3
     a44:	854a                	mv	a0,s2
     a46:	00005097          	auipc	ra,0x5
     a4a:	206080e7          	jalr	518(ra) # 5c4c <write>
     a4e:	47a9                	li	a5,10
     a50:	0af51563          	bne	a0,a5,afa <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a54:	4629                	li	a2,10
     a56:	85d6                	mv	a1,s5
     a58:	854a                	mv	a0,s2
     a5a:	00005097          	auipc	ra,0x5
     a5e:	1f2080e7          	jalr	498(ra) # 5c4c <write>
     a62:	47a9                	li	a5,10
     a64:	0af51a63          	bne	a0,a5,b18 <writetest+0x11e>
  for(i = 0; i < N; i++){
     a68:	2485                	addiw	s1,s1,1
     a6a:	fd449be3          	bne	s1,s4,a40 <writetest+0x46>
  close(fd);
     a6e:	854a                	mv	a0,s2
     a70:	00005097          	auipc	ra,0x5
     a74:	1e4080e7          	jalr	484(ra) # 5c54 <close>
  fd = open("small", O_RDONLY);
     a78:	4581                	li	a1,0
     a7a:	00006517          	auipc	a0,0x6
     a7e:	a3650513          	addi	a0,a0,-1482 # 64b0 <malloc+0x45c>
     a82:	00005097          	auipc	ra,0x5
     a86:	1ea080e7          	jalr	490(ra) # 5c6c <open>
     a8a:	84aa                	mv	s1,a0
  if(fd < 0){
     a8c:	0a054563          	bltz	a0,b36 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     a90:	7d000613          	li	a2,2000
     a94:	0000d597          	auipc	a1,0xd
     a98:	58458593          	addi	a1,a1,1412 # e018 <buf>
     a9c:	00005097          	auipc	ra,0x5
     aa0:	1a8080e7          	jalr	424(ra) # 5c44 <read>
  if(i != N*SZ*2){
     aa4:	7d000793          	li	a5,2000
     aa8:	0af51563          	bne	a0,a5,b52 <writetest+0x158>
  close(fd);
     aac:	8526                	mv	a0,s1
     aae:	00005097          	auipc	ra,0x5
     ab2:	1a6080e7          	jalr	422(ra) # 5c54 <close>
  if(unlink("small") < 0){
     ab6:	00006517          	auipc	a0,0x6
     aba:	9fa50513          	addi	a0,a0,-1542 # 64b0 <malloc+0x45c>
     abe:	00005097          	auipc	ra,0x5
     ac2:	1be080e7          	jalr	446(ra) # 5c7c <unlink>
     ac6:	0a054463          	bltz	a0,b6e <writetest+0x174>
}
     aca:	70e2                	ld	ra,56(sp)
     acc:	7442                	ld	s0,48(sp)
     ace:	74a2                	ld	s1,40(sp)
     ad0:	7902                	ld	s2,32(sp)
     ad2:	69e2                	ld	s3,24(sp)
     ad4:	6a42                	ld	s4,16(sp)
     ad6:	6aa2                	ld	s5,8(sp)
     ad8:	6b02                	ld	s6,0(sp)
     ada:	6121                	addi	sp,sp,64
     adc:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     ade:	85da                	mv	a1,s6
     ae0:	00006517          	auipc	a0,0x6
     ae4:	9d850513          	addi	a0,a0,-1576 # 64b8 <malloc+0x464>
     ae8:	00005097          	auipc	ra,0x5
     aec:	4b4080e7          	jalr	1204(ra) # 5f9c <printf>
    exit(1);
     af0:	4505                	li	a0,1
     af2:	00005097          	auipc	ra,0x5
     af6:	13a080e7          	jalr	314(ra) # 5c2c <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     afa:	8626                	mv	a2,s1
     afc:	85da                	mv	a1,s6
     afe:	00006517          	auipc	a0,0x6
     b02:	9ea50513          	addi	a0,a0,-1558 # 64e8 <malloc+0x494>
     b06:	00005097          	auipc	ra,0x5
     b0a:	496080e7          	jalr	1174(ra) # 5f9c <printf>
      exit(1);
     b0e:	4505                	li	a0,1
     b10:	00005097          	auipc	ra,0x5
     b14:	11c080e7          	jalr	284(ra) # 5c2c <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b18:	8626                	mv	a2,s1
     b1a:	85da                	mv	a1,s6
     b1c:	00006517          	auipc	a0,0x6
     b20:	a0450513          	addi	a0,a0,-1532 # 6520 <malloc+0x4cc>
     b24:	00005097          	auipc	ra,0x5
     b28:	478080e7          	jalr	1144(ra) # 5f9c <printf>
      exit(1);
     b2c:	4505                	li	a0,1
     b2e:	00005097          	auipc	ra,0x5
     b32:	0fe080e7          	jalr	254(ra) # 5c2c <exit>
    printf("%s: error: open small failed!\n", s);
     b36:	85da                	mv	a1,s6
     b38:	00006517          	auipc	a0,0x6
     b3c:	a1050513          	addi	a0,a0,-1520 # 6548 <malloc+0x4f4>
     b40:	00005097          	auipc	ra,0x5
     b44:	45c080e7          	jalr	1116(ra) # 5f9c <printf>
    exit(1);
     b48:	4505                	li	a0,1
     b4a:	00005097          	auipc	ra,0x5
     b4e:	0e2080e7          	jalr	226(ra) # 5c2c <exit>
    printf("%s: read failed\n", s);
     b52:	85da                	mv	a1,s6
     b54:	00006517          	auipc	a0,0x6
     b58:	a1450513          	addi	a0,a0,-1516 # 6568 <malloc+0x514>
     b5c:	00005097          	auipc	ra,0x5
     b60:	440080e7          	jalr	1088(ra) # 5f9c <printf>
    exit(1);
     b64:	4505                	li	a0,1
     b66:	00005097          	auipc	ra,0x5
     b6a:	0c6080e7          	jalr	198(ra) # 5c2c <exit>
    printf("%s: unlink small failed\n", s);
     b6e:	85da                	mv	a1,s6
     b70:	00006517          	auipc	a0,0x6
     b74:	a1050513          	addi	a0,a0,-1520 # 6580 <malloc+0x52c>
     b78:	00005097          	auipc	ra,0x5
     b7c:	424080e7          	jalr	1060(ra) # 5f9c <printf>
    exit(1);
     b80:	4505                	li	a0,1
     b82:	00005097          	auipc	ra,0x5
     b86:	0aa080e7          	jalr	170(ra) # 5c2c <exit>

0000000000000b8a <writebig>:
{
     b8a:	7139                	addi	sp,sp,-64
     b8c:	fc06                	sd	ra,56(sp)
     b8e:	f822                	sd	s0,48(sp)
     b90:	f426                	sd	s1,40(sp)
     b92:	f04a                	sd	s2,32(sp)
     b94:	ec4e                	sd	s3,24(sp)
     b96:	e852                	sd	s4,16(sp)
     b98:	e456                	sd	s5,8(sp)
     b9a:	0080                	addi	s0,sp,64
     b9c:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     b9e:	20200593          	li	a1,514
     ba2:	00006517          	auipc	a0,0x6
     ba6:	9fe50513          	addi	a0,a0,-1538 # 65a0 <malloc+0x54c>
     baa:	00005097          	auipc	ra,0x5
     bae:	0c2080e7          	jalr	194(ra) # 5c6c <open>
     bb2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     bb4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     bb6:	0000d917          	auipc	s2,0xd
     bba:	46290913          	addi	s2,s2,1122 # e018 <buf>
  for(i = 0; i < MAXFILE; i++){
     bbe:	10c00a13          	li	s4,268
  if(fd < 0){
     bc2:	06054c63          	bltz	a0,c3a <writebig+0xb0>
    ((int*)buf)[0] = i;
     bc6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     bca:	40000613          	li	a2,1024
     bce:	85ca                	mv	a1,s2
     bd0:	854e                	mv	a0,s3
     bd2:	00005097          	auipc	ra,0x5
     bd6:	07a080e7          	jalr	122(ra) # 5c4c <write>
     bda:	40000793          	li	a5,1024
     bde:	06f51c63          	bne	a0,a5,c56 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     be2:	2485                	addiw	s1,s1,1
     be4:	ff4491e3          	bne	s1,s4,bc6 <writebig+0x3c>
  close(fd);
     be8:	854e                	mv	a0,s3
     bea:	00005097          	auipc	ra,0x5
     bee:	06a080e7          	jalr	106(ra) # 5c54 <close>
  fd = open("big", O_RDONLY);
     bf2:	4581                	li	a1,0
     bf4:	00006517          	auipc	a0,0x6
     bf8:	9ac50513          	addi	a0,a0,-1620 # 65a0 <malloc+0x54c>
     bfc:	00005097          	auipc	ra,0x5
     c00:	070080e7          	jalr	112(ra) # 5c6c <open>
     c04:	89aa                	mv	s3,a0
  n = 0;
     c06:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c08:	0000d917          	auipc	s2,0xd
     c0c:	41090913          	addi	s2,s2,1040 # e018 <buf>
  if(fd < 0){
     c10:	06054263          	bltz	a0,c74 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     c14:	40000613          	li	a2,1024
     c18:	85ca                	mv	a1,s2
     c1a:	854e                	mv	a0,s3
     c1c:	00005097          	auipc	ra,0x5
     c20:	028080e7          	jalr	40(ra) # 5c44 <read>
    if(i == 0){
     c24:	c535                	beqz	a0,c90 <writebig+0x106>
    } else if(i != BSIZE){
     c26:	40000793          	li	a5,1024
     c2a:	0af51f63          	bne	a0,a5,ce8 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     c2e:	00092683          	lw	a3,0(s2)
     c32:	0c969a63          	bne	a3,s1,d06 <writebig+0x17c>
    n++;
     c36:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c38:	bff1                	j	c14 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     c3a:	85d6                	mv	a1,s5
     c3c:	00006517          	auipc	a0,0x6
     c40:	96c50513          	addi	a0,a0,-1684 # 65a8 <malloc+0x554>
     c44:	00005097          	auipc	ra,0x5
     c48:	358080e7          	jalr	856(ra) # 5f9c <printf>
    exit(1);
     c4c:	4505                	li	a0,1
     c4e:	00005097          	auipc	ra,0x5
     c52:	fde080e7          	jalr	-34(ra) # 5c2c <exit>
      printf("%s: error: write big file failed\n", s, i);
     c56:	8626                	mv	a2,s1
     c58:	85d6                	mv	a1,s5
     c5a:	00006517          	auipc	a0,0x6
     c5e:	96e50513          	addi	a0,a0,-1682 # 65c8 <malloc+0x574>
     c62:	00005097          	auipc	ra,0x5
     c66:	33a080e7          	jalr	826(ra) # 5f9c <printf>
      exit(1);
     c6a:	4505                	li	a0,1
     c6c:	00005097          	auipc	ra,0x5
     c70:	fc0080e7          	jalr	-64(ra) # 5c2c <exit>
    printf("%s: error: open big failed!\n", s);
     c74:	85d6                	mv	a1,s5
     c76:	00006517          	auipc	a0,0x6
     c7a:	97a50513          	addi	a0,a0,-1670 # 65f0 <malloc+0x59c>
     c7e:	00005097          	auipc	ra,0x5
     c82:	31e080e7          	jalr	798(ra) # 5f9c <printf>
    exit(1);
     c86:	4505                	li	a0,1
     c88:	00005097          	auipc	ra,0x5
     c8c:	fa4080e7          	jalr	-92(ra) # 5c2c <exit>
      if(n == MAXFILE - 1){
     c90:	10b00793          	li	a5,267
     c94:	02f48a63          	beq	s1,a5,cc8 <writebig+0x13e>
  close(fd);
     c98:	854e                	mv	a0,s3
     c9a:	00005097          	auipc	ra,0x5
     c9e:	fba080e7          	jalr	-70(ra) # 5c54 <close>
  if(unlink("big") < 0){
     ca2:	00006517          	auipc	a0,0x6
     ca6:	8fe50513          	addi	a0,a0,-1794 # 65a0 <malloc+0x54c>
     caa:	00005097          	auipc	ra,0x5
     cae:	fd2080e7          	jalr	-46(ra) # 5c7c <unlink>
     cb2:	06054963          	bltz	a0,d24 <writebig+0x19a>
}
     cb6:	70e2                	ld	ra,56(sp)
     cb8:	7442                	ld	s0,48(sp)
     cba:	74a2                	ld	s1,40(sp)
     cbc:	7902                	ld	s2,32(sp)
     cbe:	69e2                	ld	s3,24(sp)
     cc0:	6a42                	ld	s4,16(sp)
     cc2:	6aa2                	ld	s5,8(sp)
     cc4:	6121                	addi	sp,sp,64
     cc6:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     cc8:	10b00613          	li	a2,267
     ccc:	85d6                	mv	a1,s5
     cce:	00006517          	auipc	a0,0x6
     cd2:	94250513          	addi	a0,a0,-1726 # 6610 <malloc+0x5bc>
     cd6:	00005097          	auipc	ra,0x5
     cda:	2c6080e7          	jalr	710(ra) # 5f9c <printf>
        exit(1);
     cde:	4505                	li	a0,1
     ce0:	00005097          	auipc	ra,0x5
     ce4:	f4c080e7          	jalr	-180(ra) # 5c2c <exit>
      printf("%s: read failed %d\n", s, i);
     ce8:	862a                	mv	a2,a0
     cea:	85d6                	mv	a1,s5
     cec:	00006517          	auipc	a0,0x6
     cf0:	94c50513          	addi	a0,a0,-1716 # 6638 <malloc+0x5e4>
     cf4:	00005097          	auipc	ra,0x5
     cf8:	2a8080e7          	jalr	680(ra) # 5f9c <printf>
      exit(1);
     cfc:	4505                	li	a0,1
     cfe:	00005097          	auipc	ra,0x5
     d02:	f2e080e7          	jalr	-210(ra) # 5c2c <exit>
      printf("%s: read content of block %d is %d\n", s,
     d06:	8626                	mv	a2,s1
     d08:	85d6                	mv	a1,s5
     d0a:	00006517          	auipc	a0,0x6
     d0e:	94650513          	addi	a0,a0,-1722 # 6650 <malloc+0x5fc>
     d12:	00005097          	auipc	ra,0x5
     d16:	28a080e7          	jalr	650(ra) # 5f9c <printf>
      exit(1);
     d1a:	4505                	li	a0,1
     d1c:	00005097          	auipc	ra,0x5
     d20:	f10080e7          	jalr	-240(ra) # 5c2c <exit>
    printf("%s: unlink big failed\n", s);
     d24:	85d6                	mv	a1,s5
     d26:	00006517          	auipc	a0,0x6
     d2a:	95250513          	addi	a0,a0,-1710 # 6678 <malloc+0x624>
     d2e:	00005097          	auipc	ra,0x5
     d32:	26e080e7          	jalr	622(ra) # 5f9c <printf>
    exit(1);
     d36:	4505                	li	a0,1
     d38:	00005097          	auipc	ra,0x5
     d3c:	ef4080e7          	jalr	-268(ra) # 5c2c <exit>

0000000000000d40 <unlinkread>:
{
     d40:	7179                	addi	sp,sp,-48
     d42:	f406                	sd	ra,40(sp)
     d44:	f022                	sd	s0,32(sp)
     d46:	ec26                	sd	s1,24(sp)
     d48:	e84a                	sd	s2,16(sp)
     d4a:	e44e                	sd	s3,8(sp)
     d4c:	1800                	addi	s0,sp,48
     d4e:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d50:	20200593          	li	a1,514
     d54:	00006517          	auipc	a0,0x6
     d58:	93c50513          	addi	a0,a0,-1732 # 6690 <malloc+0x63c>
     d5c:	00005097          	auipc	ra,0x5
     d60:	f10080e7          	jalr	-240(ra) # 5c6c <open>
  if(fd < 0){
     d64:	0e054563          	bltz	a0,e4e <unlinkread+0x10e>
     d68:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d6a:	4615                	li	a2,5
     d6c:	00006597          	auipc	a1,0x6
     d70:	95458593          	addi	a1,a1,-1708 # 66c0 <malloc+0x66c>
     d74:	00005097          	auipc	ra,0x5
     d78:	ed8080e7          	jalr	-296(ra) # 5c4c <write>
  close(fd);
     d7c:	8526                	mv	a0,s1
     d7e:	00005097          	auipc	ra,0x5
     d82:	ed6080e7          	jalr	-298(ra) # 5c54 <close>
  fd = open("unlinkread", O_RDWR);
     d86:	4589                	li	a1,2
     d88:	00006517          	auipc	a0,0x6
     d8c:	90850513          	addi	a0,a0,-1784 # 6690 <malloc+0x63c>
     d90:	00005097          	auipc	ra,0x5
     d94:	edc080e7          	jalr	-292(ra) # 5c6c <open>
     d98:	84aa                	mv	s1,a0
  if(fd < 0){
     d9a:	0c054863          	bltz	a0,e6a <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     d9e:	00006517          	auipc	a0,0x6
     da2:	8f250513          	addi	a0,a0,-1806 # 6690 <malloc+0x63c>
     da6:	00005097          	auipc	ra,0x5
     daa:	ed6080e7          	jalr	-298(ra) # 5c7c <unlink>
     dae:	ed61                	bnez	a0,e86 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     db0:	20200593          	li	a1,514
     db4:	00006517          	auipc	a0,0x6
     db8:	8dc50513          	addi	a0,a0,-1828 # 6690 <malloc+0x63c>
     dbc:	00005097          	auipc	ra,0x5
     dc0:	eb0080e7          	jalr	-336(ra) # 5c6c <open>
     dc4:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     dc6:	460d                	li	a2,3
     dc8:	00006597          	auipc	a1,0x6
     dcc:	94058593          	addi	a1,a1,-1728 # 6708 <malloc+0x6b4>
     dd0:	00005097          	auipc	ra,0x5
     dd4:	e7c080e7          	jalr	-388(ra) # 5c4c <write>
  close(fd1);
     dd8:	854a                	mv	a0,s2
     dda:	00005097          	auipc	ra,0x5
     dde:	e7a080e7          	jalr	-390(ra) # 5c54 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de2:	660d                	lui	a2,0x3
     de4:	0000d597          	auipc	a1,0xd
     de8:	23458593          	addi	a1,a1,564 # e018 <buf>
     dec:	8526                	mv	a0,s1
     dee:	00005097          	auipc	ra,0x5
     df2:	e56080e7          	jalr	-426(ra) # 5c44 <read>
     df6:	4795                	li	a5,5
     df8:	0af51563          	bne	a0,a5,ea2 <unlinkread+0x162>
  if(buf[0] != 'h'){
     dfc:	0000d717          	auipc	a4,0xd
     e00:	21c74703          	lbu	a4,540(a4) # e018 <buf>
     e04:	06800793          	li	a5,104
     e08:	0af71b63          	bne	a4,a5,ebe <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     e0c:	4629                	li	a2,10
     e0e:	0000d597          	auipc	a1,0xd
     e12:	20a58593          	addi	a1,a1,522 # e018 <buf>
     e16:	8526                	mv	a0,s1
     e18:	00005097          	auipc	ra,0x5
     e1c:	e34080e7          	jalr	-460(ra) # 5c4c <write>
     e20:	47a9                	li	a5,10
     e22:	0af51c63          	bne	a0,a5,eda <unlinkread+0x19a>
  close(fd);
     e26:	8526                	mv	a0,s1
     e28:	00005097          	auipc	ra,0x5
     e2c:	e2c080e7          	jalr	-468(ra) # 5c54 <close>
  unlink("unlinkread");
     e30:	00006517          	auipc	a0,0x6
     e34:	86050513          	addi	a0,a0,-1952 # 6690 <malloc+0x63c>
     e38:	00005097          	auipc	ra,0x5
     e3c:	e44080e7          	jalr	-444(ra) # 5c7c <unlink>
}
     e40:	70a2                	ld	ra,40(sp)
     e42:	7402                	ld	s0,32(sp)
     e44:	64e2                	ld	s1,24(sp)
     e46:	6942                	ld	s2,16(sp)
     e48:	69a2                	ld	s3,8(sp)
     e4a:	6145                	addi	sp,sp,48
     e4c:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e4e:	85ce                	mv	a1,s3
     e50:	00006517          	auipc	a0,0x6
     e54:	85050513          	addi	a0,a0,-1968 # 66a0 <malloc+0x64c>
     e58:	00005097          	auipc	ra,0x5
     e5c:	144080e7          	jalr	324(ra) # 5f9c <printf>
    exit(1);
     e60:	4505                	li	a0,1
     e62:	00005097          	auipc	ra,0x5
     e66:	dca080e7          	jalr	-566(ra) # 5c2c <exit>
    printf("%s: open unlinkread failed\n", s);
     e6a:	85ce                	mv	a1,s3
     e6c:	00006517          	auipc	a0,0x6
     e70:	85c50513          	addi	a0,a0,-1956 # 66c8 <malloc+0x674>
     e74:	00005097          	auipc	ra,0x5
     e78:	128080e7          	jalr	296(ra) # 5f9c <printf>
    exit(1);
     e7c:	4505                	li	a0,1
     e7e:	00005097          	auipc	ra,0x5
     e82:	dae080e7          	jalr	-594(ra) # 5c2c <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e86:	85ce                	mv	a1,s3
     e88:	00006517          	auipc	a0,0x6
     e8c:	86050513          	addi	a0,a0,-1952 # 66e8 <malloc+0x694>
     e90:	00005097          	auipc	ra,0x5
     e94:	10c080e7          	jalr	268(ra) # 5f9c <printf>
    exit(1);
     e98:	4505                	li	a0,1
     e9a:	00005097          	auipc	ra,0x5
     e9e:	d92080e7          	jalr	-622(ra) # 5c2c <exit>
    printf("%s: unlinkread read failed", s);
     ea2:	85ce                	mv	a1,s3
     ea4:	00006517          	auipc	a0,0x6
     ea8:	86c50513          	addi	a0,a0,-1940 # 6710 <malloc+0x6bc>
     eac:	00005097          	auipc	ra,0x5
     eb0:	0f0080e7          	jalr	240(ra) # 5f9c <printf>
    exit(1);
     eb4:	4505                	li	a0,1
     eb6:	00005097          	auipc	ra,0x5
     eba:	d76080e7          	jalr	-650(ra) # 5c2c <exit>
    printf("%s: unlinkread wrong data\n", s);
     ebe:	85ce                	mv	a1,s3
     ec0:	00006517          	auipc	a0,0x6
     ec4:	87050513          	addi	a0,a0,-1936 # 6730 <malloc+0x6dc>
     ec8:	00005097          	auipc	ra,0x5
     ecc:	0d4080e7          	jalr	212(ra) # 5f9c <printf>
    exit(1);
     ed0:	4505                	li	a0,1
     ed2:	00005097          	auipc	ra,0x5
     ed6:	d5a080e7          	jalr	-678(ra) # 5c2c <exit>
    printf("%s: unlinkread write failed\n", s);
     eda:	85ce                	mv	a1,s3
     edc:	00006517          	auipc	a0,0x6
     ee0:	87450513          	addi	a0,a0,-1932 # 6750 <malloc+0x6fc>
     ee4:	00005097          	auipc	ra,0x5
     ee8:	0b8080e7          	jalr	184(ra) # 5f9c <printf>
    exit(1);
     eec:	4505                	li	a0,1
     eee:	00005097          	auipc	ra,0x5
     ef2:	d3e080e7          	jalr	-706(ra) # 5c2c <exit>

0000000000000ef6 <linktest>:
{
     ef6:	1101                	addi	sp,sp,-32
     ef8:	ec06                	sd	ra,24(sp)
     efa:	e822                	sd	s0,16(sp)
     efc:	e426                	sd	s1,8(sp)
     efe:	e04a                	sd	s2,0(sp)
     f00:	1000                	addi	s0,sp,32
     f02:	892a                	mv	s2,a0
  unlink("lf1");
     f04:	00006517          	auipc	a0,0x6
     f08:	86c50513          	addi	a0,a0,-1940 # 6770 <malloc+0x71c>
     f0c:	00005097          	auipc	ra,0x5
     f10:	d70080e7          	jalr	-656(ra) # 5c7c <unlink>
  unlink("lf2");
     f14:	00006517          	auipc	a0,0x6
     f18:	86450513          	addi	a0,a0,-1948 # 6778 <malloc+0x724>
     f1c:	00005097          	auipc	ra,0x5
     f20:	d60080e7          	jalr	-672(ra) # 5c7c <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     f24:	20200593          	li	a1,514
     f28:	00006517          	auipc	a0,0x6
     f2c:	84850513          	addi	a0,a0,-1976 # 6770 <malloc+0x71c>
     f30:	00005097          	auipc	ra,0x5
     f34:	d3c080e7          	jalr	-708(ra) # 5c6c <open>
  if(fd < 0){
     f38:	10054763          	bltz	a0,1046 <linktest+0x150>
     f3c:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     f3e:	4615                	li	a2,5
     f40:	00005597          	auipc	a1,0x5
     f44:	78058593          	addi	a1,a1,1920 # 66c0 <malloc+0x66c>
     f48:	00005097          	auipc	ra,0x5
     f4c:	d04080e7          	jalr	-764(ra) # 5c4c <write>
     f50:	4795                	li	a5,5
     f52:	10f51863          	bne	a0,a5,1062 <linktest+0x16c>
  close(fd);
     f56:	8526                	mv	a0,s1
     f58:	00005097          	auipc	ra,0x5
     f5c:	cfc080e7          	jalr	-772(ra) # 5c54 <close>
  if(link("lf1", "lf2") < 0){
     f60:	00006597          	auipc	a1,0x6
     f64:	81858593          	addi	a1,a1,-2024 # 6778 <malloc+0x724>
     f68:	00006517          	auipc	a0,0x6
     f6c:	80850513          	addi	a0,a0,-2040 # 6770 <malloc+0x71c>
     f70:	00005097          	auipc	ra,0x5
     f74:	d1c080e7          	jalr	-740(ra) # 5c8c <link>
     f78:	10054363          	bltz	a0,107e <linktest+0x188>
  unlink("lf1");
     f7c:	00005517          	auipc	a0,0x5
     f80:	7f450513          	addi	a0,a0,2036 # 6770 <malloc+0x71c>
     f84:	00005097          	auipc	ra,0x5
     f88:	cf8080e7          	jalr	-776(ra) # 5c7c <unlink>
  if(open("lf1", 0) >= 0){
     f8c:	4581                	li	a1,0
     f8e:	00005517          	auipc	a0,0x5
     f92:	7e250513          	addi	a0,a0,2018 # 6770 <malloc+0x71c>
     f96:	00005097          	auipc	ra,0x5
     f9a:	cd6080e7          	jalr	-810(ra) # 5c6c <open>
     f9e:	0e055e63          	bgez	a0,109a <linktest+0x1a4>
  fd = open("lf2", 0);
     fa2:	4581                	li	a1,0
     fa4:	00005517          	auipc	a0,0x5
     fa8:	7d450513          	addi	a0,a0,2004 # 6778 <malloc+0x724>
     fac:	00005097          	auipc	ra,0x5
     fb0:	cc0080e7          	jalr	-832(ra) # 5c6c <open>
     fb4:	84aa                	mv	s1,a0
  if(fd < 0){
     fb6:	10054063          	bltz	a0,10b6 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     fba:	660d                	lui	a2,0x3
     fbc:	0000d597          	auipc	a1,0xd
     fc0:	05c58593          	addi	a1,a1,92 # e018 <buf>
     fc4:	00005097          	auipc	ra,0x5
     fc8:	c80080e7          	jalr	-896(ra) # 5c44 <read>
     fcc:	4795                	li	a5,5
     fce:	10f51263          	bne	a0,a5,10d2 <linktest+0x1dc>
  close(fd);
     fd2:	8526                	mv	a0,s1
     fd4:	00005097          	auipc	ra,0x5
     fd8:	c80080e7          	jalr	-896(ra) # 5c54 <close>
  if(link("lf2", "lf2") >= 0){
     fdc:	00005597          	auipc	a1,0x5
     fe0:	79c58593          	addi	a1,a1,1948 # 6778 <malloc+0x724>
     fe4:	852e                	mv	a0,a1
     fe6:	00005097          	auipc	ra,0x5
     fea:	ca6080e7          	jalr	-858(ra) # 5c8c <link>
     fee:	10055063          	bgez	a0,10ee <linktest+0x1f8>
  unlink("lf2");
     ff2:	00005517          	auipc	a0,0x5
     ff6:	78650513          	addi	a0,a0,1926 # 6778 <malloc+0x724>
     ffa:	00005097          	auipc	ra,0x5
     ffe:	c82080e7          	jalr	-894(ra) # 5c7c <unlink>
  if(link("lf2", "lf1") >= 0){
    1002:	00005597          	auipc	a1,0x5
    1006:	76e58593          	addi	a1,a1,1902 # 6770 <malloc+0x71c>
    100a:	00005517          	auipc	a0,0x5
    100e:	76e50513          	addi	a0,a0,1902 # 6778 <malloc+0x724>
    1012:	00005097          	auipc	ra,0x5
    1016:	c7a080e7          	jalr	-902(ra) # 5c8c <link>
    101a:	0e055863          	bgez	a0,110a <linktest+0x214>
  if(link(".", "lf1") >= 0){
    101e:	00005597          	auipc	a1,0x5
    1022:	75258593          	addi	a1,a1,1874 # 6770 <malloc+0x71c>
    1026:	00006517          	auipc	a0,0x6
    102a:	85a50513          	addi	a0,a0,-1958 # 6880 <malloc+0x82c>
    102e:	00005097          	auipc	ra,0x5
    1032:	c5e080e7          	jalr	-930(ra) # 5c8c <link>
    1036:	0e055863          	bgez	a0,1126 <linktest+0x230>
}
    103a:	60e2                	ld	ra,24(sp)
    103c:	6442                	ld	s0,16(sp)
    103e:	64a2                	ld	s1,8(sp)
    1040:	6902                	ld	s2,0(sp)
    1042:	6105                	addi	sp,sp,32
    1044:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    1046:	85ca                	mv	a1,s2
    1048:	00005517          	auipc	a0,0x5
    104c:	73850513          	addi	a0,a0,1848 # 6780 <malloc+0x72c>
    1050:	00005097          	auipc	ra,0x5
    1054:	f4c080e7          	jalr	-180(ra) # 5f9c <printf>
    exit(1);
    1058:	4505                	li	a0,1
    105a:	00005097          	auipc	ra,0x5
    105e:	bd2080e7          	jalr	-1070(ra) # 5c2c <exit>
    printf("%s: write lf1 failed\n", s);
    1062:	85ca                	mv	a1,s2
    1064:	00005517          	auipc	a0,0x5
    1068:	73450513          	addi	a0,a0,1844 # 6798 <malloc+0x744>
    106c:	00005097          	auipc	ra,0x5
    1070:	f30080e7          	jalr	-208(ra) # 5f9c <printf>
    exit(1);
    1074:	4505                	li	a0,1
    1076:	00005097          	auipc	ra,0x5
    107a:	bb6080e7          	jalr	-1098(ra) # 5c2c <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    107e:	85ca                	mv	a1,s2
    1080:	00005517          	auipc	a0,0x5
    1084:	73050513          	addi	a0,a0,1840 # 67b0 <malloc+0x75c>
    1088:	00005097          	auipc	ra,0x5
    108c:	f14080e7          	jalr	-236(ra) # 5f9c <printf>
    exit(1);
    1090:	4505                	li	a0,1
    1092:	00005097          	auipc	ra,0x5
    1096:	b9a080e7          	jalr	-1126(ra) # 5c2c <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    109a:	85ca                	mv	a1,s2
    109c:	00005517          	auipc	a0,0x5
    10a0:	73450513          	addi	a0,a0,1844 # 67d0 <malloc+0x77c>
    10a4:	00005097          	auipc	ra,0x5
    10a8:	ef8080e7          	jalr	-264(ra) # 5f9c <printf>
    exit(1);
    10ac:	4505                	li	a0,1
    10ae:	00005097          	auipc	ra,0x5
    10b2:	b7e080e7          	jalr	-1154(ra) # 5c2c <exit>
    printf("%s: open lf2 failed\n", s);
    10b6:	85ca                	mv	a1,s2
    10b8:	00005517          	auipc	a0,0x5
    10bc:	74850513          	addi	a0,a0,1864 # 6800 <malloc+0x7ac>
    10c0:	00005097          	auipc	ra,0x5
    10c4:	edc080e7          	jalr	-292(ra) # 5f9c <printf>
    exit(1);
    10c8:	4505                	li	a0,1
    10ca:	00005097          	auipc	ra,0x5
    10ce:	b62080e7          	jalr	-1182(ra) # 5c2c <exit>
    printf("%s: read lf2 failed\n", s);
    10d2:	85ca                	mv	a1,s2
    10d4:	00005517          	auipc	a0,0x5
    10d8:	74450513          	addi	a0,a0,1860 # 6818 <malloc+0x7c4>
    10dc:	00005097          	auipc	ra,0x5
    10e0:	ec0080e7          	jalr	-320(ra) # 5f9c <printf>
    exit(1);
    10e4:	4505                	li	a0,1
    10e6:	00005097          	auipc	ra,0x5
    10ea:	b46080e7          	jalr	-1210(ra) # 5c2c <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    10ee:	85ca                	mv	a1,s2
    10f0:	00005517          	auipc	a0,0x5
    10f4:	74050513          	addi	a0,a0,1856 # 6830 <malloc+0x7dc>
    10f8:	00005097          	auipc	ra,0x5
    10fc:	ea4080e7          	jalr	-348(ra) # 5f9c <printf>
    exit(1);
    1100:	4505                	li	a0,1
    1102:	00005097          	auipc	ra,0x5
    1106:	b2a080e7          	jalr	-1238(ra) # 5c2c <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    110a:	85ca                	mv	a1,s2
    110c:	00005517          	auipc	a0,0x5
    1110:	74c50513          	addi	a0,a0,1868 # 6858 <malloc+0x804>
    1114:	00005097          	auipc	ra,0x5
    1118:	e88080e7          	jalr	-376(ra) # 5f9c <printf>
    exit(1);
    111c:	4505                	li	a0,1
    111e:	00005097          	auipc	ra,0x5
    1122:	b0e080e7          	jalr	-1266(ra) # 5c2c <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1126:	85ca                	mv	a1,s2
    1128:	00005517          	auipc	a0,0x5
    112c:	76050513          	addi	a0,a0,1888 # 6888 <malloc+0x834>
    1130:	00005097          	auipc	ra,0x5
    1134:	e6c080e7          	jalr	-404(ra) # 5f9c <printf>
    exit(1);
    1138:	4505                	li	a0,1
    113a:	00005097          	auipc	ra,0x5
    113e:	af2080e7          	jalr	-1294(ra) # 5c2c <exit>

0000000000001142 <validatetest>:
{
    1142:	7139                	addi	sp,sp,-64
    1144:	fc06                	sd	ra,56(sp)
    1146:	f822                	sd	s0,48(sp)
    1148:	f426                	sd	s1,40(sp)
    114a:	f04a                	sd	s2,32(sp)
    114c:	ec4e                	sd	s3,24(sp)
    114e:	e852                	sd	s4,16(sp)
    1150:	e456                	sd	s5,8(sp)
    1152:	e05a                	sd	s6,0(sp)
    1154:	0080                	addi	s0,sp,64
    1156:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1158:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    115a:	00005997          	auipc	s3,0x5
    115e:	74e98993          	addi	s3,s3,1870 # 68a8 <malloc+0x854>
    1162:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1164:	6a85                	lui	s5,0x1
    1166:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    116a:	85a6                	mv	a1,s1
    116c:	854e                	mv	a0,s3
    116e:	00005097          	auipc	ra,0x5
    1172:	b1e080e7          	jalr	-1250(ra) # 5c8c <link>
    1176:	01251f63          	bne	a0,s2,1194 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    117a:	94d6                	add	s1,s1,s5
    117c:	ff4497e3          	bne	s1,s4,116a <validatetest+0x28>
}
    1180:	70e2                	ld	ra,56(sp)
    1182:	7442                	ld	s0,48(sp)
    1184:	74a2                	ld	s1,40(sp)
    1186:	7902                	ld	s2,32(sp)
    1188:	69e2                	ld	s3,24(sp)
    118a:	6a42                	ld	s4,16(sp)
    118c:	6aa2                	ld	s5,8(sp)
    118e:	6b02                	ld	s6,0(sp)
    1190:	6121                	addi	sp,sp,64
    1192:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1194:	85da                	mv	a1,s6
    1196:	00005517          	auipc	a0,0x5
    119a:	72250513          	addi	a0,a0,1826 # 68b8 <malloc+0x864>
    119e:	00005097          	auipc	ra,0x5
    11a2:	dfe080e7          	jalr	-514(ra) # 5f9c <printf>
      exit(1);
    11a6:	4505                	li	a0,1
    11a8:	00005097          	auipc	ra,0x5
    11ac:	a84080e7          	jalr	-1404(ra) # 5c2c <exit>

00000000000011b0 <bigdir>:
{
    11b0:	715d                	addi	sp,sp,-80
    11b2:	e486                	sd	ra,72(sp)
    11b4:	e0a2                	sd	s0,64(sp)
    11b6:	fc26                	sd	s1,56(sp)
    11b8:	f84a                	sd	s2,48(sp)
    11ba:	f44e                	sd	s3,40(sp)
    11bc:	f052                	sd	s4,32(sp)
    11be:	ec56                	sd	s5,24(sp)
    11c0:	e85a                	sd	s6,16(sp)
    11c2:	0880                	addi	s0,sp,80
    11c4:	89aa                	mv	s3,a0
  unlink("bd");
    11c6:	00005517          	auipc	a0,0x5
    11ca:	71250513          	addi	a0,a0,1810 # 68d8 <malloc+0x884>
    11ce:	00005097          	auipc	ra,0x5
    11d2:	aae080e7          	jalr	-1362(ra) # 5c7c <unlink>
  fd = open("bd", O_CREATE);
    11d6:	20000593          	li	a1,512
    11da:	00005517          	auipc	a0,0x5
    11de:	6fe50513          	addi	a0,a0,1790 # 68d8 <malloc+0x884>
    11e2:	00005097          	auipc	ra,0x5
    11e6:	a8a080e7          	jalr	-1398(ra) # 5c6c <open>
  if(fd < 0){
    11ea:	0c054963          	bltz	a0,12bc <bigdir+0x10c>
  close(fd);
    11ee:	00005097          	auipc	ra,0x5
    11f2:	a66080e7          	jalr	-1434(ra) # 5c54 <close>
  for(i = 0; i < N; i++){
    11f6:	4901                	li	s2,0
    name[0] = 'x';
    11f8:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    11fc:	00005a17          	auipc	s4,0x5
    1200:	6dca0a13          	addi	s4,s4,1756 # 68d8 <malloc+0x884>
  for(i = 0; i < N; i++){
    1204:	1f400b13          	li	s6,500
    name[0] = 'x';
    1208:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    120c:	41f9571b          	sraiw	a4,s2,0x1f
    1210:	01a7571b          	srliw	a4,a4,0x1a
    1214:	012707bb          	addw	a5,a4,s2
    1218:	4067d69b          	sraiw	a3,a5,0x6
    121c:	0306869b          	addiw	a3,a3,48
    1220:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1224:	03f7f793          	andi	a5,a5,63
    1228:	9f99                	subw	a5,a5,a4
    122a:	0307879b          	addiw	a5,a5,48
    122e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1232:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1236:	fb040593          	addi	a1,s0,-80
    123a:	8552                	mv	a0,s4
    123c:	00005097          	auipc	ra,0x5
    1240:	a50080e7          	jalr	-1456(ra) # 5c8c <link>
    1244:	84aa                	mv	s1,a0
    1246:	e949                	bnez	a0,12d8 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1248:	2905                	addiw	s2,s2,1
    124a:	fb691fe3          	bne	s2,s6,1208 <bigdir+0x58>
  unlink("bd");
    124e:	00005517          	auipc	a0,0x5
    1252:	68a50513          	addi	a0,a0,1674 # 68d8 <malloc+0x884>
    1256:	00005097          	auipc	ra,0x5
    125a:	a26080e7          	jalr	-1498(ra) # 5c7c <unlink>
    name[0] = 'x';
    125e:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1262:	1f400a13          	li	s4,500
    name[0] = 'x';
    1266:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    126a:	41f4d71b          	sraiw	a4,s1,0x1f
    126e:	01a7571b          	srliw	a4,a4,0x1a
    1272:	009707bb          	addw	a5,a4,s1
    1276:	4067d69b          	sraiw	a3,a5,0x6
    127a:	0306869b          	addiw	a3,a3,48
    127e:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1282:	03f7f793          	andi	a5,a5,63
    1286:	9f99                	subw	a5,a5,a4
    1288:	0307879b          	addiw	a5,a5,48
    128c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1290:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1294:	fb040513          	addi	a0,s0,-80
    1298:	00005097          	auipc	ra,0x5
    129c:	9e4080e7          	jalr	-1564(ra) # 5c7c <unlink>
    12a0:	ed21                	bnez	a0,12f8 <bigdir+0x148>
  for(i = 0; i < N; i++){
    12a2:	2485                	addiw	s1,s1,1
    12a4:	fd4491e3          	bne	s1,s4,1266 <bigdir+0xb6>
}
    12a8:	60a6                	ld	ra,72(sp)
    12aa:	6406                	ld	s0,64(sp)
    12ac:	74e2                	ld	s1,56(sp)
    12ae:	7942                	ld	s2,48(sp)
    12b0:	79a2                	ld	s3,40(sp)
    12b2:	7a02                	ld	s4,32(sp)
    12b4:	6ae2                	ld	s5,24(sp)
    12b6:	6b42                	ld	s6,16(sp)
    12b8:	6161                	addi	sp,sp,80
    12ba:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12bc:	85ce                	mv	a1,s3
    12be:	00005517          	auipc	a0,0x5
    12c2:	62250513          	addi	a0,a0,1570 # 68e0 <malloc+0x88c>
    12c6:	00005097          	auipc	ra,0x5
    12ca:	cd6080e7          	jalr	-810(ra) # 5f9c <printf>
    exit(1);
    12ce:	4505                	li	a0,1
    12d0:	00005097          	auipc	ra,0x5
    12d4:	95c080e7          	jalr	-1700(ra) # 5c2c <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12d8:	fb040613          	addi	a2,s0,-80
    12dc:	85ce                	mv	a1,s3
    12de:	00005517          	auipc	a0,0x5
    12e2:	62250513          	addi	a0,a0,1570 # 6900 <malloc+0x8ac>
    12e6:	00005097          	auipc	ra,0x5
    12ea:	cb6080e7          	jalr	-842(ra) # 5f9c <printf>
      exit(1);
    12ee:	4505                	li	a0,1
    12f0:	00005097          	auipc	ra,0x5
    12f4:	93c080e7          	jalr	-1732(ra) # 5c2c <exit>
      printf("%s: bigdir unlink failed", s);
    12f8:	85ce                	mv	a1,s3
    12fa:	00005517          	auipc	a0,0x5
    12fe:	62650513          	addi	a0,a0,1574 # 6920 <malloc+0x8cc>
    1302:	00005097          	auipc	ra,0x5
    1306:	c9a080e7          	jalr	-870(ra) # 5f9c <printf>
      exit(1);
    130a:	4505                	li	a0,1
    130c:	00005097          	auipc	ra,0x5
    1310:	920080e7          	jalr	-1760(ra) # 5c2c <exit>

0000000000001314 <pgbug>:
{
    1314:	7179                	addi	sp,sp,-48
    1316:	f406                	sd	ra,40(sp)
    1318:	f022                	sd	s0,32(sp)
    131a:	ec26                	sd	s1,24(sp)
    131c:	1800                	addi	s0,sp,48
  argv[0] = 0;
    131e:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1322:	00009497          	auipc	s1,0x9
    1326:	07e48493          	addi	s1,s1,126 # a3a0 <big>
    132a:	fd840593          	addi	a1,s0,-40
    132e:	6088                	ld	a0,0(s1)
    1330:	00005097          	auipc	ra,0x5
    1334:	934080e7          	jalr	-1740(ra) # 5c64 <exec>
  pipe(big);
    1338:	6088                	ld	a0,0(s1)
    133a:	00005097          	auipc	ra,0x5
    133e:	902080e7          	jalr	-1790(ra) # 5c3c <pipe>
  exit(0);
    1342:	4501                	li	a0,0
    1344:	00005097          	auipc	ra,0x5
    1348:	8e8080e7          	jalr	-1816(ra) # 5c2c <exit>

000000000000134c <badarg>:
{
    134c:	7139                	addi	sp,sp,-64
    134e:	fc06                	sd	ra,56(sp)
    1350:	f822                	sd	s0,48(sp)
    1352:	f426                	sd	s1,40(sp)
    1354:	f04a                	sd	s2,32(sp)
    1356:	ec4e                	sd	s3,24(sp)
    1358:	0080                	addi	s0,sp,64
    135a:	64b1                	lui	s1,0xc
    135c:	35048493          	addi	s1,s1,848 # c350 <uninit+0xa48>
    argv[0] = (char*)0xffffffff;
    1360:	597d                	li	s2,-1
    1362:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    1366:	00005997          	auipc	s3,0x5
    136a:	e3298993          	addi	s3,s3,-462 # 6198 <malloc+0x144>
    argv[0] = (char*)0xffffffff;
    136e:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1372:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1376:	fc040593          	addi	a1,s0,-64
    137a:	854e                	mv	a0,s3
    137c:	00005097          	auipc	ra,0x5
    1380:	8e8080e7          	jalr	-1816(ra) # 5c64 <exec>
  for(int i = 0; i < 50000; i++){
    1384:	34fd                	addiw	s1,s1,-1
    1386:	f4e5                	bnez	s1,136e <badarg+0x22>
  exit(0);
    1388:	4501                	li	a0,0
    138a:	00005097          	auipc	ra,0x5
    138e:	8a2080e7          	jalr	-1886(ra) # 5c2c <exit>

0000000000001392 <copyinstr2>:
{
    1392:	7155                	addi	sp,sp,-208
    1394:	e586                	sd	ra,200(sp)
    1396:	e1a2                	sd	s0,192(sp)
    1398:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    139a:	f6840793          	addi	a5,s0,-152
    139e:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    13a2:	07800713          	li	a4,120
    13a6:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    13aa:	0785                	addi	a5,a5,1
    13ac:	fed79de3          	bne	a5,a3,13a6 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13b0:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13b4:	f6840513          	addi	a0,s0,-152
    13b8:	00005097          	auipc	ra,0x5
    13bc:	8c4080e7          	jalr	-1852(ra) # 5c7c <unlink>
  if(ret != -1){
    13c0:	57fd                	li	a5,-1
    13c2:	0ef51063          	bne	a0,a5,14a2 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13c6:	20100593          	li	a1,513
    13ca:	f6840513          	addi	a0,s0,-152
    13ce:	00005097          	auipc	ra,0x5
    13d2:	89e080e7          	jalr	-1890(ra) # 5c6c <open>
  if(fd != -1){
    13d6:	57fd                	li	a5,-1
    13d8:	0ef51563          	bne	a0,a5,14c2 <copyinstr2+0x130>
  ret = link(b, b);
    13dc:	f6840593          	addi	a1,s0,-152
    13e0:	852e                	mv	a0,a1
    13e2:	00005097          	auipc	ra,0x5
    13e6:	8aa080e7          	jalr	-1878(ra) # 5c8c <link>
  if(ret != -1){
    13ea:	57fd                	li	a5,-1
    13ec:	0ef51b63          	bne	a0,a5,14e2 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    13f0:	00006797          	auipc	a5,0x6
    13f4:	78878793          	addi	a5,a5,1928 # 7b78 <malloc+0x1b24>
    13f8:	f4f43c23          	sd	a5,-168(s0)
    13fc:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1400:	f5840593          	addi	a1,s0,-168
    1404:	f6840513          	addi	a0,s0,-152
    1408:	00005097          	auipc	ra,0x5
    140c:	85c080e7          	jalr	-1956(ra) # 5c64 <exec>
  if(ret != -1){
    1410:	57fd                	li	a5,-1
    1412:	0ef51963          	bne	a0,a5,1504 <copyinstr2+0x172>
  int pid = fork();
    1416:	00005097          	auipc	ra,0x5
    141a:	80e080e7          	jalr	-2034(ra) # 5c24 <fork>
  if(pid < 0){
    141e:	10054363          	bltz	a0,1524 <copyinstr2+0x192>
  if(pid == 0){
    1422:	12051463          	bnez	a0,154a <copyinstr2+0x1b8>
    1426:	00009797          	auipc	a5,0x9
    142a:	4da78793          	addi	a5,a5,1242 # a900 <big.0>
    142e:	0000a697          	auipc	a3,0xa
    1432:	4d268693          	addi	a3,a3,1234 # b900 <big.0+0x1000>
      big[i] = 'x';
    1436:	07800713          	li	a4,120
    143a:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    143e:	0785                	addi	a5,a5,1
    1440:	fed79de3          	bne	a5,a3,143a <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1444:	0000a797          	auipc	a5,0xa
    1448:	4a078e23          	sb	zero,1212(a5) # b900 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    144c:	00007797          	auipc	a5,0x7
    1450:	17478793          	addi	a5,a5,372 # 85c0 <malloc+0x256c>
    1454:	6390                	ld	a2,0(a5)
    1456:	6794                	ld	a3,8(a5)
    1458:	6b98                	ld	a4,16(a5)
    145a:	6f9c                	ld	a5,24(a5)
    145c:	f2c43823          	sd	a2,-208(s0)
    1460:	f2d43c23          	sd	a3,-200(s0)
    1464:	f4e43023          	sd	a4,-192(s0)
    1468:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    146c:	f3040593          	addi	a1,s0,-208
    1470:	00005517          	auipc	a0,0x5
    1474:	d2850513          	addi	a0,a0,-728 # 6198 <malloc+0x144>
    1478:	00004097          	auipc	ra,0x4
    147c:	7ec080e7          	jalr	2028(ra) # 5c64 <exec>
    if(ret != -1){
    1480:	57fd                	li	a5,-1
    1482:	0af50e63          	beq	a0,a5,153e <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1486:	55fd                	li	a1,-1
    1488:	00005517          	auipc	a0,0x5
    148c:	54050513          	addi	a0,a0,1344 # 69c8 <malloc+0x974>
    1490:	00005097          	auipc	ra,0x5
    1494:	b0c080e7          	jalr	-1268(ra) # 5f9c <printf>
      exit(1);
    1498:	4505                	li	a0,1
    149a:	00004097          	auipc	ra,0x4
    149e:	792080e7          	jalr	1938(ra) # 5c2c <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14a2:	862a                	mv	a2,a0
    14a4:	f6840593          	addi	a1,s0,-152
    14a8:	00005517          	auipc	a0,0x5
    14ac:	49850513          	addi	a0,a0,1176 # 6940 <malloc+0x8ec>
    14b0:	00005097          	auipc	ra,0x5
    14b4:	aec080e7          	jalr	-1300(ra) # 5f9c <printf>
    exit(1);
    14b8:	4505                	li	a0,1
    14ba:	00004097          	auipc	ra,0x4
    14be:	772080e7          	jalr	1906(ra) # 5c2c <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14c2:	862a                	mv	a2,a0
    14c4:	f6840593          	addi	a1,s0,-152
    14c8:	00005517          	auipc	a0,0x5
    14cc:	49850513          	addi	a0,a0,1176 # 6960 <malloc+0x90c>
    14d0:	00005097          	auipc	ra,0x5
    14d4:	acc080e7          	jalr	-1332(ra) # 5f9c <printf>
    exit(1);
    14d8:	4505                	li	a0,1
    14da:	00004097          	auipc	ra,0x4
    14de:	752080e7          	jalr	1874(ra) # 5c2c <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14e2:	86aa                	mv	a3,a0
    14e4:	f6840613          	addi	a2,s0,-152
    14e8:	85b2                	mv	a1,a2
    14ea:	00005517          	auipc	a0,0x5
    14ee:	49650513          	addi	a0,a0,1174 # 6980 <malloc+0x92c>
    14f2:	00005097          	auipc	ra,0x5
    14f6:	aaa080e7          	jalr	-1366(ra) # 5f9c <printf>
    exit(1);
    14fa:	4505                	li	a0,1
    14fc:	00004097          	auipc	ra,0x4
    1500:	730080e7          	jalr	1840(ra) # 5c2c <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1504:	567d                	li	a2,-1
    1506:	f6840593          	addi	a1,s0,-152
    150a:	00005517          	auipc	a0,0x5
    150e:	49e50513          	addi	a0,a0,1182 # 69a8 <malloc+0x954>
    1512:	00005097          	auipc	ra,0x5
    1516:	a8a080e7          	jalr	-1398(ra) # 5f9c <printf>
    exit(1);
    151a:	4505                	li	a0,1
    151c:	00004097          	auipc	ra,0x4
    1520:	710080e7          	jalr	1808(ra) # 5c2c <exit>
    printf("fork failed\n");
    1524:	00006517          	auipc	a0,0x6
    1528:	90450513          	addi	a0,a0,-1788 # 6e28 <malloc+0xdd4>
    152c:	00005097          	auipc	ra,0x5
    1530:	a70080e7          	jalr	-1424(ra) # 5f9c <printf>
    exit(1);
    1534:	4505                	li	a0,1
    1536:	00004097          	auipc	ra,0x4
    153a:	6f6080e7          	jalr	1782(ra) # 5c2c <exit>
    exit(747); // OK
    153e:	2eb00513          	li	a0,747
    1542:	00004097          	auipc	ra,0x4
    1546:	6ea080e7          	jalr	1770(ra) # 5c2c <exit>
  int st = 0;
    154a:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    154e:	f5440513          	addi	a0,s0,-172
    1552:	00004097          	auipc	ra,0x4
    1556:	6e2080e7          	jalr	1762(ra) # 5c34 <wait>
  if(st != 747){
    155a:	f5442703          	lw	a4,-172(s0)
    155e:	2eb00793          	li	a5,747
    1562:	00f71663          	bne	a4,a5,156e <copyinstr2+0x1dc>
}
    1566:	60ae                	ld	ra,200(sp)
    1568:	640e                	ld	s0,192(sp)
    156a:	6169                	addi	sp,sp,208
    156c:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    156e:	00005517          	auipc	a0,0x5
    1572:	48250513          	addi	a0,a0,1154 # 69f0 <malloc+0x99c>
    1576:	00005097          	auipc	ra,0x5
    157a:	a26080e7          	jalr	-1498(ra) # 5f9c <printf>
    exit(1);
    157e:	4505                	li	a0,1
    1580:	00004097          	auipc	ra,0x4
    1584:	6ac080e7          	jalr	1708(ra) # 5c2c <exit>

0000000000001588 <truncate3>:
{
    1588:	7159                	addi	sp,sp,-112
    158a:	f486                	sd	ra,104(sp)
    158c:	f0a2                	sd	s0,96(sp)
    158e:	e8ca                	sd	s2,80(sp)
    1590:	1880                	addi	s0,sp,112
    1592:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    1594:	60100593          	li	a1,1537
    1598:	00005517          	auipc	a0,0x5
    159c:	c5850513          	addi	a0,a0,-936 # 61f0 <malloc+0x19c>
    15a0:	00004097          	auipc	ra,0x4
    15a4:	6cc080e7          	jalr	1740(ra) # 5c6c <open>
    15a8:	00004097          	auipc	ra,0x4
    15ac:	6ac080e7          	jalr	1708(ra) # 5c54 <close>
  pid = fork();
    15b0:	00004097          	auipc	ra,0x4
    15b4:	674080e7          	jalr	1652(ra) # 5c24 <fork>
  if(pid < 0){
    15b8:	08054463          	bltz	a0,1640 <truncate3+0xb8>
  if(pid == 0){
    15bc:	e16d                	bnez	a0,169e <truncate3+0x116>
    15be:	eca6                	sd	s1,88(sp)
    15c0:	e4ce                	sd	s3,72(sp)
    15c2:	e0d2                	sd	s4,64(sp)
    15c4:	fc56                	sd	s5,56(sp)
    15c6:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    15ca:	00005a17          	auipc	s4,0x5
    15ce:	c26a0a13          	addi	s4,s4,-986 # 61f0 <malloc+0x19c>
      int n = write(fd, "1234567890", 10);
    15d2:	00005a97          	auipc	s5,0x5
    15d6:	47ea8a93          	addi	s5,s5,1150 # 6a50 <malloc+0x9fc>
      int fd = open("truncfile", O_WRONLY);
    15da:	4585                	li	a1,1
    15dc:	8552                	mv	a0,s4
    15de:	00004097          	auipc	ra,0x4
    15e2:	68e080e7          	jalr	1678(ra) # 5c6c <open>
    15e6:	84aa                	mv	s1,a0
      if(fd < 0){
    15e8:	06054e63          	bltz	a0,1664 <truncate3+0xdc>
      int n = write(fd, "1234567890", 10);
    15ec:	4629                	li	a2,10
    15ee:	85d6                	mv	a1,s5
    15f0:	00004097          	auipc	ra,0x4
    15f4:	65c080e7          	jalr	1628(ra) # 5c4c <write>
      if(n != 10){
    15f8:	47a9                	li	a5,10
    15fa:	08f51363          	bne	a0,a5,1680 <truncate3+0xf8>
      close(fd);
    15fe:	8526                	mv	a0,s1
    1600:	00004097          	auipc	ra,0x4
    1604:	654080e7          	jalr	1620(ra) # 5c54 <close>
      fd = open("truncfile", O_RDONLY);
    1608:	4581                	li	a1,0
    160a:	8552                	mv	a0,s4
    160c:	00004097          	auipc	ra,0x4
    1610:	660080e7          	jalr	1632(ra) # 5c6c <open>
    1614:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1616:	02000613          	li	a2,32
    161a:	f9840593          	addi	a1,s0,-104
    161e:	00004097          	auipc	ra,0x4
    1622:	626080e7          	jalr	1574(ra) # 5c44 <read>
      close(fd);
    1626:	8526                	mv	a0,s1
    1628:	00004097          	auipc	ra,0x4
    162c:	62c080e7          	jalr	1580(ra) # 5c54 <close>
    for(int i = 0; i < 100; i++){
    1630:	39fd                	addiw	s3,s3,-1
    1632:	fa0994e3          	bnez	s3,15da <truncate3+0x52>
    exit(0);
    1636:	4501                	li	a0,0
    1638:	00004097          	auipc	ra,0x4
    163c:	5f4080e7          	jalr	1524(ra) # 5c2c <exit>
    1640:	eca6                	sd	s1,88(sp)
    1642:	e4ce                	sd	s3,72(sp)
    1644:	e0d2                	sd	s4,64(sp)
    1646:	fc56                	sd	s5,56(sp)
    printf("%s: fork failed\n", s);
    1648:	85ca                	mv	a1,s2
    164a:	00005517          	auipc	a0,0x5
    164e:	3d650513          	addi	a0,a0,982 # 6a20 <malloc+0x9cc>
    1652:	00005097          	auipc	ra,0x5
    1656:	94a080e7          	jalr	-1718(ra) # 5f9c <printf>
    exit(1);
    165a:	4505                	li	a0,1
    165c:	00004097          	auipc	ra,0x4
    1660:	5d0080e7          	jalr	1488(ra) # 5c2c <exit>
        printf("%s: open failed\n", s);
    1664:	85ca                	mv	a1,s2
    1666:	00005517          	auipc	a0,0x5
    166a:	3d250513          	addi	a0,a0,978 # 6a38 <malloc+0x9e4>
    166e:	00005097          	auipc	ra,0x5
    1672:	92e080e7          	jalr	-1746(ra) # 5f9c <printf>
        exit(1);
    1676:	4505                	li	a0,1
    1678:	00004097          	auipc	ra,0x4
    167c:	5b4080e7          	jalr	1460(ra) # 5c2c <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1680:	862a                	mv	a2,a0
    1682:	85ca                	mv	a1,s2
    1684:	00005517          	auipc	a0,0x5
    1688:	3dc50513          	addi	a0,a0,988 # 6a60 <malloc+0xa0c>
    168c:	00005097          	auipc	ra,0x5
    1690:	910080e7          	jalr	-1776(ra) # 5f9c <printf>
        exit(1);
    1694:	4505                	li	a0,1
    1696:	00004097          	auipc	ra,0x4
    169a:	596080e7          	jalr	1430(ra) # 5c2c <exit>
    169e:	eca6                	sd	s1,88(sp)
    16a0:	e4ce                	sd	s3,72(sp)
    16a2:	e0d2                	sd	s4,64(sp)
    16a4:	fc56                	sd	s5,56(sp)
    16a6:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16aa:	00005a17          	auipc	s4,0x5
    16ae:	b46a0a13          	addi	s4,s4,-1210 # 61f0 <malloc+0x19c>
    int n = write(fd, "xxx", 3);
    16b2:	00005a97          	auipc	s5,0x5
    16b6:	3cea8a93          	addi	s5,s5,974 # 6a80 <malloc+0xa2c>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16ba:	60100593          	li	a1,1537
    16be:	8552                	mv	a0,s4
    16c0:	00004097          	auipc	ra,0x4
    16c4:	5ac080e7          	jalr	1452(ra) # 5c6c <open>
    16c8:	84aa                	mv	s1,a0
    if(fd < 0){
    16ca:	04054763          	bltz	a0,1718 <truncate3+0x190>
    int n = write(fd, "xxx", 3);
    16ce:	460d                	li	a2,3
    16d0:	85d6                	mv	a1,s5
    16d2:	00004097          	auipc	ra,0x4
    16d6:	57a080e7          	jalr	1402(ra) # 5c4c <write>
    if(n != 3){
    16da:	478d                	li	a5,3
    16dc:	04f51c63          	bne	a0,a5,1734 <truncate3+0x1ac>
    close(fd);
    16e0:	8526                	mv	a0,s1
    16e2:	00004097          	auipc	ra,0x4
    16e6:	572080e7          	jalr	1394(ra) # 5c54 <close>
  for(int i = 0; i < 150; i++){
    16ea:	39fd                	addiw	s3,s3,-1
    16ec:	fc0997e3          	bnez	s3,16ba <truncate3+0x132>
  wait(&xstatus);
    16f0:	fbc40513          	addi	a0,s0,-68
    16f4:	00004097          	auipc	ra,0x4
    16f8:	540080e7          	jalr	1344(ra) # 5c34 <wait>
  unlink("truncfile");
    16fc:	00005517          	auipc	a0,0x5
    1700:	af450513          	addi	a0,a0,-1292 # 61f0 <malloc+0x19c>
    1704:	00004097          	auipc	ra,0x4
    1708:	578080e7          	jalr	1400(ra) # 5c7c <unlink>
  exit(xstatus);
    170c:	fbc42503          	lw	a0,-68(s0)
    1710:	00004097          	auipc	ra,0x4
    1714:	51c080e7          	jalr	1308(ra) # 5c2c <exit>
      printf("%s: open failed\n", s);
    1718:	85ca                	mv	a1,s2
    171a:	00005517          	auipc	a0,0x5
    171e:	31e50513          	addi	a0,a0,798 # 6a38 <malloc+0x9e4>
    1722:	00005097          	auipc	ra,0x5
    1726:	87a080e7          	jalr	-1926(ra) # 5f9c <printf>
      exit(1);
    172a:	4505                	li	a0,1
    172c:	00004097          	auipc	ra,0x4
    1730:	500080e7          	jalr	1280(ra) # 5c2c <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1734:	862a                	mv	a2,a0
    1736:	85ca                	mv	a1,s2
    1738:	00005517          	auipc	a0,0x5
    173c:	35050513          	addi	a0,a0,848 # 6a88 <malloc+0xa34>
    1740:	00005097          	auipc	ra,0x5
    1744:	85c080e7          	jalr	-1956(ra) # 5f9c <printf>
      exit(1);
    1748:	4505                	li	a0,1
    174a:	00004097          	auipc	ra,0x4
    174e:	4e2080e7          	jalr	1250(ra) # 5c2c <exit>

0000000000001752 <exectest>:
{
    1752:	715d                	addi	sp,sp,-80
    1754:	e486                	sd	ra,72(sp)
    1756:	e0a2                	sd	s0,64(sp)
    1758:	f84a                	sd	s2,48(sp)
    175a:	0880                	addi	s0,sp,80
    175c:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    175e:	00005797          	auipc	a5,0x5
    1762:	a3a78793          	addi	a5,a5,-1478 # 6198 <malloc+0x144>
    1766:	fcf43023          	sd	a5,-64(s0)
    176a:	00005797          	auipc	a5,0x5
    176e:	33e78793          	addi	a5,a5,830 # 6aa8 <malloc+0xa54>
    1772:	fcf43423          	sd	a5,-56(s0)
    1776:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    177a:	00005517          	auipc	a0,0x5
    177e:	33650513          	addi	a0,a0,822 # 6ab0 <malloc+0xa5c>
    1782:	00004097          	auipc	ra,0x4
    1786:	4fa080e7          	jalr	1274(ra) # 5c7c <unlink>
  pid = fork();
    178a:	00004097          	auipc	ra,0x4
    178e:	49a080e7          	jalr	1178(ra) # 5c24 <fork>
  if(pid < 0) {
    1792:	04054763          	bltz	a0,17e0 <exectest+0x8e>
    1796:	fc26                	sd	s1,56(sp)
    1798:	84aa                	mv	s1,a0
  if(pid == 0) {
    179a:	ed41                	bnez	a0,1832 <exectest+0xe0>
    close(1);
    179c:	4505                	li	a0,1
    179e:	00004097          	auipc	ra,0x4
    17a2:	4b6080e7          	jalr	1206(ra) # 5c54 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    17a6:	20100593          	li	a1,513
    17aa:	00005517          	auipc	a0,0x5
    17ae:	30650513          	addi	a0,a0,774 # 6ab0 <malloc+0xa5c>
    17b2:	00004097          	auipc	ra,0x4
    17b6:	4ba080e7          	jalr	1210(ra) # 5c6c <open>
    if(fd < 0) {
    17ba:	04054263          	bltz	a0,17fe <exectest+0xac>
    if(fd != 1) {
    17be:	4785                	li	a5,1
    17c0:	04f50d63          	beq	a0,a5,181a <exectest+0xc8>
      printf("%s: wrong fd\n", s);
    17c4:	85ca                	mv	a1,s2
    17c6:	00005517          	auipc	a0,0x5
    17ca:	30a50513          	addi	a0,a0,778 # 6ad0 <malloc+0xa7c>
    17ce:	00004097          	auipc	ra,0x4
    17d2:	7ce080e7          	jalr	1998(ra) # 5f9c <printf>
      exit(1);
    17d6:	4505                	li	a0,1
    17d8:	00004097          	auipc	ra,0x4
    17dc:	454080e7          	jalr	1108(ra) # 5c2c <exit>
    17e0:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    17e2:	85ca                	mv	a1,s2
    17e4:	00005517          	auipc	a0,0x5
    17e8:	23c50513          	addi	a0,a0,572 # 6a20 <malloc+0x9cc>
    17ec:	00004097          	auipc	ra,0x4
    17f0:	7b0080e7          	jalr	1968(ra) # 5f9c <printf>
     exit(1);
    17f4:	4505                	li	a0,1
    17f6:	00004097          	auipc	ra,0x4
    17fa:	436080e7          	jalr	1078(ra) # 5c2c <exit>
      printf("%s: create failed\n", s);
    17fe:	85ca                	mv	a1,s2
    1800:	00005517          	auipc	a0,0x5
    1804:	2b850513          	addi	a0,a0,696 # 6ab8 <malloc+0xa64>
    1808:	00004097          	auipc	ra,0x4
    180c:	794080e7          	jalr	1940(ra) # 5f9c <printf>
      exit(1);
    1810:	4505                	li	a0,1
    1812:	00004097          	auipc	ra,0x4
    1816:	41a080e7          	jalr	1050(ra) # 5c2c <exit>
    if(exec("echo", echoargv) < 0){
    181a:	fc040593          	addi	a1,s0,-64
    181e:	00005517          	auipc	a0,0x5
    1822:	97a50513          	addi	a0,a0,-1670 # 6198 <malloc+0x144>
    1826:	00004097          	auipc	ra,0x4
    182a:	43e080e7          	jalr	1086(ra) # 5c64 <exec>
    182e:	02054163          	bltz	a0,1850 <exectest+0xfe>
  if (wait(&xstatus) != pid) {
    1832:	fdc40513          	addi	a0,s0,-36
    1836:	00004097          	auipc	ra,0x4
    183a:	3fe080e7          	jalr	1022(ra) # 5c34 <wait>
    183e:	02951763          	bne	a0,s1,186c <exectest+0x11a>
  if(xstatus != 0)
    1842:	fdc42503          	lw	a0,-36(s0)
    1846:	cd0d                	beqz	a0,1880 <exectest+0x12e>
    exit(xstatus);
    1848:	00004097          	auipc	ra,0x4
    184c:	3e4080e7          	jalr	996(ra) # 5c2c <exit>
      printf("%s: exec echo failed\n", s);
    1850:	85ca                	mv	a1,s2
    1852:	00005517          	auipc	a0,0x5
    1856:	28e50513          	addi	a0,a0,654 # 6ae0 <malloc+0xa8c>
    185a:	00004097          	auipc	ra,0x4
    185e:	742080e7          	jalr	1858(ra) # 5f9c <printf>
      exit(1);
    1862:	4505                	li	a0,1
    1864:	00004097          	auipc	ra,0x4
    1868:	3c8080e7          	jalr	968(ra) # 5c2c <exit>
    printf("%s: wait failed!\n", s);
    186c:	85ca                	mv	a1,s2
    186e:	00005517          	auipc	a0,0x5
    1872:	28a50513          	addi	a0,a0,650 # 6af8 <malloc+0xaa4>
    1876:	00004097          	auipc	ra,0x4
    187a:	726080e7          	jalr	1830(ra) # 5f9c <printf>
    187e:	b7d1                	j	1842 <exectest+0xf0>
  fd = open("echo-ok", O_RDONLY);
    1880:	4581                	li	a1,0
    1882:	00005517          	auipc	a0,0x5
    1886:	22e50513          	addi	a0,a0,558 # 6ab0 <malloc+0xa5c>
    188a:	00004097          	auipc	ra,0x4
    188e:	3e2080e7          	jalr	994(ra) # 5c6c <open>
  if(fd < 0) {
    1892:	02054a63          	bltz	a0,18c6 <exectest+0x174>
  if (read(fd, buf, 2) != 2) {
    1896:	4609                	li	a2,2
    1898:	fb840593          	addi	a1,s0,-72
    189c:	00004097          	auipc	ra,0x4
    18a0:	3a8080e7          	jalr	936(ra) # 5c44 <read>
    18a4:	4789                	li	a5,2
    18a6:	02f50e63          	beq	a0,a5,18e2 <exectest+0x190>
    printf("%s: read failed\n", s);
    18aa:	85ca                	mv	a1,s2
    18ac:	00005517          	auipc	a0,0x5
    18b0:	cbc50513          	addi	a0,a0,-836 # 6568 <malloc+0x514>
    18b4:	00004097          	auipc	ra,0x4
    18b8:	6e8080e7          	jalr	1768(ra) # 5f9c <printf>
    exit(1);
    18bc:	4505                	li	a0,1
    18be:	00004097          	auipc	ra,0x4
    18c2:	36e080e7          	jalr	878(ra) # 5c2c <exit>
    printf("%s: open failed\n", s);
    18c6:	85ca                	mv	a1,s2
    18c8:	00005517          	auipc	a0,0x5
    18cc:	17050513          	addi	a0,a0,368 # 6a38 <malloc+0x9e4>
    18d0:	00004097          	auipc	ra,0x4
    18d4:	6cc080e7          	jalr	1740(ra) # 5f9c <printf>
    exit(1);
    18d8:	4505                	li	a0,1
    18da:	00004097          	auipc	ra,0x4
    18de:	352080e7          	jalr	850(ra) # 5c2c <exit>
  unlink("echo-ok");
    18e2:	00005517          	auipc	a0,0x5
    18e6:	1ce50513          	addi	a0,a0,462 # 6ab0 <malloc+0xa5c>
    18ea:	00004097          	auipc	ra,0x4
    18ee:	392080e7          	jalr	914(ra) # 5c7c <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    18f2:	fb844703          	lbu	a4,-72(s0)
    18f6:	04f00793          	li	a5,79
    18fa:	00f71863          	bne	a4,a5,190a <exectest+0x1b8>
    18fe:	fb944703          	lbu	a4,-71(s0)
    1902:	04b00793          	li	a5,75
    1906:	02f70063          	beq	a4,a5,1926 <exectest+0x1d4>
    printf("%s: wrong output\n", s);
    190a:	85ca                	mv	a1,s2
    190c:	00005517          	auipc	a0,0x5
    1910:	20450513          	addi	a0,a0,516 # 6b10 <malloc+0xabc>
    1914:	00004097          	auipc	ra,0x4
    1918:	688080e7          	jalr	1672(ra) # 5f9c <printf>
    exit(1);
    191c:	4505                	li	a0,1
    191e:	00004097          	auipc	ra,0x4
    1922:	30e080e7          	jalr	782(ra) # 5c2c <exit>
    exit(0);
    1926:	4501                	li	a0,0
    1928:	00004097          	auipc	ra,0x4
    192c:	304080e7          	jalr	772(ra) # 5c2c <exit>

0000000000001930 <pipe1>:
{
    1930:	711d                	addi	sp,sp,-96
    1932:	ec86                	sd	ra,88(sp)
    1934:	e8a2                	sd	s0,80(sp)
    1936:	fc4e                	sd	s3,56(sp)
    1938:	1080                	addi	s0,sp,96
    193a:	89aa                	mv	s3,a0
  if(pipe(fds) != 0){
    193c:	fa840513          	addi	a0,s0,-88
    1940:	00004097          	auipc	ra,0x4
    1944:	2fc080e7          	jalr	764(ra) # 5c3c <pipe>
    1948:	ed3d                	bnez	a0,19c6 <pipe1+0x96>
    194a:	e4a6                	sd	s1,72(sp)
    194c:	f852                	sd	s4,48(sp)
    194e:	84aa                	mv	s1,a0
  pid = fork();
    1950:	00004097          	auipc	ra,0x4
    1954:	2d4080e7          	jalr	724(ra) # 5c24 <fork>
    1958:	8a2a                	mv	s4,a0
  if(pid == 0){
    195a:	c951                	beqz	a0,19ee <pipe1+0xbe>
  } else if(pid > 0){
    195c:	18a05b63          	blez	a0,1af2 <pipe1+0x1c2>
    1960:	e0ca                	sd	s2,64(sp)
    1962:	f456                	sd	s5,40(sp)
    close(fds[1]);
    1964:	fac42503          	lw	a0,-84(s0)
    1968:	00004097          	auipc	ra,0x4
    196c:	2ec080e7          	jalr	748(ra) # 5c54 <close>
    total = 0;
    1970:	8a26                	mv	s4,s1
    cc = 1;
    1972:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    1974:	0000ca97          	auipc	s5,0xc
    1978:	6a4a8a93          	addi	s5,s5,1700 # e018 <buf>
    197c:	864a                	mv	a2,s2
    197e:	85d6                	mv	a1,s5
    1980:	fa842503          	lw	a0,-88(s0)
    1984:	00004097          	auipc	ra,0x4
    1988:	2c0080e7          	jalr	704(ra) # 5c44 <read>
    198c:	10a05a63          	blez	a0,1aa0 <pipe1+0x170>
      for(i = 0; i < n; i++){
    1990:	0000c717          	auipc	a4,0xc
    1994:	68870713          	addi	a4,a4,1672 # e018 <buf>
    1998:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    199c:	00074683          	lbu	a3,0(a4)
    19a0:	0ff4f793          	zext.b	a5,s1
    19a4:	2485                	addiw	s1,s1,1
    19a6:	0cf69b63          	bne	a3,a5,1a7c <pipe1+0x14c>
      for(i = 0; i < n; i++){
    19aa:	0705                	addi	a4,a4,1
    19ac:	fec498e3          	bne	s1,a2,199c <pipe1+0x6c>
      total += n;
    19b0:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    19b4:	0019179b          	slliw	a5,s2,0x1
    19b8:	0007891b          	sext.w	s2,a5
      if(cc > sizeof(buf))
    19bc:	670d                	lui	a4,0x3
    19be:	fb277fe3          	bgeu	a4,s2,197c <pipe1+0x4c>
        cc = sizeof(buf);
    19c2:	690d                	lui	s2,0x3
    19c4:	bf65                	j	197c <pipe1+0x4c>
    19c6:	e4a6                	sd	s1,72(sp)
    19c8:	e0ca                	sd	s2,64(sp)
    19ca:	f852                	sd	s4,48(sp)
    19cc:	f456                	sd	s5,40(sp)
    19ce:	f05a                	sd	s6,32(sp)
    19d0:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    19d2:	85ce                	mv	a1,s3
    19d4:	00005517          	auipc	a0,0x5
    19d8:	15450513          	addi	a0,a0,340 # 6b28 <malloc+0xad4>
    19dc:	00004097          	auipc	ra,0x4
    19e0:	5c0080e7          	jalr	1472(ra) # 5f9c <printf>
    exit(1);
    19e4:	4505                	li	a0,1
    19e6:	00004097          	auipc	ra,0x4
    19ea:	246080e7          	jalr	582(ra) # 5c2c <exit>
    19ee:	e0ca                	sd	s2,64(sp)
    19f0:	f456                	sd	s5,40(sp)
    19f2:	f05a                	sd	s6,32(sp)
    19f4:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    19f6:	fa842503          	lw	a0,-88(s0)
    19fa:	00004097          	auipc	ra,0x4
    19fe:	25a080e7          	jalr	602(ra) # 5c54 <close>
    for(n = 0; n < N; n++){
    1a02:	0000cb17          	auipc	s6,0xc
    1a06:	616b0b13          	addi	s6,s6,1558 # e018 <buf>
    1a0a:	416004bb          	negw	s1,s6
    1a0e:	0ff4f493          	zext.b	s1,s1
    1a12:	409b0913          	addi	s2,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a16:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1a18:	6a85                	lui	s5,0x1
    1a1a:	42da8a93          	addi	s5,s5,1069 # 142d <copyinstr2+0x9b>
{
    1a1e:	87da                	mv	a5,s6
        buf[i] = seq++;
    1a20:	0097873b          	addw	a4,a5,s1
    1a24:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1a28:	0785                	addi	a5,a5,1
    1a2a:	ff279be3          	bne	a5,s2,1a20 <pipe1+0xf0>
    1a2e:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a32:	40900613          	li	a2,1033
    1a36:	85de                	mv	a1,s7
    1a38:	fac42503          	lw	a0,-84(s0)
    1a3c:	00004097          	auipc	ra,0x4
    1a40:	210080e7          	jalr	528(ra) # 5c4c <write>
    1a44:	40900793          	li	a5,1033
    1a48:	00f51c63          	bne	a0,a5,1a60 <pipe1+0x130>
    for(n = 0; n < N; n++){
    1a4c:	24a5                	addiw	s1,s1,9
    1a4e:	0ff4f493          	zext.b	s1,s1
    1a52:	fd5a16e3          	bne	s4,s5,1a1e <pipe1+0xee>
    exit(0);
    1a56:	4501                	li	a0,0
    1a58:	00004097          	auipc	ra,0x4
    1a5c:	1d4080e7          	jalr	468(ra) # 5c2c <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a60:	85ce                	mv	a1,s3
    1a62:	00005517          	auipc	a0,0x5
    1a66:	0de50513          	addi	a0,a0,222 # 6b40 <malloc+0xaec>
    1a6a:	00004097          	auipc	ra,0x4
    1a6e:	532080e7          	jalr	1330(ra) # 5f9c <printf>
        exit(1);
    1a72:	4505                	li	a0,1
    1a74:	00004097          	auipc	ra,0x4
    1a78:	1b8080e7          	jalr	440(ra) # 5c2c <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a7c:	85ce                	mv	a1,s3
    1a7e:	00005517          	auipc	a0,0x5
    1a82:	0da50513          	addi	a0,a0,218 # 6b58 <malloc+0xb04>
    1a86:	00004097          	auipc	ra,0x4
    1a8a:	516080e7          	jalr	1302(ra) # 5f9c <printf>
          return;
    1a8e:	64a6                	ld	s1,72(sp)
    1a90:	6906                	ld	s2,64(sp)
    1a92:	7a42                	ld	s4,48(sp)
    1a94:	7aa2                	ld	s5,40(sp)
}
    1a96:	60e6                	ld	ra,88(sp)
    1a98:	6446                	ld	s0,80(sp)
    1a9a:	79e2                	ld	s3,56(sp)
    1a9c:	6125                	addi	sp,sp,96
    1a9e:	8082                	ret
    if(total != N * SZ){
    1aa0:	6785                	lui	a5,0x1
    1aa2:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x9b>
    1aa6:	02fa0263          	beq	s4,a5,1aca <pipe1+0x19a>
    1aaa:	f05a                	sd	s6,32(sp)
    1aac:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", total);
    1aae:	85d2                	mv	a1,s4
    1ab0:	00005517          	auipc	a0,0x5
    1ab4:	0c050513          	addi	a0,a0,192 # 6b70 <malloc+0xb1c>
    1ab8:	00004097          	auipc	ra,0x4
    1abc:	4e4080e7          	jalr	1252(ra) # 5f9c <printf>
      exit(1);
    1ac0:	4505                	li	a0,1
    1ac2:	00004097          	auipc	ra,0x4
    1ac6:	16a080e7          	jalr	362(ra) # 5c2c <exit>
    1aca:	f05a                	sd	s6,32(sp)
    1acc:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1ace:	fa842503          	lw	a0,-88(s0)
    1ad2:	00004097          	auipc	ra,0x4
    1ad6:	182080e7          	jalr	386(ra) # 5c54 <close>
    wait(&xstatus);
    1ada:	fa440513          	addi	a0,s0,-92
    1ade:	00004097          	auipc	ra,0x4
    1ae2:	156080e7          	jalr	342(ra) # 5c34 <wait>
    exit(xstatus);
    1ae6:	fa442503          	lw	a0,-92(s0)
    1aea:	00004097          	auipc	ra,0x4
    1aee:	142080e7          	jalr	322(ra) # 5c2c <exit>
    1af2:	e0ca                	sd	s2,64(sp)
    1af4:	f456                	sd	s5,40(sp)
    1af6:	f05a                	sd	s6,32(sp)
    1af8:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    1afa:	85ce                	mv	a1,s3
    1afc:	00005517          	auipc	a0,0x5
    1b00:	09450513          	addi	a0,a0,148 # 6b90 <malloc+0xb3c>
    1b04:	00004097          	auipc	ra,0x4
    1b08:	498080e7          	jalr	1176(ra) # 5f9c <printf>
    exit(1);
    1b0c:	4505                	li	a0,1
    1b0e:	00004097          	auipc	ra,0x4
    1b12:	11e080e7          	jalr	286(ra) # 5c2c <exit>

0000000000001b16 <exitwait>:
{
    1b16:	7139                	addi	sp,sp,-64
    1b18:	fc06                	sd	ra,56(sp)
    1b1a:	f822                	sd	s0,48(sp)
    1b1c:	f426                	sd	s1,40(sp)
    1b1e:	f04a                	sd	s2,32(sp)
    1b20:	ec4e                	sd	s3,24(sp)
    1b22:	e852                	sd	s4,16(sp)
    1b24:	0080                	addi	s0,sp,64
    1b26:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1b28:	4901                	li	s2,0
    1b2a:	06400993          	li	s3,100
    pid = fork();
    1b2e:	00004097          	auipc	ra,0x4
    1b32:	0f6080e7          	jalr	246(ra) # 5c24 <fork>
    1b36:	84aa                	mv	s1,a0
    if(pid < 0){
    1b38:	02054a63          	bltz	a0,1b6c <exitwait+0x56>
    if(pid){
    1b3c:	c151                	beqz	a0,1bc0 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1b3e:	fcc40513          	addi	a0,s0,-52
    1b42:	00004097          	auipc	ra,0x4
    1b46:	0f2080e7          	jalr	242(ra) # 5c34 <wait>
    1b4a:	02951f63          	bne	a0,s1,1b88 <exitwait+0x72>
      if(i != xstate) {
    1b4e:	fcc42783          	lw	a5,-52(s0)
    1b52:	05279963          	bne	a5,s2,1ba4 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1b56:	2905                	addiw	s2,s2,1 # 3001 <execout+0x51>
    1b58:	fd391be3          	bne	s2,s3,1b2e <exitwait+0x18>
}
    1b5c:	70e2                	ld	ra,56(sp)
    1b5e:	7442                	ld	s0,48(sp)
    1b60:	74a2                	ld	s1,40(sp)
    1b62:	7902                	ld	s2,32(sp)
    1b64:	69e2                	ld	s3,24(sp)
    1b66:	6a42                	ld	s4,16(sp)
    1b68:	6121                	addi	sp,sp,64
    1b6a:	8082                	ret
      printf("%s: fork failed\n", s);
    1b6c:	85d2                	mv	a1,s4
    1b6e:	00005517          	auipc	a0,0x5
    1b72:	eb250513          	addi	a0,a0,-334 # 6a20 <malloc+0x9cc>
    1b76:	00004097          	auipc	ra,0x4
    1b7a:	426080e7          	jalr	1062(ra) # 5f9c <printf>
      exit(1);
    1b7e:	4505                	li	a0,1
    1b80:	00004097          	auipc	ra,0x4
    1b84:	0ac080e7          	jalr	172(ra) # 5c2c <exit>
        printf("%s: wait wrong pid\n", s);
    1b88:	85d2                	mv	a1,s4
    1b8a:	00005517          	auipc	a0,0x5
    1b8e:	01e50513          	addi	a0,a0,30 # 6ba8 <malloc+0xb54>
    1b92:	00004097          	auipc	ra,0x4
    1b96:	40a080e7          	jalr	1034(ra) # 5f9c <printf>
        exit(1);
    1b9a:	4505                	li	a0,1
    1b9c:	00004097          	auipc	ra,0x4
    1ba0:	090080e7          	jalr	144(ra) # 5c2c <exit>
        printf("%s: wait wrong exit status\n", s);
    1ba4:	85d2                	mv	a1,s4
    1ba6:	00005517          	auipc	a0,0x5
    1baa:	01a50513          	addi	a0,a0,26 # 6bc0 <malloc+0xb6c>
    1bae:	00004097          	auipc	ra,0x4
    1bb2:	3ee080e7          	jalr	1006(ra) # 5f9c <printf>
        exit(1);
    1bb6:	4505                	li	a0,1
    1bb8:	00004097          	auipc	ra,0x4
    1bbc:	074080e7          	jalr	116(ra) # 5c2c <exit>
      exit(i);
    1bc0:	854a                	mv	a0,s2
    1bc2:	00004097          	auipc	ra,0x4
    1bc6:	06a080e7          	jalr	106(ra) # 5c2c <exit>

0000000000001bca <twochildren>:
{
    1bca:	1101                	addi	sp,sp,-32
    1bcc:	ec06                	sd	ra,24(sp)
    1bce:	e822                	sd	s0,16(sp)
    1bd0:	e426                	sd	s1,8(sp)
    1bd2:	e04a                	sd	s2,0(sp)
    1bd4:	1000                	addi	s0,sp,32
    1bd6:	892a                	mv	s2,a0
    1bd8:	3e800493          	li	s1,1000
    int pid1 = fork();
    1bdc:	00004097          	auipc	ra,0x4
    1be0:	048080e7          	jalr	72(ra) # 5c24 <fork>
    if(pid1 < 0){
    1be4:	02054c63          	bltz	a0,1c1c <twochildren+0x52>
    if(pid1 == 0){
    1be8:	c921                	beqz	a0,1c38 <twochildren+0x6e>
      int pid2 = fork();
    1bea:	00004097          	auipc	ra,0x4
    1bee:	03a080e7          	jalr	58(ra) # 5c24 <fork>
      if(pid2 < 0){
    1bf2:	04054763          	bltz	a0,1c40 <twochildren+0x76>
      if(pid2 == 0){
    1bf6:	c13d                	beqz	a0,1c5c <twochildren+0x92>
        wait(0);
    1bf8:	4501                	li	a0,0
    1bfa:	00004097          	auipc	ra,0x4
    1bfe:	03a080e7          	jalr	58(ra) # 5c34 <wait>
        wait(0);
    1c02:	4501                	li	a0,0
    1c04:	00004097          	auipc	ra,0x4
    1c08:	030080e7          	jalr	48(ra) # 5c34 <wait>
  for(int i = 0; i < 1000; i++){
    1c0c:	34fd                	addiw	s1,s1,-1
    1c0e:	f4f9                	bnez	s1,1bdc <twochildren+0x12>
}
    1c10:	60e2                	ld	ra,24(sp)
    1c12:	6442                	ld	s0,16(sp)
    1c14:	64a2                	ld	s1,8(sp)
    1c16:	6902                	ld	s2,0(sp)
    1c18:	6105                	addi	sp,sp,32
    1c1a:	8082                	ret
      printf("%s: fork failed\n", s);
    1c1c:	85ca                	mv	a1,s2
    1c1e:	00005517          	auipc	a0,0x5
    1c22:	e0250513          	addi	a0,a0,-510 # 6a20 <malloc+0x9cc>
    1c26:	00004097          	auipc	ra,0x4
    1c2a:	376080e7          	jalr	886(ra) # 5f9c <printf>
      exit(1);
    1c2e:	4505                	li	a0,1
    1c30:	00004097          	auipc	ra,0x4
    1c34:	ffc080e7          	jalr	-4(ra) # 5c2c <exit>
      exit(0);
    1c38:	00004097          	auipc	ra,0x4
    1c3c:	ff4080e7          	jalr	-12(ra) # 5c2c <exit>
        printf("%s: fork failed\n", s);
    1c40:	85ca                	mv	a1,s2
    1c42:	00005517          	auipc	a0,0x5
    1c46:	dde50513          	addi	a0,a0,-546 # 6a20 <malloc+0x9cc>
    1c4a:	00004097          	auipc	ra,0x4
    1c4e:	352080e7          	jalr	850(ra) # 5f9c <printf>
        exit(1);
    1c52:	4505                	li	a0,1
    1c54:	00004097          	auipc	ra,0x4
    1c58:	fd8080e7          	jalr	-40(ra) # 5c2c <exit>
        exit(0);
    1c5c:	00004097          	auipc	ra,0x4
    1c60:	fd0080e7          	jalr	-48(ra) # 5c2c <exit>

0000000000001c64 <forkfork>:
{
    1c64:	7179                	addi	sp,sp,-48
    1c66:	f406                	sd	ra,40(sp)
    1c68:	f022                	sd	s0,32(sp)
    1c6a:	ec26                	sd	s1,24(sp)
    1c6c:	1800                	addi	s0,sp,48
    1c6e:	84aa                	mv	s1,a0
    int pid = fork();
    1c70:	00004097          	auipc	ra,0x4
    1c74:	fb4080e7          	jalr	-76(ra) # 5c24 <fork>
    if(pid < 0){
    1c78:	04054163          	bltz	a0,1cba <forkfork+0x56>
    if(pid == 0){
    1c7c:	cd29                	beqz	a0,1cd6 <forkfork+0x72>
    int pid = fork();
    1c7e:	00004097          	auipc	ra,0x4
    1c82:	fa6080e7          	jalr	-90(ra) # 5c24 <fork>
    if(pid < 0){
    1c86:	02054a63          	bltz	a0,1cba <forkfork+0x56>
    if(pid == 0){
    1c8a:	c531                	beqz	a0,1cd6 <forkfork+0x72>
    wait(&xstatus);
    1c8c:	fdc40513          	addi	a0,s0,-36
    1c90:	00004097          	auipc	ra,0x4
    1c94:	fa4080e7          	jalr	-92(ra) # 5c34 <wait>
    if(xstatus != 0) {
    1c98:	fdc42783          	lw	a5,-36(s0)
    1c9c:	ebbd                	bnez	a5,1d12 <forkfork+0xae>
    wait(&xstatus);
    1c9e:	fdc40513          	addi	a0,s0,-36
    1ca2:	00004097          	auipc	ra,0x4
    1ca6:	f92080e7          	jalr	-110(ra) # 5c34 <wait>
    if(xstatus != 0) {
    1caa:	fdc42783          	lw	a5,-36(s0)
    1cae:	e3b5                	bnez	a5,1d12 <forkfork+0xae>
}
    1cb0:	70a2                	ld	ra,40(sp)
    1cb2:	7402                	ld	s0,32(sp)
    1cb4:	64e2                	ld	s1,24(sp)
    1cb6:	6145                	addi	sp,sp,48
    1cb8:	8082                	ret
      printf("%s: fork failed", s);
    1cba:	85a6                	mv	a1,s1
    1cbc:	00005517          	auipc	a0,0x5
    1cc0:	f2450513          	addi	a0,a0,-220 # 6be0 <malloc+0xb8c>
    1cc4:	00004097          	auipc	ra,0x4
    1cc8:	2d8080e7          	jalr	728(ra) # 5f9c <printf>
      exit(1);
    1ccc:	4505                	li	a0,1
    1cce:	00004097          	auipc	ra,0x4
    1cd2:	f5e080e7          	jalr	-162(ra) # 5c2c <exit>
{
    1cd6:	0c800493          	li	s1,200
        int pid1 = fork();
    1cda:	00004097          	auipc	ra,0x4
    1cde:	f4a080e7          	jalr	-182(ra) # 5c24 <fork>
        if(pid1 < 0){
    1ce2:	00054f63          	bltz	a0,1d00 <forkfork+0x9c>
        if(pid1 == 0){
    1ce6:	c115                	beqz	a0,1d0a <forkfork+0xa6>
        wait(0);
    1ce8:	4501                	li	a0,0
    1cea:	00004097          	auipc	ra,0x4
    1cee:	f4a080e7          	jalr	-182(ra) # 5c34 <wait>
      for(int j = 0; j < 200; j++){
    1cf2:	34fd                	addiw	s1,s1,-1
    1cf4:	f0fd                	bnez	s1,1cda <forkfork+0x76>
      exit(0);
    1cf6:	4501                	li	a0,0
    1cf8:	00004097          	auipc	ra,0x4
    1cfc:	f34080e7          	jalr	-204(ra) # 5c2c <exit>
          exit(1);
    1d00:	4505                	li	a0,1
    1d02:	00004097          	auipc	ra,0x4
    1d06:	f2a080e7          	jalr	-214(ra) # 5c2c <exit>
          exit(0);
    1d0a:	00004097          	auipc	ra,0x4
    1d0e:	f22080e7          	jalr	-222(ra) # 5c2c <exit>
      printf("%s: fork in child failed", s);
    1d12:	85a6                	mv	a1,s1
    1d14:	00005517          	auipc	a0,0x5
    1d18:	edc50513          	addi	a0,a0,-292 # 6bf0 <malloc+0xb9c>
    1d1c:	00004097          	auipc	ra,0x4
    1d20:	280080e7          	jalr	640(ra) # 5f9c <printf>
      exit(1);
    1d24:	4505                	li	a0,1
    1d26:	00004097          	auipc	ra,0x4
    1d2a:	f06080e7          	jalr	-250(ra) # 5c2c <exit>

0000000000001d2e <reparent2>:
{
    1d2e:	1101                	addi	sp,sp,-32
    1d30:	ec06                	sd	ra,24(sp)
    1d32:	e822                	sd	s0,16(sp)
    1d34:	e426                	sd	s1,8(sp)
    1d36:	1000                	addi	s0,sp,32
    1d38:	32000493          	li	s1,800
    int pid1 = fork();
    1d3c:	00004097          	auipc	ra,0x4
    1d40:	ee8080e7          	jalr	-280(ra) # 5c24 <fork>
    if(pid1 < 0){
    1d44:	00054f63          	bltz	a0,1d62 <reparent2+0x34>
    if(pid1 == 0){
    1d48:	c915                	beqz	a0,1d7c <reparent2+0x4e>
    wait(0);
    1d4a:	4501                	li	a0,0
    1d4c:	00004097          	auipc	ra,0x4
    1d50:	ee8080e7          	jalr	-280(ra) # 5c34 <wait>
  for(int i = 0; i < 800; i++){
    1d54:	34fd                	addiw	s1,s1,-1
    1d56:	f0fd                	bnez	s1,1d3c <reparent2+0xe>
  exit(0);
    1d58:	4501                	li	a0,0
    1d5a:	00004097          	auipc	ra,0x4
    1d5e:	ed2080e7          	jalr	-302(ra) # 5c2c <exit>
      printf("fork failed\n");
    1d62:	00005517          	auipc	a0,0x5
    1d66:	0c650513          	addi	a0,a0,198 # 6e28 <malloc+0xdd4>
    1d6a:	00004097          	auipc	ra,0x4
    1d6e:	232080e7          	jalr	562(ra) # 5f9c <printf>
      exit(1);
    1d72:	4505                	li	a0,1
    1d74:	00004097          	auipc	ra,0x4
    1d78:	eb8080e7          	jalr	-328(ra) # 5c2c <exit>
      fork();
    1d7c:	00004097          	auipc	ra,0x4
    1d80:	ea8080e7          	jalr	-344(ra) # 5c24 <fork>
      fork();
    1d84:	00004097          	auipc	ra,0x4
    1d88:	ea0080e7          	jalr	-352(ra) # 5c24 <fork>
      exit(0);
    1d8c:	4501                	li	a0,0
    1d8e:	00004097          	auipc	ra,0x4
    1d92:	e9e080e7          	jalr	-354(ra) # 5c2c <exit>

0000000000001d96 <createdelete>:
{
    1d96:	7175                	addi	sp,sp,-144
    1d98:	e506                	sd	ra,136(sp)
    1d9a:	e122                	sd	s0,128(sp)
    1d9c:	fca6                	sd	s1,120(sp)
    1d9e:	f8ca                	sd	s2,112(sp)
    1da0:	f4ce                	sd	s3,104(sp)
    1da2:	f0d2                	sd	s4,96(sp)
    1da4:	ecd6                	sd	s5,88(sp)
    1da6:	e8da                	sd	s6,80(sp)
    1da8:	e4de                	sd	s7,72(sp)
    1daa:	e0e2                	sd	s8,64(sp)
    1dac:	fc66                	sd	s9,56(sp)
    1dae:	0900                	addi	s0,sp,144
    1db0:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1db2:	4901                	li	s2,0
    1db4:	4991                	li	s3,4
    pid = fork();
    1db6:	00004097          	auipc	ra,0x4
    1dba:	e6e080e7          	jalr	-402(ra) # 5c24 <fork>
    1dbe:	84aa                	mv	s1,a0
    if(pid < 0){
    1dc0:	02054f63          	bltz	a0,1dfe <createdelete+0x68>
    if(pid == 0){
    1dc4:	c939                	beqz	a0,1e1a <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1dc6:	2905                	addiw	s2,s2,1
    1dc8:	ff3917e3          	bne	s2,s3,1db6 <createdelete+0x20>
    1dcc:	4491                	li	s1,4
    wait(&xstatus);
    1dce:	f7c40513          	addi	a0,s0,-132
    1dd2:	00004097          	auipc	ra,0x4
    1dd6:	e62080e7          	jalr	-414(ra) # 5c34 <wait>
    if(xstatus != 0)
    1dda:	f7c42903          	lw	s2,-132(s0)
    1dde:	0e091263          	bnez	s2,1ec2 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1de2:	34fd                	addiw	s1,s1,-1
    1de4:	f4ed                	bnez	s1,1dce <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1de6:	f8040123          	sb	zero,-126(s0)
    1dea:	03000993          	li	s3,48
    1dee:	5a7d                	li	s4,-1
    1df0:	07000c13          	li	s8,112
      if((i == 0 || i >= N/2) && fd < 0){
    1df4:	4b25                	li	s6,9
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1df6:	4ba1                	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    1df8:	07400a93          	li	s5,116
    1dfc:	a28d                	j	1f5e <createdelete+0x1c8>
      printf("fork failed\n", s);
    1dfe:	85e6                	mv	a1,s9
    1e00:	00005517          	auipc	a0,0x5
    1e04:	02850513          	addi	a0,a0,40 # 6e28 <malloc+0xdd4>
    1e08:	00004097          	auipc	ra,0x4
    1e0c:	194080e7          	jalr	404(ra) # 5f9c <printf>
      exit(1);
    1e10:	4505                	li	a0,1
    1e12:	00004097          	auipc	ra,0x4
    1e16:	e1a080e7          	jalr	-486(ra) # 5c2c <exit>
      name[0] = 'p' + pi;
    1e1a:	0709091b          	addiw	s2,s2,112
    1e1e:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1e22:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1e26:	4951                	li	s2,20
    1e28:	a015                	j	1e4c <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1e2a:	85e6                	mv	a1,s9
    1e2c:	00005517          	auipc	a0,0x5
    1e30:	c8c50513          	addi	a0,a0,-884 # 6ab8 <malloc+0xa64>
    1e34:	00004097          	auipc	ra,0x4
    1e38:	168080e7          	jalr	360(ra) # 5f9c <printf>
          exit(1);
    1e3c:	4505                	li	a0,1
    1e3e:	00004097          	auipc	ra,0x4
    1e42:	dee080e7          	jalr	-530(ra) # 5c2c <exit>
      for(i = 0; i < N; i++){
    1e46:	2485                	addiw	s1,s1,1
    1e48:	07248863          	beq	s1,s2,1eb8 <createdelete+0x122>
        name[1] = '0' + i;
    1e4c:	0304879b          	addiw	a5,s1,48
    1e50:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e54:	20200593          	li	a1,514
    1e58:	f8040513          	addi	a0,s0,-128
    1e5c:	00004097          	auipc	ra,0x4
    1e60:	e10080e7          	jalr	-496(ra) # 5c6c <open>
        if(fd < 0){
    1e64:	fc0543e3          	bltz	a0,1e2a <createdelete+0x94>
        close(fd);
    1e68:	00004097          	auipc	ra,0x4
    1e6c:	dec080e7          	jalr	-532(ra) # 5c54 <close>
        if(i > 0 && (i % 2 ) == 0){
    1e70:	12905763          	blez	s1,1f9e <createdelete+0x208>
    1e74:	0014f793          	andi	a5,s1,1
    1e78:	f7f9                	bnez	a5,1e46 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1e7a:	01f4d79b          	srliw	a5,s1,0x1f
    1e7e:	9fa5                	addw	a5,a5,s1
    1e80:	4017d79b          	sraiw	a5,a5,0x1
    1e84:	0307879b          	addiw	a5,a5,48
    1e88:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1e8c:	f8040513          	addi	a0,s0,-128
    1e90:	00004097          	auipc	ra,0x4
    1e94:	dec080e7          	jalr	-532(ra) # 5c7c <unlink>
    1e98:	fa0557e3          	bgez	a0,1e46 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1e9c:	85e6                	mv	a1,s9
    1e9e:	00005517          	auipc	a0,0x5
    1ea2:	d7250513          	addi	a0,a0,-654 # 6c10 <malloc+0xbbc>
    1ea6:	00004097          	auipc	ra,0x4
    1eaa:	0f6080e7          	jalr	246(ra) # 5f9c <printf>
            exit(1);
    1eae:	4505                	li	a0,1
    1eb0:	00004097          	auipc	ra,0x4
    1eb4:	d7c080e7          	jalr	-644(ra) # 5c2c <exit>
      exit(0);
    1eb8:	4501                	li	a0,0
    1eba:	00004097          	auipc	ra,0x4
    1ebe:	d72080e7          	jalr	-654(ra) # 5c2c <exit>
      exit(1);
    1ec2:	4505                	li	a0,1
    1ec4:	00004097          	auipc	ra,0x4
    1ec8:	d68080e7          	jalr	-664(ra) # 5c2c <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1ecc:	f8040613          	addi	a2,s0,-128
    1ed0:	85e6                	mv	a1,s9
    1ed2:	00005517          	auipc	a0,0x5
    1ed6:	d5650513          	addi	a0,a0,-682 # 6c28 <malloc+0xbd4>
    1eda:	00004097          	auipc	ra,0x4
    1ede:	0c2080e7          	jalr	194(ra) # 5f9c <printf>
        exit(1);
    1ee2:	4505                	li	a0,1
    1ee4:	00004097          	auipc	ra,0x4
    1ee8:	d48080e7          	jalr	-696(ra) # 5c2c <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1eec:	034bff63          	bgeu	s7,s4,1f2a <createdelete+0x194>
      if(fd >= 0)
    1ef0:	02055863          	bgez	a0,1f20 <createdelete+0x18a>
    for(pi = 0; pi < NCHILD; pi++){
    1ef4:	2485                	addiw	s1,s1,1
    1ef6:	0ff4f493          	zext.b	s1,s1
    1efa:	05548a63          	beq	s1,s5,1f4e <createdelete+0x1b8>
      name[0] = 'p' + pi;
    1efe:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1f02:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1f06:	4581                	li	a1,0
    1f08:	f8040513          	addi	a0,s0,-128
    1f0c:	00004097          	auipc	ra,0x4
    1f10:	d60080e7          	jalr	-672(ra) # 5c6c <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1f14:	00090463          	beqz	s2,1f1c <createdelete+0x186>
    1f18:	fd2b5ae3          	bge	s6,s2,1eec <createdelete+0x156>
    1f1c:	fa0548e3          	bltz	a0,1ecc <createdelete+0x136>
        close(fd);
    1f20:	00004097          	auipc	ra,0x4
    1f24:	d34080e7          	jalr	-716(ra) # 5c54 <close>
    1f28:	b7f1                	j	1ef4 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f2a:	fc0545e3          	bltz	a0,1ef4 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f2e:	f8040613          	addi	a2,s0,-128
    1f32:	85e6                	mv	a1,s9
    1f34:	00005517          	auipc	a0,0x5
    1f38:	d1c50513          	addi	a0,a0,-740 # 6c50 <malloc+0xbfc>
    1f3c:	00004097          	auipc	ra,0x4
    1f40:	060080e7          	jalr	96(ra) # 5f9c <printf>
        exit(1);
    1f44:	4505                	li	a0,1
    1f46:	00004097          	auipc	ra,0x4
    1f4a:	ce6080e7          	jalr	-794(ra) # 5c2c <exit>
  for(i = 0; i < N; i++){
    1f4e:	2905                	addiw	s2,s2,1
    1f50:	2a05                	addiw	s4,s4,1
    1f52:	2985                	addiw	s3,s3,1
    1f54:	0ff9f993          	zext.b	s3,s3
    1f58:	47d1                	li	a5,20
    1f5a:	02f90a63          	beq	s2,a5,1f8e <createdelete+0x1f8>
    for(pi = 0; pi < NCHILD; pi++){
    1f5e:	84e2                	mv	s1,s8
    1f60:	bf79                	j	1efe <createdelete+0x168>
  for(i = 0; i < N; i++){
    1f62:	2905                	addiw	s2,s2,1
    1f64:	0ff97913          	zext.b	s2,s2
    1f68:	2985                	addiw	s3,s3,1
    1f6a:	0ff9f993          	zext.b	s3,s3
    1f6e:	03490a63          	beq	s2,s4,1fa2 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1f72:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1f74:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1f78:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1f7c:	f8040513          	addi	a0,s0,-128
    1f80:	00004097          	auipc	ra,0x4
    1f84:	cfc080e7          	jalr	-772(ra) # 5c7c <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1f88:	34fd                	addiw	s1,s1,-1
    1f8a:	f4ed                	bnez	s1,1f74 <createdelete+0x1de>
    1f8c:	bfd9                	j	1f62 <createdelete+0x1cc>
    1f8e:	03000993          	li	s3,48
    1f92:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1f96:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1f98:	08400a13          	li	s4,132
    1f9c:	bfd9                	j	1f72 <createdelete+0x1dc>
      for(i = 0; i < N; i++){
    1f9e:	2485                	addiw	s1,s1,1
    1fa0:	b575                	j	1e4c <createdelete+0xb6>
}
    1fa2:	60aa                	ld	ra,136(sp)
    1fa4:	640a                	ld	s0,128(sp)
    1fa6:	74e6                	ld	s1,120(sp)
    1fa8:	7946                	ld	s2,112(sp)
    1faa:	79a6                	ld	s3,104(sp)
    1fac:	7a06                	ld	s4,96(sp)
    1fae:	6ae6                	ld	s5,88(sp)
    1fb0:	6b46                	ld	s6,80(sp)
    1fb2:	6ba6                	ld	s7,72(sp)
    1fb4:	6c06                	ld	s8,64(sp)
    1fb6:	7ce2                	ld	s9,56(sp)
    1fb8:	6149                	addi	sp,sp,144
    1fba:	8082                	ret

0000000000001fbc <linkunlink>:
{
    1fbc:	711d                	addi	sp,sp,-96
    1fbe:	ec86                	sd	ra,88(sp)
    1fc0:	e8a2                	sd	s0,80(sp)
    1fc2:	e4a6                	sd	s1,72(sp)
    1fc4:	e0ca                	sd	s2,64(sp)
    1fc6:	fc4e                	sd	s3,56(sp)
    1fc8:	f852                	sd	s4,48(sp)
    1fca:	f456                	sd	s5,40(sp)
    1fcc:	f05a                	sd	s6,32(sp)
    1fce:	ec5e                	sd	s7,24(sp)
    1fd0:	e862                	sd	s8,16(sp)
    1fd2:	e466                	sd	s9,8(sp)
    1fd4:	1080                	addi	s0,sp,96
    1fd6:	84aa                	mv	s1,a0
  unlink("x");
    1fd8:	00004517          	auipc	a0,0x4
    1fdc:	23050513          	addi	a0,a0,560 # 6208 <malloc+0x1b4>
    1fe0:	00004097          	auipc	ra,0x4
    1fe4:	c9c080e7          	jalr	-868(ra) # 5c7c <unlink>
  pid = fork();
    1fe8:	00004097          	auipc	ra,0x4
    1fec:	c3c080e7          	jalr	-964(ra) # 5c24 <fork>
  if(pid < 0){
    1ff0:	02054b63          	bltz	a0,2026 <linkunlink+0x6a>
    1ff4:	8caa                	mv	s9,a0
  unsigned int x = (pid ? 1 : 97);
    1ff6:	06100913          	li	s2,97
    1ffa:	c111                	beqz	a0,1ffe <linkunlink+0x42>
    1ffc:	4905                	li	s2,1
    1ffe:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    2002:	41c65a37          	lui	s4,0x41c65
    2006:	e6da0a1b          	addiw	s4,s4,-403 # 41c64e6d <base+0x41c53e55>
    200a:	698d                	lui	s3,0x3
    200c:	0399899b          	addiw	s3,s3,57 # 3039 <execout+0x89>
    if((x % 3) == 0){
    2010:	4a8d                	li	s5,3
    } else if((x % 3) == 1){
    2012:	4b85                	li	s7,1
      unlink("x");
    2014:	00004b17          	auipc	s6,0x4
    2018:	1f4b0b13          	addi	s6,s6,500 # 6208 <malloc+0x1b4>
      link("cat", "x");
    201c:	00005c17          	auipc	s8,0x5
    2020:	c5cc0c13          	addi	s8,s8,-932 # 6c78 <malloc+0xc24>
    2024:	a825                	j	205c <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    2026:	85a6                	mv	a1,s1
    2028:	00005517          	auipc	a0,0x5
    202c:	9f850513          	addi	a0,a0,-1544 # 6a20 <malloc+0x9cc>
    2030:	00004097          	auipc	ra,0x4
    2034:	f6c080e7          	jalr	-148(ra) # 5f9c <printf>
    exit(1);
    2038:	4505                	li	a0,1
    203a:	00004097          	auipc	ra,0x4
    203e:	bf2080e7          	jalr	-1038(ra) # 5c2c <exit>
      close(open("x", O_RDWR | O_CREATE));
    2042:	20200593          	li	a1,514
    2046:	855a                	mv	a0,s6
    2048:	00004097          	auipc	ra,0x4
    204c:	c24080e7          	jalr	-988(ra) # 5c6c <open>
    2050:	00004097          	auipc	ra,0x4
    2054:	c04080e7          	jalr	-1020(ra) # 5c54 <close>
  for(i = 0; i < 100; i++){
    2058:	34fd                	addiw	s1,s1,-1
    205a:	c895                	beqz	s1,208e <linkunlink+0xd2>
    x = x * 1103515245 + 12345;
    205c:	034907bb          	mulw	a5,s2,s4
    2060:	013787bb          	addw	a5,a5,s3
    2064:	0007891b          	sext.w	s2,a5
    if((x % 3) == 0){
    2068:	0357f7bb          	remuw	a5,a5,s5
    206c:	2781                	sext.w	a5,a5
    206e:	dbf1                	beqz	a5,2042 <linkunlink+0x86>
    } else if((x % 3) == 1){
    2070:	01778863          	beq	a5,s7,2080 <linkunlink+0xc4>
      unlink("x");
    2074:	855a                	mv	a0,s6
    2076:	00004097          	auipc	ra,0x4
    207a:	c06080e7          	jalr	-1018(ra) # 5c7c <unlink>
    207e:	bfe9                	j	2058 <linkunlink+0x9c>
      link("cat", "x");
    2080:	85da                	mv	a1,s6
    2082:	8562                	mv	a0,s8
    2084:	00004097          	auipc	ra,0x4
    2088:	c08080e7          	jalr	-1016(ra) # 5c8c <link>
    208c:	b7f1                	j	2058 <linkunlink+0x9c>
  if(pid)
    208e:	020c8463          	beqz	s9,20b6 <linkunlink+0xfa>
    wait(0);
    2092:	4501                	li	a0,0
    2094:	00004097          	auipc	ra,0x4
    2098:	ba0080e7          	jalr	-1120(ra) # 5c34 <wait>
}
    209c:	60e6                	ld	ra,88(sp)
    209e:	6446                	ld	s0,80(sp)
    20a0:	64a6                	ld	s1,72(sp)
    20a2:	6906                	ld	s2,64(sp)
    20a4:	79e2                	ld	s3,56(sp)
    20a6:	7a42                	ld	s4,48(sp)
    20a8:	7aa2                	ld	s5,40(sp)
    20aa:	7b02                	ld	s6,32(sp)
    20ac:	6be2                	ld	s7,24(sp)
    20ae:	6c42                	ld	s8,16(sp)
    20b0:	6ca2                	ld	s9,8(sp)
    20b2:	6125                	addi	sp,sp,96
    20b4:	8082                	ret
    exit(0);
    20b6:	4501                	li	a0,0
    20b8:	00004097          	auipc	ra,0x4
    20bc:	b74080e7          	jalr	-1164(ra) # 5c2c <exit>

00000000000020c0 <forktest>:
{
    20c0:	7179                	addi	sp,sp,-48
    20c2:	f406                	sd	ra,40(sp)
    20c4:	f022                	sd	s0,32(sp)
    20c6:	ec26                	sd	s1,24(sp)
    20c8:	e84a                	sd	s2,16(sp)
    20ca:	e44e                	sd	s3,8(sp)
    20cc:	1800                	addi	s0,sp,48
    20ce:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    20d0:	4481                	li	s1,0
    20d2:	3e800913          	li	s2,1000
    pid = fork();
    20d6:	00004097          	auipc	ra,0x4
    20da:	b4e080e7          	jalr	-1202(ra) # 5c24 <fork>
    if(pid < 0)
    20de:	08054263          	bltz	a0,2162 <forktest+0xa2>
    if(pid == 0)
    20e2:	c115                	beqz	a0,2106 <forktest+0x46>
  for(n=0; n<N; n++){
    20e4:	2485                	addiw	s1,s1,1
    20e6:	ff2498e3          	bne	s1,s2,20d6 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    20ea:	85ce                	mv	a1,s3
    20ec:	00005517          	auipc	a0,0x5
    20f0:	bdc50513          	addi	a0,a0,-1060 # 6cc8 <malloc+0xc74>
    20f4:	00004097          	auipc	ra,0x4
    20f8:	ea8080e7          	jalr	-344(ra) # 5f9c <printf>
    exit(1);
    20fc:	4505                	li	a0,1
    20fe:	00004097          	auipc	ra,0x4
    2102:	b2e080e7          	jalr	-1234(ra) # 5c2c <exit>
      exit(0);
    2106:	00004097          	auipc	ra,0x4
    210a:	b26080e7          	jalr	-1242(ra) # 5c2c <exit>
    printf("%s: no fork at all!\n", s);
    210e:	85ce                	mv	a1,s3
    2110:	00005517          	auipc	a0,0x5
    2114:	b7050513          	addi	a0,a0,-1168 # 6c80 <malloc+0xc2c>
    2118:	00004097          	auipc	ra,0x4
    211c:	e84080e7          	jalr	-380(ra) # 5f9c <printf>
    exit(1);
    2120:	4505                	li	a0,1
    2122:	00004097          	auipc	ra,0x4
    2126:	b0a080e7          	jalr	-1270(ra) # 5c2c <exit>
      printf("%s: wait stopped early\n", s);
    212a:	85ce                	mv	a1,s3
    212c:	00005517          	auipc	a0,0x5
    2130:	b6c50513          	addi	a0,a0,-1172 # 6c98 <malloc+0xc44>
    2134:	00004097          	auipc	ra,0x4
    2138:	e68080e7          	jalr	-408(ra) # 5f9c <printf>
      exit(1);
    213c:	4505                	li	a0,1
    213e:	00004097          	auipc	ra,0x4
    2142:	aee080e7          	jalr	-1298(ra) # 5c2c <exit>
    printf("%s: wait got too many\n", s);
    2146:	85ce                	mv	a1,s3
    2148:	00005517          	auipc	a0,0x5
    214c:	b6850513          	addi	a0,a0,-1176 # 6cb0 <malloc+0xc5c>
    2150:	00004097          	auipc	ra,0x4
    2154:	e4c080e7          	jalr	-436(ra) # 5f9c <printf>
    exit(1);
    2158:	4505                	li	a0,1
    215a:	00004097          	auipc	ra,0x4
    215e:	ad2080e7          	jalr	-1326(ra) # 5c2c <exit>
  if (n == 0) {
    2162:	d4d5                	beqz	s1,210e <forktest+0x4e>
  for(; n > 0; n--){
    2164:	00905b63          	blez	s1,217a <forktest+0xba>
    if(wait(0) < 0){
    2168:	4501                	li	a0,0
    216a:	00004097          	auipc	ra,0x4
    216e:	aca080e7          	jalr	-1334(ra) # 5c34 <wait>
    2172:	fa054ce3          	bltz	a0,212a <forktest+0x6a>
  for(; n > 0; n--){
    2176:	34fd                	addiw	s1,s1,-1
    2178:	f8e5                	bnez	s1,2168 <forktest+0xa8>
  if(wait(0) != -1){
    217a:	4501                	li	a0,0
    217c:	00004097          	auipc	ra,0x4
    2180:	ab8080e7          	jalr	-1352(ra) # 5c34 <wait>
    2184:	57fd                	li	a5,-1
    2186:	fcf510e3          	bne	a0,a5,2146 <forktest+0x86>
}
    218a:	70a2                	ld	ra,40(sp)
    218c:	7402                	ld	s0,32(sp)
    218e:	64e2                	ld	s1,24(sp)
    2190:	6942                	ld	s2,16(sp)
    2192:	69a2                	ld	s3,8(sp)
    2194:	6145                	addi	sp,sp,48
    2196:	8082                	ret

0000000000002198 <kernmem>:
{
    2198:	715d                	addi	sp,sp,-80
    219a:	e486                	sd	ra,72(sp)
    219c:	e0a2                	sd	s0,64(sp)
    219e:	fc26                	sd	s1,56(sp)
    21a0:	f84a                	sd	s2,48(sp)
    21a2:	f44e                	sd	s3,40(sp)
    21a4:	f052                	sd	s4,32(sp)
    21a6:	ec56                	sd	s5,24(sp)
    21a8:	0880                	addi	s0,sp,80
    21aa:	8aaa                	mv	s5,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21ac:	4485                	li	s1,1
    21ae:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    21b0:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21b2:	69b1                	lui	s3,0xc
    21b4:	35098993          	addi	s3,s3,848 # c350 <uninit+0xa48>
    21b8:	1003d937          	lui	s2,0x1003d
    21bc:	090e                	slli	s2,s2,0x3
    21be:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002c468>
    pid = fork();
    21c2:	00004097          	auipc	ra,0x4
    21c6:	a62080e7          	jalr	-1438(ra) # 5c24 <fork>
    if(pid < 0){
    21ca:	02054963          	bltz	a0,21fc <kernmem+0x64>
    if(pid == 0){
    21ce:	c529                	beqz	a0,2218 <kernmem+0x80>
    wait(&xstatus);
    21d0:	fbc40513          	addi	a0,s0,-68
    21d4:	00004097          	auipc	ra,0x4
    21d8:	a60080e7          	jalr	-1440(ra) # 5c34 <wait>
    if(xstatus != -1)  // did kernel kill child?
    21dc:	fbc42783          	lw	a5,-68(s0)
    21e0:	05479d63          	bne	a5,s4,223a <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21e4:	94ce                	add	s1,s1,s3
    21e6:	fd249ee3          	bne	s1,s2,21c2 <kernmem+0x2a>
}
    21ea:	60a6                	ld	ra,72(sp)
    21ec:	6406                	ld	s0,64(sp)
    21ee:	74e2                	ld	s1,56(sp)
    21f0:	7942                	ld	s2,48(sp)
    21f2:	79a2                	ld	s3,40(sp)
    21f4:	7a02                	ld	s4,32(sp)
    21f6:	6ae2                	ld	s5,24(sp)
    21f8:	6161                	addi	sp,sp,80
    21fa:	8082                	ret
      printf("%s: fork failed\n", s);
    21fc:	85d6                	mv	a1,s5
    21fe:	00005517          	auipc	a0,0x5
    2202:	82250513          	addi	a0,a0,-2014 # 6a20 <malloc+0x9cc>
    2206:	00004097          	auipc	ra,0x4
    220a:	d96080e7          	jalr	-618(ra) # 5f9c <printf>
      exit(1);
    220e:	4505                	li	a0,1
    2210:	00004097          	auipc	ra,0x4
    2214:	a1c080e7          	jalr	-1508(ra) # 5c2c <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    2218:	0004c683          	lbu	a3,0(s1)
    221c:	8626                	mv	a2,s1
    221e:	85d6                	mv	a1,s5
    2220:	00005517          	auipc	a0,0x5
    2224:	ad050513          	addi	a0,a0,-1328 # 6cf0 <malloc+0xc9c>
    2228:	00004097          	auipc	ra,0x4
    222c:	d74080e7          	jalr	-652(ra) # 5f9c <printf>
      exit(1);
    2230:	4505                	li	a0,1
    2232:	00004097          	auipc	ra,0x4
    2236:	9fa080e7          	jalr	-1542(ra) # 5c2c <exit>
      exit(1);
    223a:	4505                	li	a0,1
    223c:	00004097          	auipc	ra,0x4
    2240:	9f0080e7          	jalr	-1552(ra) # 5c2c <exit>

0000000000002244 <MAXVAplus>:
{
    2244:	7179                	addi	sp,sp,-48
    2246:	f406                	sd	ra,40(sp)
    2248:	f022                	sd	s0,32(sp)
    224a:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    224c:	4785                	li	a5,1
    224e:	179a                	slli	a5,a5,0x26
    2250:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2254:	fd843783          	ld	a5,-40(s0)
    2258:	c3a1                	beqz	a5,2298 <MAXVAplus+0x54>
    225a:	ec26                	sd	s1,24(sp)
    225c:	e84a                	sd	s2,16(sp)
    225e:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    2260:	54fd                	li	s1,-1
    pid = fork();
    2262:	00004097          	auipc	ra,0x4
    2266:	9c2080e7          	jalr	-1598(ra) # 5c24 <fork>
    if(pid < 0){
    226a:	02054b63          	bltz	a0,22a0 <MAXVAplus+0x5c>
    if(pid == 0){
    226e:	c539                	beqz	a0,22bc <MAXVAplus+0x78>
    wait(&xstatus);
    2270:	fd440513          	addi	a0,s0,-44
    2274:	00004097          	auipc	ra,0x4
    2278:	9c0080e7          	jalr	-1600(ra) # 5c34 <wait>
    if(xstatus != -1)  // did kernel kill child?
    227c:	fd442783          	lw	a5,-44(s0)
    2280:	06979463          	bne	a5,s1,22e8 <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    2284:	fd843783          	ld	a5,-40(s0)
    2288:	0786                	slli	a5,a5,0x1
    228a:	fcf43c23          	sd	a5,-40(s0)
    228e:	fd843783          	ld	a5,-40(s0)
    2292:	fbe1                	bnez	a5,2262 <MAXVAplus+0x1e>
    2294:	64e2                	ld	s1,24(sp)
    2296:	6942                	ld	s2,16(sp)
}
    2298:	70a2                	ld	ra,40(sp)
    229a:	7402                	ld	s0,32(sp)
    229c:	6145                	addi	sp,sp,48
    229e:	8082                	ret
      printf("%s: fork failed\n", s);
    22a0:	85ca                	mv	a1,s2
    22a2:	00004517          	auipc	a0,0x4
    22a6:	77e50513          	addi	a0,a0,1918 # 6a20 <malloc+0x9cc>
    22aa:	00004097          	auipc	ra,0x4
    22ae:	cf2080e7          	jalr	-782(ra) # 5f9c <printf>
      exit(1);
    22b2:	4505                	li	a0,1
    22b4:	00004097          	auipc	ra,0x4
    22b8:	978080e7          	jalr	-1672(ra) # 5c2c <exit>
      *(char*)a = 99;
    22bc:	fd843783          	ld	a5,-40(s0)
    22c0:	06300713          	li	a4,99
    22c4:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    22c8:	fd843603          	ld	a2,-40(s0)
    22cc:	85ca                	mv	a1,s2
    22ce:	00005517          	auipc	a0,0x5
    22d2:	a4250513          	addi	a0,a0,-1470 # 6d10 <malloc+0xcbc>
    22d6:	00004097          	auipc	ra,0x4
    22da:	cc6080e7          	jalr	-826(ra) # 5f9c <printf>
      exit(1);
    22de:	4505                	li	a0,1
    22e0:	00004097          	auipc	ra,0x4
    22e4:	94c080e7          	jalr	-1716(ra) # 5c2c <exit>
      exit(1);
    22e8:	4505                	li	a0,1
    22ea:	00004097          	auipc	ra,0x4
    22ee:	942080e7          	jalr	-1726(ra) # 5c2c <exit>

00000000000022f2 <bigargtest>:
{
    22f2:	7179                	addi	sp,sp,-48
    22f4:	f406                	sd	ra,40(sp)
    22f6:	f022                	sd	s0,32(sp)
    22f8:	ec26                	sd	s1,24(sp)
    22fa:	1800                	addi	s0,sp,48
    22fc:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    22fe:	00005517          	auipc	a0,0x5
    2302:	a2a50513          	addi	a0,a0,-1494 # 6d28 <malloc+0xcd4>
    2306:	00004097          	auipc	ra,0x4
    230a:	976080e7          	jalr	-1674(ra) # 5c7c <unlink>
  pid = fork();
    230e:	00004097          	auipc	ra,0x4
    2312:	916080e7          	jalr	-1770(ra) # 5c24 <fork>
  if(pid == 0){
    2316:	c121                	beqz	a0,2356 <bigargtest+0x64>
  } else if(pid < 0){
    2318:	0a054063          	bltz	a0,23b8 <bigargtest+0xc6>
  wait(&xstatus);
    231c:	fdc40513          	addi	a0,s0,-36
    2320:	00004097          	auipc	ra,0x4
    2324:	914080e7          	jalr	-1772(ra) # 5c34 <wait>
  if(xstatus != 0)
    2328:	fdc42503          	lw	a0,-36(s0)
    232c:	e545                	bnez	a0,23d4 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    232e:	4581                	li	a1,0
    2330:	00005517          	auipc	a0,0x5
    2334:	9f850513          	addi	a0,a0,-1544 # 6d28 <malloc+0xcd4>
    2338:	00004097          	auipc	ra,0x4
    233c:	934080e7          	jalr	-1740(ra) # 5c6c <open>
  if(fd < 0){
    2340:	08054e63          	bltz	a0,23dc <bigargtest+0xea>
  close(fd);
    2344:	00004097          	auipc	ra,0x4
    2348:	910080e7          	jalr	-1776(ra) # 5c54 <close>
}
    234c:	70a2                	ld	ra,40(sp)
    234e:	7402                	ld	s0,32(sp)
    2350:	64e2                	ld	s1,24(sp)
    2352:	6145                	addi	sp,sp,48
    2354:	8082                	ret
    2356:	00008797          	auipc	a5,0x8
    235a:	4aa78793          	addi	a5,a5,1194 # a800 <args.1>
    235e:	00008697          	auipc	a3,0x8
    2362:	59a68693          	addi	a3,a3,1434 # a8f8 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2366:	00005717          	auipc	a4,0x5
    236a:	9d270713          	addi	a4,a4,-1582 # 6d38 <malloc+0xce4>
    236e:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2370:	07a1                	addi	a5,a5,8
    2372:	fed79ee3          	bne	a5,a3,236e <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2376:	00008597          	auipc	a1,0x8
    237a:	48a58593          	addi	a1,a1,1162 # a800 <args.1>
    237e:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2382:	00004517          	auipc	a0,0x4
    2386:	e1650513          	addi	a0,a0,-490 # 6198 <malloc+0x144>
    238a:	00004097          	auipc	ra,0x4
    238e:	8da080e7          	jalr	-1830(ra) # 5c64 <exec>
    fd = open("bigarg-ok", O_CREATE);
    2392:	20000593          	li	a1,512
    2396:	00005517          	auipc	a0,0x5
    239a:	99250513          	addi	a0,a0,-1646 # 6d28 <malloc+0xcd4>
    239e:	00004097          	auipc	ra,0x4
    23a2:	8ce080e7          	jalr	-1842(ra) # 5c6c <open>
    close(fd);
    23a6:	00004097          	auipc	ra,0x4
    23aa:	8ae080e7          	jalr	-1874(ra) # 5c54 <close>
    exit(0);
    23ae:	4501                	li	a0,0
    23b0:	00004097          	auipc	ra,0x4
    23b4:	87c080e7          	jalr	-1924(ra) # 5c2c <exit>
    printf("%s: bigargtest: fork failed\n", s);
    23b8:	85a6                	mv	a1,s1
    23ba:	00005517          	auipc	a0,0x5
    23be:	a5e50513          	addi	a0,a0,-1442 # 6e18 <malloc+0xdc4>
    23c2:	00004097          	auipc	ra,0x4
    23c6:	bda080e7          	jalr	-1062(ra) # 5f9c <printf>
    exit(1);
    23ca:	4505                	li	a0,1
    23cc:	00004097          	auipc	ra,0x4
    23d0:	860080e7          	jalr	-1952(ra) # 5c2c <exit>
    exit(xstatus);
    23d4:	00004097          	auipc	ra,0x4
    23d8:	858080e7          	jalr	-1960(ra) # 5c2c <exit>
    printf("%s: bigarg test failed!\n", s);
    23dc:	85a6                	mv	a1,s1
    23de:	00005517          	auipc	a0,0x5
    23e2:	a5a50513          	addi	a0,a0,-1446 # 6e38 <malloc+0xde4>
    23e6:	00004097          	auipc	ra,0x4
    23ea:	bb6080e7          	jalr	-1098(ra) # 5f9c <printf>
    exit(1);
    23ee:	4505                	li	a0,1
    23f0:	00004097          	auipc	ra,0x4
    23f4:	83c080e7          	jalr	-1988(ra) # 5c2c <exit>

00000000000023f8 <stacktest>:
{
    23f8:	7179                	addi	sp,sp,-48
    23fa:	f406                	sd	ra,40(sp)
    23fc:	f022                	sd	s0,32(sp)
    23fe:	ec26                	sd	s1,24(sp)
    2400:	1800                	addi	s0,sp,48
    2402:	84aa                	mv	s1,a0
  pid = fork();
    2404:	00004097          	auipc	ra,0x4
    2408:	820080e7          	jalr	-2016(ra) # 5c24 <fork>
  if(pid == 0) {
    240c:	c115                	beqz	a0,2430 <stacktest+0x38>
  } else if(pid < 0){
    240e:	04054463          	bltz	a0,2456 <stacktest+0x5e>
  wait(&xstatus);
    2412:	fdc40513          	addi	a0,s0,-36
    2416:	00004097          	auipc	ra,0x4
    241a:	81e080e7          	jalr	-2018(ra) # 5c34 <wait>
  if(xstatus == -1)  // kernel killed child?
    241e:	fdc42503          	lw	a0,-36(s0)
    2422:	57fd                	li	a5,-1
    2424:	04f50763          	beq	a0,a5,2472 <stacktest+0x7a>
    exit(xstatus);
    2428:	00004097          	auipc	ra,0x4
    242c:	804080e7          	jalr	-2044(ra) # 5c2c <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2430:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2432:	77fd                	lui	a5,0xfffff
    2434:	97ba                	add	a5,a5,a4
    2436:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffedfe8>
    243a:	85a6                	mv	a1,s1
    243c:	00005517          	auipc	a0,0x5
    2440:	a1c50513          	addi	a0,a0,-1508 # 6e58 <malloc+0xe04>
    2444:	00004097          	auipc	ra,0x4
    2448:	b58080e7          	jalr	-1192(ra) # 5f9c <printf>
    exit(1);
    244c:	4505                	li	a0,1
    244e:	00003097          	auipc	ra,0x3
    2452:	7de080e7          	jalr	2014(ra) # 5c2c <exit>
    printf("%s: fork failed\n", s);
    2456:	85a6                	mv	a1,s1
    2458:	00004517          	auipc	a0,0x4
    245c:	5c850513          	addi	a0,a0,1480 # 6a20 <malloc+0x9cc>
    2460:	00004097          	auipc	ra,0x4
    2464:	b3c080e7          	jalr	-1220(ra) # 5f9c <printf>
    exit(1);
    2468:	4505                	li	a0,1
    246a:	00003097          	auipc	ra,0x3
    246e:	7c2080e7          	jalr	1986(ra) # 5c2c <exit>
    exit(0);
    2472:	4501                	li	a0,0
    2474:	00003097          	auipc	ra,0x3
    2478:	7b8080e7          	jalr	1976(ra) # 5c2c <exit>

000000000000247c <textwrite>:
{
    247c:	7179                	addi	sp,sp,-48
    247e:	f406                	sd	ra,40(sp)
    2480:	f022                	sd	s0,32(sp)
    2482:	ec26                	sd	s1,24(sp)
    2484:	1800                	addi	s0,sp,48
    2486:	84aa                	mv	s1,a0
  pid = fork();
    2488:	00003097          	auipc	ra,0x3
    248c:	79c080e7          	jalr	1948(ra) # 5c24 <fork>
  if(pid == 0) {
    2490:	c115                	beqz	a0,24b4 <textwrite+0x38>
  } else if(pid < 0){
    2492:	02054963          	bltz	a0,24c4 <textwrite+0x48>
  wait(&xstatus);
    2496:	fdc40513          	addi	a0,s0,-36
    249a:	00003097          	auipc	ra,0x3
    249e:	79a080e7          	jalr	1946(ra) # 5c34 <wait>
  if(xstatus == -1)  // kernel killed child?
    24a2:	fdc42503          	lw	a0,-36(s0)
    24a6:	57fd                	li	a5,-1
    24a8:	02f50c63          	beq	a0,a5,24e0 <textwrite+0x64>
    exit(xstatus);
    24ac:	00003097          	auipc	ra,0x3
    24b0:	780080e7          	jalr	1920(ra) # 5c2c <exit>
    *addr = 10;
    24b4:	47a9                	li	a5,10
    24b6:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    24ba:	4505                	li	a0,1
    24bc:	00003097          	auipc	ra,0x3
    24c0:	770080e7          	jalr	1904(ra) # 5c2c <exit>
    printf("%s: fork failed\n", s);
    24c4:	85a6                	mv	a1,s1
    24c6:	00004517          	auipc	a0,0x4
    24ca:	55a50513          	addi	a0,a0,1370 # 6a20 <malloc+0x9cc>
    24ce:	00004097          	auipc	ra,0x4
    24d2:	ace080e7          	jalr	-1330(ra) # 5f9c <printf>
    exit(1);
    24d6:	4505                	li	a0,1
    24d8:	00003097          	auipc	ra,0x3
    24dc:	754080e7          	jalr	1876(ra) # 5c2c <exit>
    exit(0);
    24e0:	4501                	li	a0,0
    24e2:	00003097          	auipc	ra,0x3
    24e6:	74a080e7          	jalr	1866(ra) # 5c2c <exit>

00000000000024ea <manywrites>:
{
    24ea:	711d                	addi	sp,sp,-96
    24ec:	ec86                	sd	ra,88(sp)
    24ee:	e8a2                	sd	s0,80(sp)
    24f0:	e4a6                	sd	s1,72(sp)
    24f2:	e0ca                	sd	s2,64(sp)
    24f4:	fc4e                	sd	s3,56(sp)
    24f6:	f456                	sd	s5,40(sp)
    24f8:	1080                	addi	s0,sp,96
    24fa:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    24fc:	4981                	li	s3,0
    24fe:	4911                	li	s2,4
    int pid = fork();
    2500:	00003097          	auipc	ra,0x3
    2504:	724080e7          	jalr	1828(ra) # 5c24 <fork>
    2508:	84aa                	mv	s1,a0
    if(pid < 0){
    250a:	02054d63          	bltz	a0,2544 <manywrites+0x5a>
    if(pid == 0){
    250e:	c939                	beqz	a0,2564 <manywrites+0x7a>
  for(int ci = 0; ci < nchildren; ci++){
    2510:	2985                	addiw	s3,s3,1
    2512:	ff2997e3          	bne	s3,s2,2500 <manywrites+0x16>
    2516:	f852                	sd	s4,48(sp)
    2518:	f05a                	sd	s6,32(sp)
    251a:	ec5e                	sd	s7,24(sp)
    251c:	4491                	li	s1,4
    int st = 0;
    251e:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    2522:	fa840513          	addi	a0,s0,-88
    2526:	00003097          	auipc	ra,0x3
    252a:	70e080e7          	jalr	1806(ra) # 5c34 <wait>
    if(st != 0)
    252e:	fa842503          	lw	a0,-88(s0)
    2532:	10051463          	bnez	a0,263a <manywrites+0x150>
  for(int ci = 0; ci < nchildren; ci++){
    2536:	34fd                	addiw	s1,s1,-1
    2538:	f0fd                	bnez	s1,251e <manywrites+0x34>
  exit(0);
    253a:	4501                	li	a0,0
    253c:	00003097          	auipc	ra,0x3
    2540:	6f0080e7          	jalr	1776(ra) # 5c2c <exit>
    2544:	f852                	sd	s4,48(sp)
    2546:	f05a                	sd	s6,32(sp)
    2548:	ec5e                	sd	s7,24(sp)
      printf("fork failed\n");
    254a:	00005517          	auipc	a0,0x5
    254e:	8de50513          	addi	a0,a0,-1826 # 6e28 <malloc+0xdd4>
    2552:	00004097          	auipc	ra,0x4
    2556:	a4a080e7          	jalr	-1462(ra) # 5f9c <printf>
      exit(1);
    255a:	4505                	li	a0,1
    255c:	00003097          	auipc	ra,0x3
    2560:	6d0080e7          	jalr	1744(ra) # 5c2c <exit>
    2564:	f852                	sd	s4,48(sp)
    2566:	f05a                	sd	s6,32(sp)
    2568:	ec5e                	sd	s7,24(sp)
      name[0] = 'b';
    256a:	06200793          	li	a5,98
    256e:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    2572:	0619879b          	addiw	a5,s3,97
    2576:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    257a:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    257e:	fa840513          	addi	a0,s0,-88
    2582:	00003097          	auipc	ra,0x3
    2586:	6fa080e7          	jalr	1786(ra) # 5c7c <unlink>
    258a:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    258c:	0000cb17          	auipc	s6,0xc
    2590:	a8cb0b13          	addi	s6,s6,-1396 # e018 <buf>
        for(int i = 0; i < ci+1; i++){
    2594:	8a26                	mv	s4,s1
    2596:	0209ce63          	bltz	s3,25d2 <manywrites+0xe8>
          int fd = open(name, O_CREATE | O_RDWR);
    259a:	20200593          	li	a1,514
    259e:	fa840513          	addi	a0,s0,-88
    25a2:	00003097          	auipc	ra,0x3
    25a6:	6ca080e7          	jalr	1738(ra) # 5c6c <open>
    25aa:	892a                	mv	s2,a0
          if(fd < 0){
    25ac:	04054763          	bltz	a0,25fa <manywrites+0x110>
          int cc = write(fd, buf, sz);
    25b0:	660d                	lui	a2,0x3
    25b2:	85da                	mv	a1,s6
    25b4:	00003097          	auipc	ra,0x3
    25b8:	698080e7          	jalr	1688(ra) # 5c4c <write>
          if(cc != sz){
    25bc:	678d                	lui	a5,0x3
    25be:	04f51e63          	bne	a0,a5,261a <manywrites+0x130>
          close(fd);
    25c2:	854a                	mv	a0,s2
    25c4:	00003097          	auipc	ra,0x3
    25c8:	690080e7          	jalr	1680(ra) # 5c54 <close>
        for(int i = 0; i < ci+1; i++){
    25cc:	2a05                	addiw	s4,s4,1
    25ce:	fd49d6e3          	bge	s3,s4,259a <manywrites+0xb0>
        unlink(name);
    25d2:	fa840513          	addi	a0,s0,-88
    25d6:	00003097          	auipc	ra,0x3
    25da:	6a6080e7          	jalr	1702(ra) # 5c7c <unlink>
      for(int iters = 0; iters < howmany; iters++){
    25de:	3bfd                	addiw	s7,s7,-1
    25e0:	fa0b9ae3          	bnez	s7,2594 <manywrites+0xaa>
      unlink(name);
    25e4:	fa840513          	addi	a0,s0,-88
    25e8:	00003097          	auipc	ra,0x3
    25ec:	694080e7          	jalr	1684(ra) # 5c7c <unlink>
      exit(0);
    25f0:	4501                	li	a0,0
    25f2:	00003097          	auipc	ra,0x3
    25f6:	63a080e7          	jalr	1594(ra) # 5c2c <exit>
            printf("%s: cannot create %s\n", s, name);
    25fa:	fa840613          	addi	a2,s0,-88
    25fe:	85d6                	mv	a1,s5
    2600:	00005517          	auipc	a0,0x5
    2604:	88050513          	addi	a0,a0,-1920 # 6e80 <malloc+0xe2c>
    2608:	00004097          	auipc	ra,0x4
    260c:	994080e7          	jalr	-1644(ra) # 5f9c <printf>
            exit(1);
    2610:	4505                	li	a0,1
    2612:	00003097          	auipc	ra,0x3
    2616:	61a080e7          	jalr	1562(ra) # 5c2c <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    261a:	86aa                	mv	a3,a0
    261c:	660d                	lui	a2,0x3
    261e:	85d6                	mv	a1,s5
    2620:	00004517          	auipc	a0,0x4
    2624:	c4850513          	addi	a0,a0,-952 # 6268 <malloc+0x214>
    2628:	00004097          	auipc	ra,0x4
    262c:	974080e7          	jalr	-1676(ra) # 5f9c <printf>
            exit(1);
    2630:	4505                	li	a0,1
    2632:	00003097          	auipc	ra,0x3
    2636:	5fa080e7          	jalr	1530(ra) # 5c2c <exit>
      exit(st);
    263a:	00003097          	auipc	ra,0x3
    263e:	5f2080e7          	jalr	1522(ra) # 5c2c <exit>

0000000000002642 <copyinstr3>:
{
    2642:	7179                	addi	sp,sp,-48
    2644:	f406                	sd	ra,40(sp)
    2646:	f022                	sd	s0,32(sp)
    2648:	ec26                	sd	s1,24(sp)
    264a:	1800                	addi	s0,sp,48
  sbrk(8192);
    264c:	6509                	lui	a0,0x2
    264e:	00003097          	auipc	ra,0x3
    2652:	666080e7          	jalr	1638(ra) # 5cb4 <sbrk>
  uint64 top = (uint64) sbrk(0);
    2656:	4501                	li	a0,0
    2658:	00003097          	auipc	ra,0x3
    265c:	65c080e7          	jalr	1628(ra) # 5cb4 <sbrk>
  if((top % PGSIZE) != 0){
    2660:	03451793          	slli	a5,a0,0x34
    2664:	e3c9                	bnez	a5,26e6 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2666:	4501                	li	a0,0
    2668:	00003097          	auipc	ra,0x3
    266c:	64c080e7          	jalr	1612(ra) # 5cb4 <sbrk>
  if(top % PGSIZE){
    2670:	03451793          	slli	a5,a0,0x34
    2674:	e3d9                	bnez	a5,26fa <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2676:	fff50493          	addi	s1,a0,-1 # 1fff <linkunlink+0x43>
  *b = 'x';
    267a:	07800793          	li	a5,120
    267e:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2682:	8526                	mv	a0,s1
    2684:	00003097          	auipc	ra,0x3
    2688:	5f8080e7          	jalr	1528(ra) # 5c7c <unlink>
  if(ret != -1){
    268c:	57fd                	li	a5,-1
    268e:	08f51363          	bne	a0,a5,2714 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2692:	20100593          	li	a1,513
    2696:	8526                	mv	a0,s1
    2698:	00003097          	auipc	ra,0x3
    269c:	5d4080e7          	jalr	1492(ra) # 5c6c <open>
  if(fd != -1){
    26a0:	57fd                	li	a5,-1
    26a2:	08f51863          	bne	a0,a5,2732 <copyinstr3+0xf0>
  ret = link(b, b);
    26a6:	85a6                	mv	a1,s1
    26a8:	8526                	mv	a0,s1
    26aa:	00003097          	auipc	ra,0x3
    26ae:	5e2080e7          	jalr	1506(ra) # 5c8c <link>
  if(ret != -1){
    26b2:	57fd                	li	a5,-1
    26b4:	08f51e63          	bne	a0,a5,2750 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    26b8:	00005797          	auipc	a5,0x5
    26bc:	4c078793          	addi	a5,a5,1216 # 7b78 <malloc+0x1b24>
    26c0:	fcf43823          	sd	a5,-48(s0)
    26c4:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    26c8:	fd040593          	addi	a1,s0,-48
    26cc:	8526                	mv	a0,s1
    26ce:	00003097          	auipc	ra,0x3
    26d2:	596080e7          	jalr	1430(ra) # 5c64 <exec>
  if(ret != -1){
    26d6:	57fd                	li	a5,-1
    26d8:	08f51c63          	bne	a0,a5,2770 <copyinstr3+0x12e>
}
    26dc:	70a2                	ld	ra,40(sp)
    26de:	7402                	ld	s0,32(sp)
    26e0:	64e2                	ld	s1,24(sp)
    26e2:	6145                	addi	sp,sp,48
    26e4:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    26e6:	0347d513          	srli	a0,a5,0x34
    26ea:	6785                	lui	a5,0x1
    26ec:	40a7853b          	subw	a0,a5,a0
    26f0:	00003097          	auipc	ra,0x3
    26f4:	5c4080e7          	jalr	1476(ra) # 5cb4 <sbrk>
    26f8:	b7bd                	j	2666 <copyinstr3+0x24>
    printf("oops\n");
    26fa:	00004517          	auipc	a0,0x4
    26fe:	79e50513          	addi	a0,a0,1950 # 6e98 <malloc+0xe44>
    2702:	00004097          	auipc	ra,0x4
    2706:	89a080e7          	jalr	-1894(ra) # 5f9c <printf>
    exit(1);
    270a:	4505                	li	a0,1
    270c:	00003097          	auipc	ra,0x3
    2710:	520080e7          	jalr	1312(ra) # 5c2c <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2714:	862a                	mv	a2,a0
    2716:	85a6                	mv	a1,s1
    2718:	00004517          	auipc	a0,0x4
    271c:	22850513          	addi	a0,a0,552 # 6940 <malloc+0x8ec>
    2720:	00004097          	auipc	ra,0x4
    2724:	87c080e7          	jalr	-1924(ra) # 5f9c <printf>
    exit(1);
    2728:	4505                	li	a0,1
    272a:	00003097          	auipc	ra,0x3
    272e:	502080e7          	jalr	1282(ra) # 5c2c <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2732:	862a                	mv	a2,a0
    2734:	85a6                	mv	a1,s1
    2736:	00004517          	auipc	a0,0x4
    273a:	22a50513          	addi	a0,a0,554 # 6960 <malloc+0x90c>
    273e:	00004097          	auipc	ra,0x4
    2742:	85e080e7          	jalr	-1954(ra) # 5f9c <printf>
    exit(1);
    2746:	4505                	li	a0,1
    2748:	00003097          	auipc	ra,0x3
    274c:	4e4080e7          	jalr	1252(ra) # 5c2c <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2750:	86aa                	mv	a3,a0
    2752:	8626                	mv	a2,s1
    2754:	85a6                	mv	a1,s1
    2756:	00004517          	auipc	a0,0x4
    275a:	22a50513          	addi	a0,a0,554 # 6980 <malloc+0x92c>
    275e:	00004097          	auipc	ra,0x4
    2762:	83e080e7          	jalr	-1986(ra) # 5f9c <printf>
    exit(1);
    2766:	4505                	li	a0,1
    2768:	00003097          	auipc	ra,0x3
    276c:	4c4080e7          	jalr	1220(ra) # 5c2c <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2770:	567d                	li	a2,-1
    2772:	85a6                	mv	a1,s1
    2774:	00004517          	auipc	a0,0x4
    2778:	23450513          	addi	a0,a0,564 # 69a8 <malloc+0x954>
    277c:	00004097          	auipc	ra,0x4
    2780:	820080e7          	jalr	-2016(ra) # 5f9c <printf>
    exit(1);
    2784:	4505                	li	a0,1
    2786:	00003097          	auipc	ra,0x3
    278a:	4a6080e7          	jalr	1190(ra) # 5c2c <exit>

000000000000278e <rwsbrk>:
{
    278e:	1101                	addi	sp,sp,-32
    2790:	ec06                	sd	ra,24(sp)
    2792:	e822                	sd	s0,16(sp)
    2794:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2796:	6509                	lui	a0,0x2
    2798:	00003097          	auipc	ra,0x3
    279c:	51c080e7          	jalr	1308(ra) # 5cb4 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    27a0:	57fd                	li	a5,-1
    27a2:	06f50463          	beq	a0,a5,280a <rwsbrk+0x7c>
    27a6:	e426                	sd	s1,8(sp)
    27a8:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    27aa:	7579                	lui	a0,0xffffe
    27ac:	00003097          	auipc	ra,0x3
    27b0:	508080e7          	jalr	1288(ra) # 5cb4 <sbrk>
    27b4:	57fd                	li	a5,-1
    27b6:	06f50963          	beq	a0,a5,2828 <rwsbrk+0x9a>
    27ba:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    27bc:	20100593          	li	a1,513
    27c0:	00004517          	auipc	a0,0x4
    27c4:	71850513          	addi	a0,a0,1816 # 6ed8 <malloc+0xe84>
    27c8:	00003097          	auipc	ra,0x3
    27cc:	4a4080e7          	jalr	1188(ra) # 5c6c <open>
    27d0:	892a                	mv	s2,a0
  if(fd < 0){
    27d2:	06054963          	bltz	a0,2844 <rwsbrk+0xb6>
  n = write(fd, (void*)(a+4096), 1024);
    27d6:	6785                	lui	a5,0x1
    27d8:	94be                	add	s1,s1,a5
    27da:	40000613          	li	a2,1024
    27de:	85a6                	mv	a1,s1
    27e0:	00003097          	auipc	ra,0x3
    27e4:	46c080e7          	jalr	1132(ra) # 5c4c <write>
    27e8:	862a                	mv	a2,a0
  if(n >= 0){
    27ea:	06054a63          	bltz	a0,285e <rwsbrk+0xd0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    27ee:	85a6                	mv	a1,s1
    27f0:	00004517          	auipc	a0,0x4
    27f4:	70850513          	addi	a0,a0,1800 # 6ef8 <malloc+0xea4>
    27f8:	00003097          	auipc	ra,0x3
    27fc:	7a4080e7          	jalr	1956(ra) # 5f9c <printf>
    exit(1);
    2800:	4505                	li	a0,1
    2802:	00003097          	auipc	ra,0x3
    2806:	42a080e7          	jalr	1066(ra) # 5c2c <exit>
    280a:	e426                	sd	s1,8(sp)
    280c:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    280e:	00004517          	auipc	a0,0x4
    2812:	69250513          	addi	a0,a0,1682 # 6ea0 <malloc+0xe4c>
    2816:	00003097          	auipc	ra,0x3
    281a:	786080e7          	jalr	1926(ra) # 5f9c <printf>
    exit(1);
    281e:	4505                	li	a0,1
    2820:	00003097          	auipc	ra,0x3
    2824:	40c080e7          	jalr	1036(ra) # 5c2c <exit>
    2828:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    282a:	00004517          	auipc	a0,0x4
    282e:	68e50513          	addi	a0,a0,1678 # 6eb8 <malloc+0xe64>
    2832:	00003097          	auipc	ra,0x3
    2836:	76a080e7          	jalr	1898(ra) # 5f9c <printf>
    exit(1);
    283a:	4505                	li	a0,1
    283c:	00003097          	auipc	ra,0x3
    2840:	3f0080e7          	jalr	1008(ra) # 5c2c <exit>
    printf("open(rwsbrk) failed\n");
    2844:	00004517          	auipc	a0,0x4
    2848:	69c50513          	addi	a0,a0,1692 # 6ee0 <malloc+0xe8c>
    284c:	00003097          	auipc	ra,0x3
    2850:	750080e7          	jalr	1872(ra) # 5f9c <printf>
    exit(1);
    2854:	4505                	li	a0,1
    2856:	00003097          	auipc	ra,0x3
    285a:	3d6080e7          	jalr	982(ra) # 5c2c <exit>
  close(fd);
    285e:	854a                	mv	a0,s2
    2860:	00003097          	auipc	ra,0x3
    2864:	3f4080e7          	jalr	1012(ra) # 5c54 <close>
  unlink("rwsbrk");
    2868:	00004517          	auipc	a0,0x4
    286c:	67050513          	addi	a0,a0,1648 # 6ed8 <malloc+0xe84>
    2870:	00003097          	auipc	ra,0x3
    2874:	40c080e7          	jalr	1036(ra) # 5c7c <unlink>
  fd = open("README", O_RDONLY);
    2878:	4581                	li	a1,0
    287a:	00004517          	auipc	a0,0x4
    287e:	af650513          	addi	a0,a0,-1290 # 6370 <malloc+0x31c>
    2882:	00003097          	auipc	ra,0x3
    2886:	3ea080e7          	jalr	1002(ra) # 5c6c <open>
    288a:	892a                	mv	s2,a0
  if(fd < 0){
    288c:	02054963          	bltz	a0,28be <rwsbrk+0x130>
  n = read(fd, (void*)(a+4096), 10);
    2890:	4629                	li	a2,10
    2892:	85a6                	mv	a1,s1
    2894:	00003097          	auipc	ra,0x3
    2898:	3b0080e7          	jalr	944(ra) # 5c44 <read>
    289c:	862a                	mv	a2,a0
  if(n >= 0){
    289e:	02054d63          	bltz	a0,28d8 <rwsbrk+0x14a>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    28a2:	85a6                	mv	a1,s1
    28a4:	00004517          	auipc	a0,0x4
    28a8:	68450513          	addi	a0,a0,1668 # 6f28 <malloc+0xed4>
    28ac:	00003097          	auipc	ra,0x3
    28b0:	6f0080e7          	jalr	1776(ra) # 5f9c <printf>
    exit(1);
    28b4:	4505                	li	a0,1
    28b6:	00003097          	auipc	ra,0x3
    28ba:	376080e7          	jalr	886(ra) # 5c2c <exit>
    printf("open(rwsbrk) failed\n");
    28be:	00004517          	auipc	a0,0x4
    28c2:	62250513          	addi	a0,a0,1570 # 6ee0 <malloc+0xe8c>
    28c6:	00003097          	auipc	ra,0x3
    28ca:	6d6080e7          	jalr	1750(ra) # 5f9c <printf>
    exit(1);
    28ce:	4505                	li	a0,1
    28d0:	00003097          	auipc	ra,0x3
    28d4:	35c080e7          	jalr	860(ra) # 5c2c <exit>
  close(fd);
    28d8:	854a                	mv	a0,s2
    28da:	00003097          	auipc	ra,0x3
    28de:	37a080e7          	jalr	890(ra) # 5c54 <close>
  exit(0);
    28e2:	4501                	li	a0,0
    28e4:	00003097          	auipc	ra,0x3
    28e8:	348080e7          	jalr	840(ra) # 5c2c <exit>

00000000000028ec <sbrkbasic>:
{
    28ec:	7139                	addi	sp,sp,-64
    28ee:	fc06                	sd	ra,56(sp)
    28f0:	f822                	sd	s0,48(sp)
    28f2:	ec4e                	sd	s3,24(sp)
    28f4:	0080                	addi	s0,sp,64
    28f6:	89aa                	mv	s3,a0
  pid = fork();
    28f8:	00003097          	auipc	ra,0x3
    28fc:	32c080e7          	jalr	812(ra) # 5c24 <fork>
  if(pid < 0){
    2900:	02054f63          	bltz	a0,293e <sbrkbasic+0x52>
  if(pid == 0){
    2904:	e52d                	bnez	a0,296e <sbrkbasic+0x82>
    a = sbrk(TOOMUCH);
    2906:	40000537          	lui	a0,0x40000
    290a:	00003097          	auipc	ra,0x3
    290e:	3aa080e7          	jalr	938(ra) # 5cb4 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2912:	57fd                	li	a5,-1
    2914:	04f50563          	beq	a0,a5,295e <sbrkbasic+0x72>
    2918:	f426                	sd	s1,40(sp)
    291a:	f04a                	sd	s2,32(sp)
    291c:	e852                	sd	s4,16(sp)
    for(b = a; b < a+TOOMUCH; b += 4096){
    291e:	400007b7          	lui	a5,0x40000
    2922:	97aa                	add	a5,a5,a0
      *b = 99;
    2924:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2928:	6705                	lui	a4,0x1
      *b = 99;
    292a:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3ffeefe8>
    for(b = a; b < a+TOOMUCH; b += 4096){
    292e:	953a                	add	a0,a0,a4
    2930:	fef51de3          	bne	a0,a5,292a <sbrkbasic+0x3e>
    exit(1);
    2934:	4505                	li	a0,1
    2936:	00003097          	auipc	ra,0x3
    293a:	2f6080e7          	jalr	758(ra) # 5c2c <exit>
    293e:	f426                	sd	s1,40(sp)
    2940:	f04a                	sd	s2,32(sp)
    2942:	e852                	sd	s4,16(sp)
    printf("fork failed in sbrkbasic\n");
    2944:	00004517          	auipc	a0,0x4
    2948:	60c50513          	addi	a0,a0,1548 # 6f50 <malloc+0xefc>
    294c:	00003097          	auipc	ra,0x3
    2950:	650080e7          	jalr	1616(ra) # 5f9c <printf>
    exit(1);
    2954:	4505                	li	a0,1
    2956:	00003097          	auipc	ra,0x3
    295a:	2d6080e7          	jalr	726(ra) # 5c2c <exit>
    295e:	f426                	sd	s1,40(sp)
    2960:	f04a                	sd	s2,32(sp)
    2962:	e852                	sd	s4,16(sp)
      exit(0);
    2964:	4501                	li	a0,0
    2966:	00003097          	auipc	ra,0x3
    296a:	2c6080e7          	jalr	710(ra) # 5c2c <exit>
  wait(&xstatus);
    296e:	fcc40513          	addi	a0,s0,-52
    2972:	00003097          	auipc	ra,0x3
    2976:	2c2080e7          	jalr	706(ra) # 5c34 <wait>
  if(xstatus == 1){
    297a:	fcc42703          	lw	a4,-52(s0)
    297e:	4785                	li	a5,1
    2980:	02f70063          	beq	a4,a5,29a0 <sbrkbasic+0xb4>
    2984:	f426                	sd	s1,40(sp)
    2986:	f04a                	sd	s2,32(sp)
    2988:	e852                	sd	s4,16(sp)
  a = sbrk(0);
    298a:	4501                	li	a0,0
    298c:	00003097          	auipc	ra,0x3
    2990:	328080e7          	jalr	808(ra) # 5cb4 <sbrk>
    2994:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2996:	4901                	li	s2,0
    2998:	6a05                	lui	s4,0x1
    299a:	388a0a13          	addi	s4,s4,904 # 1388 <badarg+0x3c>
    299e:	a01d                	j	29c4 <sbrkbasic+0xd8>
    29a0:	f426                	sd	s1,40(sp)
    29a2:	f04a                	sd	s2,32(sp)
    29a4:	e852                	sd	s4,16(sp)
    printf("%s: too much memory allocated!\n", s);
    29a6:	85ce                	mv	a1,s3
    29a8:	00004517          	auipc	a0,0x4
    29ac:	5c850513          	addi	a0,a0,1480 # 6f70 <malloc+0xf1c>
    29b0:	00003097          	auipc	ra,0x3
    29b4:	5ec080e7          	jalr	1516(ra) # 5f9c <printf>
    exit(1);
    29b8:	4505                	li	a0,1
    29ba:	00003097          	auipc	ra,0x3
    29be:	272080e7          	jalr	626(ra) # 5c2c <exit>
    29c2:	84be                	mv	s1,a5
    b = sbrk(1);
    29c4:	4505                	li	a0,1
    29c6:	00003097          	auipc	ra,0x3
    29ca:	2ee080e7          	jalr	750(ra) # 5cb4 <sbrk>
    if(b != a){
    29ce:	04951c63          	bne	a0,s1,2a26 <sbrkbasic+0x13a>
    *b = 1;
    29d2:	4785                	li	a5,1
    29d4:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    29d8:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    29dc:	2905                	addiw	s2,s2,1
    29de:	ff4912e3          	bne	s2,s4,29c2 <sbrkbasic+0xd6>
  pid = fork();
    29e2:	00003097          	auipc	ra,0x3
    29e6:	242080e7          	jalr	578(ra) # 5c24 <fork>
    29ea:	892a                	mv	s2,a0
  if(pid < 0){
    29ec:	04054e63          	bltz	a0,2a48 <sbrkbasic+0x15c>
  c = sbrk(1);
    29f0:	4505                	li	a0,1
    29f2:	00003097          	auipc	ra,0x3
    29f6:	2c2080e7          	jalr	706(ra) # 5cb4 <sbrk>
  c = sbrk(1);
    29fa:	4505                	li	a0,1
    29fc:	00003097          	auipc	ra,0x3
    2a00:	2b8080e7          	jalr	696(ra) # 5cb4 <sbrk>
  if(c != a + 1){
    2a04:	0489                	addi	s1,s1,2
    2a06:	04a48f63          	beq	s1,a0,2a64 <sbrkbasic+0x178>
    printf("%s: sbrk test failed post-fork\n", s);
    2a0a:	85ce                	mv	a1,s3
    2a0c:	00004517          	auipc	a0,0x4
    2a10:	5c450513          	addi	a0,a0,1476 # 6fd0 <malloc+0xf7c>
    2a14:	00003097          	auipc	ra,0x3
    2a18:	588080e7          	jalr	1416(ra) # 5f9c <printf>
    exit(1);
    2a1c:	4505                	li	a0,1
    2a1e:	00003097          	auipc	ra,0x3
    2a22:	20e080e7          	jalr	526(ra) # 5c2c <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    2a26:	872a                	mv	a4,a0
    2a28:	86a6                	mv	a3,s1
    2a2a:	864a                	mv	a2,s2
    2a2c:	85ce                	mv	a1,s3
    2a2e:	00004517          	auipc	a0,0x4
    2a32:	56250513          	addi	a0,a0,1378 # 6f90 <malloc+0xf3c>
    2a36:	00003097          	auipc	ra,0x3
    2a3a:	566080e7          	jalr	1382(ra) # 5f9c <printf>
      exit(1);
    2a3e:	4505                	li	a0,1
    2a40:	00003097          	auipc	ra,0x3
    2a44:	1ec080e7          	jalr	492(ra) # 5c2c <exit>
    printf("%s: sbrk test fork failed\n", s);
    2a48:	85ce                	mv	a1,s3
    2a4a:	00004517          	auipc	a0,0x4
    2a4e:	56650513          	addi	a0,a0,1382 # 6fb0 <malloc+0xf5c>
    2a52:	00003097          	auipc	ra,0x3
    2a56:	54a080e7          	jalr	1354(ra) # 5f9c <printf>
    exit(1);
    2a5a:	4505                	li	a0,1
    2a5c:	00003097          	auipc	ra,0x3
    2a60:	1d0080e7          	jalr	464(ra) # 5c2c <exit>
  if(pid == 0)
    2a64:	00091763          	bnez	s2,2a72 <sbrkbasic+0x186>
    exit(0);
    2a68:	4501                	li	a0,0
    2a6a:	00003097          	auipc	ra,0x3
    2a6e:	1c2080e7          	jalr	450(ra) # 5c2c <exit>
  wait(&xstatus);
    2a72:	fcc40513          	addi	a0,s0,-52
    2a76:	00003097          	auipc	ra,0x3
    2a7a:	1be080e7          	jalr	446(ra) # 5c34 <wait>
  exit(xstatus);
    2a7e:	fcc42503          	lw	a0,-52(s0)
    2a82:	00003097          	auipc	ra,0x3
    2a86:	1aa080e7          	jalr	426(ra) # 5c2c <exit>

0000000000002a8a <sbrkmuch>:
{
    2a8a:	7179                	addi	sp,sp,-48
    2a8c:	f406                	sd	ra,40(sp)
    2a8e:	f022                	sd	s0,32(sp)
    2a90:	ec26                	sd	s1,24(sp)
    2a92:	e84a                	sd	s2,16(sp)
    2a94:	e44e                	sd	s3,8(sp)
    2a96:	e052                	sd	s4,0(sp)
    2a98:	1800                	addi	s0,sp,48
    2a9a:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2a9c:	4501                	li	a0,0
    2a9e:	00003097          	auipc	ra,0x3
    2aa2:	216080e7          	jalr	534(ra) # 5cb4 <sbrk>
    2aa6:	892a                	mv	s2,a0
  a = sbrk(0);
    2aa8:	4501                	li	a0,0
    2aaa:	00003097          	auipc	ra,0x3
    2aae:	20a080e7          	jalr	522(ra) # 5cb4 <sbrk>
    2ab2:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2ab4:	06400537          	lui	a0,0x6400
    2ab8:	9d05                	subw	a0,a0,s1
    2aba:	00003097          	auipc	ra,0x3
    2abe:	1fa080e7          	jalr	506(ra) # 5cb4 <sbrk>
  if (p != a) {
    2ac2:	0ca49863          	bne	s1,a0,2b92 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2ac6:	4501                	li	a0,0
    2ac8:	00003097          	auipc	ra,0x3
    2acc:	1ec080e7          	jalr	492(ra) # 5cb4 <sbrk>
    2ad0:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2ad2:	00a4f963          	bgeu	s1,a0,2ae4 <sbrkmuch+0x5a>
    *pp = 1;
    2ad6:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2ad8:	6705                	lui	a4,0x1
    *pp = 1;
    2ada:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2ade:	94ba                	add	s1,s1,a4
    2ae0:	fef4ede3          	bltu	s1,a5,2ada <sbrkmuch+0x50>
  *lastaddr = 99;
    2ae4:	064007b7          	lui	a5,0x6400
    2ae8:	06300713          	li	a4,99
    2aec:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63eefe7>
  a = sbrk(0);
    2af0:	4501                	li	a0,0
    2af2:	00003097          	auipc	ra,0x3
    2af6:	1c2080e7          	jalr	450(ra) # 5cb4 <sbrk>
    2afa:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2afc:	757d                	lui	a0,0xfffff
    2afe:	00003097          	auipc	ra,0x3
    2b02:	1b6080e7          	jalr	438(ra) # 5cb4 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2b06:	57fd                	li	a5,-1
    2b08:	0af50363          	beq	a0,a5,2bae <sbrkmuch+0x124>
  c = sbrk(0);
    2b0c:	4501                	li	a0,0
    2b0e:	00003097          	auipc	ra,0x3
    2b12:	1a6080e7          	jalr	422(ra) # 5cb4 <sbrk>
  if(c != a - PGSIZE){
    2b16:	77fd                	lui	a5,0xfffff
    2b18:	97a6                	add	a5,a5,s1
    2b1a:	0af51863          	bne	a0,a5,2bca <sbrkmuch+0x140>
  a = sbrk(0);
    2b1e:	4501                	li	a0,0
    2b20:	00003097          	auipc	ra,0x3
    2b24:	194080e7          	jalr	404(ra) # 5cb4 <sbrk>
    2b28:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2b2a:	6505                	lui	a0,0x1
    2b2c:	00003097          	auipc	ra,0x3
    2b30:	188080e7          	jalr	392(ra) # 5cb4 <sbrk>
    2b34:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2b36:	0aa49a63          	bne	s1,a0,2bea <sbrkmuch+0x160>
    2b3a:	4501                	li	a0,0
    2b3c:	00003097          	auipc	ra,0x3
    2b40:	178080e7          	jalr	376(ra) # 5cb4 <sbrk>
    2b44:	6785                	lui	a5,0x1
    2b46:	97a6                	add	a5,a5,s1
    2b48:	0af51163          	bne	a0,a5,2bea <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2b4c:	064007b7          	lui	a5,0x6400
    2b50:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63eefe7>
    2b54:	06300793          	li	a5,99
    2b58:	0af70963          	beq	a4,a5,2c0a <sbrkmuch+0x180>
  a = sbrk(0);
    2b5c:	4501                	li	a0,0
    2b5e:	00003097          	auipc	ra,0x3
    2b62:	156080e7          	jalr	342(ra) # 5cb4 <sbrk>
    2b66:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2b68:	4501                	li	a0,0
    2b6a:	00003097          	auipc	ra,0x3
    2b6e:	14a080e7          	jalr	330(ra) # 5cb4 <sbrk>
    2b72:	40a9053b          	subw	a0,s2,a0
    2b76:	00003097          	auipc	ra,0x3
    2b7a:	13e080e7          	jalr	318(ra) # 5cb4 <sbrk>
  if(c != a){
    2b7e:	0aa49463          	bne	s1,a0,2c26 <sbrkmuch+0x19c>
}
    2b82:	70a2                	ld	ra,40(sp)
    2b84:	7402                	ld	s0,32(sp)
    2b86:	64e2                	ld	s1,24(sp)
    2b88:	6942                	ld	s2,16(sp)
    2b8a:	69a2                	ld	s3,8(sp)
    2b8c:	6a02                	ld	s4,0(sp)
    2b8e:	6145                	addi	sp,sp,48
    2b90:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2b92:	85ce                	mv	a1,s3
    2b94:	00004517          	auipc	a0,0x4
    2b98:	45c50513          	addi	a0,a0,1116 # 6ff0 <malloc+0xf9c>
    2b9c:	00003097          	auipc	ra,0x3
    2ba0:	400080e7          	jalr	1024(ra) # 5f9c <printf>
    exit(1);
    2ba4:	4505                	li	a0,1
    2ba6:	00003097          	auipc	ra,0x3
    2baa:	086080e7          	jalr	134(ra) # 5c2c <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2bae:	85ce                	mv	a1,s3
    2bb0:	00004517          	auipc	a0,0x4
    2bb4:	48850513          	addi	a0,a0,1160 # 7038 <malloc+0xfe4>
    2bb8:	00003097          	auipc	ra,0x3
    2bbc:	3e4080e7          	jalr	996(ra) # 5f9c <printf>
    exit(1);
    2bc0:	4505                	li	a0,1
    2bc2:	00003097          	auipc	ra,0x3
    2bc6:	06a080e7          	jalr	106(ra) # 5c2c <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2bca:	86aa                	mv	a3,a0
    2bcc:	8626                	mv	a2,s1
    2bce:	85ce                	mv	a1,s3
    2bd0:	00004517          	auipc	a0,0x4
    2bd4:	48850513          	addi	a0,a0,1160 # 7058 <malloc+0x1004>
    2bd8:	00003097          	auipc	ra,0x3
    2bdc:	3c4080e7          	jalr	964(ra) # 5f9c <printf>
    exit(1);
    2be0:	4505                	li	a0,1
    2be2:	00003097          	auipc	ra,0x3
    2be6:	04a080e7          	jalr	74(ra) # 5c2c <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2bea:	86d2                	mv	a3,s4
    2bec:	8626                	mv	a2,s1
    2bee:	85ce                	mv	a1,s3
    2bf0:	00004517          	auipc	a0,0x4
    2bf4:	4a850513          	addi	a0,a0,1192 # 7098 <malloc+0x1044>
    2bf8:	00003097          	auipc	ra,0x3
    2bfc:	3a4080e7          	jalr	932(ra) # 5f9c <printf>
    exit(1);
    2c00:	4505                	li	a0,1
    2c02:	00003097          	auipc	ra,0x3
    2c06:	02a080e7          	jalr	42(ra) # 5c2c <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2c0a:	85ce                	mv	a1,s3
    2c0c:	00004517          	auipc	a0,0x4
    2c10:	4bc50513          	addi	a0,a0,1212 # 70c8 <malloc+0x1074>
    2c14:	00003097          	auipc	ra,0x3
    2c18:	388080e7          	jalr	904(ra) # 5f9c <printf>
    exit(1);
    2c1c:	4505                	li	a0,1
    2c1e:	00003097          	auipc	ra,0x3
    2c22:	00e080e7          	jalr	14(ra) # 5c2c <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2c26:	86aa                	mv	a3,a0
    2c28:	8626                	mv	a2,s1
    2c2a:	85ce                	mv	a1,s3
    2c2c:	00004517          	auipc	a0,0x4
    2c30:	4d450513          	addi	a0,a0,1236 # 7100 <malloc+0x10ac>
    2c34:	00003097          	auipc	ra,0x3
    2c38:	368080e7          	jalr	872(ra) # 5f9c <printf>
    exit(1);
    2c3c:	4505                	li	a0,1
    2c3e:	00003097          	auipc	ra,0x3
    2c42:	fee080e7          	jalr	-18(ra) # 5c2c <exit>

0000000000002c46 <sbrkarg>:
{
    2c46:	7179                	addi	sp,sp,-48
    2c48:	f406                	sd	ra,40(sp)
    2c4a:	f022                	sd	s0,32(sp)
    2c4c:	ec26                	sd	s1,24(sp)
    2c4e:	e84a                	sd	s2,16(sp)
    2c50:	e44e                	sd	s3,8(sp)
    2c52:	1800                	addi	s0,sp,48
    2c54:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2c56:	6505                	lui	a0,0x1
    2c58:	00003097          	auipc	ra,0x3
    2c5c:	05c080e7          	jalr	92(ra) # 5cb4 <sbrk>
    2c60:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2c62:	20100593          	li	a1,513
    2c66:	00004517          	auipc	a0,0x4
    2c6a:	4c250513          	addi	a0,a0,1218 # 7128 <malloc+0x10d4>
    2c6e:	00003097          	auipc	ra,0x3
    2c72:	ffe080e7          	jalr	-2(ra) # 5c6c <open>
    2c76:	84aa                	mv	s1,a0
  unlink("sbrk");
    2c78:	00004517          	auipc	a0,0x4
    2c7c:	4b050513          	addi	a0,a0,1200 # 7128 <malloc+0x10d4>
    2c80:	00003097          	auipc	ra,0x3
    2c84:	ffc080e7          	jalr	-4(ra) # 5c7c <unlink>
  if(fd < 0)  {
    2c88:	0404c163          	bltz	s1,2cca <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2c8c:	6605                	lui	a2,0x1
    2c8e:	85ca                	mv	a1,s2
    2c90:	8526                	mv	a0,s1
    2c92:	00003097          	auipc	ra,0x3
    2c96:	fba080e7          	jalr	-70(ra) # 5c4c <write>
    2c9a:	04054663          	bltz	a0,2ce6 <sbrkarg+0xa0>
  close(fd);
    2c9e:	8526                	mv	a0,s1
    2ca0:	00003097          	auipc	ra,0x3
    2ca4:	fb4080e7          	jalr	-76(ra) # 5c54 <close>
  a = sbrk(PGSIZE);
    2ca8:	6505                	lui	a0,0x1
    2caa:	00003097          	auipc	ra,0x3
    2cae:	00a080e7          	jalr	10(ra) # 5cb4 <sbrk>
  if(pipe((int *) a) != 0){
    2cb2:	00003097          	auipc	ra,0x3
    2cb6:	f8a080e7          	jalr	-118(ra) # 5c3c <pipe>
    2cba:	e521                	bnez	a0,2d02 <sbrkarg+0xbc>
}
    2cbc:	70a2                	ld	ra,40(sp)
    2cbe:	7402                	ld	s0,32(sp)
    2cc0:	64e2                	ld	s1,24(sp)
    2cc2:	6942                	ld	s2,16(sp)
    2cc4:	69a2                	ld	s3,8(sp)
    2cc6:	6145                	addi	sp,sp,48
    2cc8:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2cca:	85ce                	mv	a1,s3
    2ccc:	00004517          	auipc	a0,0x4
    2cd0:	46450513          	addi	a0,a0,1124 # 7130 <malloc+0x10dc>
    2cd4:	00003097          	auipc	ra,0x3
    2cd8:	2c8080e7          	jalr	712(ra) # 5f9c <printf>
    exit(1);
    2cdc:	4505                	li	a0,1
    2cde:	00003097          	auipc	ra,0x3
    2ce2:	f4e080e7          	jalr	-178(ra) # 5c2c <exit>
    printf("%s: write sbrk failed\n", s);
    2ce6:	85ce                	mv	a1,s3
    2ce8:	00004517          	auipc	a0,0x4
    2cec:	46050513          	addi	a0,a0,1120 # 7148 <malloc+0x10f4>
    2cf0:	00003097          	auipc	ra,0x3
    2cf4:	2ac080e7          	jalr	684(ra) # 5f9c <printf>
    exit(1);
    2cf8:	4505                	li	a0,1
    2cfa:	00003097          	auipc	ra,0x3
    2cfe:	f32080e7          	jalr	-206(ra) # 5c2c <exit>
    printf("%s: pipe() failed\n", s);
    2d02:	85ce                	mv	a1,s3
    2d04:	00004517          	auipc	a0,0x4
    2d08:	e2450513          	addi	a0,a0,-476 # 6b28 <malloc+0xad4>
    2d0c:	00003097          	auipc	ra,0x3
    2d10:	290080e7          	jalr	656(ra) # 5f9c <printf>
    exit(1);
    2d14:	4505                	li	a0,1
    2d16:	00003097          	auipc	ra,0x3
    2d1a:	f16080e7          	jalr	-234(ra) # 5c2c <exit>

0000000000002d1e <argptest>:
{
    2d1e:	1101                	addi	sp,sp,-32
    2d20:	ec06                	sd	ra,24(sp)
    2d22:	e822                	sd	s0,16(sp)
    2d24:	e426                	sd	s1,8(sp)
    2d26:	e04a                	sd	s2,0(sp)
    2d28:	1000                	addi	s0,sp,32
    2d2a:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2d2c:	4581                	li	a1,0
    2d2e:	00004517          	auipc	a0,0x4
    2d32:	43250513          	addi	a0,a0,1074 # 7160 <malloc+0x110c>
    2d36:	00003097          	auipc	ra,0x3
    2d3a:	f36080e7          	jalr	-202(ra) # 5c6c <open>
  if (fd < 0) {
    2d3e:	02054b63          	bltz	a0,2d74 <argptest+0x56>
    2d42:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2d44:	4501                	li	a0,0
    2d46:	00003097          	auipc	ra,0x3
    2d4a:	f6e080e7          	jalr	-146(ra) # 5cb4 <sbrk>
    2d4e:	567d                	li	a2,-1
    2d50:	fff50593          	addi	a1,a0,-1
    2d54:	8526                	mv	a0,s1
    2d56:	00003097          	auipc	ra,0x3
    2d5a:	eee080e7          	jalr	-274(ra) # 5c44 <read>
  close(fd);
    2d5e:	8526                	mv	a0,s1
    2d60:	00003097          	auipc	ra,0x3
    2d64:	ef4080e7          	jalr	-268(ra) # 5c54 <close>
}
    2d68:	60e2                	ld	ra,24(sp)
    2d6a:	6442                	ld	s0,16(sp)
    2d6c:	64a2                	ld	s1,8(sp)
    2d6e:	6902                	ld	s2,0(sp)
    2d70:	6105                	addi	sp,sp,32
    2d72:	8082                	ret
    printf("%s: open failed\n", s);
    2d74:	85ca                	mv	a1,s2
    2d76:	00004517          	auipc	a0,0x4
    2d7a:	cc250513          	addi	a0,a0,-830 # 6a38 <malloc+0x9e4>
    2d7e:	00003097          	auipc	ra,0x3
    2d82:	21e080e7          	jalr	542(ra) # 5f9c <printf>
    exit(1);
    2d86:	4505                	li	a0,1
    2d88:	00003097          	auipc	ra,0x3
    2d8c:	ea4080e7          	jalr	-348(ra) # 5c2c <exit>

0000000000002d90 <sbrkbugs>:
{
    2d90:	1141                	addi	sp,sp,-16
    2d92:	e406                	sd	ra,8(sp)
    2d94:	e022                	sd	s0,0(sp)
    2d96:	0800                	addi	s0,sp,16
  int pid = fork();
    2d98:	00003097          	auipc	ra,0x3
    2d9c:	e8c080e7          	jalr	-372(ra) # 5c24 <fork>
  if(pid < 0){
    2da0:	02054263          	bltz	a0,2dc4 <sbrkbugs+0x34>
  if(pid == 0){
    2da4:	ed0d                	bnez	a0,2dde <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2da6:	00003097          	auipc	ra,0x3
    2daa:	f0e080e7          	jalr	-242(ra) # 5cb4 <sbrk>
    sbrk(-sz);
    2dae:	40a0053b          	negw	a0,a0
    2db2:	00003097          	auipc	ra,0x3
    2db6:	f02080e7          	jalr	-254(ra) # 5cb4 <sbrk>
    exit(0);
    2dba:	4501                	li	a0,0
    2dbc:	00003097          	auipc	ra,0x3
    2dc0:	e70080e7          	jalr	-400(ra) # 5c2c <exit>
    printf("fork failed\n");
    2dc4:	00004517          	auipc	a0,0x4
    2dc8:	06450513          	addi	a0,a0,100 # 6e28 <malloc+0xdd4>
    2dcc:	00003097          	auipc	ra,0x3
    2dd0:	1d0080e7          	jalr	464(ra) # 5f9c <printf>
    exit(1);
    2dd4:	4505                	li	a0,1
    2dd6:	00003097          	auipc	ra,0x3
    2dda:	e56080e7          	jalr	-426(ra) # 5c2c <exit>
  wait(0);
    2dde:	4501                	li	a0,0
    2de0:	00003097          	auipc	ra,0x3
    2de4:	e54080e7          	jalr	-428(ra) # 5c34 <wait>
  pid = fork();
    2de8:	00003097          	auipc	ra,0x3
    2dec:	e3c080e7          	jalr	-452(ra) # 5c24 <fork>
  if(pid < 0){
    2df0:	02054563          	bltz	a0,2e1a <sbrkbugs+0x8a>
  if(pid == 0){
    2df4:	e121                	bnez	a0,2e34 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2df6:	00003097          	auipc	ra,0x3
    2dfa:	ebe080e7          	jalr	-322(ra) # 5cb4 <sbrk>
    sbrk(-(sz - 3500));
    2dfe:	6785                	lui	a5,0x1
    2e00:	dac7879b          	addiw	a5,a5,-596 # dac <unlinkread+0x6c>
    2e04:	40a7853b          	subw	a0,a5,a0
    2e08:	00003097          	auipc	ra,0x3
    2e0c:	eac080e7          	jalr	-340(ra) # 5cb4 <sbrk>
    exit(0);
    2e10:	4501                	li	a0,0
    2e12:	00003097          	auipc	ra,0x3
    2e16:	e1a080e7          	jalr	-486(ra) # 5c2c <exit>
    printf("fork failed\n");
    2e1a:	00004517          	auipc	a0,0x4
    2e1e:	00e50513          	addi	a0,a0,14 # 6e28 <malloc+0xdd4>
    2e22:	00003097          	auipc	ra,0x3
    2e26:	17a080e7          	jalr	378(ra) # 5f9c <printf>
    exit(1);
    2e2a:	4505                	li	a0,1
    2e2c:	00003097          	auipc	ra,0x3
    2e30:	e00080e7          	jalr	-512(ra) # 5c2c <exit>
  wait(0);
    2e34:	4501                	li	a0,0
    2e36:	00003097          	auipc	ra,0x3
    2e3a:	dfe080e7          	jalr	-514(ra) # 5c34 <wait>
  pid = fork();
    2e3e:	00003097          	auipc	ra,0x3
    2e42:	de6080e7          	jalr	-538(ra) # 5c24 <fork>
  if(pid < 0){
    2e46:	02054a63          	bltz	a0,2e7a <sbrkbugs+0xea>
  if(pid == 0){
    2e4a:	e529                	bnez	a0,2e94 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2e4c:	00003097          	auipc	ra,0x3
    2e50:	e68080e7          	jalr	-408(ra) # 5cb4 <sbrk>
    2e54:	67ad                	lui	a5,0xb
    2e56:	8007879b          	addiw	a5,a5,-2048 # a800 <args.1>
    2e5a:	40a7853b          	subw	a0,a5,a0
    2e5e:	00003097          	auipc	ra,0x3
    2e62:	e56080e7          	jalr	-426(ra) # 5cb4 <sbrk>
    sbrk(-10);
    2e66:	5559                	li	a0,-10
    2e68:	00003097          	auipc	ra,0x3
    2e6c:	e4c080e7          	jalr	-436(ra) # 5cb4 <sbrk>
    exit(0);
    2e70:	4501                	li	a0,0
    2e72:	00003097          	auipc	ra,0x3
    2e76:	dba080e7          	jalr	-582(ra) # 5c2c <exit>
    printf("fork failed\n");
    2e7a:	00004517          	auipc	a0,0x4
    2e7e:	fae50513          	addi	a0,a0,-82 # 6e28 <malloc+0xdd4>
    2e82:	00003097          	auipc	ra,0x3
    2e86:	11a080e7          	jalr	282(ra) # 5f9c <printf>
    exit(1);
    2e8a:	4505                	li	a0,1
    2e8c:	00003097          	auipc	ra,0x3
    2e90:	da0080e7          	jalr	-608(ra) # 5c2c <exit>
  wait(0);
    2e94:	4501                	li	a0,0
    2e96:	00003097          	auipc	ra,0x3
    2e9a:	d9e080e7          	jalr	-610(ra) # 5c34 <wait>
  exit(0);
    2e9e:	4501                	li	a0,0
    2ea0:	00003097          	auipc	ra,0x3
    2ea4:	d8c080e7          	jalr	-628(ra) # 5c2c <exit>

0000000000002ea8 <sbrklast>:
{
    2ea8:	7179                	addi	sp,sp,-48
    2eaa:	f406                	sd	ra,40(sp)
    2eac:	f022                	sd	s0,32(sp)
    2eae:	ec26                	sd	s1,24(sp)
    2eb0:	e84a                	sd	s2,16(sp)
    2eb2:	e44e                	sd	s3,8(sp)
    2eb4:	e052                	sd	s4,0(sp)
    2eb6:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2eb8:	4501                	li	a0,0
    2eba:	00003097          	auipc	ra,0x3
    2ebe:	dfa080e7          	jalr	-518(ra) # 5cb4 <sbrk>
  if((top % 4096) != 0)
    2ec2:	03451793          	slli	a5,a0,0x34
    2ec6:	ebd9                	bnez	a5,2f5c <sbrklast+0xb4>
  sbrk(4096);
    2ec8:	6505                	lui	a0,0x1
    2eca:	00003097          	auipc	ra,0x3
    2ece:	dea080e7          	jalr	-534(ra) # 5cb4 <sbrk>
  sbrk(10);
    2ed2:	4529                	li	a0,10
    2ed4:	00003097          	auipc	ra,0x3
    2ed8:	de0080e7          	jalr	-544(ra) # 5cb4 <sbrk>
  sbrk(-20);
    2edc:	5531                	li	a0,-20
    2ede:	00003097          	auipc	ra,0x3
    2ee2:	dd6080e7          	jalr	-554(ra) # 5cb4 <sbrk>
  top = (uint64) sbrk(0);
    2ee6:	4501                	li	a0,0
    2ee8:	00003097          	auipc	ra,0x3
    2eec:	dcc080e7          	jalr	-564(ra) # 5cb4 <sbrk>
    2ef0:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2ef2:	fc050913          	addi	s2,a0,-64 # fc0 <linktest+0xca>
  p[0] = 'x';
    2ef6:	07800a13          	li	s4,120
    2efa:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2efe:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2f02:	20200593          	li	a1,514
    2f06:	854a                	mv	a0,s2
    2f08:	00003097          	auipc	ra,0x3
    2f0c:	d64080e7          	jalr	-668(ra) # 5c6c <open>
    2f10:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2f12:	4605                	li	a2,1
    2f14:	85ca                	mv	a1,s2
    2f16:	00003097          	auipc	ra,0x3
    2f1a:	d36080e7          	jalr	-714(ra) # 5c4c <write>
  close(fd);
    2f1e:	854e                	mv	a0,s3
    2f20:	00003097          	auipc	ra,0x3
    2f24:	d34080e7          	jalr	-716(ra) # 5c54 <close>
  fd = open(p, O_RDWR);
    2f28:	4589                	li	a1,2
    2f2a:	854a                	mv	a0,s2
    2f2c:	00003097          	auipc	ra,0x3
    2f30:	d40080e7          	jalr	-704(ra) # 5c6c <open>
  p[0] = '\0';
    2f34:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2f38:	4605                	li	a2,1
    2f3a:	85ca                	mv	a1,s2
    2f3c:	00003097          	auipc	ra,0x3
    2f40:	d08080e7          	jalr	-760(ra) # 5c44 <read>
  if(p[0] != 'x')
    2f44:	fc04c783          	lbu	a5,-64(s1)
    2f48:	03479463          	bne	a5,s4,2f70 <sbrklast+0xc8>
}
    2f4c:	70a2                	ld	ra,40(sp)
    2f4e:	7402                	ld	s0,32(sp)
    2f50:	64e2                	ld	s1,24(sp)
    2f52:	6942                	ld	s2,16(sp)
    2f54:	69a2                	ld	s3,8(sp)
    2f56:	6a02                	ld	s4,0(sp)
    2f58:	6145                	addi	sp,sp,48
    2f5a:	8082                	ret
    sbrk(4096 - (top % 4096));
    2f5c:	0347d513          	srli	a0,a5,0x34
    2f60:	6785                	lui	a5,0x1
    2f62:	40a7853b          	subw	a0,a5,a0
    2f66:	00003097          	auipc	ra,0x3
    2f6a:	d4e080e7          	jalr	-690(ra) # 5cb4 <sbrk>
    2f6e:	bfa9                	j	2ec8 <sbrklast+0x20>
    exit(1);
    2f70:	4505                	li	a0,1
    2f72:	00003097          	auipc	ra,0x3
    2f76:	cba080e7          	jalr	-838(ra) # 5c2c <exit>

0000000000002f7a <sbrk8000>:
{
    2f7a:	1141                	addi	sp,sp,-16
    2f7c:	e406                	sd	ra,8(sp)
    2f7e:	e022                	sd	s0,0(sp)
    2f80:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2f82:	80000537          	lui	a0,0x80000
    2f86:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7ffeefec>
    2f88:	00003097          	auipc	ra,0x3
    2f8c:	d2c080e7          	jalr	-724(ra) # 5cb4 <sbrk>
  volatile char *top = sbrk(0);
    2f90:	4501                	li	a0,0
    2f92:	00003097          	auipc	ra,0x3
    2f96:	d22080e7          	jalr	-734(ra) # 5cb4 <sbrk>
  *(top-1) = *(top-1) + 1;
    2f9a:	fff54783          	lbu	a5,-1(a0)
    2f9e:	2785                	addiw	a5,a5,1 # 1001 <linktest+0x10b>
    2fa0:	0ff7f793          	zext.b	a5,a5
    2fa4:	fef50fa3          	sb	a5,-1(a0)
}
    2fa8:	60a2                	ld	ra,8(sp)
    2faa:	6402                	ld	s0,0(sp)
    2fac:	0141                	addi	sp,sp,16
    2fae:	8082                	ret

0000000000002fb0 <execout>:
{
    2fb0:	715d                	addi	sp,sp,-80
    2fb2:	e486                	sd	ra,72(sp)
    2fb4:	e0a2                	sd	s0,64(sp)
    2fb6:	fc26                	sd	s1,56(sp)
    2fb8:	f84a                	sd	s2,48(sp)
    2fba:	f44e                	sd	s3,40(sp)
    2fbc:	f052                	sd	s4,32(sp)
    2fbe:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2fc0:	4901                	li	s2,0
    2fc2:	49bd                	li	s3,15
    int pid = fork();
    2fc4:	00003097          	auipc	ra,0x3
    2fc8:	c60080e7          	jalr	-928(ra) # 5c24 <fork>
    2fcc:	84aa                	mv	s1,a0
    if(pid < 0){
    2fce:	02054063          	bltz	a0,2fee <execout+0x3e>
    } else if(pid == 0){
    2fd2:	c91d                	beqz	a0,3008 <execout+0x58>
      wait((int*)0);
    2fd4:	4501                	li	a0,0
    2fd6:	00003097          	auipc	ra,0x3
    2fda:	c5e080e7          	jalr	-930(ra) # 5c34 <wait>
  for(int avail = 0; avail < 15; avail++){
    2fde:	2905                	addiw	s2,s2,1
    2fe0:	ff3912e3          	bne	s2,s3,2fc4 <execout+0x14>
  exit(0);
    2fe4:	4501                	li	a0,0
    2fe6:	00003097          	auipc	ra,0x3
    2fea:	c46080e7          	jalr	-954(ra) # 5c2c <exit>
      printf("fork failed\n");
    2fee:	00004517          	auipc	a0,0x4
    2ff2:	e3a50513          	addi	a0,a0,-454 # 6e28 <malloc+0xdd4>
    2ff6:	00003097          	auipc	ra,0x3
    2ffa:	fa6080e7          	jalr	-90(ra) # 5f9c <printf>
      exit(1);
    2ffe:	4505                	li	a0,1
    3000:	00003097          	auipc	ra,0x3
    3004:	c2c080e7          	jalr	-980(ra) # 5c2c <exit>
        if(a == 0xffffffffffffffffLL)
    3008:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    300a:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    300c:	6505                	lui	a0,0x1
    300e:	00003097          	auipc	ra,0x3
    3012:	ca6080e7          	jalr	-858(ra) # 5cb4 <sbrk>
        if(a == 0xffffffffffffffffLL)
    3016:	01350763          	beq	a0,s3,3024 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    301a:	6785                	lui	a5,0x1
    301c:	97aa                	add	a5,a5,a0
    301e:	ff478fa3          	sb	s4,-1(a5) # fff <linktest+0x109>
      while(1){
    3022:	b7ed                	j	300c <execout+0x5c>
      for(int i = 0; i < avail; i++)
    3024:	01205a63          	blez	s2,3038 <execout+0x88>
        sbrk(-4096);
    3028:	757d                	lui	a0,0xfffff
    302a:	00003097          	auipc	ra,0x3
    302e:	c8a080e7          	jalr	-886(ra) # 5cb4 <sbrk>
      for(int i = 0; i < avail; i++)
    3032:	2485                	addiw	s1,s1,1
    3034:	ff249ae3          	bne	s1,s2,3028 <execout+0x78>
      close(1);
    3038:	4505                	li	a0,1
    303a:	00003097          	auipc	ra,0x3
    303e:	c1a080e7          	jalr	-998(ra) # 5c54 <close>
      char *args[] = { "echo", "x", 0 };
    3042:	00003517          	auipc	a0,0x3
    3046:	15650513          	addi	a0,a0,342 # 6198 <malloc+0x144>
    304a:	faa43c23          	sd	a0,-72(s0)
    304e:	00003797          	auipc	a5,0x3
    3052:	1ba78793          	addi	a5,a5,442 # 6208 <malloc+0x1b4>
    3056:	fcf43023          	sd	a5,-64(s0)
    305a:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    305e:	fb840593          	addi	a1,s0,-72
    3062:	00003097          	auipc	ra,0x3
    3066:	c02080e7          	jalr	-1022(ra) # 5c64 <exec>
      exit(0);
    306a:	4501                	li	a0,0
    306c:	00003097          	auipc	ra,0x3
    3070:	bc0080e7          	jalr	-1088(ra) # 5c2c <exit>

0000000000003074 <fourteen>:
{
    3074:	1101                	addi	sp,sp,-32
    3076:	ec06                	sd	ra,24(sp)
    3078:	e822                	sd	s0,16(sp)
    307a:	e426                	sd	s1,8(sp)
    307c:	1000                	addi	s0,sp,32
    307e:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    3080:	00004517          	auipc	a0,0x4
    3084:	2b850513          	addi	a0,a0,696 # 7338 <malloc+0x12e4>
    3088:	00003097          	auipc	ra,0x3
    308c:	c0c080e7          	jalr	-1012(ra) # 5c94 <mkdir>
    3090:	e165                	bnez	a0,3170 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    3092:	00004517          	auipc	a0,0x4
    3096:	0fe50513          	addi	a0,a0,254 # 7190 <malloc+0x113c>
    309a:	00003097          	auipc	ra,0x3
    309e:	bfa080e7          	jalr	-1030(ra) # 5c94 <mkdir>
    30a2:	e56d                	bnez	a0,318c <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    30a4:	20000593          	li	a1,512
    30a8:	00004517          	auipc	a0,0x4
    30ac:	14050513          	addi	a0,a0,320 # 71e8 <malloc+0x1194>
    30b0:	00003097          	auipc	ra,0x3
    30b4:	bbc080e7          	jalr	-1092(ra) # 5c6c <open>
  if(fd < 0){
    30b8:	0e054863          	bltz	a0,31a8 <fourteen+0x134>
  close(fd);
    30bc:	00003097          	auipc	ra,0x3
    30c0:	b98080e7          	jalr	-1128(ra) # 5c54 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    30c4:	4581                	li	a1,0
    30c6:	00004517          	auipc	a0,0x4
    30ca:	19a50513          	addi	a0,a0,410 # 7260 <malloc+0x120c>
    30ce:	00003097          	auipc	ra,0x3
    30d2:	b9e080e7          	jalr	-1122(ra) # 5c6c <open>
  if(fd < 0){
    30d6:	0e054763          	bltz	a0,31c4 <fourteen+0x150>
  close(fd);
    30da:	00003097          	auipc	ra,0x3
    30de:	b7a080e7          	jalr	-1158(ra) # 5c54 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    30e2:	00004517          	auipc	a0,0x4
    30e6:	1ee50513          	addi	a0,a0,494 # 72d0 <malloc+0x127c>
    30ea:	00003097          	auipc	ra,0x3
    30ee:	baa080e7          	jalr	-1110(ra) # 5c94 <mkdir>
    30f2:	c57d                	beqz	a0,31e0 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    30f4:	00004517          	auipc	a0,0x4
    30f8:	23450513          	addi	a0,a0,564 # 7328 <malloc+0x12d4>
    30fc:	00003097          	auipc	ra,0x3
    3100:	b98080e7          	jalr	-1128(ra) # 5c94 <mkdir>
    3104:	cd65                	beqz	a0,31fc <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    3106:	00004517          	auipc	a0,0x4
    310a:	22250513          	addi	a0,a0,546 # 7328 <malloc+0x12d4>
    310e:	00003097          	auipc	ra,0x3
    3112:	b6e080e7          	jalr	-1170(ra) # 5c7c <unlink>
  unlink("12345678901234/12345678901234");
    3116:	00004517          	auipc	a0,0x4
    311a:	1ba50513          	addi	a0,a0,442 # 72d0 <malloc+0x127c>
    311e:	00003097          	auipc	ra,0x3
    3122:	b5e080e7          	jalr	-1186(ra) # 5c7c <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    3126:	00004517          	auipc	a0,0x4
    312a:	13a50513          	addi	a0,a0,314 # 7260 <malloc+0x120c>
    312e:	00003097          	auipc	ra,0x3
    3132:	b4e080e7          	jalr	-1202(ra) # 5c7c <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    3136:	00004517          	auipc	a0,0x4
    313a:	0b250513          	addi	a0,a0,178 # 71e8 <malloc+0x1194>
    313e:	00003097          	auipc	ra,0x3
    3142:	b3e080e7          	jalr	-1218(ra) # 5c7c <unlink>
  unlink("12345678901234/123456789012345");
    3146:	00004517          	auipc	a0,0x4
    314a:	04a50513          	addi	a0,a0,74 # 7190 <malloc+0x113c>
    314e:	00003097          	auipc	ra,0x3
    3152:	b2e080e7          	jalr	-1234(ra) # 5c7c <unlink>
  unlink("12345678901234");
    3156:	00004517          	auipc	a0,0x4
    315a:	1e250513          	addi	a0,a0,482 # 7338 <malloc+0x12e4>
    315e:	00003097          	auipc	ra,0x3
    3162:	b1e080e7          	jalr	-1250(ra) # 5c7c <unlink>
}
    3166:	60e2                	ld	ra,24(sp)
    3168:	6442                	ld	s0,16(sp)
    316a:	64a2                	ld	s1,8(sp)
    316c:	6105                	addi	sp,sp,32
    316e:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    3170:	85a6                	mv	a1,s1
    3172:	00004517          	auipc	a0,0x4
    3176:	ff650513          	addi	a0,a0,-10 # 7168 <malloc+0x1114>
    317a:	00003097          	auipc	ra,0x3
    317e:	e22080e7          	jalr	-478(ra) # 5f9c <printf>
    exit(1);
    3182:	4505                	li	a0,1
    3184:	00003097          	auipc	ra,0x3
    3188:	aa8080e7          	jalr	-1368(ra) # 5c2c <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    318c:	85a6                	mv	a1,s1
    318e:	00004517          	auipc	a0,0x4
    3192:	02250513          	addi	a0,a0,34 # 71b0 <malloc+0x115c>
    3196:	00003097          	auipc	ra,0x3
    319a:	e06080e7          	jalr	-506(ra) # 5f9c <printf>
    exit(1);
    319e:	4505                	li	a0,1
    31a0:	00003097          	auipc	ra,0x3
    31a4:	a8c080e7          	jalr	-1396(ra) # 5c2c <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    31a8:	85a6                	mv	a1,s1
    31aa:	00004517          	auipc	a0,0x4
    31ae:	06e50513          	addi	a0,a0,110 # 7218 <malloc+0x11c4>
    31b2:	00003097          	auipc	ra,0x3
    31b6:	dea080e7          	jalr	-534(ra) # 5f9c <printf>
    exit(1);
    31ba:	4505                	li	a0,1
    31bc:	00003097          	auipc	ra,0x3
    31c0:	a70080e7          	jalr	-1424(ra) # 5c2c <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    31c4:	85a6                	mv	a1,s1
    31c6:	00004517          	auipc	a0,0x4
    31ca:	0ca50513          	addi	a0,a0,202 # 7290 <malloc+0x123c>
    31ce:	00003097          	auipc	ra,0x3
    31d2:	dce080e7          	jalr	-562(ra) # 5f9c <printf>
    exit(1);
    31d6:	4505                	li	a0,1
    31d8:	00003097          	auipc	ra,0x3
    31dc:	a54080e7          	jalr	-1452(ra) # 5c2c <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    31e0:	85a6                	mv	a1,s1
    31e2:	00004517          	auipc	a0,0x4
    31e6:	10e50513          	addi	a0,a0,270 # 72f0 <malloc+0x129c>
    31ea:	00003097          	auipc	ra,0x3
    31ee:	db2080e7          	jalr	-590(ra) # 5f9c <printf>
    exit(1);
    31f2:	4505                	li	a0,1
    31f4:	00003097          	auipc	ra,0x3
    31f8:	a38080e7          	jalr	-1480(ra) # 5c2c <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    31fc:	85a6                	mv	a1,s1
    31fe:	00004517          	auipc	a0,0x4
    3202:	14a50513          	addi	a0,a0,330 # 7348 <malloc+0x12f4>
    3206:	00003097          	auipc	ra,0x3
    320a:	d96080e7          	jalr	-618(ra) # 5f9c <printf>
    exit(1);
    320e:	4505                	li	a0,1
    3210:	00003097          	auipc	ra,0x3
    3214:	a1c080e7          	jalr	-1508(ra) # 5c2c <exit>

0000000000003218 <diskfull>:
{
    3218:	b8010113          	addi	sp,sp,-1152
    321c:	46113c23          	sd	ra,1144(sp)
    3220:	46813823          	sd	s0,1136(sp)
    3224:	46913423          	sd	s1,1128(sp)
    3228:	47213023          	sd	s2,1120(sp)
    322c:	45313c23          	sd	s3,1112(sp)
    3230:	45413823          	sd	s4,1104(sp)
    3234:	45513423          	sd	s5,1096(sp)
    3238:	45613023          	sd	s6,1088(sp)
    323c:	43713c23          	sd	s7,1080(sp)
    3240:	43813823          	sd	s8,1072(sp)
    3244:	43913423          	sd	s9,1064(sp)
    3248:	48010413          	addi	s0,sp,1152
    324c:	8caa                	mv	s9,a0
  unlink("diskfulldir");
    324e:	00004517          	auipc	a0,0x4
    3252:	13250513          	addi	a0,a0,306 # 7380 <malloc+0x132c>
    3256:	00003097          	auipc	ra,0x3
    325a:	a26080e7          	jalr	-1498(ra) # 5c7c <unlink>
    325e:	03000993          	li	s3,48
    name[0] = 'b';
    3262:	06200b13          	li	s6,98
    name[1] = 'i';
    3266:	06900a93          	li	s5,105
    name[2] = 'g';
    326a:	06700a13          	li	s4,103
    326e:	10c00b93          	li	s7,268
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    3272:	07f00c13          	li	s8,127
    3276:	a269                	j	3400 <diskfull+0x1e8>
      printf("%s: could not create file %s\n", s, name);
    3278:	b8040613          	addi	a2,s0,-1152
    327c:	85e6                	mv	a1,s9
    327e:	00004517          	auipc	a0,0x4
    3282:	11250513          	addi	a0,a0,274 # 7390 <malloc+0x133c>
    3286:	00003097          	auipc	ra,0x3
    328a:	d16080e7          	jalr	-746(ra) # 5f9c <printf>
      break;
    328e:	a819                	j	32a4 <diskfull+0x8c>
        close(fd);
    3290:	854a                	mv	a0,s2
    3292:	00003097          	auipc	ra,0x3
    3296:	9c2080e7          	jalr	-1598(ra) # 5c54 <close>
    close(fd);
    329a:	854a                	mv	a0,s2
    329c:	00003097          	auipc	ra,0x3
    32a0:	9b8080e7          	jalr	-1608(ra) # 5c54 <close>
  for(int i = 0; i < nzz; i++){
    32a4:	4481                	li	s1,0
    name[0] = 'z';
    32a6:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    32aa:	08000993          	li	s3,128
    name[0] = 'z';
    32ae:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    32b2:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    32b6:	41f4d71b          	sraiw	a4,s1,0x1f
    32ba:	01b7571b          	srliw	a4,a4,0x1b
    32be:	009707bb          	addw	a5,a4,s1
    32c2:	4057d69b          	sraiw	a3,a5,0x5
    32c6:	0306869b          	addiw	a3,a3,48
    32ca:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    32ce:	8bfd                	andi	a5,a5,31
    32d0:	9f99                	subw	a5,a5,a4
    32d2:	0307879b          	addiw	a5,a5,48
    32d6:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    32da:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    32de:	ba040513          	addi	a0,s0,-1120
    32e2:	00003097          	auipc	ra,0x3
    32e6:	99a080e7          	jalr	-1638(ra) # 5c7c <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    32ea:	60200593          	li	a1,1538
    32ee:	ba040513          	addi	a0,s0,-1120
    32f2:	00003097          	auipc	ra,0x3
    32f6:	97a080e7          	jalr	-1670(ra) # 5c6c <open>
    if(fd < 0)
    32fa:	00054963          	bltz	a0,330c <diskfull+0xf4>
    close(fd);
    32fe:	00003097          	auipc	ra,0x3
    3302:	956080e7          	jalr	-1706(ra) # 5c54 <close>
  for(int i = 0; i < nzz; i++){
    3306:	2485                	addiw	s1,s1,1
    3308:	fb3493e3          	bne	s1,s3,32ae <diskfull+0x96>
  if(mkdir("diskfulldir") == 0)
    330c:	00004517          	auipc	a0,0x4
    3310:	07450513          	addi	a0,a0,116 # 7380 <malloc+0x132c>
    3314:	00003097          	auipc	ra,0x3
    3318:	980080e7          	jalr	-1664(ra) # 5c94 <mkdir>
    331c:	12050e63          	beqz	a0,3458 <diskfull+0x240>
  unlink("diskfulldir");
    3320:	00004517          	auipc	a0,0x4
    3324:	06050513          	addi	a0,a0,96 # 7380 <malloc+0x132c>
    3328:	00003097          	auipc	ra,0x3
    332c:	954080e7          	jalr	-1708(ra) # 5c7c <unlink>
  for(int i = 0; i < nzz; i++){
    3330:	4481                	li	s1,0
    name[0] = 'z';
    3332:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3336:	08000993          	li	s3,128
    name[0] = 'z';
    333a:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    333e:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    3342:	41f4d71b          	sraiw	a4,s1,0x1f
    3346:	01b7571b          	srliw	a4,a4,0x1b
    334a:	009707bb          	addw	a5,a4,s1
    334e:	4057d69b          	sraiw	a3,a5,0x5
    3352:	0306869b          	addiw	a3,a3,48
    3356:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    335a:	8bfd                	andi	a5,a5,31
    335c:	9f99                	subw	a5,a5,a4
    335e:	0307879b          	addiw	a5,a5,48
    3362:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    3366:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    336a:	ba040513          	addi	a0,s0,-1120
    336e:	00003097          	auipc	ra,0x3
    3372:	90e080e7          	jalr	-1778(ra) # 5c7c <unlink>
  for(int i = 0; i < nzz; i++){
    3376:	2485                	addiw	s1,s1,1
    3378:	fd3491e3          	bne	s1,s3,333a <diskfull+0x122>
    337c:	03000493          	li	s1,48
    name[0] = 'b';
    3380:	06200a93          	li	s5,98
    name[1] = 'i';
    3384:	06900a13          	li	s4,105
    name[2] = 'g';
    3388:	06700993          	li	s3,103
  for(int i = 0; '0' + i < 0177; i++){
    338c:	07f00913          	li	s2,127
    name[0] = 'b';
    3390:	bb540023          	sb	s5,-1120(s0)
    name[1] = 'i';
    3394:	bb4400a3          	sb	s4,-1119(s0)
    name[2] = 'g';
    3398:	bb340123          	sb	s3,-1118(s0)
    name[3] = '0' + i;
    339c:	ba9401a3          	sb	s1,-1117(s0)
    name[4] = '\0';
    33a0:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    33a4:	ba040513          	addi	a0,s0,-1120
    33a8:	00003097          	auipc	ra,0x3
    33ac:	8d4080e7          	jalr	-1836(ra) # 5c7c <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    33b0:	2485                	addiw	s1,s1,1
    33b2:	0ff4f493          	zext.b	s1,s1
    33b6:	fd249de3          	bne	s1,s2,3390 <diskfull+0x178>
}
    33ba:	47813083          	ld	ra,1144(sp)
    33be:	47013403          	ld	s0,1136(sp)
    33c2:	46813483          	ld	s1,1128(sp)
    33c6:	46013903          	ld	s2,1120(sp)
    33ca:	45813983          	ld	s3,1112(sp)
    33ce:	45013a03          	ld	s4,1104(sp)
    33d2:	44813a83          	ld	s5,1096(sp)
    33d6:	44013b03          	ld	s6,1088(sp)
    33da:	43813b83          	ld	s7,1080(sp)
    33de:	43013c03          	ld	s8,1072(sp)
    33e2:	42813c83          	ld	s9,1064(sp)
    33e6:	48010113          	addi	sp,sp,1152
    33ea:	8082                	ret
    close(fd);
    33ec:	854a                	mv	a0,s2
    33ee:	00003097          	auipc	ra,0x3
    33f2:	866080e7          	jalr	-1946(ra) # 5c54 <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    33f6:	2985                	addiw	s3,s3,1
    33f8:	0ff9f993          	zext.b	s3,s3
    33fc:	eb8984e3          	beq	s3,s8,32a4 <diskfull+0x8c>
    name[0] = 'b';
    3400:	b9640023          	sb	s6,-1152(s0)
    name[1] = 'i';
    3404:	b95400a3          	sb	s5,-1151(s0)
    name[2] = 'g';
    3408:	b9440123          	sb	s4,-1150(s0)
    name[3] = '0' + fi;
    340c:	b93401a3          	sb	s3,-1149(s0)
    name[4] = '\0';
    3410:	b8040223          	sb	zero,-1148(s0)
    unlink(name);
    3414:	b8040513          	addi	a0,s0,-1152
    3418:	00003097          	auipc	ra,0x3
    341c:	864080e7          	jalr	-1948(ra) # 5c7c <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3420:	60200593          	li	a1,1538
    3424:	b8040513          	addi	a0,s0,-1152
    3428:	00003097          	auipc	ra,0x3
    342c:	844080e7          	jalr	-1980(ra) # 5c6c <open>
    3430:	892a                	mv	s2,a0
    if(fd < 0){
    3432:	e40543e3          	bltz	a0,3278 <diskfull+0x60>
    3436:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    3438:	40000613          	li	a2,1024
    343c:	ba040593          	addi	a1,s0,-1120
    3440:	854a                	mv	a0,s2
    3442:	00003097          	auipc	ra,0x3
    3446:	80a080e7          	jalr	-2038(ra) # 5c4c <write>
    344a:	40000793          	li	a5,1024
    344e:	e4f511e3          	bne	a0,a5,3290 <diskfull+0x78>
    for(int i = 0; i < MAXFILE; i++){
    3452:	34fd                	addiw	s1,s1,-1
    3454:	f0f5                	bnez	s1,3438 <diskfull+0x220>
    3456:	bf59                	j	33ec <diskfull+0x1d4>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    3458:	00004517          	auipc	a0,0x4
    345c:	f5850513          	addi	a0,a0,-168 # 73b0 <malloc+0x135c>
    3460:	00003097          	auipc	ra,0x3
    3464:	b3c080e7          	jalr	-1220(ra) # 5f9c <printf>
    3468:	bd65                	j	3320 <diskfull+0x108>

000000000000346a <iputtest>:
{
    346a:	1101                	addi	sp,sp,-32
    346c:	ec06                	sd	ra,24(sp)
    346e:	e822                	sd	s0,16(sp)
    3470:	e426                	sd	s1,8(sp)
    3472:	1000                	addi	s0,sp,32
    3474:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    3476:	00004517          	auipc	a0,0x4
    347a:	f6a50513          	addi	a0,a0,-150 # 73e0 <malloc+0x138c>
    347e:	00003097          	auipc	ra,0x3
    3482:	816080e7          	jalr	-2026(ra) # 5c94 <mkdir>
    3486:	04054563          	bltz	a0,34d0 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    348a:	00004517          	auipc	a0,0x4
    348e:	f5650513          	addi	a0,a0,-170 # 73e0 <malloc+0x138c>
    3492:	00003097          	auipc	ra,0x3
    3496:	80a080e7          	jalr	-2038(ra) # 5c9c <chdir>
    349a:	04054963          	bltz	a0,34ec <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    349e:	00004517          	auipc	a0,0x4
    34a2:	f8250513          	addi	a0,a0,-126 # 7420 <malloc+0x13cc>
    34a6:	00002097          	auipc	ra,0x2
    34aa:	7d6080e7          	jalr	2006(ra) # 5c7c <unlink>
    34ae:	04054d63          	bltz	a0,3508 <iputtest+0x9e>
  if(chdir("/") < 0){
    34b2:	00004517          	auipc	a0,0x4
    34b6:	f9e50513          	addi	a0,a0,-98 # 7450 <malloc+0x13fc>
    34ba:	00002097          	auipc	ra,0x2
    34be:	7e2080e7          	jalr	2018(ra) # 5c9c <chdir>
    34c2:	06054163          	bltz	a0,3524 <iputtest+0xba>
}
    34c6:	60e2                	ld	ra,24(sp)
    34c8:	6442                	ld	s0,16(sp)
    34ca:	64a2                	ld	s1,8(sp)
    34cc:	6105                	addi	sp,sp,32
    34ce:	8082                	ret
    printf("%s: mkdir failed\n", s);
    34d0:	85a6                	mv	a1,s1
    34d2:	00004517          	auipc	a0,0x4
    34d6:	f1650513          	addi	a0,a0,-234 # 73e8 <malloc+0x1394>
    34da:	00003097          	auipc	ra,0x3
    34de:	ac2080e7          	jalr	-1342(ra) # 5f9c <printf>
    exit(1);
    34e2:	4505                	li	a0,1
    34e4:	00002097          	auipc	ra,0x2
    34e8:	748080e7          	jalr	1864(ra) # 5c2c <exit>
    printf("%s: chdir iputdir failed\n", s);
    34ec:	85a6                	mv	a1,s1
    34ee:	00004517          	auipc	a0,0x4
    34f2:	f1250513          	addi	a0,a0,-238 # 7400 <malloc+0x13ac>
    34f6:	00003097          	auipc	ra,0x3
    34fa:	aa6080e7          	jalr	-1370(ra) # 5f9c <printf>
    exit(1);
    34fe:	4505                	li	a0,1
    3500:	00002097          	auipc	ra,0x2
    3504:	72c080e7          	jalr	1836(ra) # 5c2c <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3508:	85a6                	mv	a1,s1
    350a:	00004517          	auipc	a0,0x4
    350e:	f2650513          	addi	a0,a0,-218 # 7430 <malloc+0x13dc>
    3512:	00003097          	auipc	ra,0x3
    3516:	a8a080e7          	jalr	-1398(ra) # 5f9c <printf>
    exit(1);
    351a:	4505                	li	a0,1
    351c:	00002097          	auipc	ra,0x2
    3520:	710080e7          	jalr	1808(ra) # 5c2c <exit>
    printf("%s: chdir / failed\n", s);
    3524:	85a6                	mv	a1,s1
    3526:	00004517          	auipc	a0,0x4
    352a:	f3250513          	addi	a0,a0,-206 # 7458 <malloc+0x1404>
    352e:	00003097          	auipc	ra,0x3
    3532:	a6e080e7          	jalr	-1426(ra) # 5f9c <printf>
    exit(1);
    3536:	4505                	li	a0,1
    3538:	00002097          	auipc	ra,0x2
    353c:	6f4080e7          	jalr	1780(ra) # 5c2c <exit>

0000000000003540 <exitiputtest>:
{
    3540:	7179                	addi	sp,sp,-48
    3542:	f406                	sd	ra,40(sp)
    3544:	f022                	sd	s0,32(sp)
    3546:	ec26                	sd	s1,24(sp)
    3548:	1800                	addi	s0,sp,48
    354a:	84aa                	mv	s1,a0
  pid = fork();
    354c:	00002097          	auipc	ra,0x2
    3550:	6d8080e7          	jalr	1752(ra) # 5c24 <fork>
  if(pid < 0){
    3554:	04054663          	bltz	a0,35a0 <exitiputtest+0x60>
  if(pid == 0){
    3558:	ed45                	bnez	a0,3610 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    355a:	00004517          	auipc	a0,0x4
    355e:	e8650513          	addi	a0,a0,-378 # 73e0 <malloc+0x138c>
    3562:	00002097          	auipc	ra,0x2
    3566:	732080e7          	jalr	1842(ra) # 5c94 <mkdir>
    356a:	04054963          	bltz	a0,35bc <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    356e:	00004517          	auipc	a0,0x4
    3572:	e7250513          	addi	a0,a0,-398 # 73e0 <malloc+0x138c>
    3576:	00002097          	auipc	ra,0x2
    357a:	726080e7          	jalr	1830(ra) # 5c9c <chdir>
    357e:	04054d63          	bltz	a0,35d8 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    3582:	00004517          	auipc	a0,0x4
    3586:	e9e50513          	addi	a0,a0,-354 # 7420 <malloc+0x13cc>
    358a:	00002097          	auipc	ra,0x2
    358e:	6f2080e7          	jalr	1778(ra) # 5c7c <unlink>
    3592:	06054163          	bltz	a0,35f4 <exitiputtest+0xb4>
    exit(0);
    3596:	4501                	li	a0,0
    3598:	00002097          	auipc	ra,0x2
    359c:	694080e7          	jalr	1684(ra) # 5c2c <exit>
    printf("%s: fork failed\n", s);
    35a0:	85a6                	mv	a1,s1
    35a2:	00003517          	auipc	a0,0x3
    35a6:	47e50513          	addi	a0,a0,1150 # 6a20 <malloc+0x9cc>
    35aa:	00003097          	auipc	ra,0x3
    35ae:	9f2080e7          	jalr	-1550(ra) # 5f9c <printf>
    exit(1);
    35b2:	4505                	li	a0,1
    35b4:	00002097          	auipc	ra,0x2
    35b8:	678080e7          	jalr	1656(ra) # 5c2c <exit>
      printf("%s: mkdir failed\n", s);
    35bc:	85a6                	mv	a1,s1
    35be:	00004517          	auipc	a0,0x4
    35c2:	e2a50513          	addi	a0,a0,-470 # 73e8 <malloc+0x1394>
    35c6:	00003097          	auipc	ra,0x3
    35ca:	9d6080e7          	jalr	-1578(ra) # 5f9c <printf>
      exit(1);
    35ce:	4505                	li	a0,1
    35d0:	00002097          	auipc	ra,0x2
    35d4:	65c080e7          	jalr	1628(ra) # 5c2c <exit>
      printf("%s: child chdir failed\n", s);
    35d8:	85a6                	mv	a1,s1
    35da:	00004517          	auipc	a0,0x4
    35de:	e9650513          	addi	a0,a0,-362 # 7470 <malloc+0x141c>
    35e2:	00003097          	auipc	ra,0x3
    35e6:	9ba080e7          	jalr	-1606(ra) # 5f9c <printf>
      exit(1);
    35ea:	4505                	li	a0,1
    35ec:	00002097          	auipc	ra,0x2
    35f0:	640080e7          	jalr	1600(ra) # 5c2c <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    35f4:	85a6                	mv	a1,s1
    35f6:	00004517          	auipc	a0,0x4
    35fa:	e3a50513          	addi	a0,a0,-454 # 7430 <malloc+0x13dc>
    35fe:	00003097          	auipc	ra,0x3
    3602:	99e080e7          	jalr	-1634(ra) # 5f9c <printf>
      exit(1);
    3606:	4505                	li	a0,1
    3608:	00002097          	auipc	ra,0x2
    360c:	624080e7          	jalr	1572(ra) # 5c2c <exit>
  wait(&xstatus);
    3610:	fdc40513          	addi	a0,s0,-36
    3614:	00002097          	auipc	ra,0x2
    3618:	620080e7          	jalr	1568(ra) # 5c34 <wait>
  exit(xstatus);
    361c:	fdc42503          	lw	a0,-36(s0)
    3620:	00002097          	auipc	ra,0x2
    3624:	60c080e7          	jalr	1548(ra) # 5c2c <exit>

0000000000003628 <dirtest>:
{
    3628:	1101                	addi	sp,sp,-32
    362a:	ec06                	sd	ra,24(sp)
    362c:	e822                	sd	s0,16(sp)
    362e:	e426                	sd	s1,8(sp)
    3630:	1000                	addi	s0,sp,32
    3632:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    3634:	00004517          	auipc	a0,0x4
    3638:	e5450513          	addi	a0,a0,-428 # 7488 <malloc+0x1434>
    363c:	00002097          	auipc	ra,0x2
    3640:	658080e7          	jalr	1624(ra) # 5c94 <mkdir>
    3644:	04054563          	bltz	a0,368e <dirtest+0x66>
  if(chdir("dir0") < 0){
    3648:	00004517          	auipc	a0,0x4
    364c:	e4050513          	addi	a0,a0,-448 # 7488 <malloc+0x1434>
    3650:	00002097          	auipc	ra,0x2
    3654:	64c080e7          	jalr	1612(ra) # 5c9c <chdir>
    3658:	04054963          	bltz	a0,36aa <dirtest+0x82>
  if(chdir("..") < 0){
    365c:	00004517          	auipc	a0,0x4
    3660:	e4c50513          	addi	a0,a0,-436 # 74a8 <malloc+0x1454>
    3664:	00002097          	auipc	ra,0x2
    3668:	638080e7          	jalr	1592(ra) # 5c9c <chdir>
    366c:	04054d63          	bltz	a0,36c6 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    3670:	00004517          	auipc	a0,0x4
    3674:	e1850513          	addi	a0,a0,-488 # 7488 <malloc+0x1434>
    3678:	00002097          	auipc	ra,0x2
    367c:	604080e7          	jalr	1540(ra) # 5c7c <unlink>
    3680:	06054163          	bltz	a0,36e2 <dirtest+0xba>
}
    3684:	60e2                	ld	ra,24(sp)
    3686:	6442                	ld	s0,16(sp)
    3688:	64a2                	ld	s1,8(sp)
    368a:	6105                	addi	sp,sp,32
    368c:	8082                	ret
    printf("%s: mkdir failed\n", s);
    368e:	85a6                	mv	a1,s1
    3690:	00004517          	auipc	a0,0x4
    3694:	d5850513          	addi	a0,a0,-680 # 73e8 <malloc+0x1394>
    3698:	00003097          	auipc	ra,0x3
    369c:	904080e7          	jalr	-1788(ra) # 5f9c <printf>
    exit(1);
    36a0:	4505                	li	a0,1
    36a2:	00002097          	auipc	ra,0x2
    36a6:	58a080e7          	jalr	1418(ra) # 5c2c <exit>
    printf("%s: chdir dir0 failed\n", s);
    36aa:	85a6                	mv	a1,s1
    36ac:	00004517          	auipc	a0,0x4
    36b0:	de450513          	addi	a0,a0,-540 # 7490 <malloc+0x143c>
    36b4:	00003097          	auipc	ra,0x3
    36b8:	8e8080e7          	jalr	-1816(ra) # 5f9c <printf>
    exit(1);
    36bc:	4505                	li	a0,1
    36be:	00002097          	auipc	ra,0x2
    36c2:	56e080e7          	jalr	1390(ra) # 5c2c <exit>
    printf("%s: chdir .. failed\n", s);
    36c6:	85a6                	mv	a1,s1
    36c8:	00004517          	auipc	a0,0x4
    36cc:	de850513          	addi	a0,a0,-536 # 74b0 <malloc+0x145c>
    36d0:	00003097          	auipc	ra,0x3
    36d4:	8cc080e7          	jalr	-1844(ra) # 5f9c <printf>
    exit(1);
    36d8:	4505                	li	a0,1
    36da:	00002097          	auipc	ra,0x2
    36de:	552080e7          	jalr	1362(ra) # 5c2c <exit>
    printf("%s: unlink dir0 failed\n", s);
    36e2:	85a6                	mv	a1,s1
    36e4:	00004517          	auipc	a0,0x4
    36e8:	de450513          	addi	a0,a0,-540 # 74c8 <malloc+0x1474>
    36ec:	00003097          	auipc	ra,0x3
    36f0:	8b0080e7          	jalr	-1872(ra) # 5f9c <printf>
    exit(1);
    36f4:	4505                	li	a0,1
    36f6:	00002097          	auipc	ra,0x2
    36fa:	536080e7          	jalr	1334(ra) # 5c2c <exit>

00000000000036fe <subdir>:
{
    36fe:	1101                	addi	sp,sp,-32
    3700:	ec06                	sd	ra,24(sp)
    3702:	e822                	sd	s0,16(sp)
    3704:	e426                	sd	s1,8(sp)
    3706:	e04a                	sd	s2,0(sp)
    3708:	1000                	addi	s0,sp,32
    370a:	892a                	mv	s2,a0
  unlink("ff");
    370c:	00004517          	auipc	a0,0x4
    3710:	f0450513          	addi	a0,a0,-252 # 7610 <malloc+0x15bc>
    3714:	00002097          	auipc	ra,0x2
    3718:	568080e7          	jalr	1384(ra) # 5c7c <unlink>
  if(mkdir("dd") != 0){
    371c:	00004517          	auipc	a0,0x4
    3720:	dc450513          	addi	a0,a0,-572 # 74e0 <malloc+0x148c>
    3724:	00002097          	auipc	ra,0x2
    3728:	570080e7          	jalr	1392(ra) # 5c94 <mkdir>
    372c:	38051663          	bnez	a0,3ab8 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    3730:	20200593          	li	a1,514
    3734:	00004517          	auipc	a0,0x4
    3738:	dcc50513          	addi	a0,a0,-564 # 7500 <malloc+0x14ac>
    373c:	00002097          	auipc	ra,0x2
    3740:	530080e7          	jalr	1328(ra) # 5c6c <open>
    3744:	84aa                	mv	s1,a0
  if(fd < 0){
    3746:	38054763          	bltz	a0,3ad4 <subdir+0x3d6>
  write(fd, "ff", 2);
    374a:	4609                	li	a2,2
    374c:	00004597          	auipc	a1,0x4
    3750:	ec458593          	addi	a1,a1,-316 # 7610 <malloc+0x15bc>
    3754:	00002097          	auipc	ra,0x2
    3758:	4f8080e7          	jalr	1272(ra) # 5c4c <write>
  close(fd);
    375c:	8526                	mv	a0,s1
    375e:	00002097          	auipc	ra,0x2
    3762:	4f6080e7          	jalr	1270(ra) # 5c54 <close>
  if(unlink("dd") >= 0){
    3766:	00004517          	auipc	a0,0x4
    376a:	d7a50513          	addi	a0,a0,-646 # 74e0 <malloc+0x148c>
    376e:	00002097          	auipc	ra,0x2
    3772:	50e080e7          	jalr	1294(ra) # 5c7c <unlink>
    3776:	36055d63          	bgez	a0,3af0 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    377a:	00004517          	auipc	a0,0x4
    377e:	dde50513          	addi	a0,a0,-546 # 7558 <malloc+0x1504>
    3782:	00002097          	auipc	ra,0x2
    3786:	512080e7          	jalr	1298(ra) # 5c94 <mkdir>
    378a:	38051163          	bnez	a0,3b0c <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    378e:	20200593          	li	a1,514
    3792:	00004517          	auipc	a0,0x4
    3796:	dee50513          	addi	a0,a0,-530 # 7580 <malloc+0x152c>
    379a:	00002097          	auipc	ra,0x2
    379e:	4d2080e7          	jalr	1234(ra) # 5c6c <open>
    37a2:	84aa                	mv	s1,a0
  if(fd < 0){
    37a4:	38054263          	bltz	a0,3b28 <subdir+0x42a>
  write(fd, "FF", 2);
    37a8:	4609                	li	a2,2
    37aa:	00004597          	auipc	a1,0x4
    37ae:	e0658593          	addi	a1,a1,-506 # 75b0 <malloc+0x155c>
    37b2:	00002097          	auipc	ra,0x2
    37b6:	49a080e7          	jalr	1178(ra) # 5c4c <write>
  close(fd);
    37ba:	8526                	mv	a0,s1
    37bc:	00002097          	auipc	ra,0x2
    37c0:	498080e7          	jalr	1176(ra) # 5c54 <close>
  fd = open("dd/dd/../ff", 0);
    37c4:	4581                	li	a1,0
    37c6:	00004517          	auipc	a0,0x4
    37ca:	df250513          	addi	a0,a0,-526 # 75b8 <malloc+0x1564>
    37ce:	00002097          	auipc	ra,0x2
    37d2:	49e080e7          	jalr	1182(ra) # 5c6c <open>
    37d6:	84aa                	mv	s1,a0
  if(fd < 0){
    37d8:	36054663          	bltz	a0,3b44 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    37dc:	660d                	lui	a2,0x3
    37de:	0000b597          	auipc	a1,0xb
    37e2:	83a58593          	addi	a1,a1,-1990 # e018 <buf>
    37e6:	00002097          	auipc	ra,0x2
    37ea:	45e080e7          	jalr	1118(ra) # 5c44 <read>
  if(cc != 2 || buf[0] != 'f'){
    37ee:	4789                	li	a5,2
    37f0:	36f51863          	bne	a0,a5,3b60 <subdir+0x462>
    37f4:	0000b717          	auipc	a4,0xb
    37f8:	82474703          	lbu	a4,-2012(a4) # e018 <buf>
    37fc:	06600793          	li	a5,102
    3800:	36f71063          	bne	a4,a5,3b60 <subdir+0x462>
  close(fd);
    3804:	8526                	mv	a0,s1
    3806:	00002097          	auipc	ra,0x2
    380a:	44e080e7          	jalr	1102(ra) # 5c54 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    380e:	00004597          	auipc	a1,0x4
    3812:	dfa58593          	addi	a1,a1,-518 # 7608 <malloc+0x15b4>
    3816:	00004517          	auipc	a0,0x4
    381a:	d6a50513          	addi	a0,a0,-662 # 7580 <malloc+0x152c>
    381e:	00002097          	auipc	ra,0x2
    3822:	46e080e7          	jalr	1134(ra) # 5c8c <link>
    3826:	34051b63          	bnez	a0,3b7c <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    382a:	00004517          	auipc	a0,0x4
    382e:	d5650513          	addi	a0,a0,-682 # 7580 <malloc+0x152c>
    3832:	00002097          	auipc	ra,0x2
    3836:	44a080e7          	jalr	1098(ra) # 5c7c <unlink>
    383a:	34051f63          	bnez	a0,3b98 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    383e:	4581                	li	a1,0
    3840:	00004517          	auipc	a0,0x4
    3844:	d4050513          	addi	a0,a0,-704 # 7580 <malloc+0x152c>
    3848:	00002097          	auipc	ra,0x2
    384c:	424080e7          	jalr	1060(ra) # 5c6c <open>
    3850:	36055263          	bgez	a0,3bb4 <subdir+0x4b6>
  if(chdir("dd") != 0){
    3854:	00004517          	auipc	a0,0x4
    3858:	c8c50513          	addi	a0,a0,-884 # 74e0 <malloc+0x148c>
    385c:	00002097          	auipc	ra,0x2
    3860:	440080e7          	jalr	1088(ra) # 5c9c <chdir>
    3864:	36051663          	bnez	a0,3bd0 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    3868:	00004517          	auipc	a0,0x4
    386c:	e3850513          	addi	a0,a0,-456 # 76a0 <malloc+0x164c>
    3870:	00002097          	auipc	ra,0x2
    3874:	42c080e7          	jalr	1068(ra) # 5c9c <chdir>
    3878:	36051a63          	bnez	a0,3bec <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    387c:	00004517          	auipc	a0,0x4
    3880:	e5450513          	addi	a0,a0,-428 # 76d0 <malloc+0x167c>
    3884:	00002097          	auipc	ra,0x2
    3888:	418080e7          	jalr	1048(ra) # 5c9c <chdir>
    388c:	36051e63          	bnez	a0,3c08 <subdir+0x50a>
  if(chdir("./..") != 0){
    3890:	00004517          	auipc	a0,0x4
    3894:	e7050513          	addi	a0,a0,-400 # 7700 <malloc+0x16ac>
    3898:	00002097          	auipc	ra,0x2
    389c:	404080e7          	jalr	1028(ra) # 5c9c <chdir>
    38a0:	38051263          	bnez	a0,3c24 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    38a4:	4581                	li	a1,0
    38a6:	00004517          	auipc	a0,0x4
    38aa:	d6250513          	addi	a0,a0,-670 # 7608 <malloc+0x15b4>
    38ae:	00002097          	auipc	ra,0x2
    38b2:	3be080e7          	jalr	958(ra) # 5c6c <open>
    38b6:	84aa                	mv	s1,a0
  if(fd < 0){
    38b8:	38054463          	bltz	a0,3c40 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    38bc:	660d                	lui	a2,0x3
    38be:	0000a597          	auipc	a1,0xa
    38c2:	75a58593          	addi	a1,a1,1882 # e018 <buf>
    38c6:	00002097          	auipc	ra,0x2
    38ca:	37e080e7          	jalr	894(ra) # 5c44 <read>
    38ce:	4789                	li	a5,2
    38d0:	38f51663          	bne	a0,a5,3c5c <subdir+0x55e>
  close(fd);
    38d4:	8526                	mv	a0,s1
    38d6:	00002097          	auipc	ra,0x2
    38da:	37e080e7          	jalr	894(ra) # 5c54 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    38de:	4581                	li	a1,0
    38e0:	00004517          	auipc	a0,0x4
    38e4:	ca050513          	addi	a0,a0,-864 # 7580 <malloc+0x152c>
    38e8:	00002097          	auipc	ra,0x2
    38ec:	384080e7          	jalr	900(ra) # 5c6c <open>
    38f0:	38055463          	bgez	a0,3c78 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    38f4:	20200593          	li	a1,514
    38f8:	00004517          	auipc	a0,0x4
    38fc:	e9850513          	addi	a0,a0,-360 # 7790 <malloc+0x173c>
    3900:	00002097          	auipc	ra,0x2
    3904:	36c080e7          	jalr	876(ra) # 5c6c <open>
    3908:	38055663          	bgez	a0,3c94 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    390c:	20200593          	li	a1,514
    3910:	00004517          	auipc	a0,0x4
    3914:	eb050513          	addi	a0,a0,-336 # 77c0 <malloc+0x176c>
    3918:	00002097          	auipc	ra,0x2
    391c:	354080e7          	jalr	852(ra) # 5c6c <open>
    3920:	38055863          	bgez	a0,3cb0 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    3924:	20000593          	li	a1,512
    3928:	00004517          	auipc	a0,0x4
    392c:	bb850513          	addi	a0,a0,-1096 # 74e0 <malloc+0x148c>
    3930:	00002097          	auipc	ra,0x2
    3934:	33c080e7          	jalr	828(ra) # 5c6c <open>
    3938:	38055a63          	bgez	a0,3ccc <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    393c:	4589                	li	a1,2
    393e:	00004517          	auipc	a0,0x4
    3942:	ba250513          	addi	a0,a0,-1118 # 74e0 <malloc+0x148c>
    3946:	00002097          	auipc	ra,0x2
    394a:	326080e7          	jalr	806(ra) # 5c6c <open>
    394e:	38055d63          	bgez	a0,3ce8 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    3952:	4585                	li	a1,1
    3954:	00004517          	auipc	a0,0x4
    3958:	b8c50513          	addi	a0,a0,-1140 # 74e0 <malloc+0x148c>
    395c:	00002097          	auipc	ra,0x2
    3960:	310080e7          	jalr	784(ra) # 5c6c <open>
    3964:	3a055063          	bgez	a0,3d04 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3968:	00004597          	auipc	a1,0x4
    396c:	ee858593          	addi	a1,a1,-280 # 7850 <malloc+0x17fc>
    3970:	00004517          	auipc	a0,0x4
    3974:	e2050513          	addi	a0,a0,-480 # 7790 <malloc+0x173c>
    3978:	00002097          	auipc	ra,0x2
    397c:	314080e7          	jalr	788(ra) # 5c8c <link>
    3980:	3a050063          	beqz	a0,3d20 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3984:	00004597          	auipc	a1,0x4
    3988:	ecc58593          	addi	a1,a1,-308 # 7850 <malloc+0x17fc>
    398c:	00004517          	auipc	a0,0x4
    3990:	e3450513          	addi	a0,a0,-460 # 77c0 <malloc+0x176c>
    3994:	00002097          	auipc	ra,0x2
    3998:	2f8080e7          	jalr	760(ra) # 5c8c <link>
    399c:	3a050063          	beqz	a0,3d3c <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    39a0:	00004597          	auipc	a1,0x4
    39a4:	c6858593          	addi	a1,a1,-920 # 7608 <malloc+0x15b4>
    39a8:	00004517          	auipc	a0,0x4
    39ac:	b5850513          	addi	a0,a0,-1192 # 7500 <malloc+0x14ac>
    39b0:	00002097          	auipc	ra,0x2
    39b4:	2dc080e7          	jalr	732(ra) # 5c8c <link>
    39b8:	3a050063          	beqz	a0,3d58 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    39bc:	00004517          	auipc	a0,0x4
    39c0:	dd450513          	addi	a0,a0,-556 # 7790 <malloc+0x173c>
    39c4:	00002097          	auipc	ra,0x2
    39c8:	2d0080e7          	jalr	720(ra) # 5c94 <mkdir>
    39cc:	3a050463          	beqz	a0,3d74 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    39d0:	00004517          	auipc	a0,0x4
    39d4:	df050513          	addi	a0,a0,-528 # 77c0 <malloc+0x176c>
    39d8:	00002097          	auipc	ra,0x2
    39dc:	2bc080e7          	jalr	700(ra) # 5c94 <mkdir>
    39e0:	3a050863          	beqz	a0,3d90 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    39e4:	00004517          	auipc	a0,0x4
    39e8:	c2450513          	addi	a0,a0,-988 # 7608 <malloc+0x15b4>
    39ec:	00002097          	auipc	ra,0x2
    39f0:	2a8080e7          	jalr	680(ra) # 5c94 <mkdir>
    39f4:	3a050c63          	beqz	a0,3dac <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    39f8:	00004517          	auipc	a0,0x4
    39fc:	dc850513          	addi	a0,a0,-568 # 77c0 <malloc+0x176c>
    3a00:	00002097          	auipc	ra,0x2
    3a04:	27c080e7          	jalr	636(ra) # 5c7c <unlink>
    3a08:	3c050063          	beqz	a0,3dc8 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3a0c:	00004517          	auipc	a0,0x4
    3a10:	d8450513          	addi	a0,a0,-636 # 7790 <malloc+0x173c>
    3a14:	00002097          	auipc	ra,0x2
    3a18:	268080e7          	jalr	616(ra) # 5c7c <unlink>
    3a1c:	3c050463          	beqz	a0,3de4 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    3a20:	00004517          	auipc	a0,0x4
    3a24:	ae050513          	addi	a0,a0,-1312 # 7500 <malloc+0x14ac>
    3a28:	00002097          	auipc	ra,0x2
    3a2c:	274080e7          	jalr	628(ra) # 5c9c <chdir>
    3a30:	3c050863          	beqz	a0,3e00 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3a34:	00004517          	auipc	a0,0x4
    3a38:	f6c50513          	addi	a0,a0,-148 # 79a0 <malloc+0x194c>
    3a3c:	00002097          	auipc	ra,0x2
    3a40:	260080e7          	jalr	608(ra) # 5c9c <chdir>
    3a44:	3c050c63          	beqz	a0,3e1c <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3a48:	00004517          	auipc	a0,0x4
    3a4c:	bc050513          	addi	a0,a0,-1088 # 7608 <malloc+0x15b4>
    3a50:	00002097          	auipc	ra,0x2
    3a54:	22c080e7          	jalr	556(ra) # 5c7c <unlink>
    3a58:	3e051063          	bnez	a0,3e38 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3a5c:	00004517          	auipc	a0,0x4
    3a60:	aa450513          	addi	a0,a0,-1372 # 7500 <malloc+0x14ac>
    3a64:	00002097          	auipc	ra,0x2
    3a68:	218080e7          	jalr	536(ra) # 5c7c <unlink>
    3a6c:	3e051463          	bnez	a0,3e54 <subdir+0x756>
  if(unlink("dd") == 0){
    3a70:	00004517          	auipc	a0,0x4
    3a74:	a7050513          	addi	a0,a0,-1424 # 74e0 <malloc+0x148c>
    3a78:	00002097          	auipc	ra,0x2
    3a7c:	204080e7          	jalr	516(ra) # 5c7c <unlink>
    3a80:	3e050863          	beqz	a0,3e70 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3a84:	00004517          	auipc	a0,0x4
    3a88:	f8c50513          	addi	a0,a0,-116 # 7a10 <malloc+0x19bc>
    3a8c:	00002097          	auipc	ra,0x2
    3a90:	1f0080e7          	jalr	496(ra) # 5c7c <unlink>
    3a94:	3e054c63          	bltz	a0,3e8c <subdir+0x78e>
  if(unlink("dd") < 0){
    3a98:	00004517          	auipc	a0,0x4
    3a9c:	a4850513          	addi	a0,a0,-1464 # 74e0 <malloc+0x148c>
    3aa0:	00002097          	auipc	ra,0x2
    3aa4:	1dc080e7          	jalr	476(ra) # 5c7c <unlink>
    3aa8:	40054063          	bltz	a0,3ea8 <subdir+0x7aa>
}
    3aac:	60e2                	ld	ra,24(sp)
    3aae:	6442                	ld	s0,16(sp)
    3ab0:	64a2                	ld	s1,8(sp)
    3ab2:	6902                	ld	s2,0(sp)
    3ab4:	6105                	addi	sp,sp,32
    3ab6:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3ab8:	85ca                	mv	a1,s2
    3aba:	00004517          	auipc	a0,0x4
    3abe:	a2e50513          	addi	a0,a0,-1490 # 74e8 <malloc+0x1494>
    3ac2:	00002097          	auipc	ra,0x2
    3ac6:	4da080e7          	jalr	1242(ra) # 5f9c <printf>
    exit(1);
    3aca:	4505                	li	a0,1
    3acc:	00002097          	auipc	ra,0x2
    3ad0:	160080e7          	jalr	352(ra) # 5c2c <exit>
    printf("%s: create dd/ff failed\n", s);
    3ad4:	85ca                	mv	a1,s2
    3ad6:	00004517          	auipc	a0,0x4
    3ada:	a3250513          	addi	a0,a0,-1486 # 7508 <malloc+0x14b4>
    3ade:	00002097          	auipc	ra,0x2
    3ae2:	4be080e7          	jalr	1214(ra) # 5f9c <printf>
    exit(1);
    3ae6:	4505                	li	a0,1
    3ae8:	00002097          	auipc	ra,0x2
    3aec:	144080e7          	jalr	324(ra) # 5c2c <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3af0:	85ca                	mv	a1,s2
    3af2:	00004517          	auipc	a0,0x4
    3af6:	a3650513          	addi	a0,a0,-1482 # 7528 <malloc+0x14d4>
    3afa:	00002097          	auipc	ra,0x2
    3afe:	4a2080e7          	jalr	1186(ra) # 5f9c <printf>
    exit(1);
    3b02:	4505                	li	a0,1
    3b04:	00002097          	auipc	ra,0x2
    3b08:	128080e7          	jalr	296(ra) # 5c2c <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3b0c:	85ca                	mv	a1,s2
    3b0e:	00004517          	auipc	a0,0x4
    3b12:	a5250513          	addi	a0,a0,-1454 # 7560 <malloc+0x150c>
    3b16:	00002097          	auipc	ra,0x2
    3b1a:	486080e7          	jalr	1158(ra) # 5f9c <printf>
    exit(1);
    3b1e:	4505                	li	a0,1
    3b20:	00002097          	auipc	ra,0x2
    3b24:	10c080e7          	jalr	268(ra) # 5c2c <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3b28:	85ca                	mv	a1,s2
    3b2a:	00004517          	auipc	a0,0x4
    3b2e:	a6650513          	addi	a0,a0,-1434 # 7590 <malloc+0x153c>
    3b32:	00002097          	auipc	ra,0x2
    3b36:	46a080e7          	jalr	1130(ra) # 5f9c <printf>
    exit(1);
    3b3a:	4505                	li	a0,1
    3b3c:	00002097          	auipc	ra,0x2
    3b40:	0f0080e7          	jalr	240(ra) # 5c2c <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3b44:	85ca                	mv	a1,s2
    3b46:	00004517          	auipc	a0,0x4
    3b4a:	a8250513          	addi	a0,a0,-1406 # 75c8 <malloc+0x1574>
    3b4e:	00002097          	auipc	ra,0x2
    3b52:	44e080e7          	jalr	1102(ra) # 5f9c <printf>
    exit(1);
    3b56:	4505                	li	a0,1
    3b58:	00002097          	auipc	ra,0x2
    3b5c:	0d4080e7          	jalr	212(ra) # 5c2c <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3b60:	85ca                	mv	a1,s2
    3b62:	00004517          	auipc	a0,0x4
    3b66:	a8650513          	addi	a0,a0,-1402 # 75e8 <malloc+0x1594>
    3b6a:	00002097          	auipc	ra,0x2
    3b6e:	432080e7          	jalr	1074(ra) # 5f9c <printf>
    exit(1);
    3b72:	4505                	li	a0,1
    3b74:	00002097          	auipc	ra,0x2
    3b78:	0b8080e7          	jalr	184(ra) # 5c2c <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3b7c:	85ca                	mv	a1,s2
    3b7e:	00004517          	auipc	a0,0x4
    3b82:	a9a50513          	addi	a0,a0,-1382 # 7618 <malloc+0x15c4>
    3b86:	00002097          	auipc	ra,0x2
    3b8a:	416080e7          	jalr	1046(ra) # 5f9c <printf>
    exit(1);
    3b8e:	4505                	li	a0,1
    3b90:	00002097          	auipc	ra,0x2
    3b94:	09c080e7          	jalr	156(ra) # 5c2c <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3b98:	85ca                	mv	a1,s2
    3b9a:	00004517          	auipc	a0,0x4
    3b9e:	aa650513          	addi	a0,a0,-1370 # 7640 <malloc+0x15ec>
    3ba2:	00002097          	auipc	ra,0x2
    3ba6:	3fa080e7          	jalr	1018(ra) # 5f9c <printf>
    exit(1);
    3baa:	4505                	li	a0,1
    3bac:	00002097          	auipc	ra,0x2
    3bb0:	080080e7          	jalr	128(ra) # 5c2c <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3bb4:	85ca                	mv	a1,s2
    3bb6:	00004517          	auipc	a0,0x4
    3bba:	aaa50513          	addi	a0,a0,-1366 # 7660 <malloc+0x160c>
    3bbe:	00002097          	auipc	ra,0x2
    3bc2:	3de080e7          	jalr	990(ra) # 5f9c <printf>
    exit(1);
    3bc6:	4505                	li	a0,1
    3bc8:	00002097          	auipc	ra,0x2
    3bcc:	064080e7          	jalr	100(ra) # 5c2c <exit>
    printf("%s: chdir dd failed\n", s);
    3bd0:	85ca                	mv	a1,s2
    3bd2:	00004517          	auipc	a0,0x4
    3bd6:	ab650513          	addi	a0,a0,-1354 # 7688 <malloc+0x1634>
    3bda:	00002097          	auipc	ra,0x2
    3bde:	3c2080e7          	jalr	962(ra) # 5f9c <printf>
    exit(1);
    3be2:	4505                	li	a0,1
    3be4:	00002097          	auipc	ra,0x2
    3be8:	048080e7          	jalr	72(ra) # 5c2c <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3bec:	85ca                	mv	a1,s2
    3bee:	00004517          	auipc	a0,0x4
    3bf2:	ac250513          	addi	a0,a0,-1342 # 76b0 <malloc+0x165c>
    3bf6:	00002097          	auipc	ra,0x2
    3bfa:	3a6080e7          	jalr	934(ra) # 5f9c <printf>
    exit(1);
    3bfe:	4505                	li	a0,1
    3c00:	00002097          	auipc	ra,0x2
    3c04:	02c080e7          	jalr	44(ra) # 5c2c <exit>
    printf("chdir dd/../../dd failed\n", s);
    3c08:	85ca                	mv	a1,s2
    3c0a:	00004517          	auipc	a0,0x4
    3c0e:	ad650513          	addi	a0,a0,-1322 # 76e0 <malloc+0x168c>
    3c12:	00002097          	auipc	ra,0x2
    3c16:	38a080e7          	jalr	906(ra) # 5f9c <printf>
    exit(1);
    3c1a:	4505                	li	a0,1
    3c1c:	00002097          	auipc	ra,0x2
    3c20:	010080e7          	jalr	16(ra) # 5c2c <exit>
    printf("%s: chdir ./.. failed\n", s);
    3c24:	85ca                	mv	a1,s2
    3c26:	00004517          	auipc	a0,0x4
    3c2a:	ae250513          	addi	a0,a0,-1310 # 7708 <malloc+0x16b4>
    3c2e:	00002097          	auipc	ra,0x2
    3c32:	36e080e7          	jalr	878(ra) # 5f9c <printf>
    exit(1);
    3c36:	4505                	li	a0,1
    3c38:	00002097          	auipc	ra,0x2
    3c3c:	ff4080e7          	jalr	-12(ra) # 5c2c <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3c40:	85ca                	mv	a1,s2
    3c42:	00004517          	auipc	a0,0x4
    3c46:	ade50513          	addi	a0,a0,-1314 # 7720 <malloc+0x16cc>
    3c4a:	00002097          	auipc	ra,0x2
    3c4e:	352080e7          	jalr	850(ra) # 5f9c <printf>
    exit(1);
    3c52:	4505                	li	a0,1
    3c54:	00002097          	auipc	ra,0x2
    3c58:	fd8080e7          	jalr	-40(ra) # 5c2c <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3c5c:	85ca                	mv	a1,s2
    3c5e:	00004517          	auipc	a0,0x4
    3c62:	ae250513          	addi	a0,a0,-1310 # 7740 <malloc+0x16ec>
    3c66:	00002097          	auipc	ra,0x2
    3c6a:	336080e7          	jalr	822(ra) # 5f9c <printf>
    exit(1);
    3c6e:	4505                	li	a0,1
    3c70:	00002097          	auipc	ra,0x2
    3c74:	fbc080e7          	jalr	-68(ra) # 5c2c <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3c78:	85ca                	mv	a1,s2
    3c7a:	00004517          	auipc	a0,0x4
    3c7e:	ae650513          	addi	a0,a0,-1306 # 7760 <malloc+0x170c>
    3c82:	00002097          	auipc	ra,0x2
    3c86:	31a080e7          	jalr	794(ra) # 5f9c <printf>
    exit(1);
    3c8a:	4505                	li	a0,1
    3c8c:	00002097          	auipc	ra,0x2
    3c90:	fa0080e7          	jalr	-96(ra) # 5c2c <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3c94:	85ca                	mv	a1,s2
    3c96:	00004517          	auipc	a0,0x4
    3c9a:	b0a50513          	addi	a0,a0,-1270 # 77a0 <malloc+0x174c>
    3c9e:	00002097          	auipc	ra,0x2
    3ca2:	2fe080e7          	jalr	766(ra) # 5f9c <printf>
    exit(1);
    3ca6:	4505                	li	a0,1
    3ca8:	00002097          	auipc	ra,0x2
    3cac:	f84080e7          	jalr	-124(ra) # 5c2c <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3cb0:	85ca                	mv	a1,s2
    3cb2:	00004517          	auipc	a0,0x4
    3cb6:	b1e50513          	addi	a0,a0,-1250 # 77d0 <malloc+0x177c>
    3cba:	00002097          	auipc	ra,0x2
    3cbe:	2e2080e7          	jalr	738(ra) # 5f9c <printf>
    exit(1);
    3cc2:	4505                	li	a0,1
    3cc4:	00002097          	auipc	ra,0x2
    3cc8:	f68080e7          	jalr	-152(ra) # 5c2c <exit>
    printf("%s: create dd succeeded!\n", s);
    3ccc:	85ca                	mv	a1,s2
    3cce:	00004517          	auipc	a0,0x4
    3cd2:	b2250513          	addi	a0,a0,-1246 # 77f0 <malloc+0x179c>
    3cd6:	00002097          	auipc	ra,0x2
    3cda:	2c6080e7          	jalr	710(ra) # 5f9c <printf>
    exit(1);
    3cde:	4505                	li	a0,1
    3ce0:	00002097          	auipc	ra,0x2
    3ce4:	f4c080e7          	jalr	-180(ra) # 5c2c <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3ce8:	85ca                	mv	a1,s2
    3cea:	00004517          	auipc	a0,0x4
    3cee:	b2650513          	addi	a0,a0,-1242 # 7810 <malloc+0x17bc>
    3cf2:	00002097          	auipc	ra,0x2
    3cf6:	2aa080e7          	jalr	682(ra) # 5f9c <printf>
    exit(1);
    3cfa:	4505                	li	a0,1
    3cfc:	00002097          	auipc	ra,0x2
    3d00:	f30080e7          	jalr	-208(ra) # 5c2c <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3d04:	85ca                	mv	a1,s2
    3d06:	00004517          	auipc	a0,0x4
    3d0a:	b2a50513          	addi	a0,a0,-1238 # 7830 <malloc+0x17dc>
    3d0e:	00002097          	auipc	ra,0x2
    3d12:	28e080e7          	jalr	654(ra) # 5f9c <printf>
    exit(1);
    3d16:	4505                	li	a0,1
    3d18:	00002097          	auipc	ra,0x2
    3d1c:	f14080e7          	jalr	-236(ra) # 5c2c <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3d20:	85ca                	mv	a1,s2
    3d22:	00004517          	auipc	a0,0x4
    3d26:	b3e50513          	addi	a0,a0,-1218 # 7860 <malloc+0x180c>
    3d2a:	00002097          	auipc	ra,0x2
    3d2e:	272080e7          	jalr	626(ra) # 5f9c <printf>
    exit(1);
    3d32:	4505                	li	a0,1
    3d34:	00002097          	auipc	ra,0x2
    3d38:	ef8080e7          	jalr	-264(ra) # 5c2c <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3d3c:	85ca                	mv	a1,s2
    3d3e:	00004517          	auipc	a0,0x4
    3d42:	b4a50513          	addi	a0,a0,-1206 # 7888 <malloc+0x1834>
    3d46:	00002097          	auipc	ra,0x2
    3d4a:	256080e7          	jalr	598(ra) # 5f9c <printf>
    exit(1);
    3d4e:	4505                	li	a0,1
    3d50:	00002097          	auipc	ra,0x2
    3d54:	edc080e7          	jalr	-292(ra) # 5c2c <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3d58:	85ca                	mv	a1,s2
    3d5a:	00004517          	auipc	a0,0x4
    3d5e:	b5650513          	addi	a0,a0,-1194 # 78b0 <malloc+0x185c>
    3d62:	00002097          	auipc	ra,0x2
    3d66:	23a080e7          	jalr	570(ra) # 5f9c <printf>
    exit(1);
    3d6a:	4505                	li	a0,1
    3d6c:	00002097          	auipc	ra,0x2
    3d70:	ec0080e7          	jalr	-320(ra) # 5c2c <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3d74:	85ca                	mv	a1,s2
    3d76:	00004517          	auipc	a0,0x4
    3d7a:	b6250513          	addi	a0,a0,-1182 # 78d8 <malloc+0x1884>
    3d7e:	00002097          	auipc	ra,0x2
    3d82:	21e080e7          	jalr	542(ra) # 5f9c <printf>
    exit(1);
    3d86:	4505                	li	a0,1
    3d88:	00002097          	auipc	ra,0x2
    3d8c:	ea4080e7          	jalr	-348(ra) # 5c2c <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3d90:	85ca                	mv	a1,s2
    3d92:	00004517          	auipc	a0,0x4
    3d96:	b6650513          	addi	a0,a0,-1178 # 78f8 <malloc+0x18a4>
    3d9a:	00002097          	auipc	ra,0x2
    3d9e:	202080e7          	jalr	514(ra) # 5f9c <printf>
    exit(1);
    3da2:	4505                	li	a0,1
    3da4:	00002097          	auipc	ra,0x2
    3da8:	e88080e7          	jalr	-376(ra) # 5c2c <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3dac:	85ca                	mv	a1,s2
    3dae:	00004517          	auipc	a0,0x4
    3db2:	b6a50513          	addi	a0,a0,-1174 # 7918 <malloc+0x18c4>
    3db6:	00002097          	auipc	ra,0x2
    3dba:	1e6080e7          	jalr	486(ra) # 5f9c <printf>
    exit(1);
    3dbe:	4505                	li	a0,1
    3dc0:	00002097          	auipc	ra,0x2
    3dc4:	e6c080e7          	jalr	-404(ra) # 5c2c <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3dc8:	85ca                	mv	a1,s2
    3dca:	00004517          	auipc	a0,0x4
    3dce:	b7650513          	addi	a0,a0,-1162 # 7940 <malloc+0x18ec>
    3dd2:	00002097          	auipc	ra,0x2
    3dd6:	1ca080e7          	jalr	458(ra) # 5f9c <printf>
    exit(1);
    3dda:	4505                	li	a0,1
    3ddc:	00002097          	auipc	ra,0x2
    3de0:	e50080e7          	jalr	-432(ra) # 5c2c <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3de4:	85ca                	mv	a1,s2
    3de6:	00004517          	auipc	a0,0x4
    3dea:	b7a50513          	addi	a0,a0,-1158 # 7960 <malloc+0x190c>
    3dee:	00002097          	auipc	ra,0x2
    3df2:	1ae080e7          	jalr	430(ra) # 5f9c <printf>
    exit(1);
    3df6:	4505                	li	a0,1
    3df8:	00002097          	auipc	ra,0x2
    3dfc:	e34080e7          	jalr	-460(ra) # 5c2c <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3e00:	85ca                	mv	a1,s2
    3e02:	00004517          	auipc	a0,0x4
    3e06:	b7e50513          	addi	a0,a0,-1154 # 7980 <malloc+0x192c>
    3e0a:	00002097          	auipc	ra,0x2
    3e0e:	192080e7          	jalr	402(ra) # 5f9c <printf>
    exit(1);
    3e12:	4505                	li	a0,1
    3e14:	00002097          	auipc	ra,0x2
    3e18:	e18080e7          	jalr	-488(ra) # 5c2c <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3e1c:	85ca                	mv	a1,s2
    3e1e:	00004517          	auipc	a0,0x4
    3e22:	b8a50513          	addi	a0,a0,-1142 # 79a8 <malloc+0x1954>
    3e26:	00002097          	auipc	ra,0x2
    3e2a:	176080e7          	jalr	374(ra) # 5f9c <printf>
    exit(1);
    3e2e:	4505                	li	a0,1
    3e30:	00002097          	auipc	ra,0x2
    3e34:	dfc080e7          	jalr	-516(ra) # 5c2c <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3e38:	85ca                	mv	a1,s2
    3e3a:	00004517          	auipc	a0,0x4
    3e3e:	80650513          	addi	a0,a0,-2042 # 7640 <malloc+0x15ec>
    3e42:	00002097          	auipc	ra,0x2
    3e46:	15a080e7          	jalr	346(ra) # 5f9c <printf>
    exit(1);
    3e4a:	4505                	li	a0,1
    3e4c:	00002097          	auipc	ra,0x2
    3e50:	de0080e7          	jalr	-544(ra) # 5c2c <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3e54:	85ca                	mv	a1,s2
    3e56:	00004517          	auipc	a0,0x4
    3e5a:	b7250513          	addi	a0,a0,-1166 # 79c8 <malloc+0x1974>
    3e5e:	00002097          	auipc	ra,0x2
    3e62:	13e080e7          	jalr	318(ra) # 5f9c <printf>
    exit(1);
    3e66:	4505                	li	a0,1
    3e68:	00002097          	auipc	ra,0x2
    3e6c:	dc4080e7          	jalr	-572(ra) # 5c2c <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3e70:	85ca                	mv	a1,s2
    3e72:	00004517          	auipc	a0,0x4
    3e76:	b7650513          	addi	a0,a0,-1162 # 79e8 <malloc+0x1994>
    3e7a:	00002097          	auipc	ra,0x2
    3e7e:	122080e7          	jalr	290(ra) # 5f9c <printf>
    exit(1);
    3e82:	4505                	li	a0,1
    3e84:	00002097          	auipc	ra,0x2
    3e88:	da8080e7          	jalr	-600(ra) # 5c2c <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3e8c:	85ca                	mv	a1,s2
    3e8e:	00004517          	auipc	a0,0x4
    3e92:	b8a50513          	addi	a0,a0,-1142 # 7a18 <malloc+0x19c4>
    3e96:	00002097          	auipc	ra,0x2
    3e9a:	106080e7          	jalr	262(ra) # 5f9c <printf>
    exit(1);
    3e9e:	4505                	li	a0,1
    3ea0:	00002097          	auipc	ra,0x2
    3ea4:	d8c080e7          	jalr	-628(ra) # 5c2c <exit>
    printf("%s: unlink dd failed\n", s);
    3ea8:	85ca                	mv	a1,s2
    3eaa:	00004517          	auipc	a0,0x4
    3eae:	b8e50513          	addi	a0,a0,-1138 # 7a38 <malloc+0x19e4>
    3eb2:	00002097          	auipc	ra,0x2
    3eb6:	0ea080e7          	jalr	234(ra) # 5f9c <printf>
    exit(1);
    3eba:	4505                	li	a0,1
    3ebc:	00002097          	auipc	ra,0x2
    3ec0:	d70080e7          	jalr	-656(ra) # 5c2c <exit>

0000000000003ec4 <rmdot>:
{
    3ec4:	1101                	addi	sp,sp,-32
    3ec6:	ec06                	sd	ra,24(sp)
    3ec8:	e822                	sd	s0,16(sp)
    3eca:	e426                	sd	s1,8(sp)
    3ecc:	1000                	addi	s0,sp,32
    3ece:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3ed0:	00004517          	auipc	a0,0x4
    3ed4:	b8050513          	addi	a0,a0,-1152 # 7a50 <malloc+0x19fc>
    3ed8:	00002097          	auipc	ra,0x2
    3edc:	dbc080e7          	jalr	-580(ra) # 5c94 <mkdir>
    3ee0:	e549                	bnez	a0,3f6a <rmdot+0xa6>
  if(chdir("dots") != 0){
    3ee2:	00004517          	auipc	a0,0x4
    3ee6:	b6e50513          	addi	a0,a0,-1170 # 7a50 <malloc+0x19fc>
    3eea:	00002097          	auipc	ra,0x2
    3eee:	db2080e7          	jalr	-590(ra) # 5c9c <chdir>
    3ef2:	e951                	bnez	a0,3f86 <rmdot+0xc2>
  if(unlink(".") == 0){
    3ef4:	00003517          	auipc	a0,0x3
    3ef8:	98c50513          	addi	a0,a0,-1652 # 6880 <malloc+0x82c>
    3efc:	00002097          	auipc	ra,0x2
    3f00:	d80080e7          	jalr	-640(ra) # 5c7c <unlink>
    3f04:	cd59                	beqz	a0,3fa2 <rmdot+0xde>
  if(unlink("..") == 0){
    3f06:	00003517          	auipc	a0,0x3
    3f0a:	5a250513          	addi	a0,a0,1442 # 74a8 <malloc+0x1454>
    3f0e:	00002097          	auipc	ra,0x2
    3f12:	d6e080e7          	jalr	-658(ra) # 5c7c <unlink>
    3f16:	c545                	beqz	a0,3fbe <rmdot+0xfa>
  if(chdir("/") != 0){
    3f18:	00003517          	auipc	a0,0x3
    3f1c:	53850513          	addi	a0,a0,1336 # 7450 <malloc+0x13fc>
    3f20:	00002097          	auipc	ra,0x2
    3f24:	d7c080e7          	jalr	-644(ra) # 5c9c <chdir>
    3f28:	e94d                	bnez	a0,3fda <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3f2a:	00004517          	auipc	a0,0x4
    3f2e:	b8e50513          	addi	a0,a0,-1138 # 7ab8 <malloc+0x1a64>
    3f32:	00002097          	auipc	ra,0x2
    3f36:	d4a080e7          	jalr	-694(ra) # 5c7c <unlink>
    3f3a:	cd55                	beqz	a0,3ff6 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3f3c:	00004517          	auipc	a0,0x4
    3f40:	ba450513          	addi	a0,a0,-1116 # 7ae0 <malloc+0x1a8c>
    3f44:	00002097          	auipc	ra,0x2
    3f48:	d38080e7          	jalr	-712(ra) # 5c7c <unlink>
    3f4c:	c179                	beqz	a0,4012 <rmdot+0x14e>
  if(unlink("dots") != 0){
    3f4e:	00004517          	auipc	a0,0x4
    3f52:	b0250513          	addi	a0,a0,-1278 # 7a50 <malloc+0x19fc>
    3f56:	00002097          	auipc	ra,0x2
    3f5a:	d26080e7          	jalr	-730(ra) # 5c7c <unlink>
    3f5e:	e961                	bnez	a0,402e <rmdot+0x16a>
}
    3f60:	60e2                	ld	ra,24(sp)
    3f62:	6442                	ld	s0,16(sp)
    3f64:	64a2                	ld	s1,8(sp)
    3f66:	6105                	addi	sp,sp,32
    3f68:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3f6a:	85a6                	mv	a1,s1
    3f6c:	00004517          	auipc	a0,0x4
    3f70:	aec50513          	addi	a0,a0,-1300 # 7a58 <malloc+0x1a04>
    3f74:	00002097          	auipc	ra,0x2
    3f78:	028080e7          	jalr	40(ra) # 5f9c <printf>
    exit(1);
    3f7c:	4505                	li	a0,1
    3f7e:	00002097          	auipc	ra,0x2
    3f82:	cae080e7          	jalr	-850(ra) # 5c2c <exit>
    printf("%s: chdir dots failed\n", s);
    3f86:	85a6                	mv	a1,s1
    3f88:	00004517          	auipc	a0,0x4
    3f8c:	ae850513          	addi	a0,a0,-1304 # 7a70 <malloc+0x1a1c>
    3f90:	00002097          	auipc	ra,0x2
    3f94:	00c080e7          	jalr	12(ra) # 5f9c <printf>
    exit(1);
    3f98:	4505                	li	a0,1
    3f9a:	00002097          	auipc	ra,0x2
    3f9e:	c92080e7          	jalr	-878(ra) # 5c2c <exit>
    printf("%s: rm . worked!\n", s);
    3fa2:	85a6                	mv	a1,s1
    3fa4:	00004517          	auipc	a0,0x4
    3fa8:	ae450513          	addi	a0,a0,-1308 # 7a88 <malloc+0x1a34>
    3fac:	00002097          	auipc	ra,0x2
    3fb0:	ff0080e7          	jalr	-16(ra) # 5f9c <printf>
    exit(1);
    3fb4:	4505                	li	a0,1
    3fb6:	00002097          	auipc	ra,0x2
    3fba:	c76080e7          	jalr	-906(ra) # 5c2c <exit>
    printf("%s: rm .. worked!\n", s);
    3fbe:	85a6                	mv	a1,s1
    3fc0:	00004517          	auipc	a0,0x4
    3fc4:	ae050513          	addi	a0,a0,-1312 # 7aa0 <malloc+0x1a4c>
    3fc8:	00002097          	auipc	ra,0x2
    3fcc:	fd4080e7          	jalr	-44(ra) # 5f9c <printf>
    exit(1);
    3fd0:	4505                	li	a0,1
    3fd2:	00002097          	auipc	ra,0x2
    3fd6:	c5a080e7          	jalr	-934(ra) # 5c2c <exit>
    printf("%s: chdir / failed\n", s);
    3fda:	85a6                	mv	a1,s1
    3fdc:	00003517          	auipc	a0,0x3
    3fe0:	47c50513          	addi	a0,a0,1148 # 7458 <malloc+0x1404>
    3fe4:	00002097          	auipc	ra,0x2
    3fe8:	fb8080e7          	jalr	-72(ra) # 5f9c <printf>
    exit(1);
    3fec:	4505                	li	a0,1
    3fee:	00002097          	auipc	ra,0x2
    3ff2:	c3e080e7          	jalr	-962(ra) # 5c2c <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3ff6:	85a6                	mv	a1,s1
    3ff8:	00004517          	auipc	a0,0x4
    3ffc:	ac850513          	addi	a0,a0,-1336 # 7ac0 <malloc+0x1a6c>
    4000:	00002097          	auipc	ra,0x2
    4004:	f9c080e7          	jalr	-100(ra) # 5f9c <printf>
    exit(1);
    4008:	4505                	li	a0,1
    400a:	00002097          	auipc	ra,0x2
    400e:	c22080e7          	jalr	-990(ra) # 5c2c <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    4012:	85a6                	mv	a1,s1
    4014:	00004517          	auipc	a0,0x4
    4018:	ad450513          	addi	a0,a0,-1324 # 7ae8 <malloc+0x1a94>
    401c:	00002097          	auipc	ra,0x2
    4020:	f80080e7          	jalr	-128(ra) # 5f9c <printf>
    exit(1);
    4024:	4505                	li	a0,1
    4026:	00002097          	auipc	ra,0x2
    402a:	c06080e7          	jalr	-1018(ra) # 5c2c <exit>
    printf("%s: unlink dots failed!\n", s);
    402e:	85a6                	mv	a1,s1
    4030:	00004517          	auipc	a0,0x4
    4034:	ad850513          	addi	a0,a0,-1320 # 7b08 <malloc+0x1ab4>
    4038:	00002097          	auipc	ra,0x2
    403c:	f64080e7          	jalr	-156(ra) # 5f9c <printf>
    exit(1);
    4040:	4505                	li	a0,1
    4042:	00002097          	auipc	ra,0x2
    4046:	bea080e7          	jalr	-1046(ra) # 5c2c <exit>

000000000000404a <dirfile>:
{
    404a:	1101                	addi	sp,sp,-32
    404c:	ec06                	sd	ra,24(sp)
    404e:	e822                	sd	s0,16(sp)
    4050:	e426                	sd	s1,8(sp)
    4052:	e04a                	sd	s2,0(sp)
    4054:	1000                	addi	s0,sp,32
    4056:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    4058:	20000593          	li	a1,512
    405c:	00004517          	auipc	a0,0x4
    4060:	acc50513          	addi	a0,a0,-1332 # 7b28 <malloc+0x1ad4>
    4064:	00002097          	auipc	ra,0x2
    4068:	c08080e7          	jalr	-1016(ra) # 5c6c <open>
  if(fd < 0){
    406c:	0e054d63          	bltz	a0,4166 <dirfile+0x11c>
  close(fd);
    4070:	00002097          	auipc	ra,0x2
    4074:	be4080e7          	jalr	-1052(ra) # 5c54 <close>
  if(chdir("dirfile") == 0){
    4078:	00004517          	auipc	a0,0x4
    407c:	ab050513          	addi	a0,a0,-1360 # 7b28 <malloc+0x1ad4>
    4080:	00002097          	auipc	ra,0x2
    4084:	c1c080e7          	jalr	-996(ra) # 5c9c <chdir>
    4088:	cd6d                	beqz	a0,4182 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    408a:	4581                	li	a1,0
    408c:	00004517          	auipc	a0,0x4
    4090:	ae450513          	addi	a0,a0,-1308 # 7b70 <malloc+0x1b1c>
    4094:	00002097          	auipc	ra,0x2
    4098:	bd8080e7          	jalr	-1064(ra) # 5c6c <open>
  if(fd >= 0){
    409c:	10055163          	bgez	a0,419e <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    40a0:	20000593          	li	a1,512
    40a4:	00004517          	auipc	a0,0x4
    40a8:	acc50513          	addi	a0,a0,-1332 # 7b70 <malloc+0x1b1c>
    40ac:	00002097          	auipc	ra,0x2
    40b0:	bc0080e7          	jalr	-1088(ra) # 5c6c <open>
  if(fd >= 0){
    40b4:	10055363          	bgez	a0,41ba <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    40b8:	00004517          	auipc	a0,0x4
    40bc:	ab850513          	addi	a0,a0,-1352 # 7b70 <malloc+0x1b1c>
    40c0:	00002097          	auipc	ra,0x2
    40c4:	bd4080e7          	jalr	-1068(ra) # 5c94 <mkdir>
    40c8:	10050763          	beqz	a0,41d6 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    40cc:	00004517          	auipc	a0,0x4
    40d0:	aa450513          	addi	a0,a0,-1372 # 7b70 <malloc+0x1b1c>
    40d4:	00002097          	auipc	ra,0x2
    40d8:	ba8080e7          	jalr	-1112(ra) # 5c7c <unlink>
    40dc:	10050b63          	beqz	a0,41f2 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    40e0:	00004597          	auipc	a1,0x4
    40e4:	a9058593          	addi	a1,a1,-1392 # 7b70 <malloc+0x1b1c>
    40e8:	00002517          	auipc	a0,0x2
    40ec:	28850513          	addi	a0,a0,648 # 6370 <malloc+0x31c>
    40f0:	00002097          	auipc	ra,0x2
    40f4:	b9c080e7          	jalr	-1124(ra) # 5c8c <link>
    40f8:	10050b63          	beqz	a0,420e <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    40fc:	00004517          	auipc	a0,0x4
    4100:	a2c50513          	addi	a0,a0,-1492 # 7b28 <malloc+0x1ad4>
    4104:	00002097          	auipc	ra,0x2
    4108:	b78080e7          	jalr	-1160(ra) # 5c7c <unlink>
    410c:	10051f63          	bnez	a0,422a <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    4110:	4589                	li	a1,2
    4112:	00002517          	auipc	a0,0x2
    4116:	76e50513          	addi	a0,a0,1902 # 6880 <malloc+0x82c>
    411a:	00002097          	auipc	ra,0x2
    411e:	b52080e7          	jalr	-1198(ra) # 5c6c <open>
  if(fd >= 0){
    4122:	12055263          	bgez	a0,4246 <dirfile+0x1fc>
  fd = open(".", 0);
    4126:	4581                	li	a1,0
    4128:	00002517          	auipc	a0,0x2
    412c:	75850513          	addi	a0,a0,1880 # 6880 <malloc+0x82c>
    4130:	00002097          	auipc	ra,0x2
    4134:	b3c080e7          	jalr	-1220(ra) # 5c6c <open>
    4138:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    413a:	4605                	li	a2,1
    413c:	00002597          	auipc	a1,0x2
    4140:	0cc58593          	addi	a1,a1,204 # 6208 <malloc+0x1b4>
    4144:	00002097          	auipc	ra,0x2
    4148:	b08080e7          	jalr	-1272(ra) # 5c4c <write>
    414c:	10a04b63          	bgtz	a0,4262 <dirfile+0x218>
  close(fd);
    4150:	8526                	mv	a0,s1
    4152:	00002097          	auipc	ra,0x2
    4156:	b02080e7          	jalr	-1278(ra) # 5c54 <close>
}
    415a:	60e2                	ld	ra,24(sp)
    415c:	6442                	ld	s0,16(sp)
    415e:	64a2                	ld	s1,8(sp)
    4160:	6902                	ld	s2,0(sp)
    4162:	6105                	addi	sp,sp,32
    4164:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    4166:	85ca                	mv	a1,s2
    4168:	00004517          	auipc	a0,0x4
    416c:	9c850513          	addi	a0,a0,-1592 # 7b30 <malloc+0x1adc>
    4170:	00002097          	auipc	ra,0x2
    4174:	e2c080e7          	jalr	-468(ra) # 5f9c <printf>
    exit(1);
    4178:	4505                	li	a0,1
    417a:	00002097          	auipc	ra,0x2
    417e:	ab2080e7          	jalr	-1358(ra) # 5c2c <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    4182:	85ca                	mv	a1,s2
    4184:	00004517          	auipc	a0,0x4
    4188:	9cc50513          	addi	a0,a0,-1588 # 7b50 <malloc+0x1afc>
    418c:	00002097          	auipc	ra,0x2
    4190:	e10080e7          	jalr	-496(ra) # 5f9c <printf>
    exit(1);
    4194:	4505                	li	a0,1
    4196:	00002097          	auipc	ra,0x2
    419a:	a96080e7          	jalr	-1386(ra) # 5c2c <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    419e:	85ca                	mv	a1,s2
    41a0:	00004517          	auipc	a0,0x4
    41a4:	9e050513          	addi	a0,a0,-1568 # 7b80 <malloc+0x1b2c>
    41a8:	00002097          	auipc	ra,0x2
    41ac:	df4080e7          	jalr	-524(ra) # 5f9c <printf>
    exit(1);
    41b0:	4505                	li	a0,1
    41b2:	00002097          	auipc	ra,0x2
    41b6:	a7a080e7          	jalr	-1414(ra) # 5c2c <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    41ba:	85ca                	mv	a1,s2
    41bc:	00004517          	auipc	a0,0x4
    41c0:	9c450513          	addi	a0,a0,-1596 # 7b80 <malloc+0x1b2c>
    41c4:	00002097          	auipc	ra,0x2
    41c8:	dd8080e7          	jalr	-552(ra) # 5f9c <printf>
    exit(1);
    41cc:	4505                	li	a0,1
    41ce:	00002097          	auipc	ra,0x2
    41d2:	a5e080e7          	jalr	-1442(ra) # 5c2c <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    41d6:	85ca                	mv	a1,s2
    41d8:	00004517          	auipc	a0,0x4
    41dc:	9d050513          	addi	a0,a0,-1584 # 7ba8 <malloc+0x1b54>
    41e0:	00002097          	auipc	ra,0x2
    41e4:	dbc080e7          	jalr	-580(ra) # 5f9c <printf>
    exit(1);
    41e8:	4505                	li	a0,1
    41ea:	00002097          	auipc	ra,0x2
    41ee:	a42080e7          	jalr	-1470(ra) # 5c2c <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    41f2:	85ca                	mv	a1,s2
    41f4:	00004517          	auipc	a0,0x4
    41f8:	9dc50513          	addi	a0,a0,-1572 # 7bd0 <malloc+0x1b7c>
    41fc:	00002097          	auipc	ra,0x2
    4200:	da0080e7          	jalr	-608(ra) # 5f9c <printf>
    exit(1);
    4204:	4505                	li	a0,1
    4206:	00002097          	auipc	ra,0x2
    420a:	a26080e7          	jalr	-1498(ra) # 5c2c <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    420e:	85ca                	mv	a1,s2
    4210:	00004517          	auipc	a0,0x4
    4214:	9e850513          	addi	a0,a0,-1560 # 7bf8 <malloc+0x1ba4>
    4218:	00002097          	auipc	ra,0x2
    421c:	d84080e7          	jalr	-636(ra) # 5f9c <printf>
    exit(1);
    4220:	4505                	li	a0,1
    4222:	00002097          	auipc	ra,0x2
    4226:	a0a080e7          	jalr	-1526(ra) # 5c2c <exit>
    printf("%s: unlink dirfile failed!\n", s);
    422a:	85ca                	mv	a1,s2
    422c:	00004517          	auipc	a0,0x4
    4230:	9f450513          	addi	a0,a0,-1548 # 7c20 <malloc+0x1bcc>
    4234:	00002097          	auipc	ra,0x2
    4238:	d68080e7          	jalr	-664(ra) # 5f9c <printf>
    exit(1);
    423c:	4505                	li	a0,1
    423e:	00002097          	auipc	ra,0x2
    4242:	9ee080e7          	jalr	-1554(ra) # 5c2c <exit>
    printf("%s: open . for writing succeeded!\n", s);
    4246:	85ca                	mv	a1,s2
    4248:	00004517          	auipc	a0,0x4
    424c:	9f850513          	addi	a0,a0,-1544 # 7c40 <malloc+0x1bec>
    4250:	00002097          	auipc	ra,0x2
    4254:	d4c080e7          	jalr	-692(ra) # 5f9c <printf>
    exit(1);
    4258:	4505                	li	a0,1
    425a:	00002097          	auipc	ra,0x2
    425e:	9d2080e7          	jalr	-1582(ra) # 5c2c <exit>
    printf("%s: write . succeeded!\n", s);
    4262:	85ca                	mv	a1,s2
    4264:	00004517          	auipc	a0,0x4
    4268:	a0450513          	addi	a0,a0,-1532 # 7c68 <malloc+0x1c14>
    426c:	00002097          	auipc	ra,0x2
    4270:	d30080e7          	jalr	-720(ra) # 5f9c <printf>
    exit(1);
    4274:	4505                	li	a0,1
    4276:	00002097          	auipc	ra,0x2
    427a:	9b6080e7          	jalr	-1610(ra) # 5c2c <exit>

000000000000427e <iref>:
{
    427e:	7139                	addi	sp,sp,-64
    4280:	fc06                	sd	ra,56(sp)
    4282:	f822                	sd	s0,48(sp)
    4284:	f426                	sd	s1,40(sp)
    4286:	f04a                	sd	s2,32(sp)
    4288:	ec4e                	sd	s3,24(sp)
    428a:	e852                	sd	s4,16(sp)
    428c:	e456                	sd	s5,8(sp)
    428e:	e05a                	sd	s6,0(sp)
    4290:	0080                	addi	s0,sp,64
    4292:	8b2a                	mv	s6,a0
    4294:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    4298:	00004a17          	auipc	s4,0x4
    429c:	9e8a0a13          	addi	s4,s4,-1560 # 7c80 <malloc+0x1c2c>
    mkdir("");
    42a0:	00003497          	auipc	s1,0x3
    42a4:	4e848493          	addi	s1,s1,1256 # 7788 <malloc+0x1734>
    link("README", "");
    42a8:	00002a97          	auipc	s5,0x2
    42ac:	0c8a8a93          	addi	s5,s5,200 # 6370 <malloc+0x31c>
    fd = open("xx", O_CREATE);
    42b0:	00004997          	auipc	s3,0x4
    42b4:	8c898993          	addi	s3,s3,-1848 # 7b78 <malloc+0x1b24>
    42b8:	a891                	j	430c <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    42ba:	85da                	mv	a1,s6
    42bc:	00004517          	auipc	a0,0x4
    42c0:	9cc50513          	addi	a0,a0,-1588 # 7c88 <malloc+0x1c34>
    42c4:	00002097          	auipc	ra,0x2
    42c8:	cd8080e7          	jalr	-808(ra) # 5f9c <printf>
      exit(1);
    42cc:	4505                	li	a0,1
    42ce:	00002097          	auipc	ra,0x2
    42d2:	95e080e7          	jalr	-1698(ra) # 5c2c <exit>
      printf("%s: chdir irefd failed\n", s);
    42d6:	85da                	mv	a1,s6
    42d8:	00004517          	auipc	a0,0x4
    42dc:	9c850513          	addi	a0,a0,-1592 # 7ca0 <malloc+0x1c4c>
    42e0:	00002097          	auipc	ra,0x2
    42e4:	cbc080e7          	jalr	-836(ra) # 5f9c <printf>
      exit(1);
    42e8:	4505                	li	a0,1
    42ea:	00002097          	auipc	ra,0x2
    42ee:	942080e7          	jalr	-1726(ra) # 5c2c <exit>
      close(fd);
    42f2:	00002097          	auipc	ra,0x2
    42f6:	962080e7          	jalr	-1694(ra) # 5c54 <close>
    42fa:	a889                	j	434c <iref+0xce>
    unlink("xx");
    42fc:	854e                	mv	a0,s3
    42fe:	00002097          	auipc	ra,0x2
    4302:	97e080e7          	jalr	-1666(ra) # 5c7c <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4306:	397d                	addiw	s2,s2,-1
    4308:	06090063          	beqz	s2,4368 <iref+0xea>
    if(mkdir("irefd") != 0){
    430c:	8552                	mv	a0,s4
    430e:	00002097          	auipc	ra,0x2
    4312:	986080e7          	jalr	-1658(ra) # 5c94 <mkdir>
    4316:	f155                	bnez	a0,42ba <iref+0x3c>
    if(chdir("irefd") != 0){
    4318:	8552                	mv	a0,s4
    431a:	00002097          	auipc	ra,0x2
    431e:	982080e7          	jalr	-1662(ra) # 5c9c <chdir>
    4322:	f955                	bnez	a0,42d6 <iref+0x58>
    mkdir("");
    4324:	8526                	mv	a0,s1
    4326:	00002097          	auipc	ra,0x2
    432a:	96e080e7          	jalr	-1682(ra) # 5c94 <mkdir>
    link("README", "");
    432e:	85a6                	mv	a1,s1
    4330:	8556                	mv	a0,s5
    4332:	00002097          	auipc	ra,0x2
    4336:	95a080e7          	jalr	-1702(ra) # 5c8c <link>
    fd = open("", O_CREATE);
    433a:	20000593          	li	a1,512
    433e:	8526                	mv	a0,s1
    4340:	00002097          	auipc	ra,0x2
    4344:	92c080e7          	jalr	-1748(ra) # 5c6c <open>
    if(fd >= 0)
    4348:	fa0555e3          	bgez	a0,42f2 <iref+0x74>
    fd = open("xx", O_CREATE);
    434c:	20000593          	li	a1,512
    4350:	854e                	mv	a0,s3
    4352:	00002097          	auipc	ra,0x2
    4356:	91a080e7          	jalr	-1766(ra) # 5c6c <open>
    if(fd >= 0)
    435a:	fa0541e3          	bltz	a0,42fc <iref+0x7e>
      close(fd);
    435e:	00002097          	auipc	ra,0x2
    4362:	8f6080e7          	jalr	-1802(ra) # 5c54 <close>
    4366:	bf59                	j	42fc <iref+0x7e>
    4368:	03300493          	li	s1,51
    chdir("..");
    436c:	00003997          	auipc	s3,0x3
    4370:	13c98993          	addi	s3,s3,316 # 74a8 <malloc+0x1454>
    unlink("irefd");
    4374:	00004917          	auipc	s2,0x4
    4378:	90c90913          	addi	s2,s2,-1780 # 7c80 <malloc+0x1c2c>
    chdir("..");
    437c:	854e                	mv	a0,s3
    437e:	00002097          	auipc	ra,0x2
    4382:	91e080e7          	jalr	-1762(ra) # 5c9c <chdir>
    unlink("irefd");
    4386:	854a                	mv	a0,s2
    4388:	00002097          	auipc	ra,0x2
    438c:	8f4080e7          	jalr	-1804(ra) # 5c7c <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4390:	34fd                	addiw	s1,s1,-1
    4392:	f4ed                	bnez	s1,437c <iref+0xfe>
  chdir("/");
    4394:	00003517          	auipc	a0,0x3
    4398:	0bc50513          	addi	a0,a0,188 # 7450 <malloc+0x13fc>
    439c:	00002097          	auipc	ra,0x2
    43a0:	900080e7          	jalr	-1792(ra) # 5c9c <chdir>
}
    43a4:	70e2                	ld	ra,56(sp)
    43a6:	7442                	ld	s0,48(sp)
    43a8:	74a2                	ld	s1,40(sp)
    43aa:	7902                	ld	s2,32(sp)
    43ac:	69e2                	ld	s3,24(sp)
    43ae:	6a42                	ld	s4,16(sp)
    43b0:	6aa2                	ld	s5,8(sp)
    43b2:	6b02                	ld	s6,0(sp)
    43b4:	6121                	addi	sp,sp,64
    43b6:	8082                	ret

00000000000043b8 <openiputtest>:
{
    43b8:	7179                	addi	sp,sp,-48
    43ba:	f406                	sd	ra,40(sp)
    43bc:	f022                	sd	s0,32(sp)
    43be:	ec26                	sd	s1,24(sp)
    43c0:	1800                	addi	s0,sp,48
    43c2:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    43c4:	00004517          	auipc	a0,0x4
    43c8:	8f450513          	addi	a0,a0,-1804 # 7cb8 <malloc+0x1c64>
    43cc:	00002097          	auipc	ra,0x2
    43d0:	8c8080e7          	jalr	-1848(ra) # 5c94 <mkdir>
    43d4:	04054263          	bltz	a0,4418 <openiputtest+0x60>
  pid = fork();
    43d8:	00002097          	auipc	ra,0x2
    43dc:	84c080e7          	jalr	-1972(ra) # 5c24 <fork>
  if(pid < 0){
    43e0:	04054a63          	bltz	a0,4434 <openiputtest+0x7c>
  if(pid == 0){
    43e4:	e93d                	bnez	a0,445a <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    43e6:	4589                	li	a1,2
    43e8:	00004517          	auipc	a0,0x4
    43ec:	8d050513          	addi	a0,a0,-1840 # 7cb8 <malloc+0x1c64>
    43f0:	00002097          	auipc	ra,0x2
    43f4:	87c080e7          	jalr	-1924(ra) # 5c6c <open>
    if(fd >= 0){
    43f8:	04054c63          	bltz	a0,4450 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    43fc:	85a6                	mv	a1,s1
    43fe:	00004517          	auipc	a0,0x4
    4402:	8da50513          	addi	a0,a0,-1830 # 7cd8 <malloc+0x1c84>
    4406:	00002097          	auipc	ra,0x2
    440a:	b96080e7          	jalr	-1130(ra) # 5f9c <printf>
      exit(1);
    440e:	4505                	li	a0,1
    4410:	00002097          	auipc	ra,0x2
    4414:	81c080e7          	jalr	-2020(ra) # 5c2c <exit>
    printf("%s: mkdir oidir failed\n", s);
    4418:	85a6                	mv	a1,s1
    441a:	00004517          	auipc	a0,0x4
    441e:	8a650513          	addi	a0,a0,-1882 # 7cc0 <malloc+0x1c6c>
    4422:	00002097          	auipc	ra,0x2
    4426:	b7a080e7          	jalr	-1158(ra) # 5f9c <printf>
    exit(1);
    442a:	4505                	li	a0,1
    442c:	00002097          	auipc	ra,0x2
    4430:	800080e7          	jalr	-2048(ra) # 5c2c <exit>
    printf("%s: fork failed\n", s);
    4434:	85a6                	mv	a1,s1
    4436:	00002517          	auipc	a0,0x2
    443a:	5ea50513          	addi	a0,a0,1514 # 6a20 <malloc+0x9cc>
    443e:	00002097          	auipc	ra,0x2
    4442:	b5e080e7          	jalr	-1186(ra) # 5f9c <printf>
    exit(1);
    4446:	4505                	li	a0,1
    4448:	00001097          	auipc	ra,0x1
    444c:	7e4080e7          	jalr	2020(ra) # 5c2c <exit>
    exit(0);
    4450:	4501                	li	a0,0
    4452:	00001097          	auipc	ra,0x1
    4456:	7da080e7          	jalr	2010(ra) # 5c2c <exit>
  sleep(1);
    445a:	4505                	li	a0,1
    445c:	00002097          	auipc	ra,0x2
    4460:	860080e7          	jalr	-1952(ra) # 5cbc <sleep>
  if(unlink("oidir") != 0){
    4464:	00004517          	auipc	a0,0x4
    4468:	85450513          	addi	a0,a0,-1964 # 7cb8 <malloc+0x1c64>
    446c:	00002097          	auipc	ra,0x2
    4470:	810080e7          	jalr	-2032(ra) # 5c7c <unlink>
    4474:	cd19                	beqz	a0,4492 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    4476:	85a6                	mv	a1,s1
    4478:	00002517          	auipc	a0,0x2
    447c:	79850513          	addi	a0,a0,1944 # 6c10 <malloc+0xbbc>
    4480:	00002097          	auipc	ra,0x2
    4484:	b1c080e7          	jalr	-1252(ra) # 5f9c <printf>
    exit(1);
    4488:	4505                	li	a0,1
    448a:	00001097          	auipc	ra,0x1
    448e:	7a2080e7          	jalr	1954(ra) # 5c2c <exit>
  wait(&xstatus);
    4492:	fdc40513          	addi	a0,s0,-36
    4496:	00001097          	auipc	ra,0x1
    449a:	79e080e7          	jalr	1950(ra) # 5c34 <wait>
  exit(xstatus);
    449e:	fdc42503          	lw	a0,-36(s0)
    44a2:	00001097          	auipc	ra,0x1
    44a6:	78a080e7          	jalr	1930(ra) # 5c2c <exit>

00000000000044aa <forkforkfork>:
{
    44aa:	1101                	addi	sp,sp,-32
    44ac:	ec06                	sd	ra,24(sp)
    44ae:	e822                	sd	s0,16(sp)
    44b0:	e426                	sd	s1,8(sp)
    44b2:	1000                	addi	s0,sp,32
    44b4:	84aa                	mv	s1,a0
  unlink("stopforking");
    44b6:	00004517          	auipc	a0,0x4
    44ba:	84a50513          	addi	a0,a0,-1974 # 7d00 <malloc+0x1cac>
    44be:	00001097          	auipc	ra,0x1
    44c2:	7be080e7          	jalr	1982(ra) # 5c7c <unlink>
  int pid = fork();
    44c6:	00001097          	auipc	ra,0x1
    44ca:	75e080e7          	jalr	1886(ra) # 5c24 <fork>
  if(pid < 0){
    44ce:	04054563          	bltz	a0,4518 <forkforkfork+0x6e>
  if(pid == 0){
    44d2:	c12d                	beqz	a0,4534 <forkforkfork+0x8a>
  sleep(20); // two seconds
    44d4:	4551                	li	a0,20
    44d6:	00001097          	auipc	ra,0x1
    44da:	7e6080e7          	jalr	2022(ra) # 5cbc <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    44de:	20200593          	li	a1,514
    44e2:	00004517          	auipc	a0,0x4
    44e6:	81e50513          	addi	a0,a0,-2018 # 7d00 <malloc+0x1cac>
    44ea:	00001097          	auipc	ra,0x1
    44ee:	782080e7          	jalr	1922(ra) # 5c6c <open>
    44f2:	00001097          	auipc	ra,0x1
    44f6:	762080e7          	jalr	1890(ra) # 5c54 <close>
  wait(0);
    44fa:	4501                	li	a0,0
    44fc:	00001097          	auipc	ra,0x1
    4500:	738080e7          	jalr	1848(ra) # 5c34 <wait>
  sleep(10); // one second
    4504:	4529                	li	a0,10
    4506:	00001097          	auipc	ra,0x1
    450a:	7b6080e7          	jalr	1974(ra) # 5cbc <sleep>
}
    450e:	60e2                	ld	ra,24(sp)
    4510:	6442                	ld	s0,16(sp)
    4512:	64a2                	ld	s1,8(sp)
    4514:	6105                	addi	sp,sp,32
    4516:	8082                	ret
    printf("%s: fork failed", s);
    4518:	85a6                	mv	a1,s1
    451a:	00002517          	auipc	a0,0x2
    451e:	6c650513          	addi	a0,a0,1734 # 6be0 <malloc+0xb8c>
    4522:	00002097          	auipc	ra,0x2
    4526:	a7a080e7          	jalr	-1414(ra) # 5f9c <printf>
    exit(1);
    452a:	4505                	li	a0,1
    452c:	00001097          	auipc	ra,0x1
    4530:	700080e7          	jalr	1792(ra) # 5c2c <exit>
      int fd = open("stopforking", 0);
    4534:	00003497          	auipc	s1,0x3
    4538:	7cc48493          	addi	s1,s1,1996 # 7d00 <malloc+0x1cac>
    453c:	4581                	li	a1,0
    453e:	8526                	mv	a0,s1
    4540:	00001097          	auipc	ra,0x1
    4544:	72c080e7          	jalr	1836(ra) # 5c6c <open>
      if(fd >= 0){
    4548:	02055763          	bgez	a0,4576 <forkforkfork+0xcc>
      if(fork() < 0){
    454c:	00001097          	auipc	ra,0x1
    4550:	6d8080e7          	jalr	1752(ra) # 5c24 <fork>
    4554:	fe0554e3          	bgez	a0,453c <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    4558:	20200593          	li	a1,514
    455c:	00003517          	auipc	a0,0x3
    4560:	7a450513          	addi	a0,a0,1956 # 7d00 <malloc+0x1cac>
    4564:	00001097          	auipc	ra,0x1
    4568:	708080e7          	jalr	1800(ra) # 5c6c <open>
    456c:	00001097          	auipc	ra,0x1
    4570:	6e8080e7          	jalr	1768(ra) # 5c54 <close>
    4574:	b7e1                	j	453c <forkforkfork+0x92>
        exit(0);
    4576:	4501                	li	a0,0
    4578:	00001097          	auipc	ra,0x1
    457c:	6b4080e7          	jalr	1716(ra) # 5c2c <exit>

0000000000004580 <killstatus>:
{
    4580:	7139                	addi	sp,sp,-64
    4582:	fc06                	sd	ra,56(sp)
    4584:	f822                	sd	s0,48(sp)
    4586:	f426                	sd	s1,40(sp)
    4588:	f04a                	sd	s2,32(sp)
    458a:	ec4e                	sd	s3,24(sp)
    458c:	e852                	sd	s4,16(sp)
    458e:	0080                	addi	s0,sp,64
    4590:	8a2a                	mv	s4,a0
    4592:	06400913          	li	s2,100
    if(xst != -1) {
    4596:	59fd                	li	s3,-1
    int pid1 = fork();
    4598:	00001097          	auipc	ra,0x1
    459c:	68c080e7          	jalr	1676(ra) # 5c24 <fork>
    45a0:	84aa                	mv	s1,a0
    if(pid1 < 0){
    45a2:	02054f63          	bltz	a0,45e0 <killstatus+0x60>
    if(pid1 == 0){
    45a6:	c939                	beqz	a0,45fc <killstatus+0x7c>
    sleep(1);
    45a8:	4505                	li	a0,1
    45aa:	00001097          	auipc	ra,0x1
    45ae:	712080e7          	jalr	1810(ra) # 5cbc <sleep>
    kill(pid1);
    45b2:	8526                	mv	a0,s1
    45b4:	00001097          	auipc	ra,0x1
    45b8:	6a8080e7          	jalr	1704(ra) # 5c5c <kill>
    wait(&xst);
    45bc:	fcc40513          	addi	a0,s0,-52
    45c0:	00001097          	auipc	ra,0x1
    45c4:	674080e7          	jalr	1652(ra) # 5c34 <wait>
    if(xst != -1) {
    45c8:	fcc42783          	lw	a5,-52(s0)
    45cc:	03379d63          	bne	a5,s3,4606 <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    45d0:	397d                	addiw	s2,s2,-1
    45d2:	fc0913e3          	bnez	s2,4598 <killstatus+0x18>
  exit(0);
    45d6:	4501                	li	a0,0
    45d8:	00001097          	auipc	ra,0x1
    45dc:	654080e7          	jalr	1620(ra) # 5c2c <exit>
      printf("%s: fork failed\n", s);
    45e0:	85d2                	mv	a1,s4
    45e2:	00002517          	auipc	a0,0x2
    45e6:	43e50513          	addi	a0,a0,1086 # 6a20 <malloc+0x9cc>
    45ea:	00002097          	auipc	ra,0x2
    45ee:	9b2080e7          	jalr	-1614(ra) # 5f9c <printf>
      exit(1);
    45f2:	4505                	li	a0,1
    45f4:	00001097          	auipc	ra,0x1
    45f8:	638080e7          	jalr	1592(ra) # 5c2c <exit>
        getpid();
    45fc:	00001097          	auipc	ra,0x1
    4600:	6b0080e7          	jalr	1712(ra) # 5cac <getpid>
      while(1) {
    4604:	bfe5                	j	45fc <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    4606:	85d2                	mv	a1,s4
    4608:	00003517          	auipc	a0,0x3
    460c:	70850513          	addi	a0,a0,1800 # 7d10 <malloc+0x1cbc>
    4610:	00002097          	auipc	ra,0x2
    4614:	98c080e7          	jalr	-1652(ra) # 5f9c <printf>
       exit(1);
    4618:	4505                	li	a0,1
    461a:	00001097          	auipc	ra,0x1
    461e:	612080e7          	jalr	1554(ra) # 5c2c <exit>

0000000000004622 <preempt>:
{
    4622:	7139                	addi	sp,sp,-64
    4624:	fc06                	sd	ra,56(sp)
    4626:	f822                	sd	s0,48(sp)
    4628:	f426                	sd	s1,40(sp)
    462a:	f04a                	sd	s2,32(sp)
    462c:	ec4e                	sd	s3,24(sp)
    462e:	e852                	sd	s4,16(sp)
    4630:	0080                	addi	s0,sp,64
    4632:	892a                	mv	s2,a0
  pid1 = fork();
    4634:	00001097          	auipc	ra,0x1
    4638:	5f0080e7          	jalr	1520(ra) # 5c24 <fork>
  if(pid1 < 0) {
    463c:	00054563          	bltz	a0,4646 <preempt+0x24>
    4640:	84aa                	mv	s1,a0
  if(pid1 == 0)
    4642:	e105                	bnez	a0,4662 <preempt+0x40>
    for(;;)
    4644:	a001                	j	4644 <preempt+0x22>
    printf("%s: fork failed", s);
    4646:	85ca                	mv	a1,s2
    4648:	00002517          	auipc	a0,0x2
    464c:	59850513          	addi	a0,a0,1432 # 6be0 <malloc+0xb8c>
    4650:	00002097          	auipc	ra,0x2
    4654:	94c080e7          	jalr	-1716(ra) # 5f9c <printf>
    exit(1);
    4658:	4505                	li	a0,1
    465a:	00001097          	auipc	ra,0x1
    465e:	5d2080e7          	jalr	1490(ra) # 5c2c <exit>
  pid2 = fork();
    4662:	00001097          	auipc	ra,0x1
    4666:	5c2080e7          	jalr	1474(ra) # 5c24 <fork>
    466a:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    466c:	00054463          	bltz	a0,4674 <preempt+0x52>
  if(pid2 == 0)
    4670:	e105                	bnez	a0,4690 <preempt+0x6e>
    for(;;)
    4672:	a001                	j	4672 <preempt+0x50>
    printf("%s: fork failed\n", s);
    4674:	85ca                	mv	a1,s2
    4676:	00002517          	auipc	a0,0x2
    467a:	3aa50513          	addi	a0,a0,938 # 6a20 <malloc+0x9cc>
    467e:	00002097          	auipc	ra,0x2
    4682:	91e080e7          	jalr	-1762(ra) # 5f9c <printf>
    exit(1);
    4686:	4505                	li	a0,1
    4688:	00001097          	auipc	ra,0x1
    468c:	5a4080e7          	jalr	1444(ra) # 5c2c <exit>
  pipe(pfds);
    4690:	fc840513          	addi	a0,s0,-56
    4694:	00001097          	auipc	ra,0x1
    4698:	5a8080e7          	jalr	1448(ra) # 5c3c <pipe>
  pid3 = fork();
    469c:	00001097          	auipc	ra,0x1
    46a0:	588080e7          	jalr	1416(ra) # 5c24 <fork>
    46a4:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    46a6:	02054e63          	bltz	a0,46e2 <preempt+0xc0>
  if(pid3 == 0){
    46aa:	e525                	bnez	a0,4712 <preempt+0xf0>
    close(pfds[0]);
    46ac:	fc842503          	lw	a0,-56(s0)
    46b0:	00001097          	auipc	ra,0x1
    46b4:	5a4080e7          	jalr	1444(ra) # 5c54 <close>
    if(write(pfds[1], "x", 1) != 1)
    46b8:	4605                	li	a2,1
    46ba:	00002597          	auipc	a1,0x2
    46be:	b4e58593          	addi	a1,a1,-1202 # 6208 <malloc+0x1b4>
    46c2:	fcc42503          	lw	a0,-52(s0)
    46c6:	00001097          	auipc	ra,0x1
    46ca:	586080e7          	jalr	1414(ra) # 5c4c <write>
    46ce:	4785                	li	a5,1
    46d0:	02f51763          	bne	a0,a5,46fe <preempt+0xdc>
    close(pfds[1]);
    46d4:	fcc42503          	lw	a0,-52(s0)
    46d8:	00001097          	auipc	ra,0x1
    46dc:	57c080e7          	jalr	1404(ra) # 5c54 <close>
    for(;;)
    46e0:	a001                	j	46e0 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    46e2:	85ca                	mv	a1,s2
    46e4:	00002517          	auipc	a0,0x2
    46e8:	33c50513          	addi	a0,a0,828 # 6a20 <malloc+0x9cc>
    46ec:	00002097          	auipc	ra,0x2
    46f0:	8b0080e7          	jalr	-1872(ra) # 5f9c <printf>
     exit(1);
    46f4:	4505                	li	a0,1
    46f6:	00001097          	auipc	ra,0x1
    46fa:	536080e7          	jalr	1334(ra) # 5c2c <exit>
      printf("%s: preempt write error", s);
    46fe:	85ca                	mv	a1,s2
    4700:	00003517          	auipc	a0,0x3
    4704:	63050513          	addi	a0,a0,1584 # 7d30 <malloc+0x1cdc>
    4708:	00002097          	auipc	ra,0x2
    470c:	894080e7          	jalr	-1900(ra) # 5f9c <printf>
    4710:	b7d1                	j	46d4 <preempt+0xb2>
  close(pfds[1]);
    4712:	fcc42503          	lw	a0,-52(s0)
    4716:	00001097          	auipc	ra,0x1
    471a:	53e080e7          	jalr	1342(ra) # 5c54 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    471e:	660d                	lui	a2,0x3
    4720:	0000a597          	auipc	a1,0xa
    4724:	8f858593          	addi	a1,a1,-1800 # e018 <buf>
    4728:	fc842503          	lw	a0,-56(s0)
    472c:	00001097          	auipc	ra,0x1
    4730:	518080e7          	jalr	1304(ra) # 5c44 <read>
    4734:	4785                	li	a5,1
    4736:	02f50363          	beq	a0,a5,475c <preempt+0x13a>
    printf("%s: preempt read error", s);
    473a:	85ca                	mv	a1,s2
    473c:	00003517          	auipc	a0,0x3
    4740:	60c50513          	addi	a0,a0,1548 # 7d48 <malloc+0x1cf4>
    4744:	00002097          	auipc	ra,0x2
    4748:	858080e7          	jalr	-1960(ra) # 5f9c <printf>
}
    474c:	70e2                	ld	ra,56(sp)
    474e:	7442                	ld	s0,48(sp)
    4750:	74a2                	ld	s1,40(sp)
    4752:	7902                	ld	s2,32(sp)
    4754:	69e2                	ld	s3,24(sp)
    4756:	6a42                	ld	s4,16(sp)
    4758:	6121                	addi	sp,sp,64
    475a:	8082                	ret
  close(pfds[0]);
    475c:	fc842503          	lw	a0,-56(s0)
    4760:	00001097          	auipc	ra,0x1
    4764:	4f4080e7          	jalr	1268(ra) # 5c54 <close>
  printf("kill... ");
    4768:	00003517          	auipc	a0,0x3
    476c:	5f850513          	addi	a0,a0,1528 # 7d60 <malloc+0x1d0c>
    4770:	00002097          	auipc	ra,0x2
    4774:	82c080e7          	jalr	-2004(ra) # 5f9c <printf>
  kill(pid1);
    4778:	8526                	mv	a0,s1
    477a:	00001097          	auipc	ra,0x1
    477e:	4e2080e7          	jalr	1250(ra) # 5c5c <kill>
  kill(pid2);
    4782:	854e                	mv	a0,s3
    4784:	00001097          	auipc	ra,0x1
    4788:	4d8080e7          	jalr	1240(ra) # 5c5c <kill>
  kill(pid3);
    478c:	8552                	mv	a0,s4
    478e:	00001097          	auipc	ra,0x1
    4792:	4ce080e7          	jalr	1230(ra) # 5c5c <kill>
  printf("wait... ");
    4796:	00003517          	auipc	a0,0x3
    479a:	5da50513          	addi	a0,a0,1498 # 7d70 <malloc+0x1d1c>
    479e:	00001097          	auipc	ra,0x1
    47a2:	7fe080e7          	jalr	2046(ra) # 5f9c <printf>
  wait(0);
    47a6:	4501                	li	a0,0
    47a8:	00001097          	auipc	ra,0x1
    47ac:	48c080e7          	jalr	1164(ra) # 5c34 <wait>
  wait(0);
    47b0:	4501                	li	a0,0
    47b2:	00001097          	auipc	ra,0x1
    47b6:	482080e7          	jalr	1154(ra) # 5c34 <wait>
  wait(0);
    47ba:	4501                	li	a0,0
    47bc:	00001097          	auipc	ra,0x1
    47c0:	478080e7          	jalr	1144(ra) # 5c34 <wait>
    47c4:	b761                	j	474c <preempt+0x12a>

00000000000047c6 <reparent>:
{
    47c6:	7179                	addi	sp,sp,-48
    47c8:	f406                	sd	ra,40(sp)
    47ca:	f022                	sd	s0,32(sp)
    47cc:	ec26                	sd	s1,24(sp)
    47ce:	e84a                	sd	s2,16(sp)
    47d0:	e44e                	sd	s3,8(sp)
    47d2:	e052                	sd	s4,0(sp)
    47d4:	1800                	addi	s0,sp,48
    47d6:	89aa                	mv	s3,a0
  int master_pid = getpid();
    47d8:	00001097          	auipc	ra,0x1
    47dc:	4d4080e7          	jalr	1236(ra) # 5cac <getpid>
    47e0:	8a2a                	mv	s4,a0
    47e2:	0c800913          	li	s2,200
    int pid = fork();
    47e6:	00001097          	auipc	ra,0x1
    47ea:	43e080e7          	jalr	1086(ra) # 5c24 <fork>
    47ee:	84aa                	mv	s1,a0
    if(pid < 0){
    47f0:	02054263          	bltz	a0,4814 <reparent+0x4e>
    if(pid){
    47f4:	cd21                	beqz	a0,484c <reparent+0x86>
      if(wait(0) != pid){
    47f6:	4501                	li	a0,0
    47f8:	00001097          	auipc	ra,0x1
    47fc:	43c080e7          	jalr	1084(ra) # 5c34 <wait>
    4800:	02951863          	bne	a0,s1,4830 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    4804:	397d                	addiw	s2,s2,-1
    4806:	fe0910e3          	bnez	s2,47e6 <reparent+0x20>
  exit(0);
    480a:	4501                	li	a0,0
    480c:	00001097          	auipc	ra,0x1
    4810:	420080e7          	jalr	1056(ra) # 5c2c <exit>
      printf("%s: fork failed\n", s);
    4814:	85ce                	mv	a1,s3
    4816:	00002517          	auipc	a0,0x2
    481a:	20a50513          	addi	a0,a0,522 # 6a20 <malloc+0x9cc>
    481e:	00001097          	auipc	ra,0x1
    4822:	77e080e7          	jalr	1918(ra) # 5f9c <printf>
      exit(1);
    4826:	4505                	li	a0,1
    4828:	00001097          	auipc	ra,0x1
    482c:	404080e7          	jalr	1028(ra) # 5c2c <exit>
        printf("%s: wait wrong pid\n", s);
    4830:	85ce                	mv	a1,s3
    4832:	00002517          	auipc	a0,0x2
    4836:	37650513          	addi	a0,a0,886 # 6ba8 <malloc+0xb54>
    483a:	00001097          	auipc	ra,0x1
    483e:	762080e7          	jalr	1890(ra) # 5f9c <printf>
        exit(1);
    4842:	4505                	li	a0,1
    4844:	00001097          	auipc	ra,0x1
    4848:	3e8080e7          	jalr	1000(ra) # 5c2c <exit>
      int pid2 = fork();
    484c:	00001097          	auipc	ra,0x1
    4850:	3d8080e7          	jalr	984(ra) # 5c24 <fork>
      if(pid2 < 0){
    4854:	00054763          	bltz	a0,4862 <reparent+0x9c>
      exit(0);
    4858:	4501                	li	a0,0
    485a:	00001097          	auipc	ra,0x1
    485e:	3d2080e7          	jalr	978(ra) # 5c2c <exit>
        kill(master_pid);
    4862:	8552                	mv	a0,s4
    4864:	00001097          	auipc	ra,0x1
    4868:	3f8080e7          	jalr	1016(ra) # 5c5c <kill>
        exit(1);
    486c:	4505                	li	a0,1
    486e:	00001097          	auipc	ra,0x1
    4872:	3be080e7          	jalr	958(ra) # 5c2c <exit>

0000000000004876 <sbrkfail>:
{
    4876:	7119                	addi	sp,sp,-128
    4878:	fc86                	sd	ra,120(sp)
    487a:	f8a2                	sd	s0,112(sp)
    487c:	f4a6                	sd	s1,104(sp)
    487e:	f0ca                	sd	s2,96(sp)
    4880:	ecce                	sd	s3,88(sp)
    4882:	e8d2                	sd	s4,80(sp)
    4884:	e4d6                	sd	s5,72(sp)
    4886:	0100                	addi	s0,sp,128
    4888:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    488a:	fb040513          	addi	a0,s0,-80
    488e:	00001097          	auipc	ra,0x1
    4892:	3ae080e7          	jalr	942(ra) # 5c3c <pipe>
    4896:	e901                	bnez	a0,48a6 <sbrkfail+0x30>
    4898:	f8040493          	addi	s1,s0,-128
    489c:	fa840993          	addi	s3,s0,-88
    48a0:	8926                	mv	s2,s1
    if(pids[i] != -1)
    48a2:	5a7d                	li	s4,-1
    48a4:	a085                	j	4904 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    48a6:	85d6                	mv	a1,s5
    48a8:	00002517          	auipc	a0,0x2
    48ac:	28050513          	addi	a0,a0,640 # 6b28 <malloc+0xad4>
    48b0:	00001097          	auipc	ra,0x1
    48b4:	6ec080e7          	jalr	1772(ra) # 5f9c <printf>
    exit(1);
    48b8:	4505                	li	a0,1
    48ba:	00001097          	auipc	ra,0x1
    48be:	372080e7          	jalr	882(ra) # 5c2c <exit>
      sbrk(BIG - (uint64)sbrk(0));
    48c2:	00001097          	auipc	ra,0x1
    48c6:	3f2080e7          	jalr	1010(ra) # 5cb4 <sbrk>
    48ca:	064007b7          	lui	a5,0x6400
    48ce:	40a7853b          	subw	a0,a5,a0
    48d2:	00001097          	auipc	ra,0x1
    48d6:	3e2080e7          	jalr	994(ra) # 5cb4 <sbrk>
      write(fds[1], "x", 1);
    48da:	4605                	li	a2,1
    48dc:	00002597          	auipc	a1,0x2
    48e0:	92c58593          	addi	a1,a1,-1748 # 6208 <malloc+0x1b4>
    48e4:	fb442503          	lw	a0,-76(s0)
    48e8:	00001097          	auipc	ra,0x1
    48ec:	364080e7          	jalr	868(ra) # 5c4c <write>
      for(;;) sleep(1000);
    48f0:	3e800513          	li	a0,1000
    48f4:	00001097          	auipc	ra,0x1
    48f8:	3c8080e7          	jalr	968(ra) # 5cbc <sleep>
    48fc:	bfd5                	j	48f0 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    48fe:	0911                	addi	s2,s2,4
    4900:	03390563          	beq	s2,s3,492a <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    4904:	00001097          	auipc	ra,0x1
    4908:	320080e7          	jalr	800(ra) # 5c24 <fork>
    490c:	00a92023          	sw	a0,0(s2)
    4910:	d94d                	beqz	a0,48c2 <sbrkfail+0x4c>
    if(pids[i] != -1)
    4912:	ff4506e3          	beq	a0,s4,48fe <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4916:	4605                	li	a2,1
    4918:	faf40593          	addi	a1,s0,-81
    491c:	fb042503          	lw	a0,-80(s0)
    4920:	00001097          	auipc	ra,0x1
    4924:	324080e7          	jalr	804(ra) # 5c44 <read>
    4928:	bfd9                	j	48fe <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    492a:	6505                	lui	a0,0x1
    492c:	00001097          	auipc	ra,0x1
    4930:	388080e7          	jalr	904(ra) # 5cb4 <sbrk>
    4934:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    4936:	597d                	li	s2,-1
    4938:	a021                	j	4940 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    493a:	0491                	addi	s1,s1,4
    493c:	01348f63          	beq	s1,s3,495a <sbrkfail+0xe4>
    if(pids[i] == -1)
    4940:	4088                	lw	a0,0(s1)
    4942:	ff250ce3          	beq	a0,s2,493a <sbrkfail+0xc4>
    kill(pids[i]);
    4946:	00001097          	auipc	ra,0x1
    494a:	316080e7          	jalr	790(ra) # 5c5c <kill>
    wait(0);
    494e:	4501                	li	a0,0
    4950:	00001097          	auipc	ra,0x1
    4954:	2e4080e7          	jalr	740(ra) # 5c34 <wait>
    4958:	b7cd                	j	493a <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    495a:	57fd                	li	a5,-1
    495c:	04fa0163          	beq	s4,a5,499e <sbrkfail+0x128>
  pid = fork();
    4960:	00001097          	auipc	ra,0x1
    4964:	2c4080e7          	jalr	708(ra) # 5c24 <fork>
    4968:	84aa                	mv	s1,a0
  if(pid < 0){
    496a:	04054863          	bltz	a0,49ba <sbrkfail+0x144>
  if(pid == 0){
    496e:	c525                	beqz	a0,49d6 <sbrkfail+0x160>
  wait(&xstatus);
    4970:	fbc40513          	addi	a0,s0,-68
    4974:	00001097          	auipc	ra,0x1
    4978:	2c0080e7          	jalr	704(ra) # 5c34 <wait>
  if(xstatus != -1 && xstatus != 2)
    497c:	fbc42783          	lw	a5,-68(s0)
    4980:	577d                	li	a4,-1
    4982:	00e78563          	beq	a5,a4,498c <sbrkfail+0x116>
    4986:	4709                	li	a4,2
    4988:	08e79d63          	bne	a5,a4,4a22 <sbrkfail+0x1ac>
}
    498c:	70e6                	ld	ra,120(sp)
    498e:	7446                	ld	s0,112(sp)
    4990:	74a6                	ld	s1,104(sp)
    4992:	7906                	ld	s2,96(sp)
    4994:	69e6                	ld	s3,88(sp)
    4996:	6a46                	ld	s4,80(sp)
    4998:	6aa6                	ld	s5,72(sp)
    499a:	6109                	addi	sp,sp,128
    499c:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    499e:	85d6                	mv	a1,s5
    49a0:	00003517          	auipc	a0,0x3
    49a4:	3e050513          	addi	a0,a0,992 # 7d80 <malloc+0x1d2c>
    49a8:	00001097          	auipc	ra,0x1
    49ac:	5f4080e7          	jalr	1524(ra) # 5f9c <printf>
    exit(1);
    49b0:	4505                	li	a0,1
    49b2:	00001097          	auipc	ra,0x1
    49b6:	27a080e7          	jalr	634(ra) # 5c2c <exit>
    printf("%s: fork failed\n", s);
    49ba:	85d6                	mv	a1,s5
    49bc:	00002517          	auipc	a0,0x2
    49c0:	06450513          	addi	a0,a0,100 # 6a20 <malloc+0x9cc>
    49c4:	00001097          	auipc	ra,0x1
    49c8:	5d8080e7          	jalr	1496(ra) # 5f9c <printf>
    exit(1);
    49cc:	4505                	li	a0,1
    49ce:	00001097          	auipc	ra,0x1
    49d2:	25e080e7          	jalr	606(ra) # 5c2c <exit>
    a = sbrk(0);
    49d6:	4501                	li	a0,0
    49d8:	00001097          	auipc	ra,0x1
    49dc:	2dc080e7          	jalr	732(ra) # 5cb4 <sbrk>
    49e0:	892a                	mv	s2,a0
    sbrk(10*BIG);
    49e2:	3e800537          	lui	a0,0x3e800
    49e6:	00001097          	auipc	ra,0x1
    49ea:	2ce080e7          	jalr	718(ra) # 5cb4 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    49ee:	87ca                	mv	a5,s2
    49f0:	3e800737          	lui	a4,0x3e800
    49f4:	993a                	add	s2,s2,a4
    49f6:	6705                	lui	a4,0x1
      n += *(a+i);
    49f8:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63eefe8>
    49fc:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    49fe:	97ba                	add	a5,a5,a4
    4a00:	fef91ce3          	bne	s2,a5,49f8 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4a04:	8626                	mv	a2,s1
    4a06:	85d6                	mv	a1,s5
    4a08:	00003517          	auipc	a0,0x3
    4a0c:	39850513          	addi	a0,a0,920 # 7da0 <malloc+0x1d4c>
    4a10:	00001097          	auipc	ra,0x1
    4a14:	58c080e7          	jalr	1420(ra) # 5f9c <printf>
    exit(1);
    4a18:	4505                	li	a0,1
    4a1a:	00001097          	auipc	ra,0x1
    4a1e:	212080e7          	jalr	530(ra) # 5c2c <exit>
    exit(1);
    4a22:	4505                	li	a0,1
    4a24:	00001097          	auipc	ra,0x1
    4a28:	208080e7          	jalr	520(ra) # 5c2c <exit>

0000000000004a2c <mem>:
{
    4a2c:	7139                	addi	sp,sp,-64
    4a2e:	fc06                	sd	ra,56(sp)
    4a30:	f822                	sd	s0,48(sp)
    4a32:	f426                	sd	s1,40(sp)
    4a34:	f04a                	sd	s2,32(sp)
    4a36:	ec4e                	sd	s3,24(sp)
    4a38:	0080                	addi	s0,sp,64
    4a3a:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    4a3c:	00001097          	auipc	ra,0x1
    4a40:	1e8080e7          	jalr	488(ra) # 5c24 <fork>
    m1 = 0;
    4a44:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    4a46:	6909                	lui	s2,0x2
    4a48:	71190913          	addi	s2,s2,1809 # 2711 <copyinstr3+0xcf>
  if((pid = fork()) == 0){
    4a4c:	c115                	beqz	a0,4a70 <mem+0x44>
    wait(&xstatus);
    4a4e:	fcc40513          	addi	a0,s0,-52
    4a52:	00001097          	auipc	ra,0x1
    4a56:	1e2080e7          	jalr	482(ra) # 5c34 <wait>
    if(xstatus == -1){
    4a5a:	fcc42503          	lw	a0,-52(s0)
    4a5e:	57fd                	li	a5,-1
    4a60:	06f50363          	beq	a0,a5,4ac6 <mem+0x9a>
    exit(xstatus);
    4a64:	00001097          	auipc	ra,0x1
    4a68:	1c8080e7          	jalr	456(ra) # 5c2c <exit>
      *(char**)m2 = m1;
    4a6c:	e104                	sd	s1,0(a0)
      m1 = m2;
    4a6e:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4a70:	854a                	mv	a0,s2
    4a72:	00001097          	auipc	ra,0x1
    4a76:	5e2080e7          	jalr	1506(ra) # 6054 <malloc>
    4a7a:	f96d                	bnez	a0,4a6c <mem+0x40>
    while(m1){
    4a7c:	c881                	beqz	s1,4a8c <mem+0x60>
      m2 = *(char**)m1;
    4a7e:	8526                	mv	a0,s1
    4a80:	6084                	ld	s1,0(s1)
      free(m1);
    4a82:	00001097          	auipc	ra,0x1
    4a86:	550080e7          	jalr	1360(ra) # 5fd2 <free>
    while(m1){
    4a8a:	f8f5                	bnez	s1,4a7e <mem+0x52>
    m1 = malloc(1024*20);
    4a8c:	6515                	lui	a0,0x5
    4a8e:	00001097          	auipc	ra,0x1
    4a92:	5c6080e7          	jalr	1478(ra) # 6054 <malloc>
    if(m1 == 0){
    4a96:	c911                	beqz	a0,4aaa <mem+0x7e>
    free(m1);
    4a98:	00001097          	auipc	ra,0x1
    4a9c:	53a080e7          	jalr	1338(ra) # 5fd2 <free>
    exit(0);
    4aa0:	4501                	li	a0,0
    4aa2:	00001097          	auipc	ra,0x1
    4aa6:	18a080e7          	jalr	394(ra) # 5c2c <exit>
      printf("couldn't allocate mem?!!\n", s);
    4aaa:	85ce                	mv	a1,s3
    4aac:	00003517          	auipc	a0,0x3
    4ab0:	32450513          	addi	a0,a0,804 # 7dd0 <malloc+0x1d7c>
    4ab4:	00001097          	auipc	ra,0x1
    4ab8:	4e8080e7          	jalr	1256(ra) # 5f9c <printf>
      exit(1);
    4abc:	4505                	li	a0,1
    4abe:	00001097          	auipc	ra,0x1
    4ac2:	16e080e7          	jalr	366(ra) # 5c2c <exit>
      exit(0);
    4ac6:	4501                	li	a0,0
    4ac8:	00001097          	auipc	ra,0x1
    4acc:	164080e7          	jalr	356(ra) # 5c2c <exit>

0000000000004ad0 <sharedfd>:
{
    4ad0:	7159                	addi	sp,sp,-112
    4ad2:	f486                	sd	ra,104(sp)
    4ad4:	f0a2                	sd	s0,96(sp)
    4ad6:	e0d2                	sd	s4,64(sp)
    4ad8:	1880                	addi	s0,sp,112
    4ada:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4adc:	00003517          	auipc	a0,0x3
    4ae0:	31450513          	addi	a0,a0,788 # 7df0 <malloc+0x1d9c>
    4ae4:	00001097          	auipc	ra,0x1
    4ae8:	198080e7          	jalr	408(ra) # 5c7c <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4aec:	20200593          	li	a1,514
    4af0:	00003517          	auipc	a0,0x3
    4af4:	30050513          	addi	a0,a0,768 # 7df0 <malloc+0x1d9c>
    4af8:	00001097          	auipc	ra,0x1
    4afc:	174080e7          	jalr	372(ra) # 5c6c <open>
  if(fd < 0){
    4b00:	06054063          	bltz	a0,4b60 <sharedfd+0x90>
    4b04:	eca6                	sd	s1,88(sp)
    4b06:	e8ca                	sd	s2,80(sp)
    4b08:	e4ce                	sd	s3,72(sp)
    4b0a:	fc56                	sd	s5,56(sp)
    4b0c:	f85a                	sd	s6,48(sp)
    4b0e:	f45e                	sd	s7,40(sp)
    4b10:	892a                	mv	s2,a0
  pid = fork();
    4b12:	00001097          	auipc	ra,0x1
    4b16:	112080e7          	jalr	274(ra) # 5c24 <fork>
    4b1a:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4b1c:	07000593          	li	a1,112
    4b20:	e119                	bnez	a0,4b26 <sharedfd+0x56>
    4b22:	06300593          	li	a1,99
    4b26:	4629                	li	a2,10
    4b28:	fa040513          	addi	a0,s0,-96
    4b2c:	00001097          	auipc	ra,0x1
    4b30:	f06080e7          	jalr	-250(ra) # 5a32 <memset>
    4b34:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4b38:	4629                	li	a2,10
    4b3a:	fa040593          	addi	a1,s0,-96
    4b3e:	854a                	mv	a0,s2
    4b40:	00001097          	auipc	ra,0x1
    4b44:	10c080e7          	jalr	268(ra) # 5c4c <write>
    4b48:	47a9                	li	a5,10
    4b4a:	02f51f63          	bne	a0,a5,4b88 <sharedfd+0xb8>
  for(i = 0; i < N; i++){
    4b4e:	34fd                	addiw	s1,s1,-1
    4b50:	f4e5                	bnez	s1,4b38 <sharedfd+0x68>
  if(pid == 0) {
    4b52:	04099963          	bnez	s3,4ba4 <sharedfd+0xd4>
    exit(0);
    4b56:	4501                	li	a0,0
    4b58:	00001097          	auipc	ra,0x1
    4b5c:	0d4080e7          	jalr	212(ra) # 5c2c <exit>
    4b60:	eca6                	sd	s1,88(sp)
    4b62:	e8ca                	sd	s2,80(sp)
    4b64:	e4ce                	sd	s3,72(sp)
    4b66:	fc56                	sd	s5,56(sp)
    4b68:	f85a                	sd	s6,48(sp)
    4b6a:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    4b6c:	85d2                	mv	a1,s4
    4b6e:	00003517          	auipc	a0,0x3
    4b72:	29250513          	addi	a0,a0,658 # 7e00 <malloc+0x1dac>
    4b76:	00001097          	auipc	ra,0x1
    4b7a:	426080e7          	jalr	1062(ra) # 5f9c <printf>
    exit(1);
    4b7e:	4505                	li	a0,1
    4b80:	00001097          	auipc	ra,0x1
    4b84:	0ac080e7          	jalr	172(ra) # 5c2c <exit>
      printf("%s: write sharedfd failed\n", s);
    4b88:	85d2                	mv	a1,s4
    4b8a:	00003517          	auipc	a0,0x3
    4b8e:	29e50513          	addi	a0,a0,670 # 7e28 <malloc+0x1dd4>
    4b92:	00001097          	auipc	ra,0x1
    4b96:	40a080e7          	jalr	1034(ra) # 5f9c <printf>
      exit(1);
    4b9a:	4505                	li	a0,1
    4b9c:	00001097          	auipc	ra,0x1
    4ba0:	090080e7          	jalr	144(ra) # 5c2c <exit>
    wait(&xstatus);
    4ba4:	f9c40513          	addi	a0,s0,-100
    4ba8:	00001097          	auipc	ra,0x1
    4bac:	08c080e7          	jalr	140(ra) # 5c34 <wait>
    if(xstatus != 0)
    4bb0:	f9c42983          	lw	s3,-100(s0)
    4bb4:	00098763          	beqz	s3,4bc2 <sharedfd+0xf2>
      exit(xstatus);
    4bb8:	854e                	mv	a0,s3
    4bba:	00001097          	auipc	ra,0x1
    4bbe:	072080e7          	jalr	114(ra) # 5c2c <exit>
  close(fd);
    4bc2:	854a                	mv	a0,s2
    4bc4:	00001097          	auipc	ra,0x1
    4bc8:	090080e7          	jalr	144(ra) # 5c54 <close>
  fd = open("sharedfd", 0);
    4bcc:	4581                	li	a1,0
    4bce:	00003517          	auipc	a0,0x3
    4bd2:	22250513          	addi	a0,a0,546 # 7df0 <malloc+0x1d9c>
    4bd6:	00001097          	auipc	ra,0x1
    4bda:	096080e7          	jalr	150(ra) # 5c6c <open>
    4bde:	8baa                	mv	s7,a0
  nc = np = 0;
    4be0:	8ace                	mv	s5,s3
  if(fd < 0){
    4be2:	02054563          	bltz	a0,4c0c <sharedfd+0x13c>
    4be6:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4bea:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4bee:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4bf2:	4629                	li	a2,10
    4bf4:	fa040593          	addi	a1,s0,-96
    4bf8:	855e                	mv	a0,s7
    4bfa:	00001097          	auipc	ra,0x1
    4bfe:	04a080e7          	jalr	74(ra) # 5c44 <read>
    4c02:	02a05f63          	blez	a0,4c40 <sharedfd+0x170>
    4c06:	fa040793          	addi	a5,s0,-96
    4c0a:	a01d                	j	4c30 <sharedfd+0x160>
    printf("%s: cannot open sharedfd for reading\n", s);
    4c0c:	85d2                	mv	a1,s4
    4c0e:	00003517          	auipc	a0,0x3
    4c12:	23a50513          	addi	a0,a0,570 # 7e48 <malloc+0x1df4>
    4c16:	00001097          	auipc	ra,0x1
    4c1a:	386080e7          	jalr	902(ra) # 5f9c <printf>
    exit(1);
    4c1e:	4505                	li	a0,1
    4c20:	00001097          	auipc	ra,0x1
    4c24:	00c080e7          	jalr	12(ra) # 5c2c <exit>
        nc++;
    4c28:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4c2a:	0785                	addi	a5,a5,1
    4c2c:	fd2783e3          	beq	a5,s2,4bf2 <sharedfd+0x122>
      if(buf[i] == 'c')
    4c30:	0007c703          	lbu	a4,0(a5)
    4c34:	fe970ae3          	beq	a4,s1,4c28 <sharedfd+0x158>
      if(buf[i] == 'p')
    4c38:	ff6719e3          	bne	a4,s6,4c2a <sharedfd+0x15a>
        np++;
    4c3c:	2a85                	addiw	s5,s5,1
    4c3e:	b7f5                	j	4c2a <sharedfd+0x15a>
  close(fd);
    4c40:	855e                	mv	a0,s7
    4c42:	00001097          	auipc	ra,0x1
    4c46:	012080e7          	jalr	18(ra) # 5c54 <close>
  unlink("sharedfd");
    4c4a:	00003517          	auipc	a0,0x3
    4c4e:	1a650513          	addi	a0,a0,422 # 7df0 <malloc+0x1d9c>
    4c52:	00001097          	auipc	ra,0x1
    4c56:	02a080e7          	jalr	42(ra) # 5c7c <unlink>
  if(nc == N*SZ && np == N*SZ){
    4c5a:	6789                	lui	a5,0x2
    4c5c:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0xce>
    4c60:	00f99763          	bne	s3,a5,4c6e <sharedfd+0x19e>
    4c64:	6789                	lui	a5,0x2
    4c66:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0xce>
    4c6a:	02fa8063          	beq	s5,a5,4c8a <sharedfd+0x1ba>
    printf("%s: nc/np test fails\n", s);
    4c6e:	85d2                	mv	a1,s4
    4c70:	00003517          	auipc	a0,0x3
    4c74:	20050513          	addi	a0,a0,512 # 7e70 <malloc+0x1e1c>
    4c78:	00001097          	auipc	ra,0x1
    4c7c:	324080e7          	jalr	804(ra) # 5f9c <printf>
    exit(1);
    4c80:	4505                	li	a0,1
    4c82:	00001097          	auipc	ra,0x1
    4c86:	faa080e7          	jalr	-86(ra) # 5c2c <exit>
    exit(0);
    4c8a:	4501                	li	a0,0
    4c8c:	00001097          	auipc	ra,0x1
    4c90:	fa0080e7          	jalr	-96(ra) # 5c2c <exit>

0000000000004c94 <fourfiles>:
{
    4c94:	7135                	addi	sp,sp,-160
    4c96:	ed06                	sd	ra,152(sp)
    4c98:	e922                	sd	s0,144(sp)
    4c9a:	e526                	sd	s1,136(sp)
    4c9c:	e14a                	sd	s2,128(sp)
    4c9e:	fcce                	sd	s3,120(sp)
    4ca0:	f8d2                	sd	s4,112(sp)
    4ca2:	f4d6                	sd	s5,104(sp)
    4ca4:	f0da                	sd	s6,96(sp)
    4ca6:	ecde                	sd	s7,88(sp)
    4ca8:	e8e2                	sd	s8,80(sp)
    4caa:	e4e6                	sd	s9,72(sp)
    4cac:	e0ea                	sd	s10,64(sp)
    4cae:	fc6e                	sd	s11,56(sp)
    4cb0:	1100                	addi	s0,sp,160
    4cb2:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4cb4:	00003797          	auipc	a5,0x3
    4cb8:	1d478793          	addi	a5,a5,468 # 7e88 <malloc+0x1e34>
    4cbc:	f6f43823          	sd	a5,-144(s0)
    4cc0:	00003797          	auipc	a5,0x3
    4cc4:	1d078793          	addi	a5,a5,464 # 7e90 <malloc+0x1e3c>
    4cc8:	f6f43c23          	sd	a5,-136(s0)
    4ccc:	00003797          	auipc	a5,0x3
    4cd0:	1cc78793          	addi	a5,a5,460 # 7e98 <malloc+0x1e44>
    4cd4:	f8f43023          	sd	a5,-128(s0)
    4cd8:	00003797          	auipc	a5,0x3
    4cdc:	1c878793          	addi	a5,a5,456 # 7ea0 <malloc+0x1e4c>
    4ce0:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4ce4:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4ce8:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4cea:	4481                	li	s1,0
    4cec:	4a11                	li	s4,4
    fname = names[pi];
    4cee:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4cf2:	854e                	mv	a0,s3
    4cf4:	00001097          	auipc	ra,0x1
    4cf8:	f88080e7          	jalr	-120(ra) # 5c7c <unlink>
    pid = fork();
    4cfc:	00001097          	auipc	ra,0x1
    4d00:	f28080e7          	jalr	-216(ra) # 5c24 <fork>
    if(pid < 0){
    4d04:	04054063          	bltz	a0,4d44 <fourfiles+0xb0>
    if(pid == 0){
    4d08:	cd21                	beqz	a0,4d60 <fourfiles+0xcc>
  for(pi = 0; pi < NCHILD; pi++){
    4d0a:	2485                	addiw	s1,s1,1
    4d0c:	0921                	addi	s2,s2,8
    4d0e:	ff4490e3          	bne	s1,s4,4cee <fourfiles+0x5a>
    4d12:	4491                	li	s1,4
    wait(&xstatus);
    4d14:	f6c40513          	addi	a0,s0,-148
    4d18:	00001097          	auipc	ra,0x1
    4d1c:	f1c080e7          	jalr	-228(ra) # 5c34 <wait>
    if(xstatus != 0)
    4d20:	f6c42a83          	lw	s5,-148(s0)
    4d24:	0c0a9863          	bnez	s5,4df4 <fourfiles+0x160>
  for(pi = 0; pi < NCHILD; pi++){
    4d28:	34fd                	addiw	s1,s1,-1
    4d2a:	f4ed                	bnez	s1,4d14 <fourfiles+0x80>
    4d2c:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4d30:	00009a17          	auipc	s4,0x9
    4d34:	2e8a0a13          	addi	s4,s4,744 # e018 <buf>
    if(total != N*SZ){
    4d38:	6d05                	lui	s10,0x1
    4d3a:	770d0d13          	addi	s10,s10,1904 # 1770 <exectest+0x1e>
  for(i = 0; i < NCHILD; i++){
    4d3e:	03400d93          	li	s11,52
    4d42:	a22d                	j	4e6c <fourfiles+0x1d8>
      printf("fork failed\n", s);
    4d44:	85e6                	mv	a1,s9
    4d46:	00002517          	auipc	a0,0x2
    4d4a:	0e250513          	addi	a0,a0,226 # 6e28 <malloc+0xdd4>
    4d4e:	00001097          	auipc	ra,0x1
    4d52:	24e080e7          	jalr	590(ra) # 5f9c <printf>
      exit(1);
    4d56:	4505                	li	a0,1
    4d58:	00001097          	auipc	ra,0x1
    4d5c:	ed4080e7          	jalr	-300(ra) # 5c2c <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4d60:	20200593          	li	a1,514
    4d64:	854e                	mv	a0,s3
    4d66:	00001097          	auipc	ra,0x1
    4d6a:	f06080e7          	jalr	-250(ra) # 5c6c <open>
    4d6e:	892a                	mv	s2,a0
      if(fd < 0){
    4d70:	04054763          	bltz	a0,4dbe <fourfiles+0x12a>
      memset(buf, '0'+pi, SZ);
    4d74:	1f400613          	li	a2,500
    4d78:	0304859b          	addiw	a1,s1,48
    4d7c:	00009517          	auipc	a0,0x9
    4d80:	29c50513          	addi	a0,a0,668 # e018 <buf>
    4d84:	00001097          	auipc	ra,0x1
    4d88:	cae080e7          	jalr	-850(ra) # 5a32 <memset>
    4d8c:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4d8e:	00009997          	auipc	s3,0x9
    4d92:	28a98993          	addi	s3,s3,650 # e018 <buf>
    4d96:	1f400613          	li	a2,500
    4d9a:	85ce                	mv	a1,s3
    4d9c:	854a                	mv	a0,s2
    4d9e:	00001097          	auipc	ra,0x1
    4da2:	eae080e7          	jalr	-338(ra) # 5c4c <write>
    4da6:	85aa                	mv	a1,a0
    4da8:	1f400793          	li	a5,500
    4dac:	02f51763          	bne	a0,a5,4dda <fourfiles+0x146>
      for(i = 0; i < N; i++){
    4db0:	34fd                	addiw	s1,s1,-1
    4db2:	f0f5                	bnez	s1,4d96 <fourfiles+0x102>
      exit(0);
    4db4:	4501                	li	a0,0
    4db6:	00001097          	auipc	ra,0x1
    4dba:	e76080e7          	jalr	-394(ra) # 5c2c <exit>
        printf("create failed\n", s);
    4dbe:	85e6                	mv	a1,s9
    4dc0:	00003517          	auipc	a0,0x3
    4dc4:	0e850513          	addi	a0,a0,232 # 7ea8 <malloc+0x1e54>
    4dc8:	00001097          	auipc	ra,0x1
    4dcc:	1d4080e7          	jalr	468(ra) # 5f9c <printf>
        exit(1);
    4dd0:	4505                	li	a0,1
    4dd2:	00001097          	auipc	ra,0x1
    4dd6:	e5a080e7          	jalr	-422(ra) # 5c2c <exit>
          printf("write failed %d\n", n);
    4dda:	00003517          	auipc	a0,0x3
    4dde:	0de50513          	addi	a0,a0,222 # 7eb8 <malloc+0x1e64>
    4de2:	00001097          	auipc	ra,0x1
    4de6:	1ba080e7          	jalr	442(ra) # 5f9c <printf>
          exit(1);
    4dea:	4505                	li	a0,1
    4dec:	00001097          	auipc	ra,0x1
    4df0:	e40080e7          	jalr	-448(ra) # 5c2c <exit>
      exit(xstatus);
    4df4:	8556                	mv	a0,s5
    4df6:	00001097          	auipc	ra,0x1
    4dfa:	e36080e7          	jalr	-458(ra) # 5c2c <exit>
          printf("wrong char\n", s);
    4dfe:	85e6                	mv	a1,s9
    4e00:	00003517          	auipc	a0,0x3
    4e04:	0d050513          	addi	a0,a0,208 # 7ed0 <malloc+0x1e7c>
    4e08:	00001097          	auipc	ra,0x1
    4e0c:	194080e7          	jalr	404(ra) # 5f9c <printf>
          exit(1);
    4e10:	4505                	li	a0,1
    4e12:	00001097          	auipc	ra,0x1
    4e16:	e1a080e7          	jalr	-486(ra) # 5c2c <exit>
      total += n;
    4e1a:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e1e:	660d                	lui	a2,0x3
    4e20:	85d2                	mv	a1,s4
    4e22:	854e                	mv	a0,s3
    4e24:	00001097          	auipc	ra,0x1
    4e28:	e20080e7          	jalr	-480(ra) # 5c44 <read>
    4e2c:	02a05063          	blez	a0,4e4c <fourfiles+0x1b8>
    4e30:	00009797          	auipc	a5,0x9
    4e34:	1e878793          	addi	a5,a5,488 # e018 <buf>
    4e38:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    4e3c:	0007c703          	lbu	a4,0(a5)
    4e40:	fa971fe3          	bne	a4,s1,4dfe <fourfiles+0x16a>
      for(j = 0; j < n; j++){
    4e44:	0785                	addi	a5,a5,1
    4e46:	fed79be3          	bne	a5,a3,4e3c <fourfiles+0x1a8>
    4e4a:	bfc1                	j	4e1a <fourfiles+0x186>
    close(fd);
    4e4c:	854e                	mv	a0,s3
    4e4e:	00001097          	auipc	ra,0x1
    4e52:	e06080e7          	jalr	-506(ra) # 5c54 <close>
    if(total != N*SZ){
    4e56:	03a91863          	bne	s2,s10,4e86 <fourfiles+0x1f2>
    unlink(fname);
    4e5a:	8562                	mv	a0,s8
    4e5c:	00001097          	auipc	ra,0x1
    4e60:	e20080e7          	jalr	-480(ra) # 5c7c <unlink>
  for(i = 0; i < NCHILD; i++){
    4e64:	0ba1                	addi	s7,s7,8
    4e66:	2b05                	addiw	s6,s6,1
    4e68:	03bb0d63          	beq	s6,s11,4ea2 <fourfiles+0x20e>
    fname = names[i];
    4e6c:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4e70:	4581                	li	a1,0
    4e72:	8562                	mv	a0,s8
    4e74:	00001097          	auipc	ra,0x1
    4e78:	df8080e7          	jalr	-520(ra) # 5c6c <open>
    4e7c:	89aa                	mv	s3,a0
    total = 0;
    4e7e:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    4e80:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e84:	bf69                	j	4e1e <fourfiles+0x18a>
      printf("wrong length %d\n", total);
    4e86:	85ca                	mv	a1,s2
    4e88:	00003517          	auipc	a0,0x3
    4e8c:	05850513          	addi	a0,a0,88 # 7ee0 <malloc+0x1e8c>
    4e90:	00001097          	auipc	ra,0x1
    4e94:	10c080e7          	jalr	268(ra) # 5f9c <printf>
      exit(1);
    4e98:	4505                	li	a0,1
    4e9a:	00001097          	auipc	ra,0x1
    4e9e:	d92080e7          	jalr	-622(ra) # 5c2c <exit>
}
    4ea2:	60ea                	ld	ra,152(sp)
    4ea4:	644a                	ld	s0,144(sp)
    4ea6:	64aa                	ld	s1,136(sp)
    4ea8:	690a                	ld	s2,128(sp)
    4eaa:	79e6                	ld	s3,120(sp)
    4eac:	7a46                	ld	s4,112(sp)
    4eae:	7aa6                	ld	s5,104(sp)
    4eb0:	7b06                	ld	s6,96(sp)
    4eb2:	6be6                	ld	s7,88(sp)
    4eb4:	6c46                	ld	s8,80(sp)
    4eb6:	6ca6                	ld	s9,72(sp)
    4eb8:	6d06                	ld	s10,64(sp)
    4eba:	7de2                	ld	s11,56(sp)
    4ebc:	610d                	addi	sp,sp,160
    4ebe:	8082                	ret

0000000000004ec0 <concreate>:
{
    4ec0:	7135                	addi	sp,sp,-160
    4ec2:	ed06                	sd	ra,152(sp)
    4ec4:	e922                	sd	s0,144(sp)
    4ec6:	e526                	sd	s1,136(sp)
    4ec8:	e14a                	sd	s2,128(sp)
    4eca:	fcce                	sd	s3,120(sp)
    4ecc:	f8d2                	sd	s4,112(sp)
    4ece:	f4d6                	sd	s5,104(sp)
    4ed0:	f0da                	sd	s6,96(sp)
    4ed2:	ecde                	sd	s7,88(sp)
    4ed4:	1100                	addi	s0,sp,160
    4ed6:	89aa                	mv	s3,a0
  file[0] = 'C';
    4ed8:	04300793          	li	a5,67
    4edc:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4ee0:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4ee4:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4ee6:	4b0d                	li	s6,3
    4ee8:	4a85                	li	s5,1
      link("C0", file);
    4eea:	00003b97          	auipc	s7,0x3
    4eee:	00eb8b93          	addi	s7,s7,14 # 7ef8 <malloc+0x1ea4>
  for(i = 0; i < N; i++){
    4ef2:	02800a13          	li	s4,40
    4ef6:	acc9                	j	51c8 <concreate+0x308>
      link("C0", file);
    4ef8:	fa840593          	addi	a1,s0,-88
    4efc:	855e                	mv	a0,s7
    4efe:	00001097          	auipc	ra,0x1
    4f02:	d8e080e7          	jalr	-626(ra) # 5c8c <link>
    if(pid == 0) {
    4f06:	a465                	j	51ae <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    4f08:	4795                	li	a5,5
    4f0a:	02f9693b          	remw	s2,s2,a5
    4f0e:	4785                	li	a5,1
    4f10:	02f90b63          	beq	s2,a5,4f46 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4f14:	20200593          	li	a1,514
    4f18:	fa840513          	addi	a0,s0,-88
    4f1c:	00001097          	auipc	ra,0x1
    4f20:	d50080e7          	jalr	-688(ra) # 5c6c <open>
      if(fd < 0){
    4f24:	26055c63          	bgez	a0,519c <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    4f28:	fa840593          	addi	a1,s0,-88
    4f2c:	00003517          	auipc	a0,0x3
    4f30:	fd450513          	addi	a0,a0,-44 # 7f00 <malloc+0x1eac>
    4f34:	00001097          	auipc	ra,0x1
    4f38:	068080e7          	jalr	104(ra) # 5f9c <printf>
        exit(1);
    4f3c:	4505                	li	a0,1
    4f3e:	00001097          	auipc	ra,0x1
    4f42:	cee080e7          	jalr	-786(ra) # 5c2c <exit>
      link("C0", file);
    4f46:	fa840593          	addi	a1,s0,-88
    4f4a:	00003517          	auipc	a0,0x3
    4f4e:	fae50513          	addi	a0,a0,-82 # 7ef8 <malloc+0x1ea4>
    4f52:	00001097          	auipc	ra,0x1
    4f56:	d3a080e7          	jalr	-710(ra) # 5c8c <link>
      exit(0);
    4f5a:	4501                	li	a0,0
    4f5c:	00001097          	auipc	ra,0x1
    4f60:	cd0080e7          	jalr	-816(ra) # 5c2c <exit>
        exit(1);
    4f64:	4505                	li	a0,1
    4f66:	00001097          	auipc	ra,0x1
    4f6a:	cc6080e7          	jalr	-826(ra) # 5c2c <exit>
  memset(fa, 0, sizeof(fa));
    4f6e:	02800613          	li	a2,40
    4f72:	4581                	li	a1,0
    4f74:	f8040513          	addi	a0,s0,-128
    4f78:	00001097          	auipc	ra,0x1
    4f7c:	aba080e7          	jalr	-1350(ra) # 5a32 <memset>
  fd = open(".", 0);
    4f80:	4581                	li	a1,0
    4f82:	00002517          	auipc	a0,0x2
    4f86:	8fe50513          	addi	a0,a0,-1794 # 6880 <malloc+0x82c>
    4f8a:	00001097          	auipc	ra,0x1
    4f8e:	ce2080e7          	jalr	-798(ra) # 5c6c <open>
    4f92:	892a                	mv	s2,a0
  n = 0;
    4f94:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f96:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4f9a:	02700b13          	li	s6,39
      fa[i] = 1;
    4f9e:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4fa0:	4641                	li	a2,16
    4fa2:	f7040593          	addi	a1,s0,-144
    4fa6:	854a                	mv	a0,s2
    4fa8:	00001097          	auipc	ra,0x1
    4fac:	c9c080e7          	jalr	-868(ra) # 5c44 <read>
    4fb0:	08a05263          	blez	a0,5034 <concreate+0x174>
    if(de.inum == 0)
    4fb4:	f7045783          	lhu	a5,-144(s0)
    4fb8:	d7e5                	beqz	a5,4fa0 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4fba:	f7244783          	lbu	a5,-142(s0)
    4fbe:	ff4791e3          	bne	a5,s4,4fa0 <concreate+0xe0>
    4fc2:	f7444783          	lbu	a5,-140(s0)
    4fc6:	ffe9                	bnez	a5,4fa0 <concreate+0xe0>
      i = de.name[1] - '0';
    4fc8:	f7344783          	lbu	a5,-141(s0)
    4fcc:	fd07879b          	addiw	a5,a5,-48
    4fd0:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4fd4:	02eb6063          	bltu	s6,a4,4ff4 <concreate+0x134>
      if(fa[i]){
    4fd8:	fb070793          	addi	a5,a4,-80 # fb0 <linktest+0xba>
    4fdc:	97a2                	add	a5,a5,s0
    4fde:	fd07c783          	lbu	a5,-48(a5)
    4fe2:	eb8d                	bnez	a5,5014 <concreate+0x154>
      fa[i] = 1;
    4fe4:	fb070793          	addi	a5,a4,-80
    4fe8:	00878733          	add	a4,a5,s0
    4fec:	fd770823          	sb	s7,-48(a4)
      n++;
    4ff0:	2a85                	addiw	s5,s5,1
    4ff2:	b77d                	j	4fa0 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4ff4:	f7240613          	addi	a2,s0,-142
    4ff8:	85ce                	mv	a1,s3
    4ffa:	00003517          	auipc	a0,0x3
    4ffe:	f2650513          	addi	a0,a0,-218 # 7f20 <malloc+0x1ecc>
    5002:	00001097          	auipc	ra,0x1
    5006:	f9a080e7          	jalr	-102(ra) # 5f9c <printf>
        exit(1);
    500a:	4505                	li	a0,1
    500c:	00001097          	auipc	ra,0x1
    5010:	c20080e7          	jalr	-992(ra) # 5c2c <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    5014:	f7240613          	addi	a2,s0,-142
    5018:	85ce                	mv	a1,s3
    501a:	00003517          	auipc	a0,0x3
    501e:	f2650513          	addi	a0,a0,-218 # 7f40 <malloc+0x1eec>
    5022:	00001097          	auipc	ra,0x1
    5026:	f7a080e7          	jalr	-134(ra) # 5f9c <printf>
        exit(1);
    502a:	4505                	li	a0,1
    502c:	00001097          	auipc	ra,0x1
    5030:	c00080e7          	jalr	-1024(ra) # 5c2c <exit>
  close(fd);
    5034:	854a                	mv	a0,s2
    5036:	00001097          	auipc	ra,0x1
    503a:	c1e080e7          	jalr	-994(ra) # 5c54 <close>
  if(n != N){
    503e:	02800793          	li	a5,40
    5042:	00fa9763          	bne	s5,a5,5050 <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    5046:	4a8d                	li	s5,3
    5048:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    504a:	02800a13          	li	s4,40
    504e:	a8c9                	j	5120 <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    5050:	85ce                	mv	a1,s3
    5052:	00003517          	auipc	a0,0x3
    5056:	f1650513          	addi	a0,a0,-234 # 7f68 <malloc+0x1f14>
    505a:	00001097          	auipc	ra,0x1
    505e:	f42080e7          	jalr	-190(ra) # 5f9c <printf>
    exit(1);
    5062:	4505                	li	a0,1
    5064:	00001097          	auipc	ra,0x1
    5068:	bc8080e7          	jalr	-1080(ra) # 5c2c <exit>
      printf("%s: fork failed\n", s);
    506c:	85ce                	mv	a1,s3
    506e:	00002517          	auipc	a0,0x2
    5072:	9b250513          	addi	a0,a0,-1614 # 6a20 <malloc+0x9cc>
    5076:	00001097          	auipc	ra,0x1
    507a:	f26080e7          	jalr	-218(ra) # 5f9c <printf>
      exit(1);
    507e:	4505                	li	a0,1
    5080:	00001097          	auipc	ra,0x1
    5084:	bac080e7          	jalr	-1108(ra) # 5c2c <exit>
      close(open(file, 0));
    5088:	4581                	li	a1,0
    508a:	fa840513          	addi	a0,s0,-88
    508e:	00001097          	auipc	ra,0x1
    5092:	bde080e7          	jalr	-1058(ra) # 5c6c <open>
    5096:	00001097          	auipc	ra,0x1
    509a:	bbe080e7          	jalr	-1090(ra) # 5c54 <close>
      close(open(file, 0));
    509e:	4581                	li	a1,0
    50a0:	fa840513          	addi	a0,s0,-88
    50a4:	00001097          	auipc	ra,0x1
    50a8:	bc8080e7          	jalr	-1080(ra) # 5c6c <open>
    50ac:	00001097          	auipc	ra,0x1
    50b0:	ba8080e7          	jalr	-1112(ra) # 5c54 <close>
      close(open(file, 0));
    50b4:	4581                	li	a1,0
    50b6:	fa840513          	addi	a0,s0,-88
    50ba:	00001097          	auipc	ra,0x1
    50be:	bb2080e7          	jalr	-1102(ra) # 5c6c <open>
    50c2:	00001097          	auipc	ra,0x1
    50c6:	b92080e7          	jalr	-1134(ra) # 5c54 <close>
      close(open(file, 0));
    50ca:	4581                	li	a1,0
    50cc:	fa840513          	addi	a0,s0,-88
    50d0:	00001097          	auipc	ra,0x1
    50d4:	b9c080e7          	jalr	-1124(ra) # 5c6c <open>
    50d8:	00001097          	auipc	ra,0x1
    50dc:	b7c080e7          	jalr	-1156(ra) # 5c54 <close>
      close(open(file, 0));
    50e0:	4581                	li	a1,0
    50e2:	fa840513          	addi	a0,s0,-88
    50e6:	00001097          	auipc	ra,0x1
    50ea:	b86080e7          	jalr	-1146(ra) # 5c6c <open>
    50ee:	00001097          	auipc	ra,0x1
    50f2:	b66080e7          	jalr	-1178(ra) # 5c54 <close>
      close(open(file, 0));
    50f6:	4581                	li	a1,0
    50f8:	fa840513          	addi	a0,s0,-88
    50fc:	00001097          	auipc	ra,0x1
    5100:	b70080e7          	jalr	-1168(ra) # 5c6c <open>
    5104:	00001097          	auipc	ra,0x1
    5108:	b50080e7          	jalr	-1200(ra) # 5c54 <close>
    if(pid == 0)
    510c:	08090363          	beqz	s2,5192 <concreate+0x2d2>
      wait(0);
    5110:	4501                	li	a0,0
    5112:	00001097          	auipc	ra,0x1
    5116:	b22080e7          	jalr	-1246(ra) # 5c34 <wait>
  for(i = 0; i < N; i++){
    511a:	2485                	addiw	s1,s1,1
    511c:	0f448563          	beq	s1,s4,5206 <concreate+0x346>
    file[1] = '0' + i;
    5120:	0304879b          	addiw	a5,s1,48
    5124:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    5128:	00001097          	auipc	ra,0x1
    512c:	afc080e7          	jalr	-1284(ra) # 5c24 <fork>
    5130:	892a                	mv	s2,a0
    if(pid < 0){
    5132:	f2054de3          	bltz	a0,506c <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    5136:	0354e73b          	remw	a4,s1,s5
    513a:	00a767b3          	or	a5,a4,a0
    513e:	2781                	sext.w	a5,a5
    5140:	d7a1                	beqz	a5,5088 <concreate+0x1c8>
    5142:	01671363          	bne	a4,s6,5148 <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    5146:	f129                	bnez	a0,5088 <concreate+0x1c8>
      unlink(file);
    5148:	fa840513          	addi	a0,s0,-88
    514c:	00001097          	auipc	ra,0x1
    5150:	b30080e7          	jalr	-1232(ra) # 5c7c <unlink>
      unlink(file);
    5154:	fa840513          	addi	a0,s0,-88
    5158:	00001097          	auipc	ra,0x1
    515c:	b24080e7          	jalr	-1244(ra) # 5c7c <unlink>
      unlink(file);
    5160:	fa840513          	addi	a0,s0,-88
    5164:	00001097          	auipc	ra,0x1
    5168:	b18080e7          	jalr	-1256(ra) # 5c7c <unlink>
      unlink(file);
    516c:	fa840513          	addi	a0,s0,-88
    5170:	00001097          	auipc	ra,0x1
    5174:	b0c080e7          	jalr	-1268(ra) # 5c7c <unlink>
      unlink(file);
    5178:	fa840513          	addi	a0,s0,-88
    517c:	00001097          	auipc	ra,0x1
    5180:	b00080e7          	jalr	-1280(ra) # 5c7c <unlink>
      unlink(file);
    5184:	fa840513          	addi	a0,s0,-88
    5188:	00001097          	auipc	ra,0x1
    518c:	af4080e7          	jalr	-1292(ra) # 5c7c <unlink>
    5190:	bfb5                	j	510c <concreate+0x24c>
      exit(0);
    5192:	4501                	li	a0,0
    5194:	00001097          	auipc	ra,0x1
    5198:	a98080e7          	jalr	-1384(ra) # 5c2c <exit>
      close(fd);
    519c:	00001097          	auipc	ra,0x1
    51a0:	ab8080e7          	jalr	-1352(ra) # 5c54 <close>
    if(pid == 0) {
    51a4:	bb5d                	j	4f5a <concreate+0x9a>
      close(fd);
    51a6:	00001097          	auipc	ra,0x1
    51aa:	aae080e7          	jalr	-1362(ra) # 5c54 <close>
      wait(&xstatus);
    51ae:	f6c40513          	addi	a0,s0,-148
    51b2:	00001097          	auipc	ra,0x1
    51b6:	a82080e7          	jalr	-1406(ra) # 5c34 <wait>
      if(xstatus != 0)
    51ba:	f6c42483          	lw	s1,-148(s0)
    51be:	da0493e3          	bnez	s1,4f64 <concreate+0xa4>
  for(i = 0; i < N; i++){
    51c2:	2905                	addiw	s2,s2,1
    51c4:	db4905e3          	beq	s2,s4,4f6e <concreate+0xae>
    file[1] = '0' + i;
    51c8:	0309079b          	addiw	a5,s2,48
    51cc:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    51d0:	fa840513          	addi	a0,s0,-88
    51d4:	00001097          	auipc	ra,0x1
    51d8:	aa8080e7          	jalr	-1368(ra) # 5c7c <unlink>
    pid = fork();
    51dc:	00001097          	auipc	ra,0x1
    51e0:	a48080e7          	jalr	-1464(ra) # 5c24 <fork>
    if(pid && (i % 3) == 1){
    51e4:	d20502e3          	beqz	a0,4f08 <concreate+0x48>
    51e8:	036967bb          	remw	a5,s2,s6
    51ec:	d15786e3          	beq	a5,s5,4ef8 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    51f0:	20200593          	li	a1,514
    51f4:	fa840513          	addi	a0,s0,-88
    51f8:	00001097          	auipc	ra,0x1
    51fc:	a74080e7          	jalr	-1420(ra) # 5c6c <open>
      if(fd < 0){
    5200:	fa0553e3          	bgez	a0,51a6 <concreate+0x2e6>
    5204:	b315                	j	4f28 <concreate+0x68>
}
    5206:	60ea                	ld	ra,152(sp)
    5208:	644a                	ld	s0,144(sp)
    520a:	64aa                	ld	s1,136(sp)
    520c:	690a                	ld	s2,128(sp)
    520e:	79e6                	ld	s3,120(sp)
    5210:	7a46                	ld	s4,112(sp)
    5212:	7aa6                	ld	s5,104(sp)
    5214:	7b06                	ld	s6,96(sp)
    5216:	6be6                	ld	s7,88(sp)
    5218:	610d                	addi	sp,sp,160
    521a:	8082                	ret

000000000000521c <bigfile>:
{
    521c:	7139                	addi	sp,sp,-64
    521e:	fc06                	sd	ra,56(sp)
    5220:	f822                	sd	s0,48(sp)
    5222:	f426                	sd	s1,40(sp)
    5224:	f04a                	sd	s2,32(sp)
    5226:	ec4e                	sd	s3,24(sp)
    5228:	e852                	sd	s4,16(sp)
    522a:	e456                	sd	s5,8(sp)
    522c:	0080                	addi	s0,sp,64
    522e:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    5230:	00003517          	auipc	a0,0x3
    5234:	d7050513          	addi	a0,a0,-656 # 7fa0 <malloc+0x1f4c>
    5238:	00001097          	auipc	ra,0x1
    523c:	a44080e7          	jalr	-1468(ra) # 5c7c <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    5240:	20200593          	li	a1,514
    5244:	00003517          	auipc	a0,0x3
    5248:	d5c50513          	addi	a0,a0,-676 # 7fa0 <malloc+0x1f4c>
    524c:	00001097          	auipc	ra,0x1
    5250:	a20080e7          	jalr	-1504(ra) # 5c6c <open>
    5254:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    5256:	4481                	li	s1,0
    memset(buf, i, SZ);
    5258:	00009917          	auipc	s2,0x9
    525c:	dc090913          	addi	s2,s2,-576 # e018 <buf>
  for(i = 0; i < N; i++){
    5260:	4a51                	li	s4,20
  if(fd < 0){
    5262:	0a054063          	bltz	a0,5302 <bigfile+0xe6>
    memset(buf, i, SZ);
    5266:	25800613          	li	a2,600
    526a:	85a6                	mv	a1,s1
    526c:	854a                	mv	a0,s2
    526e:	00000097          	auipc	ra,0x0
    5272:	7c4080e7          	jalr	1988(ra) # 5a32 <memset>
    if(write(fd, buf, SZ) != SZ){
    5276:	25800613          	li	a2,600
    527a:	85ca                	mv	a1,s2
    527c:	854e                	mv	a0,s3
    527e:	00001097          	auipc	ra,0x1
    5282:	9ce080e7          	jalr	-1586(ra) # 5c4c <write>
    5286:	25800793          	li	a5,600
    528a:	08f51a63          	bne	a0,a5,531e <bigfile+0x102>
  for(i = 0; i < N; i++){
    528e:	2485                	addiw	s1,s1,1
    5290:	fd449be3          	bne	s1,s4,5266 <bigfile+0x4a>
  close(fd);
    5294:	854e                	mv	a0,s3
    5296:	00001097          	auipc	ra,0x1
    529a:	9be080e7          	jalr	-1602(ra) # 5c54 <close>
  fd = open("bigfile.dat", 0);
    529e:	4581                	li	a1,0
    52a0:	00003517          	auipc	a0,0x3
    52a4:	d0050513          	addi	a0,a0,-768 # 7fa0 <malloc+0x1f4c>
    52a8:	00001097          	auipc	ra,0x1
    52ac:	9c4080e7          	jalr	-1596(ra) # 5c6c <open>
    52b0:	8a2a                	mv	s4,a0
  total = 0;
    52b2:	4981                	li	s3,0
  for(i = 0; ; i++){
    52b4:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    52b6:	00009917          	auipc	s2,0x9
    52ba:	d6290913          	addi	s2,s2,-670 # e018 <buf>
  if(fd < 0){
    52be:	06054e63          	bltz	a0,533a <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    52c2:	12c00613          	li	a2,300
    52c6:	85ca                	mv	a1,s2
    52c8:	8552                	mv	a0,s4
    52ca:	00001097          	auipc	ra,0x1
    52ce:	97a080e7          	jalr	-1670(ra) # 5c44 <read>
    if(cc < 0){
    52d2:	08054263          	bltz	a0,5356 <bigfile+0x13a>
    if(cc == 0)
    52d6:	c971                	beqz	a0,53aa <bigfile+0x18e>
    if(cc != SZ/2){
    52d8:	12c00793          	li	a5,300
    52dc:	08f51b63          	bne	a0,a5,5372 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    52e0:	01f4d79b          	srliw	a5,s1,0x1f
    52e4:	9fa5                	addw	a5,a5,s1
    52e6:	4017d79b          	sraiw	a5,a5,0x1
    52ea:	00094703          	lbu	a4,0(s2)
    52ee:	0af71063          	bne	a4,a5,538e <bigfile+0x172>
    52f2:	12b94703          	lbu	a4,299(s2)
    52f6:	08f71c63          	bne	a4,a5,538e <bigfile+0x172>
    total += cc;
    52fa:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    52fe:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    5300:	b7c9                	j	52c2 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    5302:	85d6                	mv	a1,s5
    5304:	00003517          	auipc	a0,0x3
    5308:	cac50513          	addi	a0,a0,-852 # 7fb0 <malloc+0x1f5c>
    530c:	00001097          	auipc	ra,0x1
    5310:	c90080e7          	jalr	-880(ra) # 5f9c <printf>
    exit(1);
    5314:	4505                	li	a0,1
    5316:	00001097          	auipc	ra,0x1
    531a:	916080e7          	jalr	-1770(ra) # 5c2c <exit>
      printf("%s: write bigfile failed\n", s);
    531e:	85d6                	mv	a1,s5
    5320:	00003517          	auipc	a0,0x3
    5324:	cb050513          	addi	a0,a0,-848 # 7fd0 <malloc+0x1f7c>
    5328:	00001097          	auipc	ra,0x1
    532c:	c74080e7          	jalr	-908(ra) # 5f9c <printf>
      exit(1);
    5330:	4505                	li	a0,1
    5332:	00001097          	auipc	ra,0x1
    5336:	8fa080e7          	jalr	-1798(ra) # 5c2c <exit>
    printf("%s: cannot open bigfile\n", s);
    533a:	85d6                	mv	a1,s5
    533c:	00003517          	auipc	a0,0x3
    5340:	cb450513          	addi	a0,a0,-844 # 7ff0 <malloc+0x1f9c>
    5344:	00001097          	auipc	ra,0x1
    5348:	c58080e7          	jalr	-936(ra) # 5f9c <printf>
    exit(1);
    534c:	4505                	li	a0,1
    534e:	00001097          	auipc	ra,0x1
    5352:	8de080e7          	jalr	-1826(ra) # 5c2c <exit>
      printf("%s: read bigfile failed\n", s);
    5356:	85d6                	mv	a1,s5
    5358:	00003517          	auipc	a0,0x3
    535c:	cb850513          	addi	a0,a0,-840 # 8010 <malloc+0x1fbc>
    5360:	00001097          	auipc	ra,0x1
    5364:	c3c080e7          	jalr	-964(ra) # 5f9c <printf>
      exit(1);
    5368:	4505                	li	a0,1
    536a:	00001097          	auipc	ra,0x1
    536e:	8c2080e7          	jalr	-1854(ra) # 5c2c <exit>
      printf("%s: short read bigfile\n", s);
    5372:	85d6                	mv	a1,s5
    5374:	00003517          	auipc	a0,0x3
    5378:	cbc50513          	addi	a0,a0,-836 # 8030 <malloc+0x1fdc>
    537c:	00001097          	auipc	ra,0x1
    5380:	c20080e7          	jalr	-992(ra) # 5f9c <printf>
      exit(1);
    5384:	4505                	li	a0,1
    5386:	00001097          	auipc	ra,0x1
    538a:	8a6080e7          	jalr	-1882(ra) # 5c2c <exit>
      printf("%s: read bigfile wrong data\n", s);
    538e:	85d6                	mv	a1,s5
    5390:	00003517          	auipc	a0,0x3
    5394:	cb850513          	addi	a0,a0,-840 # 8048 <malloc+0x1ff4>
    5398:	00001097          	auipc	ra,0x1
    539c:	c04080e7          	jalr	-1020(ra) # 5f9c <printf>
      exit(1);
    53a0:	4505                	li	a0,1
    53a2:	00001097          	auipc	ra,0x1
    53a6:	88a080e7          	jalr	-1910(ra) # 5c2c <exit>
  close(fd);
    53aa:	8552                	mv	a0,s4
    53ac:	00001097          	auipc	ra,0x1
    53b0:	8a8080e7          	jalr	-1880(ra) # 5c54 <close>
  if(total != N*SZ){
    53b4:	678d                	lui	a5,0x3
    53b6:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrklast+0x38>
    53ba:	02f99363          	bne	s3,a5,53e0 <bigfile+0x1c4>
  unlink("bigfile.dat");
    53be:	00003517          	auipc	a0,0x3
    53c2:	be250513          	addi	a0,a0,-1054 # 7fa0 <malloc+0x1f4c>
    53c6:	00001097          	auipc	ra,0x1
    53ca:	8b6080e7          	jalr	-1866(ra) # 5c7c <unlink>
}
    53ce:	70e2                	ld	ra,56(sp)
    53d0:	7442                	ld	s0,48(sp)
    53d2:	74a2                	ld	s1,40(sp)
    53d4:	7902                	ld	s2,32(sp)
    53d6:	69e2                	ld	s3,24(sp)
    53d8:	6a42                	ld	s4,16(sp)
    53da:	6aa2                	ld	s5,8(sp)
    53dc:	6121                	addi	sp,sp,64
    53de:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    53e0:	85d6                	mv	a1,s5
    53e2:	00003517          	auipc	a0,0x3
    53e6:	c8650513          	addi	a0,a0,-890 # 8068 <malloc+0x2014>
    53ea:	00001097          	auipc	ra,0x1
    53ee:	bb2080e7          	jalr	-1102(ra) # 5f9c <printf>
    exit(1);
    53f2:	4505                	li	a0,1
    53f4:	00001097          	auipc	ra,0x1
    53f8:	838080e7          	jalr	-1992(ra) # 5c2c <exit>

00000000000053fc <fsfull>:
{
    53fc:	7135                	addi	sp,sp,-160
    53fe:	ed06                	sd	ra,152(sp)
    5400:	e922                	sd	s0,144(sp)
    5402:	e526                	sd	s1,136(sp)
    5404:	e14a                	sd	s2,128(sp)
    5406:	fcce                	sd	s3,120(sp)
    5408:	f8d2                	sd	s4,112(sp)
    540a:	f4d6                	sd	s5,104(sp)
    540c:	f0da                	sd	s6,96(sp)
    540e:	ecde                	sd	s7,88(sp)
    5410:	e8e2                	sd	s8,80(sp)
    5412:	e4e6                	sd	s9,72(sp)
    5414:	e0ea                	sd	s10,64(sp)
    5416:	1100                	addi	s0,sp,160
  printf("fsfull test\n");
    5418:	00003517          	auipc	a0,0x3
    541c:	c7050513          	addi	a0,a0,-912 # 8088 <malloc+0x2034>
    5420:	00001097          	auipc	ra,0x1
    5424:	b7c080e7          	jalr	-1156(ra) # 5f9c <printf>
  for(nfiles = 0; ; nfiles++){
    5428:	4481                	li	s1,0
    name[0] = 'f';
    542a:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    542e:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5432:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    5436:	4b29                	li	s6,10
    printf("writing %s\n", name);
    5438:	00003c97          	auipc	s9,0x3
    543c:	c60c8c93          	addi	s9,s9,-928 # 8098 <malloc+0x2044>
    name[0] = 'f';
    5440:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    5444:	0384c7bb          	divw	a5,s1,s8
    5448:	0307879b          	addiw	a5,a5,48
    544c:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5450:	0384e7bb          	remw	a5,s1,s8
    5454:	0377c7bb          	divw	a5,a5,s7
    5458:	0307879b          	addiw	a5,a5,48
    545c:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5460:	0374e7bb          	remw	a5,s1,s7
    5464:	0367c7bb          	divw	a5,a5,s6
    5468:	0307879b          	addiw	a5,a5,48
    546c:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    5470:	0364e7bb          	remw	a5,s1,s6
    5474:	0307879b          	addiw	a5,a5,48
    5478:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    547c:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    5480:	f6040593          	addi	a1,s0,-160
    5484:	8566                	mv	a0,s9
    5486:	00001097          	auipc	ra,0x1
    548a:	b16080e7          	jalr	-1258(ra) # 5f9c <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    548e:	20200593          	li	a1,514
    5492:	f6040513          	addi	a0,s0,-160
    5496:	00000097          	auipc	ra,0x0
    549a:	7d6080e7          	jalr	2006(ra) # 5c6c <open>
    549e:	892a                	mv	s2,a0
    if(fd < 0){
    54a0:	0a055563          	bgez	a0,554a <fsfull+0x14e>
      printf("open %s failed\n", name);
    54a4:	f6040593          	addi	a1,s0,-160
    54a8:	00003517          	auipc	a0,0x3
    54ac:	c0050513          	addi	a0,a0,-1024 # 80a8 <malloc+0x2054>
    54b0:	00001097          	auipc	ra,0x1
    54b4:	aec080e7          	jalr	-1300(ra) # 5f9c <printf>
  while(nfiles >= 0){
    54b8:	0604c363          	bltz	s1,551e <fsfull+0x122>
    name[0] = 'f';
    54bc:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    54c0:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    54c4:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    54c8:	4929                	li	s2,10
  while(nfiles >= 0){
    54ca:	5afd                	li	s5,-1
    name[0] = 'f';
    54cc:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    54d0:	0344c7bb          	divw	a5,s1,s4
    54d4:	0307879b          	addiw	a5,a5,48
    54d8:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    54dc:	0344e7bb          	remw	a5,s1,s4
    54e0:	0337c7bb          	divw	a5,a5,s3
    54e4:	0307879b          	addiw	a5,a5,48
    54e8:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    54ec:	0334e7bb          	remw	a5,s1,s3
    54f0:	0327c7bb          	divw	a5,a5,s2
    54f4:	0307879b          	addiw	a5,a5,48
    54f8:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    54fc:	0324e7bb          	remw	a5,s1,s2
    5500:	0307879b          	addiw	a5,a5,48
    5504:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    5508:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    550c:	f6040513          	addi	a0,s0,-160
    5510:	00000097          	auipc	ra,0x0
    5514:	76c080e7          	jalr	1900(ra) # 5c7c <unlink>
    nfiles--;
    5518:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    551a:	fb5499e3          	bne	s1,s5,54cc <fsfull+0xd0>
  printf("fsfull test finished\n");
    551e:	00003517          	auipc	a0,0x3
    5522:	baa50513          	addi	a0,a0,-1110 # 80c8 <malloc+0x2074>
    5526:	00001097          	auipc	ra,0x1
    552a:	a76080e7          	jalr	-1418(ra) # 5f9c <printf>
}
    552e:	60ea                	ld	ra,152(sp)
    5530:	644a                	ld	s0,144(sp)
    5532:	64aa                	ld	s1,136(sp)
    5534:	690a                	ld	s2,128(sp)
    5536:	79e6                	ld	s3,120(sp)
    5538:	7a46                	ld	s4,112(sp)
    553a:	7aa6                	ld	s5,104(sp)
    553c:	7b06                	ld	s6,96(sp)
    553e:	6be6                	ld	s7,88(sp)
    5540:	6c46                	ld	s8,80(sp)
    5542:	6ca6                	ld	s9,72(sp)
    5544:	6d06                	ld	s10,64(sp)
    5546:	610d                	addi	sp,sp,160
    5548:	8082                	ret
    int total = 0;
    554a:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    554c:	00009a97          	auipc	s5,0x9
    5550:	acca8a93          	addi	s5,s5,-1332 # e018 <buf>
      if(cc < BSIZE)
    5554:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    5558:	40000613          	li	a2,1024
    555c:	85d6                	mv	a1,s5
    555e:	854a                	mv	a0,s2
    5560:	00000097          	auipc	ra,0x0
    5564:	6ec080e7          	jalr	1772(ra) # 5c4c <write>
      if(cc < BSIZE)
    5568:	00aa5563          	bge	s4,a0,5572 <fsfull+0x176>
      total += cc;
    556c:	00a989bb          	addw	s3,s3,a0
    while(1){
    5570:	b7e5                	j	5558 <fsfull+0x15c>
    printf("wrote %d bytes\n", total);
    5572:	85ce                	mv	a1,s3
    5574:	00003517          	auipc	a0,0x3
    5578:	b4450513          	addi	a0,a0,-1212 # 80b8 <malloc+0x2064>
    557c:	00001097          	auipc	ra,0x1
    5580:	a20080e7          	jalr	-1504(ra) # 5f9c <printf>
    close(fd);
    5584:	854a                	mv	a0,s2
    5586:	00000097          	auipc	ra,0x0
    558a:	6ce080e7          	jalr	1742(ra) # 5c54 <close>
    if(total == 0)
    558e:	f20985e3          	beqz	s3,54b8 <fsfull+0xbc>
  for(nfiles = 0; ; nfiles++){
    5592:	2485                	addiw	s1,s1,1
    5594:	b575                	j	5440 <fsfull+0x44>

0000000000005596 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5596:	7179                	addi	sp,sp,-48
    5598:	f406                	sd	ra,40(sp)
    559a:	f022                	sd	s0,32(sp)
    559c:	ec26                	sd	s1,24(sp)
    559e:	e84a                	sd	s2,16(sp)
    55a0:	1800                	addi	s0,sp,48
    55a2:	84aa                	mv	s1,a0
    55a4:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    55a6:	00003517          	auipc	a0,0x3
    55aa:	b3a50513          	addi	a0,a0,-1222 # 80e0 <malloc+0x208c>
    55ae:	00001097          	auipc	ra,0x1
    55b2:	9ee080e7          	jalr	-1554(ra) # 5f9c <printf>
  if((pid = fork()) < 0) {
    55b6:	00000097          	auipc	ra,0x0
    55ba:	66e080e7          	jalr	1646(ra) # 5c24 <fork>
    55be:	02054e63          	bltz	a0,55fa <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    55c2:	c929                	beqz	a0,5614 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    55c4:	fdc40513          	addi	a0,s0,-36
    55c8:	00000097          	auipc	ra,0x0
    55cc:	66c080e7          	jalr	1644(ra) # 5c34 <wait>
    if(xstatus != 0) 
    55d0:	fdc42783          	lw	a5,-36(s0)
    55d4:	c7b9                	beqz	a5,5622 <run+0x8c>
      printf("FAILED\n");
    55d6:	00003517          	auipc	a0,0x3
    55da:	b3250513          	addi	a0,a0,-1230 # 8108 <malloc+0x20b4>
    55de:	00001097          	auipc	ra,0x1
    55e2:	9be080e7          	jalr	-1602(ra) # 5f9c <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    55e6:	fdc42503          	lw	a0,-36(s0)
  }
}
    55ea:	00153513          	seqz	a0,a0
    55ee:	70a2                	ld	ra,40(sp)
    55f0:	7402                	ld	s0,32(sp)
    55f2:	64e2                	ld	s1,24(sp)
    55f4:	6942                	ld	s2,16(sp)
    55f6:	6145                	addi	sp,sp,48
    55f8:	8082                	ret
    printf("runtest: fork error\n");
    55fa:	00003517          	auipc	a0,0x3
    55fe:	af650513          	addi	a0,a0,-1290 # 80f0 <malloc+0x209c>
    5602:	00001097          	auipc	ra,0x1
    5606:	99a080e7          	jalr	-1638(ra) # 5f9c <printf>
    exit(1);
    560a:	4505                	li	a0,1
    560c:	00000097          	auipc	ra,0x0
    5610:	620080e7          	jalr	1568(ra) # 5c2c <exit>
    f(s);
    5614:	854a                	mv	a0,s2
    5616:	9482                	jalr	s1
    exit(0);
    5618:	4501                	li	a0,0
    561a:	00000097          	auipc	ra,0x0
    561e:	612080e7          	jalr	1554(ra) # 5c2c <exit>
      printf("OK\n");
    5622:	00003517          	auipc	a0,0x3
    5626:	aee50513          	addi	a0,a0,-1298 # 8110 <malloc+0x20bc>
    562a:	00001097          	auipc	ra,0x1
    562e:	972080e7          	jalr	-1678(ra) # 5f9c <printf>
    5632:	bf55                	j	55e6 <run+0x50>

0000000000005634 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    5634:	7179                	addi	sp,sp,-48
    5636:	f406                	sd	ra,40(sp)
    5638:	f022                	sd	s0,32(sp)
    563a:	ec26                	sd	s1,24(sp)
    563c:	1800                	addi	s0,sp,48
    563e:	84aa                	mv	s1,a0
  for (struct test *t = tests; t->s != 0; t++) {
    5640:	6508                	ld	a0,8(a0)
    5642:	c12d                	beqz	a0,56a4 <runtests+0x70>
    5644:	e84a                	sd	s2,16(sp)
    5646:	e44e                	sd	s3,8(sp)
    5648:	e052                	sd	s4,0(sp)
    564a:	892e                	mv	s2,a1
    564c:	89b2                	mv	s3,a2
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s)){
        if(continuous != 2){
    564e:	4a09                	li	s4,2
    5650:	a021                	j	5658 <runtests+0x24>
  for (struct test *t = tests; t->s != 0; t++) {
    5652:	04c1                	addi	s1,s1,16
    5654:	6488                	ld	a0,8(s1)
    5656:	cd1d                	beqz	a0,5694 <runtests+0x60>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    5658:	00090863          	beqz	s2,5668 <runtests+0x34>
    565c:	85ca                	mv	a1,s2
    565e:	00000097          	auipc	ra,0x0
    5662:	37e080e7          	jalr	894(ra) # 59dc <strcmp>
    5666:	f575                	bnez	a0,5652 <runtests+0x1e>
      if(!run(t->f, t->s)){
    5668:	648c                	ld	a1,8(s1)
    566a:	6088                	ld	a0,0(s1)
    566c:	00000097          	auipc	ra,0x0
    5670:	f2a080e7          	jalr	-214(ra) # 5596 <run>
    5674:	fd79                	bnez	a0,5652 <runtests+0x1e>
        if(continuous != 2){
    5676:	fd498ee3          	beq	s3,s4,5652 <runtests+0x1e>
          printf("SOME TESTS FAILED\n");
    567a:	00003517          	auipc	a0,0x3
    567e:	a9e50513          	addi	a0,a0,-1378 # 8118 <malloc+0x20c4>
    5682:	00001097          	auipc	ra,0x1
    5686:	91a080e7          	jalr	-1766(ra) # 5f9c <printf>
          return 1;
    568a:	4505                	li	a0,1
    568c:	6942                	ld	s2,16(sp)
    568e:	69a2                	ld	s3,8(sp)
    5690:	6a02                	ld	s4,0(sp)
    5692:	a021                	j	569a <runtests+0x66>
    5694:	6942                	ld	s2,16(sp)
    5696:	69a2                	ld	s3,8(sp)
    5698:	6a02                	ld	s4,0(sp)
        }
      }
    }
  }
  return 0;
}
    569a:	70a2                	ld	ra,40(sp)
    569c:	7402                	ld	s0,32(sp)
    569e:	64e2                	ld	s1,24(sp)
    56a0:	6145                	addi	sp,sp,48
    56a2:	8082                	ret
  return 0;
    56a4:	4501                	li	a0,0
    56a6:	bfd5                	j	569a <runtests+0x66>

00000000000056a8 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    56a8:	7139                	addi	sp,sp,-64
    56aa:	fc06                	sd	ra,56(sp)
    56ac:	f822                	sd	s0,48(sp)
    56ae:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    56b0:	fc840513          	addi	a0,s0,-56
    56b4:	00000097          	auipc	ra,0x0
    56b8:	588080e7          	jalr	1416(ra) # 5c3c <pipe>
    56bc:	06054a63          	bltz	a0,5730 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    56c0:	00000097          	auipc	ra,0x0
    56c4:	564080e7          	jalr	1380(ra) # 5c24 <fork>

  if(pid < 0){
    56c8:	08054463          	bltz	a0,5750 <countfree+0xa8>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    56cc:	e55d                	bnez	a0,577a <countfree+0xd2>
    56ce:	f426                	sd	s1,40(sp)
    56d0:	f04a                	sd	s2,32(sp)
    56d2:	ec4e                	sd	s3,24(sp)
    close(fds[0]);
    56d4:	fc842503          	lw	a0,-56(s0)
    56d8:	00000097          	auipc	ra,0x0
    56dc:	57c080e7          	jalr	1404(ra) # 5c54 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    56e0:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    56e2:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    56e4:	00001997          	auipc	s3,0x1
    56e8:	b2498993          	addi	s3,s3,-1244 # 6208 <malloc+0x1b4>
      uint64 a = (uint64) sbrk(4096);
    56ec:	6505                	lui	a0,0x1
    56ee:	00000097          	auipc	ra,0x0
    56f2:	5c6080e7          	jalr	1478(ra) # 5cb4 <sbrk>
      if(a == 0xffffffffffffffff){
    56f6:	07250d63          	beq	a0,s2,5770 <countfree+0xc8>
      *(char *)(a + 4096 - 1) = 1;
    56fa:	6785                	lui	a5,0x1
    56fc:	97aa                	add	a5,a5,a0
    56fe:	fe978fa3          	sb	s1,-1(a5) # fff <linktest+0x109>
      if(write(fds[1], "x", 1) != 1){
    5702:	8626                	mv	a2,s1
    5704:	85ce                	mv	a1,s3
    5706:	fcc42503          	lw	a0,-52(s0)
    570a:	00000097          	auipc	ra,0x0
    570e:	542080e7          	jalr	1346(ra) # 5c4c <write>
    5712:	fc950de3          	beq	a0,s1,56ec <countfree+0x44>
        printf("write() failed in countfree()\n");
    5716:	00003517          	auipc	a0,0x3
    571a:	a5a50513          	addi	a0,a0,-1446 # 8170 <malloc+0x211c>
    571e:	00001097          	auipc	ra,0x1
    5722:	87e080e7          	jalr	-1922(ra) # 5f9c <printf>
        exit(1);
    5726:	4505                	li	a0,1
    5728:	00000097          	auipc	ra,0x0
    572c:	504080e7          	jalr	1284(ra) # 5c2c <exit>
    5730:	f426                	sd	s1,40(sp)
    5732:	f04a                	sd	s2,32(sp)
    5734:	ec4e                	sd	s3,24(sp)
    printf("pipe() failed in countfree()\n");
    5736:	00003517          	auipc	a0,0x3
    573a:	9fa50513          	addi	a0,a0,-1542 # 8130 <malloc+0x20dc>
    573e:	00001097          	auipc	ra,0x1
    5742:	85e080e7          	jalr	-1954(ra) # 5f9c <printf>
    exit(1);
    5746:	4505                	li	a0,1
    5748:	00000097          	auipc	ra,0x0
    574c:	4e4080e7          	jalr	1252(ra) # 5c2c <exit>
    5750:	f426                	sd	s1,40(sp)
    5752:	f04a                	sd	s2,32(sp)
    5754:	ec4e                	sd	s3,24(sp)
    printf("fork failed in countfree()\n");
    5756:	00003517          	auipc	a0,0x3
    575a:	9fa50513          	addi	a0,a0,-1542 # 8150 <malloc+0x20fc>
    575e:	00001097          	auipc	ra,0x1
    5762:	83e080e7          	jalr	-1986(ra) # 5f9c <printf>
    exit(1);
    5766:	4505                	li	a0,1
    5768:	00000097          	auipc	ra,0x0
    576c:	4c4080e7          	jalr	1220(ra) # 5c2c <exit>
      }
    }

    exit(0);
    5770:	4501                	li	a0,0
    5772:	00000097          	auipc	ra,0x0
    5776:	4ba080e7          	jalr	1210(ra) # 5c2c <exit>
    577a:	f426                	sd	s1,40(sp)
  }

  close(fds[1]);
    577c:	fcc42503          	lw	a0,-52(s0)
    5780:	00000097          	auipc	ra,0x0
    5784:	4d4080e7          	jalr	1236(ra) # 5c54 <close>

  int n = 0;
    5788:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    578a:	4605                	li	a2,1
    578c:	fc740593          	addi	a1,s0,-57
    5790:	fc842503          	lw	a0,-56(s0)
    5794:	00000097          	auipc	ra,0x0
    5798:	4b0080e7          	jalr	1200(ra) # 5c44 <read>
    if(cc < 0){
    579c:	00054563          	bltz	a0,57a6 <countfree+0xfe>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    57a0:	c115                	beqz	a0,57c4 <countfree+0x11c>
      break;
    n += 1;
    57a2:	2485                	addiw	s1,s1,1
  while(1){
    57a4:	b7dd                	j	578a <countfree+0xe2>
    57a6:	f04a                	sd	s2,32(sp)
    57a8:	ec4e                	sd	s3,24(sp)
      printf("read() failed in countfree()\n");
    57aa:	00003517          	auipc	a0,0x3
    57ae:	9e650513          	addi	a0,a0,-1562 # 8190 <malloc+0x213c>
    57b2:	00000097          	auipc	ra,0x0
    57b6:	7ea080e7          	jalr	2026(ra) # 5f9c <printf>
      exit(1);
    57ba:	4505                	li	a0,1
    57bc:	00000097          	auipc	ra,0x0
    57c0:	470080e7          	jalr	1136(ra) # 5c2c <exit>
  }

  close(fds[0]);
    57c4:	fc842503          	lw	a0,-56(s0)
    57c8:	00000097          	auipc	ra,0x0
    57cc:	48c080e7          	jalr	1164(ra) # 5c54 <close>
  wait((int*)0);
    57d0:	4501                	li	a0,0
    57d2:	00000097          	auipc	ra,0x0
    57d6:	462080e7          	jalr	1122(ra) # 5c34 <wait>
  
  return n;
}
    57da:	8526                	mv	a0,s1
    57dc:	74a2                	ld	s1,40(sp)
    57de:	70e2                	ld	ra,56(sp)
    57e0:	7442                	ld	s0,48(sp)
    57e2:	6121                	addi	sp,sp,64
    57e4:	8082                	ret

00000000000057e6 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    57e6:	711d                	addi	sp,sp,-96
    57e8:	ec86                	sd	ra,88(sp)
    57ea:	e8a2                	sd	s0,80(sp)
    57ec:	e4a6                	sd	s1,72(sp)
    57ee:	e0ca                	sd	s2,64(sp)
    57f0:	fc4e                	sd	s3,56(sp)
    57f2:	f852                	sd	s4,48(sp)
    57f4:	f456                	sd	s5,40(sp)
    57f6:	f05a                	sd	s6,32(sp)
    57f8:	ec5e                	sd	s7,24(sp)
    57fa:	e862                	sd	s8,16(sp)
    57fc:	e466                	sd	s9,8(sp)
    57fe:	e06a                	sd	s10,0(sp)
    5800:	1080                	addi	s0,sp,96
    5802:	8aaa                	mv	s5,a0
    5804:	892e                	mv	s2,a1
    5806:	89b2                	mv	s3,a2
  do {
    printf("usertests starting\n");
    5808:	00003b97          	auipc	s7,0x3
    580c:	9a8b8b93          	addi	s7,s7,-1624 # 81b0 <malloc+0x215c>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone, continuous)) {
    5810:	00005b17          	auipc	s6,0x5
    5814:	ba0b0b13          	addi	s6,s6,-1120 # a3b0 <quicktests>
      if(continuous != 2) {
    5818:	4a09                	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone, continuous)) {
    581a:	00005c17          	auipc	s8,0x5
    581e:	f66c0c13          	addi	s8,s8,-154 # a780 <slowtests>
        printf("usertests slow tests starting\n");
    5822:	00003d17          	auipc	s10,0x3
    5826:	9a6d0d13          	addi	s10,s10,-1626 # 81c8 <malloc+0x2174>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    582a:	00003c97          	auipc	s9,0x3
    582e:	9bec8c93          	addi	s9,s9,-1602 # 81e8 <malloc+0x2194>
    5832:	a839                	j	5850 <drivetests+0x6a>
        printf("usertests slow tests starting\n");
    5834:	856a                	mv	a0,s10
    5836:	00000097          	auipc	ra,0x0
    583a:	766080e7          	jalr	1894(ra) # 5f9c <printf>
    583e:	a089                	j	5880 <drivetests+0x9a>
    if((free1 = countfree()) < free0) {
    5840:	00000097          	auipc	ra,0x0
    5844:	e68080e7          	jalr	-408(ra) # 56a8 <countfree>
    5848:	04954863          	blt	a0,s1,5898 <drivetests+0xb2>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    584c:	06090363          	beqz	s2,58b2 <drivetests+0xcc>
    printf("usertests starting\n");
    5850:	855e                	mv	a0,s7
    5852:	00000097          	auipc	ra,0x0
    5856:	74a080e7          	jalr	1866(ra) # 5f9c <printf>
    int free0 = countfree();
    585a:	00000097          	auipc	ra,0x0
    585e:	e4e080e7          	jalr	-434(ra) # 56a8 <countfree>
    5862:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone, continuous)) {
    5864:	864a                	mv	a2,s2
    5866:	85ce                	mv	a1,s3
    5868:	855a                	mv	a0,s6
    586a:	00000097          	auipc	ra,0x0
    586e:	dca080e7          	jalr	-566(ra) # 5634 <runtests>
    5872:	c119                	beqz	a0,5878 <drivetests+0x92>
      if(continuous != 2) {
    5874:	03491d63          	bne	s2,s4,58ae <drivetests+0xc8>
    if(!quick) {
    5878:	fc0a94e3          	bnez	s5,5840 <drivetests+0x5a>
      if (justone == 0)
    587c:	fa098ce3          	beqz	s3,5834 <drivetests+0x4e>
      if (runtests(slowtests, justone, continuous)) {
    5880:	864a                	mv	a2,s2
    5882:	85ce                	mv	a1,s3
    5884:	8562                	mv	a0,s8
    5886:	00000097          	auipc	ra,0x0
    588a:	dae080e7          	jalr	-594(ra) # 5634 <runtests>
    588e:	d94d                	beqz	a0,5840 <drivetests+0x5a>
        if(continuous != 2) {
    5890:	fb4908e3          	beq	s2,s4,5840 <drivetests+0x5a>
          return 1;
    5894:	4505                	li	a0,1
    5896:	a839                	j	58b4 <drivetests+0xce>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5898:	8626                	mv	a2,s1
    589a:	85aa                	mv	a1,a0
    589c:	8566                	mv	a0,s9
    589e:	00000097          	auipc	ra,0x0
    58a2:	6fe080e7          	jalr	1790(ra) # 5f9c <printf>
      if(continuous != 2) {
    58a6:	fb4905e3          	beq	s2,s4,5850 <drivetests+0x6a>
        return 1;
    58aa:	4505                	li	a0,1
    58ac:	a021                	j	58b4 <drivetests+0xce>
        return 1;
    58ae:	4505                	li	a0,1
    58b0:	a011                	j	58b4 <drivetests+0xce>
  return 0;
    58b2:	854a                	mv	a0,s2
}
    58b4:	60e6                	ld	ra,88(sp)
    58b6:	6446                	ld	s0,80(sp)
    58b8:	64a6                	ld	s1,72(sp)
    58ba:	6906                	ld	s2,64(sp)
    58bc:	79e2                	ld	s3,56(sp)
    58be:	7a42                	ld	s4,48(sp)
    58c0:	7aa2                	ld	s5,40(sp)
    58c2:	7b02                	ld	s6,32(sp)
    58c4:	6be2                	ld	s7,24(sp)
    58c6:	6c42                	ld	s8,16(sp)
    58c8:	6ca2                	ld	s9,8(sp)
    58ca:	6d02                	ld	s10,0(sp)
    58cc:	6125                	addi	sp,sp,96
    58ce:	8082                	ret

00000000000058d0 <main>:

int
main(int argc, char *argv[])
{
    58d0:	1101                	addi	sp,sp,-32
    58d2:	ec06                	sd	ra,24(sp)
    58d4:	e822                	sd	s0,16(sp)
    58d6:	e426                	sd	s1,8(sp)
    58d8:	e04a                	sd	s2,0(sp)
    58da:	1000                	addi	s0,sp,32
    58dc:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    58de:	4789                	li	a5,2
    58e0:	02f50263          	beq	a0,a5,5904 <main+0x34>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    58e4:	4785                	li	a5,1
    58e6:	08a7c063          	blt	a5,a0,5966 <main+0x96>
  char *justone = 0;
    58ea:	4601                	li	a2,0
  int quick = 0;
    58ec:	4501                	li	a0,0
  int continuous = 0;
    58ee:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    58f0:	00000097          	auipc	ra,0x0
    58f4:	ef6080e7          	jalr	-266(ra) # 57e6 <drivetests>
    58f8:	c951                	beqz	a0,598c <main+0xbc>
    exit(1);
    58fa:	4505                	li	a0,1
    58fc:	00000097          	auipc	ra,0x0
    5900:	330080e7          	jalr	816(ra) # 5c2c <exit>
    5904:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5906:	00003597          	auipc	a1,0x3
    590a:	91258593          	addi	a1,a1,-1774 # 8218 <malloc+0x21c4>
    590e:	00893503          	ld	a0,8(s2)
    5912:	00000097          	auipc	ra,0x0
    5916:	0ca080e7          	jalr	202(ra) # 59dc <strcmp>
    591a:	85aa                	mv	a1,a0
    591c:	e501                	bnez	a0,5924 <main+0x54>
  char *justone = 0;
    591e:	4601                	li	a2,0
    quick = 1;
    5920:	4505                	li	a0,1
    5922:	b7f9                	j	58f0 <main+0x20>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5924:	00003597          	auipc	a1,0x3
    5928:	8fc58593          	addi	a1,a1,-1796 # 8220 <malloc+0x21cc>
    592c:	00893503          	ld	a0,8(s2)
    5930:	00000097          	auipc	ra,0x0
    5934:	0ac080e7          	jalr	172(ra) # 59dc <strcmp>
    5938:	c521                	beqz	a0,5980 <main+0xb0>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    593a:	00003597          	auipc	a1,0x3
    593e:	93658593          	addi	a1,a1,-1738 # 8270 <malloc+0x221c>
    5942:	00893503          	ld	a0,8(s2)
    5946:	00000097          	auipc	ra,0x0
    594a:	096080e7          	jalr	150(ra) # 59dc <strcmp>
    594e:	cd05                	beqz	a0,5986 <main+0xb6>
  } else if(argc == 2 && argv[1][0] != '-'){
    5950:	00893603          	ld	a2,8(s2)
    5954:	00064703          	lbu	a4,0(a2) # 3000 <execout+0x50>
    5958:	02d00793          	li	a5,45
    595c:	00f70563          	beq	a4,a5,5966 <main+0x96>
  int quick = 0;
    5960:	4501                	li	a0,0
  int continuous = 0;
    5962:	4581                	li	a1,0
    5964:	b771                	j	58f0 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    5966:	00003517          	auipc	a0,0x3
    596a:	8c250513          	addi	a0,a0,-1854 # 8228 <malloc+0x21d4>
    596e:	00000097          	auipc	ra,0x0
    5972:	62e080e7          	jalr	1582(ra) # 5f9c <printf>
    exit(1);
    5976:	4505                	li	a0,1
    5978:	00000097          	auipc	ra,0x0
    597c:	2b4080e7          	jalr	692(ra) # 5c2c <exit>
  char *justone = 0;
    5980:	4601                	li	a2,0
    continuous = 1;
    5982:	4585                	li	a1,1
    5984:	b7b5                	j	58f0 <main+0x20>
    continuous = 2;
    5986:	85a6                	mv	a1,s1
  char *justone = 0;
    5988:	4601                	li	a2,0
    598a:	b79d                	j	58f0 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    598c:	00003517          	auipc	a0,0x3
    5990:	8cc50513          	addi	a0,a0,-1844 # 8258 <malloc+0x2204>
    5994:	00000097          	auipc	ra,0x0
    5998:	608080e7          	jalr	1544(ra) # 5f9c <printf>
  exit(0);
    599c:	4501                	li	a0,0
    599e:	00000097          	auipc	ra,0x0
    59a2:	28e080e7          	jalr	654(ra) # 5c2c <exit>

00000000000059a6 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    59a6:	1141                	addi	sp,sp,-16
    59a8:	e406                	sd	ra,8(sp)
    59aa:	e022                	sd	s0,0(sp)
    59ac:	0800                	addi	s0,sp,16
  extern int main();
  main();
    59ae:	00000097          	auipc	ra,0x0
    59b2:	f22080e7          	jalr	-222(ra) # 58d0 <main>
  exit(0);
    59b6:	4501                	li	a0,0
    59b8:	00000097          	auipc	ra,0x0
    59bc:	274080e7          	jalr	628(ra) # 5c2c <exit>

00000000000059c0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    59c0:	1141                	addi	sp,sp,-16
    59c2:	e422                	sd	s0,8(sp)
    59c4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    59c6:	87aa                	mv	a5,a0
    59c8:	0585                	addi	a1,a1,1
    59ca:	0785                	addi	a5,a5,1
    59cc:	fff5c703          	lbu	a4,-1(a1)
    59d0:	fee78fa3          	sb	a4,-1(a5)
    59d4:	fb75                	bnez	a4,59c8 <strcpy+0x8>
    ;
  return os;
}
    59d6:	6422                	ld	s0,8(sp)
    59d8:	0141                	addi	sp,sp,16
    59da:	8082                	ret

00000000000059dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
    59dc:	1141                	addi	sp,sp,-16
    59de:	e422                	sd	s0,8(sp)
    59e0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    59e2:	00054783          	lbu	a5,0(a0)
    59e6:	cb91                	beqz	a5,59fa <strcmp+0x1e>
    59e8:	0005c703          	lbu	a4,0(a1)
    59ec:	00f71763          	bne	a4,a5,59fa <strcmp+0x1e>
    p++, q++;
    59f0:	0505                	addi	a0,a0,1
    59f2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    59f4:	00054783          	lbu	a5,0(a0)
    59f8:	fbe5                	bnez	a5,59e8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    59fa:	0005c503          	lbu	a0,0(a1)
}
    59fe:	40a7853b          	subw	a0,a5,a0
    5a02:	6422                	ld	s0,8(sp)
    5a04:	0141                	addi	sp,sp,16
    5a06:	8082                	ret

0000000000005a08 <strlen>:

uint
strlen(const char *s)
{
    5a08:	1141                	addi	sp,sp,-16
    5a0a:	e422                	sd	s0,8(sp)
    5a0c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5a0e:	00054783          	lbu	a5,0(a0)
    5a12:	cf91                	beqz	a5,5a2e <strlen+0x26>
    5a14:	0505                	addi	a0,a0,1
    5a16:	87aa                	mv	a5,a0
    5a18:	86be                	mv	a3,a5
    5a1a:	0785                	addi	a5,a5,1
    5a1c:	fff7c703          	lbu	a4,-1(a5)
    5a20:	ff65                	bnez	a4,5a18 <strlen+0x10>
    5a22:	40a6853b          	subw	a0,a3,a0
    5a26:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    5a28:	6422                	ld	s0,8(sp)
    5a2a:	0141                	addi	sp,sp,16
    5a2c:	8082                	ret
  for(n = 0; s[n]; n++)
    5a2e:	4501                	li	a0,0
    5a30:	bfe5                	j	5a28 <strlen+0x20>

0000000000005a32 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5a32:	1141                	addi	sp,sp,-16
    5a34:	e422                	sd	s0,8(sp)
    5a36:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5a38:	ca19                	beqz	a2,5a4e <memset+0x1c>
    5a3a:	87aa                	mv	a5,a0
    5a3c:	1602                	slli	a2,a2,0x20
    5a3e:	9201                	srli	a2,a2,0x20
    5a40:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5a44:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5a48:	0785                	addi	a5,a5,1
    5a4a:	fee79de3          	bne	a5,a4,5a44 <memset+0x12>
  }
  return dst;
}
    5a4e:	6422                	ld	s0,8(sp)
    5a50:	0141                	addi	sp,sp,16
    5a52:	8082                	ret

0000000000005a54 <strchr>:

char*
strchr(const char *s, char c)
{
    5a54:	1141                	addi	sp,sp,-16
    5a56:	e422                	sd	s0,8(sp)
    5a58:	0800                	addi	s0,sp,16
  for(; *s; s++)
    5a5a:	00054783          	lbu	a5,0(a0)
    5a5e:	cb99                	beqz	a5,5a74 <strchr+0x20>
    if(*s == c)
    5a60:	00f58763          	beq	a1,a5,5a6e <strchr+0x1a>
  for(; *s; s++)
    5a64:	0505                	addi	a0,a0,1
    5a66:	00054783          	lbu	a5,0(a0)
    5a6a:	fbfd                	bnez	a5,5a60 <strchr+0xc>
      return (char*)s;
  return 0;
    5a6c:	4501                	li	a0,0
}
    5a6e:	6422                	ld	s0,8(sp)
    5a70:	0141                	addi	sp,sp,16
    5a72:	8082                	ret
  return 0;
    5a74:	4501                	li	a0,0
    5a76:	bfe5                	j	5a6e <strchr+0x1a>

0000000000005a78 <gets>:

char*
gets(char *buf, int max)
{
    5a78:	711d                	addi	sp,sp,-96
    5a7a:	ec86                	sd	ra,88(sp)
    5a7c:	e8a2                	sd	s0,80(sp)
    5a7e:	e4a6                	sd	s1,72(sp)
    5a80:	e0ca                	sd	s2,64(sp)
    5a82:	fc4e                	sd	s3,56(sp)
    5a84:	f852                	sd	s4,48(sp)
    5a86:	f456                	sd	s5,40(sp)
    5a88:	f05a                	sd	s6,32(sp)
    5a8a:	ec5e                	sd	s7,24(sp)
    5a8c:	1080                	addi	s0,sp,96
    5a8e:	8baa                	mv	s7,a0
    5a90:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5a92:	892a                	mv	s2,a0
    5a94:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5a96:	4aa9                	li	s5,10
    5a98:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5a9a:	89a6                	mv	s3,s1
    5a9c:	2485                	addiw	s1,s1,1
    5a9e:	0344d863          	bge	s1,s4,5ace <gets+0x56>
    cc = read(0, &c, 1);
    5aa2:	4605                	li	a2,1
    5aa4:	faf40593          	addi	a1,s0,-81
    5aa8:	4501                	li	a0,0
    5aaa:	00000097          	auipc	ra,0x0
    5aae:	19a080e7          	jalr	410(ra) # 5c44 <read>
    if(cc < 1)
    5ab2:	00a05e63          	blez	a0,5ace <gets+0x56>
    buf[i++] = c;
    5ab6:	faf44783          	lbu	a5,-81(s0)
    5aba:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5abe:	01578763          	beq	a5,s5,5acc <gets+0x54>
    5ac2:	0905                	addi	s2,s2,1
    5ac4:	fd679be3          	bne	a5,s6,5a9a <gets+0x22>
    buf[i++] = c;
    5ac8:	89a6                	mv	s3,s1
    5aca:	a011                	j	5ace <gets+0x56>
    5acc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5ace:	99de                	add	s3,s3,s7
    5ad0:	00098023          	sb	zero,0(s3)
  return buf;
}
    5ad4:	855e                	mv	a0,s7
    5ad6:	60e6                	ld	ra,88(sp)
    5ad8:	6446                	ld	s0,80(sp)
    5ada:	64a6                	ld	s1,72(sp)
    5adc:	6906                	ld	s2,64(sp)
    5ade:	79e2                	ld	s3,56(sp)
    5ae0:	7a42                	ld	s4,48(sp)
    5ae2:	7aa2                	ld	s5,40(sp)
    5ae4:	7b02                	ld	s6,32(sp)
    5ae6:	6be2                	ld	s7,24(sp)
    5ae8:	6125                	addi	sp,sp,96
    5aea:	8082                	ret

0000000000005aec <stat>:

int
stat(const char *n, struct stat *st)
{
    5aec:	1101                	addi	sp,sp,-32
    5aee:	ec06                	sd	ra,24(sp)
    5af0:	e822                	sd	s0,16(sp)
    5af2:	e04a                	sd	s2,0(sp)
    5af4:	1000                	addi	s0,sp,32
    5af6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5af8:	4581                	li	a1,0
    5afa:	00000097          	auipc	ra,0x0
    5afe:	172080e7          	jalr	370(ra) # 5c6c <open>
  if(fd < 0)
    5b02:	02054663          	bltz	a0,5b2e <stat+0x42>
    5b06:	e426                	sd	s1,8(sp)
    5b08:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5b0a:	85ca                	mv	a1,s2
    5b0c:	00000097          	auipc	ra,0x0
    5b10:	178080e7          	jalr	376(ra) # 5c84 <fstat>
    5b14:	892a                	mv	s2,a0
  close(fd);
    5b16:	8526                	mv	a0,s1
    5b18:	00000097          	auipc	ra,0x0
    5b1c:	13c080e7          	jalr	316(ra) # 5c54 <close>
  return r;
    5b20:	64a2                	ld	s1,8(sp)
}
    5b22:	854a                	mv	a0,s2
    5b24:	60e2                	ld	ra,24(sp)
    5b26:	6442                	ld	s0,16(sp)
    5b28:	6902                	ld	s2,0(sp)
    5b2a:	6105                	addi	sp,sp,32
    5b2c:	8082                	ret
    return -1;
    5b2e:	597d                	li	s2,-1
    5b30:	bfcd                	j	5b22 <stat+0x36>

0000000000005b32 <atoi>:

int
atoi(const char *s)
{
    5b32:	1141                	addi	sp,sp,-16
    5b34:	e422                	sd	s0,8(sp)
    5b36:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5b38:	00054683          	lbu	a3,0(a0)
    5b3c:	fd06879b          	addiw	a5,a3,-48
    5b40:	0ff7f793          	zext.b	a5,a5
    5b44:	4625                	li	a2,9
    5b46:	02f66863          	bltu	a2,a5,5b76 <atoi+0x44>
    5b4a:	872a                	mv	a4,a0
  n = 0;
    5b4c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    5b4e:	0705                	addi	a4,a4,1
    5b50:	0025179b          	slliw	a5,a0,0x2
    5b54:	9fa9                	addw	a5,a5,a0
    5b56:	0017979b          	slliw	a5,a5,0x1
    5b5a:	9fb5                	addw	a5,a5,a3
    5b5c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5b60:	00074683          	lbu	a3,0(a4)
    5b64:	fd06879b          	addiw	a5,a3,-48
    5b68:	0ff7f793          	zext.b	a5,a5
    5b6c:	fef671e3          	bgeu	a2,a5,5b4e <atoi+0x1c>
  return n;
}
    5b70:	6422                	ld	s0,8(sp)
    5b72:	0141                	addi	sp,sp,16
    5b74:	8082                	ret
  n = 0;
    5b76:	4501                	li	a0,0
    5b78:	bfe5                	j	5b70 <atoi+0x3e>

0000000000005b7a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5b7a:	1141                	addi	sp,sp,-16
    5b7c:	e422                	sd	s0,8(sp)
    5b7e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5b80:	02b57463          	bgeu	a0,a1,5ba8 <memmove+0x2e>
    while(n-- > 0)
    5b84:	00c05f63          	blez	a2,5ba2 <memmove+0x28>
    5b88:	1602                	slli	a2,a2,0x20
    5b8a:	9201                	srli	a2,a2,0x20
    5b8c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5b90:	872a                	mv	a4,a0
      *dst++ = *src++;
    5b92:	0585                	addi	a1,a1,1
    5b94:	0705                	addi	a4,a4,1
    5b96:	fff5c683          	lbu	a3,-1(a1)
    5b9a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5b9e:	fef71ae3          	bne	a4,a5,5b92 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5ba2:	6422                	ld	s0,8(sp)
    5ba4:	0141                	addi	sp,sp,16
    5ba6:	8082                	ret
    dst += n;
    5ba8:	00c50733          	add	a4,a0,a2
    src += n;
    5bac:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5bae:	fec05ae3          	blez	a2,5ba2 <memmove+0x28>
    5bb2:	fff6079b          	addiw	a5,a2,-1
    5bb6:	1782                	slli	a5,a5,0x20
    5bb8:	9381                	srli	a5,a5,0x20
    5bba:	fff7c793          	not	a5,a5
    5bbe:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5bc0:	15fd                	addi	a1,a1,-1
    5bc2:	177d                	addi	a4,a4,-1
    5bc4:	0005c683          	lbu	a3,0(a1)
    5bc8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5bcc:	fee79ae3          	bne	a5,a4,5bc0 <memmove+0x46>
    5bd0:	bfc9                	j	5ba2 <memmove+0x28>

0000000000005bd2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5bd2:	1141                	addi	sp,sp,-16
    5bd4:	e422                	sd	s0,8(sp)
    5bd6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5bd8:	ca05                	beqz	a2,5c08 <memcmp+0x36>
    5bda:	fff6069b          	addiw	a3,a2,-1
    5bde:	1682                	slli	a3,a3,0x20
    5be0:	9281                	srli	a3,a3,0x20
    5be2:	0685                	addi	a3,a3,1
    5be4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5be6:	00054783          	lbu	a5,0(a0)
    5bea:	0005c703          	lbu	a4,0(a1)
    5bee:	00e79863          	bne	a5,a4,5bfe <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5bf2:	0505                	addi	a0,a0,1
    p2++;
    5bf4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5bf6:	fed518e3          	bne	a0,a3,5be6 <memcmp+0x14>
  }
  return 0;
    5bfa:	4501                	li	a0,0
    5bfc:	a019                	j	5c02 <memcmp+0x30>
      return *p1 - *p2;
    5bfe:	40e7853b          	subw	a0,a5,a4
}
    5c02:	6422                	ld	s0,8(sp)
    5c04:	0141                	addi	sp,sp,16
    5c06:	8082                	ret
  return 0;
    5c08:	4501                	li	a0,0
    5c0a:	bfe5                	j	5c02 <memcmp+0x30>

0000000000005c0c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5c0c:	1141                	addi	sp,sp,-16
    5c0e:	e406                	sd	ra,8(sp)
    5c10:	e022                	sd	s0,0(sp)
    5c12:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5c14:	00000097          	auipc	ra,0x0
    5c18:	f66080e7          	jalr	-154(ra) # 5b7a <memmove>
}
    5c1c:	60a2                	ld	ra,8(sp)
    5c1e:	6402                	ld	s0,0(sp)
    5c20:	0141                	addi	sp,sp,16
    5c22:	8082                	ret

0000000000005c24 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5c24:	4885                	li	a7,1
 ecall
    5c26:	00000073          	ecall
 ret
    5c2a:	8082                	ret

0000000000005c2c <exit>:
.global exit
exit:
 li a7, SYS_exit
    5c2c:	4889                	li	a7,2
 ecall
    5c2e:	00000073          	ecall
 ret
    5c32:	8082                	ret

0000000000005c34 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5c34:	488d                	li	a7,3
 ecall
    5c36:	00000073          	ecall
 ret
    5c3a:	8082                	ret

0000000000005c3c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5c3c:	4891                	li	a7,4
 ecall
    5c3e:	00000073          	ecall
 ret
    5c42:	8082                	ret

0000000000005c44 <read>:
.global read
read:
 li a7, SYS_read
    5c44:	4895                	li	a7,5
 ecall
    5c46:	00000073          	ecall
 ret
    5c4a:	8082                	ret

0000000000005c4c <write>:
.global write
write:
 li a7, SYS_write
    5c4c:	48c1                	li	a7,16
 ecall
    5c4e:	00000073          	ecall
 ret
    5c52:	8082                	ret

0000000000005c54 <close>:
.global close
close:
 li a7, SYS_close
    5c54:	48d5                	li	a7,21
 ecall
    5c56:	00000073          	ecall
 ret
    5c5a:	8082                	ret

0000000000005c5c <kill>:
.global kill
kill:
 li a7, SYS_kill
    5c5c:	4899                	li	a7,6
 ecall
    5c5e:	00000073          	ecall
 ret
    5c62:	8082                	ret

0000000000005c64 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5c64:	489d                	li	a7,7
 ecall
    5c66:	00000073          	ecall
 ret
    5c6a:	8082                	ret

0000000000005c6c <open>:
.global open
open:
 li a7, SYS_open
    5c6c:	48bd                	li	a7,15
 ecall
    5c6e:	00000073          	ecall
 ret
    5c72:	8082                	ret

0000000000005c74 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5c74:	48c5                	li	a7,17
 ecall
    5c76:	00000073          	ecall
 ret
    5c7a:	8082                	ret

0000000000005c7c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5c7c:	48c9                	li	a7,18
 ecall
    5c7e:	00000073          	ecall
 ret
    5c82:	8082                	ret

0000000000005c84 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5c84:	48a1                	li	a7,8
 ecall
    5c86:	00000073          	ecall
 ret
    5c8a:	8082                	ret

0000000000005c8c <link>:
.global link
link:
 li a7, SYS_link
    5c8c:	48cd                	li	a7,19
 ecall
    5c8e:	00000073          	ecall
 ret
    5c92:	8082                	ret

0000000000005c94 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5c94:	48d1                	li	a7,20
 ecall
    5c96:	00000073          	ecall
 ret
    5c9a:	8082                	ret

0000000000005c9c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5c9c:	48a5                	li	a7,9
 ecall
    5c9e:	00000073          	ecall
 ret
    5ca2:	8082                	ret

0000000000005ca4 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5ca4:	48a9                	li	a7,10
 ecall
    5ca6:	00000073          	ecall
 ret
    5caa:	8082                	ret

0000000000005cac <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5cac:	48ad                	li	a7,11
 ecall
    5cae:	00000073          	ecall
 ret
    5cb2:	8082                	ret

0000000000005cb4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5cb4:	48b1                	li	a7,12
 ecall
    5cb6:	00000073          	ecall
 ret
    5cba:	8082                	ret

0000000000005cbc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5cbc:	48b5                	li	a7,13
 ecall
    5cbe:	00000073          	ecall
 ret
    5cc2:	8082                	ret

0000000000005cc4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5cc4:	48b9                	li	a7,14
 ecall
    5cc6:	00000073          	ecall
 ret
    5cca:	8082                	ret

0000000000005ccc <cowstats>:
.global cowstats
cowstats:
 li a7, SYS_cowstats
    5ccc:	48d9                	li	a7,22
 ecall
    5cce:	00000073          	ecall
 ret
    5cd2:	8082                	ret

0000000000005cd4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5cd4:	1101                	addi	sp,sp,-32
    5cd6:	ec06                	sd	ra,24(sp)
    5cd8:	e822                	sd	s0,16(sp)
    5cda:	1000                	addi	s0,sp,32
    5cdc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5ce0:	4605                	li	a2,1
    5ce2:	fef40593          	addi	a1,s0,-17
    5ce6:	00000097          	auipc	ra,0x0
    5cea:	f66080e7          	jalr	-154(ra) # 5c4c <write>
}
    5cee:	60e2                	ld	ra,24(sp)
    5cf0:	6442                	ld	s0,16(sp)
    5cf2:	6105                	addi	sp,sp,32
    5cf4:	8082                	ret

0000000000005cf6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5cf6:	7139                	addi	sp,sp,-64
    5cf8:	fc06                	sd	ra,56(sp)
    5cfa:	f822                	sd	s0,48(sp)
    5cfc:	f426                	sd	s1,40(sp)
    5cfe:	0080                	addi	s0,sp,64
    5d00:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5d02:	c299                	beqz	a3,5d08 <printint+0x12>
    5d04:	0805cb63          	bltz	a1,5d9a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5d08:	2581                	sext.w	a1,a1
  neg = 0;
    5d0a:	4881                	li	a7,0
    5d0c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5d10:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5d12:	2601                	sext.w	a2,a2
    5d14:	00003517          	auipc	a0,0x3
    5d18:	92450513          	addi	a0,a0,-1756 # 8638 <digits>
    5d1c:	883a                	mv	a6,a4
    5d1e:	2705                	addiw	a4,a4,1
    5d20:	02c5f7bb          	remuw	a5,a1,a2
    5d24:	1782                	slli	a5,a5,0x20
    5d26:	9381                	srli	a5,a5,0x20
    5d28:	97aa                	add	a5,a5,a0
    5d2a:	0007c783          	lbu	a5,0(a5)
    5d2e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5d32:	0005879b          	sext.w	a5,a1
    5d36:	02c5d5bb          	divuw	a1,a1,a2
    5d3a:	0685                	addi	a3,a3,1
    5d3c:	fec7f0e3          	bgeu	a5,a2,5d1c <printint+0x26>
  if(neg)
    5d40:	00088c63          	beqz	a7,5d58 <printint+0x62>
    buf[i++] = '-';
    5d44:	fd070793          	addi	a5,a4,-48
    5d48:	00878733          	add	a4,a5,s0
    5d4c:	02d00793          	li	a5,45
    5d50:	fef70823          	sb	a5,-16(a4)
    5d54:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5d58:	02e05c63          	blez	a4,5d90 <printint+0x9a>
    5d5c:	f04a                	sd	s2,32(sp)
    5d5e:	ec4e                	sd	s3,24(sp)
    5d60:	fc040793          	addi	a5,s0,-64
    5d64:	00e78933          	add	s2,a5,a4
    5d68:	fff78993          	addi	s3,a5,-1
    5d6c:	99ba                	add	s3,s3,a4
    5d6e:	377d                	addiw	a4,a4,-1
    5d70:	1702                	slli	a4,a4,0x20
    5d72:	9301                	srli	a4,a4,0x20
    5d74:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5d78:	fff94583          	lbu	a1,-1(s2)
    5d7c:	8526                	mv	a0,s1
    5d7e:	00000097          	auipc	ra,0x0
    5d82:	f56080e7          	jalr	-170(ra) # 5cd4 <putc>
  while(--i >= 0)
    5d86:	197d                	addi	s2,s2,-1
    5d88:	ff3918e3          	bne	s2,s3,5d78 <printint+0x82>
    5d8c:	7902                	ld	s2,32(sp)
    5d8e:	69e2                	ld	s3,24(sp)
}
    5d90:	70e2                	ld	ra,56(sp)
    5d92:	7442                	ld	s0,48(sp)
    5d94:	74a2                	ld	s1,40(sp)
    5d96:	6121                	addi	sp,sp,64
    5d98:	8082                	ret
    x = -xx;
    5d9a:	40b005bb          	negw	a1,a1
    neg = 1;
    5d9e:	4885                	li	a7,1
    x = -xx;
    5da0:	b7b5                	j	5d0c <printint+0x16>

0000000000005da2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5da2:	715d                	addi	sp,sp,-80
    5da4:	e486                	sd	ra,72(sp)
    5da6:	e0a2                	sd	s0,64(sp)
    5da8:	f84a                	sd	s2,48(sp)
    5daa:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5dac:	0005c903          	lbu	s2,0(a1)
    5db0:	1a090a63          	beqz	s2,5f64 <vprintf+0x1c2>
    5db4:	fc26                	sd	s1,56(sp)
    5db6:	f44e                	sd	s3,40(sp)
    5db8:	f052                	sd	s4,32(sp)
    5dba:	ec56                	sd	s5,24(sp)
    5dbc:	e85a                	sd	s6,16(sp)
    5dbe:	e45e                	sd	s7,8(sp)
    5dc0:	8aaa                	mv	s5,a0
    5dc2:	8bb2                	mv	s7,a2
    5dc4:	00158493          	addi	s1,a1,1
  state = 0;
    5dc8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5dca:	02500a13          	li	s4,37
    5dce:	4b55                	li	s6,21
    5dd0:	a839                	j	5dee <vprintf+0x4c>
        putc(fd, c);
    5dd2:	85ca                	mv	a1,s2
    5dd4:	8556                	mv	a0,s5
    5dd6:	00000097          	auipc	ra,0x0
    5dda:	efe080e7          	jalr	-258(ra) # 5cd4 <putc>
    5dde:	a019                	j	5de4 <vprintf+0x42>
    } else if(state == '%'){
    5de0:	01498d63          	beq	s3,s4,5dfa <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    5de4:	0485                	addi	s1,s1,1
    5de6:	fff4c903          	lbu	s2,-1(s1)
    5dea:	16090763          	beqz	s2,5f58 <vprintf+0x1b6>
    if(state == 0){
    5dee:	fe0999e3          	bnez	s3,5de0 <vprintf+0x3e>
      if(c == '%'){
    5df2:	ff4910e3          	bne	s2,s4,5dd2 <vprintf+0x30>
        state = '%';
    5df6:	89d2                	mv	s3,s4
    5df8:	b7f5                	j	5de4 <vprintf+0x42>
      if(c == 'd'){
    5dfa:	13490463          	beq	s2,s4,5f22 <vprintf+0x180>
    5dfe:	f9d9079b          	addiw	a5,s2,-99
    5e02:	0ff7f793          	zext.b	a5,a5
    5e06:	12fb6763          	bltu	s6,a5,5f34 <vprintf+0x192>
    5e0a:	f9d9079b          	addiw	a5,s2,-99
    5e0e:	0ff7f713          	zext.b	a4,a5
    5e12:	12eb6163          	bltu	s6,a4,5f34 <vprintf+0x192>
    5e16:	00271793          	slli	a5,a4,0x2
    5e1a:	00002717          	auipc	a4,0x2
    5e1e:	7c670713          	addi	a4,a4,1990 # 85e0 <malloc+0x258c>
    5e22:	97ba                	add	a5,a5,a4
    5e24:	439c                	lw	a5,0(a5)
    5e26:	97ba                	add	a5,a5,a4
    5e28:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5e2a:	008b8913          	addi	s2,s7,8
    5e2e:	4685                	li	a3,1
    5e30:	4629                	li	a2,10
    5e32:	000ba583          	lw	a1,0(s7)
    5e36:	8556                	mv	a0,s5
    5e38:	00000097          	auipc	ra,0x0
    5e3c:	ebe080e7          	jalr	-322(ra) # 5cf6 <printint>
    5e40:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5e42:	4981                	li	s3,0
    5e44:	b745                	j	5de4 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5e46:	008b8913          	addi	s2,s7,8
    5e4a:	4681                	li	a3,0
    5e4c:	4629                	li	a2,10
    5e4e:	000ba583          	lw	a1,0(s7)
    5e52:	8556                	mv	a0,s5
    5e54:	00000097          	auipc	ra,0x0
    5e58:	ea2080e7          	jalr	-350(ra) # 5cf6 <printint>
    5e5c:	8bca                	mv	s7,s2
      state = 0;
    5e5e:	4981                	li	s3,0
    5e60:	b751                	j	5de4 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    5e62:	008b8913          	addi	s2,s7,8
    5e66:	4681                	li	a3,0
    5e68:	4641                	li	a2,16
    5e6a:	000ba583          	lw	a1,0(s7)
    5e6e:	8556                	mv	a0,s5
    5e70:	00000097          	auipc	ra,0x0
    5e74:	e86080e7          	jalr	-378(ra) # 5cf6 <printint>
    5e78:	8bca                	mv	s7,s2
      state = 0;
    5e7a:	4981                	li	s3,0
    5e7c:	b7a5                	j	5de4 <vprintf+0x42>
    5e7e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    5e80:	008b8c13          	addi	s8,s7,8
    5e84:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5e88:	03000593          	li	a1,48
    5e8c:	8556                	mv	a0,s5
    5e8e:	00000097          	auipc	ra,0x0
    5e92:	e46080e7          	jalr	-442(ra) # 5cd4 <putc>
  putc(fd, 'x');
    5e96:	07800593          	li	a1,120
    5e9a:	8556                	mv	a0,s5
    5e9c:	00000097          	auipc	ra,0x0
    5ea0:	e38080e7          	jalr	-456(ra) # 5cd4 <putc>
    5ea4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5ea6:	00002b97          	auipc	s7,0x2
    5eaa:	792b8b93          	addi	s7,s7,1938 # 8638 <digits>
    5eae:	03c9d793          	srli	a5,s3,0x3c
    5eb2:	97de                	add	a5,a5,s7
    5eb4:	0007c583          	lbu	a1,0(a5)
    5eb8:	8556                	mv	a0,s5
    5eba:	00000097          	auipc	ra,0x0
    5ebe:	e1a080e7          	jalr	-486(ra) # 5cd4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5ec2:	0992                	slli	s3,s3,0x4
    5ec4:	397d                	addiw	s2,s2,-1
    5ec6:	fe0914e3          	bnez	s2,5eae <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    5eca:	8be2                	mv	s7,s8
      state = 0;
    5ecc:	4981                	li	s3,0
    5ece:	6c02                	ld	s8,0(sp)
    5ed0:	bf11                	j	5de4 <vprintf+0x42>
        s = va_arg(ap, char*);
    5ed2:	008b8993          	addi	s3,s7,8
    5ed6:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    5eda:	02090163          	beqz	s2,5efc <vprintf+0x15a>
        while(*s != 0){
    5ede:	00094583          	lbu	a1,0(s2)
    5ee2:	c9a5                	beqz	a1,5f52 <vprintf+0x1b0>
          putc(fd, *s);
    5ee4:	8556                	mv	a0,s5
    5ee6:	00000097          	auipc	ra,0x0
    5eea:	dee080e7          	jalr	-530(ra) # 5cd4 <putc>
          s++;
    5eee:	0905                	addi	s2,s2,1
        while(*s != 0){
    5ef0:	00094583          	lbu	a1,0(s2)
    5ef4:	f9e5                	bnez	a1,5ee4 <vprintf+0x142>
        s = va_arg(ap, char*);
    5ef6:	8bce                	mv	s7,s3
      state = 0;
    5ef8:	4981                	li	s3,0
    5efa:	b5ed                	j	5de4 <vprintf+0x42>
          s = "(null)";
    5efc:	00002917          	auipc	s2,0x2
    5f00:	6bc90913          	addi	s2,s2,1724 # 85b8 <malloc+0x2564>
        while(*s != 0){
    5f04:	02800593          	li	a1,40
    5f08:	bff1                	j	5ee4 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    5f0a:	008b8913          	addi	s2,s7,8
    5f0e:	000bc583          	lbu	a1,0(s7)
    5f12:	8556                	mv	a0,s5
    5f14:	00000097          	auipc	ra,0x0
    5f18:	dc0080e7          	jalr	-576(ra) # 5cd4 <putc>
    5f1c:	8bca                	mv	s7,s2
      state = 0;
    5f1e:	4981                	li	s3,0
    5f20:	b5d1                	j	5de4 <vprintf+0x42>
        putc(fd, c);
    5f22:	02500593          	li	a1,37
    5f26:	8556                	mv	a0,s5
    5f28:	00000097          	auipc	ra,0x0
    5f2c:	dac080e7          	jalr	-596(ra) # 5cd4 <putc>
      state = 0;
    5f30:	4981                	li	s3,0
    5f32:	bd4d                	j	5de4 <vprintf+0x42>
        putc(fd, '%');
    5f34:	02500593          	li	a1,37
    5f38:	8556                	mv	a0,s5
    5f3a:	00000097          	auipc	ra,0x0
    5f3e:	d9a080e7          	jalr	-614(ra) # 5cd4 <putc>
        putc(fd, c);
    5f42:	85ca                	mv	a1,s2
    5f44:	8556                	mv	a0,s5
    5f46:	00000097          	auipc	ra,0x0
    5f4a:	d8e080e7          	jalr	-626(ra) # 5cd4 <putc>
      state = 0;
    5f4e:	4981                	li	s3,0
    5f50:	bd51                	j	5de4 <vprintf+0x42>
        s = va_arg(ap, char*);
    5f52:	8bce                	mv	s7,s3
      state = 0;
    5f54:	4981                	li	s3,0
    5f56:	b579                	j	5de4 <vprintf+0x42>
    5f58:	74e2                	ld	s1,56(sp)
    5f5a:	79a2                	ld	s3,40(sp)
    5f5c:	7a02                	ld	s4,32(sp)
    5f5e:	6ae2                	ld	s5,24(sp)
    5f60:	6b42                	ld	s6,16(sp)
    5f62:	6ba2                	ld	s7,8(sp)
    }
  }
}
    5f64:	60a6                	ld	ra,72(sp)
    5f66:	6406                	ld	s0,64(sp)
    5f68:	7942                	ld	s2,48(sp)
    5f6a:	6161                	addi	sp,sp,80
    5f6c:	8082                	ret

0000000000005f6e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5f6e:	715d                	addi	sp,sp,-80
    5f70:	ec06                	sd	ra,24(sp)
    5f72:	e822                	sd	s0,16(sp)
    5f74:	1000                	addi	s0,sp,32
    5f76:	e010                	sd	a2,0(s0)
    5f78:	e414                	sd	a3,8(s0)
    5f7a:	e818                	sd	a4,16(s0)
    5f7c:	ec1c                	sd	a5,24(s0)
    5f7e:	03043023          	sd	a6,32(s0)
    5f82:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5f86:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5f8a:	8622                	mv	a2,s0
    5f8c:	00000097          	auipc	ra,0x0
    5f90:	e16080e7          	jalr	-490(ra) # 5da2 <vprintf>
}
    5f94:	60e2                	ld	ra,24(sp)
    5f96:	6442                	ld	s0,16(sp)
    5f98:	6161                	addi	sp,sp,80
    5f9a:	8082                	ret

0000000000005f9c <printf>:

void
printf(const char *fmt, ...)
{
    5f9c:	711d                	addi	sp,sp,-96
    5f9e:	ec06                	sd	ra,24(sp)
    5fa0:	e822                	sd	s0,16(sp)
    5fa2:	1000                	addi	s0,sp,32
    5fa4:	e40c                	sd	a1,8(s0)
    5fa6:	e810                	sd	a2,16(s0)
    5fa8:	ec14                	sd	a3,24(s0)
    5faa:	f018                	sd	a4,32(s0)
    5fac:	f41c                	sd	a5,40(s0)
    5fae:	03043823          	sd	a6,48(s0)
    5fb2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5fb6:	00840613          	addi	a2,s0,8
    5fba:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5fbe:	85aa                	mv	a1,a0
    5fc0:	4505                	li	a0,1
    5fc2:	00000097          	auipc	ra,0x0
    5fc6:	de0080e7          	jalr	-544(ra) # 5da2 <vprintf>
}
    5fca:	60e2                	ld	ra,24(sp)
    5fcc:	6442                	ld	s0,16(sp)
    5fce:	6125                	addi	sp,sp,96
    5fd0:	8082                	ret

0000000000005fd2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5fd2:	1141                	addi	sp,sp,-16
    5fd4:	e422                	sd	s0,8(sp)
    5fd6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5fd8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5fdc:	00005797          	auipc	a5,0x5
    5fe0:	8147b783          	ld	a5,-2028(a5) # a7f0 <freep>
    5fe4:	a02d                	j	600e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5fe6:	4618                	lw	a4,8(a2)
    5fe8:	9f2d                	addw	a4,a4,a1
    5fea:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5fee:	6398                	ld	a4,0(a5)
    5ff0:	6310                	ld	a2,0(a4)
    5ff2:	a83d                	j	6030 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5ff4:	ff852703          	lw	a4,-8(a0)
    5ff8:	9f31                	addw	a4,a4,a2
    5ffa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5ffc:	ff053683          	ld	a3,-16(a0)
    6000:	a091                	j	6044 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6002:	6398                	ld	a4,0(a5)
    6004:	00e7e463          	bltu	a5,a4,600c <free+0x3a>
    6008:	00e6ea63          	bltu	a3,a4,601c <free+0x4a>
{
    600c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    600e:	fed7fae3          	bgeu	a5,a3,6002 <free+0x30>
    6012:	6398                	ld	a4,0(a5)
    6014:	00e6e463          	bltu	a3,a4,601c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6018:	fee7eae3          	bltu	a5,a4,600c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    601c:	ff852583          	lw	a1,-8(a0)
    6020:	6390                	ld	a2,0(a5)
    6022:	02059813          	slli	a6,a1,0x20
    6026:	01c85713          	srli	a4,a6,0x1c
    602a:	9736                	add	a4,a4,a3
    602c:	fae60de3          	beq	a2,a4,5fe6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    6030:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    6034:	4790                	lw	a2,8(a5)
    6036:	02061593          	slli	a1,a2,0x20
    603a:	01c5d713          	srli	a4,a1,0x1c
    603e:	973e                	add	a4,a4,a5
    6040:	fae68ae3          	beq	a3,a4,5ff4 <free+0x22>
    p->s.ptr = bp->s.ptr;
    6044:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    6046:	00004717          	auipc	a4,0x4
    604a:	7af73523          	sd	a5,1962(a4) # a7f0 <freep>
}
    604e:	6422                	ld	s0,8(sp)
    6050:	0141                	addi	sp,sp,16
    6052:	8082                	ret

0000000000006054 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    6054:	7139                	addi	sp,sp,-64
    6056:	fc06                	sd	ra,56(sp)
    6058:	f822                	sd	s0,48(sp)
    605a:	f426                	sd	s1,40(sp)
    605c:	ec4e                	sd	s3,24(sp)
    605e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    6060:	02051493          	slli	s1,a0,0x20
    6064:	9081                	srli	s1,s1,0x20
    6066:	04bd                	addi	s1,s1,15
    6068:	8091                	srli	s1,s1,0x4
    606a:	0014899b          	addiw	s3,s1,1
    606e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    6070:	00004517          	auipc	a0,0x4
    6074:	78053503          	ld	a0,1920(a0) # a7f0 <freep>
    6078:	c915                	beqz	a0,60ac <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    607a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    607c:	4798                	lw	a4,8(a5)
    607e:	08977e63          	bgeu	a4,s1,611a <malloc+0xc6>
    6082:	f04a                	sd	s2,32(sp)
    6084:	e852                	sd	s4,16(sp)
    6086:	e456                	sd	s5,8(sp)
    6088:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    608a:	8a4e                	mv	s4,s3
    608c:	0009871b          	sext.w	a4,s3
    6090:	6685                	lui	a3,0x1
    6092:	00d77363          	bgeu	a4,a3,6098 <malloc+0x44>
    6096:	6a05                	lui	s4,0x1
    6098:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    609c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    60a0:	00004917          	auipc	s2,0x4
    60a4:	75090913          	addi	s2,s2,1872 # a7f0 <freep>
  if(p == (char*)-1)
    60a8:	5afd                	li	s5,-1
    60aa:	a091                	j	60ee <malloc+0x9a>
    60ac:	f04a                	sd	s2,32(sp)
    60ae:	e852                	sd	s4,16(sp)
    60b0:	e456                	sd	s5,8(sp)
    60b2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    60b4:	0000b797          	auipc	a5,0xb
    60b8:	f6478793          	addi	a5,a5,-156 # 11018 <base>
    60bc:	00004717          	auipc	a4,0x4
    60c0:	72f73a23          	sd	a5,1844(a4) # a7f0 <freep>
    60c4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    60c6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    60ca:	b7c1                	j	608a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    60cc:	6398                	ld	a4,0(a5)
    60ce:	e118                	sd	a4,0(a0)
    60d0:	a08d                	j	6132 <malloc+0xde>
  hp->s.size = nu;
    60d2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    60d6:	0541                	addi	a0,a0,16
    60d8:	00000097          	auipc	ra,0x0
    60dc:	efa080e7          	jalr	-262(ra) # 5fd2 <free>
  return freep;
    60e0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    60e4:	c13d                	beqz	a0,614a <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    60e6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    60e8:	4798                	lw	a4,8(a5)
    60ea:	02977463          	bgeu	a4,s1,6112 <malloc+0xbe>
    if(p == freep)
    60ee:	00093703          	ld	a4,0(s2)
    60f2:	853e                	mv	a0,a5
    60f4:	fef719e3          	bne	a4,a5,60e6 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
    60f8:	8552                	mv	a0,s4
    60fa:	00000097          	auipc	ra,0x0
    60fe:	bba080e7          	jalr	-1094(ra) # 5cb4 <sbrk>
  if(p == (char*)-1)
    6102:	fd5518e3          	bne	a0,s5,60d2 <malloc+0x7e>
        return 0;
    6106:	4501                	li	a0,0
    6108:	7902                	ld	s2,32(sp)
    610a:	6a42                	ld	s4,16(sp)
    610c:	6aa2                	ld	s5,8(sp)
    610e:	6b02                	ld	s6,0(sp)
    6110:	a03d                	j	613e <malloc+0xea>
    6112:	7902                	ld	s2,32(sp)
    6114:	6a42                	ld	s4,16(sp)
    6116:	6aa2                	ld	s5,8(sp)
    6118:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    611a:	fae489e3          	beq	s1,a4,60cc <malloc+0x78>
        p->s.size -= nunits;
    611e:	4137073b          	subw	a4,a4,s3
    6122:	c798                	sw	a4,8(a5)
        p += p->s.size;
    6124:	02071693          	slli	a3,a4,0x20
    6128:	01c6d713          	srli	a4,a3,0x1c
    612c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    612e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    6132:	00004717          	auipc	a4,0x4
    6136:	6aa73f23          	sd	a0,1726(a4) # a7f0 <freep>
      return (void*)(p + 1);
    613a:	01078513          	addi	a0,a5,16
  }
}
    613e:	70e2                	ld	ra,56(sp)
    6140:	7442                	ld	s0,48(sp)
    6142:	74a2                	ld	s1,40(sp)
    6144:	69e2                	ld	s3,24(sp)
    6146:	6121                	addi	sp,sp,64
    6148:	8082                	ret
    614a:	7902                	ld	s2,32(sp)
    614c:	6a42                	ld	s4,16(sp)
    614e:	6aa2                	ld	s5,8(sp)
    6150:	6b02                	ld	s6,0(sp)
    6152:	b7f5                	j	613e <malloc+0xea>
