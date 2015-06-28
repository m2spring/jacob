(* $Id: Parser.mi,v 2.8 1992/08/12 06:54:05 grosch rel $ *)

MODULE Parser;

IMPORT SYSTEM, Scanner, Positions, Errors, Strings, DynArray, Sets, System,

(* line 2 "/tmp/lalr1303" *)
(* line 5 oberon.lal *)
 Base           ,
               Idents         ,
               OB             ,
               OT             ,
               POS            ,
               Tree           ;

VAR ParsTabName*	: ARRAY 129 OF CHAR;

        TYPE tTree = Tree.tTree;
        TYPE   tParsAttribute = RECORD
                                 Scan : Scanner.tScanAttribute;
                                 Tree : tTree;
                                END; 

CONST
   yyInitStackSize	= 100;
   yyNoState		= 0;

   yyFirstTerminal		= 0;
   yyLastTerminal		= 67;
   yyFirstSymbol		= 0;
   yyLastSymbol		= 136;
   yyTableMax		= 620;
   yyNTableMax		= 771;
   yyFirstReadState		= 1;
   yyLastReadState		= 213;
   yyFirstReadTermState		= 214;
   yyLastReadTermState		= 262;
   yyLastReadNontermState		= 341;
   yyFirstReduceState		= 342;
   yyLastReduceState		= 509;
   yyStartState		= 1;
   yyStopState		= 342;

   yyFirstFinalState	= yyFirstReadTermState;
   yyLastState		= yyLastReduceState;

TYPE
   yyTableElmt		= INTEGER;
   yyTCombRange		= LONGINT; 
   yyNCombRange		= LONGINT; 
   yyStateRange		= LONGINT; 
   yyReadRange		= LONGINT; 
   yyReadReduceRange	= LONGINT; 
   yyReduceRange	= LONGINT; 
   yySymbolRange	= LONGINT; 
   yyTCombType		= RECORD Check, Next: yyStateRange; END;
   yyNCombType		= LONGINT; 
   yyTCombTypePtr	= POINTER TO yyTCombType;
   yyNCombTypePtr	= POINTER TO ARRAY 1 OF yyNCombType;
   yyStackType		= POINTER TO ARRAY 1000000 OF yyStateRange;

VAR
   yyTBasePtr		: ARRAY yyLastReadState+1	OF yyTCombTypePtr;
   yyNBasePtr		: ARRAY yyLastReadState+1	OF yyNCombTypePtr;
   yyDefault		: ARRAY yyLastReadState+1	OF yyReadRange	;
   yyTComb		: ARRAY yyTableMax+1 OF yyTCombType	;
   yyNComb		: ARRAY yyNTableMax-yyLastTerminal+2 OF yyNCombType	;
   yyLength		: ARRAY yyLastReduceState-yyFirstReduceState+1 OF yyTableElmt	;
   yyLeftHandSide	: ARRAY yyLastReduceState-yyFirstReduceState+1 OF yySymbolRange;
   yyContinuation	: ARRAY yyLastReadState+1	OF yySymbolRange;
   yyFinalToProd	: ARRAY yyLastReadNontermState-yyFirstReadTermState+1 OF yyReduceRange;
   yyIsInitialized	: BOOLEAN;
   yyTableFile		: System.tFile;

PROCEDURE^Next (State: yyStateRange; Symbol: yySymbolRange): yyStateRange;
PROCEDURE^BeginParser;
PROCEDURE^ErrorRecovery (
      VAR Terminal	: yySymbolRange	;
	  StateStack	: yyStackType	;
	  StackSize	: LONGINT	;
	  StackPtr	: LONGINT	);
PROCEDURE^ComputeContinuation (
	  Stack		: yyStackType	;
	  StackSize	: LONGINT	;
	  StackPtr	: LONGINT	;
      VAR ContinueSet	: Sets.tSet	);
PROCEDURE^ComputeRestartPoints (
	  ParseStack	: yyStackType	;
	  StackSize	: LONGINT	;
	  StackPtr	: LONGINT	;
      VAR RestartSet	: Sets.tSet	);
PROCEDURE^IsContinuation (
      Terminal		: yySymbolRange	;
      ParseStack	: yyStackType	;
      StackSize		: LONGINT	;
      StackPtr		: LONGINT	): BOOLEAN;
PROCEDURE^yyErrorCheck (ErrorCode:LONGINT; Info:LONGINT);
PROCEDURE^yyGetTable (Address: SYSTEM.PTR): LONGINT;

PROCEDURE TokenName* (Token: LONGINT; VAR Name: ARRAY OF CHAR);
   PROCEDURE Copy (Source: ARRAY OF CHAR; VAR Target: ARRAY OF CHAR);
      VAR i, j: LONGINT;
      BEGIN
	 IF LEN(Source) < LEN(Target)
	 THEN j := LEN(Source); ELSE j := LEN(Target); END;
	 FOR i := 0 TO j DO Target [i] := Source [i]; END;
	 IF LEN(Target) > j THEN Target [j + 1] := CHR (0); END;
      END Copy;
   BEGIN
      CASE Token OF
      | 0: Copy ("_EndOfFile", Name);
      | 1: Copy ("ident", Name);
      | 2: Copy ("integer", Name);
      | 3: Copy ("real", Name);
      | 4: Copy ("longreal", Name);
      | 5: Copy ("character", Name);
      | 6: Copy ("string", Name);
      | 7: Copy ('+', Name);
      | 8: Copy ('-', Name);
      | 9: Copy ('*', Name);
      | 10: Copy ('/', Name);
      | 11: Copy ('~', Name);
      | 12: Copy ('&', Name);
      | 13: Copy ('.', Name);
      | 14: Copy (',', Name);
      | 15: Copy (';', Name);
      | 16: Copy ('|', Name);
      | 17: Copy ('(', Name);
      | 18: Copy (')', Name);
      | 19: Copy ('[', Name);
      | 20: Copy (']', Name);
      | 21: Copy ('{', Name);
      | 22: Copy ('}', Name);
      | 23: Copy (':=', Name);
      | 24: Copy ('^', Name);
      | 25: Copy ('=', Name);
      | 26: Copy ('#', Name);
      | 27: Copy ('<', Name);
      | 28: Copy ('>', Name);
      | 29: Copy ('<=', Name);
      | 30: Copy ('>=', Name);
      | 31: Copy ('..', Name);
      | 32: Copy (':', Name);
      | 33: Copy ("ARRAY", Name);
      | 34: Copy ('BEGIN', Name);
      | 35: Copy ("BY", Name);
      | 36: Copy ("CASE", Name);
      | 37: Copy ("CONST", Name);
      | 38: Copy ("DIV", Name);
      | 39: Copy ("DO", Name);
      | 40: Copy ("ELSE", Name);
      | 41: Copy ("ELSIF", Name);
      | 42: Copy ("END", Name);
      | 43: Copy ("EXIT", Name);
      | 44: Copy ("FOREIGN", Name);
      | 45: Copy ("FOR", Name);
      | 46: Copy ("IF", Name);
      | 47: Copy ("IMPORT", Name);
      | 48: Copy ("IN", Name);
      | 49: Copy ("IS", Name);
      | 50: Copy ("LOOP", Name);
      | 51: Copy ("MOD", Name);
      | 52: Copy ("MODULE", Name);
      | 53: Copy ("NIL", Name);
      | 54: Copy ("OF", Name);
      | 55: Copy ("OR", Name);
      | 56: Copy ("POINTER", Name);
      | 57: Copy ("PROCEDURE", Name);
      | 58: Copy ("RECORD", Name);
      | 59: Copy ("REPEAT", Name);
      | 60: Copy ("RETURN", Name);
      | 61: Copy ("THEN", Name);
      | 62: Copy ("TO", Name);
      | 63: Copy ("TYPE", Name);
      | 64: Copy ("UNTIL", Name);
      | 65: Copy ("VAR", Name);
      | 66: Copy ("WHILE", Name);
      | 67: Copy ("WITH", Name);
      END;
   END TokenName;

PROCEDURE Parser* (): LONGINT;

   VAR
      yyState		: yyStateRange;
      yyTerminal	: yySymbolRange;
      yyNonterminal	: yySymbolRange;	(* left-hand side symbol *)
      yyStackPtr	: yyTableElmt;
      yyStateStackSize	: LONGINT;
      yyAttrStackSize	: LONGINT;
      yyShortStackSize	: yyTableElmt;
      yyStateStack	: yyStackType;
      yyAttributeStack	: POINTER TO ARRAY 10 OF tParsAttribute;
      yySynAttribute	: tParsAttribute;	(* synthesized attribute *)
      yyRepairAttribute : Scanner.tScanAttribute;
      yyRepairToken	: yySymbolRange;
      yyTCombPtr	: yyTCombTypePtr;
      yyNCombPtr	: yyNCombTypePtr;
      yyIsRepairing	: BOOLEAN;
      yyErrorCount	: LONGINT;
      yyTokenString	: ARRAY 128 OF CHAR;
   BEGIN
      BeginParser;
      yyState		:= yyStartState;
      yyTerminal	:= Scanner.GetToken ();
      yyStateStackSize	:= yyInitStackSize;
      yyAttrStackSize	:= yyInitStackSize;
      DynArray.MakeArray (yyStateStack, yyStateStackSize, SIZE (yyStateRange));
      DynArray.MakeArray (yyAttributeStack, yyAttrStackSize, SIZE (tParsAttribute));
      yyShortStackSize	:= SHORT(yyStateStackSize) - 1;
      yyStackPtr	:= 0;
      yyErrorCount	:= 0;
      yyIsRepairing	:= FALSE;

      LOOP
	 IF yyStackPtr >= yyShortStackSize THEN
	    DynArray.ExtendArray (yyStateStack, yyStateStackSize, SIZE (yyStateRange));
	    DynArray.ExtendArray (yyAttributeStack, yyAttrStackSize, SIZE (tParsAttribute));
	    yyShortStackSize := SHORT(yyStateStackSize) - 1;
	 END;
	 yyStateStack^ [yyStackPtr] := yyState;

	 LOOP	(* SPEC State := Next (State, Terminal); terminal transition *)
	    yyTCombPtr := SYSTEM.VAL(yyTCombTypePtr,(SYSTEM.VAL(LONGINT,yyTBasePtr [yyState]) 
			     + yyTerminal * SIZE (yyTCombType)));
	    IF yyTCombPtr^.Check = yyState THEN
	       yyState := yyTCombPtr^.Next;
	       EXIT;
	    END;
	    yyState := yyDefault [yyState];

	    IF yyState = yyNoState THEN			(* syntax error *)
	       yyState := yyStateStack^ [yyStackPtr];
	       IF yyIsRepairing THEN			(* repair *)
		  yyRepairToken := yyContinuation [yyState];
		  yyState := Next (yyState, yyRepairToken);
		  IF yyState <= yyLastReadTermState THEN (* read or read terminal reduce ? *)
		     Scanner.ErrorAttribute (yyRepairToken, yyRepairAttribute);
		     TokenName (yyRepairToken, yyTokenString);
		     Errors.ErrorMessageI (Errors.TokenInserted, Errors.Repair,
			Scanner.Attribute.Position, Errors.Array, SYSTEM.VAL(SYSTEM.PTR,SYSTEM.ADR (yyTokenString)));
		     IF yyState >= yyFirstFinalState THEN (* avoid second push *)
			yyState := yyFinalToProd [yyState];
		     END;
		     INC (yyStackPtr);
		     yyAttributeStack^ [yyStackPtr].Scan := yyRepairAttribute;
		     yyStateStack^     [yyStackPtr] := yyState;
		  END;
		  IF yyState >= yyFirstFinalState THEN	(* final state ? *)
		    EXIT;
		  END;
	       ELSE					(* report and recover *)
		  INC (yyErrorCount);
		  ErrorRecovery (yyTerminal, yyStateStack, yyStateStackSize, yyStackPtr);
		  yyIsRepairing := TRUE;
	       END;
	    END;
	 END;

	 IF yyState >= yyFirstFinalState THEN		(* final state ? *)
	    IF yyState <= yyLastReadTermState THEN	(* read terminal reduce ? *)
	       INC (yyStackPtr);
	       yyAttributeStack^ [yyStackPtr].Scan := Scanner.Attribute;
	       yyTerminal := Scanner.GetToken ();
	       yyIsRepairing := FALSE;
	    END;

	    LOOP					(* reduce *)
