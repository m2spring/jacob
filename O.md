DEFINITION MODULE O;
(*
 * Provides various output primitives (to stdoutput).
 *)

IMPORT Idents, OT, SYSTEM, Strings;

CONST  BEL = CHR(7);
       BS  = CHR(8);
       LF  = CHR(10);
       CR  = CHR(13);
       NL  = LF;

PROCEDURE Ln;
PROCEDURE Spc;
PROCEDURE Bool        ( v : BOOLEAN              );
PROCEDURE Char        ( c : CHAR                 );
PROCEDURE oChar       ( c : OT.oCHAR         );
PROCEDURE STR         ( VAR s : ARRAY OF CHAR    );
PROCEDURE Str         ( s : ARRAY OF CHAR        );
PROCEDURE StrLn       ( s : ARRAY OF CHAR        );
PROCEDURE String      ( s : Strings.tString      );
PROCEDURE oString     ( r : OT.oSTRING       );
PROCEDURE Ident       ( i : Idents.tIdent        );
PROCEDURE ShtCard     ( v : SHORTCARD            );
PROCEDURE Card        ( v : CARDINAL             );
PROCEDURE LngCard     ( v : LONGCARD             );
PROCEDURE ShtInt      ( v : SHORTINT             );
PROCEDURE Int         ( v : INTEGER              );
PROCEDURE LngInt      ( v : LONGINT              );
PROCEDURE Byte        ( v : SHORTCARD            );
PROCEDURE Word        ( v : CARDINAL             );
PROCEDURE LngWord     ( v : LONGCARD             );
PROCEDURE Addr        ( v : SYSTEM.ADDRESS       );
PROCEDURE Set         ( v : BITSET               );
PROCEDURE Data        ( v : ARRAY OF SYSTEM.BYTE );

PROCEDURE ShtNum      ( v : SHORTCARD; n : SHORTCARD );
PROCEDURE Num         ( v : CARDINAL ; n : SHORTCARD );
PROCEDURE LngNum      ( v : LONGCARD ; n : SHORTCARD );

PROCEDURE Real        ( v : REAL    ; Precision, Length : INTEGER );
PROCEDURE LngReal     ( v : LONGREAL; Precision, Length : INTEGER );
PROCEDURE oLngReal    ( v : OT.oLONGREAL; Precision, Length : INTEGER );

PROCEDURE RealSci     ( v : REAL );
PROCEDURE LngRealSci  ( v : LONGREAL );
PROCEDURE oLngRealSci ( v : OT.oLONGREAL );

PROCEDURE CharRep     ( c : CHAR; count : CARDINAL );

PROCEDURE BackSpace   ( n : CARDINAL );

PROCEDURE St2         ( s1, s2                             : ARRAY OF CHAR );
PROCEDURE St3         ( s1, s2, s3                         : ARRAY OF CHAR );
PROCEDURE St4         ( s1, s2, s3, s4                     : ARRAY OF CHAR );
PROCEDURE St5         ( s1, s2, s3, s4, s5                 : ARRAY OF CHAR );
PROCEDURE St6         ( s1, s2, s3, s4, s5, s6             : ARRAY OF CHAR );
PROCEDURE St7         ( s1, s2, s3, s4, s5, s6, s7         : ARRAY OF CHAR );
PROCEDURE St8         ( s1, s2, s3, s4, s5, s6, s7, s8     : ARRAY OF CHAR );
PROCEDURE St9         ( s1, s2, s3, s4, s5, s6, s7, s8, s9 : ARRAY OF CHAR );

PROCEDURE CharVerb    ( c : CHAR );

END O.

