MODULE Index02;
(*% Indexing: Fixed mit mehrdimensionalen Arrays *)

IMPORT O:=Out;

CONST Str1 = '1111111111';
CONST Str2 = '2222222222';
CONST Str3 = '3333333333';
CONST Str4 = '4444444444';

TYPE 
  T0 = ARRAY 11 OF CHAR; 
  T1 = ARRAY 2 OF ARRAY 5 OF T0;
  
VAR 
  a0:T0;
  a1:T1;
  
BEGIN (* Index02 *)
 a0:='Butterbrot'; 
 a1[0][0]:=Str1;
 a1[0][1]:=Str2;
 a1[0][2]:=Str3;
 a1[0][3]:=a0;
 a1[0][4]:=Str4;
 
 a1[1,0]:=a1[0][4];
 a1[1,1]:=a1[0,2];
 a1[1,2]:=a1[0,1];
 a1[1,3]:=a1[0,0];
 a1[1,4]:=a1[0,3];
 
 O.String(a1[0,0]); O.Ln;
 O.String(a1[0,1]); O.Ln;
 O.String(a1[0,2]); O.Ln;
 O.String(a1[0,3]); O.Ln;
 O.String(a1[0,4]); O.Ln;
 O.Ln;
 O.String(a1[1,0]); O.Ln;
 O.String(a1[1,1]); O.Ln;
 O.String(a1[1,2]); O.Ln;
 O.String(a1[1,3]); O.Ln;
 O.String(a1[1,4]); O.Ln;
 O.Ln;
END Index02.
