MODULE TableElems;      (** CAS 13-May-92 / 28-Sep-93 **)
        IMPORT
                Input, Display, Fonts, Printer, Files, Oberon, Texts, TextFrames, Viewers, MenuViewers, TextPrinter;

        CONST
                Menu = "System.Close  Edit.Search  Edit.Replace All  Edit.Parcs  TableElems.Update ";
                mm = TextFrames.mm; Scale = mm DIV 10; MinW = 3*mm; MinH = 3*mm;
                unit = TextFrames.Unit; Unit = TextPrinter.Unit;
                middleKey = 1;
                TAB = 9X; CR = 0DX;
                MaxCol = 32; MaxRow = 32;
                (*elem.opts set elements*)
                        headCol = 0; headRow = 1; colL = 2; rowL = 3; leftL = 4; rightL = 5; topL = 6; botL = 7;

        TYPE
                Row = POINTER TO RowDesc;
                RowDesc = RECORD
                        next: Row;
                        lsp, dsr: LONGINT;
                        pos: ARRAY MaxCol OF LONGINT;
                        x, y: ARRAY MaxCol OF LONGINT
                END;

                Elem* = POINTER TO ElemDesc;
                ElemDesc* = RECORD(Texts.ElemDesc)
                        def*: Texts.Text;
                        parc: TextFrames.Parc;
                        opts: SET;
                        nofCols, nofRows: INTEGER;
                        lw: LONGINT;
                        width: ARRAY MaxCol OF LONGINT;
                        row: Row        (*rows chained from bottom to top*)
                END;

                Viewer* = POINTER TO ViewerDesc;
                ViewerDesc* = RECORD(MenuViewers.ViewerDesc)
                        elem*: Elem
                END;

        VAR
                W: Texts.Writer;


        PROCEDURE Min (x, y: LONGINT): LONGINT;
        BEGIN
                IF x < y THEN RETURN x ELSE RETURN y END
        END Min;

        PROCEDURE Max (x, y: LONGINT): LONGINT;
        BEGIN
                IF x > y THEN RETURN x ELSE RETURN y END
        END Max;

        PROCEDURE UnmarkMenu (V: Viewers.Viewer);
                VAR R: Texts.Reader; T: Texts.Text; ch: CHAR;
        BEGIN T := V.dsc(TextFrames.Frame).text;
                Texts.OpenReader(R, T, T.len - 1); Texts.Read(R, ch);
                IF ch = "!" THEN Texts.Delete(T, T.len - 1, T.len) END
        END UnmarkMenu;


        (* generate table structure *)

        PROCEDURE Matches (VAR S: Texts.Scanner; key: ARRAY OF CHAR): BOOLEAN;
                VAR i: INTEGER;
        BEGIN i := 0;
                WHILE (S.s[i] # 0X) & (CAP(S.s[i]) = key[i]) DO INC(i) END;
                RETURN (S.class = Texts.Name) & ((key[i] = 0X) OR (i >= 3)) & (S.s[i] = 0X)
        END Matches;

        PROCEDURE Opts (s: ARRAY OF CHAR): SET;
                VAR opts: SET; i: INTEGER; ch: CHAR;
        BEGIN opts := {}; i := 0;
                WHILE s[i] # 0X DO ch := CAP(s[i]);
                        IF ch = "H" THEN INCL(opts, headRow)
                        ELSIF ch = "V" THEN INCL(opts, headCol)
                        ELSIF s[i] = "*" THEN opts := {headRow, headCol}
                        END;
                        INC(i)
                END;
                RETURN opts
        END Opts;

        PROCEDURE LineOpts (s: ARRAY OF CHAR): SET;
                VAR opts: SET; i: INTEGER; ch: CHAR;
        BEGIN opts := {}; i := 0;
                WHILE s[i] # 0X DO ch := CAP(s[i]);
                        IF ch = "H" THEN INCL(opts, rowL)
                        ELSIF ch = "V" THEN INCL(opts, colL)
                        ELSIF ch = "L" THEN INCL(opts, leftL)
                        ELSIF ch = "R" THEN INCL(opts, rightL)
                        ELSIF ch = "T" THEN INCL(opts, topL)
                        ELSIF ch = "B" THEN INCL(opts, botL)
                        ELSIF s[i] = "*" THEN opts := {rowL, colL, leftL, rightL, topL, botL}
                        END;
                        INC(i)
                END;
                RETURN opts
        END LineOpts;

        PROCEDURE ColOpts (VAR cm: ARRAY OF CHAR; s: ARRAY OF CHAR);
                VAR i: INTEGER; ch: CHAR;
        BEGIN i := 0;
                WHILE (s[i] # 0X) & (i < LEN(cm)) DO ch := CAP(s[i]);
                        IF (ch = "C") OR (ch = "L") OR (ch = "N") OR (ch = "R") THEN cm[i] := ch END;
                        INC(i)
                END
        END ColOpts;

        PROCEDURE RowOpts (VAR rm: ARRAY OF CHAR; s: ARRAY OF CHAR);
                VAR i: INTEGER; ch: CHAR;
        BEGIN i := 0;
                WHILE (s[i] # 0X) & (i < LEN(rm)) DO ch := CAP(s[i]);
                        IF (ch = "B") OR (ch = "C") OR (ch = "L") OR (ch = "T") THEN rm[i] := ch END;
                        INC(i)
                END
        END RowOpts;

        PROCEDURE Offset (VAR R: Texts.Reader): LONGINT;
        BEGIN
                IF R.voff = 0 THEN RETURN 0 ELSE RETURN LONG(R.fnt.height) * unit * R.voff DIV 64 END
        END Offset;

        PROCEDURE DispPrepElem (E: Elem; e: Texts.Elem; fnt: Fonts.Font; col: SHORTINT; pos: LONGINT);
                VAR disp: TextFrames.DisplayMsg;
        BEGIN disp.prepare := TRUE;
                disp.fnt := fnt; disp.col := col; disp.pos := pos; disp.indent := 0; e.handle(e, disp)
        END DispPrepElem;

        PROCEDURE PrintPrepElem (E: Elem; e: Texts.Elem; fnt: Fonts.Font; col: SHORTINT; pno: INTEGER; pos: LONGINT);
                VAR print: TextPrinter.PrintMsg;
        BEGIN print.prepare := TRUE;
                print.fnt := fnt; print.col := col; print.pos := pos; print.indent := 0; print.pno := pno; e.handle(e, print)
        END PrintPrepElem;

        PROCEDURE GetElem (E: Elem; e: Texts.Elem;
                        fnt: Fonts.Font; col: SHORTINT; pos: LONGINT; VAR dx, x, y, w, h: LONGINT);
        BEGIN x := 0; y := -E.parc.dsr;
                DispPrepElem(E, e, fnt, col, pos); dx := e.W; h := e.H;
                PrintPrepElem(E, e, fnt, col, -1, pos); dx := Max(dx, e.W); h := Max(h, e.H); w := dx
        END GetElem;


        PROCEDURE Parse (E: Elem): LONGINT;
                CONST StrClass = {Texts.Name, Texts.String};
                VAR S: Texts.Scanner; row: Row; pbeg, beg, pos: LONGINT; state, st, r, c: INTEGER; ch, period: CHAR;
                        margL, margR, margB, margT, gridW, lsp, dsr, min, max, cmin, cmax, cw, wl, wr, dx, x, y, w, h: LONGINT;
                        cm: ARRAY MaxCol OF CHAR;
                        rm: ARRAY MaxRow OF CHAR;
                        h1, h2, w1, w2: ARRAY MaxRow, MaxCol OF LONGINT;

                PROCEDURE Setup;
                BEGIN E.opts := {headRow, headCol, colL, rowL, leftL, rightL, topL, botL}; E.lw := 2*Scale; period := ".";
                        r := 0; WHILE r < MaxRow DO rm[r] := "L"; INC(r) END;
                        cm[0] := "L"; c := 1; WHILE c < MaxCol DO cm[c] := "N"; INC(c) END;
                        margL := 1*mm; margR := margL; margB := 3*Scale; margT := margB; gridW := 5*mm
                END Setup;

                PROCEDURE Scan (VAR S: Texts.Scanner);
                        VAR i: SHORTINT; ch: CHAR;
                BEGIN ch := S.nextCh; i := 0;
                        LOOP
                                IF ch = CR THEN INC(S.line)
                                ELSIF (ch # " ") & (ch # TAB) THEN EXIT
                                END;
                                Texts.Read(S, ch)
                        END;
                        IF ("A" <= CAP(ch)) & (CAP(ch) <= "Z") THEN
                                REPEAT S.s[i] := ch; INC(i); Texts.Read(S, ch)
                                UNTIL (CAP(ch) > "Z")
                                        OR ("A" > CAP(ch)) & (ch > "9")
                                        OR ("0" > ch) & (ch # ".")
                                        OR (i = LEN(S.s)-1);
                                S.s[i] := 0X; S.len := i; S.class := Texts.Name; S.nextCh := ch
                        ELSIF ch = "/" THEN S.class := 6; S.c := ch; Texts.Read(S, S.nextCh)
                        ELSE S.nextCh := ch; Texts.Scan(S)
                        END
                END Scan;

                PROCEDURE Options;
                BEGIN Texts.OpenScanner(S, E.def, 0); Scan(S);
                        LOOP
                                IF S.eot THEN RETURN
                                ELSIF (S.class = Texts.Char) & (S.c = "/") THEN Scan(S);
                                        IF Matches(S, "TABLE") THEN RETURN
                                        ELSIF Matches(S, "BOTTOM") THEN Scan(S);
                                                IF (S.class = Texts.Int) & (0 <= S.i) & (S.i <= 100) THEN margB := S.i*Scale END
                                        ELSIF Matches(S, "COLUMNS") THEN Scan(S);
                                                IF S.class IN StrClass THEN ColOpts(cm, S.s) END
                                        ELSIF Matches(S, "GRID") THEN Scan(S);
                                                IF (S.class = Texts.Int) & (0 <= S.i) & (S.i <= 100) THEN gridW := S.i*Scale END
                                        ELSIF Matches(S, "HEADS") THEN Scan(S);
                                                IF S.class IN StrClass THEN E.opts := E.opts + Opts(S.s) END
                                        ELSIF Matches(S, "LEFT") THEN Scan(S);
                                                IF (S.class = Texts.Int) & (0 <= S.i) & (S.i <= 100) THEN margL := S.i*Scale END
                                        ELSIF Matches(S, "LINES") THEN Scan(S);
                                                IF S.class IN StrClass THEN E.opts := E.opts + LineOpts(S.s) END
                                        ELSIF Matches(S, "NOHEADS") THEN Scan(S);
                                                IF S.class IN StrClass THEN E.opts := E.opts - Opts(S.s) END
                                        ELSIF Matches(S, "NOLINES") THEN Scan(S);
                                                IF S.class IN StrClass THEN E.opts := E.opts - LineOpts(S.s) END
                                        ELSIF Matches(S, "PERIOD") THEN Scan(S);
                                                IF S.class IN StrClass THEN period := S.s[0] END
                                        ELSIF Matches(S, "RIGHT") THEN Scan(S);
                                                IF (S.class = Texts.Int) & (0 <= S.i) & (S.i <= 100) THEN margR := S.i*Scale END
                                        ELSIF Matches(S, "ROWS") THEN Scan(S);
                                                IF S.class IN StrClass THEN RowOpts(rm, S.s) END
                                        ELSIF Matches(S, "TOP") THEN Scan(S);
                                                IF (S.class = Texts.Int) & (0 <= S.i) & (S.i <= 100) THEN margT := S.i*Scale END
                                        ELSIF Matches(S, "WIDTHS") THEN Scan(S);
                                                IF (S.class = Texts.Int) & (1 <= S.i) & (S.i <= 10) THEN E.lw := S.i*Scale END
                                        END;
                                        Scan(S)
                                ELSE Scan(S)
                                END
                        END
                END Options;

                PROCEDURE AcceptCell;
                BEGIN row.pos[c] := pos; w1[r, c] := cw; h1[r, c] := cmax - cmin; h2[r, c] := -cmin;
                        min := Min(min, cmin); max := Max(max, cmax);
                        CASE state OF
                                0, 1: w2[r, c] := cw
                        |  2: w2[r, c] := wl
                        |  3: w2[r, c] := -1
                        END;
                        pos := Texts.Pos(S); INC(c); cmin := -E.parc.dsr; cmax := 0; cw := 0; state := 0;
                        IF c > E.nofCols THEN
                                IF c < MaxCol THEN INC(E.nofCols) ELSE DEC(c) END
                        END
                END AcceptCell;

        BEGIN Setup; Options; INC(margL, E.lw); INC(margR, E.lw); INC(margB, E.lw); INC(margT, E.lw);
                E.nofCols := 0; E.nofRows := 0;
                ch := S.nextCh; WHILE ~S.eot & (ch # CR) DO Texts.Read(S, ch) END;
                beg := Texts.Pos(S); TextFrames.ParcBefore(E.def, beg, E.parc, pbeg);
        (*parse*)
                pos := beg; E.row := NIL;
                IF ~S.eot THEN NEW(row); r := 0; min := 0; max := 0; c := 0; cmin := -E.parc.dsr; cmax := 0; cw := 0; state := 0;
                        LOOP Texts.Read(S, ch);
                                IF S.eot THEN EXIT
                                ELSIF ch = CR THEN AcceptCell;
                                        IF TextFrames.gridAdj IN E.parc.opts THEN dsr := E.parc.dsr;
                                                WHILE dsr < -min DO INC(dsr, E.parc.lsp) END;
                                                lsp := Max(E.parc.lsp, dsr + max); INC(lsp, (-lsp) MOD E.parc.lsp)
                                        ELSE dsr := Max(E.parc.dsr, -min); lsp := Max(E.parc.lsp, dsr + max)
                                        END;
                                        row.dsr := dsr + margB; row.lsp := lsp + margB + margT;
                                        WHILE c < MaxCol DO
                                                row.pos[c] := E.def.len; h1[r, c] := 0; h2[r, c] := 0; w1[r, c] := 0; w2[r, c] := -1; INC(c)
                                        END;
                                        row.next := E.row; E.row := row; INC(r); IF r = MaxRow THEN EXIT END;
                                        NEW(row); min := 0; max := 0; c := 0
                                ELSIF ch = TAB THEN AcceptCell
                                ELSE st := state;
                                        IF (state < 2) & (ch = period) THEN wl := cw; state := 2
                                        ELSIF (state = 0) & ((ch >= "0") & (ch <= "9") OR (ch = "+") OR (ch = "-") OR (ch = "#")) THEN state := 1
                                        ELSIF state = 0 THEN state := 3
                                        END;
                                        IF (st # 0) OR (ch # "#") & (ch # "&") THEN
                                                IF (S.elem # NIL) & ~(S.elem IS TextFrames.Parc) THEN
                                                        GetElem(E, S.elem, S.fnt, S.col, Texts.Pos(S)-1, dx, x, y, w, h)
                                                ELSE TextPrinter.Get(TextPrinter.FontNo(S.fnt), ch, dx, x, y, w, h)
                                                END;
                                                INC(y, Offset(S)); cmin := Min(cmin, y); cmax := Max(cmax, y + h); INC(cw, dx)
                                        END
                                END
                        END;
                        E.nofRows := r
                END;
        (*format*)
                IF E.nofRows < 2 THEN EXCL(E.opts, headRow) END;
                IF E.nofCols < 2 THEN EXCL(E.opts, headCol) END;
                c := 0;
                WHILE c < E.nofCols DO
                        IF cm[c] = "N" THEN wl := 0; wr := 0; r := 0;
                                WHILE r < E.nofRows DO
                                        IF w2[r, c] > wl THEN wl := w2[r, c] END;
                                        IF (w2[r, c] >= 0) & (w1[r, c] - w2[r, c] > wr) THEN wr := w1[r, c] - w2[r, c] END;
                                        INC(r)
                                END;
                                cw := wl + wr
                        ELSE cw := 0
                        END;
                        r := 0;
                        WHILE r < E.nofRows DO
                                IF w1[r, c] > cw THEN cw := w1[r, c] END;
                                INC(r)
                        END;
                        INC(cw, margL + margR);
                        IF gridW > 0 THEN INC(cw, (-cw) MOD gridW) END;
                        r := E.nofRows; row := E.row;
                        WHILE r > 0 DO DEC(r);
                                IF cm[c] = "L" THEN row.x[c] := margL
                                ELSIF cm[c] = "R" THEN row.x[c] := cw - margR - w1[r, c]
                                ELSIF (cm[c] = "C") OR (w2[r, c] = -1) THEN row.x[c] := (cw - w1[r, c]) DIV 2
                                ELSIF cm[c] = "N" THEN row.x[c] := (cw - wl - wr) DIV 2 + wl - w2[r, c]
                                END;
                                IF rm[r] = "B" THEN row.y[c] := margB + h2[r, c]
                                ELSIF rm[r] = "T" THEN row.y[c] := row.lsp - h1[r, c] - margB + h2[r, c]
                                ELSIF rm[r] = "C" THEN row.y[c] := (row.lsp - h1[r, c]) DIV 2 + h2[r, c]
                                ELSIF rm[r] = "L" THEN row.y[c] := row.dsr
                                END;
                                row := row.next
                        END;
                        E.width[c] := cw;
                        INC(c)
                END;
                RETURN beg
        END Parse;


        (* operations on elements *)

        PROCEDURE CopyText* (T: Texts.Text): Texts.Text;
                VAR B: Texts.Buffer; t: Texts.Text;
        BEGIN NEW(B); Texts.OpenBuf(B); Texts.Save(T, 0, T.len, B);
                NEW(t); Texts.Open(t, ""); t.notify := T.notify;
                Texts.Append(t, B); RETURN t
        END CopyText;

        PROCEDURE Open* (E: Elem; def: Texts.Text);
                VAR row: Row; beg: LONGINT; i: INTEGER;
        BEGIN
                E.def := def; beg := Parse(E);
                E.W := 0; i := 0; WHILE i < E.nofCols DO INC(E.W, E.width[i]); INC(i) END;
                E.H := 0; row := E.row; WHILE row # NIL DO INC(E.H, row.lsp); row := row.next END;
                IF (headRow IN E.opts) & (rowL IN E.opts) THEN INC(E.H, E.lw * 2) END;
                IF (headCol IN E.opts) & (colL IN E.opts) THEN INC(E.W, E.lw * 2) END;
                IF E.W < MinW THEN E.W := MinW END;
                IF E.H < MinH THEN E.H := MinH END
        END Open;

        PROCEDURE Load* (E: Elem; VAR r: Files.Rider);
                VAR text: Texts.Text; f: Files.File; pos, len: LONGINT; version, tag: CHAR;
        BEGIN Files.Read(r, version); NEW(text); Texts.Load(r, text); text.notify := TextFrames.NotifyDisplay;
                Open(E, text)
        END Load;

        PROCEDURE Store* (E: Elem; VAR r: Files.Rider);
                VAR f: Files.File; pos, len: LONGINT;
        BEGIN Files.Write(r, 1X); Texts.Store(r, E.def)
        END Store;

        PROCEDURE Changed* (E: Elem);
                VAR R: Texts.Reader; T: Texts.Text;
        BEGIN T := Texts.ElemBase(E);
                IF T # NIL THEN Texts.OpenReader(R, T, 0);
                        REPEAT Texts.ReadElem(R) UNTIL R.elem = E;
                        T.notify(T, Texts.replace, Texts.Pos(R)-1, Texts.Pos(R))
                END
        END Changed;


        PROCEDURE Line (x, y, w, h: INTEGER);
        BEGIN Display.ReplConst(Display.white, x, y, w, h, Display.replace)
        END Line;

        PROCEDURE DrawString (E: Elem; F: Display.Frame; pos: LONGINT; x0, y0: INTEGER);
                VAR R: Texts.Reader; e: Texts.Elem; pat: Display.Pattern;
                        px, pdx: LONGINT; dx, x, y, w, h: INTEGER; ch: CHAR;
                        disp: TextFrames.DisplayMsg;
        BEGIN Texts.OpenReader(R, E.def, pos); Texts.Read(R, ch); px := LONG(x0) * unit;
                IF (ch = "#") OR (ch = "&") THEN Texts.Read(R, ch) END;
                WHILE ~R.eot & (ch # TAB) & (ch # CR) DO
                        IF R.elem # NIL THEN
                                IF R.elem IS TextFrames.Parc THEN pdx := 0
                                ELSE e := R.elem;
                                        DispPrepElem(E, e, R.fnt, R.col, Texts.Pos(R)-1); pdx := e.W;
                                        disp.prepare := FALSE; disp.fnt := R.fnt; disp.col := R.col; disp.pos := Texts.Pos(R)-1; disp.frame := F;
                                        disp.X0 := SHORT(px DIV unit); disp.Y0 := y0 + SHORT((Offset(R) - E.parc.dsr) DIV unit);
                                        disp.indent := 0;
                                        e.handle(e, disp)
                                END
                        ELSE TextPrinter.GetChar(TextPrinter.FontNo(R.fnt), unit, ch, pdx, dx, x, y, w, h, pat);
                                Display.CopyPattern(R.col, pat,
                                        SHORT(px DIV unit) + x, y0 + SHORT(Offset(R) DIV unit) + y, Display.replace)
                        END;
                        INC(px, pdx); Texts.Read(R, ch)
                END
        END DrawString;

        PROCEDURE Draw* (E: Elem; F: Display.Frame; x0, y0: INTEGER);
                VAR row: Row; r, c, x, y, w, h, h1, lw, d: INTEGER;

                PROCEDURE Align(x: LONGINT): LONGINT;
                BEGIN RETURN x + (-x) MOD unit
                END Align;
        BEGIN
                IF (E.nofRows = 0) OR (E.nofCols = 0) THEN w := SHORT(E.W DIV unit); h := SHORT(E.H DIV unit);
                        Display.ReplPattern(Display.white, Display.grey1, x0, y0, w, h, Display.replace)
                ELSE r := E.nofRows; row := E.row;
                        y := y0; lw := SHORT(Align(E.lw) DIV unit); d := SHORT(E.lw * 2 DIV unit);
                        WHILE r > 0 DO DEC(r); x := x0; c := 0; h := SHORT(row.lsp DIV unit); h1 := h;
                                IF (r = 1) & (headRow IN E.opts) & (rowL IN E.opts) THEN INC(h1, d) END;
                                WHILE c < E.nofCols DO w := SHORT(E.width[c] DIV unit);
                                        IF c = 0 THEN
                                                IF headCol IN E.opts THEN Line(x + w - lw, y, lw, h);
                                                        IF colL IN E.opts THEN INC(w, d) END
                                                END;
                                                IF leftL IN E.opts THEN Line(x, y, lw, h1) END
                                        ELSIF colL IN E.opts THEN Line(x, y, lw, h)
                                        END;
                                        IF (c = E.nofCols - 1) & (rightL IN E.opts) THEN Line(x + w - lw, y, lw, h1) END;
                                        IF (r = 0) & (topL IN E.opts) OR (r = 1) & (headRow IN E.opts) THEN
                                                Line(x, y + h - lw, w, lw)
                                        END;
                                        IF (r = E.nofRows - 1) & (botL IN E.opts) OR (r < E.nofRows - 1) & (rowL IN E.opts) THEN
                                                Line(x, y, w, lw)
                                        END;
                                        DrawString(E, F, row.pos[c], x + SHORT(row.x[c] DIV unit), y + SHORT(row.y[c] DIV unit));
                                        INC(x, w); INC(c)
                                END;
                                INC(y, h1); row := row.next
                        END
                END
        END Draw;


        PROCEDURE PrintString (E: Elem; pos: LONGINT; pno, x0, y0: INTEGER);
                VAR R: Texts.Reader; e: Texts.Elem; fnt: Fonts.Font;
                        i, w, dy: INTEGER; voff, fno: SHORTINT; ch: CHAR; first: BOOLEAN;
                        print: TextPrinter.PrintMsg; s: ARRAY 256 OF CHAR;
        BEGIN Texts.OpenReader(R, E.def, pos); Texts.Read(R, ch); first := TRUE;
                IF (ch = "#") OR (ch = "&") THEN Texts.Read(R, ch) END;
                WHILE ~R.eot & (ch # TAB) & (ch # CR) DO
                        WHILE ~R.eot & (R.elem # NIL) DO
                                IF ~(R.elem IS TextFrames.Parc) THEN e := R.elem;
                                        PrintPrepElem(E, e, R.fnt, R.col, pno, Texts.Pos(R)-1);
                                        print.prepare := FALSE; print.indent := 0; print.fnt := R.fnt; print.col := R.col; print.pos := Texts.Pos(R)-1;
                                        print.X0 := x0; print.Y0 := y0 + SHORT((Offset(R) - E.parc.dsr) DIV Unit); print.pno := pno;
                                        e.handle(e, print); INC(x0, SHORT(e.W DIV Unit)); first := TRUE
                                END;
                                Texts.Read(R, ch)
                        END;
                        IF ~R.eot & (ch # TAB) & (ch # CR) THEN
                                fnt := R.fnt; fno := TextPrinter.FontNo(fnt); voff := R.voff;
                                dy := SHORT(Offset(R) DIV Unit); i := 0; w := 0;
                                REPEAT s[i] := ch; INC(i); INC(w, SHORT(TextPrinter.DX(fno, ch) DIV Unit)); Texts.Read(R, ch)
                                UNTIL R.eot OR (R.elem # NIL) OR (ch = TAB) OR (ch = CR)
                                                OR (fno # TextPrinter.FontNo(R.fnt)) OR (voff # R.voff) OR (i = LEN(s)-1);
                                s[i] := 0X;
                                IF voff # 0 THEN Printer.String(x0, y0 + dy, s, fnt.name); first := TRUE
                                ELSIF first THEN Printer.String(x0, y0 + dy, s, fnt.name); first := FALSE
                                ELSE Printer.ContString(s, fnt.name)
                                END;
                                INC(x0, w)
                        END
                END
        END PrintString;

        PROCEDURE Print* (E: Elem; pno, x0, y0: INTEGER);
                VAR row: Row; r, c, x, y, w, h, h1, lw, d: INTEGER;
        BEGIN r := E.nofRows; row := E.row; y := y0; lw := SHORT(E.lw DIV Unit); d := SHORT(E.lw * 2 DIV Unit);
                WHILE r > 0 DO DEC(r); x := x0; c := 0; h := SHORT(row.lsp DIV Unit); h1 := h;
                        IF (r = 1) & (headRow IN E.opts) & (rowL IN E.opts) THEN INC(h1, d) END;
                        WHILE c < E.nofCols DO w := SHORT(E.width[c] DIV Unit);
                                IF c = 0 THEN
                                        IF headCol IN E.opts THEN Printer.ReplConst(x + w - lw, y, lw, h);
                                                IF colL IN E.opts THEN INC(w, d) END
                                        END;
                                        IF leftL IN E.opts THEN Printer.ReplConst(x, y, lw, h1) END
                                ELSIF colL IN E.opts THEN Printer.ReplConst(x, y, lw, h)
                                END;
                                IF (c = E.nofCols - 1) & (rightL IN E.opts) THEN Printer.ReplConst(x + w - lw, y, lw, h1) END;
                                IF (r = 0) & (topL IN E.opts) OR (r = 1) & (headRow IN E.opts) THEN
                                        Printer.ReplConst(x, y + h - lw, w, lw)
                                END;
                                IF (r = E.nofRows - 1) & (botL IN E.opts) OR (r < E.nofRows - 1) & (rowL IN E.opts) THEN
                                        Printer.ReplConst(x, y, w, lw)
                                END;
                                PrintString(E, row.pos[c], pno, x + SHORT(row.x[c] DIV Unit), y + SHORT(row.y[c] DIV Unit));
                                INC(x, w); INC(c)
                        END;
                        INC(y, h1); row := row.next
                END
        END Print;


        PROCEDURE OpenViewer* (E: Elem);
                VAR V: Viewer; menu: TextFrames.Frame; body: TextFrames.Frame; x, y: INTEGER;
                        restore: Viewers.ViewerMsg;
        BEGIN Oberon.AllocateUserViewer(Oberon.Mouse.X, x, y);
                menu := TextFrames.NewMenu("TableElems.Text",  Menu);
                body := TextFrames.NewText(CopyText(E.def), 0);
                NEW(V); V.handle := MenuViewers.Handle; V.dsc := menu; V.dsc.next := body;
                V.menuH := TextFrames.menuH; V.elem := E;
                Viewers.Open(V, x, y); restore.id := Viewers.restore; V.handle(V, restore)
        END OpenViewer;

        PROCEDURE Track* (E: Elem; pos: LONGINT; keys: SET; x, y, x0, y0: INTEGER);
                VAR keysum: SET;
        BEGIN
                IF middleKey IN keys THEN keysum := keys;
                        REPEAT Input.Mouse(keys, x, y); Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, x, y);
                                keysum := keysum + keys
                        UNTIL keys = {};
                        IF keysum = {middleKey} THEN OpenViewer(E) END
                END
        END Track;


        (* handle elements *)

        PROCEDURE Handle* (E: Texts.Elem; VAR msg: Texts.ElemMsg);
                VAR e: Elem;
        BEGIN
                WITH E: Elem DO
                        WITH
                                msg: TextFrames.DisplayMsg DO
                                        IF ~msg.prepare THEN Draw(E, msg.frame, msg.X0, msg.Y0) END
                        |  msg: TextPrinter.PrintMsg DO
                                        IF ~msg.prepare THEN Print(E, msg.pno, msg.X0, msg.Y0) END
                        |  msg: Texts.IdentifyMsg DO
                                        msg.mod := "TableElems"; msg.proc := "Alloc"
                        |  msg: Texts.FileMsg DO
                                        IF msg.id = Texts.load THEN Load(E, msg.r)
                                        ELSIF msg.id = Texts.store THEN Store(E, msg.r)
                                        END
                        |  msg: Texts.CopyMsg DO
                                        NEW(e); Texts.CopyElem(E, e); Open(e, CopyText(E.def)); msg(Texts.CopyMsg).e := e
                        |  msg: TextFrames.TrackMsg DO
                                        Track(E, msg.pos, msg.keys, msg.X, msg.Y, msg.X0, msg.Y0)
                        ELSE (*ignore*)
                        END
                END
        END Handle;

        PROCEDURE Alloc*;
                VAR e: Elem;
        BEGIN NEW(e); e.handle := Handle; Texts.new := e
        END Alloc;


        (* commands *)

        PROCEDURE Insert*;      (** ["^" | name] **)
                VAR S: Texts.Scanner; text: Texts.Text; beg, end, time: LONGINT;
                        e: Elem; t: Texts.Text; m: TextFrames.InsertElemMsg;
        BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
                IF (S.class = Texts.Char) & (S.c = "^") THEN
                        Oberon.GetSelection(text, beg, end, time);
                        IF time >= 0 THEN Texts.OpenScanner(S, text, beg); Texts.Scan(S) END
                END;
                IF (S.class = Texts.Name) & (S.line = 0) THEN t := TextFrames.Text(S.s)
                ELSE t := TextFrames.Text("");
                        Texts.WriteString(W, "/table"); Texts.WriteLn(W);
                        Texts.Append(t, W.buf)
                END;
                NEW(e); e.handle := Handle; Open(e, t); m.e := e;
                Oberon.FocusViewer.handle(Oberon.FocusViewer, m)
        END Insert;

        PROCEDURE Update*;
                VAR V: Viewer; F: TextFrames.Frame;
        BEGIN V := Oberon.Par.vwr(Viewer); F := V.dsc.next(TextFrames.Frame);
                Open(V.elem, CopyText(F.text)); Changed(V.elem); UnmarkMenu(V)
        END Update;

BEGIN Texts.OpenWriter(W)
END TableElems.

(*
        Edit.Open ^     test.Txt                TableElems.Insert ^     testTable.Txt           System.Free TableElems ~
*)
