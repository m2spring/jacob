(* 8. Expressions: 8.1 Operands                                              *)
(* If a designates an array, ... If r designates a record, ...               *)
(* If a or r are read-only, then also a[e] and r.f are read-only.            *)
 
MODULE eeop005f;                               (* Declarations of eeop007t:  *)
                                               (* -------------------------- *)
IMPORT S:=eeop007t;                            (* TYPE                       *)
                                               (*  TA  = ARRAY 3 OF CHAR;    *)
VAR                                            (*  TR  = RECORD              *)
 i:INTEGER;                                    (*         i*: INTEGER;       *)
 s:SET;                                        (*         s : SET;           *)
 c:CHAR;                                       (*        END;                *)
                                               (*  TRE = RECORD(TR)          *)
BEGIN                                          (*         c* : CHAR;         *)
 S.a[1]:='A';                                  (*        END;                *)
(* Object is read-only *)                      (* VAR                        *)
(* Pos: 15,2           *)                      (*  a- : TA;                  *)
                                               (*  r- : TR;                  *)
 S.r.i:=1;                                     (*  e* : TRE;                 *)
(* Object is read-only *)
(* Pos: 19,2           *)
 
 S.r.s:=s;               
(*   ^--- Record field not exported  Pos: 23,6 *)
(* Object is read-only               Pos: 23,2 *)
 
 S.e.s:={};              
(*   ^--- Record field not exported *)
(* Pos: 27,6                        *)
 
END eeop005f.
