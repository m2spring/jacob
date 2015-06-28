MODULE FoldElems;

   IMPORT Texts;

   CONST
      colLeft* = 0;
      colRight* = 1;
      expLeft* = 3;
      expRight* = 2;
      findLeft* = 5;
      tempLeft* = 4;

   TYPE
      CheckProc* = PROCEDURE (e: Texts.Elem): BOOLEAN;
      Elem* = POINTER TO ElemDesc;
      ElemDesc* = RECORD (Texts.ElemDesc)
         mode*: SHORTINT;
         hidden*: Texts.Buffer;
      END;

   PROCEDURE Collapse*;
   BEGIN
   END Collapse;

   PROCEDURE CollapseAll* (t: Texts.Text; modes: SET);
   BEGIN
   END CollapseAll;

   PROCEDURE Echo* (t: Texts.Text; on: BOOLEAN);
   BEGIN
   END Echo;

   PROCEDURE ElemPos* (e: Texts.Elem): LONGINT;
   BEGIN
    RETURN 0;
   END ElemPos;

   PROCEDURE Expand*;
   BEGIN
   END Expand;

   PROCEDURE ExpandAll* (t: Texts.Text; from: LONGINT; temporal: BOOLEAN);
   BEGIN
   END ExpandAll;

   PROCEDURE FindElem* (t: Texts.Text; pos: LONGINT; P: CheckProc; VAR elem: Texts.Elem; VAR elemPos: LONGINT);
   BEGIN
   END FindElem;

   PROCEDURE FoldHandler* (e: Texts.Elem; VAR m: Texts.ElemMsg);
   BEGIN
   END FoldHandler;

   PROCEDURE Insert*;
   BEGIN
   END Insert;

   PROCEDURE InsertCollapsed*;
   BEGIN
   END InsertCollapsed;

   PROCEDURE Marks*;
   BEGIN
   END Marks;

   PROCEDURE New*;
   BEGIN
   END New;

   PROCEDURE Search*;
   BEGIN
   END Search;

   PROCEDURE Switch* (e: Elem; pos: LONGINT);
   BEGIN
   END Switch;

END FoldElems.
