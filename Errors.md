DEFINITION MODULE Errors;

IMPORT POS, SYSTEM;

CONST  (* error codes *)
       NoText               = 0  ;
       SyntaxError          = 1  ;
       ExpectedTokens       = 2  ;
       RestartPoint         = 3  ;
       TokenInserted        = 4  ;
       WrongParseTable      = 5  ;
       OpenParseTable       = 6  ;
       ReadParseTable       = 7  ;

       (* error classes *)
       NoError              = 0  ;
       Fatal                = 1  ;
       Restriction          = 2  ;
       Error                = 3  ;
       Warning              = 4  ;
       Repair               = 5  ;
       Note                 = 6  ;
       Information          = 7  ;

       (* info classes *)
       None                 = 0  ;
       Integer              = 1  ;
       Short                = 2  ;
       Long                 = 3  ;
       Real                 = 4  ;
       Boolean              = 5  ;
       Character            = 6  ;
       String               = 7  ;
       Array                = 8  ;
       Set                  = 9  ;
       Ident                = 10 ;

VAR    UseGeneratedCode     : BOOLEAN;

PROCEDURE ErrorMessage  ( ErrorCode  ,
                          ErrorClass : CARDINAL       ;
                          Position   : POS.tPosition  );

PROCEDURE ErrorMessageI ( ErrorCode  ,
                          ErrorClass : CARDINAL       ;
                          Position   : POS.tPosition  ;
                          InfoClass  : CARDINAL       ;
                          Info       : SYSTEM.ADDRESS );

END Errors.


