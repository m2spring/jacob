MODULE Model1;    (* A single queue model, page 171 *)
IMPORT Paths, Calendar, RandomNumbers, In, Out;
CONST  arrival = 0;  departure = 1;
VAR
   event: INTEGER;
   time: REAL;         (*  current time  *)
   q: Paths.Path;      (*  state of queue and statistics  *)
   lamda: REAL;      (*  arrival rate  *)
   mu: REAL;         (*  inverse of mean service time *)

PROCEDURE ProcessArrival;
BEGIN
   Calendar.Schedule(arrival, time + RandomNumbers.Exp(lamda));
   IF q.n = 0 THEN
      Calendar.Schedule(departure, time + RandomNumbers.Exp(mu))
   END;
   Paths.Up(q, time)
END ProcessArrival;

PROCEDURE ProcessDeparture;
VAR s: REAL;
BEGIN
   Paths.Down(q, time);
   IF q.n > 0 THEN
      Calendar.Schedule(departure, time + RandomNumbers.Exp(mu))
   END
END ProcessDeparture;

PROCEDURE Simulate(dt: REAL);
VAR tEnd: REAL;
BEGIN
   tEnd := time + dt;
   REPEAT
      Calendar.GetNextEvent(event, time);
      IF event = arrival THEN  ProcessArrival
      ELSIF event = departure THEN  ProcessDeparture
      END
   UNTIL time > tEnd
END Simulate;

PROCEDURE Setup*;
BEGIN
   In.Open;  In.Real(lamda);  In.Real(mu);
   Out.Open;
   Out.String("lamda =");   Out.Real(lamda, 10);
   Out.String("   mu =");   Out.Real(mu, 10);   Out.Ln;
   Calendar.Reset;   Paths.Init(q);
   Calendar.Schedule(arrival, 0.0)
END Setup;

PROCEDURE Run*;
VAR dt: REAL;
BEGIN
   In.Open;  In.Real(dt);  Simulate(dt);
   Out.String("mean =");  Out.Real(Paths.Mean(q, time), 11);  Out.Ln
END Run;

END Model1.     (* Copyright M. Reiser, 1992 *)
