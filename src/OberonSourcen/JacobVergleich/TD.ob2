MODULE TD;








IMPORT SYSTEM, System, IO, OB, Tree,
(* line 9 "TD.pum" *)
 ED, Idents, OT, UTI, V;
        CONST  BRACKETS   = TRUE;
               NOBRACKETS = FALSE;
        VAR    E          : ED.tEditor;
VAR yyf*	: IO.tFile;
VAR Exit*	: PROCEDURE;


        PROCEDURE MaxSC(a, b:LONGINT):LONGINT; 
        BEGIN
         IF a>b THEN RETURN a; ELSE RETURN b; END;
        END MaxSC;

        PROCEDURE NotNilCoerce(co : OB.tOB) : OB.tOB;
        BEGIN
         IF co = OB.NoOB THEN RETURN OB.cmtCoercion; ELSE RETURN co END; 
        END NotNilCoerce; 


























PROCEDURE^DumpPredecl (yyP10: Tree.tTree);
PROCEDURE^DumpSetExpr (val: OB.tOB; expr: Tree.tTree);
PROCEDURE^DumpElements (yyP9: Tree.tTree; isFirst: BOOLEAN);
PROCEDURE^DumpValue (yyP11: OB.tOB);
PROCEDURE^DumpExpr (coerce: OB.tOB; expr: Tree.tTree; brackets: BOOLEAN);










































































































PROCEDURE yyAbort (yyFunction: ARRAY OF CHAR);
 BEGIN
  IO.WriteS (IO.StdError, 'Error: module TD, routine ');
  IO.WriteS (IO.StdError, yyFunction);
  IO.WriteS (IO.StdError, ' failed');
  IO.WriteNl (IO.StdError);
  Exit;
 END yyAbort;

PROCEDURE yyIsEqual* (VAR yya, yyb: ARRAY OF SYSTEM.BYTE): BOOLEAN;
 VAR yyi:LONGINT; 
 BEGIN
  FOR yyi := 0 TO (LEN(yya)) DO
   IF SYSTEM.VAL(CHAR,yya [yyi]) # SYSTEM.VAL(CHAR,yyb [yyi]) THEN RETURN FALSE; END;
  END;
  RETURN TRUE;
 END yyIsEqual;

PROCEDURE MaxImportRefLen (yyP1: Tree.tTree):LONGINT; 
 BEGIN
  IF (yyP1^.Kind = Tree.Import) THEN
(* line 26 "TD.pum" *)
      RETURN MaxSC(MaxImportRefLen(yyP1^.Import.Next),UTI.IdentLength(yyP1^.Import.RefId));

  END;
(* line 27 "TD.pum" *)
      RETURN 0;

 END MaxImportRefLen;

PROCEDURE MaxImportSrvLen (yyP2: Tree.tTree):LONGINT; 
 BEGIN
  IF (yyP2^.Kind = Tree.Import) THEN
  IF ( yyP2^.Import.ServerId  =   yyP2^.Import.RefId  ) THEN
(* line 31 "TD.pum" *)
      RETURN MaxImportSrvLen(yyP2^.Import.Next);

  END;
(* line 32 "TD.pum" *)
      RETURN MaxSC(MaxImportSrvLen(yyP2^.Import.Next),UTI.IdentLength(yyP2^.Import.ServerId));

  END;
(* line 33 "TD.pum" *)
      RETURN 0;

 END MaxImportSrvLen;

PROCEDURE MaxDeclIdentLen (yyP3: Tree.tTree):LONGINT; 
 BEGIN

  CASE yyP3^.Kind OF
  | Tree.DeclUnit:
(* line 37 "TD.pum" *)
      RETURN MaxSC(MaxDeclIdentLen(yyP3^.DeclUnit.Decls),MaxDeclIdentLen(yyP3^.DeclUnit.Next));

  | Tree.ConstDecl:
(* line 38 "TD.pum" *)
      RETURN MaxSC(MaxDeclIdentLen(yyP3^.ConstDecl.IdentDef),MaxDeclIdentLen(yyP3^.ConstDecl.Next));

  | Tree.TypeDecl:
(* line 39 "TD.pum" *)
      RETURN MaxSC(MaxDeclIdentLen(yyP3^.TypeDecl.IdentDef),MaxDeclIdentLen(yyP3^.TypeDecl.Next));

  | Tree.VarDecl:
(* line 40 "TD.pum" *)
      RETURN MaxSC(MaxDeclIdentLen(yyP3^.VarDecl.IdentLists),MaxDeclIdentLen(yyP3^.VarDecl.Next));

  | Tree.FieldList:
  IF (yyP3^.FieldList.IdentLists^.Kind = Tree.IdentList) THEN
(* line 41 "TD.pum" *)
      RETURN MaxSC(MaxDeclIdentLen(yyP3^.FieldList.IdentLists),MaxDeclIdentLen(yyP3^.FieldList.Next));

  END;
  | Tree.IdentList:
(* line 42 "TD.pum" *)
      RETURN MaxSC(MaxDeclIdentLen(yyP3^.IdentList.IdentDef),MaxDeclIdentLen(yyP3^.IdentList.Next));

  | Tree.IdentDef:
  IF (yyIsEqual ( yyP3^.IdentDef.ExportMode ,   OB.PRIVATE ) ) THEN
(* line 43 "TD.pum" *)
      RETURN UTI.IdentLength(yyP3^.IdentDef.Ident);

  END;
  IF (yyIsEqual ( yyP3^.IdentDef.ExportMode ,   OB.PUBLIC ) ) THEN
(* line 44 "TD.pum" *)
      RETURN 1+UTI.IdentLength(yyP3^.IdentDef.Ident);

  END;
  IF (yyIsEqual ( yyP3^.IdentDef.ExportMode ,   OB.READONLY ) ) THEN
(* line 45 "TD.pum" *)
      RETURN 1+UTI.IdentLength(yyP3^.IdentDef.Ident);

  END;
  ELSE END;

(* line 46 "TD.pum" *)
      RETURN 0;

 END MaxDeclIdentLen;

PROCEDURE MaxParamModeLen (yyP4: Tree.tTree):LONGINT; 
 BEGIN
  IF (yyP4^.Kind = Tree.FPSection) THEN
  IF (yyIsEqual ( yyP4^.FPSection.ParMode ,   OB.REFPAR ) ) THEN
(* line 50 "TD.pum" *)
      RETURN 4;

  END;
  IF (yyIsEqual ( yyP4^.FPSection.ParMode ,   OB.VALPAR ) ) THEN
(* line 51 "TD.pum" *)
      RETURN MaxParamModeLen(yyP4^.FPSection.Next);

  END;
  END;
(* line 52 "TD.pum" *)
      RETURN 0;

 END MaxParamModeLen;

PROCEDURE MaxParamIdLen (yyP5: Tree.tTree):LONGINT; 
 BEGIN
  IF (yyP5^.Kind = Tree.FPSection) THEN
(* line 56 "TD.pum" *)
      RETURN MaxSC(MaxParamIdLen(yyP5^.FPSection.ParIds),MaxParamIdLen(yyP5^.FPSection.Next));

  END;
  IF (yyP5^.Kind = Tree.ParId) THEN
(* line 57 "TD.pum" *)
      RETURN MaxSC(UTI.IdentLength(yyP5^.ParId.Ident),MaxParamIdLen(yyP5^.ParId.Next));

  END;
(* line 58 "TD.pum" *)
      RETURN 0;

 END MaxParamIdLen;

PROCEDURE ProcsDeclared (yyP6: Tree.tTree): BOOLEAN;
 BEGIN
  IF yyP6 = Tree.NoTree THEN RETURN FALSE; END;
  IF (yyP6^.Kind = Tree.DeclSection) THEN
