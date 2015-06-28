MODULE Trees;
(* Binary trees, page 146-153; Exercise 9.6, page 157 *)

TYPE
   Key* = INTEGER;
   Data* = ARRAY 32 OF CHAR;

   Node* = POINTER TO NodeDesc;
   NodeDesc* = RECORD
      key*: Key;
      data*: Data;
      left*, right*: Node
   END;

   NodeProc* = PROCEDURE(N: Node);  (* see page 199 *)

PROCEDURE New*(VAR n: Node; k: Key);
BEGIN  NEW(n);  n.key := k;  n.left := NIL;  n.right := NIL
END New;

PROCEDURE Insert*(VAR root: Node; new: Node);
BEGIN  (* new # NIL *)
   IF root = NIL THEN  (* stop recursion *)
      root := new;  root.left := NIL;  root.right := NIL
   ELSIF new.key < root.key THEN Insert(root.left, new)
   ELSIF new.key > root.key THEN Insert(root.right, new)
   ELSE  (* duplicate key, add desired action *)
   END
END Insert;

PROCEDURE RemoveMax(VAR root, max: Node);
BEGIN
   IF root.right # NIL THEN RemoveMax(root.right, max)
   ELSE max := root;  root := max.left
   END
END RemoveMax;

PROCEDURE Delete*(VAR root: Node; key: Key);
VAR node: Node;
BEGIN
   IF root # NIL THEN
      IF key < root.key THEN Delete(root.left, key)
      ELSIF key > root.key THEN Delete(root.right, key)
      ELSE  (* delete root *)
         IF root.left = NIL THEN root := root.right
         ELSIF root.right = NIL THEN root := root.left
         ELSE  (* root has two sub-trees *)
            RemoveMax(root.left, node);
            node.left := root.left;  node.right := root.right;
            root := node
         END
      END
   END
END Delete;

PROCEDURE Search*(root: Node; key: Key): Node;
BEGIN
   WHILE (root # NIL) & (root.key # key) DO
      IF key < root.key THEN root := root.left
      ELSE  root := root.right
      END
   END;
   RETURN root
END Search;

PROCEDURE Enumerate*(root: Node; P: NodeProc);
BEGIN
   IF root # NIL THEN
      Enumerate(root.left, P);  P(root);  Enumerate(root.right, P)
   END
END Enumerate;

END Trees.   (* Copyright M. Reiser, 1992 *)

