#undef FILLBLOCK
#undef TRACE

#include <string.h>
#include <stdarg.h>
#include "Storage.h"
#include "UTIS.h"

#define ALIGN(A,X)  (((X)+(A)-1)&~((A)-1))
#define MEM(X)      ((*(unsigned*)(X)))
#define ADR(X)      ((unsigned)&(X))
#define TAG(X)      (MEM((X)-4)&~1)
#define FREESIZE(X) ((TAG(X)==ADR(PRE(B8$D)))? 8 : MEM((X)+4))
#define ISMARKED(X) (MEM((X)-4)%2 > 0)

static unsigned InitialHeapSize = 2*1024*1024, PRE(HeapStart), PRE(HeapEnd);
static unsigned PRE(root_ebp);

#define SAVE_ROOT_EBP()    { char got_ebp;                           \
                             if (got_ebp = (PRE(root_ebp)==0))            \
                                asm("pushl (%ebp); popl _root_ebp"); 

#define RESTORE_ROOT_EBP()   if (got_ebp) PRE(root_ebp) = 0;              \
                           }

void PRE(DumpStr)(char *str); 
void PRE(DumpLn)(); 
extern void PRE(Halt)(int); 

/*****************************************************************************/
static void DefaultAllocFailHandler(unsigned size, unsigned nofAttempts){
   if (nofAttempts==0){
      PRE(GC)(); 
   }else{
      if (!IncreaseHeap(size+InitialHeapSize)){
         OStr("Storage.DefaultAllocFailHandler: Unable to increase heap"); OLn();
         PRE(Halt)(1); 
      } /* if */                  
   } /* if */
} /* DefaultAllocFailHandler */

static tAllocFailHandler PRE(AllocFailHandlerProc) = DefaultAllocFailHandler;

/*---------------------------------------------------------------------------*/
tAllocFailHandler PRE(SetAllocFailHandler)(tAllocFailHandler proc){
   tAllocFailHandler old = PRE(AllocFailHandlerProc);
   
   PRE(AllocFailHandlerProc) = proc; 
   return old; 
} /* SetAllocFailHandler */

/*****************************************************************************/
typedef struct{
   unsigned elemSize;
   char     *name;
   int      size;
   void     *skipper;
   void     *walker;
} tBlockDesc;
typedef tBlockDesc *tTag;

#define BDESC(X)           ((tTag)(TAG(X)-sizeof(tBlockDesc)+4))
#define BLOCKNAME(X)       (BDESC(X)->name)
#define TYPESIZE(X)        (BDESC(X)->size)
#define ODIM(X)            (-(BDESC(X)->size))
#define NOFELEMS(X)        (MEM(X))
#define ELEMSIZE(X)        (BDESC(X)->elemSize)
#define LEN(X,I)           (MEM((X)+4*((ODIM(X)>1)+(I))))

#define SYSTEMBLOCKSIZE(X) (MEM(TAG(X)))
#define STATICBLOCKSIZE(X) ALIGN(8,4+TYPESIZE(block))
#define OPENBLOCKSIZE(X)   ALIGN(8,4                               \
                                  +4*((ODIM(block)>1)+ODIM(block)) \
                                  +NOFELEMS(block)*ELEMSIZE(block))

/*---------------------------------------------------------------------------*/
static void AnchorBlockFrame(){ asm("\n\
\n\
# Desc for AnchorBlock\n\
_AB$N:  .asciz	\"anchor\"\n\
\n\
	.align	2\n\
	.long	_AB$N		# -12 name\n\
	.long	0		# -8  size\n\
	.long	_NILPROC	# -4  skipper\n\
_AB$D:				#     walker\n\
\n\
"); } extern void *PRE(AB$D);

/*---------------------------------------------------------------------------*/
static void FreeBlockFrame(){ asm("\n\
\n\
# Desc for FreeBlock\n\
_FB$N:  .asciz	\"free\"\n\
\n\
	.align	2,144\n\
_FB$S:  addl	4(%ebx),%ebx\n\
	jmp	%esi\n\
\n\
	.align	2\n\
	.long	_FB$N	# -12 name\n\
	.long	0	# -8  size\n\
	.long	_FB$S	# -4  skipper\n\
_FB$D:			#     walker\n\
\n\
"); } extern void *PRE(FB$D);

/*---------------------------------------------------------------------------*/
static void SmallBlockFrame(){ asm("\n\
\n\
# Desc for SmallBlock\n\
_B8$N:	.asciz	\"small\"\n\
\n\
	.align	2,144\n\
_B8$S:  addl	$8,%ebx\n\
	jmp	%esi\n\
\n\
	.align	2\n\
	.long	_B8$N	# -12 name\n\
	.long	0	# -8  size\n\
	.long	_B8$S	# -4  skipper\n\
_B8$D:			#     walker\n\
\n\
"); } extern void *PRE(B8$D);

/*---------------------------------------------------------------------------*/
static void SentinelBlockFrame(){ asm("\n\
\n\
# Desc for SentinelBlock\n\
_ZB$N:	.asciz	\"sentinel\"\n\
\n\
	.align	2,144\n\
_ZB$S:  ret\n\
\n\
	.align	2\n\
	.long	_ZB$N	# -12 name\n\
	.long	0	# -8  size\n\
	.long	_ZB$S	# -4  skipper\n\
_ZB$D:			#     walker\n\
\n\
"); } extern void *PRE(ZB$D);

/*---------------------------------------------------------------------------*/
static void SystemBlockSkipperFrame(){ asm("\n\
\n\
# Skipper for SystemBlock\n\
	.align	2,144\n\
_SB$S:	movl	-4(%ebx),%eax\n\
	andb	$0xFE,%al\n\
	addl	(%eax),%ebx\n\
        jmp	%esi\n\
\n\
"); } extern void *PRE(SB$S);

/*****************************************************************************/
#define DOMAX(X,Y) if ((Y)>(X)) (X)=(Y)

