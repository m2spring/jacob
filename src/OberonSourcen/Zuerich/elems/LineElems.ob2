MODULE LineElems;       (** CAS 15-Oct-91 / 28-Sep-93 **)
        (* mh 12.1.93: elimination of WriteNum, ReadNum for Oberon V2.2 *)
        IMPORT
                SYSTEM, Input, Display, Viewers, Files, Fonts, Printer, Texts, Oberon,
                TextFrames, TextPrinter;

        CONST
                autoVOpt* = 0; tabVOpt* = 1; autoHOpt* = 2; doubleOpt* = 3;
                mm = TextFrames.mm; Scale = mm DIV 10;
                unit = TextFrames.Unit; Unit = TextPrinter.Unit;
                MinW = unit; MinH = 1*Scale;

        TYPE
                Elem* = POINTER TO ElemDesc;
                ElemDesc* = RECORD(Texts.ElemDesc)
                        opts*: SET;
                        h: LONGINT      (*used to cache true height of hair lines*)
                END;


        PROCEDURE Max(x, y: LONGINT): LONGINT;
        BEGIN
                IF x > y THEN RETURN x ELSE RETURN y END
        END Max;


        (* portable I/O *)

        PROCEDURE WriteSet (VAR r: Files.Rider; s: SET);
        BEGIN Files.WriteNum(r, SYSTEM.VAL(LONGINT, s))
        END WriteSet;

        PROCEDURE ReadSet (VAR r: Files.Rider; VAR s: SET);
        BEGIN Files.ReadNum(r, SYSTEM.VAL(LONGINT, s))
        END ReadSet;


        (* handle line elements *)

        PROCEDURE Prepare* (E: Elem; pos, indent: LONGINT; printing: BOOLEAN);
                VAR P: TextFrames.Parc; pbeg: LONGINT; i: INTEGER;
        BEGIN TextFrames.ParcBefore(Texts.ElemBase(E), pos, P, pbeg);
                IF autoVOpt IN E.opts THEN E.W := Max(P.width - indent, MinW)
                ELSIF tabVOpt IN E.opts THEN i := 0;
                        WHILE (i < P.nofTabs) & (P.tab[i] - indent < 5*Scale) DO INC(i) END;
                        IF i < P.nofTabs THEN E.W := P.tab[i] - indent ELSE E.W := MinW END
                END;
                IF autoHOpt IN E.opts THEN E.h := Max(P.lsp, MinH) END;
                IF printing THEN E.H := E.h
                ELSE
                        IF doubleOpt IN E.opts THEN E.H := Max(E.h, 3*unit) ELSE E.H := Max(E.h, unit) END
                END
        END Prepare;

        PROCEDURE Draw* (E: Elem; x0, y0: INTEGER; col: SHORTINT);
                VAR w, h: INTEGER;
        BEGIN w := SHORT(Max(E.W, unit) DIV unit); h := SHORT(E.H DIV unit);
                IF doubleOpt IN E.opts THEN h := SHORT(Max(1, h DIV 3));
                        Display.ReplConst(col, x0, y0 + 2 * h, w, h, Display.replace)
                END;
                Display.ReplConst(col, x0, y0, w, h, Display.replace)
        END Draw;

        PROCEDURE Print* (E: Elem; x0, y0: INTEGER; col: SHORTINT);
                VAR w, h: INTEGER;
        BEGIN w := SHORT(E.W DIV Unit); h := SHORT(E.H DIV Unit);
                IF doubleOpt IN E.opts THEN h := SHORT(Max(1, h DIV 3));
                        Printer.ReplConst(x0, y0 + SHORT(Max(4, 3 * h)), w, h)
                END;
                Printer.ReplConst(x0, y0, w, h)
        END Print;

        PROCEDURE Load* (E: Elem; VAR r: Files.Rider);
        BEGIN ReadSet(r, E.opts); Files.ReadNum(r, E.h)
        END Load;

        PROCEDURE Store* (E: Elem; VAR r: Files.Rider);
        BEGIN WriteSet(r, E.opts); Files.WriteNum(r, E.h)
        END Store;

        PROCEDURE Copy* (SE, DE: Elem);
        BEGIN Texts.CopyElem(SE, DE); DE.opts := SE.opts; DE.h := SE.h
        END Copy;


        PROCEDURE Handle* (E: Texts.Elem; VAR msg: Texts.ElemMsg);
                VAR e: Elem;
        BEGIN
                WITH E: Elem DO
                        IF msg IS TextFrames.DisplayMsg THEN
                                WITH msg: TextFrames.DisplayMsg DO
                                        IF msg.prepare THEN Prepare(E, msg.pos, msg.indent, FALSE)
                                        ELSE Draw(E, msg.X0, msg.Y0, msg.col)
                                        END
                                END
                        ELSIF msg IS TextPrinter.PrintMsg THEN
                                WITH msg: TextPrinter.PrintMsg DO
                                        IF msg.prepare THEN Prepare(E, msg.pos, msg.indent, TRUE)
                                        ELSE Print(E, msg.X0, msg.Y0, msg.col)
                                        END
                                END
                        ELSIF msg IS Texts.IdentifyMsg THEN
                                WITH msg: Texts.IdentifyMsg DO msg.mod := "LineElems"; msg.proc := "Alloc" END
                        ELSIF msg IS Texts.FileMsg THEN
                                WITH msg: Texts.FileMsg DO
                                        IF msg.id = Texts.load THEN Load(E, msg.r)
                                        ELSIF msg.id = Texts.store THEN Store(E, msg.r)
                                        END
                                END
                        ELSIF msg IS Texts.CopyMsg THEN NEW(e); Copy(E, e); msg(Texts.CopyMsg).e := e
                        END
                END
        END Handle;


        PROCEDURE Alloc*;
                VAR e: Elem;
        BEGIN NEW(e); e.handle := Handle; Texts.new := e
        END Alloc;


        PROCEDURE Insert*;      (** "^" | ( ("auto" | "tab" | W) ("auto" | H) ["double"] ) **)
                VAR S: Texts.Scanner; w, h: LONGINT; opts: SET; ok: BOOLEAN;
                        text: Texts.Text; beg, end, time: LONGINT; e: Elem; m: TextFrames.InsertElemMsg;
        BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
                IF (S.line = 0) & (S.class = Texts.Char) & (S.c = "^") THEN
                        Oberon.GetSelection(text, beg, end, time);
                        IF time >= 0 THEN Texts.OpenScanner(S, text, beg); Texts.Scan(S) END
                END;
                opts := {}; ok := TRUE;
                IF (S.line = 0) & (S.class = Texts.Name) & (S.s = "auto") THEN INCL(opts, autoVOpt); w := MinW
                ELSIF (S.line = 0) & (S.class = Texts.Name) & (S.s = "tab") THEN INCL(opts, tabVOpt); w := MinW
                ELSIF (S.line = 0) & (S.class = Texts.Int) & (1 <= S.i) & (S.i <= 10000) THEN w := S.i * Scale
                ELSE ok := FALSE
                END;
                Texts.Scan(S);
                IF (S.line = 0) & (S.class = Texts.Name) & (S.s = "auto") THEN INCL(opts, autoHOpt); h := MinH
                ELSIF (S.line = 0) & (S.class = Texts.Int) & (1 <= S.i) & (S.i <= 100) THEN h := S.i * Scale
                ELSE ok := FALSE
                END;
                Texts.Scan(S);
                IF (S.line = 0) & (S.class = Texts.Name) & (S.s = "double") THEN INCL(opts, doubleOpt); h := 3 * h END;
                IF ok THEN NEW(e); e.W := w; e.H := h; e.handle := Handle; e.opts := opts; e.h := h; m.e := e;
                        Oberon.FocusViewer.handle(Oberon.FocusViewer, m)
                END
        END Insert;

END LineElems.

(*

        LineElems.Insert ^
                auto auto double        tab auto double 3 auto double
                auto 6 double   tab 1 double    1 1 double
                auto auto       tab auto        3 auto
                auto 1  tab 1   1 1

*)
