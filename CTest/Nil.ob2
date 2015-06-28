MODULE Nil;
TYPE  tPt=POINTER TO ARRAY OF CHAR;
      tPr=PROCEDURE;
VAR   pt:tPt;
      pr:tPr;
CONST c0=NIL;
      c1=NIL=NIL;
      c2=NIL#NIL;  

PROCEDURE Pt(p:tPt):tPt; 
BEGIN (* Pt *)         
 RETURN NIL; 
END Pt;

PROCEDURE Pr(p:tPr):tPr; 
BEGIN (* Pr *)
 RETURN NIL; 
END Pr;

BEGIN (* Nil *)
 pt:=NIL; 
 pr:=NIL; 
 IF NIL=NIL THEN END; (* IF *)
 IF NIL#NIL THEN END; (* IF *)
 IF pt=NIL THEN END; (* IF *)
 IF pr=NIL THEN END; (* IF *)
 IF NIL=pt THEN END; (* IF *)
 IF NIL=pr THEN END; (* IF *)
 pt:=Pt(NIL); 
 pr:=Pr(NIL); 
END Nil.
