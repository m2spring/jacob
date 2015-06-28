MODULE MenuViewers; (*JG 26.8.90*)

  IMPORT Input, Display, Texts, Viewers, Oberon;

  CONST extend* = 0; reduce* = 1; FrameColor = 15;

  TYPE
    Viewer* = POINTER TO ViewerDesc;

    ViewerDesc* = RECORD
      (Viewers.ViewerDesc)
      menuH*: INTEGER
    END;

    ModifyMsg* = RECORD
      (Display.FrameMsg)
      id*: INTEGER;
      dY*, Y*, H*: INTEGER
    END;

  VAR Ancestor*: Viewer;

  PROCEDURE Copy (V: Viewer; VAR V1: Viewer);
    VAR Menu, Main: Display.Frame; M: Oberon.CopyMsg;
  BEGIN
    Menu := V.dsc; Main := V.dsc.next;
    NEW(V1); V1^ := V^; V1.state := 0;
    Menu.handle(Menu, M); V1.dsc := M.F;
    Main.handle(Main, M); V1.dsc.next := M.F
  END Copy;

  PROCEDURE Draw (V: Viewers.Viewer);
  BEGIN
    Display.ReplConst(FrameColor, V.X, V.Y, 1, V.H, 0);
    Display.ReplConst(FrameColor, V.X + V.W - 1, V.Y, 1, V.H, 0);
    Display.ReplConst(FrameColor, V.X + 1, V.Y, V.W - 2, 1, 0);
    Display.ReplConst(FrameColor, V.X + 1, V.Y + V.H - 1, V.W - 2, 1, 0)
  END Draw;

  PROCEDURE Extend (V: Viewer; newY: INTEGER);
    VAR dH: INTEGER;
  BEGIN dH := V.Y - newY;
    IF dH > 0 THEN
    Display.ReplConst(Display.black, V.X + 1, newY + 1, V.W - 2, dH, 0);
    Display.ReplConst(FrameColor, V.X, newY, 1, dH, 0);
    Display.ReplConst(FrameColor, V.X + V.W - 1, newY, 1, dH, 0);
    Display.ReplConst(FrameColor, V.X + 1, newY, V.W - 2, 1, 0)
  END
  END Extend;

  PROCEDURE Reduce (V: Viewer; newY: INTEGER);
  BEGIN Display.ReplConst(FrameColor, V.X + 1, newY, V.W - 2, 1, 0)
  END Reduce;

  PROCEDURE Grow (V: Viewer; oldH: INTEGER);
    VAR dH: INTEGER;
  BEGIN dH := V.H - oldH;
    IF dH > 0 THEN
      Display.ReplConst(FrameColor, V.X, V.Y + oldH, 1, dH, 0);
      Display.ReplConst(FrameColor, V.X + V.W - 1, V.Y + oldH, 1, dH, 0);
      Display.ReplConst(FrameColor, V.X + 1, V.Y + V.H - 1, V.W - 2, 1, 0)
    END
  END Grow;

  PROCEDURE Shrink (V: Viewer; newH: INTEGER);
  BEGIN Display.ReplConst(FrameColor, V.X + 1, V.Y + newH - 1, V.W - 2, 1, 0)
  END Shrink;

  PROCEDURE Adjust (F: Display.Frame; id, dY, Y, H: INTEGER);
    VAR M: ModifyMsg;
  BEGIN M.id := id; M.dY := dY; M.Y := Y; M.H := H; F.handle(F, M); F.Y := Y; F.H := H
  END Adjust;

  PROCEDURE Restore (V: Viewer);
    VAR Menu, Main: Display.Frame;
  BEGIN
    Menu := V.dsc; Main := V.dsc.next;
    Oberon.RemoveMarks(V.X, V.Y, V.W, V.H);
    Draw(V);
    Menu.X := V.X + 1; Menu.Y := V.Y + V.H - 1; Menu.W := V.W - 2; Menu.H := 0;
    Main.X := V.X + 1; Main.Y := V.Y + V.H - V.menuH; Main.W := V.W - 2; Main.H := 0;
    IF V.H > V.menuH + 1 THEN
      Adjust(Menu, extend, 0, V.Y + V.H - V.menuH, V.menuH - 1);
      Adjust( Main, extend, 0, V.Y + 1, V.H - V.menuH - 1)
    ELSE Adjust(Menu, extend, 0, V.Y + 1, V.H - 2)
    END
  END Restore;

  PROCEDURE Modify (V: Viewer; Y, H: INTEGER);
    VAR Menu, Main: Display.Frame;
  BEGIN
    Menu := V.dsc; Main := V.dsc.next;
    IF Y < V.Y THEN (*extend*)
      Oberon.RemoveMarks(V.X, Y, V.W, V.Y - Y);
      Extend(V, Y);
      IF H > V.menuH + 1 THEN
        Adjust(Menu, extend, 0, Y + H - V.menuH, V.menuH - 1);
        Adjust(Main, extend, 0, Y + 1, H - V.menuH - 1)
      ELSE Adjust(Menu, extend, 0, Y + 1, H - 2)
      END
    ELSIF Y > V.Y THEN (*reduce*)
      Oberon.RemoveMarks(V.X, V.Y, V.W, V.H);
      IF H > V.menuH + 1 THEN
        Adjust(Main, reduce, 0, Y + 1, H - V.menuH - 1);
        Adjust(Menu, reduce, 0, Y + H - V.menuH, V.menuH - 1)
      ELSE
        Adjust(Main, reduce, 0, Y + H - V.menuH, 0);
        Adjust(Menu, reduce, 0, Y + 1, H - 2)
      END;
      Reduce(V, Y)
    END
  END Modify;

  PROCEDURE Change (V: Viewer; X, Y: INTEGER; Keys: SET);
    VAR Menu, Main: Display.Frame;
      V1: Viewers.Viewer; keysum: SET; Y0, dY, H: INTEGER;
  BEGIN (*Keys # {}*)
    Menu := V.dsc; Main := V.dsc.next;
    Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, X, Y);
    Display.ReplConst(Display.white, V.X + 1, V.Y + V.H - 1 - V.dsc.H, V.W - 2, V.dsc.H, 2);
    Y0 := Y;
    keysum := Keys;
    LOOP
      Input.Mouse(Keys, X, Y);
      IF Keys = {} THEN EXIT END;
      keysum := keysum + Keys;
      Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, X, Y)
    END;
    Display.ReplConst(Display.white, V.X + 1, V.Y + V.H - 1 - V.dsc.H, V.W - 2, V.dsc.H, 2);
    IF ~(0 IN keysum) THEN
      IF 1 IN keysum THEN
        Viewers.Close(V); Viewers.Open(V, X, Y); Restore(V)
      ELSE
        IF Y > Y0 THEN (*extend*) dY := Y - Y0;
          V1 := Viewers.Next(V);
          IF V1.state > 1 THEN
            IF V1 IS Viewer THEN
              IF dY > V1.H - V1(Viewer).menuH - 2 THEN dY := V1.H - V1(Viewer).menuH - 2 END
            ELSIF dY > V1.H - Viewers.minH THEN dY := V1.H - Viewers.minH
            END
          ELSIF dY > V1.H THEN dY := V1.H
          END;
          Viewers.Change(V, V.Y + V.H + dY);
          Oberon.RemoveMarks(V.X, V.Y, V.W, V.H);
          Grow(V, V.H - dY);
          IF V.H > V.menuH + 1 THEN
            Adjust(Menu, extend, dY, V.Y + V.H - V.menuH, V.menuH - 1);
            Adjust(Main, extend, dY, V.Y + 1, V.H - V.menuH - 1)
          ELSE Adjust(Menu, extend, dY, V.Y + 1, V.H - 2)
          END
        ELSIF Y < Y0 THEN (*reduce*) dY := Y0 - Y;
          IF dY > V.H - V(Viewer).menuH - 2 THEN dY := V.H - V(Viewer).menuH - 2 END;
          Oberon.RemoveMarks(V.X, V.Y, V.W, V.H);
          H := V.H - dY;
          IF H > V.menuH + 1 THEN
            Adjust(Main, reduce, dY, V.Y + 1, H - V.menuH - 1);
            Adjust(Menu, reduce, dY, V.Y + H - V.menuH, V.menuH - 1)
          ELSE
            Adjust(Main, reduce, dY, V.Y + H - V.menuH, 0);
            Adjust(Menu, reduce, dY, V.Y + 1, H - 2)
          END;
          Shrink(V, H);
          Viewers.Change(V, V.Y + H)
        END
      END
    END
  END Change;

  PROCEDURE Suspend (V: Viewer);
    VAR Menu, Main: Display.Frame;
  BEGIN
    Menu := V.dsc; Main := V.dsc.next;
    Adjust(Main, reduce, 0, V.Y + V.H - V.menuH, 0);
    Adjust(Menu, reduce, 0, V.Y + V.H - 1, 0)
  END Suspend;

  PROCEDURE Handle* (V: Display.Frame; VAR M: Display.FrameMsg);
    VAR Menu, Main: Display.Frame; V1: Viewer;
  BEGIN
    WITH V: Viewer DO Ancestor := V;
      Menu := V.dsc; Main := V.dsc.next;
      IF M IS Oberon.InputMsg THEN
        WITH M: Oberon.InputMsg DO
          IF M.id = Oberon.track THEN
            IF M.Y < V.Y + 1 THEN Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, M.X, M.Y)
            ELSIF M.Y < V.Y + V.H - V.menuH THEN Main.handle(Main, M)
            ELSIF M.Y < V.Y + V.H - V.menuH + 2 THEN Menu.handle(Menu, M)
            ELSIF M.Y < V.Y + V.H - 1 THEN
              IF 2 IN M.keys THEN Change(V, M.X, M.Y, M.keys)
                ELSE Menu.handle(Menu, M)
              END
            ELSE Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, M.X, M.Y)
            END
          ELSE Menu.handle(Menu, M); Main.handle(Main, M)
          END
        END
      ELSIF M IS Oberon.ControlMsg THEN
        WITH M: Oberon.ControlMsg DO
          IF M.id = Oberon.mark THEN
            Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, M.X, M.Y);
            Oberon.DrawCursor(Oberon.Pointer, Oberon.Star, M.X, M.Y)
          ELSE Menu.handle(Menu, M); Main.handle(Main, M)
          END
        END
       ELSIF M IS Oberon.CopyMsg THEN
         WITH M: Oberon.CopyMsg DO Copy(V(Viewer), V1); M.F := V1 END
       ELSIF M IS Viewers.ViewerMsg THEN
         WITH M: Viewers.ViewerMsg DO
           IF M.id = Viewers.restore THEN Restore(V)
           ELSIF M.id = Viewers.modify THEN Modify(V, M.Y, M.H)
           ELSIF M.id = Viewers.suspend THEN Suspend(V)
           END
         END
      ELSE Menu.handle(Menu, M); Main.handle(Main, M)
      END
    END
  END Handle;

  PROCEDURE New* (Menu, Main: Display.Frame; menuH, X, Y: INTEGER): Viewer;
    VAR V: Viewer;
  BEGIN NEW(V);
    V.handle := Handle; V.dsc := Menu; V.dsc.next := Main; V.menuH := menuH;
    Viewers.Open(V, X, Y); Restore(V);
    RETURN V
  END New;

END MenuViewers.
