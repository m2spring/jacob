MODULE ParcElems;       (** CAS/MH/HM 12.10.1993 **)
        IMPORT
                SYSTEM, Input, Display, Files, Oberon, Fonts, Texts, TextFrames, TextPrinter;

        CONST
                (**StateMsg.id*)
                        set* = 0; get* = 1;
                mm = TextFrames.mm; unit = TextFrames.Unit; Unit = TextPrinter.Unit;
                Scale = mm DIV 10; MinTabDelta = 5*mm; ParcHeight = 3*mm; ColumnGap = 7*mm;
                gridAdj = TextFrames.gridAdj; leftAdj = TextFrames.leftAdj; rightAdj = TextFrames.rightAdj;
                pageBreak = TextFrames.pageBreak;
                twoColumns = TextFrames.twoColumns;
                AdjMask = {leftAdj, rightAdj};
                rightKey = 0; middleKey = 1; leftKey = 2; cancel = {rightKey, middleKey, leftKey};

        TYPE
                StateMsg* = RECORD (Texts.ElemMsg)
                        id*: INTEGER;
                        pos*: LONGINT;
                        frame*: TextFrames.Frame;
                        par*: Texts.Scanner;
                        log*: Texts.Text
                END;


        VAR
                W: Texts.Writer;

        PROCEDURE RdSet (VAR r: Files.Rider; VAR s: SET);
        BEGIN Files.ReadNum(r, SYSTEM.VAL(LONGINT, s))
        END RdSet;

        PROCEDURE WrtSet (VAR r: Files.Rider; s: SET);
        BEGIN Files.WriteNum(r, SYSTEM.VAL(LONGINT, s))
        END WrtSet;

        PROCEDURE Str (s: ARRAY OF CHAR);
        BEGIN Texts.WriteString(W, s)
        END Str;

        PROCEDURE Int (n: LONGINT);
        BEGIN Texts.Write(W, " "); Texts.WriteInt(W, n, 0)
        END Int;

        PROCEDURE Ln;
        BEGIN Texts.WriteLn(W)
        END Ln;


        PROCEDURE Min (x, y: LONGINT): LONGINT;
        BEGIN
                IF x < y THEN RETURN x ELSE RETURN y END
        END Min;

        PROCEDURE Max (x, y: LONGINT): LONGINT;
        BEGIN
                IF x > y THEN RETURN x ELSE RETURN y END
        END Max;


        PROCEDURE Matches (VAR S: Texts.Scanner; key: ARRAY OF CHAR): BOOLEAN;
                VAR i: INTEGER;
        BEGIN i := 0;
                WHILE (S.s[i] # 0X) & (CAP(S.s[i]) = key[i]) DO INC(i) END;
                RETURN (S.class = Texts.Name) & ((key[i] = 0X) OR (i >= 3)) & (S.s[i] = 0X)
        END Matches;

        PROCEDURE GetNextInt (VAR S: Texts.Scanner; lo, hi, def: LONGINT);      (*constrained int w/ default*)
        BEGIN Texts.Scan(S);
                IF Matches(S, "DEFAULT") THEN S.class := Texts.Int; S.i := def
                ELSIF S.class = Texts.Int THEN
                        IF (S.i < lo) OR (S.i >= hi) THEN S.i := def END
                END
        END GetNextInt;


        PROCEDURE Grid (x: LONGINT): LONGINT;
        BEGIN RETURN x + (-x) MOD (1 * mm)
        END Grid;


        PROCEDURE DrawCursor (x, y: INTEGER);
        BEGIN Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, x, y)
        END DrawCursor;

        PROCEDURE TrackMouse (VAR x, y: INTEGER; VAR keys, keysum: SET);
        BEGIN Input.Mouse(keys, x, y); DrawCursor(x, y); keysum := keysum + keys
        END TrackMouse;
