MODULE IconElems; (* gri 18.3.91 / 28.9.93 *)

        IMPORT Input, Display, Oberon, Math, Viewers, Files, Printer, Texts, TextFrames, TextPrinter;

(*<<<<<<<<<<<<<<<
        CONST
                IStag = 753; (* icon stretch tag *)
                left = 2; middle = 1; right = 0; (* mouse keys *)
                HSide = MAX(SET)+1; Side = 2*HSide; PDot = 3; (* dimensions *)
                MaxN = 64; Sleep = 100; (* in ms *)

        TYPE
                Icon = ARRAY 2 OF RECORD
                        addr: LONGINT;
                        image: ARRAY Side+1 OF SET
                END;

                Elem = POINTER TO ElemDesc;
                ElemDesc = RECORD (Texts.ElemDesc)
                END;

                Frame = POINTER TO RECORD(Display.FrameDesc) col: SHORTINT END;
                NotifyMsg = RECORD(TextFrames.NotifyMsg) END;

        VAR
                N: LONGINT; (* no. of figurs *)
                Task: Oberon.Task;
                State: LONGINT; (* actual figure state *)
                Fig: ARRAY MaxN OF Icon;


        PROCEDURE EmptyFig;
                VAR j: INTEGER;
        BEGIN N := 1; j := 1;
                WHILE j <= Side DO
                        Fig[0, 0].image[j] := {};
                        Fig[0, 1].image[j] := {};
                        INC(j)
                END;
                Fig[0, 0].addr := Display.NewPattern(Fig[0, 0].image, HSide, Side);
                Fig[0, 1].addr := Display.NewPattern(Fig[0, 1].image, HSide, Side)
        END EmptyFig;

        PROCEDURE LoadFig (file: ARRAY OF CHAR); (* read portable file format *)
                VAR F: Files.File; R: Files.Rider; i, j: INTEGER;

                PROCEDURE ReadInt (VAR x: LONGINT);
                        VAR n: LONGINT; i: SHORTINT; ch: CHAR;
                BEGIN i := 0; n := 0; Files.Read(R, ch);
                        WHILE ORD(ch) >= 128 DO INC(n, ASH(ORD(ch) - 128, i)); INC(i, 7); Files.Read(R, ch) END;
                        x := n + ASH(ORD(ch) MOD 64 - ORD(ch) DIV 64 * 64, i)
                END ReadInt;

                PROCEDURE ReadSet (VAR s: SET);
                        VAR x: LONGINT; i: INTEGER;
                BEGIN ReadInt(x); s := {}; i := 0;
                        WHILE i < 32 DO
                                IF ODD(x) THEN INCL(s, i) END;
                                x := x DIV 2; INC(i)
                        END
                END ReadSet;

        BEGIN F := Files.Old(file);
                IF F = NIL THEN EmptyFig; RETURN END;
                Files.Set(R, F, 0); ReadInt(N);
                IF N # IStag THEN EmptyFig; RETURN END;
                ReadInt(N); i := 0;
                WHILE i <= N DO j := 1;
                        WHILE j < Side DO
                                ReadSet(Fig[i, 0].image[j]);
                                ReadSet(Fig[i, 1].image[j]);
                                INC(j)
                        END;
                        Fig[i, 0].addr := Display.NewPattern(Fig[i, 0].image, HSide, Side);
                        Fig[i, 1].addr := Display.NewPattern(Fig[i, 1].image, HSide, Side);
                        INC(i)
                END
        END LoadFig;

        PROCEDURE Draw (VAR icn: Icon; x, y, color: INTEGER);
        BEGIN
                Display.CopyPattern(color, icn[0].addr, x, y, Display.invert);
                Display.CopyPattern(color, icn[1].addr, x + HSide, y, Display.invert)
        END Draw;

        PROCEDURE Print (VAR icn: Icon; x, y: INTEGER);
                VAR i: INTEGER;

                PROCEDURE PrintLine (x, y: INTEGER; line: SET);
                        VAR i, i0: INTEGER;
                BEGIN i := 0;
                        WHILE i < HSide DO
                                IF i IN line THEN i0 := i; INC(i);
                                        WHILE (i < HSide) & (i IN line) DO INC(i) END;
                                        Printer.ReplConst(x + i0*PDot, y, (i-i0)*PDot, PDot)
                                END;
                                INC(i)
                        END
                END PrintLine;

        BEGIN i := 0;
                WHILE i < Side DO
                        PrintLine(x, y + i*PDot, icn[0].image[i+1]);
                        PrintLine(x + HSide*PDot, y + i*PDot, icn[1].image[i+1]);
                        INC(i)
                END
        END Print;
>>>>>>>>>>>>>>>*)

        PROCEDURE HotSpot (X, Y, W, H, X0, Y0: INTEGER);
                CONST d = 6;
                VAR dx, dy: LONGINT; r: INTEGER;

                PROCEDURE Block (x, y, w, h, col, mode: INTEGER);
                BEGIN
                        IF x < X THEN DEC(w, X-x); x := X END;
                        IF x+w > X+W THEN w := X+W-x END;
                        IF w <= 0 THEN RETURN END;
                        IF y < Y THEN DEC(h, Y-y); y := Y END;
                        IF y+h > Y+H THEN h := Y+H-y END;
                        IF h <= 0 THEN RETURN END;
                        Display.ReplConst(col, x, y, w, h, mode)
                END Block;

                PROCEDURE Dot4 (x1, x2, y1, y2, col, mode: INTEGER);
                        CONST r = (d+1) DIV 2;
                BEGIN
                        Block(x1-r, y1-r, 2*r+1, 2*r+1, col, mode);
                        Block(x1-r, y2-r, 2*r+1, 2*r+1, col, mode);
                        Block(x2-r, y1-r, 2*r+1, 2*r+1, col, mode);
                        Block(x2-r, y2-r, 2*r+1, 2*r+1, col, mode)
                END Dot4;

                PROCEDURE Circle (X, Y, R, col, mode: INTEGER);
                        VAR x, y, dx, dy, d: INTEGER;
                BEGIN
                        x := R; y := 0; dx := 8*(x-1); dy := 8*y+4; d := 1 - 4*R;
                        WHILE x > y DO
                                Dot4(X-x-1, X+x, Y-y-1, Y+y, col, mode);
                                Dot4(X-y-1, X+y, Y-x-1, Y+x, col, mode);
                                INC(d, dy); INC(dy, 8); INC(y);
                                IF d >= 0 THEN DEC(d, dx); DEC(dx, 8); DEC(x) END
                        END;
                        IF x = y THEN Dot4(X-x-1, X+x, Y-y-1, Y+y, col, mode) END
                END Circle;

        BEGIN
