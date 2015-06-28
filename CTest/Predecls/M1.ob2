MODULE M1;

TYPE T=SHORTINT;
VAR arr:POINTER TO ARRAY OF T;
    arr3:POINTER TO ARRAY OF ARRAY OF ARRAY OF T;
    arr1x1:POINTER TO ARRAY OF ARRAY 3 OF T;
    a2:ARRAY 10 OF POINTER TO ARRAY OF T;
    ptr:POINTER TO RECORD
                    f:POINTER TO ARRAY OF T;
                   END;
    c:T; i,j,k,l,m:T; 

PROCEDURE P(a:ARRAY OF ARRAY OF ARRAY OF ARRAY OF T);

 PROCEDURE Q;
 BEGIN (* Q *)
  a[arr[i+arr[j]],a2[i]^[j],ptr.f[i],arr3[i,j,k]]:=c; 
 END Q;

BEGIN (* P *)           
 a[i,j,k,l]:=c; 
END P;

BEGIN (* M1 *)
 arr[i+arr[j]]:=c; 
 a2[i]^[j]:=c;
 ptr.f[i]:=c;
 arr3[i,j,k]:=c; 
 arr[arr[i]]:=c; 
 arr1x1[i,j]:=c; 
END M1.
