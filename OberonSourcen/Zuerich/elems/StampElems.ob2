MODULE StampElems;      (* CAS 26 Jun 92, SHML 17 Mar 94 *)

        IMPORT Files, Input, Display, Fonts, Texts, Oberon, Printer, TextFrames, TextPrinter;

        TYPE
                Elem = POINTER TO ElemDesc;
                ElemDesc = RECORD (Texts.ElemDesc)
                        s: ARRAY 32 OF CHAR
                END;

        VAR
                W: Texts.Writer;
                month: ARRAY 12*3+1 OF CHAR;

        PROCEDURE StrDispWidth (fnt: Fonts.Font; s: ARRAY OF CHAR): LONGINT;
                VAR pat: Display.Pattern; width, i, dx, x, y, w, h: INTEGER; ch: CHAR;
        BEGIN width := 0;
                i := 0; ch := s[i];
                WHILE ch # 0X DO
                        Display.GetChar(fnt.raster, ch, dx, x, y, w, h, pat); INC(width, dx);
                        INC(i); ch := s[i]
                END;
                RETURN LONG(width) * TextFrames.Unit
        END StrDispWidth;

        PROCEDURE DispStr (fnt: Fonts.Font; s: ARRAY OF CHAR; col, x0, y0: INTEGER);
                VAR pat: Display.Pattern; i, dx, x, y, w, h: INTEGER; ch: CHAR;
        BEGIN i := 0; ch := s[i];
                WHILE ch # 0X DO
                        Display.GetChar(fnt.raster, ch, dx, x, y, w, h, pat);
                        Display.CopyPattern(col, pat, x0+x, y0+y, Display.replace);
                        INC(i); ch := s[i]; INC(x0, dx)
                END
        END DispStr;

        PROCEDURE StrPrntWidth (fnt: Fonts.Font; s: ARRAY OF CHAR): LONGINT;
                VAR width, dx, x, y, w, h: LONGINT; i: INTEGER; fno: SHORTINT; ch: CHAR;
        BEGIN width := 0; fno := TextPrinter.FontNo(fnt);
                i := 0; ch := s[i];
                WHILE ch # 0X DO
                        TextPrinter.Get(fno, ch, dx, x, y, w, h); INC(width, dx);
                        INC(i); ch := s[i]
                END;
                RETURN width
        END StrPrntWidth;

        PROCEDURE PrntStr (fnt: Fonts.Font; s: ARRAY OF CHAR; x0, y0: INTEGER);
        BEGIN Printer.String(x0, y0, s, fnt.name)
        END PrntStr;

        PROCEDURE Format (date: LONGINT; VAR s: ARRAY OF CHAR);
                VAR i: INTEGER;

                PROCEDURE Pair (x: LONGINT);
                BEGIN
                        IF x >= 10 THEN s[i] := CHR(x DIV 10 + 30H); INC(i) END;
                        s[i] := CHR(x MOD 10 + 30H); INC(i)
                END Pair;

                PROCEDURE Label (m: LONGINT);
                BEGIN m := (m-1)*3;
                        s[i] := month[m]; s[i+1] := month[m+1]; s[i+2] := month[m+2]; INC(i, 3)
                END Label;

        BEGIN i := 0;
                Pair(date MOD 32); s[i] := " "; INC(i);
                Label(date DIV 32 MOD 16); s[i] := " "; INC(i);
                Pair(date DIV 512 MOD 128); s[i] := 0X
        END Format;

        PROCEDURE Copy (se, de: Elem);
        BEGIN Texts.CopyElem(se, de); de.s := se.s
        END Copy;

        PROCEDURE Load (e: Elem; VAR r: Files.Rider);
                VAR i: INTEGER; vers, ch: CHAR;
        BEGIN Files.Read(r, vers); i := 0;
                REPEAT Files.Read(r, ch); e.s[i] := ch; INC(i) UNTIL ch = 0X
        END Load;

        PROCEDURE Store (e: Elem; pos: LONGINT; VAR r: Files.Rider);
                VAR t, d: LONGINT; i: INTEGER; ch: CHAR; s: ARRAY 32 OF CHAR;
        BEGIN COPY(e.s, s); Oberon.GetClock(t, d); Format(d, e.s);
                Files.Write(r, 1X); i := 0;
                REPEAT ch := e.s[i]; Files.Write(r, ch); INC(i) UNTIL ch = 0X;
                IF s # e.s THEN Texts.ChangeLooks(Texts.ElemBase(e), pos, pos+1, {}, NIL, 0, 0) END
        END Store;

        PROCEDURE PrepDraw (e: Elem; fnt: Fonts.Font; VAR dy: INTEGER);
        BEGIN e.W := StrDispWidth(fnt, e.s); e.H := LONG(fnt.maxY-fnt.minY) * TextFrames.Unit;
                dy := fnt.minY;
                IF dy > -2 THEN dy := -2 END
        END PrepDraw;

        PROCEDURE Draw (e: Elem; pos: LONGINT; fnt: Fonts.Font; col, x0, y0: INTEGER);
                VAR p: TextFrames.Parc; beg: LONGINT; w: INTEGER;
        BEGIN w := SHORT(e.W DIV TextFrames.Unit);
                TextFrames.ParcBefore(Texts.ElemBase(e), pos, p, beg);
                INC(y0, SHORT(p.dsr DIV TextFrames.Unit));
                DispStr(fnt, e.s, col, x0, y0);
                Display.ReplPattern(col, Display.grey1, x0, y0-1, w, 1, Display.replace)
        END Draw;

        PROCEDURE PrepPrint (e: Elem; fnt: Fonts.Font; VAR dy: INTEGER);
        BEGIN e.W := StrPrntWidth(fnt, e.s); e.H := LONG(fnt.maxY-fnt.minY) * TextFrames.Unit;
                dy := SHORT(fnt.minY * LONG(TextFrames.Unit) DIV TextPrinter.Unit);
                IF dy > -2 THEN dy := -2 END
        END PrepPrint;

        PROCEDURE Print (e: Elem; pos: LONGINT; fnt: Fonts.Font; x0, y0: INTEGER);
                VAR p: TextFrames.Parc; beg: LONGINT;
        BEGIN TextFrames.ParcBefore(Texts.ElemBase(e), pos, p, beg);
                INC(y0, SHORT(p.dsr DIV TextPrinter.Unit));
                PrntStr(fnt, e.s, x0, y0);
                e.W := StrDispWidth(fnt, e.s)
        END Print;

        PROCEDURE Track (e: Elem; pos: LONGINT; x, y: INTEGER; keys: SET);
        BEGIN
                REPEAT Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, x, y); Input.Mouse(keys, x, y)
                UNTIL keys = {}
        END Track;

        PROCEDURE Handle (e: Texts.Elem; VAR msg: Texts.ElemMsg);
                VAR copy: Elem;
        BEGIN
                WITH e: Elem DO
                        IF msg IS Texts.CopyMsg THEN
                                NEW(copy); Copy(e, copy); msg(Texts.CopyMsg).e := copy
                        ELSIF msg IS Texts.IdentifyMsg THEN
                                WITH msg: Texts.IdentifyMsg DO msg.mod := "StampElems"; msg.proc := "Alloc" END
                        ELSIF msg IS Texts.FileMsg THEN
                                WITH msg: Texts.FileMsg DO
                                        IF msg.id = Texts.load THEN Load(e, msg.r)
                                        ELSIF msg.id = Texts.store THEN Store(e, msg.pos, msg.r)
                                        END
                                END
                        ELSIF msg IS TextFrames.TrackMsg THEN
                                WITH msg: TextFrames.TrackMsg DO
                                        IF msg.keys = {1} THEN Track(e, msg.pos, msg.X, msg.Y, msg.keys); msg.keys := {} END
                                END
                        ELSIF msg IS TextFrames.DisplayMsg THEN
                                WITH msg: TextFrames.DisplayMsg DO
                                        IF msg.prepare THEN PrepDraw(e, msg.fnt, msg.Y0)
                                        ELSE Draw(e, msg.pos, msg.fnt, msg.col, msg.X0, msg.Y0)
                                        END
                                END
                        ELSIF msg IS TextPrinter.PrintMsg THEN
                                WITH msg: TextPrinter.PrintMsg DO
                                        IF msg.prepare THEN PrepPrint(e, msg.fnt, msg.Y0)
                                        ELSE Print(e, msg.pos, msg.fnt, msg.X0, msg.Y0)
                                        END
                                END
                        END
                END
        END Handle;

        PROCEDURE Alloc*;
                VAR e: Elem;
        BEGIN NEW(e); e.handle := Handle; Texts.new := e
        END Alloc;

        PROCEDURE Open (e: Elem);
                VAR t, d: LONGINT;
        BEGIN e.W := 5*TextFrames.mm; e.H := e.W; e.handle := Handle;
                Oberon.GetClock(t, d); Format(d, e.s)
        END Open;

        PROCEDURE Insert*;      (** [font] **)
                VAR s: Texts.Scanner; T: Texts.Text; e: Elem; fnt: Fonts.Font; copyover: Oberon.CopyOverMsg;
        BEGIN Texts.OpenScanner(s, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(s);
                IF (s.line = 0) & (s.class = Texts.Name) THEN fnt := Fonts.This(s.s) ELSE fnt := Oberon.CurFnt END;
                NEW(e); Open(e);
                T := TextFrames.Text(""); Texts.WriteElem(W, e); Texts.Append(T, W.buf);
                Texts.ChangeLooks(T, 0, 1, {0}, fnt, 0, 0);
                copyover.text := T; copyover.beg := 0; copyover.end := 1;
                Oberon.FocusViewer.handle(Oberon.FocusViewer, copyover)
        END Insert;

BEGIN Texts.OpenWriter(W);
        month := "JanFebMarAprMayJunJulAugSepOctNovDec"
END StampElems.
