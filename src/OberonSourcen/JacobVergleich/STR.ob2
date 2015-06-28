MODULE STR;

IMPORT Storage,Strings1,SYSTEM;

TYPE tStr* = POINTER TO ARRAY 500 OF CHAR; 

PROCEDURE^DoLb(VAR s : ARRAY OF CHAR; Len : LONGINT);
PROCEDURE^DoUncapsChar(VAR c : CHAR);
PROCEDURE^UNCAP(c : CHAR) : CHAR;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE MinC(a, b : LONGINT) : LONGINT;
BEGIN (* MinC *)
 IF a<b
    THEN RETURN a;
    ELSE RETURN b;
 END; (* IF *)
END MinC;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Compare*(s1, s2 : ARRAY OF CHAR) : LONGINT;
BEGIN (* Compare *)
 RETURN Strings1.compare(s1,s2);
END Compare;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Length*(VAR s : ARRAY OF CHAR) : LONGINT;
VAR i : LONGINT; 
BEGIN (* Length *)
 FOR i:=0 TO LEN(s) DO
  IF s[i]=0X THEN RETURN i; END; (* IF *)
 END; (* FOR *)
 RETURN LEN(s);
END Length;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Concat*(VAR r : ARRAY OF CHAR; s1, s2 : ARRAY OF CHAR);
BEGIN (* Concat *)
 Strings1.Concat(s1,s2,r);
END Concat;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Append*(VAR r : ARRAY OF CHAR; s : ARRAY OF CHAR);
BEGIN (* Append *)
 Strings1.Append(r,s);
END Append;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Copy*(VAR r : ARRAY OF CHAR; s : ARRAY OF CHAR);
BEGIN (* Copy *)
 Strings1.Assign(r,s);
END Copy;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Slice*(VAR r : ARRAY OF CHAR; s : ARRAY OF CHAR; p, l : LONGINT);
BEGIN (* Slice *)
 Strings1.Copy(s,p,l,r);
END Slice;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Pos*(s, p : ARRAY OF CHAR) : LONGINT;
VAR
   pos : LONGINT;
BEGIN (* Pos *)
 pos:=Strings1.pos(p,s);
 IF pos>LEN(s)
    THEN RETURN MAX(LONGINT);
    ELSE RETURN pos;
 END; (* IF *)
END Pos;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Prepend*(VAR s1 : ARRAY OF CHAR; s2 : ARRAY OF CHAR);
BEGIN (* Prepend *)
 Strings1.Concat(s2,s1,s1);
END Prepend;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Insert*(VAR r : ARRAY OF CHAR; s : ARRAY OF CHAR; p : LONGINT);
BEGIN (* Insert *)
 Strings1.Insert(s,r,p);
END Insert;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Delete*(VAR r : ARRAY OF CHAR; p, l : LONGINT);
BEGIN (* Delete *)
 Strings1.Delete(r,p,l);
END Delete;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE DoString*(VAR s : ARRAY OF CHAR; Len : LONGINT; c : CHAR);
VAR
   i, h : LONGINT;
BEGIN (* DoString *)
 IF Len=0
    THEN s[0]:=0X;
    ELSE FOR i:=0 TO MinC(LEN(s),Len) DO
          s[i]:=c;
         END; (* FOR i *)
         IF Len<LEN(s) THEN s[Len]:=0X; END; (* IF *)
 END; (* IF Len=0 *)
END DoString;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE DoRept*(VAR s : ARRAY OF CHAR; Len : LONGINT; t : ARRAY OF CHAR);
VAR
   src, dst, high, max : LONGINT;
BEGIN (* DoRept *)
 IF (Len=0) OR (t[0]=0X) THEN s[0]:=0X; RETURN; END; (* IF *)

 dst:=0; high:=LEN(s); max:=Length(t)-1;
 LOOP
  FOR src:=0 TO max DO
   IF (dst>high) OR (dst>=Len) THEN EXIT; END; (* IF *)
   s[dst]:=t[src]; INC(dst);
  END; (* FOR *)
 END; (* LOOP *)
 s[dst]:=0X;
END DoRept;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE DoFillLb*(VAR s : ARRAY OF CHAR; Len : LONGINT; c : CHAR);
VAR
   i, h : LONGINT;
