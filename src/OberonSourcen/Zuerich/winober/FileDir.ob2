MODULE FileDir;

   CONST
      HostNameLen* = 14;
      NameLen* = 32;
      PathLen* = 128;

   TYPE
      Path* = ARRAY 128 OF CHAR;
      FileName* = ARRAY 32 OF CHAR;
      HostName* = ARRAY 14 OF CHAR;
      Directory* = POINTER TO DirectoryDesc;
      DirectoryDesc* = RECORD
         path*: Path;
      END;
      Entry* = POINTER TO EntryDesc;
      EntryDesc* = RECORD
         dir*: Directory;
         name*: FileName;
         hostname*: HostName;
      END;
      EntryHandler* = PROCEDURE (name, dosName: ARRAY OF CHAR);

   PROCEDURE ChangeDirectory* (path: ARRAY OF CHAR);
   BEGIN
   END ChangeDirectory;

   PROCEDURE CurrentDirectory* (): Directory;
   BEGIN
    RETURN NIL;
   END CurrentDirectory;

   PROCEDURE Delete* (dir: Directory; VAR name: ARRAY OF CHAR);
   BEGIN
   END Delete;

   PROCEDURE Enumerate* (D: Directory; H: EntryHandler);
   BEGIN
   END Enumerate;

   PROCEDURE Exists* (dir: Directory; VAR hostname: ARRAY OF CHAR): BOOLEAN;
   BEGIN
    RETURN FALSE;
   END Exists;

   PROCEDURE GetNextInSearchPath* (VAR pathNo: LONGINT; VAR D: Directory);
   BEGIN
   END GetNextInSearchPath;

   PROCEDURE InsertEntry* (D: Directory; e: Entry);
   BEGIN
   END InsertEntry;

   PROCEDURE Map* (VAR name, hostname: ARRAY OF CHAR);
   BEGIN
   END Map;

   PROCEDURE NextMapping* (this: ARRAY OF CHAR; VAR next: ARRAY OF CHAR);
   BEGIN
   END NextMapping;

   PROCEDURE OpenSearchPath* (VAR pathNo: LONGINT);
   BEGIN
   END OpenSearchPath;

   PROCEDURE RemoveEntry* (D: Directory; e: Entry);
   BEGIN
   END RemoveEntry;

   PROCEDURE Rename* (e: Entry; VAR new: ARRAY OF CHAR);
   BEGIN
   END Rename;

   PROCEDURE ThisDirectory* (path: ARRAY OF CHAR): Directory;
   BEGIN
    RETURN NIL;
   END ThisDirectory;

   PROCEDURE ThisEntry* (D: Directory; VAR name: ARRAY OF CHAR): Entry;
   BEGIN
    RETURN NIL;
   END ThisEntry;

   PROCEDURE ThisHostEntry* (D: Directory; VAR hostname: ARRAY OF CHAR): Entry;
   BEGIN
    RETURN NIL;
   END ThisHostEntry;

END FileDir.
