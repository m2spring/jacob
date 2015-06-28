(* Appendix A: Definition of terms: Expression compatible                     *)
(* For a given operator, the types of its operands are expression             *)
(* compatible if they conform to the following table (which shows also the    *)
(* result type of the expression). Character arrays that are to be            *)
(* compared must contain 0X as a terminator. Type T1 must be an extension     *)
(* of type T0.                                                                *)

MODULE eaex001f;

CONST
   csi = 1;
   ci  = 500;
   cli = MAX(LONGINT);
   cr  = 4.0;
   clr = 2.0D0;
   cs  = {1};
   cb  = TRUE;
   cc  = 41X;

TYPE
  T0       = RECORD END;
  T1       = RECORD(T0) END;
  TPROC    = PROCEDURE;
  T0POINTER = POINTER TO T0;
  T1POINTER = POINTER TO T1;

VAR
   b   : BOOLEAN;
   arr : ARRAY 5 OF CHAR;
   rec0: T0;
   rec1: T1;
   proc: TPROC;
   ptr0: T0POINTER;
   ptr1: T1POINTER;

CONST

(* operator      first operand     second operand        result type          *)
(* --------      -------------     --------------        -----------          *)
(* + - *         numeric           numeric         smallest numeric type      *)
(*                                                 including both operands    *)

 c1 = cs + ci;
(*       ^--- Operator not applicable *)
(* Pos: 43,10                         *)

 c2 = cb - cr;
(*       ^--- Operator not applicable *)
(* Pos: 47,10                         *)

 c3 = 12 * cc;
(*       ^--- Operator not applicable *)
(* Pos: 51,10                         *)


(* operator      first operand     second operand        result type          *)
(* --------      -------------     --------------        -----------          *)
(*   /           numeric           numeric         smallest real type         *)
(*                                                 including both operands    *)

c4 = ci / cs;
(*      ^--- Operator not applicable *)
(* Pos: 61,9                         *)

c5 = clr / cb;
(*       ^--- Operator not applicable *)
(* Pos: 65,10                         *)

c6 = cc  / cli;
(*       ^--- Operator not applicable *)
(* Pos: 69,10                         *)

c7 = clr / {};
(*       ^--- Operator not applicable *)
(* Pos: 73,10                         *)


(* operator      first operand     second operand        result type          *)
(* --------      -------------     --------------        -----------          *)
(* + - * /           SET               SET                   SET              *)

c8 = cs + cli;
(*      ^--- Operator not applicable *)
(* Pos: 82,9                         *)

c9 = cr * {8,9};
(*      ^--- Operator not applicable *)
(* Pos: 86,9                         *)

c10 = c9 - cb;
(*       ^--- Operator not applicable *)
(* Pos: 90,10                         *)

c11 = cs / csi;
(*       ^--- Operator not applicable *)
(* Pos: 94,10                         *)


(* operator      first operand     second operand        result type          *)
(* --------      -------------     --------------        -----------          *)
(*  DIV MOD       integer type      integer type   smallest integer type      *)
(*                                                 including both operands    *)

c12 = csi DIV cr;
(*        ^--- Operator not applicable *)
(* Pos: 104,11                         *)

c13 = clr MOD csi;
(*        ^--- Operator not applicable *)
(* Pos: 108,11                         *)

c14 = cli DIV cb;
(*        ^--- Operator not applicable *)
(* Pos: 112,11                         *)

c15 = cc MOD cli;
(*       ^--- Operator not applicable *)
(* Pos: 116,10                        *)


(* operator      first operand     second operand        result type          *)
(* --------      -------------     --------------        -----------          *)
(* OR & ~          BOOLEAN           BOOLEAN               BOOLEAN            *)

c16 = cb OR ci;
(*          ^--- Invalid type of expression *)
(* Pos: 125,13                              *)

c17 = csi OR FALSE;
(*    ^--- Invalid type of expression *)
(* Pos: 129,7                         *)

c18 = FALSE & cc;
(*            ^--- Invalid type of expression *)
(* Pos: 133,15                                *)

c19 = clr & TRUE;
(*    ^--- Invalid type of expression *)
(* Pos: 137,7                         *)

c20 = ~ci;
(*     ^--- Invalid type of expression *)
(* Pos: 141,8                          *)


(* operator      first operand     second operand        result type          *)
(* --------      -------------     --------------        -----------          *)
(* = # <         numeric           numeric               BOOLEAN              *)
(* <= > >=       CHAR              CHAR                  BOOLEAN              *)
(*               character array,  character array,      BOOLEAN              *)
(*               string            string                BOOLEAN              *)

c21 = csi < cb;
(*        ^--- Operator not applicable *)
(* Pos: 153,11                         *)

PROCEDURE P1;
VAR
 c :CHAR;
BEGIN    
 b:= c # 'ABC';
(*     ^--- Operator not applicable *)
(* Pos: 161,8                       *)

b:= arr # cli;
(*      ^--- Operator not applicable *)
(* Pos: 165,9                        *)
END P1;

(* operator      first operand       second operand        result type        *)
(* --------      -------------       --------------        -----------        *)
(*   = #           BOOLEAN             BOOLEAN             BOOLEAN            *)
(*                   SET                 SET               BOOLEAN            *)
(*               NIL, pointer type   NIL, pointer type     BOOLEAN            *)
(*               T0 or T1            T0 or T1                                 *)
(*               procedure type T,   procedure type T,     BOOLEAN            *)
(*               NIL                 NIL                                      *)

PROCEDURE P2;
CONST
 c25 = cb = csi;
(*        ^--- Operator not applicable *)
(* Pos: 181,11                         *)

 c26 = cs = clr;
(*        ^--- Operator not applicable *)
(* Pos: 185,11                         *)

BEGIN
 b:= NIL = rec0;
(*       ^--- Operator not applicable *)
(* Pos: 190,10                        *)
END P2;

(* operator      first operand     second operand        result type          *)
(* --------      -------------     --------------        -----------          *)
(*    IN         integer type          SET                BOOLEAN             *)

PROCEDURE P3;
CONST
 c28 = cr IN cs;
(*     ^--- Invalid type of expression *)
(* Pos: 201,8                          *)

 c29 = clr IN {};
(*     ^--- Invalid type of expression *)
(* Pos: 205,8                          *)

 c30 = cli IN cr;
(*            ^--- Invalid type of expression *)
(* Pos: 209,15                                *)


(* operator      first operand     second operand        result type          *)
(* --------      -------------     --------------        -----------          *)
(*    IS           type T0            type T1             BOOLEAN             *)

BEGIN
 b:= ptr1 IS T0POINTER;
(*        ^--- Type test not applicable *)
(* Pos: 219,11                          *)
END P3;

END eaex001f.

