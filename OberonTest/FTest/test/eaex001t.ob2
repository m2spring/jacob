(* Appendix A: Definition of terms: Expression compatible                     *)
(* For a given operator, the types of its operands are expression             *)
(* compatible if they conform to the following table (which shows also the    *)
(* result type of the expression). Character arrays that are to be            *)
(* compared must contain 0X as a terminator. Type T1 must be an extension     *)
(* of type T0.                                                                *)

MODULE eaex001t;

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

 c1 = csi + csi;
 c2 = csi + ci;
 c3 = ci  - cli;
 c4 = cli * cr;
 c5 = clr - cr;

(* operator      first operand     second operand        result type          *)
(* --------      -------------     --------------        -----------          *)
(*   /           numeric           numeric         smallest real type         *)
(*                                                 including both operands    *)

c6 = csi / csi;
c7 = ci  / cli;
c8 = cr  / cli;
c9 = clr / cr;

(* operator      first operand     second operand        result type          *)
(* --------      -------------     --------------        -----------          *)
(* + - * /           SET               SET                   SET              *)

c10 = cs + {1,2,3};
c11 = c10 * {8,9};
c12 = c11 - {9};
c13 = cs / c10;

(* operator      first operand     second operand        result type          *)
(* --------      -------------     --------------        -----------          *)
(*  DIV MOD       integer type      integer type   smallest integer type      *)
(*                                                 including both operands    *)

c14 = csi DIV csi;
c15 = ci MOD csi;
c16 = cli DIV csi;
c17 = cli MOD cli;

(* operator      first operand     second operand        result type          *)
(* --------      -------------     --------------        -----------          *)
(* OR & ~          BOOLEAN           BOOLEAN               BOOLEAN            *)

c18 = cb OR FALSE;
c19 = FALSE OR FALSE;
c20 = FALSE & cb;
c21 = TRUE & TRUE;
c22 = ~cb;

(* operator      first operand     second operand        result type          *)
(* --------      -------------     --------------        -----------          *)
(* = # <         numeric           numeric               BOOLEAN              *)
(* <= > >=       CHAR              CHAR                  BOOLEAN              *)
(*               character array,  character array,      BOOLEAN              *)
(*               string            string                BOOLEAN              *)

c23 = csi < ci;
c24 = ci > cli;
c25 = cr <= csi;
c26 = clr >= ci;
c27 = cc # 'A';
c28 = 'Laber' = 'Bla';

PROCEDURE P1;
BEGIN
 b:= arr = 'Blubber';
 b:= arr # arr;
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
 c31 = cb = TRUE;
 c32 = FALSE # cb;
 c33 = cs = {1,2,3};
 c34 = {} = {1,2,3};

BEGIN
 b:= NIL = ptr1;
 b:= ptr0 # ptr1;
 b:= ptr1 = NIL;
 b:= proc = NIL;
END P2;

(* operator      first operand     second operand        result type          *)
(* --------      -------------     --------------        -----------          *)
(*    IN         integer type          SET                BOOLEAN             *)

PROCEDURE P3;
CONST
 c39 = 3 IN cs;
 c40 = ci IN {};
 c41 = cli IN {1,2,3};
END P3;
(* operator      first operand     second operand        result type          *)
(* --------      -------------     --------------        -----------          *)
(*    IS           type T0            type T1             BOOLEAN             *)

BEGIN
 b:= ptr0 IS T1POINTER;
END eaex001t.

