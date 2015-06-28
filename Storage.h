#ifdef ELF
#define PRE(x) _##x
#else
#define PRE(x) x
#endif

typedef void (*tAllocFailHandler)(unsigned size, unsigned nofAttemps);
tAllocFailHandler PRE(SetAllocFailHandler)(tAllocFailHandler proc);

extern void *tHeapInfo$D; 
typedef struct{
   unsigned Start;
   unsigned End;
   unsigned TotalBytes;
   unsigned TotalFreeBytes;
   unsigned MaxFreeBytes;
   unsigned NofFreeBlocks;
} tHeapInfo;
void PRE(GetInfo)(void *inf$D, tHeapInfo *inf);
void PRE(DumpHeap)();

unsigned PRE(Alloc)(unsigned size);
void PRE(Free)(unsigned adr, unsigned size);

void PRE($staticNEW)(unsigned *var, unsigned size, unsigned tdescAddr, unsigned initAddr);
void PRE($openNEW)(unsigned *var, unsigned elemSize, unsigned tdescAddr, unsigned initAddr, unsigned nofLens, ...);
void PRE(SYSTEM$NEW)(unsigned *var, unsigned size);

void PRE(MarkBlock)(unsigned block); 
void PRE(MarkAll)(); 

void PRE(Mark)(); 
void PRE(Sweep)(); 	 
void PRE(GC)(); 

int PRE(ChangeHeapSize)(int change); 

void PRE(Storage$I)();
