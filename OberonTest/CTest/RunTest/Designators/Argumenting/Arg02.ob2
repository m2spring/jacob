MODULE Arg02;
(*% Argumenting: Indirect call via Selecting and Indexing *)
(*% Assignment via Function Procedure                     *)

IMPORT O:=Out;

TYPE 
     Proc  = PROCEDURE;
     tRec1 = RECORD
              p:Proc;
             END;
     tRec2 = RECORD
              a:ARRAY 1 OF Proc;
              e:RECORD
                 p:Proc;
                END;
             END;             

VAR 
  r1:tRec1;
  r2:tRec2;
  
PROCEDURE Ausgabe;
BEGIN (* Ausgabe *)
 O.String('Prozedur erfolgreich gerufen!'); O.Ln;
END Ausgabe;

PROCEDURE Function(): Proc;
BEGIN (* Function *)
 RETURN Ausgabe;
END Function;

BEGIN (* Arg02 *)
 r1.p:=Function();
 r2.a[0]:=Function();
 r2.e.p:=Function();
 
 r1.p;
 r2.a[0];
 r2.e.p;
END Arg02.
