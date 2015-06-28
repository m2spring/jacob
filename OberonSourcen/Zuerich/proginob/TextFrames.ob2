MODULE TextFrames;

   IMPORT Texts, Fonts, Display, Kernel;

   CONST
      MaxTabs* = 32;
      Unit* = 10000;
      delete* = 2;
      gridAdj* = 0;
      insert* = 1;
      leftAdj* = 1;
      mm* = 36000;
      pageBreak* = 3;
      replace* = 0;
      rightAdj* = 2;
      twoColumns* = 4;

   TYPE
      DisplayMsg* = RECORD (Texts.ElemMsg)
         prepare*: BOOLEAN;
         fnt*: Fonts.Font;
         col*: SHORTINT;
         pos*: LONGINT;
         frame*: Display.Frame;
         X0*, Y0*: INTEGER;
         indent*: LONGINT;
         elemFrame*: Display.Frame;
      END;
      FocusMsg* = RECORD (Texts.ElemMsg)
         focus*: BOOLEAN;
         elemFrame*, frame*: Display.Frame;
      END;
      Frame* = POINTER TO FrameDesc;
      Location* = RECORD
         org*, pos*: LONGINT;
         x*, y*, dx*, dy*: INTEGER;
      END;
      FrameDesc* = RECORD (Display.FrameDesc)
         text*: Texts.Text;
         org*: LONGINT;
         col*, left*, right*, top*, bot*, markH*, barW*: INTEGER;
         time*: LONGINT;
         hasCar*, hasSel*, showsParcs*: BOOLEAN;
         carloc*, selbeg*, selend*: Location;
         focus*: Display.Frame;
      END;
      InsertElemMsg* = RECORD (Display.FrameMsg)
         e*: Texts.Elem;
      END;
      NotifyMsg* = RECORD (Display.FrameMsg)
         frame*: Display.Frame;
      END;
      Parc* = POINTER TO ParcDesc;
      ParcDesc* = RECORD (Texts.ElemDesc)
         left*, first*, width*, lead*, lsp*, dsr*: LONGINT;
         opts*: SET;
         nofTabs*: INTEGER;
         tab*: ARRAY 32 OF LONGINT;
      END;
      TrackMsg* = RECORD (Texts.ElemMsg)
         X*, Y*: INTEGER;
         keys*: SET;
         fnt*: Fonts.Font;
         col*: SHORTINT;
         pos*: LONGINT;
         frame*: Display.Frame;
         X0*, Y0*: INTEGER;
      END;
      UpdateMsg* = RECORD (Display.FrameMsg)
         id*: INTEGER;
         text*: Texts.Text;
         beg*, end*: LONGINT;
      END;

   VAR
      barW*: INTEGER;
      bot*: INTEGER;
      defParc*: Parc;
      left*: INTEGER;
      menuH*: INTEGER;
      right*: INTEGER;
      top*: INTEGER;

   PROCEDURE Handle* (f: Display.Frame; VAR msg: Display.FrameMsg);
   BEGIN
   END Handle;

   PROCEDURE LocateChar* (F: Frame; x, y: INTEGER; VAR loc: Location);
   BEGIN
   END LocateChar;

   PROCEDURE LocateLine* (F: Frame; y: INTEGER; VAR loc: Location);
   BEGIN
   END LocateLine;

   PROCEDURE LocatePos* (F: Frame; pos: LONGINT; VAR loc: Location);
   BEGIN
   END LocatePos;

   PROCEDURE LocateWord* (F: Frame; x, y: INTEGER; VAR loc: Location);
   BEGIN
   END LocateWord;

   PROCEDURE Mark* (F: Frame; mark: INTEGER);
   BEGIN
   END Mark;

   PROCEDURE NewMenu* (name, commands: ARRAY OF CHAR): Frame;
   BEGIN
    RETURN NIL;
   END NewMenu;

   PROCEDURE NewText* (T: Texts.Text; pos: LONGINT): Frame;
   BEGIN
    RETURN NIL;
   END NewText;

   PROCEDURE NotifyDisplay* (T: Texts.Text; op: INTEGER; beg, end: LONGINT);
   BEGIN
   END NotifyDisplay;

   PROCEDURE Open* (F: Frame; T: Texts.Text; pos: LONGINT);
   BEGIN
   END Open;

   PROCEDURE ParcBefore* (T: Texts.Text; pos: LONGINT; VAR P: Parc; VAR beg: LONGINT);
   BEGIN
   END ParcBefore;

   PROCEDURE Pos* (F: Frame; x, y: INTEGER): LONGINT;
   BEGIN
    RETURN 0;
   END Pos;

   PROCEDURE RemoveCaret* (F: Frame);
   BEGIN
   END RemoveCaret;

   PROCEDURE RemoveSelection* (F: Frame);
   BEGIN
   END RemoveSelection;

   PROCEDURE SetCaret* (F: Frame; pos: LONGINT);
   BEGIN
   END SetCaret;

   PROCEDURE SetSelection* (F: Frame; beg, end: LONGINT);
   BEGIN
   END SetSelection;

   PROCEDURE Show* (F: Frame; pos: LONGINT);
   BEGIN
   END Show;

   PROCEDURE Text* (name: ARRAY OF CHAR): Texts.Text;
   BEGIN
    RETURN NIL;
   END Text;

   PROCEDURE TrackCaret* (F: Frame; VAR x, y: INTEGER; VAR keysum: SET);
   BEGIN
   END TrackCaret;

   PROCEDURE TrackLine* (F: Frame; VAR x, y: INTEGER; VAR org: LONGINT; VAR keysum: SET);
   BEGIN
   END TrackLine;

   PROCEDURE TrackSelection* (F: Frame; VAR x, y: INTEGER; VAR keysum: SET);
   BEGIN
   END TrackSelection;

   PROCEDURE TrackWord* (F: Frame; VAR x, y: INTEGER; VAR pos: LONGINT; VAR keysum: SET);
   BEGIN
   END TrackWord;

END TextFrames.
