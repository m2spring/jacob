MODULE Arg03;
(*% Argumenting: Indirect Call of local and outer proc-var via Open array Param *)
IMPORT O:=Out;

TYPE 
     Proc  = PROCEDURE;
     tRec1 = RECORD
              a:ARRAY 2,3 OF RECORD
                              p:Proc;
                             END;
             END;
     tRec2 = ARRAY 2 OF RECORD
                         a:ARRAY 1 OF Proc;
                         e:RECORD
                            g: RECORD
                                a:ARRAY 2,2 OF Proc;
                               END;
                           END;
                        END;

VAR 
  r1:tRec1;
  r2:tRec2;

PROCEDURE Ausgabe;
BEGIN (* Ausgabe *)
 O.String('Prozedur erfolgreich gerufen!'); O.Ln;
END Ausgabe;

(************************************************************************************************************************)
PROCEDURE P(a:ARRAY OF Proc);
BEGIN (* P *)
 a[0];
END P;


PROCEDURE Q;
VAR r1:tRec1;
    r2:tRec2;

  PROCEDURE R;
  BEGIN (* R *)
   r1.a[1,0].p;
   P(r2[1].a);
   P(r2[1].e.g.a[1]);
  END R;

BEGIN (* Q *)
 r1.a[1,0].p:=Ausgabe;
 r2[1].a[0]:=Ausgabe;
 r2[1].e.g.a[1,0]:=Ausgabe; 
 R;
 r2[1].e.g.a[1,0];
END Q;

BEGIN (* Arg03 *)
 r2[0].a[0]:=Ausgabe;
 r2[1].e.g.a[0,0]:=Ausgabe;;
 P(r2[0].a);
 P(r2[1].e.g.a[0]);
 O.String('-----'); O.Ln;
 Q;
END Arg03.
