MODULE Lists;
(* Simple lists, page 140-146; Exercise 9.3, page 156 *)

TYPE
   Key* = INTEGER;
   Data* = ARRAY 32 OF CHAR;

   Node* = POINTER TO NodeDesc;
   NodeDesc* = RECORD
      key*: Key;
      data*: Data;
      next*: Node
   END;

   NodeProc* = PROCEDURE(N: Node);  (* see page 199 *)


PROCEDURE New*(VAR n: Node; k: Key);
BEGIN  NEW(n);  n.key := k;  n.next := NIL
END New;

PROCEDURE InsertFirst*(VAR first: Node; new: Node);
BEGIN  (* new # NIL, no test for duplicate nodes *)
   new.next := first;  first := new
END InsertFirst;

PROCEDURE InsertLast*(VAR first: Node; new: Node);
VAR n: Node;
BEGIN  (* new # NIL *)
   IF first = NIL THEN  new.next := first; first := new
   ELSE
      n := first;
      WHILE n.next # NIL DO  n := n.next  END;
      new.next := n.next;  n.next := new
   END
END InsertLast;

PROCEDURE InsertRanked*(VAR first: Node; new: Node);
VAR n: Node;
BEGIN  (* new # NIL *)
   IF (first = NIL) OR (new.key < first.key) THEN
      new.next := first;  first := new
   ELSE
      n := first;
      WHILE (n.next # NIL) & (new.key >= n.next.key) DO
         n := n.next
      END;
      new.next := n.next;  n.next := new
   END
END InsertRanked;

PROCEDURE FirstNode*(VAR first: Node): Node;
VAR n: Node;
BEGIN
   n := first;  IF  n # NIL THEN  first := n.next  END;
   RETURN n
END FirstNode;

PROCEDURE Search*(first: Node; k: Key): Node;
BEGIN
   WHILE (first # NIL) & (first.key # k) DO first := first.next END;
   RETURN first
END Search ;

PROCEDURE Delete*(VAR first: Node; node: Node);
VAR n: Node;
BEGIN  (*  node # NIL  *)
   IF first # NIL THEN
      IF first = node THEN  first := node.next
      ELSE
         n := first;
         WHILE (n.next # NIL) & (n.next # node) DO
            n := n.next
         END;
         IF n.next # NIL THEN n.next := n.next.next END
      END
   END
END Delete;

PROCEDURE Enumerate*(first: Node; P: NodeProc);
BEGIN
   WHILE first # NIL DO  P(first);  first := first.next  END
END Enumerate;

END Lists.

