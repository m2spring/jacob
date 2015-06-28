(* WITH-Statement und Guard *)

MODULE pars040t;

BEGIN

WITH laber:bla DO
END;

WITH rec.field:mod.ident DO
 stmts;
END;

WITH rec.field:mod.ident DO
 stmts;
ELSE
 nochmehrstmts;
END;

WITH la:ber DO st1;
| qual.ident:bla DO st2;
|last:not.least DO st3;
ELSE
 st4;
END;

WITH la:ber DO st1;
| qual.ident:bla DO st2;
|last:not.least DO st3;
END;

END pars040t.
