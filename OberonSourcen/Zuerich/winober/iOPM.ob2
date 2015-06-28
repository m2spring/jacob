MODULE iOPM;

   IMPORT SYSTEM, Texts, Fonts, Kernel, Display;

   CONST
      BoolSize* = 1;
      ByteSize* = 1;
      CharSize* = 1;
      ConstNotAlloc* = -1;
      Eot* = 0X;
      ExpHdProcFld* = FALSE;
      ExpHdPtrFld* = TRUE;
      ExpHdTProc* = FALSE;
      ExpParAdr* = FALSE;
      ExpVarAdr* = FALSE;
      IntSize* = 2;
      LANotAlloc* = -1;
      LIntSize* = 4;
      LRealSize* = 8;
      MaxCC* = -1;
      MaxCaseRange* = 512;
      MaxCases* = 128;
      MaxHDig* = 8;
      MaxHaltNr* = 255;
      MaxIndex* = 2147483647;
      MaxInt* = 32767;
      MaxLExp* = 308;
      MaxLInt* = 2147483647;
      MaxRExp* = 38;
      MaxRegNr* = 7;
      MaxSInt* = 127;
      MaxSet* = 31;
      MaxSysFlag* = 0;
      MinHaltNr* = 20;
      MinInt* = -32768;
      MinLInt* =  -2147483647-1;
      MinRegNr* = 0;
      MinSInt* = -128;
      NEWusingAdr* = TRUE;
      PointerSize* = 4;
      ProcSize* = 4;
      RealSize* = 4;
      SIntSize* = 1;
      SetSize* = 4;
      TDAdrUndef* = -1;
      nilval* = 0;

   VAR
      MaxLReal*: LONGREAL;
      MaxReal*: REAL;
      MinLReal*: LONGREAL;
      MinReal*: REAL;
      breakpc*: LONGINT;
      curpos*: LONGINT;
      errpos*: LONGINT;
      noerr*: BOOLEAN;

   PROCEDURE CloseOldSym*;
   BEGIN
   END CloseOldSym;

   PROCEDURE CloseRefObj*;
   BEGIN
   END CloseRefObj;

   PROCEDURE DeleteNewSym*;
   BEGIN
   END DeleteNewSym;

   PROCEDURE EqualSym* (VAR oldkey: LONGINT): BOOLEAN;
   BEGIN
    RETURN FALSE;
   END EqualSym;

   PROCEDURE Get* (VAR ch: CHAR);
   BEGIN
   END Get;

   PROCEDURE Init* (source: Texts.Reader; log: Texts.Text);
   BEGIN
   END Init;

   PROCEDURE LogW* (ch: CHAR);
   BEGIN
   END LogW;

   PROCEDURE LogWLn*;
   BEGIN
   END LogWLn;

   PROCEDURE LogWNum* (i, len: LONGINT);
   BEGIN
   END LogWNum;

   PROCEDURE LogWStr* (s: ARRAY OF CHAR);
   BEGIN
   END LogWStr;

   PROCEDURE Mark* (n: INTEGER; pos: LONGINT);
   BEGIN
   END Mark;

   PROCEDURE NewKey* (): LONGINT;
   BEGIN
    RETURN 0;
   END NewKey;

   PROCEDURE NewSym* (VAR modName: ARRAY OF CHAR; VAR done: BOOLEAN);
   BEGIN
   END NewSym;

   PROCEDURE ObjW* (ch: CHAR);
   BEGIN
   END ObjW;

   PROCEDURE ObjWBytes* (VAR bytes: ARRAY OF SYSTEM.BYTE; n: LONGINT);
   BEGIN
   END ObjWBytes;

   PROCEDURE ObjWInt* (i: INTEGER);
   BEGIN
   END ObjWInt;

   PROCEDURE ObjWLInt* (i: LONGINT);
   BEGIN
   END ObjWLInt;

   PROCEDURE OldSym* (VAR modName: ARRAY OF CHAR; self: BOOLEAN; VAR done: BOOLEAN);
   BEGIN
   END OldSym;

   PROCEDURE OpenRefObj* (VAR modName: ARRAY OF CHAR);
   BEGIN
   END OpenRefObj;

   PROCEDURE RefW* (ch: CHAR);
   BEGIN
   END RefW;

   PROCEDURE RefWNum* (i: LONGINT);
   BEGIN
   END RefWNum;

   PROCEDURE RegisterNewSym* (VAR modName: ARRAY OF CHAR);
   BEGIN
   END RegisterNewSym;

   PROCEDURE SymRCh* (VAR ch: CHAR);
   BEGIN
   END SymRCh;

   PROCEDURE SymRInt* (VAR k: LONGINT);
   BEGIN
   END SymRInt;

   PROCEDURE SymRLInt* (VAR k: LONGINT);
   BEGIN
   END SymRLInt;

   PROCEDURE SymRLReal* (VAR lr: LONGREAL);
   BEGIN
   END SymRLReal;

   PROCEDURE SymRReal* (VAR r: REAL);
   BEGIN
   END SymRReal;

   PROCEDURE SymRSet* (VAR s: SET);
   BEGIN
   END SymRSet;

   PROCEDURE SymRTag* (VAR k: INTEGER);
   BEGIN
   END SymRTag;

   PROCEDURE SymWCh* (ch: CHAR);
   BEGIN
   END SymWCh;

   PROCEDURE SymWInt* (k: LONGINT);
   BEGIN
   END SymWInt;

   PROCEDURE SymWLInt* (k: LONGINT);
   BEGIN
   END SymWLInt;

   PROCEDURE SymWLReal* (lr: LONGREAL);
   BEGIN
   END SymWLReal;

   PROCEDURE SymWReal* (r: REAL);
   BEGIN
   END SymWReal;

   PROCEDURE SymWSet* (s: SET);
   BEGIN
   END SymWSet;

   PROCEDURE SymWTag* (k: INTEGER);
   BEGIN
   END SymWTag;

   PROCEDURE eofSF* (): BOOLEAN;
   BEGIN
    RETURN FALSE;
   END eofSF;

   PROCEDURE err* (n: INTEGER);
   BEGIN
   END err;

END iOPM.
