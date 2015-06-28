MODULE MenuElems;   (*NW 4.7.93 / HM 8.12.93*)
        IMPORT Display, Viewers, Input, Fonts, Files, Texts, TextFrames, MenuViewers, Oberon;

        CONST
                left = 2; middle = 1; right = 0;  (*mouse keys*)

        TYPE
                Menu = POINTER TO MenuDesc;
                MenuDesc = RECORD (Texts.ElemDesc)
                        text: Texts.Text;
                        nofcom, lastcom, mpos, mw, mh, lsp, dsc: INTEGER
                END ;

                EditFrame = POINTER TO EditFrameDesc;
                EditFrameDesc = RECORD (TextFrames.FrameDesc)
                        menu: Menu
                END ;

        VAR
                buf: Texts.Buffer;  (*copy buffer*)
                YBottom: INTEGER;

        PROCEDURE WriteTitle(M: Menu; x, y: INTEGER);
                VAR dx, x1, y1, w, h: INTEGER;
                        ch: CHAR;
                        pat: Display.Pattern;
                        R: Texts.Reader;
        BEGIN
                Texts.OpenReader(R, M.text, 0); Texts.Read(R, ch);
                IF R.eot THEN ch := Texts.ElemChar; R.fnt := Fonts.Default END;
                DEC(y, R.fnt.minY);
                REPEAT
                        Display.GetChar(R.fnt.raster, ch, dx, x1, y1, w, h, pat);
                        Display.CopyPattern(R.col, pat, x + x1, y + y1, Display.invert);
                        INC(x, dx); Texts.Read(R, ch)
                UNTIL R.eot OR (ch <= " ")
        END WriteTitle;

        PROCEDURE DrawMenu(M: Menu; col, x, y, w, h: INTEGER);
                VAR x0, x1, y1, dx: INTEGER; ch: CHAR;
                        pat: Display.Pattern;
                        R: Texts.Reader;
        BEGIN Display.ReplConst(Display.black, x, y, w, h, 0);
                Display.ReplConst(col, x, y, w, 1, 0);
                Display.ReplConst(col, x+w-1, y, 1, h, 0);
                Display.ReplConst(col, x, y+h-1, w, 1, 0);
                Display.ReplConst(col, x, y, 1, h, 0);
                Texts.OpenReader(R, M.text, M.mpos); Texts.Read(R, ch);
                x0 := x + 4; x := x0; y := y + h - M.lsp - M.dsc - 4;
                WHILE ~R.eot DO
                        IF ch = 0DX THEN DEC(y, M.lsp); x := x0
                        ELSE Display.GetChar(R.fnt.raster, ch, dx, x1, y1, w, h, pat);
                                Display.CopyPattern(R.col, pat, x+x1, y+y1, 0); INC(x, dx)
                        END ;
                        Texts.Read(R, ch)
                END
        END DrawMenu;

        PROCEDURE HandleEdit(F: Display.Frame; VAR M: Display.FrameMsg);
                VAR F1: EditFrame;
        BEGIN TextFrames.Handle(F, M);
                WITH F: EditFrame DO
                        IF M IS Oberon.CopyMsg THEN
                                NEW(F1);
                                TextFrames.Open(F1, F.text, F.org);
                                F1.handle := F.handle; F1.menu := F.menu; M(Oberon.CopyMsg).F := F1
                        END
                END
        END HandleEdit;

        PROCEDURE Edit(M: Menu);
                VAR V: Viewers.Viewer; F: EditFrame;
                        T: Texts.Text; x, y: INTEGER;
        BEGIN T := TextFrames.Text("");
                Texts.Save(M.text, 0, M.text.len, buf); Texts.Append(T, buf);
                Oberon.AllocateUserViewer(Oberon.Par.vwr.X, x, y);
                NEW(F); F.menu := M;
                TextFrames.Open(F, T, 0); F.handle := HandleEdit;
                V := MenuViewers.New(TextFrames.NewMenu("Menu", "System.Close  MenuElems.Update "),
                                F, TextFrames.menuH, x, y)
        END Edit;

        PROCEDURE TrackMenu(M: Menu; x, y: INTEGER; VAR cmd: INTEGER; VAR edit: BOOLEAN);
                VAR mx, my, xbar, wbar, lsp, top, com, old, dy, i: INTEGER; keys: SET; cancel: BOOLEAN;
        BEGIN
                lsp := M.lsp; xbar := x + 4; wbar := M.mw - 8; top := y + M.mh - 4;
                my := y + M.mh - (M.lastcom+1) * lsp;
                Input.Mouse(keys, mx, i); dy := my - i;
                keys := {middle}; cancel := FALSE; edit := FALSE; old := -1;
                LOOP
                        IF (x < mx) & (mx < x + M.mw) & (y + 4 < my) & (my < top) THEN
                                com := (top - my) DIV lsp; Oberon.FadeCursor(Oberon.Mouse)
                        ELSE com := -1; Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, mx, my)
                        END;
                        IF com # old THEN
                                IF old >= 0 THEN Display.ReplConst(Display.white, xbar, top-(old+1)*lsp, wbar, lsp, Display.invert) END;
                                IF com >= 0 THEN Display.ReplConst(Display.white, xbar, top-(com+1)*lsp, wbar, lsp, Display.invert) END;
                                old := com
                        END;
                        IF keys = {} THEN EXIT
                        ELSIF keys = {left, middle, right} THEN cancel := TRUE
                        ELSIF left IN keys THEN edit := TRUE
                        END;
                        Input.Mouse(keys, mx, my); my := (my + dy) MOD Display.Height
                END;
                IF cancel THEN com := -1; edit := FALSE END;
                Oberon.FadeCursor(Oberon.Mouse); cmd := com
        END TrackMenu;

        PROCEDURE Popup(M: Menu; col, x, y: INTEGER);
                VAR i, j, cmd, res: INTEGER; ch: CHAR; keys: SET; cmdStr: ARRAY 32 OF CHAR; R: Texts.Reader; edit: BOOLEAN;
                        v: Viewers.Viewer;
        BEGIN cmd := M.lastcom; v := Viewers.This(x, y);
                IF x + M.mw > v.X + v.W THEN x := v.X + v.W - M.mw END ;
                IF y + M.mh > v.Y + v.H THEN y := v.Y + v.H - M.mh END ;
                Oberon.RemoveMarks(x, y, M.mw, M.mh); Oberon.FadeCursor(Oberon.Mouse);
                Display.CopyBlock(x, y, M.mw, M.mh, x, YBottom, 0);  (*save*)
                DrawMenu(M, col, x, y, M.mw, M.mh); TrackMenu(M, x, y, cmd, edit);
                Display.CopyBlock(x, YBottom, M.mw, M.mh, x, y, 0);  (*restore*)
                IF edit THEN Edit(M)
                ELSIF cmd >= 0 THEN
                        M.lastcom := cmd; j := 0; Texts.OpenReader(R, M.text, M.mpos); Texts.Read(R, ch);
                        WHILE j < cmd DO
                                IF ch = 0DX THEN INC(j) END ;
                                Texts.Read(R, ch)
                        END;
                        i := 0;
                        WHILE (ch > " ") & (i < 31) DO cmdStr[i] := ch; INC(i); Texts.Read(R, ch) END;
                        cmdStr[i] := 0X;
                        Oberon.Par.vwr := v; Oberon.Par.frame := v.dsc; Oberon.Par.text := M.text; Oberon.Par.pos := Texts.Pos(R);
                        Oberon.Call(cmdStr, Oberon.Par, FALSE, res)
                END
        END Popup;

        PROCEDURE Load(VAR R: Files.Rider; M: Menu);
                VAR n: LONGINT;
        BEGIN Files.ReadNum(R, n); M.nofcom := SHORT(n); M.lastcom := 0;
                Files.ReadNum(R, n); M.mpos := SHORT(n);
                Files.ReadNum(R, n); M.mw := SHORT(n); Files.ReadNum(R, n); M.mh := SHORT(n);
                Files.ReadNum(R, n); M.lsp := SHORT(n); Files.ReadNum(R, n); M.dsc := SHORT(n);
                M.text := TextFrames.Text("");
                Texts.Load(R, M.text)
        END Load;

        PROCEDURE Store(VAR R: Files.Rider; M: Menu);
        BEGIN Files.WriteNum(R, M.nofcom); Files.WriteNum(R, M.mpos); Files.WriteNum(R, M.mw);
                Files.WriteNum(R, M.mh); Files.WriteNum(R, M.lsp); Files.WriteNum(R, M.dsc);
                Texts.Store(R, M.text)
        END Store;

        PROCEDURE Handle(E: Texts.Elem; VAR msg: Texts.ElemMsg);
                VAR M: Menu;
        BEGIN
                WITH E: Menu DO
                        IF msg IS TextFrames.DisplayMsg THEN
                                WITH msg: TextFrames.DisplayMsg DO
                                        IF ~msg.prepare THEN WriteTitle(E, msg.X0, msg.Y0) END
                                END
                        ELSIF msg IS Texts.CopyMsg THEN
                                WITH msg: Texts.CopyMsg DO
                                        NEW(M); Texts.CopyElem(E, M);
                                        M.nofcom := E.nofcom; M.lastcom := E.lastcom; M.mpos := E.mpos; M.mw := E.mw;
                                        M.mh := E.mh; M.lsp := E.lsp; M.dsc := E.dsc; M.text := TextFrames.Text("");
                                        Texts.Save(E.text, 0, E.text.len, buf); Texts.Append(M.text, buf); msg.e := M
                                END
                        ELSIF msg IS Texts.IdentifyMsg THEN
                                WITH msg: Texts.IdentifyMsg DO
                                        msg.mod := "MenuElems"; msg.proc := "Alloc"
                                END
                        ELSIF msg IS Texts.FileMsg THEN
                                WITH msg: Texts.FileMsg DO
                                        IF msg.id = Texts.load THEN Load(msg.r, E)
                                        ELSIF msg.id = Texts.store THEN Store(msg.r, E)
                                        END
                                END
                        ELSIF msg IS TextFrames.TrackMsg THEN
                                WITH msg: TextFrames.TrackMsg DO
                                        IF msg.keys = {middle} THEN Popup(E, msg.col, msg.X0, msg.Y0) END
                                END
                        END
                END
        END Handle;

        PROCEDURE Alloc*;
                VAR M: Menu;
        BEGIN NEW(M); M.handle := Handle; Texts.new := M
        END Alloc;

        PROCEDURE Update*;
                VAR M: Menu; pos: LONGINT;
                        len, dx, x1, y1, w, w1, h, h1: INTEGER; ch: CHAR;
                        pat: Display.Pattern;
                        F: EditFrame;
                        T: Texts.Text;
                        R: Texts.Reader;
        BEGIN
                IF Oberon.Par.frame = Oberon.Par.vwr.dsc THEN
                        F := Oberon.Par.frame.next(EditFrame); M := F.menu; T := F.text;
                        Texts.OpenReader(R, T, 0); len := 1; w := 0; h := 0; Texts.Read(R, ch);
                        WHILE ~R.eot & (ch > " ") DO
                                Display.GetChar(R.fnt.raster, ch, dx, x1, y1, w1, h1, pat); INC(w, dx); INC(len);
                                IF h < R.fnt.height THEN h := R.fnt.height END ;
                                Texts.Read(R, ch)
                        END ;
                        Texts.Read(R, ch);
                        M.W := LONG(w)*Display.Unit; M.H := LONG(h)*Display.Unit; M.mpos := len;
                        M.nofcom := 0; M.lastcom := 0; M.mw := 0; M.lsp := 0; M.dsc := 0; w := 0;
                        WHILE ~R.eot DO
                                IF ch = 0DX THEN
                                        IF M.mw < w THEN M.mw := w END ;
                                        w := 0; INC(M.nofcom)
                                ELSE
                                        IF M.lsp < R.fnt.height THEN M.lsp := R.fnt.height END ;
                                        IF M.dsc > R.fnt.minY THEN M.dsc := R.fnt.minY END ;
                                        Display.GetChar(R.fnt.raster, ch, dx, x1, y1, w1, h1, pat); INC(w, dx)
                                END ;
                                Texts.Read(R, ch)
                        END ;
                        IF w > 0 THEN INC(M.nofcom);
                                IF M.mw < w THEN M.mw := w END
                        END ;
                        M.mh := M.lsp * M.nofcom + 8; INC(M.mw, 8); M.text := T;
                        T := Texts.ElemBase(M); pos := Texts.ElemPos(M); T.notify(T, Texts.replace, pos, pos+1);
                        T := Oberon.Par.frame(TextFrames.Frame).text;
                        Texts.OpenReader(R, T, T.len - 1); Texts.Read(R, ch);
                        IF ch = "!" THEN Texts.Delete(T, T.len - 1, T.len) END
                END
        END Update;

        PROCEDURE Insert*;
                VAR M: Menu; insert: TextFrames.InsertElemMsg;
        BEGIN  NEW(M);
                M.W := 8*Display.Unit; M.H := M.W; M.lsp := 8; M.mw := 8; M.mh := 8;
                M.text := TextFrames.Text(""); M.handle := Handle;
                insert.e := M; Viewers.Broadcast(insert)
        END Insert;

BEGIN NEW(buf); Texts.OpenBuf(buf); YBottom := Display.UBottom
END MenuElems.
