/********************************************************************************************************************************/
/*** oberon.rex / Scanner specification                                                                                       ***/
/********************************************************************************************************************************/
EXPORT{  IMPORT OT                      ,
                POS                     ,
                Idents                  ;

         CONST  TokenNameMaxLength      = 10;

                IdentToken              = 1 ;         CaretToken        = 24; (* ^        *)  ImportToken    = 47; (* IMPORT    *)
                IntegerToken            = 2 ;         EqualToken        = 25; (* =        *)  InToken        = 48; (* IN        *)
                RealToken               = 3 ;         UnequalToken      = 26; (* #        *)  IsToken        = 49; (* IS        *)
                LongrealToken           = 4 ;         LessToken         = 27; (* <        *)  LoopToken      = 50; (* LOOP      *)
                CharToken               = 5 ;         GreaterToken      = 28; (* >        *)  ModToken       = 51; (* MOD       *)
                StringToken             = 6 ;         LessEqualToken    = 29; (* <=       *)  ModuleToken    = 52; (* MODULE    *)
                PlusToken               = 7 ; (* + *) GreaterEqualToken = 30; (* >=       *)  NilToken       = 53; (* NIL       *)
                HyphenToken             = 8 ; (* - *) DotDotToken       = 31; (* ..       *)  OfToken        = 54; (* OF        *)
                AsteriskToken           = 9 ; (* * *) ColonToken        = 32; (* :        *)  OrToken        = 55; (* OR        *)
                SlantMarkToken          = 10; (* / *) ArrayToken        = 33; (* ARRAY    *)  PointerToken   = 56; (* POINTER   *)
                TildeToken              = 11; (* ~ *) BeginToken        = 34; (* BEGIN    *)  ProcedureToken = 57; (* PROCEDURE *)
                AmpersandToken          = 12; (* & *) ByToken           = 35; (* BY       *)  RecordToken    = 58; (* RECORD    *)
                PeriodToken             = 13; (* . *) CaseToken         = 36; (* CASE     *)  RepeatToken    = 59; (* REPEAT    *)
                CommaToken              = 14; (* , *) ConstToken        = 37; (* CONST    *)  ReturnToken    = 60; (* RETURN    *)
                SemicolonToken          = 15; (* ; *) DivToken          = 38; (* DIV      *)  ThenToken      = 61; (* THEN      *)
                BarToken                = 16; (* | *) DoToken           = 39; (* DO       *)  ToToken        = 62; (* TO        *)
                OpenRoundBracketToken   = 17; (* ( *) ElseToken         = 40; (* ELSE     *)  TypeToken      = 63; (* TYPE      *)
                CloseRoundBracketToken  = 18; (* ) *) ElsifToken        = 41; (* ELSIF    *)  UntilToken     = 64; (* UNTIL     *)
                OpenSquareBracketToken  = 19; (* [ *) EndToken          = 42; (* END      *)  VarToken       = 65; (* VAR       *)
                CloseSquareBracketToken = 20; (* ] *) ExitToken         = 43; (* EXIT     *)  WhileToken     = 66; (* WHILE     *)
                OpenBraceToken          = 21; (* { *) ExternalToken     = 44; (* EXTERNAL *)  WithToken      = 67; (* WITH      *)
                CloseBraceToken         = 22; (* } *) ForToken          = 45; (* FOR      *)   
                AssignToken             = 23; (* :=*) IfToken           = 46; (* IF       *) 

         TYPE   tPosition               = POS.tPosition;
                tScanAttribute          = RECORD
                                           Position     : POS.tPosition;
                                           CASE         : CARDINAL OF
                                           |1: Ident    : Idents.tIdent;
                                           |2: Integer  : OT.oLONGINT  ;
                                           |3: Real     : OT.oREAL     ;
                                           |4: Longreal : OT.oLONGREAL ;
                                           |5: Char     : OT.oCHAR     ;
                                           |6: String   : OT.oSTRING   ;
                                           END;
                                          END;

         PROCEDURE ErrorAttribute     (     Token     : CARDINAL       ;
                                        VAR Attribute : tScanAttribute );
         PROCEDURE TokenNum2TokenName (     TokenNum  : INTEGER        ;
                                        VAR TokenName : ARRAY OF CHAR  );
         PROCEDURE ReadAll():INTEGER; }
         
GLOBAL{  IMPORT ERR          , 
                Idents       ,
                O            ,
                OT           ,
                POS          ,
                Strings1     ,
                UTI          ;

         CONST  NoInteger    = 0               ;                        (* used for ErrorAttribute                              *)
                TAB          = 11C             ;                        (* used for tab characters in string constants          *)
         VAR    String       : Strings.tString ;                        (* temporary for the init section                       *)
                NoIdent      : Idents.tIdent   ;                        (* used for ErrorAttribute, initialized in init section *)
                NestingLevel : CARDINAL        ;                        (* counts comment nesting                               *)
                ErrIdent     : Strings.tString ;                        (* contains "<?ident>"                                  *)

         PROCEDURE ErrorAttribute(Token : CARDINAL; VAR Attribute : tScanAttribute);
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

         PROCEDURE TokenNum2TokenName(TokenNum : INTEGER; VAR TokenName : ARRAY OF CHAR);
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
          |ExternalToken          : Strings1.Assign(TokenName,'EXTERNAL'  );
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
         
         PROCEDURE ReadAll():INTEGER;
         VAR n,size:INTEGER;
         BEGIN (* ReadAll *)
          n:=0; size:=General.Exp2(General.Log2(yyChBufferSize)); 
          LOOP
           yyBytesRead:=Source.GetLine(yySourceFile,yyChBufferPtr,size);
           IF yyBytesRead=0 THEN EXIT; END;
           INC(n,yyBytesRead);
          END; (* LOOP *)              
          CloseFile;
          RETURN n; 
         END ReadAll; }


LOCAL{   VAR Repr, Str1, Str2 : Strings.tString;
             OK               : BOOLEAN; }

BEGIN{   Strings.AssignEmpty(String);
         NoIdent      := Idents.MakeIdent(String);
         NestingLevel := 0; 
         Strings.ArrayToString("<?ident>",ErrIdent); }

DEFAULT{ ERR.MsgPos(ERR.MsgIllegalCharInSource,Attribute.Position); }

EOF{     IF yyStartState=Comment
            THEN ERR.MsgPos(ERR.MsgCommentNotClosed,Attribute.Position);
         END;
         IF (yyStartState=StrSQ) OR (yyStartState=StrDQ)
            THEN ERR.MsgPos(ERR.MsgStringNotTerminated,Attribute.Position);
         END;
         yyStart(STD);
         NestingLevel := 0; }

/********************************************************************************************************************************/
DEFINE

   Digit        =  { 0-9       }.
   HexDigit     =  { 0-9 A-F   }.
   Letter       =  { a-z A-Z _ }.
   CommentChar  = -{ * ( \t \n }.

/********************************************************************************************************************************/
START

   Comment, StrSQ, StrDQ

/********************************************************************************************************************************/
RULES

/*--- Comments -----------------------------------------------------------------------------------------------------------------*/

#STD, Comment# "(*" :-{                                                                                            (* !Comments *)
  INC(NestingLevel);
  yyStart(Comment);
}

#Comment# "*)" :-{
   DEC(NestingLevel);
   IF NestingLevel=0
      THEN yyStart(STD);
   END;
}

