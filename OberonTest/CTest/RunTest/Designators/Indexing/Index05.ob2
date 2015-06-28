MODULE Index05;
(*% Indexing: VAL und VAR Parameter mit und ohne lokalen Kopien *)
IMPORT O:=Out;

TYPE T1= ARRAY 4 OF CHAR;
     T2= ARRAY 2 OF T1;
     T3= ARRAY 2 OF T2;

VAR 
     a1:T1;
     a2:T2;
     a3:T3;

(* ------------ *)

PROCEDURE PrintT1(a1:T1);
BEGIN (* PrintT1 *)
 O.String(a1); O.Ln;
END PrintT1;

PROCEDURE PrintT2(a2:T2);
VAR i:LONGINT; 
BEGIN (* PrintT2 *)
 i:=0;
 PrintT1(a2[i]);
 i:=1;
 PrintT1(a2[i]);
END PrintT2;

PROCEDURE PrintT3(a3:T3);
VAR i:LONGINT; 
BEGIN (* PrintT3 *)
 i:=0;  
 PrintT2(a3[i]);
 i:=1; 
 PrintT2(a3[i]);
END PrintT3;

(* ------------ *)

PROCEDURE PVar1(VAR a1:T1);
BEGIN (* PVar1 *)
 PrintT1(a1);
END PVar1;     

PROCEDURE PVar2(VAR a1:T1; VAR a2:T2);
BEGIN (* PVar2 *)
 PrintT1(a1);
 PrintT2(a2);
END PVar2;

PROCEDURE PVar3(VAR a1:T1; VAR a2:T2; VAR a3:T3);
BEGIN (* PVar3 *)
 PrintT1(a1);
 PrintT2(a2);
 PrintT3(a3);
END PVar3;

PROCEDURE PVal1(a1:T1);
BEGIN (* PVal1 *)
 PrintT1(a1);
END PVal1;

PROCEDURE PVal2(a1:T1; a2:T2);
BEGIN (* PVal2 *)
 PrintT1(a1);
 PrintT2(a2);
END PVal2;

PROCEDURE PVal3(a1:T1; a2:T2; a3:T3);
BEGIN (* PVal3 *)
 PrintT1(a1);
 PrintT2(a2);
 PrintT3(a3);
END PVal3;

BEGIN (* Index05 *)
 a1:='abc';
 a2[0]:='123';
 a2[1]:='456';
 a3[0]:=a2;
 a3[1,0]:='ABC';
 a3[1,1]:='DEF';

 PVar1(a1);
 PVal1(a1); 
 O.String('----------------'); O.Ln;
 PVar2(a1,a2);
 PVal2(a1,a2);
 O.String('----------------'); O.Ln;
 PVar3(a1,a2,a3);
 PVal3(a1,a2,a3);
 
END Index05.
