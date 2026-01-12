
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	4c013103          	ld	sp,1216(sp) # 8000b4c0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	5b9050ef          	jal	80005dce <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7179                	addi	sp,sp,-48
    8000001e:	f406                	sd	ra,40(sp)
    80000020:	f022                	sd	s0,32(sp)
    80000022:	ec26                	sd	s1,24(sp)
    80000024:	e84a                	sd	s2,16(sp)
    80000026:	e44e                	sd	s3,8(sp)
    80000028:	1800                	addi	s0,sp,48
  struct run *r;
  int idx;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000002a:	03451793          	slli	a5,a0,0x34
    8000002e:	efbd                	bnez	a5,800000ac <kfree+0x90>
    80000030:	892a                	mv	s2,a0
    80000032:	00045797          	auipc	a5,0x45
    80000036:	96e78793          	addi	a5,a5,-1682 # 800449a0 <end>
    8000003a:	06f56963          	bltu	a0,a5,800000ac <kfree+0x90>
    8000003e:	47c5                	li	a5,17
    80000040:	07ee                	slli	a5,a5,0x1b
    80000042:	06f57563          	bgeu	a0,a5,800000ac <kfree+0x90>
    panic("kfree");

  idx = PA2IDX((uint64)pa);
    80000046:	800004b7          	lui	s1,0x80000
    8000004a:	94aa                	add	s1,s1,a0
    8000004c:	80b1                	srli	s1,s1,0xc
    8000004e:	2481                	sext.w	s1,s1
  if(idx < 0 || idx >= (PHYSTOP - KERNBASE) / PGSIZE)
    80000050:	67a1                	lui	a5,0x8
    80000052:	06f4f563          	bgeu	s1,a5,800000bc <kfree+0xa0>
    panic("kfree: bad idx");

  acquire(&refcount.lock);
    80000056:	0000b517          	auipc	a0,0xb
    8000005a:	4da50513          	addi	a0,a0,1242 # 8000b530 <refcount>
    8000005e:	00006097          	auipc	ra,0x6
    80000062:	7be080e7          	jalr	1982(ra) # 8000681c <acquire>
  if(refcount.refcount[idx] <= 0) {
    80000066:	00448713          	addi	a4,s1,4 # ffffffff80000004 <end+0xfffffffefffbb664>
    8000006a:	070a                	slli	a4,a4,0x2
    8000006c:	0000b797          	auipc	a5,0xb
    80000070:	4c478793          	addi	a5,a5,1220 # 8000b530 <refcount>
    80000074:	97ba                	add	a5,a5,a4
    80000076:	479c                	lw	a5,8(a5)
    80000078:	04f05a63          	blez	a5,800000cc <kfree+0xb0>
    release(&refcount.lock);
    panic("kfree: refcount");
  }
  refcount.refcount[idx]--;
    8000007c:	37fd                	addiw	a5,a5,-1
    8000007e:	0007899b          	sext.w	s3,a5
    80000082:	0000b517          	auipc	a0,0xb
    80000086:	4ae50513          	addi	a0,a0,1198 # 8000b530 <refcount>
    8000008a:	0491                	addi	s1,s1,4
    8000008c:	048a                	slli	s1,s1,0x2
    8000008e:	94aa                	add	s1,s1,a0
    80000090:	c49c                	sw	a5,8(s1)
  int rc = refcount.refcount[idx];
  release(&refcount.lock);
    80000092:	00007097          	auipc	ra,0x7
    80000096:	83e080e7          	jalr	-1986(ra) # 800068d0 <release>

  // Only free the page if refcount reaches 0
  if(rc > 0)
    8000009a:	05305963          	blez	s3,800000ec <kfree+0xd0>

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}
    8000009e:	70a2                	ld	ra,40(sp)
    800000a0:	7402                	ld	s0,32(sp)
    800000a2:	64e2                	ld	s1,24(sp)
    800000a4:	6942                	ld	s2,16(sp)
    800000a6:	69a2                	ld	s3,8(sp)
    800000a8:	6145                	addi	sp,sp,48
    800000aa:	8082                	ret
    panic("kfree");
    800000ac:	00008517          	auipc	a0,0x8
    800000b0:	f5450513          	addi	a0,a0,-172 # 80008000 <etext>
    800000b4:	00006097          	auipc	ra,0x6
    800000b8:	1ee080e7          	jalr	494(ra) # 800062a2 <panic>
    panic("kfree: bad idx");
    800000bc:	00008517          	auipc	a0,0x8
    800000c0:	f5450513          	addi	a0,a0,-172 # 80008010 <etext+0x10>
    800000c4:	00006097          	auipc	ra,0x6
    800000c8:	1de080e7          	jalr	478(ra) # 800062a2 <panic>
    release(&refcount.lock);
    800000cc:	0000b517          	auipc	a0,0xb
    800000d0:	46450513          	addi	a0,a0,1124 # 8000b530 <refcount>
    800000d4:	00006097          	auipc	ra,0x6
    800000d8:	7fc080e7          	jalr	2044(ra) # 800068d0 <release>
    panic("kfree: refcount");
    800000dc:	00008517          	auipc	a0,0x8
    800000e0:	f4450513          	addi	a0,a0,-188 # 80008020 <etext+0x20>
    800000e4:	00006097          	auipc	ra,0x6
    800000e8:	1be080e7          	jalr	446(ra) # 800062a2 <panic>
  memset(pa, 1, PGSIZE);
    800000ec:	6605                	lui	a2,0x1
    800000ee:	4585                	li	a1,1
    800000f0:	854a                	mv	a0,s2
    800000f2:	00000097          	auipc	ra,0x0
    800000f6:	2d2080e7          	jalr	722(ra) # 800003c4 <memset>
  acquire(&kmem.lock);
    800000fa:	0000b497          	auipc	s1,0xb
    800000fe:	41648493          	addi	s1,s1,1046 # 8000b510 <kmem>
    80000102:	8526                	mv	a0,s1
    80000104:	00006097          	auipc	ra,0x6
    80000108:	718080e7          	jalr	1816(ra) # 8000681c <acquire>
  r->next = kmem.freelist;
    8000010c:	6c9c                	ld	a5,24(s1)
    8000010e:	00f93023          	sd	a5,0(s2)
  kmem.freelist = r;
    80000112:	0124bc23          	sd	s2,24(s1)
  release(&kmem.lock);
    80000116:	8526                	mv	a0,s1
    80000118:	00006097          	auipc	ra,0x6
    8000011c:	7b8080e7          	jalr	1976(ra) # 800068d0 <release>
    80000120:	bfbd                	j	8000009e <kfree+0x82>

0000000080000122 <freerange>:
{
    80000122:	711d                	addi	sp,sp,-96
    80000124:	ec86                	sd	ra,88(sp)
    80000126:	e8a2                	sd	s0,80(sp)
    80000128:	e0ca                	sd	s2,64(sp)
    8000012a:	1080                	addi	s0,sp,96
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000012c:	6785                	lui	a5,0x1
    8000012e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000132:	00e50933          	add	s2,a0,a4
    80000136:	777d                	lui	a4,0xfffff
    80000138:	00e97933          	and	s2,s2,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    8000013c:	993e                	add	s2,s2,a5
    8000013e:	0925e463          	bltu	a1,s2,800001c6 <freerange+0xa4>
    80000142:	e4a6                	sd	s1,72(sp)
    80000144:	fc4e                	sd	s3,56(sp)
    80000146:	f852                	sd	s4,48(sp)
    80000148:	f456                	sd	s5,40(sp)
    8000014a:	f05a                	sd	s6,32(sp)
    8000014c:	ec5e                	sd	s7,24(sp)
    8000014e:	e862                	sd	s8,16(sp)
    80000150:	e466                	sd	s9,8(sp)
    80000152:	e06a                	sd	s10,0(sp)
    80000154:	8aae                	mv	s5,a1
    80000156:	7c7d                	lui	s8,0xfffff
    idx = PA2IDX((uint64)p);
    80000158:	fff80a37          	lui	s4,0xfff80
    8000015c:	1a7d                	addi	s4,s4,-1 # fffffffffff7ffff <end+0xffffffff7ff3b65f>
    8000015e:	0a32                	slli	s4,s4,0xc
    if(idx >= 0 && idx < (PHYSTOP - KERNBASE) / PGSIZE) {
    80000160:	6ba1                	lui	s7,0x8
      acquire(&refcount.lock);
    80000162:	0000bc97          	auipc	s9,0xb
    80000166:	3cec8c93          	addi	s9,s9,974 # 8000b530 <refcount>
      refcount.refcount[idx] = 1;
    8000016a:	4d05                	li	s10,1
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    8000016c:	6b05                	lui	s6,0x1
    8000016e:	a809                	j	80000180 <freerange+0x5e>
    kfree(p);
    80000170:	854e                	mv	a0,s3
    80000172:	00000097          	auipc	ra,0x0
    80000176:	eaa080e7          	jalr	-342(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    8000017a:	995a                	add	s2,s2,s6
    8000017c:	032aec63          	bltu	s5,s2,800001b4 <freerange+0x92>
    80000180:	018909b3          	add	s3,s2,s8
    idx = PA2IDX((uint64)p);
    80000184:	014904b3          	add	s1,s2,s4
    80000188:	80b1                	srli	s1,s1,0xc
    if(idx >= 0 && idx < (PHYSTOP - KERNBASE) / PGSIZE) {
    8000018a:	0004879b          	sext.w	a5,s1
    8000018e:	ff77f1e3          	bgeu	a5,s7,80000170 <freerange+0x4e>
      acquire(&refcount.lock);
    80000192:	8566                	mv	a0,s9
    80000194:	00006097          	auipc	ra,0x6
    80000198:	688080e7          	jalr	1672(ra) # 8000681c <acquire>
      refcount.refcount[idx] = 1;
    8000019c:	2481                	sext.w	s1,s1
    8000019e:	0491                	addi	s1,s1,4
    800001a0:	048a                	slli	s1,s1,0x2
    800001a2:	94e6                	add	s1,s1,s9
    800001a4:	01a4a423          	sw	s10,8(s1)
      release(&refcount.lock);
    800001a8:	8566                	mv	a0,s9
    800001aa:	00006097          	auipc	ra,0x6
    800001ae:	726080e7          	jalr	1830(ra) # 800068d0 <release>
    800001b2:	bf7d                	j	80000170 <freerange+0x4e>
    800001b4:	64a6                	ld	s1,72(sp)
    800001b6:	79e2                	ld	s3,56(sp)
    800001b8:	7a42                	ld	s4,48(sp)
    800001ba:	7aa2                	ld	s5,40(sp)
    800001bc:	7b02                	ld	s6,32(sp)
    800001be:	6be2                	ld	s7,24(sp)
    800001c0:	6c42                	ld	s8,16(sp)
    800001c2:	6ca2                	ld	s9,8(sp)
    800001c4:	6d02                	ld	s10,0(sp)
}
    800001c6:	60e6                	ld	ra,88(sp)
    800001c8:	6446                	ld	s0,80(sp)
    800001ca:	6906                	ld	s2,64(sp)
    800001cc:	6125                	addi	sp,sp,96
    800001ce:	8082                	ret

00000000800001d0 <kinit>:
{
    800001d0:	1141                	addi	sp,sp,-16
    800001d2:	e406                	sd	ra,8(sp)
    800001d4:	e022                	sd	s0,0(sp)
    800001d6:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800001d8:	00008597          	auipc	a1,0x8
    800001dc:	e5858593          	addi	a1,a1,-424 # 80008030 <etext+0x30>
    800001e0:	0000b517          	auipc	a0,0xb
    800001e4:	33050513          	addi	a0,a0,816 # 8000b510 <kmem>
    800001e8:	00006097          	auipc	ra,0x6
    800001ec:	5a4080e7          	jalr	1444(ra) # 8000678c <initlock>
  initlock(&refcount.lock, "refcount");
    800001f0:	00008597          	auipc	a1,0x8
    800001f4:	e4858593          	addi	a1,a1,-440 # 80008038 <etext+0x38>
    800001f8:	0000b517          	auipc	a0,0xb
    800001fc:	33850513          	addi	a0,a0,824 # 8000b530 <refcount>
    80000200:	00006097          	auipc	ra,0x6
    80000204:	58c080e7          	jalr	1420(ra) # 8000678c <initlock>
  for(int i = 0; i < (PHYSTOP - KERNBASE) / PGSIZE; i++) {
    80000208:	0000b797          	auipc	a5,0xb
    8000020c:	34078793          	addi	a5,a5,832 # 8000b548 <refcount+0x18>
    80000210:	0002b717          	auipc	a4,0x2b
    80000214:	33870713          	addi	a4,a4,824 # 8002b548 <pid_lock>
    refcount.refcount[i] = 0;
    80000218:	0007a023          	sw	zero,0(a5)
  for(int i = 0; i < (PHYSTOP - KERNBASE) / PGSIZE; i++) {
    8000021c:	0791                	addi	a5,a5,4
    8000021e:	fee79de3          	bne	a5,a4,80000218 <kinit+0x48>
  freerange(end, (void*)PHYSTOP);
    80000222:	45c5                	li	a1,17
    80000224:	05ee                	slli	a1,a1,0x1b
    80000226:	00044517          	auipc	a0,0x44
    8000022a:	77a50513          	addi	a0,a0,1914 # 800449a0 <end>
    8000022e:	00000097          	auipc	ra,0x0
    80000232:	ef4080e7          	jalr	-268(ra) # 80000122 <freerange>
}
    80000236:	60a2                	ld	ra,8(sp)
    80000238:	6402                	ld	s0,0(sp)
    8000023a:	0141                	addi	sp,sp,16
    8000023c:	8082                	ret

000000008000023e <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000023e:	1101                	addi	sp,sp,-32
    80000240:	ec06                	sd	ra,24(sp)
    80000242:	e822                	sd	s0,16(sp)
    80000244:	e426                	sd	s1,8(sp)
    80000246:	e04a                	sd	s2,0(sp)
    80000248:	1000                	addi	s0,sp,32
  struct run *r;
  int idx;

  acquire(&kmem.lock);
    8000024a:	0000b497          	auipc	s1,0xb
    8000024e:	2c648493          	addi	s1,s1,710 # 8000b510 <kmem>
    80000252:	8526                	mv	a0,s1
    80000254:	00006097          	auipc	ra,0x6
    80000258:	5c8080e7          	jalr	1480(ra) # 8000681c <acquire>
  r = kmem.freelist;
    8000025c:	0184b903          	ld	s2,24(s1)
  if(r)
    80000260:	06090963          	beqz	s2,800002d2 <kalloc+0x94>
    kmem.freelist = r->next;
    80000264:	00093783          	ld	a5,0(s2)
    80000268:	8526                	mv	a0,s1
    8000026a:	ec9c                	sd	a5,24(s1)
  release(&kmem.lock);
    8000026c:	00006097          	auipc	ra,0x6
    80000270:	664080e7          	jalr	1636(ra) # 800068d0 <release>

  if(r) {
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000274:	6605                	lui	a2,0x1
    80000276:	4595                	li	a1,5
    80000278:	854a                	mv	a0,s2
    8000027a:	00000097          	auipc	ra,0x0
    8000027e:	14a080e7          	jalr	330(ra) # 800003c4 <memset>
    idx = PA2IDX((uint64)r);
    80000282:	800004b7          	lui	s1,0x80000
    80000286:	94ca                	add	s1,s1,s2
    80000288:	80b1                	srli	s1,s1,0xc
    if(idx >= 0 && idx < (PHYSTOP - KERNBASE) / PGSIZE) {
    8000028a:	0004871b          	sext.w	a4,s1
    8000028e:	67a1                	lui	a5,0x8
    80000290:	00f76963          	bltu	a4,a5,800002a2 <kalloc+0x64>
      refcount.refcount[idx] = 1;
      release(&refcount.lock);
    }
  }
  return (void*)r;
}
    80000294:	854a                	mv	a0,s2
    80000296:	60e2                	ld	ra,24(sp)
    80000298:	6442                	ld	s0,16(sp)
    8000029a:	64a2                	ld	s1,8(sp)
    8000029c:	6902                	ld	s2,0(sp)
    8000029e:	6105                	addi	sp,sp,32
    800002a0:	8082                	ret
      acquire(&refcount.lock);
    800002a2:	0000b517          	auipc	a0,0xb
    800002a6:	28e50513          	addi	a0,a0,654 # 8000b530 <refcount>
    800002aa:	00006097          	auipc	ra,0x6
    800002ae:	572080e7          	jalr	1394(ra) # 8000681c <acquire>
      refcount.refcount[idx] = 1;
    800002b2:	0000b517          	auipc	a0,0xb
    800002b6:	27e50513          	addi	a0,a0,638 # 8000b530 <refcount>
    800002ba:	0004879b          	sext.w	a5,s1
    800002be:	0791                	addi	a5,a5,4 # 8004 <_entry-0x7fff7ffc>
    800002c0:	078a                	slli	a5,a5,0x2
    800002c2:	97aa                	add	a5,a5,a0
    800002c4:	4705                	li	a4,1
    800002c6:	c798                	sw	a4,8(a5)
      release(&refcount.lock);
    800002c8:	00006097          	auipc	ra,0x6
    800002cc:	608080e7          	jalr	1544(ra) # 800068d0 <release>
  return (void*)r;
    800002d0:	b7d1                	j	80000294 <kalloc+0x56>
  release(&kmem.lock);
    800002d2:	0000b517          	auipc	a0,0xb
    800002d6:	23e50513          	addi	a0,a0,574 # 8000b510 <kmem>
    800002da:	00006097          	auipc	ra,0x6
    800002de:	5f6080e7          	jalr	1526(ra) # 800068d0 <release>
  if(r) {
    800002e2:	bf4d                	j	80000294 <kalloc+0x56>

00000000800002e4 <krefinc>:

// Increment reference count for a physical page
void
krefinc(void *pa)
{
    800002e4:	1101                	addi	sp,sp,-32
    800002e6:	ec06                	sd	ra,24(sp)
    800002e8:	e822                	sd	s0,16(sp)
    800002ea:	e426                	sd	s1,8(sp)
    800002ec:	1000                	addi	s0,sp,32
  int idx;
  
  if((uint64)pa < KERNBASE || (uint64)pa >= PHYSTOP)
    800002ee:	800007b7          	lui	a5,0x80000
    800002f2:	953e                	add	a0,a0,a5
    800002f4:	080007b7          	lui	a5,0x8000
    800002f8:	04f57a63          	bgeu	a0,a5,8000034c <krefinc+0x68>
    panic("krefinc: bad pa");
    
  idx = PA2IDX((uint64)pa);
    800002fc:	8131                	srli	a0,a0,0xc
    800002fe:	0005049b          	sext.w	s1,a0
  if(idx < 0 || idx >= (PHYSTOP - KERNBASE) / PGSIZE)
    panic("krefinc: bad idx");
    
  acquire(&refcount.lock);
    80000302:	0000b517          	auipc	a0,0xb
    80000306:	22e50513          	addi	a0,a0,558 # 8000b530 <refcount>
    8000030a:	00006097          	auipc	ra,0x6
    8000030e:	512080e7          	jalr	1298(ra) # 8000681c <acquire>
  if(refcount.refcount[idx] < 1)
    80000312:	00448713          	addi	a4,s1,4 # ffffffff80000004 <end+0xfffffffefffbb664>
    80000316:	070a                	slli	a4,a4,0x2
    80000318:	0000b797          	auipc	a5,0xb
    8000031c:	21878793          	addi	a5,a5,536 # 8000b530 <refcount>
    80000320:	97ba                	add	a5,a5,a4
    80000322:	479c                	lw	a5,8(a5)
    80000324:	02f05c63          	blez	a5,8000035c <krefinc+0x78>
    panic("krefinc: refcount");
  refcount.refcount[idx]++;
    80000328:	0000b517          	auipc	a0,0xb
    8000032c:	20850513          	addi	a0,a0,520 # 8000b530 <refcount>
    80000330:	0491                	addi	s1,s1,4
    80000332:	048a                	slli	s1,s1,0x2
    80000334:	94aa                	add	s1,s1,a0
    80000336:	2785                	addiw	a5,a5,1
    80000338:	c49c                	sw	a5,8(s1)
  release(&refcount.lock);
    8000033a:	00006097          	auipc	ra,0x6
    8000033e:	596080e7          	jalr	1430(ra) # 800068d0 <release>
}
    80000342:	60e2                	ld	ra,24(sp)
    80000344:	6442                	ld	s0,16(sp)
    80000346:	64a2                	ld	s1,8(sp)
    80000348:	6105                	addi	sp,sp,32
    8000034a:	8082                	ret
    panic("krefinc: bad pa");
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cfc50513          	addi	a0,a0,-772 # 80008048 <etext+0x48>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	f4e080e7          	jalr	-178(ra) # 800062a2 <panic>
    panic("krefinc: refcount");
    8000035c:	00008517          	auipc	a0,0x8
    80000360:	cfc50513          	addi	a0,a0,-772 # 80008058 <etext+0x58>
    80000364:	00006097          	auipc	ra,0x6
    80000368:	f3e080e7          	jalr	-194(ra) # 800062a2 <panic>

000000008000036c <krefcount>:

// Get reference count for a physical page
int
krefcount(void *pa)
{
    8000036c:	1101                	addi	sp,sp,-32
    8000036e:	ec06                	sd	ra,24(sp)
    80000370:	e822                	sd	s0,16(sp)
    80000372:	e426                	sd	s1,8(sp)
    80000374:	1000                	addi	s0,sp,32
  int idx, rc;
  
  if((uint64)pa < KERNBASE || (uint64)pa >= PHYSTOP)
    80000376:	800007b7          	lui	a5,0x80000
    8000037a:	00f504b3          	add	s1,a0,a5
    8000037e:	080007b7          	lui	a5,0x8000
    80000382:	02f4ff63          	bgeu	s1,a5,800003c0 <krefcount+0x54>
    
  idx = PA2IDX((uint64)pa);
  if(idx < 0 || idx >= (PHYSTOP - KERNBASE) / PGSIZE)
    return 0;
    
  acquire(&refcount.lock);
    80000386:	0000b517          	auipc	a0,0xb
    8000038a:	1aa50513          	addi	a0,a0,426 # 8000b530 <refcount>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	48e080e7          	jalr	1166(ra) # 8000681c <acquire>
  rc = refcount.refcount[idx];
    80000396:	0000b517          	auipc	a0,0xb
    8000039a:	19a50513          	addi	a0,a0,410 # 8000b530 <refcount>
  idx = PA2IDX((uint64)pa);
    8000039e:	00c4d793          	srli	a5,s1,0xc
  rc = refcount.refcount[idx];
    800003a2:	2781                	sext.w	a5,a5
    800003a4:	0791                	addi	a5,a5,4 # 8000004 <_entry-0x77fffffc>
    800003a6:	078a                	slli	a5,a5,0x2
    800003a8:	97aa                	add	a5,a5,a0
    800003aa:	4784                	lw	s1,8(a5)
  release(&refcount.lock);
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	524080e7          	jalr	1316(ra) # 800068d0 <release>
  
  return rc;
}
    800003b4:	8526                	mv	a0,s1
    800003b6:	60e2                	ld	ra,24(sp)
    800003b8:	6442                	ld	s0,16(sp)
    800003ba:	64a2                	ld	s1,8(sp)
    800003bc:	6105                	addi	sp,sp,32
    800003be:	8082                	ret
    return 0;
    800003c0:	4481                	li	s1,0
    800003c2:	bfcd                	j	800003b4 <krefcount+0x48>

00000000800003c4 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800003c4:	1141                	addi	sp,sp,-16
    800003c6:	e422                	sd	s0,8(sp)
    800003c8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800003ca:	ca19                	beqz	a2,800003e0 <memset+0x1c>
    800003cc:	87aa                	mv	a5,a0
    800003ce:	1602                	slli	a2,a2,0x20
    800003d0:	9201                	srli	a2,a2,0x20
    800003d2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800003d6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800003da:	0785                	addi	a5,a5,1
    800003dc:	fee79de3          	bne	a5,a4,800003d6 <memset+0x12>
  }
  return dst;
}
    800003e0:	6422                	ld	s0,8(sp)
    800003e2:	0141                	addi	sp,sp,16
    800003e4:	8082                	ret

00000000800003e6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800003e6:	1141                	addi	sp,sp,-16
    800003e8:	e422                	sd	s0,8(sp)
    800003ea:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800003ec:	ca05                	beqz	a2,8000041c <memcmp+0x36>
    800003ee:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800003f2:	1682                	slli	a3,a3,0x20
    800003f4:	9281                	srli	a3,a3,0x20
    800003f6:	0685                	addi	a3,a3,1
    800003f8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800003fa:	00054783          	lbu	a5,0(a0)
    800003fe:	0005c703          	lbu	a4,0(a1)
    80000402:	00e79863          	bne	a5,a4,80000412 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000406:	0505                	addi	a0,a0,1
    80000408:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000040a:	fed518e3          	bne	a0,a3,800003fa <memcmp+0x14>
  }

  return 0;
    8000040e:	4501                	li	a0,0
    80000410:	a019                	j	80000416 <memcmp+0x30>
      return *s1 - *s2;
    80000412:	40e7853b          	subw	a0,a5,a4
}
    80000416:	6422                	ld	s0,8(sp)
    80000418:	0141                	addi	sp,sp,16
    8000041a:	8082                	ret
  return 0;
    8000041c:	4501                	li	a0,0
    8000041e:	bfe5                	j	80000416 <memcmp+0x30>

0000000080000420 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000420:	1141                	addi	sp,sp,-16
    80000422:	e422                	sd	s0,8(sp)
    80000424:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000426:	c205                	beqz	a2,80000446 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000428:	02a5e263          	bltu	a1,a0,8000044c <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000042c:	1602                	slli	a2,a2,0x20
    8000042e:	9201                	srli	a2,a2,0x20
    80000430:	00c587b3          	add	a5,a1,a2
{
    80000434:	872a                	mv	a4,a0
      *d++ = *s++;
    80000436:	0585                	addi	a1,a1,1
    80000438:	0705                	addi	a4,a4,1
    8000043a:	fff5c683          	lbu	a3,-1(a1)
    8000043e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000442:	feb79ae3          	bne	a5,a1,80000436 <memmove+0x16>

  return dst;
}
    80000446:	6422                	ld	s0,8(sp)
    80000448:	0141                	addi	sp,sp,16
    8000044a:	8082                	ret
  if(s < d && s + n > d){
    8000044c:	02061693          	slli	a3,a2,0x20
    80000450:	9281                	srli	a3,a3,0x20
    80000452:	00d58733          	add	a4,a1,a3
    80000456:	fce57be3          	bgeu	a0,a4,8000042c <memmove+0xc>
    d += n;
    8000045a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000045c:	fff6079b          	addiw	a5,a2,-1
    80000460:	1782                	slli	a5,a5,0x20
    80000462:	9381                	srli	a5,a5,0x20
    80000464:	fff7c793          	not	a5,a5
    80000468:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000046a:	177d                	addi	a4,a4,-1
    8000046c:	16fd                	addi	a3,a3,-1
    8000046e:	00074603          	lbu	a2,0(a4)
    80000472:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000476:	fef71ae3          	bne	a4,a5,8000046a <memmove+0x4a>
    8000047a:	b7f1                	j	80000446 <memmove+0x26>

000000008000047c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000047c:	1141                	addi	sp,sp,-16
    8000047e:	e406                	sd	ra,8(sp)
    80000480:	e022                	sd	s0,0(sp)
    80000482:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000484:	00000097          	auipc	ra,0x0
    80000488:	f9c080e7          	jalr	-100(ra) # 80000420 <memmove>
}
    8000048c:	60a2                	ld	ra,8(sp)
    8000048e:	6402                	ld	s0,0(sp)
    80000490:	0141                	addi	sp,sp,16
    80000492:	8082                	ret

0000000080000494 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000494:	1141                	addi	sp,sp,-16
    80000496:	e422                	sd	s0,8(sp)
    80000498:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000049a:	ce11                	beqz	a2,800004b6 <strncmp+0x22>
    8000049c:	00054783          	lbu	a5,0(a0)
    800004a0:	cf89                	beqz	a5,800004ba <strncmp+0x26>
    800004a2:	0005c703          	lbu	a4,0(a1)
    800004a6:	00f71a63          	bne	a4,a5,800004ba <strncmp+0x26>
    n--, p++, q++;
    800004aa:	367d                	addiw	a2,a2,-1
    800004ac:	0505                	addi	a0,a0,1
    800004ae:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800004b0:	f675                	bnez	a2,8000049c <strncmp+0x8>
  if(n == 0)
    return 0;
    800004b2:	4501                	li	a0,0
    800004b4:	a801                	j	800004c4 <strncmp+0x30>
    800004b6:	4501                	li	a0,0
    800004b8:	a031                	j	800004c4 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    800004ba:	00054503          	lbu	a0,0(a0)
    800004be:	0005c783          	lbu	a5,0(a1)
    800004c2:	9d1d                	subw	a0,a0,a5
}
    800004c4:	6422                	ld	s0,8(sp)
    800004c6:	0141                	addi	sp,sp,16
    800004c8:	8082                	ret

00000000800004ca <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800004ca:	1141                	addi	sp,sp,-16
    800004cc:	e422                	sd	s0,8(sp)
    800004ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800004d0:	87aa                	mv	a5,a0
    800004d2:	86b2                	mv	a3,a2
    800004d4:	367d                	addiw	a2,a2,-1
    800004d6:	02d05563          	blez	a3,80000500 <strncpy+0x36>
    800004da:	0785                	addi	a5,a5,1
    800004dc:	0005c703          	lbu	a4,0(a1)
    800004e0:	fee78fa3          	sb	a4,-1(a5)
    800004e4:	0585                	addi	a1,a1,1
    800004e6:	f775                	bnez	a4,800004d2 <strncpy+0x8>
    ;
  while(n-- > 0)
    800004e8:	873e                	mv	a4,a5
    800004ea:	9fb5                	addw	a5,a5,a3
    800004ec:	37fd                	addiw	a5,a5,-1
    800004ee:	00c05963          	blez	a2,80000500 <strncpy+0x36>
    *s++ = 0;
    800004f2:	0705                	addi	a4,a4,1
    800004f4:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800004f8:	40e786bb          	subw	a3,a5,a4
    800004fc:	fed04be3          	bgtz	a3,800004f2 <strncpy+0x28>
  return os;
}
    80000500:	6422                	ld	s0,8(sp)
    80000502:	0141                	addi	sp,sp,16
    80000504:	8082                	ret

0000000080000506 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000506:	1141                	addi	sp,sp,-16
    80000508:	e422                	sd	s0,8(sp)
    8000050a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000050c:	02c05363          	blez	a2,80000532 <safestrcpy+0x2c>
    80000510:	fff6069b          	addiw	a3,a2,-1
    80000514:	1682                	slli	a3,a3,0x20
    80000516:	9281                	srli	a3,a3,0x20
    80000518:	96ae                	add	a3,a3,a1
    8000051a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000051c:	00d58963          	beq	a1,a3,8000052e <safestrcpy+0x28>
    80000520:	0585                	addi	a1,a1,1
    80000522:	0785                	addi	a5,a5,1
    80000524:	fff5c703          	lbu	a4,-1(a1)
    80000528:	fee78fa3          	sb	a4,-1(a5)
    8000052c:	fb65                	bnez	a4,8000051c <safestrcpy+0x16>
    ;
  *s = 0;
    8000052e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000532:	6422                	ld	s0,8(sp)
    80000534:	0141                	addi	sp,sp,16
    80000536:	8082                	ret

0000000080000538 <strlen>:

int
strlen(const char *s)
{
    80000538:	1141                	addi	sp,sp,-16
    8000053a:	e422                	sd	s0,8(sp)
    8000053c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000053e:	00054783          	lbu	a5,0(a0)
    80000542:	cf91                	beqz	a5,8000055e <strlen+0x26>
    80000544:	0505                	addi	a0,a0,1
    80000546:	87aa                	mv	a5,a0
    80000548:	86be                	mv	a3,a5
    8000054a:	0785                	addi	a5,a5,1
    8000054c:	fff7c703          	lbu	a4,-1(a5)
    80000550:	ff65                	bnez	a4,80000548 <strlen+0x10>
    80000552:	40a6853b          	subw	a0,a3,a0
    80000556:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000558:	6422                	ld	s0,8(sp)
    8000055a:	0141                	addi	sp,sp,16
    8000055c:	8082                	ret
  for(n = 0; s[n]; n++)
    8000055e:	4501                	li	a0,0
    80000560:	bfe5                	j	80000558 <strlen+0x20>

0000000080000562 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000562:	1141                	addi	sp,sp,-16
    80000564:	e406                	sd	ra,8(sp)
    80000566:	e022                	sd	s0,0(sp)
    80000568:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000056a:	00001097          	auipc	ra,0x1
    8000056e:	d24080e7          	jalr	-732(ra) # 8000128e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000572:	0000b717          	auipc	a4,0xb
    80000576:	f6e70713          	addi	a4,a4,-146 # 8000b4e0 <started>
  if(cpuid() == 0){
    8000057a:	c139                	beqz	a0,800005c0 <main+0x5e>
    while(started == 0)
    8000057c:	431c                	lw	a5,0(a4)
    8000057e:	2781                	sext.w	a5,a5
    80000580:	dff5                	beqz	a5,8000057c <main+0x1a>
      ;
    __sync_synchronize();
    80000582:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000586:	00001097          	auipc	ra,0x1
    8000058a:	d08080e7          	jalr	-760(ra) # 8000128e <cpuid>
    8000058e:	85aa                	mv	a1,a0
    80000590:	00008517          	auipc	a0,0x8
    80000594:	b0050513          	addi	a0,a0,-1280 # 80008090 <etext+0x90>
    80000598:	00006097          	auipc	ra,0x6
    8000059c:	d54080e7          	jalr	-684(ra) # 800062ec <printf>
    kvminithart();    // turn on paging
    800005a0:	00000097          	auipc	ra,0x0
    800005a4:	0d8080e7          	jalr	216(ra) # 80000678 <kvminithart>
    trapinithart();   // install kernel trap vector
    800005a8:	00002097          	auipc	ra,0x2
    800005ac:	9b6080e7          	jalr	-1610(ra) # 80001f5e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800005b0:	00005097          	auipc	ra,0x5
    800005b4:	194080e7          	jalr	404(ra) # 80005744 <plicinithart>
  }

  scheduler();        
    800005b8:	00001097          	auipc	ra,0x1
    800005bc:	1fe080e7          	jalr	510(ra) # 800017b6 <scheduler>
    consoleinit();
    800005c0:	00006097          	auipc	ra,0x6
    800005c4:	bf2080e7          	jalr	-1038(ra) # 800061b2 <consoleinit>
    printfinit();
    800005c8:	00006097          	auipc	ra,0x6
    800005cc:	f2c080e7          	jalr	-212(ra) # 800064f4 <printfinit>
    printf("\n");
    800005d0:	00008517          	auipc	a0,0x8
    800005d4:	aa050513          	addi	a0,a0,-1376 # 80008070 <etext+0x70>
    800005d8:	00006097          	auipc	ra,0x6
    800005dc:	d14080e7          	jalr	-748(ra) # 800062ec <printf>
    printf("xv6 kernel is booting\n");
    800005e0:	00008517          	auipc	a0,0x8
    800005e4:	a9850513          	addi	a0,a0,-1384 # 80008078 <etext+0x78>
    800005e8:	00006097          	auipc	ra,0x6
    800005ec:	d04080e7          	jalr	-764(ra) # 800062ec <printf>
    printf("\n");
    800005f0:	00008517          	auipc	a0,0x8
    800005f4:	a8050513          	addi	a0,a0,-1408 # 80008070 <etext+0x70>
    800005f8:	00006097          	auipc	ra,0x6
    800005fc:	cf4080e7          	jalr	-780(ra) # 800062ec <printf>
    kinit();         // physical page allocator
    80000600:	00000097          	auipc	ra,0x0
    80000604:	bd0080e7          	jalr	-1072(ra) # 800001d0 <kinit>
    kvminit();       // create kernel page table
    80000608:	00000097          	auipc	ra,0x0
    8000060c:	34a080e7          	jalr	842(ra) # 80000952 <kvminit>
    kvminithart();   // turn on paging
    80000610:	00000097          	auipc	ra,0x0
    80000614:	068080e7          	jalr	104(ra) # 80000678 <kvminithart>
    procinit();      // process table
    80000618:	00001097          	auipc	ra,0x1
    8000061c:	bb4080e7          	jalr	-1100(ra) # 800011cc <procinit>
    trapinit();      // trap vectors
    80000620:	00002097          	auipc	ra,0x2
    80000624:	916080e7          	jalr	-1770(ra) # 80001f36 <trapinit>
    trapinithart();  // install kernel trap vector
    80000628:	00002097          	auipc	ra,0x2
    8000062c:	936080e7          	jalr	-1738(ra) # 80001f5e <trapinithart>
    plicinit();      // set up interrupt controller
    80000630:	00005097          	auipc	ra,0x5
    80000634:	0fa080e7          	jalr	250(ra) # 8000572a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000638:	00005097          	auipc	ra,0x5
    8000063c:	10c080e7          	jalr	268(ra) # 80005744 <plicinithart>
    binit();         // buffer cache
    80000640:	00002097          	auipc	ra,0x2
    80000644:	1cc080e7          	jalr	460(ra) # 8000280c <binit>
    iinit();         // inode table
    80000648:	00003097          	auipc	ra,0x3
    8000064c:	882080e7          	jalr	-1918(ra) # 80002eca <iinit>
    fileinit();      // file table
    80000650:	00004097          	auipc	ra,0x4
    80000654:	832080e7          	jalr	-1998(ra) # 80003e82 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000658:	00005097          	auipc	ra,0x5
    8000065c:	1f4080e7          	jalr	500(ra) # 8000584c <virtio_disk_init>
    userinit();      // first user process
    80000660:	00001097          	auipc	ra,0x1
    80000664:	f36080e7          	jalr	-202(ra) # 80001596 <userinit>
    __sync_synchronize();
    80000668:	0330000f          	fence	rw,rw
    started = 1;
    8000066c:	4785                	li	a5,1
    8000066e:	0000b717          	auipc	a4,0xb
    80000672:	e6f72923          	sw	a5,-398(a4) # 8000b4e0 <started>
    80000676:	b789                	j	800005b8 <main+0x56>

0000000080000678 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000678:	1141                	addi	sp,sp,-16
    8000067a:	e422                	sd	s0,8(sp)
    8000067c:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000067e:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000682:	0000b797          	auipc	a5,0xb
    80000686:	e667b783          	ld	a5,-410(a5) # 8000b4e8 <kernel_pagetable>
    8000068a:	83b1                	srli	a5,a5,0xc
    8000068c:	577d                	li	a4,-1
    8000068e:	177e                	slli	a4,a4,0x3f
    80000690:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000692:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000696:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000069a:	6422                	ld	s0,8(sp)
    8000069c:	0141                	addi	sp,sp,16
    8000069e:	8082                	ret

00000000800006a0 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800006a0:	7139                	addi	sp,sp,-64
    800006a2:	fc06                	sd	ra,56(sp)
    800006a4:	f822                	sd	s0,48(sp)
    800006a6:	f426                	sd	s1,40(sp)
    800006a8:	f04a                	sd	s2,32(sp)
    800006aa:	ec4e                	sd	s3,24(sp)
    800006ac:	e852                	sd	s4,16(sp)
    800006ae:	e456                	sd	s5,8(sp)
    800006b0:	e05a                	sd	s6,0(sp)
    800006b2:	0080                	addi	s0,sp,64
    800006b4:	84aa                	mv	s1,a0
    800006b6:	89ae                	mv	s3,a1
    800006b8:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800006ba:	57fd                	li	a5,-1
    800006bc:	83e9                	srli	a5,a5,0x1a
    800006be:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800006c0:	4b31                	li	s6,12
  if(va >= MAXVA)
    800006c2:	04b7f263          	bgeu	a5,a1,80000706 <walk+0x66>
    panic("walk");
    800006c6:	00008517          	auipc	a0,0x8
    800006ca:	9e250513          	addi	a0,a0,-1566 # 800080a8 <etext+0xa8>
    800006ce:	00006097          	auipc	ra,0x6
    800006d2:	bd4080e7          	jalr	-1068(ra) # 800062a2 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800006d6:	060a8663          	beqz	s5,80000742 <walk+0xa2>
    800006da:	00000097          	auipc	ra,0x0
    800006de:	b64080e7          	jalr	-1180(ra) # 8000023e <kalloc>
    800006e2:	84aa                	mv	s1,a0
    800006e4:	c529                	beqz	a0,8000072e <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800006e6:	6605                	lui	a2,0x1
    800006e8:	4581                	li	a1,0
    800006ea:	00000097          	auipc	ra,0x0
    800006ee:	cda080e7          	jalr	-806(ra) # 800003c4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800006f2:	00c4d793          	srli	a5,s1,0xc
    800006f6:	07aa                	slli	a5,a5,0xa
    800006f8:	0017e793          	ori	a5,a5,1
    800006fc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000700:	3a5d                	addiw	s4,s4,-9
    80000702:	036a0063          	beq	s4,s6,80000722 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000706:	0149d933          	srl	s2,s3,s4
    8000070a:	1ff97913          	andi	s2,s2,511
    8000070e:	090e                	slli	s2,s2,0x3
    80000710:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000712:	00093483          	ld	s1,0(s2)
    80000716:	0014f793          	andi	a5,s1,1
    8000071a:	dfd5                	beqz	a5,800006d6 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000071c:	80a9                	srli	s1,s1,0xa
    8000071e:	04b2                	slli	s1,s1,0xc
    80000720:	b7c5                	j	80000700 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000722:	00c9d513          	srli	a0,s3,0xc
    80000726:	1ff57513          	andi	a0,a0,511
    8000072a:	050e                	slli	a0,a0,0x3
    8000072c:	9526                	add	a0,a0,s1
}
    8000072e:	70e2                	ld	ra,56(sp)
    80000730:	7442                	ld	s0,48(sp)
    80000732:	74a2                	ld	s1,40(sp)
    80000734:	7902                	ld	s2,32(sp)
    80000736:	69e2                	ld	s3,24(sp)
    80000738:	6a42                	ld	s4,16(sp)
    8000073a:	6aa2                	ld	s5,8(sp)
    8000073c:	6b02                	ld	s6,0(sp)
    8000073e:	6121                	addi	sp,sp,64
    80000740:	8082                	ret
        return 0;
    80000742:	4501                	li	a0,0
    80000744:	b7ed                	j	8000072e <walk+0x8e>

0000000080000746 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000746:	57fd                	li	a5,-1
    80000748:	83e9                	srli	a5,a5,0x1a
    8000074a:	00b7f463          	bgeu	a5,a1,80000752 <walkaddr+0xc>
    return 0;
    8000074e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000750:	8082                	ret
{
    80000752:	1141                	addi	sp,sp,-16
    80000754:	e406                	sd	ra,8(sp)
    80000756:	e022                	sd	s0,0(sp)
    80000758:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000075a:	4601                	li	a2,0
    8000075c:	00000097          	auipc	ra,0x0
    80000760:	f44080e7          	jalr	-188(ra) # 800006a0 <walk>
  if(pte == 0)
    80000764:	c105                	beqz	a0,80000784 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000766:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000768:	0117f693          	andi	a3,a5,17
    8000076c:	4745                	li	a4,17
    return 0;
    8000076e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000770:	00e68663          	beq	a3,a4,8000077c <walkaddr+0x36>
}
    80000774:	60a2                	ld	ra,8(sp)
    80000776:	6402                	ld	s0,0(sp)
    80000778:	0141                	addi	sp,sp,16
    8000077a:	8082                	ret
  pa = PTE2PA(*pte);
    8000077c:	83a9                	srli	a5,a5,0xa
    8000077e:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000782:	bfcd                	j	80000774 <walkaddr+0x2e>
    return 0;
    80000784:	4501                	li	a0,0
    80000786:	b7fd                	j	80000774 <walkaddr+0x2e>

0000000080000788 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000788:	715d                	addi	sp,sp,-80
    8000078a:	e486                	sd	ra,72(sp)
    8000078c:	e0a2                	sd	s0,64(sp)
    8000078e:	fc26                	sd	s1,56(sp)
    80000790:	f84a                	sd	s2,48(sp)
    80000792:	f44e                	sd	s3,40(sp)
    80000794:	f052                	sd	s4,32(sp)
    80000796:	ec56                	sd	s5,24(sp)
    80000798:	e85a                	sd	s6,16(sp)
    8000079a:	e45e                	sd	s7,8(sp)
    8000079c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000079e:	03459793          	slli	a5,a1,0x34
    800007a2:	e7b9                	bnez	a5,800007f0 <mappages+0x68>
    800007a4:	8aaa                	mv	s5,a0
    800007a6:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800007a8:	03461793          	slli	a5,a2,0x34
    800007ac:	ebb1                	bnez	a5,80000800 <mappages+0x78>
    panic("mappages: size not aligned");

  if(size == 0)
    800007ae:	c22d                	beqz	a2,80000810 <mappages+0x88>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800007b0:	77fd                	lui	a5,0xfffff
    800007b2:	963e                	add	a2,a2,a5
    800007b4:	00b609b3          	add	s3,a2,a1
  a = va;
    800007b8:	892e                	mv	s2,a1
    800007ba:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800007be:	6b85                	lui	s7,0x1
    800007c0:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800007c4:	4605                	li	a2,1
    800007c6:	85ca                	mv	a1,s2
    800007c8:	8556                	mv	a0,s5
    800007ca:	00000097          	auipc	ra,0x0
    800007ce:	ed6080e7          	jalr	-298(ra) # 800006a0 <walk>
    800007d2:	cd39                	beqz	a0,80000830 <mappages+0xa8>
    if(*pte & PTE_V)
    800007d4:	611c                	ld	a5,0(a0)
    800007d6:	8b85                	andi	a5,a5,1
    800007d8:	e7a1                	bnez	a5,80000820 <mappages+0x98>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800007da:	80b1                	srli	s1,s1,0xc
    800007dc:	04aa                	slli	s1,s1,0xa
    800007de:	0164e4b3          	or	s1,s1,s6
    800007e2:	0014e493          	ori	s1,s1,1
    800007e6:	e104                	sd	s1,0(a0)
    if(a == last)
    800007e8:	07390063          	beq	s2,s3,80000848 <mappages+0xc0>
    a += PGSIZE;
    800007ec:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800007ee:	bfc9                	j	800007c0 <mappages+0x38>
    panic("mappages: va not aligned");
    800007f0:	00008517          	auipc	a0,0x8
    800007f4:	8c050513          	addi	a0,a0,-1856 # 800080b0 <etext+0xb0>
    800007f8:	00006097          	auipc	ra,0x6
    800007fc:	aaa080e7          	jalr	-1366(ra) # 800062a2 <panic>
    panic("mappages: size not aligned");
    80000800:	00008517          	auipc	a0,0x8
    80000804:	8d050513          	addi	a0,a0,-1840 # 800080d0 <etext+0xd0>
    80000808:	00006097          	auipc	ra,0x6
    8000080c:	a9a080e7          	jalr	-1382(ra) # 800062a2 <panic>
    panic("mappages: size");
    80000810:	00008517          	auipc	a0,0x8
    80000814:	8e050513          	addi	a0,a0,-1824 # 800080f0 <etext+0xf0>
    80000818:	00006097          	auipc	ra,0x6
    8000081c:	a8a080e7          	jalr	-1398(ra) # 800062a2 <panic>
      panic("mappages: remap");
    80000820:	00008517          	auipc	a0,0x8
    80000824:	8e050513          	addi	a0,a0,-1824 # 80008100 <etext+0x100>
    80000828:	00006097          	auipc	ra,0x6
    8000082c:	a7a080e7          	jalr	-1414(ra) # 800062a2 <panic>
      return -1;
    80000830:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000832:	60a6                	ld	ra,72(sp)
    80000834:	6406                	ld	s0,64(sp)
    80000836:	74e2                	ld	s1,56(sp)
    80000838:	7942                	ld	s2,48(sp)
    8000083a:	79a2                	ld	s3,40(sp)
    8000083c:	7a02                	ld	s4,32(sp)
    8000083e:	6ae2                	ld	s5,24(sp)
    80000840:	6b42                	ld	s6,16(sp)
    80000842:	6ba2                	ld	s7,8(sp)
    80000844:	6161                	addi	sp,sp,80
    80000846:	8082                	ret
  return 0;
    80000848:	4501                	li	a0,0
    8000084a:	b7e5                	j	80000832 <mappages+0xaa>

000000008000084c <kvmmap>:
{
    8000084c:	1141                	addi	sp,sp,-16
    8000084e:	e406                	sd	ra,8(sp)
    80000850:	e022                	sd	s0,0(sp)
    80000852:	0800                	addi	s0,sp,16
    80000854:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000856:	86b2                	mv	a3,a2
    80000858:	863e                	mv	a2,a5
    8000085a:	00000097          	auipc	ra,0x0
    8000085e:	f2e080e7          	jalr	-210(ra) # 80000788 <mappages>
    80000862:	e509                	bnez	a0,8000086c <kvmmap+0x20>
}
    80000864:	60a2                	ld	ra,8(sp)
    80000866:	6402                	ld	s0,0(sp)
    80000868:	0141                	addi	sp,sp,16
    8000086a:	8082                	ret
    panic("kvmmap");
    8000086c:	00008517          	auipc	a0,0x8
    80000870:	8a450513          	addi	a0,a0,-1884 # 80008110 <etext+0x110>
    80000874:	00006097          	auipc	ra,0x6
    80000878:	a2e080e7          	jalr	-1490(ra) # 800062a2 <panic>

000000008000087c <kvmmake>:
{
    8000087c:	1101                	addi	sp,sp,-32
    8000087e:	ec06                	sd	ra,24(sp)
    80000880:	e822                	sd	s0,16(sp)
    80000882:	e426                	sd	s1,8(sp)
    80000884:	e04a                	sd	s2,0(sp)
    80000886:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000888:	00000097          	auipc	ra,0x0
    8000088c:	9b6080e7          	jalr	-1610(ra) # 8000023e <kalloc>
    80000890:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000892:	6605                	lui	a2,0x1
    80000894:	4581                	li	a1,0
    80000896:	00000097          	auipc	ra,0x0
    8000089a:	b2e080e7          	jalr	-1234(ra) # 800003c4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000089e:	4719                	li	a4,6
    800008a0:	6685                	lui	a3,0x1
    800008a2:	10000637          	lui	a2,0x10000
    800008a6:	100005b7          	lui	a1,0x10000
    800008aa:	8526                	mv	a0,s1
    800008ac:	00000097          	auipc	ra,0x0
    800008b0:	fa0080e7          	jalr	-96(ra) # 8000084c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800008b4:	4719                	li	a4,6
    800008b6:	6685                	lui	a3,0x1
    800008b8:	10001637          	lui	a2,0x10001
    800008bc:	100015b7          	lui	a1,0x10001
    800008c0:	8526                	mv	a0,s1
    800008c2:	00000097          	auipc	ra,0x0
    800008c6:	f8a080e7          	jalr	-118(ra) # 8000084c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800008ca:	4719                	li	a4,6
    800008cc:	004006b7          	lui	a3,0x400
    800008d0:	0c000637          	lui	a2,0xc000
    800008d4:	0c0005b7          	lui	a1,0xc000
    800008d8:	8526                	mv	a0,s1
    800008da:	00000097          	auipc	ra,0x0
    800008de:	f72080e7          	jalr	-142(ra) # 8000084c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800008e2:	00007917          	auipc	s2,0x7
    800008e6:	71e90913          	addi	s2,s2,1822 # 80008000 <etext>
    800008ea:	4729                	li	a4,10
    800008ec:	80007697          	auipc	a3,0x80007
    800008f0:	71468693          	addi	a3,a3,1812 # 8000 <_entry-0x7fff8000>
    800008f4:	4605                	li	a2,1
    800008f6:	067e                	slli	a2,a2,0x1f
    800008f8:	85b2                	mv	a1,a2
    800008fa:	8526                	mv	a0,s1
    800008fc:	00000097          	auipc	ra,0x0
    80000900:	f50080e7          	jalr	-176(ra) # 8000084c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000904:	46c5                	li	a3,17
    80000906:	06ee                	slli	a3,a3,0x1b
    80000908:	4719                	li	a4,6
    8000090a:	412686b3          	sub	a3,a3,s2
    8000090e:	864a                	mv	a2,s2
    80000910:	85ca                	mv	a1,s2
    80000912:	8526                	mv	a0,s1
    80000914:	00000097          	auipc	ra,0x0
    80000918:	f38080e7          	jalr	-200(ra) # 8000084c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000091c:	4729                	li	a4,10
    8000091e:	6685                	lui	a3,0x1
    80000920:	00006617          	auipc	a2,0x6
    80000924:	6e060613          	addi	a2,a2,1760 # 80007000 <_trampoline>
    80000928:	040005b7          	lui	a1,0x4000
    8000092c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000092e:	05b2                	slli	a1,a1,0xc
    80000930:	8526                	mv	a0,s1
    80000932:	00000097          	auipc	ra,0x0
    80000936:	f1a080e7          	jalr	-230(ra) # 8000084c <kvmmap>
  proc_mapstacks(kpgtbl);
    8000093a:	8526                	mv	a0,s1
    8000093c:	00000097          	auipc	ra,0x0
    80000940:	7ec080e7          	jalr	2028(ra) # 80001128 <proc_mapstacks>
}
    80000944:	8526                	mv	a0,s1
    80000946:	60e2                	ld	ra,24(sp)
    80000948:	6442                	ld	s0,16(sp)
    8000094a:	64a2                	ld	s1,8(sp)
    8000094c:	6902                	ld	s2,0(sp)
    8000094e:	6105                	addi	sp,sp,32
    80000950:	8082                	ret

0000000080000952 <kvminit>:
{
    80000952:	1141                	addi	sp,sp,-16
    80000954:	e406                	sd	ra,8(sp)
    80000956:	e022                	sd	s0,0(sp)
    80000958:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	f22080e7          	jalr	-222(ra) # 8000087c <kvmmake>
    80000962:	0000b797          	auipc	a5,0xb
    80000966:	b8a7b323          	sd	a0,-1146(a5) # 8000b4e8 <kernel_pagetable>
}
    8000096a:	60a2                	ld	ra,8(sp)
    8000096c:	6402                	ld	s0,0(sp)
    8000096e:	0141                	addi	sp,sp,16
    80000970:	8082                	ret

0000000080000972 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000972:	715d                	addi	sp,sp,-80
    80000974:	e486                	sd	ra,72(sp)
    80000976:	e0a2                	sd	s0,64(sp)
    80000978:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000097a:	03459793          	slli	a5,a1,0x34
    8000097e:	e39d                	bnez	a5,800009a4 <uvmunmap+0x32>
    80000980:	f84a                	sd	s2,48(sp)
    80000982:	f44e                	sd	s3,40(sp)
    80000984:	f052                	sd	s4,32(sp)
    80000986:	ec56                	sd	s5,24(sp)
    80000988:	e85a                	sd	s6,16(sp)
    8000098a:	e45e                	sd	s7,8(sp)
    8000098c:	8a2a                	mv	s4,a0
    8000098e:	892e                	mv	s2,a1
    80000990:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000992:	0632                	slli	a2,a2,0xc
    80000994:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000998:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000099a:	6b05                	lui	s6,0x1
    8000099c:	0935fb63          	bgeu	a1,s3,80000a32 <uvmunmap+0xc0>
    800009a0:	fc26                	sd	s1,56(sp)
    800009a2:	a8a9                	j	800009fc <uvmunmap+0x8a>
    800009a4:	fc26                	sd	s1,56(sp)
    800009a6:	f84a                	sd	s2,48(sp)
    800009a8:	f44e                	sd	s3,40(sp)
    800009aa:	f052                	sd	s4,32(sp)
    800009ac:	ec56                	sd	s5,24(sp)
    800009ae:	e85a                	sd	s6,16(sp)
    800009b0:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800009b2:	00007517          	auipc	a0,0x7
    800009b6:	76650513          	addi	a0,a0,1894 # 80008118 <etext+0x118>
    800009ba:	00006097          	auipc	ra,0x6
    800009be:	8e8080e7          	jalr	-1816(ra) # 800062a2 <panic>
      panic("uvmunmap: walk");
    800009c2:	00007517          	auipc	a0,0x7
    800009c6:	76e50513          	addi	a0,a0,1902 # 80008130 <etext+0x130>
    800009ca:	00006097          	auipc	ra,0x6
    800009ce:	8d8080e7          	jalr	-1832(ra) # 800062a2 <panic>
      panic("uvmunmap: not mapped");
    800009d2:	00007517          	auipc	a0,0x7
    800009d6:	76e50513          	addi	a0,a0,1902 # 80008140 <etext+0x140>
    800009da:	00006097          	auipc	ra,0x6
    800009de:	8c8080e7          	jalr	-1848(ra) # 800062a2 <panic>
      panic("uvmunmap: not a leaf");
    800009e2:	00007517          	auipc	a0,0x7
    800009e6:	77650513          	addi	a0,a0,1910 # 80008158 <etext+0x158>
    800009ea:	00006097          	auipc	ra,0x6
    800009ee:	8b8080e7          	jalr	-1864(ra) # 800062a2 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800009f2:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800009f6:	995a                	add	s2,s2,s6
    800009f8:	03397c63          	bgeu	s2,s3,80000a30 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    800009fc:	4601                	li	a2,0
    800009fe:	85ca                	mv	a1,s2
    80000a00:	8552                	mv	a0,s4
    80000a02:	00000097          	auipc	ra,0x0
    80000a06:	c9e080e7          	jalr	-866(ra) # 800006a0 <walk>
    80000a0a:	84aa                	mv	s1,a0
    80000a0c:	d95d                	beqz	a0,800009c2 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    80000a0e:	6108                	ld	a0,0(a0)
    80000a10:	00157793          	andi	a5,a0,1
    80000a14:	dfdd                	beqz	a5,800009d2 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000a16:	3ff57793          	andi	a5,a0,1023
    80000a1a:	fd7784e3          	beq	a5,s7,800009e2 <uvmunmap+0x70>
    if(do_free){
    80000a1e:	fc0a8ae3          	beqz	s5,800009f2 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    80000a22:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000a24:	0532                	slli	a0,a0,0xc
    80000a26:	fffff097          	auipc	ra,0xfffff
    80000a2a:	5f6080e7          	jalr	1526(ra) # 8000001c <kfree>
    80000a2e:	b7d1                	j	800009f2 <uvmunmap+0x80>
    80000a30:	74e2                	ld	s1,56(sp)
    80000a32:	7942                	ld	s2,48(sp)
    80000a34:	79a2                	ld	s3,40(sp)
    80000a36:	7a02                	ld	s4,32(sp)
    80000a38:	6ae2                	ld	s5,24(sp)
    80000a3a:	6b42                	ld	s6,16(sp)
    80000a3c:	6ba2                	ld	s7,8(sp)
  }
}
    80000a3e:	60a6                	ld	ra,72(sp)
    80000a40:	6406                	ld	s0,64(sp)
    80000a42:	6161                	addi	sp,sp,80
    80000a44:	8082                	ret

0000000080000a46 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000a46:	1101                	addi	sp,sp,-32
    80000a48:	ec06                	sd	ra,24(sp)
    80000a4a:	e822                	sd	s0,16(sp)
    80000a4c:	e426                	sd	s1,8(sp)
    80000a4e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000a50:	fffff097          	auipc	ra,0xfffff
    80000a54:	7ee080e7          	jalr	2030(ra) # 8000023e <kalloc>
    80000a58:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000a5a:	c519                	beqz	a0,80000a68 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000a5c:	6605                	lui	a2,0x1
    80000a5e:	4581                	li	a1,0
    80000a60:	00000097          	auipc	ra,0x0
    80000a64:	964080e7          	jalr	-1692(ra) # 800003c4 <memset>
  return pagetable;
}
    80000a68:	8526                	mv	a0,s1
    80000a6a:	60e2                	ld	ra,24(sp)
    80000a6c:	6442                	ld	s0,16(sp)
    80000a6e:	64a2                	ld	s1,8(sp)
    80000a70:	6105                	addi	sp,sp,32
    80000a72:	8082                	ret

0000000080000a74 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000a74:	7179                	addi	sp,sp,-48
    80000a76:	f406                	sd	ra,40(sp)
    80000a78:	f022                	sd	s0,32(sp)
    80000a7a:	ec26                	sd	s1,24(sp)
    80000a7c:	e84a                	sd	s2,16(sp)
    80000a7e:	e44e                	sd	s3,8(sp)
    80000a80:	e052                	sd	s4,0(sp)
    80000a82:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000a84:	6785                	lui	a5,0x1
    80000a86:	04f67863          	bgeu	a2,a5,80000ad6 <uvmfirst+0x62>
    80000a8a:	8a2a                	mv	s4,a0
    80000a8c:	89ae                	mv	s3,a1
    80000a8e:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000a90:	fffff097          	auipc	ra,0xfffff
    80000a94:	7ae080e7          	jalr	1966(ra) # 8000023e <kalloc>
    80000a98:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000a9a:	6605                	lui	a2,0x1
    80000a9c:	4581                	li	a1,0
    80000a9e:	00000097          	auipc	ra,0x0
    80000aa2:	926080e7          	jalr	-1754(ra) # 800003c4 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000aa6:	4779                	li	a4,30
    80000aa8:	86ca                	mv	a3,s2
    80000aaa:	6605                	lui	a2,0x1
    80000aac:	4581                	li	a1,0
    80000aae:	8552                	mv	a0,s4
    80000ab0:	00000097          	auipc	ra,0x0
    80000ab4:	cd8080e7          	jalr	-808(ra) # 80000788 <mappages>
  memmove(mem, src, sz);
    80000ab8:	8626                	mv	a2,s1
    80000aba:	85ce                	mv	a1,s3
    80000abc:	854a                	mv	a0,s2
    80000abe:	00000097          	auipc	ra,0x0
    80000ac2:	962080e7          	jalr	-1694(ra) # 80000420 <memmove>
}
    80000ac6:	70a2                	ld	ra,40(sp)
    80000ac8:	7402                	ld	s0,32(sp)
    80000aca:	64e2                	ld	s1,24(sp)
    80000acc:	6942                	ld	s2,16(sp)
    80000ace:	69a2                	ld	s3,8(sp)
    80000ad0:	6a02                	ld	s4,0(sp)
    80000ad2:	6145                	addi	sp,sp,48
    80000ad4:	8082                	ret
    panic("uvmfirst: more than a page");
    80000ad6:	00007517          	auipc	a0,0x7
    80000ada:	69a50513          	addi	a0,a0,1690 # 80008170 <etext+0x170>
    80000ade:	00005097          	auipc	ra,0x5
    80000ae2:	7c4080e7          	jalr	1988(ra) # 800062a2 <panic>

0000000080000ae6 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000ae6:	1101                	addi	sp,sp,-32
    80000ae8:	ec06                	sd	ra,24(sp)
    80000aea:	e822                	sd	s0,16(sp)
    80000aec:	e426                	sd	s1,8(sp)
    80000aee:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000af0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000af2:	00b67d63          	bgeu	a2,a1,80000b0c <uvmdealloc+0x26>
    80000af6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000af8:	6785                	lui	a5,0x1
    80000afa:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000afc:	00f60733          	add	a4,a2,a5
    80000b00:	76fd                	lui	a3,0xfffff
    80000b02:	8f75                	and	a4,a4,a3
    80000b04:	97ae                	add	a5,a5,a1
    80000b06:	8ff5                	and	a5,a5,a3
    80000b08:	00f76863          	bltu	a4,a5,80000b18 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000b0c:	8526                	mv	a0,s1
    80000b0e:	60e2                	ld	ra,24(sp)
    80000b10:	6442                	ld	s0,16(sp)
    80000b12:	64a2                	ld	s1,8(sp)
    80000b14:	6105                	addi	sp,sp,32
    80000b16:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000b18:	8f99                	sub	a5,a5,a4
    80000b1a:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000b1c:	4685                	li	a3,1
    80000b1e:	0007861b          	sext.w	a2,a5
    80000b22:	85ba                	mv	a1,a4
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	e4e080e7          	jalr	-434(ra) # 80000972 <uvmunmap>
    80000b2c:	b7c5                	j	80000b0c <uvmdealloc+0x26>

0000000080000b2e <uvmalloc>:
  if(newsz < oldsz)
    80000b2e:	0ab66b63          	bltu	a2,a1,80000be4 <uvmalloc+0xb6>
{
    80000b32:	7139                	addi	sp,sp,-64
    80000b34:	fc06                	sd	ra,56(sp)
    80000b36:	f822                	sd	s0,48(sp)
    80000b38:	ec4e                	sd	s3,24(sp)
    80000b3a:	e852                	sd	s4,16(sp)
    80000b3c:	e456                	sd	s5,8(sp)
    80000b3e:	0080                	addi	s0,sp,64
    80000b40:	8aaa                	mv	s5,a0
    80000b42:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000b44:	6785                	lui	a5,0x1
    80000b46:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000b48:	95be                	add	a1,a1,a5
    80000b4a:	77fd                	lui	a5,0xfffff
    80000b4c:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000b50:	08c9fc63          	bgeu	s3,a2,80000be8 <uvmalloc+0xba>
    80000b54:	f426                	sd	s1,40(sp)
    80000b56:	f04a                	sd	s2,32(sp)
    80000b58:	e05a                	sd	s6,0(sp)
    80000b5a:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000b5c:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000b60:	fffff097          	auipc	ra,0xfffff
    80000b64:	6de080e7          	jalr	1758(ra) # 8000023e <kalloc>
    80000b68:	84aa                	mv	s1,a0
    if(mem == 0){
    80000b6a:	c915                	beqz	a0,80000b9e <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    80000b6c:	6605                	lui	a2,0x1
    80000b6e:	4581                	li	a1,0
    80000b70:	00000097          	auipc	ra,0x0
    80000b74:	854080e7          	jalr	-1964(ra) # 800003c4 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000b78:	875a                	mv	a4,s6
    80000b7a:	86a6                	mv	a3,s1
    80000b7c:	6605                	lui	a2,0x1
    80000b7e:	85ca                	mv	a1,s2
    80000b80:	8556                	mv	a0,s5
    80000b82:	00000097          	auipc	ra,0x0
    80000b86:	c06080e7          	jalr	-1018(ra) # 80000788 <mappages>
    80000b8a:	ed05                	bnez	a0,80000bc2 <uvmalloc+0x94>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000b8c:	6785                	lui	a5,0x1
    80000b8e:	993e                	add	s2,s2,a5
    80000b90:	fd4968e3          	bltu	s2,s4,80000b60 <uvmalloc+0x32>
  return newsz;
    80000b94:	8552                	mv	a0,s4
    80000b96:	74a2                	ld	s1,40(sp)
    80000b98:	7902                	ld	s2,32(sp)
    80000b9a:	6b02                	ld	s6,0(sp)
    80000b9c:	a821                	j	80000bb4 <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    80000b9e:	864e                	mv	a2,s3
    80000ba0:	85ca                	mv	a1,s2
    80000ba2:	8556                	mv	a0,s5
    80000ba4:	00000097          	auipc	ra,0x0
    80000ba8:	f42080e7          	jalr	-190(ra) # 80000ae6 <uvmdealloc>
      return 0;
    80000bac:	4501                	li	a0,0
    80000bae:	74a2                	ld	s1,40(sp)
    80000bb0:	7902                	ld	s2,32(sp)
    80000bb2:	6b02                	ld	s6,0(sp)
}
    80000bb4:	70e2                	ld	ra,56(sp)
    80000bb6:	7442                	ld	s0,48(sp)
    80000bb8:	69e2                	ld	s3,24(sp)
    80000bba:	6a42                	ld	s4,16(sp)
    80000bbc:	6aa2                	ld	s5,8(sp)
    80000bbe:	6121                	addi	sp,sp,64
    80000bc0:	8082                	ret
      kfree(mem);
    80000bc2:	8526                	mv	a0,s1
    80000bc4:	fffff097          	auipc	ra,0xfffff
    80000bc8:	458080e7          	jalr	1112(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000bcc:	864e                	mv	a2,s3
    80000bce:	85ca                	mv	a1,s2
    80000bd0:	8556                	mv	a0,s5
    80000bd2:	00000097          	auipc	ra,0x0
    80000bd6:	f14080e7          	jalr	-236(ra) # 80000ae6 <uvmdealloc>
      return 0;
    80000bda:	4501                	li	a0,0
    80000bdc:	74a2                	ld	s1,40(sp)
    80000bde:	7902                	ld	s2,32(sp)
    80000be0:	6b02                	ld	s6,0(sp)
    80000be2:	bfc9                	j	80000bb4 <uvmalloc+0x86>
    return oldsz;
    80000be4:	852e                	mv	a0,a1
}
    80000be6:	8082                	ret
  return newsz;
    80000be8:	8532                	mv	a0,a2
    80000bea:	b7e9                	j	80000bb4 <uvmalloc+0x86>

0000000080000bec <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000bec:	7179                	addi	sp,sp,-48
    80000bee:	f406                	sd	ra,40(sp)
    80000bf0:	f022                	sd	s0,32(sp)
    80000bf2:	ec26                	sd	s1,24(sp)
    80000bf4:	e84a                	sd	s2,16(sp)
    80000bf6:	e44e                	sd	s3,8(sp)
    80000bf8:	e052                	sd	s4,0(sp)
    80000bfa:	1800                	addi	s0,sp,48
    80000bfc:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000bfe:	84aa                	mv	s1,a0
    80000c00:	6905                	lui	s2,0x1
    80000c02:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000c04:	4985                	li	s3,1
    80000c06:	a829                	j	80000c20 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000c08:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000c0a:	00c79513          	slli	a0,a5,0xc
    80000c0e:	00000097          	auipc	ra,0x0
    80000c12:	fde080e7          	jalr	-34(ra) # 80000bec <freewalk>
      pagetable[i] = 0;
    80000c16:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000c1a:	04a1                	addi	s1,s1,8
    80000c1c:	03248163          	beq	s1,s2,80000c3e <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000c20:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000c22:	00f7f713          	andi	a4,a5,15
    80000c26:	ff3701e3          	beq	a4,s3,80000c08 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000c2a:	8b85                	andi	a5,a5,1
    80000c2c:	d7fd                	beqz	a5,80000c1a <freewalk+0x2e>
      panic("freewalk: leaf");
    80000c2e:	00007517          	auipc	a0,0x7
    80000c32:	56250513          	addi	a0,a0,1378 # 80008190 <etext+0x190>
    80000c36:	00005097          	auipc	ra,0x5
    80000c3a:	66c080e7          	jalr	1644(ra) # 800062a2 <panic>
    }
  }
  kfree((void*)pagetable);
    80000c3e:	8552                	mv	a0,s4
    80000c40:	fffff097          	auipc	ra,0xfffff
    80000c44:	3dc080e7          	jalr	988(ra) # 8000001c <kfree>
}
    80000c48:	70a2                	ld	ra,40(sp)
    80000c4a:	7402                	ld	s0,32(sp)
    80000c4c:	64e2                	ld	s1,24(sp)
    80000c4e:	6942                	ld	s2,16(sp)
    80000c50:	69a2                	ld	s3,8(sp)
    80000c52:	6a02                	ld	s4,0(sp)
    80000c54:	6145                	addi	sp,sp,48
    80000c56:	8082                	ret

0000000080000c58 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000c58:	1101                	addi	sp,sp,-32
    80000c5a:	ec06                	sd	ra,24(sp)
    80000c5c:	e822                	sd	s0,16(sp)
    80000c5e:	e426                	sd	s1,8(sp)
    80000c60:	1000                	addi	s0,sp,32
    80000c62:	84aa                	mv	s1,a0
  if(sz > 0)
    80000c64:	e999                	bnez	a1,80000c7a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000c66:	8526                	mv	a0,s1
    80000c68:	00000097          	auipc	ra,0x0
    80000c6c:	f84080e7          	jalr	-124(ra) # 80000bec <freewalk>
}
    80000c70:	60e2                	ld	ra,24(sp)
    80000c72:	6442                	ld	s0,16(sp)
    80000c74:	64a2                	ld	s1,8(sp)
    80000c76:	6105                	addi	sp,sp,32
    80000c78:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000c7a:	6785                	lui	a5,0x1
    80000c7c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000c7e:	95be                	add	a1,a1,a5
    80000c80:	4685                	li	a3,1
    80000c82:	00c5d613          	srli	a2,a1,0xc
    80000c86:	4581                	li	a1,0
    80000c88:	00000097          	auipc	ra,0x0
    80000c8c:	cea080e7          	jalr	-790(ra) # 80000972 <uvmunmap>
    80000c90:	bfd9                	j	80000c66 <uvmfree+0xe>

0000000080000c92 <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80000c92:	711d                	addi	sp,sp,-96
    80000c94:	ec86                	sd	ra,88(sp)
    80000c96:	e8a2                	sd	s0,80(sp)
    80000c98:	e06a                	sd	s10,0(sp)
    80000c9a:	1080                	addi	s0,sp,96
  pte_t *pte_old;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; i += PGSIZE){
    80000c9c:	10060863          	beqz	a2,80000dac <uvmcopy+0x11a>
    80000ca0:	e4a6                	sd	s1,72(sp)
    80000ca2:	e0ca                	sd	s2,64(sp)
    80000ca4:	fc4e                	sd	s3,56(sp)
    80000ca6:	f852                	sd	s4,48(sp)
    80000ca8:	f456                	sd	s5,40(sp)
    80000caa:	f05a                	sd	s6,32(sp)
    80000cac:	ec5e                	sd	s7,24(sp)
    80000cae:	e862                	sd	s8,16(sp)
    80000cb0:	e466                	sd	s9,8(sp)
    80000cb2:	8baa                	mv	s7,a0
    80000cb4:	8b2e                	mv	s6,a1
    80000cb6:	8ab2                	mv	s5,a2
    80000cb8:	4981                	li	s3,0
    // For COW: map the parent's physical page into child's page table
    // instead of allocating a new page and copying
    if(flags & PTE_W) {
      // Clear PTE_W and set PTE_COW for writable pages
      flags = (flags & ~PTE_W) | PTE_COW;
      *pte_old = PA2PTE(pa) | flags;
    80000cba:	7c7d                	lui	s8,0xfffff
    80000cbc:	002c5c13          	srli	s8,s8,0x2
    80000cc0:	a0a9                	j	80000d0a <uvmcopy+0x78>
      panic("uvmcopy: pte should exist");
    80000cc2:	00007517          	auipc	a0,0x7
    80000cc6:	4de50513          	addi	a0,a0,1246 # 800081a0 <etext+0x1a0>
    80000cca:	00005097          	auipc	ra,0x5
    80000cce:	5d8080e7          	jalr	1496(ra) # 800062a2 <panic>
      panic("uvmcopy: page not present");
    80000cd2:	00007517          	auipc	a0,0x7
    80000cd6:	4ee50513          	addi	a0,a0,1262 # 800081c0 <etext+0x1c0>
    80000cda:	00005097          	auipc	ra,0x5
    80000cde:	5c8080e7          	jalr	1480(ra) # 800062a2 <panic>
    }
    // Read-only pages (like text segment) remain read-only and shared
    
    // Map the same physical page to child
    if(mappages(new, i, PGSIZE, pa, flags) != 0) {
    80000ce2:	8766                	mv	a4,s9
    80000ce4:	86d2                	mv	a3,s4
    80000ce6:	6605                	lui	a2,0x1
    80000ce8:	85ce                	mv	a1,s3
    80000cea:	855a                	mv	a0,s6
    80000cec:	00000097          	auipc	ra,0x0
    80000cf0:	a9c080e7          	jalr	-1380(ra) # 80000788 <mappages>
    80000cf4:	8d2a                	mv	s10,a0
    80000cf6:	e939                	bnez	a0,80000d4c <uvmcopy+0xba>
      goto err;
    }
    
    // Increment reference count for the shared physical page
    // Only after successful mapping
    krefinc((void*)pa);
    80000cf8:	8552                	mv	a0,s4
    80000cfa:	fffff097          	auipc	ra,0xfffff
    80000cfe:	5ea080e7          	jalr	1514(ra) # 800002e4 <krefinc>
  for(i = 0; i < sz; i += PGSIZE){
    80000d02:	6785                	lui	a5,0x1
    80000d04:	99be                	add	s3,s3,a5
    80000d06:	0959f963          	bgeu	s3,s5,80000d98 <uvmcopy+0x106>
    if((pte_old = walk(old, i, 0)) == 0)
    80000d0a:	4601                	li	a2,0
    80000d0c:	85ce                	mv	a1,s3
    80000d0e:	855e                	mv	a0,s7
    80000d10:	00000097          	auipc	ra,0x0
    80000d14:	990080e7          	jalr	-1648(ra) # 800006a0 <walk>
    80000d18:	892a                	mv	s2,a0
    80000d1a:	d545                	beqz	a0,80000cc2 <uvmcopy+0x30>
    if((*pte_old & PTE_V) == 0)
    80000d1c:	6104                	ld	s1,0(a0)
    80000d1e:	0014f793          	andi	a5,s1,1
    80000d22:	dbc5                	beqz	a5,80000cd2 <uvmcopy+0x40>
    pa = PTE2PA(*pte_old);
    80000d24:	00a4da13          	srli	s4,s1,0xa
    80000d28:	0a32                	slli	s4,s4,0xc
    flags = PTE_FLAGS(*pte_old);
    80000d2a:	0004871b          	sext.w	a4,s1
    if(flags & PTE_W) {
    80000d2e:	0044f793          	andi	a5,s1,4
    flags = PTE_FLAGS(*pte_old);
    80000d32:	3ff77c93          	andi	s9,a4,1023
    if(flags & PTE_W) {
    80000d36:	d7d5                	beqz	a5,80000ce2 <uvmcopy+0x50>
      flags = (flags & ~PTE_W) | PTE_COW;
    80000d38:	2fb77713          	andi	a4,a4,763
    80000d3c:	10076c93          	ori	s9,a4,256
      *pte_old = PA2PTE(pa) | flags;
    80000d40:	0184f7b3          	and	a5,s1,s8
    80000d44:	0197e7b3          	or	a5,a5,s9
    80000d48:	e11c                	sd	a5,0(a0)
    80000d4a:	bf61                	j	80000ce2 <uvmcopy+0x50>
      if(flags & PTE_COW) {
    80000d4c:	100cf793          	andi	a5,s9,256
    80000d50:	cb99                	beqz	a5,80000d66 <uvmcopy+0xd4>
        *pte_old = PA2PTE(pa) | flags;
    80000d52:	efbcf793          	andi	a5,s9,-261
    80000d56:	0047e793          	ori	a5,a5,4
    80000d5a:	777d                	lui	a4,0xfffff
    80000d5c:	8309                	srli	a4,a4,0x2
    80000d5e:	8cf9                	and	s1,s1,a4
    80000d60:	8fc5                	or	a5,a5,s1
    80000d62:	00f93023          	sd	a5,0(s2) # 1000 <_entry-0x7ffff000>
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 0); // don't free pages (they're shared)
    80000d66:	4681                	li	a3,0
    80000d68:	00c9d613          	srli	a2,s3,0xc
    80000d6c:	4581                	li	a1,0
    80000d6e:	855a                	mv	a0,s6
    80000d70:	00000097          	auipc	ra,0x0
    80000d74:	c02080e7          	jalr	-1022(ra) # 80000972 <uvmunmap>
  return -1;
    80000d78:	5d7d                	li	s10,-1
    80000d7a:	64a6                	ld	s1,72(sp)
    80000d7c:	6906                	ld	s2,64(sp)
    80000d7e:	79e2                	ld	s3,56(sp)
    80000d80:	7a42                	ld	s4,48(sp)
    80000d82:	7aa2                	ld	s5,40(sp)
    80000d84:	7b02                	ld	s6,32(sp)
    80000d86:	6be2                	ld	s7,24(sp)
    80000d88:	6c42                	ld	s8,16(sp)
    80000d8a:	6ca2                	ld	s9,8(sp)
}
    80000d8c:	856a                	mv	a0,s10
    80000d8e:	60e6                	ld	ra,88(sp)
    80000d90:	6446                	ld	s0,80(sp)
    80000d92:	6d02                	ld	s10,0(sp)
    80000d94:	6125                	addi	sp,sp,96
    80000d96:	8082                	ret
    80000d98:	64a6                	ld	s1,72(sp)
    80000d9a:	6906                	ld	s2,64(sp)
    80000d9c:	79e2                	ld	s3,56(sp)
    80000d9e:	7a42                	ld	s4,48(sp)
    80000da0:	7aa2                	ld	s5,40(sp)
    80000da2:	7b02                	ld	s6,32(sp)
    80000da4:	6be2                	ld	s7,24(sp)
    80000da6:	6c42                	ld	s8,16(sp)
    80000da8:	6ca2                	ld	s9,8(sp)
    80000daa:	b7cd                	j	80000d8c <uvmcopy+0xfa>
  return 0;
    80000dac:	4d01                	li	s10,0
    80000dae:	bff9                	j	80000d8c <uvmcopy+0xfa>

0000000080000db0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000db0:	1141                	addi	sp,sp,-16
    80000db2:	e406                	sd	ra,8(sp)
    80000db4:	e022                	sd	s0,0(sp)
    80000db6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000db8:	4601                	li	a2,0
    80000dba:	00000097          	auipc	ra,0x0
    80000dbe:	8e6080e7          	jalr	-1818(ra) # 800006a0 <walk>
  if(pte == 0)
    80000dc2:	c901                	beqz	a0,80000dd2 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000dc4:	611c                	ld	a5,0(a0)
    80000dc6:	9bbd                	andi	a5,a5,-17
    80000dc8:	e11c                	sd	a5,0(a0)
}
    80000dca:	60a2                	ld	ra,8(sp)
    80000dcc:	6402                	ld	s0,0(sp)
    80000dce:	0141                	addi	sp,sp,16
    80000dd0:	8082                	ret
    panic("uvmclear");
    80000dd2:	00007517          	auipc	a0,0x7
    80000dd6:	40e50513          	addi	a0,a0,1038 # 800081e0 <etext+0x1e0>
    80000dda:	00005097          	auipc	ra,0x5
    80000dde:	4c8080e7          	jalr	1224(ra) # 800062a2 <panic>

0000000080000de2 <cowalloc>:
  pte_t *pte;
  char *mem;
  uint flags;
  uint64 oldpa;

  if(va >= MAXVA)
    80000de2:	57fd                	li	a5,-1
    80000de4:	83e9                	srli	a5,a5,0x1a
    80000de6:	08b7e263          	bltu	a5,a1,80000e6a <cowalloc+0x88>
{
    80000dea:	7179                	addi	sp,sp,-48
    80000dec:	f406                	sd	ra,40(sp)
    80000dee:	f022                	sd	s0,32(sp)
    80000df0:	e44e                	sd	s3,8(sp)
    80000df2:	1800                	addi	s0,sp,48
    return -1;
    
  pte = walk(pagetable, va, 0);
    80000df4:	4601                	li	a2,0
    80000df6:	00000097          	auipc	ra,0x0
    80000dfa:	8aa080e7          	jalr	-1878(ra) # 800006a0 <walk>
    80000dfe:	89aa                	mv	s3,a0
  if(pte == 0)
    80000e00:	c53d                	beqz	a0,80000e6e <cowalloc+0x8c>
    return -1;
  if((*pte & PTE_V) == 0)
    80000e02:	611c                	ld	a5,0(a0)
    return -1;
  if((*pte & PTE_COW) == 0)
    80000e04:	1017f693          	andi	a3,a5,257
    80000e08:	10100713          	li	a4,257
    80000e0c:	06e69363          	bne	a3,a4,80000e72 <cowalloc+0x90>
    80000e10:	ec26                	sd	s1,24(sp)
    80000e12:	e84a                	sd	s2,16(sp)
    80000e14:	e052                	sd	s4,0(sp)
    return -1;
    
  oldpa = PTE2PA(*pte);
    80000e16:	00a7da13          	srli	s4,a5,0xa
    80000e1a:	0a32                	slli	s4,s4,0xc
  flags = PTE_FLAGS(*pte);
    80000e1c:	0007891b          	sext.w	s2,a5
  // Pages marked with COW were originally writable
  // If a page doesn't have COW flag and is read-only, it should remain read-only
  // and attempts to write should be killed (handled elsewhere)
  
  // Allocate a new page
  if((mem = kalloc()) == 0)
    80000e20:	fffff097          	auipc	ra,0xfffff
    80000e24:	41e080e7          	jalr	1054(ra) # 8000023e <kalloc>
    80000e28:	84aa                	mv	s1,a0
    80000e2a:	c531                	beqz	a0,80000e76 <cowalloc+0x94>
    return -1;  // Out of memory, kill the process
    
  // Copy the old page to the new page
  memmove(mem, (char*)oldpa, PGSIZE);
    80000e2c:	6605                	lui	a2,0x1
    80000e2e:	85d2                	mv	a1,s4
    80000e30:	fffff097          	auipc	ra,0xfffff
    80000e34:	5f0080e7          	jalr	1520(ra) # 80000420 <memmove>
  
  // Update PTE to point to new page with PTE_W set, clear COW flag
  flags = (flags & ~PTE_COW) | PTE_W;
  *pte = PA2PTE((uint64)mem) | flags;
    80000e38:	80b1                	srli	s1,s1,0xc
    80000e3a:	04aa                	slli	s1,s1,0xa
    80000e3c:	2fb97793          	andi	a5,s2,763
    80000e40:	0047e793          	ori	a5,a5,4
    80000e44:	8cdd                	or	s1,s1,a5
    80000e46:	0099b023          	sd	s1,0(s3)
    80000e4a:	12000073          	sfence.vma
  
  // Flush TLB to ensure the new mapping is visible
  sfence_vma();
  
  // Free the old page (kfree will handle refcount decrement)
  kfree((void*)oldpa);
    80000e4e:	8552                	mv	a0,s4
    80000e50:	fffff097          	auipc	ra,0xfffff
    80000e54:	1cc080e7          	jalr	460(ra) # 8000001c <kfree>
  
  return 0;
    80000e58:	4501                	li	a0,0
    80000e5a:	64e2                	ld	s1,24(sp)
    80000e5c:	6942                	ld	s2,16(sp)
    80000e5e:	6a02                	ld	s4,0(sp)
}
    80000e60:	70a2                	ld	ra,40(sp)
    80000e62:	7402                	ld	s0,32(sp)
    80000e64:	69a2                	ld	s3,8(sp)
    80000e66:	6145                	addi	sp,sp,48
    80000e68:	8082                	ret
    return -1;
    80000e6a:	557d                	li	a0,-1
}
    80000e6c:	8082                	ret
    return -1;
    80000e6e:	557d                	li	a0,-1
    80000e70:	bfc5                	j	80000e60 <cowalloc+0x7e>
    return -1;
    80000e72:	557d                	li	a0,-1
    80000e74:	b7f5                	j	80000e60 <cowalloc+0x7e>
    return -1;  // Out of memory, kill the process
    80000e76:	557d                	li	a0,-1
    80000e78:	64e2                	ld	s1,24(sp)
    80000e7a:	6942                	ld	s2,16(sp)
    80000e7c:	6a02                	ld	s4,0(sp)
    80000e7e:	b7cd                	j	80000e60 <cowalloc+0x7e>

0000000080000e80 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000e80:	c2fd                	beqz	a3,80000f66 <copyout+0xe6>
{
    80000e82:	7159                	addi	sp,sp,-112
    80000e84:	f486                	sd	ra,104(sp)
    80000e86:	f0a2                	sd	s0,96(sp)
    80000e88:	eca6                	sd	s1,88(sp)
    80000e8a:	e4ce                	sd	s3,72(sp)
    80000e8c:	fc56                	sd	s5,56(sp)
    80000e8e:	f85a                	sd	s6,48(sp)
    80000e90:	f45e                	sd	s7,40(sp)
    80000e92:	1880                	addi	s0,sp,112
    80000e94:	8baa                	mv	s7,a0
    80000e96:	8aae                	mv	s5,a1
    80000e98:	8b32                	mv	s6,a2
    80000e9a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000e9c:	74fd                	lui	s1,0xfffff
    80000e9e:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000ea0:	57fd                	li	a5,-1
    80000ea2:	83e9                	srli	a5,a5,0x1a
    80000ea4:	0c97e363          	bltu	a5,s1,80000f6a <copyout+0xea>
    80000ea8:	e8ca                	sd	s2,80(sp)
    80000eaa:	e0d2                	sd	s4,64(sp)
    80000eac:	f062                	sd	s8,32(sp)
    80000eae:	ec66                	sd	s9,24(sp)
    80000eb0:	e86a                	sd	s10,16(sp)
    80000eb2:	e46e                	sd	s11,8(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0)
    80000eb4:	4cc5                	li	s9,17
    if(*pte & PTE_COW) {
      if(cowalloc(pagetable, va0) < 0)
        return -1;
      // Re-walk to get the new PTE
      pte = walk(pagetable, va0, 0);
      if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000eb6:	4dd5                	li	s11,21
    80000eb8:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000eba:	8c3e                	mv	s8,a5
    80000ebc:	a09d                	j	80000f22 <copyout+0xa2>
      if(cowalloc(pagetable, va0) < 0)
    80000ebe:	85a6                	mv	a1,s1
    80000ec0:	855e                	mv	a0,s7
    80000ec2:	00000097          	auipc	ra,0x0
    80000ec6:	f20080e7          	jalr	-224(ra) # 80000de2 <cowalloc>
    80000eca:	0e054263          	bltz	a0,80000fae <copyout+0x12e>
      pte = walk(pagetable, va0, 0);
    80000ece:	4601                	li	a2,0
    80000ed0:	85a6                	mv	a1,s1
    80000ed2:	855e                	mv	a0,s7
    80000ed4:	fffff097          	auipc	ra,0xfffff
    80000ed8:	7cc080e7          	jalr	1996(ra) # 800006a0 <walk>
      if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000edc:	c16d                	beqz	a0,80000fbe <copyout+0x13e>
    80000ede:	611c                	ld	a5,0(a0)
    80000ee0:	8bd5                	andi	a5,a5,21
    80000ee2:	07b78263          	beq	a5,s11,80000f46 <copyout+0xc6>
         (*pte & PTE_W) == 0)
        return -1;
    80000ee6:	557d                	li	a0,-1
    80000ee8:	6946                	ld	s2,80(sp)
    80000eea:	6a06                	ld	s4,64(sp)
    80000eec:	7c02                	ld	s8,32(sp)
    80000eee:	6ce2                	ld	s9,24(sp)
    80000ef0:	6d42                	ld	s10,16(sp)
    80000ef2:	6da2                	ld	s11,8(sp)
    80000ef4:	a861                	j	80000f8c <copyout+0x10c>
    } else if((*pte & PTE_W) == 0) {
      return -1;
    }
    
    pa0 = PTE2PA(*pte);
    80000ef6:	611c                	ld	a5,0(a0)
    80000ef8:	83a9                	srli	a5,a5,0xa
    80000efa:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000efc:	409a8533          	sub	a0,s5,s1
    80000f00:	0009061b          	sext.w	a2,s2
    80000f04:	85da                	mv	a1,s6
    80000f06:	953e                	add	a0,a0,a5
    80000f08:	fffff097          	auipc	ra,0xfffff
    80000f0c:	518080e7          	jalr	1304(ra) # 80000420 <memmove>

    len -= n;
    80000f10:	412989b3          	sub	s3,s3,s2
    src += n;
    80000f14:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000f16:	04098063          	beqz	s3,80000f56 <copyout+0xd6>
    if(va0 >= MAXVA)
    80000f1a:	054c6a63          	bltu	s8,s4,80000f6e <copyout+0xee>
    80000f1e:	84d2                	mv	s1,s4
    80000f20:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000f22:	4601                	li	a2,0
    80000f24:	85a6                	mv	a1,s1
    80000f26:	855e                	mv	a0,s7
    80000f28:	fffff097          	auipc	ra,0xfffff
    80000f2c:	778080e7          	jalr	1912(ra) # 800006a0 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0)
    80000f30:	c539                	beqz	a0,80000f7e <copyout+0xfe>
    80000f32:	611c                	ld	a5,0(a0)
    80000f34:	0117f713          	andi	a4,a5,17
    80000f38:	07971363          	bne	a4,s9,80000f9e <copyout+0x11e>
    if(*pte & PTE_COW) {
    80000f3c:	1007f713          	andi	a4,a5,256
    80000f40:	ff3d                	bnez	a4,80000ebe <copyout+0x3e>
    } else if((*pte & PTE_W) == 0) {
    80000f42:	8b91                	andi	a5,a5,4
    80000f44:	c7c9                	beqz	a5,80000fce <copyout+0x14e>
    n = PGSIZE - (dstva - va0);
    80000f46:	01a48a33          	add	s4,s1,s10
    80000f4a:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000f4e:	fb29f4e3          	bgeu	s3,s2,80000ef6 <copyout+0x76>
    80000f52:	894e                	mv	s2,s3
    80000f54:	b74d                	j	80000ef6 <copyout+0x76>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000f56:	4501                	li	a0,0
    80000f58:	6946                	ld	s2,80(sp)
    80000f5a:	6a06                	ld	s4,64(sp)
    80000f5c:	7c02                	ld	s8,32(sp)
    80000f5e:	6ce2                	ld	s9,24(sp)
    80000f60:	6d42                	ld	s10,16(sp)
    80000f62:	6da2                	ld	s11,8(sp)
    80000f64:	a025                	j	80000f8c <copyout+0x10c>
    80000f66:	4501                	li	a0,0
}
    80000f68:	8082                	ret
      return -1;
    80000f6a:	557d                	li	a0,-1
    80000f6c:	a005                	j	80000f8c <copyout+0x10c>
    80000f6e:	557d                	li	a0,-1
    80000f70:	6946                	ld	s2,80(sp)
    80000f72:	6a06                	ld	s4,64(sp)
    80000f74:	7c02                	ld	s8,32(sp)
    80000f76:	6ce2                	ld	s9,24(sp)
    80000f78:	6d42                	ld	s10,16(sp)
    80000f7a:	6da2                	ld	s11,8(sp)
    80000f7c:	a801                	j	80000f8c <copyout+0x10c>
      return -1;
    80000f7e:	557d                	li	a0,-1
    80000f80:	6946                	ld	s2,80(sp)
    80000f82:	6a06                	ld	s4,64(sp)
    80000f84:	7c02                	ld	s8,32(sp)
    80000f86:	6ce2                	ld	s9,24(sp)
    80000f88:	6d42                	ld	s10,16(sp)
    80000f8a:	6da2                	ld	s11,8(sp)
}
    80000f8c:	70a6                	ld	ra,104(sp)
    80000f8e:	7406                	ld	s0,96(sp)
    80000f90:	64e6                	ld	s1,88(sp)
    80000f92:	69a6                	ld	s3,72(sp)
    80000f94:	7ae2                	ld	s5,56(sp)
    80000f96:	7b42                	ld	s6,48(sp)
    80000f98:	7ba2                	ld	s7,40(sp)
    80000f9a:	6165                	addi	sp,sp,112
    80000f9c:	8082                	ret
      return -1;
    80000f9e:	557d                	li	a0,-1
    80000fa0:	6946                	ld	s2,80(sp)
    80000fa2:	6a06                	ld	s4,64(sp)
    80000fa4:	7c02                	ld	s8,32(sp)
    80000fa6:	6ce2                	ld	s9,24(sp)
    80000fa8:	6d42                	ld	s10,16(sp)
    80000faa:	6da2                	ld	s11,8(sp)
    80000fac:	b7c5                	j	80000f8c <copyout+0x10c>
        return -1;
    80000fae:	557d                	li	a0,-1
    80000fb0:	6946                	ld	s2,80(sp)
    80000fb2:	6a06                	ld	s4,64(sp)
    80000fb4:	7c02                	ld	s8,32(sp)
    80000fb6:	6ce2                	ld	s9,24(sp)
    80000fb8:	6d42                	ld	s10,16(sp)
    80000fba:	6da2                	ld	s11,8(sp)
    80000fbc:	bfc1                	j	80000f8c <copyout+0x10c>
        return -1;
    80000fbe:	557d                	li	a0,-1
    80000fc0:	6946                	ld	s2,80(sp)
    80000fc2:	6a06                	ld	s4,64(sp)
    80000fc4:	7c02                	ld	s8,32(sp)
    80000fc6:	6ce2                	ld	s9,24(sp)
    80000fc8:	6d42                	ld	s10,16(sp)
    80000fca:	6da2                	ld	s11,8(sp)
    80000fcc:	b7c1                	j	80000f8c <copyout+0x10c>
      return -1;
    80000fce:	557d                	li	a0,-1
    80000fd0:	6946                	ld	s2,80(sp)
    80000fd2:	6a06                	ld	s4,64(sp)
    80000fd4:	7c02                	ld	s8,32(sp)
    80000fd6:	6ce2                	ld	s9,24(sp)
    80000fd8:	6d42                	ld	s10,16(sp)
    80000fda:	6da2                	ld	s11,8(sp)
    80000fdc:	bf45                	j	80000f8c <copyout+0x10c>

0000000080000fde <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000fde:	caa5                	beqz	a3,8000104e <copyin+0x70>
{
    80000fe0:	715d                	addi	sp,sp,-80
    80000fe2:	e486                	sd	ra,72(sp)
    80000fe4:	e0a2                	sd	s0,64(sp)
    80000fe6:	fc26                	sd	s1,56(sp)
    80000fe8:	f84a                	sd	s2,48(sp)
    80000fea:	f44e                	sd	s3,40(sp)
    80000fec:	f052                	sd	s4,32(sp)
    80000fee:	ec56                	sd	s5,24(sp)
    80000ff0:	e85a                	sd	s6,16(sp)
    80000ff2:	e45e                	sd	s7,8(sp)
    80000ff4:	e062                	sd	s8,0(sp)
    80000ff6:	0880                	addi	s0,sp,80
    80000ff8:	8b2a                	mv	s6,a0
    80000ffa:	8a2e                	mv	s4,a1
    80000ffc:	8c32                	mv	s8,a2
    80000ffe:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001000:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001002:	6a85                	lui	s5,0x1
    80001004:	a01d                	j	8000102a <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001006:	018505b3          	add	a1,a0,s8
    8000100a:	0004861b          	sext.w	a2,s1
    8000100e:	412585b3          	sub	a1,a1,s2
    80001012:	8552                	mv	a0,s4
    80001014:	fffff097          	auipc	ra,0xfffff
    80001018:	40c080e7          	jalr	1036(ra) # 80000420 <memmove>

    len -= n;
    8000101c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001020:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001022:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001026:	02098263          	beqz	s3,8000104a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    8000102a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000102e:	85ca                	mv	a1,s2
    80001030:	855a                	mv	a0,s6
    80001032:	fffff097          	auipc	ra,0xfffff
    80001036:	714080e7          	jalr	1812(ra) # 80000746 <walkaddr>
    if(pa0 == 0)
    8000103a:	cd01                	beqz	a0,80001052 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    8000103c:	418904b3          	sub	s1,s2,s8
    80001040:	94d6                	add	s1,s1,s5
    if(n > len)
    80001042:	fc99f2e3          	bgeu	s3,s1,80001006 <copyin+0x28>
    80001046:	84ce                	mv	s1,s3
    80001048:	bf7d                	j	80001006 <copyin+0x28>
  }
  return 0;
    8000104a:	4501                	li	a0,0
    8000104c:	a021                	j	80001054 <copyin+0x76>
    8000104e:	4501                	li	a0,0
}
    80001050:	8082                	ret
      return -1;
    80001052:	557d                	li	a0,-1
}
    80001054:	60a6                	ld	ra,72(sp)
    80001056:	6406                	ld	s0,64(sp)
    80001058:	74e2                	ld	s1,56(sp)
    8000105a:	7942                	ld	s2,48(sp)
    8000105c:	79a2                	ld	s3,40(sp)
    8000105e:	7a02                	ld	s4,32(sp)
    80001060:	6ae2                	ld	s5,24(sp)
    80001062:	6b42                	ld	s6,16(sp)
    80001064:	6ba2                	ld	s7,8(sp)
    80001066:	6c02                	ld	s8,0(sp)
    80001068:	6161                	addi	sp,sp,80
    8000106a:	8082                	ret

000000008000106c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000106c:	cacd                	beqz	a3,8000111e <copyinstr+0xb2>
{
    8000106e:	715d                	addi	sp,sp,-80
    80001070:	e486                	sd	ra,72(sp)
    80001072:	e0a2                	sd	s0,64(sp)
    80001074:	fc26                	sd	s1,56(sp)
    80001076:	f84a                	sd	s2,48(sp)
    80001078:	f44e                	sd	s3,40(sp)
    8000107a:	f052                	sd	s4,32(sp)
    8000107c:	ec56                	sd	s5,24(sp)
    8000107e:	e85a                	sd	s6,16(sp)
    80001080:	e45e                	sd	s7,8(sp)
    80001082:	0880                	addi	s0,sp,80
    80001084:	8a2a                	mv	s4,a0
    80001086:	8b2e                	mv	s6,a1
    80001088:	8bb2                	mv	s7,a2
    8000108a:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    8000108c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000108e:	6985                	lui	s3,0x1
    80001090:	a825                	j	800010c8 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001092:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001096:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001098:	37fd                	addiw	a5,a5,-1
    8000109a:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000109e:	60a6                	ld	ra,72(sp)
    800010a0:	6406                	ld	s0,64(sp)
    800010a2:	74e2                	ld	s1,56(sp)
    800010a4:	7942                	ld	s2,48(sp)
    800010a6:	79a2                	ld	s3,40(sp)
    800010a8:	7a02                	ld	s4,32(sp)
    800010aa:	6ae2                	ld	s5,24(sp)
    800010ac:	6b42                	ld	s6,16(sp)
    800010ae:	6ba2                	ld	s7,8(sp)
    800010b0:	6161                	addi	sp,sp,80
    800010b2:	8082                	ret
    800010b4:	fff90713          	addi	a4,s2,-1
    800010b8:	9742                	add	a4,a4,a6
      --max;
    800010ba:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    800010be:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    800010c2:	04e58663          	beq	a1,a4,8000110e <copyinstr+0xa2>
{
    800010c6:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    800010c8:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800010cc:	85a6                	mv	a1,s1
    800010ce:	8552                	mv	a0,s4
    800010d0:	fffff097          	auipc	ra,0xfffff
    800010d4:	676080e7          	jalr	1654(ra) # 80000746 <walkaddr>
    if(pa0 == 0)
    800010d8:	cd0d                	beqz	a0,80001112 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    800010da:	417486b3          	sub	a3,s1,s7
    800010de:	96ce                	add	a3,a3,s3
    if(n > max)
    800010e0:	00d97363          	bgeu	s2,a3,800010e6 <copyinstr+0x7a>
    800010e4:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    800010e6:	955e                	add	a0,a0,s7
    800010e8:	8d05                	sub	a0,a0,s1
    while(n > 0){
    800010ea:	c695                	beqz	a3,80001116 <copyinstr+0xaa>
    800010ec:	87da                	mv	a5,s6
    800010ee:	885a                	mv	a6,s6
      if(*p == '\0'){
    800010f0:	41650633          	sub	a2,a0,s6
    while(n > 0){
    800010f4:	96da                	add	a3,a3,s6
    800010f6:	85be                	mv	a1,a5
      if(*p == '\0'){
    800010f8:	00f60733          	add	a4,a2,a5
    800010fc:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffba660>
    80001100:	db49                	beqz	a4,80001092 <copyinstr+0x26>
        *dst = *p;
    80001102:	00e78023          	sb	a4,0(a5)
      dst++;
    80001106:	0785                	addi	a5,a5,1
    while(n > 0){
    80001108:	fed797e3          	bne	a5,a3,800010f6 <copyinstr+0x8a>
    8000110c:	b765                	j	800010b4 <copyinstr+0x48>
    8000110e:	4781                	li	a5,0
    80001110:	b761                	j	80001098 <copyinstr+0x2c>
      return -1;
    80001112:	557d                	li	a0,-1
    80001114:	b769                	j	8000109e <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80001116:	6b85                	lui	s7,0x1
    80001118:	9ba6                	add	s7,s7,s1
    8000111a:	87da                	mv	a5,s6
    8000111c:	b76d                	j	800010c6 <copyinstr+0x5a>
  int got_null = 0;
    8000111e:	4781                	li	a5,0
  if(got_null){
    80001120:	37fd                	addiw	a5,a5,-1
    80001122:	0007851b          	sext.w	a0,a5
}
    80001126:	8082                	ret

0000000080001128 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001128:	7139                	addi	sp,sp,-64
    8000112a:	fc06                	sd	ra,56(sp)
    8000112c:	f822                	sd	s0,48(sp)
    8000112e:	f426                	sd	s1,40(sp)
    80001130:	f04a                	sd	s2,32(sp)
    80001132:	ec4e                	sd	s3,24(sp)
    80001134:	e852                	sd	s4,16(sp)
    80001136:	e456                	sd	s5,8(sp)
    80001138:	e05a                	sd	s6,0(sp)
    8000113a:	0080                	addi	s0,sp,64
    8000113c:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000113e:	0002b497          	auipc	s1,0x2b
    80001142:	83a48493          	addi	s1,s1,-1990 # 8002b978 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001146:	8b26                	mv	s6,s1
    80001148:	04fa5937          	lui	s2,0x4fa5
    8000114c:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80001150:	0932                	slli	s2,s2,0xc
    80001152:	fa590913          	addi	s2,s2,-91
    80001156:	0932                	slli	s2,s2,0xc
    80001158:	fa590913          	addi	s2,s2,-91
    8000115c:	0932                	slli	s2,s2,0xc
    8000115e:	fa590913          	addi	s2,s2,-91
    80001162:	040009b7          	lui	s3,0x4000
    80001166:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001168:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000116a:	00030a97          	auipc	s5,0x30
    8000116e:	20ea8a93          	addi	s5,s5,526 # 80031378 <tickslock>
    char *pa = kalloc();
    80001172:	fffff097          	auipc	ra,0xfffff
    80001176:	0cc080e7          	jalr	204(ra) # 8000023e <kalloc>
    8000117a:	862a                	mv	a2,a0
    if(pa == 0)
    8000117c:	c121                	beqz	a0,800011bc <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    8000117e:	416485b3          	sub	a1,s1,s6
    80001182:	858d                	srai	a1,a1,0x3
    80001184:	032585b3          	mul	a1,a1,s2
    80001188:	2585                	addiw	a1,a1,1
    8000118a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000118e:	4719                	li	a4,6
    80001190:	6685                	lui	a3,0x1
    80001192:	40b985b3          	sub	a1,s3,a1
    80001196:	8552                	mv	a0,s4
    80001198:	fffff097          	auipc	ra,0xfffff
    8000119c:	6b4080e7          	jalr	1716(ra) # 8000084c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011a0:	16848493          	addi	s1,s1,360
    800011a4:	fd5497e3          	bne	s1,s5,80001172 <proc_mapstacks+0x4a>
  }
}
    800011a8:	70e2                	ld	ra,56(sp)
    800011aa:	7442                	ld	s0,48(sp)
    800011ac:	74a2                	ld	s1,40(sp)
    800011ae:	7902                	ld	s2,32(sp)
    800011b0:	69e2                	ld	s3,24(sp)
    800011b2:	6a42                	ld	s4,16(sp)
    800011b4:	6aa2                	ld	s5,8(sp)
    800011b6:	6b02                	ld	s6,0(sp)
    800011b8:	6121                	addi	sp,sp,64
    800011ba:	8082                	ret
      panic("kalloc");
    800011bc:	00007517          	auipc	a0,0x7
    800011c0:	03450513          	addi	a0,a0,52 # 800081f0 <etext+0x1f0>
    800011c4:	00005097          	auipc	ra,0x5
    800011c8:	0de080e7          	jalr	222(ra) # 800062a2 <panic>

00000000800011cc <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800011cc:	7139                	addi	sp,sp,-64
    800011ce:	fc06                	sd	ra,56(sp)
    800011d0:	f822                	sd	s0,48(sp)
    800011d2:	f426                	sd	s1,40(sp)
    800011d4:	f04a                	sd	s2,32(sp)
    800011d6:	ec4e                	sd	s3,24(sp)
    800011d8:	e852                	sd	s4,16(sp)
    800011da:	e456                	sd	s5,8(sp)
    800011dc:	e05a                	sd	s6,0(sp)
    800011de:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    800011e0:	00007597          	auipc	a1,0x7
    800011e4:	01858593          	addi	a1,a1,24 # 800081f8 <etext+0x1f8>
    800011e8:	0002a517          	auipc	a0,0x2a
    800011ec:	36050513          	addi	a0,a0,864 # 8002b548 <pid_lock>
    800011f0:	00005097          	auipc	ra,0x5
    800011f4:	59c080e7          	jalr	1436(ra) # 8000678c <initlock>
  initlock(&wait_lock, "wait_lock");
    800011f8:	00007597          	auipc	a1,0x7
    800011fc:	00858593          	addi	a1,a1,8 # 80008200 <etext+0x200>
    80001200:	0002a517          	auipc	a0,0x2a
    80001204:	36050513          	addi	a0,a0,864 # 8002b560 <wait_lock>
    80001208:	00005097          	auipc	ra,0x5
    8000120c:	584080e7          	jalr	1412(ra) # 8000678c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001210:	0002a497          	auipc	s1,0x2a
    80001214:	76848493          	addi	s1,s1,1896 # 8002b978 <proc>
      initlock(&p->lock, "proc");
    80001218:	00007b17          	auipc	s6,0x7
    8000121c:	ff8b0b13          	addi	s6,s6,-8 # 80008210 <etext+0x210>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001220:	8aa6                	mv	s5,s1
    80001222:	04fa5937          	lui	s2,0x4fa5
    80001226:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    8000122a:	0932                	slli	s2,s2,0xc
    8000122c:	fa590913          	addi	s2,s2,-91
    80001230:	0932                	slli	s2,s2,0xc
    80001232:	fa590913          	addi	s2,s2,-91
    80001236:	0932                	slli	s2,s2,0xc
    80001238:	fa590913          	addi	s2,s2,-91
    8000123c:	040009b7          	lui	s3,0x4000
    80001240:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001242:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001244:	00030a17          	auipc	s4,0x30
    80001248:	134a0a13          	addi	s4,s4,308 # 80031378 <tickslock>
      initlock(&p->lock, "proc");
    8000124c:	85da                	mv	a1,s6
    8000124e:	8526                	mv	a0,s1
    80001250:	00005097          	auipc	ra,0x5
    80001254:	53c080e7          	jalr	1340(ra) # 8000678c <initlock>
      p->state = UNUSED;
    80001258:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    8000125c:	415487b3          	sub	a5,s1,s5
    80001260:	878d                	srai	a5,a5,0x3
    80001262:	032787b3          	mul	a5,a5,s2
    80001266:	2785                	addiw	a5,a5,1
    80001268:	00d7979b          	slliw	a5,a5,0xd
    8000126c:	40f987b3          	sub	a5,s3,a5
    80001270:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001272:	16848493          	addi	s1,s1,360
    80001276:	fd449be3          	bne	s1,s4,8000124c <procinit+0x80>
  }
}
    8000127a:	70e2                	ld	ra,56(sp)
    8000127c:	7442                	ld	s0,48(sp)
    8000127e:	74a2                	ld	s1,40(sp)
    80001280:	7902                	ld	s2,32(sp)
    80001282:	69e2                	ld	s3,24(sp)
    80001284:	6a42                	ld	s4,16(sp)
    80001286:	6aa2                	ld	s5,8(sp)
    80001288:	6b02                	ld	s6,0(sp)
    8000128a:	6121                	addi	sp,sp,64
    8000128c:	8082                	ret

000000008000128e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    8000128e:	1141                	addi	sp,sp,-16
    80001290:	e422                	sd	s0,8(sp)
    80001292:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001294:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001296:	2501                	sext.w	a0,a0
    80001298:	6422                	ld	s0,8(sp)
    8000129a:	0141                	addi	sp,sp,16
    8000129c:	8082                	ret

000000008000129e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    8000129e:	1141                	addi	sp,sp,-16
    800012a0:	e422                	sd	s0,8(sp)
    800012a2:	0800                	addi	s0,sp,16
    800012a4:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800012a6:	2781                	sext.w	a5,a5
    800012a8:	079e                	slli	a5,a5,0x7
  return c;
}
    800012aa:	0002a517          	auipc	a0,0x2a
    800012ae:	2ce50513          	addi	a0,a0,718 # 8002b578 <cpus>
    800012b2:	953e                	add	a0,a0,a5
    800012b4:	6422                	ld	s0,8(sp)
    800012b6:	0141                	addi	sp,sp,16
    800012b8:	8082                	ret

00000000800012ba <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800012ba:	1101                	addi	sp,sp,-32
    800012bc:	ec06                	sd	ra,24(sp)
    800012be:	e822                	sd	s0,16(sp)
    800012c0:	e426                	sd	s1,8(sp)
    800012c2:	1000                	addi	s0,sp,32
  push_off();
    800012c4:	00005097          	auipc	ra,0x5
    800012c8:	50c080e7          	jalr	1292(ra) # 800067d0 <push_off>
    800012cc:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800012ce:	2781                	sext.w	a5,a5
    800012d0:	079e                	slli	a5,a5,0x7
    800012d2:	0002a717          	auipc	a4,0x2a
    800012d6:	27670713          	addi	a4,a4,630 # 8002b548 <pid_lock>
    800012da:	97ba                	add	a5,a5,a4
    800012dc:	7b84                	ld	s1,48(a5)
  pop_off();
    800012de:	00005097          	auipc	ra,0x5
    800012e2:	592080e7          	jalr	1426(ra) # 80006870 <pop_off>
  return p;
}
    800012e6:	8526                	mv	a0,s1
    800012e8:	60e2                	ld	ra,24(sp)
    800012ea:	6442                	ld	s0,16(sp)
    800012ec:	64a2                	ld	s1,8(sp)
    800012ee:	6105                	addi	sp,sp,32
    800012f0:	8082                	ret

00000000800012f2 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800012f2:	1141                	addi	sp,sp,-16
    800012f4:	e406                	sd	ra,8(sp)
    800012f6:	e022                	sd	s0,0(sp)
    800012f8:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800012fa:	00000097          	auipc	ra,0x0
    800012fe:	fc0080e7          	jalr	-64(ra) # 800012ba <myproc>
    80001302:	00005097          	auipc	ra,0x5
    80001306:	5ce080e7          	jalr	1486(ra) # 800068d0 <release>

  if (first) {
    8000130a:	0000a797          	auipc	a5,0xa
    8000130e:	1667a783          	lw	a5,358(a5) # 8000b470 <first.1>
    80001312:	eb89                	bnez	a5,80001324 <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001314:	00001097          	auipc	ra,0x1
    80001318:	c62080e7          	jalr	-926(ra) # 80001f76 <usertrapret>
}
    8000131c:	60a2                	ld	ra,8(sp)
    8000131e:	6402                	ld	s0,0(sp)
    80001320:	0141                	addi	sp,sp,16
    80001322:	8082                	ret
    fsinit(ROOTDEV);
    80001324:	4505                	li	a0,1
    80001326:	00002097          	auipc	ra,0x2
    8000132a:	b24080e7          	jalr	-1244(ra) # 80002e4a <fsinit>
    first = 0;
    8000132e:	0000a797          	auipc	a5,0xa
    80001332:	1407a123          	sw	zero,322(a5) # 8000b470 <first.1>
    __sync_synchronize();
    80001336:	0330000f          	fence	rw,rw
    8000133a:	bfe9                	j	80001314 <forkret+0x22>

000000008000133c <allocpid>:
{
    8000133c:	1101                	addi	sp,sp,-32
    8000133e:	ec06                	sd	ra,24(sp)
    80001340:	e822                	sd	s0,16(sp)
    80001342:	e426                	sd	s1,8(sp)
    80001344:	e04a                	sd	s2,0(sp)
    80001346:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001348:	0002a917          	auipc	s2,0x2a
    8000134c:	20090913          	addi	s2,s2,512 # 8002b548 <pid_lock>
    80001350:	854a                	mv	a0,s2
    80001352:	00005097          	auipc	ra,0x5
    80001356:	4ca080e7          	jalr	1226(ra) # 8000681c <acquire>
  pid = nextpid;
    8000135a:	0000a797          	auipc	a5,0xa
    8000135e:	11a78793          	addi	a5,a5,282 # 8000b474 <nextpid>
    80001362:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001364:	0014871b          	addiw	a4,s1,1
    80001368:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000136a:	854a                	mv	a0,s2
    8000136c:	00005097          	auipc	ra,0x5
    80001370:	564080e7          	jalr	1380(ra) # 800068d0 <release>
}
    80001374:	8526                	mv	a0,s1
    80001376:	60e2                	ld	ra,24(sp)
    80001378:	6442                	ld	s0,16(sp)
    8000137a:	64a2                	ld	s1,8(sp)
    8000137c:	6902                	ld	s2,0(sp)
    8000137e:	6105                	addi	sp,sp,32
    80001380:	8082                	ret

0000000080001382 <proc_pagetable>:
{
    80001382:	1101                	addi	sp,sp,-32
    80001384:	ec06                	sd	ra,24(sp)
    80001386:	e822                	sd	s0,16(sp)
    80001388:	e426                	sd	s1,8(sp)
    8000138a:	e04a                	sd	s2,0(sp)
    8000138c:	1000                	addi	s0,sp,32
    8000138e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001390:	fffff097          	auipc	ra,0xfffff
    80001394:	6b6080e7          	jalr	1718(ra) # 80000a46 <uvmcreate>
    80001398:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000139a:	c121                	beqz	a0,800013da <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000139c:	4729                	li	a4,10
    8000139e:	00006697          	auipc	a3,0x6
    800013a2:	c6268693          	addi	a3,a3,-926 # 80007000 <_trampoline>
    800013a6:	6605                	lui	a2,0x1
    800013a8:	040005b7          	lui	a1,0x4000
    800013ac:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800013ae:	05b2                	slli	a1,a1,0xc
    800013b0:	fffff097          	auipc	ra,0xfffff
    800013b4:	3d8080e7          	jalr	984(ra) # 80000788 <mappages>
    800013b8:	02054863          	bltz	a0,800013e8 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800013bc:	4719                	li	a4,6
    800013be:	05893683          	ld	a3,88(s2)
    800013c2:	6605                	lui	a2,0x1
    800013c4:	020005b7          	lui	a1,0x2000
    800013c8:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800013ca:	05b6                	slli	a1,a1,0xd
    800013cc:	8526                	mv	a0,s1
    800013ce:	fffff097          	auipc	ra,0xfffff
    800013d2:	3ba080e7          	jalr	954(ra) # 80000788 <mappages>
    800013d6:	02054163          	bltz	a0,800013f8 <proc_pagetable+0x76>
}
    800013da:	8526                	mv	a0,s1
    800013dc:	60e2                	ld	ra,24(sp)
    800013de:	6442                	ld	s0,16(sp)
    800013e0:	64a2                	ld	s1,8(sp)
    800013e2:	6902                	ld	s2,0(sp)
    800013e4:	6105                	addi	sp,sp,32
    800013e6:	8082                	ret
    uvmfree(pagetable, 0);
    800013e8:	4581                	li	a1,0
    800013ea:	8526                	mv	a0,s1
    800013ec:	00000097          	auipc	ra,0x0
    800013f0:	86c080e7          	jalr	-1940(ra) # 80000c58 <uvmfree>
    return 0;
    800013f4:	4481                	li	s1,0
    800013f6:	b7d5                	j	800013da <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800013f8:	4681                	li	a3,0
    800013fa:	4605                	li	a2,1
    800013fc:	040005b7          	lui	a1,0x4000
    80001400:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001402:	05b2                	slli	a1,a1,0xc
    80001404:	8526                	mv	a0,s1
    80001406:	fffff097          	auipc	ra,0xfffff
    8000140a:	56c080e7          	jalr	1388(ra) # 80000972 <uvmunmap>
    uvmfree(pagetable, 0);
    8000140e:	4581                	li	a1,0
    80001410:	8526                	mv	a0,s1
    80001412:	00000097          	auipc	ra,0x0
    80001416:	846080e7          	jalr	-1978(ra) # 80000c58 <uvmfree>
    return 0;
    8000141a:	4481                	li	s1,0
    8000141c:	bf7d                	j	800013da <proc_pagetable+0x58>

000000008000141e <proc_freepagetable>:
{
    8000141e:	1101                	addi	sp,sp,-32
    80001420:	ec06                	sd	ra,24(sp)
    80001422:	e822                	sd	s0,16(sp)
    80001424:	e426                	sd	s1,8(sp)
    80001426:	e04a                	sd	s2,0(sp)
    80001428:	1000                	addi	s0,sp,32
    8000142a:	84aa                	mv	s1,a0
    8000142c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000142e:	4681                	li	a3,0
    80001430:	4605                	li	a2,1
    80001432:	040005b7          	lui	a1,0x4000
    80001436:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001438:	05b2                	slli	a1,a1,0xc
    8000143a:	fffff097          	auipc	ra,0xfffff
    8000143e:	538080e7          	jalr	1336(ra) # 80000972 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001442:	4681                	li	a3,0
    80001444:	4605                	li	a2,1
    80001446:	020005b7          	lui	a1,0x2000
    8000144a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000144c:	05b6                	slli	a1,a1,0xd
    8000144e:	8526                	mv	a0,s1
    80001450:	fffff097          	auipc	ra,0xfffff
    80001454:	522080e7          	jalr	1314(ra) # 80000972 <uvmunmap>
  uvmfree(pagetable, sz);
    80001458:	85ca                	mv	a1,s2
    8000145a:	8526                	mv	a0,s1
    8000145c:	fffff097          	auipc	ra,0xfffff
    80001460:	7fc080e7          	jalr	2044(ra) # 80000c58 <uvmfree>
}
    80001464:	60e2                	ld	ra,24(sp)
    80001466:	6442                	ld	s0,16(sp)
    80001468:	64a2                	ld	s1,8(sp)
    8000146a:	6902                	ld	s2,0(sp)
    8000146c:	6105                	addi	sp,sp,32
    8000146e:	8082                	ret

0000000080001470 <freeproc>:
{
    80001470:	1101                	addi	sp,sp,-32
    80001472:	ec06                	sd	ra,24(sp)
    80001474:	e822                	sd	s0,16(sp)
    80001476:	e426                	sd	s1,8(sp)
    80001478:	1000                	addi	s0,sp,32
    8000147a:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000147c:	6d28                	ld	a0,88(a0)
    8000147e:	c509                	beqz	a0,80001488 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001480:	fffff097          	auipc	ra,0xfffff
    80001484:	b9c080e7          	jalr	-1124(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001488:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000148c:	68a8                	ld	a0,80(s1)
    8000148e:	c511                	beqz	a0,8000149a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001490:	64ac                	ld	a1,72(s1)
    80001492:	00000097          	auipc	ra,0x0
    80001496:	f8c080e7          	jalr	-116(ra) # 8000141e <proc_freepagetable>
  p->pagetable = 0;
    8000149a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000149e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800014a2:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800014a6:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800014aa:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800014ae:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800014b2:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800014b6:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800014ba:	0004ac23          	sw	zero,24(s1)
}
    800014be:	60e2                	ld	ra,24(sp)
    800014c0:	6442                	ld	s0,16(sp)
    800014c2:	64a2                	ld	s1,8(sp)
    800014c4:	6105                	addi	sp,sp,32
    800014c6:	8082                	ret

00000000800014c8 <allocproc>:
{
    800014c8:	1101                	addi	sp,sp,-32
    800014ca:	ec06                	sd	ra,24(sp)
    800014cc:	e822                	sd	s0,16(sp)
    800014ce:	e426                	sd	s1,8(sp)
    800014d0:	e04a                	sd	s2,0(sp)
    800014d2:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800014d4:	0002a497          	auipc	s1,0x2a
    800014d8:	4a448493          	addi	s1,s1,1188 # 8002b978 <proc>
    800014dc:	00030917          	auipc	s2,0x30
    800014e0:	e9c90913          	addi	s2,s2,-356 # 80031378 <tickslock>
    acquire(&p->lock);
    800014e4:	8526                	mv	a0,s1
    800014e6:	00005097          	auipc	ra,0x5
    800014ea:	336080e7          	jalr	822(ra) # 8000681c <acquire>
    if(p->state == UNUSED) {
    800014ee:	4c9c                	lw	a5,24(s1)
    800014f0:	cf81                	beqz	a5,80001508 <allocproc+0x40>
      release(&p->lock);
    800014f2:	8526                	mv	a0,s1
    800014f4:	00005097          	auipc	ra,0x5
    800014f8:	3dc080e7          	jalr	988(ra) # 800068d0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800014fc:	16848493          	addi	s1,s1,360
    80001500:	ff2492e3          	bne	s1,s2,800014e4 <allocproc+0x1c>
  return 0;
    80001504:	4481                	li	s1,0
    80001506:	a889                	j	80001558 <allocproc+0x90>
  p->pid = allocpid();
    80001508:	00000097          	auipc	ra,0x0
    8000150c:	e34080e7          	jalr	-460(ra) # 8000133c <allocpid>
    80001510:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001512:	4785                	li	a5,1
    80001514:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001516:	fffff097          	auipc	ra,0xfffff
    8000151a:	d28080e7          	jalr	-728(ra) # 8000023e <kalloc>
    8000151e:	892a                	mv	s2,a0
    80001520:	eca8                	sd	a0,88(s1)
    80001522:	c131                	beqz	a0,80001566 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001524:	8526                	mv	a0,s1
    80001526:	00000097          	auipc	ra,0x0
    8000152a:	e5c080e7          	jalr	-420(ra) # 80001382 <proc_pagetable>
    8000152e:	892a                	mv	s2,a0
    80001530:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001532:	c531                	beqz	a0,8000157e <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001534:	07000613          	li	a2,112
    80001538:	4581                	li	a1,0
    8000153a:	06048513          	addi	a0,s1,96
    8000153e:	fffff097          	auipc	ra,0xfffff
    80001542:	e86080e7          	jalr	-378(ra) # 800003c4 <memset>
  p->context.ra = (uint64)forkret;
    80001546:	00000797          	auipc	a5,0x0
    8000154a:	dac78793          	addi	a5,a5,-596 # 800012f2 <forkret>
    8000154e:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001550:	60bc                	ld	a5,64(s1)
    80001552:	6705                	lui	a4,0x1
    80001554:	97ba                	add	a5,a5,a4
    80001556:	f4bc                	sd	a5,104(s1)
}
    80001558:	8526                	mv	a0,s1
    8000155a:	60e2                	ld	ra,24(sp)
    8000155c:	6442                	ld	s0,16(sp)
    8000155e:	64a2                	ld	s1,8(sp)
    80001560:	6902                	ld	s2,0(sp)
    80001562:	6105                	addi	sp,sp,32
    80001564:	8082                	ret
    freeproc(p);
    80001566:	8526                	mv	a0,s1
    80001568:	00000097          	auipc	ra,0x0
    8000156c:	f08080e7          	jalr	-248(ra) # 80001470 <freeproc>
    release(&p->lock);
    80001570:	8526                	mv	a0,s1
    80001572:	00005097          	auipc	ra,0x5
    80001576:	35e080e7          	jalr	862(ra) # 800068d0 <release>
    return 0;
    8000157a:	84ca                	mv	s1,s2
    8000157c:	bff1                	j	80001558 <allocproc+0x90>
    freeproc(p);
    8000157e:	8526                	mv	a0,s1
    80001580:	00000097          	auipc	ra,0x0
    80001584:	ef0080e7          	jalr	-272(ra) # 80001470 <freeproc>
    release(&p->lock);
    80001588:	8526                	mv	a0,s1
    8000158a:	00005097          	auipc	ra,0x5
    8000158e:	346080e7          	jalr	838(ra) # 800068d0 <release>
    return 0;
    80001592:	84ca                	mv	s1,s2
    80001594:	b7d1                	j	80001558 <allocproc+0x90>

0000000080001596 <userinit>:
{
    80001596:	1101                	addi	sp,sp,-32
    80001598:	ec06                	sd	ra,24(sp)
    8000159a:	e822                	sd	s0,16(sp)
    8000159c:	e426                	sd	s1,8(sp)
    8000159e:	1000                	addi	s0,sp,32
  p = allocproc();
    800015a0:	00000097          	auipc	ra,0x0
    800015a4:	f28080e7          	jalr	-216(ra) # 800014c8 <allocproc>
    800015a8:	84aa                	mv	s1,a0
  initproc = p;
    800015aa:	0000a797          	auipc	a5,0xa
    800015ae:	f4a7b323          	sd	a0,-186(a5) # 8000b4f0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800015b2:	03400613          	li	a2,52
    800015b6:	0000a597          	auipc	a1,0xa
    800015ba:	eca58593          	addi	a1,a1,-310 # 8000b480 <initcode>
    800015be:	6928                	ld	a0,80(a0)
    800015c0:	fffff097          	auipc	ra,0xfffff
    800015c4:	4b4080e7          	jalr	1204(ra) # 80000a74 <uvmfirst>
  p->sz = PGSIZE;
    800015c8:	6785                	lui	a5,0x1
    800015ca:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800015cc:	6cb8                	ld	a4,88(s1)
    800015ce:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800015d2:	6cb8                	ld	a4,88(s1)
    800015d4:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800015d6:	4641                	li	a2,16
    800015d8:	00007597          	auipc	a1,0x7
    800015dc:	c4058593          	addi	a1,a1,-960 # 80008218 <etext+0x218>
    800015e0:	15848513          	addi	a0,s1,344
    800015e4:	fffff097          	auipc	ra,0xfffff
    800015e8:	f22080e7          	jalr	-222(ra) # 80000506 <safestrcpy>
  p->cwd = namei("/");
    800015ec:	00007517          	auipc	a0,0x7
    800015f0:	c3c50513          	addi	a0,a0,-964 # 80008228 <etext+0x228>
    800015f4:	00002097          	auipc	ra,0x2
    800015f8:	2a8080e7          	jalr	680(ra) # 8000389c <namei>
    800015fc:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001600:	478d                	li	a5,3
    80001602:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001604:	8526                	mv	a0,s1
    80001606:	00005097          	auipc	ra,0x5
    8000160a:	2ca080e7          	jalr	714(ra) # 800068d0 <release>
}
    8000160e:	60e2                	ld	ra,24(sp)
    80001610:	6442                	ld	s0,16(sp)
    80001612:	64a2                	ld	s1,8(sp)
    80001614:	6105                	addi	sp,sp,32
    80001616:	8082                	ret

0000000080001618 <growproc>:
{
    80001618:	1101                	addi	sp,sp,-32
    8000161a:	ec06                	sd	ra,24(sp)
    8000161c:	e822                	sd	s0,16(sp)
    8000161e:	e426                	sd	s1,8(sp)
    80001620:	e04a                	sd	s2,0(sp)
    80001622:	1000                	addi	s0,sp,32
    80001624:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001626:	00000097          	auipc	ra,0x0
    8000162a:	c94080e7          	jalr	-876(ra) # 800012ba <myproc>
    8000162e:	84aa                	mv	s1,a0
  sz = p->sz;
    80001630:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001632:	01204c63          	bgtz	s2,8000164a <growproc+0x32>
  } else if(n < 0){
    80001636:	02094663          	bltz	s2,80001662 <growproc+0x4a>
  p->sz = sz;
    8000163a:	e4ac                	sd	a1,72(s1)
  return 0;
    8000163c:	4501                	li	a0,0
}
    8000163e:	60e2                	ld	ra,24(sp)
    80001640:	6442                	ld	s0,16(sp)
    80001642:	64a2                	ld	s1,8(sp)
    80001644:	6902                	ld	s2,0(sp)
    80001646:	6105                	addi	sp,sp,32
    80001648:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000164a:	4691                	li	a3,4
    8000164c:	00b90633          	add	a2,s2,a1
    80001650:	6928                	ld	a0,80(a0)
    80001652:	fffff097          	auipc	ra,0xfffff
    80001656:	4dc080e7          	jalr	1244(ra) # 80000b2e <uvmalloc>
    8000165a:	85aa                	mv	a1,a0
    8000165c:	fd79                	bnez	a0,8000163a <growproc+0x22>
      return -1;
    8000165e:	557d                	li	a0,-1
    80001660:	bff9                	j	8000163e <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001662:	00b90633          	add	a2,s2,a1
    80001666:	6928                	ld	a0,80(a0)
    80001668:	fffff097          	auipc	ra,0xfffff
    8000166c:	47e080e7          	jalr	1150(ra) # 80000ae6 <uvmdealloc>
    80001670:	85aa                	mv	a1,a0
    80001672:	b7e1                	j	8000163a <growproc+0x22>

0000000080001674 <fork>:
{
    80001674:	7139                	addi	sp,sp,-64
    80001676:	fc06                	sd	ra,56(sp)
    80001678:	f822                	sd	s0,48(sp)
    8000167a:	f04a                	sd	s2,32(sp)
    8000167c:	e456                	sd	s5,8(sp)
    8000167e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001680:	00000097          	auipc	ra,0x0
    80001684:	c3a080e7          	jalr	-966(ra) # 800012ba <myproc>
    80001688:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000168a:	00000097          	auipc	ra,0x0
    8000168e:	e3e080e7          	jalr	-450(ra) # 800014c8 <allocproc>
    80001692:	12050063          	beqz	a0,800017b2 <fork+0x13e>
    80001696:	e852                	sd	s4,16(sp)
    80001698:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000169a:	048ab603          	ld	a2,72(s5)
    8000169e:	692c                	ld	a1,80(a0)
    800016a0:	050ab503          	ld	a0,80(s5)
    800016a4:	fffff097          	auipc	ra,0xfffff
    800016a8:	5ee080e7          	jalr	1518(ra) # 80000c92 <uvmcopy>
    800016ac:	04054a63          	bltz	a0,80001700 <fork+0x8c>
    800016b0:	f426                	sd	s1,40(sp)
    800016b2:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800016b4:	048ab783          	ld	a5,72(s5)
    800016b8:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800016bc:	058ab683          	ld	a3,88(s5)
    800016c0:	87b6                	mv	a5,a3
    800016c2:	058a3703          	ld	a4,88(s4)
    800016c6:	12068693          	addi	a3,a3,288
    800016ca:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800016ce:	6788                	ld	a0,8(a5)
    800016d0:	6b8c                	ld	a1,16(a5)
    800016d2:	6f90                	ld	a2,24(a5)
    800016d4:	01073023          	sd	a6,0(a4)
    800016d8:	e708                	sd	a0,8(a4)
    800016da:	eb0c                	sd	a1,16(a4)
    800016dc:	ef10                	sd	a2,24(a4)
    800016de:	02078793          	addi	a5,a5,32
    800016e2:	02070713          	addi	a4,a4,32
    800016e6:	fed792e3          	bne	a5,a3,800016ca <fork+0x56>
  np->trapframe->a0 = 0;
    800016ea:	058a3783          	ld	a5,88(s4)
    800016ee:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800016f2:	0d0a8493          	addi	s1,s5,208
    800016f6:	0d0a0913          	addi	s2,s4,208
    800016fa:	150a8993          	addi	s3,s5,336
    800016fe:	a015                	j	80001722 <fork+0xae>
    freeproc(np);
    80001700:	8552                	mv	a0,s4
    80001702:	00000097          	auipc	ra,0x0
    80001706:	d6e080e7          	jalr	-658(ra) # 80001470 <freeproc>
    release(&np->lock);
    8000170a:	8552                	mv	a0,s4
    8000170c:	00005097          	auipc	ra,0x5
    80001710:	1c4080e7          	jalr	452(ra) # 800068d0 <release>
    return -1;
    80001714:	597d                	li	s2,-1
    80001716:	6a42                	ld	s4,16(sp)
    80001718:	a071                	j	800017a4 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    8000171a:	04a1                	addi	s1,s1,8
    8000171c:	0921                	addi	s2,s2,8
    8000171e:	01348b63          	beq	s1,s3,80001734 <fork+0xc0>
    if(p->ofile[i])
    80001722:	6088                	ld	a0,0(s1)
    80001724:	d97d                	beqz	a0,8000171a <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001726:	00002097          	auipc	ra,0x2
    8000172a:	7ee080e7          	jalr	2030(ra) # 80003f14 <filedup>
    8000172e:	00a93023          	sd	a0,0(s2)
    80001732:	b7e5                	j	8000171a <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001734:	150ab503          	ld	a0,336(s5)
    80001738:	00002097          	auipc	ra,0x2
    8000173c:	958080e7          	jalr	-1704(ra) # 80003090 <idup>
    80001740:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001744:	4641                	li	a2,16
    80001746:	158a8593          	addi	a1,s5,344
    8000174a:	158a0513          	addi	a0,s4,344
    8000174e:	fffff097          	auipc	ra,0xfffff
    80001752:	db8080e7          	jalr	-584(ra) # 80000506 <safestrcpy>
  pid = np->pid;
    80001756:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000175a:	8552                	mv	a0,s4
    8000175c:	00005097          	auipc	ra,0x5
    80001760:	174080e7          	jalr	372(ra) # 800068d0 <release>
  acquire(&wait_lock);
    80001764:	0002a497          	auipc	s1,0x2a
    80001768:	dfc48493          	addi	s1,s1,-516 # 8002b560 <wait_lock>
    8000176c:	8526                	mv	a0,s1
    8000176e:	00005097          	auipc	ra,0x5
    80001772:	0ae080e7          	jalr	174(ra) # 8000681c <acquire>
  np->parent = p;
    80001776:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000177a:	8526                	mv	a0,s1
    8000177c:	00005097          	auipc	ra,0x5
    80001780:	154080e7          	jalr	340(ra) # 800068d0 <release>
  acquire(&np->lock);
    80001784:	8552                	mv	a0,s4
    80001786:	00005097          	auipc	ra,0x5
    8000178a:	096080e7          	jalr	150(ra) # 8000681c <acquire>
  np->state = RUNNABLE;
    8000178e:	478d                	li	a5,3
    80001790:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001794:	8552                	mv	a0,s4
    80001796:	00005097          	auipc	ra,0x5
    8000179a:	13a080e7          	jalr	314(ra) # 800068d0 <release>
  return pid;
    8000179e:	74a2                	ld	s1,40(sp)
    800017a0:	69e2                	ld	s3,24(sp)
    800017a2:	6a42                	ld	s4,16(sp)
}
    800017a4:	854a                	mv	a0,s2
    800017a6:	70e2                	ld	ra,56(sp)
    800017a8:	7442                	ld	s0,48(sp)
    800017aa:	7902                	ld	s2,32(sp)
    800017ac:	6aa2                	ld	s5,8(sp)
    800017ae:	6121                	addi	sp,sp,64
    800017b0:	8082                	ret
    return -1;
    800017b2:	597d                	li	s2,-1
    800017b4:	bfc5                	j	800017a4 <fork+0x130>

00000000800017b6 <scheduler>:
{
    800017b6:	7139                	addi	sp,sp,-64
    800017b8:	fc06                	sd	ra,56(sp)
    800017ba:	f822                	sd	s0,48(sp)
    800017bc:	f426                	sd	s1,40(sp)
    800017be:	f04a                	sd	s2,32(sp)
    800017c0:	ec4e                	sd	s3,24(sp)
    800017c2:	e852                	sd	s4,16(sp)
    800017c4:	e456                	sd	s5,8(sp)
    800017c6:	e05a                	sd	s6,0(sp)
    800017c8:	0080                	addi	s0,sp,64
    800017ca:	8792                	mv	a5,tp
  int id = r_tp();
    800017cc:	2781                	sext.w	a5,a5
  c->proc = 0;
    800017ce:	00779a93          	slli	s5,a5,0x7
    800017d2:	0002a717          	auipc	a4,0x2a
    800017d6:	d7670713          	addi	a4,a4,-650 # 8002b548 <pid_lock>
    800017da:	9756                	add	a4,a4,s5
    800017dc:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800017e0:	0002a717          	auipc	a4,0x2a
    800017e4:	da070713          	addi	a4,a4,-608 # 8002b580 <cpus+0x8>
    800017e8:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800017ea:	498d                	li	s3,3
        p->state = RUNNING;
    800017ec:	4b11                	li	s6,4
        c->proc = p;
    800017ee:	079e                	slli	a5,a5,0x7
    800017f0:	0002aa17          	auipc	s4,0x2a
    800017f4:	d58a0a13          	addi	s4,s4,-680 # 8002b548 <pid_lock>
    800017f8:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800017fa:	00030917          	auipc	s2,0x30
    800017fe:	b7e90913          	addi	s2,s2,-1154 # 80031378 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001802:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001806:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000180a:	10079073          	csrw	sstatus,a5
    8000180e:	0002a497          	auipc	s1,0x2a
    80001812:	16a48493          	addi	s1,s1,362 # 8002b978 <proc>
    80001816:	a811                	j	8000182a <scheduler+0x74>
      release(&p->lock);
    80001818:	8526                	mv	a0,s1
    8000181a:	00005097          	auipc	ra,0x5
    8000181e:	0b6080e7          	jalr	182(ra) # 800068d0 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001822:	16848493          	addi	s1,s1,360
    80001826:	fd248ee3          	beq	s1,s2,80001802 <scheduler+0x4c>
      acquire(&p->lock);
    8000182a:	8526                	mv	a0,s1
    8000182c:	00005097          	auipc	ra,0x5
    80001830:	ff0080e7          	jalr	-16(ra) # 8000681c <acquire>
      if(p->state == RUNNABLE) {
    80001834:	4c9c                	lw	a5,24(s1)
    80001836:	ff3791e3          	bne	a5,s3,80001818 <scheduler+0x62>
        p->state = RUNNING;
    8000183a:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000183e:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001842:	06048593          	addi	a1,s1,96
    80001846:	8556                	mv	a0,s5
    80001848:	00000097          	auipc	ra,0x0
    8000184c:	684080e7          	jalr	1668(ra) # 80001ecc <swtch>
        c->proc = 0;
    80001850:	020a3823          	sd	zero,48(s4)
    80001854:	b7d1                	j	80001818 <scheduler+0x62>

0000000080001856 <sched>:
{
    80001856:	7179                	addi	sp,sp,-48
    80001858:	f406                	sd	ra,40(sp)
    8000185a:	f022                	sd	s0,32(sp)
    8000185c:	ec26                	sd	s1,24(sp)
    8000185e:	e84a                	sd	s2,16(sp)
    80001860:	e44e                	sd	s3,8(sp)
    80001862:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001864:	00000097          	auipc	ra,0x0
    80001868:	a56080e7          	jalr	-1450(ra) # 800012ba <myproc>
    8000186c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000186e:	00005097          	auipc	ra,0x5
    80001872:	f34080e7          	jalr	-204(ra) # 800067a2 <holding>
    80001876:	c93d                	beqz	a0,800018ec <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001878:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000187a:	2781                	sext.w	a5,a5
    8000187c:	079e                	slli	a5,a5,0x7
    8000187e:	0002a717          	auipc	a4,0x2a
    80001882:	cca70713          	addi	a4,a4,-822 # 8002b548 <pid_lock>
    80001886:	97ba                	add	a5,a5,a4
    80001888:	0a87a703          	lw	a4,168(a5)
    8000188c:	4785                	li	a5,1
    8000188e:	06f71763          	bne	a4,a5,800018fc <sched+0xa6>
  if(p->state == RUNNING)
    80001892:	4c98                	lw	a4,24(s1)
    80001894:	4791                	li	a5,4
    80001896:	06f70b63          	beq	a4,a5,8000190c <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000189a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000189e:	8b89                	andi	a5,a5,2
  if(intr_get())
    800018a0:	efb5                	bnez	a5,8000191c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800018a2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800018a4:	0002a917          	auipc	s2,0x2a
    800018a8:	ca490913          	addi	s2,s2,-860 # 8002b548 <pid_lock>
    800018ac:	2781                	sext.w	a5,a5
    800018ae:	079e                	slli	a5,a5,0x7
    800018b0:	97ca                	add	a5,a5,s2
    800018b2:	0ac7a983          	lw	s3,172(a5)
    800018b6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800018b8:	2781                	sext.w	a5,a5
    800018ba:	079e                	slli	a5,a5,0x7
    800018bc:	0002a597          	auipc	a1,0x2a
    800018c0:	cc458593          	addi	a1,a1,-828 # 8002b580 <cpus+0x8>
    800018c4:	95be                	add	a1,a1,a5
    800018c6:	06048513          	addi	a0,s1,96
    800018ca:	00000097          	auipc	ra,0x0
    800018ce:	602080e7          	jalr	1538(ra) # 80001ecc <swtch>
    800018d2:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800018d4:	2781                	sext.w	a5,a5
    800018d6:	079e                	slli	a5,a5,0x7
    800018d8:	993e                	add	s2,s2,a5
    800018da:	0b392623          	sw	s3,172(s2)
}
    800018de:	70a2                	ld	ra,40(sp)
    800018e0:	7402                	ld	s0,32(sp)
    800018e2:	64e2                	ld	s1,24(sp)
    800018e4:	6942                	ld	s2,16(sp)
    800018e6:	69a2                	ld	s3,8(sp)
    800018e8:	6145                	addi	sp,sp,48
    800018ea:	8082                	ret
    panic("sched p->lock");
    800018ec:	00007517          	auipc	a0,0x7
    800018f0:	94450513          	addi	a0,a0,-1724 # 80008230 <etext+0x230>
    800018f4:	00005097          	auipc	ra,0x5
    800018f8:	9ae080e7          	jalr	-1618(ra) # 800062a2 <panic>
    panic("sched locks");
    800018fc:	00007517          	auipc	a0,0x7
    80001900:	94450513          	addi	a0,a0,-1724 # 80008240 <etext+0x240>
    80001904:	00005097          	auipc	ra,0x5
    80001908:	99e080e7          	jalr	-1634(ra) # 800062a2 <panic>
    panic("sched running");
    8000190c:	00007517          	auipc	a0,0x7
    80001910:	94450513          	addi	a0,a0,-1724 # 80008250 <etext+0x250>
    80001914:	00005097          	auipc	ra,0x5
    80001918:	98e080e7          	jalr	-1650(ra) # 800062a2 <panic>
    panic("sched interruptible");
    8000191c:	00007517          	auipc	a0,0x7
    80001920:	94450513          	addi	a0,a0,-1724 # 80008260 <etext+0x260>
    80001924:	00005097          	auipc	ra,0x5
    80001928:	97e080e7          	jalr	-1666(ra) # 800062a2 <panic>

000000008000192c <yield>:
{
    8000192c:	1101                	addi	sp,sp,-32
    8000192e:	ec06                	sd	ra,24(sp)
    80001930:	e822                	sd	s0,16(sp)
    80001932:	e426                	sd	s1,8(sp)
    80001934:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001936:	00000097          	auipc	ra,0x0
    8000193a:	984080e7          	jalr	-1660(ra) # 800012ba <myproc>
    8000193e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001940:	00005097          	auipc	ra,0x5
    80001944:	edc080e7          	jalr	-292(ra) # 8000681c <acquire>
  p->state = RUNNABLE;
    80001948:	478d                	li	a5,3
    8000194a:	cc9c                	sw	a5,24(s1)
  sched();
    8000194c:	00000097          	auipc	ra,0x0
    80001950:	f0a080e7          	jalr	-246(ra) # 80001856 <sched>
  release(&p->lock);
    80001954:	8526                	mv	a0,s1
    80001956:	00005097          	auipc	ra,0x5
    8000195a:	f7a080e7          	jalr	-134(ra) # 800068d0 <release>
}
    8000195e:	60e2                	ld	ra,24(sp)
    80001960:	6442                	ld	s0,16(sp)
    80001962:	64a2                	ld	s1,8(sp)
    80001964:	6105                	addi	sp,sp,32
    80001966:	8082                	ret

0000000080001968 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001968:	7179                	addi	sp,sp,-48
    8000196a:	f406                	sd	ra,40(sp)
    8000196c:	f022                	sd	s0,32(sp)
    8000196e:	ec26                	sd	s1,24(sp)
    80001970:	e84a                	sd	s2,16(sp)
    80001972:	e44e                	sd	s3,8(sp)
    80001974:	1800                	addi	s0,sp,48
    80001976:	89aa                	mv	s3,a0
    80001978:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000197a:	00000097          	auipc	ra,0x0
    8000197e:	940080e7          	jalr	-1728(ra) # 800012ba <myproc>
    80001982:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001984:	00005097          	auipc	ra,0x5
    80001988:	e98080e7          	jalr	-360(ra) # 8000681c <acquire>
  release(lk);
    8000198c:	854a                	mv	a0,s2
    8000198e:	00005097          	auipc	ra,0x5
    80001992:	f42080e7          	jalr	-190(ra) # 800068d0 <release>

  // Go to sleep.
  p->chan = chan;
    80001996:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000199a:	4789                	li	a5,2
    8000199c:	cc9c                	sw	a5,24(s1)

  sched();
    8000199e:	00000097          	auipc	ra,0x0
    800019a2:	eb8080e7          	jalr	-328(ra) # 80001856 <sched>

  // Tidy up.
  p->chan = 0;
    800019a6:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800019aa:	8526                	mv	a0,s1
    800019ac:	00005097          	auipc	ra,0x5
    800019b0:	f24080e7          	jalr	-220(ra) # 800068d0 <release>
  acquire(lk);
    800019b4:	854a                	mv	a0,s2
    800019b6:	00005097          	auipc	ra,0x5
    800019ba:	e66080e7          	jalr	-410(ra) # 8000681c <acquire>
}
    800019be:	70a2                	ld	ra,40(sp)
    800019c0:	7402                	ld	s0,32(sp)
    800019c2:	64e2                	ld	s1,24(sp)
    800019c4:	6942                	ld	s2,16(sp)
    800019c6:	69a2                	ld	s3,8(sp)
    800019c8:	6145                	addi	sp,sp,48
    800019ca:	8082                	ret

00000000800019cc <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800019cc:	7139                	addi	sp,sp,-64
    800019ce:	fc06                	sd	ra,56(sp)
    800019d0:	f822                	sd	s0,48(sp)
    800019d2:	f426                	sd	s1,40(sp)
    800019d4:	f04a                	sd	s2,32(sp)
    800019d6:	ec4e                	sd	s3,24(sp)
    800019d8:	e852                	sd	s4,16(sp)
    800019da:	e456                	sd	s5,8(sp)
    800019dc:	0080                	addi	s0,sp,64
    800019de:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800019e0:	0002a497          	auipc	s1,0x2a
    800019e4:	f9848493          	addi	s1,s1,-104 # 8002b978 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800019e8:	4989                	li	s3,2
        p->state = RUNNABLE;
    800019ea:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800019ec:	00030917          	auipc	s2,0x30
    800019f0:	98c90913          	addi	s2,s2,-1652 # 80031378 <tickslock>
    800019f4:	a811                	j	80001a08 <wakeup+0x3c>
      }
      release(&p->lock);
    800019f6:	8526                	mv	a0,s1
    800019f8:	00005097          	auipc	ra,0x5
    800019fc:	ed8080e7          	jalr	-296(ra) # 800068d0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a00:	16848493          	addi	s1,s1,360
    80001a04:	03248663          	beq	s1,s2,80001a30 <wakeup+0x64>
    if(p != myproc()){
    80001a08:	00000097          	auipc	ra,0x0
    80001a0c:	8b2080e7          	jalr	-1870(ra) # 800012ba <myproc>
    80001a10:	fea488e3          	beq	s1,a0,80001a00 <wakeup+0x34>
      acquire(&p->lock);
    80001a14:	8526                	mv	a0,s1
    80001a16:	00005097          	auipc	ra,0x5
    80001a1a:	e06080e7          	jalr	-506(ra) # 8000681c <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001a1e:	4c9c                	lw	a5,24(s1)
    80001a20:	fd379be3          	bne	a5,s3,800019f6 <wakeup+0x2a>
    80001a24:	709c                	ld	a5,32(s1)
    80001a26:	fd4798e3          	bne	a5,s4,800019f6 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001a2a:	0154ac23          	sw	s5,24(s1)
    80001a2e:	b7e1                	j	800019f6 <wakeup+0x2a>
    }
  }
}
    80001a30:	70e2                	ld	ra,56(sp)
    80001a32:	7442                	ld	s0,48(sp)
    80001a34:	74a2                	ld	s1,40(sp)
    80001a36:	7902                	ld	s2,32(sp)
    80001a38:	69e2                	ld	s3,24(sp)
    80001a3a:	6a42                	ld	s4,16(sp)
    80001a3c:	6aa2                	ld	s5,8(sp)
    80001a3e:	6121                	addi	sp,sp,64
    80001a40:	8082                	ret

0000000080001a42 <reparent>:
{
    80001a42:	7179                	addi	sp,sp,-48
    80001a44:	f406                	sd	ra,40(sp)
    80001a46:	f022                	sd	s0,32(sp)
    80001a48:	ec26                	sd	s1,24(sp)
    80001a4a:	e84a                	sd	s2,16(sp)
    80001a4c:	e44e                	sd	s3,8(sp)
    80001a4e:	e052                	sd	s4,0(sp)
    80001a50:	1800                	addi	s0,sp,48
    80001a52:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a54:	0002a497          	auipc	s1,0x2a
    80001a58:	f2448493          	addi	s1,s1,-220 # 8002b978 <proc>
      pp->parent = initproc;
    80001a5c:	0000aa17          	auipc	s4,0xa
    80001a60:	a94a0a13          	addi	s4,s4,-1388 # 8000b4f0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a64:	00030997          	auipc	s3,0x30
    80001a68:	91498993          	addi	s3,s3,-1772 # 80031378 <tickslock>
    80001a6c:	a029                	j	80001a76 <reparent+0x34>
    80001a6e:	16848493          	addi	s1,s1,360
    80001a72:	01348d63          	beq	s1,s3,80001a8c <reparent+0x4a>
    if(pp->parent == p){
    80001a76:	7c9c                	ld	a5,56(s1)
    80001a78:	ff279be3          	bne	a5,s2,80001a6e <reparent+0x2c>
      pp->parent = initproc;
    80001a7c:	000a3503          	ld	a0,0(s4)
    80001a80:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001a82:	00000097          	auipc	ra,0x0
    80001a86:	f4a080e7          	jalr	-182(ra) # 800019cc <wakeup>
    80001a8a:	b7d5                	j	80001a6e <reparent+0x2c>
}
    80001a8c:	70a2                	ld	ra,40(sp)
    80001a8e:	7402                	ld	s0,32(sp)
    80001a90:	64e2                	ld	s1,24(sp)
    80001a92:	6942                	ld	s2,16(sp)
    80001a94:	69a2                	ld	s3,8(sp)
    80001a96:	6a02                	ld	s4,0(sp)
    80001a98:	6145                	addi	sp,sp,48
    80001a9a:	8082                	ret

0000000080001a9c <exit>:
{
    80001a9c:	7179                	addi	sp,sp,-48
    80001a9e:	f406                	sd	ra,40(sp)
    80001aa0:	f022                	sd	s0,32(sp)
    80001aa2:	ec26                	sd	s1,24(sp)
    80001aa4:	e84a                	sd	s2,16(sp)
    80001aa6:	e44e                	sd	s3,8(sp)
    80001aa8:	e052                	sd	s4,0(sp)
    80001aaa:	1800                	addi	s0,sp,48
    80001aac:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001aae:	00000097          	auipc	ra,0x0
    80001ab2:	80c080e7          	jalr	-2036(ra) # 800012ba <myproc>
    80001ab6:	89aa                	mv	s3,a0
  if(p == initproc)
    80001ab8:	0000a797          	auipc	a5,0xa
    80001abc:	a387b783          	ld	a5,-1480(a5) # 8000b4f0 <initproc>
    80001ac0:	0d050493          	addi	s1,a0,208
    80001ac4:	15050913          	addi	s2,a0,336
    80001ac8:	02a79363          	bne	a5,a0,80001aee <exit+0x52>
    panic("init exiting");
    80001acc:	00006517          	auipc	a0,0x6
    80001ad0:	7ac50513          	addi	a0,a0,1964 # 80008278 <etext+0x278>
    80001ad4:	00004097          	auipc	ra,0x4
    80001ad8:	7ce080e7          	jalr	1998(ra) # 800062a2 <panic>
      fileclose(f);
    80001adc:	00002097          	auipc	ra,0x2
    80001ae0:	48a080e7          	jalr	1162(ra) # 80003f66 <fileclose>
      p->ofile[fd] = 0;
    80001ae4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001ae8:	04a1                	addi	s1,s1,8
    80001aea:	01248563          	beq	s1,s2,80001af4 <exit+0x58>
    if(p->ofile[fd]){
    80001aee:	6088                	ld	a0,0(s1)
    80001af0:	f575                	bnez	a0,80001adc <exit+0x40>
    80001af2:	bfdd                	j	80001ae8 <exit+0x4c>
  begin_op();
    80001af4:	00002097          	auipc	ra,0x2
    80001af8:	fa8080e7          	jalr	-88(ra) # 80003a9c <begin_op>
  iput(p->cwd);
    80001afc:	1509b503          	ld	a0,336(s3)
    80001b00:	00001097          	auipc	ra,0x1
    80001b04:	78c080e7          	jalr	1932(ra) # 8000328c <iput>
  end_op();
    80001b08:	00002097          	auipc	ra,0x2
    80001b0c:	00e080e7          	jalr	14(ra) # 80003b16 <end_op>
  p->cwd = 0;
    80001b10:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001b14:	0002a497          	auipc	s1,0x2a
    80001b18:	a4c48493          	addi	s1,s1,-1460 # 8002b560 <wait_lock>
    80001b1c:	8526                	mv	a0,s1
    80001b1e:	00005097          	auipc	ra,0x5
    80001b22:	cfe080e7          	jalr	-770(ra) # 8000681c <acquire>
  reparent(p);
    80001b26:	854e                	mv	a0,s3
    80001b28:	00000097          	auipc	ra,0x0
    80001b2c:	f1a080e7          	jalr	-230(ra) # 80001a42 <reparent>
  wakeup(p->parent);
    80001b30:	0389b503          	ld	a0,56(s3)
    80001b34:	00000097          	auipc	ra,0x0
    80001b38:	e98080e7          	jalr	-360(ra) # 800019cc <wakeup>
  acquire(&p->lock);
    80001b3c:	854e                	mv	a0,s3
    80001b3e:	00005097          	auipc	ra,0x5
    80001b42:	cde080e7          	jalr	-802(ra) # 8000681c <acquire>
  p->xstate = status;
    80001b46:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001b4a:	4795                	li	a5,5
    80001b4c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001b50:	8526                	mv	a0,s1
    80001b52:	00005097          	auipc	ra,0x5
    80001b56:	d7e080e7          	jalr	-642(ra) # 800068d0 <release>
  sched();
    80001b5a:	00000097          	auipc	ra,0x0
    80001b5e:	cfc080e7          	jalr	-772(ra) # 80001856 <sched>
  panic("zombie exit");
    80001b62:	00006517          	auipc	a0,0x6
    80001b66:	72650513          	addi	a0,a0,1830 # 80008288 <etext+0x288>
    80001b6a:	00004097          	auipc	ra,0x4
    80001b6e:	738080e7          	jalr	1848(ra) # 800062a2 <panic>

0000000080001b72 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001b72:	7179                	addi	sp,sp,-48
    80001b74:	f406                	sd	ra,40(sp)
    80001b76:	f022                	sd	s0,32(sp)
    80001b78:	ec26                	sd	s1,24(sp)
    80001b7a:	e84a                	sd	s2,16(sp)
    80001b7c:	e44e                	sd	s3,8(sp)
    80001b7e:	1800                	addi	s0,sp,48
    80001b80:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001b82:	0002a497          	auipc	s1,0x2a
    80001b86:	df648493          	addi	s1,s1,-522 # 8002b978 <proc>
    80001b8a:	0002f997          	auipc	s3,0x2f
    80001b8e:	7ee98993          	addi	s3,s3,2030 # 80031378 <tickslock>
    acquire(&p->lock);
    80001b92:	8526                	mv	a0,s1
    80001b94:	00005097          	auipc	ra,0x5
    80001b98:	c88080e7          	jalr	-888(ra) # 8000681c <acquire>
    if(p->pid == pid){
    80001b9c:	589c                	lw	a5,48(s1)
    80001b9e:	01278d63          	beq	a5,s2,80001bb8 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001ba2:	8526                	mv	a0,s1
    80001ba4:	00005097          	auipc	ra,0x5
    80001ba8:	d2c080e7          	jalr	-724(ra) # 800068d0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bac:	16848493          	addi	s1,s1,360
    80001bb0:	ff3491e3          	bne	s1,s3,80001b92 <kill+0x20>
  }
  return -1;
    80001bb4:	557d                	li	a0,-1
    80001bb6:	a829                	j	80001bd0 <kill+0x5e>
      p->killed = 1;
    80001bb8:	4785                	li	a5,1
    80001bba:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001bbc:	4c98                	lw	a4,24(s1)
    80001bbe:	4789                	li	a5,2
    80001bc0:	00f70f63          	beq	a4,a5,80001bde <kill+0x6c>
      release(&p->lock);
    80001bc4:	8526                	mv	a0,s1
    80001bc6:	00005097          	auipc	ra,0x5
    80001bca:	d0a080e7          	jalr	-758(ra) # 800068d0 <release>
      return 0;
    80001bce:	4501                	li	a0,0
}
    80001bd0:	70a2                	ld	ra,40(sp)
    80001bd2:	7402                	ld	s0,32(sp)
    80001bd4:	64e2                	ld	s1,24(sp)
    80001bd6:	6942                	ld	s2,16(sp)
    80001bd8:	69a2                	ld	s3,8(sp)
    80001bda:	6145                	addi	sp,sp,48
    80001bdc:	8082                	ret
        p->state = RUNNABLE;
    80001bde:	478d                	li	a5,3
    80001be0:	cc9c                	sw	a5,24(s1)
    80001be2:	b7cd                	j	80001bc4 <kill+0x52>

0000000080001be4 <setkilled>:

void
setkilled(struct proc *p)
{
    80001be4:	1101                	addi	sp,sp,-32
    80001be6:	ec06                	sd	ra,24(sp)
    80001be8:	e822                	sd	s0,16(sp)
    80001bea:	e426                	sd	s1,8(sp)
    80001bec:	1000                	addi	s0,sp,32
    80001bee:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001bf0:	00005097          	auipc	ra,0x5
    80001bf4:	c2c080e7          	jalr	-980(ra) # 8000681c <acquire>
  p->killed = 1;
    80001bf8:	4785                	li	a5,1
    80001bfa:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001bfc:	8526                	mv	a0,s1
    80001bfe:	00005097          	auipc	ra,0x5
    80001c02:	cd2080e7          	jalr	-814(ra) # 800068d0 <release>
}
    80001c06:	60e2                	ld	ra,24(sp)
    80001c08:	6442                	ld	s0,16(sp)
    80001c0a:	64a2                	ld	s1,8(sp)
    80001c0c:	6105                	addi	sp,sp,32
    80001c0e:	8082                	ret

0000000080001c10 <killed>:

int
killed(struct proc *p)
{
    80001c10:	1101                	addi	sp,sp,-32
    80001c12:	ec06                	sd	ra,24(sp)
    80001c14:	e822                	sd	s0,16(sp)
    80001c16:	e426                	sd	s1,8(sp)
    80001c18:	e04a                	sd	s2,0(sp)
    80001c1a:	1000                	addi	s0,sp,32
    80001c1c:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001c1e:	00005097          	auipc	ra,0x5
    80001c22:	bfe080e7          	jalr	-1026(ra) # 8000681c <acquire>
  k = p->killed;
    80001c26:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001c2a:	8526                	mv	a0,s1
    80001c2c:	00005097          	auipc	ra,0x5
    80001c30:	ca4080e7          	jalr	-860(ra) # 800068d0 <release>
  return k;
}
    80001c34:	854a                	mv	a0,s2
    80001c36:	60e2                	ld	ra,24(sp)
    80001c38:	6442                	ld	s0,16(sp)
    80001c3a:	64a2                	ld	s1,8(sp)
    80001c3c:	6902                	ld	s2,0(sp)
    80001c3e:	6105                	addi	sp,sp,32
    80001c40:	8082                	ret

0000000080001c42 <wait>:
{
    80001c42:	715d                	addi	sp,sp,-80
    80001c44:	e486                	sd	ra,72(sp)
    80001c46:	e0a2                	sd	s0,64(sp)
    80001c48:	fc26                	sd	s1,56(sp)
    80001c4a:	f84a                	sd	s2,48(sp)
    80001c4c:	f44e                	sd	s3,40(sp)
    80001c4e:	f052                	sd	s4,32(sp)
    80001c50:	ec56                	sd	s5,24(sp)
    80001c52:	e85a                	sd	s6,16(sp)
    80001c54:	e45e                	sd	s7,8(sp)
    80001c56:	e062                	sd	s8,0(sp)
    80001c58:	0880                	addi	s0,sp,80
    80001c5a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001c5c:	fffff097          	auipc	ra,0xfffff
    80001c60:	65e080e7          	jalr	1630(ra) # 800012ba <myproc>
    80001c64:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001c66:	0002a517          	auipc	a0,0x2a
    80001c6a:	8fa50513          	addi	a0,a0,-1798 # 8002b560 <wait_lock>
    80001c6e:	00005097          	auipc	ra,0x5
    80001c72:	bae080e7          	jalr	-1106(ra) # 8000681c <acquire>
    havekids = 0;
    80001c76:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001c78:	4a15                	li	s4,5
        havekids = 1;
    80001c7a:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001c7c:	0002f997          	auipc	s3,0x2f
    80001c80:	6fc98993          	addi	s3,s3,1788 # 80031378 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001c84:	0002ac17          	auipc	s8,0x2a
    80001c88:	8dcc0c13          	addi	s8,s8,-1828 # 8002b560 <wait_lock>
    80001c8c:	a0d1                	j	80001d50 <wait+0x10e>
          pid = pp->pid;
    80001c8e:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001c92:	000b0e63          	beqz	s6,80001cae <wait+0x6c>
    80001c96:	4691                	li	a3,4
    80001c98:	02c48613          	addi	a2,s1,44
    80001c9c:	85da                	mv	a1,s6
    80001c9e:	05093503          	ld	a0,80(s2)
    80001ca2:	fffff097          	auipc	ra,0xfffff
    80001ca6:	1de080e7          	jalr	478(ra) # 80000e80 <copyout>
    80001caa:	04054163          	bltz	a0,80001cec <wait+0xaa>
          freeproc(pp);
    80001cae:	8526                	mv	a0,s1
    80001cb0:	fffff097          	auipc	ra,0xfffff
    80001cb4:	7c0080e7          	jalr	1984(ra) # 80001470 <freeproc>
          release(&pp->lock);
    80001cb8:	8526                	mv	a0,s1
    80001cba:	00005097          	auipc	ra,0x5
    80001cbe:	c16080e7          	jalr	-1002(ra) # 800068d0 <release>
          release(&wait_lock);
    80001cc2:	0002a517          	auipc	a0,0x2a
    80001cc6:	89e50513          	addi	a0,a0,-1890 # 8002b560 <wait_lock>
    80001cca:	00005097          	auipc	ra,0x5
    80001cce:	c06080e7          	jalr	-1018(ra) # 800068d0 <release>
}
    80001cd2:	854e                	mv	a0,s3
    80001cd4:	60a6                	ld	ra,72(sp)
    80001cd6:	6406                	ld	s0,64(sp)
    80001cd8:	74e2                	ld	s1,56(sp)
    80001cda:	7942                	ld	s2,48(sp)
    80001cdc:	79a2                	ld	s3,40(sp)
    80001cde:	7a02                	ld	s4,32(sp)
    80001ce0:	6ae2                	ld	s5,24(sp)
    80001ce2:	6b42                	ld	s6,16(sp)
    80001ce4:	6ba2                	ld	s7,8(sp)
    80001ce6:	6c02                	ld	s8,0(sp)
    80001ce8:	6161                	addi	sp,sp,80
    80001cea:	8082                	ret
            release(&pp->lock);
    80001cec:	8526                	mv	a0,s1
    80001cee:	00005097          	auipc	ra,0x5
    80001cf2:	be2080e7          	jalr	-1054(ra) # 800068d0 <release>
            release(&wait_lock);
    80001cf6:	0002a517          	auipc	a0,0x2a
    80001cfa:	86a50513          	addi	a0,a0,-1942 # 8002b560 <wait_lock>
    80001cfe:	00005097          	auipc	ra,0x5
    80001d02:	bd2080e7          	jalr	-1070(ra) # 800068d0 <release>
            return -1;
    80001d06:	59fd                	li	s3,-1
    80001d08:	b7e9                	j	80001cd2 <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001d0a:	16848493          	addi	s1,s1,360
    80001d0e:	03348463          	beq	s1,s3,80001d36 <wait+0xf4>
      if(pp->parent == p){
    80001d12:	7c9c                	ld	a5,56(s1)
    80001d14:	ff279be3          	bne	a5,s2,80001d0a <wait+0xc8>
        acquire(&pp->lock);
    80001d18:	8526                	mv	a0,s1
    80001d1a:	00005097          	auipc	ra,0x5
    80001d1e:	b02080e7          	jalr	-1278(ra) # 8000681c <acquire>
        if(pp->state == ZOMBIE){
    80001d22:	4c9c                	lw	a5,24(s1)
    80001d24:	f74785e3          	beq	a5,s4,80001c8e <wait+0x4c>
        release(&pp->lock);
    80001d28:	8526                	mv	a0,s1
    80001d2a:	00005097          	auipc	ra,0x5
    80001d2e:	ba6080e7          	jalr	-1114(ra) # 800068d0 <release>
        havekids = 1;
    80001d32:	8756                	mv	a4,s5
    80001d34:	bfd9                	j	80001d0a <wait+0xc8>
    if(!havekids || killed(p)){
    80001d36:	c31d                	beqz	a4,80001d5c <wait+0x11a>
    80001d38:	854a                	mv	a0,s2
    80001d3a:	00000097          	auipc	ra,0x0
    80001d3e:	ed6080e7          	jalr	-298(ra) # 80001c10 <killed>
    80001d42:	ed09                	bnez	a0,80001d5c <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001d44:	85e2                	mv	a1,s8
    80001d46:	854a                	mv	a0,s2
    80001d48:	00000097          	auipc	ra,0x0
    80001d4c:	c20080e7          	jalr	-992(ra) # 80001968 <sleep>
    havekids = 0;
    80001d50:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001d52:	0002a497          	auipc	s1,0x2a
    80001d56:	c2648493          	addi	s1,s1,-986 # 8002b978 <proc>
    80001d5a:	bf65                	j	80001d12 <wait+0xd0>
      release(&wait_lock);
    80001d5c:	0002a517          	auipc	a0,0x2a
    80001d60:	80450513          	addi	a0,a0,-2044 # 8002b560 <wait_lock>
    80001d64:	00005097          	auipc	ra,0x5
    80001d68:	b6c080e7          	jalr	-1172(ra) # 800068d0 <release>
      return -1;
    80001d6c:	59fd                	li	s3,-1
    80001d6e:	b795                	j	80001cd2 <wait+0x90>

0000000080001d70 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001d70:	7179                	addi	sp,sp,-48
    80001d72:	f406                	sd	ra,40(sp)
    80001d74:	f022                	sd	s0,32(sp)
    80001d76:	ec26                	sd	s1,24(sp)
    80001d78:	e84a                	sd	s2,16(sp)
    80001d7a:	e44e                	sd	s3,8(sp)
    80001d7c:	e052                	sd	s4,0(sp)
    80001d7e:	1800                	addi	s0,sp,48
    80001d80:	84aa                	mv	s1,a0
    80001d82:	892e                	mv	s2,a1
    80001d84:	89b2                	mv	s3,a2
    80001d86:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001d88:	fffff097          	auipc	ra,0xfffff
    80001d8c:	532080e7          	jalr	1330(ra) # 800012ba <myproc>
  if(user_dst){
    80001d90:	c08d                	beqz	s1,80001db2 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001d92:	86d2                	mv	a3,s4
    80001d94:	864e                	mv	a2,s3
    80001d96:	85ca                	mv	a1,s2
    80001d98:	6928                	ld	a0,80(a0)
    80001d9a:	fffff097          	auipc	ra,0xfffff
    80001d9e:	0e6080e7          	jalr	230(ra) # 80000e80 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001da2:	70a2                	ld	ra,40(sp)
    80001da4:	7402                	ld	s0,32(sp)
    80001da6:	64e2                	ld	s1,24(sp)
    80001da8:	6942                	ld	s2,16(sp)
    80001daa:	69a2                	ld	s3,8(sp)
    80001dac:	6a02                	ld	s4,0(sp)
    80001dae:	6145                	addi	sp,sp,48
    80001db0:	8082                	ret
    memmove((char *)dst, src, len);
    80001db2:	000a061b          	sext.w	a2,s4
    80001db6:	85ce                	mv	a1,s3
    80001db8:	854a                	mv	a0,s2
    80001dba:	ffffe097          	auipc	ra,0xffffe
    80001dbe:	666080e7          	jalr	1638(ra) # 80000420 <memmove>
    return 0;
    80001dc2:	8526                	mv	a0,s1
    80001dc4:	bff9                	j	80001da2 <either_copyout+0x32>

0000000080001dc6 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001dc6:	7179                	addi	sp,sp,-48
    80001dc8:	f406                	sd	ra,40(sp)
    80001dca:	f022                	sd	s0,32(sp)
    80001dcc:	ec26                	sd	s1,24(sp)
    80001dce:	e84a                	sd	s2,16(sp)
    80001dd0:	e44e                	sd	s3,8(sp)
    80001dd2:	e052                	sd	s4,0(sp)
    80001dd4:	1800                	addi	s0,sp,48
    80001dd6:	892a                	mv	s2,a0
    80001dd8:	84ae                	mv	s1,a1
    80001dda:	89b2                	mv	s3,a2
    80001ddc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001dde:	fffff097          	auipc	ra,0xfffff
    80001de2:	4dc080e7          	jalr	1244(ra) # 800012ba <myproc>
  if(user_src){
    80001de6:	c08d                	beqz	s1,80001e08 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001de8:	86d2                	mv	a3,s4
    80001dea:	864e                	mv	a2,s3
    80001dec:	85ca                	mv	a1,s2
    80001dee:	6928                	ld	a0,80(a0)
    80001df0:	fffff097          	auipc	ra,0xfffff
    80001df4:	1ee080e7          	jalr	494(ra) # 80000fde <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001df8:	70a2                	ld	ra,40(sp)
    80001dfa:	7402                	ld	s0,32(sp)
    80001dfc:	64e2                	ld	s1,24(sp)
    80001dfe:	6942                	ld	s2,16(sp)
    80001e00:	69a2                	ld	s3,8(sp)
    80001e02:	6a02                	ld	s4,0(sp)
    80001e04:	6145                	addi	sp,sp,48
    80001e06:	8082                	ret
    memmove(dst, (char*)src, len);
    80001e08:	000a061b          	sext.w	a2,s4
    80001e0c:	85ce                	mv	a1,s3
    80001e0e:	854a                	mv	a0,s2
    80001e10:	ffffe097          	auipc	ra,0xffffe
    80001e14:	610080e7          	jalr	1552(ra) # 80000420 <memmove>
    return 0;
    80001e18:	8526                	mv	a0,s1
    80001e1a:	bff9                	j	80001df8 <either_copyin+0x32>

0000000080001e1c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001e1c:	715d                	addi	sp,sp,-80
    80001e1e:	e486                	sd	ra,72(sp)
    80001e20:	e0a2                	sd	s0,64(sp)
    80001e22:	fc26                	sd	s1,56(sp)
    80001e24:	f84a                	sd	s2,48(sp)
    80001e26:	f44e                	sd	s3,40(sp)
    80001e28:	f052                	sd	s4,32(sp)
    80001e2a:	ec56                	sd	s5,24(sp)
    80001e2c:	e85a                	sd	s6,16(sp)
    80001e2e:	e45e                	sd	s7,8(sp)
    80001e30:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001e32:	00006517          	auipc	a0,0x6
    80001e36:	23e50513          	addi	a0,a0,574 # 80008070 <etext+0x70>
    80001e3a:	00004097          	auipc	ra,0x4
    80001e3e:	4b2080e7          	jalr	1202(ra) # 800062ec <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001e42:	0002a497          	auipc	s1,0x2a
    80001e46:	c8e48493          	addi	s1,s1,-882 # 8002bad0 <proc+0x158>
    80001e4a:	0002f917          	auipc	s2,0x2f
    80001e4e:	68690913          	addi	s2,s2,1670 # 800314d0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001e52:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001e54:	00006997          	auipc	s3,0x6
    80001e58:	44498993          	addi	s3,s3,1092 # 80008298 <etext+0x298>
    printf("%d %s %s", p->pid, state, p->name);
    80001e5c:	00006a97          	auipc	s5,0x6
    80001e60:	444a8a93          	addi	s5,s5,1092 # 800082a0 <etext+0x2a0>
    printf("\n");
    80001e64:	00006a17          	auipc	s4,0x6
    80001e68:	20ca0a13          	addi	s4,s4,524 # 80008070 <etext+0x70>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001e6c:	00007b97          	auipc	s7,0x7
    80001e70:	a5cb8b93          	addi	s7,s7,-1444 # 800088c8 <states.0>
    80001e74:	a00d                	j	80001e96 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001e76:	ed86a583          	lw	a1,-296(a3)
    80001e7a:	8556                	mv	a0,s5
    80001e7c:	00004097          	auipc	ra,0x4
    80001e80:	470080e7          	jalr	1136(ra) # 800062ec <printf>
    printf("\n");
    80001e84:	8552                	mv	a0,s4
    80001e86:	00004097          	auipc	ra,0x4
    80001e8a:	466080e7          	jalr	1126(ra) # 800062ec <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001e8e:	16848493          	addi	s1,s1,360
    80001e92:	03248263          	beq	s1,s2,80001eb6 <procdump+0x9a>
    if(p->state == UNUSED)
    80001e96:	86a6                	mv	a3,s1
    80001e98:	ec04a783          	lw	a5,-320(s1)
    80001e9c:	dbed                	beqz	a5,80001e8e <procdump+0x72>
      state = "???";
    80001e9e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ea0:	fcfb6be3          	bltu	s6,a5,80001e76 <procdump+0x5a>
    80001ea4:	02079713          	slli	a4,a5,0x20
    80001ea8:	01d75793          	srli	a5,a4,0x1d
    80001eac:	97de                	add	a5,a5,s7
    80001eae:	6390                	ld	a2,0(a5)
    80001eb0:	f279                	bnez	a2,80001e76 <procdump+0x5a>
      state = "???";
    80001eb2:	864e                	mv	a2,s3
    80001eb4:	b7c9                	j	80001e76 <procdump+0x5a>
  }
}
    80001eb6:	60a6                	ld	ra,72(sp)
    80001eb8:	6406                	ld	s0,64(sp)
    80001eba:	74e2                	ld	s1,56(sp)
    80001ebc:	7942                	ld	s2,48(sp)
    80001ebe:	79a2                	ld	s3,40(sp)
    80001ec0:	7a02                	ld	s4,32(sp)
    80001ec2:	6ae2                	ld	s5,24(sp)
    80001ec4:	6b42                	ld	s6,16(sp)
    80001ec6:	6ba2                	ld	s7,8(sp)
    80001ec8:	6161                	addi	sp,sp,80
    80001eca:	8082                	ret

0000000080001ecc <swtch>:
    80001ecc:	00153023          	sd	ra,0(a0)
    80001ed0:	00253423          	sd	sp,8(a0)
    80001ed4:	e900                	sd	s0,16(a0)
    80001ed6:	ed04                	sd	s1,24(a0)
    80001ed8:	03253023          	sd	s2,32(a0)
    80001edc:	03353423          	sd	s3,40(a0)
    80001ee0:	03453823          	sd	s4,48(a0)
    80001ee4:	03553c23          	sd	s5,56(a0)
    80001ee8:	05653023          	sd	s6,64(a0)
    80001eec:	05753423          	sd	s7,72(a0)
    80001ef0:	05853823          	sd	s8,80(a0)
    80001ef4:	05953c23          	sd	s9,88(a0)
    80001ef8:	07a53023          	sd	s10,96(a0)
    80001efc:	07b53423          	sd	s11,104(a0)
    80001f00:	0005b083          	ld	ra,0(a1)
    80001f04:	0085b103          	ld	sp,8(a1)
    80001f08:	6980                	ld	s0,16(a1)
    80001f0a:	6d84                	ld	s1,24(a1)
    80001f0c:	0205b903          	ld	s2,32(a1)
    80001f10:	0285b983          	ld	s3,40(a1)
    80001f14:	0305ba03          	ld	s4,48(a1)
    80001f18:	0385ba83          	ld	s5,56(a1)
    80001f1c:	0405bb03          	ld	s6,64(a1)
    80001f20:	0485bb83          	ld	s7,72(a1)
    80001f24:	0505bc03          	ld	s8,80(a1)
    80001f28:	0585bc83          	ld	s9,88(a1)
    80001f2c:	0605bd03          	ld	s10,96(a1)
    80001f30:	0685bd83          	ld	s11,104(a1)
    80001f34:	8082                	ret

0000000080001f36 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001f36:	1141                	addi	sp,sp,-16
    80001f38:	e406                	sd	ra,8(sp)
    80001f3a:	e022                	sd	s0,0(sp)
    80001f3c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001f3e:	00006597          	auipc	a1,0x6
    80001f42:	3a258593          	addi	a1,a1,930 # 800082e0 <etext+0x2e0>
    80001f46:	0002f517          	auipc	a0,0x2f
    80001f4a:	43250513          	addi	a0,a0,1074 # 80031378 <tickslock>
    80001f4e:	00005097          	auipc	ra,0x5
    80001f52:	83e080e7          	jalr	-1986(ra) # 8000678c <initlock>
}
    80001f56:	60a2                	ld	ra,8(sp)
    80001f58:	6402                	ld	s0,0(sp)
    80001f5a:	0141                	addi	sp,sp,16
    80001f5c:	8082                	ret

0000000080001f5e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001f5e:	1141                	addi	sp,sp,-16
    80001f60:	e422                	sd	s0,8(sp)
    80001f62:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001f64:	00003797          	auipc	a5,0x3
    80001f68:	70c78793          	addi	a5,a5,1804 # 80005670 <kernelvec>
    80001f6c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001f70:	6422                	ld	s0,8(sp)
    80001f72:	0141                	addi	sp,sp,16
    80001f74:	8082                	ret

0000000080001f76 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001f76:	1141                	addi	sp,sp,-16
    80001f78:	e406                	sd	ra,8(sp)
    80001f7a:	e022                	sd	s0,0(sp)
    80001f7c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001f7e:	fffff097          	auipc	ra,0xfffff
    80001f82:	33c080e7          	jalr	828(ra) # 800012ba <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f86:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001f8a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f8c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001f90:	00005697          	auipc	a3,0x5
    80001f94:	07068693          	addi	a3,a3,112 # 80007000 <_trampoline>
    80001f98:	00005717          	auipc	a4,0x5
    80001f9c:	06870713          	addi	a4,a4,104 # 80007000 <_trampoline>
    80001fa0:	8f15                	sub	a4,a4,a3
    80001fa2:	040007b7          	lui	a5,0x4000
    80001fa6:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001fa8:	07b2                	slli	a5,a5,0xc
    80001faa:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001fac:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001fb0:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001fb2:	18002673          	csrr	a2,satp
    80001fb6:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001fb8:	6d30                	ld	a2,88(a0)
    80001fba:	6138                	ld	a4,64(a0)
    80001fbc:	6585                	lui	a1,0x1
    80001fbe:	972e                	add	a4,a4,a1
    80001fc0:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001fc2:	6d38                	ld	a4,88(a0)
    80001fc4:	00000617          	auipc	a2,0x0
    80001fc8:	13860613          	addi	a2,a2,312 # 800020fc <usertrap>
    80001fcc:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001fce:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001fd0:	8612                	mv	a2,tp
    80001fd2:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fd4:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001fd8:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001fdc:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fe0:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001fe4:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001fe6:	6f18                	ld	a4,24(a4)
    80001fe8:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001fec:	6928                	ld	a0,80(a0)
    80001fee:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001ff0:	00005717          	auipc	a4,0x5
    80001ff4:	0ac70713          	addi	a4,a4,172 # 8000709c <userret>
    80001ff8:	8f15                	sub	a4,a4,a3
    80001ffa:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001ffc:	577d                	li	a4,-1
    80001ffe:	177e                	slli	a4,a4,0x3f
    80002000:	8d59                	or	a0,a0,a4
    80002002:	9782                	jalr	a5
}
    80002004:	60a2                	ld	ra,8(sp)
    80002006:	6402                	ld	s0,0(sp)
    80002008:	0141                	addi	sp,sp,16
    8000200a:	8082                	ret

000000008000200c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000200c:	1101                	addi	sp,sp,-32
    8000200e:	ec06                	sd	ra,24(sp)
    80002010:	e822                	sd	s0,16(sp)
    80002012:	e426                	sd	s1,8(sp)
    80002014:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002016:	0002f497          	auipc	s1,0x2f
    8000201a:	36248493          	addi	s1,s1,866 # 80031378 <tickslock>
    8000201e:	8526                	mv	a0,s1
    80002020:	00004097          	auipc	ra,0x4
    80002024:	7fc080e7          	jalr	2044(ra) # 8000681c <acquire>
  ticks++;
    80002028:	00009517          	auipc	a0,0x9
    8000202c:	4d050513          	addi	a0,a0,1232 # 8000b4f8 <ticks>
    80002030:	411c                	lw	a5,0(a0)
    80002032:	2785                	addiw	a5,a5,1
    80002034:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002036:	00000097          	auipc	ra,0x0
    8000203a:	996080e7          	jalr	-1642(ra) # 800019cc <wakeup>
  release(&tickslock);
    8000203e:	8526                	mv	a0,s1
    80002040:	00005097          	auipc	ra,0x5
    80002044:	890080e7          	jalr	-1904(ra) # 800068d0 <release>
}
    80002048:	60e2                	ld	ra,24(sp)
    8000204a:	6442                	ld	s0,16(sp)
    8000204c:	64a2                	ld	s1,8(sp)
    8000204e:	6105                	addi	sp,sp,32
    80002050:	8082                	ret

0000000080002052 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002052:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002056:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80002058:	0a07d163          	bgez	a5,800020fa <devintr+0xa8>
{
    8000205c:	1101                	addi	sp,sp,-32
    8000205e:	ec06                	sd	ra,24(sp)
    80002060:	e822                	sd	s0,16(sp)
    80002062:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80002064:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80002068:	46a5                	li	a3,9
    8000206a:	00d70c63          	beq	a4,a3,80002082 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    8000206e:	577d                	li	a4,-1
    80002070:	177e                	slli	a4,a4,0x3f
    80002072:	0705                	addi	a4,a4,1
    return 0;
    80002074:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002076:	06e78163          	beq	a5,a4,800020d8 <devintr+0x86>
  }
}
    8000207a:	60e2                	ld	ra,24(sp)
    8000207c:	6442                	ld	s0,16(sp)
    8000207e:	6105                	addi	sp,sp,32
    80002080:	8082                	ret
    80002082:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002084:	00003097          	auipc	ra,0x3
    80002088:	6f8080e7          	jalr	1784(ra) # 8000577c <plic_claim>
    8000208c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000208e:	47a9                	li	a5,10
    80002090:	00f50963          	beq	a0,a5,800020a2 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80002094:	4785                	li	a5,1
    80002096:	00f50b63          	beq	a0,a5,800020ac <devintr+0x5a>
    return 1;
    8000209a:	4505                	li	a0,1
    } else if(irq){
    8000209c:	ec89                	bnez	s1,800020b6 <devintr+0x64>
    8000209e:	64a2                	ld	s1,8(sp)
    800020a0:	bfe9                	j	8000207a <devintr+0x28>
      uartintr();
    800020a2:	00004097          	auipc	ra,0x4
    800020a6:	69a080e7          	jalr	1690(ra) # 8000673c <uartintr>
    if(irq)
    800020aa:	a839                	j	800020c8 <devintr+0x76>
      virtio_disk_intr();
    800020ac:	00004097          	auipc	ra,0x4
    800020b0:	bfa080e7          	jalr	-1030(ra) # 80005ca6 <virtio_disk_intr>
    if(irq)
    800020b4:	a811                	j	800020c8 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    800020b6:	85a6                	mv	a1,s1
    800020b8:	00006517          	auipc	a0,0x6
    800020bc:	23050513          	addi	a0,a0,560 # 800082e8 <etext+0x2e8>
    800020c0:	00004097          	auipc	ra,0x4
    800020c4:	22c080e7          	jalr	556(ra) # 800062ec <printf>
      plic_complete(irq);
    800020c8:	8526                	mv	a0,s1
    800020ca:	00003097          	auipc	ra,0x3
    800020ce:	6d6080e7          	jalr	1750(ra) # 800057a0 <plic_complete>
    return 1;
    800020d2:	4505                	li	a0,1
    800020d4:	64a2                	ld	s1,8(sp)
    800020d6:	b755                	j	8000207a <devintr+0x28>
    if(cpuid() == 0){
    800020d8:	fffff097          	auipc	ra,0xfffff
    800020dc:	1b6080e7          	jalr	438(ra) # 8000128e <cpuid>
    800020e0:	c901                	beqz	a0,800020f0 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800020e2:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800020e6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800020e8:	14479073          	csrw	sip,a5
    return 2;
    800020ec:	4509                	li	a0,2
    800020ee:	b771                	j	8000207a <devintr+0x28>
      clockintr();
    800020f0:	00000097          	auipc	ra,0x0
    800020f4:	f1c080e7          	jalr	-228(ra) # 8000200c <clockintr>
    800020f8:	b7ed                	j	800020e2 <devintr+0x90>
}
    800020fa:	8082                	ret

00000000800020fc <usertrap>:
{
    800020fc:	1101                	addi	sp,sp,-32
    800020fe:	ec06                	sd	ra,24(sp)
    80002100:	e822                	sd	s0,16(sp)
    80002102:	e426                	sd	s1,8(sp)
    80002104:	e04a                	sd	s2,0(sp)
    80002106:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002108:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000210c:	1007f793          	andi	a5,a5,256
    80002110:	e3c1                	bnez	a5,80002190 <usertrap+0x94>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002112:	00003797          	auipc	a5,0x3
    80002116:	55e78793          	addi	a5,a5,1374 # 80005670 <kernelvec>
    8000211a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000211e:	fffff097          	auipc	ra,0xfffff
    80002122:	19c080e7          	jalr	412(ra) # 800012ba <myproc>
    80002126:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002128:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000212a:	14102773          	csrr	a4,sepc
    8000212e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002130:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002134:	47a1                	li	a5,8
    80002136:	06f70563          	beq	a4,a5,800021a0 <usertrap+0xa4>
  } else if((which_dev = devintr()) != 0){
    8000213a:	00000097          	auipc	ra,0x0
    8000213e:	f18080e7          	jalr	-232(ra) # 80002052 <devintr>
    80002142:	892a                	mv	s2,a0
    80002144:	1a051163          	bnez	a0,800022e6 <usertrap+0x1ea>
    80002148:	14202773          	csrr	a4,scause
  } else if(r_scause() == 12 || r_scause() == 13 || r_scause() == 15){
    8000214c:	47b1                	li	a5,12
    8000214e:	00f70c63          	beq	a4,a5,80002166 <usertrap+0x6a>
    80002152:	14202773          	csrr	a4,scause
    80002156:	47b5                	li	a5,13
    80002158:	00f70763          	beq	a4,a5,80002166 <usertrap+0x6a>
    8000215c:	14202773          	csrr	a4,scause
    80002160:	47bd                	li	a5,15
    80002162:	14f71563          	bne	a4,a5,800022ac <usertrap+0x1b0>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002166:	14302973          	csrr	s2,stval
    if(va >= p->sz) {
    8000216a:	64bc                	ld	a5,72(s1)
    8000216c:	08f96463          	bltu	s2,a5,800021f4 <usertrap+0xf8>
      printf("usertrap(): bad address %p pid=%d\n", va, p->pid);
    80002170:	5890                	lw	a2,48(s1)
    80002172:	85ca                	mv	a1,s2
    80002174:	00006517          	auipc	a0,0x6
    80002178:	1b450513          	addi	a0,a0,436 # 80008328 <etext+0x328>
    8000217c:	00004097          	auipc	ra,0x4
    80002180:	170080e7          	jalr	368(ra) # 800062ec <printf>
      setkilled(p);
    80002184:	8526                	mv	a0,s1
    80002186:	00000097          	auipc	ra,0x0
    8000218a:	a5e080e7          	jalr	-1442(ra) # 80001be4 <setkilled>
    8000218e:	a825                	j	800021c6 <usertrap+0xca>
    panic("usertrap: not from user mode");
    80002190:	00006517          	auipc	a0,0x6
    80002194:	17850513          	addi	a0,a0,376 # 80008308 <etext+0x308>
    80002198:	00004097          	auipc	ra,0x4
    8000219c:	10a080e7          	jalr	266(ra) # 800062a2 <panic>
    if(killed(p))
    800021a0:	00000097          	auipc	ra,0x0
    800021a4:	a70080e7          	jalr	-1424(ra) # 80001c10 <killed>
    800021a8:	e121                	bnez	a0,800021e8 <usertrap+0xec>
    p->trapframe->epc += 4;
    800021aa:	6cb8                	ld	a4,88(s1)
    800021ac:	6f1c                	ld	a5,24(a4)
    800021ae:	0791                	addi	a5,a5,4
    800021b0:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800021b2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800021b6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800021ba:	10079073          	csrw	sstatus,a5
    syscall();
    800021be:	00000097          	auipc	ra,0x0
    800021c2:	39c080e7          	jalr	924(ra) # 8000255a <syscall>
  if(killed(p))
    800021c6:	8526                	mv	a0,s1
    800021c8:	00000097          	auipc	ra,0x0
    800021cc:	a48080e7          	jalr	-1464(ra) # 80001c10 <killed>
    800021d0:	12051263          	bnez	a0,800022f4 <usertrap+0x1f8>
  usertrapret();
    800021d4:	00000097          	auipc	ra,0x0
    800021d8:	da2080e7          	jalr	-606(ra) # 80001f76 <usertrapret>
}
    800021dc:	60e2                	ld	ra,24(sp)
    800021de:	6442                	ld	s0,16(sp)
    800021e0:	64a2                	ld	s1,8(sp)
    800021e2:	6902                	ld	s2,0(sp)
    800021e4:	6105                	addi	sp,sp,32
    800021e6:	8082                	ret
      exit(-1);
    800021e8:	557d                	li	a0,-1
    800021ea:	00000097          	auipc	ra,0x0
    800021ee:	8b2080e7          	jalr	-1870(ra) # 80001a9c <exit>
    800021f2:	bf65                	j	800021aa <usertrap+0xae>
      pte_t *pte = walk(p->pagetable, va, 0);
    800021f4:	4601                	li	a2,0
    800021f6:	85ca                	mv	a1,s2
    800021f8:	68a8                	ld	a0,80(s1)
    800021fa:	ffffe097          	auipc	ra,0xffffe
    800021fe:	4a6080e7          	jalr	1190(ra) # 800006a0 <walk>
      if(pte == 0 || (*pte & PTE_V) == 0) {
    80002202:	c509                	beqz	a0,8000220c <usertrap+0x110>
    80002204:	611c                	ld	a5,0(a0)
    80002206:	0017f713          	andi	a4,a5,1
    8000220a:	e30d                	bnez	a4,8000222c <usertrap+0x130>
        printf("usertrap(): page not mapped va=%p pid=%d\n", va, p->pid);
    8000220c:	5890                	lw	a2,48(s1)
    8000220e:	85ca                	mv	a1,s2
    80002210:	00006517          	auipc	a0,0x6
    80002214:	14050513          	addi	a0,a0,320 # 80008350 <etext+0x350>
    80002218:	00004097          	auipc	ra,0x4
    8000221c:	0d4080e7          	jalr	212(ra) # 800062ec <printf>
        setkilled(p);
    80002220:	8526                	mv	a0,s1
    80002222:	00000097          	auipc	ra,0x0
    80002226:	9c2080e7          	jalr	-1598(ra) # 80001be4 <setkilled>
    8000222a:	bf71                	j	800021c6 <usertrap+0xca>
      } else if((*pte & PTE_COW) == 0) {
    8000222c:	1007f793          	andi	a5,a5,256
    80002230:	e7b1                	bnez	a5,8000227c <usertrap+0x180>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002232:	14202773          	csrr	a4,scause
        if(r_scause() == 12) {
    80002236:	47b1                	li	a5,12
    80002238:	02f70263          	beq	a4,a5,8000225c <usertrap+0x160>
          printf("usertrap(): page fault on non-COW page %p pid=%d\n", va, p->pid);
    8000223c:	5890                	lw	a2,48(s1)
    8000223e:	85ca                	mv	a1,s2
    80002240:	00006517          	auipc	a0,0x6
    80002244:	18050513          	addi	a0,a0,384 # 800083c0 <etext+0x3c0>
    80002248:	00004097          	auipc	ra,0x4
    8000224c:	0a4080e7          	jalr	164(ra) # 800062ec <printf>
          setkilled(p);
    80002250:	8526                	mv	a0,s1
    80002252:	00000097          	auipc	ra,0x0
    80002256:	992080e7          	jalr	-1646(ra) # 80001be4 <setkilled>
    8000225a:	b7b5                	j	800021c6 <usertrap+0xca>
          printf("usertrap(): instruction page fault on non-COW page %p pid=%d\n", va, p->pid);
    8000225c:	5890                	lw	a2,48(s1)
    8000225e:	85ca                	mv	a1,s2
    80002260:	00006517          	auipc	a0,0x6
    80002264:	12050513          	addi	a0,a0,288 # 80008380 <etext+0x380>
    80002268:	00004097          	auipc	ra,0x4
    8000226c:	084080e7          	jalr	132(ra) # 800062ec <printf>
          setkilled(p);
    80002270:	8526                	mv	a0,s1
    80002272:	00000097          	auipc	ra,0x0
    80002276:	972080e7          	jalr	-1678(ra) # 80001be4 <setkilled>
    8000227a:	b7b1                	j	800021c6 <usertrap+0xca>
      } else if(cowalloc(p->pagetable, va) < 0) {
    8000227c:	85ca                	mv	a1,s2
    8000227e:	68a8                	ld	a0,80(s1)
    80002280:	fffff097          	auipc	ra,0xfffff
    80002284:	b62080e7          	jalr	-1182(ra) # 80000de2 <cowalloc>
    80002288:	f2055fe3          	bgez	a0,800021c6 <usertrap+0xca>
        printf("usertrap(): cowalloc failed va=%p pid=%d\n", va, p->pid);
    8000228c:	5890                	lw	a2,48(s1)
    8000228e:	85ca                	mv	a1,s2
    80002290:	00006517          	auipc	a0,0x6
    80002294:	16850513          	addi	a0,a0,360 # 800083f8 <etext+0x3f8>
    80002298:	00004097          	auipc	ra,0x4
    8000229c:	054080e7          	jalr	84(ra) # 800062ec <printf>
        setkilled(p);
    800022a0:	8526                	mv	a0,s1
    800022a2:	00000097          	auipc	ra,0x0
    800022a6:	942080e7          	jalr	-1726(ra) # 80001be4 <setkilled>
    800022aa:	bf31                	j	800021c6 <usertrap+0xca>
    800022ac:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800022b0:	5890                	lw	a2,48(s1)
    800022b2:	00006517          	auipc	a0,0x6
    800022b6:	17650513          	addi	a0,a0,374 # 80008428 <etext+0x428>
    800022ba:	00004097          	auipc	ra,0x4
    800022be:	032080e7          	jalr	50(ra) # 800062ec <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800022c2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800022c6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800022ca:	00006517          	auipc	a0,0x6
    800022ce:	18e50513          	addi	a0,a0,398 # 80008458 <etext+0x458>
    800022d2:	00004097          	auipc	ra,0x4
    800022d6:	01a080e7          	jalr	26(ra) # 800062ec <printf>
    setkilled(p);
    800022da:	8526                	mv	a0,s1
    800022dc:	00000097          	auipc	ra,0x0
    800022e0:	908080e7          	jalr	-1784(ra) # 80001be4 <setkilled>
    800022e4:	b5cd                	j	800021c6 <usertrap+0xca>
  if(killed(p))
    800022e6:	8526                	mv	a0,s1
    800022e8:	00000097          	auipc	ra,0x0
    800022ec:	928080e7          	jalr	-1752(ra) # 80001c10 <killed>
    800022f0:	c901                	beqz	a0,80002300 <usertrap+0x204>
    800022f2:	a011                	j	800022f6 <usertrap+0x1fa>
    800022f4:	4901                	li	s2,0
    exit(-1);
    800022f6:	557d                	li	a0,-1
    800022f8:	fffff097          	auipc	ra,0xfffff
    800022fc:	7a4080e7          	jalr	1956(ra) # 80001a9c <exit>
  if(which_dev == 2)
    80002300:	4789                	li	a5,2
    80002302:	ecf919e3          	bne	s2,a5,800021d4 <usertrap+0xd8>
    yield();
    80002306:	fffff097          	auipc	ra,0xfffff
    8000230a:	626080e7          	jalr	1574(ra) # 8000192c <yield>
    8000230e:	b5d9                	j	800021d4 <usertrap+0xd8>

0000000080002310 <kerneltrap>:
{
    80002310:	7179                	addi	sp,sp,-48
    80002312:	f406                	sd	ra,40(sp)
    80002314:	f022                	sd	s0,32(sp)
    80002316:	ec26                	sd	s1,24(sp)
    80002318:	e84a                	sd	s2,16(sp)
    8000231a:	e44e                	sd	s3,8(sp)
    8000231c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000231e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002322:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002326:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    8000232a:	1004f793          	andi	a5,s1,256
    8000232e:	cb85                	beqz	a5,8000235e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002330:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002334:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002336:	ef85                	bnez	a5,8000236e <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002338:	00000097          	auipc	ra,0x0
    8000233c:	d1a080e7          	jalr	-742(ra) # 80002052 <devintr>
    80002340:	cd1d                	beqz	a0,8000237e <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002342:	4789                	li	a5,2
    80002344:	06f50a63          	beq	a0,a5,800023b8 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002348:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000234c:	10049073          	csrw	sstatus,s1
}
    80002350:	70a2                	ld	ra,40(sp)
    80002352:	7402                	ld	s0,32(sp)
    80002354:	64e2                	ld	s1,24(sp)
    80002356:	6942                	ld	s2,16(sp)
    80002358:	69a2                	ld	s3,8(sp)
    8000235a:	6145                	addi	sp,sp,48
    8000235c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000235e:	00006517          	auipc	a0,0x6
    80002362:	11a50513          	addi	a0,a0,282 # 80008478 <etext+0x478>
    80002366:	00004097          	auipc	ra,0x4
    8000236a:	f3c080e7          	jalr	-196(ra) # 800062a2 <panic>
    panic("kerneltrap: interrupts enabled");
    8000236e:	00006517          	auipc	a0,0x6
    80002372:	13250513          	addi	a0,a0,306 # 800084a0 <etext+0x4a0>
    80002376:	00004097          	auipc	ra,0x4
    8000237a:	f2c080e7          	jalr	-212(ra) # 800062a2 <panic>
    printf("scause %p\n", scause);
    8000237e:	85ce                	mv	a1,s3
    80002380:	00006517          	auipc	a0,0x6
    80002384:	14050513          	addi	a0,a0,320 # 800084c0 <etext+0x4c0>
    80002388:	00004097          	auipc	ra,0x4
    8000238c:	f64080e7          	jalr	-156(ra) # 800062ec <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002390:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002394:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002398:	00006517          	auipc	a0,0x6
    8000239c:	13850513          	addi	a0,a0,312 # 800084d0 <etext+0x4d0>
    800023a0:	00004097          	auipc	ra,0x4
    800023a4:	f4c080e7          	jalr	-180(ra) # 800062ec <printf>
    panic("kerneltrap");
    800023a8:	00006517          	auipc	a0,0x6
    800023ac:	14050513          	addi	a0,a0,320 # 800084e8 <etext+0x4e8>
    800023b0:	00004097          	auipc	ra,0x4
    800023b4:	ef2080e7          	jalr	-270(ra) # 800062a2 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800023b8:	fffff097          	auipc	ra,0xfffff
    800023bc:	f02080e7          	jalr	-254(ra) # 800012ba <myproc>
    800023c0:	d541                	beqz	a0,80002348 <kerneltrap+0x38>
    800023c2:	fffff097          	auipc	ra,0xfffff
    800023c6:	ef8080e7          	jalr	-264(ra) # 800012ba <myproc>
    800023ca:	4d18                	lw	a4,24(a0)
    800023cc:	4791                	li	a5,4
    800023ce:	f6f71de3          	bne	a4,a5,80002348 <kerneltrap+0x38>
    yield();
    800023d2:	fffff097          	auipc	ra,0xfffff
    800023d6:	55a080e7          	jalr	1370(ra) # 8000192c <yield>
    800023da:	b7bd                	j	80002348 <kerneltrap+0x38>

00000000800023dc <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800023dc:	1101                	addi	sp,sp,-32
    800023de:	ec06                	sd	ra,24(sp)
    800023e0:	e822                	sd	s0,16(sp)
    800023e2:	e426                	sd	s1,8(sp)
    800023e4:	1000                	addi	s0,sp,32
    800023e6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800023e8:	fffff097          	auipc	ra,0xfffff
    800023ec:	ed2080e7          	jalr	-302(ra) # 800012ba <myproc>
  switch (n) {
    800023f0:	4795                	li	a5,5
    800023f2:	0497e163          	bltu	a5,s1,80002434 <argraw+0x58>
    800023f6:	048a                	slli	s1,s1,0x2
    800023f8:	00006717          	auipc	a4,0x6
    800023fc:	50070713          	addi	a4,a4,1280 # 800088f8 <states.0+0x30>
    80002400:	94ba                	add	s1,s1,a4
    80002402:	409c                	lw	a5,0(s1)
    80002404:	97ba                	add	a5,a5,a4
    80002406:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002408:	6d3c                	ld	a5,88(a0)
    8000240a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000240c:	60e2                	ld	ra,24(sp)
    8000240e:	6442                	ld	s0,16(sp)
    80002410:	64a2                	ld	s1,8(sp)
    80002412:	6105                	addi	sp,sp,32
    80002414:	8082                	ret
    return p->trapframe->a1;
    80002416:	6d3c                	ld	a5,88(a0)
    80002418:	7fa8                	ld	a0,120(a5)
    8000241a:	bfcd                	j	8000240c <argraw+0x30>
    return p->trapframe->a2;
    8000241c:	6d3c                	ld	a5,88(a0)
    8000241e:	63c8                	ld	a0,128(a5)
    80002420:	b7f5                	j	8000240c <argraw+0x30>
    return p->trapframe->a3;
    80002422:	6d3c                	ld	a5,88(a0)
    80002424:	67c8                	ld	a0,136(a5)
    80002426:	b7dd                	j	8000240c <argraw+0x30>
    return p->trapframe->a4;
    80002428:	6d3c                	ld	a5,88(a0)
    8000242a:	6bc8                	ld	a0,144(a5)
    8000242c:	b7c5                	j	8000240c <argraw+0x30>
    return p->trapframe->a5;
    8000242e:	6d3c                	ld	a5,88(a0)
    80002430:	6fc8                	ld	a0,152(a5)
    80002432:	bfe9                	j	8000240c <argraw+0x30>
  panic("argraw");
    80002434:	00006517          	auipc	a0,0x6
    80002438:	0c450513          	addi	a0,a0,196 # 800084f8 <etext+0x4f8>
    8000243c:	00004097          	auipc	ra,0x4
    80002440:	e66080e7          	jalr	-410(ra) # 800062a2 <panic>

0000000080002444 <fetchaddr>:
{
    80002444:	1101                	addi	sp,sp,-32
    80002446:	ec06                	sd	ra,24(sp)
    80002448:	e822                	sd	s0,16(sp)
    8000244a:	e426                	sd	s1,8(sp)
    8000244c:	e04a                	sd	s2,0(sp)
    8000244e:	1000                	addi	s0,sp,32
    80002450:	84aa                	mv	s1,a0
    80002452:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002454:	fffff097          	auipc	ra,0xfffff
    80002458:	e66080e7          	jalr	-410(ra) # 800012ba <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000245c:	653c                	ld	a5,72(a0)
    8000245e:	02f4f863          	bgeu	s1,a5,8000248e <fetchaddr+0x4a>
    80002462:	00848713          	addi	a4,s1,8
    80002466:	02e7e663          	bltu	a5,a4,80002492 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000246a:	46a1                	li	a3,8
    8000246c:	8626                	mv	a2,s1
    8000246e:	85ca                	mv	a1,s2
    80002470:	6928                	ld	a0,80(a0)
    80002472:	fffff097          	auipc	ra,0xfffff
    80002476:	b6c080e7          	jalr	-1172(ra) # 80000fde <copyin>
    8000247a:	00a03533          	snez	a0,a0
    8000247e:	40a00533          	neg	a0,a0
}
    80002482:	60e2                	ld	ra,24(sp)
    80002484:	6442                	ld	s0,16(sp)
    80002486:	64a2                	ld	s1,8(sp)
    80002488:	6902                	ld	s2,0(sp)
    8000248a:	6105                	addi	sp,sp,32
    8000248c:	8082                	ret
    return -1;
    8000248e:	557d                	li	a0,-1
    80002490:	bfcd                	j	80002482 <fetchaddr+0x3e>
    80002492:	557d                	li	a0,-1
    80002494:	b7fd                	j	80002482 <fetchaddr+0x3e>

0000000080002496 <fetchstr>:
{
    80002496:	7179                	addi	sp,sp,-48
    80002498:	f406                	sd	ra,40(sp)
    8000249a:	f022                	sd	s0,32(sp)
    8000249c:	ec26                	sd	s1,24(sp)
    8000249e:	e84a                	sd	s2,16(sp)
    800024a0:	e44e                	sd	s3,8(sp)
    800024a2:	1800                	addi	s0,sp,48
    800024a4:	892a                	mv	s2,a0
    800024a6:	84ae                	mv	s1,a1
    800024a8:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800024aa:	fffff097          	auipc	ra,0xfffff
    800024ae:	e10080e7          	jalr	-496(ra) # 800012ba <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800024b2:	86ce                	mv	a3,s3
    800024b4:	864a                	mv	a2,s2
    800024b6:	85a6                	mv	a1,s1
    800024b8:	6928                	ld	a0,80(a0)
    800024ba:	fffff097          	auipc	ra,0xfffff
    800024be:	bb2080e7          	jalr	-1102(ra) # 8000106c <copyinstr>
    800024c2:	00054e63          	bltz	a0,800024de <fetchstr+0x48>
  return strlen(buf);
    800024c6:	8526                	mv	a0,s1
    800024c8:	ffffe097          	auipc	ra,0xffffe
    800024cc:	070080e7          	jalr	112(ra) # 80000538 <strlen>
}
    800024d0:	70a2                	ld	ra,40(sp)
    800024d2:	7402                	ld	s0,32(sp)
    800024d4:	64e2                	ld	s1,24(sp)
    800024d6:	6942                	ld	s2,16(sp)
    800024d8:	69a2                	ld	s3,8(sp)
    800024da:	6145                	addi	sp,sp,48
    800024dc:	8082                	ret
    return -1;
    800024de:	557d                	li	a0,-1
    800024e0:	bfc5                	j	800024d0 <fetchstr+0x3a>

00000000800024e2 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800024e2:	1101                	addi	sp,sp,-32
    800024e4:	ec06                	sd	ra,24(sp)
    800024e6:	e822                	sd	s0,16(sp)
    800024e8:	e426                	sd	s1,8(sp)
    800024ea:	1000                	addi	s0,sp,32
    800024ec:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800024ee:	00000097          	auipc	ra,0x0
    800024f2:	eee080e7          	jalr	-274(ra) # 800023dc <argraw>
    800024f6:	c088                	sw	a0,0(s1)
}
    800024f8:	60e2                	ld	ra,24(sp)
    800024fa:	6442                	ld	s0,16(sp)
    800024fc:	64a2                	ld	s1,8(sp)
    800024fe:	6105                	addi	sp,sp,32
    80002500:	8082                	ret

0000000080002502 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002502:	1101                	addi	sp,sp,-32
    80002504:	ec06                	sd	ra,24(sp)
    80002506:	e822                	sd	s0,16(sp)
    80002508:	e426                	sd	s1,8(sp)
    8000250a:	1000                	addi	s0,sp,32
    8000250c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000250e:	00000097          	auipc	ra,0x0
    80002512:	ece080e7          	jalr	-306(ra) # 800023dc <argraw>
    80002516:	e088                	sd	a0,0(s1)
}
    80002518:	60e2                	ld	ra,24(sp)
    8000251a:	6442                	ld	s0,16(sp)
    8000251c:	64a2                	ld	s1,8(sp)
    8000251e:	6105                	addi	sp,sp,32
    80002520:	8082                	ret

0000000080002522 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002522:	7179                	addi	sp,sp,-48
    80002524:	f406                	sd	ra,40(sp)
    80002526:	f022                	sd	s0,32(sp)
    80002528:	ec26                	sd	s1,24(sp)
    8000252a:	e84a                	sd	s2,16(sp)
    8000252c:	1800                	addi	s0,sp,48
    8000252e:	84ae                	mv	s1,a1
    80002530:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002532:	fd840593          	addi	a1,s0,-40
    80002536:	00000097          	auipc	ra,0x0
    8000253a:	fcc080e7          	jalr	-52(ra) # 80002502 <argaddr>
  return fetchstr(addr, buf, max);
    8000253e:	864a                	mv	a2,s2
    80002540:	85a6                	mv	a1,s1
    80002542:	fd843503          	ld	a0,-40(s0)
    80002546:	00000097          	auipc	ra,0x0
    8000254a:	f50080e7          	jalr	-176(ra) # 80002496 <fetchstr>
}
    8000254e:	70a2                	ld	ra,40(sp)
    80002550:	7402                	ld	s0,32(sp)
    80002552:	64e2                	ld	s1,24(sp)
    80002554:	6942                	ld	s2,16(sp)
    80002556:	6145                	addi	sp,sp,48
    80002558:	8082                	ret

000000008000255a <syscall>:
[SYS_cowstats] sys_cowstats,
};

void
syscall(void)
{
    8000255a:	1101                	addi	sp,sp,-32
    8000255c:	ec06                	sd	ra,24(sp)
    8000255e:	e822                	sd	s0,16(sp)
    80002560:	e426                	sd	s1,8(sp)
    80002562:	e04a                	sd	s2,0(sp)
    80002564:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002566:	fffff097          	auipc	ra,0xfffff
    8000256a:	d54080e7          	jalr	-684(ra) # 800012ba <myproc>
    8000256e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002570:	05853903          	ld	s2,88(a0)
    80002574:	0a893783          	ld	a5,168(s2)
    80002578:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000257c:	37fd                	addiw	a5,a5,-1
    8000257e:	4755                	li	a4,21
    80002580:	00f76f63          	bltu	a4,a5,8000259e <syscall+0x44>
    80002584:	00369713          	slli	a4,a3,0x3
    80002588:	00006797          	auipc	a5,0x6
    8000258c:	38878793          	addi	a5,a5,904 # 80008910 <syscalls>
    80002590:	97ba                	add	a5,a5,a4
    80002592:	639c                	ld	a5,0(a5)
    80002594:	c789                	beqz	a5,8000259e <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002596:	9782                	jalr	a5
    80002598:	06a93823          	sd	a0,112(s2)
    8000259c:	a839                	j	800025ba <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000259e:	15848613          	addi	a2,s1,344
    800025a2:	588c                	lw	a1,48(s1)
    800025a4:	00006517          	auipc	a0,0x6
    800025a8:	f5c50513          	addi	a0,a0,-164 # 80008500 <etext+0x500>
    800025ac:	00004097          	auipc	ra,0x4
    800025b0:	d40080e7          	jalr	-704(ra) # 800062ec <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800025b4:	6cbc                	ld	a5,88(s1)
    800025b6:	577d                	li	a4,-1
    800025b8:	fbb8                	sd	a4,112(a5)
  }
}
    800025ba:	60e2                	ld	ra,24(sp)
    800025bc:	6442                	ld	s0,16(sp)
    800025be:	64a2                	ld	s1,8(sp)
    800025c0:	6902                	ld	s2,0(sp)
    800025c2:	6105                	addi	sp,sp,32
    800025c4:	8082                	ret

00000000800025c6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800025c6:	1101                	addi	sp,sp,-32
    800025c8:	ec06                	sd	ra,24(sp)
    800025ca:	e822                	sd	s0,16(sp)
    800025cc:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800025ce:	fec40593          	addi	a1,s0,-20
    800025d2:	4501                	li	a0,0
    800025d4:	00000097          	auipc	ra,0x0
    800025d8:	f0e080e7          	jalr	-242(ra) # 800024e2 <argint>
  exit(n);
    800025dc:	fec42503          	lw	a0,-20(s0)
    800025e0:	fffff097          	auipc	ra,0xfffff
    800025e4:	4bc080e7          	jalr	1212(ra) # 80001a9c <exit>
  return 0;  // not reached
}
    800025e8:	4501                	li	a0,0
    800025ea:	60e2                	ld	ra,24(sp)
    800025ec:	6442                	ld	s0,16(sp)
    800025ee:	6105                	addi	sp,sp,32
    800025f0:	8082                	ret

00000000800025f2 <sys_getpid>:

uint64
sys_getpid(void)
{
    800025f2:	1141                	addi	sp,sp,-16
    800025f4:	e406                	sd	ra,8(sp)
    800025f6:	e022                	sd	s0,0(sp)
    800025f8:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800025fa:	fffff097          	auipc	ra,0xfffff
    800025fe:	cc0080e7          	jalr	-832(ra) # 800012ba <myproc>
}
    80002602:	5908                	lw	a0,48(a0)
    80002604:	60a2                	ld	ra,8(sp)
    80002606:	6402                	ld	s0,0(sp)
    80002608:	0141                	addi	sp,sp,16
    8000260a:	8082                	ret

000000008000260c <sys_fork>:

uint64
sys_fork(void)
{
    8000260c:	1141                	addi	sp,sp,-16
    8000260e:	e406                	sd	ra,8(sp)
    80002610:	e022                	sd	s0,0(sp)
    80002612:	0800                	addi	s0,sp,16
  return fork();
    80002614:	fffff097          	auipc	ra,0xfffff
    80002618:	060080e7          	jalr	96(ra) # 80001674 <fork>
}
    8000261c:	60a2                	ld	ra,8(sp)
    8000261e:	6402                	ld	s0,0(sp)
    80002620:	0141                	addi	sp,sp,16
    80002622:	8082                	ret

0000000080002624 <sys_wait>:

uint64
sys_wait(void)
{
    80002624:	1101                	addi	sp,sp,-32
    80002626:	ec06                	sd	ra,24(sp)
    80002628:	e822                	sd	s0,16(sp)
    8000262a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000262c:	fe840593          	addi	a1,s0,-24
    80002630:	4501                	li	a0,0
    80002632:	00000097          	auipc	ra,0x0
    80002636:	ed0080e7          	jalr	-304(ra) # 80002502 <argaddr>
  return wait(p);
    8000263a:	fe843503          	ld	a0,-24(s0)
    8000263e:	fffff097          	auipc	ra,0xfffff
    80002642:	604080e7          	jalr	1540(ra) # 80001c42 <wait>
}
    80002646:	60e2                	ld	ra,24(sp)
    80002648:	6442                	ld	s0,16(sp)
    8000264a:	6105                	addi	sp,sp,32
    8000264c:	8082                	ret

000000008000264e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000264e:	7179                	addi	sp,sp,-48
    80002650:	f406                	sd	ra,40(sp)
    80002652:	f022                	sd	s0,32(sp)
    80002654:	ec26                	sd	s1,24(sp)
    80002656:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002658:	fdc40593          	addi	a1,s0,-36
    8000265c:	4501                	li	a0,0
    8000265e:	00000097          	auipc	ra,0x0
    80002662:	e84080e7          	jalr	-380(ra) # 800024e2 <argint>
  addr = myproc()->sz;
    80002666:	fffff097          	auipc	ra,0xfffff
    8000266a:	c54080e7          	jalr	-940(ra) # 800012ba <myproc>
    8000266e:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002670:	fdc42503          	lw	a0,-36(s0)
    80002674:	fffff097          	auipc	ra,0xfffff
    80002678:	fa4080e7          	jalr	-92(ra) # 80001618 <growproc>
    8000267c:	00054863          	bltz	a0,8000268c <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002680:	8526                	mv	a0,s1
    80002682:	70a2                	ld	ra,40(sp)
    80002684:	7402                	ld	s0,32(sp)
    80002686:	64e2                	ld	s1,24(sp)
    80002688:	6145                	addi	sp,sp,48
    8000268a:	8082                	ret
    return -1;
    8000268c:	54fd                	li	s1,-1
    8000268e:	bfcd                	j	80002680 <sys_sbrk+0x32>

0000000080002690 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002690:	7139                	addi	sp,sp,-64
    80002692:	fc06                	sd	ra,56(sp)
    80002694:	f822                	sd	s0,48(sp)
    80002696:	f04a                	sd	s2,32(sp)
    80002698:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000269a:	fcc40593          	addi	a1,s0,-52
    8000269e:	4501                	li	a0,0
    800026a0:	00000097          	auipc	ra,0x0
    800026a4:	e42080e7          	jalr	-446(ra) # 800024e2 <argint>
  if(n < 0)
    800026a8:	fcc42783          	lw	a5,-52(s0)
    800026ac:	0807c163          	bltz	a5,8000272e <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800026b0:	0002f517          	auipc	a0,0x2f
    800026b4:	cc850513          	addi	a0,a0,-824 # 80031378 <tickslock>
    800026b8:	00004097          	auipc	ra,0x4
    800026bc:	164080e7          	jalr	356(ra) # 8000681c <acquire>
  ticks0 = ticks;
    800026c0:	00009917          	auipc	s2,0x9
    800026c4:	e3892903          	lw	s2,-456(s2) # 8000b4f8 <ticks>
  while(ticks - ticks0 < n){
    800026c8:	fcc42783          	lw	a5,-52(s0)
    800026cc:	c3b9                	beqz	a5,80002712 <sys_sleep+0x82>
    800026ce:	f426                	sd	s1,40(sp)
    800026d0:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800026d2:	0002f997          	auipc	s3,0x2f
    800026d6:	ca698993          	addi	s3,s3,-858 # 80031378 <tickslock>
    800026da:	00009497          	auipc	s1,0x9
    800026de:	e1e48493          	addi	s1,s1,-482 # 8000b4f8 <ticks>
    if(killed(myproc())){
    800026e2:	fffff097          	auipc	ra,0xfffff
    800026e6:	bd8080e7          	jalr	-1064(ra) # 800012ba <myproc>
    800026ea:	fffff097          	auipc	ra,0xfffff
    800026ee:	526080e7          	jalr	1318(ra) # 80001c10 <killed>
    800026f2:	e129                	bnez	a0,80002734 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    800026f4:	85ce                	mv	a1,s3
    800026f6:	8526                	mv	a0,s1
    800026f8:	fffff097          	auipc	ra,0xfffff
    800026fc:	270080e7          	jalr	624(ra) # 80001968 <sleep>
  while(ticks - ticks0 < n){
    80002700:	409c                	lw	a5,0(s1)
    80002702:	412787bb          	subw	a5,a5,s2
    80002706:	fcc42703          	lw	a4,-52(s0)
    8000270a:	fce7ece3          	bltu	a5,a4,800026e2 <sys_sleep+0x52>
    8000270e:	74a2                	ld	s1,40(sp)
    80002710:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002712:	0002f517          	auipc	a0,0x2f
    80002716:	c6650513          	addi	a0,a0,-922 # 80031378 <tickslock>
    8000271a:	00004097          	auipc	ra,0x4
    8000271e:	1b6080e7          	jalr	438(ra) # 800068d0 <release>
  return 0;
    80002722:	4501                	li	a0,0
}
    80002724:	70e2                	ld	ra,56(sp)
    80002726:	7442                	ld	s0,48(sp)
    80002728:	7902                	ld	s2,32(sp)
    8000272a:	6121                	addi	sp,sp,64
    8000272c:	8082                	ret
    n = 0;
    8000272e:	fc042623          	sw	zero,-52(s0)
    80002732:	bfbd                	j	800026b0 <sys_sleep+0x20>
      release(&tickslock);
    80002734:	0002f517          	auipc	a0,0x2f
    80002738:	c4450513          	addi	a0,a0,-956 # 80031378 <tickslock>
    8000273c:	00004097          	auipc	ra,0x4
    80002740:	194080e7          	jalr	404(ra) # 800068d0 <release>
      return -1;
    80002744:	557d                	li	a0,-1
    80002746:	74a2                	ld	s1,40(sp)
    80002748:	69e2                	ld	s3,24(sp)
    8000274a:	bfe9                	j	80002724 <sys_sleep+0x94>

000000008000274c <sys_kill>:

uint64
sys_kill(void)
{
    8000274c:	1101                	addi	sp,sp,-32
    8000274e:	ec06                	sd	ra,24(sp)
    80002750:	e822                	sd	s0,16(sp)
    80002752:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002754:	fec40593          	addi	a1,s0,-20
    80002758:	4501                	li	a0,0
    8000275a:	00000097          	auipc	ra,0x0
    8000275e:	d88080e7          	jalr	-632(ra) # 800024e2 <argint>
  return kill(pid);
    80002762:	fec42503          	lw	a0,-20(s0)
    80002766:	fffff097          	auipc	ra,0xfffff
    8000276a:	40c080e7          	jalr	1036(ra) # 80001b72 <kill>
}
    8000276e:	60e2                	ld	ra,24(sp)
    80002770:	6442                	ld	s0,16(sp)
    80002772:	6105                	addi	sp,sp,32
    80002774:	8082                	ret

0000000080002776 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002776:	1101                	addi	sp,sp,-32
    80002778:	ec06                	sd	ra,24(sp)
    8000277a:	e822                	sd	s0,16(sp)
    8000277c:	e426                	sd	s1,8(sp)
    8000277e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002780:	0002f517          	auipc	a0,0x2f
    80002784:	bf850513          	addi	a0,a0,-1032 # 80031378 <tickslock>
    80002788:	00004097          	auipc	ra,0x4
    8000278c:	094080e7          	jalr	148(ra) # 8000681c <acquire>
  xticks = ticks;
    80002790:	00009497          	auipc	s1,0x9
    80002794:	d684a483          	lw	s1,-664(s1) # 8000b4f8 <ticks>
  release(&tickslock);
    80002798:	0002f517          	auipc	a0,0x2f
    8000279c:	be050513          	addi	a0,a0,-1056 # 80031378 <tickslock>
    800027a0:	00004097          	auipc	ra,0x4
    800027a4:	130080e7          	jalr	304(ra) # 800068d0 <release>
  return xticks;
}
    800027a8:	02049513          	slli	a0,s1,0x20
    800027ac:	9101                	srli	a0,a0,0x20
    800027ae:	60e2                	ld	ra,24(sp)
    800027b0:	6442                	ld	s0,16(sp)
    800027b2:	64a2                	ld	s1,8(sp)
    800027b4:	6105                	addi	sp,sp,32
    800027b6:	8082                	ret

00000000800027b8 <sys_cowstats>:

// Calculate the amount of memory (in bytes) saved by COW mechanism
uint64
sys_cowstats(void)
{
    800027b8:	7139                	addi	sp,sp,-64
    800027ba:	fc06                	sd	ra,56(sp)
    800027bc:	f822                	sd	s0,48(sp)
    800027be:	f426                	sd	s1,40(sp)
    800027c0:	f04a                	sd	s2,32(sp)
    800027c2:	ec4e                	sd	s3,24(sp)
    800027c4:	e852                	sd	s4,16(sp)
    800027c6:	e456                	sd	s5,8(sp)
    800027c8:	0080                	addi	s0,sp,64
  uint64 saved = 0;
  char *pa;
  
  // Iterate through all physical pages from KERNBASE to PHYSTOP
  for(pa = (char*)KERNBASE; pa < (char*)PHYSTOP; pa += PGSIZE) {
    800027ca:	4485                	li	s1,1
    800027cc:	04fe                	slli	s1,s1,0x1f
  uint64 saved = 0;
    800027ce:	4901                	li	s2,0
    int rc = krefcount(pa);
    if(rc > 1) {
    800027d0:	4a85                	li	s5,1
  for(pa = (char*)KERNBASE; pa < (char*)PHYSTOP; pa += PGSIZE) {
    800027d2:	6a05                	lui	s4,0x1
    800027d4:	49c5                	li	s3,17
    800027d6:	09ee                	slli	s3,s3,0x1b
    800027d8:	a021                	j	800027e0 <sys_cowstats+0x28>
    800027da:	94d2                	add	s1,s1,s4
    800027dc:	01348e63          	beq	s1,s3,800027f8 <sys_cowstats+0x40>
    int rc = krefcount(pa);
    800027e0:	8526                	mv	a0,s1
    800027e2:	ffffe097          	auipc	ra,0xffffe
    800027e6:	b8a080e7          	jalr	-1142(ra) # 8000036c <krefcount>
    if(rc > 1) {
    800027ea:	feaad8e3          	bge	s5,a0,800027da <sys_cowstats+0x22>
      // If a page is referenced more than once, COW saves (rc-1) * PGSIZE bytes
      saved += (rc - 1) * PGSIZE;
    800027ee:	357d                	addiw	a0,a0,-1
    800027f0:	00c5151b          	slliw	a0,a0,0xc
    800027f4:	992a                	add	s2,s2,a0
    800027f6:	b7d5                	j	800027da <sys_cowstats+0x22>
    }
  }
  
  return saved;
}
    800027f8:	854a                	mv	a0,s2
    800027fa:	70e2                	ld	ra,56(sp)
    800027fc:	7442                	ld	s0,48(sp)
    800027fe:	74a2                	ld	s1,40(sp)
    80002800:	7902                	ld	s2,32(sp)
    80002802:	69e2                	ld	s3,24(sp)
    80002804:	6a42                	ld	s4,16(sp)
    80002806:	6aa2                	ld	s5,8(sp)
    80002808:	6121                	addi	sp,sp,64
    8000280a:	8082                	ret

000000008000280c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000280c:	7179                	addi	sp,sp,-48
    8000280e:	f406                	sd	ra,40(sp)
    80002810:	f022                	sd	s0,32(sp)
    80002812:	ec26                	sd	s1,24(sp)
    80002814:	e84a                	sd	s2,16(sp)
    80002816:	e44e                	sd	s3,8(sp)
    80002818:	e052                	sd	s4,0(sp)
    8000281a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000281c:	00006597          	auipc	a1,0x6
    80002820:	d0458593          	addi	a1,a1,-764 # 80008520 <etext+0x520>
    80002824:	0002f517          	auipc	a0,0x2f
    80002828:	b6c50513          	addi	a0,a0,-1172 # 80031390 <bcache>
    8000282c:	00004097          	auipc	ra,0x4
    80002830:	f60080e7          	jalr	-160(ra) # 8000678c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002834:	00037797          	auipc	a5,0x37
    80002838:	b5c78793          	addi	a5,a5,-1188 # 80039390 <bcache+0x8000>
    8000283c:	00037717          	auipc	a4,0x37
    80002840:	dbc70713          	addi	a4,a4,-580 # 800395f8 <bcache+0x8268>
    80002844:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002848:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000284c:	0002f497          	auipc	s1,0x2f
    80002850:	b5c48493          	addi	s1,s1,-1188 # 800313a8 <bcache+0x18>
    b->next = bcache.head.next;
    80002854:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002856:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002858:	00006a17          	auipc	s4,0x6
    8000285c:	cd0a0a13          	addi	s4,s4,-816 # 80008528 <etext+0x528>
    b->next = bcache.head.next;
    80002860:	2b893783          	ld	a5,696(s2)
    80002864:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002866:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000286a:	85d2                	mv	a1,s4
    8000286c:	01048513          	addi	a0,s1,16
    80002870:	00001097          	auipc	ra,0x1
    80002874:	4e8080e7          	jalr	1256(ra) # 80003d58 <initsleeplock>
    bcache.head.next->prev = b;
    80002878:	2b893783          	ld	a5,696(s2)
    8000287c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000287e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002882:	45848493          	addi	s1,s1,1112
    80002886:	fd349de3          	bne	s1,s3,80002860 <binit+0x54>
  }
}
    8000288a:	70a2                	ld	ra,40(sp)
    8000288c:	7402                	ld	s0,32(sp)
    8000288e:	64e2                	ld	s1,24(sp)
    80002890:	6942                	ld	s2,16(sp)
    80002892:	69a2                	ld	s3,8(sp)
    80002894:	6a02                	ld	s4,0(sp)
    80002896:	6145                	addi	sp,sp,48
    80002898:	8082                	ret

000000008000289a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000289a:	7179                	addi	sp,sp,-48
    8000289c:	f406                	sd	ra,40(sp)
    8000289e:	f022                	sd	s0,32(sp)
    800028a0:	ec26                	sd	s1,24(sp)
    800028a2:	e84a                	sd	s2,16(sp)
    800028a4:	e44e                	sd	s3,8(sp)
    800028a6:	1800                	addi	s0,sp,48
    800028a8:	892a                	mv	s2,a0
    800028aa:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800028ac:	0002f517          	auipc	a0,0x2f
    800028b0:	ae450513          	addi	a0,a0,-1308 # 80031390 <bcache>
    800028b4:	00004097          	auipc	ra,0x4
    800028b8:	f68080e7          	jalr	-152(ra) # 8000681c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800028bc:	00037497          	auipc	s1,0x37
    800028c0:	d8c4b483          	ld	s1,-628(s1) # 80039648 <bcache+0x82b8>
    800028c4:	00037797          	auipc	a5,0x37
    800028c8:	d3478793          	addi	a5,a5,-716 # 800395f8 <bcache+0x8268>
    800028cc:	02f48f63          	beq	s1,a5,8000290a <bread+0x70>
    800028d0:	873e                	mv	a4,a5
    800028d2:	a021                	j	800028da <bread+0x40>
    800028d4:	68a4                	ld	s1,80(s1)
    800028d6:	02e48a63          	beq	s1,a4,8000290a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800028da:	449c                	lw	a5,8(s1)
    800028dc:	ff279ce3          	bne	a5,s2,800028d4 <bread+0x3a>
    800028e0:	44dc                	lw	a5,12(s1)
    800028e2:	ff3799e3          	bne	a5,s3,800028d4 <bread+0x3a>
      b->refcnt++;
    800028e6:	40bc                	lw	a5,64(s1)
    800028e8:	2785                	addiw	a5,a5,1
    800028ea:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800028ec:	0002f517          	auipc	a0,0x2f
    800028f0:	aa450513          	addi	a0,a0,-1372 # 80031390 <bcache>
    800028f4:	00004097          	auipc	ra,0x4
    800028f8:	fdc080e7          	jalr	-36(ra) # 800068d0 <release>
      acquiresleep(&b->lock);
    800028fc:	01048513          	addi	a0,s1,16
    80002900:	00001097          	auipc	ra,0x1
    80002904:	492080e7          	jalr	1170(ra) # 80003d92 <acquiresleep>
      return b;
    80002908:	a8b9                	j	80002966 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000290a:	00037497          	auipc	s1,0x37
    8000290e:	d364b483          	ld	s1,-714(s1) # 80039640 <bcache+0x82b0>
    80002912:	00037797          	auipc	a5,0x37
    80002916:	ce678793          	addi	a5,a5,-794 # 800395f8 <bcache+0x8268>
    8000291a:	00f48863          	beq	s1,a5,8000292a <bread+0x90>
    8000291e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002920:	40bc                	lw	a5,64(s1)
    80002922:	cf81                	beqz	a5,8000293a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002924:	64a4                	ld	s1,72(s1)
    80002926:	fee49de3          	bne	s1,a4,80002920 <bread+0x86>
  panic("bget: no buffers");
    8000292a:	00006517          	auipc	a0,0x6
    8000292e:	c0650513          	addi	a0,a0,-1018 # 80008530 <etext+0x530>
    80002932:	00004097          	auipc	ra,0x4
    80002936:	970080e7          	jalr	-1680(ra) # 800062a2 <panic>
      b->dev = dev;
    8000293a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000293e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002942:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002946:	4785                	li	a5,1
    80002948:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000294a:	0002f517          	auipc	a0,0x2f
    8000294e:	a4650513          	addi	a0,a0,-1466 # 80031390 <bcache>
    80002952:	00004097          	auipc	ra,0x4
    80002956:	f7e080e7          	jalr	-130(ra) # 800068d0 <release>
      acquiresleep(&b->lock);
    8000295a:	01048513          	addi	a0,s1,16
    8000295e:	00001097          	auipc	ra,0x1
    80002962:	434080e7          	jalr	1076(ra) # 80003d92 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002966:	409c                	lw	a5,0(s1)
    80002968:	cb89                	beqz	a5,8000297a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000296a:	8526                	mv	a0,s1
    8000296c:	70a2                	ld	ra,40(sp)
    8000296e:	7402                	ld	s0,32(sp)
    80002970:	64e2                	ld	s1,24(sp)
    80002972:	6942                	ld	s2,16(sp)
    80002974:	69a2                	ld	s3,8(sp)
    80002976:	6145                	addi	sp,sp,48
    80002978:	8082                	ret
    virtio_disk_rw(b, 0);
    8000297a:	4581                	li	a1,0
    8000297c:	8526                	mv	a0,s1
    8000297e:	00003097          	auipc	ra,0x3
    80002982:	0fa080e7          	jalr	250(ra) # 80005a78 <virtio_disk_rw>
    b->valid = 1;
    80002986:	4785                	li	a5,1
    80002988:	c09c                	sw	a5,0(s1)
  return b;
    8000298a:	b7c5                	j	8000296a <bread+0xd0>

000000008000298c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000298c:	1101                	addi	sp,sp,-32
    8000298e:	ec06                	sd	ra,24(sp)
    80002990:	e822                	sd	s0,16(sp)
    80002992:	e426                	sd	s1,8(sp)
    80002994:	1000                	addi	s0,sp,32
    80002996:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002998:	0541                	addi	a0,a0,16
    8000299a:	00001097          	auipc	ra,0x1
    8000299e:	492080e7          	jalr	1170(ra) # 80003e2c <holdingsleep>
    800029a2:	cd01                	beqz	a0,800029ba <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800029a4:	4585                	li	a1,1
    800029a6:	8526                	mv	a0,s1
    800029a8:	00003097          	auipc	ra,0x3
    800029ac:	0d0080e7          	jalr	208(ra) # 80005a78 <virtio_disk_rw>
}
    800029b0:	60e2                	ld	ra,24(sp)
    800029b2:	6442                	ld	s0,16(sp)
    800029b4:	64a2                	ld	s1,8(sp)
    800029b6:	6105                	addi	sp,sp,32
    800029b8:	8082                	ret
    panic("bwrite");
    800029ba:	00006517          	auipc	a0,0x6
    800029be:	b8e50513          	addi	a0,a0,-1138 # 80008548 <etext+0x548>
    800029c2:	00004097          	auipc	ra,0x4
    800029c6:	8e0080e7          	jalr	-1824(ra) # 800062a2 <panic>

00000000800029ca <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800029ca:	1101                	addi	sp,sp,-32
    800029cc:	ec06                	sd	ra,24(sp)
    800029ce:	e822                	sd	s0,16(sp)
    800029d0:	e426                	sd	s1,8(sp)
    800029d2:	e04a                	sd	s2,0(sp)
    800029d4:	1000                	addi	s0,sp,32
    800029d6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800029d8:	01050913          	addi	s2,a0,16
    800029dc:	854a                	mv	a0,s2
    800029de:	00001097          	auipc	ra,0x1
    800029e2:	44e080e7          	jalr	1102(ra) # 80003e2c <holdingsleep>
    800029e6:	c925                	beqz	a0,80002a56 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800029e8:	854a                	mv	a0,s2
    800029ea:	00001097          	auipc	ra,0x1
    800029ee:	3fe080e7          	jalr	1022(ra) # 80003de8 <releasesleep>

  acquire(&bcache.lock);
    800029f2:	0002f517          	auipc	a0,0x2f
    800029f6:	99e50513          	addi	a0,a0,-1634 # 80031390 <bcache>
    800029fa:	00004097          	auipc	ra,0x4
    800029fe:	e22080e7          	jalr	-478(ra) # 8000681c <acquire>
  b->refcnt--;
    80002a02:	40bc                	lw	a5,64(s1)
    80002a04:	37fd                	addiw	a5,a5,-1
    80002a06:	0007871b          	sext.w	a4,a5
    80002a0a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002a0c:	e71d                	bnez	a4,80002a3a <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002a0e:	68b8                	ld	a4,80(s1)
    80002a10:	64bc                	ld	a5,72(s1)
    80002a12:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002a14:	68b8                	ld	a4,80(s1)
    80002a16:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002a18:	00037797          	auipc	a5,0x37
    80002a1c:	97878793          	addi	a5,a5,-1672 # 80039390 <bcache+0x8000>
    80002a20:	2b87b703          	ld	a4,696(a5)
    80002a24:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002a26:	00037717          	auipc	a4,0x37
    80002a2a:	bd270713          	addi	a4,a4,-1070 # 800395f8 <bcache+0x8268>
    80002a2e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002a30:	2b87b703          	ld	a4,696(a5)
    80002a34:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002a36:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002a3a:	0002f517          	auipc	a0,0x2f
    80002a3e:	95650513          	addi	a0,a0,-1706 # 80031390 <bcache>
    80002a42:	00004097          	auipc	ra,0x4
    80002a46:	e8e080e7          	jalr	-370(ra) # 800068d0 <release>
}
    80002a4a:	60e2                	ld	ra,24(sp)
    80002a4c:	6442                	ld	s0,16(sp)
    80002a4e:	64a2                	ld	s1,8(sp)
    80002a50:	6902                	ld	s2,0(sp)
    80002a52:	6105                	addi	sp,sp,32
    80002a54:	8082                	ret
    panic("brelse");
    80002a56:	00006517          	auipc	a0,0x6
    80002a5a:	afa50513          	addi	a0,a0,-1286 # 80008550 <etext+0x550>
    80002a5e:	00004097          	auipc	ra,0x4
    80002a62:	844080e7          	jalr	-1980(ra) # 800062a2 <panic>

0000000080002a66 <bpin>:

void
bpin(struct buf *b) {
    80002a66:	1101                	addi	sp,sp,-32
    80002a68:	ec06                	sd	ra,24(sp)
    80002a6a:	e822                	sd	s0,16(sp)
    80002a6c:	e426                	sd	s1,8(sp)
    80002a6e:	1000                	addi	s0,sp,32
    80002a70:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002a72:	0002f517          	auipc	a0,0x2f
    80002a76:	91e50513          	addi	a0,a0,-1762 # 80031390 <bcache>
    80002a7a:	00004097          	auipc	ra,0x4
    80002a7e:	da2080e7          	jalr	-606(ra) # 8000681c <acquire>
  b->refcnt++;
    80002a82:	40bc                	lw	a5,64(s1)
    80002a84:	2785                	addiw	a5,a5,1
    80002a86:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002a88:	0002f517          	auipc	a0,0x2f
    80002a8c:	90850513          	addi	a0,a0,-1784 # 80031390 <bcache>
    80002a90:	00004097          	auipc	ra,0x4
    80002a94:	e40080e7          	jalr	-448(ra) # 800068d0 <release>
}
    80002a98:	60e2                	ld	ra,24(sp)
    80002a9a:	6442                	ld	s0,16(sp)
    80002a9c:	64a2                	ld	s1,8(sp)
    80002a9e:	6105                	addi	sp,sp,32
    80002aa0:	8082                	ret

0000000080002aa2 <bunpin>:

void
bunpin(struct buf *b) {
    80002aa2:	1101                	addi	sp,sp,-32
    80002aa4:	ec06                	sd	ra,24(sp)
    80002aa6:	e822                	sd	s0,16(sp)
    80002aa8:	e426                	sd	s1,8(sp)
    80002aaa:	1000                	addi	s0,sp,32
    80002aac:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002aae:	0002f517          	auipc	a0,0x2f
    80002ab2:	8e250513          	addi	a0,a0,-1822 # 80031390 <bcache>
    80002ab6:	00004097          	auipc	ra,0x4
    80002aba:	d66080e7          	jalr	-666(ra) # 8000681c <acquire>
  b->refcnt--;
    80002abe:	40bc                	lw	a5,64(s1)
    80002ac0:	37fd                	addiw	a5,a5,-1
    80002ac2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002ac4:	0002f517          	auipc	a0,0x2f
    80002ac8:	8cc50513          	addi	a0,a0,-1844 # 80031390 <bcache>
    80002acc:	00004097          	auipc	ra,0x4
    80002ad0:	e04080e7          	jalr	-508(ra) # 800068d0 <release>
}
    80002ad4:	60e2                	ld	ra,24(sp)
    80002ad6:	6442                	ld	s0,16(sp)
    80002ad8:	64a2                	ld	s1,8(sp)
    80002ada:	6105                	addi	sp,sp,32
    80002adc:	8082                	ret

0000000080002ade <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002ade:	1101                	addi	sp,sp,-32
    80002ae0:	ec06                	sd	ra,24(sp)
    80002ae2:	e822                	sd	s0,16(sp)
    80002ae4:	e426                	sd	s1,8(sp)
    80002ae6:	e04a                	sd	s2,0(sp)
    80002ae8:	1000                	addi	s0,sp,32
    80002aea:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002aec:	00d5d59b          	srliw	a1,a1,0xd
    80002af0:	00037797          	auipc	a5,0x37
    80002af4:	f7c7a783          	lw	a5,-132(a5) # 80039a6c <sb+0x1c>
    80002af8:	9dbd                	addw	a1,a1,a5
    80002afa:	00000097          	auipc	ra,0x0
    80002afe:	da0080e7          	jalr	-608(ra) # 8000289a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002b02:	0074f713          	andi	a4,s1,7
    80002b06:	4785                	li	a5,1
    80002b08:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002b0c:	14ce                	slli	s1,s1,0x33
    80002b0e:	90d9                	srli	s1,s1,0x36
    80002b10:	00950733          	add	a4,a0,s1
    80002b14:	05874703          	lbu	a4,88(a4)
    80002b18:	00e7f6b3          	and	a3,a5,a4
    80002b1c:	c69d                	beqz	a3,80002b4a <bfree+0x6c>
    80002b1e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002b20:	94aa                	add	s1,s1,a0
    80002b22:	fff7c793          	not	a5,a5
    80002b26:	8f7d                	and	a4,a4,a5
    80002b28:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002b2c:	00001097          	auipc	ra,0x1
    80002b30:	148080e7          	jalr	328(ra) # 80003c74 <log_write>
  brelse(bp);
    80002b34:	854a                	mv	a0,s2
    80002b36:	00000097          	auipc	ra,0x0
    80002b3a:	e94080e7          	jalr	-364(ra) # 800029ca <brelse>
}
    80002b3e:	60e2                	ld	ra,24(sp)
    80002b40:	6442                	ld	s0,16(sp)
    80002b42:	64a2                	ld	s1,8(sp)
    80002b44:	6902                	ld	s2,0(sp)
    80002b46:	6105                	addi	sp,sp,32
    80002b48:	8082                	ret
    panic("freeing free block");
    80002b4a:	00006517          	auipc	a0,0x6
    80002b4e:	a0e50513          	addi	a0,a0,-1522 # 80008558 <etext+0x558>
    80002b52:	00003097          	auipc	ra,0x3
    80002b56:	750080e7          	jalr	1872(ra) # 800062a2 <panic>

0000000080002b5a <balloc>:
{
    80002b5a:	711d                	addi	sp,sp,-96
    80002b5c:	ec86                	sd	ra,88(sp)
    80002b5e:	e8a2                	sd	s0,80(sp)
    80002b60:	e4a6                	sd	s1,72(sp)
    80002b62:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002b64:	00037797          	auipc	a5,0x37
    80002b68:	ef07a783          	lw	a5,-272(a5) # 80039a54 <sb+0x4>
    80002b6c:	10078f63          	beqz	a5,80002c8a <balloc+0x130>
    80002b70:	e0ca                	sd	s2,64(sp)
    80002b72:	fc4e                	sd	s3,56(sp)
    80002b74:	f852                	sd	s4,48(sp)
    80002b76:	f456                	sd	s5,40(sp)
    80002b78:	f05a                	sd	s6,32(sp)
    80002b7a:	ec5e                	sd	s7,24(sp)
    80002b7c:	e862                	sd	s8,16(sp)
    80002b7e:	e466                	sd	s9,8(sp)
    80002b80:	8baa                	mv	s7,a0
    80002b82:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002b84:	00037b17          	auipc	s6,0x37
    80002b88:	eccb0b13          	addi	s6,s6,-308 # 80039a50 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002b8c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002b8e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002b90:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002b92:	6c89                	lui	s9,0x2
    80002b94:	a061                	j	80002c1c <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002b96:	97ca                	add	a5,a5,s2
    80002b98:	8e55                	or	a2,a2,a3
    80002b9a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002b9e:	854a                	mv	a0,s2
    80002ba0:	00001097          	auipc	ra,0x1
    80002ba4:	0d4080e7          	jalr	212(ra) # 80003c74 <log_write>
        brelse(bp);
    80002ba8:	854a                	mv	a0,s2
    80002baa:	00000097          	auipc	ra,0x0
    80002bae:	e20080e7          	jalr	-480(ra) # 800029ca <brelse>
  bp = bread(dev, bno);
    80002bb2:	85a6                	mv	a1,s1
    80002bb4:	855e                	mv	a0,s7
    80002bb6:	00000097          	auipc	ra,0x0
    80002bba:	ce4080e7          	jalr	-796(ra) # 8000289a <bread>
    80002bbe:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002bc0:	40000613          	li	a2,1024
    80002bc4:	4581                	li	a1,0
    80002bc6:	05850513          	addi	a0,a0,88
    80002bca:	ffffd097          	auipc	ra,0xffffd
    80002bce:	7fa080e7          	jalr	2042(ra) # 800003c4 <memset>
  log_write(bp);
    80002bd2:	854a                	mv	a0,s2
    80002bd4:	00001097          	auipc	ra,0x1
    80002bd8:	0a0080e7          	jalr	160(ra) # 80003c74 <log_write>
  brelse(bp);
    80002bdc:	854a                	mv	a0,s2
    80002bde:	00000097          	auipc	ra,0x0
    80002be2:	dec080e7          	jalr	-532(ra) # 800029ca <brelse>
}
    80002be6:	6906                	ld	s2,64(sp)
    80002be8:	79e2                	ld	s3,56(sp)
    80002bea:	7a42                	ld	s4,48(sp)
    80002bec:	7aa2                	ld	s5,40(sp)
    80002bee:	7b02                	ld	s6,32(sp)
    80002bf0:	6be2                	ld	s7,24(sp)
    80002bf2:	6c42                	ld	s8,16(sp)
    80002bf4:	6ca2                	ld	s9,8(sp)
}
    80002bf6:	8526                	mv	a0,s1
    80002bf8:	60e6                	ld	ra,88(sp)
    80002bfa:	6446                	ld	s0,80(sp)
    80002bfc:	64a6                	ld	s1,72(sp)
    80002bfe:	6125                	addi	sp,sp,96
    80002c00:	8082                	ret
    brelse(bp);
    80002c02:	854a                	mv	a0,s2
    80002c04:	00000097          	auipc	ra,0x0
    80002c08:	dc6080e7          	jalr	-570(ra) # 800029ca <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002c0c:	015c87bb          	addw	a5,s9,s5
    80002c10:	00078a9b          	sext.w	s5,a5
    80002c14:	004b2703          	lw	a4,4(s6)
    80002c18:	06eaf163          	bgeu	s5,a4,80002c7a <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    80002c1c:	41fad79b          	sraiw	a5,s5,0x1f
    80002c20:	0137d79b          	srliw	a5,a5,0x13
    80002c24:	015787bb          	addw	a5,a5,s5
    80002c28:	40d7d79b          	sraiw	a5,a5,0xd
    80002c2c:	01cb2583          	lw	a1,28(s6)
    80002c30:	9dbd                	addw	a1,a1,a5
    80002c32:	855e                	mv	a0,s7
    80002c34:	00000097          	auipc	ra,0x0
    80002c38:	c66080e7          	jalr	-922(ra) # 8000289a <bread>
    80002c3c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002c3e:	004b2503          	lw	a0,4(s6)
    80002c42:	000a849b          	sext.w	s1,s5
    80002c46:	8762                	mv	a4,s8
    80002c48:	faa4fde3          	bgeu	s1,a0,80002c02 <balloc+0xa8>
      m = 1 << (bi % 8);
    80002c4c:	00777693          	andi	a3,a4,7
    80002c50:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002c54:	41f7579b          	sraiw	a5,a4,0x1f
    80002c58:	01d7d79b          	srliw	a5,a5,0x1d
    80002c5c:	9fb9                	addw	a5,a5,a4
    80002c5e:	4037d79b          	sraiw	a5,a5,0x3
    80002c62:	00f90633          	add	a2,s2,a5
    80002c66:	05864603          	lbu	a2,88(a2)
    80002c6a:	00c6f5b3          	and	a1,a3,a2
    80002c6e:	d585                	beqz	a1,80002b96 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002c70:	2705                	addiw	a4,a4,1
    80002c72:	2485                	addiw	s1,s1,1
    80002c74:	fd471ae3          	bne	a4,s4,80002c48 <balloc+0xee>
    80002c78:	b769                	j	80002c02 <balloc+0xa8>
    80002c7a:	6906                	ld	s2,64(sp)
    80002c7c:	79e2                	ld	s3,56(sp)
    80002c7e:	7a42                	ld	s4,48(sp)
    80002c80:	7aa2                	ld	s5,40(sp)
    80002c82:	7b02                	ld	s6,32(sp)
    80002c84:	6be2                	ld	s7,24(sp)
    80002c86:	6c42                	ld	s8,16(sp)
    80002c88:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002c8a:	00006517          	auipc	a0,0x6
    80002c8e:	8e650513          	addi	a0,a0,-1818 # 80008570 <etext+0x570>
    80002c92:	00003097          	auipc	ra,0x3
    80002c96:	65a080e7          	jalr	1626(ra) # 800062ec <printf>
  return 0;
    80002c9a:	4481                	li	s1,0
    80002c9c:	bfa9                	j	80002bf6 <balloc+0x9c>

0000000080002c9e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002c9e:	7179                	addi	sp,sp,-48
    80002ca0:	f406                	sd	ra,40(sp)
    80002ca2:	f022                	sd	s0,32(sp)
    80002ca4:	ec26                	sd	s1,24(sp)
    80002ca6:	e84a                	sd	s2,16(sp)
    80002ca8:	e44e                	sd	s3,8(sp)
    80002caa:	1800                	addi	s0,sp,48
    80002cac:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002cae:	47ad                	li	a5,11
    80002cb0:	02b7e863          	bltu	a5,a1,80002ce0 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002cb4:	02059793          	slli	a5,a1,0x20
    80002cb8:	01e7d593          	srli	a1,a5,0x1e
    80002cbc:	00b504b3          	add	s1,a0,a1
    80002cc0:	0504a903          	lw	s2,80(s1)
    80002cc4:	08091263          	bnez	s2,80002d48 <bmap+0xaa>
      addr = balloc(ip->dev);
    80002cc8:	4108                	lw	a0,0(a0)
    80002cca:	00000097          	auipc	ra,0x0
    80002cce:	e90080e7          	jalr	-368(ra) # 80002b5a <balloc>
    80002cd2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002cd6:	06090963          	beqz	s2,80002d48 <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    80002cda:	0524a823          	sw	s2,80(s1)
    80002cde:	a0ad                	j	80002d48 <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002ce0:	ff45849b          	addiw	s1,a1,-12
    80002ce4:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002ce8:	0ff00793          	li	a5,255
    80002cec:	08e7e863          	bltu	a5,a4,80002d7c <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002cf0:	08052903          	lw	s2,128(a0)
    80002cf4:	00091f63          	bnez	s2,80002d12 <bmap+0x74>
      addr = balloc(ip->dev);
    80002cf8:	4108                	lw	a0,0(a0)
    80002cfa:	00000097          	auipc	ra,0x0
    80002cfe:	e60080e7          	jalr	-416(ra) # 80002b5a <balloc>
    80002d02:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002d06:	04090163          	beqz	s2,80002d48 <bmap+0xaa>
    80002d0a:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002d0c:	0929a023          	sw	s2,128(s3)
    80002d10:	a011                	j	80002d14 <bmap+0x76>
    80002d12:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002d14:	85ca                	mv	a1,s2
    80002d16:	0009a503          	lw	a0,0(s3)
    80002d1a:	00000097          	auipc	ra,0x0
    80002d1e:	b80080e7          	jalr	-1152(ra) # 8000289a <bread>
    80002d22:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002d24:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002d28:	02049713          	slli	a4,s1,0x20
    80002d2c:	01e75593          	srli	a1,a4,0x1e
    80002d30:	00b784b3          	add	s1,a5,a1
    80002d34:	0004a903          	lw	s2,0(s1)
    80002d38:	02090063          	beqz	s2,80002d58 <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002d3c:	8552                	mv	a0,s4
    80002d3e:	00000097          	auipc	ra,0x0
    80002d42:	c8c080e7          	jalr	-884(ra) # 800029ca <brelse>
    return addr;
    80002d46:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002d48:	854a                	mv	a0,s2
    80002d4a:	70a2                	ld	ra,40(sp)
    80002d4c:	7402                	ld	s0,32(sp)
    80002d4e:	64e2                	ld	s1,24(sp)
    80002d50:	6942                	ld	s2,16(sp)
    80002d52:	69a2                	ld	s3,8(sp)
    80002d54:	6145                	addi	sp,sp,48
    80002d56:	8082                	ret
      addr = balloc(ip->dev);
    80002d58:	0009a503          	lw	a0,0(s3)
    80002d5c:	00000097          	auipc	ra,0x0
    80002d60:	dfe080e7          	jalr	-514(ra) # 80002b5a <balloc>
    80002d64:	0005091b          	sext.w	s2,a0
      if(addr){
    80002d68:	fc090ae3          	beqz	s2,80002d3c <bmap+0x9e>
        a[bn] = addr;
    80002d6c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002d70:	8552                	mv	a0,s4
    80002d72:	00001097          	auipc	ra,0x1
    80002d76:	f02080e7          	jalr	-254(ra) # 80003c74 <log_write>
    80002d7a:	b7c9                	j	80002d3c <bmap+0x9e>
    80002d7c:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002d7e:	00006517          	auipc	a0,0x6
    80002d82:	80a50513          	addi	a0,a0,-2038 # 80008588 <etext+0x588>
    80002d86:	00003097          	auipc	ra,0x3
    80002d8a:	51c080e7          	jalr	1308(ra) # 800062a2 <panic>

0000000080002d8e <iget>:
{
    80002d8e:	7179                	addi	sp,sp,-48
    80002d90:	f406                	sd	ra,40(sp)
    80002d92:	f022                	sd	s0,32(sp)
    80002d94:	ec26                	sd	s1,24(sp)
    80002d96:	e84a                	sd	s2,16(sp)
    80002d98:	e44e                	sd	s3,8(sp)
    80002d9a:	e052                	sd	s4,0(sp)
    80002d9c:	1800                	addi	s0,sp,48
    80002d9e:	89aa                	mv	s3,a0
    80002da0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002da2:	00037517          	auipc	a0,0x37
    80002da6:	cce50513          	addi	a0,a0,-818 # 80039a70 <itable>
    80002daa:	00004097          	auipc	ra,0x4
    80002dae:	a72080e7          	jalr	-1422(ra) # 8000681c <acquire>
  empty = 0;
    80002db2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002db4:	00037497          	auipc	s1,0x37
    80002db8:	cd448493          	addi	s1,s1,-812 # 80039a88 <itable+0x18>
    80002dbc:	00038697          	auipc	a3,0x38
    80002dc0:	75c68693          	addi	a3,a3,1884 # 8003b518 <log>
    80002dc4:	a039                	j	80002dd2 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002dc6:	02090b63          	beqz	s2,80002dfc <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002dca:	08848493          	addi	s1,s1,136
    80002dce:	02d48a63          	beq	s1,a3,80002e02 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002dd2:	449c                	lw	a5,8(s1)
    80002dd4:	fef059e3          	blez	a5,80002dc6 <iget+0x38>
    80002dd8:	4098                	lw	a4,0(s1)
    80002dda:	ff3716e3          	bne	a4,s3,80002dc6 <iget+0x38>
    80002dde:	40d8                	lw	a4,4(s1)
    80002de0:	ff4713e3          	bne	a4,s4,80002dc6 <iget+0x38>
      ip->ref++;
    80002de4:	2785                	addiw	a5,a5,1
    80002de6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002de8:	00037517          	auipc	a0,0x37
    80002dec:	c8850513          	addi	a0,a0,-888 # 80039a70 <itable>
    80002df0:	00004097          	auipc	ra,0x4
    80002df4:	ae0080e7          	jalr	-1312(ra) # 800068d0 <release>
      return ip;
    80002df8:	8926                	mv	s2,s1
    80002dfa:	a03d                	j	80002e28 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002dfc:	f7f9                	bnez	a5,80002dca <iget+0x3c>
      empty = ip;
    80002dfe:	8926                	mv	s2,s1
    80002e00:	b7e9                	j	80002dca <iget+0x3c>
  if(empty == 0)
    80002e02:	02090c63          	beqz	s2,80002e3a <iget+0xac>
  ip->dev = dev;
    80002e06:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002e0a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002e0e:	4785                	li	a5,1
    80002e10:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002e14:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002e18:	00037517          	auipc	a0,0x37
    80002e1c:	c5850513          	addi	a0,a0,-936 # 80039a70 <itable>
    80002e20:	00004097          	auipc	ra,0x4
    80002e24:	ab0080e7          	jalr	-1360(ra) # 800068d0 <release>
}
    80002e28:	854a                	mv	a0,s2
    80002e2a:	70a2                	ld	ra,40(sp)
    80002e2c:	7402                	ld	s0,32(sp)
    80002e2e:	64e2                	ld	s1,24(sp)
    80002e30:	6942                	ld	s2,16(sp)
    80002e32:	69a2                	ld	s3,8(sp)
    80002e34:	6a02                	ld	s4,0(sp)
    80002e36:	6145                	addi	sp,sp,48
    80002e38:	8082                	ret
    panic("iget: no inodes");
    80002e3a:	00005517          	auipc	a0,0x5
    80002e3e:	76650513          	addi	a0,a0,1894 # 800085a0 <etext+0x5a0>
    80002e42:	00003097          	auipc	ra,0x3
    80002e46:	460080e7          	jalr	1120(ra) # 800062a2 <panic>

0000000080002e4a <fsinit>:
fsinit(int dev) {
    80002e4a:	7179                	addi	sp,sp,-48
    80002e4c:	f406                	sd	ra,40(sp)
    80002e4e:	f022                	sd	s0,32(sp)
    80002e50:	ec26                	sd	s1,24(sp)
    80002e52:	e84a                	sd	s2,16(sp)
    80002e54:	e44e                	sd	s3,8(sp)
    80002e56:	1800                	addi	s0,sp,48
    80002e58:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002e5a:	4585                	li	a1,1
    80002e5c:	00000097          	auipc	ra,0x0
    80002e60:	a3e080e7          	jalr	-1474(ra) # 8000289a <bread>
    80002e64:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002e66:	00037997          	auipc	s3,0x37
    80002e6a:	bea98993          	addi	s3,s3,-1046 # 80039a50 <sb>
    80002e6e:	02000613          	li	a2,32
    80002e72:	05850593          	addi	a1,a0,88
    80002e76:	854e                	mv	a0,s3
    80002e78:	ffffd097          	auipc	ra,0xffffd
    80002e7c:	5a8080e7          	jalr	1448(ra) # 80000420 <memmove>
  brelse(bp);
    80002e80:	8526                	mv	a0,s1
    80002e82:	00000097          	auipc	ra,0x0
    80002e86:	b48080e7          	jalr	-1208(ra) # 800029ca <brelse>
  if(sb.magic != FSMAGIC)
    80002e8a:	0009a703          	lw	a4,0(s3)
    80002e8e:	102037b7          	lui	a5,0x10203
    80002e92:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002e96:	02f71263          	bne	a4,a5,80002eba <fsinit+0x70>
  initlog(dev, &sb);
    80002e9a:	00037597          	auipc	a1,0x37
    80002e9e:	bb658593          	addi	a1,a1,-1098 # 80039a50 <sb>
    80002ea2:	854a                	mv	a0,s2
    80002ea4:	00001097          	auipc	ra,0x1
    80002ea8:	b60080e7          	jalr	-1184(ra) # 80003a04 <initlog>
}
    80002eac:	70a2                	ld	ra,40(sp)
    80002eae:	7402                	ld	s0,32(sp)
    80002eb0:	64e2                	ld	s1,24(sp)
    80002eb2:	6942                	ld	s2,16(sp)
    80002eb4:	69a2                	ld	s3,8(sp)
    80002eb6:	6145                	addi	sp,sp,48
    80002eb8:	8082                	ret
    panic("invalid file system");
    80002eba:	00005517          	auipc	a0,0x5
    80002ebe:	6f650513          	addi	a0,a0,1782 # 800085b0 <etext+0x5b0>
    80002ec2:	00003097          	auipc	ra,0x3
    80002ec6:	3e0080e7          	jalr	992(ra) # 800062a2 <panic>

0000000080002eca <iinit>:
{
    80002eca:	7179                	addi	sp,sp,-48
    80002ecc:	f406                	sd	ra,40(sp)
    80002ece:	f022                	sd	s0,32(sp)
    80002ed0:	ec26                	sd	s1,24(sp)
    80002ed2:	e84a                	sd	s2,16(sp)
    80002ed4:	e44e                	sd	s3,8(sp)
    80002ed6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002ed8:	00005597          	auipc	a1,0x5
    80002edc:	6f058593          	addi	a1,a1,1776 # 800085c8 <etext+0x5c8>
    80002ee0:	00037517          	auipc	a0,0x37
    80002ee4:	b9050513          	addi	a0,a0,-1136 # 80039a70 <itable>
    80002ee8:	00004097          	auipc	ra,0x4
    80002eec:	8a4080e7          	jalr	-1884(ra) # 8000678c <initlock>
  for(i = 0; i < NINODE; i++) {
    80002ef0:	00037497          	auipc	s1,0x37
    80002ef4:	ba848493          	addi	s1,s1,-1112 # 80039a98 <itable+0x28>
    80002ef8:	00038997          	auipc	s3,0x38
    80002efc:	63098993          	addi	s3,s3,1584 # 8003b528 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002f00:	00005917          	auipc	s2,0x5
    80002f04:	6d090913          	addi	s2,s2,1744 # 800085d0 <etext+0x5d0>
    80002f08:	85ca                	mv	a1,s2
    80002f0a:	8526                	mv	a0,s1
    80002f0c:	00001097          	auipc	ra,0x1
    80002f10:	e4c080e7          	jalr	-436(ra) # 80003d58 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002f14:	08848493          	addi	s1,s1,136
    80002f18:	ff3498e3          	bne	s1,s3,80002f08 <iinit+0x3e>
}
    80002f1c:	70a2                	ld	ra,40(sp)
    80002f1e:	7402                	ld	s0,32(sp)
    80002f20:	64e2                	ld	s1,24(sp)
    80002f22:	6942                	ld	s2,16(sp)
    80002f24:	69a2                	ld	s3,8(sp)
    80002f26:	6145                	addi	sp,sp,48
    80002f28:	8082                	ret

0000000080002f2a <ialloc>:
{
    80002f2a:	7139                	addi	sp,sp,-64
    80002f2c:	fc06                	sd	ra,56(sp)
    80002f2e:	f822                	sd	s0,48(sp)
    80002f30:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002f32:	00037717          	auipc	a4,0x37
    80002f36:	b2a72703          	lw	a4,-1238(a4) # 80039a5c <sb+0xc>
    80002f3a:	4785                	li	a5,1
    80002f3c:	06e7f463          	bgeu	a5,a4,80002fa4 <ialloc+0x7a>
    80002f40:	f426                	sd	s1,40(sp)
    80002f42:	f04a                	sd	s2,32(sp)
    80002f44:	ec4e                	sd	s3,24(sp)
    80002f46:	e852                	sd	s4,16(sp)
    80002f48:	e456                	sd	s5,8(sp)
    80002f4a:	e05a                	sd	s6,0(sp)
    80002f4c:	8aaa                	mv	s5,a0
    80002f4e:	8b2e                	mv	s6,a1
    80002f50:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002f52:	00037a17          	auipc	s4,0x37
    80002f56:	afea0a13          	addi	s4,s4,-1282 # 80039a50 <sb>
    80002f5a:	00495593          	srli	a1,s2,0x4
    80002f5e:	018a2783          	lw	a5,24(s4)
    80002f62:	9dbd                	addw	a1,a1,a5
    80002f64:	8556                	mv	a0,s5
    80002f66:	00000097          	auipc	ra,0x0
    80002f6a:	934080e7          	jalr	-1740(ra) # 8000289a <bread>
    80002f6e:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002f70:	05850993          	addi	s3,a0,88
    80002f74:	00f97793          	andi	a5,s2,15
    80002f78:	079a                	slli	a5,a5,0x6
    80002f7a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002f7c:	00099783          	lh	a5,0(s3)
    80002f80:	cf9d                	beqz	a5,80002fbe <ialloc+0x94>
    brelse(bp);
    80002f82:	00000097          	auipc	ra,0x0
    80002f86:	a48080e7          	jalr	-1464(ra) # 800029ca <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002f8a:	0905                	addi	s2,s2,1
    80002f8c:	00ca2703          	lw	a4,12(s4)
    80002f90:	0009079b          	sext.w	a5,s2
    80002f94:	fce7e3e3          	bltu	a5,a4,80002f5a <ialloc+0x30>
    80002f98:	74a2                	ld	s1,40(sp)
    80002f9a:	7902                	ld	s2,32(sp)
    80002f9c:	69e2                	ld	s3,24(sp)
    80002f9e:	6a42                	ld	s4,16(sp)
    80002fa0:	6aa2                	ld	s5,8(sp)
    80002fa2:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002fa4:	00005517          	auipc	a0,0x5
    80002fa8:	63450513          	addi	a0,a0,1588 # 800085d8 <etext+0x5d8>
    80002fac:	00003097          	auipc	ra,0x3
    80002fb0:	340080e7          	jalr	832(ra) # 800062ec <printf>
  return 0;
    80002fb4:	4501                	li	a0,0
}
    80002fb6:	70e2                	ld	ra,56(sp)
    80002fb8:	7442                	ld	s0,48(sp)
    80002fba:	6121                	addi	sp,sp,64
    80002fbc:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002fbe:	04000613          	li	a2,64
    80002fc2:	4581                	li	a1,0
    80002fc4:	854e                	mv	a0,s3
    80002fc6:	ffffd097          	auipc	ra,0xffffd
    80002fca:	3fe080e7          	jalr	1022(ra) # 800003c4 <memset>
      dip->type = type;
    80002fce:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002fd2:	8526                	mv	a0,s1
    80002fd4:	00001097          	auipc	ra,0x1
    80002fd8:	ca0080e7          	jalr	-864(ra) # 80003c74 <log_write>
      brelse(bp);
    80002fdc:	8526                	mv	a0,s1
    80002fde:	00000097          	auipc	ra,0x0
    80002fe2:	9ec080e7          	jalr	-1556(ra) # 800029ca <brelse>
      return iget(dev, inum);
    80002fe6:	0009059b          	sext.w	a1,s2
    80002fea:	8556                	mv	a0,s5
    80002fec:	00000097          	auipc	ra,0x0
    80002ff0:	da2080e7          	jalr	-606(ra) # 80002d8e <iget>
    80002ff4:	74a2                	ld	s1,40(sp)
    80002ff6:	7902                	ld	s2,32(sp)
    80002ff8:	69e2                	ld	s3,24(sp)
    80002ffa:	6a42                	ld	s4,16(sp)
    80002ffc:	6aa2                	ld	s5,8(sp)
    80002ffe:	6b02                	ld	s6,0(sp)
    80003000:	bf5d                	j	80002fb6 <ialloc+0x8c>

0000000080003002 <iupdate>:
{
    80003002:	1101                	addi	sp,sp,-32
    80003004:	ec06                	sd	ra,24(sp)
    80003006:	e822                	sd	s0,16(sp)
    80003008:	e426                	sd	s1,8(sp)
    8000300a:	e04a                	sd	s2,0(sp)
    8000300c:	1000                	addi	s0,sp,32
    8000300e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003010:	415c                	lw	a5,4(a0)
    80003012:	0047d79b          	srliw	a5,a5,0x4
    80003016:	00037597          	auipc	a1,0x37
    8000301a:	a525a583          	lw	a1,-1454(a1) # 80039a68 <sb+0x18>
    8000301e:	9dbd                	addw	a1,a1,a5
    80003020:	4108                	lw	a0,0(a0)
    80003022:	00000097          	auipc	ra,0x0
    80003026:	878080e7          	jalr	-1928(ra) # 8000289a <bread>
    8000302a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000302c:	05850793          	addi	a5,a0,88
    80003030:	40d8                	lw	a4,4(s1)
    80003032:	8b3d                	andi	a4,a4,15
    80003034:	071a                	slli	a4,a4,0x6
    80003036:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003038:	04449703          	lh	a4,68(s1)
    8000303c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003040:	04649703          	lh	a4,70(s1)
    80003044:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003048:	04849703          	lh	a4,72(s1)
    8000304c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003050:	04a49703          	lh	a4,74(s1)
    80003054:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003058:	44f8                	lw	a4,76(s1)
    8000305a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000305c:	03400613          	li	a2,52
    80003060:	05048593          	addi	a1,s1,80
    80003064:	00c78513          	addi	a0,a5,12
    80003068:	ffffd097          	auipc	ra,0xffffd
    8000306c:	3b8080e7          	jalr	952(ra) # 80000420 <memmove>
  log_write(bp);
    80003070:	854a                	mv	a0,s2
    80003072:	00001097          	auipc	ra,0x1
    80003076:	c02080e7          	jalr	-1022(ra) # 80003c74 <log_write>
  brelse(bp);
    8000307a:	854a                	mv	a0,s2
    8000307c:	00000097          	auipc	ra,0x0
    80003080:	94e080e7          	jalr	-1714(ra) # 800029ca <brelse>
}
    80003084:	60e2                	ld	ra,24(sp)
    80003086:	6442                	ld	s0,16(sp)
    80003088:	64a2                	ld	s1,8(sp)
    8000308a:	6902                	ld	s2,0(sp)
    8000308c:	6105                	addi	sp,sp,32
    8000308e:	8082                	ret

0000000080003090 <idup>:
{
    80003090:	1101                	addi	sp,sp,-32
    80003092:	ec06                	sd	ra,24(sp)
    80003094:	e822                	sd	s0,16(sp)
    80003096:	e426                	sd	s1,8(sp)
    80003098:	1000                	addi	s0,sp,32
    8000309a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000309c:	00037517          	auipc	a0,0x37
    800030a0:	9d450513          	addi	a0,a0,-1580 # 80039a70 <itable>
    800030a4:	00003097          	auipc	ra,0x3
    800030a8:	778080e7          	jalr	1912(ra) # 8000681c <acquire>
  ip->ref++;
    800030ac:	449c                	lw	a5,8(s1)
    800030ae:	2785                	addiw	a5,a5,1
    800030b0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800030b2:	00037517          	auipc	a0,0x37
    800030b6:	9be50513          	addi	a0,a0,-1602 # 80039a70 <itable>
    800030ba:	00004097          	auipc	ra,0x4
    800030be:	816080e7          	jalr	-2026(ra) # 800068d0 <release>
}
    800030c2:	8526                	mv	a0,s1
    800030c4:	60e2                	ld	ra,24(sp)
    800030c6:	6442                	ld	s0,16(sp)
    800030c8:	64a2                	ld	s1,8(sp)
    800030ca:	6105                	addi	sp,sp,32
    800030cc:	8082                	ret

00000000800030ce <ilock>:
{
    800030ce:	1101                	addi	sp,sp,-32
    800030d0:	ec06                	sd	ra,24(sp)
    800030d2:	e822                	sd	s0,16(sp)
    800030d4:	e426                	sd	s1,8(sp)
    800030d6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800030d8:	c10d                	beqz	a0,800030fa <ilock+0x2c>
    800030da:	84aa                	mv	s1,a0
    800030dc:	451c                	lw	a5,8(a0)
    800030de:	00f05e63          	blez	a5,800030fa <ilock+0x2c>
  acquiresleep(&ip->lock);
    800030e2:	0541                	addi	a0,a0,16
    800030e4:	00001097          	auipc	ra,0x1
    800030e8:	cae080e7          	jalr	-850(ra) # 80003d92 <acquiresleep>
  if(ip->valid == 0){
    800030ec:	40bc                	lw	a5,64(s1)
    800030ee:	cf99                	beqz	a5,8000310c <ilock+0x3e>
}
    800030f0:	60e2                	ld	ra,24(sp)
    800030f2:	6442                	ld	s0,16(sp)
    800030f4:	64a2                	ld	s1,8(sp)
    800030f6:	6105                	addi	sp,sp,32
    800030f8:	8082                	ret
    800030fa:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800030fc:	00005517          	auipc	a0,0x5
    80003100:	4f450513          	addi	a0,a0,1268 # 800085f0 <etext+0x5f0>
    80003104:	00003097          	auipc	ra,0x3
    80003108:	19e080e7          	jalr	414(ra) # 800062a2 <panic>
    8000310c:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000310e:	40dc                	lw	a5,4(s1)
    80003110:	0047d79b          	srliw	a5,a5,0x4
    80003114:	00037597          	auipc	a1,0x37
    80003118:	9545a583          	lw	a1,-1708(a1) # 80039a68 <sb+0x18>
    8000311c:	9dbd                	addw	a1,a1,a5
    8000311e:	4088                	lw	a0,0(s1)
    80003120:	fffff097          	auipc	ra,0xfffff
    80003124:	77a080e7          	jalr	1914(ra) # 8000289a <bread>
    80003128:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000312a:	05850593          	addi	a1,a0,88
    8000312e:	40dc                	lw	a5,4(s1)
    80003130:	8bbd                	andi	a5,a5,15
    80003132:	079a                	slli	a5,a5,0x6
    80003134:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003136:	00059783          	lh	a5,0(a1)
    8000313a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000313e:	00259783          	lh	a5,2(a1)
    80003142:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003146:	00459783          	lh	a5,4(a1)
    8000314a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000314e:	00659783          	lh	a5,6(a1)
    80003152:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003156:	459c                	lw	a5,8(a1)
    80003158:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000315a:	03400613          	li	a2,52
    8000315e:	05b1                	addi	a1,a1,12
    80003160:	05048513          	addi	a0,s1,80
    80003164:	ffffd097          	auipc	ra,0xffffd
    80003168:	2bc080e7          	jalr	700(ra) # 80000420 <memmove>
    brelse(bp);
    8000316c:	854a                	mv	a0,s2
    8000316e:	00000097          	auipc	ra,0x0
    80003172:	85c080e7          	jalr	-1956(ra) # 800029ca <brelse>
    ip->valid = 1;
    80003176:	4785                	li	a5,1
    80003178:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000317a:	04449783          	lh	a5,68(s1)
    8000317e:	c399                	beqz	a5,80003184 <ilock+0xb6>
    80003180:	6902                	ld	s2,0(sp)
    80003182:	b7bd                	j	800030f0 <ilock+0x22>
      panic("ilock: no type");
    80003184:	00005517          	auipc	a0,0x5
    80003188:	47450513          	addi	a0,a0,1140 # 800085f8 <etext+0x5f8>
    8000318c:	00003097          	auipc	ra,0x3
    80003190:	116080e7          	jalr	278(ra) # 800062a2 <panic>

0000000080003194 <iunlock>:
{
    80003194:	1101                	addi	sp,sp,-32
    80003196:	ec06                	sd	ra,24(sp)
    80003198:	e822                	sd	s0,16(sp)
    8000319a:	e426                	sd	s1,8(sp)
    8000319c:	e04a                	sd	s2,0(sp)
    8000319e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800031a0:	c905                	beqz	a0,800031d0 <iunlock+0x3c>
    800031a2:	84aa                	mv	s1,a0
    800031a4:	01050913          	addi	s2,a0,16
    800031a8:	854a                	mv	a0,s2
    800031aa:	00001097          	auipc	ra,0x1
    800031ae:	c82080e7          	jalr	-894(ra) # 80003e2c <holdingsleep>
    800031b2:	cd19                	beqz	a0,800031d0 <iunlock+0x3c>
    800031b4:	449c                	lw	a5,8(s1)
    800031b6:	00f05d63          	blez	a5,800031d0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    800031ba:	854a                	mv	a0,s2
    800031bc:	00001097          	auipc	ra,0x1
    800031c0:	c2c080e7          	jalr	-980(ra) # 80003de8 <releasesleep>
}
    800031c4:	60e2                	ld	ra,24(sp)
    800031c6:	6442                	ld	s0,16(sp)
    800031c8:	64a2                	ld	s1,8(sp)
    800031ca:	6902                	ld	s2,0(sp)
    800031cc:	6105                	addi	sp,sp,32
    800031ce:	8082                	ret
    panic("iunlock");
    800031d0:	00005517          	auipc	a0,0x5
    800031d4:	43850513          	addi	a0,a0,1080 # 80008608 <etext+0x608>
    800031d8:	00003097          	auipc	ra,0x3
    800031dc:	0ca080e7          	jalr	202(ra) # 800062a2 <panic>

00000000800031e0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800031e0:	7179                	addi	sp,sp,-48
    800031e2:	f406                	sd	ra,40(sp)
    800031e4:	f022                	sd	s0,32(sp)
    800031e6:	ec26                	sd	s1,24(sp)
    800031e8:	e84a                	sd	s2,16(sp)
    800031ea:	e44e                	sd	s3,8(sp)
    800031ec:	1800                	addi	s0,sp,48
    800031ee:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800031f0:	05050493          	addi	s1,a0,80
    800031f4:	08050913          	addi	s2,a0,128
    800031f8:	a021                	j	80003200 <itrunc+0x20>
    800031fa:	0491                	addi	s1,s1,4
    800031fc:	01248d63          	beq	s1,s2,80003216 <itrunc+0x36>
    if(ip->addrs[i]){
    80003200:	408c                	lw	a1,0(s1)
    80003202:	dde5                	beqz	a1,800031fa <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003204:	0009a503          	lw	a0,0(s3)
    80003208:	00000097          	auipc	ra,0x0
    8000320c:	8d6080e7          	jalr	-1834(ra) # 80002ade <bfree>
      ip->addrs[i] = 0;
    80003210:	0004a023          	sw	zero,0(s1)
    80003214:	b7dd                	j	800031fa <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003216:	0809a583          	lw	a1,128(s3)
    8000321a:	ed99                	bnez	a1,80003238 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000321c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003220:	854e                	mv	a0,s3
    80003222:	00000097          	auipc	ra,0x0
    80003226:	de0080e7          	jalr	-544(ra) # 80003002 <iupdate>
}
    8000322a:	70a2                	ld	ra,40(sp)
    8000322c:	7402                	ld	s0,32(sp)
    8000322e:	64e2                	ld	s1,24(sp)
    80003230:	6942                	ld	s2,16(sp)
    80003232:	69a2                	ld	s3,8(sp)
    80003234:	6145                	addi	sp,sp,48
    80003236:	8082                	ret
    80003238:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000323a:	0009a503          	lw	a0,0(s3)
    8000323e:	fffff097          	auipc	ra,0xfffff
    80003242:	65c080e7          	jalr	1628(ra) # 8000289a <bread>
    80003246:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003248:	05850493          	addi	s1,a0,88
    8000324c:	45850913          	addi	s2,a0,1112
    80003250:	a021                	j	80003258 <itrunc+0x78>
    80003252:	0491                	addi	s1,s1,4
    80003254:	01248b63          	beq	s1,s2,8000326a <itrunc+0x8a>
      if(a[j])
    80003258:	408c                	lw	a1,0(s1)
    8000325a:	dde5                	beqz	a1,80003252 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    8000325c:	0009a503          	lw	a0,0(s3)
    80003260:	00000097          	auipc	ra,0x0
    80003264:	87e080e7          	jalr	-1922(ra) # 80002ade <bfree>
    80003268:	b7ed                	j	80003252 <itrunc+0x72>
    brelse(bp);
    8000326a:	8552                	mv	a0,s4
    8000326c:	fffff097          	auipc	ra,0xfffff
    80003270:	75e080e7          	jalr	1886(ra) # 800029ca <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003274:	0809a583          	lw	a1,128(s3)
    80003278:	0009a503          	lw	a0,0(s3)
    8000327c:	00000097          	auipc	ra,0x0
    80003280:	862080e7          	jalr	-1950(ra) # 80002ade <bfree>
    ip->addrs[NDIRECT] = 0;
    80003284:	0809a023          	sw	zero,128(s3)
    80003288:	6a02                	ld	s4,0(sp)
    8000328a:	bf49                	j	8000321c <itrunc+0x3c>

000000008000328c <iput>:
{
    8000328c:	1101                	addi	sp,sp,-32
    8000328e:	ec06                	sd	ra,24(sp)
    80003290:	e822                	sd	s0,16(sp)
    80003292:	e426                	sd	s1,8(sp)
    80003294:	1000                	addi	s0,sp,32
    80003296:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003298:	00036517          	auipc	a0,0x36
    8000329c:	7d850513          	addi	a0,a0,2008 # 80039a70 <itable>
    800032a0:	00003097          	auipc	ra,0x3
    800032a4:	57c080e7          	jalr	1404(ra) # 8000681c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800032a8:	4498                	lw	a4,8(s1)
    800032aa:	4785                	li	a5,1
    800032ac:	02f70263          	beq	a4,a5,800032d0 <iput+0x44>
  ip->ref--;
    800032b0:	449c                	lw	a5,8(s1)
    800032b2:	37fd                	addiw	a5,a5,-1
    800032b4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800032b6:	00036517          	auipc	a0,0x36
    800032ba:	7ba50513          	addi	a0,a0,1978 # 80039a70 <itable>
    800032be:	00003097          	auipc	ra,0x3
    800032c2:	612080e7          	jalr	1554(ra) # 800068d0 <release>
}
    800032c6:	60e2                	ld	ra,24(sp)
    800032c8:	6442                	ld	s0,16(sp)
    800032ca:	64a2                	ld	s1,8(sp)
    800032cc:	6105                	addi	sp,sp,32
    800032ce:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800032d0:	40bc                	lw	a5,64(s1)
    800032d2:	dff9                	beqz	a5,800032b0 <iput+0x24>
    800032d4:	04a49783          	lh	a5,74(s1)
    800032d8:	ffe1                	bnez	a5,800032b0 <iput+0x24>
    800032da:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800032dc:	01048913          	addi	s2,s1,16
    800032e0:	854a                	mv	a0,s2
    800032e2:	00001097          	auipc	ra,0x1
    800032e6:	ab0080e7          	jalr	-1360(ra) # 80003d92 <acquiresleep>
    release(&itable.lock);
    800032ea:	00036517          	auipc	a0,0x36
    800032ee:	78650513          	addi	a0,a0,1926 # 80039a70 <itable>
    800032f2:	00003097          	auipc	ra,0x3
    800032f6:	5de080e7          	jalr	1502(ra) # 800068d0 <release>
    itrunc(ip);
    800032fa:	8526                	mv	a0,s1
    800032fc:	00000097          	auipc	ra,0x0
    80003300:	ee4080e7          	jalr	-284(ra) # 800031e0 <itrunc>
    ip->type = 0;
    80003304:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003308:	8526                	mv	a0,s1
    8000330a:	00000097          	auipc	ra,0x0
    8000330e:	cf8080e7          	jalr	-776(ra) # 80003002 <iupdate>
    ip->valid = 0;
    80003312:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003316:	854a                	mv	a0,s2
    80003318:	00001097          	auipc	ra,0x1
    8000331c:	ad0080e7          	jalr	-1328(ra) # 80003de8 <releasesleep>
    acquire(&itable.lock);
    80003320:	00036517          	auipc	a0,0x36
    80003324:	75050513          	addi	a0,a0,1872 # 80039a70 <itable>
    80003328:	00003097          	auipc	ra,0x3
    8000332c:	4f4080e7          	jalr	1268(ra) # 8000681c <acquire>
    80003330:	6902                	ld	s2,0(sp)
    80003332:	bfbd                	j	800032b0 <iput+0x24>

0000000080003334 <iunlockput>:
{
    80003334:	1101                	addi	sp,sp,-32
    80003336:	ec06                	sd	ra,24(sp)
    80003338:	e822                	sd	s0,16(sp)
    8000333a:	e426                	sd	s1,8(sp)
    8000333c:	1000                	addi	s0,sp,32
    8000333e:	84aa                	mv	s1,a0
  iunlock(ip);
    80003340:	00000097          	auipc	ra,0x0
    80003344:	e54080e7          	jalr	-428(ra) # 80003194 <iunlock>
  iput(ip);
    80003348:	8526                	mv	a0,s1
    8000334a:	00000097          	auipc	ra,0x0
    8000334e:	f42080e7          	jalr	-190(ra) # 8000328c <iput>
}
    80003352:	60e2                	ld	ra,24(sp)
    80003354:	6442                	ld	s0,16(sp)
    80003356:	64a2                	ld	s1,8(sp)
    80003358:	6105                	addi	sp,sp,32
    8000335a:	8082                	ret

000000008000335c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000335c:	1141                	addi	sp,sp,-16
    8000335e:	e422                	sd	s0,8(sp)
    80003360:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003362:	411c                	lw	a5,0(a0)
    80003364:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003366:	415c                	lw	a5,4(a0)
    80003368:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000336a:	04451783          	lh	a5,68(a0)
    8000336e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003372:	04a51783          	lh	a5,74(a0)
    80003376:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000337a:	04c56783          	lwu	a5,76(a0)
    8000337e:	e99c                	sd	a5,16(a1)
}
    80003380:	6422                	ld	s0,8(sp)
    80003382:	0141                	addi	sp,sp,16
    80003384:	8082                	ret

0000000080003386 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003386:	457c                	lw	a5,76(a0)
    80003388:	10d7e563          	bltu	a5,a3,80003492 <readi+0x10c>
{
    8000338c:	7159                	addi	sp,sp,-112
    8000338e:	f486                	sd	ra,104(sp)
    80003390:	f0a2                	sd	s0,96(sp)
    80003392:	eca6                	sd	s1,88(sp)
    80003394:	e0d2                	sd	s4,64(sp)
    80003396:	fc56                	sd	s5,56(sp)
    80003398:	f85a                	sd	s6,48(sp)
    8000339a:	f45e                	sd	s7,40(sp)
    8000339c:	1880                	addi	s0,sp,112
    8000339e:	8b2a                	mv	s6,a0
    800033a0:	8bae                	mv	s7,a1
    800033a2:	8a32                	mv	s4,a2
    800033a4:	84b6                	mv	s1,a3
    800033a6:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800033a8:	9f35                	addw	a4,a4,a3
    return 0;
    800033aa:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800033ac:	0cd76a63          	bltu	a4,a3,80003480 <readi+0xfa>
    800033b0:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800033b2:	00e7f463          	bgeu	a5,a4,800033ba <readi+0x34>
    n = ip->size - off;
    800033b6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800033ba:	0a0a8963          	beqz	s5,8000346c <readi+0xe6>
    800033be:	e8ca                	sd	s2,80(sp)
    800033c0:	f062                	sd	s8,32(sp)
    800033c2:	ec66                	sd	s9,24(sp)
    800033c4:	e86a                	sd	s10,16(sp)
    800033c6:	e46e                	sd	s11,8(sp)
    800033c8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800033ca:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800033ce:	5c7d                	li	s8,-1
    800033d0:	a82d                	j	8000340a <readi+0x84>
    800033d2:	020d1d93          	slli	s11,s10,0x20
    800033d6:	020ddd93          	srli	s11,s11,0x20
    800033da:	05890613          	addi	a2,s2,88
    800033de:	86ee                	mv	a3,s11
    800033e0:	963a                	add	a2,a2,a4
    800033e2:	85d2                	mv	a1,s4
    800033e4:	855e                	mv	a0,s7
    800033e6:	fffff097          	auipc	ra,0xfffff
    800033ea:	98a080e7          	jalr	-1654(ra) # 80001d70 <either_copyout>
    800033ee:	05850d63          	beq	a0,s8,80003448 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800033f2:	854a                	mv	a0,s2
    800033f4:	fffff097          	auipc	ra,0xfffff
    800033f8:	5d6080e7          	jalr	1494(ra) # 800029ca <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800033fc:	013d09bb          	addw	s3,s10,s3
    80003400:	009d04bb          	addw	s1,s10,s1
    80003404:	9a6e                	add	s4,s4,s11
    80003406:	0559fd63          	bgeu	s3,s5,80003460 <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    8000340a:	00a4d59b          	srliw	a1,s1,0xa
    8000340e:	855a                	mv	a0,s6
    80003410:	00000097          	auipc	ra,0x0
    80003414:	88e080e7          	jalr	-1906(ra) # 80002c9e <bmap>
    80003418:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000341c:	c9b1                	beqz	a1,80003470 <readi+0xea>
    bp = bread(ip->dev, addr);
    8000341e:	000b2503          	lw	a0,0(s6)
    80003422:	fffff097          	auipc	ra,0xfffff
    80003426:	478080e7          	jalr	1144(ra) # 8000289a <bread>
    8000342a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000342c:	3ff4f713          	andi	a4,s1,1023
    80003430:	40ec87bb          	subw	a5,s9,a4
    80003434:	413a86bb          	subw	a3,s5,s3
    80003438:	8d3e                	mv	s10,a5
    8000343a:	2781                	sext.w	a5,a5
    8000343c:	0006861b          	sext.w	a2,a3
    80003440:	f8f679e3          	bgeu	a2,a5,800033d2 <readi+0x4c>
    80003444:	8d36                	mv	s10,a3
    80003446:	b771                	j	800033d2 <readi+0x4c>
      brelse(bp);
    80003448:	854a                	mv	a0,s2
    8000344a:	fffff097          	auipc	ra,0xfffff
    8000344e:	580080e7          	jalr	1408(ra) # 800029ca <brelse>
      tot = -1;
    80003452:	59fd                	li	s3,-1
      break;
    80003454:	6946                	ld	s2,80(sp)
    80003456:	7c02                	ld	s8,32(sp)
    80003458:	6ce2                	ld	s9,24(sp)
    8000345a:	6d42                	ld	s10,16(sp)
    8000345c:	6da2                	ld	s11,8(sp)
    8000345e:	a831                	j	8000347a <readi+0xf4>
    80003460:	6946                	ld	s2,80(sp)
    80003462:	7c02                	ld	s8,32(sp)
    80003464:	6ce2                	ld	s9,24(sp)
    80003466:	6d42                	ld	s10,16(sp)
    80003468:	6da2                	ld	s11,8(sp)
    8000346a:	a801                	j	8000347a <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000346c:	89d6                	mv	s3,s5
    8000346e:	a031                	j	8000347a <readi+0xf4>
    80003470:	6946                	ld	s2,80(sp)
    80003472:	7c02                	ld	s8,32(sp)
    80003474:	6ce2                	ld	s9,24(sp)
    80003476:	6d42                	ld	s10,16(sp)
    80003478:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000347a:	0009851b          	sext.w	a0,s3
    8000347e:	69a6                	ld	s3,72(sp)
}
    80003480:	70a6                	ld	ra,104(sp)
    80003482:	7406                	ld	s0,96(sp)
    80003484:	64e6                	ld	s1,88(sp)
    80003486:	6a06                	ld	s4,64(sp)
    80003488:	7ae2                	ld	s5,56(sp)
    8000348a:	7b42                	ld	s6,48(sp)
    8000348c:	7ba2                	ld	s7,40(sp)
    8000348e:	6165                	addi	sp,sp,112
    80003490:	8082                	ret
    return 0;
    80003492:	4501                	li	a0,0
}
    80003494:	8082                	ret

0000000080003496 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003496:	457c                	lw	a5,76(a0)
    80003498:	10d7ee63          	bltu	a5,a3,800035b4 <writei+0x11e>
{
    8000349c:	7159                	addi	sp,sp,-112
    8000349e:	f486                	sd	ra,104(sp)
    800034a0:	f0a2                	sd	s0,96(sp)
    800034a2:	e8ca                	sd	s2,80(sp)
    800034a4:	e0d2                	sd	s4,64(sp)
    800034a6:	fc56                	sd	s5,56(sp)
    800034a8:	f85a                	sd	s6,48(sp)
    800034aa:	f45e                	sd	s7,40(sp)
    800034ac:	1880                	addi	s0,sp,112
    800034ae:	8aaa                	mv	s5,a0
    800034b0:	8bae                	mv	s7,a1
    800034b2:	8a32                	mv	s4,a2
    800034b4:	8936                	mv	s2,a3
    800034b6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800034b8:	00e687bb          	addw	a5,a3,a4
    800034bc:	0ed7ee63          	bltu	a5,a3,800035b8 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800034c0:	00043737          	lui	a4,0x43
    800034c4:	0ef76c63          	bltu	a4,a5,800035bc <writei+0x126>
    800034c8:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800034ca:	0c0b0d63          	beqz	s6,800035a4 <writei+0x10e>
    800034ce:	eca6                	sd	s1,88(sp)
    800034d0:	f062                	sd	s8,32(sp)
    800034d2:	ec66                	sd	s9,24(sp)
    800034d4:	e86a                	sd	s10,16(sp)
    800034d6:	e46e                	sd	s11,8(sp)
    800034d8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800034da:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800034de:	5c7d                	li	s8,-1
    800034e0:	a091                	j	80003524 <writei+0x8e>
    800034e2:	020d1d93          	slli	s11,s10,0x20
    800034e6:	020ddd93          	srli	s11,s11,0x20
    800034ea:	05848513          	addi	a0,s1,88
    800034ee:	86ee                	mv	a3,s11
    800034f0:	8652                	mv	a2,s4
    800034f2:	85de                	mv	a1,s7
    800034f4:	953a                	add	a0,a0,a4
    800034f6:	fffff097          	auipc	ra,0xfffff
    800034fa:	8d0080e7          	jalr	-1840(ra) # 80001dc6 <either_copyin>
    800034fe:	07850263          	beq	a0,s8,80003562 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003502:	8526                	mv	a0,s1
    80003504:	00000097          	auipc	ra,0x0
    80003508:	770080e7          	jalr	1904(ra) # 80003c74 <log_write>
    brelse(bp);
    8000350c:	8526                	mv	a0,s1
    8000350e:	fffff097          	auipc	ra,0xfffff
    80003512:	4bc080e7          	jalr	1212(ra) # 800029ca <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003516:	013d09bb          	addw	s3,s10,s3
    8000351a:	012d093b          	addw	s2,s10,s2
    8000351e:	9a6e                	add	s4,s4,s11
    80003520:	0569f663          	bgeu	s3,s6,8000356c <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003524:	00a9559b          	srliw	a1,s2,0xa
    80003528:	8556                	mv	a0,s5
    8000352a:	fffff097          	auipc	ra,0xfffff
    8000352e:	774080e7          	jalr	1908(ra) # 80002c9e <bmap>
    80003532:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003536:	c99d                	beqz	a1,8000356c <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003538:	000aa503          	lw	a0,0(s5)
    8000353c:	fffff097          	auipc	ra,0xfffff
    80003540:	35e080e7          	jalr	862(ra) # 8000289a <bread>
    80003544:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003546:	3ff97713          	andi	a4,s2,1023
    8000354a:	40ec87bb          	subw	a5,s9,a4
    8000354e:	413b06bb          	subw	a3,s6,s3
    80003552:	8d3e                	mv	s10,a5
    80003554:	2781                	sext.w	a5,a5
    80003556:	0006861b          	sext.w	a2,a3
    8000355a:	f8f674e3          	bgeu	a2,a5,800034e2 <writei+0x4c>
    8000355e:	8d36                	mv	s10,a3
    80003560:	b749                	j	800034e2 <writei+0x4c>
      brelse(bp);
    80003562:	8526                	mv	a0,s1
    80003564:	fffff097          	auipc	ra,0xfffff
    80003568:	466080e7          	jalr	1126(ra) # 800029ca <brelse>
  }

  if(off > ip->size)
    8000356c:	04caa783          	lw	a5,76(s5)
    80003570:	0327fc63          	bgeu	a5,s2,800035a8 <writei+0x112>
    ip->size = off;
    80003574:	052aa623          	sw	s2,76(s5)
    80003578:	64e6                	ld	s1,88(sp)
    8000357a:	7c02                	ld	s8,32(sp)
    8000357c:	6ce2                	ld	s9,24(sp)
    8000357e:	6d42                	ld	s10,16(sp)
    80003580:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003582:	8556                	mv	a0,s5
    80003584:	00000097          	auipc	ra,0x0
    80003588:	a7e080e7          	jalr	-1410(ra) # 80003002 <iupdate>

  return tot;
    8000358c:	0009851b          	sext.w	a0,s3
    80003590:	69a6                	ld	s3,72(sp)
}
    80003592:	70a6                	ld	ra,104(sp)
    80003594:	7406                	ld	s0,96(sp)
    80003596:	6946                	ld	s2,80(sp)
    80003598:	6a06                	ld	s4,64(sp)
    8000359a:	7ae2                	ld	s5,56(sp)
    8000359c:	7b42                	ld	s6,48(sp)
    8000359e:	7ba2                	ld	s7,40(sp)
    800035a0:	6165                	addi	sp,sp,112
    800035a2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800035a4:	89da                	mv	s3,s6
    800035a6:	bff1                	j	80003582 <writei+0xec>
    800035a8:	64e6                	ld	s1,88(sp)
    800035aa:	7c02                	ld	s8,32(sp)
    800035ac:	6ce2                	ld	s9,24(sp)
    800035ae:	6d42                	ld	s10,16(sp)
    800035b0:	6da2                	ld	s11,8(sp)
    800035b2:	bfc1                	j	80003582 <writei+0xec>
    return -1;
    800035b4:	557d                	li	a0,-1
}
    800035b6:	8082                	ret
    return -1;
    800035b8:	557d                	li	a0,-1
    800035ba:	bfe1                	j	80003592 <writei+0xfc>
    return -1;
    800035bc:	557d                	li	a0,-1
    800035be:	bfd1                	j	80003592 <writei+0xfc>

00000000800035c0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800035c0:	1141                	addi	sp,sp,-16
    800035c2:	e406                	sd	ra,8(sp)
    800035c4:	e022                	sd	s0,0(sp)
    800035c6:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800035c8:	4639                	li	a2,14
    800035ca:	ffffd097          	auipc	ra,0xffffd
    800035ce:	eca080e7          	jalr	-310(ra) # 80000494 <strncmp>
}
    800035d2:	60a2                	ld	ra,8(sp)
    800035d4:	6402                	ld	s0,0(sp)
    800035d6:	0141                	addi	sp,sp,16
    800035d8:	8082                	ret

00000000800035da <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800035da:	7139                	addi	sp,sp,-64
    800035dc:	fc06                	sd	ra,56(sp)
    800035de:	f822                	sd	s0,48(sp)
    800035e0:	f426                	sd	s1,40(sp)
    800035e2:	f04a                	sd	s2,32(sp)
    800035e4:	ec4e                	sd	s3,24(sp)
    800035e6:	e852                	sd	s4,16(sp)
    800035e8:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800035ea:	04451703          	lh	a4,68(a0)
    800035ee:	4785                	li	a5,1
    800035f0:	00f71a63          	bne	a4,a5,80003604 <dirlookup+0x2a>
    800035f4:	892a                	mv	s2,a0
    800035f6:	89ae                	mv	s3,a1
    800035f8:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800035fa:	457c                	lw	a5,76(a0)
    800035fc:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800035fe:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003600:	e79d                	bnez	a5,8000362e <dirlookup+0x54>
    80003602:	a8a5                	j	8000367a <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003604:	00005517          	auipc	a0,0x5
    80003608:	00c50513          	addi	a0,a0,12 # 80008610 <etext+0x610>
    8000360c:	00003097          	auipc	ra,0x3
    80003610:	c96080e7          	jalr	-874(ra) # 800062a2 <panic>
      panic("dirlookup read");
    80003614:	00005517          	auipc	a0,0x5
    80003618:	01450513          	addi	a0,a0,20 # 80008628 <etext+0x628>
    8000361c:	00003097          	auipc	ra,0x3
    80003620:	c86080e7          	jalr	-890(ra) # 800062a2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003624:	24c1                	addiw	s1,s1,16
    80003626:	04c92783          	lw	a5,76(s2)
    8000362a:	04f4f763          	bgeu	s1,a5,80003678 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000362e:	4741                	li	a4,16
    80003630:	86a6                	mv	a3,s1
    80003632:	fc040613          	addi	a2,s0,-64
    80003636:	4581                	li	a1,0
    80003638:	854a                	mv	a0,s2
    8000363a:	00000097          	auipc	ra,0x0
    8000363e:	d4c080e7          	jalr	-692(ra) # 80003386 <readi>
    80003642:	47c1                	li	a5,16
    80003644:	fcf518e3          	bne	a0,a5,80003614 <dirlookup+0x3a>
    if(de.inum == 0)
    80003648:	fc045783          	lhu	a5,-64(s0)
    8000364c:	dfe1                	beqz	a5,80003624 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000364e:	fc240593          	addi	a1,s0,-62
    80003652:	854e                	mv	a0,s3
    80003654:	00000097          	auipc	ra,0x0
    80003658:	f6c080e7          	jalr	-148(ra) # 800035c0 <namecmp>
    8000365c:	f561                	bnez	a0,80003624 <dirlookup+0x4a>
      if(poff)
    8000365e:	000a0463          	beqz	s4,80003666 <dirlookup+0x8c>
        *poff = off;
    80003662:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003666:	fc045583          	lhu	a1,-64(s0)
    8000366a:	00092503          	lw	a0,0(s2)
    8000366e:	fffff097          	auipc	ra,0xfffff
    80003672:	720080e7          	jalr	1824(ra) # 80002d8e <iget>
    80003676:	a011                	j	8000367a <dirlookup+0xa0>
  return 0;
    80003678:	4501                	li	a0,0
}
    8000367a:	70e2                	ld	ra,56(sp)
    8000367c:	7442                	ld	s0,48(sp)
    8000367e:	74a2                	ld	s1,40(sp)
    80003680:	7902                	ld	s2,32(sp)
    80003682:	69e2                	ld	s3,24(sp)
    80003684:	6a42                	ld	s4,16(sp)
    80003686:	6121                	addi	sp,sp,64
    80003688:	8082                	ret

000000008000368a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000368a:	711d                	addi	sp,sp,-96
    8000368c:	ec86                	sd	ra,88(sp)
    8000368e:	e8a2                	sd	s0,80(sp)
    80003690:	e4a6                	sd	s1,72(sp)
    80003692:	e0ca                	sd	s2,64(sp)
    80003694:	fc4e                	sd	s3,56(sp)
    80003696:	f852                	sd	s4,48(sp)
    80003698:	f456                	sd	s5,40(sp)
    8000369a:	f05a                	sd	s6,32(sp)
    8000369c:	ec5e                	sd	s7,24(sp)
    8000369e:	e862                	sd	s8,16(sp)
    800036a0:	e466                	sd	s9,8(sp)
    800036a2:	1080                	addi	s0,sp,96
    800036a4:	84aa                	mv	s1,a0
    800036a6:	8b2e                	mv	s6,a1
    800036a8:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800036aa:	00054703          	lbu	a4,0(a0)
    800036ae:	02f00793          	li	a5,47
    800036b2:	02f70263          	beq	a4,a5,800036d6 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800036b6:	ffffe097          	auipc	ra,0xffffe
    800036ba:	c04080e7          	jalr	-1020(ra) # 800012ba <myproc>
    800036be:	15053503          	ld	a0,336(a0)
    800036c2:	00000097          	auipc	ra,0x0
    800036c6:	9ce080e7          	jalr	-1586(ra) # 80003090 <idup>
    800036ca:	8a2a                	mv	s4,a0
  while(*path == '/')
    800036cc:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800036d0:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800036d2:	4b85                	li	s7,1
    800036d4:	a875                	j	80003790 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800036d6:	4585                	li	a1,1
    800036d8:	4505                	li	a0,1
    800036da:	fffff097          	auipc	ra,0xfffff
    800036de:	6b4080e7          	jalr	1716(ra) # 80002d8e <iget>
    800036e2:	8a2a                	mv	s4,a0
    800036e4:	b7e5                	j	800036cc <namex+0x42>
      iunlockput(ip);
    800036e6:	8552                	mv	a0,s4
    800036e8:	00000097          	auipc	ra,0x0
    800036ec:	c4c080e7          	jalr	-948(ra) # 80003334 <iunlockput>
      return 0;
    800036f0:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800036f2:	8552                	mv	a0,s4
    800036f4:	60e6                	ld	ra,88(sp)
    800036f6:	6446                	ld	s0,80(sp)
    800036f8:	64a6                	ld	s1,72(sp)
    800036fa:	6906                	ld	s2,64(sp)
    800036fc:	79e2                	ld	s3,56(sp)
    800036fe:	7a42                	ld	s4,48(sp)
    80003700:	7aa2                	ld	s5,40(sp)
    80003702:	7b02                	ld	s6,32(sp)
    80003704:	6be2                	ld	s7,24(sp)
    80003706:	6c42                	ld	s8,16(sp)
    80003708:	6ca2                	ld	s9,8(sp)
    8000370a:	6125                	addi	sp,sp,96
    8000370c:	8082                	ret
      iunlock(ip);
    8000370e:	8552                	mv	a0,s4
    80003710:	00000097          	auipc	ra,0x0
    80003714:	a84080e7          	jalr	-1404(ra) # 80003194 <iunlock>
      return ip;
    80003718:	bfe9                	j	800036f2 <namex+0x68>
      iunlockput(ip);
    8000371a:	8552                	mv	a0,s4
    8000371c:	00000097          	auipc	ra,0x0
    80003720:	c18080e7          	jalr	-1000(ra) # 80003334 <iunlockput>
      return 0;
    80003724:	8a4e                	mv	s4,s3
    80003726:	b7f1                	j	800036f2 <namex+0x68>
  len = path - s;
    80003728:	40998633          	sub	a2,s3,s1
    8000372c:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003730:	099c5863          	bge	s8,s9,800037c0 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003734:	4639                	li	a2,14
    80003736:	85a6                	mv	a1,s1
    80003738:	8556                	mv	a0,s5
    8000373a:	ffffd097          	auipc	ra,0xffffd
    8000373e:	ce6080e7          	jalr	-794(ra) # 80000420 <memmove>
    80003742:	84ce                	mv	s1,s3
  while(*path == '/')
    80003744:	0004c783          	lbu	a5,0(s1)
    80003748:	01279763          	bne	a5,s2,80003756 <namex+0xcc>
    path++;
    8000374c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000374e:	0004c783          	lbu	a5,0(s1)
    80003752:	ff278de3          	beq	a5,s2,8000374c <namex+0xc2>
    ilock(ip);
    80003756:	8552                	mv	a0,s4
    80003758:	00000097          	auipc	ra,0x0
    8000375c:	976080e7          	jalr	-1674(ra) # 800030ce <ilock>
    if(ip->type != T_DIR){
    80003760:	044a1783          	lh	a5,68(s4)
    80003764:	f97791e3          	bne	a5,s7,800036e6 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003768:	000b0563          	beqz	s6,80003772 <namex+0xe8>
    8000376c:	0004c783          	lbu	a5,0(s1)
    80003770:	dfd9                	beqz	a5,8000370e <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003772:	4601                	li	a2,0
    80003774:	85d6                	mv	a1,s5
    80003776:	8552                	mv	a0,s4
    80003778:	00000097          	auipc	ra,0x0
    8000377c:	e62080e7          	jalr	-414(ra) # 800035da <dirlookup>
    80003780:	89aa                	mv	s3,a0
    80003782:	dd41                	beqz	a0,8000371a <namex+0x90>
    iunlockput(ip);
    80003784:	8552                	mv	a0,s4
    80003786:	00000097          	auipc	ra,0x0
    8000378a:	bae080e7          	jalr	-1106(ra) # 80003334 <iunlockput>
    ip = next;
    8000378e:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003790:	0004c783          	lbu	a5,0(s1)
    80003794:	01279763          	bne	a5,s2,800037a2 <namex+0x118>
    path++;
    80003798:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000379a:	0004c783          	lbu	a5,0(s1)
    8000379e:	ff278de3          	beq	a5,s2,80003798 <namex+0x10e>
  if(*path == 0)
    800037a2:	cb9d                	beqz	a5,800037d8 <namex+0x14e>
  while(*path != '/' && *path != 0)
    800037a4:	0004c783          	lbu	a5,0(s1)
    800037a8:	89a6                	mv	s3,s1
  len = path - s;
    800037aa:	4c81                	li	s9,0
    800037ac:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800037ae:	01278963          	beq	a5,s2,800037c0 <namex+0x136>
    800037b2:	dbbd                	beqz	a5,80003728 <namex+0x9e>
    path++;
    800037b4:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800037b6:	0009c783          	lbu	a5,0(s3)
    800037ba:	ff279ce3          	bne	a5,s2,800037b2 <namex+0x128>
    800037be:	b7ad                	j	80003728 <namex+0x9e>
    memmove(name, s, len);
    800037c0:	2601                	sext.w	a2,a2
    800037c2:	85a6                	mv	a1,s1
    800037c4:	8556                	mv	a0,s5
    800037c6:	ffffd097          	auipc	ra,0xffffd
    800037ca:	c5a080e7          	jalr	-934(ra) # 80000420 <memmove>
    name[len] = 0;
    800037ce:	9cd6                	add	s9,s9,s5
    800037d0:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800037d4:	84ce                	mv	s1,s3
    800037d6:	b7bd                	j	80003744 <namex+0xba>
  if(nameiparent){
    800037d8:	f00b0de3          	beqz	s6,800036f2 <namex+0x68>
    iput(ip);
    800037dc:	8552                	mv	a0,s4
    800037de:	00000097          	auipc	ra,0x0
    800037e2:	aae080e7          	jalr	-1362(ra) # 8000328c <iput>
    return 0;
    800037e6:	4a01                	li	s4,0
    800037e8:	b729                	j	800036f2 <namex+0x68>

00000000800037ea <dirlink>:
{
    800037ea:	7139                	addi	sp,sp,-64
    800037ec:	fc06                	sd	ra,56(sp)
    800037ee:	f822                	sd	s0,48(sp)
    800037f0:	f04a                	sd	s2,32(sp)
    800037f2:	ec4e                	sd	s3,24(sp)
    800037f4:	e852                	sd	s4,16(sp)
    800037f6:	0080                	addi	s0,sp,64
    800037f8:	892a                	mv	s2,a0
    800037fa:	8a2e                	mv	s4,a1
    800037fc:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800037fe:	4601                	li	a2,0
    80003800:	00000097          	auipc	ra,0x0
    80003804:	dda080e7          	jalr	-550(ra) # 800035da <dirlookup>
    80003808:	ed25                	bnez	a0,80003880 <dirlink+0x96>
    8000380a:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000380c:	04c92483          	lw	s1,76(s2)
    80003810:	c49d                	beqz	s1,8000383e <dirlink+0x54>
    80003812:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003814:	4741                	li	a4,16
    80003816:	86a6                	mv	a3,s1
    80003818:	fc040613          	addi	a2,s0,-64
    8000381c:	4581                	li	a1,0
    8000381e:	854a                	mv	a0,s2
    80003820:	00000097          	auipc	ra,0x0
    80003824:	b66080e7          	jalr	-1178(ra) # 80003386 <readi>
    80003828:	47c1                	li	a5,16
    8000382a:	06f51163          	bne	a0,a5,8000388c <dirlink+0xa2>
    if(de.inum == 0)
    8000382e:	fc045783          	lhu	a5,-64(s0)
    80003832:	c791                	beqz	a5,8000383e <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003834:	24c1                	addiw	s1,s1,16
    80003836:	04c92783          	lw	a5,76(s2)
    8000383a:	fcf4ede3          	bltu	s1,a5,80003814 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000383e:	4639                	li	a2,14
    80003840:	85d2                	mv	a1,s4
    80003842:	fc240513          	addi	a0,s0,-62
    80003846:	ffffd097          	auipc	ra,0xffffd
    8000384a:	c84080e7          	jalr	-892(ra) # 800004ca <strncpy>
  de.inum = inum;
    8000384e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003852:	4741                	li	a4,16
    80003854:	86a6                	mv	a3,s1
    80003856:	fc040613          	addi	a2,s0,-64
    8000385a:	4581                	li	a1,0
    8000385c:	854a                	mv	a0,s2
    8000385e:	00000097          	auipc	ra,0x0
    80003862:	c38080e7          	jalr	-968(ra) # 80003496 <writei>
    80003866:	1541                	addi	a0,a0,-16
    80003868:	00a03533          	snez	a0,a0
    8000386c:	40a00533          	neg	a0,a0
    80003870:	74a2                	ld	s1,40(sp)
}
    80003872:	70e2                	ld	ra,56(sp)
    80003874:	7442                	ld	s0,48(sp)
    80003876:	7902                	ld	s2,32(sp)
    80003878:	69e2                	ld	s3,24(sp)
    8000387a:	6a42                	ld	s4,16(sp)
    8000387c:	6121                	addi	sp,sp,64
    8000387e:	8082                	ret
    iput(ip);
    80003880:	00000097          	auipc	ra,0x0
    80003884:	a0c080e7          	jalr	-1524(ra) # 8000328c <iput>
    return -1;
    80003888:	557d                	li	a0,-1
    8000388a:	b7e5                	j	80003872 <dirlink+0x88>
      panic("dirlink read");
    8000388c:	00005517          	auipc	a0,0x5
    80003890:	dac50513          	addi	a0,a0,-596 # 80008638 <etext+0x638>
    80003894:	00003097          	auipc	ra,0x3
    80003898:	a0e080e7          	jalr	-1522(ra) # 800062a2 <panic>

000000008000389c <namei>:

struct inode*
namei(char *path)
{
    8000389c:	1101                	addi	sp,sp,-32
    8000389e:	ec06                	sd	ra,24(sp)
    800038a0:	e822                	sd	s0,16(sp)
    800038a2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800038a4:	fe040613          	addi	a2,s0,-32
    800038a8:	4581                	li	a1,0
    800038aa:	00000097          	auipc	ra,0x0
    800038ae:	de0080e7          	jalr	-544(ra) # 8000368a <namex>
}
    800038b2:	60e2                	ld	ra,24(sp)
    800038b4:	6442                	ld	s0,16(sp)
    800038b6:	6105                	addi	sp,sp,32
    800038b8:	8082                	ret

00000000800038ba <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800038ba:	1141                	addi	sp,sp,-16
    800038bc:	e406                	sd	ra,8(sp)
    800038be:	e022                	sd	s0,0(sp)
    800038c0:	0800                	addi	s0,sp,16
    800038c2:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800038c4:	4585                	li	a1,1
    800038c6:	00000097          	auipc	ra,0x0
    800038ca:	dc4080e7          	jalr	-572(ra) # 8000368a <namex>
}
    800038ce:	60a2                	ld	ra,8(sp)
    800038d0:	6402                	ld	s0,0(sp)
    800038d2:	0141                	addi	sp,sp,16
    800038d4:	8082                	ret

00000000800038d6 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800038d6:	1101                	addi	sp,sp,-32
    800038d8:	ec06                	sd	ra,24(sp)
    800038da:	e822                	sd	s0,16(sp)
    800038dc:	e426                	sd	s1,8(sp)
    800038de:	e04a                	sd	s2,0(sp)
    800038e0:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800038e2:	00038917          	auipc	s2,0x38
    800038e6:	c3690913          	addi	s2,s2,-970 # 8003b518 <log>
    800038ea:	01892583          	lw	a1,24(s2)
    800038ee:	02892503          	lw	a0,40(s2)
    800038f2:	fffff097          	auipc	ra,0xfffff
    800038f6:	fa8080e7          	jalr	-88(ra) # 8000289a <bread>
    800038fa:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800038fc:	02c92603          	lw	a2,44(s2)
    80003900:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003902:	00c05f63          	blez	a2,80003920 <write_head+0x4a>
    80003906:	00038717          	auipc	a4,0x38
    8000390a:	c4270713          	addi	a4,a4,-958 # 8003b548 <log+0x30>
    8000390e:	87aa                	mv	a5,a0
    80003910:	060a                	slli	a2,a2,0x2
    80003912:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003914:	4314                	lw	a3,0(a4)
    80003916:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003918:	0711                	addi	a4,a4,4
    8000391a:	0791                	addi	a5,a5,4
    8000391c:	fec79ce3          	bne	a5,a2,80003914 <write_head+0x3e>
  }
  bwrite(buf);
    80003920:	8526                	mv	a0,s1
    80003922:	fffff097          	auipc	ra,0xfffff
    80003926:	06a080e7          	jalr	106(ra) # 8000298c <bwrite>
  brelse(buf);
    8000392a:	8526                	mv	a0,s1
    8000392c:	fffff097          	auipc	ra,0xfffff
    80003930:	09e080e7          	jalr	158(ra) # 800029ca <brelse>
}
    80003934:	60e2                	ld	ra,24(sp)
    80003936:	6442                	ld	s0,16(sp)
    80003938:	64a2                	ld	s1,8(sp)
    8000393a:	6902                	ld	s2,0(sp)
    8000393c:	6105                	addi	sp,sp,32
    8000393e:	8082                	ret

0000000080003940 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003940:	00038797          	auipc	a5,0x38
    80003944:	c047a783          	lw	a5,-1020(a5) # 8003b544 <log+0x2c>
    80003948:	0af05d63          	blez	a5,80003a02 <install_trans+0xc2>
{
    8000394c:	7139                	addi	sp,sp,-64
    8000394e:	fc06                	sd	ra,56(sp)
    80003950:	f822                	sd	s0,48(sp)
    80003952:	f426                	sd	s1,40(sp)
    80003954:	f04a                	sd	s2,32(sp)
    80003956:	ec4e                	sd	s3,24(sp)
    80003958:	e852                	sd	s4,16(sp)
    8000395a:	e456                	sd	s5,8(sp)
    8000395c:	e05a                	sd	s6,0(sp)
    8000395e:	0080                	addi	s0,sp,64
    80003960:	8b2a                	mv	s6,a0
    80003962:	00038a97          	auipc	s5,0x38
    80003966:	be6a8a93          	addi	s5,s5,-1050 # 8003b548 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000396a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000396c:	00038997          	auipc	s3,0x38
    80003970:	bac98993          	addi	s3,s3,-1108 # 8003b518 <log>
    80003974:	a00d                	j	80003996 <install_trans+0x56>
    brelse(lbuf);
    80003976:	854a                	mv	a0,s2
    80003978:	fffff097          	auipc	ra,0xfffff
    8000397c:	052080e7          	jalr	82(ra) # 800029ca <brelse>
    brelse(dbuf);
    80003980:	8526                	mv	a0,s1
    80003982:	fffff097          	auipc	ra,0xfffff
    80003986:	048080e7          	jalr	72(ra) # 800029ca <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000398a:	2a05                	addiw	s4,s4,1
    8000398c:	0a91                	addi	s5,s5,4
    8000398e:	02c9a783          	lw	a5,44(s3)
    80003992:	04fa5e63          	bge	s4,a5,800039ee <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003996:	0189a583          	lw	a1,24(s3)
    8000399a:	014585bb          	addw	a1,a1,s4
    8000399e:	2585                	addiw	a1,a1,1
    800039a0:	0289a503          	lw	a0,40(s3)
    800039a4:	fffff097          	auipc	ra,0xfffff
    800039a8:	ef6080e7          	jalr	-266(ra) # 8000289a <bread>
    800039ac:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800039ae:	000aa583          	lw	a1,0(s5)
    800039b2:	0289a503          	lw	a0,40(s3)
    800039b6:	fffff097          	auipc	ra,0xfffff
    800039ba:	ee4080e7          	jalr	-284(ra) # 8000289a <bread>
    800039be:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800039c0:	40000613          	li	a2,1024
    800039c4:	05890593          	addi	a1,s2,88
    800039c8:	05850513          	addi	a0,a0,88
    800039cc:	ffffd097          	auipc	ra,0xffffd
    800039d0:	a54080e7          	jalr	-1452(ra) # 80000420 <memmove>
    bwrite(dbuf);  // write dst to disk
    800039d4:	8526                	mv	a0,s1
    800039d6:	fffff097          	auipc	ra,0xfffff
    800039da:	fb6080e7          	jalr	-74(ra) # 8000298c <bwrite>
    if(recovering == 0)
    800039de:	f80b1ce3          	bnez	s6,80003976 <install_trans+0x36>
      bunpin(dbuf);
    800039e2:	8526                	mv	a0,s1
    800039e4:	fffff097          	auipc	ra,0xfffff
    800039e8:	0be080e7          	jalr	190(ra) # 80002aa2 <bunpin>
    800039ec:	b769                	j	80003976 <install_trans+0x36>
}
    800039ee:	70e2                	ld	ra,56(sp)
    800039f0:	7442                	ld	s0,48(sp)
    800039f2:	74a2                	ld	s1,40(sp)
    800039f4:	7902                	ld	s2,32(sp)
    800039f6:	69e2                	ld	s3,24(sp)
    800039f8:	6a42                	ld	s4,16(sp)
    800039fa:	6aa2                	ld	s5,8(sp)
    800039fc:	6b02                	ld	s6,0(sp)
    800039fe:	6121                	addi	sp,sp,64
    80003a00:	8082                	ret
    80003a02:	8082                	ret

0000000080003a04 <initlog>:
{
    80003a04:	7179                	addi	sp,sp,-48
    80003a06:	f406                	sd	ra,40(sp)
    80003a08:	f022                	sd	s0,32(sp)
    80003a0a:	ec26                	sd	s1,24(sp)
    80003a0c:	e84a                	sd	s2,16(sp)
    80003a0e:	e44e                	sd	s3,8(sp)
    80003a10:	1800                	addi	s0,sp,48
    80003a12:	892a                	mv	s2,a0
    80003a14:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003a16:	00038497          	auipc	s1,0x38
    80003a1a:	b0248493          	addi	s1,s1,-1278 # 8003b518 <log>
    80003a1e:	00005597          	auipc	a1,0x5
    80003a22:	c2a58593          	addi	a1,a1,-982 # 80008648 <etext+0x648>
    80003a26:	8526                	mv	a0,s1
    80003a28:	00003097          	auipc	ra,0x3
    80003a2c:	d64080e7          	jalr	-668(ra) # 8000678c <initlock>
  log.start = sb->logstart;
    80003a30:	0149a583          	lw	a1,20(s3)
    80003a34:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003a36:	0109a783          	lw	a5,16(s3)
    80003a3a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003a3c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003a40:	854a                	mv	a0,s2
    80003a42:	fffff097          	auipc	ra,0xfffff
    80003a46:	e58080e7          	jalr	-424(ra) # 8000289a <bread>
  log.lh.n = lh->n;
    80003a4a:	4d30                	lw	a2,88(a0)
    80003a4c:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003a4e:	00c05f63          	blez	a2,80003a6c <initlog+0x68>
    80003a52:	87aa                	mv	a5,a0
    80003a54:	00038717          	auipc	a4,0x38
    80003a58:	af470713          	addi	a4,a4,-1292 # 8003b548 <log+0x30>
    80003a5c:	060a                	slli	a2,a2,0x2
    80003a5e:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003a60:	4ff4                	lw	a3,92(a5)
    80003a62:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003a64:	0791                	addi	a5,a5,4
    80003a66:	0711                	addi	a4,a4,4
    80003a68:	fec79ce3          	bne	a5,a2,80003a60 <initlog+0x5c>
  brelse(buf);
    80003a6c:	fffff097          	auipc	ra,0xfffff
    80003a70:	f5e080e7          	jalr	-162(ra) # 800029ca <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003a74:	4505                	li	a0,1
    80003a76:	00000097          	auipc	ra,0x0
    80003a7a:	eca080e7          	jalr	-310(ra) # 80003940 <install_trans>
  log.lh.n = 0;
    80003a7e:	00038797          	auipc	a5,0x38
    80003a82:	ac07a323          	sw	zero,-1338(a5) # 8003b544 <log+0x2c>
  write_head(); // clear the log
    80003a86:	00000097          	auipc	ra,0x0
    80003a8a:	e50080e7          	jalr	-432(ra) # 800038d6 <write_head>
}
    80003a8e:	70a2                	ld	ra,40(sp)
    80003a90:	7402                	ld	s0,32(sp)
    80003a92:	64e2                	ld	s1,24(sp)
    80003a94:	6942                	ld	s2,16(sp)
    80003a96:	69a2                	ld	s3,8(sp)
    80003a98:	6145                	addi	sp,sp,48
    80003a9a:	8082                	ret

0000000080003a9c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003a9c:	1101                	addi	sp,sp,-32
    80003a9e:	ec06                	sd	ra,24(sp)
    80003aa0:	e822                	sd	s0,16(sp)
    80003aa2:	e426                	sd	s1,8(sp)
    80003aa4:	e04a                	sd	s2,0(sp)
    80003aa6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003aa8:	00038517          	auipc	a0,0x38
    80003aac:	a7050513          	addi	a0,a0,-1424 # 8003b518 <log>
    80003ab0:	00003097          	auipc	ra,0x3
    80003ab4:	d6c080e7          	jalr	-660(ra) # 8000681c <acquire>
  while(1){
    if(log.committing){
    80003ab8:	00038497          	auipc	s1,0x38
    80003abc:	a6048493          	addi	s1,s1,-1440 # 8003b518 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003ac0:	4979                	li	s2,30
    80003ac2:	a039                	j	80003ad0 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003ac4:	85a6                	mv	a1,s1
    80003ac6:	8526                	mv	a0,s1
    80003ac8:	ffffe097          	auipc	ra,0xffffe
    80003acc:	ea0080e7          	jalr	-352(ra) # 80001968 <sleep>
    if(log.committing){
    80003ad0:	50dc                	lw	a5,36(s1)
    80003ad2:	fbed                	bnez	a5,80003ac4 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003ad4:	5098                	lw	a4,32(s1)
    80003ad6:	2705                	addiw	a4,a4,1
    80003ad8:	0027179b          	slliw	a5,a4,0x2
    80003adc:	9fb9                	addw	a5,a5,a4
    80003ade:	0017979b          	slliw	a5,a5,0x1
    80003ae2:	54d4                	lw	a3,44(s1)
    80003ae4:	9fb5                	addw	a5,a5,a3
    80003ae6:	00f95963          	bge	s2,a5,80003af8 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003aea:	85a6                	mv	a1,s1
    80003aec:	8526                	mv	a0,s1
    80003aee:	ffffe097          	auipc	ra,0xffffe
    80003af2:	e7a080e7          	jalr	-390(ra) # 80001968 <sleep>
    80003af6:	bfe9                	j	80003ad0 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003af8:	00038517          	auipc	a0,0x38
    80003afc:	a2050513          	addi	a0,a0,-1504 # 8003b518 <log>
    80003b00:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003b02:	00003097          	auipc	ra,0x3
    80003b06:	dce080e7          	jalr	-562(ra) # 800068d0 <release>
      break;
    }
  }
}
    80003b0a:	60e2                	ld	ra,24(sp)
    80003b0c:	6442                	ld	s0,16(sp)
    80003b0e:	64a2                	ld	s1,8(sp)
    80003b10:	6902                	ld	s2,0(sp)
    80003b12:	6105                	addi	sp,sp,32
    80003b14:	8082                	ret

0000000080003b16 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003b16:	7139                	addi	sp,sp,-64
    80003b18:	fc06                	sd	ra,56(sp)
    80003b1a:	f822                	sd	s0,48(sp)
    80003b1c:	f426                	sd	s1,40(sp)
    80003b1e:	f04a                	sd	s2,32(sp)
    80003b20:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003b22:	00038497          	auipc	s1,0x38
    80003b26:	9f648493          	addi	s1,s1,-1546 # 8003b518 <log>
    80003b2a:	8526                	mv	a0,s1
    80003b2c:	00003097          	auipc	ra,0x3
    80003b30:	cf0080e7          	jalr	-784(ra) # 8000681c <acquire>
  log.outstanding -= 1;
    80003b34:	509c                	lw	a5,32(s1)
    80003b36:	37fd                	addiw	a5,a5,-1
    80003b38:	0007891b          	sext.w	s2,a5
    80003b3c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003b3e:	50dc                	lw	a5,36(s1)
    80003b40:	e7b9                	bnez	a5,80003b8e <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    80003b42:	06091163          	bnez	s2,80003ba4 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003b46:	00038497          	auipc	s1,0x38
    80003b4a:	9d248493          	addi	s1,s1,-1582 # 8003b518 <log>
    80003b4e:	4785                	li	a5,1
    80003b50:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003b52:	8526                	mv	a0,s1
    80003b54:	00003097          	auipc	ra,0x3
    80003b58:	d7c080e7          	jalr	-644(ra) # 800068d0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003b5c:	54dc                	lw	a5,44(s1)
    80003b5e:	06f04763          	bgtz	a5,80003bcc <end_op+0xb6>
    acquire(&log.lock);
    80003b62:	00038497          	auipc	s1,0x38
    80003b66:	9b648493          	addi	s1,s1,-1610 # 8003b518 <log>
    80003b6a:	8526                	mv	a0,s1
    80003b6c:	00003097          	auipc	ra,0x3
    80003b70:	cb0080e7          	jalr	-848(ra) # 8000681c <acquire>
    log.committing = 0;
    80003b74:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003b78:	8526                	mv	a0,s1
    80003b7a:	ffffe097          	auipc	ra,0xffffe
    80003b7e:	e52080e7          	jalr	-430(ra) # 800019cc <wakeup>
    release(&log.lock);
    80003b82:	8526                	mv	a0,s1
    80003b84:	00003097          	auipc	ra,0x3
    80003b88:	d4c080e7          	jalr	-692(ra) # 800068d0 <release>
}
    80003b8c:	a815                	j	80003bc0 <end_op+0xaa>
    80003b8e:	ec4e                	sd	s3,24(sp)
    80003b90:	e852                	sd	s4,16(sp)
    80003b92:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003b94:	00005517          	auipc	a0,0x5
    80003b98:	abc50513          	addi	a0,a0,-1348 # 80008650 <etext+0x650>
    80003b9c:	00002097          	auipc	ra,0x2
    80003ba0:	706080e7          	jalr	1798(ra) # 800062a2 <panic>
    wakeup(&log);
    80003ba4:	00038497          	auipc	s1,0x38
    80003ba8:	97448493          	addi	s1,s1,-1676 # 8003b518 <log>
    80003bac:	8526                	mv	a0,s1
    80003bae:	ffffe097          	auipc	ra,0xffffe
    80003bb2:	e1e080e7          	jalr	-482(ra) # 800019cc <wakeup>
  release(&log.lock);
    80003bb6:	8526                	mv	a0,s1
    80003bb8:	00003097          	auipc	ra,0x3
    80003bbc:	d18080e7          	jalr	-744(ra) # 800068d0 <release>
}
    80003bc0:	70e2                	ld	ra,56(sp)
    80003bc2:	7442                	ld	s0,48(sp)
    80003bc4:	74a2                	ld	s1,40(sp)
    80003bc6:	7902                	ld	s2,32(sp)
    80003bc8:	6121                	addi	sp,sp,64
    80003bca:	8082                	ret
    80003bcc:	ec4e                	sd	s3,24(sp)
    80003bce:	e852                	sd	s4,16(sp)
    80003bd0:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003bd2:	00038a97          	auipc	s5,0x38
    80003bd6:	976a8a93          	addi	s5,s5,-1674 # 8003b548 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003bda:	00038a17          	auipc	s4,0x38
    80003bde:	93ea0a13          	addi	s4,s4,-1730 # 8003b518 <log>
    80003be2:	018a2583          	lw	a1,24(s4)
    80003be6:	012585bb          	addw	a1,a1,s2
    80003bea:	2585                	addiw	a1,a1,1
    80003bec:	028a2503          	lw	a0,40(s4)
    80003bf0:	fffff097          	auipc	ra,0xfffff
    80003bf4:	caa080e7          	jalr	-854(ra) # 8000289a <bread>
    80003bf8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003bfa:	000aa583          	lw	a1,0(s5)
    80003bfe:	028a2503          	lw	a0,40(s4)
    80003c02:	fffff097          	auipc	ra,0xfffff
    80003c06:	c98080e7          	jalr	-872(ra) # 8000289a <bread>
    80003c0a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003c0c:	40000613          	li	a2,1024
    80003c10:	05850593          	addi	a1,a0,88
    80003c14:	05848513          	addi	a0,s1,88
    80003c18:	ffffd097          	auipc	ra,0xffffd
    80003c1c:	808080e7          	jalr	-2040(ra) # 80000420 <memmove>
    bwrite(to);  // write the log
    80003c20:	8526                	mv	a0,s1
    80003c22:	fffff097          	auipc	ra,0xfffff
    80003c26:	d6a080e7          	jalr	-662(ra) # 8000298c <bwrite>
    brelse(from);
    80003c2a:	854e                	mv	a0,s3
    80003c2c:	fffff097          	auipc	ra,0xfffff
    80003c30:	d9e080e7          	jalr	-610(ra) # 800029ca <brelse>
    brelse(to);
    80003c34:	8526                	mv	a0,s1
    80003c36:	fffff097          	auipc	ra,0xfffff
    80003c3a:	d94080e7          	jalr	-620(ra) # 800029ca <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c3e:	2905                	addiw	s2,s2,1
    80003c40:	0a91                	addi	s5,s5,4
    80003c42:	02ca2783          	lw	a5,44(s4)
    80003c46:	f8f94ee3          	blt	s2,a5,80003be2 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003c4a:	00000097          	auipc	ra,0x0
    80003c4e:	c8c080e7          	jalr	-884(ra) # 800038d6 <write_head>
    install_trans(0); // Now install writes to home locations
    80003c52:	4501                	li	a0,0
    80003c54:	00000097          	auipc	ra,0x0
    80003c58:	cec080e7          	jalr	-788(ra) # 80003940 <install_trans>
    log.lh.n = 0;
    80003c5c:	00038797          	auipc	a5,0x38
    80003c60:	8e07a423          	sw	zero,-1816(a5) # 8003b544 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003c64:	00000097          	auipc	ra,0x0
    80003c68:	c72080e7          	jalr	-910(ra) # 800038d6 <write_head>
    80003c6c:	69e2                	ld	s3,24(sp)
    80003c6e:	6a42                	ld	s4,16(sp)
    80003c70:	6aa2                	ld	s5,8(sp)
    80003c72:	bdc5                	j	80003b62 <end_op+0x4c>

0000000080003c74 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003c74:	1101                	addi	sp,sp,-32
    80003c76:	ec06                	sd	ra,24(sp)
    80003c78:	e822                	sd	s0,16(sp)
    80003c7a:	e426                	sd	s1,8(sp)
    80003c7c:	e04a                	sd	s2,0(sp)
    80003c7e:	1000                	addi	s0,sp,32
    80003c80:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003c82:	00038917          	auipc	s2,0x38
    80003c86:	89690913          	addi	s2,s2,-1898 # 8003b518 <log>
    80003c8a:	854a                	mv	a0,s2
    80003c8c:	00003097          	auipc	ra,0x3
    80003c90:	b90080e7          	jalr	-1136(ra) # 8000681c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003c94:	02c92603          	lw	a2,44(s2)
    80003c98:	47f5                	li	a5,29
    80003c9a:	06c7c563          	blt	a5,a2,80003d04 <log_write+0x90>
    80003c9e:	00038797          	auipc	a5,0x38
    80003ca2:	8967a783          	lw	a5,-1898(a5) # 8003b534 <log+0x1c>
    80003ca6:	37fd                	addiw	a5,a5,-1
    80003ca8:	04f65e63          	bge	a2,a5,80003d04 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003cac:	00038797          	auipc	a5,0x38
    80003cb0:	88c7a783          	lw	a5,-1908(a5) # 8003b538 <log+0x20>
    80003cb4:	06f05063          	blez	a5,80003d14 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003cb8:	4781                	li	a5,0
    80003cba:	06c05563          	blez	a2,80003d24 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003cbe:	44cc                	lw	a1,12(s1)
    80003cc0:	00038717          	auipc	a4,0x38
    80003cc4:	88870713          	addi	a4,a4,-1912 # 8003b548 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003cc8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003cca:	4314                	lw	a3,0(a4)
    80003ccc:	04b68c63          	beq	a3,a1,80003d24 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003cd0:	2785                	addiw	a5,a5,1
    80003cd2:	0711                	addi	a4,a4,4
    80003cd4:	fef61be3          	bne	a2,a5,80003cca <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003cd8:	0621                	addi	a2,a2,8
    80003cda:	060a                	slli	a2,a2,0x2
    80003cdc:	00038797          	auipc	a5,0x38
    80003ce0:	83c78793          	addi	a5,a5,-1988 # 8003b518 <log>
    80003ce4:	97b2                	add	a5,a5,a2
    80003ce6:	44d8                	lw	a4,12(s1)
    80003ce8:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003cea:	8526                	mv	a0,s1
    80003cec:	fffff097          	auipc	ra,0xfffff
    80003cf0:	d7a080e7          	jalr	-646(ra) # 80002a66 <bpin>
    log.lh.n++;
    80003cf4:	00038717          	auipc	a4,0x38
    80003cf8:	82470713          	addi	a4,a4,-2012 # 8003b518 <log>
    80003cfc:	575c                	lw	a5,44(a4)
    80003cfe:	2785                	addiw	a5,a5,1
    80003d00:	d75c                	sw	a5,44(a4)
    80003d02:	a82d                	j	80003d3c <log_write+0xc8>
    panic("too big a transaction");
    80003d04:	00005517          	auipc	a0,0x5
    80003d08:	95c50513          	addi	a0,a0,-1700 # 80008660 <etext+0x660>
    80003d0c:	00002097          	auipc	ra,0x2
    80003d10:	596080e7          	jalr	1430(ra) # 800062a2 <panic>
    panic("log_write outside of trans");
    80003d14:	00005517          	auipc	a0,0x5
    80003d18:	96450513          	addi	a0,a0,-1692 # 80008678 <etext+0x678>
    80003d1c:	00002097          	auipc	ra,0x2
    80003d20:	586080e7          	jalr	1414(ra) # 800062a2 <panic>
  log.lh.block[i] = b->blockno;
    80003d24:	00878693          	addi	a3,a5,8
    80003d28:	068a                	slli	a3,a3,0x2
    80003d2a:	00037717          	auipc	a4,0x37
    80003d2e:	7ee70713          	addi	a4,a4,2030 # 8003b518 <log>
    80003d32:	9736                	add	a4,a4,a3
    80003d34:	44d4                	lw	a3,12(s1)
    80003d36:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003d38:	faf609e3          	beq	a2,a5,80003cea <log_write+0x76>
  }
  release(&log.lock);
    80003d3c:	00037517          	auipc	a0,0x37
    80003d40:	7dc50513          	addi	a0,a0,2012 # 8003b518 <log>
    80003d44:	00003097          	auipc	ra,0x3
    80003d48:	b8c080e7          	jalr	-1140(ra) # 800068d0 <release>
}
    80003d4c:	60e2                	ld	ra,24(sp)
    80003d4e:	6442                	ld	s0,16(sp)
    80003d50:	64a2                	ld	s1,8(sp)
    80003d52:	6902                	ld	s2,0(sp)
    80003d54:	6105                	addi	sp,sp,32
    80003d56:	8082                	ret

0000000080003d58 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003d58:	1101                	addi	sp,sp,-32
    80003d5a:	ec06                	sd	ra,24(sp)
    80003d5c:	e822                	sd	s0,16(sp)
    80003d5e:	e426                	sd	s1,8(sp)
    80003d60:	e04a                	sd	s2,0(sp)
    80003d62:	1000                	addi	s0,sp,32
    80003d64:	84aa                	mv	s1,a0
    80003d66:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003d68:	00005597          	auipc	a1,0x5
    80003d6c:	93058593          	addi	a1,a1,-1744 # 80008698 <etext+0x698>
    80003d70:	0521                	addi	a0,a0,8
    80003d72:	00003097          	auipc	ra,0x3
    80003d76:	a1a080e7          	jalr	-1510(ra) # 8000678c <initlock>
  lk->name = name;
    80003d7a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003d7e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003d82:	0204a423          	sw	zero,40(s1)
}
    80003d86:	60e2                	ld	ra,24(sp)
    80003d88:	6442                	ld	s0,16(sp)
    80003d8a:	64a2                	ld	s1,8(sp)
    80003d8c:	6902                	ld	s2,0(sp)
    80003d8e:	6105                	addi	sp,sp,32
    80003d90:	8082                	ret

0000000080003d92 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003d92:	1101                	addi	sp,sp,-32
    80003d94:	ec06                	sd	ra,24(sp)
    80003d96:	e822                	sd	s0,16(sp)
    80003d98:	e426                	sd	s1,8(sp)
    80003d9a:	e04a                	sd	s2,0(sp)
    80003d9c:	1000                	addi	s0,sp,32
    80003d9e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003da0:	00850913          	addi	s2,a0,8
    80003da4:	854a                	mv	a0,s2
    80003da6:	00003097          	auipc	ra,0x3
    80003daa:	a76080e7          	jalr	-1418(ra) # 8000681c <acquire>
  while (lk->locked) {
    80003dae:	409c                	lw	a5,0(s1)
    80003db0:	cb89                	beqz	a5,80003dc2 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003db2:	85ca                	mv	a1,s2
    80003db4:	8526                	mv	a0,s1
    80003db6:	ffffe097          	auipc	ra,0xffffe
    80003dba:	bb2080e7          	jalr	-1102(ra) # 80001968 <sleep>
  while (lk->locked) {
    80003dbe:	409c                	lw	a5,0(s1)
    80003dc0:	fbed                	bnez	a5,80003db2 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003dc2:	4785                	li	a5,1
    80003dc4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003dc6:	ffffd097          	auipc	ra,0xffffd
    80003dca:	4f4080e7          	jalr	1268(ra) # 800012ba <myproc>
    80003dce:	591c                	lw	a5,48(a0)
    80003dd0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003dd2:	854a                	mv	a0,s2
    80003dd4:	00003097          	auipc	ra,0x3
    80003dd8:	afc080e7          	jalr	-1284(ra) # 800068d0 <release>
}
    80003ddc:	60e2                	ld	ra,24(sp)
    80003dde:	6442                	ld	s0,16(sp)
    80003de0:	64a2                	ld	s1,8(sp)
    80003de2:	6902                	ld	s2,0(sp)
    80003de4:	6105                	addi	sp,sp,32
    80003de6:	8082                	ret

0000000080003de8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003de8:	1101                	addi	sp,sp,-32
    80003dea:	ec06                	sd	ra,24(sp)
    80003dec:	e822                	sd	s0,16(sp)
    80003dee:	e426                	sd	s1,8(sp)
    80003df0:	e04a                	sd	s2,0(sp)
    80003df2:	1000                	addi	s0,sp,32
    80003df4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003df6:	00850913          	addi	s2,a0,8
    80003dfa:	854a                	mv	a0,s2
    80003dfc:	00003097          	auipc	ra,0x3
    80003e00:	a20080e7          	jalr	-1504(ra) # 8000681c <acquire>
  lk->locked = 0;
    80003e04:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003e08:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003e0c:	8526                	mv	a0,s1
    80003e0e:	ffffe097          	auipc	ra,0xffffe
    80003e12:	bbe080e7          	jalr	-1090(ra) # 800019cc <wakeup>
  release(&lk->lk);
    80003e16:	854a                	mv	a0,s2
    80003e18:	00003097          	auipc	ra,0x3
    80003e1c:	ab8080e7          	jalr	-1352(ra) # 800068d0 <release>
}
    80003e20:	60e2                	ld	ra,24(sp)
    80003e22:	6442                	ld	s0,16(sp)
    80003e24:	64a2                	ld	s1,8(sp)
    80003e26:	6902                	ld	s2,0(sp)
    80003e28:	6105                	addi	sp,sp,32
    80003e2a:	8082                	ret

0000000080003e2c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003e2c:	7179                	addi	sp,sp,-48
    80003e2e:	f406                	sd	ra,40(sp)
    80003e30:	f022                	sd	s0,32(sp)
    80003e32:	ec26                	sd	s1,24(sp)
    80003e34:	e84a                	sd	s2,16(sp)
    80003e36:	1800                	addi	s0,sp,48
    80003e38:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003e3a:	00850913          	addi	s2,a0,8
    80003e3e:	854a                	mv	a0,s2
    80003e40:	00003097          	auipc	ra,0x3
    80003e44:	9dc080e7          	jalr	-1572(ra) # 8000681c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003e48:	409c                	lw	a5,0(s1)
    80003e4a:	ef91                	bnez	a5,80003e66 <holdingsleep+0x3a>
    80003e4c:	4481                	li	s1,0
  release(&lk->lk);
    80003e4e:	854a                	mv	a0,s2
    80003e50:	00003097          	auipc	ra,0x3
    80003e54:	a80080e7          	jalr	-1408(ra) # 800068d0 <release>
  return r;
}
    80003e58:	8526                	mv	a0,s1
    80003e5a:	70a2                	ld	ra,40(sp)
    80003e5c:	7402                	ld	s0,32(sp)
    80003e5e:	64e2                	ld	s1,24(sp)
    80003e60:	6942                	ld	s2,16(sp)
    80003e62:	6145                	addi	sp,sp,48
    80003e64:	8082                	ret
    80003e66:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003e68:	0284a983          	lw	s3,40(s1)
    80003e6c:	ffffd097          	auipc	ra,0xffffd
    80003e70:	44e080e7          	jalr	1102(ra) # 800012ba <myproc>
    80003e74:	5904                	lw	s1,48(a0)
    80003e76:	413484b3          	sub	s1,s1,s3
    80003e7a:	0014b493          	seqz	s1,s1
    80003e7e:	69a2                	ld	s3,8(sp)
    80003e80:	b7f9                	j	80003e4e <holdingsleep+0x22>

0000000080003e82 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003e82:	1141                	addi	sp,sp,-16
    80003e84:	e406                	sd	ra,8(sp)
    80003e86:	e022                	sd	s0,0(sp)
    80003e88:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003e8a:	00005597          	auipc	a1,0x5
    80003e8e:	81e58593          	addi	a1,a1,-2018 # 800086a8 <etext+0x6a8>
    80003e92:	00037517          	auipc	a0,0x37
    80003e96:	7ce50513          	addi	a0,a0,1998 # 8003b660 <ftable>
    80003e9a:	00003097          	auipc	ra,0x3
    80003e9e:	8f2080e7          	jalr	-1806(ra) # 8000678c <initlock>
}
    80003ea2:	60a2                	ld	ra,8(sp)
    80003ea4:	6402                	ld	s0,0(sp)
    80003ea6:	0141                	addi	sp,sp,16
    80003ea8:	8082                	ret

0000000080003eaa <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003eaa:	1101                	addi	sp,sp,-32
    80003eac:	ec06                	sd	ra,24(sp)
    80003eae:	e822                	sd	s0,16(sp)
    80003eb0:	e426                	sd	s1,8(sp)
    80003eb2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003eb4:	00037517          	auipc	a0,0x37
    80003eb8:	7ac50513          	addi	a0,a0,1964 # 8003b660 <ftable>
    80003ebc:	00003097          	auipc	ra,0x3
    80003ec0:	960080e7          	jalr	-1696(ra) # 8000681c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ec4:	00037497          	auipc	s1,0x37
    80003ec8:	7b448493          	addi	s1,s1,1972 # 8003b678 <ftable+0x18>
    80003ecc:	00038717          	auipc	a4,0x38
    80003ed0:	74c70713          	addi	a4,a4,1868 # 8003c618 <disk>
    if(f->ref == 0){
    80003ed4:	40dc                	lw	a5,4(s1)
    80003ed6:	cf99                	beqz	a5,80003ef4 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ed8:	02848493          	addi	s1,s1,40
    80003edc:	fee49ce3          	bne	s1,a4,80003ed4 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003ee0:	00037517          	auipc	a0,0x37
    80003ee4:	78050513          	addi	a0,a0,1920 # 8003b660 <ftable>
    80003ee8:	00003097          	auipc	ra,0x3
    80003eec:	9e8080e7          	jalr	-1560(ra) # 800068d0 <release>
  return 0;
    80003ef0:	4481                	li	s1,0
    80003ef2:	a819                	j	80003f08 <filealloc+0x5e>
      f->ref = 1;
    80003ef4:	4785                	li	a5,1
    80003ef6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003ef8:	00037517          	auipc	a0,0x37
    80003efc:	76850513          	addi	a0,a0,1896 # 8003b660 <ftable>
    80003f00:	00003097          	auipc	ra,0x3
    80003f04:	9d0080e7          	jalr	-1584(ra) # 800068d0 <release>
}
    80003f08:	8526                	mv	a0,s1
    80003f0a:	60e2                	ld	ra,24(sp)
    80003f0c:	6442                	ld	s0,16(sp)
    80003f0e:	64a2                	ld	s1,8(sp)
    80003f10:	6105                	addi	sp,sp,32
    80003f12:	8082                	ret

0000000080003f14 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003f14:	1101                	addi	sp,sp,-32
    80003f16:	ec06                	sd	ra,24(sp)
    80003f18:	e822                	sd	s0,16(sp)
    80003f1a:	e426                	sd	s1,8(sp)
    80003f1c:	1000                	addi	s0,sp,32
    80003f1e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003f20:	00037517          	auipc	a0,0x37
    80003f24:	74050513          	addi	a0,a0,1856 # 8003b660 <ftable>
    80003f28:	00003097          	auipc	ra,0x3
    80003f2c:	8f4080e7          	jalr	-1804(ra) # 8000681c <acquire>
  if(f->ref < 1)
    80003f30:	40dc                	lw	a5,4(s1)
    80003f32:	02f05263          	blez	a5,80003f56 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003f36:	2785                	addiw	a5,a5,1
    80003f38:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003f3a:	00037517          	auipc	a0,0x37
    80003f3e:	72650513          	addi	a0,a0,1830 # 8003b660 <ftable>
    80003f42:	00003097          	auipc	ra,0x3
    80003f46:	98e080e7          	jalr	-1650(ra) # 800068d0 <release>
  return f;
}
    80003f4a:	8526                	mv	a0,s1
    80003f4c:	60e2                	ld	ra,24(sp)
    80003f4e:	6442                	ld	s0,16(sp)
    80003f50:	64a2                	ld	s1,8(sp)
    80003f52:	6105                	addi	sp,sp,32
    80003f54:	8082                	ret
    panic("filedup");
    80003f56:	00004517          	auipc	a0,0x4
    80003f5a:	75a50513          	addi	a0,a0,1882 # 800086b0 <etext+0x6b0>
    80003f5e:	00002097          	auipc	ra,0x2
    80003f62:	344080e7          	jalr	836(ra) # 800062a2 <panic>

0000000080003f66 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003f66:	7139                	addi	sp,sp,-64
    80003f68:	fc06                	sd	ra,56(sp)
    80003f6a:	f822                	sd	s0,48(sp)
    80003f6c:	f426                	sd	s1,40(sp)
    80003f6e:	0080                	addi	s0,sp,64
    80003f70:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003f72:	00037517          	auipc	a0,0x37
    80003f76:	6ee50513          	addi	a0,a0,1774 # 8003b660 <ftable>
    80003f7a:	00003097          	auipc	ra,0x3
    80003f7e:	8a2080e7          	jalr	-1886(ra) # 8000681c <acquire>
  if(f->ref < 1)
    80003f82:	40dc                	lw	a5,4(s1)
    80003f84:	04f05c63          	blez	a5,80003fdc <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003f88:	37fd                	addiw	a5,a5,-1
    80003f8a:	0007871b          	sext.w	a4,a5
    80003f8e:	c0dc                	sw	a5,4(s1)
    80003f90:	06e04263          	bgtz	a4,80003ff4 <fileclose+0x8e>
    80003f94:	f04a                	sd	s2,32(sp)
    80003f96:	ec4e                	sd	s3,24(sp)
    80003f98:	e852                	sd	s4,16(sp)
    80003f9a:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003f9c:	0004a903          	lw	s2,0(s1)
    80003fa0:	0094ca83          	lbu	s5,9(s1)
    80003fa4:	0104ba03          	ld	s4,16(s1)
    80003fa8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003fac:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003fb0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003fb4:	00037517          	auipc	a0,0x37
    80003fb8:	6ac50513          	addi	a0,a0,1708 # 8003b660 <ftable>
    80003fbc:	00003097          	auipc	ra,0x3
    80003fc0:	914080e7          	jalr	-1772(ra) # 800068d0 <release>

  if(ff.type == FD_PIPE){
    80003fc4:	4785                	li	a5,1
    80003fc6:	04f90463          	beq	s2,a5,8000400e <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003fca:	3979                	addiw	s2,s2,-2
    80003fcc:	4785                	li	a5,1
    80003fce:	0527fb63          	bgeu	a5,s2,80004024 <fileclose+0xbe>
    80003fd2:	7902                	ld	s2,32(sp)
    80003fd4:	69e2                	ld	s3,24(sp)
    80003fd6:	6a42                	ld	s4,16(sp)
    80003fd8:	6aa2                	ld	s5,8(sp)
    80003fda:	a02d                	j	80004004 <fileclose+0x9e>
    80003fdc:	f04a                	sd	s2,32(sp)
    80003fde:	ec4e                	sd	s3,24(sp)
    80003fe0:	e852                	sd	s4,16(sp)
    80003fe2:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003fe4:	00004517          	auipc	a0,0x4
    80003fe8:	6d450513          	addi	a0,a0,1748 # 800086b8 <etext+0x6b8>
    80003fec:	00002097          	auipc	ra,0x2
    80003ff0:	2b6080e7          	jalr	694(ra) # 800062a2 <panic>
    release(&ftable.lock);
    80003ff4:	00037517          	auipc	a0,0x37
    80003ff8:	66c50513          	addi	a0,a0,1644 # 8003b660 <ftable>
    80003ffc:	00003097          	auipc	ra,0x3
    80004000:	8d4080e7          	jalr	-1836(ra) # 800068d0 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004004:	70e2                	ld	ra,56(sp)
    80004006:	7442                	ld	s0,48(sp)
    80004008:	74a2                	ld	s1,40(sp)
    8000400a:	6121                	addi	sp,sp,64
    8000400c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000400e:	85d6                	mv	a1,s5
    80004010:	8552                	mv	a0,s4
    80004012:	00000097          	auipc	ra,0x0
    80004016:	3a2080e7          	jalr	930(ra) # 800043b4 <pipeclose>
    8000401a:	7902                	ld	s2,32(sp)
    8000401c:	69e2                	ld	s3,24(sp)
    8000401e:	6a42                	ld	s4,16(sp)
    80004020:	6aa2                	ld	s5,8(sp)
    80004022:	b7cd                	j	80004004 <fileclose+0x9e>
    begin_op();
    80004024:	00000097          	auipc	ra,0x0
    80004028:	a78080e7          	jalr	-1416(ra) # 80003a9c <begin_op>
    iput(ff.ip);
    8000402c:	854e                	mv	a0,s3
    8000402e:	fffff097          	auipc	ra,0xfffff
    80004032:	25e080e7          	jalr	606(ra) # 8000328c <iput>
    end_op();
    80004036:	00000097          	auipc	ra,0x0
    8000403a:	ae0080e7          	jalr	-1312(ra) # 80003b16 <end_op>
    8000403e:	7902                	ld	s2,32(sp)
    80004040:	69e2                	ld	s3,24(sp)
    80004042:	6a42                	ld	s4,16(sp)
    80004044:	6aa2                	ld	s5,8(sp)
    80004046:	bf7d                	j	80004004 <fileclose+0x9e>

0000000080004048 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004048:	715d                	addi	sp,sp,-80
    8000404a:	e486                	sd	ra,72(sp)
    8000404c:	e0a2                	sd	s0,64(sp)
    8000404e:	fc26                	sd	s1,56(sp)
    80004050:	f44e                	sd	s3,40(sp)
    80004052:	0880                	addi	s0,sp,80
    80004054:	84aa                	mv	s1,a0
    80004056:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004058:	ffffd097          	auipc	ra,0xffffd
    8000405c:	262080e7          	jalr	610(ra) # 800012ba <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004060:	409c                	lw	a5,0(s1)
    80004062:	37f9                	addiw	a5,a5,-2
    80004064:	4705                	li	a4,1
    80004066:	04f76863          	bltu	a4,a5,800040b6 <filestat+0x6e>
    8000406a:	f84a                	sd	s2,48(sp)
    8000406c:	892a                	mv	s2,a0
    ilock(f->ip);
    8000406e:	6c88                	ld	a0,24(s1)
    80004070:	fffff097          	auipc	ra,0xfffff
    80004074:	05e080e7          	jalr	94(ra) # 800030ce <ilock>
    stati(f->ip, &st);
    80004078:	fb840593          	addi	a1,s0,-72
    8000407c:	6c88                	ld	a0,24(s1)
    8000407e:	fffff097          	auipc	ra,0xfffff
    80004082:	2de080e7          	jalr	734(ra) # 8000335c <stati>
    iunlock(f->ip);
    80004086:	6c88                	ld	a0,24(s1)
    80004088:	fffff097          	auipc	ra,0xfffff
    8000408c:	10c080e7          	jalr	268(ra) # 80003194 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004090:	46e1                	li	a3,24
    80004092:	fb840613          	addi	a2,s0,-72
    80004096:	85ce                	mv	a1,s3
    80004098:	05093503          	ld	a0,80(s2)
    8000409c:	ffffd097          	auipc	ra,0xffffd
    800040a0:	de4080e7          	jalr	-540(ra) # 80000e80 <copyout>
    800040a4:	41f5551b          	sraiw	a0,a0,0x1f
    800040a8:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800040aa:	60a6                	ld	ra,72(sp)
    800040ac:	6406                	ld	s0,64(sp)
    800040ae:	74e2                	ld	s1,56(sp)
    800040b0:	79a2                	ld	s3,40(sp)
    800040b2:	6161                	addi	sp,sp,80
    800040b4:	8082                	ret
  return -1;
    800040b6:	557d                	li	a0,-1
    800040b8:	bfcd                	j	800040aa <filestat+0x62>

00000000800040ba <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800040ba:	7179                	addi	sp,sp,-48
    800040bc:	f406                	sd	ra,40(sp)
    800040be:	f022                	sd	s0,32(sp)
    800040c0:	e84a                	sd	s2,16(sp)
    800040c2:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800040c4:	00854783          	lbu	a5,8(a0)
    800040c8:	cbc5                	beqz	a5,80004178 <fileread+0xbe>
    800040ca:	ec26                	sd	s1,24(sp)
    800040cc:	e44e                	sd	s3,8(sp)
    800040ce:	84aa                	mv	s1,a0
    800040d0:	89ae                	mv	s3,a1
    800040d2:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800040d4:	411c                	lw	a5,0(a0)
    800040d6:	4705                	li	a4,1
    800040d8:	04e78963          	beq	a5,a4,8000412a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800040dc:	470d                	li	a4,3
    800040de:	04e78f63          	beq	a5,a4,8000413c <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800040e2:	4709                	li	a4,2
    800040e4:	08e79263          	bne	a5,a4,80004168 <fileread+0xae>
    ilock(f->ip);
    800040e8:	6d08                	ld	a0,24(a0)
    800040ea:	fffff097          	auipc	ra,0xfffff
    800040ee:	fe4080e7          	jalr	-28(ra) # 800030ce <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800040f2:	874a                	mv	a4,s2
    800040f4:	5094                	lw	a3,32(s1)
    800040f6:	864e                	mv	a2,s3
    800040f8:	4585                	li	a1,1
    800040fa:	6c88                	ld	a0,24(s1)
    800040fc:	fffff097          	auipc	ra,0xfffff
    80004100:	28a080e7          	jalr	650(ra) # 80003386 <readi>
    80004104:	892a                	mv	s2,a0
    80004106:	00a05563          	blez	a0,80004110 <fileread+0x56>
      f->off += r;
    8000410a:	509c                	lw	a5,32(s1)
    8000410c:	9fa9                	addw	a5,a5,a0
    8000410e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004110:	6c88                	ld	a0,24(s1)
    80004112:	fffff097          	auipc	ra,0xfffff
    80004116:	082080e7          	jalr	130(ra) # 80003194 <iunlock>
    8000411a:	64e2                	ld	s1,24(sp)
    8000411c:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000411e:	854a                	mv	a0,s2
    80004120:	70a2                	ld	ra,40(sp)
    80004122:	7402                	ld	s0,32(sp)
    80004124:	6942                	ld	s2,16(sp)
    80004126:	6145                	addi	sp,sp,48
    80004128:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000412a:	6908                	ld	a0,16(a0)
    8000412c:	00000097          	auipc	ra,0x0
    80004130:	400080e7          	jalr	1024(ra) # 8000452c <piperead>
    80004134:	892a                	mv	s2,a0
    80004136:	64e2                	ld	s1,24(sp)
    80004138:	69a2                	ld	s3,8(sp)
    8000413a:	b7d5                	j	8000411e <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000413c:	02451783          	lh	a5,36(a0)
    80004140:	03079693          	slli	a3,a5,0x30
    80004144:	92c1                	srli	a3,a3,0x30
    80004146:	4725                	li	a4,9
    80004148:	02d76a63          	bltu	a4,a3,8000417c <fileread+0xc2>
    8000414c:	0792                	slli	a5,a5,0x4
    8000414e:	00037717          	auipc	a4,0x37
    80004152:	47270713          	addi	a4,a4,1138 # 8003b5c0 <devsw>
    80004156:	97ba                	add	a5,a5,a4
    80004158:	639c                	ld	a5,0(a5)
    8000415a:	c78d                	beqz	a5,80004184 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    8000415c:	4505                	li	a0,1
    8000415e:	9782                	jalr	a5
    80004160:	892a                	mv	s2,a0
    80004162:	64e2                	ld	s1,24(sp)
    80004164:	69a2                	ld	s3,8(sp)
    80004166:	bf65                	j	8000411e <fileread+0x64>
    panic("fileread");
    80004168:	00004517          	auipc	a0,0x4
    8000416c:	56050513          	addi	a0,a0,1376 # 800086c8 <etext+0x6c8>
    80004170:	00002097          	auipc	ra,0x2
    80004174:	132080e7          	jalr	306(ra) # 800062a2 <panic>
    return -1;
    80004178:	597d                	li	s2,-1
    8000417a:	b755                	j	8000411e <fileread+0x64>
      return -1;
    8000417c:	597d                	li	s2,-1
    8000417e:	64e2                	ld	s1,24(sp)
    80004180:	69a2                	ld	s3,8(sp)
    80004182:	bf71                	j	8000411e <fileread+0x64>
    80004184:	597d                	li	s2,-1
    80004186:	64e2                	ld	s1,24(sp)
    80004188:	69a2                	ld	s3,8(sp)
    8000418a:	bf51                	j	8000411e <fileread+0x64>

000000008000418c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000418c:	00954783          	lbu	a5,9(a0)
    80004190:	12078963          	beqz	a5,800042c2 <filewrite+0x136>
{
    80004194:	715d                	addi	sp,sp,-80
    80004196:	e486                	sd	ra,72(sp)
    80004198:	e0a2                	sd	s0,64(sp)
    8000419a:	f84a                	sd	s2,48(sp)
    8000419c:	f052                	sd	s4,32(sp)
    8000419e:	e85a                	sd	s6,16(sp)
    800041a0:	0880                	addi	s0,sp,80
    800041a2:	892a                	mv	s2,a0
    800041a4:	8b2e                	mv	s6,a1
    800041a6:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800041a8:	411c                	lw	a5,0(a0)
    800041aa:	4705                	li	a4,1
    800041ac:	02e78763          	beq	a5,a4,800041da <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800041b0:	470d                	li	a4,3
    800041b2:	02e78a63          	beq	a5,a4,800041e6 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800041b6:	4709                	li	a4,2
    800041b8:	0ee79863          	bne	a5,a4,800042a8 <filewrite+0x11c>
    800041bc:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800041be:	0cc05463          	blez	a2,80004286 <filewrite+0xfa>
    800041c2:	fc26                	sd	s1,56(sp)
    800041c4:	ec56                	sd	s5,24(sp)
    800041c6:	e45e                	sd	s7,8(sp)
    800041c8:	e062                	sd	s8,0(sp)
    int i = 0;
    800041ca:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800041cc:	6b85                	lui	s7,0x1
    800041ce:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800041d2:	6c05                	lui	s8,0x1
    800041d4:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800041d8:	a851                	j	8000426c <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    800041da:	6908                	ld	a0,16(a0)
    800041dc:	00000097          	auipc	ra,0x0
    800041e0:	248080e7          	jalr	584(ra) # 80004424 <pipewrite>
    800041e4:	a85d                	j	8000429a <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800041e6:	02451783          	lh	a5,36(a0)
    800041ea:	03079693          	slli	a3,a5,0x30
    800041ee:	92c1                	srli	a3,a3,0x30
    800041f0:	4725                	li	a4,9
    800041f2:	0cd76a63          	bltu	a4,a3,800042c6 <filewrite+0x13a>
    800041f6:	0792                	slli	a5,a5,0x4
    800041f8:	00037717          	auipc	a4,0x37
    800041fc:	3c870713          	addi	a4,a4,968 # 8003b5c0 <devsw>
    80004200:	97ba                	add	a5,a5,a4
    80004202:	679c                	ld	a5,8(a5)
    80004204:	c3f9                	beqz	a5,800042ca <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80004206:	4505                	li	a0,1
    80004208:	9782                	jalr	a5
    8000420a:	a841                	j	8000429a <filewrite+0x10e>
      if(n1 > max)
    8000420c:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004210:	00000097          	auipc	ra,0x0
    80004214:	88c080e7          	jalr	-1908(ra) # 80003a9c <begin_op>
      ilock(f->ip);
    80004218:	01893503          	ld	a0,24(s2)
    8000421c:	fffff097          	auipc	ra,0xfffff
    80004220:	eb2080e7          	jalr	-334(ra) # 800030ce <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004224:	8756                	mv	a4,s5
    80004226:	02092683          	lw	a3,32(s2)
    8000422a:	01698633          	add	a2,s3,s6
    8000422e:	4585                	li	a1,1
    80004230:	01893503          	ld	a0,24(s2)
    80004234:	fffff097          	auipc	ra,0xfffff
    80004238:	262080e7          	jalr	610(ra) # 80003496 <writei>
    8000423c:	84aa                	mv	s1,a0
    8000423e:	00a05763          	blez	a0,8000424c <filewrite+0xc0>
        f->off += r;
    80004242:	02092783          	lw	a5,32(s2)
    80004246:	9fa9                	addw	a5,a5,a0
    80004248:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000424c:	01893503          	ld	a0,24(s2)
    80004250:	fffff097          	auipc	ra,0xfffff
    80004254:	f44080e7          	jalr	-188(ra) # 80003194 <iunlock>
      end_op();
    80004258:	00000097          	auipc	ra,0x0
    8000425c:	8be080e7          	jalr	-1858(ra) # 80003b16 <end_op>

      if(r != n1){
    80004260:	029a9563          	bne	s5,s1,8000428a <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80004264:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004268:	0149da63          	bge	s3,s4,8000427c <filewrite+0xf0>
      int n1 = n - i;
    8000426c:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004270:	0004879b          	sext.w	a5,s1
    80004274:	f8fbdce3          	bge	s7,a5,8000420c <filewrite+0x80>
    80004278:	84e2                	mv	s1,s8
    8000427a:	bf49                	j	8000420c <filewrite+0x80>
    8000427c:	74e2                	ld	s1,56(sp)
    8000427e:	6ae2                	ld	s5,24(sp)
    80004280:	6ba2                	ld	s7,8(sp)
    80004282:	6c02                	ld	s8,0(sp)
    80004284:	a039                	j	80004292 <filewrite+0x106>
    int i = 0;
    80004286:	4981                	li	s3,0
    80004288:	a029                	j	80004292 <filewrite+0x106>
    8000428a:	74e2                	ld	s1,56(sp)
    8000428c:	6ae2                	ld	s5,24(sp)
    8000428e:	6ba2                	ld	s7,8(sp)
    80004290:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004292:	033a1e63          	bne	s4,s3,800042ce <filewrite+0x142>
    80004296:	8552                	mv	a0,s4
    80004298:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000429a:	60a6                	ld	ra,72(sp)
    8000429c:	6406                	ld	s0,64(sp)
    8000429e:	7942                	ld	s2,48(sp)
    800042a0:	7a02                	ld	s4,32(sp)
    800042a2:	6b42                	ld	s6,16(sp)
    800042a4:	6161                	addi	sp,sp,80
    800042a6:	8082                	ret
    800042a8:	fc26                	sd	s1,56(sp)
    800042aa:	f44e                	sd	s3,40(sp)
    800042ac:	ec56                	sd	s5,24(sp)
    800042ae:	e45e                	sd	s7,8(sp)
    800042b0:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800042b2:	00004517          	auipc	a0,0x4
    800042b6:	42650513          	addi	a0,a0,1062 # 800086d8 <etext+0x6d8>
    800042ba:	00002097          	auipc	ra,0x2
    800042be:	fe8080e7          	jalr	-24(ra) # 800062a2 <panic>
    return -1;
    800042c2:	557d                	li	a0,-1
}
    800042c4:	8082                	ret
      return -1;
    800042c6:	557d                	li	a0,-1
    800042c8:	bfc9                	j	8000429a <filewrite+0x10e>
    800042ca:	557d                	li	a0,-1
    800042cc:	b7f9                	j	8000429a <filewrite+0x10e>
    ret = (i == n ? n : -1);
    800042ce:	557d                	li	a0,-1
    800042d0:	79a2                	ld	s3,40(sp)
    800042d2:	b7e1                	j	8000429a <filewrite+0x10e>

00000000800042d4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800042d4:	7179                	addi	sp,sp,-48
    800042d6:	f406                	sd	ra,40(sp)
    800042d8:	f022                	sd	s0,32(sp)
    800042da:	ec26                	sd	s1,24(sp)
    800042dc:	e052                	sd	s4,0(sp)
    800042de:	1800                	addi	s0,sp,48
    800042e0:	84aa                	mv	s1,a0
    800042e2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800042e4:	0005b023          	sd	zero,0(a1)
    800042e8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800042ec:	00000097          	auipc	ra,0x0
    800042f0:	bbe080e7          	jalr	-1090(ra) # 80003eaa <filealloc>
    800042f4:	e088                	sd	a0,0(s1)
    800042f6:	cd49                	beqz	a0,80004390 <pipealloc+0xbc>
    800042f8:	00000097          	auipc	ra,0x0
    800042fc:	bb2080e7          	jalr	-1102(ra) # 80003eaa <filealloc>
    80004300:	00aa3023          	sd	a0,0(s4)
    80004304:	c141                	beqz	a0,80004384 <pipealloc+0xb0>
    80004306:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004308:	ffffc097          	auipc	ra,0xffffc
    8000430c:	f36080e7          	jalr	-202(ra) # 8000023e <kalloc>
    80004310:	892a                	mv	s2,a0
    80004312:	c13d                	beqz	a0,80004378 <pipealloc+0xa4>
    80004314:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004316:	4985                	li	s3,1
    80004318:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000431c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004320:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004324:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004328:	00004597          	auipc	a1,0x4
    8000432c:	3c058593          	addi	a1,a1,960 # 800086e8 <etext+0x6e8>
    80004330:	00002097          	auipc	ra,0x2
    80004334:	45c080e7          	jalr	1116(ra) # 8000678c <initlock>
  (*f0)->type = FD_PIPE;
    80004338:	609c                	ld	a5,0(s1)
    8000433a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000433e:	609c                	ld	a5,0(s1)
    80004340:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004344:	609c                	ld	a5,0(s1)
    80004346:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000434a:	609c                	ld	a5,0(s1)
    8000434c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004350:	000a3783          	ld	a5,0(s4)
    80004354:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004358:	000a3783          	ld	a5,0(s4)
    8000435c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004360:	000a3783          	ld	a5,0(s4)
    80004364:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004368:	000a3783          	ld	a5,0(s4)
    8000436c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004370:	4501                	li	a0,0
    80004372:	6942                	ld	s2,16(sp)
    80004374:	69a2                	ld	s3,8(sp)
    80004376:	a03d                	j	800043a4 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004378:	6088                	ld	a0,0(s1)
    8000437a:	c119                	beqz	a0,80004380 <pipealloc+0xac>
    8000437c:	6942                	ld	s2,16(sp)
    8000437e:	a029                	j	80004388 <pipealloc+0xb4>
    80004380:	6942                	ld	s2,16(sp)
    80004382:	a039                	j	80004390 <pipealloc+0xbc>
    80004384:	6088                	ld	a0,0(s1)
    80004386:	c50d                	beqz	a0,800043b0 <pipealloc+0xdc>
    fileclose(*f0);
    80004388:	00000097          	auipc	ra,0x0
    8000438c:	bde080e7          	jalr	-1058(ra) # 80003f66 <fileclose>
  if(*f1)
    80004390:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004394:	557d                	li	a0,-1
  if(*f1)
    80004396:	c799                	beqz	a5,800043a4 <pipealloc+0xd0>
    fileclose(*f1);
    80004398:	853e                	mv	a0,a5
    8000439a:	00000097          	auipc	ra,0x0
    8000439e:	bcc080e7          	jalr	-1076(ra) # 80003f66 <fileclose>
  return -1;
    800043a2:	557d                	li	a0,-1
}
    800043a4:	70a2                	ld	ra,40(sp)
    800043a6:	7402                	ld	s0,32(sp)
    800043a8:	64e2                	ld	s1,24(sp)
    800043aa:	6a02                	ld	s4,0(sp)
    800043ac:	6145                	addi	sp,sp,48
    800043ae:	8082                	ret
  return -1;
    800043b0:	557d                	li	a0,-1
    800043b2:	bfcd                	j	800043a4 <pipealloc+0xd0>

00000000800043b4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800043b4:	1101                	addi	sp,sp,-32
    800043b6:	ec06                	sd	ra,24(sp)
    800043b8:	e822                	sd	s0,16(sp)
    800043ba:	e426                	sd	s1,8(sp)
    800043bc:	e04a                	sd	s2,0(sp)
    800043be:	1000                	addi	s0,sp,32
    800043c0:	84aa                	mv	s1,a0
    800043c2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800043c4:	00002097          	auipc	ra,0x2
    800043c8:	458080e7          	jalr	1112(ra) # 8000681c <acquire>
  if(writable){
    800043cc:	02090d63          	beqz	s2,80004406 <pipeclose+0x52>
    pi->writeopen = 0;
    800043d0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800043d4:	21848513          	addi	a0,s1,536
    800043d8:	ffffd097          	auipc	ra,0xffffd
    800043dc:	5f4080e7          	jalr	1524(ra) # 800019cc <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800043e0:	2204b783          	ld	a5,544(s1)
    800043e4:	eb95                	bnez	a5,80004418 <pipeclose+0x64>
    release(&pi->lock);
    800043e6:	8526                	mv	a0,s1
    800043e8:	00002097          	auipc	ra,0x2
    800043ec:	4e8080e7          	jalr	1256(ra) # 800068d0 <release>
    kfree((char*)pi);
    800043f0:	8526                	mv	a0,s1
    800043f2:	ffffc097          	auipc	ra,0xffffc
    800043f6:	c2a080e7          	jalr	-982(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    800043fa:	60e2                	ld	ra,24(sp)
    800043fc:	6442                	ld	s0,16(sp)
    800043fe:	64a2                	ld	s1,8(sp)
    80004400:	6902                	ld	s2,0(sp)
    80004402:	6105                	addi	sp,sp,32
    80004404:	8082                	ret
    pi->readopen = 0;
    80004406:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000440a:	21c48513          	addi	a0,s1,540
    8000440e:	ffffd097          	auipc	ra,0xffffd
    80004412:	5be080e7          	jalr	1470(ra) # 800019cc <wakeup>
    80004416:	b7e9                	j	800043e0 <pipeclose+0x2c>
    release(&pi->lock);
    80004418:	8526                	mv	a0,s1
    8000441a:	00002097          	auipc	ra,0x2
    8000441e:	4b6080e7          	jalr	1206(ra) # 800068d0 <release>
}
    80004422:	bfe1                	j	800043fa <pipeclose+0x46>

0000000080004424 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004424:	711d                	addi	sp,sp,-96
    80004426:	ec86                	sd	ra,88(sp)
    80004428:	e8a2                	sd	s0,80(sp)
    8000442a:	e4a6                	sd	s1,72(sp)
    8000442c:	e0ca                	sd	s2,64(sp)
    8000442e:	fc4e                	sd	s3,56(sp)
    80004430:	f852                	sd	s4,48(sp)
    80004432:	f456                	sd	s5,40(sp)
    80004434:	1080                	addi	s0,sp,96
    80004436:	84aa                	mv	s1,a0
    80004438:	8aae                	mv	s5,a1
    8000443a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000443c:	ffffd097          	auipc	ra,0xffffd
    80004440:	e7e080e7          	jalr	-386(ra) # 800012ba <myproc>
    80004444:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004446:	8526                	mv	a0,s1
    80004448:	00002097          	auipc	ra,0x2
    8000444c:	3d4080e7          	jalr	980(ra) # 8000681c <acquire>
  while(i < n){
    80004450:	0d405863          	blez	s4,80004520 <pipewrite+0xfc>
    80004454:	f05a                	sd	s6,32(sp)
    80004456:	ec5e                	sd	s7,24(sp)
    80004458:	e862                	sd	s8,16(sp)
  int i = 0;
    8000445a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000445c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000445e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004462:	21c48b93          	addi	s7,s1,540
    80004466:	a089                	j	800044a8 <pipewrite+0x84>
      release(&pi->lock);
    80004468:	8526                	mv	a0,s1
    8000446a:	00002097          	auipc	ra,0x2
    8000446e:	466080e7          	jalr	1126(ra) # 800068d0 <release>
      return -1;
    80004472:	597d                	li	s2,-1
    80004474:	7b02                	ld	s6,32(sp)
    80004476:	6be2                	ld	s7,24(sp)
    80004478:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000447a:	854a                	mv	a0,s2
    8000447c:	60e6                	ld	ra,88(sp)
    8000447e:	6446                	ld	s0,80(sp)
    80004480:	64a6                	ld	s1,72(sp)
    80004482:	6906                	ld	s2,64(sp)
    80004484:	79e2                	ld	s3,56(sp)
    80004486:	7a42                	ld	s4,48(sp)
    80004488:	7aa2                	ld	s5,40(sp)
    8000448a:	6125                	addi	sp,sp,96
    8000448c:	8082                	ret
      wakeup(&pi->nread);
    8000448e:	8562                	mv	a0,s8
    80004490:	ffffd097          	auipc	ra,0xffffd
    80004494:	53c080e7          	jalr	1340(ra) # 800019cc <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004498:	85a6                	mv	a1,s1
    8000449a:	855e                	mv	a0,s7
    8000449c:	ffffd097          	auipc	ra,0xffffd
    800044a0:	4cc080e7          	jalr	1228(ra) # 80001968 <sleep>
  while(i < n){
    800044a4:	05495f63          	bge	s2,s4,80004502 <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    800044a8:	2204a783          	lw	a5,544(s1)
    800044ac:	dfd5                	beqz	a5,80004468 <pipewrite+0x44>
    800044ae:	854e                	mv	a0,s3
    800044b0:	ffffd097          	auipc	ra,0xffffd
    800044b4:	760080e7          	jalr	1888(ra) # 80001c10 <killed>
    800044b8:	f945                	bnez	a0,80004468 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800044ba:	2184a783          	lw	a5,536(s1)
    800044be:	21c4a703          	lw	a4,540(s1)
    800044c2:	2007879b          	addiw	a5,a5,512
    800044c6:	fcf704e3          	beq	a4,a5,8000448e <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800044ca:	4685                	li	a3,1
    800044cc:	01590633          	add	a2,s2,s5
    800044d0:	faf40593          	addi	a1,s0,-81
    800044d4:	0509b503          	ld	a0,80(s3)
    800044d8:	ffffd097          	auipc	ra,0xffffd
    800044dc:	b06080e7          	jalr	-1274(ra) # 80000fde <copyin>
    800044e0:	05650263          	beq	a0,s6,80004524 <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800044e4:	21c4a783          	lw	a5,540(s1)
    800044e8:	0017871b          	addiw	a4,a5,1
    800044ec:	20e4ae23          	sw	a4,540(s1)
    800044f0:	1ff7f793          	andi	a5,a5,511
    800044f4:	97a6                	add	a5,a5,s1
    800044f6:	faf44703          	lbu	a4,-81(s0)
    800044fa:	00e78c23          	sb	a4,24(a5)
      i++;
    800044fe:	2905                	addiw	s2,s2,1
    80004500:	b755                	j	800044a4 <pipewrite+0x80>
    80004502:	7b02                	ld	s6,32(sp)
    80004504:	6be2                	ld	s7,24(sp)
    80004506:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004508:	21848513          	addi	a0,s1,536
    8000450c:	ffffd097          	auipc	ra,0xffffd
    80004510:	4c0080e7          	jalr	1216(ra) # 800019cc <wakeup>
  release(&pi->lock);
    80004514:	8526                	mv	a0,s1
    80004516:	00002097          	auipc	ra,0x2
    8000451a:	3ba080e7          	jalr	954(ra) # 800068d0 <release>
  return i;
    8000451e:	bfb1                	j	8000447a <pipewrite+0x56>
  int i = 0;
    80004520:	4901                	li	s2,0
    80004522:	b7dd                	j	80004508 <pipewrite+0xe4>
    80004524:	7b02                	ld	s6,32(sp)
    80004526:	6be2                	ld	s7,24(sp)
    80004528:	6c42                	ld	s8,16(sp)
    8000452a:	bff9                	j	80004508 <pipewrite+0xe4>

000000008000452c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000452c:	715d                	addi	sp,sp,-80
    8000452e:	e486                	sd	ra,72(sp)
    80004530:	e0a2                	sd	s0,64(sp)
    80004532:	fc26                	sd	s1,56(sp)
    80004534:	f84a                	sd	s2,48(sp)
    80004536:	f44e                	sd	s3,40(sp)
    80004538:	f052                	sd	s4,32(sp)
    8000453a:	ec56                	sd	s5,24(sp)
    8000453c:	0880                	addi	s0,sp,80
    8000453e:	84aa                	mv	s1,a0
    80004540:	892e                	mv	s2,a1
    80004542:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004544:	ffffd097          	auipc	ra,0xffffd
    80004548:	d76080e7          	jalr	-650(ra) # 800012ba <myproc>
    8000454c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000454e:	8526                	mv	a0,s1
    80004550:	00002097          	auipc	ra,0x2
    80004554:	2cc080e7          	jalr	716(ra) # 8000681c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004558:	2184a703          	lw	a4,536(s1)
    8000455c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004560:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004564:	02f71963          	bne	a4,a5,80004596 <piperead+0x6a>
    80004568:	2244a783          	lw	a5,548(s1)
    8000456c:	cf95                	beqz	a5,800045a8 <piperead+0x7c>
    if(killed(pr)){
    8000456e:	8552                	mv	a0,s4
    80004570:	ffffd097          	auipc	ra,0xffffd
    80004574:	6a0080e7          	jalr	1696(ra) # 80001c10 <killed>
    80004578:	e10d                	bnez	a0,8000459a <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000457a:	85a6                	mv	a1,s1
    8000457c:	854e                	mv	a0,s3
    8000457e:	ffffd097          	auipc	ra,0xffffd
    80004582:	3ea080e7          	jalr	1002(ra) # 80001968 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004586:	2184a703          	lw	a4,536(s1)
    8000458a:	21c4a783          	lw	a5,540(s1)
    8000458e:	fcf70de3          	beq	a4,a5,80004568 <piperead+0x3c>
    80004592:	e85a                	sd	s6,16(sp)
    80004594:	a819                	j	800045aa <piperead+0x7e>
    80004596:	e85a                	sd	s6,16(sp)
    80004598:	a809                	j	800045aa <piperead+0x7e>
      release(&pi->lock);
    8000459a:	8526                	mv	a0,s1
    8000459c:	00002097          	auipc	ra,0x2
    800045a0:	334080e7          	jalr	820(ra) # 800068d0 <release>
      return -1;
    800045a4:	59fd                	li	s3,-1
    800045a6:	a0a5                	j	8000460e <piperead+0xe2>
    800045a8:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800045aa:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800045ac:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800045ae:	05505463          	blez	s5,800045f6 <piperead+0xca>
    if(pi->nread == pi->nwrite)
    800045b2:	2184a783          	lw	a5,536(s1)
    800045b6:	21c4a703          	lw	a4,540(s1)
    800045ba:	02f70e63          	beq	a4,a5,800045f6 <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800045be:	0017871b          	addiw	a4,a5,1
    800045c2:	20e4ac23          	sw	a4,536(s1)
    800045c6:	1ff7f793          	andi	a5,a5,511
    800045ca:	97a6                	add	a5,a5,s1
    800045cc:	0187c783          	lbu	a5,24(a5)
    800045d0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800045d4:	4685                	li	a3,1
    800045d6:	fbf40613          	addi	a2,s0,-65
    800045da:	85ca                	mv	a1,s2
    800045dc:	050a3503          	ld	a0,80(s4)
    800045e0:	ffffd097          	auipc	ra,0xffffd
    800045e4:	8a0080e7          	jalr	-1888(ra) # 80000e80 <copyout>
    800045e8:	01650763          	beq	a0,s6,800045f6 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800045ec:	2985                	addiw	s3,s3,1
    800045ee:	0905                	addi	s2,s2,1
    800045f0:	fd3a91e3          	bne	s5,s3,800045b2 <piperead+0x86>
    800045f4:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800045f6:	21c48513          	addi	a0,s1,540
    800045fa:	ffffd097          	auipc	ra,0xffffd
    800045fe:	3d2080e7          	jalr	978(ra) # 800019cc <wakeup>
  release(&pi->lock);
    80004602:	8526                	mv	a0,s1
    80004604:	00002097          	auipc	ra,0x2
    80004608:	2cc080e7          	jalr	716(ra) # 800068d0 <release>
    8000460c:	6b42                	ld	s6,16(sp)
  return i;
}
    8000460e:	854e                	mv	a0,s3
    80004610:	60a6                	ld	ra,72(sp)
    80004612:	6406                	ld	s0,64(sp)
    80004614:	74e2                	ld	s1,56(sp)
    80004616:	7942                	ld	s2,48(sp)
    80004618:	79a2                	ld	s3,40(sp)
    8000461a:	7a02                	ld	s4,32(sp)
    8000461c:	6ae2                	ld	s5,24(sp)
    8000461e:	6161                	addi	sp,sp,80
    80004620:	8082                	ret

0000000080004622 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004622:	1141                	addi	sp,sp,-16
    80004624:	e422                	sd	s0,8(sp)
    80004626:	0800                	addi	s0,sp,16
    80004628:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000462a:	8905                	andi	a0,a0,1
    8000462c:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000462e:	8b89                	andi	a5,a5,2
    80004630:	c399                	beqz	a5,80004636 <flags2perm+0x14>
      perm |= PTE_W;
    80004632:	00456513          	ori	a0,a0,4
    return perm;
}
    80004636:	6422                	ld	s0,8(sp)
    80004638:	0141                	addi	sp,sp,16
    8000463a:	8082                	ret

000000008000463c <exec>:

int
exec(char *path, char **argv)
{
    8000463c:	df010113          	addi	sp,sp,-528
    80004640:	20113423          	sd	ra,520(sp)
    80004644:	20813023          	sd	s0,512(sp)
    80004648:	ffa6                	sd	s1,504(sp)
    8000464a:	fbca                	sd	s2,496(sp)
    8000464c:	0c00                	addi	s0,sp,528
    8000464e:	892a                	mv	s2,a0
    80004650:	dea43c23          	sd	a0,-520(s0)
    80004654:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004658:	ffffd097          	auipc	ra,0xffffd
    8000465c:	c62080e7          	jalr	-926(ra) # 800012ba <myproc>
    80004660:	84aa                	mv	s1,a0

  begin_op();
    80004662:	fffff097          	auipc	ra,0xfffff
    80004666:	43a080e7          	jalr	1082(ra) # 80003a9c <begin_op>

  if((ip = namei(path)) == 0){
    8000466a:	854a                	mv	a0,s2
    8000466c:	fffff097          	auipc	ra,0xfffff
    80004670:	230080e7          	jalr	560(ra) # 8000389c <namei>
    80004674:	c135                	beqz	a0,800046d8 <exec+0x9c>
    80004676:	f3d2                	sd	s4,480(sp)
    80004678:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000467a:	fffff097          	auipc	ra,0xfffff
    8000467e:	a54080e7          	jalr	-1452(ra) # 800030ce <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004682:	04000713          	li	a4,64
    80004686:	4681                	li	a3,0
    80004688:	e5040613          	addi	a2,s0,-432
    8000468c:	4581                	li	a1,0
    8000468e:	8552                	mv	a0,s4
    80004690:	fffff097          	auipc	ra,0xfffff
    80004694:	cf6080e7          	jalr	-778(ra) # 80003386 <readi>
    80004698:	04000793          	li	a5,64
    8000469c:	00f51a63          	bne	a0,a5,800046b0 <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800046a0:	e5042703          	lw	a4,-432(s0)
    800046a4:	464c47b7          	lui	a5,0x464c4
    800046a8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800046ac:	02f70c63          	beq	a4,a5,800046e4 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800046b0:	8552                	mv	a0,s4
    800046b2:	fffff097          	auipc	ra,0xfffff
    800046b6:	c82080e7          	jalr	-894(ra) # 80003334 <iunlockput>
    end_op();
    800046ba:	fffff097          	auipc	ra,0xfffff
    800046be:	45c080e7          	jalr	1116(ra) # 80003b16 <end_op>
  }
  return -1;
    800046c2:	557d                	li	a0,-1
    800046c4:	7a1e                	ld	s4,480(sp)
}
    800046c6:	20813083          	ld	ra,520(sp)
    800046ca:	20013403          	ld	s0,512(sp)
    800046ce:	74fe                	ld	s1,504(sp)
    800046d0:	795e                	ld	s2,496(sp)
    800046d2:	21010113          	addi	sp,sp,528
    800046d6:	8082                	ret
    end_op();
    800046d8:	fffff097          	auipc	ra,0xfffff
    800046dc:	43e080e7          	jalr	1086(ra) # 80003b16 <end_op>
    return -1;
    800046e0:	557d                	li	a0,-1
    800046e2:	b7d5                	j	800046c6 <exec+0x8a>
    800046e4:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800046e6:	8526                	mv	a0,s1
    800046e8:	ffffd097          	auipc	ra,0xffffd
    800046ec:	c9a080e7          	jalr	-870(ra) # 80001382 <proc_pagetable>
    800046f0:	8b2a                	mv	s6,a0
    800046f2:	30050f63          	beqz	a0,80004a10 <exec+0x3d4>
    800046f6:	f7ce                	sd	s3,488(sp)
    800046f8:	efd6                	sd	s5,472(sp)
    800046fa:	e7de                	sd	s7,456(sp)
    800046fc:	e3e2                	sd	s8,448(sp)
    800046fe:	ff66                	sd	s9,440(sp)
    80004700:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004702:	e7042d03          	lw	s10,-400(s0)
    80004706:	e8845783          	lhu	a5,-376(s0)
    8000470a:	14078d63          	beqz	a5,80004864 <exec+0x228>
    8000470e:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004710:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004712:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004714:	6c85                	lui	s9,0x1
    80004716:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000471a:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000471e:	6a85                	lui	s5,0x1
    80004720:	a0b5                	j	8000478c <exec+0x150>
      panic("loadseg: address should exist");
    80004722:	00004517          	auipc	a0,0x4
    80004726:	fce50513          	addi	a0,a0,-50 # 800086f0 <etext+0x6f0>
    8000472a:	00002097          	auipc	ra,0x2
    8000472e:	b78080e7          	jalr	-1160(ra) # 800062a2 <panic>
    if(sz - i < PGSIZE)
    80004732:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004734:	8726                	mv	a4,s1
    80004736:	012c06bb          	addw	a3,s8,s2
    8000473a:	4581                	li	a1,0
    8000473c:	8552                	mv	a0,s4
    8000473e:	fffff097          	auipc	ra,0xfffff
    80004742:	c48080e7          	jalr	-952(ra) # 80003386 <readi>
    80004746:	2501                	sext.w	a0,a0
    80004748:	28a49863          	bne	s1,a0,800049d8 <exec+0x39c>
  for(i = 0; i < sz; i += PGSIZE){
    8000474c:	012a893b          	addw	s2,s5,s2
    80004750:	03397563          	bgeu	s2,s3,8000477a <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80004754:	02091593          	slli	a1,s2,0x20
    80004758:	9181                	srli	a1,a1,0x20
    8000475a:	95de                	add	a1,a1,s7
    8000475c:	855a                	mv	a0,s6
    8000475e:	ffffc097          	auipc	ra,0xffffc
    80004762:	fe8080e7          	jalr	-24(ra) # 80000746 <walkaddr>
    80004766:	862a                	mv	a2,a0
    if(pa == 0)
    80004768:	dd4d                	beqz	a0,80004722 <exec+0xe6>
    if(sz - i < PGSIZE)
    8000476a:	412984bb          	subw	s1,s3,s2
    8000476e:	0004879b          	sext.w	a5,s1
    80004772:	fcfcf0e3          	bgeu	s9,a5,80004732 <exec+0xf6>
    80004776:	84d6                	mv	s1,s5
    80004778:	bf6d                	j	80004732 <exec+0xf6>
    sz = sz1;
    8000477a:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000477e:	2d85                	addiw	s11,s11,1
    80004780:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004784:	e8845783          	lhu	a5,-376(s0)
    80004788:	08fdd663          	bge	s11,a5,80004814 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000478c:	2d01                	sext.w	s10,s10
    8000478e:	03800713          	li	a4,56
    80004792:	86ea                	mv	a3,s10
    80004794:	e1840613          	addi	a2,s0,-488
    80004798:	4581                	li	a1,0
    8000479a:	8552                	mv	a0,s4
    8000479c:	fffff097          	auipc	ra,0xfffff
    800047a0:	bea080e7          	jalr	-1046(ra) # 80003386 <readi>
    800047a4:	03800793          	li	a5,56
    800047a8:	20f51063          	bne	a0,a5,800049a8 <exec+0x36c>
    if(ph.type != ELF_PROG_LOAD)
    800047ac:	e1842783          	lw	a5,-488(s0)
    800047b0:	4705                	li	a4,1
    800047b2:	fce796e3          	bne	a5,a4,8000477e <exec+0x142>
    if(ph.memsz < ph.filesz)
    800047b6:	e4043483          	ld	s1,-448(s0)
    800047ba:	e3843783          	ld	a5,-456(s0)
    800047be:	1ef4e963          	bltu	s1,a5,800049b0 <exec+0x374>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800047c2:	e2843783          	ld	a5,-472(s0)
    800047c6:	94be                	add	s1,s1,a5
    800047c8:	1ef4e863          	bltu	s1,a5,800049b8 <exec+0x37c>
    if(ph.vaddr % PGSIZE != 0)
    800047cc:	df043703          	ld	a4,-528(s0)
    800047d0:	8ff9                	and	a5,a5,a4
    800047d2:	1e079763          	bnez	a5,800049c0 <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800047d6:	e1c42503          	lw	a0,-484(s0)
    800047da:	00000097          	auipc	ra,0x0
    800047de:	e48080e7          	jalr	-440(ra) # 80004622 <flags2perm>
    800047e2:	86aa                	mv	a3,a0
    800047e4:	8626                	mv	a2,s1
    800047e6:	85ca                	mv	a1,s2
    800047e8:	855a                	mv	a0,s6
    800047ea:	ffffc097          	auipc	ra,0xffffc
    800047ee:	344080e7          	jalr	836(ra) # 80000b2e <uvmalloc>
    800047f2:	e0a43423          	sd	a0,-504(s0)
    800047f6:	1c050963          	beqz	a0,800049c8 <exec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800047fa:	e2843b83          	ld	s7,-472(s0)
    800047fe:	e2042c03          	lw	s8,-480(s0)
    80004802:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004806:	00098463          	beqz	s3,8000480e <exec+0x1d2>
    8000480a:	4901                	li	s2,0
    8000480c:	b7a1                	j	80004754 <exec+0x118>
    sz = sz1;
    8000480e:	e0843903          	ld	s2,-504(s0)
    80004812:	b7b5                	j	8000477e <exec+0x142>
    80004814:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004816:	8552                	mv	a0,s4
    80004818:	fffff097          	auipc	ra,0xfffff
    8000481c:	b1c080e7          	jalr	-1252(ra) # 80003334 <iunlockput>
  end_op();
    80004820:	fffff097          	auipc	ra,0xfffff
    80004824:	2f6080e7          	jalr	758(ra) # 80003b16 <end_op>
  p = myproc();
    80004828:	ffffd097          	auipc	ra,0xffffd
    8000482c:	a92080e7          	jalr	-1390(ra) # 800012ba <myproc>
    80004830:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004832:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004836:	6985                	lui	s3,0x1
    80004838:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000483a:	99ca                	add	s3,s3,s2
    8000483c:	77fd                	lui	a5,0xfffff
    8000483e:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004842:	4691                	li	a3,4
    80004844:	6609                	lui	a2,0x2
    80004846:	964e                	add	a2,a2,s3
    80004848:	85ce                	mv	a1,s3
    8000484a:	855a                	mv	a0,s6
    8000484c:	ffffc097          	auipc	ra,0xffffc
    80004850:	2e2080e7          	jalr	738(ra) # 80000b2e <uvmalloc>
    80004854:	892a                	mv	s2,a0
    80004856:	e0a43423          	sd	a0,-504(s0)
    8000485a:	e519                	bnez	a0,80004868 <exec+0x22c>
  if(pagetable)
    8000485c:	e1343423          	sd	s3,-504(s0)
    80004860:	4a01                	li	s4,0
    80004862:	aaa5                	j	800049da <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004864:	4901                	li	s2,0
    80004866:	bf45                	j	80004816 <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004868:	75f9                	lui	a1,0xffffe
    8000486a:	95aa                	add	a1,a1,a0
    8000486c:	855a                	mv	a0,s6
    8000486e:	ffffc097          	auipc	ra,0xffffc
    80004872:	542080e7          	jalr	1346(ra) # 80000db0 <uvmclear>
  stackbase = sp - PGSIZE;
    80004876:	7bfd                	lui	s7,0xfffff
    80004878:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000487a:	e0043783          	ld	a5,-512(s0)
    8000487e:	6388                	ld	a0,0(a5)
    80004880:	c52d                	beqz	a0,800048ea <exec+0x2ae>
    80004882:	e9040993          	addi	s3,s0,-368
    80004886:	f9040c13          	addi	s8,s0,-112
    8000488a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000488c:	ffffc097          	auipc	ra,0xffffc
    80004890:	cac080e7          	jalr	-852(ra) # 80000538 <strlen>
    80004894:	0015079b          	addiw	a5,a0,1
    80004898:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000489c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800048a0:	13796863          	bltu	s2,s7,800049d0 <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800048a4:	e0043d03          	ld	s10,-512(s0)
    800048a8:	000d3a03          	ld	s4,0(s10)
    800048ac:	8552                	mv	a0,s4
    800048ae:	ffffc097          	auipc	ra,0xffffc
    800048b2:	c8a080e7          	jalr	-886(ra) # 80000538 <strlen>
    800048b6:	0015069b          	addiw	a3,a0,1
    800048ba:	8652                	mv	a2,s4
    800048bc:	85ca                	mv	a1,s2
    800048be:	855a                	mv	a0,s6
    800048c0:	ffffc097          	auipc	ra,0xffffc
    800048c4:	5c0080e7          	jalr	1472(ra) # 80000e80 <copyout>
    800048c8:	10054663          	bltz	a0,800049d4 <exec+0x398>
    ustack[argc] = sp;
    800048cc:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800048d0:	0485                	addi	s1,s1,1
    800048d2:	008d0793          	addi	a5,s10,8
    800048d6:	e0f43023          	sd	a5,-512(s0)
    800048da:	008d3503          	ld	a0,8(s10)
    800048de:	c909                	beqz	a0,800048f0 <exec+0x2b4>
    if(argc >= MAXARG)
    800048e0:	09a1                	addi	s3,s3,8
    800048e2:	fb8995e3          	bne	s3,s8,8000488c <exec+0x250>
  ip = 0;
    800048e6:	4a01                	li	s4,0
    800048e8:	a8cd                	j	800049da <exec+0x39e>
  sp = sz;
    800048ea:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800048ee:	4481                	li	s1,0
  ustack[argc] = 0;
    800048f0:	00349793          	slli	a5,s1,0x3
    800048f4:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffba5f0>
    800048f8:	97a2                	add	a5,a5,s0
    800048fa:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800048fe:	00148693          	addi	a3,s1,1
    80004902:	068e                	slli	a3,a3,0x3
    80004904:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004908:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000490c:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004910:	f57966e3          	bltu	s2,s7,8000485c <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004914:	e9040613          	addi	a2,s0,-368
    80004918:	85ca                	mv	a1,s2
    8000491a:	855a                	mv	a0,s6
    8000491c:	ffffc097          	auipc	ra,0xffffc
    80004920:	564080e7          	jalr	1380(ra) # 80000e80 <copyout>
    80004924:	0e054863          	bltz	a0,80004a14 <exec+0x3d8>
  p->trapframe->a1 = sp;
    80004928:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000492c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004930:	df843783          	ld	a5,-520(s0)
    80004934:	0007c703          	lbu	a4,0(a5)
    80004938:	cf11                	beqz	a4,80004954 <exec+0x318>
    8000493a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000493c:	02f00693          	li	a3,47
    80004940:	a039                	j	8000494e <exec+0x312>
      last = s+1;
    80004942:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004946:	0785                	addi	a5,a5,1
    80004948:	fff7c703          	lbu	a4,-1(a5)
    8000494c:	c701                	beqz	a4,80004954 <exec+0x318>
    if(*s == '/')
    8000494e:	fed71ce3          	bne	a4,a3,80004946 <exec+0x30a>
    80004952:	bfc5                	j	80004942 <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    80004954:	4641                	li	a2,16
    80004956:	df843583          	ld	a1,-520(s0)
    8000495a:	158a8513          	addi	a0,s5,344
    8000495e:	ffffc097          	auipc	ra,0xffffc
    80004962:	ba8080e7          	jalr	-1112(ra) # 80000506 <safestrcpy>
  oldpagetable = p->pagetable;
    80004966:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000496a:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000496e:	e0843783          	ld	a5,-504(s0)
    80004972:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004976:	058ab783          	ld	a5,88(s5)
    8000497a:	e6843703          	ld	a4,-408(s0)
    8000497e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004980:	058ab783          	ld	a5,88(s5)
    80004984:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004988:	85e6                	mv	a1,s9
    8000498a:	ffffd097          	auipc	ra,0xffffd
    8000498e:	a94080e7          	jalr	-1388(ra) # 8000141e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004992:	0004851b          	sext.w	a0,s1
    80004996:	79be                	ld	s3,488(sp)
    80004998:	7a1e                	ld	s4,480(sp)
    8000499a:	6afe                	ld	s5,472(sp)
    8000499c:	6b5e                	ld	s6,464(sp)
    8000499e:	6bbe                	ld	s7,456(sp)
    800049a0:	6c1e                	ld	s8,448(sp)
    800049a2:	7cfa                	ld	s9,440(sp)
    800049a4:	7d5a                	ld	s10,432(sp)
    800049a6:	b305                	j	800046c6 <exec+0x8a>
    800049a8:	e1243423          	sd	s2,-504(s0)
    800049ac:	7dba                	ld	s11,424(sp)
    800049ae:	a035                	j	800049da <exec+0x39e>
    800049b0:	e1243423          	sd	s2,-504(s0)
    800049b4:	7dba                	ld	s11,424(sp)
    800049b6:	a015                	j	800049da <exec+0x39e>
    800049b8:	e1243423          	sd	s2,-504(s0)
    800049bc:	7dba                	ld	s11,424(sp)
    800049be:	a831                	j	800049da <exec+0x39e>
    800049c0:	e1243423          	sd	s2,-504(s0)
    800049c4:	7dba                	ld	s11,424(sp)
    800049c6:	a811                	j	800049da <exec+0x39e>
    800049c8:	e1243423          	sd	s2,-504(s0)
    800049cc:	7dba                	ld	s11,424(sp)
    800049ce:	a031                	j	800049da <exec+0x39e>
  ip = 0;
    800049d0:	4a01                	li	s4,0
    800049d2:	a021                	j	800049da <exec+0x39e>
    800049d4:	4a01                	li	s4,0
  if(pagetable)
    800049d6:	a011                	j	800049da <exec+0x39e>
    800049d8:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800049da:	e0843583          	ld	a1,-504(s0)
    800049de:	855a                	mv	a0,s6
    800049e0:	ffffd097          	auipc	ra,0xffffd
    800049e4:	a3e080e7          	jalr	-1474(ra) # 8000141e <proc_freepagetable>
  return -1;
    800049e8:	557d                	li	a0,-1
  if(ip){
    800049ea:	000a1b63          	bnez	s4,80004a00 <exec+0x3c4>
    800049ee:	79be                	ld	s3,488(sp)
    800049f0:	7a1e                	ld	s4,480(sp)
    800049f2:	6afe                	ld	s5,472(sp)
    800049f4:	6b5e                	ld	s6,464(sp)
    800049f6:	6bbe                	ld	s7,456(sp)
    800049f8:	6c1e                	ld	s8,448(sp)
    800049fa:	7cfa                	ld	s9,440(sp)
    800049fc:	7d5a                	ld	s10,432(sp)
    800049fe:	b1e1                	j	800046c6 <exec+0x8a>
    80004a00:	79be                	ld	s3,488(sp)
    80004a02:	6afe                	ld	s5,472(sp)
    80004a04:	6b5e                	ld	s6,464(sp)
    80004a06:	6bbe                	ld	s7,456(sp)
    80004a08:	6c1e                	ld	s8,448(sp)
    80004a0a:	7cfa                	ld	s9,440(sp)
    80004a0c:	7d5a                	ld	s10,432(sp)
    80004a0e:	b14d                	j	800046b0 <exec+0x74>
    80004a10:	6b5e                	ld	s6,464(sp)
    80004a12:	b979                	j	800046b0 <exec+0x74>
  sz = sz1;
    80004a14:	e0843983          	ld	s3,-504(s0)
    80004a18:	b591                	j	8000485c <exec+0x220>

0000000080004a1a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004a1a:	7179                	addi	sp,sp,-48
    80004a1c:	f406                	sd	ra,40(sp)
    80004a1e:	f022                	sd	s0,32(sp)
    80004a20:	ec26                	sd	s1,24(sp)
    80004a22:	e84a                	sd	s2,16(sp)
    80004a24:	1800                	addi	s0,sp,48
    80004a26:	892e                	mv	s2,a1
    80004a28:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004a2a:	fdc40593          	addi	a1,s0,-36
    80004a2e:	ffffe097          	auipc	ra,0xffffe
    80004a32:	ab4080e7          	jalr	-1356(ra) # 800024e2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004a36:	fdc42703          	lw	a4,-36(s0)
    80004a3a:	47bd                	li	a5,15
    80004a3c:	02e7eb63          	bltu	a5,a4,80004a72 <argfd+0x58>
    80004a40:	ffffd097          	auipc	ra,0xffffd
    80004a44:	87a080e7          	jalr	-1926(ra) # 800012ba <myproc>
    80004a48:	fdc42703          	lw	a4,-36(s0)
    80004a4c:	01a70793          	addi	a5,a4,26
    80004a50:	078e                	slli	a5,a5,0x3
    80004a52:	953e                	add	a0,a0,a5
    80004a54:	611c                	ld	a5,0(a0)
    80004a56:	c385                	beqz	a5,80004a76 <argfd+0x5c>
    return -1;
  if(pfd)
    80004a58:	00090463          	beqz	s2,80004a60 <argfd+0x46>
    *pfd = fd;
    80004a5c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004a60:	4501                	li	a0,0
  if(pf)
    80004a62:	c091                	beqz	s1,80004a66 <argfd+0x4c>
    *pf = f;
    80004a64:	e09c                	sd	a5,0(s1)
}
    80004a66:	70a2                	ld	ra,40(sp)
    80004a68:	7402                	ld	s0,32(sp)
    80004a6a:	64e2                	ld	s1,24(sp)
    80004a6c:	6942                	ld	s2,16(sp)
    80004a6e:	6145                	addi	sp,sp,48
    80004a70:	8082                	ret
    return -1;
    80004a72:	557d                	li	a0,-1
    80004a74:	bfcd                	j	80004a66 <argfd+0x4c>
    80004a76:	557d                	li	a0,-1
    80004a78:	b7fd                	j	80004a66 <argfd+0x4c>

0000000080004a7a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004a7a:	1101                	addi	sp,sp,-32
    80004a7c:	ec06                	sd	ra,24(sp)
    80004a7e:	e822                	sd	s0,16(sp)
    80004a80:	e426                	sd	s1,8(sp)
    80004a82:	1000                	addi	s0,sp,32
    80004a84:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004a86:	ffffd097          	auipc	ra,0xffffd
    80004a8a:	834080e7          	jalr	-1996(ra) # 800012ba <myproc>
    80004a8e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004a90:	0d050793          	addi	a5,a0,208
    80004a94:	4501                	li	a0,0
    80004a96:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004a98:	6398                	ld	a4,0(a5)
    80004a9a:	cb19                	beqz	a4,80004ab0 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004a9c:	2505                	addiw	a0,a0,1
    80004a9e:	07a1                	addi	a5,a5,8
    80004aa0:	fed51ce3          	bne	a0,a3,80004a98 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004aa4:	557d                	li	a0,-1
}
    80004aa6:	60e2                	ld	ra,24(sp)
    80004aa8:	6442                	ld	s0,16(sp)
    80004aaa:	64a2                	ld	s1,8(sp)
    80004aac:	6105                	addi	sp,sp,32
    80004aae:	8082                	ret
      p->ofile[fd] = f;
    80004ab0:	01a50793          	addi	a5,a0,26
    80004ab4:	078e                	slli	a5,a5,0x3
    80004ab6:	963e                	add	a2,a2,a5
    80004ab8:	e204                	sd	s1,0(a2)
      return fd;
    80004aba:	b7f5                	j	80004aa6 <fdalloc+0x2c>

0000000080004abc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004abc:	715d                	addi	sp,sp,-80
    80004abe:	e486                	sd	ra,72(sp)
    80004ac0:	e0a2                	sd	s0,64(sp)
    80004ac2:	fc26                	sd	s1,56(sp)
    80004ac4:	f84a                	sd	s2,48(sp)
    80004ac6:	f44e                	sd	s3,40(sp)
    80004ac8:	ec56                	sd	s5,24(sp)
    80004aca:	e85a                	sd	s6,16(sp)
    80004acc:	0880                	addi	s0,sp,80
    80004ace:	8b2e                	mv	s6,a1
    80004ad0:	89b2                	mv	s3,a2
    80004ad2:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004ad4:	fb040593          	addi	a1,s0,-80
    80004ad8:	fffff097          	auipc	ra,0xfffff
    80004adc:	de2080e7          	jalr	-542(ra) # 800038ba <nameiparent>
    80004ae0:	84aa                	mv	s1,a0
    80004ae2:	14050e63          	beqz	a0,80004c3e <create+0x182>
    return 0;

  ilock(dp);
    80004ae6:	ffffe097          	auipc	ra,0xffffe
    80004aea:	5e8080e7          	jalr	1512(ra) # 800030ce <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004aee:	4601                	li	a2,0
    80004af0:	fb040593          	addi	a1,s0,-80
    80004af4:	8526                	mv	a0,s1
    80004af6:	fffff097          	auipc	ra,0xfffff
    80004afa:	ae4080e7          	jalr	-1308(ra) # 800035da <dirlookup>
    80004afe:	8aaa                	mv	s5,a0
    80004b00:	c539                	beqz	a0,80004b4e <create+0x92>
    iunlockput(dp);
    80004b02:	8526                	mv	a0,s1
    80004b04:	fffff097          	auipc	ra,0xfffff
    80004b08:	830080e7          	jalr	-2000(ra) # 80003334 <iunlockput>
    ilock(ip);
    80004b0c:	8556                	mv	a0,s5
    80004b0e:	ffffe097          	auipc	ra,0xffffe
    80004b12:	5c0080e7          	jalr	1472(ra) # 800030ce <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004b16:	4789                	li	a5,2
    80004b18:	02fb1463          	bne	s6,a5,80004b40 <create+0x84>
    80004b1c:	044ad783          	lhu	a5,68(s5)
    80004b20:	37f9                	addiw	a5,a5,-2
    80004b22:	17c2                	slli	a5,a5,0x30
    80004b24:	93c1                	srli	a5,a5,0x30
    80004b26:	4705                	li	a4,1
    80004b28:	00f76c63          	bltu	a4,a5,80004b40 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004b2c:	8556                	mv	a0,s5
    80004b2e:	60a6                	ld	ra,72(sp)
    80004b30:	6406                	ld	s0,64(sp)
    80004b32:	74e2                	ld	s1,56(sp)
    80004b34:	7942                	ld	s2,48(sp)
    80004b36:	79a2                	ld	s3,40(sp)
    80004b38:	6ae2                	ld	s5,24(sp)
    80004b3a:	6b42                	ld	s6,16(sp)
    80004b3c:	6161                	addi	sp,sp,80
    80004b3e:	8082                	ret
    iunlockput(ip);
    80004b40:	8556                	mv	a0,s5
    80004b42:	ffffe097          	auipc	ra,0xffffe
    80004b46:	7f2080e7          	jalr	2034(ra) # 80003334 <iunlockput>
    return 0;
    80004b4a:	4a81                	li	s5,0
    80004b4c:	b7c5                	j	80004b2c <create+0x70>
    80004b4e:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004b50:	85da                	mv	a1,s6
    80004b52:	4088                	lw	a0,0(s1)
    80004b54:	ffffe097          	auipc	ra,0xffffe
    80004b58:	3d6080e7          	jalr	982(ra) # 80002f2a <ialloc>
    80004b5c:	8a2a                	mv	s4,a0
    80004b5e:	c531                	beqz	a0,80004baa <create+0xee>
  ilock(ip);
    80004b60:	ffffe097          	auipc	ra,0xffffe
    80004b64:	56e080e7          	jalr	1390(ra) # 800030ce <ilock>
  ip->major = major;
    80004b68:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004b6c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004b70:	4905                	li	s2,1
    80004b72:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004b76:	8552                	mv	a0,s4
    80004b78:	ffffe097          	auipc	ra,0xffffe
    80004b7c:	48a080e7          	jalr	1162(ra) # 80003002 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004b80:	032b0d63          	beq	s6,s2,80004bba <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004b84:	004a2603          	lw	a2,4(s4)
    80004b88:	fb040593          	addi	a1,s0,-80
    80004b8c:	8526                	mv	a0,s1
    80004b8e:	fffff097          	auipc	ra,0xfffff
    80004b92:	c5c080e7          	jalr	-932(ra) # 800037ea <dirlink>
    80004b96:	08054163          	bltz	a0,80004c18 <create+0x15c>
  iunlockput(dp);
    80004b9a:	8526                	mv	a0,s1
    80004b9c:	ffffe097          	auipc	ra,0xffffe
    80004ba0:	798080e7          	jalr	1944(ra) # 80003334 <iunlockput>
  return ip;
    80004ba4:	8ad2                	mv	s5,s4
    80004ba6:	7a02                	ld	s4,32(sp)
    80004ba8:	b751                	j	80004b2c <create+0x70>
    iunlockput(dp);
    80004baa:	8526                	mv	a0,s1
    80004bac:	ffffe097          	auipc	ra,0xffffe
    80004bb0:	788080e7          	jalr	1928(ra) # 80003334 <iunlockput>
    return 0;
    80004bb4:	8ad2                	mv	s5,s4
    80004bb6:	7a02                	ld	s4,32(sp)
    80004bb8:	bf95                	j	80004b2c <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004bba:	004a2603          	lw	a2,4(s4)
    80004bbe:	00004597          	auipc	a1,0x4
    80004bc2:	b5258593          	addi	a1,a1,-1198 # 80008710 <etext+0x710>
    80004bc6:	8552                	mv	a0,s4
    80004bc8:	fffff097          	auipc	ra,0xfffff
    80004bcc:	c22080e7          	jalr	-990(ra) # 800037ea <dirlink>
    80004bd0:	04054463          	bltz	a0,80004c18 <create+0x15c>
    80004bd4:	40d0                	lw	a2,4(s1)
    80004bd6:	00004597          	auipc	a1,0x4
    80004bda:	b4258593          	addi	a1,a1,-1214 # 80008718 <etext+0x718>
    80004bde:	8552                	mv	a0,s4
    80004be0:	fffff097          	auipc	ra,0xfffff
    80004be4:	c0a080e7          	jalr	-1014(ra) # 800037ea <dirlink>
    80004be8:	02054863          	bltz	a0,80004c18 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004bec:	004a2603          	lw	a2,4(s4)
    80004bf0:	fb040593          	addi	a1,s0,-80
    80004bf4:	8526                	mv	a0,s1
    80004bf6:	fffff097          	auipc	ra,0xfffff
    80004bfa:	bf4080e7          	jalr	-1036(ra) # 800037ea <dirlink>
    80004bfe:	00054d63          	bltz	a0,80004c18 <create+0x15c>
    dp->nlink++;  // for ".."
    80004c02:	04a4d783          	lhu	a5,74(s1)
    80004c06:	2785                	addiw	a5,a5,1
    80004c08:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c0c:	8526                	mv	a0,s1
    80004c0e:	ffffe097          	auipc	ra,0xffffe
    80004c12:	3f4080e7          	jalr	1012(ra) # 80003002 <iupdate>
    80004c16:	b751                	j	80004b9a <create+0xde>
  ip->nlink = 0;
    80004c18:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004c1c:	8552                	mv	a0,s4
    80004c1e:	ffffe097          	auipc	ra,0xffffe
    80004c22:	3e4080e7          	jalr	996(ra) # 80003002 <iupdate>
  iunlockput(ip);
    80004c26:	8552                	mv	a0,s4
    80004c28:	ffffe097          	auipc	ra,0xffffe
    80004c2c:	70c080e7          	jalr	1804(ra) # 80003334 <iunlockput>
  iunlockput(dp);
    80004c30:	8526                	mv	a0,s1
    80004c32:	ffffe097          	auipc	ra,0xffffe
    80004c36:	702080e7          	jalr	1794(ra) # 80003334 <iunlockput>
  return 0;
    80004c3a:	7a02                	ld	s4,32(sp)
    80004c3c:	bdc5                	j	80004b2c <create+0x70>
    return 0;
    80004c3e:	8aaa                	mv	s5,a0
    80004c40:	b5f5                	j	80004b2c <create+0x70>

0000000080004c42 <sys_dup>:
{
    80004c42:	7179                	addi	sp,sp,-48
    80004c44:	f406                	sd	ra,40(sp)
    80004c46:	f022                	sd	s0,32(sp)
    80004c48:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004c4a:	fd840613          	addi	a2,s0,-40
    80004c4e:	4581                	li	a1,0
    80004c50:	4501                	li	a0,0
    80004c52:	00000097          	auipc	ra,0x0
    80004c56:	dc8080e7          	jalr	-568(ra) # 80004a1a <argfd>
    return -1;
    80004c5a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004c5c:	02054763          	bltz	a0,80004c8a <sys_dup+0x48>
    80004c60:	ec26                	sd	s1,24(sp)
    80004c62:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004c64:	fd843903          	ld	s2,-40(s0)
    80004c68:	854a                	mv	a0,s2
    80004c6a:	00000097          	auipc	ra,0x0
    80004c6e:	e10080e7          	jalr	-496(ra) # 80004a7a <fdalloc>
    80004c72:	84aa                	mv	s1,a0
    return -1;
    80004c74:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004c76:	00054f63          	bltz	a0,80004c94 <sys_dup+0x52>
  filedup(f);
    80004c7a:	854a                	mv	a0,s2
    80004c7c:	fffff097          	auipc	ra,0xfffff
    80004c80:	298080e7          	jalr	664(ra) # 80003f14 <filedup>
  return fd;
    80004c84:	87a6                	mv	a5,s1
    80004c86:	64e2                	ld	s1,24(sp)
    80004c88:	6942                	ld	s2,16(sp)
}
    80004c8a:	853e                	mv	a0,a5
    80004c8c:	70a2                	ld	ra,40(sp)
    80004c8e:	7402                	ld	s0,32(sp)
    80004c90:	6145                	addi	sp,sp,48
    80004c92:	8082                	ret
    80004c94:	64e2                	ld	s1,24(sp)
    80004c96:	6942                	ld	s2,16(sp)
    80004c98:	bfcd                	j	80004c8a <sys_dup+0x48>

0000000080004c9a <sys_read>:
{
    80004c9a:	7179                	addi	sp,sp,-48
    80004c9c:	f406                	sd	ra,40(sp)
    80004c9e:	f022                	sd	s0,32(sp)
    80004ca0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004ca2:	fd840593          	addi	a1,s0,-40
    80004ca6:	4505                	li	a0,1
    80004ca8:	ffffe097          	auipc	ra,0xffffe
    80004cac:	85a080e7          	jalr	-1958(ra) # 80002502 <argaddr>
  argint(2, &n);
    80004cb0:	fe440593          	addi	a1,s0,-28
    80004cb4:	4509                	li	a0,2
    80004cb6:	ffffe097          	auipc	ra,0xffffe
    80004cba:	82c080e7          	jalr	-2004(ra) # 800024e2 <argint>
  if(argfd(0, 0, &f) < 0)
    80004cbe:	fe840613          	addi	a2,s0,-24
    80004cc2:	4581                	li	a1,0
    80004cc4:	4501                	li	a0,0
    80004cc6:	00000097          	auipc	ra,0x0
    80004cca:	d54080e7          	jalr	-684(ra) # 80004a1a <argfd>
    80004cce:	87aa                	mv	a5,a0
    return -1;
    80004cd0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004cd2:	0007cc63          	bltz	a5,80004cea <sys_read+0x50>
  return fileread(f, p, n);
    80004cd6:	fe442603          	lw	a2,-28(s0)
    80004cda:	fd843583          	ld	a1,-40(s0)
    80004cde:	fe843503          	ld	a0,-24(s0)
    80004ce2:	fffff097          	auipc	ra,0xfffff
    80004ce6:	3d8080e7          	jalr	984(ra) # 800040ba <fileread>
}
    80004cea:	70a2                	ld	ra,40(sp)
    80004cec:	7402                	ld	s0,32(sp)
    80004cee:	6145                	addi	sp,sp,48
    80004cf0:	8082                	ret

0000000080004cf2 <sys_write>:
{
    80004cf2:	7179                	addi	sp,sp,-48
    80004cf4:	f406                	sd	ra,40(sp)
    80004cf6:	f022                	sd	s0,32(sp)
    80004cf8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004cfa:	fd840593          	addi	a1,s0,-40
    80004cfe:	4505                	li	a0,1
    80004d00:	ffffe097          	auipc	ra,0xffffe
    80004d04:	802080e7          	jalr	-2046(ra) # 80002502 <argaddr>
  argint(2, &n);
    80004d08:	fe440593          	addi	a1,s0,-28
    80004d0c:	4509                	li	a0,2
    80004d0e:	ffffd097          	auipc	ra,0xffffd
    80004d12:	7d4080e7          	jalr	2004(ra) # 800024e2 <argint>
  if(argfd(0, 0, &f) < 0)
    80004d16:	fe840613          	addi	a2,s0,-24
    80004d1a:	4581                	li	a1,0
    80004d1c:	4501                	li	a0,0
    80004d1e:	00000097          	auipc	ra,0x0
    80004d22:	cfc080e7          	jalr	-772(ra) # 80004a1a <argfd>
    80004d26:	87aa                	mv	a5,a0
    return -1;
    80004d28:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004d2a:	0007cc63          	bltz	a5,80004d42 <sys_write+0x50>
  return filewrite(f, p, n);
    80004d2e:	fe442603          	lw	a2,-28(s0)
    80004d32:	fd843583          	ld	a1,-40(s0)
    80004d36:	fe843503          	ld	a0,-24(s0)
    80004d3a:	fffff097          	auipc	ra,0xfffff
    80004d3e:	452080e7          	jalr	1106(ra) # 8000418c <filewrite>
}
    80004d42:	70a2                	ld	ra,40(sp)
    80004d44:	7402                	ld	s0,32(sp)
    80004d46:	6145                	addi	sp,sp,48
    80004d48:	8082                	ret

0000000080004d4a <sys_close>:
{
    80004d4a:	1101                	addi	sp,sp,-32
    80004d4c:	ec06                	sd	ra,24(sp)
    80004d4e:	e822                	sd	s0,16(sp)
    80004d50:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004d52:	fe040613          	addi	a2,s0,-32
    80004d56:	fec40593          	addi	a1,s0,-20
    80004d5a:	4501                	li	a0,0
    80004d5c:	00000097          	auipc	ra,0x0
    80004d60:	cbe080e7          	jalr	-834(ra) # 80004a1a <argfd>
    return -1;
    80004d64:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004d66:	02054463          	bltz	a0,80004d8e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004d6a:	ffffc097          	auipc	ra,0xffffc
    80004d6e:	550080e7          	jalr	1360(ra) # 800012ba <myproc>
    80004d72:	fec42783          	lw	a5,-20(s0)
    80004d76:	07e9                	addi	a5,a5,26
    80004d78:	078e                	slli	a5,a5,0x3
    80004d7a:	953e                	add	a0,a0,a5
    80004d7c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004d80:	fe043503          	ld	a0,-32(s0)
    80004d84:	fffff097          	auipc	ra,0xfffff
    80004d88:	1e2080e7          	jalr	482(ra) # 80003f66 <fileclose>
  return 0;
    80004d8c:	4781                	li	a5,0
}
    80004d8e:	853e                	mv	a0,a5
    80004d90:	60e2                	ld	ra,24(sp)
    80004d92:	6442                	ld	s0,16(sp)
    80004d94:	6105                	addi	sp,sp,32
    80004d96:	8082                	ret

0000000080004d98 <sys_fstat>:
{
    80004d98:	1101                	addi	sp,sp,-32
    80004d9a:	ec06                	sd	ra,24(sp)
    80004d9c:	e822                	sd	s0,16(sp)
    80004d9e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004da0:	fe040593          	addi	a1,s0,-32
    80004da4:	4505                	li	a0,1
    80004da6:	ffffd097          	auipc	ra,0xffffd
    80004daa:	75c080e7          	jalr	1884(ra) # 80002502 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004dae:	fe840613          	addi	a2,s0,-24
    80004db2:	4581                	li	a1,0
    80004db4:	4501                	li	a0,0
    80004db6:	00000097          	auipc	ra,0x0
    80004dba:	c64080e7          	jalr	-924(ra) # 80004a1a <argfd>
    80004dbe:	87aa                	mv	a5,a0
    return -1;
    80004dc0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004dc2:	0007ca63          	bltz	a5,80004dd6 <sys_fstat+0x3e>
  return filestat(f, st);
    80004dc6:	fe043583          	ld	a1,-32(s0)
    80004dca:	fe843503          	ld	a0,-24(s0)
    80004dce:	fffff097          	auipc	ra,0xfffff
    80004dd2:	27a080e7          	jalr	634(ra) # 80004048 <filestat>
}
    80004dd6:	60e2                	ld	ra,24(sp)
    80004dd8:	6442                	ld	s0,16(sp)
    80004dda:	6105                	addi	sp,sp,32
    80004ddc:	8082                	ret

0000000080004dde <sys_link>:
{
    80004dde:	7169                	addi	sp,sp,-304
    80004de0:	f606                	sd	ra,296(sp)
    80004de2:	f222                	sd	s0,288(sp)
    80004de4:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004de6:	08000613          	li	a2,128
    80004dea:	ed040593          	addi	a1,s0,-304
    80004dee:	4501                	li	a0,0
    80004df0:	ffffd097          	auipc	ra,0xffffd
    80004df4:	732080e7          	jalr	1842(ra) # 80002522 <argstr>
    return -1;
    80004df8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004dfa:	12054663          	bltz	a0,80004f26 <sys_link+0x148>
    80004dfe:	08000613          	li	a2,128
    80004e02:	f5040593          	addi	a1,s0,-176
    80004e06:	4505                	li	a0,1
    80004e08:	ffffd097          	auipc	ra,0xffffd
    80004e0c:	71a080e7          	jalr	1818(ra) # 80002522 <argstr>
    return -1;
    80004e10:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004e12:	10054a63          	bltz	a0,80004f26 <sys_link+0x148>
    80004e16:	ee26                	sd	s1,280(sp)
  begin_op();
    80004e18:	fffff097          	auipc	ra,0xfffff
    80004e1c:	c84080e7          	jalr	-892(ra) # 80003a9c <begin_op>
  if((ip = namei(old)) == 0){
    80004e20:	ed040513          	addi	a0,s0,-304
    80004e24:	fffff097          	auipc	ra,0xfffff
    80004e28:	a78080e7          	jalr	-1416(ra) # 8000389c <namei>
    80004e2c:	84aa                	mv	s1,a0
    80004e2e:	c949                	beqz	a0,80004ec0 <sys_link+0xe2>
  ilock(ip);
    80004e30:	ffffe097          	auipc	ra,0xffffe
    80004e34:	29e080e7          	jalr	670(ra) # 800030ce <ilock>
  if(ip->type == T_DIR){
    80004e38:	04449703          	lh	a4,68(s1)
    80004e3c:	4785                	li	a5,1
    80004e3e:	08f70863          	beq	a4,a5,80004ece <sys_link+0xf0>
    80004e42:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004e44:	04a4d783          	lhu	a5,74(s1)
    80004e48:	2785                	addiw	a5,a5,1
    80004e4a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004e4e:	8526                	mv	a0,s1
    80004e50:	ffffe097          	auipc	ra,0xffffe
    80004e54:	1b2080e7          	jalr	434(ra) # 80003002 <iupdate>
  iunlock(ip);
    80004e58:	8526                	mv	a0,s1
    80004e5a:	ffffe097          	auipc	ra,0xffffe
    80004e5e:	33a080e7          	jalr	826(ra) # 80003194 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004e62:	fd040593          	addi	a1,s0,-48
    80004e66:	f5040513          	addi	a0,s0,-176
    80004e6a:	fffff097          	auipc	ra,0xfffff
    80004e6e:	a50080e7          	jalr	-1456(ra) # 800038ba <nameiparent>
    80004e72:	892a                	mv	s2,a0
    80004e74:	cd35                	beqz	a0,80004ef0 <sys_link+0x112>
  ilock(dp);
    80004e76:	ffffe097          	auipc	ra,0xffffe
    80004e7a:	258080e7          	jalr	600(ra) # 800030ce <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004e7e:	00092703          	lw	a4,0(s2)
    80004e82:	409c                	lw	a5,0(s1)
    80004e84:	06f71163          	bne	a4,a5,80004ee6 <sys_link+0x108>
    80004e88:	40d0                	lw	a2,4(s1)
    80004e8a:	fd040593          	addi	a1,s0,-48
    80004e8e:	854a                	mv	a0,s2
    80004e90:	fffff097          	auipc	ra,0xfffff
    80004e94:	95a080e7          	jalr	-1702(ra) # 800037ea <dirlink>
    80004e98:	04054763          	bltz	a0,80004ee6 <sys_link+0x108>
  iunlockput(dp);
    80004e9c:	854a                	mv	a0,s2
    80004e9e:	ffffe097          	auipc	ra,0xffffe
    80004ea2:	496080e7          	jalr	1174(ra) # 80003334 <iunlockput>
  iput(ip);
    80004ea6:	8526                	mv	a0,s1
    80004ea8:	ffffe097          	auipc	ra,0xffffe
    80004eac:	3e4080e7          	jalr	996(ra) # 8000328c <iput>
  end_op();
    80004eb0:	fffff097          	auipc	ra,0xfffff
    80004eb4:	c66080e7          	jalr	-922(ra) # 80003b16 <end_op>
  return 0;
    80004eb8:	4781                	li	a5,0
    80004eba:	64f2                	ld	s1,280(sp)
    80004ebc:	6952                	ld	s2,272(sp)
    80004ebe:	a0a5                	j	80004f26 <sys_link+0x148>
    end_op();
    80004ec0:	fffff097          	auipc	ra,0xfffff
    80004ec4:	c56080e7          	jalr	-938(ra) # 80003b16 <end_op>
    return -1;
    80004ec8:	57fd                	li	a5,-1
    80004eca:	64f2                	ld	s1,280(sp)
    80004ecc:	a8a9                	j	80004f26 <sys_link+0x148>
    iunlockput(ip);
    80004ece:	8526                	mv	a0,s1
    80004ed0:	ffffe097          	auipc	ra,0xffffe
    80004ed4:	464080e7          	jalr	1124(ra) # 80003334 <iunlockput>
    end_op();
    80004ed8:	fffff097          	auipc	ra,0xfffff
    80004edc:	c3e080e7          	jalr	-962(ra) # 80003b16 <end_op>
    return -1;
    80004ee0:	57fd                	li	a5,-1
    80004ee2:	64f2                	ld	s1,280(sp)
    80004ee4:	a089                	j	80004f26 <sys_link+0x148>
    iunlockput(dp);
    80004ee6:	854a                	mv	a0,s2
    80004ee8:	ffffe097          	auipc	ra,0xffffe
    80004eec:	44c080e7          	jalr	1100(ra) # 80003334 <iunlockput>
  ilock(ip);
    80004ef0:	8526                	mv	a0,s1
    80004ef2:	ffffe097          	auipc	ra,0xffffe
    80004ef6:	1dc080e7          	jalr	476(ra) # 800030ce <ilock>
  ip->nlink--;
    80004efa:	04a4d783          	lhu	a5,74(s1)
    80004efe:	37fd                	addiw	a5,a5,-1
    80004f00:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004f04:	8526                	mv	a0,s1
    80004f06:	ffffe097          	auipc	ra,0xffffe
    80004f0a:	0fc080e7          	jalr	252(ra) # 80003002 <iupdate>
  iunlockput(ip);
    80004f0e:	8526                	mv	a0,s1
    80004f10:	ffffe097          	auipc	ra,0xffffe
    80004f14:	424080e7          	jalr	1060(ra) # 80003334 <iunlockput>
  end_op();
    80004f18:	fffff097          	auipc	ra,0xfffff
    80004f1c:	bfe080e7          	jalr	-1026(ra) # 80003b16 <end_op>
  return -1;
    80004f20:	57fd                	li	a5,-1
    80004f22:	64f2                	ld	s1,280(sp)
    80004f24:	6952                	ld	s2,272(sp)
}
    80004f26:	853e                	mv	a0,a5
    80004f28:	70b2                	ld	ra,296(sp)
    80004f2a:	7412                	ld	s0,288(sp)
    80004f2c:	6155                	addi	sp,sp,304
    80004f2e:	8082                	ret

0000000080004f30 <sys_unlink>:
{
    80004f30:	7151                	addi	sp,sp,-240
    80004f32:	f586                	sd	ra,232(sp)
    80004f34:	f1a2                	sd	s0,224(sp)
    80004f36:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004f38:	08000613          	li	a2,128
    80004f3c:	f3040593          	addi	a1,s0,-208
    80004f40:	4501                	li	a0,0
    80004f42:	ffffd097          	auipc	ra,0xffffd
    80004f46:	5e0080e7          	jalr	1504(ra) # 80002522 <argstr>
    80004f4a:	1a054a63          	bltz	a0,800050fe <sys_unlink+0x1ce>
    80004f4e:	eda6                	sd	s1,216(sp)
  begin_op();
    80004f50:	fffff097          	auipc	ra,0xfffff
    80004f54:	b4c080e7          	jalr	-1204(ra) # 80003a9c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004f58:	fb040593          	addi	a1,s0,-80
    80004f5c:	f3040513          	addi	a0,s0,-208
    80004f60:	fffff097          	auipc	ra,0xfffff
    80004f64:	95a080e7          	jalr	-1702(ra) # 800038ba <nameiparent>
    80004f68:	84aa                	mv	s1,a0
    80004f6a:	cd71                	beqz	a0,80005046 <sys_unlink+0x116>
  ilock(dp);
    80004f6c:	ffffe097          	auipc	ra,0xffffe
    80004f70:	162080e7          	jalr	354(ra) # 800030ce <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004f74:	00003597          	auipc	a1,0x3
    80004f78:	79c58593          	addi	a1,a1,1948 # 80008710 <etext+0x710>
    80004f7c:	fb040513          	addi	a0,s0,-80
    80004f80:	ffffe097          	auipc	ra,0xffffe
    80004f84:	640080e7          	jalr	1600(ra) # 800035c0 <namecmp>
    80004f88:	14050c63          	beqz	a0,800050e0 <sys_unlink+0x1b0>
    80004f8c:	00003597          	auipc	a1,0x3
    80004f90:	78c58593          	addi	a1,a1,1932 # 80008718 <etext+0x718>
    80004f94:	fb040513          	addi	a0,s0,-80
    80004f98:	ffffe097          	auipc	ra,0xffffe
    80004f9c:	628080e7          	jalr	1576(ra) # 800035c0 <namecmp>
    80004fa0:	14050063          	beqz	a0,800050e0 <sys_unlink+0x1b0>
    80004fa4:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004fa6:	f2c40613          	addi	a2,s0,-212
    80004faa:	fb040593          	addi	a1,s0,-80
    80004fae:	8526                	mv	a0,s1
    80004fb0:	ffffe097          	auipc	ra,0xffffe
    80004fb4:	62a080e7          	jalr	1578(ra) # 800035da <dirlookup>
    80004fb8:	892a                	mv	s2,a0
    80004fba:	12050263          	beqz	a0,800050de <sys_unlink+0x1ae>
  ilock(ip);
    80004fbe:	ffffe097          	auipc	ra,0xffffe
    80004fc2:	110080e7          	jalr	272(ra) # 800030ce <ilock>
  if(ip->nlink < 1)
    80004fc6:	04a91783          	lh	a5,74(s2)
    80004fca:	08f05563          	blez	a5,80005054 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004fce:	04491703          	lh	a4,68(s2)
    80004fd2:	4785                	li	a5,1
    80004fd4:	08f70963          	beq	a4,a5,80005066 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004fd8:	4641                	li	a2,16
    80004fda:	4581                	li	a1,0
    80004fdc:	fc040513          	addi	a0,s0,-64
    80004fe0:	ffffb097          	auipc	ra,0xffffb
    80004fe4:	3e4080e7          	jalr	996(ra) # 800003c4 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004fe8:	4741                	li	a4,16
    80004fea:	f2c42683          	lw	a3,-212(s0)
    80004fee:	fc040613          	addi	a2,s0,-64
    80004ff2:	4581                	li	a1,0
    80004ff4:	8526                	mv	a0,s1
    80004ff6:	ffffe097          	auipc	ra,0xffffe
    80004ffa:	4a0080e7          	jalr	1184(ra) # 80003496 <writei>
    80004ffe:	47c1                	li	a5,16
    80005000:	0af51b63          	bne	a0,a5,800050b6 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80005004:	04491703          	lh	a4,68(s2)
    80005008:	4785                	li	a5,1
    8000500a:	0af70f63          	beq	a4,a5,800050c8 <sys_unlink+0x198>
  iunlockput(dp);
    8000500e:	8526                	mv	a0,s1
    80005010:	ffffe097          	auipc	ra,0xffffe
    80005014:	324080e7          	jalr	804(ra) # 80003334 <iunlockput>
  ip->nlink--;
    80005018:	04a95783          	lhu	a5,74(s2)
    8000501c:	37fd                	addiw	a5,a5,-1
    8000501e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005022:	854a                	mv	a0,s2
    80005024:	ffffe097          	auipc	ra,0xffffe
    80005028:	fde080e7          	jalr	-34(ra) # 80003002 <iupdate>
  iunlockput(ip);
    8000502c:	854a                	mv	a0,s2
    8000502e:	ffffe097          	auipc	ra,0xffffe
    80005032:	306080e7          	jalr	774(ra) # 80003334 <iunlockput>
  end_op();
    80005036:	fffff097          	auipc	ra,0xfffff
    8000503a:	ae0080e7          	jalr	-1312(ra) # 80003b16 <end_op>
  return 0;
    8000503e:	4501                	li	a0,0
    80005040:	64ee                	ld	s1,216(sp)
    80005042:	694e                	ld	s2,208(sp)
    80005044:	a84d                	j	800050f6 <sys_unlink+0x1c6>
    end_op();
    80005046:	fffff097          	auipc	ra,0xfffff
    8000504a:	ad0080e7          	jalr	-1328(ra) # 80003b16 <end_op>
    return -1;
    8000504e:	557d                	li	a0,-1
    80005050:	64ee                	ld	s1,216(sp)
    80005052:	a055                	j	800050f6 <sys_unlink+0x1c6>
    80005054:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005056:	00003517          	auipc	a0,0x3
    8000505a:	6ca50513          	addi	a0,a0,1738 # 80008720 <etext+0x720>
    8000505e:	00001097          	auipc	ra,0x1
    80005062:	244080e7          	jalr	580(ra) # 800062a2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005066:	04c92703          	lw	a4,76(s2)
    8000506a:	02000793          	li	a5,32
    8000506e:	f6e7f5e3          	bgeu	a5,a4,80004fd8 <sys_unlink+0xa8>
    80005072:	e5ce                	sd	s3,200(sp)
    80005074:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005078:	4741                	li	a4,16
    8000507a:	86ce                	mv	a3,s3
    8000507c:	f1840613          	addi	a2,s0,-232
    80005080:	4581                	li	a1,0
    80005082:	854a                	mv	a0,s2
    80005084:	ffffe097          	auipc	ra,0xffffe
    80005088:	302080e7          	jalr	770(ra) # 80003386 <readi>
    8000508c:	47c1                	li	a5,16
    8000508e:	00f51c63          	bne	a0,a5,800050a6 <sys_unlink+0x176>
    if(de.inum != 0)
    80005092:	f1845783          	lhu	a5,-232(s0)
    80005096:	e7b5                	bnez	a5,80005102 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005098:	29c1                	addiw	s3,s3,16
    8000509a:	04c92783          	lw	a5,76(s2)
    8000509e:	fcf9ede3          	bltu	s3,a5,80005078 <sys_unlink+0x148>
    800050a2:	69ae                	ld	s3,200(sp)
    800050a4:	bf15                	j	80004fd8 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    800050a6:	00003517          	auipc	a0,0x3
    800050aa:	69250513          	addi	a0,a0,1682 # 80008738 <etext+0x738>
    800050ae:	00001097          	auipc	ra,0x1
    800050b2:	1f4080e7          	jalr	500(ra) # 800062a2 <panic>
    800050b6:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800050b8:	00003517          	auipc	a0,0x3
    800050bc:	69850513          	addi	a0,a0,1688 # 80008750 <etext+0x750>
    800050c0:	00001097          	auipc	ra,0x1
    800050c4:	1e2080e7          	jalr	482(ra) # 800062a2 <panic>
    dp->nlink--;
    800050c8:	04a4d783          	lhu	a5,74(s1)
    800050cc:	37fd                	addiw	a5,a5,-1
    800050ce:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800050d2:	8526                	mv	a0,s1
    800050d4:	ffffe097          	auipc	ra,0xffffe
    800050d8:	f2e080e7          	jalr	-210(ra) # 80003002 <iupdate>
    800050dc:	bf0d                	j	8000500e <sys_unlink+0xde>
    800050de:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800050e0:	8526                	mv	a0,s1
    800050e2:	ffffe097          	auipc	ra,0xffffe
    800050e6:	252080e7          	jalr	594(ra) # 80003334 <iunlockput>
  end_op();
    800050ea:	fffff097          	auipc	ra,0xfffff
    800050ee:	a2c080e7          	jalr	-1492(ra) # 80003b16 <end_op>
  return -1;
    800050f2:	557d                	li	a0,-1
    800050f4:	64ee                	ld	s1,216(sp)
}
    800050f6:	70ae                	ld	ra,232(sp)
    800050f8:	740e                	ld	s0,224(sp)
    800050fa:	616d                	addi	sp,sp,240
    800050fc:	8082                	ret
    return -1;
    800050fe:	557d                	li	a0,-1
    80005100:	bfdd                	j	800050f6 <sys_unlink+0x1c6>
    iunlockput(ip);
    80005102:	854a                	mv	a0,s2
    80005104:	ffffe097          	auipc	ra,0xffffe
    80005108:	230080e7          	jalr	560(ra) # 80003334 <iunlockput>
    goto bad;
    8000510c:	694e                	ld	s2,208(sp)
    8000510e:	69ae                	ld	s3,200(sp)
    80005110:	bfc1                	j	800050e0 <sys_unlink+0x1b0>

0000000080005112 <sys_open>:

uint64
sys_open(void)
{
    80005112:	7131                	addi	sp,sp,-192
    80005114:	fd06                	sd	ra,184(sp)
    80005116:	f922                	sd	s0,176(sp)
    80005118:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000511a:	f4c40593          	addi	a1,s0,-180
    8000511e:	4505                	li	a0,1
    80005120:	ffffd097          	auipc	ra,0xffffd
    80005124:	3c2080e7          	jalr	962(ra) # 800024e2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005128:	08000613          	li	a2,128
    8000512c:	f5040593          	addi	a1,s0,-176
    80005130:	4501                	li	a0,0
    80005132:	ffffd097          	auipc	ra,0xffffd
    80005136:	3f0080e7          	jalr	1008(ra) # 80002522 <argstr>
    8000513a:	87aa                	mv	a5,a0
    return -1;
    8000513c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000513e:	0a07ce63          	bltz	a5,800051fa <sys_open+0xe8>
    80005142:	f526                	sd	s1,168(sp)

  begin_op();
    80005144:	fffff097          	auipc	ra,0xfffff
    80005148:	958080e7          	jalr	-1704(ra) # 80003a9c <begin_op>

  if(omode & O_CREATE){
    8000514c:	f4c42783          	lw	a5,-180(s0)
    80005150:	2007f793          	andi	a5,a5,512
    80005154:	cfd5                	beqz	a5,80005210 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005156:	4681                	li	a3,0
    80005158:	4601                	li	a2,0
    8000515a:	4589                	li	a1,2
    8000515c:	f5040513          	addi	a0,s0,-176
    80005160:	00000097          	auipc	ra,0x0
    80005164:	95c080e7          	jalr	-1700(ra) # 80004abc <create>
    80005168:	84aa                	mv	s1,a0
    if(ip == 0){
    8000516a:	cd41                	beqz	a0,80005202 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000516c:	04449703          	lh	a4,68(s1)
    80005170:	478d                	li	a5,3
    80005172:	00f71763          	bne	a4,a5,80005180 <sys_open+0x6e>
    80005176:	0464d703          	lhu	a4,70(s1)
    8000517a:	47a5                	li	a5,9
    8000517c:	0ee7e163          	bltu	a5,a4,8000525e <sys_open+0x14c>
    80005180:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005182:	fffff097          	auipc	ra,0xfffff
    80005186:	d28080e7          	jalr	-728(ra) # 80003eaa <filealloc>
    8000518a:	892a                	mv	s2,a0
    8000518c:	c97d                	beqz	a0,80005282 <sys_open+0x170>
    8000518e:	ed4e                	sd	s3,152(sp)
    80005190:	00000097          	auipc	ra,0x0
    80005194:	8ea080e7          	jalr	-1814(ra) # 80004a7a <fdalloc>
    80005198:	89aa                	mv	s3,a0
    8000519a:	0c054e63          	bltz	a0,80005276 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000519e:	04449703          	lh	a4,68(s1)
    800051a2:	478d                	li	a5,3
    800051a4:	0ef70c63          	beq	a4,a5,8000529c <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800051a8:	4789                	li	a5,2
    800051aa:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800051ae:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800051b2:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800051b6:	f4c42783          	lw	a5,-180(s0)
    800051ba:	0017c713          	xori	a4,a5,1
    800051be:	8b05                	andi	a4,a4,1
    800051c0:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800051c4:	0037f713          	andi	a4,a5,3
    800051c8:	00e03733          	snez	a4,a4
    800051cc:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800051d0:	4007f793          	andi	a5,a5,1024
    800051d4:	c791                	beqz	a5,800051e0 <sys_open+0xce>
    800051d6:	04449703          	lh	a4,68(s1)
    800051da:	4789                	li	a5,2
    800051dc:	0cf70763          	beq	a4,a5,800052aa <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    800051e0:	8526                	mv	a0,s1
    800051e2:	ffffe097          	auipc	ra,0xffffe
    800051e6:	fb2080e7          	jalr	-78(ra) # 80003194 <iunlock>
  end_op();
    800051ea:	fffff097          	auipc	ra,0xfffff
    800051ee:	92c080e7          	jalr	-1748(ra) # 80003b16 <end_op>

  return fd;
    800051f2:	854e                	mv	a0,s3
    800051f4:	74aa                	ld	s1,168(sp)
    800051f6:	790a                	ld	s2,160(sp)
    800051f8:	69ea                	ld	s3,152(sp)
}
    800051fa:	70ea                	ld	ra,184(sp)
    800051fc:	744a                	ld	s0,176(sp)
    800051fe:	6129                	addi	sp,sp,192
    80005200:	8082                	ret
      end_op();
    80005202:	fffff097          	auipc	ra,0xfffff
    80005206:	914080e7          	jalr	-1772(ra) # 80003b16 <end_op>
      return -1;
    8000520a:	557d                	li	a0,-1
    8000520c:	74aa                	ld	s1,168(sp)
    8000520e:	b7f5                	j	800051fa <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80005210:	f5040513          	addi	a0,s0,-176
    80005214:	ffffe097          	auipc	ra,0xffffe
    80005218:	688080e7          	jalr	1672(ra) # 8000389c <namei>
    8000521c:	84aa                	mv	s1,a0
    8000521e:	c90d                	beqz	a0,80005250 <sys_open+0x13e>
    ilock(ip);
    80005220:	ffffe097          	auipc	ra,0xffffe
    80005224:	eae080e7          	jalr	-338(ra) # 800030ce <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005228:	04449703          	lh	a4,68(s1)
    8000522c:	4785                	li	a5,1
    8000522e:	f2f71fe3          	bne	a4,a5,8000516c <sys_open+0x5a>
    80005232:	f4c42783          	lw	a5,-180(s0)
    80005236:	d7a9                	beqz	a5,80005180 <sys_open+0x6e>
      iunlockput(ip);
    80005238:	8526                	mv	a0,s1
    8000523a:	ffffe097          	auipc	ra,0xffffe
    8000523e:	0fa080e7          	jalr	250(ra) # 80003334 <iunlockput>
      end_op();
    80005242:	fffff097          	auipc	ra,0xfffff
    80005246:	8d4080e7          	jalr	-1836(ra) # 80003b16 <end_op>
      return -1;
    8000524a:	557d                	li	a0,-1
    8000524c:	74aa                	ld	s1,168(sp)
    8000524e:	b775                	j	800051fa <sys_open+0xe8>
      end_op();
    80005250:	fffff097          	auipc	ra,0xfffff
    80005254:	8c6080e7          	jalr	-1850(ra) # 80003b16 <end_op>
      return -1;
    80005258:	557d                	li	a0,-1
    8000525a:	74aa                	ld	s1,168(sp)
    8000525c:	bf79                	j	800051fa <sys_open+0xe8>
    iunlockput(ip);
    8000525e:	8526                	mv	a0,s1
    80005260:	ffffe097          	auipc	ra,0xffffe
    80005264:	0d4080e7          	jalr	212(ra) # 80003334 <iunlockput>
    end_op();
    80005268:	fffff097          	auipc	ra,0xfffff
    8000526c:	8ae080e7          	jalr	-1874(ra) # 80003b16 <end_op>
    return -1;
    80005270:	557d                	li	a0,-1
    80005272:	74aa                	ld	s1,168(sp)
    80005274:	b759                	j	800051fa <sys_open+0xe8>
      fileclose(f);
    80005276:	854a                	mv	a0,s2
    80005278:	fffff097          	auipc	ra,0xfffff
    8000527c:	cee080e7          	jalr	-786(ra) # 80003f66 <fileclose>
    80005280:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005282:	8526                	mv	a0,s1
    80005284:	ffffe097          	auipc	ra,0xffffe
    80005288:	0b0080e7          	jalr	176(ra) # 80003334 <iunlockput>
    end_op();
    8000528c:	fffff097          	auipc	ra,0xfffff
    80005290:	88a080e7          	jalr	-1910(ra) # 80003b16 <end_op>
    return -1;
    80005294:	557d                	li	a0,-1
    80005296:	74aa                	ld	s1,168(sp)
    80005298:	790a                	ld	s2,160(sp)
    8000529a:	b785                	j	800051fa <sys_open+0xe8>
    f->type = FD_DEVICE;
    8000529c:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800052a0:	04649783          	lh	a5,70(s1)
    800052a4:	02f91223          	sh	a5,36(s2)
    800052a8:	b729                	j	800051b2 <sys_open+0xa0>
    itrunc(ip);
    800052aa:	8526                	mv	a0,s1
    800052ac:	ffffe097          	auipc	ra,0xffffe
    800052b0:	f34080e7          	jalr	-204(ra) # 800031e0 <itrunc>
    800052b4:	b735                	j	800051e0 <sys_open+0xce>

00000000800052b6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800052b6:	7175                	addi	sp,sp,-144
    800052b8:	e506                	sd	ra,136(sp)
    800052ba:	e122                	sd	s0,128(sp)
    800052bc:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800052be:	ffffe097          	auipc	ra,0xffffe
    800052c2:	7de080e7          	jalr	2014(ra) # 80003a9c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800052c6:	08000613          	li	a2,128
    800052ca:	f7040593          	addi	a1,s0,-144
    800052ce:	4501                	li	a0,0
    800052d0:	ffffd097          	auipc	ra,0xffffd
    800052d4:	252080e7          	jalr	594(ra) # 80002522 <argstr>
    800052d8:	02054963          	bltz	a0,8000530a <sys_mkdir+0x54>
    800052dc:	4681                	li	a3,0
    800052de:	4601                	li	a2,0
    800052e0:	4585                	li	a1,1
    800052e2:	f7040513          	addi	a0,s0,-144
    800052e6:	fffff097          	auipc	ra,0xfffff
    800052ea:	7d6080e7          	jalr	2006(ra) # 80004abc <create>
    800052ee:	cd11                	beqz	a0,8000530a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800052f0:	ffffe097          	auipc	ra,0xffffe
    800052f4:	044080e7          	jalr	68(ra) # 80003334 <iunlockput>
  end_op();
    800052f8:	fffff097          	auipc	ra,0xfffff
    800052fc:	81e080e7          	jalr	-2018(ra) # 80003b16 <end_op>
  return 0;
    80005300:	4501                	li	a0,0
}
    80005302:	60aa                	ld	ra,136(sp)
    80005304:	640a                	ld	s0,128(sp)
    80005306:	6149                	addi	sp,sp,144
    80005308:	8082                	ret
    end_op();
    8000530a:	fffff097          	auipc	ra,0xfffff
    8000530e:	80c080e7          	jalr	-2036(ra) # 80003b16 <end_op>
    return -1;
    80005312:	557d                	li	a0,-1
    80005314:	b7fd                	j	80005302 <sys_mkdir+0x4c>

0000000080005316 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005316:	7135                	addi	sp,sp,-160
    80005318:	ed06                	sd	ra,152(sp)
    8000531a:	e922                	sd	s0,144(sp)
    8000531c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000531e:	ffffe097          	auipc	ra,0xffffe
    80005322:	77e080e7          	jalr	1918(ra) # 80003a9c <begin_op>
  argint(1, &major);
    80005326:	f6c40593          	addi	a1,s0,-148
    8000532a:	4505                	li	a0,1
    8000532c:	ffffd097          	auipc	ra,0xffffd
    80005330:	1b6080e7          	jalr	438(ra) # 800024e2 <argint>
  argint(2, &minor);
    80005334:	f6840593          	addi	a1,s0,-152
    80005338:	4509                	li	a0,2
    8000533a:	ffffd097          	auipc	ra,0xffffd
    8000533e:	1a8080e7          	jalr	424(ra) # 800024e2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005342:	08000613          	li	a2,128
    80005346:	f7040593          	addi	a1,s0,-144
    8000534a:	4501                	li	a0,0
    8000534c:	ffffd097          	auipc	ra,0xffffd
    80005350:	1d6080e7          	jalr	470(ra) # 80002522 <argstr>
    80005354:	02054b63          	bltz	a0,8000538a <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005358:	f6841683          	lh	a3,-152(s0)
    8000535c:	f6c41603          	lh	a2,-148(s0)
    80005360:	458d                	li	a1,3
    80005362:	f7040513          	addi	a0,s0,-144
    80005366:	fffff097          	auipc	ra,0xfffff
    8000536a:	756080e7          	jalr	1878(ra) # 80004abc <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000536e:	cd11                	beqz	a0,8000538a <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005370:	ffffe097          	auipc	ra,0xffffe
    80005374:	fc4080e7          	jalr	-60(ra) # 80003334 <iunlockput>
  end_op();
    80005378:	ffffe097          	auipc	ra,0xffffe
    8000537c:	79e080e7          	jalr	1950(ra) # 80003b16 <end_op>
  return 0;
    80005380:	4501                	li	a0,0
}
    80005382:	60ea                	ld	ra,152(sp)
    80005384:	644a                	ld	s0,144(sp)
    80005386:	610d                	addi	sp,sp,160
    80005388:	8082                	ret
    end_op();
    8000538a:	ffffe097          	auipc	ra,0xffffe
    8000538e:	78c080e7          	jalr	1932(ra) # 80003b16 <end_op>
    return -1;
    80005392:	557d                	li	a0,-1
    80005394:	b7fd                	j	80005382 <sys_mknod+0x6c>

0000000080005396 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005396:	7135                	addi	sp,sp,-160
    80005398:	ed06                	sd	ra,152(sp)
    8000539a:	e922                	sd	s0,144(sp)
    8000539c:	e14a                	sd	s2,128(sp)
    8000539e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800053a0:	ffffc097          	auipc	ra,0xffffc
    800053a4:	f1a080e7          	jalr	-230(ra) # 800012ba <myproc>
    800053a8:	892a                	mv	s2,a0
  
  begin_op();
    800053aa:	ffffe097          	auipc	ra,0xffffe
    800053ae:	6f2080e7          	jalr	1778(ra) # 80003a9c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800053b2:	08000613          	li	a2,128
    800053b6:	f6040593          	addi	a1,s0,-160
    800053ba:	4501                	li	a0,0
    800053bc:	ffffd097          	auipc	ra,0xffffd
    800053c0:	166080e7          	jalr	358(ra) # 80002522 <argstr>
    800053c4:	04054d63          	bltz	a0,8000541e <sys_chdir+0x88>
    800053c8:	e526                	sd	s1,136(sp)
    800053ca:	f6040513          	addi	a0,s0,-160
    800053ce:	ffffe097          	auipc	ra,0xffffe
    800053d2:	4ce080e7          	jalr	1230(ra) # 8000389c <namei>
    800053d6:	84aa                	mv	s1,a0
    800053d8:	c131                	beqz	a0,8000541c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800053da:	ffffe097          	auipc	ra,0xffffe
    800053de:	cf4080e7          	jalr	-780(ra) # 800030ce <ilock>
  if(ip->type != T_DIR){
    800053e2:	04449703          	lh	a4,68(s1)
    800053e6:	4785                	li	a5,1
    800053e8:	04f71163          	bne	a4,a5,8000542a <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800053ec:	8526                	mv	a0,s1
    800053ee:	ffffe097          	auipc	ra,0xffffe
    800053f2:	da6080e7          	jalr	-602(ra) # 80003194 <iunlock>
  iput(p->cwd);
    800053f6:	15093503          	ld	a0,336(s2)
    800053fa:	ffffe097          	auipc	ra,0xffffe
    800053fe:	e92080e7          	jalr	-366(ra) # 8000328c <iput>
  end_op();
    80005402:	ffffe097          	auipc	ra,0xffffe
    80005406:	714080e7          	jalr	1812(ra) # 80003b16 <end_op>
  p->cwd = ip;
    8000540a:	14993823          	sd	s1,336(s2)
  return 0;
    8000540e:	4501                	li	a0,0
    80005410:	64aa                	ld	s1,136(sp)
}
    80005412:	60ea                	ld	ra,152(sp)
    80005414:	644a                	ld	s0,144(sp)
    80005416:	690a                	ld	s2,128(sp)
    80005418:	610d                	addi	sp,sp,160
    8000541a:	8082                	ret
    8000541c:	64aa                	ld	s1,136(sp)
    end_op();
    8000541e:	ffffe097          	auipc	ra,0xffffe
    80005422:	6f8080e7          	jalr	1784(ra) # 80003b16 <end_op>
    return -1;
    80005426:	557d                	li	a0,-1
    80005428:	b7ed                	j	80005412 <sys_chdir+0x7c>
    iunlockput(ip);
    8000542a:	8526                	mv	a0,s1
    8000542c:	ffffe097          	auipc	ra,0xffffe
    80005430:	f08080e7          	jalr	-248(ra) # 80003334 <iunlockput>
    end_op();
    80005434:	ffffe097          	auipc	ra,0xffffe
    80005438:	6e2080e7          	jalr	1762(ra) # 80003b16 <end_op>
    return -1;
    8000543c:	557d                	li	a0,-1
    8000543e:	64aa                	ld	s1,136(sp)
    80005440:	bfc9                	j	80005412 <sys_chdir+0x7c>

0000000080005442 <sys_exec>:

uint64
sys_exec(void)
{
    80005442:	7121                	addi	sp,sp,-448
    80005444:	ff06                	sd	ra,440(sp)
    80005446:	fb22                	sd	s0,432(sp)
    80005448:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000544a:	e4840593          	addi	a1,s0,-440
    8000544e:	4505                	li	a0,1
    80005450:	ffffd097          	auipc	ra,0xffffd
    80005454:	0b2080e7          	jalr	178(ra) # 80002502 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005458:	08000613          	li	a2,128
    8000545c:	f5040593          	addi	a1,s0,-176
    80005460:	4501                	li	a0,0
    80005462:	ffffd097          	auipc	ra,0xffffd
    80005466:	0c0080e7          	jalr	192(ra) # 80002522 <argstr>
    8000546a:	87aa                	mv	a5,a0
    return -1;
    8000546c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000546e:	0e07c263          	bltz	a5,80005552 <sys_exec+0x110>
    80005472:	f726                	sd	s1,424(sp)
    80005474:	f34a                	sd	s2,416(sp)
    80005476:	ef4e                	sd	s3,408(sp)
    80005478:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000547a:	10000613          	li	a2,256
    8000547e:	4581                	li	a1,0
    80005480:	e5040513          	addi	a0,s0,-432
    80005484:	ffffb097          	auipc	ra,0xffffb
    80005488:	f40080e7          	jalr	-192(ra) # 800003c4 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000548c:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005490:	89a6                	mv	s3,s1
    80005492:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005494:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005498:	00391513          	slli	a0,s2,0x3
    8000549c:	e4040593          	addi	a1,s0,-448
    800054a0:	e4843783          	ld	a5,-440(s0)
    800054a4:	953e                	add	a0,a0,a5
    800054a6:	ffffd097          	auipc	ra,0xffffd
    800054aa:	f9e080e7          	jalr	-98(ra) # 80002444 <fetchaddr>
    800054ae:	02054a63          	bltz	a0,800054e2 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    800054b2:	e4043783          	ld	a5,-448(s0)
    800054b6:	c7b9                	beqz	a5,80005504 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800054b8:	ffffb097          	auipc	ra,0xffffb
    800054bc:	d86080e7          	jalr	-634(ra) # 8000023e <kalloc>
    800054c0:	85aa                	mv	a1,a0
    800054c2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800054c6:	cd11                	beqz	a0,800054e2 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800054c8:	6605                	lui	a2,0x1
    800054ca:	e4043503          	ld	a0,-448(s0)
    800054ce:	ffffd097          	auipc	ra,0xffffd
    800054d2:	fc8080e7          	jalr	-56(ra) # 80002496 <fetchstr>
    800054d6:	00054663          	bltz	a0,800054e2 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    800054da:	0905                	addi	s2,s2,1
    800054dc:	09a1                	addi	s3,s3,8
    800054de:	fb491de3          	bne	s2,s4,80005498 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800054e2:	f5040913          	addi	s2,s0,-176
    800054e6:	6088                	ld	a0,0(s1)
    800054e8:	c125                	beqz	a0,80005548 <sys_exec+0x106>
    kfree(argv[i]);
    800054ea:	ffffb097          	auipc	ra,0xffffb
    800054ee:	b32080e7          	jalr	-1230(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800054f2:	04a1                	addi	s1,s1,8
    800054f4:	ff2499e3          	bne	s1,s2,800054e6 <sys_exec+0xa4>
  return -1;
    800054f8:	557d                	li	a0,-1
    800054fa:	74ba                	ld	s1,424(sp)
    800054fc:	791a                	ld	s2,416(sp)
    800054fe:	69fa                	ld	s3,408(sp)
    80005500:	6a5a                	ld	s4,400(sp)
    80005502:	a881                	j	80005552 <sys_exec+0x110>
      argv[i] = 0;
    80005504:	0009079b          	sext.w	a5,s2
    80005508:	078e                	slli	a5,a5,0x3
    8000550a:	fd078793          	addi	a5,a5,-48
    8000550e:	97a2                	add	a5,a5,s0
    80005510:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005514:	e5040593          	addi	a1,s0,-432
    80005518:	f5040513          	addi	a0,s0,-176
    8000551c:	fffff097          	auipc	ra,0xfffff
    80005520:	120080e7          	jalr	288(ra) # 8000463c <exec>
    80005524:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005526:	f5040993          	addi	s3,s0,-176
    8000552a:	6088                	ld	a0,0(s1)
    8000552c:	c901                	beqz	a0,8000553c <sys_exec+0xfa>
    kfree(argv[i]);
    8000552e:	ffffb097          	auipc	ra,0xffffb
    80005532:	aee080e7          	jalr	-1298(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005536:	04a1                	addi	s1,s1,8
    80005538:	ff3499e3          	bne	s1,s3,8000552a <sys_exec+0xe8>
  return ret;
    8000553c:	854a                	mv	a0,s2
    8000553e:	74ba                	ld	s1,424(sp)
    80005540:	791a                	ld	s2,416(sp)
    80005542:	69fa                	ld	s3,408(sp)
    80005544:	6a5a                	ld	s4,400(sp)
    80005546:	a031                	j	80005552 <sys_exec+0x110>
  return -1;
    80005548:	557d                	li	a0,-1
    8000554a:	74ba                	ld	s1,424(sp)
    8000554c:	791a                	ld	s2,416(sp)
    8000554e:	69fa                	ld	s3,408(sp)
    80005550:	6a5a                	ld	s4,400(sp)
}
    80005552:	70fa                	ld	ra,440(sp)
    80005554:	745a                	ld	s0,432(sp)
    80005556:	6139                	addi	sp,sp,448
    80005558:	8082                	ret

000000008000555a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000555a:	7139                	addi	sp,sp,-64
    8000555c:	fc06                	sd	ra,56(sp)
    8000555e:	f822                	sd	s0,48(sp)
    80005560:	f426                	sd	s1,40(sp)
    80005562:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005564:	ffffc097          	auipc	ra,0xffffc
    80005568:	d56080e7          	jalr	-682(ra) # 800012ba <myproc>
    8000556c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000556e:	fd840593          	addi	a1,s0,-40
    80005572:	4501                	li	a0,0
    80005574:	ffffd097          	auipc	ra,0xffffd
    80005578:	f8e080e7          	jalr	-114(ra) # 80002502 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000557c:	fc840593          	addi	a1,s0,-56
    80005580:	fd040513          	addi	a0,s0,-48
    80005584:	fffff097          	auipc	ra,0xfffff
    80005588:	d50080e7          	jalr	-688(ra) # 800042d4 <pipealloc>
    return -1;
    8000558c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000558e:	0c054463          	bltz	a0,80005656 <sys_pipe+0xfc>
  fd0 = -1;
    80005592:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005596:	fd043503          	ld	a0,-48(s0)
    8000559a:	fffff097          	auipc	ra,0xfffff
    8000559e:	4e0080e7          	jalr	1248(ra) # 80004a7a <fdalloc>
    800055a2:	fca42223          	sw	a0,-60(s0)
    800055a6:	08054b63          	bltz	a0,8000563c <sys_pipe+0xe2>
    800055aa:	fc843503          	ld	a0,-56(s0)
    800055ae:	fffff097          	auipc	ra,0xfffff
    800055b2:	4cc080e7          	jalr	1228(ra) # 80004a7a <fdalloc>
    800055b6:	fca42023          	sw	a0,-64(s0)
    800055ba:	06054863          	bltz	a0,8000562a <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800055be:	4691                	li	a3,4
    800055c0:	fc440613          	addi	a2,s0,-60
    800055c4:	fd843583          	ld	a1,-40(s0)
    800055c8:	68a8                	ld	a0,80(s1)
    800055ca:	ffffc097          	auipc	ra,0xffffc
    800055ce:	8b6080e7          	jalr	-1866(ra) # 80000e80 <copyout>
    800055d2:	02054063          	bltz	a0,800055f2 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800055d6:	4691                	li	a3,4
    800055d8:	fc040613          	addi	a2,s0,-64
    800055dc:	fd843583          	ld	a1,-40(s0)
    800055e0:	0591                	addi	a1,a1,4
    800055e2:	68a8                	ld	a0,80(s1)
    800055e4:	ffffc097          	auipc	ra,0xffffc
    800055e8:	89c080e7          	jalr	-1892(ra) # 80000e80 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800055ec:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800055ee:	06055463          	bgez	a0,80005656 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800055f2:	fc442783          	lw	a5,-60(s0)
    800055f6:	07e9                	addi	a5,a5,26
    800055f8:	078e                	slli	a5,a5,0x3
    800055fa:	97a6                	add	a5,a5,s1
    800055fc:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005600:	fc042783          	lw	a5,-64(s0)
    80005604:	07e9                	addi	a5,a5,26
    80005606:	078e                	slli	a5,a5,0x3
    80005608:	94be                	add	s1,s1,a5
    8000560a:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000560e:	fd043503          	ld	a0,-48(s0)
    80005612:	fffff097          	auipc	ra,0xfffff
    80005616:	954080e7          	jalr	-1708(ra) # 80003f66 <fileclose>
    fileclose(wf);
    8000561a:	fc843503          	ld	a0,-56(s0)
    8000561e:	fffff097          	auipc	ra,0xfffff
    80005622:	948080e7          	jalr	-1720(ra) # 80003f66 <fileclose>
    return -1;
    80005626:	57fd                	li	a5,-1
    80005628:	a03d                	j	80005656 <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000562a:	fc442783          	lw	a5,-60(s0)
    8000562e:	0007c763          	bltz	a5,8000563c <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005632:	07e9                	addi	a5,a5,26
    80005634:	078e                	slli	a5,a5,0x3
    80005636:	97a6                	add	a5,a5,s1
    80005638:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000563c:	fd043503          	ld	a0,-48(s0)
    80005640:	fffff097          	auipc	ra,0xfffff
    80005644:	926080e7          	jalr	-1754(ra) # 80003f66 <fileclose>
    fileclose(wf);
    80005648:	fc843503          	ld	a0,-56(s0)
    8000564c:	fffff097          	auipc	ra,0xfffff
    80005650:	91a080e7          	jalr	-1766(ra) # 80003f66 <fileclose>
    return -1;
    80005654:	57fd                	li	a5,-1
}
    80005656:	853e                	mv	a0,a5
    80005658:	70e2                	ld	ra,56(sp)
    8000565a:	7442                	ld	s0,48(sp)
    8000565c:	74a2                	ld	s1,40(sp)
    8000565e:	6121                	addi	sp,sp,64
    80005660:	8082                	ret
	...

0000000080005670 <kernelvec>:
    80005670:	7111                	addi	sp,sp,-256
    80005672:	e006                	sd	ra,0(sp)
    80005674:	e40a                	sd	sp,8(sp)
    80005676:	e80e                	sd	gp,16(sp)
    80005678:	ec12                	sd	tp,24(sp)
    8000567a:	f016                	sd	t0,32(sp)
    8000567c:	f41a                	sd	t1,40(sp)
    8000567e:	f81e                	sd	t2,48(sp)
    80005680:	fc22                	sd	s0,56(sp)
    80005682:	e0a6                	sd	s1,64(sp)
    80005684:	e4aa                	sd	a0,72(sp)
    80005686:	e8ae                	sd	a1,80(sp)
    80005688:	ecb2                	sd	a2,88(sp)
    8000568a:	f0b6                	sd	a3,96(sp)
    8000568c:	f4ba                	sd	a4,104(sp)
    8000568e:	f8be                	sd	a5,112(sp)
    80005690:	fcc2                	sd	a6,120(sp)
    80005692:	e146                	sd	a7,128(sp)
    80005694:	e54a                	sd	s2,136(sp)
    80005696:	e94e                	sd	s3,144(sp)
    80005698:	ed52                	sd	s4,152(sp)
    8000569a:	f156                	sd	s5,160(sp)
    8000569c:	f55a                	sd	s6,168(sp)
    8000569e:	f95e                	sd	s7,176(sp)
    800056a0:	fd62                	sd	s8,184(sp)
    800056a2:	e1e6                	sd	s9,192(sp)
    800056a4:	e5ea                	sd	s10,200(sp)
    800056a6:	e9ee                	sd	s11,208(sp)
    800056a8:	edf2                	sd	t3,216(sp)
    800056aa:	f1f6                	sd	t4,224(sp)
    800056ac:	f5fa                	sd	t5,232(sp)
    800056ae:	f9fe                	sd	t6,240(sp)
    800056b0:	c61fc0ef          	jal	80002310 <kerneltrap>
    800056b4:	6082                	ld	ra,0(sp)
    800056b6:	6122                	ld	sp,8(sp)
    800056b8:	61c2                	ld	gp,16(sp)
    800056ba:	7282                	ld	t0,32(sp)
    800056bc:	7322                	ld	t1,40(sp)
    800056be:	73c2                	ld	t2,48(sp)
    800056c0:	7462                	ld	s0,56(sp)
    800056c2:	6486                	ld	s1,64(sp)
    800056c4:	6526                	ld	a0,72(sp)
    800056c6:	65c6                	ld	a1,80(sp)
    800056c8:	6666                	ld	a2,88(sp)
    800056ca:	7686                	ld	a3,96(sp)
    800056cc:	7726                	ld	a4,104(sp)
    800056ce:	77c6                	ld	a5,112(sp)
    800056d0:	7866                	ld	a6,120(sp)
    800056d2:	688a                	ld	a7,128(sp)
    800056d4:	692a                	ld	s2,136(sp)
    800056d6:	69ca                	ld	s3,144(sp)
    800056d8:	6a6a                	ld	s4,152(sp)
    800056da:	7a8a                	ld	s5,160(sp)
    800056dc:	7b2a                	ld	s6,168(sp)
    800056de:	7bca                	ld	s7,176(sp)
    800056e0:	7c6a                	ld	s8,184(sp)
    800056e2:	6c8e                	ld	s9,192(sp)
    800056e4:	6d2e                	ld	s10,200(sp)
    800056e6:	6dce                	ld	s11,208(sp)
    800056e8:	6e6e                	ld	t3,216(sp)
    800056ea:	7e8e                	ld	t4,224(sp)
    800056ec:	7f2e                	ld	t5,232(sp)
    800056ee:	7fce                	ld	t6,240(sp)
    800056f0:	6111                	addi	sp,sp,256
    800056f2:	10200073          	sret
    800056f6:	00000013          	nop
    800056fa:	00000013          	nop
    800056fe:	0001                	nop

0000000080005700 <timervec>:
    80005700:	34051573          	csrrw	a0,mscratch,a0
    80005704:	e10c                	sd	a1,0(a0)
    80005706:	e510                	sd	a2,8(a0)
    80005708:	e914                	sd	a3,16(a0)
    8000570a:	6d0c                	ld	a1,24(a0)
    8000570c:	7110                	ld	a2,32(a0)
    8000570e:	6194                	ld	a3,0(a1)
    80005710:	96b2                	add	a3,a3,a2
    80005712:	e194                	sd	a3,0(a1)
    80005714:	4589                	li	a1,2
    80005716:	14459073          	csrw	sip,a1
    8000571a:	6914                	ld	a3,16(a0)
    8000571c:	6510                	ld	a2,8(a0)
    8000571e:	610c                	ld	a1,0(a0)
    80005720:	34051573          	csrrw	a0,mscratch,a0
    80005724:	30200073          	mret
	...

000000008000572a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000572a:	1141                	addi	sp,sp,-16
    8000572c:	e422                	sd	s0,8(sp)
    8000572e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005730:	0c0007b7          	lui	a5,0xc000
    80005734:	4705                	li	a4,1
    80005736:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005738:	0c0007b7          	lui	a5,0xc000
    8000573c:	c3d8                	sw	a4,4(a5)
}
    8000573e:	6422                	ld	s0,8(sp)
    80005740:	0141                	addi	sp,sp,16
    80005742:	8082                	ret

0000000080005744 <plicinithart>:

void
plicinithart(void)
{
    80005744:	1141                	addi	sp,sp,-16
    80005746:	e406                	sd	ra,8(sp)
    80005748:	e022                	sd	s0,0(sp)
    8000574a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000574c:	ffffc097          	auipc	ra,0xffffc
    80005750:	b42080e7          	jalr	-1214(ra) # 8000128e <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005754:	0085171b          	slliw	a4,a0,0x8
    80005758:	0c0027b7          	lui	a5,0xc002
    8000575c:	97ba                	add	a5,a5,a4
    8000575e:	40200713          	li	a4,1026
    80005762:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005766:	00d5151b          	slliw	a0,a0,0xd
    8000576a:	0c2017b7          	lui	a5,0xc201
    8000576e:	97aa                	add	a5,a5,a0
    80005770:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005774:	60a2                	ld	ra,8(sp)
    80005776:	6402                	ld	s0,0(sp)
    80005778:	0141                	addi	sp,sp,16
    8000577a:	8082                	ret

000000008000577c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000577c:	1141                	addi	sp,sp,-16
    8000577e:	e406                	sd	ra,8(sp)
    80005780:	e022                	sd	s0,0(sp)
    80005782:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005784:	ffffc097          	auipc	ra,0xffffc
    80005788:	b0a080e7          	jalr	-1270(ra) # 8000128e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000578c:	00d5151b          	slliw	a0,a0,0xd
    80005790:	0c2017b7          	lui	a5,0xc201
    80005794:	97aa                	add	a5,a5,a0
  return irq;
}
    80005796:	43c8                	lw	a0,4(a5)
    80005798:	60a2                	ld	ra,8(sp)
    8000579a:	6402                	ld	s0,0(sp)
    8000579c:	0141                	addi	sp,sp,16
    8000579e:	8082                	ret

00000000800057a0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800057a0:	1101                	addi	sp,sp,-32
    800057a2:	ec06                	sd	ra,24(sp)
    800057a4:	e822                	sd	s0,16(sp)
    800057a6:	e426                	sd	s1,8(sp)
    800057a8:	1000                	addi	s0,sp,32
    800057aa:	84aa                	mv	s1,a0
  int hart = cpuid();
    800057ac:	ffffc097          	auipc	ra,0xffffc
    800057b0:	ae2080e7          	jalr	-1310(ra) # 8000128e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800057b4:	00d5151b          	slliw	a0,a0,0xd
    800057b8:	0c2017b7          	lui	a5,0xc201
    800057bc:	97aa                	add	a5,a5,a0
    800057be:	c3c4                	sw	s1,4(a5)
}
    800057c0:	60e2                	ld	ra,24(sp)
    800057c2:	6442                	ld	s0,16(sp)
    800057c4:	64a2                	ld	s1,8(sp)
    800057c6:	6105                	addi	sp,sp,32
    800057c8:	8082                	ret

00000000800057ca <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800057ca:	1141                	addi	sp,sp,-16
    800057cc:	e406                	sd	ra,8(sp)
    800057ce:	e022                	sd	s0,0(sp)
    800057d0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800057d2:	479d                	li	a5,7
    800057d4:	04a7cc63          	blt	a5,a0,8000582c <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800057d8:	00037797          	auipc	a5,0x37
    800057dc:	e4078793          	addi	a5,a5,-448 # 8003c618 <disk>
    800057e0:	97aa                	add	a5,a5,a0
    800057e2:	0187c783          	lbu	a5,24(a5)
    800057e6:	ebb9                	bnez	a5,8000583c <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800057e8:	00451693          	slli	a3,a0,0x4
    800057ec:	00037797          	auipc	a5,0x37
    800057f0:	e2c78793          	addi	a5,a5,-468 # 8003c618 <disk>
    800057f4:	6398                	ld	a4,0(a5)
    800057f6:	9736                	add	a4,a4,a3
    800057f8:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800057fc:	6398                	ld	a4,0(a5)
    800057fe:	9736                	add	a4,a4,a3
    80005800:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005804:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005808:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000580c:	97aa                	add	a5,a5,a0
    8000580e:	4705                	li	a4,1
    80005810:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005814:	00037517          	auipc	a0,0x37
    80005818:	e1c50513          	addi	a0,a0,-484 # 8003c630 <disk+0x18>
    8000581c:	ffffc097          	auipc	ra,0xffffc
    80005820:	1b0080e7          	jalr	432(ra) # 800019cc <wakeup>
}
    80005824:	60a2                	ld	ra,8(sp)
    80005826:	6402                	ld	s0,0(sp)
    80005828:	0141                	addi	sp,sp,16
    8000582a:	8082                	ret
    panic("free_desc 1");
    8000582c:	00003517          	auipc	a0,0x3
    80005830:	f3450513          	addi	a0,a0,-204 # 80008760 <etext+0x760>
    80005834:	00001097          	auipc	ra,0x1
    80005838:	a6e080e7          	jalr	-1426(ra) # 800062a2 <panic>
    panic("free_desc 2");
    8000583c:	00003517          	auipc	a0,0x3
    80005840:	f3450513          	addi	a0,a0,-204 # 80008770 <etext+0x770>
    80005844:	00001097          	auipc	ra,0x1
    80005848:	a5e080e7          	jalr	-1442(ra) # 800062a2 <panic>

000000008000584c <virtio_disk_init>:
{
    8000584c:	1101                	addi	sp,sp,-32
    8000584e:	ec06                	sd	ra,24(sp)
    80005850:	e822                	sd	s0,16(sp)
    80005852:	e426                	sd	s1,8(sp)
    80005854:	e04a                	sd	s2,0(sp)
    80005856:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005858:	00003597          	auipc	a1,0x3
    8000585c:	f2858593          	addi	a1,a1,-216 # 80008780 <etext+0x780>
    80005860:	00037517          	auipc	a0,0x37
    80005864:	ee050513          	addi	a0,a0,-288 # 8003c740 <disk+0x128>
    80005868:	00001097          	auipc	ra,0x1
    8000586c:	f24080e7          	jalr	-220(ra) # 8000678c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005870:	100017b7          	lui	a5,0x10001
    80005874:	4398                	lw	a4,0(a5)
    80005876:	2701                	sext.w	a4,a4
    80005878:	747277b7          	lui	a5,0x74727
    8000587c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005880:	18f71c63          	bne	a4,a5,80005a18 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005884:	100017b7          	lui	a5,0x10001
    80005888:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000588a:	439c                	lw	a5,0(a5)
    8000588c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000588e:	4709                	li	a4,2
    80005890:	18e79463          	bne	a5,a4,80005a18 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005894:	100017b7          	lui	a5,0x10001
    80005898:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000589a:	439c                	lw	a5,0(a5)
    8000589c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000589e:	16e79d63          	bne	a5,a4,80005a18 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800058a2:	100017b7          	lui	a5,0x10001
    800058a6:	47d8                	lw	a4,12(a5)
    800058a8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800058aa:	554d47b7          	lui	a5,0x554d4
    800058ae:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800058b2:	16f71363          	bne	a4,a5,80005a18 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    800058b6:	100017b7          	lui	a5,0x10001
    800058ba:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800058be:	4705                	li	a4,1
    800058c0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800058c2:	470d                	li	a4,3
    800058c4:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800058c6:	10001737          	lui	a4,0x10001
    800058ca:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800058cc:	c7ffe737          	lui	a4,0xc7ffe
    800058d0:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fb9dbf>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800058d4:	8ef9                	and	a3,a3,a4
    800058d6:	10001737          	lui	a4,0x10001
    800058da:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800058dc:	472d                	li	a4,11
    800058de:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800058e0:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800058e4:	439c                	lw	a5,0(a5)
    800058e6:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800058ea:	8ba1                	andi	a5,a5,8
    800058ec:	12078e63          	beqz	a5,80005a28 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800058f0:	100017b7          	lui	a5,0x10001
    800058f4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800058f8:	100017b7          	lui	a5,0x10001
    800058fc:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005900:	439c                	lw	a5,0(a5)
    80005902:	2781                	sext.w	a5,a5
    80005904:	12079a63          	bnez	a5,80005a38 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005908:	100017b7          	lui	a5,0x10001
    8000590c:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005910:	439c                	lw	a5,0(a5)
    80005912:	2781                	sext.w	a5,a5
  if(max == 0)
    80005914:	12078a63          	beqz	a5,80005a48 <virtio_disk_init+0x1fc>
  if(max < NUM)
    80005918:	471d                	li	a4,7
    8000591a:	12f77f63          	bgeu	a4,a5,80005a58 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    8000591e:	ffffb097          	auipc	ra,0xffffb
    80005922:	920080e7          	jalr	-1760(ra) # 8000023e <kalloc>
    80005926:	00037497          	auipc	s1,0x37
    8000592a:	cf248493          	addi	s1,s1,-782 # 8003c618 <disk>
    8000592e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005930:	ffffb097          	auipc	ra,0xffffb
    80005934:	90e080e7          	jalr	-1778(ra) # 8000023e <kalloc>
    80005938:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000593a:	ffffb097          	auipc	ra,0xffffb
    8000593e:	904080e7          	jalr	-1788(ra) # 8000023e <kalloc>
    80005942:	87aa                	mv	a5,a0
    80005944:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005946:	6088                	ld	a0,0(s1)
    80005948:	12050063          	beqz	a0,80005a68 <virtio_disk_init+0x21c>
    8000594c:	00037717          	auipc	a4,0x37
    80005950:	cd473703          	ld	a4,-812(a4) # 8003c620 <disk+0x8>
    80005954:	10070a63          	beqz	a4,80005a68 <virtio_disk_init+0x21c>
    80005958:	10078863          	beqz	a5,80005a68 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    8000595c:	6605                	lui	a2,0x1
    8000595e:	4581                	li	a1,0
    80005960:	ffffb097          	auipc	ra,0xffffb
    80005964:	a64080e7          	jalr	-1436(ra) # 800003c4 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005968:	00037497          	auipc	s1,0x37
    8000596c:	cb048493          	addi	s1,s1,-848 # 8003c618 <disk>
    80005970:	6605                	lui	a2,0x1
    80005972:	4581                	li	a1,0
    80005974:	6488                	ld	a0,8(s1)
    80005976:	ffffb097          	auipc	ra,0xffffb
    8000597a:	a4e080e7          	jalr	-1458(ra) # 800003c4 <memset>
  memset(disk.used, 0, PGSIZE);
    8000597e:	6605                	lui	a2,0x1
    80005980:	4581                	li	a1,0
    80005982:	6888                	ld	a0,16(s1)
    80005984:	ffffb097          	auipc	ra,0xffffb
    80005988:	a40080e7          	jalr	-1472(ra) # 800003c4 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000598c:	100017b7          	lui	a5,0x10001
    80005990:	4721                	li	a4,8
    80005992:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005994:	4098                	lw	a4,0(s1)
    80005996:	100017b7          	lui	a5,0x10001
    8000599a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000599e:	40d8                	lw	a4,4(s1)
    800059a0:	100017b7          	lui	a5,0x10001
    800059a4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800059a8:	649c                	ld	a5,8(s1)
    800059aa:	0007869b          	sext.w	a3,a5
    800059ae:	10001737          	lui	a4,0x10001
    800059b2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800059b6:	9781                	srai	a5,a5,0x20
    800059b8:	10001737          	lui	a4,0x10001
    800059bc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800059c0:	689c                	ld	a5,16(s1)
    800059c2:	0007869b          	sext.w	a3,a5
    800059c6:	10001737          	lui	a4,0x10001
    800059ca:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800059ce:	9781                	srai	a5,a5,0x20
    800059d0:	10001737          	lui	a4,0x10001
    800059d4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800059d8:	10001737          	lui	a4,0x10001
    800059dc:	4785                	li	a5,1
    800059de:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800059e0:	00f48c23          	sb	a5,24(s1)
    800059e4:	00f48ca3          	sb	a5,25(s1)
    800059e8:	00f48d23          	sb	a5,26(s1)
    800059ec:	00f48da3          	sb	a5,27(s1)
    800059f0:	00f48e23          	sb	a5,28(s1)
    800059f4:	00f48ea3          	sb	a5,29(s1)
    800059f8:	00f48f23          	sb	a5,30(s1)
    800059fc:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005a00:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a04:	100017b7          	lui	a5,0x10001
    80005a08:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80005a0c:	60e2                	ld	ra,24(sp)
    80005a0e:	6442                	ld	s0,16(sp)
    80005a10:	64a2                	ld	s1,8(sp)
    80005a12:	6902                	ld	s2,0(sp)
    80005a14:	6105                	addi	sp,sp,32
    80005a16:	8082                	ret
    panic("could not find virtio disk");
    80005a18:	00003517          	auipc	a0,0x3
    80005a1c:	d7850513          	addi	a0,a0,-648 # 80008790 <etext+0x790>
    80005a20:	00001097          	auipc	ra,0x1
    80005a24:	882080e7          	jalr	-1918(ra) # 800062a2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005a28:	00003517          	auipc	a0,0x3
    80005a2c:	d8850513          	addi	a0,a0,-632 # 800087b0 <etext+0x7b0>
    80005a30:	00001097          	auipc	ra,0x1
    80005a34:	872080e7          	jalr	-1934(ra) # 800062a2 <panic>
    panic("virtio disk should not be ready");
    80005a38:	00003517          	auipc	a0,0x3
    80005a3c:	d9850513          	addi	a0,a0,-616 # 800087d0 <etext+0x7d0>
    80005a40:	00001097          	auipc	ra,0x1
    80005a44:	862080e7          	jalr	-1950(ra) # 800062a2 <panic>
    panic("virtio disk has no queue 0");
    80005a48:	00003517          	auipc	a0,0x3
    80005a4c:	da850513          	addi	a0,a0,-600 # 800087f0 <etext+0x7f0>
    80005a50:	00001097          	auipc	ra,0x1
    80005a54:	852080e7          	jalr	-1966(ra) # 800062a2 <panic>
    panic("virtio disk max queue too short");
    80005a58:	00003517          	auipc	a0,0x3
    80005a5c:	db850513          	addi	a0,a0,-584 # 80008810 <etext+0x810>
    80005a60:	00001097          	auipc	ra,0x1
    80005a64:	842080e7          	jalr	-1982(ra) # 800062a2 <panic>
    panic("virtio disk kalloc");
    80005a68:	00003517          	auipc	a0,0x3
    80005a6c:	dc850513          	addi	a0,a0,-568 # 80008830 <etext+0x830>
    80005a70:	00001097          	auipc	ra,0x1
    80005a74:	832080e7          	jalr	-1998(ra) # 800062a2 <panic>

0000000080005a78 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005a78:	7159                	addi	sp,sp,-112
    80005a7a:	f486                	sd	ra,104(sp)
    80005a7c:	f0a2                	sd	s0,96(sp)
    80005a7e:	eca6                	sd	s1,88(sp)
    80005a80:	e8ca                	sd	s2,80(sp)
    80005a82:	e4ce                	sd	s3,72(sp)
    80005a84:	e0d2                	sd	s4,64(sp)
    80005a86:	fc56                	sd	s5,56(sp)
    80005a88:	f85a                	sd	s6,48(sp)
    80005a8a:	f45e                	sd	s7,40(sp)
    80005a8c:	f062                	sd	s8,32(sp)
    80005a8e:	ec66                	sd	s9,24(sp)
    80005a90:	1880                	addi	s0,sp,112
    80005a92:	8a2a                	mv	s4,a0
    80005a94:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005a96:	00c52c83          	lw	s9,12(a0)
    80005a9a:	001c9c9b          	slliw	s9,s9,0x1
    80005a9e:	1c82                	slli	s9,s9,0x20
    80005aa0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005aa4:	00037517          	auipc	a0,0x37
    80005aa8:	c9c50513          	addi	a0,a0,-868 # 8003c740 <disk+0x128>
    80005aac:	00001097          	auipc	ra,0x1
    80005ab0:	d70080e7          	jalr	-656(ra) # 8000681c <acquire>
  for(int i = 0; i < 3; i++){
    80005ab4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005ab6:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005ab8:	00037b17          	auipc	s6,0x37
    80005abc:	b60b0b13          	addi	s6,s6,-1184 # 8003c618 <disk>
  for(int i = 0; i < 3; i++){
    80005ac0:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005ac2:	00037c17          	auipc	s8,0x37
    80005ac6:	c7ec0c13          	addi	s8,s8,-898 # 8003c740 <disk+0x128>
    80005aca:	a0ad                	j	80005b34 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    80005acc:	00fb0733          	add	a4,s6,a5
    80005ad0:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005ad4:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005ad6:	0207c563          	bltz	a5,80005b00 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005ada:	2905                	addiw	s2,s2,1
    80005adc:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005ade:	05590f63          	beq	s2,s5,80005b3c <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80005ae2:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005ae4:	00037717          	auipc	a4,0x37
    80005ae8:	b3470713          	addi	a4,a4,-1228 # 8003c618 <disk>
    80005aec:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005aee:	01874683          	lbu	a3,24(a4)
    80005af2:	fee9                	bnez	a3,80005acc <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80005af4:	2785                	addiw	a5,a5,1
    80005af6:	0705                	addi	a4,a4,1
    80005af8:	fe979be3          	bne	a5,s1,80005aee <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005afc:	57fd                	li	a5,-1
    80005afe:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005b00:	03205163          	blez	s2,80005b22 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80005b04:	f9042503          	lw	a0,-112(s0)
    80005b08:	00000097          	auipc	ra,0x0
    80005b0c:	cc2080e7          	jalr	-830(ra) # 800057ca <free_desc>
      for(int j = 0; j < i; j++)
    80005b10:	4785                	li	a5,1
    80005b12:	0127d863          	bge	a5,s2,80005b22 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80005b16:	f9442503          	lw	a0,-108(s0)
    80005b1a:	00000097          	auipc	ra,0x0
    80005b1e:	cb0080e7          	jalr	-848(ra) # 800057ca <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005b22:	85e2                	mv	a1,s8
    80005b24:	00037517          	auipc	a0,0x37
    80005b28:	b0c50513          	addi	a0,a0,-1268 # 8003c630 <disk+0x18>
    80005b2c:	ffffc097          	auipc	ra,0xffffc
    80005b30:	e3c080e7          	jalr	-452(ra) # 80001968 <sleep>
  for(int i = 0; i < 3; i++){
    80005b34:	f9040613          	addi	a2,s0,-112
    80005b38:	894e                	mv	s2,s3
    80005b3a:	b765                	j	80005ae2 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005b3c:	f9042503          	lw	a0,-112(s0)
    80005b40:	00451693          	slli	a3,a0,0x4

  if(write)
    80005b44:	00037797          	auipc	a5,0x37
    80005b48:	ad478793          	addi	a5,a5,-1324 # 8003c618 <disk>
    80005b4c:	00a50713          	addi	a4,a0,10
    80005b50:	0712                	slli	a4,a4,0x4
    80005b52:	973e                	add	a4,a4,a5
    80005b54:	01703633          	snez	a2,s7
    80005b58:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005b5a:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005b5e:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005b62:	6398                	ld	a4,0(a5)
    80005b64:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005b66:	0a868613          	addi	a2,a3,168
    80005b6a:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005b6c:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005b6e:	6390                	ld	a2,0(a5)
    80005b70:	00d605b3          	add	a1,a2,a3
    80005b74:	4741                	li	a4,16
    80005b76:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005b78:	4805                	li	a6,1
    80005b7a:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005b7e:	f9442703          	lw	a4,-108(s0)
    80005b82:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005b86:	0712                	slli	a4,a4,0x4
    80005b88:	963a                	add	a2,a2,a4
    80005b8a:	058a0593          	addi	a1,s4,88
    80005b8e:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005b90:	0007b883          	ld	a7,0(a5)
    80005b94:	9746                	add	a4,a4,a7
    80005b96:	40000613          	li	a2,1024
    80005b9a:	c710                	sw	a2,8(a4)
  if(write)
    80005b9c:	001bb613          	seqz	a2,s7
    80005ba0:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005ba4:	00166613          	ori	a2,a2,1
    80005ba8:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005bac:	f9842583          	lw	a1,-104(s0)
    80005bb0:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005bb4:	00250613          	addi	a2,a0,2
    80005bb8:	0612                	slli	a2,a2,0x4
    80005bba:	963e                	add	a2,a2,a5
    80005bbc:	577d                	li	a4,-1
    80005bbe:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005bc2:	0592                	slli	a1,a1,0x4
    80005bc4:	98ae                	add	a7,a7,a1
    80005bc6:	03068713          	addi	a4,a3,48
    80005bca:	973e                	add	a4,a4,a5
    80005bcc:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005bd0:	6398                	ld	a4,0(a5)
    80005bd2:	972e                	add	a4,a4,a1
    80005bd4:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005bd8:	4689                	li	a3,2
    80005bda:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005bde:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005be2:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005be6:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005bea:	6794                	ld	a3,8(a5)
    80005bec:	0026d703          	lhu	a4,2(a3)
    80005bf0:	8b1d                	andi	a4,a4,7
    80005bf2:	0706                	slli	a4,a4,0x1
    80005bf4:	96ba                	add	a3,a3,a4
    80005bf6:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005bfa:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005bfe:	6798                	ld	a4,8(a5)
    80005c00:	00275783          	lhu	a5,2(a4)
    80005c04:	2785                	addiw	a5,a5,1
    80005c06:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005c0a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005c0e:	100017b7          	lui	a5,0x10001
    80005c12:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005c16:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005c1a:	00037917          	auipc	s2,0x37
    80005c1e:	b2690913          	addi	s2,s2,-1242 # 8003c740 <disk+0x128>
  while(b->disk == 1) {
    80005c22:	4485                	li	s1,1
    80005c24:	01079c63          	bne	a5,a6,80005c3c <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005c28:	85ca                	mv	a1,s2
    80005c2a:	8552                	mv	a0,s4
    80005c2c:	ffffc097          	auipc	ra,0xffffc
    80005c30:	d3c080e7          	jalr	-708(ra) # 80001968 <sleep>
  while(b->disk == 1) {
    80005c34:	004a2783          	lw	a5,4(s4)
    80005c38:	fe9788e3          	beq	a5,s1,80005c28 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005c3c:	f9042903          	lw	s2,-112(s0)
    80005c40:	00290713          	addi	a4,s2,2
    80005c44:	0712                	slli	a4,a4,0x4
    80005c46:	00037797          	auipc	a5,0x37
    80005c4a:	9d278793          	addi	a5,a5,-1582 # 8003c618 <disk>
    80005c4e:	97ba                	add	a5,a5,a4
    80005c50:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005c54:	00037997          	auipc	s3,0x37
    80005c58:	9c498993          	addi	s3,s3,-1596 # 8003c618 <disk>
    80005c5c:	00491713          	slli	a4,s2,0x4
    80005c60:	0009b783          	ld	a5,0(s3)
    80005c64:	97ba                	add	a5,a5,a4
    80005c66:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005c6a:	854a                	mv	a0,s2
    80005c6c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005c70:	00000097          	auipc	ra,0x0
    80005c74:	b5a080e7          	jalr	-1190(ra) # 800057ca <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005c78:	8885                	andi	s1,s1,1
    80005c7a:	f0ed                	bnez	s1,80005c5c <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005c7c:	00037517          	auipc	a0,0x37
    80005c80:	ac450513          	addi	a0,a0,-1340 # 8003c740 <disk+0x128>
    80005c84:	00001097          	auipc	ra,0x1
    80005c88:	c4c080e7          	jalr	-948(ra) # 800068d0 <release>
}
    80005c8c:	70a6                	ld	ra,104(sp)
    80005c8e:	7406                	ld	s0,96(sp)
    80005c90:	64e6                	ld	s1,88(sp)
    80005c92:	6946                	ld	s2,80(sp)
    80005c94:	69a6                	ld	s3,72(sp)
    80005c96:	6a06                	ld	s4,64(sp)
    80005c98:	7ae2                	ld	s5,56(sp)
    80005c9a:	7b42                	ld	s6,48(sp)
    80005c9c:	7ba2                	ld	s7,40(sp)
    80005c9e:	7c02                	ld	s8,32(sp)
    80005ca0:	6ce2                	ld	s9,24(sp)
    80005ca2:	6165                	addi	sp,sp,112
    80005ca4:	8082                	ret

0000000080005ca6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005ca6:	1101                	addi	sp,sp,-32
    80005ca8:	ec06                	sd	ra,24(sp)
    80005caa:	e822                	sd	s0,16(sp)
    80005cac:	e426                	sd	s1,8(sp)
    80005cae:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005cb0:	00037497          	auipc	s1,0x37
    80005cb4:	96848493          	addi	s1,s1,-1688 # 8003c618 <disk>
    80005cb8:	00037517          	auipc	a0,0x37
    80005cbc:	a8850513          	addi	a0,a0,-1400 # 8003c740 <disk+0x128>
    80005cc0:	00001097          	auipc	ra,0x1
    80005cc4:	b5c080e7          	jalr	-1188(ra) # 8000681c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005cc8:	100017b7          	lui	a5,0x10001
    80005ccc:	53b8                	lw	a4,96(a5)
    80005cce:	8b0d                	andi	a4,a4,3
    80005cd0:	100017b7          	lui	a5,0x10001
    80005cd4:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005cd6:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005cda:	689c                	ld	a5,16(s1)
    80005cdc:	0204d703          	lhu	a4,32(s1)
    80005ce0:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005ce4:	04f70863          	beq	a4,a5,80005d34 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80005ce8:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005cec:	6898                	ld	a4,16(s1)
    80005cee:	0204d783          	lhu	a5,32(s1)
    80005cf2:	8b9d                	andi	a5,a5,7
    80005cf4:	078e                	slli	a5,a5,0x3
    80005cf6:	97ba                	add	a5,a5,a4
    80005cf8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005cfa:	00278713          	addi	a4,a5,2
    80005cfe:	0712                	slli	a4,a4,0x4
    80005d00:	9726                	add	a4,a4,s1
    80005d02:	01074703          	lbu	a4,16(a4)
    80005d06:	e721                	bnez	a4,80005d4e <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005d08:	0789                	addi	a5,a5,2
    80005d0a:	0792                	slli	a5,a5,0x4
    80005d0c:	97a6                	add	a5,a5,s1
    80005d0e:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005d10:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005d14:	ffffc097          	auipc	ra,0xffffc
    80005d18:	cb8080e7          	jalr	-840(ra) # 800019cc <wakeup>

    disk.used_idx += 1;
    80005d1c:	0204d783          	lhu	a5,32(s1)
    80005d20:	2785                	addiw	a5,a5,1
    80005d22:	17c2                	slli	a5,a5,0x30
    80005d24:	93c1                	srli	a5,a5,0x30
    80005d26:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005d2a:	6898                	ld	a4,16(s1)
    80005d2c:	00275703          	lhu	a4,2(a4)
    80005d30:	faf71ce3          	bne	a4,a5,80005ce8 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80005d34:	00037517          	auipc	a0,0x37
    80005d38:	a0c50513          	addi	a0,a0,-1524 # 8003c740 <disk+0x128>
    80005d3c:	00001097          	auipc	ra,0x1
    80005d40:	b94080e7          	jalr	-1132(ra) # 800068d0 <release>
}
    80005d44:	60e2                	ld	ra,24(sp)
    80005d46:	6442                	ld	s0,16(sp)
    80005d48:	64a2                	ld	s1,8(sp)
    80005d4a:	6105                	addi	sp,sp,32
    80005d4c:	8082                	ret
      panic("virtio_disk_intr status");
    80005d4e:	00003517          	auipc	a0,0x3
    80005d52:	afa50513          	addi	a0,a0,-1286 # 80008848 <etext+0x848>
    80005d56:	00000097          	auipc	ra,0x0
    80005d5a:	54c080e7          	jalr	1356(ra) # 800062a2 <panic>

0000000080005d5e <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005d5e:	1141                	addi	sp,sp,-16
    80005d60:	e422                	sd	s0,8(sp)
    80005d62:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005d64:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005d68:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005d6c:	0037979b          	slliw	a5,a5,0x3
    80005d70:	02004737          	lui	a4,0x2004
    80005d74:	97ba                	add	a5,a5,a4
    80005d76:	0200c737          	lui	a4,0x200c
    80005d7a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    80005d7c:	6318                	ld	a4,0(a4)
    80005d7e:	000f4637          	lui	a2,0xf4
    80005d82:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005d86:	9732                	add	a4,a4,a2
    80005d88:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005d8a:	00259693          	slli	a3,a1,0x2
    80005d8e:	96ae                	add	a3,a3,a1
    80005d90:	068e                	slli	a3,a3,0x3
    80005d92:	00037717          	auipc	a4,0x37
    80005d96:	9ce70713          	addi	a4,a4,-1586 # 8003c760 <timer_scratch>
    80005d9a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005d9c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005d9e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005da0:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005da4:	00000797          	auipc	a5,0x0
    80005da8:	95c78793          	addi	a5,a5,-1700 # 80005700 <timervec>
    80005dac:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005db0:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005db4:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005db8:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005dbc:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005dc0:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005dc4:	30479073          	csrw	mie,a5
}
    80005dc8:	6422                	ld	s0,8(sp)
    80005dca:	0141                	addi	sp,sp,16
    80005dcc:	8082                	ret

0000000080005dce <start>:
{
    80005dce:	1141                	addi	sp,sp,-16
    80005dd0:	e406                	sd	ra,8(sp)
    80005dd2:	e022                	sd	s0,0(sp)
    80005dd4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005dd6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005dda:	7779                	lui	a4,0xffffe
    80005ddc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffb9e5f>
    80005de0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005de2:	6705                	lui	a4,0x1
    80005de4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005de8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005dea:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005dee:	ffffa797          	auipc	a5,0xffffa
    80005df2:	77478793          	addi	a5,a5,1908 # 80000562 <main>
    80005df6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005dfa:	4781                	li	a5,0
    80005dfc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005e00:	67c1                	lui	a5,0x10
    80005e02:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005e04:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005e08:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005e0c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005e10:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005e14:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005e18:	57fd                	li	a5,-1
    80005e1a:	83a9                	srli	a5,a5,0xa
    80005e1c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005e20:	47bd                	li	a5,15
    80005e22:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005e26:	00000097          	auipc	ra,0x0
    80005e2a:	f38080e7          	jalr	-200(ra) # 80005d5e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005e2e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005e32:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005e34:	823e                	mv	tp,a5
  asm volatile("mret");
    80005e36:	30200073          	mret
}
    80005e3a:	60a2                	ld	ra,8(sp)
    80005e3c:	6402                	ld	s0,0(sp)
    80005e3e:	0141                	addi	sp,sp,16
    80005e40:	8082                	ret

0000000080005e42 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005e42:	715d                	addi	sp,sp,-80
    80005e44:	e486                	sd	ra,72(sp)
    80005e46:	e0a2                	sd	s0,64(sp)
    80005e48:	f84a                	sd	s2,48(sp)
    80005e4a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005e4c:	04c05663          	blez	a2,80005e98 <consolewrite+0x56>
    80005e50:	fc26                	sd	s1,56(sp)
    80005e52:	f44e                	sd	s3,40(sp)
    80005e54:	f052                	sd	s4,32(sp)
    80005e56:	ec56                	sd	s5,24(sp)
    80005e58:	8a2a                	mv	s4,a0
    80005e5a:	84ae                	mv	s1,a1
    80005e5c:	89b2                	mv	s3,a2
    80005e5e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005e60:	5afd                	li	s5,-1
    80005e62:	4685                	li	a3,1
    80005e64:	8626                	mv	a2,s1
    80005e66:	85d2                	mv	a1,s4
    80005e68:	fbf40513          	addi	a0,s0,-65
    80005e6c:	ffffc097          	auipc	ra,0xffffc
    80005e70:	f5a080e7          	jalr	-166(ra) # 80001dc6 <either_copyin>
    80005e74:	03550463          	beq	a0,s5,80005e9c <consolewrite+0x5a>
      break;
    uartputc(c);
    80005e78:	fbf44503          	lbu	a0,-65(s0)
    80005e7c:	00000097          	auipc	ra,0x0
    80005e80:	7e4080e7          	jalr	2020(ra) # 80006660 <uartputc>
  for(i = 0; i < n; i++){
    80005e84:	2905                	addiw	s2,s2,1
    80005e86:	0485                	addi	s1,s1,1
    80005e88:	fd299de3          	bne	s3,s2,80005e62 <consolewrite+0x20>
    80005e8c:	894e                	mv	s2,s3
    80005e8e:	74e2                	ld	s1,56(sp)
    80005e90:	79a2                	ld	s3,40(sp)
    80005e92:	7a02                	ld	s4,32(sp)
    80005e94:	6ae2                	ld	s5,24(sp)
    80005e96:	a039                	j	80005ea4 <consolewrite+0x62>
    80005e98:	4901                	li	s2,0
    80005e9a:	a029                	j	80005ea4 <consolewrite+0x62>
    80005e9c:	74e2                	ld	s1,56(sp)
    80005e9e:	79a2                	ld	s3,40(sp)
    80005ea0:	7a02                	ld	s4,32(sp)
    80005ea2:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005ea4:	854a                	mv	a0,s2
    80005ea6:	60a6                	ld	ra,72(sp)
    80005ea8:	6406                	ld	s0,64(sp)
    80005eaa:	7942                	ld	s2,48(sp)
    80005eac:	6161                	addi	sp,sp,80
    80005eae:	8082                	ret

0000000080005eb0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005eb0:	711d                	addi	sp,sp,-96
    80005eb2:	ec86                	sd	ra,88(sp)
    80005eb4:	e8a2                	sd	s0,80(sp)
    80005eb6:	e4a6                	sd	s1,72(sp)
    80005eb8:	e0ca                	sd	s2,64(sp)
    80005eba:	fc4e                	sd	s3,56(sp)
    80005ebc:	f852                	sd	s4,48(sp)
    80005ebe:	f456                	sd	s5,40(sp)
    80005ec0:	f05a                	sd	s6,32(sp)
    80005ec2:	1080                	addi	s0,sp,96
    80005ec4:	8aaa                	mv	s5,a0
    80005ec6:	8a2e                	mv	s4,a1
    80005ec8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005eca:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005ece:	0003f517          	auipc	a0,0x3f
    80005ed2:	9d250513          	addi	a0,a0,-1582 # 800448a0 <cons>
    80005ed6:	00001097          	auipc	ra,0x1
    80005eda:	946080e7          	jalr	-1722(ra) # 8000681c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005ede:	0003f497          	auipc	s1,0x3f
    80005ee2:	9c248493          	addi	s1,s1,-1598 # 800448a0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005ee6:	0003f917          	auipc	s2,0x3f
    80005eea:	a5290913          	addi	s2,s2,-1454 # 80044938 <cons+0x98>
  while(n > 0){
    80005eee:	0d305763          	blez	s3,80005fbc <consoleread+0x10c>
    while(cons.r == cons.w){
    80005ef2:	0984a783          	lw	a5,152(s1)
    80005ef6:	09c4a703          	lw	a4,156(s1)
    80005efa:	0af71c63          	bne	a4,a5,80005fb2 <consoleread+0x102>
      if(killed(myproc())){
    80005efe:	ffffb097          	auipc	ra,0xffffb
    80005f02:	3bc080e7          	jalr	956(ra) # 800012ba <myproc>
    80005f06:	ffffc097          	auipc	ra,0xffffc
    80005f0a:	d0a080e7          	jalr	-758(ra) # 80001c10 <killed>
    80005f0e:	e52d                	bnez	a0,80005f78 <consoleread+0xc8>
      sleep(&cons.r, &cons.lock);
    80005f10:	85a6                	mv	a1,s1
    80005f12:	854a                	mv	a0,s2
    80005f14:	ffffc097          	auipc	ra,0xffffc
    80005f18:	a54080e7          	jalr	-1452(ra) # 80001968 <sleep>
    while(cons.r == cons.w){
    80005f1c:	0984a783          	lw	a5,152(s1)
    80005f20:	09c4a703          	lw	a4,156(s1)
    80005f24:	fcf70de3          	beq	a4,a5,80005efe <consoleread+0x4e>
    80005f28:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005f2a:	0003f717          	auipc	a4,0x3f
    80005f2e:	97670713          	addi	a4,a4,-1674 # 800448a0 <cons>
    80005f32:	0017869b          	addiw	a3,a5,1
    80005f36:	08d72c23          	sw	a3,152(a4)
    80005f3a:	07f7f693          	andi	a3,a5,127
    80005f3e:	9736                	add	a4,a4,a3
    80005f40:	01874703          	lbu	a4,24(a4)
    80005f44:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005f48:	4691                	li	a3,4
    80005f4a:	04db8a63          	beq	s7,a3,80005f9e <consoleread+0xee>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005f4e:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005f52:	4685                	li	a3,1
    80005f54:	faf40613          	addi	a2,s0,-81
    80005f58:	85d2                	mv	a1,s4
    80005f5a:	8556                	mv	a0,s5
    80005f5c:	ffffc097          	auipc	ra,0xffffc
    80005f60:	e14080e7          	jalr	-492(ra) # 80001d70 <either_copyout>
    80005f64:	57fd                	li	a5,-1
    80005f66:	04f50a63          	beq	a0,a5,80005fba <consoleread+0x10a>
      break;

    dst++;
    80005f6a:	0a05                	addi	s4,s4,1
    --n;
    80005f6c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005f6e:	47a9                	li	a5,10
    80005f70:	06fb8163          	beq	s7,a5,80005fd2 <consoleread+0x122>
    80005f74:	6be2                	ld	s7,24(sp)
    80005f76:	bfa5                	j	80005eee <consoleread+0x3e>
        release(&cons.lock);
    80005f78:	0003f517          	auipc	a0,0x3f
    80005f7c:	92850513          	addi	a0,a0,-1752 # 800448a0 <cons>
    80005f80:	00001097          	auipc	ra,0x1
    80005f84:	950080e7          	jalr	-1712(ra) # 800068d0 <release>
        return -1;
    80005f88:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005f8a:	60e6                	ld	ra,88(sp)
    80005f8c:	6446                	ld	s0,80(sp)
    80005f8e:	64a6                	ld	s1,72(sp)
    80005f90:	6906                	ld	s2,64(sp)
    80005f92:	79e2                	ld	s3,56(sp)
    80005f94:	7a42                	ld	s4,48(sp)
    80005f96:	7aa2                	ld	s5,40(sp)
    80005f98:	7b02                	ld	s6,32(sp)
    80005f9a:	6125                	addi	sp,sp,96
    80005f9c:	8082                	ret
      if(n < target){
    80005f9e:	0009871b          	sext.w	a4,s3
    80005fa2:	01677a63          	bgeu	a4,s6,80005fb6 <consoleread+0x106>
        cons.r--;
    80005fa6:	0003f717          	auipc	a4,0x3f
    80005faa:	98f72923          	sw	a5,-1646(a4) # 80044938 <cons+0x98>
    80005fae:	6be2                	ld	s7,24(sp)
    80005fb0:	a031                	j	80005fbc <consoleread+0x10c>
    80005fb2:	ec5e                	sd	s7,24(sp)
    80005fb4:	bf9d                	j	80005f2a <consoleread+0x7a>
    80005fb6:	6be2                	ld	s7,24(sp)
    80005fb8:	a011                	j	80005fbc <consoleread+0x10c>
    80005fba:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005fbc:	0003f517          	auipc	a0,0x3f
    80005fc0:	8e450513          	addi	a0,a0,-1820 # 800448a0 <cons>
    80005fc4:	00001097          	auipc	ra,0x1
    80005fc8:	90c080e7          	jalr	-1780(ra) # 800068d0 <release>
  return target - n;
    80005fcc:	413b053b          	subw	a0,s6,s3
    80005fd0:	bf6d                	j	80005f8a <consoleread+0xda>
    80005fd2:	6be2                	ld	s7,24(sp)
    80005fd4:	b7e5                	j	80005fbc <consoleread+0x10c>

0000000080005fd6 <consputc>:
{
    80005fd6:	1141                	addi	sp,sp,-16
    80005fd8:	e406                	sd	ra,8(sp)
    80005fda:	e022                	sd	s0,0(sp)
    80005fdc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005fde:	10000793          	li	a5,256
    80005fe2:	00f50a63          	beq	a0,a5,80005ff6 <consputc+0x20>
    uartputc_sync(c);
    80005fe6:	00000097          	auipc	ra,0x0
    80005fea:	59c080e7          	jalr	1436(ra) # 80006582 <uartputc_sync>
}
    80005fee:	60a2                	ld	ra,8(sp)
    80005ff0:	6402                	ld	s0,0(sp)
    80005ff2:	0141                	addi	sp,sp,16
    80005ff4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ff6:	4521                	li	a0,8
    80005ff8:	00000097          	auipc	ra,0x0
    80005ffc:	58a080e7          	jalr	1418(ra) # 80006582 <uartputc_sync>
    80006000:	02000513          	li	a0,32
    80006004:	00000097          	auipc	ra,0x0
    80006008:	57e080e7          	jalr	1406(ra) # 80006582 <uartputc_sync>
    8000600c:	4521                	li	a0,8
    8000600e:	00000097          	auipc	ra,0x0
    80006012:	574080e7          	jalr	1396(ra) # 80006582 <uartputc_sync>
    80006016:	bfe1                	j	80005fee <consputc+0x18>

0000000080006018 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80006018:	1101                	addi	sp,sp,-32
    8000601a:	ec06                	sd	ra,24(sp)
    8000601c:	e822                	sd	s0,16(sp)
    8000601e:	e426                	sd	s1,8(sp)
    80006020:	1000                	addi	s0,sp,32
    80006022:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80006024:	0003f517          	auipc	a0,0x3f
    80006028:	87c50513          	addi	a0,a0,-1924 # 800448a0 <cons>
    8000602c:	00000097          	auipc	ra,0x0
    80006030:	7f0080e7          	jalr	2032(ra) # 8000681c <acquire>

  switch(c){
    80006034:	47d5                	li	a5,21
    80006036:	0af48563          	beq	s1,a5,800060e0 <consoleintr+0xc8>
    8000603a:	0297c963          	blt	a5,s1,8000606c <consoleintr+0x54>
    8000603e:	47a1                	li	a5,8
    80006040:	0ef48c63          	beq	s1,a5,80006138 <consoleintr+0x120>
    80006044:	47c1                	li	a5,16
    80006046:	10f49f63          	bne	s1,a5,80006164 <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    8000604a:	ffffc097          	auipc	ra,0xffffc
    8000604e:	dd2080e7          	jalr	-558(ra) # 80001e1c <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80006052:	0003f517          	auipc	a0,0x3f
    80006056:	84e50513          	addi	a0,a0,-1970 # 800448a0 <cons>
    8000605a:	00001097          	auipc	ra,0x1
    8000605e:	876080e7          	jalr	-1930(ra) # 800068d0 <release>
}
    80006062:	60e2                	ld	ra,24(sp)
    80006064:	6442                	ld	s0,16(sp)
    80006066:	64a2                	ld	s1,8(sp)
    80006068:	6105                	addi	sp,sp,32
    8000606a:	8082                	ret
  switch(c){
    8000606c:	07f00793          	li	a5,127
    80006070:	0cf48463          	beq	s1,a5,80006138 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80006074:	0003f717          	auipc	a4,0x3f
    80006078:	82c70713          	addi	a4,a4,-2004 # 800448a0 <cons>
    8000607c:	0a072783          	lw	a5,160(a4)
    80006080:	09872703          	lw	a4,152(a4)
    80006084:	9f99                	subw	a5,a5,a4
    80006086:	07f00713          	li	a4,127
    8000608a:	fcf764e3          	bltu	a4,a5,80006052 <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    8000608e:	47b5                	li	a5,13
    80006090:	0cf48d63          	beq	s1,a5,8000616a <consoleintr+0x152>
      consputc(c);
    80006094:	8526                	mv	a0,s1
    80006096:	00000097          	auipc	ra,0x0
    8000609a:	f40080e7          	jalr	-192(ra) # 80005fd6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000609e:	0003f797          	auipc	a5,0x3f
    800060a2:	80278793          	addi	a5,a5,-2046 # 800448a0 <cons>
    800060a6:	0a07a683          	lw	a3,160(a5)
    800060aa:	0016871b          	addiw	a4,a3,1
    800060ae:	0007061b          	sext.w	a2,a4
    800060b2:	0ae7a023          	sw	a4,160(a5)
    800060b6:	07f6f693          	andi	a3,a3,127
    800060ba:	97b6                	add	a5,a5,a3
    800060bc:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800060c0:	47a9                	li	a5,10
    800060c2:	0cf48b63          	beq	s1,a5,80006198 <consoleintr+0x180>
    800060c6:	4791                	li	a5,4
    800060c8:	0cf48863          	beq	s1,a5,80006198 <consoleintr+0x180>
    800060cc:	0003f797          	auipc	a5,0x3f
    800060d0:	86c7a783          	lw	a5,-1940(a5) # 80044938 <cons+0x98>
    800060d4:	9f1d                	subw	a4,a4,a5
    800060d6:	08000793          	li	a5,128
    800060da:	f6f71ce3          	bne	a4,a5,80006052 <consoleintr+0x3a>
    800060de:	a86d                	j	80006198 <consoleintr+0x180>
    800060e0:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800060e2:	0003e717          	auipc	a4,0x3e
    800060e6:	7be70713          	addi	a4,a4,1982 # 800448a0 <cons>
    800060ea:	0a072783          	lw	a5,160(a4)
    800060ee:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800060f2:	0003e497          	auipc	s1,0x3e
    800060f6:	7ae48493          	addi	s1,s1,1966 # 800448a0 <cons>
    while(cons.e != cons.w &&
    800060fa:	4929                	li	s2,10
    800060fc:	02f70a63          	beq	a4,a5,80006130 <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80006100:	37fd                	addiw	a5,a5,-1
    80006102:	07f7f713          	andi	a4,a5,127
    80006106:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80006108:	01874703          	lbu	a4,24(a4)
    8000610c:	03270463          	beq	a4,s2,80006134 <consoleintr+0x11c>
      cons.e--;
    80006110:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80006114:	10000513          	li	a0,256
    80006118:	00000097          	auipc	ra,0x0
    8000611c:	ebe080e7          	jalr	-322(ra) # 80005fd6 <consputc>
    while(cons.e != cons.w &&
    80006120:	0a04a783          	lw	a5,160(s1)
    80006124:	09c4a703          	lw	a4,156(s1)
    80006128:	fcf71ce3          	bne	a4,a5,80006100 <consoleintr+0xe8>
    8000612c:	6902                	ld	s2,0(sp)
    8000612e:	b715                	j	80006052 <consoleintr+0x3a>
    80006130:	6902                	ld	s2,0(sp)
    80006132:	b705                	j	80006052 <consoleintr+0x3a>
    80006134:	6902                	ld	s2,0(sp)
    80006136:	bf31                	j	80006052 <consoleintr+0x3a>
    if(cons.e != cons.w){
    80006138:	0003e717          	auipc	a4,0x3e
    8000613c:	76870713          	addi	a4,a4,1896 # 800448a0 <cons>
    80006140:	0a072783          	lw	a5,160(a4)
    80006144:	09c72703          	lw	a4,156(a4)
    80006148:	f0f705e3          	beq	a4,a5,80006052 <consoleintr+0x3a>
      cons.e--;
    8000614c:	37fd                	addiw	a5,a5,-1
    8000614e:	0003e717          	auipc	a4,0x3e
    80006152:	7ef72923          	sw	a5,2034(a4) # 80044940 <cons+0xa0>
      consputc(BACKSPACE);
    80006156:	10000513          	li	a0,256
    8000615a:	00000097          	auipc	ra,0x0
    8000615e:	e7c080e7          	jalr	-388(ra) # 80005fd6 <consputc>
    80006162:	bdc5                	j	80006052 <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80006164:	ee0487e3          	beqz	s1,80006052 <consoleintr+0x3a>
    80006168:	b731                	j	80006074 <consoleintr+0x5c>
      consputc(c);
    8000616a:	4529                	li	a0,10
    8000616c:	00000097          	auipc	ra,0x0
    80006170:	e6a080e7          	jalr	-406(ra) # 80005fd6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80006174:	0003e797          	auipc	a5,0x3e
    80006178:	72c78793          	addi	a5,a5,1836 # 800448a0 <cons>
    8000617c:	0a07a703          	lw	a4,160(a5)
    80006180:	0017069b          	addiw	a3,a4,1
    80006184:	0006861b          	sext.w	a2,a3
    80006188:	0ad7a023          	sw	a3,160(a5)
    8000618c:	07f77713          	andi	a4,a4,127
    80006190:	97ba                	add	a5,a5,a4
    80006192:	4729                	li	a4,10
    80006194:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80006198:	0003e797          	auipc	a5,0x3e
    8000619c:	7ac7a223          	sw	a2,1956(a5) # 8004493c <cons+0x9c>
        wakeup(&cons.r);
    800061a0:	0003e517          	auipc	a0,0x3e
    800061a4:	79850513          	addi	a0,a0,1944 # 80044938 <cons+0x98>
    800061a8:	ffffc097          	auipc	ra,0xffffc
    800061ac:	824080e7          	jalr	-2012(ra) # 800019cc <wakeup>
    800061b0:	b54d                	j	80006052 <consoleintr+0x3a>

00000000800061b2 <consoleinit>:

void
consoleinit(void)
{
    800061b2:	1141                	addi	sp,sp,-16
    800061b4:	e406                	sd	ra,8(sp)
    800061b6:	e022                	sd	s0,0(sp)
    800061b8:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800061ba:	00002597          	auipc	a1,0x2
    800061be:	6a658593          	addi	a1,a1,1702 # 80008860 <etext+0x860>
    800061c2:	0003e517          	auipc	a0,0x3e
    800061c6:	6de50513          	addi	a0,a0,1758 # 800448a0 <cons>
    800061ca:	00000097          	auipc	ra,0x0
    800061ce:	5c2080e7          	jalr	1474(ra) # 8000678c <initlock>

  uartinit();
    800061d2:	00000097          	auipc	ra,0x0
    800061d6:	354080e7          	jalr	852(ra) # 80006526 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800061da:	00035797          	auipc	a5,0x35
    800061de:	3e678793          	addi	a5,a5,998 # 8003b5c0 <devsw>
    800061e2:	00000717          	auipc	a4,0x0
    800061e6:	cce70713          	addi	a4,a4,-818 # 80005eb0 <consoleread>
    800061ea:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800061ec:	00000717          	auipc	a4,0x0
    800061f0:	c5670713          	addi	a4,a4,-938 # 80005e42 <consolewrite>
    800061f4:	ef98                	sd	a4,24(a5)
}
    800061f6:	60a2                	ld	ra,8(sp)
    800061f8:	6402                	ld	s0,0(sp)
    800061fa:	0141                	addi	sp,sp,16
    800061fc:	8082                	ret

00000000800061fe <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800061fe:	7179                	addi	sp,sp,-48
    80006200:	f406                	sd	ra,40(sp)
    80006202:	f022                	sd	s0,32(sp)
    80006204:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80006206:	c219                	beqz	a2,8000620c <printint+0xe>
    80006208:	08054963          	bltz	a0,8000629a <printint+0x9c>
    x = -xx;
  else
    x = xx;
    8000620c:	2501                	sext.w	a0,a0
    8000620e:	4881                	li	a7,0
    80006210:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006214:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80006216:	2581                	sext.w	a1,a1
    80006218:	00002617          	auipc	a2,0x2
    8000621c:	7b060613          	addi	a2,a2,1968 # 800089c8 <digits>
    80006220:	883a                	mv	a6,a4
    80006222:	2705                	addiw	a4,a4,1
    80006224:	02b577bb          	remuw	a5,a0,a1
    80006228:	1782                	slli	a5,a5,0x20
    8000622a:	9381                	srli	a5,a5,0x20
    8000622c:	97b2                	add	a5,a5,a2
    8000622e:	0007c783          	lbu	a5,0(a5)
    80006232:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80006236:	0005079b          	sext.w	a5,a0
    8000623a:	02b5553b          	divuw	a0,a0,a1
    8000623e:	0685                	addi	a3,a3,1
    80006240:	feb7f0e3          	bgeu	a5,a1,80006220 <printint+0x22>

  if(sign)
    80006244:	00088c63          	beqz	a7,8000625c <printint+0x5e>
    buf[i++] = '-';
    80006248:	fe070793          	addi	a5,a4,-32
    8000624c:	00878733          	add	a4,a5,s0
    80006250:	02d00793          	li	a5,45
    80006254:	fef70823          	sb	a5,-16(a4)
    80006258:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    8000625c:	02e05b63          	blez	a4,80006292 <printint+0x94>
    80006260:	ec26                	sd	s1,24(sp)
    80006262:	e84a                	sd	s2,16(sp)
    80006264:	fd040793          	addi	a5,s0,-48
    80006268:	00e784b3          	add	s1,a5,a4
    8000626c:	fff78913          	addi	s2,a5,-1
    80006270:	993a                	add	s2,s2,a4
    80006272:	377d                	addiw	a4,a4,-1
    80006274:	1702                	slli	a4,a4,0x20
    80006276:	9301                	srli	a4,a4,0x20
    80006278:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000627c:	fff4c503          	lbu	a0,-1(s1)
    80006280:	00000097          	auipc	ra,0x0
    80006284:	d56080e7          	jalr	-682(ra) # 80005fd6 <consputc>
  while(--i >= 0)
    80006288:	14fd                	addi	s1,s1,-1
    8000628a:	ff2499e3          	bne	s1,s2,8000627c <printint+0x7e>
    8000628e:	64e2                	ld	s1,24(sp)
    80006290:	6942                	ld	s2,16(sp)
}
    80006292:	70a2                	ld	ra,40(sp)
    80006294:	7402                	ld	s0,32(sp)
    80006296:	6145                	addi	sp,sp,48
    80006298:	8082                	ret
    x = -xx;
    8000629a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000629e:	4885                	li	a7,1
    x = -xx;
    800062a0:	bf85                	j	80006210 <printint+0x12>

00000000800062a2 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    800062a2:	1101                	addi	sp,sp,-32
    800062a4:	ec06                	sd	ra,24(sp)
    800062a6:	e822                	sd	s0,16(sp)
    800062a8:	e426                	sd	s1,8(sp)
    800062aa:	1000                	addi	s0,sp,32
    800062ac:	84aa                	mv	s1,a0
  pr.locking = 0;
    800062ae:	0003e797          	auipc	a5,0x3e
    800062b2:	6a07a923          	sw	zero,1714(a5) # 80044960 <pr+0x18>
  printf("panic: ");
    800062b6:	00002517          	auipc	a0,0x2
    800062ba:	5b250513          	addi	a0,a0,1458 # 80008868 <etext+0x868>
    800062be:	00000097          	auipc	ra,0x0
    800062c2:	02e080e7          	jalr	46(ra) # 800062ec <printf>
  printf(s);
    800062c6:	8526                	mv	a0,s1
    800062c8:	00000097          	auipc	ra,0x0
    800062cc:	024080e7          	jalr	36(ra) # 800062ec <printf>
  printf("\n");
    800062d0:	00002517          	auipc	a0,0x2
    800062d4:	da050513          	addi	a0,a0,-608 # 80008070 <etext+0x70>
    800062d8:	00000097          	auipc	ra,0x0
    800062dc:	014080e7          	jalr	20(ra) # 800062ec <printf>
  panicked = 1; // freeze uart output from other CPUs
    800062e0:	4785                	li	a5,1
    800062e2:	00005717          	auipc	a4,0x5
    800062e6:	20f72d23          	sw	a5,538(a4) # 8000b4fc <panicked>
  for(;;)
    800062ea:	a001                	j	800062ea <panic+0x48>

00000000800062ec <printf>:
{
    800062ec:	7131                	addi	sp,sp,-192
    800062ee:	fc86                	sd	ra,120(sp)
    800062f0:	f8a2                	sd	s0,112(sp)
    800062f2:	e8d2                	sd	s4,80(sp)
    800062f4:	f06a                	sd	s10,32(sp)
    800062f6:	0100                	addi	s0,sp,128
    800062f8:	8a2a                	mv	s4,a0
    800062fa:	e40c                	sd	a1,8(s0)
    800062fc:	e810                	sd	a2,16(s0)
    800062fe:	ec14                	sd	a3,24(s0)
    80006300:	f018                	sd	a4,32(s0)
    80006302:	f41c                	sd	a5,40(s0)
    80006304:	03043823          	sd	a6,48(s0)
    80006308:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    8000630c:	0003ed17          	auipc	s10,0x3e
    80006310:	654d2d03          	lw	s10,1620(s10) # 80044960 <pr+0x18>
  if(locking)
    80006314:	040d1463          	bnez	s10,8000635c <printf+0x70>
  if (fmt == 0)
    80006318:	040a0b63          	beqz	s4,8000636e <printf+0x82>
  va_start(ap, fmt);
    8000631c:	00840793          	addi	a5,s0,8
    80006320:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006324:	000a4503          	lbu	a0,0(s4)
    80006328:	18050b63          	beqz	a0,800064be <printf+0x1d2>
    8000632c:	f4a6                	sd	s1,104(sp)
    8000632e:	f0ca                	sd	s2,96(sp)
    80006330:	ecce                	sd	s3,88(sp)
    80006332:	e4d6                	sd	s5,72(sp)
    80006334:	e0da                	sd	s6,64(sp)
    80006336:	fc5e                	sd	s7,56(sp)
    80006338:	f862                	sd	s8,48(sp)
    8000633a:	f466                	sd	s9,40(sp)
    8000633c:	ec6e                	sd	s11,24(sp)
    8000633e:	4981                	li	s3,0
    if(c != '%'){
    80006340:	02500b13          	li	s6,37
    switch(c){
    80006344:	07000b93          	li	s7,112
  consputc('x');
    80006348:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000634a:	00002a97          	auipc	s5,0x2
    8000634e:	67ea8a93          	addi	s5,s5,1662 # 800089c8 <digits>
    switch(c){
    80006352:	07300c13          	li	s8,115
    80006356:	06400d93          	li	s11,100
    8000635a:	a0b1                	j	800063a6 <printf+0xba>
    acquire(&pr.lock);
    8000635c:	0003e517          	auipc	a0,0x3e
    80006360:	5ec50513          	addi	a0,a0,1516 # 80044948 <pr>
    80006364:	00000097          	auipc	ra,0x0
    80006368:	4b8080e7          	jalr	1208(ra) # 8000681c <acquire>
    8000636c:	b775                	j	80006318 <printf+0x2c>
    8000636e:	f4a6                	sd	s1,104(sp)
    80006370:	f0ca                	sd	s2,96(sp)
    80006372:	ecce                	sd	s3,88(sp)
    80006374:	e4d6                	sd	s5,72(sp)
    80006376:	e0da                	sd	s6,64(sp)
    80006378:	fc5e                	sd	s7,56(sp)
    8000637a:	f862                	sd	s8,48(sp)
    8000637c:	f466                	sd	s9,40(sp)
    8000637e:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80006380:	00002517          	auipc	a0,0x2
    80006384:	4f850513          	addi	a0,a0,1272 # 80008878 <etext+0x878>
    80006388:	00000097          	auipc	ra,0x0
    8000638c:	f1a080e7          	jalr	-230(ra) # 800062a2 <panic>
      consputc(c);
    80006390:	00000097          	auipc	ra,0x0
    80006394:	c46080e7          	jalr	-954(ra) # 80005fd6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006398:	2985                	addiw	s3,s3,1
    8000639a:	013a07b3          	add	a5,s4,s3
    8000639e:	0007c503          	lbu	a0,0(a5)
    800063a2:	10050563          	beqz	a0,800064ac <printf+0x1c0>
    if(c != '%'){
    800063a6:	ff6515e3          	bne	a0,s6,80006390 <printf+0xa4>
    c = fmt[++i] & 0xff;
    800063aa:	2985                	addiw	s3,s3,1
    800063ac:	013a07b3          	add	a5,s4,s3
    800063b0:	0007c783          	lbu	a5,0(a5)
    800063b4:	0007849b          	sext.w	s1,a5
    if(c == 0)
    800063b8:	10078b63          	beqz	a5,800064ce <printf+0x1e2>
    switch(c){
    800063bc:	05778a63          	beq	a5,s7,80006410 <printf+0x124>
    800063c0:	02fbf663          	bgeu	s7,a5,800063ec <printf+0x100>
    800063c4:	09878863          	beq	a5,s8,80006454 <printf+0x168>
    800063c8:	07800713          	li	a4,120
    800063cc:	0ce79563          	bne	a5,a4,80006496 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    800063d0:	f8843783          	ld	a5,-120(s0)
    800063d4:	00878713          	addi	a4,a5,8
    800063d8:	f8e43423          	sd	a4,-120(s0)
    800063dc:	4605                	li	a2,1
    800063de:	85e6                	mv	a1,s9
    800063e0:	4388                	lw	a0,0(a5)
    800063e2:	00000097          	auipc	ra,0x0
    800063e6:	e1c080e7          	jalr	-484(ra) # 800061fe <printint>
      break;
    800063ea:	b77d                	j	80006398 <printf+0xac>
    switch(c){
    800063ec:	09678f63          	beq	a5,s6,8000648a <printf+0x19e>
    800063f0:	0bb79363          	bne	a5,s11,80006496 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    800063f4:	f8843783          	ld	a5,-120(s0)
    800063f8:	00878713          	addi	a4,a5,8
    800063fc:	f8e43423          	sd	a4,-120(s0)
    80006400:	4605                	li	a2,1
    80006402:	45a9                	li	a1,10
    80006404:	4388                	lw	a0,0(a5)
    80006406:	00000097          	auipc	ra,0x0
    8000640a:	df8080e7          	jalr	-520(ra) # 800061fe <printint>
      break;
    8000640e:	b769                	j	80006398 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80006410:	f8843783          	ld	a5,-120(s0)
    80006414:	00878713          	addi	a4,a5,8
    80006418:	f8e43423          	sd	a4,-120(s0)
    8000641c:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006420:	03000513          	li	a0,48
    80006424:	00000097          	auipc	ra,0x0
    80006428:	bb2080e7          	jalr	-1102(ra) # 80005fd6 <consputc>
  consputc('x');
    8000642c:	07800513          	li	a0,120
    80006430:	00000097          	auipc	ra,0x0
    80006434:	ba6080e7          	jalr	-1114(ra) # 80005fd6 <consputc>
    80006438:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000643a:	03c95793          	srli	a5,s2,0x3c
    8000643e:	97d6                	add	a5,a5,s5
    80006440:	0007c503          	lbu	a0,0(a5)
    80006444:	00000097          	auipc	ra,0x0
    80006448:	b92080e7          	jalr	-1134(ra) # 80005fd6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000644c:	0912                	slli	s2,s2,0x4
    8000644e:	34fd                	addiw	s1,s1,-1
    80006450:	f4ed                	bnez	s1,8000643a <printf+0x14e>
    80006452:	b799                	j	80006398 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80006454:	f8843783          	ld	a5,-120(s0)
    80006458:	00878713          	addi	a4,a5,8
    8000645c:	f8e43423          	sd	a4,-120(s0)
    80006460:	6384                	ld	s1,0(a5)
    80006462:	cc89                	beqz	s1,8000647c <printf+0x190>
      for(; *s; s++)
    80006464:	0004c503          	lbu	a0,0(s1)
    80006468:	d905                	beqz	a0,80006398 <printf+0xac>
        consputc(*s);
    8000646a:	00000097          	auipc	ra,0x0
    8000646e:	b6c080e7          	jalr	-1172(ra) # 80005fd6 <consputc>
      for(; *s; s++)
    80006472:	0485                	addi	s1,s1,1
    80006474:	0004c503          	lbu	a0,0(s1)
    80006478:	f96d                	bnez	a0,8000646a <printf+0x17e>
    8000647a:	bf39                	j	80006398 <printf+0xac>
        s = "(null)";
    8000647c:	00002497          	auipc	s1,0x2
    80006480:	3f448493          	addi	s1,s1,1012 # 80008870 <etext+0x870>
      for(; *s; s++)
    80006484:	02800513          	li	a0,40
    80006488:	b7cd                	j	8000646a <printf+0x17e>
      consputc('%');
    8000648a:	855a                	mv	a0,s6
    8000648c:	00000097          	auipc	ra,0x0
    80006490:	b4a080e7          	jalr	-1206(ra) # 80005fd6 <consputc>
      break;
    80006494:	b711                	j	80006398 <printf+0xac>
      consputc('%');
    80006496:	855a                	mv	a0,s6
    80006498:	00000097          	auipc	ra,0x0
    8000649c:	b3e080e7          	jalr	-1218(ra) # 80005fd6 <consputc>
      consputc(c);
    800064a0:	8526                	mv	a0,s1
    800064a2:	00000097          	auipc	ra,0x0
    800064a6:	b34080e7          	jalr	-1228(ra) # 80005fd6 <consputc>
      break;
    800064aa:	b5fd                	j	80006398 <printf+0xac>
    800064ac:	74a6                	ld	s1,104(sp)
    800064ae:	7906                	ld	s2,96(sp)
    800064b0:	69e6                	ld	s3,88(sp)
    800064b2:	6aa6                	ld	s5,72(sp)
    800064b4:	6b06                	ld	s6,64(sp)
    800064b6:	7be2                	ld	s7,56(sp)
    800064b8:	7c42                	ld	s8,48(sp)
    800064ba:	7ca2                	ld	s9,40(sp)
    800064bc:	6de2                	ld	s11,24(sp)
  if(locking)
    800064be:	020d1263          	bnez	s10,800064e2 <printf+0x1f6>
}
    800064c2:	70e6                	ld	ra,120(sp)
    800064c4:	7446                	ld	s0,112(sp)
    800064c6:	6a46                	ld	s4,80(sp)
    800064c8:	7d02                	ld	s10,32(sp)
    800064ca:	6129                	addi	sp,sp,192
    800064cc:	8082                	ret
    800064ce:	74a6                	ld	s1,104(sp)
    800064d0:	7906                	ld	s2,96(sp)
    800064d2:	69e6                	ld	s3,88(sp)
    800064d4:	6aa6                	ld	s5,72(sp)
    800064d6:	6b06                	ld	s6,64(sp)
    800064d8:	7be2                	ld	s7,56(sp)
    800064da:	7c42                	ld	s8,48(sp)
    800064dc:	7ca2                	ld	s9,40(sp)
    800064de:	6de2                	ld	s11,24(sp)
    800064e0:	bff9                	j	800064be <printf+0x1d2>
    release(&pr.lock);
    800064e2:	0003e517          	auipc	a0,0x3e
    800064e6:	46650513          	addi	a0,a0,1126 # 80044948 <pr>
    800064ea:	00000097          	auipc	ra,0x0
    800064ee:	3e6080e7          	jalr	998(ra) # 800068d0 <release>
}
    800064f2:	bfc1                	j	800064c2 <printf+0x1d6>

00000000800064f4 <printfinit>:
    ;
}

void
printfinit(void)
{
    800064f4:	1101                	addi	sp,sp,-32
    800064f6:	ec06                	sd	ra,24(sp)
    800064f8:	e822                	sd	s0,16(sp)
    800064fa:	e426                	sd	s1,8(sp)
    800064fc:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800064fe:	0003e497          	auipc	s1,0x3e
    80006502:	44a48493          	addi	s1,s1,1098 # 80044948 <pr>
    80006506:	00002597          	auipc	a1,0x2
    8000650a:	38258593          	addi	a1,a1,898 # 80008888 <etext+0x888>
    8000650e:	8526                	mv	a0,s1
    80006510:	00000097          	auipc	ra,0x0
    80006514:	27c080e7          	jalr	636(ra) # 8000678c <initlock>
  pr.locking = 1;
    80006518:	4785                	li	a5,1
    8000651a:	cc9c                	sw	a5,24(s1)
}
    8000651c:	60e2                	ld	ra,24(sp)
    8000651e:	6442                	ld	s0,16(sp)
    80006520:	64a2                	ld	s1,8(sp)
    80006522:	6105                	addi	sp,sp,32
    80006524:	8082                	ret

0000000080006526 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006526:	1141                	addi	sp,sp,-16
    80006528:	e406                	sd	ra,8(sp)
    8000652a:	e022                	sd	s0,0(sp)
    8000652c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000652e:	100007b7          	lui	a5,0x10000
    80006532:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006536:	10000737          	lui	a4,0x10000
    8000653a:	f8000693          	li	a3,-128
    8000653e:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006542:	468d                	li	a3,3
    80006544:	10000637          	lui	a2,0x10000
    80006548:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000654c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006550:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006554:	10000737          	lui	a4,0x10000
    80006558:	461d                	li	a2,7
    8000655a:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000655e:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006562:	00002597          	auipc	a1,0x2
    80006566:	32e58593          	addi	a1,a1,814 # 80008890 <etext+0x890>
    8000656a:	0003e517          	auipc	a0,0x3e
    8000656e:	3fe50513          	addi	a0,a0,1022 # 80044968 <uart_tx_lock>
    80006572:	00000097          	auipc	ra,0x0
    80006576:	21a080e7          	jalr	538(ra) # 8000678c <initlock>
}
    8000657a:	60a2                	ld	ra,8(sp)
    8000657c:	6402                	ld	s0,0(sp)
    8000657e:	0141                	addi	sp,sp,16
    80006580:	8082                	ret

0000000080006582 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006582:	1101                	addi	sp,sp,-32
    80006584:	ec06                	sd	ra,24(sp)
    80006586:	e822                	sd	s0,16(sp)
    80006588:	e426                	sd	s1,8(sp)
    8000658a:	1000                	addi	s0,sp,32
    8000658c:	84aa                	mv	s1,a0
  push_off();
    8000658e:	00000097          	auipc	ra,0x0
    80006592:	242080e7          	jalr	578(ra) # 800067d0 <push_off>

  if(panicked){
    80006596:	00005797          	auipc	a5,0x5
    8000659a:	f667a783          	lw	a5,-154(a5) # 8000b4fc <panicked>
    8000659e:	eb85                	bnez	a5,800065ce <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800065a0:	10000737          	lui	a4,0x10000
    800065a4:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800065a6:	00074783          	lbu	a5,0(a4)
    800065aa:	0207f793          	andi	a5,a5,32
    800065ae:	dfe5                	beqz	a5,800065a6 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800065b0:	0ff4f513          	zext.b	a0,s1
    800065b4:	100007b7          	lui	a5,0x10000
    800065b8:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800065bc:	00000097          	auipc	ra,0x0
    800065c0:	2b4080e7          	jalr	692(ra) # 80006870 <pop_off>
}
    800065c4:	60e2                	ld	ra,24(sp)
    800065c6:	6442                	ld	s0,16(sp)
    800065c8:	64a2                	ld	s1,8(sp)
    800065ca:	6105                	addi	sp,sp,32
    800065cc:	8082                	ret
    for(;;)
    800065ce:	a001                	j	800065ce <uartputc_sync+0x4c>

00000000800065d0 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800065d0:	00005797          	auipc	a5,0x5
    800065d4:	f307b783          	ld	a5,-208(a5) # 8000b500 <uart_tx_r>
    800065d8:	00005717          	auipc	a4,0x5
    800065dc:	f3073703          	ld	a4,-208(a4) # 8000b508 <uart_tx_w>
    800065e0:	06f70f63          	beq	a4,a5,8000665e <uartstart+0x8e>
{
    800065e4:	7139                	addi	sp,sp,-64
    800065e6:	fc06                	sd	ra,56(sp)
    800065e8:	f822                	sd	s0,48(sp)
    800065ea:	f426                	sd	s1,40(sp)
    800065ec:	f04a                	sd	s2,32(sp)
    800065ee:	ec4e                	sd	s3,24(sp)
    800065f0:	e852                	sd	s4,16(sp)
    800065f2:	e456                	sd	s5,8(sp)
    800065f4:	e05a                	sd	s6,0(sp)
    800065f6:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800065f8:	10000937          	lui	s2,0x10000
    800065fc:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800065fe:	0003ea97          	auipc	s5,0x3e
    80006602:	36aa8a93          	addi	s5,s5,874 # 80044968 <uart_tx_lock>
    uart_tx_r += 1;
    80006606:	00005497          	auipc	s1,0x5
    8000660a:	efa48493          	addi	s1,s1,-262 # 8000b500 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    8000660e:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80006612:	00005997          	auipc	s3,0x5
    80006616:	ef698993          	addi	s3,s3,-266 # 8000b508 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000661a:	00094703          	lbu	a4,0(s2)
    8000661e:	02077713          	andi	a4,a4,32
    80006622:	c705                	beqz	a4,8000664a <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006624:	01f7f713          	andi	a4,a5,31
    80006628:	9756                	add	a4,a4,s5
    8000662a:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    8000662e:	0785                	addi	a5,a5,1
    80006630:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80006632:	8526                	mv	a0,s1
    80006634:	ffffb097          	auipc	ra,0xffffb
    80006638:	398080e7          	jalr	920(ra) # 800019cc <wakeup>
    WriteReg(THR, c);
    8000663c:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80006640:	609c                	ld	a5,0(s1)
    80006642:	0009b703          	ld	a4,0(s3)
    80006646:	fcf71ae3          	bne	a4,a5,8000661a <uartstart+0x4a>
  }
}
    8000664a:	70e2                	ld	ra,56(sp)
    8000664c:	7442                	ld	s0,48(sp)
    8000664e:	74a2                	ld	s1,40(sp)
    80006650:	7902                	ld	s2,32(sp)
    80006652:	69e2                	ld	s3,24(sp)
    80006654:	6a42                	ld	s4,16(sp)
    80006656:	6aa2                	ld	s5,8(sp)
    80006658:	6b02                	ld	s6,0(sp)
    8000665a:	6121                	addi	sp,sp,64
    8000665c:	8082                	ret
    8000665e:	8082                	ret

0000000080006660 <uartputc>:
{
    80006660:	7179                	addi	sp,sp,-48
    80006662:	f406                	sd	ra,40(sp)
    80006664:	f022                	sd	s0,32(sp)
    80006666:	ec26                	sd	s1,24(sp)
    80006668:	e84a                	sd	s2,16(sp)
    8000666a:	e44e                	sd	s3,8(sp)
    8000666c:	e052                	sd	s4,0(sp)
    8000666e:	1800                	addi	s0,sp,48
    80006670:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006672:	0003e517          	auipc	a0,0x3e
    80006676:	2f650513          	addi	a0,a0,758 # 80044968 <uart_tx_lock>
    8000667a:	00000097          	auipc	ra,0x0
    8000667e:	1a2080e7          	jalr	418(ra) # 8000681c <acquire>
  if(panicked){
    80006682:	00005797          	auipc	a5,0x5
    80006686:	e7a7a783          	lw	a5,-390(a5) # 8000b4fc <panicked>
    8000668a:	e7c9                	bnez	a5,80006714 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000668c:	00005717          	auipc	a4,0x5
    80006690:	e7c73703          	ld	a4,-388(a4) # 8000b508 <uart_tx_w>
    80006694:	00005797          	auipc	a5,0x5
    80006698:	e6c7b783          	ld	a5,-404(a5) # 8000b500 <uart_tx_r>
    8000669c:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800066a0:	0003e997          	auipc	s3,0x3e
    800066a4:	2c898993          	addi	s3,s3,712 # 80044968 <uart_tx_lock>
    800066a8:	00005497          	auipc	s1,0x5
    800066ac:	e5848493          	addi	s1,s1,-424 # 8000b500 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800066b0:	00005917          	auipc	s2,0x5
    800066b4:	e5890913          	addi	s2,s2,-424 # 8000b508 <uart_tx_w>
    800066b8:	00e79f63          	bne	a5,a4,800066d6 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800066bc:	85ce                	mv	a1,s3
    800066be:	8526                	mv	a0,s1
    800066c0:	ffffb097          	auipc	ra,0xffffb
    800066c4:	2a8080e7          	jalr	680(ra) # 80001968 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800066c8:	00093703          	ld	a4,0(s2)
    800066cc:	609c                	ld	a5,0(s1)
    800066ce:	02078793          	addi	a5,a5,32
    800066d2:	fee785e3          	beq	a5,a4,800066bc <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800066d6:	0003e497          	auipc	s1,0x3e
    800066da:	29248493          	addi	s1,s1,658 # 80044968 <uart_tx_lock>
    800066de:	01f77793          	andi	a5,a4,31
    800066e2:	97a6                	add	a5,a5,s1
    800066e4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800066e8:	0705                	addi	a4,a4,1
    800066ea:	00005797          	auipc	a5,0x5
    800066ee:	e0e7bf23          	sd	a4,-482(a5) # 8000b508 <uart_tx_w>
  uartstart();
    800066f2:	00000097          	auipc	ra,0x0
    800066f6:	ede080e7          	jalr	-290(ra) # 800065d0 <uartstart>
  release(&uart_tx_lock);
    800066fa:	8526                	mv	a0,s1
    800066fc:	00000097          	auipc	ra,0x0
    80006700:	1d4080e7          	jalr	468(ra) # 800068d0 <release>
}
    80006704:	70a2                	ld	ra,40(sp)
    80006706:	7402                	ld	s0,32(sp)
    80006708:	64e2                	ld	s1,24(sp)
    8000670a:	6942                	ld	s2,16(sp)
    8000670c:	69a2                	ld	s3,8(sp)
    8000670e:	6a02                	ld	s4,0(sp)
    80006710:	6145                	addi	sp,sp,48
    80006712:	8082                	ret
    for(;;)
    80006714:	a001                	j	80006714 <uartputc+0xb4>

0000000080006716 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006716:	1141                	addi	sp,sp,-16
    80006718:	e422                	sd	s0,8(sp)
    8000671a:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000671c:	100007b7          	lui	a5,0x10000
    80006720:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80006722:	0007c783          	lbu	a5,0(a5)
    80006726:	8b85                	andi	a5,a5,1
    80006728:	cb81                	beqz	a5,80006738 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    8000672a:	100007b7          	lui	a5,0x10000
    8000672e:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006732:	6422                	ld	s0,8(sp)
    80006734:	0141                	addi	sp,sp,16
    80006736:	8082                	ret
    return -1;
    80006738:	557d                	li	a0,-1
    8000673a:	bfe5                	j	80006732 <uartgetc+0x1c>

000000008000673c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000673c:	1101                	addi	sp,sp,-32
    8000673e:	ec06                	sd	ra,24(sp)
    80006740:	e822                	sd	s0,16(sp)
    80006742:	e426                	sd	s1,8(sp)
    80006744:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006746:	54fd                	li	s1,-1
    80006748:	a029                	j	80006752 <uartintr+0x16>
      break;
    consoleintr(c);
    8000674a:	00000097          	auipc	ra,0x0
    8000674e:	8ce080e7          	jalr	-1842(ra) # 80006018 <consoleintr>
    int c = uartgetc();
    80006752:	00000097          	auipc	ra,0x0
    80006756:	fc4080e7          	jalr	-60(ra) # 80006716 <uartgetc>
    if(c == -1)
    8000675a:	fe9518e3          	bne	a0,s1,8000674a <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000675e:	0003e497          	auipc	s1,0x3e
    80006762:	20a48493          	addi	s1,s1,522 # 80044968 <uart_tx_lock>
    80006766:	8526                	mv	a0,s1
    80006768:	00000097          	auipc	ra,0x0
    8000676c:	0b4080e7          	jalr	180(ra) # 8000681c <acquire>
  uartstart();
    80006770:	00000097          	auipc	ra,0x0
    80006774:	e60080e7          	jalr	-416(ra) # 800065d0 <uartstart>
  release(&uart_tx_lock);
    80006778:	8526                	mv	a0,s1
    8000677a:	00000097          	auipc	ra,0x0
    8000677e:	156080e7          	jalr	342(ra) # 800068d0 <release>
}
    80006782:	60e2                	ld	ra,24(sp)
    80006784:	6442                	ld	s0,16(sp)
    80006786:	64a2                	ld	s1,8(sp)
    80006788:	6105                	addi	sp,sp,32
    8000678a:	8082                	ret

000000008000678c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000678c:	1141                	addi	sp,sp,-16
    8000678e:	e422                	sd	s0,8(sp)
    80006790:	0800                	addi	s0,sp,16
  lk->name = name;
    80006792:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006794:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006798:	00053823          	sd	zero,16(a0)
}
    8000679c:	6422                	ld	s0,8(sp)
    8000679e:	0141                	addi	sp,sp,16
    800067a0:	8082                	ret

00000000800067a2 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800067a2:	411c                	lw	a5,0(a0)
    800067a4:	e399                	bnez	a5,800067aa <holding+0x8>
    800067a6:	4501                	li	a0,0
  return r;
}
    800067a8:	8082                	ret
{
    800067aa:	1101                	addi	sp,sp,-32
    800067ac:	ec06                	sd	ra,24(sp)
    800067ae:	e822                	sd	s0,16(sp)
    800067b0:	e426                	sd	s1,8(sp)
    800067b2:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800067b4:	6904                	ld	s1,16(a0)
    800067b6:	ffffb097          	auipc	ra,0xffffb
    800067ba:	ae8080e7          	jalr	-1304(ra) # 8000129e <mycpu>
    800067be:	40a48533          	sub	a0,s1,a0
    800067c2:	00153513          	seqz	a0,a0
}
    800067c6:	60e2                	ld	ra,24(sp)
    800067c8:	6442                	ld	s0,16(sp)
    800067ca:	64a2                	ld	s1,8(sp)
    800067cc:	6105                	addi	sp,sp,32
    800067ce:	8082                	ret

00000000800067d0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800067d0:	1101                	addi	sp,sp,-32
    800067d2:	ec06                	sd	ra,24(sp)
    800067d4:	e822                	sd	s0,16(sp)
    800067d6:	e426                	sd	s1,8(sp)
    800067d8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800067da:	100024f3          	csrr	s1,sstatus
    800067de:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800067e2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800067e4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800067e8:	ffffb097          	auipc	ra,0xffffb
    800067ec:	ab6080e7          	jalr	-1354(ra) # 8000129e <mycpu>
    800067f0:	5d3c                	lw	a5,120(a0)
    800067f2:	cf89                	beqz	a5,8000680c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800067f4:	ffffb097          	auipc	ra,0xffffb
    800067f8:	aaa080e7          	jalr	-1366(ra) # 8000129e <mycpu>
    800067fc:	5d3c                	lw	a5,120(a0)
    800067fe:	2785                	addiw	a5,a5,1
    80006800:	dd3c                	sw	a5,120(a0)
}
    80006802:	60e2                	ld	ra,24(sp)
    80006804:	6442                	ld	s0,16(sp)
    80006806:	64a2                	ld	s1,8(sp)
    80006808:	6105                	addi	sp,sp,32
    8000680a:	8082                	ret
    mycpu()->intena = old;
    8000680c:	ffffb097          	auipc	ra,0xffffb
    80006810:	a92080e7          	jalr	-1390(ra) # 8000129e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006814:	8085                	srli	s1,s1,0x1
    80006816:	8885                	andi	s1,s1,1
    80006818:	dd64                	sw	s1,124(a0)
    8000681a:	bfe9                	j	800067f4 <push_off+0x24>

000000008000681c <acquire>:
{
    8000681c:	1101                	addi	sp,sp,-32
    8000681e:	ec06                	sd	ra,24(sp)
    80006820:	e822                	sd	s0,16(sp)
    80006822:	e426                	sd	s1,8(sp)
    80006824:	1000                	addi	s0,sp,32
    80006826:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006828:	00000097          	auipc	ra,0x0
    8000682c:	fa8080e7          	jalr	-88(ra) # 800067d0 <push_off>
  if(holding(lk))
    80006830:	8526                	mv	a0,s1
    80006832:	00000097          	auipc	ra,0x0
    80006836:	f70080e7          	jalr	-144(ra) # 800067a2 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000683a:	4705                	li	a4,1
  if(holding(lk))
    8000683c:	e115                	bnez	a0,80006860 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000683e:	87ba                	mv	a5,a4
    80006840:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006844:	2781                	sext.w	a5,a5
    80006846:	ffe5                	bnez	a5,8000683e <acquire+0x22>
  __sync_synchronize();
    80006848:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    8000684c:	ffffb097          	auipc	ra,0xffffb
    80006850:	a52080e7          	jalr	-1454(ra) # 8000129e <mycpu>
    80006854:	e888                	sd	a0,16(s1)
}
    80006856:	60e2                	ld	ra,24(sp)
    80006858:	6442                	ld	s0,16(sp)
    8000685a:	64a2                	ld	s1,8(sp)
    8000685c:	6105                	addi	sp,sp,32
    8000685e:	8082                	ret
    panic("acquire");
    80006860:	00002517          	auipc	a0,0x2
    80006864:	03850513          	addi	a0,a0,56 # 80008898 <etext+0x898>
    80006868:	00000097          	auipc	ra,0x0
    8000686c:	a3a080e7          	jalr	-1478(ra) # 800062a2 <panic>

0000000080006870 <pop_off>:

void
pop_off(void)
{
    80006870:	1141                	addi	sp,sp,-16
    80006872:	e406                	sd	ra,8(sp)
    80006874:	e022                	sd	s0,0(sp)
    80006876:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006878:	ffffb097          	auipc	ra,0xffffb
    8000687c:	a26080e7          	jalr	-1498(ra) # 8000129e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006880:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006884:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006886:	e78d                	bnez	a5,800068b0 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006888:	5d3c                	lw	a5,120(a0)
    8000688a:	02f05b63          	blez	a5,800068c0 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000688e:	37fd                	addiw	a5,a5,-1
    80006890:	0007871b          	sext.w	a4,a5
    80006894:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006896:	eb09                	bnez	a4,800068a8 <pop_off+0x38>
    80006898:	5d7c                	lw	a5,124(a0)
    8000689a:	c799                	beqz	a5,800068a8 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000689c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800068a0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800068a4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800068a8:	60a2                	ld	ra,8(sp)
    800068aa:	6402                	ld	s0,0(sp)
    800068ac:	0141                	addi	sp,sp,16
    800068ae:	8082                	ret
    panic("pop_off - interruptible");
    800068b0:	00002517          	auipc	a0,0x2
    800068b4:	ff050513          	addi	a0,a0,-16 # 800088a0 <etext+0x8a0>
    800068b8:	00000097          	auipc	ra,0x0
    800068bc:	9ea080e7          	jalr	-1558(ra) # 800062a2 <panic>
    panic("pop_off");
    800068c0:	00002517          	auipc	a0,0x2
    800068c4:	ff850513          	addi	a0,a0,-8 # 800088b8 <etext+0x8b8>
    800068c8:	00000097          	auipc	ra,0x0
    800068cc:	9da080e7          	jalr	-1574(ra) # 800062a2 <panic>

00000000800068d0 <release>:
{
    800068d0:	1101                	addi	sp,sp,-32
    800068d2:	ec06                	sd	ra,24(sp)
    800068d4:	e822                	sd	s0,16(sp)
    800068d6:	e426                	sd	s1,8(sp)
    800068d8:	1000                	addi	s0,sp,32
    800068da:	84aa                	mv	s1,a0
  if(!holding(lk))
    800068dc:	00000097          	auipc	ra,0x0
    800068e0:	ec6080e7          	jalr	-314(ra) # 800067a2 <holding>
    800068e4:	c115                	beqz	a0,80006908 <release+0x38>
  lk->cpu = 0;
    800068e6:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800068ea:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800068ee:	0310000f          	fence	rw,w
    800068f2:	0004a023          	sw	zero,0(s1)
  pop_off();
    800068f6:	00000097          	auipc	ra,0x0
    800068fa:	f7a080e7          	jalr	-134(ra) # 80006870 <pop_off>
}
    800068fe:	60e2                	ld	ra,24(sp)
    80006900:	6442                	ld	s0,16(sp)
    80006902:	64a2                	ld	s1,8(sp)
    80006904:	6105                	addi	sp,sp,32
    80006906:	8082                	ret
    panic("release");
    80006908:	00002517          	auipc	a0,0x2
    8000690c:	fb850513          	addi	a0,a0,-72 # 800088c0 <etext+0x8c0>
    80006910:	00000097          	auipc	ra,0x0
    80006914:	992080e7          	jalr	-1646(ra) # 800062a2 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