(* line 62 "TD.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END ProcsDeclared;

PROCEDURE IsEmpty (yyP7: Tree.tTree): BOOLEAN;
 BEGIN
  IF yyP7 = Tree.NoTree THEN RETURN FALSE; END;

  CASE yyP7^.Kind OF
  | Tree.mtImport:
(* line 66 "TD.pum" *)
      RETURN TRUE;

  | Tree.mtDeclUnit:
(* line 67 "TD.pum" *)
      RETURN TRUE;

  | Tree.mtDecl:
(* line 68 "TD.pum" *)
      RETURN TRUE;

  | Tree.mtProc:
(* line 69 "TD.pum" *)
      RETURN TRUE;

  | Tree.mtFPSection:
(* line 70 "TD.pum" *)
      RETURN TRUE;

  | Tree.mtParId:
(* line 71 "TD.pum" *)
      RETURN TRUE;

  | Tree.mtType:
(* line 72 "TD.pum" *)
      RETURN TRUE;

  | Tree.mtArrayExprList:
(* line 73 "TD.pum" *)
      RETURN TRUE;

  | Tree.mtFieldList:
(* line 74 "TD.pum" *)
      RETURN TRUE;

  | Tree.mtIdentList:
(* line 75 "TD.pum" *)
      RETURN TRUE;

  | Tree.mtStmt:
(* line 76 "TD.pum" *)
      RETURN TRUE;

  | Tree.NoStmts:
(* line 77 "TD.pum" *)
      RETURN TRUE;

  | Tree.mtCase:
(* line 78 "TD.pum" *)
      RETURN TRUE;

  | Tree.mtCaseLabel:
(* line 79 "TD.pum" *)
      RETURN TRUE;

  | Tree.mtGuardedStmt:
(* line 80 "TD.pum" *)
      RETURN TRUE;

  | Tree.mtExpr:
(* line 81 "TD.pum" *)
      RETURN TRUE;

  | Tree.mtElement:
(* line 82 "TD.pum" *)
      RETURN TRUE;

  | Tree.mtDesignor:
(* line 83 "TD.pum" *)
      RETURN TRUE;

  | Tree.mtDesignation:
(* line 84 "TD.pum" *)
      RETURN TRUE;

  | Tree.mtExprList:
(* line 85 "TD.pum" *)
      RETURN TRUE;

  | Tree.mtNewExprList:
(* line 86 "TD.pum" *)
      RETURN TRUE;

  | Tree.mtSysAsmExprList:
(* line 87 "TD.pum" *)
      RETURN TRUE;

  ELSE END;

  RETURN FALSE;
 END IsEmpty;

PROCEDURE IsPredeclArgumenting (yyP8: Tree.tTree): BOOLEAN;
 BEGIN
  IF yyP8 = Tree.NoTree THEN RETURN FALSE; END;
  IF Tree.IsType (yyP8, Tree.PredeclArgumenting) THEN
(* line 91 "TD.pum" *)
      RETURN TRUE;

  END;
  IF (yyP8^.Kind = Tree.Importing) THEN
  IF Tree.IsType (yyP8^.Importing.Nextion, Tree.PredeclArgumenting) THEN
(* line 92 "TD.pum" *)
      RETURN TRUE;

  END;
  END;
  RETURN FALSE;
 END IsPredeclArgumenting;

PROCEDURE Dump* (t: Tree.tTree);
(* line 96 "TD.pum" *)
VAR n:LONGINT; 
 BEGIN
  IF t = Tree.NoTree THEN RETURN; END;

  CASE t^.Kind OF
  | Tree.Module:
(* line 99 "TD.pum" *)
(* line 99 "TD.pum" *)
      
    E:=ED.Create();

    IF t^.Module.IsForeign THEN ED.Text(E,"FOREIGN "); END;
    
    ED.Text(E,'MODULE ');
    ED.Ident(E,t^.Module.Name);
    ED.TextLn(E,';');

    IF ~IsEmpty(t^.Module.Imports)
       THEN ED.TextLn(E,'IMPORT');
            ED.Indent(E,3);
            n:=MaxImportRefLen(t^.Module.Imports);
            ED.SetTab(E,1,SHORT(2+n));
            ED.SetTab(E,2,SHORT(5+n+MaxImportSrvLen(t^.Module.Imports)));
            Dump(t^.Module.Imports);
            ED.Undent(E);
    END;

    Dump(t^.Module.DeclSection);

    IF ProcsDeclared(t^.Module.DeclSection) THEN ED.CR(E); END;
    IF ~IsEmpty(t^.Module.Stmts)
       THEN ED.Text(E,'BEGIN (* ');
            ED.Ident(E,t^.Module.Name);
            ED.TextLn(E,' *)');

            ED.Indent(E,3);
            Dump(t^.Module.Stmts);
            ED.Undent(E);
    END;

    ED.Text(E,'END ');
    ED.Ident(E,t^.Module.Name2);
    ED.TextLn(E,'.');

    ED.Dump(E);
    ED.Kill(E);
 ;
      RETURN;

  | Tree.Import:
(* line 139 "TD.pum" *)
(* line 139 "TD.pum" *)
      
    ED.Ident(E,t^.Import.RefId);
    IF t^.Import.ServerId#t^.Import.RefId
       THEN ED.Tab(E,1);
            ED.Text(E,':= ');
            ED.Ident(E,t^.Import.ServerId);
    END;

    ED.Tab(E,2);
    IF ~IsEmpty(t^.Import.Next)
       THEN ED.TextLn(E,',');
            Dump(t^.Import.Next);
       ELSE ED.TextLn(E,';');
    END;
 ;
      RETURN;

  | Tree.DeclSection:
(* line 155 "TD.pum" *)
(* line 155 "TD.pum" *)
      
    ED.SetTab(E,1,SHORT(5+MaxDeclIdentLen(t^.DeclSection.DeclUnits)));
    Dump(t^.DeclSection.DeclUnits);

    ED.Indent(E,1);
    Dump(t^.DeclSection.Procs);
    ED.Undent(E);
 ;
      RETURN;

  | Tree.DeclUnit:
  IF (t^.DeclUnit.Decls^.Kind = Tree.ConstDecl) THEN
(* line 164 "TD.pum" *)
(* line 164 "TD.pum" *)
      
    ED.TextLn(E,'CONST');

    ED.Indent(E,3);
    Dump(t^.DeclUnit.Decls);
    ED.Undent(E);

    Dump(t^.DeclUnit.Next);
 ;
      RETURN;

  END;
  IF (t^.DeclUnit.Decls^.Kind = Tree.TypeDecl) THEN
(* line 173 "TD.pum" *)
(* line 173 "TD.pum" *)
      
    ED.TextLn(E,'TYPE');

    ED.Indent(E,3);
    Dump(t^.DeclUnit.Decls);
    ED.Undent(E);

    Dump(t^.DeclUnit.Next);
 ;
      RETURN;

  END;
  IF (t^.DeclUnit.Decls^.Kind = Tree.VarDecl) THEN
(* line 182 "TD.pum" *)
(* line 182 "TD.pum" *)
      
    ED.TextLn(E,'VAR');

    ED.Indent(E,3);
    Dump(t^.DeclUnit.Decls);
    ED.Undent(E);

    Dump(t^.DeclUnit.Next);
 ;
      RETURN;

  END;
  IF (t^.DeclUnit.Decls^.Kind = Tree.mtDecl) THEN
(* line 191 "TD.pum" *)
(* line 191 "TD.pum" *)
      
    Dump(t^.DeclUnit.Next);
 ;
      RETURN;

  END;
  | Tree.ConstDecl:
(* line 195 "TD.pum" *)
(* line 195 "TD.pum" *)
      
    Dump(t^.ConstDecl.IdentDef);
    ED.Tab(E,1);
    ED.Text(E,'= ');

    ED.IndentCur(E);
    Dump(t^.ConstDecl.ConstExpr);
    ED.Eol(E);
    ED.TextLn(E,';');
    ED.Undent(E);

    Dump(t^.ConstDecl.Next);
 ;
      RETURN;

  | Tree.TypeDecl:
(* line 209 "TD.pum" *)
(* line 209 "TD.pum" *)
      
    Dump(t^.TypeDecl.IdentDef);
    ED.Tab(E,1);
    ED.Text(E,'= ');

    ED.IndentCur(E);
    Dump(t^.TypeDecl.Type);
    ED.Eol(E);
    ED.TextLn(E,';');
    ED.Undent(E);

    Dump(t^.TypeDecl.Next);
 ;
      RETURN;

  | Tree.VarDecl:
(* line 223 "TD.pum" *)
(* line 223 "TD.pum" *)
      
    Dump(t^.VarDecl.IdentLists);
    ED.Tab(E,1);
    ED.Text(E,': ');

    ED.IndentCur(E);
    Dump(t^.VarDecl.Type);
    ED.Eol(E);
    ED.TextLn(E,';');
    ED.Undent(E);

    Dump(t^.VarDecl.Next);
 ;
      RETURN;

  | Tree.ProcDecl:
(* line 237 "TD.pum" *)
(* line 244 "TD.pum" *)
      
    ED.CR(E);
    ED.Text(E,'PROCEDURE ');
    Dump(t^.ProcDecl.IdentDef);
    Dump(t^.ProcDecl.FormalPars);
    ED.Eol(E);
    ED.TextLn(E,';');

    IF ~IsEmpty(t^.ProcDecl.DeclSection) THEN Dump(t^.ProcDecl.DeclSection); END;

    IF ProcsDeclared(t^.ProcDecl.DeclSection) THEN ED.CR(E); END;

    IF ~IsEmpty(t^.ProcDecl.Stmts)
       THEN ED.Text(E,'BEGIN (* ');
            ED.Ident(E,t^.ProcDecl.IdentDef^.IdentDef.Ident);
            ED.TextLn(E,' *)');
            ED.Indent(E,3);
            Dump(t^.ProcDecl.Stmts);
            ED.Undent(E);
    END;

    ED.Text(E,'END ');
    ED.Ident(E,t^.ProcDecl.Ident);
    ED.TextLn(E,';');

    Dump(t^.ProcDecl.Next);
 ;
      RETURN;

  | Tree.ForwardDecl:
(* line 272 "TD.pum" *)
(* line 272 "TD.pum" *)
      
    ED.CR(E);
    ED.Text(E,'PROCEDURE ^ ');
    Dump(t^.ForwardDecl.IdentDef);
    Dump(t^.ForwardDecl.FormalPars);
    ED.Eol(E);
    ED.TextLn(E,';');

    Dump(t^.ForwardDecl.Next);
 ;
      RETURN;

  | Tree.BoundProcDecl:
(* line 283 "TD.pum" *)
(* line 292 "TD.pum" *)
      
    ED.CR(E);
    ED.Text(E,'PROCEDURE ');
    Dump(t^.BoundProcDecl.Receiver);
    Dump(t^.BoundProcDecl.IdentDef);
    Dump(t^.BoundProcDecl.FormalPars);
    ED.Eol(E);
    ED.TextLn(E,';');

    Dump(t^.BoundProcDecl.DeclSection);

    IF ProcsDeclared(t^.BoundProcDecl.DeclSection) THEN ED.CR(E); END;

    IF ~IsEmpty(t^.BoundProcDecl.Stmts)
       THEN ED.Text(E,'BEGIN (* ');
            ED.Ident(E,t^.BoundProcDecl.IdentDef^.IdentDef.Ident);
            ED.TextLn(E,' *)');
            ED.Indent(E,3);
            Dump(t^.BoundProcDecl.Stmts);
            ED.Undent(E);
    END;

    ED.Text(E,'END ');
    ED.Ident(E,t^.BoundProcDecl.Ident);
    ED.TextLn(E,';');

    Dump(t^.BoundProcDecl.Next);
 ;
      RETURN;

  | Tree.BoundForwardDecl:
(* line 321 "TD.pum" *)
(* line 325 "TD.pum" *)
      
    ED.CR(E);
    ED.Text(E,'PROCEDURE ^ ');
    Dump(t^.BoundForwardDecl.Receiver);
    Dump(t^.BoundForwardDecl.IdentDef);
    Dump(t^.BoundForwardDecl.FormalPars);
    ED.Eol(E);
    ED.TextLn(E,';');

    Dump(t^.BoundForwardDecl.Next);
 ;
      RETURN;

  | Tree.FormalPars:
  IF (t^.FormalPars.FPSections^.Kind = Tree.mtFPSection) THEN
  IF (t^.FormalPars.Type^.Kind = Tree.mtType) THEN
(* line 337 "TD.pum" *)
(* line 337 "TD.pum" *)
      
 ;
      RETURN;

  END;
  END;
(* line 339 "TD.pum" *)
(* line 339 "TD.pum" *)
      
    ED.Text(E,'(');
    ED.IndentCur(E);

    n:=MaxParamModeLen(t^.FormalPars.FPSections);
    ED.SetTab(E,1,SHORT(1+n));
    ED.SetTab(E,2,SHORT(2+n+MaxParamIdLen(t^.FormalPars.FPSections)));
    Dump(t^.FormalPars.FPSections);

    IF IsEmpty(t^.FormalPars.Type)
       THEN ED.Text(E,')');
       ELSE ED.Text(E,') : ');
            Dump(t^.FormalPars.Type);
    END;
    ED.Undent(E);
 ;
      RETURN;

  | Tree.FPSection:
(* line 356 "TD.pum" *)
(* line 356 "TD.pum" *)
      
    IF t^.FPSection.ParMode=OB.REFPAR THEN ED.Text(E,'VAR'); END;
    Dump(t^.FPSection.ParIds);
    ED.Tab(E,2);
    ED.Text(E,': ');
    Dump(t^.FPSection.Type);

    IF ~IsEmpty(t^.FPSection.Next)
       THEN ED.TextLn(E,';');
            Dump(t^.FPSection.Next);
    END;
 ;
      RETURN;

  | Tree.ParId:
(* line 369 "TD.pum" *)
(* line 369 "TD.pum" *)
      
    ED.Tab(E,1);
    ED.Ident(E,t^.ParId.Ident);

    IF ~IsEmpty(t^.ParId.Next)
       THEN ED.Tab(E,2);
            ED.TextLn(E,',');
            Dump(t^.ParId.Next);
    END;
 ;
      RETURN;

  | Tree.Receiver:
(* line 380 "TD.pum" *)
(* line 380 "TD.pum" *)
      
    ED.Text(E,'(');
    IF t^.Receiver.ParMode=OB.REFPAR THEN ED.Text(E,'VAR '); END;
    ED.Ident(E,t^.Receiver.Name);
    ED.Text(E,' : ');
    ED.Ident(E,t^.Receiver.TypeIdent);
    ED.Text(E,') ');
 ;
      RETURN;

  | Tree.NamedType:
(* line 389 "TD.pum" *)
(* line 389 "TD.pum" *)
      
    Dump(t^.NamedType.Qualidents);
 ;
      RETURN;

  | Tree.ArrayType:
(* line 393 "TD.pum" *)
(* line 393 "TD.pum" *)
      
    ED.Text(E,'ARRAY ');
    Dump(t^.ArrayType.ArrayExprLists);
    ED.Text(E,' OF ');
    Dump(t^.ArrayType.Type);
 ;
      RETURN;

  | Tree.OpenArrayType:
(* line 400 "TD.pum" *)
(* line 400 "TD.pum" *)
      
    ED.Text(E,'ARRAY OF ');
    Dump(t^.OpenArrayType.Type);
 ;
      RETURN;

  | Tree.RecordType:
(* line 405 "TD.pum" *)
(* line 405 "TD.pum" *)
      
    ED.IndentCur(E);
    ED.TextLn(E,'RECORD');

    ED.Indent(E,1);
    ED.SetTab(E,1,SHORT(2+MaxDeclIdentLen(t^.RecordType.FieldLists)));
    Dump(t^.RecordType.FieldLists);
    ED.Undent(E);

    ED.Text(E,'END');
    ED.Undent(E);
 ;
      RETURN;

  | Tree.ExtendedType:
(* line 418 "TD.pum" *)
(* line 418 "TD.pum" *)
      
    ED.IndentCur(E);
    ED.Text(E,'RECORD(');
    Dump(t^.ExtendedType.Qualidents);
    ED.TextLn(E,')');

    ED.Indent(E,1);
    ED.SetTab(E,1,SHORT(2+MaxDeclIdentLen(t^.ExtendedType.FieldLists)));
    Dump(t^.ExtendedType.FieldLists);
    ED.Undent(E);

    ED.Text(E,'END');
    ED.Undent(E);
 ;
      RETURN;

  | Tree.PointerToIdType:
(* line 433 "TD.pum" *)
(* line 433 "TD.pum" *)
      
    ED.Text(E,'POINTER TO ');
    ED.Ident(E,t^.PointerToIdType.Ident);
 ;
      RETURN;

  | Tree.PointerToQualIdType:
(* line 438 "TD.pum" *)
(* line 438 "TD.pum" *)
      
    ED.Text(E,'POINTER TO ');
    Dump(t^.PointerToQualIdType.Qualidents);
 ;
      RETURN;

  | Tree.PointerToStructType:
(* line 443 "TD.pum" *)
(* line 443 "TD.pum" *)
      
    ED.Text(E,'POINTER TO ');
    Dump(t^.PointerToStructType.Type);
 ;
      RETURN;

  | Tree.ProcedureType:
(* line 448 "TD.pum" *)
(* line 448 "TD.pum" *)
      
    ED.Text(E,'PROCEDURE');
    Dump(t^.ProcedureType.FormalPars);
 ;
      RETURN;

  | Tree.ArrayExprList:
(* line 453 "TD.pum" *)
(* line 453 "TD.pum" *)
      
    Dump(t^.ArrayExprList.ConstExpr);
    IF ~IsEmpty(t^.ArrayExprList.Next)
       THEN ED.Text(E,',');
            Dump(t^.ArrayExprList.Next);
    END;
 ;
      RETURN;

  | Tree.FieldList:
(* line 461 "TD.pum" *)
(* line 461 "TD.pum" *)
      
    Dump(t^.FieldList.IdentLists);
    ED.Tab(E,1);
    ED.Text(E,': ');

    ED.IndentCur(E);
    Dump(t^.FieldList.Type);
    ED.Eol(E);
    ED.TextLn(E,';');
    ED.Undent(E);

    Dump(t^.FieldList.Next);
 ;
      RETURN;

  | Tree.IdentList:
(* line 475 "TD.pum" *)
(* line 475 "TD.pum" *)
      
    Dump(t^.IdentList.IdentDef);

    IF ~IsEmpty(t^.IdentList.Next)
       THEN ED.Tab(E,1);
            ED.TextLn(E,',');

            Dump(t^.IdentList.Next);
    END;
 ;
      RETURN;

  | Tree.mtQualident:
(* line 486 "TD.pum" *)
(* line 486 "TD.pum" *)
      
    ED.Text(E,'mtQualident?');
 ;
      RETURN;

  | Tree.ErrorQualident:
(* line 489 "TD.pum" *)
(* line 489 "TD.pum" *)
      
    ED.Text(E,'ErrorQualident?');
 ;
      RETURN;

  | Tree.UnqualifiedIdent:
(* line 492 "TD.pum" *)
(* line 492 "TD.pum" *)
      
    ED.Ident(E,t^.UnqualifiedIdent.Ident);
 ;
      RETURN;

  | Tree.QualifiedIdent:
(* line 495 "TD.pum" *)
(* line 495 "TD.pum" *)
      
    ED.Ident(E,t^.QualifiedIdent.ServerId);
    ED.Text(E,'$');
    ED.Ident(E,t^.QualifiedIdent.Ident);
 ;
      RETURN;

  | Tree.IdentDef:
  IF (yyIsEqual ( t^.IdentDef.ExportMode ,   OB.PRIVATE ) ) THEN
(* line 501 "TD.pum" *)
(* line 501 "TD.pum" *)
      
    ED.Ident(E,t^.IdentDef.Ident);
 ;
      RETURN;

  END;
  IF (yyIsEqual ( t^.IdentDef.ExportMode ,   OB.PUBLIC ) ) THEN
(* line 504 "TD.pum" *)
(* line 504 "TD.pum" *)
      
    ED.Ident(E,t^.IdentDef.Ident);
    ED.Text(E,'*');
 ;
      RETURN;

  END;
  IF (yyIsEqual ( t^.IdentDef.ExportMode ,   OB.READONLY ) ) THEN
(* line 508 "TD.pum" *)
(* line 508 "TD.pum" *)
      
    ED.Ident(E,t^.IdentDef.Ident);
    ED.Text(E,'-');
 ;
      RETURN;

  END;
  | Tree.AssignStmt:
(* line 513 "TD.pum" *)
(* line 513 "TD.pum" *)
      
    Dump(t^.AssignStmt.Designator);
    ED.Text(E,' := ');
    DumpExpr(NotNilCoerce(SYSTEM.VAL(OB.tOB,t^.AssignStmt.Coerce)),t^.AssignStmt.Exprs,NOBRACKETS);
    ED.TextLn(E,';');
    Dump(t^.AssignStmt.Next);
 ;
      RETURN;

  | Tree.CallStmt:
(* line 521 "TD.pum" *)
(* line 521 "TD.pum" *)
      
    Dump(t^.CallStmt.Designator);
    ED.TextLn(E,';');

    Dump(t^.CallStmt.Next);
 ;
      RETURN;

  | Tree.IfStmt:
(* line 528 "TD.pum" *)
(* line 528 "TD.pum" *)
      
    ED.Text(E,'IF ');
    Dump(t^.IfStmt.Exprs);

    ED.CR(E);
    ED.Text(E,'THEN ');
    IF IsEmpty(t^.IfStmt.Then)
       THEN ED.CR(E);
       ELSE ED.IndentCur(E);
            Dump(t^.IfStmt.Then);
            ED.Undent(E);
    END;

    IF ~IsEmpty(t^.IfStmt.Else)
       THEN ED.Text(E,'ELSE ');
            ED.IndentCur(E);
            Dump(t^.IfStmt.Else);
            ED.Undent(E);
    END;

    ED.TextLn(E,'END; (* IF *)');

    Dump(t^.IfStmt.Next);
 ;
      RETURN;

  | Tree.CaseStmt:
(* line 553 "TD.pum" *)
(* line 553 "TD.pum" *)
      
    ED.Text(E,'CASE ');
    Dump(t^.CaseStmt.Exprs);
    ED.TextLn(E,' OF');
    Dump(t^.CaseStmt.Cases);

    ED.Text(E,'ELSE ');
    IF IsEmpty(t^.CaseStmt.Else)
       THEN ED.CR(E);
       ELSE ED.IndentCur(E);
            Dump(t^.CaseStmt.Else);
            ED.Undent(E);
    END;

    ED.TextLn(E,'END; (* CASE *)');

    Dump(t^.CaseStmt.Next);
 ;
      RETURN;

  | Tree.Case:
(* line 572 "TD.pum" *)
(* line 572 "TD.pum" *)
      
    ED.Text(E,'|');
    Dump(t^.Case.CaseLabels);
    ED.TextLn(E,':');

    ED.Indent(E,5);
    Dump(t^.Case.Stmts);
    ED.Undent(E);

    Dump(t^.Case.Next);
 ;
      RETURN;

  | Tree.CaseLabel:
(* line 584 "TD.pum" *)
(* line 584 "TD.pum" *)
      
    Dump(t^.CaseLabel.ConstExpr1);

    IF ~IsEmpty(t^.CaseLabel.ConstExpr2^.ConstExpr.Expr)
       THEN ED.Text(E,'..');
            Dump(t^.CaseLabel.ConstExpr2);
    END;

    IF ~IsEmpty(t^.CaseLabel.Next)
       THEN ED.Text(E,',');
            Dump(t^.CaseLabel.Next);
    END;
 ;
      RETURN;

  | Tree.WhileStmt:
(* line 598 "TD.pum" *)
(* line 598 "TD.pum" *)
      
    ED.Text(E,'WHILE ');
    Dump(t^.WhileStmt.Exprs);
    ED.TextLn(E,' DO');
    ED.Indent(E,3);
    Dump(t^.WhileStmt.Stmts);
    ED.Undent(E);
    ED.TextLn(E,'END; (* WHILE *)');

    Dump(t^.WhileStmt.Next);
 ;
      RETURN;

  | Tree.RepeatStmt:
(* line 610 "TD.pum" *)
(* line 610 "TD.pum" *)
      
    ED.TextLn(E,'REPEAT');
    ED.Indent(E,3);
    Dump(t^.RepeatStmt.Stmts);
    ED.Undent(E);
    ED.Text(E,'UNTIL ');
    Dump(t^.RepeatStmt.Exprs);
    ED.TextLn(E,';');

    Dump(t^.RepeatStmt.Next);
 ;
      RETURN;

  | Tree.ForStmt:
(* line 622 "TD.pum" *)
(* line 623 "TD.pum" *)
      

    ED.Text(E,'FOR ');
    ED.Ident(E,t^.ForStmt.Ident);
    ED.Text(E,':=');
    DumpExpr(NotNilCoerce(SYSTEM.VAL(OB.tOB,t^.ForStmt.FromCoerce)),t^.ForStmt.From,NOBRACKETS);
    ED.Text(E,' TO ');
    DumpExpr(NotNilCoerce(SYSTEM.VAL(OB.tOB,t^.ForStmt.ToCoerce)),t^.ForStmt.To,NOBRACKETS);
    ED.Text(E,' BY ');
    DumpExpr(OB.cmtCoercion,t^.ForStmt.By,NOBRACKETS);
    ED.TextLn(E,' DO');
    ED.Indent(E,3);
    Dump(t^.ForStmt.Stmts);
    ED.Undent(E);
    ED.TextLn(E,'END; (* FOR *)');

    Dump(t^.ForStmt.Next);
 ;
      RETURN;

  | Tree.LoopStmt:
(* line 642 "TD.pum" *)
(* line 642 "TD.pum" *)
      
    ED.TextLn(E,'LOOP');
    ED.Indent(E,3);
    Dump(t^.LoopStmt.Stmts);
    ED.Undent(E);
    ED.TextLn(E,'END; (* LOOP *)');

    Dump(t^.LoopStmt.Next);
 ;
      RETURN;

  | Tree.WithStmt:
(* line 652 "TD.pum" *)
(* line 652 "TD.pum" *)
      
    ED.Text(E,'WITH ');
    Dump(t^.WithStmt.GuardedStmts);

    ED.Text(E,'ELSE ');
    IF IsEmpty(t^.WithStmt.Else)
       THEN ED.CR(E);
       ELSE ED.IndentCur(E);
            Dump(t^.WithStmt.Else);
            ED.Undent(E);
    END;
    ED.TextLn(E,'END; (* WITH *)');

    Dump(t^.WithStmt.Next);
 ;
      RETURN;

  | Tree.GuardedStmt:
(* line 668 "TD.pum" *)
(* line 668 "TD.pum" *)
      
    Dump(t^.GuardedStmt.Guard);
    ED.TextLn(E,' DO');

    ED.Indent(E,5);
    Dump(t^.GuardedStmt.Stmts);
    ED.Undent(E);

    IF ~IsEmpty(t^.GuardedStmt.Next)
       THEN ED.Text(E,'|');
            Dump(t^.GuardedStmt.Next);
    END;
 ;
      RETURN;

  | Tree.Guard:
(* line 682 "TD.pum" *)
(* line 682 "TD.pum" *)
      
    Dump(t^.Guard.Variable);
    ED.Text(E,':');
    Dump(t^.Guard.TypeId);
 ;
      RETURN;

  | Tree.ExitStmt:
(* line 688 "TD.pum" *)
(* line 688 "TD.pum" *)
      
    ED.TextLn(E,'EXIT;');

    Dump(t^.ExitStmt.Next);
 ;
      RETURN;

  | Tree.ReturnStmt:
(* line 694 "TD.pum" *)
(* line 694 "TD.pum" *)
      
    ED.Text(E,'RETURN');
    IF ~IsEmpty(t^.ReturnStmt.Exprs) THEN 
       ED.Text(E,' ');
       DumpExpr(NotNilCoerce(SYSTEM.VAL(OB.tOB,t^.ReturnStmt.Coerce)),t^.ReturnStmt.Exprs,NOBRACKETS);
    END;
    ED.TextLn(E,';');
    Dump(t^.ReturnStmt.Next);
 ;
      RETURN;

  | Tree.ConstExpr:
(* line 704 "TD.pum" *)
(* line 704 "TD.pum" *)
      
    Dump(t^.ConstExpr.Expr);
 ;
      RETURN;

  | Tree.Exprs
  , Tree.mtExpr
  , Tree.MonExpr
  , Tree.NegateExpr
  , Tree.IdentityExpr
  , Tree.NotExpr
  , Tree.DyExpr
  , Tree.IsExpr
  , Tree.SetExpr
  , Tree.DesignExpr
  , Tree.SetConst
  , Tree.IntConst
  , Tree.RealConst
  , Tree.LongrealConst
  , Tree.CharConst
  , Tree.StringConst
  , Tree.NilConst:
(* line 708 "TD.pum" *)
   LOOP
(* line 708 "TD.pum" *)
      IF ~((V . IsValidConstValue (SYSTEM.VAL(OB.tOB,t^.Exprs.ValueReprOut)))) THEN EXIT; END;
(* line 708 "TD.pum" *)
      
    DumpValue(SYSTEM.VAL(OB.tOB,t^.Exprs.ValueReprOut)); 
 ;
      RETURN;
   END;

  ELSE END;


  CASE t^.Kind OF
  | Tree.NegateExpr:
(* line 712 "TD.pum" *)
(* line 712 "TD.pum" *)
      
    ED.Text(E,'-');
    DumpExpr(OB.cmtCoercion,t^.NegateExpr.Exprs,BRACKETS);
 ;
      RETURN;

  | Tree.IdentityExpr:
(* line 717 "TD.pum" *)
(* line 717 "TD.pum" *)
      
    ED.Text(E,'+');
    DumpExpr(OB.cmtCoercion,t^.IdentityExpr.Exprs,BRACKETS);
 ;
      RETURN;

  | Tree.NotExpr:
(* line 722 "TD.pum" *)
(* line 722 "TD.pum" *)
      
    ED.Text(E,'~');
    DumpExpr(OB.cmtCoercion,t^.NotExpr.Exprs,BRACKETS);
 ;
      RETURN;

  | Tree.DyExpr:
(* line 727 "TD.pum" *)
(* line 727 "TD.pum" *)
      
    DumpExpr(NotNilCoerce(SYSTEM.VAL(OB.tOB,t^.DyExpr.DyOperator^.DyOperator.Coerce1)),t^.DyExpr.Expr1,BRACKETS);
    Dump(t^.DyExpr.DyOperator);
    DumpExpr(NotNilCoerce(SYSTEM.VAL(OB.tOB,t^.DyExpr.DyOperator^.DyOperator.Coerce2)),t^.DyExpr.Expr2,BRACKETS);
 ;
      RETURN;

  | Tree.IsExpr:
(* line 733 "TD.pum" *)
(* line 733 "TD.pum" *)
      
    Dump(t^.IsExpr.Designator);
    ED.Text(E,' IS ');
    Dump(t^.IsExpr.TypeId);
 ;
      RETURN;

  | Tree.SetExpr:
  IF t^.SetExpr.ConstValueRepr = NIL THEN
(* line 739 "TD.pum" *)
(* line 739 "TD.pum" *)
      
    ED.Text(E,'{');
    DumpElements(t^.SetExpr.Elements,TRUE); 
    ED.Text(E,'}');
 ;
      RETURN;

  END;
(* line 745 "TD.pum" *)
(* line 745 "TD.pum" *)
      
    DumpSetExpr(SYSTEM.VAL(OB.tOB,t^.SetExpr.ConstValueRepr),t); 
 ;
      RETURN;

  | Tree.DesignExpr:
(* line 749 "TD.pum" *)
(* line 749 "TD.pum" *)
      
    Dump(t^.DesignExpr.Designator);
 ;
      RETURN;

  | Tree.IntConst:
(* line 753 "TD.pum" *)
(* line 753 "TD.pum" *)
      
    ED.Longint(E,t^.IntConst.Int);
 ;
      RETURN;

  | Tree.SetConst:
(* line 757 "TD.pum" *)
(* line 757 "TD.pum" *)
      
    ED.Set(E,t^.SetConst.Set);
 ;
      RETURN;

  | Tree.RealConst:
(* line 761 "TD.pum" *)
(* line 761 "TD.pum" *)
      
    ED.Real(E,t^.RealConst.Real);
 ;
      RETURN;

  | Tree.LongrealConst:
(* line 765 "TD.pum" *)
(* line 765 "TD.pum" *)
      
    ED.Longreal(E,t^.LongrealConst.Longreal);
 ;
      RETURN;

  | Tree.CharConst:
(* line 769 "TD.pum" *)
(* line 769 "TD.pum" *)
      
    ED.Char(E,t^.CharConst.Char);
 ;
      RETURN;

  | Tree.StringConst:
(* line 773 "TD.pum" *)
(* line 773 "TD.pum" *)
      
    ED.String(E,t^.StringConst.String);
 ;
      RETURN;

  | Tree.NilConst:
(* line 777 "TD.pum" *)
(* line 777 "TD.pum" *)
      
    ED.Text(E,'NIL');
 ;
      RETURN;

  | Tree.EqualOper:
(* line 781 "TD.pum" *)
(* line 781 "TD.pum" *)
       ED.Text(E,'='    );;
      RETURN;

  | Tree.UnequalOper:
(* line 782 "TD.pum" *)
(* line 782 "TD.pum" *)
       ED.Text(E,'#'    );;
      RETURN;

  | Tree.LessOper:
(* line 783 "TD.pum" *)
(* line 783 "TD.pum" *)
       ED.Text(E,'<'    );;
      RETURN;

  | Tree.LessEqualOper:
(* line 784 "TD.pum" *)
(* line 784 "TD.pum" *)
       ED.Text(E,'<='   );;
      RETURN;

  | Tree.GreaterOper:
(* line 785 "TD.pum" *)
(* line 785 "TD.pum" *)
       ED.Text(E,'>'    );;
      RETURN;

  | Tree.GreaterEqualOper:
(* line 786 "TD.pum" *)
(* line 786 "TD.pum" *)
       ED.Text(E,'>='   );;
      RETURN;

  | Tree.InOper:
(* line 787 "TD.pum" *)
(* line 787 "TD.pum" *)
       ED.Text(E,' IN ' );;
      RETURN;

  | Tree.PlusOper:
(* line 788 "TD.pum" *)
(* line 788 "TD.pum" *)
       ED.Text(E,'+'    );;
      RETURN;

  | Tree.MinusOper:
(* line 789 "TD.pum" *)
(* line 789 "TD.pum" *)
       ED.Text(E,'-'    );;
      RETURN;

  | Tree.MultOper:
(* line 790 "TD.pum" *)
(* line 790 "TD.pum" *)
       ED.Text(E,'*'    );;
      RETURN;

  | Tree.RDivOper:
(* line 791 "TD.pum" *)
(* line 791 "TD.pum" *)
       ED.Text(E,'/'    );;
      RETURN;

  | Tree.DivOper:
(* line 792 "TD.pum" *)
(* line 792 "TD.pum" *)
       ED.Text(E,' DIV ');;
      RETURN;

  | Tree.ModOper:
(* line 793 "TD.pum" *)
(* line 793 "TD.pum" *)
       ED.Text(E,' MOD ');;
      RETURN;

  | Tree.OrOper:
(* line 794 "TD.pum" *)
(* line 794 "TD.pum" *)
       ED.Text(E,' OR ' );;
      RETURN;

  | Tree.AndOper:
(* line 795 "TD.pum" *)
(* line 795 "TD.pum" *)
       ED.Text(E,' & '  );;
      RETURN;

  | Tree.Designator:
(* line 798 "TD.pum" *)
(* line 798 "TD.pum" *)
      
    IF ~IsPredeclArgumenting(t^.Designator.Designations) THEN ED.Ident(E,t^.Designator.Ident); END;
    Dump(t^.Designator.Designors);
    Dump(t^.Designator.Designations);
 ;
      RETURN;

  | Tree.Selector:
(* line 804 "TD.pum" *)
(* line 804 "TD.pum" *)
      
    ED.Text(E,'\.');
    ED.Ident(E,t^.Selector.Ident);

    Dump(t^.Selector.Nextor);
 ;
      RETURN;

  | Tree.Indexor:
(* line 811 "TD.pum" *)
(* line 811 "TD.pum" *)
      
    ED.Text(E,'\[');
    Dump(t^.Indexor.ExprList);
    ED.Text(E,'\]');

    Dump(t^.Indexor.Nextor);
 ;
      RETURN;

  | Tree.Dereferencor:
(* line 819 "TD.pum" *)
(* line 819 "TD.pum" *)
      
    ED.Text(E,'\^');

    Dump(t^.Dereferencor.Nextor);
 ;
      RETURN;

  | Tree.Argumentor:
(* line 825 "TD.pum" *)
(* line 825 "TD.pum" *)
      
    ED.Text(E,'\(');
    Dump(t^.Argumentor.ExprList);
    ED.Text(E,'\)');

    Dump(t^.Argumentor.Nextor);
 ;
      RETURN;

  | Tree.Importing:
(* line 833 "TD.pum" *)
(* line 833 "TD.pum" *)
      
    IF ~IsPredeclArgumenting(t^.Importing.Nextion)
       THEN ED.Text(E,'$');
            ED.Ident(E,t^.Importing.Ident);
    END;

    Dump(t^.Importing.Nextion);
 ;
      RETURN;

  | Tree.Selecting:
(* line 842 "TD.pum" *)
(* line 842 "TD.pum" *)
      
    ED.Text(E,'.');
    ED.Ident(E,t^.Selecting.Ident);

    Dump(t^.Selecting.Nextion);
 ;
      RETURN;

  | Tree.Indexing:
(* line 849 "TD.pum" *)
(* line 849 "TD.pum" *)
      
    ED.Text(E,'[');
    Dump(t^.Indexing.Expr);
    ED.Text(E,']');

    Dump(t^.Indexing.Nextion);
 ;
      RETURN;

  | Tree.Dereferencing:
(* line 857 "TD.pum" *)
(* line 857 "TD.pum" *)
      
    ED.Text(E,'^');

    Dump(t^.Dereferencing.Nextion);
 ;
      RETURN;

  | Tree.Supering:
(* line 863 "TD.pum" *)
(* line 863 "TD.pum" *)
      
    ED.Text(E,'!');

    Dump(t^.Supering.Nextion);
 ;
      RETURN;

  | Tree.Argumenting:
(* line 869 "TD.pum" *)
(* line 869 "TD.pum" *)
      
    ED.Text(E,'(');
    Dump(t^.Argumenting.ExprList);
    ED.Text(E,')');

    Dump(t^.Argumenting.Nextion);
 ;
      RETURN;

  | Tree.Guarding:
(* line 877 "TD.pum" *)
(* line 877 "TD.pum" *)
      
    ED.Text(E,'`');
    Dump(t^.Guarding.Qualidents);

    Dump(t^.Guarding.Nextion);
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
(* line 884 "TD.pum" *)
(* line 884 "TD.pum" *)
      
    DumpPredecl(t);
    ED.Text(E,'(');
    DumpExpr(OB.cmtCoercion,t^.PredeclArgumenting1.Expr,NOBRACKETS);
    IF ~IsEmpty(t^.PredeclArgumenting1.ExprLists)
       THEN ED.Text(E,',[');
            Dump(t^.PredeclArgumenting1.ExprLists);
            ED.Text(E,']');
    END;
    ED.Text(E,')');
    Dump(t^.PredeclArgumenting1.Nextion);
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
(* line 896 "TD.pum" *)
(* line 896 "TD.pum" *)
      
    DumpPredecl(t);
    ED.Text(E,'(');
    DumpExpr(NotNilCoerce(SYSTEM.VAL(OB.tOB,t^.PredeclArgumenting2.Coerce1)),t^.PredeclArgumenting2.Expr1,NOBRACKETS);
    ED.Text(E,',');
    DumpExpr(NotNilCoerce(SYSTEM.VAL(OB.tOB,t^.PredeclArgumenting2.Coerce2)),t^.PredeclArgumenting2.Expr2,NOBRACKETS);
    IF ~IsEmpty(t^.PredeclArgumenting2.ExprLists)
       THEN ED.Text(E,',[');
            Dump(t^.PredeclArgumenting2.ExprLists);
            ED.Text(E,']');
    END;
    ED.Text(E,')');
    Dump(t^.PredeclArgumenting2.Nextion);
 ;
      RETURN;

  | Tree.PredeclArgumenting2Opt
  , Tree.LenArgumenting
  , Tree.AssertArgumenting
  , Tree.DecIncArgumenting
  , Tree.DecArgumenting
  , Tree.IncArgumenting:
(* line 910 "TD.pum" *)
(* line 910 "TD.pum" *)
      
    DumpPredecl(t);
    ED.Text(E,'(');
    DumpExpr(NotNilCoerce(SYSTEM.VAL(OB.tOB,t^.PredeclArgumenting2Opt.Coerce1)),t^.PredeclArgumenting2Opt.Expr1,NOBRACKETS);
    IF ~IsEmpty(t^.PredeclArgumenting2Opt.Expr2)
       THEN ED.Text(E,',');
            DumpExpr(NotNilCoerce(SYSTEM.VAL(OB.tOB,t^.PredeclArgumenting2Opt.Coerce2)),t^.PredeclArgumenting2Opt.Expr2,NOBRACKETS);
    END;
    IF ~IsEmpty(t^.PredeclArgumenting2Opt.ExprLists)
       THEN ED.Text(E,',[');
            Dump(t^.PredeclArgumenting2Opt.ExprLists);
            ED.Text(E,']');
    END;
    ED.Text(E,')');
    Dump(t^.PredeclArgumenting2Opt.Nextion);
 ;
      RETURN;

  | Tree.PredeclArgumenting3
  , Tree.SysMoveArgumenting:
(* line 926 "TD.pum" *)
(* line 926 "TD.pum" *)
      
    DumpPredecl(t);
    ED.Text(E,'(');
    DumpExpr(OB.cmtCoercion,t^.PredeclArgumenting3.Expr1,NOBRACKETS);
    ED.Text(E,',');
    DumpExpr(OB.cmtCoercion,t^.PredeclArgumenting3.Expr2,NOBRACKETS);
    ED.Text(E,',');
    DumpExpr(NotNilCoerce(SYSTEM.VAL(OB.tOB,t^.PredeclArgumenting3.Coerce3)),t^.PredeclArgumenting3.Expr3,NOBRACKETS);
    IF ~IsEmpty(t^.PredeclArgumenting3.ExprLists)
       THEN ED.Text(E,',[');
            Dump(t^.PredeclArgumenting3.ExprLists);
            ED.Text(E,']');
    END;
    ED.Text(E,')');
    Dump(t^.PredeclArgumenting3.Nextion);
 ;
      RETURN;

  | Tree.SysValArgumenting:
(* line 942 "TD.pum" *)
(* line 942 "TD.pum" *)
      
    DumpPredecl(t);
    ED.Text(E,'(');
    Dump(t^.SysValArgumenting.Qualidents);
    ED.Text(E,',');
    DumpExpr(OB.cmtCoercion,t^.SysValArgumenting.Expr,NOBRACKETS);
    IF ~IsEmpty(t^.SysValArgumenting.ExprLists)
       THEN ED.Text(E,',[');
            Dump(t^.SysValArgumenting.ExprLists);
            ED.Text(E,']');
    END;
    ED.Text(E,')');
    Dump(t^.SysValArgumenting.Nextion);
 ;
      RETURN;

  | Tree.TypeArgumenting
  , Tree.MaxMinArgumenting
  , Tree.MaxArgumenting
  , Tree.MinArgumenting
  , Tree.SizeArgumenting:
(* line 956 "TD.pum" *)
(* line 956 "TD.pum" *)
      
    DumpPredecl(t);
    ED.Text(E,'(');
    Dump(t^.TypeArgumenting.Qualidents);
    IF ~IsEmpty(t^.TypeArgumenting.ExprLists)
       THEN ED.Text(E,',[');
            Dump(t^.TypeArgumenting.ExprLists);
            ED.Text(E,']');
    END;
    ED.Text(E,')');
    Dump(t^.TypeArgumenting.Nextion);
 ;
      RETURN;

  | Tree.NewArgumenting:
(* line 968 "TD.pum" *)
(* line 968 "TD.pum" *)
      
    DumpPredecl(t);
    ED.Text(E,'(');
    Dump(t^.NewArgumenting.Expr);
    IF ~IsEmpty(t^.NewArgumenting.NewExprLists)
       THEN ED.Text(E,',');
            Dump(t^.NewArgumenting.NewExprLists);
    END;
    ED.Text(E,')');
    Dump(t^.NewArgumenting.Nextion);
 ;
      RETURN;

  | Tree.SysAsmArgumenting:
(* line 979 "TD.pum" *)
(* line 979 "TD.pum" *)
      
    DumpPredecl(t);
    ED.Text(E,'(');
    Dump(t^.SysAsmArgumenting.SysAsmExprLists);
    ED.Text(E,')');
    Dump(t^.SysAsmArgumenting.Nextion);
 ;
      RETURN;

  | Tree.ExprList:
(* line 987 "TD.pum" *)
(* line 987 "TD.pum" *)
      
    DumpExpr(NotNilCoerce(SYSTEM.VAL(OB.tOB,t^.ExprList.Coerce)),t^.ExprList.Expr,NOBRACKETS);
    IF ~IsEmpty(t^.ExprList.Next)
       THEN ED.Text(E,',');
            Dump(t^.ExprList.Next);
    END;
 ;
      RETURN;

  | Tree.NewExprList:
(* line 995 "TD.pum" *)
(* line 995 "TD.pum" *)
      
    DumpExpr(NotNilCoerce(SYSTEM.VAL(OB.tOB,t^.NewExprList.Coerce)),t^.NewExprList.Expr,NOBRACKETS);
    IF ~IsEmpty(t^.NewExprList.Next)
       THEN ED.Text(E,',');
            Dump(t^.NewExprList.Next);
    END;
 ;
      RETURN;

  | Tree.SysAsmExprList:
(* line 1004 "TD.pum" *)
(* line 1004 "TD.pum" *)
      
    Dump(t^.SysAsmExprList.Expr);
    IF ~IsEmpty(t^.SysAsmExprList.Next)
       THEN ED.Text(E,',');
            Dump(t^.SysAsmExprList.Next);
    END;
 ;
      RETURN;

  ELSE END;

 END Dump;

PROCEDURE DumpExpr (coerce: OB.tOB; expr: Tree.tTree; brackets: BOOLEAN);
 BEGIN
  IF coerce = OB.NoOB THEN RETURN; END;
  IF expr = Tree.NoTree THEN RETURN; END;

  CASE coerce^.Kind OF
  | OB.Shortint2Integer:
  IF (expr^.Kind = Tree.IntConst) THEN
(* line 1014 "TD.pum" *)
(* line 1014 "TD.pum" *)
       ED.Longint (E,expr^.IntConst.Int); ED.Text(E,'I'); ;
      RETURN;

  END;
(* line 1025 "TD.pum" *)
(* line 1025 "TD.pum" *)
       ED.Text(E,'$SI_IN('); Dump(expr); ED.Text(E,')'); ;
      RETURN;

  | OB.Shortint2Longint:
  IF (expr^.Kind = Tree.IntConst) THEN
(* line 1015 "TD.pum" *)
(* line 1015 "TD.pum" *)
       ED.Longint (E,expr^.IntConst.Int); ED.Text(E,'L'); ;
      RETURN;

  END;
(* line 1026 "TD.pum" *)
(* line 1026 "TD.pum" *)
       ED.Text(E,'$SI_LI('); Dump(expr); ED.Text(E,')'); ;
      RETURN;

  | OB.Shortint2Real:
  IF (expr^.Kind = Tree.IntConst) THEN
(* line 1016 "TD.pum" *)
(* line 1016 "TD.pum" *)
       ED.Longint (E,expr^.IntConst.Int); ED.Text(E,'R'); ;
      RETURN;

  END;
(* line 1027 "TD.pum" *)
(* line 1027 "TD.pum" *)
       ED.Text(E,'$SI_RE('); Dump(expr); ED.Text(E,')'); ;
      RETURN;

  | OB.Shortint2Longreal:
  IF (expr^.Kind = Tree.IntConst) THEN
(* line 1017 "TD.pum" *)
(* line 1017 "TD.pum" *)
       ED.Longint (E,expr^.IntConst.Int); ED.Text(E,'D'); ;
      RETURN;

  END;
(* line 1028 "TD.pum" *)
(* line 1028 "TD.pum" *)
       ED.Text(E,'$SI_LR('); Dump(expr); ED.Text(E,')'); ;
      RETURN;

  | OB.Integer2Longint:
  IF (expr^.Kind = Tree.IntConst) THEN
(* line 1018 "TD.pum" *)
(* line 1018 "TD.pum" *)
       ED.Longint (E,expr^.IntConst.Int); ED.Text(E,'L'); ;
      RETURN;

  END;
(* line 1029 "TD.pum" *)
(* line 1029 "TD.pum" *)
       ED.Text(E,'$IN_LI('); Dump(expr); ED.Text(E,')'); ;
      RETURN;

  | OB.Integer2Real:
  IF (expr^.Kind = Tree.IntConst) THEN
(* line 1019 "TD.pum" *)
(* line 1019 "TD.pum" *)
       ED.Longint (E,expr^.IntConst.Int); ED.Text(E,'R'); ;
      RETURN;

  END;
(* line 1030 "TD.pum" *)
(* line 1030 "TD.pum" *)
       ED.Text(E,'$IN_RE('); Dump(expr); ED.Text(E,')'); ;
      RETURN;

  | OB.Integer2Longreal:
  IF (expr^.Kind = Tree.IntConst) THEN
(* line 1020 "TD.pum" *)
(* line 1020 "TD.pum" *)
       ED.Longint (E,expr^.IntConst.Int); ED.Text(E,'D'); ;
      RETURN;

  END;
(* line 1031 "TD.pum" *)
(* line 1031 "TD.pum" *)
       ED.Text(E,'$IN_LR('); Dump(expr); ED.Text(E,')'); ;
      RETURN;

  | OB.Longint2Real:
  IF (expr^.Kind = Tree.IntConst) THEN
(* line 1021 "TD.pum" *)
(* line 1021 "TD.pum" *)
       ED.Longint (E,expr^.IntConst.Int); ED.Text(E,'R'); ;
      RETURN;

  END;
(* line 1032 "TD.pum" *)
(* line 1032 "TD.pum" *)
       ED.Text(E,'$LI_RE('); Dump(expr); ED.Text(E,')'); ;
      RETURN;

  | OB.Longint2Longreal:
  IF (expr^.Kind = Tree.IntConst) THEN
(* line 1022 "TD.pum" *)
(* line 1022 "TD.pum" *)
       ED.Longint (E,expr^.IntConst.Int); ED.Text(E,'D'); ;
      RETURN;

  END;
(* line 1033 "TD.pum" *)
(* line 1033 "TD.pum" *)
       ED.Text(E,'$LI_LR('); Dump(expr); ED.Text(E,')'); ;
      RETURN;

  | OB.Real2Longreal:
  IF (expr^.Kind = Tree.LongrealConst) THEN
(* line 1023 "TD.pum" *)
(* line 1023 "TD.pum" *)
       ED.Longreal(E,expr^.LongrealConst.Longreal); ED.Text(E,'D'); ;
      RETURN;

  END;
(* line 1034 "TD.pum" *)
(* line 1034 "TD.pum" *)
       ED.Text(E,'$RE_LR('); Dump(expr); ED.Text(E,')'); ;
      RETURN;

  | OB.Char2String:
(* line 1035 "TD.pum" *)
(* line 1035 "TD.pum" *)
       ED.Text(E,'$CH_ST('); Dump(expr); ED.Text(E,')'); ;
      RETURN;

  ELSE END;


  CASE expr^.Kind OF
  | Tree.SetExpr:
(* line 1037 "TD.pum" *)
(* line 1037 "TD.pum" *)
       Dump(expr); ;
      RETURN;

  | Tree.DesignExpr:
(* line 1038 "TD.pum" *)
(* line 1038 "TD.pum" *)
       Dump(expr); ;
      RETURN;

  | Tree.IntConst:
(* line 1039 "TD.pum" *)
(* line 1039 "TD.pum" *)
       Dump(expr); ;
      RETURN;

  | Tree.RealConst:
(* line 1040 "TD.pum" *)
(* line 1040 "TD.pum" *)
       Dump(expr); ;
      RETURN;

  | Tree.LongrealConst:
(* line 1041 "TD.pum" *)
(* line 1041 "TD.pum" *)
       Dump(expr); ;
      RETURN;

  | Tree.CharConst:
(* line 1042 "TD.pum" *)
(* line 1042 "TD.pum" *)
       Dump(expr); ;
      RETURN;

  | Tree.StringConst:
(* line 1043 "TD.pum" *)
(* line 1043 "TD.pum" *)
       Dump(expr); ;
      RETURN;

  | Tree.NilConst:
(* line 1044 "TD.pum" *)
(* line 1044 "TD.pum" *)
       Dump(expr); ;
      RETURN;

  ELSE END;

(* line 1045 "TD.pum" *)
(* line 1045 "TD.pum" *)
      
    IF brackets THEN ED.Text(E,'('); END;
    Dump(expr);
    IF brackets THEN ED.Text(E,')'); END;
 ;
      RETURN;

 END DumpExpr;

PROCEDURE DumpSetExpr (val: OB.tOB; expr: Tree.tTree);
 BEGIN
  IF val = OB.NoOB THEN RETURN; END;
  IF expr = Tree.NoTree THEN RETURN; END;
  IF (val^.Kind = OB.SetValue) THEN
(* line 1054 "TD.pum" *)
   LOOP
(* line 1054 "TD.pum" *)
      IF ~((val^.SetValue.v # OT . NoSet)) THEN EXIT; END;
(* line 1054 "TD.pum" *)
      
    ED.Text(E,'{');
    ED.SetElems(E,val^.SetValue.v); 
    DumpElements(expr^.SetExpr.Elements,FALSE); 
    ED.Text(E,'}');
 ;
      RETURN;
   END;

  END;
(* line 1061 "TD.pum" *)
(* line 1061 "TD.pum" *)
      
    ED.Text(E,'{');
    DumpElements(expr^.SetExpr.Elements,TRUE); 
    ED.Text(E,'}');
 ;
      RETURN;

 END DumpSetExpr;

PROCEDURE DumpElements (yyP9: Tree.tTree; isFirst: BOOLEAN);
 BEGIN
  IF yyP9 = Tree.NoTree THEN RETURN; END;
  IF (yyP9^.Kind = Tree.Element) THEN
  IF (yyP9^.Element.Expr2^.Kind = Tree.mtExpr) THEN
(* line 1070 "TD.pum" *)
(* line 1070 "TD.pum" *)
      
    IF ~V.IsCalculatableValue(SYSTEM.VAL(OB.tOB,yyP9^.Element.Expr1^.Exprs.ValueReprOut)) THEN 
       IF isFirst THEN isFirst:=FALSE; ELSE ED.Text(E,','); END; (* IF *)
       Dump(yyP9^.Element.Expr1);
    END; (* IF *)
    DumpElements(yyP9^.Element.Next,isFirst); 
 ;
      RETURN;

  END;
(* line 1078 "TD.pum" *)
(* line 1078 "TD.pum" *)
      
    IF ~V.IsCalculatableValue(SYSTEM.VAL(OB.tOB,yyP9^.Element.Expr1^.Exprs.ValueReprOut)) OR ~V.IsCalculatableValue(SYSTEM.VAL(OB.tOB,yyP9^.Element.Expr2^.Exprs.ValueReprOut)) THEN 
       IF isFirst THEN isFirst:=FALSE; ELSE ED.Text(E,','); END; (* IF *)
       Dump(yyP9^.Element.Expr1);
       IF ~IsEmpty(yyP9^.Element.Expr2) THEN ED.Text(E,'..'); Dump(yyP9^.Element.Expr2); END;
    END; (* IF *)
    DumpElements(yyP9^.Element.Next,isFirst); 
 ;
      RETURN;

  END;
 END DumpElements;

PROCEDURE DumpPredecl (yyP10: Tree.tTree);
 BEGIN
  IF yyP10 = Tree.NoTree THEN RETURN; END;

  CASE yyP10^.Kind OF
  | Tree.AbsArgumenting:
(* line 1089 "TD.pum" *)
(* line 1089 "TD.pum" *)
       ED.Text(E,'$ABS'         ); ;
      RETURN;

  | Tree.AshArgumenting:
(* line 1090 "TD.pum" *)
(* line 1090 "TD.pum" *)
       ED.Text(E,'$ASH'         ); ;
      RETURN;

  | Tree.CapArgumenting:
(* line 1091 "TD.pum" *)
(* line 1091 "TD.pum" *)
       ED.Text(E,'$CAP'         ); ;
      RETURN;

  | Tree.ChrArgumenting:
(* line 1092 "TD.pum" *)
(* line 1092 "TD.pum" *)
       ED.Text(E,'$CHR'         ); ;
      RETURN;

  | Tree.EntierArgumenting:
(* line 1093 "TD.pum" *)
(* line 1093 "TD.pum" *)
       ED.Text(E,'$ENTIER'      ); ;
      RETURN;

  | Tree.LenArgumenting:
(* line 1094 "TD.pum" *)
(* line 1094 "TD.pum" *)
       ED.Text(E,'$LEN'         ); ;
      RETURN;

  | Tree.LongArgumenting:
(* line 1095 "TD.pum" *)
(* line 1095 "TD.pum" *)
       ED.Text(E,'$LONG'        ); ;
      RETURN;

  | Tree.MaxArgumenting:
(* line 1096 "TD.pum" *)
(* line 1096 "TD.pum" *)
       ED.Text(E,'$MAX'         ); ;
      RETURN;

  | Tree.MinArgumenting:
(* line 1097 "TD.pum" *)
(* line 1097 "TD.pum" *)
       ED.Text(E,'$MIN'         ); ;
      RETURN;

  | Tree.OddArgumenting:
(* line 1098 "TD.pum" *)
(* line 1098 "TD.pum" *)
       ED.Text(E,'$ODD'         ); ;
      RETURN;

  | Tree.OrdArgumenting:
(* line 1099 "TD.pum" *)
(* line 1099 "TD.pum" *)
       ED.Text(E,'$ORD'         ); ;
      RETURN;

  | Tree.ShortArgumenting:
(* line 1100 "TD.pum" *)
(* line 1100 "TD.pum" *)
       ED.Text(E,'$SHORT'       ); ;
      RETURN;

  | Tree.SizeArgumenting:
(* line 1101 "TD.pum" *)
(* line 1101 "TD.pum" *)
       ED.Text(E,'$SIZE'        ); ;
      RETURN;

  | Tree.AssertArgumenting:
(* line 1103 "TD.pum" *)
(* line 1103 "TD.pum" *)
       ED.Text(E,'$ASSERT'      ); ;
      RETURN;

  | Tree.CopyArgumenting:
(* line 1104 "TD.pum" *)
(* line 1104 "TD.pum" *)
       ED.Text(E,'$COPY'        ); ;
      RETURN;

  | Tree.DecArgumenting:
(* line 1105 "TD.pum" *)
(* line 1105 "TD.pum" *)
       ED.Text(E,'$DEC'         ); ;
      RETURN;

  | Tree.ExclArgumenting:
(* line 1106 "TD.pum" *)
(* line 1106 "TD.pum" *)
       ED.Text(E,'$EXCL'        ); ;
      RETURN;

  | Tree.HaltArgumenting:
(* line 1107 "TD.pum" *)
(* line 1107 "TD.pum" *)
       ED.Text(E,'$HALT'        ); ;
      RETURN;

  | Tree.IncArgumenting:
(* line 1108 "TD.pum" *)
(* line 1108 "TD.pum" *)
       ED.Text(E,'$INC'         ); ;
      RETURN;

  | Tree.InclArgumenting:
(* line 1109 "TD.pum" *)
(* line 1109 "TD.pum" *)
       ED.Text(E,'$INCL'        ); ;
      RETURN;

  | Tree.NewArgumenting:
(* line 1110 "TD.pum" *)
(* line 1110 "TD.pum" *)
       ED.Text(E,'$NEW'         ); ;
      RETURN;

  | Tree.SysAdrArgumenting:
(* line 1112 "TD.pum" *)
(* line 1112 "TD.pum" *)
       ED.Text(E,'SYSTEM$ADR'   ); ;
      RETURN;

  | Tree.SysBitArgumenting:
(* line 1113 "TD.pum" *)
(* line 1113 "TD.pum" *)
       ED.Text(E,'SYSTEM$BIT'   ); ;
      RETURN;

  | Tree.SysCcArgumenting:
(* line 1114 "TD.pum" *)
(* line 1114 "TD.pum" *)
       ED.Text(E,'SYSTEM$CC'    ); ;
      RETURN;

  | Tree.SysLshArgumenting:
(* line 1115 "TD.pum" *)
(* line 1115 "TD.pum" *)
       ED.Text(E,'SYSTEM$LSH'   ); ;
      RETURN;

  | Tree.SysRotArgumenting:
(* line 1116 "TD.pum" *)
(* line 1116 "TD.pum" *)
       ED.Text(E,'SYSTEM$ROT'   ); ;
      RETURN;

  | Tree.SysValArgumenting:
(* line 1117 "TD.pum" *)
(* line 1117 "TD.pum" *)
       ED.Text(E,'SYSTEM$VAL'   ); ;
      RETURN;

  | Tree.SysGetArgumenting:
(* line 1119 "TD.pum" *)
(* line 1119 "TD.pum" *)
       ED.Text(E,'SYSTEM$GET'   ); ;
      RETURN;

  | Tree.SysPutArgumenting:
(* line 1120 "TD.pum" *)
(* line 1120 "TD.pum" *)
       ED.Text(E,'SYSTEM$PUT'   ); ;
      RETURN;

  | Tree.SysGetregArgumenting:
(* line 1121 "TD.pum" *)
(* line 1121 "TD.pum" *)
       ED.Text(E,'SYSTEM$GETREG'); ;
      RETURN;

  | Tree.SysPutregArgumenting:
(* line 1122 "TD.pum" *)
(* line 1122 "TD.pum" *)
       ED.Text(E,'SYSTEM$PUTREG'); ;
      RETURN;

  | Tree.SysMoveArgumenting:
(* line 1123 "TD.pum" *)
(* line 1123 "TD.pum" *)
       ED.Text(E,'SYSTEM$MOVE'  ); ;
      RETURN;

  | Tree.SysNewArgumenting:
(* line 1124 "TD.pum" *)
(* line 1124 "TD.pum" *)
       ED.Text(E,'SYSTEM$NEW'   ); ;
      RETURN;

  | Tree.SysAsmArgumenting:
(* line 1125 "TD.pum" *)
(* line 1125 "TD.pum" *)
       ED.Text(E,'SYSTEM$ASM'   ); ;
      RETURN;

  ELSE END;

(* line 1127 "TD.pum" *)
(* line 1127 "TD.pum" *)
       ED.Text(E,'$PREDECL?'    ); ;
      RETURN;

 END DumpPredecl;

PROCEDURE DumpValue (yyP11: OB.tOB);
 BEGIN
  IF yyP11 = OB.NoOB THEN RETURN; END;

  CASE yyP11^.Kind OF
  | OB.BooleanValue:
(* line 1132 "TD.pum" *)
(* line 1132 "TD.pum" *)
       ED.Boolean(E,yyP11^.BooleanValue.v        ); ;
      RETURN;

  | OB.CharValue:
(* line 1133 "TD.pum" *)
(* line 1133 "TD.pum" *)
       ED.Char   (E,yyP11^.CharValue.v        ); ;
      RETURN;

  | OB.StringValue:
(* line 1134 "TD.pum" *)
(* line 1134 "TD.pum" *)
       ED.String (E,yyP11^.StringValue.v        ); ;
      RETURN;

  | OB.SetValue:
(* line 1135 "TD.pum" *)
(* line 1135 "TD.pum" *)
       ED.Set    (E,yyP11^.SetValue.v        ); ;
      RETURN;

  | OB.NilValue:
(* line 1136 "TD.pum" *)
(* line 1136 "TD.pum" *)
       ED.Text   (E,'<NIL>'  ); ;
      RETURN;

  | OB.NilPointerValue:
(* line 1137 "TD.pum" *)
(* line 1137 "TD.pum" *)
       ED.Text   (E,'NIL'    ); ;
      RETURN;

  | OB.NilProcedureValue:
(* line 1138 "TD.pum" *)
(* line 1138 "TD.pum" *)
       ED.Text   (E,'NILPROC'); ;
      RETURN;

  | OB.IntegerValue:
(* line 1140 "TD.pum" *)
(* line 1140 "TD.pum" *)
      
    IF    yyP11^.IntegerValue.v=OT.MINoSHORTINT THEN ED.Text(E,'MIN(SHORTINT)');
    ELSIF yyP11^.IntegerValue.v=OT.MAXoSHORTINT THEN ED.Text(E,'MAX(SHORTINT)');
    ELSIF yyP11^.IntegerValue.v=OT.MINoINTEGER  THEN ED.Text(E,'MIN(INTEGER)');
    ELSIF yyP11^.IntegerValue.v=OT.MAXoINTEGER  THEN ED.Text(E,'MAX(INTEGER)');
    ELSIF yyP11^.IntegerValue.v=OT.MINoLONGINT  THEN ED.Text(E,'MIN(LONGINT)');
    ELSIF yyP11^.IntegerValue.v=OT.MAXoLONGINT  THEN ED.Text(E,'MAX(LONGINT)');
                            ELSE ED.Longint(E,yyP11^.IntegerValue.v);
    END; (* IF *)
 ;
      RETURN;

  | OB.RealValue:
(* line 1151 "TD.pum" *)
(* line 1151 "TD.pum" *)
      
    IF    yyP11^.RealValue.v=OT.MINoREAL THEN ED.Text(E,'MIN(REAL)');
    ELSIF yyP11^.RealValue.v=OT.MAXoREAL THEN ED.Text(E,'MAX(REAL)');
                        ELSE ED.Real(E,yyP11^.RealValue.v);
    END; (* IF *)
 ;
      RETURN;

  | OB.LongrealValue:
(* line 1158 "TD.pum" *)
(* line 1158 "TD.pum" *)
      
    IF    OT.EqualoLONGREAL(yyP11^.LongrealValue.v,OT.MINoLONGREAL) THEN ED.Text(E,'MIN(LONGREAL)');
    ELSIF OT.EqualoLONGREAL(yyP11^.LongrealValue.v,OT.MAXoLONGREAL) THEN ED.Text(E,'MAX(LONGREAL)');
                                               ELSE ED.Longreal(E,yyP11^.LongrealValue.v);
    END; (* IF *)
 ;
      RETURN;

  ELSE END;

 END DumpValue;

PROCEDURE BeginTD*;
 BEGIN
 END BeginTD;

PROCEDURE CloseTD*;
 BEGIN
 END CloseTD;

PROCEDURE yyExit;
 BEGIN
  IO.CloseIO; System.Exit (1);
 END yyExit;

BEGIN
 yyf	:= IO.StdOutput;
 Exit	:= yyExit;
 BeginTD;
END TD.

