MODULE PictElems;       (** jm 12-Oct-90 / kr CAS 8-Apr-91 / mf  14.10.91 / kr 16.10.91**)
IMPORT
        Input, Display, Files, Printer, Oberon, Viewers, MenuViewers, Texts, TextFrames,
        TextPrinter, Pictures, PictureFrames, SYSTEM;

CONST
        mm = TextFrames.mm; unit = TextFrames.Unit; Unit = TextPrinter.Unit;
        Mw = 5*mm; Mh = 5*mm; Ow = 30*mm; Oh = 30*mm;  (*minimal, original width in units*)
        right = 0; middle = 1; left = 2;
        maxW = 1024; maxH = 800;

TYPE
        PictElem = POINTER TO PictElemDesc;
        PictElemDesc = RECORD (Texts.ElemDesc)
                name: ARRAY 32 OF CHAR;
                pict, scalPict: Pictures.Picture;
                scale: BOOLEAN
        END;
        NotifyMsg = RECORD (TextFrames.NotifyMsg) END;

        Frame = POINTER TO FrameDesc;
        FrameDesc = RECORD (PictureFrames.FrameDesc);
                E: PictElem;
        END;

VAR
        W: Texts.Writer;
        bit : ARRAY 8 OF INTEGER;
        menuString : ARRAY 120 OF CHAR;
        updateString : ARRAY 20 OF CHAR;
        i, j : INTEGER;

PROCEDURE Min (x, y: LONGINT): LONGINT;
BEGIN
        IF x < y THEN RETURN x ELSE RETURN y END
END Min;

PROCEDURE Max (x, y: LONGINT): LONGINT;
BEGIN
        IF x > y THEN RETURN x ELSE RETURN y END
END Max;

PROCEDURE InvertRect (x, y, w, h: INTEGER);
BEGIN Display.ReplConst(Display.white, x, y, w, h, Display.invert)
END InvertRect;

PROCEDURE InvertGrip (x, y, w: INTEGER);
BEGIN InvertRect(x + w - 5, y + 5, 5, 1); InvertRect(x + w - 5, y, 1, 5)
END InvertGrip;

PROCEDURE InvertFrame (x, y, w, h: INTEGER);
BEGIN InvertRect(x, y, w, 1); InvertRect(x, y+h-1, w, 1); InvertRect(x, y, 1, h); InvertRect(x+w-1, y, 1, h)
END InvertFrame;

PROCEDURE SizeRect (VAR keysum: SET; mx, my, dx, dy: INTEGER; VAR x, y, w, h: INTEGER);
        VAR keys: SET; lx, ly, top: INTEGER;
BEGIN top := y + h; INC(mx, dx); INC(my, dy); lx := mx; ly := my;
        InvertFrame(x, my, mx - x, top - my);
        REPEAT Input.Mouse(keys, mx, my); keysum := keysum + keys;
                Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, mx, my);
                INC(mx, dx); INC(my, dy);
                mx := SHORT(Max(mx, x + Mw DIV unit)); my := SHORT(Min(my, top - Mh DIV unit));
                IF (mx # lx) OR (my # ly) THEN
                        InvertFrame(x, ly, lx - x, top - ly); InvertGrip(x, ly, lx - x);
                        InvertFrame(x, my, mx - x, top - my); InvertGrip(x, my, mx - x);
                        lx := mx; ly := my
                END
        UNTIL keys = {};
        InvertFrame(x, my, mx - x, top - my); InvertGrip(x, my, mx - x);
        w := mx - x; h :=  top - my; y := my
END SizeRect;


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

PROCEDURE NewPicture(P : Pictures.Picture;E : PictElem) : Frame;
        VAR F : Frame;
BEGIN
        NEW(F); F.car := 0;
        PictureFrames.Open(F,PictureFrames.Handle,P,0,P.height); P.notify := PictureFrames.NotifyDisplay;
        F.E := E;
        RETURN F
END NewPicture;

PROCEDURE Track* (E: PictElem; pos: LONGINT; keys: SET; x, y, x0, y0: INTEGER);
        VAR P: Pictures.Picture; V: Viewers.Viewer; T: Texts.Text; x1, y1, w, h: INTEGER;
BEGIN w := SHORT(E.W DIV unit); h := SHORT(E.H DIV unit);
        IF keys = {middle} THEN
                IF E.scale & (x >= x0 + w - 5) & (y <= y0 + 5) THEN x1 := x0; y1 := y0;
                        SizeRect(keys, x, y, x0 + w - x, y0 - y, x1, y1, w, h);
                        IF keys = {middle} THEN E.W := LONG(w) * unit; E.H := LONG(h) * unit
                        ELSIF keys = {middle, left} THEN E.W := LONG(E.pict.width) * unit; E.H := LONG(E.pict.height) * unit
                        END;
                        IF ~(right IN keys) THEN E.scalPict := NIL;
                                T := Texts.ElemBase(E); T.notify(T, Texts.replace, pos, pos + 1)
                        ELSE InvertGrip(x0, y0, SHORT(E.W DIV unit))
                        END
                ELSE NEW(P);
                        Pictures.Create(P, E.pict.width, E.pict.height, E.pict.depth);
                        E.pict.width := E.pict.width *  E.pict.depth; P.width := P.width *  P.depth;
                        Pictures.CopyBlock(E.pict, P, 0, 0, E.pict.width, E.pict.height, 0, 0, Display.replace);
                        E.pict.width := E.pict.width DIV  E.pict.depth; P.width := P.width DIV P.depth;
                        Oberon.AllocateUserViewer(0, x, y);
                        V := MenuViewers.New(TextFrames.NewMenu("P.Pict", menuString),NewPicture(P,E),
                                TextFrames.menuH, x, y);
                        REPEAT Input.Mouse(keys, x, y); Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, x, y) UNTIL keys = {}
                END
        END