unsigned AddrLen, SizeLen, MaxSize,i,ptr;

/*---------------------------------------------------------------------------*/
void GetLens(){
   char buf[50];
   
   Int2Dez(PRE(HeapEnd),buf,sizeof(buf)); AddrLen = strlen(buf); 
   Int2Dez(MaxSize,buf,sizeof(buf)); SizeLen = strlen(buf); 
} /* GetLens */

/*---------------------------------------------------------------------------*/
static void DumpBlocks(unsigned block){
   if (TAG(block) == ADR(PRE(ZB$D))){
      GetLens(); 
      
      ONum(block,AddrLen); 
      OStr(ISMARKED(block)?"*":" "); 
      OStL(BLOCKNAME(block),8);
      OStr(" "); 
      OIntR(8,SizeLen);
      OStr(" >"); 
      ONum(MEM(block),AddrLen); 
      OLn();

   }else if (TAG(block) == ADR(PRE(AB$D))){
      DOMAX(MaxSize,8);
      DumpBlocks(block+8); 

      ONum(block,AddrLen); 
      OStr(ISMARKED(block)?"*":" "); 
      OStL(BLOCKNAME(block),8);
      OStr(" "); 
      OIntR(8,SizeLen);
      OStr(" >"); 
      ONum(MEM(block),AddrLen); 
      OLn();

   }else if (TAG(block) == ADR(PRE(FB$D))){
      DOMAX(MaxSize,FREESIZE(block));
      DumpBlocks(block+FREESIZE(block)); 

      ONum(block,AddrLen); 
      OStr(ISMARKED(block)?"*":" "); 
      OStL(BLOCKNAME(block),8);
      OStr(" "); 
      OIntR(FREESIZE(block),SizeLen);
      OStr(" >"); 
      ONum(MEM(block),AddrLen); 
      OLn();

   }else if (TAG(block) == ADR(PRE(B8$D))){
      DOMAX(MaxSize,8);
      DumpBlocks(block+8); 

      ONum(block,AddrLen); 
      OStr(ISMARKED(block)?"*":" "); 
      OStL(BLOCKNAME(block),8);
      OStr(" "); 
      OIntR(8,SizeLen);
      OStr(" >"); 
      ONum(MEM(block),AddrLen); 
      OLn();
   
   }else if (PRE(HeapStart)<=TAG(block) && TAG(block)<=PRE(HeapEnd)){
      DOMAX(MaxSize,SYSTEMBLOCKSIZE(block));
      DumpBlocks(block+SYSTEMBLOCKSIZE(block)); 

      ONum(block,AddrLen); 
      OStr(ISMARKED(block)?"*":" "); 
      OStL("system",8);
      OStr(" "); 
      OIntR(SYSTEMBLOCKSIZE(block),SizeLen);
      OLn();
   
   }else if (TYPESIZE(block) >= 0){
      DOMAX(MaxSize,STATICBLOCKSIZE(block));
      DumpBlocks(block+STATICBLOCKSIZE(block)); 

      ONum(block,AddrLen); 
      OStr(ISMARKED(block)?"*":" "); 
      OStL("static",8);
      OStr(" "); 
      OIntR(STATICBLOCKSIZE(block),SizeLen);
      OStr(" T="); 
      OStr(BLOCKNAME(block)); 
      OStr(" size="); 
      OInt(TYPESIZE(block)); 
      OStr(" tag="); 
      OInt(MEM(block-4)); 
      OLn();
   
   }else if (TYPESIZE(block) < 0){
      DOMAX(MaxSize,OPENBLOCKSIZE(block));
      DumpBlocks(block+OPENBLOCKSIZE(block));

      ONum(block,AddrLen); 
      OStr(ISMARKED(block)?"*":" "); 
      OStL("open",8);
      OStr(" "); 
      OIntR(OPENBLOCKSIZE(block),SizeLen);
      OStr(" T="); 
      OStr(BLOCKNAME(block)); 
      OStr(" elemSize="); 
      OInt(ELEMSIZE(block)); 
      OStr(" odim="); 
      OInt(ODIM(block)); 
      OStr(" nofElems="); 
      OInt(NOFELEMS(block)); 
      OStr(" LENs="); 
   
      OInt(LEN(block,0)); 
      for (i=1; i<ODIM(block); i++){
         OStr(","); OInt(LEN(block,i)); 
      } /* for */
      OLn();
   }else{
      GetLens(); 
      
      OStrLn("...");
      ONum(block,AddrLen); 
      OLn(); 
   } /* if */
} /* DumpBlocks */

/*---------------------------------------------------------------------------*/
void PRE(DumpHeap)(){
   MaxSize = 0; 
   
   DumpBlocks(PRE(HeapStart)+4); 
} /* DumpHeap */

/*****************************************************************************/
void *tHeapInfo$D = 0; 

/*---------------------------------------------------------------------------*/
void PRE(GetInfo)(void *inf$D, tHeapInfo *inf){
   unsigned block, blocksize; 

   inf->Start          = PRE(HeapStart); 
   inf->End            = PRE(HeapEnd); 
   inf->TotalBytes     = PRE(HeapEnd)-PRE(HeapStart)-12; 
   inf->TotalFreeBytes = 0; 
   inf->MaxFreeBytes   = 0; 
   inf->NofFreeBlocks  = 0; 

   block = MEM(PRE(HeapStart)+4);
   while (block != PRE(HeapEnd)){
      blocksize = FREESIZE(block); 

      inf->TotalFreeBytes += blocksize;
      if (blocksize > inf->MaxFreeBytes) inf->MaxFreeBytes = blocksize; 
      inf->NofFreeBlocks++;
      
      block = MEM(block); 
   } /* while */
} /* GetInfo */

