(* 6. Type declarations *)
(* A type must not be used in its own declaration except as a pointer base    *)
(* type or a type of a formal variable parameter.                             *)
 
MODULE etyp002t;
 
TYPE
  R1 = RECORD 
        f: POINTER TO R1; 
       END;
 
  P1 = PROCEDURE (VAR p: P1);
 
PROCEDURE P2;
 TYPE T = RECORD
           f : POINTER TO T;
           g : PROCEDURE(VAR p : T);
          END;
END P2;
 
PROCEDURE P3;
 TYPE T = RECORD
           f : ARRAY 1 OF RECORD
                           f : POINTER TO RECORD
                                           f : ARRAY 1 OF RECORD
                                                           f : POINTER TO T;
                                                          END;
                                          END;
                          END;
           g : SET;
          END;
END P3;
 
END etyp002t.
