(* $Id: Scanner.mi,v 2.11 1992/09/24 13:14:00 grosch rel $ *)

MODULE Scanner;
 
IMPORT SYSTEM, Checks, System, General, Positions, IO, DynArray, Strings, Source,
(* line 52 "oberon.rex" *)
  ERR          , 
                Idents       ,
                O            ,
                OT           ,
                POS          ,
                Strings1     ,
                UTI          ;

         CONST  TokenNameMaxLength*      = 10;

                IdentToken*              = 1 ;          CaretToken*        = 24; (* ^       *)  ImportToken*    = 47; (* IMPORT    *)
                IntegerToken*            = 2 ;          EqualToken*        = 25; (* =       *)  InToken*        = 48; (* IN        *)
                RealToken*               = 3 ;          UnequalToken*      = 26; (* #       *)  IsToken*        = 49; (* IS        *)
                LongrealToken*           = 4 ;          LessToken*         = 27; (* <       *)  LoopToken*      = 50; (* LOOP      *)
                CharToken*               = 5 ;          GreaterToken*      = 28; (* >       *)  ModToken*       = 51; (* MOD       *)
                StringToken*             = 6 ;          LessEqualToken*    = 29; (* <=      *)  ModuleToken*    = 52; (* MODULE    *)
                PlusToken*               = 7 ; (* + *)  GreaterEqualToken* = 30; (* >=      *)  NilToken*       = 53; (* NIL       *)
                HyphenToken*             = 8 ; (* - *)  DotDotToken*       = 31; (* ..      *)  OfToken*        = 54; (* OF        *)
                AsteriskToken*           = 9 ; (* * *)  ColonToken*        = 32; (* :       *)  OrToken*        = 55; (* OR        *)
                SlantMarkToken*          = 10; (* / *)  ArrayToken*        = 33; (* ARRAY   *)  PointerToken*   = 56; (* POINTER   *)
                TildeToken*              = 11; (* ~ *)  BeginToken*        = 34; (* BEGIN   *)  ProcedureToken* = 57; (* PROCEDURE *)
                AmpersandToken*          = 12; (* & *)  ByToken*           = 35; (* BY      *)  RecordToken*    = 58; (* RECORD    *)
                PeriodToken*             = 13; (* . *)  CaseToken*         = 36; (* CASE    *)  RepeatToken*    = 59; (* REPEAT    *)
                CommaToken*              = 14; (* , *)  ConstToken*        = 37; (* CONST   *)  ReturnToken*    = 60; (* RETURN    *)
                SemicolonToken*          = 15; (* ; *)  DivToken*          = 38; (* DIV     *)  ThenToken*      = 61; (* THEN      *)
                BarToken*                = 16; (* | *)  DoToken*           = 39; (* DO      *)  ToToken*        = 62; (* TO        *)
                OpenRoundBracketToken*   = 17; (* ( *)  ElseToken*         = 40; (* ELSE    *)  TypeToken*      = 63; (* TYPE      *)
                CloseRoundBracketToken*  = 18; (* ) *)  ElsifToken*        = 41; (* ELSIF   *)  UntilToken*     = 64; (* UNTIL     *)
                OpenSquareBracketToken*  = 19; (* [ *)  EndToken*          = 42; (* END     *)  VarToken*       = 65; (* VAR       *)
                CloseSquareBracketToken* = 20; (* ] *)  ExitToken*         = 43; (* EXIT    *)  WhileToken*     = 66; (* WHILE     *)
                OpenBraceToken*          = 21; (* { *)  ForeignToken*      = 44; (* FOREIGN *)  WithToken*      = 67; (* WITH      *)
                CloseBraceToken*         = 22; (* } *)  ForToken*          = 45; (* FOR     *)   
                AssignToken*             = 23; (* :=*)  IfToken*           = 46; (* IF      *) 

         TYPE   tPosition*               = POS.tPosition;
                tScanAttribute*         = RECORD
                                           Position* : POS.tPosition;
                                           Ident*    : Idents.tIdent;
                                           Integer*  : OT.oLONGINT  ;
                                           Real*     : OT.oREAL     ;
                                           Longreal* : OT.oLONGREAL ;
                                           Char*     : OT.oCHAR     ;
                                           String*   : OT.oSTRING   ;
                                          END;

CONST EofToken*	= 0;

VAR TokenLength*	: LONGINT;
VAR Attribute*	: tScanAttribute;
VAR ScanTabName*	: ARRAY 128 OF CHAR;
VAR Exit*	: PROCEDURE;

         CONST  NoInteger    = 0               ;                        (* used for ErrorAttribute                              *)
                TAB          = 9X              ;                        (* used for tab characters in string constants          *)
         VAR    String       : Strings.tString ;                        (* temporary for the init section                       *)
                NoIdent      : Idents.tIdent   ;                        (* used for ErrorAttribute, initialized in init section *)
                NestingLevel :LONGINT;                         (* counts comment nesting                               *)

CONST
   yyTabSpace		= 8;
   yyDNoState		= 0;
   yyFileStackSize	= 16;
   yyInitBufferSize	= 1024 * 8 + 256;
yyFirstCh	= 0X;
yyLastCh	= 0FFX;
yyEolCh	= 0AX;
yyEobCh	= 7FX;
yyDStateCount	= 191;
yyTableSize	= 1437;
yyEobState	= 28;
yyDefaultState	= 29;
STD	= 1;
Comment	= 3;
StrSQ	= 5;
StrDQ	= 7;
 
TYPE
   yyTableElmt		= LONGINT; 
   yyStateRange		= LONGINT;
   yyTableRange		= LONGINT;
   yyCombType		= RECORD Check, Next: yyStateRange; END;
   yyCombTypePtr	= POINTER TO yyCombType;
   yytChBufferPtr	= POINTER TO ARRAY 100000 OF CHAR;
   yyChRange		= LONGINT;

VAR
   yyBasePtr		: ARRAY yyDStateCount+1 OF LONGINT	;
   yyDefault		: ARRAY yyDStateCount+1 OF yyStateRange	;
   yyComb		: ARRAY yyTableSize+1 OF yyCombType	;
   yyEobTrans		: ARRAY yyDStateCount+1 OF yyStateRange	;
   yyToLower, yyToUpper	: ARRAY ORD(yyLastCh)-ORD(yyFirstCh)+1 OF CHAR		;

   yyStateStack		: POINTER TO ARRAY 100000 OF yyStateRange;
   yyStateStackSize	: LONGINT;
   yyStartState		: yyStateRange;
   yyPreviousStart	: yyStateRange;
   yyCh			: CHAR;
   yyChi:LONGINT; 
 
   yySourceFile		: System.tFile;
   yyEof		: BOOLEAN;
   yyChBufferPtr	: yytChBufferPtr;
   yyChBufferStart	: LONGINT;
   yyChBufferSize	: LONGINT;
   yyChBufferIndex	: LONGINT;
   yyBytesRead		: LONGINT;
   yyLineCount		:INTEGER; 
   yyLineStart		: LONGINT;

   yyFileStackPtr	:LONGINT; 
   yyFileStack		: ARRAY yyFileStackSize+2 OF RECORD
   			     SourceFile		: System.tFile;
			     Eof		: BOOLEAN;
   			     ChBufferPtr	: yytChBufferPtr;
			     ChBufferStart	: LONGINT;
			     ChBufferSize	: LONGINT;
   			     ChBufferIndex	: LONGINT;
   			     BytesRead		: LONGINT;
   			     LineCount		:INTEGER; 
   			     LineStart		: LONGINT;
			  END;

         PROCEDURE ErrorAttribute*(Token : LONGINT; VAR Attribute : tScanAttribute);
         BEGIN
          CASE Token OF
          |IdentToken   : Attribute.Ident    := NoIdent      ;
          |IntegerToken : Attribute.Integer  := NoInteger    ;
          |RealToken    : Attribute.Real     := OT.NoReal    ;
          |LongrealToken: Attribute.Longreal := OT.NoLongreal;
          |CharToken    : Attribute.Char     := OT.NoChar    ;
          |StringToken  : Attribute.String   := OT.NoString  ;
          ELSE
          END; (* CASE *)
         END ErrorAttribute;

         PROCEDURE TokenNum2TokenName*(TokenNum : LONGINT; VAR TokenName : ARRAY OF CHAR);
         BEGIN (* TokenNum2TokenName *)
          CASE TokenNum OF
          |EofToken               : Strings1.Assign(TokenName,'<eof>'     );
          |IdentToken             : Strings1.Assign(TokenName,'<ident>'   );
          |IntegerToken           : Strings1.Assign(TokenName,'<integer>' );
          |RealToken              : Strings1.Assign(TokenName,'<real>'    );
          |LongrealToken          : Strings1.Assign(TokenName,'<longreal>');
          |CharToken              : Strings1.Assign(TokenName,'<char>'    );
          |StringToken            : Strings1.Assign(TokenName,'<string>'  );
          |PlusToken              : Strings1.Assign(TokenName,'+'         );
          |HyphenToken            : Strings1.Assign(TokenName,'-'         );
          |AsteriskToken          : Strings1.Assign(TokenName,'*'         );
          |SlantMarkToken         : Strings1.Assign(TokenName,'/'         );
          |TildeToken             : Strings1.Assign(TokenName,'~'         );
          |AmpersandToken         : Strings1.Assign(TokenName,'&'         );
          |PeriodToken            : Strings1.Assign(TokenName,'.'         );
          |CommaToken             : Strings1.Assign(TokenName,','         );
          |SemicolonToken         : Strings1.Assign(TokenName,';'         );
          |BarToken               : Strings1.Assign(TokenName,'|'         );
          |OpenRoundBracketToken  : Strings1.Assign(TokenName,'('         );
          |CloseRoundBracketToken : Strings1.Assign(TokenName,')'         );
          |OpenSquareBracketToken : Strings1.Assign(TokenName,'['         );
          |CloseSquareBracketToken: Strings1.Assign(TokenName,']'         );
          |OpenBraceToken         : Strings1.Assign(TokenName,'{'         );
          |CloseBraceToken        : Strings1.Assign(TokenName,'}'         );
          |AssignToken            : Strings1.Assign(TokenName,':='        );
          |CaretToken             : Strings1.Assign(TokenName,'^'         );
          |EqualToken             : Strings1.Assign(TokenName,'='         );
          |UnequalToken           : Strings1.Assign(TokenName,'#'         );
          |LessToken              : Strings1.Assign(TokenName,'<'         );
          |GreaterToken           : Strings1.Assign(TokenName,'>'         );
          |LessEqualToken         : Strings1.Assign(TokenName,'<='        );
          |GreaterEqualToken      : Strings1.Assign(TokenName,'>='        );
          |DotDotToken            : Strings1.Assign(TokenName,'..'        );
          |ColonToken             : Strings1.Assign(TokenName,':'         );
          |ArrayToken             : Strings1.Assign(TokenName,'ARRAY'     );
          |BeginToken             : Strings1.Assign(TokenName,'BEGIN'     );
          |ByToken                : Strings1.Assign(TokenName,'BY'        );
          |CaseToken              : Strings1.Assign(TokenName,'CASE'      );
          |ConstToken             : Strings1.Assign(TokenName,'CONST'     );
          |DivToken               : Strings1.Assign(TokenName,'DIV'       );
          |DoToken                : Strings1.Assign(TokenName,'DO'        );
          |ElseToken              : Strings1.Assign(TokenName,'ELSE'      );
          |ElsifToken             : Strings1.Assign(TokenName,'ELSIF'     );
          |EndToken               : Strings1.Assign(TokenName,'END'       );
          |ExitToken              : Strings1.Assign(TokenName,'EXIT'      );
          |ForToken               : Strings1.Assign(TokenName,'FOR'       );
          |ForeignToken           : Strings1.Assign(TokenName,'FOREIGN'   );
          |IfToken                : Strings1.Assign(TokenName,'IF'        );
          |ImportToken            : Strings1.Assign(TokenName,'IMPORT'    );
          |InToken                : Strings1.Assign(TokenName,'IN'        );
          |IsToken                : Strings1.Assign(TokenName,'IS'        );
          |LoopToken              : Strings1.Assign(TokenName,'LOOP'      );
          |ModToken               : Strings1.Assign(TokenName,'MOD'       );
          |ModuleToken            : Strings1.Assign(TokenName,'MODULE'    );
          |NilToken               : Strings1.Assign(TokenName,'NIL'       );
          |OfToken                : Strings1.Assign(TokenName,'OF'        );
          |OrToken                : Strings1.Assign(TokenName,'OR'        );
          |PointerToken           : Strings1.Assign(TokenName,'POINTER'   );
          |ProcedureToken         : Strings1.Assign(TokenName,'PROCEDURE' );
          |RecordToken            : Strings1.Assign(TokenName,'RECORD'    );
          |RepeatToken            : Strings1.Assign(TokenName,'REPEAT'    );
          |ReturnToken            : Strings1.Assign(TokenName,'RETURN'    );
          |ThenToken              : Strings1.Assign(TokenName,'THEN'      );
          |ToToken                : Strings1.Assign(TokenName,'TO'        );
          |TypeToken              : Strings1.Assign(TokenName,'TYPE'      );
          |UntilToken             : Strings1.Assign(TokenName,'UNTIL'     );
          |VarToken               : Strings1.Assign(TokenName,'VAR'       );
          |WhileToken             : Strings1.Assign(TokenName,'WHILE'     );
          |WithToken              : Strings1.Assign(TokenName,'WITH'      );
          ELSE                      Strings1.Assign(TokenName,'<?token>'  );
          END; (* CASE *)
         END TokenNum2TokenName; 
 
PROCEDURE^yyStart (State: yyStateRange);
PROCEDURE^GetWord (VAR Word: Strings.tString);
PROCEDURE^yyTab;
PROCEDURE^yyEol (Column: LONGINT);
PROCEDURE^yyGetTables;
PROCEDURE^yyInitialize;
PROCEDURE^yyErrorMessage (ErrorCode:INTEGER);
PROCEDURE^CloseFile;
PROCEDURE^yyGetTable (TableFile: System.tFile; Address:LONGINT): LONGINT;

PROCEDURE GetToken*(): LONGINT;
   VAR
      yyState		: yyStateRange;
      yyTablePtr	: yyCombTypePtr;
      yyRestartFlag	: BOOLEAN;
      yyi, yySource, yyTarget, yyChBufferFree	: LONGINT;
(* line 154 "oberon.rex" *)
   VAR Repr, Str1, Str2 : Strings.tString;
             OK               : BOOLEAN; 
BEGIN
   LOOP
      yyState		:= yyStartState;
      TokenLength 	:= 0;
 
      (* ASSERT yyChBuffer [yyChBufferIndex] = first character *)
 
      LOOP		(* eventually restart after sentinel *)
	 LOOP		(* execute as many state transitions as possible *)
	    					(* determine next state *)
	    yyTablePtr := SYSTEM.VAL(yyCombTypePtr,yyBasePtr [yyState] +
	       ORD (yyChBufferPtr^ [yyChBufferIndex]) * SIZE (yyCombType));
	    IF yyTablePtr^.Check # yyState THEN
	       yyState := yyDefault [yyState];
	       IF yyState = yyDNoState THEN EXIT; END;
	    ELSE
	       yyState := yyTablePtr^.Next;
	       INC (TokenLength);
	       yyStateStack^ [TokenLength] := yyState;	(* push state *)
	       INC (yyChBufferIndex);		(* get next character *)
	    END;
	 END;
 
	 LOOP					(* search for last final state *)
CASE yyStateStack^ [TokenLength] OF
|190
:
(* line 189 "oberon.rex" *)
                                                                                            (* !Comments *)
  INC(NestingLevel);
  yyStart(Comment);

yyRestartFlag := FALSE; EXIT;
|189
:
(* line 194 "oberon.rex" *)

   DEC(NestingLevel);
   IF NestingLevel=0
      THEN yyStart(STD);
   END;

yyRestartFlag := FALSE; EXIT;
|11
,20
,33
,188
,191
:
(* line 201 "oberon.rex" *)


yyRestartFlag := FALSE; EXIT;
|12
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 207 "oberon.rex" *)
                                                                                             (* !Integers *)
   GetWord(Repr);
   OT.LONGCARD2oLONGINT(UTI.Str2Longcard(Repr,OK),Attribute.Integer);
   IF ~OK THEN ERR.MsgPos(ERR.MsgIllegalIntegerConst,Attribute.Position); END;
   RETURN IntegerToken;

