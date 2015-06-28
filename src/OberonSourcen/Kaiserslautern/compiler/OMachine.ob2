MODULE OMachine;

IMPORT 
  Redir;


CONST
  maxSizeString* = 256;  (* Length(string constant)<maxSizeString *)
  maxSizeIdent* = 48;    (* Length(identifier)<maxSizeIdent *)
  (* MIN/MAX values of the standard data types *)
  minBool* = 0;             maxBool* = 1;
  minChar* = 0;             maxChar* = 0FFH;
  minSInt* = -80H;          maxSInt* = 07FH;
  minInt*  = -8000H;        maxInt*  = 07FFFH;
  minLInt* = -7FFFFFFFH-1;  maxLInt* = 07FFFFFFFH;
  minReal* = MIN(REAL);     maxReal* = MAX(REAL);      (* defined in _OGCC.h *)
  minLReal*= MIN(LONGREAL); maxLReal*= MAX(LONGREAL);  (* defined in _OGCC.h *)
  minSet*  = 0;             maxSet*  = 31;
  (* index range for PUTREG, GETREG, CC and HALT: *)
  minRegNum*=0; maxRegNum*=-1;           (* disabled *)
  minCC*=0; maxCC*=-1;                   (* disabled *)
  minTrapNum*=1; maxTrapNum*=255;
  defAssertTrap*=1;                      (* default trap for ASSERT(x) *)

CONST
  (* file extensions *)
  moduleExtension*     = "Mod";          (* module files *)
  symbolExtension*     = "OSym";         (* symbol files *)

CONST
  (* enable parsing of EXTERNAL modules *)
  allowExternal* = TRUE;
  (* allow underscore to be used in identifiers declared EXTERNAL *)
  allowUnderscore* = TRUE;
  (* allow 'rest parameter ..' in EXTERNAL modules *)
  allowRestParam* = TRUE;
  (* allow use of UNION type in EXTERNAL modules *)
  allowUnion* = TRUE;
  
VAR
  redir* : Redir.Pattern;
  noGC* : BOOLEAN;
    (* TRUE iff the system under which the compiler is running does not
       provide a garbage collector (default: FALSE). *)

BEGIN
  noGC := FALSE
END OMachine.
