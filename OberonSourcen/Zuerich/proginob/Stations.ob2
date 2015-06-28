MODULE Stations;
(* A first-come, first-served queueing station, page 257 *)
IMPORT Qs, Sim, Paths;

TYPE
   Station* = POINTER TO StationDesc;
   StationDesc* = RECORD
      wl: Qs.FIFO;         (* Waiting Line  *)
      path* : Paths.Path
   END;

   BeginMsg* = RECORD (Sim.Message)  s*: Station  END;

PROCEDURE Request* (s: Station; customer: Sim.Actor);
VAR msg: BeginMsg;
BEGIN
   IF s.path.n = 0  THEN  (* Server empty  *)
      msg.s := s;  customer.handle(customer, msg)
   ELSE  Qs.Enqueue(s.wl, customer)
   END;
   Paths.Up(s.path, Sim.time)
END Request;

PROCEDURE Free* (s: Station);
VAR
   customer: Qs.Item;
   msg: BeginMsg;
BEGIN
   Paths.Down(s.path, Sim.time);
   IF s.path.n > 0 THEN  (* Customers are waiting *)
      customer := Qs.DequeuedItem(s.wl);
      WITH customer: Sim.Actor DO
         msg.s := s;  customer.handle(customer, msg)
      END
   END
END Free;

PROCEDURE Open* (s: Station);
BEGIN
   Paths.Init(s.path);  NEW(s.wl);  Qs.Open(s.wl)
END Open;

END Stations.   (* Copyright M. Reiser, 1992 *)

