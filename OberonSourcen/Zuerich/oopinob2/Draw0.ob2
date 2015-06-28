MODULE Draw0;   (*HM Mar-25-92*)
IMPORT OS, IO:=io, Texts0, TextFrames0, Shapes0, GraphicFrames0, Viewers0;

PROCEDURE Open*;
   VAR s: IO.Scanner; v: Viewers0.Viewer; menu: TextFrames0.Frame;
      cont: GraphicFrames0.Frame; file: OS.File; r: OS.Rider; g: Shapes0.Graphic;
BEGIN s.SetToParameters; s.Read;
   IF s.class = IO.name THEN
      menu := TextFrames0.NewMenu(s.str, "Viewers0.Close  Viewers0.Copy  Draw0.Store");
      NEW(g); Shapes0.InitGraphic(g); file := OS.OldFile(s.str);
      IF file # NIL THEN OS.InitRider(r); r.Set(file, 0); g.Load(r) END;
      cont := GraphicFrames0.New(g);
      v := Viewers0.New(menu, cont)
   END
END Open;

PROCEDURE Store*;
   VAR v: Viewers0.Viewer; s: IO.Scanner; file: OS.File; r: OS.Rider;
BEGIN v := Viewers0.ViewerAt(TextFrames0.cmdFrame.y);
   s.Set(v.menu(TextFrames0.Frame).text, 0); s.Read;
   IF s.class = IO.name THEN file := OS.NewFile(s.str); OS.InitRider(r); r.Set(file, 0);
      v.cont(GraphicFrames0.Frame).graphic.Store(r);
      OS.Register(file)
   END
END Store;

END Draw0.
