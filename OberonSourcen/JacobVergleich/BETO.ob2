MODULE BETO;
IMPORT ASM, ASMOP, ERR, Idents, InOut, LAB, OT, StringMem, Strings;

PROCEDURE PrintCHAR*(v:CHAR);
BEGIN (* PrintCHAR *)
 InOut.Write(v); 
END PrintCHAR;

PROCEDURE PrintoCHAR*(v:OT.oCHAR);
VAR s:ARRAY 11 OF CHAR; 
BEGIN (* PrintoCHAR *)
 OT.oCHAR2ARR(v,s); InOut.WriteString(s); 
END PrintoCHAR;

PROCEDURE PrintoBOOLEAN*(v:OT.oBOOLEAN);
VAR s:ARRAY 11 OF CHAR; 
BEGIN (* PrintoBOOLEAN *)
 OT.oBOOLEAN2ARR(v,s); InOut.WriteString(s); 
END PrintoBOOLEAN;                  

PROCEDURE PrintoLONGINT*(v:OT.oLONGINT);
VAR s:ARRAY 51 OF CHAR; 
BEGIN (* PrintoLONGINT *)
 OT.oLONGINT2ARR(v,s); InOut.WriteString(s); 
END PrintoLONGINT;

PROCEDURE PrintoREAL*(v:OT.oREAL);
VAR s:ARRAY 51 OF CHAR; 
BEGIN (* PrintoREAL *)
 OT.oREAL2ARR(v,s); InOut.WriteString(s); 
END PrintoREAL;                

PROCEDURE PrintoSET*(v:OT.oSET);
VAR s:ARRAY 51 OF CHAR; 
BEGIN (* PrintoSET *)
 OT.oSET2ARR(v,s); InOut.WriteString(s); 
END PrintoSET;

PROCEDURE PrintoSTRING*(v:OT.oSTRING);
VAR s:ARRAY 301 OF CHAR; 
BEGIN (* PrintoSTRING *)
 OT.oSTRING2ARR(v,s); InOut.WriteString(s); 
END PrintoSTRING;

PROCEDURE PrintT*(l:LAB.T);
BEGIN (* PrintT *)
 IF l=NIL THEN 
    InOut.WriteString('LAB.MT'); 
 ELSE 
    InOut.WriteString(l^); 
 END; (* IF *)
END PrintT;

PROCEDURE PrintLONGINT*(i:LONGINT);
BEGIN (* PrintLONGINT *)
 InOut.WriteInt(i,0); 
END PrintLONGINT; 

PROCEDURE PrintLONGCARD*(c:LONGINT);
BEGIN (* PrintLONGCARD *)
 InOut.WriteCard(c,0); 
END PrintLONGCARD;

PROCEDURE PrinttLocation*(VAR loc:ASM.tLocation);
BEGIN (* PrinttLocation *)
 IF loc.ofs#0 THEN PrintLONGINT(loc.ofs); END; (* IF *)
 IF loc.label#LAB.MT THEN 
    IF loc.ofs#0 THEN InOut.Write('+'); END; (* IF *)
    PrintT(loc.label); 
 END; (* IF *)
 IF (loc.breg#ASM.NoReg) OR (loc.ireg#ASM.NoReg) THEN 
    InOut.Write('('); 
    IF loc.breg#ASM.NoReg THEN InOut.WriteString(ASM.RegStrTab[loc.breg]); END; (* IF *)
    InOut.Write(','); 
    IF loc.ireg#ASM.NoReg THEN InOut.WriteString(ASM.RegStrTab[loc.ireg]); END; (* IF *)
    IF loc.factor>1 THEN InOut.Write(','); PrintLONGINT(loc.factor); END; (* IF *)
    InOut.Write(')'); 
 END; (* IF *)
END PrinttLocation;
  
PROCEDURE PrinttSize*(s:ASM.tSize); 
BEGIN (* PrinttSize *)
 InOut.Write(ASM.SizeStrTab[s]); 
END PrinttSize;

PROCEDURE PrinttRelation*(r:ASM.tRelation); 
BEGIN (* PrinttRelation *)
 CASE r OF
 |ASM.equal         : InOut.WriteString("=");
 |ASM.unequal       : InOut.WriteString("#");
 |ASM.less          : InOut.WriteString("<");
 |ASM.lessORequal   : InOut.WriteString("<=");
 |ASM.greater       : InOut.WriteString(">");
 |ASM.greaterORequal: InOut.WriteString(">=");
 ELSE                 InOut.WriteString("<?>");
 END; (* CASE *)
END PrinttRelation;

PROCEDURE PrinttOper*(o:ASMOP.tOper); 
BEGIN (* PrinttOper *)
 InOut.WriteString(ASMOP.OperStrTab[o]); 
END PrinttOper;

PROCEDURE PrinttIdent*(id:Idents.tIdent); 
VAR s:Strings.tString; a:ARRAY Strings.cMaxStrLength+1 OF CHAR;
BEGIN (* PrinttIdent *)
 Idents.GetString(id,s); Strings.StringToArray(s,a); InOut.WriteString(a); 
END PrinttIdent;

PROCEDURE PrinttOperand*(VAR o:ASM.tOperand);
BEGIN (* PrinttOperand *)	      
 CASE o.kind OF
 |ASM.okMemory   : PrinttLocation(o.loc); 
 |ASM.okRegister : InOut.WriteString(ASM.RegStrTab[o.reg]); 
 |ASM.okImmediate: InOut.WriteInt(o.val,0); 
 ELSE              ERR.Fatal('BETO.PrinttOperand: CASE fault'); 
 END; (* CASE *)
END PrinttOperand;

PROCEDURE PrinttVariable*(VAR v:ASM.tVariable); 
BEGIN (* PrinttVariable *)
 IF v.label#LAB.MT THEN 
    PrintLONGINT(v.ofs); InOut.Write('+'); PrintT(v.label); 
 ELSIF v.frame=0 THEN 
    PrintLONGINT(v.ofs); InOut.WriteString('(%ebp)');
 ELSE 
    PrintLONGINT(v.ofs); InOut.Write('('); InOut.WriteString(ASM.RegStrTab[v.tmpreg]); 
    InOut.Write('='); PrintLONGINT(v.frame); InOut.WriteString('(%ebp))');
 END; (* IF *)
END PrinttVariable;

END BETO.