yyRestartFlag := FALSE; EXIT;
|18
:
DEC (yyChBufferIndex, 2);
DEC (TokenLength, 2);
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 207 "oberon.rex" *)
                                                                                             (* !Integers *)
   GetWord(Repr);
   OT.LONGCARD2oLONGINT(UTI.Str2Longcard(Repr,OK),Attribute.Integer);
   IF ~OK THEN ERR.MsgPos(ERR.MsgIllegalIntegerConst,Attribute.Position); END;
   RETURN IntegerToken;

yyRestartFlag := FALSE; EXIT;
|16
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 214 "oberon.rex" *)

   GetWord(Repr);
   OT.LONGCARD2oLONGINT(UTI.HexStr2Longcard(Repr,OK),Attribute.Integer);
   IF ~OK THEN ERR.MsgPos(ERR.MsgIllegalIntegerConst,Attribute.Position); END;
   RETURN IntegerToken;

yyRestartFlag := FALSE; EXIT;
|14
,21
,22
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 223 "oberon.rex" *)
                                                                    (* !Reals *)
   GetWord(Repr);
   OT.STR2oREAL(Repr,Attribute.Real,OK);
   IF ~OK THEN ERR.MsgPos(ERR.MsgIllegalRealConst,Attribute.Position); END;
   RETURN RealToken;

