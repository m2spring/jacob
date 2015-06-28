MODULE Scanner;
IMPORT ERR:=Errors, Idents, Tokens, F:=FIO, POS:=Positions, O:=Out, Str;

CONST TabWidth     = 8;
      MaxNumberLen = 100;
      BufferSize   = 4*1024;
TYPE  tBuffer      = ARRAY BufferSize OF CHAR;
      tStatus      = POINTER TO tStatusDesc;
      tStatusDesc  = RECORD
                      prev      : tStatus;
                      f         : F.File;
                      buf       : tBuffer;
                      nextIdx   , 
                      nofBytes  : LONGINT; 
                      actCh     , 
                      nxtCh     : CHAR; 	   
                      pos       : POS.T;
		   	         
                      Pos-      : POS.T;
                      Token-    : Tokens.T;
                      Ident-    : Idents.T;
                      Integer-  : LONGINT; 
                      Real-     : REAL;
                      Longreal- : LONGREAL;
                      Char-     : CHAR; 
                      String-   : Idents.T;
                     END;
VAR   Act-         : tStatusDesc;
      nesting,dst  : LONGINT; 
      number       : ARRAY MaxNumberLen+1 OF CHAR; 

(************************************************************************************************************************)
PROCEDURE ReadNext;
BEGIN (* ReadNext *)
 IF    Act.actCh=0AX THEN INC(Act.pos.line); Act.pos.column:=1; 
 ELSIF Act.actCh=9X  THEN INC(Act.pos.column,TabWidth-((Act.pos.column-1) MOD TabWidth));
                     ELSE INC(Act.pos.column); 
 END; (* IF *)
 Act.actCh:=Act.nxtCh; 
 
 IF Act.nextIdx>=Act.nofBytes THEN 
    Act.nofBytes:=F.RdBin(Act.f,Act.buf,LEN(Act.buf)); 
    IF Act.nofBytes<=0 THEN Act.nxtCh:=0X; RETURN; END; (* IF *)
 END; (* IF *)
 
 Act.nxtCh:=Act.buf[Act.nextIdx]; INC(Act.nextIdx); 
END ReadNext;

(************************************************************************************************************************)
PROCEDURE Open*(fn:ARRAY OF CHAR):BOOLEAN; 
VAR f:F.File; stat:tStatus;
BEGIN (* Open *)
 IF ~F.Exists(fn) THEN RETURN FALSE; END; (* IF *)
 f:=F.Open(fn); 
 IF F.IOresult()#0 THEN RETURN FALSE; END; (* IF *)
 
 IF Act.f#-1 THEN NEW(stat); stat^:=Act; Act.prev:=stat; END; (* IF *)
 
 Act.f:=f; Act.nextIdx:=0; Act.nofBytes:=0; 
 Act.pos.line:=1; Act.pos.column:=-1; Act.actCh:=' '; Act.nxtCh:=' '; 

 Act.Pos   := POS.MT; 
 Act.Token := Tokens.MT; 
 Act.Ident := Idents.MT; 

 ReadNext; ReadNext;
 RETURN TRUE; 
END Open;

(************************************************************************************************************************)
PROCEDURE Close*;
BEGIN (* Close *)		     
 IF Act.f#-1 THEN F.Close(Act.f); END; (* IF *)
 IF Act.prev=NIL THEN 
    Act.f:=-1; 
 ELSE
    Act:=Act.prev^; 
 END; (* IF *)
END Close;

(************************************************************************************************************************)
PROCEDURE DezInt;
VAR i:LONGINT; 
BEGIN (* DezInt *)
 IF dst>=MaxNumberLen THEN ERR.MsgPos(ERR.NumberTooLong,Act.Pos);  END; (* IF *)
 Act.Integer:=0; 
 FOR i:=0 TO dst-1 DO
  Act.Integer:=10*Act.Integer+ORD(number[i])-48; 
 END; (* FOR *)				       
 Act.Token:=Tokens.Integer; 
END DezInt;

(************************************************************************************************************************)
PROCEDURE HexInt(); 
VAR i,v:LONGINT; 
BEGIN (* HexInt *)
 IF dst>=MaxNumberLen THEN ERR.MsgPos(ERR.NumberTooLong,Act.Pos); END; (* IF *)
 Act.Integer:=0; 
 FOR i:=0 TO dst-1 DO
  v:=ORD(number[i])-48; 
  IF v>9 THEN DEC(v,7); END; (* IF *)
  Act.Integer:=16*Act.Integer+v; 
 END; (* FOR *)				       
 Act.Token:=Tokens.Integer; 
