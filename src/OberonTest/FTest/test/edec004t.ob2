(* 4. Declaration and scope rules                                          *)
(* A type T of the form POINTER TO T1 can be declared at a point           *)
(* where T1 is still unknown. The declaration of T1 must follow in the     *)
(* same block to which T is local.                                         *)

MODULE edec004t;

TYPE
   ForwardPointer = POINTER TO Behind;

VAR
   AppPtr : ForwardPointer;
   Rec    : RECORD
             o, p, q : ForwardPointer;
             proc    : PROCEDURE (p : ForwardPointer);
            END;
CONST
   l = 10;

TYPE
   Behind = RECORD
             x: CHAR;
            END;
END edec004t.
