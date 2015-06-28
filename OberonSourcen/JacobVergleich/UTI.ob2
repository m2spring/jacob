MODULE UTI;

IMPORT Base,Idents, RealConv, StringMem, Strings, Strings1, SYSTEM;

PROCEDURE^HexStr2Longcard*(VAR s : Strings.tString; VAR OK : BOOLEAN) : LONGINT;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE IdentOf*(name : ARRAY OF CHAR) : Idents.tIdent;
VAR
   s : Strings.tString;
BEGIN (* IdentOf *)
 Strings.ArrayToString(name,s);
 RETURN Idents.MakeIdent(s);
END IdentOf;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE IdentLength*(Ident : Idents.tIdent) : LONGINT;
BEGIN (* IdentLength *)
 RETURN StringMem.Length(Idents.GetStringRef(Ident));
END IdentLength;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE MakeString*(a : ARRAY OF CHAR) : StringMem.tStringRef;
VAR
   s : Strings.tString;
BEGIN (* MakeString *)
 Strings.ArrayToString(a,s);
 RETURN StringMem.PutString(s);
END MakeString;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE HexStr2Char*(VAR s : Strings.tString; VAR OK : BOOLEAN) : CHAR;
VAR
   v : LONGINT;
BEGIN (* HexStr2Char *)
 v:=HexStr2Longcard(s,OK);
 IF v > ORD(Base.MaxCharOrd)
    THEN OK:=FALSE;
         RETURN CHR(0);
    ELSE RETURN CHR(v);
 END;
END HexStr2Char;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Str2Longcard*(VAR s : Strings.tString; VAR OK : BOOLEAN) : LONGINT;
VAR
   i    : LONGINT;
   d, v : LONGINT;
   a    : ARRAY Strings.cMaxStrLength+1 OF CHAR;