CASE yyState OF
  | 342: (* _0000_ : Module _EndOfFile .*)
  DynArray.ReleaseArray (yyStateStack, yyStateStackSize, SIZE (yyTableElmt));
  DynArray.ReleaseArray (yyAttributeStack, yyAttrStackSize, SIZE (tParsAttribute));
  RETURN yyErrorCount;

  | 343,262: (* Module : MODULE ident ';' ImportList DeclSection BeginStmts END ident '.' .*)
  DEC (yyStackPtr, 9); yyNonterminal := 71;
(* line 90 "/tmp/lalr1303" *)
  (* line 61 oberon.lal *)
   Base.ActP^.TreeRoot      := Tree.mModule
                                                           ((* Name          := *) yyAttributeStack^[yyStackPtr+2].Scan.Ident
                                                           ,(* Pos           := *) yyAttributeStack^[yyStackPtr+2].Scan.Position
                                                           ,(* IsForeign     := *) FALSE
                                                           ,(* Imports       := *) yyAttributeStack^[yyStackPtr+4].Tree
                                                           ,(* DeclSection   := *) yyAttributeStack^[yyStackPtr+5].Tree
                                                           ,(* Stmts         := *) yyAttributeStack^[yyStackPtr+6].Tree
                                                           ,(* Name2         := *) yyAttributeStack^[yyStackPtr+8].Scan.Ident
                                                           ,(* Pos2          := *) yyAttributeStack^[yyStackPtr+8].Scan.Position);
                              
  | 344,257: (* Module : FOREIGN MODULE ident ';' ImportList DeclSection BeginStmts END ident '.' .*)
  DEC (yyStackPtr, 10); yyNonterminal := 71;
(* line 103 "/tmp/lalr1303" *)
  (* line 81 oberon.lal *)
   Base.ActP^.TreeRoot      := Tree.mModule
                                                           ((* Name          := *) yyAttributeStack^[yyStackPtr+3].Scan.Ident
                                                           ,(* Pos           := *) yyAttributeStack^[yyStackPtr+3].Scan.Position
                                                           ,(* IsForeign     := *) TRUE
                                                           ,(* Imports       := *) yyAttributeStack^[yyStackPtr+5].Tree
                                                           ,(* DeclSection   := *) yyAttributeStack^[yyStackPtr+6].Tree
                                                           ,(* Stmts         := *) yyAttributeStack^[yyStackPtr+7].Tree
                                                           ,(* Name2         := *) yyAttributeStack^[yyStackPtr+9].Scan.Ident
                                                           ,(* Pos2          := *) yyAttributeStack^[yyStackPtr+9].Scan.Position);
                              
  | 345,215: (* ImportList : IMPORT Import Imports ';' .*)
  DEC (yyStackPtr, 4); yyNonterminal := 68;
(* line 117 "/tmp/lalr1303" *)
  (* line 98 oberon.lal *)
   yyAttributeStack^[yyStackPtr+2].Tree^.Import.Next    := yyAttributeStack^[yyStackPtr+3].Tree;
                                yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+2].Tree;
                              
  | 346: (* ImportList : .*)
  DEC (yyStackPtr, 0); yyNonterminal := 68;
(* line 123 "/tmp/lalr1303" *)
  (* line 102 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mmtImport();
                              
  | 347,263: (* Imports : ',' Import Imports .*)
  DEC (yyStackPtr, 3); yyNonterminal := 73;
(* line 129 "/tmp/lalr1303" *)
  (* line 110 oberon.lal *)
   yyAttributeStack^[yyStackPtr+2].Tree^.Import.Next    := yyAttributeStack^[yyStackPtr+3].Tree;
                                yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+2].Tree;
                              
  | 348: (* Imports : .*)
  DEC (yyStackPtr, 0); yyNonterminal := 73;
(* line 135 "/tmp/lalr1303" *)
  (* line 114 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mmtImport();
                              
  | 349: (* Import : ident .*)
  DEC (yyStackPtr, 1); yyNonterminal := 72;
(* line 141 "/tmp/lalr1303" *)
  (* line 120 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mImport
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* ServerId      := *) yyAttributeStack^[yyStackPtr+1].Scan.Ident
                                                           ,(* ServerPos     := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* RefId         := *) yyAttributeStack^[yyStackPtr+1].Scan.Ident
                                                           ,(* RefPos        := *) yyAttributeStack^[yyStackPtr+1].Scan.Position);
                              
  | 350,214: (* Import : ident ':=' ident .*)
  DEC (yyStackPtr, 3); yyNonterminal := 72;
(* line 151 "/tmp/lalr1303" *)
  (* line 130 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mImport
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* ServerId      := *) yyAttributeStack^[yyStackPtr+3].Scan.Ident
                                                           ,(* ServerPos     := *) yyAttributeStack^[yyStackPtr+3].Scan.Position
                                                           ,(* RefId         := *) yyAttributeStack^[yyStackPtr+1].Scan.Ident
                                                           ,(* RefPos        := *) yyAttributeStack^[yyStackPtr+1].Scan.Position);
                              
  | 351,340: (* DeclSection : DeclUnits ProcDecls .*)
  DEC (yyStackPtr, 2); yyNonterminal := 69;
(* line 162 "/tmp/lalr1303" *)
  (* line 142 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mDeclSection
                                                           ((* DeclUnits     := *) yyAttributeStack^[yyStackPtr+1].Tree
                                                           ,(* Procs         := *) yyAttributeStack^[yyStackPtr+2].Tree);
                              
  | 352,339: (* DeclUnits : DeclUnit DeclUnits .*)
  DEC (yyStackPtr, 2); yyNonterminal := 74;
(* line 170 "/tmp/lalr1303" *)
  (* line 151 oberon.lal *)
   yyAttributeStack^[yyStackPtr+1].Tree^.DeclUnit.Next  := yyAttributeStack^[yyStackPtr+2].Tree;
                                yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 353: (* DeclUnits : .*)
  DEC (yyStackPtr, 0); yyNonterminal := 74;
(* line 176 "/tmp/lalr1303" *)
  (* line 155 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mmtDeclUnit();
                              
  | 354,264: (* DeclUnit : CONST ConstDecls .*)
  DEC (yyStackPtr, 2); yyNonterminal := 76;
(* line 182 "/tmp/lalr1303" *)
  (* line 162 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mDeclUnit
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* Decls         := *) yyAttributeStack^[yyStackPtr+2].Tree);
                              
  | 355,283: (* DeclUnit : TYPE TypeDecls .*)
  DEC (yyStackPtr, 2); yyNonterminal := 76;
(* line 189 "/tmp/lalr1303" *)
  (* line 168 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mDeclUnit
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* Decls         := *) yyAttributeStack^[yyStackPtr+2].Tree);
                              
  | 356,308: (* DeclUnit : VAR VarDecls .*)
  DEC (yyStackPtr, 2); yyNonterminal := 76;
(* line 196 "/tmp/lalr1303" *)
  (* line 174 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mDeclUnit
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* Decls         := *) yyAttributeStack^[yyStackPtr+2].Tree);
                              
  | 357,265: (* ConstDecls : ConstDecl ';' ConstDecls .*)
  DEC (yyStackPtr, 3); yyNonterminal := 77;
(* line 204 "/tmp/lalr1303" *)
  (* line 184 oberon.lal *)
   yyAttributeStack^[yyStackPtr+1].Tree^.ConstDecl.Next := yyAttributeStack^[yyStackPtr+3].Tree;
                                yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 358: (* ConstDecls : .*)
  DEC (yyStackPtr, 0); yyNonterminal := 77;
(* line 210 "/tmp/lalr1303" *)
  (* line 188 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mmtDecl();
                              
  | 359,284: (* TypeDecls : TypeDecl ';' TypeDecls .*)
  DEC (yyStackPtr, 3); yyNonterminal := 78;
(* line 216 "/tmp/lalr1303" *)
  (* line 196 oberon.lal *)
   yyAttributeStack^[yyStackPtr+1].Tree^.TypeDecl.Next  := yyAttributeStack^[yyStackPtr+3].Tree;
                                yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 360: (* TypeDecls : .*)
  DEC (yyStackPtr, 0); yyNonterminal := 78;
(* line 222 "/tmp/lalr1303" *)
  (* line 200 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mmtDecl();
                              
  | 361,309: (* VarDecls : VarDecl ';' VarDecls .*)
  DEC (yyStackPtr, 3); yyNonterminal := 79;
(* line 228 "/tmp/lalr1303" *)
  (* line 208 oberon.lal *)
   yyAttributeStack^[yyStackPtr+1].Tree^.VarDecl.Next   := yyAttributeStack^[yyStackPtr+3].Tree;
                                yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 362: (* VarDecls : .*)
  DEC (yyStackPtr, 0); yyNonterminal := 79;
(* line 234 "/tmp/lalr1303" *)
  (* line 212 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mmtDecl();
                              
  | 363,281: (* ConstDecl : IdentDef '=' ConstExpr .*)
  DEC (yyStackPtr, 3); yyNonterminal := 80;
(* line 240 "/tmp/lalr1303" *)
  (* line 220 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mConstDecl
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* IdentDef      := *) yyAttributeStack^[yyStackPtr+1].Tree
                                                           ,(* ConstExpr     := *) yyAttributeStack^[yyStackPtr+3].Tree);
                              
  | 364,307: (* TypeDecl : IdentDef '=' Type .*)
  DEC (yyStackPtr, 3); yyNonterminal := 81;
(* line 249 "/tmp/lalr1303" *)
  (* line 231 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mTypeDecl
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* IdentDef      := *) yyAttributeStack^[yyStackPtr+1].Tree
                                                           ,(* Type          := *) yyAttributeStack^[yyStackPtr+3].Tree);
                              
  | 365,310: (* VarDecl : IdentList ':' Type .*)
  DEC (yyStackPtr, 3); yyNonterminal := 82;
(* line 258 "/tmp/lalr1303" *)
  (* line 242 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mVarDecl
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* IdentLists    := *) yyAttributeStack^[yyStackPtr+1].Tree
                                                           ,(* Type          := *) yyAttributeStack^[yyStackPtr+3].Tree);
                              
  | 366,341: (* ProcDecls : ProcDecl ';' ProcDecls .*)
  DEC (yyStackPtr, 3); yyNonterminal := 75;
(* line 267 "/tmp/lalr1303" *)
  (* line 253 oberon.lal *)
   yyAttributeStack^[yyStackPtr+1].Tree^.Proc.Next      := yyAttributeStack^[yyStackPtr+3].Tree;
                                yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 367: (* ProcDecls : .*)
  DEC (yyStackPtr, 0); yyNonterminal := 75;
