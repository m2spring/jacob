MODULE Viewers0;  (*HM Mar-25-92*)
IMPORT OS;

CONST
   barH = 14; (*default height of title bar*)
   minH = barH + 2; (*minimal height of a viewer*)

TYPE
   Frame* = POINTER TO FrameDesc;
   FrameDesc* = RECORD (OS.ObjectDesc)
      x*, y*: INTEGER; (*left bottom corner in pixels relative to left bottom corner of screen*)
      w*, h*: INTEGER (*width, height in pixels*)
   END;
   Viewer* = POINTER TO ViewerDesc;
   ViewerDesc* = RECORD (FrameDesc)
      menu-, cont-: Frame;
      next-: Viewer;
   END;

VAR
   focus-: Frame; (*the frame that gets the keyboard input*)
   viewers: Viewer; (*bottom viewer on the screen*)

(*Frame methods*)

PROCEDURE (f: Frame) Draw*; END Draw;
PROCEDURE (f: Frame) Modify* (dy: INTEGER); BEGIN INC(f.y, dy); DEC(f.h, dy) END Modify;
PROCEDURE (f: Frame) Move* (dy: INTEGER); BEGIN INC(f.y, dy) END Move;
PROCEDURE (f: Frame) Copy* (): Frame; END Copy;
PROCEDURE (f: Frame) HandleMouse* (x, y: INTEGER; buttons: SET); END HandleMouse;
PROCEDURE (f: Frame) HandleKey* (ch: CHAR); END HandleKey;
PROCEDURE (f: Frame) Handle* (VAR m: OS.Message); END Handle;
PROCEDURE (f: Frame) Defocus*; BEGIN focus := NIL END Defocus;
PROCEDURE (f: Frame) SetFocus*; BEGIN IF focus # NIL THEN focus.Defocus END; focus := f END SetFocus;
PROCEDURE (f: Frame) Neutralize*; END Neutralize;


(*Viewer methods*)

PROCEDURE (v: Viewer) Erase (h: INTEGER);
BEGIN
   IF h > 0 THEN
      OS.EraseBlock(v.x, v.y, v.w, h); (*clear bottom block of viewer*)
      OS.FillBlock(v.x, v.y, 1, h); (*draw left border*)
      OS.FillBlock(v.x+v.w-1, v.y, 1, h) (*draw right border*)
   END;
   OS.FillBlock(v.x, v.y, OS.screenW, 1) (*draw bottom border*)
END Erase;

PROCEDURE (v: Viewer) FlipTitleBar;
BEGIN OS.InvertBlock(v.x+1, v.y + v.h - barH, OS.screenW-2, barH)
END FlipTitleBar;

PROCEDURE (v: Viewer) Neutralize*;
BEGIN v.menu.Neutralize; v.cont.Neutralize
END Neutralize;

PROCEDURE (v: Viewer) Modify* (dy: INTEGER);
BEGIN v.Neutralize; v.Modify^ (dy); v.Erase(-dy+1); v.cont.Modify(dy)
END Modify;

PROCEDURE (v: Viewer) Move* (dy: INTEGER);
BEGIN v.Neutralize; v.menu.Move(dy); v.cont.Move(dy);
   OS.CopyBlock(v.x, v.y+1, v.w, v.h-1, v.x, v.y+dy+1);
   INC(v.y, dy)
END Move;

PROCEDURE (v: Viewer) Draw*;
BEGIN OS.FadeCursor;
   v.Erase(v.h); v.menu.Draw; v.cont.Draw; v.FlipTitleBar
END Draw;

PROCEDURE (v: Viewer) HandleMouse* (x, y: INTEGER; buttons: SET);
   VAR b: SET; x1, y1: INTEGER; dy, maxUp, maxDown: INTEGER;
