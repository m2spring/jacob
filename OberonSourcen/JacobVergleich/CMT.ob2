MODULE CMT;








IMPORT SYSTEM, System, IO, Tree, OB,
(* line 15 "CMT.pum" *)
 ASMOP,ASM, Idents, LAB, OT, PR, STR, T, UTI;
CONST l=ASM.l; esp=ASM.esp; 
CONST add=ASMOP.add; pushl=ASMOP.pushl; call=ASMOP.call;

        CONST  BRACKETS    = TRUE           ;
               NOBRACKETS  = FALSE          ;
        TYPE   tIdent      = Idents.tIdent  ;
               tExportMode = OB.tExportMode ;
               tLabel      = LAB.T          ;
               tLevel      = OB.tLevel      ;
               tSize       = OB.tSize       ;

 CONST  EnterStage*  = 0              ;
               LeaveStage*  = -1             ; 

VAR yyf*	: IO.tFile;
VAR Exit*	: PROCEDURE;

        PROCEDURE NotNilCoerce(co : OB.tOB) : OB.tOB;
        BEGIN
         IF co = OB.NoOB THEN RETURN OB.cmtCoercion; ELSE RETURN co END; 
        END NotNilCoerce; 




































































































































PROCEDURE yyAbort (yyFunction: ARRAY OF CHAR);
 BEGIN
  IO.WriteS (IO.StdError, 'Error: module CMT, routine ');
  IO.WriteS (IO.StdError, yyFunction);
  IO.WriteS (IO.StdError, ' failed');
  IO.WriteNl (IO.StdError);
  Exit;
 END yyAbort;

PROCEDURE yyIsEqual (VAR yya, yyb: ARRAY OF SYSTEM.BYTE): BOOLEAN;
 VAR yyi:LONGINT; 
 BEGIN
  FOR yyi := 0 TO (LEN(yya)) DO
   IF SYSTEM.VAL(CHAR,yya [yyi]) # SYSTEM.VAL(CHAR,yyb [yyi]) THEN RETURN FALSE; END;
  END;
  RETURN TRUE;
 END yyIsEqual;

