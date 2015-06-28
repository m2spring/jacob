(* 4. Declaration and scope rules                                    *)
(* "The scope of an object x extends textually from the point of its *)
(* declaration..."                                                   *)

MODULE edec002t;

TYPE
   x = ARRAY 2 OF SHORTINT;
   a = RECORD
        i : INTEGER;
        c : CHAR;
        s : SHORTINT;
        r : REAL;
        n : x;
        a : LONGINT;
       END;
    y = ARRAY 2 OF a;

PROCEDURE proc(fa : a; a: CHAR; fy : y);
VAR
  array : x;
TYPE
  x = SHORTINT;
VAR
  szahl : x;

BEGIN (* proc *)
 array[1] := szahl;

 fa.c := a;
END proc;

END edec002t.
