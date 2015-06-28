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


MODULE eate001f;

TYPE
 T  = RECORD 
      END;
 TA = RECORD
       s:SET;
      END;

 TB = RECORD(TA)
       i:INTEGER;
      END;

PROCEDURE P(VAR r:TB);
BEGIN
 r(TA).s:={1};
(*^--- Guard not applicable  *)
(* Pos: 33,3                 *)

 r(T).i:=1;
(*^--- Guard not applicable; Pos: 37,3       *)
(*    ^--- Record field not found  Pos: 37,7 *)

END P;

END eate001f.