END HexInt;

(************************************************************************************************************************)
PROCEDURE Real;
VAR isLong,ok:BOOLEAN; 

(*----------------------------------------------------------------------------*)
 PROCEDURE ScaleFactor;
 BEGIN (* ScaleFactor *)
  IF dst<MaxNumberLen THEN number[dst]:=Act.actCh; INC(dst); END; (* IF *)
  ReadNext;
  
  CASE Act.actCh OF
  |'-','0'..'9': IF dst<MaxNumberLen THEN number[dst]:=Act.actCh; INC(dst); END; (* IF *)
  |'+'         : ;
  ELSE           RETURN;
  END; (* CASE *)
  ReadNext; 
  
  LOOP
   CASE Act.actCh OF
   |'0'..'9': IF dst<MaxNumberLen THEN number[dst]:=Act.actCh; INC(dst); END; (* IF *)
   ELSE       EXIT; 
   END; (* CASE *)
   ReadNext; 
  END; (* LOOP *)
 END ScaleFactor;

(*----------------------------------------------------------------------------*)
BEGIN (* Real *)
 (* ! Act.actCh='.' *)
 IF dst<MaxNumberLen THEN number[dst]:=Act.actCh; INC(dst); END; (* IF *)

 LOOP
  ReadNext;
  CASE Act.actCh OF
  |'0'..'9': IF dst<MaxNumberLen THEN number[dst]:=Act.actCh; INC(dst); END; (* IF *)
  |'E'     : isLong:=FALSE; ScaleFactor; EXIT; 
  |'D'     : isLong:=TRUE ; ScaleFactor; EXIT; 
  ELSE       EXIT; 
  END; (* CASE *)
 END; (* LOOP *)
 
 IF dst>=MaxNumberLen THEN ERR.MsgPos(ERR.NumberTooLong,Act.Pos); END; (* IF *)

 number[dst]:=0X; 
 IF isLong THEN 
    Act.Longreal:=Str.StrToReal(number,ok); Act.Token:=Tokens.Longreal; 
 ELSE 
    Act.Real:=SHORT(Str.StrToReal(number,ok)); Act.Token:=Tokens.Real; 
 END; (* IF *)
 IF ~ok THEN ERR.MsgPos(ERR.MsgInvalidConstant,Act.Pos); END; (* IF *)
END Real;

