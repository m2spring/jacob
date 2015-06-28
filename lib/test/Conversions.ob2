MODULE Conversions;
IMPORT O:=Out, SYS:=SYSTEM, SL:=SysLib, S:=Strings;

VAR digits:ARRAY 17 OF CHAR; 

(************************************************************************************************************************)
PROCEDURE Int2Str*(v:LONGINT; base:SHORTINT; VAR s:ARRAY OF CHAR; VAR ok:BOOLEAN);
VAR c:CHAR; negative:BOOLEAN; dst,tsd:LONGINT; 
BEGIN (* Int2Str *)
 ok:=FALSE; 
 IF base>16 THEN RETURN; END; (* IF *)
 
 negative:=(v<0); v:=ABS(v); dst:=0; 
 REPEAT
  IF dst>=LEN(s) THEN RETURN; END; (* IF *)
  s[dst]:=digits[v MOD base]; v:=v DIV base; INC(dst); 
 UNTIL v=0;
 
 IF negative THEN 
    IF dst>=LEN(s) THEN RETURN; END; (* IF *)
    s[dst]:='-'; INC(dst); 
 END; (* IF *)                 
 
 IF dst>=LEN(s) THEN RETURN; END; (* IF *)
 s[dst]:=0X; 
 
 tsd:=0; 
 WHILE tsd<dst DO
  c:=s[tsd]; s[tsd]:=s[dst]; s[dst]:=c; INC(tsd); DEC(dst);  
 END; (* WHILE *)                                                
 ok:=TRUE; 
END Int2Str;

(************************************************************************************************************************)
PROCEDURE Longreal2Str*(v:LONGREAL; prec:LONGINT; VAR s:ARRAY OF CHAR; VAR ok:BOOLEAN);
VAR buf:ARRAY 30 OF CHAR; decpt,sign:LONGINT; 
BEGIN (* Longreal2Str *)
 SYS.MOVE(SL.ecvt(v,prec,decpt,sign),SYS.ADR(buf),LEN(buf)); 
 IF sign=0 THEN 
    COPY(buf,s); 
 ELSE 
    COPY('-',s); S.Append(s,buf); 
 END; (* IF *)  
 S.Append(s,'DC'); 
 Int2Str(decpt,10,buf,ok); S.Append(s,buf); 
END Longreal2Str;

(************************************************************************************************************************)
PROCEDURE Str2Longreal(s:ARRAY OF CHAR; VAR ok:BOOLEAN):LONGREAL;
VAR v:LONGREAL; end:LONGINT;
BEGIN (* Str2Longreal *)					 
 v:=SL.strtod(SYS.ADR(s),end); DEC(end,SYS.ADR(s)); 
 ok:=(end<LEN(s)) & (s[end]=0X); 
 RETURN v; 
END Str2Longreal;

(************************************************************************************************************************)
BEGIN (* Conversions *)
 digits:="0123456789ABCDEF";
END Conversions.
