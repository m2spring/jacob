(*
The following is a simple implementation of regular expressions in Oberon-1
It was developed and compiled using pOt and is very poorly tested.

The syntax is the same as for egrep, except that grouping pars are not quoted with \.

Compile builds internal representation from the source expression,
Exec finds it in a Text and put results into a structure that contains
a boolean field for the answer as well as table of origins and ends of
all subexpressions -- the 0'th subexpressions is the whole expression.

Dump outputs compiled expression in a printable form.

Comments and suggestions are accepted at dvd@pizza.msk.su.
*)
(*$Id: Regexp.mod,v 1.10 1995/01/28 14:29:21 dvd Exp $*)
MODULE Regexp;
	(* This code is derived from one written by Henry Spencer at
		University of Toronto. *)
	IMPORT Texts;

	CONST
		NL = 0AX; (* change this if you are Oberon System or Mac user *)

		maxSubExp = 10; maxLtrlLen = 15;

		bol = 0;	eol = 1;
		any = 2; anyof = 3; anybut = 4;
		branch = 5; back = 6;
		exactly = 7; nothing = 8;
		open = 9; close = 10;

		error = 11;

		ErrUnexp = 0;
		ErrSERange = 1; ErrSEMatch = 2;
		ErrSPEmptyArg = 3; ErrSPNested = 4;
		ErrAnyRange = 5; ErrAnyMatch = 6;
		ErrEscEmptyArg = 7;
		ErrAnch = 8;

		haswidth = 0; spstart = 1;

	TYPE
		Node = POINTER TO NodeDesc; (* bol eol any nothing  start end *)
		NodeDesc = RECORD
			opcode: SHORTINT;
			next: Node
		END;
		Literal = POINTER TO LiteralDesc; (* exactly *)
		LiteralDesc = RECORD(NodeDesc)
			ltrl: ARRAY maxLtrlLen+1 OF CHAR
		END;
		Set = POINTER TO SetDesc; (* anyof anybut *)
		SetDesc = RECORD(NodeDesc)
			chars: ARRAY 8 OF SET (*256 DIV 32*)
		END;
		Fork = POINTER TO ForkDesc; (* branch *)
		ForkDesc = RECORD(NodeDesc)
			down: Node
		END;
		Marker = POINTER TO MarkerDesc; (* open close *)
		MarkerDesc = RECORD(NodeDesc)
			lvl: SHORTINT
		END;
		Error = POINTER TO ErrDesc; (* error *)
		ErrDesc = RECORD(NodeDesc)
			pos: LONGINT;
			num: INTEGER
		END;
	
		Program* = RECORD
			code: Node;
			anch: BOOLEAN;
			inich: CHAR;
			lit: Literal; (* pointer to the longest literal that must appear in the expr *)
			kmp: ARRAY maxLtrlLen + 1 OF INTEGER (* kmp jump table *)
		END;

		REsult* = RECORD
			found*: BOOLEAN;
			se*: ARRAY maxSubExp OF RECORD from*, till*: LONGINT END
		END;
			
	PROCEDURE Compile*(regex: ARRAY OF CHAR; VAR prog: Program);
		
		VAR pos, length: LONGINT; N: Node; errlist: Error; nSubExp: SHORTINT;
			Lflags: SET;

		PROCEDURE Init();
			VAR N: Node;
		BEGIN prog.code := NIL;
			pos := 0; errlist := NIL; nSubExp := 0;
			length := 0; WHILE regex[length] # 0X DO INC(length) END
		END Init;

		PROCEDURE Opti();
			VAR N: Node; maxlen, curlen: INTEGER;

			PROCEDURE KMPCompile(len: INTEGER; VAR lit: ARRAY OF CHAR; VAR kmp: ARRAY OF INTEGER);
				VAR j,k: INTEGER;
			BEGIN j := 0; k := -1; kmp[0] := -1;
				WHILE j # len - 1 DO (* 'not equal' is valid here because the length cannot be 0 *)
					WHILE (k >= 0) & (lit[j] # lit[k]) DO k := kmp[k] END;
					INC(j); INC(k);
					IF lit[j] = lit[k] THEN kmp[j] := kmp[k] 
					ELSE kmp[j] := k
					END
				END
			END KMPCompile;

		BEGIN prog.anch := FALSE; prog.inich := 0X; prog.lit := NIL;
			N := prog.code.next; (* first branch *)
			IF (N.next.opcode = close) & (N.next(Marker).lvl = 0) THEN
				N := N(Fork).down;
				IF N.opcode = exactly THEN prog.inich := N(Literal).ltrl[0]
				ELSIF N.opcode = bol THEN prog.anch := TRUE
				END;
				maxlen := 1; (* exact matches of length 1 aren't considered *)
				WHILE N # NIL DO
					IF N.opcode = exactly THEN
						WITH N: Literal DO
							curlen := 0;
							WHILE N.ltrl[curlen] # 0X DO INC(curlen) END;
							IF curlen > maxlen THEN prog.lit := N; maxlen := curlen END
						END
					END;
					N := N.next
				END;
				IF prog.lit # NIL THEN KMPCompile(maxlen, prog.lit.ltrl, prog.kmp) END
			END
		END Opti;

		PROCEDURE Emit(VAR last: Node; N: Node);
		BEGIN
			IF last = NIL THEN last := N
			ELSE WHILE last.next # NIL DO last := last.next END; last.next := N; last := N
			END
		END Emit;

		PROCEDURE Attach(F: Fork; N: Node);
			VAR n: Node;
		BEGIN
			IF F.down = NIL THEN F.down := N
			ELSE n := F.down; WHILE n.next # NIL DO n := n.next END; n.next := N
			END
		END Attach;

		PROCEDURE Mark(num: INTEGER);
			VAR E: Error;
		BEGIN
			IF (errlist = NIL) OR (errlist.pos + 3 < pos) THEN
				NEW(E); E.opcode := error;
				E.pos := pos; E.num := num;
				E.next := errlist; errlist := E
			END
		END Mark;

		PROCEDURE Expr(VAR N: Node; VAR Gflags: SET);
			
			VAR M: Marker; last, Br: Node; level: SHORTINT;
				Lflags: SET;

			PROCEDURE Branch(VAR N: Node; VAR Gflags: SET);

				VAR Br: Fork; last, P: Node; isFirst: BOOLEAN;
					Lflags: SET;

				PROCEDURE Piece(VAR N: Node; VAR Gflags: SET);

					VAR P, P1: Fork; last, A, A1: Node;
						Lflags: SET;
						op: CHAR;

					PROCEDURE Atom(VAR N: Node; VAR Gflags: SET);
						VAR op, ch: CHAR; ic, cc: INTEGER;
							S: Set; L: Literal;
							i: INTEGER; till: LONGINT;

					BEGIN Gflags := {};
						op := regex[pos]; INC(pos);
						CASE op OF "^": NEW(N); N.opcode := bol; N.next := NIL; 
							IF pos # 1 THEN Mark(ErrAnch) END
						| "$": NEW(N); N.opcode := eol; N.next := NIL;
							IF pos # length THEN Mark(ErrAnch) END
						| ".": NEW(N); N.opcode := any; N.next := NIL;
							INCL(Gflags, haswidth)
						| "[": NEW(S); N := S; N.next := NIL;
							IF regex[pos] = "^" THEN N.opcode := anybut; INC(pos)
							ELSE N.opcode := anyof
							END;
						 (* special processing fore leading [ and - *)
							IF (regex[pos] = "-") OR (regex[pos] = "]") THEN
								cc := ORD(regex[pos]); INC(pos);
								INCL(S.chars[cc DIV 32], cc MOD 32)
							END;
						 (* loop thru regular components or trailing - *)
						 	WHILE (pos # length) & (regex[pos] # "]") DO
								IF regex[pos] = "-" THEN (* may be the trailing one *)
									INC(pos);
									IF (pos = length) OR (regex[pos] = "]") THEN (* verbatim *)
										cc := ORD("-");
										INCL(S.chars[cc DIV 32], cc MOD 32)
									ELSE (* a range of characters *)
										ic := cc; (* lower margin *)
										cc := ORD(regex[pos]); INC(pos);
										IF ic >= cc THEN Mark(ErrAnyRange)
										ELSE
											WHILE ic # cc DO
												INC(ic);
												INCL(S.chars[ic DIV 32], ic MOD 32)
											END
									  END
									END
								ELSE cc := ORD(regex[pos]); INC(pos);
									INCL(S.chars[cc DIV 32], cc MOD 32)
								END
							END;
							IF regex[pos] # "]" THEN Mark(ErrAnyMatch)
							ELSE INC(pos)
							END;
							IF S.opcode = anybut THEN
								S.opcode := anyof;
								i := 0;
								WHILE i # 8 DO S.chars[i] := -S.chars[i]; INC(i) END
							END;
							INCL(Gflags, haswidth)
						| "(":
							Expr(N, Lflags);
							IF regex[pos] # ")" THEN Mark(ErrSEMatch)
							ELSE INC(pos)
							END;
							Gflags := Lflags * {haswidth, spstart}
						| 0X: Mark(ErrUnexp);
							NEW(N); N.opcode := nothing; N.next := NIL
						| "|", ")": Mark(ErrUnexp);
							NEW(N); N.opcode := nothing; N.next := NIL;
							INC(pos)
						| "?", "+", "*": Mark(ErrSPEmptyArg);
							NEW(N); N.opcode := nothing; N.next := NIL;
							INC(pos)
						| "\":
							IF pos = length THEN Mark(ErrEscEmptyArg)
							ELSE NEW(L); N := L; N.next := NIL; L.opcode := exactly;
								L.ltrl[0] := regex[pos]; L.ltrl[1] := 0X;
								INC(pos)
							END
						ELSE
							NEW(L); N := L;  N.next := NIL; L.opcode := exactly;
							L.ltrl[0] := op; i := 1;
							till := pos;
							LOOP	
								IF till = length THEN EXIT END;
								ch := regex[till];
								CASE ch OF "^", "$", ".", "[", "(", ")", "|", "\": EXIT
								| "?", "+", "*": IF till # pos THEN DEC(till) END; EXIT
								ELSE INC(till)
								END
							END;
							IF pos + maxLtrlLen <= till THEN till := pos + maxLtrlLen - 1 END;
							WHILE pos # till DO
								L.ltrl[i] := regex[pos];
								INC(pos); INC(i)
							END;
							L.ltrl[i] := 0X;
							INCL(Gflags, haswidth)
						END
					END Atom;

				BEGIN Atom(A, Lflags);
					op := regex[pos];
					IF (op # "*") & (op # "+") & (op # "?") THEN
						N := A; Gflags := Lflags
					ELSIF ~(haswidth IN Lflags) & (op # "?") THEN
						Mark(ErrSPEmptyArg);
						N := A; Gflags := Lflags;
						INC(pos)
					ELSE
						IF op = "+" THEN Gflags := {haswidth}
						ELSE Gflags := {spstart}
						END;
						NEW(P); N := P; N.next := NIL;
						CASE op OF "*":
							P.opcode := branch;
							last := NIL;
							Attach(P, A); Emit(last, A); 
							NEW(A); A.opcode := back; A.next := NIL;
							Emit(last, A); Emit(last, P);
							NEW(P); P.opcode := branch; P.next := NIL; P.down := NIL;
							NEW(A); A.opcode := nothing; A.next := NIL;
							Emit(last, P); Emit(last, A); Attach(P, A);
						| "+":
							N := A; P.opcode := branch;
							last := NIL;
							NEW(A1); A1.opcode := back; A1.next := NIL;
							Emit(last, A); Emit(last, P); Attach(P, A1); Attach(P, A);
							NEW(P); P.opcode := branch; P.next := NIL; P.down := NIL;
							NEW(A); A.opcode := nothing; A.next := NIL;
							Emit(last, P); Emit(last, A); Attach(P, A)
						| "?":
							P.opcode := branch;
							last := NIL;
							Emit(last, P); Attach(P, A);
							NEW(P1); P1.opcode := branch; P1.next := NIL; P1.down := NIL;
							NEW(A); A.opcode := nothing; A.next := NIL;
							Emit(last, P1); Attach(P1, A); Attach(P, A); Emit(last, A)
						END;
						INC(pos);
						IF (regex[pos] = "*") OR (regex[pos] = "+") OR (regex[pos] = "?") THEN
							Mark(ErrSPNested); INC(pos)
						END;
					END
				END Piece;

			BEGIN Gflags := {};
				NEW(Br); N := Br;
				Br.opcode := branch; Br.next := NIL; Br.down := NIL;
				isFirst := TRUE; last := NIL;
				WHILE (regex[pos] # 0X) & (regex[pos] # "|") & (regex[pos] #")") DO
					Piece(P, Lflags);
					IF haswidth IN Lflags THEN INCL(Gflags, haswidth) END;
					IF isFirst THEN
						IF spstart IN Lflags THEN INCL(Gflags, spstart) END;
						Emit(last, P); Attach(Br, P); isFirst := FALSE
					ELSE Emit(last,P)
					END
				END;
			END Branch;

		BEGIN Gflags := {haswidth};
			IF nSubExp = maxSubExp THEN Mark(ErrSERange); level := -1
			ELSE level := nSubExp; INC(nSubExp)
			END;
			
		 (* open subexpr *)
			NEW(M); N := M;  (* this will be the subexpr *)
			M.opcode := open; M.next := NIL; M.lvl := level;

		 (* pick branches *)
			last := NIL; Emit(last, M);
			LOOP
				Branch(Br, Lflags);
				IF ~(haswidth IN Lflags) THEN EXCL(Gflags, haswidth) END;
				IF spstart IN Lflags THEN INCL(Gflags, spstart) END;
				Emit(last, Br);
				IF regex[pos] # "|" THEN EXIT END;
				INC(pos)
			END;
			Br := M.next;

		 (* close subexpr *)
			NEW(M);
			M.opcode := close; M.next := NIL; M.lvl := level;
			Emit(last, M);

		 (* link branches to the tail *)	
			REPEAT Attach(Br(Fork), M); Br := Br.next UNTIL M = Br;

		END Expr;

	BEGIN Init(); Expr(prog.code, Lflags); 
		IF pos # length THEN Mark(ErrUnexp) END;
		IF errlist # NIL THEN prog.code := errlist
		ELSE Opti()
		END
	END Compile;

	PROCEDURE Exec*(VAR prog: Program; T: Texts.Text; pos: LONGINT; VAR res: REsult);
		VAR R: Texts.Reader; bolpos: LONGINT;
			ch: CHAR; i, j: INTEGER;

		PROCEDURE Match(N: Node): BOOLEAN;
			VAR entrych: CHAR; entrypos: LONGINT; cc, ic: INTEGER;
		BEGIN entrypos := Texts.Pos(R); entrych := ch; ic := 0;
			LOOP
				IF R.eot OR (ch = NL) THEN bolpos := Texts.Pos(R); ch := NL END;
				IF N = NIL THEN res.found := TRUE; EXIT END;
				CASE N.opcode OF bol: N := N.next (* processed outside *)
				| eol: IF ch # NL THEN EXIT END; N := N.next
				| any: IF ch = NL THEN EXIT END; Texts.Read(R, ch); N := N.next
				| anyof, anybut: 
					cc := ORD(ch); 
					WITH N: Set DO
						IF ((cc MOD 32) IN N.chars[cc DIV 32]) = (N.opcode = anybut) THEN EXIT END
					END;
					Texts.Read(R, ch); N := N.next
				| branch: 
					REPEAT
						IF Match(N(Fork).down) THEN res.found := TRUE; EXIT END;
						N := N.next
					UNTIL (N.opcode # branch);
					EXIT
				| back: N := N.next (* nothing -- for re debugging only *)
				| exactly: 
					IF N(Literal).ltrl[ic] = 0X THEN ic := 0; N := N.next
					ELSIF N(Literal).ltrl[ic] # ch THEN EXIT
					ELSE INC(ic); Texts.Read(R, ch)
					END
				| nothing: N := N.next (* nothing -- was used to link together two branches *)
				| open: res.se[N(Marker).lvl].from := Texts.Pos(R)-1; N := N.next
				| close: res.se[N(Marker).lvl].till := Texts.Pos(R)-1; N := N.next;
				| error: EXIT
				END
			END;
			Texts.OpenReader(R,T,entrypos); ch := entrych;
			RETURN res.found
		END Match;

	BEGIN
		res.found := FALSE; 
		i := 0;
		WHILE i # maxSubExp DO res.se[i].from := 0; res.se[i].till := -1; INC(i) END;
		IF prog.anch THEN
			IF pos = 0 THEN Texts.OpenReader(R, T, pos); bolpos := 0
			ELSE Texts.OpenReader(R, T, pos-1);
				LOOP
					IF R.eot THEN RETURN END;
					Texts.Read(R, ch);
					IF ch = NL THEN bolpos := Texts.Pos(R); EXIT END
				END
			END
		ELSE Texts.OpenReader(R, T, pos); bolpos := pos
		END;
		LOOP
			IF prog.lit # NIL THEN
				j := 0;
				LOOP 
					IF R.eot THEN RETURN END;
					Texts.Read(R, ch); 
					IF ch = NL THEN bolpos := Texts.Pos(R); j := -1
					ELSE WHILE (j # -1) & (prog.lit.ltrl[j] # ch) DO j := prog.kmp[j] END;
					END;
					INC(j);
					IF prog.lit.ltrl[j] = 0X THEN
						Texts.OpenReader(R, T, bolpos);
						EXIT
					END
				END
			END;
			Texts.Read(R, ch);
			IF prog.anch THEN 
				IF Match(prog.code) THEN res.found := TRUE; RETURN
				ELSE
					LOOP
						IF R.eot THEN RETURN
						ELSIF ch = NL THEN bolpos := Texts.Pos(R); EXIT
						ELSE Texts.Read(R,ch)
						END
					END
				END
			ELSIF prog.inich # 0X THEN
				LOOP 
					IF R.eot THEN RETURN
					ELSIF ch = NL THEN bolpos := Texts.Pos(R); EXIT 
					ELSIF (ch = prog.inich) & Match(prog.code) THEN res.found := TRUE; RETURN 
					ELSE Texts.Read(R, ch)
					END
				END
			ELSE
				LOOP
					IF R.eot THEN RETURN
					ELSIF ch = NL THEN bolpos := Texts.Pos(R); EXIT
					ELSIF Match(prog.code) THEN res.found := TRUE; RETURN
					ELSE Texts.Read(R, ch)
					END
				END
			END
		END
	END Exec;

	PROCEDURE Dump*(W: Texts.Writer; prog: Program);

		PROCEDURE Print(N: Node; Indent: SHORTINT);
			VAR i: INTEGER;
		BEGIN
			i := 0; WHILE i # Indent DO Texts.Write(W, " "); INC(i) END;
			Texts.WriteString(W, "<");
			CASE N.opcode OF bol: Texts.WriteString(W, "BOL")
			|	eol: Texts.WriteString(W, "EOL")
			| any: Texts.WriteString(W, "ANY")
			| anyof, anybut:
				IF N.opcode = anyof THEN Texts.WriteString(W, "ANYOF ")
				ELSE Texts.WriteString(W, "ANYBUT ")
				END;
				WITH N: Set DO
					i := 0;
					WHILE i # 256 DO
						IF (i MOD 32) IN (N.chars[ i DIV 32]) THEN
							Texts.Write(W, CHR(i))
						END;
						INC(i)
					END
				END
			| branch: Texts.WriteString(W,"BRANCH")
			| back: Texts.WriteString(W, "BACK")
			| exactly: Texts.WriteString(W, "EXACTLY ");
				WITH N: Literal DO
					IF N.ltrl[1] = 0X THEN Texts.WriteHex(W, ORD(N.ltrl[0])); Texts.Write(W, "X")
					ELSE Texts.WriteString(W, N.ltrl)
					END
				END;
			| nothing: Texts.WriteString(W, "NOTHING")
			| open: Texts.WriteString(W, "OPEN ");
				Texts.WriteInt(W, N(Marker).lvl, 0)
			| close: Texts.WriteString(W, "CLOSE ");
				Texts.WriteInt(W, N(Marker).lvl, 0)
			| error: Texts.WriteString(W, "ERROR ");
				WITH N: Error DO
					Texts.WriteInt(W, N.num, 0);
					Texts.WriteString(W, " AT ");
					Texts.WriteInt(W, N.pos, 0)
				END
			ELSE Texts.WriteString(W, "UNKNOWN "); Texts.WriteInt(W, N.opcode, 0)
			END;
			Texts.WriteString(W, ">");
			Texts.WriteLn(W)
		END Print;

		PROCEDURE DumpTail(N: Node; Indent: SHORTINT);
		BEGIN 
			LOOP
				IF N = NIL THEN EXIT
				ELSIF N.opcode = back THEN Print(N, Indent); EXIT
				ELSIF N.opcode = branch THEN
					REPEAT
						Print(N, Indent);
						DumpTail(N(Fork).down, Indent+1);
						N := N.next
					UNTIL N.opcode # branch;
					EXIT
				ELSE
					IF (N.opcode = close) & (Indent # 0) THEN DEC(Indent) END;
					Print(N, Indent); IF N IS Fork THEN Print(N(Fork).down, Indent+1) END;
					IF N.opcode = open THEN INC(Indent) END;
					N := N.next
				END
			END
		END DumpTail;

	BEGIN DumpTail(prog.code, 0)
	END Dump;

END Regexp.
(*
$Log: Regexp.mod,v $
# Revision 1.10  1995/01/28  14:29:21  dvd
# Release
#
# Revision 1.6  1995/01/28  14:25:57  dvd
# IMPORT Files is removed
#
# Revision 1.5  1995/01/28  14:23:09  dvd
# Bugfix: looping when ch = inich
#
# Revision 1.4  1995/01/28  01:30:22  dvd
# Opti is called now.
#
# Revision 1.3  1995/01/28  00:59:47  dvd
# Presearch is used only if there is a sequence of length more than 1.
#
# Revision 1.2  1995/01/27  23:16:19  dvd
# The comment about Spencer is added.
#
# Revision 1.1  1995/01/27  23:03:48  dvd
# Initial revision
#
*)
