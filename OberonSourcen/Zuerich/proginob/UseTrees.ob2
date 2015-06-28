MODULE UseTrees;
(* Exercise 9.6, page 157 *)

IMPORT Trees, In, Out;

VAR  tree: Trees.Node;  (* anchor of the tree *)

PROCEDURE PrintNode(n: Trees.Node);
BEGIN
   Out.String("    key =");  Out.Int(n.key, 3);
   Out.String("    data =");  Out.String(n.data);
   Out.Ln
END PrintNode;

PROCEDURE Make*;
BEGIN tree := NIL;  Out.String("made empty tree");  Out.Ln
END Make;

PROCEDURE Print*;
BEGIN
   Out.String("print tree:");  Out.Ln;  Trees.Enumerate(tree, PrintNode)
END Print;

PROCEDURE Add*;
VAR  n: Trees.Node;  k: Trees.Key;  d: Trees.Data;
BEGIN
   In.Open;  In.Int(k);  In.String(d);
   Trees.New(n, k);  n.data := d;  Trees.Insert(tree, n);
   Out.String("added:  key =");  Out.Int(n.key, 3);
   Out.String("    data = ");  Out.String(d);  Out.Ln
END Add;

PROCEDURE Query*;
VAR  n: Trees.Node;  k: Trees.Key;
BEGIN
   In.Open;  In.Int(k);
   n := Trees.Search(tree, k);
   IF n = NIL THEN Out.String("not found")
   ELSE
      Out.String("query found:  key =");  Out.Int(n.key, 3);
      Out.String("    data = ");  Out.String(n.data)
   END;
   Out.Ln
END Query;

PROCEDURE Delete*;
VAR  n: Trees.Node;  k: Trees.Key;
BEGIN
   In.Open;  In.Int(k);
   Trees.Delete(tree, k);
   Out.String("deleted  key=");  Out.Int(k, 3);  Out.Ln
END Delete;

BEGIN Make
END UseTrees.   (* Copyright M. Reiser, 1992 *)
