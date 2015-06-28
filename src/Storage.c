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
static void AnchorBlockFrame(){ asm("

# Desc for AnchorBlock
_AB$N:  .asciz	\"anchor\"

	.align	2
	.long	_AB$N		# -12 name
	.long	0		# -8  size
	.long	_NILPROC	# -4  skipper
_AB$D:				#     walker

"); } extern void *PRE(AB$D);

/*---------------------------------------------------------------------------*/
static void FreeBlockFrame(){ asm("

# Desc for FreeBlock
_FB$N:  .asciz	\"free\"

	.align	2,144
_FB$S:  addl	4(%ebx),%ebx
	jmp	%esi

	.align	2
	.long	_FB$N	# -12 name
	.long	0	# -8  size
	.long	_FB$S	# -4  skipper
_FB$D:			#     walker

"); } extern void *PRE(FB$D);

/*---------------------------------------------------------------------------*/
static void SmallBlockFrame(){ asm("

# Desc for SmallBlock
_B8$N:	.asciz	\"small\"

	.align	2,144
_B8$S:  addl	$8,%ebx
	jmp	%esi

	.align	2
	.long	_B8$N	# -12 name
	.long	0	# -8  size
	.long	_B8$S	# -4  skipper
_B8$D:			#     walker

"); } extern void *PRE(B8$D);

/*---------------------------------------------------------------------------*/
static void SentinelBlockFrame(){ asm("

# Desc for SentinelBlock
_ZB$N:	.asciz	\"sentinel\"

	.align	2,144
_ZB$S:  ret

	.align	2
	.long	_ZB$N	# -12 name
	.long	0	# -8  size
	.long	_ZB$S	# -4  skipper
_ZB$D:			#     walker

"); } extern void *PRE(ZB$D);

/*---------------------------------------------------------------------------*/
static void SystemBlockSkipperFrame(){ asm("

# Skipper for SystemBlock
	.align	2,144
_SB$S:	movl	-4(%ebx),%eax
	andb	$0xFE,%al
	addl	(%eax),%ebx
        jmp	%esi

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
void AllocFail(unsigned size, unsigned nofAttempts){ asm("

	pushl	%eax
	pushl	%ebx
	pushl	%ecx
	pushl	%edx
	pushl	%esi
	pushl	%edi
        
	pushl	12(%ebp)
	pushl	8(%ebp)
        movl	_AllocFailHandlerProc,%eax
	call	%eax
	addl	$8,%esp

	popl	%edi
	popl	%esi
	popl	%edx
	popl	%ecx
	popl	%ebx
	popl	%eax
        
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

   asm("
   pushl %eax
   pushl %ebx
   pushl %ecx
   pushl %edx
   pushl %esi
   pushl %edi

   movl  8(%ebp),%edi # edi = var
   movl  (%edi),%edi  # edi = *var

   call  20(%ebp)     # call initAddr

   popl  %edi
   popl  %esi
   popl  %edx
   popl  %ecx
   popl  %ebx
   popl  %eax
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

   asm("
   pushl %eax
   pushl %ebx
   pushl %ecx
   pushl %edx
   pushl %esi
   pushl %edi

   movl  8(%ebp),%edi # edi = var
   movl  (%edi),%edi  # edi = *var
                      
   call  20(%ebp)     # call initAddr

   popl  %edi
   popl  %esi
   popl  %edx
   popl  %ecx
   popl  %ebx
   popl  %eax
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
void PRE(MarkAll)(){ asm("

       pushl   %eax
       pushl   %ebx
       pushl   %ecx
       pushl   %edx
       pushl   %esi
       pushl   %edi
       
       pushl   $MarkAllDone
       movl    _HeapStart,%ebx
       addl    $12,%ebx
       movl    $MarkAllLoop,%esi
MarkAllLoop:
       movl    -4(%ebx),%edi
       orl     $1,-4(%ebx)
       jmp     -4(%edi)
       
MarkAllDone:
       andl    $0xFFFFFFFE,-4(%ebx) # clear sentinel's mark
       popl    %edi
       popl    %esi
       popl    %edx
       popl    %ecx
       popl    %ebx
       popl    %eax
        
"); } /* MarkAll */

/*****************************************************************************/
void PRE(Mark)(){ 

   SAVE_ROOT_EBP(); 
   asm("
       pushl   %eax
       pushl   %ebx
       pushl   %ecx
       pushl   %edx
       pushl   %esi
       pushl   %edi
       pushl   %ebp

       call    MarkIt

       jmp     MarkDone

#------------------------------------------------------------------------------
ShowBlockName1: .asciz \" --> \"
ShowBlockName:
       pushl   %eax

       pushl   %ebp ; call _DumpDec ; addl $4,%esp
       pushl   $ShowBlockName1; call _DumpStr ; addl $4,%esp
       movl    -4(%ebp),%eax
       andl    $0xfffffffe,%eax
       pushl   -12(%eax) ; call _DumpStr ; addl $4,%esp
       call    _DumpLn

       popl    %eax
       ret
       
#------------------------------------------------------------------------------
ShowOfsAndNew1: .asciz \": \"
ShowOfsAndNew:
       pushl   %ebx ; call _DumpDec ; addl $4,%esp
       pushl   $ShowOfsAndNew1; call _DumpStr ; addl $4,%esp
       pushl   %eax ; call _DumpDec ; addl $4,%esp
       call    _DumpLn
       ret
       
#------------------------------------------------------------------------------
ShowBlockInfo1: .asciz  \"block \"
ShowBlockInfo2: .asciz  \"tag   \"
ShowBlockInfo3: .asciz  \"name  \"
ShowBlockInfo:
       pushl   %eax

       pushl   $ShowBlockInfo1 ; call _DumpStr ; addl $4,%esp
       pushl   %ebp ; call _DumpDec ; addl $4,%esp
       call    _DumpLn

       pushl   $ShowBlockInfo2 ; call _DumpStr ; addl $4,%esp
       pushl   -4(%ebp) ; call _DumpDec ; addl $4,%esp
       call    _DumpLn

       pushl   $ShowBlockInfo3 ; call _DumpStr ; addl $4,%esp
       movl    -4(%ebp),%eax
       andl    $0xfffffffe,%eax
       pushl   -12(%eax) ; call _DumpStr ; addl $4,%esp
       call    _DumpLn

       call    _DumpLn
       popl    %eax
       ret
       
#------------------------------------------------------------------------------
ShowOpenInfo1: .asciz \"open at ofs=\"
ShowOpenInfo2: .asciz \" nofElems=\"
ShowOpenInfo3: .asciz \" base=\"
ShowOpenInfo:	  

       pushl   $ShowOpenInfo1 ; call _DumpStr ; addl $4,%esp
       pushl   %ebx ; call _DumpDec ; addl $4,%esp

       pushl   $ShowOpenInfo2 ; call _DumpStr ; addl $4,%esp
       pushl   %ecx ; call _DumpDec ; addl $4,%esp

       pushl   $ShowOpenInfo3 ; call _DumpStr ; addl $4,%esp
       pushl   %esi ; call _DumpDec ; addl $4,%esp

       call    _DumpLn
       ret
       
#------------------------------------------------------------------------------
MarkIt:
       movl    _root_ebp,%ebp        # act := root_ebp
       
MarkRepeat:                          # REPEAT
# call ShowBlockName # !DEBUG
       movl    -4(%ebp),%edi         #    desc := MEM(act-4); 

                                     #    (* process fixed offsets *)
       movl    (%edi),%ebx           #    ofs  := MEM(desc); 
       
       jmp     MarkWhileCond1        #    WHILE ofs # -1 DO
MarkWhile1:
       movl    (%ebp,%ebx),%eax      #       new := MEM(act+ofs); 
       
# call ShowOfsAndNew # !DEBUG

       testl   %eax,%eax             #       IF (new # NIL)
       jz      MarkIfEnd1

       btsb    $0,-4(%eax)           #       &  ~ISMARKED(new-4) THEN
       jc      MarkIfEnd1
       
       pushl   %edi                  #          PUSH(desc);
       movl    %ebp,%edx             #          last := act;
       movl    %eax,%ebp             #          act  := new;
       call    MarkABlock            #          MarkABlock;
       movl    %edx,%ebp             #          act  := last;
       popl    %edi                  #          POP(desc);
MarkIfEnd1:                          #       END; (* IF *)

       addl    $4,%edi               #       INC(desc,4);
       movl    (%edi),%ebx           #       ofs := MEM(desc);
       
MarkWhileCond1:                      #    END; (* WHILE ofs >= 0 *)
       cmpl    $-1,%ebx
       jnz     MarkWhile1

       addl    $4,%edi               #    INC(desc,4);

                                     #    (* process open offsets *)
       jmp     MarkWhileCond2        #    WHILE MEM(desc) = -2 DO
MarkWhile2:
       pushl   %edi                  #       PUSH(desc);
       movl    4(%edi),%ebx          #       ofs   := MEM(desc+4);
       movl    4(%ebp,%ebx),%ecx     #       count := MEM(act+ofs+4);
       movl    (%ebp,%ebx),%esi      #       base  := MEM(act+ofs);
# call ShowOpenInfo # !DEBUG
MarkLoop:                            #       LOOP
       addl    $12,%edi              #          INC(desc,12);
       movl    (%edi),%ebx           #          ofs := MEM(desc);
       
       jmp     MarkWhileCond3        #          WHILE ofs # -1 DO
MarkWhile3:

       movl    (%esi,%ebx),%eax      #             new := MEM(base+ofs); 
# call ShowOfsAndNew # !DEBUG
       testl   %eax,%eax             #             IF (new # NIL)
       jz      MarkIfEnd2
       
       btsb    $0,-4(%eax)           #             &  ~ISMARKED(new-4) THEN
       jc      MarkIfEnd2
       
       pushl   %edi                  #                PUSH(desc);
       movl    %ebp,%edx             #                last := act;
       movl    %eax,%ebp             #                act  := new;
       call    MarkABlock            #                MarkABlock;
       movl    %edx,%ebp             #                act  := last;
       popl    %edi                  #                POP(desc);
MarkIfEnd2:                          #             END; (* IF *)

       addl    $4,%edi               #             INC(desc,4);
       movl    (%edi),%ebx           #             ofs := MEM(desc);
       
MarkWhileCond3:                      #          END; (* WHILE ofs # -1 *)
       cmpl    $-1,%ebx
       jnz     MarkWhile3
       
       dec     %ecx                  #          DEC(count);
       jz      MarkLoopEnd           #          IF count = 0 THEN EXIT; END;
       
       movl    (%esp),%edi           #          desc := TOP();
       addl    8(%edi),%esi          #          INC(base,MEM(desc+8)); (* elemSize *)

       jmp     MarkLoop              #       END; (* LOOP *)
MarkLoopEnd:

       addl    $4,%edi               #       INC(desc,4);
       addl    $4,%esp               #       DROP;

MarkWhileCond2:                      #    END; (* WHILE MEM(desc) = -2 *)
       cmpl    $-2,(%edi)
       jz      MarkWhile2

       movl    (%ebp),%ebp           #    act := MEM(act); 
       testl   %ebp,%ebp
       jnz     MarkRepeat            # UNTIL act = 0;
       ret                           # RETURN;

#------------------------------------------------------------------------------
MarkABlock:
# call ShowBlockName # !DEBUG
       movl    -4(%ebp),%edi         # desc := MEM(act-4);
       movl    (%edi),%ebx           # ofs  := MEM(desc);
       
       cmpl    $-1,%ebx              # IF ofs = -1 THEN RETURN; END;
       jz      MarkBlockDone

       cmpl    $-2,%ebx              # IF ofs # -2 THEN
       jz      MarkBlockIfElse0
       
       jmp     MarkBlockWhileCond1   #    WHILE ofs # -1 DO
MarkBlockWhile1:       

       movl    (%ebp,%ebx),%eax      #       new := MEM(act+ofs);
# call ShowOfsAndNew # !DEBUG
       testl   %eax,%eax             #       IF (new # NIL)
       jz      MarkBlockIfEnd1
       
       btsb    $0,-4(%eax)           #       &  ~ISMARKED(new-4) THEN
       jc      MarkBlockIfEnd1
       
       movl    %edx,(%ebp,%ebx)      #          MEM(act+ofs) := last;
       movl    %edi,-4(%ebp)         #          MEM(act-4)   := desc;
       movl    %ebp,%edx             #          last         := act;
       movl    %eax,%ebp             #          act          := new;
       call    MarkABlock            #          MarkABlock;
       movl    %ebp,%eax             #          new          := act;
       movl    %edx,%ebp             #          act          := last;
       movl    -4(%ebp),%edi         #          desc         := MEM(act-4);
       movl    (%edi),%ebx           #          ofs          := MEM(desc);
       movl    (%ebp,%ebx),%edx      #          last         := MEM(act+ofs);
       movl    %eax,(%ebp,%ebx)      #          MEM(act+ofs) := new;
MarkBlockIfEnd1:                     #       END; (* IF *)

       addl    $4,%edi               #       INC(desc,4);
       movl    (%edi),%ebx           #       ofs := MEM(desc);

MarkBlockWhileCond1:                 #    END; (* WHILE ofs # -1 *)
       cmpl    $-1,%ebx
       jnz     MarkBlockWhile1
       
       movl    4(%edi),%eax          #    MEM(act-4) := MEM(desc+4);
       movl    %eax,-4(%ebp)

       jmp     MarkBlockIfEnd0       # ELSE
MarkBlockIfElse0:

       pushl   %ecx                  #    PUSH(count);
       pushl   %esi                  #    PUSH(base);
       pushl   %edi                  #    PUSH(desc);
       movl    (%ebp),%ecx           #    count := MEM(act);
       movl    %ebp,%esi             #    base  := act;
       addl    4(%edi),%esi          #    INC(base,MEM(desc+4));
       
MarkBlockRepeat:                     #    REPEAT
       addl    $12,%edi              #       INC(desc,12);
       movl    (%edi),%ebx           #       ofs := MEM(desc);
       
       jmp     MarkBlockWhileCond2   #       WHILE ofs # -1 DO
MarkBlockWhile2:
       movl    (%esi,%ebx),%eax      #          new := MEM(base+ofs);
       
       testl   %eax,%eax             #          IF (new # NIL)
       jz      MarkBlockIfEnd2
       
       btsb    $0,-4(%eax)           #          &  ~ISMARKED(new-4) THEN
       jc      MarkBlockIfEnd2
       
       movl    %edx,(%esi,%ebx)      #             MEM(base+ofs) := last;
       movl    %edi,-4(%ebp)         #             MEM(act-4)    := desc;
       movl    %ebp,%edx             #             last          := act;
       movl    %eax,%ebp             #             act           := new;
       call    MarkABlock            #             MarkABlock;
       movl    %ebp,%eax             #             new           := act;
       movl    %edx,%ebp             #             act           := last;
       movl    -4(%ebp),%edi         #             desc          := MEM(act-4);
       movl    (%edi),%ebx           #             ofs           := MEM(desc);
       movl    (%esi,%ebx),%edx      #             last          := MEM(base+ofs);
       movl    %eax,(%esi,%ebx)      #             MEM(base+ofs) := new;
MarkBlockIfEnd2:                     #          END; (* IF *)

       addl    $4,%edi               #          INC(desc,4);
       movl    (%edi),%ebx           #          ofs := MEM(desc);
       
MarkBlockWhileCond2:                 #       END; (* WHILE ofs # -1 *)
       cmpl    $-1,%ebx
       jnz     MarkBlockWhile2

       movl    (%esp),%edi           #       desc := TOP();
       addl    8(%edi),%esi          #       INC(base,MEM(desc+8)); (* elemSize *)
       decl    %ecx                  #       DEC(count);
       jnz     MarkBlockRepeat       #    UNTIL count = 0;
       
       popl    -4(%ebp)              #    POP(MEM(act-4));
       popl    %esi                  #    POP(base);
       popl    %ecx                  #    POP(count);
MarkBlockIfEnd0:                     # END; (* IF ofs # -2 *)
       
MarkBlockDone:
       ret                           # RETURN;

#------------------------------------------------------------------------------
MarkDone:
       popl    %ebp
       popl    %edi
       popl    %esi
       popl    %edx
       popl    %ecx
       popl    %ebx
       popl    %eax	

   "); 
   RESTORE_ROOT_EBP(); 
} /* Mark */

/*****************************************************************************/
void PRE(Sweep)(){ asm("

       pushl   %eax                      # used by some skippers
       pushl   %ebx                      # points always to the current block
       pushl   %ecx                      # points to the last block to be set free
       pushl   %edx                      # points to the last block set free
       pushl   %esi                      # holds the return address for a skipper
       pushl   %edi                      # holds the tag of the current block
       pushl   $SweepDone                # the default return address for the sentinel

       movl    _HeapStart,%ebx
       leal	4(%ebx),%edx
       addl    $12,%ebx

#------------------------------------------------------------------------------------------------
SweepHeadSearch:                         # let us look for a first unmarked block...
       movl    $SweepHeadLoop,%esi       # skipper default return address
SweepHeadLoop:
       btrl    $0,-4(%ebx)               # block marked? ...reset mark
       jnc     SweepHeadFound            # block was not marked --> further unmarked blocks?
       movl    -4(%ebx),%edi             # load tag
       jmp     -4(%edi)                  # call skipper

SweepHeadFound:
       movl    %ebx,%ecx                 # remember head
       movl    $SweepFreeEnd,(%esp)      # sentinel alternate return address
       movl    $SweepFreeLoop,%esi       # skipper alternate return address
SweepFreeNext:
       movl    -4(%ebx),%edi             # load tag
       jmp     -4(%edi)                  # call skipper
SweepFreeLoop:
       btrl    $0,-4(%ebx)               # is this block also marked? ...reset mark
       jnc     SweepFreeNext             # this block was not marked --> continue search

       # we've reached a marked block: all previous blocks starting from head are to be set free
       movl    %ebx,%eax
       subl    %ecx,%eax                 # eax = blocksize of head
       cmpl    $8,%eax                   # eax>8 ?
       ja      SweepFreeLargeBlock       # yes -->

       # we're freeing a small block (hoping the blocksize's not < 8 ;-)
       movl    $_B8$D,-4(%ecx)           # this is a small free block
       movl    %ecx,(%edx)               # link last free block to head
       movl    %ecx,%edx                 # head is now the last free block

       movl    $SweepDone,(%esp)         # sentinel default return target
       movl    $SweepHeadLoop,%esi       # skipper default return target
       movl    -4(%ebx),%edi             # load tag
       jmp     -4(%edi)                  # call skipper

SweepFreeLargeBlock: # we're freeing a standard block
       movl    $_FB$D,-4(%ecx)           # descriptor for a standard block...
       movl    %eax,4(%ecx)              # ...of this size
       movl    %ecx,(%edx)               # link last free block to head
       movl    %ecx,%edx                 # head is now the last free block
       
       movl    $SweepDone,(%esp)         # sentinel default return target
       movl    $SweepHeadLoop,%esi       # skipper default return target
       movl    -4(%ebx),%edi             # load tag
       jmp     -4(%edi)                  # call skipper


SweepFreeEnd:
       # we've reached the sentinel: all blocks starting from head are to be set free
       movl    %ebx,%eax
       subl    %ecx,%eax                 # eax = blocksize of head
       cmpl    $8,%eax                   # eax>8 ?
       jg      SweepFreeLargeLastBlock   # yes -->

       # we're freeing a small block (hoping the blocksize's not < 8 ;-)
       movl    $_B8$D,-4(%ecx)           # this is a small free block
       jmp     SweepLinkLast
       
SweepFreeLargeLastBlock: # we're freeing a standard block
       movl    $_FB$D,-4(%ecx)           # descriptor for a standard block...
       movl    %eax,4(%ecx)              # ...of this size

SweepLinkLast:
       movl    %ecx,(%edx)               # link last free block to head
       movl    %ebx,(%ecx)               # link head to sentinel

#------------------------------------------------------------------------------------------------
SweepDone:
       movl    _HeapEnd,%eax
       movl    $_ZB$D,-4(%eax)
       movl    $0,(%eax)
       
       popl    %edi
       popl    %esi
       popl    %edx
       popl    %ecx
       popl    %ebx
       popl    %eax
        
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

