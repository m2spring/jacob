MODULE OpenInd02;
(*% OpenIndex: Global Fixed MehrDim -> Open *)

IMPORT O:=Out;

TYPE 
   Ta0* = ARRAY OF CHAR;
   Ta1* = ARRAY OF ARRAY OF CHAR;
   Ta2* = ARRAY OF ARRAY OF ARRAY OF CHAR;

   Tp0* = POINTER TO Ta0;
   Tp1* = POINTER TO Ta1;
   Tp2* = POINTER TO Ta2;
   
   T0*  = ARRAY 5 OF CHAR;
   T1*  = ARRAY 4 OF T0;
   T2*  = ARRAY 3 OF T1;
   
VAR 
   a0  : T0;
   a1  : T1;
   a2  : T2;

   p0  : Tp0;
   p1  : Tp1;
   p2  : Tp2;

(*--- Ausgabe Prozeduren ---*)
PROCEDURE PrintTa0(s:Ta0);
BEGIN (* PrintTa0 *)
 O.String(s); O.Ln;
 O.String('----'); O.Ln;
END PrintTa0;

PROCEDURE PrintTa1(a1:Ta1);
VAR i:LONGINT; 
BEGIN (* PrintTa1 *)
 i:=0; 
 O.String(a1[i]); O.Ln;
 i:=1; 
 O.String(a1[i]); O.Ln;
 i:=2; 
 O.String(a1[i]); O.Ln;
 i:=3; 
 O.String(a1[i]); O.Ln;
 O.String('----'); O.Ln;
END PrintTa1;

PROCEDURE PrintTa2(a2:Ta2);
VAR i:LONGINT; 
BEGIN (* PrintTa2 *)
 i:=0;
 PrintTa1(a2[i]);
 i:=1; 
 PrintTa1(a2[i]);
 i:=2; 
 PrintTa1(a2[i]);
END PrintTa2;

(*--------------------------*)

(************************************************************************************************************************)
(* Record-Parameter                                                                                                     *)
(************************************************************************************************************************)
PROCEDURE PVar(VAR a0:Ta0; VAR a1:Ta1; VAR a2:Ta2);
BEGIN (* PVar *)
 PrintTa0(a0);
 PrintTa1(a1);
 PrintTa2(a2);
 O.String('------------------------'); O.Ln;
END PVar;

PROCEDURE PVal(a0:Ta0; a1:Ta1; a2:Ta2);
BEGIN (* PVal *)
 PrintTa0(a0);
 PrintTa1(a1);
 PrintTa2(a2);
 O.String('------------------------'); O.Ln;
END PVal;

(************************************************************************************************************************)
BEGIN (* OpenInd02 *)
 a0:='abcd';

 a1[0]:=a0;
 a1[1]:='efgh';
 a1[2]:='ijkl';
 a1[3]:='mnop';

 a2[0]:=a1;

 a2[1,0]:='1234'; 
 a2[1,1]:='5678';
 a2[1,2]:='STUV'; 
 a2[1,3]:='WXYZ';

 a2[2,0]:='ABCD';
 a2[2,1]:='EFGH';
 a2[2,2]:='IJKL';
 a2[2,3]:='MNOP';

 PVar(a0,a1,a2);
 PVal(a0,a1,a2);
 
 NEW(p0,5);
 NEW(p1,4,5);
 NEW(p2,3,4,5);

 COPY(a0,p0^);

 COPY(a1[0],p1[0]);
 COPY('efgh',p1[1]);
 COPY('ijkl',p1[2]);
 COPY('mnop',p1[3]);

 COPY('abcd',p2[0,0]);
 COPY('efgh',p2[0,1]);
 COPY('ijkl',p2[0,2]);
 COPY('mnop',p2[0,3]);
 COPY('1234',p2[1,0]); 
 COPY('5678',p2[1,1]);
 COPY('STUV',p2[1,2]); 
 COPY('WXYZ',p2[1,3]);
 COPY('ABCD',p2[2,0]);
 COPY('EFGH',p2[2,1]);
 COPY('IJKL',p2[2,2]);
 COPY('MNOP',p2[2,3]);

 PVar(p0^,p1^,p2^);
 PVal(p0^,p1^,p2^);
END OpenInd02.

