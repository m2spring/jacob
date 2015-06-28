MODULE Model2;
(* A single server queue model, page 260 *)
IMPORT Sim, Stations, Paths, Sequences, RandomNumbers, In, Out;
TYPE
   Customer = POINTER TO CustomerDesc;
   CustomerDesc = RECORD (Sim.ActorDesc)
      ts: REAL   (* Time stamp of arrival epoch *)
   END;

VAR  (* Global state variables *)
   lambda, mu: REAL;
   s: Stations.Station;
   srce: Sim.Actor;
   w: Sequences.Sequence;

PROCEDURE HandleCust(cust: Sim.Actor; VAR msg: Sim.Message);
BEGIN
   WITH cust: Customer DO
      IF msg IS Stations.BeginMsg THEN
         Sim.Schedule(cust, Sim.time + RandomNumbers.Exp(mu))
      ELSIF msg IS Sim.CalendarMsg THEN
         Stations.Free(s);  Sequences.Add(w, Sim.time - cust.ts)
      END
   END
END HandleCust;

PROCEDURE HandleSrce(srce: Sim.Actor; VAR msg: Sim.Message);
VAR c: Customer;
BEGIN
   NEW(c);  c.handle := HandleCust;  c.ts := Sim.time;
   Stations.Request(s, c);
   Sim.Schedule(srce, Sim.time + RandomNumbers.Exp(lambda))
END HandleSrce;

PROCEDURE Setup*;
VAR  c: Customer;
BEGIN
   In.Open;  Sim.Reset;  Sequences.Open(w);  Out.Open;
   NEW(srce); srce.handle := HandleSrce;
   In.Real(lambda);  Out.String("lambda =");  Out.Real(lambda, 10);
   Sim.Schedule(srce, 0);
   NEW(s);  Stations.Open(s);
   In.Real(mu);  Out.String("     mu =");  Out.Real(mu, 10);  Out.Ln
END Setup;

PROCEDURE Run*;
VAR dt: REAL;  q: REAL;
BEGIN
   In.Open; In.Real(dt);
   Sim.Simulate(dt);
   Out.String("Sim.time =");  Out.Real(Sim.time, 10);
   Out.String("     E[W]=");  Out.Real(Sequences.Mean(w), 10);
   Out.String("     var[W]=");  Out.Real(Sequences.Var(w), 10);
   Out.Ln
END Run;

END Model2.     (* Copyright M. Reiser, 1992 *)
