MODULE Graphics;

   IMPORT Fonts, Modules, Files, Texts, Kernel, Display;

   CONST
      NameLen* = 16;

   TYPE
      Method* = POINTER TO MethodDesc;
      Msg* = RECORD END;
      Name* = ARRAY 16 OF CHAR;
      Object* = POINTER TO ObjectDesc;
      ObjectDesc* = RECORD
         x*, y*, w*, h*, col*: INTEGER;
         selected*, marked*: BOOLEAN;
         do*: Method;
      END;
      WidMsg* = RECORD (Msg)
         w*: INTEGER;
      END;
      Caption* = POINTER TO CaptionDesc;
      CaptionDesc* = RECORD (ObjectDesc)
         pos*, len*: INTEGER;
      END;
      ColorMsg* = RECORD (Msg)
         col*: INTEGER;
      END;
      Context* = RECORD
      END;
      FontMsg* = RECORD (Msg)
         fnt*: Fonts.Font;
      END;
      Graph* = POINTER TO GraphDesc;
      GraphDesc* = RECORD
         time*: LONGINT;
         sel*: Object;
      END;
      Library* = POINTER TO LibraryDesc;
      LibraryDesc* = RECORD
         name*: Name;
      END;
      Line* = POINTER TO LineDesc;
      LineDesc* = RECORD (ObjectDesc) END;
      MacExt* = POINTER TO MacExtDesc;
      MacExtDesc* = RECORD END;
      MacHead* = POINTER TO MacHeadDesc;
      MacHeadDesc* = RECORD
         name*: Name;
         w*, h*: INTEGER;
         ext*: MacExt;
         lib*: Library;
      END;
      Macro* = POINTER TO MacroDesc;
      MacroDesc* = RECORD (ObjectDesc)
         mac*: MacHead;
      END;
      MethodDesc* = RECORD
         module*, allocator*: Name;
         new*: Modules.Command;
         copy*: PROCEDURE (from, to: Object);
         draw*, handle*: PROCEDURE (obj: Object; VAR msg: Msg);
         selectable*: PROCEDURE (obj: Object; x, y: INTEGER): BOOLEAN;
         read*: PROCEDURE (obj: Object; VAR R: Files.Rider; VAR C: Context);
         write*: PROCEDURE (obj: Object; cno: SHORTINT; VAR R: Files.Rider; VAR C: Context);
         print*: PROCEDURE (obj: Object; x, y: INTEGER);
      END;

   VAR
      CapMethod*: Method;
      LineMethod*: Method;
      MacMethod*: Method;
      T*: Texts.Text;
      new*: Object;
      res*: INTEGER;
      width*: INTEGER;

   PROCEDURE Add* (G: Graph; obj: Object);
   BEGIN
   END Add;

   PROCEDURE Copy* (Gs, Gd: Graph; dx, dy: INTEGER);
   BEGIN
   END Copy;

   PROCEDURE Delete* (G: Graph);
   BEGIN
   END Delete;

   PROCEDURE Deselect* (G: Graph);
   BEGIN
   END Deselect;

   PROCEDURE Draw* (G: Graph; VAR M: Msg);
   BEGIN
   END Draw;

   PROCEDURE DrawMac* (mh: MacHead; VAR M: Msg);
   BEGIN
   END DrawMac;

   PROCEDURE DrawSel* (G: Graph; VAR M: Msg);
   BEGIN
   END DrawSel;

   PROCEDURE Enumerate* (G: Graph; handle: PROCEDURE (obj: Object; VAR done: BOOLEAN));
   BEGIN
   END Enumerate;

   PROCEDURE Font* (VAR R: Files.Rider; VAR C: Context): Fonts.Font;
   BEGIN
    RETURN NIL;
   END Font;

   PROCEDURE FontNo* (VAR W: Files.Rider; VAR C: Context; fnt: Fonts.Font): SHORTINT;
   BEGIN
    RETURN 0;
   END FontNo;

   PROCEDURE Handle* (G: Graph; VAR M: Msg);
   BEGIN
   END Handle;

   PROCEDURE InsertMac* (mh: MacHead; L: Library; VAR new: BOOLEAN);
   BEGIN
   END InsertMac;

   PROCEDURE Load* (G: Graph; VAR R: Files.Rider);
   BEGIN
   END Load;

   PROCEDURE MakeMac* (G: Graph; x, y, w, h: INTEGER; VAR Mname: ARRAY OF CHAR): MacHead;
   BEGIN
    RETURN NIL;
   END MakeMac;

   PROCEDURE Move* (G: Graph; dx, dy: INTEGER);
   BEGIN
   END Move;

   PROCEDURE NewLib* (VAR Lname: ARRAY OF CHAR): Library;
   BEGIN
    RETURN NIL;
   END NewLib;

   PROCEDURE Open* (G: Graph; name: ARRAY OF CHAR);
   BEGIN
   END Open;

   PROCEDURE OpenMac* (mh: MacHead; G: Graph; x, y: INTEGER);
   BEGIN
   END OpenMac;

   PROCEDURE Print* (G: Graph; x0, y0: INTEGER);
   BEGIN
   END Print;

   PROCEDURE RemoveLibraries*;
   BEGIN
   END RemoveLibraries;

   PROCEDURE SelectArea* (G: Graph; x0, y0, x1, y1: INTEGER);
   BEGIN
   END SelectArea;

   PROCEDURE SelectObj* (G: Graph; obj: Object);
   BEGIN
   END SelectObj;

   PROCEDURE Store* (G: Graph; VAR W: Files.Rider);
   BEGIN
   END Store;

   PROCEDURE StoreLib* (L: Library; VAR Fname: ARRAY OF CHAR);
   BEGIN
   END StoreLib;

   PROCEDURE ThisClass* (VAR module, allocator: ARRAY OF CHAR): Modules.Command;
   BEGIN
    RETURN NIL;
   END ThisClass;

   PROCEDURE ThisLib* (VAR name: ARRAY OF CHAR; replace: BOOLEAN): Library;
   BEGIN
    RETURN NIL;
   END ThisLib;

   PROCEDURE ThisMac* (L: Library; VAR Mname: ARRAY OF CHAR): MacHead;
   BEGIN
    RETURN NIL;
   END ThisMac;

   PROCEDURE ThisObj* (G: Graph; x, y: INTEGER): Object;
   BEGIN
    RETURN NIL;
   END ThisObj;

   PROCEDURE WriteFile* (G: Graph; name: ARRAY OF CHAR);
   BEGIN
   END WriteFile;

   PROCEDURE WriteObj* (VAR W: Files.Rider; cno: SHORTINT; obj: Object);
   BEGIN
   END WriteObj;

END Graphics.
