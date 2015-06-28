MODULE Copy3;
IMPORT O:=Out;

VAR s20,s3:ARRAY 20 OF CHAR; i,j:LONGINT; 
    arr:ARRAY 4,5 OF CHAR;

PROCEDURE P1(a:ARRAY OF ARRAY OF CHAR);

 PROCEDURE Q;
 BEGIN (* Q *)
 COPY(a[i],s20); 
(*<<<<<<<<<<<<<<<
 COPY(s3,a[i+1]);

 O.String(a[0]); O.Ln;
 O.String(a[1]); O.Ln;
 O.String(a[2]); O.Ln;
 O.String(a[3]); O.Ln;
>>>>>>>>>>>>>>>*)
 END Q;

BEGIN (* P1 *)  
 Q;
END P1;


BEGIN (* Copy3 *)	   
 i:=1; j:=2; s20:='abcdefg'; s3:='xy'; 
 
 COPY("1234567",arr[0]);
 COPY("234567",arr[1]);
 COPY("34567",arr[2]);
 COPY("4567",arr[3]);
 P1(arr);
 
 O.String(arr[0]); O.Ln;
 O.String(arr[1]); O.Ln;
 O.String(arr[2]); O.Ln;
 O.String(arr[3]); O.Ln;

 O.String(s20); O.Ln;
END Copy3.
