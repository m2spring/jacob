MODULE ClockElems; (* gri 18.3.91 *)    (* mod CAS 8-Jul-91 *)

        IMPORT Texts, TextFrames, TextPrinter, Math, Oberon, Display, Printer, Viewers, Files, Input;

        CONST
                Rmin = 12; Rdef = 32; (* clock radi in pixels *)

        TYPE
                Time = RECORD sec, min, hour: INTEGER; timeStamp: LONGINT END;
                Frame = POINTER TO RECORD(Display.FrameDesc) col: SHORTINT END;
                NotifyMsg = RECORD(Display.FrameMsg) END;

        VAR
                sin, cos: ARRAY 60 OF REAL;
                wakeUp: LONGINT; (* overflow in 82.8 days *)
                old, new: Time;
                Task: Oberon.Task;
                Line: PROCEDURE(x1, y1, x2, y2, color, mode: INTEGER); (* current output procedure *)
                Circle: PROCEDURE(x0, y0, r, color, mode: INTEGER); (* current output procedure *)


(* initialization *)

        PROCEDURE Init;
                VAR i: INTEGER;
        BEGIN i := 0;
                WHILE i < 60 DO
                        sin[i] := Math.sin(2 * Math.pi / 60 * i);
                        cos[i] := Math.cos(2 * Math.pi / 60 * i);
                        INC(i)
                END
        END Init;

        PROCEDURE GetTime(VAR time: Time);
                VAR t, d: LONGINT;
        BEGIN
                Oberon.GetClock(t, d);
                time.sec := SHORT(t MOD 64);
                time.min := SHORT(t DIV 64 MOD 64);
                time.hour := SHORT(t DIV (64*64))*5 + time.min DIV 12;
                time.timeStamp := t
        END GetTime;


(* graphics *)

        PROCEDURE SCircle(x0, y0, r, color, mode: INTEGER);
                VAR x, y, dx, dy, d: INTEGER;

                PROCEDURE Dot4(x1, x2, y1, y2, color, mode: INTEGER);
                BEGIN
                        Display.Dot(color, x1, y1, mode);
                        Display.Dot(color, x1, y2, mode);
                        Display.Dot(color, x2, y1, mode);
                        Display.Dot(color, x2, y2, mode)
                END Dot4;

        BEGIN
                x := r; y := 0; dx := 8*(x-1); dy := 8*y+4; d := 1-4*r;
                WHILE x > y DO
                        Dot4(x0-x, x0+x, y0-y, y0+y, color, mode);
                        Dot4(x0-y, x0+y, y0-x, y0+x, color, mode);
                        INC(d, dy); INC(dy, 8); INC(y);
                        IF d >= 0 THEN DEC(d, dx); DEC(dx, 8); DEC(x) END
                END;
                IF x = y THEN Dot4(x0-x, x0+x, y0-y, y0+y, color, mode) END
        END SCircle;

        PROCEDURE SLine(x1, y1, x2, y2, color, mode: INTEGER);
                VAR x, y, dx, dy, d, inc: INTEGER;
        BEGIN
                IF (y2-y1) < (x1-x2) THEN x := x1; x1 := x2; x2 := x; y := y1; y1 := y2; y2 := y END;
                dx := 2*(x2-x1);
                dy := 2*(y2-y1);
                x := x1; y := y1; inc := 1;
                IF dy > dx THEN
                        d := dy DIV 2;
                        IF dx < 0 THEN inc := -1; dx := -dx END;
                        WHILE y <= y2 DO
                                Display.Dot(color, x, y, mode);
                                INC(y); DEC(d, dx);
                                IF d < 0 THEN INC(d, dy); INC(x, inc) END
                        END
                ELSE
                        d := dx DIV 2;
                        IF dy < 0 THEN inc := -1; dy := -dy END;
                        WHILE x <= x2 DO
                                Display.Dot(color, x, y, mode);
                                INC(x); DEC(d, dy);
                                IF d < 0 THEN INC(d, dx); INC(y, inc) END
                        END
                END
        END SLine;

        PROCEDURE PCircle(x0, y0, r, color, mode: INTEGER);
        BEGIN Printer.Circle(x0, y0, r)
        END PCircle;

        PROCEDURE PLine(x1, y1, x2, y2, color, mode: INTEGER);
        BEGIN Printer.Line(x1, y1, x2, y2)
        END PLine;


