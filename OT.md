(********************************************************************************************************************************)
(*** OT.md / Basic Oberon-2 constants, types and operations                                                                   ***)
(********************************************************************************************************************************)
DEFINITION MODULE OT;

IMPORT StringMem, Strings, SYSTEM;

CONST  DBL_DIG            = 15;                                                  (* number of decimal digits of precision       *)
       DBL_MAX            = 1.7976931348623151E+308;                             (* maximum value                               *)

       FLT_DIG            = 7;                                                   (* number of decimal digits of precision       *)
       FLT_MAX            = 3.402823466E+38;                                     (* maximum value                               *)

       MaxCharOrd         = 255;                                                 (* We grant 8-Bit ASCII...                     *)
VAR    MinLongintReal     ,
       MaxLongintReal     : REAL;
       MinLongintLongreal ,
       MaxLongintLongreal : LONGREAL;
CONST  MinIllegalAbsInt   = (MAX(LONGCARD) DIV 2)+1;                             (* = 80000000H in 32 bits                      *)
       MaxObjectSize      = MAX(LONGINT)-1;                                      (* Maximum size of variables and types         *)
       ObjectTooBigSize   = MaxObjectSize+1;                                     (* This size flags that an object is too large *)

(*------------------------------------------------------------------------------------------------------------------------------*)
(*
 *  The oberon types
 *)
TYPE   oBYTE              = SYSTEM.BYTE;
       oPTR               = SYSTEM.ADDRESS;
       oBOOLEAN           = BOOLEAN;
       oCHAR              = SHORTCARD;
       oSTRING            = StringMem.tStringRef;
       oSHORTINT          = SHORTINT;
       oINTEGER           = SHORTINT;
       oLONGINT           = LONGINT;
       oREAL              = REAL;
       oLONGREAL          = RECORD v : LONGREAL; END;
       oSET               = BITSET;

(*------------------------------------------------------------------------------------------------------------------------------*)
(*
 *  number of storage required by oberon types
 *)
CONST  SIZEoBYTE          = SYSTEM.TSIZE(oBYTE);
       SIZEoPTR           = SYSTEM.TSIZE(oPTR);
       SIZEoBOOLEAN       = 1;
       SIZEoCHAR          = 1;
       SIZEoSHORTINT      = 1;
       SIZEoINTEGER       = 2;
       SIZEoLONGINT       = SYSTEM.TSIZE(oLONGINT);
       SIZEoSET           = SYSTEM.TSIZE(oSET);
       SIZEoREAL          = SYSTEM.TSIZE(oREAL);
       SIZEoLONGREAL      = SYSTEM.TSIZE(oLONGREAL);
       SIZEoPOINTER       = SYSTEM.TSIZE(SYSTEM.ADDRESS);
       SIZEoPROCEDURE     = SYSTEM.TSIZE(SYSTEM.ADDRESS);

(*------------------------------------------------------------------------------------------------------------------------------*)
(*
 *  limits of oberon types
 *)
CONST  MINoBOOLEAN        = FALSE;
       MAXoBOOLEAN        = TRUE;
       MINoCHAR           = 0;
       MAXoCHAR           = MaxCharOrd;
       MINoSHORTINT       = -128;
       MAXoSHORTINT       =  127;
       MINoINTEGER        = -32768;
       MAXoINTEGER        =  32767;
       MINoLONGINT        = MIN(LONGINT);
       MAXoLONGINT        = MAX(LONGINT);
       MINoSET            = 0;
       MAXoSET            = 31;
       MINoREAL           = -FLT_MAX;
       MAXoREAL           = +FLT_MAX;
VAR    MINoLONGREAL       ,
       MAXoLONGREAL       : oLONGREAL;

(*------------------------------------------------------------------------------------------------------------------------------*)
(*
 *  special oberon type values
 *)
CONST  NoBoolean          = FALSE;
       NoChar             = 0;
VAR    NoString           : oSTRING;
CONST  NoShortint         = 0;
       NoInteger          = 0;
       NoLongint          = 0;
       NoSet              = {};
       NoReal             = 0.0;
VAR    NoLongreal         : oLONGREAL;

CONST  EmptySet           = {};
       AllSet             = {0..MAXoSET};
VAR    ZeroLongint        : oLONGINT;

CONST  oNULL              = 0;
       oTAB               = 11;

(*------------------------------------------------------------------------------------------------------------------------------*)
(*
 *  oberon type constructors: mocka/reuse types --> oberon types
 *)

PROCEDURE LONGCARD2oLONGINT           (     lc     : LONGCARD        ;
                                        VAR oi     : oLONGINT        );

PROCEDURE CHAR2oCHAR                  (     ch     : CHAR            ;
                                        VAR oc     : oCHAR           );

PROCEDURE STR2oSTRING                 (     st     : Strings.tString ;
                                        VAR os     : oSTRING         );

