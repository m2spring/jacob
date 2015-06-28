DEFINITION MODULE STR;
(*
 * Provides various string manipulation functions.
 *)

(************************************************************************************************************************)
PROCEDURE Compare(s1,s2 : ARRAY OF CHAR) : INTEGER;
(*
 * s1 < s2 --> -1
 * s1 = s2 -->  0
 * s1 > s2 --> +1
 *)

PROCEDURE Length(VAR s : ARRAY OF CHAR) : CARDINAL;
(*
 * Returns length of string.
 *)

PROCEDURE Concat(VAR r : ARRAY OF CHAR; s1,s2 : ARRAY OF CHAR);
(*
 * Concatenates s1 and s2 to r.
 *)

PROCEDURE Append(VAR r : ARRAY OF CHAR; s : ARRAY OF CHAR);
(*
 * Append s to r.
 *)

PROCEDURE Copy(VAR r : ARRAY OF CHAR; s : ARRAY OF CHAR);
(*
 * Copies s to r.
 *)

PROCEDURE Slice(VAR r : ARRAY OF CHAR; s : ARRAY OF CHAR; p,l : CARDINAL);
(*
 * Extracts l characters from s starting from position p to r.
 *)

PROCEDURE Pos(s,p : ARRAY OF CHAR) : CARDINAL;
(*
 * Returns the first position of p in s. Not found --> MAX(CARDINAL).
 *)

PROCEDURE Prepend(VAR s1 : ARRAY OF CHAR; s2 : ARRAY OF CHAR);
(*
 * Prefixes s2 to s1.
 *)

PROCEDURE Insert(VAR r : ARRAY OF CHAR; s : ARRAY OF CHAR; p : CARDINAL);
(*
 * Inserts s in r at position p.
 *)

PROCEDURE Delete(VAR r : ARRAY OF CHAR; p,l : CARDINAL);
(*
 * Deletes l characters in r starting at position p.
 *)

PROCEDURE DoString(VAR s : ARRAY OF CHAR; Len : CARDINAL; c : CHAR);
(*
 * Creates a string of length Len, only of characters c.
 *)

PROCEDURE DoRept(VAR s : ARRAY OF CHAR; Len : CARDINAL; t : ARRAY OF CHAR);
(*
 * Similiar to DoString.
 *)

PROCEDURE DoFillLb(VAR s : ARRAY OF CHAR; Len : CARDINAL; c : CHAR);
(*
 * s left justified to Len, filled up with c.
 *)

PROCEDURE DoFillRb(VAR s : ARRAY OF CHAR; Len : CARDINAL; c : CHAR);
(*
 * s right justified to Len, filled up with c.
 *)

PROCEDURE DoFillMb(VAR s : ARRAY OF CHAR; Len : CARDINAL; c : CHAR);
(*
 * s centered to Len, filled up with c.
 *)

PROCEDURE DoLb(VAR s : ARRAY OF CHAR; Len : CARDINAL);
(*
 * s left justified to Len, filled up with blanks.
 *)

PROCEDURE DoRb(VAR s : ARRAY OF CHAR; Len : CARDINAL);
(*
 * s right justified to Len, filled up with blanks.
 *)

PROCEDURE DoMb(VAR s : ARRAY OF CHAR; Len : CARDINAL);
(*
 * s centered to Len, filled up with blanks.
 *)

PROCEDURE DoCaps(VAR s : ARRAY OF CHAR);
(*
 * Capitalizes s.
 *)

PROCEDURE DoCapsChar(VAR c : CHAR);
(*
 * c := CAP(c)
 *)

PROCEDURE DoUncaps(VAR s : ARRAY OF CHAR);
(*
 * Uncapitalizes s.
 *)

PROCEDURE DoUncapsChar(VAR c : CHAR);
(*
 * Uncapitalizes c.
 *)

PROCEDURE UNCAP(c : CHAR) : CHAR;
(*
 * Returns c uncapitalized.
 *)

PROCEDURE DoKillSpaces(VAR s : ARRAY OF CHAR);
(*
 * Deletes all blanks from s.
 *)

PROCEDURE DoKillLeadingSpaces(VAR s : ARRAY OF CHAR);
(*
 * Deletes all leading blanks from s.
 *)

PROCEDURE DoKillTrailingSpaces(VAR s : ARRAY OF CHAR);
(*
 * Deletes all trailing spaces from s.
 *)

PROCEDURE DoKillLeadTrailSpaces(VAR s : ARRAY OF CHAR);
(*
 * Deletes all leading & trailing spaces from s.
 *)

PROCEDURE InsertBlanks(VAR s : ARRAY OF CHAR);
(*
 * Inserts a blank between any two character of s.
 *)

PROCEDURE Conc1(VAR s : ARRAY OF CHAR; s1 : ARRAY OF CHAR);
(*
 * Copies s1 to s.
 *)

