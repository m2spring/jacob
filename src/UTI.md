DEFINITION MODULE UTI;
(*
 * Provides several utility procedures for different purposes.
 *)

IMPORT Idents,OB,StringMem,Strings,SysLib,SYSTEM;

PROCEDURE IdentOf(name : ARRAY OF CHAR) : Idents.tIdent;
(*
 * Creates an identifier from name.
 *)

PROCEDURE IdentLength(Ident : Idents.tIdent) : SHORTCARD;
(*
 * Returns the length of the textual representation of an identifier.
 *)

PROCEDURE MakeString(a : ARRAY OF CHAR) : StringMem.tStringRef;
(*
 * Guess!
 *)

PROCEDURE HexStr2Char(VAR s : Strings.tString; VAR OK : BOOLEAN) : CHAR;
(*
 * Returns the character with the hexadecimal represented ordinal value in s.
 * OK flags the success.
 *)

PROCEDURE Str2Longcard(VAR s : Strings.tString; VAR OK : BOOLEAN) : LONGCARD;
(*
 * Returns the value of the decimal representation in s.
 * OK <==> result < ABS(MIN(LONGINT)).
 *)

PROCEDURE HexStr2Longcard(VAR s : Strings.tString; VAR OK : BOOLEAN) : LONGCARD;
(*
 * Returns the value of the hexadecimal representation in s.
 * OK <==> Overflow.
 *)

PROCEDURE Str2Real(VAR s : Strings.tString; VAR OK : BOOLEAN) : LONGREAL;
(*
 * Returns the real value of the decimal representation in s.
 * OK flags the success.
 *)

PROCEDURE Str2Longreal(VAR s : Strings.tString; VAR OK : BOOLEAN) : LONGREAL;
(*
 * Returns the longreal value of the decimal representation in s.
 * OK flags the success.
 *)

PROCEDURE Longint2Arr(v : LONGINT; VAR s : ARRAY OF CHAR);
(*
 * Converts value v to decimal representation.
 *)

PROCEDURE Real2Arr(v : REAL; VAR s : ARRAY OF CHAR);
(*
 * Converts value v to decimal representation.
 *)

PROCEDURE Longreal2Arr(v : LONGREAL; VAR s : ARRAY OF CHAR);
(*
 * Converts value v to decimal representation.
 *)

PROCEDURE Shortcard2Arr(v : SHORTCARD; VAR s : ARRAY OF CHAR);
(*
 * Converts value v to decimal representation.
 *)

PROCEDURE Shortcard2ArrHex(v : SHORTCARD; VAR s : ARRAY OF CHAR);
(*
 * Converts value v to hexadecimal representation.
 *)

PROCEDURE Addr2ArrHex(v : SYSTEM.ADDRESS; VAR s : ARRAY OF CHAR);
(*
 * Converts address v to hexadecimal representation.
 *)

PROCEDURE MaxLI(a, b : LONGINT) : LONGINT;
(*
 * Returns the maximum over a and b
 *)

PROCEDURE MaxLI3(a, b, c : LONGINT) : LONGINT;
(*
 * Returns the maximum over a, b and c
 *)

PROCEDURE MaxLI4(a, b, c, d : LONGINT) : LONGINT;
(*
 * Returns the maximum over a, b, c and d
 *)

PROCEDURE stat(path:SYSTEM.ADDRESS; VAR buf:SysLib.Stat):SysLib.SIGNED;

END UTI.

