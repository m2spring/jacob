MODULE System; (*JG 3.10.90 / NW 26.11.91*)

   IMPORT SYSTEM, Kernel, Modules, FileDir, Files, Input,
      Viewers, MenuViewers, Oberon, Fonts, Texts, TextFrames;

   CONST
      StandardMenu = "System.Close System.Copy System.Grow Edit.Search Edit.Store";
      LogMenu = "System.Close System.Grow Edit.Locate Edit.Store";

   VAR W: Texts.Writer;
      pos: INTEGER; trapped: BOOLEAN; diroption: CHAR;
      mod: Modules.Module;
      pat: ARRAY 32 OF CHAR;

   PROCEDURE Max (i, j: LONGINT): LONGINT;
   BEGIN IF i >= j THEN RETURN i ELSE RETURN j END
   END Max;

   (* ------------- Toolbox for system control ---------------*)

   PROCEDURE SetUser*;
      VAR i: INTEGER; ch: CHAR;
         user: ARRAY 8 OF CHAR;
         password: ARRAY 16 OF CHAR;
   BEGIN
      i := 0; Input.Read(ch);
      WHILE (ch # "/") & (i < 7) DO user[i] := ch; INC(i); Input.Read(ch) END;
      user[i] := 0X; i := 0; Input.Read(ch);
      WHILE (ch > " ") & (i < 15) DO password[i] := ch; INC(i); Input.Read(ch) END;
      password[i] := 0X;
      Oberon.SetUser(user, password)
   END SetUser;

   PROCEDURE SetFont*;
      VAR beg, end, time: LONGINT;
         T: Texts.Text; S: Texts.Scanner;
   BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF (S.class = Texts.Char) & (S.c = "^") THEN
         Oberon.GetSelection(T, beg, end, time);
         IF time >= 0 THEN
            Texts.OpenScanner(S, T, beg); Texts.Scan(S);
            IF S.class = Texts.Name THEN Oberon.SetFont(Fonts.This(S.s)) END
         END
      ELSIF S.class = Texts.Name THEN Oberon.SetFont(Fonts.This(S.s))
      END
   END SetFont;

   PROCEDURE SetColor*;
      VAR beg, end, time: LONGINT;
         T: Texts.Text; S: Texts.Scanner; ch: CHAR;
   BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF (S.class = Texts.Char) & (S.c = "^") THEN
         Oberon.GetSelection(T, beg, end, time);
         IF time >= 0 THEN
            Texts.OpenReader(S, T, beg); Texts.Read(S, ch); Oberon.SetColor(S.col)
         END
      ELSIF S.class = Texts.Int THEN Oberon.SetColor(SHORT(SHORT(S.i)))
      END
   END SetColor;

   PROCEDURE SetOffset*;
      VAR beg, end, time: LONGINT;
         T: Texts.Text;S: Texts.Scanner; ch: CHAR;
   BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF (S.class = Texts.Char) & (S.c = "^") THEN
         Oberon.GetSelection(T, beg, end, time);
         IF time >= 0 THEN
            Texts.OpenReader(S, T, beg); Texts.Read(S, ch); Oberon.SetOffset(S.voff)
         END
      ELSIF S.class = Texts.Int THEN Oberon.SetOffset(SHORT(SHORT(S.i)))
      END
   END SetOffset;

   PROCEDURE Time*;
      VAR par: Oberon.ParList;
         S: Texts.Scanner;
         t, d, hr, min, sec, yr, mo, day: LONGINT;
   BEGIN par := Oberon.Par;
      Texts.OpenScanner(S, par.text, par.pos); Texts.Scan(S);
      IF S.class = Texts.Int THEN (*set date*)
         day := S.i; Texts.Scan(S); mo := S.i; Texts.Scan(S); yr := S.i; Texts.Scan(S);
         hr := S.i; Texts.Scan(S); min := S.i; Texts.Scan(S); sec := S.i;
         t := (hr*64 + min)*64 + sec; d := (yr*16 + mo)*32 + day;
         Kernel.SetClock(t, d)
      ELSE (*read date*)
         Texts.WriteString(W, "System.Time");
         Oberon.GetClock(t, d); Texts.WriteDate(W, t, d); Texts.WriteLn(W);
         Texts.Append(Oberon.Log, W.buf)
      END
   END Time;

   PROCEDURE Collect*;
   BEGIN Oberon.Collect(0)
   END Collect;

   (* ------------- Toolbox for standard display ---------------*)

   PROCEDURE Open*;
      VAR par: Oberon.ParList;
         T: Texts.Text;
         S: Texts.Scanner;
         V: Viewers.Viewer;
         X, Y: INTEGER;
         beg, end, time: LONGINT;
   BEGIN
      par := Oberon.Par;
      Texts.OpenScanner(S, par.text, par.pos); Texts.Scan(S);
      IF (S.class = Texts.Char) & (S.c = "^") OR (S.line # 0) THEN
         Oberon.GetSelection(T, beg, end, time);
         IF time >= 0 THEN Texts.OpenScanner(S, T, beg); Texts.Scan(S) END
      END;
      IF S.class = Texts.Name THEN
         Oberon.AllocateSystemViewer(par.vwr.X, X, Y);
         V := MenuViewers.New(
            TextFrames.NewMenu(S.s, StandardMenu),
            TextFrames.NewText(TextFrames.Text(S.s), 0),
            TextFrames.menuH,
            X, Y)
      END
   END Open;

   PROCEDURE OpenLog*;
      VAR logV: Viewers.Viewer; X, Y: INTEGER;
   BEGIN
      Oberon.AllocateSystemViewer(Oberon.Par.vwr.X, X, Y);
      logV := MenuViewers.New(
         TextFrames.NewMenu("System.Log", LogMenu),
         TextFrames.NewText(Oberon.Log, Max(0, Oberon.Log.len - 200)),
         TextFrames.menuH,
         X, Y)
   END OpenLog;

   PROCEDURE Close*;
      VAR  par: Oberon.ParList; V: Viewers.Viewer; M: Viewers.ViewerMsg;
   BEGIN par := Oberon.Par;
      IF par.frame = par.vwr.dsc THEN V := par.vwr
      ELSE V := Oberon.MarkedViewer()
      END;
      Viewers.Close(V)
   END Close;

   PROCEDURE CloseTrack*;
      VAR V: Viewers.Viewer;
   BEGIN V := Oberon.MarkedViewer(); Viewers.CloseTrack(V.X)
   END CloseTrack;

   PROCEDURE Recall*;
      VAR V: Viewers.Viewer; M: Viewers.ViewerMsg;
   BEGIN
      Viewers.Recall(V);
      IF (V#NIL) & (V.state = 0) THEN
         Viewers.Open(V, V.X, V.Y + V.H); M.id := Viewers.restore; V.handle(V, M)
      END
   END Recall;

   PROCEDURE Copy*;
      VAR V, V1: Viewers.Viewer; M: Oberon.CopyMsg; N: Viewers.ViewerMsg;
   BEGIN
      V := Oberon.Par.vwr; V.handle(V, M); V1 := M.F(Viewers.Viewer);
      Viewers.Open(V1, V.X, V.Y + V.H DIV 2);
      N.id := Viewers.restore; V1.handle(V1, N)
   END Copy;

   PROCEDURE Grow*;
      VAR V, V1: Viewers.Viewer; M: Oberon.CopyMsg; N: Viewers.ViewerMsg;
         DW, DH: INTEGER;
   BEGIN V := Oberon.Par.vwr;
      DW := Oberon.DisplayWidth(V.X); DH := Oberon.DisplayHeight(V.X);
      IF V.H < DH - Viewers.minH THEN Oberon.OpenTrack(V.X, V.W)
      ELSIF V.W < DW THEN Oberon.OpenTrack(Oberon.UserTrack(V.X), DW)
      END;
      IF (V.H < DH - Viewers.minH) OR (V.W < DW) THEN
         V.handle(V, M); V1 := M.F(Viewers.Viewer);
         Viewers.Open(V1, V.X, DH);
         N.id := Viewers.restore; V1.handle(V1, N)
      END
   END Grow;

   (* ------------- Toolbox for module management ---------------*)

   PROCEDURE Free1(VAR S: Texts.Scanner);
   BEGIN Texts.WriteString(W, S.s); Texts.WriteString(W, " unloading");
      Texts.Append(Oberon.Log, W.buf);
      IF S.nextCh # "*" THEN Modules.Free(S.s, FALSE)
         ELSE Modules.Free(S.s, TRUE); Texts.Scan(S); Texts.WriteString(W, " all")
      END;
      IF Modules.res # 0 THEN Texts.WriteString(W, " failed") END;
      Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
   END Free1;

   PROCEDURE Free*;
      VAR T: Texts.Text;
         V: Viewers.Viewer;
         beg, end, time: LONGINT;
         S: Texts.Scanner;
   BEGIN Texts.WriteString(W, "System.Free"); Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf);
      Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF (S.class = Texts.Char) & (S.c = "^") THEN
         Oberon.GetSelection(T, beg, end, time);
         IF time >= 0 THEN Texts.OpenScanner(S, T, beg); Texts.Scan(S);
            IF S.class = Texts.Name THEN Free1(S) END
         END
      ELSE
         WHILE S.class = Texts.Name DO Free1(S); Texts.Scan(S) END
      END
   END Free;

   PROCEDURE ShowModules*;
      VAR T: Texts.Text;
         V: Viewers.Viewer;
         M: Modules.Module;
         X, Y: INTEGER;
   BEGIN T := TextFrames.Text("");
      Oberon.AllocateSystemViewer(Oberon.Par.vwr.X, X, Y);
      V := MenuViewers.New(TextFrames.NewMenu("System.ShowModules", StandardMenu),
                  TextFrames.NewText(T, 0), TextFrames.menuH, X, Y);
      M := SYSTEM.VAL(Modules.Module, Kernel.ModList);
      WHILE M # NIL DO
         Texts.WriteString(W, M.name); Texts.WriteInt(W, M.size, 8);
         Texts.WriteInt(W, M.refcnt, 4); Texts.WriteLn(W); M := M.link
      END;
      Texts.Append(T, W.buf)
   END ShowModules;

   (* ------------- Toolbox of file system ---------------*)

   PROCEDURE List(name: FileDir.FileName; adr: LONGINT; VAR cont: BOOLEAN);
      VAR i0, i1, j0, j1: INTEGER; f: BOOLEAN; hp: FileDir.FileHeader;
   BEGIN i0 := pos; j0 := pos; f := TRUE;
      LOOP
         IF pat[i0] = "*" THEN INC(i0);
            IF pat[i0] = 0X THEN EXIT END
         ELSE
            IF name[j0] # 0X THEN f := FALSE END;
            EXIT
         END;
         f := FALSE;
         LOOP
            IF name[j0] = 0X THEN EXIT END;
            i1 := i0; j1 := j0;
            LOOP
               IF pat[i1] = "*" THEN f := TRUE; EXIT END ;
               IF pat[i1] # name[j1] THEN EXIT END;
               INC(i1); INC(j1);
               IF pat[i1-1] = 0X THEN f := TRUE; EXIT END
            END ;
            IF f THEN j0 := j1; i0 := i1; EXIT END;
            INC(j0)
         END;
         IF ~f OR (pat[i0-1] = 0X) THEN EXIT END
      END ;
      IF f THEN
         Texts.WriteString(W, name);
         IF diroption = "d" THEN
            Kernel.GetSector(adr, hp);
             Texts.WriteString(W, "    "); Texts.WriteDate(W, hp.time, hp.date);
            Texts.WriteInt(W, LONG(hp.aleng)*FileDir.SectorSize + hp.bleng - FileDir.HeaderSize, 8)
         END ;
         Texts.WriteLn(W)
      END
   END List;

   PROCEDURE Directory*;
      VAR X, Y, i: INTEGER; ch: CHAR;
         R: Texts.Reader;
         T, t: Texts.Text;
         V: Viewers.Viewer;
         beg, end, time: LONGINT;
         pre: ARRAY 32 OF CHAR;
   BEGIN Texts.OpenReader(R, Oberon.Par.text, Oberon.Par.pos); Texts.Read(R, ch);
      WHILE ch = " " DO Texts.Read(R, ch) END;
      IF (ch = "^") OR (ch = 0DX) THEN
         Oberon.GetSelection(T, beg, end, time);
         IF time >= 0 THEN
            Texts.OpenReader(R, T, beg); Texts.Read(R, ch);
            WHILE ch <= " " DO Texts.Read(R, ch) END
         END
      END ;
      i := 0;
      WHILE (ch > " ") & (ch # "/") DO pat[i] := ch; INC(i); Texts.Read(R, ch) END;
      pat[i] := 0X;
      IF ch = "/" THEN Texts.Read(R, diroption) ELSE diroption := 0X END;
      i := 0;
      WHILE pat[i] > "*" DO pre[i] := pat[i]; INC(i) END;
      pre[i] := 0X; pos := i;
      Oberon.AllocateSystemViewer(Oberon.Par.vwr.X, X, Y); t := TextFrames.Text("");
      V := MenuViewers.New(
         TextFrames.NewMenu("System.Directory", StandardMenu),
         TextFrames.NewText(t, 0), TextFrames.menuH, X, Y);
      FileDir.Enumerate(pre, List); Texts.Append(t, W.buf)
   END Directory;

   PROCEDURE CopyFile(name: ARRAY OF CHAR; VAR S: Texts.Scanner);
      VAR f, g: Files.File; Rf, Rg: Files.Rider; ch: CHAR;
   BEGIN Texts.Scan(S);
      IF (S.class = Texts.Char) & (S.c = "=") THEN Texts.Scan(S);
         IF (S.class = Texts.Char) & (S.c = ">") THEN Texts.Scan(S);
            IF S.class = Texts.Name THEN
               Texts.WriteString(W, name); Texts.WriteString(W, " => "); Texts.WriteString(W, S.s);
               Texts.WriteString(W, " copying"); Texts.Append(Oberon.Log, W.buf);
               f := Files.Old(name);
               IF f # NIL THEN g := Files.New(S.s);
                  Files.Set(Rf, f, 0); Files.Set(Rg, g, 0); Files.Read(Rf, ch);
                  WHILE ~Rf.eof DO Files.Write(Rg, ch); Files.Read(Rf, ch) END;
                  Files.Register(g)
               ELSE Texts.WriteString(W, " failed")
               END ;
               Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
            END
         END
      END
   END CopyFile;

   PROCEDURE CopyFiles*;
      VAR beg, end, time: LONGINT; res: INTEGER;
         T: Texts.Text;
         S: Texts.Scanner;
   BEGIN Texts.WriteString(W, "System.CopyFiles"); Texts.WriteLn(W);
      Texts.Append(Oberon.Log, W.buf);
      Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF (S.class = Texts.Char) & (S.c = "^") THEN Oberon.GetSelection(T, beg, end, time);
         IF time >= 0 THEN
            Texts.OpenScanner(S, T, beg); Texts.Scan(S);
            IF S.class = Texts.Name THEN CopyFile(S.s, S) END
         END
      ELSE
         WHILE S.class = Texts.Name DO CopyFile(S.s, S); Texts.Scan(S) END
      END
   END CopyFiles;

   PROCEDURE RenameFile (name: ARRAY OF CHAR; VAR S: Texts.Scanner);
      VAR res: INTEGER;
   BEGIN Texts.Scan(S);
      IF (S.class = Texts.Char) & (S.c = "=") THEN Texts.Scan(S);
         IF (S.class = Texts.Char) & (S.c = ">") THEN Texts.Scan(S);
            IF S.class = Texts.Name THEN
               Texts.WriteString(W, name); Texts.WriteString(W, " => "); Texts.WriteString(W, S.s);
               Texts.WriteString(W, " renaming"); Texts.Append(Oberon.Log, W.buf);
               Files.Rename(name, S.s, res);
               IF res > 1 THEN Texts.WriteString(W, " failed") END;
               Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
            END
         END
      END
   END RenameFile;

   PROCEDURE RenameFiles*;
      VAR beg, end, time: LONGINT; res: INTEGER;
         T: Texts.Text;
         S: Texts.Scanner;
   BEGIN Texts.WriteString(W, "System.RenameFiles"); Texts.WriteLn(W);
      Texts.Append(Oberon.Log, W.buf);
      Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF (S.class = Texts.Char) & (S.c = "^") THEN
         Oberon.GetSelection(T, beg, end, time);
         IF time >= 0 THEN
            Texts.OpenScanner(S, T, beg); Texts.Scan(S);
            IF S.class = Texts.Name THEN RenameFile(S.s, S) END
         END
      ELSE
         WHILE S.class = Texts.Name DO RenameFile(S.s, S); Texts.Scan(S) END
      END
   END RenameFiles;

   PROCEDURE DeleteFile(VAR name: ARRAY OF CHAR);
       VAR res: INTEGER;
   BEGIN Texts.WriteString(W, name); Texts.WriteString(W, " deleting");
      Texts.Append(Oberon.Log, W.buf); Files.Delete(name, res);
      IF res # 0 THEN Texts.WriteString(W, " failed") END;
      Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
   END DeleteFile;

   PROCEDURE DeleteFiles*;
      VAR beg, end, time: LONGINT;
         T: Texts.Text;
         S: Texts.Scanner;
   BEGIN Texts.WriteString(W, "System.DeleteFiles"); Texts.WriteLn(W);
      Texts.Append(Oberon.Log, W.buf);
      Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF (S.class = Texts.Char) & (S.c = "^") THEN
         Oberon.GetSelection(T, beg, end, time);
         IF time >= 0 THEN Texts.OpenScanner(S, T, beg); Texts.Scan(S);
            IF S.class = Texts.Name THEN DeleteFile(S.s) END
         END
      ELSE
         WHILE S.class = Texts.Name DO DeleteFile(S.s); Texts.Scan(S) END
      END
   END DeleteFiles;

   (* ------------- Toolbox for system inspection ---------------*)

   PROCEDURE Watch*;
   BEGIN
      Texts.WriteString(W, "System.Watch"); Texts.WriteLn(W);
      Texts.WriteInt(W, Kernel.NofPages, 1); Texts.WriteString(W, " pages, ");
      Texts.WriteInt(W, Kernel.NofSectors, 1); Texts.WriteString(W, " sectors, ");
      Texts.WriteInt(W, Kernel.allocated, 1); Texts.WriteString(W, " bytes allocated");
      Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
   END Watch;

   PROCEDURE Locals(VAR R: Files.Rider; base: LONGINT);
      VAR adr, val: LONGINT;
         sval, form: SHORTINT;
         ch, mode: CHAR;
         ival, i: INTEGER;
         rval: REAL;
         lrval: LONGREAL;
   BEGIN Texts.WriteLn(W); Files.Read(R, mode);
      WHILE ~R.eof & (mode < 0F8X) DO
         Files.Read(R, form); Files.ReadBytes(R,  adr, 4);
         Texts.WriteString(W, "   "); Files.Read(R, ch);
         WHILE ch > 0X DO Texts.Write(W, ch); Files.Read(R, ch) END ;
         Texts.WriteString(W, " = "); INC(adr, base);
         IF mode = 3X THEN SYSTEM.GET(adr, adr) (*indirect*) END ;
         CASE form OF
           2: (*BOOL*) SYSTEM.GET(adr, sval);
            IF sval = 0 THEN Texts.WriteString(W, "FALSE")
               ELSE Texts.WriteString(W, "TRUE")
            END
         | 1,3: (*CHAR*) SYSTEM.GET(adr, ch);
            IF (" " <= ch) & (ch <= "~") THEN Texts.Write(W, ch)
               ELSE Texts.WriteHex(W, ORD(ch)); Texts.Write(W, "X")
            END
         | 4: (*SINT*) SYSTEM.GET(adr, sval); Texts.WriteInt(W, sval, 1)
         | 5: (*INT*) SYSTEM.GET(adr, ival); Texts.WriteInt(W, ival, 1)
         | 6: (*LINT*) SYSTEM.GET(adr, val); Texts.WriteInt(W, val, 1)
         | 7: (*REAL*) SYSTEM.GET(adr, rval); Texts.WriteReal(W, rval, 14)
         | 8: (*LREAL*) SYSTEM.GET(adr, lrval); Texts.WriteLongReal(W, lrval, 21)
         | 9, 13, 14: (*SET, POINTER*)
            SYSTEM.GET(adr, val); Texts.WriteHex(W, val); Texts.Write(W, "H")
         | 15: (*String*) i := 0; Texts.Write(W, 22X);
            LOOP SYSTEM.GET(adr, ch);
               IF (ch < " ") OR (ch >= 90X) OR (i = 32) THEN EXIT END ;
               Texts.Write(W, ch); INC(i); INC(adr)
            END ;
            Texts.Write(W, 22X)
         END;
         Texts.WriteLn(W); Files.Read(R, mode)
      END
   END Locals;

   PROCEDURE OutState (VAR name: ARRAY OF CHAR; t: Texts.Text);
      VAR mod: Modules.Module;
      refpos: LONGINT;
      ch: CHAR; X, Y, i: INTEGER;
      F: Files.File; R: Files.Rider;
    BEGIN
       Texts.WriteString(W, name); mod := SYSTEM.VAL(Modules.Module, Kernel.ModList);
       WHILE (mod # NIL) & (mod.name # name) DO mod := mod.link END ;
       IF mod # NIL THEN
          i := 0;
          WHILE (i < 28) & (name[i] > 0X)  DO INC(i) END ;
          name[i] := "."; name[i+1] := "O"; name[i+2] := "b"; name[i+3] := "j"; name[i+4] := 0X;
          F := Files.Old(name);
          IF F # NIL THEN
             Texts.WriteString(W, "  SB ="); Texts.WriteHex(W, mod.SB);
             Files.Set(R, F, 2); Files.ReadBytes(R, refpos, 4); Files.Set(R, F, refpos+1);
              LOOP Files.Read(R, ch);
                IF R.eof THEN EXIT END ;
                IF ch = 0F8X THEN
                   Files.ReadBytes(R, i, 2); Files.Read(R, ch);
                   IF ch = "$" THEN Files.Read(R, ch); Files.Read(R, ch); EXIT END ;
                   REPEAT Files.Read(R, ch) UNTIL ch = 0X  (*skip name*)
                ELSIF ch < 0F8X THEN  (*skip object*)
                   Files.Read(R, ch); Files.Read(R, ch); Files.Read(R, ch);
                   REPEAT Files.Read(R, ch) UNTIL ch = 0X; (*skip name*)
               END
            END ;
            IF ~R.eof THEN Locals(R, mod.SB) END
         ELSE Texts.WriteString(W, ".Obj  not found")
         END
      ELSE Texts.WriteString(W, " not loaded")
      END ;
      Texts.WriteLn(W); Texts.Append(t, W.buf)
   END OutState;

   PROCEDURE State*;
      VAR T: Texts.Text;
         S: Texts.Scanner;
         V: Viewers.Viewer;
         beg, end, time: LONGINT;
         X, Y: INTEGER;
   BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF (S.class = Texts.Char) & (S.c = "^") THEN
         Oberon.GetSelection(T, beg, end, time);
         IF time >= 0 THEN Texts.OpenScanner(S, T, beg); Texts.Scan(S) END
      END;
      IF S.class = Texts.Name THEN
         Oberon.AllocateSystemViewer(Oberon.Par.vwr.X, X, Y); T := TextFrames.Text("");
         V := MenuViewers.New(TextFrames.NewMenu("System.State", StandardMenu),
                  TextFrames.NewText(T, 0), TextFrames.menuH, X, Y);
         OutState(S.s, T)
      END
   END State;

   PROCEDURE ShowCommands*;
      VAR M: Modules.Module;
         comadr, beg, end, time: LONGINT; ch: CHAR;
         T: Texts.Text;
         S: Texts.Scanner;
         V: Viewers.Viewer;
         X, Y: INTEGER;
   BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF (S.class = Texts.Char) & (S.c = "^") THEN
         Oberon.GetSelection(T, beg, end, time);
         IF time >= 0 THEN Texts.OpenScanner(S, T, beg); Texts.Scan(S) END
      END ;
      IF S.class = Texts.Name THEN
         M := Modules.ThisMod(S.s);
         IF M # NIL THEN comadr := M.CB;
            Oberon.AllocateSystemViewer(Oberon.Par.vwr.X, X, Y); T := TextFrames.Text("");
            V := MenuViewers.New(TextFrames.NewMenu("System.Commands", StandardMenu),
                     TextFrames.NewText(T, 0), TextFrames.menuH, X, Y);
            LOOP SYSTEM.GET(comadr, ch); INC(comadr);
               IF ch = 0X THEN EXIT END ;
               Texts.WriteString(W, S.s); Texts.Write(W, ".");
               REPEAT Texts.Write(W, ch); SYSTEM.GET(comadr, ch); INC(comadr)
               UNTIL ch = 0X;
               Texts.WriteLn(W); INC(comadr, 2)
            END ;
            Texts.Append(T, W.buf)
         END
      END
   END ShowCommands;

   PROCEDURE Trap;
      VAR V: Viewers.Viewer;
         T: Texts.Text;
         RefFile: Files.File;
         R: Files.Rider;
         fp, pc, refpos, dmy: LONGINT;
         ch, mode: CHAR;
         X, Y, i: INTEGER;
         mod, curmod: Modules.Module;
         name: ARRAY 24 OF CHAR;
   BEGIN
      IF ~trapped THEN
         trapped := TRUE; T := TextFrames.Text("");
         Oberon.AllocateSystemViewer(0, X, Y);
         V := MenuViewers.New(TextFrames.NewMenu("System.Trap", StandardMenu),
                     TextFrames.NewText(T, 0), TextFrames.menuH, X, Y);
         IF V.state > 0 THEN
            fp := Kernel.fp; pc := Kernel.pc; curmod := NIL;
            mod := SYSTEM.VAL(Modules.Module, Kernel.mod MOD 10000H);
            Texts.WriteString(W, "TRAP "); Texts.WriteInt(W, Kernel.err, 1);
            Texts.WriteString(W, "  FP ="); Texts.WriteHex(W, fp);
            Texts.WriteString(W, "  PC ="); Texts.WriteHex(W, pc);
            IF Kernel.err = 2 THEN
               Texts.WriteString(W, "  EIA ="); Texts.WriteHex(W, Kernel.eia)
            ELSIF Kernel.err = 20 THEN
               Texts.WriteString(W, "  sect ="); Texts.WriteHex(W, Kernel.SectNo)
            END ;
            Texts.WriteLn(W);
            LOOP Texts.WriteString(W, mod.name); Texts.Append(T, W.buf);
               IF mod # curmod THEN
                  (*load obj file*) i := 0;
                  WHILE mod.name[i] > 0X DO name[i] := mod.name[i]; INC(i) END ;
                  name[i] := "."; name[i+1] := "O"; name[i+2] := "b"; name[i+3] := "j"; name[i+4] := 0X;
                  RefFile := Files.Old(name);
                  IF RefFile = NIL THEN curmod := NIL; Texts.WriteLn(W)
                  ELSE curmod := mod; Files.Set(R, RefFile, 2);
                     Files.ReadBytes(R, refpos, 4); Files.Set(R, RefFile, refpos); Files.Read(R, ch);
                     IF ch = 8AX THEN INC(refpos)
                     ELSE curmod := NIL; Texts.WriteInt(W, pc - mod.PB, 7); Texts.WriteLn(W)
                     END
                  END
               END ;
               IF curmod # NIL THEN  (*find procedure*)
                  Files.Set(R, RefFile, refpos);
                  LOOP Files.Read(R, ch);
                     IF R.eof THEN EXIT END ;
                     IF ch = 0F8X THEN (*start proc*)
                        Files.ReadBytes(R, i, 2);
                        IF pc < mod.PB + i THEN EXIT END;
                        REPEAT Files.Read(R, ch) UNTIL ch = 0X; (*skip name*)
                     ELSIF ch < 0F8X THEN (*skip object*)
                        Files.Read(R, ch); Files.ReadBytes(R, dmy, 4);
                        REPEAT Files.Read(R, ch) UNTIL ch = 0X; (*skip name*)
                     END
                  END ;
                  IF ~R.eof THEN
                     Texts.Write(W, "."); Files.Read(R, ch);
                     WHILE ch > 0X DO Texts.Write(W, ch); Files.Read(R, ch) END ;
                     Texts.Append(T, W.buf); Locals(R, fp)
                  END
               END ;
               SYSTEM.GET(fp+4, pc); SYSTEM.GET(fp, fp);
               IF fp >= Kernel.StackOrg THEN EXIT END ;
               mod := SYSTEM.VAL(Modules.Module, Kernel.ModList);  (*find module of next procedure*)
               WHILE (mod # NIL) &
                  ((pc < mod.PB) OR (mod.size + mod.BB <= pc)) DO
                  mod := mod.link
               END ;
               IF mod = NIL THEN EXIT END
            END ;
            Texts.Append(T, W.buf)
         END ;
         trapped := FALSE
      END
   END Trap;

  PROCEDURE OpenViewers;
   VAR logV, toolV: Viewers.Viewer; t, d: LONGINT; X, Y: INTEGER;
  BEGIN
   Oberon.GetClock(t, d); Texts.WriteString(W, "System.Time");
   Texts.WriteDate(W, t, d); Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf);
   Oberon.AllocateSystemViewer(0, X, Y);
   logV := MenuViewers.New(
      TextFrames.NewMenu("System.Log", LogMenu),
      TextFrames.NewText(Oberon.Log, 0),
      TextFrames.menuH,
      X, Y);
   Oberon.AllocateSystemViewer(0, X, Y);
   toolV := MenuViewers.New(
      TextFrames.NewMenu("System.Tool", StandardMenu),
      TextFrames.NewText(TextFrames.Text("System.Tool"), 0),
      TextFrames.menuH,
      X, Y)
  END OpenViewers;

BEGIN trapped := FALSE; Kernel.InstallTrap(Trap); Texts.OpenWriter(W);
   Oberon.Log := TextFrames.Text(""); OpenViewers;
   mod := Modules.ThisMod("Configuration")
END System.