(* line 273 "/tmp/lalr1303" *)
  (* line 257 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mmtDecl();
                              
  | 368,260: (* ProcDecl : PROCEDURE IdentDef FormalPars ';' DeclSection BeginStmts END ident .*)
  DEC (yyStackPtr, 8); yyNonterminal := 87;
(* line 279 "/tmp/lalr1303" *)
  (* line 270 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mProcDecl
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* IdentDef      := *) yyAttributeStack^[yyStackPtr+2].Tree
                                                           ,(* FormalPars    := *) yyAttributeStack^[yyStackPtr+3].Tree
                                                           ,(* DeclSection   := *) yyAttributeStack^[yyStackPtr+5].Tree
                                                           ,(* Stmts         := *) yyAttributeStack^[yyStackPtr+6].Tree
                                                           ,(* EndPos        := *) yyAttributeStack^[yyStackPtr+7].Scan.Position
                                                           ,(* Ident         := *) yyAttributeStack^[yyStackPtr+8].Scan.Ident
                                                           ,(* IdPos         := *) yyAttributeStack^[yyStackPtr+8].Scan.Position);
                              
  | 369,337: (* ProcDecl : PROCEDURE '^' IdentDef FormalPars .*)
  DEC (yyStackPtr, 4); yyNonterminal := 87;
(* line 292 "/tmp/lalr1303" *)
  (* line 284 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mForwardDecl
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* IdentDef      := *) yyAttributeStack^[yyStackPtr+3].Tree
                                                           ,(* FormalPars    := *) yyAttributeStack^[yyStackPtr+4].Tree);
                              
  | 370,261: (* ProcDecl : PROCEDURE Receiver IdentDef FormalPars ';' DeclSection BeginStmts END ident .*)
  DEC (yyStackPtr, 9); yyNonterminal := 87;
(* line 300 "/tmp/lalr1303" *)
  (* line 298 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mBoundProcDecl
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* Receiver      := *) yyAttributeStack^[yyStackPtr+2].Tree
                                                           ,(* IdentDef      := *) yyAttributeStack^[yyStackPtr+3].Tree
                                                           ,(* FormalPars    := *) yyAttributeStack^[yyStackPtr+4].Tree
                                                           ,(* DeclSection   := *) yyAttributeStack^[yyStackPtr+6].Tree
                                                           ,(* Stmts         := *) yyAttributeStack^[yyStackPtr+7].Tree
                                                           ,(* EndPos        := *) yyAttributeStack^[yyStackPtr+8].Scan.Position
                                                           ,(* Ident         := *) yyAttributeStack^[yyStackPtr+9].Scan.Ident
                                                           ,(* IdPos         := *) yyAttributeStack^[yyStackPtr+8].Scan.Position);
                              
  | 371,338: (* ProcDecl : PROCEDURE '^' Receiver IdentDef FormalPars .*)
  DEC (yyStackPtr, 5); yyNonterminal := 87;
(* line 314 "/tmp/lalr1303" *)
  (* line 314 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mBoundForwardDecl
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* Receiver      := *) yyAttributeStack^[yyStackPtr+3].Tree
                                                           ,(* IdentDef      := *) yyAttributeStack^[yyStackPtr+4].Tree
                                                           ,(* FormalPars    := *) yyAttributeStack^[yyStackPtr+5].Tree);
                              
  | 372,288: (* FormalPars : '(' ')' FormalResult .*)
  DEC (yyStackPtr, 3); yyNonterminal := 88;