/*****************************************************************************/
void AllocFail(unsigned size, unsigned nofAttempts){ asm("\n\
\n\
	pushl	%eax\n\
	pushl	%ebx\n\
	pushl	%ecx\n\
	pushl	%edx\n\
	pushl	%esi\n\
	pushl	%edi\n\
        \n\
	pushl	12(%ebp)\n\
	pushl	8(%ebp)\n\
        movl	_AllocFailHandlerProc,%eax\n\
	call	%eax\n\
	addl	$8,%esp\n\
\n\
	popl	%edi\n\
	popl	%esi\n\
	popl	%edx\n\
	popl	%ecx\n\
	popl	%ebx\n\
	popl	%eax\n\
        \n\
"); } /* AllocFail */

/*****************************************************************************/
static unsigned AllocAligned(unsigned size){
   unsigned prv,act,new,blocksize,nofAttempts=0;

   while (1){
      prv = PRE(HeapStart)+4, act = MEM(prv), new, blocksize;
      while (act != PRE(HeapEnd)){
         blocksize = FREESIZE(act);
   
         if (size<=blocksize){
            if (size==blocksize){
               MEM(prv) = MEM(act); 
            }else{
               new = act+size; 
               MEM(prv) = new; 
               blocksize -= size;
               if (blocksize==8){
                  MEM(new-4) = ADR(PRE(B8$D)); 
                  MEM(new  ) = MEM(act); 
               }else{
                  MEM(new-4) = ADR(PRE(FB$D)); 
                  MEM(new  ) = MEM(act); 
                  MEM(new+4) = blocksize; 
               } /* if */
            } /* if */
   
#ifdef FILLBLOCK
            {  char *p = (char*)(act-4); 
               int  n  = size;
               while (n--) *p++ = 0xFF; 
            }
#endif
            return act; 
         } /* if */
         prv = act; act = MEM(act); 
      } /* while */

      AllocFail(size,nofAttempts); 
      nofAttempts++;
   } /* while */
} /* AllocAligned */

/*****************************************************************************/
unsigned PRE(Alloc)(unsigned size){
   unsigned block; 

   SAVE_ROOT_EBP(); 

   block = AllocAligned(ALIGN(8,size)); 

   RESTORE_ROOT_EBP(); 

   return block; 
} /* Alloc */

/*****************************************************************************/
void PRE(Free)(unsigned adr, unsigned size){
   unsigned prv = PRE(HeapStart)+4, act = MEM(prv), nxt, blocksize;

   if (adr<PRE(HeapStart)+12 || PRE(HeapEnd)-16<adr || adr%8!=0){
      OStrLn("Storage.Free: corrupt pointer"); PRE(Halt)(1); 
   } /* if */

   size = ALIGN(8,size); 
   if (adr<act){
      nxt = act; MEM(prv) = adr; act = adr; blocksize = size; 
   }else{
      while (act != 0){
         nxt = MEM(act); 
         if (nxt>adr){
   
            /* merge freed block with previous free block? */
            blocksize = FREESIZE(act); 
            if (act+blocksize == adr){
               blocksize += size;
            }else{
               MEM(act) = adr; act = adr; blocksize = size; 
            } /* if */
   
            break; 
         } /* if */
         prv = act; act = nxt; 
      } /* while */
   } /* if (adr==PRE(HeapStart)+12) */
   
   /* merge freed block with next free block? */
   if (nxt != PRE(HeapEnd) && act+blocksize == nxt){
      blocksize += FREESIZE(nxt); nxt = MEM(nxt); 
   } /* if */                                   
   
   if (blocksize == 8){
      MEM(act-4) = ADR(PRE(B8$D)); 
      MEM(act  ) = nxt; 
   }else{
      MEM(act-4) = ADR(PRE(FB$D)); 
      MEM(act  ) = nxt; 
      MEM(act+4) = blocksize; 
   } /* if */
   
#ifdef TRACE
   OStr("Free(");
   ONum(adr,10);
   OStr(",");
   OInt(size); 
   OStrLn(")");
#endif
} /* Free */

/*****************************************************************************/
static void DumpAllocBlock(unsigned block, unsigned blocksize){
   unsigned i;

   i = block+blocksize; 
   ONum(i,10); OStr(": "); OHex(MEM(i)); OStr(" = "); ONum(MEM(i),10); OLn(); i-=4;
   ONum(i,10); OStr(": "); OHex(MEM(i)); OStr(" = "); ONum(MEM(i),10); OLn(); i-=4;
   OStrLn("----------:----------|-----------"); 
   while (i>=block-4){
      ONum(i,10); OStr(": "); OHex(MEM(i)); OStr(" = "); ONum(MEM(i),10); OLn(); i-=4;
   } /* while */
   OStrLn("----------:----------|-----------"); 
   ONum(i,10); OStr(": "); OHex(MEM(i)); OStr(" = "); ONum(MEM(i),10); OLn(); i-=4;
   ONum(i,10); OStr(": "); OHex(MEM(i)); OStr(" = "); ONum(MEM(i),10); OLn(); i-=4;
} /* DumpAllocBlock */

/*****************************************************************************/
void PRE($staticNEW)(/*  8(ebp) */ unsigned *var
                    ,/* 12(ebp) */ unsigned size
                    ,/* 16(ebp) */ unsigned tdescAddr
                    ,/* 20(ebp) */ unsigned initAddr){
   unsigned block, blocksize;

   SAVE_ROOT_EBP(); 
   blocksize = ALIGN(8,4+size); 
   block     = AllocAligned(blocksize); 
   if (block == 0){ OStrLn("staticNEW failed"); PRE(Halt)(1); } /* if */

   MEM(block-4) = tdescAddr; 

   *var = block; 
   RESTORE_ROOT_EBP(); 
   
#ifdef TRACE
   {  unsigned i;

      for (i=block; i<block+blocksize-4; i+=4){
          MEM(i) = -1; 
      } /* for */

      OStr("staticNEW(size=");
      OInt(size);
      OStr(",tdesc="); 
      ONum(tdescAddr,10);
      OStr(") --> "); 
      ONum(block,10);
      OLn(); 
      DumpAllocBlock(block,blocksize); 
   }
#endif

   asm("\n\
   pushl %eax\n\
   pushl %ebx\n\
   pushl %ecx\n\
   pushl %edx\n\
   pushl %esi\n\
   pushl %edi\n\
\n\
   movl  8(%ebp),%edi # edi = var\n\
   movl  (%edi),%edi  # edi = *var\n\
\n\
   call  20(%ebp)     # call initAddr\n\
\n\
   popl  %edi\n\
   popl  %esi\n\
   popl  %edx\n\
   popl  %ecx\n\
   popl  %ebx\n\
   popl  %eax\n\
   ");
} /* staticNEW */

