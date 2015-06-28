MODULE Preredef;
TYPE T0 = RECORD END; T1 = RECORD(T0) END;
(*                                        ^ err 119: redefinition textually precedes procedure bound to base type *)
 
PROCEDURE (VAR r: T1) P; END P;
PROCEDURE (VAR r: T0) P; END P;
 
END Preredef.