(* line 324 "/tmp/lalr1303" *)
  (* line 326 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mFormalPars
                                                           ((* FPSections    := *) Tree.mmtFPSection()
                                                           ,(* Type          := *) yyAttributeStack^[yyStackPtr+3].Tree);
                              
  | 373,296: (* FormalPars : '(' FPSections ')' FormalResult .*)
  DEC (yyStackPtr, 4); yyNonterminal := 88;
(* line 331 "/tmp/lalr1303" *)
  (* line 334 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mFormalPars
                                                           ((* FPSections    := *) yyAttributeStack^[yyStackPtr+2].Tree
                                                           ,(* Type          := *) yyAttributeStack^[yyStackPtr+4].Tree);
                              
  | 374: (* FormalPars : .*)
  DEC (yyStackPtr, 0); yyNonterminal := 88;
(* line 338 "/tmp/lalr1303" *)
  (* line 339 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mFormalPars
                                                           ((* FPSections    := *) Tree.mmtFPSection()
                                                           ,(* Type          := *) Tree.mmtType
                                                                                   ((* Position := *) POS.NoPosition)
                                                           );
                              
  | 375,297: (* FPSections : FPSection ';' FPSections .*)
  DEC (yyStackPtr, 3); yyNonterminal := 91;
(* line 348 "/tmp/lalr1303" *)
  (* line 351 oberon.lal *)
   yyAttributeStack^[yyStackPtr+1].Tree^.FPSection.Next := yyAttributeStack^[yyStackPtr+3].Tree;
                                yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 376: (* FPSections : FPSection .*)
  DEC (yyStackPtr, 1); yyNonterminal := 91;
(* line 354 "/tmp/lalr1303" *)
  (* line 355 oberon.lal *)
   yyAttributeStack^[yyStackPtr+1].Tree^.FPSection.Next := Tree.mmtFPSection();
                                yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 377,298: (* FPSection : ParIds ':' Type .*)
  DEC (yyStackPtr, 3); yyNonterminal := 92;
(* line 361 "/tmp/lalr1303" *)
  (* line 364 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mFPSection
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* ParMode       := *) OB.VALPAR
                                                           ,(* ParIds        := *) yyAttributeStack^[yyStackPtr+1].Tree
                                                           ,(* Type          := *) yyAttributeStack^[yyStackPtr+3].Tree);
                              
  | 378,289: (* FPSection : VAR ParIds ':' Type .*)
  DEC (yyStackPtr, 4); yyNonterminal := 92;
(* line 370 "/tmp/lalr1303" *)
  (* line 374 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mFPSection
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* ParMode       := *) OB.REFPAR
                                                           ,(* IdentLists    := *) yyAttributeStack^[yyStackPtr+2].Tree
                                                           ,(* Type          := *) yyAttributeStack^[yyStackPtr+4].Tree);
                              
  | 379,286: (* ParIds : ident ',' ParIds .*)
  DEC (yyStackPtr, 3); yyNonterminal := 93;
(* line 380 "/tmp/lalr1303" *)
  (* line 386 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mParId
                                                           ((* Next          := *) yyAttributeStack^[yyStackPtr+3].Tree
                                                           ,(* Ident         := *) yyAttributeStack^[yyStackPtr+1].Scan.Ident
                                                           ,(* Pos           := *) yyAttributeStack^[yyStackPtr+1].Scan.Position);
                              
  | 380: (* ParIds : ident .*)
  DEC (yyStackPtr, 1); yyNonterminal := 93;
(* line 388 "/tmp/lalr1303" *)
  (* line 392 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mParId
                                                           ((* Next          := *) Tree.mmtParId()
                                                           ,(* Ident         := *) yyAttributeStack^[yyStackPtr+1].Scan.Ident
                                                           ,(* Pos           := *) yyAttributeStack^[yyStackPtr+1].Scan.Position);
                              
  | 381,287: (* FormalResult : ':' Qualident .*)
  DEC (yyStackPtr, 2); yyNonterminal := 90;
(* line 397 "/tmp/lalr1303" *)
  (* line 402 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mNamedType
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+2].Tree^.Qualidents.Position
                                                           ,(* Qualidents    := *) yyAttributeStack^[yyStackPtr+2].Tree);
                              
  | 382: (* FormalResult : .*)
  DEC (yyStackPtr, 0); yyNonterminal := 90;
(* line 404 "/tmp/lalr1303" *)
  (* line 407 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mmtType
                                                           ((* Position      := *) POS.NoPosition);
                              
  | 383,258: (* Receiver : '(' ident ':' ident ')' .*)
  DEC (yyStackPtr, 5); yyNonterminal := 89;
(* line 411 "/tmp/lalr1303" *)
  (* line 418 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mReceiver
                                                           ((* ParMode       := *) OB.VALPAR
                                                           ,(* Name          := *) yyAttributeStack^[yyStackPtr+2].Scan.Ident
                                                           ,(* TypeIdent     := *) yyAttributeStack^[yyStackPtr+4].Scan.Ident
                                                           ,(* TypePos       := *) yyAttributeStack^[yyStackPtr+4].Scan.Position);
                              
  | 384,259: (* Receiver : '(' VAR ident ':' ident ')' .*)
  DEC (yyStackPtr, 6); yyNonterminal := 89;
(* line 420 "/tmp/lalr1303" *)
  (* line 430 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mReceiver
                                                           ((* ParMode       := *) OB.REFPAR
                                                           ,(* Name          := *) yyAttributeStack^[yyStackPtr+3].Scan.Ident
                                                           ,(* TypeIdent     := *) yyAttributeStack^[yyStackPtr+5].Scan.Ident
                                                           ,(* TypePos       := *) yyAttributeStack^[yyStackPtr+5].Scan.Position);
                              
  | 385,290: (* Type : Qualident .*)
  DEC (yyStackPtr, 1); yyNonterminal := 85;
(* line 430 "/tmp/lalr1303" *)
  (* line 440 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mNamedType
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Tree^.Qualidents.Position
                                                           ,(* Qualidents    := *) yyAttributeStack^[yyStackPtr+1].Tree);
                              
  | 386,291: (* Type : PointerBaseType .*)
  DEC (yyStackPtr, 1); yyNonterminal := 85;
(* line 437 "/tmp/lalr1303" *)
  (* line 445 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 387,292: (* Type : PointerType .*)
  DEC (yyStackPtr, 1); yyNonterminal := 85;
(* line 442 "/tmp/lalr1303" *)
  (* line 448 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 388,293: (* Type : ProcedureType .*)
  DEC (yyStackPtr, 1); yyNonterminal := 85;
(* line 447 "/tmp/lalr1303" *)
  (* line 451 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 389,294: (* PointerBaseType : ArrayType .*)
  DEC (yyStackPtr, 1); yyNonterminal := 95;
(* line 453 "/tmp/lalr1303" *)
  (* line 457 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 390,295: (* PointerBaseType : RecordType .*)
  DEC (yyStackPtr, 1); yyNonterminal := 95;
(* line 458 "/tmp/lalr1303" *)
  (* line 460 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 391,306: (* ArrayType : ARRAY ArrayExprList OF Type .*)
  DEC (yyStackPtr, 4); yyNonterminal := 98;
(* line 464 "/tmp/lalr1303" *)
  (* line 469 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mArrayType
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* ArrayExprList := *) yyAttributeStack^[yyStackPtr+2].Tree
                                                           ,(* Type          := *) yyAttributeStack^[yyStackPtr+4].Tree);
                              
  | 392,304: (* ArrayType : ARRAY OF Type .*)
  DEC (yyStackPtr, 3); yyNonterminal := 98;
(* line 472 "/tmp/lalr1303" *)
  (* line 477 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mOpenArrayType
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* OfPosition    := *) yyAttributeStack^[yyStackPtr+2].Scan.Position
                                                           ,(* Type          := *) yyAttributeStack^[yyStackPtr+3].Tree);
                              
  | 393,305: (* ArrayExprList : ConstExpr ',' ArrayExprList .*)
  DEC (yyStackPtr, 3); yyNonterminal := 100;
(* line 481 "/tmp/lalr1303" *)
  (* line 488 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mArrayExprList
                                                           ((* Next          := *) yyAttributeStack^[yyStackPtr+3].Tree
                                                           ,(* ConstExpr     := *) yyAttributeStack^[yyStackPtr+1].Tree);
                              
  | 394: (* ArrayExprList : ConstExpr .*)
  DEC (yyStackPtr, 1); yyNonterminal := 100;
(* line 488 "/tmp/lalr1303" *)
  (* line 493 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mArrayExprList
                                                           ((* Next          := *) Tree.mmtArrayExprList()
                                                           ,(* ConstExpr     := *) yyAttributeStack^[yyStackPtr+1].Tree);
                              
  | 395,244: (* RecordType : RECORD '(' Qualident ')' FieldLists END .*)
  DEC (yyStackPtr, 6); yyNonterminal := 99;
(* line 496 "/tmp/lalr1303" *)
  (* line 506 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mExtendedType
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Qualidents    := *) yyAttributeStack^[yyStackPtr+3].Tree
                                                           ,(* FieldLists    := *) yyAttributeStack^[yyStackPtr+5].Tree);
                              
  | 396,245: (* RecordType : RECORD FieldLists END .*)
  DEC (yyStackPtr, 3); yyNonterminal := 99;
(* line 504 "/tmp/lalr1303" *)
  (* line 514 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mRecordType
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* FieldLists    := *) yyAttributeStack^[yyStackPtr+2].Tree);
                              
  | 397,302: (* FieldLists : FieldList ';' FieldLists .*)
  DEC (yyStackPtr, 3); yyNonterminal := 101;
(* line 512 "/tmp/lalr1303" *)
  (* line 524 oberon.lal *)
   yyAttributeStack^[yyStackPtr+1].Tree^.FieldList.Next := yyAttributeStack^[yyStackPtr+3].Tree;
                                yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 398,301: (* FieldLists : ';' FieldLists .*)
  DEC (yyStackPtr, 2); yyNonterminal := 101;
(* line 518 "/tmp/lalr1303" *)
  (* line 529 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+2].Tree;
                              
  | 399: (* FieldLists : FieldList .*)
  DEC (yyStackPtr, 1); yyNonterminal := 101;
(* line 523 "/tmp/lalr1303" *)
  (* line 532 oberon.lal *)
   yyAttributeStack^[yyStackPtr+1].Tree^.FieldList.Next := Tree.mmtFieldList();
                                yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 400: (* FieldLists : .*)
  DEC (yyStackPtr, 0); yyNonterminal := 101;
(* line 529 "/tmp/lalr1303" *)
  (* line 536 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mmtFieldList();
                              
  | 401,300: (* FieldList : IdentList ':' Type .*)
  DEC (yyStackPtr, 3); yyNonterminal := 102;
(* line 535 "/tmp/lalr1303" *)
  (* line 544 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mFieldList
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* IdentLists    := *) yyAttributeStack^[yyStackPtr+1].Tree
                                                           ,(* Type          := *) yyAttributeStack^[yyStackPtr+3].Tree);
                              
  | 402: (* PointerType : POINTER TO ident .*)
  DEC (yyStackPtr, 3); yyNonterminal := 96;
(* line 544 "/tmp/lalr1303" *)
  (* line 555 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mPointerToIdType
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Ident         := *) yyAttributeStack^[yyStackPtr+3].Scan.Ident
                                                           ,(* IdentPos      := *) yyAttributeStack^[yyStackPtr+3].Scan.Position);
                              
  | 403,243: (* PointerType : POINTER TO ident '.' ident .*)
  DEC (yyStackPtr, 5); yyNonterminal := 96;
(* line 552 "/tmp/lalr1303" *)
  (* line 564 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mPointerToQualIdType
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Qualidents    := *) Tree.mQualifiedIdent
                                                                                   ((* Position := *) yyAttributeStack^[yyStackPtr+3].Scan.Position
                                                                                   ,(* ServerId := *) yyAttributeStack^[yyStackPtr+3].Scan.Ident
                                                                                   ,(* Ident    := *) yyAttributeStack^[yyStackPtr+5].Scan.Ident
                                                                                   ,(* IdentPos := *) yyAttributeStack^[yyStackPtr+5].Scan.Position
                                                                                   )
                                                           );
                              
  | 404,303: (* PointerType : POINTER TO PointerBaseType .*)
  DEC (yyStackPtr, 3); yyNonterminal := 96;
(* line 565 "/tmp/lalr1303" *)
  (* line 576 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mPointerToStructType
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Type          := *) yyAttributeStack^[yyStackPtr+3].Tree);
                              
  | 405,299: (* ProcedureType : PROCEDURE FormalPars .*)
  DEC (yyStackPtr, 2); yyNonterminal := 97;
(* line 573 "/tmp/lalr1303" *)
  (* line 585 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mProcedureType
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* FormalPars    := *) yyAttributeStack^[yyStackPtr+2].Tree);
                              
  | 406,336: (* BeginStmts : 'BEGIN' StatementSeq .*)
  DEC (yyStackPtr, 2); yyNonterminal := 70;
(* line 581 "/tmp/lalr1303" *)
  (* line 594 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+2].Tree;
                              
  | 407: (* BeginStmts : .*)
  DEC (yyStackPtr, 0); yyNonterminal := 70;
(* line 586 "/tmp/lalr1303" *)
  (* line 597 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mNoStmts();
                              
  | 408,317: (* StatementSeq : Statement ';' StatementSeq .*)
  DEC (yyStackPtr, 3); yyNonterminal := 103;
(* line 592 "/tmp/lalr1303" *)
  (* line 605 oberon.lal *)
   yyAttributeStack^[yyStackPtr+1].Tree^.Stmt.Next      := yyAttributeStack^[yyStackPtr+3].Tree;
                                yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 409,335: (* StatementSeq : ';' StatementSeq .*)
  DEC (yyStackPtr, 2); yyNonterminal := 103;
(* line 598 "/tmp/lalr1303" *)
  (* line 610 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+2].Tree;
                              
  | 410: (* StatementSeq : Statement .*)
  DEC (yyStackPtr, 1); yyNonterminal := 103;
(* line 603 "/tmp/lalr1303" *)
  (* line 613 oberon.lal *)
   yyAttributeStack^[yyStackPtr+1].Tree^.Stmt.Next      := Tree.mmtStmt();
                                yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 411: (* StatementSeq : .*)
  DEC (yyStackPtr, 0); yyNonterminal := 103;
(* line 609 "/tmp/lalr1303" *)
  (* line 617 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mmtStmt();
                              
  | 412,318: (* Statement : AssignStmt .*)
  DEC (yyStackPtr, 1); yyNonterminal := 104;
(* line 615 "/tmp/lalr1303" *)
  (* line 623 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 413,319: (* Statement : CallStmt .*)
  DEC (yyStackPtr, 1); yyNonterminal := 104;
(* line 620 "/tmp/lalr1303" *)
  (* line 626 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 414,320: (* Statement : IfStmt .*)
  DEC (yyStackPtr, 1); yyNonterminal := 104;
(* line 625 "/tmp/lalr1303" *)
  (* line 629 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 415,321: (* Statement : CaseStmt .*)
  DEC (yyStackPtr, 1); yyNonterminal := 104;
(* line 630 "/tmp/lalr1303" *)
  (* line 632 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 416,322: (* Statement : WhileStmt .*)
  DEC (yyStackPtr, 1); yyNonterminal := 104;
(* line 635 "/tmp/lalr1303" *)
  (* line 635 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 417,323: (* Statement : RepeatStmt .*)
  DEC (yyStackPtr, 1); yyNonterminal := 104;
(* line 640 "/tmp/lalr1303" *)
  (* line 638 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 418,324: (* Statement : ForStmt .*)
  DEC (yyStackPtr, 1); yyNonterminal := 104;
(* line 645 "/tmp/lalr1303" *)
  (* line 641 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 419,325: (* Statement : LoopStmt .*)
  DEC (yyStackPtr, 1); yyNonterminal := 104;
(* line 650 "/tmp/lalr1303" *)
  (* line 644 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 420,326: (* Statement : WithStmt .*)
  DEC (yyStackPtr, 1); yyNonterminal := 104;
(* line 655 "/tmp/lalr1303" *)
  (* line 647 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 421,327: (* Statement : ExitStmt .*)
  DEC (yyStackPtr, 1); yyNonterminal := 104;
(* line 660 "/tmp/lalr1303" *)
  (* line 650 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 422,328: (* Statement : ReturnStmt .*)
  DEC (yyStackPtr, 1); yyNonterminal := 104;
(* line 665 "/tmp/lalr1303" *)
  (* line 653 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 423,329: (* AssignStmt : Designator ':=' Expr .*)
  DEC (yyStackPtr, 3); yyNonterminal := 105;
(* line 671 "/tmp/lalr1303" *)
  (* line 661 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mAssignStmt
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* Designator    := *) yyAttributeStack^[yyStackPtr+1].Tree
                                                           ,(* Exprs         := *) yyAttributeStack^[yyStackPtr+3].Tree);
                              
  | 424: (* CallStmt : Designator .*)
  DEC (yyStackPtr, 1); yyNonterminal := 106;
(* line 680 "/tmp/lalr1303" *)
  (* line 670 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mCallStmt
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* Designator    := *) yyAttributeStack^[yyStackPtr+1].Tree);
                              
  | 425,332: (* IfStmt : IF Expr THEN StatementSeq ElsIfs .*)
  DEC (yyStackPtr, 5); yyNonterminal := 107;
(* line 688 "/tmp/lalr1303" *)
  (* line 682 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mIfStmt
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* Exprs         := *) yyAttributeStack^[yyStackPtr+2].Tree
                                                           ,(* Then          := *) yyAttributeStack^[yyStackPtr+4].Tree
                                                           ,(* Else          := *) yyAttributeStack^[yyStackPtr+5].Tree);
                              
  | 426,331: (* ElsIfs : ELSIF Expr THEN StatementSeq ElsIfs .*)
  DEC (yyStackPtr, 5); yyNonterminal := 118;
(* line 698 "/tmp/lalr1303" *)
  (* line 697 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mIfStmt
                                                           ((* Next          := *) Tree.mmtStmt()              (* An ELSIF has no *)
                                                           ,(* Exprs         := *) yyAttributeStack^[yyStackPtr+2].Tree                     (* next statement. *)
                                                           ,(* Then          := *) yyAttributeStack^[yyStackPtr+4].Tree
                                                           ,(* Else          := *) yyAttributeStack^[yyStackPtr+5].Tree);
                              
  | 427,251: (* ElsIfs : ELSE StatementSeq END .*)
  DEC (yyStackPtr, 3); yyNonterminal := 118;
(* line 707 "/tmp/lalr1303" *)
  (* line 706 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+2].Tree
                              
  | 428,252: (* ElsIfs : END .*)
  DEC (yyStackPtr, 1); yyNonterminal := 118;
(* line 712 "/tmp/lalr1303" *)
  (* line 709 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mmtStmt();
                              
  | 429,255: (* CaseStmt : CASE Expr OF Cases ELSE StatementSeq END .*)
  DEC (yyStackPtr, 7); yyNonterminal := 108;
(* line 718 "/tmp/lalr1303" *)
  (* line 721 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mCaseStmt
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* Exprs         := *) yyAttributeStack^[yyStackPtr+2].Tree
                                                           ,(* Cases         := *) yyAttributeStack^[yyStackPtr+4].Tree
                                                           ,(* Else          := *) yyAttributeStack^[yyStackPtr+6].Tree);
                              
  | 430,256: (* CaseStmt : CASE Expr OF Cases END .*)
  DEC (yyStackPtr, 5); yyNonterminal := 108;
(* line 727 "/tmp/lalr1303" *)
  (* line 732 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mCaseStmt
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* Exprs         := *) yyAttributeStack^[yyStackPtr+2].Tree
                                                           ,(* Cases         := *) yyAttributeStack^[yyStackPtr+4].Tree
                                                           ,(* Else          := *) Tree.mCallStmt
                                                                                   ((* Next       := *) Tree.mmtStmt()
                                                                                   ,(* Designator := *) Tree.mDesignator
                                                                                                        ((* Ident     := *)
                                                                                                         Idents.IdentCASEFAULT
                                                                                                        ,(* Position  := *)
                                                                                                         yyAttributeStack^[yyStackPtr+5].Scan.Position
                                                                                                        ,(* Designors := *)
                                                                                                         Tree.mmtDesignor())
                                                                                   )
                                                           );
                              
  | 431,313: (* Cases : Case '|' Cases .*)
  DEC (yyStackPtr, 3); yyNonterminal := 119;
(* line 747 "/tmp/lalr1303" *)
  (* line 754 oberon.lal *)
   yyAttributeStack^[yyStackPtr+1].Tree^.Case.Next      := yyAttributeStack^[yyStackPtr+3].Tree;
                                yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 432,312: (* Cases : '|' Cases .*)
  DEC (yyStackPtr, 2); yyNonterminal := 119;
(* line 753 "/tmp/lalr1303" *)
  (* line 759 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+2].Tree;
                              
  | 433: (* Cases : Case .*)
  DEC (yyStackPtr, 1); yyNonterminal := 119;
(* line 758 "/tmp/lalr1303" *)
  (* line 762 oberon.lal *)
   yyAttributeStack^[yyStackPtr+1].Tree^.Case.Next      := Tree.mmtCase();
                                yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 434: (* Cases : .*)
  DEC (yyStackPtr, 0); yyNonterminal := 119;
(* line 764 "/tmp/lalr1303" *)
  (* line 766 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mmtCase();
                              
  | 435,333: (* Case : CaseLabelList ':' StatementSeq .*)
  DEC (yyStackPtr, 3); yyNonterminal := 120;
(* line 770 "/tmp/lalr1303" *)
  (* line 774 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mCase
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* CaseLabels    := *) yyAttributeStack^[yyStackPtr+1].Tree
                                                           ,(* Stmts         := *) yyAttributeStack^[yyStackPtr+3].Tree);
                              
  | 436,334: (* CaseLabelList : CaseLabels ',' CaseLabelList .*)
  DEC (yyStackPtr, 3); yyNonterminal := 121;
(* line 779 "/tmp/lalr1303" *)
  (* line 785 oberon.lal *)
   yyAttributeStack^[yyStackPtr+1].Tree^.CaseLabel.Next := yyAttributeStack^[yyStackPtr+3].Tree;
                                yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 437: (* CaseLabelList : CaseLabels .*)
  DEC (yyStackPtr, 1); yyNonterminal := 121;
(* line 785 "/tmp/lalr1303" *)
  (* line 789 oberon.lal *)
   yyAttributeStack^[yyStackPtr+1].Tree^.CaseLabel.Next := Tree.mmtCaseLabel();
                                yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 438,311: (* CaseLabels : ConstExpr '..' ConstExpr .*)
  DEC (yyStackPtr, 3); yyNonterminal := 122;
(* line 792 "/tmp/lalr1303" *)
  (* line 798 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mCaseLabel
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* ConstExpr1    := *) yyAttributeStack^[yyStackPtr+1].Tree
                                                           ,(* ConstExpr2    := *) yyAttributeStack^[yyStackPtr+3].Tree);
                              
  | 439: (* CaseLabels : ConstExpr .*)
  DEC (yyStackPtr, 1); yyNonterminal := 122;
(* line 800 "/tmp/lalr1303" *)
  (* line 804 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mCaseLabel
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* ConstExpr1    := *) yyAttributeStack^[yyStackPtr+1].Tree
                                                           ,(* ConstExpr2    := *) Tree.mConstExpr
                                                                                   ((* Position := *) POS.NoPosition
                                                                                   ,(* Expr     := *) Tree.mmtExpr(POS.NoPosition)
                                                                                   )
                                                           );
                              
  | 440,249: (* WhileStmt : WHILE Expr DO StatementSeq END .*)
  DEC (yyStackPtr, 5); yyNonterminal := 109;
(* line 813 "/tmp/lalr1303" *)
  (* line 821 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mWhileStmt
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* Exprs         := *) yyAttributeStack^[yyStackPtr+2].Tree
                                                           ,(* Stmts         := *) yyAttributeStack^[yyStackPtr+4].Tree);
                              
  | 441,330: (* RepeatStmt : REPEAT StatementSeq UNTIL Expr .*)
  DEC (yyStackPtr, 4); yyNonterminal := 110;
(* line 822 "/tmp/lalr1303" *)
  (* line 833 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mRepeatStmt
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* Stmts         := *) yyAttributeStack^[yyStackPtr+2].Tree
                                                           ,(* Exprs         := *) yyAttributeStack^[yyStackPtr+4].Tree);
                              
  | 442,253: (* ForStmt : FOR ident ':=' Expr TO Expr BY ConstExpr DO StatementSeq END .*)
  DEC (yyStackPtr, 11); yyNonterminal := 111;
(* line 831 "/tmp/lalr1303" *)
  (* line 852 oberon.lal *)
   yySynAttribute.Tree                := Tree.mForStmt
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* Ident         := *) yyAttributeStack^[yyStackPtr+2].Scan.Ident
                                                           ,(* Pos           := *) yyAttributeStack^[yyStackPtr+2].Scan.Position
                                                           ,(* From          := *) yyAttributeStack^[yyStackPtr+4].Tree
                                                           ,(* To            := *) yyAttributeStack^[yyStackPtr+6].Tree
                                                           ,(* By            := *) yyAttributeStack^[yyStackPtr+8].Tree
                                                           ,(* Stmts         := *) yyAttributeStack^[yyStackPtr+10].Tree);
                               
  | 443,254: (* ForStmt : FOR ident ':=' Expr TO Expr DO StatementSeq END .*)
  DEC (yyStackPtr, 9); yyNonterminal := 111;
(* line 843 "/tmp/lalr1303" *)
  (* line 869 oberon.lal *)
   yySynAttribute.Tree                := Tree.mForStmt
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* Ident         := *) yyAttributeStack^[yyStackPtr+2].Scan.Ident
                                                           ,(* Pos           := *) yyAttributeStack^[yyStackPtr+2].Scan.Position
                                                           ,(* From          := *) yyAttributeStack^[yyStackPtr+4].Tree
                                                           ,(* To            := *) yyAttributeStack^[yyStackPtr+6].Tree
                                                           ,(* By            := *) Tree.mConstExpr
                                                                                   ((* Pos  := *) yyAttributeStack^[yyStackPtr+7].Scan.Position
                                                                                   ,(* Expr := *) Tree.mIntConst
                                                                                                  ((* Pos := *) yyAttributeStack^[yyStackPtr+7].Scan.Position
                                                                                                  ,(* Int := *) 1)
                                                                                   )
                                                           ,(* Stmts         := *) yyAttributeStack^[yyStackPtr+8].Tree);
                               
  | 444,250: (* LoopStmt : LOOP StatementSeq END .*)
  DEC (yyStackPtr, 3); yyNonterminal := 112;
(* line 861 "/tmp/lalr1303" *)
  (* line 889 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mLoopStmt
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* Stmts         := *) yyAttributeStack^[yyStackPtr+2].Tree);
                              
  | 445,247: (* WithStmt : WITH Guard DO StatementSeq Guards ELSE StatementSeq END .*)
  DEC (yyStackPtr, 8); yyNonterminal := 113;
(* line 869 "/tmp/lalr1303" *)
  (* line 904 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mWithStmt
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* GuardedStmts  := *) Tree.mGuardedStmt
                                                                                   ((* Next  := *) yyAttributeStack^[yyStackPtr+5].Tree
                                                                                   ,(* Guard := *) yyAttributeStack^[yyStackPtr+2].Tree
                                                                                   ,(* Stmts := *) yyAttributeStack^[yyStackPtr+4].Tree)
                                                           ,(* Else          := *) yyAttributeStack^[yyStackPtr+7].Tree);
                              
  | 446,248: (* WithStmt : WITH Guard DO StatementSeq Guards END .*)
  DEC (yyStackPtr, 6); yyNonterminal := 113;
(* line 880 "/tmp/lalr1303" *)
  (* line 918 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mWithStmt
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* GuardedStmts  := *) Tree.mGuardedStmt
                                                                                   ((* Next       := *) yyAttributeStack^[yyStackPtr+5].Tree
                                                                                   ,(* Guard      := *) yyAttributeStack^[yyStackPtr+2].Tree
                                                                                   ,(* Stmts      := *) yyAttributeStack^[yyStackPtr+4].Tree)
                                                           ,(* Else          := *) Tree.mCallStmt
                                                                                   ((* Next       := *) Tree.mmtStmt()
                                                                                   ,(* Designator := *) Tree.mDesignator
                                                                                                        ((* Ident     := *)
                                                                                                         Idents.IdentWITHFAULT
                                                                                                        ,(* Position  := *)
                                                                                                         yyAttributeStack^[yyStackPtr+6].Scan.Position
                                                                                                        ,(* Designors := *)
                                                                                                         Tree.mmtDesignor())
                                                                                   )
                                                           );
                              
  | 447,316: (* Guards : '|' Guard DO StatementSeq Guards .*)
  DEC (yyStackPtr, 5); yyNonterminal := 124;
(* line 902 "/tmp/lalr1303" *)
  (* line 944 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mGuardedStmt
                                                           ((* Next          := *) yyAttributeStack^[yyStackPtr+5].Tree
                                                           ,(* Guard         := *) yyAttributeStack^[yyStackPtr+2].Tree
                                                           ,(* Stmts         := *) yyAttributeStack^[yyStackPtr+4].Tree);
                              
  | 448: (* Guards : .*)
  DEC (yyStackPtr, 0); yyNonterminal := 124;
(* line 910 "/tmp/lalr1303" *)
  (* line 950 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mmtGuardedStmt();
                              
  | 449,315: (* Guard : Qualident ':' Qualident .*)
  DEC (yyStackPtr, 3); yyNonterminal := 123;
(* line 916 "/tmp/lalr1303" *)
  (* line 958 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mGuard
                                                           ((* Variable      := *) yyAttributeStack^[yyStackPtr+1].Tree
                                                           ,(* OpPos         := *) yyAttributeStack^[yyStackPtr+2].Scan.Position
                                                           ,(* Type          := *) yyAttributeStack^[yyStackPtr+3].Tree);
                              
  | 450,246: (* ExitStmt : EXIT .*)
  DEC (yyStackPtr, 1); yyNonterminal := 114;
(* line 925 "/tmp/lalr1303" *)
  (* line 967 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mExitStmt
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position);
                              
  | 451,314: (* ReturnStmt : RETURN Expr .*)
  DEC (yyStackPtr, 2); yyNonterminal := 115;
(* line 933 "/tmp/lalr1303" *)
  (* line 976 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mReturnStmt
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Exprs         := *) yyAttributeStack^[yyStackPtr+2].Tree);
                              
  | 452: (* ReturnStmt : RETURN .*)
  DEC (yyStackPtr, 1); yyNonterminal := 115;
(* line 941 "/tmp/lalr1303" *)
  (* line 982 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mReturnStmt
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Exprs         := *) Tree.mmtExpr
                                                                                   ((* Position := *) POS.NoPosition)
                                                           );
                              
  | 453,282: (* ConstExpr : Expr .*)
  DEC (yyStackPtr, 1); yyNonterminal := 84;
(* line 952 "/tmp/lalr1303" *)
  (* line 992 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mConstExpr
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Tree^.Exprs.Position
                                                           ,(* Expr          := *) yyAttributeStack^[yyStackPtr+1].Tree);
                              
  | 454: (* Expr : SimpleExpr Relation SimpleExpr .*)
  DEC (yyStackPtr, 3); yyNonterminal := 117;
(* line 960 "/tmp/lalr1303" *)
  (* line 1002 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mDyExpr
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Tree^.Exprs.Position
                                                           ,(* DyOperator    := *) yyAttributeStack^[yyStackPtr+2].Tree
                                                           ,(* Expr1         := *) yyAttributeStack^[yyStackPtr+1].Tree
                                                           ,(* Expr2         := *) yyAttributeStack^[yyStackPtr+3].Tree);
                              
  | 455,266: (* Expr : Designator IS Qualident .*)
  DEC (yyStackPtr, 3); yyNonterminal := 117;
(* line 969 "/tmp/lalr1303" *)
  (* line 1011 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mIsExpr
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Tree^.Designator.Position
                                                           ,(* Variable      := *) yyAttributeStack^[yyStackPtr+1].Tree
                                                           ,(* OpPos         := *) yyAttributeStack^[yyStackPtr+2].Scan.Position
                                                           ,(* TypeId        := *) yyAttributeStack^[yyStackPtr+3].Tree);
                              
  | 456: (* Expr : SimpleExpr .*)
  DEC (yyStackPtr, 1); yyNonterminal := 117;
(* line 978 "/tmp/lalr1303" *)
  (* line 1018 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 457: (* SimpleExpr : SimpleExpr AddOp Term .*)
  DEC (yyStackPtr, 3); yyNonterminal := 125;
(* line 984 "/tmp/lalr1303" *)
  (* line 1026 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mDyExpr
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Tree^.Exprs.Position
                                                           ,(* DyOperator    := *) yyAttributeStack^[yyStackPtr+2].Tree
                                                           ,(* Expr1         := *) yyAttributeStack^[yyStackPtr+1].Tree
                                                           ,(* Expr2         := *) yyAttributeStack^[yyStackPtr+3].Tree);
                              
  | 458: (* SimpleExpr : '+' Term .*)
  DEC (yyStackPtr, 2); yyNonterminal := 125;
(* line 993 "/tmp/lalr1303" *)
  (* line 1034 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mIdentityExpr
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Exprs         := *) yyAttributeStack^[yyStackPtr+2].Tree);
                              
  | 459: (* SimpleExpr : '-' Term .*)
  DEC (yyStackPtr, 2); yyNonterminal := 125;
(* line 1000 "/tmp/lalr1303" *)
  (* line 1040 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mNegateExpr
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Exprs         := *) yyAttributeStack^[yyStackPtr+2].Tree);
                              
  | 460: (* SimpleExpr : Term .*)
  DEC (yyStackPtr, 1); yyNonterminal := 125;
(* line 1007 "/tmp/lalr1303" *)
  (* line 1045 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 461,269: (* Term : Term MulOp Factor .*)
  DEC (yyStackPtr, 3); yyNonterminal := 128;
(* line 1013 "/tmp/lalr1303" *)
  (* line 1053 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mDyExpr
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Tree^.Exprs.Position
                                                           ,(* DyOperator    := *) yyAttributeStack^[yyStackPtr+2].Tree
                                                           ,(* Expr1         := *) yyAttributeStack^[yyStackPtr+1].Tree
                                                           ,(* Expr2         := *) yyAttributeStack^[yyStackPtr+3].Tree);
                              
  | 462,271: (* Term : Factor .*)
  DEC (yyStackPtr, 1); yyNonterminal := 128;
(* line 1022 "/tmp/lalr1303" *)
  (* line 1060 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 463,268: (* Factor : Designator .*)
  DEC (yyStackPtr, 1); yyNonterminal := 130;
(* line 1028 "/tmp/lalr1303" *)
  (* line 1066 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mDesignExpr
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Tree^.Designator.Position
                                                           ,(* Designator    := *) yyAttributeStack^[yyStackPtr+1].Tree);
                              
  | 464,218: (* Factor : integer .*)
  DEC (yyStackPtr, 1); yyNonterminal := 130;
(* line 1035 "/tmp/lalr1303" *)
  (* line 1071 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mIntConst
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Int           := *) yyAttributeStack^[yyStackPtr+1].Scan.Integer);
                              
  | 465,219: (* Factor : real .*)
  DEC (yyStackPtr, 1); yyNonterminal := 130;
(* line 1042 "/tmp/lalr1303" *)
  (* line 1076 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mRealConst
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Real          := *) yyAttributeStack^[yyStackPtr+1].Scan.Real);
                              
  | 466,220: (* Factor : longreal .*)
  DEC (yyStackPtr, 1); yyNonterminal := 130;
(* line 1049 "/tmp/lalr1303" *)
  (* line 1081 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mLongrealConst
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Longreal      := *) yyAttributeStack^[yyStackPtr+1].Scan.Longreal);
                              
  | 467,221: (* Factor : character .*)
  DEC (yyStackPtr, 1); yyNonterminal := 130;
(* line 1056 "/tmp/lalr1303" *)
  (* line 1086 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mCharConst
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Char          := *) yyAttributeStack^[yyStackPtr+1].Scan.Char);
                              
  | 468,222: (* Factor : string .*)
  DEC (yyStackPtr, 1); yyNonterminal := 130;
(* line 1063 "/tmp/lalr1303" *)
  (* line 1091 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mStringConst
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* String        := *) yyAttributeStack^[yyStackPtr+1].Scan.String);
                              
  | 469,224: (* Factor : NIL .*)
  DEC (yyStackPtr, 1); yyNonterminal := 130;
