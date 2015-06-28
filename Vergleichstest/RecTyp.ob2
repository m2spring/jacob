MODULE RecTyp;
TYPE
   T0 = POINTER TO RECORD next: T0; END;
   T1 = POINTER TO ARRAY SIZE(T1) OF CHAR;
   T2 = PROCEDURE (): T2;
   T3 = RECORD
         f: POINTER TO RECORD
                        x: T3;
                       END;
        END;
   T4 = RECORD f: T4; END;
(*                  ^ err 58: recursive type definition *)
   T5 = RECORD
         f: INTEGER;
         p: POINTER TO ARRAY SIZE(T5) OF CHAR;
(*                                  ^ err 58: recursive type definition *)
         g: SET;
        END;
   T6 = PROCEDURE (p: T6);
   T7 = ARRAY 10 OF POINTER TO T7;
END RecTyp.
