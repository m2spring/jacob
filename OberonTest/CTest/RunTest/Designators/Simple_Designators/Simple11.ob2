MODULE Simple11;

IMPORT O:=Out, Sim:=Simple10;

BEGIN (* Simple11 *)
  Sim.bo:=Sim.cbo;
  Sim.ch:=Sim.cch;
  Sim.si:=Sim.csi;
  Sim.in:=Sim.cin;
  Sim.li:=Sim.cli;
  Sim.re:=Sim.cre;
  Sim.lr:=Sim.clr;
  Sim.se:=Sim.cse;

  O.Bool(Sim.bo); O.String(' = '); O.Bool(Sim.cbo); O.Ln;
  O.Char(Sim.ch); O.String(' = '); O.Char(Sim.cch); O.Ln;
  O.Int(Sim.si); O.String(' = '); O.Int(Sim.csi); O.Ln;
  O.Int(Sim.in); O.String(' = '); O.Int(Sim.cin); O.Ln;
  O.Int(Sim.li); O.String(' = '); O.Int(Sim.cli); O.Ln;
  O.Real(Sim.re); O.String(' = '); O.Real(Sim.cre); O.Ln;
  O.Longreal(Sim.lr); O.String(' = '); O.Longreal(Sim.clr); O.Ln;
  O.Set(Sim.se); O.String(' = '); O.Set(Sim.cse); O.Ln;
  
END Simple11.