yyRestartFlag := FALSE; EXIT;
|19
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 230 "oberon.rex" *)

   GetWord(Repr);
   OT.STR2oLONGREAL(Repr,Attribute.Longreal,OK);
   IF ~OK THEN ERR.MsgPos(ERR.MsgIllegalLongrealConst,Attribute.Position); END;
   RETURN LongrealToken;

yyRestartFlag := FALSE; EXIT;
|17
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 239 "oberon.rex" *)
                                                                                          (* !Chars *)
   GetWord(Repr);
   OT.HEXSTR2oCHAR(Repr,Attribute.Char,OK);
   IF ~OK THEN ERR.MsgPos(ERR.MsgIllegalCharConst,Attribute.Position); END;
   RETURN CharToken;

yyRestartFlag := FALSE; EXIT;
|187
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 248 "oberon.rex" *)
                                                                                                          (* !Strings *)
   Strings.AssignEmpty(Str1); yyStart(StrSQ);

yyRestartFlag := FALSE; EXIT;
|10
,34
:
(* line 252 "oberon.rex" *)

   GetWord(Str2); Strings.Concatenate(Str1,Str2);

yyRestartFlag := FALSE; EXIT;
|186
:
(* line 256 "oberon.rex" *)

   yyStart(STD);
   CASE Strings.Length(Str1) OF
   |0 : Attribute.String := OT.NoString;                    RETURN StringToken;
   |1 : OT.CHAR2oCHAR(Strings.Char(Str1,1),Attribute.Char); RETURN CharToken;                              (* !CharEqualString1 *)
   ELSE OT.STR2oSTRING(Str1,Attribute.String);              RETURN StringToken;
   END; (* CASE *)

