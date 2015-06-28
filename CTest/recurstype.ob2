MODULE recurstype;
 
TYPE
R1 = RECORD(R1) END;
R2 = RECORD f: POINTER TO R2; END;
P1 = POINTER TO RECORD f: P1; END;
P2 = POINTER TO ARRAY OF P2;
PP = PROCEDURE (VAR p: PP);
 
PROCEDURE P1;
   TYPE TR = RECORD f : TR; END;
        TA = ARRAY 1 OF TA;
BEGIN END P1;

PROCEDURE P2;
   TYPE T = RECORD
             f : POINTER TO T;
             g : PROCEDURE(p : T);
             h : PROCEDURE(VAR p : T);
            END;
BEGIN END P2;
 
PROCEDURE P3;
   TYPE T1 = RECORD
              f : POINTER TO RECORD
                              f : T1;
                             END;
              g : SET;
             END;
 
        T2 = RECORD
              f : POINTER TO ARRAY SIZE(T2) OF CHAR;
              g : SET;
             END;
 
        T3 = POINTER TO RECORD
                         f : T3;
                        END;
 
        T4 = RECORD
              f : ARRAY 1 OF RECORD
                              f : POINTER TO RECORD
                                              f : ARRAY 1 OF RECORD
                                                              f : T4;
                                                             END;
                                             END;
                          END;
              g : SET;
             END;
BEGIN END P3;
 
PROCEDURE P4;
   VAR v : ARRAY 1,LEN(v,1) OF CHAR;
BEGIN END P4;
 
PROCEDURE P5;
   VAR v : ARRAY LEN(v,2),1 OF CHAR;
BEGIN END P5;
       
END recurstype.