BEGIN (* DoFillLb *)
 i:=0; h:=LEN(s);
 WHILE (i<=h) & (i<Len) & (s[i]#0X) DO
  INC(i);
 END; (* WHILE *)
 WHILE (i<=h) & (i<Len) DO
  s[i]:=c;
  INC(i);
 END; (* WHILE *)
 IF i<=h THEN s[i]:=0X; END; (* IF *)
END DoFillLb;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE DoFillRb*(VAR s : ARRAY OF CHAR; Len : LONGINT; c : CHAR);
VAR
   i, j, sLen : LONGINT;
BEGIN (* DoFillRb *)
 IF Len>=LEN(s)+1 THEN Len:=LEN(s); END; (* IF *)
 sLen:=Length(s);
 IF Len<sLen
    THEN Delete(s,0,sLen-Len);
 ELSIF Len>sLen
    THEN i:=Len; j:=sLen;
         WHILE (i>0) & (j>0) DO
          DEC(i); DEC(j);
          s[i]:=s[j];
         END; (* WHILE *)
         WHILE i>0 DO
          DEC(i);
          s[i]:=c;
         END; (* WHILE *)
         IF Len<LEN(s) THEN s[Len]:=0X; END; (* IF *)
 END; (* IF *)
END DoFillRb;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE DoFillMb*(VAR s : ARRAY OF CHAR; Len : LONGINT; c : CHAR);
VAR
   i, j, t0, tn, sLen : LONGINT;
BEGIN (* DoFillMb *)
 IF Len>LEN(s) THEN Len:=LEN(s); END; (* IF *)
 sLen:=Length(s);
 IF sLen=0
    THEN DoString(s,Len,c);
 ELSIF sLen=Len
    THEN RETURN;
 ELSIF sLen>Len
    THEN DoLb(s,Len);
    ELSE t0:=(Len-sLen) DIV 2;
         tn:=t0+sLen-1;
         j:=sLen-1;

         i:=tn;
         WHILE i>t0 DO
          s[i]:=s[j]; DEC(j); DEC(i);
         END; (* WHILE *)
         s[i]:=s[j];

         IF t0>0
            THEN FOR i:=0 TO t0-1 DO
                  s[i]:=c;
                 END; (* FOR i *)
         END; (* IF t0>0 *)
         FOR i:=tn+1 TO Len-1 DO
          s[i]:=c;
         END; (* FOR i *)
         IF Len<LEN(s) THEN s[Len]:=0X; END; (* IF *)
 END; (* IF Length(s)>Len *)
END DoFillMb;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE DoLb*(VAR s : ARRAY OF CHAR; Len : LONGINT);
BEGIN (* DoLb *)
 DoFillLb(s,Len,' ');
END DoLb;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE DoRb*(VAR s : ARRAY OF CHAR; Len : LONGINT);
BEGIN (* DoRb *)
 DoFillRb(s,Len,' ');
END DoRb;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE DoMb*(VAR s : ARRAY OF CHAR; Len : LONGINT);
BEGIN (* DoMb *)
 DoFillMb(s,Len,' ');
END DoMb;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE DoCaps*(VAR s : ARRAY OF CHAR);
VAR
   i : LONGINT;
BEGIN (* DoCaps *)
 i:=0;
 WHILE (i<LEN(s)) & (s[i]#0X) DO
  s[i]:=CAP(s[i]);
  INC(i);
 END; (* WHILE *)
END DoCaps;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE DoCapsChar*(VAR c : CHAR);
BEGIN (* DoCapsChar *)
 c:=CAP(c);
END DoCapsChar;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE DoUncaps*(VAR s : ARRAY OF CHAR);
VAR
   i : LONGINT;
BEGIN (* DoUncaps *)
 i:=0;
 WHILE (i<LEN(s)) & (s[i]#0X) DO
  DoUncapsChar(s[i]);
  INC(i);
 END; (* WHILE *)
END DoUncaps;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE DoUncapsChar*(VAR c : CHAR);
BEGIN (* DoUncapsChar *)
 c:=UNCAP(c);
END DoUncapsChar;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE UNCAP*(c : CHAR) : CHAR;
BEGIN (* UNCAP *)
 IF ('A'<=c) & (c<='Z')
    THEN RETURN CHR(ORD(c)+32);
    ELSE RETURN c;
 END; (* IF *)
END UNCAP;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE DoKillSpaces*(VAR s : ARRAY OF CHAR);
VAR
   i : LONGINT;
BEGIN (* DoKillSpaces *)
 i:=0;
 WHILE (i<LEN(s)) & (s[i]#0X) DO
  IF s[i]=' '
     THEN Delete(s,i,1);
     ELSE INC(i);
  END; (* IF *)
 END; (* WHILE *)
END DoKillSpaces;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE DoKillLeadingSpaces*(VAR s : ARRAY OF CHAR);
BEGIN (* DoKillLeadingSpaces *)
 WHILE s[0]=' ' DO
  Delete(s,0,1);
 END; (* WHILE *)
END DoKillLeadingSpaces;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE DoKillTrailingSpaces*(VAR s : ARRAY OF CHAR);
VAR
   i : LONGINT;
BEGIN (* DoKillTrailingSpaces *)
 i:=Length(s);
 LOOP
  IF i=0 THEN EXIT; END; (* IF *)
  DEC(i);
  IF s[i]#' ' THEN EXIT; END; (* IF *)
  s[i]:=0X;
 END; (* LOOP *)
END DoKillTrailingSpaces;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE DoKillLeadTrailSpaces*(VAR s : ARRAY OF CHAR);
BEGIN (* DoKillLeadTrailSpaces *)
 DoKillLeadingSpaces(s);
 DoKillTrailingSpaces(s);
END DoKillLeadTrailSpaces;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE InsertBlanks*(VAR s : ARRAY OF CHAR);
VAR
   i : LONGINT;
BEGIN (* InsertBlanks *)
 i:=1;
 WHILE i<Length(s) DO
  Insert(s,' ',i);
  INC(i,2);
 END; (* WHILE *)
END InsertBlanks;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Conc1*(VAR s : ARRAY OF CHAR; s1 : ARRAY OF CHAR);
BEGIN (* Conc1 *)
 Copy(s,s1);
END Conc1;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Conc2*(VAR s : ARRAY OF CHAR; s1, s2 : ARRAY OF CHAR);
BEGIN (* Conc2 *)
 Copy(s,s1);
 Append(s,s2);
END Conc2;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Conc3*(VAR s : ARRAY OF CHAR; s1, s2, s3 : ARRAY OF CHAR);
BEGIN (* Conc3 *)
 Copy(s,s1);
 Append(s,s2);
 Append(s,s3);
END Conc3;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Conc4*(VAR s : ARRAY OF CHAR; s1, s2, s3, s4 : ARRAY OF CHAR);
BEGIN (* Conc4 *)
 Copy(s,s1);
 Append(s,s2);
 Append(s,s3);
 Append(s,s4);
END Conc4;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Conc5*(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5 : ARRAY OF CHAR);
BEGIN (* Conc5 *)
 Copy(s,s1);
 Append(s,s2);
 Append(s,s3);
 Append(s,s4);
 Append(s,s5);
END Conc5;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Conc6*(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5, s6 : ARRAY OF CHAR);
BEGIN (* Conc6 *)
 Copy(s,s1);
 Append(s,s2);
 Append(s,s3);
 Append(s,s4);
 Append(s,s5);
 Append(s,s6);
END Conc6;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Conc7*(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5, s6, s7 : ARRAY OF CHAR);
BEGIN (* Conc7 *)
 Copy(s,s1);
 Append(s,s2);
 Append(s,s3);
 Append(s,s4);
 Append(s,s5);
 Append(s,s6);
 Append(s,s7);
END Conc7;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Conc8*(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5, s6, s7, s8 : ARRAY OF CHAR);
BEGIN (* Conc8 *)
 Copy(s,s1);
 Append(s,s2);
 Append(s,s3);
 Append(s,s4);
 Append(s,s5);
 Append(s,s6);
 Append(s,s7);
 Append(s,s8);
END Conc8;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Conc9*(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5, s6, s7, s8, s9 : ARRAY OF CHAR);
BEGIN (* Conc9 *)
 Copy(s,s1);
 Append(s,s2);
 Append(s,s3);
 Append(s,s4);
 Append(s,s5);
 Append(s,s6);
 Append(s,s7);
 Append(s,s8);
 Append(s,s9);
END Conc9;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Conc10*(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5, s6, s7, s8, s9, s10 : ARRAY OF CHAR);
BEGIN (* Conc10 *)
 Copy(s,s1);
 Append(s,s2);
 Append(s,s3);
 Append(s,s4);
 Append(s,s5);
 Append(s,s6);
 Append(s,s7);
 Append(s,s8);
 Append(s,s9);
 Append(s,s10);
END Conc10;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE App1*(VAR s : ARRAY OF CHAR; s1 : ARRAY OF CHAR);
BEGIN (* App1 *)
 Append(s,s1);
END App1;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE App2*(VAR s : ARRAY OF CHAR; s1, s2 : ARRAY OF CHAR);
BEGIN (* App2 *)
 Append(s,s1);
 Append(s,s2);
END App2;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE App3*(VAR s : ARRAY OF CHAR; s1, s2, s3 : ARRAY OF CHAR);
BEGIN (* App3 *)
 Append(s,s1);
 Append(s,s2);
 Append(s,s3);
END App3;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE App4*(VAR s : ARRAY OF CHAR; s1, s2, s3, s4 : ARRAY OF CHAR);
BEGIN (* App4 *)
 Append(s,s1);
 Append(s,s2);
 Append(s,s3);
 Append(s,s4);
END App4;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE App5*(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5 : ARRAY OF CHAR);
BEGIN (* App5 *)
 Append(s,s1);
 Append(s,s2);
 Append(s,s3);
 Append(s,s4);
 Append(s,s5);
END App5;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE App6*(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5, s6 : ARRAY OF CHAR);
BEGIN (* App6 *)
 Append(s,s1);
 Append(s,s2);
 Append(s,s3);
 Append(s,s4);
 Append(s,s5);
 Append(s,s6);
END App6;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE App7*(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5, s6, s7 : ARRAY OF CHAR);
BEGIN (* App7 *)
 Append(s,s1);
 Append(s,s2);
 Append(s,s3);
 Append(s,s4);
 Append(s,s5);
 Append(s,s6);
 Append(s,s7);
END App7;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE App8*(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5, s6, s7, s8 : ARRAY OF CHAR);
BEGIN (* App8 *)
 Append(s,s1);
 Append(s,s2);
 Append(s,s3);
 Append(s,s4);
 Append(s,s5);
 Append(s,s6);
 Append(s,s7);
 Append(s,s8);
END App8;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE App9*(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5, s6, s7, s8, s9 : ARRAY OF CHAR);
BEGIN (* App9 *)
 Append(s,s1);
 Append(s,s2);
 Append(s,s3);
 Append(s,s4);
 Append(s,s5);
 Append(s,s6);
 Append(s,s7);
 Append(s,s8);
 Append(s,s9);
END App9;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE App10*(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5, s6, s7, s8, s9, s10 : ARRAY OF CHAR);
BEGIN (* App10 *)
 Append(s,s1);
 Append(s,s2);
 Append(s,s3);
 Append(s,s4);
 Append(s,s5);
 Append(s,s6);
 Append(s,s7);
 Append(s,s8);
 Append(s,s9);
 Append(s,s10);
END App10;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE IsCapsedStr*(s : ARRAY OF CHAR) : BOOLEAN;
VAR
   i : LONGINT;
BEGIN (* IsCapsedStr *)
 i:=0;
 WHILE (i<LEN(s)) & (s[i]#0X) DO
  IF (s[i]<'A') OR ('Z'<s[i]) THEN RETURN FALSE; END; (* IF *)
  INC(i);
 END; (* WHILE *)
 RETURN TRUE;
END IsCapsedStr;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE HasPrefix*(s, p : ARRAY OF CHAR) : BOOLEAN;
VAR
   t : ARRAY 200 OF CHAR;
BEGIN (* HasPrefix *)
 Slice(t,s,0,Length(p));
 RETURN (Compare(t,p)=0);
END HasPrefix;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Reverse*(VAR s : ARRAY OF CHAR);
VAR
   i, j : LONGINT;
   c    : CHAR;
BEGIN (* Reverse *)
 i:=0; j:=Length(s)-1;
 WHILE i<j DO
  c:=s[i]; s[i]:=s[j]; s[j]:=c;
  INC(i); DEC(j);
 END; (* WHILE *)
END Reverse;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE StrCard*(VAR s : ARRAY OF CHAR; val : LONGINT);
VAR
   dst : LONGINT;
BEGIN (* StrCard *)
 dst:=0;
 LOOP
  IF dst>LEN(s) THEN EXIT; END; (* IF *)
  s[dst] := CHR(48+(val MOD 10)); INC(dst);
  val    := val DIV 10;
  IF val=0 THEN EXIT; END; (* IF *)
 END; (* LOOP *)
 s[dst]:=0X;
 Reverse(s);
END StrCard;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE StrNum*(VAR s : ARRAY OF CHAR; val, width : LONGINT);
BEGIN (* StrNum *)
 StrCard(s,val);
 IF Length(s)>width
    THEN DoString(s,width,'*');
    ELSE DoFillRb(s,width,'0');
 END; (* IF *)
END StrNum;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE CardVal*(s : ARRAY OF CHAR) : LONGINT; 
VAR
   i, v : LONGINT; 
BEGIN (* CardVal *)
 v:=0; 
 FOR i:=0 TO LEN(s) DO
  CASE s[i] OF
  |0X      : RETURN v; 
  |'0'..'9': v:=10*v+ORD(s[i])-48; 
  ELSE 
  END; (* CASE *)
 END; (* FOR *)
 RETURN v; 
END CardVal;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Alloc*(s : ARRAY OF CHAR) : tStr; 
VAR i,n:LONGINT; result:tStr;
BEGIN (* Alloc *)
 n:=Length(s); Storage.ALLOCATE(result,n+1); 
 FOR i:=0 TO n-1 DO result^[i]:=s[i]; END; (* FOR *)
 result^[n]:=0X; 
 RETURN result; 
END Alloc;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Dup*(s : tStr) : tStr;
VAR i,n:LONGINT; result:tStr;
BEGIN (* Dup *)
 IF s=NIL THEN RETURN NIL; END; (* IF *)

 n:=Length(s^); Storage.ALLOCATE(result,n+1); 
 FOR i:=0 TO n-1 DO result^[i]:=s^[i]; END; (* FOR *)
 result^[n]:=0X; 
 RETURN result; 
END Dup;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Free*(VAR s : tStr);    
VAR i:LONGINT; 
BEGIN (* Free *)
 IF s#NIL THEN Storage.DEALLOCATE(s,1+Length(s^)); END; (* IF *)
END Free;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE AppS*(s : tStr; t : ARRAY OF CHAR) : tStr;  
VAR i,sLen,tLen:LONGINT; tmp:tStr;
BEGIN (* AppS *)
 IF (s=NIL) OR (s^[0]=0X) THEN RETURN Alloc(t); END; (* IF *)

 tLen:=Length(t); sLen:=Length(s^); 
 Storage.ALLOCATE(tmp,sLen+tLen+1); 
 FOR i:=0 TO sLen-1 DO tmp^[i]:=s^[i]; END; (* FOR *)
 FOR i:=0 TO tLen-1 DO tmp^[sLen+i]:=t[i]; END; (* FOR *)
 tmp^[sLen+tLen]:=0X; 
 RETURN tmp; 
END AppS;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE AppendS*(VAR s : tStr; t : ARRAY OF CHAR);  
VAR i,sLen,tLen:LONGINT; tmp:tStr;
BEGIN (* AppendS *)
 tLen:=Length(t); 
 IF tLen<=0 THEN RETURN; END; (* IF *)
 IF s=NIL THEN s:=Alloc(t); RETURN; END; (* IF *)
 
 sLen:=Length(s^); 
 Storage.ALLOCATE(tmp,sLen+tLen+1); 
 FOR i:=0 TO sLen-1 DO tmp^[i]:=s^[i]; END; (* FOR *)
 FOR i:=0 TO tLen-1 DO tmp^[sLen+i]:=t[i]; END; (* FOR *)
 tmp^[sLen+tLen]:=0X; 
 Storage.DEALLOCATE(s,1+sLen); 
 s:=tmp; 
END AppendS;

(*------------------------------------------------------------------------------------------------------------------------------*)
END STR.

