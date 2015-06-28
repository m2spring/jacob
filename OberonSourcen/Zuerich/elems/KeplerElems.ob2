MODULE KeplerElems;     (* J. Templ, 27.09.93 *)

        (* shows how to extend the Write editor by an additional element class *)

        IMPORT
                KeplerGraphs, KeplerFrames, KeplerPorts, TextFrames, Texts, TextPrinter,
                Files, Oberon, Input, Viewers, MenuViewers, Display;


        CONST
                unit = TextFrames.Unit; (* screen pixel size *)
                Unit = TextPrinter.Unit;        (* printer pixel size *)

                MM = 1; (* mouse middle *)
                Menu = "System.Close  System.Copy  System.Grow  KeplerElems.Update";


        TYPE
                Elem = POINTER TO ElemDesc;
                ElemDesc = RECORD
                        (Texts.ElemDesc)
                        G: KeplerGraphs.Graph;
                        dx, dy, w, h, grid: INTEGER;
                END;

                Frame = POINTER TO FrameDesc;
                FrameDesc = RECORD
                        (KeplerFrames.FrameDesc)
                        E: Elem;
                END ;

        PROCEDURE Draw(E: Elem; X, Y: INTEGER; VAR DF: Display.Frame);
                VAR F: KeplerFrames.Frame;
        BEGIN F := KeplerFrames.New(E.G); DF := F;
                F.X := X; F.Y := Y; F.W := SHORT(E.W DIV unit); F.H := SHORT(E.H DIV unit);
                F.x0 := - E.dx; F.y0 := - (F.H * 4 + E.dy); F.scale := 4;
                IF E.G.cons # NIL THEN E.G.Draw(F) ELSE F.DrawRect(0, 0, 99, 99, Display.white, Display.replace) END
        END Draw;

        PROCEDURE Print(E: Elem; X, Y: INTEGER);
                VAR P: KeplerPorts.PrinterPort;
        BEGIN NEW(P);
                P.X := X; P.Y := Y; P.W := SHORT(E.W DIV Unit); P.H := SHORT(E.H DIV Unit);
                P.x0 := - E.dx; P.y0 := - (P.H + E.dy); P.scale := 1;
                E.G.Draw(P)
        END Print;

        PROCEDURE Copy(G: KeplerGraphs.Graph): KeplerGraphs.Graph;
                VAR buf: Files.File; R: Files.Rider; o: KeplerGraphs.Object;
        BEGIN buf := Files.New("");
                Files.Set(R, buf, 0); KeplerGraphs.Reset;
                KeplerGraphs.WriteObj(R, G);
                Files.Set(R, buf, 0); KeplerGraphs.Reset;
                KeplerGraphs.ReadObj(R, o);
                RETURN o(KeplerGraphs.Graph)
        END Copy;

        PROCEDURE (*<*>*)FrameHandle (F: Display.Frame; VAR M: Display.FrameMsg);
                VAR F1: Frame;
        BEGIN
                WITH F: Frame DO
                        WITH M: Oberon.CopyMsg DO
                                NEW(F1); M.F := F1; F1^ := F^
                        ELSE KeplerFrames.Handle(F, M)
                        END
                END
        END FrameHandle;

        PROCEDURE Edit(E: Elem);
                VAR keysum, keys: SET; X, Y: INTEGER; F: Frame; V: Viewers.Viewer;
        BEGIN
                keysum := {MM};
                REPEAT Input.Mouse(keys, X, Y); keysum := keysum + keys;
                        Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, X, Y)
                UNTIL keys = {};
                IF keysum = {MM} THEN
                        Oberon.AllocateUserViewer(Oberon.Mouse.X, X, Y);
                        NEW(F); F.G := Copy(E.G); (*copy out*)
                        F.G.notify := KeplerFrames.NotifyDisplay;
                        F.handle := FrameHandle;
                        F.grid := E.grid; F.scale := 4; F.x0 := 0; F.y0 := 0; F.E := E;
                        V := MenuViewers.New(TextFrames.NewMenu("KeplerElem", Menu), F, TextFrames.menuH, X, Y)
                END
        END Edit;

        PROCEDURE Load(VAR R: Files.Rider; E: Elem);
                VAR o: KeplerGraphs.Object;
                        err: ARRAY 24 OF CHAR; version: INTEGER;
        BEGIN
                KeplerGraphs.Reset; KeplerGraphs.ReadObj(R, o); E.G := o(KeplerGraphs.Graph);
                Files.ReadInt(R, E.dx); Files.ReadInt(R, E.dy);
                Files.ReadInt(R, E.w); Files.ReadInt(R, version);
                (*upward compatible version encoding*)
                IF version >= 0 THEN E.h := version;
                ELSIF version = -1 THEN Files.ReadInt(R, E.h); Files.ReadInt(R, E.grid)
                (* ELSIF .. future versions *)
                ELSE err := "version not supported"; HALT(99)
                END
        END Load;

        PROCEDURE Store(VAR R: Files.Rider; E: Elem);
        BEGIN
                KeplerGraphs.Reset; KeplerGraphs.WriteObj(R, E.G);
                Files.WriteInt(R, E.dx); Files.WriteInt(R, E.dy);
                Files.WriteInt(R, E.w); Files.WriteInt(R, (*version*) -1);
                Files.WriteInt(R, E.h); Files.WriteInt(R, E.grid);
        END Store;

        PROCEDURE Focus(E: Elem; focus: BOOLEAN; F: KeplerFrames.Frame);
        BEGIN
                IF focus THEN F.grid := E.grid ELSE F.grid := 0 END ;
                F.Restore(F.X, F.Y, F.W, F.H)
        END Focus;

        PROCEDURE(*<*>*) ElemHandle (E: Texts.Elem; VAR M: Texts.ElemMsg);
                VAR e: Elem;
        BEGIN
                WITH E: Elem DO
                        WITH
                                 M: TextFrames.DisplayMsg DO
                                        IF M.prepare THEN E.W := E.w * LONG(unit) DIV 4; E.H := E.h * LONG(unit) DIV 4
                                        ELSE Draw(E, M.X0, M.Y0, M.elemFrame)
                                        END
                                | M: TextPrinter.PrintMsg DO
                                        IF M.prepare THEN E.W := E.w * LONG(Unit); E.H := E.h * LONG(Unit)
                                        ELSE Print(E, M.X0, M.Y0)
                                        END
                                | M: Texts.IdentifyMsg DO
                                        M.mod := "KeplerElems"; M.proc := "Alloc"
                                | M: Texts.FileMsg DO
                                        IF M.id = Texts.load THEN Load(M.r, E);
                                        ELSIF M.id = Texts.store THEN Store(M.r, E)
                                        END
                                | M: Texts.CopyMsg DO
                                        NEW(e); Texts.CopyElem(E, e); M.e := e;
                                        e.dx := E.dx; e.dy := E.dy; e.w := E.w; e.h := E.h; e.grid := E.grid;
                                        e.G := Copy(E.G)
                                | M: TextFrames.TrackMsg DO
                                        IF M.keys = {MM} THEN Edit(E) END
                                | M: TextFrames.FocusMsg DO
                                        Focus(E, M.focus, M.elemFrame(KeplerFrames.Frame));
                        ELSE
                        END
                END
        END ElemHandle;

        PROCEDURE Alloc*;
                VAR e: Elem;
        BEGIN NEW(e); e.handle := ElemHandle; Texts.new := e
        END Alloc;

        PROCEDURE Insert*;
                VAR e: Elem; M: TextFrames.InsertElemMsg;
        BEGIN
                NEW(e); e.w := 100; e.h := 100; e.grid := 5; e.handle := ElemHandle;
                NEW(e.G); M.e := e; Viewers.Broadcast(M)
        END Insert;

        PROCEDURE Update*;
                VAR
                        G: KeplerGraphs.Graph;
                        F: Frame; E: Elem; B: KeplerPorts.BalloonPort;
                        R: Texts.Reader; T: Texts.Text;
        BEGIN
                IF Oberon.Par.vwr.dsc.next IS Frame THEN
                        F := Oberon.Par.vwr.dsc.next(Frame);
                        G := F.G; E := F.E;
                        G.All(0); (*deselect*);
                        NEW(B); KeplerPorts.InitBalloon(B);
                        G.Draw(B); (*get bounding box*)
                        E.dx := B.X; E.dy := B.Y; E.w := B.W + 4; E.h := B.H + 4;
                        E.G := Copy(G); (*copy in*)
                        E.grid := F.grid;
                        T := Texts.ElemBase(E);
                        IF E.G.cons = NIL THEN E.dx := 0; E.dy := 0; E.w := 100; E.h := 100 END ;
                        IF T # NIL THEN Texts.OpenReader(R, T, 0);
                                REPEAT Texts.ReadElem(R) UNTIL R.elem = E;
                                T.notify(T, Texts.replace, Texts.Pos(R)-1, Texts.Pos(R))
                        END
                END
        END Update;

END KeplerElems.
