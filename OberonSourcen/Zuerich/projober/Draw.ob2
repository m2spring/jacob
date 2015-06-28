MODULE Draw; (*NW 29.6.88 / 22.11.91*)

   IMPORT Files, Fonts, Viewers, Printer, Texts, Oberon,
      TextFrames, MenuViewers, Graphics, GraphicFrames;

   VAR W: Texts.Writer;

   (*Exported commands:
      Open, Delete,
      SetWidth, ChangeColor, ChangeWidth, ChangeFont,
      Store, Print
      Macro, OpenMacro, MakeMacro, StoreLibrary*)

   PROCEDURE Open*;
      VAR X, Y: INTEGER;
         beg, end, t: LONGINT;
         G: Graphics.Graph;
         F: GraphicFrames.Frame;
         V: Viewers.Viewer;
         text: Texts.Text;
         S: Texts.Scanner;
   BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF (S.class = Texts.Char) & (S.c = "^") THEN
         Oberon.GetSelection(text, beg, end, t);
         IF t >= 0 THEN Texts.OpenScanner(S, text, beg); Texts.Scan(S) END
      END ;
      IF S.class = Texts.Name THEN
         NEW(G); Graphics.Open(G, S.s);
         NEW(F); GraphicFrames.Open(F, G, -1, 0, 0, TRUE);
         Oberon.AllocateUserViewer(Oberon.Par.vwr.X, X, Y);
         V := MenuViewers.New(
            TextFrames.NewMenu(S.s, "System.Close  System.Copy  System.Grow  Draw.Delete  Draw.Store"),
            F, TextFrames.menuH, X, Y)
      END
   END Open;

   PROCEDURE Delete*;
      VAR F: GraphicFrames.Frame;
   BEGIN
      IF Oberon.Par.frame = Oberon.Par.vwr.dsc THEN
         F := Oberon.Par.vwr.dsc.next(GraphicFrames.Frame);
         GraphicFrames.Erase(F); Graphics.Delete(F.graph)
      END
   END Delete;

   PROCEDURE SetWidth*;
      VAR S: Texts.Scanner;
   BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF (S.class = Texts.Int) & (S.i > 0) & (S.i < 7) THEN Graphics.width := SHORT(S.i) END
   END SetWidth;

   PROCEDURE ChangeColor*;
      VAR ch: CHAR;
         CM: Graphics.ColorMsg;
         S: Texts.Scanner;
   BEGIN
      IF Oberon.Par.frame(TextFrames.Frame).sel > 0 THEN
         Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.frame(TextFrames.Frame).selbeg.pos);
         Texts.Read(S, ch); CM.col := S.col
      ELSE Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
         IF S.class = Texts.Int THEN CM.col := SHORT(S.i) ELSE CM.col := S.col END
      END ;
      GraphicFrames.Change(GraphicFrames.Selected(), CM)
   END ChangeColor;

   PROCEDURE ChangeWidth*;
      VAR WM: Graphics.WidMsg;
         S: Texts.Scanner;
   BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF S.class = Texts.Int THEN
         WM.w := SHORT(S.i); GraphicFrames.Change(GraphicFrames.Selected(), WM)
      END
   END ChangeWidth;

   PROCEDURE ChangeFont*;
      VAR FM: Graphics.FontMsg;
         S: Texts.Scanner;
   BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF S.class = Texts.Name THEN
         FM.fnt := Fonts.This(S.s);
         IF FM.fnt # NIL THEN GraphicFrames.Change(GraphicFrames.Selected(), FM) END
      END
   END ChangeFont;

   PROCEDURE Backup (VAR name: ARRAY OF CHAR);
      VAR res, i: INTEGER; ch: CHAR;
         bak: ARRAY 32 OF CHAR;
   BEGIN i := 0; ch := name[0];
      WHILE ch > 0X DO bak[i] := ch; INC(i); ch := name[i] END ;
      IF i < 28 THEN
         bak[i] := "."; bak[i+1] := "B"; bak[i+2] := "a"; bak[i+3] := "k"; bak[i+4] := 0X;
         Files.Rename(name, bak, res)
      END
   END Backup;

   PROCEDURE Store*;
      VAR par: Oberon.ParList; S: Texts.Scanner;
         Menu: TextFrames.Frame; G: GraphicFrames.Frame;
         v: Viewers.Viewer;
   BEGIN par := Oberon.Par;
      IF par.frame = par.vwr. dsc THEN
         Menu := par.vwr.dsc(TextFrames.Frame); G := Menu.next(GraphicFrames.Frame);
         Texts.OpenScanner(S, Menu.text, 0); Texts.Scan(S);
         IF S.class = Texts.Name THEN
            Texts.WriteString(W, S.s); Texts.WriteString(W, " storing");
            Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf);
            Backup(S.s); Graphics.WriteFile(G.graph, S.s)
         END
      ELSE
         Texts.OpenScanner(S, par.text, par.pos); Texts.Scan(S);
         IF S.class = Texts.Name THEN
            v := Oberon.MarkedViewer();
            IF (v.dsc # NIL) & (v.dsc.next IS GraphicFrames.Frame) THEN
               G := v.dsc.next(GraphicFrames.Frame);
               Texts.WriteString(W, S.s); Texts.WriteString(W, " storing");
               Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf);
               Backup(S.s); Graphics.WriteFile(G.graph, S.s)
            END
         END
      END
   END Store;

   PROCEDURE Print*;
      VAR nofcopies: INTEGER;
         S: Texts.Scanner;
         G: Graphics.Graph;
         V: Viewers.Viewer;

      PROCEDURE Copies;
         VAR ch: CHAR;
      BEGIN nofcopies := 1;
         IF S.nextCh = "/" THEN
            Texts.Read(S, ch);
            IF (ch >= "0") & (ch <= "9") THEN nofcopies := ORD(ch) - 30H END ;
            WHILE ch > " " DO Texts.Read(S, ch) END ;
            S.nextCh := ch
         END
      END Copies;

   BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF S.class = Texts.Name THEN
         Printer.Open(S.s, Oberon.User, Oberon.Password);
         IF Printer.res = 0 THEN
            Texts.Scan(S);
            WHILE S.class = Texts.Name DO
               Texts.WriteString(W, S.s); Copies; NEW(G); Graphics.Open(G, S.s);
               IF Graphics.res = 0 THEN
                  Texts.WriteString(W, " printing");
                  Texts.WriteInt(W, nofcopies, 3); Texts.Append(Oberon.Log, W.buf);
                  Graphics.Print(G, 0, Printer.PageHeight-128); Printer.Page(nofcopies)
               ELSE Texts.WriteString(W, " not found")
               END ;
               Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf); Texts.Scan(S)
            END ;
            IF (S.class = Texts.Char) & (S.c = "*") THEN
               Copies; V := Oberon.MarkedViewer();
               IF (V.dsc # NIL) & (V.dsc.next IS GraphicFrames.Frame) THEN
                  Texts.OpenScanner(S, V.dsc(TextFrames.Frame).text, 0);
                  Texts.Scan(S);
                  IF S.class = Texts.Name THEN
                     Texts.WriteString(W, S.s); Texts.WriteString(W, " printing");
                     Texts.WriteInt(W, nofcopies, 3); Texts.Append(Oberon.Log, W.buf);
                     Graphics.Print(V.dsc.next(GraphicFrames.Frame).graph, 0, Printer.PageHeight-128);
                     Printer.Page(nofcopies)
                  END
               END
            END ;
            Printer.Close
         ELSIF Printer.res = 1 THEN Texts.WriteString(W, " no printer")
         ELSIF Printer.res = 2 THEN Texts.WriteString(W, " no link")
         ELSIF Printer.res = 3 THEN Texts.WriteString(W, " bad response")
         ELSIF Printer.res = 4 THEN Texts.WriteString(W, " no permission")
         END
      END ;
      Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
   END Print;

   PROCEDURE Macro*;
      VAR S: Texts.Scanner;
         T: Texts.Text;
         time, beg, end: LONGINT;
         Lname: ARRAY 32 OF CHAR;
   BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF S.class = Texts.Name THEN
         COPY(S.s, Lname); Texts.Scan(S);
         IF (S.class = Texts.Char) & (S.c = "^") THEN
            Oberon.GetSelection(T, beg, end, time);
            IF time >= 0 THEN Texts.OpenScanner(S, T, beg); Texts.Scan(S) END
         END ;
         IF (S.class = Texts.Name) OR (S.class = Texts.String) THEN
            GraphicFrames.Macro(Lname, S.s)
         END
      END
   END Macro;

   PROCEDURE OpenMacro*;
      VAR F: GraphicFrames.Frame; sel: Graphics.Object;
   BEGIN F := GraphicFrames.Selected();
      IF F # NIL THEN
         sel := F.graph.sel;
         IF (sel # NIL) & (sel IS Graphics.Macro) THEN
            GraphicFrames.Deselect(F);
            Graphics.OpenMac(sel(Graphics.Macro).mac, F.graph, F.mark.x - F.x, F.mark.y - F.y);
            GraphicFrames.Draw(F)
         END
      END
   END OpenMacro;

   PROCEDURE MakeMacro*;
      VAR new: BOOLEAN;
         F: GraphicFrames.Frame;
         S: Texts.Scanner;
         Lname: ARRAY 32 OF CHAR;

      PROCEDURE MakeMac;
         VAR x0, y0, x1, y1, w, h: INTEGER;
            mh: Graphics.MacHead;
            L: Graphics.Library;
      BEGIN
         L := Graphics.ThisLib(Lname, FALSE);
         IF L = NIL THEN L := Graphics.NewLib(Lname) END ;
         x0 := F.mark.x; y0 := F.mark.y; x1 := F.mark.next.x; y1 := F.mark.next.y;
         w := ABS(x1-x0); h := ABS(y1-y0);
         IF x0 < x1 THEN x0 := x0 - F.x ELSE x0 := x1 - F.x END ;
         IF y0 < y1 THEN y0 := y0 - F.y ELSE y0 := y1 - F.y END ;
         mh := Graphics.MakeMac(F.graph, x0, y0, w, h, S.s);
         Graphics.InsertMac(mh, L, new)
      END MakeMac;

   BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF S.class = Texts.Name THEN
         COPY(S.s, Lname); Texts.Scan(S);
         IF (S.class  = Texts.Name) OR (S.class = Texts.String) & (S.len <= 8) THEN
            F := GraphicFrames.Focus();
            IF (F # NIL) & (F.graph.sel # NIL) THEN
               MakeMac; Texts.WriteString(W, S.s);
               IF new THEN Texts.WriteString(W, " inserted in ")
               ELSE Texts.WriteString(W, " replaced in ")
               END ;
               Texts.WriteString(W, Lname); Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
            END
         END
      END
   END MakeMacro;

   PROCEDURE LoadLibrary*;
      VAR S: Texts.Scanner; L: Graphics.Library;
   BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF S.class = Texts.Name THEN
         L := Graphics.ThisLib(S.s, TRUE);
         Texts.WriteString(W, S.s); Texts.WriteString(W, " loaded");
         Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
      END
   END LoadLibrary;

   PROCEDURE StoreLibrary*;
      VAR i: INTEGER; S: Texts.Scanner; L: Graphics.Library;
         Lname: ARRAY 32 OF CHAR;
   BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF S.class = Texts.Name THEN i := 0;
         WHILE S.s[i] >= "0" DO Lname[i] := S.s[i]; INC(i) END ;
         Lname[i] := 0X;
         L := Graphics.ThisLib(Lname, FALSE);
         IF L # NIL THEN
            Texts.WriteString(W, S.s); Texts.WriteString(W, " storing");
            Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf); Graphics.StoreLib(L, S.s)
         END
      END
   END StoreLibrary;

BEGIN Texts.OpenWriter(W)
END Draw.