(* line 1070 "/tmp/lalr1303" *)
  (* line 1096 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mNilConst
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position);
                              
  | 470,270: (* Factor : Set .*)
  DEC (yyStackPtr, 1); yyNonterminal := 130;
(* line 1076 "/tmp/lalr1303" *)
  (* line 1100 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 471,242: (* Factor : '(' Expr ')' .*)
  DEC (yyStackPtr, 3); yyNonterminal := 130;
(* line 1081 "/tmp/lalr1303" *)
  (* line 1105 oberon.lal *)
   yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+2].Tree;
                                yySynAttribute.Tree^.Exprs.Position := yyAttributeStack^[yyStackPtr+1].Scan.Position;
                              
  | 472,273: (* Factor : '~' Factor .*)
  DEC (yyStackPtr, 2); yyNonterminal := 130;
(* line 1087 "/tmp/lalr1303" *)
  (* line 1110 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mNotExpr
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Exprs         := *) yyAttributeStack^[yyStackPtr+2].Tree);
                              
  | 473,241: (* Set : '{' Elements '}' .*)
  DEC (yyStackPtr, 3); yyNonterminal := 131;
(* line 1095 "/tmp/lalr1303" *)
  (* line 1120 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mSetExpr
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Elements      := *) yyAttributeStack^[yyStackPtr+2].Tree);
                              
  | 474,223: (* Set : '{' '}' .*)
  DEC (yyStackPtr, 2); yyNonterminal := 131;
