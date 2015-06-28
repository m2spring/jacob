MODULE OpenIndex;
TYPE T=INTEGER; 
CONST MT=0;
VAR i,j,k,l,m,n,o:LONGINT; 
    p2:POINTER TO ARRAY OF ARRAY OF T;
    p3:POINTER TO ARRAY OF ARRAY OF ARRAY OF T;
    p4:POINTER TO ARRAY OF ARRAY OF ARRAY OF ARRAY OF T;
    p5:POINTER TO ARRAY OF ARRAY OF ARRAY OF ARRAY OF ARRAY OF T;
    p6:POINTER TO ARRAY OF ARRAY OF ARRAY OF ARRAY OF ARRAY OF ARRAY OF T;
    p7:POINTER TO ARRAY OF ARRAY OF ARRAY OF ARRAY OF ARRAY OF ARRAY OF ARRAY 5 OF T;

(*<<<<<<<<<<<<<<<
(************************************************************************************************************************)
PROCEDURE P2(VAR a:ARRAY OF ARRAY OF T);

 PROCEDURE Q;
 
  PROCEDURE R;
  BEGIN (* R *)
   a[i,j]:=MT; 
  END R;

 BEGIN (* Q *)
  a[i,j]:=MT; 
 END Q;

BEGIN (* P2 *)
 a[i,j]:=MT; 
END P2;
>>>>>>>>>>>>>>>*)

(************************************************************************************************************************)
PROCEDURE P6(a:ARRAY OF ARRAY OF ARRAY OF ARRAY OF ARRAY OF ARRAY OF T);
BEGIN (* P6 *)
END P6;

(************************************************************************************************************************)
PROCEDURE P2(a:ARRAY OF T);
BEGIN (* P2 *)
END P2;

(************************************************************************************************************************)
BEGIN (* OpenIndex *)
 p2[i,j]:=MT; 
 p3[i,j,k]:=MT; 
 p4[i,j,k,l]:=MT; 
 p5[i,j,k,l,m]:=MT; 
 p6[i,j,k,l,m,n]:=MT; 
 p7[i,j,k,l,m,n,o]:=MT; 
 P2(p2[i]); 
END OpenIndex.
