(* FormalPars und FPSection *)

MODULE pars029t;

PROCEDURE proc();
END proc;

PROCEDURE proc(a:b);
END proc;

PROCEDURE proc(VAR a:b):laber;
END proc;

PROCEDURE proc(a,b,c:Type1; VAR e:Type2):laber.bla;
END proc;

PROCEDURE proc(a,b:Type1; c:Type1; VAR d:Type2; e:Type3; f,g,h,i:Type4);
END proc;

PROCEDURE ^ forward():hur.ga;

PROCEDURE ^ forward(a:Type);

PROCEDURE ^ forward(VAR x:Type):result.type;

PROCEDURE ^ forward(a,b,c,d:Type1; VAR x,y:Type2; VAR z:Type3);

END pars029t.