yyRestartFlag := FALSE; EXIT;
|185
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 265 "oberon.rex" *)
                                                                                                         (* !Strings *)
   Strings.AssignEmpty(Str1); yyStart(StrDQ);

yyRestartFlag := FALSE; EXIT;
|9
,35
:
(* line 269 "oberon.rex" *)

   GetWord(Str2); Strings.Concatenate(Str1,Str2);

yyRestartFlag := FALSE; EXIT;
|184
:
(* line 273 "oberon.rex" *)

   yyStart(STD);
   CASE Strings.Length(Str1) OF
   |0 : Attribute.String := OT.NoString;                    RETURN StringToken;
   |1 : OT.CHAR2oCHAR(Strings.Char(Str1,1),Attribute.Char); RETURN CharToken;                              (* !CharEqualString1 *)
   ELSE OT.STR2oSTRING(Str1,Attribute.String);              RETURN StringToken;
   END; (* CASE *)

yyRestartFlag := FALSE; EXIT;
|183
:
(* line 282 "oberon.rex" *)

   Strings.Append(Str1,TAB); yyTab;

yyRestartFlag := FALSE; EXIT;
|182
:
(* line 286 "oberon.rex" *)
                                                                                     (* !NoNewlineInString *)
   ERR.MsgPos(ERR.MsgStringNotTerminated,Attribute.Position);
   yyEol(0); yyStart(STD);
   OT.STR2oSTRING(Str1,Attribute.String);
   RETURN StringToken;

yyRestartFlag := FALSE; EXIT;
|181
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 295 "oberon.rex" *)
 RETURN PlusToken              ; 
yyRestartFlag := FALSE; EXIT;
|180
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 296 "oberon.rex" *)
 RETURN HyphenToken            ; 
yyRestartFlag := FALSE; EXIT;
|179
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 297 "oberon.rex" *)
 RETURN AsteriskToken          ; 
yyRestartFlag := FALSE; EXIT;
|178
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 298 "oberon.rex" *)
 RETURN SlantMarkToken         ; 
yyRestartFlag := FALSE; EXIT;
|177
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 299 "oberon.rex" *)
 RETURN TildeToken             ; 
yyRestartFlag := FALSE; EXIT;
|176
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 300 "oberon.rex" *)
 RETURN AmpersandToken         ; 
yyRestartFlag := FALSE; EXIT;
|157
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 301 "oberon.rex" *)
 RETURN PeriodToken            ; 
yyRestartFlag := FALSE; EXIT;
|175
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 302 "oberon.rex" *)
 RETURN CommaToken             ; 
yyRestartFlag := FALSE; EXIT;
|174
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 303 "oberon.rex" *)
 RETURN SemicolonToken         ; 
yyRestartFlag := FALSE; EXIT;
|173
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 304 "oberon.rex" *)
 RETURN BarToken               ; 
yyRestartFlag := FALSE; EXIT;
|172
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 305 "oberon.rex" *)
 RETURN OpenRoundBracketToken  ; 
yyRestartFlag := FALSE; EXIT;
|171
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 306 "oberon.rex" *)
 RETURN CloseRoundBracketToken ; 
yyRestartFlag := FALSE; EXIT;
|170
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 307 "oberon.rex" *)
 RETURN OpenSquareBracketToken ; 
yyRestartFlag := FALSE; EXIT;
|169
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 308 "oberon.rex" *)
 RETURN CloseSquareBracketToken; 
yyRestartFlag := FALSE; EXIT;
|168
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 309 "oberon.rex" *)
 RETURN OpenBraceToken         ; 
yyRestartFlag := FALSE; EXIT;
|167
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 310 "oberon.rex" *)
 RETURN CloseBraceToken        ; 
yyRestartFlag := FALSE; EXIT;
|166
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 311 "oberon.rex" *)
 RETURN AssignToken            ; 
yyRestartFlag := FALSE; EXIT;
|165
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 312 "oberon.rex" *)
 RETURN CaretToken             ; 
yyRestartFlag := FALSE; EXIT;
|164
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 313 "oberon.rex" *)
 RETURN EqualToken             ; 
yyRestartFlag := FALSE; EXIT;
|163
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 314 "oberon.rex" *)
 RETURN UnequalToken           ; 
yyRestartFlag := FALSE; EXIT;
|161
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 315 "oberon.rex" *)
 RETURN LessToken              ; 
yyRestartFlag := FALSE; EXIT;
|159
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 316 "oberon.rex" *)
 RETURN GreaterToken           ; 
yyRestartFlag := FALSE; EXIT;
|162
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 317 "oberon.rex" *)
 RETURN LessEqualToken         ; 
yyRestartFlag := FALSE; EXIT;
|160
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 318 "oberon.rex" *)
 RETURN GreaterEqualToken      ; 