PROCEDURE HEXSTR2oCHAR                ( VAR st     : Strings.tString ;
                                        VAR oc     : oCHAR           ;
                                        VAR OK     : BOOLEAN         );

PROCEDURE STR2oREAL                   ( VAR st     : Strings.tString ;
                                        VAR or     : oREAL           ;
                                        VAR OK     : BOOLEAN         );

PROCEDURE STR2oLONGREAL               ( VAR st     : Strings.tString ;
                                        VAR or     : oLONGREAL       ;
                                        VAR OK     : BOOLEAN         );

(*------------------------------------------------------------------------------------------------------------------------------*)
(*
 *  oberon types --> mocka types
 *)

PROCEDURE CHARofoCHAR                 (     oc     : oCHAR           ) : CHAR;
PROCEDURE LengthOfoSTRING             (     os     : oSTRING         ) : oLONGINT;
PROCEDURE LONGREALofoLONGREAL         (     ol     : oLONGREAL       ) : LONGREAL;

PROCEDURE SplitoLONGREAL              (     ol     : oLONGREAL       ;
                                        VAR lo, hi : LONGINT         ); 
PROCEDURE SplitoSTRING                (     os     : oSTRING         ;
                                        VAR li     : LONGINT         ); 
PROCEDURE ShortenoSTRING              (     os     : oSTRING         ;
                                            len    : LONGINT         ) : oSTRING;

(*------------------------------------------------------------------------------------------------------------------------------*)
(*
 *  oberon types --> textual representation
 *)

PROCEDURE oBOOLEAN2ARR                (     ob     : oBOOLEAN        ;
                                        VAR st     : ARRAY OF CHAR   );
PROCEDURE oCHAR2ARR                   (     oc     : oCHAR           ;
                                        VAR st     : ARRAY OF CHAR   );
PROCEDURE oSTRING2ARR                 (     s      : oSTRING         ;
                                        VAR st     : ARRAY OF CHAR   );
PROCEDURE oSET2ARR                    (     os     : oSET            ;
                                        VAR st     : ARRAY OF CHAR   );
PROCEDURE oLONGINT2ARR                (     oi     : oLONGINT        ;
                                        VAR st     : ARRAY OF CHAR   );
PROCEDURE oREAL2ARR                   (     or     : oREAL           ;
                                        VAR st     : ARRAY OF CHAR   );
PROCEDURE oLONGREAL2ARR               (     ol     : oLONGREAL       ;
                                        VAR st     : ARRAY OF CHAR   );

(*------------------------------------------------------------------------------------------------------------------------------*)
(*
 *  evaluator internal procedures
 *)

PROCEDURE EqualoLONGREAL              (     arg1   ,
                                            arg2   : oLONGREAL        ) : BOOLEAN;

PROCEDURE IsLegalSetValue             (     val    : oLONGINT         ) : BOOLEAN;

PROCEDURE ExtendSet                   ( VAR result : oSET             ;
                                            set    : oSET;
                                            arg1   ,
                                            arg2   : oLONGINT         );

PROCEDURE AreOverlappingCharRanges    (     a1     ,
                                            b1     ,
                                            a2     ,
                                            b2     : oCHAR            ) : BOOLEAN;

PROCEDURE AreOverlappingIntegerRanges (     a1     ,
                                            b1     ,
                                            a2     ,
                                            b2     : oLONGINT         ) : BOOLEAN;

PROCEDURE NewArrayTypeSize            (     len    : oLONGINT         ;
                                            eSize  : LONGINT          ) : LONGINT;

PROCEDURE NewRecordTypeSize           (     oSize  ,
                                            fSize  : LONGINT          ) : LONGINT;

(*------------------------------------------------------------------------------------------------------------------------------*)
(*
 *  coercions
 *)

PROCEDURE oCHAR2oSTRING               (     arg    : oCHAR            ;
                                        VAR result : oSTRING          );

PROCEDURE oLONGINT2oREAL              (     arg    : oLONGINT         ;
                                        VAR result : oREAL            );

PROCEDURE oLONGINT2oLONGREAL          (     arg    : oLONGINT         ;
                                        VAR result : oLONGREAL        );

PROCEDURE oREAL2oLONGREAL             (     arg    : oREAL            ;
                                        VAR result : oLONGREAL        );

PROCEDURE oLONGREAL2oREAL             (     arg    : oLONGREAL        ;
                                        VAR result : oREAL            ;
                                        VAR OK     : BOOLEAN          );

(*------------------------------------------------------------------------------------------------------------------------------*)
(*
 *  monadic operations
 *)

PROCEDURE NegateSet                   ( VAR result : oSET             ;
                                            arg    : oSET             );
PROCEDURE NegateLongint               ( VAR result : oLONGINT         ;
                                            arg    : oLONGINT         ;
                                        VAR OK     : BOOLEAN          );
