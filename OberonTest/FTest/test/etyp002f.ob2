(* 6. Type declarations                                                       *)
(* A type must not be used in its own declaration except as a pointer base    *)
(* type or a type of a formal variable parameter.                             *)
 
MODULE etyp002f;
 
TYPE
 R1 = RECORD(R1) END;
(*           ^--- Illegal recursive type application *)
(* Pos: 8,14                                         *)
 
 P1 = POINTER TO RECORD f: P1; END;
(*                         ^--- Illegal recursive type application *)
(* Pos: 12,28                                                      *)
 
 P2 = POINTER TO ARRAY OF P2;
(*                        ^--- Illegal recursive type application *)
(* Pos: 16,27                                                     *)
 
 
PROCEDURE PR1;
   TYPE TR = RECORD f : TR; END;
(*                      ^--- Illegal recursive type application *)
(* Pos: 22,25                                                   *)
 
        TA = ARRAY 1 OF TA;
(*                      ^--- Illegal recursive type application *)
(* Pos: 26,25                                                   *)
 
END PR1;
 
PROCEDURE PR2;
 TYPE T = RECORD
           f : POINTER TO T;
           g : PROCEDURE(p : T);
(*                           ^--- Illegal recursive type application *)
(* Pos: 35,30                                                        *)
 
           h : PROCEDURE(VAR p : T);
          END;
END PR2;
 
PROCEDURE PR3;
 TYPE T1 = RECORD
            f : POINTER TO RECORD
                            f : T1;
(*                              ^--- Illegal recursive type application *)
(* Pos: 46,33                                                           *)
 
                           END;
            g : SET;
           END;
END PR3;
 
PROCEDURE PR4;
 TYPE T2 = RECORD
            f : POINTER TO ARRAY SIZE(T2) OF CHAR;
(*                               ^--- Invalid length of array *)
(* Pos: 57,34                                                 *)
 
            g : SET;
           END;
END PR4;
 
PROCEDURE PR5;
 TYPE T3 = POINTER TO RECORD
                       f : T3;
(*                         ^--- Illegal recursive type application *)
(* Pos: 67,28                                                      *)
 
                      END;
END PR5;
 
PROCEDURE PR6;
 TYPE T4 = RECORD
            f : ARRAY 1 OF RECORD
                            f : POINTER TO RECORD
                                            f : ARRAY 1 OF RECORD
                                                            f : T4;
(*                                                              ^--- *)
(* Pos: 79,65                     Illegal recursive type application *)
 
                                                           END;
                                           END;
                           END;
            g : SET;
           END;
END PR6;
 
PROCEDURE PR7;
   VAR v : ARRAY 1,LEN(v,1) OF CHAR;
(*                     ^--- Identifier not declared                     *)
(* Pos: 91,24          ^--- Actual parameter not compatible with formal *)
 
END PR7;
 
PROCEDURE PR8;
   VAR v : ARRAY LEN(v,2),1 OF CHAR;
(*                   ^--- Identifier not declared                     *)
(* Pos: 98,22        ^--- Actual parameter not compatible with formal *)
 
END PR8;
 
END etyp002f.
