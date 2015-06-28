MODULE Sim;
(* Object-oriented simulation calendar, page 250 *)
IMPORT Qs, Out;

TYPE
   Actor* = POINTER TO ActorDesc;
   Message* = RECORD END;
   CalendarMsg* = RECORD (Message) END;
   Handler* = PROCEDURE (a: Actor; VAR msg: Message);

   ActorDesc* = RECORD (Qs.ItemDesc)
      handle* : Handler
   END;

VAR
   time* : REAL;         (*  Global simulation time  *)
   clndr: Qs.Ranked;   (* Abstract data structure *)

PROCEDURE Schedule* (a: Actor; t: REAL);
BEGIN  a.key := t;  Qs.Enqueue(clndr, a)
END Schedule;

PROCEDURE Simulate* (dt: REAL);
VAR
   cur: Qs.Item;
   msg: CalendarMsg;  tEnd: REAL;
BEGIN
   tEnd := time + dt;
   LOOP
      IF ~Qs.Empty(clndr) THEN
         cur := Qs.DequeuedItem(clndr);
         WITH cur: Actor DO
            time := cur.key;  cur.handle(cur, msg)
         END
      ELSE Out.String("empty calendar");  Out.Ln;  EXIT
      END;
      IF time > tEnd THEN EXIT END
   END
END Simulate;

PROCEDURE Reset*;
BEGIN  Qs.Open(clndr);  time := 0
END Reset;

BEGIN  NEW(clndr);  Reset
END Sim.   (* Copyright M. Reiser, 1992 *)