/*****************************************************************************/
void PRE($openNEW)(/*  8(ebp) */ unsigned *var
                  ,/* 12(ebp) */ unsigned elemSize
                  ,/* 16(ebp) */ unsigned tdescAddr
                  ,/* 20(ebp) */ unsigned initAddr
                  ,/* 24(ebp) */ unsigned nofLens, ...){
   unsigned i, len, dst, block, blocksize, nofElems = 1;
   va_list ap;    
   
   SAVE_ROOT_EBP(); 

   va_start(ap,&nofLens);                                       /* calculate total nofElems */
   for (i=0; i<nofLens; i++) nofElems *= va_arg(ap,unsigned); 

   blocksize = ALIGN(8,4+4*((nofLens>1)+nofLens)+nofElems*elemSize); /* alloc required bytes */
   block     = AllocAligned(blocksize); 
   if (block == 0){ OStrLn("openNEW failed"); PRE(Halt)(1); } /* if */

   MEM(block-4) = tdescAddr;                                    /* enter the TDesc */

   dst = block;
   if (nofLens>1){                                              /* enter nofElems */
      MEM(dst) = nofElems; dst += 4;
   } /* if */      
                    
   va_start(ap,&nofLens);                                       /* enter the LENs */
   for (i=0; i<nofLens; i++){
      MEM(dst) = va_arg(ap,unsigned); dst += 4;
   } /* for */

   *var = block; 

   RESTORE_ROOT_EBP(); 
   
#ifdef TRACE
   {  unsigned i;

      for (i=block+4*((nofLens>1)+nofLens); i<block+blocksize-4; i+=4){
          MEM(i) = -1; 
      } /* for */

      OStr("openNEW("); 
      va_start(ap,&nofLens); 
      for (i=0; i<nofLens; i++){
         OStr((i>0)?",":""); 
         OInt(va_arg(ap,unsigned)); 
      } /* for */
      OStr("[,");
      OInt(elemSize);
      OStr("]) --> ");
      ONum(block,10);
      OLn(); 
      DumpAllocBlock(block,blocksize); 
   }
#endif

   asm("\n\
   pushl %eax\n\
   pushl %ebx\n\
   pushl %ecx\n\
   pushl %edx\n\
   pushl %esi\n\
   pushl %edi\n\
\n\
   movl  8(%ebp),%edi # edi = var\n\
   movl  (%edi),%edi  # edi = *var\n\
                      \n\
   call  20(%ebp)     # call initAddr\n\
\n\
   popl  %edi\n\
   popl  %esi\n\
   popl  %edx\n\
   popl  %ecx\n\
   popl  %ebx\n\
   popl  %eax\n\
   ");
} /* $openNEW */

/*****************************************************************************/
void PRE(SYSTEM$NEW)(unsigned *var, unsigned size){
   unsigned block, blocksize;

   SAVE_ROOT_EBP(); 

   blocksize = ALIGN(8,4+size+8); 
   block     = AllocAligned(blocksize); 
   if (block == 0){ OStrLn("SYSTEM.NEW failed"); PRE(Halt)(1); } /* if */

   MEM(block+blocksize- 8) = blocksize; 
   MEM(block+blocksize-12) = ADR(PRE(SB$S)); 
   MEM(block-4           ) = block+blocksize-8; 

   *var = block; 

   RESTORE_ROOT_EBP(); 
   
#ifdef TRACE
   {  unsigned i;

      for (i=block; i<block+blocksize-12; i+=4){
          MEM(i) = -1; 
      } /* for */

      OStr("SYSTEM.NEW(,");
      OInt(size);
      OStr(") --> "); 
      ONum(block,10);
      OLn(); 
      DumpAllocBlock(block,blocksize); 
   }
#endif
} /* SYSTEM$NEW */

/*****************************************************************************/
void PRE(MarkBlock)(unsigned block){
   MEM(block-4) |= 1;
} /* MarkBlock */

/*****************************************************************************/
void PRE(MarkAll)(){ asm("\n\
\n\
       pushl   %eax\n\
       pushl   %ebx\n\
       pushl   %ecx\n\
       pushl   %edx\n\
       pushl   %esi\n\
       pushl   %edi\n\
       \n\
       pushl   $MarkAllDone\n\
       movl    _HeapStart,%ebx\n\
       addl    $12,%ebx\n\
       movl    $MarkAllLoop,%esi\n\
MarkAllLoop:\n\
       movl    -4(%ebx),%edi\n\
       orl     $1,-4(%ebx)\n\
       jmp     -4(%edi)\n\
       \n\
MarkAllDone:\n\
       andl    $0xFFFFFFFE,-4(%ebx) # clear sentinel's mark\n\
       popl    %edi\n\
       popl    %esi\n\
       popl    %edx\n\
       popl    %ecx\n\
       popl    %ebx\n\
       popl    %eax\n\
        \n\
"); } /* MarkAll */

