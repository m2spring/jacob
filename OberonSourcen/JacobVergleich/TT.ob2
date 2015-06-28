MODULE TT;







IMPORT SYSTEM, System, IO, Tree, OB,
(* line 31 "TT.pum" *)
 Idents    ,
                POS       ,
                UTI       ; 


        TYPE    tIdent    = Idents.tIdent;                          (* These types are re-declared due to the fact that         *)
                tPosition = POS.tPosition; 

VAR yyf*	: IO.tFile;
VAR Exit*	: PROCEDURE;

















PROCEDURE^ExprListToSysAsmExprList (yyP22: Tree.tTree): Tree.tTree;
PROCEDURE^ExprListToNewExprList (yyP21: Tree.tTree): Tree.tTree;
PROCEDURE^ExtractFirstExpr (exprList: Tree.tTree; VAR yyP24: Tree.tTree): Tree.tTree;
PROCEDURE^ExtractFirstQualident (exprList: Tree.tTree; VAR yyP23: Tree.tTree): Tree.tTree;
PROCEDURE^ExtractExpr3 (yyP16: Tree.tTree; argNode: Tree.tTree): Tree.tTree;
PROCEDURE^ExtractExprType (yyP17: Tree.tTree; argNode: Tree.tTree): Tree.tTree;
PROCEDURE^ExtractExprVal (yyP18: Tree.tTree; argNode: Tree.tTree): Tree.tTree;
PROCEDURE^ExtractExprNew (yyP19: Tree.tTree; argNode: Tree.tTree): Tree.tTree;
PROCEDURE^ExtractExprAsm (yyP20: Tree.tTree; argNode: Tree.tTree): Tree.tTree;
PROCEDURE^ExtractExpr2 (yyP15: Tree.tTree; argNode: Tree.tTree): Tree.tTree;
PROCEDURE^ExtractExpr1 (yyP14: Tree.tTree; argNode: Tree.tTree): Tree.tTree;
PROCEDURE^DesignorToDesignation* (entry: OB.tOB; typeRepr: OB.tOB; designor: Tree.tTree; VAR yyP13: Tree.tTree): Tree.tTree;












































































































PROCEDURE yyAbort (yyFunction: ARRAY OF CHAR);
 BEGIN
  IO.WriteS (IO.StdError, 'Error: module TT, routine ');
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

PROCEDURE GetQualification* (yyP1: Tree.tTree): tIdent;
 BEGIN
  IF (yyP1^.Kind = Tree.QualifiedIdent) THEN
(* line 38 "TT.pum" *)
      RETURN yyP1^.QualifiedIdent.ServerId;

  END;
(* line 43 "TT.pum" *)
      RETURN Idents.NoIdent;

 END GetQualification;

PROCEDURE IsEmptyExpr* (yyP2: Tree.tTree): BOOLEAN;
 BEGIN
  IF yyP2 = Tree.NoTree THEN RETURN FALSE; END;
  IF (yyP2^.Kind = Tree.mtExpr) THEN
