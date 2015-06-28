MODULE Str;
IMPORT SL:=SysLib, SYS:=SYSTEM;

TYPE T* = POINTER TO ARRAY OF CHAR;
VAR nullCh:T; HexDigits:ARRAY 17 OF CHAR; 
VAR t:ARRAY 5 OF CHAR; 

PROCEDURE^Length*(s:ARRAY OF CHAR):LONGINT; 

(************************************************************************************************************************)
PROCEDURE Alloc*(s:ARRAY OF CHAR):T;
VAR t:T; n:LONGINT; 
BEGIN (* Alloc *)
 IF s[0]=0X THEN RETURN nullCh; END; (* IF *)
 
 n:=Length(s); 
 NEW(t,n+1); 
 SYS.MOVE(SYS.ADR(s),SYS.ADR(t^),n); 
 t[n]:=0X; 
 
 RETURN t; 
END Alloc;

(************************************************************************************************************************)
PROCEDURE Length*(s:ARRAY OF CHAR):LONGINT; 
VAR i:LONGINT; 
BEGIN (* Length *)
 FOR i:=0 TO LEN(s)-1 DO
  IF s[i]=0X THEN RETURN i; END; (* IF *)
 END; (* FOR *)               
 RETURN LEN(s); 
END Length;

(************************************************************************************************************************)
PROCEDURE Append*(VAR s:ARRAY OF CHAR; t:ARRAY OF CHAR);
VAR src,dst:LONGINT; c:CHAR; 
BEGIN (* Append *)   
 dst:=0; 
 WHILE s[dst]#0X DO
  INC(dst); 
  IF dst>=LEN(s) THEN RETURN; END; (* IF *)
 END; (* WHILE *)	      
 
 src:=0; 
 LOOP
  IF dst>=LEN(s) THEN s[LEN(s)-1]:=0X; RETURN; END; (* IF *)
  IF src>=LEN(t) THEN s[dst]:=0X; RETURN; END; (* IF *)
  c:=t[src]; s[dst]:=c; 
  IF c=0X THEN RETURN;END; (* IF *)
  INC(src); INC(dst); 
 END; (* LOOP *)
END Append;

(************************************************************************************************************************)
PROCEDURE Caps*(VAR s:ARRAY OF CHAR);
VAR i:LONGINT; c:CHAR; 
BEGIN (* Caps *)
 FOR i:=0 TO LEN(s)-1 DO
  c:=s[i]; 
  IF c=0X THEN RETURN; END; (* IF *)
  s[i]:=CAP(c); 
 END; (* FOR *)
END Caps;

(************************************************************************************************************************)
PROCEDURE CharPos*(s:ARRAY OF CHAR; c:CHAR):LONGINT; 
VAR i:LONGINT; 
BEGIN (* CharPos *)				     
 FOR i:=0 TO LEN(s)-1 DO
  IF s[i]=c THEN RETURN i; END; (* IF *)
 END; (* FOR *)		   
 RETURN -1; 
END CharPos;

(************************************************************************************************************************)
PROCEDURE Concat*(VAR r:ARRAY OF CHAR; s1,s2:ARRAY OF CHAR);
VAR src,dst:LONGINT; c:CHAR; 
BEGIN (* Concat *)
 dst:=0; src:=0; 
 LOOP
  IF dst>=LEN(r) THEN r[LEN(r)-1]:=0X; RETURN; END; (* IF *)
  IF src>=LEN(s1) THEN EXIT; END; (* IF *)
  c:=s1[src]; r[dst]:=c; 
  IF c=0X THEN EXIT; END; (* IF *)
  INC(src); INC(dst); 
 END; (* LOOP *)

 src:=0; 
 LOOP
  IF dst>=LEN(r) THEN r[LEN(r)-1]:=0X; RETURN; END; (* IF *)
  IF src>=LEN(s2) THEN r[dst]:=0X; RETURN; END; (* IF *)
  c:=s2[src]; r[dst]:=c; 
  IF c=0X THEN RETURN;END; (* IF *)
  INC(src); INC(dst); 
 END; (* LOOP *)
END Concat;

(************************************************************************************************************************)
PROCEDURE Delete*(VAR r:ARRAY OF CHAR; p,l:LONGINT);
VAR i,len:LONGINT; 
BEGIN (* Delete *)
 IF (l<=0) OR (p<0) THEN RETURN; END; (* IF *)
 
 len:=Length(r); 
 IF p>=len THEN RETURN; END; (* IF *)
 
 IF p+l>=len THEN r[p]:=0X; RETURN; END; (* IF *)
 FOR i:=p+l TO len-1 DO r[i-l]:=r[i]; END; (* FOR *)
 r[len-l]:=0X; 
END Delete;

