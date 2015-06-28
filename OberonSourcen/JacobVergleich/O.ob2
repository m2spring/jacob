MODULE O;

IMPORT Idents, InOut, OT, Strings, Strings1, SYSTEM;

CONST  BEL* = CHR(7);
       BS*  = CHR(8);
       LF*  = CHR(10);
       CR*  = CHR(13);
       NL*  = LF;

PROCEDURE^Char*(c : CHAR);
PROCEDURE^Str*(s : ARRAY OF CHAR);
PROCEDURE^LngCard*(v :LONGINT);
PROCEDURE^LngInt*(v : LONGINT);
PROCEDURE^LngNum*(v,n:LONGINT);

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Ln*;
BEGIN (* Ln *)
 InOut.WriteLn;
END Ln;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Spc*;
BEGIN (* Spc *)
 Char(' ');
END Spc;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Bool*(v : BOOLEAN);
BEGIN (* Bool *)
 IF v
    THEN Str('TRUE');
    ELSE Str('FALSE');
 END; (* IF *)
END Bool;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Char*(c : CHAR);
BEGIN (* Char *)
 InOut.Write(c);
END Char;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE oChar*(c : OT.oCHAR);
BEGIN (* oChar *)
 Char(OT.CHARofoCHAR(c));
END oChar;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Str*(s : ARRAY OF CHAR);
BEGIN (* Str *)
 InOut.WriteString(s);
END Str;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE STR*(VAR s : ARRAY OF CHAR);
VAR i, n:LONGINT; 
BEGIN (* STR *)
 n:=Strings1.Length(s); 
 FOR i:=0 TO n DO
  Char(s[i]); 
 END; (* FOR *)
END STR;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE StrLn*(s : ARRAY OF CHAR);
BEGIN (* StrLn *)
 Str(s); Ln;
END StrLn;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE String*(s : Strings.tString);
VAR a : ARRAY Strings.cMaxStrLength+1 OF CHAR;
BEGIN (* String *)
 Strings.StringToArray(s,a);
 Str(a);
END String;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE oString*(r : OT.oSTRING);
VAR a : ARRAY Strings.cMaxStrLength+1 OF CHAR;
BEGIN (* oString *)
 OT.oSTRING2ARR(r,a);
 Str(a);
END oString;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Ident*(i : Idents.tIdent);
VAR s : Strings.tString;
BEGIN (* Ident *)
 Idents.GetString(i,s);
 String(s);
END Ident;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE ShtCard*(v :LONGINT);
BEGIN (* ShtCard *)
 LngCard(v);
END ShtCard;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Card*(v :LONGINT);
BEGIN (* Card *)
 LngCard(v);
END Card;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE LngCard*(v :LONGINT);
BEGIN (* LngCard *)
 InOut.WriteCard(v,0);
END LngCard;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE ShtInt*(v :LONGINT);
BEGIN (* ShtInt *)
 LngInt(v);
END ShtInt;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Int*(v :LONGINT);
BEGIN (* Int *)
 LngInt(v);
END Int;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE LngInt*(v : LONGINT);
BEGIN (* LngInt *)
 InOut.WriteInt(v,0);
END LngInt;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Byte*(v :LONGINT);
VAR d :LONGINT; 
BEGIN (* Byte *)
 d:=(v DIV 16) MOD 16;
 IF d>9 THEN INC(d,7); END; (* IF *)
 Char(CHR(48+d));

 d:=v MOD 16;
 IF d>9 THEN INC(d,7); END; (* IF *)
 Char(CHR(48+d));
END Byte;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Word*(v :LONGINT);
BEGIN (* Word *)
 InOut.WriteHex(v,4);
END Word;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE LngWord*(v :LONGINT);
BEGIN (* LngWord *)
 InOut.WriteHex(v,8);
END LngWord;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Addr*(v : SYSTEM.PTR);
BEGIN (* Addr *)
 LngWord(SYSTEM.VAL(LONGINT,v));
END Addr;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Set*(v : SET);
VAR i :LONGINT; f : BOOLEAN;
BEGIN (* Set *)
 f:=FALSE;
 Char('{');
 FOR i:=0 TO 31 DO
  IF i IN v
     THEN IF f THEN Char(','); END; (* IF *)
          ShtCard(i);
          f:=TRUE;
  END; (* IF *)
 END; (* FOR *)
 Char('}');
END Set;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Data*(v : ARRAY OF SYSTEM.BYTE);
VAR i,j:LONGINT; 
BEGIN (* Data *)
 FOR i:=0 TO LEN(v) DO
  j:=SYSTEM.VAL(SHORTINT,v[i]); 
  Byte(j);
 END; (* FOR *)
END Data;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE ShtNum*(v,n:LONGINT);
BEGIN (* ShtNum *)
 LngNum(v,n);
