MODULE iOPT;

   IMPORT iOPS;

   CONST
      HdProcName* = "@proc";
      HdPtrName* = "@ptr";
      HdTProcName* = "@tproc";
      MaxConstLen* = 256;

   TYPE
      Const* = POINTER TO ConstDesc;
      ConstExt* = POINTER TO iOPS.String;
      ConstDesc* = RECORD
         ext*: ConstExt;
         intval*, intval2*: LONGINT;
         setval*: SET;
         realval*: LONGREAL;
      END;
      Node* = POINTER TO NodeDesc;
      Struct* = POINTER TO StrDesc;
      Object* = POINTER TO ObjDesc;
      NodeDesc* = RECORD
         left*, right*, link*: Node;
         class*, subcl*: SHORTINT;
         readonly*: BOOLEAN;
         typ*: Struct;
         obj*: Object;
         conval*: Const;
      END;
      ObjDesc* = RECORD
         left*, right*, link*, scope*: Object;
         name*: iOPS.Name;
         leaf*: BOOLEAN;
         mode*, mnolev*, vis*: SHORTINT;
         typ*: Struct;
         conval*: Const;
         adr*, linkadr*: LONGINT;
      END;
      StrDesc* = RECORD
         form*, comp*, mno*, extlev*: SHORTINT;
         ref*, sysflag*: INTEGER;
         n*, size*, tdadr*, offset*, txtpos*: LONGINT;
         BaseTyp*: Struct;
         link*, strobj*: Object;
      END;

   VAR
      GlbMod*: ARRAY 31 OF Object;
      SYSimported*: BOOLEAN;
      booltyp*: Struct;
      bytetyp*: Struct;
      chartyp*: Struct;
      inttyp*: Struct;
      linttyp*: Struct;
      lrltyp*: Struct;
      niltyp*: Struct;
      nofGmod*: SHORTINT;
      notyp*: Struct;
      realtyp*: Struct;
      settyp*: Struct;
      sinttyp*: Struct;
      stringtyp*: Struct;
      sysptrtyp*: Struct;
      topScope*: Object;
      undftyp*: Struct;

   PROCEDURE Close*;
   BEGIN
   END Close;

   PROCEDURE CloseScope*;
   BEGIN
   END CloseScope;

   PROCEDURE Export* (VAR modName: iOPS.Name; VAR newSF: BOOLEAN; VAR key: LONGINT);
   BEGIN
   END Export;

   PROCEDURE Find* (VAR res: Object);
   BEGIN
   END Find;

   PROCEDURE FindField* (name: iOPS.Name; typ: Struct; VAR res: Object);
   BEGIN
   END FindField;

   PROCEDURE FindImport* (mod: Object; VAR res: Object);
   BEGIN
   END FindImport;

   PROCEDURE Import* (VAR aliasName, impName, selfName: iOPS.Name);
   BEGIN
   END Import;

   PROCEDURE Init*;
   BEGIN
   END Init;

   PROCEDURE Insert* (name: iOPS.Name; VAR obj: Object);
   BEGIN
   END Insert;

   PROCEDURE NewConst* (): Const;
   BEGIN
    RETURN NIL;
   END NewConst;

   PROCEDURE NewExt* (): ConstExt;
   BEGIN
    RETURN NIL;
   END NewExt;

   PROCEDURE NewNode* (class: SHORTINT): Node;
   BEGIN
    RETURN NIL;
   END NewNode;

   PROCEDURE NewObj* (): Object;
   BEGIN
    RETURN NIL;
   END NewObj;

   PROCEDURE NewStr* (form, comp: SHORTINT): Struct;
   BEGIN
    RETURN NIL;
   END NewStr;

   PROCEDURE OpenScope* (level: SHORTINT; owner: Object);
   BEGIN
   END OpenScope;

END iOPT.