#Comment# "(" | "*" | CommentChar + :-{
}

/*--- Integer ------------------------------------------------------------------------------------------------------------------*/

#STD# Digit+        ,
#STD# Digit+ / ".." :{                                                                                             (* !Integers *)
   GetWord(Repr);
   OT.LONGCARD2oLONGINT(UTI.Str2Longcard(Repr,OK),Attribute.Integer);
   IF ~OK THEN ERR.MsgPos(ERR.MsgIllegalIntegerConst,Attribute.Position); END;
   RETURN IntegerToken;
}

#STD# Digit HexDigit* "H" :{
   GetWord(Repr);
   OT.LONGCARD2oLONGINT(UTI.HexStr2Longcard(Repr,OK),Attribute.Integer);
   IF ~OK THEN ERR.MsgPos(ERR.MsgIllegalIntegerConst,Attribute.Position); END;
   RETURN IntegerToken;
}

/*--- Reals --------------------------------------------------------------------------------------------------------------------*/

#STD# Digit+ "." Digit* ( E { + \- }? Digit+ )? :{                                                                    (* !Reals *)
   GetWord(Repr);
   OT.STR2oREAL(Repr,Attribute.Real,OK);
   IF ~OK THEN ERR.MsgPos(ERR.MsgIllegalRealConst,Attribute.Position); END;
   RETURN RealToken;
}

