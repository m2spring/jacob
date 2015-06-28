MODULE CV;
IMPORT SYSTEM, Storage, ARG, ASM, FIL, LAB, O, OT, StringMem, Strings;

CONST TabSize     = 1024;
TYPE  tLabels     = POINTER TO tLabelsDesc;
      tLabelsDesc = RECORD
                     next       : tLabels;
                     label      : LAB.T;
                     isExported : BOOLEAN; 
                    END;
      tElem       = POINTER TO tElemDesc;
      tElemDesc   = RECORD
                     next   : tElem;
		     labels : tLabels;
		     string  : OT.oSTRING;
		     real	 : OT.oREAL;
		     longreal: OT.oLONGREAL;
                     a,b     : LONGINT; 
                    END;
      tTab        = RECORD
                     HashMethod  : PROCEDURE(VAR x:tElemDesc):LONGINT; 
                     EqualMethod : PROCEDURE(VAR e:tElemDesc;f:tElem):BOOLEAN; 
                     CodeMethod  : PROCEDURE(e:tElem);
                     isEmpty     : BOOLEAN; 
                     root        : ARRAY TabSize OF tElem;
                    END;
TYPE tTable       = POINTER TO tTableDesc; 
     tTableDesc   = RECORD
                          	st,re,lr:tTab;
                               END;

(************************************************************************************************************************)
PROCEDURE HashString(VAR e:tElemDesc):LONGINT; 
VAR s:Strings.tString; idx:LONGINT; i:Strings.tStringIndex; 
BEGIN (* HashString *)
 StringMem.GetString(e.string,s); idx:=0; 
 FOR i:=1 TO s.Length DO INC(idx,ORD(s.Chars[i])); END; (* FOR *)
 RETURN idx MOD TabSize; 
END HashString;

PROCEDURE HashReal(VAR e:tElemDesc):LONGINT; 
BEGIN (* HashReal *)
 RETURN SYSTEM.VAL(LONGINT,e.real) MOD TabSize;
END HashReal;

PROCEDURE HashLongreal(VAR e:tElemDesc):LONGINT; 
VAR retype:RECORD
	    longreal : OT.oLONGREAL;
	    lo,hi    :LONGINT; 
           END;
BEGIN (* HashLongreal *)
 retype.longreal:=e.longreal; 
 RETURN (retype.lo+retype.hi) MOD TabSize; 
END HashLongreal;

(************************************************************************************************************************)
PROCEDURE EqualString(VAR e:tElemDesc; f:tElem):BOOLEAN; 
VAR s:Strings.tString; 
BEGIN (* EqualString *)
 StringMem.GetString(e.string,s); 
 RETURN StringMem.IsEqual(f^.string,s);
END EqualString;

PROCEDURE EqualReal(VAR e:tElemDesc; f:tElem):BOOLEAN;
BEGIN (* EqualReal *)                                 
 RETURN e.real=f^.real; 
END EqualReal;

PROCEDURE EqualLongreal(VAR e:tElemDesc; f:tElem):BOOLEAN;
BEGIN (* EqualLongreal *)
 RETURN e.longreal.v=f^.longreal.v; 
END EqualLongreal;

(************************************************************************************************************************)
PROCEDURE CodeString(e:tElem);
VAR str:Strings.tString; arr,tmp:ARRAY 2*Strings.cMaxStrLength+1 OF CHAR; 
    i,v,src,dst:LONGINT; c:CHAR; 
BEGIN (* CodeString *)
 StringMem.GetString(e^.string,str); 
 Strings.StringToArray(str,arr); 
 
 src:=0; dst:=0; 
 LOOP
  IF src>LEN(arr) THEN EXIT; END; (* IF *)
  c:=arr[src]; 
  CASE c OF
  |0X                        : EXIT; 				 
  |1X..1FX,'"','\',7FX..0FFX: tmp[dst]:='\'; INC(dst); 
                               CASE c OF
                               |0AX    : tmp[dst]:='b'; 
                               |0BX    : tmp[dst]:='t'; 
                               |0CX    : tmp[dst]:='n'; 
                               |0EX    : tmp[dst]:='f'; 
                               |0FX    : tmp[dst]:='r'; 
                               |'"','\': tmp[dst]:=c; 
                               ELSE      v:=ORD(c); 
                                         tmp[dst+2]:=CHR(48+(v MOD 8)); v:=v DIV 8; 
                                         tmp[dst+1]:=CHR(48+(v MOD 8)); v:=v DIV 8; 
                                         tmp[dst  ]:=CHR(48+(v MOD 8)); 
                                         INC(dst,2); 
                               END; (* CASE *)
                               INC(dst); 
  ELSE                         tmp[dst]:=c; INC(dst); 
  END; (* CASE *)                      
  INC(src); 
 END; (* WHILE *)
 tmp[dst]:=0X; 
 
 ASM.Asciz(tmp); 
