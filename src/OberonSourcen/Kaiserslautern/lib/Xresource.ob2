MODULE Xresource (*!["C"] EXTERNAL [""]*);
(* 
This file was generated in a semi-automatic way from the original C header
files.  It may (or rather will) contain errors, since the translation of 
certain C types and parameters into Oberon-2 is ambiguous (not to speak of 
other error sources). 
X11.Mod, Xutil.Mod, and Xresource.Mod are untested.  I'm open to suggestions
to improve these files.  -- MvA, oberon1@informatik.uni-kl.de  
*)

IMPORT
  C := CType, X := X11;


(****************************************************************
 ****************************************************************
 ***                                                          ***
 ***                                                          ***
 ***          X Resource Manager Intrinsics                   ***
 ***                                                          ***
 ***                                                          ***
 ****************************************************************
 ****************************************************************)


TYPE
  XrmQuark* = C.int;
  XrmQuarkList* = POINTER TO ARRAY OF XrmQuark;
  XrmString* = C.charPtr1d;

CONST
  NULLQUARK* = 0;
  NULLSTRING* = NIL;
  
CONST  (* enum XrmBinding *)
  XrmBindTightly* = 0;
  XrmBindLoosely* = 1;

TYPE
  XrmBinding* = C.enum1;
  XrmBindingList* = POINTER TO ARRAY OF XrmBinding;

TYPE
  XrmName* = XrmQuark;
  XrmNameList* = XrmQuarkList;
  XrmClass* = XrmQuark;
  XrmClassList* = XrmQuarkList;

TYPE
  XrmRepresentation* = XrmQuark;
  XrmValuePtr* = POINTER TO XrmValue;
  XrmValue* = RECORD
    size*: C.int;
    addr*: X.XPointer;
  END;

TYPE
  XrmHashBucketDesc = RECORD END;  
  XrmHashBucket* = POINTER TO XrmHashBucketDesc;
  XrmHashTable* = POINTER TO ARRAY OF XrmHashBucket;
  XrmSearchList* = POINTER TO ARRAY OF XrmHashTable;
  XrmDatabase* = POINTER TO XrmHashBucketDesc;

CONST
  XrmEnumAllLevels* = 0;
  XrmEnumOneLevel* = 1;

TYPE
  EnumProc* = PROCEDURE (VAR db: XrmDatabase; bindings: XrmBindingList; 
                         quarks: XrmQuarkList; VAR type: XrmRepresentation;
                         VAR value: XrmValue; closure: X.XPointer): X.Bool;

CONST  (* enum XrmOptionKind *)
  XrmoptionNoArg* = 0;
  XrmoptionIsArg* = 1;
  XrmoptionStickyArg* = 2;
  XrmoptionSepArg* = 3;
  XrmoptionResArg* = 4;
  XrmoptionSkipArg* = 5;
  XrmoptionSkipLine* = 6;
  XrmoptionSkipNArgs* = 7;

TYPE
  XrmOptionKind* = C.enum1;
  XrmOptionDescRecPtr* = POINTER TO XrmOptionDescRec;
  XrmOptionDescRec* = RECORD
    option*: C.charPtr1d;       (* Option abbreviation in argv	    *)
    specifier*: C.charPtr1d;    (* Resource specifier		    *)
    argKind*: XrmOptionKind;    (* Which style of option it is	    *)
    value*: X.XPointer;         (* Value to provide if XrmoptionNoArg   *)
  END;
  XrmOptionDescList* = POINTER TO ARRAY OF XrmOptionDescRec;
  
                         
(****************************************************************
 *
 * Memory Management
 *
 ****************************************************************)

PROCEDURE Xpermalloc* (
    size: C.int): C.address;
(*<*)END Xpermalloc;(*>*)

(****************************************************************
 *
 * Quark Management
 *
 ****************************************************************)

(* find quark for string, create new quark if none already exists *)
PROCEDURE XrmStringToQuark* (
    string: ARRAY OF C.char): XrmQuark;
