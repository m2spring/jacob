MODULE TypeTest;
IMPORT O:=Out; 


TYPE T0* = RECORD     f0:SHORTINT; END; P0* = POINTER TO T0;
     T1* = RECORD(T0) f1:SHORTINT; END; P1* = POINTER TO T1;
     T2* = RECORD(T1) f2:SHORTINT; END; P2* = POINTER TO T2;
     T3* = RECORD(T2) f3:SHORTINT; END; P3* = POINTER TO T3;
     T4* = RECORD(T3) f4:SHORTINT; END; P4* = POINTER TO T4;
     T5* = RECORD(T4) f5:SHORTINT; END; P5* = POINTER TO T5;
     T6* = RECORD(T5) f6:SHORTINT; END; P6* = POINTER TO T6;
     T7* = RECORD(T6) f7:SHORTINT; END; P7* = POINTER TO T7;
VAR f:BOOLEAN; 

PROCEDURE Local(VAR r:T0);
BEGIN (* Local *)
 O.Str('r IS '); 
 IF r IS T0 THEN O.Str(' T0');  END; (* IF *)
 IF r IS T1 THEN O.Str(' T1');  END; (* IF *)
 IF r IS T2 THEN O.Str(' T2');  END; (* IF *)
 IF r IS T3 THEN O.Str(' T3');  END; (* IF *)
 IF r IS T4 THEN O.Str(' T4');  END; (* IF *)
 IF r IS T5 THEN O.Str(' T5');  END; (* IF *)
 IF r IS T6 THEN O.Str(' T6');  END; (* IF *)
 IF r IS T7 THEN O.Str(' T7');  END; (* IF *)
END Local;

PROCEDURE Stack(VAR r:T0);

 PROCEDURE Q;
 BEGIN (* Q *)
 O.Str('r IS '); 
 IF r IS T0 THEN O.Str(' T0');  END; (* IF *)
 IF r IS T1 THEN O.Str(' T1');  END; (* IF *)
 IF r IS T2 THEN O.Str(' T2');  END; (* IF *)
 IF r IS T3 THEN O.Str(' T3');  END; (* IF *)
 IF r IS T4 THEN O.Str(' T4');  END; (* IF *)
 IF r IS T5 THEN O.Str(' T5');  END; (* IF *)
 IF r IS T6 THEN O.Str(' T6');  END; (* IF *)
 IF r IS T7 THEN O.Str(' T7');  END; (* IF *)
 END Q;

BEGIN (* Stack *)
 Q;
END Stack;

PROCEDURE Caller(msg:ARRAY OF CHAR; Callee:PROCEDURE(VAR r:T0));
VAR r0:T0; 
    r1:T1; 
    r2:T2; 
    r3:T3; 
    r4:T4; 
    r5:T5; 
    r6:T6; 
    r7:T7; 
BEGIN (* Caller *)
 O.StrLn(msg); 
 O.Str('r0: '); Callee(r0); O.Ln;  
 O.Str('r1: '); Callee(r1); O.Ln;  
 O.Str('r2: '); Callee(r2); O.Ln;  
 O.Str('r3: '); Callee(r3); O.Ln;  
 O.Str('r4: '); Callee(r4); O.Ln;  
 O.Str('r5: '); Callee(r5); O.Ln;  
 O.Str('r6: '); Callee(r6); O.Ln;  
 O.Str('r7: '); Callee(r7); O.Ln;  
END Caller;

PROCEDURE Pointer();
VAR p0:P0;
    p1:P1;
    p2:P2;
    p3:P3;
    p4:P4;
    p5:P5;
    p6:P6;
    p7:P7;
    arr:ARRAY 8 OF P0;
    i:SHORTINT; 
BEGIN (* Pointer *)
 NEW(p0); arr[0]:=p0; 
 NEW(p1); arr[1]:=p1; 
 NEW(p2); arr[2]:=p2; 
 NEW(p3); arr[3]:=p3; 
 NEW(p4); arr[4]:=p4; 
 NEW(p5); arr[5]:=p5; 
 NEW(p6); arr[6]:=p6; 
 NEW(p7); arr[7]:=p7; 
 
 O.StrLn('Pointer');  
 FOR i:=0 TO LEN(arr)-1 DO
  O.Str('p IS '); 
  IF arr[i] IS P0 THEN O.Str(' P0');  END; (* IF *)
  IF arr[i] IS P1 THEN O.Str(' P1');  END; (* IF *)
  IF arr[i] IS P2 THEN O.Str(' P2');  END; (* IF *)
  IF arr[i] IS P3 THEN O.Str(' P3');  END; (* IF *)
  IF arr[i] IS P4 THEN O.Str(' P4');  END; (* IF *)
  IF arr[i] IS P5 THEN O.Str(' P5');  END; (* IF *)
  IF arr[i] IS P6 THEN O.Str(' P6');  END; (* IF *)
  IF arr[i] IS P7 THEN O.Str(' P7');  END; (* IF *)
  O.Ln;
 END; (* FOR *)
 f:=p0 IS P2; 
END Pointer;

BEGIN (* TypeTest *)
 Caller('Local',Local); 
 Caller('Stack',Stack); 
 Pointer;
END TypeTest.
