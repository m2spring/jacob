MODULE RandomTokens;
IMPORT ID:=Idents,O:=Out,L:=Lib,Str,VerboseGC;

CONST maxLen=20;
      MinCh='A'; MaxCh='B';
TYPE tElem=POINTER TO tElemDesc;
     tElemDesc = RECORD
                  id:ID.T;
                  s:ARRAY maxLen OF CHAR; 
                  next:tElem;
                 END;
VAR head:tElem; i,count:LONGINT; 

(************************************************************************************************************************)
PROCEDURE MakeStr;
VAR i,n:LONGINT; c:CHAR; id:ID.T; e:tElem; 
BEGIN (* MakeStr *)
 n:=L.RANDOM(maxLen); 

 NEW(e); 
 FOR i:=0 TO n-1 DO
  c:=CHR(ORD(MinCh)+L.RANDOM(ORD(MaxCh)-ORD(MinCh)+1)); 
  e.s[i]:=c; 
  ID.App(c); 
 END; (* FOR *)            
 e.s[n]:=0X; 
 
 e.id:=ID.Enter(); 
 e.next:=head; 
 head:=e; 
 INC(count); 
END MakeStr;

(************************************************************************************************************************)
PROCEDURE TestAll;
VAR e:tElem; n:LONGINT; s:Str.T;
BEGIN (* TestAll *)
 O.Str('Tested '); 
 
 e:=head; n:=0; 
 WHILE e#NIL DO
  s:=ID.Repr(e.id); 
  IF (ID.Make(e.s)#e.id) OR (e.s#s^) THEN 
     O.StrLn('Test failed'); 
     HALT(1); 
  END; (* IF *)
  INC(n); 
  e:=e.next; 
 END; (* WHILE *)

 O.Int(n); 
 O.Char(' '); 
 O.Int(ID.nextId); 
 O.Char(' '); 
 O.Int(ID.nextId*100 DIV n); 
 O.Char(0DX); O.Ln;
END TestAll;

(************************************************************************************************************************)
BEGIN (* RandomTokens *)
 count:=0; 
 LOOP
  MakeStr;
  IF count MOD (4*1024)=0 THEN TestAll; END; (* IF *)  
  IF count MOD (20*1024)=0 THEN count:=0; head:=NIL; END; (* IF *)
 END; (* LOOP *)
END RandomTokens.
