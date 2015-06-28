DEFINITION MODULE ED; 
(*
 * Provides a text editor functionality, for simplier output formatting purposes.
 *)

IMPORT Idents     ,
       OT         ,
       SYSTEM     ;

TYPE   tCol       = SHORTCARD;
       tEditor    ;

PROCEDURE Create() : tEditor;
(*
 * Creates a new editor.
 *)

PROCEDURE Kill(VAR Editor : tEditor);
(*
 * Kills an existing editor.
 *)

PROCEDURE curCol(Editor : tEditor) : tCol;
(*
 * Yields the current cursor column.
 *)

PROCEDURE indCol(Editor : tEditor) : tCol;
(*
 * Yields the current indentation column.
 *)

PROCEDURE Text(Editor : tEditor; str : ARRAY OF CHAR);
(*
 * Inserts texts at the current cursor position.
 *)

PROCEDURE TextLn(Editor : tEditor; str : ARRAY OF CHAR);
(*
 * Inserts texts at the current cursor position and performs a new-line.
 *)

PROCEDURE CharRep(Editor : tEditor; c : CHAR; count : CARDINAL);
(*
 * Repeatedly inserts a character. 
 *)

PROCEDURE Line(Editor : tEditor);
(*
 * Inserts a separator line of 79 '-'s.
 *)

PROCEDURE Ident(Editor : tEditor; ident : Idents.tIdent);
(*
 * Inserts an identier.
 *)

PROCEDURE Boolean(Editor : tEditor; val : OT.oBOOLEAN);
(*
 * Inserts a boolean value.
 *)

PROCEDURE Char(Editor : tEditor; val : OT.oCHAR);
(*
 * Inserts a character.
 *)

PROCEDURE String(Editor : tEditor; val : OT.oSTRING);
(*
 * Inserts a string.
 *)

PROCEDURE Set(Editor : tEditor; val : OT.oSET);
(*
 * Inserts a set value.
 *)

PROCEDURE SetElems(Editor : tEditor; val : OT.oSET);
(*
 * Inserts the elements of a set value.
 *)

PROCEDURE Longint(Editor : tEditor; val : OT.oLONGINT);
(*
 * Inserts a longint.
 *)

PROCEDURE Num(Editor : tEditor; val : CARDINAL; width : CARDINAL);
(*
 * Inserts 'val' right justified with 'width', filled with '0'.
 *)

PROCEDURE Addr(Editor : tEditor; val : SYSTEM.ADDRESS);
(*
 * Inserts 'val' in hexadecimal representation.
 *)

PROCEDURE Real(Editor : tEditor; val : OT.oREAL);
(*
 * Inserts the decimal representation of 'val'.
 *)

PROCEDURE Longreal(Editor : tEditor; val : OT.oLONGREAL);
(*
 * Inserts the decimal representation of 'val'.
 *)

PROCEDURE CR(Editor : tEditor);
(*
 * Inserts a new line after the current and puts the cursor to the current indent column.
 *)

PROCEDURE Indent(Editor : tEditor; ind : tCol);
(*
 * Sets the new indentation column to the current indentation column + 'ind'.
 *)

PROCEDURE IndentCur(Editor : tEditor);
(*
 * Sets the new indentation column to the current cursor column.
 *)

PROCEDURE Undent(Editor : tEditor);
(*
 * Retrieves the last indentation column.
 *)

PROCEDURE SetTab(Editor : tEditor; tNum : SHORTCARD; col : tCol);
(*
 * Sets the tab 'tNum' to column 'col'.
 *)

PROCEDURE Home(Editor : tEditor);
(*
 * Moves the cursor to indentation column in the current line.
 *)

PROCEDURE Eol(Editor : tEditor);
(*
 * Moves the cursor to the end of the current line.
 *)

PROCEDURE Tab(Editor : tEditor; tNum : SHORTCARD);
(*
 * Moves the cursor to the 'tNum'th tab column.
 *)

PROCEDURE Dump(Editor : tEditor);
(*
 * Writes the current editor content to stdoutput.
 *)

END ED.

