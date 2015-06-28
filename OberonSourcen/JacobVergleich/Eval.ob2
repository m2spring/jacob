MODULE Eval;

IMPORT SYSTEM, Tree,
(* line 677 "oberon.aecp" *)
 ADR              ,
               ARG              ,
	       BL               ,
               CO               ,
               Base             ,
               E                ,
               ERR              ,
               ErrLists         ,
               FIL              ,
               Idents           ,
	       LIM              ,
               LAB              ,
               O                ,
               OD               ,
               OB               ,
               OT               ,
               POS              ,
               PR               ,
               SI               ,
	       STR              ,
               TT               ,
               T                ,
               UTI              ,
               V                ;

        TYPE   tOB              = OB.tOB;                             (* These types are re-declared due to the fact that       *)
               tSize            = OB.tSize;                           (* qualidents are  illegal in an ast specification.       *)
               tAddress         = OB.tAddress;                        
               tParMode         = OB.tParMode;

VAR yyb	: BOOLEAN;
        PROCEDURE superfluous_application_due_to_warning_suppression(VAR b:ARRAY OF SYSTEM.BYTE) : BOOLEAN;
        BEGIN RETURN TRUE; END superfluous_application_due_to_warning_suppression; 


PROCEDURE^yyVisit1 (yyt: Tree.tTree);
PROCEDURE^yyVisit2 (yyt: Tree.tTree);
PROCEDURE^yyVisit3 (yyt: Tree.tTree);

PROCEDURE Eval* (yyt: Tree.tTree);
 BEGIN yyVisit1 (yyt); END Eval;

PROCEDURE yyVisit1 (yyt: Tree.tTree);
 BEGIN
  CASE yyt^.Kind OF
| Tree.Module:
(* line 3279 "oberon.aecp" *)
IF ~( (yyt^.Module.Name=yyt^.Module.Name2)
  ) THEN  ERR.MsgPos(ERR.MsgModulename2Incorrect,yyt^.Module.Pos2)
 END;
(* line 3164 "oberon.aecp" *)

  yyt^.Module.TDescList                     := OB.mTDescList(OB.cmtTDescElem);
(* line 738 "oberon.aecp" *)

  yyt^.Module.ModuleEntry                   := OB.mModuleEntry
                                   ( yyt^.Module.Name
                                   , LAB.AppS(LAB.NewGlobal(yyt^.Module.Name),'$G')
                                   , yyt^.Module.IsForeign);
(* line 3231 "oberon.aecp" *)

  yyt^.Module.env                           := OB.mEnvironment(yyt^.Module.ModuleEntry,OB.NOLEVELS);
(* line 3232 "oberon.aecp" *)
 
  yyt^.Module.DeclSection^.DeclSection.EnvIn             := yyt^.Module.env;
(* line 3165 "oberon.aecp" *)
 
  yyt^.Module.DeclSection^.DeclSection.TDescListIn       := yyt^.Module.TDescList;
(* line 3087 "oberon.aecp" *)

  yyt^.Module.DeclSection^.DeclSection.NamePathIn        := OB.mSelectNamePath(OB.mIdentNamePath(OB.cmtNamePath,yyt^.Module.Name));
(* line 3003 "oberon.aecp" *)
 IF yyt^.Module.IsForeign THEN 
                                        yyt^.Module.DeclSection^.DeclSection.LabelPrefixIn:=LAB.NewGlobal(Idents.NoIdent);
                                     ELSE 
                                        yyt^.Module.DeclSection^.DeclSection.LabelPrefixIn:=LAB.NewGlobal(yyt^.Module.Name);
                                     END; 
(* line 2537 "oberon.aecp" *)

  yyt^.Module.DeclSection^.DeclSection.LevelIn           := OB.MODULELEVEL;
(* line 2579 "oberon.aecp" *)

  yyt^.Module.DeclSection^.DeclSection.VarAddrIn         := ADR.GlobalVarBase;
(* line 743 "oberon.aecp" *)
 yyt^.Module.Imports^.Imports.TableIn:=OB.mScopeEntry(PR.GetTablePREDECL());                    

                                     IF ARG.OptionShowPredeclTable & (FIL.NestingDepth<=1)THEN 
                                        OD.DumpTable(yyt^.Module.Name,yyt^.Module.Imports^.Imports.TableIn,UTI.MakeString('PREDECL'),yyt^.Module.Name);
                                     END;
                                   
(* line 749 "oberon.aecp" *)

  yyt^.Module.Imports^.Imports.ModuleIn              := yyt^.Module.ModuleEntry;
yyVisit1 (yyt^.Module.Imports);
(* line 751 "oberon.aecp" *)


  yyt^.Module.DeclSection^.DeclSection.TableIn           := SYSTEM.VAL(OB.tOB,Base.ShowCompiling(yyt^.Module.Imports^.Imports.TableOut));
(* line 752 "oberon.aecp" *)

  yyt^.Module.DeclSection^.DeclSection.ModuleIn          := yyt^.Module.ModuleEntry;
yyVisit1 (yyt^.Module.DeclSection);
(* line 2580 "oberon.aecp" *)

  yyt^.Module.GlobalSpace                   := ADR.Align4(yyt^.Module.DeclSection^.DeclSection.VarAddrOut-ADR.GlobalVarBase);
(* line 3233 "oberon.aecp" *)

  yyt^.Module.Stmts^.Stmts.EnvIn                   := yyt^.Module.env;
(* line 3008 "oberon.aecp" *)

  yyt^.Module.Stmts^.Stmts.LoopEndLabelIn          := LAB.MT;
(* line 2751 "oberon.aecp" *)

  yyt^.Module.Stmts^.Stmts.TempOfsIn               := ADR.GlobalTmpBase;
(* line 2538 "oberon.aecp" *)

  yyt^.Module.Stmts^.Stmts.LevelIn                 := OB.MODULELEVEL;
(* line 771 "oberon.aecp" *)

  yyt^.Module.Stmts^.Stmts.ResultTypeReprIn        := OB.cmtTypeRepr;
(* line 755 "oberon.aecp" *)
 yyt^.Module.Stmts^.Stmts.TableIn:=E.CheckUnresolvedForwardBoundProcs                 
                                                    (E.CheckUnresolvedForwardProcs
                                                     (SYSTEM.VAL(OB.tOB,Base.ShowProcCount(yyt^.Module.DeclSection^.DeclSection.TableOut)))
                                                    );
                                     IF ErrLists.Length(FIL.ActP^.ErrorList)=0 THEN 
                                        T.CalcProcNumsOfEntries(yyt^.Module.Stmts^.Stmts.TableIn); 
                                     END;
                                     FIL.ActP^.MainTable   := yyt^.Module.DeclSection^.DeclSection.TableOut;
                                     FIL.ActP^.IsForeign   := yyt^.Module.IsForeign;           
                                     FIL.ActP^.ModuleEntry := yyt^.Module.ModuleEntry;           

                                     IF ARG.OptionShowStmtTables & (FIL.NestingDepth<=1) THEN 
                                        OD.DumpTable0(yyt^.Module.Name,yyt^.Module.Stmts^.Stmts.TableIn,UTI.MakeString('MODULE'),yyt^.Module.Name);
                                     END;
                                   
(* line 770 "oberon.aecp" *)

  yyt^.Module.Stmts^.Stmts.ModuleIn                := yyt^.Module.ModuleEntry;
yyVisit1 (yyt^.Module.Stmts);
(* line 773 "oberon.aecp" *)

  
  yyt^.Module.Globals                       := yyt^.Module.DeclSection^.DeclSection.TableOut;
(* line 2753 "oberon.aecp" *)

  
  yyt^.Module.TempSpace                     := ADR.GlobalTmpBase-yyt^.Module.Stmts^.Stmts.TempOfsOut;
(* line 3275 "oberon.aecp" *)
IF ~( (FIL.ActP^.ModuleIdent=Idents.NoIdent)                                                           
     OR (yyt^.Module.Name=FIL.ActP^.ModuleIdent)
  ) THEN  ERR.MsgPos(ERR.MsgModuleFilenameDiffers,yyt^.Module.Pos)
 END;
| Tree.Imports:
yyt^.Imports.TableOut:=yyt^.Imports.TableIn;
| Tree.mtImport:
yyt^.mtImport.TableOut:=yyt^.mtImport.TableIn;
| Tree.Import:
(* line 784 "oberon.aecp" *)
 yyt^.Import.ServerTable:=SYSTEM.VAL(OB.tOB,Base.Import(yyt^.Import.ServerId,yyt^.Import.ErrorMsg));
                                     IF ARG.OptionShowImportTables & (FIL.NestingDepth<=1) THEN 
                                        OD.DumpTable0(E.IdentOfEntry(yyt^.Import.ModuleIn)
                                                       ,yyt^.Import.ServerTable,UTI.MakeString('SERVER'),yyt^.Import.ServerId);
                                     END;
                                   
(* line 3289 "oberon.aecp" *)
IF ~( (yyt^.Import.ErrorMsg=ERR.NoErrorMsg)                                                         
  ) THEN  ERR.MsgPos(yyt^.Import.ErrorMsg,yyt^.Import.ServerPos)
 END;
(* line 791 "oberon.aecp" *)


  yyt^.Import.Next^.Imports.TableIn                  := OB.mServerEntry
                                   ( yyt^.Import.TableIn
                                   , yyt^.Import.ModuleIn     
                                   , yyt^.Import.RefId
                                   , OB.PRIVATE
                                   , 1
                                   , OB.DECLARED
                                   , yyt^.Import.ServerTable
                                   , yyt^.Import.ServerId);
yyt^.Import.Next^.Imports.ModuleIn:=yyt^.Import.ModuleIn;
yyVisit1 (yyt^.Import.Next);
(* line 3286 "oberon.aecp" *)
IF ~( E.IsUndeclared(yyt^.Import.TableIn,yyt^.Import.RefId)                                                                    
  ) THEN  ERR.MsgPos(ERR.MsgAlreadyDeclared,yyt^.Import.RefPos)
 END;
(* line 800 "oberon.aecp" *)

  yyt^.Import.TableOut                      := yyt^.Import.Next^.Imports.TableOut;
| Tree.DeclSection:
yyt^.DeclSection.DeclUnits^.DeclUnits.ModuleIn:=yyt^.DeclSection.ModuleIn;
yyt^.DeclSection.Procs^.Procs.EnvIn:=yyt^.DeclSection.EnvIn;
yyt^.DeclSection.Procs^.Procs.TDescListIn:=yyt^.DeclSection.TDescListIn;
yyt^.DeclSection.Procs^.Procs.NamePathIn:=yyt^.DeclSection.NamePathIn;
yyt^.DeclSection.Procs^.Procs.LabelPrefixIn:=yyt^.DeclSection.LabelPrefixIn;
yyt^.DeclSection.Procs^.Procs.LevelIn:=yyt^.DeclSection.LevelIn;
yyt^.DeclSection.DeclUnits^.DeclUnits.EnvIn:=yyt^.DeclSection.EnvIn;
yyt^.DeclSection.DeclUnits^.DeclUnits.TDescListIn:=yyt^.DeclSection.TDescListIn;
yyt^.DeclSection.DeclUnits^.DeclUnits.NamePathIn:=yyt^.DeclSection.NamePathIn;
yyt^.DeclSection.DeclUnits^.DeclUnits.LabelPrefixIn:=yyt^.DeclSection.LabelPrefixIn;
yyt^.DeclSection.DeclUnits^.DeclUnits.VarAddrIn:=yyt^.DeclSection.VarAddrIn;
yyt^.DeclSection.DeclUnits^.DeclUnits.LevelIn:=yyt^.DeclSection.LevelIn;
(* line 807 "oberon.aecp" *)

  yyt^.DeclSection.DeclUnits^.DeclUnits.TableIn             := yyt^.DeclSection.TableIn;
yyVisit1 (yyt^.DeclSection.DeclUnits);
(* line 809 "oberon.aecp" *)


  yyt^.DeclSection.Procs^.Procs.TableIn                 := E.CheckUnresolvedForwardPointers(yyt^.DeclSection.DeclUnits^.DeclUnits.TableOut);
yyt^.DeclSection.Procs^.Procs.ModuleIn:=yyt^.DeclSection.ModuleIn;
yyVisit1 (yyt^.DeclSection.Procs);
yyt^.DeclSection.VarAddrOut:=yyt^.DeclSection.DeclUnits^.DeclUnits.VarAddrOut;
(* line 811 "oberon.aecp" *)
               

  yyt^.DeclSection.TableOut                      := yyt^.DeclSection.Procs^.Procs.TableOut;
| Tree.DeclUnits:
yyt^.DeclUnits.VarAddrOut:=yyt^.DeclUnits.VarAddrIn;
yyt^.DeclUnits.TableOut:=yyt^.DeclUnits.TableIn;
| Tree.mtDeclUnit:
yyt^.mtDeclUnit.VarAddrOut:=yyt^.mtDeclUnit.VarAddrIn;
yyt^.mtDeclUnit.TableOut:=yyt^.mtDeclUnit.TableIn;
| Tree.DeclUnit:
yyt^.DeclUnit.Next^.DeclUnits.ModuleIn:=yyt^.DeclUnit.ModuleIn;
yyt^.DeclUnit.Decls^.Decls.EnvIn:=yyt^.DeclUnit.EnvIn;
yyt^.DeclUnit.Decls^.Decls.TDescListIn:=yyt^.DeclUnit.TDescListIn;
yyt^.DeclUnit.Decls^.Decls.NamePathIn:=yyt^.DeclUnit.NamePathIn;
yyt^.DeclUnit.Decls^.Decls.LabelPrefixIn:=yyt^.DeclUnit.LabelPrefixIn;
(* line 2592 "oberon.aecp" *)

  yyt^.DeclUnit.Decls^.Decls.VarAddrIn               := yyt^.DeclUnit.VarAddrIn;
yyt^.DeclUnit.Decls^.Decls.LevelIn:=yyt^.DeclUnit.LevelIn;
(* line 820 "oberon.aecp" *)

  yyt^.DeclUnit.Decls^.Decls.TableIn                 := yyt^.DeclUnit.TableIn;
yyt^.DeclUnit.Decls^.Decls.ModuleIn:=yyt^.DeclUnit.ModuleIn;
yyVisit1 (yyt^.DeclUnit.Decls);
yyt^.DeclUnit.Next^.DeclUnits.EnvIn:=yyt^.DeclUnit.EnvIn;
yyt^.DeclUnit.Next^.DeclUnits.TDescListIn:=yyt^.DeclUnit.TDescListIn;
yyt^.DeclUnit.Next^.DeclUnits.NamePathIn:=yyt^.DeclUnit.NamePathIn;
yyt^.DeclUnit.Next^.DeclUnits.LabelPrefixIn:=yyt^.DeclUnit.LabelPrefixIn;
(* line 2593 "oberon.aecp" *)

  yyt^.DeclUnit.Next^.DeclUnits.VarAddrIn                := yyt^.DeclUnit.Decls^.Decls.VarAddrOut;
yyt^.DeclUnit.Next^.DeclUnits.LevelIn:=yyt^.DeclUnit.LevelIn;
(* line 822 "oberon.aecp" *)


  yyt^.DeclUnit.Next^.DeclUnits.TableIn                  := yyt^.DeclUnit.Decls^.Decls.TableOut;
yyVisit1 (yyt^.DeclUnit.Next);
(* line 2594 "oberon.aecp" *)

  yyt^.DeclUnit.VarAddrOut                    := yyt^.DeclUnit.Next^.DeclUnits.VarAddrOut;
(* line 824 "oberon.aecp" *)


  yyt^.DeclUnit.TableOut                      := yyt^.DeclUnit.Next^.DeclUnits.TableOut;
| Tree.Decls:
yyt^.Decls.VarAddrOut:=yyt^.Decls.VarAddrIn;
yyt^.Decls.TableOut:=yyt^.Decls.TableIn;
| Tree.mtDecl:
yyt^.mtDecl.VarAddrOut:=yyt^.mtDecl.VarAddrIn;
yyt^.mtDecl.TableOut:=yyt^.mtDecl.TableIn;
| Tree.Decl:
yyt^.Decl.Next^.Decls.EnvIn:=yyt^.Decl.EnvIn;
yyt^.Decl.Next^.Decls.TDescListIn:=yyt^.Decl.TDescListIn;
yyt^.Decl.Next^.Decls.NamePathIn:=yyt^.Decl.NamePathIn;
yyt^.Decl.Next^.Decls.LabelPrefixIn:=yyt^.Decl.LabelPrefixIn;
yyt^.Decl.Next^.Decls.VarAddrIn:=yyt^.Decl.VarAddrIn;
yyt^.Decl.Next^.Decls.LevelIn:=yyt^.Decl.LevelIn;
yyt^.Decl.Next^.Decls.TableIn:=yyt^.Decl.TableIn;
yyt^.Decl.Next^.Decls.ModuleIn:=yyt^.Decl.ModuleIn;
yyVisit1 (yyt^.Decl.Next);
yyt^.Decl.VarAddrOut:=yyt^.Decl.Next^.Decls.VarAddrOut;
yyt^.Decl.TableOut:=yyt^.Decl.Next^.Decls.TableOut;
| Tree.ConstDecl:
(* line 3299 "oberon.aecp" *)
IF ~( (yyt^.ConstDecl.IdentDef^.IdentDef.ExportMode#OB.READONLY)                                                                  
  ) THEN  ERR.MsgPos(ERR.MsgConstsAlwaysReadOnly,yyt^.ConstDecl.IdentDef^.IdentDef.Pos)
 END;
(* line 3013 "oberon.aecp" *)

  yyt^.ConstDecl.label                         := LAB.MakeGlobal
                                   ( (yyt^.ConstDecl.IdentDef^.IdentDef.ExportMode#OB.PRIVATE)
                                   , yyt^.ConstDecl.LabelPrefixIn
                                   , yyt^.ConstDecl.IdentDef^.IdentDef.Ident);
(* line 836 "oberon.aecp" *)

  yyt^.ConstDecl.TableTmp                      := OB.mConstEntry
                                   ( yyt^.ConstDecl.TableIn
                                   , yyt^.ConstDecl.ModuleIn     
                                   , yyt^.ConstDecl.IdentDef^.IdentDef.Ident
                                   , yyt^.ConstDecl.IdentDef^.IdentDef.ExportMode
                                   , yyt^.ConstDecl.LevelIn
                                   , OB.TOBEDECLARED
                                   , OB.cmtObject
                                   , OB.cmtObject
                                   , yyt^.ConstDecl.label);
(* line 858 "oberon.aecp" *)


  yyt^.ConstDecl.Entry                         := yyt^.ConstDecl.TableTmp;
yyt^.ConstDecl.ConstExpr^.ConstExpr.EnvIn:=yyt^.ConstDecl.EnvIn;
yyt^.ConstDecl.ConstExpr^.ConstExpr.LevelIn:=yyt^.ConstDecl.LevelIn;
(* line 847 "oberon.aecp" *)


  yyt^.ConstDecl.ConstExpr^.ConstExpr.TableIn             := yyt^.ConstDecl.TableTmp;
yyt^.ConstDecl.ConstExpr^.ConstExpr.ModuleIn:=yyt^.ConstDecl.ModuleIn;
yyVisit1 (yyt^.ConstDecl.ConstExpr);
yyt^.ConstDecl.IdentDef^.IdentDef.LevelIn:=yyt^.ConstDecl.LevelIn;
yyVisit1 (yyt^.ConstDecl.IdentDef);
yyt^.ConstDecl.Next^.Decls.EnvIn:=yyt^.ConstDecl.EnvIn;
yyt^.ConstDecl.Next^.Decls.TDescListIn:=yyt^.ConstDecl.TDescListIn;
yyt^.ConstDecl.Next^.Decls.NamePathIn:=yyt^.ConstDecl.NamePathIn;
yyt^.ConstDecl.Next^.Decls.LabelPrefixIn:=yyt^.ConstDecl.LabelPrefixIn;
yyt^.ConstDecl.Next^.Decls.VarAddrIn:=yyt^.ConstDecl.VarAddrIn;
yyt^.ConstDecl.Next^.Decls.LevelIn:=yyt^.ConstDecl.LevelIn;
(* line 849 "oberon.aecp" *)


  yyt^.ConstDecl.Next^.Decls.TableIn                  := E.DefineConstEntry
                                   ( yyt^.ConstDecl.TableTmp
                                   , yyt^.ConstDecl.LevelIn
                                   , yyt^.ConstDecl.IdentDef^.IdentDef.Ident
                                   , yyt^.ConstDecl.ConstExpr^.ConstExpr.TypeReprOut
                                   , yyt^.ConstDecl.ConstExpr^.ConstExpr.ValueReprOut);
yyt^.ConstDecl.Next^.Decls.ModuleIn:=yyt^.ConstDecl.ModuleIn;
yyVisit1 (yyt^.ConstDecl.Next);
(* line 3296 "oberon.aecp" *)
IF ~( E.IsUndeclared(yyt^.ConstDecl.TableIn,yyt^.ConstDecl.IdentDef^.IdentDef.Ident)                                                           
  ) THEN  ERR.MsgPos(ERR.MsgAlreadyDeclared,yyt^.ConstDecl.IdentDef^.IdentDef.Pos)
 END;
yyt^.ConstDecl.VarAddrOut:=yyt^.ConstDecl.Next^.Decls.VarAddrOut;
(* line 856 "oberon.aecp" *)


  yyt^.ConstDecl.TableOut                      := yyt^.ConstDecl.Next^.Decls.TableOut;
| Tree.TypeDecl:
(* line 3314 "oberon.aecp" *)
IF ~( (yyt^.TypeDecl.IdentDef^.IdentDef.ExportMode#OB.READONLY)                                                                  
  ) THEN  ERR.MsgPos(ERR.MsgTypesAlwaysReadOnly,yyt^.TypeDecl.IdentDef^.IdentDef.Pos)
 END;
yyVisit1 (yyt^.TypeDecl.Type);
yyt^.TypeDecl.Type^.Type.EnvIn:=yyt^.TypeDecl.EnvIn;
yyt^.TypeDecl.Type^.Type.TDescListIn:=yyt^.TypeDecl.TDescListIn;
(* line 3091 "oberon.aecp" *)

  yyt^.TypeDecl.Type^.Type.NamePathIn               := OB.mIdentNamePath(yyt^.TypeDecl.NamePathIn,yyt^.TypeDecl.IdentDef^.IdentDef.Ident);
yyt^.TypeDecl.Type^.Type.LevelIn:=yyt^.TypeDecl.LevelIn;
(* line 880 "oberon.aecp" *)
                                                                     
  yyt^.TypeDecl.Type^.Type.IsVarParTypeIn           := FALSE;
(* line 879 "oberon.aecp" *)
                                                   
  yyt^.TypeDecl.Type^.Type.OpenArrayIsOkIn          := TRUE;
(* line 878 "oberon.aecp" *)

  yyt^.TypeDecl.Type^.Type.ForwardPBaseIsOkIn       := TRUE;
(* line 868 "oberon.aecp" *)

  yyt^.TypeDecl.TableTmp                      := OB.mTypeEntry
                                   ( yyt^.TypeDecl.TableIn
                                   , yyt^.TypeDecl.ModuleIn
                                   , yyt^.TypeDecl.IdentDef^.IdentDef.Ident
                                   , yyt^.TypeDecl.IdentDef^.IdentDef.ExportMode
                                   , yyt^.TypeDecl.LevelIn
                                   , OB.TOBEDECLARED
                                   , yyt^.TypeDecl.Type^.Type.FirstTypeReprOut);
(* line 877 "oberon.aecp" *)


  yyt^.TypeDecl.Type^.Type.TableIn                  := yyt^.TypeDecl.TableTmp;
yyt^.TypeDecl.Type^.Type.ModuleIn:=yyt^.TypeDecl.ModuleIn;
yyVisit2 (yyt^.TypeDecl.Type);
yyt^.TypeDecl.IdentDef^.IdentDef.LevelIn:=yyt^.TypeDecl.LevelIn;
yyVisit1 (yyt^.TypeDecl.IdentDef);
yyt^.TypeDecl.Next^.Decls.EnvIn:=yyt^.TypeDecl.EnvIn;
yyt^.TypeDecl.Next^.Decls.TDescListIn:=yyt^.TypeDecl.TDescListIn;
yyt^.TypeDecl.Next^.Decls.NamePathIn:=yyt^.TypeDecl.NamePathIn;
yyt^.TypeDecl.Next^.Decls.LabelPrefixIn:=yyt^.TypeDecl.LabelPrefixIn;
yyt^.TypeDecl.Next^.Decls.VarAddrIn:=yyt^.TypeDecl.VarAddrIn;
yyt^.TypeDecl.Next^.Decls.LevelIn:=yyt^.TypeDecl.LevelIn;
(* line 882 "oberon.aecp" *)
                                                                     

  yyt^.TypeDecl.ForwardedEntry                := E.LookupForward
                                   ( yyt^.TypeDecl.TableIn
                                   , yyt^.TypeDecl.IdentDef^.IdentDef.Ident);
(* line 886 "oberon.aecp" *)
 E.PosOfForwardEntry(yyt^.TypeDecl.ForwardedEntry,yyt^.TypeDecl.ForwardedPos); 
(* line 888 "oberon.aecp" *)
 yyt^.TypeDecl.Next^.Decls.TableIn                := E.DefineTypeEntry
                                   ( yyt^.TypeDecl.Type^.Type.TableOut
                                   , yyt^.TypeDecl.TableTmp
                                   , yyt^.TypeDecl.ForwardedEntry
                                   , yyt^.TypeDecl.LevelIn
                                   , yyt^.TypeDecl.IdentDef^.IdentDef.Ident
                                   , yyt^.TypeDecl.Type^.Type.TypeReprOut);
    yyt^.TypeDecl.TypeEntry                   := yyt^.TypeDecl.TableTmp; 
  
yyt^.TypeDecl.Next^.Decls.ModuleIn:=yyt^.TypeDecl.ModuleIn;
yyVisit1 (yyt^.TypeDecl.Next);
 T.DefineTypeReprLabel
      (yyt^.TypeDecl.TypeEntry
      ,LAB.App_Id(yyt^.TypeDecl.LabelPrefixIn,yyt^.TypeDecl.IdentDef^.IdentDef.Ident));
 T.AppendTDesc(yyt^.TypeDecl.TDescListIn
                     ,yyt^.TypeDecl.TypeEntry
                     ,yyt^.TypeDecl.Type^.Type.NamePathIn);
(* line 3306 "oberon.aecp" *)
IF ~(  E.IsUndeclared(yyt^.TypeDecl.TableIn,yyt^.TypeDecl.IdentDef^.IdentDef.Ident)                                                          
     OR ~E.IsGenuineEmptyEntry(yyt^.TypeDecl.ForwardedEntry)                                                                
  ) THEN  ERR.MsgPos(ERR.MsgAlreadyDeclared,yyt^.TypeDecl.IdentDef^.IdentDef.Pos)
 END;
(* line 3310 "oberon.aecp" *)
IF ~( E.IsGenuineEmptyEntry(yyt^.TypeDecl.ForwardedEntry)                                                                 
     OR T.IsLegalPointerBaseType(yyt^.TypeDecl.Type^.Type.TypeReprOut)                                                       
  ) THEN  ERR.MsgPos(ERR.MsgWrongPointerBase,yyt^.TypeDecl.ForwardedPos)
 END;
yyt^.TypeDecl.VarAddrOut:=yyt^.TypeDecl.Next^.Decls.VarAddrOut;
(* line 899 "oberon.aecp" *)


  yyt^.TypeDecl.TableOut                      := yyt^.TypeDecl.Next^.Decls.TableOut;
| Tree.VarDecl:
yyt^.VarDecl.Next^.Decls.EnvIn:=yyt^.VarDecl.EnvIn;
yyVisit1 (yyt^.VarDecl.Type);
yyt^.VarDecl.Type^.Type.EnvIn:=yyt^.VarDecl.EnvIn;
yyt^.VarDecl.Type^.Type.TDescListIn:=yyt^.VarDecl.TDescListIn;
(* line 3095 "oberon.aecp" *)

  yyt^.VarDecl.Type^.Type.NamePathIn               := OB.mIdentNamePath(yyt^.VarDecl.NamePathIn,TT.IdentOfFirstVariable(yyt^.VarDecl.IdentLists));
yyt^.VarDecl.Type^.Type.LevelIn:=yyt^.VarDecl.LevelIn;
(* line 915 "oberon.aecp" *)
                                                                    
  yyt^.VarDecl.Type^.Type.IsVarParTypeIn           := FALSE;
(* line 914 "oberon.aecp" *)
                                                  
  yyt^.VarDecl.Type^.Type.OpenArrayIsOkIn          := FALSE;
(* line 913 "oberon.aecp" *)
              
  yyt^.VarDecl.Type^.Type.ForwardPBaseIsOkIn       := FALSE;
yyt^.VarDecl.IdentLists^.IdentLists.LevelIn:=yyt^.VarDecl.LevelIn;
(* line 909 "oberon.aecp" *)
                                                                     
  yyt^.VarDecl.IdentLists^.IdentLists.Table1In           := yyt^.VarDecl.TableIn;
yyt^.VarDecl.IdentLists^.IdentLists.ModuleIn:=yyt^.VarDecl.ModuleIn;
yyVisit1 (yyt^.VarDecl.IdentLists);
(* line 912 "oberon.aecp" *)
              

  yyt^.VarDecl.Type^.Type.TableIn                  := yyt^.VarDecl.IdentLists^.IdentLists.Table1Out;
yyt^.VarDecl.Type^.Type.ModuleIn:=yyt^.VarDecl.ModuleIn;
yyVisit2 (yyt^.VarDecl.Type);
yyt^.VarDecl.IdentLists^.IdentLists.EnvIn:=yyt^.VarDecl.EnvIn;
(* line 2603 "oberon.aecp" *)

  yyt^.VarDecl.IdentLists^.IdentLists.SizeIn             := 0;
(* line 2602 "oberon.aecp" *)

  yyt^.VarDecl.IdentLists^.IdentLists.VarAddrIn          := yyt^.VarDecl.VarAddrIn;
(* line 918 "oberon.aecp" *)

  yyt^.VarDecl.IdentLists^.IdentLists.TypeReprIn         := yyt^.VarDecl.Type^.Type.TypeReprOut;
(* line 917 "oberon.aecp" *)
                                                                     

  yyt^.VarDecl.IdentLists^.IdentLists.Table2In           := yyt^.VarDecl.IdentLists^.IdentLists.Table1Out;
(* line 910 "oberon.aecp" *)

  yyt^.VarDecl.IdentLists^.IdentLists.TooBigMsg          := ERR.MsgTooManyVars;
yyVisit2 (yyt^.VarDecl.IdentLists);
yyt^.VarDecl.Next^.Decls.TDescListIn:=yyt^.VarDecl.TDescListIn;
yyt^.VarDecl.Next^.Decls.NamePathIn:=yyt^.VarDecl.NamePathIn;
yyt^.VarDecl.Next^.Decls.LabelPrefixIn:=yyt^.VarDecl.LabelPrefixIn;
(* line 2604 "oberon.aecp" *)

  yyt^.VarDecl.Next^.Decls.VarAddrIn                := yyt^.VarDecl.IdentLists^.IdentLists.VarAddrOut;
yyt^.VarDecl.Next^.Decls.LevelIn:=yyt^.VarDecl.LevelIn;
(* line 920 "oberon.aecp" *)


  yyt^.VarDecl.Next^.Decls.TableIn                  := yyt^.VarDecl.IdentLists^.IdentLists.Table2Out;
yyt^.VarDecl.Next^.Decls.ModuleIn:=yyt^.VarDecl.ModuleIn;
yyVisit1 (yyt^.VarDecl.Next);
(* line 2605 "oberon.aecp" *)

  yyt^.VarDecl.VarAddrOut                    := yyt^.VarDecl.Next^.Decls.VarAddrOut;
(* line 922 "oberon.aecp" *)
              

  yyt^.VarDecl.TableOut                      := yyt^.VarDecl.Next^.Decls.TableOut;
| Tree.Procs:
(* line 3100 "oberon.aecp" *)

  yyt^.Procs.NamePath                      := OB.cmtNamePath;
yyt^.Procs.TableOut:=yyt^.Procs.TableIn;
| Tree.mtProc:
(* line 3100 "oberon.aecp" *)

  yyt^.mtProc.NamePath                      := OB.cmtNamePath;
yyt^.mtProc.TableOut:=yyt^.mtProc.TableIn;
| Tree.Proc:
yyt^.Proc.Next^.Procs.TDescListIn:=yyt^.Proc.TDescListIn;
yyt^.Proc.Next^.Procs.EnvIn:=yyt^.Proc.EnvIn;
yyt^.Proc.Next^.Procs.NamePathIn:=yyt^.Proc.NamePathIn;
yyt^.Proc.Next^.Procs.LabelPrefixIn:=yyt^.Proc.LabelPrefixIn;
yyt^.Proc.Next^.Procs.LevelIn:=yyt^.Proc.LevelIn;
yyt^.Proc.Next^.Procs.TableIn:=yyt^.Proc.TableIn;
yyt^.Proc.Next^.Procs.ModuleIn:=yyt^.Proc.ModuleIn;
yyVisit1 (yyt^.Proc.Next);
(* line 3100 "oberon.aecp" *)

  yyt^.Proc.NamePath                      := OB.cmtNamePath;
yyt^.Proc.TableOut:=yyt^.Proc.Next^.Procs.TableOut;
| Tree.ProcDecl:
(* line 3340 "oberon.aecp" *)
IF ~( (yyt^.ProcDecl.LevelIn<OB.MODULELEVEL+LIM.MaxProcedureNesting)
  ) THEN  ERR.MsgPos(ERR.MsgProcNestedTooDeeply,yyt^.ProcDecl.IdentDef^.IdentDef.Pos)
 END;
(* line 3027 "oberon.aecp" *)

  yyt^.ProcDecl.label                         := LAB.MakeGlobal
                                   ( (yyt^.ProcDecl.IdentDef^.IdentDef.ExportMode#OB.PRIVATE)
                                   , yyt^.ProcDecl.LabelPrefixIn
                                   , yyt^.ProcDecl.IdentDef^.IdentDef.Ident);
(* line 937 "oberon.aecp" *)

  yyt^.ProcDecl.AlreadyDeclEntry              := E.Lookup0(SYSTEM.VAL(OB.tOB,Base.ShowProcCount(yyt^.ProcDecl.TableIn)),yyt^.ProcDecl.IdentDef^.IdentDef.Ident);
(* line 938 "oberon.aecp" *)

  yyt^.ProcDecl.ForwardedProcEntry            := E.ForwardProcOnly(yyt^.ProcDecl.AlreadyDeclEntry);
(* line 3104 "oberon.aecp" *)

  yyt^.ProcDecl.NamePath                      := OB.mIdentNamePath(yyt^.ProcDecl.NamePathIn,yyt^.ProcDecl.IdentDef^.IdentDef.Ident);
(* line 942 "oberon.aecp" *)

  yyt^.ProcDecl.TableTmp                      := E.ChooseProcedureEntry
                                   ( yyt^.ProcDecl.TableIn
                                   , OB.mProcedureEntry
                                                                ( yyt^.ProcDecl.TableIn
                                                                , yyt^.ProcDecl.ModuleIn     
                                                                , yyt^.ProcDecl.IdentDef^.IdentDef.Ident
                                                                , yyt^.ProcDecl.IdentDef^.IdentDef.ExportMode
                                                                , yyt^.ProcDecl.LevelIn
                                                                , OB.TOBEDECLARED
                                                                , OB.cmtObject
                                                                , TRUE
                                                                , yyt^.ProcDecl.IdentDef^.IdentDef.Pos
                                                                , yyt^.ProcDecl.label
                                                                , yyt^.ProcDecl.NamePath
                                                                , NIL)
                                   , yyt^.ProcDecl.ForwardedProcEntry);
(* line 995 "oberon.aecp" *)


  yyt^.ProcDecl.Entry                         := E.Lookup0(yyt^.ProcDecl.TableTmp,yyt^.ProcDecl.IdentDef^.IdentDef.Ident);
(* line 3237 "oberon.aecp" *)

  yyt^.ProcDecl.env                           := OB.mEnvironment(NIL,OB.NOLEVELS);
(* line 3240 "oberon.aecp" *)

  yyt^.ProcDecl.Stmts^.Stmts.EnvIn                   := yyt^.ProcDecl.env;
(* line 3032 "oberon.aecp" *)

  yyt^.ProcDecl.Stmts^.Stmts.LoopEndLabelIn          := LAB.MT;
(* line 3239 "oberon.aecp" *)

  yyt^.ProcDecl.DeclSection^.DeclSection.EnvIn             := yyt^.ProcDecl.env;
yyt^.ProcDecl.DeclSection^.DeclSection.TDescListIn:=yyt^.ProcDecl.TDescListIn;
(* line 3105 "oberon.aecp" *)

  yyt^.ProcDecl.FormalPars^.FormalPars.NamePathIn         := OB.mSelectNamePath(yyt^.ProcDecl.NamePath);
(* line 3106 "oberon.aecp" *)

  yyt^.ProcDecl.DeclSection^.DeclSection.NamePathIn        := yyt^.ProcDecl.FormalPars^.FormalPars.NamePathIn;
(* line 3031 "oberon.aecp" *)

  yyt^.ProcDecl.DeclSection^.DeclSection.LabelPrefixIn     := LAB.App_Id(yyt^.ProcDecl.LabelPrefixIn,yyt^.ProcDecl.IdentDef^.IdentDef.Ident);
(* line 2543 "oberon.aecp" *)

  yyt^.ProcDecl.DeclSection^.DeclSection.LevelIn           := yyt^.ProcDecl.LevelIn+1;
(* line 2612 "oberon.aecp" *)

  yyt^.ProcDecl.DeclSection^.DeclSection.VarAddrIn         := ADR.LocalVarBase(yyt^.ProcDecl.DeclSection^.DeclSection.LevelIn);
(* line 3238 "oberon.aecp" *)
 
  yyt^.ProcDecl.FormalPars^.FormalPars.EnvIn              := yyt^.ProcDecl.env;
yyt^.ProcDecl.FormalPars^.FormalPars.TDescListIn:=yyt^.ProcDecl.TDescListIn;
(* line 2610 "oberon.aecp" *)

  yyt^.ProcDecl.FormalPars^.FormalPars.ParAddrIn          := ADR.ProcParBase;
(* line 2542 "oberon.aecp" *)

  yyt^.ProcDecl.FormalPars^.FormalPars.LevelIn            := yyt^.ProcDecl.LevelIn+1;
(* line 959 "oberon.aecp" *)


  yyt^.ProcDecl.FormalPars^.FormalPars.TableIn            := OB.mScopeEntry(yyt^.ProcDecl.TableTmp);
yyt^.ProcDecl.FormalPars^.FormalPars.ModuleIn:=yyt^.ProcDecl.ModuleIn;
yyVisit1 (yyt^.ProcDecl.FormalPars);
(* line 2611 "oberon.aecp" *)

  yyt^.ProcDecl.paramSpace                    := yyt^.ProcDecl.FormalPars^.FormalPars.ParAddrOut-ADR.ProcParBase;
(* line 961 "oberon.aecp" *)


  yyt^.ProcDecl.ProcTypeRepr                  := OB.mProcedureTypeRepr
                                   ( OB.cNonameEntry
                                   , OT.SIZEoPROCEDURE
                                   , OB.mTypeBlocklists(NIL,NIL)
                                   , FALSE
                                   , LAB.MT
                                   , yyt^.ProcDecl.FormalPars^.FormalPars.SignatureReprOut
                                   , yyt^.ProcDecl.FormalPars^.FormalPars.ResultTypeReprOut
                                   , yyt^.ProcDecl.paramSpace);
(* line 940 "oberon.aecp" *)

  yyt^.ProcDecl.IsUndeclared                  := E.IsErrorEntry(yyt^.ProcDecl.AlreadyDeclEntry)
                                OR E.IsForwardProcEntry(yyt^.ProcDecl.AlreadyDeclEntry);
(* line 971 "oberon.aecp" *)


  yyt^.ProcDecl.DeclSection^.DeclSection.TableIn           := E.DefineProcedureEntry
                                   ( yyt^.ProcDecl.FormalPars^.FormalPars.TableOut
                                   , yyt^.ProcDecl.TableTmp
                                   , yyt^.ProcDecl.ForwardedProcEntry
                                   , yyt^.ProcDecl.LevelIn
                                   , yyt^.ProcDecl.IdentDef^.IdentDef.Ident
                                   , yyt^.ProcDecl.IdentDef^.IdentDef.ExportMode
                                   , yyt^.ProcDecl.label
                                   , yyt^.ProcDecl.ProcTypeRepr
                                   , yyt^.ProcDecl.env);
yyt^.ProcDecl.DeclSection^.DeclSection.ModuleIn:=yyt^.ProcDecl.ModuleIn;
yyVisit1 (yyt^.ProcDecl.DeclSection);
(* line 2757 "oberon.aecp" *)

  yyt^.ProcDecl.Stmts^.Stmts.TempOfsIn               := -ADR.Align4(-yyt^.ProcDecl.DeclSection^.DeclSection.VarAddrOut);
(* line 2544 "oberon.aecp" *)

  yyt^.ProcDecl.Stmts^.Stmts.LevelIn                 := yyt^.ProcDecl.LevelIn+1;
(* line 989 "oberon.aecp" *)

  yyt^.ProcDecl.Stmts^.Stmts.ResultTypeReprIn        := yyt^.ProcDecl.FormalPars^.FormalPars.ResultTypeReprOut;
(* line 982 "oberon.aecp" *)
 yyt^.ProcDecl.Stmts^.Stmts.TableIn:=E.CheckUnresolvedForwardProcs
                                                    (yyt^.ProcDecl.DeclSection^.DeclSection.TableOut);                              
                                     IF ARG.OptionShowStmtTables & (FIL.NestingDepth<=1) THEN 
                                        OD.DumpTable0(E.IdentOfEntry(yyt^.ProcDecl.ModuleIn)
                                                       ,yyt^.ProcDecl.Stmts^.Stmts.TableIn,UTI.MakeString('PROCEDURE'),yyt^.ProcDecl.IdentDef^.IdentDef.Ident);
                                     END; (* IF *)
                                   
yyt^.ProcDecl.Stmts^.Stmts.ModuleIn:=yyt^.ProcDecl.ModuleIn;
yyVisit1 (yyt^.ProcDecl.Stmts);
yyt^.ProcDecl.IdentDef^.IdentDef.LevelIn:=yyt^.ProcDecl.LevelIn;
yyVisit1 (yyt^.ProcDecl.IdentDef);
yyt^.ProcDecl.Next^.Procs.EnvIn:=yyt^.ProcDecl.EnvIn;
yyt^.ProcDecl.Next^.Procs.TDescListIn:=yyt^.ProcDecl.TDescListIn;
yyt^.ProcDecl.Next^.Procs.NamePathIn:=yyt^.ProcDecl.NamePathIn;
yyt^.ProcDecl.Next^.Procs.LabelPrefixIn:=yyt^.ProcDecl.LabelPrefixIn;
yyt^.ProcDecl.Next^.Procs.LevelIn:=yyt^.ProcDecl.LevelIn;
(* line 991 "oberon.aecp" *)


  yyt^.ProcDecl.Next^.Procs.TableIn                  := yyt^.ProcDecl.TableTmp;
yyt^.ProcDecl.Next^.Procs.ModuleIn:=yyt^.ProcDecl.ModuleIn;
yyVisit1 (yyt^.ProcDecl.Next);
(* line 996 "oberon.aecp" *)

  yyt^.ProcDecl.Locals                        := yyt^.ProcDecl.DeclSection^.DeclSection.TableOut;
(* line 2759 "oberon.aecp" *)


  yyt^.ProcDecl.TempSpace                     := yyt^.ProcDecl.Stmts^.Stmts.TempOfsIn-yyt^.ProcDecl.Stmts^.Stmts.TempOfsOut;
(* line 2613 "oberon.aecp" *)

  yyt^.ProcDecl.LocalSpace                    := ADR.Align4(yyt^.ProcDecl.DeclSection^.DeclSection.VarAddrIn-yyt^.ProcDecl.DeclSection^.DeclSection.VarAddrOut);
(* line 3321 "oberon.aecp" *)
IF ~( yyt^.ProcDecl.IsUndeclared                                                                                       
  ) THEN  ERR.MsgPos(ERR.MsgAlreadyDeclared,yyt^.ProcDecl.IdentDef^.IdentDef.Pos)
 END;
(* line 3324 "oberon.aecp" *)
IF ~( T.HaveMatchingFormalPars                                                                         
        ( E.TypeOfEntry(yyt^.ProcDecl.ForwardedProcEntry)
        , yyt^.ProcDecl.ProcTypeRepr)
  ) THEN  ERR.MsgPos(ERR.MsgNonMatchingActualDecl,yyt^.ProcDecl.IdentDef^.IdentDef.Pos)
 END;
(* line 3329 "oberon.aecp" *)
IF ~( yyt^.ProcDecl.Stmts^.Stmts.ReturnExistsOut                                                                               
     OR TT.IsNoStmts(yyt^.ProcDecl.Stmts)
     OR T.IsGenuineEmptyType(yyt^.ProcDecl.FormalPars^.FormalPars.ResultTypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgMissingReturn,yyt^.ProcDecl.EndPos)
 END;
(* line 3334 "oberon.aecp" *)
IF ~( (yyt^.ProcDecl.IdentDef^.IdentDef.Ident=yyt^.ProcDecl.Ident)                                                                           
  ) THEN  ERR.MsgPos(ERR.MsgProcname2Incorrect,yyt^.ProcDecl.IdPos)
 END;
(* line 3337 "oberon.aecp" *)
IF ~( (yyt^.ProcDecl.IdentDef^.IdentDef.ExportMode#OB.READONLY)                                                                  
  ) THEN  ERR.MsgPos(ERR.MsgProcsAlwaysReadOnly,yyt^.ProcDecl.IdentDef^.IdentDef.Pos)
 END;
(* line 993 "oberon.aecp" *)


  yyt^.ProcDecl.TableOut                      := yyt^.ProcDecl.Next^.Procs.TableOut;
| Tree.ForwardDecl:
(* line 3353 "oberon.aecp" *)
IF ~( (yyt^.ForwardDecl.LevelIn<OB.MODULELEVEL+LIM.MaxProcedureNesting)
  ) THEN  ERR.MsgPos(ERR.MsgProcNestedTooDeeply,yyt^.ForwardDecl.IdentDef^.IdentDef.Pos)
 END;
yyt^.ForwardDecl.FormalPars^.FormalPars.EnvIn:=yyt^.ForwardDecl.EnvIn;
yyt^.ForwardDecl.FormalPars^.FormalPars.TDescListIn:=yyt^.ForwardDecl.TDescListIn;
(* line 3110 "oberon.aecp" *)

  yyt^.ForwardDecl.NamePath                      := OB.mIdentNamePath(yyt^.ForwardDecl.NamePathIn,yyt^.ForwardDecl.IdentDef^.IdentDef.Ident);
(* line 3111 "oberon.aecp" *)

  yyt^.ForwardDecl.FormalPars^.FormalPars.NamePathIn         := OB.mSelectNamePath(yyt^.ForwardDecl.NamePath);
(* line 2618 "oberon.aecp" *)

  yyt^.ForwardDecl.FormalPars^.FormalPars.ParAddrIn          := ADR.ProcParBase;
(* line 2548 "oberon.aecp" *)

  yyt^.ForwardDecl.FormalPars^.FormalPars.LevelIn            := yyt^.ForwardDecl.LevelIn+1;
(* line 3037 "oberon.aecp" *)

  yyt^.ForwardDecl.label                         := LAB.MakeGlobal
                                   ( (yyt^.ForwardDecl.IdentDef^.IdentDef.ExportMode#OB.PRIVATE)
                                   , yyt^.ForwardDecl.LabelPrefixIn
                                   , yyt^.ForwardDecl.IdentDef^.IdentDef.Ident);
(* line 1003 "oberon.aecp" *)

  yyt^.ForwardDecl.TableTmp                      := OB.mProcedureEntry
                                   ( yyt^.ForwardDecl.TableIn
                                   , yyt^.ForwardDecl.ModuleIn     
                                   , yyt^.ForwardDecl.IdentDef^.IdentDef.Ident
                                   , yyt^.ForwardDecl.IdentDef^.IdentDef.ExportMode
                                   , yyt^.ForwardDecl.LevelIn
                                   , OB.TOBEDECLARED
                                   , OB.cmtObject
                                   , FALSE
                                   , yyt^.ForwardDecl.IdentDef^.IdentDef.Pos
                                   , yyt^.ForwardDecl.label
                                   , yyt^.ForwardDecl.NamePath
                                   , NIL);
(* line 1017 "oberon.aecp" *)


  yyt^.ForwardDecl.FormalPars^.FormalPars.TableIn            := OB.mScopeEntry(yyt^.ForwardDecl.TableTmp);
yyt^.ForwardDecl.FormalPars^.FormalPars.ModuleIn:=yyt^.ForwardDecl.ModuleIn;
yyVisit1 (yyt^.ForwardDecl.FormalPars);
yyt^.ForwardDecl.IdentDef^.IdentDef.LevelIn:=yyt^.ForwardDecl.LevelIn;
yyVisit1 (yyt^.ForwardDecl.IdentDef);
yyt^.ForwardDecl.Next^.Procs.EnvIn:=yyt^.ForwardDecl.EnvIn;
yyt^.ForwardDecl.Next^.Procs.TDescListIn:=yyt^.ForwardDecl.TDescListIn;
yyt^.ForwardDecl.Next^.Procs.NamePathIn:=yyt^.ForwardDecl.NamePathIn;
yyt^.ForwardDecl.Next^.Procs.LabelPrefixIn:=yyt^.ForwardDecl.LabelPrefixIn;
yyt^.ForwardDecl.Next^.Procs.LevelIn:=yyt^.ForwardDecl.LevelIn;
(* line 2619 "oberon.aecp" *)

  yyt^.ForwardDecl.paramSpace                    := yyt^.ForwardDecl.FormalPars^.FormalPars.ParAddrOut-ADR.ProcParBase;
(* line 1019 "oberon.aecp" *)


  yyt^.ForwardDecl.Next^.Procs.TableIn                  := E.DefineProcedureEntry
                                   ( yyt^.ForwardDecl.TableTmp
                                   , yyt^.ForwardDecl.TableTmp
                                   , OB.cmtEntry
                                   , yyt^.ForwardDecl.LevelIn
                                   , yyt^.ForwardDecl.IdentDef^.IdentDef.Ident
                                   , yyt^.ForwardDecl.IdentDef^.IdentDef.ExportMode
                                   , yyt^.ForwardDecl.label
                                   , OB.mProcedureTypeRepr
                                                                ( OB.cNonameEntry
                                                                , OT.SIZEoPROCEDURE
                                                                , OB.mTypeBlocklists(NIL,NIL)
                                                                , FALSE
                                                                , LAB.MT
                                                                , yyt^.ForwardDecl.FormalPars^.FormalPars.SignatureReprOut
                                                                , yyt^.ForwardDecl.FormalPars^.FormalPars.ResultTypeReprOut
                                                                , yyt^.ForwardDecl.paramSpace)
                                   , NIL
                                   );
yyt^.ForwardDecl.Next^.Procs.ModuleIn:=yyt^.ForwardDecl.ModuleIn;
yyVisit1 (yyt^.ForwardDecl.Next);
(* line 3347 "oberon.aecp" *)
IF ~( E.IsUndeclared(yyt^.ForwardDecl.TableIn,yyt^.ForwardDecl.IdentDef^.IdentDef.Ident)                                                           
  ) THEN  ERR.MsgPos(ERR.MsgAlreadyDeclared,yyt^.ForwardDecl.IdentDef^.IdentDef.Pos)
 END;
(* line 3350 "oberon.aecp" *)
IF ~( (yyt^.ForwardDecl.IdentDef^.IdentDef.ExportMode#OB.READONLY)                                                                  
  ) THEN  ERR.MsgPos(ERR.MsgProcsAlwaysReadOnly,yyt^.ForwardDecl.IdentDef^.IdentDef.Pos)
 END;
(* line 1039 "oberon.aecp" *)


  yyt^.ForwardDecl.TableOut                      := yyt^.ForwardDecl.Next^.Procs.TableOut;
| Tree.BoundProcDecl:
(* line 3382 "oberon.aecp" *)
IF ~( (yyt^.BoundProcDecl.LevelIn<OB.MODULELEVEL+LIM.MaxProcedureNesting)
  ) THEN  ERR.MsgPos(ERR.MsgProcNestedTooDeeply,yyt^.BoundProcDecl.IdentDef^.IdentDef.Pos)
 END;
(* line 3244 "oberon.aecp" *)

  yyt^.BoundProcDecl.env                           := OB.mEnvironment(NIL,OB.NOLEVELS);
(* line 3245 "oberon.aecp" *)
 
  yyt^.BoundProcDecl.FormalPars^.FormalPars.EnvIn              := yyt^.BoundProcDecl.env;
yyt^.BoundProcDecl.FormalPars^.FormalPars.TDescListIn:=yyt^.BoundProcDecl.TDescListIn;
(* line 3115 "oberon.aecp" *)

  yyt^.BoundProcDecl.NamePath                      := OB.mIdentNamePath
                                   (OB.mSelectNamePath
                                    (OB.mIdentNamePath(yyt^.BoundProcDecl.NamePathIn,yyt^.BoundProcDecl.Receiver^.Receiver.TypeIdent))
                                   ,yyt^.BoundProcDecl.IdentDef^.IdentDef.Ident);
(* line 3119 "oberon.aecp" *)

  yyt^.BoundProcDecl.FormalPars^.FormalPars.NamePathIn         := OB.mSelectNamePath(yyt^.BoundProcDecl.NamePath);
(* line 2624 "oberon.aecp" *)

  yyt^.BoundProcDecl.Receiver^.Receiver.ParAddrIn            := ADR.ProcParBase;
(* line 2552 "oberon.aecp" *)

  yyt^.BoundProcDecl.Receiver^.Receiver.LevelIn              := yyt^.BoundProcDecl.LevelIn+1;
(* line 1050 "oberon.aecp" *)

  yyt^.BoundProcDecl.Receiver^.Receiver.TableIn              := OB.mScopeEntry(SYSTEM.VAL(OB.tOB,Base.ShowProcCount(yyt^.BoundProcDecl.TableIn)));
yyt^.BoundProcDecl.Receiver^.Receiver.ModuleIn:=yyt^.BoundProcDecl.ModuleIn;
yyVisit1 (yyt^.BoundProcDecl.Receiver);
(* line 2625 "oberon.aecp" *)

  yyt^.BoundProcDecl.FormalPars^.FormalPars.ParAddrIn          := yyt^.BoundProcDecl.Receiver^.Receiver.ParAddrOut;
(* line 2553 "oberon.aecp" *)

  yyt^.BoundProcDecl.FormalPars^.FormalPars.LevelIn            := yyt^.BoundProcDecl.LevelIn+1;
(* line 1054 "oberon.aecp" *)


  yyt^.BoundProcDecl.FormalPars^.FormalPars.TableIn            := yyt^.BoundProcDecl.Receiver^.Receiver.TableOut;
yyt^.BoundProcDecl.FormalPars^.FormalPars.ModuleIn:=yyt^.BoundProcDecl.ModuleIn;
yyVisit1 (yyt^.BoundProcDecl.FormalPars);
(* line 1052 "oberon.aecp" *)


  yyt^.BoundProcDecl.ReceiverTypeRepr              := T.ReceiverRecordTypeOfType(yyt^.BoundProcDecl.Receiver^.Receiver.TypeReprOut);
(* line 3046 "oberon.aecp" *)

  yyt^.BoundProcDecl.typeident                     := E.IdentOfEntry(T.EntryOfType(yyt^.BoundProcDecl.ReceiverTypeRepr));
(* line 3048 "oberon.aecp" *)
 

  yyt^.BoundProcDecl.label                         := LAB.MakeBound
                                   ( yyt^.BoundProcDecl.LabelPrefixIn
                                   , yyt^.BoundProcDecl.typeident
                                   , yyt^.BoundProcDecl.IdentDef^.IdentDef.Ident);
(* line 2626 "oberon.aecp" *)

  yyt^.BoundProcDecl.paramSpace                    := yyt^.BoundProcDecl.FormalPars^.FormalPars.ParAddrOut-ADR.ProcParBase;
(* line 1056 "oberon.aecp" *)


  yyt^.BoundProcDecl.ProcTypeRepr                  := OB.mProcedureTypeRepr
                                   ( OB.cNonameEntry
                                   , OT.SIZEoPROCEDURE
                                   , OB.mTypeBlocklists(NIL,NIL)
                                   , FALSE
                                   , LAB.MT
                                   , yyt^.BoundProcDecl.FormalPars^.FormalPars.SignatureReprOut
                                   , yyt^.BoundProcDecl.FormalPars^.FormalPars.ResultTypeReprOut
                                   , yyt^.BoundProcDecl.paramSpace);
(* line 1078 "oberon.aecp" *)


  yyt^.BoundProcDecl.CurrBProcEntry                := OB.mBoundProcEntry
                                   ( OB.cmtEntry
                                   , yyt^.BoundProcDecl.ModuleIn     
                                   , yyt^.BoundProcDecl.IdentDef^.IdentDef.Ident
                                   , yyt^.BoundProcDecl.IdentDef^.IdentDef.ExportMode
                                   , yyt^.BoundProcDecl.LevelIn
                                   , OB.DECLARED
                                   , yyt^.BoundProcDecl.Receiver^.Receiver.SignatureOut
                                   , yyt^.BoundProcDecl.ProcTypeRepr
                                   , TRUE
                                   , yyt^.BoundProcDecl.IdentDef^.IdentDef.Pos
                                   , yyt^.BoundProcDecl.label
                                   , yyt^.BoundProcDecl.NamePath
                                   , OB.cmtEntry
                                   , OB.NOPROCNUM
                                   , yyt^.BoundProcDecl.env);
(* line 1116 "oberon.aecp" *)


  yyt^.BoundProcDecl.Entry                         := yyt^.BoundProcDecl.CurrBProcEntry;
(* line 3247 "oberon.aecp" *)

  yyt^.BoundProcDecl.Stmts^.Stmts.EnvIn                   := yyt^.BoundProcDecl.env;
(* line 3054 "oberon.aecp" *)

  yyt^.BoundProcDecl.Stmts^.Stmts.LoopEndLabelIn          := LAB.MT;
(* line 3246 "oberon.aecp" *)

  yyt^.BoundProcDecl.DeclSection^.DeclSection.EnvIn             := yyt^.BoundProcDecl.env;
yyt^.BoundProcDecl.DeclSection^.DeclSection.TDescListIn:=yyt^.BoundProcDecl.TDescListIn;
(* line 3120 "oberon.aecp" *)

  yyt^.BoundProcDecl.DeclSection^.DeclSection.NamePathIn        := yyt^.BoundProcDecl.FormalPars^.FormalPars.NamePathIn;
(* line 3053 "oberon.aecp" *)


  yyt^.BoundProcDecl.DeclSection^.DeclSection.LabelPrefixIn     := yyt^.BoundProcDecl.label;
(* line 2554 "oberon.aecp" *)

  yyt^.BoundProcDecl.DeclSection^.DeclSection.LevelIn           := yyt^.BoundProcDecl.LevelIn+1;
(* line 2627 "oberon.aecp" *)

  yyt^.BoundProcDecl.DeclSection^.DeclSection.VarAddrIn         := ADR.LocalVarBase(yyt^.BoundProcDecl.DeclSection^.DeclSection.LevelIn);
(* line 1066 "oberon.aecp" *)


  yyt^.BoundProcDecl.AlreadyExistingField          := E.Lookup0
                                   (T.FieldsOfRecordType(yyt^.BoundProcDecl.ReceiverTypeRepr)
                                   ,yyt^.BoundProcDecl.IdentDef^.IdentDef.Ident);
(* line 1070 "oberon.aecp" *)

  yyt^.BoundProcDecl.ErrorMsg                      := T.CheckBoundProc
                                   ( yyt^.BoundProcDecl.ModuleIn     
                                   , yyt^.BoundProcDecl.AlreadyExistingField
                                   , yyt^.BoundProcDecl.ProcTypeRepr
                                   , FALSE
                                   , yyt^.BoundProcDecl.ReceiverTypeRepr
                                   , yyt^.BoundProcDecl.IdentDef^.IdentDef.Ident);
(* line 1095 "oberon.aecp" *)


  yyt^.BoundProcDecl.DeclSection^.DeclSection.TableIn           := T.BindProcedureToRecord
                                   ( yyt^.BoundProcDecl.ReceiverTypeRepr
                                   , yyt^.BoundProcDecl.CurrBProcEntry
                                   , yyt^.BoundProcDecl.FormalPars^.FormalPars.TableOut
                                   , yyt^.BoundProcDecl.AlreadyExistingField
                                   , yyt^.BoundProcDecl.IdentDef^.IdentDef.Pos
                                   , yyt^.BoundProcDecl.ModuleIn);
yyt^.BoundProcDecl.DeclSection^.DeclSection.ModuleIn:=yyt^.BoundProcDecl.ModuleIn;
yyVisit1 (yyt^.BoundProcDecl.DeclSection);
(* line 2763 "oberon.aecp" *)

  yyt^.BoundProcDecl.Stmts^.Stmts.TempOfsIn               := -ADR.Align4(-yyt^.BoundProcDecl.DeclSection^.DeclSection.VarAddrOut);
(* line 2555 "oberon.aecp" *)

  yyt^.BoundProcDecl.Stmts^.Stmts.LevelIn                 := yyt^.BoundProcDecl.LevelIn+1;
(* line 1110 "oberon.aecp" *)

  yyt^.BoundProcDecl.Stmts^.Stmts.ResultTypeReprIn        := yyt^.BoundProcDecl.FormalPars^.FormalPars.ResultTypeReprOut;
(* line 1103 "oberon.aecp" *)
 yyt^.BoundProcDecl.Stmts^.Stmts.TableIn:=E.CheckUnresolvedForwardProcs                      
                                                    (yyt^.BoundProcDecl.DeclSection^.DeclSection.TableOut);
                                     IF ARG.OptionShowStmtTables & (FIL.NestingDepth<=1) THEN 
                                        OD.DumpTable0(E.IdentOfEntry(yyt^.BoundProcDecl.ModuleIn)
                                                       ,yyt^.BoundProcDecl.Stmts^.Stmts.TableIn,UTI.MakeString('BOUND'),yyt^.BoundProcDecl.IdentDef^.IdentDef.Ident);
                                     END; (* IF *)
                                   
yyt^.BoundProcDecl.Stmts^.Stmts.ModuleIn:=yyt^.BoundProcDecl.ModuleIn;
yyVisit1 (yyt^.BoundProcDecl.Stmts);
yyt^.BoundProcDecl.IdentDef^.IdentDef.LevelIn:=yyt^.BoundProcDecl.LevelIn;
yyVisit1 (yyt^.BoundProcDecl.IdentDef);
yyt^.BoundProcDecl.Next^.Procs.EnvIn:=yyt^.BoundProcDecl.EnvIn;
yyt^.BoundProcDecl.Next^.Procs.TDescListIn:=yyt^.BoundProcDecl.TDescListIn;
yyt^.BoundProcDecl.Next^.Procs.NamePathIn:=yyt^.BoundProcDecl.NamePathIn;
yyt^.BoundProcDecl.Next^.Procs.LabelPrefixIn:=yyt^.BoundProcDecl.LabelPrefixIn;
yyt^.BoundProcDecl.Next^.Procs.LevelIn:=yyt^.BoundProcDecl.LevelIn;
(* line 1112 "oberon.aecp" *)


  yyt^.BoundProcDecl.Next^.Procs.TableIn                  := yyt^.BoundProcDecl.TableIn;
yyt^.BoundProcDecl.Next^.Procs.ModuleIn:=yyt^.BoundProcDecl.ModuleIn;
yyVisit1 (yyt^.BoundProcDecl.Next);
(* line 1117 "oberon.aecp" *)

  yyt^.BoundProcDecl.Locals                        := yyt^.BoundProcDecl.DeclSection^.DeclSection.TableOut;
(* line 2765 "oberon.aecp" *)


  yyt^.BoundProcDecl.TempSpace                     := yyt^.BoundProcDecl.Stmts^.Stmts.TempOfsIn-yyt^.BoundProcDecl.Stmts^.Stmts.TempOfsOut;
(* line 2628 "oberon.aecp" *)

  yyt^.BoundProcDecl.LocalSpace                    := ADR.Align4(yyt^.BoundProcDecl.DeclSection^.DeclSection.VarAddrIn-yyt^.BoundProcDecl.DeclSection^.DeclSection.VarAddrOut);
(* line 3360 "oberon.aecp" *)
IF ~( (yyt^.BoundProcDecl.LevelIn=OB.MODULELEVEL)                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgBoundProcMustBeGlobal,yyt^.BoundProcDecl.IdentDef^.IdentDef.Pos)
 END;
(* line 3363 "oberon.aecp" *)
IF ~( yyt^.BoundProcDecl.Stmts^.Stmts.ReturnExistsOut                                                                               
     OR TT.IsNoStmts(yyt^.BoundProcDecl.Stmts)
     OR T.IsGenuineEmptyType(yyt^.BoundProcDecl.FormalPars^.FormalPars.ResultTypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgMissingReturn,yyt^.BoundProcDecl.EndPos)
 END;
(* line 3368 "oberon.aecp" *)
IF ~( (yyt^.BoundProcDecl.IdentDef^.IdentDef.Ident=yyt^.BoundProcDecl.Ident)                                                                           
  ) THEN  ERR.MsgPos(ERR.MsgProcname2Incorrect,yyt^.BoundProcDecl.IdPos)
 END;
(* line 3371 "oberon.aecp" *)
IF ~( (yyt^.BoundProcDecl.IdentDef^.IdentDef.ExportMode#OB.READONLY)                                                                  
  ) THEN  ERR.MsgPos(ERR.MsgProcsAlwaysReadOnly,yyt^.BoundProcDecl.IdentDef^.IdentDef.Pos)
 END;
(* line 3374 "oberon.aecp" *)
IF ~( (yyt^.BoundProcDecl.ErrorMsg=ERR.NoErrorMsg)                                       
  ) THEN  ERR.MsgPos(yyt^.BoundProcDecl.ErrorMsg,yyt^.BoundProcDecl.IdentDef^.IdentDef.Pos)
 END;
(* line 3377 "oberon.aecp" *)
IF ~( (yyt^.BoundProcDecl.IdentDef^.IdentDef.ExportMode#OB.PRIVATE)                                                              
     OR ~E.IsExportedInheritedProc(yyt^.BoundProcDecl.AlreadyExistingField)
     OR ~E.IsExportedEntry(T.EntryOfType(yyt^.BoundProcDecl.Receiver^.Receiver.TypeReprOut))
  ) THEN  ERR.MsgPos(ERR.MsgRedefMustBeExported,yyt^.BoundProcDecl.IdentDef^.IdentDef.Pos)
 END;
(* line 1114 "oberon.aecp" *)


  yyt^.BoundProcDecl.TableOut                      := yyt^.BoundProcDecl.Next^.Procs.TableOut;
| Tree.BoundForwardDecl:
(* line 3403 "oberon.aecp" *)
IF ~( (yyt^.BoundForwardDecl.LevelIn<OB.MODULELEVEL+LIM.MaxProcedureNesting)
  ) THEN  ERR.MsgPos(ERR.MsgProcNestedTooDeeply,yyt^.BoundForwardDecl.IdentDef^.IdentDef.Pos)
 END;
yyt^.BoundForwardDecl.FormalPars^.FormalPars.EnvIn:=yyt^.BoundForwardDecl.EnvIn;
yyt^.BoundForwardDecl.FormalPars^.FormalPars.TDescListIn:=yyt^.BoundForwardDecl.TDescListIn;
(* line 3124 "oberon.aecp" *)

  yyt^.BoundForwardDecl.NamePath                      := OB.mIdentNamePath(yyt^.BoundForwardDecl.NamePathIn,yyt^.BoundForwardDecl.IdentDef^.IdentDef.Ident);
(* line 3125 "oberon.aecp" *)

  yyt^.BoundForwardDecl.FormalPars^.FormalPars.NamePathIn         := OB.mSelectNamePath(yyt^.BoundForwardDecl.NamePath);
(* line 2633 "oberon.aecp" *)

  yyt^.BoundForwardDecl.Receiver^.Receiver.ParAddrIn            := ADR.ProcParBase;
(* line 2559 "oberon.aecp" *)

  yyt^.BoundForwardDecl.Receiver^.Receiver.LevelIn              := yyt^.BoundForwardDecl.LevelIn+1;
(* line 1127 "oberon.aecp" *)

  yyt^.BoundForwardDecl.Receiver^.Receiver.TableIn              := OB.mScopeEntry(yyt^.BoundForwardDecl.TableIn);
yyt^.BoundForwardDecl.Receiver^.Receiver.ModuleIn:=yyt^.BoundForwardDecl.ModuleIn;
yyVisit1 (yyt^.BoundForwardDecl.Receiver);
(* line 2634 "oberon.aecp" *)

  yyt^.BoundForwardDecl.FormalPars^.FormalPars.ParAddrIn          := yyt^.BoundForwardDecl.Receiver^.Receiver.ParAddrOut;
(* line 2560 "oberon.aecp" *)

  yyt^.BoundForwardDecl.FormalPars^.FormalPars.LevelIn            := yyt^.BoundForwardDecl.LevelIn+1;
(* line 1131 "oberon.aecp" *)


  yyt^.BoundForwardDecl.FormalPars^.FormalPars.TableIn            := yyt^.BoundForwardDecl.Receiver^.Receiver.TableOut;
yyt^.BoundForwardDecl.FormalPars^.FormalPars.ModuleIn:=yyt^.BoundForwardDecl.ModuleIn;
yyVisit1 (yyt^.BoundForwardDecl.FormalPars);
yyt^.BoundForwardDecl.IdentDef^.IdentDef.LevelIn:=yyt^.BoundForwardDecl.LevelIn;
yyVisit1 (yyt^.BoundForwardDecl.IdentDef);
yyt^.BoundForwardDecl.Next^.Procs.EnvIn:=yyt^.BoundForwardDecl.EnvIn;
yyt^.BoundForwardDecl.Next^.Procs.TDescListIn:=yyt^.BoundForwardDecl.TDescListIn;
yyt^.BoundForwardDecl.Next^.Procs.NamePathIn:=yyt^.BoundForwardDecl.NamePathIn;
yyt^.BoundForwardDecl.Next^.Procs.LabelPrefixIn:=yyt^.BoundForwardDecl.LabelPrefixIn;
yyt^.BoundForwardDecl.Next^.Procs.LevelIn:=yyt^.BoundForwardDecl.LevelIn;
(* line 1129 "oberon.aecp" *)


  yyt^.BoundForwardDecl.ReceiverTypeRepr              := T.ReceiverRecordTypeOfType(yyt^.BoundForwardDecl.Receiver^.Receiver.TypeReprOut);
(* line 3059 "oberon.aecp" *)

  yyt^.BoundForwardDecl.label                         := LAB.MakeBound
                                   ( yyt^.BoundForwardDecl.LabelPrefixIn
                                   , E.IdentOfEntry(T.EntryOfType(yyt^.BoundForwardDecl.ReceiverTypeRepr))
                                   , yyt^.BoundForwardDecl.IdentDef^.IdentDef.Ident);
(* line 2635 "oberon.aecp" *)

  yyt^.BoundForwardDecl.paramSpace                    := yyt^.BoundForwardDecl.FormalPars^.FormalPars.ParAddrOut-ADR.ProcParBase;
(* line 1143 "oberon.aecp" *)


  yyt^.BoundForwardDecl.AlreadyExistingField          := E.Lookup0
                                   (T.FieldsOfRecordType(yyt^.BoundForwardDecl.ReceiverTypeRepr)
                                   ,yyt^.BoundForwardDecl.IdentDef^.IdentDef.Ident);
(* line 1133 "oberon.aecp" *)


  yyt^.BoundForwardDecl.ProcTypeRepr                  := OB.mProcedureTypeRepr
                                   ( OB.cNonameEntry
                                   , OT.SIZEoPROCEDURE
                                   , OB.mTypeBlocklists(NIL,NIL)
                                   , FALSE
                                   , LAB.MT
                                   , yyt^.BoundForwardDecl.FormalPars^.FormalPars.SignatureReprOut
                                   , yyt^.BoundForwardDecl.FormalPars^.FormalPars.ResultTypeReprOut
                                   , yyt^.BoundForwardDecl.paramSpace);
(* line 1147 "oberon.aecp" *)

  yyt^.BoundForwardDecl.ErrorMsg                      := T.CheckBoundProc
                                   ( yyt^.BoundForwardDecl.ModuleIn     
                                   , yyt^.BoundForwardDecl.AlreadyExistingField
                                   , yyt^.BoundForwardDecl.ProcTypeRepr
                                   , TRUE
                                   , yyt^.BoundForwardDecl.ReceiverTypeRepr
                                   , yyt^.BoundForwardDecl.IdentDef^.IdentDef.Ident);
(* line 1155 "oberon.aecp" *)


  yyt^.BoundForwardDecl.Next^.Procs.TableIn                  := T.BindProcedureToRecord
                                   ( yyt^.BoundForwardDecl.ReceiverTypeRepr
                                   , OB.mBoundProcEntry
                                                                ( OB.cmtEntry
                                                                , yyt^.BoundForwardDecl.ModuleIn     
                                                                , yyt^.BoundForwardDecl.IdentDef^.IdentDef.Ident
                                                                , yyt^.BoundForwardDecl.IdentDef^.IdentDef.ExportMode
                                                                , yyt^.BoundForwardDecl.LevelIn
                                                                , OB.DECLARED
                                                                , yyt^.BoundForwardDecl.Receiver^.Receiver.SignatureOut
                                                                , yyt^.BoundForwardDecl.ProcTypeRepr
                                                                , FALSE
                                                                , yyt^.BoundForwardDecl.IdentDef^.IdentDef.Pos                             
                                                                , yyt^.BoundForwardDecl.label
                                                                , yyt^.BoundForwardDecl.NamePath
                                                                , OB.cmtEntry
                                                                , OB.NOPROCNUM
                                                                , NIL)
                                   , yyt^.BoundForwardDecl.TableIn
                                   , OB.cmtEntry
                                   , yyt^.BoundForwardDecl.IdentDef^.IdentDef.Pos
                                   , yyt^.BoundForwardDecl.ModuleIn);
yyt^.BoundForwardDecl.Next^.Procs.ModuleIn:=yyt^.BoundForwardDecl.ModuleIn;
yyVisit1 (yyt^.BoundForwardDecl.Next);
(* line 3389 "oberon.aecp" *)
IF ~( (yyt^.BoundForwardDecl.LevelIn=OB.MODULELEVEL)                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgBoundProcMustBeGlobal,yyt^.BoundForwardDecl.IdentDef^.IdentDef.Pos)
 END;
(* line 3392 "oberon.aecp" *)
IF ~( (yyt^.BoundForwardDecl.IdentDef^.IdentDef.ExportMode#OB.READONLY)                                                                  
  ) THEN  ERR.MsgPos(ERR.MsgProcsAlwaysReadOnly,yyt^.BoundForwardDecl.IdentDef^.IdentDef.Pos)
 END;
(* line 3395 "oberon.aecp" *)
IF ~( (yyt^.BoundForwardDecl.ErrorMsg=ERR.NoErrorMsg)                                       
  ) THEN  ERR.MsgPos(yyt^.BoundForwardDecl.ErrorMsg,yyt^.BoundForwardDecl.IdentDef^.IdentDef.Pos)
 END;
(* line 3398 "oberon.aecp" *)
IF ~( (yyt^.BoundForwardDecl.IdentDef^.IdentDef.ExportMode#OB.PRIVATE)                                                              
     OR ~E.IsExportedInheritedProc(yyt^.BoundForwardDecl.AlreadyExistingField)
     OR ~E.IsExportedEntry(T.EntryOfType(yyt^.BoundForwardDecl.Receiver^.Receiver.TypeReprOut))
  ) THEN  ERR.MsgPos(ERR.MsgRedefMustBeExported,yyt^.BoundForwardDecl.IdentDef^.IdentDef.Pos)
 END;
(* line 1178 "oberon.aecp" *)


  yyt^.BoundForwardDecl.TableOut                      := yyt^.BoundForwardDecl.Next^.Procs.TableOut;
| Tree.FormalPars:
yyVisit1 (yyt^.FormalPars.Type);
yyt^.FormalPars.Type^.Type.EnvIn:=yyt^.FormalPars.EnvIn;
yyt^.FormalPars.Type^.Type.TDescListIn:=yyt^.FormalPars.TDescListIn;
yyt^.FormalPars.Type^.Type.NamePathIn:=yyt^.FormalPars.NamePathIn;
yyt^.FormalPars.Type^.Type.LevelIn:=yyt^.FormalPars.LevelIn;
(* line 1192 "oberon.aecp" *)
                                                                    
  yyt^.FormalPars.Type^.Type.IsVarParTypeIn           := FALSE;
(* line 1191 "oberon.aecp" *)
                                                  
  yyt^.FormalPars.Type^.Type.OpenArrayIsOkIn          := FALSE;
(* line 1190 "oberon.aecp" *)

  yyt^.FormalPars.Type^.Type.ForwardPBaseIsOkIn       := FALSE;
(* line 1189 "oberon.aecp" *)


  yyt^.FormalPars.Type^.Type.TableIn                  := yyt^.FormalPars.TableIn;
yyt^.FormalPars.Type^.Type.ModuleIn:=yyt^.FormalPars.ModuleIn;
yyVisit2 (yyt^.FormalPars.Type);
(* line 3410 "oberon.aecp" *)
IF ~( T.IsLegalResultType(yyt^.FormalPars.Type^.Type.TypeReprOut)                                                                  
  ) THEN  ERR.MsgPos(ERR.MsgIllegalFunctionResult,yyt^.FormalPars.Type^.Type.Position)
 END;
yyt^.FormalPars.FPSections^.FPSections.EnvIn:=yyt^.FormalPars.EnvIn;
yyt^.FormalPars.FPSections^.FPSections.TDescListIn:=yyt^.FormalPars.TDescListIn;
yyt^.FormalPars.FPSections^.FPSections.NamePathIn:=yyt^.FormalPars.NamePathIn;
yyt^.FormalPars.FPSections^.FPSections.ParAddrIn:=yyt^.FormalPars.ParAddrIn;
yyt^.FormalPars.FPSections^.FPSections.LevelIn:=yyt^.FormalPars.LevelIn;
(* line 1187 "oberon.aecp" *)

  yyt^.FormalPars.FPSections^.FPSections.TableIn            := yyt^.FormalPars.TableIn;
yyt^.FormalPars.FPSections^.FPSections.ModuleIn:=yyt^.FormalPars.ModuleIn;
yyVisit1 (yyt^.FormalPars.FPSections);
yyt^.FormalPars.ParAddrOut:=yyt^.FormalPars.FPSections^.FPSections.ParAddrOut;
(* line 1195 "oberon.aecp" *)

  yyt^.FormalPars.ResultTypeReprOut             := yyt^.FormalPars.Type^.Type.TypeReprOut;
(* line 1194 "oberon.aecp" *)
                                                                     

  yyt^.FormalPars.SignatureReprOut              := yyt^.FormalPars.FPSections^.FPSections.SignatureReprOut;
(* line 1196 "oberon.aecp" *)

  yyt^.FormalPars.TableOut                      := yyt^.FormalPars.FPSections^.FPSections.TableOut;
| Tree.FPSections:
yyt^.FPSections.ParAddrOut:=yyt^.FPSections.ParAddrIn;
(* line 1204 "oberon.aecp" *)

  yyt^.FPSections.SignatureReprOut              := OB.cmtSignature;
yyt^.FPSections.TableOut:=yyt^.FPSections.TableIn;
| Tree.mtFPSection:
yyt^.mtFPSection.ParAddrOut:=yyt^.mtFPSection.ParAddrIn;
(* line 1204 "oberon.aecp" *)

  yyt^.mtFPSection.SignatureReprOut              := OB.cmtSignature;
yyt^.mtFPSection.TableOut:=yyt^.mtFPSection.TableIn;
| Tree.FPSection:
yyt^.FPSection.Next^.FPSections.ModuleIn:=yyt^.FPSection.ModuleIn;
yyVisit1 (yyt^.FPSection.Type);
yyt^.FPSection.Type^.Type.EnvIn:=yyt^.FPSection.EnvIn;
yyt^.FPSection.Type^.Type.TDescListIn:=yyt^.FPSection.TDescListIn;
(* line 3129 "oberon.aecp" *)

  yyt^.FPSection.Type^.Type.NamePathIn               := OB.mIdentNamePath(yyt^.FPSection.NamePathIn,TT.IdentOfFirstParameter(yyt^.FPSection.ParIds));
yyt^.FPSection.Type^.Type.LevelIn:=yyt^.FPSection.LevelIn;
(* line 1219 "oberon.aecp" *)
                                                                     
  yyt^.FPSection.Type^.Type.IsVarParTypeIn           := (yyt^.FPSection.ParMode=OB.REFPAR);
(* line 1218 "oberon.aecp" *)
                                                  
  yyt^.FPSection.Type^.Type.OpenArrayIsOkIn          := TRUE;
(* line 1217 "oberon.aecp" *)
                  
  yyt^.FPSection.Type^.Type.ForwardPBaseIsOkIn       := FALSE;
yyt^.FPSection.ParIds^.ParIds.LevelIn:=yyt^.FPSection.LevelIn;
(* line 1214 "oberon.aecp" *)

  yyt^.FPSection.ParIds^.ParIds.ParModeIn              := yyt^.FPSection.ParMode;
(* line 1213 "oberon.aecp" *)
                                                                     
  yyt^.FPSection.ParIds^.ParIds.Table1In               := yyt^.FPSection.TableIn;
yyt^.FPSection.ParIds^.ParIds.ModuleIn:=yyt^.FPSection.ModuleIn;
yyVisit1 (yyt^.FPSection.ParIds);
(* line 1216 "oberon.aecp" *)


  yyt^.FPSection.Type^.Type.TableIn                  := yyt^.FPSection.ParIds^.ParIds.Table1Out;
yyt^.FPSection.Type^.Type.ModuleIn:=yyt^.FPSection.ModuleIn;
yyVisit2 (yyt^.FPSection.Type);
(* line 2647 "oberon.aecp" *)

  yyt^.FPSection.ParIds^.ParIds.ParAddrIn              := yyt^.FPSection.ParAddrIn;
(* line 1222 "oberon.aecp" *)

  yyt^.FPSection.ParIds^.ParIds.Table2In               := yyt^.FPSection.ParIds^.ParIds.Table1Out;
(* line 1221 "oberon.aecp" *)
                                                     

  yyt^.FPSection.ParIds^.ParIds.TypeReprIn             := yyt^.FPSection.Type^.Type.TypeReprOut;
yyVisit2 (yyt^.FPSection.ParIds);
yyt^.FPSection.ParIds^.ParIds.EnvIn:=yyt^.FPSection.EnvIn;
yyt^.FPSection.Next^.FPSections.EnvIn:=yyt^.FPSection.EnvIn;
yyt^.FPSection.Next^.FPSections.TDescListIn:=yyt^.FPSection.TDescListIn;
yyt^.FPSection.Next^.FPSections.NamePathIn:=yyt^.FPSection.NamePathIn;
(* line 2648 "oberon.aecp" *)

  yyt^.FPSection.Next^.FPSections.ParAddrIn                := yyt^.FPSection.ParIds^.ParIds.ParAddrOut;
yyt^.FPSection.Next^.FPSections.LevelIn:=yyt^.FPSection.LevelIn;
(* line 1225 "oberon.aecp" *)


  yyt^.FPSection.Next^.FPSections.TableIn                  := yyt^.FPSection.ParIds^.ParIds.Table2Out;
yyVisit1 (yyt^.FPSection.Next);
(* line 1223 "oberon.aecp" *)

  yyt^.FPSection.ParIds^.ParIds.SignatureReprIn        := yyt^.FPSection.Next^.FPSections.SignatureReprOut;
yyVisit3 (yyt^.FPSection.ParIds);
(* line 2649 "oberon.aecp" *)

  yyt^.FPSection.ParAddrOut                    := yyt^.FPSection.Next^.FPSections.ParAddrOut;
(* line 1228 "oberon.aecp" *)

  yyt^.FPSection.SignatureReprOut              := yyt^.FPSection.ParIds^.ParIds.SignatureReprOut;
(* line 1227 "oberon.aecp" *)
                  

  yyt^.FPSection.TableOut                      := yyt^.FPSection.Next^.FPSections.TableOut;
| Tree.ParIds:
yyt^.ParIds.Table1Out:=yyt^.ParIds.Table1In;
| Tree.mtParId:
yyt^.mtParId.Table1Out:=yyt^.mtParId.Table1In;
| Tree.ParId:
(* line 3417 "oberon.aecp" *)
IF ~( E.IsUndeclared(yyt^.ParId.Table1In,yyt^.ParId.Ident)
  ) THEN  ERR.MsgPos(ERR.MsgAlreadyDeclared,yyt^.ParId.Pos)
 END;
yyt^.ParId.Next^.ParIds.LevelIn:=yyt^.ParId.LevelIn;
yyt^.ParId.Next^.ParIds.ParModeIn:=yyt^.ParId.ParModeIn;
(* line 1243 "oberon.aecp" *)

  
  yyt^.ParId.Next^.ParIds.Table1In                 := OB.mVarEntry
                                   ( yyt^.ParId.Table1In
                                   , yyt^.ParId.ModuleIn
                                   , yyt^.ParId.Ident
                                   , OB.PRIVATE
                                   , yyt^.ParId.LevelIn
                                   , OB.TOBEDECLARED
                                   , OB.cmtObject
                                   , TRUE
                                   , FALSE
                                   , yyt^.ParId.ParModeIn
                                   , 0
                                   , yyt^.ParId.ParModeIn
                                   , FALSE
                                   , FALSE);
yyt^.ParId.Next^.ParIds.ModuleIn:=yyt^.ParId.ModuleIn;
yyVisit1 (yyt^.ParId.Next);
(* line 1259 "oberon.aecp" *)


  yyt^.ParId.Table1Out                     := yyt^.ParId.Next^.ParIds.Table1Out;
| Tree.Receiver:
(* line 1305 "oberon.aecp" *)


  yyt^.Receiver.Entry                         := E.Lookup(yyt^.Receiver.TableIn,yyt^.Receiver.TypeIdent);
(* line 1306 "oberon.aecp" *)

  yyt^.Receiver.EntryTypeRepr                 := E.TypeOfTypeEntry(yyt^.Receiver.Entry);
(* line 3430 "oberon.aecp" *)
IF ~( (yyt^.Receiver.ParMode=OB.REFPAR) & T.IsRecordType         (yyt^.Receiver.EntryTypeRepr)                                       
     OR                         T.IsPointerToRecordType(yyt^.Receiver.EntryTypeRepr)
  ) THEN  ERR.MsgPos(ERR.MsgInvalidType,yyt^.Receiver.TypePos)
 END;
(* line 2678 "oberon.aecp" *)
 ADR.NextParAddr
                                     ( yyt^.Receiver.ParMode
                                     , yyt^.Receiver.EntryTypeRepr
                                     , yyt^.Receiver.ParAddrIn
                                     , yyt^.Receiver.AddrOfPar
                                     , yyt^.Receiver.RefMode
                                     , yyt^.Receiver.ParAddrOut);
                                   
(* line 1289 "oberon.aecp" *)

  yyt^.Receiver.TableTmp                      := OB.mVarEntry
                                   ( yyt^.Receiver.TableIn
                                   , yyt^.Receiver.ModuleIn
                                   , yyt^.Receiver.Name
                                   , OB.PRIVATE
                                   , yyt^.Receiver.LevelIn
                                   , OB.TOBEDECLARED
                                   , OB.cmtObject
                                   , TRUE
                                   , TRUE
                                   , yyt^.Receiver.ParMode
                                   , yyt^.Receiver.AddrOfPar
                                   , OB.REFPAR
                                   , FALSE
                                   , FALSE);
(* line 1308 "oberon.aecp" *)


  yyt^.Receiver.TypeReprOut                   := T.LegalReceiverTypeOnly(yyt^.Receiver.EntryTypeRepr);
(* line 1309 "oberon.aecp" *)

  yyt^.Receiver.TableOut                      := E.DefineVarEntry
                                   ( yyt^.Receiver.TableTmp
                                   , yyt^.Receiver.TableTmp
                                   , yyt^.Receiver.LevelIn
                                   , yyt^.Receiver.Name
                                   , yyt^.Receiver.TypeReprOut
                                   , yyt^.Receiver.AddrOfPar
                                   , yyt^.Receiver.ParMode);
(* line 1317 "oberon.aecp" *)

  yyt^.Receiver.SignatureOut                  := OB.mSignature
                                   ( OB.cmtObject
                                   , yyt^.Receiver.TableOut);
(* line 3424 "oberon.aecp" *)
IF ~( (E.DeclStatusOfEntry(yyt^.Receiver.Entry)=OB.DECLARED)                                                        
  ) THEN  ERR.MsgPos(ERR.MsgUndeclaredIdent,yyt^.Receiver.TypePos)
 END;
(* line 3427 "oberon.aecp" *)
IF ~( E.IsTypeEntry(yyt^.Receiver.Entry)                                                                                 
  ) THEN  ERR.MsgPos(ERR.MsgTypeExpected,yyt^.Receiver.TypePos)
 END;
| Tree.Type:
(* line 1332 "oberon.aecp" *)

  yyt^.Type.FirstTypeReprOut              := OB.cmtTypeRepr;
| Tree.mtType:
(* line 1332 "oberon.aecp" *)

  yyt^.mtType.FirstTypeReprOut              := OB.cmtTypeRepr;
| Tree.NamedType:
(* line 1332 "oberon.aecp" *)

  yyt^.NamedType.FirstTypeReprOut              := OB.cmtTypeRepr;
| Tree.ArrayType:
(* line 1349 "oberon.aecp" *)

  yyt^.ArrayType.FirstTypeReprOut              := OB.mArrayTypeRepr
                                   ( OB.cNonameEntry
                                   , 0
                                   , OB.mTypeBlocklists(NIL,NIL)
                                   , FALSE
                                   , LAB.MT
                                   , 0
                                   , OB.cmtTypeRepr);
| Tree.OpenArrayType:
(* line 1374 "oberon.aecp" *)

  yyt^.OpenArrayType.FirstTypeReprOut              := OB.mArrayTypeRepr
                                   ( OB.cNonameEntry
                                   , 0
                                   , OB.mTypeBlocklists(NIL,NIL)
                                   , FALSE
                                   , LAB.MT
                                   , OB.OPENARRAYLEN
                                   , OB.cmtTypeRepr);
| Tree.RecordType:
(* line 1481 "oberon.aecp" *)

  yyt^.RecordType.FirstTypeReprOut              := OB.mRecordTypeRepr
                                   ( OB.cNonameEntry
                                   , 0
                                   , OB.mTypeBlocklists(NIL,NIL)
                                   , FALSE
                                   , LAB.MT
                                   , 0
                                   , OB.cmtObject
                                   , OB.cmtTypeReprList
                                   , OB.cmtEntry
                                   , 0);
| Tree.ExtendedType:
(* line 1509 "oberon.aecp" *)

  yyt^.ExtendedType.FirstTypeReprOut              := OB.mRecordTypeRepr
                                   ( OB.cNonameEntry
                                   , 0
                                   , OB.mTypeBlocklists(NIL,NIL)
                                   , FALSE
                                   , LAB.MT
                                   , 0
                                   , OB.cmtObject
                                   , OB.cmtTypeReprList
                                   , OB.cmtEntry
                                   , 0);
| Tree.PointerType:
(* line 1397 "oberon.aecp" *)

  yyt^.PointerType.FirstTypeReprOut              := OB.mPointerTypeRepr
                                   ( OB.cNonameEntry
                                   , OT.SIZEoPOINTER
                                   , OB.mTypeBlocklists(NIL,NIL)
                                   , FALSE
                                   , LAB.MT
                                   , OB.cNonameEntry);
| Tree.PointerToIdType:
(* line 1397 "oberon.aecp" *)

  yyt^.PointerToIdType.FirstTypeReprOut              := OB.mPointerTypeRepr
                                   ( OB.cNonameEntry
                                   , OT.SIZEoPOINTER
                                   , OB.mTypeBlocklists(NIL,NIL)
                                   , FALSE
                                   , LAB.MT
                                   , OB.cNonameEntry);
| Tree.PointerToQualIdType:
(* line 1397 "oberon.aecp" *)

  yyt^.PointerToQualIdType.FirstTypeReprOut              := OB.mPointerTypeRepr
                                   ( OB.cNonameEntry
                                   , OT.SIZEoPOINTER
                                   , OB.mTypeBlocklists(NIL,NIL)
                                   , FALSE
                                   , LAB.MT
                                   , OB.cNonameEntry);
| Tree.PointerToStructType:
(* line 1397 "oberon.aecp" *)

  yyt^.PointerToStructType.FirstTypeReprOut              := OB.mPointerTypeRepr
                                   ( OB.cNonameEntry
                                   , OT.SIZEoPOINTER
                                   , OB.mTypeBlocklists(NIL,NIL)
                                   , FALSE
                                   , LAB.MT
                                   , OB.cNonameEntry);
| Tree.ProcedureType:
(* line 1458 "oberon.aecp" *)

  yyt^.ProcedureType.FirstTypeReprOut              := OB.mProcedureTypeRepr
                                   ( OB.cNonameEntry
                                   , OT.SIZEoPROCEDURE
                                   , OB.mTypeBlocklists(NIL,NIL)
                                   , FALSE
                                   , LAB.MT
                                   , OB.cmtSignature
                                   , OB.cmtTypeRepr
                                   , 0);
| Tree.ArrayExprLists:
(* line 1546 "oberon.aecp" *)

  yyt^.ArrayExprLists.TypeReprOut                   := OB.cmtObject;
| Tree.mtArrayExprList:
(* line 1551 "oberon.aecp" *)

  yyt^.mtArrayExprList.TypeReprOut                   := yyt^.mtArrayExprList.ElemTypeReprIn;
| Tree.ArrayExprList:
yyt^.ArrayExprList.Next^.ArrayExprLists.ModuleIn:=yyt^.ArrayExprList.ModuleIn;
yyt^.ArrayExprList.ConstExpr^.ConstExpr.EnvIn:=yyt^.ArrayExprList.EnvIn;
yyt^.ArrayExprList.ConstExpr^.ConstExpr.LevelIn:=yyt^.ArrayExprList.LevelIn;
(* line 1561 "oberon.aecp" *)


  yyt^.ArrayExprList.ConstExpr^.ConstExpr.TableIn             := yyt^.ArrayExprList.TableIn;
yyt^.ArrayExprList.ConstExpr^.ConstExpr.ModuleIn:=yyt^.ArrayExprList.ModuleIn;
yyVisit1 (yyt^.ArrayExprList.ConstExpr);
yyt^.ArrayExprList.Next^.ArrayExprLists.EnvIn:=yyt^.ArrayExprList.EnvIn;
yyt^.ArrayExprList.Next^.ArrayExprLists.LevelIn:=yyt^.ArrayExprList.LevelIn;
yyt^.ArrayExprList.Next^.ArrayExprLists.ElemTypeReprIn:=yyt^.ArrayExprList.ElemTypeReprIn;
(* line 1559 "oberon.aecp" *)

  yyt^.ArrayExprList.Next^.ArrayExprLists.TableIn                  := yyt^.ArrayExprList.TableIn;
yyVisit1 (yyt^.ArrayExprList.Next);
(* line 1564 "oberon.aecp" *)

  yyt^.ArrayExprList.ElemSize                      := T.SizeOfType(yyt^.ArrayExprList.Next^.ArrayExprLists.TypeReprOut);
(* line 1563 "oberon.aecp" *)


  yyt^.ArrayExprList.Len                           := V.ValueOfInteger(yyt^.ArrayExprList.ConstExpr^.ConstExpr.ValueReprOut);
(* line 1565 "oberon.aecp" *)

  yyt^.ArrayExprList.TypeSize                      := OT.NewArrayTypeSize                                      
                                   ( yyt^.ArrayExprList.Len
                                   , yyt^.ArrayExprList.ElemSize);
(* line 3500 "oberon.aecp" *)
IF ~(  (yyt^.ArrayExprList.TypeSize <= OT.MaxObjectSize)                                                                        
     OR ~(yyt^.ArrayExprList.ElemSize <= OT.MaxObjectSize)
  ) THEN  ERR.MsgPos(ERR.MsgObjectTooBig,yyt^.ArrayExprList.ConstExpr^.ConstExpr.Position)
 END;
(* line 3494 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.ArrayExprList.ConstExpr^.ConstExpr.TypeReprOut)                                                                  
  ) THEN  ERR.MsgPos(ERR.MsgConstantNotInteger,yyt^.ArrayExprList.ConstExpr^.ConstExpr.Position)
 END;
(* line 3497 "oberon.aecp" *)
IF ~( V.IsGreaterZeroInteger(yyt^.ArrayExprList.ConstExpr^.ConstExpr.ValueReprOut)                                                          
  ) THEN  ERR.MsgPos(ERR.MsgInvalidArrayLen,yyt^.ArrayExprList.ConstExpr^.ConstExpr.Position)
 END;
(* line 1569 "oberon.aecp" *)


  yyt^.ArrayExprList.TypeReprOut                   := OB.mArrayTypeRepr
                                   ( OB.cNonameEntry
                                   , yyt^.ArrayExprList.TypeSize
                                   , OB.mTypeBlocklists(NIL,NIL)
                                   , FALSE
                                   , LAB.MT
                                   , yyt^.ArrayExprList.Len
                                   , yyt^.ArrayExprList.Next^.ArrayExprLists.TypeReprOut);
| Tree.FieldLists:
yyt^.FieldLists.SizeOut:=yyt^.FieldLists.SizeIn;
yyt^.FieldLists.FieldTableOut:=yyt^.FieldLists.FieldTableIn;
| Tree.mtFieldList:
yyt^.mtFieldList.SizeOut:=yyt^.mtFieldList.SizeIn;
yyt^.mtFieldList.FieldTableOut:=yyt^.mtFieldList.FieldTableIn;
| Tree.FieldList:
yyt^.FieldList.Next^.FieldLists.ModuleIn:=yyt^.FieldList.ModuleIn;
yyVisit1 (yyt^.FieldList.Type);
yyt^.FieldList.Type^.Type.EnvIn:=yyt^.FieldList.EnvIn;
yyt^.FieldList.Type^.Type.TDescListIn:=yyt^.FieldList.TDescListIn;
(* line 3149 "oberon.aecp" *)

  yyt^.FieldList.Type^.Type.NamePathIn               := OB.mIdentNamePath(yyt^.FieldList.NamePathIn,TT.IdentOfFirstVariable(yyt^.FieldList.IdentLists));
yyt^.FieldList.Type^.Type.LevelIn:=yyt^.FieldList.LevelIn;
(* line 1591 "oberon.aecp" *)
                                                                    
  yyt^.FieldList.Type^.Type.IsVarParTypeIn           := FALSE;
(* line 1590 "oberon.aecp" *)
                                                  
  yyt^.FieldList.Type^.Type.OpenArrayIsOkIn          := FALSE;
(* line 1589 "oberon.aecp" *)

  yyt^.FieldList.Type^.Type.ForwardPBaseIsOkIn       := FALSE;
yyt^.FieldList.IdentLists^.IdentLists.LevelIn:=yyt^.FieldList.LevelIn;
(* line 1585 "oberon.aecp" *)

  yyt^.FieldList.IdentLists^.IdentLists.Table1In           := yyt^.FieldList.FieldTableIn;
yyt^.FieldList.IdentLists^.IdentLists.ModuleIn:=yyt^.FieldList.ModuleIn;
yyVisit1 (yyt^.FieldList.IdentLists);
(* line 1588 "oberon.aecp" *)


  yyt^.FieldList.Type^.Type.TableIn                  := yyt^.FieldList.IdentLists^.IdentLists.Table1Out;
yyt^.FieldList.Type^.Type.ModuleIn:=yyt^.FieldList.ModuleIn;
yyVisit2 (yyt^.FieldList.Type);
yyt^.FieldList.IdentLists^.IdentLists.EnvIn:=yyt^.FieldList.EnvIn;
(* line 2708 "oberon.aecp" *)

  yyt^.FieldList.IdentLists^.IdentLists.SizeIn             := yyt^.FieldList.SizeIn;
(* line 2707 "oberon.aecp" *)

  yyt^.FieldList.IdentLists^.IdentLists.VarAddrIn          := yyt^.FieldList.SizeIn;
(* line 1594 "oberon.aecp" *)

  yyt^.FieldList.IdentLists^.IdentLists.TypeReprIn         := yyt^.FieldList.Type^.Type.TypeReprOut;
(* line 1593 "oberon.aecp" *)
                                                                     

  yyt^.FieldList.IdentLists^.IdentLists.Table2In           := yyt^.FieldList.IdentLists^.IdentLists.Table1Out;
(* line 1586 "oberon.aecp" *)

  yyt^.FieldList.IdentLists^.IdentLists.TooBigMsg          := ERR.MsgObjectTooBig;
yyVisit2 (yyt^.FieldList.IdentLists);
yyt^.FieldList.Next^.FieldLists.EnvIn:=yyt^.FieldList.EnvIn;
yyt^.FieldList.Next^.FieldLists.TDescListIn:=yyt^.FieldList.TDescListIn;
yyt^.FieldList.Next^.FieldLists.NamePathIn:=yyt^.FieldList.NamePathIn;
(* line 2709 "oberon.aecp" *)

  yyt^.FieldList.Next^.FieldLists.SizeIn                   := yyt^.FieldList.IdentLists^.IdentLists.SizeOut;
yyt^.FieldList.Next^.FieldLists.LevelIn:=yyt^.FieldList.LevelIn;
(* line 1596 "oberon.aecp" *)


  yyt^.FieldList.Next^.FieldLists.FieldTableIn             := yyt^.FieldList.IdentLists^.IdentLists.Table2Out;
yyVisit1 (yyt^.FieldList.Next);
(* line 2710 "oberon.aecp" *)

  yyt^.FieldList.SizeOut                       := yyt^.FieldList.Next^.FieldLists.SizeOut;
(* line 1598 "oberon.aecp" *)


  yyt^.FieldList.FieldTableOut                 := yyt^.FieldList.Next^.FieldLists.FieldTableOut;
| Tree.IdentLists:
yyt^.IdentLists.Table1Out:=yyt^.IdentLists.Table1In;
| Tree.mtIdentList:
yyt^.mtIdentList.Table1Out:=yyt^.mtIdentList.Table1In;
| Tree.IdentList:
yyt^.IdentList.Next^.IdentLists.LevelIn:=yyt^.IdentList.LevelIn;
(* line 1615 "oberon.aecp" *)


  yyt^.IdentList.Next^.IdentLists.Table1In                 := OB.mVarEntry
                                   ( yyt^.IdentList.Table1In
                                   , yyt^.IdentList.ModuleIn
                                   , yyt^.IdentList.IdentDef^.IdentDef.Ident
                                   , yyt^.IdentList.IdentDef^.IdentDef.ExportMode
                                   , yyt^.IdentList.LevelIn
                                   , OB.TOBEDECLARED
                                   , OB.cmtObject
                                   , FALSE
                                   , FALSE
                                   , OB.VALPAR
                                   , 0
                                   , OB.VALPAR
                                   , FALSE
                                   , FALSE);
yyt^.IdentList.Next^.IdentLists.ModuleIn:=yyt^.IdentList.ModuleIn;
yyVisit1 (yyt^.IdentList.Next);
(* line 1631 "oberon.aecp" *)


  yyt^.IdentList.Table1Out                     := yyt^.IdentList.Next^.IdentLists.Table1Out;
| Tree.Qualidents:
(* line 1651 "oberon.aecp" *)


  yyt^.Qualidents.EntryOut                      := OB.cmtObject;
| Tree.mtQualident:
(* line 1656 "oberon.aecp" *)

  yyt^.mtQualident.EntryOut                      := OB.cErrorEntry;
| Tree.ErrorQualident:
(* line 1651 "oberon.aecp" *)


  yyt^.ErrorQualident.EntryOut                      := OB.cmtObject;
| Tree.UnqualifiedIdent:
(* line 1661 "oberon.aecp" *)

  yyt^.UnqualifiedIdent.EntryOut                      := E.Lookup(yyt^.UnqualifiedIdent.TableIn,yyt^.UnqualifiedIdent.Ident);
(* line 3521 "oberon.aecp" *)
IF ~( (E.DeclStatusOfEntry(yyt^.UnqualifiedIdent.EntryOut)#OB.UNDECLARED)                                                   
  ) THEN  ERR.MsgPos(ERR.MsgUndeclaredIdent,yyt^.UnqualifiedIdent.Position)
 END;
(* line 2477 "oberon.aecp" *)
IF ~( superfluous_application_due_to_warning_suppression ( yyt^.UnqualifiedIdent.ModuleIn      ) ) THEN  
 END;
| Tree.QualifiedIdent:
(* line 1667 "oberon.aecp" *)

  yyt^.QualifiedIdent.ServerEntry                   := E.Lookup(yyt^.QualifiedIdent.TableIn,yyt^.QualifiedIdent.ServerId);
(* line 3533 "oberon.aecp" *)

  yyt^.QualifiedIdent.isServerEntry    := E.IsServerEntry(yyt^.QualifiedIdent.ServerEntry);
(* line 3532 "oberon.aecp" *)

  yyt^.QualifiedIdent.isDeclared       := (E.DeclStatusOfEntry(yyt^.QualifiedIdent.ServerEntry)=OB.DECLARED);
(* line 3531 "oberon.aecp" *)

  yyt^.QualifiedIdent.isExistingServer := E.ServerHasExistingTable(yyt^.QualifiedIdent.ServerEntry);
(* line 1668 "oberon.aecp" *)

  yyt^.QualifiedIdent.EntryOut                      := E.LookupExtern(yyt^.QualifiedIdent.ServerEntry,yyt^.QualifiedIdent.Ident);
(* line 3547 "oberon.aecp" *)
IF ~( ~yyt^.QualifiedIdent.isExistingServer                                                                                    
     OR ~yyt^.QualifiedIdent.isDeclared
     OR ~yyt^.QualifiedIdent.isServerEntry
     OR  E.IsExportedEntry(yyt^.QualifiedIdent.EntryOut)
  ) THEN  ERR.MsgPos(ERR.MsgIdentNotExported,yyt^.QualifiedIdent.IdentPos)
 END;
(* line 2481 "oberon.aecp" *)
IF ~( superfluous_application_due_to_warning_suppression ( yyt^.QualifiedIdent.ModuleIn      ) ) THEN  
 END;
(* line 3535 "oberon.aecp" *)
IF ~( yyt^.QualifiedIdent.isDeclared                                                                                          
  ) THEN  ERR.MsgPos(ERR.MsgUndeclaredIdent,yyt^.QualifiedIdent.Position)
 END;
(* line 3538 "oberon.aecp" *)
IF ~( yyt^.QualifiedIdent.isServerEntry                                                                                        
  ) THEN  ERR.MsgPos(ERR.MsgIdentIsNoModule,yyt^.QualifiedIdent.Position)
 END;
(* line 3541 "oberon.aecp" *)
IF ~( ~yyt^.QualifiedIdent.isExistingServer                                                                                   
     OR ~yyt^.QualifiedIdent.isDeclared
     OR ~yyt^.QualifiedIdent.isServerEntry
     OR  (E.DeclStatusOfEntry(yyt^.QualifiedIdent.EntryOut)=OB.DECLARED)
  ) THEN  ERR.MsgPos(ERR.MsgUndeclaredExternIdent,yyt^.QualifiedIdent.IdentPos)
 END;
| Tree.IdentDef:
(* line 3557 "oberon.aecp" *)
IF ~( (yyt^.IdentDef.ExportMode=OB.PRIVATE)                                                                              
     OR (yyt^.IdentDef.LevelIn<=OB.MODULELEVEL)
  ) THEN  ERR.MsgPos(ERR.MsgIllegalLocalExport,yyt^.IdentDef.Pos)
 END;
| Tree.Stmts:
yyt^.Stmts.TempOfsOut:=yyt^.Stmts.TempOfsIn;
(* line 1674 "oberon.aecp" *)

  yyt^.Stmts.ReturnExistsOut               := FALSE;
| Tree.mtStmt:
yyt^.mtStmt.TempOfsOut:=yyt^.mtStmt.TempOfsIn;
(* line 1674 "oberon.aecp" *)

  yyt^.mtStmt.ReturnExistsOut               := FALSE;
| Tree.NoStmts:
yyt^.NoStmts.TempOfsOut:=yyt^.NoStmts.TempOfsIn;
(* line 1674 "oberon.aecp" *)

  yyt^.NoStmts.ReturnExistsOut               := FALSE;
| Tree.Stmt:
yyt^.Stmt.Next^.Stmts.ModuleIn:=yyt^.Stmt.ModuleIn;
yyt^.Stmt.Next^.Stmts.EnvIn:=yyt^.Stmt.EnvIn;
yyt^.Stmt.Next^.Stmts.LoopEndLabelIn:=yyt^.Stmt.LoopEndLabelIn;
yyt^.Stmt.Next^.Stmts.TempOfsIn:=yyt^.Stmt.TempOfsIn;
yyt^.Stmt.Next^.Stmts.LevelIn:=yyt^.Stmt.LevelIn;
yyt^.Stmt.Next^.Stmts.ResultTypeReprIn:=yyt^.Stmt.ResultTypeReprIn;
yyt^.Stmt.Next^.Stmts.TableIn:=yyt^.Stmt.TableIn;
yyVisit1 (yyt^.Stmt.Next);
yyt^.Stmt.TempOfsOut:=yyt^.Stmt.Next^.Stmts.TempOfsOut;
(* line 1680 "oberon.aecp" *)

  yyt^.Stmt.ReturnExistsOut               := yyt^.Stmt.Next^.Stmts.ReturnExistsOut;
| Tree.AssignStmt:
yyt^.AssignStmt.Designator^.Designator.LevelIn:=yyt^.AssignStmt.LevelIn;
yyt^.AssignStmt.Exprs^.Exprs.EnvIn:=yyt^.AssignStmt.EnvIn;
(* line 2770 "oberon.aecp" *)
 
  yyt^.AssignStmt.Exprs^.Exprs.TempOfsIn               := yyt^.AssignStmt.TempOfsIn;
yyt^.AssignStmt.Exprs^.Exprs.LevelIn:=yyt^.AssignStmt.LevelIn;
(* line 1690 "oberon.aecp" *)


  yyt^.AssignStmt.Exprs^.Exprs.ValDontCareIn           := FALSE;
yyt^.AssignStmt.Exprs^.Exprs.TableIn:=yyt^.AssignStmt.TableIn;
yyt^.AssignStmt.Exprs^.Exprs.ModuleIn:=yyt^.AssignStmt.ModuleIn;
yyVisit1 (yyt^.AssignStmt.Exprs);
yyt^.AssignStmt.Designator^.Designator.EnvIn:=yyt^.AssignStmt.EnvIn;
(* line 2769 "oberon.aecp" *)

  yyt^.AssignStmt.Designator^.Designator.TempOfsIn          := yyt^.AssignStmt.TempOfsIn;
(* line 1688 "oberon.aecp" *)
                                                                      
  yyt^.AssignStmt.Designator^.Designator.IsCallDesignatorIn := FALSE;
(* line 1687 "oberon.aecp" *)

  yyt^.AssignStmt.Designator^.Designator.ValDontCareIn      := FALSE;
yyt^.AssignStmt.Designator^.Designator.TableIn:=yyt^.AssignStmt.TableIn;
yyt^.AssignStmt.Designator^.Designator.ModuleIn:=yyt^.AssignStmt.ModuleIn;
yyVisit1 (yyt^.AssignStmt.Designator);
(* line 1692 "oberon.aecp" *)
                                                                      

  yyt^.AssignStmt.VarTypeRepr                   := yyt^.AssignStmt.Designator^.Designator.TypeReprOut;
(* line 3571 "oberon.aecp" *)
IF ~( T.IsAssignmentCompatible                                                                     
        ( yyt^.AssignStmt.VarTypeRepr
        , yyt^.AssignStmt.Exprs^.Exprs.TypeReprOut
        , yyt^.AssignStmt.Exprs^.Exprs.ValueReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgNotAssignCompatible,yyt^.AssignStmt.Exprs^.Exprs.Position)
 END;
(* line 1693 "oberon.aecp" *)

  yyt^.AssignStmt.Coerce                        := CO.GetCoercion
                                   ( yyt^.AssignStmt.Exprs^.Exprs.TypeReprOut
                                   , yyt^.AssignStmt.VarTypeRepr);
yyt^.AssignStmt.Next^.Stmts.EnvIn:=yyt^.AssignStmt.EnvIn;
yyt^.AssignStmt.Next^.Stmts.LoopEndLabelIn:=yyt^.AssignStmt.LoopEndLabelIn;
(* line 2771 "oberon.aecp" *)
 
  yyt^.AssignStmt.Next^.Stmts.TempOfsIn                := yyt^.AssignStmt.TempOfsIn;
yyt^.AssignStmt.Next^.Stmts.LevelIn:=yyt^.AssignStmt.LevelIn;
yyt^.AssignStmt.Next^.Stmts.ResultTypeReprIn:=yyt^.AssignStmt.ResultTypeReprIn;
yyt^.AssignStmt.Next^.Stmts.TableIn:=yyt^.AssignStmt.TableIn;
yyt^.AssignStmt.Next^.Stmts.ModuleIn:=yyt^.AssignStmt.ModuleIn;
yyVisit1 (yyt^.AssignStmt.Next);
 CO.DoRealCoercion(yyt^.AssignStmt.Coerce,yyt^.AssignStmt.Exprs^.Exprs.ValueReprOut,yyt^.AssignStmt.Exprs^.Exprs.TypeReprOut);
 V.AdjustNilValue(yyt^.AssignStmt.Exprs^.Exprs.ValueReprOut,yyt^.AssignStmt.VarTypeRepr      ,yyt^.AssignStmt.Exprs^.Exprs.ValueReprOut);
 E.SetLaccess(yyt^.AssignStmt.Designator^.Designator.MainEntryOut);
(* line 3565 "oberon.aecp" *)
IF ~( E.IsVarEntry(yyt^.AssignStmt.Designator^.Designator.EntryOut)                                                                
  ) THEN  ERR.MsgPos(ERR.MsgLValueExpected,yyt^.AssignStmt.Designator^.Designator.Position)
 END;
(* line 3568 "oberon.aecp" *)
IF ~( yyt^.AssignStmt.Designator^.Designator.IsWritableOut                                                                        
  ) THEN  ERR.MsgPos(ERR.MsgObjectIsReadonly,yyt^.AssignStmt.Designator^.Designator.Position)
 END;
(* line 2773 "oberon.aecp" *)
 

  yyt^.AssignStmt.TempOfsOut                    := ADR.MinSize3(yyt^.AssignStmt.Designator^.Designator.TempOfsOut,yyt^.AssignStmt.Exprs^.Exprs.TempOfsOut,yyt^.AssignStmt.Next^.Stmts.TempOfsOut);
(* line 1680 "oberon.aecp" *)

  yyt^.AssignStmt.ReturnExistsOut               := yyt^.AssignStmt.Next^.Stmts.ReturnExistsOut;
| Tree.CallStmt:
yyt^.CallStmt.Designator^.Designator.LevelIn:=yyt^.CallStmt.LevelIn;
yyt^.CallStmt.Designator^.Designator.EnvIn:=yyt^.CallStmt.EnvIn;
(* line 2777 "oberon.aecp" *)

  yyt^.CallStmt.Designator^.Designator.TempOfsIn          := yyt^.CallStmt.TempOfsIn;
(* line 1704 "oberon.aecp" *)
                                                                      
  yyt^.CallStmt.Designator^.Designator.IsCallDesignatorIn := TRUE;
(* line 1703 "oberon.aecp" *)

  yyt^.CallStmt.Designator^.Designator.ValDontCareIn      := FALSE;
yyt^.CallStmt.Designator^.Designator.TableIn:=yyt^.CallStmt.TableIn;
yyt^.CallStmt.Designator^.Designator.ModuleIn:=yyt^.CallStmt.ModuleIn;
yyVisit1 (yyt^.CallStmt.Designator);
(* line 3581 "oberon.aecp" *)
IF ~( T.IsEmptyType(yyt^.CallStmt.Designator^.Designator.TypeReprOut)                                                               
  ) THEN  ERR.MsgPos(ERR.MsgProcedureExpected,yyt^.CallStmt.Designator^.Designator.Position)
 END;
yyt^.CallStmt.Next^.Stmts.EnvIn:=yyt^.CallStmt.EnvIn;
yyt^.CallStmt.Next^.Stmts.LoopEndLabelIn:=yyt^.CallStmt.LoopEndLabelIn;
(* line 2778 "oberon.aecp" *)
 
  yyt^.CallStmt.Next^.Stmts.TempOfsIn                := yyt^.CallStmt.TempOfsIn;
yyt^.CallStmt.Next^.Stmts.LevelIn:=yyt^.CallStmt.LevelIn;
yyt^.CallStmt.Next^.Stmts.ResultTypeReprIn:=yyt^.CallStmt.ResultTypeReprIn;
yyt^.CallStmt.Next^.Stmts.TableIn:=yyt^.CallStmt.TableIn;
yyt^.CallStmt.Next^.Stmts.ModuleIn:=yyt^.CallStmt.ModuleIn;
yyVisit1 (yyt^.CallStmt.Next);
 E.InclEnvLevel(yyt^.CallStmt.EnvIn,E.LevelOfProcEntry(yyt^.CallStmt.Designator^.Designator.EntryOut));
(* line 2780 "oberon.aecp" *)
 

  yyt^.CallStmt.TempOfsOut                    := ADR.MinSize2(yyt^.CallStmt.Designator^.Designator.TempOfsOut,yyt^.CallStmt.Next^.Stmts.TempOfsOut);
(* line 1680 "oberon.aecp" *)

  yyt^.CallStmt.ReturnExistsOut               := yyt^.CallStmt.Next^.Stmts.ReturnExistsOut;
| Tree.IfStmt:
yyt^.IfStmt.Exprs^.Exprs.ModuleIn:=yyt^.IfStmt.ModuleIn;
yyt^.IfStmt.Exprs^.Exprs.EnvIn:=yyt^.IfStmt.EnvIn;
(* line 2784 "oberon.aecp" *)

  yyt^.IfStmt.Exprs^.Exprs.TempOfsIn               := yyt^.IfStmt.TempOfsIn;
yyt^.IfStmt.Exprs^.Exprs.LevelIn:=yyt^.IfStmt.LevelIn;
(* line 1710 "oberon.aecp" *)

  yyt^.IfStmt.Exprs^.Exprs.ValDontCareIn           := FALSE;
yyt^.IfStmt.Exprs^.Exprs.TableIn:=yyt^.IfStmt.TableIn;
yyVisit1 (yyt^.IfStmt.Exprs);
(* line 3588 "oberon.aecp" *)
IF ~( T.IsBooleanType(yyt^.IfStmt.Exprs^.Exprs.TypeReprOut)                                                                   
  ) THEN  ERR.MsgPos(ERR.MsgInvalidExprType,yyt^.IfStmt.Exprs^.Exprs.Position)
 END;
yyt^.IfStmt.Else^.Stmts.EnvIn:=yyt^.IfStmt.EnvIn;
yyt^.IfStmt.Else^.Stmts.LoopEndLabelIn:=yyt^.IfStmt.LoopEndLabelIn;
(* line 2786 "oberon.aecp" *)
 
  yyt^.IfStmt.Else^.Stmts.TempOfsIn                := yyt^.IfStmt.TempOfsIn;
yyt^.IfStmt.Else^.Stmts.LevelIn:=yyt^.IfStmt.LevelIn;
yyt^.IfStmt.Else^.Stmts.ResultTypeReprIn:=yyt^.IfStmt.ResultTypeReprIn;
yyt^.IfStmt.Else^.Stmts.TableIn:=yyt^.IfStmt.TableIn;
yyt^.IfStmt.Else^.Stmts.ModuleIn:=yyt^.IfStmt.ModuleIn;
yyVisit1 (yyt^.IfStmt.Else);
yyt^.IfStmt.Then^.Stmts.EnvIn:=yyt^.IfStmt.EnvIn;
yyt^.IfStmt.Then^.Stmts.LoopEndLabelIn:=yyt^.IfStmt.LoopEndLabelIn;
(* line 2785 "oberon.aecp" *)
 
  yyt^.IfStmt.Then^.Stmts.TempOfsIn                := yyt^.IfStmt.TempOfsIn;
yyt^.IfStmt.Then^.Stmts.LevelIn:=yyt^.IfStmt.LevelIn;
yyt^.IfStmt.Then^.Stmts.ResultTypeReprIn:=yyt^.IfStmt.ResultTypeReprIn;
yyt^.IfStmt.Then^.Stmts.TableIn:=yyt^.IfStmt.TableIn;
yyt^.IfStmt.Then^.Stmts.ModuleIn:=yyt^.IfStmt.ModuleIn;
yyVisit1 (yyt^.IfStmt.Then);
yyt^.IfStmt.Next^.Stmts.EnvIn:=yyt^.IfStmt.EnvIn;
yyt^.IfStmt.Next^.Stmts.LoopEndLabelIn:=yyt^.IfStmt.LoopEndLabelIn;
(* line 2787 "oberon.aecp" *)
 
  yyt^.IfStmt.Next^.Stmts.TempOfsIn                := yyt^.IfStmt.TempOfsIn;
yyt^.IfStmt.Next^.Stmts.LevelIn:=yyt^.IfStmt.LevelIn;
yyt^.IfStmt.Next^.Stmts.ResultTypeReprIn:=yyt^.IfStmt.ResultTypeReprIn;
yyt^.IfStmt.Next^.Stmts.TableIn:=yyt^.IfStmt.TableIn;
yyt^.IfStmt.Next^.Stmts.ModuleIn:=yyt^.IfStmt.ModuleIn;
yyVisit1 (yyt^.IfStmt.Next);
(* line 2789 "oberon.aecp" *)
 

  yyt^.IfStmt.TempOfsOut                    := ADR.MinSize4(yyt^.IfStmt.Exprs^.Exprs.TempOfsOut,yyt^.IfStmt.Then^.Stmts.TempOfsOut,yyt^.IfStmt.Else^.Stmts.TempOfsOut,yyt^.IfStmt.Next^.Stmts.TempOfsOut);
(* line 1712 "oberon.aecp" *)
                                                                      

  yyt^.IfStmt.ReturnExistsOut               := yyt^.IfStmt.Next^.Stmts.ReturnExistsOut
                                OR yyt^.IfStmt.Then^.Stmts.ReturnExistsOut
                                OR yyt^.IfStmt.Else^.Stmts.ReturnExistsOut;
| Tree.CaseStmt:
yyt^.CaseStmt.Exprs^.Exprs.ModuleIn:=yyt^.CaseStmt.ModuleIn;
yyt^.CaseStmt.Exprs^.Exprs.EnvIn:=yyt^.CaseStmt.EnvIn;
(* line 2793 "oberon.aecp" *)

  yyt^.CaseStmt.Exprs^.Exprs.TempOfsIn               := yyt^.CaseStmt.TempOfsIn;
yyt^.CaseStmt.Exprs^.Exprs.LevelIn:=yyt^.CaseStmt.LevelIn;
(* line 1720 "oberon.aecp" *)

  yyt^.CaseStmt.Exprs^.Exprs.ValDontCareIn           := FALSE;
yyt^.CaseStmt.Exprs^.Exprs.TableIn:=yyt^.CaseStmt.TableIn;
yyVisit1 (yyt^.CaseStmt.Exprs);
(* line 3602 "oberon.aecp" *)
IF ~( T.IsCharType(yyt^.CaseStmt.Exprs^.Exprs.TypeReprOut)                                                                    
     OR T.IsIntegerType(yyt^.CaseStmt.Exprs^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgIllegalCaseExpr,yyt^.CaseStmt.Exprs^.Exprs.Position)
 END;
yyt^.CaseStmt.Cases^.Cases.EnvIn:=yyt^.CaseStmt.EnvIn;
yyt^.CaseStmt.Cases^.Cases.LoopEndLabelIn:=yyt^.CaseStmt.LoopEndLabelIn;
(* line 2794 "oberon.aecp" *)
 
  yyt^.CaseStmt.Cases^.Cases.TempOfsIn               := yyt^.CaseStmt.TempOfsIn;
yyt^.CaseStmt.Cases^.Cases.LevelIn:=yyt^.CaseStmt.LevelIn;
(* line 1724 "oberon.aecp" *)

  yyt^.CaseStmt.Cases^.Cases.LabelLimitsIn           := OB.cmtLabelRange;
(* line 1723 "oberon.aecp" *)

  yyt^.CaseStmt.Cases^.Cases.LabelRangeIn            := OB.cmtLabelRange;
(* line 1722 "oberon.aecp" *)
                                                                      

  yyt^.CaseStmt.Cases^.Cases.CaseTypeReprIn          := T.LegalCaseExprTypesOnly(yyt^.CaseStmt.Exprs^.Exprs.TypeReprOut);
yyt^.CaseStmt.Cases^.Cases.ResultTypeReprIn:=yyt^.CaseStmt.ResultTypeReprIn;
yyt^.CaseStmt.Cases^.Cases.TableIn:=yyt^.CaseStmt.TableIn;
yyt^.CaseStmt.Cases^.Cases.ModuleIn:=yyt^.CaseStmt.ModuleIn;
yyVisit1 (yyt^.CaseStmt.Cases);
(* line 1729 "oberon.aecp" *)

  yyt^.CaseStmt.LabelLimits                   := yyt^.CaseStmt.Cases^.Cases.LabelLimitsOut;
yyt^.CaseStmt.Else^.Stmts.EnvIn:=yyt^.CaseStmt.EnvIn;
yyt^.CaseStmt.Else^.Stmts.LoopEndLabelIn:=yyt^.CaseStmt.LoopEndLabelIn;
(* line 2795 "oberon.aecp" *)
 
  yyt^.CaseStmt.Else^.Stmts.TempOfsIn                := yyt^.CaseStmt.TempOfsIn;
yyt^.CaseStmt.Else^.Stmts.LevelIn:=yyt^.CaseStmt.LevelIn;
yyt^.CaseStmt.Else^.Stmts.ResultTypeReprIn:=yyt^.CaseStmt.ResultTypeReprIn;
yyt^.CaseStmt.Else^.Stmts.TableIn:=yyt^.CaseStmt.TableIn;
yyt^.CaseStmt.Else^.Stmts.ModuleIn:=yyt^.CaseStmt.ModuleIn;
yyVisit1 (yyt^.CaseStmt.Else);
yyt^.CaseStmt.Next^.Stmts.EnvIn:=yyt^.CaseStmt.EnvIn;
yyt^.CaseStmt.Next^.Stmts.LoopEndLabelIn:=yyt^.CaseStmt.LoopEndLabelIn;
(* line 2796 "oberon.aecp" *)
 
  yyt^.CaseStmt.Next^.Stmts.TempOfsIn                := yyt^.CaseStmt.TempOfsIn;
yyt^.CaseStmt.Next^.Stmts.LevelIn:=yyt^.CaseStmt.LevelIn;
yyt^.CaseStmt.Next^.Stmts.ResultTypeReprIn:=yyt^.CaseStmt.ResultTypeReprIn;
yyt^.CaseStmt.Next^.Stmts.TableIn:=yyt^.CaseStmt.TableIn;
yyt^.CaseStmt.Next^.Stmts.ModuleIn:=yyt^.CaseStmt.ModuleIn;
yyVisit1 (yyt^.CaseStmt.Next);
(* line 2798 "oberon.aecp" *)
 

  yyt^.CaseStmt.TempOfsOut                    := ADR.MinSize4(yyt^.CaseStmt.Exprs^.Exprs.TempOfsOut,yyt^.CaseStmt.Cases^.Cases.TempOfsOut,yyt^.CaseStmt.Else^.Stmts.TempOfsOut,yyt^.CaseStmt.Next^.Stmts.TempOfsOut);
(* line 1726 "oberon.aecp" *)
 

  yyt^.CaseStmt.ReturnExistsOut               := yyt^.CaseStmt.Next^.Stmts.ReturnExistsOut
                                OR yyt^.CaseStmt.Cases^.Cases.ReturnExistsOut
                                OR yyt^.CaseStmt.Else^.Stmts.ReturnExistsOut;
| Tree.WhileStmt:
yyt^.WhileStmt.Exprs^.Exprs.ModuleIn:=yyt^.WhileStmt.ModuleIn;
yyt^.WhileStmt.Exprs^.Exprs.EnvIn:=yyt^.WhileStmt.EnvIn;
(* line 2802 "oberon.aecp" *)

  yyt^.WhileStmt.Exprs^.Exprs.TempOfsIn               := yyt^.WhileStmt.TempOfsIn;
yyt^.WhileStmt.Exprs^.Exprs.LevelIn:=yyt^.WhileStmt.LevelIn;
(* line 1774 "oberon.aecp" *)

  yyt^.WhileStmt.Exprs^.Exprs.ValDontCareIn           := FALSE;
yyt^.WhileStmt.Exprs^.Exprs.TableIn:=yyt^.WhileStmt.TableIn;
yyVisit1 (yyt^.WhileStmt.Exprs);
(* line 3595 "oberon.aecp" *)
IF ~( T.IsBooleanType(yyt^.WhileStmt.Exprs^.Exprs.TypeReprOut)                                                                
  ) THEN  ERR.MsgPos(ERR.MsgInvalidExprType,yyt^.WhileStmt.Exprs^.Exprs.Position)
 END;
yyt^.WhileStmt.Stmts^.Stmts.EnvIn:=yyt^.WhileStmt.EnvIn;
yyt^.WhileStmt.Stmts^.Stmts.LoopEndLabelIn:=yyt^.WhileStmt.LoopEndLabelIn;
(* line 2803 "oberon.aecp" *)
 
  yyt^.WhileStmt.Stmts^.Stmts.TempOfsIn               := yyt^.WhileStmt.TempOfsIn;
yyt^.WhileStmt.Stmts^.Stmts.LevelIn:=yyt^.WhileStmt.LevelIn;
yyt^.WhileStmt.Stmts^.Stmts.ResultTypeReprIn:=yyt^.WhileStmt.ResultTypeReprIn;
yyt^.WhileStmt.Stmts^.Stmts.TableIn:=yyt^.WhileStmt.TableIn;
yyt^.WhileStmt.Stmts^.Stmts.ModuleIn:=yyt^.WhileStmt.ModuleIn;
yyVisit1 (yyt^.WhileStmt.Stmts);
yyt^.WhileStmt.Next^.Stmts.EnvIn:=yyt^.WhileStmt.EnvIn;
yyt^.WhileStmt.Next^.Stmts.LoopEndLabelIn:=yyt^.WhileStmt.LoopEndLabelIn;
(* line 2804 "oberon.aecp" *)
 
  yyt^.WhileStmt.Next^.Stmts.TempOfsIn                := yyt^.WhileStmt.TempOfsIn;
yyt^.WhileStmt.Next^.Stmts.LevelIn:=yyt^.WhileStmt.LevelIn;
yyt^.WhileStmt.Next^.Stmts.ResultTypeReprIn:=yyt^.WhileStmt.ResultTypeReprIn;
yyt^.WhileStmt.Next^.Stmts.TableIn:=yyt^.WhileStmt.TableIn;
yyt^.WhileStmt.Next^.Stmts.ModuleIn:=yyt^.WhileStmt.ModuleIn;
yyVisit1 (yyt^.WhileStmt.Next);
(* line 2806 "oberon.aecp" *)
 

  yyt^.WhileStmt.TempOfsOut                    := ADR.MinSize3(yyt^.WhileStmt.Exprs^.Exprs.TempOfsOut,yyt^.WhileStmt.Stmts^.Stmts.TempOfsOut,yyt^.WhileStmt.Next^.Stmts.TempOfsOut);
(* line 1776 "oberon.aecp" *)
                                                                      

  yyt^.WhileStmt.ReturnExistsOut               := yyt^.WhileStmt.Next^.Stmts.ReturnExistsOut
                                OR yyt^.WhileStmt.Stmts^.Stmts.ReturnExistsOut;
| Tree.RepeatStmt:
yyt^.RepeatStmt.Exprs^.Exprs.ModuleIn:=yyt^.RepeatStmt.ModuleIn;
yyt^.RepeatStmt.Exprs^.Exprs.EnvIn:=yyt^.RepeatStmt.EnvIn;
(* line 2811 "oberon.aecp" *)
 
  yyt^.RepeatStmt.Exprs^.Exprs.TempOfsIn               := yyt^.RepeatStmt.TempOfsIn;
yyt^.RepeatStmt.Exprs^.Exprs.LevelIn:=yyt^.RepeatStmt.LevelIn;
(* line 1783 "oberon.aecp" *)

  yyt^.RepeatStmt.Exprs^.Exprs.ValDontCareIn           := FALSE;
yyt^.RepeatStmt.Exprs^.Exprs.TableIn:=yyt^.RepeatStmt.TableIn;
yyVisit1 (yyt^.RepeatStmt.Exprs);
(* line 3648 "oberon.aecp" *)
IF ~( T.IsBooleanType(yyt^.RepeatStmt.Exprs^.Exprs.TypeReprOut)                                                               
  ) THEN  ERR.MsgPos(ERR.MsgInvalidExprType,yyt^.RepeatStmt.Exprs^.Exprs.Position)
 END;
yyt^.RepeatStmt.Stmts^.Stmts.EnvIn:=yyt^.RepeatStmt.EnvIn;
yyt^.RepeatStmt.Stmts^.Stmts.LoopEndLabelIn:=yyt^.RepeatStmt.LoopEndLabelIn;
(* line 2810 "oberon.aecp" *)

  yyt^.RepeatStmt.Stmts^.Stmts.TempOfsIn               := yyt^.RepeatStmt.TempOfsIn;
yyt^.RepeatStmt.Stmts^.Stmts.LevelIn:=yyt^.RepeatStmt.LevelIn;
yyt^.RepeatStmt.Stmts^.Stmts.ResultTypeReprIn:=yyt^.RepeatStmt.ResultTypeReprIn;
yyt^.RepeatStmt.Stmts^.Stmts.TableIn:=yyt^.RepeatStmt.TableIn;
yyt^.RepeatStmt.Stmts^.Stmts.ModuleIn:=yyt^.RepeatStmt.ModuleIn;
yyVisit1 (yyt^.RepeatStmt.Stmts);
yyt^.RepeatStmt.Next^.Stmts.EnvIn:=yyt^.RepeatStmt.EnvIn;
yyt^.RepeatStmt.Next^.Stmts.LoopEndLabelIn:=yyt^.RepeatStmt.LoopEndLabelIn;
(* line 2812 "oberon.aecp" *)
 
  yyt^.RepeatStmt.Next^.Stmts.TempOfsIn                := yyt^.RepeatStmt.TempOfsIn;
yyt^.RepeatStmt.Next^.Stmts.LevelIn:=yyt^.RepeatStmt.LevelIn;
yyt^.RepeatStmt.Next^.Stmts.ResultTypeReprIn:=yyt^.RepeatStmt.ResultTypeReprIn;
yyt^.RepeatStmt.Next^.Stmts.TableIn:=yyt^.RepeatStmt.TableIn;
yyt^.RepeatStmt.Next^.Stmts.ModuleIn:=yyt^.RepeatStmt.ModuleIn;
yyVisit1 (yyt^.RepeatStmt.Next);
(* line 2814 "oberon.aecp" *)
 

  yyt^.RepeatStmt.TempOfsOut                    := ADR.MinSize3(yyt^.RepeatStmt.Exprs^.Exprs.TempOfsOut,yyt^.RepeatStmt.Stmts^.Stmts.TempOfsOut,yyt^.RepeatStmt.Next^.Stmts.TempOfsOut);
(* line 1785 "oberon.aecp" *)
                                                                      

  yyt^.RepeatStmt.ReturnExistsOut               := yyt^.RepeatStmt.Next^.Stmts.ReturnExistsOut
                                OR yyt^.RepeatStmt.Stmts^.Stmts.ReturnExistsOut;
| Tree.ForStmt:
yyt^.ForStmt.By^.ConstExpr.ModuleIn:=yyt^.ForStmt.ModuleIn;
yyt^.ForStmt.By^.ConstExpr.EnvIn:=yyt^.ForStmt.EnvIn;
yyt^.ForStmt.By^.ConstExpr.LevelIn:=yyt^.ForStmt.LevelIn;
yyt^.ForStmt.By^.ConstExpr.TableIn:=yyt^.ForStmt.TableIn;
yyVisit1 (yyt^.ForStmt.By);
(* line 3680 "oberon.aecp" *)
IF ~( V.IsNonZeroInteger(yyt^.ForStmt.By^.ConstExpr.ValueReprOut)                                                                   
  ) THEN  ERR.MsgPos(ERR.MsgStepMustBeNonZero,yyt^.ForStmt.By^.ConstExpr.Position)
 END;
(* line 1793 "oberon.aecp" *)

  yyt^.ForStmt.CurLevel                      := yyt^.ForStmt.LevelIn;
yyt^.ForStmt.Stmts^.Stmts.EnvIn:=yyt^.ForStmt.EnvIn;
yyt^.ForStmt.Stmts^.Stmts.LoopEndLabelIn:=yyt^.ForStmt.LoopEndLabelIn;
(* line 2818 "oberon.aecp" *)

  yyt^.ForStmt.TempAddr                      := yyt^.ForStmt.TempOfsIn-4;
(* line 2822 "oberon.aecp" *)
 
  yyt^.ForStmt.Stmts^.Stmts.TempOfsIn               := yyt^.ForStmt.TempAddr;
yyt^.ForStmt.Stmts^.Stmts.LevelIn:=yyt^.ForStmt.LevelIn;
yyt^.ForStmt.Stmts^.Stmts.ResultTypeReprIn:=yyt^.ForStmt.ResultTypeReprIn;
yyt^.ForStmt.Stmts^.Stmts.TableIn:=yyt^.ForStmt.TableIn;
yyt^.ForStmt.Stmts^.Stmts.ModuleIn:=yyt^.ForStmt.ModuleIn;
yyVisit1 (yyt^.ForStmt.Stmts);
yyt^.ForStmt.To^.Exprs.EnvIn:=yyt^.ForStmt.EnvIn;
(* line 2821 "oberon.aecp" *)
 
  yyt^.ForStmt.To^.Exprs.TempOfsIn                  := yyt^.ForStmt.TempOfsIn;
yyt^.ForStmt.To^.Exprs.LevelIn:=yyt^.ForStmt.LevelIn;
(* line 1799 "oberon.aecp" *)
                                                                      

  yyt^.ForStmt.To^.Exprs.ValDontCareIn              := FALSE;
yyt^.ForStmt.To^.Exprs.TableIn:=yyt^.ForStmt.TableIn;
yyt^.ForStmt.To^.Exprs.ModuleIn:=yyt^.ForStmt.ModuleIn;
yyVisit1 (yyt^.ForStmt.To);
yyt^.ForStmt.From^.Exprs.EnvIn:=yyt^.ForStmt.EnvIn;
(* line 2820 "oberon.aecp" *)
 

  yyt^.ForStmt.From^.Exprs.TempOfsIn                := yyt^.ForStmt.TempOfsIn;
yyt^.ForStmt.From^.Exprs.LevelIn:=yyt^.ForStmt.LevelIn;
(* line 1797 "oberon.aecp" *)


  yyt^.ForStmt.From^.Exprs.ValDontCareIn            := FALSE;
yyt^.ForStmt.From^.Exprs.TableIn:=yyt^.ForStmt.TableIn;
yyt^.ForStmt.From^.Exprs.ModuleIn:=yyt^.ForStmt.ModuleIn;
yyVisit1 (yyt^.ForStmt.From);
yyt^.ForStmt.Next^.Stmts.EnvIn:=yyt^.ForStmt.EnvIn;
yyt^.ForStmt.Next^.Stmts.LoopEndLabelIn:=yyt^.ForStmt.LoopEndLabelIn;
(* line 2823 "oberon.aecp" *)
 
  yyt^.ForStmt.Next^.Stmts.TempOfsIn                := yyt^.ForStmt.TempAddr;
yyt^.ForStmt.Next^.Stmts.LevelIn:=yyt^.ForStmt.LevelIn;
yyt^.ForStmt.Next^.Stmts.ResultTypeReprIn:=yyt^.ForStmt.ResultTypeReprIn;
yyt^.ForStmt.Next^.Stmts.TableIn:=yyt^.ForStmt.TableIn;
yyt^.ForStmt.Next^.Stmts.ModuleIn:=yyt^.ForStmt.ModuleIn;
yyVisit1 (yyt^.ForStmt.Next);
(* line 1794 "oberon.aecp" *)
 
  yyt^.ForStmt.ControlVarEntry               := E.Lookup(yyt^.ForStmt.TableIn,yyt^.ForStmt.Ident);
(* line 1795 "oberon.aecp" *)

  yyt^.ForStmt.ControlVarTypeRepr            := E.TypeOfEntry(yyt^.ForStmt.ControlVarEntry);
(* line 1804 "oberon.aecp" *)

  yyt^.ForStmt.ToCoerce                      := CO.GetCoercion
                                   ( yyt^.ForStmt.To^.Exprs.TypeReprOut
                                   , yyt^.ForStmt.ControlVarTypeRepr);
(* line 1801 "oberon.aecp" *)
                                                                      

  yyt^.ForStmt.FromCoerce                    := CO.GetCoercion
                                   ( yyt^.ForStmt.From^.Exprs.TypeReprOut
                                   , yyt^.ForStmt.ControlVarTypeRepr);
(* line 3655 "oberon.aecp" *)
IF ~( (E.DeclStatusOfEntry(yyt^.ForStmt.ControlVarEntry)=OB.DECLARED)                                              
  ) THEN  ERR.MsgPos(ERR.MsgUndeclaredIdent,yyt^.ForStmt.Pos)
 END;
(* line 3658 "oberon.aecp" *)
IF ~( E.IsVarEntry(yyt^.ForStmt.ControlVarEntry)                                                                     
  ) THEN  ERR.MsgPos(ERR.MsgVariableExpected,yyt^.ForStmt.Pos)
 END;
(* line 3661 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.ForStmt.ControlVarTypeRepr)                                                               
  ) THEN  ERR.MsgPos(ERR.MsgIntegerTypeExpected,yyt^.ForStmt.Pos)
 END;
(* line 3664 "oberon.aecp" *)
IF ~( T.IsAssignmentCompatible                                                                                 
        ( yyt^.ForStmt.ControlVarTypeRepr
        , yyt^.ForStmt.From^.Exprs.TypeReprOut
        , yyt^.ForStmt.From^.Exprs.ValueReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgNotAssignCompatible,yyt^.ForStmt.From^.Exprs.Position)
 END;
(* line 3670 "oberon.aecp" *)
IF ~( T.IsAssignmentCompatible                                                                                 
        ( yyt^.ForStmt.ControlVarTypeRepr
        , yyt^.ForStmt.To^.Exprs.TypeReprOut
        , yyt^.ForStmt.To^.Exprs.ValueReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgNotCompatibleWithCtrlVar,yyt^.ForStmt.To^.Exprs.Position)
 END;
(* line 3676 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.ForStmt.By^.ConstExpr.TypeReprOut)                                                                          
      & T.IsIncludedBy(yyt^.ForStmt.By^.ConstExpr.TypeReprOut,T.LegalForExprTypesOnly(yyt^.ForStmt.ControlVarTypeRepr))
  ) THEN  ERR.MsgPos(ERR.MsgNotCompatibleWithCtrlVar,yyt^.ForStmt.By^.ConstExpr.Position)
 END;
(* line 2825 "oberon.aecp" *)
 

  yyt^.ForStmt.TempOfsOut                    := ADR.MinSize4(yyt^.ForStmt.From^.Exprs.TempOfsOut,yyt^.ForStmt.To^.Exprs.TempOfsOut,yyt^.ForStmt.Stmts^.Stmts.TempOfsOut,yyt^.ForStmt.Next^.Stmts.TempOfsOut);
(* line 1808 "oberon.aecp" *)


  yyt^.ForStmt.ReturnExistsOut               := yyt^.ForStmt.Next^.Stmts.ReturnExistsOut
                                OR yyt^.ForStmt.Stmts^.Stmts.ReturnExistsOut;
| Tree.LoopStmt:
(* line 3066 "oberon.aecp" *)

  yyt^.LoopStmt.LoopEndLabel                  := LAB.NewLocal();
yyt^.LoopStmt.Stmts^.Stmts.EnvIn:=yyt^.LoopStmt.EnvIn;
yyt^.LoopStmt.Next^.Stmts.ModuleIn:=yyt^.LoopStmt.ModuleIn;
(* line 3067 "oberon.aecp" *)
 
  yyt^.LoopStmt.Stmts^.Stmts.LoopEndLabelIn          := yyt^.LoopStmt.LoopEndLabel;
(* line 2829 "oberon.aecp" *)

  yyt^.LoopStmt.Stmts^.Stmts.TempOfsIn               := yyt^.LoopStmt.TempOfsIn;
yyt^.LoopStmt.Stmts^.Stmts.LevelIn:=yyt^.LoopStmt.LevelIn;
yyt^.LoopStmt.Stmts^.Stmts.ResultTypeReprIn:=yyt^.LoopStmt.ResultTypeReprIn;
yyt^.LoopStmt.Stmts^.Stmts.TableIn:=yyt^.LoopStmt.TableIn;
yyt^.LoopStmt.Stmts^.Stmts.ModuleIn:=yyt^.LoopStmt.ModuleIn;
yyVisit1 (yyt^.LoopStmt.Stmts);
yyt^.LoopStmt.Next^.Stmts.EnvIn:=yyt^.LoopStmt.EnvIn;
yyt^.LoopStmt.Next^.Stmts.LoopEndLabelIn:=yyt^.LoopStmt.LoopEndLabelIn;
(* line 2830 "oberon.aecp" *)
 
  yyt^.LoopStmt.Next^.Stmts.TempOfsIn                := yyt^.LoopStmt.TempOfsIn;
yyt^.LoopStmt.Next^.Stmts.LevelIn:=yyt^.LoopStmt.LevelIn;
yyt^.LoopStmt.Next^.Stmts.ResultTypeReprIn:=yyt^.LoopStmt.ResultTypeReprIn;
yyt^.LoopStmt.Next^.Stmts.TableIn:=yyt^.LoopStmt.TableIn;
yyVisit1 (yyt^.LoopStmt.Next);
(* line 2832 "oberon.aecp" *)
 

  yyt^.LoopStmt.TempOfsOut                    := ADR.MinSize2(yyt^.LoopStmt.Stmts^.Stmts.TempOfsOut,yyt^.LoopStmt.Next^.Stmts.TempOfsOut);
(* line 1815 "oberon.aecp" *)

  yyt^.LoopStmt.ReturnExistsOut               := yyt^.LoopStmt.Next^.Stmts.ReturnExistsOut
                                OR yyt^.LoopStmt.Stmts^.Stmts.ReturnExistsOut;
| Tree.WithStmt:
yyt^.WithStmt.Next^.Stmts.ModuleIn:=yyt^.WithStmt.ModuleIn;
yyt^.WithStmt.Else^.Stmts.EnvIn:=yyt^.WithStmt.EnvIn;
yyt^.WithStmt.Else^.Stmts.LoopEndLabelIn:=yyt^.WithStmt.LoopEndLabelIn;
(* line 2837 "oberon.aecp" *)
 
  yyt^.WithStmt.Else^.Stmts.TempOfsIn                := yyt^.WithStmt.TempOfsIn;
yyt^.WithStmt.Else^.Stmts.LevelIn:=yyt^.WithStmt.LevelIn;
yyt^.WithStmt.Else^.Stmts.ResultTypeReprIn:=yyt^.WithStmt.ResultTypeReprIn;
yyt^.WithStmt.Else^.Stmts.TableIn:=yyt^.WithStmt.TableIn;
yyt^.WithStmt.Else^.Stmts.ModuleIn:=yyt^.WithStmt.ModuleIn;
yyVisit1 (yyt^.WithStmt.Else);
yyt^.WithStmt.GuardedStmts^.GuardedStmts.EnvIn:=yyt^.WithStmt.EnvIn;
yyt^.WithStmt.GuardedStmts^.GuardedStmts.LoopEndLabelIn:=yyt^.WithStmt.LoopEndLabelIn;
(* line 2836 "oberon.aecp" *)

  yyt^.WithStmt.GuardedStmts^.GuardedStmts.TempOfsIn        := yyt^.WithStmt.TempOfsIn;
yyt^.WithStmt.GuardedStmts^.GuardedStmts.LevelIn:=yyt^.WithStmt.LevelIn;
yyt^.WithStmt.GuardedStmts^.GuardedStmts.ResultTypeReprIn:=yyt^.WithStmt.ResultTypeReprIn;
yyt^.WithStmt.GuardedStmts^.GuardedStmts.TableIn:=yyt^.WithStmt.TableIn;
yyt^.WithStmt.GuardedStmts^.GuardedStmts.ModuleIn:=yyt^.WithStmt.ModuleIn;
yyVisit1 (yyt^.WithStmt.GuardedStmts);
yyt^.WithStmt.Next^.Stmts.EnvIn:=yyt^.WithStmt.EnvIn;
yyt^.WithStmt.Next^.Stmts.LoopEndLabelIn:=yyt^.WithStmt.LoopEndLabelIn;
(* line 2838 "oberon.aecp" *)
 
  yyt^.WithStmt.Next^.Stmts.TempOfsIn                := yyt^.WithStmt.TempOfsIn;
yyt^.WithStmt.Next^.Stmts.LevelIn:=yyt^.WithStmt.LevelIn;
yyt^.WithStmt.Next^.Stmts.ResultTypeReprIn:=yyt^.WithStmt.ResultTypeReprIn;
yyt^.WithStmt.Next^.Stmts.TableIn:=yyt^.WithStmt.TableIn;
yyVisit1 (yyt^.WithStmt.Next);
(* line 2840 "oberon.aecp" *)
 

  yyt^.WithStmt.TempOfsOut                    := ADR.MinSize3(yyt^.WithStmt.GuardedStmts^.GuardedStmts.TempOfsOut,yyt^.WithStmt.Else^.Stmts.TempOfsOut,yyt^.WithStmt.Next^.Stmts.TempOfsOut);
(* line 1822 "oberon.aecp" *)

  yyt^.WithStmt.ReturnExistsOut               := yyt^.WithStmt.Next^.Stmts.ReturnExistsOut
                                OR yyt^.WithStmt.GuardedStmts^.GuardedStmts.ReturnExistsOut
                                OR yyt^.WithStmt.Else^.Stmts.ReturnExistsOut;
| Tree.ExitStmt:
(* line 3703 "oberon.aecp" *)
IF ~( (yyt^.ExitStmt.LoopEndLabelIn # LAB.MT)
  ) THEN  ERR.MsgPos(ERR.MsgExitWithoutLoop,yyt^.ExitStmt.Position)
 END;
(* line 3071 "oberon.aecp" *)

  yyt^.ExitStmt.LoopEndLabel                  := yyt^.ExitStmt.LoopEndLabelIn;
yyt^.ExitStmt.Next^.Stmts.EnvIn:=yyt^.ExitStmt.EnvIn;
yyt^.ExitStmt.Next^.Stmts.LoopEndLabelIn:=yyt^.ExitStmt.LoopEndLabelIn;
yyt^.ExitStmt.Next^.Stmts.TempOfsIn:=yyt^.ExitStmt.TempOfsIn;
yyt^.ExitStmt.Next^.Stmts.LevelIn:=yyt^.ExitStmt.LevelIn;
yyt^.ExitStmt.Next^.Stmts.ResultTypeReprIn:=yyt^.ExitStmt.ResultTypeReprIn;
yyt^.ExitStmt.Next^.Stmts.TableIn:=yyt^.ExitStmt.TableIn;
yyt^.ExitStmt.Next^.Stmts.ModuleIn:=yyt^.ExitStmt.ModuleIn;
yyVisit1 (yyt^.ExitStmt.Next);
yyt^.ExitStmt.TempOfsOut:=yyt^.ExitStmt.Next^.Stmts.TempOfsOut;
(* line 1680 "oberon.aecp" *)

  yyt^.ExitStmt.ReturnExistsOut               := yyt^.ExitStmt.Next^.Stmts.ReturnExistsOut;
| Tree.ReturnStmt:
yyt^.ReturnStmt.Next^.Stmts.ModuleIn:=yyt^.ReturnStmt.ModuleIn;
yyt^.ReturnStmt.Exprs^.Exprs.EnvIn:=yyt^.ReturnStmt.EnvIn;
yyt^.ReturnStmt.Exprs^.Exprs.ModuleIn:=yyt^.ReturnStmt.ModuleIn;
yyt^.ReturnStmt.Next^.Stmts.EnvIn:=yyt^.ReturnStmt.EnvIn;
yyt^.ReturnStmt.Next^.Stmts.LoopEndLabelIn:=yyt^.ReturnStmt.LoopEndLabelIn;
yyt^.ReturnStmt.Next^.Stmts.TempOfsIn:=yyt^.ReturnStmt.TempOfsIn;
yyt^.ReturnStmt.Next^.Stmts.LevelIn:=yyt^.ReturnStmt.LevelIn;
yyt^.ReturnStmt.Next^.Stmts.ResultTypeReprIn:=yyt^.ReturnStmt.ResultTypeReprIn;
yyt^.ReturnStmt.Next^.Stmts.TableIn:=yyt^.ReturnStmt.TableIn;
yyVisit1 (yyt^.ReturnStmt.Next);
yyt^.ReturnStmt.Exprs^.Exprs.TempOfsIn:=yyt^.ReturnStmt.Next^.Stmts.TempOfsOut;
yyt^.ReturnStmt.Exprs^.Exprs.LevelIn:=yyt^.ReturnStmt.LevelIn;
(* line 1870 "oberon.aecp" *)

  yyt^.ReturnStmt.Exprs^.Exprs.ValDontCareIn           := FALSE;
yyt^.ReturnStmt.Exprs^.Exprs.TableIn:=yyt^.ReturnStmt.TableIn;
yyVisit1 (yyt^.ReturnStmt.Exprs);
(* line 3731 "oberon.aecp" *)
IF ~( T.IsAssignmentCompatible                                                                         
        ( T.EmptyTypeToErrorType(yyt^.ReturnStmt.ResultTypeReprIn)
        , T.EmptyTypeToErrorType(yyt^.ReturnStmt.Exprs^.Exprs.TypeReprOut)
        , yyt^.ReturnStmt.Exprs^.Exprs.ValueReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgIncompatibleReturnExpr,yyt^.ReturnStmt.Exprs^.Exprs.Position)
 END;
(* line 1872 "oberon.aecp" *)
                                                                      

  yyt^.ReturnStmt.Coerce                        := CO.GetCoercion
                                   ( yyt^.ReturnStmt.Exprs^.Exprs.TypeReprOut
                                   , yyt^.ReturnStmt.ResultTypeReprIn);
 CO.DoRealCoercion(yyt^.ReturnStmt.Coerce,yyt^.ReturnStmt.Exprs^.Exprs.ValueReprOut,yyt^.ReturnStmt.Exprs^.Exprs.TypeReprOut);
 V.AdjustNilValue(yyt^.ReturnStmt.Exprs^.Exprs.ValueReprOut,yyt^.ReturnStmt.ResultTypeReprIn ,yyt^.ReturnStmt.Exprs^.Exprs.ValueReprOut);
(* line 3713 "oberon.aecp" *)
IF ~( (yyt^.ReturnStmt.LevelIn > OB.MODULELEVEL)                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgReturnOnlyInProcs,yyt^.ReturnStmt.Position)
 END;
(* line 3719 "oberon.aecp" *)
IF ~(  T.IsGenuineEmptyType(yyt^.ReturnStmt.ResultTypeReprIn)                                                           
     OR ~TT.IsEmptyExpr(yyt^.ReturnStmt.Exprs)
  ) THEN  ERR.MsgPos(ERR.MsgMissingReturnExpr,yyt^.ReturnStmt.Position)
 END;
(* line 3726 "oberon.aecp" *)
IF ~( (yyt^.ReturnStmt.LevelIn = OB.MODULELEVEL)                                                                        
     OR ~T.IsGenuineEmptyType(yyt^.ReturnStmt.ResultTypeReprIn)
     OR  TT.IsEmptyExpr(yyt^.ReturnStmt.Exprs)
  ) THEN  ERR.MsgPos(ERR.MsgMisplacedReturnExpr,yyt^.ReturnStmt.Exprs^.Exprs.Position)
 END;
yyt^.ReturnStmt.TempOfsOut:=yyt^.ReturnStmt.Exprs^.Exprs.TempOfsOut;
(* line 1876 "oberon.aecp" *)


  yyt^.ReturnStmt.ReturnExistsOut               := TRUE;
| Tree.Cases:
yyt^.Cases.TempOfsOut:=yyt^.Cases.TempOfsIn;
yyt^.Cases.LabelLimitsOut:=yyt^.Cases.LabelLimitsIn;
(* line 1738 "oberon.aecp" *)

  yyt^.Cases.ReturnExistsOut               := FALSE;
| Tree.mtCase:
yyt^.mtCase.TempOfsOut:=yyt^.mtCase.TempOfsIn;
yyt^.mtCase.LabelLimitsOut:=yyt^.mtCase.LabelLimitsIn;
(* line 1738 "oberon.aecp" *)

  yyt^.mtCase.ReturnExistsOut               := FALSE;
| Tree.Case:
yyt^.Case.Next^.Cases.ModuleIn:=yyt^.Case.ModuleIn;
yyt^.Case.Stmts^.Stmts.EnvIn:=yyt^.Case.EnvIn;
yyt^.Case.Stmts^.Stmts.LoopEndLabelIn:=yyt^.Case.LoopEndLabelIn;
(* line 2844 "oberon.aecp" *)

  yyt^.Case.Stmts^.Stmts.TempOfsIn               := yyt^.Case.TempOfsIn;
yyt^.Case.Stmts^.Stmts.LevelIn:=yyt^.Case.LevelIn;
yyt^.Case.Stmts^.Stmts.ResultTypeReprIn:=yyt^.Case.ResultTypeReprIn;
yyt^.Case.Stmts^.Stmts.TableIn:=yyt^.Case.TableIn;
yyt^.Case.Stmts^.Stmts.ModuleIn:=yyt^.Case.ModuleIn;
yyVisit1 (yyt^.Case.Stmts);
yyt^.Case.CaseLabels^.CaseLabels.EnvIn:=yyt^.Case.EnvIn;
yyt^.Case.CaseLabels^.CaseLabels.LevelIn:=yyt^.Case.LevelIn;
(* line 1745 "oberon.aecp" *)

  yyt^.Case.CaseLabels^.CaseLabels.LabelLimitsIn      := yyt^.Case.LabelLimitsIn;
(* line 1744 "oberon.aecp" *)

  yyt^.Case.CaseLabels^.CaseLabels.LabelRangeIn       := yyt^.Case.LabelRangeIn;
yyt^.Case.CaseLabels^.CaseLabels.CaseTypeReprIn:=yyt^.Case.CaseTypeReprIn;
yyt^.Case.CaseLabels^.CaseLabels.TableIn:=yyt^.Case.TableIn;
yyt^.Case.CaseLabels^.CaseLabels.ModuleIn:=yyt^.Case.ModuleIn;
yyVisit1 (yyt^.Case.CaseLabels);
yyt^.Case.Next^.Cases.EnvIn:=yyt^.Case.EnvIn;
yyt^.Case.Next^.Cases.LoopEndLabelIn:=yyt^.Case.LoopEndLabelIn;
(* line 2845 "oberon.aecp" *)
 
  yyt^.Case.Next^.Cases.TempOfsIn                := yyt^.Case.TempOfsIn;
yyt^.Case.Next^.Cases.LevelIn:=yyt^.Case.LevelIn;
(* line 1748 "oberon.aecp" *)

  yyt^.Case.Next^.Cases.LabelLimitsIn            := yyt^.Case.CaseLabels^.CaseLabels.LabelLimitsOut;
(* line 1747 "oberon.aecp" *)


  yyt^.Case.Next^.Cases.LabelRangeIn             := yyt^.Case.CaseLabels^.CaseLabels.LabelRangeOut;
yyt^.Case.Next^.Cases.CaseTypeReprIn:=yyt^.Case.CaseTypeReprIn;
yyt^.Case.Next^.Cases.ResultTypeReprIn:=yyt^.Case.ResultTypeReprIn;
yyt^.Case.Next^.Cases.TableIn:=yyt^.Case.TableIn;
yyVisit1 (yyt^.Case.Next);
(* line 2847 "oberon.aecp" *)
 

  yyt^.Case.TempOfsOut                    := ADR.MinSize2(yyt^.Case.Stmts^.Stmts.TempOfsOut,yyt^.Case.Next^.Cases.TempOfsOut);
yyt^.Case.LabelLimitsOut:=yyt^.Case.CaseLabels^.CaseLabels.LabelLimitsOut;
(* line 1750 "oberon.aecp" *)


  yyt^.Case.ReturnExistsOut               := yyt^.Case.Next^.Cases.ReturnExistsOut OR yyt^.Case.Stmts^.Stmts.ReturnExistsOut;
| Tree.CaseLabels:
yyt^.CaseLabels.LabelLimitsOut:=yyt^.CaseLabels.LabelLimitsIn;
yyt^.CaseLabels.LabelRangeOut:=yyt^.CaseLabels.LabelRangeIn;
| Tree.mtCaseLabel:
yyt^.mtCaseLabel.LabelLimitsOut:=yyt^.mtCaseLabel.LabelLimitsIn;
yyt^.mtCaseLabel.LabelRangeOut:=yyt^.mtCaseLabel.LabelRangeIn;
| Tree.CaseLabel:
yyt^.CaseLabel.ConstExpr1^.ConstExpr.ModuleIn:=yyt^.CaseLabel.ModuleIn;
yyt^.CaseLabel.ConstExpr2^.ConstExpr.EnvIn:=yyt^.CaseLabel.EnvIn;
yyt^.CaseLabel.ConstExpr2^.ConstExpr.LevelIn:=yyt^.CaseLabel.LevelIn;
yyt^.CaseLabel.ConstExpr2^.ConstExpr.TableIn:=yyt^.CaseLabel.TableIn;
yyt^.CaseLabel.ConstExpr2^.ConstExpr.ModuleIn:=yyt^.CaseLabel.ModuleIn;
yyVisit1 (yyt^.CaseLabel.ConstExpr2);
yyt^.CaseLabel.ConstExpr1^.ConstExpr.EnvIn:=yyt^.CaseLabel.EnvIn;
yyt^.CaseLabel.ConstExpr1^.ConstExpr.LevelIn:=yyt^.CaseLabel.LevelIn;
yyt^.CaseLabel.ConstExpr1^.ConstExpr.TableIn:=yyt^.CaseLabel.TableIn;
yyVisit1 (yyt^.CaseLabel.ConstExpr1);
(* line 1765 "oberon.aecp" *)

  yyt^.CaseLabel.Next^.CaseLabels.LabelLimitsIn            := V.ExtendLabelLimits
                                   ( yyt^.CaseLabel.LabelLimitsIn
                                   , yyt^.CaseLabel.ConstExpr1^.ConstExpr.ValueReprOut
                                   , yyt^.CaseLabel.ConstExpr2^.ConstExpr.ValueReprOut);
(* line 3641 "oberon.aecp" *)
IF ~( V.IsValidLabelRange(yyt^.CaseLabel.Next^.CaseLabels.LabelLimitsIn)
  ) THEN  ERR.MsgPos(ERR.MsgMaxCaseLabelRange,yyt^.CaseLabel.ConstExpr1^.ConstExpr.Position)
 END;
yyt^.CaseLabel.Next^.CaseLabels.EnvIn:=yyt^.CaseLabel.EnvIn;
yyt^.CaseLabel.Next^.CaseLabels.LevelIn:=yyt^.CaseLabel.LevelIn;
(* line 1761 "oberon.aecp" *)

  yyt^.CaseLabel.Next^.CaseLabels.LabelRangeIn             := V.ExtendLabelRange
                                   ( yyt^.CaseLabel.LabelRangeIn
                                   , yyt^.CaseLabel.ConstExpr1^.ConstExpr.ValueReprOut
                                   , yyt^.CaseLabel.ConstExpr2^.ConstExpr.ValueReprOut);
yyt^.CaseLabel.Next^.CaseLabels.CaseTypeReprIn:=yyt^.CaseLabel.CaseTypeReprIn;
yyt^.CaseLabel.Next^.CaseLabels.TableIn:=yyt^.CaseLabel.TableIn;
yyt^.CaseLabel.Next^.CaseLabels.ModuleIn:=yyt^.CaseLabel.ModuleIn;
yyVisit1 (yyt^.CaseLabel.Next);
(* line 3610 "oberon.aecp" *)
IF ~( ~T.IsErrorType(yyt^.CaseLabel.CaseTypeReprIn)                                                                     
     OR T.IsCharType(yyt^.CaseLabel.ConstExpr1^.ConstExpr.TypeReprOut)
     OR T.IsIntegerType(yyt^.CaseLabel.ConstExpr1^.ConstExpr.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgWrongLabelType,yyt^.CaseLabel.ConstExpr1^.ConstExpr.Position)
 END;
(* line 3615 "oberon.aecp" *)
IF ~( (yyt^.CaseLabel.ConstExpr2=yyt^.CaseLabel.ConstExpr1)                                                                              
     OR ~T.IsErrorType(yyt^.CaseLabel.CaseTypeReprIn)
     OR T.IsCharType(yyt^.CaseLabel.ConstExpr2^.ConstExpr.TypeReprOut)
     OR T.IsIntegerType(yyt^.CaseLabel.ConstExpr2^.ConstExpr.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgWrongLabelType,yyt^.CaseLabel.ConstExpr2^.ConstExpr.Position)
 END;
(* line 3621 "oberon.aecp" *)
IF ~( T.IsCaseExprCompatible                                                                             
        ( yyt^.CaseLabel.CaseTypeReprIn
        , yyt^.CaseLabel.ConstExpr1^.ConstExpr.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgLabelNotCompatible,yyt^.CaseLabel.ConstExpr1^.ConstExpr.Position)
 END;
(* line 3626 "oberon.aecp" *)
IF ~( (yyt^.CaseLabel.ConstExpr2=yyt^.CaseLabel.ConstExpr1)                                                                              
     OR T.IsCaseExprCompatible
        ( yyt^.CaseLabel.CaseTypeReprIn
        , T.EmptyTypeToErrorType(yyt^.CaseLabel.ConstExpr2^.ConstExpr.TypeReprOut))
  ) THEN  ERR.MsgPos(ERR.MsgLabelNotCompatible,yyt^.CaseLabel.ConstExpr2^.ConstExpr.Position)
 END;
(* line 3632 "oberon.aecp" *)
IF ~( V.AreLegalLabelRanges(yyt^.CaseLabel.ConstExpr1^.ConstExpr.ValueReprOut,yyt^.CaseLabel.ConstExpr2^.ConstExpr.ValueReprOut)                                 
  ) THEN  ERR.MsgPos(ERR.MsgIllegalCaseLabelRange,yyt^.CaseLabel.ConstExpr1^.ConstExpr.Position)
 END;
(* line 3635 "oberon.aecp" *)
IF ~( ~V.IsInLabelRange                                                                               
        ( yyt^.CaseLabel.LabelRangeIn
        , yyt^.CaseLabel.ConstExpr1^.ConstExpr.ValueReprOut
        , yyt^.CaseLabel.ConstExpr2^.ConstExpr.ValueReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgOverlappingCaseLabel,yyt^.CaseLabel.ConstExpr1^.ConstExpr.Position)
 END;
yyt^.CaseLabel.LabelLimitsOut:=yyt^.CaseLabel.Next^.CaseLabels.LabelLimitsOut;
yyt^.CaseLabel.LabelRangeOut:=yyt^.CaseLabel.Next^.CaseLabels.LabelRangeOut;
| Tree.GuardedStmts:
yyt^.GuardedStmts.TempOfsOut:=yyt^.GuardedStmts.TempOfsIn;
(* line 1830 "oberon.aecp" *)

  yyt^.GuardedStmts.ReturnExistsOut               := FALSE;
| Tree.mtGuardedStmt:
yyt^.mtGuardedStmt.TempOfsOut:=yyt^.mtGuardedStmt.TempOfsIn;
(* line 1830 "oberon.aecp" *)

  yyt^.mtGuardedStmt.ReturnExistsOut               := FALSE;
| Tree.GuardedStmt:
(* line 1846 "oberon.aecp" *)

  yyt^.GuardedStmt.CurLevel                      := yyt^.GuardedStmt.LevelIn;
(* line 1837 "oberon.aecp" *)


  yyt^.GuardedStmt.Guard^.Guard.TableIn                 := yyt^.GuardedStmt.TableIn;
yyt^.GuardedStmt.Guard^.Guard.ModuleIn:=yyt^.GuardedStmt.ModuleIn;
yyVisit1 (yyt^.GuardedStmt.Guard);
yyt^.GuardedStmt.Stmts^.Stmts.EnvIn:=yyt^.GuardedStmt.EnvIn;
yyt^.GuardedStmt.Stmts^.Stmts.LoopEndLabelIn:=yyt^.GuardedStmt.LoopEndLabelIn;
(* line 2851 "oberon.aecp" *)

  yyt^.GuardedStmt.Stmts^.Stmts.TempOfsIn               := yyt^.GuardedStmt.TempOfsIn;
yyt^.GuardedStmt.Stmts^.Stmts.LevelIn:=yyt^.GuardedStmt.LevelIn;
yyt^.GuardedStmt.Stmts^.Stmts.ResultTypeReprIn:=yyt^.GuardedStmt.ResultTypeReprIn;
(* line 1839 "oberon.aecp" *)
 yyt^.GuardedStmt.Stmts^.Stmts.TableIn:=yyt^.GuardedStmt.Guard^.Guard.TableOut;
                                     IF ARG.OptionShowWithTables & (FIL.NestingDepth<=1) THEN 
                                        OD.DumpTable0(E.IdentOfEntry(yyt^.GuardedStmt.ModuleIn)
                                                       ,yyt^.GuardedStmt.Stmts^.Stmts.TableIn,UTI.MakeString('WITH'),Idents.NoIdent);
                                     END; (* IF *)
                                   
yyt^.GuardedStmt.Stmts^.Stmts.ModuleIn:=yyt^.GuardedStmt.ModuleIn;
yyVisit1 (yyt^.GuardedStmt.Stmts);
yyt^.GuardedStmt.Next^.GuardedStmts.EnvIn:=yyt^.GuardedStmt.EnvIn;
yyt^.GuardedStmt.Next^.GuardedStmts.LoopEndLabelIn:=yyt^.GuardedStmt.LoopEndLabelIn;
(* line 2852 "oberon.aecp" *)
 
  yyt^.GuardedStmt.Next^.GuardedStmts.TempOfsIn                := yyt^.GuardedStmt.TempOfsIn;
yyt^.GuardedStmt.Next^.GuardedStmts.LevelIn:=yyt^.GuardedStmt.LevelIn;
yyt^.GuardedStmt.Next^.GuardedStmts.ResultTypeReprIn:=yyt^.GuardedStmt.ResultTypeReprIn;
(* line 1835 "oberon.aecp" *)

  yyt^.GuardedStmt.Next^.GuardedStmts.TableIn                  := yyt^.GuardedStmt.TableIn;
yyt^.GuardedStmt.Next^.GuardedStmts.ModuleIn:=yyt^.GuardedStmt.ModuleIn;
yyVisit1 (yyt^.GuardedStmt.Next);
(* line 2854 "oberon.aecp" *)
 

  yyt^.GuardedStmt.TempOfsOut                    := ADR.MinSize2(yyt^.GuardedStmt.Stmts^.Stmts.TempOfsOut,yyt^.GuardedStmt.Next^.GuardedStmts.TempOfsOut);
(* line 1845 "oberon.aecp" *)

  yyt^.GuardedStmt.ReturnExistsOut               := yyt^.GuardedStmt.Next^.GuardedStmts.ReturnExistsOut OR yyt^.GuardedStmt.Stmts^.Stmts.ReturnExistsOut;
| Tree.Guard:
yyt^.Guard.Variable^.Qualidents.TableIn:=yyt^.Guard.TableIn;
yyt^.Guard.Variable^.Qualidents.ModuleIn:=yyt^.Guard.ModuleIn;
yyVisit1 (yyt^.Guard.Variable);
(* line 1854 "oberon.aecp" *)

  yyt^.Guard.VarEntry                      := yyt^.Guard.Variable^.Qualidents.EntryOut;
yyt^.Guard.TypeId^.Qualidents.TableIn:=yyt^.Guard.TableIn;
yyt^.Guard.TypeId^.Qualidents.ModuleIn:=yyt^.Guard.ModuleIn;
yyVisit1 (yyt^.Guard.TypeId);
(* line 1857 "oberon.aecp" *)

  yyt^.Guard.TypeTypeRepr                  := E.TypeOfTypeEntry(yyt^.Guard.TypeId^.Qualidents.EntryOut);
(* line 1856 "oberon.aecp" *)
 
  
  yyt^.Guard.VarTypeRepr                   := E.TypeOfVarEntry(yyt^.Guard.VarEntry);
(* line 3690 "oberon.aecp" *)
IF ~( (    ( E.IsVarParamEntry(yyt^.Guard.Variable^.Qualidents.EntryOut)                                                       
             & T.IsRecordType   (yyt^.Guard.VarTypeRepr      ))
          OR ( E.IsVarEntry     (yyt^.Guard.Variable^.Qualidents.EntryOut)
             & T.IsPointerType  (yyt^.Guard.VarTypeRepr      )
             )
        )
      & T.IsExtensionOf(yyt^.Guard.TypeTypeRepr,yyt^.Guard.VarTypeRepr)
  ) THEN  ERR.MsgPos(ERR.MsgGuardNotApplicable,yyt^.Guard.OpPos)
 END;
(* line 1859 "oberon.aecp" *)


  yyt^.Guard.TableOut                      := E.EntryWithed                                                           
                                   ( yyt^.Guard.ModuleIn
                                   , TT.GetQualification(yyt^.Guard.Variable)
                                   , yyt^.Guard.TableIn
                                   , yyt^.Guard.Variable^.Qualidents.EntryOut
                                   , yyt^.Guard.TypeTypeRepr);
(* line 3687 "oberon.aecp" *)
IF ~( E.IsTypeEntry(yyt^.Guard.TypeId^.Qualidents.EntryOut)                                                                    
  ) THEN  ERR.MsgPos(ERR.MsgTypeExpected,yyt^.Guard.TypeId^.Qualidents.Position)
 END;
| Tree.ConstExpr:
yyt^.ConstExpr.Expr^.Exprs.ModuleIn:=yyt^.ConstExpr.ModuleIn;
yyt^.ConstExpr.Expr^.Exprs.EnvIn:=yyt^.ConstExpr.EnvIn;
(* line 2858 "oberon.aecp" *)

  yyt^.ConstExpr.Expr^.Exprs.TempOfsIn                := 0;
yyt^.ConstExpr.Expr^.Exprs.LevelIn:=yyt^.ConstExpr.LevelIn;
(* line 1886 "oberon.aecp" *)

  yyt^.ConstExpr.Expr^.Exprs.ValDontCareIn            := FALSE;
yyt^.ConstExpr.Expr^.Exprs.TableIn:=yyt^.ConstExpr.TableIn;
yyVisit1 (yyt^.ConstExpr.Expr);
(* line 3741 "oberon.aecp" *)
IF ~( TT.IsEmptyExpr(yyt^.ConstExpr.Expr)                                                                                   
     OR V.IsValidConstValue(yyt^.ConstExpr.Expr^.Exprs.ValueReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgExprNotConstant,yyt^.ConstExpr.Expr^.Exprs.Position)
 END;
yyt^.ConstExpr.ValueReprOut:=yyt^.ConstExpr.Expr^.Exprs.ValueReprOut;
yyt^.ConstExpr.TypeReprOut:=yyt^.ConstExpr.Expr^.Exprs.TypeReprOut;
| Tree.Exprs:
(* line 1897 "oberon.aecp" *)

  yyt^.Exprs.ValueReprOut                  := OB.cmtValue;
(* line 1896 "oberon.aecp" *)

  yyt^.Exprs.TypeReprOut                   := OB.cErrorTypeRepr;
(* line 3187 "oberon.aecp" *)
 yyt^.Exprs.MainEntryOut             := OB.cmtEntry;
yyt^.Exprs.TempOfsOut:=yyt^.Exprs.TempOfsIn;
(* line 1899 "oberon.aecp" *)

  yyt^.Exprs.IsWritableOut                 := FALSE;
(* line 1898 "oberon.aecp" *)

  yyt^.Exprs.IsLValueOut                   := FALSE;
(* line 1895 "oberon.aecp" *)

  yyt^.Exprs.EntryOut                      := OB.cmtEntry;
| Tree.mtExpr:
(* line 1897 "oberon.aecp" *)

  yyt^.mtExpr.ValueReprOut                  := OB.cmtValue;
(* line 1896 "oberon.aecp" *)

  yyt^.mtExpr.TypeReprOut                   := OB.cErrorTypeRepr;
(* line 3187 "oberon.aecp" *)
 yyt^.mtExpr.MainEntryOut             := OB.cmtEntry;
yyt^.mtExpr.TempOfsOut:=yyt^.mtExpr.TempOfsIn;
(* line 1899 "oberon.aecp" *)

  yyt^.mtExpr.IsWritableOut                 := FALSE;
(* line 1898 "oberon.aecp" *)

  yyt^.mtExpr.IsLValueOut                   := FALSE;
(* line 1895 "oberon.aecp" *)

  yyt^.mtExpr.EntryOut                      := OB.cmtEntry;
| Tree.MonExpr:
(* line 1897 "oberon.aecp" *)

  yyt^.MonExpr.ValueReprOut                  := OB.cmtValue;
yyt^.MonExpr.Exprs^.Exprs.EnvIn:=yyt^.MonExpr.EnvIn;
yyt^.MonExpr.Exprs^.Exprs.TempOfsIn:=yyt^.MonExpr.TempOfsIn;
yyt^.MonExpr.Exprs^.Exprs.LevelIn:=yyt^.MonExpr.LevelIn;
yyt^.MonExpr.Exprs^.Exprs.ValDontCareIn:=yyt^.MonExpr.ValDontCareIn;
yyt^.MonExpr.Exprs^.Exprs.TableIn:=yyt^.MonExpr.TableIn;
yyt^.MonExpr.Exprs^.Exprs.ModuleIn:=yyt^.MonExpr.ModuleIn;
yyVisit1 (yyt^.MonExpr.Exprs);
(* line 1905 "oberon.aecp" *)

  yyt^.MonExpr.TypeReprOut                   := yyt^.MonExpr.Exprs^.Exprs.TypeReprOut;
(* line 3187 "oberon.aecp" *)
 yyt^.MonExpr.MainEntryOut             := OB.cmtEntry;
yyt^.MonExpr.TempOfsOut:=yyt^.MonExpr.Exprs^.Exprs.TempOfsOut;
(* line 1899 "oberon.aecp" *)

  yyt^.MonExpr.IsWritableOut                 := FALSE;
(* line 1898 "oberon.aecp" *)

  yyt^.MonExpr.IsLValueOut                   := FALSE;
(* line 1895 "oberon.aecp" *)

  yyt^.MonExpr.EntryOut                      := OB.cmtEntry;
| Tree.NegateExpr:
yyt^.NegateExpr.Exprs^.Exprs.ModuleIn:=yyt^.NegateExpr.ModuleIn;
yyt^.NegateExpr.Exprs^.Exprs.EnvIn:=yyt^.NegateExpr.EnvIn;
yyt^.NegateExpr.Exprs^.Exprs.TempOfsIn:=yyt^.NegateExpr.TempOfsIn;
yyt^.NegateExpr.Exprs^.Exprs.LevelIn:=yyt^.NegateExpr.LevelIn;
yyt^.NegateExpr.Exprs^.Exprs.ValDontCareIn:=yyt^.NegateExpr.ValDontCareIn;
yyt^.NegateExpr.Exprs^.Exprs.TableIn:=yyt^.NegateExpr.TableIn;
yyVisit1 (yyt^.NegateExpr.Exprs);
(* line 1910 "oberon.aecp" *)

  yyt^.NegateExpr.ValueReprOut                  := V.NegateValue(yyt^.NegateExpr.Exprs^.Exprs.ValueReprOut);
(* line 1911 "oberon.aecp" *)

  yyt^.NegateExpr.TypeReprOut                   := T.ConstTypeCorrection                                               
                                   ( yyt^.NegateExpr.Exprs^.Exprs.TypeReprOut
                                   , yyt^.NegateExpr.ValueReprOut);
(* line 3749 "oberon.aecp" *)
IF ~( T.IsSetType    (yyt^.NegateExpr.Exprs^.Exprs.TypeReprOut)                                                                 
     OR T.IsNumericType(yyt^.NegateExpr.Exprs^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgInvalidExprType,yyt^.NegateExpr.Exprs^.Exprs.Position)
 END;
(* line 3753 "oberon.aecp" *)
IF ~( yyt^.NegateExpr.ValDontCareIn                                                                                          
     OR ~V.IsErrorValue(yyt^.NegateExpr.ValueReprOut)                                                                     
     OR  V.IsErrorValue(yyt^.NegateExpr.Exprs^.Exprs.ValueReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgConstArithmeticError,yyt^.NegateExpr.Position)
 END;
(* line 3187 "oberon.aecp" *)
 yyt^.NegateExpr.MainEntryOut             := OB.cmtEntry;
yyt^.NegateExpr.TempOfsOut:=yyt^.NegateExpr.Exprs^.Exprs.TempOfsOut;
(* line 1899 "oberon.aecp" *)

  yyt^.NegateExpr.IsWritableOut                 := FALSE;
(* line 1898 "oberon.aecp" *)

  yyt^.NegateExpr.IsLValueOut                   := FALSE;
(* line 1895 "oberon.aecp" *)

  yyt^.NegateExpr.EntryOut                      := OB.cmtEntry;
| Tree.IdentityExpr:
yyt^.IdentityExpr.Exprs^.Exprs.ModuleIn:=yyt^.IdentityExpr.ModuleIn;
yyt^.IdentityExpr.Exprs^.Exprs.EnvIn:=yyt^.IdentityExpr.EnvIn;
yyt^.IdentityExpr.Exprs^.Exprs.TempOfsIn:=yyt^.IdentityExpr.TempOfsIn;
yyt^.IdentityExpr.Exprs^.Exprs.LevelIn:=yyt^.IdentityExpr.LevelIn;
yyt^.IdentityExpr.Exprs^.Exprs.ValDontCareIn:=yyt^.IdentityExpr.ValDontCareIn;
yyt^.IdentityExpr.Exprs^.Exprs.TableIn:=yyt^.IdentityExpr.TableIn;
yyVisit1 (yyt^.IdentityExpr.Exprs);
(* line 1918 "oberon.aecp" *)

  yyt^.IdentityExpr.ValueReprOut                  := yyt^.IdentityExpr.Exprs^.Exprs.ValueReprOut;
(* line 1905 "oberon.aecp" *)

  yyt^.IdentityExpr.TypeReprOut                   := yyt^.IdentityExpr.Exprs^.Exprs.TypeReprOut;
(* line 3762 "oberon.aecp" *)
IF ~( T.IsNumericType(yyt^.IdentityExpr.Exprs^.Exprs.TypeReprOut)                                                                 
  ) THEN  ERR.MsgPos(ERR.MsgInvalidExprType,yyt^.IdentityExpr.Exprs^.Exprs.Position)
 END;
(* line 3187 "oberon.aecp" *)
 yyt^.IdentityExpr.MainEntryOut             := OB.cmtEntry;
yyt^.IdentityExpr.TempOfsOut:=yyt^.IdentityExpr.Exprs^.Exprs.TempOfsOut;
(* line 1899 "oberon.aecp" *)

  yyt^.IdentityExpr.IsWritableOut                 := FALSE;
(* line 1898 "oberon.aecp" *)

  yyt^.IdentityExpr.IsLValueOut                   := FALSE;
(* line 1895 "oberon.aecp" *)

  yyt^.IdentityExpr.EntryOut                      := OB.cmtEntry;
| Tree.NotExpr:
yyt^.NotExpr.Exprs^.Exprs.ModuleIn:=yyt^.NotExpr.ModuleIn;
yyt^.NotExpr.Exprs^.Exprs.EnvIn:=yyt^.NotExpr.EnvIn;
yyt^.NotExpr.Exprs^.Exprs.TempOfsIn:=yyt^.NotExpr.TempOfsIn;
yyt^.NotExpr.Exprs^.Exprs.LevelIn:=yyt^.NotExpr.LevelIn;
yyt^.NotExpr.Exprs^.Exprs.ValDontCareIn:=yyt^.NotExpr.ValDontCareIn;
yyt^.NotExpr.Exprs^.Exprs.TableIn:=yyt^.NotExpr.TableIn;
yyVisit1 (yyt^.NotExpr.Exprs);
(* line 1923 "oberon.aecp" *)

  yyt^.NotExpr.ValueReprOut                  := V.NotValue(yyt^.NotExpr.Exprs^.Exprs.ValueReprOut);
(* line 1905 "oberon.aecp" *)

  yyt^.NotExpr.TypeReprOut                   := yyt^.NotExpr.Exprs^.Exprs.TypeReprOut;
(* line 3769 "oberon.aecp" *)
IF ~( T.IsBooleanType(yyt^.NotExpr.Exprs^.Exprs.TypeReprOut)                                                                 
  ) THEN  ERR.MsgPos(ERR.MsgInvalidExprType,yyt^.NotExpr.Exprs^.Exprs.Position)
 END;
(* line 3187 "oberon.aecp" *)
 yyt^.NotExpr.MainEntryOut             := OB.cmtEntry;
yyt^.NotExpr.TempOfsOut:=yyt^.NotExpr.Exprs^.Exprs.TempOfsOut;
(* line 1899 "oberon.aecp" *)

  yyt^.NotExpr.IsWritableOut                 := FALSE;
(* line 1898 "oberon.aecp" *)

  yyt^.NotExpr.IsLValueOut                   := FALSE;
(* line 1895 "oberon.aecp" *)

  yyt^.NotExpr.EntryOut                      := OB.cmtEntry;
| Tree.DyExpr:
yyt^.DyExpr.Expr1^.Exprs.ModuleIn:=yyt^.DyExpr.ModuleIn;
yyt^.DyExpr.Expr2^.Exprs.EnvIn:=yyt^.DyExpr.EnvIn;
(* line 2863 "oberon.aecp" *)
 
  yyt^.DyExpr.Expr2^.Exprs.TempOfsIn               := yyt^.DyExpr.TempOfsIn;
yyt^.DyExpr.Expr2^.Exprs.LevelIn:=yyt^.DyExpr.LevelIn;
yyt^.DyExpr.Expr2^.Exprs.ModuleIn:=yyt^.DyExpr.ModuleIn;
yyt^.DyExpr.Expr1^.Exprs.EnvIn:=yyt^.DyExpr.EnvIn;
(* line 2862 "oberon.aecp" *)

  yyt^.DyExpr.Expr1^.Exprs.TempOfsIn               := yyt^.DyExpr.TempOfsIn;
yyt^.DyExpr.Expr1^.Exprs.LevelIn:=yyt^.DyExpr.LevelIn;
yyt^.DyExpr.Expr1^.Exprs.ValDontCareIn:=yyt^.DyExpr.ValDontCareIn;
yyt^.DyExpr.Expr1^.Exprs.TableIn:=yyt^.DyExpr.TableIn;
yyVisit1 (yyt^.DyExpr.Expr1);
(* line 1937 "oberon.aecp" *)


  yyt^.DyExpr.DyOperator^.DyOperator.ValDontCareIn      := yyt^.DyExpr.ValDontCareIn;
(* line 1930 "oberon.aecp" *)

  yyt^.DyExpr.DyOperator^.DyOperator.ValueRepr1In       := yyt^.DyExpr.Expr1^.Exprs.ValueReprOut;
yyVisit1 (yyt^.DyExpr.DyOperator);
(* line 1938 "oberon.aecp" *)

  yyt^.DyExpr.Expr2^.Exprs.ValDontCareIn           := yyt^.DyExpr.DyOperator^.DyOperator.ValDontCareOut;
yyt^.DyExpr.Expr2^.Exprs.TableIn:=yyt^.DyExpr.TableIn;
yyVisit1 (yyt^.DyExpr.Expr2);
(* line 1935 "oberon.aecp" *)

  yyt^.DyExpr.DyOperator^.DyOperator.Expr2PosIn         := yyt^.DyExpr.Expr2^.Exprs.Position;
(* line 1934 "oberon.aecp" *)

  yyt^.DyExpr.DyOperator^.DyOperator.ValueRepr2In       := yyt^.DyExpr.Expr2^.Exprs.ValueReprOut;
(* line 1933 "oberon.aecp" *)


  yyt^.DyExpr.DyOperator^.DyOperator.TypeRepr2In        := yyt^.DyExpr.Expr2^.Exprs.TypeReprOut;
(* line 1931 "oberon.aecp" *)

  yyt^.DyExpr.DyOperator^.DyOperator.Expr1PosIn         := yyt^.DyExpr.Expr1^.Exprs.Position;
(* line 1929 "oberon.aecp" *)

  yyt^.DyExpr.DyOperator^.DyOperator.TypeRepr1In        := yyt^.DyExpr.Expr1^.Exprs.TypeReprOut;
yyVisit2 (yyt^.DyExpr.DyOperator);
(* line 1941 "oberon.aecp" *)

  yyt^.DyExpr.ValueReprOut                  := yyt^.DyExpr.DyOperator^.DyOperator.ValueReprOut;
(* line 1940 "oberon.aecp" *)


  yyt^.DyExpr.TypeReprOut                   := yyt^.DyExpr.DyOperator^.DyOperator.TypeReprOut;
 CO.DoRealCoercion(yyt^.DyExpr.DyOperator^.DyOperator.Coerce1,yyt^.DyExpr.Expr1^.Exprs.ValueReprOut,yyt^.DyExpr.Expr1^.Exprs.TypeReprOut);
 CO.DoRealCoercion(yyt^.DyExpr.DyOperator^.DyOperator.Coerce2,yyt^.DyExpr.Expr2^.Exprs.ValueReprOut,yyt^.DyExpr.Expr2^.Exprs.TypeReprOut);
 V.AdjustNilValue(yyt^.DyExpr.Expr2^.Exprs.ValueReprOut,yyt^.DyExpr.Expr1^.Exprs.TypeReprOut,yyt^.DyExpr.Expr2^.Exprs.ValueReprOut);
 V.AdjustNilValue(yyt^.DyExpr.Expr1^.Exprs.ValueReprOut,yyt^.DyExpr.Expr2^.Exprs.TypeReprOut,yyt^.DyExpr.Expr1^.Exprs.ValueReprOut);
(* line 3187 "oberon.aecp" *)
 yyt^.DyExpr.MainEntryOut             := OB.cmtEntry;
(* line 2865 "oberon.aecp" *)
 

  yyt^.DyExpr.TempOfsOut                    := ADR.MinSize2(yyt^.DyExpr.Expr1^.Exprs.TempOfsOut,yyt^.DyExpr.Expr2^.Exprs.TempOfsOut);
(* line 1899 "oberon.aecp" *)

  yyt^.DyExpr.IsWritableOut                 := FALSE;
(* line 1898 "oberon.aecp" *)

  yyt^.DyExpr.IsLValueOut                   := FALSE;
(* line 1895 "oberon.aecp" *)

  yyt^.DyExpr.EntryOut                      := OB.cmtEntry;
| Tree.IsExpr:
yyt^.IsExpr.TypeId^.Qualidents.TableIn:=yyt^.IsExpr.TableIn;
yyt^.IsExpr.TypeId^.Qualidents.ModuleIn:=yyt^.IsExpr.ModuleIn;
yyVisit1 (yyt^.IsExpr.TypeId);
(* line 1952 "oberon.aecp" *)


  yyt^.IsExpr.TypeTypeRepr                  := E.TypeOfTypeEntry(yyt^.IsExpr.TypeId^.Qualidents.EntryOut);
yyt^.IsExpr.Designator^.Designator.EnvIn:=yyt^.IsExpr.EnvIn;
(* line 2869 "oberon.aecp" *)

  yyt^.IsExpr.Designator^.Designator.TempOfsIn          := yyt^.IsExpr.TempOfsIn;
(* line 1950 "oberon.aecp" *)

  yyt^.IsExpr.Designator^.Designator.IsCallDesignatorIn := FALSE;
yyt^.IsExpr.Designator^.Designator.ValDontCareIn:=yyt^.IsExpr.ValDontCareIn;
yyt^.IsExpr.Designator^.Designator.TableIn:=yyt^.IsExpr.TableIn;
yyt^.IsExpr.Designator^.Designator.ModuleIn:=yyt^.IsExpr.ModuleIn;
yyt^.IsExpr.Designator^.Designator.LevelIn:=yyt^.IsExpr.LevelIn;
yyVisit1 (yyt^.IsExpr.Designator);
(* line 1955 "oberon.aecp" *)

  yyt^.IsExpr.ValueReprOut                  := V.TypeTestValue(yyt^.IsExpr.Designator^.Designator.TypeReprOut,yyt^.IsExpr.TypeTypeRepr);
(* line 1954 "oberon.aecp" *)


  yyt^.IsExpr.TypeReprOut                   := OB.cBooleanTypeRepr;
(* line 3776 "oberon.aecp" *)
IF ~( E.IsTypeEntry(yyt^.IsExpr.TypeId^.Qualidents.EntryOut)                                                                           
  ) THEN  ERR.MsgPos(ERR.MsgTypeExpected,yyt^.IsExpr.TypeId^.Qualidents.Position)
 END;
(* line 3779 "oberon.aecp" *)
IF ~( (    ( E.IsVarParamEntry(yyt^.IsExpr.Designator^.Designator.EntryOut   )                                                         
             & T.IsRecordType   (yyt^.IsExpr.Designator^.Designator.TypeReprOut))
          OR   T.IsPointerType  (yyt^.IsExpr.Designator^.Designator.TypeReprOut)
        )
      & T.IsExtensionOf(yyt^.IsExpr.TypeTypeRepr,yyt^.IsExpr.Designator^.Designator.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgTypeTestNotApplicable,yyt^.IsExpr.OpPos)
 END;
(* line 3187 "oberon.aecp" *)
 yyt^.IsExpr.MainEntryOut             := OB.cmtEntry;
(* line 2871 "oberon.aecp" *)
 
  
  yyt^.IsExpr.TempOfsOut                    := yyt^.IsExpr.Designator^.Designator.TempOfsOut;
(* line 1899 "oberon.aecp" *)

  yyt^.IsExpr.IsWritableOut                 := FALSE;
(* line 1898 "oberon.aecp" *)

  yyt^.IsExpr.IsLValueOut                   := FALSE;
(* line 1895 "oberon.aecp" *)

  yyt^.IsExpr.EntryOut                      := OB.cmtEntry;
| Tree.SetExpr:
yyt^.SetExpr.Elements^.Elements.ModuleIn:=yyt^.SetExpr.ModuleIn;
yyt^.SetExpr.Elements^.Elements.EnvIn:=yyt^.SetExpr.EnvIn;
(* line 2875 "oberon.aecp" *)

  yyt^.SetExpr.Elements^.Elements.TempOfsIn            := yyt^.SetExpr.TempOfsIn;
yyt^.SetExpr.Elements^.Elements.LevelIn:=yyt^.SetExpr.LevelIn;
yyt^.SetExpr.Elements^.Elements.ValDontCareIn:=yyt^.SetExpr.ValDontCareIn;
yyt^.SetExpr.Elements^.Elements.TableIn:=yyt^.SetExpr.TableIn;
yyVisit1 (yyt^.SetExpr.Elements);
(* line 1963 "oberon.aecp" *)
 IF yyt^.SetExpr.Elements^.Elements.IsConstOut THEN 
                                        yyt^.SetExpr.ValueReprOut:=yyt^.SetExpr.Elements^.Elements.ValueReprOut;
                                     ELSE 
                                        yyt^.SetExpr.ValueReprOut:=OB.cmtValue;
                                     END;
                                   
(* line 1961 "oberon.aecp" *)

  yyt^.SetExpr.TypeReprOut                   := OB.cSetTypeRepr;
(* line 1962 "oberon.aecp" *)

  yyt^.SetExpr.ConstValueRepr                := yyt^.SetExpr.Elements^.Elements.ValueReprOut;
(* line 3187 "oberon.aecp" *)
 yyt^.SetExpr.MainEntryOut             := OB.cmtEntry;
(* line 2877 "oberon.aecp" *)
 
  
  yyt^.SetExpr.TempOfsOut                    := yyt^.SetExpr.Elements^.Elements.TempOfsOut;
(* line 1899 "oberon.aecp" *)

  yyt^.SetExpr.IsWritableOut                 := FALSE;
(* line 1898 "oberon.aecp" *)

  yyt^.SetExpr.IsLValueOut                   := FALSE;
(* line 1895 "oberon.aecp" *)

  yyt^.SetExpr.EntryOut                      := OB.cmtEntry;
| Tree.DesignExpr:
yyt^.DesignExpr.Designator^.Designator.LevelIn:=yyt^.DesignExpr.LevelIn;
yyt^.DesignExpr.Designator^.Designator.EnvIn:=yyt^.DesignExpr.EnvIn;
(* line 2881 "oberon.aecp" *)

  yyt^.DesignExpr.Designator^.Designator.TempOfsIn          := yyt^.DesignExpr.TempOfsIn;
(* line 1974 "oberon.aecp" *)

  yyt^.DesignExpr.Designator^.Designator.IsCallDesignatorIn := FALSE;
yyt^.DesignExpr.Designator^.Designator.ValDontCareIn:=yyt^.DesignExpr.ValDontCareIn;
yyt^.DesignExpr.Designator^.Designator.TableIn:=yyt^.DesignExpr.TableIn;
yyt^.DesignExpr.Designator^.Designator.ModuleIn:=yyt^.DesignExpr.ModuleIn;
yyVisit1 (yyt^.DesignExpr.Designator);
(* line 1978 "oberon.aecp" *)

  yyt^.DesignExpr.ValueReprOut                  := yyt^.DesignExpr.Designator^.Designator.ValueReprOut;
(* line 1977 "oberon.aecp" *)

  yyt^.DesignExpr.TypeReprOut                   := T.EmptyTypeToErrorType(yyt^.DesignExpr.Designator^.Designator.TypeReprOut);
(* line 1976 "oberon.aecp" *)


  yyt^.DesignExpr.EntryOut                      := yyt^.DesignExpr.Designator^.Designator.EntryOut;
(* line 1982 "oberon.aecp" *)

  
  yyt^.DesignExpr.Entry                         := yyt^.DesignExpr.EntryOut;
(* line 3790 "oberon.aecp" *)
IF ~( ~T.IsEmptyType(yyt^.DesignExpr.Designator^.Designator.TypeReprOut)                                                           
     OR  T.IsErrorType(yyt^.DesignExpr.Designator^.Designator.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgIllegalFuncCall,yyt^.DesignExpr.Designator^.Designator.Position)
 END;
(* line 3188 "oberon.aecp" *)
 yyt^.DesignExpr.MainEntryOut             := yyt^.DesignExpr.Designator^.Designator.MainEntryOut;
(* line 2883 "oberon.aecp" *)
 
  
  yyt^.DesignExpr.TempOfsOut                    := yyt^.DesignExpr.Designator^.Designator.TempOfsOut;
(* line 1980 "oberon.aecp" *)

  yyt^.DesignExpr.IsWritableOut                 := yyt^.DesignExpr.Designator^.Designator.IsWritableOut;
(* line 1979 "oberon.aecp" *)

  yyt^.DesignExpr.IsLValueOut                   := E.IsVarEntry(yyt^.DesignExpr.Designator^.Designator.EntryOut);
| Tree.SetConst:
(* line 1989 "oberon.aecp" *)

  yyt^.SetConst.ValueReprOut                  := OB.mSetValue      ( yyt^.SetConst.Set      );
(* line 1988 "oberon.aecp" *)

  yyt^.SetConst.TypeReprOut                   := OB.cSetTypeRepr;
(* line 3187 "oberon.aecp" *)
 yyt^.SetConst.MainEntryOut             := OB.cmtEntry;
yyt^.SetConst.TempOfsOut:=yyt^.SetConst.TempOfsIn;
(* line 1899 "oberon.aecp" *)

  yyt^.SetConst.IsWritableOut                 := FALSE;
(* line 1898 "oberon.aecp" *)

  yyt^.SetConst.IsLValueOut                   := FALSE;
(* line 1895 "oberon.aecp" *)

  yyt^.SetConst.EntryOut                      := OB.cmtEntry;
| Tree.IntConst:
(* line 1996 "oberon.aecp" *)
                                         
  yyt^.IntConst.ValueReprOut                  := OB.mIntegerValue  ( yyt^.IntConst.Int      );
(* line 1995 "oberon.aecp" *)

  yyt^.IntConst.TypeReprOut                   := T.MinimalIntegerType(yyt^.IntConst.Int);
(* line 3187 "oberon.aecp" *)
 yyt^.IntConst.MainEntryOut             := OB.cmtEntry;
yyt^.IntConst.TempOfsOut:=yyt^.IntConst.TempOfsIn;
(* line 1899 "oberon.aecp" *)

  yyt^.IntConst.IsWritableOut                 := FALSE;
(* line 1898 "oberon.aecp" *)

  yyt^.IntConst.IsLValueOut                   := FALSE;
(* line 1895 "oberon.aecp" *)

  yyt^.IntConst.EntryOut                      := OB.cmtEntry;
| Tree.RealConst:
(* line 2003 "oberon.aecp" *)

  yyt^.RealConst.ValueReprOut                  := OB.mRealValue     ( yyt^.RealConst.Real     );
(* line 2002 "oberon.aecp" *)

  yyt^.RealConst.TypeReprOut                   := OB.cRealTypeRepr;
(* line 3187 "oberon.aecp" *)
 yyt^.RealConst.MainEntryOut             := OB.cmtEntry;
yyt^.RealConst.TempOfsOut:=yyt^.RealConst.TempOfsIn;
(* line 1899 "oberon.aecp" *)

  yyt^.RealConst.IsWritableOut                 := FALSE;
(* line 1898 "oberon.aecp" *)

  yyt^.RealConst.IsLValueOut                   := FALSE;
(* line 1895 "oberon.aecp" *)

  yyt^.RealConst.EntryOut                      := OB.cmtEntry;
| Tree.LongrealConst:
(* line 2010 "oberon.aecp" *)

  yyt^.LongrealConst.ValueReprOut                  := OB.mLongrealValue ( yyt^.LongrealConst.Longreal );
(* line 2009 "oberon.aecp" *)

  yyt^.LongrealConst.TypeReprOut                   := OB.cLongrealTypeRepr;
(* line 3187 "oberon.aecp" *)
 yyt^.LongrealConst.MainEntryOut             := OB.cmtEntry;
yyt^.LongrealConst.TempOfsOut:=yyt^.LongrealConst.TempOfsIn;
(* line 1899 "oberon.aecp" *)

  yyt^.LongrealConst.IsWritableOut                 := FALSE;
(* line 1898 "oberon.aecp" *)

  yyt^.LongrealConst.IsLValueOut                   := FALSE;
(* line 1895 "oberon.aecp" *)

  yyt^.LongrealConst.EntryOut                      := OB.cmtEntry;
| Tree.CharConst:
(* line 2017 "oberon.aecp" *)
                                               
  yyt^.CharConst.ValueReprOut                  := OB.mCharValue     ( yyt^.CharConst.Char     );
(* line 2016 "oberon.aecp" *)

  yyt^.CharConst.TypeReprOut                   := OB.cCharStringTypeRepr;
(* line 3187 "oberon.aecp" *)
 yyt^.CharConst.MainEntryOut             := OB.cmtEntry;
yyt^.CharConst.TempOfsOut:=yyt^.CharConst.TempOfsIn;
(* line 1899 "oberon.aecp" *)

  yyt^.CharConst.IsWritableOut                 := FALSE;
(* line 1898 "oberon.aecp" *)

  yyt^.CharConst.IsLValueOut                   := FALSE;
(* line 1895 "oberon.aecp" *)

  yyt^.CharConst.EntryOut                      := OB.cmtEntry;
| Tree.StringConst:
(* line 2024 "oberon.aecp" *)

  yyt^.StringConst.ValueReprOut                  := OB.mStringValue   ( yyt^.StringConst.String   );
(* line 2023 "oberon.aecp" *)

  yyt^.StringConst.TypeReprOut                   := OB.cStringTypeRepr;
(* line 3187 "oberon.aecp" *)
 yyt^.StringConst.MainEntryOut             := OB.cmtEntry;
yyt^.StringConst.TempOfsOut:=yyt^.StringConst.TempOfsIn;
(* line 1899 "oberon.aecp" *)

  yyt^.StringConst.IsWritableOut                 := FALSE;
(* line 1898 "oberon.aecp" *)

  yyt^.StringConst.IsLValueOut                   := FALSE;
(* line 1895 "oberon.aecp" *)

  yyt^.StringConst.EntryOut                      := OB.cmtEntry;
| Tree.NilConst:
(* line 2031 "oberon.aecp" *)

  yyt^.NilConst.ValueReprOut                  := OB.cNilValue;
(* line 2030 "oberon.aecp" *)

  yyt^.NilConst.TypeReprOut                   := OB.cNilTypeRepr;
(* line 3187 "oberon.aecp" *)
 yyt^.NilConst.MainEntryOut             := OB.cmtEntry;
yyt^.NilConst.TempOfsOut:=yyt^.NilConst.TempOfsIn;
(* line 1899 "oberon.aecp" *)

  yyt^.NilConst.IsWritableOut                 := FALSE;
(* line 1898 "oberon.aecp" *)

  yyt^.NilConst.IsLValueOut                   := FALSE;
(* line 1895 "oberon.aecp" *)

  yyt^.NilConst.EntryOut                      := OB.cmtEntry;
| Tree.Elements:
yyt^.Elements.TempOfsOut:=yyt^.Elements.TempOfsIn;
(* line 2040 "oberon.aecp" *)

  yyt^.Elements.IsConstOut                    := TRUE;
(* line 2039 "oberon.aecp" *)

  yyt^.Elements.ValueReprOut                  := OB.cEmptySetValue;
| Tree.mtElement:
yyt^.mtElement.TempOfsOut:=yyt^.mtElement.TempOfsIn;
(* line 2040 "oberon.aecp" *)

  yyt^.mtElement.IsConstOut                    := TRUE;
(* line 2039 "oberon.aecp" *)

  yyt^.mtElement.ValueReprOut                  := OB.cEmptySetValue;
| Tree.Element:
yyt^.Element.Expr2^.Exprs.ModuleIn:=yyt^.Element.ModuleIn;
yyt^.Element.Expr2^.Exprs.EnvIn:=yyt^.Element.EnvIn;
(* line 2888 "oberon.aecp" *)
 
  yyt^.Element.Expr2^.Exprs.TempOfsIn               := yyt^.Element.TempOfsIn;
yyt^.Element.Expr2^.Exprs.LevelIn:=yyt^.Element.LevelIn;
yyt^.Element.Expr2^.Exprs.ValDontCareIn:=yyt^.Element.ValDontCareIn;
yyt^.Element.Expr2^.Exprs.TableIn:=yyt^.Element.TableIn;
yyVisit1 (yyt^.Element.Expr2);
(* line 3807 "oberon.aecp" *)
IF ~( V.IsLegalSetValue(yyt^.Element.Expr2^.Exprs.ValueReprOut)                                                                 
  ) THEN  ERR.MsgPos(ERR.MsgIntOutOfSet,yyt^.Element.Expr1^.Exprs.Position)
 END;
yyt^.Element.Expr1^.Exprs.EnvIn:=yyt^.Element.EnvIn;
(* line 2887 "oberon.aecp" *)

  yyt^.Element.Expr1^.Exprs.TempOfsIn               := yyt^.Element.TempOfsIn;
yyt^.Element.Expr1^.Exprs.LevelIn:=yyt^.Element.LevelIn;
yyt^.Element.Expr1^.Exprs.ValDontCareIn:=yyt^.Element.ValDontCareIn;
yyt^.Element.Expr1^.Exprs.TableIn:=yyt^.Element.TableIn;
yyt^.Element.Expr1^.Exprs.ModuleIn:=yyt^.Element.ModuleIn;
yyVisit1 (yyt^.Element.Expr1);
yyt^.Element.Next^.Elements.EnvIn:=yyt^.Element.EnvIn;
(* line 2889 "oberon.aecp" *)
 
  yyt^.Element.Next^.Elements.TempOfsIn                := yyt^.Element.TempOfsIn;
yyt^.Element.Next^.Elements.LevelIn:=yyt^.Element.LevelIn;
yyt^.Element.Next^.Elements.ValDontCareIn:=yyt^.Element.ValDontCareIn;
yyt^.Element.Next^.Elements.TableIn:=yyt^.Element.TableIn;
yyt^.Element.Next^.Elements.ModuleIn:=yyt^.Element.ModuleIn;
yyVisit1 (yyt^.Element.Next);
(* line 3798 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.Element.Expr1^.Exprs.TypeReprOut)                                                                    
  ) THEN  ERR.MsgPos(ERR.MsgInvalidExprType,yyt^.Element.Expr1^.Exprs.Position)
 END;
(* line 3801 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.Element.Expr2^.Exprs.TypeReprOut)                                                                    
  ) THEN  ERR.MsgPos(ERR.MsgInvalidExprType,yyt^.Element.Expr2^.Exprs.Position)
 END;
(* line 3804 "oberon.aecp" *)
IF ~( V.IsLegalSetValue(yyt^.Element.Expr1^.Exprs.ValueReprOut)                                                                 
  ) THEN  ERR.MsgPos(ERR.MsgIntOutOfSet,yyt^.Element.Expr1^.Exprs.Position)
 END;
(* line 2891 "oberon.aecp" *)
 

  yyt^.Element.TempOfsOut                    := ADR.MinSize3(yyt^.Element.Expr1^.Exprs.TempOfsOut,yyt^.Element.Expr2^.Exprs.TempOfsOut,yyt^.Element.Next^.Elements.TempOfsOut);
(* line 2045 "oberon.aecp" *)
 yyt^.Element.ValueReprOut:=V.ExtendSet
                                     ( yyt^.Element.Next^.Elements.ValueReprOut
                                     , yyt^.Element.Expr1^.Exprs.ValueReprOut
                                     , TT.ElementCorrection
                                                                ( yyt^.Element.Expr2
                                                                , yyt^.Element.Expr1^.Exprs.ValueReprOut
                                                                , yyt^.Element.Expr2^.Exprs.ValueReprOut)
                                     , yyt^.Element.IsConstOut);
                                     IF ~yyt^.Element.Next^.Elements.IsConstOut THEN yyt^.Element.IsConstOut:=FALSE; END; (* IF *)
                                    
| Tree.DyOperator:
(* line 2075 "oberon.aecp" *)


  yyt^.DyOperator.ValDontCareOut                := yyt^.DyOperator.ValDontCareIn;
| Tree.RelationOper:
(* line 2075 "oberon.aecp" *)


  yyt^.RelationOper.ValDontCareOut                := yyt^.RelationOper.ValDontCareIn;
| Tree.EqualOper:
(* line 2075 "oberon.aecp" *)


  yyt^.EqualOper.ValDontCareOut                := yyt^.EqualOper.ValDontCareIn;
| Tree.UnequalOper:
(* line 2075 "oberon.aecp" *)


  yyt^.UnequalOper.ValDontCareOut                := yyt^.UnequalOper.ValDontCareIn;
| Tree.OrderRelationOper:
(* line 2075 "oberon.aecp" *)


  yyt^.OrderRelationOper.ValDontCareOut                := yyt^.OrderRelationOper.ValDontCareIn;
| Tree.LessOper:
(* line 2075 "oberon.aecp" *)


  yyt^.LessOper.ValDontCareOut                := yyt^.LessOper.ValDontCareIn;
| Tree.LessEqualOper:
(* line 2075 "oberon.aecp" *)


  yyt^.LessEqualOper.ValDontCareOut                := yyt^.LessEqualOper.ValDontCareIn;
| Tree.GreaterOper:
(* line 2075 "oberon.aecp" *)


  yyt^.GreaterOper.ValDontCareOut                := yyt^.GreaterOper.ValDontCareIn;
| Tree.GreaterEqualOper:
(* line 2075 "oberon.aecp" *)


  yyt^.GreaterEqualOper.ValDontCareOut                := yyt^.GreaterEqualOper.ValDontCareIn;
| Tree.InOper:
(* line 2075 "oberon.aecp" *)


  yyt^.InOper.ValDontCareOut                := yyt^.InOper.ValDontCareIn;
| Tree.NumSetOper:
(* line 2075 "oberon.aecp" *)


  yyt^.NumSetOper.ValDontCareOut                := yyt^.NumSetOper.ValDontCareIn;
| Tree.PlusOper:
(* line 2075 "oberon.aecp" *)


  yyt^.PlusOper.ValDontCareOut                := yyt^.PlusOper.ValDontCareIn;
| Tree.MinusOper:
(* line 2075 "oberon.aecp" *)


  yyt^.MinusOper.ValDontCareOut                := yyt^.MinusOper.ValDontCareIn;
| Tree.MultOper:
(* line 2075 "oberon.aecp" *)


  yyt^.MultOper.ValDontCareOut                := yyt^.MultOper.ValDontCareIn;
| Tree.RDivOper:
(* line 2075 "oberon.aecp" *)


  yyt^.RDivOper.ValDontCareOut                := yyt^.RDivOper.ValDontCareIn;
| Tree.IntOper:
(* line 2075 "oberon.aecp" *)


  yyt^.IntOper.ValDontCareOut                := yyt^.IntOper.ValDontCareIn;
| Tree.DivOper:
(* line 2075 "oberon.aecp" *)


  yyt^.DivOper.ValDontCareOut                := yyt^.DivOper.ValDontCareIn;
| Tree.ModOper:
(* line 2075 "oberon.aecp" *)


  yyt^.ModOper.ValDontCareOut                := yyt^.ModOper.ValDontCareIn;
| Tree.BoolOper:
(* line 2075 "oberon.aecp" *)


  yyt^.BoolOper.ValDontCareOut                := yyt^.BoolOper.ValDontCareIn;
| Tree.OrOper:
(* line 2163 "oberon.aecp" *)

  yyt^.OrOper.ValDontCareOut                := yyt^.OrOper.ValDontCareIn                                                               
                                OR V.IsTrueValue(yyt^.OrOper.ValueRepr1In);
| Tree.AndOper:
(* line 2171 "oberon.aecp" *)

  yyt^.AndOper.ValDontCareOut                := yyt^.AndOper.ValDontCareIn                                                               
                                OR V.IsFalseValue(yyt^.AndOper.ValueRepr1In);
| Tree.Designator:
(* line 2187 "oberon.aecp" *)

  yyt^.Designator.Entry                         := E.Lookup(yyt^.Designator.TableIn,yyt^.Designator.Ident);
(* line 2190 "oberon.aecp" *)
 yyt^.Designator.endPos:=yyt^.Designator.Position; POS.IncCol(yyt^.Designator.endPos,UTI.IdentLength(yyt^.Designator.Ident)); 
(* line 2188 "oberon.aecp" *)

  yyt^.Designator.typeRepr                      := E.TypeOfEntry(yyt^.Designator.Entry);
(* line 2192 "oberon.aecp" *)


  yyt^.Designator.Designations                  := TT.ArgumentCorrection
                                   ( yyt^.Designator.IsCallDesignatorIn
                                   , yyt^.Designator.typeRepr
                                   , yyt^.Designator.endPos
                                   , TT.DesignorToGuardedDesignation
                                                                ( yyt^.Designator.ModuleIn
                                                                , yyt^.Designator.Entry
                                                                , yyt^.Designator.typeRepr
                                                                , yyt^.Designator.Designors
                                                                , yyt^.Designator.Designors)
                                   );
(* line 3882 "oberon.aecp" *)
IF ~( E.IsNotServerEntry(yyt^.Designator.Entry)                                                                         
     OR TT.IsImportingDesignation(yyt^.Designator.Designations)
  ) THEN  ERR.MsgPos(ERR.MsgModulesNotAllowed,yyt^.Designator.Position)
 END;
yyt^.Designator.Designations^.Designations.LevelIn:=yyt^.Designator.LevelIn;
yyt^.Designator.Designations^.Designations.EnvIn:=yyt^.Designator.EnvIn;
(* line 3190 "oberon.aecp" *)
 yyt^.Designator.Designations^.Designations.MainEntryIn := yyt^.Designator.Entry;
(* line 2895 "oberon.aecp" *)

  yyt^.Designator.Designations^.Designations.TempOfsIn        := yyt^.Designator.TempOfsIn;
(* line 2209 "oberon.aecp" *)

  yyt^.Designator.Designations^.Designations.IsWritableIn     := TRUE;
(* line 2189 "oberon.aecp" *)

  yyt^.Designator.valueRepr                     := E.ExprValueOfEntry(yyt^.Designator.Entry);
(* line 2206 "oberon.aecp" *)

  yyt^.Designator.Designations^.Designations.ValueReprIn      := yyt^.Designator.valueRepr;
(* line 2205 "oberon.aecp" *)

  yyt^.Designator.Designations^.Designations.TypeReprIn       := yyt^.Designator.typeRepr;
(* line 2204 "oberon.aecp" *)


  yyt^.Designator.Designations^.Designations.EntryIn          := yyt^.Designator.Entry;
(* line 2208 "oberon.aecp" *)

  yyt^.Designator.Designations^.Designations.EntryPosition    := yyt^.Designator.Position;
(* line 2207 "oberon.aecp" *)

  yyt^.Designator.Designations^.Designations.PrevEntryIn      := OB.cmtEntry;
yyt^.Designator.Designations^.Designations.IsCallDesignatorIn:=yyt^.Designator.IsCallDesignatorIn;
yyt^.Designator.Designations^.Designations.ValDontCareIn:=yyt^.Designator.ValDontCareIn;
yyt^.Designator.Designations^.Designations.TableIn:=yyt^.Designator.TableIn;
yyt^.Designator.Designations^.Designations.ModuleIn:=yyt^.Designator.ModuleIn;
yyVisit1 (yyt^.Designator.Designations);
(* line 2212 "oberon.aecp" *)

  yyt^.Designator.TypeReprOut                   := yyt^.Designator.Designations^.Designations.TypeReprOut;
yyt^.Designator.Designors^.Designors.EnvIn:=yyt^.Designator.EnvIn;
yyt^.Designator.Designors^.Designors.LevelIn:=yyt^.Designator.LevelIn;
yyVisit1 (yyt^.Designator.Designors);
(* line 3191 "oberon.aecp" *)
                   
                                                          yyt^.Designator.MainEntryOut             := yyt^.Designator.Designations^.Designations.MainEntryOut;
(* line 2897 "oberon.aecp" *)
 
  
  yyt^.Designator.TempOfsOut                    := yyt^.Designator.Designations^.Designations.TempOfsOut;
(* line 2214 "oberon.aecp" *)

  yyt^.Designator.IsWritableOut                 := yyt^.Designator.Designations^.Designations.IsWritableOut;
(* line 2213 "oberon.aecp" *)

  yyt^.Designator.ValueReprOut                  := yyt^.Designator.Designations^.Designations.ValueReprOut;
(* line 2211 "oberon.aecp" *)


  yyt^.Designator.EntryOut                      := yyt^.Designator.Designations^.Designations.EntryOut;
(* line 2216 "oberon.aecp" *)
 
  yyt^.Designator.ExprList                      := yyt^.Designator.Designations^.Designations.ExprListOut;
(* line 2215 "oberon.aecp" *)

  yyt^.Designator.SignatureRepr                 := yyt^.Designator.Designations^.Designations.SignatureReprOut;
(* line 3876 "oberon.aecp" *)
IF ~( (E.DeclStatusOfEntry(yyt^.Designator.Entry)=OB.DECLARED)                                                        
  ) THEN  ERR.MsgPos(ERR.MsgUndeclaredIdent,yyt^.Designator.Position)
 END;
(* line 3879 "oberon.aecp" *)
IF ~( E.IsNotTypeEntry(yyt^.Designator.EntryOut)                                                                        
  ) THEN  ERR.MsgPos(ERR.MsgTypeNotAllowed,yyt^.Designator.Position)
 END;
| Tree.Designors:
| Tree.mtDesignor:
| Tree.Designor:
(* line 2485 "oberon.aecp" *)
IF ~( superfluous_application_due_to_warning_suppression ( yyt^.Designor.Nextor        ) ) THEN  
 END;
yyt^.Designor.Nextor^.Designors.EnvIn:=yyt^.Designor.EnvIn;
yyt^.Designor.Nextor^.Designors.LevelIn:=yyt^.Designor.LevelIn;
yyVisit1 (yyt^.Designor.Nextor);
| Tree.Selector:
(* line 2485 "oberon.aecp" *)
IF ~( superfluous_application_due_to_warning_suppression ( yyt^.Selector.Nextor        ) ) THEN  
 END;
yyt^.Selector.Nextor^.Designors.EnvIn:=yyt^.Selector.EnvIn;
yyt^.Selector.Nextor^.Designors.LevelIn:=yyt^.Selector.LevelIn;
yyVisit1 (yyt^.Selector.Nextor);
(* line 2489 "oberon.aecp" *)
IF ~( superfluous_application_due_to_warning_suppression ( yyt^.Selector.OpPos         ) ) THEN  
 END;
(* line 2490 "oberon.aecp" *)
IF ~( superfluous_application_due_to_warning_suppression ( yyt^.Selector.Ident         ) ) THEN  
 END;
(* line 2491 "oberon.aecp" *)
IF ~( superfluous_application_due_to_warning_suppression ( yyt^.Selector.IdPos         ) ) THEN  
 END;
| Tree.Indexor:
(* line 2485 "oberon.aecp" *)
IF ~( superfluous_application_due_to_warning_suppression ( yyt^.Indexor.Nextor        ) ) THEN  
 END;
yyt^.Indexor.ExprList^.ExprLists.EnvIn:=yyt^.Indexor.EnvIn;
(* line 2901 "oberon.aecp" *)

  yyt^.Indexor.ExprList^.ExprLists.TempOfsIn            := 0;
yyt^.Indexor.ExprList^.ExprLists.LevelIn:=yyt^.Indexor.LevelIn;
(* line 2226 "oberon.aecp" *)

  yyt^.Indexor.ExprList^.ExprLists.ClosingPosIn         := POS.NoPosition;
(* line 2225 "oberon.aecp" *)

  yyt^.Indexor.ExprList^.ExprLists.SignatureIn          := OB.cmtObject;
(* line 2224 "oberon.aecp" *)

  yyt^.Indexor.ExprList^.ExprLists.ValDontCareIn        := FALSE;
(* line 2222 "oberon.aecp" *)

  yyt^.Indexor.ExprList^.ExprLists.TableIn              := OB.cmtObject;
(* line 2223 "oberon.aecp" *)

  yyt^.Indexor.ExprList^.ExprLists.ModuleIn             := NIL;
yyVisit1 (yyt^.Indexor.ExprList);
yyt^.Indexor.Nextor^.Designors.EnvIn:=yyt^.Indexor.EnvIn;
yyt^.Indexor.Nextor^.Designors.LevelIn:=yyt^.Indexor.LevelIn;
yyVisit1 (yyt^.Indexor.Nextor);
(* line 2495 "oberon.aecp" *)
IF ~( superfluous_application_due_to_warning_suppression ( yyt^.Indexor.Op1Pos        ) ) THEN  
 END;
(* line 2496 "oberon.aecp" *)
IF ~( superfluous_application_due_to_warning_suppression ( yyt^.Indexor.Op2Pos        ) ) THEN  
 END;
| Tree.Dereferencor:
(* line 2485 "oberon.aecp" *)
IF ~( superfluous_application_due_to_warning_suppression ( yyt^.Dereferencor.Nextor        ) ) THEN  
 END;
yyt^.Dereferencor.Nextor^.Designors.EnvIn:=yyt^.Dereferencor.EnvIn;
yyt^.Dereferencor.Nextor^.Designors.LevelIn:=yyt^.Dereferencor.LevelIn;
yyVisit1 (yyt^.Dereferencor.Nextor);
(* line 2500 "oberon.aecp" *)
IF ~( superfluous_application_due_to_warning_suppression ( yyt^.Dereferencor.OpPos         ) ) THEN  
 END;
| Tree.Argumentor:
(* line 2485 "oberon.aecp" *)
IF ~( superfluous_application_due_to_warning_suppression ( yyt^.Argumentor.Nextor        ) ) THEN  
 END;
yyt^.Argumentor.ExprList^.ExprLists.EnvIn:=yyt^.Argumentor.EnvIn;
(* line 2905 "oberon.aecp" *)

  yyt^.Argumentor.ExprList^.ExprLists.TempOfsIn            := 0;
yyt^.Argumentor.ExprList^.ExprLists.LevelIn:=yyt^.Argumentor.LevelIn;
(* line 2235 "oberon.aecp" *)

  yyt^.Argumentor.ExprList^.ExprLists.ClosingPosIn         := POS.NoPosition;
(* line 2234 "oberon.aecp" *)

  yyt^.Argumentor.ExprList^.ExprLists.SignatureIn          := OB.cmtObject;
(* line 2233 "oberon.aecp" *)

  yyt^.Argumentor.ExprList^.ExprLists.ValDontCareIn        := FALSE;
(* line 2231 "oberon.aecp" *)

  yyt^.Argumentor.ExprList^.ExprLists.TableIn              := OB.cmtObject;
(* line 2232 "oberon.aecp" *)

  yyt^.Argumentor.ExprList^.ExprLists.ModuleIn             := NIL;
yyVisit1 (yyt^.Argumentor.ExprList);
yyt^.Argumentor.Nextor^.Designors.EnvIn:=yyt^.Argumentor.EnvIn;
yyt^.Argumentor.Nextor^.Designors.LevelIn:=yyt^.Argumentor.LevelIn;
yyVisit1 (yyt^.Argumentor.Nextor);
(* line 2504 "oberon.aecp" *)
IF ~( superfluous_application_due_to_warning_suppression ( yyt^.Argumentor.Op1Pos        ) ) THEN  
 END;
(* line 2505 "oberon.aecp" *)
IF ~( superfluous_application_due_to_warning_suppression ( yyt^.Argumentor.Op2Pos        ) ) THEN  
 END;
| Tree.Designations:
(* line 2250 "oberon.aecp" *)

  yyt^.Designations.Entry                         := OB.cmtObject;
yyt^.Designations.MainEntryOut:=yyt^.Designations.MainEntryIn;
yyt^.Designations.TempOfsOut:=yyt^.Designations.TempOfsIn;
(* line 2252 "oberon.aecp" *)
 
  yyt^.Designations.ExprListOut                   := Tree.NoTree;
(* line 2251 "oberon.aecp" *)
 
  yyt^.Designations.SignatureReprOut              := OB.cmtObject;
yyt^.Designations.IsWritableOut:=yyt^.Designations.IsWritableIn;
yyt^.Designations.ValueReprOut:=yyt^.Designations.ValueReprIn;
yyt^.Designations.TypeReprOut:=yyt^.Designations.TypeReprIn;
yyt^.Designations.EntryOut:=yyt^.Designations.EntryIn;
| Tree.mtDesignation:
(* line 2250 "oberon.aecp" *)

  yyt^.mtDesignation.Entry                         := OB.cmtObject;
yyt^.mtDesignation.MainEntryOut:=yyt^.mtDesignation.MainEntryIn;
yyt^.mtDesignation.TempOfsOut:=yyt^.mtDesignation.TempOfsIn;
(* line 2252 "oberon.aecp" *)
 
  yyt^.mtDesignation.ExprListOut                   := Tree.NoTree;
(* line 2251 "oberon.aecp" *)
 
  yyt^.mtDesignation.SignatureReprOut              := OB.cmtObject;
yyt^.mtDesignation.IsWritableOut:=yyt^.mtDesignation.IsWritableIn;
yyt^.mtDesignation.ValueReprOut:=yyt^.mtDesignation.ValueReprIn;
yyt^.mtDesignation.TypeReprOut:=yyt^.mtDesignation.TypeReprIn;
yyt^.mtDesignation.EntryOut:=yyt^.mtDesignation.EntryIn;
| Tree.Designation:
(* line 2250 "oberon.aecp" *)

  yyt^.Designation.Entry                         := OB.cmtObject;
yyt^.Designation.Nextor^.Designors.EnvIn:=yyt^.Designation.EnvIn;
yyt^.Designation.Nextor^.Designors.LevelIn:=yyt^.Designation.LevelIn;
yyVisit1 (yyt^.Designation.Nextor);
(* line 2258 "oberon.aecp" *)

  yyt^.Designation.Nextion                       := Tree.cmtDesignation;
yyt^.Designation.Nextion^.Designations.LevelIn:=yyt^.Designation.LevelIn;
yyt^.Designation.Nextion^.Designations.EnvIn:=yyt^.Designation.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.Designation.Nextion^.Designations.MainEntryIn      := yyt^.Designation.MainEntryIn;
yyt^.Designation.Nextion^.Designations.TempOfsIn:=yyt^.Designation.TempOfsIn;
yyt^.Designation.Nextion^.Designations.IsWritableIn:=yyt^.Designation.IsWritableIn;
yyt^.Designation.Nextion^.Designations.ValueReprIn:=yyt^.Designation.ValueReprIn;
yyt^.Designation.Nextion^.Designations.TypeReprIn:=yyt^.Designation.TypeReprIn;
yyt^.Designation.Nextion^.Designations.EntryIn:=yyt^.Designation.EntryIn;
yyt^.Designation.Nextion^.Designations.EntryPosition:=yyt^.Designation.EntryPosition;
yyt^.Designation.Nextion^.Designations.PrevEntryIn:=yyt^.Designation.PrevEntryIn;
yyt^.Designation.Nextion^.Designations.IsCallDesignatorIn:=yyt^.Designation.IsCallDesignatorIn;
yyt^.Designation.Nextion^.Designations.ValDontCareIn:=yyt^.Designation.ValDontCareIn;
yyt^.Designation.Nextion^.Designations.TableIn:=yyt^.Designation.TableIn;
yyt^.Designation.Nextion^.Designations.ModuleIn:=yyt^.Designation.ModuleIn;
yyVisit1 (yyt^.Designation.Nextion);
(* line 3194 "oberon.aecp" *)

                                                          yyt^.Designation.MainEntryOut             := yyt^.Designation.Nextion^.Designations.MainEntryOut;
yyt^.Designation.TempOfsOut:=yyt^.Designation.Nextion^.Designations.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.Designation.ExprListOut                   := yyt^.Designation.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.Designation.SignatureReprOut              := yyt^.Designation.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.Designation.IsWritableOut                 := yyt^.Designation.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.Designation.ValueReprOut                  := yyt^.Designation.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.Designation.TypeReprOut                   := yyt^.Designation.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.Designation.EntryOut                      := yyt^.Designation.Nextion^.Designations.EntryOut;
| Tree.Importing:
(* line 2273 "oberon.aecp" *)

  yyt^.Importing.Entry                         := E.LookupExtern(yyt^.Importing.EntryIn,yyt^.Importing.Ident);
(* line 3893 "oberon.aecp" *)
IF ~( E.IsExportedEntry(yyt^.Importing.Entry)                                                                           
  ) THEN  ERR.MsgPos(ERR.MsgIdentNotExported,yyt^.Importing.IdPos)
 END;
(* line 2275 "oberon.aecp" *)
 yyt^.Importing.endPos:=yyt^.Importing.IdPos; POS.IncCol(yyt^.Importing.endPos,UTI.IdentLength(yyt^.Importing.Ident)); 
(* line 2274 "oberon.aecp" *)

  yyt^.Importing.typeRepr                      := E.TypeOfEntry(yyt^.Importing.Entry);
(* line 2277 "oberon.aecp" *)


  yyt^.Importing.Nextion                       := TT.ArgumentCorrection
                                   ( yyt^.Importing.IsCallDesignatorIn
                                   , yyt^.Importing.typeRepr
                                   , yyt^.Importing.endPos
                                   , TT.DesignorToDesignation
                                                                ( yyt^.Importing.Entry
                                                                , yyt^.Importing.typeRepr
                                                                , yyt^.Importing.Nextor
                                                                , yyt^.Importing.Nextor)
                                   );
yyt^.Importing.Nextion^.Designations.LevelIn:=yyt^.Importing.LevelIn;
yyt^.Importing.Nextion^.Designations.EnvIn:=yyt^.Importing.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.Importing.Nextion^.Designations.MainEntryIn      := yyt^.Importing.MainEntryIn;
yyt^.Importing.Nextion^.Designations.TempOfsIn:=yyt^.Importing.TempOfsIn;
(* line 2292 "oberon.aecp" *)

  yyt^.Importing.Nextion^.Designations.IsWritableIn          := E.IsWritableEntry(yyt^.Importing.Entry);
(* line 2291 "oberon.aecp" *)

  yyt^.Importing.Nextion^.Designations.ValueReprIn           := E.ExprValueOfEntry(yyt^.Importing.Entry);
(* line 2290 "oberon.aecp" *)

  yyt^.Importing.Nextion^.Designations.TypeReprIn            := yyt^.Importing.typeRepr;
(* line 2289 "oberon.aecp" *)

  yyt^.Importing.Nextion^.Designations.EntryIn               := yyt^.Importing.Entry;
yyt^.Importing.Nextion^.Designations.EntryPosition:=yyt^.Importing.EntryPosition;
(* line 2288 "oberon.aecp" *)


  yyt^.Importing.Nextion^.Designations.PrevEntryIn           := yyt^.Importing.EntryIn;
yyt^.Importing.Nextion^.Designations.IsCallDesignatorIn:=yyt^.Importing.IsCallDesignatorIn;
yyt^.Importing.Nextion^.Designations.ValDontCareIn:=yyt^.Importing.ValDontCareIn;
yyt^.Importing.Nextion^.Designations.TableIn:=yyt^.Importing.TableIn;
yyt^.Importing.Nextion^.Designations.ModuleIn:=yyt^.Importing.ModuleIn;
yyVisit1 (yyt^.Importing.Nextion);
yyt^.Importing.Nextor^.Designors.EnvIn:=yyt^.Importing.EnvIn;
yyt^.Importing.Nextor^.Designors.LevelIn:=yyt^.Importing.LevelIn;
yyVisit1 (yyt^.Importing.Nextor);
(* line 3890 "oberon.aecp" *)
IF ~( (E.DeclStatusOfEntry(yyt^.Importing.Entry)=OB.DECLARED)                                                        
  ) THEN  ERR.MsgPos(ERR.MsgUndeclaredExternIdent,yyt^.Importing.IdPos)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.Importing.MainEntryOut             := yyt^.Importing.Nextion^.Designations.MainEntryOut;
yyt^.Importing.TempOfsOut:=yyt^.Importing.Nextion^.Designations.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.Importing.ExprListOut                   := yyt^.Importing.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.Importing.SignatureReprOut              := yyt^.Importing.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.Importing.IsWritableOut                 := yyt^.Importing.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.Importing.ValueReprOut                  := yyt^.Importing.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.Importing.TypeReprOut                   := yyt^.Importing.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.Importing.EntryOut                      := yyt^.Importing.Nextion^.Designations.EntryOut;
| Tree.Selecting:
(* line 2300 "oberon.aecp" *)

  yyt^.Selecting.Entry                         := T.TypeSelected(yyt^.Selecting.TypeReprIn,yyt^.Selecting.Ident);
(* line 3908 "oberon.aecp" *)
IF ~( ~E.IsExternEntry(yyt^.Selecting.Entry,yyt^.Selecting.ModuleIn)                                                                   
     OR  E.IsExportedEntry(yyt^.Selecting.Entry)
  ) THEN  ERR.MsgPos(ERR.MsgRecordFieldNotExported,yyt^.Selecting.IdPos)
 END;
(* line 2302 "oberon.aecp" *)
 yyt^.Selecting.endPos:=yyt^.Selecting.IdPos; POS.IncCol(yyt^.Selecting.endPos,UTI.IdentLength(yyt^.Selecting.Ident)); 
(* line 2301 "oberon.aecp" *)

  yyt^.Selecting.typeRepr                      := E.TypeOfVarEntry(yyt^.Selecting.Entry);
(* line 2304 "oberon.aecp" *)


  yyt^.Selecting.Nextion                       := TT.ArgumentCorrection
                                   ( yyt^.Selecting.IsCallDesignatorIn
                                   , yyt^.Selecting.typeRepr
                                   , yyt^.Selecting.endPos
                                   , TT.DesignorToGuardedDesignation
                                                                ( yyt^.Selecting.ModuleIn
                                                                , yyt^.Selecting.Entry
                                                                , yyt^.Selecting.typeRepr
                                                                , yyt^.Selecting.Nextor
                                                                , yyt^.Selecting.Nextor)
                                   );
yyt^.Selecting.Nextion^.Designations.LevelIn:=yyt^.Selecting.LevelIn;
yyt^.Selecting.Nextion^.Designations.EnvIn:=yyt^.Selecting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.Selecting.Nextion^.Designations.MainEntryIn      := yyt^.Selecting.MainEntryIn;
yyt^.Selecting.Nextion^.Designations.TempOfsIn:=yyt^.Selecting.TempOfsIn;
(* line 2320 "oberon.aecp" *)

  yyt^.Selecting.Nextion^.Designations.IsWritableIn          := yyt^.Selecting.IsWritableIn                                                          
                                 & (  ~E.IsExternEntry(yyt^.Selecting.Entry,yyt^.Selecting.ModuleIn)                                
                                   OR E.IsWritableEntry(yyt^.Selecting.Entry)
                                   );
(* line 2319 "oberon.aecp" *)

  yyt^.Selecting.Nextion^.Designations.ValueReprIn           := OB.cmtValue;
(* line 2318 "oberon.aecp" *)

  yyt^.Selecting.Nextion^.Designations.TypeReprIn            := yyt^.Selecting.typeRepr;
(* line 2317 "oberon.aecp" *)

  yyt^.Selecting.Nextion^.Designations.EntryIn               := yyt^.Selecting.Entry;
yyt^.Selecting.Nextion^.Designations.EntryPosition:=yyt^.Selecting.EntryPosition;
(* line 2316 "oberon.aecp" *)


  yyt^.Selecting.Nextion^.Designations.PrevEntryIn           := yyt^.Selecting.EntryIn;
yyt^.Selecting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.Selecting.IsCallDesignatorIn;
yyt^.Selecting.Nextion^.Designations.ValDontCareIn:=yyt^.Selecting.ValDontCareIn;
yyt^.Selecting.Nextion^.Designations.TableIn:=yyt^.Selecting.TableIn;
yyt^.Selecting.Nextion^.Designations.ModuleIn:=yyt^.Selecting.ModuleIn;
yyVisit1 (yyt^.Selecting.Nextion);
yyt^.Selecting.Nextor^.Designors.EnvIn:=yyt^.Selecting.EnvIn;
yyt^.Selecting.Nextor^.Designors.LevelIn:=yyt^.Selecting.LevelIn;
yyVisit1 (yyt^.Selecting.Nextor);
(* line 3900 "oberon.aecp" *)
IF ~( T.IsRecordType(yyt^.Selecting.TypeReprIn)                                                                          
      & E.IsVarEntry(yyt^.Selecting.EntryIn)
  ) THEN  ERR.MsgPos(ERR.MsgSelectorNotApplicable,yyt^.Selecting.Position)
 END;
(* line 3904 "oberon.aecp" *)
IF ~( (E.DeclStatusOfEntry(yyt^.Selecting.Entry  )=OB.DECLARED)                                                      
     OR (E.DeclStatusOfEntry(yyt^.Selecting.EntryIn)#OB.DECLARED)
  ) THEN  ERR.MsgPos(ERR.MsgRecordFieldNotFound,yyt^.Selecting.IdPos)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.Selecting.MainEntryOut             := yyt^.Selecting.Nextion^.Designations.MainEntryOut;
yyt^.Selecting.TempOfsOut:=yyt^.Selecting.Nextion^.Designations.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.Selecting.ExprListOut                   := yyt^.Selecting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.Selecting.SignatureReprOut              := yyt^.Selecting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.Selecting.IsWritableOut                 := yyt^.Selecting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.Selecting.ValueReprOut                  := yyt^.Selecting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.Selecting.TypeReprOut                   := yyt^.Selecting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.Selecting.EntryOut                      := yyt^.Selecting.Nextion^.Designations.EntryOut;
| Tree.Indexing:
(* line 2250 "oberon.aecp" *)

  yyt^.Indexing.Entry                         := OB.cmtObject;
yyt^.Indexing.Expr^.Exprs.EnvIn:=yyt^.Indexing.EnvIn;
(* line 2909 "oberon.aecp" *)

  yyt^.Indexing.Expr^.Exprs.TempOfsIn                := yyt^.Indexing.TempOfsIn;
yyt^.Indexing.Expr^.Exprs.LevelIn:=yyt^.Indexing.LevelIn;
yyt^.Indexing.Expr^.Exprs.ValDontCareIn:=yyt^.Indexing.ValDontCareIn;
yyt^.Indexing.Expr^.Exprs.TableIn:=yyt^.Indexing.TableIn;
yyt^.Indexing.Expr^.Exprs.ModuleIn:=yyt^.Indexing.ModuleIn;
yyVisit1 (yyt^.Indexing.Expr);
(* line 2332 "oberon.aecp" *)
 yyt^.Indexing.endPos:=yyt^.Indexing.Op2Pos; POS.IncCol(yyt^.Indexing.endPos,1); 
(* line 2331 "oberon.aecp" *)

  yyt^.Indexing.ElemTypeRepr                  := T.TypeIndexed(yyt^.Indexing.TypeReprIn);
(* line 2330 "oberon.aecp" *)

  yyt^.Indexing.Len                           := T.LenOfArrayType(yyt^.Indexing.TypeReprIn);
(* line 3923 "oberon.aecp" *)
IF ~( yyt^.Indexing.ValDontCareIn                                                                                          
     OR V.IsLegalArrayIndex(yyt^.Indexing.Expr^.Exprs.ValueReprOut,yyt^.Indexing.Len)                                                          
  ) THEN  ERR.MsgPos(ERR.MsgIndexOutOfBounds,yyt^.Indexing.Expr^.Exprs.Position)
 END;
(* line 2334 "oberon.aecp" *)


  yyt^.Indexing.Nextion                       := TT.ArgumentCorrection
                                   ( yyt^.Indexing.IsCallDesignatorIn
                                   , yyt^.Indexing.ElemTypeRepr
                                   , yyt^.Indexing.endPos
                                   , TT.DesignorToGuardedDesignation
                                                                ( yyt^.Indexing.ModuleIn
                                                                , yyt^.Indexing.EntryIn
                                                                , yyt^.Indexing.ElemTypeRepr
                                                                , yyt^.Indexing.Nextor
                                                                , yyt^.Indexing.Nextor)
                                   );
yyt^.Indexing.Nextion^.Designations.LevelIn:=yyt^.Indexing.LevelIn;
yyt^.Indexing.Nextion^.Designations.EnvIn:=yyt^.Indexing.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.Indexing.Nextion^.Designations.MainEntryIn      := yyt^.Indexing.MainEntryIn;
(* line 2910 "oberon.aecp" *)
 
  yyt^.Indexing.Nextion^.Designations.TempOfsIn             := yyt^.Indexing.TempOfsIn;
(* line 2349 "oberon.aecp" *)

  yyt^.Indexing.Nextion^.Designations.IsWritableIn          := yyt^.Indexing.IsWritableIn;
(* line 2348 "oberon.aecp" *)

  yyt^.Indexing.Nextion^.Designations.ValueReprIn           := OB.cmtValue;
(* line 2347 "oberon.aecp" *)

  yyt^.Indexing.Nextion^.Designations.TypeReprIn            := yyt^.Indexing.ElemTypeRepr;
(* line 2346 "oberon.aecp" *)


  yyt^.Indexing.Nextion^.Designations.EntryIn               := yyt^.Indexing.EntryIn;
yyt^.Indexing.Nextion^.Designations.EntryPosition:=yyt^.Indexing.EntryPosition;
yyt^.Indexing.Nextion^.Designations.PrevEntryIn:=yyt^.Indexing.PrevEntryIn;
yyt^.Indexing.Nextion^.Designations.IsCallDesignatorIn:=yyt^.Indexing.IsCallDesignatorIn;
yyt^.Indexing.Nextion^.Designations.ValDontCareIn:=yyt^.Indexing.ValDontCareIn;
yyt^.Indexing.Nextion^.Designations.TableIn:=yyt^.Indexing.TableIn;
yyt^.Indexing.Nextion^.Designations.ModuleIn:=yyt^.Indexing.ModuleIn;
yyVisit1 (yyt^.Indexing.Nextion);
yyt^.Indexing.Nextor^.Designors.EnvIn:=yyt^.Indexing.EnvIn;
yyt^.Indexing.Nextor^.Designors.LevelIn:=yyt^.Indexing.LevelIn;
yyVisit1 (yyt^.Indexing.Nextor);
(* line 3916 "oberon.aecp" *)
IF ~( T.IsArrayType(yyt^.Indexing.TypeReprIn)                                                                              
      & E.IsVarEntry(yyt^.Indexing.EntryIn)
  ) THEN  ERR.MsgPos(ERR.MsgIndexNotApplicable,yyt^.Indexing.Position)
 END;
(* line 3920 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.Indexing.Expr^.Exprs.TypeReprOut)                                                                      
  ) THEN  ERR.MsgPos(ERR.MsgInvalidExprType,yyt^.Indexing.Expr^.Exprs.Position)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.Indexing.MainEntryOut             := yyt^.Indexing.Nextion^.Designations.MainEntryOut;
(* line 2912 "oberon.aecp" *)
 

  yyt^.Indexing.TempOfsOut                    := ADR.MinSize2(yyt^.Indexing.Expr^.Exprs.TempOfsOut,yyt^.Indexing.Nextion^.Designations.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.Indexing.ExprListOut                   := yyt^.Indexing.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.Indexing.SignatureReprOut              := yyt^.Indexing.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.Indexing.IsWritableOut                 := yyt^.Indexing.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.Indexing.ValueReprOut                  := yyt^.Indexing.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.Indexing.TypeReprOut                   := yyt^.Indexing.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.Indexing.EntryOut                      := yyt^.Indexing.Nextion^.Designations.EntryOut;
| Tree.Dereferencing:
(* line 2250 "oberon.aecp" *)

  yyt^.Dereferencing.Entry                         := OB.cmtObject;
(* line 2355 "oberon.aecp" *)

  yyt^.Dereferencing.BaseTypeRepr                  := T.TypeDereferenced(yyt^.Dereferencing.TypeReprIn);
(* line 3931 "oberon.aecp" *)
IF ~( T.IsPointerType(yyt^.Dereferencing.TypeReprIn)                                                                          
      & E.IsVarEntry(yyt^.Dereferencing.EntryIn)
  ) THEN  ERR.MsgPos(ERR.MsgDerefNotApplicable,yyt^.Dereferencing.Position)
 END;
(* line 2357 "oberon.aecp" *)


  yyt^.Dereferencing.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.Dereferencing.EntryIn
                                   , yyt^.Dereferencing.BaseTypeRepr
                                   , yyt^.Dereferencing.Nextor
                                   , yyt^.Dereferencing.Nextor);
yyt^.Dereferencing.Nextion^.Designations.LevelIn:=yyt^.Dereferencing.LevelIn;
yyt^.Dereferencing.Nextion^.Designations.EnvIn:=yyt^.Dereferencing.EnvIn;
(* line 3195 "oberon.aecp" *)
 yyt^.Dereferencing.Nextion^.Designations.MainEntryIn      := OB.cmtEntry;
yyt^.Dereferencing.Nextion^.Designations.TempOfsIn:=yyt^.Dereferencing.TempOfsIn;
(* line 2366 "oberon.aecp" *)

  yyt^.Dereferencing.Nextion^.Designations.IsWritableIn          := TRUE;
(* line 2365 "oberon.aecp" *)

  yyt^.Dereferencing.Nextion^.Designations.ValueReprIn           := OB.cmtValue;
(* line 2364 "oberon.aecp" *)

  yyt^.Dereferencing.Nextion^.Designations.TypeReprIn            := yyt^.Dereferencing.BaseTypeRepr;
(* line 2363 "oberon.aecp" *)


  yyt^.Dereferencing.Nextion^.Designations.EntryIn               := yyt^.Dereferencing.EntryIn;
yyt^.Dereferencing.Nextion^.Designations.EntryPosition:=yyt^.Dereferencing.EntryPosition;
yyt^.Dereferencing.Nextion^.Designations.PrevEntryIn:=yyt^.Dereferencing.PrevEntryIn;
yyt^.Dereferencing.Nextion^.Designations.IsCallDesignatorIn:=yyt^.Dereferencing.IsCallDesignatorIn;
yyt^.Dereferencing.Nextion^.Designations.ValDontCareIn:=yyt^.Dereferencing.ValDontCareIn;
yyt^.Dereferencing.Nextion^.Designations.TableIn:=yyt^.Dereferencing.TableIn;
yyt^.Dereferencing.Nextion^.Designations.ModuleIn:=yyt^.Dereferencing.ModuleIn;
yyVisit1 (yyt^.Dereferencing.Nextion);
yyt^.Dereferencing.Nextor^.Designors.EnvIn:=yyt^.Dereferencing.EnvIn;
yyt^.Dereferencing.Nextor^.Designors.LevelIn:=yyt^.Dereferencing.LevelIn;
yyVisit1 (yyt^.Dereferencing.Nextor);
(* line 3194 "oberon.aecp" *)

                                                          yyt^.Dereferencing.MainEntryOut             := yyt^.Dereferencing.Nextion^.Designations.MainEntryOut;
yyt^.Dereferencing.TempOfsOut:=yyt^.Dereferencing.Nextion^.Designations.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.Dereferencing.ExprListOut                   := yyt^.Dereferencing.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.Dereferencing.SignatureReprOut              := yyt^.Dereferencing.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.Dereferencing.IsWritableOut                 := yyt^.Dereferencing.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.Dereferencing.ValueReprOut                  := yyt^.Dereferencing.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.Dereferencing.TypeReprOut                   := yyt^.Dereferencing.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.Dereferencing.EntryOut                      := yyt^.Dereferencing.Nextion^.Designations.EntryOut;
| Tree.Supering:
(* line 2374 "oberon.aecp" *)

  yyt^.Supering.Entry                         := yyt^.Supering.EntryIn;
(* line 3940 "oberon.aecp" *)

  yyt^.Supering.isReceiver := E.IsReceiverEntry(yyt^.Supering.PrevEntryIn);
(* line 2377 "oberon.aecp" *)
 yyt^.Supering.endPos:=yyt^.Supering.Position; POS.IncCol(yyt^.Supering.endPos,1); 
(* line 2376 "oberon.aecp" *)
 
  yyt^.Supering.baseTypeRepr                  := T.RecordBaseTypeOfType(E.ReceiverTypeOfBoundProc(yyt^.Supering.EntryIn));
(* line 2375 "oberon.aecp" *)
 
  yyt^.Supering.RcvEntry                      := yyt^.Supering.PrevEntryIn;
(* line 3945 "oberon.aecp" *)
IF ~( ~yyt^.Supering.isReceiver                                                                                       
     OR T.IsExistingBoundProc(yyt^.Supering.ModuleIn,yyt^.Supering.baseTypeRepr,yyt^.Supering.EntryIn)
  ) THEN  ERR.MsgPos(ERR.MsgMissingRedefined,yyt^.Supering.Position)
 END;
(* line 2379 "oberon.aecp" *)


  yyt^.Supering.Nextion                       := TT.ArgumentCorrection
                                   ( yyt^.Supering.IsCallDesignatorIn
                                   , yyt^.Supering.TypeReprIn
                                   , yyt^.Supering.endPos
                                   , TT.DesignorToDesignation
                                                                ( yyt^.Supering.EntryIn
                                                                , yyt^.Supering.TypeReprIn
                                                                , yyt^.Supering.Nextor
                                                                , yyt^.Supering.Nextor)
                                   );
yyt^.Supering.Nextion^.Designations.EnvIn:=yyt^.Supering.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.Supering.Nextion^.Designations.MainEntryIn      := yyt^.Supering.MainEntryIn;
yyt^.Supering.Nextion^.Designations.TempOfsIn:=yyt^.Supering.TempOfsIn;
(* line 2393 "oberon.aecp" *)

  yyt^.Supering.Nextion^.Designations.IsWritableIn          := yyt^.Supering.IsWritableIn;
(* line 2392 "oberon.aecp" *)

  yyt^.Supering.Nextion^.Designations.ValueReprIn           := OB.cmtValue;
(* line 2391 "oberon.aecp" *)

  yyt^.Supering.Nextion^.Designations.TypeReprIn            := yyt^.Supering.TypeReprIn;
(* line 2390 "oberon.aecp" *)


  yyt^.Supering.Nextion^.Designations.EntryIn               := yyt^.Supering.EntryIn;
yyt^.Supering.Nextion^.Designations.EntryPosition:=yyt^.Supering.EntryPosition;
yyt^.Supering.Nextion^.Designations.PrevEntryIn:=yyt^.Supering.PrevEntryIn;
yyt^.Supering.Nextion^.Designations.IsCallDesignatorIn:=yyt^.Supering.IsCallDesignatorIn;
yyt^.Supering.Nextion^.Designations.ValDontCareIn:=yyt^.Supering.ValDontCareIn;
yyt^.Supering.Nextion^.Designations.TableIn:=yyt^.Supering.TableIn;
yyt^.Supering.Nextion^.Designations.ModuleIn:=yyt^.Supering.ModuleIn;
yyt^.Supering.Nextion^.Designations.LevelIn:=yyt^.Supering.LevelIn;
yyVisit1 (yyt^.Supering.Nextion);
yyt^.Supering.Nextor^.Designors.EnvIn:=yyt^.Supering.EnvIn;
yyt^.Supering.Nextor^.Designors.LevelIn:=yyt^.Supering.LevelIn;
yyVisit1 (yyt^.Supering.Nextor);
(* line 3942 "oberon.aecp" *)
IF ~( yyt^.Supering.isReceiver                                                                                        
  ) THEN  ERR.MsgPos(ERR.MsgNonReceiverSupered,yyt^.Supering.Position)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.Supering.MainEntryOut             := yyt^.Supering.Nextion^.Designations.MainEntryOut;
yyt^.Supering.TempOfsOut:=yyt^.Supering.Nextion^.Designations.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.Supering.ExprListOut                   := yyt^.Supering.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.Supering.SignatureReprOut              := yyt^.Supering.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.Supering.IsWritableOut                 := yyt^.Supering.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.Supering.ValueReprOut                  := yyt^.Supering.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.Supering.TypeReprOut                   := yyt^.Supering.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.Supering.EntryOut                      := yyt^.Supering.Nextion^.Designations.EntryOut;
| Tree.Argumenting:
(* line 2400 "oberon.aecp" *)

  yyt^.Argumenting.Entry                         := yyt^.Argumenting.EntryIn;
yyt^.Argumenting.ExprList^.ExprLists.EnvIn:=yyt^.Argumenting.EnvIn;
(* line 2916 "oberon.aecp" *)

  yyt^.Argumenting.ExprList^.ExprLists.TempOfsIn            := yyt^.Argumenting.TempOfsIn;
yyt^.Argumenting.ExprList^.ExprLists.LevelIn:=yyt^.Argumenting.LevelIn;
(* line 2413 "oberon.aecp" *)

  yyt^.Argumenting.ExprList^.ExprLists.ClosingPosIn         := yyt^.Argumenting.Op2Pos;
(* line 2410 "oberon.aecp" *)


  yyt^.Argumenting.signature                     := SI.SignatureOfProcType(yyt^.Argumenting.TypeReprIn);
(* line 2412 "oberon.aecp" *)


  yyt^.Argumenting.ExprList^.ExprLists.SignatureIn          := yyt^.Argumenting.signature;
yyt^.Argumenting.ExprList^.ExprLists.ValDontCareIn:=yyt^.Argumenting.ValDontCareIn;
yyt^.Argumenting.ExprList^.ExprLists.TableIn:=yyt^.Argumenting.TableIn;
yyt^.Argumenting.ExprList^.ExprLists.ModuleIn:=yyt^.Argumenting.ModuleIn;
yyVisit1 (yyt^.Argumenting.ExprList);
(* line 3954 "oberon.aecp" *)

  yyt^.Argumenting.isBoundProc := E.IsBoundProcEntry(yyt^.Argumenting.EntryIn);
(* line 2401 "oberon.aecp" *)
 
  yyt^.Argumenting.ProcTypeRepr                  := yyt^.Argumenting.TypeReprIn;
(* line 3963 "oberon.aecp" *)
IF ~( ~yyt^.Argumenting.isBoundProc
     OR T.IsRecordType(E.ReceiverTypeOfBoundProc(yyt^.Argumenting.EntryIn))
     OR T.IsPointerOrArrayOfPointerType(E.TypeOfEntry(yyt^.Argumenting.PrevEntryIn))
  ) THEN  ERR.MsgPos(ERR.MsgReceiverParamNotPointer,yyt^.Argumenting.Position)
 END;
(* line 2404 "oberon.aecp" *)
 

  yyt^.Argumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.Argumenting.EntryIn
                                   , yyt^.Argumenting.TypeReprIn
                                   , yyt^.Argumenting.Nextor
                                   , yyt^.Argumenting.Nextor);
yyt^.Argumenting.Nextion^.Designations.EnvIn:=yyt^.Argumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.Argumenting.Nextion^.Designations.MainEntryIn      := yyt^.Argumenting.MainEntryIn;
yyt^.Argumenting.Nextion^.Designations.TempOfsIn:=yyt^.Argumenting.TempOfsIn;
(* line 2418 "oberon.aecp" *)

  yyt^.Argumenting.Nextion^.Designations.IsWritableIn          := yyt^.Argumenting.IsWritableIn;
(* line 2417 "oberon.aecp" *)

  yyt^.Argumenting.Nextion^.Designations.ValueReprIn           := OB.cmtValue;
(* line 2416 "oberon.aecp" *)

  yyt^.Argumenting.Nextion^.Designations.TypeReprIn            := T.TypeArgumented(yyt^.Argumenting.TypeReprIn);
(* line 2415 "oberon.aecp" *)


  yyt^.Argumenting.Nextion^.Designations.EntryIn               := yyt^.Argumenting.EntryIn;
yyt^.Argumenting.Nextion^.Designations.EntryPosition:=yyt^.Argumenting.EntryPosition;
yyt^.Argumenting.Nextion^.Designations.PrevEntryIn:=yyt^.Argumenting.PrevEntryIn;
yyt^.Argumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.Argumenting.IsCallDesignatorIn;
yyt^.Argumenting.Nextion^.Designations.ValDontCareIn:=yyt^.Argumenting.ValDontCareIn;
yyt^.Argumenting.Nextion^.Designations.TableIn:=yyt^.Argumenting.TableIn;
yyt^.Argumenting.Nextion^.Designations.ModuleIn:=yyt^.Argumenting.ModuleIn;
yyt^.Argumenting.Nextion^.Designations.LevelIn:=yyt^.Argumenting.LevelIn;
yyVisit1 (yyt^.Argumenting.Nextion);
yyt^.Argumenting.Nextor^.Designors.EnvIn:=yyt^.Argumenting.EnvIn;
yyt^.Argumenting.Nextor^.Designors.LevelIn:=yyt^.Argumenting.LevelIn;
yyVisit1 (yyt^.Argumenting.Nextor);
(* line 2402 "oberon.aecp" *)
 
  yyt^.Argumenting.RcvEntry                      := yyt^.Argumenting.PrevEntryIn;
 IF yyt^.Argumenting.isBoundProc & T.IsRecordType(T.ElemTypeOfArrayType(E.TypeOfEntry(yyt^.Argumenting.PrevEntryIn))) THEN
                                  E.SetLaccess(yyt^.Argumenting.MainEntryIn);
                               END; ;
 E.InclEnvLevel(yyt^.Argumenting.EnvIn,E.LevelOfProcEntry(yyt^.Argumenting.EntryIn));
(* line 3956 "oberon.aecp" *)
IF ~( T.IsProcedureType(yyt^.Argumenting.TypeReprIn)                                                                  
      & (  E.IsVarEntry(yyt^.Argumenting.EntryIn)
        OR E.IsProcedureEntry(yyt^.Argumenting.EntryIn)
        OR yyt^.Argumenting.isBoundProc
        )
  ) THEN  ERR.MsgPos(ERR.MsgArgumentsNotAllowed,yyt^.Argumenting.Position)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.Argumenting.MainEntryOut             := yyt^.Argumenting.Nextion^.Designations.MainEntryOut;
(* line 2918 "oberon.aecp" *)
 

  yyt^.Argumenting.TempOfsOut                    := yyt^.Argumenting.ExprList^.ExprLists.TempOfsOut;
(* line 2421 "oberon.aecp" *)
 
  yyt^.Argumenting.ExprListOut                   := yyt^.Argumenting.ExprList;
(* line 2420 "oberon.aecp" *)

  
  yyt^.Argumenting.SignatureReprOut              := yyt^.Argumenting.signature;
(* line 2263 "oberon.aecp" *)

  yyt^.Argumenting.IsWritableOut                 := yyt^.Argumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.Argumenting.ValueReprOut                  := yyt^.Argumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.Argumenting.TypeReprOut                   := yyt^.Argumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.Argumenting.EntryOut                      := yyt^.Argumenting.Nextion^.Designations.EntryOut;
| Tree.Guarding:
(* line 2250 "oberon.aecp" *)

  yyt^.Guarding.Entry                         := OB.cmtObject;
yyt^.Guarding.Qualidents^.Qualidents.TableIn:=yyt^.Guarding.TableIn;
yyt^.Guarding.Qualidents^.Qualidents.ModuleIn:=yyt^.Guarding.ModuleIn;
yyVisit1 (yyt^.Guarding.Qualidents);
(* line 2428 "oberon.aecp" *)
 IF yyt^.Guarding.IsImplicit THEN 
                                        yyt^.Guarding.TestTypeRepr := yyt^.Guarding.TypeReprIn;
                                     ELSE
                                        yyt^.Guarding.TestTypeRepr := E.TypeOfTypeEntry(yyt^.Guarding.Qualidents^.Qualidents.EntryOut);
                                     END;
                                   
(* line 2427 "oberon.aecp" *)

  yyt^.Guarding.StaticTypeRepr                := yyt^.Guarding.TypeReprIn;
(* line 3975 "oberon.aecp" *)
IF ~( (yyt^.Guarding.Position.Line=0)                                                           
     OR (    ( E.IsVarParamEntry(yyt^.Guarding.EntryIn   )                                                              
             & T.IsRecordType   (yyt^.Guarding.TypeReprIn))
          OR   T.IsPointerType  (yyt^.Guarding.TypeReprIn)
        )
      & T.IsExtensionOf(yyt^.Guarding.TestTypeRepr,yyt^.Guarding.TypeReprIn)
  ) THEN  ERR.MsgPos(ERR.MsgGuardNotApplicable,yyt^.Guarding.Position)
 END;
(* line 2435 "oberon.aecp" *)


  yyt^.Guarding.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.Guarding.EntryIn
                                   , yyt^.Guarding.TypeReprIn
                                   , yyt^.Guarding.Nextor
                                   , yyt^.Guarding.Nextor);
yyt^.Guarding.Nextion^.Designations.EnvIn:=yyt^.Guarding.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.Guarding.Nextion^.Designations.MainEntryIn      := yyt^.Guarding.MainEntryIn;
yyt^.Guarding.Nextion^.Designations.TempOfsIn:=yyt^.Guarding.TempOfsIn;
(* line 2444 "oberon.aecp" *)

  yyt^.Guarding.Nextion^.Designations.IsWritableIn          := yyt^.Guarding.IsWritableIn;
(* line 2443 "oberon.aecp" *)
                                                                   
  yyt^.Guarding.Nextion^.Designations.ValueReprIn           := OB.cmtValue;
(* line 2442 "oberon.aecp" *)

  yyt^.Guarding.Nextion^.Designations.TypeReprIn            := yyt^.Guarding.TestTypeRepr;
(* line 2441 "oberon.aecp" *)


  yyt^.Guarding.Nextion^.Designations.EntryIn               := yyt^.Guarding.EntryIn;
yyt^.Guarding.Nextion^.Designations.EntryPosition:=yyt^.Guarding.EntryPosition;
yyt^.Guarding.Nextion^.Designations.PrevEntryIn:=yyt^.Guarding.PrevEntryIn;
yyt^.Guarding.Nextion^.Designations.IsCallDesignatorIn:=yyt^.Guarding.IsCallDesignatorIn;
yyt^.Guarding.Nextion^.Designations.ValDontCareIn:=yyt^.Guarding.ValDontCareIn;
yyt^.Guarding.Nextion^.Designations.TableIn:=yyt^.Guarding.TableIn;
yyt^.Guarding.Nextion^.Designations.ModuleIn:=yyt^.Guarding.ModuleIn;
yyt^.Guarding.Nextion^.Designations.LevelIn:=yyt^.Guarding.LevelIn;
yyVisit1 (yyt^.Guarding.Nextion);
yyt^.Guarding.Nextor^.Designors.EnvIn:=yyt^.Guarding.EnvIn;
yyt^.Guarding.Nextor^.Designors.LevelIn:=yyt^.Guarding.LevelIn;
yyVisit1 (yyt^.Guarding.Nextor);
(* line 3972 "oberon.aecp" *)
IF ~( E.IsTypeEntry(yyt^.Guarding.Qualidents^.Qualidents.EntryOut)                                                                
  ) THEN  ERR.MsgPos(ERR.MsgTypeExpected,yyt^.Guarding.Qualidents^.Qualidents.Position)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.Guarding.MainEntryOut             := yyt^.Guarding.Nextion^.Designations.MainEntryOut;
yyt^.Guarding.TempOfsOut:=yyt^.Guarding.Nextion^.Designations.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.Guarding.ExprListOut                   := yyt^.Guarding.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.Guarding.SignatureReprOut              := yyt^.Guarding.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.Guarding.IsWritableOut                 := yyt^.Guarding.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.Guarding.ValueReprOut                  := yyt^.Guarding.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.Guarding.TypeReprOut                   := yyt^.Guarding.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.Guarding.EntryOut                      := yyt^.Guarding.Nextion^.Designations.EntryOut;
| Tree.PredeclArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.PredeclArgumenting.Entry                         := OB.cmtObject;
yyt^.PredeclArgumenting.Nextor^.Designors.EnvIn:=yyt^.PredeclArgumenting.EnvIn;
yyt^.PredeclArgumenting.Nextor^.Designors.LevelIn:=yyt^.PredeclArgumenting.LevelIn;
yyVisit1 (yyt^.PredeclArgumenting.Nextor);
(* line 4035 "oberon.aecp" *)

  yyt^.PredeclArgumenting.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.PredeclArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.PredeclArgumenting.EntryIn
                                   , yyt^.PredeclArgumenting.typeRepr
                                   , yyt^.PredeclArgumenting.Nextor
                                   , yyt^.PredeclArgumenting.Nextor);
yyt^.PredeclArgumenting.Nextion^.Designations.LevelIn:=yyt^.PredeclArgumenting.LevelIn;
yyt^.PredeclArgumenting.Nextion^.Designations.EnvIn:=yyt^.PredeclArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.PredeclArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.PredeclArgumenting.MainEntryIn;
yyt^.PredeclArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.PredeclArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.PredeclArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.PredeclArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.PredeclArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.PredeclArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.PredeclArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.PredeclArgumenting.typeRepr
                                   , yyt^.PredeclArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.PredeclArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.PredeclArgumenting.Nextion^.Designations.EntryPosition:=yyt^.PredeclArgumenting.EntryPosition;
yyt^.PredeclArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.PredeclArgumenting.PrevEntryIn;
yyt^.PredeclArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.PredeclArgumenting.IsCallDesignatorIn;
yyt^.PredeclArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.PredeclArgumenting.ValDontCareIn;
yyt^.PredeclArgumenting.Nextion^.Designations.TableIn:=yyt^.PredeclArgumenting.TableIn;
yyt^.PredeclArgumenting.Nextion^.Designations.ModuleIn:=yyt^.PredeclArgumenting.ModuleIn;
yyVisit1 (yyt^.PredeclArgumenting.Nextion);
(* line 3194 "oberon.aecp" *)

                                                          yyt^.PredeclArgumenting.MainEntryOut             := yyt^.PredeclArgumenting.Nextion^.Designations.MainEntryOut;
yyt^.PredeclArgumenting.TempOfsOut:=yyt^.PredeclArgumenting.Nextion^.Designations.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.PredeclArgumenting.ExprListOut                   := yyt^.PredeclArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.PredeclArgumenting.SignatureReprOut              := yyt^.PredeclArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.PredeclArgumenting.IsWritableOut                 := yyt^.PredeclArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.PredeclArgumenting.ValueReprOut                  := yyt^.PredeclArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.PredeclArgumenting.TypeReprOut                   := yyt^.PredeclArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.PredeclArgumenting.EntryOut                      := yyt^.PredeclArgumenting.Nextion^.Designations.EntryOut;
| Tree.PredeclArgumenting1:
(* line 2250 "oberon.aecp" *)

  yyt^.PredeclArgumenting1.Entry                         := OB.cmtObject;
(* line 4058 "oberon.aecp" *)
IF ~( ~TT.IsEmptyExpr(yyt^.PredeclArgumenting1.Expr)                                                                     
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.PredeclArgumenting1.Op2Pos)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.PredeclArgumenting1.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.PredeclArgumenting1.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.PredeclArgumenting1.EntryIn
                                   , yyt^.PredeclArgumenting1.typeRepr
                                   , yyt^.PredeclArgumenting1.Nextor
                                   , yyt^.PredeclArgumenting1.Nextor);
yyt^.PredeclArgumenting1.Nextion^.Designations.LevelIn:=yyt^.PredeclArgumenting1.LevelIn;
yyt^.PredeclArgumenting1.Nextion^.Designations.EnvIn:=yyt^.PredeclArgumenting1.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.PredeclArgumenting1.Nextion^.Designations.MainEntryIn      := yyt^.PredeclArgumenting1.MainEntryIn;
yyt^.PredeclArgumenting1.Nextion^.Designations.TempOfsIn:=yyt^.PredeclArgumenting1.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.PredeclArgumenting1.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.PredeclArgumenting1.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.PredeclArgumenting1.Nextion^.Designations.ValueReprIn           := yyt^.PredeclArgumenting1.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.PredeclArgumenting1.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.PredeclArgumenting1.typeRepr
                                   , yyt^.PredeclArgumenting1.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.PredeclArgumenting1.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.PredeclArgumenting1.Nextion^.Designations.EntryPosition:=yyt^.PredeclArgumenting1.EntryPosition;
yyt^.PredeclArgumenting1.Nextion^.Designations.PrevEntryIn:=yyt^.PredeclArgumenting1.PrevEntryIn;
yyt^.PredeclArgumenting1.Nextion^.Designations.IsCallDesignatorIn:=yyt^.PredeclArgumenting1.IsCallDesignatorIn;
yyt^.PredeclArgumenting1.Nextion^.Designations.ValDontCareIn:=yyt^.PredeclArgumenting1.ValDontCareIn;
yyt^.PredeclArgumenting1.Nextion^.Designations.TableIn:=yyt^.PredeclArgumenting1.TableIn;
yyt^.PredeclArgumenting1.Nextion^.Designations.ModuleIn:=yyt^.PredeclArgumenting1.ModuleIn;
yyVisit1 (yyt^.PredeclArgumenting1.Nextion);
yyt^.PredeclArgumenting1.ExprLists^.ExprLists.EnvIn:=yyt^.PredeclArgumenting1.EnvIn;
(* line 2923 "oberon.aecp" *)
 
  yyt^.PredeclArgumenting1.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.PredeclArgumenting1.ExprLists^.ExprLists.LevelIn:=yyt^.PredeclArgumenting1.LevelIn;
(* line 4056 "oberon.aecp" *)

  yyt^.PredeclArgumenting1.ExprLists^.ExprLists.ClosingPosIn        := yyt^.PredeclArgumenting1.Op2Pos;
(* line 4055 "oberon.aecp" *)

  yyt^.PredeclArgumenting1.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.PredeclArgumenting1.ExprLists^.ExprLists.ValDontCareIn:=yyt^.PredeclArgumenting1.ValDontCareIn;
yyt^.PredeclArgumenting1.ExprLists^.ExprLists.TableIn:=yyt^.PredeclArgumenting1.TableIn;
yyt^.PredeclArgumenting1.ExprLists^.ExprLists.ModuleIn:=yyt^.PredeclArgumenting1.ModuleIn;
yyVisit1 (yyt^.PredeclArgumenting1.ExprLists);
yyt^.PredeclArgumenting1.Expr^.Exprs.EnvIn:=yyt^.PredeclArgumenting1.EnvIn;
(* line 2922 "oberon.aecp" *)

  yyt^.PredeclArgumenting1.Expr^.Exprs.TempOfsIn                := yyt^.PredeclArgumenting1.TempOfsIn;
yyt^.PredeclArgumenting1.Expr^.Exprs.LevelIn:=yyt^.PredeclArgumenting1.LevelIn;
yyt^.PredeclArgumenting1.Expr^.Exprs.ValDontCareIn:=yyt^.PredeclArgumenting1.ValDontCareIn;
yyt^.PredeclArgumenting1.Expr^.Exprs.TableIn:=yyt^.PredeclArgumenting1.TableIn;
yyt^.PredeclArgumenting1.Expr^.Exprs.ModuleIn:=yyt^.PredeclArgumenting1.ModuleIn;
yyVisit1 (yyt^.PredeclArgumenting1.Expr);
yyt^.PredeclArgumenting1.Nextor^.Designors.EnvIn:=yyt^.PredeclArgumenting1.EnvIn;
yyt^.PredeclArgumenting1.Nextor^.Designors.LevelIn:=yyt^.PredeclArgumenting1.LevelIn;
yyVisit1 (yyt^.PredeclArgumenting1.Nextor);
(* line 3194 "oberon.aecp" *)

                                                          yyt^.PredeclArgumenting1.MainEntryOut             := yyt^.PredeclArgumenting1.Nextion^.Designations.MainEntryOut;
(* line 2925 "oberon.aecp" *)
 

  yyt^.PredeclArgumenting1.TempOfsOut                    := yyt^.PredeclArgumenting1.Expr^.Exprs.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.PredeclArgumenting1.ExprListOut                   := yyt^.PredeclArgumenting1.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.PredeclArgumenting1.SignatureReprOut              := yyt^.PredeclArgumenting1.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.PredeclArgumenting1.IsWritableOut                 := yyt^.PredeclArgumenting1.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.PredeclArgumenting1.ValueReprOut                  := yyt^.PredeclArgumenting1.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.PredeclArgumenting1.TypeReprOut                   := yyt^.PredeclArgumenting1.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.PredeclArgumenting1.EntryOut                      := yyt^.PredeclArgumenting1.Nextion^.Designations.EntryOut;
| Tree.AbsArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.AbsArgumenting.Entry                         := OB.cmtObject;
yyt^.AbsArgumenting.Expr^.Exprs.EnvIn:=yyt^.AbsArgumenting.EnvIn;
(* line 2922 "oberon.aecp" *)

  yyt^.AbsArgumenting.Expr^.Exprs.TempOfsIn                := yyt^.AbsArgumenting.TempOfsIn;
yyt^.AbsArgumenting.Expr^.Exprs.LevelIn:=yyt^.AbsArgumenting.LevelIn;
yyt^.AbsArgumenting.Expr^.Exprs.ValDontCareIn:=yyt^.AbsArgumenting.ValDontCareIn;
yyt^.AbsArgumenting.Expr^.Exprs.TableIn:=yyt^.AbsArgumenting.TableIn;
yyt^.AbsArgumenting.Expr^.Exprs.ModuleIn:=yyt^.AbsArgumenting.ModuleIn;
yyVisit1 (yyt^.AbsArgumenting.Expr);
(* line 4058 "oberon.aecp" *)
IF ~( ~TT.IsEmptyExpr(yyt^.AbsArgumenting.Expr)                                                                     
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.AbsArgumenting.Op2Pos)
 END;
(* line 4066 "oberon.aecp" *)

  yyt^.AbsArgumenting.typeRepr                      := T.LegalAbsTypesOnly(yyt^.AbsArgumenting.Expr^.Exprs.TypeReprOut);
(* line 4038 "oberon.aecp" *)


  yyt^.AbsArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.AbsArgumenting.EntryIn
                                   , yyt^.AbsArgumenting.typeRepr
                                   , yyt^.AbsArgumenting.Nextor
                                   , yyt^.AbsArgumenting.Nextor);
yyt^.AbsArgumenting.Nextion^.Designations.LevelIn:=yyt^.AbsArgumenting.LevelIn;
yyt^.AbsArgumenting.Nextion^.Designations.EnvIn:=yyt^.AbsArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.AbsArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.AbsArgumenting.MainEntryIn;
yyt^.AbsArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.AbsArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.AbsArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4067 "oberon.aecp" *)
 yyt^.AbsArgumenting.valueRepr:=V.AbsValue(yyt^.AbsArgumenting.Expr^.Exprs.ValueReprOut,yyt^.AbsArgumenting.OK); 
(* line 4048 "oberon.aecp" *)

  yyt^.AbsArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.AbsArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.AbsArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.AbsArgumenting.typeRepr
                                   , yyt^.AbsArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.AbsArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.AbsArgumenting.Nextion^.Designations.EntryPosition:=yyt^.AbsArgumenting.EntryPosition;
yyt^.AbsArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.AbsArgumenting.PrevEntryIn;
yyt^.AbsArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.AbsArgumenting.IsCallDesignatorIn;
yyt^.AbsArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.AbsArgumenting.ValDontCareIn;
yyt^.AbsArgumenting.Nextion^.Designations.TableIn:=yyt^.AbsArgumenting.TableIn;
yyt^.AbsArgumenting.Nextion^.Designations.ModuleIn:=yyt^.AbsArgumenting.ModuleIn;
yyVisit1 (yyt^.AbsArgumenting.Nextion);
yyt^.AbsArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.AbsArgumenting.EnvIn;
(* line 2923 "oberon.aecp" *)
 
  yyt^.AbsArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.AbsArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.AbsArgumenting.LevelIn;
(* line 4056 "oberon.aecp" *)

  yyt^.AbsArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.AbsArgumenting.Op2Pos;
(* line 4055 "oberon.aecp" *)

  yyt^.AbsArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.AbsArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.AbsArgumenting.ValDontCareIn;
yyt^.AbsArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.AbsArgumenting.TableIn;
yyt^.AbsArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.AbsArgumenting.ModuleIn;
yyVisit1 (yyt^.AbsArgumenting.ExprLists);
yyt^.AbsArgumenting.Nextor^.Designors.EnvIn:=yyt^.AbsArgumenting.EnvIn;
yyt^.AbsArgumenting.Nextor^.Designors.LevelIn:=yyt^.AbsArgumenting.LevelIn;
yyVisit1 (yyt^.AbsArgumenting.Nextor);
(* line 4069 "oberon.aecp" *)
IF ~( T.IsNumericType(yyt^.AbsArgumenting.Expr^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.AbsArgumenting.Expr^.Exprs.Position)
 END;
(* line 4072 "oberon.aecp" *)
IF ~( yyt^.AbsArgumenting.OK
  ) THEN  ERR.MsgPos(ERR.MsgConstArithmeticError,yyt^.AbsArgumenting.EntryPosition)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.AbsArgumenting.MainEntryOut             := yyt^.AbsArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2925 "oberon.aecp" *)
 

  yyt^.AbsArgumenting.TempOfsOut                    := yyt^.AbsArgumenting.Expr^.Exprs.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.AbsArgumenting.ExprListOut                   := yyt^.AbsArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.AbsArgumenting.SignatureReprOut              := yyt^.AbsArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.AbsArgumenting.IsWritableOut                 := yyt^.AbsArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.AbsArgumenting.ValueReprOut                  := yyt^.AbsArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.AbsArgumenting.TypeReprOut                   := yyt^.AbsArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.AbsArgumenting.EntryOut                      := yyt^.AbsArgumenting.Nextion^.Designations.EntryOut;
| Tree.CapArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.CapArgumenting.Entry                         := OB.cmtObject;
(* line 4058 "oberon.aecp" *)
IF ~( ~TT.IsEmptyExpr(yyt^.CapArgumenting.Expr)                                                                     
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.CapArgumenting.Op2Pos)
 END;
(* line 4079 "oberon.aecp" *)

  yyt^.CapArgumenting.typeRepr                      := OB.cCharTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.CapArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.CapArgumenting.EntryIn
                                   , yyt^.CapArgumenting.typeRepr
                                   , yyt^.CapArgumenting.Nextor
                                   , yyt^.CapArgumenting.Nextor);
yyt^.CapArgumenting.Nextion^.Designations.LevelIn:=yyt^.CapArgumenting.LevelIn;
yyt^.CapArgumenting.Expr^.Exprs.EnvIn:=yyt^.CapArgumenting.EnvIn;
(* line 2922 "oberon.aecp" *)

  yyt^.CapArgumenting.Expr^.Exprs.TempOfsIn                := yyt^.CapArgumenting.TempOfsIn;
yyt^.CapArgumenting.Expr^.Exprs.LevelIn:=yyt^.CapArgumenting.LevelIn;
yyt^.CapArgumenting.Expr^.Exprs.ValDontCareIn:=yyt^.CapArgumenting.ValDontCareIn;
yyt^.CapArgumenting.Expr^.Exprs.TableIn:=yyt^.CapArgumenting.TableIn;
yyt^.CapArgumenting.Expr^.Exprs.ModuleIn:=yyt^.CapArgumenting.ModuleIn;
yyVisit1 (yyt^.CapArgumenting.Expr);
yyt^.CapArgumenting.Nextion^.Designations.EnvIn:=yyt^.CapArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.CapArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.CapArgumenting.MainEntryIn;
yyt^.CapArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.CapArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.CapArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4080 "oberon.aecp" *)
                                                           
  yyt^.CapArgumenting.valueRepr                     := V.CapValue(yyt^.CapArgumenting.Expr^.Exprs.ValueReprOut);
(* line 4048 "oberon.aecp" *)

  yyt^.CapArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.CapArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.CapArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.CapArgumenting.typeRepr
                                   , yyt^.CapArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.CapArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.CapArgumenting.Nextion^.Designations.EntryPosition:=yyt^.CapArgumenting.EntryPosition;
yyt^.CapArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.CapArgumenting.PrevEntryIn;
yyt^.CapArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.CapArgumenting.IsCallDesignatorIn;
yyt^.CapArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.CapArgumenting.ValDontCareIn;
yyt^.CapArgumenting.Nextion^.Designations.TableIn:=yyt^.CapArgumenting.TableIn;
yyt^.CapArgumenting.Nextion^.Designations.ModuleIn:=yyt^.CapArgumenting.ModuleIn;
yyVisit1 (yyt^.CapArgumenting.Nextion);
yyt^.CapArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.CapArgumenting.EnvIn;
(* line 2923 "oberon.aecp" *)
 
  yyt^.CapArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.CapArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.CapArgumenting.LevelIn;
(* line 4056 "oberon.aecp" *)

  yyt^.CapArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.CapArgumenting.Op2Pos;
(* line 4055 "oberon.aecp" *)

  yyt^.CapArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.CapArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.CapArgumenting.ValDontCareIn;
yyt^.CapArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.CapArgumenting.TableIn;
yyt^.CapArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.CapArgumenting.ModuleIn;
yyVisit1 (yyt^.CapArgumenting.ExprLists);
yyt^.CapArgumenting.Nextor^.Designors.EnvIn:=yyt^.CapArgumenting.EnvIn;
yyt^.CapArgumenting.Nextor^.Designors.LevelIn:=yyt^.CapArgumenting.LevelIn;
yyVisit1 (yyt^.CapArgumenting.Nextor);
(* line 4082 "oberon.aecp" *)
IF ~( T.IsCharType(yyt^.CapArgumenting.Expr^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.CapArgumenting.Expr^.Exprs.Position)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.CapArgumenting.MainEntryOut             := yyt^.CapArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2925 "oberon.aecp" *)
 

  yyt^.CapArgumenting.TempOfsOut                    := yyt^.CapArgumenting.Expr^.Exprs.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.CapArgumenting.ExprListOut                   := yyt^.CapArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.CapArgumenting.SignatureReprOut              := yyt^.CapArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.CapArgumenting.IsWritableOut                 := yyt^.CapArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.CapArgumenting.ValueReprOut                  := yyt^.CapArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.CapArgumenting.TypeReprOut                   := yyt^.CapArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.CapArgumenting.EntryOut                      := yyt^.CapArgumenting.Nextion^.Designations.EntryOut;
| Tree.ChrArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.ChrArgumenting.Entry                         := OB.cmtObject;
(* line 4058 "oberon.aecp" *)
IF ~( ~TT.IsEmptyExpr(yyt^.ChrArgumenting.Expr)                                                                     
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.ChrArgumenting.Op2Pos)
 END;
(* line 4090 "oberon.aecp" *)

  yyt^.ChrArgumenting.typeRepr                      := OB.cCharTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.ChrArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.ChrArgumenting.EntryIn
                                   , yyt^.ChrArgumenting.typeRepr
                                   , yyt^.ChrArgumenting.Nextor
                                   , yyt^.ChrArgumenting.Nextor);
yyt^.ChrArgumenting.Nextion^.Designations.LevelIn:=yyt^.ChrArgumenting.LevelIn;
yyt^.ChrArgumenting.Expr^.Exprs.EnvIn:=yyt^.ChrArgumenting.EnvIn;
(* line 2922 "oberon.aecp" *)

  yyt^.ChrArgumenting.Expr^.Exprs.TempOfsIn                := yyt^.ChrArgumenting.TempOfsIn;
yyt^.ChrArgumenting.Expr^.Exprs.LevelIn:=yyt^.ChrArgumenting.LevelIn;
yyt^.ChrArgumenting.Expr^.Exprs.ValDontCareIn:=yyt^.ChrArgumenting.ValDontCareIn;
yyt^.ChrArgumenting.Expr^.Exprs.TableIn:=yyt^.ChrArgumenting.TableIn;
yyt^.ChrArgumenting.Expr^.Exprs.ModuleIn:=yyt^.ChrArgumenting.ModuleIn;
yyVisit1 (yyt^.ChrArgumenting.Expr);
yyt^.ChrArgumenting.Nextion^.Designations.EnvIn:=yyt^.ChrArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.ChrArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.ChrArgumenting.MainEntryIn;
yyt^.ChrArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.ChrArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.ChrArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4091 "oberon.aecp" *)
 yyt^.ChrArgumenting.valueRepr:=V.ChrValue(yyt^.ChrArgumenting.Expr^.Exprs.ValueReprOut,yyt^.ChrArgumenting.OK); 
(* line 4048 "oberon.aecp" *)

  yyt^.ChrArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.ChrArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.ChrArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.ChrArgumenting.typeRepr
                                   , yyt^.ChrArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.ChrArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.ChrArgumenting.Nextion^.Designations.EntryPosition:=yyt^.ChrArgumenting.EntryPosition;
yyt^.ChrArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.ChrArgumenting.PrevEntryIn;
yyt^.ChrArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.ChrArgumenting.IsCallDesignatorIn;
yyt^.ChrArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.ChrArgumenting.ValDontCareIn;
yyt^.ChrArgumenting.Nextion^.Designations.TableIn:=yyt^.ChrArgumenting.TableIn;
yyt^.ChrArgumenting.Nextion^.Designations.ModuleIn:=yyt^.ChrArgumenting.ModuleIn;
yyVisit1 (yyt^.ChrArgumenting.Nextion);
yyt^.ChrArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.ChrArgumenting.EnvIn;
(* line 2923 "oberon.aecp" *)
 
  yyt^.ChrArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.ChrArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.ChrArgumenting.LevelIn;
(* line 4056 "oberon.aecp" *)

  yyt^.ChrArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.ChrArgumenting.Op2Pos;
(* line 4055 "oberon.aecp" *)

  yyt^.ChrArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.ChrArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.ChrArgumenting.ValDontCareIn;
yyt^.ChrArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.ChrArgumenting.TableIn;
yyt^.ChrArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.ChrArgumenting.ModuleIn;
yyVisit1 (yyt^.ChrArgumenting.ExprLists);
yyt^.ChrArgumenting.Nextor^.Designors.EnvIn:=yyt^.ChrArgumenting.EnvIn;
yyt^.ChrArgumenting.Nextor^.Designors.LevelIn:=yyt^.ChrArgumenting.LevelIn;
yyVisit1 (yyt^.ChrArgumenting.Nextor);
(* line 4093 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.ChrArgumenting.Expr^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.ChrArgumenting.Expr^.Exprs.Position)
 END;
(* line 4096 "oberon.aecp" *)
IF ~( yyt^.ChrArgumenting.OK
  ) THEN  ERR.MsgPos(ERR.MsgConstArithmeticError,yyt^.ChrArgumenting.EntryPosition)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.ChrArgumenting.MainEntryOut             := yyt^.ChrArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2925 "oberon.aecp" *)
 

  yyt^.ChrArgumenting.TempOfsOut                    := yyt^.ChrArgumenting.Expr^.Exprs.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.ChrArgumenting.ExprListOut                   := yyt^.ChrArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.ChrArgumenting.SignatureReprOut              := yyt^.ChrArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.ChrArgumenting.IsWritableOut                 := yyt^.ChrArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.ChrArgumenting.ValueReprOut                  := yyt^.ChrArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.ChrArgumenting.TypeReprOut                   := yyt^.ChrArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.ChrArgumenting.EntryOut                      := yyt^.ChrArgumenting.Nextion^.Designations.EntryOut;
| Tree.EntierArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.EntierArgumenting.Entry                         := OB.cmtObject;
(* line 4058 "oberon.aecp" *)
IF ~( ~TT.IsEmptyExpr(yyt^.EntierArgumenting.Expr)                                                                     
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.EntierArgumenting.Op2Pos)
 END;
(* line 4104 "oberon.aecp" *)

  yyt^.EntierArgumenting.typeRepr                      := OB.cLongintTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.EntierArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.EntierArgumenting.EntryIn
                                   , yyt^.EntierArgumenting.typeRepr
                                   , yyt^.EntierArgumenting.Nextor
                                   , yyt^.EntierArgumenting.Nextor);
yyt^.EntierArgumenting.Nextion^.Designations.LevelIn:=yyt^.EntierArgumenting.LevelIn;
yyt^.EntierArgumenting.Expr^.Exprs.EnvIn:=yyt^.EntierArgumenting.EnvIn;
(* line 2922 "oberon.aecp" *)

  yyt^.EntierArgumenting.Expr^.Exprs.TempOfsIn                := yyt^.EntierArgumenting.TempOfsIn;
yyt^.EntierArgumenting.Expr^.Exprs.LevelIn:=yyt^.EntierArgumenting.LevelIn;
yyt^.EntierArgumenting.Expr^.Exprs.ValDontCareIn:=yyt^.EntierArgumenting.ValDontCareIn;
yyt^.EntierArgumenting.Expr^.Exprs.TableIn:=yyt^.EntierArgumenting.TableIn;
yyt^.EntierArgumenting.Expr^.Exprs.ModuleIn:=yyt^.EntierArgumenting.ModuleIn;
yyVisit1 (yyt^.EntierArgumenting.Expr);
yyt^.EntierArgumenting.Nextion^.Designations.EnvIn:=yyt^.EntierArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.EntierArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.EntierArgumenting.MainEntryIn;
yyt^.EntierArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.EntierArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.EntierArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4105 "oberon.aecp" *)
 yyt^.EntierArgumenting.valueRepr:=V.EntierValue(yyt^.EntierArgumenting.Expr^.Exprs.ValueReprOut,yyt^.EntierArgumenting.OK); 
(* line 4048 "oberon.aecp" *)

  yyt^.EntierArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.EntierArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.EntierArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.EntierArgumenting.typeRepr
                                   , yyt^.EntierArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.EntierArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.EntierArgumenting.Nextion^.Designations.EntryPosition:=yyt^.EntierArgumenting.EntryPosition;
yyt^.EntierArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.EntierArgumenting.PrevEntryIn;
yyt^.EntierArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.EntierArgumenting.IsCallDesignatorIn;
yyt^.EntierArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.EntierArgumenting.ValDontCareIn;
yyt^.EntierArgumenting.Nextion^.Designations.TableIn:=yyt^.EntierArgumenting.TableIn;
yyt^.EntierArgumenting.Nextion^.Designations.ModuleIn:=yyt^.EntierArgumenting.ModuleIn;
yyVisit1 (yyt^.EntierArgumenting.Nextion);
yyt^.EntierArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.EntierArgumenting.EnvIn;
(* line 2923 "oberon.aecp" *)
 
  yyt^.EntierArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.EntierArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.EntierArgumenting.LevelIn;
(* line 4056 "oberon.aecp" *)

  yyt^.EntierArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.EntierArgumenting.Op2Pos;
(* line 4055 "oberon.aecp" *)

  yyt^.EntierArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.EntierArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.EntierArgumenting.ValDontCareIn;
yyt^.EntierArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.EntierArgumenting.TableIn;
yyt^.EntierArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.EntierArgumenting.ModuleIn;
yyVisit1 (yyt^.EntierArgumenting.ExprLists);
yyt^.EntierArgumenting.Nextor^.Designors.EnvIn:=yyt^.EntierArgumenting.EnvIn;
yyt^.EntierArgumenting.Nextor^.Designors.LevelIn:=yyt^.EntierArgumenting.LevelIn;
yyVisit1 (yyt^.EntierArgumenting.Nextor);
(* line 4107 "oberon.aecp" *)
IF ~( T.IsRealType(yyt^.EntierArgumenting.Expr^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.EntierArgumenting.Expr^.Exprs.Position)
 END;
(* line 4110 "oberon.aecp" *)
IF ~( yyt^.EntierArgumenting.OK
  ) THEN  ERR.MsgPos(ERR.MsgConstArithmeticError,yyt^.EntierArgumenting.EntryPosition)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.EntierArgumenting.MainEntryOut             := yyt^.EntierArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2925 "oberon.aecp" *)
 

  yyt^.EntierArgumenting.TempOfsOut                    := yyt^.EntierArgumenting.Expr^.Exprs.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.EntierArgumenting.ExprListOut                   := yyt^.EntierArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.EntierArgumenting.SignatureReprOut              := yyt^.EntierArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.EntierArgumenting.IsWritableOut                 := yyt^.EntierArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.EntierArgumenting.ValueReprOut                  := yyt^.EntierArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.EntierArgumenting.TypeReprOut                   := yyt^.EntierArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.EntierArgumenting.EntryOut                      := yyt^.EntierArgumenting.Nextion^.Designations.EntryOut;
| Tree.LongArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.LongArgumenting.Entry                         := OB.cmtObject;
yyt^.LongArgumenting.Expr^.Exprs.EnvIn:=yyt^.LongArgumenting.EnvIn;
(* line 2922 "oberon.aecp" *)

  yyt^.LongArgumenting.Expr^.Exprs.TempOfsIn                := yyt^.LongArgumenting.TempOfsIn;
yyt^.LongArgumenting.Expr^.Exprs.LevelIn:=yyt^.LongArgumenting.LevelIn;
yyt^.LongArgumenting.Expr^.Exprs.ValDontCareIn:=yyt^.LongArgumenting.ValDontCareIn;
yyt^.LongArgumenting.Expr^.Exprs.TableIn:=yyt^.LongArgumenting.TableIn;
yyt^.LongArgumenting.Expr^.Exprs.ModuleIn:=yyt^.LongArgumenting.ModuleIn;
yyVisit1 (yyt^.LongArgumenting.Expr);
(* line 4058 "oberon.aecp" *)
IF ~( ~TT.IsEmptyExpr(yyt^.LongArgumenting.Expr)                                                                     
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.LongArgumenting.Op2Pos)
 END;
(* line 4117 "oberon.aecp" *)

  yyt^.LongArgumenting.typeRepr                      := T.TypeLonged(yyt^.LongArgumenting.Expr^.Exprs.TypeReprOut);
(* line 4038 "oberon.aecp" *)


  yyt^.LongArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.LongArgumenting.EntryIn
                                   , yyt^.LongArgumenting.typeRepr
                                   , yyt^.LongArgumenting.Nextor
                                   , yyt^.LongArgumenting.Nextor);
yyt^.LongArgumenting.Nextion^.Designations.LevelIn:=yyt^.LongArgumenting.LevelIn;
yyt^.LongArgumenting.Nextion^.Designations.EnvIn:=yyt^.LongArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.LongArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.LongArgumenting.MainEntryIn;
yyt^.LongArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.LongArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.LongArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4118 "oberon.aecp" *)
                                            
  yyt^.LongArgumenting.valueRepr                     := V.LongValue(yyt^.LongArgumenting.Expr^.Exprs.ValueReprOut);
(* line 4048 "oberon.aecp" *)

  yyt^.LongArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.LongArgumenting.valueRepr;
(* line 4120 "oberon.aecp" *)


  yyt^.LongArgumenting.Nextion^.Designations.TypeReprIn            := yyt^.LongArgumenting.typeRepr;
(* line 4044 "oberon.aecp" *)


  yyt^.LongArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.LongArgumenting.Nextion^.Designations.EntryPosition:=yyt^.LongArgumenting.EntryPosition;
yyt^.LongArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.LongArgumenting.PrevEntryIn;
yyt^.LongArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.LongArgumenting.IsCallDesignatorIn;
yyt^.LongArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.LongArgumenting.ValDontCareIn;
yyt^.LongArgumenting.Nextion^.Designations.TableIn:=yyt^.LongArgumenting.TableIn;
yyt^.LongArgumenting.Nextion^.Designations.ModuleIn:=yyt^.LongArgumenting.ModuleIn;
yyVisit1 (yyt^.LongArgumenting.Nextion);
yyt^.LongArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.LongArgumenting.EnvIn;
(* line 2923 "oberon.aecp" *)
 
  yyt^.LongArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.LongArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.LongArgumenting.LevelIn;
(* line 4056 "oberon.aecp" *)

  yyt^.LongArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.LongArgumenting.Op2Pos;
(* line 4055 "oberon.aecp" *)

  yyt^.LongArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.LongArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.LongArgumenting.ValDontCareIn;
yyt^.LongArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.LongArgumenting.TableIn;
yyt^.LongArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.LongArgumenting.ModuleIn;
yyVisit1 (yyt^.LongArgumenting.ExprLists);
yyt^.LongArgumenting.Nextor^.Designors.EnvIn:=yyt^.LongArgumenting.EnvIn;
yyt^.LongArgumenting.Nextor^.Designors.LevelIn:=yyt^.LongArgumenting.LevelIn;
yyVisit1 (yyt^.LongArgumenting.Nextor);
(* line 4122 "oberon.aecp" *)
IF ~( T.IsShortType(yyt^.LongArgumenting.Expr^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.LongArgumenting.Expr^.Exprs.Position)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.LongArgumenting.MainEntryOut             := yyt^.LongArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2925 "oberon.aecp" *)
 

  yyt^.LongArgumenting.TempOfsOut                    := yyt^.LongArgumenting.Expr^.Exprs.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.LongArgumenting.ExprListOut                   := yyt^.LongArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.LongArgumenting.SignatureReprOut              := yyt^.LongArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.LongArgumenting.IsWritableOut                 := yyt^.LongArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.LongArgumenting.ValueReprOut                  := yyt^.LongArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.LongArgumenting.TypeReprOut                   := yyt^.LongArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.LongArgumenting.EntryOut                      := yyt^.LongArgumenting.Nextion^.Designations.EntryOut;
| Tree.OddArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.OddArgumenting.Entry                         := OB.cmtObject;
(* line 4058 "oberon.aecp" *)
IF ~( ~TT.IsEmptyExpr(yyt^.OddArgumenting.Expr)                                                                     
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.OddArgumenting.Op2Pos)
 END;
(* line 4129 "oberon.aecp" *)

  yyt^.OddArgumenting.typeRepr                      := OB.cBooleanTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.OddArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.OddArgumenting.EntryIn
                                   , yyt^.OddArgumenting.typeRepr
                                   , yyt^.OddArgumenting.Nextor
                                   , yyt^.OddArgumenting.Nextor);
yyt^.OddArgumenting.Nextion^.Designations.LevelIn:=yyt^.OddArgumenting.LevelIn;
yyt^.OddArgumenting.Expr^.Exprs.EnvIn:=yyt^.OddArgumenting.EnvIn;
(* line 2922 "oberon.aecp" *)

  yyt^.OddArgumenting.Expr^.Exprs.TempOfsIn                := yyt^.OddArgumenting.TempOfsIn;
yyt^.OddArgumenting.Expr^.Exprs.LevelIn:=yyt^.OddArgumenting.LevelIn;
yyt^.OddArgumenting.Expr^.Exprs.ValDontCareIn:=yyt^.OddArgumenting.ValDontCareIn;
yyt^.OddArgumenting.Expr^.Exprs.TableIn:=yyt^.OddArgumenting.TableIn;
yyt^.OddArgumenting.Expr^.Exprs.ModuleIn:=yyt^.OddArgumenting.ModuleIn;
yyVisit1 (yyt^.OddArgumenting.Expr);
yyt^.OddArgumenting.Nextion^.Designations.EnvIn:=yyt^.OddArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.OddArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.OddArgumenting.MainEntryIn;
yyt^.OddArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.OddArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.OddArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4130 "oberon.aecp" *)
                                                        
  yyt^.OddArgumenting.valueRepr                     := V.OddValue(yyt^.OddArgumenting.Expr^.Exprs.ValueReprOut);
(* line 4048 "oberon.aecp" *)

  yyt^.OddArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.OddArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.OddArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.OddArgumenting.typeRepr
                                   , yyt^.OddArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.OddArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.OddArgumenting.Nextion^.Designations.EntryPosition:=yyt^.OddArgumenting.EntryPosition;
yyt^.OddArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.OddArgumenting.PrevEntryIn;
yyt^.OddArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.OddArgumenting.IsCallDesignatorIn;
yyt^.OddArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.OddArgumenting.ValDontCareIn;
yyt^.OddArgumenting.Nextion^.Designations.TableIn:=yyt^.OddArgumenting.TableIn;
yyt^.OddArgumenting.Nextion^.Designations.ModuleIn:=yyt^.OddArgumenting.ModuleIn;
yyVisit1 (yyt^.OddArgumenting.Nextion);
yyt^.OddArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.OddArgumenting.EnvIn;
(* line 2923 "oberon.aecp" *)
 
  yyt^.OddArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.OddArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.OddArgumenting.LevelIn;
(* line 4056 "oberon.aecp" *)

  yyt^.OddArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.OddArgumenting.Op2Pos;
(* line 4055 "oberon.aecp" *)

  yyt^.OddArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.OddArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.OddArgumenting.ValDontCareIn;
yyt^.OddArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.OddArgumenting.TableIn;
yyt^.OddArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.OddArgumenting.ModuleIn;
yyVisit1 (yyt^.OddArgumenting.ExprLists);
yyt^.OddArgumenting.Nextor^.Designors.EnvIn:=yyt^.OddArgumenting.EnvIn;
yyt^.OddArgumenting.Nextor^.Designors.LevelIn:=yyt^.OddArgumenting.LevelIn;
yyVisit1 (yyt^.OddArgumenting.Nextor);
(* line 4132 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.OddArgumenting.Expr^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.OddArgumenting.Expr^.Exprs.Position)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.OddArgumenting.MainEntryOut             := yyt^.OddArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2925 "oberon.aecp" *)
 

  yyt^.OddArgumenting.TempOfsOut                    := yyt^.OddArgumenting.Expr^.Exprs.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.OddArgumenting.ExprListOut                   := yyt^.OddArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.OddArgumenting.SignatureReprOut              := yyt^.OddArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.OddArgumenting.IsWritableOut                 := yyt^.OddArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.OddArgumenting.ValueReprOut                  := yyt^.OddArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.OddArgumenting.TypeReprOut                   := yyt^.OddArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.OddArgumenting.EntryOut                      := yyt^.OddArgumenting.Nextion^.Designations.EntryOut;
| Tree.OrdArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.OrdArgumenting.Entry                         := OB.cmtObject;
(* line 4058 "oberon.aecp" *)
IF ~( ~TT.IsEmptyExpr(yyt^.OrdArgumenting.Expr)                                                                     
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.OrdArgumenting.Op2Pos)
 END;
(* line 4139 "oberon.aecp" *)

  yyt^.OrdArgumenting.typeRepr                      := OB.cIntegerTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.OrdArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.OrdArgumenting.EntryIn
                                   , yyt^.OrdArgumenting.typeRepr
                                   , yyt^.OrdArgumenting.Nextor
                                   , yyt^.OrdArgumenting.Nextor);
yyt^.OrdArgumenting.Nextion^.Designations.LevelIn:=yyt^.OrdArgumenting.LevelIn;
yyt^.OrdArgumenting.Expr^.Exprs.EnvIn:=yyt^.OrdArgumenting.EnvIn;
(* line 2922 "oberon.aecp" *)

  yyt^.OrdArgumenting.Expr^.Exprs.TempOfsIn                := yyt^.OrdArgumenting.TempOfsIn;
yyt^.OrdArgumenting.Expr^.Exprs.LevelIn:=yyt^.OrdArgumenting.LevelIn;
yyt^.OrdArgumenting.Expr^.Exprs.ValDontCareIn:=yyt^.OrdArgumenting.ValDontCareIn;
yyt^.OrdArgumenting.Expr^.Exprs.TableIn:=yyt^.OrdArgumenting.TableIn;
yyt^.OrdArgumenting.Expr^.Exprs.ModuleIn:=yyt^.OrdArgumenting.ModuleIn;
yyVisit1 (yyt^.OrdArgumenting.Expr);
yyt^.OrdArgumenting.Nextion^.Designations.EnvIn:=yyt^.OrdArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.OrdArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.OrdArgumenting.MainEntryIn;
yyt^.OrdArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.OrdArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.OrdArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4140 "oberon.aecp" *)
                                                        
  yyt^.OrdArgumenting.valueRepr                     := V.OrdValue(yyt^.OrdArgumenting.Expr^.Exprs.ValueReprOut);
(* line 4048 "oberon.aecp" *)

  yyt^.OrdArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.OrdArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.OrdArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.OrdArgumenting.typeRepr
                                   , yyt^.OrdArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.OrdArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.OrdArgumenting.Nextion^.Designations.EntryPosition:=yyt^.OrdArgumenting.EntryPosition;
yyt^.OrdArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.OrdArgumenting.PrevEntryIn;
yyt^.OrdArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.OrdArgumenting.IsCallDesignatorIn;
yyt^.OrdArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.OrdArgumenting.ValDontCareIn;
yyt^.OrdArgumenting.Nextion^.Designations.TableIn:=yyt^.OrdArgumenting.TableIn;
yyt^.OrdArgumenting.Nextion^.Designations.ModuleIn:=yyt^.OrdArgumenting.ModuleIn;
yyVisit1 (yyt^.OrdArgumenting.Nextion);
yyt^.OrdArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.OrdArgumenting.EnvIn;
(* line 2923 "oberon.aecp" *)
 
  yyt^.OrdArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.OrdArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.OrdArgumenting.LevelIn;
(* line 4056 "oberon.aecp" *)

  yyt^.OrdArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.OrdArgumenting.Op2Pos;
(* line 4055 "oberon.aecp" *)

  yyt^.OrdArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.OrdArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.OrdArgumenting.ValDontCareIn;
yyt^.OrdArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.OrdArgumenting.TableIn;
yyt^.OrdArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.OrdArgumenting.ModuleIn;
yyVisit1 (yyt^.OrdArgumenting.ExprLists);
yyt^.OrdArgumenting.Nextor^.Designors.EnvIn:=yyt^.OrdArgumenting.EnvIn;
yyt^.OrdArgumenting.Nextor^.Designors.LevelIn:=yyt^.OrdArgumenting.LevelIn;
yyVisit1 (yyt^.OrdArgumenting.Nextor);
(* line 4142 "oberon.aecp" *)
IF ~( T.IsCharType(yyt^.OrdArgumenting.Expr^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.OrdArgumenting.Expr^.Exprs.Position)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.OrdArgumenting.MainEntryOut             := yyt^.OrdArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2925 "oberon.aecp" *)
 

  yyt^.OrdArgumenting.TempOfsOut                    := yyt^.OrdArgumenting.Expr^.Exprs.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.OrdArgumenting.ExprListOut                   := yyt^.OrdArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.OrdArgumenting.SignatureReprOut              := yyt^.OrdArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.OrdArgumenting.IsWritableOut                 := yyt^.OrdArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.OrdArgumenting.ValueReprOut                  := yyt^.OrdArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.OrdArgumenting.TypeReprOut                   := yyt^.OrdArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.OrdArgumenting.EntryOut                      := yyt^.OrdArgumenting.Nextion^.Designations.EntryOut;
| Tree.ShortArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.ShortArgumenting.Entry                         := OB.cmtObject;
yyt^.ShortArgumenting.Expr^.Exprs.EnvIn:=yyt^.ShortArgumenting.EnvIn;
(* line 2922 "oberon.aecp" *)

  yyt^.ShortArgumenting.Expr^.Exprs.TempOfsIn                := yyt^.ShortArgumenting.TempOfsIn;
yyt^.ShortArgumenting.Expr^.Exprs.LevelIn:=yyt^.ShortArgumenting.LevelIn;
yyt^.ShortArgumenting.Expr^.Exprs.ValDontCareIn:=yyt^.ShortArgumenting.ValDontCareIn;
yyt^.ShortArgumenting.Expr^.Exprs.TableIn:=yyt^.ShortArgumenting.TableIn;
yyt^.ShortArgumenting.Expr^.Exprs.ModuleIn:=yyt^.ShortArgumenting.ModuleIn;
yyVisit1 (yyt^.ShortArgumenting.Expr);
(* line 4058 "oberon.aecp" *)
IF ~( ~TT.IsEmptyExpr(yyt^.ShortArgumenting.Expr)                                                                     
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.ShortArgumenting.Op2Pos)
 END;
(* line 4150 "oberon.aecp" *)

  yyt^.ShortArgumenting.typeRepr                      := T.TypeShortened(yyt^.ShortArgumenting.Expr^.Exprs.TypeReprOut);
(* line 4038 "oberon.aecp" *)


  yyt^.ShortArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.ShortArgumenting.EntryIn
                                   , yyt^.ShortArgumenting.typeRepr
                                   , yyt^.ShortArgumenting.Nextor
                                   , yyt^.ShortArgumenting.Nextor);
yyt^.ShortArgumenting.Nextion^.Designations.LevelIn:=yyt^.ShortArgumenting.LevelIn;
yyt^.ShortArgumenting.Nextion^.Designations.EnvIn:=yyt^.ShortArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.ShortArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.ShortArgumenting.MainEntryIn;
yyt^.ShortArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.ShortArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.ShortArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4151 "oberon.aecp" *)
 yyt^.ShortArgumenting.valueRepr:=V.ShortValue(yyt^.ShortArgumenting.Expr^.Exprs.TypeReprOut,yyt^.ShortArgumenting.Expr^.Exprs.ValueReprOut,yyt^.ShortArgumenting.OK); 
(* line 4048 "oberon.aecp" *)

  yyt^.ShortArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.ShortArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.ShortArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.ShortArgumenting.typeRepr
                                   , yyt^.ShortArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.ShortArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.ShortArgumenting.Nextion^.Designations.EntryPosition:=yyt^.ShortArgumenting.EntryPosition;
yyt^.ShortArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.ShortArgumenting.PrevEntryIn;
yyt^.ShortArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.ShortArgumenting.IsCallDesignatorIn;
yyt^.ShortArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.ShortArgumenting.ValDontCareIn;
yyt^.ShortArgumenting.Nextion^.Designations.TableIn:=yyt^.ShortArgumenting.TableIn;
yyt^.ShortArgumenting.Nextion^.Designations.ModuleIn:=yyt^.ShortArgumenting.ModuleIn;
yyVisit1 (yyt^.ShortArgumenting.Nextion);
yyt^.ShortArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.ShortArgumenting.EnvIn;
(* line 2923 "oberon.aecp" *)
 
  yyt^.ShortArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.ShortArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.ShortArgumenting.LevelIn;
(* line 4056 "oberon.aecp" *)

  yyt^.ShortArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.ShortArgumenting.Op2Pos;
(* line 4055 "oberon.aecp" *)

  yyt^.ShortArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.ShortArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.ShortArgumenting.ValDontCareIn;
yyt^.ShortArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.ShortArgumenting.TableIn;
yyt^.ShortArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.ShortArgumenting.ModuleIn;
yyVisit1 (yyt^.ShortArgumenting.ExprLists);
yyt^.ShortArgumenting.Nextor^.Designors.EnvIn:=yyt^.ShortArgumenting.EnvIn;
yyt^.ShortArgumenting.Nextor^.Designors.LevelIn:=yyt^.ShortArgumenting.LevelIn;
yyVisit1 (yyt^.ShortArgumenting.Nextor);
(* line 4153 "oberon.aecp" *)
IF ~( T.IsLongType(yyt^.ShortArgumenting.Expr^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.ShortArgumenting.Expr^.Exprs.Position)
 END;
(* line 4156 "oberon.aecp" *)
IF ~( yyt^.ShortArgumenting.OK
  ) THEN  ERR.MsgPos(ERR.MsgConstArithmeticError,yyt^.ShortArgumenting.EntryPosition)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.ShortArgumenting.MainEntryOut             := yyt^.ShortArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2925 "oberon.aecp" *)
 

  yyt^.ShortArgumenting.TempOfsOut                    := yyt^.ShortArgumenting.Expr^.Exprs.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.ShortArgumenting.ExprListOut                   := yyt^.ShortArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.ShortArgumenting.SignatureReprOut              := yyt^.ShortArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.ShortArgumenting.IsWritableOut                 := yyt^.ShortArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.ShortArgumenting.ValueReprOut                  := yyt^.ShortArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.ShortArgumenting.TypeReprOut                   := yyt^.ShortArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.ShortArgumenting.EntryOut                      := yyt^.ShortArgumenting.Nextion^.Designations.EntryOut;
| Tree.HaltArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.HaltArgumenting.Entry                         := OB.cmtObject;
(* line 4058 "oberon.aecp" *)
IF ~( ~TT.IsEmptyExpr(yyt^.HaltArgumenting.Expr)                                                                     
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.HaltArgumenting.Op2Pos)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.HaltArgumenting.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.HaltArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.HaltArgumenting.EntryIn
                                   , yyt^.HaltArgumenting.typeRepr
                                   , yyt^.HaltArgumenting.Nextor
                                   , yyt^.HaltArgumenting.Nextor);
yyt^.HaltArgumenting.Nextion^.Designations.LevelIn:=yyt^.HaltArgumenting.LevelIn;
yyt^.HaltArgumenting.Nextion^.Designations.EnvIn:=yyt^.HaltArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.HaltArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.HaltArgumenting.MainEntryIn;
yyt^.HaltArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.HaltArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.HaltArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.HaltArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.HaltArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.HaltArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.HaltArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.HaltArgumenting.typeRepr
                                   , yyt^.HaltArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.HaltArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.HaltArgumenting.Nextion^.Designations.EntryPosition:=yyt^.HaltArgumenting.EntryPosition;
yyt^.HaltArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.HaltArgumenting.PrevEntryIn;
yyt^.HaltArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.HaltArgumenting.IsCallDesignatorIn;
yyt^.HaltArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.HaltArgumenting.ValDontCareIn;
yyt^.HaltArgumenting.Nextion^.Designations.TableIn:=yyt^.HaltArgumenting.TableIn;
yyt^.HaltArgumenting.Nextion^.Designations.ModuleIn:=yyt^.HaltArgumenting.ModuleIn;
yyVisit1 (yyt^.HaltArgumenting.Nextion);
yyt^.HaltArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.HaltArgumenting.EnvIn;
(* line 2923 "oberon.aecp" *)
 
  yyt^.HaltArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.HaltArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.HaltArgumenting.LevelIn;
(* line 4056 "oberon.aecp" *)

  yyt^.HaltArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.HaltArgumenting.Op2Pos;
(* line 4055 "oberon.aecp" *)

  yyt^.HaltArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.HaltArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.HaltArgumenting.ValDontCareIn;
yyt^.HaltArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.HaltArgumenting.TableIn;
yyt^.HaltArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.HaltArgumenting.ModuleIn;
yyVisit1 (yyt^.HaltArgumenting.ExprLists);
yyt^.HaltArgumenting.Expr^.Exprs.EnvIn:=yyt^.HaltArgumenting.EnvIn;
(* line 2922 "oberon.aecp" *)

  yyt^.HaltArgumenting.Expr^.Exprs.TempOfsIn                := yyt^.HaltArgumenting.TempOfsIn;
yyt^.HaltArgumenting.Expr^.Exprs.LevelIn:=yyt^.HaltArgumenting.LevelIn;
yyt^.HaltArgumenting.Expr^.Exprs.ValDontCareIn:=yyt^.HaltArgumenting.ValDontCareIn;
yyt^.HaltArgumenting.Expr^.Exprs.TableIn:=yyt^.HaltArgumenting.TableIn;
yyt^.HaltArgumenting.Expr^.Exprs.ModuleIn:=yyt^.HaltArgumenting.ModuleIn;
yyVisit1 (yyt^.HaltArgumenting.Expr);
yyt^.HaltArgumenting.Nextor^.Designors.EnvIn:=yyt^.HaltArgumenting.EnvIn;
yyt^.HaltArgumenting.Nextor^.Designors.LevelIn:=yyt^.HaltArgumenting.LevelIn;
yyVisit1 (yyt^.HaltArgumenting.Nextor);
(* line 4163 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.HaltArgumenting.Expr^.Exprs.TypeReprOut)                                                                     
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.HaltArgumenting.Expr^.Exprs.Position)
 END;
(* line 4166 "oberon.aecp" *)
IF ~( V.IsValidConstValue(yyt^.HaltArgumenting.Expr^.Exprs.ValueReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgExprNotConstant,yyt^.HaltArgumenting.Expr^.Exprs.Position)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.HaltArgumenting.MainEntryOut             := yyt^.HaltArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2925 "oberon.aecp" *)
 

  yyt^.HaltArgumenting.TempOfsOut                    := yyt^.HaltArgumenting.Expr^.Exprs.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.HaltArgumenting.ExprListOut                   := yyt^.HaltArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.HaltArgumenting.SignatureReprOut              := yyt^.HaltArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.HaltArgumenting.IsWritableOut                 := yyt^.HaltArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.HaltArgumenting.ValueReprOut                  := yyt^.HaltArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.HaltArgumenting.TypeReprOut                   := yyt^.HaltArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.HaltArgumenting.EntryOut                      := yyt^.HaltArgumenting.Nextion^.Designations.EntryOut;
| Tree.SysAdrArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.SysAdrArgumenting.Entry                         := OB.cmtObject;
(* line 4058 "oberon.aecp" *)
IF ~( ~TT.IsEmptyExpr(yyt^.SysAdrArgumenting.Expr)                                                                     
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.SysAdrArgumenting.Op2Pos)
 END;
(* line 4173 "oberon.aecp" *)

  yyt^.SysAdrArgumenting.typeRepr                      := OB.cLongintTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.SysAdrArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.SysAdrArgumenting.EntryIn
                                   , yyt^.SysAdrArgumenting.typeRepr
                                   , yyt^.SysAdrArgumenting.Nextor
                                   , yyt^.SysAdrArgumenting.Nextor);
yyt^.SysAdrArgumenting.Nextion^.Designations.LevelIn:=yyt^.SysAdrArgumenting.LevelIn;
yyt^.SysAdrArgumenting.Nextion^.Designations.EnvIn:=yyt^.SysAdrArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.SysAdrArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.SysAdrArgumenting.MainEntryIn;
yyt^.SysAdrArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.SysAdrArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.SysAdrArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.SysAdrArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.SysAdrArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.SysAdrArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.SysAdrArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.SysAdrArgumenting.typeRepr
                                   , yyt^.SysAdrArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.SysAdrArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.SysAdrArgumenting.Nextion^.Designations.EntryPosition:=yyt^.SysAdrArgumenting.EntryPosition;
yyt^.SysAdrArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.SysAdrArgumenting.PrevEntryIn;
yyt^.SysAdrArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.SysAdrArgumenting.IsCallDesignatorIn;
yyt^.SysAdrArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.SysAdrArgumenting.ValDontCareIn;
yyt^.SysAdrArgumenting.Nextion^.Designations.TableIn:=yyt^.SysAdrArgumenting.TableIn;
yyt^.SysAdrArgumenting.Nextion^.Designations.ModuleIn:=yyt^.SysAdrArgumenting.ModuleIn;
yyVisit1 (yyt^.SysAdrArgumenting.Nextion);
yyt^.SysAdrArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.SysAdrArgumenting.EnvIn;
(* line 2923 "oberon.aecp" *)
 
  yyt^.SysAdrArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.SysAdrArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.SysAdrArgumenting.LevelIn;
(* line 4056 "oberon.aecp" *)

  yyt^.SysAdrArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.SysAdrArgumenting.Op2Pos;
(* line 4055 "oberon.aecp" *)

  yyt^.SysAdrArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.SysAdrArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.SysAdrArgumenting.ValDontCareIn;
yyt^.SysAdrArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.SysAdrArgumenting.TableIn;
yyt^.SysAdrArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.SysAdrArgumenting.ModuleIn;
yyVisit1 (yyt^.SysAdrArgumenting.ExprLists);
yyt^.SysAdrArgumenting.Expr^.Exprs.EnvIn:=yyt^.SysAdrArgumenting.EnvIn;
(* line 2922 "oberon.aecp" *)

  yyt^.SysAdrArgumenting.Expr^.Exprs.TempOfsIn                := yyt^.SysAdrArgumenting.TempOfsIn;
yyt^.SysAdrArgumenting.Expr^.Exprs.LevelIn:=yyt^.SysAdrArgumenting.LevelIn;
yyt^.SysAdrArgumenting.Expr^.Exprs.ValDontCareIn:=yyt^.SysAdrArgumenting.ValDontCareIn;
yyt^.SysAdrArgumenting.Expr^.Exprs.TableIn:=yyt^.SysAdrArgumenting.TableIn;
yyt^.SysAdrArgumenting.Expr^.Exprs.ModuleIn:=yyt^.SysAdrArgumenting.ModuleIn;
yyVisit1 (yyt^.SysAdrArgumenting.Expr);
yyt^.SysAdrArgumenting.Nextor^.Designors.EnvIn:=yyt^.SysAdrArgumenting.EnvIn;
yyt^.SysAdrArgumenting.Nextor^.Designors.LevelIn:=yyt^.SysAdrArgumenting.LevelIn;
yyVisit1 (yyt^.SysAdrArgumenting.Nextor);
(* line 4175 "oberon.aecp" *)
IF ~( yyt^.SysAdrArgumenting.Expr^.Exprs.IsLValueOut
  ) THEN  ERR.MsgPos(ERR.MsgLValueExpected,yyt^.SysAdrArgumenting.Expr^.Exprs.Position)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.SysAdrArgumenting.MainEntryOut             := yyt^.SysAdrArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2925 "oberon.aecp" *)
 

  yyt^.SysAdrArgumenting.TempOfsOut                    := yyt^.SysAdrArgumenting.Expr^.Exprs.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.SysAdrArgumenting.ExprListOut                   := yyt^.SysAdrArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.SysAdrArgumenting.SignatureReprOut              := yyt^.SysAdrArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.SysAdrArgumenting.IsWritableOut                 := yyt^.SysAdrArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.SysAdrArgumenting.ValueReprOut                  := yyt^.SysAdrArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.SysAdrArgumenting.TypeReprOut                   := yyt^.SysAdrArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.SysAdrArgumenting.EntryOut                      := yyt^.SysAdrArgumenting.Nextion^.Designations.EntryOut;
| Tree.SysCcArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.SysCcArgumenting.Entry                         := OB.cmtObject;
(* line 4058 "oberon.aecp" *)
IF ~( ~TT.IsEmptyExpr(yyt^.SysCcArgumenting.Expr)                                                                     
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.SysCcArgumenting.Op2Pos)
 END;
(* line 4182 "oberon.aecp" *)

  yyt^.SysCcArgumenting.typeRepr                      := OB.cBooleanTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.SysCcArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.SysCcArgumenting.EntryIn
                                   , yyt^.SysCcArgumenting.typeRepr
                                   , yyt^.SysCcArgumenting.Nextor
                                   , yyt^.SysCcArgumenting.Nextor);
yyt^.SysCcArgumenting.Nextion^.Designations.LevelIn:=yyt^.SysCcArgumenting.LevelIn;
yyt^.SysCcArgumenting.Nextion^.Designations.EnvIn:=yyt^.SysCcArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.SysCcArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.SysCcArgumenting.MainEntryIn;
yyt^.SysCcArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.SysCcArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.SysCcArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.SysCcArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.SysCcArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.SysCcArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.SysCcArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.SysCcArgumenting.typeRepr
                                   , yyt^.SysCcArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.SysCcArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.SysCcArgumenting.Nextion^.Designations.EntryPosition:=yyt^.SysCcArgumenting.EntryPosition;
yyt^.SysCcArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.SysCcArgumenting.PrevEntryIn;
yyt^.SysCcArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.SysCcArgumenting.IsCallDesignatorIn;
yyt^.SysCcArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.SysCcArgumenting.ValDontCareIn;
yyt^.SysCcArgumenting.Nextion^.Designations.TableIn:=yyt^.SysCcArgumenting.TableIn;
yyt^.SysCcArgumenting.Nextion^.Designations.ModuleIn:=yyt^.SysCcArgumenting.ModuleIn;
yyVisit1 (yyt^.SysCcArgumenting.Nextion);
yyt^.SysCcArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.SysCcArgumenting.EnvIn;
(* line 2923 "oberon.aecp" *)
 
  yyt^.SysCcArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.SysCcArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.SysCcArgumenting.LevelIn;
(* line 4056 "oberon.aecp" *)

  yyt^.SysCcArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.SysCcArgumenting.Op2Pos;
(* line 4055 "oberon.aecp" *)

  yyt^.SysCcArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.SysCcArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.SysCcArgumenting.ValDontCareIn;
yyt^.SysCcArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.SysCcArgumenting.TableIn;
yyt^.SysCcArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.SysCcArgumenting.ModuleIn;
yyVisit1 (yyt^.SysCcArgumenting.ExprLists);
yyt^.SysCcArgumenting.Expr^.Exprs.EnvIn:=yyt^.SysCcArgumenting.EnvIn;
(* line 2922 "oberon.aecp" *)

  yyt^.SysCcArgumenting.Expr^.Exprs.TempOfsIn                := yyt^.SysCcArgumenting.TempOfsIn;
yyt^.SysCcArgumenting.Expr^.Exprs.LevelIn:=yyt^.SysCcArgumenting.LevelIn;
yyt^.SysCcArgumenting.Expr^.Exprs.ValDontCareIn:=yyt^.SysCcArgumenting.ValDontCareIn;
yyt^.SysCcArgumenting.Expr^.Exprs.TableIn:=yyt^.SysCcArgumenting.TableIn;
yyt^.SysCcArgumenting.Expr^.Exprs.ModuleIn:=yyt^.SysCcArgumenting.ModuleIn;
yyVisit1 (yyt^.SysCcArgumenting.Expr);
yyt^.SysCcArgumenting.Nextor^.Designors.EnvIn:=yyt^.SysCcArgumenting.EnvIn;
yyt^.SysCcArgumenting.Nextor^.Designors.LevelIn:=yyt^.SysCcArgumenting.LevelIn;
yyVisit1 (yyt^.SysCcArgumenting.Nextor);
(* line 4184 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.SysCcArgumenting.Expr^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysCcArgumenting.Expr^.Exprs.Position)
 END;
(* line 4187 "oberon.aecp" *)
IF ~( V.IsValidConstValue(yyt^.SysCcArgumenting.Expr^.Exprs.ValueReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgExprNotConstant,yyt^.SysCcArgumenting.Expr^.Exprs.Position)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.SysCcArgumenting.MainEntryOut             := yyt^.SysCcArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2925 "oberon.aecp" *)
 

  yyt^.SysCcArgumenting.TempOfsOut                    := yyt^.SysCcArgumenting.Expr^.Exprs.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.SysCcArgumenting.ExprListOut                   := yyt^.SysCcArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.SysCcArgumenting.SignatureReprOut              := yyt^.SysCcArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.SysCcArgumenting.IsWritableOut                 := yyt^.SysCcArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.SysCcArgumenting.ValueReprOut                  := yyt^.SysCcArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.SysCcArgumenting.TypeReprOut                   := yyt^.SysCcArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.SysCcArgumenting.EntryOut                      := yyt^.SysCcArgumenting.Nextion^.Designations.EntryOut;
| Tree.PredeclArgumenting2Opt:
(* line 2250 "oberon.aecp" *)

  yyt^.PredeclArgumenting2Opt.Entry                         := OB.cmtObject;
yyt^.PredeclArgumenting2Opt.ExprLists^.ExprLists.EnvIn:=yyt^.PredeclArgumenting2Opt.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.PredeclArgumenting2Opt.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.PredeclArgumenting2Opt.ExprLists^.ExprLists.LevelIn:=yyt^.PredeclArgumenting2Opt.LevelIn;
(* line 4203 "oberon.aecp" *)

  yyt^.PredeclArgumenting2Opt.ExprLists^.ExprLists.ClosingPosIn        := yyt^.PredeclArgumenting2Opt.Op2Pos;
(* line 4202 "oberon.aecp" *)


  yyt^.PredeclArgumenting2Opt.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.PredeclArgumenting2Opt.ExprLists^.ExprLists.ValDontCareIn:=yyt^.PredeclArgumenting2Opt.ValDontCareIn;
yyt^.PredeclArgumenting2Opt.ExprLists^.ExprLists.TableIn:=yyt^.PredeclArgumenting2Opt.TableIn;
yyt^.PredeclArgumenting2Opt.ExprLists^.ExprLists.ModuleIn:=yyt^.PredeclArgumenting2Opt.ModuleIn;
yyVisit1 (yyt^.PredeclArgumenting2Opt.ExprLists);
yyt^.PredeclArgumenting2Opt.Expr2^.Exprs.EnvIn:=yyt^.PredeclArgumenting2Opt.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.PredeclArgumenting2Opt.Expr2^.Exprs.TempOfsIn               := yyt^.PredeclArgumenting2Opt.TempOfsIn;
yyt^.PredeclArgumenting2Opt.Expr2^.Exprs.LevelIn:=yyt^.PredeclArgumenting2Opt.LevelIn;
yyt^.PredeclArgumenting2Opt.Expr2^.Exprs.ValDontCareIn:=yyt^.PredeclArgumenting2Opt.ValDontCareIn;
yyt^.PredeclArgumenting2Opt.Expr2^.Exprs.TableIn:=yyt^.PredeclArgumenting2Opt.TableIn;
yyt^.PredeclArgumenting2Opt.Expr2^.Exprs.ModuleIn:=yyt^.PredeclArgumenting2Opt.ModuleIn;
yyVisit1 (yyt^.PredeclArgumenting2Opt.Expr2);
yyt^.PredeclArgumenting2Opt.Expr1^.Exprs.EnvIn:=yyt^.PredeclArgumenting2Opt.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.PredeclArgumenting2Opt.Expr1^.Exprs.TempOfsIn               := yyt^.PredeclArgumenting2Opt.TempOfsIn;
yyt^.PredeclArgumenting2Opt.Expr1^.Exprs.LevelIn:=yyt^.PredeclArgumenting2Opt.LevelIn;
yyt^.PredeclArgumenting2Opt.Expr1^.Exprs.ValDontCareIn:=yyt^.PredeclArgumenting2Opt.ValDontCareIn;
yyt^.PredeclArgumenting2Opt.Expr1^.Exprs.TableIn:=yyt^.PredeclArgumenting2Opt.TableIn;
yyt^.PredeclArgumenting2Opt.Expr1^.Exprs.ModuleIn:=yyt^.PredeclArgumenting2Opt.ModuleIn;
yyVisit1 (yyt^.PredeclArgumenting2Opt.Expr1);
(* line 4197 "oberon.aecp" *)

  yyt^.PredeclArgumenting2Opt.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.PredeclArgumenting2Opt.Expr1);
(* line 4199 "oberon.aecp" *)


  yyt^.PredeclArgumenting2Opt.Coerce1                       := OB.cmtCoercion;
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.PredeclArgumenting2Opt.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.PredeclArgumenting2Opt.Op2Pos)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.PredeclArgumenting2Opt.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.PredeclArgumenting2Opt.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.PredeclArgumenting2Opt.EntryIn
                                   , yyt^.PredeclArgumenting2Opt.typeRepr
                                   , yyt^.PredeclArgumenting2Opt.Nextor
                                   , yyt^.PredeclArgumenting2Opt.Nextor);
yyt^.PredeclArgumenting2Opt.Nextion^.Designations.EnvIn:=yyt^.PredeclArgumenting2Opt.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.PredeclArgumenting2Opt.Nextion^.Designations.MainEntryIn      := yyt^.PredeclArgumenting2Opt.MainEntryIn;
yyt^.PredeclArgumenting2Opt.Nextion^.Designations.TempOfsIn:=yyt^.PredeclArgumenting2Opt.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.PredeclArgumenting2Opt.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.PredeclArgumenting2Opt.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.PredeclArgumenting2Opt.Nextion^.Designations.ValueReprIn           := yyt^.PredeclArgumenting2Opt.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.PredeclArgumenting2Opt.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.PredeclArgumenting2Opt.typeRepr
                                   , yyt^.PredeclArgumenting2Opt.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.PredeclArgumenting2Opt.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.PredeclArgumenting2Opt.Nextion^.Designations.EntryPosition:=yyt^.PredeclArgumenting2Opt.EntryPosition;
yyt^.PredeclArgumenting2Opt.Nextion^.Designations.PrevEntryIn:=yyt^.PredeclArgumenting2Opt.PrevEntryIn;
yyt^.PredeclArgumenting2Opt.Nextion^.Designations.IsCallDesignatorIn:=yyt^.PredeclArgumenting2Opt.IsCallDesignatorIn;
yyt^.PredeclArgumenting2Opt.Nextion^.Designations.ValDontCareIn:=yyt^.PredeclArgumenting2Opt.ValDontCareIn;
yyt^.PredeclArgumenting2Opt.Nextion^.Designations.TableIn:=yyt^.PredeclArgumenting2Opt.TableIn;
yyt^.PredeclArgumenting2Opt.Nextion^.Designations.ModuleIn:=yyt^.PredeclArgumenting2Opt.ModuleIn;
yyt^.PredeclArgumenting2Opt.Nextion^.Designations.LevelIn:=yyt^.PredeclArgumenting2Opt.LevelIn;
yyVisit1 (yyt^.PredeclArgumenting2Opt.Nextion);
yyt^.PredeclArgumenting2Opt.Nextor^.Designors.EnvIn:=yyt^.PredeclArgumenting2Opt.EnvIn;
yyt^.PredeclArgumenting2Opt.Nextor^.Designors.LevelIn:=yyt^.PredeclArgumenting2Opt.LevelIn;
yyVisit1 (yyt^.PredeclArgumenting2Opt.Nextor);
(* line 4196 "oberon.aecp" *)

  yyt^.PredeclArgumenting2Opt.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.PredeclArgumenting2Opt.Expr2);
(* line 4200 "oberon.aecp" *)

  yyt^.PredeclArgumenting2Opt.Coerce2                       := OB.cmtCoercion;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.PredeclArgumenting2Opt.MainEntryOut             := yyt^.PredeclArgumenting2Opt.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.PredeclArgumenting2Opt.TempOfsOut                    := ADR.MinSize2(yyt^.PredeclArgumenting2Opt.Expr1^.Exprs.TempOfsOut,yyt^.PredeclArgumenting2Opt.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.PredeclArgumenting2Opt.ExprListOut                   := yyt^.PredeclArgumenting2Opt.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.PredeclArgumenting2Opt.SignatureReprOut              := yyt^.PredeclArgumenting2Opt.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.PredeclArgumenting2Opt.IsWritableOut                 := yyt^.PredeclArgumenting2Opt.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.PredeclArgumenting2Opt.ValueReprOut                  := yyt^.PredeclArgumenting2Opt.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.PredeclArgumenting2Opt.TypeReprOut                   := yyt^.PredeclArgumenting2Opt.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.PredeclArgumenting2Opt.EntryOut                      := yyt^.PredeclArgumenting2Opt.Nextion^.Designations.EntryOut;
| Tree.LenArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.LenArgumenting.Entry                         := OB.cmtObject;
yyt^.LenArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.LenArgumenting.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.LenArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.LenArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.LenArgumenting.LevelIn;
(* line 4203 "oberon.aecp" *)

  yyt^.LenArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.LenArgumenting.Op2Pos;
(* line 4202 "oberon.aecp" *)


  yyt^.LenArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.LenArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.LenArgumenting.ValDontCareIn;
yyt^.LenArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.LenArgumenting.TableIn;
yyt^.LenArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.LenArgumenting.ModuleIn;
yyVisit1 (yyt^.LenArgumenting.ExprLists);
yyt^.LenArgumenting.Expr2^.Exprs.EnvIn:=yyt^.LenArgumenting.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.LenArgumenting.Expr2^.Exprs.TempOfsIn               := yyt^.LenArgumenting.TempOfsIn;
yyt^.LenArgumenting.Expr2^.Exprs.LevelIn:=yyt^.LenArgumenting.LevelIn;
yyt^.LenArgumenting.Expr2^.Exprs.ValDontCareIn:=yyt^.LenArgumenting.ValDontCareIn;
yyt^.LenArgumenting.Expr2^.Exprs.TableIn:=yyt^.LenArgumenting.TableIn;
yyt^.LenArgumenting.Expr2^.Exprs.ModuleIn:=yyt^.LenArgumenting.ModuleIn;
yyVisit1 (yyt^.LenArgumenting.Expr2);
yyt^.LenArgumenting.Expr1^.Exprs.EnvIn:=yyt^.LenArgumenting.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.LenArgumenting.Expr1^.Exprs.TempOfsIn               := yyt^.LenArgumenting.TempOfsIn;
yyt^.LenArgumenting.Expr1^.Exprs.LevelIn:=yyt^.LenArgumenting.LevelIn;
yyt^.LenArgumenting.Expr1^.Exprs.ValDontCareIn:=yyt^.LenArgumenting.ValDontCareIn;
yyt^.LenArgumenting.Expr1^.Exprs.TableIn:=yyt^.LenArgumenting.TableIn;
yyt^.LenArgumenting.Expr1^.Exprs.ModuleIn:=yyt^.LenArgumenting.ModuleIn;
yyVisit1 (yyt^.LenArgumenting.Expr1);
(* line 4197 "oberon.aecp" *)

  yyt^.LenArgumenting.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.LenArgumenting.Expr1);
(* line 4199 "oberon.aecp" *)


  yyt^.LenArgumenting.Coerce1                       := OB.cmtCoercion;
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.LenArgumenting.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.LenArgumenting.Op2Pos)
 END;
(* line 4227 "oberon.aecp" *)

  yyt^.LenArgumenting.typeRepr                      := OB.cLongintTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.LenArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.LenArgumenting.EntryIn
                                   , yyt^.LenArgumenting.typeRepr
                                   , yyt^.LenArgumenting.Nextor
                                   , yyt^.LenArgumenting.Nextor);
yyt^.LenArgumenting.Nextion^.Designations.EnvIn:=yyt^.LenArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.LenArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.LenArgumenting.MainEntryIn;
yyt^.LenArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.LenArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.LenArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4228 "oberon.aecp" *)
                                                        
  yyt^.LenArgumenting.valueRepr                     := T.TypeDimensioned(yyt^.LenArgumenting.Expr1^.Exprs.TypeReprOut,yyt^.LenArgumenting.Expr2^.Exprs.ValueReprOut);
(* line 4048 "oberon.aecp" *)

  yyt^.LenArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.LenArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.LenArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.LenArgumenting.typeRepr
                                   , yyt^.LenArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.LenArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.LenArgumenting.Nextion^.Designations.EntryPosition:=yyt^.LenArgumenting.EntryPosition;
yyt^.LenArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.LenArgumenting.PrevEntryIn;
yyt^.LenArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.LenArgumenting.IsCallDesignatorIn;
yyt^.LenArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.LenArgumenting.ValDontCareIn;
yyt^.LenArgumenting.Nextion^.Designations.TableIn:=yyt^.LenArgumenting.TableIn;
yyt^.LenArgumenting.Nextion^.Designations.ModuleIn:=yyt^.LenArgumenting.ModuleIn;
yyt^.LenArgumenting.Nextion^.Designations.LevelIn:=yyt^.LenArgumenting.LevelIn;
yyVisit1 (yyt^.LenArgumenting.Nextion);
yyt^.LenArgumenting.Nextor^.Designors.EnvIn:=yyt^.LenArgumenting.EnvIn;
yyt^.LenArgumenting.Nextor^.Designors.LevelIn:=yyt^.LenArgumenting.LevelIn;
yyVisit1 (yyt^.LenArgumenting.Nextor);
(* line 4230 "oberon.aecp" *)
IF ~( T.IsArrayType(yyt^.LenArgumenting.Expr1^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.LenArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4233 "oberon.aecp" *)
IF ~( yyt^.LenArgumenting.Expr1^.Exprs.IsLValueOut
  ) THEN  ERR.MsgPos(ERR.MsgLValueExpected,yyt^.LenArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4196 "oberon.aecp" *)

  yyt^.LenArgumenting.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.LenArgumenting.Expr2);
(* line 4236 "oberon.aecp" *)
IF ~( yyt^.LenArgumenting.isEmptyExpr2
     OR T.IsIntegerType(yyt^.LenArgumenting.Expr2^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.LenArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4240 "oberon.aecp" *)
IF ~( yyt^.LenArgumenting.isEmptyExpr2
     OR V.IsValidConstValue(yyt^.LenArgumenting.Expr2^.Exprs.ValueReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgExprNotConstant,yyt^.LenArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4244 "oberon.aecp" *)
IF ~( yyt^.LenArgumenting.isEmptyExpr2
     OR T.IsValidLenDim(yyt^.LenArgumenting.Expr1^.Exprs.TypeReprOut,yyt^.LenArgumenting.Expr2^.Exprs.ValueReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgIllegalLenDimension,yyt^.LenArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4200 "oberon.aecp" *)

  yyt^.LenArgumenting.Coerce2                       := OB.cmtCoercion;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.LenArgumenting.MainEntryOut             := yyt^.LenArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.LenArgumenting.TempOfsOut                    := ADR.MinSize2(yyt^.LenArgumenting.Expr1^.Exprs.TempOfsOut,yyt^.LenArgumenting.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.LenArgumenting.ExprListOut                   := yyt^.LenArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.LenArgumenting.SignatureReprOut              := yyt^.LenArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.LenArgumenting.IsWritableOut                 := yyt^.LenArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.LenArgumenting.ValueReprOut                  := yyt^.LenArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.LenArgumenting.TypeReprOut                   := yyt^.LenArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.LenArgumenting.EntryOut                      := yyt^.LenArgumenting.Nextion^.Designations.EntryOut;
| Tree.AssertArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.AssertArgumenting.Entry                         := OB.cmtObject;
yyt^.AssertArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.AssertArgumenting.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.AssertArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.AssertArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.AssertArgumenting.LevelIn;
(* line 4203 "oberon.aecp" *)

  yyt^.AssertArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.AssertArgumenting.Op2Pos;
(* line 4202 "oberon.aecp" *)


  yyt^.AssertArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.AssertArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.AssertArgumenting.ValDontCareIn;
yyt^.AssertArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.AssertArgumenting.TableIn;
yyt^.AssertArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.AssertArgumenting.ModuleIn;
yyVisit1 (yyt^.AssertArgumenting.ExprLists);
yyt^.AssertArgumenting.Expr2^.Exprs.EnvIn:=yyt^.AssertArgumenting.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.AssertArgumenting.Expr2^.Exprs.TempOfsIn               := yyt^.AssertArgumenting.TempOfsIn;
yyt^.AssertArgumenting.Expr2^.Exprs.LevelIn:=yyt^.AssertArgumenting.LevelIn;
yyt^.AssertArgumenting.Expr2^.Exprs.ValDontCareIn:=yyt^.AssertArgumenting.ValDontCareIn;
yyt^.AssertArgumenting.Expr2^.Exprs.TableIn:=yyt^.AssertArgumenting.TableIn;
yyt^.AssertArgumenting.Expr2^.Exprs.ModuleIn:=yyt^.AssertArgumenting.ModuleIn;
yyVisit1 (yyt^.AssertArgumenting.Expr2);
yyt^.AssertArgumenting.Expr1^.Exprs.EnvIn:=yyt^.AssertArgumenting.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.AssertArgumenting.Expr1^.Exprs.TempOfsIn               := yyt^.AssertArgumenting.TempOfsIn;
yyt^.AssertArgumenting.Expr1^.Exprs.LevelIn:=yyt^.AssertArgumenting.LevelIn;
yyt^.AssertArgumenting.Expr1^.Exprs.ValDontCareIn:=yyt^.AssertArgumenting.ValDontCareIn;
yyt^.AssertArgumenting.Expr1^.Exprs.TableIn:=yyt^.AssertArgumenting.TableIn;
yyt^.AssertArgumenting.Expr1^.Exprs.ModuleIn:=yyt^.AssertArgumenting.ModuleIn;
yyVisit1 (yyt^.AssertArgumenting.Expr1);
(* line 4197 "oberon.aecp" *)

  yyt^.AssertArgumenting.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.AssertArgumenting.Expr1);
(* line 4199 "oberon.aecp" *)


  yyt^.AssertArgumenting.Coerce1                       := OB.cmtCoercion;
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.AssertArgumenting.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.AssertArgumenting.Op2Pos)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.AssertArgumenting.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.AssertArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.AssertArgumenting.EntryIn
                                   , yyt^.AssertArgumenting.typeRepr
                                   , yyt^.AssertArgumenting.Nextor
                                   , yyt^.AssertArgumenting.Nextor);
yyt^.AssertArgumenting.Nextion^.Designations.EnvIn:=yyt^.AssertArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.AssertArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.AssertArgumenting.MainEntryIn;
yyt^.AssertArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.AssertArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.AssertArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.AssertArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.AssertArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.AssertArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.AssertArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.AssertArgumenting.typeRepr
                                   , yyt^.AssertArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.AssertArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.AssertArgumenting.Nextion^.Designations.EntryPosition:=yyt^.AssertArgumenting.EntryPosition;
yyt^.AssertArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.AssertArgumenting.PrevEntryIn;
yyt^.AssertArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.AssertArgumenting.IsCallDesignatorIn;
yyt^.AssertArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.AssertArgumenting.ValDontCareIn;
yyt^.AssertArgumenting.Nextion^.Designations.TableIn:=yyt^.AssertArgumenting.TableIn;
yyt^.AssertArgumenting.Nextion^.Designations.ModuleIn:=yyt^.AssertArgumenting.ModuleIn;
yyt^.AssertArgumenting.Nextion^.Designations.LevelIn:=yyt^.AssertArgumenting.LevelIn;
yyVisit1 (yyt^.AssertArgumenting.Nextion);
yyt^.AssertArgumenting.Nextor^.Designors.EnvIn:=yyt^.AssertArgumenting.EnvIn;
yyt^.AssertArgumenting.Nextor^.Designors.LevelIn:=yyt^.AssertArgumenting.LevelIn;
yyVisit1 (yyt^.AssertArgumenting.Nextor);
(* line 4212 "oberon.aecp" *)
IF ~( T.IsBooleanType(yyt^.AssertArgumenting.Expr1^.Exprs.TypeReprOut)                                                                  
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.AssertArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4196 "oberon.aecp" *)

  yyt^.AssertArgumenting.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.AssertArgumenting.Expr2);
(* line 4215 "oberon.aecp" *)
IF ~( yyt^.AssertArgumenting.isEmptyExpr2
     OR T.IsIntegerType(yyt^.AssertArgumenting.Expr2^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.AssertArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4219 "oberon.aecp" *)
IF ~( yyt^.AssertArgumenting.isEmptyExpr2
     OR V.IsValidConstValue(yyt^.AssertArgumenting.Expr2^.Exprs.ValueReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgExprNotConstant,yyt^.AssertArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4200 "oberon.aecp" *)

  yyt^.AssertArgumenting.Coerce2                       := OB.cmtCoercion;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.AssertArgumenting.MainEntryOut             := yyt^.AssertArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.AssertArgumenting.TempOfsOut                    := ADR.MinSize2(yyt^.AssertArgumenting.Expr1^.Exprs.TempOfsOut,yyt^.AssertArgumenting.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.AssertArgumenting.ExprListOut                   := yyt^.AssertArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.AssertArgumenting.SignatureReprOut              := yyt^.AssertArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.AssertArgumenting.IsWritableOut                 := yyt^.AssertArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.AssertArgumenting.ValueReprOut                  := yyt^.AssertArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.AssertArgumenting.TypeReprOut                   := yyt^.AssertArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.AssertArgumenting.EntryOut                      := yyt^.AssertArgumenting.Nextion^.Designations.EntryOut;
| Tree.DecIncArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.DecIncArgumenting.Entry                         := OB.cmtObject;
yyt^.DecIncArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.DecIncArgumenting.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.DecIncArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.DecIncArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.DecIncArgumenting.LevelIn;
(* line 4203 "oberon.aecp" *)

  yyt^.DecIncArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.DecIncArgumenting.Op2Pos;
(* line 4202 "oberon.aecp" *)


  yyt^.DecIncArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.DecIncArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.DecIncArgumenting.ValDontCareIn;
yyt^.DecIncArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.DecIncArgumenting.TableIn;
yyt^.DecIncArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.DecIncArgumenting.ModuleIn;
yyVisit1 (yyt^.DecIncArgumenting.ExprLists);
yyt^.DecIncArgumenting.Expr2^.Exprs.EnvIn:=yyt^.DecIncArgumenting.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.DecIncArgumenting.Expr2^.Exprs.TempOfsIn               := yyt^.DecIncArgumenting.TempOfsIn;
yyt^.DecIncArgumenting.Expr2^.Exprs.LevelIn:=yyt^.DecIncArgumenting.LevelIn;
yyt^.DecIncArgumenting.Expr2^.Exprs.ValDontCareIn:=yyt^.DecIncArgumenting.ValDontCareIn;
yyt^.DecIncArgumenting.Expr2^.Exprs.TableIn:=yyt^.DecIncArgumenting.TableIn;
yyt^.DecIncArgumenting.Expr2^.Exprs.ModuleIn:=yyt^.DecIncArgumenting.ModuleIn;
yyVisit1 (yyt^.DecIncArgumenting.Expr2);
yyt^.DecIncArgumenting.Expr1^.Exprs.EnvIn:=yyt^.DecIncArgumenting.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.DecIncArgumenting.Expr1^.Exprs.TempOfsIn               := yyt^.DecIncArgumenting.TempOfsIn;
yyt^.DecIncArgumenting.Expr1^.Exprs.LevelIn:=yyt^.DecIncArgumenting.LevelIn;
yyt^.DecIncArgumenting.Expr1^.Exprs.ValDontCareIn:=yyt^.DecIncArgumenting.ValDontCareIn;
yyt^.DecIncArgumenting.Expr1^.Exprs.TableIn:=yyt^.DecIncArgumenting.TableIn;
yyt^.DecIncArgumenting.Expr1^.Exprs.ModuleIn:=yyt^.DecIncArgumenting.ModuleIn;
yyVisit1 (yyt^.DecIncArgumenting.Expr1);
(* line 4197 "oberon.aecp" *)

  yyt^.DecIncArgumenting.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.DecIncArgumenting.Expr1);
(* line 4199 "oberon.aecp" *)


  yyt^.DecIncArgumenting.Coerce1                       := OB.cmtCoercion;
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.DecIncArgumenting.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.DecIncArgumenting.Op2Pos)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.DecIncArgumenting.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.DecIncArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.DecIncArgumenting.EntryIn
                                   , yyt^.DecIncArgumenting.typeRepr
                                   , yyt^.DecIncArgumenting.Nextor
                                   , yyt^.DecIncArgumenting.Nextor);
yyt^.DecIncArgumenting.Nextion^.Designations.EnvIn:=yyt^.DecIncArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.DecIncArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.DecIncArgumenting.MainEntryIn;
yyt^.DecIncArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.DecIncArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.DecIncArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.DecIncArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.DecIncArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.DecIncArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.DecIncArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.DecIncArgumenting.typeRepr
                                   , yyt^.DecIncArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.DecIncArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.DecIncArgumenting.Nextion^.Designations.EntryPosition:=yyt^.DecIncArgumenting.EntryPosition;
yyt^.DecIncArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.DecIncArgumenting.PrevEntryIn;
yyt^.DecIncArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.DecIncArgumenting.IsCallDesignatorIn;
yyt^.DecIncArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.DecIncArgumenting.ValDontCareIn;
yyt^.DecIncArgumenting.Nextion^.Designations.TableIn:=yyt^.DecIncArgumenting.TableIn;
yyt^.DecIncArgumenting.Nextion^.Designations.ModuleIn:=yyt^.DecIncArgumenting.ModuleIn;
yyt^.DecIncArgumenting.Nextion^.Designations.LevelIn:=yyt^.DecIncArgumenting.LevelIn;
yyVisit1 (yyt^.DecIncArgumenting.Nextion);
yyt^.DecIncArgumenting.Nextor^.Designors.EnvIn:=yyt^.DecIncArgumenting.EnvIn;
yyt^.DecIncArgumenting.Nextor^.Designors.LevelIn:=yyt^.DecIncArgumenting.LevelIn;
yyVisit1 (yyt^.DecIncArgumenting.Nextor);
 E.SetLaccess(yyt^.DecIncArgumenting.Expr1^.Exprs.MainEntryOut     );
(* line 4256 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.DecIncArgumenting.Expr1^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.DecIncArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4259 "oberon.aecp" *)
IF ~( yyt^.DecIncArgumenting.Expr1^.Exprs.IsLValueOut
  ) THEN  ERR.MsgPos(ERR.MsgLValueExpected,yyt^.DecIncArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4196 "oberon.aecp" *)

  yyt^.DecIncArgumenting.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.DecIncArgumenting.Expr2);
(* line 4262 "oberon.aecp" *)
IF ~( yyt^.DecIncArgumenting.isEmptyExpr2
     OR ( T.IsIntegerType(yyt^.DecIncArgumenting.Expr2^.Exprs.TypeReprOut)
        & T.IsIncludedBy(yyt^.DecIncArgumenting.Expr2^.Exprs.TypeReprOut,yyt^.DecIncArgumenting.Expr1^.Exprs.TypeReprOut))
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.DecIncArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4252 "oberon.aecp" *)

  yyt^.DecIncArgumenting.Coerce2                       := CO.GetCoercion                                                           
                                   ( yyt^.DecIncArgumenting.Expr2^.Exprs.TypeReprOut
                                   , yyt^.DecIncArgumenting.Expr1^.Exprs.TypeReprOut);
(* line 3194 "oberon.aecp" *)

                                                          yyt^.DecIncArgumenting.MainEntryOut             := yyt^.DecIncArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.DecIncArgumenting.TempOfsOut                    := ADR.MinSize2(yyt^.DecIncArgumenting.Expr1^.Exprs.TempOfsOut,yyt^.DecIncArgumenting.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.DecIncArgumenting.ExprListOut                   := yyt^.DecIncArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.DecIncArgumenting.SignatureReprOut              := yyt^.DecIncArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.DecIncArgumenting.IsWritableOut                 := yyt^.DecIncArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.DecIncArgumenting.ValueReprOut                  := yyt^.DecIncArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.DecIncArgumenting.TypeReprOut                   := yyt^.DecIncArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.DecIncArgumenting.EntryOut                      := yyt^.DecIncArgumenting.Nextion^.Designations.EntryOut;
| Tree.DecArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.DecArgumenting.Entry                         := OB.cmtObject;
yyt^.DecArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.DecArgumenting.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.DecArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.DecArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.DecArgumenting.LevelIn;
(* line 4203 "oberon.aecp" *)

  yyt^.DecArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.DecArgumenting.Op2Pos;
(* line 4202 "oberon.aecp" *)


  yyt^.DecArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.DecArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.DecArgumenting.ValDontCareIn;
yyt^.DecArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.DecArgumenting.TableIn;
yyt^.DecArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.DecArgumenting.ModuleIn;
yyVisit1 (yyt^.DecArgumenting.ExprLists);
yyt^.DecArgumenting.Expr2^.Exprs.EnvIn:=yyt^.DecArgumenting.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.DecArgumenting.Expr2^.Exprs.TempOfsIn               := yyt^.DecArgumenting.TempOfsIn;
yyt^.DecArgumenting.Expr2^.Exprs.LevelIn:=yyt^.DecArgumenting.LevelIn;
yyt^.DecArgumenting.Expr2^.Exprs.ValDontCareIn:=yyt^.DecArgumenting.ValDontCareIn;
yyt^.DecArgumenting.Expr2^.Exprs.TableIn:=yyt^.DecArgumenting.TableIn;
yyt^.DecArgumenting.Expr2^.Exprs.ModuleIn:=yyt^.DecArgumenting.ModuleIn;
yyVisit1 (yyt^.DecArgumenting.Expr2);
yyt^.DecArgumenting.Expr1^.Exprs.EnvIn:=yyt^.DecArgumenting.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.DecArgumenting.Expr1^.Exprs.TempOfsIn               := yyt^.DecArgumenting.TempOfsIn;
yyt^.DecArgumenting.Expr1^.Exprs.LevelIn:=yyt^.DecArgumenting.LevelIn;
yyt^.DecArgumenting.Expr1^.Exprs.ValDontCareIn:=yyt^.DecArgumenting.ValDontCareIn;
yyt^.DecArgumenting.Expr1^.Exprs.TableIn:=yyt^.DecArgumenting.TableIn;
yyt^.DecArgumenting.Expr1^.Exprs.ModuleIn:=yyt^.DecArgumenting.ModuleIn;
yyVisit1 (yyt^.DecArgumenting.Expr1);
(* line 4197 "oberon.aecp" *)

  yyt^.DecArgumenting.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.DecArgumenting.Expr1);
(* line 4199 "oberon.aecp" *)


  yyt^.DecArgumenting.Coerce1                       := OB.cmtCoercion;
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.DecArgumenting.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.DecArgumenting.Op2Pos)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.DecArgumenting.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.DecArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.DecArgumenting.EntryIn
                                   , yyt^.DecArgumenting.typeRepr
                                   , yyt^.DecArgumenting.Nextor
                                   , yyt^.DecArgumenting.Nextor);
yyt^.DecArgumenting.Nextion^.Designations.EnvIn:=yyt^.DecArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.DecArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.DecArgumenting.MainEntryIn;
yyt^.DecArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.DecArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.DecArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.DecArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.DecArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.DecArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.DecArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.DecArgumenting.typeRepr
                                   , yyt^.DecArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.DecArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.DecArgumenting.Nextion^.Designations.EntryPosition:=yyt^.DecArgumenting.EntryPosition;
yyt^.DecArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.DecArgumenting.PrevEntryIn;
yyt^.DecArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.DecArgumenting.IsCallDesignatorIn;
yyt^.DecArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.DecArgumenting.ValDontCareIn;
yyt^.DecArgumenting.Nextion^.Designations.TableIn:=yyt^.DecArgumenting.TableIn;
yyt^.DecArgumenting.Nextion^.Designations.ModuleIn:=yyt^.DecArgumenting.ModuleIn;
yyt^.DecArgumenting.Nextion^.Designations.LevelIn:=yyt^.DecArgumenting.LevelIn;
yyVisit1 (yyt^.DecArgumenting.Nextion);
yyt^.DecArgumenting.Nextor^.Designors.EnvIn:=yyt^.DecArgumenting.EnvIn;
yyt^.DecArgumenting.Nextor^.Designors.LevelIn:=yyt^.DecArgumenting.LevelIn;
yyVisit1 (yyt^.DecArgumenting.Nextor);
 E.SetLaccess(yyt^.DecArgumenting.Expr1^.Exprs.MainEntryOut     );
(* line 4256 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.DecArgumenting.Expr1^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.DecArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4259 "oberon.aecp" *)
IF ~( yyt^.DecArgumenting.Expr1^.Exprs.IsLValueOut
  ) THEN  ERR.MsgPos(ERR.MsgLValueExpected,yyt^.DecArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4196 "oberon.aecp" *)

  yyt^.DecArgumenting.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.DecArgumenting.Expr2);
(* line 4262 "oberon.aecp" *)
IF ~( yyt^.DecArgumenting.isEmptyExpr2
     OR ( T.IsIntegerType(yyt^.DecArgumenting.Expr2^.Exprs.TypeReprOut)
        & T.IsIncludedBy(yyt^.DecArgumenting.Expr2^.Exprs.TypeReprOut,yyt^.DecArgumenting.Expr1^.Exprs.TypeReprOut))
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.DecArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4252 "oberon.aecp" *)

  yyt^.DecArgumenting.Coerce2                       := CO.GetCoercion                                                           
                                   ( yyt^.DecArgumenting.Expr2^.Exprs.TypeReprOut
                                   , yyt^.DecArgumenting.Expr1^.Exprs.TypeReprOut);
(* line 3194 "oberon.aecp" *)

                                                          yyt^.DecArgumenting.MainEntryOut             := yyt^.DecArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.DecArgumenting.TempOfsOut                    := ADR.MinSize2(yyt^.DecArgumenting.Expr1^.Exprs.TempOfsOut,yyt^.DecArgumenting.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.DecArgumenting.ExprListOut                   := yyt^.DecArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.DecArgumenting.SignatureReprOut              := yyt^.DecArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.DecArgumenting.IsWritableOut                 := yyt^.DecArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.DecArgumenting.ValueReprOut                  := yyt^.DecArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.DecArgumenting.TypeReprOut                   := yyt^.DecArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.DecArgumenting.EntryOut                      := yyt^.DecArgumenting.Nextion^.Designations.EntryOut;
| Tree.IncArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.IncArgumenting.Entry                         := OB.cmtObject;
yyt^.IncArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.IncArgumenting.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.IncArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.IncArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.IncArgumenting.LevelIn;
(* line 4203 "oberon.aecp" *)

  yyt^.IncArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.IncArgumenting.Op2Pos;
(* line 4202 "oberon.aecp" *)


  yyt^.IncArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.IncArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.IncArgumenting.ValDontCareIn;
yyt^.IncArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.IncArgumenting.TableIn;
yyt^.IncArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.IncArgumenting.ModuleIn;
yyVisit1 (yyt^.IncArgumenting.ExprLists);
yyt^.IncArgumenting.Expr2^.Exprs.EnvIn:=yyt^.IncArgumenting.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.IncArgumenting.Expr2^.Exprs.TempOfsIn               := yyt^.IncArgumenting.TempOfsIn;
yyt^.IncArgumenting.Expr2^.Exprs.LevelIn:=yyt^.IncArgumenting.LevelIn;
yyt^.IncArgumenting.Expr2^.Exprs.ValDontCareIn:=yyt^.IncArgumenting.ValDontCareIn;
yyt^.IncArgumenting.Expr2^.Exprs.TableIn:=yyt^.IncArgumenting.TableIn;
yyt^.IncArgumenting.Expr2^.Exprs.ModuleIn:=yyt^.IncArgumenting.ModuleIn;
yyVisit1 (yyt^.IncArgumenting.Expr2);
yyt^.IncArgumenting.Expr1^.Exprs.EnvIn:=yyt^.IncArgumenting.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.IncArgumenting.Expr1^.Exprs.TempOfsIn               := yyt^.IncArgumenting.TempOfsIn;
yyt^.IncArgumenting.Expr1^.Exprs.LevelIn:=yyt^.IncArgumenting.LevelIn;
yyt^.IncArgumenting.Expr1^.Exprs.ValDontCareIn:=yyt^.IncArgumenting.ValDontCareIn;
yyt^.IncArgumenting.Expr1^.Exprs.TableIn:=yyt^.IncArgumenting.TableIn;
yyt^.IncArgumenting.Expr1^.Exprs.ModuleIn:=yyt^.IncArgumenting.ModuleIn;
yyVisit1 (yyt^.IncArgumenting.Expr1);
(* line 4197 "oberon.aecp" *)

  yyt^.IncArgumenting.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.IncArgumenting.Expr1);
(* line 4199 "oberon.aecp" *)


  yyt^.IncArgumenting.Coerce1                       := OB.cmtCoercion;
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.IncArgumenting.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.IncArgumenting.Op2Pos)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.IncArgumenting.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.IncArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.IncArgumenting.EntryIn
                                   , yyt^.IncArgumenting.typeRepr
                                   , yyt^.IncArgumenting.Nextor
                                   , yyt^.IncArgumenting.Nextor);
yyt^.IncArgumenting.Nextion^.Designations.EnvIn:=yyt^.IncArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.IncArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.IncArgumenting.MainEntryIn;
yyt^.IncArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.IncArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.IncArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.IncArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.IncArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.IncArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.IncArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.IncArgumenting.typeRepr
                                   , yyt^.IncArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.IncArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.IncArgumenting.Nextion^.Designations.EntryPosition:=yyt^.IncArgumenting.EntryPosition;
yyt^.IncArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.IncArgumenting.PrevEntryIn;
yyt^.IncArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.IncArgumenting.IsCallDesignatorIn;
yyt^.IncArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.IncArgumenting.ValDontCareIn;
yyt^.IncArgumenting.Nextion^.Designations.TableIn:=yyt^.IncArgumenting.TableIn;
yyt^.IncArgumenting.Nextion^.Designations.ModuleIn:=yyt^.IncArgumenting.ModuleIn;
yyt^.IncArgumenting.Nextion^.Designations.LevelIn:=yyt^.IncArgumenting.LevelIn;
yyVisit1 (yyt^.IncArgumenting.Nextion);
yyt^.IncArgumenting.Nextor^.Designors.EnvIn:=yyt^.IncArgumenting.EnvIn;
yyt^.IncArgumenting.Nextor^.Designors.LevelIn:=yyt^.IncArgumenting.LevelIn;
yyVisit1 (yyt^.IncArgumenting.Nextor);
 E.SetLaccess(yyt^.IncArgumenting.Expr1^.Exprs.MainEntryOut     );
(* line 4256 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.IncArgumenting.Expr1^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.IncArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4259 "oberon.aecp" *)
IF ~( yyt^.IncArgumenting.Expr1^.Exprs.IsLValueOut
  ) THEN  ERR.MsgPos(ERR.MsgLValueExpected,yyt^.IncArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4196 "oberon.aecp" *)

  yyt^.IncArgumenting.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.IncArgumenting.Expr2);
(* line 4262 "oberon.aecp" *)
IF ~( yyt^.IncArgumenting.isEmptyExpr2
     OR ( T.IsIntegerType(yyt^.IncArgumenting.Expr2^.Exprs.TypeReprOut)
        & T.IsIncludedBy(yyt^.IncArgumenting.Expr2^.Exprs.TypeReprOut,yyt^.IncArgumenting.Expr1^.Exprs.TypeReprOut))
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.IncArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4252 "oberon.aecp" *)

  yyt^.IncArgumenting.Coerce2                       := CO.GetCoercion                                                           
                                   ( yyt^.IncArgumenting.Expr2^.Exprs.TypeReprOut
                                   , yyt^.IncArgumenting.Expr1^.Exprs.TypeReprOut);
(* line 3194 "oberon.aecp" *)

                                                          yyt^.IncArgumenting.MainEntryOut             := yyt^.IncArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.IncArgumenting.TempOfsOut                    := ADR.MinSize2(yyt^.IncArgumenting.Expr1^.Exprs.TempOfsOut,yyt^.IncArgumenting.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.IncArgumenting.ExprListOut                   := yyt^.IncArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.IncArgumenting.SignatureReprOut              := yyt^.IncArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.IncArgumenting.IsWritableOut                 := yyt^.IncArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.IncArgumenting.ValueReprOut                  := yyt^.IncArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.IncArgumenting.TypeReprOut                   := yyt^.IncArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.IncArgumenting.EntryOut                      := yyt^.IncArgumenting.Nextion^.Designations.EntryOut;
| Tree.PredeclArgumenting2:
(* line 2250 "oberon.aecp" *)

  yyt^.PredeclArgumenting2.Entry                         := OB.cmtObject;
yyt^.PredeclArgumenting2.ExprLists^.ExprLists.EnvIn:=yyt^.PredeclArgumenting2.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.PredeclArgumenting2.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.PredeclArgumenting2.ExprLists^.ExprLists.LevelIn:=yyt^.PredeclArgumenting2.LevelIn;
(* line 4275 "oberon.aecp" *)

  yyt^.PredeclArgumenting2.ExprLists^.ExprLists.ClosingPosIn        := yyt^.PredeclArgumenting2.Op2Pos;
(* line 4274 "oberon.aecp" *)


  yyt^.PredeclArgumenting2.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.PredeclArgumenting2.ExprLists^.ExprLists.ValDontCareIn:=yyt^.PredeclArgumenting2.ValDontCareIn;
yyt^.PredeclArgumenting2.ExprLists^.ExprLists.TableIn:=yyt^.PredeclArgumenting2.TableIn;
yyt^.PredeclArgumenting2.ExprLists^.ExprLists.ModuleIn:=yyt^.PredeclArgumenting2.ModuleIn;
yyVisit1 (yyt^.PredeclArgumenting2.ExprLists);
yyt^.PredeclArgumenting2.Expr2^.Exprs.EnvIn:=yyt^.PredeclArgumenting2.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.PredeclArgumenting2.Expr2^.Exprs.TempOfsIn               := yyt^.PredeclArgumenting2.TempOfsIn;
yyt^.PredeclArgumenting2.Expr2^.Exprs.LevelIn:=yyt^.PredeclArgumenting2.LevelIn;
yyt^.PredeclArgumenting2.Expr2^.Exprs.ValDontCareIn:=yyt^.PredeclArgumenting2.ValDontCareIn;
yyt^.PredeclArgumenting2.Expr2^.Exprs.TableIn:=yyt^.PredeclArgumenting2.TableIn;
yyt^.PredeclArgumenting2.Expr2^.Exprs.ModuleIn:=yyt^.PredeclArgumenting2.ModuleIn;
yyVisit1 (yyt^.PredeclArgumenting2.Expr2);
yyt^.PredeclArgumenting2.Expr1^.Exprs.EnvIn:=yyt^.PredeclArgumenting2.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.PredeclArgumenting2.Expr1^.Exprs.TempOfsIn               := yyt^.PredeclArgumenting2.TempOfsIn;
yyt^.PredeclArgumenting2.Expr1^.Exprs.LevelIn:=yyt^.PredeclArgumenting2.LevelIn;
yyt^.PredeclArgumenting2.Expr1^.Exprs.ValDontCareIn:=yyt^.PredeclArgumenting2.ValDontCareIn;
yyt^.PredeclArgumenting2.Expr1^.Exprs.TableIn:=yyt^.PredeclArgumenting2.TableIn;
yyt^.PredeclArgumenting2.Expr1^.Exprs.ModuleIn:=yyt^.PredeclArgumenting2.ModuleIn;
yyVisit1 (yyt^.PredeclArgumenting2.Expr1);
(* line 4271 "oberon.aecp" *)

  yyt^.PredeclArgumenting2.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.PredeclArgumenting2.Expr1)
                                 & ~TT.IsEmptyExpr(yyt^.PredeclArgumenting2.Expr2);
(* line 4199 "oberon.aecp" *)


  yyt^.PredeclArgumenting2.Coerce1                       := OB.cmtCoercion;
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.PredeclArgumenting2.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.PredeclArgumenting2.Op2Pos)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.PredeclArgumenting2.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.PredeclArgumenting2.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.PredeclArgumenting2.EntryIn
                                   , yyt^.PredeclArgumenting2.typeRepr
                                   , yyt^.PredeclArgumenting2.Nextor
                                   , yyt^.PredeclArgumenting2.Nextor);
yyt^.PredeclArgumenting2.Nextion^.Designations.EnvIn:=yyt^.PredeclArgumenting2.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.PredeclArgumenting2.Nextion^.Designations.MainEntryIn      := yyt^.PredeclArgumenting2.MainEntryIn;
yyt^.PredeclArgumenting2.Nextion^.Designations.TempOfsIn:=yyt^.PredeclArgumenting2.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.PredeclArgumenting2.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.PredeclArgumenting2.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.PredeclArgumenting2.Nextion^.Designations.ValueReprIn           := yyt^.PredeclArgumenting2.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.PredeclArgumenting2.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.PredeclArgumenting2.typeRepr
                                   , yyt^.PredeclArgumenting2.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.PredeclArgumenting2.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.PredeclArgumenting2.Nextion^.Designations.EntryPosition:=yyt^.PredeclArgumenting2.EntryPosition;
yyt^.PredeclArgumenting2.Nextion^.Designations.PrevEntryIn:=yyt^.PredeclArgumenting2.PrevEntryIn;
yyt^.PredeclArgumenting2.Nextion^.Designations.IsCallDesignatorIn:=yyt^.PredeclArgumenting2.IsCallDesignatorIn;
yyt^.PredeclArgumenting2.Nextion^.Designations.ValDontCareIn:=yyt^.PredeclArgumenting2.ValDontCareIn;
yyt^.PredeclArgumenting2.Nextion^.Designations.TableIn:=yyt^.PredeclArgumenting2.TableIn;
yyt^.PredeclArgumenting2.Nextion^.Designations.ModuleIn:=yyt^.PredeclArgumenting2.ModuleIn;
yyt^.PredeclArgumenting2.Nextion^.Designations.LevelIn:=yyt^.PredeclArgumenting2.LevelIn;
yyVisit1 (yyt^.PredeclArgumenting2.Nextion);
yyt^.PredeclArgumenting2.Nextor^.Designors.EnvIn:=yyt^.PredeclArgumenting2.EnvIn;
yyt^.PredeclArgumenting2.Nextor^.Designors.LevelIn:=yyt^.PredeclArgumenting2.LevelIn;
yyVisit1 (yyt^.PredeclArgumenting2.Nextor);
(* line 4196 "oberon.aecp" *)

  yyt^.PredeclArgumenting2.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.PredeclArgumenting2.Expr2);
(* line 4200 "oberon.aecp" *)

  yyt^.PredeclArgumenting2.Coerce2                       := OB.cmtCoercion;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.PredeclArgumenting2.MainEntryOut             := yyt^.PredeclArgumenting2.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.PredeclArgumenting2.TempOfsOut                    := ADR.MinSize2(yyt^.PredeclArgumenting2.Expr1^.Exprs.TempOfsOut,yyt^.PredeclArgumenting2.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.PredeclArgumenting2.ExprListOut                   := yyt^.PredeclArgumenting2.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.PredeclArgumenting2.SignatureReprOut              := yyt^.PredeclArgumenting2.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.PredeclArgumenting2.IsWritableOut                 := yyt^.PredeclArgumenting2.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.PredeclArgumenting2.ValueReprOut                  := yyt^.PredeclArgumenting2.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.PredeclArgumenting2.TypeReprOut                   := yyt^.PredeclArgumenting2.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.PredeclArgumenting2.EntryOut                      := yyt^.PredeclArgumenting2.Nextion^.Designations.EntryOut;
| Tree.AshArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.AshArgumenting.Entry                         := OB.cmtObject;
yyt^.AshArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.AshArgumenting.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.AshArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.AshArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.AshArgumenting.LevelIn;
(* line 4275 "oberon.aecp" *)

  yyt^.AshArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.AshArgumenting.Op2Pos;
(* line 4274 "oberon.aecp" *)


  yyt^.AshArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.AshArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.AshArgumenting.ValDontCareIn;
yyt^.AshArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.AshArgumenting.TableIn;
yyt^.AshArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.AshArgumenting.ModuleIn;
yyVisit1 (yyt^.AshArgumenting.ExprLists);
yyt^.AshArgumenting.Expr2^.Exprs.EnvIn:=yyt^.AshArgumenting.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.AshArgumenting.Expr2^.Exprs.TempOfsIn               := yyt^.AshArgumenting.TempOfsIn;
yyt^.AshArgumenting.Expr2^.Exprs.LevelIn:=yyt^.AshArgumenting.LevelIn;
yyt^.AshArgumenting.Expr2^.Exprs.ValDontCareIn:=yyt^.AshArgumenting.ValDontCareIn;
yyt^.AshArgumenting.Expr2^.Exprs.TableIn:=yyt^.AshArgumenting.TableIn;
yyt^.AshArgumenting.Expr2^.Exprs.ModuleIn:=yyt^.AshArgumenting.ModuleIn;
yyVisit1 (yyt^.AshArgumenting.Expr2);
yyt^.AshArgumenting.Expr1^.Exprs.EnvIn:=yyt^.AshArgumenting.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.AshArgumenting.Expr1^.Exprs.TempOfsIn               := yyt^.AshArgumenting.TempOfsIn;
yyt^.AshArgumenting.Expr1^.Exprs.LevelIn:=yyt^.AshArgumenting.LevelIn;
yyt^.AshArgumenting.Expr1^.Exprs.ValDontCareIn:=yyt^.AshArgumenting.ValDontCareIn;
yyt^.AshArgumenting.Expr1^.Exprs.TableIn:=yyt^.AshArgumenting.TableIn;
yyt^.AshArgumenting.Expr1^.Exprs.ModuleIn:=yyt^.AshArgumenting.ModuleIn;
yyVisit1 (yyt^.AshArgumenting.Expr1);
(* line 4271 "oberon.aecp" *)

  yyt^.AshArgumenting.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.AshArgumenting.Expr1)
                                 & ~TT.IsEmptyExpr(yyt^.AshArgumenting.Expr2);
(* line 4285 "oberon.aecp" *)


  yyt^.AshArgumenting.Coerce1                       := CO.GetCoercion
                                   ( yyt^.AshArgumenting.Expr1^.Exprs.TypeReprOut
                                   , OB.cLongintTypeRepr);
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.AshArgumenting.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.AshArgumenting.Op2Pos)
 END;
(* line 4282 "oberon.aecp" *)

  yyt^.AshArgumenting.typeRepr                      := OB.cLongintTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.AshArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.AshArgumenting.EntryIn
                                   , yyt^.AshArgumenting.typeRepr
                                   , yyt^.AshArgumenting.Nextor
                                   , yyt^.AshArgumenting.Nextor);
yyt^.AshArgumenting.Nextion^.Designations.EnvIn:=yyt^.AshArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.AshArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.AshArgumenting.MainEntryIn;
yyt^.AshArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.AshArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.AshArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4283 "oberon.aecp" *)
 yyt^.AshArgumenting.valueRepr:=V.AshValue(yyt^.AshArgumenting.Expr1^.Exprs.ValueReprOut,yyt^.AshArgumenting.Expr2^.Exprs.ValueReprOut,yyt^.AshArgumenting.OK); 
(* line 4048 "oberon.aecp" *)

  yyt^.AshArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.AshArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.AshArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.AshArgumenting.typeRepr
                                   , yyt^.AshArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.AshArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.AshArgumenting.Nextion^.Designations.EntryPosition:=yyt^.AshArgumenting.EntryPosition;
yyt^.AshArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.AshArgumenting.PrevEntryIn;
yyt^.AshArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.AshArgumenting.IsCallDesignatorIn;
yyt^.AshArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.AshArgumenting.ValDontCareIn;
yyt^.AshArgumenting.Nextion^.Designations.TableIn:=yyt^.AshArgumenting.TableIn;
yyt^.AshArgumenting.Nextion^.Designations.ModuleIn:=yyt^.AshArgumenting.ModuleIn;
yyt^.AshArgumenting.Nextion^.Designations.LevelIn:=yyt^.AshArgumenting.LevelIn;
yyVisit1 (yyt^.AshArgumenting.Nextion);
yyt^.AshArgumenting.Nextor^.Designors.EnvIn:=yyt^.AshArgumenting.EnvIn;
yyt^.AshArgumenting.Nextor^.Designors.LevelIn:=yyt^.AshArgumenting.LevelIn;
yyVisit1 (yyt^.AshArgumenting.Nextor);
(* line 4292 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.AshArgumenting.Expr1^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.AshArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4295 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.AshArgumenting.Expr2^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.AshArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4298 "oberon.aecp" *)
IF ~( yyt^.AshArgumenting.OK
  ) THEN  ERR.MsgPos(ERR.MsgConstArithmeticError,yyt^.AshArgumenting.EntryPosition)
 END;
(* line 4196 "oberon.aecp" *)

  yyt^.AshArgumenting.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.AshArgumenting.Expr2);
(* line 4288 "oberon.aecp" *)

  yyt^.AshArgumenting.Coerce2                       := CO.GetCoercion
                                   ( yyt^.AshArgumenting.Expr2^.Exprs.TypeReprOut
                                   , OB.cLongintTypeRepr);
(* line 3194 "oberon.aecp" *)

                                                          yyt^.AshArgumenting.MainEntryOut             := yyt^.AshArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.AshArgumenting.TempOfsOut                    := ADR.MinSize2(yyt^.AshArgumenting.Expr1^.Exprs.TempOfsOut,yyt^.AshArgumenting.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.AshArgumenting.ExprListOut                   := yyt^.AshArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.AshArgumenting.SignatureReprOut              := yyt^.AshArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.AshArgumenting.IsWritableOut                 := yyt^.AshArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.AshArgumenting.ValueReprOut                  := yyt^.AshArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.AshArgumenting.TypeReprOut                   := yyt^.AshArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.AshArgumenting.EntryOut                      := yyt^.AshArgumenting.Nextion^.Designations.EntryOut;
| Tree.CopyArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.CopyArgumenting.Entry                         := OB.cmtObject;
yyt^.CopyArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.CopyArgumenting.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.CopyArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.CopyArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.CopyArgumenting.LevelIn;
(* line 4275 "oberon.aecp" *)

  yyt^.CopyArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.CopyArgumenting.Op2Pos;
(* line 4274 "oberon.aecp" *)


  yyt^.CopyArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.CopyArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.CopyArgumenting.ValDontCareIn;
yyt^.CopyArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.CopyArgumenting.TableIn;
yyt^.CopyArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.CopyArgumenting.ModuleIn;
yyVisit1 (yyt^.CopyArgumenting.ExprLists);
yyt^.CopyArgumenting.Expr2^.Exprs.EnvIn:=yyt^.CopyArgumenting.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.CopyArgumenting.Expr2^.Exprs.TempOfsIn               := yyt^.CopyArgumenting.TempOfsIn;
yyt^.CopyArgumenting.Expr2^.Exprs.LevelIn:=yyt^.CopyArgumenting.LevelIn;
yyt^.CopyArgumenting.Expr2^.Exprs.ValDontCareIn:=yyt^.CopyArgumenting.ValDontCareIn;
yyt^.CopyArgumenting.Expr2^.Exprs.TableIn:=yyt^.CopyArgumenting.TableIn;
yyt^.CopyArgumenting.Expr2^.Exprs.ModuleIn:=yyt^.CopyArgumenting.ModuleIn;
yyVisit1 (yyt^.CopyArgumenting.Expr2);
yyt^.CopyArgumenting.Expr1^.Exprs.EnvIn:=yyt^.CopyArgumenting.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.CopyArgumenting.Expr1^.Exprs.TempOfsIn               := yyt^.CopyArgumenting.TempOfsIn;
yyt^.CopyArgumenting.Expr1^.Exprs.LevelIn:=yyt^.CopyArgumenting.LevelIn;
yyt^.CopyArgumenting.Expr1^.Exprs.ValDontCareIn:=yyt^.CopyArgumenting.ValDontCareIn;
yyt^.CopyArgumenting.Expr1^.Exprs.TableIn:=yyt^.CopyArgumenting.TableIn;
yyt^.CopyArgumenting.Expr1^.Exprs.ModuleIn:=yyt^.CopyArgumenting.ModuleIn;
yyVisit1 (yyt^.CopyArgumenting.Expr1);
(* line 4271 "oberon.aecp" *)

  yyt^.CopyArgumenting.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.CopyArgumenting.Expr1)
                                 & ~TT.IsEmptyExpr(yyt^.CopyArgumenting.Expr2);
(* line 4199 "oberon.aecp" *)


  yyt^.CopyArgumenting.Coerce1                       := OB.cmtCoercion;
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.CopyArgumenting.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.CopyArgumenting.Op2Pos)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.CopyArgumenting.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.CopyArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.CopyArgumenting.EntryIn
                                   , yyt^.CopyArgumenting.typeRepr
                                   , yyt^.CopyArgumenting.Nextor
                                   , yyt^.CopyArgumenting.Nextor);
yyt^.CopyArgumenting.Nextion^.Designations.EnvIn:=yyt^.CopyArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.CopyArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.CopyArgumenting.MainEntryIn;
yyt^.CopyArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.CopyArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.CopyArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.CopyArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.CopyArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.CopyArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.CopyArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.CopyArgumenting.typeRepr
                                   , yyt^.CopyArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.CopyArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.CopyArgumenting.Nextion^.Designations.EntryPosition:=yyt^.CopyArgumenting.EntryPosition;
yyt^.CopyArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.CopyArgumenting.PrevEntryIn;
yyt^.CopyArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.CopyArgumenting.IsCallDesignatorIn;
yyt^.CopyArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.CopyArgumenting.ValDontCareIn;
yyt^.CopyArgumenting.Nextion^.Designations.TableIn:=yyt^.CopyArgumenting.TableIn;
yyt^.CopyArgumenting.Nextion^.Designations.ModuleIn:=yyt^.CopyArgumenting.ModuleIn;
yyt^.CopyArgumenting.Nextion^.Designations.LevelIn:=yyt^.CopyArgumenting.LevelIn;
yyVisit1 (yyt^.CopyArgumenting.Nextion);
yyt^.CopyArgumenting.Nextor^.Designors.EnvIn:=yyt^.CopyArgumenting.EnvIn;
yyt^.CopyArgumenting.Nextor^.Designors.LevelIn:=yyt^.CopyArgumenting.LevelIn;
yyVisit1 (yyt^.CopyArgumenting.Nextor);
 E.SetLaccess(yyt^.CopyArgumenting.Expr1^.Exprs.MainEntryOut     );
(* line 4305 "oberon.aecp" *)
IF ~( T.IsStringOrCharArrayType(yyt^.CopyArgumenting.Expr1^.Exprs.TypeReprOut)                                                          
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.CopyArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4308 "oberon.aecp" *)
IF ~( T.IsStringOrCharArrayType(yyt^.CopyArgumenting.Expr1^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.CopyArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4311 "oberon.aecp" *)
IF ~( T.IsCharArrayType(yyt^.CopyArgumenting.Expr2^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.CopyArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4314 "oberon.aecp" *)
IF ~( yyt^.CopyArgumenting.Expr2^.Exprs.IsLValueOut
  ) THEN  ERR.MsgPos(ERR.MsgLValueExpected,yyt^.CopyArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4196 "oberon.aecp" *)

  yyt^.CopyArgumenting.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.CopyArgumenting.Expr2);
(* line 4200 "oberon.aecp" *)

  yyt^.CopyArgumenting.Coerce2                       := OB.cmtCoercion;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.CopyArgumenting.MainEntryOut             := yyt^.CopyArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.CopyArgumenting.TempOfsOut                    := ADR.MinSize2(yyt^.CopyArgumenting.Expr1^.Exprs.TempOfsOut,yyt^.CopyArgumenting.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.CopyArgumenting.ExprListOut                   := yyt^.CopyArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.CopyArgumenting.SignatureReprOut              := yyt^.CopyArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.CopyArgumenting.IsWritableOut                 := yyt^.CopyArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.CopyArgumenting.ValueReprOut                  := yyt^.CopyArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.CopyArgumenting.TypeReprOut                   := yyt^.CopyArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.CopyArgumenting.EntryOut                      := yyt^.CopyArgumenting.Nextion^.Designations.EntryOut;
| Tree.ExclInclArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.ExclInclArgumenting.Entry                         := OB.cmtObject;
yyt^.ExclInclArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.ExclInclArgumenting.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.ExclInclArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.ExclInclArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.ExclInclArgumenting.LevelIn;
(* line 4275 "oberon.aecp" *)

  yyt^.ExclInclArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.ExclInclArgumenting.Op2Pos;
(* line 4274 "oberon.aecp" *)


  yyt^.ExclInclArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.ExclInclArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.ExclInclArgumenting.ValDontCareIn;
yyt^.ExclInclArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.ExclInclArgumenting.TableIn;
yyt^.ExclInclArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.ExclInclArgumenting.ModuleIn;
yyVisit1 (yyt^.ExclInclArgumenting.ExprLists);
yyt^.ExclInclArgumenting.Expr2^.Exprs.EnvIn:=yyt^.ExclInclArgumenting.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.ExclInclArgumenting.Expr2^.Exprs.TempOfsIn               := yyt^.ExclInclArgumenting.TempOfsIn;
yyt^.ExclInclArgumenting.Expr2^.Exprs.LevelIn:=yyt^.ExclInclArgumenting.LevelIn;
yyt^.ExclInclArgumenting.Expr2^.Exprs.ValDontCareIn:=yyt^.ExclInclArgumenting.ValDontCareIn;
yyt^.ExclInclArgumenting.Expr2^.Exprs.TableIn:=yyt^.ExclInclArgumenting.TableIn;
yyt^.ExclInclArgumenting.Expr2^.Exprs.ModuleIn:=yyt^.ExclInclArgumenting.ModuleIn;
yyVisit1 (yyt^.ExclInclArgumenting.Expr2);
yyt^.ExclInclArgumenting.Expr1^.Exprs.EnvIn:=yyt^.ExclInclArgumenting.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.ExclInclArgumenting.Expr1^.Exprs.TempOfsIn               := yyt^.ExclInclArgumenting.TempOfsIn;
yyt^.ExclInclArgumenting.Expr1^.Exprs.LevelIn:=yyt^.ExclInclArgumenting.LevelIn;
yyt^.ExclInclArgumenting.Expr1^.Exprs.ValDontCareIn:=yyt^.ExclInclArgumenting.ValDontCareIn;
yyt^.ExclInclArgumenting.Expr1^.Exprs.TableIn:=yyt^.ExclInclArgumenting.TableIn;
yyt^.ExclInclArgumenting.Expr1^.Exprs.ModuleIn:=yyt^.ExclInclArgumenting.ModuleIn;
yyVisit1 (yyt^.ExclInclArgumenting.Expr1);
(* line 4271 "oberon.aecp" *)

  yyt^.ExclInclArgumenting.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.ExclInclArgumenting.Expr1)
                                 & ~TT.IsEmptyExpr(yyt^.ExclInclArgumenting.Expr2);
(* line 4199 "oberon.aecp" *)


  yyt^.ExclInclArgumenting.Coerce1                       := OB.cmtCoercion;
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.ExclInclArgumenting.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.ExclInclArgumenting.Op2Pos)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.ExclInclArgumenting.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.ExclInclArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.ExclInclArgumenting.EntryIn
                                   , yyt^.ExclInclArgumenting.typeRepr
                                   , yyt^.ExclInclArgumenting.Nextor
                                   , yyt^.ExclInclArgumenting.Nextor);
yyt^.ExclInclArgumenting.Nextion^.Designations.EnvIn:=yyt^.ExclInclArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.ExclInclArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.ExclInclArgumenting.MainEntryIn;
yyt^.ExclInclArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.ExclInclArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.ExclInclArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.ExclInclArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.ExclInclArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.ExclInclArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.ExclInclArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.ExclInclArgumenting.typeRepr
                                   , yyt^.ExclInclArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.ExclInclArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.ExclInclArgumenting.Nextion^.Designations.EntryPosition:=yyt^.ExclInclArgumenting.EntryPosition;
yyt^.ExclInclArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.ExclInclArgumenting.PrevEntryIn;
yyt^.ExclInclArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.ExclInclArgumenting.IsCallDesignatorIn;
yyt^.ExclInclArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.ExclInclArgumenting.ValDontCareIn;
yyt^.ExclInclArgumenting.Nextion^.Designations.TableIn:=yyt^.ExclInclArgumenting.TableIn;
yyt^.ExclInclArgumenting.Nextion^.Designations.ModuleIn:=yyt^.ExclInclArgumenting.ModuleIn;
yyt^.ExclInclArgumenting.Nextion^.Designations.LevelIn:=yyt^.ExclInclArgumenting.LevelIn;
yyVisit1 (yyt^.ExclInclArgumenting.Nextion);
yyt^.ExclInclArgumenting.Nextor^.Designors.EnvIn:=yyt^.ExclInclArgumenting.EnvIn;
yyt^.ExclInclArgumenting.Nextor^.Designors.LevelIn:=yyt^.ExclInclArgumenting.LevelIn;
yyVisit1 (yyt^.ExclInclArgumenting.Nextor);
 E.SetLaccess(yyt^.ExclInclArgumenting.Expr1^.Exprs.MainEntryOut     );
(* line 4325 "oberon.aecp" *)
IF ~( T.IsSetType(yyt^.ExclInclArgumenting.Expr1^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.ExclInclArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4328 "oberon.aecp" *)
IF ~( yyt^.ExclInclArgumenting.Expr1^.Exprs.IsLValueOut
  ) THEN  ERR.MsgPos(ERR.MsgLValueExpected,yyt^.ExclInclArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4331 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.ExclInclArgumenting.Expr2^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.ExclInclArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4334 "oberon.aecp" *)
IF ~( V.IsLegalSetValue(yyt^.ExclInclArgumenting.Expr2^.Exprs.ValueReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgIntOutOfSet,yyt^.ExclInclArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4196 "oberon.aecp" *)

  yyt^.ExclInclArgumenting.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.ExclInclArgumenting.Expr2);
(* line 4321 "oberon.aecp" *)

  yyt^.ExclInclArgumenting.Coerce2                       := CO.GetCoercion                                                         
                                   ( yyt^.ExclInclArgumenting.Expr2^.Exprs.TypeReprOut
                                   , OB.cLongintTypeRepr);
(* line 3194 "oberon.aecp" *)

                                                          yyt^.ExclInclArgumenting.MainEntryOut             := yyt^.ExclInclArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.ExclInclArgumenting.TempOfsOut                    := ADR.MinSize2(yyt^.ExclInclArgumenting.Expr1^.Exprs.TempOfsOut,yyt^.ExclInclArgumenting.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.ExclInclArgumenting.ExprListOut                   := yyt^.ExclInclArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.ExclInclArgumenting.SignatureReprOut              := yyt^.ExclInclArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.ExclInclArgumenting.IsWritableOut                 := yyt^.ExclInclArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.ExclInclArgumenting.ValueReprOut                  := yyt^.ExclInclArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.ExclInclArgumenting.TypeReprOut                   := yyt^.ExclInclArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.ExclInclArgumenting.EntryOut                      := yyt^.ExclInclArgumenting.Nextion^.Designations.EntryOut;
| Tree.ExclArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.ExclArgumenting.Entry                         := OB.cmtObject;
yyt^.ExclArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.ExclArgumenting.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.ExclArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.ExclArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.ExclArgumenting.LevelIn;
(* line 4275 "oberon.aecp" *)

  yyt^.ExclArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.ExclArgumenting.Op2Pos;
(* line 4274 "oberon.aecp" *)


  yyt^.ExclArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.ExclArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.ExclArgumenting.ValDontCareIn;
yyt^.ExclArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.ExclArgumenting.TableIn;
yyt^.ExclArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.ExclArgumenting.ModuleIn;
yyVisit1 (yyt^.ExclArgumenting.ExprLists);
yyt^.ExclArgumenting.Expr2^.Exprs.EnvIn:=yyt^.ExclArgumenting.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.ExclArgumenting.Expr2^.Exprs.TempOfsIn               := yyt^.ExclArgumenting.TempOfsIn;
yyt^.ExclArgumenting.Expr2^.Exprs.LevelIn:=yyt^.ExclArgumenting.LevelIn;
yyt^.ExclArgumenting.Expr2^.Exprs.ValDontCareIn:=yyt^.ExclArgumenting.ValDontCareIn;
yyt^.ExclArgumenting.Expr2^.Exprs.TableIn:=yyt^.ExclArgumenting.TableIn;
yyt^.ExclArgumenting.Expr2^.Exprs.ModuleIn:=yyt^.ExclArgumenting.ModuleIn;
yyVisit1 (yyt^.ExclArgumenting.Expr2);
yyt^.ExclArgumenting.Expr1^.Exprs.EnvIn:=yyt^.ExclArgumenting.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.ExclArgumenting.Expr1^.Exprs.TempOfsIn               := yyt^.ExclArgumenting.TempOfsIn;
yyt^.ExclArgumenting.Expr1^.Exprs.LevelIn:=yyt^.ExclArgumenting.LevelIn;
yyt^.ExclArgumenting.Expr1^.Exprs.ValDontCareIn:=yyt^.ExclArgumenting.ValDontCareIn;
yyt^.ExclArgumenting.Expr1^.Exprs.TableIn:=yyt^.ExclArgumenting.TableIn;
yyt^.ExclArgumenting.Expr1^.Exprs.ModuleIn:=yyt^.ExclArgumenting.ModuleIn;
yyVisit1 (yyt^.ExclArgumenting.Expr1);
(* line 4271 "oberon.aecp" *)

  yyt^.ExclArgumenting.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.ExclArgumenting.Expr1)
                                 & ~TT.IsEmptyExpr(yyt^.ExclArgumenting.Expr2);
(* line 4199 "oberon.aecp" *)


  yyt^.ExclArgumenting.Coerce1                       := OB.cmtCoercion;
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.ExclArgumenting.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.ExclArgumenting.Op2Pos)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.ExclArgumenting.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.ExclArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.ExclArgumenting.EntryIn
                                   , yyt^.ExclArgumenting.typeRepr
                                   , yyt^.ExclArgumenting.Nextor
                                   , yyt^.ExclArgumenting.Nextor);
yyt^.ExclArgumenting.Nextion^.Designations.EnvIn:=yyt^.ExclArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.ExclArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.ExclArgumenting.MainEntryIn;
yyt^.ExclArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.ExclArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.ExclArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.ExclArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.ExclArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.ExclArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.ExclArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.ExclArgumenting.typeRepr
                                   , yyt^.ExclArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.ExclArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.ExclArgumenting.Nextion^.Designations.EntryPosition:=yyt^.ExclArgumenting.EntryPosition;
yyt^.ExclArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.ExclArgumenting.PrevEntryIn;
yyt^.ExclArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.ExclArgumenting.IsCallDesignatorIn;
yyt^.ExclArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.ExclArgumenting.ValDontCareIn;
yyt^.ExclArgumenting.Nextion^.Designations.TableIn:=yyt^.ExclArgumenting.TableIn;
yyt^.ExclArgumenting.Nextion^.Designations.ModuleIn:=yyt^.ExclArgumenting.ModuleIn;
yyt^.ExclArgumenting.Nextion^.Designations.LevelIn:=yyt^.ExclArgumenting.LevelIn;
yyVisit1 (yyt^.ExclArgumenting.Nextion);
yyt^.ExclArgumenting.Nextor^.Designors.EnvIn:=yyt^.ExclArgumenting.EnvIn;
yyt^.ExclArgumenting.Nextor^.Designors.LevelIn:=yyt^.ExclArgumenting.LevelIn;
yyVisit1 (yyt^.ExclArgumenting.Nextor);
 E.SetLaccess(yyt^.ExclArgumenting.Expr1^.Exprs.MainEntryOut     );
(* line 4325 "oberon.aecp" *)
IF ~( T.IsSetType(yyt^.ExclArgumenting.Expr1^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.ExclArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4328 "oberon.aecp" *)
IF ~( yyt^.ExclArgumenting.Expr1^.Exprs.IsLValueOut
  ) THEN  ERR.MsgPos(ERR.MsgLValueExpected,yyt^.ExclArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4331 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.ExclArgumenting.Expr2^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.ExclArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4334 "oberon.aecp" *)
IF ~( V.IsLegalSetValue(yyt^.ExclArgumenting.Expr2^.Exprs.ValueReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgIntOutOfSet,yyt^.ExclArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4196 "oberon.aecp" *)

  yyt^.ExclArgumenting.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.ExclArgumenting.Expr2);
(* line 4321 "oberon.aecp" *)

  yyt^.ExclArgumenting.Coerce2                       := CO.GetCoercion                                                         
                                   ( yyt^.ExclArgumenting.Expr2^.Exprs.TypeReprOut
                                   , OB.cLongintTypeRepr);
(* line 3194 "oberon.aecp" *)

                                                          yyt^.ExclArgumenting.MainEntryOut             := yyt^.ExclArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.ExclArgumenting.TempOfsOut                    := ADR.MinSize2(yyt^.ExclArgumenting.Expr1^.Exprs.TempOfsOut,yyt^.ExclArgumenting.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.ExclArgumenting.ExprListOut                   := yyt^.ExclArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.ExclArgumenting.SignatureReprOut              := yyt^.ExclArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.ExclArgumenting.IsWritableOut                 := yyt^.ExclArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.ExclArgumenting.ValueReprOut                  := yyt^.ExclArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.ExclArgumenting.TypeReprOut                   := yyt^.ExclArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.ExclArgumenting.EntryOut                      := yyt^.ExclArgumenting.Nextion^.Designations.EntryOut;
| Tree.InclArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.InclArgumenting.Entry                         := OB.cmtObject;
yyt^.InclArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.InclArgumenting.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.InclArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.InclArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.InclArgumenting.LevelIn;
(* line 4275 "oberon.aecp" *)

  yyt^.InclArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.InclArgumenting.Op2Pos;
(* line 4274 "oberon.aecp" *)


  yyt^.InclArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.InclArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.InclArgumenting.ValDontCareIn;
yyt^.InclArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.InclArgumenting.TableIn;
yyt^.InclArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.InclArgumenting.ModuleIn;
yyVisit1 (yyt^.InclArgumenting.ExprLists);
yyt^.InclArgumenting.Expr2^.Exprs.EnvIn:=yyt^.InclArgumenting.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.InclArgumenting.Expr2^.Exprs.TempOfsIn               := yyt^.InclArgumenting.TempOfsIn;
yyt^.InclArgumenting.Expr2^.Exprs.LevelIn:=yyt^.InclArgumenting.LevelIn;
yyt^.InclArgumenting.Expr2^.Exprs.ValDontCareIn:=yyt^.InclArgumenting.ValDontCareIn;
yyt^.InclArgumenting.Expr2^.Exprs.TableIn:=yyt^.InclArgumenting.TableIn;
yyt^.InclArgumenting.Expr2^.Exprs.ModuleIn:=yyt^.InclArgumenting.ModuleIn;
yyVisit1 (yyt^.InclArgumenting.Expr2);
yyt^.InclArgumenting.Expr1^.Exprs.EnvIn:=yyt^.InclArgumenting.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.InclArgumenting.Expr1^.Exprs.TempOfsIn               := yyt^.InclArgumenting.TempOfsIn;
yyt^.InclArgumenting.Expr1^.Exprs.LevelIn:=yyt^.InclArgumenting.LevelIn;
yyt^.InclArgumenting.Expr1^.Exprs.ValDontCareIn:=yyt^.InclArgumenting.ValDontCareIn;
yyt^.InclArgumenting.Expr1^.Exprs.TableIn:=yyt^.InclArgumenting.TableIn;
yyt^.InclArgumenting.Expr1^.Exprs.ModuleIn:=yyt^.InclArgumenting.ModuleIn;
yyVisit1 (yyt^.InclArgumenting.Expr1);
(* line 4271 "oberon.aecp" *)

  yyt^.InclArgumenting.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.InclArgumenting.Expr1)
                                 & ~TT.IsEmptyExpr(yyt^.InclArgumenting.Expr2);
(* line 4199 "oberon.aecp" *)


  yyt^.InclArgumenting.Coerce1                       := OB.cmtCoercion;
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.InclArgumenting.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.InclArgumenting.Op2Pos)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.InclArgumenting.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.InclArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.InclArgumenting.EntryIn
                                   , yyt^.InclArgumenting.typeRepr
                                   , yyt^.InclArgumenting.Nextor
                                   , yyt^.InclArgumenting.Nextor);
yyt^.InclArgumenting.Nextion^.Designations.EnvIn:=yyt^.InclArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.InclArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.InclArgumenting.MainEntryIn;
yyt^.InclArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.InclArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.InclArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.InclArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.InclArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.InclArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.InclArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.InclArgumenting.typeRepr
                                   , yyt^.InclArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.InclArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.InclArgumenting.Nextion^.Designations.EntryPosition:=yyt^.InclArgumenting.EntryPosition;
yyt^.InclArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.InclArgumenting.PrevEntryIn;
yyt^.InclArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.InclArgumenting.IsCallDesignatorIn;
yyt^.InclArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.InclArgumenting.ValDontCareIn;
yyt^.InclArgumenting.Nextion^.Designations.TableIn:=yyt^.InclArgumenting.TableIn;
yyt^.InclArgumenting.Nextion^.Designations.ModuleIn:=yyt^.InclArgumenting.ModuleIn;
yyt^.InclArgumenting.Nextion^.Designations.LevelIn:=yyt^.InclArgumenting.LevelIn;
yyVisit1 (yyt^.InclArgumenting.Nextion);
yyt^.InclArgumenting.Nextor^.Designors.EnvIn:=yyt^.InclArgumenting.EnvIn;
yyt^.InclArgumenting.Nextor^.Designors.LevelIn:=yyt^.InclArgumenting.LevelIn;
yyVisit1 (yyt^.InclArgumenting.Nextor);
 E.SetLaccess(yyt^.InclArgumenting.Expr1^.Exprs.MainEntryOut     );
(* line 4325 "oberon.aecp" *)
IF ~( T.IsSetType(yyt^.InclArgumenting.Expr1^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.InclArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4328 "oberon.aecp" *)
IF ~( yyt^.InclArgumenting.Expr1^.Exprs.IsLValueOut
  ) THEN  ERR.MsgPos(ERR.MsgLValueExpected,yyt^.InclArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4331 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.InclArgumenting.Expr2^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.InclArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4334 "oberon.aecp" *)
IF ~( V.IsLegalSetValue(yyt^.InclArgumenting.Expr2^.Exprs.ValueReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgIntOutOfSet,yyt^.InclArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4196 "oberon.aecp" *)

  yyt^.InclArgumenting.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.InclArgumenting.Expr2);
(* line 4321 "oberon.aecp" *)

  yyt^.InclArgumenting.Coerce2                       := CO.GetCoercion                                                         
                                   ( yyt^.InclArgumenting.Expr2^.Exprs.TypeReprOut
                                   , OB.cLongintTypeRepr);
(* line 3194 "oberon.aecp" *)

                                                          yyt^.InclArgumenting.MainEntryOut             := yyt^.InclArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.InclArgumenting.TempOfsOut                    := ADR.MinSize2(yyt^.InclArgumenting.Expr1^.Exprs.TempOfsOut,yyt^.InclArgumenting.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.InclArgumenting.ExprListOut                   := yyt^.InclArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.InclArgumenting.SignatureReprOut              := yyt^.InclArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.InclArgumenting.IsWritableOut                 := yyt^.InclArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.InclArgumenting.ValueReprOut                  := yyt^.InclArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.InclArgumenting.TypeReprOut                   := yyt^.InclArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.InclArgumenting.EntryOut                      := yyt^.InclArgumenting.Nextion^.Designations.EntryOut;
| Tree.SysBitArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.SysBitArgumenting.Entry                         := OB.cmtObject;
yyt^.SysBitArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.SysBitArgumenting.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.SysBitArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.SysBitArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.SysBitArgumenting.LevelIn;
(* line 4275 "oberon.aecp" *)

  yyt^.SysBitArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.SysBitArgumenting.Op2Pos;
(* line 4274 "oberon.aecp" *)


  yyt^.SysBitArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.SysBitArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.SysBitArgumenting.ValDontCareIn;
yyt^.SysBitArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.SysBitArgumenting.TableIn;
yyt^.SysBitArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.SysBitArgumenting.ModuleIn;
yyVisit1 (yyt^.SysBitArgumenting.ExprLists);
yyt^.SysBitArgumenting.Expr2^.Exprs.EnvIn:=yyt^.SysBitArgumenting.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.SysBitArgumenting.Expr2^.Exprs.TempOfsIn               := yyt^.SysBitArgumenting.TempOfsIn;
yyt^.SysBitArgumenting.Expr2^.Exprs.LevelIn:=yyt^.SysBitArgumenting.LevelIn;
yyt^.SysBitArgumenting.Expr2^.Exprs.ValDontCareIn:=yyt^.SysBitArgumenting.ValDontCareIn;
yyt^.SysBitArgumenting.Expr2^.Exprs.TableIn:=yyt^.SysBitArgumenting.TableIn;
yyt^.SysBitArgumenting.Expr2^.Exprs.ModuleIn:=yyt^.SysBitArgumenting.ModuleIn;
yyVisit1 (yyt^.SysBitArgumenting.Expr2);
yyt^.SysBitArgumenting.Expr1^.Exprs.EnvIn:=yyt^.SysBitArgumenting.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.SysBitArgumenting.Expr1^.Exprs.TempOfsIn               := yyt^.SysBitArgumenting.TempOfsIn;
yyt^.SysBitArgumenting.Expr1^.Exprs.LevelIn:=yyt^.SysBitArgumenting.LevelIn;
yyt^.SysBitArgumenting.Expr1^.Exprs.ValDontCareIn:=yyt^.SysBitArgumenting.ValDontCareIn;
yyt^.SysBitArgumenting.Expr1^.Exprs.TableIn:=yyt^.SysBitArgumenting.TableIn;
yyt^.SysBitArgumenting.Expr1^.Exprs.ModuleIn:=yyt^.SysBitArgumenting.ModuleIn;
yyVisit1 (yyt^.SysBitArgumenting.Expr1);
(* line 4271 "oberon.aecp" *)

  yyt^.SysBitArgumenting.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.SysBitArgumenting.Expr1)
                                 & ~TT.IsEmptyExpr(yyt^.SysBitArgumenting.Expr2);
(* line 4199 "oberon.aecp" *)


  yyt^.SysBitArgumenting.Coerce1                       := OB.cmtCoercion;
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.SysBitArgumenting.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.SysBitArgumenting.Op2Pos)
 END;
(* line 4341 "oberon.aecp" *)

  yyt^.SysBitArgumenting.typeRepr                      := OB.cBooleanTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.SysBitArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.SysBitArgumenting.EntryIn
                                   , yyt^.SysBitArgumenting.typeRepr
                                   , yyt^.SysBitArgumenting.Nextor
                                   , yyt^.SysBitArgumenting.Nextor);
yyt^.SysBitArgumenting.Nextion^.Designations.EnvIn:=yyt^.SysBitArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.SysBitArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.SysBitArgumenting.MainEntryIn;
yyt^.SysBitArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.SysBitArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.SysBitArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.SysBitArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.SysBitArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.SysBitArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.SysBitArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.SysBitArgumenting.typeRepr
                                   , yyt^.SysBitArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.SysBitArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.SysBitArgumenting.Nextion^.Designations.EntryPosition:=yyt^.SysBitArgumenting.EntryPosition;
yyt^.SysBitArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.SysBitArgumenting.PrevEntryIn;
yyt^.SysBitArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.SysBitArgumenting.IsCallDesignatorIn;
yyt^.SysBitArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.SysBitArgumenting.ValDontCareIn;
yyt^.SysBitArgumenting.Nextion^.Designations.TableIn:=yyt^.SysBitArgumenting.TableIn;
yyt^.SysBitArgumenting.Nextion^.Designations.ModuleIn:=yyt^.SysBitArgumenting.ModuleIn;
yyt^.SysBitArgumenting.Nextion^.Designations.LevelIn:=yyt^.SysBitArgumenting.LevelIn;
yyVisit1 (yyt^.SysBitArgumenting.Nextion);
yyt^.SysBitArgumenting.Nextor^.Designors.EnvIn:=yyt^.SysBitArgumenting.EnvIn;
yyt^.SysBitArgumenting.Nextor^.Designors.LevelIn:=yyt^.SysBitArgumenting.LevelIn;
yyVisit1 (yyt^.SysBitArgumenting.Nextor);
(* line 4347 "oberon.aecp" *)
IF ~( T.IsLongintType(yyt^.SysBitArgumenting.Expr1^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysBitArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4350 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.SysBitArgumenting.Expr2^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysBitArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4196 "oberon.aecp" *)

  yyt^.SysBitArgumenting.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.SysBitArgumenting.Expr2);
(* line 4343 "oberon.aecp" *)
                                                        

  yyt^.SysBitArgumenting.Coerce2                       := CO.GetCoercion
                                   ( yyt^.SysBitArgumenting.Expr2^.Exprs.TypeReprOut
                                   , OB.cLongintTypeRepr);
(* line 3194 "oberon.aecp" *)

                                                          yyt^.SysBitArgumenting.MainEntryOut             := yyt^.SysBitArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.SysBitArgumenting.TempOfsOut                    := ADR.MinSize2(yyt^.SysBitArgumenting.Expr1^.Exprs.TempOfsOut,yyt^.SysBitArgumenting.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.SysBitArgumenting.ExprListOut                   := yyt^.SysBitArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.SysBitArgumenting.SignatureReprOut              := yyt^.SysBitArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.SysBitArgumenting.IsWritableOut                 := yyt^.SysBitArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.SysBitArgumenting.ValueReprOut                  := yyt^.SysBitArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.SysBitArgumenting.TypeReprOut                   := yyt^.SysBitArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.SysBitArgumenting.EntryOut                      := yyt^.SysBitArgumenting.Nextion^.Designations.EntryOut;
| Tree.SysLshRotArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.SysLshRotArgumenting.Entry                         := OB.cmtObject;
yyt^.SysLshRotArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.SysLshRotArgumenting.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.SysLshRotArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.SysLshRotArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.SysLshRotArgumenting.LevelIn;
(* line 4275 "oberon.aecp" *)

  yyt^.SysLshRotArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.SysLshRotArgumenting.Op2Pos;
(* line 4274 "oberon.aecp" *)


  yyt^.SysLshRotArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.SysLshRotArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.SysLshRotArgumenting.ValDontCareIn;
yyt^.SysLshRotArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.SysLshRotArgumenting.TableIn;
yyt^.SysLshRotArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.SysLshRotArgumenting.ModuleIn;
yyVisit1 (yyt^.SysLshRotArgumenting.ExprLists);
yyt^.SysLshRotArgumenting.Expr2^.Exprs.EnvIn:=yyt^.SysLshRotArgumenting.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.SysLshRotArgumenting.Expr2^.Exprs.TempOfsIn               := yyt^.SysLshRotArgumenting.TempOfsIn;
yyt^.SysLshRotArgumenting.Expr2^.Exprs.LevelIn:=yyt^.SysLshRotArgumenting.LevelIn;
yyt^.SysLshRotArgumenting.Expr2^.Exprs.ValDontCareIn:=yyt^.SysLshRotArgumenting.ValDontCareIn;
yyt^.SysLshRotArgumenting.Expr2^.Exprs.TableIn:=yyt^.SysLshRotArgumenting.TableIn;
yyt^.SysLshRotArgumenting.Expr2^.Exprs.ModuleIn:=yyt^.SysLshRotArgumenting.ModuleIn;
yyVisit1 (yyt^.SysLshRotArgumenting.Expr2);
yyt^.SysLshRotArgumenting.Expr1^.Exprs.EnvIn:=yyt^.SysLshRotArgumenting.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.SysLshRotArgumenting.Expr1^.Exprs.TempOfsIn               := yyt^.SysLshRotArgumenting.TempOfsIn;
yyt^.SysLshRotArgumenting.Expr1^.Exprs.LevelIn:=yyt^.SysLshRotArgumenting.LevelIn;
yyt^.SysLshRotArgumenting.Expr1^.Exprs.ValDontCareIn:=yyt^.SysLshRotArgumenting.ValDontCareIn;
yyt^.SysLshRotArgumenting.Expr1^.Exprs.TableIn:=yyt^.SysLshRotArgumenting.TableIn;
yyt^.SysLshRotArgumenting.Expr1^.Exprs.ModuleIn:=yyt^.SysLshRotArgumenting.ModuleIn;
yyVisit1 (yyt^.SysLshRotArgumenting.Expr1);
(* line 4271 "oberon.aecp" *)

  yyt^.SysLshRotArgumenting.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.SysLshRotArgumenting.Expr1)
                                 & ~TT.IsEmptyExpr(yyt^.SysLshRotArgumenting.Expr2);
(* line 4199 "oberon.aecp" *)


  yyt^.SysLshRotArgumenting.Coerce1                       := OB.cmtCoercion;
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.SysLshRotArgumenting.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.SysLshRotArgumenting.Op2Pos)
 END;
(* line 4357 "oberon.aecp" *)

  yyt^.SysLshRotArgumenting.typeRepr                      := T.LegalShiftableTypesOnly(yyt^.SysLshRotArgumenting.Expr1^.Exprs.TypeReprOut);
(* line 4038 "oberon.aecp" *)


  yyt^.SysLshRotArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.SysLshRotArgumenting.EntryIn
                                   , yyt^.SysLshRotArgumenting.typeRepr
                                   , yyt^.SysLshRotArgumenting.Nextor
                                   , yyt^.SysLshRotArgumenting.Nextor);
yyt^.SysLshRotArgumenting.Nextion^.Designations.EnvIn:=yyt^.SysLshRotArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.SysLshRotArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.SysLshRotArgumenting.MainEntryIn;
yyt^.SysLshRotArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.SysLshRotArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.SysLshRotArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.SysLshRotArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.SysLshRotArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.SysLshRotArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.SysLshRotArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.SysLshRotArgumenting.typeRepr
                                   , yyt^.SysLshRotArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.SysLshRotArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.SysLshRotArgumenting.Nextion^.Designations.EntryPosition:=yyt^.SysLshRotArgumenting.EntryPosition;
yyt^.SysLshRotArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.SysLshRotArgumenting.PrevEntryIn;
yyt^.SysLshRotArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.SysLshRotArgumenting.IsCallDesignatorIn;
yyt^.SysLshRotArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.SysLshRotArgumenting.ValDontCareIn;
yyt^.SysLshRotArgumenting.Nextion^.Designations.TableIn:=yyt^.SysLshRotArgumenting.TableIn;
yyt^.SysLshRotArgumenting.Nextion^.Designations.ModuleIn:=yyt^.SysLshRotArgumenting.ModuleIn;
yyt^.SysLshRotArgumenting.Nextion^.Designations.LevelIn:=yyt^.SysLshRotArgumenting.LevelIn;
yyVisit1 (yyt^.SysLshRotArgumenting.Nextion);
yyt^.SysLshRotArgumenting.Nextor^.Designors.EnvIn:=yyt^.SysLshRotArgumenting.EnvIn;
yyt^.SysLshRotArgumenting.Nextor^.Designors.LevelIn:=yyt^.SysLshRotArgumenting.LevelIn;
yyVisit1 (yyt^.SysLshRotArgumenting.Nextor);
(* line 4359 "oberon.aecp" *)
IF ~( T.IsShiftableType(yyt^.SysLshRotArgumenting.Expr1^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysLshRotArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4362 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.SysLshRotArgumenting.Expr2^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysLshRotArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4196 "oberon.aecp" *)

  yyt^.SysLshRotArgumenting.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.SysLshRotArgumenting.Expr2);
(* line 4200 "oberon.aecp" *)

  yyt^.SysLshRotArgumenting.Coerce2                       := OB.cmtCoercion;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.SysLshRotArgumenting.MainEntryOut             := yyt^.SysLshRotArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.SysLshRotArgumenting.TempOfsOut                    := ADR.MinSize2(yyt^.SysLshRotArgumenting.Expr1^.Exprs.TempOfsOut,yyt^.SysLshRotArgumenting.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.SysLshRotArgumenting.ExprListOut                   := yyt^.SysLshRotArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.SysLshRotArgumenting.SignatureReprOut              := yyt^.SysLshRotArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.SysLshRotArgumenting.IsWritableOut                 := yyt^.SysLshRotArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.SysLshRotArgumenting.ValueReprOut                  := yyt^.SysLshRotArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.SysLshRotArgumenting.TypeReprOut                   := yyt^.SysLshRotArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.SysLshRotArgumenting.EntryOut                      := yyt^.SysLshRotArgumenting.Nextion^.Designations.EntryOut;
| Tree.SysLshArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.SysLshArgumenting.Entry                         := OB.cmtObject;
yyt^.SysLshArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.SysLshArgumenting.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.SysLshArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.SysLshArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.SysLshArgumenting.LevelIn;
(* line 4275 "oberon.aecp" *)

  yyt^.SysLshArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.SysLshArgumenting.Op2Pos;
(* line 4274 "oberon.aecp" *)


  yyt^.SysLshArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.SysLshArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.SysLshArgumenting.ValDontCareIn;
yyt^.SysLshArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.SysLshArgumenting.TableIn;
yyt^.SysLshArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.SysLshArgumenting.ModuleIn;
yyVisit1 (yyt^.SysLshArgumenting.ExprLists);
yyt^.SysLshArgumenting.Expr2^.Exprs.EnvIn:=yyt^.SysLshArgumenting.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.SysLshArgumenting.Expr2^.Exprs.TempOfsIn               := yyt^.SysLshArgumenting.TempOfsIn;
yyt^.SysLshArgumenting.Expr2^.Exprs.LevelIn:=yyt^.SysLshArgumenting.LevelIn;
yyt^.SysLshArgumenting.Expr2^.Exprs.ValDontCareIn:=yyt^.SysLshArgumenting.ValDontCareIn;
yyt^.SysLshArgumenting.Expr2^.Exprs.TableIn:=yyt^.SysLshArgumenting.TableIn;
yyt^.SysLshArgumenting.Expr2^.Exprs.ModuleIn:=yyt^.SysLshArgumenting.ModuleIn;
yyVisit1 (yyt^.SysLshArgumenting.Expr2);
yyt^.SysLshArgumenting.Expr1^.Exprs.EnvIn:=yyt^.SysLshArgumenting.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.SysLshArgumenting.Expr1^.Exprs.TempOfsIn               := yyt^.SysLshArgumenting.TempOfsIn;
yyt^.SysLshArgumenting.Expr1^.Exprs.LevelIn:=yyt^.SysLshArgumenting.LevelIn;
yyt^.SysLshArgumenting.Expr1^.Exprs.ValDontCareIn:=yyt^.SysLshArgumenting.ValDontCareIn;
yyt^.SysLshArgumenting.Expr1^.Exprs.TableIn:=yyt^.SysLshArgumenting.TableIn;
yyt^.SysLshArgumenting.Expr1^.Exprs.ModuleIn:=yyt^.SysLshArgumenting.ModuleIn;
yyVisit1 (yyt^.SysLshArgumenting.Expr1);
(* line 4271 "oberon.aecp" *)

  yyt^.SysLshArgumenting.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.SysLshArgumenting.Expr1)
                                 & ~TT.IsEmptyExpr(yyt^.SysLshArgumenting.Expr2);
(* line 4199 "oberon.aecp" *)


  yyt^.SysLshArgumenting.Coerce1                       := OB.cmtCoercion;
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.SysLshArgumenting.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.SysLshArgumenting.Op2Pos)
 END;
(* line 4357 "oberon.aecp" *)

  yyt^.SysLshArgumenting.typeRepr                      := T.LegalShiftableTypesOnly(yyt^.SysLshArgumenting.Expr1^.Exprs.TypeReprOut);
(* line 4038 "oberon.aecp" *)


  yyt^.SysLshArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.SysLshArgumenting.EntryIn
                                   , yyt^.SysLshArgumenting.typeRepr
                                   , yyt^.SysLshArgumenting.Nextor
                                   , yyt^.SysLshArgumenting.Nextor);
yyt^.SysLshArgumenting.Nextion^.Designations.EnvIn:=yyt^.SysLshArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.SysLshArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.SysLshArgumenting.MainEntryIn;
yyt^.SysLshArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.SysLshArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.SysLshArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.SysLshArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.SysLshArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.SysLshArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.SysLshArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.SysLshArgumenting.typeRepr
                                   , yyt^.SysLshArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.SysLshArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.SysLshArgumenting.Nextion^.Designations.EntryPosition:=yyt^.SysLshArgumenting.EntryPosition;
yyt^.SysLshArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.SysLshArgumenting.PrevEntryIn;
yyt^.SysLshArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.SysLshArgumenting.IsCallDesignatorIn;
yyt^.SysLshArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.SysLshArgumenting.ValDontCareIn;
yyt^.SysLshArgumenting.Nextion^.Designations.TableIn:=yyt^.SysLshArgumenting.TableIn;
yyt^.SysLshArgumenting.Nextion^.Designations.ModuleIn:=yyt^.SysLshArgumenting.ModuleIn;
yyt^.SysLshArgumenting.Nextion^.Designations.LevelIn:=yyt^.SysLshArgumenting.LevelIn;
yyVisit1 (yyt^.SysLshArgumenting.Nextion);
yyt^.SysLshArgumenting.Nextor^.Designors.EnvIn:=yyt^.SysLshArgumenting.EnvIn;
yyt^.SysLshArgumenting.Nextor^.Designors.LevelIn:=yyt^.SysLshArgumenting.LevelIn;
yyVisit1 (yyt^.SysLshArgumenting.Nextor);
(* line 4359 "oberon.aecp" *)
IF ~( T.IsShiftableType(yyt^.SysLshArgumenting.Expr1^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysLshArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4362 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.SysLshArgumenting.Expr2^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysLshArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4196 "oberon.aecp" *)

  yyt^.SysLshArgumenting.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.SysLshArgumenting.Expr2);
(* line 4200 "oberon.aecp" *)

  yyt^.SysLshArgumenting.Coerce2                       := OB.cmtCoercion;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.SysLshArgumenting.MainEntryOut             := yyt^.SysLshArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.SysLshArgumenting.TempOfsOut                    := ADR.MinSize2(yyt^.SysLshArgumenting.Expr1^.Exprs.TempOfsOut,yyt^.SysLshArgumenting.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.SysLshArgumenting.ExprListOut                   := yyt^.SysLshArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.SysLshArgumenting.SignatureReprOut              := yyt^.SysLshArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.SysLshArgumenting.IsWritableOut                 := yyt^.SysLshArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.SysLshArgumenting.ValueReprOut                  := yyt^.SysLshArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.SysLshArgumenting.TypeReprOut                   := yyt^.SysLshArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.SysLshArgumenting.EntryOut                      := yyt^.SysLshArgumenting.Nextion^.Designations.EntryOut;
| Tree.SysRotArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.SysRotArgumenting.Entry                         := OB.cmtObject;
yyt^.SysRotArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.SysRotArgumenting.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.SysRotArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.SysRotArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.SysRotArgumenting.LevelIn;
(* line 4275 "oberon.aecp" *)

  yyt^.SysRotArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.SysRotArgumenting.Op2Pos;
(* line 4274 "oberon.aecp" *)


  yyt^.SysRotArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.SysRotArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.SysRotArgumenting.ValDontCareIn;
yyt^.SysRotArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.SysRotArgumenting.TableIn;
yyt^.SysRotArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.SysRotArgumenting.ModuleIn;
yyVisit1 (yyt^.SysRotArgumenting.ExprLists);
yyt^.SysRotArgumenting.Expr2^.Exprs.EnvIn:=yyt^.SysRotArgumenting.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.SysRotArgumenting.Expr2^.Exprs.TempOfsIn               := yyt^.SysRotArgumenting.TempOfsIn;
yyt^.SysRotArgumenting.Expr2^.Exprs.LevelIn:=yyt^.SysRotArgumenting.LevelIn;
yyt^.SysRotArgumenting.Expr2^.Exprs.ValDontCareIn:=yyt^.SysRotArgumenting.ValDontCareIn;
yyt^.SysRotArgumenting.Expr2^.Exprs.TableIn:=yyt^.SysRotArgumenting.TableIn;
yyt^.SysRotArgumenting.Expr2^.Exprs.ModuleIn:=yyt^.SysRotArgumenting.ModuleIn;
yyVisit1 (yyt^.SysRotArgumenting.Expr2);
yyt^.SysRotArgumenting.Expr1^.Exprs.EnvIn:=yyt^.SysRotArgumenting.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.SysRotArgumenting.Expr1^.Exprs.TempOfsIn               := yyt^.SysRotArgumenting.TempOfsIn;
yyt^.SysRotArgumenting.Expr1^.Exprs.LevelIn:=yyt^.SysRotArgumenting.LevelIn;
yyt^.SysRotArgumenting.Expr1^.Exprs.ValDontCareIn:=yyt^.SysRotArgumenting.ValDontCareIn;
yyt^.SysRotArgumenting.Expr1^.Exprs.TableIn:=yyt^.SysRotArgumenting.TableIn;
yyt^.SysRotArgumenting.Expr1^.Exprs.ModuleIn:=yyt^.SysRotArgumenting.ModuleIn;
yyVisit1 (yyt^.SysRotArgumenting.Expr1);
(* line 4271 "oberon.aecp" *)

  yyt^.SysRotArgumenting.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.SysRotArgumenting.Expr1)
                                 & ~TT.IsEmptyExpr(yyt^.SysRotArgumenting.Expr2);
(* line 4199 "oberon.aecp" *)


  yyt^.SysRotArgumenting.Coerce1                       := OB.cmtCoercion;
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.SysRotArgumenting.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.SysRotArgumenting.Op2Pos)
 END;
(* line 4357 "oberon.aecp" *)

  yyt^.SysRotArgumenting.typeRepr                      := T.LegalShiftableTypesOnly(yyt^.SysRotArgumenting.Expr1^.Exprs.TypeReprOut);
(* line 4038 "oberon.aecp" *)


  yyt^.SysRotArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.SysRotArgumenting.EntryIn
                                   , yyt^.SysRotArgumenting.typeRepr
                                   , yyt^.SysRotArgumenting.Nextor
                                   , yyt^.SysRotArgumenting.Nextor);
yyt^.SysRotArgumenting.Nextion^.Designations.EnvIn:=yyt^.SysRotArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.SysRotArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.SysRotArgumenting.MainEntryIn;
yyt^.SysRotArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.SysRotArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.SysRotArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.SysRotArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.SysRotArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.SysRotArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.SysRotArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.SysRotArgumenting.typeRepr
                                   , yyt^.SysRotArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.SysRotArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.SysRotArgumenting.Nextion^.Designations.EntryPosition:=yyt^.SysRotArgumenting.EntryPosition;
yyt^.SysRotArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.SysRotArgumenting.PrevEntryIn;
yyt^.SysRotArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.SysRotArgumenting.IsCallDesignatorIn;
yyt^.SysRotArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.SysRotArgumenting.ValDontCareIn;
yyt^.SysRotArgumenting.Nextion^.Designations.TableIn:=yyt^.SysRotArgumenting.TableIn;
yyt^.SysRotArgumenting.Nextion^.Designations.ModuleIn:=yyt^.SysRotArgumenting.ModuleIn;
yyt^.SysRotArgumenting.Nextion^.Designations.LevelIn:=yyt^.SysRotArgumenting.LevelIn;
yyVisit1 (yyt^.SysRotArgumenting.Nextion);
yyt^.SysRotArgumenting.Nextor^.Designors.EnvIn:=yyt^.SysRotArgumenting.EnvIn;
yyt^.SysRotArgumenting.Nextor^.Designors.LevelIn:=yyt^.SysRotArgumenting.LevelIn;
yyVisit1 (yyt^.SysRotArgumenting.Nextor);
(* line 4359 "oberon.aecp" *)
IF ~( T.IsShiftableType(yyt^.SysRotArgumenting.Expr1^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysRotArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4362 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.SysRotArgumenting.Expr2^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysRotArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4196 "oberon.aecp" *)

  yyt^.SysRotArgumenting.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.SysRotArgumenting.Expr2);
(* line 4200 "oberon.aecp" *)

  yyt^.SysRotArgumenting.Coerce2                       := OB.cmtCoercion;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.SysRotArgumenting.MainEntryOut             := yyt^.SysRotArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.SysRotArgumenting.TempOfsOut                    := ADR.MinSize2(yyt^.SysRotArgumenting.Expr1^.Exprs.TempOfsOut,yyt^.SysRotArgumenting.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.SysRotArgumenting.ExprListOut                   := yyt^.SysRotArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.SysRotArgumenting.SignatureReprOut              := yyt^.SysRotArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.SysRotArgumenting.IsWritableOut                 := yyt^.SysRotArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.SysRotArgumenting.ValueReprOut                  := yyt^.SysRotArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.SysRotArgumenting.TypeReprOut                   := yyt^.SysRotArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.SysRotArgumenting.EntryOut                      := yyt^.SysRotArgumenting.Nextion^.Designations.EntryOut;
| Tree.SysGetPutArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.SysGetPutArgumenting.Entry                         := OB.cmtObject;
yyt^.SysGetPutArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.SysGetPutArgumenting.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.SysGetPutArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.SysGetPutArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.SysGetPutArgumenting.LevelIn;
(* line 4275 "oberon.aecp" *)

  yyt^.SysGetPutArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.SysGetPutArgumenting.Op2Pos;
(* line 4274 "oberon.aecp" *)


  yyt^.SysGetPutArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.SysGetPutArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.SysGetPutArgumenting.ValDontCareIn;
yyt^.SysGetPutArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.SysGetPutArgumenting.TableIn;
yyt^.SysGetPutArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.SysGetPutArgumenting.ModuleIn;
yyVisit1 (yyt^.SysGetPutArgumenting.ExprLists);
yyt^.SysGetPutArgumenting.Expr2^.Exprs.EnvIn:=yyt^.SysGetPutArgumenting.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.SysGetPutArgumenting.Expr2^.Exprs.TempOfsIn               := yyt^.SysGetPutArgumenting.TempOfsIn;
yyt^.SysGetPutArgumenting.Expr2^.Exprs.LevelIn:=yyt^.SysGetPutArgumenting.LevelIn;
yyt^.SysGetPutArgumenting.Expr2^.Exprs.ValDontCareIn:=yyt^.SysGetPutArgumenting.ValDontCareIn;
yyt^.SysGetPutArgumenting.Expr2^.Exprs.TableIn:=yyt^.SysGetPutArgumenting.TableIn;
yyt^.SysGetPutArgumenting.Expr2^.Exprs.ModuleIn:=yyt^.SysGetPutArgumenting.ModuleIn;
yyVisit1 (yyt^.SysGetPutArgumenting.Expr2);
yyt^.SysGetPutArgumenting.Expr1^.Exprs.EnvIn:=yyt^.SysGetPutArgumenting.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.SysGetPutArgumenting.Expr1^.Exprs.TempOfsIn               := yyt^.SysGetPutArgumenting.TempOfsIn;
yyt^.SysGetPutArgumenting.Expr1^.Exprs.LevelIn:=yyt^.SysGetPutArgumenting.LevelIn;
yyt^.SysGetPutArgumenting.Expr1^.Exprs.ValDontCareIn:=yyt^.SysGetPutArgumenting.ValDontCareIn;
yyt^.SysGetPutArgumenting.Expr1^.Exprs.TableIn:=yyt^.SysGetPutArgumenting.TableIn;
yyt^.SysGetPutArgumenting.Expr1^.Exprs.ModuleIn:=yyt^.SysGetPutArgumenting.ModuleIn;
yyVisit1 (yyt^.SysGetPutArgumenting.Expr1);
(* line 4271 "oberon.aecp" *)

  yyt^.SysGetPutArgumenting.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.SysGetPutArgumenting.Expr1)
                                 & ~TT.IsEmptyExpr(yyt^.SysGetPutArgumenting.Expr2);
(* line 4199 "oberon.aecp" *)


  yyt^.SysGetPutArgumenting.Coerce1                       := OB.cmtCoercion;
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.SysGetPutArgumenting.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.SysGetPutArgumenting.Op2Pos)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.SysGetPutArgumenting.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.SysGetPutArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.SysGetPutArgumenting.EntryIn
                                   , yyt^.SysGetPutArgumenting.typeRepr
                                   , yyt^.SysGetPutArgumenting.Nextor
                                   , yyt^.SysGetPutArgumenting.Nextor);
yyt^.SysGetPutArgumenting.Nextion^.Designations.EnvIn:=yyt^.SysGetPutArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.SysGetPutArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.SysGetPutArgumenting.MainEntryIn;
yyt^.SysGetPutArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.SysGetPutArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.SysGetPutArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.SysGetPutArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.SysGetPutArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.SysGetPutArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.SysGetPutArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.SysGetPutArgumenting.typeRepr
                                   , yyt^.SysGetPutArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.SysGetPutArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.SysGetPutArgumenting.Nextion^.Designations.EntryPosition:=yyt^.SysGetPutArgumenting.EntryPosition;
yyt^.SysGetPutArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.SysGetPutArgumenting.PrevEntryIn;
yyt^.SysGetPutArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.SysGetPutArgumenting.IsCallDesignatorIn;
yyt^.SysGetPutArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.SysGetPutArgumenting.ValDontCareIn;
yyt^.SysGetPutArgumenting.Nextion^.Designations.TableIn:=yyt^.SysGetPutArgumenting.TableIn;
yyt^.SysGetPutArgumenting.Nextion^.Designations.ModuleIn:=yyt^.SysGetPutArgumenting.ModuleIn;
yyt^.SysGetPutArgumenting.Nextion^.Designations.LevelIn:=yyt^.SysGetPutArgumenting.LevelIn;
yyVisit1 (yyt^.SysGetPutArgumenting.Nextion);
yyt^.SysGetPutArgumenting.Nextor^.Designors.EnvIn:=yyt^.SysGetPutArgumenting.EnvIn;
yyt^.SysGetPutArgumenting.Nextor^.Designors.LevelIn:=yyt^.SysGetPutArgumenting.LevelIn;
yyVisit1 (yyt^.SysGetPutArgumenting.Nextor);
(* line 4369 "oberon.aecp" *)
IF ~( T.IsLongintType(yyt^.SysGetPutArgumenting.Expr1^.Exprs.TypeReprOut)                                                                  
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysGetPutArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4372 "oberon.aecp" *)
IF ~( T.IsRegisterableType(yyt^.SysGetPutArgumenting.Expr2^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysGetPutArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4196 "oberon.aecp" *)

  yyt^.SysGetPutArgumenting.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.SysGetPutArgumenting.Expr2);
(* line 4200 "oberon.aecp" *)

  yyt^.SysGetPutArgumenting.Coerce2                       := OB.cmtCoercion;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.SysGetPutArgumenting.MainEntryOut             := yyt^.SysGetPutArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.SysGetPutArgumenting.TempOfsOut                    := ADR.MinSize2(yyt^.SysGetPutArgumenting.Expr1^.Exprs.TempOfsOut,yyt^.SysGetPutArgumenting.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.SysGetPutArgumenting.ExprListOut                   := yyt^.SysGetPutArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.SysGetPutArgumenting.SignatureReprOut              := yyt^.SysGetPutArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.SysGetPutArgumenting.IsWritableOut                 := yyt^.SysGetPutArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.SysGetPutArgumenting.ValueReprOut                  := yyt^.SysGetPutArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.SysGetPutArgumenting.TypeReprOut                   := yyt^.SysGetPutArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.SysGetPutArgumenting.EntryOut                      := yyt^.SysGetPutArgumenting.Nextion^.Designations.EntryOut;
| Tree.SysGetArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.SysGetArgumenting.Entry                         := OB.cmtObject;
yyt^.SysGetArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.SysGetArgumenting.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.SysGetArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.SysGetArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.SysGetArgumenting.LevelIn;
(* line 4275 "oberon.aecp" *)

  yyt^.SysGetArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.SysGetArgumenting.Op2Pos;
(* line 4274 "oberon.aecp" *)


  yyt^.SysGetArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.SysGetArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.SysGetArgumenting.ValDontCareIn;
yyt^.SysGetArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.SysGetArgumenting.TableIn;
yyt^.SysGetArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.SysGetArgumenting.ModuleIn;
yyVisit1 (yyt^.SysGetArgumenting.ExprLists);
yyt^.SysGetArgumenting.Expr2^.Exprs.EnvIn:=yyt^.SysGetArgumenting.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.SysGetArgumenting.Expr2^.Exprs.TempOfsIn               := yyt^.SysGetArgumenting.TempOfsIn;
yyt^.SysGetArgumenting.Expr2^.Exprs.LevelIn:=yyt^.SysGetArgumenting.LevelIn;
yyt^.SysGetArgumenting.Expr2^.Exprs.ValDontCareIn:=yyt^.SysGetArgumenting.ValDontCareIn;
yyt^.SysGetArgumenting.Expr2^.Exprs.TableIn:=yyt^.SysGetArgumenting.TableIn;
yyt^.SysGetArgumenting.Expr2^.Exprs.ModuleIn:=yyt^.SysGetArgumenting.ModuleIn;
yyVisit1 (yyt^.SysGetArgumenting.Expr2);
yyt^.SysGetArgumenting.Expr1^.Exprs.EnvIn:=yyt^.SysGetArgumenting.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.SysGetArgumenting.Expr1^.Exprs.TempOfsIn               := yyt^.SysGetArgumenting.TempOfsIn;
yyt^.SysGetArgumenting.Expr1^.Exprs.LevelIn:=yyt^.SysGetArgumenting.LevelIn;
yyt^.SysGetArgumenting.Expr1^.Exprs.ValDontCareIn:=yyt^.SysGetArgumenting.ValDontCareIn;
yyt^.SysGetArgumenting.Expr1^.Exprs.TableIn:=yyt^.SysGetArgumenting.TableIn;
yyt^.SysGetArgumenting.Expr1^.Exprs.ModuleIn:=yyt^.SysGetArgumenting.ModuleIn;
yyVisit1 (yyt^.SysGetArgumenting.Expr1);
(* line 4271 "oberon.aecp" *)

  yyt^.SysGetArgumenting.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.SysGetArgumenting.Expr1)
                                 & ~TT.IsEmptyExpr(yyt^.SysGetArgumenting.Expr2);
(* line 4199 "oberon.aecp" *)


  yyt^.SysGetArgumenting.Coerce1                       := OB.cmtCoercion;
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.SysGetArgumenting.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.SysGetArgumenting.Op2Pos)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.SysGetArgumenting.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.SysGetArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.SysGetArgumenting.EntryIn
                                   , yyt^.SysGetArgumenting.typeRepr
                                   , yyt^.SysGetArgumenting.Nextor
                                   , yyt^.SysGetArgumenting.Nextor);
yyt^.SysGetArgumenting.Nextion^.Designations.EnvIn:=yyt^.SysGetArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.SysGetArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.SysGetArgumenting.MainEntryIn;
yyt^.SysGetArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.SysGetArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.SysGetArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.SysGetArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.SysGetArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.SysGetArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.SysGetArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.SysGetArgumenting.typeRepr
                                   , yyt^.SysGetArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.SysGetArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.SysGetArgumenting.Nextion^.Designations.EntryPosition:=yyt^.SysGetArgumenting.EntryPosition;
yyt^.SysGetArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.SysGetArgumenting.PrevEntryIn;
yyt^.SysGetArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.SysGetArgumenting.IsCallDesignatorIn;
yyt^.SysGetArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.SysGetArgumenting.ValDontCareIn;
yyt^.SysGetArgumenting.Nextion^.Designations.TableIn:=yyt^.SysGetArgumenting.TableIn;
yyt^.SysGetArgumenting.Nextion^.Designations.ModuleIn:=yyt^.SysGetArgumenting.ModuleIn;
yyt^.SysGetArgumenting.Nextion^.Designations.LevelIn:=yyt^.SysGetArgumenting.LevelIn;
yyVisit1 (yyt^.SysGetArgumenting.Nextion);
yyt^.SysGetArgumenting.Nextor^.Designors.EnvIn:=yyt^.SysGetArgumenting.EnvIn;
yyt^.SysGetArgumenting.Nextor^.Designors.LevelIn:=yyt^.SysGetArgumenting.LevelIn;
yyVisit1 (yyt^.SysGetArgumenting.Nextor);
 E.SetLaccess(yyt^.SysGetArgumenting.Expr2^.Exprs.MainEntryOut     );
(* line 4378 "oberon.aecp" *)
IF ~( yyt^.SysGetArgumenting.Expr2^.Exprs.IsLValueOut
  ) THEN  ERR.MsgPos(ERR.MsgLValueExpected,yyt^.SysGetArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4369 "oberon.aecp" *)
IF ~( T.IsLongintType(yyt^.SysGetArgumenting.Expr1^.Exprs.TypeReprOut)                                                                  
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysGetArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4372 "oberon.aecp" *)
IF ~( T.IsRegisterableType(yyt^.SysGetArgumenting.Expr2^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysGetArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4196 "oberon.aecp" *)

  yyt^.SysGetArgumenting.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.SysGetArgumenting.Expr2);
(* line 4200 "oberon.aecp" *)

  yyt^.SysGetArgumenting.Coerce2                       := OB.cmtCoercion;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.SysGetArgumenting.MainEntryOut             := yyt^.SysGetArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.SysGetArgumenting.TempOfsOut                    := ADR.MinSize2(yyt^.SysGetArgumenting.Expr1^.Exprs.TempOfsOut,yyt^.SysGetArgumenting.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.SysGetArgumenting.ExprListOut                   := yyt^.SysGetArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.SysGetArgumenting.SignatureReprOut              := yyt^.SysGetArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.SysGetArgumenting.IsWritableOut                 := yyt^.SysGetArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.SysGetArgumenting.ValueReprOut                  := yyt^.SysGetArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.SysGetArgumenting.TypeReprOut                   := yyt^.SysGetArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.SysGetArgumenting.EntryOut                      := yyt^.SysGetArgumenting.Nextion^.Designations.EntryOut;
| Tree.SysPutArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.SysPutArgumenting.Entry                         := OB.cmtObject;
yyt^.SysPutArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.SysPutArgumenting.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.SysPutArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.SysPutArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.SysPutArgumenting.LevelIn;
(* line 4275 "oberon.aecp" *)

  yyt^.SysPutArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.SysPutArgumenting.Op2Pos;
(* line 4274 "oberon.aecp" *)


  yyt^.SysPutArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.SysPutArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.SysPutArgumenting.ValDontCareIn;
yyt^.SysPutArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.SysPutArgumenting.TableIn;
yyt^.SysPutArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.SysPutArgumenting.ModuleIn;
yyVisit1 (yyt^.SysPutArgumenting.ExprLists);
yyt^.SysPutArgumenting.Expr2^.Exprs.EnvIn:=yyt^.SysPutArgumenting.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.SysPutArgumenting.Expr2^.Exprs.TempOfsIn               := yyt^.SysPutArgumenting.TempOfsIn;
yyt^.SysPutArgumenting.Expr2^.Exprs.LevelIn:=yyt^.SysPutArgumenting.LevelIn;
yyt^.SysPutArgumenting.Expr2^.Exprs.ValDontCareIn:=yyt^.SysPutArgumenting.ValDontCareIn;
yyt^.SysPutArgumenting.Expr2^.Exprs.TableIn:=yyt^.SysPutArgumenting.TableIn;
yyt^.SysPutArgumenting.Expr2^.Exprs.ModuleIn:=yyt^.SysPutArgumenting.ModuleIn;
yyVisit1 (yyt^.SysPutArgumenting.Expr2);
yyt^.SysPutArgumenting.Expr1^.Exprs.EnvIn:=yyt^.SysPutArgumenting.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.SysPutArgumenting.Expr1^.Exprs.TempOfsIn               := yyt^.SysPutArgumenting.TempOfsIn;
yyt^.SysPutArgumenting.Expr1^.Exprs.LevelIn:=yyt^.SysPutArgumenting.LevelIn;
yyt^.SysPutArgumenting.Expr1^.Exprs.ValDontCareIn:=yyt^.SysPutArgumenting.ValDontCareIn;
yyt^.SysPutArgumenting.Expr1^.Exprs.TableIn:=yyt^.SysPutArgumenting.TableIn;
yyt^.SysPutArgumenting.Expr1^.Exprs.ModuleIn:=yyt^.SysPutArgumenting.ModuleIn;
yyVisit1 (yyt^.SysPutArgumenting.Expr1);
(* line 4271 "oberon.aecp" *)

  yyt^.SysPutArgumenting.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.SysPutArgumenting.Expr1)
                                 & ~TT.IsEmptyExpr(yyt^.SysPutArgumenting.Expr2);
(* line 4199 "oberon.aecp" *)


  yyt^.SysPutArgumenting.Coerce1                       := OB.cmtCoercion;
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.SysPutArgumenting.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.SysPutArgumenting.Op2Pos)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.SysPutArgumenting.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.SysPutArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.SysPutArgumenting.EntryIn
                                   , yyt^.SysPutArgumenting.typeRepr
                                   , yyt^.SysPutArgumenting.Nextor
                                   , yyt^.SysPutArgumenting.Nextor);
yyt^.SysPutArgumenting.Nextion^.Designations.EnvIn:=yyt^.SysPutArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.SysPutArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.SysPutArgumenting.MainEntryIn;
yyt^.SysPutArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.SysPutArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.SysPutArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.SysPutArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.SysPutArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.SysPutArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.SysPutArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.SysPutArgumenting.typeRepr
                                   , yyt^.SysPutArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.SysPutArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.SysPutArgumenting.Nextion^.Designations.EntryPosition:=yyt^.SysPutArgumenting.EntryPosition;
yyt^.SysPutArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.SysPutArgumenting.PrevEntryIn;
yyt^.SysPutArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.SysPutArgumenting.IsCallDesignatorIn;
yyt^.SysPutArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.SysPutArgumenting.ValDontCareIn;
yyt^.SysPutArgumenting.Nextion^.Designations.TableIn:=yyt^.SysPutArgumenting.TableIn;
yyt^.SysPutArgumenting.Nextion^.Designations.ModuleIn:=yyt^.SysPutArgumenting.ModuleIn;
yyt^.SysPutArgumenting.Nextion^.Designations.LevelIn:=yyt^.SysPutArgumenting.LevelIn;
yyVisit1 (yyt^.SysPutArgumenting.Nextion);
yyt^.SysPutArgumenting.Nextor^.Designors.EnvIn:=yyt^.SysPutArgumenting.EnvIn;
yyt^.SysPutArgumenting.Nextor^.Designors.LevelIn:=yyt^.SysPutArgumenting.LevelIn;
yyVisit1 (yyt^.SysPutArgumenting.Nextor);
(* line 4369 "oberon.aecp" *)
IF ~( T.IsLongintType(yyt^.SysPutArgumenting.Expr1^.Exprs.TypeReprOut)                                                                  
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysPutArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4372 "oberon.aecp" *)
IF ~( T.IsRegisterableType(yyt^.SysPutArgumenting.Expr2^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysPutArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4196 "oberon.aecp" *)

  yyt^.SysPutArgumenting.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.SysPutArgumenting.Expr2);
(* line 4200 "oberon.aecp" *)

  yyt^.SysPutArgumenting.Coerce2                       := OB.cmtCoercion;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.SysPutArgumenting.MainEntryOut             := yyt^.SysPutArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.SysPutArgumenting.TempOfsOut                    := ADR.MinSize2(yyt^.SysPutArgumenting.Expr1^.Exprs.TempOfsOut,yyt^.SysPutArgumenting.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.SysPutArgumenting.ExprListOut                   := yyt^.SysPutArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.SysPutArgumenting.SignatureReprOut              := yyt^.SysPutArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.SysPutArgumenting.IsWritableOut                 := yyt^.SysPutArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.SysPutArgumenting.ValueReprOut                  := yyt^.SysPutArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.SysPutArgumenting.TypeReprOut                   := yyt^.SysPutArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.SysPutArgumenting.EntryOut                      := yyt^.SysPutArgumenting.Nextion^.Designations.EntryOut;
| Tree.SysGetregPutregArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.SysGetregPutregArgumenting.Entry                         := OB.cmtObject;
yyt^.SysGetregPutregArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.SysGetregPutregArgumenting.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.SysGetregPutregArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.SysGetregPutregArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.SysGetregPutregArgumenting.LevelIn;
(* line 4275 "oberon.aecp" *)

  yyt^.SysGetregPutregArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.SysGetregPutregArgumenting.Op2Pos;
(* line 4274 "oberon.aecp" *)


  yyt^.SysGetregPutregArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.SysGetregPutregArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.SysGetregPutregArgumenting.ValDontCareIn;
yyt^.SysGetregPutregArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.SysGetregPutregArgumenting.TableIn;
yyt^.SysGetregPutregArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.SysGetregPutregArgumenting.ModuleIn;
yyVisit1 (yyt^.SysGetregPutregArgumenting.ExprLists);
yyt^.SysGetregPutregArgumenting.Expr2^.Exprs.EnvIn:=yyt^.SysGetregPutregArgumenting.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.SysGetregPutregArgumenting.Expr2^.Exprs.TempOfsIn               := yyt^.SysGetregPutregArgumenting.TempOfsIn;
yyt^.SysGetregPutregArgumenting.Expr2^.Exprs.LevelIn:=yyt^.SysGetregPutregArgumenting.LevelIn;
yyt^.SysGetregPutregArgumenting.Expr2^.Exprs.ValDontCareIn:=yyt^.SysGetregPutregArgumenting.ValDontCareIn;
yyt^.SysGetregPutregArgumenting.Expr2^.Exprs.TableIn:=yyt^.SysGetregPutregArgumenting.TableIn;
yyt^.SysGetregPutregArgumenting.Expr2^.Exprs.ModuleIn:=yyt^.SysGetregPutregArgumenting.ModuleIn;
yyVisit1 (yyt^.SysGetregPutregArgumenting.Expr2);
yyt^.SysGetregPutregArgumenting.Expr1^.Exprs.EnvIn:=yyt^.SysGetregPutregArgumenting.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.SysGetregPutregArgumenting.Expr1^.Exprs.TempOfsIn               := yyt^.SysGetregPutregArgumenting.TempOfsIn;
yyt^.SysGetregPutregArgumenting.Expr1^.Exprs.LevelIn:=yyt^.SysGetregPutregArgumenting.LevelIn;
yyt^.SysGetregPutregArgumenting.Expr1^.Exprs.ValDontCareIn:=yyt^.SysGetregPutregArgumenting.ValDontCareIn;
yyt^.SysGetregPutregArgumenting.Expr1^.Exprs.TableIn:=yyt^.SysGetregPutregArgumenting.TableIn;
yyt^.SysGetregPutregArgumenting.Expr1^.Exprs.ModuleIn:=yyt^.SysGetregPutregArgumenting.ModuleIn;
yyVisit1 (yyt^.SysGetregPutregArgumenting.Expr1);
(* line 4271 "oberon.aecp" *)

  yyt^.SysGetregPutregArgumenting.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.SysGetregPutregArgumenting.Expr1)
                                 & ~TT.IsEmptyExpr(yyt^.SysGetregPutregArgumenting.Expr2);
(* line 4199 "oberon.aecp" *)


  yyt^.SysGetregPutregArgumenting.Coerce1                       := OB.cmtCoercion;
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.SysGetregPutregArgumenting.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.SysGetregPutregArgumenting.Op2Pos)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.SysGetregPutregArgumenting.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.SysGetregPutregArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.SysGetregPutregArgumenting.EntryIn
                                   , yyt^.SysGetregPutregArgumenting.typeRepr
                                   , yyt^.SysGetregPutregArgumenting.Nextor
                                   , yyt^.SysGetregPutregArgumenting.Nextor);
yyt^.SysGetregPutregArgumenting.Nextion^.Designations.EnvIn:=yyt^.SysGetregPutregArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.SysGetregPutregArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.SysGetregPutregArgumenting.MainEntryIn;
yyt^.SysGetregPutregArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.SysGetregPutregArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.SysGetregPutregArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.SysGetregPutregArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.SysGetregPutregArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.SysGetregPutregArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.SysGetregPutregArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.SysGetregPutregArgumenting.typeRepr
                                   , yyt^.SysGetregPutregArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.SysGetregPutregArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.SysGetregPutregArgumenting.Nextion^.Designations.EntryPosition:=yyt^.SysGetregPutregArgumenting.EntryPosition;
yyt^.SysGetregPutregArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.SysGetregPutregArgumenting.PrevEntryIn;
yyt^.SysGetregPutregArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.SysGetregPutregArgumenting.IsCallDesignatorIn;
yyt^.SysGetregPutregArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.SysGetregPutregArgumenting.ValDontCareIn;
yyt^.SysGetregPutregArgumenting.Nextion^.Designations.TableIn:=yyt^.SysGetregPutregArgumenting.TableIn;
yyt^.SysGetregPutregArgumenting.Nextion^.Designations.ModuleIn:=yyt^.SysGetregPutregArgumenting.ModuleIn;
yyt^.SysGetregPutregArgumenting.Nextion^.Designations.LevelIn:=yyt^.SysGetregPutregArgumenting.LevelIn;
yyVisit1 (yyt^.SysGetregPutregArgumenting.Nextion);
yyt^.SysGetregPutregArgumenting.Nextor^.Designors.EnvIn:=yyt^.SysGetregPutregArgumenting.EnvIn;
yyt^.SysGetregPutregArgumenting.Nextor^.Designors.LevelIn:=yyt^.SysGetregPutregArgumenting.LevelIn;
yyVisit1 (yyt^.SysGetregPutregArgumenting.Nextor);
(* line 4385 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.SysGetregPutregArgumenting.Expr1^.Exprs.TypeReprOut)                                                            
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysGetregPutregArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4388 "oberon.aecp" *)
IF ~( V.IsValidConstValue(yyt^.SysGetregPutregArgumenting.Expr1^.Exprs.ValueReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgExprNotConstant,yyt^.SysGetregPutregArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4391 "oberon.aecp" *)
IF ~( T.IsRegisterableType(yyt^.SysGetregPutregArgumenting.Expr2^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysGetregPutregArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4196 "oberon.aecp" *)

  yyt^.SysGetregPutregArgumenting.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.SysGetregPutregArgumenting.Expr2);
(* line 4200 "oberon.aecp" *)

  yyt^.SysGetregPutregArgumenting.Coerce2                       := OB.cmtCoercion;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.SysGetregPutregArgumenting.MainEntryOut             := yyt^.SysGetregPutregArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.SysGetregPutregArgumenting.TempOfsOut                    := ADR.MinSize2(yyt^.SysGetregPutregArgumenting.Expr1^.Exprs.TempOfsOut,yyt^.SysGetregPutregArgumenting.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.SysGetregPutregArgumenting.ExprListOut                   := yyt^.SysGetregPutregArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.SysGetregPutregArgumenting.SignatureReprOut              := yyt^.SysGetregPutregArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.SysGetregPutregArgumenting.IsWritableOut                 := yyt^.SysGetregPutregArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.SysGetregPutregArgumenting.ValueReprOut                  := yyt^.SysGetregPutregArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.SysGetregPutregArgumenting.TypeReprOut                   := yyt^.SysGetregPutregArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.SysGetregPutregArgumenting.EntryOut                      := yyt^.SysGetregPutregArgumenting.Nextion^.Designations.EntryOut;
| Tree.SysGetregArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.SysGetregArgumenting.Entry                         := OB.cmtObject;
yyt^.SysGetregArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.SysGetregArgumenting.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.SysGetregArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.SysGetregArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.SysGetregArgumenting.LevelIn;
(* line 4275 "oberon.aecp" *)

  yyt^.SysGetregArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.SysGetregArgumenting.Op2Pos;
(* line 4274 "oberon.aecp" *)


  yyt^.SysGetregArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.SysGetregArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.SysGetregArgumenting.ValDontCareIn;
yyt^.SysGetregArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.SysGetregArgumenting.TableIn;
yyt^.SysGetregArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.SysGetregArgumenting.ModuleIn;
yyVisit1 (yyt^.SysGetregArgumenting.ExprLists);
yyt^.SysGetregArgumenting.Expr2^.Exprs.EnvIn:=yyt^.SysGetregArgumenting.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.SysGetregArgumenting.Expr2^.Exprs.TempOfsIn               := yyt^.SysGetregArgumenting.TempOfsIn;
yyt^.SysGetregArgumenting.Expr2^.Exprs.LevelIn:=yyt^.SysGetregArgumenting.LevelIn;
yyt^.SysGetregArgumenting.Expr2^.Exprs.ValDontCareIn:=yyt^.SysGetregArgumenting.ValDontCareIn;
yyt^.SysGetregArgumenting.Expr2^.Exprs.TableIn:=yyt^.SysGetregArgumenting.TableIn;
yyt^.SysGetregArgumenting.Expr2^.Exprs.ModuleIn:=yyt^.SysGetregArgumenting.ModuleIn;
yyVisit1 (yyt^.SysGetregArgumenting.Expr2);
yyt^.SysGetregArgumenting.Expr1^.Exprs.EnvIn:=yyt^.SysGetregArgumenting.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.SysGetregArgumenting.Expr1^.Exprs.TempOfsIn               := yyt^.SysGetregArgumenting.TempOfsIn;
yyt^.SysGetregArgumenting.Expr1^.Exprs.LevelIn:=yyt^.SysGetregArgumenting.LevelIn;
yyt^.SysGetregArgumenting.Expr1^.Exprs.ValDontCareIn:=yyt^.SysGetregArgumenting.ValDontCareIn;
yyt^.SysGetregArgumenting.Expr1^.Exprs.TableIn:=yyt^.SysGetregArgumenting.TableIn;
yyt^.SysGetregArgumenting.Expr1^.Exprs.ModuleIn:=yyt^.SysGetregArgumenting.ModuleIn;
yyVisit1 (yyt^.SysGetregArgumenting.Expr1);
(* line 4271 "oberon.aecp" *)

  yyt^.SysGetregArgumenting.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.SysGetregArgumenting.Expr1)
                                 & ~TT.IsEmptyExpr(yyt^.SysGetregArgumenting.Expr2);
(* line 4199 "oberon.aecp" *)


  yyt^.SysGetregArgumenting.Coerce1                       := OB.cmtCoercion;
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.SysGetregArgumenting.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.SysGetregArgumenting.Op2Pos)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.SysGetregArgumenting.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.SysGetregArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.SysGetregArgumenting.EntryIn
                                   , yyt^.SysGetregArgumenting.typeRepr
                                   , yyt^.SysGetregArgumenting.Nextor
                                   , yyt^.SysGetregArgumenting.Nextor);
yyt^.SysGetregArgumenting.Nextion^.Designations.EnvIn:=yyt^.SysGetregArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.SysGetregArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.SysGetregArgumenting.MainEntryIn;
yyt^.SysGetregArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.SysGetregArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.SysGetregArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.SysGetregArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.SysGetregArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.SysGetregArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.SysGetregArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.SysGetregArgumenting.typeRepr
                                   , yyt^.SysGetregArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.SysGetregArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.SysGetregArgumenting.Nextion^.Designations.EntryPosition:=yyt^.SysGetregArgumenting.EntryPosition;
yyt^.SysGetregArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.SysGetregArgumenting.PrevEntryIn;
yyt^.SysGetregArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.SysGetregArgumenting.IsCallDesignatorIn;
yyt^.SysGetregArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.SysGetregArgumenting.ValDontCareIn;
yyt^.SysGetregArgumenting.Nextion^.Designations.TableIn:=yyt^.SysGetregArgumenting.TableIn;
yyt^.SysGetregArgumenting.Nextion^.Designations.ModuleIn:=yyt^.SysGetregArgumenting.ModuleIn;
yyt^.SysGetregArgumenting.Nextion^.Designations.LevelIn:=yyt^.SysGetregArgumenting.LevelIn;
yyVisit1 (yyt^.SysGetregArgumenting.Nextion);
yyt^.SysGetregArgumenting.Nextor^.Designors.EnvIn:=yyt^.SysGetregArgumenting.EnvIn;
yyt^.SysGetregArgumenting.Nextor^.Designors.LevelIn:=yyt^.SysGetregArgumenting.LevelIn;
yyVisit1 (yyt^.SysGetregArgumenting.Nextor);
 E.SetLaccess(yyt^.SysGetregArgumenting.Expr2^.Exprs.MainEntryOut     );
(* line 4397 "oberon.aecp" *)
IF ~( yyt^.SysGetregArgumenting.Expr2^.Exprs.IsLValueOut
  ) THEN  ERR.MsgPos(ERR.MsgLValueExpected,yyt^.SysGetregArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4385 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.SysGetregArgumenting.Expr1^.Exprs.TypeReprOut)                                                            
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysGetregArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4388 "oberon.aecp" *)
IF ~( V.IsValidConstValue(yyt^.SysGetregArgumenting.Expr1^.Exprs.ValueReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgExprNotConstant,yyt^.SysGetregArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4391 "oberon.aecp" *)
IF ~( T.IsRegisterableType(yyt^.SysGetregArgumenting.Expr2^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysGetregArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4196 "oberon.aecp" *)

  yyt^.SysGetregArgumenting.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.SysGetregArgumenting.Expr2);
(* line 4200 "oberon.aecp" *)

  yyt^.SysGetregArgumenting.Coerce2                       := OB.cmtCoercion;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.SysGetregArgumenting.MainEntryOut             := yyt^.SysGetregArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.SysGetregArgumenting.TempOfsOut                    := ADR.MinSize2(yyt^.SysGetregArgumenting.Expr1^.Exprs.TempOfsOut,yyt^.SysGetregArgumenting.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.SysGetregArgumenting.ExprListOut                   := yyt^.SysGetregArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.SysGetregArgumenting.SignatureReprOut              := yyt^.SysGetregArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.SysGetregArgumenting.IsWritableOut                 := yyt^.SysGetregArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.SysGetregArgumenting.ValueReprOut                  := yyt^.SysGetregArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.SysGetregArgumenting.TypeReprOut                   := yyt^.SysGetregArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.SysGetregArgumenting.EntryOut                      := yyt^.SysGetregArgumenting.Nextion^.Designations.EntryOut;
| Tree.SysPutregArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.SysPutregArgumenting.Entry                         := OB.cmtObject;
yyt^.SysPutregArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.SysPutregArgumenting.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.SysPutregArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.SysPutregArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.SysPutregArgumenting.LevelIn;
(* line 4275 "oberon.aecp" *)

  yyt^.SysPutregArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.SysPutregArgumenting.Op2Pos;
(* line 4274 "oberon.aecp" *)


  yyt^.SysPutregArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.SysPutregArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.SysPutregArgumenting.ValDontCareIn;
yyt^.SysPutregArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.SysPutregArgumenting.TableIn;
yyt^.SysPutregArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.SysPutregArgumenting.ModuleIn;
yyVisit1 (yyt^.SysPutregArgumenting.ExprLists);
yyt^.SysPutregArgumenting.Expr2^.Exprs.EnvIn:=yyt^.SysPutregArgumenting.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.SysPutregArgumenting.Expr2^.Exprs.TempOfsIn               := yyt^.SysPutregArgumenting.TempOfsIn;
yyt^.SysPutregArgumenting.Expr2^.Exprs.LevelIn:=yyt^.SysPutregArgumenting.LevelIn;
yyt^.SysPutregArgumenting.Expr2^.Exprs.ValDontCareIn:=yyt^.SysPutregArgumenting.ValDontCareIn;
yyt^.SysPutregArgumenting.Expr2^.Exprs.TableIn:=yyt^.SysPutregArgumenting.TableIn;
yyt^.SysPutregArgumenting.Expr2^.Exprs.ModuleIn:=yyt^.SysPutregArgumenting.ModuleIn;
yyVisit1 (yyt^.SysPutregArgumenting.Expr2);
yyt^.SysPutregArgumenting.Expr1^.Exprs.EnvIn:=yyt^.SysPutregArgumenting.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.SysPutregArgumenting.Expr1^.Exprs.TempOfsIn               := yyt^.SysPutregArgumenting.TempOfsIn;
yyt^.SysPutregArgumenting.Expr1^.Exprs.LevelIn:=yyt^.SysPutregArgumenting.LevelIn;
yyt^.SysPutregArgumenting.Expr1^.Exprs.ValDontCareIn:=yyt^.SysPutregArgumenting.ValDontCareIn;
yyt^.SysPutregArgumenting.Expr1^.Exprs.TableIn:=yyt^.SysPutregArgumenting.TableIn;
yyt^.SysPutregArgumenting.Expr1^.Exprs.ModuleIn:=yyt^.SysPutregArgumenting.ModuleIn;
yyVisit1 (yyt^.SysPutregArgumenting.Expr1);
(* line 4271 "oberon.aecp" *)

  yyt^.SysPutregArgumenting.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.SysPutregArgumenting.Expr1)
                                 & ~TT.IsEmptyExpr(yyt^.SysPutregArgumenting.Expr2);
(* line 4199 "oberon.aecp" *)


  yyt^.SysPutregArgumenting.Coerce1                       := OB.cmtCoercion;
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.SysPutregArgumenting.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.SysPutregArgumenting.Op2Pos)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.SysPutregArgumenting.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.SysPutregArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.SysPutregArgumenting.EntryIn
                                   , yyt^.SysPutregArgumenting.typeRepr
                                   , yyt^.SysPutregArgumenting.Nextor
                                   , yyt^.SysPutregArgumenting.Nextor);
yyt^.SysPutregArgumenting.Nextion^.Designations.EnvIn:=yyt^.SysPutregArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.SysPutregArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.SysPutregArgumenting.MainEntryIn;
yyt^.SysPutregArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.SysPutregArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.SysPutregArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.SysPutregArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.SysPutregArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.SysPutregArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.SysPutregArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.SysPutregArgumenting.typeRepr
                                   , yyt^.SysPutregArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.SysPutregArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.SysPutregArgumenting.Nextion^.Designations.EntryPosition:=yyt^.SysPutregArgumenting.EntryPosition;
yyt^.SysPutregArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.SysPutregArgumenting.PrevEntryIn;
yyt^.SysPutregArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.SysPutregArgumenting.IsCallDesignatorIn;
yyt^.SysPutregArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.SysPutregArgumenting.ValDontCareIn;
yyt^.SysPutregArgumenting.Nextion^.Designations.TableIn:=yyt^.SysPutregArgumenting.TableIn;
yyt^.SysPutregArgumenting.Nextion^.Designations.ModuleIn:=yyt^.SysPutregArgumenting.ModuleIn;
yyt^.SysPutregArgumenting.Nextion^.Designations.LevelIn:=yyt^.SysPutregArgumenting.LevelIn;
yyVisit1 (yyt^.SysPutregArgumenting.Nextion);
yyt^.SysPutregArgumenting.Nextor^.Designors.EnvIn:=yyt^.SysPutregArgumenting.EnvIn;
yyt^.SysPutregArgumenting.Nextor^.Designors.LevelIn:=yyt^.SysPutregArgumenting.LevelIn;
yyVisit1 (yyt^.SysPutregArgumenting.Nextor);
(* line 4385 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.SysPutregArgumenting.Expr1^.Exprs.TypeReprOut)                                                            
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysPutregArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4388 "oberon.aecp" *)
IF ~( V.IsValidConstValue(yyt^.SysPutregArgumenting.Expr1^.Exprs.ValueReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgExprNotConstant,yyt^.SysPutregArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4391 "oberon.aecp" *)
IF ~( T.IsRegisterableType(yyt^.SysPutregArgumenting.Expr2^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysPutregArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4196 "oberon.aecp" *)

  yyt^.SysPutregArgumenting.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.SysPutregArgumenting.Expr2);
(* line 4200 "oberon.aecp" *)

  yyt^.SysPutregArgumenting.Coerce2                       := OB.cmtCoercion;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.SysPutregArgumenting.MainEntryOut             := yyt^.SysPutregArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.SysPutregArgumenting.TempOfsOut                    := ADR.MinSize2(yyt^.SysPutregArgumenting.Expr1^.Exprs.TempOfsOut,yyt^.SysPutregArgumenting.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.SysPutregArgumenting.ExprListOut                   := yyt^.SysPutregArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.SysPutregArgumenting.SignatureReprOut              := yyt^.SysPutregArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.SysPutregArgumenting.IsWritableOut                 := yyt^.SysPutregArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.SysPutregArgumenting.ValueReprOut                  := yyt^.SysPutregArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.SysPutregArgumenting.TypeReprOut                   := yyt^.SysPutregArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.SysPutregArgumenting.EntryOut                      := yyt^.SysPutregArgumenting.Nextion^.Designations.EntryOut;
| Tree.SysNewArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.SysNewArgumenting.Entry                         := OB.cmtObject;
yyt^.SysNewArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.SysNewArgumenting.EnvIn;
(* line 2931 "oberon.aecp" *)
 
  yyt^.SysNewArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.SysNewArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.SysNewArgumenting.LevelIn;
(* line 4275 "oberon.aecp" *)

  yyt^.SysNewArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.SysNewArgumenting.Op2Pos;
(* line 4274 "oberon.aecp" *)


  yyt^.SysNewArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.SysNewArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.SysNewArgumenting.ValDontCareIn;
yyt^.SysNewArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.SysNewArgumenting.TableIn;
yyt^.SysNewArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.SysNewArgumenting.ModuleIn;
yyVisit1 (yyt^.SysNewArgumenting.ExprLists);
yyt^.SysNewArgumenting.Expr2^.Exprs.EnvIn:=yyt^.SysNewArgumenting.EnvIn;
(* line 2930 "oberon.aecp" *)
 
  yyt^.SysNewArgumenting.Expr2^.Exprs.TempOfsIn               := yyt^.SysNewArgumenting.TempOfsIn;
yyt^.SysNewArgumenting.Expr2^.Exprs.LevelIn:=yyt^.SysNewArgumenting.LevelIn;
yyt^.SysNewArgumenting.Expr2^.Exprs.ValDontCareIn:=yyt^.SysNewArgumenting.ValDontCareIn;
yyt^.SysNewArgumenting.Expr2^.Exprs.TableIn:=yyt^.SysNewArgumenting.TableIn;
yyt^.SysNewArgumenting.Expr2^.Exprs.ModuleIn:=yyt^.SysNewArgumenting.ModuleIn;
yyVisit1 (yyt^.SysNewArgumenting.Expr2);
yyt^.SysNewArgumenting.Expr1^.Exprs.EnvIn:=yyt^.SysNewArgumenting.EnvIn;
(* line 2929 "oberon.aecp" *)

  yyt^.SysNewArgumenting.Expr1^.Exprs.TempOfsIn               := yyt^.SysNewArgumenting.TempOfsIn;
yyt^.SysNewArgumenting.Expr1^.Exprs.LevelIn:=yyt^.SysNewArgumenting.LevelIn;
yyt^.SysNewArgumenting.Expr1^.Exprs.ValDontCareIn:=yyt^.SysNewArgumenting.ValDontCareIn;
yyt^.SysNewArgumenting.Expr1^.Exprs.TableIn:=yyt^.SysNewArgumenting.TableIn;
yyt^.SysNewArgumenting.Expr1^.Exprs.ModuleIn:=yyt^.SysNewArgumenting.ModuleIn;
yyVisit1 (yyt^.SysNewArgumenting.Expr1);
(* line 4271 "oberon.aecp" *)

  yyt^.SysNewArgumenting.areEnoughParameters           := ~TT.IsEmptyExpr(yyt^.SysNewArgumenting.Expr1)
                                 & ~TT.IsEmptyExpr(yyt^.SysNewArgumenting.Expr2);
(* line 4199 "oberon.aecp" *)


  yyt^.SysNewArgumenting.Coerce1                       := OB.cmtCoercion;
(* line 4205 "oberon.aecp" *)
IF ~( yyt^.SysNewArgumenting.areEnoughParameters                                                                         
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.SysNewArgumenting.Op2Pos)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.SysNewArgumenting.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.SysNewArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.SysNewArgumenting.EntryIn
                                   , yyt^.SysNewArgumenting.typeRepr
                                   , yyt^.SysNewArgumenting.Nextor
                                   , yyt^.SysNewArgumenting.Nextor);
yyt^.SysNewArgumenting.Nextion^.Designations.EnvIn:=yyt^.SysNewArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.SysNewArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.SysNewArgumenting.MainEntryIn;
yyt^.SysNewArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.SysNewArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.SysNewArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.SysNewArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.SysNewArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.SysNewArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.SysNewArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.SysNewArgumenting.typeRepr
                                   , yyt^.SysNewArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.SysNewArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.SysNewArgumenting.Nextion^.Designations.EntryPosition:=yyt^.SysNewArgumenting.EntryPosition;
yyt^.SysNewArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.SysNewArgumenting.PrevEntryIn;
yyt^.SysNewArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.SysNewArgumenting.IsCallDesignatorIn;
yyt^.SysNewArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.SysNewArgumenting.ValDontCareIn;
yyt^.SysNewArgumenting.Nextion^.Designations.TableIn:=yyt^.SysNewArgumenting.TableIn;
yyt^.SysNewArgumenting.Nextion^.Designations.ModuleIn:=yyt^.SysNewArgumenting.ModuleIn;
yyt^.SysNewArgumenting.Nextion^.Designations.LevelIn:=yyt^.SysNewArgumenting.LevelIn;
yyVisit1 (yyt^.SysNewArgumenting.Nextion);
yyt^.SysNewArgumenting.Nextor^.Designors.EnvIn:=yyt^.SysNewArgumenting.EnvIn;
yyt^.SysNewArgumenting.Nextor^.Designors.LevelIn:=yyt^.SysNewArgumenting.LevelIn;
yyVisit1 (yyt^.SysNewArgumenting.Nextor);
(* line 4409 "oberon.aecp" *)


  yyt^.SysNewArgumenting.pointerBaseType               := T.BaseTypeOfPointerType(yyt^.SysNewArgumenting.Expr1^.Exprs.TypeReprOut);
 E.SetLaccess(yyt^.SysNewArgumenting.Expr1^.Exprs.MainEntryOut     );
(* line 4411 "oberon.aecp" *)
IF ~( T.IsPointerType(yyt^.SysNewArgumenting.Expr1^.Exprs.TypeReprOut)
      & ~T.HasPointerSubType(yyt^.SysNewArgumenting.pointerBaseType)
      & ~T.IsOpenArrayType(yyt^.SysNewArgumenting.pointerBaseType)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysNewArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4416 "oberon.aecp" *)
IF ~( yyt^.SysNewArgumenting.Expr1^.Exprs.IsLValueOut
  ) THEN  ERR.MsgPos(ERR.MsgLValueExpected,yyt^.SysNewArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4419 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.SysNewArgumenting.Expr2^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysNewArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4196 "oberon.aecp" *)

  yyt^.SysNewArgumenting.isEmptyExpr2                  := TT.IsEmptyExpr(yyt^.SysNewArgumenting.Expr2);
(* line 4405 "oberon.aecp" *)

  yyt^.SysNewArgumenting.Coerce2                       := CO.GetCoercion                                                              
                                   ( yyt^.SysNewArgumenting.Expr2^.Exprs.TypeReprOut
                                   , OB.cLongintTypeRepr);
(* line 3194 "oberon.aecp" *)

                                                          yyt^.SysNewArgumenting.MainEntryOut             := yyt^.SysNewArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2933 "oberon.aecp" *)
 

  yyt^.SysNewArgumenting.TempOfsOut                    := ADR.MinSize2(yyt^.SysNewArgumenting.Expr1^.Exprs.TempOfsOut,yyt^.SysNewArgumenting.Expr2^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.SysNewArgumenting.ExprListOut                   := yyt^.SysNewArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.SysNewArgumenting.SignatureReprOut              := yyt^.SysNewArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.SysNewArgumenting.IsWritableOut                 := yyt^.SysNewArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.SysNewArgumenting.ValueReprOut                  := yyt^.SysNewArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.SysNewArgumenting.TypeReprOut                   := yyt^.SysNewArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.SysNewArgumenting.EntryOut                      := yyt^.SysNewArgumenting.Nextion^.Designations.EntryOut;
| Tree.PredeclArgumenting3:
(* line 2250 "oberon.aecp" *)

  yyt^.PredeclArgumenting3.Entry                         := OB.cmtObject;
yyt^.PredeclArgumenting3.ExprLists^.ExprLists.EnvIn:=yyt^.PredeclArgumenting3.EnvIn;
(* line 2940 "oberon.aecp" *)
 
  yyt^.PredeclArgumenting3.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.PredeclArgumenting3.ExprLists^.ExprLists.LevelIn:=yyt^.PredeclArgumenting3.LevelIn;
(* line 4429 "oberon.aecp" *)

  yyt^.PredeclArgumenting3.ExprLists^.ExprLists.ClosingPosIn        := yyt^.PredeclArgumenting3.Op2Pos;
(* line 4428 "oberon.aecp" *)


  yyt^.PredeclArgumenting3.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.PredeclArgumenting3.ExprLists^.ExprLists.ValDontCareIn:=yyt^.PredeclArgumenting3.ValDontCareIn;
yyt^.PredeclArgumenting3.ExprLists^.ExprLists.TableIn:=yyt^.PredeclArgumenting3.TableIn;
yyt^.PredeclArgumenting3.ExprLists^.ExprLists.ModuleIn:=yyt^.PredeclArgumenting3.ModuleIn;
yyVisit1 (yyt^.PredeclArgumenting3.ExprLists);
yyt^.PredeclArgumenting3.Expr3^.Exprs.EnvIn:=yyt^.PredeclArgumenting3.EnvIn;
(* line 2939 "oberon.aecp" *)
 
  yyt^.PredeclArgumenting3.Expr3^.Exprs.TempOfsIn               := yyt^.PredeclArgumenting3.TempOfsIn;
yyt^.PredeclArgumenting3.Expr3^.Exprs.LevelIn:=yyt^.PredeclArgumenting3.LevelIn;
yyt^.PredeclArgumenting3.Expr3^.Exprs.ValDontCareIn:=yyt^.PredeclArgumenting3.ValDontCareIn;
yyt^.PredeclArgumenting3.Expr3^.Exprs.TableIn:=yyt^.PredeclArgumenting3.TableIn;
yyt^.PredeclArgumenting3.Expr3^.Exprs.ModuleIn:=yyt^.PredeclArgumenting3.ModuleIn;
yyVisit1 (yyt^.PredeclArgumenting3.Expr3);
yyt^.PredeclArgumenting3.Expr2^.Exprs.EnvIn:=yyt^.PredeclArgumenting3.EnvIn;
(* line 2938 "oberon.aecp" *)
 
  yyt^.PredeclArgumenting3.Expr2^.Exprs.TempOfsIn               := yyt^.PredeclArgumenting3.TempOfsIn;
yyt^.PredeclArgumenting3.Expr2^.Exprs.LevelIn:=yyt^.PredeclArgumenting3.LevelIn;
yyt^.PredeclArgumenting3.Expr2^.Exprs.ValDontCareIn:=yyt^.PredeclArgumenting3.ValDontCareIn;
yyt^.PredeclArgumenting3.Expr2^.Exprs.TableIn:=yyt^.PredeclArgumenting3.TableIn;
yyt^.PredeclArgumenting3.Expr2^.Exprs.ModuleIn:=yyt^.PredeclArgumenting3.ModuleIn;
yyVisit1 (yyt^.PredeclArgumenting3.Expr2);
yyt^.PredeclArgumenting3.Expr1^.Exprs.EnvIn:=yyt^.PredeclArgumenting3.EnvIn;
(* line 2937 "oberon.aecp" *)

  yyt^.PredeclArgumenting3.Expr1^.Exprs.TempOfsIn               := yyt^.PredeclArgumenting3.TempOfsIn;
yyt^.PredeclArgumenting3.Expr1^.Exprs.LevelIn:=yyt^.PredeclArgumenting3.LevelIn;
yyt^.PredeclArgumenting3.Expr1^.Exprs.ValDontCareIn:=yyt^.PredeclArgumenting3.ValDontCareIn;
yyt^.PredeclArgumenting3.Expr1^.Exprs.TableIn:=yyt^.PredeclArgumenting3.TableIn;
yyt^.PredeclArgumenting3.Expr1^.Exprs.ModuleIn:=yyt^.PredeclArgumenting3.ModuleIn;
yyVisit1 (yyt^.PredeclArgumenting3.Expr1);
(* line 4426 "oberon.aecp" *)

  yyt^.PredeclArgumenting3.Coerce3                       := OB.cmtCoercion;
(* line 4431 "oberon.aecp" *)
IF ~( ~TT.IsEmptyExpr(yyt^.PredeclArgumenting3.Expr1)                                                                    
      & ~TT.IsEmptyExpr(yyt^.PredeclArgumenting3.Expr2)
      & ~TT.IsEmptyExpr(yyt^.PredeclArgumenting3.Expr3)
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.PredeclArgumenting3.Op2Pos)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.PredeclArgumenting3.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.PredeclArgumenting3.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.PredeclArgumenting3.EntryIn
                                   , yyt^.PredeclArgumenting3.typeRepr
                                   , yyt^.PredeclArgumenting3.Nextor
                                   , yyt^.PredeclArgumenting3.Nextor);
yyt^.PredeclArgumenting3.Nextion^.Designations.EnvIn:=yyt^.PredeclArgumenting3.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.PredeclArgumenting3.Nextion^.Designations.MainEntryIn      := yyt^.PredeclArgumenting3.MainEntryIn;
yyt^.PredeclArgumenting3.Nextion^.Designations.TempOfsIn:=yyt^.PredeclArgumenting3.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.PredeclArgumenting3.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.PredeclArgumenting3.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.PredeclArgumenting3.Nextion^.Designations.ValueReprIn           := yyt^.PredeclArgumenting3.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.PredeclArgumenting3.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.PredeclArgumenting3.typeRepr
                                   , yyt^.PredeclArgumenting3.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.PredeclArgumenting3.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.PredeclArgumenting3.Nextion^.Designations.EntryPosition:=yyt^.PredeclArgumenting3.EntryPosition;
yyt^.PredeclArgumenting3.Nextion^.Designations.PrevEntryIn:=yyt^.PredeclArgumenting3.PrevEntryIn;
yyt^.PredeclArgumenting3.Nextion^.Designations.IsCallDesignatorIn:=yyt^.PredeclArgumenting3.IsCallDesignatorIn;
yyt^.PredeclArgumenting3.Nextion^.Designations.ValDontCareIn:=yyt^.PredeclArgumenting3.ValDontCareIn;
yyt^.PredeclArgumenting3.Nextion^.Designations.TableIn:=yyt^.PredeclArgumenting3.TableIn;
yyt^.PredeclArgumenting3.Nextion^.Designations.ModuleIn:=yyt^.PredeclArgumenting3.ModuleIn;
yyt^.PredeclArgumenting3.Nextion^.Designations.LevelIn:=yyt^.PredeclArgumenting3.LevelIn;
yyVisit1 (yyt^.PredeclArgumenting3.Nextion);
yyt^.PredeclArgumenting3.Nextor^.Designors.EnvIn:=yyt^.PredeclArgumenting3.EnvIn;
yyt^.PredeclArgumenting3.Nextor^.Designors.LevelIn:=yyt^.PredeclArgumenting3.LevelIn;
yyVisit1 (yyt^.PredeclArgumenting3.Nextor);
(* line 3194 "oberon.aecp" *)

                                                          yyt^.PredeclArgumenting3.MainEntryOut             := yyt^.PredeclArgumenting3.Nextion^.Designations.MainEntryOut;
(* line 2942 "oberon.aecp" *)
 

  yyt^.PredeclArgumenting3.TempOfsOut                    := ADR.MinSize3(yyt^.PredeclArgumenting3.Expr1^.Exprs.TempOfsOut,yyt^.PredeclArgumenting3.Expr2^.Exprs.TempOfsOut,yyt^.PredeclArgumenting3.Expr3^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.PredeclArgumenting3.ExprListOut                   := yyt^.PredeclArgumenting3.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.PredeclArgumenting3.SignatureReprOut              := yyt^.PredeclArgumenting3.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.PredeclArgumenting3.IsWritableOut                 := yyt^.PredeclArgumenting3.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.PredeclArgumenting3.ValueReprOut                  := yyt^.PredeclArgumenting3.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.PredeclArgumenting3.TypeReprOut                   := yyt^.PredeclArgumenting3.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.PredeclArgumenting3.EntryOut                      := yyt^.PredeclArgumenting3.Nextion^.Designations.EntryOut;
| Tree.SysMoveArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.SysMoveArgumenting.Entry                         := OB.cmtObject;
yyt^.SysMoveArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.SysMoveArgumenting.EnvIn;
(* line 2940 "oberon.aecp" *)
 
  yyt^.SysMoveArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.SysMoveArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.SysMoveArgumenting.LevelIn;
(* line 4429 "oberon.aecp" *)

  yyt^.SysMoveArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.SysMoveArgumenting.Op2Pos;
(* line 4428 "oberon.aecp" *)


  yyt^.SysMoveArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.SysMoveArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.SysMoveArgumenting.ValDontCareIn;
yyt^.SysMoveArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.SysMoveArgumenting.TableIn;
yyt^.SysMoveArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.SysMoveArgumenting.ModuleIn;
yyVisit1 (yyt^.SysMoveArgumenting.ExprLists);
yyt^.SysMoveArgumenting.Expr3^.Exprs.EnvIn:=yyt^.SysMoveArgumenting.EnvIn;
(* line 2939 "oberon.aecp" *)
 
  yyt^.SysMoveArgumenting.Expr3^.Exprs.TempOfsIn               := yyt^.SysMoveArgumenting.TempOfsIn;
yyt^.SysMoveArgumenting.Expr3^.Exprs.LevelIn:=yyt^.SysMoveArgumenting.LevelIn;
yyt^.SysMoveArgumenting.Expr3^.Exprs.ValDontCareIn:=yyt^.SysMoveArgumenting.ValDontCareIn;
yyt^.SysMoveArgumenting.Expr3^.Exprs.TableIn:=yyt^.SysMoveArgumenting.TableIn;
yyt^.SysMoveArgumenting.Expr3^.Exprs.ModuleIn:=yyt^.SysMoveArgumenting.ModuleIn;
yyVisit1 (yyt^.SysMoveArgumenting.Expr3);
yyt^.SysMoveArgumenting.Expr2^.Exprs.EnvIn:=yyt^.SysMoveArgumenting.EnvIn;
(* line 2938 "oberon.aecp" *)
 
  yyt^.SysMoveArgumenting.Expr2^.Exprs.TempOfsIn               := yyt^.SysMoveArgumenting.TempOfsIn;
yyt^.SysMoveArgumenting.Expr2^.Exprs.LevelIn:=yyt^.SysMoveArgumenting.LevelIn;
yyt^.SysMoveArgumenting.Expr2^.Exprs.ValDontCareIn:=yyt^.SysMoveArgumenting.ValDontCareIn;
yyt^.SysMoveArgumenting.Expr2^.Exprs.TableIn:=yyt^.SysMoveArgumenting.TableIn;
yyt^.SysMoveArgumenting.Expr2^.Exprs.ModuleIn:=yyt^.SysMoveArgumenting.ModuleIn;
yyVisit1 (yyt^.SysMoveArgumenting.Expr2);
yyt^.SysMoveArgumenting.Expr1^.Exprs.EnvIn:=yyt^.SysMoveArgumenting.EnvIn;
(* line 2937 "oberon.aecp" *)

  yyt^.SysMoveArgumenting.Expr1^.Exprs.TempOfsIn               := yyt^.SysMoveArgumenting.TempOfsIn;
yyt^.SysMoveArgumenting.Expr1^.Exprs.LevelIn:=yyt^.SysMoveArgumenting.LevelIn;
yyt^.SysMoveArgumenting.Expr1^.Exprs.ValDontCareIn:=yyt^.SysMoveArgumenting.ValDontCareIn;
yyt^.SysMoveArgumenting.Expr1^.Exprs.TableIn:=yyt^.SysMoveArgumenting.TableIn;
yyt^.SysMoveArgumenting.Expr1^.Exprs.ModuleIn:=yyt^.SysMoveArgumenting.ModuleIn;
yyVisit1 (yyt^.SysMoveArgumenting.Expr1);
(* line 4440 "oberon.aecp" *)

  yyt^.SysMoveArgumenting.Coerce3                       := CO.GetCoercion                                                             
                                   ( yyt^.SysMoveArgumenting.Expr3^.Exprs.TypeReprOut
                                   , OB.cLongintTypeRepr);
(* line 4431 "oberon.aecp" *)
IF ~( ~TT.IsEmptyExpr(yyt^.SysMoveArgumenting.Expr1)                                                                    
      & ~TT.IsEmptyExpr(yyt^.SysMoveArgumenting.Expr2)
      & ~TT.IsEmptyExpr(yyt^.SysMoveArgumenting.Expr3)
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.SysMoveArgumenting.Op2Pos)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.SysMoveArgumenting.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.SysMoveArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.SysMoveArgumenting.EntryIn
                                   , yyt^.SysMoveArgumenting.typeRepr
                                   , yyt^.SysMoveArgumenting.Nextor
                                   , yyt^.SysMoveArgumenting.Nextor);
yyt^.SysMoveArgumenting.Nextion^.Designations.EnvIn:=yyt^.SysMoveArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.SysMoveArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.SysMoveArgumenting.MainEntryIn;
yyt^.SysMoveArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.SysMoveArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.SysMoveArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.SysMoveArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.SysMoveArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.SysMoveArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.SysMoveArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.SysMoveArgumenting.typeRepr
                                   , yyt^.SysMoveArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.SysMoveArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.SysMoveArgumenting.Nextion^.Designations.EntryPosition:=yyt^.SysMoveArgumenting.EntryPosition;
yyt^.SysMoveArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.SysMoveArgumenting.PrevEntryIn;
yyt^.SysMoveArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.SysMoveArgumenting.IsCallDesignatorIn;
yyt^.SysMoveArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.SysMoveArgumenting.ValDontCareIn;
yyt^.SysMoveArgumenting.Nextion^.Designations.TableIn:=yyt^.SysMoveArgumenting.TableIn;
yyt^.SysMoveArgumenting.Nextion^.Designations.ModuleIn:=yyt^.SysMoveArgumenting.ModuleIn;
yyt^.SysMoveArgumenting.Nextion^.Designations.LevelIn:=yyt^.SysMoveArgumenting.LevelIn;
yyVisit1 (yyt^.SysMoveArgumenting.Nextion);
yyt^.SysMoveArgumenting.Nextor^.Designors.EnvIn:=yyt^.SysMoveArgumenting.EnvIn;
yyt^.SysMoveArgumenting.Nextor^.Designors.LevelIn:=yyt^.SysMoveArgumenting.LevelIn;
yyVisit1 (yyt^.SysMoveArgumenting.Nextor);
(* line 4444 "oberon.aecp" *)
IF ~( T.IsLongintType(yyt^.SysMoveArgumenting.Expr1^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysMoveArgumenting.Expr1^.Exprs.Position)
 END;
(* line 4447 "oberon.aecp" *)
IF ~( T.IsLongintType(yyt^.SysMoveArgumenting.Expr2^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysMoveArgumenting.Expr2^.Exprs.Position)
 END;
(* line 4450 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.SysMoveArgumenting.Expr3^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysMoveArgumenting.Expr3^.Exprs.Position)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.SysMoveArgumenting.MainEntryOut             := yyt^.SysMoveArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2942 "oberon.aecp" *)
 

  yyt^.SysMoveArgumenting.TempOfsOut                    := ADR.MinSize3(yyt^.SysMoveArgumenting.Expr1^.Exprs.TempOfsOut,yyt^.SysMoveArgumenting.Expr2^.Exprs.TempOfsOut,yyt^.SysMoveArgumenting.Expr3^.Exprs.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.SysMoveArgumenting.ExprListOut                   := yyt^.SysMoveArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.SysMoveArgumenting.SignatureReprOut              := yyt^.SysMoveArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.SysMoveArgumenting.IsWritableOut                 := yyt^.SysMoveArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.SysMoveArgumenting.ValueReprOut                  := yyt^.SysMoveArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.SysMoveArgumenting.TypeReprOut                   := yyt^.SysMoveArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.SysMoveArgumenting.EntryOut                      := yyt^.SysMoveArgumenting.Nextion^.Designations.EntryOut;
| Tree.TypeArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.TypeArgumenting.Entry                         := OB.cmtObject;
yyt^.TypeArgumenting.Qualidents^.Qualidents.TableIn:=yyt^.TypeArgumenting.TableIn;
yyt^.TypeArgumenting.Qualidents^.Qualidents.ModuleIn:=yyt^.TypeArgumenting.ModuleIn;
yyVisit1 (yyt^.TypeArgumenting.Qualidents);
(* line 4458 "oberon.aecp" *)

  yyt^.TypeArgumenting.argTypeRepr                   := E.TypeOfTypeEntry(yyt^.TypeArgumenting.Qualidents^.Qualidents.EntryOut);
(* line 4466 "oberon.aecp" *)
IF ~( E.IsTypeEntry(yyt^.TypeArgumenting.Qualidents^.Qualidents.EntryOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.TypeArgumenting.Qualidents^.Qualidents.Position)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.TypeArgumenting.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.TypeArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.TypeArgumenting.EntryIn
                                   , yyt^.TypeArgumenting.typeRepr
                                   , yyt^.TypeArgumenting.Nextor
                                   , yyt^.TypeArgumenting.Nextor);
yyt^.TypeArgumenting.Nextion^.Designations.LevelIn:=yyt^.TypeArgumenting.LevelIn;
yyt^.TypeArgumenting.Nextion^.Designations.EnvIn:=yyt^.TypeArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.TypeArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.TypeArgumenting.MainEntryIn;
yyt^.TypeArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.TypeArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.TypeArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.TypeArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.TypeArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.TypeArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.TypeArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.TypeArgumenting.typeRepr
                                   , yyt^.TypeArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.TypeArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.TypeArgumenting.Nextion^.Designations.EntryPosition:=yyt^.TypeArgumenting.EntryPosition;
yyt^.TypeArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.TypeArgumenting.PrevEntryIn;
yyt^.TypeArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.TypeArgumenting.IsCallDesignatorIn;
yyt^.TypeArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.TypeArgumenting.ValDontCareIn;
yyt^.TypeArgumenting.Nextion^.Designations.TableIn:=yyt^.TypeArgumenting.TableIn;
yyt^.TypeArgumenting.Nextion^.Designations.ModuleIn:=yyt^.TypeArgumenting.ModuleIn;
yyVisit1 (yyt^.TypeArgumenting.Nextion);
yyt^.TypeArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.TypeArgumenting.EnvIn;
(* line 2946 "oberon.aecp" *)

  yyt^.TypeArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.TypeArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.TypeArgumenting.LevelIn;
(* line 4461 "oberon.aecp" *)

  yyt^.TypeArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.TypeArgumenting.Op2Pos;
(* line 4460 "oberon.aecp" *)


  yyt^.TypeArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.TypeArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.TypeArgumenting.ValDontCareIn;
yyt^.TypeArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.TypeArgumenting.TableIn;
yyt^.TypeArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.TypeArgumenting.ModuleIn;
yyVisit1 (yyt^.TypeArgumenting.ExprLists);
yyt^.TypeArgumenting.Nextor^.Designors.EnvIn:=yyt^.TypeArgumenting.EnvIn;
yyt^.TypeArgumenting.Nextor^.Designors.LevelIn:=yyt^.TypeArgumenting.LevelIn;
yyVisit1 (yyt^.TypeArgumenting.Nextor);
(* line 4463 "oberon.aecp" *)
IF ~( TT.IsNotEmptyQualident(yyt^.TypeArgumenting.Qualidents)                                                        
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.TypeArgumenting.Op2Pos)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.TypeArgumenting.MainEntryOut             := yyt^.TypeArgumenting.Nextion^.Designations.MainEntryOut;
yyt^.TypeArgumenting.TempOfsOut:=yyt^.TypeArgumenting.ExprLists^.ExprLists.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.TypeArgumenting.ExprListOut                   := yyt^.TypeArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.TypeArgumenting.SignatureReprOut              := yyt^.TypeArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.TypeArgumenting.IsWritableOut                 := yyt^.TypeArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.TypeArgumenting.ValueReprOut                  := yyt^.TypeArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.TypeArgumenting.TypeReprOut                   := yyt^.TypeArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.TypeArgumenting.EntryOut                      := yyt^.TypeArgumenting.Nextion^.Designations.EntryOut;
| Tree.MaxMinArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.MaxMinArgumenting.Entry                         := OB.cmtObject;
yyt^.MaxMinArgumenting.Qualidents^.Qualidents.TableIn:=yyt^.MaxMinArgumenting.TableIn;
yyt^.MaxMinArgumenting.Qualidents^.Qualidents.ModuleIn:=yyt^.MaxMinArgumenting.ModuleIn;
yyVisit1 (yyt^.MaxMinArgumenting.Qualidents);
(* line 4458 "oberon.aecp" *)

  yyt^.MaxMinArgumenting.argTypeRepr                   := E.TypeOfTypeEntry(yyt^.MaxMinArgumenting.Qualidents^.Qualidents.EntryOut);
(* line 4466 "oberon.aecp" *)
IF ~( E.IsTypeEntry(yyt^.MaxMinArgumenting.Qualidents^.Qualidents.EntryOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.MaxMinArgumenting.Qualidents^.Qualidents.Position)
 END;
(* line 4473 "oberon.aecp" *)

  yyt^.MaxMinArgumenting.typeRepr                      := T.TypeLimited(yyt^.MaxMinArgumenting.argTypeRepr);
(* line 4038 "oberon.aecp" *)


  yyt^.MaxMinArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.MaxMinArgumenting.EntryIn
                                   , yyt^.MaxMinArgumenting.typeRepr
                                   , yyt^.MaxMinArgumenting.Nextor
                                   , yyt^.MaxMinArgumenting.Nextor);
yyt^.MaxMinArgumenting.Nextion^.Designations.LevelIn:=yyt^.MaxMinArgumenting.LevelIn;
yyt^.MaxMinArgumenting.Nextion^.Designations.EnvIn:=yyt^.MaxMinArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.MaxMinArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.MaxMinArgumenting.MainEntryIn;
yyt^.MaxMinArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.MaxMinArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.MaxMinArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.MaxMinArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.MaxMinArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.MaxMinArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.MaxMinArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.MaxMinArgumenting.typeRepr
                                   , yyt^.MaxMinArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.MaxMinArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.MaxMinArgumenting.Nextion^.Designations.EntryPosition:=yyt^.MaxMinArgumenting.EntryPosition;
yyt^.MaxMinArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.MaxMinArgumenting.PrevEntryIn;
yyt^.MaxMinArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.MaxMinArgumenting.IsCallDesignatorIn;
yyt^.MaxMinArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.MaxMinArgumenting.ValDontCareIn;
yyt^.MaxMinArgumenting.Nextion^.Designations.TableIn:=yyt^.MaxMinArgumenting.TableIn;
yyt^.MaxMinArgumenting.Nextion^.Designations.ModuleIn:=yyt^.MaxMinArgumenting.ModuleIn;
yyVisit1 (yyt^.MaxMinArgumenting.Nextion);
yyt^.MaxMinArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.MaxMinArgumenting.EnvIn;
(* line 2946 "oberon.aecp" *)

  yyt^.MaxMinArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.MaxMinArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.MaxMinArgumenting.LevelIn;
(* line 4461 "oberon.aecp" *)

  yyt^.MaxMinArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.MaxMinArgumenting.Op2Pos;
(* line 4460 "oberon.aecp" *)


  yyt^.MaxMinArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.MaxMinArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.MaxMinArgumenting.ValDontCareIn;
yyt^.MaxMinArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.MaxMinArgumenting.TableIn;
yyt^.MaxMinArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.MaxMinArgumenting.ModuleIn;
yyVisit1 (yyt^.MaxMinArgumenting.ExprLists);
yyt^.MaxMinArgumenting.Nextor^.Designors.EnvIn:=yyt^.MaxMinArgumenting.EnvIn;
yyt^.MaxMinArgumenting.Nextor^.Designors.LevelIn:=yyt^.MaxMinArgumenting.LevelIn;
yyVisit1 (yyt^.MaxMinArgumenting.Nextor);
(* line 4475 "oberon.aecp" *)
IF ~( T.IsBasicType(yyt^.MaxMinArgumenting.argTypeRepr)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.MaxMinArgumenting.Qualidents^.Qualidents.Position)
 END;
(* line 4463 "oberon.aecp" *)
IF ~( TT.IsNotEmptyQualident(yyt^.MaxMinArgumenting.Qualidents)                                                        
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.MaxMinArgumenting.Op2Pos)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.MaxMinArgumenting.MainEntryOut             := yyt^.MaxMinArgumenting.Nextion^.Designations.MainEntryOut;
yyt^.MaxMinArgumenting.TempOfsOut:=yyt^.MaxMinArgumenting.ExprLists^.ExprLists.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.MaxMinArgumenting.ExprListOut                   := yyt^.MaxMinArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.MaxMinArgumenting.SignatureReprOut              := yyt^.MaxMinArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.MaxMinArgumenting.IsWritableOut                 := yyt^.MaxMinArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.MaxMinArgumenting.ValueReprOut                  := yyt^.MaxMinArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.MaxMinArgumenting.TypeReprOut                   := yyt^.MaxMinArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.MaxMinArgumenting.EntryOut                      := yyt^.MaxMinArgumenting.Nextion^.Designations.EntryOut;
| Tree.MaxArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.MaxArgumenting.Entry                         := OB.cmtObject;
yyt^.MaxArgumenting.Qualidents^.Qualidents.TableIn:=yyt^.MaxArgumenting.TableIn;
yyt^.MaxArgumenting.Qualidents^.Qualidents.ModuleIn:=yyt^.MaxArgumenting.ModuleIn;
yyVisit1 (yyt^.MaxArgumenting.Qualidents);
(* line 4458 "oberon.aecp" *)

  yyt^.MaxArgumenting.argTypeRepr                   := E.TypeOfTypeEntry(yyt^.MaxArgumenting.Qualidents^.Qualidents.EntryOut);
(* line 4466 "oberon.aecp" *)
IF ~( E.IsTypeEntry(yyt^.MaxArgumenting.Qualidents^.Qualidents.EntryOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.MaxArgumenting.Qualidents^.Qualidents.Position)
 END;
(* line 4473 "oberon.aecp" *)

  yyt^.MaxArgumenting.typeRepr                      := T.TypeLimited(yyt^.MaxArgumenting.argTypeRepr);
(* line 4038 "oberon.aecp" *)


  yyt^.MaxArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.MaxArgumenting.EntryIn
                                   , yyt^.MaxArgumenting.typeRepr
                                   , yyt^.MaxArgumenting.Nextor
                                   , yyt^.MaxArgumenting.Nextor);
yyt^.MaxArgumenting.Nextion^.Designations.LevelIn:=yyt^.MaxArgumenting.LevelIn;
yyt^.MaxArgumenting.Nextion^.Designations.EnvIn:=yyt^.MaxArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.MaxArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.MaxArgumenting.MainEntryIn;
yyt^.MaxArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.MaxArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.MaxArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4481 "oberon.aecp" *)

  yyt^.MaxArgumenting.valueRepr                     := V.MaxValue(yyt^.MaxArgumenting.argTypeRepr);
(* line 4048 "oberon.aecp" *)

  yyt^.MaxArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.MaxArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.MaxArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.MaxArgumenting.typeRepr
                                   , yyt^.MaxArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.MaxArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.MaxArgumenting.Nextion^.Designations.EntryPosition:=yyt^.MaxArgumenting.EntryPosition;
yyt^.MaxArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.MaxArgumenting.PrevEntryIn;
yyt^.MaxArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.MaxArgumenting.IsCallDesignatorIn;
yyt^.MaxArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.MaxArgumenting.ValDontCareIn;
yyt^.MaxArgumenting.Nextion^.Designations.TableIn:=yyt^.MaxArgumenting.TableIn;
yyt^.MaxArgumenting.Nextion^.Designations.ModuleIn:=yyt^.MaxArgumenting.ModuleIn;
yyVisit1 (yyt^.MaxArgumenting.Nextion);
yyt^.MaxArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.MaxArgumenting.EnvIn;
(* line 2946 "oberon.aecp" *)

  yyt^.MaxArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.MaxArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.MaxArgumenting.LevelIn;
(* line 4461 "oberon.aecp" *)

  yyt^.MaxArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.MaxArgumenting.Op2Pos;
(* line 4460 "oberon.aecp" *)


  yyt^.MaxArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.MaxArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.MaxArgumenting.ValDontCareIn;
yyt^.MaxArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.MaxArgumenting.TableIn;
yyt^.MaxArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.MaxArgumenting.ModuleIn;
yyVisit1 (yyt^.MaxArgumenting.ExprLists);
yyt^.MaxArgumenting.Nextor^.Designors.EnvIn:=yyt^.MaxArgumenting.EnvIn;
yyt^.MaxArgumenting.Nextor^.Designors.LevelIn:=yyt^.MaxArgumenting.LevelIn;
yyVisit1 (yyt^.MaxArgumenting.Nextor);
(* line 4475 "oberon.aecp" *)
IF ~( T.IsBasicType(yyt^.MaxArgumenting.argTypeRepr)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.MaxArgumenting.Qualidents^.Qualidents.Position)
 END;
(* line 4463 "oberon.aecp" *)
IF ~( TT.IsNotEmptyQualident(yyt^.MaxArgumenting.Qualidents)                                                        
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.MaxArgumenting.Op2Pos)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.MaxArgumenting.MainEntryOut             := yyt^.MaxArgumenting.Nextion^.Designations.MainEntryOut;
yyt^.MaxArgumenting.TempOfsOut:=yyt^.MaxArgumenting.ExprLists^.ExprLists.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.MaxArgumenting.ExprListOut                   := yyt^.MaxArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.MaxArgumenting.SignatureReprOut              := yyt^.MaxArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.MaxArgumenting.IsWritableOut                 := yyt^.MaxArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.MaxArgumenting.ValueReprOut                  := yyt^.MaxArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.MaxArgumenting.TypeReprOut                   := yyt^.MaxArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.MaxArgumenting.EntryOut                      := yyt^.MaxArgumenting.Nextion^.Designations.EntryOut;
| Tree.MinArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.MinArgumenting.Entry                         := OB.cmtObject;
yyt^.MinArgumenting.Qualidents^.Qualidents.TableIn:=yyt^.MinArgumenting.TableIn;
yyt^.MinArgumenting.Qualidents^.Qualidents.ModuleIn:=yyt^.MinArgumenting.ModuleIn;
yyVisit1 (yyt^.MinArgumenting.Qualidents);
(* line 4458 "oberon.aecp" *)

  yyt^.MinArgumenting.argTypeRepr                   := E.TypeOfTypeEntry(yyt^.MinArgumenting.Qualidents^.Qualidents.EntryOut);
(* line 4466 "oberon.aecp" *)
IF ~( E.IsTypeEntry(yyt^.MinArgumenting.Qualidents^.Qualidents.EntryOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.MinArgumenting.Qualidents^.Qualidents.Position)
 END;
(* line 4473 "oberon.aecp" *)

  yyt^.MinArgumenting.typeRepr                      := T.TypeLimited(yyt^.MinArgumenting.argTypeRepr);
(* line 4038 "oberon.aecp" *)


  yyt^.MinArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.MinArgumenting.EntryIn
                                   , yyt^.MinArgumenting.typeRepr
                                   , yyt^.MinArgumenting.Nextor
                                   , yyt^.MinArgumenting.Nextor);
yyt^.MinArgumenting.Nextion^.Designations.LevelIn:=yyt^.MinArgumenting.LevelIn;
yyt^.MinArgumenting.Nextion^.Designations.EnvIn:=yyt^.MinArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.MinArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.MinArgumenting.MainEntryIn;
yyt^.MinArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.MinArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.MinArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4486 "oberon.aecp" *)

  yyt^.MinArgumenting.valueRepr                     := V.MinValue(yyt^.MinArgumenting.argTypeRepr);
(* line 4048 "oberon.aecp" *)

  yyt^.MinArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.MinArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.MinArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.MinArgumenting.typeRepr
                                   , yyt^.MinArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.MinArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.MinArgumenting.Nextion^.Designations.EntryPosition:=yyt^.MinArgumenting.EntryPosition;
yyt^.MinArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.MinArgumenting.PrevEntryIn;
yyt^.MinArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.MinArgumenting.IsCallDesignatorIn;
yyt^.MinArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.MinArgumenting.ValDontCareIn;
yyt^.MinArgumenting.Nextion^.Designations.TableIn:=yyt^.MinArgumenting.TableIn;
yyt^.MinArgumenting.Nextion^.Designations.ModuleIn:=yyt^.MinArgumenting.ModuleIn;
yyVisit1 (yyt^.MinArgumenting.Nextion);
yyt^.MinArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.MinArgumenting.EnvIn;
(* line 2946 "oberon.aecp" *)

  yyt^.MinArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.MinArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.MinArgumenting.LevelIn;
(* line 4461 "oberon.aecp" *)

  yyt^.MinArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.MinArgumenting.Op2Pos;
(* line 4460 "oberon.aecp" *)


  yyt^.MinArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.MinArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.MinArgumenting.ValDontCareIn;
yyt^.MinArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.MinArgumenting.TableIn;
yyt^.MinArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.MinArgumenting.ModuleIn;
yyVisit1 (yyt^.MinArgumenting.ExprLists);
yyt^.MinArgumenting.Nextor^.Designors.EnvIn:=yyt^.MinArgumenting.EnvIn;
yyt^.MinArgumenting.Nextor^.Designors.LevelIn:=yyt^.MinArgumenting.LevelIn;
yyVisit1 (yyt^.MinArgumenting.Nextor);
(* line 4475 "oberon.aecp" *)
IF ~( T.IsBasicType(yyt^.MinArgumenting.argTypeRepr)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.MinArgumenting.Qualidents^.Qualidents.Position)
 END;
(* line 4463 "oberon.aecp" *)
IF ~( TT.IsNotEmptyQualident(yyt^.MinArgumenting.Qualidents)                                                        
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.MinArgumenting.Op2Pos)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.MinArgumenting.MainEntryOut             := yyt^.MinArgumenting.Nextion^.Designations.MainEntryOut;
yyt^.MinArgumenting.TempOfsOut:=yyt^.MinArgumenting.ExprLists^.ExprLists.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.MinArgumenting.ExprListOut                   := yyt^.MinArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.MinArgumenting.SignatureReprOut              := yyt^.MinArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.MinArgumenting.IsWritableOut                 := yyt^.MinArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.MinArgumenting.ValueReprOut                  := yyt^.MinArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.MinArgumenting.TypeReprOut                   := yyt^.MinArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.MinArgumenting.EntryOut                      := yyt^.MinArgumenting.Nextion^.Designations.EntryOut;
| Tree.SizeArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.SizeArgumenting.Entry                         := OB.cmtObject;
yyt^.SizeArgumenting.Qualidents^.Qualidents.TableIn:=yyt^.SizeArgumenting.TableIn;
yyt^.SizeArgumenting.Qualidents^.Qualidents.ModuleIn:=yyt^.SizeArgumenting.ModuleIn;
yyVisit1 (yyt^.SizeArgumenting.Qualidents);
(* line 4458 "oberon.aecp" *)

  yyt^.SizeArgumenting.argTypeRepr                   := E.TypeOfTypeEntry(yyt^.SizeArgumenting.Qualidents^.Qualidents.EntryOut);
(* line 4466 "oberon.aecp" *)
IF ~( E.IsTypeEntry(yyt^.SizeArgumenting.Qualidents^.Qualidents.EntryOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SizeArgumenting.Qualidents^.Qualidents.Position)
 END;
(* line 4492 "oberon.aecp" *)

  yyt^.SizeArgumenting.typeRepr                      := OB.cLongintTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.SizeArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.SizeArgumenting.EntryIn
                                   , yyt^.SizeArgumenting.typeRepr
                                   , yyt^.SizeArgumenting.Nextor
                                   , yyt^.SizeArgumenting.Nextor);
yyt^.SizeArgumenting.Nextion^.Designations.LevelIn:=yyt^.SizeArgumenting.LevelIn;
yyt^.SizeArgumenting.Nextion^.Designations.EnvIn:=yyt^.SizeArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.SizeArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.SizeArgumenting.MainEntryIn;
yyt^.SizeArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.SizeArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.SizeArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4493 "oberon.aecp" *)
                                                       
  yyt^.SizeArgumenting.valueRepr                     := V.SizeValue(yyt^.SizeArgumenting.argTypeRepr);
(* line 4048 "oberon.aecp" *)

  yyt^.SizeArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.SizeArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.SizeArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.SizeArgumenting.typeRepr
                                   , yyt^.SizeArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.SizeArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.SizeArgumenting.Nextion^.Designations.EntryPosition:=yyt^.SizeArgumenting.EntryPosition;
yyt^.SizeArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.SizeArgumenting.PrevEntryIn;
yyt^.SizeArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.SizeArgumenting.IsCallDesignatorIn;
yyt^.SizeArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.SizeArgumenting.ValDontCareIn;
yyt^.SizeArgumenting.Nextion^.Designations.TableIn:=yyt^.SizeArgumenting.TableIn;
yyt^.SizeArgumenting.Nextion^.Designations.ModuleIn:=yyt^.SizeArgumenting.ModuleIn;
yyVisit1 (yyt^.SizeArgumenting.Nextion);
yyt^.SizeArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.SizeArgumenting.EnvIn;
(* line 2946 "oberon.aecp" *)

  yyt^.SizeArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.SizeArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.SizeArgumenting.LevelIn;
(* line 4461 "oberon.aecp" *)

  yyt^.SizeArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.SizeArgumenting.Op2Pos;
(* line 4460 "oberon.aecp" *)


  yyt^.SizeArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.SizeArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.SizeArgumenting.ValDontCareIn;
yyt^.SizeArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.SizeArgumenting.TableIn;
yyt^.SizeArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.SizeArgumenting.ModuleIn;
yyVisit1 (yyt^.SizeArgumenting.ExprLists);
yyt^.SizeArgumenting.Nextor^.Designors.EnvIn:=yyt^.SizeArgumenting.EnvIn;
yyt^.SizeArgumenting.Nextor^.Designors.LevelIn:=yyt^.SizeArgumenting.LevelIn;
yyVisit1 (yyt^.SizeArgumenting.Nextor);
(* line 4495 "oberon.aecp" *)
IF ~( T.IsNotOpenArrayType(yyt^.SizeArgumenting.argTypeRepr)
  ) THEN  ERR.MsgPos(ERR.MsgIllegalOpenArray,yyt^.SizeArgumenting.Qualidents^.Qualidents.Position)
 END;
(* line 4463 "oberon.aecp" *)
IF ~( TT.IsNotEmptyQualident(yyt^.SizeArgumenting.Qualidents)                                                        
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.SizeArgumenting.Op2Pos)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.SizeArgumenting.MainEntryOut             := yyt^.SizeArgumenting.Nextion^.Designations.MainEntryOut;
yyt^.SizeArgumenting.TempOfsOut:=yyt^.SizeArgumenting.ExprLists^.ExprLists.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.SizeArgumenting.ExprListOut                   := yyt^.SizeArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.SizeArgumenting.SignatureReprOut              := yyt^.SizeArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.SizeArgumenting.IsWritableOut                 := yyt^.SizeArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.SizeArgumenting.ValueReprOut                  := yyt^.SizeArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.SizeArgumenting.TypeReprOut                   := yyt^.SizeArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.SizeArgumenting.EntryOut                      := yyt^.SizeArgumenting.Nextion^.Designations.EntryOut;
| Tree.SysValArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.SysValArgumenting.Entry                         := OB.cmtObject;
yyt^.SysValArgumenting.Expr^.Exprs.EnvIn:=yyt^.SysValArgumenting.EnvIn;
(* line 2950 "oberon.aecp" *)

  yyt^.SysValArgumenting.Expr^.Exprs.TempOfsIn                := yyt^.SysValArgumenting.TempOfsIn;
yyt^.SysValArgumenting.Expr^.Exprs.LevelIn:=yyt^.SysValArgumenting.LevelIn;
yyt^.SysValArgumenting.Expr^.Exprs.ValDontCareIn:=yyt^.SysValArgumenting.ValDontCareIn;
yyt^.SysValArgumenting.Expr^.Exprs.TableIn:=yyt^.SysValArgumenting.TableIn;
yyt^.SysValArgumenting.Expr^.Exprs.ModuleIn:=yyt^.SysValArgumenting.ModuleIn;
yyVisit1 (yyt^.SysValArgumenting.Expr);
yyt^.SysValArgumenting.ExprLists^.ExprLists.EnvIn:=yyt^.SysValArgumenting.EnvIn;
(* line 2946 "oberon.aecp" *)

  yyt^.SysValArgumenting.ExprLists^.ExprLists.TempOfsIn           := 0;
yyt^.SysValArgumenting.ExprLists^.ExprLists.LevelIn:=yyt^.SysValArgumenting.LevelIn;
(* line 4506 "oberon.aecp" *)

  yyt^.SysValArgumenting.ExprLists^.ExprLists.ClosingPosIn        := yyt^.SysValArgumenting.Op2Pos;
(* line 4505 "oberon.aecp" *)
 

  yyt^.SysValArgumenting.ExprLists^.ExprLists.SignatureIn         := OB.cmtSignature;
yyt^.SysValArgumenting.ExprLists^.ExprLists.ValDontCareIn:=yyt^.SysValArgumenting.ValDontCareIn;
yyt^.SysValArgumenting.ExprLists^.ExprLists.TableIn:=yyt^.SysValArgumenting.TableIn;
yyt^.SysValArgumenting.ExprLists^.ExprLists.ModuleIn:=yyt^.SysValArgumenting.ModuleIn;
yyVisit1 (yyt^.SysValArgumenting.ExprLists);
yyt^.SysValArgumenting.Qualidents^.Qualidents.TableIn:=yyt^.SysValArgumenting.TableIn;
yyt^.SysValArgumenting.Qualidents^.Qualidents.ModuleIn:=yyt^.SysValArgumenting.ModuleIn;
yyVisit1 (yyt^.SysValArgumenting.Qualidents);
(* line 4458 "oberon.aecp" *)

  yyt^.SysValArgumenting.argTypeRepr                   := E.TypeOfTypeEntry(yyt^.SysValArgumenting.Qualidents^.Qualidents.EntryOut);
(* line 4503 "oberon.aecp" *)
                                                                  
  yyt^.SysValArgumenting.TypeTypeRepr                  := yyt^.SysValArgumenting.argTypeRepr;
(* line 2952 "oberon.aecp" *)
 

  yyt^.SysValArgumenting.TempAddr                      := yyt^.SysValArgumenting.Expr^.Exprs.TempOfsOut
                                 - ADR.Align4(ADR.MaxSize3(T.SizeOfType(yyt^.SysValArgumenting.TypeTypeRepr)
                                                              ,T.SizeOfType(yyt^.SysValArgumenting.Expr^.Exprs.TypeReprOut)
                                                              ,1+V.LengthOfString(yyt^.SysValArgumenting.Expr^.Exprs.ValueReprOut)
                                                              )
                                               );
(* line 4466 "oberon.aecp" *)
IF ~( E.IsTypeEntry(yyt^.SysValArgumenting.Qualidents^.Qualidents.EntryOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysValArgumenting.Qualidents^.Qualidents.Position)
 END;
(* line 4502 "oberon.aecp" *)

  yyt^.SysValArgumenting.typeRepr                      := yyt^.SysValArgumenting.argTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.SysValArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.SysValArgumenting.EntryIn
                                   , yyt^.SysValArgumenting.typeRepr
                                   , yyt^.SysValArgumenting.Nextor
                                   , yyt^.SysValArgumenting.Nextor);
yyt^.SysValArgumenting.Nextion^.Designations.EnvIn:=yyt^.SysValArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.SysValArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.SysValArgumenting.MainEntryIn;
yyt^.SysValArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.SysValArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.SysValArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.SysValArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.SysValArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.SysValArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.SysValArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.SysValArgumenting.typeRepr
                                   , yyt^.SysValArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.SysValArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.SysValArgumenting.Nextion^.Designations.EntryPosition:=yyt^.SysValArgumenting.EntryPosition;
yyt^.SysValArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.SysValArgumenting.PrevEntryIn;
yyt^.SysValArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.SysValArgumenting.IsCallDesignatorIn;
yyt^.SysValArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.SysValArgumenting.ValDontCareIn;
yyt^.SysValArgumenting.Nextion^.Designations.TableIn:=yyt^.SysValArgumenting.TableIn;
yyt^.SysValArgumenting.Nextion^.Designations.ModuleIn:=yyt^.SysValArgumenting.ModuleIn;
yyt^.SysValArgumenting.Nextion^.Designations.LevelIn:=yyt^.SysValArgumenting.LevelIn;
yyVisit1 (yyt^.SysValArgumenting.Nextion);
yyt^.SysValArgumenting.Nextor^.Designors.EnvIn:=yyt^.SysValArgumenting.EnvIn;
yyt^.SysValArgumenting.Nextor^.Designors.LevelIn:=yyt^.SysValArgumenting.LevelIn;
yyVisit1 (yyt^.SysValArgumenting.Nextor);
(* line 4512 "oberon.aecp" *)
IF ~( ~TT.IsEmptyExpr(yyt^.SysValArgumenting.Expr)                                                                     
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.SysValArgumenting.Op2Pos)
 END;
(* line 4463 "oberon.aecp" *)
IF ~( TT.IsNotEmptyQualident(yyt^.SysValArgumenting.Qualidents)                                                        
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.SysValArgumenting.Op2Pos)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.SysValArgumenting.MainEntryOut             := yyt^.SysValArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2959 "oberon.aecp" *)
 

  yyt^.SysValArgumenting.TempOfsOut                    := yyt^.SysValArgumenting.TempAddr;
(* line 2265 "oberon.aecp" *)
 
  yyt^.SysValArgumenting.ExprListOut                   := yyt^.SysValArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.SysValArgumenting.SignatureReprOut              := yyt^.SysValArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 4509 "oberon.aecp" *)

  yyt^.SysValArgumenting.IsWritableOut                 := ~E.IsExternEntry(yyt^.SysValArgumenting.Expr^.Exprs.EntryOut,yyt^.SysValArgumenting.ModuleIn)                           
                                OR  E.IsWritableEntry(yyt^.SysValArgumenting.Expr^.Exprs.EntryOut);
(* line 2262 "oberon.aecp" *)

  yyt^.SysValArgumenting.ValueReprOut                  := yyt^.SysValArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.SysValArgumenting.TypeReprOut                   := yyt^.SysValArgumenting.Nextion^.Designations.TypeReprOut;
(* line 4508 "oberon.aecp" *)


  yyt^.SysValArgumenting.EntryOut                      := yyt^.SysValArgumenting.Expr^.Exprs.EntryOut;
| Tree.NewArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.NewArgumenting.Entry                         := OB.cmtObject;
yyt^.NewArgumenting.Expr^.Exprs.EnvIn:=yyt^.NewArgumenting.EnvIn;
(* line 2963 "oberon.aecp" *)

  yyt^.NewArgumenting.Expr^.Exprs.TempOfsIn                := yyt^.NewArgumenting.TempOfsIn;
yyt^.NewArgumenting.Expr^.Exprs.LevelIn:=yyt^.NewArgumenting.LevelIn;
yyt^.NewArgumenting.Expr^.Exprs.ValDontCareIn:=yyt^.NewArgumenting.ValDontCareIn;
yyt^.NewArgumenting.Expr^.Exprs.TableIn:=yyt^.NewArgumenting.TableIn;
yyt^.NewArgumenting.Expr^.Exprs.ModuleIn:=yyt^.NewArgumenting.ModuleIn;
yyVisit1 (yyt^.NewArgumenting.Expr);
(* line 4525 "oberon.aecp" *)
IF ~( yyt^.NewArgumenting.Expr^.Exprs.IsLValueOut
  ) THEN  ERR.MsgPos(ERR.MsgLValueExpected,yyt^.NewArgumenting.Expr^.Exprs.Position)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.NewArgumenting.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.NewArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.NewArgumenting.EntryIn
                                   , yyt^.NewArgumenting.typeRepr
                                   , yyt^.NewArgumenting.Nextor
                                   , yyt^.NewArgumenting.Nextor);
yyt^.NewArgumenting.Nextion^.Designations.LevelIn:=yyt^.NewArgumenting.LevelIn;
yyt^.NewArgumenting.Nextion^.Designations.EnvIn:=yyt^.NewArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.NewArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.NewArgumenting.MainEntryIn;
yyt^.NewArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.NewArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.NewArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.NewArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.NewArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.NewArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.NewArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.NewArgumenting.typeRepr
                                   , yyt^.NewArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.NewArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.NewArgumenting.Nextion^.Designations.EntryPosition:=yyt^.NewArgumenting.EntryPosition;
yyt^.NewArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.NewArgumenting.PrevEntryIn;
yyt^.NewArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.NewArgumenting.IsCallDesignatorIn;
yyt^.NewArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.NewArgumenting.ValDontCareIn;
yyt^.NewArgumenting.Nextion^.Designations.TableIn:=yyt^.NewArgumenting.TableIn;
yyt^.NewArgumenting.Nextion^.Designations.ModuleIn:=yyt^.NewArgumenting.ModuleIn;
yyVisit1 (yyt^.NewArgumenting.Nextion);
(* line 4520 "oberon.aecp" *)

  yyt^.NewArgumenting.NewExprLists^.NewExprLists.ClosingPosIn     := yyt^.NewArgumenting.Op2Pos;
(* line 4519 "oberon.aecp" *)

  yyt^.NewArgumenting.NewExprLists^.NewExprLists.TypeReprIn       := T.BaseTypeOfPointerType(yyt^.NewArgumenting.Expr^.Exprs.TypeReprOut);
yyt^.NewArgumenting.NewExprLists^.NewExprLists.EnvIn:=yyt^.NewArgumenting.EnvIn;
(* line 2964 "oberon.aecp" *)
 
  yyt^.NewArgumenting.NewExprLists^.NewExprLists.TempOfsIn        := yyt^.NewArgumenting.TempOfsIn;
yyt^.NewArgumenting.NewExprLists^.NewExprLists.LevelIn:=yyt^.NewArgumenting.LevelIn;
yyt^.NewArgumenting.NewExprLists^.NewExprLists.ValDontCareIn:=yyt^.NewArgumenting.ValDontCareIn;
yyt^.NewArgumenting.NewExprLists^.NewExprLists.TableIn:=yyt^.NewArgumenting.TableIn;
yyt^.NewArgumenting.NewExprLists^.NewExprLists.ModuleIn:=yyt^.NewArgumenting.ModuleIn;
yyVisit1 (yyt^.NewArgumenting.NewExprLists);
yyt^.NewArgumenting.Nextor^.Designors.EnvIn:=yyt^.NewArgumenting.EnvIn;
yyt^.NewArgumenting.Nextor^.Designors.LevelIn:=yyt^.NewArgumenting.LevelIn;
yyVisit1 (yyt^.NewArgumenting.Nextor);
 E.SetLaccess(yyt^.NewArgumenting.Expr^.Exprs.MainEntryOut      );
(* line 4522 "oberon.aecp" *)
IF ~( T.IsPointerType(yyt^.NewArgumenting.Expr^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.NewArgumenting.Expr^.Exprs.Position)
 END;
(* line 3194 "oberon.aecp" *)

                                                          yyt^.NewArgumenting.MainEntryOut             := yyt^.NewArgumenting.Nextion^.Designations.MainEntryOut;
(* line 2966 "oberon.aecp" *)
 

  yyt^.NewArgumenting.TempOfsOut                    := ADR.MinSize2(yyt^.NewArgumenting.Expr^.Exprs.TempOfsOut,yyt^.NewArgumenting.NewExprLists^.NewExprLists.TempOfsOut);
(* line 2265 "oberon.aecp" *)
 
  yyt^.NewArgumenting.ExprListOut                   := yyt^.NewArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.NewArgumenting.SignatureReprOut              := yyt^.NewArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.NewArgumenting.IsWritableOut                 := yyt^.NewArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.NewArgumenting.ValueReprOut                  := yyt^.NewArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.NewArgumenting.TypeReprOut                   := yyt^.NewArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.NewArgumenting.EntryOut                      := yyt^.NewArgumenting.Nextion^.Designations.EntryOut;
| Tree.SysAsmArgumenting:
(* line 2250 "oberon.aecp" *)

  yyt^.SysAsmArgumenting.Entry                         := OB.cmtObject;
(* line 4564 "oberon.aecp" *)
IF ~( ~TT.IsEmptyExprList(yyt^.SysAsmArgumenting.SysAsmExprLists)
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.SysAsmArgumenting.Op2Pos)
 END;
(* line 4035 "oberon.aecp" *)

  yyt^.SysAsmArgumenting.typeRepr                      := OB.cmtTypeRepr;
(* line 4038 "oberon.aecp" *)


  yyt^.SysAsmArgumenting.Nextion                       := TT.DesignorToDesignation
                                   ( yyt^.SysAsmArgumenting.EntryIn
                                   , yyt^.SysAsmArgumenting.typeRepr
                                   , yyt^.SysAsmArgumenting.Nextor
                                   , yyt^.SysAsmArgumenting.Nextor);
yyt^.SysAsmArgumenting.Nextion^.Designations.LevelIn:=yyt^.SysAsmArgumenting.LevelIn;
yyt^.SysAsmArgumenting.Nextion^.Designations.EnvIn:=yyt^.SysAsmArgumenting.EnvIn;
(* line 3193 "oberon.aecp" *)
 yyt^.SysAsmArgumenting.Nextion^.Designations.MainEntryIn      := yyt^.SysAsmArgumenting.MainEntryIn;
yyt^.SysAsmArgumenting.Nextion^.Designations.TempOfsIn:=yyt^.SysAsmArgumenting.TempOfsIn;
(* line 4049 "oberon.aecp" *)

  yyt^.SysAsmArgumenting.Nextion^.Designations.IsWritableIn          := FALSE;
(* line 4036 "oberon.aecp" *)

  yyt^.SysAsmArgumenting.valueRepr                     := OB.cmtValue;
(* line 4048 "oberon.aecp" *)

  yyt^.SysAsmArgumenting.Nextion^.Designations.ValueReprIn           := yyt^.SysAsmArgumenting.valueRepr;
(* line 4045 "oberon.aecp" *)

  yyt^.SysAsmArgumenting.Nextion^.Designations.TypeReprIn            := T.ConstTypeCorrection                                               
                                   ( yyt^.SysAsmArgumenting.typeRepr
                                   , yyt^.SysAsmArgumenting.valueRepr);
(* line 4044 "oberon.aecp" *)


  yyt^.SysAsmArgumenting.Nextion^.Designations.EntryIn               := OB.cmtEntry;
yyt^.SysAsmArgumenting.Nextion^.Designations.EntryPosition:=yyt^.SysAsmArgumenting.EntryPosition;
yyt^.SysAsmArgumenting.Nextion^.Designations.PrevEntryIn:=yyt^.SysAsmArgumenting.PrevEntryIn;
yyt^.SysAsmArgumenting.Nextion^.Designations.IsCallDesignatorIn:=yyt^.SysAsmArgumenting.IsCallDesignatorIn;
yyt^.SysAsmArgumenting.Nextion^.Designations.ValDontCareIn:=yyt^.SysAsmArgumenting.ValDontCareIn;
yyt^.SysAsmArgumenting.Nextion^.Designations.TableIn:=yyt^.SysAsmArgumenting.TableIn;
yyt^.SysAsmArgumenting.Nextion^.Designations.ModuleIn:=yyt^.SysAsmArgumenting.ModuleIn;
yyVisit1 (yyt^.SysAsmArgumenting.Nextion);
yyt^.SysAsmArgumenting.SysAsmExprLists^.SysAsmExprLists.EnvIn:=yyt^.SysAsmArgumenting.EnvIn;
yyt^.SysAsmArgumenting.SysAsmExprLists^.SysAsmExprLists.LevelIn:=yyt^.SysAsmArgumenting.LevelIn;
yyt^.SysAsmArgumenting.SysAsmExprLists^.SysAsmExprLists.ValDontCareIn:=yyt^.SysAsmArgumenting.ValDontCareIn;
yyt^.SysAsmArgumenting.SysAsmExprLists^.SysAsmExprLists.TableIn:=yyt^.SysAsmArgumenting.TableIn;
yyt^.SysAsmArgumenting.SysAsmExprLists^.SysAsmExprLists.ModuleIn:=yyt^.SysAsmArgumenting.ModuleIn;
yyVisit1 (yyt^.SysAsmArgumenting.SysAsmExprLists);
yyt^.SysAsmArgumenting.Nextor^.Designors.EnvIn:=yyt^.SysAsmArgumenting.EnvIn;
yyt^.SysAsmArgumenting.Nextor^.Designors.LevelIn:=yyt^.SysAsmArgumenting.LevelIn;
yyVisit1 (yyt^.SysAsmArgumenting.Nextor);
(* line 3194 "oberon.aecp" *)

                                                          yyt^.SysAsmArgumenting.MainEntryOut             := yyt^.SysAsmArgumenting.Nextion^.Designations.MainEntryOut;
yyt^.SysAsmArgumenting.TempOfsOut:=yyt^.SysAsmArgumenting.Nextion^.Designations.TempOfsOut;
(* line 2265 "oberon.aecp" *)
 
  yyt^.SysAsmArgumenting.ExprListOut                   := yyt^.SysAsmArgumenting.Nextion^.Designations.ExprListOut;
(* line 2264 "oberon.aecp" *)

  yyt^.SysAsmArgumenting.SignatureReprOut              := yyt^.SysAsmArgumenting.Nextion^.Designations.SignatureReprOut;
(* line 2263 "oberon.aecp" *)

  yyt^.SysAsmArgumenting.IsWritableOut                 := yyt^.SysAsmArgumenting.Nextion^.Designations.IsWritableOut;
(* line 2262 "oberon.aecp" *)

  yyt^.SysAsmArgumenting.ValueReprOut                  := yyt^.SysAsmArgumenting.Nextion^.Designations.ValueReprOut;
(* line 2261 "oberon.aecp" *)

  yyt^.SysAsmArgumenting.TypeReprOut                   := yyt^.SysAsmArgumenting.Nextion^.Designations.TypeReprOut;
(* line 2260 "oberon.aecp" *)


  yyt^.SysAsmArgumenting.EntryOut                      := yyt^.SysAsmArgumenting.Nextion^.Designations.EntryOut;
| Tree.ExprLists:
yyt^.ExprLists.TempOfsOut:=yyt^.ExprLists.TempOfsIn;
| Tree.mtExprList:
(* line 3987 "oberon.aecp" *)
IF ~( SI.IsEmptySignature(yyt^.mtExprList.SignatureIn)                                                          
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.mtExprList.ClosingPosIn)
 END;
yyt^.mtExprList.TempOfsOut:=yyt^.mtExprList.TempOfsIn;
| Tree.ExprList:
yyt^.ExprList.Expr^.Exprs.ModuleIn:=yyt^.ExprList.ModuleIn;
yyt^.ExprList.Expr^.Exprs.EnvIn:=yyt^.ExprList.EnvIn;
(* line 2970 "oberon.aecp" *)

  yyt^.ExprList.Expr^.Exprs.TempOfsIn                := yyt^.ExprList.TempOfsIn;
yyt^.ExprList.Expr^.Exprs.LevelIn:=yyt^.ExprList.LevelIn;
yyt^.ExprList.Expr^.Exprs.ValDontCareIn:=yyt^.ExprList.ValDontCareIn;
yyt^.ExprList.Expr^.Exprs.TableIn:=yyt^.ExprList.TableIn;
yyVisit1 (yyt^.ExprList.Expr);
(* line 2456 "oberon.aecp" *)

  yyt^.ExprList.parMode                       := SI.ModeOfSignatureParam(yyt^.ExprList.SignatureIn);
(* line 4004 "oberon.aecp" *)


  yyt^.ExprList.IsLValueOK:=(yyt^.ExprList.parMode#OB.REFPAR) OR yyt^.ExprList.Expr^.Exprs.IsLValueOut;
(* line 4008 "oberon.aecp" *)
IF ~( ~yyt^.ExprList.IsLValueOK
     OR (yyt^.ExprList.parMode#OB.REFPAR)                                                                           
     OR yyt^.ExprList.Expr^.Exprs.IsWritableOut
  ) THEN  ERR.MsgPos(ERR.MsgIllegalROVarPar,yyt^.ExprList.Expr^.Exprs.Position)
 END;
(* line 2457 "oberon.aecp" *)

  yyt^.ExprList.formalTypeRepr                := SI.TypeOfSignatureParam(yyt^.ExprList.SignatureIn);
(* line 2459 "oberon.aecp" *)


  yyt^.ExprList.Coerce                        := CO.GetCoercion
                                   ( yyt^.ExprList.Expr^.Exprs.TypeReprOut
                                   , yyt^.ExprList.formalTypeRepr);
yyt^.ExprList.Next^.ExprLists.EnvIn:=yyt^.ExprList.EnvIn;
(* line 2971 "oberon.aecp" *)
 
  yyt^.ExprList.Next^.ExprLists.TempOfsIn                := yyt^.ExprList.TempOfsIn;
yyt^.ExprList.Next^.ExprLists.LevelIn:=yyt^.ExprList.LevelIn;
yyt^.ExprList.Next^.ExprLists.ClosingPosIn:=yyt^.ExprList.ClosingPosIn;
(* line 2463 "oberon.aecp" *)


  yyt^.ExprList.Next^.ExprLists.SignatureIn              := SI.NextSignature(yyt^.ExprList.SignatureIn);
yyt^.ExprList.Next^.ExprLists.ValDontCareIn:=yyt^.ExprList.ValDontCareIn;
yyt^.ExprList.Next^.ExprLists.TableIn:=yyt^.ExprList.TableIn;
yyt^.ExprList.Next^.ExprLists.ModuleIn:=yyt^.ExprList.ModuleIn;
yyVisit1 (yyt^.ExprList.Next);
 CO.DoRealCoercion(yyt^.ExprList.Coerce,yyt^.ExprList.Expr^.Exprs.ValueReprOut,yyt^.ExprList.Expr^.Exprs.TypeReprOut);
 V.AdjustNilValue(yyt^.ExprList.Expr^.Exprs.ValueReprOut ,yyt^.ExprList.formalTypeRepr   ,yyt^.ExprList.Expr^.Exprs.ValueReprOut );
 IF yyt^.ExprList.parMode=OB.REFPAR THEN 
                                  E.SetLaccess(yyt^.ExprList.Expr^.Exprs.MainEntryOut);
                               END; ;
(* line 3994 "oberon.aecp" *)
IF ~( SI.IsExistingSignature(yyt^.ExprList.SignatureIn)                                                       
  ) THEN  ERR.MsgPos(ERR.MsgTooManyParams,yyt^.ExprList.Expr^.Exprs.Position)
 END;
(* line 3997 "oberon.aecp" *)
IF ~( SI.IsCompatibleParam                                                                              
        ( yyt^.ExprList.parMode
        , yyt^.ExprList.formalTypeRepr
        , yyt^.ExprList.Expr^.Exprs.TypeReprOut
        , yyt^.ExprList.Expr^.Exprs.ValueReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.ExprList.Expr^.Exprs.Position)
 END;
(* line 4005 "oberon.aecp" *)
IF ~( yyt^.ExprList.IsLValueOK
  ) THEN  ERR.MsgPos(ERR.MsgLValueExpected,yyt^.ExprList.Expr^.Exprs.Position)
 END;
(* line 2973 "oberon.aecp" *)
 

  yyt^.ExprList.TempOfsOut                    := ADR.MinSize2(yyt^.ExprList.Expr^.Exprs.TempOfsOut,yyt^.ExprList.Next^.ExprLists.TempOfsOut);
| Tree.NewExprLists:
yyt^.NewExprLists.TempOfsOut:=yyt^.NewExprLists.TempOfsIn;
| Tree.mtNewExprList:
(* line 4538 "oberon.aecp" *)
IF ~( T.IsNotOpenArrayType(yyt^.mtNewExprList.TypeReprIn)                                                          
  ) THEN  ERR.MsgPos(ERR.MsgTooFewParams,yyt^.mtNewExprList.ClosingPosIn)
 END;
yyt^.mtNewExprList.TempOfsOut:=yyt^.mtNewExprList.TempOfsIn;
| Tree.NewExprList:
yyt^.NewExprList.Expr^.Exprs.ModuleIn:=yyt^.NewExprList.ModuleIn;
yyt^.NewExprList.Expr^.Exprs.EnvIn:=yyt^.NewExprList.EnvIn;
(* line 2977 "oberon.aecp" *)

  yyt^.NewExprList.Expr^.Exprs.TempOfsIn                := yyt^.NewExprList.TempOfsIn;
yyt^.NewExprList.Expr^.Exprs.LevelIn:=yyt^.NewExprList.LevelIn;
yyt^.NewExprList.Expr^.Exprs.ValDontCareIn:=yyt^.NewExprList.ValDontCareIn;
yyt^.NewExprList.Expr^.Exprs.TableIn:=yyt^.NewExprList.TableIn;
yyVisit1 (yyt^.NewExprList.Expr);
(* line 4557 "oberon.aecp" *)
IF ~( V.IsGreaterZeroInteger(yyt^.NewExprList.Expr^.Exprs.ValueReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgInvalidArrayLen,yyt^.NewExprList.Expr^.Exprs.Position)
 END;
(* line 4545 "oberon.aecp" *)

  yyt^.NewExprList.Coerce                        := CO.GetCoercion
                                   ( yyt^.NewExprList.Expr^.Exprs.TypeReprOut
                                   , OB.cLongintTypeRepr);
yyt^.NewExprList.Next^.NewExprLists.ClosingPosIn:=yyt^.NewExprList.ClosingPosIn;
(* line 4549 "oberon.aecp" *)


  yyt^.NewExprList.Next^.NewExprLists.TypeReprIn               := T.TypeOpenIndexed(yyt^.NewExprList.TypeReprIn);
yyt^.NewExprList.Next^.NewExprLists.EnvIn:=yyt^.NewExprList.EnvIn;
(* line 2978 "oberon.aecp" *)
 
  yyt^.NewExprList.Next^.NewExprLists.TempOfsIn                := yyt^.NewExprList.TempOfsIn;
yyt^.NewExprList.Next^.NewExprLists.LevelIn:=yyt^.NewExprList.LevelIn;
yyt^.NewExprList.Next^.NewExprLists.ValDontCareIn:=yyt^.NewExprList.ValDontCareIn;
yyt^.NewExprList.Next^.NewExprLists.TableIn:=yyt^.NewExprList.TableIn;
yyt^.NewExprList.Next^.NewExprLists.ModuleIn:=yyt^.NewExprList.ModuleIn;
yyVisit1 (yyt^.NewExprList.Next);
(* line 4551 "oberon.aecp" *)
IF ~( T.IsOpenArrayType(yyt^.NewExprList.TypeReprIn)                                                             
  ) THEN  ERR.MsgPos(ERR.MsgTooManyParams,yyt^.NewExprList.Expr^.Exprs.Position)
 END;
(* line 4554 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.NewExprList.Expr^.Exprs.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.NewExprList.Expr^.Exprs.Position)
 END;
(* line 2980 "oberon.aecp" *)
 

  yyt^.NewExprList.TempOfsOut                    := ADR.MinSize2(yyt^.NewExprList.Expr^.Exprs.TempOfsOut,yyt^.NewExprList.Next^.NewExprLists.TempOfsOut);
| Tree.SysAsmExprLists:
| Tree.mtSysAsmExprList:
| Tree.SysAsmExprList:
yyt^.SysAsmExprList.Expr^.Exprs.ModuleIn:=yyt^.SysAsmExprList.ModuleIn;
yyt^.SysAsmExprList.Expr^.Exprs.EnvIn:=yyt^.SysAsmExprList.EnvIn;
(* line 2984 "oberon.aecp" *)

  yyt^.SysAsmExprList.Expr^.Exprs.TempOfsIn                := 0;
yyt^.SysAsmExprList.Expr^.Exprs.LevelIn:=yyt^.SysAsmExprList.LevelIn;
yyt^.SysAsmExprList.Expr^.Exprs.ValDontCareIn:=yyt^.SysAsmExprList.ValDontCareIn;
yyt^.SysAsmExprList.Expr^.Exprs.TableIn:=yyt^.SysAsmExprList.TableIn;
yyVisit1 (yyt^.SysAsmExprList.Expr);
(* line 4571 "oberon.aecp" *)
IF ~( V.IsStringValue(yyt^.SysAsmExprList.Expr^.Exprs.ValueReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgParmNotCompatible,yyt^.SysAsmExprList.Expr^.Exprs.Position)
 END;
yyt^.SysAsmExprList.Next^.SysAsmExprLists.EnvIn:=yyt^.SysAsmExprList.EnvIn;
yyt^.SysAsmExprList.Next^.SysAsmExprLists.LevelIn:=yyt^.SysAsmExprList.LevelIn;
yyt^.SysAsmExprList.Next^.SysAsmExprLists.ValDontCareIn:=yyt^.SysAsmExprList.ValDontCareIn;
yyt^.SysAsmExprList.Next^.SysAsmExprLists.TableIn:=yyt^.SysAsmExprList.TableIn;
yyt^.SysAsmExprList.Next^.SysAsmExprLists.ModuleIn:=yyt^.SysAsmExprList.ModuleIn;
yyVisit1 (yyt^.SysAsmExprList.Next);
  ELSE
  END;
 END yyVisit1;

PROCEDURE yyVisit2 (yyt: Tree.tTree);
 BEGIN
  CASE yyt^.Kind OF
| Tree.ParIds:
yyt^.ParIds.ParAddrOut:=yyt^.ParIds.ParAddrIn;
yyt^.ParIds.Table2Out:=yyt^.ParIds.Table2In;
| Tree.mtParId:
yyt^.mtParId.ParAddrOut:=yyt^.mtParId.ParAddrIn;
yyt^.mtParId.Table2Out:=yyt^.mtParId.Table2In;
| Tree.ParId:
(* line 2661 "oberon.aecp" *)
 ADR.NextParAddr
                                     ( yyt^.ParId.ParModeIn
                                     , yyt^.ParId.TypeReprIn
                                     , yyt^.ParId.ParAddrIn
                                     , yyt^.ParId.AddrOfPar
                                     , yyt^.ParId.RefMode
                                     , yyt^.ParId.Next^.ParIds.ParAddrIn);
                                   
(* line 1263 "oberon.aecp" *)


  

  yyt^.ParId.Next^.ParIds.Table2In                 := E.DefineVarEntry
                                   ( yyt^.ParId.Table2In
                                   , yyt^.ParId.Next^.ParIds.Table1In
                                   , yyt^.ParId.LevelIn
                                   , yyt^.ParId.Ident
                                   , yyt^.ParId.TypeReprIn
                                   , yyt^.ParId.AddrOfPar
                                   , yyt^.ParId.RefMode);
yyt^.ParId.Next^.ParIds.TypeReprIn:=yyt^.ParId.TypeReprIn;
yyVisit2 (yyt^.ParId.Next);
(* line 2669 "oberon.aecp" *)

  yyt^.ParId.ParAddrOut                    := yyt^.ParId.Next^.ParIds.ParAddrOut;
(* line 1273 "oberon.aecp" *)


  yyt^.ParId.Table2Out                     := yyt^.ParId.Next^.ParIds.Table2Out;
| Tree.Type:
(* line 1335 "oberon.aecp" *)

  yyt^.Type.TypeReprOut                   := OB.cmtTypeRepr;
(* line 1334 "oberon.aecp" *)


  yyt^.Type.TableOut                      := yyt^.Type.TableIn;
| Tree.mtType:
(* line 1335 "oberon.aecp" *)

  yyt^.mtType.TypeReprOut                   := OB.cmtTypeRepr;
(* line 1334 "oberon.aecp" *)


  yyt^.mtType.TableOut                      := yyt^.mtType.TableIn;
| Tree.NamedType:
(* line 1341 "oberon.aecp" *)

  yyt^.NamedType.Qualidents^.Qualidents.TableIn            := yyt^.NamedType.TableIn;
yyt^.NamedType.Qualidents^.Qualidents.ModuleIn:=yyt^.NamedType.ModuleIn;
yyVisit1 (yyt^.NamedType.Qualidents);
(* line 1343 "oberon.aecp" *)


  yyt^.NamedType.TypeReprOut                   := E.TypeOfTypeEntry(yyt^.NamedType.Qualidents^.Qualidents.EntryOut);
(* line 3448 "oberon.aecp" *)
IF ~( yyt^.NamedType.OpenArrayIsOkIn                                                                                      
     OR T.IsNotOpenArrayType(yyt^.NamedType.TypeReprOut)
  ) THEN  ERR.MsgPos(ERR.MsgIllegalOpenArray,yyt^.NamedType.Qualidents^.Qualidents.Position)
 END;
(* line 3438 "oberon.aecp" *)
IF ~( E.IsTypeEntry(yyt^.NamedType.Qualidents^.Qualidents.EntryOut)                                                                       
  ) THEN  ERR.MsgPos(ERR.MsgTypeExpected,yyt^.NamedType.Qualidents^.Qualidents.Position)
 END;
(* line 3441 "oberon.aecp" *)
IF ~( yyt^.NamedType.IsVarParTypeIn                                                                                        

     OR E.IsNotToBeDeclared(yyt^.NamedType.Qualidents^.Qualidents.EntryOut)
  ) THEN  ERR.MsgPos(ERR.MsgIllegalRecursiveType,yyt^.NamedType.Qualidents^.Qualidents.Position)
 END;
(* line 1334 "oberon.aecp" *)


  yyt^.NamedType.TableOut                      := yyt^.NamedType.TableIn;
| Tree.ArrayType:
yyt^.ArrayType.ArrayExprLists^.ArrayExprLists.ModuleIn:=yyt^.ArrayType.ModuleIn;
yyVisit1 (yyt^.ArrayType.Type);
yyt^.ArrayType.Type^.Type.EnvIn:=yyt^.ArrayType.EnvIn;
yyt^.ArrayType.Type^.Type.TDescListIn:=yyt^.ArrayType.TDescListIn;
(* line 3133 "oberon.aecp" *)

  yyt^.ArrayType.Type^.Type.NamePathIn               := OB.mIndexNamePath(yyt^.ArrayType.NamePathIn);
yyt^.ArrayType.Type^.Type.LevelIn:=yyt^.ArrayType.LevelIn;
(* line 1361 "oberon.aecp" *)
                                                                    
  yyt^.ArrayType.Type^.Type.IsVarParTypeIn           := FALSE;
(* line 1360 "oberon.aecp" *)
                                                  
  yyt^.ArrayType.Type^.Type.OpenArrayIsOkIn          := FALSE;
(* line 1359 "oberon.aecp" *)

  yyt^.ArrayType.Type^.Type.ForwardPBaseIsOkIn       := FALSE;
(* line 1358 "oberon.aecp" *)


  yyt^.ArrayType.Type^.Type.TableIn                  := yyt^.ArrayType.TableIn;
yyt^.ArrayType.Type^.Type.ModuleIn:=yyt^.ArrayType.ModuleIn;
yyVisit2 (yyt^.ArrayType.Type);
yyt^.ArrayType.ArrayExprLists^.ArrayExprLists.EnvIn:=yyt^.ArrayType.EnvIn;
yyt^.ArrayType.ArrayExprLists^.ArrayExprLists.LevelIn:=yyt^.ArrayType.LevelIn;
(* line 1364 "oberon.aecp" *)

  yyt^.ArrayType.ArrayExprLists^.ArrayExprLists.ElemTypeReprIn := yyt^.ArrayType.Type^.Type.TypeReprOut;
(* line 1363 "oberon.aecp" *)
                                                                     

  yyt^.ArrayType.ArrayExprLists^.ArrayExprLists.TableIn        := yyt^.ArrayType.TableIn;
yyVisit1 (yyt^.ArrayType.ArrayExprLists);
(* line 1366 "oberon.aecp" *)


  yyt^.ArrayType.TypeReprOut                   := T.CopyArrayTypeRepr
                                   ( yyt^.ArrayType.FirstTypeReprOut
                                   , yyt^.ArrayType.ArrayExprLists^.ArrayExprLists.TypeReprOut);
(* line 1334 "oberon.aecp" *)


  yyt^.ArrayType.TableOut                      := yyt^.ArrayType.TableIn;
| Tree.OpenArrayType:
(* line 3456 "oberon.aecp" *)
IF ~( yyt^.OpenArrayType.OpenArrayIsOkIn                                                                                      
  ) THEN  ERR.MsgPos(ERR.MsgMissingArrayLength,yyt^.OpenArrayType.OfPosition)
 END;
yyVisit1 (yyt^.OpenArrayType.Type);
yyt^.OpenArrayType.Type^.Type.EnvIn:=yyt^.OpenArrayType.EnvIn;
yyt^.OpenArrayType.Type^.Type.TDescListIn:=yyt^.OpenArrayType.TDescListIn;
(* line 3137 "oberon.aecp" *)

  yyt^.OpenArrayType.Type^.Type.NamePathIn               := OB.mIndexNamePath(yyt^.OpenArrayType.NamePathIn);
yyt^.OpenArrayType.Type^.Type.LevelIn:=yyt^.OpenArrayType.LevelIn;
(* line 1385 "oberon.aecp" *)
                                                  
  yyt^.OpenArrayType.Type^.Type.IsVarParTypeIn           := FALSE;
yyt^.OpenArrayType.Type^.Type.OpenArrayIsOkIn:=yyt^.OpenArrayType.OpenArrayIsOkIn;
(* line 1384 "oberon.aecp" *)

  yyt^.OpenArrayType.Type^.Type.ForwardPBaseIsOkIn       := FALSE;
(* line 1383 "oberon.aecp" *)


  yyt^.OpenArrayType.Type^.Type.TableIn                  := yyt^.OpenArrayType.TableIn;
yyt^.OpenArrayType.Type^.Type.ModuleIn:=yyt^.OpenArrayType.ModuleIn;
yyVisit2 (yyt^.OpenArrayType.Type);
(* line 1387 "oberon.aecp" *)
                                                                     

  yyt^.OpenArrayType.TypeReprOut                   := T.CompleteOpenArrayTypeRepr
                                   ( yyt^.OpenArrayType.FirstTypeReprOut
                                   , yyt^.OpenArrayType.Type^.Type.TypeReprOut);
(* line 1334 "oberon.aecp" *)


  yyt^.OpenArrayType.TableOut                      := yyt^.OpenArrayType.TableIn;
| Tree.RecordType:
yyt^.RecordType.FieldLists^.FieldLists.ModuleIn:=yyt^.RecordType.ModuleIn;
yyt^.RecordType.FieldLists^.FieldLists.EnvIn:=yyt^.RecordType.EnvIn;
yyt^.RecordType.FieldLists^.FieldLists.TDescListIn:=yyt^.RecordType.TDescListIn;
(* line 3145 "oberon.aecp" *)

  yyt^.RecordType.FieldLists^.FieldLists.NamePathIn         := OB.mSelectNamePath(yyt^.RecordType.NamePathIn);
(* line 2695 "oberon.aecp" *)

  yyt^.RecordType.FieldLists^.FieldLists.SizeIn             := 0;
(* line 2564 "oberon.aecp" *)

  yyt^.RecordType.FieldLists^.FieldLists.LevelIn            := OB.FIELDLEVEL;
(* line 1493 "oberon.aecp" *)


  yyt^.RecordType.FieldLists^.FieldLists.FieldTableIn       := OB.mScopeEntry(yyt^.RecordType.TableIn);
yyVisit1 (yyt^.RecordType.FieldLists);
(* line 1495 "oberon.aecp" *)


  yyt^.RecordType.TypeReprOut                   := T.CompleteRecordTypeRepr
                                   ( yyt^.RecordType.FirstTypeReprOut
                                   , yyt^.RecordType.FieldLists^.FieldLists.SizeOut
                                   , OB.ROOTEXTLEVEL
                                   , OB.cmtObject
                                   , OB.cmtTypeReprList
                                   , yyt^.RecordType.FieldLists^.FieldLists.FieldTableOut);
(* line 1334 "oberon.aecp" *)


  yyt^.RecordType.TableOut                      := yyt^.RecordType.TableIn;
| Tree.ExtendedType:
(* line 1521 "oberon.aecp" *)


  yyt^.ExtendedType.Qualidents^.Qualidents.TableIn            := yyt^.ExtendedType.TableIn;
yyt^.ExtendedType.Qualidents^.Qualidents.ModuleIn:=yyt^.ExtendedType.ModuleIn;
yyVisit1 (yyt^.ExtendedType.Qualidents);
(* line 1523 "oberon.aecp" *)


  yyt^.ExtendedType.BaseTypeRepr                  := E.TypeOfTypeEntry(yyt^.ExtendedType.Qualidents^.Qualidents.EntryOut);
(* line 1529 "oberon.aecp" *)


  yyt^.ExtendedType.extLevel                      := 1+T.ExtLevelOfType(yyt^.ExtendedType.BaseTypeRepr);
(* line 3487 "oberon.aecp" *)
IF ~( (yyt^.ExtendedType.extLevel < LIM.MaxExtensionLevel)
  ) THEN  ERR.MsgPos(ERR.MsgMaxExtLevelReached,yyt^.ExtendedType.Qualidents^.Qualidents.Position)
 END;
yyt^.ExtendedType.FieldLists^.FieldLists.EnvIn:=yyt^.ExtendedType.EnvIn;
yyt^.ExtendedType.FieldLists^.FieldLists.TDescListIn:=yyt^.ExtendedType.TDescListIn;
yyt^.ExtendedType.FieldLists^.FieldLists.NamePathIn:=yyt^.ExtendedType.NamePathIn;
(* line 2699 "oberon.aecp" *)

  yyt^.ExtendedType.FieldLists^.FieldLists.SizeIn             := T.SizeOfType(yyt^.ExtendedType.BaseTypeRepr);
(* line 2568 "oberon.aecp" *)

  yyt^.ExtendedType.FieldLists^.FieldLists.LevelIn            := OB.FIELDLEVEL;
(* line 1525 "oberon.aecp" *)


  yyt^.ExtendedType.FieldLists^.FieldLists.FieldTableIn       := T.CloneRecordFields
                                   ( OB.mScopeEntry(yyt^.ExtendedType.TableIn)
                                   , yyt^.ExtendedType.BaseTypeRepr);
yyt^.ExtendedType.FieldLists^.FieldLists.ModuleIn:=yyt^.ExtendedType.ModuleIn;
yyVisit1 (yyt^.ExtendedType.FieldLists);
 T.AppendExtension(yyt^.ExtendedType.BaseTypeRepr,yyt^.ExtendedType.FirstTypeReprOut);
(* line 3481 "oberon.aecp" *)
IF ~( T.IsRecordType(yyt^.ExtendedType.BaseTypeRepr)                                                                     
  ) THEN  ERR.MsgPos(ERR.MsgRecordTypeExpected,yyt^.ExtendedType.Qualidents^.Qualidents.Position)
 END;
(* line 3484 "oberon.aecp" *)
IF ~( E.IsNotToBeDeclared(yyt^.ExtendedType.Qualidents^.Qualidents.EntryOut)               
  ) THEN  ERR.MsgPos(ERR.MsgIllegalRecursiveType,yyt^.ExtendedType.Qualidents^.Qualidents.Position)
 END;
(* line 1530 "oberon.aecp" *)
 
  yyt^.ExtendedType.TypeReprOut                   := T.CompleteRecordTypeRepr
                                   ( yyt^.ExtendedType.FirstTypeReprOut
                                   , yyt^.ExtendedType.FieldLists^.FieldLists.SizeOut
                                   , yyt^.ExtendedType.extLevel
                                   , yyt^.ExtendedType.BaseTypeRepr
                                   , OB.cmtTypeReprList
                                   , yyt^.ExtendedType.FieldLists^.FieldLists.FieldTableOut);
(* line 1334 "oberon.aecp" *)


  yyt^.ExtendedType.TableOut                      := yyt^.ExtendedType.TableIn;
| Tree.PointerType:
(* line 1406 "oberon.aecp" *)

  yyt^.PointerType.BaseTypePos                   := POS.NoPosition;
(* line 1405 "oberon.aecp" *)


  yyt^.PointerType.BaseTypeEntry                 := OB.cmtObject;
(* line 3466 "oberon.aecp" *)
IF ~( T.IsLegalPointerBaseType(E.TypeOfEntry(yyt^.PointerType.BaseTypeEntry))                                         
  ) THEN  ERR.MsgPos(ERR.MsgWrongPointerBase,yyt^.PointerType.BaseTypePos)
 END;
(* line 3463 "oberon.aecp" *)
IF ~( E.IsTypeEntry(yyt^.PointerType.BaseTypeEntry)                                                                          
  ) THEN  ERR.MsgPos(ERR.MsgTypeExpected,yyt^.PointerType.BaseTypePos)
 END;
(* line 1408 "oberon.aecp" *)


  yyt^.PointerType.TypeReprOut                   := T.CompletePointerTypeRepr
                                   ( yyt^.PointerType.FirstTypeReprOut
                                   , yyt^.PointerType.BaseTypeEntry);
(* line 1334 "oberon.aecp" *)


  yyt^.PointerType.TableOut                      := yyt^.PointerType.TableIn;
| Tree.PointerToIdType:
(* line 1426 "oberon.aecp" *)

  yyt^.PointerToIdType.BaseTypePos                   := yyt^.PointerToIdType.IdentPos;
(* line 1415 "oberon.aecp" *)
 yyt^.PointerToIdType.BaseTypeEntry               := E.ApplyPointerBaseIdent
                                   ( yyt^.PointerToIdType.ForwardPBaseIsOkIn
                                   , E.Lookup(yyt^.PointerToIdType.TableIn,yyt^.PointerToIdType.Ident)
                                   , yyt^.PointerToIdType.TableIn
                                   , yyt^.PointerToIdType.LevelIn
                                   , yyt^.PointerToIdType.ModuleIn
                                   , yyt^.PointerToIdType.Ident
                                   , yyt^.PointerToIdType.IdentPos
                                   , yyt^.PointerToIdType.TableOut);
  
(* line 3466 "oberon.aecp" *)
IF ~( T.IsLegalPointerBaseType(E.TypeOfEntry(yyt^.PointerToIdType.BaseTypeEntry))                                         
  ) THEN  ERR.MsgPos(ERR.MsgWrongPointerBase,yyt^.PointerToIdType.BaseTypePos)
 END;
(* line 3473 "oberon.aecp" *)
IF ~( yyt^.PointerToIdType.ForwardPBaseIsOkIn                                                                                      
     OR (E.DeclStatusOfEntry(yyt^.PointerToIdType.BaseTypeEntry)#OB.UNDECLARED)                                              
  ) THEN  ERR.MsgPos(ERR.MsgUndeclaredIdent,yyt^.PointerToIdType.IdentPos)
 END;
(* line 3463 "oberon.aecp" *)
IF ~( E.IsTypeEntry(yyt^.PointerToIdType.BaseTypeEntry)                                                                          
  ) THEN  ERR.MsgPos(ERR.MsgTypeExpected,yyt^.PointerToIdType.BaseTypePos)
 END;
(* line 1408 "oberon.aecp" *)


  yyt^.PointerToIdType.TypeReprOut                   := T.CompletePointerTypeRepr
                                   ( yyt^.PointerToIdType.FirstTypeReprOut
                                   , yyt^.PointerToIdType.BaseTypeEntry);
| Tree.PointerToQualIdType:
(* line 1431 "oberon.aecp" *)

  yyt^.PointerToQualIdType.Qualidents^.Qualidents.TableIn            := yyt^.PointerToQualIdType.TableIn;
yyt^.PointerToQualIdType.Qualidents^.Qualidents.ModuleIn:=yyt^.PointerToQualIdType.ModuleIn;
yyVisit1 (yyt^.PointerToQualIdType.Qualidents);
(* line 1434 "oberon.aecp" *)

  yyt^.PointerToQualIdType.BaseTypePos                   := yyt^.PointerToQualIdType.Qualidents^.Qualidents.Position;
(* line 1433 "oberon.aecp" *)


  yyt^.PointerToQualIdType.BaseTypeEntry                 := yyt^.PointerToQualIdType.Qualidents^.Qualidents.EntryOut;
(* line 3466 "oberon.aecp" *)
IF ~( T.IsLegalPointerBaseType(E.TypeOfEntry(yyt^.PointerToQualIdType.BaseTypeEntry))                                         
  ) THEN  ERR.MsgPos(ERR.MsgWrongPointerBase,yyt^.PointerToQualIdType.BaseTypePos)
 END;
(* line 3463 "oberon.aecp" *)
IF ~( E.IsTypeEntry(yyt^.PointerToQualIdType.BaseTypeEntry)                                                                          
  ) THEN  ERR.MsgPos(ERR.MsgTypeExpected,yyt^.PointerToQualIdType.BaseTypePos)
 END;
(* line 1408 "oberon.aecp" *)


  yyt^.PointerToQualIdType.TypeReprOut                   := T.CompletePointerTypeRepr
                                   ( yyt^.PointerToQualIdType.FirstTypeReprOut
                                   , yyt^.PointerToQualIdType.BaseTypeEntry);
(* line 1334 "oberon.aecp" *)


  yyt^.PointerToQualIdType.TableOut                      := yyt^.PointerToQualIdType.TableIn;
| Tree.PointerToStructType:
yyVisit1 (yyt^.PointerToStructType.Type);
yyt^.PointerToStructType.Type^.Type.EnvIn:=yyt^.PointerToStructType.EnvIn;
yyt^.PointerToStructType.Type^.Type.TDescListIn:=yyt^.PointerToStructType.TDescListIn;
(* line 3141 "oberon.aecp" *)

  yyt^.PointerToStructType.Type^.Type.NamePathIn               := OB.mDereferenceNamePath(yyt^.PointerToStructType.NamePathIn);
yyt^.PointerToStructType.Type^.Type.LevelIn:=yyt^.PointerToStructType.LevelIn;
(* line 1442 "oberon.aecp" *)
                                                                     
  yyt^.PointerToStructType.Type^.Type.IsVarParTypeIn           := FALSE;
(* line 1441 "oberon.aecp" *)
                                                  
  yyt^.PointerToStructType.Type^.Type.OpenArrayIsOkIn          := TRUE;
(* line 1440 "oberon.aecp" *)

  yyt^.PointerToStructType.Type^.Type.ForwardPBaseIsOkIn       := FALSE;
(* line 1439 "oberon.aecp" *)

  yyt^.PointerToStructType.Type^.Type.TableIn                  := yyt^.PointerToStructType.TableIn;
yyt^.PointerToStructType.Type^.Type.ModuleIn:=yyt^.PointerToStructType.ModuleIn;
yyVisit2 (yyt^.PointerToStructType.Type);
(* line 1452 "oberon.aecp" *)

  yyt^.PointerToStructType.BaseTypePos                   := yyt^.PointerToStructType.Type^.Type.Position;
(* line 1444 "oberon.aecp" *)
                                                                     

  yyt^.PointerToStructType.BaseTypeEntry                 := OB.mTypeEntry
                                   ( OB.cNonameEntry
                                   , yyt^.PointerToStructType.ModuleIn
                                   , Idents.NoIdent
                                   , OB.PRIVATE
                                   , yyt^.PointerToStructType.LevelIn
                                   , OB.DECLARED
                                   , yyt^.PointerToStructType.Type^.Type.TypeReprOut);
(* line 3466 "oberon.aecp" *)
IF ~( T.IsLegalPointerBaseType(E.TypeOfEntry(yyt^.PointerToStructType.BaseTypeEntry))                                         
  ) THEN  ERR.MsgPos(ERR.MsgWrongPointerBase,yyt^.PointerToStructType.BaseTypePos)
 END;
 T.AppendTDesc(yyt^.PointerToStructType.TDescListIn
                     ,yyt^.PointerToStructType.BaseTypeEntry
                     ,OB.mDereferenceNamePath(yyt^.PointerToStructType.NamePathIn));
(* line 3463 "oberon.aecp" *)
IF ~( E.IsTypeEntry(yyt^.PointerToStructType.BaseTypeEntry)                                                                          
  ) THEN  ERR.MsgPos(ERR.MsgTypeExpected,yyt^.PointerToStructType.BaseTypePos)
 END;
(* line 1408 "oberon.aecp" *)


  yyt^.PointerToStructType.TypeReprOut                   := T.CompletePointerTypeRepr
                                   ( yyt^.PointerToStructType.FirstTypeReprOut
                                   , yyt^.PointerToStructType.BaseTypeEntry);
(* line 1334 "oberon.aecp" *)


  yyt^.PointerToStructType.TableOut                      := yyt^.PointerToStructType.TableIn;
| Tree.ProcedureType:
yyt^.ProcedureType.FormalPars^.FormalPars.ModuleIn:=yyt^.ProcedureType.ModuleIn;
yyt^.ProcedureType.FormalPars^.FormalPars.EnvIn:=yyt^.ProcedureType.EnvIn;
yyt^.ProcedureType.FormalPars^.FormalPars.TDescListIn:=yyt^.ProcedureType.TDescListIn;
yyt^.ProcedureType.FormalPars^.FormalPars.NamePathIn:=yyt^.ProcedureType.NamePathIn;
(* line 2690 "oberon.aecp" *)

  yyt^.ProcedureType.FormalPars^.FormalPars.ParAddrIn          := ADR.ProcParBase;
yyt^.ProcedureType.FormalPars^.FormalPars.LevelIn:=yyt^.ProcedureType.LevelIn;
(* line 1468 "oberon.aecp" *)


  yyt^.ProcedureType.FormalPars^.FormalPars.TableIn            := OB.mScopeEntry(yyt^.ProcedureType.TableIn);
yyVisit1 (yyt^.ProcedureType.FormalPars);
(* line 2691 "oberon.aecp" *)

  yyt^.ProcedureType.paramSpace                    := yyt^.ProcedureType.FormalPars^.FormalPars.ParAddrOut-ADR.ProcParBase;
(* line 1470 "oberon.aecp" *)


  yyt^.ProcedureType.TypeReprOut                   := T.CompleteProcedureTypeRepr
                                   ( yyt^.ProcedureType.FirstTypeReprOut
                                   , yyt^.ProcedureType.FormalPars^.FormalPars.SignatureReprOut
                                   , yyt^.ProcedureType.FormalPars^.FormalPars.ResultTypeReprOut
                                   , yyt^.ProcedureType.paramSpace);
(* line 1334 "oberon.aecp" *)


  yyt^.ProcedureType.TableOut                      := yyt^.ProcedureType.TableIn;
| Tree.IdentLists:
yyt^.IdentLists.SizeOut:=yyt^.IdentLists.SizeIn;
yyt^.IdentLists.VarAddrOut:=yyt^.IdentLists.VarAddrIn;
yyt^.IdentLists.Table2Out:=yyt^.IdentLists.Table2In;
| Tree.mtIdentList:
yyt^.mtIdentList.SizeOut:=yyt^.mtIdentList.SizeIn;
yyt^.mtIdentList.VarAddrOut:=yyt^.mtIdentList.VarAddrIn;
yyt^.mtIdentList.Table2Out:=yyt^.mtIdentList.Table2In;
| Tree.IdentList:
(* line 2721 "oberon.aecp" *)

  yyt^.IdentList.ItemSize                      := T.SizeOfType(yyt^.IdentList.TypeReprIn);
(* line 2729 "oberon.aecp" *)

  yyt^.IdentList.Next^.IdentLists.SizeIn                   := OT.NewRecordTypeSize
                                   ( yyt^.IdentList.SizeIn
                                   , yyt^.IdentList.ItemSize);
(* line 3513 "oberon.aecp" *)
IF ~(  (yyt^.IdentList.Next^.IdentLists.SizeIn <= OT.MaxObjectSize)                                                                     
     OR ~(yyt^.IdentList.SizeIn      <= OT.MaxObjectSize)
  ) THEN  ERR.MsgPos(yyt^.IdentList.TooBigMsg,yyt^.IdentList.IdentDef^.IdentDef.Pos)
 END;
yyt^.IdentList.IdentDef^.IdentDef.LevelIn:=yyt^.IdentList.LevelIn;
yyVisit1 (yyt^.IdentList.IdentDef);
yyt^.IdentList.Next^.IdentLists.EnvIn:=yyt^.IdentList.EnvIn;
(* line 2722 "oberon.aecp" *)
 ADR.NextVarAddr
                                     ( yyt^.IdentList.LevelIn  
                                     , yyt^.IdentList.VarAddrIn
                                     , yyt^.IdentList.ItemSize
                                     , yyt^.IdentList.AddrOfVar
                                     , yyt^.IdentList.Next^.IdentLists.VarAddrIn);
                                   
yyt^.IdentList.Next^.IdentLists.TypeReprIn:=yyt^.IdentList.TypeReprIn;
(* line 1634 "oberon.aecp" *)


  
  yyt^.IdentList.Next^.IdentLists.Table2In                 := E.DefineVarEntry
                                   ( yyt^.IdentList.Table2In
                                   , yyt^.IdentList.Next^.IdentLists.Table1In
                                   , yyt^.IdentList.LevelIn
                                   , yyt^.IdentList.IdentDef^.IdentDef.Ident
                                   , yyt^.IdentList.TypeReprIn
                                   , yyt^.IdentList.AddrOfVar
                                   , OB.VALPAR);
yyt^.IdentList.Next^.IdentLists.TooBigMsg:=yyt^.IdentList.TooBigMsg;
yyVisit2 (yyt^.IdentList.Next);
(* line 1613 "oberon.aecp" *)

  
  yyt^.IdentList.AlreadyDeclaredEntry          := E.Lookup0(yyt^.IdentList.Table1In,yyt^.IdentList.IdentDef^.IdentDef.Ident);
(* line 3508 "oberon.aecp" *)
IF ~( E.IsErrorEntry(yyt^.IdentList.AlreadyDeclaredEntry)                                                             
     OR (  E.IsExternEntry(yyt^.IdentList.AlreadyDeclaredEntry,yyt^.IdentList.ModuleIn)                                                  
        & ~E.IsExportedEntry(yyt^.IdentList.AlreadyDeclaredEntry))
  ) THEN  ERR.MsgPos(ERR.MsgAlreadyDeclared,yyt^.IdentList.IdentDef^.IdentDef.Pos)
 END;
(* line 2734 "oberon.aecp" *)

  yyt^.IdentList.SizeOut                       := yyt^.IdentList.Next^.IdentLists.SizeOut;
(* line 2733 "oberon.aecp" *)


  yyt^.IdentList.VarAddrOut                    := yyt^.IdentList.Next^.IdentLists.VarAddrOut;
(* line 1643 "oberon.aecp" *)


  yyt^.IdentList.Table2Out                     := yyt^.IdentList.Next^.IdentLists.Table2Out;
| Tree.DyOperator:
(* line 2079 "oberon.aecp" *)


  yyt^.DyOperator.Coerce1                       := OB.cmtCoercion;
(* line 2080 "oberon.aecp" *)

  yyt^.DyOperator.Coerce2                       := OB.cmtCoercion;
(* line 2077 "oberon.aecp" *)

  yyt^.DyOperator.ValueReprOut                  := OB.cmtValue;
(* line 2076 "oberon.aecp" *)

  yyt^.DyOperator.TypeReprOut                   := OB.cErrorTypeRepr;
| Tree.RelationOper:
(* line 2089 "oberon.aecp" *)


  yyt^.RelationOper.TypeReprTmp                   := T.RelationInputType(yyt^.RelationOper.TypeRepr1In,yyt^.RelationOper.TypeRepr2In);
(* line 2091 "oberon.aecp" *)


  yyt^.RelationOper.Coerce1                       := CO.GetCoercion
                                   ( yyt^.RelationOper.TypeRepr1In
                                   , yyt^.RelationOper.TypeReprTmp);
(* line 3814 "oberon.aecp" *)
IF ~( ~T.IsErrorType(yyt^.RelationOper.TypeReprTmp)                                                                        
     OR  T.IsErrorType(yyt^.RelationOper.TypeRepr1In)
     OR  T.IsErrorType(yyt^.RelationOper.TypeRepr2In)
  ) THEN  ERR.MsgPos(ERR.MsgOperatorNotApplicable,yyt^.RelationOper.Position)
 END;
(* line 2094 "oberon.aecp" *)

  yyt^.RelationOper.Coerce2                       := CO.GetCoercion
                                   ( yyt^.RelationOper.TypeRepr2In
                                   , yyt^.RelationOper.TypeReprTmp);
(* line 2098 "oberon.aecp" *)


  yyt^.RelationOper.ValueReprOut                  := V.RelationValue
                                   ( CO.DoCoercion
                                                                ( yyt^.RelationOper.Coerce1
                                                                , yyt^.RelationOper.ValueRepr1In)
                                   , CO.DoCoercion
                                                                ( yyt^.RelationOper.Coerce2
                                                                , yyt^.RelationOper.ValueRepr2In)
                                   , yyt^.RelationOper.Operator);
(* line 2087 "oberon.aecp" *)

  yyt^.RelationOper.TypeReprOut                   := OB.cBooleanTypeRepr;
| Tree.EqualOper:
(* line 2089 "oberon.aecp" *)


  yyt^.EqualOper.TypeReprTmp                   := T.RelationInputType(yyt^.EqualOper.TypeRepr1In,yyt^.EqualOper.TypeRepr2In);
(* line 2091 "oberon.aecp" *)


  yyt^.EqualOper.Coerce1                       := CO.GetCoercion
                                   ( yyt^.EqualOper.TypeRepr1In
                                   , yyt^.EqualOper.TypeReprTmp);
(* line 3814 "oberon.aecp" *)
IF ~( ~T.IsErrorType(yyt^.EqualOper.TypeReprTmp)                                                                        
     OR  T.IsErrorType(yyt^.EqualOper.TypeRepr1In)
     OR  T.IsErrorType(yyt^.EqualOper.TypeRepr2In)
  ) THEN  ERR.MsgPos(ERR.MsgOperatorNotApplicable,yyt^.EqualOper.Position)
 END;
(* line 2094 "oberon.aecp" *)

  yyt^.EqualOper.Coerce2                       := CO.GetCoercion
                                   ( yyt^.EqualOper.TypeRepr2In
                                   , yyt^.EqualOper.TypeReprTmp);
(* line 2098 "oberon.aecp" *)


  yyt^.EqualOper.ValueReprOut                  := V.RelationValue
                                   ( CO.DoCoercion
                                                                ( yyt^.EqualOper.Coerce1
                                                                , yyt^.EqualOper.ValueRepr1In)
                                   , CO.DoCoercion
                                                                ( yyt^.EqualOper.Coerce2
                                                                , yyt^.EqualOper.ValueRepr2In)
                                   , yyt^.EqualOper.Operator);
(* line 2087 "oberon.aecp" *)

  yyt^.EqualOper.TypeReprOut                   := OB.cBooleanTypeRepr;
| Tree.UnequalOper:
(* line 2089 "oberon.aecp" *)


  yyt^.UnequalOper.TypeReprTmp                   := T.RelationInputType(yyt^.UnequalOper.TypeRepr1In,yyt^.UnequalOper.TypeRepr2In);
(* line 2091 "oberon.aecp" *)


  yyt^.UnequalOper.Coerce1                       := CO.GetCoercion
                                   ( yyt^.UnequalOper.TypeRepr1In
                                   , yyt^.UnequalOper.TypeReprTmp);
(* line 3814 "oberon.aecp" *)
IF ~( ~T.IsErrorType(yyt^.UnequalOper.TypeReprTmp)                                                                        
     OR  T.IsErrorType(yyt^.UnequalOper.TypeRepr1In)
     OR  T.IsErrorType(yyt^.UnequalOper.TypeRepr2In)
  ) THEN  ERR.MsgPos(ERR.MsgOperatorNotApplicable,yyt^.UnequalOper.Position)
 END;
(* line 2094 "oberon.aecp" *)

  yyt^.UnequalOper.Coerce2                       := CO.GetCoercion
                                   ( yyt^.UnequalOper.TypeRepr2In
                                   , yyt^.UnequalOper.TypeReprTmp);
(* line 2098 "oberon.aecp" *)


  yyt^.UnequalOper.ValueReprOut                  := V.RelationValue
                                   ( CO.DoCoercion
                                                                ( yyt^.UnequalOper.Coerce1
                                                                , yyt^.UnequalOper.ValueRepr1In)
                                   , CO.DoCoercion
                                                                ( yyt^.UnequalOper.Coerce2
                                                                , yyt^.UnequalOper.ValueRepr2In)
                                   , yyt^.UnequalOper.Operator);
(* line 2087 "oberon.aecp" *)

  yyt^.UnequalOper.TypeReprOut                   := OB.cBooleanTypeRepr;
| Tree.OrderRelationOper:
(* line 2089 "oberon.aecp" *)


  yyt^.OrderRelationOper.TypeReprTmp                   := T.RelationInputType(yyt^.OrderRelationOper.TypeRepr1In,yyt^.OrderRelationOper.TypeRepr2In);
(* line 2091 "oberon.aecp" *)


  yyt^.OrderRelationOper.Coerce1                       := CO.GetCoercion
                                   ( yyt^.OrderRelationOper.TypeRepr1In
                                   , yyt^.OrderRelationOper.TypeReprTmp);
(* line 3823 "oberon.aecp" *)
IF ~( T.IsLegalOrderRelationInputType(yyt^.OrderRelationOper.TypeReprTmp)                                                       
  ) THEN  ERR.MsgPos(ERR.MsgOperatorNotApplicable,yyt^.OrderRelationOper.Position)
 END;
(* line 3814 "oberon.aecp" *)
IF ~( ~T.IsErrorType(yyt^.OrderRelationOper.TypeReprTmp)                                                                        
     OR  T.IsErrorType(yyt^.OrderRelationOper.TypeRepr1In)
     OR  T.IsErrorType(yyt^.OrderRelationOper.TypeRepr2In)
  ) THEN  ERR.MsgPos(ERR.MsgOperatorNotApplicable,yyt^.OrderRelationOper.Position)
 END;
(* line 2094 "oberon.aecp" *)

  yyt^.OrderRelationOper.Coerce2                       := CO.GetCoercion
                                   ( yyt^.OrderRelationOper.TypeRepr2In
                                   , yyt^.OrderRelationOper.TypeReprTmp);
(* line 2098 "oberon.aecp" *)


  yyt^.OrderRelationOper.ValueReprOut                  := V.RelationValue
                                   ( CO.DoCoercion
                                                                ( yyt^.OrderRelationOper.Coerce1
                                                                , yyt^.OrderRelationOper.ValueRepr1In)
                                   , CO.DoCoercion
                                                                ( yyt^.OrderRelationOper.Coerce2
                                                                , yyt^.OrderRelationOper.ValueRepr2In)
                                   , yyt^.OrderRelationOper.Operator);
(* line 2087 "oberon.aecp" *)

  yyt^.OrderRelationOper.TypeReprOut                   := OB.cBooleanTypeRepr;
| Tree.LessOper:
(* line 2089 "oberon.aecp" *)


  yyt^.LessOper.TypeReprTmp                   := T.RelationInputType(yyt^.LessOper.TypeRepr1In,yyt^.LessOper.TypeRepr2In);
(* line 2091 "oberon.aecp" *)


  yyt^.LessOper.Coerce1                       := CO.GetCoercion
                                   ( yyt^.LessOper.TypeRepr1In
                                   , yyt^.LessOper.TypeReprTmp);
(* line 3823 "oberon.aecp" *)
IF ~( T.IsLegalOrderRelationInputType(yyt^.LessOper.TypeReprTmp)                                                       
  ) THEN  ERR.MsgPos(ERR.MsgOperatorNotApplicable,yyt^.LessOper.Position)
 END;
(* line 3814 "oberon.aecp" *)
IF ~( ~T.IsErrorType(yyt^.LessOper.TypeReprTmp)                                                                        
     OR  T.IsErrorType(yyt^.LessOper.TypeRepr1In)
     OR  T.IsErrorType(yyt^.LessOper.TypeRepr2In)
  ) THEN  ERR.MsgPos(ERR.MsgOperatorNotApplicable,yyt^.LessOper.Position)
 END;
(* line 2094 "oberon.aecp" *)

  yyt^.LessOper.Coerce2                       := CO.GetCoercion
                                   ( yyt^.LessOper.TypeRepr2In
                                   , yyt^.LessOper.TypeReprTmp);
(* line 2098 "oberon.aecp" *)


  yyt^.LessOper.ValueReprOut                  := V.RelationValue
                                   ( CO.DoCoercion
                                                                ( yyt^.LessOper.Coerce1
                                                                , yyt^.LessOper.ValueRepr1In)
                                   , CO.DoCoercion
                                                                ( yyt^.LessOper.Coerce2
                                                                , yyt^.LessOper.ValueRepr2In)
                                   , yyt^.LessOper.Operator);
(* line 2087 "oberon.aecp" *)

  yyt^.LessOper.TypeReprOut                   := OB.cBooleanTypeRepr;
| Tree.LessEqualOper:
(* line 2089 "oberon.aecp" *)


  yyt^.LessEqualOper.TypeReprTmp                   := T.RelationInputType(yyt^.LessEqualOper.TypeRepr1In,yyt^.LessEqualOper.TypeRepr2In);
(* line 2091 "oberon.aecp" *)


  yyt^.LessEqualOper.Coerce1                       := CO.GetCoercion
                                   ( yyt^.LessEqualOper.TypeRepr1In
                                   , yyt^.LessEqualOper.TypeReprTmp);
(* line 3823 "oberon.aecp" *)
IF ~( T.IsLegalOrderRelationInputType(yyt^.LessEqualOper.TypeReprTmp)                                                       
  ) THEN  ERR.MsgPos(ERR.MsgOperatorNotApplicable,yyt^.LessEqualOper.Position)
 END;
(* line 3814 "oberon.aecp" *)
IF ~( ~T.IsErrorType(yyt^.LessEqualOper.TypeReprTmp)                                                                        
     OR  T.IsErrorType(yyt^.LessEqualOper.TypeRepr1In)
     OR  T.IsErrorType(yyt^.LessEqualOper.TypeRepr2In)
  ) THEN  ERR.MsgPos(ERR.MsgOperatorNotApplicable,yyt^.LessEqualOper.Position)
 END;
(* line 2094 "oberon.aecp" *)

  yyt^.LessEqualOper.Coerce2                       := CO.GetCoercion
                                   ( yyt^.LessEqualOper.TypeRepr2In
                                   , yyt^.LessEqualOper.TypeReprTmp);
(* line 2098 "oberon.aecp" *)


  yyt^.LessEqualOper.ValueReprOut                  := V.RelationValue
                                   ( CO.DoCoercion
                                                                ( yyt^.LessEqualOper.Coerce1
                                                                , yyt^.LessEqualOper.ValueRepr1In)
                                   , CO.DoCoercion
                                                                ( yyt^.LessEqualOper.Coerce2
                                                                , yyt^.LessEqualOper.ValueRepr2In)
                                   , yyt^.LessEqualOper.Operator);
(* line 2087 "oberon.aecp" *)

  yyt^.LessEqualOper.TypeReprOut                   := OB.cBooleanTypeRepr;
| Tree.GreaterOper:
(* line 2089 "oberon.aecp" *)


  yyt^.GreaterOper.TypeReprTmp                   := T.RelationInputType(yyt^.GreaterOper.TypeRepr1In,yyt^.GreaterOper.TypeRepr2In);
(* line 2091 "oberon.aecp" *)


  yyt^.GreaterOper.Coerce1                       := CO.GetCoercion
                                   ( yyt^.GreaterOper.TypeRepr1In
                                   , yyt^.GreaterOper.TypeReprTmp);
(* line 3823 "oberon.aecp" *)
IF ~( T.IsLegalOrderRelationInputType(yyt^.GreaterOper.TypeReprTmp)                                                       
  ) THEN  ERR.MsgPos(ERR.MsgOperatorNotApplicable,yyt^.GreaterOper.Position)
 END;
(* line 3814 "oberon.aecp" *)
IF ~( ~T.IsErrorType(yyt^.GreaterOper.TypeReprTmp)                                                                        
     OR  T.IsErrorType(yyt^.GreaterOper.TypeRepr1In)
     OR  T.IsErrorType(yyt^.GreaterOper.TypeRepr2In)
  ) THEN  ERR.MsgPos(ERR.MsgOperatorNotApplicable,yyt^.GreaterOper.Position)
 END;
(* line 2094 "oberon.aecp" *)

  yyt^.GreaterOper.Coerce2                       := CO.GetCoercion
                                   ( yyt^.GreaterOper.TypeRepr2In
                                   , yyt^.GreaterOper.TypeReprTmp);
(* line 2098 "oberon.aecp" *)


  yyt^.GreaterOper.ValueReprOut                  := V.RelationValue
                                   ( CO.DoCoercion
                                                                ( yyt^.GreaterOper.Coerce1
                                                                , yyt^.GreaterOper.ValueRepr1In)
                                   , CO.DoCoercion
                                                                ( yyt^.GreaterOper.Coerce2
                                                                , yyt^.GreaterOper.ValueRepr2In)
                                   , yyt^.GreaterOper.Operator);
(* line 2087 "oberon.aecp" *)

  yyt^.GreaterOper.TypeReprOut                   := OB.cBooleanTypeRepr;
| Tree.GreaterEqualOper:
(* line 2089 "oberon.aecp" *)


  yyt^.GreaterEqualOper.TypeReprTmp                   := T.RelationInputType(yyt^.GreaterEqualOper.TypeRepr1In,yyt^.GreaterEqualOper.TypeRepr2In);
(* line 2091 "oberon.aecp" *)


  yyt^.GreaterEqualOper.Coerce1                       := CO.GetCoercion
                                   ( yyt^.GreaterEqualOper.TypeRepr1In
                                   , yyt^.GreaterEqualOper.TypeReprTmp);
(* line 3823 "oberon.aecp" *)
IF ~( T.IsLegalOrderRelationInputType(yyt^.GreaterEqualOper.TypeReprTmp)                                                       
  ) THEN  ERR.MsgPos(ERR.MsgOperatorNotApplicable,yyt^.GreaterEqualOper.Position)
 END;
(* line 3814 "oberon.aecp" *)
IF ~( ~T.IsErrorType(yyt^.GreaterEqualOper.TypeReprTmp)                                                                        
     OR  T.IsErrorType(yyt^.GreaterEqualOper.TypeRepr1In)
     OR  T.IsErrorType(yyt^.GreaterEqualOper.TypeRepr2In)
  ) THEN  ERR.MsgPos(ERR.MsgOperatorNotApplicable,yyt^.GreaterEqualOper.Position)
 END;
(* line 2094 "oberon.aecp" *)

  yyt^.GreaterEqualOper.Coerce2                       := CO.GetCoercion
                                   ( yyt^.GreaterEqualOper.TypeRepr2In
                                   , yyt^.GreaterEqualOper.TypeReprTmp);
(* line 2098 "oberon.aecp" *)


  yyt^.GreaterEqualOper.ValueReprOut                  := V.RelationValue
                                   ( CO.DoCoercion
                                                                ( yyt^.GreaterEqualOper.Coerce1
                                                                , yyt^.GreaterEqualOper.ValueRepr1In)
                                   , CO.DoCoercion
                                                                ( yyt^.GreaterEqualOper.Coerce2
                                                                , yyt^.GreaterEqualOper.ValueRepr2In)
                                   , yyt^.GreaterEqualOper.Operator);
(* line 2087 "oberon.aecp" *)

  yyt^.GreaterEqualOper.TypeReprOut                   := OB.cBooleanTypeRepr;
| Tree.InOper:
(* line 2079 "oberon.aecp" *)


  yyt^.InOper.Coerce1                       := OB.cmtCoercion;
(* line 3830 "oberon.aecp" *)
IF ~( T.IsIntegerType(yyt^.InOper.TypeRepr1In)                                                                       
  ) THEN  ERR.MsgPos(ERR.MsgInvalidExprType,yyt^.InOper.Expr1PosIn)
 END;
(* line 3833 "oberon.aecp" *)
IF ~( T.IsSetType(yyt^.InOper.TypeRepr2In)                                                                           
  ) THEN  ERR.MsgPos(ERR.MsgInvalidExprType,yyt^.InOper.Expr2PosIn)
 END;
(* line 2080 "oberon.aecp" *)

  yyt^.InOper.Coerce2                       := OB.cmtCoercion;
(* line 2112 "oberon.aecp" *)

  yyt^.InOper.ValueReprOut                  := V.InValue(yyt^.InOper.ValueRepr1In,yyt^.InOper.ValueRepr2In);
(* line 2111 "oberon.aecp" *)

  yyt^.InOper.TypeReprOut                   := OB.cBooleanTypeRepr;
| Tree.NumSetOper:
(* line 2119 "oberon.aecp" *)

  yyt^.NumSetOper.TypeReprTmp                   := T.SetOrSmallestNumTypeInclBoth(yyt^.NumSetOper.TypeRepr1In,yyt^.NumSetOper.TypeRepr2In);
(* line 2121 "oberon.aecp" *)
               

  yyt^.NumSetOper.Coerce1                       := CO.GetCoercion
                                   ( yyt^.NumSetOper.TypeRepr1In
                                   , yyt^.NumSetOper.TypeReprTmp);
(* line 2124 "oberon.aecp" *)

  yyt^.NumSetOper.Coerce2                       := CO.GetCoercion
                                   ( yyt^.NumSetOper.TypeRepr2In
                                   , yyt^.NumSetOper.TypeReprTmp);
(* line 2128 "oberon.aecp" *)


  yyt^.NumSetOper.ValueReprOut                  := V.OperationValue
                                   ( CO.DoCoercion
                                                                ( yyt^.NumSetOper.Coerce1
                                                                , yyt^.NumSetOper.ValueRepr1In)
                                   , CO.DoCoercion
                                                                ( yyt^.NumSetOper.Coerce2
                                                                , yyt^.NumSetOper.ValueRepr2In)
                                   , yyt^.NumSetOper.Operator);
(* line 3847 "oberon.aecp" *)


  yyt^.NumSetOper.calculationSuccess:= yyt^.NumSetOper.ValDontCareIn                                                                                          
                    OR  T.IsErrorType(yyt^.NumSetOper.TypeReprTmp)                                                                       
                    OR ~V.IsCalculatableValue(yyt^.NumSetOper.ValueRepr1In)
                    OR ~V.IsCalculatableValue(yyt^.NumSetOper.ValueRepr2In)
                    OR ~V.IsErrorValue(yyt^.NumSetOper.ValueReprOut);
(* line 3853 "oberon.aecp" *)
IF ~( yyt^.NumSetOper.calculationSuccess
  ) THEN  ERR.MsgPos(ERR.MsgConstArithmeticError,yyt^.NumSetOper.Position)
 END;
(* line 3842 "oberon.aecp" *)
IF ~( ~T.IsErrorType(yyt^.NumSetOper.TypeReprTmp)                                                                        
     OR  T.IsErrorType(yyt^.NumSetOper.TypeRepr1In)
     OR  T.IsErrorType(yyt^.NumSetOper.TypeRepr2In)
  ) THEN  ERR.MsgPos(ERR.MsgOperatorNotApplicable,yyt^.NumSetOper.Position)
 END;
(* line 2136 "oberon.aecp" *)

  yyt^.NumSetOper.TypeReprOut                   := T.ConstTypeCorrection                                               
                                   ( yyt^.NumSetOper.TypeReprTmp
                                   , yyt^.NumSetOper.ValueReprOut);
| Tree.PlusOper:
(* line 2119 "oberon.aecp" *)

  yyt^.PlusOper.TypeReprTmp                   := T.SetOrSmallestNumTypeInclBoth(yyt^.PlusOper.TypeRepr1In,yyt^.PlusOper.TypeRepr2In);
(* line 2121 "oberon.aecp" *)
               

  yyt^.PlusOper.Coerce1                       := CO.GetCoercion
                                   ( yyt^.PlusOper.TypeRepr1In
                                   , yyt^.PlusOper.TypeReprTmp);
(* line 2124 "oberon.aecp" *)

  yyt^.PlusOper.Coerce2                       := CO.GetCoercion
                                   ( yyt^.PlusOper.TypeRepr2In
                                   , yyt^.PlusOper.TypeReprTmp);
(* line 2128 "oberon.aecp" *)


  yyt^.PlusOper.ValueReprOut                  := V.OperationValue
                                   ( CO.DoCoercion
                                                                ( yyt^.PlusOper.Coerce1
                                                                , yyt^.PlusOper.ValueRepr1In)
                                   , CO.DoCoercion
                                                                ( yyt^.PlusOper.Coerce2
                                                                , yyt^.PlusOper.ValueRepr2In)
                                   , yyt^.PlusOper.Operator);
(* line 3847 "oberon.aecp" *)


  yyt^.PlusOper.calculationSuccess:= yyt^.PlusOper.ValDontCareIn                                                                                          
                    OR  T.IsErrorType(yyt^.PlusOper.TypeReprTmp)                                                                       
                    OR ~V.IsCalculatableValue(yyt^.PlusOper.ValueRepr1In)
                    OR ~V.IsCalculatableValue(yyt^.PlusOper.ValueRepr2In)
                    OR ~V.IsErrorValue(yyt^.PlusOper.ValueReprOut);
(* line 3853 "oberon.aecp" *)
IF ~( yyt^.PlusOper.calculationSuccess
  ) THEN  ERR.MsgPos(ERR.MsgConstArithmeticError,yyt^.PlusOper.Position)
 END;
(* line 3842 "oberon.aecp" *)
IF ~( ~T.IsErrorType(yyt^.PlusOper.TypeReprTmp)                                                                        
     OR  T.IsErrorType(yyt^.PlusOper.TypeRepr1In)
     OR  T.IsErrorType(yyt^.PlusOper.TypeRepr2In)
  ) THEN  ERR.MsgPos(ERR.MsgOperatorNotApplicable,yyt^.PlusOper.Position)
 END;
(* line 2136 "oberon.aecp" *)

  yyt^.PlusOper.TypeReprOut                   := T.ConstTypeCorrection                                               
                                   ( yyt^.PlusOper.TypeReprTmp
                                   , yyt^.PlusOper.ValueReprOut);
| Tree.MinusOper:
(* line 2119 "oberon.aecp" *)

  yyt^.MinusOper.TypeReprTmp                   := T.SetOrSmallestNumTypeInclBoth(yyt^.MinusOper.TypeRepr1In,yyt^.MinusOper.TypeRepr2In);
(* line 2121 "oberon.aecp" *)
               

  yyt^.MinusOper.Coerce1                       := CO.GetCoercion
                                   ( yyt^.MinusOper.TypeRepr1In
                                   , yyt^.MinusOper.TypeReprTmp);
(* line 2124 "oberon.aecp" *)

  yyt^.MinusOper.Coerce2                       := CO.GetCoercion
                                   ( yyt^.MinusOper.TypeRepr2In
                                   , yyt^.MinusOper.TypeReprTmp);
(* line 2128 "oberon.aecp" *)


  yyt^.MinusOper.ValueReprOut                  := V.OperationValue
                                   ( CO.DoCoercion
                                                                ( yyt^.MinusOper.Coerce1
                                                                , yyt^.MinusOper.ValueRepr1In)
                                   , CO.DoCoercion
                                                                ( yyt^.MinusOper.Coerce2
                                                                , yyt^.MinusOper.ValueRepr2In)
                                   , yyt^.MinusOper.Operator);
(* line 3847 "oberon.aecp" *)


  yyt^.MinusOper.calculationSuccess:= yyt^.MinusOper.ValDontCareIn                                                                                          
                    OR  T.IsErrorType(yyt^.MinusOper.TypeReprTmp)                                                                       
                    OR ~V.IsCalculatableValue(yyt^.MinusOper.ValueRepr1In)
                    OR ~V.IsCalculatableValue(yyt^.MinusOper.ValueRepr2In)
                    OR ~V.IsErrorValue(yyt^.MinusOper.ValueReprOut);
(* line 3853 "oberon.aecp" *)
IF ~( yyt^.MinusOper.calculationSuccess
  ) THEN  ERR.MsgPos(ERR.MsgConstArithmeticError,yyt^.MinusOper.Position)
 END;
(* line 3842 "oberon.aecp" *)
IF ~( ~T.IsErrorType(yyt^.MinusOper.TypeReprTmp)                                                                        
     OR  T.IsErrorType(yyt^.MinusOper.TypeRepr1In)
     OR  T.IsErrorType(yyt^.MinusOper.TypeRepr2In)
  ) THEN  ERR.MsgPos(ERR.MsgOperatorNotApplicable,yyt^.MinusOper.Position)
 END;
(* line 2136 "oberon.aecp" *)

  yyt^.MinusOper.TypeReprOut                   := T.ConstTypeCorrection                                               
                                   ( yyt^.MinusOper.TypeReprTmp
                                   , yyt^.MinusOper.ValueReprOut);
| Tree.MultOper:
(* line 2119 "oberon.aecp" *)

  yyt^.MultOper.TypeReprTmp                   := T.SetOrSmallestNumTypeInclBoth(yyt^.MultOper.TypeRepr1In,yyt^.MultOper.TypeRepr2In);
(* line 2121 "oberon.aecp" *)
               

  yyt^.MultOper.Coerce1                       := CO.GetCoercion
                                   ( yyt^.MultOper.TypeRepr1In
                                   , yyt^.MultOper.TypeReprTmp);
(* line 2124 "oberon.aecp" *)

  yyt^.MultOper.Coerce2                       := CO.GetCoercion
                                   ( yyt^.MultOper.TypeRepr2In
                                   , yyt^.MultOper.TypeReprTmp);
(* line 2128 "oberon.aecp" *)


  yyt^.MultOper.ValueReprOut                  := V.OperationValue
                                   ( CO.DoCoercion
                                                                ( yyt^.MultOper.Coerce1
                                                                , yyt^.MultOper.ValueRepr1In)
                                   , CO.DoCoercion
                                                                ( yyt^.MultOper.Coerce2
                                                                , yyt^.MultOper.ValueRepr2In)
                                   , yyt^.MultOper.Operator);
(* line 3847 "oberon.aecp" *)


  yyt^.MultOper.calculationSuccess:= yyt^.MultOper.ValDontCareIn                                                                                          
                    OR  T.IsErrorType(yyt^.MultOper.TypeReprTmp)                                                                       
                    OR ~V.IsCalculatableValue(yyt^.MultOper.ValueRepr1In)
                    OR ~V.IsCalculatableValue(yyt^.MultOper.ValueRepr2In)
                    OR ~V.IsErrorValue(yyt^.MultOper.ValueReprOut);
(* line 3853 "oberon.aecp" *)
IF ~( yyt^.MultOper.calculationSuccess
  ) THEN  ERR.MsgPos(ERR.MsgConstArithmeticError,yyt^.MultOper.Position)
 END;
(* line 3842 "oberon.aecp" *)
IF ~( ~T.IsErrorType(yyt^.MultOper.TypeReprTmp)                                                                        
     OR  T.IsErrorType(yyt^.MultOper.TypeRepr1In)
     OR  T.IsErrorType(yyt^.MultOper.TypeRepr2In)
  ) THEN  ERR.MsgPos(ERR.MsgOperatorNotApplicable,yyt^.MultOper.Position)
 END;
(* line 2136 "oberon.aecp" *)

  yyt^.MultOper.TypeReprOut                   := T.ConstTypeCorrection                                               
                                   ( yyt^.MultOper.TypeReprTmp
                                   , yyt^.MultOper.ValueReprOut);
| Tree.RDivOper:
(* line 2144 "oberon.aecp" *)

  yyt^.RDivOper.TypeReprTmp                   := T.SetOrSmallestRealType                                                
                                   (T.SetOrSmallestNumTypeInclBoth(yyt^.RDivOper.TypeRepr1In,yyt^.RDivOper.TypeRepr2In));
(* line 2121 "oberon.aecp" *)
               

  yyt^.RDivOper.Coerce1                       := CO.GetCoercion
                                   ( yyt^.RDivOper.TypeRepr1In
                                   , yyt^.RDivOper.TypeReprTmp);
(* line 2124 "oberon.aecp" *)

  yyt^.RDivOper.Coerce2                       := CO.GetCoercion
                                   ( yyt^.RDivOper.TypeRepr2In
                                   , yyt^.RDivOper.TypeReprTmp);
(* line 2128 "oberon.aecp" *)


  yyt^.RDivOper.ValueReprOut                  := V.OperationValue
                                   ( CO.DoCoercion
                                                                ( yyt^.RDivOper.Coerce1
                                                                , yyt^.RDivOper.ValueRepr1In)
                                   , CO.DoCoercion
                                                                ( yyt^.RDivOper.Coerce2
                                                                , yyt^.RDivOper.ValueRepr2In)
                                   , yyt^.RDivOper.Operator);
(* line 3847 "oberon.aecp" *)


  yyt^.RDivOper.calculationSuccess:= yyt^.RDivOper.ValDontCareIn                                                                                          
                    OR  T.IsErrorType(yyt^.RDivOper.TypeReprTmp)                                                                       
                    OR ~V.IsCalculatableValue(yyt^.RDivOper.ValueRepr1In)
                    OR ~V.IsCalculatableValue(yyt^.RDivOper.ValueRepr2In)
                    OR ~V.IsErrorValue(yyt^.RDivOper.ValueReprOut);
(* line 3853 "oberon.aecp" *)
IF ~( yyt^.RDivOper.calculationSuccess
  ) THEN  ERR.MsgPos(ERR.MsgConstArithmeticError,yyt^.RDivOper.Position)
 END;
(* line 3842 "oberon.aecp" *)
IF ~( ~T.IsErrorType(yyt^.RDivOper.TypeReprTmp)                                                                        
     OR  T.IsErrorType(yyt^.RDivOper.TypeRepr1In)
     OR  T.IsErrorType(yyt^.RDivOper.TypeRepr2In)
  ) THEN  ERR.MsgPos(ERR.MsgOperatorNotApplicable,yyt^.RDivOper.Position)
 END;
(* line 2136 "oberon.aecp" *)

  yyt^.RDivOper.TypeReprOut                   := T.ConstTypeCorrection                                               
                                   ( yyt^.RDivOper.TypeReprTmp
                                   , yyt^.RDivOper.ValueReprOut);
| Tree.IntOper:
(* line 2151 "oberon.aecp" *)

  yyt^.IntOper.TypeReprTmp                   := T.SmallestIntegerTypeInclBoth(yyt^.IntOper.TypeRepr1In,yyt^.IntOper.TypeRepr2In);
(* line 2121 "oberon.aecp" *)
               

  yyt^.IntOper.Coerce1                       := CO.GetCoercion
                                   ( yyt^.IntOper.TypeRepr1In
                                   , yyt^.IntOper.TypeReprTmp);
(* line 2124 "oberon.aecp" *)

  yyt^.IntOper.Coerce2                       := CO.GetCoercion
                                   ( yyt^.IntOper.TypeRepr2In
                                   , yyt^.IntOper.TypeReprTmp);
(* line 2128 "oberon.aecp" *)


  yyt^.IntOper.ValueReprOut                  := V.OperationValue
                                   ( CO.DoCoercion
                                                                ( yyt^.IntOper.Coerce1
                                                                , yyt^.IntOper.ValueRepr1In)
                                   , CO.DoCoercion
                                                                ( yyt^.IntOper.Coerce2
                                                                , yyt^.IntOper.ValueRepr2In)
                                   , yyt^.IntOper.Operator);
(* line 3860 "oberon.aecp" *)

  yyt^.IntOper.calculationSuccess:=V.IsGreaterZeroInteger(yyt^.IntOper.ValueRepr2In);
(* line 3853 "oberon.aecp" *)
IF ~( yyt^.IntOper.calculationSuccess
  ) THEN  ERR.MsgPos(ERR.MsgConstArithmeticError,yyt^.IntOper.Position)
 END;
(* line 3842 "oberon.aecp" *)
IF ~( ~T.IsErrorType(yyt^.IntOper.TypeReprTmp)                                                                        
     OR  T.IsErrorType(yyt^.IntOper.TypeRepr1In)
     OR  T.IsErrorType(yyt^.IntOper.TypeRepr2In)
  ) THEN  ERR.MsgPos(ERR.MsgOperatorNotApplicable,yyt^.IntOper.Position)
 END;
(* line 2136 "oberon.aecp" *)

  yyt^.IntOper.TypeReprOut                   := T.ConstTypeCorrection                                               
                                   ( yyt^.IntOper.TypeReprTmp
                                   , yyt^.IntOper.ValueReprOut);
| Tree.DivOper:
(* line 2151 "oberon.aecp" *)

  yyt^.DivOper.TypeReprTmp                   := T.SmallestIntegerTypeInclBoth(yyt^.DivOper.TypeRepr1In,yyt^.DivOper.TypeRepr2In);
(* line 2121 "oberon.aecp" *)
               

  yyt^.DivOper.Coerce1                       := CO.GetCoercion
                                   ( yyt^.DivOper.TypeRepr1In
                                   , yyt^.DivOper.TypeReprTmp);
(* line 2124 "oberon.aecp" *)

  yyt^.DivOper.Coerce2                       := CO.GetCoercion
                                   ( yyt^.DivOper.TypeRepr2In
                                   , yyt^.DivOper.TypeReprTmp);
(* line 2128 "oberon.aecp" *)


  yyt^.DivOper.ValueReprOut                  := V.OperationValue
                                   ( CO.DoCoercion
                                                                ( yyt^.DivOper.Coerce1
                                                                , yyt^.DivOper.ValueRepr1In)
                                   , CO.DoCoercion
                                                                ( yyt^.DivOper.Coerce2
                                                                , yyt^.DivOper.ValueRepr2In)
                                   , yyt^.DivOper.Operator);
(* line 3860 "oberon.aecp" *)

  yyt^.DivOper.calculationSuccess:=V.IsGreaterZeroInteger(yyt^.DivOper.ValueRepr2In);
(* line 3853 "oberon.aecp" *)
IF ~( yyt^.DivOper.calculationSuccess
  ) THEN  ERR.MsgPos(ERR.MsgConstArithmeticError,yyt^.DivOper.Position)
 END;
(* line 3842 "oberon.aecp" *)
IF ~( ~T.IsErrorType(yyt^.DivOper.TypeReprTmp)                                                                        
     OR  T.IsErrorType(yyt^.DivOper.TypeRepr1In)
     OR  T.IsErrorType(yyt^.DivOper.TypeRepr2In)
  ) THEN  ERR.MsgPos(ERR.MsgOperatorNotApplicable,yyt^.DivOper.Position)
 END;
(* line 2136 "oberon.aecp" *)

  yyt^.DivOper.TypeReprOut                   := T.ConstTypeCorrection                                               
                                   ( yyt^.DivOper.TypeReprTmp
                                   , yyt^.DivOper.ValueReprOut);
| Tree.ModOper:
(* line 2151 "oberon.aecp" *)

  yyt^.ModOper.TypeReprTmp                   := T.SmallestIntegerTypeInclBoth(yyt^.ModOper.TypeRepr1In,yyt^.ModOper.TypeRepr2In);
(* line 2121 "oberon.aecp" *)
               

  yyt^.ModOper.Coerce1                       := CO.GetCoercion
                                   ( yyt^.ModOper.TypeRepr1In
                                   , yyt^.ModOper.TypeReprTmp);
(* line 2124 "oberon.aecp" *)

  yyt^.ModOper.Coerce2                       := CO.GetCoercion
                                   ( yyt^.ModOper.TypeRepr2In
                                   , yyt^.ModOper.TypeReprTmp);
(* line 2128 "oberon.aecp" *)


  yyt^.ModOper.ValueReprOut                  := V.OperationValue
                                   ( CO.DoCoercion
                                                                ( yyt^.ModOper.Coerce1
                                                                , yyt^.ModOper.ValueRepr1In)
                                   , CO.DoCoercion
                                                                ( yyt^.ModOper.Coerce2
                                                                , yyt^.ModOper.ValueRepr2In)
                                   , yyt^.ModOper.Operator);
(* line 3860 "oberon.aecp" *)

  yyt^.ModOper.calculationSuccess:=V.IsGreaterZeroInteger(yyt^.ModOper.ValueRepr2In);
(* line 3853 "oberon.aecp" *)
IF ~( yyt^.ModOper.calculationSuccess
  ) THEN  ERR.MsgPos(ERR.MsgConstArithmeticError,yyt^.ModOper.Position)
 END;
(* line 3842 "oberon.aecp" *)
IF ~( ~T.IsErrorType(yyt^.ModOper.TypeReprTmp)                                                                        
     OR  T.IsErrorType(yyt^.ModOper.TypeRepr1In)
     OR  T.IsErrorType(yyt^.ModOper.TypeRepr2In)
  ) THEN  ERR.MsgPos(ERR.MsgOperatorNotApplicable,yyt^.ModOper.Position)
 END;
(* line 2136 "oberon.aecp" *)

  yyt^.ModOper.TypeReprOut                   := T.ConstTypeCorrection                                               
                                   ( yyt^.ModOper.TypeReprTmp
                                   , yyt^.ModOper.ValueReprOut);
| Tree.BoolOper:
(* line 2079 "oberon.aecp" *)


  yyt^.BoolOper.Coerce1                       := OB.cmtCoercion;
(* line 3866 "oberon.aecp" *)
IF ~( T.IsBooleanType(yyt^.BoolOper.TypeRepr1In)                                                                       
  ) THEN  ERR.MsgPos(ERR.MsgInvalidExprType,yyt^.BoolOper.Expr1PosIn)
 END;
(* line 3869 "oberon.aecp" *)
IF ~( T.IsBooleanType(yyt^.BoolOper.TypeRepr2In)                                                                       
  ) THEN  ERR.MsgPos(ERR.MsgInvalidExprType,yyt^.BoolOper.Expr2PosIn)
 END;
(* line 2080 "oberon.aecp" *)

  yyt^.BoolOper.Coerce2                       := OB.cmtCoercion;
(* line 2077 "oberon.aecp" *)

  yyt^.BoolOper.ValueReprOut                  := OB.cmtValue;
(* line 2157 "oberon.aecp" *)

  yyt^.BoolOper.TypeReprOut                   := OB.cBooleanTypeRepr;
| Tree.OrOper:
(* line 2079 "oberon.aecp" *)


  yyt^.OrOper.Coerce1                       := OB.cmtCoercion;
(* line 3866 "oberon.aecp" *)
IF ~( T.IsBooleanType(yyt^.OrOper.TypeRepr1In)                                                                       
  ) THEN  ERR.MsgPos(ERR.MsgInvalidExprType,yyt^.OrOper.Expr1PosIn)
 END;
(* line 3869 "oberon.aecp" *)
IF ~( T.IsBooleanType(yyt^.OrOper.TypeRepr2In)                                                                       
  ) THEN  ERR.MsgPos(ERR.MsgInvalidExprType,yyt^.OrOper.Expr2PosIn)
 END;
(* line 2080 "oberon.aecp" *)

  yyt^.OrOper.Coerce2                       := OB.cmtCoercion;
(* line 2165 "oberon.aecp" *)

  yyt^.OrOper.ValueReprOut                  := V.OrValue(yyt^.OrOper.ValueRepr1In,yyt^.OrOper.ValueRepr2In);
(* line 2157 "oberon.aecp" *)

  yyt^.OrOper.TypeReprOut                   := OB.cBooleanTypeRepr;
| Tree.AndOper:
(* line 2079 "oberon.aecp" *)


  yyt^.AndOper.Coerce1                       := OB.cmtCoercion;
(* line 3866 "oberon.aecp" *)
IF ~( T.IsBooleanType(yyt^.AndOper.TypeRepr1In)                                                                       
  ) THEN  ERR.MsgPos(ERR.MsgInvalidExprType,yyt^.AndOper.Expr1PosIn)
 END;
(* line 3869 "oberon.aecp" *)
IF ~( T.IsBooleanType(yyt^.AndOper.TypeRepr2In)                                                                       
  ) THEN  ERR.MsgPos(ERR.MsgInvalidExprType,yyt^.AndOper.Expr2PosIn)
 END;
(* line 2080 "oberon.aecp" *)

  yyt^.AndOper.Coerce2                       := OB.cmtCoercion;
(* line 2173 "oberon.aecp" *)

  yyt^.AndOper.ValueReprOut                  := V.AndValue(yyt^.AndOper.ValueRepr1In,yyt^.AndOper.ValueRepr2In);
(* line 2157 "oberon.aecp" *)

  yyt^.AndOper.TypeReprOut                   := OB.cBooleanTypeRepr;
  ELSE
  END;
 END yyVisit2;

PROCEDURE yyVisit3 (yyt: Tree.tTree);
 BEGIN
  CASE yyt^.Kind OF
| Tree.ParIds:
yyt^.ParIds.SignatureReprOut:=yyt^.ParIds.SignatureReprIn;
| Tree.mtParId:
yyt^.mtParId.SignatureReprOut:=yyt^.mtParId.SignatureReprIn;
| Tree.ParId:
yyt^.ParId.Next^.ParIds.EnvIn:=yyt^.ParId.EnvIn;
(* line 1271 "oberon.aecp" *)

  yyt^.ParId.Next^.ParIds.SignatureReprIn          := yyt^.ParId.SignatureReprIn;
yyVisit3 (yyt^.ParId.Next);
(* line 1274 "oberon.aecp" *)

  yyt^.ParId.SignatureReprOut              := OB.mSignature
                                   ( yyt^.ParId.Next^.ParIds.SignatureReprOut
                                   , yyt^.ParId.Next^.ParIds.Table1In);
  ELSE
  END;
 END yyVisit3;

PROCEDURE BeginEval*;
 BEGIN
 END BeginEval;

PROCEDURE CloseEval*;
 BEGIN
 END CloseEval;

BEGIN
END Eval.

