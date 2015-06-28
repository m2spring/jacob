(* 6. Type declarations : Record types                                        *)
(* An extended type T1 consists of the fields of its base type and of the     *)
(* fields which are declared in T1. All identifiers declared in the extended  *)
(* record must be different from the identifiers declared in its base type    *)
(* record(s).                                                                 *)

MODULE etre001t;

IMPORT e:=edec001t;

TYPE
   tAbgeleitet1 = RECORD(e.t1Record)
                   x,y,z : CHAR;
                  END;

   tAbgeleitet2 = RECORD(tAbgeleitet1)
                   a : tAbgeleitet1;
                  END;

PROCEDURE (VAR  r : tAbgeleitet1) ZuVerteilen;
BEGIN
END ZuVerteilen;

PROCEDURE (VAR r : tAbgeleitet2) Gebunden;
BEGIN
END Gebunden;

END etre001t.
