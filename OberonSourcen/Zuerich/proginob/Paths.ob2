MODULE Paths;
(* Simulation path and its statistics, page 169 *)
TYPE Path* = RECORD
      n*: INTEGER;
      W, t: REAL
   END;

PROCEDURE Init* (VAR p: Path);
BEGIN  p.W := 0;  p.n := 0;  p.t := 0
END Init;

PROCEDURE Up* (VAR p: Path; t: REAL);
BEGIN  p.W := p.W + p.n*(t - p.t);  INC(p.n, 1);  p.t := t
END Up;

PROCEDURE Down* (VAR p: Path; t: REAL);
BEGIN  p.W := p.W + p.n*(t - p.t);  DEC(p.n, 1);  p.t := t
END Down;

PROCEDURE Mean* (p: Path; tEnd: REAL): REAL;
BEGIN  RETURN (p.W + p.n*(tEnd - p.t))/tEnd
END Mean;

END Paths.   (* Copyright M. Reiser, 1992 *)