#STD# Digit+ "." Digit* ( D { + \- }? Digit+ )? :{
   GetWord(Repr);
   OT.STR2oLONGREAL(Repr,Attribute.Longreal,OK);
   IF ~OK THEN ERR.MsgPos(ERR.MsgIllegalLongrealConst,Attribute.Position); END;
   RETURN LongrealToken;
}

/*--- Chars --------------------------------------------------------------------------------------------------------------------*/

#STD# Digit HexDigit* "X" :{                                                                                          (* !Chars *)
   GetWord(Repr);
   OT.HEXSTR2oCHAR(Repr,Attribute.Char,OK);
   IF ~OK THEN ERR.MsgPos(ERR.MsgIllegalCharConst,Attribute.Position); END;
   RETURN CharToken;
}

/*--- Strings ------------------------------------------------------------------------------------------------------------------*/

#STD# ' :{                                                                                                          (* !Strings *)
   Strings.AssignEmpty(Str1); yyStart(StrSQ);
}

#StrSQ# (-{ ' \t \n })+ :-{
   GetWord(Str2); Strings.Concatenate(Str1,Str2);
}

#StrSQ# ' :-{
   yyStart(STD);
   CASE Strings.Length(Str1) OF
   |0 : Attribute.String := OT.NoString;                    RETURN StringToken;
   |1 : OT.CHAR2oCHAR(Strings.Char(Str1,1),Attribute.Char); RETURN CharToken;                              (* !CharEqualString1 *)
   ELSE OT.STR2oSTRING(Str1,Attribute.String);              RETURN StringToken;
   END; (* CASE *)
}

#STD# \" :{                                                                                                         (* !Strings *)
   Strings.AssignEmpty(Str1); yyStart(StrDQ);
}

#StrDQ# (-{ \" \t \n })+ :-{
   GetWord(Str2); Strings.Concatenate(Str1,Str2);
}

#StrDQ# \" :-{
   yyStart(STD);
   CASE Strings.Length(Str1) OF
   |0 : Attribute.String := OT.NoString;                    RETURN StringToken;
   |1 : OT.CHAR2oCHAR(Strings.Char(Str1,1),Attribute.Char); RETURN CharToken;                              (* !CharEqualString1 *)
   ELSE OT.STR2oSTRING(Str1,Attribute.String);              RETURN StringToken;
   END; (* CASE *)
}

#StrSQ, StrDQ# \t :-{
   Strings.Append(Str1,TAB); yyTab;
}

#StrSQ, StrDQ# \n :-{                                                                                     (* !NoNewlineInString *)
   ERR.MsgPos(ERR.MsgStringNotTerminated,Attribute.Position);
   yyEol(0); yyStart(STD);
   OT.STR2oSTRING(Str1,Attribute.String);
   RETURN StringToken;
}

/*--- Specials -----------------------------------------------------------------------------------------------------------------*/

#STD# "+"         : { RETURN PlusToken              ; }                                                           /* !Operators */
#STD# "-"         : { RETURN HyphenToken            ; }
#STD# "*"         : { RETURN AsteriskToken          ; }
#STD# "/"         : { RETURN SlantMarkToken         ; }
#STD# "~"         : { RETURN TildeToken             ; }
#STD# "&"         : { RETURN AmpersandToken         ; }
#STD# "."         : { RETURN PeriodToken            ; }
#STD# ","         : { RETURN CommaToken             ; }
#STD# ";"         : { RETURN SemicolonToken         ; }
#STD# "|"         : { RETURN BarToken               ; }
#STD# "("         : { RETURN OpenRoundBracketToken  ; }
#STD# ")"         : { RETURN CloseRoundBracketToken ; }
#STD# "["         : { RETURN OpenSquareBracketToken ; }
#STD# "]"         : { RETURN CloseSquareBracketToken; }
#STD# "{"         : { RETURN OpenBraceToken         ; }
#STD# "}"         : { RETURN CloseBraceToken        ; }
#STD# ":="        : { RETURN AssignToken            ; }
#STD# "^"         : { RETURN CaretToken             ; }
#STD# "="         : { RETURN EqualToken             ; }
#STD# "#"         : { RETURN UnequalToken           ; }
#STD# "<"         : { RETURN LessToken              ; }
#STD# ">"         : { RETURN GreaterToken           ; }
#STD# "<="        : { RETURN LessEqualToken         ; }
#STD# ">="        : { RETURN GreaterEqualToken      ; }
#STD# ".."        : { RETURN DotDotToken            ; }
#STD# ":"         : { RETURN ColonToken             ; }

