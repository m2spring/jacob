MODULE ScannerTest;
IMPORT ID:=Idents, O:=Out, L:=Lib, SC:=Scanner, TOK:=Tokens;
VAR fn:ARRAY 100 OF CHAR; i:LONGINT; 
BEGIN (* ScannerTest *)
 FOR i:=1 TO L.ParamCount()-1 DO
  L.ParamStr(fn,i); 
  IF ~SC.Open(fn) THEN HALT(1); END; (* IF *)

  REPEAT
   SC.GetToken;

   O.Int(SC.Act.Pos.line); 
   O.Str(','); 
   O.Int(SC.Act.Pos.column); 
   O.Str(': '); 
   O.StrT(TOK.Repr(SC.Act.Token)); 

   CASE SC.Act.Token OF
   |TOK.Ident   : O.Str(' "'); O.StrT(ID.Repr(SC.Act.Ident)); O.Str('"'); 
   |TOK.Integer : O.Str(' '); O.Int(SC.Act.Integer); 
   |TOK.Char    : O.Str(' CHR('); O.Int(ORD(SC.Act.Char)); O.Str(')'); 
   |TOK.Real    : O.FixReal(SC.Act.Real,10); 
   |TOK.Longreal: O.FixReal(SC.Act.Longeal,10); 
   ELSE
   END; (* CASE *)
   
   O.Ln;
  UNTIL SC.Act.Token=TOK.Eof;
  SC.Close; 
 END; (* FOR *)
END ScannerTest.
