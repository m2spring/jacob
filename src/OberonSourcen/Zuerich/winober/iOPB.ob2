MODULE iOPB;

   IMPORT iOPT, iOPS;

   VAR
      typSize*: PROCEDURE (typ: iOPT.Struct; allocDesc: BOOLEAN);

   PROCEDURE Assign* (VAR x: iOPT.Node; y: iOPT.Node);
   BEGIN
   END Assign;

   PROCEDURE Call* (VAR x: iOPT.Node; apar: iOPT.Node; fp: iOPT.Object);
   BEGIN
   END Call;

   PROCEDURE CheckParameters* (fp, ap: iOPT.Object; checkNames: BOOLEAN);
   BEGIN
   END CheckParameters;

   PROCEDURE Construct* (class: SHORTINT; VAR x: iOPT.Node; y: iOPT.Node);
   BEGIN
   END Construct;

   PROCEDURE DeRef* (VAR x: iOPT.Node);
   BEGIN
   END DeRef;

   PROCEDURE EmptySet* (): iOPT.Node;
   BEGIN
    RETURN NIL;
   END EmptySet;

   PROCEDURE Enter* (VAR procdec: iOPT.Node; stat: iOPT.Node; proc: iOPT.Object);
   BEGIN
   END Enter;

   PROCEDURE Field* (VAR x: iOPT.Node; y: iOPT.Object);
   BEGIN
   END Field;

   PROCEDURE In* (VAR x: iOPT.Node; y: iOPT.Node);
   BEGIN
   END In;

   PROCEDURE Index* (VAR x: iOPT.Node; y: iOPT.Node);
   BEGIN
   END Index;

   PROCEDURE Inittd* (VAR inittd, last: iOPT.Node; typ: iOPT.Struct);
   BEGIN
   END Inittd;

   PROCEDURE Link* (VAR x, last: iOPT.Node; y: iOPT.Node);
   BEGIN
   END Link;

   PROCEDURE MOp* (op: SHORTINT; VAR x: iOPT.Node);
   BEGIN
   END MOp;

   PROCEDURE NewBoolConst* (boolval: BOOLEAN): iOPT.Node;
   BEGIN
    RETURN NIL;
   END NewBoolConst;

   PROCEDURE NewIntConst* (intval: LONGINT): iOPT.Node;
   BEGIN
    RETURN NIL;
   END NewIntConst;

   PROCEDURE NewLeaf* (obj: iOPT.Object): iOPT.Node;
   BEGIN
    RETURN NIL;
   END NewLeaf;

   PROCEDURE NewRealConst* (realval: LONGREAL; typ: iOPT.Struct): iOPT.Node;
   BEGIN
    RETURN NIL;
   END NewRealConst;

   PROCEDURE NewString* (VAR str: iOPS.String; len: LONGINT): iOPT.Node;
   BEGIN
    RETURN NIL;
   END NewString;

   PROCEDURE Nil* (): iOPT.Node;
   BEGIN
    RETURN NIL;
   END Nil;

   PROCEDURE Op* (op: SHORTINT; VAR x: iOPT.Node; y: iOPT.Node);
   BEGIN
   END Op;

   PROCEDURE OptIf* (VAR x: iOPT.Node);
   BEGIN
   END OptIf;

   PROCEDURE Param* (ap: iOPT.Node; fp: iOPT.Object);
   BEGIN
   END Param;

   PROCEDURE PrepCall* (VAR x: iOPT.Node; VAR fpar: iOPT.Object);
   BEGIN
   END PrepCall;

   PROCEDURE Return* (VAR x: iOPT.Node; proc: iOPT.Object);
   BEGIN
   END Return;

   PROCEDURE SetElem* (VAR x: iOPT.Node);
   BEGIN
   END SetElem;

   PROCEDURE SetRange* (VAR x: iOPT.Node; y: iOPT.Node);
   BEGIN
   END SetRange;

   PROCEDURE StFct* (VAR par0: iOPT.Node; fctno: SHORTINT; parno: INTEGER);
   BEGIN
   END StFct;

   PROCEDURE StPar0* (VAR par0: iOPT.Node; fctno: INTEGER);
   BEGIN
   END StPar0;

   PROCEDURE StPar1* (VAR par0: iOPT.Node; x: iOPT.Node; fctno: SHORTINT);
   BEGIN
   END StPar1;

   PROCEDURE StParN* (VAR par0: iOPT.Node; x: iOPT.Node; fctno, n: INTEGER);
   BEGIN
   END StParN;

   PROCEDURE StaticLink* (dlev: SHORTINT);
   BEGIN
   END StaticLink;

   PROCEDURE TypTest* (VAR x: iOPT.Node; obj: iOPT.Object; guard: BOOLEAN);
   BEGIN
   END TypTest;

END iOPB.