(* view update *)

        PROCEDURE Line2(ang: INTEGER; x0, y0, r1, r2, color: INTEGER);
                VAR x1, y1, x2, y2: INTEGER;
        BEGIN
                ang := (15-ang) MOD 60;
                x1 := SHORT(ENTIER(r1*cos[ang] + 0.5));
                y1 := SHORT(ENTIER(r1*sin[ang] + 0.5));
                x2 := SHORT(ENTIER(r2*cos[ang] + 0.5));
                y2 := SHORT(ENTIER(r2*sin[ang] + 0.5));
                Line(x0+x1, y0+y1, x0+x2, y0+y2, color, Display.invert)
        END Line2;

        PROCEDURE Draw(VAR time: Time; x0, y0, r, color: INTEGER);
                VAR rh, rm, rs, i: INTEGER;
        BEGIN
                IF r >= Rmin THEN
                        rh := 7*r DIV 11; rm := 9*r DIV 11; rs := 10*r DIV 11; i := 0;
                        WHILE i < 60 DO Line2(i, x0, y0, rm, r, color); INC(i, 5) END;
                        Line2(time.sec, x0, y0, rm-r, rs, color);
                        Line2(time.min, x0, y0, 0, rm, color);
                        Line2(time.hour, x0, y0, 0, rh, color);
                        Circle(x0, y0, 2, color, Display.replace)
                END;
                Circle(x0, y0, r, color, Display.replace)
        END Draw;

        PROCEDURE Update(VAR old, new: Time; x0, y0, r, color: INTEGER);
                VAR rh, rm, rs: INTEGER;
        BEGIN
                IF r >= Rmin THEN
                        rh := 7*r DIV 11; rm := 9*r DIV 11; rs := 10*r DIV 11;
                        IF old.sec # new.sec THEN Line2(old.sec, x0, y0, rm-r, rs, color); Line2(new.sec, x0, y0, rm-r, rs, color) END;
                        IF old.min # new.min THEN Line2(old.min, x0, y0, 0, rm, color); Line2(new.min, x0, y0, 0, rm, color) END;
                        IF old.hour # new.hour THEN Line2(old.hour, x0, y0, 0, rh, color); Line2(new.hour, x0, y0, 0, rh, color) END;
                END
        END Update;


(* methods *)

        PROCEDURE HandleFrame(F: Display.Frame; VAR M: Display.FrameMsg);
                VAR r: INTEGER;
        BEGIN
                IF M IS NotifyMsg THEN Line := SLine; Circle := SCircle; r := F.W DIV 2;
                        Update(old, new, F.X+r, F.Y+r, r, F(Frame).col)
                ELSIF M IS Oberon.InputMsg THEN
                        WITH M: Oberon.InputMsg DO
                                IF M.id = Oberon.track THEN Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, M.X, M.Y) END
                        END
                END
        END HandleFrame;

        PROCEDURE HandleElem(E: Texts.Elem; VAR msg: Texts.ElemMsg);
                VAR e: Texts.Elem; f: Frame; r: INTEGER; ch: CHAR;
        BEGIN
                IF msg IS TextFrames.DisplayMsg THEN
                        WITH msg: TextFrames.DisplayMsg DO
                                IF ~msg.prepare THEN
                                        Line := SLine; Circle := SCircle; r := SHORT((E.W DIV TextFrames.Unit - 1) DIV 2);
                                        Draw(new, msg.X0+r, msg.Y0+r, r, msg.col);
                                        NEW(f); f.X := msg.X0; f.Y := msg.Y0; f.W := 2*r + 1; f.H := f.W;
                                        f.handle := HandleFrame; f.col := msg.col;
                                        msg.elemFrame := f
                                END
                        END
                ELSIF msg IS TextPrinter.PrintMsg THEN
                        WITH msg: TextPrinter.PrintMsg DO
                                IF ~msg.prepare THEN
                                        Line := PLine; Circle := PCircle; r := SHORT((E.W DIV TextPrinter.Unit - 1) DIV 2);
                                        Draw(new, msg.X0+r, msg.Y0+r, r, msg.col)
                                END
                        END
                ELSIF msg IS Texts.CopyMsg THEN
                        NEW(e); Texts.CopyElem(E, e); msg(Texts.CopyMsg).e := e
                ELSIF msg IS Texts.IdentifyMsg THEN
                        WITH msg: Texts.IdentifyMsg DO
                                msg.mod := "ClockElems"; msg.proc := "New"
                        END
                ELSIF msg IS Texts.FileMsg THEN
                        WITH msg: Texts.FileMsg DO
                                IF msg.id = Texts.load THEN Files.Read(msg.r, ch) (* ignore in this version *)
                                ELSIF msg.id = Texts.store THEN Files.Write(msg.r, 0X); (* version tag: used for future extensions *)
                                END
                        END
                END
        END HandleElem;

        PROCEDURE Clock;
                VAR msg: NotifyMsg;
        BEGIN
                old := new; GetTime(new);
                IF old.timeStamp # new.timeStamp THEN Task.time := Input.Time()+Input.TimeUnit;
                        Viewers.Broadcast(msg)
                ELSE Task.time := Input.Time() + 10 (* synchronization *)
                END
        END Clock;


(* commands *)

        PROCEDURE New*;
        BEGIN NEW(Texts.new); Texts.new.handle := HandleElem
        END New;

        PROCEDURE Insert*;
                VAR S: Texts.Scanner; w: LONGINT; E: Texts.Elem; M: TextFrames.InsertElemMsg;
        BEGIN
                Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
                IF (S.line = 0) & (S.class = Texts.Int) & (S.i > 0) THEN w := (2*S.i+1)*Display.Unit
                ELSE w := (2*Rdef+1)*Display.Unit
                END;
                NEW(E); E.W := w; E.H := w; E.handle := HandleElem;
                M.e := E; Viewers.Broadcast(M)
        END Insert;

BEGIN
        Init; wakeUp := 0; GetTime(new);
        NEW(Task); Task.safe := TRUE; Task.time := 0; Task.handle := Clock; Oberon.Install(Task)
END ClockElems.
