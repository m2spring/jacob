MODULE Varia;
(* Miscellaneous algorithms from Chapters 5 to 8 *)

IMPORT Math;
CONST width = 16;  size = 128;
TYPE
   NameList = ARRAY width OF ARRAY size OF CHAR;
   Table = ARRAY size OF INTEGER;
   RealFunct = PROCEDURE(x: REAL): REAL;


(* Chapter 5 *)

PROCEDURE Mult(X, Y: INTEGER): INTEGER;
(* Multiplication by repeated addition, page 55 *)
VAR x, z: INTEGER;
BEGIN
   x := X;  z := 0;
   WHILE x > 0 DO  z := z + Y; x := x-1 END;
   RETURN z
END Mult;

PROCEDURE FastMult(X, Y: INTEGER): INTEGER;
(* Fast multiplication, page 56 *)
VAR x, y, z: INTEGER;
BEGIN
   x := X;  y := Y;  z := 0;  (* x >= 0 *)
   WHILE x > 0 DO
      IF ODD(x) THEN  z := z + y; x := x-1  END;
      y := 2*y;  x := x DIV 2
   END;
   RETURN z
END FastMult;

PROCEDURE Log2(x: REAL): REAL;
(* Log base 2, Exercise 5.6, page 61 *)
VAR a, b, s: REAL;
BEGIN
   a := x;  b := 1;  s := 0;
   WHILE b > 0 DO
      a := a*a;  b := b/2;
      IF a >= 2 THEN  s := s + b;  a := a/2  END
   END;
   RETURN s
END Log2;

PROCEDURE GCD(x, y: INTEGER): INTEGER;
(* Greatest common divisor, Exercise 5.8, page 61 *)
VAR r: INTEGER;
BEGIN
   WHILE y > 0 DO
      r := x MOD y;  x := y;  y := r
   END;
   RETURN x
END GCD;

PROCEDURE Bisect(f: RealFunct; x1, x2: REAL): REAL;
(* Compute root of f by bisection, Exercise 5.10, page 61 *)
VAR x, y: REAL;
BEGIN  (* (f(x1) > 0) & (f(x2) < 0) & (x1 < x2) *)
   x := (x1 + x2)/2;
   WHILE (x1 < x) & (x < x2) DO  y := f(x);
      IF y > 0 THEN  x1 := x  ELSE  x2 := x  END;
      x := (x1 + x2)/2
   END;
   RETURN x
END Bisect;


(* Chaapter 6 *)

PROCEDURE ComputeRoots(a, b, c: REAL; VAR r1, r2, i1, i2: REAL);  (* page 79 *)
VAR det: REAL;
BEGIN
   b := b/2;  det := b*b - a*c;
   IF det >= 0 THEN (* real roots *)
      r1 := (ABS(b) + Math.sqrt(det))/a;
      IF b >= 0 THEN r1 := -r1  END;
      r2 := c/(a*r1);   i1 := 0;  i2 := 0
   ELSE  (* complex roots *)
      r1 := -b/a;  r2 := r1;  i1 := Math.sqrt(-det);  i2 := -i1
   END
END ComputeRoots;

(* Chapter 8.2: Arrays *)

PROCEDURE MatrixMult(VAR A, B, C: ARRAY OF ARRAY OF REAL; m, n, l: INTEGER);
(* Matrix multiplication, page 118 *)
VAR i, j, k: INTEGER;  s: REAL;
BEGIN  i := 0;
   WHILE i < m DO  j := 0;
      WHILE j < n DO  k := 0;  s := 0;
         WHILE k < l DO  s := s + A[i, k]*B[k, j]; INC(k)  END;
         C[i, j] := s;  INC(j)
      END;
      INC(i)
   END
END MatrixMult;

PROCEDURE Search(VAR t: Table; x: INTEGER; VAR i: INTEGER);
(* Binary search, page 120 *)
VAR j, m: INTEGER;
BEGIN
   i := -1;  j := LEN(t);
   WHILE  j # i + 1  DO  (* t[i] <= x < t[j] *)
      m := (i + j) DIV 2;
      IF  t[m] <= x  THEN  i := m  ELSE  j := m   END
   END
   (* (t[i] <= x < t[j]) & (j = i + 1) *)
END Search;


(* 8.2.6 Strings and the type ARRAY n OF CHAR *)

PROCEDURE Len(x: ARRAY OF CHAR): INTEGER;  (* page 123 *)
VAR j: INTEGER;
BEGIN  (* there exists a k: 0 <= k < LEN(x): x[k] = 0X *)
   j := 0;
   WHILE  x[j] > 0X  DO  INC(j)  END;
   RETURN j
END Len;

PROCEDURE Copy(s: ARRAY OF CHAR; VAR x: ARRAY OF CHAR);  (* page 123 *)
VAR j: INTEGER;
BEGIN  (* Len(x) > Len(s) *)
   j := 0;
   WHILE s[j] # 0X DO  x[j] := s[j]; INC(j)  END;
   x[j] := 0X
END Copy;

PROCEDURE Locate(VAR txt: ARRAY OF CHAR; x: ARRAY OF CHAR; VAR pos: INTEGER);
(* page 125 *)
VAR j, Lx, Lt: INTEGER;
BEGIN  Lx := Len(x);  Lt := Len(txt);  pos := -1;
   REPEAT  j := 0;
      INC(pos);
      WHILE (x[j] = txt[pos + j]) & (j < Lx)  DO INC(j)  END
   UNTIL (j = Lx) OR ((pos + Lx) > Lt);
   IF  j < Lx  THEN pos := -1 (* pattern not found *)  END
END Locate;

PROCEDURE Insert(VAR txt: ARRAY OF CHAR; x: ARRAY OF CHAR; pos: INTEGER);
(* page 125 *)
VAR j, Lt, Lx: INTEGER;
BEGIN
   Lt := Len(txt);  Lx := Len(x);
   IF (Lx + Lt < LEN(txt)) & (pos >= 0) & (pos <= Lt) THEN
      (* make room *)
      j := Lt;
      WHILE j >= pos DO  txt[j + Lx] := txt[j];  DEC(j)  END;
      (* copy pattern x after character txt[pos] *)
      j := 0;
      WHILE j < Lx DO  txt[pos + j] := x[j]; INC(j)  END
   END
END Insert;

END Varia.   (* Copyright M. Reiser, 1992 *)


