MODULE M2;

IMPORT M1;

VAR i:INTEGER; 
    r:RECORD
       g:CHAR; 
       h:INTEGER; 
      END;
    a:ARRAY 10,20 OF CHAR; 
    p:POINTER TO ARRAY 10 OF CHAR; 
BEGIN (* M2 *)
(*<<<<<<<<<<<<<<<
 M1.i:=4711;   
 i:=4712;         
 r.h:=1;         
 a[2,3]:=0X; 
 p[1]:=1X; 
>>>>>>>>>>>>>>>*)
 i:=ABS(i); 
END M2.
