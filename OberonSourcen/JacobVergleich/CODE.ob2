MODULE CODE;








IMPORT SYSTEM, System, IO, Tree, OB,
(* line 20 "CODE.tmp" *)
 ASMOP,ADR,ARG,ASM,BL,CMT,CO,CODEf,Cons,CV,Base,E,ERR,FIL,Idents,LAB,LIM,NDP,O,OT,Strings,T,Target,V; 

CONST 
al=ASM.al;ah=ASM.ah;bl=ASM.bl;bh=ASM.bh;cl=ASM.cl;ch=ASM.ch;dl=ASM.dl;dh=ASM.dh;
ax=ASM.ax;bx=ASM.bx;cx=ASM.cx;dx=ASM.dx;si=ASM.si;di=ASM.di;eax=ASM.eax;ebx=ASM.ebx;
ecx=ASM.ecx;edx=ASM.edx;esi=ASM.esi;edi=ASM.edi;ebp=ASM.ebp;esp=ASM.esp;b=ASM.b;
w=ASM.w;l=ASM.l;s=ASM.s;
add=ASMOP.add;and=ASMOP.and;call=ASMOP.call;cld=ASMOP.cld;imul=ASMOP.imul;jmp=ASMOP.jmp;
lea=ASMOP.lea;leave=ASMOP.leave;mov=ASMOP.mov;movs=ASMOP.movs;neg=ASMOP.neg;not=ASMOP.not;
or=ASMOP.or;popl=ASMOP.popl;pushl=ASMOP.pushl;repz=ASMOP.repz;ret=ASMOP.ret;shl=ASMOP.shl;
shr=ASMOP.shr;sub=ASMOP.sub;rol=ASMOP.rol;xor=ASMOP.xor;fadd=ASMOP.fadd;
fdiv=ASMOP.fdiv;fmul=ASMOP.fmul;fsub=ASMOP.fsub;

VAR yyf*	: IO.tFile;
VAR Exit*	: PROCEDURE;
        TYPE   tLevel                   = OB.tLevel                ; 
               tRelation                = ASM.tRelation            ;
               ACode                    = Cons.Address             ;
               DCode                    = Cons.Data                ; 
               CondCode                 = Cons.Condition           ;
	       BoolCode                 = Cons.Boolean             ;
	       PopCode                  = Cons.ShrinkingStack      ;
               ArgCode                  = Cons.Arguments           ;
               SCpCode                  = Cons.StringCopyArguments ; 
               RetypeCode               = Cons.Retype              ;
               tLabel                   = LAB.T                    ; 

               tCaseLabelTab            = ARRAY LIM.MaxCaseLabelRange OF tLabel;
               tImplicitDesignationData = RECORD
                                           typeOfObject          : OB.tOB;
                                           isStackObject         : BOOLEAN; 
                                           acodeToObjHeader      : ACode;
                                           ofsOfObjHeader        : LONGINT; 
                                           ofsOfObject           : LONGINT; 
    
                                           ofsOfLEN0             : LONGINT; 
                                           nofOpenIndexings      : LONGINT; 
                                           codeToOpenIndexedElem : PopCode;
                                           codeToObjBaseReg      : DCode;
                                          END;
	TYPE   RelOperRange=INTEGER;(* [Tree.EqualOper..Tree.GreaterEqualOper];*)
 CONST MAX_RelOperRange = Tree.GreaterEqualOper;
        VAR    RelTab                   : ARRAY MAX_RelOperRange+1 OF ASM.tRelation; 
	       rel                      : RelOperRange; 


PROCEDURE^CodeAssignment (dstType: OB.tOB; srcType: OB.tOB; srcVal: OB.tOB; designator: Tree.tTree; expr: Tree.tTree; coercion: OB.tOB);
PROCEDURE^CodeProcedureCall (designator: Tree.tTree);
PROCEDURE^CodeIfStmt (exprVal: OB.tOB; yyP1: Tree.tTree);
PROCEDURE^CodeCaseStmt (yyP4: OB.tOB; stmt: Tree.tTree);
PROCEDURE^CodeWhileStmt (exprVal: OB.tOB; yyP2: Tree.tTree);
PROCEDURE^CodeRepeatStmt (exprVal: OB.tOB; yyP3: Tree.tTree);
PROCEDURE^CodeForStmt (v: OB.tOB; yyP9: Tree.tTree);
PROCEDURE^CodeGuardedStmts (guardedStmts: Tree.tTree; elseLabel: tLabel; else: Tree.tTree; endLabel: tLabel);
PROCEDURE^IsEmptyNode (yyP69: Tree.tTree): BOOLEAN;
PROCEDURE^CodeFunctionReturn (srcType: OB.tOB; srcVal: OB.tOB; expr: Tree.tTree; coercion: OB.tOB);
PROCEDURE^CodeBooleanExpr (expr: Tree.tTree; exprVal: OB.tOB; exprLabel: tLabel; trueLabel: tLabel; falseLabel: tLabel; VAR yyP30: BoolCode);
PROCEDURE^CodeRExpr (type: OB.tOB; expr: Tree.tTree; co: OB.tOB; VAR yyP24: DCode);
PROCEDURE^CodeCases (case: Tree.tTree; endLabel: tLabel; VAR LabelTab: tCaseLabelTab; minLabelVal: LONGINT; mtElse: BOOLEAN);
PROCEDURE^EnterCaseLabels (yyP6: Tree.tTree; label: tLabel; VAR LabelTab: tCaseLabelTab; minLabelVal: LONGINT);
PROCEDURE^CodeSimpleLDesignator (entry: OB.tOB; curLevel: tLevel; VAR yyP35: ACode);
PROCEDURE^CodeGuard (variable: OB.tOB; testType: OB.tOB; falseLabel: tLabel; curLevel: tLevel);
PROCEDURE^CodeImplicitAssignmentGuard (dstEntry: OB.tOB; dstType: OB.tOB; designator: Tree.tTree; VAR yyP10: ACode);
PROCEDURE^CodeAssign (dstType: OB.tOB; srcType: OB.tOB; srcVal: OB.tOB; dstAcode: ACode; expr: Tree.tTree; coercion: OB.tOB);
PROCEDURE^CodeLDesignator (designator: Tree.tTree; VAR yyP36: ACode);
PROCEDURE^CodeLongstringAssignment (val: OB.tOB; yyP11: Tree.tTree; dstAcode: ACode);
PROCEDURE^CodePredeclFuncs (yyP57: Tree.tTree; dstType: OB.tOB; VAR yyP58: DCode);
PROCEDURE^CodeVarParam (dstType: OB.tOB; srcType: OB.tOB; srcVal: OB.tOB; expr: Tree.tTree; argcodeIn: ArgCode; VAR yyP15: ArgCode);
PROCEDURE^CodeValParam (dstType: OB.tOB; srcType: OB.tOB; srcVal: OB.tOB; expr: Tree.tTree; coercion: OB.tOB; argcodeIn: ArgCode; VAR yyP23: ArgCode);
PROCEDURE^CodeRecordVarParam (yyP19: OB.tOB; srcType: OB.tOB; designator: Tree.tTree; argcodeIn: ArgCode; VAR yyP20: ArgCode);
PROCEDURE^CodeOpenArrayParam (actEntry: OB.tOB; frmType: OB.tOB; actType: OB.tOB; actVal: OB.tOB; designator: Tree.tTree; argcodeIn: ArgCode; VAR yyP16: ArgCode);
PROCEDURE^CodeOpenArrayOfByteParam (actType: OB.tOB; flattenedVarType: OB.tOB; actEntry: OB.tOB; designator: Tree.tTree; argcodeIn: ArgCode; VAR yyP17: ArgCode);
PROCEDURE^CodeImplicitConstLens (frmType: OB.tOB; actType: OB.tOB; argcodeIn: ArgCode; VAR yyP18: ArgCode; VAR TotalNofOpenLens: LONGINT; VAR NofRemainingOpenLens: LONGINT; VAR BaseNofElems: LONGINT);
PROCEDURE^CodeOpenArrayStringParam (srcType: OB.tOB; srcVal: OB.tOB; argcodeIn: ArgCode; VAR yyP22: ArgCode);
PROCEDURE^CodeValue (yyP76: OB.tOB; yyP75: OB.tOB; yyP74: OB.tOB; VAR yyP77: DCode);
PROCEDURE^CodeCoercion (yyP28: OB.tOB; codeIn: DCode; VAR yyP29: DCode);
PROCEDURE^CodeDyOper (yyP25: Tree.tTree; type: OB.tOB; dcode1: DCode; dcode2: DCode; VAR yyP26: DCode);
PROCEDURE^CodeElements (elements: Tree.tTree; dcodeIn: DCode; VAR yyP27: DCode);
PROCEDURE^CodeRDesignator (designator: Tree.tTree; VAR yyP33: DCode);
PROCEDURE^CodePredeclPredicates (yyP67: Tree.tTree; exprLabel: tLabel; trueLabel: tLabel; falseLabel: tLabel; VAR yyP68: BoolCode);
PROCEDURE^CodeRelation (type1: OB.tOB; type2: OB.tOB; val1: OB.tOB; val2: OB.tOB; expr: Tree.tTree; exprLabel: tLabel; VAR yyP31: CondCode; VAR isSigned: BOOLEAN);
PROCEDURE^CodeIsExpr (StaticType: OB.tOB; TestType: OB.tOB; designator: Tree.tTree; exprLabel: tLabel; trueLabel: tLabel; falseLabel: tLabel; VAR yyP32: BoolCode);
PROCEDURE^CodeImplicitLDesignator (yyP37: Tree.tTree; VAR idData: tImplicitDesignationData; VAR yyP38: ACode);
PROCEDURE^CodePredeclProcs (yyP63: Tree.tTree);
PROCEDURE^CodeRefdValParam (dstType: OB.tOB; srcType: OB.tOB; srcVal: OB.tOB; expr: Tree.tTree; argcodeIn: ArgCode; VAR yyP21: ArgCode);
PROCEDURE^CodeRDesignator1 (entry: OB.tOB; type: OB.tOB; designator: Tree.tTree; designations: Tree.tTree; VAR yyP34: DCode);
PROCEDURE^CodeSysValSource (srcType: OB.tOB; dstType: OB.tOB; expr: Tree.tTree; tmpOfs: LONGINT; VAR yyP59: RetypeCode);
PROCEDURE^CodeLDesignator1 (entry: OB.tOB; designations: Tree.tTree; VAR idData: tImplicitDesignationData; argcodeIn: ArgCode; VAR yyP39: ACode);
PROCEDURE^CodeStackImplicitDesignations (type: OB.tOB; designations: Tree.tTree; VAR idData: tImplicitDesignationData; isWithed: BOOLEAN; objOfs: LONGINT; acodeIn: ACode; VAR yyP46: ACode; VAR yyP45: Tree.tTree);
PROCEDURE^CodeDesignations (yyP40: Tree.tTree; VAR idData: tImplicitDesignationData; isWithed: BOOLEAN; argcodeIn: ArgCode; acodeIn: ACode; VAR yyP41: ACode);
PROCEDURE^CodeHeapImplicitDesignations (type: OB.tOB; designations: Tree.tTree; VAR idData: tImplicitDesignationData; objOfs: LONGINT; acodeIn: ACode; VAR yyP48: ACode; VAR yyP47: Tree.tTree);
PROCEDURE^CodeIndirectCall (procType: OB.tOB; argcodeIn: ArgCode; acodeIn: ACode; VAR yyP52: ACode);
PROCEDURE^CodeBoundCall (procEntry: OB.tOB; aRcvEntry: OB.tOB; rcvType: OB.tOB; curLevel: tLevel; bprocLab: tLabel; argcodeIn: ArgCode; acodeIn: ACode; VAR yyP53: ACode);
PROCEDURE^CodePointerGuarding (StaticType: OB.tOB; TestType: OB.tOB; isWithed: BOOLEAN; acodeIn: ACode; VAR yyP42: ACode);
PROCEDURE^CodeOpenIndexing (type: OB.tOB; designations: Tree.tTree; VAR idData: tImplicitDesignationData; isFirst: BOOLEAN; lenOfs: LONGINT; headerBaseRegCode: DCode; VAR yyP50: PopCode; VAR yyP49: Tree.tTree; VAR WasOpenIndexing: BOOLEAN);
PROCEDURE^CodeOpenIndexingBase (type: OB.tOB; lenOfs: LONGINT; headerBaseRegCode: DCode; VAR yyP51: PopCode);
PROCEDURE^CodeBoundCall1 (formalType: OB.tOB; actualType: OB.tOB; actualEntry: OB.tOB; curLevel: tLevel; bprocLab: tLabel; procNum: LONGINT; paramSpace: LONGINT; argcodeIn: ArgCode; acodeIn: ACode; VAR yyP54: ACode);
PROCEDURE^CodeTagFieldOfRecVar (yyP55: OB.tOB; type: OB.tOB; curLevel: tLevel; VAR yyP56: DCode);
PROCEDURE^CodeSecondShiftOperand (yyP61: OB.tOB; type: OB.tOB; expr: Tree.tTree; VAR yyP62: DCode);
PROCEDURE^CodeSysValRDestination (dstType: OB.tOB; retypecode: RetypeCode; VAR yyP60: DCode);
PROCEDURE^CodeAssert (exprVal: OB.tOB; expr: Tree.tTree; errorcode: LONGINT);
PROCEDURE^CodeStringCopy (srcVal: OB.tOB; srcExpr: Tree.tTree; dstType: OB.tOB; srcType: OB.tOB; dst: Tree.tTree);
PROCEDURE^CodeDecls (yyP72: Tree.tTree);
PROCEDURE^CodeProcs (proc: Tree.tTree);
PROCEDURE^CodeConstValue (yyP73: OB.tOB);
PROCEDURE^CodeProc (entry: OB.tOB; proc: Tree.tTree; isBoundProc: BOOLEAN);
PROCEDURE^CodeStaticNew (type: OB.tOB; designator: Tree.tTree);
PROCEDURE^CodeOpenNew (type: OB.tOB; designator: Tree.tTree; exprList: Tree.tTree);
PROCEDURE^CodeStringCopyVariableOperand (type: OB.tOB; designator: Tree.tTree; VAR yyP64: DCode);
PROCEDURE^CodeOpenNewExprs (exprList: Tree.tTree; argcodeIn: ArgCode; VAR yyP66: ArgCode; VAR yyP65: LONGINT);
PROCEDURE^CodeModule (yyP71: Tree.tTree);
PROCEDURE^CodeLocalImplicitDesignations (type: OB.tOB; designations: Tree.tTree; VAR idData: tImplicitDesignationData; isWithed: BOOLEAN; objOfs: LONGINT; acodeIn: ACode; VAR yyP44: ACode; VAR yyP43: Tree.tTree);
























































































































































































PROCEDURE yyAbort (yyFunction: ARRAY OF CHAR);
 BEGIN
  IO.WriteS (IO.StdError, 'Error: module CODE, routine ');
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

PROCEDURE^CodeStmt (stmt: Tree.tTree);

PROCEDURE CodeStmts (stmt: Tree.tTree);
 BEGIN
  IF stmt = Tree.NoTree THEN RETURN; END;
  IF Tree.IsType (stmt, Tree.Stmt) THEN
(* line 66 "CODE.tmp" *)
(* line 66 "CODE.tmp" *)
      
    IF ARG.OptionCommentsInAsm THEN CMT.Cmt(stmt); END;
    CodeStmt(stmt); 
    ASM.Ln; 
    CodeStmts(stmt^.Stmt.Next); 
 ;
      RETURN;

  END;
 END CodeStmts;

