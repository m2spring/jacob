MODULE M1;
IMPORT O:=Out, Storage, UTIS; 
TYPE T  * = RECORD     f   : LONGINT; END; P   = POINTER TO T  ;        
     T1 * = RECORD(T ) f1  : LONGINT; END; P1  = POINTER TO T1 ;     
     T11* = RECORD(T1) f11 : LONGINT; END; P11 = POINTER TO T11;
     T12* = RECORD(T1) f12 : LONGINT; END; P12 = POINTER TO T12;
     T13* = RECORD(T1) f13 : LONGINT; END; P13 = POINTER TO T13;
					     		    	 
     T2 * = RECORD(T ) f2  : LONGINT; END; P2  = POINTER TO T2 ;     
     T21* = RECORD(T2) f21 : LONGINT; END; P21 = POINTER TO T21;
     T22* = RECORD(T2) f22 : LONGINT; END; P22 = POINTER TO T22;
     T23* = RECORD(T2) f23 : LONGINT; END; P23 = POINTER TO T23;
     					     		    	 
     T3 * = RECORD(T ) f3  : LONGINT; END; P3  = POINTER TO T3 ;     
     T31* = RECORD(T3) f31 : LONGINT; END; P31 = POINTER TO T31;
     T32* = RECORD(T3) f32 : LONGINT; END; P32 = POINTER TO T32;
     T33* = RECORD(T3) f33 : LONGINT; END; P33 = POINTER TO T33;
VAR p:P;
     
(************************************************************************************************************************)
PROCEDURE RecordTest;
VAR  r    : T;
     r1   : T1;
     r11  : T11;
     r12  : T12;
     r13  : T13;
     r2   : T2;
     r21  : T21;
     r22  : T22;
     r23  : T23;
     r3   : T3;
     r31  : T31;
     r32  : T32;
     r33  : T33;
     
 PROCEDURE Proc(VAR r:T);
 BEGIN (* Proc *)
  WITH r:T11 DO O.Str(" T11  "); r.f11:=1; 
  |    r:T12 DO O.Str(" T12  "); r.f12:=1; 
  |    r:T13 DO O.Str(" T13  "); r.f13:=1;
  |    r:T1  DO O.Str(" T1   "); r.f1 :=1;
  |    r:T21 DO O.Str(" T21  "); r.f21:=1;
  |    r:T22 DO O.Str(" T22  "); r.f22:=1;
  |    r:T23 DO O.Str(" T23  "); r.f23:=1;
  |    r:T2  DO O.Str(" T2   "); r.f2 :=1;
  |    r:T31 DO O.Str(" T31  "); r.f31:=1;
  |    r:T32 DO O.Str(" T32  "); r.f32:=1;
  |    r:T33 DO O.Str(" T33  "); r.f33:=1;
  |    r:T3  DO O.Str(" T3   "); r.f3 :=1;
  ELSE          O.Str(" ELSE "); r.f  :=1;
  END; (* WITH *)
 END Proc;

BEGIN (* RecordTest *)
 O.StrLn('RecordTest'); 
 r1 .f1 :=0; O.Int(r1 .f1 ); Proc(r1 ); O.Int(r1 .f1 ); O.Ln; 
 r11.f11:=0; O.Int(r11.f11); Proc(r11); O.Int(r11.f11); O.Ln; 
 r12.f12:=0; O.Int(r12.f12); Proc(r12); O.Int(r12.f12); O.Ln; 
 r13.f13:=0; O.Int(r13.f13); Proc(r13); O.Int(r13.f13); O.Ln; 
 r2 .f2 :=0; O.Int(r2 .f2 ); Proc(r2 ); O.Int(r2 .f2 ); O.Ln; 
 r21.f21:=0; O.Int(r21.f21); Proc(r21); O.Int(r21.f21); O.Ln; 
 r22.f22:=0; O.Int(r22.f22); Proc(r22); O.Int(r22.f22); O.Ln; 
 r23.f23:=0; O.Int(r23.f23); Proc(r23); O.Int(r23.f23); O.Ln; 
 r3 .f3 :=0; O.Int(r3 .f3 ); Proc(r3 ); O.Int(r3 .f3 ); O.Ln; 
 r31.f31:=0; O.Int(r31.f31); Proc(r31); O.Int(r31.f31); O.Ln; 
 r32.f32:=0; O.Int(r32.f32); Proc(r32); O.Int(r32.f32); O.Ln; 
 r33.f33:=0; O.Int(r33.f33); Proc(r33); O.Int(r33.f33); O.Ln; 
 r  .f  :=0; O.Int(r  .f  ); Proc(r  ); O.Int(r  .f  ); O.Ln; 
