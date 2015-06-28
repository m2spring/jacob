MODULE Errors;

IMPORT ERR, Idents, IO, POS, Sets, Strings, SYSTEM;

CONST  (* error codes *)
       NoText*               = 0  ;
       SyntaxError*          = 1  ;
       ExpectedTokens*       = 2  ;
       RestartPoint*         = 3  ;
       TokenInserted*        = 4  ;
       WrongParseTable*      = 5  ;
       OpenParseTable*       = 6  ;
       ReadParseTable*       = 7  ;

       (* error classes *)
       NoError*              = 0  ;
       Fatal*                = 1  ;
       Restriction*          = 2  ;
       Error*                = 3  ;
       Warning*              = 4  ;
       Repair*               = 5  ;
       Note*                 = 6  ;
       Information*          = 7  ;

       (* info classes *)
       None*                 = 0  ;
       Integer*              = 1  ;
       Short*                = 2  ;
       Long*                 = 3  ;
       Real*                 = 4  ;
       Boolean*              = 5  ;
       Character*            = 6  ;
       String*               = 7  ;
       Array*                = 8  ;
       Set*                  = 9  ;
       Ident*                = 10 ;

VAR    UseGeneratedCode*     : BOOLEAN;

PROCEDURE^WriteErrorMessage(ErrorCode  ,
                            ErrorClass :LONGINT; 
                            Position   : POS.tPosition);
PROCEDURE^WriteInfo(InfoClass :LONGINT; Info : SYSTEM.PTR);
                            
(*---------------------------------------------------------------------------*)
PROCEDURE ErrorMessageI*(ErrorCode  ,
                        ErrorClass :LONGINT; 
                        Position   : POS.tPosition;
                        InfoClass  :LONGINT; 
                        Info       : SYSTEM.PTR);
BEGIN (* ErrorMessageI *)
 IF UseGeneratedCode OR (ErrorClass=Fatal)
    THEN WriteErrorMessage(ErrorCode,ErrorClass,Position);
         WriteInfo(InfoClass,Info);
         IO.WriteNl(IO.StdError);
         IF ErrorClass=Fatal THEN IO.CloseIO; HALT(0); END;
    ELSE ERR.MsgI(ErrorCode,ErrorClass,Position,InfoClass,Info);
 END; (* IF *)
END ErrorMessageI;

(*---------------------------------------------------------------------------*)
PROCEDURE ErrorMessage*(ErrorCode  ,
                       ErrorClass :LONGINT; 
                       Position   : POS.tPosition);
BEGIN (* ErrorMessage *)
 ErrorMessageI(ErrorCode,ErrorClass,Position,None,SYSTEM.VAL(SYSTEM.PTR,NIL));
END ErrorMessage;

(*---------------------------------------------------------------------------*)
PROCEDURE WriteErrorMessage(ErrorCode  ,
                            ErrorClass :LONGINT; 
                            Position   : POS.tPosition);
BEGIN (* WriteErrorMessage *)
 IO.WriteI(IO.StdError,Position.Line,3);
 IO.WriteS(IO.StdError,",");
 IO.WriteI(IO.StdError,Position.Column,2);
 IO.WriteS(IO.StdError,": ");

 CASE ErrorClass OF
 |Fatal      : IO.WriteS(IO.StdError,"Fatal        ");
 |Restriction: IO.WriteS(IO.StdError,"Restriction  ");
 |Error      : IO.WriteS(IO.StdError,"Error        ");
 |Warning    : IO.WriteS(IO.StdError,"Warning      ");
 |Repair     : IO.WriteS(IO.StdError,"Repair       ");
 |Note       : IO.WriteS(IO.StdError,"Note         ");
 |Information: IO.WriteS(IO.StdError,"Information  ");
 ELSE          IO.WriteS(IO.StdError,"Error class: ");
               IO.WriteI(IO.StdError,ErrorClass,0   );
 END; (* CASE *)

 CASE ErrorCode OF
 |NoText         :
 |SyntaxError    : IO.WriteS(IO.StdError,"syntax error"           );
 |ExpectedTokens : IO.WriteS(IO.StdError,"expected tokens"        );
 |RestartPoint   : IO.WriteS(IO.StdError,"restart point"          );
 |TokenInserted  : IO.WriteS(IO.StdError,"token inserted "        );
 |WrongParseTable: IO.WriteS(IO.StdError,"parse table mismatch"   );
 |OpenParseTable : IO.WriteS(IO.StdError,"cannot open parse table");
 |ReadParseTable : IO.WriteS(IO.StdError,"cannot read parse table");
 ELSE              IO.WriteS(IO.StdError," error code: "          );
                   IO.WriteI(IO.StdError,ErrorCode,0              );
 END; (* CASE *)
