MODULE c1;

CONST st1 = "string1";
      st2*= "string2";
      lr1 = 1.0D0;
      lr2*= 2.0D0;

PROCEDURE P1*;
CONST st1 = "string1";
      st2 = "string2";
      lr1 = 1.0D0;
      lr2 = 2.0D0;

 PROCEDURE P2;
 CONST st1 = "string1";
       st2 = "string2";
       lr1 = 1.0D0;
       lr2 = 2.0D0;
 BEGIN (* P2 *)
 END P2;

BEGIN (* P1 *)
END P1;

BEGIN (* c1 *)
END c1.