(*
        PROCEDURE FlipZone (P: TextFrames.Parc; x0, y0, dw, dh, w: INTEGER);
        BEGIN
                IF dh < 4 THEN Display.ReplConst(Display.white, x0, y0, w, 4, Display.invert)
                ELSIF (dh > 4) & (12 <= dw) & (dw < P.width DIV unit - 12) THEN
                        Display.ReplConst(Display.white, x0, y0 + 5, w, 4, Display.invert)
                END
        END FlipZone;
*)
        PROCEDURE FlipZone (P: TextFrames.Parc; x0, y0, dw, dh, w: INTEGER);
                VAR pl, pf, pw: INTEGER;
        BEGIN pl := SHORT(P.left DIV unit); pf := SHORT(P.first DIV unit); pw := SHORT(P.width DIV unit);
                IF dh < 4 THEN Display.ReplConst(Display.white, x0, y0, w, 4, Display.invert)
                ELSIF (dh > 4) & (pf # 0) & (pf <= dw) & (dw < pf + 4) THEN
                        Display.ReplConst(Display.white, x0 - pl, y0 + 5, w + pl, 4, Display.invert)
                ELSIF (dh > 4) & (12 <= dw) & (dw < pw - 12) THEN
                        Display.ReplConst(Display.white, x0, y0 + 5, w, 4, Display.invert)
                END
        END FlipZone;

        PROCEDURE FirstMark (col: SHORTINT; x, y0: INTEGER);
        BEGIN Display.ReplConst(col, x, y0 + 5, 3, 4, Display.replace)
        END FirstMark;

        PROCEDURE AdjMark (F: Display.Frame; col: SHORTINT; x, y0: INTEGER);
        BEGIN Display.ReplPatternC(F, col, Display.grey1, x, y0 + 6, 11, 3, x, y0 + 5, Display.replace)
        END AdjMark;

        PROCEDURE FlipFirst (P: TextFrames.Parc; x0, y0: INTEGER);
        BEGIN Display.ReplConst(Display.white, x0 + SHORT((P.left + P.first) DIV unit), y0 + 5, 3, 4, Display.invert)
        END FlipFirst;

        PROCEDURE MoveFirst (P: TextFrames.Parc; x0, y0, dw: INTEGER);
                VAR px: LONGINT;
        BEGIN px := Grid(LONG(dw) * unit);
                IF (px # P.first) & (-P.left <= px) & (px < P.width) THEN
                        FlipFirst(P, x0, y0); P.first := px; FlipFirst(P, x0, y0)
                END
        END MoveFirst;

        PROCEDURE FlipLeft (P: TextFrames.Parc; x0, y0: INTEGER);
        BEGIN Display.ReplConst(Display.white, x0 + SHORT(P.left DIV unit), y0 + 4, 12, 5, Display.invert)
        END FlipLeft;

        PROCEDURE MoveLeft (P: TextFrames.Parc; rm: LONGINT; x0, y0, dw: INTEGER);
                VAR px: LONGINT;
        BEGIN px := Grid(LONG(dw) * unit);
                IF (px # P.left) & (0 <= px) & (px < rm) THEN FlipLeft(P, x0, y0); P.left := px; FlipLeft(P, x0, y0) END
        END MoveLeft;

        PROCEDURE FlipRight (P: TextFrames.Parc; x0, y0: INTEGER);
        BEGIN Display.ReplConst(Display.white, x0 + SHORT((P.left + P.width) DIV unit) - 12, y0 + 4, 12, 5, Display.invert)
        END FlipRight;

        PROCEDURE MoveRight (P: TextFrames.Parc; rm: LONGINT; x0, y0, dw: INTEGER);
                VAR px: LONGINT;
        BEGIN px := Grid(LONG(dw) * unit);
                IF (px # P.left + P.width) & (P.left + 10*mm <= px) & (px < rm) THEN
                        FlipRight(P, x0, y0); P.width := px - P.left; FlipRight(P, x0, y0)
                END
        END MoveRight;


        PROCEDURE TabMark (col: SHORTINT; x, y: INTEGER);
        BEGIN Display.ReplConst(col, x, y + 1, 2, 3, Display.replace)
        END TabMark;

        PROCEDURE FlipTab (P: TextFrames.Parc; i, x0, y0: INTEGER);
        BEGIN Display.ReplConst(Display.white, x0 + SHORT(P.tab[i] DIV unit), y0 + 1, 2, 3, Display.invert)
        END FlipTab;

        PROCEDURE GrabTab (P: TextFrames.Parc; x0, y0, dw: INTEGER; VAR i: INTEGER; VAR new: BOOLEAN);
                VAR j: INTEGER; lx, px, rx: LONGINT;
        BEGIN
                i := 0; j := P.nofTabs; new := FALSE; px := Grid(LONG(dw) * unit);
                WHILE (i < j) & (P.tab[i] < px - 1*mm) DO INC(i) END;
                IF i < TextFrames.MaxTabs THEN
                        IF (i = j) OR (P.tab[i] >= px + 1*mm) THEN
                                IF i = 0 THEN lx := MinTabDelta ELSE lx := P.tab[i - 1] + MinTabDelta END;
                                IF i = P.nofTabs THEN rx := P.width ELSE rx := P.tab[i] - MinTabDelta END;
                                IF px < lx THEN px := lx END;
                                IF px < rx THEN INC(P.nofTabs); new := TRUE;
                                        WHILE j > i DO P.tab[j] := P.tab[j - 1]; DEC(j) END
                                END
                        ELSE px := P.tab[i]
                        END
                ELSE DEC(i); px := P.tab[i]
                END;
                IF ~new THEN FlipTab(P, i, x0, y0) END;
                P.tab[i] := px; FlipTab(P, i, x0, y0)
        END GrabTab;

        PROCEDURE MoveTab (P: TextFrames.Parc; rm: LONGINT; i, x0, y0, dw: INTEGER);
                VAR lx, px, rx: LONGINT;
        BEGIN px := Grid(LONG(dw) * unit);
                IF i = 0 THEN lx := MinTabDelta ELSE lx := P.tab[i - 1] + MinTabDelta END;
                IF i = P.nofTabs - 1 THEN rx := P.width ELSE rx := P.tab[i + 1] - MinTabDelta END;
                IF (px # P.tab[i]) & (lx <= px) & (px <= rx) & (px <= rm) THEN
                        FlipTab(P, i, x0, y0); P.tab[i] := px; FlipTab(P, i, x0, y0)
                END
        END MoveTab;

        PROCEDURE RemoveTab (P: TextFrames.Parc; i: INTEGER);
        BEGIN
                WHILE i < P.nofTabs - 1 DO P.tab[i] := P.tab[i + 1]; INC(i) END;
                DEC(P.nofTabs)
        END RemoveTab;


        PROCEDURE Changed (E: Texts.Elem; beg: LONGINT);
                VAR T: Texts.Text;
        BEGIN T := Texts.ElemBase(E); Texts.ChangeLooks(T, beg, beg+1, {}, NIL, 0, 0)
        END Changed;


        PROCEDURE ParcExtent* (T: Texts.Text; beg: LONGINT; VAR end: LONGINT);
                VAR R: Texts.Reader;
        BEGIN Texts.OpenReader(R, T, beg + 1);
                REPEAT Texts.ReadElem(R) UNTIL R.eot OR (R.elem IS TextFrames.Parc);
                IF R.eot THEN end := T.len ELSE end := Texts.Pos(R) - 1 END
        END ParcExtent;

        PROCEDURE ChangedParc* (P: TextFrames.Parc; beg: LONGINT);
                VAR T: Texts.Text; end: LONGINT;
        BEGIN T := Texts.ElemBase(P); ParcExtent(T, beg, end); Texts.ChangeLooks(T, beg, end, {}, NIL, 0, 0)
        END ChangedParc;


        PROCEDURE LoadParc* (P: TextFrames.Parc; VAR r: Files.Rider);
                VAR version, i, j, k: LONGINT;
        BEGIN Files.ReadNum(r, version);        (*version 1*)
                Files.ReadNum(r, P.first); Files.ReadNum(r, P.left); Files.ReadNum(r, P.width);
                Files.ReadNum(r, P.lead); Files.ReadNum(r, P.lsp); Files.ReadNum(r, P.dsr);
                RdSet(r, P.opts); Files.ReadNum(r, i);
                IF i <= TextFrames.MaxTabs THEN P.nofTabs := SHORT(i) ELSE P.nofTabs := TextFrames.MaxTabs END;
                j := 0; WHILE j < P.nofTabs DO Files.ReadNum(r, P.tab[j]); INC(j) END;
                WHILE j < i DO Files.ReadNum(r, k); INC(j) END;
        END LoadParc;

        PROCEDURE StoreParc* (P: TextFrames.Parc; VAR r: Files.Rider);
                VAR i: INTEGER;
        BEGIN Files.WriteNum(r, 1);     (*version 1*)
                Files.WriteNum(r, P.first); Files.WriteNum(r, P.left); Files.WriteNum(r, P.width);
                Files.WriteNum(r, P.lead); Files.WriteNum(r, P.lsp); Files.WriteNum(r, P.dsr);
                WrtSet(r, P.opts); Files.WriteNum(r, P.nofTabs); i := 0;
                WHILE i < P.nofTabs DO Files.WriteNum(r, P.tab[i]); INC(i) END
        END StoreParc;

        PROCEDURE CopyParc* (SP, DP: TextFrames.Parc);
                VAR i: INTEGER;
        BEGIN Texts.CopyElem(SP, DP);
                DP.first := SP.first; DP.left := SP.left; DP.width := SP.width;
                DP.lead := SP.lead; DP.lsp := SP.lsp; DP.dsr := SP.dsr;
                DP.opts := SP.opts; DP.nofTabs := SP.nofTabs; i := SP.nofTabs;
                WHILE i > 0 DO DEC(i); DP.tab[i] := SP.tab[i] END
        END CopyParc;


        PROCEDURE Prepare* (P: TextFrames.Parc; indent, unit: LONGINT);
        BEGIN P.W := 9999 * unit; P.H := ParcHeight + P.lead;
                IF gridAdj IN P.opts THEN INC(P.H, (-P.lead) MOD P.lsp) END
        END Prepare;

        PROCEDURE Draw* (P: TextFrames.Parc; F: Display.Frame; col: SHORTINT; x0, y0: INTEGER);
                VAR i, x1, px, w, n: INTEGER;
        BEGIN x1 := x0 + SHORT(P.left DIV unit); w := SHORT((P.W - P.left) DIV unit);
                IF twoColumns IN P.opts THEN n := 2 ELSE n := 1 END;
                WHILE n > 0 DO DEC(n);
                        IF w > 20 THEN i := 0;
                                LOOP
                                        IF i = P.nofTabs THEN EXIT END;
                                        px := SHORT(x1 + P.tab[i] DIV unit);
                                        IF px > x1 + w THEN EXIT END;
                                        TabMark(col, px, y0); INC(i)
                                END;
                                IF pageBreak IN P.opts THEN Display.ReplConst(col, x1, y0 + 4, w, 1, Display.replace)
                                ELSE Display.ReplPatternC(F, col, Display.grey1, x1, y0 + 4, w, 1, x1, y0 + 4, Display.replace)
                                END;
                                IF leftAdj IN P.opts THEN AdjMark(F, col, x1, y0) END;
                                IF rightAdj IN P.opts THEN AdjMark(F, col, x1 + w - 11, y0) END;
                                IF P.opts * AdjMask = {} THEN AdjMark(F, col, x1 + w DIV 2 - 5, y0) END;
                                IF P.first # 0 THEN FirstMark(col, x0 + SHORT((P.left + P.first) DIV unit), y0) END;
                                WITH F: TextFrames.Frame DO     (*recalc base measures for second column*)
                                        x0 := SHORT(Max( x1 + w + ColumnGap DIV unit, x0 + (F.W - F.left - F.right + ColumnGap DIV unit) DIV 2 ));
                                        x1 := x0 + SHORT(P.left DIV unit);
                                        w := SHORT(Min( (F.X + F.W - F.right) - x1, (P.W - P.left) DIV unit ))
                                END
                        END
                END
        END Draw;


        PROCEDURE Edit* (P: TextFrames.Parc; F: TextFrames.Frame; pos: LONGINT; x0, y0, x, y : INTEGER; keysum: SET);
                VAR keys: SET; old, rx: LONGINT; i, x1, dw, dh, dx, w, h: INTEGER; changed, new: BOOLEAN;
        BEGIN
                IF (middleKey IN keysum) & F.showsParcs THEN changed := FALSE;
                        x1 := x0 + SHORT(P.left DIV unit); w := SHORT((P.W - P.left) DIV unit); h := SHORT(P.H DIV unit);
                        dh := y - y0; dw := x - x1;
                        Oberon.RemoveMarks(x0, y0, SHORT(P.W DIV unit), h); FlipZone(P, x1, y0, dw, dh, w);
                        IF (dw >= 0) & (dh < 4) THEN
                                IF dw > 0 THEN changed := TRUE; GrabTab(P, x1, y0, x - x1, i, new); old := P.tab[i];
                                        rx := LONG(F.W - F.left - F.right) * unit - P.left; dx := dw - SHORT(old DIV unit);
                                        REPEAT TrackMouse(x, y, keys, keysum); MoveTab(P, rx, i, x1, y0, (x - x1) - dx) UNTIL keys = {};
                                        IF keysum = {middleKey} THEN FlipTab(P, i, x1, y0)
                                        ELSIF keysum = {middleKey, rightKey} THEN FlipTab(P, i, x1, y0); rx := P.tab[i] - old;
                                                WHILE i < P.nofTabs-1 DO INC(i); INC(P.tab[i], rx) END
                                        ELSIF new OR (keysum = {middleKey, leftKey}) THEN RemoveTab(P, i)
                                        ELSE changed := FALSE; FlipTab(P, i, x1, y0); P.tab[i] := old; FlipTab(P, i, x1, y0)
                                        END
                                END
                        ELSIF (P.first # 0) & (P.first DIV unit <= dw) & (dw < P.first DIV unit + 4) & (dh > 4) THEN
                                old := P.first; dx := dw - SHORT(P.first DIV unit);
                                REPEAT TrackMouse(x, y, keys, keysum); MoveFirst(P, x0, y0, (x - x1) - dx) UNTIL keys = {};
                                IF keysum # cancel THEN changed := TRUE;
                                        IF keysum = {middleKey, leftKey} THEN P.first := 0 END;
                                ELSE FlipFirst(P, x0, y0); P.first := old; FlipFirst(P, x0, y0)
                                END
                        ELSIF (dw >= 0) & (dh > 4) THEN
                                IF dw < 12 THEN
                                        IF P.left DIV unit < F.W - F.left - F.right THEN FlipLeft(P, x0, y0); old := P.left;
                                                rx := P.left + P.width - 10*mm;
                                                REPEAT TrackMouse(x, y, keys, keysum); MoveLeft(P, rx, x0, y0, (x - x0) - dw) UNTIL keys = {};
                                                IF keysum = {middleKey} THEN DEC(P.width, P.left - old); changed := TRUE
                                                ELSIF (keysum = {middleKey, rightKey}) & (P.width - 2*(P.left - old) >= 10*mm) THEN
                                                        DEC(P.width, 2*(P.left - old)); changed := TRUE
                                                ELSIF keysum = {middleKey, leftKey} THEN P.first := P.left - old; P.left := old; changed := TRUE
                                                ELSE FlipLeft(P, x0, y0); P.left := old
                                                END;
                                                IF P.left + P.first < 0 THEN P.first := -P.left; changed := TRUE
                                                ELSIF P.left + P.first > P.left + P.width THEN P.first := P.width; changed := TRUE
                                                END
                                        END
                                ELSIF dw >= P.width DIV unit - 12 THEN FlipRight(P, x0, y0); old := P.width;
                                        rx := LONG(F.W - F.left - F.right) * unit; dx := dw - SHORT(P.width DIV unit);
                                        REPEAT TrackMouse(x, y, keys, keysum); MoveRight(P, rx, x0, y0, (x - x0) - dx) UNTIL keys = {};
                                        IF keysum = {middleKey} THEN changed := TRUE
                                        ELSIF (keysum = {middleKey, rightKey})
                                        & (P.left + old - P.width >= 0) & (P.width - (old - P.width) >= 10*mm) THEN
                                                INC(P.left, old - P.width); DEC(P.width, old - P.width); changed := TRUE
                                        ELSE FlipRight(P, x0, y0); P.width := old
                                        END;
                                        IF P.left + P.first < 0 THEN P.first := -P.left; changed := TRUE
                                        ELSIF P.left + P.first > P.left + P.width THEN P.first := P.width; changed := TRUE
                                        END
                                ELSE changed := TRUE;
                                        REPEAT TrackMouse(x, y, keys, keysum) UNTIL keys = {};
                                        IF keysum = {middleKey} THEN dw := x - x1;
                                                IF (dw < w DIV 3) & (P.opts * AdjMask # {leftAdj}) THEN P.opts := P.opts - AdjMask + {leftAdj}
                                                ELSIF (w DIV 3 <= dw) & (dw < 2 * w DIV 3) & (P.opts * AdjMask # {}) THEN
                                                        P.opts := P.opts - AdjMask
                                                ELSIF (2 * w DIV 3 <= dw) & (P.opts * AdjMask # {rightAdj}) THEN
                                                        P.opts := P.opts - AdjMask + {rightAdj}
                                                ELSE changed := FALSE
                                                END
                                        ELSIF (keysum = {middleKey, leftKey}) & (P.opts * AdjMask # AdjMask) THEN
                                                P.opts := P.opts + AdjMask
                                        ELSIF keysum = {middleKey, rightKey} THEN P.opts := P.opts / {twoColumns};
                                                IF twoColumns IN P.opts THEN P.width := (P.width - ColumnGap) DIV 2
                                                ELSE P.width := P.width * 2 + ColumnGap
                                                END
                                        ELSE changed := FALSE
                                        END
                                END
                        END;
                        IF changed THEN ChangedParc(P, pos) ELSE FlipZone(P, x1, y0, dw, dh, w) END
                END
        END Edit;


        PROCEDURE SetAttr* (P: TextFrames.Parc; F: TextFrames.Frame; pos: LONGINT;
                                                                        VAR S: Texts.Scanner; log: Texts.Text);
                VAR fnt: Fonts.Font; def, pt, lsp, dsr: LONGINT;

                PROCEDURE SetMeasure (new: LONGINT; VAR old: LONGINT);
                BEGIN
                        IF new # old THEN old := new; ChangedParc(P, pos) END
                END SetMeasure;

                PROCEDURE SetOpts (opts: SET);
                BEGIN
                        IF P.opts #opts THEN P.opts := opts; ChangedParc(P, pos) END
                END SetOpts;

                PROCEDURE Err (s: ARRAY OF CHAR; n: INTEGER);
                BEGIN Str("Set "); Str(s); Str(" failed (bad ");
                        CASE n OF
                                0: Str("number)")
                        |  1: Str("indentation)")
                        |  2: Str("option)")
                        |  3: Str("selector)")
                        END;
                        Ln
                END Err;
        BEGIN
                IF Matches(S, "LEAD") THEN def := TextFrames.defParc.lead DIV Scale;
                        GetNextInt(S, 0, 10000, def);
                        IF S.class = Texts.Int THEN SetMeasure(S.i * Scale, P.lead)
                        ELSIF S.class = Texts.Name THEN fnt := Fonts.This(S.s);
                                lsp := Max(fnt.height, fnt.maxY - fnt.minY) * unit; INC(lsp, (-lsp) MOD Scale);
                                SetMeasure(lsp, P.lead)
                        ELSE Err("lead", 0)
                        END
                ELSIF Matches(S, "LINE") THEN def := TextFrames.defParc.lsp DIV Scale;
                        GetNextInt(S, 10, 10000, def);
                        IF S.class = Texts.Int THEN lsp := S.i * Scale; dsr := lsp DIV 4; INC(dsr, (-dsr) MOD Scale)
                        ELSIF S.class = Texts.Name THEN fnt := Fonts.This(S.s);
                                lsp := Max(fnt.height, fnt.maxY - fnt.minY) * unit; INC(lsp, (-lsp) MOD Scale);
                                dsr := LONG(-fnt.minY) * unit; INC(dsr, (-dsr) MOD Scale)
                        ELSE Err("line", 0); lsp := P.lsp; dsr := P.dsr
                        END;
                        IF (P.lsp # lsp) OR (P.dsr # dsr) THEN P.lsp := lsp; P.dsr := dsr; ChangedParc(P, pos) END
                ELSIF Matches(S, "FIRST") THEN def := TextFrames.defParc.first DIV Scale;
                        GetNextInt(S, -10000, 10000, def);
                        IF S.class = Texts.Int THEN
                                IF (0 <= P.left + S.i * Scale) & (P.left + S.i * Scale <= P.left + P.width) THEN SetMeasure(S.i * Scale, P.first)
                                ELSE Err("first", 1)
                                END
                        ELSE Err("first", 0)
                        END
                ELSIF Matches(S, "LEFT") THEN def := TextFrames.defParc.left DIV Scale;
                        GetNextInt(S, 0, 10000, def);
                        IF S.class = Texts.Int THEN
                                IF S.i * Scale # P.left THEN INC(P.width, P.left - S.i * Scale);
                                        P.left := S.i * Scale; ChangedParc(P, pos)
                                END;
                        ELSE Err("left", 0)
                        END
                ELSIF Matches(S, "RIGHT") THEN def := (TextFrames.defParc.left + TextFrames.defParc.width) DIV Scale;
                        GetNextInt(S, 0, 10000, def);
                        IF S.class = Texts.Int THEN SetMeasure(S.i * Scale - P.left, P.width)
                        ELSE Err("right", 0)
                        END
                ELSIF Matches(S, "WIDTH") THEN def := TextFrames.defParc.width DIV Scale;
                        GetNextInt(S, 100, 10000, def);
                        IF S.class = Texts.Int THEN SetMeasure(S.i * Scale, P.width)
                        ELSE Err("width", 0)
                        END
                ELSIF Matches(S, "GRID") THEN Texts.Scan(S);
                        IF Matches(S, "ON") THEN SetOpts(P.opts + {gridAdj})
                        ELSIF Matches(S, "OFF") THEN SetOpts(P.opts - {gridAdj})
                        ELSE Err("grid", 2)
                        END
                ELSIF Matches(S, "ADJUST") THEN Texts.Scan(S);
                        IF Matches(S, "LEFT") THEN SetOpts(P.opts - AdjMask + {leftAdj})
                        ELSIF Matches(S, "RIGHT") THEN SetOpts(P.opts - AdjMask + {rightAdj})
                        ELSIF Matches(S, "CENTER") THEN SetOpts(P.opts - AdjMask)
                        ELSIF Matches(S, "BLOCK") THEN SetOpts(P.opts + AdjMask)
                        ELSE Err("adjust", 2)
                        END
                ELSIF Matches(S, "BREAK") THEN Texts.Scan(S);
                        IF Matches(S, "BEFORE") THEN SetOpts(P.opts + {pageBreak})
                        ELSIF Matches(S, "NORMAL") THEN SetOpts(P.opts - {pageBreak})
                        ELSE Err("break", 2)
                        END
                ELSIF Matches(S, "COLUMNS") THEN GetNextInt(S, 1, 3, 1);
                        IF S.class = Texts.Int THEN
                                IF S.i = 1 THEN SetOpts(P.opts - {twoColumns})
                                ELSE SetOpts(P.opts + {twoColumns})
                                END
                        ELSE Err("left", 0)
                        END
                ELSIF Matches(S, "TABS") THEN Texts.Scan(S); P.nofTabs := 0; pt := 0;
                        IF (S.class = Texts.Char) & (S.c = "*") THEN Texts.Scan(S);
                                IF (S.class = Texts.Int) & (S.i * Scale >= MinTabDelta) THEN
                                        WHILE (P.nofTabs < TextFrames.MaxTabs) & (pt < 3000) DO
                                                INC(pt, S.i); P.tab[P.nofTabs] := pt * Scale; INC(P.nofTabs)
                                        END
                                END
                        ELSE
                                WHILE (S.class = Texts.Int) & (S.i * Scale >= pt * Scale + MinTabDelta)
                                & (P.nofTabs < TextFrames.MaxTabs) DO
                                        pt := S.i; P.tab[P.nofTabs] := pt * Scale; INC(P.nofTabs); Texts.Scan(S)
                                END
                        END;
                        ChangedParc(P, pos)
                ELSE Err("", 3)
                END;
                IF W.buf.len # 0 THEN Texts.Append(log, W.buf) END
        END SetAttr;


        PROCEDURE GetAttr* (P: TextFrames.Parc; F: TextFrames.Frame; VAR S: Texts.Scanner; log: Texts.Text);
                VAR n: INTEGER;

                PROCEDURE Out (n: INTEGER);
                        VAR i: INTEGER; d: LONGINT;
                BEGIN
                        CASE n OF
                                0: Str("lead"); Int(P.lead DIV Scale)
                        |  1: Str("line"); Int(P.lsp DIV Scale)
                        |  2: Str("left"); Int(P.left DIV Scale)
                        |  3: Str("first"); Int(P.first DIV Scale)
                        |  4: Str("width"); Int(P.width DIV Scale)
                        |  5: Str("right"); Int((P.left + P.width) DIV Scale)
                        |  6: IF gridAdj IN P.opts THEN Str("grid on") ELSE Str("grid off") END
                        |  7:
                                        IF leftAdj IN P.opts THEN
                                                IF rightAdj IN P.opts THEN Str("adjust block") ELSE Str("adjust left") END
                                        ELSIF rightAdj IN P.opts THEN Str("adjust right")
                                        ELSE Str("adjust center")
                                        END
                        |  8: IF pageBreak IN P.opts THEN Str("break before") ELSE Str("break normal") END
                        |  9: IF twoColumns IN P.opts THEN Str("columns 2") ELSE Str("columns 1") END
                        | 10: Str("tabs"); i := 0;
                                        IF P.nofTabs > 0 THEN d := P.tab[0]; i := 1;
                                                WHILE (i < P.nofTabs) & (P.tab[i] - P.tab[i - 1] = d) DO INC(i) END
                                        END;
                                        IF (P.nofTabs > 1) & (i = P.nofTabs) & (P.tab[i - 1] + MinTabDelta > P.width) THEN
                                                Str(" *"); Int(d DIV Scale)
                                        ELSE i := 0;
                                                WHILE i < P.nofTabs DO Int(P.tab[i] DIV Scale); INC(i) END;
                                                Str(" ~")
                                        END
                        END
                END Out;
        BEGIN
                IF S.class # Texts.Name THEN Out(0); n := 1;
                        REPEAT Ln; Out(n); INC(n) UNTIL n = 11
                ELSIF Matches(S, "LEAD") THEN Out(0)
                ELSIF Matches(S, "LINE") THEN Out(1)
                ELSIF Matches(S, "LEFT") THEN Out(2)
                ELSIF Matches(S, "FIRST") THEN Out(3)
                ELSIF Matches(S, "WIDTH") THEN Out(4)
                ELSIF Matches(S, "RIGHT") THEN Out(5)
                ELSIF Matches(S, "GRID") THEN Out(6)
                ELSIF Matches(S, "ADJUST") THEN Out(7)
                ELSIF Matches(S, "BREAK") THEN Out(8)
                ELSIF Matches(S, "COLUMNS") THEN Out(9)
                ELSIF Matches(S, "TABS") THEN Out(10)
                ELSE Str("failed (bad selector)")
                END;
                Texts.Append(log, W.buf)
        END GetAttr;


        PROCEDURE Handle* (E: Texts.Elem; VAR msg: Texts.ElemMsg);
                VAR e: TextFrames.Parc;
        BEGIN
                WITH E: TextFrames.Parc DO
                        IF msg IS TextFrames.DisplayMsg THEN
                                WITH msg: TextFrames.DisplayMsg DO
                                        IF msg.prepare THEN Prepare(E, msg.indent, unit)
                                        ELSE Draw(E, msg.frame, msg.col, msg.X0, msg.Y0)
                                        END
                                END
                        ELSIF msg IS TextPrinter.PrintMsg THEN
                                WITH msg: TextPrinter.PrintMsg DO
                                        IF msg.prepare THEN Prepare(E, msg.indent, Unit) END
                                END
                        ELSIF msg IS Texts.CopyMsg THEN NEW(e); CopyParc(E, e); msg(Texts.CopyMsg).e := e
                        ELSIF msg IS TextFrames.TrackMsg THEN
                                WITH msg: TextFrames.TrackMsg DO
                                        Edit(E, msg.frame(TextFrames.Frame), msg.pos, msg.X0, msg.Y0, msg.X, msg.Y, msg.keys)
                                END
                        ELSIF msg IS Texts.IdentifyMsg THEN
                                WITH msg: Texts.IdentifyMsg DO msg.mod := "ParcElems"; msg.proc := "Alloc" END
                        ELSIF msg IS Texts.FileMsg THEN
                                WITH msg: Texts.FileMsg DO
                                        IF msg.id = Texts.load THEN LoadParc(E, msg.r)
                                        ELSIF msg.id = Texts.store THEN StoreParc(E, msg.r)
                                        END
                                END
                        ELSIF msg IS StateMsg THEN
                                WITH msg: StateMsg DO
                                        IF msg.id = set THEN SetAttr(E, msg.frame, msg.pos, msg.par, msg.log)
                                        ELSIF msg.id = get THEN GetAttr(E, msg.frame, msg.par, msg.log)
                                        END
                                END
                        END
                END
        END Handle;


        PROCEDURE Alloc*;
                VAR e: TextFrames.Parc;
        BEGIN NEW(e); e.handle := Handle; Texts.new := e
        END Alloc;

        PROCEDURE InitDefParc (VAR def: TextFrames.Parc);
                VAR h, lsp, dsr: LONGINT; i: INTEGER;
        BEGIN
                lsp := Max(Fonts.Default.height, Fonts.Default.maxY - Fonts.Default.minY) * unit;
                dsr := LONG(-Fonts.Default.minY) * unit;
                NEW(def); def.W := 99; def.H := ParcHeight; def.handle := Handle;
                def.first := 0; def.left := 0; (*def.width := 165*mm;*)
                def.width := Max(165*mm, ((Display.Width DIV 8 * 5) - TextFrames.left - TextFrames.right - 2) * LONG(unit));
                def.lead := 0; def.lsp := lsp + (-lsp) MOD Scale; def.dsr := dsr + (-dsr) MOD Scale;
                def.opts := {leftAdj}; def.nofTabs := 0
        END InitDefParc;

BEGIN Texts.OpenWriter(W); InitDefParc(TextFrames.defParc)
END ParcElems.
