MODULE Calendar;
(* Simulation Calendar, page 164 *)
CONST  deadlock* = MAX(INTEGER);
TYPE
     Event = POINTER TO EventDesc;
     EventDesc = RECORD
          id: INTEGER;
          time: REAL;
          next: Event
     END;

VAR clndr: Event;

PROCEDURE GetNextEvent*(VAR id: INTEGER; VAR t: REAL);
BEGIN
     IF clndr # NIL THEN
          id := clndr.id;  t := clndr.time;
          clndr := clndr.next
     ELSE id := deadlock
     END
END GetNextEvent;

PROCEDURE Schedule* (id: INTEGER; t: REAL);
VAR x, y: Event;
BEGIN
     NEW(x);  x.id := id;  x.time := t;
     IF (clndr = NIL) OR (t < clndr.time) THEN
          x.next := clndr;  clndr := x
     ELSE
          y := clndr;
          WHILE (y.next # NIL) & (t >= y.time) DO  y := y.next  END;
          x.next := y.next;  y.next := x
     END
END Schedule;

PROCEDURE Reset*;
BEGIN  clndr := NIL
END Reset;

BEGIN
     Reset
END Calendar. (* Copyright M. Reiser, 1992 *)
