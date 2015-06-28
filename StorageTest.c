#include <stdlib.h>
#include "Storage.h"

#define MaxNofElems 100
#define MinSize     1
#define MaxSize     1024

typedef struct{
   char *ptr;
   int  size;
   char val;
} tElem;

tElem arr[MaxNofElems];

/*****************************************************************************/
unsigned HeapAvail(){
   tHeapInfo inf;
   
   GetInfo(tHeapInfo$D,&inf); 
   
   return inf.MaxFreeBytes; 
} /* HeapAvail */

/*****************************************************************************/
void PrintInfo(){
   tHeapInfo inf;
   
   DumpHeap(); 
   GetInfo(tHeapInfo$D,&inf); 

   printf("Start          = %i\n",inf.Start         ); 
   printf("End            = %i\n",inf.End           ); 
   printf("TotalBytes     = %i\n",inf.TotalBytes    ); 
   printf("TotalFreeBytes = %i\n",inf.TotalFreeBytes); 
   printf("MaxFreeBytes   = %i\n",inf.MaxFreeBytes  ); 
   printf("NofFreeBlocks  = %i\n",inf.NofFreeBlocks ); 
} /* PrintInfo */

/*****************************************************************************/
void InitElems(){
   int i;

   for (i=0; i<MaxNofElems; i++){
      arr[i].ptr = NULL; 
   } /* for */
} /* InitElems */

/*****************************************************************************/
void TestElem(int idx){
   int i,n;
   char *ptr, val;
   
   ptr = arr[idx].ptr; 
   if (ptr!=NULL){
      val = arr[idx].val; n = arr[idx].size; 
      ptr -= 4;
      for (i=0; i<n; i++){
         if (ptr[i] != val){
            printf("invalid heap content at pos %i -> %i\n",i,(int)ptr[i]); 
            printf("ptr  = %010i\n",(int)(arr[idx].ptr)); 
            printf("size = %i\n",(int)(arr[idx].size)); 
            printf("val  = %i\n",(int)(arr[idx].val)); 
            exit(1); 
         } /* if */
      } /* for */
   } /* if */
} /* TestElem */

/*****************************************************************************/
void TestElems(){
   int idx;
   
   for (idx=0; idx<MaxNofElems; idx++) TestElem(idx); 
} /* TestElems */

/*****************************************************************************/
void FreeElem(int idx){
   TestElem(idx); 
   Free((unsigned)arr[idx].ptr,arr[idx].size); 
   arr[idx].ptr = NULL; 
/*<<<<<<<<<<<<<<<
   DumpHeap(); 
>>>>>>>>>>>>>>>*/
} /* FreeElem */

/*****************************************************************************/
void AllocElem(int idx){
   unsigned size = MinSize+(unsigned)(random()%(MaxSize-MinSize)); 
   char *ptr, val = (char)random(); 
   
   if (size>HeapAvail()) return; 
   
   ptr = (char*)Alloc(size); 
   arr[idx].ptr  = ptr; 
   arr[idx].size = size; 
   arr[idx].val  = val; 
   
   ptr -= 4;
   while (size--) *ptr++ = val; 
/*<<<<<<<<<<<<<<<
   DumpHeap(); 
>>>>>>>>>>>>>>>*/
} /* AllocElem */

/*****************************************************************************/
void FreeAll(){
   int idx;

   for (idx=0; idx<MaxNofElems; idx++){
      if (arr[idx].ptr!=NULL) FreeElem(idx); 
   } /* for */
} /* FreeAll */

/*****************************************************************************/
void StressTest(){      
   unsigned ActionCount = 0; 
   int idx;
   
   while (1){
      ActionCount++;
      if (ActionCount%(32768)==0){
         printf("\n%i\n",ActionCount); 
         PrintInfo(); 
         TestElems(); 
         FreeAll(); 
/*<<<<<<<<<<<<<<<
         PrintInfo(); 
>>>>>>>>>>>>>>>*/
      } /* if */

      idx = (int)(random()%MaxNofElems); 
      if (arr[idx].ptr!=NULL){
         FreeElem(idx); 
      } /* if */

      AllocElem(idx);    
   } /* while */
} /* StressTest */

/*****************************************************************************/
void main(){
   Storage$I(); 
   
   InitElems(); 
   StressTest(); 
} /* main */

