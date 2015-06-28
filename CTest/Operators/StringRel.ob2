MODULE StringRel;
IMPORT O:=Out; 

VAR a:ARRAY 20 OF CHAR; 
    b:ARRAY 10 OF CHAR; 
    f:BOOLEAN; 
BEGIN (* StringRel *)
 f:=a=b; 
(*<<<<<<<<<<<<<<<
 f:=a="a"; 
>>>>>>>>>>>>>>>*)
 f:=a="ab"; 
END StringRel.
