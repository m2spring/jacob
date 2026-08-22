MODULE Eliza;
(* A compact reimplementation of Joseph Weizenbaum's 1966 ELIZA program
   (the "DOCTOR" script): a keyword/decomposition-and-reassembly pattern
   matcher that mimics a Rogerian psychotherapist. It has no understanding
   of what you type -- it just recognizes a handful of keywords, reflects
   the pronouns in the words that follow them ("I" <-> "YOU", "MY" <->
   "YOUR", "AM" <-> "ARE", ...), and slots the result into one of a few
   canned templates per keyword. Type BYE, QUIT, or EXIT to leave. *)

IMPORT Out, In, Str, Lib;

CONST
  MaxLine  = 256;
  MaxWord  = 32;
  MaxWords = 40;

VAR
  words   : ARRAY MaxWords, MaxWord OF CHAR;
  nWords  : LONGINT;
  running : BOOLEAN;
  line    : ARRAY MaxLine OF CHAR;
  reply   : ARRAY MaxLine OF CHAR;

(* ---------------------------------------------------------------- *)
(* small string helpers -- Str has no tokenizer or substring search *)
(* ---------------------------------------------------------------- *)

PROCEDURE IsSpace(c: CHAR): BOOLEAN;
BEGIN
  RETURN (c = ' ') OR (c = 9X)
END IsSpace;

PROCEDURE IsPunct(c: CHAR): BOOLEAN;
BEGIN
  RETURN (c='.') OR (c=',') OR (c='!') OR (c='?') OR (c=';') OR (c=':')
END IsPunct;

PROCEDURE Eq(a, b: ARRAY OF CHAR): BOOLEAN;
VAR i: LONGINT;
BEGIN
  i := 0;
  LOOP
    IF a[i] # b[i] THEN RETURN FALSE END;
    IF a[i] = 0X THEN RETURN TRUE END;
    INC(i)
  END
END Eq;

