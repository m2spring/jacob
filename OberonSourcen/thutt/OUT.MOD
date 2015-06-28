MODULE Out;	
(* Stream-oriented text output, page 89, 98,310 *)IMPORT Texts, Oberon, MenuViewers, TextFrames;VAR	T: Texts.Text;  (* output text *)	S: Texts.Scanner;  W: Texts.Writer;PROCEDURE Open*;VAR  	x, y: INTEGER;  	menuF, mainF: TextFrames.Frame; 	V: MenuViewers.Viewer;BEGIN	T := TextFrames.Text("Out.Text");  	menuF := TextFrames.NewMenu("Out.Text", 					"System.Close System.Copy System.Grow Edit.Search Edit.Store");	mainF := TextFrames.NewText(T, T.len - 200); 	Oberon.AllocateUserViewer(Oberon.Mouse.X, x, y);	V := MenuViewers.New(menuF, mainF, TextFrames.menuH, x, y)END Open;PROCEDURE Char*(ch: CHAR);BEGIN Texts.Write(W, ch);  Texts.Append(T, W.buf)
END Char;PROCEDURE String*(str: ARRAY OF CHAR);BEGIN Texts.WriteString(W, str);  Texts.Append(T, W.buf)
END String;PROCEDURE Real*(x: REAL; n: INTEGER);BEGIN Texts.WriteReal(W, x, n);  Texts.Append(T, W.buf)
END Real;PROCEDURE Int*(i, n: LONGINT);BEGIN Texts.WriteInt(W, i, n);  Texts.Append(T, W.buf)
END Int;
PROCEDURE Set*(s: SET);
VAR i, j: INTEGER; notfirst: BOOLEAN;
BEGIN i := 0; notfirst := FALSE; Char("{");
	WHILE i <= MAX(SET) DO
		IF i IN s THEN
			IF notfirst THEN String(", ")
			ELSE notfirst := TRUE
			END ;
			j := i; Int(i, 1); INC(i);
			WHILE (i <= MAX(SET)) & (i IN s) DO INC(i) END ;
			IF i-1 > j THEN
				IF i-2 = j THEN String(", ") ELSE String("..") END ;
				Int(i-1, 1)
			END
		END ;
		INC(i)
	END ;
	Char("}");
END Set;

PROCEDURE Boolean*(b : BOOLEAN);
BEGIN
	IF b THEN Texts.WriteString(W, "TRUE");
	ELSE Texts.WriteString(W, "FALSE");
	END;
END Boolean;
PROCEDURE Ln*;BEGIN  	Texts.WriteLn(W);  Texts.Append(T, W.buf)END Ln;BEGIN Texts.OpenWriter(W);  T := Oberon.Log
END Out.	(* Copyright M. Reiser, 1992 *)