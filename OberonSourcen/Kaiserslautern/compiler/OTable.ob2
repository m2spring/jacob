MODULE OTable;
(*
(*
------------------------------------------------------------------------------
  Project : Oberon-2 Compiler Front End, Oberon Implementation
  Modul   : SymbolTable.
  Datum   : $Date: 1995/04/18 13:11:05 $
  Autor   : $Author: oberon2 $
  Locking : $Locker:  $
  Revision: $Revision: 2.34 $
  Contents: Bookkeeping of Structures & Idents.
------------------------------------------------------------------------------
*)
*)


IMPORT
  OM:=OMachine, OS:=OScan, Strings, Strings2, Out;

CONST 
  debug = FALSE;

CONST
  noPos* = -1;  (* it is impossible to get a position at creation-time of an object *)
  systemIdent* = "SYSTEM";
  systemKey = 1283764;  (* the key for the internal compiler-module "SYSTEM" *)

  importMnolev* =-3;  (* this is mnolev for all imported modules/identifiers *)
  systemMnolev* =-2;  (* types/procedures from SYSTEM have this mnolev *)
  predeclMnolev* =-1;  (* predeclared identifiers have this mnolev *)
  compileMnolev* = 0;  (* lowest Level for currenty compiled module *)

  noIdent* = "@"; (* Not exported record-field become this (illegal) identifier
                    when stored in a symbol-file *)
  genericParam* = "##";

CONST
  objCollected = MAX(SET); (* object is collected for garbage-collection *)
  objUndef* = 0;  (* not defined *)
  objScope* = 1;  (* scope-anchor object *)
  objConst* = 2;  (* object for a constant *)
  objType* = 3;  (* object for a type-declaration *)
  objVar* = 4;  (* declared variable or value-parameter *)
  objVarPar* = 5;  (* VAR-param. of a procedure *)
  objField* = 6; (* RECORD-field *)
  objExtProc* = 7; (* exported or external procedures *)
  objIntProc* = 8; (* Interrupt Procedure *)
  objLocalProc* = 9; (* standard-procedure, not exported Procs etc... *)
  objModule* =10; (* imported Module *)
  objTBProc* =11; (* Type-Bound Procedure *)
  objForwardType* =12; (* Forward Type-Reference, not yet declared *)
  objForwardProc* =13; (* Forward-Proc-Decl. *)
  objForwardTBProc* =14; (* Forward-TBProc-Decl. *)
  objProtoTBProc =15; (* inserted in a RECORD, if a method is only defined in a subclass yet *)

CONST
  exportNot*   = 0;                (* not exported *)
  exportWrite* = 2;                (* exported as read-write *)
  exportRead*  = exportWrite - 1;  (* exported as read-only *)

