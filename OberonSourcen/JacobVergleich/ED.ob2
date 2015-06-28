MODULE ED;

IMPORT
   ARG, Idents, O, OT, STR, Strings, SYSTEM, UTI,
Storage;

TYPE   tCol*       = INTEGER;
CONST
   MaxStringLength = 1000;
   MaxTabCount     = 10;
TYPE
   tStringPtr      = POINTER TO tString;
   tString         = ARRAY MaxStringLength+1 OF CHAR;

   tData           = RECORD
                      len : tCol;
                      ch  : ARRAY MaxStringLength+1 OF CHAR;
                     END;

   tLinePtr        = POINTER TO tLine;
   tLine           = RECORD
                      len   : tCol;
                      sP    : tStringPtr;
                      prevP ,
                      nextP : tLinePtr;
                     END;

   tEnvPtr         = POINTER TO tEnv;
   tEnv            = RECORD
                      indentCol : tCol;
                      tabCol    : ARRAY MaxTabCount+1 OF tCol;
                      prevP     : tEnvPtr;
                     END;

   tEditor*         = POINTER TO tEditorStruct;
   tEditorStruct   = RECORD
                      headLineP ,
                      actLineP  ,
                      tailLineP : tLinePtr;

                      curX      : tCol;
                      actEnvP   : tEnvPtr;
                     END;