yyRestartFlag := FALSE; EXIT;
|158
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 319 "oberon.rex" *)
 RETURN DotDotToken            ; 
yyRestartFlag := FALSE; EXIT;
|156
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 320 "oberon.rex" *)
 RETURN ColonToken             ; 
yyRestartFlag := FALSE; EXIT;
|155
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 324 "oberon.rex" *)
 RETURN ArrayToken             ; 
yyRestartFlag := FALSE; EXIT;
|150
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 325 "oberon.rex" *)
 RETURN BeginToken             ; 
yyRestartFlag := FALSE; EXIT;
|146
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 326 "oberon.rex" *)
 RETURN ByToken                ; 
yyRestartFlag := FALSE; EXIT;
|144
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 327 "oberon.rex" *)
 RETURN CaseToken              ; 
yyRestartFlag := FALSE; EXIT;
|141
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 328 "oberon.rex" *)
 RETURN ConstToken             ; 
yyRestartFlag := FALSE; EXIT;
|136
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 329 "oberon.rex" *)
 RETURN DivToken               ; 
yyRestartFlag := FALSE; EXIT;
|134
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 330 "oberon.rex" *)
 RETURN DoToken                ; 
yyRestartFlag := FALSE; EXIT;
|132
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 331 "oberon.rex" *)
 RETURN ElseToken              ; 
yyRestartFlag := FALSE; EXIT;
|131
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 332 "oberon.rex" *)
 RETURN ElsifToken             ; 
yyRestartFlag := FALSE; EXIT;
|127
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 333 "oberon.rex" *)
 RETURN EndToken               ; 
yyRestartFlag := FALSE; EXIT;
|125
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 334 "oberon.rex" *)
 RETURN ExitToken              ; 
yyRestartFlag := FALSE; EXIT;
|117
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 335 "oberon.rex" *)
 RETURN ForToken               ; 
yyRestartFlag := FALSE; EXIT;
|121
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 336 "oberon.rex" *)
 RETURN ForeignToken           ; 
yyRestartFlag := FALSE; EXIT;
|114
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 337 "oberon.rex" *)
 RETURN IfToken                ; 
yyRestartFlag := FALSE; EXIT;
|113
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 338 "oberon.rex" *)
 RETURN ImportToken            ; 
yyRestartFlag := FALSE; EXIT;
|108
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 339 "oberon.rex" *)
 RETURN InToken                ; 
yyRestartFlag := FALSE; EXIT;
|107
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 340 "oberon.rex" *)
 RETURN IsToken                ; 
yyRestartFlag := FALSE; EXIT;
|105
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 341 "oberon.rex" *)
 RETURN LoopToken              ; 
yyRestartFlag := FALSE; EXIT;
|98
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 342 "oberon.rex" *)
 RETURN ModToken               ; 
yyRestartFlag := FALSE; EXIT;
|101
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 343 "oberon.rex" *)
 RETURN ModuleToken            ; 
yyRestartFlag := FALSE; EXIT;
|95
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 344 "oberon.rex" *)
 RETURN NilToken               ; 
yyRestartFlag := FALSE; EXIT;
|92
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 345 "oberon.rex" *)
 RETURN OfToken                ; 
yyRestartFlag := FALSE; EXIT;
|91
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 346 "oberon.rex" *)
 RETURN OrToken                ; 
yyRestartFlag := FALSE; EXIT;
|89
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 347 "oberon.rex" *)
 RETURN PointerToken           ; 
yyRestartFlag := FALSE; EXIT;
|83
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 348 "oberon.rex" *)
 RETURN ProcedureToken         ; 
yyRestartFlag := FALSE; EXIT;
|74
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 349 "oberon.rex" *)
 RETURN RecordToken            ; 
yyRestartFlag := FALSE; EXIT;
|70
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 350 "oberon.rex" *)
 RETURN RepeatToken            ; 
yyRestartFlag := FALSE; EXIT;
|66
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 351 "oberon.rex" *)
 RETURN ReturnToken            ; 
yyRestartFlag := FALSE; EXIT;
|60
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 352 "oberon.rex" *)
 RETURN ThenToken              ; 
yyRestartFlag := FALSE; EXIT;
|57
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 353 "oberon.rex" *)
 RETURN ToToken                ; 
yyRestartFlag := FALSE; EXIT;
|56
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 354 "oberon.rex" *)
 RETURN TypeToken              ; 
yyRestartFlag := FALSE; EXIT;
|52
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 355 "oberon.rex" *)
 RETURN UntilToken             ; 
yyRestartFlag := FALSE; EXIT;
|47
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 356 "oberon.rex" *)
 RETURN VarToken               ; 
yyRestartFlag := FALSE; EXIT;
|44
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 357 "oberon.rex" *)
 RETURN WhileToken             ; 
yyRestartFlag := FALSE; EXIT;
|40
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 358 "oberon.rex" *)
 RETURN WithToken              ; 
yyRestartFlag := FALSE; EXIT;
|13
,37
,38
,39
,41
,42
,43
,45
,46
,48
,49
,50
,51
,53
,54
,55
,58
,59
,61
,62
,63
,64
,65
,67
,68
,69
,71
,72
,73
,75
,76
,77
,78
,79
,80
,81
,82
,84
,85
,86
,87
,88
,90
,93
,94
,96
,97
,99
,100
,102
,103
,104
,106
,109
,110
,111
,112
,115
,116
,118
,119
,120
,122
,123
,124
,126
,128
,129
,130
,133
,135
,137
,138
,139
,140
,142
,143
,145
,147
,148
,149
,151
,152
,153
,154
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 362 "oberon.rex" *)
                                                                             (* !Identifiers *)
   GetWord(Repr);
   Attribute.Ident:=Idents.MakeIdent(Repr);
   RETURN IdentToken;

yyRestartFlag := FALSE; EXIT;
|36
:
Attribute.Position.Line   := yyLineCount;
Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart - TokenLength);
(* line 369 "oberon.rex" *)

   ERR.MsgPos(ERR.MsgIllegalCharInSource,Attribute.Position);

