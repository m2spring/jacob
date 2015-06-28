MODULE In;
IMPORT O:=Out, Str, SL:=SysLib, SYS:=SYSTEM;

VAR Done-:BOOLEAN;

CONST SP         = 20X;
      HT         = 9X;
      LF         = 0AX;
      cMaxStrLen = 4096;

(************************************************************************************************************************)
PROCEDURE Str2Int(s:ARRAY OF CHAR; VAR ok:BOOLEAN):LONGINT;
VAR v,i:LONGINT; c:CHAR; 
    neg:BOOLEAN;
BEGIN (* Str2Int *)
 v:=0; i:=0; 
 ok:=TRUE; neg:=FALSE; 
 IF s[i]='-'
    THEN INC(i); neg:=TRUE;
 END; (* IF *)
 LOOP
  IF i>=LEN(s) THEN ok:=FALSE; EXIT; END; (* IF *)
  c:=s[i]; 
  IF c=0X 
     THEN IF i=0 THEN ok:=FALSE; END; (* IF *)EXIT;
          EXIT;
  END; (* IF *)
  IF ('0'<=c) & (c<='9') 
     THEN v:=10*v+ORD(c)-48; 
     ELSE ok:=FALSE; EXIT;
  END; (* IF *)
  INC(i); 
 END; (* LOOP *)
 IF neg THEN v:=-v; END; (* IF *)
 RETURN v; 
END Str2Int;

(************************************************************************************************************************)
PROCEDURE Char*(VAR ch:CHAR);
VAR dummy:LONGINT; 
BEGIN (* Char *)
 dummy:=SL.read(SL.stdin,SYS.ADR(ch),1);
 Done:=(dummy=1); 
END Char;

(************************************************************************************************************************)
PROCEDURE String*(VAR str:ARRAY OF CHAR);
VAR i, highidx:LONGINT; 
    c         :CHAR; 
BEGIN (* String *)
 Done:=TRUE;
 highidx:=LEN(str)-1; 
 i:=0; 
 Char(c);
 LOOP
  str[i]:=c;
  IF ORD(c)<32 THEN EXIT; END;
  INC(i);
  IF i>highidx THEN DEC(i); Done:=FALSE; EXIT; END;
  Char(c);
 END; (* LOOP *)
 str[i]:=0X;
END String;

(************************************************************************************************************************)
PROCEDURE Int*(VAR i:INTEGER);
VAR s :ARRAY cMaxStrLen OF CHAR; 
    li:LONGINT; 
BEGIN (* Int *)
 i:=0; 
 String(s);
 IF ~Done THEN RETURN; END;
 li:=Str2Int(s,Done);
 IF Done
    THEN IF (MIN(INTEGER)<=li) & (li<=MAX(INTEGER))
            THEN i:=SHORT(li); 
            ELSE Done:=FALSE;  
         END; (* IF *); 
 END; (* IF *)
END Int;

(************************************************************************************************************************)
PROCEDURE Longint*(VAR i:LONGINT);
VAR s :ARRAY cMaxStrLen OF CHAR; 
BEGIN (* Longint *)
 i:=0; 
 String(s);
 IF ~Done THEN RETURN; END;
 i:=Str2Int(s,Done);
END Longint;

(************************************************************************************************************************)
PROCEDURE Real*(VAR x:REAL);
VAR s :ARRAY cMaxStrLen OF CHAR; 
   lr :LONGREAL;
BEGIN (* Real *)
 x:=0; 
 String(s);
 IF ~Done THEN RETURN; END;
 lr:=Str.StrToReal(s,Done);
 IF Done
    THEN IF (MIN(REAL)<=lr) & (lr<=MAX(REAL))
            THEN x:=SHORT(lr); 
            ELSE Done:=FALSE; 
         END; (* IF *) 
 END; (* IF *)
END Real;

(************************************************************************************************************************)
PROCEDURE LongReal*(VAR y:LONGREAL);
VAR s :ARRAY cMaxStrLen OF CHAR; 
BEGIN (* LongReal *)
 y:=0;
 String(s);
 IF ~Done THEN RETURN; END; (* IF *)
 y:=Str.StrToReal(s,Done);
END LongReal;

(************************************************************************************************************************)
BEGIN (* In *)
 Done:=FALSE; 
END In.

