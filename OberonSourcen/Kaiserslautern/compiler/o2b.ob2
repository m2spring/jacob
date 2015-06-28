MODULE o2b;

IMPORT
  Rts,Out,OSym,OTable,OBrowse,Filenames,OMachine,Redir;

CONST
  version = "1.4";
  date = "Thu Apr 20 19:07:26 MESZ 1995";
  
PROCEDURE PrintHelp;
  BEGIN
    Out.String("o2b [options] modulename"); Out.Ln;
    Out.String("Options:"); Out.Ln;
    Out.String("--help, -h      Print this text."); Out.Ln;
    Out.String("--version, -V   Print version."); Out.Ln;
    Out.String("--external, -e  Print external names."); Out.Ln;
    Out.String("--expand, -x    Expand records, show inherited fields."); Out.Ln;
  END PrintHelp;

PROCEDURE HandleArguments;
  VAR
    mod: OTable.Object;
    expand,external: BOOLEAN;
    argno: INTEGER;
    arginfo: ARRAY 256 OF CHAR;
  BEGIN
    IF (Rts.ArgNumber() > 0) THEN
      expand:=FALSE; external:=FALSE;
      argno:=1;
      REPEAT
        Rts.GetArg(argno,arginfo);
        IF (arginfo[0] = "-") THEN
          IF (arginfo = "--version") OR (arginfo = "-V") THEN
            Out.String("o2b "); 
            Out.String (version);
            Out.String (", ");
            Out.String (date);
            Out.Ln;
            RETURN;
          ELSIF (arginfo = "--help") OR (arginfo = "-h") THEN
            PrintHelp;
            RETURN;
          ELSIF (arginfo = "--expand") OR (arginfo = "-x") THEN
            expand:=TRUE;
          ELSIF (arginfo = "--external") OR (arginfo = "-e") THEN
            external:=TRUE;
          ELSE
            Out.String("Illegal option: "); Out.String(arginfo); Out.Ln;
          END; (* IF *)
          IF (Rts.ArgNumber() > argno) THEN
            INC(argno);
            Rts.GetArg(argno,arginfo);
          ELSE
            Out.String("Module name missing"); Out.Ln;
            RETURN;
          END; (* IF *)
        END; (* IF *)
      UNTIL (arginfo[0] # "-");
      Filenames.GetFile(arginfo,arginfo); (* Remove all additional stuff from modulename *)
      mod:=OSym.GetImport(arginfo,"");
      IF (mod # NIL) THEN
        OBrowse.Browse(mod,expand,external);
      ELSE
        Out.String("Symbolfile for '"); Out.String(arginfo); Out.String("' not found or not valid."); Out.Ln;
      END; (* IF *)
    END; (* IF *)
  END HandleArguments;

PROCEDURE Run*;
  BEGIN
    OTable.InitTable;
    HandleArguments;
    OTable.Cleanup;
  END Run;

BEGIN
  OMachine.redir := Redir.Read ("~/.o2c.red");
  Run;
END o2b.