END WriteErrorMessage;

(*---------------------------------------------------------------------------*)
PROCEDURE WriteInfo(InfoClass :LONGINT; Info : SYSTEM.PTR);
TYPE 
   tPtrToInteger   = POINTER TO ARRAY 1 OF INTEGER;
   tPtrToShort     = POINTER TO ARRAY 1 OF SHORTINT;
   tPtrToLong      = POINTER TO ARRAY 1 OF LONGINT;
   tPtrToReal      = POINTER TO ARRAY 1 OF REAL;
   tPtrToBoolean   = POINTER TO ARRAY 1 OF BOOLEAN;
   tPtrToCharacter = POINTER TO ARRAY 1 OF CHAR;
   tPtrToString    = POINTER TO ARRAY 1 OF Strings.tString;
   tPtrToArray     = POINTER TO ARRAY 1024 OF CHAR;
   tPtrToIdent     = POINTER TO ARRAY 1 OF Idents.tIdent;
VAR
   PtrToInteger   : tPtrToInteger  ;
   PtrToShort     : tPtrToShort    ;
   PtrToLong      : tPtrToLong     ;
   PtrToReal      : tPtrToReal     ;
   PtrToBoolean   : tPtrToBoolean  ;
   PtrToCharacter : tPtrToCharacter;
   PtrToString    : tPtrToString   ;
   PtrToArray     : tPtrToArray    ;
   PtrToIdent     : tPtrToIdent    ;
BEGIN (* WriteInfo *)
 IF InfoClass=None THEN RETURN END; (* IF *)

 IO.WriteS(IO.StdError, ": ");
 CASE InfoClass OF
 |Integer  : PtrToInteger   := SYSTEM.VAL(tPtrToInteger  ,Info); IO.WriteI        (IO.StdError,PtrToInteger[0],0);
 |Short    : PtrToShort     := SYSTEM.VAL(tPtrToShort    ,Info); IO.WriteI        (IO.StdError,PtrToShort[0],0);
 |Long     : PtrToLong      := SYSTEM.VAL(tPtrToLong     ,Info); IO.WriteLong     (IO.StdError,PtrToLong[0],0);
 |Real     : PtrToReal      := SYSTEM.VAL(tPtrToReal     ,Info); IO.WriteR        (IO.StdError,PtrToReal[0],1,10,1);
 |Boolean  : PtrToBoolean   := SYSTEM.VAL(tPtrToBoolean  ,Info); IO.WriteB        (IO.StdError,PtrToBoolean[0]);
 |Character: PtrToCharacter := SYSTEM.VAL(tPtrToCharacter,Info); IO.WriteC        (IO.StdError,PtrToCharacter[0]);
 |String   : PtrToString    := SYSTEM.VAL(tPtrToString   ,Info); Strings.WriteS   (IO.StdError,PtrToString[0]);
 |Array    : PtrToArray     := SYSTEM.VAL(tPtrToArray    ,Info); IO.WriteS        (IO.StdError,PtrToArray^);
 |Ident    : PtrToIdent     := SYSTEM.VAL(tPtrToIdent    ,Info); Idents.WriteIdent(IO.StdError, PtrToIdent[0]);
 ELSE        IO.WriteS(IO.StdError,"info class: ");
             IO.WriteI(IO.StdError,InfoClass,0);
 END; (* CASE *)
END WriteInfo;

(*
(*---------------------------------------------------------------------------*)
PROCEDURE WriteIdent(File : IO.tFile; Token : CARDINAL);
VAR
   Name : ARRAY [0..31] OF CHAR;
BEGIN (* WriteIdent *)
 Parser.xxTokenName(Token,Name);
 IO.WriteS(File,Name);
END WriteIdent;
*)

(*---------------------------------------------------------------------------*)
BEGIN (* Errors *)
 UseGeneratedCode:=FALSE;
END Errors.