(************************************************************************************************************************)
PROCEDURE GetToken*;
BEGIN (* GetToken *)
 Act.Pos:=Act.pos; 
 LOOP
  CASE Act.actCh OF
  |1X..' ': REPEAT ReadNext; UNTIL (Act.actCh>' ') OR (Act.actCh=0X);
            Act.Pos:=Act.pos; 
	    
  |0X :                       Act.Token:=Tokens.Eof               ; RETURN;
  |'+':                       Act.Token:=Tokens.Plus              ; EXIT;
  |'-':                       Act.Token:=Tokens.Hyphen            ; EXIT;
  |'*':                       Act.Token:=Tokens.Asterisk          ; EXIT;
  |'/':                       Act.Token:=Tokens.SlantMark         ; EXIT;
  |'~':                       Act.Token:=Tokens.Tilde             ; EXIT;
  |'&':                       Act.Token:=Tokens.Ampersand         ; EXIT;
  |',':                       Act.Token:=Tokens.Comma             ; EXIT;
  |';':                       Act.Token:=Tokens.Semicolon         ; EXIT;
  |'|':                       Act.Token:=Tokens.Bar               ; EXIT;
  |')':                       Act.Token:=Tokens.CloseRoundBracket ; EXIT;
  |'[':                       Act.Token:=Tokens.OpenSquareBracket ; EXIT;
  |']':                       Act.Token:=Tokens.CloseSquareBracket; EXIT;
  |'{':                       Act.Token:=Tokens.OpenBrace         ; EXIT;
  |'}':                       Act.Token:=Tokens.CloseBrace        ; EXIT;
  |'^':                       Act.Token:=Tokens.Caret             ; EXIT;
  |'=':                       Act.Token:=Tokens.Equal             ; EXIT;
  |'#':                       Act.Token:=Tokens.Unequal           ; EXIT;
  |':': ReadNext;
        IF Act.actCh='=' THEN Act.Token:=Tokens.Assign            ; EXIT; 
                         ELSE Act.Token:=Tokens.Colon             ; RETURN;
        END;
  |'.': ReadNext;
        IF Act.actCh='.' THEN Act.Token:=Tokens.DotDot            ; EXIT; 
                         ELSE Act.Token:=Tokens.Period            ; RETURN;
        END;
  |'<': ReadNext;
        IF Act.actCh='=' THEN Act.Token:=Tokens.LessEqual         ; EXIT; 
                         ELSE Act.Token:=Tokens.Less              ; RETURN;
        END;
  |'>': ReadNext;
        IF Act.actCh='=' THEN Act.Token:=Tokens.GreaterEqual      ; EXIT; 
                         ELSE Act.Token:=Tokens.Greater           ; RETURN;
        END;
  |'(': ReadNext;
        IF Act.actCh#'*' THEN Act.Token:=Tokens.OpenRoundBracket  ; RETURN; END;
        ReadNext; nesting:=1; 
	LOOP
         CASE Act.actCh OF
         |0X : ERR.MsgPos(ERR.CommentNotClosed,Act.Pos); 
               Act.Token:=Tokens.Eof; RETURN;
         |'*': ReadNext;
               IF Act.actCh=')' THEN 
                  ReadNext; DEC(nesting); 
                  IF nesting=0 THEN EXIT; END; (* IF *)
               END; (* IF *)
         |'(': ReadNext;
               IF Act.actCh='*' THEN ReadNext; INC(nesting); END; (* IF *)
	 ELSE  ReadNext;
         END; (* CASE *)
        END; (* LOOP *)
	Act.Pos:=Act.pos; 

  |'A'..'Z','a'..'z','_':
        LOOP
         Idents.App(Act.actCh); 
         ReadNext;
         CASE Act.actCh OF
         |'A'..'Z','a'..'z','_','0'..'9':
         ELSE EXIT; 
         END; (* CASE *)
        END; (* LOOP *)
        Act.Ident:=Idents.Enter(); 
        IF Act.Ident>Tokens.LastConst THEN 
           Act.Token:=Tokens.Ident; 
        ELSE 
	   Act.Token:=Act.Ident; 
        END; (* IF *)
	RETURN;

  |'0'..'9':
        number[0]:=Act.actCh; dst:=1; 
        LOOP
         ReadNext;
         CASE Act.actCh OF
         |'0'..'9': IF dst<MaxNumberLen THEN number[dst]:=Act.actCh; INC(dst); END; (* IF *)
         |'.'     : IF Act.nxtCh='.' THEN DezInt; ELSE Real; END; (* IF *)
                    RETURN;
         |'A'..'F': LOOP
                     IF dst<MaxNumberLen THEN number[dst]:=Act.actCh; INC(dst); END; (* IF *)
                     ReadNext;
                     CASE Act.actCh OF
                     |'0'..'9','A'..'F': ;
                     |'X'              : ReadNext; HexInt; 
                                         IF Act.Integer>ORD(MAX(CHAR)) THEN ERR.MsgPos(ERR.MsgIllegalCharConst,Act.Pos); END; (* IF *)
                                         Act.Char:=CHR(Act.Integer MOD (1+ORD(MAX(CHAR)))); 
                                         Act.Token:=Tokens.Char; 
                                         RETURN;
                     |'H'              : ReadNext; HexInt;
                                         Act.Token:=Tokens.Integer; 
                                         RETURN;
                     ELSE                ERR.MsgPos(ERR.MsgInvalidConstant,Act.Pos); 
                                         HexInt; Act.Token:=Tokens.Integer; 
                                         RETURN;
                     END; (* CASE *)
                    END; (* LOOP *)
         |'X'     : ReadNext; HexInt; 
                    IF Act.Integer>ORD(MAX(CHAR)) THEN ERR.MsgPos(ERR.MsgIllegalCharConst,Act.Pos); END; (* IF *)
                    Act.Char:=CHR(Act.Integer MOD (1+ORD(MAX(CHAR)))); 
                    Act.Token:=Tokens.Char; 
                    RETURN;
         |'H'     : ReadNext; HexInt;
                    Act.Token:=Tokens.Integer; 
                    RETURN;
         ELSE       DezInt; 
		    RETURN;
         END; (* CASE *)
        END; (* LOOP *)

  ELSE  ReadNext;
  END; (* CASE *)
 END; (* LOOP *)
 
 ReadNext;
END GetToken;

(************************************************************************************************************************)
BEGIN (* Scanner *)
 Act.f:=-1; 
END Scanner.
