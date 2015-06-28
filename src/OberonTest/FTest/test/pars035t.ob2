(* CASE-Statement *)

MODULE pars035t;

BEGIN

CASE a OF
END;

CASE a OF
ELSE laber;
END;

CASE a OF
3:bla;
END;

CASE a OF
3:bla;
|5:laber;
END;

CASE a OF
3,4:bla;
|5..6,la..ber:hurga;
END;

CASE a OF
3:bla;
|5:laber;
|1,2..3,4..5,6,7,8,9..10 : laber;
END;

CASE a OF
3:bla;
|5:laber;
|1,2..3,4..5,6,7,8,9..10 : laber;
ELSE hurga;
END;

CASE a OF
3:bla;
|5..6:CASE EineExpr OF 3: firststatement|4..5,6,7..8:secondstatement END;
|9..1: laststatement;
END;

CASE a OF
ELSE CASE b OF ELSE CASE c OF ELSE CASE d OF ELSE laber; END; END; END;
END;

END pars035t.
