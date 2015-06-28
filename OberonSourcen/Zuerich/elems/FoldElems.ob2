MODULE FoldElems;       (** HM 6 Apr 93 / 28 Sept 93 **)

IMPORT Display, Fonts, Oberon, Input, Files, Texts, Viewers, MenuViewers, TextFrames, TextPrinter;

CONST
        rightKey = 0; middleKey = 1; leftKey = 2;
        colLeft* = 0; colRight* = 1; expRight* = 2; expLeft* = 3; tempLeft* = 4; findLeft* = 5; (*fold element mode*)
        leftMode = {colLeft, expLeft, tempLeft, findLeft};
        rightMode = {colRight, expRight};
        tempMode = {tempLeft, findLeft};
        pixel = 10000;
        invisW = 1 * pixel;  (*width of an invisible element*)

TYPE
        Elem* = POINTER TO ElemDesc;
        ElemDesc* = RECORD (Texts.ElemDesc)
                mode*: SHORTINT;
                hidden*: Texts.Buffer;
                visible: BOOLEAN;
                pos: LONGINT
        END;
        CheckProc* = PROCEDURE(e: Texts.Elem): BOOLEAN;
        MarkElem = POINTER TO MarkElemDesc;
        MarkElemDesc = RECORD (Texts.ElemDesc) END;
        FindInfo = RECORD
                found: BOOLEAN;
                text: Texts.Text;
                pos: LONGINT;
                pat: ARRAY 128 OF CHAR;
                len: INTEGER
        END;

VAR
        elemW, elemH: LONGINT;
        w: Texts.Writer;
        inf: FindInfo;
        x0, y0: INTEGER; (*x and y metric of fold characters*)
        Pat: ARRAY 6 OF Display.Pattern; (* x = 0, y = 3, w = 8, h = 9 *)
        icl, icr, iel, ier: ARRAY 4 OF SET;
        (*img: ARRAY 10 OF SET;*)

PROCEDURE (*<*>*)NoNotify(t: Texts.Text; op: INTEGER; beg, end: LONGINT);
END NoNotify;


PROCEDURE (*<*>*)FindCheck(e: Texts.Elem): BOOLEAN;
BEGIN RETURN e IS MarkElem
END FindCheck;


PROCEDURE WriteString(VAR r: Files.Rider; s: ARRAY OF CHAR);
        VAR i: INTEGER;
BEGIN i := 0;
        WHILE s[i] # 0X DO INC(i) END;
        Files.WriteBytes(r, s, i + 1)
END WriteString;


PROCEDURE TargetText(): Texts.Text;
        VAR f: Display.Frame; v: Viewers.Viewer;