(************************************************************************************************************************)
PROCEDURE IntToStr*(v:LONGINT; VAR s:ARRAY OF CHAR; base:LONGINT; VAR ok:BOOLEAN);
VAR c:CHAR; negative:BOOLEAN; dst:LONGINT; buf:ARRAY 20 OF CHAR; 
BEGIN (* IntToStr *)
 ok:=FALSE; 
 IF base>16 THEN RETURN; END; (* IF *)
 
 negative:=(v<0); v:=ABS(v); dst:=LEN(buf)-1; buf[LEN(buf)-1]:=0X; 
 REPEAT
  DEC(dst); buf[dst]:=HexDigits[v MOD base]; v:=v DIV base; 
 UNTIL v=0;
 
 IF negative THEN DEC(dst); buf[dst]:='-'; END; (* IF *)                 
 IF LEN(s)-1 < LEN(buf)-dst THEN RETURN; END; (* IF *)
 SYS.MOVE(SYS.ADR(buf[dst]),SYS.ADR(s),LEN(buf)-dst+1); 
 ok:=TRUE; 
END IntToStr;

(************************************************************************************************************************)
PROCEDURE StrToInt*(s:ARRAY OF CHAR):LONGINT; 
VAR v,i:LONGINT; c:CHAR; 
BEGIN (* StrToInt *)
 v:=0; i:=0; 
 LOOP
  IF i>=LEN(s) THEN EXIT; END; (* IF *)
  c:=s[i]; 
  IF c=0X THEN EXIT; END; (* IF *)
  IF ('0'<=c) & (c<='9') THEN v:=10*v+ORD(c)-48; END; (* IF *)
  INC(i); 
 END; (* LOOP *)
 RETURN v; 
END StrToInt;

(************************************************************************************************************************)
PROCEDURE FixRealToStr*(v:LONGREAL; prec:LONGINT; VAR s:ARRAY OF CHAR; VAR ok:BOOLEAN);
CONST mantlen=30;
VAR mant,decpt,sign,start,src,dst:LONGINT; buf:ARRAY 500 OF CHAR; 
CONST frac=LEN(buf) DIV 2;
BEGIN (* FixRealToStr *)
 ok:=FALSE; 
 s[0]:=0X; 
 IF (prec<0) OR (frac+prec>=LEN(buf)) THEN RETURN; END; (* IF *)
 
 mant:=SL.ecvt(v,mantlen,decpt,sign); 

 SYS.MOVE(mant,SYS.ADR(buf),mantlen+1); 

 IF decpt<=0 THEN 
    IF frac-decpt+mantlen >= LEN(buf) THEN RETURN; END; (* IF *)
    start:=frac-1; 
    FOR dst:=start TO frac-decpt-1 DO buf[dst]:='0'; END; (* FOR *)
    SYS.MOVE(mant,SYS.ADR(buf[frac-decpt]),mantlen); 
    FOR dst:=frac-decpt+mantlen TO LEN(buf)-1 DO buf[dst]:='0'; END; (* FOR *)
 ELSE
    start:=frac-decpt; 
    IF start<0 THEN RETURN; END; (* IF *)
    SYS.MOVE(mant,SYS.ADR(buf[start]),mantlen); 
    FOR dst:=start+mantlen TO LEN(buf)-1 DO buf[dst]:='0'; END; (* FOR *)
 END; (* IF *)
 
 dst:=0; 
 IF sign=1 THEN s[dst]:='-'; INC(dst); END; (* IF *)

 FOR src:=start TO frac-1 DO
  IF dst>=LEN(s) THEN RETURN; END; (* IF *)
  s[dst]:=buf[src]; INC(dst); 
 END; (* FOR *)		   
 
 IF dst>=LEN(s) THEN RETURN; END; (* IF *)
 s[dst]:='.'; INC(dst); 
 
 FOR src:=frac TO frac+prec-1 DO
  IF dst>=LEN(s) THEN RETURN; END; (* IF *)
  s[dst]:=buf[src]; INC(dst); 
 END; (* FOR *)
 
 IF dst>=LEN(s) THEN RETURN; END; (* IF *)
 s[dst]:=0X; 
 ok:=TRUE; 
END FixRealToStr;

(************************************************************************************************************************)
PROCEDURE StrToReal*(s:ARRAY OF CHAR; VAR ok:BOOLEAN):LONGREAL;
VAR v:LONGREAL; p,end:LONGINT;
BEGIN (* StrToReal *)
 p:=CharPos(s,'D'); 
 IF p>-1 THEN s[p]:='E'; END; (* IF *)
 
 v:=SL.strtod(SYS.ADR(s),end); DEC(end,SYS.ADR(s)); 
 ok:=(end<LEN(s)) & (s[end]=0X); 
 RETURN v; 
END StrToReal;

(************************************************************************************************************************)
BEGIN (* Str *)
 NEW(nullCh,1); nullCh[0]:=0X; 
 HexDigits:="0123456789ABCDEF";
END Str.
