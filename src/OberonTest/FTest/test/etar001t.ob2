(* 6. Type declarations : Array types                                         *)
(* The number of elements of an array is called its length. The elements of   *)
(* the array are designated by indices, which are integers between 0 and the  *)
(* length minus 1.                                                            *)


MODULE etar001t;

CONST
   d1 = 10;
   d2 = MAX(SHORTINT);

TYPE
   t1Array = ARRAY d1 OF INTEGER;
   t2Array = ARRAY d2 OF CHAR;
   t3Array = ARRAY 1,1 OF BOOLEAN;
   t4Array = ARRAY 1 OF t3Array;

VAR
   v1 : t1Array;
   v2 : t2Array;
   v3 : t3Array;
   v4 : t4Array;

BEGIN
 v1[0]               := 0;
 v1[d1-1]            := 4000;

 v2[0]               := 0X;
 v2[100]             := 'a';
 v2[MAX(SHORTINT)-1] := 13X;

 v3[0,0]             := TRUE;
 v4[0,0,0]           := TRUE;
 v4[0]               := v3;
END etar001t.