BEGIN (* Str2Longcard *)
 OK:=TRUE;
 Strings.StringToArray(s,a);

 i:=0; v:=0;
 WHILE (i<=LEN(a)) & (a[i]#0X) DO
  d:=ORD(a[i])-48;
  IF v > Base.MinIllegalAbsInt DIV 10 THEN OK:=FALSE; END;
  v:=10*v;
  IF v >= Base.MinIllegalAbsInt-d THEN OK:=FALSE; END;
  INC(v,d);
  INC(i);
 END; (* WHILE *)

 RETURN v;
END Str2Longcard;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE HexStr2Longcard*(VAR s : Strings.tString; VAR OK : BOOLEAN) : LONGINT;
VAR
   i    : LONGINT;
   d, v : LONGINT;
   a    : ARRAY Strings.cMaxStrLength+1 OF CHAR;
BEGIN (* HexStr2Longcard *)
 OK:=TRUE;
 Strings.StringToArray(s,a);

 i:=0; v:=0;
 LOOP
  IF i>=LEN(a) THEN EXIT; END;

  CASE a[i] OF
  |'H','X',0X: EXIT;
  |'0'..'9'  : d:=ORD(a[i])-48;
  |'A'..'F'  : d:=ORD(a[i])-55;
  END; (* CASE *)

  IF v > MAX(LONGINT) DIV 16 THEN OK:=FALSE; END;
  v:=16*v;
  IF v > MAX(LONGINT)-d THEN OK:=FALSE; END;
  INC(v,d);
  INC(i);
 END; (* LOOP *)

 RETURN v;
END HexStr2Longcard;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Str2Real*(VAR s : Strings.tString; VAR OK : BOOLEAN) : LONGREAL;
VAR
   a : ARRAY Strings.cMaxStrLength+1 OF CHAR;
BEGIN (* Str2Real *)
 Strings.StringToArray(s,a);
 RETURN RealConv.Str2Real(a,OK);
END Str2Real;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Str2Longreal*(VAR s : Strings.tString; VAR OK : BOOLEAN) : LONGREAL;
VAR
   i : LONGINT;
   a : ARRAY Strings.cMaxStrLength+1 OF CHAR;
BEGIN (* Str2Longreal *)
 Strings.StringToArray(s,a);

 i:=0;
 LOOP
  IF i>=LEN(a) THEN EXIT; END;

  CASE a[i] OF
  |0X : EXIT;
  |'D': a[i]:='E';
        EXIT;
  ELSE  INC(i);
  END; (* CASE *)
 END; (* LOOP *)

 RETURN RealConv.Str2LongReal(a,OK);
END Str2Longreal;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Reverse*(VAR s : ARRAY OF CHAR; a, b : LONGINT);
VAR
   c : CHAR;
BEGIN (* Reverse *)
 WHILE a<b DO
  c:=s[a]; s[a]:=s[b]; s[b]:=c;
  INC(a); DEC(b);
 END; (* WHILE *)
END Reverse;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Longint2Arr*(v : LONGINT; VAR s : ARRAY OF CHAR);
VAR
   negative : BOOLEAN;
   dst      : LONGINT;
BEGIN (* Longint2Arr *)
 negative:=(v<0); dst:=0; v:=ABS(v); 
 REPEAT
  IF dst<=LEN(s) THEN s[dst]:=CHR(48+(v MOD 10)); INC(dst); END; (* IF *)
  v:=v DIV 10;
 UNTIL v=0;
 IF negative & (dst<=LEN(s)) THEN s[dst]:='-'; INC(dst); END; (* IF *)
 Reverse(s,0,dst-1);
 s[dst]:=0X;
END Longint2Arr;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Real2Arr*(v : REAL; VAR s : ARRAY OF CHAR);
VAR
   done : BOOLEAN;
BEGIN (* Real2Arr *)
 RealConv.Real2Str(v,0,-(Base.FLTDIG-2),s,done);
END Real2Arr;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Longreal2Arr*(v : LONGREAL; VAR s : ARRAY OF CHAR);
VAR
   done : BOOLEAN;
BEGIN (* Longreal2Arr *)
 RealConv.LongReal2Str(v,0,-(Base.DBLDIG-2),s,done);
END Longreal2Arr;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Shortcard2Arr*(v : LONGINT; VAR s : ARRAY OF CHAR);
VAR
   w, dst : LONGINT;
BEGIN (* Shortcard2Arr *)
 dst:=0;
 REPEAT
  w:=v MOD 10;
  IF dst<=LEN(s) THEN s[dst]:=CHR(48+w); INC(dst); END; (* IF *)
  v:=v DIV 10;
 UNTIL v=0;
 Reverse(s,0,dst-1);
 s[dst]:=0X;
END Shortcard2Arr;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Shortcard2ArrHex*(v : LONGINT; VAR s : ARRAY OF CHAR);
VAR
   w, dst : LONGINT;
BEGIN (* Shortcard2ArrHex *)
 dst:=0;
 REPEAT
  w:=v MOD 16;
  IF w>9 THEN INC(w,7); END; (* IF *)
  IF dst<=LEN(s) THEN s[dst]:=CHR(48+w); INC(dst); END; (* IF *)
  v:=v DIV 16;
 UNTIL v=0;
 IF (s[dst-1]>'9') & (dst<=LEN(s)) THEN s[dst]:='0'; INC(dst); END; (* IF *)
 Reverse(s,0,dst-1);
 s[dst]:=0X;
END Shortcard2ArrHex;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Addr2ArrHex*(v : SYSTEM.PTR; VAR s : ARRAY OF CHAR);
VAR
   val    : LONGINT;
   w, dst : LONGINT;
BEGIN (* Addr2ArrHex *)
 val:=SYSTEM.VAL(LONGINT,v);
 dst:=0;
 REPEAT
  w:=val MOD 16;
  IF w>9 THEN INC(w,7); END; (* IF *)
  IF dst<=LEN(s) THEN s[dst]:=CHR(48+w); INC(dst); END; (* IF *)
  val:=val DIV 16;
 UNTIL val=0;
 Reverse(s,0,dst-1);
 s[dst]:=0X;
END Addr2ArrHex;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE MaxLI*(a, b : LONGINT) : LONGINT;
BEGIN (* MaxLI *)
 IF a>b THEN RETURN a; ELSE RETURN b; END; (* IF *)
END MaxLI;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE MaxLI3*(a, b, c : LONGINT) : LONGINT; 
BEGIN (* MaxLI3 *)		      
 IF a>b THEN 
    IF a>c THEN RETURN a; END; (* IF *)
 ELSE 
    IF b>c THEN RETURN b; END; (* IF *)
 END; (* IF *)		
 RETURN c; 
END MaxLI3;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE MaxLI4*(a, b, c, d : LONGINT) : LONGINT; 
BEGIN (* MaxLI4 *)			 
 IF b>a THEN a:=b; END; (* IF *)
 IF d>c THEN c:=d; END; (* IF *)
 
 IF a>b THEN RETURN a; ELSE RETURN b; END; (* IF *)
END MaxLI4;

(*------------------------------------------------------------------------------------------------------------------------------*)
END UTI.


