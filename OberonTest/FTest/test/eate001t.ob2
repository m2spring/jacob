(* Appendix A: Definition of terms: Type extension (base type)                *)
(* Given a type declaration Tb = RECORD (Ta) ... END, Tb is a direct          *)
(* extension of Ta, and Ta is a direct base type of Tb. A type Tb is an       *)
(* extension of a type Ta (Ta is a base type of Tb) if                        *)
(*                                                                            *)
(* 1.  Ta and Tb are the same types, or                                       *)
(*                                                                            *)
(* 2.  Tb is a direct extension of an extension of Ta                         *)
(*                                                                            *)
(* If Pa = POINTER TO Ta and Pb = POINTER TO Tb, Pb is an extension of Pa     *)
(* (Pa is a base type of Pb) if Tb is an extension of Ta.                     *)

(* The [type] guard is applicable, if                                         *)
(* [...]                                                                      *)
(*  2.  T is an extension of the static type of v                             *)

MODULE eate001t;

TYPE
 TA = RECORD
       s:SET;
      END;

 TB = RECORD(TA)
       i:INTEGER;
      END;

PROCEDURE P(VAR r:TA);
BEGIN
(* 1. *)
 r(TA).s:={1};

(* 2. *)
 r(TB).i:=1;
END P;

END eate001t.