(*<<<<<<<<<<<<<<<
                IF X0-X > X+W-X0 THEN dx := X0-X ELSE dx := X+W-X0 END;
                IF Y0-Y > Y+H-Y0 THEN dy := Y0-Y ELSE dy := Y+H-Y0 END;
>>>>>>>>>>>>>>>*)
                r := SHORT(ENTIER(Math.sqrt(dx*dx + dy*dy)));
(*<<<<<<<<<<<<<<<
                WHILE r > 0 DO Circle(X0, Y0, r, Display.black, Display.replace); DEC(r, d) END
>>>>>>>>>>>>>>>*)
        END HotSpot;

(*<<<<<<<<<<<<<<<
        PROCEDURE SaveScreen (x0, y0: INTEGER; keys: SET; col: SHORTINT);
                VAR sum: SET; x, y, w, h: INTEGER; msg: Viewers.ViewerMsg; wakeUp: LONGINT;
        BEGIN
                Display.ReplConst(Display.white, x0, y0, Side, Side, Display.invert); sum := keys;
                REPEAT
                        Input.Mouse(keys, x, y); sum := sum+keys;
                        Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, x, y)
                UNTIL keys = {};
                Display.ReplConst(Display.white, x0, y0, Side, Side, Display.invert);
                IF sum # {left, middle, right} THEN
                        x := Oberon.UserTrack(x0); w := Oberon.DisplayWidth(x0);
                        y := Display.Bottom; h := Oberon.DisplayHeight(x0);
                        Oberon.RemoveMarks(x, y, w, h);
                        msg.id := Viewers.suspend; Viewers.Broadcast(msg);
                        HotSpot(x, y, w, h, x0 + Side DIV 2, y0 + Side DIV 2);
                        REPEAT
                                Display.ReplConst(Display.black, x0, y0, Side, Side, Display.replace);
                                INC(State); INC(x0, 10);
                                IF x0+Side > x+w THEN x0 := x; INC(y0, Side);
                                        IF y0+Side > y+h THEN y0 := y END
                                END;
                                Draw(Fig[State MOD N], x0, y0, col);
                                wakeUp := Oberon.Time() + Sleep*Input.TimeUnit DIV 1000;
                                REPEAT UNTIL Oberon.Time() >= wakeUp
                        UNTIL Input.Available() > 0;
                        msg.id := Viewers.restore; Viewers.Broadcast(msg)
                END
        END SaveScreen;

        PROCEDURE HandleFrame (F: Display.Frame; VAR M: Display.FrameMsg);
                VAR r: INTEGER;
        BEGIN
                WITH F: Frame DO
                        IF M IS NotifyMsg THEN
                                WITH M: NotifyMsg DO
                                        Draw(Fig[(State-1) MOD N], F.X, F.Y, F.col);
                                        Draw(Fig[State MOD N], F.X, F.Y, F.col)
                                END
                        ELSIF M IS Oberon.InputMsg THEN
                                WITH M: Oberon.InputMsg DO
                                        IF M.id = Oberon.track THEN Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, M.X, M.Y) END
                                END
                        END
                END
        END HandleFrame;

        PROCEDURE Handle (E: Texts.Elem; VAR msg: Texts.ElemMsg);
                VAR e: Elem; ch: CHAR; F: Frame;
        BEGIN
                WITH E: Elem DO
                        IF msg IS TextFrames.DisplayMsg THEN
                                WITH msg: TextFrames.DisplayMsg DO
                                        IF ~msg.prepare THEN
                                                Draw(Fig[State MOD N], msg.X0, msg.Y0, msg.col);
                                                NEW(F); F.handle := HandleFrame; F.X := msg.X0; F.Y := msg.Y0; F.W := 64; F.H := 64; F.col := msg.col;
                                                msg.elemFrame := F
                                        END
                                END
                        ELSIF msg IS TextPrinter.PrintMsg THEN
                                WITH msg: TextPrinter.PrintMsg DO
                                        IF msg.prepare THEN
                                                E.W := Side * TextPrinter.Unit * PDot; E.H := E.W
                                        ELSE
                                                Print(Fig[State MOD N], msg.X0, msg.Y0);
                                                E.W := Side * TextFrames.Unit; E.H := E.W
                                        END
                                END
                        ELSIF msg IS Texts.CopyMsg THEN
                                NEW(e); Texts.CopyElem(E, e); msg(Texts.CopyMsg).e := e
                        ELSIF msg IS TextFrames.TrackMsg THEN
                                WITH msg: TextFrames.TrackMsg DO
                                        IF middle IN msg.keys THEN SaveScreen(msg.X0, msg.Y0, msg.keys, msg.col) END
                                END
                        ELSIF msg IS Texts.IdentifyMsg THEN
                                WITH msg: Texts.IdentifyMsg DO
                                        msg.mod := "IconElems"; msg.proc := "New"
                                END
                        ELSIF msg IS Texts.FileMsg THEN
                                WITH msg: Texts.FileMsg DO
                                        IF msg.id = Texts.load THEN Files.Read(msg.r, ch) (* ignore in this version *)
                                        ELSIF msg.id = Texts.store THEN Files.Write(msg.r, 0X); (* version tag: used for future extensions *)
                                        END
                                END
                        END
                END
        END Handle;

        PROCEDURE Step;
                VAR msg: NotifyMsg;
        BEGIN
                INC(State); Viewers.Broadcast(msg);
                Oberon.CurTask.time := Oberon.Time() + Sleep*Input.TimeUnit DIV 1000
        END Step;

        PROCEDURE New*;
                VAR E: Elem;
        BEGIN NEW(E); E.handle := Handle; Texts.new := E; Oberon.Install(Task)
        END New;

        PROCEDURE Insert*;
                VAR E: Elem; m: TextFrames.InsertElemMsg;
        BEGIN NEW(E); E.W := Side * TextFrames.Unit; E.H := E.W; E.handle := Handle; m.e := E;
                Oberon.FocusViewer.handle(Oberon.FocusViewer, m);
                Oberon.Install(Task)
        END Insert;

        PROCEDURE Stop*;
        BEGIN Oberon.Remove(Task);
        END Stop;

BEGIN
        LoadFig("IconElems.Icon"); State := 0;
        NEW(Task); Task.safe := FALSE; Task.time := 0; Task.handle := Step; Oberon.Install(Task)
>>>>>>>>>>>>>>>*)
END IconElems.
