MODULE Texts;

   IMPORT Files, Fonts, Kernel, Display;

   CONST
      Char* = 6;
      ElemChar* = 1CX;
      Int* = 3;
      Inval* = 0;
      LongReal* = 5;
      Name* = 1;
      Real* = 4;
      String* = 2;
      delete* = 2;
      insert* = 1;
      load* = 0;
      replace* = 0;
      store* = 1;

   TYPE
      Buffer* = POINTER TO BufDesc;
      BufDesc* = RECORD
         len*: LONGINT;
      END;
      ElemMsg* = RECORD END;
      Elem* = POINTER TO ElemDesc;
      CopyMsg* = RECORD (ElemMsg)
         e*: Elem;
      END;
      Handler* = PROCEDURE (e: Elem; VAR msg: ElemMsg);
      ElemDesc* = RECORD
         W*, H*: LONGINT;
         handle*: Handler;
      END;
      FileMsg* = RECORD (ElemMsg)
         id*: INTEGER;
         pos*: LONGINT;
         r*: Files.Rider;
      END;
      IdentifyMsg* = RECORD (ElemMsg)
         mod*, proc*: ARRAY 32 OF CHAR;
      END;
      Text* = POINTER TO TextDesc;
      Notifier* = PROCEDURE (T: Text; op: INTEGER; beg, end: LONGINT);
      Reader* = RECORD
         eot*: BOOLEAN;
         fnt*: Fonts.Font;
         col*, voff*: SHORTINT;
         elem*: Elem;
      END;
      Scanner* = RECORD (Reader)
         nextCh*: CHAR;
         line*, class*: INTEGER;
         i*: LONGINT;
         x*: REAL;
         y*: LONGREAL;
         c*: CHAR;
         len*: SHORTINT;
         s*: ARRAY 64 OF CHAR;
      END;
      TextDesc* = RECORD
         len*: LONGINT;
         notify*: Notifier;
      END;
      Writer* = RECORD
         buf*: Buffer;
         fnt*: Fonts.Font;
         col*, voff*: SHORTINT;
      END;

   VAR
      new*: Elem;

   PROCEDURE Append* (T: Text; B: Buffer);
   BEGIN
   END Append;

   PROCEDURE ChangeLooks* (T: Text; beg, end: LONGINT; sel: SET; fnt: Fonts.Font; col, voff: SHORTINT);
   BEGIN
   END ChangeLooks;

   PROCEDURE Close* (T: Text; name: ARRAY OF CHAR);
   BEGIN
   END Close;

   PROCEDURE Copy* (SB, DB: Buffer);
   BEGIN
   END Copy;

   PROCEDURE CopyElem* (SE, DE: Elem);
   BEGIN
   END CopyElem;

   PROCEDURE Delete* (T: Text; beg, end: LONGINT);
   BEGIN
   END Delete;

   PROCEDURE ElemBase* (E: Elem): Text;
   BEGIN
    RETURN NIL;
   END ElemBase;

   PROCEDURE ElemPos* (E: Elem): LONGINT;
   BEGIN
    RETURN 0;
   END ElemPos;

   PROCEDURE Insert* (T: Text; pos: LONGINT; B: Buffer);
   BEGIN
   END Insert;

   PROCEDURE Load* (VAR r: Files.Rider; T: Text);
   BEGIN
   END Load;

   PROCEDURE Open* (T: Text; name: ARRAY OF CHAR);
   BEGIN
   END Open;

   PROCEDURE OpenBuf* (B: Buffer);
   BEGIN
   END OpenBuf;

   PROCEDURE OpenReader* (VAR R: Reader; T: Text; pos: LONGINT);
   BEGIN
   END OpenReader;

   PROCEDURE OpenScanner* (VAR S: Scanner; T: Text; pos: LONGINT);
   BEGIN
   END OpenScanner;

   PROCEDURE OpenWriter* (VAR W: Writer);
   BEGIN
   END OpenWriter;

   PROCEDURE Pos* (VAR R: Reader): LONGINT;
   BEGIN
    RETURN 0;
   END Pos;

   PROCEDURE Read* (VAR R: Reader; VAR ch: CHAR);
   BEGIN
   END Read;

   PROCEDURE ReadElem* (VAR R: Reader);
   BEGIN
   END ReadElem;

   PROCEDURE ReadPrevElem* (VAR R: Reader);
   BEGIN
   END ReadPrevElem;

   PROCEDURE Recall* (VAR B: Buffer);
   BEGIN
   END Recall;

   PROCEDURE Save* (T: Text; beg, end: LONGINT; B: Buffer);
   BEGIN
   END Save;

   PROCEDURE Scan* (VAR S: Scanner);
   BEGIN
   END Scan;

   PROCEDURE SetColor* (VAR W: Writer; col: SHORTINT);
   BEGIN
   END SetColor;

   PROCEDURE SetFont* (VAR W: Writer; fnt: Fonts.Font);
   BEGIN
   END SetFont;

   PROCEDURE SetOffset* (VAR W: Writer; voff: SHORTINT);
   BEGIN
   END SetOffset;

   PROCEDURE Store* (VAR r: Files.Rider; T: Text);
   BEGIN
   END Store;

   PROCEDURE Write* (VAR W: Writer; ch: CHAR);
   BEGIN
   END Write;

   PROCEDURE WriteDate* (VAR W: Writer; t, d: LONGINT);
   BEGIN
   END WriteDate;

   PROCEDURE WriteElem* (VAR W: Writer; e: Elem);
   BEGIN
   END WriteElem;

   PROCEDURE WriteHex* (VAR W: Writer; x: LONGINT);
   BEGIN
   END WriteHex;

   PROCEDURE WriteInt* (VAR W: Writer; x, n: LONGINT);
   BEGIN
   END WriteInt;

   PROCEDURE WriteLn* (VAR W: Writer);
   BEGIN
   END WriteLn;

   PROCEDURE WriteLongReal* (VAR W: Writer; x: LONGREAL; n: LONGINT);
   BEGIN
   END WriteLongReal;

   PROCEDURE WriteLongRealHex* (VAR W: Writer; x: LONGREAL);
   BEGIN
   END WriteLongRealHex;

   PROCEDURE WriteReal* (VAR W: Writer; x: REAL; n: LONGINT);
   BEGIN
   END WriteReal;

   PROCEDURE WriteRealFix* (VAR W: Writer; x: REAL; n, k: LONGINT);
   BEGIN
   END WriteRealFix;

   PROCEDURE WriteRealHex* (VAR W: Writer; x: REAL);
   BEGIN
   END WriteRealHex;

   PROCEDURE WriteString* (VAR W: Writer; s: ARRAY OF CHAR);
   BEGIN
   END WriteString;

END Texts.
