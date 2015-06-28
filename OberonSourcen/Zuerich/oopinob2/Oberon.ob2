MODULE Oberon;

   IMPORT Display, Texts, Fonts, Viewers, Kernel;

   CONST
      consume* = 0;
      defocus* = 0;
      mark* = 2;
      neutralize* = 1;
      track* = 1;

   TYPE
      ControlMsg* = RECORD (Display.FrameMsg)
         id*, X*, Y*: INTEGER;
      END;
      CopyMsg* = RECORD (Display.FrameMsg)
         F*: Display.Frame;
      END;
      CopyOverMsg* = RECORD (Display.FrameMsg)
         text*: Texts.Text;
         beg*, end*: LONGINT;
      END;
      Painter* = PROCEDURE (x, y: INTEGER);
      Marker* = RECORD
         Fade*, Draw*: Painter;
      END;
      Cursor* = RECORD
         marker*: Marker;
         on*: BOOLEAN;
         X*, Y*: INTEGER;
      END;
      Handler* = PROCEDURE;
      InputMsg* = RECORD (Display.FrameMsg)
         id*: INTEGER;
         keys*: SET;
         X*, Y*: INTEGER;
         ch*: CHAR;
         fnt*: Fonts.Font;
         col*, voff*: SHORTINT;
      END;
      ParList* = POINTER TO ParRec;
      ParRec* = RECORD
         vwr*: Viewers.Viewer;
         frame*: Display.Frame;
         text*: Texts.Text;
         pos*: LONGINT;
      END;
      SelectionMsg* = RECORD (Display.FrameMsg)
         time*: LONGINT;
         text*: Texts.Text;
         beg*, end*: LONGINT;
      END;
      Task* = POINTER TO TaskDesc;
      TaskDesc* = RECORD
         safe*: BOOLEAN;
         time*: LONGINT;
         handle*: Handler;
      END;

   VAR
      Arrow*: Marker;
      CurCol*: SHORTINT;
      CurFnt*: Fonts.Font;
      CurOff*: SHORTINT;
      CurTask*: Task;
      FocusViewer*: Viewers.Viewer;
      Log*: Texts.Text;
      Mouse*: Cursor;
      Par*: ParList;
      Password*: LONGINT;
      Pointer*: Cursor;
      Star*: Marker;
      User*: ARRAY 8 OF CHAR;

   PROCEDURE AllocateSystemViewer* (DX: INTEGER; VAR X, Y: INTEGER);
   BEGIN
   END AllocateSystemViewer;

   PROCEDURE AllocateUserViewer* (DX: INTEGER; VAR X, Y: INTEGER);
   BEGIN
   END AllocateUserViewer;

   PROCEDURE Call* (name: ARRAY OF CHAR; par: ParList; new: BOOLEAN; VAR res: INTEGER);
   BEGIN
   END Call;

   PROCEDURE Collect* (count: INTEGER);
   BEGIN
   END Collect;

   PROCEDURE DisplayHeight* (X: INTEGER): INTEGER;
   BEGIN
    RETURN 0;
   END DisplayHeight;

   PROCEDURE DisplayWidth* (X: INTEGER): INTEGER;
   BEGIN
    RETURN 0;
   END DisplayWidth;

   PROCEDURE DrawCursor* (VAR c: Cursor; VAR m: Marker; X, Y: INTEGER);
   BEGIN
   END DrawCursor;

   PROCEDURE FadeCursor* (VAR c: Cursor);
   BEGIN
   END FadeCursor;

   PROCEDURE GetClock* (VAR t, d: LONGINT);
   BEGIN
   END GetClock;

   PROCEDURE GetSelection* (VAR text: Texts.Text; VAR beg, end, time: LONGINT);
   BEGIN
   END GetSelection;

   PROCEDURE Install* (T: Task);
   BEGIN
   END Install;

   PROCEDURE Loop*;
   BEGIN
   END Loop;

   PROCEDURE MarkedViewer* (): Viewers.Viewer;
   BEGIN
    RETURN NIL;
   END MarkedViewer;

   PROCEDURE OpenCursor* (VAR c: Cursor);
   BEGIN
   END OpenCursor;

   PROCEDURE OpenDisplay* (UW, SW, H: INTEGER);
   BEGIN
   END OpenDisplay;

   PROCEDURE OpenTrack* (X, W: INTEGER);
   BEGIN
   END OpenTrack;

   PROCEDURE PassFocus* (V: Viewers.Viewer);
   BEGIN
   END PassFocus;

   PROCEDURE Remove* (T: Task);
   BEGIN
   END Remove;

   PROCEDURE RemoveMarks* (X, Y, W, H: INTEGER);
   BEGIN
   END RemoveMarks;

   PROCEDURE SetClock* (t, d: LONGINT);
   BEGIN
   END SetClock;

   PROCEDURE SetColor* (col: SHORTINT);
   BEGIN
   END SetColor;

   PROCEDURE SetFont* (fnt: Fonts.Font);
   BEGIN
   END SetFont;

   PROCEDURE SetOffset* (voff: SHORTINT);
   BEGIN
   END SetOffset;

   PROCEDURE SetUser* (VAR user, password: ARRAY OF CHAR);
   BEGIN
   END SetUser;

   PROCEDURE SystemTrack* (X: INTEGER): INTEGER;
   BEGIN
    RETURN 0;
   END SystemTrack;

   PROCEDURE Time* (): LONGINT;
   BEGIN
    RETURN 0;
   END Time;

   PROCEDURE UserTrack* (X: INTEGER): INTEGER;
   BEGIN
    RETURN 0;
   END UserTrack;

END Oberon.
