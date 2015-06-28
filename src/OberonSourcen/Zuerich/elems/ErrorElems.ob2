MODULE ErrorElems;      (** CAS 28-Oct-91 / MH 28-Sep-1993**)
        IMPORT
                Display, Input, Files, Fonts, Printer, Oberon, Texts, Viewers, MenuViewers, TextFrames, TextPrinter;

        CONST
                ErrFile = "OberonErrors.Text";
                ErrFont = "Syntax8.Scn.Fnt";    (* MH: may be changed to any font *)
                mm = TextFrames.mm;
                CR = 0DX;
                middleKey = 1; leftKey = 2;

        TYPE
                Elem* = POINTER TO ElemDesc;
                ElemDesc* = RECORD(Texts.ElemDesc)
                        err*: INTEGER;
                        msg*: ARRAY 128 OF CHAR;
                        expanded: BOOLEAN;
                END;


        VAR
                font*: Fonts.Font;
                W: Texts.Writer;
                lastTime: LONGINT;


        PROCEDURE MarkedFrame (): TextFrames.Frame;
                VAR V: Viewers.Viewer;
        BEGIN V := Oberon.MarkedViewer();
                IF (V IS MenuViewers.Viewer) & (V.dsc.next IS TextFrames.Frame) THEN RETURN V.dsc.next(TextFrames.Frame)
                ELSE RETURN NIL
                END
        END MarkedFrame;

        PROCEDURE Show (F: TextFrames.Frame; pos: LONGINT);
                VAR beg, end, delta: LONGINT;
        BEGIN delta := 200;
                LOOP beg := F.org; end := TextFrames.Pos(F, F.X, F.Y);
                        IF (beg <= pos) & (pos < end) OR (beg = end) THEN EXIT END;
                        TextFrames.Show(F, pos - delta); DEC(delta, 20)
                END
        END Show;

        PROCEDURE IntToStr (x: LONGINT; VAR s: ARRAY OF CHAR);
                VAR i, j: INTEGER; str: ARRAY 10 OF CHAR;
        BEGIN i := 0; j := 0;
                REPEAT str[i] := CHR((x MOD 10) + ORD("0")); x := x DIV 10; INC(i) UNTIL x = 0;
                REPEAT DEC(i); s[j] := str[i]; INC(j) UNTIL i = 0;
                s[j] := 0X;
        END IntToStr;

        PROCEDURE Width (E: Elem): INTEGER;
                VAR fnt: Fonts.Font; pat: Display.Pattern; i, px, dx, x, y, w, h: INTEGER;
        BEGIN fnt := Fonts.This(ErrFont); i := 0; px := 0;
                WHILE E.msg[i] # 0X DO
                        Display.GetChar(fnt.raster, E.msg[i], dx, x, y, w, h, pat); INC(px, dx); INC(i)
                END;
                RETURN px + 6
        END Width;

        PROCEDURE ShowErrMsg* (E: Elem; F: Display.Frame; col: SHORTINT; x0, y0, dw: INTEGER);
                VAR fnt: Fonts.Font; pat: Display.Pattern; i, px, rm, dx, x, y, w, h: INTEGER; ch: CHAR;
        BEGIN fnt := Fonts.This(ErrFont); i := 0; px := x0 + 3; rm := x0 + dw - 3;
                LOOP ch := E.msg[i]; INC(i);
                        IF ch = 0X THEN EXIT END;
                        Display.GetChar(fnt.raster, ch, dx, x, y, w, h, pat);
                        IF px + dx > rm THEN EXIT END;
                        Display.CopyPattern(col, pat, px + x, y0 + y, Display.invert); INC(px, dx)
                END
        END ShowErrMsg;

        PROCEDURE Expand* (E: Elem; pos: LONGINT);
                VAR S: Texts.Scanner; T: Texts.Text; n, m: INTEGER; ch: CHAR;
        BEGIN
                NEW(T); Texts.Open(T, ErrFile); Texts.OpenScanner(S, T, 0);
                REPEAT S.line := 0;
                        REPEAT Texts.Scan(S) UNTIL S.eot OR (S.line # 0)
                UNTIL S.eot OR (S.class = Texts.Int) & (S.i = E.err);
                IF ~S.eot THEN Texts.Read(S, ch); n := 0;
                        WHILE ~S.eot & (ch # CR) & (n + 1 < LEN(E.msg)) DO E.msg[n] := ch; INC(n); Texts.Read(S, ch) END;
                        E.msg[n] := 0X; E.W := LONG(Width(E)) * TextFrames.Unit;
                        TextFrames.NotifyDisplay(Texts.ElemBase(E), Texts.replace, pos, pos+1)
                END;
                E.expanded := TRUE;
        END Expand;

        PROCEDURE Reduce* (E: Elem; pos: LONGINT);
        BEGIN
                E.W := 3 * mm; IntToStr(E.err, E.msg); E.W := LONG(Width(E)) * TextFrames.Unit;
                TextFrames.NotifyDisplay(Texts.ElemBase(E), Texts.replace, pos, pos+1);
                E.expanded := FALSE;
        END Reduce;

        PROCEDURE Delete* (E: Elem; pos: LONGINT);
                VAR T: Texts.Text;
        BEGIN T := Texts.ElemBase(E);
                IF T # NIL THEN Texts.Delete(T, pos, pos + 1) END
        END Delete;

        PROCEDURE Copy* (SE, DE: Elem);
        BEGIN Texts.CopyElem(SE, DE); DE.err := SE.err; DE.msg := SE.msg; DE.expanded := SE.expanded;
        END Copy;

        PROCEDURE Prepare* (E: Elem; fnt: Fonts.Font; VAR voff: INTEGER);
                VAR max: INTEGER;
        BEGIN
                IF font.height > fnt.height THEN max := font.height ELSE max := fnt.height END;
                E.H := LONG(max+1) * TextFrames.Unit;
                voff := fnt.minY;
        END Prepare;

        PROCEDURE Disp* (E: Elem; F: Display.Frame; col: SHORTINT; fnt: Fonts.Font; x0, y0: INTEGER);
                VAR w, h: INTEGER;
        BEGIN w := SHORT(E.W DIV TextFrames.Unit); h := SHORT(E.H DIV TextFrames.Unit);
                Display.ReplConst(15, x0, y0 , w , h, Display.replace);
                IF E.msg[0] # 0X THEN ShowErrMsg(E, F, col, x0, y0 - fnt.minY, w) END
        END Disp;

        PROCEDURE Print* (E: Elem; x0, y0: INTEGER);
                VAR w, h: INTEGER;
        BEGIN w := SHORT(E.W DIV TextPrinter.Unit); h := SHORT(E.H DIV TextPrinter.Unit);
                Printer.ReplConst(x0 + 1, y0 + 2, w - 2, h)
        END Print;

        PROCEDURE Edit* (E: Elem; pos: LONGINT; x0, y0, x, y: INTEGER; keysum: SET);
                VAR w, h: INTEGER; keys: SET;
        BEGIN
                IF keysum = {middleKey} THEN
                        w := SHORT(E.W DIV TextFrames.Unit); h := SHORT(E.H DIV TextFrames.Unit);
                        Oberon.RemoveMarks(x0, y0, w, h);
                        Display.ReplConst(15, x0 + 2 , y0 + 2, w - 4, h - 4, Display.invert);
                        REPEAT Input.Mouse(keys, x, y); keysum := keysum + keys;
                                Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, x, y);
                        UNTIL keys = {};
                        Display.ReplConst(15, x0 + 2, y0 + 2, w - 4, h - 4, Display.invert);
                        IF keysum = {middleKey} THEN
                                IF E.expanded THEN Reduce(E, pos) ELSE Expand(E, pos) END
                        END
                END
        END Edit;

        PROCEDURE Handle* (E: Texts.Elem; VAR msg: Texts.ElemMsg);
                VAR e: Elem; pos: LONGINT; w, h: INTEGER; keys, keysum: SET;
        BEGIN
                WITH E: Elem DO
                        IF msg IS TextFrames.DisplayMsg THEN
                                WITH msg: TextFrames.DisplayMsg DO
                                        IF ~msg.prepare THEN Disp(E, msg.frame, msg.col, msg.fnt, msg.X0, msg.Y0)
                                        ELSE Prepare (E, msg.fnt, msg.Y0)
                                        END
                                END
                        ELSIF msg IS TextPrinter.PrintMsg THEN
                                WITH msg: TextPrinter.PrintMsg DO
                                        IF ~msg.prepare THEN Print(E, msg.X0, msg.Y0) END
                                END
                        ELSIF msg IS Texts.CopyMsg THEN
                                NEW(e); Copy(E, e); msg(Texts.CopyMsg).e := e;
                        ELSIF msg IS TextFrames.TrackMsg THEN
                                WITH msg: TextFrames.TrackMsg DO
                                        Edit(E, msg.pos, msg.X0, msg.Y0, msg.X, msg.Y, msg.keys)
                                END
                        END
                END
        END Handle;

        PROCEDURE InsertAt* (T: Texts.Text; pos: LONGINT; err: INTEGER);
                VAR e: Elem;
        BEGIN NEW(e); e.H := LONG(font.height + 2) * TextFrames.Unit; e.handle := Handle;
                e.err := err;
                IntToStr(err, e.msg); e.W := LONG(Width(e)) * TextFrames.Unit; e.expanded := FALSE;
                Texts.WriteElem(W, e); Texts.Insert(T, pos, W.buf)
        END InsertAt;

        PROCEDURE Unmark*;
                VAR F: TextFrames.Frame; pos: LONGINT; R: Texts.Reader;
        BEGIN F := MarkedFrame();
                IF F # NIL THEN
                        Texts.OpenReader(R, F.text, 0); Texts.ReadElem(R);
                        WHILE ~R.eot DO
                                IF R.elem IS Elem THEN pos := Texts.Pos(R); Texts.Delete(F.text, pos-1, pos);
                                        Texts.OpenReader(R, F.text, pos)
                                END;
                                Texts.ReadElem(R)
                        END
                END
        END Unmark;

        PROCEDURE Mark*;
                VAR F: TextFrames.Frame; S: Texts.Scanner; T: Texts.Text;
                        text: Texts.Text; beg, end, time, pos, delta: LONGINT; err: INTEGER;
        BEGIN Unmark; F := MarkedFrame(); Oberon.GetSelection(text, beg, end, time); delta := 0;
                IF (F # NIL) & (time >= lastTime) THEN
                        lastTime := time; T := F.text; Texts.OpenScanner(S, text, beg);
                        LOOP S.line := 0;
                                REPEAT Texts.Scan(S) UNTIL S.eot OR (S.line # 0) OR (S.class = Texts.Int);
                                IF S.eot OR (S.line # 0) THEN EXIT END;
                                pos := S.i;
                                REPEAT Texts.Scan(S) UNTIL S.eot OR (S.line # 0) OR (S.class = Texts.Int);
                                IF S.eot OR (S.line # 0) THEN EXIT END;
                                err := SHORT(S.i); InsertAt(T, pos + delta, err); INC(delta);
                                REPEAT Texts.Scan(S) UNTIL S.eot OR (S.line # 0)
                        END
                END
        END Mark;

        PROCEDURE LocateNext*;
                VAR F: TextFrames.Frame; beg, pos: LONGINT; R: Texts.Reader;
        BEGIN F := MarkedFrame();
                IF F # NIL THEN
                        IF F.hasCar THEN beg := F.carloc.pos ELSE beg := 0 END;
                        Texts.OpenReader(R, F.text, beg);
                        REPEAT Texts.ReadElem(R) UNTIL R.eot OR (R.elem IS Elem);
                        IF ~R.eot & (R.elem IS Elem) THEN
                                Oberon.PassFocus(Viewers.This(F.X, F.Y)); pos := Texts.Pos(R);
                                Show(F, pos-1); TextFrames.SetCaret(F, pos)
                        ELSE TextFrames.RemoveCaret(F)
                        END
                END
        END LocateNext;

BEGIN
        font := Fonts.This(ErrFont);
        Texts.OpenWriter(W); lastTime := -1;
END ErrorElems.

(*
        ErrorElems.Mark ^
        ErrorElems.Unmark *
        ErrorElems.LocateNext
*)
