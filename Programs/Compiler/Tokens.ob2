MODULE Tokens;
IMPORT Errors,Idents,Str;

TYPE  T*                  = Idents.T;
CONST MT*                 = 0 ;
      Eof*                = 1 ; 
      Ident*              = 2 ;
      Integer*            = 3 ; 
      Real*               = 4 ;          
      Longreal*           = 5 ;          
      Char*               = 6 ;          
      String*             = 7 ;          
      Plus*               = 8 ;          
      Hyphen*             = 9 ; (* +  *)  
      Asterisk*           = 10; (* -  *)  
      SlantMark*          = 11; (* *  *)  
      Tilde*              = 12; (* /  *)  
      Ampersand*          = 13; (* ~  *)  
      Period*             = 14; (* &  *)  
      Comma*              = 15; (* .  *)  
      Semicolon*          = 16; (* ,  *)  
      Bar*                = 17; (* ;  *)  
      OpenRoundBracket*   = 18; (* |  *)  
      CloseRoundBracket*  = 19; (* (  *)  
      OpenSquareBracket*  = 20; (* )  *)  
      CloseSquareBracket* = 21; (* [  *)  
      OpenBrace*          = 22; (* ]  *)  
      CloseBrace*         = 23; (* {  *)  
      Assign*             = 24; (* }  *)   
      Caret*              = 25; (* := *)  
      Equal*              = 26; (* ^  *)  
      Unequal*            = 27; (* =  *)  
      Less*               = 28; (* #  *)  
      Greater*            = 29; (* <  *)  
      LessEqual*          = 30; (* >  *)  
      GreaterEqual*       = 31; (* <= *)  
      DotDot*             = 32; (* >= *)  
      Colon*              = 33; (* .. *)  
      Array*              = 34; (* :  *)  
      Begin*              = 35; 
      By*                 = 36; 
      Case*               = 37; 
      Const*              = 38; 
      Div*                = 39; 
      Do*                 = 40; 
      Else*               = 41; 
      Elsif*              = 42; 
      End*                = 43; 
      Exit*               = 44; 
      Foreign*            = 45; 
      For*                = 46; 
      If*                 = 47; 
      Import*             = 48; 
      In*                 = 49; 
      Is*                 = 50; 
      Loop*               = 51; 
      Mod*                = 52; 
      Module*             = 53; 
      Nil*                = 54; 
      Of*                 = 55; 
      Or*                 = 56; 
      Pointer*            = 57; 
      Procedure*          = 58; 
      Record*             = 59; 
      Repeat*             = 60; 
      Return*             = 61; 
      Then*               = 62; 
      To*                 = 63; 
      Type*               = 64; 
      Until*              = 65; 
      Var*                = 66; 
      While*              = 67; 
      With*               = 68; 

      LastConst*          = 68;

(************************************************************************************************************************)
PROCEDURE Repr*(tok:T):Str.T;
BEGIN (* Repr *)
 RETURN Idents.Repr(tok); 
END Repr;

(************************************************************************************************************************)
PROCEDURE E(id:Idents.T; s:ARRAY OF CHAR);
BEGIN (* E *)                           
 IF id#Idents.Make(s) THEN Errors.Fatal('Tokens.Init'); END; (* IF *)
END E;

(************************************************************************************************************************)
BEGIN (* Tokens *)
 E(Eof               ,'<eof>'     ); 
 E(Ident             ,'<ident>'   ); 
 E(Integer           ,'<integer>' ); 
 E(Real              ,'<real>'    );
 E(Longreal          ,'<longreal>'); 
 E(Char              ,'<char>'    );
 E(String            ,'<string>'  );
 E(Plus              ,'+'         );
 E(Hyphen            ,'-'         );
 E(Asterisk          ,'*'         );
 E(SlantMark         ,'/'         );
 E(Tilde             ,'~'         );
 E(Ampersand         ,'&'         );
 E(Period            ,'.'         );
 E(Comma             ,','         );
 E(Semicolon         ,';'         );
 E(Bar               ,'|'         );
 E(OpenRoundBracket  ,'('         );
 E(CloseRoundBracket ,')'         );
 E(OpenSquareBracket ,'['         );
 E(CloseSquareBracket,']'         );
 E(OpenBrace         ,'{'         );
 E(CloseBrace        ,'}'         );
 E(Assign            ,':='        );
 E(Caret             ,'^'         );
 E(Equal             ,'='         );
 E(Unequal           ,'#'         );
 E(Less              ,'<'         );
 E(Greater           ,'>'         );
 E(LessEqual         ,'<='        );
 E(GreaterEqual      ,'>='        );
 E(DotDot            ,'..'        );
 E(Colon             ,':'         );
 E(Array             ,'ARRAY'     );
 E(Begin             ,'BEGIN'     );
 E(By                ,'BY'        );
 E(Case              ,'CASE'      );
 E(Const             ,'CONST'     );
 E(Div               ,'DIV'       );
 E(Do                ,'DO'        );
 E(Else              ,'ELSE'      );
 E(Elsif             ,'ELSIF'     );
 E(End               ,'END'       );
 E(Exit              ,'EXIT'      );
 E(Foreign           ,'FOREIGN'   );
 E(For               ,'FOR'       );
 E(If                ,'IF'        );
 E(Import            ,'IMPORT'    );
 E(In                ,'IN'        );
 E(Is                ,'IS'        );
 E(Loop              ,'LOOP'      );
 E(Mod               ,'MOD'       );
 E(Module            ,'MODULE'    );
 E(Nil               ,'NIL'       );
 E(Of                ,'OF'        );
 E(Or                ,'OR'        );
 E(Pointer           ,'POINTER'   );
 E(Procedure         ,'PROCEDURE' ); 
 E(Record            ,'RECORD'    );
 E(Repeat            ,'REPEAT'    );
 E(Return            ,'RETURN'    );
 E(Then              ,'THEN'      );
 E(To                ,'TO'        );
 E(Type              ,'TYPE'      );
 E(Until             ,'UNTIL'     );
 E(Var               ,'VAR'       );
 E(While             ,'WHILE'     );
 E(With              ,'WITH'      );
END Tokens.