END ShtNum;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Num*(v,n:LONGINT);
BEGIN (* Num *)
 LngNum(v,n);
END Num;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE LngNum*(v,n:LONGINT);
VAR i :LONGINT; s : ARRAY 101 OF CHAR;
BEGIN (* LngNum *)
 IF n=0 THEN RETURN; END; (* IF *)
 IF n>99 THEN n:=99; END; (* IF *)

 s[n]:=0X;
 LOOP
  IF n=0 THEN EXIT; END; (* IF *)
  DEC(n);
  s[n]:=CHR(48+(v MOD 10)); v:=v DIV 10;
  IF v=0 THEN EXIT; END; (* IF *)
 END; (* LOOP *)

 WHILE n>0 DO
  DEC(n);
  s[n]:='0';
 END; (* WHILE *)

 Str(s);
END LngNum;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Real*(v : REAL; Precision, Length:LONGINT);
BEGIN (* Real *)
 InOut.WriteReal(v,Length,Precision);
END Real;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE LngReal*(v : LONGREAL; Precision, Length:LONGINT);
BEGIN (* LngReal *)
 InOut.WriteLongReal(v,Length,Precision);
END LngReal;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE oLngReal*(v : OT.oLONGREAL; Precision, Length:LONGINT);
BEGIN (* oLngReal *)
 LngReal(OT.LONGREALofoLONGREAL(v),Precision,Length);
END oLngReal;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE RealSci*(v : REAL);
BEGIN (* RealSci *)
 InOut.WriteReal(v,0,-(OT.FLTDIG));
END RealSci;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE LngRealSci*(v : LONGREAL);
BEGIN (* LngRealSci *)
 InOut.WriteLongReal(v,0,-(OT.DBLDIG));
END LngRealSci;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE oLngRealSci*(v : OT.oLONGREAL);
BEGIN (* oLngRealSci *)
 LngRealSci(OT.LONGREALofoLONGREAL(v));
END oLngRealSci;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE CharRep*(c : CHAR; count:LONGINT);
BEGIN (* CharRep *)
 WHILE count>0 DO
  Char(c); DEC(count);
 END; (* WHILE *)
END CharRep;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE BackSpace*(n:LONGINT);
VAR i :LONGINT; 
BEGIN (* BackSpace *)
 FOR i:=1 TO n DO
  Char(BS);
  Char(' ');
  Char(BS);
 END; (* FOR *)
END BackSpace;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE St2*(s1, s2 : ARRAY OF CHAR);
BEGIN (* St2 *)
 Str(s1);
 Str(s2);
END St2;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE St3*(s1, s2, s3 : ARRAY OF CHAR);
BEGIN (* St3 *)
 Str(s1);
 Str(s2);
 Str(s3);
END St3;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE St4*(s1, s2, s3, s4 : ARRAY OF CHAR);
BEGIN (* St4 *)
 Str(s1);
 Str(s2);
 Str(s3);
 Str(s4);
END St4;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE St5*(s1, s2, s3, s4, s5 : ARRAY OF CHAR);
BEGIN (* St5 *)
 Str(s1);
 Str(s2);
 Str(s3);
 Str(s4);
 Str(s5);
END St5;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE St6*(s1, s2, s3, s4, s5, s6 : ARRAY OF CHAR);
BEGIN (* St6 *)
 Str(s1);
 Str(s2);
 Str(s3);
 Str(s4);
 Str(s5);
 Str(s6);
END St6;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE St7*(s1, s2, s3, s4, s5, s6, s7 : ARRAY OF CHAR);
BEGIN (* St7 *)
 Str(s1);
 Str(s2);
 Str(s3);
 Str(s4);
 Str(s5);
 Str(s6);
 Str(s7);
END St7;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE St8*(s1, s2, s3, s4, s5, s6, s7, s8 : ARRAY OF CHAR);
BEGIN (* St8 *)
 Str(s1);
 Str(s2);
 Str(s3);
 Str(s4);
 Str(s5);
 Str(s6);
 Str(s7);
 Str(s8);
END St8;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE St9*(s1, s2, s3, s4, s5, s6, s7, s8, s9 : ARRAY OF CHAR);
BEGIN (* St9 *)
 Str(s1);
 Str(s2);
 Str(s3);
 Str(s4);
 Str(s5);
 Str(s6);
 Str(s7);
 Str(s8);
 Str(s9);
END St9;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE CharVerb*(c : CHAR);
BEGIN (* CharVerb *)
 CASE c OF
 |0X..1FX
 ,80X..0FFX : Byte(ORD(c)); Char('X');
 |'"'       : Char('"'); Char("'"); Char('"');
 ELSE         Char("'"); Char(c); Char("'");
 END; (* CASE *)
END CharVerb;

(*------------------------------------------------------------------------------------------------------------------------------*)
END O.