CONST (* Internal predefined structures, types *)
  (*
  strCollected = MAX(SET); (* this structure is collected for garbage-collection *)
  *)
  strUndef* = 0;  (* undefined *)
  strBool* = 1;  (* BOOLEAN *)
  strChar* = 2;  (* CHAR *)
  strShortInt* = 3;  (* SHORTINT *)
  strInteger* = 4;  (* INTEGER *)
  strLongInt* = 5;  (* LONGINT *)
  strReal* = 6;  (* REAL *)
  strLongReal* = 7;  (* LONGREAL *)
  strSet* = 8;  (* SET *)

  strNone* = 9;  (* typeless, procedure is NO function *)
  strString* =10;  (* string-constant *)
  strNil* =11;  (* NIL *)

  strPredeclMax* = strNil; (* the first free number for numbering types in symbolfiles *)

  strSysByte* =12;  (* SYSTEM.BYTE *)
  strSysPtr* =13;  (* SYSTEM.PTR *)

  strFixedMax* = strSysPtr; (* all other structures don't have a fixed number! *)

(* Other structures which were not predefined internally *)
  strPointer* =14;  (* POINTER TO base *)
  strProc* =15;  (* PROCEDURE *)
  strTBProc   *=16;  (* PROCEDURE (receiver)... *)

  strArray* =17;  (* ARRAY xx OF base *)
  strDynArray* =18;  (* ARRAY OF base *)
  strRecord* =19;  (* RECORD *)


(* Constants for predefined- and SYSTEM-procedures *)
CONST
(* conversions *)
  predCHR* =13; predENTIER*=14; predLONG* =15;
  predORD* =16; predSHORT* =17;
(* some constants as defined in OMachine.Mod *)
  predMAX* =18; predMIN* =19; predSIZE* =20; (* special case *)
(*  monadic operators *)
  predABS* =21; predCAP* =22; predODD* =23; sysADR* =24; sysCC* =25;
(* binary operators *)
  predASH* =26; sysBIT* =27; sysLSH* =28; sysROT* =29;
  predLEN* =30;  (* special case *)
  sysVAL* =31;  (* special case *)
(* assign variations *)
  predINCL* =32; predEXCL* =33; predINC* =34; predDEC* =35; predCOPY* =36;
  sysMOVE* =37;  (* special case *)
  sysGET* =38; sysPUT* =39; sysGETREG* =40; sysPUTREG* =41; sysNEW* =42;
  predNEW* =43;  (* special case, 44 must be left free *)
(* trap *)
  predHALT* =45; predASSERT*=46;
(* dispose memory *)
  sysDISPOSE* = 47;
  
CONST
(* flags which occur in Object^.flag *)
  flagUsed* = 0; (* included in Object^.flags, if Object is referenced *)
  flagForward* = 1; (* included in Object^.flags, if Object is forward-declaration *)
  flagHasLocalProc*= 2; (* included in Object(objScope)^.flag, if local procedures are declared in that scope! *)
(*
  flagMethodExport = 3; (* if a method of this type is exported, in objProtoTBProc *)
  flagMethodLocal = 4; (* if a method of this type is NOT exported, in objProtoTBProc *)
*)
(* flags which occur in Struct^.flag *)
  flagExport* = 5; (* This object/struct is exported *)
  flagParam* = 6; (* this is a parameter... *)
  flagReceiver* = 7; (* this parameter is the receiver of a typebound procedure *)
  flagEmptyBody* = 8; (* this procedure has an empty body... *)
  flagUnion* = 9;

(* flags which occur both in Struct^.flag and Object^.flag *)
  flagExternal* = 10; (* this Object/Struct belongs to an external-definition *)

  flagMinFree* =16; (* first free flag for backend usage *)


TYPE
  Object* = POINTER TO ObjectDesc;
  Struct* = POINTER TO StructDesc;
  Const* = POINTER TO ConstDesc;
  String = POINTER TO ARRAY OM.maxSizeString OF CHAR;
  
  ConstDesc* =
    RECORD
      string* : String; (* string-constant *)
      intval* : LONGINT;   (* an integer constant *)
      intval2*: LONGINT;   (* second integer-constant, needed for case-ranges or export-valuation *)
      set*    : SET;   (* a set-constant *)
      real*   : LONGREAL;  (* a real-constant *)
    END; (* RECORD *)

  ObjectDesc* = (* an object of the symbol-table *)
    RECORD
      mode*  : SHORTINT; (* what kind of object belongs this node to? *)
      scope- : Object; (* pointer to current scope *)
      left*,
      right* : Object; (* pointers for internal search-binary-tree *)
      link*  : Object; (* internal link-pointer for objects *)
      next*  : Object; (* the next object in declaration-sequence *)
      sort-  : Object; (* the next object in alphabetic order *)
      name*  : ARRAY OM.maxSizeIdent OF CHAR; (* the identifier of the object *)
      extName* : String;  (* external name (if not NIL) *) 
      mark*  : SHORTINT; (* state of export (none,read-only,read-write *)
      type*  : Struct;
      const* : Const;
      flags* : SET;
      mnolev*: LONGINT;
      pos-   : LONGINT; (* position of the object within the source, for correct error-positions *)
    END; (* RECORD *)

  StructDesc* = (* type-information *)
    RECORD
       form* : SHORTINT; (* what kind of structure is it? *)
       base* : Struct;   (* base-type(RECORDs) or function-result(PROCEDUREs) *)
       obj*  : Object;   (* pointer to object which has this name, (NIL, if anonymous structure *)
       link* : Object;   (* the parameter-list *)
       flags*: SET;
       len*  : LONGINT;  (* dimension of array or number of formal parameters *)
       size* : LONGINT;  (* the size of this structure (machine- & backend dependend *)
    END; (* RECORD *)

(* organisation of nested scopes *)
CONST
  scopeStackClusterSize = 16;

TYPE
  ScopeStackCluster = POINTER TO ScopeStackClusterDesc;
  ScopeStackClusterDesc =
    RECORD
      next,prev : ScopeStackCluster;
      scopes: ARRAY scopeStackClusterSize OF Object;
    END; (* RECORD *)

  ScopeStack =
    RECORD
      bottom,top: ScopeStackCluster;
      stackTop: LONGINT;
      topScope: Object;
    END;

VAR
  scopeStack: ScopeStack;



VAR
  predefined,                 (* the lowest scope of all, contains predefined structures, only a scope-object, no module-object!!! *)
  system,                     (* the internal module SYSTEM *)
  compiledModule*:Object;            (* the currently compiled Module, must be opened by OParse.Mod *)
  external*      : BOOLEAN;

(* Fixed structur-nodes for internal structures *)
  predeclType* : ARRAY (strFixedMax+1) OF Struct;

  collectedObjs: Object;

TYPE (* Symboltable-Caching *)
  SymbolTableImported = POINTER TO SymbolTableImportedDesc;
  SymbolTableCache = POINTER TO SymbolTableCacheDesc;

  SymbolTableCacheDesc =
    RECORD
      pred,succ: SymbolTableCache;
      name: ARRAY OM.maxSizeIdent OF CHAR;
      symtable : Object; (* an Object with mode "objModule" *)
      imported : SymbolTableImported;
    END; (* RECORD *)

  SymbolTableImportedDesc =
    RECORD
      next: SymbolTableImported;
      this: SymbolTableCache;
    END; (* RECORD *)

VAR
  symbolCache: SymbolTableCache;
  cacheMnolev: LONGINT; 


(******************************************************************************)
(* PROCEDUREs for a simple garbage-collector on "Object"s *)
(******************************************************************************)

PROCEDURE NEWObject(VAR obj: Object);
(* tries to get an already allocated Object from the freelist.
   Otherwise a new Object will be created.
*)
  BEGIN
    IF (collectedObjs # NIL) THEN
      obj:=collectedObjs;
      collectedObjs:=collectedObjs^.next;
    ELSE
      NEW(obj);
    END; (* IF *)
  END NEWObject;

PROCEDURE RecycleMem*(VAR module: Object);
(* Collects recursively all Objects in moduleObject and stores them
   into the global list of unused objects.
     These Objects are held in a linear-list which is linked via
   obj^.next-pointer.

   Only objects with "obj^.mnolev" >= "module^.mnolev" (> only, iff module^.mnolev >= compileMnolev) are collected.
*)
  VAR
    numobj: LONGINT;

  PROCEDURE CollectObject(VAR obj: Object);
    BEGIN
      COPY(noIdent,obj^.name);
      obj^.mode:=objCollected; obj^.mark:=exportNot; obj^.mnolev:=compileMnolev;
      (* put it in the list of collected Objects *)
      obj^.next:=collectedObjs; collectedObjs:=obj;
      INC(numobj);
    END CollectObject;

  PROCEDURE MnolevOk(this,wanted: LONGINT): BOOLEAN;
    BEGIN
      RETURN(this=wanted) OR ((this >= wanted) & (wanted >= compileMnolev));
    END MnolevOk;

  PROCEDURE ^RecycleObject(VAR obj: Object; mnolev: LONGINT);

  PROCEDURE RecycleStruct(VAR type: Struct; mnolev: LONGINT);
    BEGIN
      IF (type # NIL) THEN
        IF (type^.form = strRecord) & ((type^.obj = NIL) OR MnolevOk(type^.obj^.mnolev,mnolev)) THEN (* Recordfelder einsammeln *)
          RecycleObject(type^.link,mnolev);
        END; (* IF *)
      END; (* IF *)
    END RecycleStruct;

  PROCEDURE RecycleObject(VAR obj: Object; mnolev: LONGINT);
    BEGIN
      IF (obj # NIL) THEN
        IF (obj^.mode IN {objConst .. objTBProc}) THEN
          RecycleObject(obj^.left,mnolev);
          RecycleObject(obj^.right,mnolev);
        END; (* IF *)
        IF (obj^.mode IN {objScope,objExtProc..objLocalProc,objTBProc}) THEN
          RecycleObject(obj^.link,mnolev);
        ELSIF (obj^.mode = objType) THEN
          RecycleStruct(obj^.type,mnolev);
        END; (* IF *)
        IF ~(obj^.mode IN {objCollected}) & MnolevOk(obj^.mnolev,mnolev) THEN
          CollectObject(obj);
        END; (* IF *)
      END; (* IF *)
    END RecycleObject;

  BEGIN
    IF (module # NIL) THEN
      RecycleObject(module^.link,module^.mnolev);
      CollectObject(module);
    END; (* IF *)
    module:=NIL;
  END RecycleMem;

(*****************************************************************************)
(* PROCEDUREs for Symboltable-Caching *)
(*****************************************************************************)

PROCEDURE DumpSymbolTable;
  VAR
    walk: SymbolTableCache;
    num: LONGINT;
  BEGIN
    num:=0;
    Out.String(" SymbolTable contains: ");
    walk:=symbolCache;
    WHILE walk # NIL DO
      Out.String(walk.name); Out.String(", ");
      walk:=walk.succ;
      INC(num);
    END;
    Out.Ln; Out.String("Cache objects: "); Out.Int(num,0); Out.Ln;
  END DumpSymbolTable;
  
PROCEDURE SearchSymbolTable(module: ARRAY OF CHAR): SymbolTableCache;
  VAR
    walk: SymbolTableCache;
  BEGIN
    IF debug THEN DumpSymbolTable; END;
    walk:=symbolCache;
    WHILE (walk # NIL) & (walk.name < module) DO
      walk:=walk.succ;
    END;

    IF (walk # NIL) & (walk.name = module) THEN
      RETURN(walk);
    ELSE
      RETURN(NIL);
    END;
  END SearchSymbolTable;

PROCEDURE RemoveSymbolTable(module: ARRAY OF CHAR): SymbolTableCache;
(* Removed cache object is returned *)
  VAR
    walk: SymbolTableCache;
  BEGIN
    walk:=SearchSymbolTable(module);
    IF (walk # NIL) THEN
      IF (walk.pred # NIL) THEN
        walk.pred.succ:=walk.succ;
      ELSE
        symbolCache:=walk.succ;
      END;
      IF (walk.succ # NIL) THEN
        walk.succ.pred:=walk.pred;
      END;
      walk.succ:=NIL;
      walk.pred:=NIL;
      RecycleMem(walk.symtable);
      RETURN(walk);
    ELSE
      Out.String("compiler error? Symboltable to remove was not found"); Out.Ln;
      RETURN(NIL);
    END;
  END RemoveSymbolTable;

PROCEDURE InsertSymbolTable*(module: ARRAY OF CHAR; table: Object);
  VAR
    pre,walk,new: SymbolTableCache;
  BEGIN
    IF debug THEN
      walk:=SearchSymbolTable(module);
      IF (walk # NIL) THEN
        Out.String("internal compiler error in frontend: Module more than once in cache"); Out.Ln; HALT(100);
      END;
    END;

    pre:=NIL;walk:=symbolCache;
    WHILE (walk # NIL) & (walk.name < module) DO
      pre:=walk; walk:=walk.succ;
    END;

    NEW(new);
    COPY(module,new.name);
    new.symtable:=table; new.imported:=NIL;
    new.pred:=pre; new.succ:=walk;

    IF (pre = NIL) THEN
      symbolCache:=new;
    ELSE
      pre.succ:=new;
    END;
    IF (walk # NIL) THEN
      walk.pred:=new;
    END;
  END InsertSymbolTable;

PROCEDURE InsertSymbolTableImport*(module,import: ARRAY OF CHAR);
(* 'import' is imported by 'module' *)
  VAR
    mod,imp: SymbolTableCache;
    new: SymbolTableImported;
  BEGIN
    mod:=SearchSymbolTable(module);
    imp:=SearchSymbolTable(import);
    IF (mod # NIL) & (imp # NIL) THEN
      NEW(new);
      new.this:=mod; new.next:=imp.imported; imp.imported:=new;
    ELSE
      Out.String("internal compiler error in frontend: problems with the cache hierachie"); Out.Ln;
      Out.String("   "); Out.String(module); Out.String(" imports "); Out.String(import); Out.Ln;
      IF imp = NIL THEN Out.String("imp = NIL")
      ELSIF (mod = NIL) THEN Out.String("mod = NIL"); 
      END; 
      Out.Ln
    END;
  END InsertSymbolTableImport;

PROCEDURE GetSymbolTable*(module: ARRAY OF CHAR): Object;
  VAR
    walk: SymbolTableCache;
  BEGIN
    walk:=SearchSymbolTable(module);
    IF (walk # NIL) THEN
      RETURN(walk.symtable);
    ELSE
      RETURN(NIL);
    END;
  END GetSymbolTable;

PROCEDURE FlushTable(flush: SymbolTableCache); 
  VAR
    thisflush: SymbolTableImported;
  BEGIN
    IF (flush # NIL) THEN
      WHILE (flush.imported # NIL) DO
        thisflush:=flush.imported;
        flush.imported:=flush.imported.next;
        FlushTable(thisflush.this);
      END;
    END;
  END FlushTable;

PROCEDURE FlushSymbolTable*(module: ARRAY OF CHAR);
  VAR
    flush: SymbolTableCache;
  BEGIN
    IF debug THEN Out.String("Flush Table: "); Out.String(module); Out.Ln; END;
    flush:=SearchSymbolTable(module);
    FlushTable(flush);
  END FlushSymbolTable;

PROCEDURE InitSymbolCache*;
  BEGIN
    symbolCache:=NIL;
    cacheMnolev:=importMnolev;
    InsertSymbolTable(systemIdent,system);
    cacheMnolev:=importMnolev;
  END InitSymbolCache;

PROCEDURE FlushSymbolCache;
  VAR
    flush: SymbolTableCache;
  BEGIN
    WHILE (symbolCache # NIL) DO
      flush:=RemoveSymbolTable(symbolCache.name);
      FlushTable(flush);
    END;
    InitSymbolCache;
  END FlushSymbolCache;

PROCEDURE GetImportMnolev*(): LONGINT;
  BEGIN
    IF (cacheMnolev > OM.minLInt) THEN
      DEC(cacheMnolev);
    ELSE (* this should never happen, but we will check this carefully *)
      Out.String("Cache-Overflow: flushing all caches, don't panic."); Out.Ln;
      FlushSymbolCache;
      InitSymbolCache;
    END; (* IF *)
    RETURN(cacheMnolev);
  END GetImportMnolev;


(*****************************************************************************)
(* PROCEDUREs, which work on binary-trees of "Object" *)
(*****************************************************************************)

PROCEDURE InsertInTree(VAR root: Object; obj : Object);
(* insert the object "obj" in the sorted-binary-tree with the root "root" *)
  VAR
    walk: Object;
  BEGIN
    IF (root = NIL) THEN
      root:=obj; (* we insert the first object into the tree *)
    ELSE
      walk:=root; (* we start searching at the root *)
      LOOP
        IF (obj^.name < walk^.name) THEN (* left side handling *)
          IF (walk^.left # NIL) THEN (* we have to go to the left *)
            walk:=walk^.left;
          ELSE (* insert here directly *)
            walk^.left:=obj; EXIT; (* work done *)
          END; (* IF *)
        ELSIF (obj^.name > walk^.name) THEN (* right side handling *)
          IF (walk^.right # NIL) THEN (* go to the right *)
            walk:=walk^.right;
          ELSE (* insert here on the right *)
            walk^.right:=obj; EXIT;
          END; (* IF *)
        ELSE (* walk^.name = obj^.name *)
          EXIT;
        END; (* IF *)
      END; (* LOOP *)
    END; (* IF *)
  END InsertInTree;

PROCEDURE SearchInTree(root: Object; ident: ARRAY OF CHAR): Object;
(* Searches for an object with the identifier "ident" in the sorted-binary-tree
   with root "root".
   If such an object is found, its pointer will be returned, otherwise NIL. *)
  VAR
    walk: Object;
  BEGIN
    walk:=root;
    LOOP
      IF (walk = NIL) THEN EXIT;
      ELSIF (ident < walk^.name) THEN walk:=walk^.left;
      ELSIF (ident > walk^.name) THEN walk:=walk^.right;
      ELSE (* ident = walk^.name, Object found *) EXIT;
      END; (* IF *)
    END; (* LOOP *)
    RETURN(walk);
  END SearchInTree;

(******************************************************************************)
(* PROCEDUREs, which are used for binary-tree-optimation! (these can be replaced
   by dummy-procedures for shorter compilers *)
(******************************************************************************)

PROCEDURE LinearizeTree(root: Object): Object;
(* rebuilds the binary-tree "root" to a linear-list, object
   are linked via "Object^.right". Does not destroy order of nodes,
   nor moves the place of nodes in memory! *)
  VAR
    newroot,tmproot: Object;
  BEGIN
    newroot:=root;
    IF (root # NIL) THEN (* work only if there are nodes in the tree! *)
      root^.right:=LinearizeTree(root^.right); (* build lin.list on the right *)
      root^.left :=LinearizeTree(root^.left);  (* build lin.list on the left *)
      IF (root^.left # NIL) THEN (* are there some nodes on the left? *)
        newroot:=root^.left; (* this will become our new root *)
        root^.left:=NIL;     (* set the left-tree to NIL *)
        tmproot:=newroot;    (* and put the right side with the old "root" on the rightmost
                                      node of the new root *)
        WHILE (tmproot^.right # NIL) DO
          tmproot:=tmproot^.right;
        END; (* WHILE *)
        tmproot^.right:=root;
      END; (* IF *)
    END; (* IF *)
    RETURN(newroot);
  END LinearizeTree;

PROCEDURE RebuildTree(root: Object): Object;
(* Builds a binary-tree with minimal depth out of a linear-list, which
   must be linked via "Object^.right".
     Call this procedure directly after "LinearizeTree" *)
   VAR
     newroot,left,right: Object;
     
   PROCEDURE SplitList(list: Object; VAR left,root,right: Object);
   (* splits a via Object^.right linked list into the following parts:
      left : left part, LEN(left) = LEN(list) DIV 2;
      root : middle node of the list (root of binary tree)
      right: left part, LEN(right) = LEN(list) DIV 2 [-1]
   *)
     VAR
       walk: Object;
     BEGIN
       left :=list; root :=list; right:=list; walk :=list;
       WHILE (walk # NIL) DO
         walk:=walk^.right;
         IF (walk # NIL) THEN
           walk:=walk^.right; root:=right; right:=right^.right;
         END; (* IF *)
       END; (* WHILE *)
       (* walk is one behind the end of the list,
          right stands at the middle node, root one node before right.
          In order to remove the middle node from the left-side-list,
          we have to set root^.right to NIL, then identify root with
          the middle node (which is stored in right now) and move
          right to the next position *)
       IF (right # NIL) THEN
         root^.right:=NIL; root:=right;
         right:=right^.right; root^.right:=NIL;
       END; (* IF *)
     END SplitList;

  BEGIN
    newroot:=NIL;
    IF (root # NIL) & (root^.right # NIL) THEN
      SplitList(root,left,newroot,right);
      IF (newroot # NIL) THEN
        newroot^.left :=RebuildTree(left);
        newroot^.right:=RebuildTree(right);
      ELSE (* there was just one node left *)
        newroot:=root;
      END; (* IF *)
    ELSE
      newroot:=root;
    END; (* IF *)
    RETURN(newroot);
  END RebuildTree;

PROCEDURE OptimizeTree*(VAR root: Object);
(* Optimize the binary-tree with root "root" to minimal depth.
   Only internal pointers will be modified so external
   references will stay valid for this operation. *)
  BEGIN
    IF (root # NIL) THEN
      root:=LinearizeTree(root);
      root:=RebuildTree(root);
    END; (* IF *)
  END OptimizeTree;

(******************************************************************************)
(* Initialize the exported structures *)
(******************************************************************************)

PROCEDURE NewConst*(): Const;
(* creates a new initialized constant *)
  VAR
    const: Const;
  BEGIN
    NEW(const);
    const^.intval:=0; const^.intval2:=0;
    const^.real:=0.0; const^.set:={}; const^.string:=NIL;
    RETURN(const);
  END NewConst;

PROCEDURE NewStruct*(form: SHORTINT): Struct;
(* Creates a new initializes structure which will be inserted into the
   symbol-table by the parser (normally with a corresponding object) *)
  VAR
    str: Struct;
  BEGIN
    NEW(str);
    str^.form :=form; str^.flags:={}; str^.len:=0;
    str^.base :=NIL; str^.obj  :=NIL; str^.link :=NIL;
    str^.size :=0;
    RETURN(str);
  END NewStruct;

PROCEDURE NewObject*(name: ARRAY OF CHAR; mode: SHORTINT; pos: LONGINT): Object;
(* Creates a new object with "name", "mode" and "pos" set to the corresponding
   values of the parameters.
   It will not be inserted into the symbol-table, this is a task for the parser... *)
  VAR
    new: Object;
  BEGIN
    NEWObject(new);
    new^.mode:=mode;
    COPY(name,new^.name);
    new^.mark:=exportNot;
    new^.extName:=NIL;
    
    new^.scope:=NIL; new^.left:=NIL; new^.right:=NIL;
    new^.link:=NIL; new^.next:=NIL; new^.sort:=NIL;
    new^.const:=NIL;
    new^.pos:=pos; new^.type:=predeclType[strUndef];
    new^.flags:={}; new^.mnolev:=compileMnolev;

    IF (mode IN {objForwardType,objForwardTBProc,objForwardProc}) THEN 
      (* update forward-declaration-info *)
      INCL(new^.flags,flagForward);
    END; (* IF *)

    IF (mode IN {objTBProc,objIntProc,objModule,objLocalProc,objExtProc,objForwardProc,objForwardTBProc}) THEN
      (* these object need a scope for their locally defined identifiers, so we create one *)
      new^.link:=NewObject(OS.undefStr,objScope,pos); (* create a scope-anchor for these object-types! *)
      new^.link^.left:=new; (* for each scope we have to find the corresponding object! *)
    END; (* IF  *)
    new^.scope:=scopeStack.topScope;

    IF (mode = objModule) THEN
      new^.const:=NewConst();
    ELSIF (mode IN {objForwardTBProc,objTBProc}) THEN
      INC(new^.link^.mnolev);
    END; (* CASE *)

    RETURN(new);
  END NewObject;

PROCEDURE CopyObject(source,dest: Object);
(* copies relevant fields of an object *)
  BEGIN
    dest^.mark :=source^.mark;
    dest^.mode :=source^.mode;
    dest^.pos  :=source^.pos;
  END CopyObject;

PROCEDURE CopyStruct(source,dest: Struct);
(* copies relevant fields of a structure *)
  BEGIN
    dest^.flags:=source^.flags;
    dest^.form :=source^.form;
    dest^.len  :=source^.len;
    dest^.base :=source^.base;
    dest^.link :=source^.link;
  END CopyStruct;

(******************************************************************************)
(* Check-Functions of some Oberon-2-definitions and other Functions. *)
(******************************************************************************)

PROCEDURE SameType*(a,b: Struct): BOOLEAN;
(* see Oberon-2-Report, Appendix A *)
  BEGIN
    RETURN((a = b) & (a^.form # strDynArray));
  END SameType;

PROCEDURE ^ParamsMatch*(str1,str2: Struct): BOOLEAN;

PROCEDURE EqualType*(a,b: Struct): BOOLEAN;
(* see Oberon-2-Report, Appendix A *)
  BEGIN
    RETURN(SameType(a,b) OR
      ((a^.form = strDynArray) & (b^.form = strDynArray) & EqualType(a^.base,b^.base)) OR
      ((a^.form = strProc) & (b^.form = strProc) & ParamsMatch(a,b)));
 END EqualType;

PROCEDURE ExtOf*(a,b: Struct): BOOLEAN;
(* Is "a" an extension of "b"? *)
  BEGIN
    IF (a^.form = strPointer) & (b^.form = strPointer) THEN
      a:=a^.base; b:=b^.base;
    ELSIF (a^.form = strPointer) # (b^.form = strPointer) THEN (* Pointers cannot be extensions of other types... *)
      RETURN(FALSE);
    END; (* IF *)
    IF (a^.form = strRecord) & (b^.form = strRecord) THEN
      WHILE (a # NIL) & (a # predeclType[strUndef]) DO (* remember: predeclType[strUndef]^.base = predeclType[strUndef], so we jump into an infinite loop *)
        IF SameType(a,b) THEN
          RETURN(TRUE);
        ELSE
          a:=a^.base;
        END; (* IF *)
      END; (* WHILE *)
    END; (* IF *)
    RETURN(FALSE);
  END ExtOf;

PROCEDURE ParamsMatch*(str1,str2: Struct): BOOLEAN;
(* checks for the two PROCEDURE-structures "str1" and "str2", if their
   formal parametertypes match *)
  VAR
    par1,par2: Object;
    specType: BOOLEAN;
  BEGIN
    IF SameType(str1^.base,str2^.base) (* test the result-type *) THEN
      specType := FALSE;  (* set to TRUE iff params contain VAR record or open array *)
      par1:=str1^.link; par2:=str2^.link;
      LOOP
        IF (par1 # NIL) & (par2 # NIL) THEN
          specType:=specType OR 
            (par1^.mode = objVarPar) & (par1^.type^.form = strRecord) & ~(flagExternal IN par1^.type^.flags) OR 
            (par1^.type^.form = strDynArray);
          IF (par1^.mode = par2^.mode) & EqualType(par1^.type,par2^.type) THEN
            par1:=par1^.link; par2:=par2^.link;
          ELSE
            RETURN(FALSE); (* parameters differ *)
          END; (* IF *)
        ELSE
          RETURN((par1 = NIL) & (par2 = NIL)) & (* no more parameters => everything's ok *)
                 (~specType OR ((flagExternal IN str1^.flags) = (flagExternal IN str2^.flags)));
        END; (* IF *)
      END; (* LOOP *)
    END; (* IF *)
    RETURN(FALSE);
  END ParamsMatch;

PROCEDURE CheckParameter(par1,par2: Object; quiet: BOOLEAN): BOOLEAN;
  BEGIN
    IF (par1^.mode # par2^.mode) THEN (* objVarParam <-> objParam *)
      IF ~quiet THEN OS.Err(par2^.pos,69); END;(* IF *)
      RETURN(FALSE);
    ELSIF ~EqualType(par1^.type,par2^.type) THEN (* types are not equal *)
      IF ~quiet THEN OS.Err(par2^.pos,67); END; (* IF *)
      RETURN(FALSE);
    END; (* IF *)
    RETURN(TRUE);
  END CheckParameter;

PROCEDURE SameResult(func1,func2: Object; quiet: BOOLEAN): BOOLEAN;
  BEGIN
    IF ~SameType(func1^.type^.base,func2^.type^.base) THEN (* different result-types *)
      IF ~quiet THEN
        OS.Err(func2^.pos,70);
      END; (* IF *)
      RETURN(FALSE);
    END; (* IF *)
      RETURN(TRUE);
    END SameResult;

PROCEDURE FormalParameterMatch(proc1,proc2: Object): BOOLEAN;
  VAR
    res: BOOLEAN;
    par1,par2: Object;

  BEGIN
    res:=SameResult(proc1,proc2,FALSE);
    par1:=proc1^.type^.link; par2:=proc2^.type^.link;
    (* check the other parameters *)
    LOOP
      IF (par1 = NIL) & (par2 = NIL) THEN EXIT; (* same number of parameters, exit return to caller with 'res' *)
      ELSIF (par1 = NIL) # (par2 = NIL) THEN (* Error: different number of parameters *)
        OS.Err(proc2^.pos,71);
        RETURN(FALSE);
      END; (* IF *)
      res:=CheckParameter(par1,par2,FALSE) & res;
      par1:=par1^.link; par2:=par2^.link;
    END; (* LOOP *)
    RETURN(res);
  END FormalParameterMatch;

PROCEDURE FormalParameterMatchTB(proc1,proc2: Object): BOOLEAN;
  VAR
    res: BOOLEAN;
    par1,par2: Object;
    quiet: BOOLEAN;

  PROCEDURE CheckReceiver(par1,par2: Object; quiet: BOOLEAN): BOOLEAN;
    BEGIN
      IF (par1^.mode # par2^.mode) THEN
        RETURN(FALSE);
      ELSIF (par1^.type^.form # par2^.type^.form) THEN
        RETURN(FALSE);
      ELSE
        IF ExtOf(par2^.type,par1^.type) OR EqualType(par2^.type,par1^.type) THEN
          RETURN(TRUE);
        ELSE
          IF ~quiet THEN OS.Err(par2^.pos,84); END; (* IF *)
          RETURN(FALSE);
        END; (* IF *)
      END; (* IF *)
    END CheckReceiver;

  BEGIN
    quiet:=FALSE; (* ((proc1^.mode = objProtoTBProc) OR (proc2^.mode = objProtoTBProc)); (* only report errors for "real" procedures, nor for compiler generated ones *) *)
    res:=SameResult(proc1,proc2,quiet);

    par1:=proc1^.type^.link; par2:=proc2^.type^.link;
    res:=CheckReceiver(par1,par2,quiet) & res;
    par1:=par1^.link; par2:=par2^.link;

    (* check the other parameters *)
    LOOP
      IF (par1 = NIL) & (par2 = NIL) THEN EXIT; (* everything is ok, same number of parameters *)
      ELSIF (par1 = NIL) # (par2 = NIL) THEN (* Error: different number of parameters *)
        IF ~quiet THEN
          OS.Err(proc2^.pos,71);
        END; (* IF *)
        RETURN(FALSE);
      END; (* IF *)
      res:=CheckParameter(par1,par2,quiet) & res;
      par1:=par1^.link; par2:=par2^.link;
    END; (* LOOP *)
    RETURN(res);
  END FormalParameterMatchTB;

(*****************************************************************************)
(* Opening/Closing of scopes *)
(*****************************************************************************)

PROCEDURE OpenScope*(scope: Object);
  VAR
    clusterPos: LONGINT;
    newCluster: ScopeStackCluster;
  BEGIN
    INC(scopeStack.stackTop);
    clusterPos:=(scopeStack.stackTop MOD scopeStackClusterSize);
    IF (clusterPos = 0) & (scopeStack.stackTop > 0) THEN
      (* maybe we have to create a new ScopeStackCluster? *)
      IF (scopeStack.top.next = NIL) THEN
        NEW(newCluster);
        newCluster.next:=NIL;
        scopeStack.top.next:=newCluster;
        newCluster.prev:=scopeStack.top;
      END;
      scopeStack.top:=scopeStack.top.next;
    END;
    scopeStack.top.scopes[clusterPos]:=scope;
    scopeStack.topScope:=scope;
    IF (scope = NIL) THEN
      Out.String("internal compiler error in frontend: OpenScope(NIL)"); Out.Ln;
    END; (* IF *)
  END OpenScope;

PROCEDURE ^CheckUnresolvedForward(scope,obj: Object);
PROCEDURE ^WarnUnused(scope: Object);
PROCEDURE ^PutModulesNextAndSort(scope: Object);

PROCEDURE LevelOfTopScope*(): LONGINT;
  BEGIN
    RETURN (scopeStack.topScope.mnolev);
  END LevelOfTopScope;

PROCEDURE CloseScope*(check: BOOLEAN);
  VAR
    clusterPos: LONGINT;
  BEGIN
   IF check THEN (* check for unresolved forwarddeclarations *)
      CheckUnresolvedForward(scopeStack.topScope,scopeStack.topScope.link);
      WarnUnused(scopeStack.topScope);
      PutModulesNextAndSort(scopeStack.topScope);
    END; (* IF *)

    IF (scopeStack.stackTop MOD scopeStackClusterSize) = 0 THEN
      IF (scopeStack.stackTop = 0) THEN
        Out.String("internal compiler error in frontend: more CloseScope than OpenScope"); Out.Ln; HALT(100);
      END;
      scopeStack.top:=scopeStack.top.prev;
    END;

    DEC(scopeStack.stackTop);
    clusterPos:=(scopeStack.stackTop MOD scopeStackClusterSize);
    scopeStack.topScope:=scopeStack.top.scopes[clusterPos];
  END CloseScope;

PROCEDURE CleanupScopeStack;
  BEGIN
    scopeStack.top:=scopeStack.bottom;
    scopeStack.stackTop:=-1;
    scopeStack.topScope:=NIL;
  END CleanupScopeStack;

PROCEDURE InitScopeStack;
  BEGIN
    NEW(scopeStack.bottom);
    CleanupScopeStack;
    scopeStack.bottom.prev:=NIL;
    scopeStack.top.next:=NIL;
  END InitScopeStack;

PROCEDURE ^FindField*(ident: ARRAY OF CHAR; struct: Struct): Object;

PROCEDURE WarnUnused(scope: Object);
(* all unused-warn-procedures have problems to indicate unused type-declarations
   of the following pattern:
   "TYPE a = POINTER TO aDesc; aDesc = RECORD b: a END; "
*)

  VAR
    istbproc: BOOLEAN;
  
  PROCEDURE IsRedefinition(tbproc: Object): BOOLEAN;
    VAR
      struct: Struct;
    BEGIN
      struct:=tbproc^.type^.link^.type; (* this is the receiver's type *)
      IF (struct # NIL) & (struct^.form = strPointer) THEN (* resolve pointer, get corresponding record type *)
        struct:=struct^.base;
      END; (* IF *)
      RETURN(FindField(tbproc^.name,struct^.base) # NIL); (* if field is visible, then it's a redefinition *)
    END IsRedefinition;
      
  PROCEDURE WarnUnusedRec(obj: Object; istbproc: BOOLEAN);
  (* look within procedure scopes for unreferenced objects *)
    BEGIN
      IF (obj # NIL) THEN
        WarnUnusedRec(obj^.left,istbproc);
        IF istbproc & (flagParam IN obj^.flags) & (flagEmptyBody IN scope^.flags) THEN
          (* suppress warning for unused parameter *)
        ELSIF (obj^.mode = objTBProc) & (obj^.mark = exportNot) & ~(flagUsed IN obj^.flags) & IsRedefinition(obj) THEN
          (* suppress warning for redefinition *)
        ELSIF (obj^.mode IN {objConst,objType,objVar,objVarPar,objField,objExtProc,objIntProc,objLocalProc,objModule,objTBProc}) & ~(flagUsed IN obj^.flags)  & (obj^.mark = exportNot) THEN (* all other unused objects *)
          OS.Warn(obj^.pos,90);
        END; (* IF *)
        IF (obj^.mode = objType) & (obj^.type^.form = strRecord) THEN
          WarnUnusedRec(obj^.type^.link,istbproc);
        END; (* IF *)
        WarnUnusedRec(obj^.right,istbproc);
      END; (* IF *)
    END WarnUnusedRec;

  BEGIN
    IF (scope^.left # NIL) THEN 
      (* test, if the scope's object is a typebound procedure. *)
      istbproc:=(scope^.left^.mode = objTBProc);
    ELSE
      istbproc:=FALSE;
    END; (* IF *)
    IF (scope^.mnolev >= compileMnolev) THEN (* Object on module-level. Maybe a TBProc *)
      WarnUnusedRec(scope^.link,istbproc);
    END; (* IF *)
  END WarnUnused;

PROCEDURE CheckUnresolvedForward(scope,obj: Object);
(* recursive check-procedure for unresolved forward-declarations.
   At the same time, look for locally declared procedures *)
  BEGIN
    IF (obj # NIL) THEN
      CheckUnresolvedForward(scope,obj^.left);
      CASE obj^.mode OF
        |objForwardType,
         objForwardProc,
         objForwardTBProc:
            OS.Err(obj^.pos,65);
        |objType:
            IF (obj^.type^.form = strRecord) THEN
              CheckUnresolvedForward(scope,obj^.type^.link);
              (* to get to type-bound procedures *)
            END; (* IF *)
        |objIntProc,
         objExtProc,
         objLocalProc:
             (* for effiency in backend: Check for locally declared procedures *)
            INCL(scope^.flags,flagHasLocalProc);
        ELSE
          (* no error in this case *)
      END; (* CASE *)
      CheckUnresolvedForward(scope,obj^.right);
    END; (* IF *)
  END CheckUnresolvedForward;

PROCEDURE PutModulesNextAndSort(scope: Object);
(* Collects all module-Object "objModule" in "scope" and puts them
   into a via "obj^.next" linear linked list at "scope^.right".

   This procedure must only be called when nothing more is done in
   "scope" *)
  VAR
    module,
    sort: Object;
    first: Object;

  PROCEDURE RecCollectAndSort(obj: Object);
    (* collect all modules, sort other objects *)
    BEGIN
      IF (obj # NIL) THEN
        RecCollectAndSort(obj^.left);
        IF (obj^.mode = objModule) THEN
          module^.next:=obj; obj^.next:=NIL; module:=obj;
        ELSIF ~(flagParam IN obj^.flags) THEN
          sort^.sort:=obj; obj^.sort:=NIL; sort:=obj;
        END; (* IF *)
        RecCollectAndSort(obj^.right);
      END; (* IF *)
    END RecCollectAndSort;

  BEGIN
    scope^.next:=NIL;
    first:=NewObject(noIdent,objUndef,noPos);
    module:=first; sort:=first;
    RecCollectAndSort(scope^.link);
    scope^.next:=first^.next; scope^.sort:=first^.sort;
    first:=NIL;
  END PutModulesNextAndSort;

PROCEDURE ObjectScopePath*(obj: Object; VAR path: ARRAY OF CHAR; seperator: CHAR);
(* builds for a given object "obj" a string containing the path it:
   path= [modulname seperator] {procedurename seperator} objectname.
   Predefined identifiers lack the modulename, all other will have this one. *)

  VAR
    searchScope: Object;
  BEGIN
    IF (obj # NIL) & (obj^.mode IN {objConst .. objProtoTBProc}) THEN
      COPY(obj^.name,path);
      IF (obj^.mode # objField) THEN
        searchScope:=obj;
        WHILE (searchScope # NIL) & (searchScope^.mode # objModule) DO
          IF (searchScope^.scope # predefined) THEN
            searchScope:=searchScope^.scope^.left; (* find the object, in which scope we are *)
            (* We arrived in a module, so we put its name in front of the others. *)
            Strings2.InsertChar (seperator, 0, path); 
            Strings.Insert (searchScope^.name, 0, path);
          ELSE (* we wanted the path of a predefined identifier! *)
            searchScope:=NIL;
          END; (* IF *)
        END; (* WHILE *)
(*          ELSE "No scopeinfo for fields implemented yet" *)
      END; (* IF *)
    ELSE
      COPY("Illegal use of 'ObjectScopePath'",path);
    END; (* IF *)
  END ObjectScopePath;

PROCEDURE GetModuleForObject*(obj : Object): Object;
(* Returns for a given object "obj" the module in which's scope it is declared.
   For predefined Identifiers the currently "compiledModule" is returned
   Returns always the real identifier for the module, not an alias! *)
  VAR
    walk: Object;
  BEGIN
    walk:=obj;
    WHILE (walk # NIL) & (walk^.mode # objModule) DO
      IF (walk^.mode = objField) THEN
        RETURN(NIL); (* keine Info verfuegbar *)
      ELSE
        walk:=walk^.scope^.left;
(*                ^^^ the scope in which "obj" is declared
                         ^^^ the object in which's scope "obj" is declared
*)
      END; (* IF *)
    END; (* WHILE *)

    IF (walk # NIL) THEN
      RETURN(walk^.link^.left); (* objModule -> objScope -> objModule: get the real name, not the name of an alias *)
    ELSE
      RETURN(compiledModule);
    END; (* IF *)
  END GetModuleForObject;

PROCEDURE GetModuleName*(obj : Object; VAR name: ARRAY OF CHAR);
(* Gets the "real" (not alias) name of the module in which "obj" is declared *)
  VAR
    mod: Object;
  BEGIN
    mod:=GetModuleForObject(obj);
    COPY(mod^.name,name);
  END GetModuleName;


(******************************************************************************)
(* Insertion and searching in scopes. *)
(******************************************************************************)


PROCEDURE InsertNextObject(obj: Object);
(* all objects are also in a linear list which reflects their declaration order,
   we update this list with this procedure *)
  BEGIN
    IF ~(flagParam IN obj^.flags) THEN (* do not insert parameters to the next-list *)
      IF (scopeStack.topScope^.next # NIL) THEN (* There are already some object in the scope *)
        scopeStack.topScope^.next^.next:=obj; (* put the new object at the end of the list *)
      ELSIF (scopeStack.topScope^.right = NIL) THEN
        scopeStack.topScope^.right:=obj; (* we are the first object in this scope *)
      ELSE (* we have to search the end of the next-list (the scope is reopened) *)
        scopeStack.topScope^.next:=scopeStack.topScope^.next;
        WHILE (scopeStack.topScope^.next^.next # NIL) DO
          scopeStack.topScope^.next:=scopeStack.topScope^.next^.next;
        END; (* WHILE *)
        scopeStack.topScope^.next^.next:=obj;
      END; (* IF *)
      scopeStack.topScope^.next:=obj; (* bookkeeping for the next object *)
    END; (* IF *)
  END InsertNextObject;

PROCEDURE UpdateForNewInsert(VAR obj: Object);
  BEGIN
    obj^.scope :=scopeStack.topScope;
    obj^.mnolev:=scopeStack.topScope^.mnolev;
    IF ~(obj^.mode IN {objForwardProc,objForwardType,objModule}) THEN
      InsertNextObject(obj);
    END; (* IF *)
    IF (obj^.mode IN {objIntProc,objExtProc,objLocalProc}) & (obj^.mnolev >= compileMnolev) THEN
        (* the scopes of these objects have a higher mnolev! *)
      obj^.link^.mnolev:=obj^.mnolev + 1;
    ELSIF (obj^.mode IN {objType}) & (obj^.type^.obj = NIL) THEN
      obj^.type^.obj:=obj;
    END; (* IF *)
  END UpdateForNewInsert;

PROCEDURE Insert*(VAR obj: Object);
(* puts the object in the actual scope.
   If a forward-reference is resolved, the procedure will check for compatibility.
   If an object with the same name already exists in the actual scope, an
   error will be reported. *)
  VAR
    old: Object;

  BEGIN
    old:=SearchInTree(scopeStack.topScope^.link,obj^.name);
    IF (old # NIL) THEN (* object with this name already present in this local scope *)
      CASE old^.mode OF
        |objForwardType:
            IF (obj^.mode = objType) THEN (* resolve the old reference *)
              IF (obj^.type^.form IN {strRecord,strArray,strDynArray}) THEN
                 (* copy the new type-information into the old locations
                    because there is a certain possibility that there are
                    already pointers to these objects which we don't want
                    to loose (would cause teribble errors!) *)
                CopyObject(obj,old);
                CopyStruct(obj^.type,old^.type);
                obj:=old; (* identify both objects *)
                obj^.type^.obj:=obj;
                InsertNextObject(obj);
              ELSE (* only records, arrays or dynamic arrays are allowed as forward-declarations *)
                OS.Err(obj^.pos,66);
              END; (* IF *)
            ELSE (* a forward-type MUST be resolved by a type! *)
              OS.Err(obj^.pos,61)
            END; (* IF *)
        |objForwardProc:
            IF (obj^.mode IN {objExtProc,objLocalProc,objIntProc}) THEN (* check the parameter lists *)
              IF FormalParameterMatch(old,obj) THEN
                CopyObject(obj,old); (* copy the new data into the old location *)
                CopyStruct(obj^.type,old^.type); (* copy the new data out of the struct *)
                obj:=old;
                IF (old^.mnolev >= compileMnolev) THEN (* increase level only for "local"-procedures, not for procs in imported modules *)
                  old^.link^.mnolev:=scopeStack.topScope^.mnolev + 1;
                ELSE (* imported procs have the number of the corresponding module in their "mnolev" *)
                  old^.link^.mnolev:=scopeStack.topScope^.mnolev;
                END; (* IF *)
                InsertNextObject(obj);
              ELSE (* formal parameterlists differ *)
                OS.Err(obj^.pos,62);
              END; (* IF *)
            ELSIF (obj^.mode = objForwardProc) THEN (* it is allowed to declare several forward-references, but they must match! *)
              IF FormalParameterMatch(old,obj) THEN
                OS.Warn(obj^.pos,91);
                OS.Warn(old^.pos,91);
                obj:=old;
              ELSE (* formal parameterlists differ *)
                OS.Err(obj^.pos,62);
              END; (* IF *)
            ELSE (* resolve forward-procedures only with procedures *)
              OS.Err(obj^.pos,72);
            END; (* IF *)
        ELSE (* no resolving of forward declaration => illegal double-declaration *)
          OS.ErrIns(obj^.pos,60,obj^.name);
      END; (* CASE *)
    ELSE (* just put the object in the actual scope *)
      UpdateForNewInsert(obj);
      InsertInTree(scopeStack.topScope^.link,obj);
    END; (* IF *)
  END Insert;

PROCEDURE InsertForOSym*(VAR obj: Object; VAR last: Object);
(* Used to insert objects into the symbol table that are read from the symbol
   file: We don't need to test for double declarations and the objects come in
   (almost) alphabetic order.  'last' is the most recent object inserted into
   the tree, 'last.sort' the lexicographic following object to 'last'. *)
  VAR
    ptr, lastLeft: Object;
  BEGIN
    UpdateForNewInsert(obj);
    IF (last = NIL) THEN  (* empty tree *)
      scopeStack.topScope. link := obj;
      obj. sort := NIL
    ELSIF (last. name < obj. name) & 
          ((last. sort = NIL) OR (obj. name < last. sort. name)) THEN
      (* obj is in the intervall ]last, last.sort[; since last is a leaf
         of the tree, we can safely add the new object at last.right *)
      last. right := obj;
      obj. sort := last. sort
    ELSE  (* do normal inserton and calculate new last.sort *)
      InsertInTree(scopeStack.topScope. link, obj);
      (* find first object larger than obj and store in in obj.sort *)
      lastLeft := NIL;      
      ptr := scopeStack.topScope. link;
      LOOP
        IF (ptr. name <= obj. name) THEN
          ptr := ptr. right;
          IF (ptr = NIL) THEN
            ptr := lastLeft;
            EXIT
          END
        ELSE
          IF (ptr. left = NIL) OR (ptr. left = obj) THEN
            EXIT
          ELSE 
            lastLeft := ptr;
            ptr := ptr. left
          END
        END
      END;      
      obj. sort := ptr
    END;
    last := obj
  END InsertForOSym;
  
PROCEDURE InsertParams*(proc: Object);
(* pre: proc^.mode IN {objIntProc,objExtProc,objLocalProc,objTBProc}
        (proc^.type # NIL) & (proc^.type^.form IN {strTBProc,strProc})
   post: The formal parameters of 'proc' are visible (inserted) in the local scope
         of 'proc'.
         Also set 'flagParam' for each parameterobject*)
  VAR
    param: Object;
  BEGIN
    OpenScope(proc^.link);
    param:=proc^.type^.link;
    IF (proc^.type^.form = strTBProc) THEN INCL(param^.flags,flagReceiver); END; (* IF *)
    WHILE (param # NIL) DO
      INCL(param^.flags,flagParam); Insert(param);
      param:=param^.link;
    END; (* WHILE *)
    CloseScope(FALSE);
  END InsertParams;

PROCEDURE Find*(ident: ARRAY OF CHAR): Object;
(* searches in the actual and outer scopes (those of procedures and modules)
   for an object with identifier "ident". If no object with that name is
   found, NIL will be returned *)
  VAR
    walk : Object;
    scope: Object;
  BEGIN
    scope:=scopeStack.topScope; (* search begins at the actual scope *)
    WHILE (scope # NIL) DO
      walk:=SearchInTree(scope^.link,ident);
      IF (walk # NIL) THEN
        INCL(walk^.flags,flagUsed);
        RETURN(walk);
      END; (* IF *)
      scope:=scope^.scope;  (* try in the next outer scope! *)
    END; (* WHILE *)
    RETURN(NIL);
  END Find;

(******************************************************************************)
(* Insertion and searching within RECORDs. *)
(******************************************************************************)

PROCEDURE InternalFindField(ident: ARRAY OF CHAR; struct: Struct): Object;
  VAR
    walk: Object;
  BEGIN
    LOOP
      IF (struct = NIL) THEN (* no more base types *)
        RETURN(NIL);
      ELSE
        walk:=SearchInTree(struct^.link,ident);
        IF (walk # NIL) THEN
          IF (walk^.mark # exportNot) OR (walk^.mnolev >= compileMnolev) THEN (* field visible *)
            RETURN(walk);
          ELSE (* field not visible *)
            RETURN(NIL);
          END; (* IF *)
        ELSE
          struct:=struct^.base; (* there maybe a base type, so look within that one! *)
        END; (* IF *)
      END; (* IF *)
    END; (* LOOP *)
  END InternalFindField;

PROCEDURE FindField*(ident: ARRAY OF CHAR; struct: Struct): Object;
(* Searches in record "struct" for field with name "ident". If "struct"
   is an extended record, the base-types are also searched *)
  VAR
    field: Object;
  BEGIN
    field:=InternalFindField(ident,struct);
    IF (field = NIL) OR (field.mode = objProtoTBProc) THEN
      RETURN(NIL);
    ELSE
      INCL(field.flags,flagUsed);
      RETURN(field);
    END;
  END FindField;

PROCEDURE ^InsertField*(obj: Object; struct: Struct);

PROCEDURE InsertProtoTBs(dest: Struct; orig: Object);
  PROCEDURE InsertRecProtoTBs(dest: Struct; orig: Object);
    VAR
      virt: Object;
    BEGIN
      IF (dest # NIL) THEN
        virt:=SearchInTree(dest^.link,orig^.name);
        IF (virt = NIL) THEN (* just insert the Proto tb *)
          virt:=NewObject(orig^.name,objProtoTBProc,noPos);
          InsertField(virt,dest);
        END; (* IF *)
        InsertRecProtoTBs(dest^.base,orig);
      END; (* IF *)
    END InsertRecProtoTBs;
  BEGIN
    IF (dest # NIL) THEN
      IF dest^.form = strPointer THEN
        dest:=dest^.base;
      END; (* IF *)
      IF dest^.form = strRecord THEN
        InsertRecProtoTBs(dest,orig);
      END; (* IF *)
    END; (* IF *)
  END InsertProtoTBs;

PROCEDURE CheckTBExportSemantic(sub,super: Object): BOOLEAN;
(* Checks, if (none-)export is allowed according to some rules *)
  VAR
    base: Object; (* Base-Recordobject *)
  BEGIN
    base:=sub^.type^.link^.type^.obj; (* get the type of the receiver *)
    IF (super # NIL) THEN (* check for consistency between "sub" & "super" *)
      IF (super^.mark = exportWrite) THEN
        IF (base^.mark = exportWrite) THEN (* in this case "sub" must be exported according to the report *)
          IF (sub^.mark # exportWrite) THEN
            Out.String("Error: typebound procedure must be exported!"); Out.Ln;
          END; (* IF *)
          RETURN(sub^.mark = exportWrite);
        END; (* IF *)
      END; (* IF *)
    END; (* IF *)
    RETURN(TRUE);
  END CheckTBExportSemantic;

PROCEDURE InsertField*(obj: Object; struct: Struct);
(* puts object "obj" in the record-structure "struct".
   It will be checked, that the identifier of "obj" will
   be unique within the (expanded) record except for type-bound
   procedures, which can be redefined in new extensions. *)

(* imported (but not visible fields) will only be inserted in the
   list of fields but not in the "scope", so there will be no entry
   with the name "noIdent" *)

(* for type-bound procedures "obj^.type^.form" will be set to "strTBProc"
   in order to get the right type later *)
  VAR
    old: Object;

  PROCEDURE InsertNextField;
  (* link the fields together in the textual order *)
    VAR
      walk: Object;
    BEGIN
      walk:=struct^.link;
      IF (walk # obj) THEN
        IF (walk # NIL) THEN
          WHILE (walk^.next # NIL) DO
            walk:=walk^.next;
          END; (* WHILE *)
          walk^.next:=obj;
        ELSE
          struct^.link:=walk;
        END; (* IF *)
      END; (* IF *)
    END InsertNextField;

  PROCEDURE FieldAlreadyFound;
    VAR
      local: Object;
    BEGIN
      IF (old^.mode IN {objForwardTBProc,objTBProc,objProtoTBProc}) THEN
          (* for type-bound records check whether it was at this
             scope or a lower level *)
        local:=SearchInTree(struct^.link,obj^.name);
        IF (local # NIL) THEN
          
          IF (local^.mode = objForwardTBProc) THEN
             (* we have to resolve an old forward-declaration,
                but check the formal parameters first! *)
            IF FormalParameterMatchTB(local,obj) & CheckTBExportSemantic(local,obj) THEN
              CopyObject(obj,local); (* copy new data into old object *)
              CopyStruct(obj^.type,local^.type);
            ELSE
              OS.Err(obj^.pos,88)
             END; (* IF *)
          ELSIF (local^.mode = objProtoTBProc) THEN
             (* wrong sequence of deklaration *)
            OS.Err(obj^.pos,87);
          ELSE
            OS.Err(obj^.pos,64);
          END; (* IF *)
        ELSE (* the object was not declared at this level, so we
                redefine the old type-bound procedure *)
          IF (old^.mode = objProtoTBProc) THEN (* there was only a Proto TBProc, so we insert the method *)
            InsertInTree(struct^.link,obj);
            InsertProtoTBs(struct^.base,obj); (* insert Proto methods up the tree *)
          ELSIF FormalParameterMatchTB(old,obj) & CheckTBExportSemantic(old,obj) THEN (* parameters match, so simply insert *)
            InsertInTree(struct^.link,obj);
          ELSE
            OS.Err(obj^.pos,89)
          END; (* IF *)
        END; (* IF *)
      ELSE
        OS.Err(obj^.pos,64);
      END; (* IF *)
    END FieldAlreadyFound;

  BEGIN
    old:=InternalFindField(obj^.name,struct);
    IF (old # NIL) THEN (* object with same name already occured *)
      FieldAlreadyFound;
    ELSE (* identifier does not occur in record yet *)
      IF (obj^.mode IN {objTBProc,objForwardTBProc}) THEN
        IF CheckTBExportSemantic(obj,NIL) THEN
          InsertInTree(struct^.link,obj);
          InsertProtoTBs(struct^.base,obj);
        ELSE
          Out.String("ERROR in exportmarks for TBProcs!"); Out.Ln; OS.noerr:=FALSE;
        END; (* IF *)
      ELSE (* just insert normal fields *)
        InsertInTree(struct^.link,obj);
      END; (* IF *)
    END; (* IF *)
    IF (obj^.mode = objField) THEN
      InsertNextField;
    END; (* IF *)
  END InsertField;

PROCEDURE ImportInsertField*(obj: Object; struct: Struct);
  BEGIN
    IF (obj^.name # noIdent) THEN
      InsertInTree(struct^.link,obj);
    END; (* IF *)
  END ImportInsertField;

(******************************************************************************)
(* Search identifiers in imported modules. *)
(******************************************************************************)

PROCEDURE InternalFindImport*(ident: ARRAY OF CHAR; mod: Object): Object;
(* only for use in OSym, does not check for visibility (because symbolfiles contain
   more information than only exported types...) *)
  BEGIN
    RETURN(SearchInTree(mod^.link^.link,ident)); (* search in the corresponding scope *)
                     (* ^^^^^^^^^^^^^^^ module->scope-anchor->first-object-in-scope *)
  END InternalFindImport;

PROCEDURE FindImport*(ident: ARRAY OF CHAR; mod: Object): Object;
(* searches in the imported module "mod" for an object with identifier "ident".
   If none is found or it is not exported, NIL will be returned *)
  VAR
    obj: Object;
  BEGIN
    INCL(mod^.flags,flagUsed);
    obj:=InternalFindImport(ident,mod);
    IF (obj # NIL) & (obj^.mark = exportNot) THEN RETURN(NIL); END; (* IF *)
    RETURN(obj);
  END FindImport;

(******************************************************************************)
(* Build the internal structures and scopes during initialisation *)
(******************************************************************************)

PROCEDURE InsertPredeclStruct(name: ARRAY OF CHAR; str: SHORTINT);
(* str  : Internal number of the structure
   ident: name of the object.
   type : Pointer to the created struct, will be stored in global VARs
          in order to address types directly .
*)
(* Puts an object in the currently opened scope *)
  VAR
    obj : Object;
    type: Struct;
  BEGIN
    obj:=NewObject(name,objType,noPos); type:=NewStruct(str);
    obj^.mark:=exportWrite; obj^.type:=type; type^.obj:=obj;
    Insert(obj); (* insert in the currently opened scope 'scopeStack.topScope' *)
    INCL(obj^.flags,flagUsed); (* so CloseScope does not warn on these objects *)
    predeclType[str]:=type;
  END InsertPredeclStruct;

PROCEDURE InsertProc(name: ARRAY OF CHAR; num: LONGINT);
(* Insert a predefined procedure/function, later identified through obj^.const # NIL & "num" *)
  VAR
    obj: Object;
  BEGIN
    obj:=NewObject(name,objExtProc,noPos);
    obj^.const:=NewConst(); obj^.const^.intval:=num;
    obj^.mark:=exportWrite; obj^.type:=NewStruct(strProc);
    Insert(obj);
    INCL(obj^.flags,flagUsed); (* so CloseScope does not warn on these objects *)
  END InsertProc;

PROCEDURE InitPredefined;
(* Initialize the "predefined" types and procedures *)
  VAR
    new: Object;
  BEGIN
    predefined:=NewObject(OS.undefStr,objScope,noPos); (* open the lowest scope of all *)
    predefined^.mnolev:=predeclMnolev; (* in order to get this level *)
    OpenScope(predefined);

    (* insert predefined types *)
    InsertPredeclStruct("BOOLEAN",strBool);
    InsertPredeclStruct("CHAR",strChar);
    InsertPredeclStruct("INTEGER",strInteger);
    InsertPredeclStruct("LONGINT",strLongInt);
    InsertPredeclStruct("LONGREAL",strLongReal);
    InsertPredeclStruct("NIL",strNil);
    InsertPredeclStruct("REAL",strReal);
    InsertPredeclStruct("SET",strSet);
    InsertPredeclStruct("SHORTINT",strShortInt);

    (* insert predefined procedures/functions *)
    InsertProc("ABS",predABS);
    InsertProc("ASH",predASH);
    InsertProc("ASSERT",predASSERT);
    InsertProc("CAP",predCAP);
    InsertProc("CHR",predCHR);
    InsertProc("COPY",predCOPY);
    InsertProc("DEC",predDEC);
    InsertProc("ENTIER",predENTIER);
    InsertProc("EXCL",predEXCL);
    InsertProc("HALT",predHALT);
    InsertProc("INC",predINC);
    InsertProc("INCL",predINCL);
    InsertProc("LEN",predLEN);
    InsertProc("LONG",predLONG);
    InsertProc("MAX",predMAX);
    InsertProc("MIN",predMIN);
    InsertProc("NEW",predNEW);
    InsertProc("ODD",predODD);
    InsertProc("ORD",predORD);
    InsertProc("SHORT",predSHORT);
    InsertProc("SIZE",predSIZE);

    (* the most common constants: TRUE & FALSE *)
    new:=NewObject("FALSE",objConst,noPos);
    new^.const:=NewConst(); new^.const^.intval:=0;
    new^.type:=predeclType[strBool]; Insert(new);
    new:=NewObject("TRUE",objConst,noPos);
    new^.const:=NewConst(); new^.const^.intval:=1;
    new^.type:=predeclType[strBool]; Insert(new);

(* some structs to be initialized, but no special object for them... *)
    predeclType[strUndef] :=NewStruct(strUndef);
    predeclType[strUndef]^.base:=predeclType[strUndef];
      (* This was a wish from Michael in order to
         not confuse the parser's procedure "Designator"
         for not defined types... *)
    predeclType[strString]:=NewStruct(strString);
    predeclType[strNone]  :=NewStruct(strNone);

    (* We DO NOT close this scope, because it is the lowest one and all
       (even the compiled module) scopes MUST be opened within it. *)

    OptimizeTree(predefined^.link); (* optimize, just for better performance *)
  END InitPredefined;

PROCEDURE InitSYSTEM;
(* Initialize the compilermodule "SYSTEM" *)
  BEGIN
    system:=NewObject(systemIdent,objModule,noPos);
    system^.const^.intval:=systemKey;
    system^.mnolev:=systemMnolev;
    system^.link^.mnolev:=systemMnolev;
    OpenScope(system^.link);

    InsertPredeclStruct("BYTE",strSysByte);
    InsertPredeclStruct("PTR",strSysPtr);

    InsertProc("ADR",sysADR);
    InsertProc("BIT",sysBIT);
    InsertProc("CC",sysCC);
    InsertProc("DISPOSE",sysDISPOSE);
    InsertProc("GET",sysGET);
    InsertProc("GETREG",sysGETREG);
    InsertProc("LSH",sysLSH);
    InsertProc("MOVE",sysMOVE);
    InsertProc("NEW",sysNEW);
    InsertProc("PUT",sysPUT);
    InsertProc("PUTREG",sysPUTREG);
    InsertProc("ROT",sysROT);
    InsertProc("VAL",sysVAL);

    OptimizeTree(system^.link^.link);
    CloseScope(TRUE);
  END InitSYSTEM;

PROCEDURE Cleanup*;
(* set all relevant pointers to NIL, so a garbage collection can collect all objects
   we no longer need *)
  VAR
    i: SHORTINT;
  BEGIN
    FlushSymbolCache;
    predefined:=NIL;
    CleanupScopeStack;
    compiledModule:=NIL; system:=NIL;
    cacheMnolev:=importMnolev;

    FOR i:=strUndef TO strSysPtr DO
      predeclType[i]:=NIL;
    END; (* FOR *)
  END Cleanup;

PROCEDURE InitTable*;
  BEGIN
    Cleanup;
    InitPredefined; InitSYSTEM;
    InitSymbolCache;
    external:=FALSE;
  END InitTable;

BEGIN
  InitScopeStack;
  collectedObjs:=NIL;
  Cleanup;
  InitSymbolCache;
END OTable.