(*<*)END XrmStringToQuark;(*>*)
PROCEDURE XrmPermStringToQuark* (
    string: ARRAY OF C.char): XrmQuark;

(* find string for quark *)
(*<*)END XrmPermStringToQuark;(*>*)
PROCEDURE XrmQuarkToString* (
    quark: XrmQuark): XrmString;
(*<*)END XrmQuarkToString;(*>*)
PROCEDURE XrmUniqueQuark* (): XrmQuark;
(*<*)END XrmUniqueQuark;(*>*)

(****************************************************************
 *
 * Conversion of Strings to Lists
 *
 ****************************************************************)
 
PROCEDURE XrmStringToQuarkList* (
    string: ARRAY OF C.char;
    VAR quarks_return: ARRAY OF XrmQuark);
(*<*)END XrmStringToQuarkList;(*>*)
PROCEDURE XrmStringToBindingQuarkList* (
    string: ARRAY OF C.char;
    VAR bindings_return: ARRAY OF XrmBinding;
    VAR quarks_return: ARRAY OF XrmQuark): C.int;
(*<*)END XrmStringToBindingQuarkList;(*>*)

(****************************************************************
 *
 * Name and Class lists.
 *
 ****************************************************************)

PROCEDURE XrmNameToString* (*!["XrmQuarkToString"]*) (
    quark: XrmQuark): XrmString;
(*<*)END XrmNameToString;(*>*)
PROCEDURE XrmStringToName* (*!["XrmStringToQuark"]*) (
    string: ARRAY OF C.char): XrmQuark;
(*<*)END XrmStringToName;(*>*)
PROCEDURE XrmStringToNameList* (*!["XrmStringToQuarkList"]*) (
    string: ARRAY OF C.char;
    VAR quarks_return: ARRAY OF XrmQuark);
(*<*)END XrmStringToNameList;(*>*)

PROCEDURE XrmClassToString* (*!["XrmQuarkToString"]*) (
    quark: XrmQuark): XrmString;
(*<*)END XrmClassToString;(*>*)
PROCEDURE XrmStringToClass* (*!["XrmStringToQuark"]*) (
    string: ARRAY OF C.char): XrmQuark;
(*<*)END XrmStringToClass;(*>*)
PROCEDURE XrmStringToClassList* (*!["XrmStringToQuarkList"]*) (
    string: ARRAY OF C.char;
    VAR quarks_return: ARRAY OF XrmQuark);
(*<*)END XrmStringToClassList;(*>*)

(****************************************************************
 *
 * Resource Representation Types and Values
 *
 ****************************************************************)

PROCEDURE XrmStringToRepresentation* (*!["XrmStringToQuark"]*) (
    string: ARRAY OF C.char): XrmQuark;
(*<*)END XrmStringToRepresentation;(*>*)
PROCEDURE XrmRepresentationToString* (*!["XrmQuarkToString"]*) (
    quark: XrmQuark): XrmString;
(*<*)END XrmRepresentationToString;(*>*)

(****************************************************************
 *
 * Resource Manager Functions
 *
 ****************************************************************)

PROCEDURE XrmDestroyDatabase* (
    database: XrmDatabase);
(*<*)END XrmDestroyDatabase;(*>*)
PROCEDURE XrmQPutResource* (
    VAR database: XrmDatabase;
    bindings: XrmBindingList;
    quarks: XrmQuarkList;
    type: XrmRepresentation;
    value: XrmValuePtr);
(*<*)END XrmQPutResource;(*>*)
PROCEDURE XrmPutResource* (
    VAR database: XrmDatabase;
    specifier: ARRAY OF C.char;
    type: ARRAY OF C.char;
    value: XrmValuePtr);
(*<*)END XrmPutResource;(*>*)
PROCEDURE XrmQPutStringResource* (
    VAR database: XrmDatabase;
    bindings: XrmBindingList;
    quarks: XrmQuarkList;
    value: ARRAY OF C.char);
(*<*)END XrmQPutStringResource;(*>*)
PROCEDURE XrmPutStringResource* (
    VAR database: XrmDatabase;
    specifier: ARRAY OF C.char;
    value: ARRAY OF C.char);
