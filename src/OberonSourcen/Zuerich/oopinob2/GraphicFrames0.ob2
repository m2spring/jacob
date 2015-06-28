MODULE GraphicFrames0;   (*HM Mar-25-92*)
IMPORT OS, Viewers0, Shapes0;

TYPE
   Frame* = POINTER TO FrameDesc;
   FrameDesc* = RECORD (Viewers0.FrameDesc)
      orgX*, orgY*: INTEGER;  (*origin*)
      graphic*: Shapes0.Graphic  (*shapes in this frame*)
   END;

PROCEDURE (f: Frame) InvertBlock* (x, y, w, h: INTEGER);
BEGIN INC(x, f.x + f.orgX); INC(y, f.y + f.orgY);
   IF x < f.x THEN DEC(w, f.x - x); x := f.x END;
   IF x + w > f.x + f.w THEN w := f.x + f.w - x END;
   IF y < f.y THEN DEC(h, f.y - y); y := f.y END;
   IF y + h > f.y + f.h THEN h := f.y + f.h - y END;
   IF (w > 0) & (h > 0) THEN OS.InvertBlock(x, y, w, h) END
END InvertBlock;

PROCEDURE (f: Frame) Draw*;
BEGIN OS.FadeCursor;
   OS.EraseBlock(f.x, f.y, f.w, f.h);
   f.graphic.Draw(f)
END Draw;

PROCEDURE (f: Frame) Modify* (y: INTEGER);
BEGIN f.Modify^ (y); f.Draw
END Modify;

PROCEDURE (f: Frame) HandleMouse* (x, y: INTEGER; buttons: SET);
   VAR w, h, dx, dy: INTEGER; obj: OS.Object; s: Shapes0.Shape; changed: BOOLEAN;

      PROCEDURE Track(VAR x, y, w, h, dx, dy: INTEGER; VAR buttons: SET);
         VAR b: SET; x1, y1: INTEGER;
      BEGIN
         REPEAT OS.GetMouse(b, x1, y1); buttons := buttons + b; OS.DrawCursor(x1, y1) UNTIL b = {};
         dx := x1 - x; dy := y1 - y; w := ABS(dx); h := ABS(dy);
         IF x1 < x THEN x := x1 END;
         IF y1 < y THEN y := y1 END;
         DEC(x, f.x + f.orgX); DEC(y, f.y + f.orgY) (*convert to frame coordinates*)
      END Track;

BEGIN changed := FALSE;
   IF OS.left IN buttons THEN Track(x, y, w, h, dx, dy, buttons);
      (*generate new shape with type curShape*)
      OS.NameToObj(Shapes0.curShape, obj);
      IF obj # NIL THEN s := obj(Shapes0.Shape); s.SetBox(x, y, w, h); f.graphic.Insert(s) END
   ELSIF OS.middle IN buttons THEN Track(x, y, w, h, dx, dy, buttons);
      IF OS.left IN buttons THEN (*MM+ML click: move selected figures*)
         f.graphic.MoveSelected(dx, dy)
      ELSE (*MM click: move origin*)
         INC(f.orgX, dx); INC(f.orgY, dy); f.Draw
      END
   ELSIF OS.right IN buttons THEN f.Neutralize; Track(x, y, w, h, dx, dy, buttons);
      f.graphic.SetSelection(x, y, w, h);
      IF OS.left IN buttons THEN (*MR+ML click: delete selected shapes*)
         f.graphic.DeleteSelected
      END
   END
END HandleMouse;

PROCEDURE (f: Frame) Neutralize*;
BEGIN f.graphic.Neutralize
END Neutralize;

PROCEDURE (f: Frame) Handle* (VAR m: OS.Message);
BEGIN
   WITH m: Shapes0.NotifyChangeMsg DO
      IF f.graphic = m.g THEN f.Draw END
   ELSE
   END
END Handle;

PROCEDURE New* (graphic: Shapes0.Graphic): Frame;
   VAR f: Frame;
BEGIN NEW(f); f.graphic := graphic; f.orgX := 0; f.orgY := 0; RETURN f
END New;

PROCEDURE (f: Frame) Copy* (): Viewers0.Frame;
   VAR f1: Frame;
BEGIN f1 := New(f.graphic); f1.orgX := f.orgX; f1.orgY := f.orgY; RETURN f1
END Copy;

END GraphicFrames0.