(* line 1102 "/tmp/lalr1303" *)
  (* line 1126 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mSetConst
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Set           := *) OT.EmptySet);
                              
  | 475,272: (* Elements : Element ',' Elements .*)
  DEC (yyStackPtr, 3); yyNonterminal := 132;
(* line 1110 "/tmp/lalr1303" *)
  (* line 1136 oberon.lal *)
   yyAttributeStack^[yyStackPtr+1].Tree^.Element.Next   := yyAttributeStack^[yyStackPtr+3].Tree;
                                yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 476: (* Elements : Element .*)
  DEC (yyStackPtr, 1); yyNonterminal := 132;
(* line 1116 "/tmp/lalr1303" *)
  (* line 1140 oberon.lal *)
   yyAttributeStack^[yyStackPtr+1].Tree^.Element.Next   := Tree.mmtElement();
                                yySynAttribute.Tree                 := yyAttributeStack^[yyStackPtr+1].Tree;
                              
  | 477,267: (* Element : Expr '..' Expr .*)
  DEC (yyStackPtr, 3); yyNonterminal := 133;
(* line 1123 "/tmp/lalr1303" *)
  (* line 1150 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mElement
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* Expr1         := *) yyAttributeStack^[yyStackPtr+1].Tree
                                                           ,(* Expr2         := *) yyAttributeStack^[yyStackPtr+3].Tree);
                              
  | 478: (* Element : Expr .*)
  DEC (yyStackPtr, 1); yyNonterminal := 133;
(* line 1131 "/tmp/lalr1303" *)
  (* line 1156 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mElement
                                                           ((* Next          := *) Tree.NoTree
                                                           ,(* Expr1         := *) yyAttributeStack^[yyStackPtr+1].Tree
                                                           ,(* Expr2         := *) Tree.mmtExpr
                                                                                   ((* Position := *) POS.NoPosition)
                                                           );
                              
  | 479,228: (* Relation : '=' .*)
  DEC (yyStackPtr, 1); yyNonterminal := 126;
(* line 1142 "/tmp/lalr1303" *)
  (* line 1167 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mEqualOper
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Operator      := *) Tree.EqualOper);
                              
  | 480,229: (* Relation : '#' .*)
  DEC (yyStackPtr, 1); yyNonterminal := 126;
(* line 1149 "/tmp/lalr1303" *)
  (* line 1172 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mUnequalOper
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Operator      := *) Tree.UnequalOper);
                              
  | 481,230: (* Relation : '<' .*)
  DEC (yyStackPtr, 1); yyNonterminal := 126;
(* line 1156 "/tmp/lalr1303" *)
  (* line 1177 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mLessOper
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Operator      := *) Tree.LessOper);
                              
  | 482,232: (* Relation : '<=' .*)
  DEC (yyStackPtr, 1); yyNonterminal := 126;
(* line 1163 "/tmp/lalr1303" *)
  (* line 1182 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mLessEqualOper
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Operator      := *) Tree.LessEqualOper);
                              
  | 483,231: (* Relation : '>' .*)
  DEC (yyStackPtr, 1); yyNonterminal := 126;
(* line 1170 "/tmp/lalr1303" *)
  (* line 1187 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mGreaterOper
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Operator      := *) Tree.GreaterOper);
                              
  | 484,233: (* Relation : '>=' .*)
  DEC (yyStackPtr, 1); yyNonterminal := 126;
(* line 1177 "/tmp/lalr1303" *)
  (* line 1192 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mGreaterEqualOper
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Operator      := *) Tree.GreaterEqualOper);
                              
  | 485,234: (* Relation : IN .*)
  DEC (yyStackPtr, 1); yyNonterminal := 126;
(* line 1184 "/tmp/lalr1303" *)
  (* line 1197 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mInOper
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Operator      := *) Tree.InOper);
                              
  | 486,226: (* AddOp : '+' .*)
  DEC (yyStackPtr, 1); yyNonterminal := 127;
(* line 1192 "/tmp/lalr1303" *)
  (* line 1205 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mPlusOper
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Operator      := *) Tree.PlusOper);
                              
  | 487,227: (* AddOp : '-' .*)
  DEC (yyStackPtr, 1); yyNonterminal := 127;
(* line 1199 "/tmp/lalr1303" *)
  (* line 1210 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mMinusOper
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Operator      := *) Tree.MinusOper);
                              
  | 488,235: (* AddOp : OR .*)
  DEC (yyStackPtr, 1); yyNonterminal := 127;