END CodeString;

PROCEDURE CodeReal(e:tElem);
VAR retype:RECORD
            real: REAL;
            int : LONGINT;
           END;
    arr:ARRAY 31 OF CHAR; 
BEGIN (* CodeReal *)
 retype.real:=e^.real; 
 ASM.LongI(retype.int); 
 IF ARG.OptionCommentsInAsm THEN OT.oREAL2ARR(e^.real,arr); ASM.CmtS(arr); END; (* IF *)
END CodeReal;

PROCEDURE CodeLongreal(e:tElem);
VAR retype:RECORD
	    longreal : OT.oLONGREAL;
	    lo,hi    : LONGINT; 
           END;
    arr:ARRAY 31 OF CHAR; 
BEGIN (* CodeLongreal *)
 retype.longreal:=e^.longreal; 
 ASM.LongI2(retype.lo,retype.hi); 
 IF ARG.OptionCommentsInAsm THEN OT.oLONGREAL2ARR(e^.longreal,arr); ASM.CmtS(arr); END; (* IF *)
END CodeLongreal;

(************************************************************************************************************************)
PROCEDURE Init*;
VAR t:tTable; i:LONGINT; 
BEGIN (* Init *)
 NEW(t); 
  t^.st.HashMethod:=HashString; t^.st.EqualMethod:=EqualString; t^.st.CodeMethod:=CodeString; 
  t^.st.isEmpty:=TRUE; 
  FOR i:=0 TO TabSize-1 DO t^.st.root[i]:=NIL; END; (* FOR *)

  t^.re.HashMethod:=HashReal; t^.re.EqualMethod:=EqualReal; t^.re.CodeMethod:=CodeReal; 
  t^.re.isEmpty:=TRUE; 
  FOR i:=0 TO TabSize-1 DO t^.re.root[i]:=NIL; END; (* FOR *)

  t^.lr.HashMethod:=HashLongreal; t^.lr.EqualMethod:=EqualLongreal; t^.lr.CodeMethod:=CodeLongreal; 
  t^.lr.isEmpty:=TRUE; 
  FOR i:=0 TO TabSize-1 DO t^.lr.root[i]:=NIL; END; (* FOR *)

 FIL.ActP^.ConstTable:=t; 
END Init;

(************************************************************************************************************************)
PROCEDURE Lookup(VAR tab:tTab; VAR elem:tElemDesc):tElem; 
VAR idx:LONGINT; e:tElem; 
BEGIN (* Lookup *)
 idx:=tab.HashMethod(elem); 
 
 e:=tab.root[idx]; 
 WHILE e#NIL DO
  IF tab.EqualMethod(elem,e) THEN RETURN e; END; (* IF *)
  e:=e^.next; 
 END; (* WHILE *)
 
 NEW(e); 
 e^:=elem; e^.next:=tab.root[idx]; e^.labels:=NIL; tab.root[idx]:=e; 
 RETURN e; 
END Lookup;

(************************************************************************************************************************)
PROCEDURE AppendLabel(VAR labels:tLabels; lab:LAB.T; isExported:BOOLEAN);
VAR l:tLabels;
BEGIN (* AppendLabel *)                                  
 NEW(l); l^.next:=labels; l^.label:=lab; l^.isExported:=isExported; labels:=l; 
END AppendLabel;

(************************************************************************************************************************)
PROCEDURE NamedConst(VAR tab:tTab; VAR elem:tElemDesc; name:LAB.T; isExported:BOOLEAN);
VAR e:tElem; 
BEGIN (* NamedConst *)
 e:=Lookup(tab,elem); 
 IF isExported THEN 
    AppendLabel(e^.labels,name,isExported); 
    tab.isEmpty:=FALSE; 
 END; (* IF *)
END NamedConst;

(************************************************************************************************************************)
PROCEDURE Const(VAR tab:tTab; VAR elem:tElemDesc):LAB.T;
VAR e:tElem; 
BEGIN (* Const *)
 e:=Lookup(tab,elem); 
 IF e^.labels=NIL THEN 
    AppendLabel(e^.labels,LAB.NewLocal(),FALSE); 
    tab.isEmpty:=FALSE; 
 END; (* IF *)
 RETURN e^.labels^.label; 
END Const;

