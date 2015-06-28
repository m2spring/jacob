MODULE Byte;
IMPORT SYSTEM;
 
PROCEDURE P1(VAR p: SYSTEM.BYTE); BEGIN END P1;
PROCEDURE P2(p: SYSTEM.BYTE); BEGIN END P2;
 
PROCEDURE Q;
VAR bo:BOOLEAN; ch:CHAR; si:SHORTINT; in:INTEGER; li:LONGINT;
    re:REAL; lr:LONGREAL; se:SET;
BEGIN
   P1(bo);
(*      ^ err 123: type of actual parameter is not identical with that of formal VAR-parameter *)
   P1(ch);
   P1(si);
   P1(in);
(*      ^ err 123: type of actual parameter is not identical with that of formal VAR-parameter *)
   P1(li);
   P1(re);
(*      ^ err 123: type of actual parameter is not identical with that of formal VAR-parameter *)
   P1(lr);
   P1(se);
(*      ^ err 123: type of actual parameter is not identical with that of formal VAR-parameter *)
 
   P2(TRUE);
(*        ^ err 113: incompatible assignment *)
   P2(1X);
   P2(1);
   P2(128);
(*       ^ err 113: incompatible assignment *)
   P2(32768);
(*         ^ err 113: incompatible assignment *)
   P2(1.0E0);
(*         ^ err 113: incompatible assignment *)
   P2(1.0D0);
(*         ^ err 113: incompatible assignment *)
   P2({1});
(*       ^ err 113: incompatible assignment *)
END Q;
 
END Byte.
