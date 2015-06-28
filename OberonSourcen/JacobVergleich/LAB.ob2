MODULE LAB;
IMPORT OT, Base, Idents, STR, Strings, Strings1, SYSTEM;

TYPE T* = STR.tStr;

CONST MT*               = NIL;
VAR   Halt*             ,
      FirstModuleTDesc* ,
      IndexFault*       ,
      NilFault*         ,
      ElementFault*     ,
      DivFault*         ,
      TypeTestFault*    ,
      AbsFault*         ,
      ChrFault*         ,
      LenFault*         ,
      ShortFault*       ,
      GuardFault*       ,
      CaseFault*        ,
      WithFault*        ,
      AssertFail*       ,
      NILPROC*          ,
      FunctionFault*    ,
      NullChar*         ,
      BitRangeTab*      ,
      SingleBitTab*     ,
      StaticNew*        ,
      OpenNew*          ,
      SystemNew*        ,
      printf*           : T;

(* From CV *)

PROCEDURE String*(v:OT.oSTRING):T; END String;
PROCEDURE Real*(v:OT.oREAL):T; END Real;
PROCEDURE Longreal*(v:OT.oLONGREAL):T; END Longreal;

(************************************************************************************************************************)
PROCEDURE NewLocal*():T; 
CONST bufSize=30;
VAR n:LONGINT; buf:ARRAY 31 OF CHAR; dst:INTEGER; s:T;
BEGIN (* NewLocal *)			    
 n:=Base.ActP^.NextLocLabel; INC(Base.ActP^.NextLocLabel); 

 buf[bufSize]:=0X; dst:=bufSize-1; 
 REPEAT buf[dst]:=CHR(48+(n MOD 10)); n:=n DIV 10; DEC(dst); UNTIL n=0;
 buf[dst]:='L'; 

 s:=SYSTEM.VAL(T,SYSTEM.ADR(buf[dst])); 
 RETURN STR.Alloc(s^); 
END NewLocal;

PROCEDURE^NewGlobal*(id:Idents.tIdent):T; 

(************************************************************************************************************************)
PROCEDURE NewImplicit*(prefix:Idents.tIdent):T; 
CONST bufSize=30;
VAR n:LONGINT; buf:ARRAY 31 OF CHAR; dst:INTEGER; s:T;
BEGIN (* NewImplicit *)
 n:=Base.ActP^.NextLocLabel; INC(Base.ActP^.NextLocLabel); 

 buf[bufSize]:=0X; dst:=bufSize-1; 
 REPEAT buf[dst]:=CHR(48+(n MOD 10)); n:=n DIV 10; DEC(dst); UNTIL n=0;
 buf[dst]:='$'; 

 s:=SYSTEM.VAL(T,SYSTEM.ADR(buf[dst])); 
 RETURN STR.AppS(NewGlobal(prefix),s^); 
END NewImplicit;

(************************************************************************************************************************)
PROCEDURE NewGlobal*(id:Idents.tIdent):T; 
VAR str:Strings.tString; arr:ARRAY Strings.cMaxStrLength+2 OF CHAR; 
BEGIN (* NewGlobal *)
 IF id=Idents.NoIdent THEN 
    arr:=''; 
 ELSE 
    Idents.GetString(id,str); Strings.StringToArray(str,arr); 
 END; (* IF *)
 RETURN STR.Alloc(arr); 
END NewGlobal;

(************************************************************************************************************************)
PROCEDURE AppS*(lab:T; s:ARRAY OF CHAR):T; 
BEGIN (* AppS *)
 RETURN STR.AppS(lab,s); 
END AppS;

(************************************************************************************************************************)
PROCEDURE App_Id*(lab:T; id:Idents.tIdent):T; 
VAR str:Strings.tString; arr:ARRAY Strings.cMaxStrLength+2 OF CHAR; 
BEGIN (* App_Id *)
 Idents.GetString(id,str); Strings.StringToArray(str,arr); 
 STR.Prepend(arr,'_'); 

 RETURN STR.AppS(lab,arr); 
