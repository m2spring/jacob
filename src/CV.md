DEFINITION MODULE CV;
(*
 * Provides functionality for handling memory Constant Values (strings, reals and longreals) efficiently:
 * Identical constants are only stored once!
 *)
 
IMPORT LAB, OT;

TYPE tTable; (* Used only for FIL.ActP^.ConstTab! *)

(*----------------------------------------------------------------------------------------------------------------------*)
PROCEDURE NamedString(v:OT.oSTRING; name:LAB.T; isExported:BOOLEAN);
(*
 * Stores string 'v'  and label 'name'
 *)
 
PROCEDURE String(v:OT.oSTRING):LAB.T; 
(*
 * Stores string 'v' and yields a (new) local label
 *)

PROCEDURE NamedReal(v:OT.oREAL; name:LAB.T; isExported:BOOLEAN);
(*
 * Stores real value 'v'  and label 'name'
 *)
 
PROCEDURE Real(v:OT.oREAL):LAB.T;
(*
 * Stores real value 'v' and yields a (new) local label
 *)

PROCEDURE NamedLongreal(v:OT.oLONGREAL; name:LAB.T; isExported:BOOLEAN);
(*
 * Stores longreal value 'v'  and label 'name'
 *)
 
PROCEDURE Longreal(v:OT.oLONGREAL):LAB.T;
(*
 * Stores longreal value 'v' and yields a (new) local label
 *)

PROCEDURE Set(v:OT.oSET):LAB.T;
(*
 * Stores set value 'v' and yields a (new) local label
 *)

(*----------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Init;
(*
 * Initializes FIL.ActP^.ConstTab
 * Called in FIL.Open
 *)

PROCEDURE Code;
(*
 * Emits all stored memory constants to ASM
 *)

(*----------------------------------------------------------------------------------------------------------------------*)
END CV.
