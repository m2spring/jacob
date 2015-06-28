MODULE Idents;
IMPORT O:=Out,Str,SYSTEM;

TYPE  T*  = LONGINT;
CONST MT* = 0;

CONST BufferSize  = 256*1024;
      HashTabSize = 1024;
      IdTabSize   = 8*1024;
TYPE  tElem       = POINTER TO tElemDesc;
      tElemDesc   = RECORD
                     id   : T;
                     pos  : LONGINT; 
                     next : tElem;
                    END;
      tBuffer     = POINTER TO ARRAY OF CHAR; 
      tIdTab      = POINTER TO ARRAY OF tElem; 
VAR   buffer      : tBuffer;
      hashTab     : ARRAY HashTabSize OF tElem;                  
      idTab       : tIdTab;
      hashSum     ,
      actStart    ,
      nextFree    ,
      nextId-     : LONGINT; 
      dummy       : T; 

(************************************************************************************************************************)
PROCEDURE IncreaseBuffer;
VAR newBuffer:tBuffer; n:LONGINT; 
BEGIN (* IncreaseBuffer *)
 n:=LEN(buffer^); 
 NEW(newBuffer,n+BufferSize); 
 SYSTEM.MOVE(SYSTEM.ADR(buffer^),SYSTEM.ADR(newBuffer^),n); 
 buffer:=newBuffer; 
END IncreaseBuffer;

(************************************************************************************************************************)
PROCEDURE IncreaseIdTab;
VAR newIdTab:tIdTab; n:LONGINT; 
BEGIN (* IncreaseIdTab *)
 n:=LEN(idTab^); 
 NEW(newIdTab,n+IdTabSize); 
 SYSTEM.MOVE(SYSTEM.ADR(idTab^),SYSTEM.ADR(newIdTab^),n*SIZE(tElem)); 
 idTab:=newIdTab; 
END IncreaseIdTab;

(************************************************************************************************************************)
PROCEDURE App*(c:CHAR);
BEGIN (* App *)      
 IF nextFree>=LEN(buffer^) THEN IncreaseBuffer; END; (* IF *)
 buffer[nextFree]:=c; INC(nextFree); 
 INC(hashSum,(nextFree-actStart)*ORD(c)); 
END App;

(************************************************************************************************************************)
PROCEDURE EqualReprs(aPos,bPos:LONGINT):BOOLEAN; 
TYPE tP=POINTER TO ARRAY 1000000 OF CHAR;
VAR a,b:tP;
BEGIN (* EqualReprs *)
 a:=SYSTEM.VAL(tP,SYSTEM.ADR(buffer[aPos])); 
 b:=SYSTEM.VAL(tP,SYSTEM.ADR(buffer[bPos])); 
 RETURN a^=b^; 
END EqualReprs;

(************************************************************************************************************************)
PROCEDURE Enter*():T;
VAR idx:LONGINT; e:tElem; id:T;
BEGIN (* Enter *)
 IF nextFree>=LEN(buffer^) THEN IncreaseBuffer; END; (* IF *)
 buffer[nextFree]:=0X; INC(nextFree); 
 
 idx:=hashSum MOD HashTabSize; hashSum:=0; 
 e:=hashTab[idx]; 
 WHILE e#NIL DO
  IF EqualReprs(e.pos,actStart) THEN nextFree:=actStart; RETURN e.id; END; (* IF *)
  e:=e.next; 
 END; (* WHILE *)
 
 NEW(e);
 e.id:=nextId; 
 e.pos:=actStart; actStart:=nextFree; 
 e.next:=hashTab[idx]; 
 hashTab[idx]:=e; 
 
 IF nextId>=LEN(idTab^) THEN IncreaseIdTab; END; (* IF *) 
 idTab[nextId]:=e; 
 id:=nextId; INC(nextId); 

 RETURN id; 
END Enter;

(************************************************************************************************************************)
PROCEDURE EnterNew*():T;
VAR idx:LONGINT; e:tElem; id:T;
BEGIN (* EnterNew *)
 IF nextFree>=LEN(buffer^) THEN IncreaseBuffer; END; (* IF *)
 buffer[nextFree]:=0X; INC(nextFree); 
 hashSum:=0; 
 
 NEW(e);
 e.id:=nextId; 
 e.pos:=actStart; actStart:=nextFree; 
 
 IF nextId>=LEN(idTab^) THEN IncreaseIdTab; END; (* IF *) 
 idTab[nextId]:=e; 
 id:=nextId; INC(nextId); 

 RETURN id; 
END EnterNew;

(************************************************************************************************************************)
PROCEDURE Make*(s:ARRAY OF CHAR):T;
VAR i:LONGINT; 
BEGIN (* Make *)
 i:=0; 
 WHILE (i<LEN(s)) & (s[i]#0X) DO
  App(s[i]); INC(i); 
 END; (* WHILE *) 
 RETURN Enter(); 
END Make;

(************************************************************************************************************************)
PROCEDURE Length*(id:T):LONGINT; 
VAR start,p:LONGINT; 
BEGIN (* Length *)
 IF (0<=id) & (id<nextId) THEN 
    start:=idTab[id].pos; p:=start; 
    WHILE buffer[p]#0X DO INC(p); END; (* WHILE *)
    RETURN p-start; 
 ELSE
    RETURN 0; 
 END; (* IF *)       
END Length;

(************************************************************************************************************************)
PROCEDURE Repr*(id:T):Str.T;
VAR i,src,dst:LONGINT; s:Str.T; c:CHAR; 
BEGIN (* Repr *)
 IF (id<0) OR (nextId<=id) THEN id:=0; END; (* IF *)
 
 NEW(s,1+Length(id)); 
 src:=idTab[id].pos; dst:=0; 
 LOOP
  c:=buffer[src]; s[dst]:=c; 
  IF c=0X THEN EXIT; END; (* IF *)
  INC(src); INC(dst); 
 END; (* LOOP *)

 RETURN s; 
END Repr;

(************************************************************************************************************************)
PROCEDURE GetRepr*(VAR s:ARRAY OF CHAR; id:T);
VAR src,dst:LONGINT; c:CHAR; 
BEGIN (* GetRepr *)
 IF (0<=id) & (id<nextId) THEN 
    src:=idTab[id].pos; dst:=0; 
    LOOP
     IF dst>=LEN(s) THEN s[LEN(s)-1]:=0X; RETURN; END; (* IF *)
     c:=buffer[src]; 
     s[dst]:=c; 
     IF c=0X THEN RETURN; END; (* IF *)
     INC(src); INC(dst); 
    END; (* LOOP *)
 ELSE
    s[0]:=0X; 
 END; (* IF *)       
END GetRepr;

(************************************************************************************************************************)
PROCEDURE Dump*;
VAR i,p:LONGINT; s:Str.T;
BEGIN (* Dump *)
 FOR i:=0 TO nextId-1 DO
  O.Int(i); O.Str(': "'); 
  s:=Repr(i); O.Str(s^); 
  O.StrLn('"'); 
 END; (* FOR *)
END Dump;

(************************************************************************************************************************)
BEGIN (* Idents *)
 NEW(buffer,BufferSize); nextFree:=0; actStart:=0; hashSum:=0; 
 NEW(idTab,IdTabSize); nextId:=0; 
 dummy:=Make(''); 
END Idents.
