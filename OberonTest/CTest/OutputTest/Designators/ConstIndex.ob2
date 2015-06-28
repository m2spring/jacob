MODULE ConstIndex;
TYPE T=ARRAY 10 OF CHAR; 
CONST i=5;
VAR c:CHAR; a:T; j:LONGINT; 
BEGIN (* ConstIndex *)
 a[i]:=c; 
 c:=a[i];                   
 j:=5; 
 c:=a[j]; 
END ConstIndex.