END App_Id;

(************************************************************************************************************************)
PROCEDURE MakeGlobal*(isExported:BOOLEAN; prefix:T; id:Idents.tIdent):T; 
BEGIN (* MakeGlobal *)
 IF isExported THEN RETURN App_Id(prefix,id); ELSE RETURN NewLocal(); END; (* IF *)
END MakeGlobal;

(************************************************************************************************************************)
PROCEDURE MakeBound*(prefix:T; idType,idProc:Idents.tIdent):T; 
VAR str:Strings.tString; aType,aProc:ARRAY Strings.cMaxStrLength+2 OF CHAR; 
    arr:ARRAY 2*Strings.cMaxStrLength+4 OF CHAR; 
BEGIN (* MakeBound *)
 Idents.GetString(idType,str); Strings.StringToArray(str,aType); 
 Idents.GetString(idProc,str); Strings.StringToArray(str,aProc); 
 STR.Conc4(arr,'_',aType,'_',aProc); 

 RETURN STR.AppS(prefix,arr); 
END MakeBound;

(************************************************************************************************************************)
PROCEDURE MakeForeign*(id:Idents.tIdent):T; 
VAR str:Strings.tString; arr:ARRAY Strings.cMaxStrLength+2 OF CHAR; 
BEGIN (* MakeForeign *)
 Idents.GetString(id,str); Strings.StringToArray(str,arr); 
 STR.Prepend(arr,'_'); 

 RETURN STR.Alloc(arr); 
END MakeForeign;

(************************************************************************************************************************)
PROCEDURE New*(VAR lab:T):T; 
BEGIN (* New *)
 lab:=NewLocal(); RETURN lab; 
END New;

(************************************************************************************************************************)
PROCEDURE Equal*(l1,l2:T):BOOLEAN; 
BEGIN (* Equal *)
 IF (l1=MT) OR (l2=MT) THEN 
    RETURN l1=l2; 
 ELSE 
    RETURN Strings1.StrEq(l1^,l2^); 
 END; (* IF *)
END Equal;

(************************************************************************************************************************)
BEGIN (* LAB *)
 Halt             := STR.Alloc('_Halt'            ); 
 NILPROC          := STR.Alloc('_NILPROC'         ); 
 FunctionFault    := STR.Alloc('_FunctionFault'   ); 
 IndexFault       := STR.Alloc('_IndexFault'      ); 
 NilFault         := STR.Alloc('_NilFault'        ); 
 ElementFault     := STR.Alloc('_ElementFault'    ); 
 DivFault         := STR.Alloc('_DivFault'        ); 
 TypeTestFault    := STR.Alloc('_TypeTestFault'   ); 
 AbsFault         := STR.Alloc('_AbsFault'        ); 
 ChrFault         := STR.Alloc('_ChrFault'        ); 
 LenFault         := STR.Alloc('_LenFault'        ); 
 ShortFault       := STR.Alloc('_ShortFault'      ); 
 GuardFault       := STR.Alloc('_GuardFault'      ); 
 CaseFault        := STR.Alloc('_CaseFault'       ); 
 WithFault        := STR.Alloc('_WithFault'       ); 
 AssertFail       := STR.Alloc('_AssertFail'      ); 
 NullChar         := STR.Alloc('_NullChar'        ); 
 BitRangeTab      := STR.Alloc('_BitRangeTab'     ); 
 SingleBitTab     := STR.Alloc('_SingleBitTab'    ); 
 StaticNew        := STR.Alloc('_$staticNEW'      ); 
 OpenNew          := STR.Alloc('_$openNEW'        ); 
 SystemNew        := STR.Alloc('_SYSTEM$NEW'      ); 
 printf           := STR.Alloc('_printf'          ); 
 FirstModuleTDesc := STR.Alloc('_FirstModuleTDesc'); 
END LAB.

