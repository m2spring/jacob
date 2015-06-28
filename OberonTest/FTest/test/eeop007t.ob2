(* 8. Expressions: 8.1 Operands                                               *)
(* If a designates an array, ... If r designates a record, ...                *)
(* If a or r are read-only, then also a[e] and r.f are read-only.             *)
(* This module gets imported from module eeop005t.ob2                         *)

MODULE eeop007t;

TYPE
 TA  = ARRAY 3 OF CHAR;

 TR  = RECORD
        i*: INTEGER;
        s : SET;
       END;

 TRE = RECORD(TR)
        c* : CHAR;
       END;
VAR
 a- : TA;
 r- : TR;
 e* : TRE;

END eeop007t.
