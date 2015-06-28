MODULE Edit0;   (* HM Mar-25-92*)
IMPORT OS, IO:=io, TextFrames0, Texts0, Viewers0;

PROCEDURE Open*;
   VAR s: IO.Scanner; t: Texts0.Text; menu, cont: TextFrames0.Frame; v: Viewers0.Viewer;
      f: OS.File; r: OS.Rider;
BEGIN s.SetToParameters; s.Read;
   IF s.class = IO.name THEN
      menu := TextFrames0.NewMenu(s.str, "Viewers0.Close  Viewers0.Copy  Edit0.Store");
      NEW(t); f := OS.OldFile(s.str);
      IF f = NIL THEN t.Clear ELSE OS.InitRider(r); r.Set(f, 0); t.Load(r) END;
      cont := TextFrames0.New(t);
      v := Viewers0.New(menu, cont)
   END
END Open;

PROCEDURE Store*;
   VAR v: Viewers0.Viewer; s: IO.Scanner; f: OS.File; r: OS.Rider;
BEGIN v := Viewers0.ViewerAt(TextFrames0.cmdFrame.y);
   s.Set(v.menu(TextFrames0.Frame).text, 0); s.Read;
   IF s.class = IO.name THEN f := OS.NewFile(s.str); OS.InitRider(r); r.Set(f, 0);
      v.Neutralize; v.cont(TextFrames0.Frame).text.Store(r); OS.Register(f)
   END
END Store;

PROCEDURE ChangeFont*;
   VAR s: IO.Scanner; fnt: OS.Font; f: TextFrames0.Frame;
BEGIN s.SetToParameters; s.Read; TextFrames0.GetSelection(f);
   IF (f # NIL) & (s.class = IO.name) THEN
      fnt := OS.FontWithName(s.str); f.text.ChangeFont(f.selBeg.pos, f.selEnd.pos, fnt)
   END
END ChangeFont;

END Edit0.