PROCEDURE IsEmpty (yyP1: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP1 = OB.NoOB THEN RETURN FALSE; END;
  IF yyP1 = NIL THEN
(* line 34 "CMT.pum" *)
      RETURN TRUE;

  END;

  CASE yyP1^.Kind OF
  | OB.mtObject:
(* line 35 "CMT.pum" *)
      RETURN TRUE;

  | OB.mtEntry:
(* line 36 "CMT.pum" *)
      RETURN TRUE;

  | OB.mtTypeReprList:
(* line 37 "CMT.pum" *)
      RETURN TRUE;

  | OB.mtTypeRepr:
(* line 38 "CMT.pum" *)
      RETURN TRUE;

  | OB.mtSignature:
(* line 39 "CMT.pum" *)
      RETURN TRUE;

  | OB.mtValue:
(* line 40 "CMT.pum" *)
      RETURN TRUE;

  | OB.mtLabelRange:
(* line 41 "CMT.pum" *)
      RETURN TRUE;

  ELSE END;

  RETURN FALSE;
 END IsEmpty;

PROCEDURE IsEmptyNode (yyP2: Tree.tTree): BOOLEAN;
 BEGIN
  IF yyP2 = Tree.NoTree THEN RETURN FALSE; END;

  CASE yyP2^.Kind OF
  | Tree.mtImport:
(* line 45 "CMT.pum" *)
      RETURN TRUE;

  | Tree.mtDeclUnit:
(* line 46 "CMT.pum" *)
      RETURN TRUE;

  | Tree.mtDecl:
(* line 47 "CMT.pum" *)
      RETURN TRUE;

  | Tree.mtProc:
(* line 48 "CMT.pum" *)
      RETURN TRUE;

  | Tree.mtFPSection:
(* line 49 "CMT.pum" *)
      RETURN TRUE;

  | Tree.mtParId:
(* line 50 "CMT.pum" *)
      RETURN TRUE;

  | Tree.mtType:
(* line 51 "CMT.pum" *)
      RETURN TRUE;

  | Tree.mtArrayExprList:
(* line 52 "CMT.pum" *)
      RETURN TRUE;

  | Tree.mtFieldList:
(* line 53 "CMT.pum" *)
      RETURN TRUE;

  | Tree.mtIdentList:
(* line 54 "CMT.pum" *)
      RETURN TRUE;

  | Tree.mtStmt:
(* line 55 "CMT.pum" *)
      RETURN TRUE;

  | Tree.NoStmts:
(* line 56 "CMT.pum" *)
      RETURN TRUE;

  | Tree.mtCase:
(* line 57 "CMT.pum" *)
      RETURN TRUE;

  | Tree.mtCaseLabel:
(* line 58 "CMT.pum" *)
      RETURN TRUE;

  | Tree.mtGuardedStmt:
(* line 59 "CMT.pum" *)
      RETURN TRUE;

  | Tree.mtExpr:
(* line 60 "CMT.pum" *)
      RETURN TRUE;

  | Tree.mtElement:
(* line 61 "CMT.pum" *)
      RETURN TRUE;

  | Tree.mtDesignor:
(* line 62 "CMT.pum" *)
      RETURN TRUE;

  | Tree.mtDesignation:
(* line 63 "CMT.pum" *)
      RETURN TRUE;

  | Tree.mtExprList:
(* line 64 "CMT.pum" *)
      RETURN TRUE;

  | Tree.mtNewExprList:
(* line 65 "CMT.pum" *)
      RETURN TRUE;

  | Tree.mtSysAsmExprList:
(* line 66 "CMT.pum" *)
      RETURN TRUE;

  ELSE END;

  RETURN FALSE;
 END IsEmptyNode;

PROCEDURE IsPredeclArgumenting (yyP3: Tree.tTree): BOOLEAN;
 BEGIN
  IF yyP3 = Tree.NoTree THEN RETURN FALSE; END;
  IF Tree.IsType (yyP3, Tree.PredeclArgumenting) THEN
(* line 70 "CMT.pum" *)
      RETURN TRUE;

  END;
  IF (yyP3^.Kind = Tree.Importing) THEN
  IF Tree.IsType (yyP3^.Importing.Nextion, Tree.PredeclArgumenting) THEN
(* line 71 "CMT.pum" *)
      RETURN TRUE;

  END;
  END;
  RETURN FALSE;
 END IsPredeclArgumenting;

PROCEDURE IsInt1Value (yyP4: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP4 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP4^.Kind = OB.IntegerValue) THEN
(* line 75 "CMT.pum" *)
(* line 75 "CMT.pum" *)
      RETURN (yyP4^.IntegerValue.v=1);
      RETURN TRUE;

  END;
(* line 76 "CMT.pum" *)
(* line 76 "CMT.pum" *)
      RETURN FALSE;

 END IsInt1Value;

PROCEDURE^Trace1 (label: tLabel; stage: LONGINT);

PROCEDURE Trace (yyP5: OB.tOB; stage: LONGINT);
 BEGIN
  IF yyP5 = OB.NoOB THEN RETURN; END;
  IF (yyP5^.Kind = OB.BoundProcEntry) THEN
(* line 81 "CMT.pum" *)
(* line 83 "CMT.pum" *)
      Trace1 (yyP5^.BoundProcEntry.label, stage);
      RETURN;

  END;
  IF (yyP5^.Kind = OB.ProcedureEntry) THEN
(* line 81 "CMT.pum" *)
(* line 83 "CMT.pum" *)
      Trace1 (yyP5^.ProcedureEntry.label, stage);
      RETURN;

  END;
 END Trace;

PROCEDURE Trace1 (label: tLabel; stage: LONGINT);
(* line 86 "CMT.pum" *)
 VAR lab:LAB.T; s:ARRAY 51 OF CHAR; 
 BEGIN
(* line 88 "CMT.pum" *)
(* line 88 "CMT.pum" *)
      
    ASM.Data;

    ASM.Label(LAB.New(lab)); 
    IF    stage=EnterStage THEN s:='Entering %s\n'; 
    ELSIF stage=LeaveStage THEN s:='Leaving  %s\n'; 
                           ELSE UTI.Longint2Arr(stage,s); STR.Conc3(s,'Stage ',s,' %s\n'); 
    END;
    ASM.Asciz(s); 

    ASM.Text;
    ASM.C1 ( pushl  ,  ASM.iL(LAB.AppS(label,'$N')) ); 
    ASM.C1 ( pushl  ,  ASM.iL(lab)                  ); 
    ASM.C1 ( call   ,  ASM.L(LAB.printf)            ); 
    ASM.CS2( add,l  ,  ASM.i(8),ASM.R(esp)              ); 
    ASM.Ln;
 ;
      RETURN;

 END Trace1;

PROCEDURE^CmtExpr (coerce: OB.tOB; expr: Tree.tTree; brackets: BOOLEAN);
PROCEDURE^CmtPredecl (yyP6: Tree.tTree);

PROCEDURE Cmt* (t: Tree.tTree);
(* line 108 "CMT.pum" *)
VAR n:LONGINT; arr:ARRAY 201 OF CHAR; 
 BEGIN
  IF t = Tree.NoTree THEN RETURN; END;

  CASE t^.Kind OF
  | Tree.UnqualifiedIdent:
(* line 110 "CMT.pum" *)
(* line 110 "CMT.pum" *)
      
    ASM.CmtId(t^.UnqualifiedIdent.Ident); 
 ;
      RETURN;

  | Tree.QualifiedIdent:
(* line 114 "CMT.pum" *)
(* line 114 "CMT.pum" *)
      
    ASM.CmtId(t^.QualifiedIdent.ServerId); ASM.CmtS('.'); ASM.CmtId(t^.QualifiedIdent.Ident); 
 ;
      RETURN;

  | Tree.AssignStmt:
(* line 118 "CMT.pum" *)
(* line 118 "CMT.pum" *)
      
    ASM.CmtLnS('	'); Cmt(t^.AssignStmt.Designator); ASM.CmtS(':='); CmtExpr(NotNilCoerce(t^.AssignStmt.Coerce),t^.AssignStmt.Exprs,NOBRACKETS); ASM.CmtS(';'); 
 ;
      RETURN;

  | Tree.CallStmt:
(* line 122 "CMT.pum" *)
(* line 122 "CMT.pum" *)
      
    ASM.CmtLnS('	'); Cmt(t^.CallStmt.Designator); ASM.CmtS(';'); 
 ;
      RETURN;

  | Tree.IfStmt:
(* line 126 "CMT.pum" *)
(* line 126 "CMT.pum" *)
      
    ASM.CmtLnS('	'); ASM.CmtS('IF '); Cmt(t^.IfStmt.Exprs); 
 ;
      RETURN;

  | Tree.CaseStmt:
(* line 130 "CMT.pum" *)
(* line 130 "CMT.pum" *)
      
    ASM.CmtLnS('	'); ASM.CmtS('CASE '); Cmt(t^.CaseStmt.Exprs); ASM.CmtS(' OF'); 
 ;
      RETURN;

  | Tree.Case:
(* line 134 "CMT.pum" *)
(* line 134 "CMT.pum" *)
      
    ASM.CmtLnS('	'); ASM.CmtS('|'); Cmt(t^.Case.CaseLabels); ASM.CmtS(':'); 
 ;
      RETURN;

  | Tree.CaseLabel:
(* line 137 "CMT.pum" *)
(* line 137 "CMT.pum" *)
      
    Cmt(t^.CaseLabel.ConstExpr1);
    IF ~IsEmptyNode(t^.CaseLabel.ConstExpr2^.ConstExpr.Expr) THEN ASM.CmtS('..'); Cmt(t^.CaseLabel.ConstExpr2); END;
    IF ~IsEmptyNode(t^.CaseLabel.Next) THEN ASM.CmtS(',' ); Cmt(t^.CaseLabel.Next);  END;
 ;
      RETURN;

  | Tree.WhileStmt:
(* line 143 "CMT.pum" *)
(* line 143 "CMT.pum" *)
      
    ASM.CmtLnS('	WHILE '); Cmt(t^.WhileStmt.Exprs); ASM.CmtS(' DO'); 
 ;
      RETURN;

  | Tree.RepeatStmt:
(* line 147 "CMT.pum" *)
(* line 147 "CMT.pum" *)
      
    ASM.CmtLnS('	REPEAT ... UNTIL '); Cmt(t^.RepeatStmt.Exprs); ASM.CmtS(';'); 
 ;
      RETURN;

  | Tree.ForStmt:
(* line 151 "CMT.pum" *)
(* line 151 "CMT.pum" *)
      
    ASM.CmtLnS('	FOR '); ASM.CmtId(t^.ForStmt.Ident); ASM.CmtS(':=');
    CmtExpr(NotNilCoerce(t^.ForStmt.FromCoerce),t^.ForStmt.From,NOBRACKETS);
    ASM.CmtS(' TO ');
    CmtExpr(NotNilCoerce(t^.ForStmt.ToCoerce),t^.ForStmt.To,NOBRACKETS);
    IF ~IsInt1Value(t^.ForStmt.By^.ConstExpr.Expr^.Exprs.ValueReprOut) THEN 
       ASM.CmtS(' BY ');
       CmtExpr(NotNilCoerce(OB.cmtCoercion),t^.ForStmt.By,NOBRACKETS);
    END;
    ASM.CmtS(' DO (tempofs='); 
    ASM.CmtI(t^.ForStmt.TempAddr); 
    ASM.CmtS(')'); 
 ;
      RETURN;

  | Tree.LoopStmt:
(* line 165 "CMT.pum" *)
(* line 165 "CMT.pum" *)
      
    ASM.CmtLnS('	LOOP'); 
 ;
      RETURN;

  | Tree.GuardedStmt:
(* line 169 "CMT.pum" *)
(* line 169 "CMT.pum" *)
      
    ASM.CmtLnS('	WITH '); Cmt(t^.GuardedStmt.Guard); ASM.CmtS(' DO'); 
 ;
      RETURN;

  | Tree.Guard:
(* line 172 "CMT.pum" *)
(* line 172 "CMT.pum" *)
      
    Cmt(t^.Guard.Variable); ASM.CmtS(':'); Cmt(t^.Guard.TypeId);
 ;
      RETURN;

  | Tree.ExitStmt:
(* line 176 "CMT.pum" *)
(* line 176 "CMT.pum" *)
      
    ASM.CmtLnS('	EXIT;'); 
 ;
      RETURN;

  | Tree.ReturnStmt:
(* line 180 "CMT.pum" *)
(* line 180 "CMT.pum" *)
      
    ASM.CmtLnS('	RETURN');
    IF ~IsEmptyNode(t^.ReturnStmt.Exprs) THEN 
       ASM.CmtS(' ');
       CmtExpr(NotNilCoerce(t^.ReturnStmt.Coerce),t^.ReturnStmt.Exprs,NOBRACKETS);
    END;
 ;
      RETURN;

  | Tree.ConstExpr:
(* line 188 "CMT.pum" *)
(* line 188 "CMT.pum" *)
      
    Cmt(t^.ConstExpr.Expr);
 ;
      RETURN;

  | Tree.NegateExpr:
(* line 192 "CMT.pum" *)
(* line 192 "CMT.pum" *)
      
    ASM.CmtS('-'); CmtExpr(OB.cmtCoercion,t^.NegateExpr.Exprs,BRACKETS);
 ;
      RETURN;

  | Tree.IdentityExpr:
(* line 196 "CMT.pum" *)
(* line 196 "CMT.pum" *)
      
    ASM.CmtS('+'); CmtExpr(OB.cmtCoercion,t^.IdentityExpr.Exprs,BRACKETS);
 ;
      RETURN;

  | Tree.NotExpr:
(* line 200 "CMT.pum" *)
(* line 200 "CMT.pum" *)
      
    ASM.CmtS('~'); CmtExpr(OB.cmtCoercion,t^.NotExpr.Exprs,BRACKETS);
 ;
      RETURN;

  | Tree.DyExpr:
(* line 204 "CMT.pum" *)
(* line 204 "CMT.pum" *)
      
    CmtExpr(NotNilCoerce(t^.DyExpr.DyOperator^.DyOperator.Coerce1),t^.DyExpr.Expr1,BRACKETS);
    Cmt(t^.DyExpr.DyOperator);
    CmtExpr(NotNilCoerce(t^.DyExpr.DyOperator^.DyOperator.Coerce2),t^.DyExpr.Expr2,BRACKETS);
 ;
      RETURN;

  | Tree.IsExpr:
(* line 210 "CMT.pum" *)
(* line 210 "CMT.pum" *)
      
    Cmt(t^.IsExpr.Designator);
    ASM.CmtS(' IS ');
    Cmt(t^.IsExpr.TypeId);
 ;
      RETURN;

  | Tree.SetExpr:
(* line 216 "CMT.pum" *)
(* line 216 "CMT.pum" *)
      
    ASM.CmtS('{'); Cmt(t^.SetExpr.Elements); ASM.CmtS('}');
 ;
      RETURN;

  | Tree.Element:
(* line 220 "CMT.pum" *)
(* line 220 "CMT.pum" *)
      
    Cmt(t^.Element.Expr1);
    IF ~IsEmptyNode(t^.Element.Expr2) THEN ASM.CmtS('..'); Cmt(t^.Element.Expr2); END;
    IF ~IsEmptyNode(t^.Element.Next)  THEN ASM.CmtS(',' ); Cmt(t^.Element.Next);  END;
 ;
      RETURN;

  | Tree.DesignExpr:
(* line 226 "CMT.pum" *)
(* line 226 "CMT.pum" *)
      
    Cmt(t^.DesignExpr.Designator);
 ;
      RETURN;

  | Tree.IntConst:
(* line 230 "CMT.pum" *)
(* line 230 "CMT.pum" *)
      
    ASM.CmtI(t^.IntConst.Int);
 ;
      RETURN;

  | Tree.SetConst:
(* line 234 "CMT.pum" *)
(* line 234 "CMT.pum" *)
      
    OT.oSET2ARR(t^.SetConst.Set,arr); ASM.CmtS(arr); 
 ;
      RETURN;

  | Tree.RealConst:
(* line 238 "CMT.pum" *)
(* line 238 "CMT.pum" *)
      
    OT.oREAL2ARR(t^.RealConst.Real,arr); ASM.CmtS(arr); 
 ;
      RETURN;

  | Tree.LongrealConst:
(* line 242 "CMT.pum" *)
(* line 242 "CMT.pum" *)
      
    OT.oLONGREAL2ARR(t^.LongrealConst.Longreal,arr); ASM.CmtS(arr); 
 ;
      RETURN;

  | Tree.CharConst:
(* line 246 "CMT.pum" *)
(* line 246 "CMT.pum" *)
      
    OT.oCHAR2ARR(t^.CharConst.Char,arr); ASM.CmtS(arr); 
 ;
      RETURN;

  | Tree.StringConst:
(* line 250 "CMT.pum" *)
(* line 250 "CMT.pum" *)
      
    OT.oSTRING2ARR(t^.StringConst.String,arr); ASM.CmtS(arr); 
 ;
      RETURN;

  | Tree.NilConst:
(* line 254 "CMT.pum" *)
(* line 254 "CMT.pum" *)
      
    ASM.CmtS('NIL');
 ;
      RETURN;

  | Tree.EqualOper:
(* line 258 "CMT.pum" *)
(* line 258 "CMT.pum" *)
       ASM.CmtS('='    );;
      RETURN;

  | Tree.UnequalOper:
(* line 259 "CMT.pum" *)
(* line 259 "CMT.pum" *)
       ASM.CmtS('#'    );;
      RETURN;

  | Tree.LessOper:
(* line 260 "CMT.pum" *)
(* line 260 "CMT.pum" *)
       ASM.CmtS('<'    );;
      RETURN;

  | Tree.LessEqualOper:
(* line 261 "CMT.pum" *)
(* line 261 "CMT.pum" *)
       ASM.CmtS('<='   );;
      RETURN;

  | Tree.GreaterOper:
(* line 262 "CMT.pum" *)
(* line 262 "CMT.pum" *)
       ASM.CmtS('>'    );;
      RETURN;

  | Tree.GreaterEqualOper:
(* line 263 "CMT.pum" *)
(* line 263 "CMT.pum" *)
       ASM.CmtS('>='   );;
      RETURN;

  | Tree.InOper:
(* line 264 "CMT.pum" *)
(* line 264 "CMT.pum" *)
       ASM.CmtS(' IN ' );;
      RETURN;

  | Tree.PlusOper:
(* line 265 "CMT.pum" *)
(* line 265 "CMT.pum" *)
       ASM.CmtS('+'    );;
      RETURN;

  | Tree.MinusOper:
(* line 266 "CMT.pum" *)
(* line 266 "CMT.pum" *)
       ASM.CmtS('-'    );;
      RETURN;

  | Tree.MultOper:
(* line 267 "CMT.pum" *)
(* line 267 "CMT.pum" *)
       ASM.CmtS('*'    );;
      RETURN;

  | Tree.RDivOper:
(* line 268 "CMT.pum" *)
(* line 268 "CMT.pum" *)
       ASM.CmtS('/'    );;
      RETURN;

  | Tree.DivOper:
(* line 269 "CMT.pum" *)
(* line 269 "CMT.pum" *)
       ASM.CmtS(' DIV ');;
      RETURN;

  | Tree.ModOper:
(* line 270 "CMT.pum" *)
(* line 270 "CMT.pum" *)
       ASM.CmtS(' MOD ');;
      RETURN;

  | Tree.OrOper:
(* line 271 "CMT.pum" *)
(* line 271 "CMT.pum" *)
       ASM.CmtS(' OR ' );;
      RETURN;

  | Tree.AndOper:
(* line 272 "CMT.pum" *)
(* line 272 "CMT.pum" *)
       ASM.CmtS(' & '  );;
      RETURN;

  | Tree.Designator:
(* line 274 "CMT.pum" *)
(* line 274 "CMT.pum" *)
      
    IF ~IsPredeclArgumenting(t^.Designator.Designations) THEN ASM.CmtId(t^.Designator.Ident); END;
    Cmt(t^.Designator.Designations);
 ;
      RETURN;

  | Tree.Importing:
(* line 279 "CMT.pum" *)
(* line 279 "CMT.pum" *)
      
    IF ~IsPredeclArgumenting(t^.Importing.Nextion) THEN ASM.CmtS('.'); ASM.CmtId(t^.Importing.Ident); END;
    Cmt(t^.Importing.Nextion);
 ;
      RETURN;

  | Tree.Selecting:
(* line 284 "CMT.pum" *)
(* line 284 "CMT.pum" *)
      
    ASM.CmtS('.'); ASM.CmtId(t^.Selecting.Ident); Cmt(t^.Selecting.Nextion);
 ;
      RETURN;

  | Tree.Indexing:
(* line 288 "CMT.pum" *)
(* line 288 "CMT.pum" *)
      
    ASM.CmtS('['); Cmt(t^.Indexing.Expr); ASM.CmtS(']'); Cmt(t^.Indexing.Nextion);
 ;
      RETURN;

  | Tree.Dereferencing:
(* line 292 "CMT.pum" *)
(* line 293 "CMT.pum" *)
      
    ASM.CmtS('^'); Cmt(t^.Dereferencing.Nextion);
 ;
      RETURN;

  | Tree.Supering:
(* line 292 "CMT.pum" *)
(* line 293 "CMT.pum" *)
      
    ASM.CmtS('^'); Cmt(t^.Supering.Nextion);
 ;
      RETURN;

  | Tree.Argumenting:
(* line 297 "CMT.pum" *)
(* line 298 "CMT.pum" *)
      
    ASM.CmtS('('); Cmt(t^.Argumenting.ExprList); ASM.CmtS(')'); Cmt(t^.Argumenting.Nextion); 
 ;
      RETURN;

  | Tree.Guarding:
(* line 297 "CMT.pum" *)
(* line 298 "CMT.pum" *)
      
    ASM.CmtS('('); Cmt(t^.Guarding.Qualidents); ASM.CmtS(')'); Cmt(t^.Guarding.Nextion); 
 ;
      RETURN;

  | Tree.PredeclArgumenting1
  , Tree.AbsArgumenting
  , Tree.CapArgumenting
  , Tree.ChrArgumenting
  , Tree.EntierArgumenting
  , Tree.LongArgumenting
  , Tree.OddArgumenting
  , Tree.OrdArgumenting
  , Tree.ShortArgumenting
  , Tree.HaltArgumenting
  , Tree.SysAdrArgumenting
  , Tree.SysCcArgumenting:
(* line 302 "CMT.pum" *)
(* line 302 "CMT.pum" *)
      
    CmtPredecl(t);
    ASM.CmtS('(');
    CmtExpr(OB.cmtCoercion,t^.PredeclArgumenting1.Expr,NOBRACKETS);
    ASM.CmtS(')');
    Cmt(t^.PredeclArgumenting1.Nextion);
 ;
      RETURN;

  | Tree.PredeclArgumenting2
  , Tree.AshArgumenting
  , Tree.CopyArgumenting
  , Tree.ExclInclArgumenting
  , Tree.ExclArgumenting
  , Tree.InclArgumenting
  , Tree.SysBitArgumenting
  , Tree.SysLshRotArgumenting
  , Tree.SysLshArgumenting
  , Tree.SysRotArgumenting
  , Tree.SysGetPutArgumenting
  , Tree.SysGetArgumenting
  , Tree.SysPutArgumenting
  , Tree.SysGetregPutregArgumenting
  , Tree.SysGetregArgumenting
  , Tree.SysPutregArgumenting
  , Tree.SysNewArgumenting:
(* line 309 "CMT.pum" *)
(* line 309 "CMT.pum" *)
      
    CmtPredecl(t);
    ASM.CmtS('(');
    CmtExpr(NotNilCoerce(t^.PredeclArgumenting2.Coerce1),t^.PredeclArgumenting2.Expr1,NOBRACKETS);
    ASM.CmtS(',');
    CmtExpr(NotNilCoerce(t^.PredeclArgumenting2.Coerce2),t^.PredeclArgumenting2.Expr2,NOBRACKETS);
    ASM.CmtS(')');
    Cmt(t^.PredeclArgumenting2.Nextion);
 ;
      RETURN;

  | Tree.PredeclArgumenting2Opt
  , Tree.LenArgumenting
  , Tree.AssertArgumenting
  , Tree.DecIncArgumenting
  , Tree.DecArgumenting
  , Tree.IncArgumenting:
(* line 318 "CMT.pum" *)
(* line 318 "CMT.pum" *)
      
    CmtPredecl(t);
    ASM.CmtS('(');
    CmtExpr(NotNilCoerce(t^.PredeclArgumenting2Opt.Coerce1),t^.PredeclArgumenting2Opt.Expr1,NOBRACKETS);
    IF ~IsEmptyNode(t^.PredeclArgumenting2Opt.Expr2) THEN 
       ASM.CmtS(','); CmtExpr(NotNilCoerce(t^.PredeclArgumenting2Opt.Coerce2),t^.PredeclArgumenting2Opt.Expr2,NOBRACKETS);
    END;
    ASM.CmtS(')');
    Cmt(t^.PredeclArgumenting2Opt.Nextion);
 ;
      RETURN;

  | Tree.PredeclArgumenting3
  , Tree.SysMoveArgumenting:
(* line 328 "CMT.pum" *)
(* line 328 "CMT.pum" *)
      
    CmtPredecl(t);
    ASM.CmtS('(');
    CmtExpr(OB.cmtCoercion,t^.PredeclArgumenting3.Expr1,NOBRACKETS);
    ASM.CmtS(',');
    CmtExpr(OB.cmtCoercion,t^.PredeclArgumenting3.Expr2,NOBRACKETS);
    ASM.CmtS(',');
    CmtExpr(NotNilCoerce(t^.PredeclArgumenting3.Coerce3),t^.PredeclArgumenting3.Expr3,NOBRACKETS);
    ASM.CmtS(')');
    Cmt(t^.PredeclArgumenting3.Nextion);
 ;
      RETURN;

  | Tree.SysValArgumenting:
(* line 339 "CMT.pum" *)
(* line 339 "CMT.pum" *)
      
    CmtPredecl(t);
    ASM.CmtS('(');
    Cmt(t^.SysValArgumenting.Qualidents);
    ASM.CmtS(',');
    CmtExpr(OB.cmtCoercion,t^.SysValArgumenting.Expr,NOBRACKETS);
    ASM.CmtS('; tempOfs=');
    ASM.CmtI(t^.SysValArgumenting.TempAddr); 
    ASM.CmtS(')');
    Cmt(t^.SysValArgumenting.Nextion);
 ;
      RETURN;

  | Tree.TypeArgumenting
  , Tree.MaxMinArgumenting
  , Tree.MaxArgumenting
  , Tree.MinArgumenting
  , Tree.SizeArgumenting:
(* line 350 "CMT.pum" *)
(* line 350 "CMT.pum" *)
      
    CmtPredecl(t); ASM.CmtS('('); Cmt(t^.TypeArgumenting.Qualidents); ASM.CmtS(')'); Cmt(t^.TypeArgumenting.Nextion);
 ;
      RETURN;

  | Tree.NewArgumenting:
(* line 353 "CMT.pum" *)
(* line 353 "CMT.pum" *)
      
    CmtPredecl(t); ASM.CmtS('('); Cmt(t^.NewArgumenting.Expr);
    IF ~IsEmptyNode(t^.NewArgumenting.NewExprLists) THEN ASM.CmtS(','); Cmt(t^.NewArgumenting.NewExprLists); END;
    ASM.CmtS(')');
    Cmt(t^.NewArgumenting.Nextion);
 ;
      RETURN;

  | Tree.SysAsmArgumenting:
(* line 359 "CMT.pum" *)
(* line 359 "CMT.pum" *)
      
    CmtPredecl(t); ASM.CmtS('('); Cmt(t^.SysAsmArgumenting.SysAsmExprLists); ASM.CmtS(')'); Cmt(t^.SysAsmArgumenting.Nextion);
 ;
      RETURN;

  | Tree.ExprList:
(* line 363 "CMT.pum" *)
(* line 363 "CMT.pum" *)
      
    CmtExpr(NotNilCoerce(t^.ExprList.Coerce),t^.ExprList.Expr,NOBRACKETS);
    IF ~IsEmptyNode(t^.ExprList.Next) THEN ASM.CmtS(','); Cmt(t^.ExprList.Next); END;
 ;
      RETURN;

  | Tree.NewExprList:
(* line 368 "CMT.pum" *)
(* line 368 "CMT.pum" *)
      
    CmtExpr(NotNilCoerce(t^.NewExprList.Coerce),t^.NewExprList.Expr,NOBRACKETS);
    IF ~IsEmptyNode(t^.NewExprList.Next) THEN ASM.CmtS(','); Cmt(t^.NewExprList.Next); END;
 ;
      RETURN;

  | Tree.SysAsmExprList:
(* line 373 "CMT.pum" *)
(* line 373 "CMT.pum" *)
      
    Cmt(t^.SysAsmExprList.Expr); 
    IF ~IsEmptyNode(t^.SysAsmExprList.Next) THEN ASM.CmtS(','); Cmt(t^.SysAsmExprList.Next); END;
 ;
      RETURN;

  ELSE END;

 END Cmt;

PROCEDURE CmtExpr (coerce: OB.tOB; expr: Tree.tTree; brackets: BOOLEAN);
(* line 380 "CMT.pum" *)
 VAR arr:ARRAY 101 OF CHAR; 
 BEGIN
  IF coerce = OB.NoOB THEN RETURN; END;
  IF expr = Tree.NoTree THEN RETURN; END;

  CASE coerce^.Kind OF
  | OB.Shortint2Integer:
  IF (expr^.Kind = Tree.IntConst) THEN
(* line 382 "CMT.pum" *)
(* line 390 "CMT.pum" *)
       ASM.CmtI(expr^.IntConst.Int); ;
      RETURN;

  END;
(* line 394 "CMT.pum" *)
(* line 394 "CMT.pum" *)
       ASM.CmtS('$SI_IN('); Cmt(expr); ASM.CmtS(')'); ;
      RETURN;

  | OB.Shortint2Longint:
  IF (expr^.Kind = Tree.IntConst) THEN
(* line 382 "CMT.pum" *)
(* line 390 "CMT.pum" *)
       ASM.CmtI(expr^.IntConst.Int); ;
      RETURN;

  END;
(* line 395 "CMT.pum" *)
(* line 395 "CMT.pum" *)
       ASM.CmtS('$SI_LI('); Cmt(expr); ASM.CmtS(')'); ;
      RETURN;

  | OB.Shortint2Real:
  IF (expr^.Kind = Tree.IntConst) THEN
(* line 382 "CMT.pum" *)
(* line 390 "CMT.pum" *)
       ASM.CmtI(expr^.IntConst.Int); ;
      RETURN;

  END;
(* line 396 "CMT.pum" *)
(* line 396 "CMT.pum" *)
       ASM.CmtS('$SI_RE('); Cmt(expr); ASM.CmtS(')'); ;
      RETURN;

  | OB.Shortint2Longreal:
  IF (expr^.Kind = Tree.IntConst) THEN
(* line 382 "CMT.pum" *)
(* line 390 "CMT.pum" *)
       ASM.CmtI(expr^.IntConst.Int); ;
      RETURN;

  END;
(* line 397 "CMT.pum" *)
(* line 397 "CMT.pum" *)
       ASM.CmtS('$SI_LR('); Cmt(expr); ASM.CmtS(')'); ;
      RETURN;

  | OB.Integer2Longint:
  IF (expr^.Kind = Tree.IntConst) THEN
(* line 382 "CMT.pum" *)
(* line 390 "CMT.pum" *)
       ASM.CmtI(expr^.IntConst.Int); ;
      RETURN;

  END;
(* line 398 "CMT.pum" *)
(* line 398 "CMT.pum" *)
       ASM.CmtS('$IN_LI('); Cmt(expr); ASM.CmtS(')'); ;
      RETURN;

  | OB.Integer2Real:
  IF (expr^.Kind = Tree.IntConst) THEN
(* line 382 "CMT.pum" *)
(* line 390 "CMT.pum" *)
       ASM.CmtI(expr^.IntConst.Int); ;
      RETURN;

  END;
(* line 399 "CMT.pum" *)
(* line 399 "CMT.pum" *)
       ASM.CmtS('$IN_RE('); Cmt(expr); ASM.CmtS(')'); ;
      RETURN;

  | OB.Integer2Longreal:
  IF (expr^.Kind = Tree.IntConst) THEN
(* line 382 "CMT.pum" *)
(* line 390 "CMT.pum" *)
       ASM.CmtI(expr^.IntConst.Int); ;
      RETURN;

  END;
(* line 400 "CMT.pum" *)
(* line 400 "CMT.pum" *)
       ASM.CmtS('$IN_LR('); Cmt(expr); ASM.CmtS(')'); ;
      RETURN;

  | OB.Longint2Real:
  IF (expr^.Kind = Tree.IntConst) THEN
(* line 382 "CMT.pum" *)
(* line 390 "CMT.pum" *)
       ASM.CmtI(expr^.IntConst.Int); ;
      RETURN;

  END;
(* line 401 "CMT.pum" *)
(* line 401 "CMT.pum" *)
       ASM.CmtS('$LI_RE('); Cmt(expr); ASM.CmtS(')'); ;
      RETURN;

  | OB.Longint2Longreal:
  IF (expr^.Kind = Tree.IntConst) THEN
(* line 382 "CMT.pum" *)
(* line 390 "CMT.pum" *)
       ASM.CmtI(expr^.IntConst.Int); ;
      RETURN;

  END;
(* line 402 "CMT.pum" *)
(* line 402 "CMT.pum" *)
       ASM.CmtS('$LI_LR('); Cmt(expr); ASM.CmtS(')'); ;
      RETURN;

  | OB.Real2Longreal:
  IF (expr^.Kind = Tree.LongrealConst) THEN
(* line 392 "CMT.pum" *)
(* line 392 "CMT.pum" *)
       OT.oLONGREAL2ARR(expr^.LongrealConst.Longreal,arr); ASM.CmtS(arr); ;
      RETURN;

  END;
(* line 403 "CMT.pum" *)
(* line 403 "CMT.pum" *)
       ASM.CmtS('$RE_LR('); Cmt(expr); ASM.CmtS(')'); ;
      RETURN;

  | OB.Char2String:
(* line 404 "CMT.pum" *)
(* line 404 "CMT.pum" *)
       ASM.CmtS('$CH_ST('); Cmt(expr); ASM.CmtS(')'); ;
      RETURN;

  ELSE END;


  CASE expr^.Kind OF
  | Tree.SetExpr:
(* line 406 "CMT.pum" *)
(* line 406 "CMT.pum" *)
       Cmt(expr); ;
      RETURN;

  | Tree.DesignExpr:
(* line 407 "CMT.pum" *)
(* line 407 "CMT.pum" *)
       Cmt(expr); ;
      RETURN;

  | Tree.IntConst:
(* line 408 "CMT.pum" *)
(* line 408 "CMT.pum" *)
       Cmt(expr); ;
      RETURN;

  | Tree.RealConst:
(* line 409 "CMT.pum" *)
(* line 409 "CMT.pum" *)
       Cmt(expr); ;
      RETURN;

  | Tree.LongrealConst:
(* line 410 "CMT.pum" *)
(* line 410 "CMT.pum" *)
       Cmt(expr); ;
      RETURN;

  | Tree.CharConst:
(* line 411 "CMT.pum" *)
(* line 411 "CMT.pum" *)
       Cmt(expr); ;
      RETURN;

  | Tree.StringConst:
(* line 412 "CMT.pum" *)
(* line 412 "CMT.pum" *)
       Cmt(expr); ;
      RETURN;

  | Tree.NilConst:
(* line 413 "CMT.pum" *)
(* line 413 "CMT.pum" *)
       Cmt(expr); ;
      RETURN;

  ELSE END;

(* line 414 "CMT.pum" *)
(* line 414 "CMT.pum" *)
      
    IF brackets THEN ASM.CmtS('('); END;
    Cmt(expr);
    IF brackets THEN ASM.CmtS(')'); END;
 ;
      RETURN;

 END CmtExpr;

PROCEDURE CmtPredecl (yyP6: Tree.tTree);
 BEGIN
  IF yyP6 = Tree.NoTree THEN RETURN; END;

  CASE yyP6^.Kind OF
  | Tree.AbsArgumenting:
(* line 422 "CMT.pum" *)
(* line 422 "CMT.pum" *)
       ASM.CmtS('ABS'          ); ;
      RETURN;

  | Tree.AshArgumenting:
(* line 423 "CMT.pum" *)
(* line 423 "CMT.pum" *)
       ASM.CmtS('ASH'          ); ;
      RETURN;

  | Tree.CapArgumenting:
(* line 424 "CMT.pum" *)
(* line 424 "CMT.pum" *)
       ASM.CmtS('CAP'          ); ;
      RETURN;

  | Tree.ChrArgumenting:
(* line 425 "CMT.pum" *)
(* line 425 "CMT.pum" *)
       ASM.CmtS('CHR'          ); ;
      RETURN;

  | Tree.EntierArgumenting:
(* line 426 "CMT.pum" *)
(* line 426 "CMT.pum" *)
       ASM.CmtS('ENTIER'       ); ;
      RETURN;

  | Tree.LenArgumenting:
(* line 427 "CMT.pum" *)
(* line 427 "CMT.pum" *)
       ASM.CmtS('LEN'          ); ;
      RETURN;

  | Tree.LongArgumenting:
(* line 428 "CMT.pum" *)
(* line 428 "CMT.pum" *)
       ASM.CmtS('LONG'         ); ;
      RETURN;

  | Tree.MaxArgumenting:
(* line 429 "CMT.pum" *)
(* line 429 "CMT.pum" *)
       ASM.CmtS('MAX'          ); ;
      RETURN;

  | Tree.MinArgumenting:
(* line 430 "CMT.pum" *)
(* line 430 "CMT.pum" *)
       ASM.CmtS('MIN'          ); ;
      RETURN;

  | Tree.OddArgumenting:
(* line 431 "CMT.pum" *)
(* line 431 "CMT.pum" *)
       ASM.CmtS('ODD'          ); ;
      RETURN;

  | Tree.OrdArgumenting:
(* line 432 "CMT.pum" *)
(* line 432 "CMT.pum" *)
       ASM.CmtS('ORD'          ); ;
      RETURN;

  | Tree.ShortArgumenting:
(* line 433 "CMT.pum" *)
(* line 433 "CMT.pum" *)
       ASM.CmtS('SHORT'        ); ;
      RETURN;

  | Tree.SizeArgumenting:
(* line 434 "CMT.pum" *)
(* line 434 "CMT.pum" *)
       ASM.CmtS('SIZE'         ); ;
      RETURN;

  | Tree.AssertArgumenting:
(* line 436 "CMT.pum" *)
(* line 436 "CMT.pum" *)
       ASM.CmtS('ASSERT'       ); ;
      RETURN;

  | Tree.CopyArgumenting:
(* line 437 "CMT.pum" *)
(* line 437 "CMT.pum" *)
       ASM.CmtS('COPY'         ); ;
      RETURN;

  | Tree.DecArgumenting:
(* line 438 "CMT.pum" *)
(* line 438 "CMT.pum" *)
       ASM.CmtS('DEC'          ); ;
      RETURN;

  | Tree.ExclArgumenting:
(* line 439 "CMT.pum" *)
(* line 439 "CMT.pum" *)
       ASM.CmtS('EXCL'         ); ;
      RETURN;

  | Tree.HaltArgumenting:
(* line 440 "CMT.pum" *)
(* line 440 "CMT.pum" *)
       ASM.CmtS('HALT'         ); ;
      RETURN;

  | Tree.IncArgumenting:
(* line 441 "CMT.pum" *)
(* line 441 "CMT.pum" *)
       ASM.CmtS('INC'          ); ;
      RETURN;

  | Tree.InclArgumenting:
(* line 442 "CMT.pum" *)
(* line 442 "CMT.pum" *)
       ASM.CmtS('INCL'         ); ;
      RETURN;

  | Tree.NewArgumenting:
(* line 443 "CMT.pum" *)
(* line 443 "CMT.pum" *)
       ASM.CmtS('NEW'          ); ;
      RETURN;

  | Tree.SysAdrArgumenting:
(* line 445 "CMT.pum" *)
(* line 445 "CMT.pum" *)
       ASM.CmtS('SYSTEM.ADR'   ); ;
      RETURN;

  | Tree.SysBitArgumenting:
(* line 446 "CMT.pum" *)
(* line 446 "CMT.pum" *)
       ASM.CmtS('SYSTEM.BIT'   ); ;
      RETURN;

  | Tree.SysCcArgumenting:
(* line 447 "CMT.pum" *)
(* line 447 "CMT.pum" *)
       ASM.CmtS('SYSTEM.CC'    ); ;
      RETURN;

  | Tree.SysLshArgumenting:
(* line 448 "CMT.pum" *)
(* line 448 "CMT.pum" *)
       ASM.CmtS('SYSTEM.LSH'   ); ;
      RETURN;

  | Tree.SysRotArgumenting:
(* line 449 "CMT.pum" *)
(* line 449 "CMT.pum" *)
       ASM.CmtS('SYSTEM.ROT'   ); ;
      RETURN;

  | Tree.SysValArgumenting:
(* line 450 "CMT.pum" *)
(* line 450 "CMT.pum" *)
       ASM.CmtS('SYSTEM.VAL'   ); ;
      RETURN;

  | Tree.SysGetArgumenting:
(* line 452 "CMT.pum" *)
(* line 452 "CMT.pum" *)
       ASM.CmtS('SYSTEM.GET'   ); ;
      RETURN;

  | Tree.SysPutArgumenting:
(* line 453 "CMT.pum" *)
(* line 453 "CMT.pum" *)
       ASM.CmtS('SYSTEM.PUT'   ); ;
      RETURN;

  | Tree.SysGetregArgumenting:
(* line 454 "CMT.pum" *)
(* line 454 "CMT.pum" *)
       ASM.CmtS('SYSTEM.GETREG'); ;
      RETURN;

  | Tree.SysPutregArgumenting:
(* line 455 "CMT.pum" *)
(* line 455 "CMT.pum" *)
       ASM.CmtS('SYSTEM.PUTREG'); ;
      RETURN;

  | Tree.SysMoveArgumenting:
(* line 456 "CMT.pum" *)
(* line 456 "CMT.pum" *)
       ASM.CmtS('SYSTEM.MOVE'  ); ;
      RETURN;

  | Tree.SysNewArgumenting:
(* line 457 "CMT.pum" *)
(* line 457 "CMT.pum" *)
       ASM.CmtS('SYSTEM.NEW'   ); ;
      RETURN;

  | Tree.SysAsmArgumenting:
(* line 458 "CMT.pum" *)
(* line 458 "CMT.pum" *)
       ASM.CmtS('SYSTEM.ASM'   ); ;
      RETURN;

  ELSE END;

(* line 460 "CMT.pum" *)
(* line 460 "CMT.pum" *)
       ASM.CmtS('$PREDECL?'    ); ;
      RETURN;

 END CmtPredecl;

PROCEDURE^Procedure1 (id: tIdent; em: tExportMode; lv: tLevel; rsig: OB.tOB; sig: OB.tOB; rtype: OB.tOB; lspace: tSize; tspace: tSize; locals: OB.tOB; env: OB.tOB);

PROCEDURE Procedure* (yyP8: OB.tOB; yyP7: Tree.tTree);
 BEGIN
  IF yyP8 = OB.NoOB THEN RETURN; END;
  IF yyP7 = Tree.NoTree THEN RETURN; END;
  IF (yyP8^.Kind = OB.ProcedureEntry) THEN
  IF OB.IsType (yyP8^.ProcedureEntry.typeRepr, OB.ProcedureTypeRepr) THEN
  IF (yyP7^.Kind = Tree.ProcDecl) THEN
(* line 465 "CMT.pum" *)
(* line 469 "CMT.pum" *)
      
    Procedure1(yyP8^.ProcedureEntry.ident,yyP8^.ProcedureEntry.exportMode,yyP8^.ProcedureEntry.level,OB.cmtSignature,yyP8^.ProcedureEntry.typeRepr^.ProcedureTypeRepr.signatureRepr,yyP8^.ProcedureEntry.typeRepr^.ProcedureTypeRepr.resultType,yyP7^.ProcDecl.LocalSpace,yyP7^.ProcDecl.TempSpace,yyP7^.ProcDecl.Locals,yyP8^.ProcedureEntry.env);
 ;
      RETURN;

  END;
  END;
  END;
  IF (yyP8^.Kind = OB.BoundProcEntry) THEN
  IF OB.IsType (yyP8^.BoundProcEntry.typeRepr, OB.ProcedureTypeRepr) THEN
  IF (yyP7^.Kind = Tree.BoundProcDecl) THEN
(* line 473 "CMT.pum" *)
(* line 477 "CMT.pum" *)
      
    Procedure1(yyP8^.BoundProcEntry.ident,yyP8^.BoundProcEntry.exportMode,0,yyP8^.BoundProcEntry.receiverSig,yyP8^.BoundProcEntry.typeRepr^.ProcedureTypeRepr.signatureRepr,yyP8^.BoundProcEntry.typeRepr^.ProcedureTypeRepr.resultType,yyP7^.BoundProcDecl.LocalSpace,yyP7^.BoundProcDecl.TempSpace,yyP7^.BoundProcDecl.Locals,yyP8^.BoundProcEntry.env);
 ;
      RETURN;

  END;
  END;
  END;
 END Procedure;

PROCEDURE^Type (yyP13: OB.tOB);
PROCEDURE^Parameters (yyP10: OB.tOB);
PROCEDURE^Locals* (yyP11: OB.tOB);
PROCEDURE^Signature (yyP12: OB.tOB);
PROCEDURE^ExportMode (em: tExportMode);
PROCEDURE^DstLevel (yyP9: OB.tOB);

PROCEDURE Procedure1 (id: tIdent; em: tExportMode; lv: tLevel; rsig: OB.tOB; sig: OB.tOB; rtype: OB.tOB; lspace: tSize; tspace: tSize; locals: OB.tOB; env: OB.tOB);
 BEGIN
  IF rsig = OB.NoOB THEN RETURN; END;
  IF sig = OB.NoOB THEN RETURN; END;
  IF rtype = OB.NoOB THEN RETURN; END;
  IF locals = OB.NoOB THEN RETURN; END;
  IF env = OB.NoOB THEN RETURN; END;
(* line 492 "CMT.pum" *)
(* line 492 "CMT.pum" *)
      
    ASM.SepLine;

    Parameters(sig);
    IF ~IsEmpty(rsig) THEN Parameters(rsig); END;

    ASM.WrS('# PROCEDURE '); 

    IF ~IsEmpty(rsig) THEN ASM.WrS('('); Signature(rsig); ASM.WrS(')'); END;

    ASM.WrId(id); ExportMode(em);
    ASM.WrS('(');
    Signature(sig);
    IF IsEmpty(rtype) THEN ASM.WrS(')'); ELSE ASM.WrS('):'); Type(rtype); END;
    ASM.WrLn; 
    
    ASM.WrS("# LEVEL  = "); ASM.WrI(lv); DstLevel(env); ASM.WrLn; 
    ASM.WrS("# LSPACE = "); ASM.WrI(lspace); ASM.WrLn; 
    ASM.WrS("# TSPACE = "); ASM.WrI(tspace); ASM.WrLn; 
    
    Locals(locals);
    ASM.WrLn;
 ;
      RETURN;

 END Procedure1;

PROCEDURE DstLevel (yyP9: OB.tOB);
(* line 518 "CMT.pum" *)
 VAR i:INTEGER; f:BOOLEAN; 
 BEGIN
  IF yyP9 = OB.NoOB THEN RETURN; END;
(* line 520 "CMT.pum" *)
(* line 520 "CMT.pum" *)
      
    ASM.WrS(" --> {"); 
    f:=FALSE; 
    FOR i:=0 TO 31 DO
     IF i IN yyP9^.Environment.callDstLevels THEN 
        IF f THEN ASM.WrS(','); ELSE f:=TRUE; END;
        ASM.WrI(i); 
     END;
    END;
    ASM.WrS("}"); 
 ;
      RETURN;

 END DstLevel;

PROCEDURE Parameters (yyP10: OB.tOB);
(* line 534 "CMT.pum" *)
 VAR s:ARRAY 31 OF CHAR; 
 BEGIN
  IF yyP10 = OB.NoOB THEN RETURN; END;
  IF (yyP10^.Kind = OB.Signature) THEN
(* line 536 "CMT.pum" *)
(* line 536 "CMT.pum" *)
      
    Parameters(yyP10^.Signature.next);

    ASM.WrS('# '); 
    UTI.Longint2Arr(yyP10^.Signature.VarEntry^.VarEntry.address,s); STR.DoRb(s,6); ASM.WrS(s); 

    IF yyP10^.Signature.VarEntry^.VarEntry.refMode=OB.REFPAR THEN 
       ASM.WrS(' addr '); 
    ELSE 
       ASM.WrS('      '); 
    END;
    ASM.WrId(yyP10^.Signature.VarEntry^.VarEntry.ident); 

    IF    yyP10^.Signature.VarEntry^.VarEntry.parMode=OB.REFPAR THEN ASM.WrS(' (VAR '); 
    ELSIF yyP10^.Signature.VarEntry^.VarEntry.refMode=OB.REFPAR THEN ASM.WrS(' ('); 
                            ELSE ASM.WrS(' ('); 
    END;
    Type(yyP10^.Signature.VarEntry^.VarEntry.typeRepr); ASM.WrS(')'); 

    IF yyP10^.Signature.VarEntry^.VarEntry.isLaccessed THEN ASM.WrS(' L-accessed'); END; (* IF *)
    ASM.WrLn;
    
    IF (yyP10^.Signature.VarEntry^.VarEntry.parMode=OB.REFPAR) & T.IsRecordType(yyP10^.Signature.VarEntry^.VarEntry.typeRepr) THEN 
       ASM.WrS('# '); 
       UTI.Longint2Arr(yyP10^.Signature.VarEntry^.VarEntry.address-4,s); STR.DoRb(s,6); ASM.WrS(s); 
       ASM.WrS(' tag  '); ASM.WrId(yyP10^.Signature.VarEntry^.VarEntry.ident); 
       ASM.WrLn;
    END;
 ;
      RETURN;

  END;
 END Parameters;

PROCEDURE Locals* (yyP11: OB.tOB);
(* line 568 "CMT.pum" *)
 VAR s:ARRAY 31 OF CHAR; 
 BEGIN
  IF yyP11 = OB.NoOB THEN RETURN; END;
  IF (yyP11^.Kind = OB.VarEntry) THEN
(* line 570 "CMT.pum" *)
(* line 570 "CMT.pum" *)
      
    Locals(yyP11^.VarEntry.prevEntry);

    IF ~yyP11^.VarEntry.isParam & ~yyP11^.VarEntry.isReceiverPar THEN 
       ASM.WrS('# '); 
       UTI.Longint2Arr(yyP11^.VarEntry.address,s); STR.DoRb(s,6); 
       ASM.WrS(s); ASM.WrS(' '); ASM.WrId(yyP11^.VarEntry.ident); ASM.WrS(': '); Type(yyP11^.VarEntry.typeRepr); 
       IF yyP11^.VarEntry.isLaccessed THEN ASM.WrS(' L-accessed'); END; (* IF *)
       ASM.WrLn;
    END;
 ;
      RETURN;

  END;
  IF OB.IsType (yyP11, OB.DataEntry) THEN
(* line 582 "CMT.pum" *)
(* line 582 "CMT.pum" *)
      
    Locals(yyP11^.DataEntry.prevEntry);
 ;
      RETURN;

  END;
 END Locals;

PROCEDURE Signature (yyP12: OB.tOB);
 BEGIN
  IF yyP12 = OB.NoOB THEN RETURN; END;
  IF (yyP12^.Kind = OB.Signature) THEN
(* line 589 "CMT.pum" *)
(* line 589 "CMT.pum" *)
      
    IF yyP12^.Signature.VarEntry^.VarEntry.parMode=OB.REFPAR THEN ASM.WrS('VAR '); END;

    ASM.WrId(yyP12^.Signature.VarEntry^.VarEntry.ident); ASM.WrS(':');
    Type(yyP12^.Signature.VarEntry^.VarEntry.typeRepr);

    IF ~IsEmpty(yyP12^.Signature.next) THEN ASM.WrS('; '); Signature(yyP12^.Signature.next); END;
 ;
      RETURN;

  END;
 END Signature;

PROCEDURE Type (yyP13: OB.tOB);
 BEGIN
  IF yyP13 = OB.NoOB THEN RETURN; END;
  IF (yyP13^.Kind = OB.mtTypeRepr) THEN
(* line 601 "CMT.pum" *)
(* line 601 "CMT.pum" *)
       ASM.WrS('<EmptyType>'); ;
      RETURN;

  END;
  IF (yyP13^.Kind = OB.ErrorTypeRepr) THEN
(* line 602 "CMT.pum" *)
(* line 602 "CMT.pum" *)
       ASM.WrS('<ErrorType>'); ;
      RETURN;

  END;
  IF OB.IsType (yyP13, OB.TypeRepr) THEN
  IF (yyP13^.TypeRepr.entry^.Kind = OB.TypeEntry) THEN
(* line 604 "CMT.pum" *)
(* line 604 "CMT.pum" *)
      
    IF (yyP13^.TypeRepr.entry^.TypeEntry.module^.ModuleEntry.name#Idents.NoIdent) & (yyP13^.TypeRepr.entry^.TypeEntry.module^.ModuleEntry.name#PR.IdentPREDECL) THEN 
       ASM.WrId(yyP13^.TypeRepr.entry^.TypeEntry.module^.ModuleEntry.name); ASM.WrS('.');
    END;
    ASM.WrId(yyP13^.TypeRepr.entry^.TypeEntry.ident);
 ;
      RETURN;

  END;
  END;

  CASE yyP13^.Kind OF
  | OB.ForwardTypeRepr:
(* line 611 "CMT.pum" *)
(* line 611 "CMT.pum" *)
       ASM.WrS('<Forward>'); ;
      RETURN;

  | OB.CharStringTypeRepr:
(* line 612 "CMT.pum" *)
(* line 612 "CMT.pum" *)
       ASM.WrS('<Char>');    ;
      RETURN;

  | OB.StringTypeRepr:
(* line 613 "CMT.pum" *)
(* line 613 "CMT.pum" *)
       ASM.WrS('<String>');  ;
      RETURN;

  | OB.ArrayTypeRepr:
(* line 615 "CMT.pum" *)
(* line 615 "CMT.pum" *)
      
    ASM.WrS('ARRAY ');
    IF yyP13^.ArrayTypeRepr.len>0 THEN ASM.WrI(yyP13^.ArrayTypeRepr.len); ASM.WrS(' '); END;
    ASM.WrS('OF '); Type(yyP13^.ArrayTypeRepr.elemTypeRepr);
 ;
      RETURN;

  | OB.RecordTypeRepr:
(* line 621 "CMT.pum" *)
(* line 621 "CMT.pum" *)
      
    ASM.WrS('RECORD...');
 ;
      RETURN;

  | OB.PointerTypeRepr:
  IF (yyP13^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
(* line 625 "CMT.pum" *)
(* line 625 "CMT.pum" *)
      
    ASM.WrS('POINTER TO '); Type(yyP13^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr);
 ;
      RETURN;

  END;
(* line 629 "CMT.pum" *)
(* line 629 "CMT.pum" *)
       ASM.WrS('POINTER TO ?'); ;
      RETURN;

  | OB.ProcedureTypeRepr
  , OB.PreDeclProcTypeRepr
  , OB.CaseFaultTypeRepr
  , OB.WithFaultTypeRepr
  , OB.AbsTypeRepr
  , OB.AshTypeRepr
  , OB.CapTypeRepr
  , OB.ChrTypeRepr
  , OB.EntierTypeRepr
  , OB.LenTypeRepr
  , OB.LongTypeRepr
  , OB.MaxTypeRepr
  , OB.MinTypeRepr
  , OB.OddTypeRepr
  , OB.OrdTypeRepr
  , OB.ShortTypeRepr
  , OB.SizeTypeRepr
  , OB.AssertTypeRepr
  , OB.CopyTypeRepr
  , OB.DecTypeRepr
  , OB.ExclTypeRepr
  , OB.HaltTypeRepr
  , OB.IncTypeRepr
  , OB.InclTypeRepr
  , OB.NewTypeRepr
  , OB.SysAdrTypeRepr
  , OB.SysBitTypeRepr
  , OB.SysCcTypeRepr
  , OB.SysLshTypeRepr
  , OB.SysRotTypeRepr
  , OB.SysValTypeRepr
  , OB.SysGetTypeRepr
  , OB.SysPutTypeRepr
  , OB.SysGetregTypeRepr
  , OB.SysPutregTypeRepr
  , OB.SysMoveTypeRepr
  , OB.SysNewTypeRepr
  , OB.SysAsmTypeRepr:
(* line 631 "CMT.pum" *)
(* line 631 "CMT.pum" *)
      
    ASM.WrS('PROCEDURE('); Signature(yyP13^.ProcedureTypeRepr.signatureRepr); ASM.WrS(')');
    IF ~IsEmpty(yyP13^.ProcedureTypeRepr.resultType) THEN ASM.WrS(':'); Type(yyP13^.ProcedureTypeRepr.resultType); END;
 ;
      RETURN;

  ELSE END;

(* line 636 "CMT.pum" *)
(* line 636 "CMT.pum" *)
       ASM.WrS('?TypeRepr'); ;
      RETURN;

 END Type;

PROCEDURE ExportMode (em: tExportMode);
 BEGIN
  IF (yyIsEqual ( em ,   OB.PUBLIC   ) ) THEN
(* line 641 "CMT.pum" *)
(* line 641 "CMT.pum" *)
       ASM.WrS('*'); ;
      RETURN;

  END;
  IF (yyIsEqual ( em ,   OB.READONLY ) ) THEN
(* line 642 "CMT.pum" *)
(* line 642 "CMT.pum" *)
       ASM.WrS('-'); ;
      RETURN;

  END;
 END ExportMode;

PROCEDURE^CmtBl (bl: OB.tOB);

PROCEDURE CmtBlocklist* (bl: OB.tOB);
 BEGIN
  IF bl = OB.NoOB THEN RETURN; END;
  IF (bl^.Kind = OB.Blocklist) THEN
(* line 647 "CMT.pum" *)
(* line 647 "CMT.pum" *)
      
    CmtBlocklist(bl^.Blocklist.prev); 
    ASM.WrS('# '); 
    CmtBl(bl); 
    ASM.WrLn;
 ;
      RETURN;

  END;
 END CmtBlocklist;

PROCEDURE CmtBl (bl: OB.tOB);
 BEGIN
  IF bl = OB.NoOB THEN RETURN; END;
  IF (bl^.Kind = OB.Blocklist) THEN
(* line 656 "CMT.pum" *)
(* line 656 "CMT.pum" *)
      
    ASM.WrS('('); ASM.WrI(bl^.Blocklist.ofs); 
    ASM.WrS(','); ASM.WrI(bl^.Blocklist.count); 
    ASM.WrS(','); ASM.WrI(bl^.Blocklist.incr); 
    ASM.WrS(',H'); ASM.WrI(bl^.Blocklist.height); 
    ASM.WrS(','); 
    CmtBl(bl^.Blocklist.sub);
    ASM.WrS(')'); 
 ;
      RETURN;

  END;
(* line 666 "CMT.pum" *)
(* line 666 "CMT.pum" *)
      
    ASM.WrS('-'); 
 ;
      RETURN;

 END CmtBl;

PROCEDURE BeginCMT*;
 BEGIN
 END BeginCMT;

PROCEDURE CloseCMT*;
 BEGIN
 END CloseCMT;

PROCEDURE yyExit;
 BEGIN
  IO.CloseIO; System.Exit (1);
 END yyExit;

BEGIN
 yyf	:= IO.StdOutput;
 Exit	:= yyExit;
 BeginCMT;
END CMT.