(* line 1206 "/tmp/lalr1303" *)
  (* line 1215 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mOrOper
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Operator      := *) Tree.OrOper);
                              
  | 489,236: (* MulOp : '*' .*)
  DEC (yyStackPtr, 1); yyNonterminal := 129;
(* line 1214 "/tmp/lalr1303" *)
  (* line 1223 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mMultOper
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Operator      := *) Tree.MultOper);
                              
  | 490,237: (* MulOp : '/' .*)
  DEC (yyStackPtr, 1); yyNonterminal := 129;
(* line 1221 "/tmp/lalr1303" *)
  (* line 1228 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mRDivOper
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Operator      := *) Tree.RDivOper);
                              
  | 491,239: (* MulOp : DIV .*)
  DEC (yyStackPtr, 1); yyNonterminal := 129;
(* line 1228 "/tmp/lalr1303" *)
  (* line 1233 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mDivOper
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Operator      := *) Tree.DivOper);
                              
  | 492,240: (* MulOp : MOD .*)
  DEC (yyStackPtr, 1); yyNonterminal := 129;
(* line 1235 "/tmp/lalr1303" *)
  (* line 1238 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mModOper
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Operator      := *) Tree.ModOper);
                              
  | 493,238: (* MulOp : '&' .*)
  DEC (yyStackPtr, 1); yyNonterminal := 129;
(* line 1242 "/tmp/lalr1303" *)
  (* line 1243 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mAndOper
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Operator      := *) Tree.AndOper);
                              
  | 494,280: (* Designator : ident Designations .*)
  DEC (yyStackPtr, 2); yyNonterminal := 116;