yyRestartFlag := FALSE; EXIT;
|32
:
(* BlankAction *)
WHILE yyChBufferPtr^ [yyChBufferIndex] = ' ' DO INC (yyChBufferIndex); END;
yyRestartFlag := FALSE; EXIT;
|31
:
(* TabAction *)
DEC (yyLineStart, 7 - (yyChBufferIndex - yyLineStart - 2) MOD 8);
yyRestartFlag := FALSE; EXIT;
|30
:
(* EolAction *)
INC (yyLineCount);
yyLineStart := yyChBufferIndex - 1;
yyRestartFlag := FALSE; EXIT;
|1
,2
,3
,4
,5
,6
,7
,8
,15
,23
,24
,25
,26
,27
:
	    (* non final states *)
		  DEC (yyChBufferIndex);	(* return character *)
		  DEC (TokenLength)		(* pop state *)
 
| 29:
		  Attribute.Position.Line   := yyLineCount;
		  Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart);
		  INC (yyChBufferIndex);
		  TokenLength := 1;
(* line 161 "oberon.rex" *)
 ERR.MsgPos(ERR.MsgIllegalCharInSource,Attribute.Position); 
	          yyRestartFlag := FALSE; EXIT;

	    |  yyDNoState	:		(* automatic initialization *)
		  yyGetTables;
		  yyStateStack^ [0] := yyDefaultState; (* stack underflow sentinel *)
		  IF yyFileStackPtr = 0 THEN
		     yyInitialize;
		     yySourceFile := System.StdInput;
		  END;
	          yyRestartFlag := FALSE; EXIT;

| 28:
		  DEC (yyChBufferIndex);	(* undo last state transition *)
		  DEC (TokenLength);		(* get previous state *)
		  IF TokenLength = 0 THEN
		     yyState := yyStartState;
		  ELSE
		     yyState := yyStateStack^ [TokenLength];
		  END;

		  IF yyChBufferIndex # yyChBufferStart + yyBytesRead THEN
		     yyState := yyEobTrans [yyState];	(* end of buffer sentinel in buffer *)
		     IF yyState # yyDNoState THEN
			INC (yyChBufferIndex);
			INC (TokenLength);
			yyStateStack^ [TokenLength] := yyState;
			yyRestartFlag := TRUE; EXIT;
		     END;
		  ELSE				(* end of buffer reached *)

		     (* copy initial part of token in front of input buffer *)

		     yySource := yyChBufferIndex - TokenLength - 1;
		     yyTarget := General.MaxAlign - TokenLength MOD General.MaxAlign - 1;
		     IF yySource # yyTarget THEN
			FOR yyi := 1 TO TokenLength DO
			   yyChBufferPtr^ [yyTarget + yyi] := yyChBufferPtr^ [yySource + yyi];
			END;
			DEC (yyLineStart, yySource - yyTarget);
			yyChBufferStart := yyTarget + TokenLength + 1;
		     ELSE
			yyChBufferStart := yyChBufferIndex;
		     END;

		     IF ~yyEof THEN		(* read buffer and restart *)
			yyChBufferFree := General.Exp2 (General.Log2 (yyChBufferSize - 4 - General.MaxAlign - TokenLength));
			IF yyChBufferFree < yyChBufferSize DIV 8 THEN
			   DynArray.ExtendArray (yyChBufferPtr, yyChBufferSize, SIZE (CHAR));
			   IF yyChBufferPtr = NIL THEN yyErrorMessage (1); END;
			   yyChBufferFree := General.Exp2 (General.Log2 (yyChBufferSize - 4 - General.MaxAlign - TokenLength));
			   IF yyStateStackSize < yyChBufferSize THEN
			      DynArray.ExtendArray (yyStateStack, yyStateStackSize, SIZE (yyStateRange));
			      IF yyStateStack = NIL THEN yyErrorMessage (1); END;
			   END;
			END;
			yyChBufferIndex := yyChBufferStart;
			yyBytesRead := Source.GetLine (yySourceFile, SYSTEM.VAL(SYSTEM.PTR,SYSTEM.ADR
			   (yyChBufferPtr^ [yyChBufferIndex])), yyChBufferFree);
			IF yyBytesRead <= 0 THEN yyBytesRead := 0; yyEof := TRUE; END;
			yyChBufferPtr^ [yyChBufferStart + yyBytesRead    ] := yyEobCh;
			yyChBufferPtr^ [yyChBufferStart + yyBytesRead + 1] := 0X;
			yyRestartFlag := TRUE; EXIT;
		     END;

		     IF TokenLength = 0 THEN	(* end of file reached *)
			Attribute.Position.Line   := yyLineCount;
			Attribute.Position.Column := SHORT(yyChBufferIndex - yyLineStart);
			CloseFile;
			IF yyFileStackPtr = 0 THEN
(* line 163 "oberon.rex" *)
     IF yyStartState=Comment
            THEN ERR.MsgPos(ERR.MsgCommentNotClosed,Attribute.Position);
         END;
         IF (yyStartState=StrSQ) OR (yyStartState=StrDQ)
            THEN ERR.MsgPos(ERR.MsgStringNotTerminated,Attribute.Position);
         END;
         yyStart(STD); 
			END;
			IF yyFileStackPtr = 0 THEN RETURN EofToken; END;
			yyRestartFlag := FALSE; EXIT;
		     END;
		  END;
	    ELSE
	       yyErrorMessage (0);
	    END;
	 END;
	 IF yyRestartFlag THEN ELSE EXIT; END;
      END;
   END;
   END GetToken;
 
PROCEDURE BeginFile* (FileName: ARRAY OF CHAR);
   BEGIN
      IF yyStateStack^ [0] = yyDNoState THEN	(* have tables been read in ? *)
	 yyGetTables;
	 yyStateStack^ [0] := yyDefaultState;	(* stack underflow sentinel *)
      END;
      yyInitialize;
      yySourceFile := Source.BeginSource (FileName);
      IF yySourceFile < 0 THEN yyErrorMessage (5); END;
   END BeginFile;