END Track;

PROCEDURE Draw* (E: PictElem; x0, y0: INTEGER);
        VAR p, P: Pictures.Picture; w, h: INTEGER;
BEGIN w := SHORT(E.W DIV unit); h := SHORT(E.H DIV unit);
        IF ~E.scale THEN Pictures.DisplayBlock(E.pict, 0, 0, w, h, x0, y0, Display.replace)
        ELSE
                IF E.scalPict = NIL THEN NEW(P); E.scalPict := P;
                        Pictures.Create(P, SHORT(E.W DIV unit), SHORT(E.H DIV unit), E.pict.depth);
                        E.pict.width := E.pict.width *  E.pict.depth; P.width := P.width *  P.depth;
                        Pictures.Copy(E.pict,P,0, 0, E.pict.width, E.pict.height,0,0,P.width, P.height, Display.replace);
                        E.pict.width := E.pict.width DIV  E.pict.depth; P.width := P.width DIV  P.depth;
                ELSE P := E.scalPict
                END;
                Pictures.DisplayBlock(P, 0, 0, P.width, P.height, x0, y0, Display.replace);
                Display.ReplConst(Display.black, x0 + w - 6, y0, 6, 7, Display.replace);
                InvertGrip(x0, y0, w)
        END
END Draw;

PROCEDURE Print* (P: Pictures.Picture;  px, py: LONGINT; eW, eH: LONGINT; scaled: BOOLEAN);
        VAR winc, hinc, dW, dH, hleft, hdiff: LONGINT; y, h, ph: LONGINT; pict : Pictures.Picture;

        PROCEDURE LoadPrinter(x, y, w, h, pw, ph : LONGINT) : LONGINT;
        BEGIN
                IF (pict = NIL) OR (pict.width # pw) OR (pict.height # ph) THEN
                        pw := SHORT((pw+7) DIV 8 * 8);
                        NEW(pict); Pictures.Create(pict,SHORT(pw),SHORT(ph),1);
                END;
                Pictures.Copy(P,pict,SHORT(x), SHORT(y), SHORT(w), SHORT(h), 0, 0,SHORT(pw), SHORT(ph),Display.replace);
                RETURN Pictures.Address(pict);
        END LoadPrinter;

        PROCEDURE Stripe(px: LONGINT);
                VAR wleft, wdiff : LONGINT; x, w, pw: LONGINT;
        BEGIN wleft := dW; x := 0;
                WHILE (Printer.res = 0) & (wleft > 0) DO wdiff := Min(wleft, winc);
                        w := SHORT(wdiff DIV unit); pw := SHORT(wdiff DIV Unit * eW DIV dW);
                        pw := SHORT((pw+7) DIV 8 * 8); (*hack Printer.Picture*);
                        Printer.Picture(SHORT(px), SHORT(py), SHORT(pw), SHORT(ph), Display.replace, LoadPrinter(x, y, w, h, pw, ph));
                        INC(x, w); INC(px, pw);
                        DEC(wleft, wdiff)
                END
        END Stripe;

BEGIN
        pict := NIL;
        Printer.res := 0; winc := 16*mm; hinc := 16*mm;
        IF ~scaled THEN dW := eW; dH := eH ELSE dW := P.width * unit; dH :=P.height * unit END;
        hleft := dH; y := 0;
        INC(px, px MOD 2);      (*hack Printer.Picture*)
        WHILE (Printer.res = 0) & (hleft > 0) DO hdiff := Min(hleft, hinc);
                h := SHORT(hdiff DIV unit); ph :=  SHORT(hdiff DIV Unit * eH DIV dH);
                Stripe(px);
                INC(y, h); INC(py, ph);
                DEC(hleft, hdiff)
        END;
        IF Printer.res # 0 THEN
                Texts.WriteLn(W); Texts.WriteString(W, "PictureElems Printer Timeout");  Texts.WriteLn(W);
                Texts.Append(Oberon.Log, W.buf)
        END
END Print;

PROCEDURE Load* (E: PictElem; VAR r: Files.Rider);
        VAR ch: CHAR; dmy, len: LONGINT; R : Files.Rider; w : INTEGER;
BEGIN ReadString(r, E.name);
        Files.Read(r, ch); E.scale := (ch # 0X); NEW(E.pict);
        IF E.name[0] = 0X THEN
                Files.Set(R,Files.Base(r),Files.Pos(r));
                Pictures.Load(E.pict, Files.Base(r), Files.Pos(r) + 2, len);  Files.Set(r, Files.Base(r), Files.Pos(r) + len + 2)
        ELSE    (*old version*)
                Files.ReadLInt(r, dmy); Pictures.Open(E.pict, E.name)
        END
END Load;

PROCEDURE Store* (E: PictElem; VAR r: Files.Rider);
        VAR len: LONGINT;
BEGIN Files.Write(r, 0X); (*version*)
        IF E.scale THEN Files.Write(r, 1X) ELSE Files.Write(r, 0X) END;
        Pictures.Store(E.pict, Files.Base(r), Files.Pos(r), len); Files.Set(r, Files.Base(r), Files.Pos(r) + len)
END Store;

PROCEDURE Copy* (SE, DE: PictElem);
BEGIN Texts.CopyElem(SE, DE);
        COPY(SE.name, DE.name);
        NEW(DE.pict);
        Pictures.Create(DE.pict, SE.pict.width, SE.pict.height, SE.pict.depth);
        DE.pict.width := DE.pict.width *  DE.pict.depth; SE.pict.width := SE.pict.width *  SE.pict.depth;
        Pictures.CopyBlock(SE.pict, DE.pict, 0, 0, SE.pict.width, SE.pict.height, 0, 0, Display.replace);
        DE.pict.width := DE.pict.width DIV  DE.pict.depth; SE.pict.width := SE.pict.width DIV  SE.pict.depth;
        DE.scalPict := NIL; DE.scale := SE.scale
END Copy;

PROCEDURE Changed* (E: PictElem);
        VAR R: Texts.Reader; T: Texts.Text;
BEGIN T := Texts.ElemBase(E);
        IF T # NIL THEN Texts.OpenReader(R, T, 0);
                REPEAT Texts.ReadElem(R) UNTIL R.elem = E;
                T.notify(T, Texts.replace, Texts.Pos(R)-1, Texts.Pos(R))
        END
END Changed;


PROCEDURE PictHandle* (E: Texts.Elem; VAR msg: Texts.ElemMsg);
        VAR e: PictElem; P: Pictures.Picture; V: Viewers.Viewer; F: PictureFrames.Frame; x, y, w, h,X, Y: INTEGER; keys: SET;
BEGIN
        WITH E: PictElem DO
                IF msg IS TextFrames.DisplayMsg THEN
                        WITH msg: TextFrames.DisplayMsg DO
                                IF ~msg.prepare THEN Draw(E, msg.X0, msg.Y0) END
                        END
                ELSIF msg IS TextPrinter.PrintMsg THEN
                        WITH msg: TextPrinter.PrintMsg DO
                                IF ~msg.prepare THEN Print(E.pict, msg.X0, msg.Y0, E.W, E.H, E.scale) END
                        END
                ELSIF msg IS Texts.IdentifyMsg THEN
                        WITH msg: Texts.IdentifyMsg DO msg.mod := "PictElems"; msg.proc := "Alloc" END
                ELSIF msg IS Texts.FileMsg THEN
                        WITH msg: Texts.FileMsg DO
                                IF msg.id = Texts.load THEN Load(E, msg.r)
                                ELSIF msg.id = Texts.store THEN Store(E, msg.r)
                                END
                        END
                ELSIF msg IS Texts.CopyMsg THEN
                        WITH msg: Texts.CopyMsg DO NEW(e); Copy(E, e); msg.e := e END
                ELSIF msg IS TextFrames.TrackMsg THEN
                        WITH msg: TextFrames.TrackMsg DO Track(E, msg.pos, msg.keys, msg.X, msg.Y, msg.X0, msg.Y0) END
                END
        END
END PictHandle;


PROCEDURE Alloc*;
        VAR e: PictElem;
BEGIN NEW(e); e.handle := PictHandle; Texts.new := e
END Alloc;

PROCEDURE Insert*;      (** ("^" | "*" | name ["scaled"]) **)
        VAR S, S1: Texts.Scanner; V: Viewers.Viewer; P: Pictures.Picture; e: PictElem; T: Texts.Text;
                ew, eh, beg, end, time: LONGINT;
                msg: TextFrames.InsertElemMsg;
BEGIN P := NIL; Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
        IF (S.class = Texts.Char) & (S.c = "^") THEN Oberon.GetSelection(T, beg, end, time);
                IF time > 0 THEN Texts.OpenScanner(S, T, beg); Texts.Scan(S) END
        END;
        IF S.line = 0 THEN
                IF (S.class = Texts.Char) & (S.c = "*") THEN
                        V := Oberon.MarkedViewer();
                        IF (V IS MenuViewers.Viewer) & (V.dsc IS TextFrames.Frame) & (V.dsc.next IS PictureFrames.Frame) THEN
                                Texts.OpenScanner(S1, V.dsc(TextFrames.Frame).text, 0); Texts.Scan(S1);
                                IF S1.class = Texts.Name THEN P := V.dsc.next(PictureFrames.Frame).pict END
                        END
                ELSIF S.class = Texts.Name THEN NEW(P); Pictures.Open(P, S.s)
                END
        END;
        IF P # NIL THEN NEW(e); COPY(S.s, e.name); Texts.Scan(S); e.scalPict := NIL; e.scale := S.s = "scaled";
                NEW(e.pict); Pictures.Create(e.pict, P.width, P.height, P.depth);
                e.pict.width := e.pict.width * e.pict.depth; P.width := P.width * P.depth;
                Pictures.CopyBlock(P, e.pict, 0, 0, P.width, P.height, 0, 0, Display.replace);
                e.pict.width := e.pict.width DIV e.pict.depth; P.width := P.width DIV P.depth;
                IF e.scale THEN ew := Ow; eh := Oh
                ELSE ew := LONG(e.pict.width) * unit; eh := LONG(e.pict.height) * unit
                END;
                e.W := ew; e.H := eh; e.handle := PictHandle;
                msg.e := e; Oberon.FocusViewer.handle(Oberon.FocusViewer, msg)
        END
END Insert;

PROCEDURE Update*;
        VAR V: Viewers.Viewer; P: Pictures.Picture; pict: Pictures.Picture; F: Frame;
BEGIN
        V := Oberon.Par.vwr;
        IF V.dsc.next IS Frame THEN
                F := V.dsc.next(Frame);
                P := F.pict; F.E.scalPict := NIL; pict := F.E.pict;
                Pictures.Create(pict, P.width, P.height, P.depth);
                pict.width := pict.width DIV  pict.depth; P.width := P.width DIV  P.depth;
                Pictures.CopyBlock(P, pict,0, 0, P.width,  P.height, 0, 0, Display.replace);
                pict.width := pict.width DIV  pict.depth; P.width := P.width DIV  P.depth;
                IF ~F.E.scale THEN F.E.W := LONG(pict.width) * unit; F.E.H := LONG(pict.height) * unit END;
                Changed(F.E)
        END
END Update;

BEGIN Texts.OpenWriter(W);
bit[0] :=1; bit[1] :=2; bit[2] := 4; bit[3] := 8;
bit[4] := 16; bit[5] := 32; bit[6] := 64; bit[7]:= 128;
updateString  := "PictElems.Update";
COPY(PictureFrames.menuString,menuString);
i := 0; WHILE menuString[i] # 0X DO INC(i) END; DEC(i,11);
j := 0;  menuString[i] := updateString[j];
WHILE updateString[j] # 0X DO INC(i); INC(j); menuString[i] := updateString[j]; END;
END PictElems.