/*****************************************************************************/
void PRE(Mark)(){ 

   SAVE_ROOT_EBP(); 
   asm("\n\
       pushl   %eax\n\
       pushl   %ebx\n\
       pushl   %ecx\n\
       pushl   %edx\n\
       pushl   %esi\n\
       pushl   %edi\n\
       pushl   %ebp\n\
\n\
       call    MarkIt\n\
\n\
       jmp     MarkDone\n\
\n\
#------------------------------------------------------------------------------\n\
ShowBlockName1: .asciz \" --> \"\n\
ShowBlockName:\n\
       pushl   %eax\n\
\n\
       pushl   %ebp ; call _DumpDec ; addl $4,%esp\n\
       pushl   $ShowBlockName1; call _DumpStr ; addl $4,%esp\n\
       movl    -4(%ebp),%eax\n\
       andl    $0xfffffffe,%eax\n\
       pushl   -12(%eax) ; call _DumpStr ; addl $4,%esp\n\
       call    _DumpLn\n\
\n\
       popl    %eax\n\
       ret\n\
       \n\
#------------------------------------------------------------------------------\n\
ShowOfsAndNew1: .asciz \": \"\n\
ShowOfsAndNew:\n\
       pushl   %ebx ; call _DumpDec ; addl $4,%esp\n\
       pushl   $ShowOfsAndNew1; call _DumpStr ; addl $4,%esp\n\
       pushl   %eax ; call _DumpDec ; addl $4,%esp\n\
       call    _DumpLn\n\
       ret\n\
       \n\
#------------------------------------------------------------------------------\n\
ShowBlockInfo1: .asciz  \"block \"\n\
ShowBlockInfo2: .asciz  \"tag   \"\n\
ShowBlockInfo3: .asciz  \"name  \"\n\
ShowBlockInfo:\n\
       pushl   %eax\n\
\n\
       pushl   $ShowBlockInfo1 ; call _DumpStr ; addl $4,%esp\n\
       pushl   %ebp ; call _DumpDec ; addl $4,%esp\n\
       call    _DumpLn\n\
\n\
       pushl   $ShowBlockInfo2 ; call _DumpStr ; addl $4,%esp\n\
       pushl   -4(%ebp) ; call _DumpDec ; addl $4,%esp\n\
       call    _DumpLn\n\
\n\
       pushl   $ShowBlockInfo3 ; call _DumpStr ; addl $4,%esp\n\
       movl    -4(%ebp),%eax\n\
       andl    $0xfffffffe,%eax\n\
       pushl   -12(%eax) ; call _DumpStr ; addl $4,%esp\n\
       call    _DumpLn\n\
\n\
       call    _DumpLn\n\
       popl    %eax\n\
       ret\n\
       \n\
#------------------------------------------------------------------------------\n\
ShowOpenInfo1: .asciz \"open at ofs=\"\n\
ShowOpenInfo2: .asciz \" nofElems=\"\n\
ShowOpenInfo3: .asciz \" base=\"\n\
ShowOpenInfo:	  \n\
\n\
       pushl   $ShowOpenInfo1 ; call _DumpStr ; addl $4,%esp\n\
       pushl   %ebx ; call _DumpDec ; addl $4,%esp\n\
\n\
       pushl   $ShowOpenInfo2 ; call _DumpStr ; addl $4,%esp\n\
       pushl   %ecx ; call _DumpDec ; addl $4,%esp\n\
\n\
       pushl   $ShowOpenInfo3 ; call _DumpStr ; addl $4,%esp\n\
       pushl   %esi ; call _DumpDec ; addl $4,%esp\n\
\n\
       call    _DumpLn\n\
       ret\n\
       \n\
#------------------------------------------------------------------------------\n\
MarkIt:\n\
       movl    _root_ebp,%ebp        # act := root_ebp\n\
       \n\
MarkRepeat:                          # REPEAT\n\
# call ShowBlockName # !DEBUG\n\
       movl    -4(%ebp),%edi         #    desc := MEM(act-4); \n\
\n\
                                     #    (* process fixed offsets *)\n\
       movl    (%edi),%ebx           #    ofs  := MEM(desc); \n\
       \n\
       jmp     MarkWhileCond1        #    WHILE ofs # -1 DO\n\
MarkWhile1:\n\
       movl    (%ebp,%ebx),%eax      #       new := MEM(act+ofs); \n\
       \n\
# call ShowOfsAndNew # !DEBUG\n\
\n\
       testl   %eax,%eax             #       IF (new # NIL)\n\
       jz      MarkIfEnd1\n\
\n\
       btsl    $0,-4(%eax)           #       &  ~ISMARKED(new-4) THEN\n\
       jc      MarkIfEnd1\n\
       \n\
       pushl   %edi                  #          PUSH(desc);\n\
       movl    %ebp,%edx             #          last := act;\n\
       movl    %eax,%ebp             #          act  := new;\n\
       call    MarkABlock            #          MarkABlock;\n\
       movl    %edx,%ebp             #          act  := last;\n\
       popl    %edi                  #          POP(desc);\n\
MarkIfEnd1:                          #       END; (* IF *)\n\
\n\
       addl    $4,%edi               #       INC(desc,4);\n\
       movl    (%edi),%ebx           #       ofs := MEM(desc);\n\
       \n\
MarkWhileCond1:                      #    END; (* WHILE ofs >= 0 *)\n\
       cmpl    $-1,%ebx\n\
       jnz     MarkWhile1\n\
\n\
       addl    $4,%edi               #    INC(desc,4);\n\
\n\
                                     #    (* process open offsets *)\n\
       jmp     MarkWhileCond2        #    WHILE MEM(desc) = -2 DO\n\
MarkWhile2:\n\
       pushl   %edi                  #       PUSH(desc);\n\
       movl    4(%edi),%ebx          #       ofs   := MEM(desc+4);\n\
       movl    4(%ebp,%ebx),%ecx     #       count := MEM(act+ofs+4);\n\
       movl    (%ebp,%ebx),%esi      #       base  := MEM(act+ofs);\n\
# call ShowOpenInfo # !DEBUG\n\
MarkLoop:                            #       LOOP\n\
       addl    $12,%edi              #          INC(desc,12);\n\
       movl    (%edi),%ebx           #          ofs := MEM(desc);\n\
       \n\
       jmp     MarkWhileCond3        #          WHILE ofs # -1 DO\n\
MarkWhile3:\n\
\n\
       movl    (%esi,%ebx),%eax      #             new := MEM(base+ofs); \n\
# call ShowOfsAndNew # !DEBUG\n\
       testl   %eax,%eax             #             IF (new # NIL)\n\
       jz      MarkIfEnd2\n\
       \n\
       btsl    $0,-4(%eax)           #             &  ~ISMARKED(new-4) THEN\n\
       jc      MarkIfEnd2\n\
       \n\
       pushl   %edi                  #                PUSH(desc);\n\
       movl    %ebp,%edx             #                last := act;\n\
       movl    %eax,%ebp             #                act  := new;\n\
       call    MarkABlock            #                MarkABlock;\n\
       movl    %edx,%ebp             #                act  := last;\n\
       popl    %edi                  #                POP(desc);\n\
MarkIfEnd2:                          #             END; (* IF *)\n\
\n\
       addl    $4,%edi               #             INC(desc,4);\n\
       movl    (%edi),%ebx           #             ofs := MEM(desc);\n\
       \n\
MarkWhileCond3:                      #          END; (* WHILE ofs # -1 *)\n\
       cmpl    $-1,%ebx\n\
       jnz     MarkWhile3\n\
       \n\
       dec     %ecx                  #          DEC(count);\n\
       jz      MarkLoopEnd           #          IF count = 0 THEN EXIT; END;\n\
       \n\
       movl    (%esp),%edi           #          desc := TOP();\n\
       addl    8(%edi),%esi          #          INC(base,MEM(desc+8)); (* elemSize *)\n\
\n\
       jmp     MarkLoop              #       END; (* LOOP *)\n\
MarkLoopEnd:\n\
\n\
       addl    $4,%edi               #       INC(desc,4);\n\
       addl    $4,%esp               #       DROP;\n\
\n\
MarkWhileCond2:                      #    END; (* WHILE MEM(desc) = -2 *)\n\
       cmpl    $-2,(%edi)\n\
       jz      MarkWhile2\n\
\n\
       movl    (%ebp),%ebp           #    act := MEM(act); \n\
       testl   %ebp,%ebp\n\
       jnz     MarkRepeat            # UNTIL act = 0;\n\
       ret                           # RETURN;\n\
\n\
#------------------------------------------------------------------------------\n\
MarkABlock:\n\
# call ShowBlockName # !DEBUG\n\
       movl    -4(%ebp),%edi         # desc := MEM(act-4);\n\
       movl    (%edi),%ebx           # ofs  := MEM(desc);\n\
       \n\
       cmpl    $-1,%ebx              # IF ofs = -1 THEN RETURN; END;\n\
       jz      MarkBlockDone\n\
\n\
       cmpl    $-2,%ebx              # IF ofs # -2 THEN\n\
       jz      MarkBlockIfElse0\n\
       \n\
       jmp     MarkBlockWhileCond1   #    WHILE ofs # -1 DO\n\
MarkBlockWhile1:       \n\
\n\
       movl    (%ebp,%ebx),%eax      #       new := MEM(act+ofs);\n\
# call ShowOfsAndNew # !DEBUG\n\
       testl   %eax,%eax             #       IF (new # NIL)\n\
       jz      MarkBlockIfEnd1\n\
       \n\
       btsl    $0,-4(%eax)           #       &  ~ISMARKED(new-4) THEN\n\
       jc      MarkBlockIfEnd1\n\
       \n\
       movl    %edx,(%ebp,%ebx)      #          MEM(act+ofs) := last;\n\
       movl    %edi,-4(%ebp)         #          MEM(act-4)   := desc;\n\
       movl    %ebp,%edx             #          last         := act;\n\
       movl    %eax,%ebp             #          act          := new;\n\
       call    MarkABlock            #          MarkABlock;\n\
       movl    %ebp,%eax             #          new          := act;\n\
       movl    %edx,%ebp             #          act          := last;\n\
       movl    -4(%ebp),%edi         #          desc         := MEM(act-4);\n\
       movl    (%edi),%ebx           #          ofs          := MEM(desc);\n\
       movl    (%ebp,%ebx),%edx      #          last         := MEM(act+ofs);\n\
       movl    %eax,(%ebp,%ebx)      #          MEM(act+ofs) := new;\n\
MarkBlockIfEnd1:                     #       END; (* IF *)\n\
\n\
       addl    $4,%edi               #       INC(desc,4);\n\
       movl    (%edi),%ebx           #       ofs := MEM(desc);\n\
\n\
MarkBlockWhileCond1:                 #    END; (* WHILE ofs # -1 *)\n\
       cmpl    $-1,%ebx\n\
       jnz     MarkBlockWhile1\n\
       \n\
       movl    4(%edi),%eax          #    MEM(act-4) := MEM(desc+4);\n\
       movl    %eax,-4(%ebp)\n\
\n\
       jmp     MarkBlockIfEnd0       # ELSE\n\
MarkBlockIfElse0:\n\
\n\
       pushl   %ecx                  #    PUSH(count);\n\
       pushl   %esi                  #    PUSH(base);\n\
       pushl   %edi                  #    PUSH(desc);\n\
       movl    (%ebp),%ecx           #    count := MEM(act);\n\
       movl    %ebp,%esi             #    base  := act;\n\
       addl    4(%edi),%esi          #    INC(base,MEM(desc+4));\n\
       \n\
MarkBlockRepeat:                     #    REPEAT\n\
       addl    $12,%edi              #       INC(desc,12);\n\
       movl    (%edi),%ebx           #       ofs := MEM(desc);\n\
       \n\
       jmp     MarkBlockWhileCond2   #       WHILE ofs # -1 DO\n\
MarkBlockWhile2:\n\
       movl    (%esi,%ebx),%eax      #          new := MEM(base+ofs);\n\
       \n\
       testl   %eax,%eax             #          IF (new # NIL)\n\
       jz      MarkBlockIfEnd2\n\
       \n\
       btsl    $0,-4(%eax)           #          &  ~ISMARKED(new-4) THEN\n\
       jc      MarkBlockIfEnd2\n\
       \n\
       movl    %edx,(%esi,%ebx)      #             MEM(base+ofs) := last;\n\
       movl    %edi,-4(%ebp)         #             MEM(act-4)    := desc;\n\
       movl    %ebp,%edx             #             last          := act;\n\
       movl    %eax,%ebp             #             act           := new;\n\
       call    MarkABlock            #             MarkABlock;\n\
       movl    %ebp,%eax             #             new           := act;\n\
       movl    %edx,%ebp             #             act           := last;\n\
       movl    -4(%ebp),%edi         #             desc          := MEM(act-4);\n\
       movl    (%edi),%ebx           #             ofs           := MEM(desc);\n\
       movl    (%esi,%ebx),%edx      #             last          := MEM(base+ofs);\n\
       movl    %eax,(%esi,%ebx)      #             MEM(base+ofs) := new;\n\
MarkBlockIfEnd2:                     #          END; (* IF *)\n\
\n\
       addl    $4,%edi               #          INC(desc,4);\n\
       movl    (%edi),%ebx           #          ofs := MEM(desc);\n\
       \n\
MarkBlockWhileCond2:                 #       END; (* WHILE ofs # -1 *)\n\
       cmpl    $-1,%ebx\n\
       jnz     MarkBlockWhile2\n\
\n\
       movl    (%esp),%edi           #       desc := TOP();\n\
       addl    8(%edi),%esi          #       INC(base,MEM(desc+8)); (* elemSize *)\n\
       decl    %ecx                  #       DEC(count);\n\
       jnz     MarkBlockRepeat       #    UNTIL count = 0;\n\
       \n\
       popl    -4(%ebp)              #    POP(MEM(act-4));\n\
       popl    %esi                  #    POP(base);\n\
       popl    %ecx                  #    POP(count);\n\
MarkBlockIfEnd0:                     # END; (* IF ofs # -2 *)\n\
       \n\
MarkBlockDone:\n\
       ret                           # RETURN;\n\
\n\
#------------------------------------------------------------------------------\n\
MarkDone:\n\
       popl    %ebp\n\
       popl    %edi\n\
       popl    %esi\n\
       popl    %edx\n\
       popl    %ecx\n\
       popl    %ebx\n\
       popl    %eax	\n\
\n\
   "); 
   RESTORE_ROOT_EBP(); 
} /* Mark */