PROCEDURE yyInitialize;
   BEGIN
      IF yyFileStackPtr >= yyFileStackSize THEN yyErrorMessage (3); END;
      INC (yyFileStackPtr);			(* push file *)
	 yyFileStack [yyFileStackPtr].SourceFile	:= yySourceFile		;
	 yyFileStack [yyFileStackPtr].Eof		:= yyEof		;
	 yyFileStack [yyFileStackPtr].ChBufferPtr	:= yyChBufferPtr	;
	 yyFileStack [yyFileStackPtr].ChBufferStart	:= yyChBufferStart	;
	 yyFileStack [yyFileStackPtr].ChBufferSize	:= yyChBufferSize	;
	 yyFileStack [yyFileStackPtr].ChBufferIndex	:= yyChBufferIndex	;
	 yyFileStack [yyFileStackPtr].BytesRead	:= yyBytesRead		;
	 yyFileStack [yyFileStackPtr].LineCount	:= yyLineCount		;
	 yyFileStack [yyFileStackPtr].LineStart	:= yyLineStart		;
						(* initialize file state *)
      yyChBufferSize	:= yyInitBufferSize;
      DynArray.MakeArray (yyChBufferPtr, yyChBufferSize, SIZE (CHAR));
      IF yyChBufferPtr = NIL THEN yyErrorMessage (1); END;
      yyChBufferStart	:= General.MaxAlign;
      yyChBufferPtr^ [yyChBufferStart - 1] := yyEolCh; (* begin of line indicator *)
      yyChBufferPtr^ [yyChBufferStart    ] := yyEobCh; (* end of buffer sentinel *)
      yyChBufferPtr^ [yyChBufferStart + 1] := 0X;
      yyChBufferIndex	:= yyChBufferStart;
      yyEof		:= FALSE;
      yyBytesRead	:= 0;
      yyLineCount	:= 1;
      yyLineStart	:= yyChBufferStart - 1;
   END yyInitialize;

PROCEDURE CloseFile;
   BEGIN
      IF yyFileStackPtr = 0 THEN yyErrorMessage (4); END;
      Source.CloseSource (yySourceFile);
      DynArray.ReleaseArray (yyChBufferPtr, yyChBufferSize, SIZE (CHAR));
	 yySourceFile	:= yyFileStack [yyFileStackPtr].SourceFile		;
	 yyEof		:= yyFileStack [yyFileStackPtr].Eof			;
	 yyChBufferPtr	:= yyFileStack [yyFileStackPtr].ChBufferPtr		;
	 yyChBufferStart:= yyFileStack [yyFileStackPtr].ChBufferStart	;
	 yyChBufferSize	:= yyFileStack [yyFileStackPtr].ChBufferSize		;
	 yyChBufferIndex:= yyFileStack [yyFileStackPtr].ChBufferIndex	;
	 yyBytesRead	:= yyFileStack [yyFileStackPtr].BytesRead		;
	 yyLineCount	:= yyFileStack [yyFileStackPtr].LineCount		;
	 yyLineStart	:= yyFileStack [yyFileStackPtr].LineStart		;
      DEC (yyFileStackPtr);		
   END CloseFile;

PROCEDURE GetWord (VAR Word: Strings.tString);
   VAR i, WordStart	: LONGINT;
   BEGIN
      WordStart := yyChBufferIndex - TokenLength - 1;
      FOR i := 1 TO TokenLength DO
	 Word.Chars [i] := yyChBufferPtr^ [WordStart + i];
      END;
      Word.Length := SHORT(TokenLength);
   END GetWord;
 
PROCEDURE GetLower (VAR Word: Strings.tString);
   VAR i, WordStart	: LONGINT;
   BEGIN
      WordStart := yyChBufferIndex - TokenLength - 1;
      FOR i := 1 TO TokenLength DO
	 Word.Chars [i] := yyToLower [ORD(yyChBufferPtr^ [WordStart + i])];
      END;
      Word.Length := SHORT(TokenLength);
   END GetLower;
 
PROCEDURE GetUpper (VAR Word: Strings.tString);
   VAR i, WordStart	: LONGINT;
   BEGIN
      WordStart := yyChBufferIndex - TokenLength - 1;
      FOR i := 1 TO TokenLength DO
	 Word.Chars [i] := yyToUpper [ORD(yyChBufferPtr^ [WordStart + i])];
      END;
      Word.Length := SHORT(TokenLength);
   END GetUpper;
 
PROCEDURE yyStart (State: yyStateRange);
   BEGIN
      yyPreviousStart	:= yyStartState;
      yyStartState	:= State;
   END yyStart;
 
PROCEDURE yyPrevious;
   VAR s	: yyStateRange;
   BEGIN
      s		      := yyStartState;
      yyStartState    := yyPreviousStart;
      yyPreviousStart := s;
   END yyPrevious;
 
PROCEDURE yyEcho;
   VAR i	: LONGINT;
   BEGIN
      FOR i := yyChBufferIndex - TokenLength TO yyChBufferIndex - 1 DO
	 IO.WriteC (IO.StdOutput, yyChBufferPtr^ [i]);
      END;
   END yyEcho;
 
PROCEDURE yyLess (n: LONGINT);
   BEGIN
      DEC (yyChBufferIndex, TokenLength - n);
      TokenLength := n;
   END yyLess;
 
PROCEDURE yyTab;
   BEGIN
      DEC (yyLineStart, yyTabSpace - 1 - (yyChBufferIndex - yyLineStart - 2) MOD yyTabSpace);
   END yyTab;

PROCEDURE yyTab1 (a: LONGINT);
   BEGIN
      DEC (yyLineStart, yyTabSpace - 1 - (yyChBufferIndex - yyLineStart - TokenLength + a - 1) MOD yyTabSpace);
   END yyTab1;

PROCEDURE yyTab2 (a, b: LONGINT);
   BEGIN
      DEC (yyLineStart, yyTabSpace - 1 - (yyChBufferIndex - yyLineStart - TokenLength + a - 1) MOD yyTabSpace);
   END yyTab2;

PROCEDURE yyEol (Column: LONGINT);
   BEGIN
      INC (yyLineCount);
      yyLineStart := yyChBufferIndex - 1 - Column;
   END yyEol;

