(* 4. Declaration and scope rules                                             *)
(* An identifier declared in a module block may be followed by an export mark *)
(* "*" or "-" in its declaration to indicate that it is exported.             *)
(* This module gets imported by other test modules                            *)

MODULE edec001t;

VAR
   vshortint * : SHORTINT;
   vint      - : INTEGER;
   vlongint    : LONGINT;
   vreal     * : REAL;
   vlongreal   : LONGREAL;
   vchar     * : CHAR;
   vbool     - : BOOLEAN;
   vset        : SET;

TYPE
   tShortint * = SHORTINT;
   tInt      * = INTEGER;
   tLongint    = LONGINT;
   tReal     * = REAL;
   tLongreal   = LONGREAL;
   tChar     * = CHAR;
   tBool     * = BOOLEAN;
   tSet        = SET;

CONST
   cshortint * = 10;
   cint        = 400;
   clongint    = 4000000;
   creal       = 3.0;
   clongreal   = 3.0D2;
   cchar       = 41X;
   cbool       = TRUE;
   cset        = {1,2,3,4};

TYPE
  t1Record *   = RECORD
                  i* : tInt;
                  c- : tChar;
                  d  : tBool;
                 END;

BEGIN
 vshortint := 1;
 vint      := 1;
 vlongint  := 1;
 vreal     := 1.0;
 vlongreal := 1.0D0;
 vchar     := 31X;
 vbool     := TRUE;
 vset      := {1};
END edec001t.
