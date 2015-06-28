MODULE M2;

IMPORT S:=SYSTEM; 

VAR i,j,k:LONGINT; c:CHAR; 

(*<<<<<<<<<<<<<<<
PROCEDURE P1(s:ARRAY OF CHAR);

 PROCEDURE Q;
 BEGIN (* Q *)
  s[i]:=c; 
 END Q;

BEGIN (* P1 *)
 s[i]:=c; 
END P1;
>>>>>>>>>>>>>>>*)

PROCEDURE P3(s:ARRAY OF ARRAY OF ARRAY OF ARRAY OF ARRAY OF ARRAY OF ARRAY OF ARRAY OF CHAR);

 PROCEDURE Q;
 BEGIN (* Q *)
(*<<<<<<<<<<<<<<<
  s[i,j,k]:=c; 
>>>>>>>>>>>>>>>*)
  i:=S.ADR(s[i]); 
 END Q;

BEGIN (* P3 *)
(*<<<<<<<<<<<<<<<
 s[i,j,k]:=c; 
>>>>>>>>>>>>>>>*)
 i:=S.ADR(s[i]); 
END P3;

BEGIN (* M2 *)
END M2.
