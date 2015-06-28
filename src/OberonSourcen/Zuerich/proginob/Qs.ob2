MODULE Qs;
(* Generic queues module, page 245 *)
TYPE
   Key = REAL;
   Item* = POINTER TO ItemDesc;
   ItemDesc* = RECORD
      key*: Key;
      next: Item
   END;
   ItemProc = PROCEDURE(i: Item);


   Queue* = POINTER TO QueueDesc;
   QueueDesc* = RECORD
      first: Item
   END;

   FIFO* = POINTER TO FIFODesc;
   FIFODesc* = RECORD (QueueDesc)
      last: Item
   END;

   LIFO* = POINTER TO LIFODesc;
   LIFODesc* = RECORD (QueueDesc) END;

   Ranked* = POINTER TO RankedDesc;
   RankedDesc* = RECORD (QueueDesc) END;

PROCEDURE InsertFIFO(q: FIFO; i: Item);
BEGIN
   i.next := NIL;
   IF q.first # NIL THEN q.last.next := i
   ELSE q.first := i
   END;
   q.last := i
END InsertFIFO;

PROCEDURE InsertLIFO(q: LIFO; i: Item);
BEGIN  i.next := q.first;  q.first := i
END InsertLIFO;

PROCEDURE InsertRanked(q: Ranked; i: Item);
VAR x: Item;
BEGIN
   IF (q.first = NIL) OR (i.key < q.first.key) THEN
      i.next := q.first;  q.first := i
   ELSE
      x := q.first;
      WHILE (x.next # NIL) & (i.key >= x.next.key) DO
         x := x.next
      END;
      i.next := x.next;  x.next := i
   END
END InsertRanked;

PROCEDURE Enqueue*(q: Queue; i: Item);
VAR x: Item;
BEGIN
   IF q IS FIFO THEN  InsertFIFO(q(FIFO), i)
   ELSIF q IS LIFO THEN InsertLIFO(q(LIFO), i)
   ELSIF q IS Ranked THEN InsertRanked(q(Ranked), i)
   END
END Enqueue;

PROCEDURE DequeuedItem*(q: Queue): Item;
VAR x: Item;
BEGIN  x := q.first;
   IF x # NIL THEN q.first := x.next END;
   RETURN x
END DequeuedItem;

PROCEDURE Enumerate*(q: Queue; P: ItemProc);
VAR x: Item;
BEGIN  x := q.first; WHILE x # NIL DO P(x); x := x.next END
END Enumerate;

PROCEDURE Empty*(q: Queue): BOOLEAN;
BEGIN  RETURN q.first = NIL
END Empty;

PROCEDURE Open*(q: Queue);
BEGIN  q.first := NIL
END Open;

END Qs.   (* Copyright M. Reiser *)