/*****************************************************************************/
void PRE(Sweep)(){ asm("\n\
\n\
       pushl   %eax                      # used by some skippers\n\
       pushl   %ebx                      # points always to the current block\n\
       pushl   %ecx                      # points to the last block to be set free\n\
       pushl   %edx                      # points to the last block set free\n\
       pushl   %esi                      # holds the return address for a skipper\n\
       pushl   %edi                      # holds the tag of the current block\n\
       pushl   $SweepDone                # the default return address for the sentinel\n\
\n\
       movl    _HeapStart,%ebx\n\
       leal	4(%ebx),%edx\n\
       addl    $12,%ebx\n\
\n\
#------------------------------------------------------------------------------------------------\n\
SweepHeadSearch:                         # let us look for a first unmarked block...\n\
       movl    $SweepHeadLoop,%esi       # skipper default return address\n\
SweepHeadLoop:\n\
       btrl    $0,-4(%ebx)               # block marked? ...reset mark\n\
       jnc     SweepHeadFound            # block was not marked --> further unmarked blocks?\n\
       movl    -4(%ebx),%edi             # load tag\n\
       jmp     -4(%edi)                  # call skipper\n\
\n\
SweepHeadFound:\n\
       movl    %ebx,%ecx                 # remember head\n\
       movl    $SweepFreeEnd,(%esp)      # sentinel alternate return address\n\
       movl    $SweepFreeLoop,%esi       # skipper alternate return address\n\
SweepFreeNext:\n\
       movl    -4(%ebx),%edi             # load tag\n\
       jmp     -4(%edi)                  # call skipper\n\
SweepFreeLoop:\n\
       btrl    $0,-4(%ebx)               # is this block also marked? ...reset mark\n\
       jnc     SweepFreeNext             # this block was not marked --> continue search\n\
\n\
       # we've reached a marked block: all previous blocks starting from head are to be set free\n\
       movl    %ebx,%eax\n\
       subl    %ecx,%eax                 # eax = blocksize of head\n\
       cmpl    $8,%eax                   # eax>8 ?\n\
       ja      SweepFreeLargeBlock       # yes -->\n\
\n\
       # we're freeing a small block (hoping the blocksize's not < 8 ;-)\n\
       movl    $_B8$D,-4(%ecx)           # this is a small free block\n\
       movl    %ecx,(%edx)               # link last free block to head\n\
       movl    %ecx,%edx                 # head is now the last free block\n\
\n\
       movl    $SweepDone,(%esp)         # sentinel default return target\n\
       movl    $SweepHeadLoop,%esi       # skipper default return target\n\
       movl    -4(%ebx),%edi             # load tag\n\
       jmp     -4(%edi)                  # call skipper\n\
\n\
SweepFreeLargeBlock: # we're freeing a standard block\n\
       movl    $_FB$D,-4(%ecx)           # descriptor for a standard block...\n\
       movl    %eax,4(%ecx)              # ...of this size\n\
       movl    %ecx,(%edx)               # link last free block to head\n\
       movl    %ecx,%edx                 # head is now the last free block\n\
       \n\
       movl    $SweepDone,(%esp)         # sentinel default return target\n\
       movl    $SweepHeadLoop,%esi       # skipper default return target\n\
       movl    -4(%ebx),%edi             # load tag\n\
       jmp     -4(%edi)                  # call skipper\n\
\n\
\n\
SweepFreeEnd:\n\
       # we've reached the sentinel: all blocks starting from head are to be set free\n\
       movl    %ebx,%eax\n\
       subl    %ecx,%eax                 # eax = blocksize of head\n\
       cmpl    $8,%eax                   # eax>8 ?\n\
       jg      SweepFreeLargeLastBlock   # yes -->\n\
\n\
       # we're freeing a small block (hoping the blocksize's not < 8 ;-)\n\
       movl    $_B8$D,-4(%ecx)           # this is a small free block\n\
       jmp     SweepLinkLast\n\
       \n\
SweepFreeLargeLastBlock: # we're freeing a standard block\n\
       movl    $_FB$D,-4(%ecx)           # descriptor for a standard block...\n\
       movl    %eax,4(%ecx)              # ...of this size\n\
\n\
SweepLinkLast:\n\
       movl    %ecx,(%edx)               # link last free block to head\n\
       movl    %ebx,(%ecx)               # link head to sentinel\n\
\n\
#------------------------------------------------------------------------------------------------\n\
SweepDone:\n\
       movl    _HeapEnd,%eax\n\
       movl    $_ZB$D,-4(%eax)\n\
       movl    $0,(%eax)\n\
       \n\
       popl    %edi\n\
       popl    %esi\n\
       popl    %edx\n\
       popl    %ecx\n\
       popl    %ebx\n\
       popl    %eax\n\
        \n\
"); } /* Sweep */

