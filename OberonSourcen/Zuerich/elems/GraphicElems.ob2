MODULE GraphicElems;    (** CAS **)  (*mod NW 19.3.91/ HM 27.9.93*)
        IMPORT
                Input, Display, Files, Oberon, Viewers, MenuViewers, Texts, TextFrames, Graphics, GraphicFrames, TextPrinter;

        CONST
                Menu = "System.Close  System.Copy  System.Grow  Draw.Delete  GraphicElems.Update ";
                mm = TextFrames.mm; Scale = mm DIV 10;
                unit = TextFrames.Unit; Unit = TextPrinter.Unit;
                MinW = 3*mm; MinH = MinW; GripW = 15*Scale DIV unit; GripH = GripW;
                rightKey = 0; middleKey = 1; leftKey = 2;

        TYPE
                Elem* = POINTER TO ElemDesc;
                ElemDesc* = RECORD(Texts.ElemDesc)
                        SW*, SH*, PW*, PH*: LONGINT;    (**screen, printer box**)
                        graph*: Graphics.Graph;
                        Xg*, Yg*: INTEGER;
                        empty*: BOOLEAN
                END;

                Frame = POINTER TO FrameDesc;
                FrameDesc = RECORD (GraphicFrames.FrameDesc)
                        elem: Elem
                END;


        VAR x0, x1, y0, y1: INTEGER;
                W: Texts.Writer;


        PROCEDURE MarkMenu (F: Frame);
                VAR R: Texts.Reader; V: Viewers.Viewer; T: Texts.Text; ch: CHAR;
        BEGIN V := Viewers.This(F.X, F.Y);
                IF V IS MenuViewers.Viewer THEN
                        T := V.dsc(TextFrames.Frame).text;
                        IF T.len > 0 THEN Texts.OpenReader(R, T, T.len - 1); Texts.Read(R, ch) ELSE ch := 0X END;
                        IF ch # "!" THEN Texts.Write(W, "!"); Texts.Append(T, W.buf) END
                END
        END MarkMenu;

        PROCEDURE Changed (E: Elem);
                VAR T: Texts.Text; pos: LONGINT;
        BEGIN
                T := Texts.ElemBase(E); pos := Texts.ElemPos(E); T.notify(T, Texts.replace, pos-1, pos)
        END Changed;

        PROCEDURE FlipGrip (x0, y0, w, h: INTEGER);
        BEGIN Display.ReplConst(Display.white, x0 + w - GripW, y0, GripW, GripH, Display.invert)
        END FlipGrip;


        (* operations on elements *)

        PROCEDURE SetSize* (E: Elem; w, h: LONGINT);
        BEGIN
                IF w < MinW THEN w := MinW END;
                IF h < MinH THEN h := MinH END;
                E.W := w; E.H := h; E.SW := w; E.SH := h;
                E.PW := 4 * (w DIV unit) * Unit; E.PH := 4 * (h DIV unit) * Unit
        END SetSize;

        PROCEDURE box(obj: Graphics.Object; VAR done: BOOLEAN);
        BEGIN
                IF obj.x < x0 THEN x0 := obj.x END ;
                IF x1 < obj.x + obj.w THEN x1 := obj.x + obj.w END ;
                IF obj.y < y0 THEN y0 := obj.y END ;
                IF y1 < obj.y + obj.h THEN y1 := obj.y + obj.h END
        END box;

        PROCEDURE Open* (E: Elem; G: Graphics.Graph; Xg, Yg: INTEGER; adjust: BOOLEAN);
        BEGIN E.graph := G;
                x0 := MAX(INTEGER); x1 := MIN(INTEGER); y0 := MAX(INTEGER); y1 := MIN(INTEGER);
                Graphics.Enumerate(G, box);
                IF x0 = MAX(INTEGER) THEN E.empty := TRUE; E.Xg := 0; E.Yg := 0; SetSize(E, 0, 0)
                ELSE E.empty := FALSE;
                        IF adjust THEN E.Xg := -x0; E.Yg := -y1; SetSize(E, LONG(x1-x0) * unit, LONG(y1-y0) * unit)
                        ELSE E.Xg := Xg; E.Yg := Yg; SetSize(E, E.W, E.H)
                        END
                END
        END Open;

        PROCEDURE CopyGraph (G: Graphics.Graph): Graphics.Graph;
                VAR g: Graphics.Graph;
        BEGIN
                Graphics.SelectArea(G, MIN(INTEGER), MIN(INTEGER), MAX(INTEGER), MAX(INTEGER));
                NEW(g); Graphics.Copy(G, g, 0, 0); Graphics.Deselect(g);
                RETURN g
        END CopyGraph;

        PROCEDURE Copy* (SE, DE: Elem);
        BEGIN SE.W := SE.SW; SE.H := SE.SH;
                Texts.CopyElem(SE, DE); Open(DE, CopyGraph(SE.graph), SE.Xg, SE.Yg, FALSE)
        END Copy;

        PROCEDURE HandleFrame (f: Display.Frame; VAR msg: Display.FrameMsg);
                VAR F: Frame; F1: Frame;
        BEGIN
                F := f(Frame);
                (*IF msg IS GraphicFrames.UpdateMsg THEN        use when UpdateMsg gets exported*)
                IF msg IS Oberon.InputMsg THEN GraphicFrames.Handle(F, msg);
                        WITH msg: Oberon.InputMsg DO
                                IF (msg.id = Oberon.consume) OR (msg.id = Oberon.track) & (msg.keys # {}) THEN
                                        MarkMenu(F)
                                END
                        END
                ELSIF msg IS Oberon.CopyMsg THEN
                        NEW(F1); GraphicFrames.Open(F1, F.graph, F.Xg, F.Yg, F.col, F.ticked);
                        F1.handle := F.handle; F1.elem := F.elem;
                        msg(Oberon.CopyMsg).F := F1
                ELSE GraphicFrames.Handle(F, msg)
                END
        END HandleFrame;

        PROCEDURE OpenViewer* (E: Elem);
                VAR v: Viewers.Viewer; f: Frame; x, y: INTEGER;
        BEGIN NEW(f); GraphicFrames.Open(f, CopyGraph(E.graph), 0, 0, Display.black, TRUE);
                f.elem := E; f.handle := HandleFrame;
                Oberon.AllocateUserViewer(Oberon.Mouse.X, x, y);
                v := MenuViewers.New(TextFrames.NewMenu("GraphicElems.Graph", Menu), f, TextFrames.menuH, x, y)
        END OpenViewer;

        PROCEDURE Track (E: Elem; keys: SET; x, y, x0, y0: INTEGER);
                VAR keysum: SET; x1, y1, w, h: INTEGER; hit: BOOLEAN;
        BEGIN
                IF middleKey IN keys THEN x1 := x - x0; y1 := y - y0; keysum := keys;
                        w := SHORT(E.W DIV unit); h := SHORT(E.H DIV unit);
                        hit := ~E.empty & (x1 >= w-GripW) & (0 <= y1) & (y1 < GripH);
                        IF hit THEN FlipGrip(x0, y0, w, h) END;
                        REPEAT Input.Mouse(keys, x, y); Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, x, y);
                                keysum := keysum + keys
                        UNTIL keys = {};
                        IF hit THEN FlipGrip(x0, y0, w, h) END;
                        IF keysum = {middleKey} THEN
                                IF hit THEN INC(w, (x - x0) - x1); DEC(h, (y - y0) - y1);
                                        SetSize(E, LONG(w) * unit, LONG(h) * unit); Changed(E)
                                ELSE OpenViewer(E)
                                END
                        END
                END
        END Track;


        (* handle elements *)

        PROCEDURE Handle* (e: Texts.Elem; VAR msg: Texts.ElemMsg);
                VAR E, E1: Elem; x, y, w, h: INTEGER; f: GraphicFrames.Frame; g: Graphics.Graph; version: CHAR;
        BEGIN E := e(Elem);
                IF msg IS TextFrames.DisplayMsg THEN
                        WITH msg: TextFrames.DisplayMsg DO
                                IF msg.prepare THEN E.W := E.SW; E.H := E.SH
                                ELSE
                                        x := msg.X0; y := msg.Y0; w := SHORT(E.W DIV unit); h := SHORT(E.H DIV unit);
                                        IF E.empty THEN
                                                Display.ReplPattern(Display.white, Display.grey1, x, y, w, h, Display.replace)
                                        ELSE NEW(f); GraphicFrames.Open(f, E.graph, E.Xg, E.Yg, Display.black, FALSE);
                                                f.X := x; f.Y := y; f.W := w; f.H := h;
                                                GraphicFrames.Restore(f); FlipGrip(x, y, w, h);
                                                msg.elemFrame := f
                                        END
                                END
                        END
                ELSIF msg IS TextPrinter.PrintMsg THEN
                        WITH msg: TextPrinter.PrintMsg DO
                                IF msg.prepare THEN E.W := E.PW; E.H := E.PH
                                ELSE
                                        Graphics.Print(E.graph, E.Xg*4 + msg.X0, E.Yg*4 + msg.Y0 + SHORT(E.PH DIV Unit));
                                        E.W := E.SW; E.H := E.SH
                                END
                        END
                ELSIF msg IS Texts.IdentifyMsg THEN
                        WITH msg: Texts.IdentifyMsg DO msg.mod := "GraphicElems"; msg.proc := "Alloc" END
                ELSIF msg IS Texts.FileMsg THEN
                        WITH msg: Texts.FileMsg DO
                                IF msg.id = Texts.load THEN
                                        Files.Read(msg.r, version); NEW(g); Graphics.Load(g, msg.r);
                                        IF version = 1X THEN Open(E, g, 0, 0, TRUE)
                                        ELSE Files.ReadInt(msg.r, E.Xg); Files.ReadInt(msg.r, E.Yg); Open(E, g, E.Xg, E.Yg, FALSE)
                                        END
                                ELSIF msg.id = Texts.store THEN
                                        E.W := E.SW; E.H := E.SH;
                                        Files.Write(msg.r, 2X); Graphics.Store(E.graph, msg.r);
                                        Files.WriteInt(msg.r, E.Xg); Files.WriteInt(msg.r, E.Yg)
                                END
                        END
                ELSIF msg IS Texts.CopyMsg THEN NEW(E1); Copy(E, E1); msg(Texts.CopyMsg).e := E1
                ELSIF msg IS TextFrames.TrackMsg THEN
                        WITH msg: TextFrames.TrackMsg DO Track(E, msg.keys, msg.X, msg.Y, msg.X0, msg.Y0) END
                ELSIF msg IS TextFrames.FocusMsg THEN
                        WITH msg: TextFrames.FocusMsg DO
                                f := msg.elemFrame(GraphicFrames.Frame);
                                f.ticked := msg.focus; GraphicFrames.Restore(f);
                                IF ~msg.focus THEN FlipGrip(f.X, f.Y, f.W, f.H) END
                        END
                END
        END Handle;

        PROCEDURE Alloc*;
                VAR e: Elem;
        BEGIN NEW(e); e.handle := Handle; Texts.new := e
        END Alloc;


        (* commands *)

        PROCEDURE Insert*;      (** ["^" | "*" | name] **)
                VAR S: Texts.Scanner; text: Texts.Text;
                        beg, end, time: LONGINT;
                        V: Viewers.Viewer;
                        G, g: Graphics.Graph;
                        e: Elem;
                        msg: TextFrames.InsertElemMsg;
        BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
                IF (S.class = Texts.Char) & (S.c = "^") THEN
                        Oberon.GetSelection(text, beg, end, time);
                        IF time >= 0 THEN Texts.OpenScanner(S, text, beg); Texts.Scan(S) END
                END;
                NEW(g);
                IF (S.class = Texts.Char) & (S.c = "*") THEN
                        V := Oberon.MarkedViewer();
                        IF (V.dsc # NIL) & (V.dsc.next # NIL) & (V.dsc.next IS GraphicFrames.Frame) THEN
                                G := V.dsc.next(GraphicFrames.Frame).graph;
                                IF G.sel = NIL THEN g := CopyGraph(G) ELSE Graphics.Copy(G, g, 0, 0) END
                        END
                ELSIF S.class = Texts.Name THEN Graphics.Open(g, S.s)
                END;
                NEW(e); e.handle := Handle; Open(e, g, 0, 0, TRUE);
                msg.e := e; Oberon.FocusViewer.handle(Oberon.FocusViewer, msg)
        END Insert;

        PROCEDURE Update*;
                VAR V: Viewers.Viewer; F: Frame; R: Texts.Reader; T: Texts.Text; ch: CHAR;
        BEGIN V := Oberon.Par.vwr; F := V.dsc.next(Frame); T := V.dsc(TextFrames.Frame).text;
                GraphicFrames.Deselect(F); Open(F.elem, CopyGraph(F.graph), 0, 0, TRUE); Changed(F.elem);
                Texts.OpenReader(R, T, T.len - 1); Texts.Read(R, ch);
                IF ch = "!" THEN Texts.Delete(T, T.len - 1, T.len) END
        END Update;

BEGIN Texts.OpenWriter(W)
END GraphicElems.
