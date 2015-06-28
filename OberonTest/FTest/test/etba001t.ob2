(* 6. Type declarations : Basic types *)

MODULE etba001t;

VAR
  vshortint : SHORTINT;
  vint      : INTEGER;
  vlongint  : LONGINT;
  vreal     : REAL;
  vlongreal : LONGREAL;
  vchar     : CHAR;
  vbool     : BOOLEAN;
  vset      : SET;

BEGIN
 vbool := TRUE;
 vbool := FALSE;

 vchar := 00X;
 vchar := 'A';
 vchar := 7FX;

 vshortint := MIN(SHORTINT);
 vshortint := MAX(SHORTINT);

 vint := MIN(INTEGER);
 vint := MAX(INTEGER);

 vlongint := MIN(LONGINT);
 vlongint := MAX(LONGINT);

 vreal := MIN(REAL);
 vreal := MAX(REAL);

 vlongreal := MIN(LONGREAL);
 vlongreal := MAX(LONGREAL);

 vset := {MIN(SET)..MAX(SET)};
END etba001t.
