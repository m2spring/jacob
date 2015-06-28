(* 6. Type declarations *)
(* A type must not be used in its own declaration except as a pointer base    *)
(* type or a type of a formal variable parameter.                             *)

MODULE etyp001t;

TYPE
  T1 = RECORD
        s: SET;
        g: POINTER TO T1;
       END;

  T2 = RECORD
        t: T1;
        p: PROCEDURE (VAR r:T2);
       END;

END etyp001t.