PROCEDURE^CR*(Editor : tEditor);
(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE TraceBegin(s : ARRAY OF CHAR);
BEGIN (* TraceBegin *)
 IF ARG.OptionTraceEdCalls
    THEN O.Str('BEGIN Ed.');
         O.Str(s);
         O.Ln;
 END; (* IF *)
END TraceBegin;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE TraceEnd(s : ARRAY OF CHAR);
BEGIN (* TraceEnd *)
 IF ARG.OptionTraceEdCalls
    THEN O.Str('END   Ed.');
         O.Str(s);
         O.Ln;
 END; (* IF *)
END TraceEnd;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Length(VAR s : ARRAY OF CHAR) : LONGINT;
VAR
   i : LONGINT;
BEGIN (* Length *)
 i:=0;
 WHILE i<LEN(s) DO
  IF s[i]=0X THEN RETURN i; END; (* IF *)
  INC(i);
 END; (* WHILE *)
 RETURN LEN(s);
END Length;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE GetLine(Editor : tEditor; VAR Data : tData);
VAR
   i : tCol;
BEGIN (* GetLine *)
  IF Editor^.actLineP=NIL
     THEN Data.len:=0;
     ELSE 
           Data.len:=Editor^.actLineP^.len;
           FOR i:=1 TO Editor^.actLineP^.len DO
            Data.ch[i]:=Editor^.actLineP^.sP^[i];
           END; (* FOR *)
  END; (* IF *)
END GetLine;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE PutLine(Editor : tEditor; VAR Data : tData);
VAR
   i : tCol;
BEGIN (* PutLine *)
  IF Editor^.actLineP=NIL
     THEN NEW(Editor^.actLineP);
          Editor^.actLineP^.len   := 0;
          Editor^.actLineP^.sP    := NIL;
          Editor^.actLineP^.prevP := NIL;
          Editor^.actLineP^.nextP := NIL;
          Editor^.headLineP       := Editor^.actLineP;
          Editor^.tailLineP       := Editor^.actLineP;
  END; (* IF *)

   IF Editor^.actLineP^.len>0 THEN Storage.DEALLOCATE(Editor^.actLineP^.sP,Editor^.actLineP^.len); Editor^.actLineP^.sP:=NIL; END; (* IF *)

   Editor^.actLineP^.len:=Data.len;
   IF Editor^.actLineP^.len>0
      THEN Storage.ALLOCATE(Editor^.actLineP^.sP,Editor^.actLineP^.len);
           FOR i:=1 TO Editor^.actLineP^.len DO
            Editor^.actLineP^.sP^[i]:=Data.ch[i];
           END; (* FOR *)
   END; (* IF *)
END PutLine;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE InsLine(Editor : tEditor);
VAR
   lP : tLinePtr;
BEGIN (* InsLine *)
  NEW(lP);
   lP^.len   := 0;
   lP^.sP    := NIL;
   lP^.prevP := NIL;
   lP^.nextP := NIL;

  IF Editor^.actLineP=NIL
     THEN Editor^.headLineP                := lP;
          Editor^.actLineP                 := lP;
          Editor^.tailLineP                := lP;
     ELSE lP^.prevP                := Editor^.actLineP;
          lP^.nextP                := Editor^.actLineP^.nextP;
          IF lP^.nextP=NIL
             THEN Editor^.tailLineP        := lP;
             ELSE lP^.nextP^.prevP := lP;
          END; (* IF *)
          Editor^.actLineP^.nextP          := lP;
          Editor^.actLineP                 := lP;
  END; (* IF *)
END InsLine;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE NewEnv(prevEnvP : tEnvPtr) : tEnvPtr;
VAR
   eP : tEnvPtr;
   i  : tCol;
BEGIN (* NewEnv *)
 NEW(eP);
  eP^.indentCol:=1;
  IF prevEnvP=NIL
     THEN FOR i:=1 TO MaxTabCount DO eP^.tabCol[i]:=1; END; (* FOR *)
     ELSE eP^.tabCol:=prevEnvP^.tabCol;
  END; (* IF *)
  eP^.prevP:=prevEnvP;
 RETURN eP;
END NewEnv;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Create*() : tEditor;
VAR
   Editor : tEditor;
BEGIN (* Create *)
 TraceBegin('Create');

 NEW(Editor);
  Editor^.headLineP := NIL;
  Editor^.actLineP  := NIL;
  Editor^.tailLineP := NIL;
  Editor^.curX      := 1;
  Editor^.actEnvP   := NewEnv(NIL);

 TraceEnd('Create');
 RETURN Editor;
END Create;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Kill*(VAR Editor : tEditor);
VAR
   ilP, dlP : tLinePtr;
   ieP, deP : tEnvPtr;
BEGIN (* Kill *)
 TraceBegin('Kill');

  ilP:=Editor^.headLineP;
  WHILE ilP#NIL DO
    IF ilP^.len>0 THEN Storage.DEALLOCATE(ilP^.sP,ilP^.len); END; (* IF *)
    dlP:=ilP; ilP:=ilP^.nextP;
   Storage.DEALLOCATE(dlP,SIZE(tLine));
  END; (* WHILE *)

  ieP:=Editor^.actEnvP;
  WHILE ieP#NIL DO
   deP:=ieP; ieP:=ieP^.prevP;
   Storage.DEALLOCATE(deP,SIZE(tEnv));
  END; (* WHILE *)
 Storage.DEALLOCATE(Editor,SIZE(tEditorStruct));

 TraceEnd('Kill');
END Kill;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE curCol*(Editor : tEditor) : tCol;
BEGIN (* curCol *)
 TraceBegin('curCol');
 TraceEnd('curCol');

 RETURN Editor^.curX;
END curCol;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE indCol*(Editor : tEditor) : tCol;
BEGIN (* indCol *)
 TraceBegin('indCol');
 TraceEnd('indCol');

 RETURN Editor^.actEnvP^.indentCol;
END indCol;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Text*(Editor : tEditor; str : ARRAY OF CHAR);
VAR
   s    : ARRAY 500 OF CHAR;
   d    : tData;
   i, n : tCol;
BEGIN (* Text *)
 STR.Conc3(s,'Text           ("',str,'")');
 TraceBegin(s);

 IF str[0]=0X THEN TraceEnd('Text'); RETURN; END; (* IF *)

 n:=SHORT(Length(str));
  GetLine(Editor,d);

  IF Editor^.curX>d.len+1
     THEN FOR i:=d.len+1 TO Editor^.curX-1 DO
           d.ch[i]:=' ';
          END; (* FOR *)
          d.len:=Editor^.curX-1;
  ELSIF Editor^.curX<=d.len
     THEN FOR i:=Editor^.curX TO Editor^.curX+n-1 DO
           d.ch[i+n]:=d.ch[i];
          END; (* FOR *)
  END; (* IF *)

  FOR i:=0 TO n-1 DO
   d.ch[Editor^.curX+i]:=str[i];
  END; (* FOR *)
  INC(d.len,n);
  INC(Editor^.curX,n);
  PutLine(Editor,d);

 TraceEnd('Text');
END Text;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE TextLn*(Editor : tEditor; str : ARRAY OF CHAR);
BEGIN (* TextLn *)
 TraceBegin('TextLn');

 Text(Editor,str);
 CR(Editor);

 TraceEnd('TextLn');
END TextLn;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE CharRep*(Editor : tEditor; c : CHAR; count : LONGINT);
VAR
   s : ARRAY MaxStringLength+1 OF CHAR;
   i : LONGINT;
BEGIN (* CharRep *)
 TraceBegin('CharRep');

 IF count<=0 THEN TraceEnd('CharRep'); RETURN; END; (* IF *)

 IF count>=MaxStringLength THEN count:=MaxStringLength; END; (* IF *)
 FOR i:=0 TO count-1 DO
  s[i]:=c;
 END; (* FOR *)
 s[count]:=0X;

 Text(Editor,s);

 TraceEnd('CharRep');
END CharRep;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Line*(Editor : tEditor);
BEGIN (* Line *)
 TraceBegin('Line');

 CharRep(Editor,'-',79);
 CR(Editor);

 TraceEnd('Line');
END Line;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Ident*(Editor : tEditor; ident : Idents.tIdent);
VAR
   s : Strings.tString;
   a : ARRAY MaxStringLength+1 OF CHAR;
BEGIN (* Ident *)
 TraceBegin('Ident');

 Idents.GetString(ident,s);
 Strings.StringToArray(s,a);
 Text(Editor,a);

 TraceEnd('Ident');
END Ident;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Boolean*(Editor : tEditor; val : OT.oBOOLEAN);
VAR
   s : ARRAY 51 OF CHAR;
BEGIN (* Boolean *)
 TraceBegin('Boolean');

 OT.oBOOLEAN2ARR(val,s);
 Text(Editor,s);

 TraceEnd('Boolean');
END Boolean;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Char*(Editor : tEditor; val : OT.oCHAR);
VAR
   s : ARRAY 51 OF CHAR;
BEGIN (* Char *)
 TraceBegin('Char');

 OT.oCHAR2ARR(val,s);
 Text(Editor,s);

 TraceEnd('Char');
END Char;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE String*(Editor : tEditor; val : OT.oSTRING);
VAR
   s : ARRAY 501 OF CHAR;
BEGIN (* String *)
 TraceBegin('String');

 OT.oSTRING2ARR(val,s);
 Text(Editor,s);

 TraceEnd('String');
END String;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Set*(Editor : tEditor; val : OT.oSET);
VAR
   s : ARRAY 501 OF CHAR;
BEGIN (* Set *)
 TraceBegin('Set');

 OT.oSET2ARR(val,s);
 Text(Editor,s);

 TraceEnd('Set');
END Set;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE SetElems*(Editor : tEditor; val : OT.oSET);
VAR a,b:LONGINT; f:BOOLEAN; s,t:ARRAY 81 OF CHAR; 
BEGIN (* SetElems *)
 TraceBegin('SetElems');

 s:=''; f:=TRUE; 
 a:=OT.MINoSET;
 WHILE a<=OT.MAXoSET DO
  IF a IN val THEN b:=a;
     WHILE (b<OT.MAXoSET) & ((b+1) IN val) DO INC(b); END; (* WHILE *)

     IF ~f THEN STR.Append(s,','); ELSE f:=FALSE; END; (* IF *)
     UTI.Shortcard2Arr(a,t); STR.Append(s,t);
     IF b>a THEN UTI.Shortcard2Arr(b,t); STR.App2(s,'..',t); END; (* IF *)

     a:=b;
  END; (* IF *)
  INC(a);
 END; (* WHILE *)

 Text(Editor,s);

 TraceEnd('SetElems');
END SetElems;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Longint*(Editor : tEditor; val : OT.oLONGINT);
VAR
   s : ARRAY 51 OF CHAR;
BEGIN (* Longint *)
 TraceBegin('Longint');

 OT.oLONGINT2ARR(val,s);
 Text(Editor,s);

 TraceEnd('Longint');
END Longint;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Num*(Editor : tEditor; val, width : LONGINT);
VAR
   s : ARRAY 51 OF CHAR;
BEGIN (* Num *)
 TraceBegin('Num');

 STR.StrNum(s,val,width);
 Text(Editor,s);

 TraceEnd('Num');
END Num;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Addr*(Editor : tEditor; val : SYSTEM.PTR);
VAR
   s : ARRAY 51 OF CHAR;
BEGIN (* Addr *)
 TraceBegin('Addr');

 UTI.Addr2ArrHex(val,s);
 Text(Editor,s);

 TraceEnd('Addr');
END Addr;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Real*(Editor : tEditor; val : OT.oREAL);
VAR
   s : ARRAY 51 OF CHAR;
BEGIN (* Real *)
 TraceBegin('Real');

 OT.oREAL2ARR(val,s);
 Text(Editor,s);

 TraceEnd('Real');
END Real;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Longreal*(Editor : tEditor; val : OT.oLONGREAL);
VAR
   s : ARRAY 51 OF CHAR;
BEGIN (* Longreal *)
 TraceBegin('Longreal');

 OT.oLONGREAL2ARR(val,s);
 Text(Editor,s);

 TraceEnd('Longreal');
END Longreal;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE CR*(Editor : tEditor);
BEGIN (* CR *)
 TraceBegin('CR');

  InsLine(Editor);
  Editor^.curX:=1+Editor^.actEnvP^.indentCol-1;

 TraceEnd('CR');
END CR;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Indent*(Editor : tEditor; ind : tCol);
BEGIN (* Indent *)
 TraceBegin('Indent');

  Editor^.actEnvP:=NewEnv(Editor^.actEnvP);
  Editor^.actEnvP^.indentCol := Editor^.actEnvP^.prevP^.indentCol+ind;
  Editor^.curX               := Editor^.actEnvP^.indentCol;

 TraceEnd('Indent');
END Indent;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE IndentCur*(Editor : tEditor);
BEGIN (* IndentCur *)
 TraceBegin('IndentCur');

  Indent(Editor,Editor^.curX-Editor^.actEnvP^.indentCol);

 TraceEnd('IndentCur');
END IndentCur;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Undent*(Editor : tEditor);
VAR
   eP : tEnvPtr;
BEGIN (* Undent *)
 TraceBegin('Undent');

  IF Editor^.actEnvP^.prevP#NIL
     THEN eP      := Editor^.actEnvP;
          Editor^.actEnvP := Editor^.actEnvP^.prevP;
          Storage.DEALLOCATE(eP,SIZE(tEnv));
          Editor^.curX    := Editor^.actEnvP^.indentCol;
  END; (* IF *)

 TraceEnd('Undent');
END Undent;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE SetTab*(Editor : tEditor; tNum : LONGINT; col : tCol);
BEGIN (* SetTab *)
 TraceBegin('SetTab');

  IF (col>0) & (1<=tNum) & (tNum<=MaxTabCount)
     THEN Editor^.actEnvP^.tabCol[tNum]:=Editor^.actEnvP^.indentCol+col-1;
  END; (* IF *)

 TraceEnd('SetTab');
END SetTab;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Home*(Editor : tEditor);
BEGIN (* Home *)
 TraceBegin('Home');

  Editor^.curX:=Editor^.actEnvP^.indentCol;

 TraceEnd('Home');
END Home;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Eol*(Editor : tEditor);
BEGIN (* Eol *)
 TraceBegin('Eol');

  IF Editor^.actLineP#NIL
     THEN Editor^.curX:=1+Editor^.actLineP^.len;
  END; (* IF *)

 TraceEnd('Eol');
END Eol;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Tab*(Editor : tEditor; tNum : LONGINT);
BEGIN (* Tab *)
 TraceBegin('Tab');

  IF (1<=tNum) & (tNum<=MaxTabCount)
     THEN IF Editor^.actEnvP^.tabCol[tNum]>Editor^.curX THEN Editor^.curX:=Editor^.actEnvP^.tabCol[tNum]; END; (* IF *)
  END; (* IF *)

 TraceEnd('Tab');
END Tab;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Dump*(Editor : tEditor);
VAR
   i  : tCol;
   lP : tLinePtr;
BEGIN (* Dump *)
 TraceBegin('Dump');

  lP:=Editor^.headLineP;
  WHILE lP#NIL DO
    FOR i:=1 TO lP^.len DO
     O.Char(lP^.sP^[i]);
    END; (* FOR *)
    O.Ln;
    lP:=lP^.nextP;
  END; (* WHILE *)

 TraceEnd('Dump');
END Dump;

(*------------------------------------------------------------------------------------------------------------------------------*)
END ED.


