MODULE M4;
VAR xsi,si:SHORTINT; 
    xin,in:INTEGER; 
    xli,li:LONGINT; 
    xse,se:SET;
    r:RECORD
       b:BOOLEAN; 
       i:LONGINT; 
      END;
    
PROCEDURE P;
VAR si:SHORTINT; 
    in:INTEGER; 
    li:LONGINT; 
    se:SET;
    r:RECORD
       b:BOOLEAN; 
       i:LONGINT; 
      END;
    
 PROCEDURE Q;
 BEGIN (* Q *)
  si:=si DIV 16;   si:=si-xsi; 
  in:=in DIV 16;   in:=in-xin; 
  li:=li DIV 16;   li:=li-xli; 
  se:=se-{10}; se:=se-xse; 
  r.i:=r.i DIV 16; 
 END Q;

BEGIN (* P *)
 si:=si DIV 16;   si:=si-xsi; 
 in:=in DIV 16;   in:=in-xin; 
 li:=li DIV 16;   li:=li-xli; 
 se:=se-{10}; se:=se-xse; 
 r.i:=r.i DIV 16; 
END P;

BEGIN (* M4 *)
 si:=si DIV 16;   si:=si-xsi; 
 in:=in DIV 16;   in:=in-xin; 
 li:=li DIV 16;   li:=li-xli; 
 se:=se-{10}; se:=se-xse; 

 si:=10-si;   si:=si-xsi; 
 in:=10-in;   in:=in-xin; 
 li:=10-li;   li:=li-xli; 
 se:={10}-se; se:=se-xse; 
 
 r.i:=r.i DIV 16; 
END M4.
