(* 9.10 Return and exit statements                                            *)
(* An exit statement is denoted by the symbol EXIT. It specifies              *)
(* termination of the enclosing loop statement and continuation with the      *)
(* statement following that loop statement.  Exit statements are              *)
(* contextually, although not syntactically associated with the loop          *)
(* statement which contains them.                                             *)

MODULE esrt003t;

VAR
   i: INTEGER;

BEGIN
 LOOP
  IF TRUE THEN EXIT END;
 END;

 LOOP
  CASE i OF
   1..3,5:;
   |6     : EXIT;
   |8..10 :;
   |20    : EXIT;
   ELSE EXIT;
  END;
 END;

 LOOP
  LOOP
   EXIT;
   LOOP
    EXIT;
   END;
  END;
  EXIT;
 END;
END esrt003t.