/*****************************************************************************/
void PRE(GC)(){
   SAVE_ROOT_EBP(); 
   
   PRE(Mark)(); 
   PRE(Sweep)(); 

   RESTORE_ROOT_EBP(); 
} /* GC */

/*****************************************************************************/
int IncreaseHeap(unsigned change){
   unsigned oldEnd;

   if (sbrk(ALIGN(8,change)) == -1) return 0; 
   
   oldEnd              = PRE(HeapEnd); 
   PRE(HeapEnd)        = ALIGN(8,sbrk(0)-8);

   /* old sentinel -> free block */	             
   MEM(oldEnd-4 )      = ADR(PRE(FB$D));      /* tag  */
   MEM(oldEnd   )      = PRE(HeapEnd);        /* next */
   MEM(oldEnd+4 )      = PRE(HeapEnd)-oldEnd; /* size */
   
   /* new sentinel block */
   MEM(PRE(HeapEnd)-4) = ADR(PRE(ZB$D));      /* tag  */
   MEM(PRE(HeapEnd)  ) = 0;                   /* next */
   
   return (PRE(HeapEnd)-oldEnd); 
} /* IncreaseHeap */

/*****************************************************************************/
int DecreaseHeap(int change){
   int block,next,newEnd,oldEnd;
   
   oldEnd = PRE(HeapEnd); 
   change = ALIGN(8,change); 
   newEnd = PRE(HeapEnd)-change; 

   /* search last free block */
   block = MEM(PRE(HeapStart)+4); 
   if (block == PRE(HeapEnd)) return 0; 
   while (1){
      next = MEM(block); 
      if (next == PRE(HeapEnd)) break; 
      block = next; 
   } /* while */
   
   if (block+FREESIZE(block) != PRE(HeapEnd)) return 0; 

   if (newEnd < block) newEnd = block; 

   PRE(HeapEnd) = newEnd; 
   if (PRE(HeapEnd)-block == 8){
      MEM(block-4) = ADR(PRE(B8$D));     /* tag  */
      MEM(block  ) = PRE(HeapEnd);       /* next */
   }else if (PRE(HeapEnd)-block > 8){
      MEM(block-4) = ADR(PRE(FB$D));     /* tag  */
      MEM(block  ) = PRE(HeapEnd);       /* next */
      MEM(block+4) = PRE(HeapEnd)-block; /* size */
   } /* if */

   /* new sentinel block */
   MEM(PRE(HeapEnd)-4) = ADR(PRE(ZB$D)); /* tag  */
   MEM(PRE(HeapEnd)  ) = 0;              /* next */

   change = PRE(HeapEnd)-oldEnd; 
   sbrk(change); 
   return change; 
} /* DecreaseHeap */

