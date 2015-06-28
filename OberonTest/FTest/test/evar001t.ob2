(* 7. Variable declarations *)

MODULE evar001t;

VAR
   i, j, k : INTEGER;
   x, y    : REAL;
   p, q    : BOOLEAN;
   s       : SET;
   a       : ARRAY 100 OF REAL;
   w       : ARRAY 16 OF RECORD
                          name: ARRAY 32 OF CHAR;
                          count: INTEGER
                         END;

END evar001t.