PROCEDURE NegateReal                  ( VAR result : oREAL            ;
                                            arg    : oREAL            );
PROCEDURE NegateLongreal              ( VAR result : oLONGREAL        ;
                                            arg    : oLONGREAL        );
PROCEDURE NotBoolean                  ( VAR result : oBOOLEAN         ;
                                            arg    : oBOOLEAN         );

(*------------------------------------------------------------------------------------------------------------------------------*)
(*
 *  relations
 *)

PROCEDURE BooleanRelation             ( VAR result : oBOOLEAN         ;
                                            arg1   ,
                                            arg2   : oBOOLEAN         ;
                                            oper   : SHORTCARD        );
PROCEDURE CharRelation                ( VAR result : oBOOLEAN         ;
                                            arg1   ,
                                            arg2   : oCHAR            ;
                                            oper   : SHORTCARD        );
PROCEDURE StringRelation              ( VAR result : oBOOLEAN         ;
                                            arg1   ,
                                            arg2   : oSTRING          ;
                                            oper   : SHORTCARD        );
PROCEDURE SetRelation                 ( VAR result : oBOOLEAN         ;
                                            arg1   ,
                                            arg2   : oSET             ;
                                            oper   : SHORTCARD        );
PROCEDURE IntegerRelation             ( VAR result : oBOOLEAN         ;
                                            arg1   ,
                                            arg2   : oLONGINT         ;
                                            oper   : SHORTCARD        );
PROCEDURE RealRelation                ( VAR result : oBOOLEAN         ;
                                            arg1   ,
                                            arg2   : oREAL            ;
                                            oper   : SHORTCARD        );
PROCEDURE LongrealRelation            ( VAR result : oBOOLEAN         ;
                                            arg1   ,
                                            arg2   : oLONGREAL        ;
                                            oper   : SHORTCARD        );

PROCEDURE IntegerInSet                ( VAR result : oBOOLEAN         ;
                                            arg1   : oLONGINT         ;
                                            arg2   : oSET             );

(*------------------------------------------------------------------------------------------------------------------------------*)
(*
 *  dyadic operations
 *)

PROCEDURE IntegerOperation            ( VAR result : oLONGINT         ;
                                            arg1   ,
                                            arg2   : oLONGINT         ;
                                            oper   : SHORTCARD        ;
                                        VAR OK     : BOOLEAN          );
PROCEDURE RealOperation               ( VAR result : oREAL            ;
                                            arg1   ,
                                            arg2   : oREAL            ;
                                            oper   : SHORTCARD        ;
                                        VAR OK     : BOOLEAN          );
PROCEDURE LongrealOperation           ( VAR result : oLONGREAL        ;
                                            arg1   ,
                                            arg2   : oLONGREAL        ;
                                            oper   : SHORTCARD        ;
                                        VAR OK     : BOOLEAN          );
PROCEDURE SetOperation                ( VAR result : oSET             ;
                                            arg1   ,
                                            arg2   : oSET             ;
                                            oper   : SHORTCARD        ;
                                        VAR OK     : BOOLEAN          );

(*------------------------------------------------------------------------------------------------------------------------------*)
(*
 *  predeclared (function) procedures
 *)

PROCEDURE IntegerAbs                  ( VAR result : oLONGINT         ;
                                            arg    : oLONGINT         ;
                                        VAR OK     : BOOLEAN          );
PROCEDURE RealAbs                     ( VAR result : oREAL            ;
                                            arg    : oREAL            ;
                                        VAR OK     : BOOLEAN          );
PROCEDURE LongrealAbs                 ( VAR result : oLONGREAL        ;
                                            arg    : oLONGREAL        ;
                                        VAR OK     : BOOLEAN          );

PROCEDURE IntegerAsh                  ( VAR result : oLONGINT         ;
                                            arg1   ,
                                            arg2   : oLONGINT         ;
                                        VAR OK     : BOOLEAN          );

PROCEDURE CharCap                     ( VAR result : oCHAR            ;
                                            arg    : oCHAR            );

PROCEDURE IntegerChr                  ( VAR result : oCHAR            ;
                                            arg    : oLONGINT         ;
                                        VAR OK     : BOOLEAN          );

PROCEDURE RealEntier                  ( VAR result : oLONGINT         ;
                                            arg    : oREAL            ;
                                        VAR OK     : BOOLEAN          );
PROCEDURE LongrealEntier              ( VAR result : oLONGINT         ;
                                            arg    : oLONGREAL        ;
                                        VAR OK     : BOOLEAN          );

PROCEDURE IntegerOdd                  ( VAR result : oBOOLEAN         ;
                                            arg    : oLONGINT         );

PROCEDURE CharOrd                     ( VAR result : oLONGINT         ;
                                            arg    : oCHAR            );

(*------------------------------------------------------------------------------------------------------------------------------*)
END OT.

