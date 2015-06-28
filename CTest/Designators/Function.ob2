MODULE Function;

VAR i,j,k,l:LONGINT; a:ARRAY 20 OF LONGINT; 
    si:SHORTINT; 
    af:ARRAY 20 OF PROCEDURE(i:LONGINT):LONGINT; 

PROCEDURE F0():LONGINT; 
BEGIN (* F0 *)
 RETURN 0; 
END F0;	     

PROCEDURE F1(i:LONGINT):SHORTINT; 
BEGIN (* F1 *)			 
 RETURN 1; 
END F1;

PROCEDURE F2(i,j:LONGINT):LONGINT; 
BEGIN (* F2 *)
 RETURN F1(i+j); 
END F2;

PROCEDURE P1(i:LONGINT);
BEGIN (* P1 *)
END P1;


BEGIN (* Function *)
(*<<<<<<<<<<<<<<<
 P1(1);
 i:=F0(); 
 i:=F1(F1(i)); 
 i:=af[i](i);   
 i:=F2(F1(i),F1(j)); 
 a[F0()]:=1; 
 i:=F1(i);   
>>>>>>>>>>>>>>>*)
 i:=a[si+F1(i)+F1(j)]; 
 si:=F1(i)+F1(j); 
END Function.