BEGIN f := NIL;
        IF Oberon.Par.frame = Oberon.Par.vwr.dsc THEN f := Oberon.Par.frame.next
        ELSE v := Oberon.MarkedViewer();
                IF (v # NIL) & (v.dsc # NIL) THEN f := v.dsc.next END
        END;
        IF (f # NIL) & (f IS TextFrames.Frame) THEN RETURN f(TextFrames.Frame).text
        ELSE RETURN NIL
        END
END TargetText;


PROCEDURE ElemPos*(e: Texts.Elem): LONGINT;
        VAR r: Texts.Reader;
BEGIN Texts.OpenReader(r, Texts.ElemBase(e), 0);
        REPEAT Texts.ReadElem(r) UNTIL (r.elem = e) OR (r.elem = NIL);
        RETURN Texts.Pos(r) - 1
END ElemPos;


PROCEDURE Echo*(t: Texts.Text; on: BOOLEAN);
BEGIN
        IF on THEN t.notify := TextFrames.NotifyDisplay ELSE t.notify := NoNotify END
END Echo;


PROCEDURE Update(e: Elem);
        VAR t: Texts.Text; pos: LONGINT;
BEGIN t := Texts.ElemBase(e); t.notify(t, Texts.replace, e.pos, e.pos+1)
END Update;


PROCEDURE Twin(e: Elem): Elem;
        VAR level, sp: INTEGER; stack: ARRAY 8 OF Elem; r: Texts.Reader; E: Elem;
BEGIN E := NIL; level := 1;
        IF e.mode IN leftMode THEN Texts.OpenReader(r, Texts.ElemBase(e), e.pos+1);
                LOOP Texts.ReadElem(r);
                        IF r.elem = NIL THEN EXIT
                        ELSIF r.elem IS Elem THEN E := r.elem(Elem);
                                IF E.mode IN leftMode THEN INC(level) ELSE DEC(level) END;
                                IF level = 0 THEN E.pos := Texts.Pos(r)-1; EXIT END
                        END
                END
        ELSE
                Texts.OpenReader(r, Texts.ElemBase(e), e.pos);
                LOOP Texts.ReadPrevElem(r);
                        IF r.elem = NIL THEN EXIT
                        ELSIF r.elem IS Elem THEN E := r.elem(Elem);
                                IF E.mode IN rightMode THEN INC(level) ELSE DEC(level) END;
                                IF level = 0 THEN E.pos := Texts.Pos(r); EXIT END
                        END
                END
        END;
        RETURN E
        (*postcondition: twin = NIL OR twin.pos is correct*)
END Twin;


PROCEDURE Switch*(e: Elem; pos: LONGINT);
        VAR a, b: Elem; t: Texts.Text; buf: Texts.Buffer;
BEGIN
        e.pos := pos;
        IF e.mode IN leftMode THEN a := e; b := Twin(a) ELSE b := e; a := Twin(b) END;
        IF a.mode IN tempMode THEN a.mode := expLeft END;
        IF (a # NIL) & (b # NIL) THEN
                t := Texts.ElemBase(a);
                a.mode := 3 - a.mode; b.mode := 3 - b.mode;
                Texts.Delete(t, a.pos+1, b.pos); Texts.Recall(buf);
                Texts.Insert(t, a.pos+1, a.hidden); a.hidden := buf;
                Update(a)
        END
        (*postcondition: if e.mode IN leftMode then e.pos is correct*)
END Switch;


PROCEDURE ExpandAll*(t: Texts.Text; from: LONGINT; temporal: BOOLEAN);
        VAR r: Texts.Reader; E: Elem; res: INTEGER;
BEGIN Texts.OpenReader(r, t, from);
        LOOP Texts.ReadElem(r);
                IF r.elem = NIL THEN EXIT END;
                IF r.elem IS Elem THEN E := r.elem(Elem);
                        IF E.mode = colLeft THEN
                                Switch(E, Texts.Pos(r)-1); IF temporal THEN E.mode := tempLeft END;
                                Texts.OpenReader(r, t, E.pos+1)
                        END
                END
        END
END ExpandAll;


PROCEDURE CollapseAll*(t: Texts.Text; modes: SET);
        VAR r: Texts.Reader;
BEGIN Texts.OpenReader(r, t, t.len);
        LOOP Texts.ReadPrevElem(r);
                IF r.elem = NIL THEN EXIT
                ELSIF (r.elem IS Elem) & (r.elem(Elem).mode IN modes) THEN Switch(r.elem(Elem), Texts.Pos(r))
                END
        END
END CollapseAll;


PROCEDURE FindElem*(t: Texts.Text; pos: LONGINT; P: CheckProc; VAR elem: Texts.Elem; VAR elemPos: LONGINT);
        VAR r: Texts.Reader; E: Elem;

        PROCEDURE Inside(buf: Texts.Buffer): BOOLEAN;
                VAR r: Texts.Reader; t0: Texts.Text; found: BOOLEAN;
        BEGIN t0 := TextFrames.Text(""); Texts.Append(t0, buf); Texts.OpenReader(r, t0, 0); found := FALSE;
                LOOP Texts.ReadElem(r);
                        IF r.elem = NIL THEN EXIT
                        ELSIF P(r.elem) OR (r.elem IS Elem) & (r.elem(Elem).mode = colLeft) & Inside(r.elem(Elem).hidden) THEN
                                found := TRUE; EXIT
                        END
                END;
                Texts.Save(t0, 0, t0.len, buf); RETURN found
        END Inside;


BEGIN Texts.OpenReader(r, t, pos);
        LOOP Texts.ReadElem(r); elemPos := Texts.Pos(r)-1;
                IF (r.elem = NIL) OR P(r.elem) THEN elem := r.elem; EXIT END;
                IF r.elem IS Elem THEN E := r.elem(Elem);
                        IF (E.mode = colLeft) & Inside(E.hidden) THEN
                                Switch(E, elemPos); E.mode := findLeft; Texts.OpenReader(r, t, elemPos+1)
                        END
                END
        END
END FindElem;


PROCEDURE FoldHandler*(e: Texts.Elem; VAR m: Texts.ElemMsg);
        VAR a: Elem; keys: SET; x, y: INTEGER; t: Texts.Text; buf: Texts.Buffer; k, mode: SHORTINT;
                neutralize: Oberon.ControlMsg;
BEGIN
        WITH e: Elem DO
                WITH
                        m: Texts.FileMsg DO
                                IF m.id = Texts.load THEN
                                        Files.Read(m.r, k); e.mode := k MOD 4; e.visible := e.W > invisW;
                                        IF e.mode IN leftMode THEN
                                                NEW(e.hidden); Texts.OpenBuf(e.hidden);
                                                IF k < 4 THEN (*text not empty*)
                                                        t := TextFrames.Text("");
                                                        Texts.Load(m.r, t);
                                                        Texts.Save(t, 0, t.len, e.hidden)
                                                END
                                        END
                                ELSE (*Texts.store*)
                                        mode := e.mode;
                                        IF mode IN tempMode THEN mode := expLeft END;
                                        IF (mode IN leftMode) & (e.hidden.len = 0) THEN k := mode +  4 ELSE k := mode END;
                                        Files.Write(m.r, k);
                                        IF (k < 4)  & (mode IN leftMode) THEN
                                                t := TextFrames.Text("");
                                                NEW(buf); Texts.OpenBuf(buf); Texts.Copy(e.hidden, buf); Texts.Append(t, buf);
                                                Texts.Store(m.r, t)
                                        END
                                END

                | m: Texts.CopyMsg DO
                                NEW(a); Texts.CopyElem(e, a);
                                a.mode := e.mode; a.visible := e.visible;
                                IF e.mode IN leftMode THEN
                                        NEW(a.hidden); Texts.OpenBuf(a.hidden); Texts.Copy(e.hidden, a.hidden)
                                END;
                                m.e := a

                | m: Texts.IdentifyMsg DO
                                m.mod := "FoldElems"; m.proc := "New"

                | m: TextFrames.DisplayMsg DO
                        IF m.prepare THEN
                                IF e.visible THEN e.W := elemW ELSE e.W := invisW END
                        ELSIF e.visible THEN
                                Display.CopyPattern(15, Pat[e.mode], m.X0 + x0, m.Y0 + y0, Display.replace)
                        END

                | m: TextFrames.TrackMsg DO
                                IF middleKey IN m.keys THEN
                                        neutralize.id := Oberon.neutralize; m.frame.handle(m.frame, neutralize);
                                        IF e.mode IN tempMode THEN mode := expLeft ELSE mode := e.mode END;
                                        Display.CopyPattern(Display.white, Pat[mode], m.X0 + x0, m.Y0 + y0, Display.invert);
                                        Display.CopyPattern(Display.white, Pat[3 - mode], m.X0 + x0, m.Y0 + y0, Display.invert);
                                        REPEAT Input.Mouse(keys, x, y); m.keys := m.keys + keys;
                                                Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, x, y)
                                        UNTIL keys = {};
                                        IF m.keys = {middleKey} THEN Switch(e, m.pos)
                                        ELSE
                                                Display.CopyPattern(Display.white, Pat[3 - mode], m.X0 + x0, m.Y0 + y0, Display.invert);
                                                Display.CopyPattern(Display.white, Pat[mode], m.X0 + x0, m.Y0 + y0, Display.invert)
                                        END
                                END

                ELSE
                END
        END
END FoldHandler;


PROCEDURE (*<*>*)MarkHandler(e: Texts.Elem; VAR m: Texts.ElemMsg);
        VAR a: MarkElem;
BEGIN
        IF m IS Texts.CopyMsg THEN NEW(a); Texts.CopyElem(e, a); m(Texts.CopyMsg).e := a END
END MarkHandler;


PROCEDURE Insert*;
        VAR e: Elem; t: Texts.Text; beg, end, time: LONGINT;
BEGIN
        Oberon.GetSelection(t, beg, end, time);
        IF (time >= 0) & (t IS Texts.Text) THEN
                NEW(e); e.mode := expRight; e.W := elemW; e.H := elemH; e.handle := FoldHandler;
                e.visible := TRUE; Texts.WriteElem(w, e); Texts.Insert(t, end, w.buf);
                NEW(e); e.mode := expLeft; e.W := elemW; e.H := elemH; e.handle := FoldHandler;
                NEW(e.hidden); Texts.OpenBuf(e.hidden); e.visible := TRUE;
                Texts.WriteElem(w, e); Texts.Insert(t, beg, w.buf)
        END
END Insert;


PROCEDURE InsertCollapsed*;
        VAR e: Elem; t: Texts.Text; beg, end, time: LONGINT;
BEGIN
        Oberon.GetSelection(t, beg, end, time);
        IF (time >= 0) & (t IS Texts.Text) THEN
                NEW(e); e.mode := colRight; e.W := elemW; e.H := elemH; e.handle := FoldHandler;
                e.visible := TRUE; Texts.WriteElem(w, e); Texts.Insert(t, end, w.buf);
                NEW(e); e.mode := colLeft; e.W := elemW; e.H := elemH; e.handle := FoldHandler;
                NEW(e.hidden); Texts.OpenBuf(e.hidden); e.visible := TRUE;
                Texts.WriteElem(w, e); Texts.Insert(t, beg, w.buf)
        END
END InsertCollapsed;


PROCEDURE Marks*;
        VAR s: Texts.Scanner; t: Texts.Text; beg, end, time: LONGINT; visible: BOOLEAN;
                wt: Texts.Text; r: Texts.Reader;
BEGIN
        wt := TargetText();
        IF wt # NIL THEN
                Texts.OpenScanner(s, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(s);
                IF (s.class = Texts.Char) & (s.c = "^") & (s.line = 0) THEN
                        Oberon.GetSelection(t, beg, end, time);
                        IF time >= 0 THEN Texts.OpenScanner(s, t, beg); Texts.Scan(s) END
                END;
                IF (s.class = Texts.Name) & ((s.s = "on") OR (s.s = "off")) THEN visible := s.s = "on";
                        Texts.OpenReader(r, wt, 0);
                        LOOP Texts.ReadElem(r);
                                IF r.elem = NIL THEN EXIT
                                ELSIF r.elem IS Elem THEN
                                        r.elem(Elem).visible := visible; r.elem(Elem).pos := Texts.Pos(r) - 1;
                                        Update(r.elem(Elem))
                                END
                        END
                END
        END
END Marks;


PROCEDURE Search*;
        VAR v: Viewers.Viewer; f: TextFrames.Frame; t: Texts.Text; r: Texts.Reader; beg, end, time, lim: LONGINT;
                i: INTEGER; ch: CHAR; e: Texts.Elem; ntfy: Texts.Notifier; E: MarkElem; m: Oberon.ControlMsg;
BEGIN
        v := Oberon.Par.vwr;
        IF Oberon.Par.frame # v.dsc THEN v := Oberon.FocusViewer END;
        IF (v # NIL) & (v IS MenuViewers.Viewer) & (v.dsc.next IS TextFrames.Frame) THEN
                f := v.dsc.next(TextFrames.Frame);
                inf.text := f.text(Texts.Text);
                IF f.hasCar THEN inf.pos := f.carloc.pos; TextFrames.RemoveCaret(f) ELSE inf.pos := 0 END;
                Oberon.GetSelection(t, beg, end, time);
                IF time >= 0 THEN       (*else find again*)
                        Texts.OpenReader(r, t, beg); inf.len := 0;
                        WHILE beg < end DO Texts.Read(r, inf.pat[inf.len]); INC(inf.len); INC(beg) END;
                        inf.pat[inf.len] := 0X;
                        m.id := Oberon.neutralize; Viewers.Broadcast(m);
                END;
                IF inf.len > 0 THEN
                        Echo(inf.text, FALSE);
                        ExpandAll(inf.text, inf.pos, TRUE);
                        inf.found := FALSE; lim := inf.text.len - inf.len;
                        Texts.OpenReader(r, inf.text, inf.pos);
                        LOOP Texts.Read(r, ch); (*find*)
                                IF inf.pos > lim THEN EXIT
                                ELSIF ch = inf.pat[0] THEN
                                        Texts.Read(r, ch); i := 1;
                                        WHILE (i < inf.len) & (ch = inf.pat[i]) DO Texts.Read(r, ch); INC(i) END;
                                        IF i = inf.len THEN inf.pos := inf.pos + inf.len; inf.found := TRUE; EXIT
                                        ELSE INC(inf.pos); Texts.OpenReader(r, inf.text, inf.pos)
                                        END
                                ELSE INC(inf.pos)
                                END
                        END;
                        IF inf.found THEN
                                NEW(E); E.W := 0; E.H := 0; E.handle := MarkHandler;
                                Texts.WriteElem(w, E); Texts.Insert(inf.text, inf.pos, w.buf);
                                CollapseAll(inf.text, {tempLeft});
                                Echo(inf.text, TRUE);
                                FindElem(inf.text, 0, FindCheck, e, inf.pos);
                                IF E = e (*FindElem did not expand anything*) THEN Echo(inf.text, FALSE) END;
                                Texts.Delete(inf.text, inf.pos, inf.pos + 1); Echo(inf.text, TRUE);
                                end := TextFrames.Pos(f, f.X + f.W, f.Y);
                                IF (inf.pos < f.org) OR (inf.pos >= end) THEN TextFrames.Show(f, inf.pos - 120) END;
                                TextFrames.SetCaret(f, inf.pos)
                        ELSE CollapseAll(inf.text, {tempLeft}); Echo(inf.text, TRUE)
                        END
                END
        END
END Search;


PROCEDURE Expand*;
        VAR t: Texts.Text;
BEGIN t := TargetText(); IF t # NIL THEN ExpandAll(t, 0, FALSE) END
END Expand;


PROCEDURE Collapse*;
        VAR t: Texts.Text;
BEGIN t := TargetText(); IF t # NIL THEN CollapseAll(t, {expLeft, tempLeft, findLeft}) END
END Collapse;


PROCEDURE New*;
        VAR e: Elem;
BEGIN NEW(e); e.handle := FoldHandler; Texts.new := e
END New;


PROCEDURE Init; (*for SPARCstatiom, DECstation and RS6000*)
        VAR img: ARRAY 10 OF SET;
BEGIN
        img[1] := {2};
        img[2] := {2..3};
        img[3] := {2..4};
        img[4] := {2..5};
        img[5] := {2..6};
        img[6] := {2..5};
        img[7] := {2..4};
        img[8] := {2..3};
        img[9] := {2};
        Pat[0]:=Display.NewPattern(img, 8, 9);  (*collapsed left*)

        img[1] := {2};
        img[2] := {2, 3};
        img[3] := {2, 4};
        img[4] := {2, 5};
        img[5] := {2, 6};
        img[6] := {2, 5};
        img[7] := {2, 4};
        img[8] := {2, 3};
        img[9] := {2};
        Pat[3]:=Display.NewPattern(img, 8, 9);  (*expanded left*)

        img[1] := {5};
        img[2] := {4..5};
        img[3] := {3..5};
        img[4] := {2..5};
        img[5] := {1..5};
        img[6] := {2..5};
        img[7] := {3..5};
        img[8] := {4..5};
        img[9] := {5};
        Pat[1]:=Display.NewPattern(img, 8, 9);  (*collapsed right*)

        img[1] := {5};
        img[2] := {4, 5};
        img[3] := {3, 5};
        img[4] := {2, 5};
        img[5] := {1, 5};
        img[6] := {2, 5};
        img[7] := {3, 5};
        img[8] := {4, 5};
        img[9] := {5};
        Pat[2]:=Display.NewPattern(img, 8, 9);  (*expanded right*)

        Pat[4]:=Pat[3]; Pat[5]:=Pat[3];
        inf.len:=0; elemW:=8*LONG(pixel); elemH:=12*LONG(pixel); x0:=0; y0:=3
END Init;

(* PROCEDURE Init;
BEGIN
        icl[1] := {2, 10..11, 18..20, 26..29};
        icl[2] := {2..6, 10..13, 18..20, 26..27};
        icl[3] := {2};
        Pat[0]:=Display.NewPattern(icl, 8, 9);  (*collapsed left*)

        iel[1] := {2,   10,11,   18,20,   26,29};
        iel[2] := {2,6,   10,13,   18,20,   26,27};
        iel[3] := {2};
        Pat[3]:=Display.NewPattern(iel, 8, 9);  (*expanded left*)

        icr[1] := {5, 12..13, 19..21, 26..29};
        icr[2] := {1..5, 10..13, 19..21, 28..29};
        icr[3] := {5};
        Pat[1]:=Display.NewPattern(icr, 8, 9);  (*collapsed right*)

        ier[1] := {5,   12,13,   19,21,   26,29};
        ier[2] := {1,5,   10,13,   19,21,   28,29};
        ier[3] := {5};
        Pat[2]:=Display.NewPattern(ier, 8, 9);  (*expanded right*)

        Pat[4]:=Pat[3]; Pat[5]:=Pat[3];
        inf.len:=0; elemW:=8*LONG(pixel); elemH:=12*LONG(pixel); x0:=0; y0:=3
END Init; *)

BEGIN
        Init; Texts.OpenWriter(w)
END FoldElems.
