
unsigned Length(char *s, unsigned sLEN);
void Delete(char *str, unsigned strLEN, unsigned inx, unsigned len); 
void DoFillLb(char *s, unsigned sLEN, unsigned len, char c); 
void DoFillRb(char *s, unsigned sLEN, unsigned len, char c); 

unsigned Ptr2Int(unsigned ptr); 
void Int2Dez(int val, char *s, unsigned sLEN); 
void Int2Hex(unsigned val, char *s, unsigned sLEN); 

void OStr(char *s); 
void OStL(char *s, unsigned len); 
void OLn(); 
void OStrLn(char *s); 
void OInt(int v); 
void OIntR(int v, unsigned len); 
void OHex(unsigned v); 
void ONum(unsigned v, unsigned len); 