/*--- Reserved Words -----------------------------------------------------------------------------------------------------------*/

#STD# "ARRAY"     : { RETURN ArrayToken             ; }                                                       /* !ReservedWords */
#STD# "BEGIN"     : { RETURN BeginToken             ; }
#STD# "BY"        : { RETURN ByToken                ; }
#STD# "CASE"      : { RETURN CaseToken              ; }
#STD# "CONST"     : { RETURN ConstToken             ; }
#STD# "DIV"       : { RETURN DivToken               ; }
#STD# "DO"        : { RETURN DoToken                ; }
#STD# "ELSE"      : { RETURN ElseToken              ; }
#STD# "ELSIF"     : { RETURN ElsifToken             ; }
#STD# "END"       : { RETURN EndToken               ; }
#STD# "EXIT"      : { RETURN ExitToken              ; }
#STD# "FOR"       : { RETURN ForToken               ; }
#STD# "EXTERNAL"  : { RETURN ExternalToken          ; }
#STD# "IF"        : { RETURN IfToken                ; }
#STD# "IMPORT"    : { RETURN ImportToken            ; }
#STD# "IN"        : { RETURN InToken                ; }
#STD# "IS"        : { RETURN IsToken                ; }
#STD# "LOOP"      : { RETURN LoopToken              ; }
#STD# "MOD"       : { RETURN ModToken               ; }
#STD# "MODULE"    : { RETURN ModuleToken            ; }
#STD# "NIL"       : { RETURN NilToken               ; }
#STD# "OF"        : { RETURN OfToken                ; }
#STD# "OR"        : { RETURN OrToken                ; }
#STD# "POINTER"   : { RETURN PointerToken           ; }
#STD# "PROCEDURE" : { RETURN ProcedureToken         ; }
#STD# "RECORD"    : { RETURN RecordToken            ; }
#STD# "REPEAT"    : { RETURN RepeatToken            ; }
#STD# "RETURN"    : { RETURN ReturnToken            ; }
#STD# "THEN"      : { RETURN ThenToken              ; }
#STD# "TO"        : { RETURN ToToken                ; }
#STD# "TYPE"      : { RETURN TypeToken              ; }
#STD# "UNTIL"     : { RETURN UntilToken             ; }
#STD# "VAR"       : { RETURN VarToken               ; }
#STD# "WHILE"     : { RETURN WhileToken             ; }
#STD# "WITH"      : { RETURN WithToken              ; }

/*--- Identifiers --------------------------------------------------------------------------------------------------------------*/

#STD# Letter ( Letter | Digit )* :{                                                                             (* !Identifiers *)
   IF TokenLength>255
      THEN ERR.MsgPos(ERR.MsgIdentifierTooLong,Attribute.Position);
           Strings.Assign(Repr,ErrIdent);
      ELSE GetWord(Repr);
   END;
   Attribute.Ident:=Idents.MakeIdent(Repr);
   RETURN IdentToken;
}

/*--- Illegal characters -------------------------------------------------------------------------------------------------------*/
#STD# { \0-\8 \11-\31 ! $ % \? @ \\ ` \128-\255 } :{
   ERR.MsgPos(ERR.MsgIllegalCharInSource,Attribute.Position);
}

/********************************************************************************************************************************/
/*** END oberon.rex                                                                                                           ***/
/********************************************************************************************************************************/