(************************************************************************************************************************)
PROCEDURE NamedString*(v:OT.oSTRING; name:LAB.T; isExported:BOOLEAN);
VAR elem:tElemDesc; t:tTable;
BEGIN (* NamedString *)
 IF OT.LengthOfoSTRING(v)#0 THEN 
    elem.string:=v; 
    t:=SYSTEM.VAL(tTable,FIL.ActP^.ConstTable); 
    NamedConst(t.st,elem,name,isExported); 
 END; (* IF *)
END NamedString;

(************************************************************************************************************************)
PROCEDURE String*(v:OT.oSTRING):LAB.T;
VAR elem:tElemDesc; t:tTable;
BEGIN (* String *)
 IF OT.LengthOfoSTRING(v)#0 THEN 
    elem.string:=v; 
    t:=SYSTEM.VAL(tTable,FIL.ActP^.ConstTable); 
    RETURN Const(t.st,elem); 
 ELSE 			 
    RETURN LAB.NullChar; 
 END; (* IF *)
END String;

(************************************************************************************************************************)
PROCEDURE NamedReal*(v:OT.oREAL; name:LAB.T; isExported:BOOLEAN);
VAR elem:tElemDesc; t:tTable;
BEGIN (* NamedReal *)
 elem.real:=v; 
 t:=SYSTEM.VAL(tTable,FIL.ActP^.ConstTable); 
 NamedConst(t.re,elem,name,isExported); 
END NamedReal;

(************************************************************************************************************************)
PROCEDURE Real*(v:OT.oREAL):LAB.T;
VAR elem:tElemDesc; t:tTable;
BEGIN (* Real *)
 elem.real:=v; 
 t:=SYSTEM.VAL(tTable,FIL.ActP^.ConstTable); 
 RETURN Const(t.re,elem); 
END Real;

(************************************************************************************************************************)
PROCEDURE NamedLongreal*(v:OT.oLONGREAL; name:LAB.T; isExported:BOOLEAN);
VAR elem:tElemDesc; t:tTable;
BEGIN (* NamedLongreal *)
 elem.longreal:=v; 
 t:=SYSTEM.VAL(tTable,FIL.ActP^.ConstTable); 
 NamedConst(t.lr,elem,name,isExported); 
END NamedLongreal;

(************************************************************************************************************************)
PROCEDURE Longreal*(v:OT.oLONGREAL):LAB.T;
VAR elem:tElemDesc; t:tTable;
BEGIN (* Longreal *)
 elem.longreal:=v; 
 t:=SYSTEM.VAL(tTable,FIL.ActP^.ConstTable); 
 RETURN Const(t.lr,elem); 
END Longreal;

(************************************************************************************************************************)
PROCEDURE CodeTab(VAR tab:tTab);
VAR i:INTEGER; e,f:tElem; l,k:tLabels;
BEGIN (* CodeTab *)
 FOR i:=0 TO TabSize-1 DO
  e:=tab.root[i]; 
  WHILE e#NIL DO
   IF e^.labels#NIL THEN 
      l:=e^.labels; 
      WHILE l#NIL DO
       IF l^.isExported THEN ASM.Globl(l^.label); END; (* IF *)
       ASM.Label(l^.label); 
       k:=l; l:=l^.next; Storage.DEALLOCATE(k,SIZE(tLabelsDesc)); 
      END; (* WHILE *)
      tab.CodeMethod(e); 
   END; (* IF *)
   f:=e; e:=e^.next; Storage.DEALLOCATE(f,SIZE(tElemDesc)); 
  END; (* WHILE *)
 END; (* FOR *)
END CodeTab;

(************************************************************************************************************************)
PROCEDURE Code*;
VAR t:tTable;

 PROCEDURE code;
 BEGIN (* code *)
   IF t.st.isEmpty & t.re.isEmpty & t.lr.isEmpty THEN RETURN; END; (* IF *)
 
   ASM.Ln;
   IF ARG.OptionCommentsInAsm THEN ASM.SepLine; END; (* IF *)
  
   ASM.Text;
   CodeTab(t.st); 
   IF t.re.isEmpty & t.lr.isEmpty THEN RETURN; END; (* IF *)
   ASM.Align(2);
   CodeTab(t.re); 
   CodeTab(t.lr); 
 END code;

BEGIN (* Code *)	   
 t:=SYSTEM.VAL(tTable,FIL.ActP^.ConstTable); 
 code;
 Storage.DEALLOCATE(FIL.ActP^.ConstTable,SIZE(tTableDesc)); 
END Code;

(************************************************************************************************************************)
END CV.

