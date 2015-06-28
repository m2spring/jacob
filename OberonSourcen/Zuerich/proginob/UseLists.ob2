MODULE UseLists;
(* Exercise 9.3, page 156 *)
IMPORT Lists, In, Out;

VAR  list: Lists.Node;  (* anchor of the list *)

PROCEDURE PrintNode(n: Lists.Node);
BEGIN
   Out.String("    key =");  Out.Int(n.key, 3);
   Out.String("    data =");  Out.String(n.data);
   Out.Ln
END PrintNode;

PROCEDURE Make*;
BEGIN list := NIL;  Out.String("made empty list");  Out.Ln
END Make;

PROCEDURE Print*;
BEGIN
   Out.String("print list:");  Out.Ln;  Lists.Enumerate(list, PrintNode)
END Print;

PROCEDURE Add*;
VAR  n: Lists.Node;  k: Lists.Key;  d: Lists.Data;
BEGIN
   In.Open;  In.Int(k);  In.String(d);
   Lists.New(n, k);  n.data := d;  Lists.InsertRanked(list, n);
   Out.String("added:  key =");  Out.Int(n.key, 3);
   Out.String("    data = ");  Out.String(d);  Out.Ln
END Add;

PROCEDURE Query*;
VAR  n: Lists.Node;  k: Lists.Key;
BEGIN
   In.Open;  In.Int(k);
   n := Lists.Search(list, k);
   IF n = NIL THEN Out.String("not found")
   ELSE
      Out.String("query found:  key =");  Out.Int(n.key, 3);
      Out.String("    data = ");  Out.String(n.data)
   END;
   Out.Ln
END Query;

PROCEDURE Delete*;
VAR  n: Lists.Node;  k: Lists.Key;
BEGIN
   In.Open;  In.Int(k);
   n := Lists.Search(list, k);
   IF n = NIL THEN Out.String("not found")
   ELSE
      Lists.Delete(list, n);
      Out.String("deleted  key=");  Out.Int(n.key, 3)
   END;
   Out.Ln
END Delete;

BEGIN Make
END UseLists.   (* Copyright M. Reiser, 1992 *)
