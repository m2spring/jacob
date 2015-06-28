DEFINITION MODULE LAB;

IMPORT Idents, STR;

TYPE T = STR.tStr;

(*$1*)
CONST MT               = NIL;
VAR   Halt             ,
      FirstModuleTDesc ,
      IndexFault       ,
      NilFault         ,
      ElementFault     ,
      DivFault         ,
      AbsFault         ,
      ChrFault         ,
      LenFault         ,
      ShortFault       ,
      GuardFault       ,
      CaseFault        ,
      WithFault        ,
      AssertFail       ,
      NILPROC          ,
      FunctionFault    ,
      NullChar         ,
      BitRangeTab      ,
      SingleBitTab     ,
      StaticNew        ,
      OpenNew          ,
      SystemNew        ,
      printf           : T;

PROCEDURE NewLocal():T; 
(*
 * Yields a new local label according to the counter 'FIL.ActP^.NextLocLabel'.
 *)
 
PROCEDURE NewImplicit(prefix:Idents.tIdent):T; 
(*
 * Yields a new implicit label.
 *)
 
PROCEDURE NewGlobal(id:Idents.tIdent):T; 
(*
 * Yields the label with the same representation as the one of 'id'.
 *)
 
PROCEDURE AppS(lab:T; s:ARRAY OF CHAR):T; 
(*
 * Yields the concatenation of 'lab' and 's'.
 *)
 
PROCEDURE App_Id(lab:T; id:Idents.tIdent):T; 
(*
 * Yields 'lab' concat "_" concat 'id'.
 *)

PROCEDURE MakeGlobal(isExported:BOOLEAN; prefix:T; id:Idents.tIdent):T; 
(*
 *   'isExported': result = 'prefix' concat "_" concat 'id'.
 * ~ 'isExported': result = NewLocal().
 *)
 
PROCEDURE MakeBound(prefix:T; idType,idProc:Idents.tIdent):T; 
(*
 * Yields 'prefix' concat "_" concat 'idType' concat 'idProc'.
 *)
 
PROCEDURE MakeForeign(id:Idents.tIdent):T; 
(*
 * Yields "_" concat 'id'.
 *)
 
PROCEDURE New(VAR lab:T):T;
(*
 * Yields a new local label. 'lab' := result.
 *)

PROCEDURE Equal(l1,l2:T):BOOLEAN; 
(*
 * Guess!
 *)
 
END LAB.