(* line 47 "TT.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsEmptyExpr;

PROCEDURE IsEmptyExprList* (yyP3: Tree.tTree): BOOLEAN;
 BEGIN
  IF yyP3 = Tree.NoTree THEN RETURN FALSE; END;
  IF (yyP3^.Kind = Tree.mtExprList) THEN
(* line 51 "TT.pum" *)
      RETURN TRUE;

  END;
  IF (yyP3^.Kind = Tree.mtNewExprList) THEN
(* line 52 "TT.pum" *)
      RETURN TRUE;

  END;
  IF (yyP3^.Kind = Tree.mtSysAsmExprList) THEN
(* line 53 "TT.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsEmptyExprList;

PROCEDURE IsImportingDesignation* (yyP4: Tree.tTree): BOOLEAN;
 BEGIN
  IF yyP4 = Tree.NoTree THEN RETURN FALSE; END;
  IF (yyP4^.Kind = Tree.Importing) THEN
(* line 57 "TT.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsImportingDesignation;

PROCEDURE IsArgumentor (yyP5: Tree.tTree): BOOLEAN;
 BEGIN
  IF yyP5 = Tree.NoTree THEN RETURN FALSE; END;
  IF (yyP5^.Kind = Tree.Argumentor) THEN
(* line 61 "TT.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsArgumentor;

PROCEDURE IsNotEmptyQualident* (yyP6: Tree.tTree): BOOLEAN;
 BEGIN
  IF yyP6 = Tree.NoTree THEN RETURN FALSE; END;
  IF (yyP6^.Kind = Tree.mtQualident) THEN
(* line 65 "TT.pum" *)
(* line 65 "TT.pum" *)
      RETURN FALSE;

  END;
(* line 66 "TT.pum" *)
      RETURN TRUE;

 END IsNotEmptyQualident;

PROCEDURE IsNoStmts* (yyP7: Tree.tTree): BOOLEAN;
 BEGIN
  IF yyP7 = Tree.NoTree THEN RETURN FALSE; END;
  IF (yyP7^.Kind = Tree.NoStmts) THEN
(* line 70 "TT.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsNoStmts;

PROCEDURE IdentOfFirstVariable* (yyP8: Tree.tTree): tIdent;
 BEGIN
  IF (yyP8^.Kind = Tree.IdentList) THEN
(* line 74 "TT.pum" *)
      RETURN yyP8^.IdentList.IdentDef^.IdentDef.Ident;

  END;
(* line 75 "TT.pum" *)
      RETURN Idents.NoIdent;

 END IdentOfFirstVariable;

PROCEDURE IdentOfFirstParameter* (yyP9: Tree.tTree): tIdent;
 BEGIN
  IF (yyP9^.Kind = Tree.ParId) THEN
(* line 79 "TT.pum" *)
      RETURN yyP9^.ParId.Ident;

  END;
(* line 80 "TT.pum" *)
      RETURN Idents.NoIdent;

 END IdentOfFirstParameter;

PROCEDURE ElementCorrection* (expr2: Tree.tTree; val1: OB.tOB; val2: OB.tOB): OB.tOB;
 BEGIN
  IF (expr2^.Kind = Tree.mtExpr) THEN
(* line 86 "TT.pum" *)
      RETURN val1;

  END;
(* line 87 "TT.pum" *)
      RETURN val2;

 END ElementCorrection;

PROCEDURE ArgumentCorrection* (isCall: BOOLEAN; type: OB.tOB; pos: tPosition; next: Tree.tTree): Tree.tTree;
 VAR yyTempo: RECORD 
 yyR1: RECORD
  yyV1: Tree.tTree;
  END;
 END;
 BEGIN
  IF ( isCall  =   TRUE  ) THEN
  IF OB.IsType (type, OB.ProcedureTypeRepr) THEN
  IF (next^.Kind = Tree.mtDesignation) THEN
(* line 100 "TT.pum" *)
       yyTempo.yyR1.yyV1  :=  Tree . MakeTree  ( Tree . Argumenting ); 
       yyTempo.yyR1.yyV1^.Argumenting.Nextor  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
      yyTempo.yyR1.yyV1^.Argumenting.Position := pos;
       yyTempo.yyR1.yyV1^.Argumenting.Nextion  :=  Tree . MakeTree  ( Tree . mtDesignation ); 
      yyTempo.yyR1.yyV1^.Argumenting.Op2Pos := pos;
       yyTempo.yyR1.yyV1^.Argumenting.ExprList  :=  Tree . MakeTree  ( Tree . mtExprList ); 
      RETURN yyTempo.yyR1.yyV1;

  END;
  END;
    END;
(* line 111 "TT.pum" *)
      RETURN next;

 END ArgumentCorrection;

PROCEDURE DesignorToGuardedDesignation* (curModule: OB.tOB; entry: OB.tOB; typeRepr: OB.tOB; designor: Tree.tTree; VAR yyP10: Tree.tTree): Tree.tTree;
(* line 130 "TT.pum" *)
 VAR designorOut,designation:Tree.tTree; 
 VAR yyTempo: RECORD
 yyR1: RECORD
  yyV1: Tree.tTree;
  END;
 END;
 BEGIN
  IF (entry^.Kind = OB.VarEntry) THEN
(* line 132 "TT.pum" *)
   LOOP
(* line 155 "TT.pum" *)
      IF ~((entry^.VarEntry.isWithed & ~ IsArgumentor (designor))) THEN EXIT; END;
       yyP10  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR1.yyV1  :=  Tree . MakeTree  ( Tree . Guarding ); 
      yyTempo.yyR1.yyV1^.Guarding.Nextor := designor;
      	
       yyTempo.yyR1.yyV1^.Guarding.Nextion  :=  Tree . MakeTree  ( Tree . mtDesignation ); 
      yyTempo.yyR1.yyV1^.Guarding.IsImplicit := TRUE;
       yyTempo.yyR1.yyV1^.Guarding.Qualidents  :=  Tree . MakeTree  ( Tree . mtQualident ); 
      RETURN yyTempo.yyR1.yyV1;
    END;

  END;
(* line 157 "TT.pum" *)
(* line 158 "TT.pum" *)
       designation:=DesignorToDesignation(entry,typeRepr,designor,designorOut); ;
      yyP10 := designorOut;
      RETURN designation;

 END DesignorToGuardedDesignation;

PROCEDURE QualidentFromType (yyP12: OB.tOB; yyP11: OB.tOB): Tree.tTree;
 VAR yyTempo: RECORD 
 yyR1: RECORD
  yyV1: Tree.tTree;
  END;
 yyR2: RECORD
  yyV1: Tree.tTree;
  END;
 END;
 BEGIN
  IF OB.IsType (yyP11, OB.TypeRepr) THEN
  IF (yyP11^.TypeRepr.entry^.Kind = OB.TypeEntry) THEN
(* line 163 "TT.pum" *)
   LOOP
(* line 164 "TT.pum" *)
      IF ~((yyP12^.ModuleEntry.name # yyP11^.TypeRepr.entry^.TypeEntry.module^.ModuleEntry.name)) THEN EXIT; END;
       yyTempo.yyR1.yyV1  :=  Tree . MakeTree  ( Tree . QualifiedIdent ); 
      yyTempo.yyR1.yyV1^.QualifiedIdent.Position := POS.NoPosition;
      yyTempo.yyR1.yyV1^.QualifiedIdent.ServerId := yyP11^.TypeRepr.entry^.TypeEntry.module^.ModuleEntry.name;
      yyTempo.yyR1.yyV1^.QualifiedIdent.Ident := yyP11^.TypeRepr.entry^.TypeEntry.ident;
      yyTempo.yyR1.yyV1^.QualifiedIdent.IdentPos := POS.NoPosition;
      RETURN yyTempo.yyR1.yyV1;
    END;

(* line 166 "TT.pum" *)
       yyTempo.yyR2.yyV1  :=  Tree . MakeTree  ( Tree . UnqualifiedIdent ); 
      yyTempo.yyR2.yyV1^.UnqualifiedIdent.Position := POS.NoPosition;
      yyTempo.yyR2.yyV1^.UnqualifiedIdent.Ident := yyP11^.TypeRepr.entry^.TypeEntry.ident;
      RETURN yyTempo.yyR2.yyV1;

  END;
  END;
  yyAbort ('QualidentFromType');
 END QualidentFromType;

PROCEDURE DesignorToDesignation* (entry: OB.tOB; typeRepr: OB.tOB; designor: Tree.tTree; VAR yyP13: Tree.tTree): Tree.tTree;
 VAR yyTempo: RECORD
 yyR1: RECORD
  yyV1: Tree.tTree;
  END;
 yyR2: RECORD
  yyV1: Tree.tTree;
  END;
 yyR3: RECORD
  yyV1: Tree.tTree;
  END;
 yyR4: RECORD
  yyV1: Tree.tTree;
  END;
 yyR5: RECORD
  yyV1: Tree.tTree;
  END;
 yyR6: RECORD
  yyV1: Tree.tTree;
  END;
 yyR7: RECORD
  yyV1: Tree.tTree;
  END;
 yyR8: RECORD
  yyV1: Tree.tTree;
  END;
 yyR9: RECORD
  yyV1: Tree.tTree;
  END;
 yyR10: RECORD
  yyV1: Tree.tTree;
  END;
 yyR11: RECORD
  yyV1: Tree.tTree;
  END;
 yyR12: RECORD
  yyV1: Tree.tTree;
  END;
 yyR13: RECORD
  yyV1: Tree.tTree;
  END;
 yyR14: RECORD
  yyV1: Tree.tTree;
  END;
 yyR15: RECORD
  yyV1: Tree.tTree;
  END;
 yyR16: RECORD
  yyV1: Tree.tTree;
  END;
 yyR17: RECORD
  yyV1: Tree.tTree;
  END;
 yyR18: RECORD
  yyV1: Tree.tTree;
  END;
 yyR19: RECORD
  yyV1: Tree.tTree;
  END;
 yyR20: RECORD
  yyV1: Tree.tTree;
  END;
 yyR21: RECORD
  yyV1: Tree.tTree;
  END;
 yyR22: RECORD
  yyV1: Tree.tTree;
  END;
 yyR23: RECORD
  yyV1: Tree.tTree;
  END;
 yyR24: RECORD
  yyV1: Tree.tTree;
  END;
 yyR25: RECORD
  yyV1: Tree.tTree;
  END;
 yyR26: RECORD
  yyV1: Tree.tTree;
  END;
 yyR27: RECORD
  yyV1: Tree.tTree;
  END;
 yyR28: RECORD
  yyV1: Tree.tTree;
  END;
 yyR29: RECORD
  yyV1: Tree.tTree;
  END;
 yyR30: RECORD
  yyV1: Tree.tTree;
  END;
 yyR31: RECORD
  yyV1: Tree.tTree;
  END;
 yyR32: RECORD
  yyV1: Tree.tTree;
  END;
 yyR33: RECORD
  yyV1: Tree.tTree;
  END;
 yyR34: RECORD
  yyV1: Tree.tTree;
  END;
 yyR35: RECORD
  yyV1: Tree.tTree;
  END;
 yyR36: RECORD
  yyV1: Tree.tTree;
  END;
 yyR37: RECORD
  yyV1: Tree.tTree;
  END;
 yyR38: RECORD
  yyV1: Tree.tTree;
  END;
 yyR39: RECORD
  yyV1: Tree.tTree;
  END;
 yyR40: RECORD
  yyV1: Tree.tTree;
  END;
 yyR41: RECORD
  yyV1: Tree.tTree;
  END;
 yyR42: RECORD
  yyV1: Tree.tTree;
  END;
 yyR43: RECORD
  yyV1: Tree.tTree;
  END;
 yyR44: RECORD
  yyV1: Tree.tTree;
  END;
 yyR45: RECORD
  yyV1: Tree.tTree;
  END;
 yyR46: RECORD
  yyV1: Tree.tTree;
  END;
 yyR47: RECORD
  yyV1: Tree.tTree;
  END;
 yyR48: RECORD
  yyV1: Tree.tTree;
  END;
 yyR49: RECORD
  yyV1: Tree.tTree;
  END;
 END;
 BEGIN
  IF (designor^.Kind = Tree.mtDesignor) THEN
(* line 177 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR1.yyV1  :=  Tree . MakeTree  ( Tree . mtDesignation ); 
      RETURN yyTempo.yyR1.yyV1;

  END;
  IF (entry^.Kind = OB.ServerEntry) THEN
  IF (designor^.Kind = Tree.Selector) THEN
(* line 185 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR2.yyV1  :=  Tree . MakeTree  ( Tree . Importing ); 
      yyTempo.yyR2.yyV1^.Importing.Nextor := designor^.Selector.Nextor;
      yyTempo.yyR2.yyV1^.Importing.Position := designor^.Selector.OpPos;
       yyTempo.yyR2.yyV1^.Importing.Nextion  :=  Tree . MakeTree  ( Tree . mtDesignation ); 
      yyTempo.yyR2.yyV1^.Importing.Ident := designor^.Selector.Ident;
      yyTempo.yyR2.yyV1^.Importing.IdPos := designor^.Selector.IdPos;
      RETURN yyTempo.yyR2.yyV1;

  END;
  END;
  IF (typeRepr^.Kind = OB.PointerTypeRepr) THEN
  IF (designor^.Kind = Tree.Selector) THEN
(* line 206 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR3.yyV1  :=  Tree . MakeTree  ( Tree . Dereferencing ); 
      yyTempo.yyR3.yyV1^.Dereferencing.Nextor := designor;
      yyTempo.yyR3.yyV1^.Dereferencing.Position := designor^.Selector.OpPos;
       yyTempo.yyR3.yyV1^.Dereferencing.Nextion  :=  Tree . MakeTree  ( Tree . mtDesignation ); 
      RETURN yyTempo.yyR3.yyV1;

  END;
  IF (designor^.Kind = Tree.Indexor) THEN
(* line 225 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR4.yyV1  :=  Tree . MakeTree  ( Tree . Dereferencing ); 
      yyTempo.yyR4.yyV1^.Dereferencing.Nextor := designor;
      yyTempo.yyR4.yyV1^.Dereferencing.Position := designor^.Indexor.Op1Pos;
       yyTempo.yyR4.yyV1^.Dereferencing.Nextion  :=  Tree . MakeTree  ( Tree . mtDesignation ); 
      RETURN yyTempo.yyR4.yyV1;

  END;
  IF (designor^.Kind = Tree.Argumentor) THEN
  IF (designor^.Argumentor.ExprList^.Kind = Tree.ExprList) THEN
  IF (designor^.Argumentor.ExprList^.ExprList.Next^.Kind = Tree.mtExprList) THEN
  IF (designor^.Argumentor.ExprList^.ExprList.Expr^.Kind = Tree.DesignExpr) THEN
  IF (designor^.Argumentor.ExprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Designors^.Kind = Tree.mtDesignor) THEN
(* line 393 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR12.yyV1  :=  Tree . MakeTree  ( Tree . Guarding ); 
      yyTempo.yyR12.yyV1^.Guarding.Nextor := designor^.Argumentor.Nextor;
      yyTempo.yyR12.yyV1^.Guarding.Position := designor^.Argumentor.Op1Pos;
       yyTempo.yyR12.yyV1^.Guarding.Nextion  :=  Tree . MakeTree  ( Tree . mtDesignation ); 
      yyTempo.yyR12.yyV1^.Guarding.IsImplicit := FALSE;
       yyTempo.yyR12.yyV1^.Guarding.Qualidents  :=  Tree . MakeTree  ( Tree . UnqualifiedIdent ); 
      yyTempo.yyR12.yyV1^.Guarding.Qualidents^.UnqualifiedIdent.Position := designor^.Argumentor.ExprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Position;
      yyTempo.yyR12.yyV1^.Guarding.Qualidents^.UnqualifiedIdent.Ident := designor^.Argumentor.ExprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Ident;
      RETURN yyTempo.yyR12.yyV1;

  END;
  IF (designor^.Argumentor.ExprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Designors^.Kind = Tree.Selector) THEN
  IF (designor^.Argumentor.ExprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Designors^.Selector.Nextor^.Kind = Tree.mtDesignor) THEN
(* line 469 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR14.yyV1  :=  Tree . MakeTree  ( Tree . Guarding ); 
      yyTempo.yyR14.yyV1^.Guarding.Nextor := designor^.Argumentor.Nextor;
      yyTempo.yyR14.yyV1^.Guarding.Position := designor^.Argumentor.Op1Pos;
       yyTempo.yyR14.yyV1^.Guarding.Nextion  :=  Tree . MakeTree  ( Tree . mtDesignation ); 
      yyTempo.yyR14.yyV1^.Guarding.IsImplicit := FALSE;
       yyTempo.yyR14.yyV1^.Guarding.Qualidents  :=  Tree . MakeTree  ( Tree . QualifiedIdent ); 
      yyTempo.yyR14.yyV1^.Guarding.Qualidents^.QualifiedIdent.Position := designor^.Argumentor.ExprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Position;
      yyTempo.yyR14.yyV1^.Guarding.Qualidents^.QualifiedIdent.ServerId := designor^.Argumentor.ExprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Ident;
      yyTempo.yyR14.yyV1^.Guarding.Qualidents^.QualifiedIdent.Ident := designor^.Argumentor.ExprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Designors^.Selector.Ident;
      yyTempo.yyR14.yyV1^.Guarding.Qualidents^.QualifiedIdent.IdentPos := designor^.Argumentor.ExprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Designors^.Selector.IdPos;
      RETURN yyTempo.yyR14.yyV1;

  END;
  END;
  END;
  END;
  END;
  END;
  END;
  IF (designor^.Kind = Tree.Selector) THEN
(* line 242 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR5.yyV1  :=  Tree . MakeTree  ( Tree . Selecting ); 
      yyTempo.yyR5.yyV1^.Selecting.Nextor := designor^.Selector.Nextor;
      yyTempo.yyR5.yyV1^.Selecting.Position := designor^.Selector.OpPos;
       yyTempo.yyR5.yyV1^.Selecting.Nextion  :=  Tree . MakeTree  ( Tree . mtDesignation ); 
      yyTempo.yyR5.yyV1^.Selecting.Ident := designor^.Selector.Ident;
      yyTempo.yyR5.yyV1^.Selecting.IdPos := designor^.Selector.IdPos;
      RETURN yyTempo.yyR5.yyV1;

  END;
  IF (designor^.Kind = Tree.Indexor) THEN
  IF (designor^.Indexor.ExprList^.Kind = Tree.ExprList) THEN
  IF (designor^.Indexor.ExprList^.ExprList.Next^.Kind = Tree.mtExprList) THEN
(* line 261 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR6.yyV1  :=  Tree . MakeTree  ( Tree . Indexing ); 
      yyTempo.yyR6.yyV1^.Indexing.Nextor := designor^.Indexor.Nextor;
      yyTempo.yyR6.yyV1^.Indexing.Position := designor^.Indexor.Op1Pos;
       yyTempo.yyR6.yyV1^.Indexing.Nextion  :=  Tree . MakeTree  ( Tree . mtDesignation ); 
      yyTempo.yyR6.yyV1^.Indexing.Op2Pos := designor^.Indexor.Op2Pos;
      yyTempo.yyR6.yyV1^.Indexing.Expr := designor^.Indexor.ExprList^.ExprList.Expr;
      RETURN yyTempo.yyR6.yyV1;

  END;
  IF (designor^.Indexor.ExprList^.ExprList.Next^.Kind = Tree.ExprList) THEN
(* line 283 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR7.yyV1  :=  Tree . MakeTree  ( Tree . Indexing ); 
       yyTempo.yyR7.yyV1^.Indexing.Nextor  :=  Tree . MakeTree  ( Tree . Indexor ); 
      yyTempo.yyR7.yyV1^.Indexing.Nextor^.Indexor.Nextor := designor^.Indexor.Nextor;
      yyTempo.yyR7.yyV1^.Indexing.Nextor^.Indexor.Op1Pos := designor^.Indexor.ExprList^.ExprList.Expr^.Exprs.Position;
      yyTempo.yyR7.yyV1^.Indexing.Nextor^.Indexor.Op2Pos := designor^.Indexor.Op2Pos;
      yyTempo.yyR7.yyV1^.Indexing.Nextor^.Indexor.ExprList := designor^.Indexor.ExprList^.ExprList.Next;
      yyTempo.yyR7.yyV1^.Indexing.Position := designor^.Indexor.Op1Pos;
       yyTempo.yyR7.yyV1^.Indexing.Nextion  :=  Tree . MakeTree  ( Tree . mtDesignation ); 
      yyTempo.yyR7.yyV1^.Indexing.Op2Pos := designor^.Indexor.ExprList^.ExprList.Next^.ExprList.Expr^.Exprs.Position;
      yyTempo.yyR7.yyV1^.Indexing.Expr := designor^.Indexor.ExprList^.ExprList.Expr;
      RETURN yyTempo.yyR7.yyV1;

  END;
  END;
  END;
  IF (entry^.Kind = OB.BoundProcEntry) THEN
  IF (designor^.Kind = Tree.Dereferencor) THEN
(* line 309 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR8.yyV1  :=  Tree . MakeTree  ( Tree . Supering ); 
      yyTempo.yyR8.yyV1^.Supering.Nextor := designor^.Dereferencor.Nextor;
      yyTempo.yyR8.yyV1^.Supering.Position := designor^.Dereferencor.OpPos;
       yyTempo.yyR8.yyV1^.Supering.Nextion  :=  Tree . MakeTree  ( Tree . mtDesignation ); 
      RETURN yyTempo.yyR8.yyV1;

  END;
  END;
  IF (entry^.Kind = OB.InheritedProcEntry) THEN
  IF (designor^.Kind = Tree.Dereferencor) THEN
(* line 326 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR9.yyV1  :=  Tree . MakeTree  ( Tree . Supering ); 
      yyTempo.yyR9.yyV1^.Supering.Nextor := designor^.Dereferencor.Nextor;
      yyTempo.yyR9.yyV1^.Supering.Position := designor^.Dereferencor.OpPos;
       yyTempo.yyR9.yyV1^.Supering.Nextion  :=  Tree . MakeTree  ( Tree . mtDesignation ); 
      RETURN yyTempo.yyR9.yyV1;

  END;
  END;
  IF (designor^.Kind = Tree.Dereferencor) THEN
(* line 343 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR10.yyV1  :=  Tree . MakeTree  ( Tree . Dereferencing ); 
      yyTempo.yyR10.yyV1^.Dereferencing.Nextor := designor^.Dereferencor.Nextor;
      yyTempo.yyR10.yyV1^.Dereferencing.Position := designor^.Dereferencor.OpPos;
       yyTempo.yyR10.yyV1^.Dereferencing.Nextion  :=  Tree . MakeTree  ( Tree . mtDesignation ); 
      RETURN yyTempo.yyR10.yyV1;

  END;

  CASE typeRepr^.Kind OF
  | OB.RecordTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
  IF (designor^.Argumentor.ExprList^.Kind = Tree.ExprList) THEN
  IF (designor^.Argumentor.ExprList^.ExprList.Next^.Kind = Tree.mtExprList) THEN
  IF (designor^.Argumentor.ExprList^.ExprList.Expr^.Kind = Tree.DesignExpr) THEN
  IF (designor^.Argumentor.ExprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Designors^.Kind = Tree.mtDesignor) THEN
(* line 358 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR11.yyV1  :=  Tree . MakeTree  ( Tree . Guarding ); 
      yyTempo.yyR11.yyV1^.Guarding.Nextor := designor^.Argumentor.Nextor;
      yyTempo.yyR11.yyV1^.Guarding.Position := designor^.Argumentor.Op1Pos;
       yyTempo.yyR11.yyV1^.Guarding.Nextion  :=  Tree . MakeTree  ( Tree . mtDesignation ); 
      yyTempo.yyR11.yyV1^.Guarding.IsImplicit := FALSE;
       yyTempo.yyR11.yyV1^.Guarding.Qualidents  :=  Tree . MakeTree  ( Tree . UnqualifiedIdent ); 
      yyTempo.yyR11.yyV1^.Guarding.Qualidents^.UnqualifiedIdent.Position := designor^.Argumentor.ExprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Position;
      yyTempo.yyR11.yyV1^.Guarding.Qualidents^.UnqualifiedIdent.Ident := designor^.Argumentor.ExprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Ident;
      RETURN yyTempo.yyR11.yyV1;

  END;
  IF (designor^.Argumentor.ExprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Designors^.Kind = Tree.Selector) THEN
  IF (designor^.Argumentor.ExprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Designors^.Selector.Nextor^.Kind = Tree.mtDesignor) THEN
(* line 428 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR13.yyV1  :=  Tree . MakeTree  ( Tree . Guarding ); 
      yyTempo.yyR13.yyV1^.Guarding.Nextor := designor^.Argumentor.Nextor;
      yyTempo.yyR13.yyV1^.Guarding.Position := designor^.Argumentor.Op1Pos;
       yyTempo.yyR13.yyV1^.Guarding.Nextion  :=  Tree . MakeTree  ( Tree . mtDesignation ); 
      yyTempo.yyR13.yyV1^.Guarding.IsImplicit := FALSE;
       yyTempo.yyR13.yyV1^.Guarding.Qualidents  :=  Tree . MakeTree  ( Tree . QualifiedIdent ); 
      yyTempo.yyR13.yyV1^.Guarding.Qualidents^.QualifiedIdent.Position := designor^.Argumentor.ExprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Position;
      yyTempo.yyR13.yyV1^.Guarding.Qualidents^.QualifiedIdent.ServerId := designor^.Argumentor.ExprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Ident;
      yyTempo.yyR13.yyV1^.Guarding.Qualidents^.QualifiedIdent.Ident := designor^.Argumentor.ExprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Designors^.Selector.Ident;
      yyTempo.yyR13.yyV1^.Guarding.Qualidents^.QualifiedIdent.IdentPos := designor^.Argumentor.ExprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Designors^.Selector.IdPos;
      RETURN yyTempo.yyR13.yyV1;

  END;
  END;
  END;
  END;
  END;
  END;
  | OB.AbsTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 508 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR15.yyV1  :=  Tree . MakeTree  ( Tree . AbsArgumenting ); 
      RETURN ExtractExpr1 (designor, yyTempo.yyR15.yyV1);

  END;
  | OB.AshTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 509 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR16.yyV1  :=  Tree . MakeTree  ( Tree . AshArgumenting ); 
      RETURN ExtractExpr2 (designor, yyTempo.yyR16.yyV1);

  END;
  | OB.CapTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 510 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR17.yyV1  :=  Tree . MakeTree  ( Tree . CapArgumenting ); 
      RETURN ExtractExpr1 (designor, yyTempo.yyR17.yyV1);

  END;
  | OB.ChrTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 511 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR18.yyV1  :=  Tree . MakeTree  ( Tree . ChrArgumenting ); 
      RETURN ExtractExpr1 (designor, yyTempo.yyR18.yyV1);

  END;
  | OB.EntierTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 512 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR19.yyV1  :=  Tree . MakeTree  ( Tree . EntierArgumenting ); 
      RETURN ExtractExpr1 (designor, yyTempo.yyR19.yyV1);

  END;
  | OB.LenTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 513 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR20.yyV1  :=  Tree . MakeTree  ( Tree . LenArgumenting ); 
      RETURN ExtractExpr2 (designor, yyTempo.yyR20.yyV1);

  END;
  | OB.LongTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 514 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR21.yyV1  :=  Tree . MakeTree  ( Tree . LongArgumenting ); 
      RETURN ExtractExpr1 (designor, yyTempo.yyR21.yyV1);

  END;
  | OB.MaxTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 515 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR22.yyV1  :=  Tree . MakeTree  ( Tree . MaxArgumenting ); 
      RETURN ExtractExprType (designor, yyTempo.yyR22.yyV1);

  END;
  | OB.MinTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 516 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR23.yyV1  :=  Tree . MakeTree  ( Tree . MinArgumenting ); 
      RETURN ExtractExprType (designor, yyTempo.yyR23.yyV1);

  END;
  | OB.OddTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 517 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR24.yyV1  :=  Tree . MakeTree  ( Tree . OddArgumenting ); 
      RETURN ExtractExpr1 (designor, yyTempo.yyR24.yyV1);

  END;
  | OB.OrdTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 518 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR25.yyV1  :=  Tree . MakeTree  ( Tree . OrdArgumenting ); 
      RETURN ExtractExpr1 (designor, yyTempo.yyR25.yyV1);

  END;
  | OB.ShortTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 519 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR26.yyV1  :=  Tree . MakeTree  ( Tree . ShortArgumenting ); 
      RETURN ExtractExpr1 (designor, yyTempo.yyR26.yyV1);

  END;
  | OB.SizeTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 520 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR27.yyV1  :=  Tree . MakeTree  ( Tree . SizeArgumenting ); 
      RETURN ExtractExprType (designor, yyTempo.yyR27.yyV1);

  END;
  | OB.AssertTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 522 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR28.yyV1  :=  Tree . MakeTree  ( Tree . AssertArgumenting ); 
      RETURN ExtractExpr2 (designor, yyTempo.yyR28.yyV1);

  END;
  | OB.CopyTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 523 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR29.yyV1  :=  Tree . MakeTree  ( Tree . CopyArgumenting ); 
      RETURN ExtractExpr2 (designor, yyTempo.yyR29.yyV1);

  END;
  | OB.DecTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 524 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR30.yyV1  :=  Tree . MakeTree  ( Tree . DecArgumenting ); 
      RETURN ExtractExpr2 (designor, yyTempo.yyR30.yyV1);

  END;
  | OB.ExclTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 525 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR31.yyV1  :=  Tree . MakeTree  ( Tree . ExclArgumenting ); 
      RETURN ExtractExpr2 (designor, yyTempo.yyR31.yyV1);

  END;
  | OB.HaltTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 526 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR32.yyV1  :=  Tree . MakeTree  ( Tree . HaltArgumenting ); 
      RETURN ExtractExpr1 (designor, yyTempo.yyR32.yyV1);

  END;
  | OB.IncTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 527 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR33.yyV1  :=  Tree . MakeTree  ( Tree . IncArgumenting ); 
      RETURN ExtractExpr2 (designor, yyTempo.yyR33.yyV1);

  END;
  | OB.InclTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 528 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR34.yyV1  :=  Tree . MakeTree  ( Tree . InclArgumenting ); 
      RETURN ExtractExpr2 (designor, yyTempo.yyR34.yyV1);

  END;
  | OB.NewTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 529 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR35.yyV1  :=  Tree . MakeTree  ( Tree . NewArgumenting ); 
      RETURN ExtractExprNew (designor, yyTempo.yyR35.yyV1);

  END;
  | OB.SysAdrTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 531 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR36.yyV1  :=  Tree . MakeTree  ( Tree . SysAdrArgumenting ); 
      RETURN ExtractExpr1 (designor, yyTempo.yyR36.yyV1);

  END;
  | OB.SysBitTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 532 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR37.yyV1  :=  Tree . MakeTree  ( Tree . SysBitArgumenting ); 
      RETURN ExtractExpr2 (designor, yyTempo.yyR37.yyV1);

  END;
  | OB.SysCcTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 533 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR38.yyV1  :=  Tree . MakeTree  ( Tree . SysCcArgumenting ); 
      RETURN ExtractExpr1 (designor, yyTempo.yyR38.yyV1);

  END;
  | OB.SysLshTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 534 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR39.yyV1  :=  Tree . MakeTree  ( Tree . SysLshArgumenting ); 
      RETURN ExtractExpr2 (designor, yyTempo.yyR39.yyV1);

  END;
  | OB.SysRotTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 535 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR40.yyV1  :=  Tree . MakeTree  ( Tree . SysRotArgumenting ); 
      RETURN ExtractExpr2 (designor, yyTempo.yyR40.yyV1);

  END;
  | OB.SysValTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 536 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR41.yyV1  :=  Tree . MakeTree  ( Tree . SysValArgumenting ); 
      RETURN ExtractExprVal (designor, yyTempo.yyR41.yyV1);

  END;
  | OB.SysGetTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 538 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR42.yyV1  :=  Tree . MakeTree  ( Tree . SysGetArgumenting ); 
      RETURN ExtractExpr2 (designor, yyTempo.yyR42.yyV1);

  END;
  | OB.SysPutTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 539 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR43.yyV1  :=  Tree . MakeTree  ( Tree . SysPutArgumenting ); 
      RETURN ExtractExpr2 (designor, yyTempo.yyR43.yyV1);

  END;
  | OB.SysGetregTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 540 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR44.yyV1  :=  Tree . MakeTree  ( Tree . SysGetregArgumenting ); 
      RETURN ExtractExpr2 (designor, yyTempo.yyR44.yyV1);

  END;
  | OB.SysPutregTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 541 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR45.yyV1  :=  Tree . MakeTree  ( Tree . SysPutregArgumenting ); 
      RETURN ExtractExpr2 (designor, yyTempo.yyR45.yyV1);

  END;
  | OB.SysMoveTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 542 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR46.yyV1  :=  Tree . MakeTree  ( Tree . SysMoveArgumenting ); 
      RETURN ExtractExpr3 (designor, yyTempo.yyR46.yyV1);

  END;
  | OB.SysNewTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 543 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR47.yyV1  :=  Tree . MakeTree  ( Tree . SysNewArgumenting ); 
      RETURN ExtractExpr2 (designor, yyTempo.yyR47.yyV1);

  END;
  | OB.SysAsmTypeRepr:
  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 544 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR48.yyV1  :=  Tree . MakeTree  ( Tree . SysAsmArgumenting ); 
      RETURN ExtractExprAsm (designor, yyTempo.yyR48.yyV1);

  END;
  ELSE END;

  IF (designor^.Kind = Tree.Argumentor) THEN
(* line 549 "TT.pum" *)
       yyP13  :=  Tree . MakeTree  ( Tree . mtDesignor ); 
       yyTempo.yyR49.yyV1  :=  Tree . MakeTree  ( Tree . Argumenting ); 
      yyTempo.yyR49.yyV1^.Argumenting.Nextor := designor^.Argumentor.Nextor;
      yyTempo.yyR49.yyV1^.Argumenting.Position := designor^.Argumentor.Op1Pos;
       yyTempo.yyR49.yyV1^.Argumenting.Nextion  :=  Tree . MakeTree  ( Tree . mtDesignation ); 
      yyTempo.yyR49.yyV1^.Argumenting.Op2Pos := designor^.Argumentor.Op2Pos;
      yyTempo.yyR49.yyV1^.Argumenting.ExprList := designor^.Argumentor.ExprList;
      RETURN yyTempo.yyR49.yyV1;

  END;
  yyAbort ('DesignorToDesignation');
 END DesignorToDesignation;

PROCEDURE ExtractExpr1 (yyP14: Tree.tTree; argNode: Tree.tTree): Tree.tTree;
 BEGIN
  IF (yyP14^.Kind = Tree.Argumentor) THEN
  IF (yyP14^.Argumentor.ExprList^.Kind = Tree.mtExprList) THEN
  IF Tree.IsType (argNode, Tree.PredeclArgumenting1) THEN
(* line 576 "TT.pum" *)
(* line 590 "TT.pum" *)
       argNode^.PredeclArgumenting1.Nextor  := yyP14^.Argumentor.Nextor;
                  argNode^.PredeclArgumenting1.Position := yyP14^.Argumentor.Op1Pos;
                  argNode^.PredeclArgumenting1.Op2Pos := yyP14^.Argumentor.Op2Pos;
                  argNode^.PredeclArgumenting1.Expr  := Tree.mmtExpr(POS.NoPosition);
                  argNode^.PredeclArgumenting1.ExprLists  := Tree.mmtExprList();
                ;
      RETURN argNode;

  END;
  END;
  IF (yyP14^.Argumentor.ExprList^.Kind = Tree.ExprList) THEN
  IF Tree.IsType (argNode, Tree.PredeclArgumenting1) THEN
(* line 600 "TT.pum" *)
(* line 617 "TT.pum" *)
       argNode^.PredeclArgumenting1.Nextor  := yyP14^.Argumentor.Nextor;
                  argNode^.PredeclArgumenting1.Position := yyP14^.Argumentor.Op1Pos;
                  argNode^.PredeclArgumenting1.Op2Pos := yyP14^.Argumentor.Op2Pos;
                  argNode^.PredeclArgumenting1.Expr  := yyP14^.Argumentor.ExprList^.ExprList.Expr;
                  argNode^.PredeclArgumenting1.ExprLists  := yyP14^.Argumentor.ExprList^.ExprList.Next;
                ;
      RETURN argNode;

  END;
  END;
  END;
  yyAbort ('ExtractExpr1');
 END ExtractExpr1;

PROCEDURE ExtractExpr2 (yyP15: Tree.tTree; argNode: Tree.tTree): Tree.tTree;
 BEGIN
  IF (yyP15^.Kind = Tree.Argumentor) THEN
  IF (yyP15^.Argumentor.ExprList^.Kind = Tree.mtExprList) THEN
  IF Tree.IsType (argNode, Tree.PredeclArgumenting2Opt) THEN
(* line 635 "TT.pum" *)
(* line 650 "TT.pum" *)
       argNode^.PredeclArgumenting2Opt.Nextor  := yyP15^.Argumentor.Nextor;
                  argNode^.PredeclArgumenting2Opt.Position := yyP15^.Argumentor.Op1Pos;
                  argNode^.PredeclArgumenting2Opt.Op2Pos := yyP15^.Argumentor.Op2Pos;
                  argNode^.PredeclArgumenting2Opt.Expr1 := Tree.mmtExpr(POS.NoPosition);
                  argNode^.PredeclArgumenting2Opt.Expr2 := Tree.mmtExpr(POS.NoPosition);
                  argNode^.PredeclArgumenting2Opt.ExprLists  := Tree.mmtExprList();
                ;
      RETURN argNode;

  END;
  END;
  IF (yyP15^.Argumentor.ExprList^.Kind = Tree.ExprList) THEN
  IF (yyP15^.Argumentor.ExprList^.ExprList.Next^.Kind = Tree.mtExprList) THEN
  IF Tree.IsType (argNode, Tree.PredeclArgumenting2Opt) THEN
(* line 661 "TT.pum" *)
(* line 679 "TT.pum" *)
       argNode^.PredeclArgumenting2Opt.Nextor  := yyP15^.Argumentor.Nextor;
                  argNode^.PredeclArgumenting2Opt.Position := yyP15^.Argumentor.Op1Pos;
                  argNode^.PredeclArgumenting2Opt.Op2Pos := yyP15^.Argumentor.Op2Pos;
                  argNode^.PredeclArgumenting2Opt.Expr1 := yyP15^.Argumentor.ExprList^.ExprList.Expr;
                  argNode^.PredeclArgumenting2Opt.Expr2 := Tree.mmtExpr(POS.NoPosition);
                  argNode^.PredeclArgumenting2Opt.ExprLists  := Tree.mmtExprList();
                ;
      RETURN argNode;

  END;
  END;
  IF (yyP15^.Argumentor.ExprList^.ExprList.Next^.Kind = Tree.ExprList) THEN
  IF Tree.IsType (argNode, Tree.PredeclArgumenting2Opt) THEN
(* line 690 "TT.pum" *)
(* line 710 "TT.pum" *)
       argNode^.PredeclArgumenting2Opt.Nextor  := yyP15^.Argumentor.Nextor;
                  argNode^.PredeclArgumenting2Opt.Position := yyP15^.Argumentor.Op1Pos;
                  argNode^.PredeclArgumenting2Opt.Op2Pos := yyP15^.Argumentor.Op2Pos;
                  argNode^.PredeclArgumenting2Opt.Expr1 := yyP15^.Argumentor.ExprList^.ExprList.Expr;
                  argNode^.PredeclArgumenting2Opt.Expr2 := yyP15^.Argumentor.ExprList^.ExprList.Next^.ExprList.Expr;
                  argNode^.PredeclArgumenting2Opt.ExprLists  := yyP15^.Argumentor.ExprList^.ExprList.Next^.ExprList.Next;
                ;
      RETURN argNode;

  END;
  END;
  END;
  END;
  yyAbort ('ExtractExpr2');
 END ExtractExpr2;

PROCEDURE ExtractExpr3 (yyP16: Tree.tTree; argNode: Tree.tTree): Tree.tTree;
 BEGIN
  IF (yyP16^.Kind = Tree.Argumentor) THEN
  IF (yyP16^.Argumentor.ExprList^.Kind = Tree.mtExprList) THEN
  IF Tree.IsType (argNode, Tree.PredeclArgumenting3) THEN
(* line 729 "TT.pum" *)
(* line 745 "TT.pum" *)
       argNode^.PredeclArgumenting3.Nextor  := yyP16^.Argumentor.Nextor;
                  argNode^.PredeclArgumenting3.Position := yyP16^.Argumentor.Op1Pos;
                  argNode^.PredeclArgumenting3.Op2Pos := yyP16^.Argumentor.Op2Pos;
                  argNode^.PredeclArgumenting3.Expr1 := Tree.mmtExpr(POS.NoPosition);
                  argNode^.PredeclArgumenting3.Expr2 := Tree.mmtExpr(POS.NoPosition);
                  argNode^.PredeclArgumenting3.Expr3 := Tree.mmtExpr(POS.NoPosition);
                  argNode^.PredeclArgumenting3.ExprLists  := Tree.mmtExprList();
                ;
      RETURN argNode;

  END;
  END;
  IF (yyP16^.Argumentor.ExprList^.Kind = Tree.ExprList) THEN
  IF (yyP16^.Argumentor.ExprList^.ExprList.Next^.Kind = Tree.mtExprList) THEN
  IF Tree.IsType (argNode, Tree.PredeclArgumenting3) THEN
(* line 757 "TT.pum" *)
(* line 776 "TT.pum" *)
       argNode^.PredeclArgumenting3.Nextor  := yyP16^.Argumentor.Nextor;
                  argNode^.PredeclArgumenting3.Position := yyP16^.Argumentor.Op1Pos;
                  argNode^.PredeclArgumenting3.Op2Pos := yyP16^.Argumentor.Op2Pos;
                  argNode^.PredeclArgumenting3.Expr1 := yyP16^.Argumentor.ExprList^.ExprList.Expr;
                  argNode^.PredeclArgumenting3.Expr2 := Tree.mmtExpr(POS.NoPosition);
                  argNode^.PredeclArgumenting3.Expr3 := Tree.mmtExpr(POS.NoPosition);
                  argNode^.PredeclArgumenting3.ExprLists  := yyP16^.Argumentor.ExprList^.ExprList.Next;
                ;
      RETURN argNode;

  END;
  END;
  IF (yyP16^.Argumentor.ExprList^.ExprList.Next^.Kind = Tree.ExprList) THEN
  IF (yyP16^.Argumentor.ExprList^.ExprList.Next^.ExprList.Next^.Kind = Tree.mtExprList) THEN
  IF Tree.IsType (argNode, Tree.PredeclArgumenting3) THEN
(* line 788 "TT.pum" *)
(* line 809 "TT.pum" *)
       argNode^.PredeclArgumenting3.Nextor  := yyP16^.Argumentor.Nextor;
                  argNode^.PredeclArgumenting3.Position := yyP16^.Argumentor.Op1Pos;
                  argNode^.PredeclArgumenting3.Op2Pos := yyP16^.Argumentor.Op2Pos;
                  argNode^.PredeclArgumenting3.Expr1 := yyP16^.Argumentor.ExprList^.ExprList.Expr;
                  argNode^.PredeclArgumenting3.Expr2 := yyP16^.Argumentor.ExprList^.ExprList.Next^.ExprList.Expr;
                  argNode^.PredeclArgumenting3.Expr3 := Tree.mmtExpr(POS.NoPosition);
                  argNode^.PredeclArgumenting3.ExprLists  := yyP16^.Argumentor.ExprList^.ExprList.Next^.ExprList.Next;
                ;
      RETURN argNode;

  END;
  END;
  IF (yyP16^.Argumentor.ExprList^.ExprList.Next^.ExprList.Next^.Kind = Tree.ExprList) THEN
  IF Tree.IsType (argNode, Tree.PredeclArgumenting3) THEN
(* line 821 "TT.pum" *)
(* line 844 "TT.pum" *)
       argNode^.PredeclArgumenting3.Nextor  := yyP16^.Argumentor.Nextor;
                  argNode^.PredeclArgumenting3.Position := yyP16^.Argumentor.Op1Pos;
                  argNode^.PredeclArgumenting3.Op2Pos := yyP16^.Argumentor.Op2Pos;
                  argNode^.PredeclArgumenting3.Expr1 := yyP16^.Argumentor.ExprList^.ExprList.Expr;
                  argNode^.PredeclArgumenting3.Expr2 := yyP16^.Argumentor.ExprList^.ExprList.Next^.ExprList.Expr;
                  argNode^.PredeclArgumenting3.Expr3 := yyP16^.Argumentor.ExprList^.ExprList.Next^.ExprList.Next^.ExprList.Expr;
                  argNode^.PredeclArgumenting3.ExprLists  := yyP16^.Argumentor.ExprList^.ExprList.Next^.ExprList.Next^.ExprList.Next;
                ;
      RETURN argNode;

  END;
  END;
  END;
  END;
  END;
  yyAbort ('ExtractExpr3');
 END ExtractExpr3;

PROCEDURE ExtractExprType (yyP17: Tree.tTree; argNode: Tree.tTree): Tree.tTree;
 BEGIN
  IF (yyP17^.Kind = Tree.Argumentor) THEN
  IF Tree.IsType (argNode, Tree.TypeArgumenting) THEN
(* line 862 "TT.pum" *)
(* line 876 "TT.pum" *)
       argNode^.TypeArgumenting.Nextor  := yyP17^.Argumentor.Nextor;
                  argNode^.TypeArgumenting.Position := yyP17^.Argumentor.Op1Pos;
                  argNode^.TypeArgumenting.Op2Pos := yyP17^.Argumentor.Op2Pos;
                  argNode^.TypeArgumenting.Qualidents  := ExtractFirstQualident(yyP17^.Argumentor.ExprList,argNode^.TypeArgumenting.ExprLists);
                ;
      RETURN argNode;

  END;
  END;
  yyAbort ('ExtractExprType');
 END ExtractExprType;

PROCEDURE ExtractExprVal (yyP18: Tree.tTree; argNode: Tree.tTree): Tree.tTree;
 BEGIN
  IF (yyP18^.Kind = Tree.Argumentor) THEN
  IF (argNode^.Kind = Tree.SysValArgumenting) THEN
(* line 893 "TT.pum" *)
(* line 908 "TT.pum" *)
       argNode^.SysValArgumenting.Nextor  := yyP18^.Argumentor.Nextor;
                  argNode^.SysValArgumenting.Position := yyP18^.Argumentor.Op1Pos;
                  argNode^.SysValArgumenting.Op2Pos := yyP18^.Argumentor.Op2Pos;
                  argNode^.SysValArgumenting.Qualidents  := ExtractFirstQualident(yyP18^.Argumentor.ExprList,argNode^.SysValArgumenting.ExprLists);
                  argNode^.SysValArgumenting.Expr  := ExtractFirstExpr(argNode^.SysValArgumenting.ExprLists,argNode^.SysValArgumenting.ExprLists);
                ;
      RETURN argNode;

  END;
  END;
  yyAbort ('ExtractExprVal');
 END ExtractExprVal;

PROCEDURE ExtractExprNew (yyP19: Tree.tTree; argNode: Tree.tTree): Tree.tTree;
 BEGIN
  IF (yyP19^.Kind = Tree.Argumentor) THEN
  IF (yyP19^.Argumentor.ExprList^.Kind = Tree.mtExprList) THEN
  IF (argNode^.Kind = Tree.NewArgumenting) THEN
(* line 927 "TT.pum" *)
(* line 941 "TT.pum" *)
       argNode^.NewArgumenting.Nextor  := yyP19^.Argumentor.Nextor;
                  argNode^.NewArgumenting.Position := yyP19^.Argumentor.Op1Pos;
                  argNode^.NewArgumenting.Op2Pos := yyP19^.Argumentor.Op2Pos;
                  argNode^.NewArgumenting.Expr  := Tree.mmtExpr(POS.NoPosition);
                  argNode^.NewArgumenting.NewExprLists  := Tree.mmtNewExprList();
                ;
      RETURN argNode;

  END;
  END;
  IF (yyP19^.Argumentor.ExprList^.Kind = Tree.ExprList) THEN
  IF (argNode^.Kind = Tree.NewArgumenting) THEN
(* line 951 "TT.pum" *)
(* line 968 "TT.pum" *)
       argNode^.NewArgumenting.Nextor  := yyP19^.Argumentor.Nextor;
                  argNode^.NewArgumenting.Position := yyP19^.Argumentor.Op1Pos;
                  argNode^.NewArgumenting.Op2Pos := yyP19^.Argumentor.Op2Pos;
                  argNode^.NewArgumenting.Expr  := yyP19^.Argumentor.ExprList^.ExprList.Expr;
                  argNode^.NewArgumenting.NewExprLists  := ExprListToNewExprList(yyP19^.Argumentor.ExprList^.ExprList.Next);
                ;
      RETURN argNode;

  END;
  END;
  END;
  yyAbort ('ExtractExprNew');
 END ExtractExprNew;

PROCEDURE ExtractExprAsm (yyP20: Tree.tTree; argNode: Tree.tTree): Tree.tTree;
 BEGIN
  IF (yyP20^.Kind = Tree.Argumentor) THEN
  IF (argNode^.Kind = Tree.SysAsmArgumenting) THEN
(* line 986 "TT.pum" *)
(* line 999 "TT.pum" *)
       argNode^.SysAsmArgumenting.Nextor  := yyP20^.Argumentor.Nextor;
                  argNode^.SysAsmArgumenting.Position := yyP20^.Argumentor.Op1Pos;
                  argNode^.SysAsmArgumenting.Op2Pos := yyP20^.Argumentor.Op2Pos;
                  argNode^.SysAsmArgumenting.SysAsmExprLists  := ExprListToSysAsmExprList(yyP20^.Argumentor.ExprList);
                ;
      RETURN argNode;

  END;
  END;
  yyAbort ('ExtractExprAsm');
 END ExtractExprAsm;

PROCEDURE ExprListToNewExprList (yyP21: Tree.tTree): Tree.tTree;
 VAR yyTempo: RECORD
 yyR1: RECORD
  yyV1: Tree.tTree;
  END;
 yyR2: RECORD
  yyV1: Tree.tTree;
  END;
 END;
 BEGIN
  IF (yyP21^.Kind = Tree.mtExprList) THEN
(* line 1012 "TT.pum" *)
       yyTempo.yyR1.yyV1  :=  Tree . MakeTree  ( Tree . mtNewExprList ); 
      RETURN yyTempo.yyR1.yyV1;

  END;
  IF (yyP21^.Kind = Tree.ExprList) THEN
(* line 1016 "TT.pum" *)
       yyTempo.yyR2.yyV1  :=  Tree . MakeTree  ( Tree . NewExprList ); 
      yyTempo.yyR2.yyV1^.NewExprList.Next := ExprListToNewExprList (yyP21^.ExprList.Next);
      yyTempo.yyR2.yyV1^.NewExprList.Expr := yyP21^.ExprList.Expr;
      RETURN yyTempo.yyR2.yyV1;

  END;
  yyAbort ('ExprListToNewExprList');
 END ExprListToNewExprList;

PROCEDURE ExprListToSysAsmExprList (yyP22: Tree.tTree): Tree.tTree;
 VAR yyTempo: RECORD
 yyR1: RECORD
  yyV1: Tree.tTree;
  END;
 yyR2: RECORD
  yyV1: Tree.tTree;
  END;
 END;
 BEGIN
  IF (yyP22^.Kind = Tree.mtExprList) THEN
(* line 1031 "TT.pum" *)
       yyTempo.yyR1.yyV1  :=  Tree . MakeTree  ( Tree . mtSysAsmExprList ); 
      RETURN yyTempo.yyR1.yyV1;

  END;
  IF (yyP22^.Kind = Tree.ExprList) THEN
(* line 1035 "TT.pum" *)
       yyTempo.yyR2.yyV1  :=  Tree . MakeTree  ( Tree . SysAsmExprList ); 
      yyTempo.yyR2.yyV1^.SysAsmExprList.Next := ExprListToSysAsmExprList (yyP22^.ExprList.Next);
      yyTempo.yyR2.yyV1^.SysAsmExprList.Expr := yyP22^.ExprList.Expr;
      RETURN yyTempo.yyR2.yyV1;

  END;
  yyAbort ('ExprListToSysAsmExprList');
 END ExprListToSysAsmExprList;

PROCEDURE ExtractFirstQualident (exprList: Tree.tTree; VAR yyP23: Tree.tTree): Tree.tTree;
 VAR yyTempo: RECORD
 yyR1: RECORD
  yyV1: Tree.tTree;
  END;
 yyR2: RECORD
  yyV1: Tree.tTree;
  END;
 yyR3: RECORD
  yyV1: Tree.tTree;
  END;
 yyR4: RECORD
  yyV1: Tree.tTree;
  END;
 END;
 BEGIN
  IF (exprList^.Kind = Tree.ExprList) THEN
  IF (exprList^.ExprList.Expr^.Kind = Tree.DesignExpr) THEN
  IF (exprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Designors^.Kind = Tree.mtDesignor) THEN
(* line 1054 "TT.pum" *)
      yyP23 := exprList^.ExprList.Next;
       yyTempo.yyR1.yyV1  :=  Tree . MakeTree  ( Tree . UnqualifiedIdent ); 
      yyTempo.yyR1.yyV1^.UnqualifiedIdent.Position := exprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Position;
      yyTempo.yyR1.yyV1^.UnqualifiedIdent.Ident := exprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Ident;
      RETURN yyTempo.yyR1.yyV1;

  END;
  IF (exprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Designors^.Kind = Tree.Selector) THEN
  IF (exprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Designors^.Selector.Nextor^.Kind = Tree.mtDesignor) THEN
(* line 1074 "TT.pum" *)
      yyP23 := exprList^.ExprList.Next;
       yyTempo.yyR2.yyV1  :=  Tree . MakeTree  ( Tree . QualifiedIdent ); 
      yyTempo.yyR2.yyV1^.QualifiedIdent.Position := exprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Position;
      yyTempo.yyR2.yyV1^.QualifiedIdent.ServerId := exprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Ident;
      yyTempo.yyR2.yyV1^.QualifiedIdent.Ident := exprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Designors^.Selector.Ident;
      yyTempo.yyR2.yyV1^.QualifiedIdent.IdentPos := exprList^.ExprList.Expr^.DesignExpr.Designator^.Designator.Designors^.Selector.IdPos;
      RETURN yyTempo.yyR2.yyV1;

  END;
  END;
  END;
(* line 1100 "TT.pum" *)
      yyP23 := exprList^.ExprList.Next;
       yyTempo.yyR3.yyV1  :=  Tree . MakeTree  ( Tree . ErrorQualident ); 
      yyTempo.yyR3.yyV1^.ErrorQualident.Position := exprList^.ExprList.Expr^.Exprs.Position;
      RETURN yyTempo.yyR3.yyV1;

  END;
  IF (exprList^.Kind = Tree.mtExprList) THEN
(* line 1112 "TT.pum" *)
      yyP23 := exprList;
       yyTempo.yyR4.yyV1  :=  Tree . MakeTree  ( Tree . mtQualident ); 
      yyTempo.yyR4.yyV1^.mtQualident.Position := POS.NoPosition;
      RETURN yyTempo.yyR4.yyV1;

  END;
  yyAbort ('ExtractFirstQualident');
 END ExtractFirstQualident;

PROCEDURE ExtractFirstExpr (exprList: Tree.tTree; VAR yyP24: Tree.tTree): Tree.tTree;
 VAR yyTempo: RECORD
 yyR2: RECORD
  yyV1: Tree.tTree;
  END;
 END;
 BEGIN
  IF (exprList^.Kind = Tree.ExprList) THEN
(* line 1128 "TT.pum" *)
      yyP24 := exprList^.ExprList.Next;
      RETURN exprList^.ExprList.Expr;

  END;
(* line 1137 "TT.pum" *)
      yyP24 := exprList;
       yyTempo.yyR2.yyV1  :=  Tree . MakeTree  ( Tree . mtExpr ); 
      yyTempo.yyR2.yyV1^.mtExpr.Position := POS.NoPosition;
      RETURN yyTempo.yyR2.yyV1;

 END ExtractFirstExpr;

PROCEDURE BeginTT*;
 BEGIN
 END BeginTT;

PROCEDURE CloseTT*;
 BEGIN
 END CloseTT;

PROCEDURE yyExit;
 BEGIN
  IO.CloseIO; System.Exit (1);
 END yyExit;

BEGIN
 yyf	:= IO.StdOutput;
 Exit	:= yyExit;
 BeginTT;
END TT.

