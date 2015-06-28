MODULE M1;
IMPORT O:=Out;
VAR si,sb,se:SHORTINT; 
    in,ib,ie:INTEGER; 
    li,lb,le:LONGINT; 

PROCEDURE P(VAR p:LONGINT);
VAR l:LONGINT; 

 PROCEDURE Q;
 BEGIN (* Q *)
  O.Str("PQp:"); 
  FOR p:=0 TO 10 DO
   O.Int(p); O.Str(" "); 
  END; (* FOR *)     
  O.Ln;
 
  O.Str("PQl:"); 
  FOR l:=10 TO -10 BY -1 DO
   O.Int(l); O.Str(" "); 
  END; (* FOR *)     
  O.Ln;
 END Q;

BEGIN (* P *)  
 O.Str("Pp:"); 
 FOR p:=0 TO 10 DO
  O.Int(p); O.Str(" "); 
 END; (* FOR *)     
 O.Ln;

 O.Str("Pl:"); 
 FOR l:=10 TO -10 BY -1 DO
  O.Int(l); O.Str(" "); 
 END; (* FOR *)     
 O.Ln;
END P;


BEGIN (* M1 *)
 sb:=-5; se:=5; 
 FOR si:=sb+1 TO se+2 BY 2 DO
  O.Int(si); O.Ln;
 END; (* FOR *)  
 
 ib:=1; ie:=5; 
 FOR in:=ib+1 TO ie+2 BY -2 DO
  O.Int(in); O.Ln;
 END; (* FOR *)  
 
 lb:=500; le:=-100; 
 FOR li:=lb+1 TO le+2 BY -128 DO
  O.Int(li); O.Ln;
 END; (* FOR *)   
 
 FOR li:=0 TO 99999 DO
 END; (* FOR *)
 
 P(li);
 
END M1.