PROCEDURE output (c: CHAR);
   BEGIN
      IO.WriteC (IO.StdOutput, c);
   END output;

PROCEDURE unput (c: CHAR);
   BEGIN
      DEC (yyChBufferIndex);
      yyChBufferPtr^ [yyChBufferIndex] := c;
   END unput;

PROCEDURE input (): CHAR;
   BEGIN
      IF yyChBufferIndex = yyChBufferStart + yyBytesRead THEN
	 IF ~yyEof THEN
	    DEC (yyLineStart, yyBytesRead);
	    yyChBufferIndex := 0;
	    yyChBufferStart := 0;
	    yyBytesRead := Source.GetLine (yySourceFile, yyChBufferPtr, General.Exp2 (General.Log2 (yyChBufferSize)));
	    IF yyBytesRead <= 0 THEN yyBytesRead := 0; yyEof := TRUE; END;
	    yyChBufferPtr^ [yyBytesRead    ] := yyEobCh;
	    yyChBufferPtr^ [yyBytesRead + 1] := 0X;
	 END;
      END;
      IF yyChBufferIndex = yyChBufferStart + yyBytesRead THEN
	 RETURN 0X;
      ELSE
	 INC (yyChBufferIndex);
	 RETURN yyChBufferPtr^ [yyChBufferIndex - 1];
      END
   END input;

PROCEDURE BeginScanner*;
   BEGIN
(* line 157 "oberon.rex" *)
   Strings.AssignEmpty(String);
         NoIdent      := Idents.MakeIdent(String);
         NestingLevel := 0; 
   END BeginScanner;
 
PROCEDURE CloseScanner*;
   BEGIN
   END CloseScanner;
 
PROCEDURE yyGetTables;
   VAR
      BlockSize, j, n	: LONGINT;
      TableFile	: System.tFile;
      i		: yyStateRange;
      Base	: ARRAY yyDStateCount+1 OF yyTableRange;
   BEGIN
      BlockSize	:= 64000 DIV SIZE (yyCombType);
      TableFile := System.OpenInput (ScanTabName);
      Checks.ErrorCheck ("yyGetTables.OpenInput", TableFile);
      IF (yyGetTable (TableFile, SYSTEM.ADR (Base      )) DIV SIZE (yyTableElmt) - 1 # yyDStateCount) OR
         (yyGetTable (TableFile, SYSTEM.ADR (yyDefault )) DIV SIZE (yyTableElmt) - 1 # yyDStateCount) OR
         (yyGetTable (TableFile, SYSTEM.ADR (yyEobTrans)) DIV SIZE (yyTableElmt) - 1 # yyDStateCount)
	 THEN
	 yyErrorMessage (2);
      END;
      n := 0;
      j := 0;
      WHILE j <= yyTableSize DO
         INC (n, yyGetTable (TableFile, SYSTEM.ADR (yyComb [j])) DIV SIZE (yyCombType));
         INC (j, BlockSize);
      END;
      IF n # yyTableSize + 1 THEN yyErrorMessage (2); END;
      System.Close (TableFile);

      FOR i := 0 TO yyDStateCount DO
	 yyBasePtr [i] := (SYSTEM.ADR (yyComb [Base [i]]));
      END;
   END yyGetTables;
 
PROCEDURE yyGetTable (TableFile: System.tFile; Address:LONGINT): LONGINT;
   VAR
      N		: LONGINT;
      Length	: yyTableElmt;
   BEGIN
      N := System.Read (TableFile, SYSTEM.ADR (Length), SIZE (yyTableElmt));
      Checks.ErrorCheck ("yyGetTable.Read1", N);
      N := System.Read (TableFile, Address, Length);
      Checks.ErrorCheck ("yyGetTable.Read2", N);
      RETURN Length;
   END yyGetTable;
 
PROCEDURE yyErrorMessage (ErrorCode:INTEGER);
   BEGIN
      Positions.WritePosition (IO.StdError, Attribute.Position);
      CASE ErrorCode OF
   | 0: IO.WriteS (IO.StdError, ": Scanner: internal error");
   | 1: IO.WriteS (IO.StdError, ": Scanner: out of memory");
   | 2: IO.WriteS (IO.StdError, ": Scanner: table mismatch");
   | 3: IO.WriteS (IO.StdError, ": Scanner: too many nested include files");
   | 4: IO.WriteS (IO.StdError, ": Scanner: file stack underflow (too many calls of CloseFile)");
   | 5: IO.WriteS (IO.StdError, ": Scanner: cannot open input file");
      END;
      IO.WriteNl (IO.StdError); Exit;
   END yyErrorMessage;
 
PROCEDURE yyExit;
   BEGIN
      IO.CloseIO; System.Exit (1);
   END yyExit;

BEGIN
   ScanTabName		:= "Scanner.Tab";
   Exit			:= yyExit;
   yyFileStackPtr	:= 0;
   yyStartState		:= 1;			(* set up for auto init *)
   yyPreviousStart	:= 1;
   yyBasePtr [yyStartState] := (SYSTEM.ADR (yyComb [0]));
   yyDefault [yyStartState] := yyDNoState;
   yyComb [0].Check	:= yyDNoState;
   yyChBufferPtr	:= SYSTEM.VAL(yytChBufferPtr,SYSTEM.ADR (yyComb [0]));	(* dirty trick *)
   yyChBufferIndex	:= 1;				(* dirty trick *)
   yyStateStackSize	:= yyInitBufferSize;
   DynArray.MakeArray (yyStateStack, yyStateStackSize, SIZE (yyStateRange));
   yyStateStack^ [0]	:= yyDNoState;
   
   FOR yyChi := ORD(yyFirstCh) TO ORD(yyLastCh) DO yyToLower [yyChi] := CHR(yyChi); END;
   yyToUpper := yyToLower;
   FOR yyChi := ORD('A') TO ORD('Z') DO
      yyToLower [yyChi] := CHR (yyChi - ORD ('A') + ORD ('a'));
   END;
   FOR yyChi := ORD('a') TO ORD('z') DO
      yyToUpper [yyChi] := CHR (yyChi - ORD ('a') + ORD ('A'));
   END;
END Scanner.

