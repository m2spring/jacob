MODULE Sequences;
(* computes mean and variance of a sequence of sample values
    Exercise 10.2, page 182 *)

TYPE
   Sequence* = RECORD
      X: REAL;
      S2: REAL;
      n: LONGINT
   END;

PROCEDURE Open*(VAR s: Sequence);
BEGIN
   s.X := 0;  s.S2 := 0;  s.n := 0
END Open;

PROCEDURE Add*(VAR s: Sequence; x: REAL);
BEGIN
   INC(s.n);
   IF s.n > 1 THEN
      s.S2 := s.S2*(s.n - 2)/(s.n - 1) + (x - s.X)*(x - s.X)/s.n
   END;
   s.X := s.X + (x - s.X)/s.n
END Add;

PROCEDURE Mean*(s: Sequence): REAL;
BEGIN
   RETURN s.X
END Mean;

PROCEDURE Var*(s: Sequence): REAL;
BEGIN
   RETURN s.S2
END Var;

END Sequences.   (* Copyright M. Reiser, 1992 *)
