MODULE o2whereis;  (* Author: Michael van Acken *)

IMPORT
  Rts, Out, Redir, Strings2, OMachine;


PROCEDURE WriteHelp;
  VAR
    arg : ARRAY Redir.maxPathLen OF CHAR;
  BEGIN
    Out.String ("Usage: ");
    Rts.GetArg (0, arg);
    Out.String (arg);
    Out.String (" [-r] <file>");
    Out.Ln;
    Out.String ("For RCS files the name of the work file is printed, unless -r is given.");
    Out.Ln
  END WriteHelp;


PROCEDURE Query*;
  VAR
    i : INTEGER;
    printRCS : BOOLEAN;
    arg, file : ARRAY Redir.maxPathLen OF CHAR;
  BEGIN
    printRCS := FALSE;
    IF (Rts.ArgNumber() < 1) THEN
      WriteHelp
    ELSE
      i := 1;
      WHILE (i <= Rts.ArgNumber()) DO
        Rts.GetArg (i, arg);
        IF (arg = "-r") THEN
          printRCS := TRUE
        ELSIF (arg = "--help") THEN
          WriteHelp        
        ELSIF (i # Rts.ArgNumber()) OR (arg[0] = "-") THEN
          Out.String ("Unknown option ");
          Out.String (arg);
          Out.Char (".");
          Out.Ln;
          RETURN
        ELSE  (* last option has to be the file name *)
          IF Redir.FindPath (OMachine.redir, arg, file) THEN
            IF ~printRCS & Strings2.Match ("*,v", file) THEN
              Redir.RCS2File (file, file)
            END;
            Out.String (file)
          ELSE
            Out.String ("Can't find file ");
            Out.String (arg);
            Out.String (".")
          END;
          Out.Ln
        END;
        INC (i)
      END
    END
  END Query;

BEGIN
  OMachine.redir := Redir.Read ("~/.o2c.red");
  Query
END o2whereis.
