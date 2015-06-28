(* 8. Expressions: 8.2 Operators                                          *)
(* 8.2.3 Set Operators                                                    *)
(* Set operators apply to operands of type SET and yield a result of type *)
(* SET.                                                                   *)

MODULE eeso001t;

CONST
   a = {1,2,3,4,5,6,7,8,9};
   b = {1,3,5,7,9};
   c = {2,4,6,8};
   d = {};
   e = {1,2};

   f = -a;                            (* {0,10,11,12,...MAX(SET)} *)
   g = b + c;                         (* {1,2,3,4,5,6,7,8,9}      *)
   h = a - b;                         (* {2,4,6,8}                *)
   i = a * c;                         (* {2,4,6,8}                *)
   j = c / e;                         (* {1,4,6,8}                *)

   k = ( (a - b) = (a * (-b)) );      (* TRUE                     *)
   l = ( (c / e) = ((c-e) + (e-c)) ); (* TRUE                     *)
   m = a + {} = a;                    (* TRUE                     *)
   n = -{0..MAX(SET)} = {};           (* TRUE                     *)
   o = -{}         = {0..MAX(SET)};   (* TRUE                     *)

END eeso001t.
