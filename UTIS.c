#include "UTIS.h"

/*****************************************************************************/
/*$1*/
unsigned Length(char *s, unsigned sLEN){
   unsigned n = 0;
   
   while (n<sLEN && s[n]!=0) n++;

   return n; 
} /* Length */

/*****************************************************************************/
/*$1*/
void Delete(char *str, unsigned strLEN, unsigned inx, unsigned len){
   unsigned i,L;
   
   if (len==0) return; 
   L = Length(str,strLEN); 
   if (inx>L || L==0) return; 
   if (inx+len>=L){ str[inx] = 0; return; } /* if */
   for (i=inx+len; i<L; i++) str[i-len] = str[i]; 
   str[L-len] = 0;
} /* Delete */

/*****************************************************************************/
/*$1*/
void DoFillLb(char *s, unsigned sLEN, unsigned len, char c){
   unsigned i = 0;

   while (i<sLEN && i<len && s[i]!=0) i++;
   while (i<sLEN && i<len) s[i++] = c; 

   if (i<sLEN) s[i] = 0; 
} /* DoFillLb */       

/*****************************************************************************/
/*$1*/
void DoFillRb(char *s, unsigned sLEN, unsigned len, char c){
   unsigned i,j,sLen;
   
   if (len>sLEN) len = sLEN; 
   sLen = Length(s,sLEN); 

   if (len<sLen){
      Delete(s,sLEN,0,sLen-len); 
   }else if (len>sLen){
      i = len; j = sLen; 
      while (i>0 && j>0) s[--i] = s[--j]; 
      while (i>0) s[--i] = c; 
      if (len<sLEN) s[len] = 0; 
   } /* if */
} /* DoFillRb */

/*****************************************************************************/
/*$1*/
unsigned Ptr2Int(unsigned ptr){
   return ptr; 
} /* Ptr2Int */

/*****************************************************************************/
/*$1*/
void Int2Dez(int val, char *s, unsigned sLEN){
   unsigned j,i=0, isNeg=(val<0); 
   char h;
   
   val = abs(val); 
   
   do{
      if (i>=sLEN) break; 
      s[i++] = 48+(val%10); val /= 10;
   } while (val!=0);
   
   if (isNeg && i<sLEN) s[i++] = '-'; 
   s[i] = 0; 
   
   j = 0; i--;
   while (j<i){ 
      h = s[i]; s[i--] = s[j]; s[j++] = h; 
   } /* while */
} /* Int2Dez */

/*****************************************************************************/
/*$1*/
void Int2Hex(unsigned val, char *s, unsigned sLEN){
   int i;
   
   if (sLEN<9) return; 
   
   s[8] = 0; 
   for (i=7; i>=0; i--){
      s[i] = 48+(val%16); val /= 16;
      if (s[i]>'9') s[i] += 'A'-'9'-1;
   } /* for */
} /* Int2Hex */

/*****************************************************************************/
/*$1*/
void OStr(char *s){
   write(1,s,strlen(s)); 
} /* OStr */

/*****************************************************************************/
/*$1*/
void OStL(char *s, unsigned len){
   unsigned i;
   char buf[200];
   
   if (len>sizeof(buf)) len = sizeof(buf); 
   for (i=0; i<len; i++){
      buf[i] = s[i]; 
      if (s[i]==0) break; 
   } /* for */
   
   DoFillLb(buf,sizeof(buf),len,' '); 
   OStr(buf); 
} /* OStL */

/*****************************************************************************/
/*$1*/
void OLn(){
   OStr("\n"); 
} /* OLn */

/*****************************************************************************/
/*$1*/
void OStrLn(char *s){
   OStr(s); OLn();
} /* OStrLn */

/*****************************************************************************/
/*$1*/
void OInt(int v){
   char buf[20];
   
   Int2Dez(v,buf,sizeof(buf)); OStr(buf); 
} /* OInt */

/*****************************************************************************/
/*$1*/
void OIntR(int v, unsigned len){
   char buf[20];
   
   Int2Dez(v,buf,sizeof(buf)); 
   DoFillRb(buf,sizeof(buf),len,' '); 
   OStr(buf); 
} /* OIntR */

/*****************************************************************************/
/*$1*/
void OHex(unsigned v){
   char buf[20];
   
   Int2Hex(v,buf,sizeof(buf)); OStr(buf); 
} /* OHex */

/*****************************************************************************/
/*$1*/
void ONum(unsigned v, unsigned len){
   char buf[100];

   Int2Dez(v,buf,20); 
   if (strlen(buf)<len) DoFillRb(buf,sizeof(buf),len,'0'); 
   OStr(buf); 
} /* ONum */

