MODULE Errors;
IMPORT O:=Out, POS:=Positions;

TYPE  tMsg*                = LONGINT;
CONST mtMsg*               = 0;
      CommentNotClosed*    = 1;
      StringNotTerminated* = 2;
      NumberTooLong*       = 3;
      MsgIllegalCharConst* = 4;
      MsgInvalidConstant*  = 5;

PROCEDURE Msg2Str(msg:tMsg; VAR s:ARRAY OF CHAR);
BEGIN (* Msg2Str *)			       
 CASE msg OF
 |mtMsg              : COPY(''                          ,s); 
 |CommentNotClosed   : COPY('Comment not closed'        ,s); 
 |StringNotTerminated: COPY('String not terminated'     ,s); 
 |NumberTooLong      : COPY('Number too long'           ,s); 
 |MsgIllegalCharConst: COPY('Illegal character constant',s); 
 |MsgInvalidConstant : COPY('Invalid constant'          ,s); 
 ELSE                  COPY('ErrorMsg?'                 ,s); 
 END; (* CASE *)
END Msg2Str;

PROCEDURE MsgPos*(msg:tMsg; p:POS.T);
VAR s:ARRAY 100 OF CHAR; 
BEGIN (* MsgPos *)			   
 Msg2Str(msg,s); 

 O.Int(p.line);
 O.Str(',');  
 O.Int(p.column); 
 O.Str(': ');  
 O.Str(s);  
 O.Ln;
END MsgPos;

PROCEDURE Fatal*(s:ARRAY OF CHAR);
BEGIN (* Fatal *)              
 O.Str('Fatal error: '); 
 O.StrLn(s); 
 HALT(1); 
END Fatal;

END Errors.