PROCEDURE CodeStmt (stmt: Tree.tTree);
(* line 77 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; boolcode:BoolCode; condLabel,endLabel,loopLabel,trueLabel,falseLabel:LAB.T; 
 BEGIN
  IF stmt = Tree.NoTree THEN RETURN; END;

  CASE stmt^.Kind OF
  | Tree.AssignStmt:
(* line 79 "CODE.tmp" *)
(* line 81 "CODE.tmp" *)
       O.StrLn( "CodeStmts.AssignStmt" ) ; 
    CodeAssignment(stmt^.AssignStmt.Designator^.Designator.TypeReprOut,stmt^.AssignStmt.Exprs^.Exprs.TypeReprOut,stmt^.AssignStmt.Exprs^.Exprs.ValueReprOut,stmt^.AssignStmt.Designator,stmt^.AssignStmt.Exprs,stmt^.AssignStmt.Coerce);
 ;
      RETURN;

  | Tree.CallStmt:
(* line 85 "CODE.tmp" *)
(* line 85 "CODE.tmp" *)
       O.StrLn( "CodeStmts.CallStmt" ) ; 
    CodeProcedureCall(stmt^.CallStmt.Designator); 
 ;
      RETURN;

  | Tree.IfStmt:
(* line 89 "CODE.tmp" *)
(* line 89 "CODE.tmp" *)
       O.StrLn( "CodeStmts.IfStmt" ) ; 
    CodeIfStmt(stmt^.IfStmt.Exprs^.Exprs.ValueReprOut,stmt); 
 ;
      RETURN;

  | Tree.CaseStmt:
(* line 93 "CODE.tmp" *)
(* line 93 "CODE.tmp" *)
       O.StrLn( "CodeStmts.CaseStmt" ) ; 
    CodeCaseStmt(stmt^.CaseStmt.LabelLimits,stmt); 
 ;
      RETURN;

  | Tree.WhileStmt:
(* line 97 "CODE.tmp" *)
(* line 97 "CODE.tmp" *)
       O.StrLn( "CodeStmts.WhileStmt" ) ; 
    CodeWhileStmt(stmt^.WhileStmt.Exprs^.Exprs.ValueReprOut,stmt); 
 ;
      RETURN;

  | Tree.RepeatStmt:
(* line 101 "CODE.tmp" *)
(* line 101 "CODE.tmp" *)
       O.StrLn( "CodeStmts.RepeatStmt" ) ; 
    CodeRepeatStmt(stmt^.RepeatStmt.Exprs^.Exprs.ValueReprOut,stmt); 
 ;
      RETURN;

  | Tree.ForStmt:
(* line 105 "CODE.tmp" *)
(* line 105 "CODE.tmp" *)
       O.StrLn( "CodeStmts.ForStmt" ) ; 
    CodeForStmt(stmt^.ForStmt.ControlVarEntry,stmt); 
 ;
      RETURN;

  | Tree.LoopStmt:
(* line 109 "CODE.tmp" *)
(* line 109 "CODE.tmp" *)
       O.StrLn( "CodeStmts.LoopStmt" ) ; 
    ASM.Label(LAB.New(loopLabel)); 
    CodeStmts(stmt^.LoopStmt.Stmts); 
    ASM.C1( jmp  ,  ASM.L(loopLabel) ); 
    ASM.Label(stmt^.LoopStmt.LoopEndLabel); 
 ;
      RETURN;

  | Tree.WithStmt:
(* line 116 "CODE.tmp" *)
(* line 116 "CODE.tmp" *)
       O.StrLn( "CodeStmts.WithStmt" ) ; 
    CodeGuardedStmts(stmt^.WithStmt.GuardedStmts,LAB.NewLocal(),stmt^.WithStmt.Else,LAB.NewLocal()); 
 ;
      RETURN;

  | Tree.ExitStmt:
(* line 120 "CODE.tmp" *)
(* line 120 "CODE.tmp" *)
       O.StrLn( "CodeStmts.ExitStmt" ) ; 
    ASM.C1( jmp  ,  ASM.L(stmt^.ExitStmt.LoopEndLabel) ); 
 ;
      RETURN;

  | Tree.ReturnStmt:
(* line 124 "CODE.tmp" *)
(* line 124 "CODE.tmp" *)
       O.StrLn( "CodeStmts.ReturnStmt" ) ; 
    IF IsEmptyNode(stmt^.ReturnStmt.Exprs) THEN 
       Cons.ProcReturn;
    ELSE 
       CodeFunctionReturn(stmt^.ReturnStmt.Exprs^.Exprs.TypeReprOut,stmt^.ReturnStmt.Exprs^.Exprs.ValueReprOut,stmt^.ReturnStmt.Exprs,stmt^.ReturnStmt.Coerce); 
    END;
 ;
      RETURN;

  ELSE END;

 END CodeStmt;

PROCEDURE CodeIfStmt (exprVal: OB.tOB; yyP1: Tree.tTree);
(* line 136 "CODE.tmp" *)
 VAR boolcode:BoolCode; endLabel,trueLabel,falseLabel:LAB.T; 
 BEGIN
  IF exprVal = OB.NoOB THEN RETURN; END;
  IF yyP1 = Tree.NoTree THEN RETURN; END;
  IF (exprVal^.Kind = OB.BooleanValue) THEN
(* line 138 "CODE.tmp" *)
(* line 138 "CODE.tmp" *)
       O.StrLn( "CodeIfStmt.Const" ) ; 
    IF exprVal^.BooleanValue.v THEN 
       CodeStmts(yyP1^.IfStmt.Then); 
    ELSE 
       CodeStmts(yyP1^.IfStmt.Else); 
    END;
 ;
      RETURN;

  END;
  IF (yyP1^.IfStmt.Then^.Kind = Tree.mtStmt) THEN
  IF (yyP1^.IfStmt.Else^.Kind = Tree.mtStmt) THEN
(* line 146 "CODE.tmp" *)
(* line 146 "CODE.tmp" *)
       O.StrLn( "CodeIfStmt.mt.mt" ) ; 
    endLabel:=LAB.NewLocal(); 
    CodeBooleanExpr(yyP1^.IfStmt.Exprs,exprVal,LAB.MT,endLabel,endLabel,boolcode); 
    Cons.NoBoolVal(boolcode); 
    ASM.Label(endLabel); 		      
 ;
      RETURN;

  END;
(* line 162 "CODE.tmp" *)
(* line 162 "CODE.tmp" *)
       O.StrLn( "CodeIfStmt.mt.Else" ) ; 
    CodeBooleanExpr(yyP1^.IfStmt.Exprs,exprVal,LAB.MT,LAB.New(endLabel),LAB.New(falseLabel),boolcode); 
    Cons.NoBoolVal(boolcode); 
    
    ASM.Label(falseLabel); 		      
    CodeStmts(yyP1^.IfStmt.Else); 
    ASM.Label(endLabel); 		      
 ;
      RETURN;

  END;
  IF (yyP1^.IfStmt.Else^.Kind = Tree.mtStmt) THEN
(* line 153 "CODE.tmp" *)
(* line 153 "CODE.tmp" *)
       O.StrLn( "CodeIfStmt.Then.mt" ) ; 
    CodeBooleanExpr(yyP1^.IfStmt.Exprs,exprVal,LAB.MT,LAB.New(trueLabel),LAB.New(endLabel),boolcode); 
    Cons.NoBoolVal(boolcode); 
    
    ASM.Label(trueLabel); 		      
    CodeStmts(yyP1^.IfStmt.Then); 
    ASM.Label(endLabel); 		      
 ;
      RETURN;

  END;
(* line 171 "CODE.tmp" *)
(* line 171 "CODE.tmp" *)
       O.StrLn( "CodeIfStmt.Then.Else" ) ; 
    CodeBooleanExpr(yyP1^.IfStmt.Exprs,exprVal,LAB.MT,LAB.New(trueLabel),LAB.New(falseLabel),boolcode); 
    Cons.NoBoolVal(boolcode); 
    
    ASM.Label(trueLabel); 		      
    CodeStmts(yyP1^.IfStmt.Then); 
    ASM.C1( jmp  ,  ASM.L(LAB.New(endLabel)) ); 
    
    ASM.Label(falseLabel); 		      
    CodeStmts(yyP1^.IfStmt.Else); 
    ASM.Label(endLabel); 		      
 ;
      RETURN;

 END CodeIfStmt;

PROCEDURE CodeWhileStmt (exprVal: OB.tOB; yyP2: Tree.tTree);
(* line 188 "CODE.tmp" *)
 VAR boolcode:BoolCode; condLabel,endLabel,loopLabel:LAB.T; 
 BEGIN
  IF exprVal = OB.NoOB THEN RETURN; END;
  IF yyP2 = Tree.NoTree THEN RETURN; END;
  IF (exprVal^.Kind = OB.BooleanValue) THEN
(* line 190 "CODE.tmp" *)
(* line 190 "CODE.tmp" *)
       O.StrLn( "CodeWhileStmt.Const" ) ; 
    IF exprVal^.BooleanValue.v THEN 
       ASM.Label(LAB.New(loopLabel)); 
       CodeStmts(yyP2^.WhileStmt.Stmts); 
       ASM.C1( jmp  ,  ASM.L(loopLabel) ); 
    END;
 ;
      RETURN;

  END;
(* line 198 "CODE.tmp" *)
(* line 198 "CODE.tmp" *)
       O.StrLn( "CodeWhileStmt" ) ; 
    ASM.C1( jmp  ,  ASM.L(LAB.New(condLabel)) ); 
    ASM.Label(LAB.New(loopLabel)); 
    CodeStmts(yyP2^.WhileStmt.Stmts); 
    ASM.Label(condLabel); 
    CodeBooleanExpr(yyP2^.WhileStmt.Exprs,exprVal,LAB.MT,loopLabel,LAB.New(endLabel),boolcode); 
    Cons.NoBoolVal(boolcode); 
    ASM.Label(endLabel); 
 ;
      RETURN;

 END CodeWhileStmt;

PROCEDURE CodeRepeatStmt (exprVal: OB.tOB; yyP3: Tree.tTree);
(* line 212 "CODE.tmp" *)
 VAR boolcode:BoolCode; endLabel,loopLabel:LAB.T; 
 BEGIN
  IF exprVal = OB.NoOB THEN RETURN; END;
  IF yyP3 = Tree.NoTree THEN RETURN; END;
  IF (exprVal^.Kind = OB.BooleanValue) THEN
(* line 214 "CODE.tmp" *)
(* line 214 "CODE.tmp" *)
       O.StrLn( "CodeRepeatStmt.Const" ) ; 
    IF exprVal^.BooleanValue.v THEN 
       CodeStmts(yyP3^.RepeatStmt.Stmts); 
    ELSE 
       ASM.Label(LAB.New(loopLabel)); 
       CodeStmts(yyP3^.RepeatStmt.Stmts); 
       ASM.C1( jmp  ,  ASM.L(loopLabel) ); 
    END;
 ;
      RETURN;

  END;
(* line 224 "CODE.tmp" *)
(* line 224 "CODE.tmp" *)
       O.StrLn( "CodeRepeatStmt" ) ; 
    ASM.Label(LAB.New(loopLabel)); 
    CodeStmts(yyP3^.RepeatStmt.Stmts); 
    CodeBooleanExpr(yyP3^.RepeatStmt.Exprs,exprVal,LAB.MT,LAB.New(endLabel),loopLabel,boolcode); 
    Cons.NoBoolVal(boolcode); 
    ASM.Label(endLabel); 
 ;
      RETURN;

 END CodeRepeatStmt;

PROCEDURE^CodeCaseStmt1 (yyP5: Tree.tTree; minLabelVal: LONGINT; maxLabelVal: LONGINT; isChar: BOOLEAN);

PROCEDURE CodeCaseStmt (yyP4: OB.tOB; stmt: Tree.tTree);
 BEGIN
  IF yyP4 = OB.NoOB THEN RETURN; END;
  IF stmt = Tree.NoTree THEN RETURN; END;
  IF (yyP4^.Kind = OB.CharRange) THEN
(* line 237 "CODE.tmp" *)
(* line 237 "CODE.tmp" *)
       CodeCaseStmt1(stmt,ORD(yyP4^.CharRange.a),ORD(yyP4^.CharRange.b),(* isChar:= *)TRUE ); ;
      RETURN;

  END;
  IF (yyP4^.Kind = OB.IntegerRange) THEN
(* line 238 "CODE.tmp" *)
(* line 238 "CODE.tmp" *)
       CodeCaseStmt1(stmt,yyP4^.IntegerRange.a,yyP4^.IntegerRange.b,(* isChar:= *)FALSE); ;
      RETURN;

  END;
(* line 240 "CODE.tmp" *)
(* line 240 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeCaseStmt: failed'); ;
      RETURN;

 END CodeCaseStmt;

PROCEDURE CodeCaseStmt1 (yyP5: Tree.tTree; minLabelVal: LONGINT; maxLabelVal: LONGINT; isChar: BOOLEAN);
(* line 246 "CODE.tmp" *)
 VAR i:LONGINT; mtElse:BOOLEAN; tabLabel,elseLabel,endLabel:tLabel; LabelTab:tCaseLabelTab; 
           dcode:DCode; s:ARRAY 11 OF CHAR; 
 BEGIN
  IF yyP5 = Tree.NoTree THEN RETURN; END;
(* line 249 "CODE.tmp" *)
(* line 249 "CODE.tmp" *)
      
    tabLabel:=LAB.NewLocal(); 
    endLabel:=LAB.NewLocal(); 
    mtElse:=IsEmptyNode(yyP5^.CaseStmt.Else); 
    IF mtElse THEN elseLabel:=endLabel; ELSE elseLabel:=LAB.NewLocal(); END;

    CodeRExpr(yyP5^.CaseStmt.Exprs^.Exprs.TypeReprOut,yyP5^.CaseStmt.Exprs,OB.cmtCoercion,dcode); 
    Cons.CaseExpr(isChar,minLabelVal,maxLabelVal,tabLabel,elseLabel,dcode); 

    FOR i:=0 TO maxLabelVal-minLabelVal DO LabelTab[i]:=elseLabel; END;

    CodeCases(yyP5^.CaseStmt.Cases,endLabel,LabelTab,minLabelVal,mtElse); 

    IF ~mtElse THEN 
       ASM.Label(elseLabel); 
       CodeStmts(yyP5^.CaseStmt.Else); 
    END;
    ASM.Label(endLabel); 

    ASM.Data;
    ASM.Align(2); 
    ASM.Label(tabLabel); 
    FOR i:=0 TO maxLabelVal-minLabelVal DO 
     ASM.LongL(LabelTab[i]); 
     IF ARG.OptionCommentsInAsm THEN 
	IF isChar THEN OT.oCHAR2ARR(CHR(i+minLabelVal),s); ASM.CmtS(s); ELSE ASM.CmtI(i+minLabelVal); END;
     END;
    END;
    ASM.Text;
 ;
      RETURN;

 END CodeCaseStmt1;

PROCEDURE CodeCases (case: Tree.tTree; endLabel: tLabel; VAR LabelTab: tCaseLabelTab; minLabelVal: LONGINT; mtElse: BOOLEAN);
(* line 284 "CODE.tmp" *)
 VAR label:tLabel; 
 BEGIN
  IF case = Tree.NoTree THEN RETURN; END;
  IF (case^.Kind = Tree.Case) THEN
(* line 286 "CODE.tmp" *)
(* line 286 "CODE.tmp" *)
       O.StrLn( "CodeCases" ) ; 
    ASM.Label(LAB.New(label)); 
    IF ARG.OptionCommentsInAsm THEN CMT.Cmt(case); END;
    EnterCaseLabels(case^.Case.CaseLabels,label,LabelTab,minLabelVal); 

    CodeStmts(case^.Case.Stmts); 
    IF ~mtElse OR ~IsEmptyNode(case^.Case.Next) THEN 
       ASM.C1( jmp  ,  ASM.L(endLabel) ); 
       ASM.Ln;
    END;

    CodeCases(case^.Case.Next,endLabel,LabelTab,minLabelVal,mtElse); 
 ;
      RETURN;

  END;
 END CodeCases;

PROCEDURE^EnterCaseLabel (yyP8: OB.tOB; yyP7: OB.tOB; label: tLabel; VAR LabelTab: tCaseLabelTab; minLabelVal: LONGINT);

PROCEDURE EnterCaseLabels (yyP6: Tree.tTree; label: tLabel; VAR LabelTab: tCaseLabelTab; minLabelVal: LONGINT);
 BEGIN
  IF yyP6 = Tree.NoTree THEN RETURN; END;
  IF (yyP6^.Kind = Tree.CaseLabel) THEN
(* line 305 "CODE.tmp" *)
(* line 305 "CODE.tmp" *)
      
    EnterCaseLabel (yyP6^.CaseLabel.ConstExpr1^.ConstExpr.Expr^.Exprs.ValueReprOut,yyP6^.CaseLabel.ConstExpr2^.ConstExpr.Expr^.Exprs.ValueReprOut ,label,LabelTab,minLabelVal); 
    EnterCaseLabels(yyP6^.CaseLabel.Next,label,LabelTab,minLabelVal); 
 ;
      RETURN;

  END;
 END EnterCaseLabels;

PROCEDURE EnterCaseLabel (yyP8: OB.tOB; yyP7: OB.tOB; label: tLabel; VAR LabelTab: tCaseLabelTab; minLabelVal: LONGINT);
(* line 314 "CODE.tmp" *)
 VAR i,x,y:LONGINT; 
 BEGIN
  IF yyP8 = OB.NoOB THEN RETURN; END;
  IF yyP7 = OB.NoOB THEN RETURN; END;
  IF (yyP8^.Kind = OB.CharValue) THEN
  IF (yyP7^.Kind = OB.mtValue) THEN
(* line 316 "CODE.tmp" *)
(* line 317 "CODE.tmp" *)
       x:=ORD(yyP8^.CharValue.v); LabelTab[x-minLabelVal]:=label; ;
      RETURN;

  END;
  IF (yyP7^.Kind = OB.CharValue) THEN
(* line 319 "CODE.tmp" *)
(* line 320 "CODE.tmp" *)
       x:=ORD(yyP8^.CharValue.v); y:=ORD(yyP7^.CharValue.v); FOR i:=x-minLabelVal TO y-minLabelVal DO LabelTab[i]:=label; END; ;
      RETURN;

  END;
  END;
  IF (yyP8^.Kind = OB.IntegerValue) THEN
  IF (yyP7^.Kind = OB.mtValue) THEN
(* line 316 "CODE.tmp" *)
(* line 317 "CODE.tmp" *)
       x:=yyP8^.IntegerValue.v; LabelTab[x-minLabelVal]:=label; ;
      RETURN;

  END;
  IF (yyP7^.Kind = OB.IntegerValue) THEN
(* line 319 "CODE.tmp" *)
(* line 320 "CODE.tmp" *)
       x:=yyP8^.IntegerValue.v; y:=yyP7^.IntegerValue.v; FOR i:=x-minLabelVal TO y-minLabelVal DO LabelTab[i]:=label; END; ;
      RETURN;

  END;
  END;
 END EnterCaseLabel;

PROCEDURE CodeForStmt (v: OB.tOB; yyP9: Tree.tTree);
(* line 326 "CODE.tmp" *)
 VAR acode,vAcode:ACode; stepDcode,dcode:DCode; condLabel,loopLabel:LAB.T; 
 BEGIN
  IF v = OB.NoOB THEN RETURN; END;
  IF yyP9 = Tree.NoTree THEN RETURN; END;
  IF OB.IsType (v^.VarEntry.typeRepr, OB.TypeRepr) THEN
(* line 328 "CODE.tmp" *)
(* line 333 "CODE.tmp" *)
       O.StrLn( "CodeForStmt" ) ; 

    (* temp := yyP9^.ForStmt.To *)
    Cons.LocalVariable(yyP9^.ForStmt.TempAddr,Idents.NoIdent,acode); 
    CodeRExpr(yyP9^.ForStmt.To^.Exprs.TypeReprOut,yyP9^.ForStmt.To,yyP9^.ForStmt.ToCoerce,dcode); 
    Cons.SimpleAssignment(acode,dcode); 
    
    (* v := yyP9^.ForStmt.From *)
    CodeSimpleLDesignator(yyP9^.ForStmt.ControlVarEntry,yyP9^.ForStmt.CurLevel,vAcode); 
    CodeRExpr(yyP9^.ForStmt.From^.Exprs.TypeReprOut,yyP9^.ForStmt.From,yyP9^.ForStmt.FromCoerce,dcode); 
    Cons.SimpleAssignment(vAcode,dcode); 
    
    ASM.C1( jmp  ,  ASM.L(LAB.New(condLabel)) ); 
    ASM.Label(LAB.New(loopLabel)); 

    CodeStmts(yyP9^.ForStmt.Stmts); 

    CodeSimpleLDesignator(yyP9^.ForStmt.ControlVarEntry,yyP9^.ForStmt.CurLevel,vAcode); 
    Cons.ForStmt(yyP9^.ForStmt.TempAddr,V.ValueOfInteger(yyP9^.ForStmt.By^.ConstExpr.Expr^.Exprs.ValueReprOut),loopLabel,condLabel,ASM.SizeTab[v^.VarEntry.typeRepr^.TypeRepr.size],vAcode); 
 ;
      RETURN;

  END;
(* line 354 "CODE.tmp" *)
(* line 354 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeForStmt: failed'); ;
      RETURN;

 END CodeForStmt;

PROCEDURE CodeGuardedStmts (guardedStmts: Tree.tTree; elseLabel: tLabel; else: Tree.tTree; endLabel: tLabel);
(* line 360 "CODE.tmp" *)
 VAR nextLabel:tLabel; 
 BEGIN
  IF guardedStmts = Tree.NoTree THEN RETURN; END;
  IF else = Tree.NoTree THEN RETURN; END;
  IF (guardedStmts^.Kind = Tree.GuardedStmt) THEN
  IF (guardedStmts^.GuardedStmt.Next^.Kind = Tree.mtGuardedStmt) THEN
(* line 362 "CODE.tmp" *)
(* line 362 "CODE.tmp" *)
       O.StrLn( "CodeGuardStmts.Guard" ) ; 
    IF ARG.OptionCommentsInAsm THEN CMT.Cmt(guardedStmts); END;

    CodeGuard(guardedStmts^.GuardedStmt.Guard^.Guard.VarEntry,guardedStmts^.GuardedStmt.Guard^.Guard.TypeTypeRepr,elseLabel,guardedStmts^.GuardedStmt.CurLevel); 
    CodeStmts(guardedStmts^.GuardedStmt.Stmts); 
    ASM.C1( jmp  ,  ASM.L(endLabel) ); 

    ASM.Label(elseLabel); 
    CodeStmts(else); 
    ASM.Label(endLabel); 
 ;
      RETURN;

  END;
(* line 374 "CODE.tmp" *)
(* line 374 "CODE.tmp" *)
       O.StrLn( "CodeGuardStmts.Guard" ) ; 
    IF ARG.OptionCommentsInAsm THEN CMT.Cmt(guardedStmts); END;

    CodeGuard(guardedStmts^.GuardedStmt.Guard^.Guard.VarEntry,guardedStmts^.GuardedStmt.Guard^.Guard.TypeTypeRepr,LAB.New(nextLabel),guardedStmts^.GuardedStmt.CurLevel); 
    CodeStmts(guardedStmts^.GuardedStmt.Stmts); 
    ASM.C1( jmp  ,  ASM.L(endLabel) ); 
    
    ASM.Label(nextLabel); 
    CodeGuardedStmts(guardedStmts^.GuardedStmt.Next,elseLabel,else,endLabel); 
 ;
      RETURN;

  END;
(* line 385 "CODE.tmp" *)
(* line 385 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeGuardedStmts: failed'); ;
      RETURN;

 END CodeGuardedStmts;

PROCEDURE CodeGuard (variable: OB.tOB; testType: OB.tOB; falseLabel: tLabel; curLevel: tLevel);
(* line 391 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; boolcode:BoolCode; labelcode:Cons.Label; trueLabel:tLabel; ofs:LONGINT; 
 BEGIN
  IF variable = OB.NoOB THEN RETURN; END;
  IF testType = OB.NoOB THEN RETURN; END;
  IF (variable^.VarEntry.typeRepr^.Kind = OB.RecordTypeRepr) THEN
(* line 393 "CODE.tmp" *)
   LOOP
(* line 393 "CODE.tmp" *)
      IF ~((variable^.VarEntry.parMode = OB . REFPAR)) THEN EXIT; END;
(* line 393 "CODE.tmp" *)
       O.StrLn( "CodeGuard.RecordType" ) ; 
    IF (ADR.TTableElemOfsInTDesc(variable^.VarEntry.typeRepr,testType,ofs) OR variable^.VarEntry.isWithed) & (ofs#0) THEN 
       IF variable^.VarEntry.level=curLevel THEN
          Cons.LocalVariable(variable^.VarEntry.address-4,variable^.VarEntry.ident,acode); 
       ELSE
          Cons.LocalVariable(-4*(1+variable^.VarEntry.level-OB.MODULELEVEL),Idents.NoIdent,acode); 
          Cons.ContentOf(l,acode,dcode); 
          Cons.PointerFrom(dcode,acode); 
          Cons.Selector(variable^.VarEntry.address-4,acode,acode); 
       END;
       Cons.ContentOf(l,acode,dcode); 

       Cons.LabelDef(LAB.MT,labelcode); 
       Cons.Is(LAB.AppS(T.LabelOfTypeRepr(testType),'$D'),ofs,LAB.New(trueLabel),falseLabel,labelcode,dcode,boolcode);
       Cons.NoBoolVal(boolcode); 
       ASM.Label(trueLabel); 
    END;
 ;
      RETURN;
   END;

  END;
  IF (variable^.VarEntry.typeRepr^.Kind = OB.PointerTypeRepr) THEN
  IF (variable^.VarEntry.typeRepr^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
  IF (testType^.Kind = OB.PointerTypeRepr) THEN
  IF (testType^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
(* line 412 "CODE.tmp" *)
(* line 413 "CODE.tmp" *)
       O.StrLn( "CodeGuard.PointerType" ) ; 
    IF (ADR.TTableElemOfsInTDesc(variable^.VarEntry.typeRepr^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr,testType^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr,ofs) OR variable^.VarEntry.isWithed) & (ofs#0) THEN 
       CodeSimpleLDesignator(variable,curLevel,acode); 
       Cons.ContentOf(l,acode,dcode); 

       IF ARG.OptionNilChecking THEN 
          Cons.NilCheck(dcode,dcode); 
       END;
       Cons.PointerFrom(dcode,acode); 
       Cons.Selector(-4,acode,acode); 
       Cons.ContentOf(l,acode,dcode); 

       Cons.LabelDef(LAB.MT,labelcode); 
       Cons.Is(LAB.AppS(T.LabelOfTypeRepr(testType^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr),'$D'),ofs,LAB.New(trueLabel),falseLabel,labelcode,dcode,boolcode);
       Cons.NoBoolVal(boolcode); 
       ASM.Label(trueLabel); 
    END;
 ;
      RETURN;

  END;
  END;
  END;
  END;
(* line 432 "CODE.tmp" *)
(* line 432 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeGuard: failed'); ;
      RETURN;

 END CodeGuard;

PROCEDURE CodeAssignment (dstType: OB.tOB; srcType: OB.tOB; srcVal: OB.tOB; designator: Tree.tTree; expr: Tree.tTree; coercion: OB.tOB);
(* line 443 "CODE.tmp" *)
 VAR acode:ACode; 
 BEGIN
  IF dstType = OB.NoOB THEN RETURN; END;
  IF srcType = OB.NoOB THEN RETURN; END;
  IF srcVal = OB.NoOB THEN RETURN; END;
  IF designator = Tree.NoTree THEN RETURN; END;
  IF expr = Tree.NoTree THEN RETURN; END;
  IF coercion = OB.NoOB THEN RETURN; END;
  IF (dstType^.Kind = OB.RecordTypeRepr) THEN
(* line 445 "CODE.tmp" *)
(* line 445 "CODE.tmp" *)
      
    CodeImplicitAssignmentGuard(designator^.Designator.Entry,dstType,designator,acode); 
    CodeAssign(dstType,srcType,srcVal,acode,expr,coercion); 
 ;
      RETURN;

  END;
(* line 450 "CODE.tmp" *)
(* line 450 "CODE.tmp" *)
      
    CodeLDesignator(designator,acode); 
    CodeAssign(dstType,srcType,srcVal,acode,expr,coercion); 
 ;
      RETURN;

 END CodeAssignment;

PROCEDURE CodeImplicitAssignmentGuard (dstEntry: OB.tOB; dstType: OB.tOB; designator: Tree.tTree; VAR yyP10: ACode);
(* line 459 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; idData:tImplicitDesignationData; 
 BEGIN
  IF dstEntry = OB.NoOB THEN RETURN; END;
  IF dstType = OB.NoOB THEN RETURN; END;
  IF designator = Tree.NoTree THEN RETURN; END;
  IF (dstEntry^.Kind = OB.VarEntry) THEN
  IF (dstEntry^.VarEntry.typeRepr^.Kind = OB.RecordTypeRepr) THEN
(* line 461 "CODE.tmp" *)
   LOOP
(* line 461 "CODE.tmp" *)
      IF ~((dstEntry^.VarEntry.parMode = OB . REFPAR)) THEN EXIT; END;
(* line 461 "CODE.tmp" *)
       O.StrLn( "ImplicitAssignmentGuard.RecordVarPar" ) ; 
    CodeImplicitLDesignator(designator,idData,acode); 

    Cons.Selector(4+idData.ofsOfObjHeader,idData.acodeToObjHeader,acode); 
    Cons.SimpleGuard(LAB.AppS(T.LabelOfTypeRepr(dstType),'$D'),-4,acode,acode); 
    Cons.ContentOf(l,acode,dcode); 
    Cons.PointerFrom(dcode,acode); 
 ;
      yyP10 := acode;
      RETURN;
   END;

  END;
(* line 470 "CODE.tmp" *)
   LOOP
(* line 470 "CODE.tmp" *)
      IF ~((T . IsPointerOrArrayOfPointerType (dstEntry^.VarEntry.typeRepr))) THEN EXIT; END;
(* line 470 "CODE.tmp" *)
       O.StrLn( "ImplicitAssignmentGuard.PointerToRecord" ) ; 
    CodeLDesignator(designator,acode); 

    Cons.SimpleGuard(LAB.AppS(T.LabelOfTypeRepr(dstType),'$D'),-4,acode,acode); 
 ;
      yyP10 := acode;
      RETURN;
   END;

  END;
(* line 476 "CODE.tmp" *)
(* line 476 "CODE.tmp" *)
       O.StrLn( "ImplicitAssignmentGuard.Default" ) ; 
    CodeLDesignator(designator,acode); 
 ;
      yyP10 := acode;
      RETURN;

 END CodeImplicitAssignmentGuard;

PROCEDURE CodeAssign (dstType: OB.tOB; srcType: OB.tOB; srcVal: OB.tOB; dstAcode: ACode; expr: Tree.tTree; coercion: OB.tOB);
(* line 490 "CODE.tmp" *)
 VAR acode,srcAcode:ACode; dcode:DCode; lr:OT.oLONGREAL; li,lo,hi:LONGINT; 
 BEGIN
  IF dstType = OB.NoOB THEN RETURN; END;
  IF srcType = OB.NoOB THEN RETURN; END;
  IF srcVal = OB.NoOB THEN RETURN; END;
  IF expr = Tree.NoTree THEN RETURN; END;
  IF coercion = OB.NoOB THEN RETURN; END;
  IF (dstType^.Kind = OB.RealTypeRepr) THEN
  IF (srcVal^.Kind = OB.RealValue) THEN
(* line 493 "CODE.tmp" *)
(* line 493 "CODE.tmp" *)
       O.StrLn( "CodeAssign.Real_ConstReal" ) ; 
    Cons.RealConst(srcVal^.RealValue.v,dcode); 
    Cons.SimpleAssignment(dstAcode,dcode);
 ;
      RETURN;

  END;
  IF (srcVal^.Kind = OB.mtValue) THEN
(* line 509 "CODE.tmp" *)
(* line 509 "CODE.tmp" *)
       O.StrLn( "CodeAssign.Real_Real" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.FloatAssignment(s,dstAcode,dcode);
 ;
      RETURN;

  END;
(* line 546 "CODE.tmp" *)
(* line 556 "CODE.tmp" *)
       O.StrLn( "CodeAssign.StandardType" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.SimpleAssignment(dstAcode,dcode);
 ;
      RETURN;

  END;
  IF (dstType^.Kind = OB.LongrealTypeRepr) THEN
  IF (srcVal^.Kind = OB.RealValue) THEN
(* line 498 "CODE.tmp" *)
(* line 498 "CODE.tmp" *)
       O.StrLn( "CodeAssign.Longreal_ConstReal" ) ; 
    OT.oREAL2oLONGREAL(srcVal^.RealValue.v,lr); OT.SplitoLONGREAL(lr,lo,hi); 
    Cons.MemSet8(lo,hi,dstAcode);
 ;
      RETURN;

  END;
  IF (srcVal^.Kind = OB.LongrealValue) THEN
(* line 503 "CODE.tmp" *)
(* line 503 "CODE.tmp" *)
       O.StrLn( "CodeAssign.Longreal_ConstLongreal" ) ; 
    OT.SplitoLONGREAL(srcVal^.LongrealValue.v,lo,hi); 
    Cons.MemSet8(lo,hi,dstAcode);
 ;
      RETURN;

  END;
  IF (srcVal^.Kind = OB.mtValue) THEN
(* line 514 "CODE.tmp" *)
(* line 514 "CODE.tmp" *)
       O.StrLn( "CodeAssign.Longreal_Longreal" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.FloatAssignment(l,dstAcode,dcode);
 ;
      RETURN;

  END;
  END;
  IF (dstType^.Kind = OB.CharStringTypeRepr) THEN
  IF (srcType^.Kind = OB.CharStringTypeRepr) THEN
  IF (srcVal^.Kind = OB.CharValue) THEN
(* line 520 "CODE.tmp" *)
(* line 521 "CODE.tmp" *)
       O.StrLn( "CodeAssign.Char_CharString" ) ; 
    Cons.CharConst(srcVal^.CharValue.v,dcode); 
    Cons.SimpleAssignment(dstAcode,dcode);
 ;
      RETURN;

  END;
  END;
  END;
  IF (dstType^.Kind = OB.CharTypeRepr) THEN
  IF (srcType^.Kind = OB.CharStringTypeRepr) THEN
  IF (srcVal^.Kind = OB.CharValue) THEN
(* line 520 "CODE.tmp" *)
(* line 521 "CODE.tmp" *)
       O.StrLn( "CodeAssign.Char_CharString" ) ; 
    Cons.CharConst(srcVal^.CharValue.v,dcode); 
    Cons.SimpleAssignment(dstAcode,dcode);
 ;
      RETURN;

  END;
  END;
(* line 546 "CODE.tmp" *)
(* line 556 "CODE.tmp" *)
       O.StrLn( "CodeAssign.StandardType" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.SimpleAssignment(dstAcode,dcode);
 ;
      RETURN;

  END;
  IF (dstType^.Kind = OB.ArrayTypeRepr) THEN
  IF (srcType^.Kind = OB.CharStringTypeRepr) THEN
  IF (srcVal^.Kind = OB.CharValue) THEN
(* line 526 "CODE.tmp" *)
(* line 526 "CODE.tmp" *)
       O.StrLn( "CodeAssign.ArrayOfChar_CharString" ) ; 
    IF srcVal^.CharValue.v=0X THEN 
       Cons.CharConst(srcVal^.CharValue.v,dcode); 
    ELSE 
       Cons.IntegerConst(ORD(srcVal^.CharValue.v) MOD 256,dcode); 
    END;
    Cons.SimpleAssignment(dstAcode,dcode);
 ;
      RETURN;

  END;
  END;
  IF (srcType^.Kind = OB.StringTypeRepr) THEN
  IF (srcVal^.Kind = OB.StringValue) THEN
(* line 535 "CODE.tmp" *)
(* line 535 "CODE.tmp" *)
       O.StrLn( "CodeAssign._String" ) ; 
    CASE OT.LengthOfoSTRING(srcVal^.StringValue.v) OF
    |0:  Cons.CharConst(0X,dcode); Cons.SimpleAssignment(dstAcode,dcode);
    |1:  OT.SplitoSTRING(srcVal^.StringValue.v,li); Cons.IntegerConst(li,dcode); Cons.SimpleAssignment(dstAcode,dcode);
    |2:  OT.SplitoSTRING(srcVal^.StringValue.v,li); Cons.MemSet3(li,dstAcode); 
    |3:  OT.SplitoSTRING(srcVal^.StringValue.v,li); Cons.LongintConst(li,dcode); Cons.SimpleAssignment(dstAcode,dcode);
    ELSE CodeLongstringAssignment(srcVal,expr,dstAcode); 
    END;
 ;
      RETURN;

  END;
  END;
  END;

  CASE dstType^.Kind OF
  | OB.ByteTypeRepr:
(* line 546 "CODE.tmp" *)
(* line 556 "CODE.tmp" *)
       O.StrLn( "CodeAssign.StandardType" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.SimpleAssignment(dstAcode,dcode);
 ;
      RETURN;

  | OB.PtrTypeRepr:
(* line 546 "CODE.tmp" *)
(* line 556 "CODE.tmp" *)
       O.StrLn( "CodeAssign.StandardType" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.SimpleAssignment(dstAcode,dcode);
 ;
      RETURN;

  | OB.BooleanTypeRepr:
(* line 546 "CODE.tmp" *)
(* line 556 "CODE.tmp" *)
       O.StrLn( "CodeAssign.StandardType" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.SimpleAssignment(dstAcode,dcode);
 ;
      RETURN;

  | OB.SetTypeRepr:
(* line 546 "CODE.tmp" *)
(* line 556 "CODE.tmp" *)
       O.StrLn( "CodeAssign.StandardType" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.SimpleAssignment(dstAcode,dcode);
 ;
      RETURN;

  | OB.ShortintTypeRepr:
(* line 546 "CODE.tmp" *)
(* line 556 "CODE.tmp" *)
       O.StrLn( "CodeAssign.StandardType" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.SimpleAssignment(dstAcode,dcode);
 ;
      RETURN;

  | OB.IntegerTypeRepr:
(* line 546 "CODE.tmp" *)
(* line 556 "CODE.tmp" *)
       O.StrLn( "CodeAssign.StandardType" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.SimpleAssignment(dstAcode,dcode);
 ;
      RETURN;

  | OB.LongintTypeRepr:
(* line 546 "CODE.tmp" *)
(* line 556 "CODE.tmp" *)
       O.StrLn( "CodeAssign.StandardType" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.SimpleAssignment(dstAcode,dcode);
 ;
      RETURN;

  | OB.PointerTypeRepr:
(* line 546 "CODE.tmp" *)
(* line 556 "CODE.tmp" *)
       O.StrLn( "CodeAssign.StandardType" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.SimpleAssignment(dstAcode,dcode);
 ;
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
(* line 546 "CODE.tmp" *)
(* line 556 "CODE.tmp" *)
       O.StrLn( "CodeAssign.StandardType" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.SimpleAssignment(dstAcode,dcode);
 ;
      RETURN;

  | OB.TypeRepr
  , OB.ForwardTypeRepr
  , OB.NilTypeRepr
  , OB.CharTypeRepr
  , OB.CharStringTypeRepr
  , OB.StringTypeRepr
  , OB.IntTypeRepr
  , OB.FloatTypeRepr
  , OB.RealTypeRepr
  , OB.LongrealTypeRepr
  , OB.ArrayTypeRepr
  , OB.RecordTypeRepr:
  IF (expr^.Kind = Tree.DesignExpr) THEN
(* line 562 "CODE.tmp" *)
(* line 562 "CODE.tmp" *)
       O.StrLn( "CodeAssign.StructuredType" ) ; 
    CodeLDesignator(expr^.DesignExpr.Designator,srcAcode); 
    Cons.MemCopy(dstType^.TypeRepr.size,(*isStringCopy:=*)FALSE,dstAcode,srcAcode); 
 ;
      RETURN;

  END;
  ELSE END;

(* line 568 "CODE.tmp" *)
(* line 568 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeAssign: failed'); ;
      RETURN;

 END CodeAssign;

PROCEDURE CodeLongstringAssignment (val: OB.tOB; yyP11: Tree.tTree; dstAcode: ACode);
(* line 575 "CODE.tmp" *)
 VAR srcAcode:ACode; lab:OB.tLabel; 
 BEGIN
  IF val = OB.NoOB THEN RETURN; END;
  IF yyP11 = Tree.NoTree THEN RETURN; END;
  IF (yyP11^.Kind = Tree.DesignExpr) THEN
(* line 577 "CODE.tmp" *)
(* line 577 "CODE.tmp" *)
       O.StrLn( "CodeLongstringAssignment.NamedStringConst" ) ; 
    CodeLDesignator(yyP11^.DesignExpr.Designator,srcAcode); 
    Cons.MemCopy(1+OT.LengthOfoSTRING(val^.StringValue.v),(*isStringCopy:=*)TRUE,dstAcode,srcAcode); 
 ;
      RETURN;

  END;
(* line 582 "CODE.tmp" *)
(* line 582 "CODE.tmp" *)
       O.StrLn( "CodeLongstringAssignment.UnnamedStringConst" ) ; 
    Cons.GlobalVariable(V.LabelOfMemValue(val),0,Idents.NoIdent,srcAcode); 
    Cons.MemCopy(1+OT.LengthOfoSTRING(val^.StringValue.v),(*isStringCopy:=*)TRUE,dstAcode,srcAcode); 
 ;
      RETURN;

 END CodeLongstringAssignment;

PROCEDURE CodeProcedureCall (designator: Tree.tTree);
(* line 592 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; 
 BEGIN
  IF designator = Tree.NoTree THEN RETURN; END;
  IF (designator^.Designator.Designations^.Kind = Tree.Importing) THEN
  IF Tree.IsType (designator^.Designator.Designations^.Importing.Nextion, Tree.PredeclArgumenting) THEN
(* line 594 "CODE.tmp" *)
(* line 595 "CODE.tmp" *)
       O.StrLn( "CodeProcedureCall.Predecls" ) ; 
    CodePredeclProcs(designator^.Designator.Designations^.Importing.Nextion); 
 ;
      RETURN;

  END;
  END;
  IF Tree.IsType (designator^.Designator.Designations, Tree.PredeclArgumenting) THEN
(* line 594 "CODE.tmp" *)
(* line 595 "CODE.tmp" *)
       O.StrLn( "CodeProcedureCall.Predecls" ) ; 
    CodePredeclProcs(designator^.Designator.Designations); 
 ;
      RETURN;

  END;
(* line 599 "CODE.tmp" *)
(* line 599 "CODE.tmp" *)
       O.StrLn( "CodeProcedureCall.UserProc" ) ; 
    CodeLDesignator(designator,acode);
    Cons.NoFuncResult(acode); 
 ;
      RETURN;

 END CodeProcedureCall;

PROCEDURE CodeFunctionReturn (srcType: OB.tOB; srcVal: OB.tOB; expr: Tree.tTree; coercion: OB.tOB);
(* line 608 "CODE.tmp" *)
 VAR dcode:DCode; 
 BEGIN
  IF srcType = OB.NoOB THEN RETURN; END;
  IF srcVal = OB.NoOB THEN RETURN; END;
  IF expr = Tree.NoTree THEN RETURN; END;
  IF coercion = OB.NoOB THEN RETURN; END;
  IF (srcType^.Kind = OB.RealTypeRepr) THEN
(* line 610 "CODE.tmp" *)
(* line 611 "CODE.tmp" *)
      
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.FloatFuncReturn(dcode); 
 ;
      RETURN;

  END;
  IF (srcType^.Kind = OB.LongrealTypeRepr) THEN
(* line 610 "CODE.tmp" *)
(* line 611 "CODE.tmp" *)
      
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.FloatFuncReturn(dcode); 
 ;
      RETURN;

  END;
(* line 616 "CODE.tmp" *)
(* line 616 "CODE.tmp" *)
      
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.FuncReturn(dcode); 
 ;
      RETURN;

 END CodeFunctionReturn;

PROCEDURE CodeArguments (yyP13: OB.tOB; yyP12: Tree.tTree; argcodeIn: ArgCode; VAR yyP14: ArgCode);
(* line 625 "CODE.tmp" *)
 VAR argcode:ArgCode; 
 BEGIN
  IF yyP13 = OB.NoOB THEN RETURN; END;
  IF yyP12 = Tree.NoTree THEN RETURN; END;
  IF (yyP13^.Kind = OB.Signature) THEN
  IF (yyP12^.Kind = Tree.ExprList) THEN
(* line 627 "CODE.tmp" *)
(* line 628 "CODE.tmp" *)
       O.StrLn( "CodeArguments" ) ; 
    CodeArguments(yyP13^.Signature.next,yyP12^.ExprList.Next,argcodeIn,argcode); 

    IF yyP13^.Signature.VarEntry^.VarEntry.parMode=OB.REFPAR THEN 
       CodeVarParam(yyP13^.Signature.VarEntry^.VarEntry.typeRepr,yyP12^.ExprList.Expr^.Exprs.TypeReprOut,yyP12^.ExprList.Expr^.Exprs.ValueReprOut,yyP12^.ExprList.Expr,argcode,argcode); 
    ELSIF yyP13^.Signature.VarEntry^.VarEntry.refMode=OB.REFPAR THEN   
       CodeRefdValParam(yyP13^.Signature.VarEntry^.VarEntry.typeRepr,yyP12^.ExprList.Expr^.Exprs.TypeReprOut,yyP12^.ExprList.Expr^.Exprs.ValueReprOut,yyP12^.ExprList.Expr,argcode,argcode); 
    ELSE 
       CodeValParam(yyP13^.Signature.VarEntry^.VarEntry.typeRepr,yyP12^.ExprList.Expr^.Exprs.TypeReprOut,yyP12^.ExprList.Expr^.Exprs.ValueReprOut,yyP12^.ExprList.Expr,yyP12^.ExprList.Coerce,argcode,argcode); 
    END;
 ;
      yyP14 := argcode;
      RETURN;

  END;
  END;
  IF (yyP13^.Kind = OB.mtSignature) THEN
  IF (yyP12^.Kind = Tree.mtExprList) THEN
(* line 640 "CODE.tmp" *)
      yyP14 := argcodeIn;
      RETURN;

  END;
  END;
(* line 642 "CODE.tmp" *)
(* line 642 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeArguments: failed'); ;
      yyP14 := NIL;
      RETURN;

 END CodeArguments;

PROCEDURE CodeVarParam (dstType: OB.tOB; srcType: OB.tOB; srcVal: OB.tOB; expr: Tree.tTree; argcodeIn: ArgCode; VAR yyP15: ArgCode);
(* line 648 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; argcode:ArgCode; 
 BEGIN
  IF dstType = OB.NoOB THEN RETURN; END;
  IF srcType = OB.NoOB THEN RETURN; END;
  IF srcVal = OB.NoOB THEN RETURN; END;
  IF expr = Tree.NoTree THEN RETURN; END;
  IF (dstType^.Kind = OB.RecordTypeRepr) THEN
  IF (expr^.Kind = Tree.DesignExpr) THEN
(* line 650 "CODE.tmp" *)
(* line 650 "CODE.tmp" *)
       O.StrLn( "CodeVarParam.Record" ) ; 
    CodeRecordVarParam(expr^.DesignExpr.Entry,srcType,expr^.DesignExpr.Designator,argcodeIn,argcode);
 ;
      yyP15 := argcode;
      RETURN;

  END;
  END;
  IF (dstType^.Kind = OB.ArrayTypeRepr) THEN
  IF (expr^.Kind = Tree.DesignExpr) THEN
(* line 654 "CODE.tmp" *)
   LOOP
(* line 654 "CODE.tmp" *)
      IF ~((dstType^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
(* line 654 "CODE.tmp" *)
       O.StrLn( "CodeVarParam.OpenArray" ) ; 
    CodeOpenArrayParam(expr^.DesignExpr.Entry,dstType,srcType,srcVal,expr^.DesignExpr.Designator,argcodeIn,argcode); 
 ;
      yyP15 := argcode;
      RETURN;
   END;

  END;
  END;
  IF (expr^.Kind = Tree.DesignExpr) THEN
(* line 658 "CODE.tmp" *)
(* line 658 "CODE.tmp" *)
       O.StrLn( "CodeVarParam.Default" ) ; 
    CodeLDesignator(expr^.DesignExpr.Designator,acode); 
    Cons.AddressOf(acode,dcode); 
    Cons.Param(argcodeIn,dcode,argcode); 
 ;
      yyP15 := argcode;
      RETURN;

  END;
(* line 664 "CODE.tmp" *)
(* line 664 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeVarParam: failed'); ;
      yyP15 := NIL;
      RETURN;

 END CodeVarParam;

PROCEDURE CodeOpenArrayParam (actEntry: OB.tOB; frmType: OB.tOB; actType: OB.tOB; actVal: OB.tOB; designator: Tree.tTree; argcodeIn: ArgCode; VAR yyP16: ArgCode);
(* line 671 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; argcode:ArgCode; 
           lastLenOfs,actTotalNofOpenLens,frmNofOpenLens,actNofOpenLens,actNofElems:LONGINT; 
 BEGIN
  IF actEntry = OB.NoOB THEN RETURN; END;
  IF frmType = OB.NoOB THEN RETURN; END;
  IF actType = OB.NoOB THEN RETURN; END;
  IF actVal = OB.NoOB THEN RETURN; END;
  IF designator = Tree.NoTree THEN RETURN; END;
  IF (actEntry^.Kind = OB.VarEntry) THEN
  IF (frmType^.Kind = OB.ArrayTypeRepr) THEN
  IF (frmType^.ArrayTypeRepr.elemTypeRepr^.Kind = OB.ByteTypeRepr) THEN
  IF OB.IsType (actType, OB.TypeRepr) THEN
(* line 675 "CODE.tmp" *)
   LOOP
(* line 680 "CODE.tmp" *)
      IF ~((frmType^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
(* line 680 "CODE.tmp" *)
       O.StrLn( "CodeOpenArrayParam.ArrayOfByte" ) ; 
    CodeOpenArrayOfByteParam(actType,T.ElemTypeOfArrayType(actEntry^.VarEntry.typeRepr),actEntry,designator,argcodeIn,argcode); 
 ;
      yyP16 := argcode;
      RETURN;
   END;

  END;
  END;
  END;
  IF (actType^.Kind = OB.ArrayTypeRepr) THEN
(* line 685 "CODE.tmp" *)
   LOOP
(* line 690 "CODE.tmp" *)
      IF ~((T . IsPointerOrArrayOfPointerType (actEntry^.VarEntry.typeRepr))) THEN EXIT; END;
(* line 690 "CODE.tmp" *)
       O.StrLn( "CodeOpenArrayParam.Ptr" ) ; 

    CodeImplicitConstLens(frmType,actType,argcodeIn,argcode,frmNofOpenLens,actNofOpenLens,actNofElems); 

(*** ! 0 <= actNofOpenLens <= frmNofOpenLens ***)

    IF actNofOpenLens=0 THEN 
       IF frmNofOpenLens>1 THEN 
          Cons.LongintConst(actNofElems,dcode); 
          Cons.Param(argcode,dcode,argcode); 
       END;

       CodeLDesignator(designator,acode); 
       Cons.AddressOf(acode,dcode); 
       Cons.Param(argcode,dcode,argcode); 
    ELSE 
       CodeLDesignator(designator,acode); 
       Cons.AddressOf(acode,dcode); 

       actTotalNofOpenLens:=T.OpenDimOfArrayType(T.BaseTypeOfPointerType(actEntry^.VarEntry.typeRepr)); 

(*** ! 0 < actNofOpenLens <= frmNofOpenLens AND actNofOpenLens <= actTotalNofOpenLens ***)

       IF frmNofOpenLens=1 THEN

(*** ! actNofOpenLens = 1 AND frmNofOpenLens = 1 ***)

          Cons.Param_LensAndAddr(1,argcode,dcode,argcode); 
       ELSE

(*** ! 0 < actNofOpenLens <= frmNofOpenLens AND frmNofOpenLens > 1 AND actNofOpenLens <= actTotalNofOpenLens ***)

          IF (actNofOpenLens=frmNofOpenLens) & (actNofOpenLens=actTotalNofOpenLens) THEN 

(*** ! actNofOpenLens > 1 AND frmNofOpenLens > 1 AND actTotalNofOpenLens > 1 ***)

             Cons.Param_LensAndAddr(actNofOpenLens+1,argcode,dcode,argcode); 
          ELSE 
             Cons.Param_LensAndNewNofElemsAndAddr(actNofOpenLens,actNofElems,argcode,dcode,argcode); 
          END;
       END;
    END;
 ;
      yyP16 := argcode;
      RETURN;
   END;

(* line 735 "CODE.tmp" *)
(* line 740 "CODE.tmp" *)
       O.StrLn( "CodeOpenArrayParam.VarPar" ) ; 

    CodeImplicitConstLens(frmType,actType,argcodeIn,argcode,frmNofOpenLens,actNofOpenLens,actNofElems); 

    IF actNofOpenLens=0 THEN 
       IF frmNofOpenLens>1 THEN 
          Cons.LongintConst(actNofElems,dcode); 
          Cons.Param(argcode,dcode,argcode); 
       END;
    ELSE 
       IF actEntry^.VarEntry.level=designator^.Designator.LevelIn THEN
          Cons.LocalVariable(actEntry^.VarEntry.address,Idents.NoIdent,acode); 
       ELSE
          Cons.LocalVariable(-4*(1+actEntry^.VarEntry.level-OB.MODULELEVEL),Idents.NoIdent,acode); 
          Cons.ContentOf(l,acode,dcode); 
          Cons.PointerFrom(dcode,acode); 
          Cons.Selector(actEntry^.VarEntry.address,acode,acode); 
       END;
       Cons.AddressOf(acode,dcode); 
   
       actTotalNofOpenLens:=T.OpenDimOfArrayType(actEntry^.VarEntry.typeRepr); 
       IF actTotalNofOpenLens>1 THEN lastLenOfs:=4*actTotalNofOpenLens+4; ELSE lastLenOfs:=4; END;

       IF frmNofOpenLens=1 THEN 
          Cons.Param_Lens(1,lastLenOfs,argcode,dcode,argcode); 
       ELSE 
          IF (actNofOpenLens=frmNofOpenLens) & (actNofOpenLens=actTotalNofOpenLens) THEN 
             Cons.Param_Lens(actNofOpenLens+1,lastLenOfs,argcode,dcode,argcode); 
          ELSE 
             Cons.Param_LensAndNewNofElems(actNofOpenLens,lastLenOfs,actNofElems,argcodeIn,dcode,argcode); 
          END;
       END;
    END;
    
    CodeLDesignator(designator,acode); 
    Cons.AddressOf(acode,dcode); 
    Cons.Param(argcode,dcode,argcode); 
 ;
      yyP16 := argcode;
      RETURN;

  END;
  END;
(* line 780 "CODE.tmp" *)
(* line 780 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeOpenArrayParam: failed'); ;
      yyP16 := NIL;
      RETURN;

 END CodeOpenArrayParam;

PROCEDURE CodeOpenArrayOfByteParam (actType: OB.tOB; flattenedVarType: OB.tOB; actEntry: OB.tOB; designator: Tree.tTree; argcodeIn: ArgCode; VAR yyP17: ArgCode);
(* line 787 "CODE.tmp" *)
 VAR objAcode,acode:ACode; dcode,sizeDcode:DCode; argcode:ArgCode; idData:tImplicitDesignationData; sz:LONGINT; 
 BEGIN
  IF actType = OB.NoOB THEN RETURN; END;
  IF flattenedVarType = OB.NoOB THEN RETURN; END;
  IF actEntry = OB.NoOB THEN RETURN; END;
  IF designator = Tree.NoTree THEN RETURN; END;
  IF (actType^.Kind = OB.RecordTypeRepr) THEN
  IF (actEntry^.Kind = OB.VarEntry) THEN
  IF (actEntry^.VarEntry.typeRepr^.Kind = OB.RecordTypeRepr) THEN
(* line 795 "CODE.tmp" *)
   LOOP
(* line 796 "CODE.tmp" *)
      IF ~((actEntry^.VarEntry.parMode = OB . REFPAR)) THEN EXIT; END;
(* line 796 "CODE.tmp" *)
       O.StrLn( "CodeOpenArrayOfByteParam.RecordVarPar" ) ; 
    CodeImplicitLDesignator(designator,idData,objAcode); 

    Cons.Selector(idData.ofsOfObjHeader,idData.acodeToObjHeader,acode); 
    Cons.ContentOf(l,acode,dcode); 
    Cons.PointerFrom(dcode,acode); 
    Cons.Selector(-8,acode,acode); 
    Cons.ContentOf(l,acode,dcode); 
    Cons.Param(argcodeIn,dcode,argcode); 
    
    Cons.AddressOf(objAcode,dcode); 
    Cons.Param(argcode,dcode,argcode); 
 ;
      yyP17 := argcode;
      RETURN;
   END;

  END;
  END;
  IF (flattenedVarType^.Kind = OB.PointerTypeRepr) THEN
(* line 811 "CODE.tmp" *)
(* line 811 "CODE.tmp" *)
       O.StrLn( "CodeOpenArrayOfByteParam.PointerToRecord" ) ; 
    CodeLDesignator(designator,acode); 
    Cons.AddressOf(acode,dcode); 
    Cons.Param_RecordSizeAndAddr(argcodeIn,dcode,argcode); 
 ;
      yyP17 := argcode;
      RETURN;

  END;
  END;
  IF (actType^.Kind = OB.ArrayTypeRepr) THEN
  IF (actEntry^.Kind = OB.VarEntry) THEN
(* line 818 "CODE.tmp" *)
   LOOP
(* line 819 "CODE.tmp" *)
      IF ~((actEntry^.VarEntry.isParam & (actType^.ArrayTypeRepr.len = OB . OPENARRAYLEN))) THEN EXIT; END;
(* line 819 "CODE.tmp" *)
       O.StrLn( "CodeOpenArrayOfByteParam.OpenArrayVarPar" ) ; 
    CodeImplicitLDesignator(designator,idData,objAcode); 
    IF actType=actEntry^.VarEntry.typeRepr THEN (* the complete array gets passed... *)
   
       Cons.Selector(4+idData.ofsOfObjHeader,idData.acodeToObjHeader,acode); 
       Cons.ContentOf(l,acode,dcode); 
   
       sz:=T.ElemSizeOfOpenArrayType(actType); 
       IF sz#1 THEN 
          Cons.LongintConst(sz,sizeDcode); 
          Cons.SymDyOper(imul,sizeDcode,dcode,dcode); 
       END;
       Cons.Param(argcodeIn,dcode,argcode); 
       
       Cons.AddressOf(objAcode,dcode); 
       Cons.Param(argcode,dcode,argcode); 
    ELSE 
       Cons.Param_PartialOArrSizeAndAddrOfPar(argcodeIn,idData.codeToOpenIndexedElem,idData.codeToObjBaseReg,argcode); 
    END;
 ;
      yyP17 := argcode;
      RETURN;
   END;

  END;
  IF (flattenedVarType^.Kind = OB.PointerTypeRepr) THEN
  IF (flattenedVarType^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
(* line 841 "CODE.tmp" *)
   LOOP
(* line 842 "CODE.tmp" *)
      IF ~((actType^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
(* line 842 "CODE.tmp" *)
       O.StrLn( "CodeOpenArrayOfByteParam.CompleteOpenArrayPointer" ) ; 
    CodeImplicitLDesignator(designator,idData,objAcode); 
    IF actType=flattenedVarType^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr THEN (* the complete array gets passed... *)
       Cons.AddressOf(idData.acodeToObjHeader,dcode); 
       Cons.Param_OArrSizeAndAddr(ADR.ArrayOfs(actType),T.ElemSizeOfOpenArrayType(actType),argcodeIn,dcode,argcode); 
    ELSE 
       Cons.Param_PartialOArrSizeAndAddrOfPtr(idData.ofsOfObject,argcodeIn,idData.codeToOpenIndexedElem,argcode); 
    END;
 ;
      yyP17 := argcode;
      RETURN;
   END;

  END;
  END;
  END;
  IF OB.IsType (actType, OB.TypeRepr) THEN
(* line 852 "CODE.tmp" *)
(* line 852 "CODE.tmp" *)
       O.StrLn( "CodeOpenArrayOfByteParam.Default" ) ; 
    Cons.LongintConst(actType^.TypeRepr.size,dcode); 
    Cons.Param(argcodeIn,dcode,argcode); 
    
    CodeLDesignator(designator,acode); 
    Cons.AddressOf(acode,dcode); 
    Cons.Param(argcode,dcode,argcode); 
 ;
      yyP17 := argcode;
      RETURN;

  END;
 END CodeOpenArrayOfByteParam;

PROCEDURE CodeImplicitConstLens (frmType: OB.tOB; actType: OB.tOB; argcodeIn: ArgCode; VAR yyP18: ArgCode; VAR TotalNofOpenLens: LONGINT; VAR NofRemainingOpenLens: LONGINT; VAR BaseNofElems: LONGINT);
(* line 866 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; argcode:ArgCode; frmNofOpenLens,actNofOpenLens,actNofElems:LONGINT; 
 BEGIN
  IF frmType = OB.NoOB THEN RETURN; END;
  IF actType = OB.NoOB THEN RETURN; END;
  IF (frmType^.Kind = OB.ArrayTypeRepr) THEN
  IF (actType^.Kind = OB.ArrayTypeRepr) THEN
(* line 868 "CODE.tmp" *)
   LOOP
(* line 870 "CODE.tmp" *)
      IF ~((frmType^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
(* line 870 "CODE.tmp" *)
       O.StrLn( "CodeImplicitConstLens" ) ; 
    CodeImplicitConstLens(frmType^.ArrayTypeRepr.elemTypeRepr,actType^.ArrayTypeRepr.elemTypeRepr,argcodeIn,argcode,frmNofOpenLens,actNofOpenLens,actNofElems); 
    
    IF actType^.ArrayTypeRepr.len=OB.OPENARRAYLEN THEN 
       INC(actNofOpenLens); 
    ELSE 	 
       Cons.LongintConst(actType^.ArrayTypeRepr.len,dcode); 
       Cons.Param(argcode,dcode,argcode); 
       actNofElems:=actType^.ArrayTypeRepr.len*actNofElems; 
    END;
    
    INC(frmNofOpenLens); 
 ;
      yyP18 := argcode;
      TotalNofOpenLens := frmNofOpenLens;
      NofRemainingOpenLens := actNofOpenLens;
      BaseNofElems := actNofElems;
      RETURN;
   END;

  END;
  END;
(* line 884 "CODE.tmp" *)
      yyP18 := argcodeIn;
      TotalNofOpenLens := 0;
      NofRemainingOpenLens := 0;
      BaseNofElems := 1;
      RETURN;

 END CodeImplicitConstLens;

PROCEDURE CodeRecordVarParam (yyP19: OB.tOB; srcType: OB.tOB; designator: Tree.tTree; argcodeIn: ArgCode; VAR yyP20: ArgCode);
(* line 890 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; argcode:ArgCode; 
 BEGIN
  IF yyP19 = OB.NoOB THEN RETURN; END;
  IF srcType = OB.NoOB THEN RETURN; END;
  IF designator = Tree.NoTree THEN RETURN; END;
  IF (yyP19^.Kind = OB.VarEntry) THEN
(* line 892 "CODE.tmp" *)
   LOOP
(* line 892 "CODE.tmp" *)
      IF ~((T . IsPointerOrArrayOfPointerType (yyP19^.VarEntry.typeRepr))) THEN EXIT; END;
(* line 892 "CODE.tmp" *)
       O.StrLn( "CodeRecordVarParam.Ptr" ) ; 
    CodeLDesignator(designator,acode); 
    Cons.AddressOf(acode,dcode); 
    Cons.Param_AddrAndTag(argcodeIn,dcode,argcode); 
 ;
      yyP20 := argcode;
      RETURN;
   END;

(* line 898 "CODE.tmp" *)
   LOOP
(* line 898 "CODE.tmp" *)
      IF ~((yyP19^.VarEntry.parMode = OB . REFPAR)) THEN EXIT; END;
(* line 898 "CODE.tmp" *)
       O.StrLn( "CodeRecordVarParam.VarPar" ) ; 
    IF yyP19^.VarEntry.level=designator^.Designator.LevelIn THEN
       Cons.LocalVariable(yyP19^.VarEntry.address,yyP19^.VarEntry.ident,acode); 
       Cons.ContentOf(l,acode,dcode); 
       Cons.Param(argcodeIn,dcode,argcode); 	   
       
       Cons.LocalVariable(yyP19^.VarEntry.address-4,Idents.NoIdent,acode); 
       Cons.ContentOf(l,acode,dcode); 
       Cons.Param(argcode,dcode,argcode); 
    ELSE
       Cons.LocalVariable(-4*(1+yyP19^.VarEntry.level-OB.MODULELEVEL),Idents.NoIdent,acode); 
       Cons.ContentOf(l,acode,dcode); 
       Cons.PointerFrom(dcode,acode); 
       Cons.Selector(yyP19^.VarEntry.address,acode,acode); 
       Cons.ContentOf(l,acode,dcode); 
       Cons.Param(argcodeIn,dcode,argcode); 

       Cons.LocalVariable(-4*(1+yyP19^.VarEntry.level-OB.MODULELEVEL),Idents.NoIdent,acode); 
       Cons.ContentOf(l,acode,dcode); 
       Cons.PointerFrom(dcode,acode); 
       Cons.Selector(yyP19^.VarEntry.address-4,acode,acode); 
       Cons.ContentOf(l,acode,dcode); 
       Cons.Param(argcode,dcode,argcode); 
    END;
 ;
      yyP20 := argcode;
      RETURN;
   END;

  END;
(* line 924 "CODE.tmp" *)
(* line 924 "CODE.tmp" *)
       O.StrLn( "CodeRecordVarParam.ConstType" ) ; 
    CodeLDesignator(designator,acode); 
    Cons.AddressOf(acode,dcode); 
    Cons.Param(argcodeIn,dcode,argcode); 
    
    Cons.GlobalVariable(LAB.AppS(T.LabelOfTypeRepr(srcType),'$D'),0,Idents.NoIdent,acode); 
    Cons.AddressOf(acode,dcode); 
    Cons.Param(argcode,dcode,argcode); 
 ;
      yyP20 := argcode;
      RETURN;

 END CodeRecordVarParam;

PROCEDURE CodeRefdValParam (dstType: OB.tOB; srcType: OB.tOB; srcVal: OB.tOB; expr: Tree.tTree; argcodeIn: ArgCode; VAR yyP21: ArgCode);
(* line 939 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; argcode:ArgCode; ar:ARRAY 3 OF CHAR; st:Strings.tString; os:OT.oSTRING; 
 BEGIN
  IF dstType = OB.NoOB THEN RETURN; END;
  IF srcType = OB.NoOB THEN RETURN; END;
  IF srcVal = OB.NoOB THEN RETURN; END;
  IF expr = Tree.NoTree THEN RETURN; END;
  IF (dstType^.Kind = OB.ArrayTypeRepr) THEN
  IF (dstType^.ArrayTypeRepr.elemTypeRepr^.Kind = OB.CharTypeRepr) THEN
  IF OB.IsType (srcVal, OB.ValueRepr) THEN
(* line 941 "CODE.tmp" *)
   LOOP
(* line 941 "CODE.tmp" *)
      IF ~((dstType^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
(* line 941 "CODE.tmp" *)
       O.StrLn( "CodeRefdValParam.String" ) ; 
    CodeOpenArrayStringParam(srcType,srcVal,argcodeIn,argcode); 
 ;
      yyP21 := argcode;
      RETURN;
   END;

  END;
  END;
  IF (expr^.Kind = Tree.DesignExpr) THEN
(* line 945 "CODE.tmp" *)
   LOOP
(* line 945 "CODE.tmp" *)
      IF ~((dstType^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
(* line 945 "CODE.tmp" *)
       O.StrLn( "CodeRefdValParam.OpenArray" ) ; 
    CodeOpenArrayParam(expr^.DesignExpr.Entry,dstType,srcType,srcVal,expr^.DesignExpr.Designator,argcodeIn,argcode); 
 ;
      yyP21 := argcode;
      RETURN;
   END;

  END;
  END;
  IF (srcType^.Kind = OB.CharTypeRepr) THEN
  IF (srcVal^.Kind = OB.CharValue) THEN
(* line 949 "CODE.tmp" *)
(* line 950 "CODE.tmp" *)
       O.StrLn( "CodeRefdValParam.Char" ) ; 
    ar[0]:=OT.CHARofoCHAR(srcVal^.CharValue.v); ar[1]:=0X; 
    Strings.ArrayToString(ar,st); 
    OT.STR2oSTRING(st,os); 
    
    Cons.GlobalVariable(CV.String(os),0,Idents.NoIdent,acode); 
    Cons.AddressOf(acode,dcode); 
    Cons.Param(argcodeIn,dcode,argcode); 
 ;
      yyP21 := argcode;
      RETURN;

  END;
  END;
  IF (srcType^.Kind = OB.CharStringTypeRepr) THEN
  IF (srcVal^.Kind = OB.CharValue) THEN
(* line 949 "CODE.tmp" *)
(* line 950 "CODE.tmp" *)
       O.StrLn( "CodeRefdValParam.Char" ) ; 
    ar[0]:=OT.CHARofoCHAR(srcVal^.CharValue.v); ar[1]:=0X; 
    Strings.ArrayToString(ar,st); 
    OT.STR2oSTRING(st,os); 
    
    Cons.GlobalVariable(CV.String(os),0,Idents.NoIdent,acode); 
    Cons.AddressOf(acode,dcode); 
    Cons.Param(argcodeIn,dcode,argcode); 
 ;
      yyP21 := argcode;
      RETURN;

  END;
  END;
  IF (srcType^.Kind = OB.StringTypeRepr) THEN
  IF (srcVal^.Kind = OB.StringValue) THEN
(* line 960 "CODE.tmp" *)
(* line 960 "CODE.tmp" *)
       O.StrLn( "CodeRefdValParam.String" ) ; 
    Cons.GlobalVariable(CV.String(srcVal^.StringValue.v),0,Idents.NoIdent,acode); 
    Cons.AddressOf(acode,dcode); 
    Cons.Param(argcodeIn,dcode,argcode); 
 ;
      yyP21 := argcode;
      RETURN;

  END;
  END;
  IF (expr^.Kind = Tree.DesignExpr) THEN
(* line 966 "CODE.tmp" *)
(* line 966 "CODE.tmp" *)
       O.StrLn( "CodeRefdValParam.Default" ) ; 
    CodeLDesignator(expr^.DesignExpr.Designator,acode); 
    Cons.AddressOf(acode,dcode); 
    Cons.Param(argcodeIn,dcode,argcode); 
 ;
      yyP21 := argcode;
      RETURN;

  END;
(* line 972 "CODE.tmp" *)
(* line 972 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeRefdValParam: failed'); ;
      yyP21 := NIL;
      RETURN;

 END CodeRefdValParam;

PROCEDURE CodeOpenArrayStringParam (srcType: OB.tOB; srcVal: OB.tOB; argcodeIn: ArgCode; VAR yyP22: ArgCode);
(* line 978 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; argcode:ArgCode; str:OT.oSTRING; 
 BEGIN
  IF srcType = OB.NoOB THEN RETURN; END;
  IF srcVal = OB.NoOB THEN RETURN; END;
  IF (srcType^.Kind = OB.CharStringTypeRepr) THEN
  IF (srcVal^.Kind = OB.CharValue) THEN
(* line 980 "CODE.tmp" *)
(* line 980 "CODE.tmp" *)
       O.StrLn( "CodeOpenArrayStringParam.Char" ) ; 
    OT.oCHAR2oSTRING(srcVal^.CharValue.v,str); 

    Cons.LongintConst(1+SYSTEM.VAL(SHORTINT,srcVal^.CharValue.v#0X),dcode); 
    Cons.Param(argcodeIn,dcode,argcode);

    Cons.GlobalVariable(CV.String(str),0,Idents.NoIdent,acode); 
    Cons.AddressOf(acode,dcode);
    Cons.Param(argcode,dcode,argcode);
 ;
      yyP22 := argcode;
      RETURN;

  END;
  END;
  IF (srcType^.Kind = OB.StringTypeRepr) THEN
  IF (srcVal^.Kind = OB.StringValue) THEN
(* line 991 "CODE.tmp" *)
(* line 991 "CODE.tmp" *)
       O.StrLn( "CodeOpenArrayStringParam.String" ) ; 
    Cons.LongintConst(1+OT.LengthOfoSTRING(srcVal^.StringValue.v),dcode); 
    Cons.Param(argcodeIn,dcode,argcode);

    Cons.GlobalVariable(CV.String(srcVal^.StringValue.v),0,Idents.NoIdent,acode); 
    Cons.AddressOf(acode,dcode);
    Cons.Param(argcode,dcode,argcode);
 ;
      yyP22 := argcode;
      RETURN;

  END;
  END;
(* line 1000 "CODE.tmp" *)
(* line 1000 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeOpenArrayStringParam: failed'); ;
      yyP22 := NIL;
      RETURN;

 END CodeOpenArrayStringParam;

PROCEDURE CodeValParam (dstType: OB.tOB; srcType: OB.tOB; srcVal: OB.tOB; expr: Tree.tTree; coercion: OB.tOB; argcodeIn: ArgCode; VAR yyP23: ArgCode);
(* line 1007 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; argcode:ArgCode; lr:OT.oLONGREAL; li,lo,hi:LONGINT; 
 BEGIN
  IF dstType = OB.NoOB THEN RETURN; END;
  IF srcType = OB.NoOB THEN RETURN; END;
  IF srcVal = OB.NoOB THEN RETURN; END;
  IF expr = Tree.NoTree THEN RETURN; END;
  IF coercion = OB.NoOB THEN RETURN; END;
  IF (dstType^.Kind = OB.RealTypeRepr) THEN
  IF (srcType^.Kind = OB.RealTypeRepr) THEN
  IF (srcVal^.Kind = OB.RealValue) THEN
(* line 1009 "CODE.tmp" *)
(* line 1009 "CODE.tmp" *)
       O.StrLn( "CodeValParam.Real_Real" ) ; 
    Cons.RealConst(srcVal^.RealValue.v,dcode); 
    Cons.Param(argcodeIn,dcode,argcode);
 ;
      yyP23 := argcode;
      RETURN;

  END;
  END;
  END;
  IF (dstType^.Kind = OB.LongrealTypeRepr) THEN
  IF (srcType^.Kind = OB.RealTypeRepr) THEN
  IF (srcVal^.Kind = OB.RealValue) THEN
(* line 1014 "CODE.tmp" *)
(* line 1014 "CODE.tmp" *)
       O.StrLn( "CodeValParam.Longreal_Real" ) ; 
    OT.oREAL2oLONGREAL(srcVal^.RealValue.v,lr); OT.SplitoLONGREAL(lr,lo,hi); 
    Cons.Param8(lo,hi,argcodeIn,argcode);
 ;
      yyP23 := argcode;
      RETURN;

  END;
  END;
  IF (srcType^.Kind = OB.LongrealTypeRepr) THEN
  IF (srcVal^.Kind = OB.LongrealValue) THEN
(* line 1019 "CODE.tmp" *)
(* line 1019 "CODE.tmp" *)
       O.StrLn( "CodeValParam.Longreal_Longreal" ) ; 
    OT.SplitoLONGREAL(srcVal^.LongrealValue.v,lo,hi); 
    Cons.Param8(lo,hi,argcodeIn,argcode);
 ;
      yyP23 := argcode;
      RETURN;

  END;
  END;
  END;
  IF (dstType^.Kind = OB.CharTypeRepr) THEN
  IF (srcType^.Kind = OB.CharStringTypeRepr) THEN
  IF (srcVal^.Kind = OB.CharValue) THEN
(* line 1024 "CODE.tmp" *)
(* line 1024 "CODE.tmp" *)
       O.StrLn( "CodeValParam.Char_Char" ) ; 
    Cons.CharConst(srcVal^.CharValue.v,dcode); 
    Cons.Param(argcodeIn,dcode,argcode);
 ;
      yyP23 := argcode;
      RETURN;

  END;
  END;
  END;
  IF (srcType^.Kind = OB.CharStringTypeRepr) THEN
  IF (srcVal^.Kind = OB.CharValue) THEN
(* line 1029 "CODE.tmp" *)
(* line 1029 "CODE.tmp" *)
       O.StrLn( "CodeValParam.String_Char" ) ; 
    Cons.IntegerConst(ORD(srcVal^.CharValue.v) MOD 256,dcode); 
    Cons.Param(argcodeIn,dcode,argcode);
 ;
      yyP23 := argcode;
      RETURN;

  END;
  END;
  IF (srcType^.Kind = OB.StringTypeRepr) THEN
  IF (srcVal^.Kind = OB.StringValue) THEN
(* line 1034 "CODE.tmp" *)
(* line 1034 "CODE.tmp" *)
       O.StrLn( "CodeValParam.String_String" ) ; 
    CASE OT.LengthOfoSTRING(srcVal^.StringValue.v) OF
    |0:   Cons.CharConst(0X,dcode);
    |1:   OT.SplitoSTRING(srcVal^.StringValue.v,li); Cons.IntegerConst(li,dcode); 
    |2,3: OT.SplitoSTRING(srcVal^.StringValue.v,li); Cons.LongintConst(li,dcode); 
    END;
    Cons.Param(argcodeIn,dcode,argcode);
 ;
      yyP23 := argcode;
      RETURN;

  END;
  END;
  IF OB.IsType (dstType, OB.FloatTypeRepr) THEN
(* line 1043 "CODE.tmp" *)
(* line 1043 "CODE.tmp" *)
       O.StrLn( "CodeValParam.Floats" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.FloatParam(ASM.FloatSizeTab[dstType^.FloatTypeRepr.size],argcodeIn,dcode,argcode);
 ;
      yyP23 := argcode;
      RETURN;

  END;

  CASE srcType^.Kind OF
  | OB.ByteTypeRepr:
(* line 1048 "CODE.tmp" *)
(* line 1058 "CODE.tmp" *)
       O.StrLn( "CodeValParam.StandardType" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.Param(argcodeIn,dcode,argcode);
 ;
      yyP23 := argcode;
      RETURN;

  | OB.PtrTypeRepr:
(* line 1048 "CODE.tmp" *)
(* line 1058 "CODE.tmp" *)
       O.StrLn( "CodeValParam.StandardType" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.Param(argcodeIn,dcode,argcode);
 ;
      yyP23 := argcode;
      RETURN;

  | OB.BooleanTypeRepr:
(* line 1048 "CODE.tmp" *)
(* line 1058 "CODE.tmp" *)
       O.StrLn( "CodeValParam.StandardType" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.Param(argcodeIn,dcode,argcode);
 ;
      yyP23 := argcode;
      RETURN;

  | OB.CharTypeRepr:
(* line 1048 "CODE.tmp" *)
(* line 1058 "CODE.tmp" *)
       O.StrLn( "CodeValParam.StandardType" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.Param(argcodeIn,dcode,argcode);
 ;
      yyP23 := argcode;
      RETURN;

  | OB.SetTypeRepr:
(* line 1048 "CODE.tmp" *)
(* line 1058 "CODE.tmp" *)
       O.StrLn( "CodeValParam.StandardType" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.Param(argcodeIn,dcode,argcode);
 ;
      yyP23 := argcode;
      RETURN;

  | OB.ShortintTypeRepr:
(* line 1048 "CODE.tmp" *)
(* line 1058 "CODE.tmp" *)
       O.StrLn( "CodeValParam.StandardType" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.Param(argcodeIn,dcode,argcode);
 ;
      yyP23 := argcode;
      RETURN;

  | OB.IntegerTypeRepr:
(* line 1048 "CODE.tmp" *)
(* line 1058 "CODE.tmp" *)
       O.StrLn( "CodeValParam.StandardType" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.Param(argcodeIn,dcode,argcode);
 ;
      yyP23 := argcode;
      RETURN;

  | OB.LongintTypeRepr:
(* line 1048 "CODE.tmp" *)
(* line 1058 "CODE.tmp" *)
       O.StrLn( "CodeValParam.StandardType" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.Param(argcodeIn,dcode,argcode);
 ;
      yyP23 := argcode;
      RETURN;

  | OB.NilTypeRepr:
(* line 1048 "CODE.tmp" *)
(* line 1058 "CODE.tmp" *)
       O.StrLn( "CodeValParam.StandardType" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.Param(argcodeIn,dcode,argcode);
 ;
      yyP23 := argcode;
      RETURN;

  | OB.PointerTypeRepr:
(* line 1048 "CODE.tmp" *)
(* line 1058 "CODE.tmp" *)
       O.StrLn( "CodeValParam.StandardType" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.Param(argcodeIn,dcode,argcode);
 ;
      yyP23 := argcode;
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
(* line 1048 "CODE.tmp" *)
(* line 1058 "CODE.tmp" *)
       O.StrLn( "CodeValParam.StandardType" ) ; 
    CodeRExpr(srcType,expr,coercion,dcode); 
    Cons.Param(argcodeIn,dcode,argcode);
 ;
      yyP23 := argcode;
      RETURN;

  ELSE END;

  IF OB.IsType (dstType, OB.TypeRepr) THEN
  IF (expr^.Kind = Tree.DesignExpr) THEN
(* line 1063 "CODE.tmp" *)
   LOOP
(* line 1063 "CODE.tmp" *)
      IF ~((dstType^.TypeRepr.size <= 4)) THEN EXIT; END;
(* line 1063 "CODE.tmp" *)
       O.StrLn( "CodeValParam.SmallStructuredType" ) ; 
    CodeLDesignator(expr^.DesignExpr.Designator,acode); 
    CASE dstType^.TypeRepr.size OF
    |0:  Cons.ContentOf(b,acode,dcode); Cons.Param0(argcodeIn,dcode,argcode); 
    |3:  Cons.ContentOf(l,acode,dcode); Cons.Param(argcodeIn,dcode,argcode); 
    ELSE Cons.ContentOf(ASM.SizeTab[dstType^.TypeRepr.size],acode,dcode); Cons.Param(argcodeIn,dcode,argcode); 
    END;
 ;
      yyP23 := argcode;
      RETURN;
   END;

  END;
  END;
(* line 1072 "CODE.tmp" *)
(* line 1072 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeValParam: failed'); ;
      yyP23 := NIL;
      RETURN;

 END CodeValParam;

PROCEDURE CodeRExpr (type: OB.tOB; expr: Tree.tTree; co: OB.tOB; VAR yyP24: DCode);
(* line 1078 "CODE.tmp" *)
 VAR dcode,dcode1,dcode2:DCode; trueLabel,falseLabel:tLabel; boolcode:BoolCode; 
 BEGIN
  IF type = OB.NoOB THEN RETURN; END;
  IF expr = Tree.NoTree THEN RETURN; END;
  IF co = OB.NoOB THEN RETURN; END;
(* line 1090 "CODE.tmp" *)
   LOOP
(* line 1090 "CODE.tmp" *)
      IF ~((V . IsValidConstValue (expr^.Exprs.ValueReprOut))) THEN EXIT; END;
(* line 1090 "CODE.tmp" *)
       O.StrLn( "CodeRExpr.UnnamedConst" ) ; 
    CodeValue(expr^.Exprs.ValueReprOut,type,co,dcode);
     ; 
 ;
      yyP24 := dcode;
      RETURN;
   END;

  IF (type^.Kind = OB.BooleanTypeRepr) THEN
(* line 1095 "CODE.tmp" *)
(* line 1095 "CODE.tmp" *)
       O.StrLn( "CodeRExpr.BooleanExpr" ) ; 
    CodeBooleanExpr(expr,expr^.Exprs.ValueReprOut,LAB.MT,LAB.New(trueLabel),LAB.New(falseLabel),boolcode); 
    Cons.BoolVal(trueLabel,falseLabel,boolcode,dcode); 
 ;
      yyP24 := dcode;
      RETURN;

  END;
  IF (type^.Kind = OB.SetTypeRepr) THEN
  IF (expr^.Kind = Tree.NegateExpr) THEN
(* line 1100 "CODE.tmp" *)
(* line 1100 "CODE.tmp" *)
       O.StrLn( "CodeRExpr.SetNegate" ) ; 
    CodeRExpr(expr^.NegateExpr.TypeReprOut,expr^.NegateExpr.Exprs,OB.cmtCoercion,dcode);
    Cons.MonOper(not,dcode,dcode); 
     ; 
 ;
      yyP24 := dcode;
      RETURN;

  END;
  END;
  IF (expr^.Kind = Tree.NegateExpr) THEN
(* line 1106 "CODE.tmp" *)
(* line 1106 "CODE.tmp" *)
       O.StrLn( "CodeRExpr.Negate" ) ; 
    CodeRExpr(expr^.NegateExpr.TypeReprOut,expr^.NegateExpr.Exprs,OB.cmtCoercion,dcode);
    Cons.MonOper(neg,dcode,dcode); 
    CodeCoercion(co,dcode,dcode);
     ; 
 ;
      yyP24 := dcode;
      RETURN;

  END;
  IF (expr^.Kind = Tree.IdentityExpr) THEN
(* line 1113 "CODE.tmp" *)
(* line 1113 "CODE.tmp" *)
       O.StrLn( "CodeRExpr.Identity" ) ; 
    CodeRExpr(expr^.IdentityExpr.TypeReprOut,expr^.IdentityExpr.Exprs,OB.cmtCoercion,dcode);
    CodeCoercion(co,dcode,dcode);
     ; 
 ;
      yyP24 := dcode;
      RETURN;

  END;
  IF (expr^.Kind = Tree.DyExpr) THEN
(* line 1119 "CODE.tmp" *)
(* line 1119 "CODE.tmp" *)
       O.StrLn( "CodeRExpr.DyExpr" ) ; 
    CodeRExpr(expr^.DyExpr.Expr1^.Exprs.TypeReprOut,expr^.DyExpr.Expr1,expr^.DyExpr.DyOperator^.DyOperator.Coerce1,dcode1); 
    CodeRExpr(expr^.DyExpr.Expr2^.Exprs.TypeReprOut,expr^.DyExpr.Expr2,expr^.DyExpr.DyOperator^.DyOperator.Coerce2,dcode2); 
    CodeDyOper(expr^.DyExpr.DyOperator,type,dcode1,dcode2,dcode); 
    CodeCoercion(co,dcode,dcode);
     ; 
 ;
      yyP24 := dcode;
      RETURN;

  END;
  IF (expr^.Kind = Tree.SetExpr) THEN
(* line 1127 "CODE.tmp" *)
(* line 1127 "CODE.tmp" *)
       O.StrLn( "CodeRExpr.SetExpr" ) ; 
    CodeValue(expr^.SetExpr.ConstValueRepr,type,OB.cmtCoercion,dcode); 
    CodeElements(expr^.SetExpr.Elements,dcode,dcode); 
     ; 
 ;
      yyP24 := dcode;
      RETURN;

  END;
  IF (expr^.Kind = Tree.DesignExpr) THEN
(* line 1133 "CODE.tmp" *)
(* line 1133 "CODE.tmp" *)
       O.StrLn( "CodeRExpr.DesignExpr" ) ; 
    CodeRDesignator(expr^.DesignExpr.Designator,dcode);
    CodeCoercion(co,dcode,dcode);
     ; 
 ;
      yyP24 := dcode;
      RETURN;

  END;
(* line 1139 "CODE.tmp" *)
(* line 1139 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeRExpr: failed'); ;
      yyP24 := NIL;
      RETURN;

 END CodeRExpr;

PROCEDURE CodeDyOper (yyP25: Tree.tTree; type: OB.tOB; dcode1: DCode; dcode2: DCode; VAR yyP26: DCode);
(* line 1145 "CODE.tmp" *)
 VAR dcode:DCode; 
 BEGIN
  IF yyP25 = Tree.NoTree THEN RETURN; END;
  IF type = OB.NoOB THEN RETURN; END;
  IF (yyP25^.Kind = Tree.PlusOper) THEN
  IF (type^.Kind = OB.SetTypeRepr) THEN
(* line 1147 "CODE.tmp" *)
(* line 1147 "CODE.tmp" *)
       Cons.SymDyOper     (or  ,dcode1,dcode2,dcode); ;
      yyP26 := dcode;
      RETURN;

  END;
  IF OB.IsType (type, OB.IntTypeRepr) THEN
(* line 1148 "CODE.tmp" *)
(* line 1148 "CODE.tmp" *)
       Cons.SymDyOper     (add ,dcode1,dcode2,dcode); ;
      yyP26 := dcode;
      RETURN;

  END;
  IF OB.IsType (type, OB.FloatTypeRepr) THEN
(* line 1149 "CODE.tmp" *)
(* line 1149 "CODE.tmp" *)
       Cons.FloatSymDyOper(fadd,dcode1,dcode2,dcode); ;
      yyP26 := dcode;
      RETURN;

  END;
  END;
  IF (yyP25^.Kind = Tree.MinusOper) THEN
  IF (type^.Kind = OB.SetTypeRepr) THEN
(* line 1151 "CODE.tmp" *)
(* line 1151 "CODE.tmp" *)
       Cons.Difference    (     dcode1,dcode2,dcode); ;
      yyP26 := dcode;
      RETURN;

  END;
  IF OB.IsType (type, OB.IntTypeRepr) THEN
(* line 1152 "CODE.tmp" *)
(* line 1152 "CODE.tmp" *)
       Cons.Sub           (     dcode1,dcode2,dcode); ;
      yyP26 := dcode;
      RETURN;

  END;
  IF OB.IsType (type, OB.FloatTypeRepr) THEN
(* line 1153 "CODE.tmp" *)
(* line 1153 "CODE.tmp" *)
       Cons.FloatDyOper   (fsub,dcode1,dcode2,dcode); ;
      yyP26 := dcode;
      RETURN;

  END;
  END;
  IF (yyP25^.Kind = Tree.MultOper) THEN
  IF (type^.Kind = OB.SetTypeRepr) THEN
(* line 1155 "CODE.tmp" *)
(* line 1155 "CODE.tmp" *)
       Cons.SymDyOper     (and ,dcode1,dcode2,dcode); ;
      yyP26 := dcode;
      RETURN;

  END;
  IF (type^.Kind = OB.ShortintTypeRepr) THEN
(* line 1156 "CODE.tmp" *)
(* line 1156 "CODE.tmp" *)
       Cons.Int2Integer(dcode1,dcode1); 
                                             Cons.Int2Integer(dcode2,dcode2); 
                                             Cons.SymDyOper     (imul,dcode1,dcode2,dcode); 
                                             Cons.Card2Shortint (dcode,dcode); 
                                           ;
      yyP26 := dcode;
      RETURN;

  END;
  IF OB.IsType (type, OB.IntTypeRepr) THEN
(* line 1161 "CODE.tmp" *)
(* line 1161 "CODE.tmp" *)
       Cons.SymDyOper     (imul,dcode1,dcode2,dcode); ;
      yyP26 := dcode;
      RETURN;

  END;
  IF OB.IsType (type, OB.FloatTypeRepr) THEN
(* line 1162 "CODE.tmp" *)
(* line 1162 "CODE.tmp" *)
       Cons.FloatSymDyOper(fmul,dcode1,dcode2,dcode); ;
      yyP26 := dcode;
      RETURN;

  END;
  END;
  IF (yyP25^.Kind = Tree.RDivOper) THEN
  IF (type^.Kind = OB.SetTypeRepr) THEN
(* line 1164 "CODE.tmp" *)
(* line 1164 "CODE.tmp" *)
       Cons.SymDyOper     (xor ,dcode1,dcode2,dcode); ;
      yyP26 := dcode;
      RETURN;

  END;
  IF OB.IsType (type, OB.FloatTypeRepr) THEN
(* line 1165 "CODE.tmp" *)
(* line 1165 "CODE.tmp" *)
       Cons.FloatDyOper   (fdiv,dcode1,dcode2,dcode); ;
      yyP26 := dcode;
      RETURN;

  END;
  END;
  IF (yyP25^.Kind = Tree.DivOper) THEN
  IF OB.IsType (type, OB.IntTypeRepr) THEN
(* line 1167 "CODE.tmp" *)
(* line 1167 "CODE.tmp" *)
       Cons.Div           (     dcode1,dcode2,dcode); ;
      yyP26 := dcode;
      RETURN;

  END;
  END;
  IF (yyP25^.Kind = Tree.ModOper) THEN
  IF OB.IsType (type, OB.IntTypeRepr) THEN
(* line 1168 "CODE.tmp" *)
(* line 1168 "CODE.tmp" *)
       Cons.Mod           (     dcode1,dcode2,dcode); ;
      yyP26 := dcode;
      RETURN;

  END;
  END;
(* line 1170 "CODE.tmp" *)
(* line 1170 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeDyOper: failed'); ;
      yyP26 := NIL;
      RETURN;

 END CodeDyOper;

PROCEDURE CodeElements (elements: Tree.tTree; dcodeIn: DCode; VAR yyP27: DCode);
(* line 1176 "CODE.tmp" *)
 VAR dcode,dcode1,dcode2:DCode; 
 BEGIN
  IF elements = Tree.NoTree THEN RETURN; END;
  IF (elements^.Kind = Tree.Element) THEN
  IF (elements^.Element.Expr2^.Kind = Tree.mtExpr) THEN
(* line 1178 "CODE.tmp" *)
(* line 1178 "CODE.tmp" *)
       O.StrLn( "CodeElements.Expr" ) ; 
    IF V.IsCalculatableValue(elements^.Element.Expr1^.Exprs.ValueReprOut) THEN 
       CodeElements(elements^.Element.Next,dcodeIn,dcode); 
    ELSE 
       CodeRExpr(elements^.Element.Expr1^.Exprs.TypeReprOut,elements^.Element.Expr1,OB.cmtCoercion,dcode); 
       Cons.Int2Longint(dcode,dcode); 
       Cons.SetExtendByElem(dcodeIn,dcode,dcode); 
       CodeElements(elements^.Element.Next,dcode,dcode); 
    END;
     ; 
 ;
      yyP27 := dcode;
      RETURN;

  END;
(* line 1190 "CODE.tmp" *)
(* line 1190 "CODE.tmp" *)
       O.StrLn( "CodeElements.Expr..Expr" ) ; 
    IF V.IsCalculatableValue(elements^.Element.Expr1^.Exprs.ValueReprOut) & V.IsCalculatableValue(elements^.Element.Expr2^.Exprs.ValueReprOut) THEN 
       CodeElements(elements^.Element.Next,dcodeIn,dcode); 
    ELSE 
       CodeRExpr(elements^.Element.Expr1^.Exprs.TypeReprOut,elements^.Element.Expr1,OB.cmtCoercion,dcode1); Cons.Int2Longint(dcode1,dcode1); 
       CodeRExpr(elements^.Element.Expr2^.Exprs.TypeReprOut,elements^.Element.Expr2,OB.cmtCoercion,dcode2); Cons.Int2Longint(dcode2,dcode2); 
       Cons.SetExtendByRange(dcodeIn,dcode1,dcode2,dcode); 
       CodeElements(elements^.Element.Next,dcode,dcode); 
    END;
     ; 
 ;
      yyP27 := dcode;
      RETURN;

  END;
  IF (elements^.Kind = Tree.mtElement) THEN
(* line 1202 "CODE.tmp" *)
      yyP27 := dcodeIn;
      RETURN;

  END;
(* line 1204 "CODE.tmp" *)
(* line 1204 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeElements: failed'); ;
      yyP27 := NIL;
      RETURN;

 END CodeElements;

PROCEDURE CodeCoercion (yyP28: OB.tOB; codeIn: DCode; VAR yyP29: DCode);
(* line 1210 "CODE.tmp" *)
 VAR dcode:DCode; 
 BEGIN
  IF yyP28 = OB.NoOB THEN RETURN; END;

  CASE yyP28^.Kind OF
  | OB.Shortint2Integer:
(* line 1212 "CODE.tmp" *)
(* line 1212 "CODE.tmp" *)
       Cons.Int2Integer(codeIn,dcode); ;
      yyP29 := dcode;
      RETURN;

  | OB.Shortint2Longint:
(* line 1213 "CODE.tmp" *)
(* line 1214 "CODE.tmp" *)
       Cons.Int2Longint(codeIn,dcode); ;
      yyP29 := dcode;
      RETURN;

  | OB.Integer2Longint:
(* line 1213 "CODE.tmp" *)
(* line 1214 "CODE.tmp" *)
       Cons.Int2Longint(codeIn,dcode); ;
      yyP29 := dcode;
      RETURN;

  | OB.Shortint2Real:
(* line 1216 "CODE.tmp" *)
(* line 1221 "CODE.tmp" *)
       Cons.Int2Float       (codeIn,dcode); ;
      yyP29 := dcode;
      RETURN;

  | OB.Integer2Real:
(* line 1216 "CODE.tmp" *)
(* line 1221 "CODE.tmp" *)
       Cons.Int2Float       (codeIn,dcode); ;
      yyP29 := dcode;
      RETURN;

  | OB.Longint2Real:
(* line 1216 "CODE.tmp" *)
(* line 1221 "CODE.tmp" *)
       Cons.Int2Float       (codeIn,dcode); ;
      yyP29 := dcode;
      RETURN;

  | OB.Shortint2Longreal:
(* line 1216 "CODE.tmp" *)
(* line 1221 "CODE.tmp" *)
       Cons.Int2Float       (codeIn,dcode); ;
      yyP29 := dcode;
      RETURN;

  | OB.Integer2Longreal:
(* line 1216 "CODE.tmp" *)
(* line 1221 "CODE.tmp" *)
       Cons.Int2Float       (codeIn,dcode); ;
      yyP29 := dcode;
      RETURN;

  | OB.Longint2Longreal:
(* line 1216 "CODE.tmp" *)
(* line 1221 "CODE.tmp" *)
       Cons.Int2Float       (codeIn,dcode); ;
      yyP29 := dcode;
      RETURN;

  ELSE END;

(* line 1227 "CODE.tmp" *)
      yyP29 := codeIn;
      RETURN;

 END CodeCoercion;

PROCEDURE CodeBooleanExpr (expr: Tree.tTree; exprVal: OB.tOB; exprLabel: tLabel; trueLabel: tLabel; falseLabel: tLabel; VAR yyP30: BoolCode);
(* line 1233 "CODE.tmp" *)
 VAR condcode:CondCode; boolcode,bool1code,bool2code:BoolCode; dcode,dcode1,dcode2:DCode; expr2Label:tLabel; 
           labelcode:Cons.Label; isSigned:BOOLEAN; 
 BEGIN
  IF expr = Tree.NoTree THEN RETURN; END;
  IF exprVal = OB.NoOB THEN RETURN; END;
  IF (exprVal^.Kind = OB.BooleanValue) THEN
(* line 1236 "CODE.tmp" *)
(* line 1236 "CODE.tmp" *)
       O.StrLn( "CodeBooleanExpr.UnnamedConst" ) ; 
    Cons.LabelDef(exprLabel,labelcode); 
    Cons.ConstBranch(exprVal^.BooleanValue.v,trueLabel,falseLabel,labelcode,boolcode); 
 ;
      yyP30 := boolcode;
      RETURN;

  END;
  IF (expr^.Kind = Tree.NotExpr) THEN
(* line 1241 "CODE.tmp" *)
(* line 1241 "CODE.tmp" *)
       O.StrLn( "CodeBooleanExpr.NotExpr" ) ; 
    CodeBooleanExpr(expr^.NotExpr.Exprs,expr^.NotExpr.Exprs^.Exprs.ValueReprOut,exprLabel,falseLabel,trueLabel,boolcode); 
    Cons.Not(boolcode,boolcode); 
 ;
      yyP30 := boolcode;
      RETURN;

  END;
  IF (expr^.Kind = Tree.DesignExpr) THEN
  IF (expr^.DesignExpr.Designator^.Designator.Designations^.Kind = Tree.Importing) THEN
  IF Tree.IsType (expr^.DesignExpr.Designator^.Designator.Designations^.Importing.Nextion, Tree.PredeclArgumenting) THEN
(* line 1246 "CODE.tmp" *)
(* line 1247 "CODE.tmp" *)
       O.StrLn( "CodeBooleanExpr.Predecl" ) ; 
    CodePredeclPredicates(expr^.DesignExpr.Designator^.Designator.Designations^.Importing.Nextion,exprLabel,trueLabel,falseLabel,boolcode); 
 ;
      yyP30 := boolcode;
      RETURN;

  END;
  END;
  IF Tree.IsType (expr^.DesignExpr.Designator^.Designator.Designations, Tree.PredeclArgumenting) THEN
(* line 1246 "CODE.tmp" *)
(* line 1247 "CODE.tmp" *)
       O.StrLn( "CodeBooleanExpr.Predecl" ) ; 
    CodePredeclPredicates(expr^.DesignExpr.Designator^.Designator.Designations,exprLabel,trueLabel,falseLabel,boolcode); 
 ;
      yyP30 := boolcode;
      RETURN;

  END;
(* line 1251 "CODE.tmp" *)
(* line 1251 "CODE.tmp" *)
       O.StrLn( "CodeBooleanExpr.DesignExpr" ) ; 
    CodeRDesignator(expr^.DesignExpr.Designator,dcode);
    Cons.LabelDef(exprLabel,labelcode); 
    Cons.Flag(ASM.unequal,labelcode,dcode,condcode); 
    Cons.Branch((*isSigned:=*)TRUE,trueLabel,falseLabel,condcode,boolcode); 
 ;
      yyP30 := boolcode;
      RETURN;

  END;
  IF (expr^.Kind = Tree.DyExpr) THEN
  IF (expr^.DyExpr.DyOperator^.Kind = Tree.OrOper) THEN
(* line 1258 "CODE.tmp" *)
(* line 1258 "CODE.tmp" *)
       O.StrLn( "CodeBooleanExpr.OR" ) ; 
    CodeBooleanExpr(expr^.DyExpr.Expr1,expr^.DyExpr.Expr1^.Exprs.ValueReprOut,exprLabel ,trueLabel,LAB.New(expr2Label),bool1code); 
    CodeBooleanExpr(expr^.DyExpr.Expr2,expr^.DyExpr.Expr2^.Exprs.ValueReprOut,expr2Label,trueLabel,falseLabel         ,bool2code); 
    Cons.Or(bool1code,bool2code,boolcode); 
 ;
      yyP30 := boolcode;
      RETURN;

  END;
  IF (expr^.DyExpr.DyOperator^.Kind = Tree.AndOper) THEN
(* line 1264 "CODE.tmp" *)
(* line 1264 "CODE.tmp" *)
       O.StrLn( "CodeBooleanExpr.AND" ) ; 
    CodeBooleanExpr(expr^.DyExpr.Expr1,expr^.DyExpr.Expr1^.Exprs.ValueReprOut,exprLabel ,LAB.New(expr2Label),falseLabel,bool1code); 
    CodeBooleanExpr(expr^.DyExpr.Expr2,expr^.DyExpr.Expr2^.Exprs.ValueReprOut,expr2Label,trueLabel          ,falseLabel,bool2code); 
    Cons.And(bool1code,bool2code,boolcode); 
 ;
      yyP30 := boolcode;
      RETURN;

  END;
  IF (expr^.DyExpr.DyOperator^.Kind = Tree.InOper) THEN
(* line 1270 "CODE.tmp" *)
(* line 1270 "CODE.tmp" *)
       O.StrLn( "CodeBooleanExpr.IN" ) ; 
    CodeRExpr(expr^.DyExpr.Expr1^.Exprs.TypeReprOut,expr^.DyExpr.Expr1,expr^.DyExpr.DyOperator^.InOper.Coerce1,dcode1);
    CodeRExpr(expr^.DyExpr.Expr2^.Exprs.TypeReprOut,expr^.DyExpr.Expr2,expr^.DyExpr.DyOperator^.InOper.Coerce2,dcode2);

    Cons.LabelDef(exprLabel,labelcode); 
    Cons.Int2Longint(dcode1,dcode1); 
    Cons.In(trueLabel,falseLabel,labelcode,dcode1,dcode2,boolcode); 
 ;
      yyP30 := boolcode;
      RETURN;

  END;
  IF Tree.IsType (expr^.DyExpr.DyOperator, Tree.RelationOper) THEN
(* line 1279 "CODE.tmp" *)
(* line 1279 "CODE.tmp" *)
       O.StrLn( "CodeBooleanExpr.Relation" ) ; 
    CodeRelation(expr^.DyExpr.Expr1^.Exprs.TypeReprOut,expr^.DyExpr.Expr2^.Exprs.TypeReprOut,expr^.DyExpr.Expr1^.Exprs.ValueReprOut,expr^.DyExpr.Expr2^.Exprs.ValueReprOut,expr,exprLabel,condcode,isSigned); 
    Cons.Branch(isSigned,trueLabel,falseLabel,condcode,boolcode); 
 ;
      yyP30 := boolcode;
      RETURN;

  END;
  END;
  IF (expr^.Kind = Tree.IsExpr) THEN
(* line 1284 "CODE.tmp" *)
(* line 1284 "CODE.tmp" *)
       O.StrLn( "CodeBooleanExpr.IS" ) ; 
    CodeIsExpr(expr^.IsExpr.Designator^.Designator.TypeReprOut,expr^.IsExpr.TypeTypeRepr,expr^.IsExpr.Designator,exprLabel,trueLabel,falseLabel,boolcode); 
 ;
      yyP30 := boolcode;
      RETURN;

  END;
(* line 1288 "CODE.tmp" *)
(* line 1288 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeBooleanExpr: failed'); ;
      yyP30 := NIL;
      RETURN;

 END CodeBooleanExpr;

PROCEDURE CodeRelation (type1: OB.tOB; type2: OB.tOB; val1: OB.tOB; val2: OB.tOB; expr: Tree.tTree; exprLabel: tLabel; VAR yyP31: CondCode; VAR isSigned: BOOLEAN);
(* line 1295 "CODE.tmp" *)
 VAR condcode:CondCode; dcode1,dcode2:DCode; labelcode:Cons.Label; string1,string2:OT.oSTRING; 
 BEGIN
  IF type1 = OB.NoOB THEN RETURN; END;
  IF type2 = OB.NoOB THEN RETURN; END;
  IF val1 = OB.NoOB THEN RETURN; END;
  IF val2 = OB.NoOB THEN RETURN; END;
  IF expr = Tree.NoTree THEN RETURN; END;
  IF (type1^.Kind = OB.CharStringTypeRepr) THEN
  IF (type2^.Kind = OB.ArrayTypeRepr) THEN
  IF (val1^.Kind = OB.CharValue) THEN
  IF Tree.IsType (expr^.DyExpr.DyOperator, Tree.RelationOper) THEN
(* line 1298 "CODE.tmp" *)
(* line 1299 "CODE.tmp" *)
       O.StrLn( "CodeRelation.String.Array" ) ; 
    CodeRExpr(type2,expr^.DyExpr.Expr2,expr^.DyExpr.DyOperator^.RelationOper.Coerce2,dcode2);

    Cons.LabelDef(exprLabel,labelcode); 
    OT.oCHAR2oSTRING(val1^.CharValue.v,string1); 
    Cons.ConstStringCompare(ASM.RevRelTab[RelTab[expr^.DyExpr.DyOperator^.RelationOper.Operator]],string1,labelcode,dcode2,condcode); 
 ;
      yyP31 := condcode;
      isSigned := FALSE;
      RETURN;

  END;
  END;
  END;
  END;
  IF (type1^.Kind = OB.ArrayTypeRepr) THEN
  IF (type2^.Kind = OB.CharStringTypeRepr) THEN
  IF (val2^.Kind = OB.CharValue) THEN
  IF Tree.IsType (expr^.DyExpr.DyOperator, Tree.RelationOper) THEN
(* line 1307 "CODE.tmp" *)
(* line 1308 "CODE.tmp" *)
       O.StrLn( "CodeRelation.Array.String" ) ; 
    CodeRExpr(type1,expr^.DyExpr.Expr1,expr^.DyExpr.DyOperator^.RelationOper.Coerce1,dcode1);

    Cons.LabelDef(exprLabel,labelcode); 
    OT.oCHAR2oSTRING(val2^.CharValue.v,string2); 
    Cons.ConstStringCompare(RelTab[expr^.DyExpr.DyOperator^.RelationOper.Operator],string2,labelcode,dcode1,condcode); 
 ;
      yyP31 := condcode;
      isSigned := FALSE;
      RETURN;

  END;
  END;
  END;
  IF (type2^.Kind = OB.StringTypeRepr) THEN
  IF (val2^.Kind = OB.StringValue) THEN
  IF Tree.IsType (expr^.DyExpr.DyOperator, Tree.RelationOper) THEN
(* line 1325 "CODE.tmp" *)
   LOOP
(* line 1326 "CODE.tmp" *)
      IF ~((OT . LengthOfoSTRING (val2^.StringValue.v) <= LIM . MaxLenToUseInlinedStrCmp)) THEN EXIT; END;
(* line 1326 "CODE.tmp" *)
       O.StrLn( "CodeRelation.Array.String" ) ; 
    CodeRExpr(type1,expr^.DyExpr.Expr1,expr^.DyExpr.DyOperator^.RelationOper.Coerce1,dcode1);

    Cons.LabelDef(exprLabel,labelcode); 
    Cons.ConstStringCompare(RelTab[expr^.DyExpr.DyOperator^.RelationOper.Operator],val2^.StringValue.v,labelcode,dcode1,condcode); 
 ;
      yyP31 := condcode;
      isSigned := FALSE;
      RETURN;
   END;

  END;
  END;
  IF Tree.IsType (expr^.DyExpr.DyOperator, Tree.RelationOper) THEN
(* line 1334 "CODE.tmp" *)
(* line 1337 "CODE.tmp" *)
       O.StrLn( "CodeRelation.Array.Array" ) ; 
    CodeRExpr(type1,expr^.DyExpr.Expr1,expr^.DyExpr.DyOperator^.RelationOper.Coerce1,dcode1);
    CodeRExpr(type2,expr^.DyExpr.Expr2,expr^.DyExpr.DyOperator^.RelationOper.Coerce2,dcode2);

    Cons.LabelDef(exprLabel,labelcode); 
    Cons.StringCompare(RelTab[expr^.DyExpr.DyOperator^.RelationOper.Operator],labelcode,dcode1,dcode2,condcode); 
 ;
      yyP31 := condcode;
      isSigned := FALSE;
      RETURN;

  END;
  END;
  IF (type2^.Kind = OB.ArrayTypeRepr) THEN
  IF Tree.IsType (expr^.DyExpr.DyOperator, Tree.RelationOper) THEN
(* line 1334 "CODE.tmp" *)
(* line 1337 "CODE.tmp" *)
       O.StrLn( "CodeRelation.Array.Array" ) ; 
    CodeRExpr(type1,expr^.DyExpr.Expr1,expr^.DyExpr.DyOperator^.RelationOper.Coerce1,dcode1);
    CodeRExpr(type2,expr^.DyExpr.Expr2,expr^.DyExpr.DyOperator^.RelationOper.Coerce2,dcode2);

    Cons.LabelDef(exprLabel,labelcode); 
    Cons.StringCompare(RelTab[expr^.DyExpr.DyOperator^.RelationOper.Operator],labelcode,dcode1,dcode2,condcode); 
 ;
      yyP31 := condcode;
      isSigned := FALSE;
      RETURN;

  END;
  END;
  END;
  IF (type1^.Kind = OB.StringTypeRepr) THEN
  IF (type2^.Kind = OB.ArrayTypeRepr) THEN
  IF (val1^.Kind = OB.StringValue) THEN
  IF Tree.IsType (expr^.DyExpr.DyOperator, Tree.RelationOper) THEN
(* line 1317 "CODE.tmp" *)
   LOOP
(* line 1318 "CODE.tmp" *)
      IF ~((OT . LengthOfoSTRING (val1^.StringValue.v) <= LIM . MaxLenToUseInlinedStrCmp)) THEN EXIT; END;
(* line 1318 "CODE.tmp" *)
       O.StrLn( "CodeRelation.String.Array" ) ; 
    CodeRExpr(type2,expr^.DyExpr.Expr2,expr^.DyExpr.DyOperator^.RelationOper.Coerce2,dcode2);

    Cons.LabelDef(exprLabel,labelcode); 
    Cons.ConstStringCompare(ASM.RevRelTab[RelTab[expr^.DyExpr.DyOperator^.RelationOper.Operator]],val1^.StringValue.v,labelcode,dcode2,condcode); 
 ;
      yyP31 := condcode;
      isSigned := FALSE;
      RETURN;
   END;

  END;
  END;
  IF Tree.IsType (expr^.DyExpr.DyOperator, Tree.RelationOper) THEN
(* line 1334 "CODE.tmp" *)
(* line 1337 "CODE.tmp" *)
       O.StrLn( "CodeRelation.Array.Array" ) ; 
    CodeRExpr(type1,expr^.DyExpr.Expr1,expr^.DyExpr.DyOperator^.RelationOper.Coerce1,dcode1);
    CodeRExpr(type2,expr^.DyExpr.Expr2,expr^.DyExpr.DyOperator^.RelationOper.Coerce2,dcode2);

    Cons.LabelDef(exprLabel,labelcode); 
    Cons.StringCompare(RelTab[expr^.DyExpr.DyOperator^.RelationOper.Operator],labelcode,dcode1,dcode2,condcode); 
 ;
      yyP31 := condcode;
      isSigned := FALSE;
      RETURN;

  END;
  END;
  END;
  IF OB.IsType (type1, OB.FloatTypeRepr) THEN
  IF Tree.IsType (expr^.DyExpr.DyOperator, Tree.RelationOper) THEN
(* line 1346 "CODE.tmp" *)
(* line 1347 "CODE.tmp" *)
       O.StrLn( "CodeRelation.Default" ) ; 
    CodeRExpr(type1,expr^.DyExpr.Expr1,expr^.DyExpr.DyOperator^.RelationOper.Coerce1,dcode1);
    CodeRExpr(type2,expr^.DyExpr.Expr2,expr^.DyExpr.DyOperator^.RelationOper.Coerce2,dcode2);

    Cons.LabelDef(exprLabel,labelcode); 
    Cons.FloatCompare(RelTab[expr^.DyExpr.DyOperator^.RelationOper.Operator],labelcode,dcode1,dcode2,condcode); 
 ;
      yyP31 := condcode;
      isSigned := TRUE;
      RETURN;

  END;
  END;
  IF OB.IsType (type2, OB.FloatTypeRepr) THEN
  IF Tree.IsType (expr^.DyExpr.DyOperator, Tree.RelationOper) THEN
(* line 1346 "CODE.tmp" *)
(* line 1347 "CODE.tmp" *)
       O.StrLn( "CodeRelation.Default" ) ; 
    CodeRExpr(type1,expr^.DyExpr.Expr1,expr^.DyExpr.DyOperator^.RelationOper.Coerce1,dcode1);
    CodeRExpr(type2,expr^.DyExpr.Expr2,expr^.DyExpr.DyOperator^.RelationOper.Coerce2,dcode2);

    Cons.LabelDef(exprLabel,labelcode); 
    Cons.FloatCompare(RelTab[expr^.DyExpr.DyOperator^.RelationOper.Operator],labelcode,dcode1,dcode2,condcode); 
 ;
      yyP31 := condcode;
      isSigned := TRUE;
      RETURN;

  END;
  END;
  IF Tree.IsType (expr^.DyExpr.DyOperator, Tree.RelationOper) THEN
(* line 1356 "CODE.tmp" *)
(* line 1356 "CODE.tmp" *)
       O.StrLn( "CodeRelation.Default" ) ; 
    CodeRExpr(type1,expr^.DyExpr.Expr1,expr^.DyExpr.DyOperator^.RelationOper.Coerce1,dcode1);
    CodeRExpr(type2,expr^.DyExpr.Expr2,expr^.DyExpr.DyOperator^.RelationOper.Coerce2,dcode2);

    Cons.LabelDef(exprLabel,labelcode); 
    Cons.Compare(RelTab[expr^.DyExpr.DyOperator^.RelationOper.Operator],labelcode,dcode1,dcode2,condcode); 
 ;
      yyP31 := condcode;
      isSigned := TRUE;
      RETURN;

  END;
(* line 1365 "CODE.tmp" *)
(* line 1365 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeRelation: failed'); ;
      yyP31 := NIL;
      isSigned := FALSE;
      RETURN;

 END CodeRelation;

PROCEDURE CodeIsExpr (StaticType: OB.tOB; TestType: OB.tOB; designator: Tree.tTree; exprLabel: tLabel; trueLabel: tLabel; falseLabel: tLabel; VAR yyP32: BoolCode);
(* line 1372 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; boolcode:BoolCode; labelcode:Cons.Label; idData:tImplicitDesignationData; ofs:LONGINT; 
 BEGIN
  IF StaticType = OB.NoOB THEN RETURN; END;
  IF TestType = OB.NoOB THEN RETURN; END;
  IF designator = Tree.NoTree THEN RETURN; END;
  IF (StaticType^.Kind = OB.RecordTypeRepr) THEN
  IF (TestType^.Kind = OB.RecordTypeRepr) THEN
(* line 1374 "CODE.tmp" *)
(* line 1375 "CODE.tmp" *)
       O.StrLn( "CodeIsExpr.RecordTypeRepr" ) ; 
    IF ~ADR.TTableElemOfsInTDesc(StaticType,TestType,ofs) THEN ERR.Fatal('CODE.CodeIsExpr.Record: failed'); END;

    CodeImplicitLDesignator(designator,idData,acode); 
    Cons.Selector(idData.ofsOfObjHeader,idData.acodeToObjHeader,acode); 
    Cons.ContentOf(l,acode,dcode); 

    Cons.LabelDef(exprLabel,labelcode); 
    Cons.Is(LAB.AppS(T.LabelOfTypeRepr(TestType),'$D'),ofs,trueLabel,falseLabel,labelcode,dcode,boolcode);
 ;
      yyP32 := boolcode;
      RETURN;

  END;
  END;
  IF (StaticType^.Kind = OB.PointerTypeRepr) THEN
  IF (StaticType^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
  IF (TestType^.Kind = OB.PointerTypeRepr) THEN
  IF (TestType^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
(* line 1386 "CODE.tmp" *)
(* line 1387 "CODE.tmp" *)
       O.StrLn( "CodeIsExpr.PointerTypeRepr" ) ; 
    IF ~ADR.TTableElemOfsInTDesc(StaticType^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr,TestType^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr,ofs) THEN ERR.Fatal('CODE.CodeIsExpr.Pointer: failed'); END;

    CodeLDesignator(designator,acode); 
    Cons.ContentOf(l,acode,dcode); 
    IF ARG.OptionNilChecking THEN Cons.NilCheck(dcode,dcode); END;
    Cons.PointerFrom(dcode,acode); 

    Cons.Selector(-4,acode,acode); 
    Cons.ContentOf(l,acode,dcode); 

    Cons.LabelDef(exprLabel,labelcode); 
    Cons.Is(LAB.AppS(T.LabelOfTypeRepr(TestType^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr),'$D'),ofs,trueLabel,falseLabel,labelcode,dcode,boolcode);
 ;
      yyP32 := boolcode;
      RETURN;

  END;
  END;
  END;
  END;
(* line 1402 "CODE.tmp" *)
(* line 1402 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeIsExpr: failed'); ;
      yyP32 := NIL;
      RETURN;

 END CodeIsExpr;

PROCEDURE CodeRDesignator (designator: Tree.tTree; VAR yyP33: DCode);
(* line 1408 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; 
 BEGIN
  IF designator = Tree.NoTree THEN RETURN; END;
  IF (designator^.Designator.Designations^.Kind = Tree.Importing) THEN
(* line 1410 "CODE.tmp" *)
(* line 1411 "CODE.tmp" *)
       O.StrLn( "CodeRDesignator" ) ; 
    IF designator^.Designator.ExprList#Tree.NoTree THEN 
       CodeLDesignator(designator,acode); 
       IF T.IsRealType(designator^.Designator.TypeReprOut) THEN 
          Cons.FloatFuncResultOf(acode,dcode); 
       ELSE 
          Cons.FuncResultOf(ASM.SizeTab[T.SizeOfType(designator^.Designator.TypeReprOut)],acode,dcode); 
       END;
    ELSE 
       CodeRDesignator1(designator^.Designator.Designations^.Importing.Entry,designator^.Designator.TypeReprOut,designator,designator^.Designator.Designations^.Importing.Nextion,dcode); 
    END;
     ; 
 ;
      yyP33 := dcode;
      RETURN;

  END;
(* line 1410 "CODE.tmp" *)
(* line 1411 "CODE.tmp" *)
       O.StrLn( "CodeRDesignator" ) ; 
    IF designator^.Designator.ExprList#Tree.NoTree THEN 
       CodeLDesignator(designator,acode); 
       IF T.IsRealType(designator^.Designator.TypeReprOut) THEN 
          Cons.FloatFuncResultOf(acode,dcode); 
       ELSE 
          Cons.FuncResultOf(ASM.SizeTab[T.SizeOfType(designator^.Designator.TypeReprOut)],acode,dcode); 
       END;
    ELSE 
       CodeRDesignator1(designator^.Designator.Entry,designator^.Designator.TypeReprOut,designator,designator^.Designator.Designations,dcode); 
    END;
     ; 
 ;
      yyP33 := dcode;
      RETURN;

 END CodeRDesignator;

PROCEDURE CodeRDesignator1 (entry: OB.tOB; type: OB.tOB; designator: Tree.tTree; designations: Tree.tTree; VAR yyP34: DCode);
(* line 1429 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; 
 BEGIN
  IF entry = OB.NoOB THEN RETURN; END;
  IF type = OB.NoOB THEN RETURN; END;
  IF designator = Tree.NoTree THEN RETURN; END;
  IF designations = Tree.NoTree THEN RETURN; END;
  IF (entry^.Kind = OB.VarEntry) THEN
  IF OB.IsType (type, OB.FloatTypeRepr) THEN
(* line 1431 "CODE.tmp" *)
(* line 1431 "CODE.tmp" *)
       O.StrLn( "CodeRDesignator1.Float" ) ; 
    CodeLDesignator(designator,acode); 
    Cons.FloatContentOf(ASM.FloatSizeTab[type^.FloatTypeRepr.size],acode,dcode); 
     ; 
 ;
      yyP34 := dcode;
      RETURN;

  END;
  IF OB.IsType (type, OB.TypeRepr) THEN
(* line 1437 "CODE.tmp" *)
   LOOP
(* line 1437 "CODE.tmp" *)
      IF ~(((type^.TypeRepr.size < 32) & (type^.TypeRepr.size IN {1,2,4}))) THEN EXIT; END;
(* line 1437 "CODE.tmp" *)
       O.StrLn( "CodeRDesignator1.StandardTypedVar" ) ; 
    CodeLDesignator(designator,acode); 
    Cons.ContentOf(ASM.SizeTab[type^.TypeRepr.size],acode,dcode); 
     ; 
 ;
      yyP34 := dcode;
      RETURN;
   END;

  END;
(* line 1443 "CODE.tmp" *)
(* line 1443 "CODE.tmp" *)
       O.StrLn( "CodeRDesignator1.Var" ) ; 
    CodeLDesignator(designator,acode); 
    Cons.AddressOf(acode,dcode); 
     ; 
 ;
      yyP34 := dcode;
      RETURN;

  END;
  IF (entry^.Kind = OB.ConstEntry) THEN
(* line 1449 "CODE.tmp" *)
(* line 1449 "CODE.tmp" *)
       O.StrLn( "CodeRDesignator1.Const" ) ; 
    CodeLDesignator(designator,acode); 
    Cons.AddressOf(acode,dcode); 
     ; 
 ;
      yyP34 := dcode;
      RETURN;

  END;
  IF (entry^.Kind = OB.ProcedureEntry) THEN
  IF (designations^.Kind = Tree.mtDesignation) THEN
(* line 1455 "CODE.tmp" *)
(* line 1455 "CODE.tmp" *)
       O.StrLn( "CodeRDesignator1.Proc" ) ; 
    Cons.GlobalVariable(entry^.ProcedureEntry.label,0,entry^.ProcedureEntry.ident,acode); 
    Cons.AddressOf(acode,dcode);
     ; 
 ;
      yyP34 := dcode;
      RETURN;

  END;
  END;
  IF Tree.IsType (designations, Tree.PredeclArgumenting) THEN
(* line 1461 "CODE.tmp" *)
(* line 1461 "CODE.tmp" *)
       O.StrLn( "CodeRDesignator1.PredeclArgumenting" ) ; 
    CodePredeclFuncs(designations,type,dcode); 
 ;
      yyP34 := dcode;
      RETURN;

  END;
(* line 1465 "CODE.tmp" *)
(* line 1465 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeRDesignator1: failed'); ;
      yyP34 := NIL;
      RETURN;

 END CodeRDesignator1;

PROCEDURE CodeSimpleLDesignator (entry: OB.tOB; curLevel: tLevel; VAR yyP35: ACode);
(* line 1471 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; 
 BEGIN
  IF entry = OB.NoOB THEN RETURN; END;
  IF (entry^.Kind = OB.VarEntry) THEN
(* line 1473 "CODE.tmp" *)
(* line 1473 "CODE.tmp" *)
       O.StrLn( "CodeSimpleLDesignator" ) ; 
    IF entry^.VarEntry.level<=OB.MODULELEVEL THEN 
       Cons.GlobalVariable(entry^.VarEntry.module^.ModuleEntry.globalLabel,entry^.VarEntry.address,entry^.VarEntry.ident,acode); 
    ELSE
       IF entry^.VarEntry.level=curLevel THEN
          Cons.LocalVariable(entry^.VarEntry.address,entry^.VarEntry.ident,acode); 
       ELSE
          Cons.LocalVariable(-4*(1+entry^.VarEntry.level-OB.MODULELEVEL),Idents.NoIdent,acode); 
          Cons.ContentOf(l,acode,dcode); 
          Cons.PointerFrom(dcode,acode); 
          Cons.Selector(entry^.VarEntry.address,acode,acode); 
       END;

       IF entry^.VarEntry.refMode=OB.REFPAR THEN 
          Cons.ContentOf(l,acode,dcode); 
          Cons.PointerFrom(dcode,acode); 
       END;
    END;
 ;
      yyP35 := acode;
      RETURN;

  END;
(* line 1493 "CODE.tmp" *)
(* line 1493 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeSimpleLDesignator: failed'); ;
      yyP35 := NIL;
      RETURN;

 END CodeSimpleLDesignator;

PROCEDURE CodeLDesignator (designator: Tree.tTree; VAR yyP36: ACode);
(* line 1499 "CODE.tmp" *)
 VAR acode:ACode; idData:tImplicitDesignationData; retypecode:RetypeCode; 
 BEGIN
  IF designator = Tree.NoTree THEN RETURN; END;
  IF (designator^.Designator.Designations^.Kind = Tree.Importing) THEN
  IF (designator^.Designator.Designations^.Importing.Nextion^.Kind = Tree.SysValArgumenting) THEN
(* line 1502 "CODE.tmp" *)
(* line 1507 "CODE.tmp" *)
       O.StrLn( "CodeLDesignator.SYSTEM.VAL" ) ; 
    CodeSysValSource(designator^.Designator.Designations^.Importing.Nextion^.SysValArgumenting.Expr^.Exprs.TypeReprOut,designator^.Designator.Designations^.Importing.Nextion^.SysValArgumenting.TypeTypeRepr,designator^.Designator.Designations^.Importing.Nextion^.SysValArgumenting.Expr,designator^.Designator.Designations^.Importing.Nextion^.SysValArgumenting.TempAddr,retypecode); 
    Cons.Retype2Addr(retypecode,acode);     
 ;
      yyP36 := acode;
      RETURN;

  END;
  END;
(* line 1513 "CODE.tmp" *)
(* line 1513 "CODE.tmp" *)
       O.StrLn( "CodeLDesignator" ) ; 
    CodeImplicitLDesignator(designator,idData,acode); 
 ;
      yyP36 := acode;
      RETURN;

 END CodeLDesignator;

PROCEDURE CodeImplicitLDesignator (yyP37: Tree.tTree; VAR idData: tImplicitDesignationData; VAR yyP38: ACode);
(* line 1522 "CODE.tmp" *)
 VAR acode:ACode; argcode:ArgCode; 
 BEGIN
  IF yyP37 = Tree.NoTree THEN RETURN; END;
  IF (yyP37^.Designator.Designations^.Kind = Tree.Importing) THEN
(* line 1524 "CODE.tmp" *)
(* line 1525 "CODE.tmp" *)
       O.StrLn( "CodeImplicitLDesignator" ) ; 
    Cons.NoParam(argcode); 
    IF yyP37^.Designator.ExprList#Tree.NoTree THEN 
       CodeArguments(yyP37^.Designator.SignatureRepr,yyP37^.Designator.ExprList,argcode,argcode); 
    END;
			      
    CodeLDesignator1(yyP37^.Designator.Designations^.Importing.Entry,yyP37^.Designator.Designations^.Importing.Nextion,idData,argcode,acode); 
 ;
      yyP38 := acode;
      RETURN;

  END;
(* line 1524 "CODE.tmp" *)
(* line 1525 "CODE.tmp" *)
       O.StrLn( "CodeImplicitLDesignator" ) ; 
    Cons.NoParam(argcode); 
    IF yyP37^.Designator.ExprList#Tree.NoTree THEN 
       CodeArguments(yyP37^.Designator.SignatureRepr,yyP37^.Designator.ExprList,argcode,argcode); 
    END;
			      
    CodeLDesignator1(yyP37^.Designator.Entry,yyP37^.Designator.Designations,idData,argcode,acode); 
 ;
      yyP38 := acode;
      RETURN;

 END CodeImplicitLDesignator;

PROCEDURE CodeLDesignator1 (entry: OB.tOB; designations: Tree.tTree; VAR idData: tImplicitDesignationData; argcodeIn: ArgCode; VAR yyP39: ACode);
(* line 1539 "CODE.tmp" *)
 VAR lab:OB.tLabel; acode:ACode; dcode:DCode; nextDesignations:Tree.tTree; 
 BEGIN
  IF entry = OB.NoOB THEN RETURN; END;
  IF designations = Tree.NoTree THEN RETURN; END;
  IF (entry^.Kind = OB.VarEntry) THEN
(* line 1541 "CODE.tmp" *)
(* line 1542 "CODE.tmp" *)
       O.StrLn( "CodeLDesignator1.Var" ) ; 
    
    idData.typeOfObject          := entry^.VarEntry.typeRepr;
    idData.isStackObject         := FALSE; 
    idData.acodeToObjHeader      := NIL;
    idData.ofsOfObjHeader        := 0; 
    idData.ofsOfObject           := 0; 
    idData.ofsOfLEN0             := 0; 
    idData.nofOpenIndexings      := 0; 
    idData.codeToOpenIndexedElem := NIL;

    nextDesignations:=designations;
    IF entry^.VarEntry.level<=OB.MODULELEVEL THEN 
       IF entry^.VarEntry.module^.ModuleEntry.isForeign THEN
          Cons.GlobalVariable(LAB.MakeForeign(entry^.VarEntry.ident),0,entry^.VarEntry.ident,acode); 
       ELSE
          Cons.GlobalVariable(entry^.VarEntry.module^.ModuleEntry.globalLabel,entry^.VarEntry.address,entry^.VarEntry.ident,acode); 
       END;
    ELSE
       IF entry^.VarEntry.refMode=OB.REFPAR THEN 
          IF entry^.VarEntry.level=designations^.Designations.LevelIn THEN
             Cons.LocalVariable(entry^.VarEntry.address,entry^.VarEntry.ident,acode); 

             CodeLocalImplicitDesignations(entry^.VarEntry.typeRepr,designations,idData,entry^.VarEntry.isWithed,entry^.VarEntry.address,acode
             (* => *)                     ,acode,nextDesignations);
          ELSE
             Cons.LocalVariable(-4*(1+entry^.VarEntry.level-OB.MODULELEVEL),Idents.NoIdent,acode); 
             Cons.ContentOf(l,acode,dcode); 
             Cons.PointerFrom(dcode,acode); 

             CodeStackImplicitDesignations(entry^.VarEntry.typeRepr,designations,idData,entry^.VarEntry.isWithed,entry^.VarEntry.address,acode
             (* => *)                     ,acode,nextDesignations);
          END;
       ELSE 
          IF entry^.VarEntry.level=designations^.Designations.LevelIn THEN
             Cons.LocalVariable(entry^.VarEntry.address,entry^.VarEntry.ident,acode); 
          ELSE
             Cons.LocalVariable(-4*(1+entry^.VarEntry.level-OB.MODULELEVEL),Idents.NoIdent,acode); 
             Cons.ContentOf(l,acode,dcode); 
             Cons.PointerFrom(dcode,acode); 
             Cons.Selector(entry^.VarEntry.address,acode,acode); 
          END;
       END;
    END;

    CodeDesignations(nextDesignations,idData,entry^.VarEntry.isWithed,argcodeIn,acode,acode); 
 ;
      yyP39 := acode;
      RETURN;

  END;
  IF (entry^.Kind = OB.ConstEntry) THEN
  IF OB.IsType (entry^.ConstEntry.value, OB.MemValueRepr) THEN
(* line 1590 "CODE.tmp" *)
(* line 1590 "CODE.tmp" *)
       O.StrLn( "CodeLDesignator1.Const" ) ; 
    IF entry^.ConstEntry.exportMode=OB.PRIVATE THEN 
       lab:=V.LabelOfMemValue(entry^.ConstEntry.value); 
    ELSE 
       lab:=entry^.ConstEntry.label; 
    END;
    Cons.GlobalVariable(lab,0,entry^.ConstEntry.ident,acode); 

    CodeDesignations(designations,idData,(*isWithed:=*)FALSE,argcodeIn,acode,acode); 
     ; 
 ;
      yyP39 := acode;
      RETURN;

  END;
  END;
  IF (entry^.Kind = OB.ProcedureEntry) THEN
  IF OB.IsType (entry^.ProcedureEntry.typeRepr, OB.ProcedureTypeRepr) THEN
  IF (designations^.Kind = Tree.Argumenting) THEN
(* line 1602 "CODE.tmp" *)
(* line 1603 "CODE.tmp" *)
       O.StrLn( "CodeLDesignator1.Proc" ) ; 
    Cons.DirectCall(entry^.ProcedureEntry.typeRepr^.ProcedureTypeRepr.paramSpace,entry^.ProcedureEntry.label,argcodeIn,acode);
     ; 
 ;
      yyP39 := acode;
      RETURN;

  END;
  END;
  END;
(* line 1608 "CODE.tmp" *)
(* line 1608 "CODE.tmp" *)
       ERR.Fatal('CODE.LDesignator1: failed'); ;
      yyP39 := NIL;
      RETURN;

 END CodeLDesignator1;

PROCEDURE CodeDesignations (yyP40: Tree.tTree; VAR idData: tImplicitDesignationData; isWithed: BOOLEAN; argcodeIn: ArgCode; acodeIn: ACode; VAR yyP41: ACode);
(* line 1615 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; nextDesignations:Tree.tTree; 
 BEGIN
  IF yyP40 = Tree.NoTree THEN RETURN; END;

  CASE yyP40^.Kind OF
  | Tree.Selecting:
(* line 1617 "CODE.tmp" *)
(* line 1617 "CODE.tmp" *)
       O.StrLn( "CodeDesignations.Selecting" ) ; 
    Cons.Selector(E.AddressOfVarEntry(yyP40^.Selecting.Entry),acodeIn,acode); 
    CodeDesignations(yyP40^.Selecting.Nextion,idData,(*isWithed:=*)FALSE,argcodeIn,acode,acode); 
     ; 
 ;
      yyP41 := acode;
      RETURN;

  | Tree.Indexing:
(* line 1623 "CODE.tmp" *)
   LOOP
(* line 1623 "CODE.tmp" *)
      IF ~((V . IsValidConstValue (yyP40^.Indexing.Expr^.Exprs.ValueReprOut))) THEN EXIT; END;
(* line 1623 "CODE.tmp" *)
       O.StrLn( "CodeDesignations.ConstIndexing" ) ; 
    Cons.Selector(V.ValueOfInteger(yyP40^.Indexing.Expr^.Exprs.ValueReprOut)*T.SizeOfType(yyP40^.Indexing.ElemTypeRepr),acodeIn,acode); 
    CodeDesignations(yyP40^.Indexing.Nextion,idData,(*isWithed:=*)FALSE,argcodeIn,acode,acode); 
     ; 
 ;
      yyP41 := acode;
      RETURN;
   END;

(* line 1629 "CODE.tmp" *)
(* line 1629 "CODE.tmp" *)
       O.StrLn( "CodeDesignations.Indexing" ) ; 
    CodeRExpr(yyP40^.Indexing.Expr^.Exprs.TypeReprOut,yyP40^.Indexing.Expr,CO.GetCoercion(yyP40^.Indexing.Expr^.Exprs.TypeReprOut,OB.cLongintTypeRepr),dcode); 
    IF ARG.OptionIndexChecking THEN Cons.IndexCheck(yyP40^.Indexing.Len,dcode,dcode); END;
    Cons.Index(T.SizeOfType(yyP40^.Indexing.ElemTypeRepr),acodeIn,dcode,acode); 
    CodeDesignations(yyP40^.Indexing.Nextion,idData,(*isWithed:=*)FALSE,argcodeIn,acode,acode); 
     ; 
 ;
      yyP41 := acode;
      RETURN;

  | Tree.Dereferencing:
(* line 1637 "CODE.tmp" *)
(* line 1637 "CODE.tmp" *)
       O.StrLn( "CodeDesignations.Dereferencing" ) ; 
    Cons.ContentOf(l,acodeIn,dcode); 
    IF ARG.OptionNilChecking THEN Cons.NilCheck(dcode,dcode); END;
    Cons.PointerFrom(dcode,acode); 

    CodeHeapImplicitDesignations(yyP40^.Dereferencing.BaseTypeRepr,yyP40^.Dereferencing.Nextion,idData,ADR.ArrayOfs(yyP40^.Dereferencing.BaseTypeRepr),acode
    (* => *)                    ,acode,nextDesignations);
    CodeDesignations(nextDesignations,idData,(*isWithed:=*)FALSE,argcodeIn,acode,acode); 
     ; 
 ;
      yyP41 := acode;
      RETURN;

  | Tree.Argumenting:
(* line 1648 "CODE.tmp" *)
(* line 1648 "CODE.tmp" *)
       O.StrLn( "CodeDesignations.Argumenting" ) ; 
    IF ~E.IsBoundProcEntry(yyP40^.Argumenting.Entry) THEN 
       CodeIndirectCall(yyP40^.Argumenting.ProcTypeRepr,argcodeIn,acodeIn,acode); 
    ELSE 
       CodeBoundCall((* procEntry := *) E.BoundProcEntryOfBoundProc(yyP40^.Argumenting.Entry)
                    ,(* aRcvEntry := *) yyP40^.Argumenting.RcvEntry
                    ,(* rcvType   := *) T.ReceiverRecordTypeOfType(E.ReceiverTypeOfBoundProc(yyP40^.Argumenting.Entry))
                    ,(* yyP40^.Argumenting.LevelIn  := *) yyP40^.Argumenting.LevelIn
                    ,(* bprocLab  := *) LAB.MT	   
                    ,(* argcodeIn := *) argcodeIn
                    ,(* acodeIn   := *) acodeIn
                    ,(*           => *) acode); 
    END;
     ; 
 ;
      yyP41 := acode;
      RETURN;

  | Tree.Supering:
  IF (yyP40^.Supering.Nextion^.Kind = Tree.Argumenting) THEN
(* line 1664 "CODE.tmp" *)
(* line 1664 "CODE.tmp" *)
       O.StrLn( "CodeDesignations.Supering" ) ; 
    CodeBoundCall((* procEntry := *) E.BoundProcEntryOfBoundProc(yyP40^.Supering.Entry)
                 ,(* aRcvEntry := *) yyP40^.Supering.RcvEntry
                 ,(* rcvType   := *) T.RecordBaseTypeOfType(E.ReceiverTypeOfBoundProc(yyP40^.Supering.Entry))
                 ,(* yyP40^.Supering.LevelIn  := *) yyP40^.Supering.LevelIn
                 ,(* bprocLab  := *) E.LabelOfRedefinedBoundProc(yyP40^.Supering.Entry)
                 ,(* argcodeIn := *) argcodeIn
                 ,(* acodeIn   := *) acodeIn
                 ,(*           => *) acode); 
     ; 
 ;
      yyP41 := acode;
      RETURN;

  END;
  | Tree.Guarding:
(* line 1676 "CODE.tmp" *)
(* line 1676 "CODE.tmp" *)
       O.StrLn( "CodeDesignations.Guarding" ) ; 
    CodePointerGuarding(yyP40^.Guarding.StaticTypeRepr,yyP40^.Guarding.TestTypeRepr,isWithed,acodeIn,acode); 
    CodeDesignations(yyP40^.Guarding.Nextion,idData,isWithed,argcodeIn,acode,acode); 
     ; 
 ;
      yyP41 := acode;
      RETURN;

  | Tree.mtDesignation:
(* line 1682 "CODE.tmp" *)
      yyP41 := acodeIn;
      RETURN;

  ELSE END;

(* line 1684 "CODE.tmp" *)
(* line 1684 "CODE.tmp" *)
       ERR.Fatal('CODE.Designations: failed'); ;
      yyP41 := NIL;
      RETURN;

 END CodeDesignations;

PROCEDURE CodePointerGuarding (StaticType: OB.tOB; TestType: OB.tOB; isWithed: BOOLEAN; acodeIn: ACode; VAR yyP42: ACode);
(* line 1690 "CODE.tmp" *)
 VAR acode:ACode; dcode,new1Reg,new2Reg:DCode; ofs:LONGINT; 
 BEGIN
  IF StaticType = OB.NoOB THEN RETURN; END;
  IF TestType = OB.NoOB THEN RETURN; END;
  IF (StaticType^.Kind = OB.PointerTypeRepr) THEN
  IF (StaticType^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
  IF (TestType^.Kind = OB.PointerTypeRepr) THEN
  IF (TestType^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
(* line 1692 "CODE.tmp" *)
(* line 1693 "CODE.tmp" *)
       O.StrLn( "CodePointerGuarding" ) ; 
    IF (ADR.TTableElemOfsInTDesc(StaticType^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr,TestType^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr,ofs) OR isWithed) & (ofs#0) THEN 
       Cons.ConjureRegister(new1Reg); Cons.ConjureRegister(new2Reg); 
       Cons.PointerGuard(LAB.AppS(T.LabelOfTypeRepr(TestType^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr),'$D'),ofs,acodeIn,new1Reg,new2Reg,dcode); 
       Cons.PointerFrom(dcode,acode); 
    ELSE 
       acode:=acodeIn; 
    END;
     ; 
 ;
      yyP42 := acode;
      RETURN;

  END;
  END;
  END;
  END;
(* line 1704 "CODE.tmp" *)
(* line 1704 "CODE.tmp" *)
       ERR.Fatal('CODE.CodePointerGuarding: failed'); ;
      yyP42 := NIL;
      RETURN;

 END CodePointerGuarding;

PROCEDURE CodeLocalImplicitDesignations (type: OB.tOB; designations: Tree.tTree; VAR idData: tImplicitDesignationData; isWithed: BOOLEAN; objOfs: LONGINT; acodeIn: ACode; VAR yyP44: ACode; VAR yyP43: Tree.tTree);
(* line 1711 "CODE.tmp" *)
 VAR acode:ACode; dcode,headerBaseRegCode,objBaseRegCode,newReg:DCode; popcode:PopCode; tailDesignations:Tree.tTree; 
           ofs:LONGINT; dontCare:BOOLEAN; 
 BEGIN
  IF type = OB.NoOB THEN RETURN; END;
  IF designations = Tree.NoTree THEN RETURN; END;
  IF (type^.Kind = OB.ArrayTypeRepr) THEN
  IF (designations^.Kind = Tree.Indexing) THEN
(* line 1714 "CODE.tmp" *)
   LOOP
(* line 1714 "CODE.tmp" *)
      IF ~((type^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
(* line 1714 "CODE.tmp" *)
       O.StrLn( "CodeLocalOpenDesignations.OpenIndex" ) ; 
    idData.isStackObject         := TRUE; 
    Cons.Selector(-objOfs,acodeIn,idData.acodeToObjHeader);
    idData.ofsOfObjHeader        := objOfs; 
    idData.ofsOfObject           := objOfs; 
    idData.ofsOfLEN0             := objOfs+4+4*(SYSTEM.VAL(SHORTINT,T.IsOpenArrayType(type^.ArrayTypeRepr.elemTypeRepr))); 

    Cons.OpenIndexStartLocal(headerBaseRegCode); 
    CodeOpenIndexing(type,designations,idData,(*isFirst:=*)TRUE,idData.ofsOfLEN0,headerBaseRegCode
    (* => *)        ,popcode,tailDesignations,dontCare);
    
    idData.codeToOpenIndexedElem := popcode;
    Cons.ContentOf(l,acodeIn,objBaseRegCode); 
    Cons.OpenIndexApplication(popcode,objBaseRegCode,acode);
    idData.codeToObjBaseReg      := objBaseRegCode; 
     ; 
 ;
      yyP44 := acode;
      yyP43 := tailDesignations;
      RETURN;
   END;

  END;
(* line 1732 "CODE.tmp" *)
   LOOP
(* line 1732 "CODE.tmp" *)
      IF ~((type^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
(* line 1732 "CODE.tmp" *)
       O.StrLn( "CodeLocalOpenDesignations.Open" ) ; 
    idData.isStackObject         := TRUE; 
    Cons.Selector(-objOfs,acodeIn,idData.acodeToObjHeader);
    idData.ofsOfObjHeader        := objOfs; 
    idData.ofsOfObject           := objOfs; 
    idData.ofsOfLEN0             := objOfs+4+4*(SYSTEM.VAL(SHORTINT,T.IsOpenArrayType(type^.ArrayTypeRepr.elemTypeRepr))); 

    Cons.ContentOf(l,acodeIn,dcode); 
    Cons.PointerFrom(dcode,acode); 
     ; 
 ;
      yyP44 := acode;
      yyP43 := designations;
      RETURN;
   END;

  END;
  IF (type^.Kind = OB.RecordTypeRepr) THEN
  IF (designations^.Kind = Tree.Guarding) THEN
(* line 1744 "CODE.tmp" *)
(* line 1744 "CODE.tmp" *)
      O.StrLn( "CodeLocalOpenDesignations.Guard" ) ; 
    idData.isStackObject         := TRUE; 
    Cons.Selector(-objOfs,acodeIn,idData.acodeToObjHeader);
    idData.ofsOfObjHeader        := objOfs-4; 
    idData.ofsOfObject           := objOfs; 

    IF (ADR.TTableElemOfsInTDesc(designations^.Guarding.StaticTypeRepr,designations^.Guarding.TestTypeRepr,ofs) OR isWithed) & (ofs#0) THEN 
       Cons.ConjureRegister(newReg); 
       Cons.RecordGuard(LAB.AppS(T.LabelOfTypeRepr(designations^.Guarding.TestTypeRepr),'$D'),ofs,-4,acodeIn,newReg,acode); 
    ELSE 
       acode:=acodeIn; 
    END;
    Cons.ContentOf(l,acode,dcode); 
    Cons.PointerFrom(dcode,acode); 
     ; 
 ;
      yyP44 := acode;
      yyP43 := designations^.Guarding.Nextion;
      RETURN;

  END;
(* line 1761 "CODE.tmp" *)
(* line 1761 "CODE.tmp" *)
      O.StrLn( "CodeLocalOpenDesignations.RecordTypeRepr" ) ; 
    idData.isStackObject         := TRUE; 
    Cons.Selector(-objOfs,acodeIn,idData.acodeToObjHeader);
    idData.ofsOfObjHeader        := objOfs-4; 
    idData.ofsOfObject           := objOfs; 

    Cons.ContentOf(l,acodeIn,dcode); 
    Cons.PointerFrom(dcode,acode); 
     ; 
 ;
      yyP44 := acode;
      yyP43 := designations;
      RETURN;

  END;
(* line 1772 "CODE.tmp" *)
(* line 1772 "CODE.tmp" *)
       O.StrLn( "CodeLocalOpenDesignations.Default" ) ; 
    Cons.ContentOf(l,acodeIn,dcode); 
    Cons.PointerFrom(dcode,acode); 
     ; 
 ;
      yyP44 := acode;
      yyP43 := designations;
      RETURN;

 END CodeLocalImplicitDesignations;

PROCEDURE CodeStackImplicitDesignations (type: OB.tOB; designations: Tree.tTree; VAR idData: tImplicitDesignationData; isWithed: BOOLEAN; objOfs: LONGINT; acodeIn: ACode; VAR yyP46: ACode; VAR yyP45: Tree.tTree);
(* line 1783 "CODE.tmp" *)
 VAR acode:ACode; dcode,headerBaseRegCode,objBaseRegCode,newReg:DCode; popcode:PopCode; tailDesignations:Tree.tTree; 
           ofs:LONGINT; dontCare:BOOLEAN; 
 BEGIN
  IF type = OB.NoOB THEN RETURN; END;
  IF designations = Tree.NoTree THEN RETURN; END;
  IF (type^.Kind = OB.ArrayTypeRepr) THEN
  IF (designations^.Kind = Tree.Indexing) THEN
(* line 1786 "CODE.tmp" *)
   LOOP
(* line 1786 "CODE.tmp" *)
      IF ~((type^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
(* line 1786 "CODE.tmp" *)
       O.StrLn( "CodeStackOpenDesignations.OpenIndex" ) ; 
    idData.isStackObject         := TRUE; 
    idData.acodeToObjHeader      := acodeIn;
    idData.ofsOfObjHeader        := objOfs; 
    idData.ofsOfObject           := objOfs; 
    idData.ofsOfLEN0             := objOfs+4+4*(SYSTEM.VAL(SHORTINT,T.IsOpenArrayType(type^.ArrayTypeRepr.elemTypeRepr))); 

    Cons.OpenIndexStart(acodeIn,headerBaseRegCode); 
    CodeOpenIndexing(type,designations,idData,(*isFirst:=*)TRUE,idData.ofsOfLEN0,headerBaseRegCode
    (* => *)        ,popcode,tailDesignations,dontCare);
    
    idData.codeToOpenIndexedElem := popcode;
    Cons.Selector(objOfs,acodeIn,acode); 
    Cons.ContentOf(l,acode,objBaseRegCode); 
    idData.codeToObjBaseReg      := objBaseRegCode; 
    Cons.OpenIndexApplication(popcode,objBaseRegCode,acode);
     ; 
 ;
      yyP46 := acode;
      yyP45 := tailDesignations;
      RETURN;
   END;

  END;
(* line 1805 "CODE.tmp" *)
   LOOP
(* line 1805 "CODE.tmp" *)
      IF ~((type^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
(* line 1805 "CODE.tmp" *)
       O.StrLn( "CodeStackOpenDesignations.Open" ) ; 
    idData.isStackObject         := TRUE; 
    idData.acodeToObjHeader      := acodeIn;
    idData.ofsOfObjHeader        := objOfs; 
    idData.ofsOfObject           := objOfs; 
    idData.ofsOfLEN0             := objOfs+4+4*(SYSTEM.VAL(SHORTINT,T.IsOpenArrayType(type^.ArrayTypeRepr.elemTypeRepr))); 

    Cons.Selector(objOfs,acodeIn,acode); 
    Cons.ContentOf(l,acode,dcode); 
    Cons.PointerFrom(dcode,acode); 
     ; 
 ;
      yyP46 := acode;
      yyP45 := designations;
      RETURN;
   END;

  END;
  IF (type^.Kind = OB.RecordTypeRepr) THEN
  IF (designations^.Kind = Tree.Guarding) THEN
(* line 1818 "CODE.tmp" *)
(* line 1818 "CODE.tmp" *)
      O.StrLn( "CodeStackImplicitDesignations.Guard" ) ; 
    idData.isStackObject         := TRUE; 
    idData.acodeToObjHeader      := acodeIn;
    idData.ofsOfObjHeader        := objOfs-4; 
    idData.ofsOfObject           := objOfs; 

    Cons.Selector(objOfs,acodeIn,acode); 
    IF (ADR.TTableElemOfsInTDesc(designations^.Guarding.StaticTypeRepr,designations^.Guarding.TestTypeRepr,ofs) OR isWithed) & (ofs#0) THEN 
       Cons.ConjureRegister(newReg); 
       Cons.RecordGuard(LAB.AppS(T.LabelOfTypeRepr(designations^.Guarding.TestTypeRepr),'$D'),ofs,-4,acode,newReg,acode); 
    END;
    Cons.ContentOf(l,acode,dcode); 
    Cons.PointerFrom(dcode,acode); 
     ; 
 ;
      yyP46 := acode;
      yyP45 := designations^.Guarding.Nextion;
      RETURN;

  END;
(* line 1834 "CODE.tmp" *)
(* line 1834 "CODE.tmp" *)
      O.StrLn( "CodeStackImplicitDesignations.RecordTypeRepr" ) ; 
    idData.isStackObject         := TRUE; 
    idData.acodeToObjHeader      := acodeIn;
    idData.ofsOfObjHeader        := objOfs-4; 
    idData.ofsOfObject           := objOfs; 

    Cons.Selector(objOfs,acodeIn,acode); 
    Cons.ContentOf(l,acode,dcode); 
    Cons.PointerFrom(dcode,acode); 
     ; 
 ;
      yyP46 := acode;
      yyP45 := designations;
      RETURN;

  END;
(* line 1846 "CODE.tmp" *)
(* line 1846 "CODE.tmp" *)
       O.StrLn( "CodeStackOpenDesignations.Default" ) ; 
    Cons.Selector(objOfs,acodeIn,acode); 
    Cons.ContentOf(l,acode,dcode); 
    Cons.PointerFrom(dcode,acode); 
     ; 
 ;
      yyP46 := acode;
      yyP45 := designations;
      RETURN;

 END CodeStackImplicitDesignations;

PROCEDURE CodeHeapImplicitDesignations (type: OB.tOB; designations: Tree.tTree; VAR idData: tImplicitDesignationData; objOfs: LONGINT; acodeIn: ACode; VAR yyP48: ACode; VAR yyP47: Tree.tTree);
(* line 1858 "CODE.tmp" *)
 VAR acode:ACode; dcode,headerBaseRegCode,objBaseRegCode:DCode; popcode:PopCode; tailDesignations:Tree.tTree; dontCare:BOOLEAN; 
 BEGIN
  IF type = OB.NoOB THEN RETURN; END;
  IF designations = Tree.NoTree THEN RETURN; END;
  IF (type^.Kind = OB.ArrayTypeRepr) THEN
  IF (designations^.Kind = Tree.Indexing) THEN
(* line 1860 "CODE.tmp" *)
   LOOP
(* line 1860 "CODE.tmp" *)
      IF ~((type^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
(* line 1860 "CODE.tmp" *)
       O.StrLn( "CodeHeapOpenDesignations.OpenIndex" ) ; 
    idData.typeOfObject          := type;
    idData.isStackObject         := FALSE; 
    idData.acodeToObjHeader      := acodeIn;
    idData.ofsOfObjHeader        := -4; 
    idData.ofsOfObject           := objOfs; 
    idData.ofsOfLEN0             := 4*SYSTEM.VAL(SHORTINT,T.IsOpenArrayType(type^.ArrayTypeRepr.elemTypeRepr)); 
    idData.nofOpenIndexings      := 0; 

    Cons.OpenIndexStart(acodeIn,headerBaseRegCode); 
    CodeOpenIndexing(type,designations,idData,(*isFirst:=*)TRUE,idData.ofsOfLEN0,headerBaseRegCode
    (* => *)        ,popcode,tailDesignations,dontCare);
    
    idData.codeToOpenIndexedElem := popcode;
    Cons.HeapOpenIndexApplication(objOfs,popcode,acode);
    
     ; 
 ;
      yyP48 := acode;
      yyP47 := tailDesignations;
      RETURN;
   END;

  END;
(* line 1879 "CODE.tmp" *)
   LOOP
(* line 1879 "CODE.tmp" *)
      IF ~((type^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
(* line 1879 "CODE.tmp" *)
       O.StrLn( "CodeHeapOpenDesignations.Open" ) ; 
    idData.typeOfObject          := type;
    idData.isStackObject         := FALSE; 
    idData.acodeToObjHeader      := acodeIn;
    idData.ofsOfObjHeader        := -4; 
    idData.ofsOfObject           := objOfs; 
    idData.ofsOfLEN0             := 4*SYSTEM.VAL(SHORTINT,T.IsOpenArrayType(type^.ArrayTypeRepr.elemTypeRepr)); 
    idData.nofOpenIndexings      := 0; 
    idData.codeToOpenIndexedElem := NIL;

    Cons.Selector(objOfs,acodeIn,acode);
     ; 
 ;
      yyP48 := acode;
      yyP47 := designations;
      RETURN;
   END;

  END;
(* line 1893 "CODE.tmp" *)
(* line 1893 "CODE.tmp" *)
       O.StrLn( "CodeHeapOpenDesignations.Default" ) ; 
    idData.typeOfObject          := type;
    idData.isStackObject         := FALSE; 
    idData.acodeToObjHeader      := NIL;
    idData.ofsOfObjHeader        := 0; 
    idData.ofsOfObject           := 0; 
    idData.ofsOfLEN0             := 0;
    idData.nofOpenIndexings      := 0; 
    idData.codeToOpenIndexedElem := NIL;

    Cons.Selector(objOfs,acodeIn,acode);
     ; 
 ;
      yyP48 := acode;
      yyP47 := designations;
      RETURN;

 END CodeHeapImplicitDesignations;

PROCEDURE CodeOpenIndexing (type: OB.tOB; designations: Tree.tTree; VAR idData: tImplicitDesignationData; isFirst: BOOLEAN; lenOfs: LONGINT; headerBaseRegCode: DCode; VAR yyP50: PopCode; VAR yyP49: Tree.tTree; VAR WasOpenIndexing: BOOLEAN);
(* line 1912 "CODE.tmp" *)
 VAR idxRegCode:DCode; popcode:PopCode; wasOpenIndexing:BOOLEAN; tailDesignations:Tree.tTree; 
 BEGIN
  IF type = OB.NoOB THEN RETURN; END;
  IF designations = Tree.NoTree THEN RETURN; END;
  IF (type^.Kind = OB.ArrayTypeRepr) THEN
  IF (designations^.Kind = Tree.Indexing) THEN
(* line 1914 "CODE.tmp" *)
   LOOP
(* line 1915 "CODE.tmp" *)
      IF ~((type^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
(* line 1915 "CODE.tmp" *)
       O.StrLn( "CodeOpenIndexing.OpenIndex" ) ; 
    INC(idData.nofOpenIndexings);
    
    CodeRExpr(designations^.Indexing.Expr^.Exprs.TypeReprOut,designations^.Indexing.Expr,CO.GetCoercion(designations^.Indexing.Expr^.Exprs.TypeReprOut,OB.cLongintTypeRepr),idxRegCode); 

    Cons.OpenIndexPush(lenOfs,headerBaseRegCode,idxRegCode,headerBaseRegCode); 
    CodeOpenIndexing(type^.ArrayTypeRepr.elemTypeRepr,designations^.Indexing.Nextion,idData,(*isFirst:=*)FALSE,lenOfs+4,headerBaseRegCode
    (* => *)        ,popcode,tailDesignations,wasOpenIndexing);
    
    Cons.OpenIndexPop(lenOfs,isFirst,~wasOpenIndexing,popcode,popcode);
     ; 
 ;
      yyP50 := popcode;
      yyP49 := tailDesignations;
      WasOpenIndexing := TRUE;
      RETURN;
   END;

  END;
  END;
(* line 1928 "CODE.tmp" *)
(* line 1928 "CODE.tmp" *)
       O.StrLn( "CodeOpenIndexing.Default" ) ; 
    CodeOpenIndexingBase(type,lenOfs,headerBaseRegCode,popcode);
     ; 
 ;
      yyP50 := popcode;
      yyP49 := designations;
      WasOpenIndexing := FALSE;
      RETURN;

 END CodeOpenIndexing;

PROCEDURE CodeOpenIndexingBase (type: OB.tOB; lenOfs: LONGINT; headerBaseRegCode: DCode; VAR yyP51: PopCode);
(* line 1937 "CODE.tmp" *)
 VAR lenAcode:ACode; sizeDcode,new1Reg,new2Reg,new3Reg:DCode; popcode:PopCode; 
 BEGIN
  IF type = OB.NoOB THEN RETURN; END;
  IF (type^.Kind = OB.ArrayTypeRepr) THEN
(* line 1939 "CODE.tmp" *)
   LOOP
(* line 1939 "CODE.tmp" *)
      IF ~((type^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
(* line 1939 "CODE.tmp" *)
       O.StrLn( "CodeOpenIndexingBase.OpenArray" ) ; 
    CodeOpenIndexingBase(type^.ArrayTypeRepr.elemTypeRepr,lenOfs+4,headerBaseRegCode,popcode);
    Cons.OpenIndexOpenBase(lenOfs,popcode,popcode);
     ; 
 ;
      yyP51 := popcode;
      RETURN;
   END;

  END;
  IF OB.IsType (type, OB.TypeRepr) THEN
(* line 1945 "CODE.tmp" *)
(* line 1945 "CODE.tmp" *)
       O.StrLn( "CodeOpenIndexingBase.Default" ) ; 
    Cons.ConjureRegister(new1Reg); Cons.ConjureRegister(new2Reg); Cons.ConjureRegister(new3Reg); 
    Cons.OpenIndexStaticBase(type^.TypeRepr.size,headerBaseRegCode,new1Reg,new2Reg,new3Reg,popcode); 
     ; 
 ;
      yyP51 := popcode;
      RETURN;

  END;
 END CodeOpenIndexingBase;

PROCEDURE CodeIndirectCall (procType: OB.tOB; argcodeIn: ArgCode; acodeIn: ACode; VAR yyP52: ACode);
(* line 1955 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; 
 BEGIN
  IF procType = OB.NoOB THEN RETURN; END;
  IF OB.IsType (procType, OB.ProcedureTypeRepr) THEN
(* line 1957 "CODE.tmp" *)
(* line 1957 "CODE.tmp" *)
       O.StrLn( "CodeIndirectCall" ) ; 
    Cons.ContentOf(l,acodeIn,dcode); 
    Cons.IndirectCall(procType^.ProcedureTypeRepr.paramSpace,dcode,argcodeIn,acode); 
     ; 
 ;
      yyP52 := acode;
      RETURN;

  END;
(* line 1963 "CODE.tmp" *)
(* line 1963 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeIndirectCall: failed'); ;
      yyP52 := NIL;
      RETURN;

 END CodeIndirectCall;

PROCEDURE CodeBoundCall (procEntry: OB.tOB; aRcvEntry: OB.tOB; rcvType: OB.tOB; curLevel: tLevel; bprocLab: tLabel; argcodeIn: ArgCode; acodeIn: ACode; VAR yyP53: ACode);
(* line 1970 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; 
 BEGIN
  IF procEntry = OB.NoOB THEN RETURN; END;
  IF aRcvEntry = OB.NoOB THEN RETURN; END;
  IF rcvType = OB.NoOB THEN RETURN; END;
  IF (procEntry^.Kind = OB.BoundProcEntry) THEN
  IF (procEntry^.BoundProcEntry.receiverSig^.Kind = OB.Signature) THEN
  IF OB.IsType (procEntry^.BoundProcEntry.typeRepr, OB.ProcedureTypeRepr) THEN
  IF (aRcvEntry^.Kind = OB.VarEntry) THEN
(* line 1972 "CODE.tmp" *)
(* line 1978 "CODE.tmp" *)
       O.StrLn( "CodeBoundCall" ) ; 
    CodeBoundCall1(  procEntry^.BoundProcEntry.receiverSig^.Signature.VarEntry^.VarEntry.typeRepr
                  ,  T.ElemTypeOfArrayType(aRcvEntry^.VarEntry.typeRepr)
                  ,  aRcvEntry
                  ,  curLevel
                  ,  bprocLab
                  ,  procEntry^.BoundProcEntry.procNum
                  ,  procEntry^.BoundProcEntry.typeRepr^.ProcedureTypeRepr.paramSpace
                  ,  argcodeIn
                  ,  acodeIn
                  ,  acode); 
     ; 
 ;
      yyP53 := acode;
      RETURN;

  END;
  END;
  END;
  END;
(* line 1992 "CODE.tmp" *)
(* line 1992 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeBoundCall: failed'); ;
      yyP53 := NIL;
      RETURN;

 END CodeBoundCall;

PROCEDURE CodeBoundCall1 (formalType: OB.tOB; actualType: OB.tOB; actualEntry: OB.tOB; curLevel: tLevel; bprocLab: tLabel; procNum: LONGINT; paramSpace: LONGINT; argcodeIn: ArgCode; acodeIn: ACode; VAR yyP54: ACode);
(* line 2007 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; argcode:ArgCode; 
 BEGIN
  IF formalType = OB.NoOB THEN RETURN; END;
  IF actualType = OB.NoOB THEN RETURN; END;
  IF actualEntry = OB.NoOB THEN RETURN; END;
  IF (formalType^.Kind = OB.PointerTypeRepr) THEN
  IF (actualType^.Kind = OB.PointerTypeRepr) THEN
(* line 2009 "CODE.tmp" *)
(* line 2009 "CODE.tmp" *)
       O.StrLn( "CodeBoundCall1.Ptr_Ptr" ) ; 
    Cons.AddressOf(acodeIn,dcode); 
    Cons.BoundCall_FPtr_APtr(bprocLab,LIM.OffsetOfProcTab-4*procNum,paramSpace,dcode,argcodeIn,acode); 
     ; 
 ;
      yyP54 := acode;
      RETURN;

  END;
  END;
  IF (formalType^.Kind = OB.RecordTypeRepr) THEN
  IF (actualType^.Kind = OB.PointerTypeRepr) THEN
(* line 2015 "CODE.tmp" *)
(* line 2015 "CODE.tmp" *)
       O.StrLn( "CodeBoundCall1.Rec_Ptr" ) ; 
    Cons.AddressOf(acodeIn,dcode); 
    Cons.BoundCall_FRec_APtr(bprocLab,LIM.OffsetOfProcTab-4*procNum,paramSpace,dcode,argcodeIn,acode);
     ; 
 ;
      yyP54 := acode;
      RETURN;

  END;
  IF (actualType^.Kind = OB.RecordTypeRepr) THEN
(* line 2021 "CODE.tmp" *)
(* line 2021 "CODE.tmp" *)
       O.StrLn( "CodeBoundCall1.Rec_Rec" ) ; 
    Cons.AddressOf(acodeIn,dcode); 
    Cons.Param(argcodeIn,dcode,argcode); 

    CodeTagFieldOfRecVar(actualEntry,actualType,curLevel,dcode); 
    Cons.BoundCall_FRec_ARec(bprocLab,LIM.OffsetOfProcTab-4*procNum,paramSpace,dcode,argcode,acode); 
     ; 
 ;
      yyP54 := acode;
      RETURN;

  END;
  END;
(* line 2030 "CODE.tmp" *)
(* line 2030 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeBoundCall1: failed'); ;
      yyP54 := NIL;
      RETURN;

 END CodeBoundCall1;

PROCEDURE CodeTagFieldOfRecVar (yyP55: OB.tOB; type: OB.tOB; curLevel: tLevel; VAR yyP56: DCode);
(* line 2036 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; 
 BEGIN
  IF yyP55 = OB.NoOB THEN RETURN; END;
  IF type = OB.NoOB THEN RETURN; END;
  IF (yyP55^.Kind = OB.VarEntry) THEN
  IF (yyP55^.VarEntry.typeRepr^.Kind = OB.RecordTypeRepr) THEN
(* line 2038 "CODE.tmp" *)
   LOOP
(* line 2039 "CODE.tmp" *)
      IF ~((yyP55^.VarEntry.parMode = OB . REFPAR)) THEN EXIT; END;
(* line 2039 "CODE.tmp" *)
       O.StrLn( "CodeTagFieldOfRecVar.VarPar" ) ; 
    IF yyP55^.VarEntry.level=curLevel THEN
       Cons.LocalVariable(yyP55^.VarEntry.address-4,Idents.NoIdent,acode); 
    ELSE
       Cons.LocalVariable(-4*(1+yyP55^.VarEntry.level-OB.MODULELEVEL),Idents.NoIdent,acode); 
       Cons.ContentOf(l,acode,dcode); 
       Cons.PointerFrom(dcode,acode); 
       Cons.Selector(yyP55^.VarEntry.address-4,acode,acode); 
    END;
    Cons.ContentOf(l,acode,dcode); 
     ; 
 ;
      yyP56 := dcode;
      RETURN;
   END;

  END;
  END;
  IF (type^.Kind = OB.RecordTypeRepr) THEN
(* line 2052 "CODE.tmp" *)
(* line 2052 "CODE.tmp" *)
       O.StrLn( "CodeTagFieldOfRecVar.ConstType" ) ; 
    Cons.GlobalVariable(LAB.AppS(T.LabelOfTypeRepr(type),'$D'),0,Idents.NoIdent,acode); 
    Cons.AddressOf(acode,dcode); 
     ; 
 ;
      yyP56 := dcode;
      RETURN;

  END;
(* line 2058 "CODE.tmp" *)
(* line 2058 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeTagFieldOfRecVar: failed'); ;
      yyP56 := NIL;
      RETURN;

 END CodeTagFieldOfRecVar;

PROCEDURE CodePredeclFuncs (yyP57: Tree.tTree; dstType: OB.tOB; VAR yyP58: DCode);
(* line 2066 "CODE.tmp" *)
 VAR acode:ACode; dcode,dcode1,dcode2:DCode; idData:tImplicitDesignationData; retypecode:RetypeCode; 
 BEGIN
  IF yyP57 = Tree.NoTree THEN RETURN; END;
  IF dstType = OB.NoOB THEN RETURN; END;

  CASE yyP57^.Kind OF
  | Tree.AbsArgumenting:
(* line 2068 "CODE.tmp" *)
(* line 2068 "CODE.tmp" *)
       O.StrLn( "PredeclFuncs.ABS" ) ; 
    CodeRExpr(yyP57^.AbsArgumenting.Expr^.Exprs.TypeReprOut,yyP57^.AbsArgumenting.Expr,OB.cmtCoercion,dcode); 
    IF ARG.OptionRangeChecking & T.IsIntegerType(yyP57^.AbsArgumenting.Expr^.Exprs.TypeReprOut) THEN Cons.MinIntCheck(LAB.AbsFault,dcode,dcode); END;
    Cons.Abs(dcode,dcode); 
     ; 
 ;
      yyP58 := dcode;
      RETURN;

  | Tree.AshArgumenting:
(* line 2075 "CODE.tmp" *)
(* line 2075 "CODE.tmp" *)
       O.StrLn( "PredeclFuncs.ASH" ) ; 
    CodeRExpr(yyP57^.AshArgumenting.Expr1^.Exprs.TypeReprOut,yyP57^.AshArgumenting.Expr1,OB.cmtCoercion,dcode1); 
    Cons.Int2Longint(dcode1,dcode1); 
    CodeSecondShiftOperand(yyP57^.AshArgumenting.Expr2^.Exprs.ValueReprOut,yyP57^.AshArgumenting.Expr2^.Exprs.TypeReprOut,yyP57^.AshArgumenting.Expr2,dcode2); 
    Cons.Ash(dcode1,dcode2,dcode); 
     ; 
 ;
      yyP58 := dcode;
      RETURN;

  | Tree.CapArgumenting:
(* line 2083 "CODE.tmp" *)
(* line 2083 "CODE.tmp" *)
       O.StrLn( "PredeclFuncs.CAP" ) ; 
    CodeRExpr(yyP57^.CapArgumenting.Expr^.Exprs.TypeReprOut,yyP57^.CapArgumenting.Expr,OB.cmtCoercion,dcode); 
    Cons.Cap(dcode,dcode);
     ; 
 ;
      yyP58 := dcode;
      RETURN;

  | Tree.ChrArgumenting:
(* line 2089 "CODE.tmp" *)
(* line 2089 "CODE.tmp" *)
       O.StrLn( "PredeclFuncs.CHR" ) ; 
    CodeRExpr(yyP57^.ChrArgumenting.Expr^.Exprs.TypeReprOut,yyP57^.ChrArgumenting.Expr,OB.cmtCoercion,dcode); 
    IF ARG.OptionRangeChecking THEN Cons.ChrRangeCheck(dcode,dcode); END;
    Cons.Int2Shortint(dcode,dcode);
     ; 
 ;
      yyP58 := dcode;
      RETURN;

  | Tree.EntierArgumenting:
(* line 2096 "CODE.tmp" *)
(* line 2096 "CODE.tmp" *)
       O.StrLn( "PredeclFuncs.ENTIER" ) ; 
    CodeRExpr(yyP57^.EntierArgumenting.Expr^.Exprs.TypeReprOut,yyP57^.EntierArgumenting.Expr,OB.cmtCoercion,dcode); 
    Cons.Entier(dcode,dcode);
     ; 
 ;
      yyP58 := dcode;
      RETURN;

  | Tree.LenArgumenting:
  IF (yyP57^.LenArgumenting.Expr1^.Kind = Tree.DesignExpr) THEN
(* line 2102 "CODE.tmp" *)
(* line 2102 "CODE.tmp" *)
       O.StrLn( "CodePredeclFuncs.LEN" ) ;
    CodeImplicitLDesignator(yyP57^.LenArgumenting.Expr1^.DesignExpr.Designator,idData,acode);
    Cons.Selector(idData.ofsOfLEN0+4*(idData.nofOpenIndexings+V.ValueOfInteger(yyP57^.LenArgumenting.Expr2^.Exprs.ValueReprOut)),idData.acodeToObjHeader,acode); 
    Cons.ContentOf(l,acode,dcode); 
 ;
      yyP58 := dcode;
      RETURN;

  END;
  | Tree.LongArgumenting:
  IF (dstType^.Kind = OB.IntegerTypeRepr) THEN
(* line 2108 "CODE.tmp" *)
(* line 2108 "CODE.tmp" *)
       O.StrLn( "PredeclFuncs.LONG->INTEGER" ) ; 
    CodeRExpr(yyP57^.LongArgumenting.Expr^.Exprs.TypeReprOut,yyP57^.LongArgumenting.Expr,OB.cmtCoercion,dcode); 
    Cons.Int2Integer(dcode,dcode);
     ; 
 ;
      yyP58 := dcode;
      RETURN;

  END;
  IF (dstType^.Kind = OB.LongintTypeRepr) THEN
(* line 2114 "CODE.tmp" *)
(* line 2114 "CODE.tmp" *)
       O.StrLn( "PredeclFuncs.LONG->LONGINT" ) ; 
    CodeRExpr(yyP57^.LongArgumenting.Expr^.Exprs.TypeReprOut,yyP57^.LongArgumenting.Expr,OB.cmtCoercion,dcode); 
    Cons.Int2Longint(dcode,dcode);
     ; 
 ;
      yyP58 := dcode;
      RETURN;

  END;
  IF (dstType^.Kind = OB.LongrealTypeRepr) THEN
(* line 2120 "CODE.tmp" *)
(* line 2120 "CODE.tmp" *)
       O.StrLn( "PredeclFuncs.LONG->LONGREAL" ) ; 
    CodeRExpr(yyP57^.LongArgumenting.Expr^.Exprs.TypeReprOut,yyP57^.LongArgumenting.Expr,OB.cmtCoercion,dcode); 
    Cons.Real2Longreal(dcode,dcode);
     ; 
 ;
      yyP58 := dcode;
      RETURN;

  END;
  | Tree.OrdArgumenting:
(* line 2134 "CODE.tmp" *)
(* line 2134 "CODE.tmp" *)
       O.StrLn( "PredeclFuncs.ORD" ) ; 
    CodeRExpr(yyP57^.OrdArgumenting.Expr^.Exprs.TypeReprOut,yyP57^.OrdArgumenting.Expr,OB.cmtCoercion,dcode); 
    Cons.Card2Integer(dcode,dcode);
     ; 
 ;
      yyP58 := dcode;
      RETURN;

  | Tree.ShortArgumenting:
  IF (dstType^.Kind = OB.ShortintTypeRepr) THEN
(* line 2140 "CODE.tmp" *)
(* line 2140 "CODE.tmp" *)
       O.StrLn( "PredeclFuncs.SHORT->SHORTINT" ) ; 
    CodeRExpr(yyP57^.ShortArgumenting.Expr^.Exprs.TypeReprOut,yyP57^.ShortArgumenting.Expr,OB.cmtCoercion,dcode); 
    IF ARG.OptionRangeChecking THEN Cons.ShortRangeCheck(dcode,dcode); END;
    Cons.Int2Shortint(dcode,dcode);
     ; 
 ;
      yyP58 := dcode;
      RETURN;

  END;
  IF (dstType^.Kind = OB.IntegerTypeRepr) THEN
(* line 2147 "CODE.tmp" *)
(* line 2147 "CODE.tmp" *)
       O.StrLn( "PredeclFuncs.SHORT->INTEGER" ) ; 
    CodeRExpr(yyP57^.ShortArgumenting.Expr^.Exprs.TypeReprOut,yyP57^.ShortArgumenting.Expr,OB.cmtCoercion,dcode); 
    IF ARG.OptionRangeChecking THEN Cons.ShortRangeCheck(dcode,dcode); END;
    Cons.Int2Integer(dcode,dcode);
     ; 
 ;
      yyP58 := dcode;
      RETURN;

  END;
  IF (dstType^.Kind = OB.RealTypeRepr) THEN
(* line 2154 "CODE.tmp" *)
(* line 2154 "CODE.tmp" *)
       O.StrLn( "PredeclFuncs.SHORT->REAL" ) ; 
    CodeRExpr(yyP57^.ShortArgumenting.Expr^.Exprs.TypeReprOut,yyP57^.ShortArgumenting.Expr,OB.cmtCoercion,dcode); 
    Cons.Longreal2Real(dcode,dcode);
     ; 
 ;
      yyP58 := dcode;
      RETURN;

  END;
  | Tree.SysAdrArgumenting:
  IF (yyP57^.SysAdrArgumenting.Expr^.Kind = Tree.DesignExpr) THEN
(* line 2165 "CODE.tmp" *)
(* line 2165 "CODE.tmp" *)
       O.StrLn( "PredeclFuncs.SYSTEM.ADR" ) ; 
    CodeLDesignator(yyP57^.SysAdrArgumenting.Expr^.DesignExpr.Designator,acode); 
    Cons.AddressOf(acode,dcode);
     ; 
 ;
      yyP58 := dcode;
      RETURN;

  END;
  | Tree.SysLshArgumenting:
(* line 2176 "CODE.tmp" *)
(* line 2176 "CODE.tmp" *)
       O.StrLn( "PredeclFuncs.SYSTEM.LSH" ) ; 
    CodeRExpr(yyP57^.SysLshArgumenting.Expr1^.Exprs.TypeReprOut,yyP57^.SysLshArgumenting.Expr1,OB.cmtCoercion,dcode1); 
    CodeSecondShiftOperand(yyP57^.SysLshArgumenting.Expr2^.Exprs.ValueReprOut,yyP57^.SysLshArgumenting.Expr2^.Exprs.TypeReprOut,yyP57^.SysLshArgumenting.Expr2,dcode2); 
    Cons.ShiftOrRotate(shl,dcode1,dcode2,dcode); 
     ; 
 ;
      yyP58 := dcode;
      RETURN;

  | Tree.SysRotArgumenting:
(* line 2183 "CODE.tmp" *)
(* line 2183 "CODE.tmp" *)
       O.StrLn( "PredeclFuncs.SYSTEM.ROT" ) ; 
    CodeRExpr(yyP57^.SysRotArgumenting.Expr1^.Exprs.TypeReprOut,yyP57^.SysRotArgumenting.Expr1,OB.cmtCoercion,dcode1); 
    CodeSecondShiftOperand(yyP57^.SysRotArgumenting.Expr2^.Exprs.ValueReprOut,yyP57^.SysRotArgumenting.Expr2^.Exprs.TypeReprOut,yyP57^.SysRotArgumenting.Expr2,dcode2); 
    Cons.ShiftOrRotate(rol,dcode1,dcode2,dcode); 
     ; 
 ;
      yyP58 := dcode;
      RETURN;

  | Tree.SysValArgumenting:
(* line 2190 "CODE.tmp" *)
(* line 2190 "CODE.tmp" *)
       O.StrLn( "PredeclFuncs.SYSTEM.VAL" ) ; 
    CodeSysValSource(yyP57^.SysValArgumenting.Expr^.Exprs.TypeReprOut,yyP57^.SysValArgumenting.TypeTypeRepr,yyP57^.SysValArgumenting.Expr,yyP57^.SysValArgumenting.TempAddr,retypecode); 
    CodeSysValRDestination(yyP57^.SysValArgumenting.TypeTypeRepr,retypecode,dcode); 
 ;
      yyP58 := dcode;
      RETURN;

  ELSE END;

(* line 2196 "CODE.tmp" *)
(* line 2196 "CODE.tmp" *)
       ERR.Fatal('CODE.CodePredeclFuncs: failed'); ;
      yyP58 := NIL;
      RETURN;

 END CodePredeclFuncs;

PROCEDURE CodeSysValSource (srcType: OB.tOB; dstType: OB.tOB; expr: Tree.tTree; tmpOfs: LONGINT; VAR yyP59: RetypeCode);
(* line 2202 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; retypecode:RetypeCode; 
 BEGIN
  IF srcType = OB.NoOB THEN RETURN; END;
  IF dstType = OB.NoOB THEN RETURN; END;
  IF expr = Tree.NoTree THEN RETURN; END;

  CASE srcType^.Kind OF
  | OB.ByteTypeRepr:
  IF OB.IsType (dstType, OB.TypeRepr) THEN
(* line 2204 "CODE.tmp" *)
(* line 2217 "CODE.tmp" *)
       O.StrLn( "CodeSysValSource.RegisteredFloat" ) ; 
    CodeRExpr(srcType,expr,OB.cmtCoercion,dcode); 
    Cons.Data2Retype(srcType^.ByteTypeRepr.size,dstType^.TypeRepr.size,tmpOfs,dcode,retypecode); 
 ;
      yyP59 := retypecode;
      RETURN;

  END;
  | OB.PtrTypeRepr:
  IF OB.IsType (dstType, OB.TypeRepr) THEN
(* line 2204 "CODE.tmp" *)
(* line 2217 "CODE.tmp" *)
       O.StrLn( "CodeSysValSource.RegisteredFloat" ) ; 
    CodeRExpr(srcType,expr,OB.cmtCoercion,dcode); 
    Cons.Data2Retype(srcType^.PtrTypeRepr.size,dstType^.TypeRepr.size,tmpOfs,dcode,retypecode); 
 ;
      yyP59 := retypecode;
      RETURN;

  END;
  | OB.BooleanTypeRepr:
  IF OB.IsType (dstType, OB.TypeRepr) THEN
(* line 2204 "CODE.tmp" *)
(* line 2217 "CODE.tmp" *)
       O.StrLn( "CodeSysValSource.RegisteredFloat" ) ; 
    CodeRExpr(srcType,expr,OB.cmtCoercion,dcode); 
    Cons.Data2Retype(srcType^.BooleanTypeRepr.size,dstType^.TypeRepr.size,tmpOfs,dcode,retypecode); 
 ;
      yyP59 := retypecode;
      RETURN;

  END;
  | OB.CharTypeRepr:
  IF OB.IsType (dstType, OB.TypeRepr) THEN
(* line 2204 "CODE.tmp" *)
(* line 2217 "CODE.tmp" *)
       O.StrLn( "CodeSysValSource.RegisteredFloat" ) ; 
    CodeRExpr(srcType,expr,OB.cmtCoercion,dcode); 
    Cons.Data2Retype(srcType^.CharTypeRepr.size,dstType^.TypeRepr.size,tmpOfs,dcode,retypecode); 
 ;
      yyP59 := retypecode;
      RETURN;

  END;
  | OB.CharStringTypeRepr:
  IF OB.IsType (dstType, OB.TypeRepr) THEN
(* line 2204 "CODE.tmp" *)
(* line 2217 "CODE.tmp" *)
       O.StrLn( "CodeSysValSource.RegisteredFloat" ) ; 
    CodeRExpr(srcType,expr,OB.cmtCoercion,dcode); 
    Cons.Data2Retype(srcType^.CharStringTypeRepr.size,dstType^.TypeRepr.size,tmpOfs,dcode,retypecode); 
 ;
      yyP59 := retypecode;
      RETURN;

  END;
  | OB.SetTypeRepr:
  IF OB.IsType (dstType, OB.TypeRepr) THEN
(* line 2204 "CODE.tmp" *)
(* line 2217 "CODE.tmp" *)
       O.StrLn( "CodeSysValSource.RegisteredFloat" ) ; 
    CodeRExpr(srcType,expr,OB.cmtCoercion,dcode); 
    Cons.Data2Retype(srcType^.SetTypeRepr.size,dstType^.TypeRepr.size,tmpOfs,dcode,retypecode); 
 ;
      yyP59 := retypecode;
      RETURN;

  END;
  | OB.ShortintTypeRepr:
  IF OB.IsType (dstType, OB.TypeRepr) THEN
(* line 2204 "CODE.tmp" *)
(* line 2217 "CODE.tmp" *)
       O.StrLn( "CodeSysValSource.RegisteredFloat" ) ; 
    CodeRExpr(srcType,expr,OB.cmtCoercion,dcode); 
    Cons.Data2Retype(srcType^.ShortintTypeRepr.size,dstType^.TypeRepr.size,tmpOfs,dcode,retypecode); 
 ;
      yyP59 := retypecode;
      RETURN;

  END;
  | OB.IntegerTypeRepr:
  IF OB.IsType (dstType, OB.TypeRepr) THEN
(* line 2204 "CODE.tmp" *)
(* line 2217 "CODE.tmp" *)
       O.StrLn( "CodeSysValSource.RegisteredFloat" ) ; 
    CodeRExpr(srcType,expr,OB.cmtCoercion,dcode); 
    Cons.Data2Retype(srcType^.IntegerTypeRepr.size,dstType^.TypeRepr.size,tmpOfs,dcode,retypecode); 
 ;
      yyP59 := retypecode;
      RETURN;

  END;
  | OB.LongintTypeRepr:
  IF OB.IsType (dstType, OB.TypeRepr) THEN
(* line 2204 "CODE.tmp" *)
(* line 2217 "CODE.tmp" *)
       O.StrLn( "CodeSysValSource.RegisteredFloat" ) ; 
    CodeRExpr(srcType,expr,OB.cmtCoercion,dcode); 
    Cons.Data2Retype(srcType^.LongintTypeRepr.size,dstType^.TypeRepr.size,tmpOfs,dcode,retypecode); 
 ;
      yyP59 := retypecode;
      RETURN;

  END;
  | OB.NilTypeRepr:
  IF OB.IsType (dstType, OB.TypeRepr) THEN
(* line 2204 "CODE.tmp" *)
(* line 2217 "CODE.tmp" *)
       O.StrLn( "CodeSysValSource.RegisteredFloat" ) ; 
    CodeRExpr(srcType,expr,OB.cmtCoercion,dcode); 
    Cons.Data2Retype(srcType^.NilTypeRepr.size,dstType^.TypeRepr.size,tmpOfs,dcode,retypecode); 
 ;
      yyP59 := retypecode;
      RETURN;

  END;
  | OB.PointerTypeRepr:
  IF OB.IsType (dstType, OB.TypeRepr) THEN
(* line 2204 "CODE.tmp" *)
(* line 2217 "CODE.tmp" *)
       O.StrLn( "CodeSysValSource.RegisteredFloat" ) ; 
    CodeRExpr(srcType,expr,OB.cmtCoercion,dcode); 
    Cons.Data2Retype(srcType^.PointerTypeRepr.size,dstType^.TypeRepr.size,tmpOfs,dcode,retypecode); 
 ;
      yyP59 := retypecode;
      RETURN;

  END;
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
  IF OB.IsType (dstType, OB.TypeRepr) THEN
(* line 2204 "CODE.tmp" *)
(* line 2217 "CODE.tmp" *)
       O.StrLn( "CodeSysValSource.RegisteredFloat" ) ; 
    CodeRExpr(srcType,expr,OB.cmtCoercion,dcode); 
    Cons.Data2Retype(srcType^.ProcedureTypeRepr.size,dstType^.TypeRepr.size,tmpOfs,dcode,retypecode); 
 ;
      yyP59 := retypecode;
      RETURN;

  END;
  | OB.RealTypeRepr:
  IF OB.IsType (dstType, OB.TypeRepr) THEN
(* line 2204 "CODE.tmp" *)
(* line 2217 "CODE.tmp" *)
       O.StrLn( "CodeSysValSource.RegisteredFloat" ) ; 
    CodeRExpr(srcType,expr,OB.cmtCoercion,dcode); 
    Cons.Data2Retype(srcType^.RealTypeRepr.size,dstType^.TypeRepr.size,tmpOfs,dcode,retypecode); 
 ;
      yyP59 := retypecode;
      RETURN;

  END;
  | OB.LongrealTypeRepr:
  IF OB.IsType (dstType, OB.TypeRepr) THEN
(* line 2204 "CODE.tmp" *)
(* line 2217 "CODE.tmp" *)
       O.StrLn( "CodeSysValSource.RegisteredFloat" ) ; 
    CodeRExpr(srcType,expr,OB.cmtCoercion,dcode); 
    Cons.Data2Retype(srcType^.LongrealTypeRepr.size,dstType^.TypeRepr.size,tmpOfs,dcode,retypecode); 
 ;
      yyP59 := retypecode;
      RETURN;

  END;
  | OB.StringTypeRepr:
  IF OB.IsType (dstType, OB.TypeRepr) THEN
(* line 2222 "CODE.tmp" *)
(* line 2222 "CODE.tmp" *)
       O.StrLn( "CodeSysValSource.String" ) ; 
    CodeValue(expr^.Exprs.ValueReprOut,srcType,OB.cmtCoercion,dcode); 
    Cons.PointerFrom(dcode,acode); 
    Cons.Addr2Retype(1+V.LengthOfString(expr^.Exprs.ValueReprOut),dstType^.TypeRepr.size,tmpOfs,acode,retypecode); 
 ;
      yyP59 := retypecode;
      RETURN;

  END;
  ELSE END;

  IF OB.IsType (srcType, OB.TypeRepr) THEN
  IF OB.IsType (dstType, OB.TypeRepr) THEN
  IF (expr^.Kind = Tree.DesignExpr) THEN
(* line 2228 "CODE.tmp" *)
(* line 2228 "CODE.tmp" *)
       O.StrLn( "CodeSysValSource.Structured" ) ; 
    CodeLDesignator(expr^.DesignExpr.Designator,acode); 
    Cons.Addr2Retype(srcType^.TypeRepr.size,dstType^.TypeRepr.size,tmpOfs,acode,retypecode); 
 ;
      yyP59 := retypecode;
      RETURN;

  END;
  END;
  END;
(* line 2233 "CODE.tmp" *)
(* line 2233 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeSysValSource: failed'); ;
      yyP59 := NIL;
      RETURN;

 END CodeSysValSource;

PROCEDURE CodeSysValRDestination (dstType: OB.tOB; retypecode: RetypeCode; VAR yyP60: DCode);
(* line 2239 "CODE.tmp" *)
 VAR dcode:DCode; 
 BEGIN
  IF dstType = OB.NoOB THEN RETURN; END;

  CASE dstType^.Kind OF
  | OB.ByteTypeRepr:
(* line 2241 "CODE.tmp" *)
(* line 2250 "CODE.tmp" *)
       O.StrLn( "CodeSysValRDestination.Registered" ) ; 
    Cons.Retype2Data(retypecode,dcode); 
 ;
      yyP60 := dcode;
      RETURN;

  | OB.PtrTypeRepr:
(* line 2241 "CODE.tmp" *)
(* line 2250 "CODE.tmp" *)
       O.StrLn( "CodeSysValRDestination.Registered" ) ; 
    Cons.Retype2Data(retypecode,dcode); 
 ;
      yyP60 := dcode;
      RETURN;

  | OB.BooleanTypeRepr:
(* line 2241 "CODE.tmp" *)
(* line 2250 "CODE.tmp" *)
       O.StrLn( "CodeSysValRDestination.Registered" ) ; 
    Cons.Retype2Data(retypecode,dcode); 
 ;
      yyP60 := dcode;
      RETURN;

  | OB.CharTypeRepr:
(* line 2241 "CODE.tmp" *)
(* line 2250 "CODE.tmp" *)
       O.StrLn( "CodeSysValRDestination.Registered" ) ; 
    Cons.Retype2Data(retypecode,dcode); 
 ;
      yyP60 := dcode;
      RETURN;

  | OB.SetTypeRepr:
(* line 2241 "CODE.tmp" *)
(* line 2250 "CODE.tmp" *)
       O.StrLn( "CodeSysValRDestination.Registered" ) ; 
    Cons.Retype2Data(retypecode,dcode); 
 ;
      yyP60 := dcode;
      RETURN;

  | OB.ShortintTypeRepr:
(* line 2241 "CODE.tmp" *)
(* line 2250 "CODE.tmp" *)
       O.StrLn( "CodeSysValRDestination.Registered" ) ; 
    Cons.Retype2Data(retypecode,dcode); 
 ;
      yyP60 := dcode;
      RETURN;

  | OB.IntegerTypeRepr:
(* line 2241 "CODE.tmp" *)
(* line 2250 "CODE.tmp" *)
       O.StrLn( "CodeSysValRDestination.Registered" ) ; 
    Cons.Retype2Data(retypecode,dcode); 
 ;
      yyP60 := dcode;
      RETURN;

  | OB.LongintTypeRepr:
(* line 2241 "CODE.tmp" *)
(* line 2250 "CODE.tmp" *)
       O.StrLn( "CodeSysValRDestination.Registered" ) ; 
    Cons.Retype2Data(retypecode,dcode); 
 ;
      yyP60 := dcode;
      RETURN;

  | OB.PointerTypeRepr:
(* line 2241 "CODE.tmp" *)
(* line 2250 "CODE.tmp" *)
       O.StrLn( "CodeSysValRDestination.Registered" ) ; 
    Cons.Retype2Data(retypecode,dcode); 
 ;
      yyP60 := dcode;
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
(* line 2241 "CODE.tmp" *)
(* line 2250 "CODE.tmp" *)
       O.StrLn( "CodeSysValRDestination.Registered" ) ; 
    Cons.Retype2Data(retypecode,dcode); 
 ;
      yyP60 := dcode;
      RETURN;

  | OB.RealTypeRepr:
(* line 2254 "CODE.tmp" *)
(* line 2255 "CODE.tmp" *)
       O.StrLn( "CodeSysValRDestination.Longreal" ) ; 
    Cons.Retype2Float(retypecode,dcode); 
 ;
      yyP60 := dcode;
      RETURN;

  | OB.LongrealTypeRepr:
(* line 2254 "CODE.tmp" *)
(* line 2255 "CODE.tmp" *)
       O.StrLn( "CodeSysValRDestination.Longreal" ) ; 
    Cons.Retype2Float(retypecode,dcode); 
 ;
      yyP60 := dcode;
      RETURN;

  ELSE END;

(* line 2259 "CODE.tmp" *)
(* line 2259 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeSysValRDestination: failed'); ;
      yyP60 := NIL;
      RETURN;

 END CodeSysValRDestination;

PROCEDURE CodeSecondShiftOperand (yyP61: OB.tOB; type: OB.tOB; expr: Tree.tTree; VAR yyP62: DCode);
(* line 2265 "CODE.tmp" *)
 VAR dcode:DCode; 
 BEGIN
  IF yyP61 = OB.NoOB THEN RETURN; END;
  IF type = OB.NoOB THEN RETURN; END;
  IF expr = Tree.NoTree THEN RETURN; END;
  IF (yyP61^.Kind = OB.IntegerValue) THEN
(* line 2267 "CODE.tmp" *)
(* line 2267 "CODE.tmp" *)
                        
    Cons.LongintConst(yyP61^.IntegerValue.v,dcode);                    
 ;
      yyP62 := dcode;
      RETURN;

  END;
(* line 2271 "CODE.tmp" *)
(* line 2271 "CODE.tmp" *)
      
    CodeRExpr(type,expr,OB.cmtCoercion,dcode); 
 ;
      yyP62 := dcode;
      RETURN;

 END CodeSecondShiftOperand;

PROCEDURE CodePredeclProcs (yyP63: Tree.tTree);
(* line 2281 "CODE.tmp" *)
 VAR acode,srcAcode,dstAcode:ACode; dcode,srcDcode,dstDcode,lenDcode:DCode; len:LONGINT; 
 BEGIN
  IF yyP63 = Tree.NoTree THEN RETURN; END;

  CASE yyP63^.Kind OF
  | Tree.AssertArgumenting:
(* line 2283 "CODE.tmp" *)
(* line 2283 "CODE.tmp" *)
       O.StrLn( "CodePredeclProcs.AssertArgumenting" ) ;
    IF ARG.OptionAssertionChecking THEN 
       CodeAssert(yyP63^.AssertArgumenting.Expr1^.Exprs.ValueReprOut,yyP63^.AssertArgumenting.Expr1,V.ValueOfInteger(yyP63^.AssertArgumenting.Expr2^.Exprs.ValueReprOut)); 
    END;
 ;
      RETURN;

  | Tree.CopyArgumenting:
  IF (yyP63^.CopyArgumenting.Expr2^.Kind = Tree.DesignExpr) THEN
(* line 2289 "CODE.tmp" *)
(* line 2290 "CODE.tmp" *)
       O.StrLn( "CodePredeclProcs.COPY" ) ;
    CodeStringCopy(yyP63^.CopyArgumenting.Expr1^.Exprs.ValueReprOut,yyP63^.CopyArgumenting.Expr1,yyP63^.CopyArgumenting.Expr2^.DesignExpr.TypeReprOut,yyP63^.CopyArgumenting.Expr1^.Exprs.TypeReprOut,yyP63^.CopyArgumenting.Expr2^.DesignExpr.Designator);
 ;
      RETURN;

  END;
  | Tree.DecArgumenting:
  IF (yyP63^.DecArgumenting.Expr1^.Kind = Tree.DesignExpr) THEN
  IF (yyP63^.DecArgumenting.Expr2^.Kind = Tree.mtExpr) THEN
(* line 2294 "CODE.tmp" *)
(* line 2294 "CODE.tmp" *)
       O.StrLn( "CodePredeclProcs.DEC(v)" ) ;
    CodeLDesignator(yyP63^.DecArgumenting.Expr1^.DesignExpr.Designator,acode);
    Cons.IntConst(1,ASM.SizeTab[T.SizeOfType(yyP63^.DecArgumenting.Expr1^.DesignExpr.TypeReprOut)],dcode); 
    Cons.IncOrDec(sub,acode,dcode); 
 ;
      RETURN;

  END;
(* line 2300 "CODE.tmp" *)
(* line 2300 "CODE.tmp" *)
       O.StrLn( "CodePredeclProcs.DEC(v,x)" ) ;
    CodeLDesignator(yyP63^.DecArgumenting.Expr1^.DesignExpr.Designator,acode);
    CodeRExpr(yyP63^.DecArgumenting.Expr2^.Exprs.TypeReprOut,yyP63^.DecArgumenting.Expr2,yyP63^.DecArgumenting.Coerce2,dcode); 
    Cons.IncOrDec(sub,acode,dcode); 
 ;
      RETURN;

  END;
  | Tree.ExclArgumenting:
  IF (yyP63^.ExclArgumenting.Expr1^.Kind = Tree.DesignExpr) THEN
(* line 2306 "CODE.tmp" *)
(* line 2306 "CODE.tmp" *)
       O.StrLn( "CodePredeclProcs.EXCL" ) ;
    CodeLDesignator(yyP63^.ExclArgumenting.Expr1^.DesignExpr.Designator,acode);
    CodeRExpr(yyP63^.ExclArgumenting.Expr2^.Exprs.TypeReprOut,yyP63^.ExclArgumenting.Expr2,yyP63^.ExclArgumenting.Coerce2,dcode); 
    Cons.Excl(acode,dcode); 
 ;
      RETURN;

  END;
  | Tree.HaltArgumenting:
(* line 2312 "CODE.tmp" *)
(* line 2312 "CODE.tmp" *)
       O.StrLn( "CodePredeclProcs.HALT" ) ;
    ASM.C1 ( pushl  ,  ASM.i(V.ValueOfInteger(yyP63^.HaltArgumenting.Expr^.Exprs.ValueReprOut)) ); 
    ASM.C1 ( call   ,  ASM.L(LAB.Halt)                ); 
    ASM.CS2( add,l  ,  ASM.i(4),ASM.R(esp)                ); 
 ;
      RETURN;

  | Tree.IncArgumenting:
  IF (yyP63^.IncArgumenting.Expr1^.Kind = Tree.DesignExpr) THEN
  IF (yyP63^.IncArgumenting.Expr2^.Kind = Tree.mtExpr) THEN
(* line 2318 "CODE.tmp" *)
(* line 2318 "CODE.tmp" *)
       O.StrLn( "CodePredeclProcs.INC(v)" ) ;
    CodeLDesignator(yyP63^.IncArgumenting.Expr1^.DesignExpr.Designator,acode);
    Cons.IntConst(1,ASM.SizeTab[T.SizeOfType(yyP63^.IncArgumenting.Expr1^.DesignExpr.TypeReprOut)],dcode); 
    Cons.IncOrDec(add,acode,dcode); 
 ;
      RETURN;

  END;
(* line 2324 "CODE.tmp" *)
(* line 2324 "CODE.tmp" *)
       O.StrLn( "CodePredeclProcs.INC(v,x)" ) ;
    CodeLDesignator(yyP63^.IncArgumenting.Expr1^.DesignExpr.Designator,acode);
    CodeRExpr(yyP63^.IncArgumenting.Expr2^.Exprs.TypeReprOut,yyP63^.IncArgumenting.Expr2,yyP63^.IncArgumenting.Coerce2,dcode); 
    Cons.IncOrDec(add,acode,dcode); 
 ;
      RETURN;

  END;
  | Tree.InclArgumenting:
  IF (yyP63^.InclArgumenting.Expr1^.Kind = Tree.DesignExpr) THEN
(* line 2330 "CODE.tmp" *)
(* line 2330 "CODE.tmp" *)
       O.StrLn( "CodePredeclProcs.INCL" ) ;
    CodeLDesignator(yyP63^.InclArgumenting.Expr1^.DesignExpr.Designator,acode);
    CodeRExpr(yyP63^.InclArgumenting.Expr2^.Exprs.TypeReprOut,yyP63^.InclArgumenting.Expr2,yyP63^.InclArgumenting.Coerce2,dcode); 
    Cons.Incl(acode,dcode); 
 ;
      RETURN;

  END;
  | Tree.NewArgumenting:
  IF (yyP63^.NewArgumenting.Expr^.Kind = Tree.DesignExpr) THEN
  IF (yyP63^.NewArgumenting.NewExprLists^.Kind = Tree.mtNewExprList) THEN
(* line 2336 "CODE.tmp" *)
(* line 2336 "CODE.tmp" *)
       O.StrLn( "CodePredeclProcs.staticNEW" ) ;
    CodeStaticNew(yyP63^.NewArgumenting.Expr^.DesignExpr.TypeReprOut,yyP63^.NewArgumenting.Expr^.DesignExpr.Designator); 
 ;
      RETURN;

  END;
(* line 2340 "CODE.tmp" *)
(* line 2340 "CODE.tmp" *)
       O.StrLn( "CodePredeclProcs.openNEW" ) ;
    CodeOpenNew(yyP63^.NewArgumenting.Expr^.DesignExpr.TypeReprOut,yyP63^.NewArgumenting.Expr^.DesignExpr.Designator,yyP63^.NewArgumenting.NewExprLists); 
 ;
      RETURN;

  END;
  | Tree.SysGetArgumenting:
  IF (yyP63^.SysGetArgumenting.Expr2^.Kind = Tree.DesignExpr) THEN
(* line 2345 "CODE.tmp" *)
(* line 2345 "CODE.tmp" *)
       O.StrLn( "CodePredeclProcs.SYSTEM.GET" ) ;
    CodeRExpr(yyP63^.SysGetArgumenting.Expr1^.Exprs.TypeReprOut,yyP63^.SysGetArgumenting.Expr1,CO.GetCoercion(yyP63^.SysGetArgumenting.Expr1^.Exprs.TypeReprOut,OB.cLongintTypeRepr),dcode); 
    Cons.PointerFrom(dcode,srcAcode); 
    
    CodeLDesignator(yyP63^.SysGetArgumenting.Expr2^.DesignExpr.Designator,dstAcode);
    Cons.MemCopy(T.SizeOfType(yyP63^.SysGetArgumenting.Expr2^.DesignExpr.TypeReprOut),(*isStringCopy:=*)FALSE,dstAcode,srcAcode); 
 ;
      RETURN;

  END;
  | Tree.SysPutArgumenting:
(* line 2353 "CODE.tmp" *)
(* line 2353 "CODE.tmp" *)
       O.StrLn( "CodePredeclProcs.SYSTEM.PUT" ) ;
    CodeRExpr(yyP63^.SysPutArgumenting.Expr1^.Exprs.TypeReprOut,yyP63^.SysPutArgumenting.Expr1,CO.GetCoercion(yyP63^.SysPutArgumenting.Expr1^.Exprs.TypeReprOut,OB.cLongintTypeRepr),dcode); 
    Cons.PointerFrom(dcode,dstAcode); 
    
    CodeAssign(yyP63^.SysPutArgumenting.Expr2^.Exprs.TypeReprOut,yyP63^.SysPutArgumenting.Expr2^.Exprs.TypeReprOut,yyP63^.SysPutArgumenting.Expr2^.Exprs.ValueReprOut,dstAcode,yyP63^.SysPutArgumenting.Expr2,OB.cmtCoercion); 
 ;
      RETURN;

  | Tree.SysGetregArgumenting:
  IF (yyP63^.SysGetregArgumenting.Expr2^.Kind = Tree.DesignExpr) THEN
(* line 2360 "CODE.tmp" *)
(* line 2360 "CODE.tmp" *)
       O.StrLn( "CodePredeclProcs.SYSTEM.GETREG" ) ;
    CodeLDesignator(yyP63^.SysGetregArgumenting.Expr2^.DesignExpr.Designator,dstAcode);
    Cons.Getreg(V.ValueOfInteger(yyP63^.SysGetregArgumenting.Expr1^.Exprs.ValueReprOut),T.SizeOfType(yyP63^.SysGetregArgumenting.Expr2^.DesignExpr.TypeReprOut),dstAcode); 
 ;
      RETURN;

  END;
  | Tree.SysPutregArgumenting:
(* line 2365 "CODE.tmp" *)
(* line 2365 "CODE.tmp" *)
       O.StrLn( "CodePredeclProcs.SYSTEM.PUTREG" ) ;
    CodeRExpr(yyP63^.SysPutregArgumenting.Expr2^.Exprs.TypeReprOut,yyP63^.SysPutregArgumenting.Expr2,OB.cmtCoercion,dcode); 
    Cons.Putreg(V.ValueOfInteger(yyP63^.SysPutregArgumenting.Expr1^.Exprs.ValueReprOut),dcode); 
 ;
      RETURN;

  | Tree.SysMoveArgumenting:
(* line 2370 "CODE.tmp" *)
(* line 2370 "CODE.tmp" *)
       O.StrLn( "CodePredeclProcs.SYSTEM.MOVE" ) ;
    CodeRExpr(yyP63^.SysMoveArgumenting.Expr1^.Exprs.TypeReprOut,yyP63^.SysMoveArgumenting.Expr1,CO.GetCoercion(yyP63^.SysMoveArgumenting.Expr1^.Exprs.TypeReprOut,OB.cLongintTypeRepr),srcDcode); 
    CodeRExpr(yyP63^.SysMoveArgumenting.Expr2^.Exprs.TypeReprOut,yyP63^.SysMoveArgumenting.Expr2,CO.GetCoercion(yyP63^.SysMoveArgumenting.Expr2^.Exprs.TypeReprOut,OB.cLongintTypeRepr),dstDcode); 
    CodeRExpr(yyP63^.SysMoveArgumenting.Expr3^.Exprs.TypeReprOut,yyP63^.SysMoveArgumenting.Expr3,CO.GetCoercion(yyP63^.SysMoveArgumenting.Expr3^.Exprs.TypeReprOut,OB.cLongintTypeRepr),lenDcode); 
    Cons.Move(srcDcode,dstDcode,lenDcode); 
 ;
      RETURN;

  | Tree.SysNewArgumenting:
  IF (yyP63^.SysNewArgumenting.Expr1^.Kind = Tree.DesignExpr) THEN
(* line 2377 "CODE.tmp" *)
(* line 2377 "CODE.tmp" *)
       O.StrLn( "CodePredeclProcs.SYSTEM.NEW" ) ;
    CodeLDesignator(yyP63^.SysNewArgumenting.Expr1^.DesignExpr.Designator,acode);
    CodeRExpr(yyP63^.SysNewArgumenting.Expr2^.Exprs.TypeReprOut,yyP63^.SysNewArgumenting.Expr2,yyP63^.SysNewArgumenting.Coerce2,dcode); 
    Cons.SystemNew(dcode,acode); 
 ;
      RETURN;

  END;
  ELSE END;

(* line 2383 "CODE.tmp" *)
(* line 2383 "CODE.tmp" *)
       ERR.Fatal('CODE.CodePredeclProcs: failed'); ;
      RETURN;

 END CodePredeclProcs;

PROCEDURE CodeAssert (exprVal: OB.tOB; expr: Tree.tTree; errorcode: LONGINT);
(* line 2389 "CODE.tmp" *)
 VAR boolcode:BoolCode; trueLabel,falseLabel:tLabel; 
 BEGIN
  IF exprVal = OB.NoOB THEN RETURN; END;
  IF expr = Tree.NoTree THEN RETURN; END;
  IF (exprVal^.Kind = OB.BooleanValue) THEN
(* line 2391 "CODE.tmp" *)
(* line 2391 "CODE.tmp" *)
       O.StrLn( "CodeAssert.Const" ) ; 
    IF ~exprVal^.BooleanValue.v THEN 
       ASM.C1 ( pushl  ,  ASM.i(errorcode)      ); 
       ASM.C1 ( call   ,  ASM.L(LAB.AssertFail) ); 
       ASM.CS2( add,l  ,  ASM.i(4),ASM.R(esp)       ); 
    END;
 ;
      RETURN;

  END;
(* line 2399 "CODE.tmp" *)
(* line 2399 "CODE.tmp" *)
       O.StrLn( "CodeAssert" ) ;
    CodeBooleanExpr(expr,exprVal,LAB.MT,LAB.New(trueLabel),LAB.New(falseLabel),boolcode); 
    Cons.NoBoolVal(boolcode); 

    ASM.Label(falseLabel); 
    ASM.C1 ( pushl  ,  ASM.i(errorcode)      ); 
    ASM.C1 ( call   ,  ASM.L(LAB.AssertFail) ); 
    ASM.CS2( add,l  ,  ASM.i(4),ASM.R(esp)       ); 
    ASM.Label(trueLabel); 
 ;
      RETURN;

 END CodeAssert;

PROCEDURE CodeStringCopy (srcVal: OB.tOB; srcExpr: Tree.tTree; dstType: OB.tOB; srcType: OB.tOB; dst: Tree.tTree);
(* line 2414 "CODE.tmp" *)
 VAR srcLen,dstLen,li:LONGINT; srcAcode,dstAcode:ACode; dcode,srcDcode,dstDcode:DCode; strcpyCode:SCpCode; 
 BEGIN
  IF srcVal = OB.NoOB THEN RETURN; END;
  IF srcExpr = Tree.NoTree THEN RETURN; END;
  IF dstType = OB.NoOB THEN RETURN; END;
  IF srcType = OB.NoOB THEN RETURN; END;
  IF dst = Tree.NoTree THEN RETURN; END;
  IF (srcVal^.Kind = OB.CharValue) THEN
  IF (dstType^.Kind = OB.ArrayTypeRepr) THEN
(* line 2416 "CODE.tmp" *)
   LOOP
(* line 2416 "CODE.tmp" *)
      IF ~((dstType^.ArrayTypeRepr.len > 0)) THEN EXIT; END;
(* line 2416 "CODE.tmp" *)
      
    CodeLDesignator(dst,dstAcode);
    IF (srcVal^.CharValue.v=0X) OR (dstType^.ArrayTypeRepr.len=1) THEN 
       Cons.CharConst(0X,dcode); 
    ELSE 
       Cons.IntegerConst(ORD(srcVal^.CharValue.v) MOD 256,dcode); 
    END;
    Cons.SimpleAssignment(dstAcode,dcode);
 ;
      RETURN;
   END;

  END;
(* line 2451 "CODE.tmp" *)
(* line 2451 "CODE.tmp" *)
      
    CodeStringCopyVariableOperand(dstType,dst,dstDcode); 
    Cons.ShortConstStrCopy(ORD(srcVal^.CharValue.v),SYSTEM.VAL(SHORTINT,srcVal^.CharValue.v>0X),dstDcode); 
 ;
      RETURN;

  END;
  IF (srcVal^.Kind = OB.StringValue) THEN
  IF (dstType^.Kind = OB.ArrayTypeRepr) THEN
(* line 2426 "CODE.tmp" *)
   LOOP
(* line 2426 "CODE.tmp" *)
      IF ~((dstType^.ArrayTypeRepr.len > 0)) THEN EXIT; END;
(* line 2426 "CODE.tmp" *)
      
    CodeLDesignator(dst,dstAcode); 
    srcLen:=OT.LengthOfoSTRING(srcVal^.StringValue.v); 
    IF (dstType^.ArrayTypeRepr.len=1) OR (srcLen=0) THEN 
       Cons.CharConst(0X,dcode); Cons.SimpleAssignment(dstAcode,dcode);
    ELSE 
       (* ! (dstType^.ArrayTypeRepr.len >= 2) & (srcLen > 0) *)
       CASE srcLen OF
       |1:   OT.SplitoSTRING(srcVal^.StringValue.v,li); Cons.IntegerConst(li,dcode); Cons.SimpleAssignment(dstAcode,dcode);
       |2,3: OT.SplitoSTRING(srcVal^.StringValue.v,li); 
             CASE dstType^.ArrayTypeRepr.len OF
             |2:  Cons.IntegerConst(li MOD 256,dcode); Cons.SimpleAssignment(dstAcode,dcode);
             |3:  Cons.MemSet3(li MOD 65536,dstAcode); 
             ELSE Cons.LongintConst(li,dcode); Cons.SimpleAssignment(dstAcode,dcode);
             END;
       ELSE  IF srcLen<dstType^.ArrayTypeRepr.len THEN 
                CodeLongstringAssignment(srcVal,srcExpr,dstAcode); 
             ELSE 
                Cons.GlobalVariable(CV.String(OT.ShortenoSTRING(srcVal^.StringValue.v,dstType^.ArrayTypeRepr.len-1)),0,Idents.NoIdent,srcAcode); 
                Cons.MemCopy(dstType^.ArrayTypeRepr.len,(*isStringCopy:=*)TRUE,dstAcode,srcAcode); 
             END;
       END;
    END;
 ;
      RETURN;
   END;

  END;
(* line 2456 "CODE.tmp" *)
(* line 2456 "CODE.tmp" *)
      
    srcLen:=OT.LengthOfoSTRING(srcVal^.StringValue.v); 
    IF srcLen=0 THEN 
       CodeStringCopyVariableOperand(dstType,dst,dstDcode); 
       Cons.ShortConstStrCopy(0,0,dstDcode); 
    ELSE 
       Cons.GlobalVariable(V.LabelOfMemValue(srcVal),0,Idents.NoIdent,srcAcode); 
       Cons.ImplicifyConst(1+srcLen,srcAcode,srcDcode);
   
       CodeStringCopyVariableOperand(dstType,dst,dstDcode); 
   
       Cons.StrCopyArguments(srcDcode,dstDcode,strcpyCode); 
       Cons.StrCopy(strcpyCode); 
    END;
 ;
      RETURN;

  END;
  IF (srcExpr^.Kind = Tree.DesignExpr) THEN
(* line 2472 "CODE.tmp" *)
(* line 2472 "CODE.tmp" *)
       O.StrLn( "CodeStringCopy.Default" ) ;
    CodeStringCopyVariableOperand(srcType,srcExpr^.DesignExpr.Designator,srcDcode); 
    CodeStringCopyVariableOperand(dstType,dst,dstDcode); 

    Cons.StrCopyArguments(srcDcode,dstDcode,strcpyCode); 
    Cons.StrCopy(strcpyCode); 
 ;
      RETURN;

  END;
(* line 2480 "CODE.tmp" *)
(* line 2480 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeStringCopy: failed'); ;
      RETURN;

 END CodeStringCopy;

PROCEDURE CodeStringCopyVariableOperand (type: OB.tOB; designator: Tree.tTree; VAR yyP64: DCode);
(* line 2486 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; idData:tImplicitDesignationData; 
 BEGIN
  IF type = OB.NoOB THEN RETURN; END;
  IF designator = Tree.NoTree THEN RETURN; END;
  IF (type^.Kind = OB.ArrayTypeRepr) THEN
(* line 2488 "CODE.tmp" *)
   LOOP
(* line 2488 "CODE.tmp" *)
      IF ~((type^.ArrayTypeRepr.len # OB . OPENARRAYLEN)) THEN EXIT; END;
(* line 2488 "CODE.tmp" *)
       O.StrLn( "CodeStringCopyVariableOperand.Fixed" ) ; 
    CodeLDesignator(designator,acode); 
    Cons.ImplicifyConst(type^.ArrayTypeRepr.len,acode,dcode);
 ;
      yyP64 := dcode;
      RETURN;
   END;

(* line 2493 "CODE.tmp" *)
(* line 2493 "CODE.tmp" *)
       O.StrLn( "CodeStringCopyVariableOperand.Open" ) ; 
    CodeImplicitLDesignator(designator,idData,acode); 

    IF idData.codeToOpenIndexedElem=NIL THEN
       Cons.Implicify((* lenOfs := *) idData.ofsOfLEN0+4*idData.nofOpenIndexings
                     ,                idData.isStackObject
                     ,(* objOfs := *) idData.ofsOfObject
                     ,                idData.acodeToObjHeader
                     ,                dcode);
    ELSE
       Cons.ImplicifyOpenIndexed((* lenOfs := *) idData.ofsOfLEN0+4*idData.nofOpenIndexings
                                ,                idData.isStackObject
                                ,(* objOfs := *) idData.ofsOfObject
                                ,                idData.codeToOpenIndexedElem
                                ,                dcode);
    END;
 ;
      yyP64 := dcode;
      RETURN;

  END;
(* line 2511 "CODE.tmp" *)
(* line 2511 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeStringCopyVariableOperand: failed'); ;
      yyP64 := NIL;
      RETURN;

 END CodeStringCopyVariableOperand;

PROCEDURE CodeStaticNew (type: OB.tOB; designator: Tree.tTree);
(* line 2517 "CODE.tmp" *)
 VAR acode:ACode; 
 BEGIN
  IF type = OB.NoOB THEN RETURN; END;
  IF designator = Tree.NoTree THEN RETURN; END;
  IF (type^.Kind = OB.PointerTypeRepr) THEN
  IF (type^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
  IF OB.IsType (type^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr, OB.TypeRepr) THEN
(* line 2519 "CODE.tmp" *)
(* line 2519 "CODE.tmp" *)
      
    CodeLDesignator(designator,acode);
    Cons.StaticNew(type^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr^.TypeRepr.size,LAB.AppS(type^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr^.TypeRepr.label,'$D'),LAB.AppS(type^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr^.TypeRepr.label,'$I'),acode); 
 ;
      RETURN;

  END;
  END;
  END;
(* line 2524 "CODE.tmp" *)
(* line 2524 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeStaticNew: failed'); ;
      RETURN;

 END CodeStaticNew;

PROCEDURE CodeOpenNew (type: OB.tOB; designator: Tree.tTree; exprList: Tree.tTree);
(* line 2530 "CODE.tmp" *)
 VAR acode:ACode; argcode:ArgCode; nofLens:LONGINT; 
 BEGIN
  IF type = OB.NoOB THEN RETURN; END;
  IF designator = Tree.NoTree THEN RETURN; END;
  IF exprList = Tree.NoTree THEN RETURN; END;
  IF (type^.Kind = OB.PointerTypeRepr) THEN
  IF (type^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
  IF OB.IsType (type^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr, OB.TypeRepr) THEN
(* line 2532 "CODE.tmp" *)
(* line 2532 "CODE.tmp" *)
      
    Cons.NoParam(argcode); 
    CodeOpenNewExprs(exprList,argcode,argcode,nofLens); 
    
    CodeLDesignator(designator,acode);
    Cons.OpenNew(T.ElemSizeOfOpenArrayType(type^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr),LAB.AppS(type^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr^.TypeRepr.label,'$D'),LAB.AppS(type^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr^.TypeRepr.label,'$I'),nofLens,argcode,acode); 
 ;
      RETURN;

  END;
  END;
  END;
(* line 2540 "CODE.tmp" *)
(* line 2540 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeOpenNew: failed'); ;
      RETURN;

 END CodeOpenNew;

PROCEDURE CodeOpenNewExprs (exprList: Tree.tTree; argcodeIn: ArgCode; VAR yyP66: ArgCode; VAR yyP65: LONGINT);
(* line 2546 "CODE.tmp" *)
 VAR dcode:DCode; argcode:ArgCode; nofLens:LONGINT; 
 BEGIN
  IF exprList = Tree.NoTree THEN RETURN; END;
  IF (exprList^.Kind = Tree.NewExprList) THEN
(* line 2548 "CODE.tmp" *)
(* line 2548 "CODE.tmp" *)
       O.StrLn( "CodeOpenNewExprs.Expr" ) ; 
    CodeOpenNewExprs(exprList^.NewExprList.Next,argcodeIn,argcode,nofLens); 

    CodeRExpr(exprList^.NewExprList.Expr^.Exprs.TypeReprOut,exprList^.NewExprList.Expr,exprList^.NewExprList.Coerce,dcode); 
    IF ARG.OptionRangeChecking THEN Cons.LenCheck(dcode,dcode); END;
    Cons.Param(argcode,dcode,argcode);
 ;
      yyP66 := argcode;
      yyP65 := nofLens+1;
      RETURN;

  END;
(* line 2556 "CODE.tmp" *)
      yyP66 := argcodeIn;
      yyP65 := 0;
      RETURN;

 END CodeOpenNewExprs;

PROCEDURE CodePredeclPredicates (yyP67: Tree.tTree; exprLabel: tLabel; trueLabel: tLabel; falseLabel: tLabel; VAR yyP68: BoolCode);
(* line 2564 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; condcode:CondCode; boolcode:BoolCode; labelcode:Cons.Label; retypecode:RetypeCode; 
 BEGIN
  IF yyP67 = Tree.NoTree THEN RETURN; END;
  IF (yyP67^.Kind = Tree.OddArgumenting) THEN
(* line 2566 "CODE.tmp" *)
(* line 2566 "CODE.tmp" *)
       O.StrLn( "CodePredeclPredicates.ODD" ) ; 
    CodeRExpr(yyP67^.OddArgumenting.Expr^.Exprs.TypeReprOut,yyP67^.OddArgumenting.Expr,OB.cmtCoercion,dcode); 
    Cons.LabelDef(exprLabel,labelcode); 
    Cons.Odd(trueLabel,falseLabel,labelcode,dcode,boolcode); 
 ;
      yyP68 := boolcode;
      RETURN;

  END;
  IF (yyP67^.Kind = Tree.SysBitArgumenting) THEN
(* line 2572 "CODE.tmp" *)
(* line 2572 "CODE.tmp" *)
       O.StrLn( "CodePredeclPredicates.SYSTEM.BIT" ) ; 
    CodeRExpr(yyP67^.SysBitArgumenting.Expr1^.Exprs.TypeReprOut,yyP67^.SysBitArgumenting.Expr1,OB.cmtCoercion,dcode); 
    Cons.PointerFrom(dcode,acode); 
    
    CodeRExpr(yyP67^.SysBitArgumenting.Expr2^.Exprs.TypeReprOut,yyP67^.SysBitArgumenting.Expr2,CO.GetCoercion(yyP67^.SysBitArgumenting.Expr2^.Exprs.TypeReprOut,OB.cLongintTypeRepr),dcode); 

    Cons.LabelDef(exprLabel,labelcode); 
    Cons.Bit(trueLabel,falseLabel,labelcode,acode,dcode,boolcode); 
 ;
      yyP68 := boolcode;
      RETURN;

  END;
  IF (yyP67^.Kind = Tree.SysCcArgumenting) THEN
(* line 2582 "CODE.tmp" *)
(* line 2582 "CODE.tmp" *)
       O.StrLn( "CodePredeclPredicates.SYSTEM.CC" ) ; 
    Cons.LabelDef(exprLabel,labelcode); 
    Cons.Cc(V.ValueOfInteger(yyP67^.SysCcArgumenting.Expr^.Exprs.ValueReprOut),trueLabel,falseLabel,labelcode,boolcode);
 ;
      yyP68 := boolcode;
      RETURN;

  END;
  IF (yyP67^.Kind = Tree.SysValArgumenting) THEN
(* line 2587 "CODE.tmp" *)
(* line 2587 "CODE.tmp" *)
       O.StrLn( "CodePredeclPredicates.SYSTEM.VAL" ) ; 
    CodeSysValSource(yyP67^.SysValArgumenting.Expr^.Exprs.TypeReprOut,yyP67^.SysValArgumenting.TypeTypeRepr,yyP67^.SysValArgumenting.Expr,yyP67^.SysValArgumenting.TempAddr,retypecode); 
    CodeSysValRDestination(yyP67^.SysValArgumenting.TypeTypeRepr,retypecode,dcode); 

    Cons.LabelDef(exprLabel,labelcode); 
    Cons.Flag(ASM.unequal,labelcode,dcode,condcode); 
    Cons.Branch((*isSigned:=*)TRUE,trueLabel,falseLabel,condcode,boolcode); 
 ;
      yyP68 := boolcode;
      RETURN;

  END;
(* line 2596 "CODE.tmp" *)
(* line 2596 "CODE.tmp" *)
       ERR.Fatal('CODE.CodePredeclPredicates: failed'); ;
      yyP68 := NIL;
      RETURN;

 END CodePredeclPredicates;

PROCEDURE IsEmptyNode (yyP69: Tree.tTree): BOOLEAN;
 BEGIN
  IF yyP69 = Tree.NoTree THEN RETURN FALSE; END;
  IF yyP69 = NIL THEN
(* line 2603 "CODE.tmp" *)
      RETURN TRUE;

  END;

  CASE yyP69^.Kind OF
  | Tree.mtImport:
(* line 2604 "CODE.tmp" *)
      RETURN TRUE;

  | Tree.mtDeclUnit:
(* line 2605 "CODE.tmp" *)
      RETURN TRUE;

  | Tree.mtDecl:
(* line 2606 "CODE.tmp" *)
      RETURN TRUE;

  | Tree.mtProc:
(* line 2607 "CODE.tmp" *)
      RETURN TRUE;

  | Tree.mtFPSection:
(* line 2608 "CODE.tmp" *)
      RETURN TRUE;

  | Tree.mtParId:
(* line 2609 "CODE.tmp" *)
      RETURN TRUE;

  | Tree.mtType:
(* line 2610 "CODE.tmp" *)
      RETURN TRUE;

  | Tree.mtArrayExprList:
(* line 2611 "CODE.tmp" *)
      RETURN TRUE;

  | Tree.mtFieldList:
(* line 2612 "CODE.tmp" *)
      RETURN TRUE;

  | Tree.mtIdentList:
(* line 2613 "CODE.tmp" *)
      RETURN TRUE;

  | Tree.mtQualident:
(* line 2614 "CODE.tmp" *)
      RETURN TRUE;

  | Tree.mtStmt:
(* line 2615 "CODE.tmp" *)
      RETURN TRUE;

  | Tree.mtCase:
(* line 2616 "CODE.tmp" *)
      RETURN TRUE;

  | Tree.mtExpr:
(* line 2617 "CODE.tmp" *)
      RETURN TRUE;

  ELSE END;

  RETURN FALSE;
 END IsEmptyNode;

PROCEDURE IsProperProcedure (yyP70: Tree.tTree): BOOLEAN;
 BEGIN
  IF yyP70 = Tree.NoTree THEN RETURN FALSE; END;
  IF (yyP70^.Kind = Tree.ProcDecl) THEN
  IF (yyP70^.ProcDecl.FormalPars^.FormalPars.Type^.Kind = Tree.mtType) THEN
(* line 2621 "CODE.tmp" *)
      RETURN TRUE;

  END;
  END;
  IF (yyP70^.Kind = Tree.BoundProcDecl) THEN
  IF (yyP70^.BoundProcDecl.FormalPars^.FormalPars.Type^.Kind = Tree.mtType) THEN
(* line 2622 "CODE.tmp" *)
      RETURN TRUE;

  END;
  END;
  RETURN FALSE;
 END IsProperProcedure;

PROCEDURE Coder* (): BOOLEAN;
 BEGIN
(* line 2626 "CODE.tmp" *)
(* line 2626 "CODE.tmp" *)
      
    CodeModule(FIL.ActP^.TreeRoot);
 ;
      RETURN TRUE;

 END Coder;

PROCEDURE CodeModule (yyP71: Tree.tTree);
(* line 2632 "CODE.tmp" *)
 VAR dummy:SYSTEM.PTR; ptrBl:OB.tOB; fTempLabel:OB.tLabel; 
 BEGIN
  IF yyP71 = Tree.NoTree THEN RETURN; END;
(* line 2634 "CODE.tmp" *)
(* line 2634 "CODE.tmp" *)
       O.StrLn( "CodeModule" ) ; 
    Target.Module(FIL.ActP^.SourceDir^,FIL.ActP^.Modulename^,yyP71^.Module.GlobalSpace); 
   
    IF ARG.OptionCommentsInAsm THEN CMT.Locals(yyP71^.Module.Globals); ASM.Ln; END;

    ptrBl:=BL.PtrBlocklistOfModuleGlobals(yyP71^.Module.Globals); 
    CODEf.GlobalTDesc(ptrBl); 
    CODEf.TDescList(yyP71^.Module.TDescList); 

    FIL.ActP^.ProcCount:=0; 
    CodeDecls(yyP71^.Module.DeclSection); 
   
    IF ARG.OptionCommentsInAsm THEN 
       ASM.SepLine; 
       ASM.CmtLnS('module init proc'); 
       ASM.CmtLnS("TSPACE = "); ASM.CmtI(yyP71^.Module.TempSpace); 
    END;
    Target.BeginModule(yyP71^.Module.TempSpace,LAB.New(fTempLabel));

    CODEf.VarInitializing((* bl       := *) ptrBl
                         ,(* isGlobal := *) TRUE
                         ,(* isPtr    := *) TRUE);
    CODEf.VarInitializing((* bl       := *) BL.ProcBlocklistOfModuleGlobals(yyP71^.Module.Globals)
                         ,(* isGlobal := *) TRUE
                         ,(* isPtr    := *) FALSE);

    NDP.Init(ADR.GlobalTmpBase-yyP71^.Module.TempSpace); 

    dummy:=Base.ShowProcCount(dummy); 
    CodeStmts(yyP71^.Module.Stmts); 

    Target.EndModule(fTempLabel,NDP.UsedTempSize());
 ;
      RETURN;

 END CodeModule;

PROCEDURE CodeDecls (yyP72: Tree.tTree);
 BEGIN
  IF yyP72 = Tree.NoTree THEN RETURN; END;
  IF (yyP72^.Kind = Tree.DeclSection) THEN
(* line 2673 "CODE.tmp" *)
(* line 2673 "CODE.tmp" *)
      CodeDecls (yyP72^.DeclSection.DeclUnits);
(* line 2673 "CODE.tmp" *)
      CodeProcs (yyP72^.DeclSection.Procs);
      RETURN;

  END;
  IF (yyP72^.Kind = Tree.DeclUnit) THEN
(* line 2674 "CODE.tmp" *)
(* line 2674 "CODE.tmp" *)
      CodeDecls (yyP72^.DeclUnit.Decls);
(* line 2674 "CODE.tmp" *)
      CodeDecls (yyP72^.DeclUnit.Next);
      RETURN;

  END;
  IF (yyP72^.Kind = Tree.ConstDecl) THEN
(* line 2675 "CODE.tmp" *)
(* line 2675 "CODE.tmp" *)
      CodeConstValue (yyP72^.ConstDecl.Entry);
(* line 2675 "CODE.tmp" *)
      CodeDecls (yyP72^.ConstDecl.Next);
      RETURN;

  END;
  IF Tree.IsType (yyP72, Tree.Decl) THEN
(* line 2676 "CODE.tmp" *)
(* line 2676 "CODE.tmp" *)
      CodeDecls (yyP72^.Decl.Next);
      RETURN;

  END;
 END CodeDecls;

PROCEDURE CodeProcs (proc: Tree.tTree);
 BEGIN
  IF proc = Tree.NoTree THEN RETURN; END;
  IF (proc^.Kind = Tree.ProcDecl) THEN
(* line 2683 "CODE.tmp" *)
(* line 2683 "CODE.tmp" *)
       CodeProc(proc^.ProcDecl.Entry,proc,FALSE); CodeProcs(proc^.ProcDecl.Next); ;
      RETURN;

  END;
  IF (proc^.Kind = Tree.BoundProcDecl) THEN
(* line 2684 "CODE.tmp" *)
(* line 2684 "CODE.tmp" *)
       CodeProc(proc^.BoundProcDecl.Entry,proc,TRUE ); CodeProcs(proc^.BoundProcDecl.Next); ;
      RETURN;

  END;
  IF (proc^.Kind = Tree.ForwardDecl) THEN
(* line 2686 "CODE.tmp" *)
(* line 2687 "CODE.tmp" *)
                               CodeProcs(proc^.ForwardDecl.Next); ;
      RETURN;

  END;
  IF (proc^.Kind = Tree.BoundForwardDecl) THEN
(* line 2686 "CODE.tmp" *)
(* line 2687 "CODE.tmp" *)
                               CodeProcs(proc^.BoundForwardDecl.Next); ;
      RETURN;

  END;
 END CodeProcs;

PROCEDURE CodeProc (entry: OB.tOB; proc: Tree.tTree; isBoundProc: BOOLEAN);
(* line 2693 "CODE.tmp" *)
 VAR dummy:SYSTEM.PTR; procLabel,fTempLabel:OB.tLabel; idOfLocalSub:ASM.tOperId; nSpace,aSpace:LONGINT; 
 BEGIN
  IF entry = OB.NoOB THEN RETURN; END;
  IF proc = Tree.NoTree THEN RETURN; END;
  IF OB.IsType (entry, OB.DataEntry) THEN
  IF (proc^.Kind = Tree.ProcDecl) THEN
(* line 2695 "CODE.tmp" *)
(* line 2696 "CODE.tmp" *)
       O.StrLn( "CodeProc" ) ; 
    CodeDecls(proc^.ProcDecl.DeclSection);

    dummy:=Base.ShowProcCount(dummy); 
    IF ARG.OptionCommentsInAsm THEN CMT.Procedure(entry,proc); END;

    CODEf.LocalTDesc(entry,BL.PtrBlocklistOfProcDecls(proc^.ProcDecl.Locals));

    ASM.Text;
    ASM.Align(2);
    procLabel:=E.LabelOfEntry(entry); 
    IF (entry^.DataEntry.exportMode#OB.PRIVATE) OR isBoundProc THEN ASM.Globl(procLabel); END;
    ASM.Label(procLabel); 

 (* procedure prologue *)

    CODEf.StackFrameLinks(entry,proc^.ProcDecl.LocalSpace+proc^.ProcDecl.TempSpace,LAB.New(fTempLabel),idOfLocalSub,aSpace);
    CODEf.RefdValParamsCopy((* SignatureRepr := *) E.SignatureOfProcEntry(entry));
    CODEf.VarInitializing  ((* bl            := *) BL.PtrBlocklistOfProcLocals(proc^.ProcDecl.Locals)
                           ,(* isGlobal      := *) FALSE
                           ,(* isPtr         := *) TRUE);
    CODEf.VarInitializing  ((* bl            := *) BL.ProcBlocklistOfProcLocals(proc^.ProcDecl.Locals)
                           ,(* isGlobal      := *) FALSE
                           ,(* isPtr         := *) FALSE);
    NDP.Init(ADR.LocalVarBase(entry^.DataEntry.level)-proc^.ProcDecl.TempSpace); 

 (* statements *)

    CodeStmts(proc^.ProcDecl.Stmts);

 (* procedure epilogue *)

    IF IsProperProcedure(proc) THEN 
       ASM.CS2( mov,l  ,  ASM.R(ebp),ASM.R(esp)      ); 
       ASM.C1 ( popl   ,  ASM.R(ebp)             );
       ASM.C0 ( ret                          ); 
    ELSE 
       ASM.C1 ( jmp  ,  ASM.L(LAB.FunctionFault) ); 
    END;

    nSpace:=aSpace+NDP.UsedTempSize();   
    IF proc^.ProcDecl.LocalSpace+proc^.ProcDecl.TempSpace+nSpace=0 THEN ASM.MakeObsolete(idOfLocalSub); END;
    ASM.LabelDef(fTempLabel,nSpace); 
    ASM.Ln;
 ;
      RETURN;

  END;
  IF (proc^.Kind = Tree.BoundProcDecl) THEN
(* line 2695 "CODE.tmp" *)
(* line 2696 "CODE.tmp" *)
       O.StrLn( "CodeProc" ) ; 
    CodeDecls(proc^.BoundProcDecl.DeclSection);

    dummy:=Base.ShowProcCount(dummy); 
    IF ARG.OptionCommentsInAsm THEN CMT.Procedure(entry,proc); END;

    CODEf.LocalTDesc(entry,BL.PtrBlocklistOfProcDecls(proc^.BoundProcDecl.Locals));

    ASM.Text;
    ASM.Align(2);
    procLabel:=E.LabelOfEntry(entry); 
    IF (entry^.DataEntry.exportMode#OB.PRIVATE) OR isBoundProc THEN ASM.Globl(procLabel); END;
    ASM.Label(procLabel); 

 (* procedure prologue *)

    CODEf.StackFrameLinks(entry,proc^.BoundProcDecl.LocalSpace+proc^.BoundProcDecl.TempSpace,LAB.New(fTempLabel),idOfLocalSub,aSpace);
    CODEf.RefdValParamsCopy((* SignatureRepr := *) E.SignatureOfProcEntry(entry));
    CODEf.VarInitializing  ((* bl            := *) BL.PtrBlocklistOfProcLocals(proc^.BoundProcDecl.Locals)
                           ,(* isGlobal      := *) FALSE
                           ,(* isPtr         := *) TRUE);
    CODEf.VarInitializing  ((* bl            := *) BL.ProcBlocklistOfProcLocals(proc^.BoundProcDecl.Locals)
                           ,(* isGlobal      := *) FALSE
                           ,(* isPtr         := *) FALSE);
    NDP.Init(ADR.LocalVarBase(entry^.DataEntry.level)-proc^.BoundProcDecl.TempSpace); 

 (* statements *)

    CodeStmts(proc^.BoundProcDecl.Stmts);

 (* procedure epilogue *)

    IF IsProperProcedure(proc) THEN 
       ASM.CS2( mov,l  ,  ASM.R(ebp),ASM.R(esp)      ); 
       ASM.C1 ( popl   ,  ASM.R(ebp)             );
       ASM.C0 ( ret                          ); 
    ELSE 
       ASM.C1 ( jmp  ,  ASM.L(LAB.FunctionFault) ); 
    END;

    nSpace:=aSpace+NDP.UsedTempSize();   
    IF proc^.BoundProcDecl.LocalSpace+proc^.BoundProcDecl.TempSpace+nSpace=0 THEN ASM.MakeObsolete(idOfLocalSub); END;
    ASM.LabelDef(fTempLabel,nSpace); 
    ASM.Ln;
 ;
      RETURN;

  END;
  END;
 END CodeProc;

PROCEDURE CodeConstValue (yyP73: OB.tOB);
 BEGIN
  IF yyP73 = OB.NoOB THEN RETURN; END;
  IF (yyP73^.Kind = OB.ConstEntry) THEN
  IF (yyP73^.ConstEntry.value^.Kind = OB.StringValue) THEN
(* line 2747 "CODE.tmp" *)
(* line 2747 "CODE.tmp" *)
       O.StrLn( "CodeConstValue.String" ) ; 
    CV.NamedString(yyP73^.ConstEntry.value^.StringValue.v,yyP73^.ConstEntry.label,(yyP73^.ConstEntry.exportMode#OB.PRIVATE)); 
 ;
      RETURN;

  END;
  IF (yyP73^.ConstEntry.value^.Kind = OB.RealValue) THEN
(* line 2751 "CODE.tmp" *)
(* line 2751 "CODE.tmp" *)
       O.StrLn( "CodeConstValue.Real" ) ; 
    CV.NamedReal(yyP73^.ConstEntry.value^.RealValue.v,yyP73^.ConstEntry.label,(yyP73^.ConstEntry.exportMode#OB.PRIVATE)); 
 ;
      RETURN;

  END;
  IF (yyP73^.ConstEntry.value^.Kind = OB.LongrealValue) THEN
(* line 2755 "CODE.tmp" *)
(* line 2755 "CODE.tmp" *)
       O.StrLn( "CodeConstValue.Longreal" ) ; 
    CV.NamedLongreal(yyP73^.ConstEntry.value^.LongrealValue.v,yyP73^.ConstEntry.label,(yyP73^.ConstEntry.exportMode#OB.PRIVATE)); 
 ;
      RETURN;

  END;
  END;
 END CodeConstValue;

PROCEDURE CodeValue (yyP76: OB.tOB; yyP75: OB.tOB; yyP74: OB.tOB; VAR yyP77: DCode);
(* line 2763 "CODE.tmp" *)
 VAR acode:ACode; dcode:DCode; 
 BEGIN
  IF yyP76 = OB.NoOB THEN RETURN; END;
  IF yyP75 = OB.NoOB THEN RETURN; END;
  IF yyP74 = OB.NoOB THEN RETURN; END;

  CASE yyP76^.Kind OF
  | OB.BooleanValue:
(* line 2765 "CODE.tmp" *)
(* line 2765 "CODE.tmp" *)
       Cons.BooleanConst (yyP76^.BooleanValue.v,dcode); ;
      yyP77 := dcode;
      RETURN;

  | OB.CharValue:
(* line 2766 "CODE.tmp" *)
(* line 2766 "CODE.tmp" *)
       Cons.CharConst    (yyP76^.CharValue.v,dcode); ;
      yyP77 := dcode;
      RETURN;

  | OB.SetValue:
(* line 2767 "CODE.tmp" *)
(* line 2767 "CODE.tmp" *)
       Cons.SetConst     (yyP76^.SetValue.v,dcode); ;
      yyP77 := dcode;
      RETURN;

  | OB.IntegerValue:
  IF (yyP74^.Kind = OB.Shortint2Integer) THEN
(* line 2768 "CODE.tmp" *)
(* line 2768 "CODE.tmp" *)
       Cons.IntegerConst (yyP76^.IntegerValue.v,dcode); ;
      yyP77 := dcode;
      RETURN;

  END;
  IF (yyP74^.Kind = OB.Shortint2Longint) THEN
(* line 2769 "CODE.tmp" *)
(* line 2769 "CODE.tmp" *)
       Cons.LongintConst (yyP76^.IntegerValue.v,dcode); ;
      yyP77 := dcode;
      RETURN;

  END;
  IF (yyP74^.Kind = OB.Integer2Longint) THEN
(* line 2770 "CODE.tmp" *)
(* line 2770 "CODE.tmp" *)
       Cons.LongintConst (yyP76^.IntegerValue.v,dcode); ;
      yyP77 := dcode;
      RETURN;

  END;
  IF (yyP75^.Kind = OB.ShortintTypeRepr) THEN
(* line 2771 "CODE.tmp" *)
(* line 2771 "CODE.tmp" *)
       Cons.ShortintConst(yyP76^.IntegerValue.v,dcode); ;
      yyP77 := dcode;
      RETURN;

  END;
  IF (yyP75^.Kind = OB.IntegerTypeRepr) THEN
(* line 2772 "CODE.tmp" *)
(* line 2772 "CODE.tmp" *)
       Cons.IntegerConst (yyP76^.IntegerValue.v,dcode); ;
      yyP77 := dcode;
      RETURN;

  END;
(* line 2773 "CODE.tmp" *)
(* line 2773 "CODE.tmp" *)
       Cons.LongintConst (yyP76^.IntegerValue.v,dcode); ;
      yyP77 := dcode;
      RETURN;

  | OB.NilValue:
(* line 2774 "CODE.tmp" *)
(* line 2774 "CODE.tmp" *)
       Cons.LongintConst (0,dcode); ;
      yyP77 := dcode;
      RETURN;

  | OB.NilPointerValue:
(* line 2775 "CODE.tmp" *)
(* line 2775 "CODE.tmp" *)
       Cons.LongintConst (0,dcode); ;
      yyP77 := dcode;
      RETURN;

  | OB.RealValue:
(* line 2777 "CODE.tmp" *)
(* line 2777 "CODE.tmp" *)
       Cons.GlobalVariable(CV.Real(yyP76^.RealValue.v),0,Idents.NoIdent,acode); 
                                                                   Cons.FloatContentOf(s,acode,dcode); ;
      yyP77 := dcode;
      RETURN;

  | OB.LongrealValue:
(* line 2779 "CODE.tmp" *)
(* line 2779 "CODE.tmp" *)
       Cons.GlobalVariable(CV.Longreal(yyP76^.LongrealValue.v),0,Idents.NoIdent,acode); 
                                                                   Cons.FloatContentOf(l,acode,dcode); ;
      yyP77 := dcode;
      RETURN;

  | OB.StringValue:
(* line 2781 "CODE.tmp" *)
(* line 2781 "CODE.tmp" *)
       Cons.GlobalVariable(CV.String(yyP76^.StringValue.v),0,Idents.NoIdent,acode); 
                                                                   Cons.AddressOf(acode,dcode); ;
      yyP77 := dcode;
      RETURN;

  | OB.NilProcedureValue:
(* line 2783 "CODE.tmp" *)
(* line 2783 "CODE.tmp" *)
       Cons.GlobalVariable(LAB.NILPROC,0,Idents.NoIdent,acode); 
                                                                   Cons.AddressOf(acode,dcode); ;
      yyP77 := dcode;
      RETURN;

  ELSE END;

(* line 2786 "CODE.tmp" *)
(* line 2786 "CODE.tmp" *)
       ERR.Fatal('CODE.CodeValue: failed'); ;
      yyP77 := NIL;
      RETURN;

 END CodeValue;

PROCEDURE BeginCODE*;
 BEGIN
(* line 54 "CODE.tmp" *)
  FOR rel:=0 TO MAX_RelOperRange-1 DO RelTab[rel]:=ASM.NoRelation; END;
        RelTab[Tree.EqualOper       ] := ASM.equal         ;
        RelTab[Tree.UnequalOper     ] := ASM.unequal       ;
        RelTab[Tree.LessOper        ] := ASM.less          ;
        RelTab[Tree.LessEqualOper   ] := ASM.lessORequal   ;
        RelTab[Tree.GreaterOper     ] := ASM.greater       ;
        RelTab[Tree.GreaterEqualOper] := ASM.greaterORequal; 
 END BeginCODE;

PROCEDURE CloseCODE*;
 BEGIN
 END CloseCODE;

PROCEDURE yyExit;
 BEGIN
  IO.CloseIO; System.Exit (1);
 END yyExit;

BEGIN
 yyf	:= IO.StdOutput;
 Exit	:= yyExit;
 BeginCODE;
END CODE.