PROCEDURE Split(VAR s: ARRAY OF CHAR);
VAR i, j: LONGINT;
BEGIN
  nWords := 0; i := 0;
  LOOP
    WHILE IsSpace(s[i]) DO INC(i) END;
    IF (s[i] = 0X) OR (nWords >= MaxWords) THEN EXIT END;
    j := 0;
    WHILE (s[i] # 0X) & ~IsSpace(s[i]) DO
      IF j < MaxWord-1 THEN words[nWords, j] := s[i]; INC(j) END;
      INC(i)
    END;
    WHILE (j > 0) & IsPunct(words[nWords, j-1]) DO DEC(j) END;
    words[nWords, j] := 0X;
    INC(nWords)
  END
END Split;

PROCEDURE Find(w: ARRAY OF CHAR): LONGINT;
VAR i: LONGINT;
BEGIN
  FOR i := 0 TO nWords-1 DO
    IF Eq(words[i], w) THEN RETURN i END
  END;
  RETURN -1
END Find;

PROCEDURE FindPair(w1, w2: ARRAY OF CHAR): LONGINT;
VAR i: LONGINT;
BEGIN
  IF nWords < 2 THEN RETURN -1 END;
  FOR i := 0 TO nWords-2 DO
    IF Eq(words[i], w1) & Eq(words[i+1], w2) THEN RETURN i END
  END;
  RETURN -1
END FindPair;

(* ---------------------------------------------------------------- *)
(* pronoun reflection, applied word by word to the remainder of a   *)
(* sentence after a matched keyword, e.g. "I NEED a vacation" ->    *)
(* "YOU NEED a vacation" for "WHY DO YOU NEED...?"                  *)
(* ---------------------------------------------------------------- *)

PROCEDURE ReflectWord(VAR w: ARRAY OF CHAR);
BEGIN
  IF    Eq(w, "I")        THEN w[0]:=0X; Str.Append(w, "YOU")
  ELSIF Eq(w, "ME")       THEN w[0]:=0X; Str.Append(w, "YOU")
  ELSIF Eq(w, "MY")       THEN w[0]:=0X; Str.Append(w, "YOUR")
  ELSIF Eq(w, "MYSELF")   THEN w[0]:=0X; Str.Append(w, "YOURSELF")
  ELSIF Eq(w, "MINE")     THEN w[0]:=0X; Str.Append(w, "YOURS")
  ELSIF Eq(w, "YOU")      THEN w[0]:=0X; Str.Append(w, "I")
  ELSIF Eq(w, "YOUR")     THEN w[0]:=0X; Str.Append(w, "MY")
  ELSIF Eq(w, "YOURS")    THEN w[0]:=0X; Str.Append(w, "MINE")
  ELSIF Eq(w, "YOURSELF") THEN w[0]:=0X; Str.Append(w, "MYSELF")
  ELSIF Eq(w, "AM")       THEN w[0]:=0X; Str.Append(w, "ARE")
  ELSIF Eq(w, "ARE")      THEN w[0]:=0X; Str.Append(w, "AM")
  ELSIF Eq(w, "WAS")      THEN w[0]:=0X; Str.Append(w, "WERE")
  ELSIF Eq(w, "WERE")     THEN w[0]:=0X; Str.Append(w, "WAS")
  END
END ReflectWord;

PROCEDURE ReflectRemainder(fromIdx: LONGINT; VAR result: ARRAY OF CHAR);
VAR i: LONGINT;
BEGIN
  result[0] := 0X;
  IF fromIdx >= nWords THEN RETURN END;
  FOR i := fromIdx TO nWords-1 DO
    ReflectWord(words[i]);
    IF i > fromIdx THEN Str.Append(result, " ") END;
    Str.Append(result, words[i])
  END
END ReflectRemainder;

PROCEDURE Pick(n: LONGINT): INTEGER;
BEGIN
  RETURN SHORT(Lib.RANDOM(n))
END Pick;

(* ---------------------------------------------------------------- *)
(* the DOCTOR: a fixed keyword search order, each with a small pool *)
(* of templates, falling back to content-free prompts if nothing    *)
(* matches -- Weizenbaum's original technique, with a much smaller  *)
(* script than the real DOCTOR.                                     *)
(* ---------------------------------------------------------------- *)

PROCEDURE Respond(VAR out: ARRAY OF CHAR): BOOLEAN;
VAR i: LONGINT; rest: ARRAY MaxLine OF CHAR;
BEGIN
  out[0] := 0X;

  IF (Find("BYE") >= 0) OR (Find("QUIT") >= 0) OR (Find("EXIT") >= 0) THEN
    Str.Append(out, "GOODBYE. IT WAS NICE TALKING TO YOU.");
    running := FALSE;
    RETURN TRUE
  END;

  IF (Find("COMPUTER") >= 0) OR (Find("COMPUTERS") >= 0)
   OR (Find("MACHINE") >= 0) OR (Find("MACHINES") >= 0) THEN
    CASE Pick(3) OF
      0: Str.Append(out, "DO COMPUTERS WORRY YOU?")
    | 1: Str.Append(out, "WHY DO YOU MENTION COMPUTERS?")
    | 2: Str.Append(out, "DO YOU THINK MACHINES CAN UNDERSTAND YOU?")
    END;
    RETURN TRUE
  END;

  IF (Find("MOTHER") >= 0) OR (Find("FATHER") >= 0)
   OR (Find("MOM") >= 0) OR (Find("DAD") >= 0)
   OR (Find("PARENTS") >= 0) OR (Find("FAMILY") >= 0) THEN
    CASE Pick(3) OF
      0: Str.Append(out, "TELL ME MORE ABOUT YOUR FAMILY.")
    | 1: Str.Append(out, "WHO ELSE IN YOUR FAMILY IS INVOLVED?")
    | 2: Str.Append(out, "DOES THAT HAVE SOMETHING TO DO WITH YOUR FAMILY?")
    END;
    RETURN TRUE
  END;

  IF (Find("DREAM") >= 0) OR (Find("DREAMS") >= 0)
   OR (Find("DREAMT") >= 0) OR (Find("DREAMED") >= 0) THEN
    CASE Pick(3) OF
      0: Str.Append(out, "WHAT DOES THAT DREAM SUGGEST TO YOU?")
    | 1: Str.Append(out, "DO YOU DREAM OFTEN?")
    | 2: Str.Append(out, "WHAT PERSONS APPEAR IN YOUR DREAMS?")
    END;
    RETURN TRUE
  END;

  IF Find("SORRY") >= 0 THEN
    CASE Pick(2) OF
      0: Str.Append(out, "PLEASE DON'T APOLOGIZE.")
    | 1: Str.Append(out, "APOLOGIES ARE NOT NECESSARY.")
    END;
    RETURN TRUE
  END;

  i := FindPair("I", "REMEMBER");
  IF i >= 0 THEN
    ReflectRemainder(i+2, rest);
    Str.Append(out, "DO YOU OFTEN THINK OF ");
    Str.Append(out, rest);
    Str.Append(out, "?");
    RETURN TRUE
  END;

  i := Find("FEEL");
  IF i < 0 THEN i := Find("FEELS") END;
  IF i < 0 THEN i := Find("FEELING") END;
  IF i >= 0 THEN
    ReflectRemainder(i+1, rest);
    IF Str.Length(rest) > 0 THEN
      Str.Append(out, "DO YOU OFTEN FEEL ");
      Str.Append(out, rest);
      Str.Append(out, "?")
    ELSE
      Str.Append(out, "TELL ME MORE ABOUT SUCH FEELINGS.")
    END;
    RETURN TRUE
  END;

  i := FindPair("I", "NEED");
  IF i >= 0 THEN
    ReflectRemainder(i+2, rest);
    Str.Append(out, "WHY DO YOU NEED ");
    Str.Append(out, rest);
    Str.Append(out, "?");
    RETURN TRUE
  END;

  i := FindPair("I", "WANT");
  IF i >= 0 THEN
    ReflectRemainder(i+2, rest);
    Str.Append(out, "WHAT WOULD IT MEAN TO YOU IF YOU GOT ");
    Str.Append(out, rest);
    Str.Append(out, "?");
    RETURN TRUE
  END;

  i := FindPair("I", "AM");
  IF i >= 0 THEN
    ReflectRemainder(i+2, rest);
    CASE Pick(2) OF
      0: Str.Append(out, "HOW LONG HAVE YOU BEEN ")
    | 1: Str.Append(out, "DO YOU BELIEVE IT IS NORMAL TO BE ")
    END;
    Str.Append(out, rest);
    Str.Append(out, "?");
    RETURN TRUE
  END;

  i := FindPair("YOU", "ARE");
  IF i >= 0 THEN
    ReflectRemainder(i+2, rest);
    Str.Append(out, "WHAT MAKES YOU THINK I AM ");
    Str.Append(out, rest);
    Str.Append(out, "?");
    RETURN TRUE
  END;

  IF Find("BECAUSE") >= 0 THEN
    CASE Pick(2) OF
      0: Str.Append(out, "IS THAT THE REAL REASON?")
    | 1: Str.Append(out, "WHAT OTHER REASON MIGHT THERE BE?")
    END;
    RETURN TRUE
  END;

  IF (Find("ALIKE") >= 0) OR (Find("SAME") >= 0) THEN
    Str.Append(out, "IN WHAT WAY?");
    RETURN TRUE
  END;

  IF Find("ALWAYS") >= 0 THEN
    Str.Append(out, "CAN YOU THINK OF A SPECIFIC EXAMPLE?");
    RETURN TRUE
  END;

  IF Find("NO") >= 0 THEN
    CASE Pick(2) OF
      0: Str.Append(out, "WHY NOT?")
    | 1: Str.Append(out, "YOU ARE BEING A BIT NEGATIVE.")
    END;
    RETURN TRUE
  END;

  IF Find("YES") >= 0 THEN
    CASE Pick(2) OF
      0: Str.Append(out, "YOU SEEM QUITE POSITIVE.")
    | 1: Str.Append(out, "I SEE.")
    END;
    RETURN TRUE
  END;

  RETURN FALSE
END Respond;

PROCEDURE Fallback(VAR out: ARRAY OF CHAR);
BEGIN
  out[0] := 0X;
  CASE Pick(6) OF
    0: Str.Append(out, "PLEASE GO ON.")
  | 1: Str.Append(out, "TELL ME MORE.")
  | 2: Str.Append(out, "I SEE.")
  | 3: Str.Append(out, "WHY DO YOU SAY THAT?")
  | 4: Str.Append(out, "HOW DOES THAT MAKE YOU FEEL?")
  | 5: Str.Append(out, "WHAT DOES THAT SUGGEST TO YOU?")
  END
END Fallback;

(* ---------------------------------------------------------------- *)

PROCEDURE ReadLine(VAR s: ARRAY OF CHAR): BOOLEAN;
BEGIN
  In.String(s);
  RETURN In.Done OR (Str.Length(s) > 0)
END ReadLine;

BEGIN
  Lib.RANDOMIZE;
  running := TRUE;
  Out.StrLn("HELLO, I AM ELIZA. HOW ARE YOU FEELING TODAY?");
  WHILE running DO
    Out.String("> ");
    IF ~ReadLine(line) THEN
      Out.Ln; Out.StrLn("GOODBYE. IT WAS NICE TALKING TO YOU.");
      running := FALSE
    ELSE
      Str.Caps(line);
      Split(line);
      IF ~Respond(reply) THEN Fallback(reply) END;
      Out.StrLn(reply)
    END
  END
END Eliza.
