(* 9.10 Return and exit statements                                            *)
(* An exit statement is denoted by the symbol EXIT. It specifies              *)
(* termination of the enclosing loop statement and continuation with the      *)
(* statement following that loop statement.  Exit statements are              *)
(* contextually, although not syntactically associated with the loop          *)
(* statement which contains them.                                             *)

MODULE esrt004f;

PROCEDURE Proc;
BEGIN
 IF 1<2 THEN EXIT END;
(*           ^--- EXIT without LOOP *)

END Proc;

BEGIN
 REPEAT
  WHILE FALSE DO
   EXIT;
(* ^--- EXIT without LOOP *)

  END;
  EXIT;
(*^--- EXIT without LOOP *)

 UNTIL TRUE;
END esrt004f.
