MODULE Files;

   IMPORT SYSTEM, Kernel;

   TYPE
      File* = POINTER TO Handle;
      Handle* = RECORD (Kernel.FinObjDesc)
      END;
      Rider* = RECORD
         eof*: BOOLEAN;
         res*: LONGINT;
      END;

   PROCEDURE Base* (VAR r: Rider): File;
   BEGIN
    RETURN NIL;
   END Base;

   PROCEDURE Close* (f: File);
   BEGIN
   END Close;

   PROCEDURE Delete* (name: ARRAY OF CHAR; VAR res: INTEGER);
   BEGIN
   END Delete;

   PROCEDURE GetDate* (f: File; VAR t, d: LONGINT);
   BEGIN
   END GetDate;

   PROCEDURE Length* (f: File): LONGINT;
   BEGIN
    RETURN 0;
   END Length;

   PROCEDURE New* (name: ARRAY OF CHAR): File;
   BEGIN
    RETURN NIL;
   END New;

   PROCEDURE Old* (name: ARRAY OF CHAR): File;
   BEGIN
    RETURN NIL;
   END Old;

   PROCEDURE Pos* (VAR r: Rider): LONGINT;
   BEGIN
    RETURN 0;
   END Pos;

   PROCEDURE Purge* (f: File);
   BEGIN
   END Purge;

   PROCEDURE Read* (VAR r: Rider; VAR x: SYSTEM.BYTE);
   BEGIN
   END Read;

   PROCEDURE ReadBool* (VAR R: Rider; VAR x: BOOLEAN);
   BEGIN
   END ReadBool;

   PROCEDURE ReadBytes* (VAR r: Rider; VAR x: ARRAY OF SYSTEM.BYTE; n: LONGINT);
   BEGIN
   END ReadBytes;

   PROCEDURE ReadInt* (VAR R: Rider; VAR x: INTEGER);
   BEGIN
   END ReadInt;

   PROCEDURE ReadLInt* (VAR R: Rider; VAR x: LONGINT);
   BEGIN
   END ReadLInt;

   PROCEDURE ReadLReal* (VAR R: Rider; VAR x: LONGREAL);
   BEGIN
   END ReadLReal;

   PROCEDURE ReadNum* (VAR R: Rider; VAR x: LONGINT);
   BEGIN
   END ReadNum;

   PROCEDURE ReadReal* (VAR R: Rider; VAR x: REAL);
   BEGIN
   END ReadReal;

   PROCEDURE ReadSet* (VAR R: Rider; VAR x: SET);
   BEGIN
   END ReadSet;

   PROCEDURE ReadString* (VAR R: Rider; VAR x: ARRAY OF CHAR);
   BEGIN
   END ReadString;

   PROCEDURE Register* (f: File);
   BEGIN
   END Register;

   PROCEDURE Rename* (old, new: ARRAY OF CHAR; VAR res: INTEGER);
   BEGIN
   END Rename;

   PROCEDURE Set* (VAR r: Rider; f: File; pos: LONGINT);
   BEGIN
   END Set;

   PROCEDURE Write* (VAR r: Rider; x: SYSTEM.BYTE);
   BEGIN
   END Write;

   PROCEDURE WriteBool* (VAR R: Rider; x: BOOLEAN);
   BEGIN
   END WriteBool;

   PROCEDURE WriteBytes* (VAR r: Rider; VAR x: ARRAY OF SYSTEM.BYTE; n: LONGINT);
   BEGIN
   END WriteBytes;

   PROCEDURE WriteInt* (VAR R: Rider; x: INTEGER);
   BEGIN
   END WriteInt;

   PROCEDURE WriteLInt* (VAR R: Rider; x: LONGINT);
   BEGIN
   END WriteLInt;

   PROCEDURE WriteLReal* (VAR R: Rider; x: LONGREAL);
   BEGIN
   END WriteLReal;

   PROCEDURE WriteNum* (VAR R: Rider; x: LONGINT);
   BEGIN
   END WriteNum;

   PROCEDURE WriteReal* (VAR R: Rider; x: REAL);
   BEGIN
   END WriteReal;

   PROCEDURE WriteSet* (VAR R: Rider; x: SET);
   BEGIN
   END WriteSet;

   PROCEDURE WriteString* (VAR R: Rider; x: ARRAY OF CHAR);
   BEGIN
   END WriteString;

END Files.
