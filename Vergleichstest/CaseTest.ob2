MODULE CaseTest;
VAR i: INTEGER;
BEGIN
   CASE i OF
   2..1: ;
(*     ^ err 63: illegal value of constant *)
   END;
END CaseTest.