/*****************************************************************************/
int PRE(ChangeHeapSize)(int change){
   if (change==0) return 0; 

   if (change>0){
      return IncreaseHeap(change); 
   }else{
      return DecreaseHeap(-change); 
   } /* if */
} /* ChangeHeapSize */

/*****************************************************************************/
void PRE(Storage$I)(){
   unsigned start;
   
   PRE(root_ebp)          = 0; 
   InitialHeapSize        = ALIGN(8,InitialHeapSize); 
   start                  = sbrk(0); 
   PRE(HeapStart)         = 4+ALIGN(8,start); 
   
   if (sbrk((PRE(HeapStart)-start)+InitialHeapSize) == -1){
      OStr("Unable to create a heap of ");
      OInt(InitialHeapSize);
      OStrLn(" bytes"); 
      PRE(Halt)(1); 
   } /* if */
   PRE(HeapEnd)           = ALIGN(8,sbrk(0)-8);
   
   /* anchor block */
   MEM(PRE(HeapStart))    = ADR(PRE(AB$D));                 /* tag  */
   MEM(PRE(HeapStart)+ 4) = PRE(HeapStart)+12;              /* next */
   				             
   /* initial free block */	             
   MEM(PRE(HeapStart)+ 8) = ADR(PRE(FB$D));                 /* tag  */
   MEM(PRE(HeapStart)+12) = PRE(HeapEnd);                   /* next */
   MEM(PRE(HeapStart)+16) = PRE(HeapEnd)-PRE(HeapStart)-12; /* size */
   
   /* sentinel block */
   MEM(PRE(HeapEnd)-4   ) = ADR(PRE(ZB$D));                 /* tag  */
   MEM(PRE(HeapEnd)     ) = 0;                              /* next */
} /* Storage$I */

