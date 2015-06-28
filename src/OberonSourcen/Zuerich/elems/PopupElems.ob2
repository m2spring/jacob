MODULE PopupElems;      (* Michael Franz, 27.1.92 -- "Hypertext without Surprises" *)   (* << RC *)
        (* SHML , save into memory instead of secondary bitmap, supports color screen, editing of name *)
        (* supports MenuElems behavior (new commands InsertMenu and Toggle) *)

        IMPORT
                Oberon, Input, Display, Viewers, Files, Fonts, Printer,
                Texts, TextFrames, MenuViewers, TextPrinter, Modules;

        CONST
                edw = 4; edh = 2; mdw = 3; mdh = 1; CR = 0DX;   (* margins of element box and menu box *)
                DUnit = TextFrames.Unit; PUnit = TextPrinter.Unit;
                MR = 0; MM = 1; ML = 2; cancel = {ML, MM, MR};

        TYPE
                Elem = POINTER TO ElemDesc;
                ElemDesc = RECORD(Texts.ElemDesc)
                        name: ARRAY 32 OF CHAR;
                        menu: Texts.Text;
                        n, def, wid, lsp, dsc: INTEGER; (* number of items, default, width, line space, descender *)
                        simple: BOOLEAN (* elem displays itself simple *)
                END;

                EditFrame = POINTER TO EditFrameDesc;
                EditFrameDesc = RECORD (TextFrames.FrameDesc)
                        elem: Elem
                END;

        VAR
                Wr: Texts.Writer;
                buf: Texts.Buffer;      (* copy buffer *)

(* auxiliary *)

        PROCEDURE Min(x, y: INTEGER): INTEGER;
        BEGIN IF x < y THEN RETURN x ELSE RETURN y END
        END Min;

        PROCEDURE Max(x, y: INTEGER): INTEGER;
        BEGIN IF x > y THEN RETURN x ELSE RETURN y END
        END Max;

        PROCEDURE CopyText(T: Texts.Text): Texts.Text;
                VAR t: Texts.Text;
        BEGIN Texts.Save(T, 0, T.len, buf); t := TextFrames.Text(""); Texts.Append(t, buf); RETURN t
        END CopyText;

        PROCEDURE DefaultMenu(E: Elem);
        BEGIN
                IF E.menu.len > 0 THEN Texts.Delete(E.menu, 0, E.menu.len) END;
                Texts.WriteString(Wr, "right interclick to edit menu"); Texts.WriteLn(Wr); Texts.Append(E.menu, Wr.buf)
        END DefaultMenu;

(* change propagation *)

        PROCEDURE PrepareElem(E: Elem; fnt: Fonts.Font; VAR dy: INTEGER);
                VAR i, wid, dh, dx, x, y, w, h: INTEGER; p: LONGINT;
        BEGIN
                IF E.simple THEN wid := 0; dh := 0; dy := fnt.minY; IF dy > -2 THEN dy := -2 END
                ELSE wid := 2*edw+4; dh := -fnt.minY+2*edh+2 END;
                i := 0;
                WHILE E.name[i] # 0X DO Display.GetChar(fnt.raster, E.name[i], dx, x, y, w, h, p); INC(wid, dx); INC(i) END;
                E.W := LONG(wid+1)*DUnit; E.H := LONG(fnt.maxY-fnt.minY+dh)*DUnit
        END PrepareElem;

        PROCEDURE PrepareMenu(E: Elem);
                VAR r: Texts.Reader; ch, oldCh: CHAR; wid, dx, x, y, w, h: INTEGER; p: LONGINT;
        BEGIN
                E.wid := 0; E.n := 1; E.lsp := 0; wid := 0; oldCh := 0X;
                Texts.OpenReader(r, E.menu, 0); Texts.Read(r, ch);
                WHILE ~r.eot DO
                        IF ch = CR THEN E.wid := Max(E.wid, wid); wid := 0; INC(E.n)
                        ELSE
                                E.lsp := Max(E.lsp, r.fnt.height); E.dsc := Min(E.dsc, r.fnt.minY);
                                Display.GetChar(r.fnt.raster, ch, dx, x, y, w, h, p); INC(wid, dx)
                        END;
                        oldCh := ch; Texts.Read(r, ch)
                END;
                IF oldCh = CR THEN DEC(E.n) END;
                IF (oldCh = 0X) OR (E.n = 0) OR (E.wid+wid = 0) THEN DefaultMenu(E); PrepareMenu(E)     (* ensure non_empty text *)
                ELSE E.wid := Max(E.wid, wid); E.def := Min(E.def, E.n-1)
                END
        END PrepareMenu;

