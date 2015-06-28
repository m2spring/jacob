MODULE Out;
IMPORT S:=Str, SL:=SysLib, SYS:=SYSTEM;

PROCEDURE String*(s:ARRAY OF CHAR);
VAR dummy:LONGINT; 
BEGIN (* String *)	     
 dummy:=SL.write(SL.stdout,SYS.ADR(s),S.Length(s)); 
END String;

PROCEDURE Char*(ch:CHAR);
VAR s:ARRAY 2 OF CHAR; 
BEGIN (* Char *)
 s[0]:=ch; s[1]:=0X; String(s); 
END Char;

PROCEDURE Int*(i:LONGINT);
VAR buf:ARRAY 20 OF CHAR; ok:BOOLEAN; 
BEGIN (* Int *) 
 S.IntToStr(i,buf,10,ok); String(buf); 
END Int;

PROCEDURE Real*(r:LONGREAL);
VAR buf:ARRAY 50 OF CHAR; ok:BOOLEAN; 
BEGIN (* Real *)
 S.FixRealToStr(r,20,buf,ok); String(buf); 
END Real;

PROCEDURE Set*(s:SET);
VAR i:LONGINT; f:BOOLEAN; 
BEGIN (* Set *)
 f:=FALSE; 
 Char('{');
 FOR i:=MIN(SET) TO MAX(SET) DO
  IF i IN s THEN 
     IF f THEN Char(','); ELSE f:=TRUE; END;
     Int(i);
  END; (* IF *)
 END; (* FOR *)
 Char('}');
END Set;

PROCEDURE Ln*;
BEGIN (* Ln *)
 String(0AX); 
END Ln;

PROCEDURE Str*(s:ARRAY OF CHAR);
BEGIN (* Str *)              
 String(s); 
END Str;

PROCEDURE StrT*(s:S.T);
BEGIN (* StrT *)
 String(s^); 
END StrT;

PROCEDURE StrLn*(s:ARRAY OF CHAR);
BEGIN (* StrLn *)
 String(s); Ln;
END StrLn;

END Out.
