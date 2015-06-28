MODULE M1;
IMPORT 
O:=Out,
SYS:=SYSTEM;

TYPE P0 = POINTER TO T0;
     T0 = RECORD
           f:BOOLEAN; 
          END;
     P1 = POINTER TO T1;
     T1 = RECORD(T0)
           i:SHORTINT; 
          END;        

(************************************************************************************************************************)
PROCEDURE P(VAR a:ARRAY OF SYS.BYTE);
BEGIN (* P *)
 O.Int(LEN(a)); O.Ln;
END P;

(************************************************************************************************************************)
(*<<<<<<<<<<<<<<<
PROCEDURE Record;
VAR v0:T0; v1:T1;       

(******************************************************************************)
 PROCEDURE Q(VAR p:T0);
 
  PROCEDURE Q1;
  BEGIN (* Q1 *)
   P(p); 
  END Q1;
 
 BEGIN (* Q *)       
  P(p); 
 END Q;

(******************************************************************************)
BEGIN (* Record *)
 Q(v0); 
 Q(v1); 
END Record;
>>>>>>>>>>>>>>>*)

(************************************************************************************************************************)
PROCEDURE PointerToRecord;
VAR p0:ARRAY 10 OF P0; p1:P1; i:LONGINT; 
BEGIN (* PointerToRecord *)
 i:=5; 
 NEW(p0[i]); 
 NEW(p1); 

 P(p0[i]^); 
(*<<<<<<<<<<<<<<<
 p0:=p1; 
 P(p0^); 
>>>>>>>>>>>>>>>*)
END PointerToRecord;

(************************************************************************************************************************)
(*<<<<<<<<<<<<<<<
PROCEDURE OpenArrayPar;
TYPE T=ARRAY 10 OF CHAR;
VAR a1:ARRAY 5 OF T; a2:ARRAY 6,7 OF T;

 PROCEDURE P1(a1:ARRAY OF T; a2:ARRAY OF ARRAY OF T);
 VAR i,j:LONGINT; 
 
  PROCEDURE Q;
  BEGIN (* Q *)
   P(a1); 
   P(a1[i]);     
   P(a2); 
   P(a2[i]); 
   P(a2[i,j]); 
  END Q;

 BEGIN (* P1 *)
  P(a1); 
  P(a1[i]);     
  P(a2); 
  P(a2[i]); 
  P(a2[i,j]); 
  Q;
 END P1;

BEGIN (* OpenArrayPar *)
 P1(a1,a2);
END OpenArrayPar;
>>>>>>>>>>>>>>>*)

(************************************************************************************************************************)
PROCEDURE OpenArrayPointer;
TYPE T=ARRAY 10 OF CHAR;
VAR p1:ARRAY 10 OF POINTER TO ARRAY OF T; 
    p2:ARRAY 10 OF POINTER TO ARRAY OF ARRAY 20 OF T; 
VAR i,j,k:LONGINT; 
BEGIN (* OpenArrayPointer *)
 i:=4; 
 NEW(p1[i],10); 
 NEW(p2[i],10); 

 P(p1[i]^);                                 
 P(p2[i]^); 
 P(p1[i,j]); 
 P(p2[i,j]); 
 P(p2[i,j,k]); 
END OpenArrayPointer;

(************************************************************************************************************************)
BEGIN (* M1 *)
 OpenArrayPointer;
END M1.
