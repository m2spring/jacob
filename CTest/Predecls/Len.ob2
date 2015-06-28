MODULE Len;
IMPORT O:=Out; 

VAR ch:CHAR; 
    a1:ARRAY 10 OF CHAR; 
    a2:ARRAY 10,20 OF CHAR; 
    li:LONGINT; 
    p1:POINTER TO ARRAY OF CHAR; 
    p2:POINTER TO ARRAY OF ARRAY OF CHAR; 
    ap1:ARRAY 10 OF POINTER TO ARRAY OF CHAR; 
    ap2:ARRAY 10 OF POINTER TO ARRAY OF ARRAY OF CHAR; 

PROCEDURE P(    a1:ARRAY OF CHAR;
                a2:ARRAY OF ARRAY OF CHAR;
            VAR a3:ARRAY OF ARRAY OF ARRAY OF CHAR);

 PROCEDURE Q;
 BEGIN (* Q *)
  li:=LEN(a1); 
  li:=LEN(a2); 
  li:=LEN(a2,1); 
  li:=LEN(a3); 
  li:=LEN(a3,1); 
  li:=LEN(a3,2); 
 END Q;

BEGIN (* P *)   
 li:=LEN(a1); 
 li:=LEN(a2); 
 li:=LEN(a2,1); 
 li:=LEN(a3); 
 li:=LEN(a3,1); 
 li:=LEN(a3,2); 
END P;

BEGIN (* Len *)   
 li:=LEN(a1); 
 li:=LEN(a2); 
 li:=LEN(a2,1);   
 li:=LEN(a2[5]);   
 
 li:=LEN(p1^); 
 li:=LEN(p2^); 
 p2[0,1]:=0X; 
 li:=LEN(p2^,1); 
 li:=LEN(p2[li],0); 
 
(*<<<<<<<<<<<<<<<
 LEN(rec.arr[F()].ptr^[i]^[F()])
>>>>>>>>>>>>>>>*)
END Len.
