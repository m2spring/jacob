MODULE ErrLists;

IMPORT IO, POS, STR, Storage, SYSTEM;

TYPE   tErrorList*    = POINTER TO tErrorListDesc;
       tErrorListDesc = RECORD
                         pos  : POS.tPosition;
                         len  :LONGINT; 
                         str  : POINTER TO ARRAY 1000 OF CHAR;
                         prev ,
                         next : tErrorList;
                        END;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE New*() : tErrorList;
VAR el:tErrorList;
BEGIN (* New *)
 NEW(el);
 el^.pos  := POS.NoPosition;
 el^.len  := 0;
 el^.prev := el;
 el^.next := el;
 RETURN el;
END New;

(*----------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Kill*(VAR el : tErrorList);
VAR e,d:tErrorList;
BEGIN (* Kill *)
 e:=el^.next;
 WHILE e#el DO
  IF e^.len>0 THEN Storage.DEALLOCATE(e^.str,e^.len); END;
  d:=e; e:=e^.next;
  Storage.DEALLOCATE(d,SIZE(tErrorListDesc));
 END; (* WHILE *)
 Storage.DEALLOCATE(el,SIZE(tErrorListDesc));
END Kill;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE App*(el : tErrorList; p : POS.tPosition; s : ARRAY OF CHAR);
VAR e,n:tErrorList; i:LONGINT; 
BEGIN (* App *)
 IF s[0]=0X THEN RETURN; END;

 INC(el^.len);
 e:=el^.prev;
 WHILE POS.Compare(e^.pos,p)=1 (* e^.pos > p *) DO e:=e^.prev; END;

 (* e^.pos <= p ! *)
 NEW(n);
 n^.pos        := p;
 n^.len        := STR.Length(s);
 Storage.ALLOCATE(n^.str,n^.len+1);
 FOR i:=0 TO n^.len DO n^.str^[i]:=s[i]; END;
 n^.next       := e^.next;
 n^.prev       := e;
 e^.next^.prev := n;
 e^.next       := n;
END App;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Write*(f : IO.tFile; el : tErrorList; prefix : ARRAY OF CHAR);
VAR e:tErrorList;
BEGIN (* Write *)
 e:=el^.next;
 WHILE e#el DO
  IO.WriteS(f,prefix);
  IO.WriteN(f,e^.pos.Line,0,10);
  IO.WriteS(f,',');
  IO.WriteN(f,e^.pos.Column,0,10);
  IO.WriteS(f,': ');
  IO.WriteS(f,e^.str^);
  IO.WriteNl(f);
  e:=e^.next;
 END; (* WHILE *)
END Write;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Length*(el : tErrorList):LONGINT; 
BEGIN (* Length *)
 RETURN el^.len;
END Length;

(*------------------------------------------------------------------------------------------------------------------------------*)
END ErrLists.