(* interactive editing of popup menus *)

        PROCEDURE HandleEdit(F: Display.Frame; VAR M: Display.FrameMsg);
                VAR F1: EditFrame;
        BEGIN
                TextFrames.Handle(F, M);
                WITH F: EditFrame DO
                        IF M IS Oberon.CopyMsg THEN
                                NEW(F1);
                                TextFrames.Open(F1, F.text, F.org);
                                F1.handle := F.handle; F1.elem := F.elem; M(Oberon.CopyMsg).F := F1
                        END
                END
        END HandleEdit;

        PROCEDURE OpenEditor(E: Elem);
                VAR V: Viewers.Viewer; F: EditFrame; x, y, i: INTEGER; name: ARRAY 34 OF CHAR;
        BEGIN
                name[0] := 22X; i := 0; (* 22X = " *)
                WHILE E.name[i] # 0X DO name[i+1] := E.name[i]; INC(i) END;
                name[i+1] := 22X; name[i+2] := 0X;
                Oberon.AllocateUserViewer(Oberon.Mouse.X, x, y);
                NEW(F); F.elem := E; TextFrames.Open(F, CopyText(E.menu), 0); F.handle := HandleEdit;
                V := MenuViewers.New(TextFrames.NewMenu(name,
                                "System.Close  Edit.Search  Edit.Replace All  PopupElems.Toggle  PopupElems.Update "
                        ), F, TextFrames.menuH, x, y)
        END OpenEditor;

(* file input/output *)

        PROCEDURE Load(VAR R: Files.Rider; E: Elem);
                VAR ch: CHAR;
        BEGIN
                Files.ReadString(R, E.name);
                Files.Read(R, ch); E.simple := ch >= 80X; E.def := ORD(ch) MOD 128;
                E.menu := TextFrames.Text(""); Texts.Load(R, E.menu)
        END Load;

        PROCEDURE Store(VAR R: Files.Rider; E: Elem);
                VAR ch: CHAR;
        BEGIN
                Files.WriteString(R, E.name);
                IF E.simple THEN ch := CHR(E.def MOD 128 + 128) ELSE ch := CHR(E.def MOD 128) END;
                Files.Write(R, ch); Texts.Store(R, E.menu)
        END Store;

(* graphics *)

        PROCEDURE Box(col, X, Y, W, H: INTEGER);
        BEGIN
                Display.ReplConst(col, X+1, Y+1, W-2, 1, Display.replace);
                Display.ReplConst(col, X+1, Y+H-2, W-2, 1, Display.replace);
                Display.ReplConst(col, X+1, Y+2, 1, H-4, Display.replace);
                Display.ReplConst(col, X+W-2, Y+2, 1, H-4, Display.replace);
                Display.ReplConst(col, X+4, Y, W-4, 1, Display.replace);
                Display.ReplConst(col, X+W-1, Y+1, 1, H-4, Display.replace);
                Display.ReplConst(Display.black, X+2, Y+2, W-4, H-4, Display.replace)
        END Box;

        PROCEDURE PrintElem(E: Elem; X, Y: INTEGER; fnt: Fonts.Font);
                VAR W, H: INTEGER;
        BEGIN
                W := SHORT((E.W-1) DIV PUnit); H := SHORT(E.H DIV PUnit);
                IF E.simple THEN Printer.String(X, Y, E.name, fnt.name); Printer.ReplPattern(X, Y-2, W, 1, 2)
                ELSE
                        Printer.ReplConst(X+1, Y+1, W-2, 1);
                        Printer.ReplConst(X+1, Y+H-2, W-2, 1);
                        Printer.ReplConst(X+1, Y+2, 1, H-4);
                        Printer.ReplConst(X+W-2, Y+2, 1, H-4);
                        Printer.ReplConst(X+4, Y, W-4, 1);
                        Printer.ReplConst(X+W-1, Y+1, 1, H-4);
                        Printer.String(X + (edw+2) * DUnit DIV PUnit,
                                Y + SHORT(LONG(edh+2-fnt.minY)*DUnit DIV PUnit), E.name, fnt.name
                        )
                END
        END PrintElem;

        PROCEDURE DrawElem(E: Elem; pos: LONGINT; col, X, Y: INTEGER; fnt: Fonts.Font);
                VAR i, oldX, dx, x, y, w, h, mode: INTEGER; p, beg: LONGINT; parc: TextFrames.Parc;
        BEGIN
                IF E.simple THEN
                        TextFrames.ParcBefore(Texts.ElemBase(E), pos, parc, beg);
                        INC(Y, SHORT(parc.dsr DIV TextFrames.Unit));
                        oldX := X; mode := Display.invert
                ELSE
                        Box(col, X, Y, SHORT((E.W-1) DIV DUnit), SHORT(E.H DIV DUnit));
                        INC(X, edw+2); INC(Y, edh+2-fnt.minY); mode := Display.replace
                END;
                i := 0;
                WHILE E.name[i] >= " " DO
                        Display.GetChar(fnt.raster, E.name[i], dx, x, y, w, h, p);
                        Display.CopyPattern(col, p, X+x, Y+y, mode); INC(X, dx); INC(i)
                END;
                IF E.simple & (i > 0) THEN
                        Display.GetChar(fnt.raster, "g", dx, x, y, w, h, p); y := Max(y, -2);
                        Display.ReplPattern(col, Display.grey1, oldX, Y+y, X-oldX, 1, Display.invert)
                END
        END DrawElem;

        PROCEDURE DrawMenu(E: Elem; X, Y, W, H: INTEGER);
                VAR R: Texts.Reader; ch: CHAR; X0, dx, x, y, w, h: INTEGER; p: LONGINT;
        BEGIN
                Box(Display.white, X, Y, W, H);
                X0 := X+mdw+2; X := X0; Y := Y+H-E.lsp-E.dsc-mdh-2;
                Texts.OpenReader(R, E.menu, 0);
                LOOP Texts.Read(R, ch);
                        IF R.eot THEN RETURN
                        ELSIF ch = CR THEN Y := Y-E.lsp; X := X0
                        ELSE
                                Display.GetChar (R.fnt.raster, ch, dx, x, y, w, h, p);
                                Display.CopyPattern(R.col, p, X+x, Y+y, Display.replace); INC(X, dx)
                        END
                END
        END DrawMenu;

(* actions *)

        PROCEDURE Show(E: Elem; X, Y, W, H: INTEGER; VAR cmd: INTEGER; VAR keysum: SET);
                VAR
                        mx, my, top, bot, left, right, newCmd: INTEGER; keys: SET;

                PROCEDURE Flip(c: INTEGER);
                BEGIN IF c >= 0 THEN Display.ReplConst(Display.white, left, top-c*E.lsp-E.lsp, W-6, E.lsp, Display.invert) END
                END Flip;

        BEGIN
                left := X+3; right := X+W-3; bot := Y+mdh+3; top := Y+H-mdh-2;
                Oberon.RemoveMarks(X, Y, W, H); Oberon.FadeCursor(Oberon.Mouse);
                (* save background *)
                Display.CopyBlock(X, Y, W, H, 0, -H, Display.replace);  (* backup into secondary bitmap *)      (* << RC *)
                DrawMenu(E, X, Y, W, H);
                Flip(cmd); keysum := {};
                REPEAT
                        Input.Mouse(keys, mx, my); keysum := keysum+keys; Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, mx, my);
                        IF keysum = cancel THEN cmd := -1
                        ELSIF (mx >= left) & (mx <= right) & (my >= bot) & (my <= top) THEN
                                newCmd := (top-my) DIV E.lsp;
                                IF newCmd # cmd THEN Flip(cmd); Flip(newCmd); cmd := newCmd END
                        ELSE Flip(cmd); cmd := -1
                        END
                UNTIL keys = {};
                Oberon.FadeCursor(Oberon.Mouse);
                (* restore background *)
                Display.CopyBlock(0, -H, W, H, X, Y, Display.replace)   (* restore from secondary bitmap *)     (* << RC *)
        END Show;

        PROCEDURE Popup(E: Elem; X, Y: INTEGER; F: Display.Frame);
                VAR W, H, mx, my, w, j, cmd, res: INTEGER; s: Texts.Scanner; ch: CHAR; keys: SET;
                        par: Oberon.ParList;
        BEGIN
                Input.Mouse(keys, mx, my);
                W := E.wid+2*mdw+4; H := E.n*E.lsp+2*mdh+4;
                w := Display.Width;
                Y := Max(my-H+E.lsp+E.def*E.lsp, 0); cmd := E.def;
                IF X+W > w THEN X := w-W END;
                IF Y+H > Display.Height THEN Y := Display.Height-H END;
                Show(E, X, Y, W, H, cmd, keys);
                IF keys = {MM, MR} THEN OpenEditor(E)
                ELSIF (keys # cancel) & (cmd > -1) THEN
                        E.def := cmd;
                        j := 0; Texts.OpenReader(s, E.menu, 0); Texts.Read(s, ch);
                        WHILE j < cmd DO
                                IF ch = CR THEN INC(j) END;
                                Texts.Read(s, ch)
                        END;
                        Texts.OpenScanner(s, E.menu, Texts.Pos(s)-1); Texts.Scan(s);
                        IF (s.class = Texts.Name) & (s.line = 0) THEN
                                NEW(par); par.frame := F; par.text := E.menu; par.pos := Texts.Pos(s)-1;
                                Oberon.Call(s.s, par, ML IN keys, res); (* left interclick -> unload module *)
(* << RC object model
                                IF res > 0 THEN
                                        Texts.WriteString(Wr, "Call error: "); Texts.WriteString(Wr, Modules.importing);
                                        IF res = 1 THEN Texts.WriteString(Wr, " not found")
                                        ELSIF res = 2 THEN Texts.WriteString(Wr, " not an obj-file")
                                        ELSIF res = 3 THEN
                                                Texts.WriteString(Wr, " imports ");
                                                Texts.WriteString(Wr, Modules.imported); Texts.WriteString(Wr, " with bad key")
                                        ELSIF res = 4 THEN Texts.WriteString(Wr, " corrupted obj file")
                                        ELSIF res = 6 THEN Texts.WriteString(Wr, " has too many imports")
                                        ELSIF res = 7 THEN Texts.WriteString(Wr, " not enough space")
                                        END
                                ELSIF res < 0 THEN
                                        Texts.WriteString(Wr, s.s); Texts.WriteString(Wr, " not found")
                                END;
                                IF res # 0 THEN Texts.WriteLn(Wr); Texts.Append(Oberon.Log, Wr.buf) END
*)
                                IF res > 0 THEN
                                        Texts.WriteString(Wr, "Call error: "); Texts.WriteString(Wr, Modules.importing);
                                        IF res = 1 THEN Texts.WriteString(Wr, " module not found")
                                        ELSIF res = 2 THEN Texts.WriteString(Wr, " not an obj-file")
                                        ELSIF res = 3 THEN
                                                Texts.WriteString(Wr, " imports "); Texts.WriteString(Wr, Modules.objmode); Texts.Write(Wr, " ");
                                                Texts.WriteString(Wr, Modules.imported); Texts.Write(Wr, ".");
                                                Texts.WriteString(Wr, Modules.object); Texts.WriteString(Wr, " with bad fingerprint")
                                        ELSIF res = 4 THEN Texts.WriteString(Wr, " corrupted obj-file")
                                        ELSIF res = 5 THEN Texts.WriteString(Wr, " command not found")
                                        ELSIF res = 7 THEN Texts.WriteString(Wr, " not enough space")
                                        ELSIF res = 10 THEN
                                                Texts.WriteString(Wr, " imports "); Texts.WriteString(Wr, Modules.objmode); Texts.Write(Wr, " ");
                                                Texts.WriteString(Wr, Modules.imported); Texts.Write(Wr, ".");
                                                Texts.WriteString(Wr, Modules.object); Texts.WriteString(Wr, ", not found")
                                        ELSIF res = 11 THEN Texts.WriteString(Wr, " too many open files")
                                        END;
                                        Texts.WriteLn(Wr); Texts.Append(Oberon.Log, Wr.buf)
                                END
                        END
                END
        END Popup;

(* element *)

        PROCEDURE Handle(E: Texts.Elem; VAR msg: Texts.ElemMsg);
                VAR e: Elem;
        BEGIN
                WITH E:Elem DO
                        IF msg IS TextFrames.DisplayMsg THEN
                                WITH msg:TextFrames.DisplayMsg DO
                                        IF msg.prepare THEN PrepareElem(E, msg.fnt, msg.Y0)
                                        ELSE DrawElem(E, msg.pos, msg.col, msg.X0, msg.Y0, msg.fnt)
                                        END
                                END
                        ELSIF msg IS TextPrinter.PrintMsg THEN
                                WITH msg:TextPrinter.PrintMsg DO
                                        IF ~msg.prepare THEN PrintElem(E, msg.X0, msg.Y0, msg.fnt) END
                                END
                        ELSIF msg IS Texts.CopyMsg THEN
                                WITH msg:Texts.CopyMsg DO
                                        NEW(e); Texts.CopyElem(E, e);
                                        e.name := E.name; e.n := E.n; e.def := E.def; e.wid := E.wid; e.lsp := E.lsp; e.dsc := E.dsc; e.simple := E.simple;
                                        e.menu := TextFrames.Text(""); Texts.Save(E.menu, 0, E.menu.len, buf); Texts.Append(e.menu, buf);
                                        msg.e := e
                                END
                        ELSIF msg IS Texts.IdentifyMsg THEN
                                WITH msg:Texts.IdentifyMsg DO
                                        msg.mod := "PopupElems"; msg.proc := "Alloc"
                                END
                        ELSIF msg IS Texts.FileMsg THEN
                                WITH msg:Texts.FileMsg DO
                                        IF msg.id = Texts.load THEN Load(msg.r, E); PrepareMenu(E)
                                        ELSIF msg.id = Texts.store THEN Store(msg.r, E)
                                        END
                                END
                        ELSIF msg IS TextFrames.TrackMsg THEN
                                WITH msg:TextFrames.TrackMsg DO
                                        IF msg.keys = {MM} THEN Popup(E, msg.X0, msg.Y0, msg.frame); msg.keys := {} END
                                END
                        END
                END
        END Handle;

        PROCEDURE Alloc*;
                VAR E: Elem;
        BEGIN NEW(E); E.handle := Handle; Texts.new := E
        END Alloc;

        PROCEDURE insert(simple: BOOLEAN);
                VAR E: Elem; S: Texts.Scanner; ins: TextFrames.InsertElemMsg;
        BEGIN
                NEW(E); Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
                IF (S.class # Texts.Name) & (S.class # Texts.String) THEN S.s := "Popup" END;
                COPY(S.s, E.name); E.simple := simple;
                E.menu := TextFrames.Text(""); DefaultMenu(E);
                PrepareMenu(E); E.handle := Handle; ins.e := E; Viewers.Broadcast(ins)
        END insert;

        PROCEDURE Insert*;
        BEGIN insert(FALSE)
        END Insert;

        PROCEDURE InsertMenu*;
        BEGIN insert(TRUE)
        END InsertMenu;

        PROCEDURE Toggle*;
                VAR text: Texts.Text; E: Elem; pos: LONGINT;
        BEGIN
                IF Oberon.Par.frame = Oberon.Par.vwr.dsc THEN
                        E := Oberon.Par.frame.next(EditFrame).elem; E.simple := ~E.simple;
                        text := Texts.ElemBase(E);
                        IF text # NIL THEN pos := Texts.ElemPos(E); text.notify(text, Texts.replace, pos, pos+1) END;
                END
        END Toggle;

        PROCEDURE Update*;
                VAR F: EditFrame; S: Texts.Scanner; menuText, text: Texts.Text; E: Elem; pos: LONGINT;
        BEGIN
                IF Oberon.Par.frame = Oberon.Par.vwr.dsc THEN
                        F := Oberon.Par.frame.next(EditFrame); E := F.elem; menuText := Oberon.Par.frame(TextFrames.Frame).text;
                        Texts.OpenScanner(S, menuText, 0); Texts.Scan(S);
                        IF (S.class # Texts.Name) & (S.class # Texts.String) THEN S.s := "Popup" END;
                        COPY(S.s, E.name); E.menu := CopyText(F.text);
                        PrepareMenu(E);
                        text := Texts.ElemBase(E);
                        IF text # NIL THEN
                                pos := Texts.ElemPos(E); text.notify(text, Texts.replace, pos, pos+1);
                                Texts.OpenReader(S, menuText, menuText.len-1); Texts.Read(S, S.c);
                                IF S.c = "!" THEN Texts.Delete(menuText, menuText.len-1, menuText.len) END
                        END
                END
        END Update;

BEGIN NEW(buf); Texts.OpenBuf(buf); Texts.OpenWriter(Wr)
END PopupElems.
