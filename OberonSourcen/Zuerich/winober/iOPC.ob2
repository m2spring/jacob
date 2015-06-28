MODULE iOPC;

   IMPORT iOPT, iOPS;

   CONST
      Nil* = -1;
      PtrToArrOffs* = 8;

   TYPE
      Item* = RECORD
         mode*, mnolev*, scale*: SHORTINT;
         typ*: iOPT.Struct;
         node*: iOPT.Node;
         adr*, offs*, inx*, descReg*, descOffs*: LONGINT;
      END;
      Label* = LONGINT;

   VAR
      RiscCodeErr*: BOOLEAN;
      level*: SHORTINT;
      pc*: INTEGER;

   PROCEDURE AbsVal* (VAR z, x: Item);
   BEGIN
   END AbsVal;

   PROCEDURE Add* (VAR z, x, y: Item; f: INTEGER);
   BEGIN
   END Add;

   PROCEDURE And* (VAR z, x, y: Item);
   BEGIN
   END And;

   PROCEDURE Ash* (VAR z, x, y: Item);
   BEGIN
   END Ash;

   PROCEDURE Assign* (VAR z, x: Item);
   BEGIN
   END Assign;

   PROCEDURE Call* (VAR x: Item; proc: iOPT.Object; node: iOPT.Node);
   BEGIN
   END Call;

   PROCEDURE Cap* (VAR z, x: Item);
   BEGIN
   END Cap;

   PROCEDURE Case* (VAR x: Item; low, high: LONGINT; VAR tab, L: LONGINT; node: iOPT.Node);
   BEGIN
   END Case;

   PROCEDURE CaseFixup* (tab, elseLabel, len: LONGINT);
   BEGIN
   END CaseFixup;

   PROCEDURE Cmp* (VAR z, x, y: Item; rel: INTEGER);
   BEGIN
   END Cmp;

   PROCEDURE CondAnd* (VAR x: Item);
   BEGIN
   END CondAnd;

   PROCEDURE CondOr* (VAR x: Item);
   BEGIN
   END CondOr;

   PROCEDURE Convert* (VAR x: Item; form: SHORTINT);
   BEGIN
   END Convert;

   PROCEDURE Copy* (VAR z, x: Item);
   BEGIN
   END Copy;

   PROCEDURE DeRef* (VAR x: Item);
   BEGIN
   END DeRef;

   PROCEDURE DefLabel* (VAR L: LONGINT);
   BEGIN
   END DefLabel;

   PROCEDURE Div* (VAR z, x, y: Item; f: INTEGER);
   BEGIN
   END Div;

   PROCEDURE Enter* (proc: iOPT.Object; dataSize: LONGINT; node: iOPT.Node);
   BEGIN
   END Enter;

   PROCEDURE Exit* (proc: iOPT.Object);
   BEGIN
   END Exit;

   PROCEDURE Field* (VAR x: Item; offset: LONGINT);
   BEGIN
   END Field;

   PROCEDURE FixLink* (L: LONGINT);
   BEGIN
   END FixLink;

   PROCEDURE GenDimTrap* (VAR len: Item);
   BEGIN
   END GenDimTrap;

   PROCEDURE In* (VAR z, x, y: Item);
   BEGIN
   END In;

   PROCEDURE IncDec* (VAR z, x: Item; increment: BOOLEAN);
   BEGIN
   END IncDec;

   PROCEDURE Include* (VAR z, x: Item; incl: BOOLEAN);
   BEGIN
   END Include;

   PROCEDURE Index* (VAR z, index: Item);
   BEGIN
   END Index;

   PROCEDURE Init* (opt: SET);
   BEGIN
   END Init;

   PROCEDURE Jcc* (VAR x: Item; VAR loc: LONGINT; node: iOPT.Node);
   BEGIN
   END Jcc;

   PROCEDURE Jmp* (VAR loc: LONGINT; node: iOPT.Node);
   BEGIN
   END Jmp;

   PROCEDURE Jncc* (VAR x: Item; VAR loc: LONGINT; node: iOPT.Node);
   BEGIN
   END Jncc;

   PROCEDURE Len* (VAR len, x, y: Item);
   BEGIN
   END Len;

   PROCEDURE MergedLinks* (L0, L1: LONGINT): LONGINT;
   BEGIN
    RETURN 0;
   END MergedLinks;

   PROCEDURE Mod* (VAR z, x, y: Item);
   BEGIN
   END Mod;

   PROCEDURE Msk* (VAR z, x, y: Item);
   BEGIN
   END Msk;

   PROCEDURE Mul* (VAR z, x, y: Item; f: INTEGER);
   BEGIN
   END Mul;

   PROCEDURE MulDim* (VAR nofelem, len: Item);
   BEGIN
   END MulDim;

   PROCEDURE Neg* (VAR z, x: Item);
   BEGIN
   END Neg;

   PROCEDURE NewArray* (VAR z, nofelem: Item; nofdim: LONGINT; typ: iOPT.Struct; dimUsed: BOOLEAN);
   BEGIN
   END NewArray;

   PROCEDURE NewRec* (VAR z: Item; typ: iOPT.Struct);
   BEGIN
   END NewRec;

   PROCEDURE NewStat* (textPos: LONGINT);
   BEGIN
   END NewStat;

   PROCEDURE NewSys* (VAR z, x: Item);
   BEGIN
   END NewSys;

   PROCEDURE Not* (VAR z, x: Item);
   BEGIN
   END Not;

   PROCEDURE Odd* (VAR z, x: Item);
   BEGIN
   END Odd;

   PROCEDURE Or* (VAR z, x, y: Item);
   BEGIN
   END Or;

   PROCEDURE Parameter* (VAR ap: Item; fp: iOPT.Object);
   BEGIN
   END Parameter;

   PROCEDURE PopLen* (VAR len: Item);
   BEGIN
   END PopLen;

   PROCEDURE PopResult* (n: iOPT.Node; VAR z: Item);
   BEGIN
   END PopResult;

   PROCEDURE Procedure* (VAR proc: Item; n: iOPT.Node);
   BEGIN
   END Procedure;

   PROCEDURE PushLen* (VAR z: Item);
   BEGIN
   END PushLen;

   PROCEDURE PushRegs*;
   BEGIN
   END PushRegs;

   PROCEDURE Relation* (VAR x: Item);
   BEGIN
   END Relation;

   PROCEDURE Return* (VAR res: Item; procform: SHORTINT);
   BEGIN
   END Return;

   PROCEDURE SYSdop* (VAR z, x, y: Item; subcl: SHORTINT);
   BEGIN
   END SYSdop;

   PROCEDURE SYSgetput* (VAR z, x: Item; getfn: BOOLEAN);
   BEGIN
   END SYSgetput;

   PROCEDURE SYSgetputReg* (VAR z, x: Item; getrfn: BOOLEAN);
   BEGIN
   END SYSgetputReg;

   PROCEDURE SYSmop* (VAR z, x: Item; subcl: SHORTINT; typ: iOPT.Struct);
   BEGIN
   END SYSmop;

   PROCEDURE SYSmove* (VAR z, x, nofBytes: Item);
   BEGIN
   END SYSmove;

   PROCEDURE SetElem* (VAR z, x: Item);
   BEGIN
   END SetElem;

   PROCEDURE SetRange* (VAR z, x, y: Item);
   BEGIN
   END SetRange;

   PROCEDURE Sub* (VAR z, x, y: Item; f: INTEGER);
   BEGIN
   END Sub;

   PROCEDURE Trap* (n: LONGINT; node: iOPT.Node);
   BEGIN
   END Trap;

   PROCEDURE TypeTest* (VAR x: Item; testtyp: iOPT.Struct; guard, equal, varRec: BOOLEAN);
   BEGIN
   END TypeTest;

END iOPC.
