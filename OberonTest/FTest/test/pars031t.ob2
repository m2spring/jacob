(* Record-Types *)

MODULE pars031t;

TYPE

A = RECORD
    END;

B = RECORD(laber)
    END;

C = RECORD(laber.bla)
    END;

D = RECORD
    a:Type1
    END;

E = RECORD
    a*,b-,c,d:Type1;;; e-:Type2;
    END;

F = RECORD(superclass)
     a,b,c*,d-,e: RECORD(mod.sup2) a,b*,c:laber END;
     f,g:Typemod.Type2
    END;

END pars031t.
