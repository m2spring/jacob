MODULE Sel03;
(*% Nested Record Variables  *)

TYPE tRec1* = RECORD
               s1:SET;
               b1:BOOLEAN;
               r1*:RECORD
                    a:ARRAY 1 OF CHAR;
                    r2*:RECORD
                         lr:LONGREAL;
                         r3*:RECORD
                              p4:POINTER TO tRec1;
                              r4*:RECORD
                                   s5*:SET;
                                  END;
                             END;
                        END;
                   END;
              END;
            
VAR r:tRec1;

BEGIN (* Sel03 *)
 r.s1:={};
 r.r1.a[0]:=0X; 
 r.r1.r2.lr:=2.0; 
 r.r1.r2.r3.p4:=NIL; 
 r.r1.r2.r3.r4.s5:={}; 
END Sel03.
