MODULE Oberon0;   (* HM Mar-25-92*)
IMPORT OS, Viewers0, Texts0, TextFrames0;

CONST ESC = 1BX;

PROCEDURE Open (name: ARRAY OF CHAR): Texts0.Text;
   VAR f: OS.File; r: OS.Rider; t: Texts0.Text;
BEGIN NEW(t); f := OS.OldFile(name);
   IF f = NIL THEN t.Clear ELSE OS.InitRider(r); r.Set(f, 0); t.Load(r) END;
   RETURN t
END Open;

PROCEDURE Loop*;
   VAR ch: CHAR; x, y: INTEGER; buttons: SET; v: Viewers0.Viewer; menu, cont: TextFrames0.Frame;
BEGIN
   menu := TextFrames0.NewMenu("LOG", "Viewers0.Close  Viewers0.Copy  Edit0.Store");
   cont := TextFrames0.New(Open("LOG"));
   v := Viewers0.New(menu, cont);
   LOOP
      IF OS.AvailChars() > 0 THEN OS.ReadKey(ch);
         IF ch = ESC THEN EXIT
         ELSIF Viewers0.focus # NIL THEN Viewers0.focus.HandleKey(ch)
         END
      ELSE OS.GetMouse(buttons, x, y);
         v := Viewers0.ViewerAt(y);
         IF v # NIL THEN v.HandleMouse(x, y, buttons)
         ELSE OS.DrawCursor(x, y)
         END
      END
   END
END Loop;

END Oberon0.
