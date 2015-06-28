MODULE GraphicElems0;   (*HM Mar-25-92*)
IMPORT OS, Texts0, Shapes0, GraphicFrames0, TextFrames0, Viewers0;

TYPE
   Element* = POINTER TO ElemDesc;
   ElemDesc* = RECORD (Texts0.ElemDesc)
      orgX, orgY: INTEGER;
      graphic: Shapes0.Graphic;
   END;
   UpdateFrame = POINTER TO UpdateFrameDesc;
   UpdateFrameDesc = RECORD (GraphicFrames0.FrameDesc)
      text: Texts0.Text;
      e: Element
   END;

VAR f: GraphicFrames0.Frame; (*reused within a text frame whenever a graphic element has to be redrawn*)

PROCEDURE (e: Element) Copy* (): Texts0.Element;
   VAR res: Element;
BEGIN NEW(res); res^ := e^; res.graphic := e.graphic.Copy(); RETURN res
END Copy;

PROCEDURE (e: Element) Draw* (x, y: INTEGER);
BEGIN
   f.x := x; f.y := y; f.w := e.w; f.h := e.h; f.orgX := e.orgX; f.orgY := e.orgY; f.graphic := e.graphic;
   f.Draw
END Draw;

PROCEDURE (e: Element) HandleMouse* (f: OS.Object; x, y: INTEGER);
   VAR v: Viewers0.Viewer; menu: TextFrames0.Frame; cont: UpdateFrame; buttons: SET;
BEGIN REPEAT OS.GetMouse(buttons, x, y) UNTIL buttons = {};
   menu := TextFrames0.NewMenu("", "Viewers0.Close  Viewers0.Copy  GraphicElems0.Update");
   NEW(cont); cont.graphic := e.graphic;
   cont.orgX := e.orgX + 10; cont.orgY := e.orgY + 10;
   cont.text := f(TextFrames0.Frame).text; cont.e := e;
   v := Viewers0.New(menu, cont)
END HandleMouse;

PROCEDURE (e: Element) Load* (VAR r: OS.Rider);
BEGIN e.Load^ (r);
   r.ReadInt(e.orgX); r.ReadInt(e.orgY);
   NEW(e.graphic); Shapes0.InitGraphic(e.graphic); e.graphic.Load(r)
END Load;

PROCEDURE (e: Element) Store* (VAR r: OS.Rider);
BEGIN e.Store^ (r); r.WriteInt(e.orgX); r.WriteInt(e.orgY); e.graphic.Store(r)
END Store;

PROCEDURE Insert*;
   VAR e: Element; f: TextFrames0.Frame;
BEGIN
   IF Viewers0.focus # NIL THEN f := Viewers0.focus(TextFrames0.Frame);
      IF (f # NIL) & (f.caret.pos >= 0) THEN
         NEW(e); e.w := 12; e.h := 12; e.dsc := 0; e.orgX := 0; e.orgY := 0;
         NEW(e.graphic); Shapes0.InitGraphic(e.graphic);
         f.text.SetPos(f.caret.pos); f.text.WriteElem(e)
      END
   END
END Insert;

PROCEDURE Update*;
   VAR v: Viewers0.Viewer; f: UpdateFrame; e: Element; m: Texts0.NotifyReplMsg; x, y: INTEGER; pos: LONGINT;
BEGIN v := Viewers0.ViewerAt(TextFrames0.cmdFrame.y); f := v.cont(UpdateFrame);
   e := f.e; pos := f.text.ElemPos(e);
   IF pos < f.text.len THEN
      f.graphic.GetBox(x, y, e.w, e.h);
      e.graphic := f.graphic; e.orgX := - x ; e.orgY := - y;
      m.t := f.text; m.beg := pos; m.end := pos + 1; Viewers0.Broadcast(m)
   END
END Update;

PROCEDURE Init;
   VAR g: Shapes0.Graphic;
BEGIN NEW(g); Shapes0.InitGraphic(g); f := GraphicFrames0.New(g)
END Init;

BEGIN Init
END GraphicElems0.
