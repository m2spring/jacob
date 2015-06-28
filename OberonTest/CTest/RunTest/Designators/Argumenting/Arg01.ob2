MODULE Arg01;
(*% Argumenting: Direct call and indirect call via Proc-var *)

IMPORT O:=Out;

VAR p :PROCEDURE;

    po: POINTER TO RECORD
                    p:PROCEDURE;
                   END;
PROCEDURE Ausgabe;
BEGIN (* Ausgabe *)
 O.String('Prozedur erfolgreich gerufen!'); O.Ln;
END Ausgabe;

BEGIN (* Arg01 *)
 Ausgabe;
 p:=Ausgabe;
 p;
 NEW(po);
 po.p:=Ausgabe;
 po.p;
END Arg01.
