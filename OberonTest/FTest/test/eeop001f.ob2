(* 8.Expressions: Operands                                                    *)
(* If r designates a record, then r.f denotes the field f of r or             *)
(* the procedure f bound to the dynamic type of r.                            *)

MODULE eeop001f;
  TYPE Point = RECORD
                x : INTEGER;
                y : INTEGER
               END;

  TYPE Point3D = RECORD(Point)
                  z:INTEGER
                 END;

  VAR p  : Point;
  VAR p3 : Point3D;
  VAR i  : INTEGER;

BEGIN
  IF Point.x = 10
(*        ^--- Field selector not applicable - Pos: 20,11 *)
(*   ^___ Types are not allowed here - Pos: 20,6          *)

     THEN i:=10
     ELSE i:=20
  END;
END eeop001f.