(*<*)END XrmPutStringResource;(*>*)
PROCEDURE XrmPutLineResource* (
    VAR database: XrmDatabase;
    line: ARRAY OF C.char);
(*<*)END XrmPutLineResource;(*>*)
PROCEDURE XrmQGetResource* (
    database: XrmDatabase;
    quark_name: XrmNameList;
    quark_class: XrmClassList;
    VAR quark_type_return: XrmRepresentation;
    VAR value_return: XrmValue);
(*<*)END XrmQGetResource;(*>*)
PROCEDURE XrmGetResource* (
    database: XrmDatabase;
    str_name: ARRAY OF C.char;
    str_class: ARRAY OF C.char;
    VAR str_type_return: C.char;
    VAR value_return: XrmValue): X.Bool;
(*<*)END XrmGetResource;(*>*)
PROCEDURE XrmQGetSearchList* (
    database: XrmDatabase;
    names: XrmNameList;
    classes: XrmClassList;
    list_return: XrmSearchList;
    list_length: C.int): X.Bool;
(*<*)END XrmQGetSearchList;(*>*)
PROCEDURE XrmQGetSearchResource* (
    list: XrmSearchList;
    name: XrmName;
    class: XrmClass;
    VAR type_return: XrmRepresentation;
    VAR value_return: XrmValue): X.Bool;
(*<*)END XrmQGetSearchResource;(*>*)
    
(****************************************************************
 *
 * Resource Database Management
 *
 ****************************************************************)
 
PROCEDURE XrmSetDatabase* (
    display: X.DisplayPtr;
    database: XrmDatabase);
(*<*)END XrmSetDatabase;(*>*)
PROCEDURE XrmGetDatabase* (
    display: X.DisplayPtr): XrmDatabase;
(*<*)END XrmGetDatabase;(*>*)
PROCEDURE XrmGetFileDatabase* (
    filename: ARRAY OF C.char): XrmDatabase;
(*<*)END XrmGetFileDatabase;(*>*)
PROCEDURE XrmCombineFileDatabase* (
    filename: ARRAY OF C.char;
    VAR target: XrmDatabase;
    override: X.Bool): X.Status;
(*<*)END XrmCombineFileDatabase;(*>*)
PROCEDURE XrmGetStringDatabase* (
    data: ARRAY OF C.char): XrmDatabase;
(*<*)END XrmGetStringDatabase;(*>*)
PROCEDURE XrmPutFileDatabase* (
    database: XrmDatabase;
    filename: ARRAY OF C.char);
(*<*)END XrmPutFileDatabase;(*>*)
PROCEDURE XrmMergeDatabases* (
    source_db: XrmDatabase;
    VAR target_db: XrmDatabase);
(*<*)END XrmMergeDatabases;(*>*)
PROCEDURE XrmCombineDatabase* (
    source_db: XrmDatabase;
    VAR target_db: XrmDatabase;
    override: X.Bool);
(*<*)END XrmCombineDatabase;(*>*)
PROCEDURE XrmEnumerateDatabase* (
    db: XrmDatabase;
    name_prefix: XrmNameList;
    class_prefix: XrmClassList;
    mode: C.int;
    proc: EnumProc;
    closure: X.XPointer): X.Bool;
(*<*)END XrmEnumerateDatabase;(*>*)
PROCEDURE XrmLocaleOfDatabase* (
    database: XrmDatabase): C.charPtr1d;
(*<*)END XrmLocaleOfDatabase;(*>*)

(****************************************************************
 *
 * Command line option mapping to resource entries
 *
 ****************************************************************)
PROCEDURE XrmParseCommand* (
    VAR database: XrmDatabase;
    table: XrmOptionDescList;
    table_count: C.int;
    name: ARRAY OF C.char;
    VAR argc_in_out: C.int;
    VAR argv_in_out: ARRAY OF C.charPtr1d);
(*<*)END XrmParseCommand;(*>*)

END Xresource.