END RecordTest;

(************************************************************************************************************************)
PROCEDURE PointerTest;
VAR  p   : P;
     p1  : P1;
     p11 : P11;
     p12 : P12;
     p13 : P13;
     p2  : P2;
     p21 : P21;
     p22 : P22;
     p23 : P23;
     p3  : P3;
     p31 : P31;
     p32 : P32;
     p33 : P33;
     
 PROCEDURE Proc(p:P);
 BEGIN (* Proc *)
  WITH p:P11 DO O.Str(" P11  "); p.f11:=1; 
  |    p:P12 DO O.Str(" P12  "); p.f12:=1; 
  |    p:P13 DO O.Str(" P13  "); p.f13:=1;
  |    p:P1  DO O.Str(" P1   "); p.f1 :=1;
  |    p:P21 DO O.Str(" P21  "); p.f21:=1;
  |    p:P22 DO O.Str(" P22  "); p.f22:=1;
  |    p:P23 DO O.Str(" P23  "); p.f23:=1;
  |    p:P2  DO O.Str(" P2   "); p.f2 :=1;
  |    p:P31 DO O.Str(" P31  "); p.f31:=1;
  |    p:P32 DO O.Str(" P32  "); p.f32:=1;
  |    p:P33 DO O.Str(" P33  "); p.f33:=1;
  |    p:P3  DO O.Str(" P3   "); p.f3 :=1;
  ELSE          O.Str(" ELSE "); p.f  :=1; 
  END; (* WITH *)
 END Proc;

BEGIN (* PointerTest *)
 O.StrLn('PointerTest'); 
 NEW(p1 ); 
 NEW(p11); 
 NEW(p12); 
 NEW(p13); 
 NEW(p2 ); 
 NEW(p21); 
 NEW(p22); 
 NEW(p23); 
 NEW(p3 ); 
 NEW(p31); 
 NEW(p32); 
 NEW(p33); 
 NEW(p  ); 
 
 p1 .f1 :=0; O.Int(p1 .f1 ); Proc(p1 ); O.Int(p1 .f1 ); O.Ln; 
 p11.f11:=0; O.Int(p11.f11); Proc(p11); O.Int(p11.f11); O.Ln; 
 p12.f12:=0; O.Int(p12.f12); Proc(p12); O.Int(p12.f12); O.Ln; 
 p13.f13:=0; O.Int(p13.f13); Proc(p13); O.Int(p13.f13); O.Ln; 
 p2 .f2 :=0; O.Int(p2 .f2 ); Proc(p2 ); O.Int(p2 .f2 ); O.Ln; 
 p21.f21:=0; O.Int(p21.f21); Proc(p21); O.Int(p21.f21); O.Ln; 
 p22.f22:=0; O.Int(p22.f22); Proc(p22); O.Int(p22.f22); O.Ln; 
 p23.f23:=0; O.Int(p23.f23); Proc(p23); O.Int(p23.f23); O.Ln; 
 p3 .f3 :=0; O.Int(p3 .f3 ); Proc(p3 ); O.Int(p3 .f3 ); O.Ln; 
 p31.f31:=0; O.Int(p31.f31); Proc(p31); O.Int(p31.f31); O.Ln; 
 p32.f32:=0; O.Int(p32.f32); Proc(p32); O.Int(p32.f32); O.Ln; 
 p33.f33:=0; O.Int(p33.f33); Proc(p33); O.Int(p33.f33); O.Ln; 
 p  .f  :=0; O.Int(p  .f  ); Proc(p  ); O.Int(p  .f  ); O.Ln; 
END PointerTest;

(************************************************************************************************************************)
BEGIN (* M1 *)
 RecordTest;
 PointerTest;
END M1.
