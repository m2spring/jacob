(* Original concept for this module was provided by Stefan Ludwig at ETH *)
MODULE Reverse;
IMPORT Texts;

CONST
	ReaderSize = 100; EOL = 0DX;

TYPE
	Reader* = RECORD (Texts.Reader)
		text : Texts.Text;
		bot- : BOOLEAN; (* is TRUE if at the beginning of the text *)
		actualpos, beginpos : LONGINT;  (* actualpos points to next char to be read *)
		backbuffer : ARRAY ReaderSize OF CHAR
	END;


(* First char read is pos -1 *)
PROCEDURE OpenReader*(VAR r : Reader; t : Texts.Text; pos : LONGINT);
VAR i : INTEGER;
BEGIN
	r.text := t;
	IF pos > t.len THEN pos := t.len; END;
	WITH r:Reader DO
		IF pos - ReaderSize < 0 THEN
			Texts.OpenReader (r, t, 0);
			r.actualpos := pos - 1;
			r.beginpos := 0
		ELSE
			Texts.OpenReader (r, t, pos - ReaderSize);
			r.actualpos := pos - 1;
			r.beginpos := pos - ReaderSize
		END;
		i := 0;
		WHILE i < ReaderSize DO Texts.Read(r, r.backbuffer [i]); INC(i) END;
		r.bot := r.actualpos < 0;
	END
END OpenReader;

PROCEDURE Read*(VAR r : Reader; VAR ch : CHAR);
BEGIN
	WITH r:Reader DO
		IF ~r.bot THEN
			IF r.actualpos < r.beginpos THEN OpenReader(r, r.text, r.actualpos + 1); END;
			ch := r.backbuffer[r.actualpos - r.beginpos];
			DEC (r.actualpos); r.bot := r.actualpos < 0;
		ELSE ch := 0X;
		END;
	ELSE ch := 0X;
	END;
END Read;

(* reader is left at end of previous line *)
PROCEDURE PreviousLine*(VAR r : Reader) : LONGINT;
VAR ch : CHAR;
BEGIN
	REPEAT Read(r, ch) UNTIL (ch = EOL) OR r.bot;
	IF r.bot THEN RETURN 0 ELSE RETURN r.actualpos+2 END
END PreviousLine;

(* Skips until EOL, Reader is after EOL. pos := pos + nbrCharRead
unused 940605 TWH
PROCEDURE NextLine(VAR R : Texts.Reader; VAR pos : LONGINT);
VAR ch : CHAR;
BEGIN REPEAT Texts.Read(R, ch); INC(pos) UNTIL (ch = EOL) OR R.eot;
END NextLine;
*)
END Reverse.
