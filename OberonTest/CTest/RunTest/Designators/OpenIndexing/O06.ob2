(*$!oc -it -kt -cmt O06 && O06 #*)
MODULE O06;
IMPORT O:=Out;

TYPE T=LONGINT;

VAR 
   a1:ARRAY 10          OF T;
   a2:ARRAY 10,10       OF T;
   a3:ARRAY 10,10,10    OF T;
   a4:ARRAY 10,10,10,10 OF T;

(************************************************************************************************************************)
PROCEDURE P1(a:ARRAY OF T );

   PROCEDURE P1Local;
   BEGIN (* P1Local *)
    IF a[0]#0 THEN 
     O.Int(a[0]); O.Str(' ');
     O.Int(a[9]); O.Ln;
    ELSE 
     a[0]:=1; 
     P1(a);
    END; (* IF *)
   END P1Local;

BEGIN (* P1 *)
 P1Local;
END P1;

(************************************************************************************************************************)
PROCEDURE P2(a:ARRAY OF ARRAY OF T );

   PROCEDURE P2Local;
   BEGIN (* P2Local *)
    IF a[0,0]#2 THEN 
     O.Int(a[0,0]); O.Str(' ');
     O.Int(a[0,9]); O.Str(' ');
     O.Int(a[9,0]); O.Str(' ');
     O.Int(a[9,9]); O.Ln;
    ELSE 
     a[0,0]:=1; 
     P2(a);
    END; (* IF *)
   END P2Local;

BEGIN (* P2 *)
 P2Local;
END P2;

(************************************************************************************************************************)
PROCEDURE P3(a:ARRAY OF ARRAY OF ARRAY OF T );

   PROCEDURE P3Local;
   BEGIN (* P3Local *)
    IF a[0,0,0]#6 THEN 
     O.Int(a[0,0,0]); O.Str(' ');
     O.Int(a[0,0,9]); O.Str(' ');
     O.Int(a[0,9,0]); O.Str(' ');
     O.Int(a[0,9,9]); O.Str(' ');
     O.Int(a[9,0,0]); O.Str(' ');
     O.Int(a[9,0,9]); O.Str(' ');
     O.Int(a[9,9,0]); O.Str(' ');
     O.Int(a[9,9,9]); O.Ln;
    ELSE 
     a[0,0,0]:=1; 
     P3(a);
    END; (* IF *)
   END P3Local;

BEGIN (* P3 *)
 P3Local;
END P3;

BEGIN (* O06 *)
(* a1 *)
a1[0]:=0; a1[9]:=1;

(* a2 *)
a2[0,0]:=2; 
a2[0,9]:=3; 
a2[9,0]:=4; 
a2[9,9]:=5;

(* a3 *)
a3[0,0,0]:=6; a3[0,0,9]:=7; 
a3[0,9,0]:=8; a3[0,9,9]:=9; 
a3[9,0,0]:=10; a3[9,0,9]:=11; 
a3[9,9,0]:=12; a3[9,9,9]:=13;

O.StrLn('*************************');
P1(a1);
P2(a2);
P3(a3);

END O06.