(* line 1250 "/tmp/lalr1303" *)
  (* line 1252 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mDesignator
                                                           ((* Ident         := *) yyAttributeStack^[yyStackPtr+1].Scan.Ident
                                                           ,(* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Designors     := *) yyAttributeStack^[yyStackPtr+2].Tree);
                              
  | 495,279: (* Designations : '.' ident Designations .*)
  DEC (yyStackPtr, 3); yyNonterminal := 134;
(* line 1259 "/tmp/lalr1303" *)
  (* line 1263 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mSelector
                                                           ((* Nextor        := *) yyAttributeStack^[yyStackPtr+3].Tree
                                                           ,(* OpPos         := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Ident         := *) yyAttributeStack^[yyStackPtr+2].Scan.Ident
                                                           ,(* IdPos         := *) yyAttributeStack^[yyStackPtr+2].Scan.Position);
                              
  | 496,276: (* Designations : '[' ExprList ']' Designations .*)
  DEC (yyStackPtr, 4); yyNonterminal := 134;
(* line 1268 "/tmp/lalr1303" *)
  (* line 1273 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mIndexor
                                                           ((* Nextor        := *) yyAttributeStack^[yyStackPtr+4].Tree
                                                           ,(* Op1Pos        := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Op2Pos        := *) yyAttributeStack^[yyStackPtr+3].Scan.Position
                                                           ,(* ExprList      := *) yyAttributeStack^[yyStackPtr+2].Tree);
                              
  | 497,275: (* Designations : '^' Designations .*)
  DEC (yyStackPtr, 2); yyNonterminal := 134;
(* line 1277 "/tmp/lalr1303" *)
  (* line 1281 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mDereferencor
                                                           ((* Nextor        := *) yyAttributeStack^[yyStackPtr+2].Tree
                                                           ,(* OpPos         := *) yyAttributeStack^[yyStackPtr+1].Scan.Position);
                              
  | 498,278: (* Designations : '(' ExprList ')' Designations .*)
  DEC (yyStackPtr, 4); yyNonterminal := 134;
(* line 1284 "/tmp/lalr1303" *)
  (* line 1289 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mArgumentor
                                                           ((* Nextor        := *) yyAttributeStack^[yyStackPtr+4].Tree
                                                           ,(* Op1Pos        := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Op2Pos        := *) yyAttributeStack^[yyStackPtr+3].Scan.Position
                                                           ,(* ExprList      := *) yyAttributeStack^[yyStackPtr+2].Tree);
                              
  | 499,277: (* Designations : '(' ')' Designations .*)
  DEC (yyStackPtr, 3); yyNonterminal := 134;
(* line 1293 "/tmp/lalr1303" *)
  (* line 1298 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mArgumentor
                                                           ((* Nextor        := *) yyAttributeStack^[yyStackPtr+3].Tree
                                                           ,(* Op1Pos        := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Op2Pos        := *) yyAttributeStack^[yyStackPtr+2].Scan.Position
                                                           ,(* ExprList      := *) Tree.mmtExprList());
                              
  | 500: (* Designations : .*)
  DEC (yyStackPtr, 0); yyNonterminal := 134;
(* line 1302 "/tmp/lalr1303" *)
  (* line 1305 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mmtDesignor();
                              
  | 501,274: (* ExprList : Expr ',' ExprList .*)
  DEC (yyStackPtr, 3); yyNonterminal := 135;
(* line 1308 "/tmp/lalr1303" *)
  (* line 1313 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mExprList
                                                           ((* Next          := *) yyAttributeStack^[yyStackPtr+3].Tree
                                                           ,(* Expr          := *) yyAttributeStack^[yyStackPtr+1].Tree);
                              
  | 502: (* ExprList : Expr .*)
  DEC (yyStackPtr, 1); yyNonterminal := 135;
(* line 1315 "/tmp/lalr1303" *)
  (* line 1318 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mExprList
                                                           ((* Next          := *) Tree.mmtExprList()
                                                           ,(* Expr          := *) yyAttributeStack^[yyStackPtr+1].Tree);
                              
  | 503,285: (* IdentList : IdentDef ',' IdentList .*)
  DEC (yyStackPtr, 3); yyNonterminal := 86;
(* line 1323 "/tmp/lalr1303" *)
  (* line 1328 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mIdentList
                                                           ((* Next          := *) yyAttributeStack^[yyStackPtr+3].Tree
                                                           ,(* IdentDef      := *) yyAttributeStack^[yyStackPtr+1].Tree);
                              
  | 504: (* IdentList : IdentDef .*)
  DEC (yyStackPtr, 1); yyNonterminal := 86;
(* line 1330 "/tmp/lalr1303" *)
  (* line 1333 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mIdentList
                                                           ((* Next          := *) Tree.mmtIdentList()
                                                           ,(* IdentDef      := *) yyAttributeStack^[yyStackPtr+1].Tree);
                              
  | 505: (* Qualident : ident .*)
  DEC (yyStackPtr, 1); yyNonterminal := 94;
(* line 1338 "/tmp/lalr1303" *)
  (* line 1341 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mUnqualifiedIdent
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* Ident         := *) yyAttributeStack^[yyStackPtr+1].Scan.Ident);
                              
  | 506,225: (* Qualident : ident '.' ident .*)
  DEC (yyStackPtr, 3); yyNonterminal := 94;
(* line 1345 "/tmp/lalr1303" *)
  (* line 1348 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mQualifiedIdent
                                                           ((* Position      := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* ServerId      := *) yyAttributeStack^[yyStackPtr+1].Scan.Ident
                                                           ,(* Ident         := *) yyAttributeStack^[yyStackPtr+3].Scan.Ident
                                                           ,(* IdentPos      := *) yyAttributeStack^[yyStackPtr+3].Scan.Position);
                              
  | 507: (* IdentDef : ident .*)
  DEC (yyStackPtr, 1); yyNonterminal := 83;
(* line 1355 "/tmp/lalr1303" *)
  (* line 1358 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mIdentDef
                                                           ((* Ident         := *) yyAttributeStack^[yyStackPtr+1].Scan.Ident
                                                           ,(* Pos           := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* ExportMode    := *) OB.PRIVATE);
                              
  | 508,217: (* IdentDef : ident '*' .*)
  DEC (yyStackPtr, 2); yyNonterminal := 83;
(* line 1363 "/tmp/lalr1303" *)
  (* line 1365 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mIdentDef
                                                           ((* Ident         := *) yyAttributeStack^[yyStackPtr+1].Scan.Ident
                                                           ,(* Pos           := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* ExportMode    := *) OB.PUBLIC);
                              
  | 509,216: (* IdentDef : ident '-' .*)
  DEC (yyStackPtr, 2); yyNonterminal := 83;
(* line 1371 "/tmp/lalr1303" *)
  (* line 1372 oberon.lal *)
   yySynAttribute.Tree                 := Tree.mIdentDef
                                                           ((* Ident         := *) yyAttributeStack^[yyStackPtr+1].Scan.Ident
                                                           ,(* Pos           := *) yyAttributeStack^[yyStackPtr+1].Scan.Position
                                                           ,(* ExportMode    := *) OB.READONLY);
                              
END;
	       (* SPEC State := Next (Top (), Nonterminal); nonterminal transition *)
	       yyNCombPtr := SYSTEM.VAL(yyNCombTypePtr,(SYSTEM.VAL(LONGINT,yyNBasePtr [yyStateStack^ [yyStackPtr]])
				+ yyNonterminal * SIZE (yyNCombType)));
	       yyState := yyNCombPtr[0];
	       INC (yyStackPtr);
	       yyAttributeStack^ [yyStackPtr] := yySynAttribute;
	       IF yyState < yyFirstFinalState THEN EXIT END; (* read nonterminal ? *)
	    END;

	 ELSE						(* read *)
	    INC (yyStackPtr);
	    yyAttributeStack^ [yyStackPtr].Scan := Scanner.Attribute;
	    yyTerminal := Scanner.GetToken ();
	    yyIsRepairing := FALSE;
	 END;
      END;
   END Parser;

PROCEDURE ErrorRecovery (
      VAR Terminal	: yySymbolRange	;
	  StateStack	: yyStackType	;
	  StackSize	: LONGINT	;
	  StackPtr	: LONGINT	);
   VAR
      TokensSkipped	: BOOLEAN;
      ContinueSet	: Sets.tSet;
      RestartSet	: Sets.tSet;
      Token		: yySymbolRange;
      TokenArray	: ARRAY 128 OF CHAR;
      TokenString	: Strings.tString;
      ContinueString	: Strings.tString;
   BEGIN
   (* 1. report the error *)
      Errors.ErrorMessage (Errors.SyntaxError, Errors.Error, Scanner.Attribute.Position);

   (* 2. report the set of expected terminal symbols *)
      Sets.MakeSet (ContinueSet, yyLastTerminal);
      ComputeContinuation (StateStack, StackSize, StackPtr, ContinueSet);
      Strings.AssignEmpty (ContinueString);
      FOR Token := Sets.Minimum (ContinueSet) TO Sets.Maximum (ContinueSet) DO
	 IF Sets.IsElement (Token, ContinueSet) THEN
	    TokenName (Token, TokenArray);
	    Strings.ArrayToString (TokenArray, TokenString);
	    IF (Strings.Length (ContinueString) + Strings.Length (TokenString) + 1 <= Strings.cMaxStrLength) THEN
	       Strings.Concatenate (ContinueString, TokenString);
	       Strings.Append (ContinueString, ' ');
	    END;
	 END;
      END;
      Errors.ErrorMessageI (Errors.ExpectedTokens, Errors.Information,
	 Scanner.Attribute.Position, Errors.String, SYSTEM.VAL(SYSTEM.PTR,SYSTEM.ADR (ContinueString)));
      Sets.ReleaseSet (ContinueSet);

   (* 3. compute the set of terminal symbols for restart of the parse *)
      Sets.MakeSet (RestartSet, yyLastTerminal);
      ComputeRestartPoints (StateStack, StackSize, StackPtr, RestartSet);

   (* 4. skip terminal symbols until a restart point is reached *)
      TokensSkipped := FALSE;
      WHILE ~Sets.IsElement (Terminal, RestartSet) DO
	 Terminal := Scanner.GetToken ();
	 TokensSkipped := TRUE;
      END;
      Sets.ReleaseSet (RestartSet);

   (* 5. report the restart point *)
      IF TokensSkipped THEN
	 Errors.ErrorMessage (Errors.RestartPoint, Errors.Information, Scanner.Attribute.Position);
      END;
   END ErrorRecovery;

(*
   compute the set of terminal symbols that can be accepted (read)
   in a given stack configuration (eventually after reduce actions)
*)

PROCEDURE ComputeContinuation (
	  Stack		: yyStackType	;
	  StackSize	: LONGINT	;
	  StackPtr	: LONGINT	;
      VAR ContinueSet	: Sets.tSet	);
   VAR Terminal		: yySymbolRange;
   BEGIN
      Sets.AssignEmpty (ContinueSet);
      FOR Terminal := yyFirstTerminal TO yyLastTerminal DO
	 IF IsContinuation (Terminal, Stack, StackSize, StackPtr) THEN
	    Sets.Include (ContinueSet, Terminal);
	 END;
      END;
   END ComputeContinuation;

(*
   check whether a given terminal symbol can be accepted (read)
   in a certain stack configuration (eventually after reduce actions)
*)

PROCEDURE IsContinuation (
      Terminal		: yySymbolRange	;
      ParseStack	: yyStackType	;
      StackSize		: LONGINT	;
      StackPtr		: LONGINT	): BOOLEAN;
   VAR
      State		: LONGINT;
      Nonterminal	: yySymbolRange;
      Stack		: yyStackType;
   BEGIN
      DynArray.MakeArray (Stack, StackSize, SIZE (yyStateRange));
      FOR State := 0 TO StackPtr DO
	 Stack^ [State] := ParseStack^ [State];
      END;
      State := Stack^ [StackPtr];
      LOOP
	 Stack^ [StackPtr] := State;
	 State := Next (State, Terminal);
	 IF State = yyNoState THEN
	    DynArray.ReleaseArray (Stack, StackSize, SIZE (yyStateRange));
	    RETURN FALSE;
	 END;
	 IF State <= yyLastReadTermState THEN		(* read or read terminal reduce ? *)
	    DynArray.ReleaseArray (Stack, StackSize, SIZE (yyStateRange));
	    RETURN TRUE;
	 END;

	 LOOP						(* reduce *)
	    IF State =	yyStopState THEN
	       DynArray.ReleaseArray (Stack, StackSize, SIZE (yyStateRange));
	       RETURN TRUE;
	    ELSE 
	       DEC (StackPtr, yyLength [State]);
	       Nonterminal := yyLeftHandSide [State];
	    END;

	    State := Next (Stack^ [StackPtr], Nonterminal);
	    IF StackPtr >= StackSize THEN
	       DynArray.ExtendArray (Stack, StackSize, SIZE (yyStateRange));
	    END;
	    INC (StackPtr);
	    IF State < yyFirstFinalState THEN EXIT; END; (* read nonterminal ? *)
	    State := yyFinalToProd [State];		(* read nonterminal reduce *)
	 END;
      END;
   END IsContinuation;

(*
   compute a set of terminal symbols that can be used to restart
   parsing in a given stack configuration. we simulate parsing until
   end of file using a suffix program synthesized by the function
   Continuation. All symbols acceptable in the states reached during
   the simulation can be used to restart parsing.
*)

PROCEDURE ComputeRestartPoints (
	  ParseStack	: yyStackType	;
	  StackSize	: LONGINT	;
	  StackPtr	: LONGINT	;
      VAR RestartSet	: Sets.tSet	);
   VAR
      Stack		: yyStackType;
      State		: LONGINT;
      Nonterminal	: yySymbolRange;
      ContinueSet	: Sets.tSet;
   BEGIN
      DynArray.MakeArray (Stack, StackSize, SIZE (yyStateRange));
      FOR State := 0 TO StackPtr DO
	 Stack^ [State] := ParseStack^ [State];
      END;
      Sets.MakeSet (ContinueSet, yyLastTerminal);
      Sets.AssignEmpty (RestartSet);
      State := Stack^ [StackPtr];

      LOOP
	 IF StackPtr >= StackSize THEN
	    DynArray.ExtendArray (Stack, StackSize, SIZE (yyStateRange));
	 END;
	 Stack^ [StackPtr] := State;
	 ComputeContinuation (Stack, StackSize, StackPtr, ContinueSet);
	 Sets.Union (RestartSet, ContinueSet);
	 State := Next (State, yyContinuation [State]);

	 IF State >= yyFirstFinalState THEN		(* final state ? *)
	    IF State <= yyLastReadTermState THEN	(* read terminal reduce ? *)
	       INC (StackPtr);
	       State := yyFinalToProd [State];
	    END;

	    LOOP					(* reduce *)
	       IF State = yyStopState THEN
		  DynArray.ReleaseArray (Stack, StackSize, SIZE (yyStateRange));
		  Sets.ReleaseSet (ContinueSet);
		  RETURN;
	       ELSE 
		  DEC (StackPtr, yyLength [State]);
		  Nonterminal := yyLeftHandSide [State];
	       END;

	       State := Next (Stack^ [StackPtr], Nonterminal);
	       INC (StackPtr);
	       IF State < yyFirstFinalState THEN EXIT; END; (* read nonterminal ? *)
	       State := yyFinalToProd [State];		(* read nonterminal reduce *)
	    END;
	 ELSE						(* read *)
	    INC (StackPtr);
	 END;
      END;
   END ComputeRestartPoints;

(* access the parse table:   Next : State x Symbol -> State *)

PROCEDURE Next (State: yyStateRange; Symbol: yySymbolRange): yyStateRange;
   VAR
      TCombPtr		: yyTCombTypePtr;
      NCombPtr		: yyNCombTypePtr;
   BEGIN
      IF Symbol <= yyLastTerminal THEN
	 LOOP
	    TCombPtr := SYSTEM.VAL(yyTCombTypePtr,SYSTEM.VAL(LONGINT,yyTBasePtr [State]) 
			   + Symbol * SIZE (yyTCombType));
	    IF TCombPtr^.Check # State THEN
	       State := yyDefault [State];
	       IF State = yyNoState THEN RETURN yyNoState; END;
	    ELSE
	       RETURN TCombPtr^.Next;
	    END;
	 END;
      ELSE
	NCombPtr := SYSTEM.VAL(yyNCombTypePtr,SYSTEM.VAL(LONGINT,yyNBasePtr [State]) 
			+ Symbol * SIZE (yyNCombType));
	RETURN NCombPtr[0];
      END;
   END Next;

PROCEDURE yyGetTables;
   VAR
      BlockSize, j, n	: LONGINT;
      State	: yyStateRange;
      TBase	: ARRAY yyLastReadState+1 OF yyTCombRange;
      NBase	: ARRAY yyLastReadState+1 OF yyNCombRange;
   BEGIN
      BlockSize	:= 64000 DIV SIZE (yyTCombType);
      yyTableFile := System.OpenInput (ParsTabName);
      yyErrorCheck (Errors.OpenParseTable, SYSTEM.VAL(LONGINT,yyTableFile));
      IF 
	 (yyGetTable (SYSTEM.VAL(SYSTEM.PTR,SYSTEM.ADR (TBase)	        )) DIV SIZE (yyTCombRange ) - 1
	    # yyLastReadState) OR
	 (yyGetTable (SYSTEM.VAL(SYSTEM.PTR,SYSTEM.ADR (NBase)	        )) DIV SIZE (yyNCombRange ) - 1
	    # yyLastReadState) OR
	 (yyGetTable (SYSTEM.VAL(SYSTEM.PTR,SYSTEM.ADR (yyDefault)     )) DIV SIZE (yyReadRange  ) - 1
	    # yyLastReadState) OR
	 (yyGetTable (SYSTEM.VAL(SYSTEM.PTR,SYSTEM.ADR (yyNComb)       )) DIV SIZE (yyNCombType  )
	    # yyNTableMax - yyLastTerminal) OR
	 (yyGetTable (SYSTEM.VAL(SYSTEM.PTR,SYSTEM.ADR (yyLength)      )) DIV SIZE (yyTableElmt  ) - 1
	    # yyLastReduceState - yyFirstReduceState) OR
	 (yyGetTable (SYSTEM.VAL(SYSTEM.PTR,SYSTEM.ADR (yyLeftHandSide))) DIV SIZE (yySymbolRange) - 1
	    # yyLastReduceState - yyFirstReduceState) OR
	 (yyGetTable (SYSTEM.VAL(SYSTEM.PTR,SYSTEM.ADR (yyContinuation))) DIV SIZE (yySymbolRange) - 1
	    # yyLastReadState) OR
	 (yyGetTable (SYSTEM.VAL(SYSTEM.PTR,SYSTEM.ADR (yyFinalToProd) )) DIV SIZE (yyReduceRange) - 1
	    # yyLastReadNontermState - yyFirstReadTermState)
      THEN
	 Errors.ErrorMessage (Errors.WrongParseTable, Errors.Fatal, Positions.NoPosition);
      END;
      n := 0;
      j := 0;
      WHILE j <= yyTableMax DO
	 INC (n, yyGetTable (SYSTEM.VAL(SYSTEM.PTR,SYSTEM.ADR (yyTComb [j]))) DIV SIZE (yyTCombType));
         INC (j, BlockSize);
      END;
      IF n # yyTableMax + 1 THEN 
	 Errors.ErrorMessage (Errors.WrongParseTable, Errors.Fatal, Positions.NoPosition);
      END;
      System.Close (yyTableFile);

      FOR State := 1 TO yyLastReadState DO
	 yyTBasePtr [State] := SYSTEM.VAL(yyTCombTypePtr,SYSTEM.ADR (yyTComb [TBase [State]]));
      END;
      FOR State := 1 TO yyLastReadState DO
	 yyNBasePtr [State] := SYSTEM.VAL(yyNCombTypePtr,SYSTEM.ADR (yyNComb [NBase [State]]));
      END;
   END yyGetTables;

PROCEDURE yyGetTable (Address: SYSTEM.PTR): LONGINT;
   VAR
      N		:LONGINT; 
      Length	: yyTableElmt;
   BEGIN
      N := System.Read (yyTableFile, SYSTEM.ADR (Length), SIZE (yyTableElmt));
      yyErrorCheck (Errors.ReadParseTable, N);
      N := System.Read (yyTableFile, SYSTEM.VAL(LONGINT,Address), Length);
      yyErrorCheck (Errors.ReadParseTable, N);
      RETURN Length;
   END yyGetTable;

PROCEDURE yyErrorCheck (ErrorCode:LONGINT; Info:LONGINT);
   VAR ErrNo:LONGINT; 
   BEGIN
     IF Info < 0 THEN
	ErrNo := System.ErrNum ();
	Errors.ErrorMessageI (ErrorCode, Errors.Fatal, Positions.NoPosition,
	   Errors.Integer, SYSTEM.VAL(SYSTEM.PTR,SYSTEM.ADR (ErrNo)));
     END;
   END yyErrorCheck;

PROCEDURE BeginParser;
   BEGIN

      IF ~yyIsInitialized THEN
	 yyIsInitialized := TRUE;
	 yyGetTables;
      END;
   END BeginParser;

PROCEDURE CloseParser*;
   BEGIN

   END CloseParser;

BEGIN
    yyIsInitialized := FALSE;
    ParsTabName := 'Parser.Tab';
END Parser.