PROCEDURE Conc2(VAR s : ARRAY OF CHAR; s1, s2 : ARRAY OF CHAR);
(*
 * Concatenates s1 and s2 to s.
 *)

PROCEDURE Conc3(VAR s : ARRAY OF CHAR; s1, s2, s3 : ARRAY OF CHAR);
(*
 * ...
 *)

PROCEDURE Conc4(VAR s : ARRAY OF CHAR; s1, s2, s3, s4 : ARRAY OF CHAR);
(*
 * ...
 *)

PROCEDURE Conc5(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5 : ARRAY OF CHAR);
(*
 * ...
 *)

PROCEDURE Conc6(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5, s6 : ARRAY OF CHAR);
(*
 * ...
 *)

PROCEDURE Conc7(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5, s6, s7 : ARRAY OF CHAR);
(*
 * ...
 *)

PROCEDURE Conc8(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5, s6, s7, s8 : ARRAY OF CHAR);
(*
 * ...
 *)

PROCEDURE Conc9(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5, s6, s7, s8, s9 : ARRAY OF CHAR);
(*
 * ...
 *)

PROCEDURE Conc10(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5, s6, s7, s8, s9, s10 : ARRAY OF CHAR);
(*
 * ...
 *)

PROCEDURE App1(VAR s : ARRAY OF CHAR; s1 : ARRAY OF CHAR);
(*
 * Appends s1 to s.
 *)

PROCEDURE App2(VAR s : ARRAY OF CHAR; s1, s2 : ARRAY OF CHAR);
(*
 * Appends s1 and s2 to s.
 *)

PROCEDURE App3(VAR s : ARRAY OF CHAR; s1, s2, s3 : ARRAY OF CHAR);
(*
 * ...
 *)

PROCEDURE App4(VAR s : ARRAY OF CHAR; s1, s2, s3, s4 : ARRAY OF CHAR);
(*
 * ...
 *)

PROCEDURE App5(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5 : ARRAY OF CHAR);
(*
 * ...
 *)

PROCEDURE App6(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5, s6 : ARRAY OF CHAR);
(*
 * ...
 *)

PROCEDURE App7(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5, s6, s7 : ARRAY OF CHAR);
(*
 * ...
 *)

PROCEDURE App8(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5, s6, s7, s8 : ARRAY OF CHAR);
(*
 * ...
 *)

PROCEDURE App9(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5, s6, s7, s8, s9 : ARRAY OF CHAR);
(*
 * ...
 *)

PROCEDURE App10(VAR s : ARRAY OF CHAR; s1, s2, s3, s4, s5, s6, s7, s8, s9, s10 : ARRAY OF CHAR);
(*
 * ...
 *)

PROCEDURE IsCapsedStr(s : ARRAY OF CHAR) : BOOLEAN;
(*
 * Returns TRUE, if all characters of s are in ['A'..'B']
 *)

PROCEDURE HasPrefix(s, p : ARRAY OF CHAR) : BOOLEAN;
(*
 * Returns TRUE, if s has the prefix p.
 *)

PROCEDURE Reverse(VAR s : ARRAY OF CHAR);
(*
 * Reverses s.
 *)

PROCEDURE StrCard(VAR s : ARRAY OF CHAR; val : CARDINAL);
(*
 * Converts val to s.
 *)

PROCEDURE StrNum(VAR s : ARRAY OF CHAR; val : CARDINAL; width : CARDINAL);
(*
 * Converts val to s, right justified to width, filled up with '0's.
 * If the textual representation of val is longer than width, the output is width '*'s.
 *)

PROCEDURE CardVal(s : ARRAY OF CHAR) : CARDINAL; 
(*
 * Returns the value of the decimal representation in s.
 *)

(************************************************************************************************************************)
(*
 * A simple data type for dynamic strings
 *)

TYPE tStr = POINTER TO ARRAY [0..500] OF CHAR; 

PROCEDURE Alloc(s : ARRAY OF CHAR) : tStr; 
(*
 * Returns address of the duplicated string s
 * (Result^ is always 0 terminated)
 *)
 
PROCEDURE Dup(s : tStr) : tStr;
(*
 * Returns address of the duplicated string s^
 * (Result^ is always 0 terminated)
 *)

PROCEDURE Free(VAR s : tStr);
(*
 * Deallocates the allocated string to which s points
 *)

PROCEDURE AppS(s : tStr; t : ARRAY OF CHAR) : tStr;  
(*
 * Returns address of the concatenation of s^ and t
 * (Result^ is always 0 terminated)
 *)

PROCEDURE AppendS(VAR s : tStr; t : ARRAY OF CHAR);  
(*
 * Extends the allocated string s^ by t
 *)

(************************************************************************************************************************)
END STR.