BEGIN OS.DrawCursor(x, y);
   IF y > v.menu.y THEN (*click in menu bar => resize viewer*)
      IF OS.left IN buttons THEN v.FlipTitleBar;
         REPEAT OS.GetMouse(b, x1, y1); OS.DrawCursor(x1, y1) UNTIL b = {};
         v.FlipTitleBar; OS.FadeCursor; v.Neutralize;
         dy := y1 - y; maxDown := v.h - minH;
         IF v.next = NIL THEN maxUp := OS.screenH - v.y - v.h ELSE maxUp := v.next.h - minH; v.next.Neutralize END;
         IF dy < - maxDown THEN dy := - maxDown ELSIF dy > maxUp THEN dy := maxUp END;
         IF dy < 0 THEN (*down*) v.Modify(-dy); v.Move(dy) ELSE (*up*) v.Move(dy); v.Modify(-dy) END;
         IF v.next # NIL THEN v.next.Modify(dy)
         ELSE OS.EraseBlock(v.x, v.y+v.h, v.w, OS.screenH-v.y-v.h)
         END
      ELSE v.menu.HandleMouse(x, y, buttons)
      END
   ELSE v.cont.HandleMouse(x, y, buttons)
   END
END HandleMouse;

PROCEDURE (v: Viewer) Handle* (VAR m: OS.Message);
BEGIN
   v.menu.Handle(m); v.cont.Handle(m)
END Handle;

PROCEDURE (v: Viewer) Close*;
   VAR x: Viewer;
BEGIN OS.FadeCursor; v.Neutralize;
   IF v.next # NIL THEN v.next.Modify(-v.h)
   ELSE OS.EraseBlock(v.x, v.y, v.w, v.h)
   END;
   IF viewers = v THEN viewers := v.next
   ELSE x := viewers; WHILE x.next # v DO x := x.next END;
      x.next := v.next
   END
END Close;


(*external procedures*)

PROCEDURE ViewerAt*(y: INTEGER): Viewer;
   VAR v: Viewer;
BEGIN v := viewers;
   WHILE (v # NIL) & (y > v.y + v.h) DO v := v.next END;
   RETURN v
END ViewerAt;

PROCEDURE New* (menu, cont: Frame): Viewer;
   VAR below, above, v, w: Viewer; top: INTEGER;
BEGIN
   (*----- compute position of new viewer*)
   IF ViewerAt(OS.screenH) = NIL THEN top := OS.screenH
   ELSE w := viewers; v := viewers.next;
      WHILE v # NIL DO
         IF v.h > w.h THEN w := v END;
         v := v.next
      END;
      top := w.y + w.h DIV 2
   END;
   (*----- generate new viewer and link it into viewer list*)
   above := viewers; below := NIL;
   WHILE (above # NIL) & (top > above.y + above.h) DO below := above; above := above.next END;
   NEW(v); v.x := 0; v.w := OS.screenW; v.next := above;
   IF below = NIL THEN v.y := 0; v.h := top ELSE v.y := below.y + below.h; v.h := top - v.y END;
   IF v.h < minH THEN RETURN NIL END;
   v.menu := menu; menu.x := v.x+1; menu.y := v.y + v.h - barH; menu.w := v.w-2; menu.h := barH-1;
   v.cont := cont; cont.x := v.x+1; cont.y := v.y+1; cont.w := v.w-2; cont.h := menu.y - v.y-1;
   IF below = NIL THEN viewers := v ELSE below.next := v END;
   IF above # NIL THEN above.Modify(v.h) END;
   v.Draw;
   RETURN v
END New;

PROCEDURE Broadcast* (VAR m: OS.Message);
   VAR v: Viewer;
BEGIN v := viewers; WHILE v # NIL DO v.Handle(m); v := v.next END
END Broadcast;

(*commands*)

PROCEDURE Close*;
   VAR x, y: INTEGER; buttons: SET; v: Viewer;
BEGIN OS.GetMouse(buttons, x, y); v := ViewerAt(y); v.Close
END Close;

PROCEDURE Copy*;
   VAR v: Viewer; x, y: INTEGER; buttons: SET;
BEGIN OS.GetMouse(buttons, x, y); v := ViewerAt(y);
   v := New(v.menu.Copy(), v.cont.Copy())
END Copy;

BEGIN
   viewers := NIL; focus := NIL
END Viewers0.
