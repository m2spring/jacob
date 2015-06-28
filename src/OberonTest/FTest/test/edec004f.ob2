(* 4. Declaration and scope rules *)
MODULE edec004f;

VAR
  I : INTEGER;

PROCEDURE proc;
VAR
  c : CHAR;
BEGIN
END proc;

BEGIN
 I := ORD(c);
(*        ^---- Identifier not declared *)
(* Pos 14,11                            *)
END edec004f.
