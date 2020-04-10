
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c0 2f 10 80       	mov    $0x80102fc0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 74 10 80       	push   $0x80107400
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 65 45 00 00       	call   801045c0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 74 10 80       	push   $0x80107407
80100097:	50                   	push   %eax
80100098:	e8 f3 43 00 00       	call   80104490 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 17 46 00 00       	call   80104700 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 59 46 00 00       	call   801047c0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 5e 43 00 00       	call   801044d0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 bd 20 00 00       	call   80102240 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 0e 74 10 80       	push   $0x8010740e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 bd 43 00 00       	call   80104570 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 77 20 00 00       	jmp    80102240 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 1f 74 10 80       	push   $0x8010741f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 7c 43 00 00       	call   80104570 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 43 00 00       	call   80104530 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 f0 44 00 00       	call   80104700 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 5f 45 00 00       	jmp    801047c0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 26 74 10 80       	push   $0x80107426
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 eb 14 00 00       	call   80101770 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 6f 44 00 00       	call   80104700 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002a7:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002c5:	e8 56 3c 00 00       	call   80103f20 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 50 36 00 00       	call   80103930 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 cc 44 00 00       	call   801047c0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 94 13 00 00       	call   80101690 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 6e 44 00 00       	call   801047c0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 36 13 00 00       	call   80101690 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 a2 24 00 00       	call   80102850 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 2d 74 10 80       	push   $0x8010742d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 cf 7e 10 80 	movl   $0x80107ecf,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 03 42 00 00       	call   801045e0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 41 74 10 80       	push   $0x80107441
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 c1 5b 00 00       	call   80106000 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 0f 5b 00 00       	call   80106000 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 03 5b 00 00       	call   80106000 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 f7 5a 00 00       	call   80106000 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 97 43 00 00       	call   801048c0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 ca 42 00 00       	call   80104810 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 45 74 10 80       	push   $0x80107445
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 70 74 10 80 	movzbl -0x7fef8b90(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 5c 11 00 00       	call   80101770 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 e0 40 00 00       	call   80104700 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 74 41 00 00       	call   801047c0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 3b 10 00 00       	call   80101690 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 9c 40 00 00       	call   801047c0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 58 74 10 80       	mov    $0x80107458,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 0b 3f 00 00       	call   80104700 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 5f 74 10 80       	push   $0x8010745f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 d8 3e 00 00       	call   80104700 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100856:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 a5 10 80       	push   $0x8010a520
80100888:	e8 33 3f 00 00       	call   801047c0 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100911:	68 a0 ff 10 80       	push   $0x8010ffa0
80100916:	e8 c5 37 00 00       	call   801040e0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010093d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100964:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 24 38 00 00       	jmp    801041c0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 68 74 10 80       	push   $0x80107468
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 eb 3b 00 00       	call   801045c0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 f2 19 00 00       	call   801023f0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 0f 2f 00 00       	call   80103930 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 94 22 00 00       	call   80102cc0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 b9 14 00 00       	call   80101ef0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 43 0c 00 00       	call   80101690 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 12 0f 00 00       	call   80101970 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 b1 0e 00 00       	call   80101920 <iunlockput>
    end_op();
80100a6f:	e8 bc 22 00 00       	call   80102d30 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 b7 66 00 00       	call   80107150 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 75 64 00 00       	call   80106f70 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 83 63 00 00       	call   80106eb0 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 13 0e 00 00       	call   80101970 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 59 65 00 00       	call   801070d0 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 86 0d 00 00       	call   80101920 <iunlockput>
  end_op();
80100b9a:	e8 91 21 00 00       	call   80102d30 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 c1 63 00 00       	call   80106f70 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 0a 65 00 00       	call   801070d0 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 58 21 00 00       	call   80102d30 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 81 74 10 80       	push   $0x80107481
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 e5 65 00 00       	call   801071f0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 f2 3d 00 00       	call   80104a30 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 df 3d 00 00       	call   80104a30 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 ee 66 00 00       	call   80107350 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 84 66 00 00       	call   80107350 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 e1 3c 00 00       	call   801049f0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 e7 5f 00 00       	call   80106d20 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 8f 63 00 00       	call   801070d0 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 8d 74 10 80       	push   $0x8010748d
80100d6b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d70:	e8 4b 38 00 00       	call   801045c0 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d91:	e8 6a 39 00 00       	call   80104700 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dc1:	e8 fa 39 00 00       	call   801047c0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dda:	e8 e1 39 00 00       	call   801047c0 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dff:	e8 fc 38 00 00       	call   80104700 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e1c:	e8 9f 39 00 00       	call   801047c0 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 94 74 10 80       	push   $0x80107494
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e51:	e8 aa 38 00 00       	call   80104700 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 3f 39 00 00       	jmp    801047c0 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 13 39 00 00       	call   801047c0 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 9a 25 00 00       	call   80103470 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 db 1d 00 00       	call   80102cc0 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 d0 08 00 00       	call   801017c0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 31 1e 00 00       	jmp    80102d30 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 9c 74 10 80       	push   $0x8010749c
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 66 07 00 00       	call   80101690 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 09 0a 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 30 08 00 00       	call   80101770 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 01 07 00 00       	call   80101690 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 d4 09 00 00       	call   80101970 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 bd 07 00 00       	call   80101770 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 4e 26 00 00       	jmp    80103620 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 a6 74 10 80       	push   $0x801074a6
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 27 07 00 00       	call   80101770 <iunlock>
      end_op();
80101049:	e8 e2 1c 00 00       	call   80102d30 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 45 1c 00 00       	call   80102cc0 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 0a 06 00 00       	call   80101690 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 d8 09 00 00       	call   80101a70 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 c3 06 00 00       	call   80101770 <iunlock>
      end_op();
801010ad:	e8 7e 1c 00 00       	call   80102d30 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 1e 24 00 00       	jmp    80103510 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 af 74 10 80       	push   $0x801074af
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 b5 74 10 80       	push   $0x801074b5
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101119:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010111f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101122:	85 c9                	test   %ecx,%ecx
80101124:	0f 84 87 00 00 00    	je     801011b1 <balloc+0xa1>
8010112a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101131:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101134:	83 ec 08             	sub    $0x8,%esp
80101137:	89 f0                	mov    %esi,%eax
80101139:	c1 f8 0c             	sar    $0xc,%eax
8010113c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101142:	50                   	push   %eax
80101143:	ff 75 d8             	pushl  -0x28(%ebp)
80101146:	e8 85 ef ff ff       	call   801000d0 <bread>
8010114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101153:	83 c4 10             	add    $0x10,%esp
80101156:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101159:	31 c0                	xor    %eax,%eax
8010115b:	eb 2f                	jmp    8010118c <balloc+0x7c>
8010115d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101160:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101162:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101165:	bb 01 00 00 00       	mov    $0x1,%ebx
8010116a:	83 e1 07             	and    $0x7,%ecx
8010116d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116f:	89 c1                	mov    %eax,%ecx
80101171:	c1 f9 03             	sar    $0x3,%ecx
80101174:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101179:	85 df                	test   %ebx,%edi
8010117b:	89 fa                	mov    %edi,%edx
8010117d:	74 41                	je     801011c0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010117f:	83 c0 01             	add    $0x1,%eax
80101182:	83 c6 01             	add    $0x1,%esi
80101185:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010118a:	74 05                	je     80101191 <balloc+0x81>
8010118c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010118f:	77 cf                	ja     80101160 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101191:	83 ec 0c             	sub    $0xc,%esp
80101194:	ff 75 e4             	pushl  -0x1c(%ebp)
80101197:	e8 44 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010119c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011a3:	83 c4 10             	add    $0x10,%esp
801011a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a9:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
801011af:	77 80                	ja     80101131 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011b1:	83 ec 0c             	sub    $0xc,%esp
801011b4:	68 bf 74 10 80       	push   $0x801074bf
801011b9:	e8 d2 f1 ff ff       	call   80100390 <panic>
801011be:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011c3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011c6:	09 da                	or     %ebx,%edx
801011c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011cc:	57                   	push   %edi
801011cd:	e8 be 1c 00 00       	call   80102e90 <log_write>
        brelse(bp);
801011d2:	89 3c 24             	mov    %edi,(%esp)
801011d5:	e8 06 f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011da:	58                   	pop    %eax
801011db:	5a                   	pop    %edx
801011dc:	56                   	push   %esi
801011dd:	ff 75 d8             	pushl  -0x28(%ebp)
801011e0:	e8 eb ee ff ff       	call   801000d0 <bread>
801011e5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ea:	83 c4 0c             	add    $0xc,%esp
801011ed:	68 00 02 00 00       	push   $0x200
801011f2:	6a 00                	push   $0x0
801011f4:	50                   	push   %eax
801011f5:	e8 16 36 00 00       	call   80104810 <memset>
  log_write(bp);
801011fa:	89 1c 24             	mov    %ebx,(%esp)
801011fd:	e8 8e 1c 00 00       	call   80102e90 <log_write>
  brelse(bp);
80101202:	89 1c 24             	mov    %ebx,(%esp)
80101205:	e8 d6 ef ff ff       	call   801001e0 <brelse>
}
8010120a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120d:	89 f0                	mov    %esi,%eax
8010120f:	5b                   	pop    %ebx
80101210:	5e                   	pop    %esi
80101211:	5f                   	pop    %edi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
80101214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010121a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	56                   	push   %esi
80101225:	53                   	push   %ebx
80101226:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101228:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010122f:	83 ec 28             	sub    $0x28,%esp
80101232:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101235:	68 e0 09 11 80       	push   $0x801109e0
8010123a:	e8 c1 34 00 00       	call   80104700 <acquire>
8010123f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101245:	eb 17                	jmp    8010125e <iget+0x3e>
80101247:	89 f6                	mov    %esi,%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101250:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101256:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010125c:	73 22                	jae    80101280 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101261:	85 c9                	test   %ecx,%ecx
80101263:	7e 04                	jle    80101269 <iget+0x49>
80101265:	39 3b                	cmp    %edi,(%ebx)
80101267:	74 4f                	je     801012b8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101269:	85 f6                	test   %esi,%esi
8010126b:	75 e3                	jne    80101250 <iget+0x30>
8010126d:	85 c9                	test   %ecx,%ecx
8010126f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101272:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101278:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010127e:	72 de                	jb     8010125e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 5b                	je     801012df <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101284:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101287:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101289:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010128c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101293:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010129a:	68 e0 09 11 80       	push   $0x801109e0
8010129f:	e8 1c 35 00 00       	call   801047c0 <release>

  return ip;
801012a4:	83 c4 10             	add    $0x10,%esp
}
801012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012aa:	89 f0                	mov    %esi,%eax
801012ac:	5b                   	pop    %ebx
801012ad:	5e                   	pop    %esi
801012ae:	5f                   	pop    %edi
801012af:	5d                   	pop    %ebp
801012b0:	c3                   	ret    
801012b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012b8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012bb:	75 ac                	jne    80101269 <iget+0x49>
      release(&icache.lock);
801012bd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801012c0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012c3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012c5:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
801012ca:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012cd:	e8 ee 34 00 00       	call   801047c0 <release>
      return ip;
801012d2:	83 c4 10             	add    $0x10,%esp
}
801012d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d8:	89 f0                	mov    %esi,%eax
801012da:	5b                   	pop    %ebx
801012db:	5e                   	pop    %esi
801012dc:	5f                   	pop    %edi
801012dd:	5d                   	pop    %ebp
801012de:	c3                   	ret    
    panic("iget: no inodes");
801012df:	83 ec 0c             	sub    $0xc,%esp
801012e2:	68 d5 74 10 80       	push   $0x801074d5
801012e7:	e8 a4 f0 ff ff       	call   80100390 <panic>
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	89 c6                	mov    %eax,%esi
801012f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012fb:	83 fa 0b             	cmp    $0xb,%edx
801012fe:	77 18                	ja     80101318 <bmap+0x28>
80101300:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101303:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101306:	85 db                	test   %ebx,%ebx
80101308:	74 76                	je     80101380 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130d:	89 d8                	mov    %ebx,%eax
8010130f:	5b                   	pop    %ebx
80101310:	5e                   	pop    %esi
80101311:	5f                   	pop    %edi
80101312:	5d                   	pop    %ebp
80101313:	c3                   	ret    
80101314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101318:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010131b:	83 fb 7f             	cmp    $0x7f,%ebx
8010131e:	0f 87 90 00 00 00    	ja     801013b4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101324:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010132a:	8b 00                	mov    (%eax),%eax
8010132c:	85 d2                	test   %edx,%edx
8010132e:	74 70                	je     801013a0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101330:	83 ec 08             	sub    $0x8,%esp
80101333:	52                   	push   %edx
80101334:	50                   	push   %eax
80101335:	e8 96 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010133a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010133e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101341:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101343:	8b 1a                	mov    (%edx),%ebx
80101345:	85 db                	test   %ebx,%ebx
80101347:	75 1d                	jne    80101366 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101349:	8b 06                	mov    (%esi),%eax
8010134b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010134e:	e8 bd fd ff ff       	call   80101110 <balloc>
80101353:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101356:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101359:	89 c3                	mov    %eax,%ebx
8010135b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010135d:	57                   	push   %edi
8010135e:	e8 2d 1b 00 00       	call   80102e90 <log_write>
80101363:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101366:	83 ec 0c             	sub    $0xc,%esp
80101369:	57                   	push   %edi
8010136a:	e8 71 ee ff ff       	call   801001e0 <brelse>
8010136f:	83 c4 10             	add    $0x10,%esp
}
80101372:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101375:	89 d8                	mov    %ebx,%eax
80101377:	5b                   	pop    %ebx
80101378:	5e                   	pop    %esi
80101379:	5f                   	pop    %edi
8010137a:	5d                   	pop    %ebp
8010137b:	c3                   	ret    
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101380:	8b 00                	mov    (%eax),%eax
80101382:	e8 89 fd ff ff       	call   80101110 <balloc>
80101387:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010138d:	89 c3                	mov    %eax,%ebx
}
8010138f:	89 d8                	mov    %ebx,%eax
80101391:	5b                   	pop    %ebx
80101392:	5e                   	pop    %esi
80101393:	5f                   	pop    %edi
80101394:	5d                   	pop    %ebp
80101395:	c3                   	ret    
80101396:	8d 76 00             	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013a0:	e8 6b fd ff ff       	call   80101110 <balloc>
801013a5:	89 c2                	mov    %eax,%edx
801013a7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013ad:	8b 06                	mov    (%esi),%eax
801013af:	e9 7c ff ff ff       	jmp    80101330 <bmap+0x40>
  panic("bmap: out of range");
801013b4:	83 ec 0c             	sub    $0xc,%esp
801013b7:	68 e5 74 10 80       	push   $0x801074e5
801013bc:	e8 cf ef ff ff       	call   80100390 <panic>
801013c1:	eb 0d                	jmp    801013d0 <readsb>
801013c3:	90                   	nop
801013c4:	90                   	nop
801013c5:	90                   	nop
801013c6:	90                   	nop
801013c7:	90                   	nop
801013c8:	90                   	nop
801013c9:	90                   	nop
801013ca:	90                   	nop
801013cb:	90                   	nop
801013cc:	90                   	nop
801013cd:	90                   	nop
801013ce:	90                   	nop
801013cf:	90                   	nop

801013d0 <readsb>:
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	56                   	push   %esi
801013d4:	53                   	push   %ebx
801013d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013d8:	83 ec 08             	sub    $0x8,%esp
801013db:	6a 01                	push   $0x1
801013dd:	ff 75 08             	pushl  0x8(%ebp)
801013e0:	e8 eb ec ff ff       	call   801000d0 <bread>
801013e5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ea:	83 c4 0c             	add    $0xc,%esp
801013ed:	6a 1c                	push   $0x1c
801013ef:	50                   	push   %eax
801013f0:	56                   	push   %esi
801013f1:	e8 ca 34 00 00       	call   801048c0 <memmove>
  brelse(bp);
801013f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013f9:	83 c4 10             	add    $0x10,%esp
}
801013fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013ff:	5b                   	pop    %ebx
80101400:	5e                   	pop    %esi
80101401:	5d                   	pop    %ebp
  brelse(bp);
80101402:	e9 d9 ed ff ff       	jmp    801001e0 <brelse>
80101407:	89 f6                	mov    %esi,%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101410 <bfree>:
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	56                   	push   %esi
80101414:	53                   	push   %ebx
80101415:	89 d3                	mov    %edx,%ebx
80101417:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101419:	83 ec 08             	sub    $0x8,%esp
8010141c:	68 c0 09 11 80       	push   $0x801109c0
80101421:	50                   	push   %eax
80101422:	e8 a9 ff ff ff       	call   801013d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101427:	58                   	pop    %eax
80101428:	5a                   	pop    %edx
80101429:	89 da                	mov    %ebx,%edx
8010142b:	c1 ea 0c             	shr    $0xc,%edx
8010142e:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101434:	52                   	push   %edx
80101435:	56                   	push   %esi
80101436:	e8 95 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010143b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010143d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101440:	ba 01 00 00 00       	mov    $0x1,%edx
80101445:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101448:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010144e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101451:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101453:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101458:	85 d1                	test   %edx,%ecx
8010145a:	74 25                	je     80101481 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010145c:	f7 d2                	not    %edx
8010145e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101460:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101463:	21 ca                	and    %ecx,%edx
80101465:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101469:	56                   	push   %esi
8010146a:	e8 21 1a 00 00       	call   80102e90 <log_write>
  brelse(bp);
8010146f:	89 34 24             	mov    %esi,(%esp)
80101472:	e8 69 ed ff ff       	call   801001e0 <brelse>
}
80101477:	83 c4 10             	add    $0x10,%esp
8010147a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010147d:	5b                   	pop    %ebx
8010147e:	5e                   	pop    %esi
8010147f:	5d                   	pop    %ebp
80101480:	c3                   	ret    
    panic("freeing free block");
80101481:	83 ec 0c             	sub    $0xc,%esp
80101484:	68 f8 74 10 80       	push   $0x801074f8
80101489:	e8 02 ef ff ff       	call   80100390 <panic>
8010148e:	66 90                	xchg   %ax,%ax

80101490 <iinit>:
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
80101494:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101499:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010149c:	68 0b 75 10 80       	push   $0x8010750b
801014a1:	68 e0 09 11 80       	push   $0x801109e0
801014a6:	e8 15 31 00 00       	call   801045c0 <initlock>
801014ab:	83 c4 10             	add    $0x10,%esp
801014ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014b0:	83 ec 08             	sub    $0x8,%esp
801014b3:	68 12 75 10 80       	push   $0x80107512
801014b8:	53                   	push   %ebx
801014b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014bf:	e8 cc 2f 00 00       	call   80104490 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014c4:	83 c4 10             	add    $0x10,%esp
801014c7:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014cd:	75 e1                	jne    801014b0 <iinit+0x20>
  readsb(dev, &sb);
801014cf:	83 ec 08             	sub    $0x8,%esp
801014d2:	68 c0 09 11 80       	push   $0x801109c0
801014d7:	ff 75 08             	pushl  0x8(%ebp)
801014da:	e8 f1 fe ff ff       	call   801013d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014df:	ff 35 d8 09 11 80    	pushl  0x801109d8
801014e5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801014eb:	ff 35 d0 09 11 80    	pushl  0x801109d0
801014f1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801014f7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801014fd:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101503:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101509:	68 94 75 10 80       	push   $0x80107594
8010150e:	e8 4d f1 ff ff       	call   80100660 <cprintf>
}
80101513:	83 c4 30             	add    $0x30,%esp
80101516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101519:	c9                   	leave  
8010151a:	c3                   	ret    
8010151b:	90                   	nop
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101520 <ialloc>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101530:	8b 45 0c             	mov    0xc(%ebp),%eax
80101533:	8b 75 08             	mov    0x8(%ebp),%esi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 91 00 00 00    	jbe    801015d0 <ialloc+0xb0>
8010153f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101544:	eb 21                	jmp    80101567 <ialloc+0x47>
80101546:	8d 76 00             	lea    0x0(%esi),%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101550:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101556:	57                   	push   %edi
80101557:	e8 84 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010155c:	83 c4 10             	add    $0x10,%esp
8010155f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101565:	76 69                	jbe    801015d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101567:	89 d8                	mov    %ebx,%eax
80101569:	83 ec 08             	sub    $0x8,%esp
8010156c:	c1 e8 03             	shr    $0x3,%eax
8010156f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101575:	50                   	push   %eax
80101576:	56                   	push   %esi
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101580:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101583:	83 e0 07             	and    $0x7,%eax
80101586:	c1 e0 06             	shl    $0x6,%eax
80101589:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101591:	75 bd                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101593:	83 ec 04             	sub    $0x4,%esp
80101596:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101599:	6a 40                	push   $0x40
8010159b:	6a 00                	push   $0x0
8010159d:	51                   	push   %ecx
8010159e:	e8 6d 32 00 00       	call   80104810 <memset>
      dip->type = type;
801015a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ad:	89 3c 24             	mov    %edi,(%esp)
801015b0:	e8 db 18 00 00       	call   80102e90 <log_write>
      brelse(bp);
801015b5:	89 3c 24             	mov    %edi,(%esp)
801015b8:	e8 23 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015bd:	83 c4 10             	add    $0x10,%esp
}
801015c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015c3:	89 da                	mov    %ebx,%edx
801015c5:	89 f0                	mov    %esi,%eax
}
801015c7:	5b                   	pop    %ebx
801015c8:	5e                   	pop    %esi
801015c9:	5f                   	pop    %edi
801015ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801015cb:	e9 50 fc ff ff       	jmp    80101220 <iget>
  panic("ialloc: no inodes");
801015d0:	83 ec 0c             	sub    $0xc,%esp
801015d3:	68 18 75 10 80       	push   $0x80107518
801015d8:	e8 b3 ed ff ff       	call   80100390 <panic>
801015dd:	8d 76 00             	lea    0x0(%esi),%esi

801015e0 <iupdate>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	56                   	push   %esi
801015e4:	53                   	push   %ebx
801015e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e8:	83 ec 08             	sub    $0x8,%esp
801015eb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ee:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f1:	c1 e8 03             	shr    $0x3,%eax
801015f4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015fa:	50                   	push   %eax
801015fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015fe:	e8 cd ea ff ff       	call   801000d0 <bread>
80101603:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101605:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101608:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010160f:	83 e0 07             	and    $0x7,%eax
80101612:	c1 e0 06             	shl    $0x6,%eax
80101615:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101619:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010161c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101620:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101623:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101627:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010162b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010162f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101633:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101637:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010163a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163d:	6a 34                	push   $0x34
8010163f:	53                   	push   %ebx
80101640:	50                   	push   %eax
80101641:	e8 7a 32 00 00       	call   801048c0 <memmove>
  log_write(bp);
80101646:	89 34 24             	mov    %esi,(%esp)
80101649:	e8 42 18 00 00       	call   80102e90 <log_write>
  brelse(bp);
8010164e:	89 75 08             	mov    %esi,0x8(%ebp)
80101651:	83 c4 10             	add    $0x10,%esp
}
80101654:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101657:	5b                   	pop    %ebx
80101658:	5e                   	pop    %esi
80101659:	5d                   	pop    %ebp
  brelse(bp);
8010165a:	e9 81 eb ff ff       	jmp    801001e0 <brelse>
8010165f:	90                   	nop

80101660 <idup>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	53                   	push   %ebx
80101664:	83 ec 10             	sub    $0x10,%esp
80101667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010166a:	68 e0 09 11 80       	push   $0x801109e0
8010166f:	e8 8c 30 00 00       	call   80104700 <acquire>
  ip->ref++;
80101674:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101678:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010167f:	e8 3c 31 00 00       	call   801047c0 <release>
}
80101684:	89 d8                	mov    %ebx,%eax
80101686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101689:	c9                   	leave  
8010168a:	c3                   	ret    
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <ilock>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	56                   	push   %esi
80101694:	53                   	push   %ebx
80101695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101698:	85 db                	test   %ebx,%ebx
8010169a:	0f 84 b7 00 00 00    	je     80101757 <ilock+0xc7>
801016a0:	8b 53 08             	mov    0x8(%ebx),%edx
801016a3:	85 d2                	test   %edx,%edx
801016a5:	0f 8e ac 00 00 00    	jle    80101757 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016ab:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ae:	83 ec 0c             	sub    $0xc,%esp
801016b1:	50                   	push   %eax
801016b2:	e8 19 2e 00 00       	call   801044d0 <acquiresleep>
  if(ip->valid == 0){
801016b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ba:	83 c4 10             	add    $0x10,%esp
801016bd:	85 c0                	test   %eax,%eax
801016bf:	74 0f                	je     801016d0 <ilock+0x40>
}
801016c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c4:	5b                   	pop    %ebx
801016c5:	5e                   	pop    %esi
801016c6:	5d                   	pop    %ebp
801016c7:	c3                   	ret    
801016c8:	90                   	nop
801016c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d0:	8b 43 04             	mov    0x4(%ebx),%eax
801016d3:	83 ec 08             	sub    $0x8,%esp
801016d6:	c1 e8 03             	shr    $0x3,%eax
801016d9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016df:	50                   	push   %eax
801016e0:	ff 33                	pushl  (%ebx)
801016e2:	e8 e9 e9 ff ff       	call   801000d0 <bread>
801016e7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ef:	83 e0 07             	and    $0x7,%eax
801016f2:	c1 e0 06             	shl    $0x6,%eax
801016f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101703:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101707:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010170b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010170f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101713:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101717:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010171b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010171e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101721:	6a 34                	push   $0x34
80101723:	50                   	push   %eax
80101724:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101727:	50                   	push   %eax
80101728:	e8 93 31 00 00       	call   801048c0 <memmove>
    brelse(bp);
8010172d:	89 34 24             	mov    %esi,(%esp)
80101730:	e8 ab ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101735:	83 c4 10             	add    $0x10,%esp
80101738:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010173d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101744:	0f 85 77 ff ff ff    	jne    801016c1 <ilock+0x31>
      panic("ilock: no type");
8010174a:	83 ec 0c             	sub    $0xc,%esp
8010174d:	68 30 75 10 80       	push   $0x80107530
80101752:	e8 39 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 2a 75 10 80       	push   $0x8010752a
8010175f:	e8 2c ec ff ff       	call   80100390 <panic>
80101764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010176a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101770 <iunlock>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	56                   	push   %esi
80101774:	53                   	push   %ebx
80101775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101778:	85 db                	test   %ebx,%ebx
8010177a:	74 28                	je     801017a4 <iunlock+0x34>
8010177c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	56                   	push   %esi
80101783:	e8 e8 2d 00 00       	call   80104570 <holdingsleep>
80101788:	83 c4 10             	add    $0x10,%esp
8010178b:	85 c0                	test   %eax,%eax
8010178d:	74 15                	je     801017a4 <iunlock+0x34>
8010178f:	8b 43 08             	mov    0x8(%ebx),%eax
80101792:	85 c0                	test   %eax,%eax
80101794:	7e 0e                	jle    801017a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101796:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101799:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010179c:	5b                   	pop    %ebx
8010179d:	5e                   	pop    %esi
8010179e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010179f:	e9 8c 2d 00 00       	jmp    80104530 <releasesleep>
    panic("iunlock");
801017a4:	83 ec 0c             	sub    $0xc,%esp
801017a7:	68 3f 75 10 80       	push   $0x8010753f
801017ac:	e8 df eb ff ff       	call   80100390 <panic>
801017b1:	eb 0d                	jmp    801017c0 <iput>
801017b3:	90                   	nop
801017b4:	90                   	nop
801017b5:	90                   	nop
801017b6:	90                   	nop
801017b7:	90                   	nop
801017b8:	90                   	nop
801017b9:	90                   	nop
801017ba:	90                   	nop
801017bb:	90                   	nop
801017bc:	90                   	nop
801017bd:	90                   	nop
801017be:	90                   	nop
801017bf:	90                   	nop

801017c0 <iput>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 28             	sub    $0x28,%esp
801017c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017cf:	57                   	push   %edi
801017d0:	e8 fb 2c 00 00       	call   801044d0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017d8:	83 c4 10             	add    $0x10,%esp
801017db:	85 d2                	test   %edx,%edx
801017dd:	74 07                	je     801017e6 <iput+0x26>
801017df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017e4:	74 32                	je     80101818 <iput+0x58>
  releasesleep(&ip->lock);
801017e6:	83 ec 0c             	sub    $0xc,%esp
801017e9:	57                   	push   %edi
801017ea:	e8 41 2d 00 00       	call   80104530 <releasesleep>
  acquire(&icache.lock);
801017ef:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017f6:	e8 05 2f 00 00       	call   80104700 <acquire>
  ip->ref--;
801017fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ff:	83 c4 10             	add    $0x10,%esp
80101802:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101809:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010180c:	5b                   	pop    %ebx
8010180d:	5e                   	pop    %esi
8010180e:	5f                   	pop    %edi
8010180f:	5d                   	pop    %ebp
  release(&icache.lock);
80101810:	e9 ab 2f 00 00       	jmp    801047c0 <release>
80101815:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	68 e0 09 11 80       	push   $0x801109e0
80101820:	e8 db 2e 00 00       	call   80104700 <acquire>
    int r = ip->ref;
80101825:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101828:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010182f:	e8 8c 2f 00 00       	call   801047c0 <release>
    if(r == 1){
80101834:	83 c4 10             	add    $0x10,%esp
80101837:	83 fe 01             	cmp    $0x1,%esi
8010183a:	75 aa                	jne    801017e6 <iput+0x26>
8010183c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101842:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101845:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x97>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101853:	39 fe                	cmp    %edi,%esi
80101855:	74 19                	je     80101870 <iput+0xb0>
    if(ip->addrs[i]){
80101857:	8b 16                	mov    (%esi),%edx
80101859:	85 d2                	test   %edx,%edx
8010185b:	74 f3                	je     80101850 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010185d:	8b 03                	mov    (%ebx),%eax
8010185f:	e8 ac fb ff ff       	call   80101410 <bfree>
      ip->addrs[i] = 0;
80101864:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010186a:	eb e4                	jmp    80101850 <iput+0x90>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101870:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 33                	jne    801018b0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010187d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101880:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101887:	53                   	push   %ebx
80101888:	e8 53 fd ff ff       	call   801015e0 <iupdate>
      ip->type = 0;
8010188d:	31 c0                	xor    %eax,%eax
8010188f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101893:	89 1c 24             	mov    %ebx,(%esp)
80101896:	e8 45 fd ff ff       	call   801015e0 <iupdate>
      ip->valid = 0;
8010189b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018a2:	83 c4 10             	add    $0x10,%esp
801018a5:	e9 3c ff ff ff       	jmp    801017e6 <iput+0x26>
801018aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	83 ec 08             	sub    $0x8,%esp
801018b3:	50                   	push   %eax
801018b4:	ff 33                	pushl  (%ebx)
801018b6:	e8 15 e8 ff ff       	call   801000d0 <bread>
801018bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018c1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018c7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ca:	83 c4 10             	add    $0x10,%esp
801018cd:	89 cf                	mov    %ecx,%edi
801018cf:	eb 0e                	jmp    801018df <iput+0x11f>
801018d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018d8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018db:	39 fe                	cmp    %edi,%esi
801018dd:	74 0f                	je     801018ee <iput+0x12e>
      if(a[j])
801018df:	8b 16                	mov    (%esi),%edx
801018e1:	85 d2                	test   %edx,%edx
801018e3:	74 f3                	je     801018d8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018e5:	8b 03                	mov    (%ebx),%eax
801018e7:	e8 24 fb ff ff       	call   80101410 <bfree>
801018ec:	eb ea                	jmp    801018d8 <iput+0x118>
    brelse(bp);
801018ee:	83 ec 0c             	sub    $0xc,%esp
801018f1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018f7:	e8 e4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018fc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101902:	8b 03                	mov    (%ebx),%eax
80101904:	e8 07 fb ff ff       	call   80101410 <bfree>
    ip->addrs[NDIRECT] = 0;
80101909:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101910:	00 00 00 
80101913:	83 c4 10             	add    $0x10,%esp
80101916:	e9 62 ff ff ff       	jmp    8010187d <iput+0xbd>
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <iunlockput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 10             	sub    $0x10,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010192a:	53                   	push   %ebx
8010192b:	e8 40 fe ff ff       	call   80101770 <iunlock>
  iput(ip);
80101930:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101933:	83 c4 10             	add    $0x10,%esp
}
80101936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101939:	c9                   	leave  
  iput(ip);
8010193a:	e9 81 fe ff ff       	jmp    801017c0 <iput>
8010193f:	90                   	nop

80101940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
}
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 1c             	sub    $0x1c,%esp
80101979:	8b 45 08             	mov    0x8(%ebp),%eax
8010197c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010197f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101982:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101987:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010198a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010198d:	8b 75 10             	mov    0x10(%ebp),%esi
80101990:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101993:	0f 84 a7 00 00 00    	je     80101a40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101999:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010199c:	8b 40 58             	mov    0x58(%eax),%eax
8010199f:	39 c6                	cmp    %eax,%esi
801019a1:	0f 87 ba 00 00 00    	ja     80101a61 <readi+0xf1>
801019a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019aa:	89 f9                	mov    %edi,%ecx
801019ac:	01 f1                	add    %esi,%ecx
801019ae:	0f 82 ad 00 00 00    	jb     80101a61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019b4:	89 c2                	mov    %eax,%edx
801019b6:	29 f2                	sub    %esi,%edx
801019b8:	39 c8                	cmp    %ecx,%eax
801019ba:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019bd:	31 ff                	xor    %edi,%edi
801019bf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c4:	74 6c                	je     80101a32 <readi+0xc2>
801019c6:	8d 76 00             	lea    0x0(%esi),%esi
801019c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019d3:	89 f2                	mov    %esi,%edx
801019d5:	c1 ea 09             	shr    $0x9,%edx
801019d8:	89 d8                	mov    %ebx,%eax
801019da:	e8 11 f9 ff ff       	call   801012f0 <bmap>
801019df:	83 ec 08             	sub    $0x8,%esp
801019e2:	50                   	push   %eax
801019e3:	ff 33                	pushl  (%ebx)
801019e5:	e8 e6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ed:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019ef:	89 f0                	mov    %esi,%eax
801019f1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019f6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019fb:	83 c4 0c             	add    $0xc,%esp
801019fe:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a00:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a04:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a07:	29 fb                	sub    %edi,%ebx
80101a09:	39 d9                	cmp    %ebx,%ecx
80101a0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0e:	53                   	push   %ebx
80101a0f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a10:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a12:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a15:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a17:	e8 a4 2e 00 00       	call   801048c0 <memmove>
    brelse(bp);
80101a1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a1f:	89 14 24             	mov    %edx,(%esp)
80101a22:	e8 b9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a2a:	83 c4 10             	add    $0x10,%esp
80101a2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a30:	77 9e                	ja     801019d0 <readi+0x60>
  }
  return n;
80101a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a38:	5b                   	pop    %ebx
80101a39:	5e                   	pop    %esi
80101a3a:	5f                   	pop    %edi
80101a3b:	5d                   	pop    %ebp
80101a3c:	c3                   	ret    
80101a3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a44:	66 83 f8 09          	cmp    $0x9,%ax
80101a48:	77 17                	ja     80101a61 <readi+0xf1>
80101a4a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a51:	85 c0                	test   %eax,%eax
80101a53:	74 0c                	je     80101a61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a5b:	5b                   	pop    %ebx
80101a5c:	5e                   	pop    %esi
80101a5d:	5f                   	pop    %edi
80101a5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a5f:	ff e0                	jmp    *%eax
      return -1;
80101a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a66:	eb cd                	jmp    80101a35 <readi+0xc5>
80101a68:	90                   	nop
80101a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 1c             	sub    $0x1c,%esp
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a8d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a90:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a93:	0f 84 b7 00 00 00    	je     80101b50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a9f:	0f 82 eb 00 00 00    	jb     80101b90 <writei+0x120>
80101aa5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101aa8:	31 d2                	xor    %edx,%edx
80101aaa:	89 f8                	mov    %edi,%eax
80101aac:	01 f0                	add    %esi,%eax
80101aae:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ab1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ab6:	0f 87 d4 00 00 00    	ja     80101b90 <writei+0x120>
80101abc:	85 d2                	test   %edx,%edx
80101abe:	0f 85 cc 00 00 00    	jne    80101b90 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ac4:	85 ff                	test   %edi,%edi
80101ac6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101acd:	74 72                	je     80101b41 <writei+0xd1>
80101acf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 f8                	mov    %edi,%eax
80101ada:	e8 11 f8 ff ff       	call   801012f0 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 37                	pushl  (%edi)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101aed:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101af2:	89 f0                	mov    %esi,%eax
80101af4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af9:	83 c4 0c             	add    $0xc,%esp
80101afc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b07:	39 d9                	cmp    %ebx,%ecx
80101b09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b0c:	53                   	push   %ebx
80101b0d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b10:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b12:	50                   	push   %eax
80101b13:	e8 a8 2d 00 00       	call   801048c0 <memmove>
    log_write(bp);
80101b18:	89 3c 24             	mov    %edi,(%esp)
80101b1b:	e8 70 13 00 00       	call   80102e90 <log_write>
    brelse(bp);
80101b20:	89 3c 24             	mov    %edi,(%esp)
80101b23:	e8 b8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b2b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b2e:	83 c4 10             	add    $0x10,%esp
80101b31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b37:	77 97                	ja     80101ad0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b3f:	77 37                	ja     80101b78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b47:	5b                   	pop    %ebx
80101b48:	5e                   	pop    %esi
80101b49:	5f                   	pop    %edi
80101b4a:	5d                   	pop    %ebp
80101b4b:	c3                   	ret    
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 36                	ja     80101b90 <writei+0x120>
80101b5a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 2b                	je     80101b90 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b6f:	ff e0                	jmp    *%eax
80101b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b81:	50                   	push   %eax
80101b82:	e8 59 fa ff ff       	call   801015e0 <iupdate>
80101b87:	83 c4 10             	add    $0x10,%esp
80101b8a:	eb b5                	jmp    80101b41 <writei+0xd1>
80101b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b95:	eb ad                	jmp    80101b44 <writei+0xd4>
80101b97:	89 f6                	mov    %esi,%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ba6:	6a 0e                	push   $0xe
80101ba8:	ff 75 0c             	pushl  0xc(%ebp)
80101bab:	ff 75 08             	pushl  0x8(%ebp)
80101bae:	e8 7d 2d 00 00       	call   80104930 <strncmp>
}
80101bb3:	c9                   	leave  
80101bb4:	c3                   	ret    
80101bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 1c             	sub    $0x1c,%esp
80101bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bd1:	0f 85 85 00 00 00    	jne    80101c5c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bda:	31 ff                	xor    %edi,%edi
80101bdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bdf:	85 d2                	test   %edx,%edx
80101be1:	74 3e                	je     80101c21 <dirlookup+0x61>
80101be3:	90                   	nop
80101be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101be8:	6a 10                	push   $0x10
80101bea:	57                   	push   %edi
80101beb:	56                   	push   %esi
80101bec:	53                   	push   %ebx
80101bed:	e8 7e fd ff ff       	call   80101970 <readi>
80101bf2:	83 c4 10             	add    $0x10,%esp
80101bf5:	83 f8 10             	cmp    $0x10,%eax
80101bf8:	75 55                	jne    80101c4f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bfa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bff:	74 18                	je     80101c19 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c01:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c04:	83 ec 04             	sub    $0x4,%esp
80101c07:	6a 0e                	push   $0xe
80101c09:	50                   	push   %eax
80101c0a:	ff 75 0c             	pushl  0xc(%ebp)
80101c0d:	e8 1e 2d 00 00       	call   80104930 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c12:	83 c4 10             	add    $0x10,%esp
80101c15:	85 c0                	test   %eax,%eax
80101c17:	74 17                	je     80101c30 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c19:	83 c7 10             	add    $0x10,%edi
80101c1c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c1f:	72 c7                	jb     80101be8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c24:	31 c0                	xor    %eax,%eax
}
80101c26:	5b                   	pop    %ebx
80101c27:	5e                   	pop    %esi
80101c28:	5f                   	pop    %edi
80101c29:	5d                   	pop    %ebp
80101c2a:	c3                   	ret    
80101c2b:	90                   	nop
80101c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c30:	8b 45 10             	mov    0x10(%ebp),%eax
80101c33:	85 c0                	test   %eax,%eax
80101c35:	74 05                	je     80101c3c <dirlookup+0x7c>
        *poff = off;
80101c37:	8b 45 10             	mov    0x10(%ebp),%eax
80101c3a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c3c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c40:	8b 03                	mov    (%ebx),%eax
80101c42:	e8 d9 f5 ff ff       	call   80101220 <iget>
}
80101c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c4a:	5b                   	pop    %ebx
80101c4b:	5e                   	pop    %esi
80101c4c:	5f                   	pop    %edi
80101c4d:	5d                   	pop    %ebp
80101c4e:	c3                   	ret    
      panic("dirlookup read");
80101c4f:	83 ec 0c             	sub    $0xc,%esp
80101c52:	68 59 75 10 80       	push   $0x80107559
80101c57:	e8 34 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c5c:	83 ec 0c             	sub    $0xc,%esp
80101c5f:	68 47 75 10 80       	push   $0x80107547
80101c64:	e8 27 e7 ff ff       	call   80100390 <panic>
80101c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	56                   	push   %esi
80101c75:	53                   	push   %ebx
80101c76:	89 cf                	mov    %ecx,%edi
80101c78:	89 c3                	mov    %eax,%ebx
80101c7a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c7d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c80:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c83:	0f 84 67 01 00 00    	je     80101df0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c89:	e8 a2 1c 00 00       	call   80103930 <myproc>
  acquire(&icache.lock);
80101c8e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c91:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c94:	68 e0 09 11 80       	push   $0x801109e0
80101c99:	e8 62 2a 00 00       	call   80104700 <acquire>
  ip->ref++;
80101c9e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ca2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101ca9:	e8 12 2b 00 00       	call   801047c0 <release>
80101cae:	83 c4 10             	add    $0x10,%esp
80101cb1:	eb 08                	jmp    80101cbb <namex+0x4b>
80101cb3:	90                   	nop
80101cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101cb8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cbb:	0f b6 03             	movzbl (%ebx),%eax
80101cbe:	3c 2f                	cmp    $0x2f,%al
80101cc0:	74 f6                	je     80101cb8 <namex+0x48>
  if(*path == 0)
80101cc2:	84 c0                	test   %al,%al
80101cc4:	0f 84 ee 00 00 00    	je     80101db8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cca:	0f b6 03             	movzbl (%ebx),%eax
80101ccd:	3c 2f                	cmp    $0x2f,%al
80101ccf:	0f 84 b3 00 00 00    	je     80101d88 <namex+0x118>
80101cd5:	84 c0                	test   %al,%al
80101cd7:	89 da                	mov    %ebx,%edx
80101cd9:	75 09                	jne    80101ce4 <namex+0x74>
80101cdb:	e9 a8 00 00 00       	jmp    80101d88 <namex+0x118>
80101ce0:	84 c0                	test   %al,%al
80101ce2:	74 0a                	je     80101cee <namex+0x7e>
    path++;
80101ce4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101ce7:	0f b6 02             	movzbl (%edx),%eax
80101cea:	3c 2f                	cmp    $0x2f,%al
80101cec:	75 f2                	jne    80101ce0 <namex+0x70>
80101cee:	89 d1                	mov    %edx,%ecx
80101cf0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101cf2:	83 f9 0d             	cmp    $0xd,%ecx
80101cf5:	0f 8e 91 00 00 00    	jle    80101d8c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101cfb:	83 ec 04             	sub    $0x4,%esp
80101cfe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d01:	6a 0e                	push   $0xe
80101d03:	53                   	push   %ebx
80101d04:	57                   	push   %edi
80101d05:	e8 b6 2b 00 00       	call   801048c0 <memmove>
    path++;
80101d0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d0d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d10:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d12:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d15:	75 11                	jne    80101d28 <namex+0xb8>
80101d17:	89 f6                	mov    %esi,%esi
80101d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d20:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d23:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d26:	74 f8                	je     80101d20 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d28:	83 ec 0c             	sub    $0xc,%esp
80101d2b:	56                   	push   %esi
80101d2c:	e8 5f f9 ff ff       	call   80101690 <ilock>
    if(ip->type != T_DIR){
80101d31:	83 c4 10             	add    $0x10,%esp
80101d34:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d39:	0f 85 91 00 00 00    	jne    80101dd0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d42:	85 d2                	test   %edx,%edx
80101d44:	74 09                	je     80101d4f <namex+0xdf>
80101d46:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d49:	0f 84 b7 00 00 00    	je     80101e06 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d4f:	83 ec 04             	sub    $0x4,%esp
80101d52:	6a 00                	push   $0x0
80101d54:	57                   	push   %edi
80101d55:	56                   	push   %esi
80101d56:	e8 65 fe ff ff       	call   80101bc0 <dirlookup>
80101d5b:	83 c4 10             	add    $0x10,%esp
80101d5e:	85 c0                	test   %eax,%eax
80101d60:	74 6e                	je     80101dd0 <namex+0x160>
  iunlock(ip);
80101d62:	83 ec 0c             	sub    $0xc,%esp
80101d65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d68:	56                   	push   %esi
80101d69:	e8 02 fa ff ff       	call   80101770 <iunlock>
  iput(ip);
80101d6e:	89 34 24             	mov    %esi,(%esp)
80101d71:	e8 4a fa ff ff       	call   801017c0 <iput>
80101d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d79:	83 c4 10             	add    $0x10,%esp
80101d7c:	89 c6                	mov    %eax,%esi
80101d7e:	e9 38 ff ff ff       	jmp    80101cbb <namex+0x4b>
80101d83:	90                   	nop
80101d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d88:	89 da                	mov    %ebx,%edx
80101d8a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d8c:	83 ec 04             	sub    $0x4,%esp
80101d8f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d92:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d95:	51                   	push   %ecx
80101d96:	53                   	push   %ebx
80101d97:	57                   	push   %edi
80101d98:	e8 23 2b 00 00       	call   801048c0 <memmove>
    name[len] = 0;
80101d9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101da0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101da3:	83 c4 10             	add    $0x10,%esp
80101da6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101daa:	89 d3                	mov    %edx,%ebx
80101dac:	e9 61 ff ff ff       	jmp    80101d12 <namex+0xa2>
80101db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dbb:	85 c0                	test   %eax,%eax
80101dbd:	75 5d                	jne    80101e1c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101dbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dc2:	89 f0                	mov    %esi,%eax
80101dc4:	5b                   	pop    %ebx
80101dc5:	5e                   	pop    %esi
80101dc6:	5f                   	pop    %edi
80101dc7:	5d                   	pop    %ebp
80101dc8:	c3                   	ret    
80101dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dd0:	83 ec 0c             	sub    $0xc,%esp
80101dd3:	56                   	push   %esi
80101dd4:	e8 97 f9 ff ff       	call   80101770 <iunlock>
  iput(ip);
80101dd9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ddc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dde:	e8 dd f9 ff ff       	call   801017c0 <iput>
      return 0;
80101de3:	83 c4 10             	add    $0x10,%esp
}
80101de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de9:	89 f0                	mov    %esi,%eax
80101deb:	5b                   	pop    %ebx
80101dec:	5e                   	pop    %esi
80101ded:	5f                   	pop    %edi
80101dee:	5d                   	pop    %ebp
80101def:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101df0:	ba 01 00 00 00       	mov    $0x1,%edx
80101df5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dfa:	e8 21 f4 ff ff       	call   80101220 <iget>
80101dff:	89 c6                	mov    %eax,%esi
80101e01:	e9 b5 fe ff ff       	jmp    80101cbb <namex+0x4b>
      iunlock(ip);
80101e06:	83 ec 0c             	sub    $0xc,%esp
80101e09:	56                   	push   %esi
80101e0a:	e8 61 f9 ff ff       	call   80101770 <iunlock>
      return ip;
80101e0f:	83 c4 10             	add    $0x10,%esp
}
80101e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e15:	89 f0                	mov    %esi,%eax
80101e17:	5b                   	pop    %ebx
80101e18:	5e                   	pop    %esi
80101e19:	5f                   	pop    %edi
80101e1a:	5d                   	pop    %ebp
80101e1b:	c3                   	ret    
    iput(ip);
80101e1c:	83 ec 0c             	sub    $0xc,%esp
80101e1f:	56                   	push   %esi
    return 0;
80101e20:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e22:	e8 99 f9 ff ff       	call   801017c0 <iput>
    return 0;
80101e27:	83 c4 10             	add    $0x10,%esp
80101e2a:	eb 93                	jmp    80101dbf <namex+0x14f>
80101e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e30 <dirlink>:
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 20             	sub    $0x20,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e3c:	6a 00                	push   $0x0
80101e3e:	ff 75 0c             	pushl  0xc(%ebp)
80101e41:	53                   	push   %ebx
80101e42:	e8 79 fd ff ff       	call   80101bc0 <dirlookup>
80101e47:	83 c4 10             	add    $0x10,%esp
80101e4a:	85 c0                	test   %eax,%eax
80101e4c:	75 67                	jne    80101eb5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e4e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e51:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e54:	85 ff                	test   %edi,%edi
80101e56:	74 29                	je     80101e81 <dirlink+0x51>
80101e58:	31 ff                	xor    %edi,%edi
80101e5a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e5d:	eb 09                	jmp    80101e68 <dirlink+0x38>
80101e5f:	90                   	nop
80101e60:	83 c7 10             	add    $0x10,%edi
80101e63:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e66:	73 19                	jae    80101e81 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e68:	6a 10                	push   $0x10
80101e6a:	57                   	push   %edi
80101e6b:	56                   	push   %esi
80101e6c:	53                   	push   %ebx
80101e6d:	e8 fe fa ff ff       	call   80101970 <readi>
80101e72:	83 c4 10             	add    $0x10,%esp
80101e75:	83 f8 10             	cmp    $0x10,%eax
80101e78:	75 4e                	jne    80101ec8 <dirlink+0x98>
    if(de.inum == 0)
80101e7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e7f:	75 df                	jne    80101e60 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e81:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e84:	83 ec 04             	sub    $0x4,%esp
80101e87:	6a 0e                	push   $0xe
80101e89:	ff 75 0c             	pushl  0xc(%ebp)
80101e8c:	50                   	push   %eax
80101e8d:	e8 fe 2a 00 00       	call   80104990 <strncpy>
  de.inum = inum;
80101e92:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e95:	6a 10                	push   $0x10
80101e97:	57                   	push   %edi
80101e98:	56                   	push   %esi
80101e99:	53                   	push   %ebx
  de.inum = inum;
80101e9a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e9e:	e8 cd fb ff ff       	call   80101a70 <writei>
80101ea3:	83 c4 20             	add    $0x20,%esp
80101ea6:	83 f8 10             	cmp    $0x10,%eax
80101ea9:	75 2a                	jne    80101ed5 <dirlink+0xa5>
  return 0;
80101eab:	31 c0                	xor    %eax,%eax
}
80101ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eb0:	5b                   	pop    %ebx
80101eb1:	5e                   	pop    %esi
80101eb2:	5f                   	pop    %edi
80101eb3:	5d                   	pop    %ebp
80101eb4:	c3                   	ret    
    iput(ip);
80101eb5:	83 ec 0c             	sub    $0xc,%esp
80101eb8:	50                   	push   %eax
80101eb9:	e8 02 f9 ff ff       	call   801017c0 <iput>
    return -1;
80101ebe:	83 c4 10             	add    $0x10,%esp
80101ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec6:	eb e5                	jmp    80101ead <dirlink+0x7d>
      panic("dirlink read");
80101ec8:	83 ec 0c             	sub    $0xc,%esp
80101ecb:	68 68 75 10 80       	push   $0x80107568
80101ed0:	e8 bb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	68 b6 7c 10 80       	push   $0x80107cb6
80101edd:	e8 ae e4 ff ff       	call   80100390 <panic>
80101ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ef0 <namei>:

struct inode*
namei(char *path)
{
80101ef0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ef1:	31 d2                	xor    %edx,%edx
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80101efb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101efe:	e8 6d fd ff ff       	call   80101c70 <namex>
}
80101f03:	c9                   	leave  
80101f04:	c3                   	ret    
80101f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f10:	55                   	push   %ebp
  return namex(path, 1, name);
80101f11:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f16:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f1e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f1f:	e9 4c fd ff ff       	jmp    80101c70 <namex>
80101f24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101f30 <swapread>:

#define SWAPBASE	500
#define SWAPMAX		(100000 - SWAPBASE)

void swapread(char* ptr, int blkno)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	57                   	push   %edi
80101f34:	56                   	push   %esi
80101f35:	53                   	push   %ebx
80101f36:	83 ec 1c             	sub    $0x1c,%esp
80101f39:	8b 7d 0c             	mov    0xc(%ebp),%edi
	struct buf* bp;
	int i;

	if ( blkno < 0 || blkno >= SWAPMAX )
80101f3c:	81 ff ab 84 01 00    	cmp    $0x184ab,%edi
80101f42:	77 5c                	ja     80101fa0 <swapread+0x70>
80101f44:	8d 87 fc 01 00 00    	lea    0x1fc(%edi),%eax
80101f4a:	8b 75 08             	mov    0x8(%ebp),%esi
80101f4d:	8d 9f f4 01 00 00    	lea    0x1f4(%edi),%ebx
80101f53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101f56:	8d 76 00             	lea    0x0(%esi),%esi
80101f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		panic("swapread: blkno exceed range");

	for ( i=0; i < 8; ++i ) {
		bp = bread(0, blkno + SWAPBASE + i);
80101f60:	83 ec 08             	sub    $0x8,%esp
80101f63:	53                   	push   %ebx
80101f64:	6a 00                	push   $0x0
80101f66:	83 c3 01             	add    $0x1,%ebx
80101f69:	e8 62 e1 ff ff       	call   801000d0 <bread>
80101f6e:	89 c7                	mov    %eax,%edi
		memmove(ptr + i * BSIZE, bp->data, BSIZE);
80101f70:	8d 40 5c             	lea    0x5c(%eax),%eax
80101f73:	83 c4 0c             	add    $0xc,%esp
80101f76:	68 00 02 00 00       	push   $0x200
80101f7b:	50                   	push   %eax
80101f7c:	56                   	push   %esi
80101f7d:	81 c6 00 02 00 00    	add    $0x200,%esi
80101f83:	e8 38 29 00 00       	call   801048c0 <memmove>
		brelse(bp);
80101f88:	89 3c 24             	mov    %edi,(%esp)
80101f8b:	e8 50 e2 ff ff       	call   801001e0 <brelse>
	for ( i=0; i < 8; ++i ) {
80101f90:	83 c4 10             	add    $0x10,%esp
80101f93:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80101f96:	75 c8                	jne    80101f60 <swapread+0x30>
	}
}
80101f98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f9b:	5b                   	pop    %ebx
80101f9c:	5e                   	pop    %esi
80101f9d:	5f                   	pop    %edi
80101f9e:	5d                   	pop    %ebp
80101f9f:	c3                   	ret    
		panic("swapread: blkno exceed range");
80101fa0:	83 ec 0c             	sub    $0xc,%esp
80101fa3:	68 75 75 10 80       	push   $0x80107575
80101fa8:	e8 e3 e3 ff ff       	call   80100390 <panic>
80101fad:	8d 76 00             	lea    0x0(%esi),%esi

80101fb0 <swapwrite>:

void swapwrite(char* ptr, int blkno)
{
80101fb0:	55                   	push   %ebp
80101fb1:	89 e5                	mov    %esp,%ebp
80101fb3:	57                   	push   %edi
80101fb4:	56                   	push   %esi
80101fb5:	53                   	push   %ebx
80101fb6:	83 ec 1c             	sub    $0x1c,%esp
80101fb9:	8b 7d 0c             	mov    0xc(%ebp),%edi
	struct buf* bp;
	int i;

	if ( blkno < 0 || blkno >= SWAPMAX )
80101fbc:	81 ff ab 84 01 00    	cmp    $0x184ab,%edi
80101fc2:	77 64                	ja     80102028 <swapwrite+0x78>
80101fc4:	8d 87 fc 01 00 00    	lea    0x1fc(%edi),%eax
80101fca:	8b 75 08             	mov    0x8(%ebp),%esi
80101fcd:	8d 9f f4 01 00 00    	lea    0x1f4(%edi),%ebx
80101fd3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101fd6:	8d 76 00             	lea    0x0(%esi),%esi
80101fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		panic("swapread: blkno exceed range");

	for ( i=0; i < 8; ++i ) {
		bp = bread(0, blkno + SWAPBASE + i);
80101fe0:	83 ec 08             	sub    $0x8,%esp
80101fe3:	53                   	push   %ebx
80101fe4:	6a 00                	push   $0x0
80101fe6:	83 c3 01             	add    $0x1,%ebx
80101fe9:	e8 e2 e0 ff ff       	call   801000d0 <bread>
80101fee:	89 c7                	mov    %eax,%edi
		memmove(bp->data, ptr + i * BSIZE, BSIZE);
80101ff0:	8d 40 5c             	lea    0x5c(%eax),%eax
80101ff3:	83 c4 0c             	add    $0xc,%esp
80101ff6:	68 00 02 00 00       	push   $0x200
80101ffb:	56                   	push   %esi
80101ffc:	81 c6 00 02 00 00    	add    $0x200,%esi
80102002:	50                   	push   %eax
80102003:	e8 b8 28 00 00       	call   801048c0 <memmove>
		bwrite(bp);
80102008:	89 3c 24             	mov    %edi,(%esp)
8010200b:	e8 90 e1 ff ff       	call   801001a0 <bwrite>
		brelse(bp);
80102010:	89 3c 24             	mov    %edi,(%esp)
80102013:	e8 c8 e1 ff ff       	call   801001e0 <brelse>
	for ( i=0; i < 8; ++i ) {
80102018:	83 c4 10             	add    $0x10,%esp
8010201b:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
8010201e:	75 c0                	jne    80101fe0 <swapwrite+0x30>
	}
}
80102020:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102023:	5b                   	pop    %ebx
80102024:	5e                   	pop    %esi
80102025:	5f                   	pop    %edi
80102026:	5d                   	pop    %ebp
80102027:	c3                   	ret    
		panic("swapread: blkno exceed range");
80102028:	83 ec 0c             	sub    $0xc,%esp
8010202b:	68 75 75 10 80       	push   $0x80107575
80102030:	e8 5b e3 ff ff       	call   80100390 <panic>
80102035:	66 90                	xchg   %ax,%ax
80102037:	66 90                	xchg   %ax,%ax
80102039:	66 90                	xchg   %ax,%ax
8010203b:	66 90                	xchg   %ax,%ax
8010203d:	66 90                	xchg   %ax,%ax
8010203f:	90                   	nop

80102040 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	57                   	push   %edi
80102044:	56                   	push   %esi
80102045:	53                   	push   %ebx
80102046:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102049:	85 c0                	test   %eax,%eax
8010204b:	0f 84 b4 00 00 00    	je     80102105 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102051:	8b 58 08             	mov    0x8(%eax),%ebx
80102054:	89 c6                	mov    %eax,%esi
80102056:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010205c:	0f 87 96 00 00 00    	ja     801020f8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102062:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102067:	89 f6                	mov    %esi,%esi
80102069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102070:	89 ca                	mov    %ecx,%edx
80102072:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102073:	83 e0 c0             	and    $0xffffffc0,%eax
80102076:	3c 40                	cmp    $0x40,%al
80102078:	75 f6                	jne    80102070 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010207a:	31 ff                	xor    %edi,%edi
8010207c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102081:	89 f8                	mov    %edi,%eax
80102083:	ee                   	out    %al,(%dx)
80102084:	b8 01 00 00 00       	mov    $0x1,%eax
80102089:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010208e:	ee                   	out    %al,(%dx)
8010208f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102094:	89 d8                	mov    %ebx,%eax
80102096:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102097:	89 d8                	mov    %ebx,%eax
80102099:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010209e:	c1 f8 08             	sar    $0x8,%eax
801020a1:	ee                   	out    %al,(%dx)
801020a2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020a7:	89 f8                	mov    %edi,%eax
801020a9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020aa:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801020ae:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020b3:	c1 e0 04             	shl    $0x4,%eax
801020b6:	83 e0 10             	and    $0x10,%eax
801020b9:	83 c8 e0             	or     $0xffffffe0,%eax
801020bc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020bd:	f6 06 04             	testb  $0x4,(%esi)
801020c0:	75 16                	jne    801020d8 <idestart+0x98>
801020c2:	b8 20 00 00 00       	mov    $0x20,%eax
801020c7:	89 ca                	mov    %ecx,%edx
801020c9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801020ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020cd:	5b                   	pop    %ebx
801020ce:	5e                   	pop    %esi
801020cf:	5f                   	pop    %edi
801020d0:	5d                   	pop    %ebp
801020d1:	c3                   	ret    
801020d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801020d8:	b8 30 00 00 00       	mov    $0x30,%eax
801020dd:	89 ca                	mov    %ecx,%edx
801020df:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801020e0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801020e5:	83 c6 5c             	add    $0x5c,%esi
801020e8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020ed:	fc                   	cld    
801020ee:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801020f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020f3:	5b                   	pop    %ebx
801020f4:	5e                   	pop    %esi
801020f5:	5f                   	pop    %edi
801020f6:	5d                   	pop    %ebp
801020f7:	c3                   	ret    
    panic("incorrect blockno");
801020f8:	83 ec 0c             	sub    $0xc,%esp
801020fb:	68 f0 75 10 80       	push   $0x801075f0
80102100:	e8 8b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102105:	83 ec 0c             	sub    $0xc,%esp
80102108:	68 e7 75 10 80       	push   $0x801075e7
8010210d:	e8 7e e2 ff ff       	call   80100390 <panic>
80102112:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102120 <ideinit>:
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102126:	68 02 76 10 80       	push   $0x80107602
8010212b:	68 80 a5 10 80       	push   $0x8010a580
80102130:	e8 8b 24 00 00       	call   801045c0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102135:	58                   	pop    %eax
80102136:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010213b:	5a                   	pop    %edx
8010213c:	83 e8 01             	sub    $0x1,%eax
8010213f:	50                   	push   %eax
80102140:	6a 0e                	push   $0xe
80102142:	e8 a9 02 00 00       	call   801023f0 <ioapicenable>
80102147:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010214a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010214f:	90                   	nop
80102150:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102151:	83 e0 c0             	and    $0xffffffc0,%eax
80102154:	3c 40                	cmp    $0x40,%al
80102156:	75 f8                	jne    80102150 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102158:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010215d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102162:	ee                   	out    %al,(%dx)
80102163:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102168:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010216d:	eb 06                	jmp    80102175 <ideinit+0x55>
8010216f:	90                   	nop
  for(i=0; i<1000; i++){
80102170:	83 e9 01             	sub    $0x1,%ecx
80102173:	74 0f                	je     80102184 <ideinit+0x64>
80102175:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102176:	84 c0                	test   %al,%al
80102178:	74 f6                	je     80102170 <ideinit+0x50>
      havedisk1 = 1;
8010217a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102181:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102184:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102189:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010218e:	ee                   	out    %al,(%dx)
}
8010218f:	c9                   	leave  
80102190:	c3                   	ret    
80102191:	eb 0d                	jmp    801021a0 <ideintr>
80102193:	90                   	nop
80102194:	90                   	nop
80102195:	90                   	nop
80102196:	90                   	nop
80102197:	90                   	nop
80102198:	90                   	nop
80102199:	90                   	nop
8010219a:	90                   	nop
8010219b:	90                   	nop
8010219c:	90                   	nop
8010219d:	90                   	nop
8010219e:	90                   	nop
8010219f:	90                   	nop

801021a0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021a0:	55                   	push   %ebp
801021a1:	89 e5                	mov    %esp,%ebp
801021a3:	57                   	push   %edi
801021a4:	56                   	push   %esi
801021a5:	53                   	push   %ebx
801021a6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021a9:	68 80 a5 10 80       	push   $0x8010a580
801021ae:	e8 4d 25 00 00       	call   80104700 <acquire>

  if((b = idequeue) == 0){
801021b3:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801021b9:	83 c4 10             	add    $0x10,%esp
801021bc:	85 db                	test   %ebx,%ebx
801021be:	74 67                	je     80102227 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801021c0:	8b 43 58             	mov    0x58(%ebx),%eax
801021c3:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801021c8:	8b 3b                	mov    (%ebx),%edi
801021ca:	f7 c7 04 00 00 00    	test   $0x4,%edi
801021d0:	75 31                	jne    80102203 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021d2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021d7:	89 f6                	mov    %esi,%esi
801021d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801021e0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e1:	89 c6                	mov    %eax,%esi
801021e3:	83 e6 c0             	and    $0xffffffc0,%esi
801021e6:	89 f1                	mov    %esi,%ecx
801021e8:	80 f9 40             	cmp    $0x40,%cl
801021eb:	75 f3                	jne    801021e0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801021ed:	a8 21                	test   $0x21,%al
801021ef:	75 12                	jne    80102203 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801021f1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801021f4:	b9 80 00 00 00       	mov    $0x80,%ecx
801021f9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021fe:	fc                   	cld    
801021ff:	f3 6d                	rep insl (%dx),%es:(%edi)
80102201:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102203:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102206:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102209:	89 f9                	mov    %edi,%ecx
8010220b:	83 c9 02             	or     $0x2,%ecx
8010220e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102210:	53                   	push   %ebx
80102211:	e8 ca 1e 00 00       	call   801040e0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102216:	a1 64 a5 10 80       	mov    0x8010a564,%eax
8010221b:	83 c4 10             	add    $0x10,%esp
8010221e:	85 c0                	test   %eax,%eax
80102220:	74 05                	je     80102227 <ideintr+0x87>
    idestart(idequeue);
80102222:	e8 19 fe ff ff       	call   80102040 <idestart>
    release(&idelock);
80102227:	83 ec 0c             	sub    $0xc,%esp
8010222a:	68 80 a5 10 80       	push   $0x8010a580
8010222f:	e8 8c 25 00 00       	call   801047c0 <release>

  release(&idelock);
}
80102234:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102237:	5b                   	pop    %ebx
80102238:	5e                   	pop    %esi
80102239:	5f                   	pop    %edi
8010223a:	5d                   	pop    %ebp
8010223b:	c3                   	ret    
8010223c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102240 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	53                   	push   %ebx
80102244:	83 ec 10             	sub    $0x10,%esp
80102247:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010224a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010224d:	50                   	push   %eax
8010224e:	e8 1d 23 00 00       	call   80104570 <holdingsleep>
80102253:	83 c4 10             	add    $0x10,%esp
80102256:	85 c0                	test   %eax,%eax
80102258:	0f 84 c6 00 00 00    	je     80102324 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010225e:	8b 03                	mov    (%ebx),%eax
80102260:	83 e0 06             	and    $0x6,%eax
80102263:	83 f8 02             	cmp    $0x2,%eax
80102266:	0f 84 ab 00 00 00    	je     80102317 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010226c:	8b 53 04             	mov    0x4(%ebx),%edx
8010226f:	85 d2                	test   %edx,%edx
80102271:	74 0d                	je     80102280 <iderw+0x40>
80102273:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102278:	85 c0                	test   %eax,%eax
8010227a:	0f 84 b1 00 00 00    	je     80102331 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102280:	83 ec 0c             	sub    $0xc,%esp
80102283:	68 80 a5 10 80       	push   $0x8010a580
80102288:	e8 73 24 00 00       	call   80104700 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010228d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102293:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102296:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010229d:	85 d2                	test   %edx,%edx
8010229f:	75 09                	jne    801022aa <iderw+0x6a>
801022a1:	eb 6d                	jmp    80102310 <iderw+0xd0>
801022a3:	90                   	nop
801022a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022a8:	89 c2                	mov    %eax,%edx
801022aa:	8b 42 58             	mov    0x58(%edx),%eax
801022ad:	85 c0                	test   %eax,%eax
801022af:	75 f7                	jne    801022a8 <iderw+0x68>
801022b1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801022b4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801022b6:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801022bc:	74 42                	je     80102300 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022be:	8b 03                	mov    (%ebx),%eax
801022c0:	83 e0 06             	and    $0x6,%eax
801022c3:	83 f8 02             	cmp    $0x2,%eax
801022c6:	74 23                	je     801022eb <iderw+0xab>
801022c8:	90                   	nop
801022c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801022d0:	83 ec 08             	sub    $0x8,%esp
801022d3:	68 80 a5 10 80       	push   $0x8010a580
801022d8:	53                   	push   %ebx
801022d9:	e8 42 1c 00 00       	call   80103f20 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022de:	8b 03                	mov    (%ebx),%eax
801022e0:	83 c4 10             	add    $0x10,%esp
801022e3:	83 e0 06             	and    $0x6,%eax
801022e6:	83 f8 02             	cmp    $0x2,%eax
801022e9:	75 e5                	jne    801022d0 <iderw+0x90>
  }


  release(&idelock);
801022eb:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801022f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022f5:	c9                   	leave  
  release(&idelock);
801022f6:	e9 c5 24 00 00       	jmp    801047c0 <release>
801022fb:	90                   	nop
801022fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102300:	89 d8                	mov    %ebx,%eax
80102302:	e8 39 fd ff ff       	call   80102040 <idestart>
80102307:	eb b5                	jmp    801022be <iderw+0x7e>
80102309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102310:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102315:	eb 9d                	jmp    801022b4 <iderw+0x74>
    panic("iderw: nothing to do");
80102317:	83 ec 0c             	sub    $0xc,%esp
8010231a:	68 1c 76 10 80       	push   $0x8010761c
8010231f:	e8 6c e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102324:	83 ec 0c             	sub    $0xc,%esp
80102327:	68 06 76 10 80       	push   $0x80107606
8010232c:	e8 5f e0 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102331:	83 ec 0c             	sub    $0xc,%esp
80102334:	68 31 76 10 80       	push   $0x80107631
80102339:	e8 52 e0 ff ff       	call   80100390 <panic>
8010233e:	66 90                	xchg   %ax,%ax

80102340 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102340:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102341:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102348:	00 c0 fe 
{
8010234b:	89 e5                	mov    %esp,%ebp
8010234d:	56                   	push   %esi
8010234e:	53                   	push   %ebx
  ioapic->reg = reg;
8010234f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102356:	00 00 00 
  return ioapic->data;
80102359:	a1 34 26 11 80       	mov    0x80112634,%eax
8010235e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102361:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102367:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010236d:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102374:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102377:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010237a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010237d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102380:	39 c2                	cmp    %eax,%edx
80102382:	74 16                	je     8010239a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102384:	83 ec 0c             	sub    $0xc,%esp
80102387:	68 50 76 10 80       	push   $0x80107650
8010238c:	e8 cf e2 ff ff       	call   80100660 <cprintf>
80102391:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102397:	83 c4 10             	add    $0x10,%esp
8010239a:	83 c3 21             	add    $0x21,%ebx
{
8010239d:	ba 10 00 00 00       	mov    $0x10,%edx
801023a2:	b8 20 00 00 00       	mov    $0x20,%eax
801023a7:	89 f6                	mov    %esi,%esi
801023a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801023b0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801023b2:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023b8:	89 c6                	mov    %eax,%esi
801023ba:	81 ce 00 00 01 00    	or     $0x10000,%esi
801023c0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801023c3:	89 71 10             	mov    %esi,0x10(%ecx)
801023c6:	8d 72 01             	lea    0x1(%edx),%esi
801023c9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801023cc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801023ce:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801023d0:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801023d6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801023dd:	75 d1                	jne    801023b0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801023df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023e2:	5b                   	pop    %ebx
801023e3:	5e                   	pop    %esi
801023e4:	5d                   	pop    %ebp
801023e5:	c3                   	ret    
801023e6:	8d 76 00             	lea    0x0(%esi),%esi
801023e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023f0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801023f0:	55                   	push   %ebp
  ioapic->reg = reg;
801023f1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801023f7:	89 e5                	mov    %esp,%ebp
801023f9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801023fc:	8d 50 20             	lea    0x20(%eax),%edx
801023ff:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102403:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102405:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010240b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010240e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102411:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102414:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102416:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010241b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010241e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102421:	5d                   	pop    %ebp
80102422:	c3                   	ret    
80102423:	66 90                	xchg   %ax,%ax
80102425:	66 90                	xchg   %ax,%ax
80102427:	66 90                	xchg   %ax,%ax
80102429:	66 90                	xchg   %ax,%ax
8010242b:	66 90                	xchg   %ax,%ax
8010242d:	66 90                	xchg   %ax,%ax
8010242f:	90                   	nop

80102430 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	53                   	push   %ebx
80102434:	83 ec 04             	sub    $0x4,%esp
80102437:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010243a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102440:	75 70                	jne    801024b2 <kfree+0x82>
80102442:	81 fb a8 58 11 80    	cmp    $0x801158a8,%ebx
80102448:	72 68                	jb     801024b2 <kfree+0x82>
8010244a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102450:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102455:	77 5b                	ja     801024b2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102457:	83 ec 04             	sub    $0x4,%esp
8010245a:	68 00 10 00 00       	push   $0x1000
8010245f:	6a 01                	push   $0x1
80102461:	53                   	push   %ebx
80102462:	e8 a9 23 00 00       	call   80104810 <memset>

  if(kmem.use_lock)
80102467:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010246d:	83 c4 10             	add    $0x10,%esp
80102470:	85 d2                	test   %edx,%edx
80102472:	75 2c                	jne    801024a0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102474:	a1 78 26 11 80       	mov    0x80112678,%eax
80102479:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010247b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102480:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102486:	85 c0                	test   %eax,%eax
80102488:	75 06                	jne    80102490 <kfree+0x60>
    release(&kmem.lock);
}
8010248a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010248d:	c9                   	leave  
8010248e:	c3                   	ret    
8010248f:	90                   	nop
    release(&kmem.lock);
80102490:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102497:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010249a:	c9                   	leave  
    release(&kmem.lock);
8010249b:	e9 20 23 00 00       	jmp    801047c0 <release>
    acquire(&kmem.lock);
801024a0:	83 ec 0c             	sub    $0xc,%esp
801024a3:	68 40 26 11 80       	push   $0x80112640
801024a8:	e8 53 22 00 00       	call   80104700 <acquire>
801024ad:	83 c4 10             	add    $0x10,%esp
801024b0:	eb c2                	jmp    80102474 <kfree+0x44>
    panic("kfree");
801024b2:	83 ec 0c             	sub    $0xc,%esp
801024b5:	68 82 76 10 80       	push   $0x80107682
801024ba:	e8 d1 de ff ff       	call   80100390 <panic>
801024bf:	90                   	nop

801024c0 <freerange>:
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	56                   	push   %esi
801024c4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801024c5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801024c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801024cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024dd:	39 de                	cmp    %ebx,%esi
801024df:	72 23                	jb     80102504 <freerange+0x44>
801024e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024e8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024ee:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024f7:	50                   	push   %eax
801024f8:	e8 33 ff ff ff       	call   80102430 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	39 f3                	cmp    %esi,%ebx
80102502:	76 e4                	jbe    801024e8 <freerange+0x28>
}
80102504:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102507:	5b                   	pop    %ebx
80102508:	5e                   	pop    %esi
80102509:	5d                   	pop    %ebp
8010250a:	c3                   	ret    
8010250b:	90                   	nop
8010250c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102510 <kinit1>:
{
80102510:	55                   	push   %ebp
80102511:	89 e5                	mov    %esp,%ebp
80102513:	56                   	push   %esi
80102514:	53                   	push   %ebx
80102515:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102518:	83 ec 08             	sub    $0x8,%esp
8010251b:	68 88 76 10 80       	push   $0x80107688
80102520:	68 40 26 11 80       	push   $0x80112640
80102525:	e8 96 20 00 00       	call   801045c0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010252a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010252d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102530:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102537:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010253a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102540:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102546:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010254c:	39 de                	cmp    %ebx,%esi
8010254e:	72 1c                	jb     8010256c <kinit1+0x5c>
    kfree(p);
80102550:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102556:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102559:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010255f:	50                   	push   %eax
80102560:	e8 cb fe ff ff       	call   80102430 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102565:	83 c4 10             	add    $0x10,%esp
80102568:	39 de                	cmp    %ebx,%esi
8010256a:	73 e4                	jae    80102550 <kinit1+0x40>
}
8010256c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010256f:	5b                   	pop    %ebx
80102570:	5e                   	pop    %esi
80102571:	5d                   	pop    %ebp
80102572:	c3                   	ret    
80102573:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102580 <kinit2>:
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	56                   	push   %esi
80102584:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102585:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102588:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010258b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102591:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102597:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010259d:	39 de                	cmp    %ebx,%esi
8010259f:	72 23                	jb     801025c4 <kinit2+0x44>
801025a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025a8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801025ae:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025b7:	50                   	push   %eax
801025b8:	e8 73 fe ff ff       	call   80102430 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025bd:	83 c4 10             	add    $0x10,%esp
801025c0:	39 de                	cmp    %ebx,%esi
801025c2:	73 e4                	jae    801025a8 <kinit2+0x28>
  kmem.use_lock = 1;
801025c4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801025cb:	00 00 00 
}
801025ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d1:	5b                   	pop    %ebx
801025d2:	5e                   	pop    %esi
801025d3:	5d                   	pop    %ebp
801025d4:	c3                   	ret    
801025d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025e0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801025e0:	a1 74 26 11 80       	mov    0x80112674,%eax
801025e5:	85 c0                	test   %eax,%eax
801025e7:	75 1f                	jne    80102608 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801025e9:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
801025ee:	85 c0                	test   %eax,%eax
801025f0:	74 0e                	je     80102600 <kalloc+0x20>
    kmem.freelist = r->next;
801025f2:	8b 10                	mov    (%eax),%edx
801025f4:	89 15 78 26 11 80    	mov    %edx,0x80112678
801025fa:	c3                   	ret    
801025fb:	90                   	nop
801025fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102600:	f3 c3                	repz ret 
80102602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102608:	55                   	push   %ebp
80102609:	89 e5                	mov    %esp,%ebp
8010260b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010260e:	68 40 26 11 80       	push   $0x80112640
80102613:	e8 e8 20 00 00       	call   80104700 <acquire>
  r = kmem.freelist;
80102618:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102626:	85 c0                	test   %eax,%eax
80102628:	74 08                	je     80102632 <kalloc+0x52>
    kmem.freelist = r->next;
8010262a:	8b 08                	mov    (%eax),%ecx
8010262c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102632:	85 d2                	test   %edx,%edx
80102634:	74 16                	je     8010264c <kalloc+0x6c>
    release(&kmem.lock);
80102636:	83 ec 0c             	sub    $0xc,%esp
80102639:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010263c:	68 40 26 11 80       	push   $0x80112640
80102641:	e8 7a 21 00 00       	call   801047c0 <release>
  return (char*)r;
80102646:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102649:	83 c4 10             	add    $0x10,%esp
}
8010264c:	c9                   	leave  
8010264d:	c3                   	ret    
8010264e:	66 90                	xchg   %ax,%ax

80102650 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102650:	ba 64 00 00 00       	mov    $0x64,%edx
80102655:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102656:	a8 01                	test   $0x1,%al
80102658:	0f 84 c2 00 00 00    	je     80102720 <kbdgetc+0xd0>
8010265e:	ba 60 00 00 00       	mov    $0x60,%edx
80102663:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102664:	0f b6 d0             	movzbl %al,%edx
80102667:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
8010266d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102673:	0f 84 7f 00 00 00    	je     801026f8 <kbdgetc+0xa8>
{
80102679:	55                   	push   %ebp
8010267a:	89 e5                	mov    %esp,%ebp
8010267c:	53                   	push   %ebx
8010267d:	89 cb                	mov    %ecx,%ebx
8010267f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102682:	84 c0                	test   %al,%al
80102684:	78 4a                	js     801026d0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102686:	85 db                	test   %ebx,%ebx
80102688:	74 09                	je     80102693 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010268a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010268d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102690:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102693:	0f b6 82 c0 77 10 80 	movzbl -0x7fef8840(%edx),%eax
8010269a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010269c:	0f b6 82 c0 76 10 80 	movzbl -0x7fef8940(%edx),%eax
801026a3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026a5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801026a7:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801026ad:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801026b0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026b3:	8b 04 85 a0 76 10 80 	mov    -0x7fef8960(,%eax,4),%eax
801026ba:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801026be:	74 31                	je     801026f1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801026c0:	8d 50 9f             	lea    -0x61(%eax),%edx
801026c3:	83 fa 19             	cmp    $0x19,%edx
801026c6:	77 40                	ja     80102708 <kbdgetc+0xb8>
      c += 'A' - 'a';
801026c8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801026cb:	5b                   	pop    %ebx
801026cc:	5d                   	pop    %ebp
801026cd:	c3                   	ret    
801026ce:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801026d0:	83 e0 7f             	and    $0x7f,%eax
801026d3:	85 db                	test   %ebx,%ebx
801026d5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801026d8:	0f b6 82 c0 77 10 80 	movzbl -0x7fef8840(%edx),%eax
801026df:	83 c8 40             	or     $0x40,%eax
801026e2:	0f b6 c0             	movzbl %al,%eax
801026e5:	f7 d0                	not    %eax
801026e7:	21 c1                	and    %eax,%ecx
    return 0;
801026e9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801026eb:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
801026f1:	5b                   	pop    %ebx
801026f2:	5d                   	pop    %ebp
801026f3:	c3                   	ret    
801026f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801026f8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801026fb:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801026fd:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
80102703:	c3                   	ret    
80102704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102708:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010270b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010270e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010270f:	83 f9 1a             	cmp    $0x1a,%ecx
80102712:	0f 42 c2             	cmovb  %edx,%eax
}
80102715:	5d                   	pop    %ebp
80102716:	c3                   	ret    
80102717:	89 f6                	mov    %esi,%esi
80102719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102720:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102725:	c3                   	ret    
80102726:	8d 76 00             	lea    0x0(%esi),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <kbdintr>:

void
kbdintr(void)
{
80102730:	55                   	push   %ebp
80102731:	89 e5                	mov    %esp,%ebp
80102733:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102736:	68 50 26 10 80       	push   $0x80102650
8010273b:	e8 d0 e0 ff ff       	call   80100810 <consoleintr>
}
80102740:	83 c4 10             	add    $0x10,%esp
80102743:	c9                   	leave  
80102744:	c3                   	ret    
80102745:	66 90                	xchg   %ax,%ax
80102747:	66 90                	xchg   %ax,%ax
80102749:	66 90                	xchg   %ax,%ax
8010274b:	66 90                	xchg   %ax,%ax
8010274d:	66 90                	xchg   %ax,%ax
8010274f:	90                   	nop

80102750 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102750:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102758:	85 c0                	test   %eax,%eax
8010275a:	0f 84 c8 00 00 00    	je     80102828 <lapicinit+0xd8>
  lapic[index] = value;
80102760:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102767:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010276a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010276d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102774:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102777:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010277a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102781:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102784:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102787:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010278e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102791:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102794:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010279b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010279e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027a1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801027a8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ab:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801027ae:	8b 50 30             	mov    0x30(%eax),%edx
801027b1:	c1 ea 10             	shr    $0x10,%edx
801027b4:	80 fa 03             	cmp    $0x3,%dl
801027b7:	77 77                	ja     80102830 <lapicinit+0xe0>
  lapic[index] = value;
801027b9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801027c0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027c3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027c6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027cd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027d3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027da:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027dd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027e7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ed:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801027f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027fa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102801:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102804:	8b 50 20             	mov    0x20(%eax),%edx
80102807:	89 f6                	mov    %esi,%esi
80102809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102810:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102816:	80 e6 10             	and    $0x10,%dh
80102819:	75 f5                	jne    80102810 <lapicinit+0xc0>
  lapic[index] = value;
8010281b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102822:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102825:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102828:	5d                   	pop    %ebp
80102829:	c3                   	ret    
8010282a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102830:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102837:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010283a:	8b 50 20             	mov    0x20(%eax),%edx
8010283d:	e9 77 ff ff ff       	jmp    801027b9 <lapicinit+0x69>
80102842:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102850 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102850:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
{
80102856:	55                   	push   %ebp
80102857:	31 c0                	xor    %eax,%eax
80102859:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010285b:	85 d2                	test   %edx,%edx
8010285d:	74 06                	je     80102865 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010285f:	8b 42 20             	mov    0x20(%edx),%eax
80102862:	c1 e8 18             	shr    $0x18,%eax
}
80102865:	5d                   	pop    %ebp
80102866:	c3                   	ret    
80102867:	89 f6                	mov    %esi,%esi
80102869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102870 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102870:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102875:	55                   	push   %ebp
80102876:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102878:	85 c0                	test   %eax,%eax
8010287a:	74 0d                	je     80102889 <lapiceoi+0x19>
  lapic[index] = value;
8010287c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102883:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102886:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102889:	5d                   	pop    %ebp
8010288a:	c3                   	ret    
8010288b:	90                   	nop
8010288c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102890 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102890:	55                   	push   %ebp
80102891:	89 e5                	mov    %esp,%ebp
}
80102893:	5d                   	pop    %ebp
80102894:	c3                   	ret    
80102895:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028a0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801028a0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a1:	b8 0f 00 00 00       	mov    $0xf,%eax
801028a6:	ba 70 00 00 00       	mov    $0x70,%edx
801028ab:	89 e5                	mov    %esp,%ebp
801028ad:	53                   	push   %ebx
801028ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801028b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801028b4:	ee                   	out    %al,(%dx)
801028b5:	b8 0a 00 00 00       	mov    $0xa,%eax
801028ba:	ba 71 00 00 00       	mov    $0x71,%edx
801028bf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801028c0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801028c2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801028c5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801028cb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801028cd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801028d0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801028d3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801028d5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801028d8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801028de:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028e3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028e9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028ec:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801028f3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028f6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028f9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102900:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102903:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102906:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010290c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010290f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102915:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102918:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010291e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102921:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102927:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010292a:	5b                   	pop    %ebx
8010292b:	5d                   	pop    %ebp
8010292c:	c3                   	ret    
8010292d:	8d 76 00             	lea    0x0(%esi),%esi

80102930 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102930:	55                   	push   %ebp
80102931:	b8 0b 00 00 00       	mov    $0xb,%eax
80102936:	ba 70 00 00 00       	mov    $0x70,%edx
8010293b:	89 e5                	mov    %esp,%ebp
8010293d:	57                   	push   %edi
8010293e:	56                   	push   %esi
8010293f:	53                   	push   %ebx
80102940:	83 ec 4c             	sub    $0x4c,%esp
80102943:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102944:	ba 71 00 00 00       	mov    $0x71,%edx
80102949:	ec                   	in     (%dx),%al
8010294a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010294d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102952:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102955:	8d 76 00             	lea    0x0(%esi),%esi
80102958:	31 c0                	xor    %eax,%eax
8010295a:	89 da                	mov    %ebx,%edx
8010295c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010295d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102962:	89 ca                	mov    %ecx,%edx
80102964:	ec                   	in     (%dx),%al
80102965:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102968:	89 da                	mov    %ebx,%edx
8010296a:	b8 02 00 00 00       	mov    $0x2,%eax
8010296f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102970:	89 ca                	mov    %ecx,%edx
80102972:	ec                   	in     (%dx),%al
80102973:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102976:	89 da                	mov    %ebx,%edx
80102978:	b8 04 00 00 00       	mov    $0x4,%eax
8010297d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010297e:	89 ca                	mov    %ecx,%edx
80102980:	ec                   	in     (%dx),%al
80102981:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102984:	89 da                	mov    %ebx,%edx
80102986:	b8 07 00 00 00       	mov    $0x7,%eax
8010298b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010298c:	89 ca                	mov    %ecx,%edx
8010298e:	ec                   	in     (%dx),%al
8010298f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102992:	89 da                	mov    %ebx,%edx
80102994:	b8 08 00 00 00       	mov    $0x8,%eax
80102999:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010299a:	89 ca                	mov    %ecx,%edx
8010299c:	ec                   	in     (%dx),%al
8010299d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010299f:	89 da                	mov    %ebx,%edx
801029a1:	b8 09 00 00 00       	mov    $0x9,%eax
801029a6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029a7:	89 ca                	mov    %ecx,%edx
801029a9:	ec                   	in     (%dx),%al
801029aa:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ac:	89 da                	mov    %ebx,%edx
801029ae:	b8 0a 00 00 00       	mov    $0xa,%eax
801029b3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029b4:	89 ca                	mov    %ecx,%edx
801029b6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801029b7:	84 c0                	test   %al,%al
801029b9:	78 9d                	js     80102958 <cmostime+0x28>
  return inb(CMOS_RETURN);
801029bb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801029bf:	89 fa                	mov    %edi,%edx
801029c1:	0f b6 fa             	movzbl %dl,%edi
801029c4:	89 f2                	mov    %esi,%edx
801029c6:	0f b6 f2             	movzbl %dl,%esi
801029c9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029cc:	89 da                	mov    %ebx,%edx
801029ce:	89 75 cc             	mov    %esi,-0x34(%ebp)
801029d1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801029d4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801029d8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801029db:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801029df:	89 45 c0             	mov    %eax,-0x40(%ebp)
801029e2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801029e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801029e9:	31 c0                	xor    %eax,%eax
801029eb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ec:	89 ca                	mov    %ecx,%edx
801029ee:	ec                   	in     (%dx),%al
801029ef:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f2:	89 da                	mov    %ebx,%edx
801029f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801029f7:	b8 02 00 00 00       	mov    $0x2,%eax
801029fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fd:	89 ca                	mov    %ecx,%edx
801029ff:	ec                   	in     (%dx),%al
80102a00:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a03:	89 da                	mov    %ebx,%edx
80102a05:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a08:	b8 04 00 00 00       	mov    $0x4,%eax
80102a0d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0e:	89 ca                	mov    %ecx,%edx
80102a10:	ec                   	in     (%dx),%al
80102a11:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a14:	89 da                	mov    %ebx,%edx
80102a16:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a19:	b8 07 00 00 00       	mov    $0x7,%eax
80102a1e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1f:	89 ca                	mov    %ecx,%edx
80102a21:	ec                   	in     (%dx),%al
80102a22:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a25:	89 da                	mov    %ebx,%edx
80102a27:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a2a:	b8 08 00 00 00       	mov    $0x8,%eax
80102a2f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a30:	89 ca                	mov    %ecx,%edx
80102a32:	ec                   	in     (%dx),%al
80102a33:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a36:	89 da                	mov    %ebx,%edx
80102a38:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102a3b:	b8 09 00 00 00       	mov    $0x9,%eax
80102a40:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a41:	89 ca                	mov    %ecx,%edx
80102a43:	ec                   	in     (%dx),%al
80102a44:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a47:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102a4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a4d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102a50:	6a 18                	push   $0x18
80102a52:	50                   	push   %eax
80102a53:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102a56:	50                   	push   %eax
80102a57:	e8 04 1e 00 00       	call   80104860 <memcmp>
80102a5c:	83 c4 10             	add    $0x10,%esp
80102a5f:	85 c0                	test   %eax,%eax
80102a61:	0f 85 f1 fe ff ff    	jne    80102958 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102a67:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102a6b:	75 78                	jne    80102ae5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102a6d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a70:	89 c2                	mov    %eax,%edx
80102a72:	83 e0 0f             	and    $0xf,%eax
80102a75:	c1 ea 04             	shr    $0x4,%edx
80102a78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a7e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102a81:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a84:	89 c2                	mov    %eax,%edx
80102a86:	83 e0 0f             	and    $0xf,%eax
80102a89:	c1 ea 04             	shr    $0x4,%edx
80102a8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a92:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102a95:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a98:	89 c2                	mov    %eax,%edx
80102a9a:	83 e0 0f             	and    $0xf,%eax
80102a9d:	c1 ea 04             	shr    $0x4,%edx
80102aa0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102aa3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102aa6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102aa9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102aac:	89 c2                	mov    %eax,%edx
80102aae:	83 e0 0f             	and    $0xf,%eax
80102ab1:	c1 ea 04             	shr    $0x4,%edx
80102ab4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ab7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102aba:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102abd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ac0:	89 c2                	mov    %eax,%edx
80102ac2:	83 e0 0f             	and    $0xf,%eax
80102ac5:	c1 ea 04             	shr    $0x4,%edx
80102ac8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102acb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ace:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102ad1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ad4:	89 c2                	mov    %eax,%edx
80102ad6:	83 e0 0f             	and    $0xf,%eax
80102ad9:	c1 ea 04             	shr    $0x4,%edx
80102adc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102adf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ae2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ae5:	8b 75 08             	mov    0x8(%ebp),%esi
80102ae8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102aeb:	89 06                	mov    %eax,(%esi)
80102aed:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102af0:	89 46 04             	mov    %eax,0x4(%esi)
80102af3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102af6:	89 46 08             	mov    %eax,0x8(%esi)
80102af9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102afc:	89 46 0c             	mov    %eax,0xc(%esi)
80102aff:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b02:	89 46 10             	mov    %eax,0x10(%esi)
80102b05:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b08:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b0b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b15:	5b                   	pop    %ebx
80102b16:	5e                   	pop    %esi
80102b17:	5f                   	pop    %edi
80102b18:	5d                   	pop    %ebp
80102b19:	c3                   	ret    
80102b1a:	66 90                	xchg   %ax,%ax
80102b1c:	66 90                	xchg   %ax,%ax
80102b1e:	66 90                	xchg   %ax,%ax

80102b20 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b20:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102b26:	85 c9                	test   %ecx,%ecx
80102b28:	0f 8e 8a 00 00 00    	jle    80102bb8 <install_trans+0x98>
{
80102b2e:	55                   	push   %ebp
80102b2f:	89 e5                	mov    %esp,%ebp
80102b31:	57                   	push   %edi
80102b32:	56                   	push   %esi
80102b33:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102b34:	31 db                	xor    %ebx,%ebx
{
80102b36:	83 ec 0c             	sub    $0xc,%esp
80102b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102b40:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102b45:	83 ec 08             	sub    $0x8,%esp
80102b48:	01 d8                	add    %ebx,%eax
80102b4a:	83 c0 01             	add    $0x1,%eax
80102b4d:	50                   	push   %eax
80102b4e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102b54:	e8 77 d5 ff ff       	call   801000d0 <bread>
80102b59:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b5b:	58                   	pop    %eax
80102b5c:	5a                   	pop    %edx
80102b5d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102b64:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102b6a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b6d:	e8 5e d5 ff ff       	call   801000d0 <bread>
80102b72:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b74:	8d 47 5c             	lea    0x5c(%edi),%eax
80102b77:	83 c4 0c             	add    $0xc,%esp
80102b7a:	68 00 02 00 00       	push   $0x200
80102b7f:	50                   	push   %eax
80102b80:	8d 46 5c             	lea    0x5c(%esi),%eax
80102b83:	50                   	push   %eax
80102b84:	e8 37 1d 00 00       	call   801048c0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102b89:	89 34 24             	mov    %esi,(%esp)
80102b8c:	e8 0f d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102b91:	89 3c 24             	mov    %edi,(%esp)
80102b94:	e8 47 d6 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102b99:	89 34 24             	mov    %esi,(%esp)
80102b9c:	e8 3f d6 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ba1:	83 c4 10             	add    $0x10,%esp
80102ba4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102baa:	7f 94                	jg     80102b40 <install_trans+0x20>
  }
}
80102bac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102baf:	5b                   	pop    %ebx
80102bb0:	5e                   	pop    %esi
80102bb1:	5f                   	pop    %edi
80102bb2:	5d                   	pop    %ebp
80102bb3:	c3                   	ret    
80102bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bb8:	f3 c3                	repz ret 
80102bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102bc0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	56                   	push   %esi
80102bc4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102bc5:	83 ec 08             	sub    $0x8,%esp
80102bc8:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102bce:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102bd4:	e8 f7 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102bd9:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102bdf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102be2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102be4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102be6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102be9:	7e 16                	jle    80102c01 <write_head+0x41>
80102beb:	c1 e3 02             	shl    $0x2,%ebx
80102bee:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102bf0:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102bf6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102bfa:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102bfd:	39 da                	cmp    %ebx,%edx
80102bff:	75 ef                	jne    80102bf0 <write_head+0x30>
  }
  bwrite(buf);
80102c01:	83 ec 0c             	sub    $0xc,%esp
80102c04:	56                   	push   %esi
80102c05:	e8 96 d5 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102c0a:	89 34 24             	mov    %esi,(%esp)
80102c0d:	e8 ce d5 ff ff       	call   801001e0 <brelse>
}
80102c12:	83 c4 10             	add    $0x10,%esp
80102c15:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c18:	5b                   	pop    %ebx
80102c19:	5e                   	pop    %esi
80102c1a:	5d                   	pop    %ebp
80102c1b:	c3                   	ret    
80102c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c20 <initlog>:
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	53                   	push   %ebx
80102c24:	83 ec 2c             	sub    $0x2c,%esp
80102c27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102c2a:	68 c0 78 10 80       	push   $0x801078c0
80102c2f:	68 80 26 11 80       	push   $0x80112680
80102c34:	e8 87 19 00 00       	call   801045c0 <initlock>
  readsb(dev, &sb);
80102c39:	58                   	pop    %eax
80102c3a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102c3d:	5a                   	pop    %edx
80102c3e:	50                   	push   %eax
80102c3f:	53                   	push   %ebx
80102c40:	e8 8b e7 ff ff       	call   801013d0 <readsb>
  log.size = sb.nlog;
80102c45:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102c48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102c4b:	59                   	pop    %ecx
  log.dev = dev;
80102c4c:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102c52:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102c58:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102c5d:	5a                   	pop    %edx
80102c5e:	50                   	push   %eax
80102c5f:	53                   	push   %ebx
80102c60:	e8 6b d4 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102c65:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102c68:	83 c4 10             	add    $0x10,%esp
80102c6b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102c6d:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102c73:	7e 1c                	jle    80102c91 <initlog+0x71>
80102c75:	c1 e3 02             	shl    $0x2,%ebx
80102c78:	31 d2                	xor    %edx,%edx
80102c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102c80:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102c84:	83 c2 04             	add    $0x4,%edx
80102c87:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102c8d:	39 d3                	cmp    %edx,%ebx
80102c8f:	75 ef                	jne    80102c80 <initlog+0x60>
  brelse(buf);
80102c91:	83 ec 0c             	sub    $0xc,%esp
80102c94:	50                   	push   %eax
80102c95:	e8 46 d5 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102c9a:	e8 81 fe ff ff       	call   80102b20 <install_trans>
  log.lh.n = 0;
80102c9f:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102ca6:	00 00 00 
  write_head(); // clear the log
80102ca9:	e8 12 ff ff ff       	call   80102bc0 <write_head>
}
80102cae:	83 c4 10             	add    $0x10,%esp
80102cb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cb4:	c9                   	leave  
80102cb5:	c3                   	ret    
80102cb6:	8d 76 00             	lea    0x0(%esi),%esi
80102cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cc0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102cc6:	68 80 26 11 80       	push   $0x80112680
80102ccb:	e8 30 1a 00 00       	call   80104700 <acquire>
80102cd0:	83 c4 10             	add    $0x10,%esp
80102cd3:	eb 18                	jmp    80102ced <begin_op+0x2d>
80102cd5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102cd8:	83 ec 08             	sub    $0x8,%esp
80102cdb:	68 80 26 11 80       	push   $0x80112680
80102ce0:	68 80 26 11 80       	push   $0x80112680
80102ce5:	e8 36 12 00 00       	call   80103f20 <sleep>
80102cea:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102ced:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102cf2:	85 c0                	test   %eax,%eax
80102cf4:	75 e2                	jne    80102cd8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102cf6:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102cfb:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d01:	83 c0 01             	add    $0x1,%eax
80102d04:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d07:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d0a:	83 fa 1e             	cmp    $0x1e,%edx
80102d0d:	7f c9                	jg     80102cd8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d0f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d12:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102d17:	68 80 26 11 80       	push   $0x80112680
80102d1c:	e8 9f 1a 00 00       	call   801047c0 <release>
      break;
    }
  }
}
80102d21:	83 c4 10             	add    $0x10,%esp
80102d24:	c9                   	leave  
80102d25:	c3                   	ret    
80102d26:	8d 76 00             	lea    0x0(%esi),%esi
80102d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d30 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102d30:	55                   	push   %ebp
80102d31:	89 e5                	mov    %esp,%ebp
80102d33:	57                   	push   %edi
80102d34:	56                   	push   %esi
80102d35:	53                   	push   %ebx
80102d36:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102d39:	68 80 26 11 80       	push   $0x80112680
80102d3e:	e8 bd 19 00 00       	call   80104700 <acquire>
  log.outstanding -= 1;
80102d43:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102d48:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102d4e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102d51:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102d54:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102d56:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102d5c:	0f 85 1a 01 00 00    	jne    80102e7c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102d62:	85 db                	test   %ebx,%ebx
80102d64:	0f 85 ee 00 00 00    	jne    80102e58 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102d6a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102d6d:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102d74:	00 00 00 
  release(&log.lock);
80102d77:	68 80 26 11 80       	push   $0x80112680
80102d7c:	e8 3f 1a 00 00       	call   801047c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102d81:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102d87:	83 c4 10             	add    $0x10,%esp
80102d8a:	85 c9                	test   %ecx,%ecx
80102d8c:	0f 8e 85 00 00 00    	jle    80102e17 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102d92:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102d97:	83 ec 08             	sub    $0x8,%esp
80102d9a:	01 d8                	add    %ebx,%eax
80102d9c:	83 c0 01             	add    $0x1,%eax
80102d9f:	50                   	push   %eax
80102da0:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102da6:	e8 25 d3 ff ff       	call   801000d0 <bread>
80102dab:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102dad:	58                   	pop    %eax
80102dae:	5a                   	pop    %edx
80102daf:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102db6:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102dbc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102dbf:	e8 0c d3 ff ff       	call   801000d0 <bread>
80102dc4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102dc6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102dc9:	83 c4 0c             	add    $0xc,%esp
80102dcc:	68 00 02 00 00       	push   $0x200
80102dd1:	50                   	push   %eax
80102dd2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102dd5:	50                   	push   %eax
80102dd6:	e8 e5 1a 00 00       	call   801048c0 <memmove>
    bwrite(to);  // write the log
80102ddb:	89 34 24             	mov    %esi,(%esp)
80102dde:	e8 bd d3 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102de3:	89 3c 24             	mov    %edi,(%esp)
80102de6:	e8 f5 d3 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102deb:	89 34 24             	mov    %esi,(%esp)
80102dee:	e8 ed d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102df3:	83 c4 10             	add    $0x10,%esp
80102df6:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102dfc:	7c 94                	jl     80102d92 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102dfe:	e8 bd fd ff ff       	call   80102bc0 <write_head>
    install_trans(); // Now install writes to home locations
80102e03:	e8 18 fd ff ff       	call   80102b20 <install_trans>
    log.lh.n = 0;
80102e08:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102e0f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102e12:	e8 a9 fd ff ff       	call   80102bc0 <write_head>
    acquire(&log.lock);
80102e17:	83 ec 0c             	sub    $0xc,%esp
80102e1a:	68 80 26 11 80       	push   $0x80112680
80102e1f:	e8 dc 18 00 00       	call   80104700 <acquire>
    wakeup(&log);
80102e24:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102e2b:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102e32:	00 00 00 
    wakeup(&log);
80102e35:	e8 a6 12 00 00       	call   801040e0 <wakeup>
    release(&log.lock);
80102e3a:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e41:	e8 7a 19 00 00       	call   801047c0 <release>
80102e46:	83 c4 10             	add    $0x10,%esp
}
80102e49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e4c:	5b                   	pop    %ebx
80102e4d:	5e                   	pop    %esi
80102e4e:	5f                   	pop    %edi
80102e4f:	5d                   	pop    %ebp
80102e50:	c3                   	ret    
80102e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102e58:	83 ec 0c             	sub    $0xc,%esp
80102e5b:	68 80 26 11 80       	push   $0x80112680
80102e60:	e8 7b 12 00 00       	call   801040e0 <wakeup>
  release(&log.lock);
80102e65:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e6c:	e8 4f 19 00 00       	call   801047c0 <release>
80102e71:	83 c4 10             	add    $0x10,%esp
}
80102e74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e77:	5b                   	pop    %ebx
80102e78:	5e                   	pop    %esi
80102e79:	5f                   	pop    %edi
80102e7a:	5d                   	pop    %ebp
80102e7b:	c3                   	ret    
    panic("log.committing");
80102e7c:	83 ec 0c             	sub    $0xc,%esp
80102e7f:	68 c4 78 10 80       	push   $0x801078c4
80102e84:	e8 07 d5 ff ff       	call   80100390 <panic>
80102e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e90 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	53                   	push   %ebx
80102e94:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e97:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102e9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ea0:	83 fa 1d             	cmp    $0x1d,%edx
80102ea3:	0f 8f 9d 00 00 00    	jg     80102f46 <log_write+0xb6>
80102ea9:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102eae:	83 e8 01             	sub    $0x1,%eax
80102eb1:	39 c2                	cmp    %eax,%edx
80102eb3:	0f 8d 8d 00 00 00    	jge    80102f46 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102eb9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102ebe:	85 c0                	test   %eax,%eax
80102ec0:	0f 8e 8d 00 00 00    	jle    80102f53 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102ec6:	83 ec 0c             	sub    $0xc,%esp
80102ec9:	68 80 26 11 80       	push   $0x80112680
80102ece:	e8 2d 18 00 00       	call   80104700 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102ed3:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102ed9:	83 c4 10             	add    $0x10,%esp
80102edc:	83 f9 00             	cmp    $0x0,%ecx
80102edf:	7e 57                	jle    80102f38 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ee1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102ee4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ee6:	3b 15 cc 26 11 80    	cmp    0x801126cc,%edx
80102eec:	75 0b                	jne    80102ef9 <log_write+0x69>
80102eee:	eb 38                	jmp    80102f28 <log_write+0x98>
80102ef0:	39 14 85 cc 26 11 80 	cmp    %edx,-0x7feed934(,%eax,4)
80102ef7:	74 2f                	je     80102f28 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102ef9:	83 c0 01             	add    $0x1,%eax
80102efc:	39 c1                	cmp    %eax,%ecx
80102efe:	75 f0                	jne    80102ef0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f00:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102f07:	83 c0 01             	add    $0x1,%eax
80102f0a:	a3 c8 26 11 80       	mov    %eax,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102f0f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102f12:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102f19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f1c:	c9                   	leave  
  release(&log.lock);
80102f1d:	e9 9e 18 00 00       	jmp    801047c0 <release>
80102f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102f28:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
80102f2f:	eb de                	jmp    80102f0f <log_write+0x7f>
80102f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f38:	8b 43 08             	mov    0x8(%ebx),%eax
80102f3b:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102f40:	75 cd                	jne    80102f0f <log_write+0x7f>
80102f42:	31 c0                	xor    %eax,%eax
80102f44:	eb c1                	jmp    80102f07 <log_write+0x77>
    panic("too big a transaction");
80102f46:	83 ec 0c             	sub    $0xc,%esp
80102f49:	68 d3 78 10 80       	push   $0x801078d3
80102f4e:	e8 3d d4 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102f53:	83 ec 0c             	sub    $0xc,%esp
80102f56:	68 e9 78 10 80       	push   $0x801078e9
80102f5b:	e8 30 d4 ff ff       	call   80100390 <panic>

80102f60 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102f60:	55                   	push   %ebp
80102f61:	89 e5                	mov    %esp,%ebp
80102f63:	53                   	push   %ebx
80102f64:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102f67:	e8 a4 09 00 00       	call   80103910 <cpuid>
80102f6c:	89 c3                	mov    %eax,%ebx
80102f6e:	e8 9d 09 00 00       	call   80103910 <cpuid>
80102f73:	83 ec 04             	sub    $0x4,%esp
80102f76:	53                   	push   %ebx
80102f77:	50                   	push   %eax
80102f78:	68 04 79 10 80       	push   $0x80107904
80102f7d:	e8 de d6 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102f82:	e8 79 2c 00 00       	call   80105c00 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102f87:	e8 04 09 00 00       	call   80103890 <mycpu>
80102f8c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102f8e:	b8 01 00 00 00       	mov    $0x1,%eax
80102f93:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102f9a:	e8 a1 0c 00 00       	call   80103c40 <scheduler>
80102f9f:	90                   	nop

80102fa0 <mpenter>:
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102fa6:	e8 55 3d 00 00       	call   80106d00 <switchkvm>
  seginit();
80102fab:	e8 c0 3c 00 00       	call   80106c70 <seginit>
  lapicinit();
80102fb0:	e8 9b f7 ff ff       	call   80102750 <lapicinit>
  mpmain();
80102fb5:	e8 a6 ff ff ff       	call   80102f60 <mpmain>
80102fba:	66 90                	xchg   %ax,%ax
80102fbc:	66 90                	xchg   %ax,%ax
80102fbe:	66 90                	xchg   %ax,%ax

80102fc0 <main>:
{
80102fc0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102fc4:	83 e4 f0             	and    $0xfffffff0,%esp
80102fc7:	ff 71 fc             	pushl  -0x4(%ecx)
80102fca:	55                   	push   %ebp
80102fcb:	89 e5                	mov    %esp,%ebp
80102fcd:	53                   	push   %ebx
80102fce:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102fcf:	83 ec 08             	sub    $0x8,%esp
80102fd2:	68 00 00 40 80       	push   $0x80400000
80102fd7:	68 a8 58 11 80       	push   $0x801158a8
80102fdc:	e8 2f f5 ff ff       	call   80102510 <kinit1>
  kvmalloc();      // kernel page table
80102fe1:	e8 ea 41 00 00       	call   801071d0 <kvmalloc>
  mpinit();        // detect other processors
80102fe6:	e8 75 01 00 00       	call   80103160 <mpinit>
  lapicinit();     // interrupt controller
80102feb:	e8 60 f7 ff ff       	call   80102750 <lapicinit>
  seginit();       // segment descriptors
80102ff0:	e8 7b 3c 00 00       	call   80106c70 <seginit>
  picinit();       // disable pic
80102ff5:	e8 46 03 00 00       	call   80103340 <picinit>
  ioapicinit();    // another interrupt controller
80102ffa:	e8 41 f3 ff ff       	call   80102340 <ioapicinit>
  consoleinit();   // console hardware
80102fff:	e8 bc d9 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103004:	e8 37 2f 00 00       	call   80105f40 <uartinit>
  pinit();         // process table
80103009:	e8 62 08 00 00       	call   80103870 <pinit>
  tvinit();        // trap vectors
8010300e:	e8 6d 2b 00 00       	call   80105b80 <tvinit>
  binit();         // buffer cache
80103013:	e8 28 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103018:	e8 43 dd ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
8010301d:	e8 fe f0 ff ff       	call   80102120 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103022:	83 c4 0c             	add    $0xc,%esp
80103025:	68 8a 00 00 00       	push   $0x8a
8010302a:	68 8c a4 10 80       	push   $0x8010a48c
8010302f:	68 00 70 00 80       	push   $0x80007000
80103034:	e8 87 18 00 00       	call   801048c0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103039:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103040:	00 00 00 
80103043:	83 c4 10             	add    $0x10,%esp
80103046:	05 80 27 11 80       	add    $0x80112780,%eax
8010304b:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80103050:	76 71                	jbe    801030c3 <main+0x103>
80103052:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80103057:	89 f6                	mov    %esi,%esi
80103059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103060:	e8 2b 08 00 00       	call   80103890 <mycpu>
80103065:	39 d8                	cmp    %ebx,%eax
80103067:	74 41                	je     801030aa <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103069:	e8 72 f5 ff ff       	call   801025e0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010306e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103073:	c7 05 f8 6f 00 80 a0 	movl   $0x80102fa0,0x80006ff8
8010307a:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010307d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80103084:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103087:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010308c:	0f b6 03             	movzbl (%ebx),%eax
8010308f:	83 ec 08             	sub    $0x8,%esp
80103092:	68 00 70 00 00       	push   $0x7000
80103097:	50                   	push   %eax
80103098:	e8 03 f8 ff ff       	call   801028a0 <lapicstartap>
8010309d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801030a0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801030a6:	85 c0                	test   %eax,%eax
801030a8:	74 f6                	je     801030a0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
801030aa:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801030b1:	00 00 00 
801030b4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801030ba:	05 80 27 11 80       	add    $0x80112780,%eax
801030bf:	39 c3                	cmp    %eax,%ebx
801030c1:	72 9d                	jb     80103060 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801030c3:	83 ec 08             	sub    $0x8,%esp
801030c6:	68 00 00 00 8e       	push   $0x8e000000
801030cb:	68 00 00 40 80       	push   $0x80400000
801030d0:	e8 ab f4 ff ff       	call   80102580 <kinit2>
  userinit();      // first user process
801030d5:	e8 86 08 00 00       	call   80103960 <userinit>
  mpmain();        // finish this processor's setup
801030da:	e8 81 fe ff ff       	call   80102f60 <mpmain>
801030df:	90                   	nop

801030e0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801030e0:	55                   	push   %ebp
801030e1:	89 e5                	mov    %esp,%ebp
801030e3:	57                   	push   %edi
801030e4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801030e5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801030eb:	53                   	push   %ebx
  e = addr+len;
801030ec:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801030ef:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801030f2:	39 de                	cmp    %ebx,%esi
801030f4:	72 10                	jb     80103106 <mpsearch1+0x26>
801030f6:	eb 50                	jmp    80103148 <mpsearch1+0x68>
801030f8:	90                   	nop
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	39 fb                	cmp    %edi,%ebx
80103102:	89 fe                	mov    %edi,%esi
80103104:	76 42                	jbe    80103148 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103106:	83 ec 04             	sub    $0x4,%esp
80103109:	8d 7e 10             	lea    0x10(%esi),%edi
8010310c:	6a 04                	push   $0x4
8010310e:	68 18 79 10 80       	push   $0x80107918
80103113:	56                   	push   %esi
80103114:	e8 47 17 00 00       	call   80104860 <memcmp>
80103119:	83 c4 10             	add    $0x10,%esp
8010311c:	85 c0                	test   %eax,%eax
8010311e:	75 e0                	jne    80103100 <mpsearch1+0x20>
80103120:	89 f1                	mov    %esi,%ecx
80103122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103128:	0f b6 11             	movzbl (%ecx),%edx
8010312b:	83 c1 01             	add    $0x1,%ecx
8010312e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103130:	39 f9                	cmp    %edi,%ecx
80103132:	75 f4                	jne    80103128 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103134:	84 c0                	test   %al,%al
80103136:	75 c8                	jne    80103100 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103138:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010313b:	89 f0                	mov    %esi,%eax
8010313d:	5b                   	pop    %ebx
8010313e:	5e                   	pop    %esi
8010313f:	5f                   	pop    %edi
80103140:	5d                   	pop    %ebp
80103141:	c3                   	ret    
80103142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103148:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010314b:	31 f6                	xor    %esi,%esi
}
8010314d:	89 f0                	mov    %esi,%eax
8010314f:	5b                   	pop    %ebx
80103150:	5e                   	pop    %esi
80103151:	5f                   	pop    %edi
80103152:	5d                   	pop    %ebp
80103153:	c3                   	ret    
80103154:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010315a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103160 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	57                   	push   %edi
80103164:	56                   	push   %esi
80103165:	53                   	push   %ebx
80103166:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103169:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103170:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103177:	c1 e0 08             	shl    $0x8,%eax
8010317a:	09 d0                	or     %edx,%eax
8010317c:	c1 e0 04             	shl    $0x4,%eax
8010317f:	85 c0                	test   %eax,%eax
80103181:	75 1b                	jne    8010319e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103183:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010318a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103191:	c1 e0 08             	shl    $0x8,%eax
80103194:	09 d0                	or     %edx,%eax
80103196:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103199:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010319e:	ba 00 04 00 00       	mov    $0x400,%edx
801031a3:	e8 38 ff ff ff       	call   801030e0 <mpsearch1>
801031a8:	85 c0                	test   %eax,%eax
801031aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801031ad:	0f 84 3d 01 00 00    	je     801032f0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031b6:	8b 58 04             	mov    0x4(%eax),%ebx
801031b9:	85 db                	test   %ebx,%ebx
801031bb:	0f 84 4f 01 00 00    	je     80103310 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801031c1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801031c7:	83 ec 04             	sub    $0x4,%esp
801031ca:	6a 04                	push   $0x4
801031cc:	68 35 79 10 80       	push   $0x80107935
801031d1:	56                   	push   %esi
801031d2:	e8 89 16 00 00       	call   80104860 <memcmp>
801031d7:	83 c4 10             	add    $0x10,%esp
801031da:	85 c0                	test   %eax,%eax
801031dc:	0f 85 2e 01 00 00    	jne    80103310 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801031e2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801031e9:	3c 01                	cmp    $0x1,%al
801031eb:	0f 95 c2             	setne  %dl
801031ee:	3c 04                	cmp    $0x4,%al
801031f0:	0f 95 c0             	setne  %al
801031f3:	20 c2                	and    %al,%dl
801031f5:	0f 85 15 01 00 00    	jne    80103310 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801031fb:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103202:	66 85 ff             	test   %di,%di
80103205:	74 1a                	je     80103221 <mpinit+0xc1>
80103207:	89 f0                	mov    %esi,%eax
80103209:	01 f7                	add    %esi,%edi
  sum = 0;
8010320b:	31 d2                	xor    %edx,%edx
8010320d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103210:	0f b6 08             	movzbl (%eax),%ecx
80103213:	83 c0 01             	add    $0x1,%eax
80103216:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103218:	39 c7                	cmp    %eax,%edi
8010321a:	75 f4                	jne    80103210 <mpinit+0xb0>
8010321c:	84 d2                	test   %dl,%dl
8010321e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103221:	85 f6                	test   %esi,%esi
80103223:	0f 84 e7 00 00 00    	je     80103310 <mpinit+0x1b0>
80103229:	84 d2                	test   %dl,%dl
8010322b:	0f 85 df 00 00 00    	jne    80103310 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103231:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103237:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010323c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103243:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103249:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010324e:	01 d6                	add    %edx,%esi
80103250:	39 c6                	cmp    %eax,%esi
80103252:	76 23                	jbe    80103277 <mpinit+0x117>
    switch(*p){
80103254:	0f b6 10             	movzbl (%eax),%edx
80103257:	80 fa 04             	cmp    $0x4,%dl
8010325a:	0f 87 ca 00 00 00    	ja     8010332a <mpinit+0x1ca>
80103260:	ff 24 95 5c 79 10 80 	jmp    *-0x7fef86a4(,%edx,4)
80103267:	89 f6                	mov    %esi,%esi
80103269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103270:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103273:	39 c6                	cmp    %eax,%esi
80103275:	77 dd                	ja     80103254 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103277:	85 db                	test   %ebx,%ebx
80103279:	0f 84 9e 00 00 00    	je     8010331d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010327f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103282:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103286:	74 15                	je     8010329d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103288:	b8 70 00 00 00       	mov    $0x70,%eax
8010328d:	ba 22 00 00 00       	mov    $0x22,%edx
80103292:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103293:	ba 23 00 00 00       	mov    $0x23,%edx
80103298:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103299:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010329c:	ee                   	out    %al,(%dx)
  }
}
8010329d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032a0:	5b                   	pop    %ebx
801032a1:	5e                   	pop    %esi
801032a2:	5f                   	pop    %edi
801032a3:	5d                   	pop    %ebp
801032a4:	c3                   	ret    
801032a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801032a8:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
801032ae:	83 f9 07             	cmp    $0x7,%ecx
801032b1:	7f 19                	jg     801032cc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801032b3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801032b7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801032bd:	83 c1 01             	add    $0x1,%ecx
801032c0:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801032c6:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
801032cc:	83 c0 14             	add    $0x14,%eax
      continue;
801032cf:	e9 7c ff ff ff       	jmp    80103250 <mpinit+0xf0>
801032d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801032d8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801032dc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801032df:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
801032e5:	e9 66 ff ff ff       	jmp    80103250 <mpinit+0xf0>
801032ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801032f0:	ba 00 00 01 00       	mov    $0x10000,%edx
801032f5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801032fa:	e8 e1 fd ff ff       	call   801030e0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032ff:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103301:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103304:	0f 85 a9 fe ff ff    	jne    801031b3 <mpinit+0x53>
8010330a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103310:	83 ec 0c             	sub    $0xc,%esp
80103313:	68 1d 79 10 80       	push   $0x8010791d
80103318:	e8 73 d0 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010331d:	83 ec 0c             	sub    $0xc,%esp
80103320:	68 3c 79 10 80       	push   $0x8010793c
80103325:	e8 66 d0 ff ff       	call   80100390 <panic>
      ismp = 0;
8010332a:	31 db                	xor    %ebx,%ebx
8010332c:	e9 26 ff ff ff       	jmp    80103257 <mpinit+0xf7>
80103331:	66 90                	xchg   %ax,%ax
80103333:	66 90                	xchg   %ax,%ax
80103335:	66 90                	xchg   %ax,%ax
80103337:	66 90                	xchg   %ax,%ax
80103339:	66 90                	xchg   %ax,%ax
8010333b:	66 90                	xchg   %ax,%ax
8010333d:	66 90                	xchg   %ax,%ax
8010333f:	90                   	nop

80103340 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103340:	55                   	push   %ebp
80103341:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103346:	ba 21 00 00 00       	mov    $0x21,%edx
8010334b:	89 e5                	mov    %esp,%ebp
8010334d:	ee                   	out    %al,(%dx)
8010334e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103353:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103354:	5d                   	pop    %ebp
80103355:	c3                   	ret    
80103356:	66 90                	xchg   %ax,%ax
80103358:	66 90                	xchg   %ax,%ax
8010335a:	66 90                	xchg   %ax,%ax
8010335c:	66 90                	xchg   %ax,%ax
8010335e:	66 90                	xchg   %ax,%ax

80103360 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	57                   	push   %edi
80103364:	56                   	push   %esi
80103365:	53                   	push   %ebx
80103366:	83 ec 0c             	sub    $0xc,%esp
80103369:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010336c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010336f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103375:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010337b:	e8 00 da ff ff       	call   80100d80 <filealloc>
80103380:	85 c0                	test   %eax,%eax
80103382:	89 03                	mov    %eax,(%ebx)
80103384:	74 22                	je     801033a8 <pipealloc+0x48>
80103386:	e8 f5 d9 ff ff       	call   80100d80 <filealloc>
8010338b:	85 c0                	test   %eax,%eax
8010338d:	89 06                	mov    %eax,(%esi)
8010338f:	74 3f                	je     801033d0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103391:	e8 4a f2 ff ff       	call   801025e0 <kalloc>
80103396:	85 c0                	test   %eax,%eax
80103398:	89 c7                	mov    %eax,%edi
8010339a:	75 54                	jne    801033f0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010339c:	8b 03                	mov    (%ebx),%eax
8010339e:	85 c0                	test   %eax,%eax
801033a0:	75 34                	jne    801033d6 <pipealloc+0x76>
801033a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801033a8:	8b 06                	mov    (%esi),%eax
801033aa:	85 c0                	test   %eax,%eax
801033ac:	74 0c                	je     801033ba <pipealloc+0x5a>
    fileclose(*f1);
801033ae:	83 ec 0c             	sub    $0xc,%esp
801033b1:	50                   	push   %eax
801033b2:	e8 89 da ff ff       	call   80100e40 <fileclose>
801033b7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801033ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801033bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801033c2:	5b                   	pop    %ebx
801033c3:	5e                   	pop    %esi
801033c4:	5f                   	pop    %edi
801033c5:	5d                   	pop    %ebp
801033c6:	c3                   	ret    
801033c7:	89 f6                	mov    %esi,%esi
801033c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801033d0:	8b 03                	mov    (%ebx),%eax
801033d2:	85 c0                	test   %eax,%eax
801033d4:	74 e4                	je     801033ba <pipealloc+0x5a>
    fileclose(*f0);
801033d6:	83 ec 0c             	sub    $0xc,%esp
801033d9:	50                   	push   %eax
801033da:	e8 61 da ff ff       	call   80100e40 <fileclose>
  if(*f1)
801033df:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801033e1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801033e4:	85 c0                	test   %eax,%eax
801033e6:	75 c6                	jne    801033ae <pipealloc+0x4e>
801033e8:	eb d0                	jmp    801033ba <pipealloc+0x5a>
801033ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801033f0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801033f3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801033fa:	00 00 00 
  p->writeopen = 1;
801033fd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103404:	00 00 00 
  p->nwrite = 0;
80103407:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010340e:	00 00 00 
  p->nread = 0;
80103411:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103418:	00 00 00 
  initlock(&p->lock, "pipe");
8010341b:	68 70 79 10 80       	push   $0x80107970
80103420:	50                   	push   %eax
80103421:	e8 9a 11 00 00       	call   801045c0 <initlock>
  (*f0)->type = FD_PIPE;
80103426:	8b 03                	mov    (%ebx),%eax
  return 0;
80103428:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010342b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103431:	8b 03                	mov    (%ebx),%eax
80103433:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103437:	8b 03                	mov    (%ebx),%eax
80103439:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010343d:	8b 03                	mov    (%ebx),%eax
8010343f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103442:	8b 06                	mov    (%esi),%eax
80103444:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010344a:	8b 06                	mov    (%esi),%eax
8010344c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103450:	8b 06                	mov    (%esi),%eax
80103452:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103456:	8b 06                	mov    (%esi),%eax
80103458:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010345b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010345e:	31 c0                	xor    %eax,%eax
}
80103460:	5b                   	pop    %ebx
80103461:	5e                   	pop    %esi
80103462:	5f                   	pop    %edi
80103463:	5d                   	pop    %ebp
80103464:	c3                   	ret    
80103465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103470 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103470:	55                   	push   %ebp
80103471:	89 e5                	mov    %esp,%ebp
80103473:	56                   	push   %esi
80103474:	53                   	push   %ebx
80103475:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103478:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010347b:	83 ec 0c             	sub    $0xc,%esp
8010347e:	53                   	push   %ebx
8010347f:	e8 7c 12 00 00       	call   80104700 <acquire>
  if(writable){
80103484:	83 c4 10             	add    $0x10,%esp
80103487:	85 f6                	test   %esi,%esi
80103489:	74 45                	je     801034d0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010348b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103491:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103494:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010349b:	00 00 00 
    wakeup(&p->nread);
8010349e:	50                   	push   %eax
8010349f:	e8 3c 0c 00 00       	call   801040e0 <wakeup>
801034a4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801034a7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801034ad:	85 d2                	test   %edx,%edx
801034af:	75 0a                	jne    801034bb <pipeclose+0x4b>
801034b1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801034b7:	85 c0                	test   %eax,%eax
801034b9:	74 35                	je     801034f0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801034bb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801034be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034c1:	5b                   	pop    %ebx
801034c2:	5e                   	pop    %esi
801034c3:	5d                   	pop    %ebp
    release(&p->lock);
801034c4:	e9 f7 12 00 00       	jmp    801047c0 <release>
801034c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801034d0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801034d6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801034d9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801034e0:	00 00 00 
    wakeup(&p->nwrite);
801034e3:	50                   	push   %eax
801034e4:	e8 f7 0b 00 00       	call   801040e0 <wakeup>
801034e9:	83 c4 10             	add    $0x10,%esp
801034ec:	eb b9                	jmp    801034a7 <pipeclose+0x37>
801034ee:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801034f0:	83 ec 0c             	sub    $0xc,%esp
801034f3:	53                   	push   %ebx
801034f4:	e8 c7 12 00 00       	call   801047c0 <release>
    kfree((char*)p);
801034f9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801034fc:	83 c4 10             	add    $0x10,%esp
}
801034ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103502:	5b                   	pop    %ebx
80103503:	5e                   	pop    %esi
80103504:	5d                   	pop    %ebp
    kfree((char*)p);
80103505:	e9 26 ef ff ff       	jmp    80102430 <kfree>
8010350a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103510 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103510:	55                   	push   %ebp
80103511:	89 e5                	mov    %esp,%ebp
80103513:	57                   	push   %edi
80103514:	56                   	push   %esi
80103515:	53                   	push   %ebx
80103516:	83 ec 28             	sub    $0x28,%esp
80103519:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010351c:	53                   	push   %ebx
8010351d:	e8 de 11 00 00       	call   80104700 <acquire>
  for(i = 0; i < n; i++){
80103522:	8b 45 10             	mov    0x10(%ebp),%eax
80103525:	83 c4 10             	add    $0x10,%esp
80103528:	85 c0                	test   %eax,%eax
8010352a:	0f 8e c9 00 00 00    	jle    801035f9 <pipewrite+0xe9>
80103530:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103533:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103539:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010353f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103542:	03 4d 10             	add    0x10(%ebp),%ecx
80103545:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103548:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010354e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103554:	39 d0                	cmp    %edx,%eax
80103556:	75 71                	jne    801035c9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103558:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010355e:	85 c0                	test   %eax,%eax
80103560:	74 4e                	je     801035b0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103562:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103568:	eb 3a                	jmp    801035a4 <pipewrite+0x94>
8010356a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103570:	83 ec 0c             	sub    $0xc,%esp
80103573:	57                   	push   %edi
80103574:	e8 67 0b 00 00       	call   801040e0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103579:	5a                   	pop    %edx
8010357a:	59                   	pop    %ecx
8010357b:	53                   	push   %ebx
8010357c:	56                   	push   %esi
8010357d:	e8 9e 09 00 00       	call   80103f20 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103582:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103588:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010358e:	83 c4 10             	add    $0x10,%esp
80103591:	05 00 02 00 00       	add    $0x200,%eax
80103596:	39 c2                	cmp    %eax,%edx
80103598:	75 36                	jne    801035d0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010359a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801035a0:	85 c0                	test   %eax,%eax
801035a2:	74 0c                	je     801035b0 <pipewrite+0xa0>
801035a4:	e8 87 03 00 00       	call   80103930 <myproc>
801035a9:	8b 40 24             	mov    0x24(%eax),%eax
801035ac:	85 c0                	test   %eax,%eax
801035ae:	74 c0                	je     80103570 <pipewrite+0x60>
        release(&p->lock);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	53                   	push   %ebx
801035b4:	e8 07 12 00 00       	call   801047c0 <release>
        return -1;
801035b9:	83 c4 10             	add    $0x10,%esp
801035bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801035c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035c4:	5b                   	pop    %ebx
801035c5:	5e                   	pop    %esi
801035c6:	5f                   	pop    %edi
801035c7:	5d                   	pop    %ebp
801035c8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035c9:	89 c2                	mov    %eax,%edx
801035cb:	90                   	nop
801035cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801035d0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801035d3:	8d 42 01             	lea    0x1(%edx),%eax
801035d6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801035dc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801035e2:	83 c6 01             	add    $0x1,%esi
801035e5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801035e9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801035ec:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801035ef:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801035f3:	0f 85 4f ff ff ff    	jne    80103548 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801035f9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801035ff:	83 ec 0c             	sub    $0xc,%esp
80103602:	50                   	push   %eax
80103603:	e8 d8 0a 00 00       	call   801040e0 <wakeup>
  release(&p->lock);
80103608:	89 1c 24             	mov    %ebx,(%esp)
8010360b:	e8 b0 11 00 00       	call   801047c0 <release>
  return n;
80103610:	83 c4 10             	add    $0x10,%esp
80103613:	8b 45 10             	mov    0x10(%ebp),%eax
80103616:	eb a9                	jmp    801035c1 <pipewrite+0xb1>
80103618:	90                   	nop
80103619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103620 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	57                   	push   %edi
80103624:	56                   	push   %esi
80103625:	53                   	push   %ebx
80103626:	83 ec 18             	sub    $0x18,%esp
80103629:	8b 75 08             	mov    0x8(%ebp),%esi
8010362c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010362f:	56                   	push   %esi
80103630:	e8 cb 10 00 00       	call   80104700 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103635:	83 c4 10             	add    $0x10,%esp
80103638:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010363e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103644:	75 6a                	jne    801036b0 <piperead+0x90>
80103646:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010364c:	85 db                	test   %ebx,%ebx
8010364e:	0f 84 c4 00 00 00    	je     80103718 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103654:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010365a:	eb 2d                	jmp    80103689 <piperead+0x69>
8010365c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103660:	83 ec 08             	sub    $0x8,%esp
80103663:	56                   	push   %esi
80103664:	53                   	push   %ebx
80103665:	e8 b6 08 00 00       	call   80103f20 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010366a:	83 c4 10             	add    $0x10,%esp
8010366d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103673:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103679:	75 35                	jne    801036b0 <piperead+0x90>
8010367b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103681:	85 d2                	test   %edx,%edx
80103683:	0f 84 8f 00 00 00    	je     80103718 <piperead+0xf8>
    if(myproc()->killed){
80103689:	e8 a2 02 00 00       	call   80103930 <myproc>
8010368e:	8b 48 24             	mov    0x24(%eax),%ecx
80103691:	85 c9                	test   %ecx,%ecx
80103693:	74 cb                	je     80103660 <piperead+0x40>
      release(&p->lock);
80103695:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103698:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010369d:	56                   	push   %esi
8010369e:	e8 1d 11 00 00       	call   801047c0 <release>
      return -1;
801036a3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801036a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036a9:	89 d8                	mov    %ebx,%eax
801036ab:	5b                   	pop    %ebx
801036ac:	5e                   	pop    %esi
801036ad:	5f                   	pop    %edi
801036ae:	5d                   	pop    %ebp
801036af:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036b0:	8b 45 10             	mov    0x10(%ebp),%eax
801036b3:	85 c0                	test   %eax,%eax
801036b5:	7e 61                	jle    80103718 <piperead+0xf8>
    if(p->nread == p->nwrite)
801036b7:	31 db                	xor    %ebx,%ebx
801036b9:	eb 13                	jmp    801036ce <piperead+0xae>
801036bb:	90                   	nop
801036bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036c0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801036c6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036cc:	74 1f                	je     801036ed <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801036ce:	8d 41 01             	lea    0x1(%ecx),%eax
801036d1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801036d7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801036dd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801036e2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036e5:	83 c3 01             	add    $0x1,%ebx
801036e8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801036eb:	75 d3                	jne    801036c0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801036ed:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801036f3:	83 ec 0c             	sub    $0xc,%esp
801036f6:	50                   	push   %eax
801036f7:	e8 e4 09 00 00       	call   801040e0 <wakeup>
  release(&p->lock);
801036fc:	89 34 24             	mov    %esi,(%esp)
801036ff:	e8 bc 10 00 00       	call   801047c0 <release>
  return i;
80103704:	83 c4 10             	add    $0x10,%esp
}
80103707:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010370a:	89 d8                	mov    %ebx,%eax
8010370c:	5b                   	pop    %ebx
8010370d:	5e                   	pop    %esi
8010370e:	5f                   	pop    %edi
8010370f:	5d                   	pop    %ebp
80103710:	c3                   	ret    
80103711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103718:	31 db                	xor    %ebx,%ebx
8010371a:	eb d1                	jmp    801036ed <piperead+0xcd>
8010371c:	66 90                	xchg   %ax,%ax
8010371e:	66 90                	xchg   %ax,%ax

80103720 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103724:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103729:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010372c:	68 20 2d 11 80       	push   $0x80112d20
80103731:	e8 ca 0f 00 00       	call   80104700 <acquire>
80103736:	83 c4 10             	add    $0x10,%esp
80103739:	eb 17                	jmp    80103752 <allocproc+0x32>
8010373b:	90                   	nop
8010373c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103740:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103746:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
8010374c:	0f 83 9e 00 00 00    	jae    801037f0 <allocproc+0xd0>
    if(p->state == UNUSED)
80103752:	8b 43 0c             	mov    0xc(%ebx),%eax
80103755:	85 c0                	test   %eax,%eax
80103757:	75 e7                	jne    80103740 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103759:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  
  p->nice = 0;
  p->runtime =0;
  p->vruntime =0;
  p->weight = 1024;
  release(&ptable.lock);
8010375e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103761:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->nice = 0;
80103768:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->runtime =0;
8010376f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103776:	00 00 00 
  p->vruntime =0;
80103779:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103780:	00 00 00 
  p->weight = 1024;
80103783:	c7 83 80 00 00 00 00 	movl   $0x400,0x80(%ebx)
8010378a:	04 00 00 
  p->pid = nextpid++;
8010378d:	8d 50 01             	lea    0x1(%eax),%edx
80103790:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103793:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
80103798:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
8010379e:	e8 1d 10 00 00       	call   801047c0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801037a3:	e8 38 ee ff ff       	call   801025e0 <kalloc>
801037a8:	83 c4 10             	add    $0x10,%esp
801037ab:	85 c0                	test   %eax,%eax
801037ad:	89 43 08             	mov    %eax,0x8(%ebx)
801037b0:	74 57                	je     80103809 <allocproc+0xe9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037b2:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801037b8:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801037bb:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801037c0:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801037c3:	c7 40 14 6f 5b 10 80 	movl   $0x80105b6f,0x14(%eax)
  p->context = (struct context*)sp;
801037ca:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801037cd:	6a 14                	push   $0x14
801037cf:	6a 00                	push   $0x0
801037d1:	50                   	push   %eax
801037d2:	e8 39 10 00 00       	call   80104810 <memset>
  p->context->eip = (uint)forkret;
801037d7:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801037da:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801037dd:	c7 40 10 20 38 10 80 	movl   $0x80103820,0x10(%eax)
}
801037e4:	89 d8                	mov    %ebx,%eax
801037e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037e9:	c9                   	leave  
801037ea:	c3                   	ret    
801037eb:	90                   	nop
801037ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801037f0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801037f3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801037f5:	68 20 2d 11 80       	push   $0x80112d20
801037fa:	e8 c1 0f 00 00       	call   801047c0 <release>
}
801037ff:	89 d8                	mov    %ebx,%eax
  return 0;
80103801:	83 c4 10             	add    $0x10,%esp
}
80103804:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103807:	c9                   	leave  
80103808:	c3                   	ret    
    p->state = UNUSED;
80103809:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103810:	31 db                	xor    %ebx,%ebx
80103812:	eb d0                	jmp    801037e4 <allocproc+0xc4>
80103814:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010381a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103820 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103826:	68 20 2d 11 80       	push   $0x80112d20
8010382b:	e8 90 0f 00 00       	call   801047c0 <release>

  if (first) {
80103830:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103835:	83 c4 10             	add    $0x10,%esp
80103838:	85 c0                	test   %eax,%eax
8010383a:	75 04                	jne    80103840 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010383c:	c9                   	leave  
8010383d:	c3                   	ret    
8010383e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103840:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103843:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010384a:	00 00 00 
    iinit(ROOTDEV);
8010384d:	6a 01                	push   $0x1
8010384f:	e8 3c dc ff ff       	call   80101490 <iinit>
    initlog(ROOTDEV);
80103854:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010385b:	e8 c0 f3 ff ff       	call   80102c20 <initlog>
80103860:	83 c4 10             	add    $0x10,%esp
}
80103863:	c9                   	leave  
80103864:	c3                   	ret    
80103865:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103870 <pinit>:
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	83 ec 10             	sub    $0x10,%esp
	initlock(&ptable.lock, "ptable");
80103876:	68 75 79 10 80       	push   $0x80107975
8010387b:	68 20 2d 11 80       	push   $0x80112d20
80103880:	e8 3b 0d 00 00       	call   801045c0 <initlock>
}	
80103885:	83 c4 10             	add    $0x10,%esp
80103888:	c9                   	leave  
80103889:	c3                   	ret    
8010388a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103890 <mycpu>:
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	56                   	push   %esi
80103894:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103895:	9c                   	pushf  
80103896:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103897:	f6 c4 02             	test   $0x2,%ah
8010389a:	75 5e                	jne    801038fa <mycpu+0x6a>
  apicid = lapicid();
8010389c:	e8 af ef ff ff       	call   80102850 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801038a1:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801038a7:	85 f6                	test   %esi,%esi
801038a9:	7e 42                	jle    801038ed <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801038ab:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
801038b2:	39 d0                	cmp    %edx,%eax
801038b4:	74 30                	je     801038e6 <mycpu+0x56>
801038b6:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
801038bb:	31 d2                	xor    %edx,%edx
801038bd:	8d 76 00             	lea    0x0(%esi),%esi
801038c0:	83 c2 01             	add    $0x1,%edx
801038c3:	39 f2                	cmp    %esi,%edx
801038c5:	74 26                	je     801038ed <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801038c7:	0f b6 19             	movzbl (%ecx),%ebx
801038ca:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801038d0:	39 c3                	cmp    %eax,%ebx
801038d2:	75 ec                	jne    801038c0 <mycpu+0x30>
801038d4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801038da:	05 80 27 11 80       	add    $0x80112780,%eax
}
801038df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038e2:	5b                   	pop    %ebx
801038e3:	5e                   	pop    %esi
801038e4:	5d                   	pop    %ebp
801038e5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801038e6:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
801038eb:	eb f2                	jmp    801038df <mycpu+0x4f>
  panic("unknown apicid\n");
801038ed:	83 ec 0c             	sub    $0xc,%esp
801038f0:	68 7c 79 10 80       	push   $0x8010797c
801038f5:	e8 96 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801038fa:	83 ec 0c             	sub    $0xc,%esp
801038fd:	68 60 7a 10 80       	push   $0x80107a60
80103902:	e8 89 ca ff ff       	call   80100390 <panic>
80103907:	89 f6                	mov    %esi,%esi
80103909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103910 <cpuid>:
cpuid() {
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103916:	e8 75 ff ff ff       	call   80103890 <mycpu>
8010391b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103920:	c9                   	leave  
  return mycpu()-cpus;
80103921:	c1 f8 04             	sar    $0x4,%eax
80103924:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010392a:	c3                   	ret    
8010392b:	90                   	nop
8010392c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103930 <myproc>:
myproc(void) {
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	53                   	push   %ebx
80103934:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103937:	e8 f4 0c 00 00       	call   80104630 <pushcli>
  c = mycpu();
8010393c:	e8 4f ff ff ff       	call   80103890 <mycpu>
  p = c->proc;
80103941:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103947:	e8 24 0d 00 00       	call   80104670 <popcli>
}
8010394c:	83 c4 04             	add    $0x4,%esp
8010394f:	89 d8                	mov    %ebx,%eax
80103951:	5b                   	pop    %ebx
80103952:	5d                   	pop    %ebp
80103953:	c3                   	ret    
80103954:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010395a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103960 <userinit>:
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	53                   	push   %ebx
80103964:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103967:	e8 b4 fd ff ff       	call   80103720 <allocproc>
8010396c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010396e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103973:	e8 d8 37 00 00       	call   80107150 <setupkvm>
80103978:	85 c0                	test   %eax,%eax
8010397a:	89 43 04             	mov    %eax,0x4(%ebx)
8010397d:	0f 84 e7 00 00 00    	je     80103a6a <userinit+0x10a>
  cprintf("%p %p\n", _binary_initcode_start, _binary_initcode_size);
80103983:	83 ec 04             	sub    $0x4,%esp
80103986:	68 2c 00 00 00       	push   $0x2c
8010398b:	68 60 a4 10 80       	push   $0x8010a460
80103990:	68 a5 79 10 80       	push   $0x801079a5
80103995:	e8 c6 cc ff ff       	call   80100660 <cprintf>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010399a:	83 c4 0c             	add    $0xc,%esp
8010399d:	68 2c 00 00 00       	push   $0x2c
801039a2:	68 60 a4 10 80       	push   $0x8010a460
801039a7:	ff 73 04             	pushl  0x4(%ebx)
801039aa:	e8 81 34 00 00       	call   80106e30 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039af:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039b2:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039b8:	6a 4c                	push   $0x4c
801039ba:	6a 00                	push   $0x0
801039bc:	ff 73 18             	pushl  0x18(%ebx)
801039bf:	e8 4c 0e 00 00       	call   80104810 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039c4:	8b 43 18             	mov    0x18(%ebx),%eax
801039c7:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039cc:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039d1:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039d4:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039d8:	8b 43 18             	mov    0x18(%ebx),%eax
801039db:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801039df:	8b 43 18             	mov    0x18(%ebx),%eax
801039e2:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039e6:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801039ea:	8b 43 18             	mov    0x18(%ebx),%eax
801039ed:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039f1:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801039f5:	8b 43 18             	mov    0x18(%ebx),%eax
801039f8:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801039ff:	8b 43 18             	mov    0x18(%ebx),%eax
80103a02:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a09:	8b 43 18             	mov    0x18(%ebx),%eax
80103a0c:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a13:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a16:	6a 10                	push   $0x10
80103a18:	68 ac 79 10 80       	push   $0x801079ac
80103a1d:	50                   	push   %eax
80103a1e:	e8 cd 0f 00 00       	call   801049f0 <safestrcpy>
  p->cwd = namei("/");
80103a23:	c7 04 24 b5 79 10 80 	movl   $0x801079b5,(%esp)
80103a2a:	e8 c1 e4 ff ff       	call   80101ef0 <namei>
80103a2f:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a32:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a39:	e8 c2 0c 00 00       	call   80104700 <acquire>
  p->state = RUNNABLE;
80103a3e:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->nice = 0;
80103a45:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->weight = 1024;
80103a4c:	c7 83 80 00 00 00 00 	movl   $0x400,0x80(%ebx)
80103a53:	04 00 00 
  release(&ptable.lock);
80103a56:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a5d:	e8 5e 0d 00 00       	call   801047c0 <release>
}
80103a62:	83 c4 10             	add    $0x10,%esp
80103a65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a68:	c9                   	leave  
80103a69:	c3                   	ret    
    panic("userinit: out of memory?");
80103a6a:	83 ec 0c             	sub    $0xc,%esp
80103a6d:	68 8c 79 10 80       	push   $0x8010798c
80103a72:	e8 19 c9 ff ff       	call   80100390 <panic>
80103a77:	89 f6                	mov    %esi,%esi
80103a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a80 <growproc>:
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	56                   	push   %esi
80103a84:	53                   	push   %ebx
80103a85:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a88:	e8 a3 0b 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103a8d:	e8 fe fd ff ff       	call   80103890 <mycpu>
  p = c->proc;
80103a92:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a98:	e8 d3 0b 00 00       	call   80104670 <popcli>
  if(n > 0){
80103a9d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103aa0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103aa2:	7f 1c                	jg     80103ac0 <growproc+0x40>
  } else if(n < 0){
80103aa4:	75 3a                	jne    80103ae0 <growproc+0x60>
  switchuvm(curproc);
80103aa6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103aa9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103aab:	53                   	push   %ebx
80103aac:	e8 6f 32 00 00       	call   80106d20 <switchuvm>
  return 0;
80103ab1:	83 c4 10             	add    $0x10,%esp
80103ab4:	31 c0                	xor    %eax,%eax
}
80103ab6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ab9:	5b                   	pop    %ebx
80103aba:	5e                   	pop    %esi
80103abb:	5d                   	pop    %ebp
80103abc:	c3                   	ret    
80103abd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ac0:	83 ec 04             	sub    $0x4,%esp
80103ac3:	01 c6                	add    %eax,%esi
80103ac5:	56                   	push   %esi
80103ac6:	50                   	push   %eax
80103ac7:	ff 73 04             	pushl  0x4(%ebx)
80103aca:	e8 a1 34 00 00       	call   80106f70 <allocuvm>
80103acf:	83 c4 10             	add    $0x10,%esp
80103ad2:	85 c0                	test   %eax,%eax
80103ad4:	75 d0                	jne    80103aa6 <growproc+0x26>
      return -1;
80103ad6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103adb:	eb d9                	jmp    80103ab6 <growproc+0x36>
80103add:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ae0:	83 ec 04             	sub    $0x4,%esp
80103ae3:	01 c6                	add    %eax,%esi
80103ae5:	56                   	push   %esi
80103ae6:	50                   	push   %eax
80103ae7:	ff 73 04             	pushl  0x4(%ebx)
80103aea:	e8 b1 35 00 00       	call   801070a0 <deallocuvm>
80103aef:	83 c4 10             	add    $0x10,%esp
80103af2:	85 c0                	test   %eax,%eax
80103af4:	75 b0                	jne    80103aa6 <growproc+0x26>
80103af6:	eb de                	jmp    80103ad6 <growproc+0x56>
80103af8:	90                   	nop
80103af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b00 <fork>:
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	57                   	push   %edi
80103b04:	56                   	push   %esi
80103b05:	53                   	push   %ebx
80103b06:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b09:	e8 22 0b 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103b0e:	e8 7d fd ff ff       	call   80103890 <mycpu>
  p = c->proc;
80103b13:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b19:	e8 52 0b 00 00       	call   80104670 <popcli>
  if((np = allocproc()) == 0){
80103b1e:	e8 fd fb ff ff       	call   80103720 <allocproc>
80103b23:	85 c0                	test   %eax,%eax
80103b25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b28:	0f 84 d7 00 00 00    	je     80103c05 <fork+0x105>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b2e:	83 ec 08             	sub    $0x8,%esp
80103b31:	ff 33                	pushl  (%ebx)
80103b33:	ff 73 04             	pushl  0x4(%ebx)
80103b36:	89 c7                	mov    %eax,%edi
80103b38:	e8 e3 36 00 00       	call   80107220 <copyuvm>
80103b3d:	83 c4 10             	add    $0x10,%esp
80103b40:	85 c0                	test   %eax,%eax
80103b42:	89 47 04             	mov    %eax,0x4(%edi)
80103b45:	0f 84 c1 00 00 00    	je     80103c0c <fork+0x10c>
  np->sz = curproc->sz;
80103b4b:	8b 03                	mov    (%ebx),%eax
80103b4d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  *np->tf = *curproc->tf;
80103b50:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103b55:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
80103b57:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103b5a:	8b 7a 18             	mov    0x18(%edx),%edi
80103b5d:	8b 73 18             	mov    0x18(%ebx),%esi
80103b60:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b62:	31 f6                	xor    %esi,%esi
  np->nice = curproc->nice;
80103b64:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103b67:	89 42 7c             	mov    %eax,0x7c(%edx)
  np->weight = curproc->weight;
80103b6a:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80103b70:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
  np->vruntime = curproc->vruntime;
80103b76:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80103b7c:	89 82 88 00 00 00    	mov    %eax,0x88(%edx)
  np->tf->eax = 0;
80103b82:	8b 42 18             	mov    0x18(%edx),%eax
80103b85:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103b90:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b94:	85 c0                	test   %eax,%eax
80103b96:	74 13                	je     80103bab <fork+0xab>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b98:	83 ec 0c             	sub    $0xc,%esp
80103b9b:	50                   	push   %eax
80103b9c:	e8 4f d2 ff ff       	call   80100df0 <filedup>
80103ba1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ba4:	83 c4 10             	add    $0x10,%esp
80103ba7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bab:	83 c6 01             	add    $0x1,%esi
80103bae:	83 fe 10             	cmp    $0x10,%esi
80103bb1:	75 dd                	jne    80103b90 <fork+0x90>
  np->cwd = idup(curproc->cwd);
80103bb3:	83 ec 0c             	sub    $0xc,%esp
80103bb6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bb9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bbc:	e8 9f da ff ff       	call   80101660 <idup>
80103bc1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bc4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bc7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bca:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bcd:	6a 10                	push   $0x10
80103bcf:	53                   	push   %ebx
80103bd0:	50                   	push   %eax
80103bd1:	e8 1a 0e 00 00       	call   801049f0 <safestrcpy>
  pid = np->pid;
80103bd6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103bd9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103be0:	e8 1b 0b 00 00       	call   80104700 <acquire>
  np->state = RUNNABLE;
80103be5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bec:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bf3:	e8 c8 0b 00 00       	call   801047c0 <release>
  return pid;
80103bf8:	83 c4 10             	add    $0x10,%esp
}
80103bfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bfe:	89 d8                	mov    %ebx,%eax
80103c00:	5b                   	pop    %ebx
80103c01:	5e                   	pop    %esi
80103c02:	5f                   	pop    %edi
80103c03:	5d                   	pop    %ebp
80103c04:	c3                   	ret    
    return -1;
80103c05:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c0a:	eb ef                	jmp    80103bfb <fork+0xfb>
    kfree(np->kstack);
80103c0c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103c0f:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103c12:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
80103c17:	ff 77 08             	pushl  0x8(%edi)
80103c1a:	e8 11 e8 ff ff       	call   80102430 <kfree>
    np->kstack = 0;
80103c1f:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103c26:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103c2d:	83 c4 10             	add    $0x10,%esp
80103c30:	eb c9                	jmp    80103bfb <fork+0xfb>
80103c32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c40 <scheduler>:
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	57                   	push   %edi
80103c44:	56                   	push   %esi
80103c45:	53                   	push   %ebx
80103c46:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c49:	e8 42 fc ff ff       	call   80103890 <mycpu>
80103c4e:	8d 78 04             	lea    0x4(%eax),%edi
80103c51:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c53:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c5a:	00 00 00 
80103c5d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c60:	fb                   	sti    
    acquire(&ptable.lock);
80103c61:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c64:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103c69:	68 20 2d 11 80       	push   $0x80112d20
80103c6e:	e8 8d 0a 00 00       	call   80104700 <acquire>
80103c73:	83 c4 10             	add    $0x10,%esp
80103c76:	8d 76 00             	lea    0x0(%esi),%esi
80103c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103c80:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c84:	75 33                	jne    80103cb9 <scheduler+0x79>
      switchuvm(p);
80103c86:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c89:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c8f:	53                   	push   %ebx
80103c90:	e8 8b 30 00 00       	call   80106d20 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103c95:	58                   	pop    %eax
80103c96:	5a                   	pop    %edx
80103c97:	ff 73 1c             	pushl  0x1c(%ebx)
80103c9a:	57                   	push   %edi
      p->state = RUNNING;
80103c9b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103ca2:	e8 a4 0d 00 00       	call   80104a4b <swtch>
      switchkvm();
80103ca7:	e8 54 30 00 00       	call   80106d00 <switchkvm>
      c->proc = 0;
80103cac:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cb3:	00 00 00 
80103cb6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cb9:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103cbf:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80103cc5:	72 b9                	jb     80103c80 <scheduler+0x40>
    release(&ptable.lock);
80103cc7:	83 ec 0c             	sub    $0xc,%esp
80103cca:	68 20 2d 11 80       	push   $0x80112d20
80103ccf:	e8 ec 0a 00 00       	call   801047c0 <release>
    sti();
80103cd4:	83 c4 10             	add    $0x10,%esp
80103cd7:	eb 87                	jmp    80103c60 <scheduler+0x20>
80103cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ce0 <sched>:
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	56                   	push   %esi
80103ce4:	53                   	push   %ebx
  pushcli();
80103ce5:	e8 46 09 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103cea:	e8 a1 fb ff ff       	call   80103890 <mycpu>
  p = c->proc;
80103cef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cf5:	e8 76 09 00 00       	call   80104670 <popcli>
  if(!holding(&ptable.lock))
80103cfa:	83 ec 0c             	sub    $0xc,%esp
80103cfd:	68 20 2d 11 80       	push   $0x80112d20
80103d02:	e8 c9 09 00 00       	call   801046d0 <holding>
80103d07:	83 c4 10             	add    $0x10,%esp
80103d0a:	85 c0                	test   %eax,%eax
80103d0c:	74 4f                	je     80103d5d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103d0e:	e8 7d fb ff ff       	call   80103890 <mycpu>
80103d13:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d1a:	75 68                	jne    80103d84 <sched+0xa4>
  if(p->state == RUNNING)
80103d1c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d20:	74 55                	je     80103d77 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d22:	9c                   	pushf  
80103d23:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d24:	f6 c4 02             	test   $0x2,%ah
80103d27:	75 41                	jne    80103d6a <sched+0x8a>
  intena = mycpu()->intena;
80103d29:	e8 62 fb ff ff       	call   80103890 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d2e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d31:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d37:	e8 54 fb ff ff       	call   80103890 <mycpu>
80103d3c:	83 ec 08             	sub    $0x8,%esp
80103d3f:	ff 70 04             	pushl  0x4(%eax)
80103d42:	53                   	push   %ebx
80103d43:	e8 03 0d 00 00       	call   80104a4b <swtch>
  mycpu()->intena = intena;
80103d48:	e8 43 fb ff ff       	call   80103890 <mycpu>
}
80103d4d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d50:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d56:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d59:	5b                   	pop    %ebx
80103d5a:	5e                   	pop    %esi
80103d5b:	5d                   	pop    %ebp
80103d5c:	c3                   	ret    
    panic("sched ptable.lock");
80103d5d:	83 ec 0c             	sub    $0xc,%esp
80103d60:	68 b7 79 10 80       	push   $0x801079b7
80103d65:	e8 26 c6 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103d6a:	83 ec 0c             	sub    $0xc,%esp
80103d6d:	68 e3 79 10 80       	push   $0x801079e3
80103d72:	e8 19 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103d77:	83 ec 0c             	sub    $0xc,%esp
80103d7a:	68 d5 79 10 80       	push   $0x801079d5
80103d7f:	e8 0c c6 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103d84:	83 ec 0c             	sub    $0xc,%esp
80103d87:	68 c9 79 10 80       	push   $0x801079c9
80103d8c:	e8 ff c5 ff ff       	call   80100390 <panic>
80103d91:	eb 0d                	jmp    80103da0 <exit>
80103d93:	90                   	nop
80103d94:	90                   	nop
80103d95:	90                   	nop
80103d96:	90                   	nop
80103d97:	90                   	nop
80103d98:	90                   	nop
80103d99:	90                   	nop
80103d9a:	90                   	nop
80103d9b:	90                   	nop
80103d9c:	90                   	nop
80103d9d:	90                   	nop
80103d9e:	90                   	nop
80103d9f:	90                   	nop

80103da0 <exit>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	57                   	push   %edi
80103da4:	56                   	push   %esi
80103da5:	53                   	push   %ebx
80103da6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103da9:	e8 82 08 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103dae:	e8 dd fa ff ff       	call   80103890 <mycpu>
  p = c->proc;
80103db3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103db9:	e8 b2 08 00 00       	call   80104670 <popcli>
  if(curproc == initproc)
80103dbe:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103dc4:	8d 5e 28             	lea    0x28(%esi),%ebx
80103dc7:	8d 7e 68             	lea    0x68(%esi),%edi
80103dca:	0f 84 f1 00 00 00    	je     80103ec1 <exit+0x121>
    if(curproc->ofile[fd]){
80103dd0:	8b 03                	mov    (%ebx),%eax
80103dd2:	85 c0                	test   %eax,%eax
80103dd4:	74 12                	je     80103de8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103dd6:	83 ec 0c             	sub    $0xc,%esp
80103dd9:	50                   	push   %eax
80103dda:	e8 61 d0 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103ddf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103de5:	83 c4 10             	add    $0x10,%esp
80103de8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103deb:	39 fb                	cmp    %edi,%ebx
80103ded:	75 e1                	jne    80103dd0 <exit+0x30>
  begin_op();
80103def:	e8 cc ee ff ff       	call   80102cc0 <begin_op>
  iput(curproc->cwd);
80103df4:	83 ec 0c             	sub    $0xc,%esp
80103df7:	ff 76 68             	pushl  0x68(%esi)
80103dfa:	e8 c1 d9 ff ff       	call   801017c0 <iput>
  end_op();
80103dff:	e8 2c ef ff ff       	call   80102d30 <end_op>
  curproc->cwd = 0;
80103e04:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103e0b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e12:	e8 e9 08 00 00       	call   80104700 <acquire>
  wakeup1(curproc->parent);
80103e17:	8b 56 14             	mov    0x14(%esi),%edx
80103e1a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e1d:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e22:	eb 10                	jmp    80103e34 <exit+0x94>
80103e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e28:	05 8c 00 00 00       	add    $0x8c,%eax
80103e2d:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103e32:	73 1e                	jae    80103e52 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80103e34:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e38:	75 ee                	jne    80103e28 <exit+0x88>
80103e3a:	3b 50 20             	cmp    0x20(%eax),%edx
80103e3d:	75 e9                	jne    80103e28 <exit+0x88>
      p->state = RUNNABLE;
80103e3f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e46:	05 8c 00 00 00       	add    $0x8c,%eax
80103e4b:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103e50:	72 e2                	jb     80103e34 <exit+0x94>
      p->parent = initproc;
80103e52:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e58:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103e5d:	eb 0f                	jmp    80103e6e <exit+0xce>
80103e5f:	90                   	nop
80103e60:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80103e66:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
80103e6c:	73 3a                	jae    80103ea8 <exit+0x108>
    if(p->parent == curproc){
80103e6e:	39 72 14             	cmp    %esi,0x14(%edx)
80103e71:	75 ed                	jne    80103e60 <exit+0xc0>
      if(p->state == ZOMBIE)
80103e73:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e77:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e7a:	75 e4                	jne    80103e60 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e7c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e81:	eb 11                	jmp    80103e94 <exit+0xf4>
80103e83:	90                   	nop
80103e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e88:	05 8c 00 00 00       	add    $0x8c,%eax
80103e8d:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103e92:	73 cc                	jae    80103e60 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103e94:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e98:	75 ee                	jne    80103e88 <exit+0xe8>
80103e9a:	3b 48 20             	cmp    0x20(%eax),%ecx
80103e9d:	75 e9                	jne    80103e88 <exit+0xe8>
      p->state = RUNNABLE;
80103e9f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103ea6:	eb e0                	jmp    80103e88 <exit+0xe8>
  curproc->state = ZOMBIE;
80103ea8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103eaf:	e8 2c fe ff ff       	call   80103ce0 <sched>
  panic("zombie exit");
80103eb4:	83 ec 0c             	sub    $0xc,%esp
80103eb7:	68 04 7a 10 80       	push   $0x80107a04
80103ebc:	e8 cf c4 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103ec1:	83 ec 0c             	sub    $0xc,%esp
80103ec4:	68 f7 79 10 80       	push   $0x801079f7
80103ec9:	e8 c2 c4 ff ff       	call   80100390 <panic>
80103ece:	66 90                	xchg   %ax,%ax

80103ed0 <yield>:
{
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	53                   	push   %ebx
80103ed4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103ed7:	68 20 2d 11 80       	push   $0x80112d20
80103edc:	e8 1f 08 00 00       	call   80104700 <acquire>
  pushcli();
80103ee1:	e8 4a 07 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103ee6:	e8 a5 f9 ff ff       	call   80103890 <mycpu>
  p = c->proc;
80103eeb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ef1:	e8 7a 07 00 00       	call   80104670 <popcli>
  myproc()->state = RUNNABLE;
80103ef6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103efd:	e8 de fd ff ff       	call   80103ce0 <sched>
  release(&ptable.lock);
80103f02:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f09:	e8 b2 08 00 00       	call   801047c0 <release>
}
80103f0e:	83 c4 10             	add    $0x10,%esp
80103f11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f14:	c9                   	leave  
80103f15:	c3                   	ret    
80103f16:	8d 76 00             	lea    0x0(%esi),%esi
80103f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f20 <sleep>:
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	57                   	push   %edi
80103f24:	56                   	push   %esi
80103f25:	53                   	push   %ebx
80103f26:	83 ec 0c             	sub    $0xc,%esp
80103f29:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103f2f:	e8 fc 06 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103f34:	e8 57 f9 ff ff       	call   80103890 <mycpu>
  p = c->proc;
80103f39:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f3f:	e8 2c 07 00 00       	call   80104670 <popcli>
  if(p == 0)
80103f44:	85 db                	test   %ebx,%ebx
80103f46:	0f 84 87 00 00 00    	je     80103fd3 <sleep+0xb3>
  if(lk == 0)
80103f4c:	85 f6                	test   %esi,%esi
80103f4e:	74 76                	je     80103fc6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103f50:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103f56:	74 50                	je     80103fa8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103f58:	83 ec 0c             	sub    $0xc,%esp
80103f5b:	68 20 2d 11 80       	push   $0x80112d20
80103f60:	e8 9b 07 00 00       	call   80104700 <acquire>
    release(lk);
80103f65:	89 34 24             	mov    %esi,(%esp)
80103f68:	e8 53 08 00 00       	call   801047c0 <release>
  p->chan = chan;
80103f6d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f70:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f77:	e8 64 fd ff ff       	call   80103ce0 <sched>
  p->chan = 0;
80103f7c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103f83:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f8a:	e8 31 08 00 00       	call   801047c0 <release>
    acquire(lk);
80103f8f:	89 75 08             	mov    %esi,0x8(%ebp)
80103f92:	83 c4 10             	add    $0x10,%esp
}
80103f95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f98:	5b                   	pop    %ebx
80103f99:	5e                   	pop    %esi
80103f9a:	5f                   	pop    %edi
80103f9b:	5d                   	pop    %ebp
    acquire(lk);
80103f9c:	e9 5f 07 00 00       	jmp    80104700 <acquire>
80103fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103fa8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103fab:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103fb2:	e8 29 fd ff ff       	call   80103ce0 <sched>
  p->chan = 0;
80103fb7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103fbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fc1:	5b                   	pop    %ebx
80103fc2:	5e                   	pop    %esi
80103fc3:	5f                   	pop    %edi
80103fc4:	5d                   	pop    %ebp
80103fc5:	c3                   	ret    
    panic("sleep without lk");
80103fc6:	83 ec 0c             	sub    $0xc,%esp
80103fc9:	68 16 7a 10 80       	push   $0x80107a16
80103fce:	e8 bd c3 ff ff       	call   80100390 <panic>
    panic("sleep");
80103fd3:	83 ec 0c             	sub    $0xc,%esp
80103fd6:	68 10 7a 10 80       	push   $0x80107a10
80103fdb:	e8 b0 c3 ff ff       	call   80100390 <panic>

80103fe0 <wait>:
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	56                   	push   %esi
80103fe4:	53                   	push   %ebx
  pushcli();
80103fe5:	e8 46 06 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103fea:	e8 a1 f8 ff ff       	call   80103890 <mycpu>
  p = c->proc;
80103fef:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ff5:	e8 76 06 00 00       	call   80104670 <popcli>
  acquire(&ptable.lock);
80103ffa:	83 ec 0c             	sub    $0xc,%esp
80103ffd:	68 20 2d 11 80       	push   $0x80112d20
80104002:	e8 f9 06 00 00       	call   80104700 <acquire>
80104007:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010400a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010400c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104011:	eb 13                	jmp    80104026 <wait+0x46>
80104013:	90                   	nop
80104014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104018:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
8010401e:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80104024:	73 1e                	jae    80104044 <wait+0x64>
      if(p->parent != curproc)
80104026:	39 73 14             	cmp    %esi,0x14(%ebx)
80104029:	75 ed                	jne    80104018 <wait+0x38>
      if(p->state == ZOMBIE){
8010402b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010402f:	74 37                	je     80104068 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104031:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      havekids = 1;
80104037:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010403c:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80104042:	72 e2                	jb     80104026 <wait+0x46>
    if(!havekids || curproc->killed){
80104044:	85 c0                	test   %eax,%eax
80104046:	74 76                	je     801040be <wait+0xde>
80104048:	8b 46 24             	mov    0x24(%esi),%eax
8010404b:	85 c0                	test   %eax,%eax
8010404d:	75 6f                	jne    801040be <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010404f:	83 ec 08             	sub    $0x8,%esp
80104052:	68 20 2d 11 80       	push   $0x80112d20
80104057:	56                   	push   %esi
80104058:	e8 c3 fe ff ff       	call   80103f20 <sleep>
    havekids = 0;
8010405d:	83 c4 10             	add    $0x10,%esp
80104060:	eb a8                	jmp    8010400a <wait+0x2a>
80104062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104068:	83 ec 0c             	sub    $0xc,%esp
8010406b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010406e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104071:	e8 ba e3 ff ff       	call   80102430 <kfree>
        freevm(p->pgdir);
80104076:	5a                   	pop    %edx
80104077:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010407a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104081:	e8 4a 30 00 00       	call   801070d0 <freevm>
        release(&ptable.lock);
80104086:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
8010408d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104094:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010409b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010409f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801040a6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801040ad:	e8 0e 07 00 00       	call   801047c0 <release>
        return pid;
801040b2:	83 c4 10             	add    $0x10,%esp
}
801040b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040b8:	89 f0                	mov    %esi,%eax
801040ba:	5b                   	pop    %ebx
801040bb:	5e                   	pop    %esi
801040bc:	5d                   	pop    %ebp
801040bd:	c3                   	ret    
      release(&ptable.lock);
801040be:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801040c1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801040c6:	68 20 2d 11 80       	push   $0x80112d20
801040cb:	e8 f0 06 00 00       	call   801047c0 <release>
      return -1;
801040d0:	83 c4 10             	add    $0x10,%esp
801040d3:	eb e0                	jmp    801040b5 <wait+0xd5>
801040d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040e0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	53                   	push   %ebx
801040e4:	83 ec 10             	sub    $0x10,%esp
801040e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801040ea:	68 20 2d 11 80       	push   $0x80112d20
801040ef:	e8 0c 06 00 00       	call   80104700 <acquire>
801040f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040f7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801040fc:	eb 0e                	jmp    8010410c <wakeup+0x2c>
801040fe:	66 90                	xchg   %ax,%ax
80104100:	05 8c 00 00 00       	add    $0x8c,%eax
80104105:	3d 54 50 11 80       	cmp    $0x80115054,%eax
8010410a:	73 1e                	jae    8010412a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010410c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104110:	75 ee                	jne    80104100 <wakeup+0x20>
80104112:	3b 58 20             	cmp    0x20(%eax),%ebx
80104115:	75 e9                	jne    80104100 <wakeup+0x20>
      p->state = RUNNABLE;
80104117:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010411e:	05 8c 00 00 00       	add    $0x8c,%eax
80104123:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80104128:	72 e2                	jb     8010410c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010412a:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104131:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104134:	c9                   	leave  
  release(&ptable.lock);
80104135:	e9 86 06 00 00       	jmp    801047c0 <release>
8010413a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104140 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	53                   	push   %ebx
80104144:	83 ec 10             	sub    $0x10,%esp
80104147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010414a:	68 20 2d 11 80       	push   $0x80112d20
8010414f:	e8 ac 05 00 00       	call   80104700 <acquire>
80104154:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104157:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010415c:	eb 0e                	jmp    8010416c <kill+0x2c>
8010415e:	66 90                	xchg   %ax,%ax
80104160:	05 8c 00 00 00       	add    $0x8c,%eax
80104165:	3d 54 50 11 80       	cmp    $0x80115054,%eax
8010416a:	73 34                	jae    801041a0 <kill+0x60>
    if(p->pid == pid){
8010416c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010416f:	75 ef                	jne    80104160 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104171:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104175:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010417c:	75 07                	jne    80104185 <kill+0x45>
        p->state = RUNNABLE;
8010417e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104185:	83 ec 0c             	sub    $0xc,%esp
80104188:	68 20 2d 11 80       	push   $0x80112d20
8010418d:	e8 2e 06 00 00       	call   801047c0 <release>
      return 0;
80104192:	83 c4 10             	add    $0x10,%esp
80104195:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104197:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010419a:	c9                   	leave  
8010419b:	c3                   	ret    
8010419c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801041a0:	83 ec 0c             	sub    $0xc,%esp
801041a3:	68 20 2d 11 80       	push   $0x80112d20
801041a8:	e8 13 06 00 00       	call   801047c0 <release>
  return -1;
801041ad:	83 c4 10             	add    $0x10,%esp
801041b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041b8:	c9                   	leave  
801041b9:	c3                   	ret    
801041ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	57                   	push   %edi
801041c4:	56                   	push   %esi
801041c5:	53                   	push   %ebx
801041c6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041c9:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801041ce:	83 ec 3c             	sub    $0x3c,%esp
801041d1:	eb 27                	jmp    801041fa <procdump+0x3a>
801041d3:	90                   	nop
801041d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801041d8:	83 ec 0c             	sub    $0xc,%esp
801041db:	68 cf 7e 10 80       	push   $0x80107ecf
801041e0:	e8 7b c4 ff ff       	call   80100660 <cprintf>
801041e5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041e8:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801041ee:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
801041f4:	0f 83 86 00 00 00    	jae    80104280 <procdump+0xc0>
    if(p->state == UNUSED)
801041fa:	8b 43 0c             	mov    0xc(%ebx),%eax
801041fd:	85 c0                	test   %eax,%eax
801041ff:	74 e7                	je     801041e8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104201:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104204:	ba 27 7a 10 80       	mov    $0x80107a27,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104209:	77 11                	ja     8010421c <procdump+0x5c>
8010420b:	8b 14 85 ac 7b 10 80 	mov    -0x7fef8454(,%eax,4),%edx
      state = "???";
80104212:	b8 27 7a 10 80       	mov    $0x80107a27,%eax
80104217:	85 d2                	test   %edx,%edx
80104219:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010421c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010421f:	50                   	push   %eax
80104220:	52                   	push   %edx
80104221:	ff 73 10             	pushl  0x10(%ebx)
80104224:	68 2b 7a 10 80       	push   $0x80107a2b
80104229:	e8 32 c4 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010422e:	83 c4 10             	add    $0x10,%esp
80104231:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104235:	75 a1                	jne    801041d8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104237:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010423a:	83 ec 08             	sub    $0x8,%esp
8010423d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104240:	50                   	push   %eax
80104241:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104244:	8b 40 0c             	mov    0xc(%eax),%eax
80104247:	83 c0 08             	add    $0x8,%eax
8010424a:	50                   	push   %eax
8010424b:	e8 90 03 00 00       	call   801045e0 <getcallerpcs>
80104250:	83 c4 10             	add    $0x10,%esp
80104253:	90                   	nop
80104254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104258:	8b 17                	mov    (%edi),%edx
8010425a:	85 d2                	test   %edx,%edx
8010425c:	0f 84 76 ff ff ff    	je     801041d8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104262:	83 ec 08             	sub    $0x8,%esp
80104265:	83 c7 04             	add    $0x4,%edi
80104268:	52                   	push   %edx
80104269:	68 41 74 10 80       	push   $0x80107441
8010426e:	e8 ed c3 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104273:	83 c4 10             	add    $0x10,%esp
80104276:	39 fe                	cmp    %edi,%esi
80104278:	75 de                	jne    80104258 <procdump+0x98>
8010427a:	e9 59 ff ff ff       	jmp    801041d8 <procdump+0x18>
8010427f:	90                   	nop
  }
}
80104280:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104283:	5b                   	pop    %ebx
80104284:	5e                   	pop    %esi
80104285:	5f                   	pop    %edi
80104286:	5d                   	pop    %ebp
80104287:	c3                   	ret    
80104288:	90                   	nop
80104289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104290 <ps>:
// own syscall

int 
ps(void)
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	53                   	push   %ebx
80104294:	83 ec 10             	sub    $0x10,%esp
  asm volatile("sti");
80104297:	fb                   	sti    
	struct proc *p;
	sti(); // enable interrupts

	//lookup
	acquire(&ptable.lock);
80104298:	68 20 2d 11 80       	push   $0x80112d20
	cprintf("current ticks : %d\nname \t\t pid \t state \t\t priority\t runtime/weight\t runtime \t vruntime \n",ticks);
	for(p =ptable.proc; p< &ptable.proc[NPROC]; p++){
8010429d:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
	acquire(&ptable.lock);
801042a2:	e8 59 04 00 00       	call   80104700 <acquire>
	cprintf("current ticks : %d\nname \t\t pid \t state \t\t priority\t runtime/weight\t runtime \t vruntime \n",ticks);
801042a7:	58                   	pop    %eax
801042a8:	5a                   	pop    %edx
801042a9:	ff 35 a0 58 11 80    	pushl  0x801158a0
801042af:	68 88 7a 10 80       	push   $0x80107a88
801042b4:	e8 a7 c3 ff ff       	call   80100660 <cprintf>
801042b9:	83 c4 10             	add    $0x10,%esp
801042bc:	eb 27                	jmp    801042e5 <ps+0x55>
801042be:	66 90                	xchg   %ax,%ax
		if(p->state == SLEEPING) cprintf("%s \t\t %d  \t SLEEPING \t %d  \t\t %d \t\t %d \t\t %d \t \n",p->name,p->pid,p->nice,1,p->runtime,p->vruntime);
		else if(p->state == RUNNING) cprintf("%s \t\t %d  \t RUNNING \t %d  \t\t %d \t\t %d \t\t %d \t \n",p->name,p->pid,p->nice,1,p->runtime,p->vruntime);
801042c0:	83 f8 04             	cmp    $0x4,%eax
801042c3:	74 7b                	je     80104340 <ps+0xb0>
		else if(p->state == RUNNABLE) cprintf("%s \t\t %d  \t RUNNABLE \t %d  \t\t %d \t\t %d \t\t %d \t \n",p->name,p->pid,p->nice,1,p->runtime,p->vruntime);
801042c5:	83 f8 03             	cmp    $0x3,%eax
801042c8:	0f 84 a2 00 00 00    	je     80104370 <ps+0xe0>
		//else if(p->state == UNUSED) cprintf("%s \t %d  \t %d  \t UNUSED \t %d \t \n",p->name,p->nice,p->pid,p->runtime);
		else if(p->state == ZOMBIE) cprintf("%s \t\t %d  \t ZOMBIE \t %d  \t\t %d \t\t %d \t\t %d \t \n",p->name,p->pid,p->nice,1,p->runtime,p->vruntime);
801042ce:	83 f8 05             	cmp    $0x5,%eax
801042d1:	0f 84 c9 00 00 00    	je     801043a0 <ps+0x110>
	for(p =ptable.proc; p< &ptable.proc[NPROC]; p++){
801042d7:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801042dd:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
801042e3:	73 3e                	jae    80104323 <ps+0x93>
		if(p->state == SLEEPING) cprintf("%s \t\t %d  \t SLEEPING \t %d  \t\t %d \t\t %d \t\t %d \t \n",p->name,p->pid,p->nice,1,p->runtime,p->vruntime);
801042e5:	8b 43 0c             	mov    0xc(%ebx),%eax
801042e8:	83 f8 02             	cmp    $0x2,%eax
801042eb:	75 d3                	jne    801042c0 <ps+0x30>
801042ed:	8d 43 6c             	lea    0x6c(%ebx),%eax
801042f0:	83 ec 04             	sub    $0x4,%esp
801042f3:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
801042f9:	ff b3 84 00 00 00    	pushl  0x84(%ebx)
801042ff:	6a 01                	push   $0x1
	for(p =ptable.proc; p< &ptable.proc[NPROC]; p++){
80104301:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
		if(p->state == SLEEPING) cprintf("%s \t\t %d  \t SLEEPING \t %d  \t\t %d \t\t %d \t\t %d \t \n",p->name,p->pid,p->nice,1,p->runtime,p->vruntime);
80104307:	ff 73 f0             	pushl  -0x10(%ebx)
8010430a:	ff 73 84             	pushl  -0x7c(%ebx)
8010430d:	50                   	push   %eax
8010430e:	68 e4 7a 10 80       	push   $0x80107ae4
80104313:	e8 48 c3 ff ff       	call   80100660 <cprintf>
80104318:	83 c4 20             	add    $0x20,%esp
	for(p =ptable.proc; p< &ptable.proc[NPROC]; p++){
8010431b:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80104321:	72 c2                	jb     801042e5 <ps+0x55>
		//else if(p->state == EMBRYO) cprintf("%s \t %d  \t %d  \t EMBRYO \t %d \t \n",p->name,p->nice,p->pid,p->runtime);
	}
	release(&ptable.lock);
80104323:	83 ec 0c             	sub    $0xc,%esp
80104326:	68 20 2d 11 80       	push   $0x80112d20
8010432b:	e8 90 04 00 00       	call   801047c0 <release>
	//yield();
	return 24;
}
80104330:	b8 18 00 00 00       	mov    $0x18,%eax
80104335:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104338:	c9                   	leave  
80104339:	c3                   	ret    
8010433a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		else if(p->state == RUNNING) cprintf("%s \t\t %d  \t RUNNING \t %d  \t\t %d \t\t %d \t\t %d \t \n",p->name,p->pid,p->nice,1,p->runtime,p->vruntime);
80104340:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104343:	83 ec 04             	sub    $0x4,%esp
80104346:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
8010434c:	ff b3 84 00 00 00    	pushl  0x84(%ebx)
80104352:	6a 01                	push   $0x1
80104354:	ff 73 7c             	pushl  0x7c(%ebx)
80104357:	ff 73 10             	pushl  0x10(%ebx)
8010435a:	50                   	push   %eax
8010435b:	68 18 7b 10 80       	push   $0x80107b18
80104360:	e8 fb c2 ff ff       	call   80100660 <cprintf>
80104365:	83 c4 20             	add    $0x20,%esp
80104368:	e9 6a ff ff ff       	jmp    801042d7 <ps+0x47>
8010436d:	8d 76 00             	lea    0x0(%esi),%esi
		else if(p->state == RUNNABLE) cprintf("%s \t\t %d  \t RUNNABLE \t %d  \t\t %d \t\t %d \t\t %d \t \n",p->name,p->pid,p->nice,1,p->runtime,p->vruntime);
80104370:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104373:	83 ec 04             	sub    $0x4,%esp
80104376:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
8010437c:	ff b3 84 00 00 00    	pushl  0x84(%ebx)
80104382:	6a 01                	push   $0x1
80104384:	ff 73 7c             	pushl  0x7c(%ebx)
80104387:	ff 73 10             	pushl  0x10(%ebx)
8010438a:	50                   	push   %eax
8010438b:	68 48 7b 10 80       	push   $0x80107b48
80104390:	e8 cb c2 ff ff       	call   80100660 <cprintf>
80104395:	83 c4 20             	add    $0x20,%esp
80104398:	e9 3a ff ff ff       	jmp    801042d7 <ps+0x47>
8010439d:	8d 76 00             	lea    0x0(%esi),%esi
		else if(p->state == ZOMBIE) cprintf("%s \t\t %d  \t ZOMBIE \t %d  \t\t %d \t\t %d \t\t %d \t \n",p->name,p->pid,p->nice,1,p->runtime,p->vruntime);
801043a0:	8d 43 6c             	lea    0x6c(%ebx),%eax
801043a3:	83 ec 04             	sub    $0x4,%esp
801043a6:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
801043ac:	ff b3 84 00 00 00    	pushl  0x84(%ebx)
801043b2:	6a 01                	push   $0x1
801043b4:	ff 73 7c             	pushl  0x7c(%ebx)
801043b7:	ff 73 10             	pushl  0x10(%ebx)
801043ba:	50                   	push   %eax
801043bb:	68 7c 7b 10 80       	push   $0x80107b7c
801043c0:	e8 9b c2 ff ff       	call   80100660 <cprintf>
801043c5:	83 c4 20             	add    $0x20,%esp
801043c8:	e9 0a ff ff ff       	jmp    801042d7 <ps+0x47>
801043cd:	8d 76 00             	lea    0x0(%esi),%esi

801043d0 <setnice>:

int 
setnice(int pid,int nice_val)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	56                   	push   %esi
801043d4:	53                   	push   %ebx
801043d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  pushcli();
801043d8:	e8 53 02 00 00       	call   80104630 <pushcli>
  c = mycpu();
801043dd:	e8 ae f4 ff ff       	call   80103890 <mycpu>
  p = c->proc;
801043e2:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801043e8:	e8 83 02 00 00       	call   80104670 <popcli>
	if(myproc()->pid == pid){
801043ed:	8b 45 08             	mov    0x8(%ebp),%eax
801043f0:	39 46 10             	cmp    %eax,0x10(%esi)
801043f3:	75 43                	jne    80104438 <setnice+0x68>
		if(nice_val>=0 && nice_val <=10){
801043f5:	83 fb 0a             	cmp    $0xa,%ebx
801043f8:	77 3e                	ja     80104438 <setnice+0x68>
  pushcli();
801043fa:	e8 31 02 00 00       	call   80104630 <pushcli>
  c = mycpu();
801043ff:	e8 8c f4 ff ff       	call   80103890 <mycpu>
  p = c->proc;
80104404:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010440a:	e8 61 02 00 00       	call   80104670 <popcli>
			myproc()->nice = nice_val;
8010440f:	89 5e 7c             	mov    %ebx,0x7c(%esi)
  pushcli();
80104412:	e8 19 02 00 00       	call   80104630 <pushcli>
  c = mycpu();
80104417:	e8 74 f4 ff ff       	call   80103890 <mycpu>
  p = c->proc;
8010441c:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104422:	e8 49 02 00 00       	call   80104670 <popcli>
			if(myproc()->nice == nice_val) return 0;
80104427:	31 c0                	xor    %eax,%eax
80104429:	39 5e 7c             	cmp    %ebx,0x7c(%esi)
8010442c:	0f 95 c0             	setne  %al
8010442f:	f7 d8                	neg    %eax
		}
	} 
	return -1; // fail
}
80104431:	5b                   	pop    %ebx
80104432:	5e                   	pop    %esi
80104433:	5d                   	pop    %ebp
80104434:	c3                   	ret    
80104435:	8d 76 00             	lea    0x0(%esi),%esi
	return -1; // fail
80104438:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010443d:	eb f2                	jmp    80104431 <setnice+0x61>
8010443f:	90                   	nop

80104440 <getnice>:
int 
getnice(int pid)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	56                   	push   %esi
80104444:	53                   	push   %ebx
80104445:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104448:	e8 e3 01 00 00       	call   80104630 <pushcli>
  c = mycpu();
8010444d:	e8 3e f4 ff ff       	call   80103890 <mycpu>
  p = c->proc;
80104452:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104458:	e8 13 02 00 00       	call   80104670 <popcli>
	int val;
	if(myproc()->pid == pid){
8010445d:	39 5e 10             	cmp    %ebx,0x10(%esi)
80104460:	74 05                	je     80104467 <getnice+0x27>
		val = myproc()->nice;
		if(val >=0 || val<=10) return val;	
	}else if(pid == 1){
80104462:	83 fb 01             	cmp    $0x1,%ebx
80104465:	75 21                	jne    80104488 <getnice+0x48>
  pushcli();
80104467:	e8 c4 01 00 00       	call   80104630 <pushcli>
  c = mycpu();
8010446c:	e8 1f f4 ff ff       	call   80103890 <mycpu>
  p = c->proc;
80104471:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104477:	e8 f4 01 00 00       	call   80104670 <popcli>
		val = myproc()->nice;	
8010447c:	8b 43 7c             	mov    0x7c(%ebx),%eax
		if(val >=0 || val<=10) return val;	
	}
	return -1;
}
8010447f:	5b                   	pop    %ebx
80104480:	5e                   	pop    %esi
80104481:	5d                   	pop    %ebp
80104482:	c3                   	ret    
80104483:	90                   	nop
80104484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	return -1;
80104488:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010448d:	eb f0                	jmp    8010447f <getnice+0x3f>
8010448f:	90                   	nop

80104490 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	53                   	push   %ebx
80104494:	83 ec 0c             	sub    $0xc,%esp
80104497:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010449a:	68 c4 7b 10 80       	push   $0x80107bc4
8010449f:	8d 43 04             	lea    0x4(%ebx),%eax
801044a2:	50                   	push   %eax
801044a3:	e8 18 01 00 00       	call   801045c0 <initlock>
  lk->name = name;
801044a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801044ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801044b1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801044b4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801044bb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801044be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044c1:	c9                   	leave  
801044c2:	c3                   	ret    
801044c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044d0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	56                   	push   %esi
801044d4:	53                   	push   %ebx
801044d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044d8:	83 ec 0c             	sub    $0xc,%esp
801044db:	8d 73 04             	lea    0x4(%ebx),%esi
801044de:	56                   	push   %esi
801044df:	e8 1c 02 00 00       	call   80104700 <acquire>
  while (lk->locked) {
801044e4:	8b 13                	mov    (%ebx),%edx
801044e6:	83 c4 10             	add    $0x10,%esp
801044e9:	85 d2                	test   %edx,%edx
801044eb:	74 16                	je     80104503 <acquiresleep+0x33>
801044ed:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801044f0:	83 ec 08             	sub    $0x8,%esp
801044f3:	56                   	push   %esi
801044f4:	53                   	push   %ebx
801044f5:	e8 26 fa ff ff       	call   80103f20 <sleep>
  while (lk->locked) {
801044fa:	8b 03                	mov    (%ebx),%eax
801044fc:	83 c4 10             	add    $0x10,%esp
801044ff:	85 c0                	test   %eax,%eax
80104501:	75 ed                	jne    801044f0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104503:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104509:	e8 22 f4 ff ff       	call   80103930 <myproc>
8010450e:	8b 40 10             	mov    0x10(%eax),%eax
80104511:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104514:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104517:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010451a:	5b                   	pop    %ebx
8010451b:	5e                   	pop    %esi
8010451c:	5d                   	pop    %ebp
  release(&lk->lk);
8010451d:	e9 9e 02 00 00       	jmp    801047c0 <release>
80104522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104530 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	56                   	push   %esi
80104534:	53                   	push   %ebx
80104535:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104538:	83 ec 0c             	sub    $0xc,%esp
8010453b:	8d 73 04             	lea    0x4(%ebx),%esi
8010453e:	56                   	push   %esi
8010453f:	e8 bc 01 00 00       	call   80104700 <acquire>
  lk->locked = 0;
80104544:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010454a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104551:	89 1c 24             	mov    %ebx,(%esp)
80104554:	e8 87 fb ff ff       	call   801040e0 <wakeup>
  release(&lk->lk);
80104559:	89 75 08             	mov    %esi,0x8(%ebp)
8010455c:	83 c4 10             	add    $0x10,%esp
}
8010455f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104562:	5b                   	pop    %ebx
80104563:	5e                   	pop    %esi
80104564:	5d                   	pop    %ebp
  release(&lk->lk);
80104565:	e9 56 02 00 00       	jmp    801047c0 <release>
8010456a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104570 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	57                   	push   %edi
80104574:	56                   	push   %esi
80104575:	53                   	push   %ebx
80104576:	31 ff                	xor    %edi,%edi
80104578:	83 ec 18             	sub    $0x18,%esp
8010457b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010457e:	8d 73 04             	lea    0x4(%ebx),%esi
80104581:	56                   	push   %esi
80104582:	e8 79 01 00 00       	call   80104700 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104587:	8b 03                	mov    (%ebx),%eax
80104589:	83 c4 10             	add    $0x10,%esp
8010458c:	85 c0                	test   %eax,%eax
8010458e:	74 13                	je     801045a3 <holdingsleep+0x33>
80104590:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104593:	e8 98 f3 ff ff       	call   80103930 <myproc>
80104598:	39 58 10             	cmp    %ebx,0x10(%eax)
8010459b:	0f 94 c0             	sete   %al
8010459e:	0f b6 c0             	movzbl %al,%eax
801045a1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801045a3:	83 ec 0c             	sub    $0xc,%esp
801045a6:	56                   	push   %esi
801045a7:	e8 14 02 00 00       	call   801047c0 <release>
  return r;
}
801045ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045af:	89 f8                	mov    %edi,%eax
801045b1:	5b                   	pop    %ebx
801045b2:	5e                   	pop    %esi
801045b3:	5f                   	pop    %edi
801045b4:	5d                   	pop    %ebp
801045b5:	c3                   	ret    
801045b6:	66 90                	xchg   %ax,%ax
801045b8:	66 90                	xchg   %ax,%ax
801045ba:	66 90                	xchg   %ax,%ax
801045bc:	66 90                	xchg   %ax,%ax
801045be:	66 90                	xchg   %ax,%ax

801045c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801045c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801045c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801045cf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801045d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801045d9:	5d                   	pop    %ebp
801045da:	c3                   	ret    
801045db:	90                   	nop
801045dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045e0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801045e0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801045e1:	31 d2                	xor    %edx,%edx
{
801045e3:	89 e5                	mov    %esp,%ebp
801045e5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801045e6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801045e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801045ec:	83 e8 08             	sub    $0x8,%eax
801045ef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045f0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801045f6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801045fc:	77 1a                	ja     80104618 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801045fe:	8b 58 04             	mov    0x4(%eax),%ebx
80104601:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104604:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104607:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104609:	83 fa 0a             	cmp    $0xa,%edx
8010460c:	75 e2                	jne    801045f0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010460e:	5b                   	pop    %ebx
8010460f:	5d                   	pop    %ebp
80104610:	c3                   	ret    
80104611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104618:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010461b:	83 c1 28             	add    $0x28,%ecx
8010461e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104620:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104626:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104629:	39 c1                	cmp    %eax,%ecx
8010462b:	75 f3                	jne    80104620 <getcallerpcs+0x40>
}
8010462d:	5b                   	pop    %ebx
8010462e:	5d                   	pop    %ebp
8010462f:	c3                   	ret    

80104630 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	53                   	push   %ebx
80104634:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104637:	9c                   	pushf  
80104638:	5b                   	pop    %ebx
  asm volatile("cli");
80104639:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010463a:	e8 51 f2 ff ff       	call   80103890 <mycpu>
8010463f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104645:	85 c0                	test   %eax,%eax
80104647:	75 11                	jne    8010465a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104649:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010464f:	e8 3c f2 ff ff       	call   80103890 <mycpu>
80104654:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010465a:	e8 31 f2 ff ff       	call   80103890 <mycpu>
8010465f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104666:	83 c4 04             	add    $0x4,%esp
80104669:	5b                   	pop    %ebx
8010466a:	5d                   	pop    %ebp
8010466b:	c3                   	ret    
8010466c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104670 <popcli>:

void
popcli(void)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104676:	9c                   	pushf  
80104677:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104678:	f6 c4 02             	test   $0x2,%ah
8010467b:	75 35                	jne    801046b2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010467d:	e8 0e f2 ff ff       	call   80103890 <mycpu>
80104682:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104689:	78 34                	js     801046bf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010468b:	e8 00 f2 ff ff       	call   80103890 <mycpu>
80104690:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104696:	85 d2                	test   %edx,%edx
80104698:	74 06                	je     801046a0 <popcli+0x30>
    sti();
}
8010469a:	c9                   	leave  
8010469b:	c3                   	ret    
8010469c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046a0:	e8 eb f1 ff ff       	call   80103890 <mycpu>
801046a5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801046ab:	85 c0                	test   %eax,%eax
801046ad:	74 eb                	je     8010469a <popcli+0x2a>
  asm volatile("sti");
801046af:	fb                   	sti    
}
801046b0:	c9                   	leave  
801046b1:	c3                   	ret    
    panic("popcli - interruptible");
801046b2:	83 ec 0c             	sub    $0xc,%esp
801046b5:	68 cf 7b 10 80       	push   $0x80107bcf
801046ba:	e8 d1 bc ff ff       	call   80100390 <panic>
    panic("popcli");
801046bf:	83 ec 0c             	sub    $0xc,%esp
801046c2:	68 e6 7b 10 80       	push   $0x80107be6
801046c7:	e8 c4 bc ff ff       	call   80100390 <panic>
801046cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046d0 <holding>:
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	56                   	push   %esi
801046d4:	53                   	push   %ebx
801046d5:	8b 75 08             	mov    0x8(%ebp),%esi
801046d8:	31 db                	xor    %ebx,%ebx
  pushcli();
801046da:	e8 51 ff ff ff       	call   80104630 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046df:	8b 06                	mov    (%esi),%eax
801046e1:	85 c0                	test   %eax,%eax
801046e3:	74 10                	je     801046f5 <holding+0x25>
801046e5:	8b 5e 08             	mov    0x8(%esi),%ebx
801046e8:	e8 a3 f1 ff ff       	call   80103890 <mycpu>
801046ed:	39 c3                	cmp    %eax,%ebx
801046ef:	0f 94 c3             	sete   %bl
801046f2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801046f5:	e8 76 ff ff ff       	call   80104670 <popcli>
}
801046fa:	89 d8                	mov    %ebx,%eax
801046fc:	5b                   	pop    %ebx
801046fd:	5e                   	pop    %esi
801046fe:	5d                   	pop    %ebp
801046ff:	c3                   	ret    

80104700 <acquire>:
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	56                   	push   %esi
80104704:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104705:	e8 26 ff ff ff       	call   80104630 <pushcli>
  if(holding(lk))
8010470a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010470d:	83 ec 0c             	sub    $0xc,%esp
80104710:	53                   	push   %ebx
80104711:	e8 ba ff ff ff       	call   801046d0 <holding>
80104716:	83 c4 10             	add    $0x10,%esp
80104719:	85 c0                	test   %eax,%eax
8010471b:	0f 85 83 00 00 00    	jne    801047a4 <acquire+0xa4>
80104721:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104723:	ba 01 00 00 00       	mov    $0x1,%edx
80104728:	eb 09                	jmp    80104733 <acquire+0x33>
8010472a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104730:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104733:	89 d0                	mov    %edx,%eax
80104735:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104738:	85 c0                	test   %eax,%eax
8010473a:	75 f4                	jne    80104730 <acquire+0x30>
  __sync_synchronize();
8010473c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104741:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104744:	e8 47 f1 ff ff       	call   80103890 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104749:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010474c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010474f:	89 e8                	mov    %ebp,%eax
80104751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104758:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010475e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104764:	77 1a                	ja     80104780 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104766:	8b 48 04             	mov    0x4(%eax),%ecx
80104769:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010476c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010476f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104771:	83 fe 0a             	cmp    $0xa,%esi
80104774:	75 e2                	jne    80104758 <acquire+0x58>
}
80104776:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104779:	5b                   	pop    %ebx
8010477a:	5e                   	pop    %esi
8010477b:	5d                   	pop    %ebp
8010477c:	c3                   	ret    
8010477d:	8d 76 00             	lea    0x0(%esi),%esi
80104780:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104783:	83 c2 28             	add    $0x28,%edx
80104786:	8d 76 00             	lea    0x0(%esi),%esi
80104789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104790:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104796:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104799:	39 d0                	cmp    %edx,%eax
8010479b:	75 f3                	jne    80104790 <acquire+0x90>
}
8010479d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047a0:	5b                   	pop    %ebx
801047a1:	5e                   	pop    %esi
801047a2:	5d                   	pop    %ebp
801047a3:	c3                   	ret    
    panic("acquire");
801047a4:	83 ec 0c             	sub    $0xc,%esp
801047a7:	68 ed 7b 10 80       	push   $0x80107bed
801047ac:	e8 df bb ff ff       	call   80100390 <panic>
801047b1:	eb 0d                	jmp    801047c0 <release>
801047b3:	90                   	nop
801047b4:	90                   	nop
801047b5:	90                   	nop
801047b6:	90                   	nop
801047b7:	90                   	nop
801047b8:	90                   	nop
801047b9:	90                   	nop
801047ba:	90                   	nop
801047bb:	90                   	nop
801047bc:	90                   	nop
801047bd:	90                   	nop
801047be:	90                   	nop
801047bf:	90                   	nop

801047c0 <release>:
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	53                   	push   %ebx
801047c4:	83 ec 10             	sub    $0x10,%esp
801047c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801047ca:	53                   	push   %ebx
801047cb:	e8 00 ff ff ff       	call   801046d0 <holding>
801047d0:	83 c4 10             	add    $0x10,%esp
801047d3:	85 c0                	test   %eax,%eax
801047d5:	74 22                	je     801047f9 <release+0x39>
  lk->pcs[0] = 0;
801047d7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801047de:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801047e5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801047ea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801047f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047f3:	c9                   	leave  
  popcli();
801047f4:	e9 77 fe ff ff       	jmp    80104670 <popcli>
    panic("release");
801047f9:	83 ec 0c             	sub    $0xc,%esp
801047fc:	68 f5 7b 10 80       	push   $0x80107bf5
80104801:	e8 8a bb ff ff       	call   80100390 <panic>
80104806:	66 90                	xchg   %ax,%ax
80104808:	66 90                	xchg   %ax,%ax
8010480a:	66 90                	xchg   %ax,%ax
8010480c:	66 90                	xchg   %ax,%ax
8010480e:	66 90                	xchg   %ax,%ax

80104810 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	57                   	push   %edi
80104814:	53                   	push   %ebx
80104815:	8b 55 08             	mov    0x8(%ebp),%edx
80104818:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010481b:	f6 c2 03             	test   $0x3,%dl
8010481e:	75 05                	jne    80104825 <memset+0x15>
80104820:	f6 c1 03             	test   $0x3,%cl
80104823:	74 13                	je     80104838 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104825:	89 d7                	mov    %edx,%edi
80104827:	8b 45 0c             	mov    0xc(%ebp),%eax
8010482a:	fc                   	cld    
8010482b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010482d:	5b                   	pop    %ebx
8010482e:	89 d0                	mov    %edx,%eax
80104830:	5f                   	pop    %edi
80104831:	5d                   	pop    %ebp
80104832:	c3                   	ret    
80104833:	90                   	nop
80104834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104838:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010483c:	c1 e9 02             	shr    $0x2,%ecx
8010483f:	89 f8                	mov    %edi,%eax
80104841:	89 fb                	mov    %edi,%ebx
80104843:	c1 e0 18             	shl    $0x18,%eax
80104846:	c1 e3 10             	shl    $0x10,%ebx
80104849:	09 d8                	or     %ebx,%eax
8010484b:	09 f8                	or     %edi,%eax
8010484d:	c1 e7 08             	shl    $0x8,%edi
80104850:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104852:	89 d7                	mov    %edx,%edi
80104854:	fc                   	cld    
80104855:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104857:	5b                   	pop    %ebx
80104858:	89 d0                	mov    %edx,%eax
8010485a:	5f                   	pop    %edi
8010485b:	5d                   	pop    %ebp
8010485c:	c3                   	ret    
8010485d:	8d 76 00             	lea    0x0(%esi),%esi

80104860 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	57                   	push   %edi
80104864:	56                   	push   %esi
80104865:	53                   	push   %ebx
80104866:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104869:	8b 75 08             	mov    0x8(%ebp),%esi
8010486c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010486f:	85 db                	test   %ebx,%ebx
80104871:	74 29                	je     8010489c <memcmp+0x3c>
    if(*s1 != *s2)
80104873:	0f b6 16             	movzbl (%esi),%edx
80104876:	0f b6 0f             	movzbl (%edi),%ecx
80104879:	38 d1                	cmp    %dl,%cl
8010487b:	75 2b                	jne    801048a8 <memcmp+0x48>
8010487d:	b8 01 00 00 00       	mov    $0x1,%eax
80104882:	eb 14                	jmp    80104898 <memcmp+0x38>
80104884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104888:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010488c:	83 c0 01             	add    $0x1,%eax
8010488f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104894:	38 ca                	cmp    %cl,%dl
80104896:	75 10                	jne    801048a8 <memcmp+0x48>
  while(n-- > 0){
80104898:	39 d8                	cmp    %ebx,%eax
8010489a:	75 ec                	jne    80104888 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010489c:	5b                   	pop    %ebx
  return 0;
8010489d:	31 c0                	xor    %eax,%eax
}
8010489f:	5e                   	pop    %esi
801048a0:	5f                   	pop    %edi
801048a1:	5d                   	pop    %ebp
801048a2:	c3                   	ret    
801048a3:	90                   	nop
801048a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801048a8:	0f b6 c2             	movzbl %dl,%eax
}
801048ab:	5b                   	pop    %ebx
      return *s1 - *s2;
801048ac:	29 c8                	sub    %ecx,%eax
}
801048ae:	5e                   	pop    %esi
801048af:	5f                   	pop    %edi
801048b0:	5d                   	pop    %ebp
801048b1:	c3                   	ret    
801048b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048c0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	56                   	push   %esi
801048c4:	53                   	push   %ebx
801048c5:	8b 45 08             	mov    0x8(%ebp),%eax
801048c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801048cb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801048ce:	39 c3                	cmp    %eax,%ebx
801048d0:	73 26                	jae    801048f8 <memmove+0x38>
801048d2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801048d5:	39 c8                	cmp    %ecx,%eax
801048d7:	73 1f                	jae    801048f8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801048d9:	85 f6                	test   %esi,%esi
801048db:	8d 56 ff             	lea    -0x1(%esi),%edx
801048de:	74 0f                	je     801048ef <memmove+0x2f>
      *--d = *--s;
801048e0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801048e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801048e7:	83 ea 01             	sub    $0x1,%edx
801048ea:	83 fa ff             	cmp    $0xffffffff,%edx
801048ed:	75 f1                	jne    801048e0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801048ef:	5b                   	pop    %ebx
801048f0:	5e                   	pop    %esi
801048f1:	5d                   	pop    %ebp
801048f2:	c3                   	ret    
801048f3:	90                   	nop
801048f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801048f8:	31 d2                	xor    %edx,%edx
801048fa:	85 f6                	test   %esi,%esi
801048fc:	74 f1                	je     801048ef <memmove+0x2f>
801048fe:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104900:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104904:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104907:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010490a:	39 d6                	cmp    %edx,%esi
8010490c:	75 f2                	jne    80104900 <memmove+0x40>
}
8010490e:	5b                   	pop    %ebx
8010490f:	5e                   	pop    %esi
80104910:	5d                   	pop    %ebp
80104911:	c3                   	ret    
80104912:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104920 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104923:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104924:	eb 9a                	jmp    801048c0 <memmove>
80104926:	8d 76 00             	lea    0x0(%esi),%esi
80104929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104930 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	57                   	push   %edi
80104934:	56                   	push   %esi
80104935:	8b 7d 10             	mov    0x10(%ebp),%edi
80104938:	53                   	push   %ebx
80104939:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010493c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010493f:	85 ff                	test   %edi,%edi
80104941:	74 2f                	je     80104972 <strncmp+0x42>
80104943:	0f b6 01             	movzbl (%ecx),%eax
80104946:	0f b6 1e             	movzbl (%esi),%ebx
80104949:	84 c0                	test   %al,%al
8010494b:	74 37                	je     80104984 <strncmp+0x54>
8010494d:	38 c3                	cmp    %al,%bl
8010494f:	75 33                	jne    80104984 <strncmp+0x54>
80104951:	01 f7                	add    %esi,%edi
80104953:	eb 13                	jmp    80104968 <strncmp+0x38>
80104955:	8d 76 00             	lea    0x0(%esi),%esi
80104958:	0f b6 01             	movzbl (%ecx),%eax
8010495b:	84 c0                	test   %al,%al
8010495d:	74 21                	je     80104980 <strncmp+0x50>
8010495f:	0f b6 1a             	movzbl (%edx),%ebx
80104962:	89 d6                	mov    %edx,%esi
80104964:	38 d8                	cmp    %bl,%al
80104966:	75 1c                	jne    80104984 <strncmp+0x54>
    n--, p++, q++;
80104968:	8d 56 01             	lea    0x1(%esi),%edx
8010496b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010496e:	39 fa                	cmp    %edi,%edx
80104970:	75 e6                	jne    80104958 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104972:	5b                   	pop    %ebx
    return 0;
80104973:	31 c0                	xor    %eax,%eax
}
80104975:	5e                   	pop    %esi
80104976:	5f                   	pop    %edi
80104977:	5d                   	pop    %ebp
80104978:	c3                   	ret    
80104979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104980:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104984:	29 d8                	sub    %ebx,%eax
}
80104986:	5b                   	pop    %ebx
80104987:	5e                   	pop    %esi
80104988:	5f                   	pop    %edi
80104989:	5d                   	pop    %ebp
8010498a:	c3                   	ret    
8010498b:	90                   	nop
8010498c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104990 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	56                   	push   %esi
80104994:	53                   	push   %ebx
80104995:	8b 45 08             	mov    0x8(%ebp),%eax
80104998:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010499b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010499e:	89 c2                	mov    %eax,%edx
801049a0:	eb 19                	jmp    801049bb <strncpy+0x2b>
801049a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049a8:	83 c3 01             	add    $0x1,%ebx
801049ab:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801049af:	83 c2 01             	add    $0x1,%edx
801049b2:	84 c9                	test   %cl,%cl
801049b4:	88 4a ff             	mov    %cl,-0x1(%edx)
801049b7:	74 09                	je     801049c2 <strncpy+0x32>
801049b9:	89 f1                	mov    %esi,%ecx
801049bb:	85 c9                	test   %ecx,%ecx
801049bd:	8d 71 ff             	lea    -0x1(%ecx),%esi
801049c0:	7f e6                	jg     801049a8 <strncpy+0x18>
    ;
  while(n-- > 0)
801049c2:	31 c9                	xor    %ecx,%ecx
801049c4:	85 f6                	test   %esi,%esi
801049c6:	7e 17                	jle    801049df <strncpy+0x4f>
801049c8:	90                   	nop
801049c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801049d0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801049d4:	89 f3                	mov    %esi,%ebx
801049d6:	83 c1 01             	add    $0x1,%ecx
801049d9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801049db:	85 db                	test   %ebx,%ebx
801049dd:	7f f1                	jg     801049d0 <strncpy+0x40>
  return os;
}
801049df:	5b                   	pop    %ebx
801049e0:	5e                   	pop    %esi
801049e1:	5d                   	pop    %ebp
801049e2:	c3                   	ret    
801049e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	53                   	push   %ebx
801049f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801049f8:	8b 45 08             	mov    0x8(%ebp),%eax
801049fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801049fe:	85 c9                	test   %ecx,%ecx
80104a00:	7e 26                	jle    80104a28 <safestrcpy+0x38>
80104a02:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104a06:	89 c1                	mov    %eax,%ecx
80104a08:	eb 17                	jmp    80104a21 <safestrcpy+0x31>
80104a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a10:	83 c2 01             	add    $0x1,%edx
80104a13:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104a17:	83 c1 01             	add    $0x1,%ecx
80104a1a:	84 db                	test   %bl,%bl
80104a1c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104a1f:	74 04                	je     80104a25 <safestrcpy+0x35>
80104a21:	39 f2                	cmp    %esi,%edx
80104a23:	75 eb                	jne    80104a10 <safestrcpy+0x20>
    ;
  *s = 0;
80104a25:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104a28:	5b                   	pop    %ebx
80104a29:	5e                   	pop    %esi
80104a2a:	5d                   	pop    %ebp
80104a2b:	c3                   	ret    
80104a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a30 <strlen>:

int
strlen(const char *s)
{
80104a30:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a31:	31 c0                	xor    %eax,%eax
{
80104a33:	89 e5                	mov    %esp,%ebp
80104a35:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a38:	80 3a 00             	cmpb   $0x0,(%edx)
80104a3b:	74 0c                	je     80104a49 <strlen+0x19>
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi
80104a40:	83 c0 01             	add    $0x1,%eax
80104a43:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104a47:	75 f7                	jne    80104a40 <strlen+0x10>
    ;
  return n;
}
80104a49:	5d                   	pop    %ebp
80104a4a:	c3                   	ret    

80104a4b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104a4b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104a4f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104a53:	55                   	push   %ebp
  pushl %ebx
80104a54:	53                   	push   %ebx
  pushl %esi
80104a55:	56                   	push   %esi
  pushl %edi
80104a56:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a57:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104a59:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104a5b:	5f                   	pop    %edi
  popl %esi
80104a5c:	5e                   	pop    %esi
  popl %ebx
80104a5d:	5b                   	pop    %ebx
  popl %ebp
80104a5e:	5d                   	pop    %ebp
  ret
80104a5f:	c3                   	ret    

80104a60 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	53                   	push   %ebx
80104a64:	83 ec 04             	sub    $0x4,%esp
80104a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a6a:	e8 c1 ee ff ff       	call   80103930 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a6f:	8b 00                	mov    (%eax),%eax
80104a71:	39 d8                	cmp    %ebx,%eax
80104a73:	76 1b                	jbe    80104a90 <fetchint+0x30>
80104a75:	8d 53 04             	lea    0x4(%ebx),%edx
80104a78:	39 d0                	cmp    %edx,%eax
80104a7a:	72 14                	jb     80104a90 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a7f:	8b 13                	mov    (%ebx),%edx
80104a81:	89 10                	mov    %edx,(%eax)
  return 0;
80104a83:	31 c0                	xor    %eax,%eax
}
80104a85:	83 c4 04             	add    $0x4,%esp
80104a88:	5b                   	pop    %ebx
80104a89:	5d                   	pop    %ebp
80104a8a:	c3                   	ret    
80104a8b:	90                   	nop
80104a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a95:	eb ee                	jmp    80104a85 <fetchint+0x25>
80104a97:	89 f6                	mov    %esi,%esi
80104a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104aa0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	53                   	push   %ebx
80104aa4:	83 ec 04             	sub    $0x4,%esp
80104aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104aaa:	e8 81 ee ff ff       	call   80103930 <myproc>

  if(addr >= curproc->sz)
80104aaf:	39 18                	cmp    %ebx,(%eax)
80104ab1:	76 29                	jbe    80104adc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104ab3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104ab6:	89 da                	mov    %ebx,%edx
80104ab8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104aba:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104abc:	39 c3                	cmp    %eax,%ebx
80104abe:	73 1c                	jae    80104adc <fetchstr+0x3c>
    if(*s == 0)
80104ac0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104ac3:	75 10                	jne    80104ad5 <fetchstr+0x35>
80104ac5:	eb 39                	jmp    80104b00 <fetchstr+0x60>
80104ac7:	89 f6                	mov    %esi,%esi
80104ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104ad0:	80 3a 00             	cmpb   $0x0,(%edx)
80104ad3:	74 1b                	je     80104af0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104ad5:	83 c2 01             	add    $0x1,%edx
80104ad8:	39 d0                	cmp    %edx,%eax
80104ada:	77 f4                	ja     80104ad0 <fetchstr+0x30>
    return -1;
80104adc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104ae1:	83 c4 04             	add    $0x4,%esp
80104ae4:	5b                   	pop    %ebx
80104ae5:	5d                   	pop    %ebp
80104ae6:	c3                   	ret    
80104ae7:	89 f6                	mov    %esi,%esi
80104ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104af0:	83 c4 04             	add    $0x4,%esp
80104af3:	89 d0                	mov    %edx,%eax
80104af5:	29 d8                	sub    %ebx,%eax
80104af7:	5b                   	pop    %ebx
80104af8:	5d                   	pop    %ebp
80104af9:	c3                   	ret    
80104afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104b00:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104b02:	eb dd                	jmp    80104ae1 <fetchstr+0x41>
80104b04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104b10 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	56                   	push   %esi
80104b14:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b15:	e8 16 ee ff ff       	call   80103930 <myproc>
80104b1a:	8b 40 18             	mov    0x18(%eax),%eax
80104b1d:	8b 55 08             	mov    0x8(%ebp),%edx
80104b20:	8b 40 44             	mov    0x44(%eax),%eax
80104b23:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b26:	e8 05 ee ff ff       	call   80103930 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b2b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b2d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b30:	39 c6                	cmp    %eax,%esi
80104b32:	73 1c                	jae    80104b50 <argint+0x40>
80104b34:	8d 53 08             	lea    0x8(%ebx),%edx
80104b37:	39 d0                	cmp    %edx,%eax
80104b39:	72 15                	jb     80104b50 <argint+0x40>
  *ip = *(int*)(addr);
80104b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b3e:	8b 53 04             	mov    0x4(%ebx),%edx
80104b41:	89 10                	mov    %edx,(%eax)
  return 0;
80104b43:	31 c0                	xor    %eax,%eax
}
80104b45:	5b                   	pop    %ebx
80104b46:	5e                   	pop    %esi
80104b47:	5d                   	pop    %ebp
80104b48:	c3                   	ret    
80104b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b55:	eb ee                	jmp    80104b45 <argint+0x35>
80104b57:	89 f6                	mov    %esi,%esi
80104b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b60 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	56                   	push   %esi
80104b64:	53                   	push   %ebx
80104b65:	83 ec 10             	sub    $0x10,%esp
80104b68:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104b6b:	e8 c0 ed ff ff       	call   80103930 <myproc>
80104b70:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104b72:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b75:	83 ec 08             	sub    $0x8,%esp
80104b78:	50                   	push   %eax
80104b79:	ff 75 08             	pushl  0x8(%ebp)
80104b7c:	e8 8f ff ff ff       	call   80104b10 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b81:	83 c4 10             	add    $0x10,%esp
80104b84:	85 c0                	test   %eax,%eax
80104b86:	78 28                	js     80104bb0 <argptr+0x50>
80104b88:	85 db                	test   %ebx,%ebx
80104b8a:	78 24                	js     80104bb0 <argptr+0x50>
80104b8c:	8b 16                	mov    (%esi),%edx
80104b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b91:	39 c2                	cmp    %eax,%edx
80104b93:	76 1b                	jbe    80104bb0 <argptr+0x50>
80104b95:	01 c3                	add    %eax,%ebx
80104b97:	39 da                	cmp    %ebx,%edx
80104b99:	72 15                	jb     80104bb0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104b9b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b9e:	89 02                	mov    %eax,(%edx)
  return 0;
80104ba0:	31 c0                	xor    %eax,%eax
}
80104ba2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ba5:	5b                   	pop    %ebx
80104ba6:	5e                   	pop    %esi
80104ba7:	5d                   	pop    %ebp
80104ba8:	c3                   	ret    
80104ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bb5:	eb eb                	jmp    80104ba2 <argptr+0x42>
80104bb7:	89 f6                	mov    %esi,%esi
80104bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bc0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104bc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bc9:	50                   	push   %eax
80104bca:	ff 75 08             	pushl  0x8(%ebp)
80104bcd:	e8 3e ff ff ff       	call   80104b10 <argint>
80104bd2:	83 c4 10             	add    $0x10,%esp
80104bd5:	85 c0                	test   %eax,%eax
80104bd7:	78 17                	js     80104bf0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104bd9:	83 ec 08             	sub    $0x8,%esp
80104bdc:	ff 75 0c             	pushl  0xc(%ebp)
80104bdf:	ff 75 f4             	pushl  -0xc(%ebp)
80104be2:	e8 b9 fe ff ff       	call   80104aa0 <fetchstr>
80104be7:	83 c4 10             	add    $0x10,%esp
}
80104bea:	c9                   	leave  
80104beb:	c3                   	ret    
80104bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104bf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bf5:	c9                   	leave  
80104bf6:	c3                   	ret    
80104bf7:	89 f6                	mov    %esi,%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c00 <syscall>:
[SYS_getnice] sys_getnice,
};

void
syscall(void)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	53                   	push   %ebx
80104c04:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c07:	e8 24 ed ff ff       	call   80103930 <myproc>
80104c0c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c0e:	8b 40 18             	mov    0x18(%eax),%eax
80104c11:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c14:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c17:	83 fa 1a             	cmp    $0x1a,%edx
80104c1a:	77 1c                	ja     80104c38 <syscall+0x38>
80104c1c:	8b 14 85 20 7c 10 80 	mov    -0x7fef83e0(,%eax,4),%edx
80104c23:	85 d2                	test   %edx,%edx
80104c25:	74 11                	je     80104c38 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104c27:	ff d2                	call   *%edx
80104c29:	8b 53 18             	mov    0x18(%ebx),%edx
80104c2c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c32:	c9                   	leave  
80104c33:	c3                   	ret    
80104c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104c38:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104c39:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104c3c:	50                   	push   %eax
80104c3d:	ff 73 10             	pushl  0x10(%ebx)
80104c40:	68 fd 7b 10 80       	push   $0x80107bfd
80104c45:	e8 16 ba ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104c4a:	8b 43 18             	mov    0x18(%ebx),%eax
80104c4d:	83 c4 10             	add    $0x10,%esp
80104c50:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104c57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c5a:	c9                   	leave  
80104c5b:	c3                   	ret    
80104c5c:	66 90                	xchg   %ax,%ax
80104c5e:	66 90                	xchg   %ax,%ax

80104c60 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	57                   	push   %edi
80104c64:	56                   	push   %esi
80104c65:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104c66:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104c69:	83 ec 44             	sub    $0x44,%esp
80104c6c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104c6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104c72:	56                   	push   %esi
80104c73:	50                   	push   %eax
{
80104c74:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104c77:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104c7a:	e8 91 d2 ff ff       	call   80101f10 <nameiparent>
80104c7f:	83 c4 10             	add    $0x10,%esp
80104c82:	85 c0                	test   %eax,%eax
80104c84:	0f 84 46 01 00 00    	je     80104dd0 <create+0x170>
    return 0;
  ilock(dp);
80104c8a:	83 ec 0c             	sub    $0xc,%esp
80104c8d:	89 c3                	mov    %eax,%ebx
80104c8f:	50                   	push   %eax
80104c90:	e8 fb c9 ff ff       	call   80101690 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104c95:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104c98:	83 c4 0c             	add    $0xc,%esp
80104c9b:	50                   	push   %eax
80104c9c:	56                   	push   %esi
80104c9d:	53                   	push   %ebx
80104c9e:	e8 1d cf ff ff       	call   80101bc0 <dirlookup>
80104ca3:	83 c4 10             	add    $0x10,%esp
80104ca6:	85 c0                	test   %eax,%eax
80104ca8:	89 c7                	mov    %eax,%edi
80104caa:	74 34                	je     80104ce0 <create+0x80>
    iunlockput(dp);
80104cac:	83 ec 0c             	sub    $0xc,%esp
80104caf:	53                   	push   %ebx
80104cb0:	e8 6b cc ff ff       	call   80101920 <iunlockput>
    ilock(ip);
80104cb5:	89 3c 24             	mov    %edi,(%esp)
80104cb8:	e8 d3 c9 ff ff       	call   80101690 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104cbd:	83 c4 10             	add    $0x10,%esp
80104cc0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104cc5:	0f 85 95 00 00 00    	jne    80104d60 <create+0x100>
80104ccb:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104cd0:	0f 85 8a 00 00 00    	jne    80104d60 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104cd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cd9:	89 f8                	mov    %edi,%eax
80104cdb:	5b                   	pop    %ebx
80104cdc:	5e                   	pop    %esi
80104cdd:	5f                   	pop    %edi
80104cde:	5d                   	pop    %ebp
80104cdf:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104ce0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104ce4:	83 ec 08             	sub    $0x8,%esp
80104ce7:	50                   	push   %eax
80104ce8:	ff 33                	pushl  (%ebx)
80104cea:	e8 31 c8 ff ff       	call   80101520 <ialloc>
80104cef:	83 c4 10             	add    $0x10,%esp
80104cf2:	85 c0                	test   %eax,%eax
80104cf4:	89 c7                	mov    %eax,%edi
80104cf6:	0f 84 e8 00 00 00    	je     80104de4 <create+0x184>
  ilock(ip);
80104cfc:	83 ec 0c             	sub    $0xc,%esp
80104cff:	50                   	push   %eax
80104d00:	e8 8b c9 ff ff       	call   80101690 <ilock>
  ip->major = major;
80104d05:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104d09:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104d0d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104d11:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104d15:	b8 01 00 00 00       	mov    $0x1,%eax
80104d1a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104d1e:	89 3c 24             	mov    %edi,(%esp)
80104d21:	e8 ba c8 ff ff       	call   801015e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104d26:	83 c4 10             	add    $0x10,%esp
80104d29:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104d2e:	74 50                	je     80104d80 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104d30:	83 ec 04             	sub    $0x4,%esp
80104d33:	ff 77 04             	pushl  0x4(%edi)
80104d36:	56                   	push   %esi
80104d37:	53                   	push   %ebx
80104d38:	e8 f3 d0 ff ff       	call   80101e30 <dirlink>
80104d3d:	83 c4 10             	add    $0x10,%esp
80104d40:	85 c0                	test   %eax,%eax
80104d42:	0f 88 8f 00 00 00    	js     80104dd7 <create+0x177>
  iunlockput(dp);
80104d48:	83 ec 0c             	sub    $0xc,%esp
80104d4b:	53                   	push   %ebx
80104d4c:	e8 cf cb ff ff       	call   80101920 <iunlockput>
  return ip;
80104d51:	83 c4 10             	add    $0x10,%esp
}
80104d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d57:	89 f8                	mov    %edi,%eax
80104d59:	5b                   	pop    %ebx
80104d5a:	5e                   	pop    %esi
80104d5b:	5f                   	pop    %edi
80104d5c:	5d                   	pop    %ebp
80104d5d:	c3                   	ret    
80104d5e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104d60:	83 ec 0c             	sub    $0xc,%esp
80104d63:	57                   	push   %edi
    return 0;
80104d64:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104d66:	e8 b5 cb ff ff       	call   80101920 <iunlockput>
    return 0;
80104d6b:	83 c4 10             	add    $0x10,%esp
}
80104d6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d71:	89 f8                	mov    %edi,%eax
80104d73:	5b                   	pop    %ebx
80104d74:	5e                   	pop    %esi
80104d75:	5f                   	pop    %edi
80104d76:	5d                   	pop    %ebp
80104d77:	c3                   	ret    
80104d78:	90                   	nop
80104d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104d80:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104d85:	83 ec 0c             	sub    $0xc,%esp
80104d88:	53                   	push   %ebx
80104d89:	e8 52 c8 ff ff       	call   801015e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104d8e:	83 c4 0c             	add    $0xc,%esp
80104d91:	ff 77 04             	pushl  0x4(%edi)
80104d94:	68 ac 7c 10 80       	push   $0x80107cac
80104d99:	57                   	push   %edi
80104d9a:	e8 91 d0 ff ff       	call   80101e30 <dirlink>
80104d9f:	83 c4 10             	add    $0x10,%esp
80104da2:	85 c0                	test   %eax,%eax
80104da4:	78 1c                	js     80104dc2 <create+0x162>
80104da6:	83 ec 04             	sub    $0x4,%esp
80104da9:	ff 73 04             	pushl  0x4(%ebx)
80104dac:	68 ab 7c 10 80       	push   $0x80107cab
80104db1:	57                   	push   %edi
80104db2:	e8 79 d0 ff ff       	call   80101e30 <dirlink>
80104db7:	83 c4 10             	add    $0x10,%esp
80104dba:	85 c0                	test   %eax,%eax
80104dbc:	0f 89 6e ff ff ff    	jns    80104d30 <create+0xd0>
      panic("create dots");
80104dc2:	83 ec 0c             	sub    $0xc,%esp
80104dc5:	68 9f 7c 10 80       	push   $0x80107c9f
80104dca:	e8 c1 b5 ff ff       	call   80100390 <panic>
80104dcf:	90                   	nop
    return 0;
80104dd0:	31 ff                	xor    %edi,%edi
80104dd2:	e9 ff fe ff ff       	jmp    80104cd6 <create+0x76>
    panic("create: dirlink");
80104dd7:	83 ec 0c             	sub    $0xc,%esp
80104dda:	68 ae 7c 10 80       	push   $0x80107cae
80104ddf:	e8 ac b5 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104de4:	83 ec 0c             	sub    $0xc,%esp
80104de7:	68 90 7c 10 80       	push   $0x80107c90
80104dec:	e8 9f b5 ff ff       	call   80100390 <panic>
80104df1:	eb 0d                	jmp    80104e00 <argfd.constprop.0>
80104df3:	90                   	nop
80104df4:	90                   	nop
80104df5:	90                   	nop
80104df6:	90                   	nop
80104df7:	90                   	nop
80104df8:	90                   	nop
80104df9:	90                   	nop
80104dfa:	90                   	nop
80104dfb:	90                   	nop
80104dfc:	90                   	nop
80104dfd:	90                   	nop
80104dfe:	90                   	nop
80104dff:	90                   	nop

80104e00 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	56                   	push   %esi
80104e04:	53                   	push   %ebx
80104e05:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104e07:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104e0a:	89 d6                	mov    %edx,%esi
80104e0c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e0f:	50                   	push   %eax
80104e10:	6a 00                	push   $0x0
80104e12:	e8 f9 fc ff ff       	call   80104b10 <argint>
80104e17:	83 c4 10             	add    $0x10,%esp
80104e1a:	85 c0                	test   %eax,%eax
80104e1c:	78 2a                	js     80104e48 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e1e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e22:	77 24                	ja     80104e48 <argfd.constprop.0+0x48>
80104e24:	e8 07 eb ff ff       	call   80103930 <myproc>
80104e29:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e2c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104e30:	85 c0                	test   %eax,%eax
80104e32:	74 14                	je     80104e48 <argfd.constprop.0+0x48>
  if(pfd)
80104e34:	85 db                	test   %ebx,%ebx
80104e36:	74 02                	je     80104e3a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104e38:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104e3a:	89 06                	mov    %eax,(%esi)
  return 0;
80104e3c:	31 c0                	xor    %eax,%eax
}
80104e3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e41:	5b                   	pop    %ebx
80104e42:	5e                   	pop    %esi
80104e43:	5d                   	pop    %ebp
80104e44:	c3                   	ret    
80104e45:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104e48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e4d:	eb ef                	jmp    80104e3e <argfd.constprop.0+0x3e>
80104e4f:	90                   	nop

80104e50 <sys_dup>:
{
80104e50:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104e51:	31 c0                	xor    %eax,%eax
{
80104e53:	89 e5                	mov    %esp,%ebp
80104e55:	56                   	push   %esi
80104e56:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104e57:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104e5a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104e5d:	e8 9e ff ff ff       	call   80104e00 <argfd.constprop.0>
80104e62:	85 c0                	test   %eax,%eax
80104e64:	78 42                	js     80104ea8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104e66:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104e69:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104e6b:	e8 c0 ea ff ff       	call   80103930 <myproc>
80104e70:	eb 0e                	jmp    80104e80 <sys_dup+0x30>
80104e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104e78:	83 c3 01             	add    $0x1,%ebx
80104e7b:	83 fb 10             	cmp    $0x10,%ebx
80104e7e:	74 28                	je     80104ea8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104e80:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104e84:	85 d2                	test   %edx,%edx
80104e86:	75 f0                	jne    80104e78 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104e88:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104e8c:	83 ec 0c             	sub    $0xc,%esp
80104e8f:	ff 75 f4             	pushl  -0xc(%ebp)
80104e92:	e8 59 bf ff ff       	call   80100df0 <filedup>
  return fd;
80104e97:	83 c4 10             	add    $0x10,%esp
}
80104e9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e9d:	89 d8                	mov    %ebx,%eax
80104e9f:	5b                   	pop    %ebx
80104ea0:	5e                   	pop    %esi
80104ea1:	5d                   	pop    %ebp
80104ea2:	c3                   	ret    
80104ea3:	90                   	nop
80104ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ea8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104eab:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104eb0:	89 d8                	mov    %ebx,%eax
80104eb2:	5b                   	pop    %ebx
80104eb3:	5e                   	pop    %esi
80104eb4:	5d                   	pop    %ebp
80104eb5:	c3                   	ret    
80104eb6:	8d 76 00             	lea    0x0(%esi),%esi
80104eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ec0 <sys_read>:
{
80104ec0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ec1:	31 c0                	xor    %eax,%eax
{
80104ec3:	89 e5                	mov    %esp,%ebp
80104ec5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ec8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104ecb:	e8 30 ff ff ff       	call   80104e00 <argfd.constprop.0>
80104ed0:	85 c0                	test   %eax,%eax
80104ed2:	78 4c                	js     80104f20 <sys_read+0x60>
80104ed4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ed7:	83 ec 08             	sub    $0x8,%esp
80104eda:	50                   	push   %eax
80104edb:	6a 02                	push   $0x2
80104edd:	e8 2e fc ff ff       	call   80104b10 <argint>
80104ee2:	83 c4 10             	add    $0x10,%esp
80104ee5:	85 c0                	test   %eax,%eax
80104ee7:	78 37                	js     80104f20 <sys_read+0x60>
80104ee9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104eec:	83 ec 04             	sub    $0x4,%esp
80104eef:	ff 75 f0             	pushl  -0x10(%ebp)
80104ef2:	50                   	push   %eax
80104ef3:	6a 01                	push   $0x1
80104ef5:	e8 66 fc ff ff       	call   80104b60 <argptr>
80104efa:	83 c4 10             	add    $0x10,%esp
80104efd:	85 c0                	test   %eax,%eax
80104eff:	78 1f                	js     80104f20 <sys_read+0x60>
  return fileread(f, p, n);
80104f01:	83 ec 04             	sub    $0x4,%esp
80104f04:	ff 75 f0             	pushl  -0x10(%ebp)
80104f07:	ff 75 f4             	pushl  -0xc(%ebp)
80104f0a:	ff 75 ec             	pushl  -0x14(%ebp)
80104f0d:	e8 4e c0 ff ff       	call   80100f60 <fileread>
80104f12:	83 c4 10             	add    $0x10,%esp
}
80104f15:	c9                   	leave  
80104f16:	c3                   	ret    
80104f17:	89 f6                	mov    %esi,%esi
80104f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f25:	c9                   	leave  
80104f26:	c3                   	ret    
80104f27:	89 f6                	mov    %esi,%esi
80104f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f30 <sys_write>:
{
80104f30:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f31:	31 c0                	xor    %eax,%eax
{
80104f33:	89 e5                	mov    %esp,%ebp
80104f35:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f38:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104f3b:	e8 c0 fe ff ff       	call   80104e00 <argfd.constprop.0>
80104f40:	85 c0                	test   %eax,%eax
80104f42:	78 4c                	js     80104f90 <sys_write+0x60>
80104f44:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f47:	83 ec 08             	sub    $0x8,%esp
80104f4a:	50                   	push   %eax
80104f4b:	6a 02                	push   $0x2
80104f4d:	e8 be fb ff ff       	call   80104b10 <argint>
80104f52:	83 c4 10             	add    $0x10,%esp
80104f55:	85 c0                	test   %eax,%eax
80104f57:	78 37                	js     80104f90 <sys_write+0x60>
80104f59:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f5c:	83 ec 04             	sub    $0x4,%esp
80104f5f:	ff 75 f0             	pushl  -0x10(%ebp)
80104f62:	50                   	push   %eax
80104f63:	6a 01                	push   $0x1
80104f65:	e8 f6 fb ff ff       	call   80104b60 <argptr>
80104f6a:	83 c4 10             	add    $0x10,%esp
80104f6d:	85 c0                	test   %eax,%eax
80104f6f:	78 1f                	js     80104f90 <sys_write+0x60>
  return filewrite(f, p, n);
80104f71:	83 ec 04             	sub    $0x4,%esp
80104f74:	ff 75 f0             	pushl  -0x10(%ebp)
80104f77:	ff 75 f4             	pushl  -0xc(%ebp)
80104f7a:	ff 75 ec             	pushl  -0x14(%ebp)
80104f7d:	e8 6e c0 ff ff       	call   80100ff0 <filewrite>
80104f82:	83 c4 10             	add    $0x10,%esp
}
80104f85:	c9                   	leave  
80104f86:	c3                   	ret    
80104f87:	89 f6                	mov    %esi,%esi
80104f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f95:	c9                   	leave  
80104f96:	c3                   	ret    
80104f97:	89 f6                	mov    %esi,%esi
80104f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fa0 <sys_close>:
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104fa6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104fa9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fac:	e8 4f fe ff ff       	call   80104e00 <argfd.constprop.0>
80104fb1:	85 c0                	test   %eax,%eax
80104fb3:	78 2b                	js     80104fe0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104fb5:	e8 76 e9 ff ff       	call   80103930 <myproc>
80104fba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104fbd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104fc0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104fc7:	00 
  fileclose(f);
80104fc8:	ff 75 f4             	pushl  -0xc(%ebp)
80104fcb:	e8 70 be ff ff       	call   80100e40 <fileclose>
  return 0;
80104fd0:	83 c4 10             	add    $0x10,%esp
80104fd3:	31 c0                	xor    %eax,%eax
}
80104fd5:	c9                   	leave  
80104fd6:	c3                   	ret    
80104fd7:	89 f6                	mov    %esi,%esi
80104fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fe5:	c9                   	leave  
80104fe6:	c3                   	ret    
80104fe7:	89 f6                	mov    %esi,%esi
80104fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ff0 <sys_fstat>:
{
80104ff0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ff1:	31 c0                	xor    %eax,%eax
{
80104ff3:	89 e5                	mov    %esp,%ebp
80104ff5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ff8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104ffb:	e8 00 fe ff ff       	call   80104e00 <argfd.constprop.0>
80105000:	85 c0                	test   %eax,%eax
80105002:	78 2c                	js     80105030 <sys_fstat+0x40>
80105004:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105007:	83 ec 04             	sub    $0x4,%esp
8010500a:	6a 14                	push   $0x14
8010500c:	50                   	push   %eax
8010500d:	6a 01                	push   $0x1
8010500f:	e8 4c fb ff ff       	call   80104b60 <argptr>
80105014:	83 c4 10             	add    $0x10,%esp
80105017:	85 c0                	test   %eax,%eax
80105019:	78 15                	js     80105030 <sys_fstat+0x40>
  return filestat(f, st);
8010501b:	83 ec 08             	sub    $0x8,%esp
8010501e:	ff 75 f4             	pushl  -0xc(%ebp)
80105021:	ff 75 f0             	pushl  -0x10(%ebp)
80105024:	e8 e7 be ff ff       	call   80100f10 <filestat>
80105029:	83 c4 10             	add    $0x10,%esp
}
8010502c:	c9                   	leave  
8010502d:	c3                   	ret    
8010502e:	66 90                	xchg   %ax,%ax
    return -1;
80105030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105035:	c9                   	leave  
80105036:	c3                   	ret    
80105037:	89 f6                	mov    %esi,%esi
80105039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105040 <sys_link>:
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	57                   	push   %edi
80105044:	56                   	push   %esi
80105045:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105046:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105049:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010504c:	50                   	push   %eax
8010504d:	6a 00                	push   $0x0
8010504f:	e8 6c fb ff ff       	call   80104bc0 <argstr>
80105054:	83 c4 10             	add    $0x10,%esp
80105057:	85 c0                	test   %eax,%eax
80105059:	0f 88 fb 00 00 00    	js     8010515a <sys_link+0x11a>
8010505f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105062:	83 ec 08             	sub    $0x8,%esp
80105065:	50                   	push   %eax
80105066:	6a 01                	push   $0x1
80105068:	e8 53 fb ff ff       	call   80104bc0 <argstr>
8010506d:	83 c4 10             	add    $0x10,%esp
80105070:	85 c0                	test   %eax,%eax
80105072:	0f 88 e2 00 00 00    	js     8010515a <sys_link+0x11a>
  begin_op();
80105078:	e8 43 dc ff ff       	call   80102cc0 <begin_op>
  if((ip = namei(old)) == 0){
8010507d:	83 ec 0c             	sub    $0xc,%esp
80105080:	ff 75 d4             	pushl  -0x2c(%ebp)
80105083:	e8 68 ce ff ff       	call   80101ef0 <namei>
80105088:	83 c4 10             	add    $0x10,%esp
8010508b:	85 c0                	test   %eax,%eax
8010508d:	89 c3                	mov    %eax,%ebx
8010508f:	0f 84 ea 00 00 00    	je     8010517f <sys_link+0x13f>
  ilock(ip);
80105095:	83 ec 0c             	sub    $0xc,%esp
80105098:	50                   	push   %eax
80105099:	e8 f2 c5 ff ff       	call   80101690 <ilock>
  if(ip->type == T_DIR){
8010509e:	83 c4 10             	add    $0x10,%esp
801050a1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050a6:	0f 84 bb 00 00 00    	je     80105167 <sys_link+0x127>
  ip->nlink++;
801050ac:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801050b1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
801050b4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801050b7:	53                   	push   %ebx
801050b8:	e8 23 c5 ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
801050bd:	89 1c 24             	mov    %ebx,(%esp)
801050c0:	e8 ab c6 ff ff       	call   80101770 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801050c5:	58                   	pop    %eax
801050c6:	5a                   	pop    %edx
801050c7:	57                   	push   %edi
801050c8:	ff 75 d0             	pushl  -0x30(%ebp)
801050cb:	e8 40 ce ff ff       	call   80101f10 <nameiparent>
801050d0:	83 c4 10             	add    $0x10,%esp
801050d3:	85 c0                	test   %eax,%eax
801050d5:	89 c6                	mov    %eax,%esi
801050d7:	74 5b                	je     80105134 <sys_link+0xf4>
  ilock(dp);
801050d9:	83 ec 0c             	sub    $0xc,%esp
801050dc:	50                   	push   %eax
801050dd:	e8 ae c5 ff ff       	call   80101690 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801050e2:	83 c4 10             	add    $0x10,%esp
801050e5:	8b 03                	mov    (%ebx),%eax
801050e7:	39 06                	cmp    %eax,(%esi)
801050e9:	75 3d                	jne    80105128 <sys_link+0xe8>
801050eb:	83 ec 04             	sub    $0x4,%esp
801050ee:	ff 73 04             	pushl  0x4(%ebx)
801050f1:	57                   	push   %edi
801050f2:	56                   	push   %esi
801050f3:	e8 38 cd ff ff       	call   80101e30 <dirlink>
801050f8:	83 c4 10             	add    $0x10,%esp
801050fb:	85 c0                	test   %eax,%eax
801050fd:	78 29                	js     80105128 <sys_link+0xe8>
  iunlockput(dp);
801050ff:	83 ec 0c             	sub    $0xc,%esp
80105102:	56                   	push   %esi
80105103:	e8 18 c8 ff ff       	call   80101920 <iunlockput>
  iput(ip);
80105108:	89 1c 24             	mov    %ebx,(%esp)
8010510b:	e8 b0 c6 ff ff       	call   801017c0 <iput>
  end_op();
80105110:	e8 1b dc ff ff       	call   80102d30 <end_op>
  return 0;
80105115:	83 c4 10             	add    $0x10,%esp
80105118:	31 c0                	xor    %eax,%eax
}
8010511a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010511d:	5b                   	pop    %ebx
8010511e:	5e                   	pop    %esi
8010511f:	5f                   	pop    %edi
80105120:	5d                   	pop    %ebp
80105121:	c3                   	ret    
80105122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105128:	83 ec 0c             	sub    $0xc,%esp
8010512b:	56                   	push   %esi
8010512c:	e8 ef c7 ff ff       	call   80101920 <iunlockput>
    goto bad;
80105131:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105134:	83 ec 0c             	sub    $0xc,%esp
80105137:	53                   	push   %ebx
80105138:	e8 53 c5 ff ff       	call   80101690 <ilock>
  ip->nlink--;
8010513d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105142:	89 1c 24             	mov    %ebx,(%esp)
80105145:	e8 96 c4 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
8010514a:	89 1c 24             	mov    %ebx,(%esp)
8010514d:	e8 ce c7 ff ff       	call   80101920 <iunlockput>
  end_op();
80105152:	e8 d9 db ff ff       	call   80102d30 <end_op>
  return -1;
80105157:	83 c4 10             	add    $0x10,%esp
}
8010515a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010515d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105162:	5b                   	pop    %ebx
80105163:	5e                   	pop    %esi
80105164:	5f                   	pop    %edi
80105165:	5d                   	pop    %ebp
80105166:	c3                   	ret    
    iunlockput(ip);
80105167:	83 ec 0c             	sub    $0xc,%esp
8010516a:	53                   	push   %ebx
8010516b:	e8 b0 c7 ff ff       	call   80101920 <iunlockput>
    end_op();
80105170:	e8 bb db ff ff       	call   80102d30 <end_op>
    return -1;
80105175:	83 c4 10             	add    $0x10,%esp
80105178:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010517d:	eb 9b                	jmp    8010511a <sys_link+0xda>
    end_op();
8010517f:	e8 ac db ff ff       	call   80102d30 <end_op>
    return -1;
80105184:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105189:	eb 8f                	jmp    8010511a <sys_link+0xda>
8010518b:	90                   	nop
8010518c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105190 <sys_unlink>:
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	57                   	push   %edi
80105194:	56                   	push   %esi
80105195:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105196:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105199:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010519c:	50                   	push   %eax
8010519d:	6a 00                	push   $0x0
8010519f:	e8 1c fa ff ff       	call   80104bc0 <argstr>
801051a4:	83 c4 10             	add    $0x10,%esp
801051a7:	85 c0                	test   %eax,%eax
801051a9:	0f 88 77 01 00 00    	js     80105326 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801051af:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801051b2:	e8 09 db ff ff       	call   80102cc0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801051b7:	83 ec 08             	sub    $0x8,%esp
801051ba:	53                   	push   %ebx
801051bb:	ff 75 c0             	pushl  -0x40(%ebp)
801051be:	e8 4d cd ff ff       	call   80101f10 <nameiparent>
801051c3:	83 c4 10             	add    $0x10,%esp
801051c6:	85 c0                	test   %eax,%eax
801051c8:	89 c6                	mov    %eax,%esi
801051ca:	0f 84 60 01 00 00    	je     80105330 <sys_unlink+0x1a0>
  ilock(dp);
801051d0:	83 ec 0c             	sub    $0xc,%esp
801051d3:	50                   	push   %eax
801051d4:	e8 b7 c4 ff ff       	call   80101690 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801051d9:	58                   	pop    %eax
801051da:	5a                   	pop    %edx
801051db:	68 ac 7c 10 80       	push   $0x80107cac
801051e0:	53                   	push   %ebx
801051e1:	e8 ba c9 ff ff       	call   80101ba0 <namecmp>
801051e6:	83 c4 10             	add    $0x10,%esp
801051e9:	85 c0                	test   %eax,%eax
801051eb:	0f 84 03 01 00 00    	je     801052f4 <sys_unlink+0x164>
801051f1:	83 ec 08             	sub    $0x8,%esp
801051f4:	68 ab 7c 10 80       	push   $0x80107cab
801051f9:	53                   	push   %ebx
801051fa:	e8 a1 c9 ff ff       	call   80101ba0 <namecmp>
801051ff:	83 c4 10             	add    $0x10,%esp
80105202:	85 c0                	test   %eax,%eax
80105204:	0f 84 ea 00 00 00    	je     801052f4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010520a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010520d:	83 ec 04             	sub    $0x4,%esp
80105210:	50                   	push   %eax
80105211:	53                   	push   %ebx
80105212:	56                   	push   %esi
80105213:	e8 a8 c9 ff ff       	call   80101bc0 <dirlookup>
80105218:	83 c4 10             	add    $0x10,%esp
8010521b:	85 c0                	test   %eax,%eax
8010521d:	89 c3                	mov    %eax,%ebx
8010521f:	0f 84 cf 00 00 00    	je     801052f4 <sys_unlink+0x164>
  ilock(ip);
80105225:	83 ec 0c             	sub    $0xc,%esp
80105228:	50                   	push   %eax
80105229:	e8 62 c4 ff ff       	call   80101690 <ilock>
  if(ip->nlink < 1)
8010522e:	83 c4 10             	add    $0x10,%esp
80105231:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105236:	0f 8e 10 01 00 00    	jle    8010534c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010523c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105241:	74 6d                	je     801052b0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105243:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105246:	83 ec 04             	sub    $0x4,%esp
80105249:	6a 10                	push   $0x10
8010524b:	6a 00                	push   $0x0
8010524d:	50                   	push   %eax
8010524e:	e8 bd f5 ff ff       	call   80104810 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105253:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105256:	6a 10                	push   $0x10
80105258:	ff 75 c4             	pushl  -0x3c(%ebp)
8010525b:	50                   	push   %eax
8010525c:	56                   	push   %esi
8010525d:	e8 0e c8 ff ff       	call   80101a70 <writei>
80105262:	83 c4 20             	add    $0x20,%esp
80105265:	83 f8 10             	cmp    $0x10,%eax
80105268:	0f 85 eb 00 00 00    	jne    80105359 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010526e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105273:	0f 84 97 00 00 00    	je     80105310 <sys_unlink+0x180>
  iunlockput(dp);
80105279:	83 ec 0c             	sub    $0xc,%esp
8010527c:	56                   	push   %esi
8010527d:	e8 9e c6 ff ff       	call   80101920 <iunlockput>
  ip->nlink--;
80105282:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105287:	89 1c 24             	mov    %ebx,(%esp)
8010528a:	e8 51 c3 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
8010528f:	89 1c 24             	mov    %ebx,(%esp)
80105292:	e8 89 c6 ff ff       	call   80101920 <iunlockput>
  end_op();
80105297:	e8 94 da ff ff       	call   80102d30 <end_op>
  return 0;
8010529c:	83 c4 10             	add    $0x10,%esp
8010529f:	31 c0                	xor    %eax,%eax
}
801052a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052a4:	5b                   	pop    %ebx
801052a5:	5e                   	pop    %esi
801052a6:	5f                   	pop    %edi
801052a7:	5d                   	pop    %ebp
801052a8:	c3                   	ret    
801052a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801052b0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801052b4:	76 8d                	jbe    80105243 <sys_unlink+0xb3>
801052b6:	bf 20 00 00 00       	mov    $0x20,%edi
801052bb:	eb 0f                	jmp    801052cc <sys_unlink+0x13c>
801052bd:	8d 76 00             	lea    0x0(%esi),%esi
801052c0:	83 c7 10             	add    $0x10,%edi
801052c3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801052c6:	0f 83 77 ff ff ff    	jae    80105243 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052cc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801052cf:	6a 10                	push   $0x10
801052d1:	57                   	push   %edi
801052d2:	50                   	push   %eax
801052d3:	53                   	push   %ebx
801052d4:	e8 97 c6 ff ff       	call   80101970 <readi>
801052d9:	83 c4 10             	add    $0x10,%esp
801052dc:	83 f8 10             	cmp    $0x10,%eax
801052df:	75 5e                	jne    8010533f <sys_unlink+0x1af>
    if(de.inum != 0)
801052e1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801052e6:	74 d8                	je     801052c0 <sys_unlink+0x130>
    iunlockput(ip);
801052e8:	83 ec 0c             	sub    $0xc,%esp
801052eb:	53                   	push   %ebx
801052ec:	e8 2f c6 ff ff       	call   80101920 <iunlockput>
    goto bad;
801052f1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801052f4:	83 ec 0c             	sub    $0xc,%esp
801052f7:	56                   	push   %esi
801052f8:	e8 23 c6 ff ff       	call   80101920 <iunlockput>
  end_op();
801052fd:	e8 2e da ff ff       	call   80102d30 <end_op>
  return -1;
80105302:	83 c4 10             	add    $0x10,%esp
80105305:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010530a:	eb 95                	jmp    801052a1 <sys_unlink+0x111>
8010530c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105310:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105315:	83 ec 0c             	sub    $0xc,%esp
80105318:	56                   	push   %esi
80105319:	e8 c2 c2 ff ff       	call   801015e0 <iupdate>
8010531e:	83 c4 10             	add    $0x10,%esp
80105321:	e9 53 ff ff ff       	jmp    80105279 <sys_unlink+0xe9>
    return -1;
80105326:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010532b:	e9 71 ff ff ff       	jmp    801052a1 <sys_unlink+0x111>
    end_op();
80105330:	e8 fb d9 ff ff       	call   80102d30 <end_op>
    return -1;
80105335:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010533a:	e9 62 ff ff ff       	jmp    801052a1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010533f:	83 ec 0c             	sub    $0xc,%esp
80105342:	68 d0 7c 10 80       	push   $0x80107cd0
80105347:	e8 44 b0 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010534c:	83 ec 0c             	sub    $0xc,%esp
8010534f:	68 be 7c 10 80       	push   $0x80107cbe
80105354:	e8 37 b0 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105359:	83 ec 0c             	sub    $0xc,%esp
8010535c:	68 e2 7c 10 80       	push   $0x80107ce2
80105361:	e8 2a b0 ff ff       	call   80100390 <panic>
80105366:	8d 76 00             	lea    0x0(%esi),%esi
80105369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105370 <sys_open>:

int
sys_open(void)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	57                   	push   %edi
80105374:	56                   	push   %esi
80105375:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105376:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105379:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010537c:	50                   	push   %eax
8010537d:	6a 00                	push   $0x0
8010537f:	e8 3c f8 ff ff       	call   80104bc0 <argstr>
80105384:	83 c4 10             	add    $0x10,%esp
80105387:	85 c0                	test   %eax,%eax
80105389:	0f 88 1d 01 00 00    	js     801054ac <sys_open+0x13c>
8010538f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105392:	83 ec 08             	sub    $0x8,%esp
80105395:	50                   	push   %eax
80105396:	6a 01                	push   $0x1
80105398:	e8 73 f7 ff ff       	call   80104b10 <argint>
8010539d:	83 c4 10             	add    $0x10,%esp
801053a0:	85 c0                	test   %eax,%eax
801053a2:	0f 88 04 01 00 00    	js     801054ac <sys_open+0x13c>
    return -1;

  begin_op();
801053a8:	e8 13 d9 ff ff       	call   80102cc0 <begin_op>

  if(omode & O_CREATE){
801053ad:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801053b1:	0f 85 a9 00 00 00    	jne    80105460 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801053b7:	83 ec 0c             	sub    $0xc,%esp
801053ba:	ff 75 e0             	pushl  -0x20(%ebp)
801053bd:	e8 2e cb ff ff       	call   80101ef0 <namei>
801053c2:	83 c4 10             	add    $0x10,%esp
801053c5:	85 c0                	test   %eax,%eax
801053c7:	89 c6                	mov    %eax,%esi
801053c9:	0f 84 b2 00 00 00    	je     80105481 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801053cf:	83 ec 0c             	sub    $0xc,%esp
801053d2:	50                   	push   %eax
801053d3:	e8 b8 c2 ff ff       	call   80101690 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801053d8:	83 c4 10             	add    $0x10,%esp
801053db:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801053e0:	0f 84 aa 00 00 00    	je     80105490 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801053e6:	e8 95 b9 ff ff       	call   80100d80 <filealloc>
801053eb:	85 c0                	test   %eax,%eax
801053ed:	89 c7                	mov    %eax,%edi
801053ef:	0f 84 a6 00 00 00    	je     8010549b <sys_open+0x12b>
  struct proc *curproc = myproc();
801053f5:	e8 36 e5 ff ff       	call   80103930 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801053fa:	31 db                	xor    %ebx,%ebx
801053fc:	eb 0e                	jmp    8010540c <sys_open+0x9c>
801053fe:	66 90                	xchg   %ax,%ax
80105400:	83 c3 01             	add    $0x1,%ebx
80105403:	83 fb 10             	cmp    $0x10,%ebx
80105406:	0f 84 ac 00 00 00    	je     801054b8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010540c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105410:	85 d2                	test   %edx,%edx
80105412:	75 ec                	jne    80105400 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105414:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105417:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010541b:	56                   	push   %esi
8010541c:	e8 4f c3 ff ff       	call   80101770 <iunlock>
  end_op();
80105421:	e8 0a d9 ff ff       	call   80102d30 <end_op>

  f->type = FD_INODE;
80105426:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010542c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010542f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105432:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105435:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010543c:	89 d0                	mov    %edx,%eax
8010543e:	f7 d0                	not    %eax
80105440:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105443:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105446:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105449:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010544d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105450:	89 d8                	mov    %ebx,%eax
80105452:	5b                   	pop    %ebx
80105453:	5e                   	pop    %esi
80105454:	5f                   	pop    %edi
80105455:	5d                   	pop    %ebp
80105456:	c3                   	ret    
80105457:	89 f6                	mov    %esi,%esi
80105459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105460:	83 ec 0c             	sub    $0xc,%esp
80105463:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105466:	31 c9                	xor    %ecx,%ecx
80105468:	6a 00                	push   $0x0
8010546a:	ba 02 00 00 00       	mov    $0x2,%edx
8010546f:	e8 ec f7 ff ff       	call   80104c60 <create>
    if(ip == 0){
80105474:	83 c4 10             	add    $0x10,%esp
80105477:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105479:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010547b:	0f 85 65 ff ff ff    	jne    801053e6 <sys_open+0x76>
      end_op();
80105481:	e8 aa d8 ff ff       	call   80102d30 <end_op>
      return -1;
80105486:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010548b:	eb c0                	jmp    8010544d <sys_open+0xdd>
8010548d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105490:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105493:	85 c9                	test   %ecx,%ecx
80105495:	0f 84 4b ff ff ff    	je     801053e6 <sys_open+0x76>
    iunlockput(ip);
8010549b:	83 ec 0c             	sub    $0xc,%esp
8010549e:	56                   	push   %esi
8010549f:	e8 7c c4 ff ff       	call   80101920 <iunlockput>
    end_op();
801054a4:	e8 87 d8 ff ff       	call   80102d30 <end_op>
    return -1;
801054a9:	83 c4 10             	add    $0x10,%esp
801054ac:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054b1:	eb 9a                	jmp    8010544d <sys_open+0xdd>
801054b3:	90                   	nop
801054b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801054b8:	83 ec 0c             	sub    $0xc,%esp
801054bb:	57                   	push   %edi
801054bc:	e8 7f b9 ff ff       	call   80100e40 <fileclose>
801054c1:	83 c4 10             	add    $0x10,%esp
801054c4:	eb d5                	jmp    8010549b <sys_open+0x12b>
801054c6:	8d 76 00             	lea    0x0(%esi),%esi
801054c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054d0 <sys_mkdir>:

int
sys_mkdir(void)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801054d6:	e8 e5 d7 ff ff       	call   80102cc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801054db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054de:	83 ec 08             	sub    $0x8,%esp
801054e1:	50                   	push   %eax
801054e2:	6a 00                	push   $0x0
801054e4:	e8 d7 f6 ff ff       	call   80104bc0 <argstr>
801054e9:	83 c4 10             	add    $0x10,%esp
801054ec:	85 c0                	test   %eax,%eax
801054ee:	78 30                	js     80105520 <sys_mkdir+0x50>
801054f0:	83 ec 0c             	sub    $0xc,%esp
801054f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054f6:	31 c9                	xor    %ecx,%ecx
801054f8:	6a 00                	push   $0x0
801054fa:	ba 01 00 00 00       	mov    $0x1,%edx
801054ff:	e8 5c f7 ff ff       	call   80104c60 <create>
80105504:	83 c4 10             	add    $0x10,%esp
80105507:	85 c0                	test   %eax,%eax
80105509:	74 15                	je     80105520 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010550b:	83 ec 0c             	sub    $0xc,%esp
8010550e:	50                   	push   %eax
8010550f:	e8 0c c4 ff ff       	call   80101920 <iunlockput>
  end_op();
80105514:	e8 17 d8 ff ff       	call   80102d30 <end_op>
  return 0;
80105519:	83 c4 10             	add    $0x10,%esp
8010551c:	31 c0                	xor    %eax,%eax
}
8010551e:	c9                   	leave  
8010551f:	c3                   	ret    
    end_op();
80105520:	e8 0b d8 ff ff       	call   80102d30 <end_op>
    return -1;
80105525:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010552a:	c9                   	leave  
8010552b:	c3                   	ret    
8010552c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105530 <sys_mknod>:

int
sys_mknod(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105536:	e8 85 d7 ff ff       	call   80102cc0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010553b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010553e:	83 ec 08             	sub    $0x8,%esp
80105541:	50                   	push   %eax
80105542:	6a 00                	push   $0x0
80105544:	e8 77 f6 ff ff       	call   80104bc0 <argstr>
80105549:	83 c4 10             	add    $0x10,%esp
8010554c:	85 c0                	test   %eax,%eax
8010554e:	78 60                	js     801055b0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105550:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105553:	83 ec 08             	sub    $0x8,%esp
80105556:	50                   	push   %eax
80105557:	6a 01                	push   $0x1
80105559:	e8 b2 f5 ff ff       	call   80104b10 <argint>
  if((argstr(0, &path)) < 0 ||
8010555e:	83 c4 10             	add    $0x10,%esp
80105561:	85 c0                	test   %eax,%eax
80105563:	78 4b                	js     801055b0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105565:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105568:	83 ec 08             	sub    $0x8,%esp
8010556b:	50                   	push   %eax
8010556c:	6a 02                	push   $0x2
8010556e:	e8 9d f5 ff ff       	call   80104b10 <argint>
     argint(1, &major) < 0 ||
80105573:	83 c4 10             	add    $0x10,%esp
80105576:	85 c0                	test   %eax,%eax
80105578:	78 36                	js     801055b0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010557a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010557e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105581:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105585:	ba 03 00 00 00       	mov    $0x3,%edx
8010558a:	50                   	push   %eax
8010558b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010558e:	e8 cd f6 ff ff       	call   80104c60 <create>
80105593:	83 c4 10             	add    $0x10,%esp
80105596:	85 c0                	test   %eax,%eax
80105598:	74 16                	je     801055b0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010559a:	83 ec 0c             	sub    $0xc,%esp
8010559d:	50                   	push   %eax
8010559e:	e8 7d c3 ff ff       	call   80101920 <iunlockput>
  end_op();
801055a3:	e8 88 d7 ff ff       	call   80102d30 <end_op>
  return 0;
801055a8:	83 c4 10             	add    $0x10,%esp
801055ab:	31 c0                	xor    %eax,%eax
}
801055ad:	c9                   	leave  
801055ae:	c3                   	ret    
801055af:	90                   	nop
    end_op();
801055b0:	e8 7b d7 ff ff       	call   80102d30 <end_op>
    return -1;
801055b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055ba:	c9                   	leave  
801055bb:	c3                   	ret    
801055bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055c0 <sys_chdir>:

int
sys_chdir(void)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	56                   	push   %esi
801055c4:	53                   	push   %ebx
801055c5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801055c8:	e8 63 e3 ff ff       	call   80103930 <myproc>
801055cd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801055cf:	e8 ec d6 ff ff       	call   80102cc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801055d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055d7:	83 ec 08             	sub    $0x8,%esp
801055da:	50                   	push   %eax
801055db:	6a 00                	push   $0x0
801055dd:	e8 de f5 ff ff       	call   80104bc0 <argstr>
801055e2:	83 c4 10             	add    $0x10,%esp
801055e5:	85 c0                	test   %eax,%eax
801055e7:	78 77                	js     80105660 <sys_chdir+0xa0>
801055e9:	83 ec 0c             	sub    $0xc,%esp
801055ec:	ff 75 f4             	pushl  -0xc(%ebp)
801055ef:	e8 fc c8 ff ff       	call   80101ef0 <namei>
801055f4:	83 c4 10             	add    $0x10,%esp
801055f7:	85 c0                	test   %eax,%eax
801055f9:	89 c3                	mov    %eax,%ebx
801055fb:	74 63                	je     80105660 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801055fd:	83 ec 0c             	sub    $0xc,%esp
80105600:	50                   	push   %eax
80105601:	e8 8a c0 ff ff       	call   80101690 <ilock>
  if(ip->type != T_DIR){
80105606:	83 c4 10             	add    $0x10,%esp
80105609:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010560e:	75 30                	jne    80105640 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105610:	83 ec 0c             	sub    $0xc,%esp
80105613:	53                   	push   %ebx
80105614:	e8 57 c1 ff ff       	call   80101770 <iunlock>
  iput(curproc->cwd);
80105619:	58                   	pop    %eax
8010561a:	ff 76 68             	pushl  0x68(%esi)
8010561d:	e8 9e c1 ff ff       	call   801017c0 <iput>
  end_op();
80105622:	e8 09 d7 ff ff       	call   80102d30 <end_op>
  curproc->cwd = ip;
80105627:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010562a:	83 c4 10             	add    $0x10,%esp
8010562d:	31 c0                	xor    %eax,%eax
}
8010562f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105632:	5b                   	pop    %ebx
80105633:	5e                   	pop    %esi
80105634:	5d                   	pop    %ebp
80105635:	c3                   	ret    
80105636:	8d 76 00             	lea    0x0(%esi),%esi
80105639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105640:	83 ec 0c             	sub    $0xc,%esp
80105643:	53                   	push   %ebx
80105644:	e8 d7 c2 ff ff       	call   80101920 <iunlockput>
    end_op();
80105649:	e8 e2 d6 ff ff       	call   80102d30 <end_op>
    return -1;
8010564e:	83 c4 10             	add    $0x10,%esp
80105651:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105656:	eb d7                	jmp    8010562f <sys_chdir+0x6f>
80105658:	90                   	nop
80105659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105660:	e8 cb d6 ff ff       	call   80102d30 <end_op>
    return -1;
80105665:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010566a:	eb c3                	jmp    8010562f <sys_chdir+0x6f>
8010566c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105670 <sys_exec>:

int
sys_exec(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	57                   	push   %edi
80105674:	56                   	push   %esi
80105675:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105676:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010567c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105682:	50                   	push   %eax
80105683:	6a 00                	push   $0x0
80105685:	e8 36 f5 ff ff       	call   80104bc0 <argstr>
8010568a:	83 c4 10             	add    $0x10,%esp
8010568d:	85 c0                	test   %eax,%eax
8010568f:	0f 88 87 00 00 00    	js     8010571c <sys_exec+0xac>
80105695:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010569b:	83 ec 08             	sub    $0x8,%esp
8010569e:	50                   	push   %eax
8010569f:	6a 01                	push   $0x1
801056a1:	e8 6a f4 ff ff       	call   80104b10 <argint>
801056a6:	83 c4 10             	add    $0x10,%esp
801056a9:	85 c0                	test   %eax,%eax
801056ab:	78 6f                	js     8010571c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801056ad:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801056b3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801056b6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801056b8:	68 80 00 00 00       	push   $0x80
801056bd:	6a 00                	push   $0x0
801056bf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801056c5:	50                   	push   %eax
801056c6:	e8 45 f1 ff ff       	call   80104810 <memset>
801056cb:	83 c4 10             	add    $0x10,%esp
801056ce:	eb 2c                	jmp    801056fc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801056d0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801056d6:	85 c0                	test   %eax,%eax
801056d8:	74 56                	je     80105730 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801056da:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801056e0:	83 ec 08             	sub    $0x8,%esp
801056e3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801056e6:	52                   	push   %edx
801056e7:	50                   	push   %eax
801056e8:	e8 b3 f3 ff ff       	call   80104aa0 <fetchstr>
801056ed:	83 c4 10             	add    $0x10,%esp
801056f0:	85 c0                	test   %eax,%eax
801056f2:	78 28                	js     8010571c <sys_exec+0xac>
  for(i=0;; i++){
801056f4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801056f7:	83 fb 20             	cmp    $0x20,%ebx
801056fa:	74 20                	je     8010571c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801056fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105702:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105709:	83 ec 08             	sub    $0x8,%esp
8010570c:	57                   	push   %edi
8010570d:	01 f0                	add    %esi,%eax
8010570f:	50                   	push   %eax
80105710:	e8 4b f3 ff ff       	call   80104a60 <fetchint>
80105715:	83 c4 10             	add    $0x10,%esp
80105718:	85 c0                	test   %eax,%eax
8010571a:	79 b4                	jns    801056d0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010571c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010571f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105724:	5b                   	pop    %ebx
80105725:	5e                   	pop    %esi
80105726:	5f                   	pop    %edi
80105727:	5d                   	pop    %ebp
80105728:	c3                   	ret    
80105729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105730:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105736:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105739:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105740:	00 00 00 00 
  return exec(path, argv);
80105744:	50                   	push   %eax
80105745:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010574b:	e8 c0 b2 ff ff       	call   80100a10 <exec>
80105750:	83 c4 10             	add    $0x10,%esp
}
80105753:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105756:	5b                   	pop    %ebx
80105757:	5e                   	pop    %esi
80105758:	5f                   	pop    %edi
80105759:	5d                   	pop    %ebp
8010575a:	c3                   	ret    
8010575b:	90                   	nop
8010575c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105760 <sys_pipe>:

int
sys_pipe(void)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	57                   	push   %edi
80105764:	56                   	push   %esi
80105765:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105766:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105769:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010576c:	6a 08                	push   $0x8
8010576e:	50                   	push   %eax
8010576f:	6a 00                	push   $0x0
80105771:	e8 ea f3 ff ff       	call   80104b60 <argptr>
80105776:	83 c4 10             	add    $0x10,%esp
80105779:	85 c0                	test   %eax,%eax
8010577b:	0f 88 ae 00 00 00    	js     8010582f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105781:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105784:	83 ec 08             	sub    $0x8,%esp
80105787:	50                   	push   %eax
80105788:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010578b:	50                   	push   %eax
8010578c:	e8 cf db ff ff       	call   80103360 <pipealloc>
80105791:	83 c4 10             	add    $0x10,%esp
80105794:	85 c0                	test   %eax,%eax
80105796:	0f 88 93 00 00 00    	js     8010582f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010579c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010579f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801057a1:	e8 8a e1 ff ff       	call   80103930 <myproc>
801057a6:	eb 10                	jmp    801057b8 <sys_pipe+0x58>
801057a8:	90                   	nop
801057a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801057b0:	83 c3 01             	add    $0x1,%ebx
801057b3:	83 fb 10             	cmp    $0x10,%ebx
801057b6:	74 60                	je     80105818 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801057b8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801057bc:	85 f6                	test   %esi,%esi
801057be:	75 f0                	jne    801057b0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801057c0:	8d 73 08             	lea    0x8(%ebx),%esi
801057c3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801057ca:	e8 61 e1 ff ff       	call   80103930 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057cf:	31 d2                	xor    %edx,%edx
801057d1:	eb 0d                	jmp    801057e0 <sys_pipe+0x80>
801057d3:	90                   	nop
801057d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057d8:	83 c2 01             	add    $0x1,%edx
801057db:	83 fa 10             	cmp    $0x10,%edx
801057de:	74 28                	je     80105808 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801057e0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801057e4:	85 c9                	test   %ecx,%ecx
801057e6:	75 f0                	jne    801057d8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801057e8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801057ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057ef:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801057f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057f4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801057f7:	31 c0                	xor    %eax,%eax
}
801057f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057fc:	5b                   	pop    %ebx
801057fd:	5e                   	pop    %esi
801057fe:	5f                   	pop    %edi
801057ff:	5d                   	pop    %ebp
80105800:	c3                   	ret    
80105801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105808:	e8 23 e1 ff ff       	call   80103930 <myproc>
8010580d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105814:	00 
80105815:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105818:	83 ec 0c             	sub    $0xc,%esp
8010581b:	ff 75 e0             	pushl  -0x20(%ebp)
8010581e:	e8 1d b6 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105823:	58                   	pop    %eax
80105824:	ff 75 e4             	pushl  -0x1c(%ebp)
80105827:	e8 14 b6 ff ff       	call   80100e40 <fileclose>
    return -1;
8010582c:	83 c4 10             	add    $0x10,%esp
8010582f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105834:	eb c3                	jmp    801057f9 <sys_pipe+0x99>
80105836:	8d 76 00             	lea    0x0(%esi),%esi
80105839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105840 <sys_swapread>:

int sys_swapread(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
80105846:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105849:	68 00 10 00 00       	push   $0x1000
8010584e:	50                   	push   %eax
8010584f:	6a 00                	push   $0x0
80105851:	e8 0a f3 ff ff       	call   80104b60 <argptr>
80105856:	83 c4 10             	add    $0x10,%esp
80105859:	85 c0                	test   %eax,%eax
8010585b:	78 33                	js     80105890 <sys_swapread+0x50>
8010585d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105860:	83 ec 08             	sub    $0x8,%esp
80105863:	50                   	push   %eax
80105864:	6a 01                	push   $0x1
80105866:	e8 a5 f2 ff ff       	call   80104b10 <argint>
8010586b:	83 c4 10             	add    $0x10,%esp
8010586e:	85 c0                	test   %eax,%eax
80105870:	78 1e                	js     80105890 <sys_swapread+0x50>
		return -1;

	swapread(ptr, blkno);
80105872:	83 ec 08             	sub    $0x8,%esp
80105875:	ff 75 f4             	pushl  -0xc(%ebp)
80105878:	ff 75 f0             	pushl  -0x10(%ebp)
8010587b:	e8 b0 c6 ff ff       	call   80101f30 <swapread>
	return 0;
80105880:	83 c4 10             	add    $0x10,%esp
80105883:	31 c0                	xor    %eax,%eax
}
80105885:	c9                   	leave  
80105886:	c3                   	ret    
80105887:	89 f6                	mov    %esi,%esi
80105889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		return -1;
80105890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105895:	c9                   	leave  
80105896:	c3                   	ret    
80105897:	89 f6                	mov    %esi,%esi
80105899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058a0 <sys_swapwrite>:

int sys_swapwrite(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
801058a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058a9:	68 00 10 00 00       	push   $0x1000
801058ae:	50                   	push   %eax
801058af:	6a 00                	push   $0x0
801058b1:	e8 aa f2 ff ff       	call   80104b60 <argptr>
801058b6:	83 c4 10             	add    $0x10,%esp
801058b9:	85 c0                	test   %eax,%eax
801058bb:	78 33                	js     801058f0 <sys_swapwrite+0x50>
801058bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058c0:	83 ec 08             	sub    $0x8,%esp
801058c3:	50                   	push   %eax
801058c4:	6a 01                	push   $0x1
801058c6:	e8 45 f2 ff ff       	call   80104b10 <argint>
801058cb:	83 c4 10             	add    $0x10,%esp
801058ce:	85 c0                	test   %eax,%eax
801058d0:	78 1e                	js     801058f0 <sys_swapwrite+0x50>
		return -1;

	swapwrite(ptr, blkno);
801058d2:	83 ec 08             	sub    $0x8,%esp
801058d5:	ff 75 f4             	pushl  -0xc(%ebp)
801058d8:	ff 75 f0             	pushl  -0x10(%ebp)
801058db:	e8 d0 c6 ff ff       	call   80101fb0 <swapwrite>
	return 0;
801058e0:	83 c4 10             	add    $0x10,%esp
801058e3:	31 c0                	xor    %eax,%eax
}
801058e5:	c9                   	leave  
801058e6:	c3                   	ret    
801058e7:	89 f6                	mov    %esi,%esi
801058e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		return -1;
801058f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058f5:	c9                   	leave  
801058f6:	c3                   	ret    
801058f7:	66 90                	xchg   %ax,%ax
801058f9:	66 90                	xchg   %ax,%ax
801058fb:	66 90                	xchg   %ax,%ax
801058fd:	66 90                	xchg   %ax,%ax
801058ff:	90                   	nop

80105900 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105903:	5d                   	pop    %ebp
  return fork();
80105904:	e9 f7 e1 ff ff       	jmp    80103b00 <fork>
80105909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105910 <sys_exit>:

int
sys_exit(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	83 ec 08             	sub    $0x8,%esp
  exit();
80105916:	e8 85 e4 ff ff       	call   80103da0 <exit>
  return 0;  // not reached
}
8010591b:	31 c0                	xor    %eax,%eax
8010591d:	c9                   	leave  
8010591e:	c3                   	ret    
8010591f:	90                   	nop

80105920 <sys_wait>:

int
sys_wait(void)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105923:	5d                   	pop    %ebp
  return wait();
80105924:	e9 b7 e6 ff ff       	jmp    80103fe0 <wait>
80105929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105930 <sys_kill>:

int
sys_kill(void)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105936:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105939:	50                   	push   %eax
8010593a:	6a 00                	push   $0x0
8010593c:	e8 cf f1 ff ff       	call   80104b10 <argint>
80105941:	83 c4 10             	add    $0x10,%esp
80105944:	85 c0                	test   %eax,%eax
80105946:	78 18                	js     80105960 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105948:	83 ec 0c             	sub    $0xc,%esp
8010594b:	ff 75 f4             	pushl  -0xc(%ebp)
8010594e:	e8 ed e7 ff ff       	call   80104140 <kill>
80105953:	83 c4 10             	add    $0x10,%esp
}
80105956:	c9                   	leave  
80105957:	c3                   	ret    
80105958:	90                   	nop
80105959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105965:	c9                   	leave  
80105966:	c3                   	ret    
80105967:	89 f6                	mov    %esi,%esi
80105969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105970 <sys_getpid>:

int
sys_getpid(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105976:	e8 b5 df ff ff       	call   80103930 <myproc>
8010597b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010597e:	c9                   	leave  
8010597f:	c3                   	ret    

80105980 <sys_sbrk>:

int
sys_sbrk(void)
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105984:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105987:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010598a:	50                   	push   %eax
8010598b:	6a 00                	push   $0x0
8010598d:	e8 7e f1 ff ff       	call   80104b10 <argint>
80105992:	83 c4 10             	add    $0x10,%esp
80105995:	85 c0                	test   %eax,%eax
80105997:	78 27                	js     801059c0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105999:	e8 92 df ff ff       	call   80103930 <myproc>
  if(growproc(n) < 0)
8010599e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801059a1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801059a3:	ff 75 f4             	pushl  -0xc(%ebp)
801059a6:	e8 d5 e0 ff ff       	call   80103a80 <growproc>
801059ab:	83 c4 10             	add    $0x10,%esp
801059ae:	85 c0                	test   %eax,%eax
801059b0:	78 0e                	js     801059c0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801059b2:	89 d8                	mov    %ebx,%eax
801059b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059b7:	c9                   	leave  
801059b8:	c3                   	ret    
801059b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801059c0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059c5:	eb eb                	jmp    801059b2 <sys_sbrk+0x32>
801059c7:	89 f6                	mov    %esi,%esi
801059c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059d0 <sys_sleep>:

int
sys_sleep(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801059d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059d7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059da:	50                   	push   %eax
801059db:	6a 00                	push   $0x0
801059dd:	e8 2e f1 ff ff       	call   80104b10 <argint>
801059e2:	83 c4 10             	add    $0x10,%esp
801059e5:	85 c0                	test   %eax,%eax
801059e7:	0f 88 8a 00 00 00    	js     80105a77 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801059ed:	83 ec 0c             	sub    $0xc,%esp
801059f0:	68 60 50 11 80       	push   $0x80115060
801059f5:	e8 06 ed ff ff       	call   80104700 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801059fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059fd:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105a00:	8b 1d a0 58 11 80    	mov    0x801158a0,%ebx
  while(ticks - ticks0 < n){
80105a06:	85 d2                	test   %edx,%edx
80105a08:	75 27                	jne    80105a31 <sys_sleep+0x61>
80105a0a:	eb 54                	jmp    80105a60 <sys_sleep+0x90>
80105a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a10:	83 ec 08             	sub    $0x8,%esp
80105a13:	68 60 50 11 80       	push   $0x80115060
80105a18:	68 a0 58 11 80       	push   $0x801158a0
80105a1d:	e8 fe e4 ff ff       	call   80103f20 <sleep>
  while(ticks - ticks0 < n){
80105a22:	a1 a0 58 11 80       	mov    0x801158a0,%eax
80105a27:	83 c4 10             	add    $0x10,%esp
80105a2a:	29 d8                	sub    %ebx,%eax
80105a2c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a2f:	73 2f                	jae    80105a60 <sys_sleep+0x90>
    if(myproc()->killed){
80105a31:	e8 fa de ff ff       	call   80103930 <myproc>
80105a36:	8b 40 24             	mov    0x24(%eax),%eax
80105a39:	85 c0                	test   %eax,%eax
80105a3b:	74 d3                	je     80105a10 <sys_sleep+0x40>
      release(&tickslock);
80105a3d:	83 ec 0c             	sub    $0xc,%esp
80105a40:	68 60 50 11 80       	push   $0x80115060
80105a45:	e8 76 ed ff ff       	call   801047c0 <release>
      return -1;
80105a4a:	83 c4 10             	add    $0x10,%esp
80105a4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105a52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a55:	c9                   	leave  
80105a56:	c3                   	ret    
80105a57:	89 f6                	mov    %esi,%esi
80105a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105a60:	83 ec 0c             	sub    $0xc,%esp
80105a63:	68 60 50 11 80       	push   $0x80115060
80105a68:	e8 53 ed ff ff       	call   801047c0 <release>
  return 0;
80105a6d:	83 c4 10             	add    $0x10,%esp
80105a70:	31 c0                	xor    %eax,%eax
}
80105a72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a75:	c9                   	leave  
80105a76:	c3                   	ret    
    return -1;
80105a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a7c:	eb f4                	jmp    80105a72 <sys_sleep+0xa2>
80105a7e:	66 90                	xchg   %ax,%ax

80105a80 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	53                   	push   %ebx
80105a84:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105a87:	68 60 50 11 80       	push   $0x80115060
80105a8c:	e8 6f ec ff ff       	call   80104700 <acquire>
  xticks = ticks;
80105a91:	8b 1d a0 58 11 80    	mov    0x801158a0,%ebx
  release(&tickslock);
80105a97:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
80105a9e:	e8 1d ed ff ff       	call   801047c0 <release>
  return xticks;
}
80105aa3:	89 d8                	mov    %ebx,%eax
80105aa5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105aa8:	c9                   	leave  
80105aa9:	c3                   	ret    
80105aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ab0 <sys_ps>:
//add
int 
sys_ps(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
	return ps();
}
80105ab3:	5d                   	pop    %ebp
	return ps();
80105ab4:	e9 d7 e7 ff ff       	jmp    80104290 <ps>
80105ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ac0 <sys_yield>:
void
sys_yield(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
	yield();
}
80105ac3:	5d                   	pop    %ebp
	yield();
80105ac4:	e9 07 e4 ff ff       	jmp    80103ed0 <yield>
80105ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ad0 <sys_setnice>:
int 
sys_setnice(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	83 ec 20             	sub    $0x20,%esp
	int pid,nice_val;
	if(argint(0,&pid) <0) return -1;
80105ad6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ad9:	50                   	push   %eax
80105ada:	6a 00                	push   $0x0
80105adc:	e8 2f f0 ff ff       	call   80104b10 <argint>
80105ae1:	83 c4 10             	add    $0x10,%esp
80105ae4:	85 c0                	test   %eax,%eax
80105ae6:	78 28                	js     80105b10 <sys_setnice+0x40>
	else if(argint(1,&nice_val) <0) return -1;
80105ae8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aeb:	83 ec 08             	sub    $0x8,%esp
80105aee:	50                   	push   %eax
80105aef:	6a 01                	push   $0x1
80105af1:	e8 1a f0 ff ff       	call   80104b10 <argint>
80105af6:	83 c4 10             	add    $0x10,%esp
80105af9:	85 c0                	test   %eax,%eax
80105afb:	78 13                	js     80105b10 <sys_setnice+0x40>
	return setnice(pid,nice_val);
80105afd:	83 ec 08             	sub    $0x8,%esp
80105b00:	ff 75 f4             	pushl  -0xc(%ebp)
80105b03:	ff 75 f0             	pushl  -0x10(%ebp)
80105b06:	e8 c5 e8 ff ff       	call   801043d0 <setnice>
80105b0b:	83 c4 10             	add    $0x10,%esp
}
80105b0e:	c9                   	leave  
80105b0f:	c3                   	ret    
	if(argint(0,&pid) <0) return -1;
80105b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b15:	c9                   	leave  
80105b16:	c3                   	ret    
80105b17:	89 f6                	mov    %esi,%esi
80105b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b20 <sys_getnice>:
int 
sys_getnice(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	83 ec 20             	sub    $0x20,%esp
	int pid;
	if(argint(0,&pid) <0) return -1;
80105b26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b29:	50                   	push   %eax
80105b2a:	6a 00                	push   $0x0
80105b2c:	e8 df ef ff ff       	call   80104b10 <argint>
80105b31:	83 c4 10             	add    $0x10,%esp
80105b34:	85 c0                	test   %eax,%eax
80105b36:	78 18                	js     80105b50 <sys_getnice+0x30>
	return getnice(pid);
80105b38:	83 ec 0c             	sub    $0xc,%esp
80105b3b:	ff 75 f4             	pushl  -0xc(%ebp)
80105b3e:	e8 fd e8 ff ff       	call   80104440 <getnice>
80105b43:	83 c4 10             	add    $0x10,%esp
}
80105b46:	c9                   	leave  
80105b47:	c3                   	ret    
80105b48:	90                   	nop
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if(argint(0,&pid) <0) return -1;
80105b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b55:	c9                   	leave  
80105b56:	c3                   	ret    

80105b57 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b57:	1e                   	push   %ds
  pushl %es
80105b58:	06                   	push   %es
  pushl %fs
80105b59:	0f a0                	push   %fs
  pushl %gs
80105b5b:	0f a8                	push   %gs
  pushal
80105b5d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b5e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b62:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b64:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b66:	54                   	push   %esp
  call trap
80105b67:	e8 c4 00 00 00       	call   80105c30 <trap>
  addl $4, %esp
80105b6c:	83 c4 04             	add    $0x4,%esp

80105b6f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b6f:	61                   	popa   
  popl %gs
80105b70:	0f a9                	pop    %gs
  popl %fs
80105b72:	0f a1                	pop    %fs
  popl %es
80105b74:	07                   	pop    %es
  popl %ds
80105b75:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105b76:	83 c4 08             	add    $0x8,%esp
  iret
80105b79:	cf                   	iret   
80105b7a:	66 90                	xchg   %ax,%ax
80105b7c:	66 90                	xchg   %ax,%ax
80105b7e:	66 90                	xchg   %ax,%ax

80105b80 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105b80:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105b81:	31 c0                	xor    %eax,%eax
{
80105b83:	89 e5                	mov    %esp,%ebp
80105b85:	83 ec 08             	sub    $0x8,%esp
80105b88:	90                   	nop
80105b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105b90:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105b97:	c7 04 c5 a2 50 11 80 	movl   $0x8e000008,-0x7feeaf5e(,%eax,8)
80105b9e:	08 00 00 8e 
80105ba2:	66 89 14 c5 a0 50 11 	mov    %dx,-0x7feeaf60(,%eax,8)
80105ba9:	80 
80105baa:	c1 ea 10             	shr    $0x10,%edx
80105bad:	66 89 14 c5 a6 50 11 	mov    %dx,-0x7feeaf5a(,%eax,8)
80105bb4:	80 
  for(i = 0; i < 256; i++)
80105bb5:	83 c0 01             	add    $0x1,%eax
80105bb8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105bbd:	75 d1                	jne    80105b90 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bbf:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105bc4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bc7:	c7 05 a2 52 11 80 08 	movl   $0xef000008,0x801152a2
80105bce:	00 00 ef 
  initlock(&tickslock, "time");
80105bd1:	68 f1 7c 10 80       	push   $0x80107cf1
80105bd6:	68 60 50 11 80       	push   $0x80115060
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bdb:	66 a3 a0 52 11 80    	mov    %ax,0x801152a0
80105be1:	c1 e8 10             	shr    $0x10,%eax
80105be4:	66 a3 a6 52 11 80    	mov    %ax,0x801152a6
  initlock(&tickslock, "time");
80105bea:	e8 d1 e9 ff ff       	call   801045c0 <initlock>
}
80105bef:	83 c4 10             	add    $0x10,%esp
80105bf2:	c9                   	leave  
80105bf3:	c3                   	ret    
80105bf4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105bfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105c00 <idtinit>:

void
idtinit(void)
{
80105c00:	55                   	push   %ebp
  pd[0] = size-1;
80105c01:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c06:	89 e5                	mov    %esp,%ebp
80105c08:	83 ec 10             	sub    $0x10,%esp
80105c0b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c0f:	b8 a0 50 11 80       	mov    $0x801150a0,%eax
80105c14:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c18:	c1 e8 10             	shr    $0x10,%eax
80105c1b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c1f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c22:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c25:	c9                   	leave  
80105c26:	c3                   	ret    
80105c27:	89 f6                	mov    %esi,%esi
80105c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c30 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
80105c33:	57                   	push   %edi
80105c34:	56                   	push   %esi
80105c35:	53                   	push   %ebx
80105c36:	83 ec 1c             	sub    $0x1c,%esp
80105c39:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105c3c:	8b 47 30             	mov    0x30(%edi),%eax
80105c3f:	83 f8 40             	cmp    $0x40,%eax
80105c42:	0f 84 f8 00 00 00    	je     80105d40 <trap+0x110>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c48:	83 e8 20             	sub    $0x20,%eax
80105c4b:	83 f8 1f             	cmp    $0x1f,%eax
80105c4e:	77 10                	ja     80105c60 <trap+0x30>
80105c50:	ff 24 85 98 7d 10 80 	jmp    *-0x7fef8268(,%eax,4)
80105c57:	89 f6                	mov    %esi,%esi
80105c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105c60:	e8 cb dc ff ff       	call   80103930 <myproc>
80105c65:	85 c0                	test   %eax,%eax
80105c67:	8b 5f 38             	mov    0x38(%edi),%ebx
80105c6a:	0f 84 24 02 00 00    	je     80105e94 <trap+0x264>
80105c70:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105c74:	0f 84 1a 02 00 00    	je     80105e94 <trap+0x264>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105c7a:	0f 20 d1             	mov    %cr2,%ecx
80105c7d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c80:	e8 8b dc ff ff       	call   80103910 <cpuid>
80105c85:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105c88:	8b 47 34             	mov    0x34(%edi),%eax
80105c8b:	8b 77 30             	mov    0x30(%edi),%esi
80105c8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105c91:	e8 9a dc ff ff       	call   80103930 <myproc>
80105c96:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105c99:	e8 92 dc ff ff       	call   80103930 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c9e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ca1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ca4:	51                   	push   %ecx
80105ca5:	53                   	push   %ebx
80105ca6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105ca7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105caa:	ff 75 e4             	pushl  -0x1c(%ebp)
80105cad:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105cae:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cb1:	52                   	push   %edx
80105cb2:	ff 70 10             	pushl  0x10(%eax)
80105cb5:	68 54 7d 10 80       	push   $0x80107d54
80105cba:	e8 a1 a9 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105cbf:	83 c4 20             	add    $0x20,%esp
80105cc2:	e8 69 dc ff ff       	call   80103930 <myproc>
80105cc7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cce:	e8 5d dc ff ff       	call   80103930 <myproc>
80105cd3:	85 c0                	test   %eax,%eax
80105cd5:	74 1d                	je     80105cf4 <trap+0xc4>
80105cd7:	e8 54 dc ff ff       	call   80103930 <myproc>
80105cdc:	8b 50 24             	mov    0x24(%eax),%edx
80105cdf:	85 d2                	test   %edx,%edx
80105ce1:	74 11                	je     80105cf4 <trap+0xc4>
80105ce3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ce7:	83 e0 03             	and    $0x3,%eax
80105cea:	66 83 f8 03          	cmp    $0x3,%ax
80105cee:	0f 84 5c 01 00 00    	je     80105e50 <trap+0x220>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  // hyunwoong
  // when timer interrupt occurs, runtime of certain process increases.
	if(myproc() && myproc()->state == RUNNING &&
80105cf4:	e8 37 dc ff ff       	call   80103930 <myproc>
80105cf9:	85 c0                	test   %eax,%eax
80105cfb:	74 0b                	je     80105d08 <trap+0xd8>
80105cfd:	e8 2e dc ff ff       	call   80103930 <myproc>
80105d02:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d06:	74 70                	je     80105d78 <trap+0x148>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    //yield();
  	myproc()->runtime +=1;
	myproc()->vruntime += (int)(1024 /(1800)); 
80105d08:	e8 23 dc ff ff       	call   80103930 <myproc>
	if(myproc() && myproc()->state == RUNNING) {
		myproc()->runtime = myproc()->runtime+1;
  	}
  */
	// Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d0d:	e8 1e dc ff ff       	call   80103930 <myproc>
80105d12:	85 c0                	test   %eax,%eax
80105d14:	74 19                	je     80105d2f <trap+0xff>
80105d16:	e8 15 dc ff ff       	call   80103930 <myproc>
80105d1b:	8b 40 24             	mov    0x24(%eax),%eax
80105d1e:	85 c0                	test   %eax,%eax
80105d20:	74 0d                	je     80105d2f <trap+0xff>
80105d22:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105d26:	83 e0 03             	and    $0x3,%eax
80105d29:	66 83 f8 03          	cmp    $0x3,%ax
80105d2d:	74 3a                	je     80105d69 <trap+0x139>
    exit();
}
80105d2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d32:	5b                   	pop    %ebx
80105d33:	5e                   	pop    %esi
80105d34:	5f                   	pop    %edi
80105d35:	5d                   	pop    %ebp
80105d36:	c3                   	ret    
80105d37:	89 f6                	mov    %esi,%esi
80105d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(myproc()->killed)
80105d40:	e8 eb db ff ff       	call   80103930 <myproc>
80105d45:	8b 58 24             	mov    0x24(%eax),%ebx
80105d48:	85 db                	test   %ebx,%ebx
80105d4a:	0f 85 f0 00 00 00    	jne    80105e40 <trap+0x210>
    myproc()->tf = tf;
80105d50:	e8 db db ff ff       	call   80103930 <myproc>
80105d55:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105d58:	e8 a3 ee ff ff       	call   80104c00 <syscall>
    if(myproc()->killed)
80105d5d:	e8 ce db ff ff       	call   80103930 <myproc>
80105d62:	8b 48 24             	mov    0x24(%eax),%ecx
80105d65:	85 c9                	test   %ecx,%ecx
80105d67:	74 c6                	je     80105d2f <trap+0xff>
}
80105d69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d6c:	5b                   	pop    %ebx
80105d6d:	5e                   	pop    %esi
80105d6e:	5f                   	pop    %edi
80105d6f:	5d                   	pop    %ebp
      exit();
80105d70:	e9 2b e0 ff ff       	jmp    80103da0 <exit>
80105d75:	8d 76 00             	lea    0x0(%esi),%esi
	if(myproc() && myproc()->state == RUNNING &&
80105d78:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105d7c:	75 8a                	jne    80105d08 <trap+0xd8>
  	myproc()->runtime +=1;
80105d7e:	e8 ad db ff ff       	call   80103930 <myproc>
80105d83:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
80105d8a:	e9 79 ff ff ff       	jmp    80105d08 <trap+0xd8>
80105d8f:	90                   	nop
    if(cpuid() == 0){
80105d90:	e8 7b db ff ff       	call   80103910 <cpuid>
80105d95:	85 c0                	test   %eax,%eax
80105d97:	0f 84 c3 00 00 00    	je     80105e60 <trap+0x230>
    lapiceoi();
80105d9d:	e8 ce ca ff ff       	call   80102870 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105da2:	e8 89 db ff ff       	call   80103930 <myproc>
80105da7:	85 c0                	test   %eax,%eax
80105da9:	0f 85 28 ff ff ff    	jne    80105cd7 <trap+0xa7>
80105daf:	e9 40 ff ff ff       	jmp    80105cf4 <trap+0xc4>
80105db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105db8:	e8 73 c9 ff ff       	call   80102730 <kbdintr>
    lapiceoi();
80105dbd:	e8 ae ca ff ff       	call   80102870 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dc2:	e8 69 db ff ff       	call   80103930 <myproc>
80105dc7:	85 c0                	test   %eax,%eax
80105dc9:	0f 85 08 ff ff ff    	jne    80105cd7 <trap+0xa7>
80105dcf:	e9 20 ff ff ff       	jmp    80105cf4 <trap+0xc4>
80105dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105dd8:	e8 53 02 00 00       	call   80106030 <uartintr>
    lapiceoi();
80105ddd:	e8 8e ca ff ff       	call   80102870 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105de2:	e8 49 db ff ff       	call   80103930 <myproc>
80105de7:	85 c0                	test   %eax,%eax
80105de9:	0f 85 e8 fe ff ff    	jne    80105cd7 <trap+0xa7>
80105def:	e9 00 ff ff ff       	jmp    80105cf4 <trap+0xc4>
80105df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105df8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105dfc:	8b 77 38             	mov    0x38(%edi),%esi
80105dff:	e8 0c db ff ff       	call   80103910 <cpuid>
80105e04:	56                   	push   %esi
80105e05:	53                   	push   %ebx
80105e06:	50                   	push   %eax
80105e07:	68 fc 7c 10 80       	push   $0x80107cfc
80105e0c:	e8 4f a8 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105e11:	e8 5a ca ff ff       	call   80102870 <lapiceoi>
    break;
80105e16:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e19:	e8 12 db ff ff       	call   80103930 <myproc>
80105e1e:	85 c0                	test   %eax,%eax
80105e20:	0f 85 b1 fe ff ff    	jne    80105cd7 <trap+0xa7>
80105e26:	e9 c9 fe ff ff       	jmp    80105cf4 <trap+0xc4>
80105e2b:	90                   	nop
80105e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105e30:	e8 6b c3 ff ff       	call   801021a0 <ideintr>
80105e35:	e9 63 ff ff ff       	jmp    80105d9d <trap+0x16d>
80105e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105e40:	e8 5b df ff ff       	call   80103da0 <exit>
80105e45:	e9 06 ff ff ff       	jmp    80105d50 <trap+0x120>
80105e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105e50:	e8 4b df ff ff       	call   80103da0 <exit>
80105e55:	e9 9a fe ff ff       	jmp    80105cf4 <trap+0xc4>
80105e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105e60:	83 ec 0c             	sub    $0xc,%esp
80105e63:	68 60 50 11 80       	push   $0x80115060
80105e68:	e8 93 e8 ff ff       	call   80104700 <acquire>
      wakeup(&ticks);
80105e6d:	c7 04 24 a0 58 11 80 	movl   $0x801158a0,(%esp)
      ticks++;
80105e74:	83 05 a0 58 11 80 01 	addl   $0x1,0x801158a0
      wakeup(&ticks);
80105e7b:	e8 60 e2 ff ff       	call   801040e0 <wakeup>
      release(&tickslock);
80105e80:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
80105e87:	e8 34 e9 ff ff       	call   801047c0 <release>
80105e8c:	83 c4 10             	add    $0x10,%esp
80105e8f:	e9 09 ff ff ff       	jmp    80105d9d <trap+0x16d>
80105e94:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105e97:	e8 74 da ff ff       	call   80103910 <cpuid>
80105e9c:	83 ec 0c             	sub    $0xc,%esp
80105e9f:	56                   	push   %esi
80105ea0:	53                   	push   %ebx
80105ea1:	50                   	push   %eax
80105ea2:	ff 77 30             	pushl  0x30(%edi)
80105ea5:	68 20 7d 10 80       	push   $0x80107d20
80105eaa:	e8 b1 a7 ff ff       	call   80100660 <cprintf>
      panic("trap");
80105eaf:	83 c4 14             	add    $0x14,%esp
80105eb2:	68 f6 7c 10 80       	push   $0x80107cf6
80105eb7:	e8 d4 a4 ff ff       	call   80100390 <panic>
80105ebc:	66 90                	xchg   %ax,%ax
80105ebe:	66 90                	xchg   %ax,%ax

80105ec0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ec0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105ec5:	55                   	push   %ebp
80105ec6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105ec8:	85 c0                	test   %eax,%eax
80105eca:	74 1c                	je     80105ee8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ecc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ed1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105ed2:	a8 01                	test   $0x1,%al
80105ed4:	74 12                	je     80105ee8 <uartgetc+0x28>
80105ed6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105edb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105edc:	0f b6 c0             	movzbl %al,%eax
}
80105edf:	5d                   	pop    %ebp
80105ee0:	c3                   	ret    
80105ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ee8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105eed:	5d                   	pop    %ebp
80105eee:	c3                   	ret    
80105eef:	90                   	nop

80105ef0 <uartputc.part.0>:
uartputc(int c)
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	57                   	push   %edi
80105ef4:	56                   	push   %esi
80105ef5:	53                   	push   %ebx
80105ef6:	89 c7                	mov    %eax,%edi
80105ef8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105efd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f02:	83 ec 0c             	sub    $0xc,%esp
80105f05:	eb 1b                	jmp    80105f22 <uartputc.part.0+0x32>
80105f07:	89 f6                	mov    %esi,%esi
80105f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105f10:	83 ec 0c             	sub    $0xc,%esp
80105f13:	6a 0a                	push   $0xa
80105f15:	e8 76 c9 ff ff       	call   80102890 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f1a:	83 c4 10             	add    $0x10,%esp
80105f1d:	83 eb 01             	sub    $0x1,%ebx
80105f20:	74 07                	je     80105f29 <uartputc.part.0+0x39>
80105f22:	89 f2                	mov    %esi,%edx
80105f24:	ec                   	in     (%dx),%al
80105f25:	a8 20                	test   $0x20,%al
80105f27:	74 e7                	je     80105f10 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f29:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f2e:	89 f8                	mov    %edi,%eax
80105f30:	ee                   	out    %al,(%dx)
}
80105f31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f34:	5b                   	pop    %ebx
80105f35:	5e                   	pop    %esi
80105f36:	5f                   	pop    %edi
80105f37:	5d                   	pop    %ebp
80105f38:	c3                   	ret    
80105f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f40 <uartinit>:
{
80105f40:	55                   	push   %ebp
80105f41:	31 c9                	xor    %ecx,%ecx
80105f43:	89 c8                	mov    %ecx,%eax
80105f45:	89 e5                	mov    %esp,%ebp
80105f47:	57                   	push   %edi
80105f48:	56                   	push   %esi
80105f49:	53                   	push   %ebx
80105f4a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105f4f:	89 da                	mov    %ebx,%edx
80105f51:	83 ec 0c             	sub    $0xc,%esp
80105f54:	ee                   	out    %al,(%dx)
80105f55:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105f5a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f5f:	89 fa                	mov    %edi,%edx
80105f61:	ee                   	out    %al,(%dx)
80105f62:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f67:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f6c:	ee                   	out    %al,(%dx)
80105f6d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105f72:	89 c8                	mov    %ecx,%eax
80105f74:	89 f2                	mov    %esi,%edx
80105f76:	ee                   	out    %al,(%dx)
80105f77:	b8 03 00 00 00       	mov    $0x3,%eax
80105f7c:	89 fa                	mov    %edi,%edx
80105f7e:	ee                   	out    %al,(%dx)
80105f7f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f84:	89 c8                	mov    %ecx,%eax
80105f86:	ee                   	out    %al,(%dx)
80105f87:	b8 01 00 00 00       	mov    $0x1,%eax
80105f8c:	89 f2                	mov    %esi,%edx
80105f8e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f8f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f94:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105f95:	3c ff                	cmp    $0xff,%al
80105f97:	74 5a                	je     80105ff3 <uartinit+0xb3>
  uart = 1;
80105f99:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105fa0:	00 00 00 
80105fa3:	89 da                	mov    %ebx,%edx
80105fa5:	ec                   	in     (%dx),%al
80105fa6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fab:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105fac:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105faf:	bb 18 7e 10 80       	mov    $0x80107e18,%ebx
  ioapicenable(IRQ_COM1, 0);
80105fb4:	6a 00                	push   $0x0
80105fb6:	6a 04                	push   $0x4
80105fb8:	e8 33 c4 ff ff       	call   801023f0 <ioapicenable>
80105fbd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105fc0:	b8 78 00 00 00       	mov    $0x78,%eax
80105fc5:	eb 13                	jmp    80105fda <uartinit+0x9a>
80105fc7:	89 f6                	mov    %esi,%esi
80105fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105fd0:	83 c3 01             	add    $0x1,%ebx
80105fd3:	0f be 03             	movsbl (%ebx),%eax
80105fd6:	84 c0                	test   %al,%al
80105fd8:	74 19                	je     80105ff3 <uartinit+0xb3>
  if(!uart)
80105fda:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105fe0:	85 d2                	test   %edx,%edx
80105fe2:	74 ec                	je     80105fd0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105fe4:	83 c3 01             	add    $0x1,%ebx
80105fe7:	e8 04 ff ff ff       	call   80105ef0 <uartputc.part.0>
80105fec:	0f be 03             	movsbl (%ebx),%eax
80105fef:	84 c0                	test   %al,%al
80105ff1:	75 e7                	jne    80105fda <uartinit+0x9a>
}
80105ff3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ff6:	5b                   	pop    %ebx
80105ff7:	5e                   	pop    %esi
80105ff8:	5f                   	pop    %edi
80105ff9:	5d                   	pop    %ebp
80105ffa:	c3                   	ret    
80105ffb:	90                   	nop
80105ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106000 <uartputc>:
  if(!uart)
80106000:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80106006:	55                   	push   %ebp
80106007:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106009:	85 d2                	test   %edx,%edx
{
8010600b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010600e:	74 10                	je     80106020 <uartputc+0x20>
}
80106010:	5d                   	pop    %ebp
80106011:	e9 da fe ff ff       	jmp    80105ef0 <uartputc.part.0>
80106016:	8d 76 00             	lea    0x0(%esi),%esi
80106019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106020:	5d                   	pop    %ebp
80106021:	c3                   	ret    
80106022:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106030 <uartintr>:

void
uartintr(void)
{
80106030:	55                   	push   %ebp
80106031:	89 e5                	mov    %esp,%ebp
80106033:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106036:	68 c0 5e 10 80       	push   $0x80105ec0
8010603b:	e8 d0 a7 ff ff       	call   80100810 <consoleintr>
}
80106040:	83 c4 10             	add    $0x10,%esp
80106043:	c9                   	leave  
80106044:	c3                   	ret    

80106045 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106045:	6a 00                	push   $0x0
  pushl $0
80106047:	6a 00                	push   $0x0
  jmp alltraps
80106049:	e9 09 fb ff ff       	jmp    80105b57 <alltraps>

8010604e <vector1>:
.globl vector1
vector1:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $1
80106050:	6a 01                	push   $0x1
  jmp alltraps
80106052:	e9 00 fb ff ff       	jmp    80105b57 <alltraps>

80106057 <vector2>:
.globl vector2
vector2:
  pushl $0
80106057:	6a 00                	push   $0x0
  pushl $2
80106059:	6a 02                	push   $0x2
  jmp alltraps
8010605b:	e9 f7 fa ff ff       	jmp    80105b57 <alltraps>

80106060 <vector3>:
.globl vector3
vector3:
  pushl $0
80106060:	6a 00                	push   $0x0
  pushl $3
80106062:	6a 03                	push   $0x3
  jmp alltraps
80106064:	e9 ee fa ff ff       	jmp    80105b57 <alltraps>

80106069 <vector4>:
.globl vector4
vector4:
  pushl $0
80106069:	6a 00                	push   $0x0
  pushl $4
8010606b:	6a 04                	push   $0x4
  jmp alltraps
8010606d:	e9 e5 fa ff ff       	jmp    80105b57 <alltraps>

80106072 <vector5>:
.globl vector5
vector5:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $5
80106074:	6a 05                	push   $0x5
  jmp alltraps
80106076:	e9 dc fa ff ff       	jmp    80105b57 <alltraps>

8010607b <vector6>:
.globl vector6
vector6:
  pushl $0
8010607b:	6a 00                	push   $0x0
  pushl $6
8010607d:	6a 06                	push   $0x6
  jmp alltraps
8010607f:	e9 d3 fa ff ff       	jmp    80105b57 <alltraps>

80106084 <vector7>:
.globl vector7
vector7:
  pushl $0
80106084:	6a 00                	push   $0x0
  pushl $7
80106086:	6a 07                	push   $0x7
  jmp alltraps
80106088:	e9 ca fa ff ff       	jmp    80105b57 <alltraps>

8010608d <vector8>:
.globl vector8
vector8:
  pushl $8
8010608d:	6a 08                	push   $0x8
  jmp alltraps
8010608f:	e9 c3 fa ff ff       	jmp    80105b57 <alltraps>

80106094 <vector9>:
.globl vector9
vector9:
  pushl $0
80106094:	6a 00                	push   $0x0
  pushl $9
80106096:	6a 09                	push   $0x9
  jmp alltraps
80106098:	e9 ba fa ff ff       	jmp    80105b57 <alltraps>

8010609d <vector10>:
.globl vector10
vector10:
  pushl $10
8010609d:	6a 0a                	push   $0xa
  jmp alltraps
8010609f:	e9 b3 fa ff ff       	jmp    80105b57 <alltraps>

801060a4 <vector11>:
.globl vector11
vector11:
  pushl $11
801060a4:	6a 0b                	push   $0xb
  jmp alltraps
801060a6:	e9 ac fa ff ff       	jmp    80105b57 <alltraps>

801060ab <vector12>:
.globl vector12
vector12:
  pushl $12
801060ab:	6a 0c                	push   $0xc
  jmp alltraps
801060ad:	e9 a5 fa ff ff       	jmp    80105b57 <alltraps>

801060b2 <vector13>:
.globl vector13
vector13:
  pushl $13
801060b2:	6a 0d                	push   $0xd
  jmp alltraps
801060b4:	e9 9e fa ff ff       	jmp    80105b57 <alltraps>

801060b9 <vector14>:
.globl vector14
vector14:
  pushl $14
801060b9:	6a 0e                	push   $0xe
  jmp alltraps
801060bb:	e9 97 fa ff ff       	jmp    80105b57 <alltraps>

801060c0 <vector15>:
.globl vector15
vector15:
  pushl $0
801060c0:	6a 00                	push   $0x0
  pushl $15
801060c2:	6a 0f                	push   $0xf
  jmp alltraps
801060c4:	e9 8e fa ff ff       	jmp    80105b57 <alltraps>

801060c9 <vector16>:
.globl vector16
vector16:
  pushl $0
801060c9:	6a 00                	push   $0x0
  pushl $16
801060cb:	6a 10                	push   $0x10
  jmp alltraps
801060cd:	e9 85 fa ff ff       	jmp    80105b57 <alltraps>

801060d2 <vector17>:
.globl vector17
vector17:
  pushl $17
801060d2:	6a 11                	push   $0x11
  jmp alltraps
801060d4:	e9 7e fa ff ff       	jmp    80105b57 <alltraps>

801060d9 <vector18>:
.globl vector18
vector18:
  pushl $0
801060d9:	6a 00                	push   $0x0
  pushl $18
801060db:	6a 12                	push   $0x12
  jmp alltraps
801060dd:	e9 75 fa ff ff       	jmp    80105b57 <alltraps>

801060e2 <vector19>:
.globl vector19
vector19:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $19
801060e4:	6a 13                	push   $0x13
  jmp alltraps
801060e6:	e9 6c fa ff ff       	jmp    80105b57 <alltraps>

801060eb <vector20>:
.globl vector20
vector20:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $20
801060ed:	6a 14                	push   $0x14
  jmp alltraps
801060ef:	e9 63 fa ff ff       	jmp    80105b57 <alltraps>

801060f4 <vector21>:
.globl vector21
vector21:
  pushl $0
801060f4:	6a 00                	push   $0x0
  pushl $21
801060f6:	6a 15                	push   $0x15
  jmp alltraps
801060f8:	e9 5a fa ff ff       	jmp    80105b57 <alltraps>

801060fd <vector22>:
.globl vector22
vector22:
  pushl $0
801060fd:	6a 00                	push   $0x0
  pushl $22
801060ff:	6a 16                	push   $0x16
  jmp alltraps
80106101:	e9 51 fa ff ff       	jmp    80105b57 <alltraps>

80106106 <vector23>:
.globl vector23
vector23:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $23
80106108:	6a 17                	push   $0x17
  jmp alltraps
8010610a:	e9 48 fa ff ff       	jmp    80105b57 <alltraps>

8010610f <vector24>:
.globl vector24
vector24:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $24
80106111:	6a 18                	push   $0x18
  jmp alltraps
80106113:	e9 3f fa ff ff       	jmp    80105b57 <alltraps>

80106118 <vector25>:
.globl vector25
vector25:
  pushl $0
80106118:	6a 00                	push   $0x0
  pushl $25
8010611a:	6a 19                	push   $0x19
  jmp alltraps
8010611c:	e9 36 fa ff ff       	jmp    80105b57 <alltraps>

80106121 <vector26>:
.globl vector26
vector26:
  pushl $0
80106121:	6a 00                	push   $0x0
  pushl $26
80106123:	6a 1a                	push   $0x1a
  jmp alltraps
80106125:	e9 2d fa ff ff       	jmp    80105b57 <alltraps>

8010612a <vector27>:
.globl vector27
vector27:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $27
8010612c:	6a 1b                	push   $0x1b
  jmp alltraps
8010612e:	e9 24 fa ff ff       	jmp    80105b57 <alltraps>

80106133 <vector28>:
.globl vector28
vector28:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $28
80106135:	6a 1c                	push   $0x1c
  jmp alltraps
80106137:	e9 1b fa ff ff       	jmp    80105b57 <alltraps>

8010613c <vector29>:
.globl vector29
vector29:
  pushl $0
8010613c:	6a 00                	push   $0x0
  pushl $29
8010613e:	6a 1d                	push   $0x1d
  jmp alltraps
80106140:	e9 12 fa ff ff       	jmp    80105b57 <alltraps>

80106145 <vector30>:
.globl vector30
vector30:
  pushl $0
80106145:	6a 00                	push   $0x0
  pushl $30
80106147:	6a 1e                	push   $0x1e
  jmp alltraps
80106149:	e9 09 fa ff ff       	jmp    80105b57 <alltraps>

8010614e <vector31>:
.globl vector31
vector31:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $31
80106150:	6a 1f                	push   $0x1f
  jmp alltraps
80106152:	e9 00 fa ff ff       	jmp    80105b57 <alltraps>

80106157 <vector32>:
.globl vector32
vector32:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $32
80106159:	6a 20                	push   $0x20
  jmp alltraps
8010615b:	e9 f7 f9 ff ff       	jmp    80105b57 <alltraps>

80106160 <vector33>:
.globl vector33
vector33:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $33
80106162:	6a 21                	push   $0x21
  jmp alltraps
80106164:	e9 ee f9 ff ff       	jmp    80105b57 <alltraps>

80106169 <vector34>:
.globl vector34
vector34:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $34
8010616b:	6a 22                	push   $0x22
  jmp alltraps
8010616d:	e9 e5 f9 ff ff       	jmp    80105b57 <alltraps>

80106172 <vector35>:
.globl vector35
vector35:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $35
80106174:	6a 23                	push   $0x23
  jmp alltraps
80106176:	e9 dc f9 ff ff       	jmp    80105b57 <alltraps>

8010617b <vector36>:
.globl vector36
vector36:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $36
8010617d:	6a 24                	push   $0x24
  jmp alltraps
8010617f:	e9 d3 f9 ff ff       	jmp    80105b57 <alltraps>

80106184 <vector37>:
.globl vector37
vector37:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $37
80106186:	6a 25                	push   $0x25
  jmp alltraps
80106188:	e9 ca f9 ff ff       	jmp    80105b57 <alltraps>

8010618d <vector38>:
.globl vector38
vector38:
  pushl $0
8010618d:	6a 00                	push   $0x0
  pushl $38
8010618f:	6a 26                	push   $0x26
  jmp alltraps
80106191:	e9 c1 f9 ff ff       	jmp    80105b57 <alltraps>

80106196 <vector39>:
.globl vector39
vector39:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $39
80106198:	6a 27                	push   $0x27
  jmp alltraps
8010619a:	e9 b8 f9 ff ff       	jmp    80105b57 <alltraps>

8010619f <vector40>:
.globl vector40
vector40:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $40
801061a1:	6a 28                	push   $0x28
  jmp alltraps
801061a3:	e9 af f9 ff ff       	jmp    80105b57 <alltraps>

801061a8 <vector41>:
.globl vector41
vector41:
  pushl $0
801061a8:	6a 00                	push   $0x0
  pushl $41
801061aa:	6a 29                	push   $0x29
  jmp alltraps
801061ac:	e9 a6 f9 ff ff       	jmp    80105b57 <alltraps>

801061b1 <vector42>:
.globl vector42
vector42:
  pushl $0
801061b1:	6a 00                	push   $0x0
  pushl $42
801061b3:	6a 2a                	push   $0x2a
  jmp alltraps
801061b5:	e9 9d f9 ff ff       	jmp    80105b57 <alltraps>

801061ba <vector43>:
.globl vector43
vector43:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $43
801061bc:	6a 2b                	push   $0x2b
  jmp alltraps
801061be:	e9 94 f9 ff ff       	jmp    80105b57 <alltraps>

801061c3 <vector44>:
.globl vector44
vector44:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $44
801061c5:	6a 2c                	push   $0x2c
  jmp alltraps
801061c7:	e9 8b f9 ff ff       	jmp    80105b57 <alltraps>

801061cc <vector45>:
.globl vector45
vector45:
  pushl $0
801061cc:	6a 00                	push   $0x0
  pushl $45
801061ce:	6a 2d                	push   $0x2d
  jmp alltraps
801061d0:	e9 82 f9 ff ff       	jmp    80105b57 <alltraps>

801061d5 <vector46>:
.globl vector46
vector46:
  pushl $0
801061d5:	6a 00                	push   $0x0
  pushl $46
801061d7:	6a 2e                	push   $0x2e
  jmp alltraps
801061d9:	e9 79 f9 ff ff       	jmp    80105b57 <alltraps>

801061de <vector47>:
.globl vector47
vector47:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $47
801061e0:	6a 2f                	push   $0x2f
  jmp alltraps
801061e2:	e9 70 f9 ff ff       	jmp    80105b57 <alltraps>

801061e7 <vector48>:
.globl vector48
vector48:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $48
801061e9:	6a 30                	push   $0x30
  jmp alltraps
801061eb:	e9 67 f9 ff ff       	jmp    80105b57 <alltraps>

801061f0 <vector49>:
.globl vector49
vector49:
  pushl $0
801061f0:	6a 00                	push   $0x0
  pushl $49
801061f2:	6a 31                	push   $0x31
  jmp alltraps
801061f4:	e9 5e f9 ff ff       	jmp    80105b57 <alltraps>

801061f9 <vector50>:
.globl vector50
vector50:
  pushl $0
801061f9:	6a 00                	push   $0x0
  pushl $50
801061fb:	6a 32                	push   $0x32
  jmp alltraps
801061fd:	e9 55 f9 ff ff       	jmp    80105b57 <alltraps>

80106202 <vector51>:
.globl vector51
vector51:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $51
80106204:	6a 33                	push   $0x33
  jmp alltraps
80106206:	e9 4c f9 ff ff       	jmp    80105b57 <alltraps>

8010620b <vector52>:
.globl vector52
vector52:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $52
8010620d:	6a 34                	push   $0x34
  jmp alltraps
8010620f:	e9 43 f9 ff ff       	jmp    80105b57 <alltraps>

80106214 <vector53>:
.globl vector53
vector53:
  pushl $0
80106214:	6a 00                	push   $0x0
  pushl $53
80106216:	6a 35                	push   $0x35
  jmp alltraps
80106218:	e9 3a f9 ff ff       	jmp    80105b57 <alltraps>

8010621d <vector54>:
.globl vector54
vector54:
  pushl $0
8010621d:	6a 00                	push   $0x0
  pushl $54
8010621f:	6a 36                	push   $0x36
  jmp alltraps
80106221:	e9 31 f9 ff ff       	jmp    80105b57 <alltraps>

80106226 <vector55>:
.globl vector55
vector55:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $55
80106228:	6a 37                	push   $0x37
  jmp alltraps
8010622a:	e9 28 f9 ff ff       	jmp    80105b57 <alltraps>

8010622f <vector56>:
.globl vector56
vector56:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $56
80106231:	6a 38                	push   $0x38
  jmp alltraps
80106233:	e9 1f f9 ff ff       	jmp    80105b57 <alltraps>

80106238 <vector57>:
.globl vector57
vector57:
  pushl $0
80106238:	6a 00                	push   $0x0
  pushl $57
8010623a:	6a 39                	push   $0x39
  jmp alltraps
8010623c:	e9 16 f9 ff ff       	jmp    80105b57 <alltraps>

80106241 <vector58>:
.globl vector58
vector58:
  pushl $0
80106241:	6a 00                	push   $0x0
  pushl $58
80106243:	6a 3a                	push   $0x3a
  jmp alltraps
80106245:	e9 0d f9 ff ff       	jmp    80105b57 <alltraps>

8010624a <vector59>:
.globl vector59
vector59:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $59
8010624c:	6a 3b                	push   $0x3b
  jmp alltraps
8010624e:	e9 04 f9 ff ff       	jmp    80105b57 <alltraps>

80106253 <vector60>:
.globl vector60
vector60:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $60
80106255:	6a 3c                	push   $0x3c
  jmp alltraps
80106257:	e9 fb f8 ff ff       	jmp    80105b57 <alltraps>

8010625c <vector61>:
.globl vector61
vector61:
  pushl $0
8010625c:	6a 00                	push   $0x0
  pushl $61
8010625e:	6a 3d                	push   $0x3d
  jmp alltraps
80106260:	e9 f2 f8 ff ff       	jmp    80105b57 <alltraps>

80106265 <vector62>:
.globl vector62
vector62:
  pushl $0
80106265:	6a 00                	push   $0x0
  pushl $62
80106267:	6a 3e                	push   $0x3e
  jmp alltraps
80106269:	e9 e9 f8 ff ff       	jmp    80105b57 <alltraps>

8010626e <vector63>:
.globl vector63
vector63:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $63
80106270:	6a 3f                	push   $0x3f
  jmp alltraps
80106272:	e9 e0 f8 ff ff       	jmp    80105b57 <alltraps>

80106277 <vector64>:
.globl vector64
vector64:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $64
80106279:	6a 40                	push   $0x40
  jmp alltraps
8010627b:	e9 d7 f8 ff ff       	jmp    80105b57 <alltraps>

80106280 <vector65>:
.globl vector65
vector65:
  pushl $0
80106280:	6a 00                	push   $0x0
  pushl $65
80106282:	6a 41                	push   $0x41
  jmp alltraps
80106284:	e9 ce f8 ff ff       	jmp    80105b57 <alltraps>

80106289 <vector66>:
.globl vector66
vector66:
  pushl $0
80106289:	6a 00                	push   $0x0
  pushl $66
8010628b:	6a 42                	push   $0x42
  jmp alltraps
8010628d:	e9 c5 f8 ff ff       	jmp    80105b57 <alltraps>

80106292 <vector67>:
.globl vector67
vector67:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $67
80106294:	6a 43                	push   $0x43
  jmp alltraps
80106296:	e9 bc f8 ff ff       	jmp    80105b57 <alltraps>

8010629b <vector68>:
.globl vector68
vector68:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $68
8010629d:	6a 44                	push   $0x44
  jmp alltraps
8010629f:	e9 b3 f8 ff ff       	jmp    80105b57 <alltraps>

801062a4 <vector69>:
.globl vector69
vector69:
  pushl $0
801062a4:	6a 00                	push   $0x0
  pushl $69
801062a6:	6a 45                	push   $0x45
  jmp alltraps
801062a8:	e9 aa f8 ff ff       	jmp    80105b57 <alltraps>

801062ad <vector70>:
.globl vector70
vector70:
  pushl $0
801062ad:	6a 00                	push   $0x0
  pushl $70
801062af:	6a 46                	push   $0x46
  jmp alltraps
801062b1:	e9 a1 f8 ff ff       	jmp    80105b57 <alltraps>

801062b6 <vector71>:
.globl vector71
vector71:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $71
801062b8:	6a 47                	push   $0x47
  jmp alltraps
801062ba:	e9 98 f8 ff ff       	jmp    80105b57 <alltraps>

801062bf <vector72>:
.globl vector72
vector72:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $72
801062c1:	6a 48                	push   $0x48
  jmp alltraps
801062c3:	e9 8f f8 ff ff       	jmp    80105b57 <alltraps>

801062c8 <vector73>:
.globl vector73
vector73:
  pushl $0
801062c8:	6a 00                	push   $0x0
  pushl $73
801062ca:	6a 49                	push   $0x49
  jmp alltraps
801062cc:	e9 86 f8 ff ff       	jmp    80105b57 <alltraps>

801062d1 <vector74>:
.globl vector74
vector74:
  pushl $0
801062d1:	6a 00                	push   $0x0
  pushl $74
801062d3:	6a 4a                	push   $0x4a
  jmp alltraps
801062d5:	e9 7d f8 ff ff       	jmp    80105b57 <alltraps>

801062da <vector75>:
.globl vector75
vector75:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $75
801062dc:	6a 4b                	push   $0x4b
  jmp alltraps
801062de:	e9 74 f8 ff ff       	jmp    80105b57 <alltraps>

801062e3 <vector76>:
.globl vector76
vector76:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $76
801062e5:	6a 4c                	push   $0x4c
  jmp alltraps
801062e7:	e9 6b f8 ff ff       	jmp    80105b57 <alltraps>

801062ec <vector77>:
.globl vector77
vector77:
  pushl $0
801062ec:	6a 00                	push   $0x0
  pushl $77
801062ee:	6a 4d                	push   $0x4d
  jmp alltraps
801062f0:	e9 62 f8 ff ff       	jmp    80105b57 <alltraps>

801062f5 <vector78>:
.globl vector78
vector78:
  pushl $0
801062f5:	6a 00                	push   $0x0
  pushl $78
801062f7:	6a 4e                	push   $0x4e
  jmp alltraps
801062f9:	e9 59 f8 ff ff       	jmp    80105b57 <alltraps>

801062fe <vector79>:
.globl vector79
vector79:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $79
80106300:	6a 4f                	push   $0x4f
  jmp alltraps
80106302:	e9 50 f8 ff ff       	jmp    80105b57 <alltraps>

80106307 <vector80>:
.globl vector80
vector80:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $80
80106309:	6a 50                	push   $0x50
  jmp alltraps
8010630b:	e9 47 f8 ff ff       	jmp    80105b57 <alltraps>

80106310 <vector81>:
.globl vector81
vector81:
  pushl $0
80106310:	6a 00                	push   $0x0
  pushl $81
80106312:	6a 51                	push   $0x51
  jmp alltraps
80106314:	e9 3e f8 ff ff       	jmp    80105b57 <alltraps>

80106319 <vector82>:
.globl vector82
vector82:
  pushl $0
80106319:	6a 00                	push   $0x0
  pushl $82
8010631b:	6a 52                	push   $0x52
  jmp alltraps
8010631d:	e9 35 f8 ff ff       	jmp    80105b57 <alltraps>

80106322 <vector83>:
.globl vector83
vector83:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $83
80106324:	6a 53                	push   $0x53
  jmp alltraps
80106326:	e9 2c f8 ff ff       	jmp    80105b57 <alltraps>

8010632b <vector84>:
.globl vector84
vector84:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $84
8010632d:	6a 54                	push   $0x54
  jmp alltraps
8010632f:	e9 23 f8 ff ff       	jmp    80105b57 <alltraps>

80106334 <vector85>:
.globl vector85
vector85:
  pushl $0
80106334:	6a 00                	push   $0x0
  pushl $85
80106336:	6a 55                	push   $0x55
  jmp alltraps
80106338:	e9 1a f8 ff ff       	jmp    80105b57 <alltraps>

8010633d <vector86>:
.globl vector86
vector86:
  pushl $0
8010633d:	6a 00                	push   $0x0
  pushl $86
8010633f:	6a 56                	push   $0x56
  jmp alltraps
80106341:	e9 11 f8 ff ff       	jmp    80105b57 <alltraps>

80106346 <vector87>:
.globl vector87
vector87:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $87
80106348:	6a 57                	push   $0x57
  jmp alltraps
8010634a:	e9 08 f8 ff ff       	jmp    80105b57 <alltraps>

8010634f <vector88>:
.globl vector88
vector88:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $88
80106351:	6a 58                	push   $0x58
  jmp alltraps
80106353:	e9 ff f7 ff ff       	jmp    80105b57 <alltraps>

80106358 <vector89>:
.globl vector89
vector89:
  pushl $0
80106358:	6a 00                	push   $0x0
  pushl $89
8010635a:	6a 59                	push   $0x59
  jmp alltraps
8010635c:	e9 f6 f7 ff ff       	jmp    80105b57 <alltraps>

80106361 <vector90>:
.globl vector90
vector90:
  pushl $0
80106361:	6a 00                	push   $0x0
  pushl $90
80106363:	6a 5a                	push   $0x5a
  jmp alltraps
80106365:	e9 ed f7 ff ff       	jmp    80105b57 <alltraps>

8010636a <vector91>:
.globl vector91
vector91:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $91
8010636c:	6a 5b                	push   $0x5b
  jmp alltraps
8010636e:	e9 e4 f7 ff ff       	jmp    80105b57 <alltraps>

80106373 <vector92>:
.globl vector92
vector92:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $92
80106375:	6a 5c                	push   $0x5c
  jmp alltraps
80106377:	e9 db f7 ff ff       	jmp    80105b57 <alltraps>

8010637c <vector93>:
.globl vector93
vector93:
  pushl $0
8010637c:	6a 00                	push   $0x0
  pushl $93
8010637e:	6a 5d                	push   $0x5d
  jmp alltraps
80106380:	e9 d2 f7 ff ff       	jmp    80105b57 <alltraps>

80106385 <vector94>:
.globl vector94
vector94:
  pushl $0
80106385:	6a 00                	push   $0x0
  pushl $94
80106387:	6a 5e                	push   $0x5e
  jmp alltraps
80106389:	e9 c9 f7 ff ff       	jmp    80105b57 <alltraps>

8010638e <vector95>:
.globl vector95
vector95:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $95
80106390:	6a 5f                	push   $0x5f
  jmp alltraps
80106392:	e9 c0 f7 ff ff       	jmp    80105b57 <alltraps>

80106397 <vector96>:
.globl vector96
vector96:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $96
80106399:	6a 60                	push   $0x60
  jmp alltraps
8010639b:	e9 b7 f7 ff ff       	jmp    80105b57 <alltraps>

801063a0 <vector97>:
.globl vector97
vector97:
  pushl $0
801063a0:	6a 00                	push   $0x0
  pushl $97
801063a2:	6a 61                	push   $0x61
  jmp alltraps
801063a4:	e9 ae f7 ff ff       	jmp    80105b57 <alltraps>

801063a9 <vector98>:
.globl vector98
vector98:
  pushl $0
801063a9:	6a 00                	push   $0x0
  pushl $98
801063ab:	6a 62                	push   $0x62
  jmp alltraps
801063ad:	e9 a5 f7 ff ff       	jmp    80105b57 <alltraps>

801063b2 <vector99>:
.globl vector99
vector99:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $99
801063b4:	6a 63                	push   $0x63
  jmp alltraps
801063b6:	e9 9c f7 ff ff       	jmp    80105b57 <alltraps>

801063bb <vector100>:
.globl vector100
vector100:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $100
801063bd:	6a 64                	push   $0x64
  jmp alltraps
801063bf:	e9 93 f7 ff ff       	jmp    80105b57 <alltraps>

801063c4 <vector101>:
.globl vector101
vector101:
  pushl $0
801063c4:	6a 00                	push   $0x0
  pushl $101
801063c6:	6a 65                	push   $0x65
  jmp alltraps
801063c8:	e9 8a f7 ff ff       	jmp    80105b57 <alltraps>

801063cd <vector102>:
.globl vector102
vector102:
  pushl $0
801063cd:	6a 00                	push   $0x0
  pushl $102
801063cf:	6a 66                	push   $0x66
  jmp alltraps
801063d1:	e9 81 f7 ff ff       	jmp    80105b57 <alltraps>

801063d6 <vector103>:
.globl vector103
vector103:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $103
801063d8:	6a 67                	push   $0x67
  jmp alltraps
801063da:	e9 78 f7 ff ff       	jmp    80105b57 <alltraps>

801063df <vector104>:
.globl vector104
vector104:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $104
801063e1:	6a 68                	push   $0x68
  jmp alltraps
801063e3:	e9 6f f7 ff ff       	jmp    80105b57 <alltraps>

801063e8 <vector105>:
.globl vector105
vector105:
  pushl $0
801063e8:	6a 00                	push   $0x0
  pushl $105
801063ea:	6a 69                	push   $0x69
  jmp alltraps
801063ec:	e9 66 f7 ff ff       	jmp    80105b57 <alltraps>

801063f1 <vector106>:
.globl vector106
vector106:
  pushl $0
801063f1:	6a 00                	push   $0x0
  pushl $106
801063f3:	6a 6a                	push   $0x6a
  jmp alltraps
801063f5:	e9 5d f7 ff ff       	jmp    80105b57 <alltraps>

801063fa <vector107>:
.globl vector107
vector107:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $107
801063fc:	6a 6b                	push   $0x6b
  jmp alltraps
801063fe:	e9 54 f7 ff ff       	jmp    80105b57 <alltraps>

80106403 <vector108>:
.globl vector108
vector108:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $108
80106405:	6a 6c                	push   $0x6c
  jmp alltraps
80106407:	e9 4b f7 ff ff       	jmp    80105b57 <alltraps>

8010640c <vector109>:
.globl vector109
vector109:
  pushl $0
8010640c:	6a 00                	push   $0x0
  pushl $109
8010640e:	6a 6d                	push   $0x6d
  jmp alltraps
80106410:	e9 42 f7 ff ff       	jmp    80105b57 <alltraps>

80106415 <vector110>:
.globl vector110
vector110:
  pushl $0
80106415:	6a 00                	push   $0x0
  pushl $110
80106417:	6a 6e                	push   $0x6e
  jmp alltraps
80106419:	e9 39 f7 ff ff       	jmp    80105b57 <alltraps>

8010641e <vector111>:
.globl vector111
vector111:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $111
80106420:	6a 6f                	push   $0x6f
  jmp alltraps
80106422:	e9 30 f7 ff ff       	jmp    80105b57 <alltraps>

80106427 <vector112>:
.globl vector112
vector112:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $112
80106429:	6a 70                	push   $0x70
  jmp alltraps
8010642b:	e9 27 f7 ff ff       	jmp    80105b57 <alltraps>

80106430 <vector113>:
.globl vector113
vector113:
  pushl $0
80106430:	6a 00                	push   $0x0
  pushl $113
80106432:	6a 71                	push   $0x71
  jmp alltraps
80106434:	e9 1e f7 ff ff       	jmp    80105b57 <alltraps>

80106439 <vector114>:
.globl vector114
vector114:
  pushl $0
80106439:	6a 00                	push   $0x0
  pushl $114
8010643b:	6a 72                	push   $0x72
  jmp alltraps
8010643d:	e9 15 f7 ff ff       	jmp    80105b57 <alltraps>

80106442 <vector115>:
.globl vector115
vector115:
  pushl $0
80106442:	6a 00                	push   $0x0
  pushl $115
80106444:	6a 73                	push   $0x73
  jmp alltraps
80106446:	e9 0c f7 ff ff       	jmp    80105b57 <alltraps>

8010644b <vector116>:
.globl vector116
vector116:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $116
8010644d:	6a 74                	push   $0x74
  jmp alltraps
8010644f:	e9 03 f7 ff ff       	jmp    80105b57 <alltraps>

80106454 <vector117>:
.globl vector117
vector117:
  pushl $0
80106454:	6a 00                	push   $0x0
  pushl $117
80106456:	6a 75                	push   $0x75
  jmp alltraps
80106458:	e9 fa f6 ff ff       	jmp    80105b57 <alltraps>

8010645d <vector118>:
.globl vector118
vector118:
  pushl $0
8010645d:	6a 00                	push   $0x0
  pushl $118
8010645f:	6a 76                	push   $0x76
  jmp alltraps
80106461:	e9 f1 f6 ff ff       	jmp    80105b57 <alltraps>

80106466 <vector119>:
.globl vector119
vector119:
  pushl $0
80106466:	6a 00                	push   $0x0
  pushl $119
80106468:	6a 77                	push   $0x77
  jmp alltraps
8010646a:	e9 e8 f6 ff ff       	jmp    80105b57 <alltraps>

8010646f <vector120>:
.globl vector120
vector120:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $120
80106471:	6a 78                	push   $0x78
  jmp alltraps
80106473:	e9 df f6 ff ff       	jmp    80105b57 <alltraps>

80106478 <vector121>:
.globl vector121
vector121:
  pushl $0
80106478:	6a 00                	push   $0x0
  pushl $121
8010647a:	6a 79                	push   $0x79
  jmp alltraps
8010647c:	e9 d6 f6 ff ff       	jmp    80105b57 <alltraps>

80106481 <vector122>:
.globl vector122
vector122:
  pushl $0
80106481:	6a 00                	push   $0x0
  pushl $122
80106483:	6a 7a                	push   $0x7a
  jmp alltraps
80106485:	e9 cd f6 ff ff       	jmp    80105b57 <alltraps>

8010648a <vector123>:
.globl vector123
vector123:
  pushl $0
8010648a:	6a 00                	push   $0x0
  pushl $123
8010648c:	6a 7b                	push   $0x7b
  jmp alltraps
8010648e:	e9 c4 f6 ff ff       	jmp    80105b57 <alltraps>

80106493 <vector124>:
.globl vector124
vector124:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $124
80106495:	6a 7c                	push   $0x7c
  jmp alltraps
80106497:	e9 bb f6 ff ff       	jmp    80105b57 <alltraps>

8010649c <vector125>:
.globl vector125
vector125:
  pushl $0
8010649c:	6a 00                	push   $0x0
  pushl $125
8010649e:	6a 7d                	push   $0x7d
  jmp alltraps
801064a0:	e9 b2 f6 ff ff       	jmp    80105b57 <alltraps>

801064a5 <vector126>:
.globl vector126
vector126:
  pushl $0
801064a5:	6a 00                	push   $0x0
  pushl $126
801064a7:	6a 7e                	push   $0x7e
  jmp alltraps
801064a9:	e9 a9 f6 ff ff       	jmp    80105b57 <alltraps>

801064ae <vector127>:
.globl vector127
vector127:
  pushl $0
801064ae:	6a 00                	push   $0x0
  pushl $127
801064b0:	6a 7f                	push   $0x7f
  jmp alltraps
801064b2:	e9 a0 f6 ff ff       	jmp    80105b57 <alltraps>

801064b7 <vector128>:
.globl vector128
vector128:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $128
801064b9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801064be:	e9 94 f6 ff ff       	jmp    80105b57 <alltraps>

801064c3 <vector129>:
.globl vector129
vector129:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $129
801064c5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801064ca:	e9 88 f6 ff ff       	jmp    80105b57 <alltraps>

801064cf <vector130>:
.globl vector130
vector130:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $130
801064d1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801064d6:	e9 7c f6 ff ff       	jmp    80105b57 <alltraps>

801064db <vector131>:
.globl vector131
vector131:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $131
801064dd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801064e2:	e9 70 f6 ff ff       	jmp    80105b57 <alltraps>

801064e7 <vector132>:
.globl vector132
vector132:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $132
801064e9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801064ee:	e9 64 f6 ff ff       	jmp    80105b57 <alltraps>

801064f3 <vector133>:
.globl vector133
vector133:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $133
801064f5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801064fa:	e9 58 f6 ff ff       	jmp    80105b57 <alltraps>

801064ff <vector134>:
.globl vector134
vector134:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $134
80106501:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106506:	e9 4c f6 ff ff       	jmp    80105b57 <alltraps>

8010650b <vector135>:
.globl vector135
vector135:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $135
8010650d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106512:	e9 40 f6 ff ff       	jmp    80105b57 <alltraps>

80106517 <vector136>:
.globl vector136
vector136:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $136
80106519:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010651e:	e9 34 f6 ff ff       	jmp    80105b57 <alltraps>

80106523 <vector137>:
.globl vector137
vector137:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $137
80106525:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010652a:	e9 28 f6 ff ff       	jmp    80105b57 <alltraps>

8010652f <vector138>:
.globl vector138
vector138:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $138
80106531:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106536:	e9 1c f6 ff ff       	jmp    80105b57 <alltraps>

8010653b <vector139>:
.globl vector139
vector139:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $139
8010653d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106542:	e9 10 f6 ff ff       	jmp    80105b57 <alltraps>

80106547 <vector140>:
.globl vector140
vector140:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $140
80106549:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010654e:	e9 04 f6 ff ff       	jmp    80105b57 <alltraps>

80106553 <vector141>:
.globl vector141
vector141:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $141
80106555:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010655a:	e9 f8 f5 ff ff       	jmp    80105b57 <alltraps>

8010655f <vector142>:
.globl vector142
vector142:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $142
80106561:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106566:	e9 ec f5 ff ff       	jmp    80105b57 <alltraps>

8010656b <vector143>:
.globl vector143
vector143:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $143
8010656d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106572:	e9 e0 f5 ff ff       	jmp    80105b57 <alltraps>

80106577 <vector144>:
.globl vector144
vector144:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $144
80106579:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010657e:	e9 d4 f5 ff ff       	jmp    80105b57 <alltraps>

80106583 <vector145>:
.globl vector145
vector145:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $145
80106585:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010658a:	e9 c8 f5 ff ff       	jmp    80105b57 <alltraps>

8010658f <vector146>:
.globl vector146
vector146:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $146
80106591:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106596:	e9 bc f5 ff ff       	jmp    80105b57 <alltraps>

8010659b <vector147>:
.globl vector147
vector147:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $147
8010659d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801065a2:	e9 b0 f5 ff ff       	jmp    80105b57 <alltraps>

801065a7 <vector148>:
.globl vector148
vector148:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $148
801065a9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801065ae:	e9 a4 f5 ff ff       	jmp    80105b57 <alltraps>

801065b3 <vector149>:
.globl vector149
vector149:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $149
801065b5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801065ba:	e9 98 f5 ff ff       	jmp    80105b57 <alltraps>

801065bf <vector150>:
.globl vector150
vector150:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $150
801065c1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801065c6:	e9 8c f5 ff ff       	jmp    80105b57 <alltraps>

801065cb <vector151>:
.globl vector151
vector151:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $151
801065cd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801065d2:	e9 80 f5 ff ff       	jmp    80105b57 <alltraps>

801065d7 <vector152>:
.globl vector152
vector152:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $152
801065d9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801065de:	e9 74 f5 ff ff       	jmp    80105b57 <alltraps>

801065e3 <vector153>:
.globl vector153
vector153:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $153
801065e5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801065ea:	e9 68 f5 ff ff       	jmp    80105b57 <alltraps>

801065ef <vector154>:
.globl vector154
vector154:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $154
801065f1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801065f6:	e9 5c f5 ff ff       	jmp    80105b57 <alltraps>

801065fb <vector155>:
.globl vector155
vector155:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $155
801065fd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106602:	e9 50 f5 ff ff       	jmp    80105b57 <alltraps>

80106607 <vector156>:
.globl vector156
vector156:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $156
80106609:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010660e:	e9 44 f5 ff ff       	jmp    80105b57 <alltraps>

80106613 <vector157>:
.globl vector157
vector157:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $157
80106615:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010661a:	e9 38 f5 ff ff       	jmp    80105b57 <alltraps>

8010661f <vector158>:
.globl vector158
vector158:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $158
80106621:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106626:	e9 2c f5 ff ff       	jmp    80105b57 <alltraps>

8010662b <vector159>:
.globl vector159
vector159:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $159
8010662d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106632:	e9 20 f5 ff ff       	jmp    80105b57 <alltraps>

80106637 <vector160>:
.globl vector160
vector160:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $160
80106639:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010663e:	e9 14 f5 ff ff       	jmp    80105b57 <alltraps>

80106643 <vector161>:
.globl vector161
vector161:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $161
80106645:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010664a:	e9 08 f5 ff ff       	jmp    80105b57 <alltraps>

8010664f <vector162>:
.globl vector162
vector162:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $162
80106651:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106656:	e9 fc f4 ff ff       	jmp    80105b57 <alltraps>

8010665b <vector163>:
.globl vector163
vector163:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $163
8010665d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106662:	e9 f0 f4 ff ff       	jmp    80105b57 <alltraps>

80106667 <vector164>:
.globl vector164
vector164:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $164
80106669:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010666e:	e9 e4 f4 ff ff       	jmp    80105b57 <alltraps>

80106673 <vector165>:
.globl vector165
vector165:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $165
80106675:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010667a:	e9 d8 f4 ff ff       	jmp    80105b57 <alltraps>

8010667f <vector166>:
.globl vector166
vector166:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $166
80106681:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106686:	e9 cc f4 ff ff       	jmp    80105b57 <alltraps>

8010668b <vector167>:
.globl vector167
vector167:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $167
8010668d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106692:	e9 c0 f4 ff ff       	jmp    80105b57 <alltraps>

80106697 <vector168>:
.globl vector168
vector168:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $168
80106699:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010669e:	e9 b4 f4 ff ff       	jmp    80105b57 <alltraps>

801066a3 <vector169>:
.globl vector169
vector169:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $169
801066a5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801066aa:	e9 a8 f4 ff ff       	jmp    80105b57 <alltraps>

801066af <vector170>:
.globl vector170
vector170:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $170
801066b1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801066b6:	e9 9c f4 ff ff       	jmp    80105b57 <alltraps>

801066bb <vector171>:
.globl vector171
vector171:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $171
801066bd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801066c2:	e9 90 f4 ff ff       	jmp    80105b57 <alltraps>

801066c7 <vector172>:
.globl vector172
vector172:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $172
801066c9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801066ce:	e9 84 f4 ff ff       	jmp    80105b57 <alltraps>

801066d3 <vector173>:
.globl vector173
vector173:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $173
801066d5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801066da:	e9 78 f4 ff ff       	jmp    80105b57 <alltraps>

801066df <vector174>:
.globl vector174
vector174:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $174
801066e1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801066e6:	e9 6c f4 ff ff       	jmp    80105b57 <alltraps>

801066eb <vector175>:
.globl vector175
vector175:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $175
801066ed:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801066f2:	e9 60 f4 ff ff       	jmp    80105b57 <alltraps>

801066f7 <vector176>:
.globl vector176
vector176:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $176
801066f9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801066fe:	e9 54 f4 ff ff       	jmp    80105b57 <alltraps>

80106703 <vector177>:
.globl vector177
vector177:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $177
80106705:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010670a:	e9 48 f4 ff ff       	jmp    80105b57 <alltraps>

8010670f <vector178>:
.globl vector178
vector178:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $178
80106711:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106716:	e9 3c f4 ff ff       	jmp    80105b57 <alltraps>

8010671b <vector179>:
.globl vector179
vector179:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $179
8010671d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106722:	e9 30 f4 ff ff       	jmp    80105b57 <alltraps>

80106727 <vector180>:
.globl vector180
vector180:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $180
80106729:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010672e:	e9 24 f4 ff ff       	jmp    80105b57 <alltraps>

80106733 <vector181>:
.globl vector181
vector181:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $181
80106735:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010673a:	e9 18 f4 ff ff       	jmp    80105b57 <alltraps>

8010673f <vector182>:
.globl vector182
vector182:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $182
80106741:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106746:	e9 0c f4 ff ff       	jmp    80105b57 <alltraps>

8010674b <vector183>:
.globl vector183
vector183:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $183
8010674d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106752:	e9 00 f4 ff ff       	jmp    80105b57 <alltraps>

80106757 <vector184>:
.globl vector184
vector184:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $184
80106759:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010675e:	e9 f4 f3 ff ff       	jmp    80105b57 <alltraps>

80106763 <vector185>:
.globl vector185
vector185:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $185
80106765:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010676a:	e9 e8 f3 ff ff       	jmp    80105b57 <alltraps>

8010676f <vector186>:
.globl vector186
vector186:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $186
80106771:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106776:	e9 dc f3 ff ff       	jmp    80105b57 <alltraps>

8010677b <vector187>:
.globl vector187
vector187:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $187
8010677d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106782:	e9 d0 f3 ff ff       	jmp    80105b57 <alltraps>

80106787 <vector188>:
.globl vector188
vector188:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $188
80106789:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010678e:	e9 c4 f3 ff ff       	jmp    80105b57 <alltraps>

80106793 <vector189>:
.globl vector189
vector189:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $189
80106795:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010679a:	e9 b8 f3 ff ff       	jmp    80105b57 <alltraps>

8010679f <vector190>:
.globl vector190
vector190:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $190
801067a1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801067a6:	e9 ac f3 ff ff       	jmp    80105b57 <alltraps>

801067ab <vector191>:
.globl vector191
vector191:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $191
801067ad:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801067b2:	e9 a0 f3 ff ff       	jmp    80105b57 <alltraps>

801067b7 <vector192>:
.globl vector192
vector192:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $192
801067b9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801067be:	e9 94 f3 ff ff       	jmp    80105b57 <alltraps>

801067c3 <vector193>:
.globl vector193
vector193:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $193
801067c5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801067ca:	e9 88 f3 ff ff       	jmp    80105b57 <alltraps>

801067cf <vector194>:
.globl vector194
vector194:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $194
801067d1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801067d6:	e9 7c f3 ff ff       	jmp    80105b57 <alltraps>

801067db <vector195>:
.globl vector195
vector195:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $195
801067dd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801067e2:	e9 70 f3 ff ff       	jmp    80105b57 <alltraps>

801067e7 <vector196>:
.globl vector196
vector196:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $196
801067e9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801067ee:	e9 64 f3 ff ff       	jmp    80105b57 <alltraps>

801067f3 <vector197>:
.globl vector197
vector197:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $197
801067f5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801067fa:	e9 58 f3 ff ff       	jmp    80105b57 <alltraps>

801067ff <vector198>:
.globl vector198
vector198:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $198
80106801:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106806:	e9 4c f3 ff ff       	jmp    80105b57 <alltraps>

8010680b <vector199>:
.globl vector199
vector199:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $199
8010680d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106812:	e9 40 f3 ff ff       	jmp    80105b57 <alltraps>

80106817 <vector200>:
.globl vector200
vector200:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $200
80106819:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010681e:	e9 34 f3 ff ff       	jmp    80105b57 <alltraps>

80106823 <vector201>:
.globl vector201
vector201:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $201
80106825:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010682a:	e9 28 f3 ff ff       	jmp    80105b57 <alltraps>

8010682f <vector202>:
.globl vector202
vector202:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $202
80106831:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106836:	e9 1c f3 ff ff       	jmp    80105b57 <alltraps>

8010683b <vector203>:
.globl vector203
vector203:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $203
8010683d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106842:	e9 10 f3 ff ff       	jmp    80105b57 <alltraps>

80106847 <vector204>:
.globl vector204
vector204:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $204
80106849:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010684e:	e9 04 f3 ff ff       	jmp    80105b57 <alltraps>

80106853 <vector205>:
.globl vector205
vector205:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $205
80106855:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010685a:	e9 f8 f2 ff ff       	jmp    80105b57 <alltraps>

8010685f <vector206>:
.globl vector206
vector206:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $206
80106861:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106866:	e9 ec f2 ff ff       	jmp    80105b57 <alltraps>

8010686b <vector207>:
.globl vector207
vector207:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $207
8010686d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106872:	e9 e0 f2 ff ff       	jmp    80105b57 <alltraps>

80106877 <vector208>:
.globl vector208
vector208:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $208
80106879:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010687e:	e9 d4 f2 ff ff       	jmp    80105b57 <alltraps>

80106883 <vector209>:
.globl vector209
vector209:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $209
80106885:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010688a:	e9 c8 f2 ff ff       	jmp    80105b57 <alltraps>

8010688f <vector210>:
.globl vector210
vector210:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $210
80106891:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106896:	e9 bc f2 ff ff       	jmp    80105b57 <alltraps>

8010689b <vector211>:
.globl vector211
vector211:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $211
8010689d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801068a2:	e9 b0 f2 ff ff       	jmp    80105b57 <alltraps>

801068a7 <vector212>:
.globl vector212
vector212:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $212
801068a9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801068ae:	e9 a4 f2 ff ff       	jmp    80105b57 <alltraps>

801068b3 <vector213>:
.globl vector213
vector213:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $213
801068b5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801068ba:	e9 98 f2 ff ff       	jmp    80105b57 <alltraps>

801068bf <vector214>:
.globl vector214
vector214:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $214
801068c1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801068c6:	e9 8c f2 ff ff       	jmp    80105b57 <alltraps>

801068cb <vector215>:
.globl vector215
vector215:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $215
801068cd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801068d2:	e9 80 f2 ff ff       	jmp    80105b57 <alltraps>

801068d7 <vector216>:
.globl vector216
vector216:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $216
801068d9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801068de:	e9 74 f2 ff ff       	jmp    80105b57 <alltraps>

801068e3 <vector217>:
.globl vector217
vector217:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $217
801068e5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801068ea:	e9 68 f2 ff ff       	jmp    80105b57 <alltraps>

801068ef <vector218>:
.globl vector218
vector218:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $218
801068f1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801068f6:	e9 5c f2 ff ff       	jmp    80105b57 <alltraps>

801068fb <vector219>:
.globl vector219
vector219:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $219
801068fd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106902:	e9 50 f2 ff ff       	jmp    80105b57 <alltraps>

80106907 <vector220>:
.globl vector220
vector220:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $220
80106909:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010690e:	e9 44 f2 ff ff       	jmp    80105b57 <alltraps>

80106913 <vector221>:
.globl vector221
vector221:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $221
80106915:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010691a:	e9 38 f2 ff ff       	jmp    80105b57 <alltraps>

8010691f <vector222>:
.globl vector222
vector222:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $222
80106921:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106926:	e9 2c f2 ff ff       	jmp    80105b57 <alltraps>

8010692b <vector223>:
.globl vector223
vector223:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $223
8010692d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106932:	e9 20 f2 ff ff       	jmp    80105b57 <alltraps>

80106937 <vector224>:
.globl vector224
vector224:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $224
80106939:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010693e:	e9 14 f2 ff ff       	jmp    80105b57 <alltraps>

80106943 <vector225>:
.globl vector225
vector225:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $225
80106945:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010694a:	e9 08 f2 ff ff       	jmp    80105b57 <alltraps>

8010694f <vector226>:
.globl vector226
vector226:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $226
80106951:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106956:	e9 fc f1 ff ff       	jmp    80105b57 <alltraps>

8010695b <vector227>:
.globl vector227
vector227:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $227
8010695d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106962:	e9 f0 f1 ff ff       	jmp    80105b57 <alltraps>

80106967 <vector228>:
.globl vector228
vector228:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $228
80106969:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010696e:	e9 e4 f1 ff ff       	jmp    80105b57 <alltraps>

80106973 <vector229>:
.globl vector229
vector229:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $229
80106975:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010697a:	e9 d8 f1 ff ff       	jmp    80105b57 <alltraps>

8010697f <vector230>:
.globl vector230
vector230:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $230
80106981:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106986:	e9 cc f1 ff ff       	jmp    80105b57 <alltraps>

8010698b <vector231>:
.globl vector231
vector231:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $231
8010698d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106992:	e9 c0 f1 ff ff       	jmp    80105b57 <alltraps>

80106997 <vector232>:
.globl vector232
vector232:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $232
80106999:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010699e:	e9 b4 f1 ff ff       	jmp    80105b57 <alltraps>

801069a3 <vector233>:
.globl vector233
vector233:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $233
801069a5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801069aa:	e9 a8 f1 ff ff       	jmp    80105b57 <alltraps>

801069af <vector234>:
.globl vector234
vector234:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $234
801069b1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801069b6:	e9 9c f1 ff ff       	jmp    80105b57 <alltraps>

801069bb <vector235>:
.globl vector235
vector235:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $235
801069bd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801069c2:	e9 90 f1 ff ff       	jmp    80105b57 <alltraps>

801069c7 <vector236>:
.globl vector236
vector236:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $236
801069c9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801069ce:	e9 84 f1 ff ff       	jmp    80105b57 <alltraps>

801069d3 <vector237>:
.globl vector237
vector237:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $237
801069d5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801069da:	e9 78 f1 ff ff       	jmp    80105b57 <alltraps>

801069df <vector238>:
.globl vector238
vector238:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $238
801069e1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801069e6:	e9 6c f1 ff ff       	jmp    80105b57 <alltraps>

801069eb <vector239>:
.globl vector239
vector239:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $239
801069ed:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801069f2:	e9 60 f1 ff ff       	jmp    80105b57 <alltraps>

801069f7 <vector240>:
.globl vector240
vector240:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $240
801069f9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801069fe:	e9 54 f1 ff ff       	jmp    80105b57 <alltraps>

80106a03 <vector241>:
.globl vector241
vector241:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $241
80106a05:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106a0a:	e9 48 f1 ff ff       	jmp    80105b57 <alltraps>

80106a0f <vector242>:
.globl vector242
vector242:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $242
80106a11:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106a16:	e9 3c f1 ff ff       	jmp    80105b57 <alltraps>

80106a1b <vector243>:
.globl vector243
vector243:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $243
80106a1d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a22:	e9 30 f1 ff ff       	jmp    80105b57 <alltraps>

80106a27 <vector244>:
.globl vector244
vector244:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $244
80106a29:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a2e:	e9 24 f1 ff ff       	jmp    80105b57 <alltraps>

80106a33 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $245
80106a35:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a3a:	e9 18 f1 ff ff       	jmp    80105b57 <alltraps>

80106a3f <vector246>:
.globl vector246
vector246:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $246
80106a41:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a46:	e9 0c f1 ff ff       	jmp    80105b57 <alltraps>

80106a4b <vector247>:
.globl vector247
vector247:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $247
80106a4d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a52:	e9 00 f1 ff ff       	jmp    80105b57 <alltraps>

80106a57 <vector248>:
.globl vector248
vector248:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $248
80106a59:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a5e:	e9 f4 f0 ff ff       	jmp    80105b57 <alltraps>

80106a63 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $249
80106a65:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a6a:	e9 e8 f0 ff ff       	jmp    80105b57 <alltraps>

80106a6f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $250
80106a71:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a76:	e9 dc f0 ff ff       	jmp    80105b57 <alltraps>

80106a7b <vector251>:
.globl vector251
vector251:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $251
80106a7d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106a82:	e9 d0 f0 ff ff       	jmp    80105b57 <alltraps>

80106a87 <vector252>:
.globl vector252
vector252:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $252
80106a89:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106a8e:	e9 c4 f0 ff ff       	jmp    80105b57 <alltraps>

80106a93 <vector253>:
.globl vector253
vector253:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $253
80106a95:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106a9a:	e9 b8 f0 ff ff       	jmp    80105b57 <alltraps>

80106a9f <vector254>:
.globl vector254
vector254:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $254
80106aa1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106aa6:	e9 ac f0 ff ff       	jmp    80105b57 <alltraps>

80106aab <vector255>:
.globl vector255
vector255:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $255
80106aad:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ab2:	e9 a0 f0 ff ff       	jmp    80105b57 <alltraps>
80106ab7:	66 90                	xchg   %ax,%ax
80106ab9:	66 90                	xchg   %ax,%ax
80106abb:	66 90                	xchg   %ax,%ax
80106abd:	66 90                	xchg   %ax,%ax
80106abf:	90                   	nop

80106ac0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106ac0:	55                   	push   %ebp
80106ac1:	89 e5                	mov    %esp,%ebp
80106ac3:	57                   	push   %edi
80106ac4:	56                   	push   %esi
80106ac5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106ac6:	89 d3                	mov    %edx,%ebx
{
80106ac8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106aca:	c1 eb 16             	shr    $0x16,%ebx
80106acd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106ad0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106ad3:	8b 06                	mov    (%esi),%eax
80106ad5:	a8 01                	test   $0x1,%al
80106ad7:	74 27                	je     80106b00 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ad9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ade:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106ae4:	c1 ef 0a             	shr    $0xa,%edi
}
80106ae7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106aea:	89 fa                	mov    %edi,%edx
80106aec:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106af2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106af5:	5b                   	pop    %ebx
80106af6:	5e                   	pop    %esi
80106af7:	5f                   	pop    %edi
80106af8:	5d                   	pop    %ebp
80106af9:	c3                   	ret    
80106afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106b00:	85 c9                	test   %ecx,%ecx
80106b02:	74 2c                	je     80106b30 <walkpgdir+0x70>
80106b04:	e8 d7 ba ff ff       	call   801025e0 <kalloc>
80106b09:	85 c0                	test   %eax,%eax
80106b0b:	89 c3                	mov    %eax,%ebx
80106b0d:	74 21                	je     80106b30 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106b0f:	83 ec 04             	sub    $0x4,%esp
80106b12:	68 00 10 00 00       	push   $0x1000
80106b17:	6a 00                	push   $0x0
80106b19:	50                   	push   %eax
80106b1a:	e8 f1 dc ff ff       	call   80104810 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b1f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b25:	83 c4 10             	add    $0x10,%esp
80106b28:	83 c8 07             	or     $0x7,%eax
80106b2b:	89 06                	mov    %eax,(%esi)
80106b2d:	eb b5                	jmp    80106ae4 <walkpgdir+0x24>
80106b2f:	90                   	nop
}
80106b30:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106b33:	31 c0                	xor    %eax,%eax
}
80106b35:	5b                   	pop    %ebx
80106b36:	5e                   	pop    %esi
80106b37:	5f                   	pop    %edi
80106b38:	5d                   	pop    %ebp
80106b39:	c3                   	ret    
80106b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b40 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106b40:	55                   	push   %ebp
80106b41:	89 e5                	mov    %esp,%ebp
80106b43:	57                   	push   %edi
80106b44:	56                   	push   %esi
80106b45:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106b46:	89 d3                	mov    %edx,%ebx
80106b48:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106b4e:	83 ec 1c             	sub    $0x1c,%esp
80106b51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b54:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106b58:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b60:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106b63:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b66:	29 df                	sub    %ebx,%edi
80106b68:	83 c8 01             	or     $0x1,%eax
80106b6b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b6e:	eb 15                	jmp    80106b85 <mappages+0x45>
    if(*pte & PTE_P)
80106b70:	f6 00 01             	testb  $0x1,(%eax)
80106b73:	75 45                	jne    80106bba <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106b75:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106b78:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106b7b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106b7d:	74 31                	je     80106bb0 <mappages+0x70>
      break;
    a += PGSIZE;
80106b7f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b88:	b9 01 00 00 00       	mov    $0x1,%ecx
80106b8d:	89 da                	mov    %ebx,%edx
80106b8f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106b92:	e8 29 ff ff ff       	call   80106ac0 <walkpgdir>
80106b97:	85 c0                	test   %eax,%eax
80106b99:	75 d5                	jne    80106b70 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106b9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ba3:	5b                   	pop    %ebx
80106ba4:	5e                   	pop    %esi
80106ba5:	5f                   	pop    %edi
80106ba6:	5d                   	pop    %ebp
80106ba7:	c3                   	ret    
80106ba8:	90                   	nop
80106ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106bb3:	31 c0                	xor    %eax,%eax
}
80106bb5:	5b                   	pop    %ebx
80106bb6:	5e                   	pop    %esi
80106bb7:	5f                   	pop    %edi
80106bb8:	5d                   	pop    %ebp
80106bb9:	c3                   	ret    
      panic("remap");
80106bba:	83 ec 0c             	sub    $0xc,%esp
80106bbd:	68 20 7e 10 80       	push   $0x80107e20
80106bc2:	e8 c9 97 ff ff       	call   80100390 <panic>
80106bc7:	89 f6                	mov    %esi,%esi
80106bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106bd0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bd0:	55                   	push   %ebp
80106bd1:	89 e5                	mov    %esp,%ebp
80106bd3:	57                   	push   %edi
80106bd4:	56                   	push   %esi
80106bd5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106bd6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bdc:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106bde:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106be4:	83 ec 1c             	sub    $0x1c,%esp
80106be7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106bea:	39 d3                	cmp    %edx,%ebx
80106bec:	73 66                	jae    80106c54 <deallocuvm.part.0+0x84>
80106bee:	89 d6                	mov    %edx,%esi
80106bf0:	eb 3d                	jmp    80106c2f <deallocuvm.part.0+0x5f>
80106bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106bf8:	8b 10                	mov    (%eax),%edx
80106bfa:	f6 c2 01             	test   $0x1,%dl
80106bfd:	74 26                	je     80106c25 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106bff:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106c05:	74 58                	je     80106c5f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106c07:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106c0a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106c10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106c13:	52                   	push   %edx
80106c14:	e8 17 b8 ff ff       	call   80102430 <kfree>
      *pte = 0;
80106c19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c1c:	83 c4 10             	add    $0x10,%esp
80106c1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106c25:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c2b:	39 f3                	cmp    %esi,%ebx
80106c2d:	73 25                	jae    80106c54 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106c2f:	31 c9                	xor    %ecx,%ecx
80106c31:	89 da                	mov    %ebx,%edx
80106c33:	89 f8                	mov    %edi,%eax
80106c35:	e8 86 fe ff ff       	call   80106ac0 <walkpgdir>
    if(!pte)
80106c3a:	85 c0                	test   %eax,%eax
80106c3c:	75 ba                	jne    80106bf8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c3e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106c44:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106c4a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c50:	39 f3                	cmp    %esi,%ebx
80106c52:	72 db                	jb     80106c2f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106c54:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c5a:	5b                   	pop    %ebx
80106c5b:	5e                   	pop    %esi
80106c5c:	5f                   	pop    %edi
80106c5d:	5d                   	pop    %ebp
80106c5e:	c3                   	ret    
        panic("kfree");
80106c5f:	83 ec 0c             	sub    $0xc,%esp
80106c62:	68 82 76 10 80       	push   $0x80107682
80106c67:	e8 24 97 ff ff       	call   80100390 <panic>
80106c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c70 <seginit>:
{
80106c70:	55                   	push   %ebp
80106c71:	89 e5                	mov    %esp,%ebp
80106c73:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106c76:	e8 95 cc ff ff       	call   80103910 <cpuid>
80106c7b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106c81:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106c86:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c8a:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106c91:	ff 00 00 
80106c94:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
80106c9b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c9e:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106ca5:	ff 00 00 
80106ca8:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106caf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106cb2:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106cb9:	ff 00 00 
80106cbc:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106cc3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106cc6:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106ccd:	ff 00 00 
80106cd0:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106cd7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106cda:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106cdf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ce3:	c1 e8 10             	shr    $0x10,%eax
80106ce6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106cea:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ced:	0f 01 10             	lgdtl  (%eax)
}
80106cf0:	c9                   	leave  
80106cf1:	c3                   	ret    
80106cf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d00 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d00:	a1 a4 58 11 80       	mov    0x801158a4,%eax
{
80106d05:	55                   	push   %ebp
80106d06:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d08:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d0d:	0f 22 d8             	mov    %eax,%cr3
}
80106d10:	5d                   	pop    %ebp
80106d11:	c3                   	ret    
80106d12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d20 <switchuvm>:
{
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	57                   	push   %edi
80106d24:	56                   	push   %esi
80106d25:	53                   	push   %ebx
80106d26:	83 ec 1c             	sub    $0x1c,%esp
80106d29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106d2c:	85 db                	test   %ebx,%ebx
80106d2e:	0f 84 cb 00 00 00    	je     80106dff <switchuvm+0xdf>
  if(p->kstack == 0)
80106d34:	8b 43 08             	mov    0x8(%ebx),%eax
80106d37:	85 c0                	test   %eax,%eax
80106d39:	0f 84 da 00 00 00    	je     80106e19 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106d3f:	8b 43 04             	mov    0x4(%ebx),%eax
80106d42:	85 c0                	test   %eax,%eax
80106d44:	0f 84 c2 00 00 00    	je     80106e0c <switchuvm+0xec>
  pushcli();
80106d4a:	e8 e1 d8 ff ff       	call   80104630 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d4f:	e8 3c cb ff ff       	call   80103890 <mycpu>
80106d54:	89 c6                	mov    %eax,%esi
80106d56:	e8 35 cb ff ff       	call   80103890 <mycpu>
80106d5b:	89 c7                	mov    %eax,%edi
80106d5d:	e8 2e cb ff ff       	call   80103890 <mycpu>
80106d62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d65:	83 c7 08             	add    $0x8,%edi
80106d68:	e8 23 cb ff ff       	call   80103890 <mycpu>
80106d6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d70:	83 c0 08             	add    $0x8,%eax
80106d73:	ba 67 00 00 00       	mov    $0x67,%edx
80106d78:	c1 e8 18             	shr    $0x18,%eax
80106d7b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106d82:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106d89:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d8f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d94:	83 c1 08             	add    $0x8,%ecx
80106d97:	c1 e9 10             	shr    $0x10,%ecx
80106d9a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106da0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106da5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dac:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106db1:	e8 da ca ff ff       	call   80103890 <mycpu>
80106db6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dbd:	e8 ce ca ff ff       	call   80103890 <mycpu>
80106dc2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106dc6:	8b 73 08             	mov    0x8(%ebx),%esi
80106dc9:	e8 c2 ca ff ff       	call   80103890 <mycpu>
80106dce:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106dd4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106dd7:	e8 b4 ca ff ff       	call   80103890 <mycpu>
80106ddc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106de0:	b8 28 00 00 00       	mov    $0x28,%eax
80106de5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106de8:	8b 43 04             	mov    0x4(%ebx),%eax
80106deb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106df0:	0f 22 d8             	mov    %eax,%cr3
}
80106df3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106df6:	5b                   	pop    %ebx
80106df7:	5e                   	pop    %esi
80106df8:	5f                   	pop    %edi
80106df9:	5d                   	pop    %ebp
  popcli();
80106dfa:	e9 71 d8 ff ff       	jmp    80104670 <popcli>
    panic("switchuvm: no process");
80106dff:	83 ec 0c             	sub    $0xc,%esp
80106e02:	68 26 7e 10 80       	push   $0x80107e26
80106e07:	e8 84 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106e0c:	83 ec 0c             	sub    $0xc,%esp
80106e0f:	68 51 7e 10 80       	push   $0x80107e51
80106e14:	e8 77 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106e19:	83 ec 0c             	sub    $0xc,%esp
80106e1c:	68 3c 7e 10 80       	push   $0x80107e3c
80106e21:	e8 6a 95 ff ff       	call   80100390 <panic>
80106e26:	8d 76 00             	lea    0x0(%esi),%esi
80106e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e30 <inituvm>:
{
80106e30:	55                   	push   %ebp
80106e31:	89 e5                	mov    %esp,%ebp
80106e33:	57                   	push   %edi
80106e34:	56                   	push   %esi
80106e35:	53                   	push   %ebx
80106e36:	83 ec 1c             	sub    $0x1c,%esp
80106e39:	8b 75 10             	mov    0x10(%ebp),%esi
80106e3c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e3f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106e42:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106e48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106e4b:	77 49                	ja     80106e96 <inituvm+0x66>
  mem = kalloc();
80106e4d:	e8 8e b7 ff ff       	call   801025e0 <kalloc>
  memset(mem, 0, PGSIZE);
80106e52:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106e55:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106e57:	68 00 10 00 00       	push   $0x1000
80106e5c:	6a 00                	push   $0x0
80106e5e:	50                   	push   %eax
80106e5f:	e8 ac d9 ff ff       	call   80104810 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e64:	58                   	pop    %eax
80106e65:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e6b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e70:	5a                   	pop    %edx
80106e71:	6a 06                	push   $0x6
80106e73:	50                   	push   %eax
80106e74:	31 d2                	xor    %edx,%edx
80106e76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e79:	e8 c2 fc ff ff       	call   80106b40 <mappages>
  memmove(mem, init, sz);
80106e7e:	89 75 10             	mov    %esi,0x10(%ebp)
80106e81:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106e84:	83 c4 10             	add    $0x10,%esp
80106e87:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106e8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e8d:	5b                   	pop    %ebx
80106e8e:	5e                   	pop    %esi
80106e8f:	5f                   	pop    %edi
80106e90:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106e91:	e9 2a da ff ff       	jmp    801048c0 <memmove>
    panic("inituvm: more than a page");
80106e96:	83 ec 0c             	sub    $0xc,%esp
80106e99:	68 65 7e 10 80       	push   $0x80107e65
80106e9e:	e8 ed 94 ff ff       	call   80100390 <panic>
80106ea3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106eb0 <loaduvm>:
{
80106eb0:	55                   	push   %ebp
80106eb1:	89 e5                	mov    %esp,%ebp
80106eb3:	57                   	push   %edi
80106eb4:	56                   	push   %esi
80106eb5:	53                   	push   %ebx
80106eb6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106eb9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106ec0:	0f 85 91 00 00 00    	jne    80106f57 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106ec6:	8b 75 18             	mov    0x18(%ebp),%esi
80106ec9:	31 db                	xor    %ebx,%ebx
80106ecb:	85 f6                	test   %esi,%esi
80106ecd:	75 1a                	jne    80106ee9 <loaduvm+0x39>
80106ecf:	eb 6f                	jmp    80106f40 <loaduvm+0x90>
80106ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ed8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ede:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106ee4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106ee7:	76 57                	jbe    80106f40 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ee9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106eec:	8b 45 08             	mov    0x8(%ebp),%eax
80106eef:	31 c9                	xor    %ecx,%ecx
80106ef1:	01 da                	add    %ebx,%edx
80106ef3:	e8 c8 fb ff ff       	call   80106ac0 <walkpgdir>
80106ef8:	85 c0                	test   %eax,%eax
80106efa:	74 4e                	je     80106f4a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106efc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106efe:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106f01:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106f06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106f0b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106f11:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f14:	01 d9                	add    %ebx,%ecx
80106f16:	05 00 00 00 80       	add    $0x80000000,%eax
80106f1b:	57                   	push   %edi
80106f1c:	51                   	push   %ecx
80106f1d:	50                   	push   %eax
80106f1e:	ff 75 10             	pushl  0x10(%ebp)
80106f21:	e8 4a aa ff ff       	call   80101970 <readi>
80106f26:	83 c4 10             	add    $0x10,%esp
80106f29:	39 f8                	cmp    %edi,%eax
80106f2b:	74 ab                	je     80106ed8 <loaduvm+0x28>
}
80106f2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f35:	5b                   	pop    %ebx
80106f36:	5e                   	pop    %esi
80106f37:	5f                   	pop    %edi
80106f38:	5d                   	pop    %ebp
80106f39:	c3                   	ret    
80106f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f43:	31 c0                	xor    %eax,%eax
}
80106f45:	5b                   	pop    %ebx
80106f46:	5e                   	pop    %esi
80106f47:	5f                   	pop    %edi
80106f48:	5d                   	pop    %ebp
80106f49:	c3                   	ret    
      panic("loaduvm: address should exist");
80106f4a:	83 ec 0c             	sub    $0xc,%esp
80106f4d:	68 7f 7e 10 80       	push   $0x80107e7f
80106f52:	e8 39 94 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106f57:	83 ec 0c             	sub    $0xc,%esp
80106f5a:	68 20 7f 10 80       	push   $0x80107f20
80106f5f:	e8 2c 94 ff ff       	call   80100390 <panic>
80106f64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f70 <allocuvm>:
{
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	57                   	push   %edi
80106f74:	56                   	push   %esi
80106f75:	53                   	push   %ebx
80106f76:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106f79:	8b 7d 10             	mov    0x10(%ebp),%edi
80106f7c:	85 ff                	test   %edi,%edi
80106f7e:	0f 88 8e 00 00 00    	js     80107012 <allocuvm+0xa2>
  if(newsz < oldsz)
80106f84:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106f87:	0f 82 93 00 00 00    	jb     80107020 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80106f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f90:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106f96:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106f9c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106f9f:	0f 86 7e 00 00 00    	jbe    80107023 <allocuvm+0xb3>
80106fa5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106fa8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106fab:	eb 42                	jmp    80106fef <allocuvm+0x7f>
80106fad:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106fb0:	83 ec 04             	sub    $0x4,%esp
80106fb3:	68 00 10 00 00       	push   $0x1000
80106fb8:	6a 00                	push   $0x0
80106fba:	50                   	push   %eax
80106fbb:	e8 50 d8 ff ff       	call   80104810 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106fc0:	58                   	pop    %eax
80106fc1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106fc7:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fcc:	5a                   	pop    %edx
80106fcd:	6a 06                	push   $0x6
80106fcf:	50                   	push   %eax
80106fd0:	89 da                	mov    %ebx,%edx
80106fd2:	89 f8                	mov    %edi,%eax
80106fd4:	e8 67 fb ff ff       	call   80106b40 <mappages>
80106fd9:	83 c4 10             	add    $0x10,%esp
80106fdc:	85 c0                	test   %eax,%eax
80106fde:	78 50                	js     80107030 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80106fe0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fe6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106fe9:	0f 86 81 00 00 00    	jbe    80107070 <allocuvm+0x100>
    mem = kalloc();
80106fef:	e8 ec b5 ff ff       	call   801025e0 <kalloc>
    if(mem == 0){
80106ff4:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106ff6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106ff8:	75 b6                	jne    80106fb0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106ffa:	83 ec 0c             	sub    $0xc,%esp
80106ffd:	68 9d 7e 10 80       	push   $0x80107e9d
80107002:	e8 59 96 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107007:	83 c4 10             	add    $0x10,%esp
8010700a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010700d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107010:	77 6e                	ja     80107080 <allocuvm+0x110>
}
80107012:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107015:	31 ff                	xor    %edi,%edi
}
80107017:	89 f8                	mov    %edi,%eax
80107019:	5b                   	pop    %ebx
8010701a:	5e                   	pop    %esi
8010701b:	5f                   	pop    %edi
8010701c:	5d                   	pop    %ebp
8010701d:	c3                   	ret    
8010701e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107020:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107023:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107026:	89 f8                	mov    %edi,%eax
80107028:	5b                   	pop    %ebx
80107029:	5e                   	pop    %esi
8010702a:	5f                   	pop    %edi
8010702b:	5d                   	pop    %ebp
8010702c:	c3                   	ret    
8010702d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107030:	83 ec 0c             	sub    $0xc,%esp
80107033:	68 b5 7e 10 80       	push   $0x80107eb5
80107038:	e8 23 96 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010703d:	83 c4 10             	add    $0x10,%esp
80107040:	8b 45 0c             	mov    0xc(%ebp),%eax
80107043:	39 45 10             	cmp    %eax,0x10(%ebp)
80107046:	76 0d                	jbe    80107055 <allocuvm+0xe5>
80107048:	89 c1                	mov    %eax,%ecx
8010704a:	8b 55 10             	mov    0x10(%ebp),%edx
8010704d:	8b 45 08             	mov    0x8(%ebp),%eax
80107050:	e8 7b fb ff ff       	call   80106bd0 <deallocuvm.part.0>
      kfree(mem);
80107055:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107058:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010705a:	56                   	push   %esi
8010705b:	e8 d0 b3 ff ff       	call   80102430 <kfree>
      return 0;
80107060:	83 c4 10             	add    $0x10,%esp
}
80107063:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107066:	89 f8                	mov    %edi,%eax
80107068:	5b                   	pop    %ebx
80107069:	5e                   	pop    %esi
8010706a:	5f                   	pop    %edi
8010706b:	5d                   	pop    %ebp
8010706c:	c3                   	ret    
8010706d:	8d 76 00             	lea    0x0(%esi),%esi
80107070:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107073:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107076:	5b                   	pop    %ebx
80107077:	89 f8                	mov    %edi,%eax
80107079:	5e                   	pop    %esi
8010707a:	5f                   	pop    %edi
8010707b:	5d                   	pop    %ebp
8010707c:	c3                   	ret    
8010707d:	8d 76 00             	lea    0x0(%esi),%esi
80107080:	89 c1                	mov    %eax,%ecx
80107082:	8b 55 10             	mov    0x10(%ebp),%edx
80107085:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107088:	31 ff                	xor    %edi,%edi
8010708a:	e8 41 fb ff ff       	call   80106bd0 <deallocuvm.part.0>
8010708f:	eb 92                	jmp    80107023 <allocuvm+0xb3>
80107091:	eb 0d                	jmp    801070a0 <deallocuvm>
80107093:	90                   	nop
80107094:	90                   	nop
80107095:	90                   	nop
80107096:	90                   	nop
80107097:	90                   	nop
80107098:	90                   	nop
80107099:	90                   	nop
8010709a:	90                   	nop
8010709b:	90                   	nop
8010709c:	90                   	nop
8010709d:	90                   	nop
8010709e:	90                   	nop
8010709f:	90                   	nop

801070a0 <deallocuvm>:
{
801070a0:	55                   	push   %ebp
801070a1:	89 e5                	mov    %esp,%ebp
801070a3:	8b 55 0c             	mov    0xc(%ebp),%edx
801070a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801070a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801070ac:	39 d1                	cmp    %edx,%ecx
801070ae:	73 10                	jae    801070c0 <deallocuvm+0x20>
}
801070b0:	5d                   	pop    %ebp
801070b1:	e9 1a fb ff ff       	jmp    80106bd0 <deallocuvm.part.0>
801070b6:	8d 76 00             	lea    0x0(%esi),%esi
801070b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801070c0:	89 d0                	mov    %edx,%eax
801070c2:	5d                   	pop    %ebp
801070c3:	c3                   	ret    
801070c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801070d0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	57                   	push   %edi
801070d4:	56                   	push   %esi
801070d5:	53                   	push   %ebx
801070d6:	83 ec 0c             	sub    $0xc,%esp
801070d9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801070dc:	85 f6                	test   %esi,%esi
801070de:	74 59                	je     80107139 <freevm+0x69>
801070e0:	31 c9                	xor    %ecx,%ecx
801070e2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801070e7:	89 f0                	mov    %esi,%eax
801070e9:	e8 e2 fa ff ff       	call   80106bd0 <deallocuvm.part.0>
801070ee:	89 f3                	mov    %esi,%ebx
801070f0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801070f6:	eb 0f                	jmp    80107107 <freevm+0x37>
801070f8:	90                   	nop
801070f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107100:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107103:	39 fb                	cmp    %edi,%ebx
80107105:	74 23                	je     8010712a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107107:	8b 03                	mov    (%ebx),%eax
80107109:	a8 01                	test   $0x1,%al
8010710b:	74 f3                	je     80107100 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010710d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107112:	83 ec 0c             	sub    $0xc,%esp
80107115:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107118:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010711d:	50                   	push   %eax
8010711e:	e8 0d b3 ff ff       	call   80102430 <kfree>
80107123:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107126:	39 fb                	cmp    %edi,%ebx
80107128:	75 dd                	jne    80107107 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010712a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010712d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107130:	5b                   	pop    %ebx
80107131:	5e                   	pop    %esi
80107132:	5f                   	pop    %edi
80107133:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107134:	e9 f7 b2 ff ff       	jmp    80102430 <kfree>
    panic("freevm: no pgdir");
80107139:	83 ec 0c             	sub    $0xc,%esp
8010713c:	68 d1 7e 10 80       	push   $0x80107ed1
80107141:	e8 4a 92 ff ff       	call   80100390 <panic>
80107146:	8d 76 00             	lea    0x0(%esi),%esi
80107149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107150 <setupkvm>:
{
80107150:	55                   	push   %ebp
80107151:	89 e5                	mov    %esp,%ebp
80107153:	56                   	push   %esi
80107154:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107155:	e8 86 b4 ff ff       	call   801025e0 <kalloc>
8010715a:	85 c0                	test   %eax,%eax
8010715c:	89 c6                	mov    %eax,%esi
8010715e:	74 42                	je     801071a2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107160:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107163:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107168:	68 00 10 00 00       	push   $0x1000
8010716d:	6a 00                	push   $0x0
8010716f:	50                   	push   %eax
80107170:	e8 9b d6 ff ff       	call   80104810 <memset>
80107175:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107178:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010717b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010717e:	83 ec 08             	sub    $0x8,%esp
80107181:	8b 13                	mov    (%ebx),%edx
80107183:	ff 73 0c             	pushl  0xc(%ebx)
80107186:	50                   	push   %eax
80107187:	29 c1                	sub    %eax,%ecx
80107189:	89 f0                	mov    %esi,%eax
8010718b:	e8 b0 f9 ff ff       	call   80106b40 <mappages>
80107190:	83 c4 10             	add    $0x10,%esp
80107193:	85 c0                	test   %eax,%eax
80107195:	78 19                	js     801071b0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107197:	83 c3 10             	add    $0x10,%ebx
8010719a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801071a0:	75 d6                	jne    80107178 <setupkvm+0x28>
}
801071a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071a5:	89 f0                	mov    %esi,%eax
801071a7:	5b                   	pop    %ebx
801071a8:	5e                   	pop    %esi
801071a9:	5d                   	pop    %ebp
801071aa:	c3                   	ret    
801071ab:	90                   	nop
801071ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801071b0:	83 ec 0c             	sub    $0xc,%esp
801071b3:	56                   	push   %esi
      return 0;
801071b4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801071b6:	e8 15 ff ff ff       	call   801070d0 <freevm>
      return 0;
801071bb:	83 c4 10             	add    $0x10,%esp
}
801071be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071c1:	89 f0                	mov    %esi,%eax
801071c3:	5b                   	pop    %ebx
801071c4:	5e                   	pop    %esi
801071c5:	5d                   	pop    %ebp
801071c6:	c3                   	ret    
801071c7:	89 f6                	mov    %esi,%esi
801071c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071d0 <kvmalloc>:
{
801071d0:	55                   	push   %ebp
801071d1:	89 e5                	mov    %esp,%ebp
801071d3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801071d6:	e8 75 ff ff ff       	call   80107150 <setupkvm>
801071db:	a3 a4 58 11 80       	mov    %eax,0x801158a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801071e0:	05 00 00 00 80       	add    $0x80000000,%eax
801071e5:	0f 22 d8             	mov    %eax,%cr3
}
801071e8:	c9                   	leave  
801071e9:	c3                   	ret    
801071ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071f0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801071f0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801071f1:	31 c9                	xor    %ecx,%ecx
{
801071f3:	89 e5                	mov    %esp,%ebp
801071f5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801071f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801071fb:	8b 45 08             	mov    0x8(%ebp),%eax
801071fe:	e8 bd f8 ff ff       	call   80106ac0 <walkpgdir>
  if(pte == 0)
80107203:	85 c0                	test   %eax,%eax
80107205:	74 05                	je     8010720c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107207:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010720a:	c9                   	leave  
8010720b:	c3                   	ret    
    panic("clearpteu");
8010720c:	83 ec 0c             	sub    $0xc,%esp
8010720f:	68 e2 7e 10 80       	push   $0x80107ee2
80107214:	e8 77 91 ff ff       	call   80100390 <panic>
80107219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107220 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107220:	55                   	push   %ebp
80107221:	89 e5                	mov    %esp,%ebp
80107223:	57                   	push   %edi
80107224:	56                   	push   %esi
80107225:	53                   	push   %ebx
80107226:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107229:	e8 22 ff ff ff       	call   80107150 <setupkvm>
8010722e:	85 c0                	test   %eax,%eax
80107230:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107233:	0f 84 9f 00 00 00    	je     801072d8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107239:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010723c:	85 c9                	test   %ecx,%ecx
8010723e:	0f 84 94 00 00 00    	je     801072d8 <copyuvm+0xb8>
80107244:	31 ff                	xor    %edi,%edi
80107246:	eb 4a                	jmp    80107292 <copyuvm+0x72>
80107248:	90                   	nop
80107249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107250:	83 ec 04             	sub    $0x4,%esp
80107253:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107259:	68 00 10 00 00       	push   $0x1000
8010725e:	53                   	push   %ebx
8010725f:	50                   	push   %eax
80107260:	e8 5b d6 ff ff       	call   801048c0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107265:	58                   	pop    %eax
80107266:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010726c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107271:	5a                   	pop    %edx
80107272:	ff 75 e4             	pushl  -0x1c(%ebp)
80107275:	50                   	push   %eax
80107276:	89 fa                	mov    %edi,%edx
80107278:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010727b:	e8 c0 f8 ff ff       	call   80106b40 <mappages>
80107280:	83 c4 10             	add    $0x10,%esp
80107283:	85 c0                	test   %eax,%eax
80107285:	78 61                	js     801072e8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107287:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010728d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107290:	76 46                	jbe    801072d8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107292:	8b 45 08             	mov    0x8(%ebp),%eax
80107295:	31 c9                	xor    %ecx,%ecx
80107297:	89 fa                	mov    %edi,%edx
80107299:	e8 22 f8 ff ff       	call   80106ac0 <walkpgdir>
8010729e:	85 c0                	test   %eax,%eax
801072a0:	74 61                	je     80107303 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801072a2:	8b 00                	mov    (%eax),%eax
801072a4:	a8 01                	test   $0x1,%al
801072a6:	74 4e                	je     801072f6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801072a8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801072aa:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
801072af:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801072b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801072b8:	e8 23 b3 ff ff       	call   801025e0 <kalloc>
801072bd:	85 c0                	test   %eax,%eax
801072bf:	89 c6                	mov    %eax,%esi
801072c1:	75 8d                	jne    80107250 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801072c3:	83 ec 0c             	sub    $0xc,%esp
801072c6:	ff 75 e0             	pushl  -0x20(%ebp)
801072c9:	e8 02 fe ff ff       	call   801070d0 <freevm>
  return 0;
801072ce:	83 c4 10             	add    $0x10,%esp
801072d1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801072d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072de:	5b                   	pop    %ebx
801072df:	5e                   	pop    %esi
801072e0:	5f                   	pop    %edi
801072e1:	5d                   	pop    %ebp
801072e2:	c3                   	ret    
801072e3:	90                   	nop
801072e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801072e8:	83 ec 0c             	sub    $0xc,%esp
801072eb:	56                   	push   %esi
801072ec:	e8 3f b1 ff ff       	call   80102430 <kfree>
      goto bad;
801072f1:	83 c4 10             	add    $0x10,%esp
801072f4:	eb cd                	jmp    801072c3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801072f6:	83 ec 0c             	sub    $0xc,%esp
801072f9:	68 06 7f 10 80       	push   $0x80107f06
801072fe:	e8 8d 90 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107303:	83 ec 0c             	sub    $0xc,%esp
80107306:	68 ec 7e 10 80       	push   $0x80107eec
8010730b:	e8 80 90 ff ff       	call   80100390 <panic>

80107310 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107310:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107311:	31 c9                	xor    %ecx,%ecx
{
80107313:	89 e5                	mov    %esp,%ebp
80107315:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107318:	8b 55 0c             	mov    0xc(%ebp),%edx
8010731b:	8b 45 08             	mov    0x8(%ebp),%eax
8010731e:	e8 9d f7 ff ff       	call   80106ac0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107323:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107325:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107326:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107328:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010732d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107330:	05 00 00 00 80       	add    $0x80000000,%eax
80107335:	83 fa 05             	cmp    $0x5,%edx
80107338:	ba 00 00 00 00       	mov    $0x0,%edx
8010733d:	0f 45 c2             	cmovne %edx,%eax
}
80107340:	c3                   	ret    
80107341:	eb 0d                	jmp    80107350 <copyout>
80107343:	90                   	nop
80107344:	90                   	nop
80107345:	90                   	nop
80107346:	90                   	nop
80107347:	90                   	nop
80107348:	90                   	nop
80107349:	90                   	nop
8010734a:	90                   	nop
8010734b:	90                   	nop
8010734c:	90                   	nop
8010734d:	90                   	nop
8010734e:	90                   	nop
8010734f:	90                   	nop

80107350 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107350:	55                   	push   %ebp
80107351:	89 e5                	mov    %esp,%ebp
80107353:	57                   	push   %edi
80107354:	56                   	push   %esi
80107355:	53                   	push   %ebx
80107356:	83 ec 1c             	sub    $0x1c,%esp
80107359:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010735c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010735f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107362:	85 db                	test   %ebx,%ebx
80107364:	75 40                	jne    801073a6 <copyout+0x56>
80107366:	eb 70                	jmp    801073d8 <copyout+0x88>
80107368:	90                   	nop
80107369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107370:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107373:	89 f1                	mov    %esi,%ecx
80107375:	29 d1                	sub    %edx,%ecx
80107377:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010737d:	39 d9                	cmp    %ebx,%ecx
8010737f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107382:	29 f2                	sub    %esi,%edx
80107384:	83 ec 04             	sub    $0x4,%esp
80107387:	01 d0                	add    %edx,%eax
80107389:	51                   	push   %ecx
8010738a:	57                   	push   %edi
8010738b:	50                   	push   %eax
8010738c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010738f:	e8 2c d5 ff ff       	call   801048c0 <memmove>
    len -= n;
    buf += n;
80107394:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107397:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010739a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801073a0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801073a2:	29 cb                	sub    %ecx,%ebx
801073a4:	74 32                	je     801073d8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801073a6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801073a8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801073ab:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801073ae:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801073b4:	56                   	push   %esi
801073b5:	ff 75 08             	pushl  0x8(%ebp)
801073b8:	e8 53 ff ff ff       	call   80107310 <uva2ka>
    if(pa0 == 0)
801073bd:	83 c4 10             	add    $0x10,%esp
801073c0:	85 c0                	test   %eax,%eax
801073c2:	75 ac                	jne    80107370 <copyout+0x20>
  }
  return 0;
}
801073c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801073c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073cc:	5b                   	pop    %ebx
801073cd:	5e                   	pop    %esi
801073ce:	5f                   	pop    %edi
801073cf:	5d                   	pop    %ebp
801073d0:	c3                   	ret    
801073d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801073db:	31 c0                	xor    %eax,%eax
}
801073dd:	5b                   	pop    %ebx
801073de:	5e                   	pop    %esi
801073df:	5f                   	pop    %edi
801073e0:	5d                   	pop    %ebp
801073e1:	c3                   	ret    
