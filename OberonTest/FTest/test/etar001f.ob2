(* 6.2 Type declarations: Array Types                                         *)
(* The number of elements of an array is called its length. The elements      *)
(* of the array are designated by indices, which are integers between 0 and   *)
(* the length minus 1.                                                        *)
(* 1.  Introduction                                                           *)
(* What remains unsaid is mostly left so intentionally, either because        *)
(* it can be derived form stated rules of the language, or because it would   *)
(* require to commit the definition when a general commitment appears as      *)
(* unwise.                                                                    *)

MODULE etar001f;

TYPE A = ARRAY -5 OF CHAR;
(*             ^--- Invalid length of array *)
(* Pos: 13,16                               *)

END etar001f.
