MODULE TestElems;       (** CAS 11-Jul-91 **)
        IMPORT
                Oberon, Input, Display, Viewers, Files, Fonts, Printer, Texts,
                WriteFrames, WritePrinter;

        CONST
                mm = WriteFrames.mm; unit = WriteFrames.Unit; Unit = WritePrinter.Unit;
                rightKey = 0; middleKey = 1; leftKey = 2;

        TYPE
                Elem = POINTER TO ElemDesc;
                ElemDesc = RECORD (Texts.ElemDesc)
                        data: ARRAY 8 OF CHAR
                END;
                Frame = Display.Frame;  (*could be any frame*)
                NotifyMsg = RECORD (Display.FrameMsg) END;

        VAR
                notify: POINTER TO NotifyMsg;


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


        PROCEDURE Changed (E: Elem; pos: LONGINT);
                (*if an element has changed and its position in the host text is unknown, one has to search the text using ReadElem*)
                VAR T: Texts.Text;
        BEGIN T := Texts.ElemBase(E); T.notify(T, Texts.replace, pos, pos + 1)
        END Changed;


        PROCEDURE(*<*>*) HandleFrame (F: Display.Frame; VAR msg: Display.FrameMsg);
        BEGIN
                IF msg IS NotifyMsg THEN        (*frame received broadcast message*)
                        Display.ReplConst(Display.white, F.X + 1, F.Y + 1, F.W - 2, F.H - 2, Display.invert)
                ELSIF msg IS Oberon.InputMsg THEN       (*frame became Write focus and thus has to handle mouse*)
                        WITH msg: Oberon.InputMsg DO
                                IF msg.id = Oberon.track THEN Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, msg.X, msg.Y) END
                        END
                END
        END HandleFrame;


        PROCEDURE(*<*>*) HandleElem (E: Texts.Elem; VAR msg: Texts.ElemMsg);
                VAR e: Elem; f: Frame; P: WriteFrames.Parc; beg: LONGINT; keys, keysum: SET; w, h: INTEGER;
        BEGIN
                WITH E: Elem DO
                        IF msg IS WriteFrames.DisplayMsg THEN
                                WITH msg: WriteFrames.DisplayMsg DO
                                        IF msg.prepare THEN     (*automatically adopt measures to element's environment*)
                                                WriteFrames.ParcBefore(Texts.ElemBase(E), msg.pos, P, beg);
                                                E.H := P.lsp    (*; E.W := P.width - msg.indent would adapt to remaining space in line*)
                                        ELSE    (*element is fully visible: draw it to the screen*)
                                                w := SHORT(E.W DIV unit); h := SHORT(E.H DIV unit);
                                                Display.ReplConst(Display.white, msg.X0 + 1, msg.Y0 + 1, w - 2, h - 2, Display.replace);
                                                NEW(f); f.X := msg.X0; f.Y := msg.Y0; f.W := w; f.H := h; f.handle := HandleFrame;
                                                msg.elemFrame := f      (*elem returns optional frame; receiver for broadcasts; support of inplace editing*)
                                        END
                                END
                        ELSIF msg IS WritePrinter.PrintMsg THEN
                                WITH msg: WritePrinter.PrintMsg DO
                                        IF msg.prepare THEN     (*automatically adopt measures to element's environment*)
                                                WriteFrames.ParcBefore(Texts.ElemBase(E), msg.pos, P, beg);
                                                E.H := P.lsp    (*; E.W := P.width - msg.indent would adapt to remaining space in line*)
                                        ELSE    (*element is fully visible: print it*)
                                                Printer.Line(msg.X0 + 1, msg.Y0 + 1, SHORT(E.W DIV Unit) - 2, SHORT(E.H DIV Unit) - 2)
                                        END
                                END
                        ELSIF msg IS Texts.IdentifyMsg THEN     (*return element's identity, i.e. its allocation command*)
                                WITH msg: Texts.IdentifyMsg DO
                                        msg.mod := "TestElems"; msg.proc := "Alloc"
                                END
                        ELSIF msg IS Texts.FileMsg THEN
                                WITH msg: Texts.FileMsg DO
                                        IF msg.id = Texts.load THEN     (*load element specific data*)
                                                ReadString(msg.r, E.data)
                                        ELSIF msg.id = Texts.store THEN (*store element specific data*)
                                                WriteString(msg.r, E.data)
                                        END
                                END
                        ELSIF msg IS Texts.CopyMsg THEN (*copy element*)
                                NEW(e); Texts.CopyElem(E, e);   (*create new element and copy state of base type*)
                                e.data := E.data;       (*copy specific state into new element*)
                                msg(Texts.CopyMsg).e := e       (*return copy in message*)
                        ELSIF msg IS WriteFrames.TrackMsg THEN  (*a mouse click hit the element*)
                                WITH msg: WriteFrames.TrackMsg DO
                                        IF msg.keys = {middleKey} THEN keysum := msg.keys;
                                                w := SHORT(E.W DIV unit); h := SHORT(E.H DIV unit);
                                                Oberon.RemoveMarks(msg.X0, msg.Y0, w, h);
                                                Display.ReplConst(Display.white, msg.X0 + 1, msg.Y0 + 1, w - 2, h - 2, Display.invert);
                                                REPEAT Input.Mouse(keys, msg.X, msg.Y); keysum := keysum + keys;
                                                        Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, msg.X, msg.Y)
                                                UNTIL keys = {};
                                                Display.ReplConst(Display.white, msg.X0 + 1, msg.Y0 + 1, w - 2, h - 2, Display.invert);
                                                IF (keysum = {middleKey, leftKey}) & (E.W > 4 * mm) THEN DEC(E.W, 2 * mm);
                                                        Changed(E, msg.pos)
                                                ELSIF msg.keys = {middleKey, rightKey} THEN INC(E.W, 2 * mm);
                                                        Changed(E, msg.pos)
                                                END
                                        END
                                END
                        END
                END
        END HandleElem;


        PROCEDURE(*<*>*) MiscHandle (E: Texts.Elem; VAR msg: Texts.ElemMsg);  (*subclass handler of HandleElem*)
        BEGIN
                WITH E: Elem DO
                        IF msg IS Texts.IdentifyMsg THEN
                                WITH msg: Texts.IdentifyMsg DO  (*name of a nonexistent procedure -> cannot be loaded again*)
                                        msg.mod := "TestElems"; msg.proc := "Unknown"
                                        (*ignoring the identify message (or returning msg.mod = "") causes element not to be stored*)
                                END
                        ELSE HandleElem(E, msg)
                        END
                END
        END MiscHandle;


        PROCEDURE Alloc*;       (*allocation procedure for class Elem; allocates specific element and installs handler*)
                VAR e: Elem;
        BEGIN NEW(e); e.handle := HandleElem; Texts.new := e
        END Alloc;


        PROCEDURE Insert*;      (** W H -- demonstrates behaviour of trivial floating element**)
                VAR S: Texts.Scanner; e: Elem; w: LONGINT;
        BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S); w := S.i; Texts.Scan(S);
                NEW(e); e.W := w*mm; e.H := S.i*mm; e.handle := HandleElem; e.data := "testing";
                WriteFrames.CopyToFocus(e)
        END Insert;

        PROCEDURE InsertMisc*;  (** W H -- demonstrates handling of elements which cannot be loaded on opening**)
                VAR S: Texts.Scanner; e: Elem; w: LONGINT;
        BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S); w := S.i; Texts.Scan(S);
                NEW(e); e.W := w*mm; e.H := S.i*mm; e.handle := MiscHandle; e.data := "testing";
                WriteFrames.CopyToFocus(e)
        END InsertMisc;

        PROCEDURE Broadcast*;   (**demonstrate effect of special viewer broadcast message**)
                VAR msg: NotifyMsg;
        BEGIN Viewers.Broadcast(msg)
        END Broadcast;

END TestElems.
