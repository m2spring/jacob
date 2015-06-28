MODULE StyleElems;      (** CAS 19-May-92 / 28-Sep-93 **)
        IMPORT
                Display, Files, Fonts, Viewers, Texts, Oberon, MenuViewers, TextFrames, ParcElems;

        CONST
                search* = 0; change* = 1; rename* = 2;
                NameFont = "Syntax8.Scn.Fnt";
                rightKey = 0; middleKey = 1; leftKey = 2; cancel = {rightKey, middleKey, leftKey};
                pageBreak = TextFrames.pageBreak;
                unit = TextFrames.Unit;

        TYPE
                Name* = ARRAY 32 OF CHAR;

                Parc* = POINTER TO ParcDesc;
                ParcDesc* = RECORD (TextFrames.ParcDesc)
                        name*: Name;
                        home: Texts.Text
                END;

                UpdateMsg* = RECORD (Texts.ElemMsg)
                        id*: INTEGER;
                        pos*: LONGINT;
                        name*, newName*: Name;
                        parc*: Parc
                END;

        VAR
                font*: Fonts.Font;


        (* arguments *)

        PROCEDURE MarkedFrame (): TextFrames.Frame;
                VAR v: Viewers.Viewer;
        BEGIN v := Oberon.MarkedViewer();
                IF (v IS MenuViewers.Viewer) & (v.dsc.next IS TextFrames.Frame) THEN
                        RETURN v.dsc.next(TextFrames.Frame)
                ELSE RETURN NIL
                END
        END MarkedFrame;

        PROCEDURE FocusFrame (): TextFrames.Frame;
                VAR v: Viewers.Viewer; f: TextFrames.Frame;
        BEGIN v := Oberon.FocusViewer;
                IF (v IS MenuViewers.Viewer) & (v.dsc.next IS TextFrames.Frame) THEN
                        f := v.dsc.next(TextFrames.Frame);
                        IF f.hasCar THEN RETURN f ELSE RETURN NIL END
                ELSE RETURN NIL
                END
        END FocusFrame;

        PROCEDURE GetMainArg (VAR S: Texts.Scanner);
                (*after command or (^) at selection*)
                VAR text: Texts.Text; beg, end, time: LONGINT;
        BEGIN Texts.Scan(S);
                IF (S.class = Texts.Char) & (S.c = "^") THEN Oberon.GetSelection(text, beg, end, time);
                        IF time >= 0 THEN Texts.OpenScanner(S, text, beg); Texts.Scan(S) END
                END;
                IF S.line # 0 THEN S.class := Texts.Inval END
        END GetMainArg;


        (* portable I/O *)

        PROCEDURE WriteString (VAR r: Files.Rider; s: ARRAY OF CHAR);
                VAR i: INTEGER;
        BEGIN i := 0;
                WHILE s[i] # 0X DO INC(i) END;
                Files.WriteBytes(r, s, i + 1)
        END WriteString;

        PROCEDURE ReadString (VAR r: Files.Rider; VAR s: ARRAY OF CHAR);
                VAR i: INTEGER; ch: CHAR;
        BEGIN i := 0;
                REPEAT Files.Read(r, ch); s[i] := ch; INC(i) UNTIL (ch = 0X) OR (i = LEN(s));
                IF ch # 0X THEN s[0] := 0X END
        END ReadString;


        (** operations on elements **)

        PROCEDURE Broadcast* (T: Texts.Text; VAR msg: UpdateMsg);
                VAR R: Texts.Reader; e: Texts.Elem;
        BEGIN Texts.OpenReader(R, T, 0); Texts.ReadElem(R);
                WHILE ~R.eot DO e := R.elem; msg.pos := Texts.Pos(R) - 1; Texts.ReadElem(R); e.handle(e, msg) END
        END Broadcast;

        PROCEDURE Search* (T: Texts.Text; VAR name: Name; VAR P: Parc);
                VAR update: UpdateMsg;
        BEGIN update.id := search; update.name := name; update.parc := NIL;
                Broadcast(T, update);
                P := update.parc
        END Search;

        PROCEDURE Synch* (P: Parc; VAR synched: BOOLEAN);
                VAR T: Texts.Text; Q: Parc;
        BEGIN T := Texts.ElemBase(P); synched := FALSE;
                IF (T # NIL) & (P.home # T) THEN Search(T, P.name, Q);
                        IF Q # NIL THEN ParcElems.CopyParc(Q, P); EXCL(P.opts, pageBreak); synched := TRUE END;
                        P.home := T
                END
        END Synch;

        PROCEDURE ChangeSetting* (P: Parc);
                VAR T: Texts.Text; update: UpdateMsg;
        BEGIN T := Texts.ElemBase(P);
                update.id := change; update.name := P.name; update.parc := P;
                Broadcast(T, update)
        END ChangeSetting;

        PROCEDURE ChangeName* (P: Parc; name: ARRAY OF CHAR; VAR synched: BOOLEAN);
        BEGIN synched := FALSE;
                IF P.name # name THEN COPY(name, P.name); P.home := NIL; Synch(P, synched) END
        END ChangeName;


        PROCEDURE Load* (P: Parc; VAR r: Files.Rider);
        BEGIN ParcElems.LoadParc(P, r); ReadString(r, P.name); P.home := Texts.ElemBase(P)
        END Load;

        PROCEDURE Store* (P: Parc; VAR r: Files.Rider);
                VAR synched: BOOLEAN;
        BEGIN Synch(P, synched); ParcElems.StoreParc(P, r); WriteString(r, P.name)
        END Store;

        PROCEDURE Copy* (SP, DP: Parc);
        BEGIN ParcElems.CopyParc(SP, DP); DP.name := SP.name; DP.home := SP.home
        END Copy;

        PROCEDURE Prepare* (P: Parc; indent, unit: LONGINT);
                VAR synched: BOOLEAN;
        BEGIN Synch(P, synched); ParcElems.Prepare(P, indent, unit);
                IF LONG(font.height + 4) * unit > P.H THEN P.H := LONG(font.height + 4) * unit END
        END Prepare;


        PROCEDURE Width (P: Parc): INTEGER;
                VAR pat: Display.Pattern; i, px, dx, x, y, w, h: INTEGER;
        BEGIN i := 0; px := 0;
                WHILE P.name[i] # 0X DO
                        Display.GetChar(font.raster, P.name[i], dx, x, y, w, h, pat); INC(px, dx); INC(i)
                END;
                RETURN px
        END Width;

        PROCEDURE DrawString (P: Parc; col: SHORTINT; x0, y0, bw: INTEGER);
                VAR pat: Display.Pattern; i, dx, x, y, w, h: INTEGER;
        BEGIN i := 0;
                Display.ReplConst(Display.black, x0, y0, bw + 4, font.height, Display.replace); INC(x0, 2); DEC(y0, font.minY);
                WHILE P.name[i] # 0X DO
                        Display.GetChar(font.raster, P.name[i], dx, x, y, w, h, pat); INC(i);
                        Display.CopyPattern(col, pat, x0 + x, y0 + y, Display.replace); INC(x0, dx)
                END
        END DrawString;

        PROCEDURE Draw* (P: Parc; F: Display.Frame; col: SHORTINT; x0, y0: INTEGER);
                VAR bw: INTEGER;
        BEGIN ParcElems.Draw(P, F, col, x0, y0);
                bw := Width(P); DrawString(P, col, x0 + SHORT(P.W DIV unit) - bw - 20, y0 + 4, bw)
        END Draw;


        PROCEDURE Edit* (P: Parc; F: TextFrames.Frame; pos: LONGINT; x0, y0, x, y: INTEGER; keysum: SET);
        BEGIN
                IF F.showsParcs THEN ParcElems.Edit(P, F, pos, x0, y0, x, y, keysum);
                        IF (middleKey IN keysum) & (keysum # cancel) THEN ChangeSetting(P) END
                END
        END Edit;

        PROCEDURE SetAttr* (P: Parc; F: TextFrames.Frame; VAR S: Texts.Scanner; log: Texts.Text);
        BEGIN ParcElems.SetAttr(P, F, unit, S, log); ChangeSetting(P)
        END SetAttr;


        (** handle elements **)

        PROCEDURE Handle* (E: Texts.Elem; VAR msg: Texts.ElemMsg);
                VAR e: Parc; opts: SET; synched: BOOLEAN;
        BEGIN
                WITH E: Parc DO
                        IF msg IS TextFrames.DisplayMsg THEN
                                WITH msg: TextFrames.DisplayMsg DO
                                        IF msg.prepare THEN Prepare(E, msg.indent, unit)
                                        ELSE Draw(E, msg.frame, msg.col, msg.X0, msg.Y0)
                                        END
                                END
                        ELSIF msg IS Texts.IdentifyMsg THEN
                                WITH msg: Texts.IdentifyMsg DO msg.mod := "StyleElems"; msg.proc := "Alloc" END
                        ELSIF msg IS Texts.FileMsg THEN
                                WITH msg: Texts.FileMsg DO
                                        IF msg.id = Texts.load THEN Load(E, msg.r)
                                        ELSIF msg.id = Texts.store THEN Store(E, msg.r)
                                        END
                                END
                        ELSIF msg IS Texts.CopyMsg THEN NEW(e); Copy(E, e); msg(Texts.CopyMsg).e := e
                        ELSIF msg IS TextFrames.TrackMsg THEN
                                WITH msg: TextFrames.TrackMsg DO
                                        Edit(E, msg.frame(TextFrames.Frame), msg.pos, msg.X0, msg.Y0, msg.X, msg.Y, msg.keys)
                                END
                        ELSIF msg IS ParcElems.StateMsg THEN
                                WITH msg: ParcElems.StateMsg DO
                                        IF msg.id = ParcElems.set THEN SetAttr(E, msg.frame, msg.par, msg.log)
                                        ELSE ParcElems.Handle(E, msg)
                                        END
                                END
                        ELSIF msg IS UpdateMsg THEN
                                WITH msg: UpdateMsg DO
                                        IF (msg.id = search) & (msg.parc = NIL) & (E.name = msg.name) & (E.home = Texts.ElemBase(E)) THEN
                                                msg.parc := E
                                        ELSIF (msg.id = change) & (E.name = msg.name) THEN
                                                IF E # msg.parc THEN opts := E.opts;
                                                        ParcElems.CopyParc(msg.parc, E); E.opts := E.opts - {pageBreak} + opts * {pageBreak}
                                                END;
                                                ParcElems.ChangedParc(E, msg.pos)
                                        ELSIF (msg.id = rename) & (E.name = msg.name) THEN
                                                ChangeName(E, msg.newName, synched);
                                                IF synched THEN ParcElems.ChangedParc(E, msg.pos)
                                                ELSE Texts.ChangeLooks(Texts.ElemBase(E), msg.pos, msg.pos+1, {}, NIL, 0, 0)
                                                END
                                        END
                                END
                        ELSE ParcElems.Handle(E, msg)
                        END
                END
        END Handle;

        PROCEDURE Alloc*;
                VAR p: Parc;
        BEGIN NEW(p); p.handle := Handle; Texts.new := p
        END Alloc;


        (** commands **)

        PROCEDURE Insert*;      (** ("^" | name | string) **)
                VAR F: TextFrames.Frame; P: TextFrames.Parc; p: Parc; S: Texts.Scanner; pbeg: LONGINT;
                        m: TextFrames.InsertElemMsg;
        BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); GetMainArg(S);
                IF (S.class = Texts.Name) OR (S.class = Texts.String) THEN
                        F := FocusFrame();
                        IF F # NIL THEN TextFrames.ParcBefore(F.text, F.carloc.pos, P, pbeg)
                        ELSE P := TextFrames.defParc
                        END;
                        NEW(p); ParcElems.CopyParc(P, p);
                        p.handle := Handle; COPY(S.s, p.name); p.home := NIL; m.e := p;
                        Oberon.FocusViewer.handle(Oberon.FocusViewer, m)
                END
        END Insert;

        PROCEDURE Rename*;      (** ("^" | name | string) ["/s"] **)
                VAR S: Texts.Scanner; F: TextFrames.Frame; P: TextFrames.Parc; p: Parc;
                        pbeg: LONGINT; synch, synched: BOOLEAN;
                        name: Name;
        BEGIN F := MarkedFrame(); Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); GetMainArg(S);
                IF (F # NIL) & F.hasSel & (F.selbeg.pos + 1 = F.selend.pos)
                & ((S.class = Texts.Name) OR (S.class = Texts.String)) THEN
                        TextFrames.ParcBefore(F.text, F.selbeg.pos, P, pbeg);
                        IF (P IS Parc) & (pbeg = F.selbeg.pos) & (P(Parc).name # S.s) THEN
                                COPY(S.s, name); Texts.Scan(S);
                                IF (S.class = Texts.Char) & (S.c = "/") & (CAP(S.nextCh) = "S") THEN synch := TRUE
                                ELSE Search(F.text, name, p); synch := p = NIL
                                END;
                                ChangeName(P(Parc), name, synched);
                                IF synched THEN ParcElems.ChangedParc(P, pbeg)
                                ELSE Texts.ChangeLooks(F.text, pbeg, pbeg+1, {}, NIL, 0, 0)
                                END
                        END
                END
        END Rename;

        PROCEDURE RenameAll*;   (** ("^" | name | string) ["/s"] **)
                VAR S: Texts.Scanner; F: TextFrames.Frame; P: TextFrames.Parc; p: Parc;
                        pbeg: LONGINT; synch: BOOLEAN;
                        msg: UpdateMsg; name: Name;
        BEGIN F := MarkedFrame(); Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); GetMainArg(S);
                IF (F # NIL) & F.hasSel & (F.selbeg.pos + 1 = F.selend.pos)
                & ((S.class = Texts.Name) OR (S.class = Texts.String)) THEN
                        TextFrames.ParcBefore(F.text, F.selbeg.pos, P, pbeg);
                        IF (P IS Parc) & (pbeg = F.selbeg.pos) & (P(Parc).name # S.s) THEN
                                COPY(S.s, name); Texts.Scan(S);
                                IF (S.class = Texts.Char) & (S.c = "/") & (CAP(S.nextCh) = "S") THEN synch := TRUE
                                ELSE Search(F.text, name, p); synch := p = NIL
                                END;
                                IF synch THEN
                                        msg.id := rename; msg.name := P(Parc).name; msg.newName := name;
                                        Broadcast(F.text, msg)
                                END
                        END
                END
        END RenameAll;

BEGIN font := Fonts.This(NameFont)
END StyleElems.

(*
        Write.Open ^    Styles.Text             System.Free StyleElems ~
        StyleElems.Insert ^     StyleElems.Rename ^     StyleElems.RenameAll ^
                "heading"       "sub-heading"   "table A"/s
*)
