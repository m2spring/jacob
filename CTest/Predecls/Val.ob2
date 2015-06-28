MODULE Val;
IMPORT S        := SYSTEM; 
TYPE   Pointer   = POINTER TO ARRAY OF CHAR;
       Procedure = PROCEDURE;
       Array     = ARRAY 10 OF CHAR; 
       Record    = RECORD f:ARRAY 100 OF CHAR; END;
CONST  st        = '23456789ABCDEFGHIJKLMNOP';
VAR    by        : S.BYTE;
       sp        : S.PTR;
       ch        : CHAR; 
       bo        : BOOLEAN; 
       si        : SHORTINT; 
       in        : INTEGER; 
       li        : LONGINT; 
       se        : SET;
       re        : REAL;
       lr        : LONGREAL;
       pt        : Pointer;
       ar        : Array; 
       rc        : Record;
       pr        : Procedure;

PROCEDURE PR*; BEGIN (* PR *) END PR;

PROCEDURE ToByte;
BEGIN (* ToByte *)
 by:=S.VAL(S.BYTE   ,'X'           ); 
 by:=S.VAL(S.BYTE   ,0X            ); 
 by:=S.VAL(S.BYTE   ,'123456789abc'); 
 by:=S.VAL(S.BYTE   ,st            ); 
 by:=S.VAL(S.BYTE   ,TRUE          ); 
 by:=S.VAL(S.BYTE   ,127           ); 
 by:=S.VAL(S.BYTE   ,32767         ); 
 by:=S.VAL(S.BYTE   ,1+MAX(INTEGER)); 
 by:=S.VAL(S.BYTE   ,{1,2,3}       ); 
 by:=S.VAL(S.BYTE   ,1.0           ); 
 by:=S.VAL(S.BYTE   ,2.0D0         ); 
 by:=S.VAL(S.BYTE   ,NIL           ); 
 by:=S.VAL(S.BYTE   ,PR            ); 

 by:=S.VAL(S.BYTE   ,by); 
 by:=S.VAL(S.BYTE   ,sp); 
 by:=S.VAL(S.BYTE   ,ch); 
 by:=S.VAL(S.BYTE   ,bo); 
 by:=S.VAL(S.BYTE   ,si); 
 by:=S.VAL(S.BYTE   ,in); 
 by:=S.VAL(S.BYTE   ,li); 
 by:=S.VAL(S.BYTE   ,se); 
 by:=S.VAL(S.BYTE   ,re); 
 by:=S.VAL(S.BYTE   ,lr); 
 by:=S.VAL(S.BYTE   ,pt); 
 by:=S.VAL(S.BYTE   ,ar); 
 by:=S.VAL(S.BYTE   ,rc); 
 by:=S.VAL(S.BYTE   ,pr); 
END ToByte;

PROCEDURE ToPtr;
BEGIN (* ToPtr *)
 sp:=S.VAL(S.PTR   ,'X'           ); 
 sp:=S.VAL(S.PTR   ,0X            ); 
 sp:=S.VAL(S.PTR   ,'123456789abc'); 
 sp:=S.VAL(S.PTR   ,st            ); 
 sp:=S.VAL(S.PTR   ,TRUE          ); 
 sp:=S.VAL(S.PTR   ,127           ); 
 sp:=S.VAL(S.PTR   ,32767         ); 
 sp:=S.VAL(S.PTR   ,1+MAX(INTEGER)); 
 sp:=S.VAL(S.PTR   ,{1,2,3}       ); 
 sp:=S.VAL(S.PTR   ,1.0           ); 
 sp:=S.VAL(S.PTR   ,2.0D0         ); 
 sp:=S.VAL(S.PTR   ,NIL           ); 
 sp:=S.VAL(S.PTR   ,PR            ); 

 sp:=S.VAL(S.PTR   ,by); 
 sp:=S.VAL(S.PTR   ,sp); 
 sp:=S.VAL(S.PTR   ,ch); 
 sp:=S.VAL(S.PTR   ,bo); 
 sp:=S.VAL(S.PTR   ,si); 
 sp:=S.VAL(S.PTR   ,in); 
 sp:=S.VAL(S.PTR   ,li); 
 sp:=S.VAL(S.PTR   ,se); 
 sp:=S.VAL(S.PTR   ,re); 
 sp:=S.VAL(S.PTR   ,lr); 
 sp:=S.VAL(S.PTR   ,pt); 
 sp:=S.VAL(S.PTR   ,ar); 
 sp:=S.VAL(S.PTR   ,rc); 
 sp:=S.VAL(S.PTR   ,pr); 
END ToPtr;

PROCEDURE ToChar;
BEGIN (* ToChar *)
 ch:=S.VAL(CHAR   ,'X'           ); 
 ch:=S.VAL(CHAR   ,0X            ); 
 ch:=S.VAL(CHAR   ,'123456789abc'); 
 ch:=S.VAL(CHAR   ,st            ); 
 ch:=S.VAL(CHAR   ,TRUE          ); 
 ch:=S.VAL(CHAR   ,127           ); 
 ch:=S.VAL(CHAR   ,32767         ); 
 ch:=S.VAL(CHAR   ,1+MAX(INTEGER)); 
 ch:=S.VAL(CHAR   ,{1,2,3}       ); 
 ch:=S.VAL(CHAR   ,1.0           ); 
 ch:=S.VAL(CHAR   ,2.0D0         ); 
 ch:=S.VAL(CHAR   ,NIL           ); 
 ch:=S.VAL(CHAR   ,PR            ); 

 ch:=S.VAL(CHAR   ,by); 
 ch:=S.VAL(CHAR   ,sp); 
 ch:=S.VAL(CHAR   ,ch); 
 ch:=S.VAL(CHAR   ,bo); 
 ch:=S.VAL(CHAR   ,si); 
 ch:=S.VAL(CHAR   ,in); 
 ch:=S.VAL(CHAR   ,li); 
 ch:=S.VAL(CHAR   ,se); 
 ch:=S.VAL(CHAR   ,re); 
 ch:=S.VAL(CHAR   ,lr); 
 ch:=S.VAL(CHAR   ,pt); 
 ch:=S.VAL(CHAR   ,ar); 
 ch:=S.VAL(CHAR   ,rc); 
 ch:=S.VAL(CHAR   ,pr); 
END ToChar;

PROCEDURE ToBoolean;
BEGIN (* ToBoolean *)
 bo:=S.VAL(BOOLEAN   ,'X'           ); 
 bo:=S.VAL(BOOLEAN   ,0X            ); 
 bo:=S.VAL(BOOLEAN   ,'123456789abc'); 
 bo:=S.VAL(BOOLEAN   ,st            ); 
 bo:=S.VAL(BOOLEAN   ,TRUE          ); 
 bo:=S.VAL(BOOLEAN   ,127           ); 
 bo:=S.VAL(BOOLEAN   ,32767         ); 
 bo:=S.VAL(BOOLEAN   ,1+MAX(INTEGER)); 
 bo:=S.VAL(BOOLEAN   ,{1,2,3}       ); 
 bo:=S.VAL(BOOLEAN   ,1.0           ); 
 bo:=S.VAL(BOOLEAN   ,2.0D0         ); 
 bo:=S.VAL(BOOLEAN   ,NIL           ); 
 bo:=S.VAL(BOOLEAN   ,PR            ); 

 bo:=S.VAL(BOOLEAN   ,by); 
 bo:=S.VAL(BOOLEAN   ,sp); 
 bo:=S.VAL(BOOLEAN   ,ch); 
 bo:=S.VAL(BOOLEAN   ,bo); 
 bo:=S.VAL(BOOLEAN   ,si); 
 bo:=S.VAL(BOOLEAN   ,in); 
 bo:=S.VAL(BOOLEAN   ,li); 
 bo:=S.VAL(BOOLEAN   ,se); 
 bo:=S.VAL(BOOLEAN   ,re); 
 bo:=S.VAL(BOOLEAN   ,lr); 
 bo:=S.VAL(BOOLEAN   ,pt); 
 bo:=S.VAL(BOOLEAN   ,ar); 
 bo:=S.VAL(BOOLEAN   ,rc); 
 bo:=S.VAL(BOOLEAN   ,pr); 
END ToBoolean;

PROCEDURE ToShortint;
BEGIN (* ToShortint *)
 si:=S.VAL(SHORTINT   ,'X'           ); 
 si:=S.VAL(SHORTINT   ,0X            ); 
 si:=S.VAL(SHORTINT   ,'123456789abc'); 
 si:=S.VAL(SHORTINT   ,st            ); 
 si:=S.VAL(SHORTINT   ,TRUE          ); 
 si:=S.VAL(SHORTINT   ,127           ); 
 si:=S.VAL(SHORTINT   ,32767         ); 
 si:=S.VAL(SHORTINT   ,1+MAX(INTEGER)); 
 si:=S.VAL(SHORTINT   ,{1,2,3}       ); 
 si:=S.VAL(SHORTINT   ,1.0           ); 
 si:=S.VAL(SHORTINT   ,2.0D0         ); 
 si:=S.VAL(SHORTINT   ,NIL           ); 
 si:=S.VAL(SHORTINT   ,PR            ); 

 si:=S.VAL(SHORTINT   ,by); 
 si:=S.VAL(SHORTINT   ,sp); 
 si:=S.VAL(SHORTINT   ,ch); 
 si:=S.VAL(SHORTINT   ,bo); 
 si:=S.VAL(SHORTINT   ,si); 
 si:=S.VAL(SHORTINT   ,in); 
 si:=S.VAL(SHORTINT   ,li); 
 si:=S.VAL(SHORTINT   ,se); 
 si:=S.VAL(SHORTINT   ,re); 
 si:=S.VAL(SHORTINT   ,lr); 
 si:=S.VAL(SHORTINT   ,pt); 
 si:=S.VAL(SHORTINT   ,ar); 
 si:=S.VAL(SHORTINT   ,rc); 
 si:=S.VAL(SHORTINT   ,pr); 
END ToShortint;

PROCEDURE ToInteger;
BEGIN (* ToInteger *)
 in:=S.VAL(INTEGER   ,'X'           ); 
 in:=S.VAL(INTEGER   ,0X            ); 
 in:=S.VAL(INTEGER   ,'123456789abc'); 
 in:=S.VAL(INTEGER   ,st            ); 
 in:=S.VAL(INTEGER   ,TRUE          ); 
 in:=S.VAL(INTEGER   ,127           ); 
 in:=S.VAL(INTEGER   ,32767         ); 
 in:=S.VAL(INTEGER   ,1+MAX(INTEGER)); 
 in:=S.VAL(INTEGER   ,{1,2,3}       ); 
 in:=S.VAL(INTEGER   ,1.0           ); 
 in:=S.VAL(INTEGER   ,2.0D0         ); 
 in:=S.VAL(INTEGER   ,NIL           ); 
 in:=S.VAL(INTEGER   ,PR            ); 

 in:=S.VAL(INTEGER   ,by); 
 in:=S.VAL(INTEGER   ,sp); 
 in:=S.VAL(INTEGER   ,ch); 
 in:=S.VAL(INTEGER   ,bo); 
 in:=S.VAL(INTEGER   ,si); 
 in:=S.VAL(INTEGER   ,in); 
 in:=S.VAL(INTEGER   ,li); 
 in:=S.VAL(INTEGER   ,se); 
 in:=S.VAL(INTEGER   ,re); 
 in:=S.VAL(INTEGER   ,lr); 
 in:=S.VAL(INTEGER   ,pt); 
 in:=S.VAL(INTEGER   ,ar); 
 in:=S.VAL(INTEGER   ,rc); 
 in:=S.VAL(INTEGER   ,pr); 
END ToInteger;

PROCEDURE ToLongint;
BEGIN (* ToLongint *)
 li:=S.VAL(LONGINT   ,'X'           ); 
 li:=S.VAL(LONGINT   ,0X            ); 
 li:=S.VAL(LONGINT   ,'123456789abc'); 
 li:=S.VAL(LONGINT   ,st            ); 
 li:=S.VAL(LONGINT   ,TRUE          ); 
 li:=S.VAL(LONGINT   ,127           ); 
 li:=S.VAL(LONGINT   ,32767         ); 
 li:=S.VAL(LONGINT   ,1+MAX(INTEGER)); 
 li:=S.VAL(LONGINT   ,{1,2,3}       ); 
 li:=S.VAL(LONGINT   ,1.0           ); 
 li:=S.VAL(LONGINT   ,2.0D0         ); 
 li:=S.VAL(LONGINT   ,NIL           ); 
 li:=S.VAL(LONGINT   ,PR            ); 

 li:=S.VAL(LONGINT   ,by); 
 li:=S.VAL(LONGINT   ,sp); 
 li:=S.VAL(LONGINT   ,ch); 
 li:=S.VAL(LONGINT   ,bo); 
 li:=S.VAL(LONGINT   ,si); 
 li:=S.VAL(LONGINT   ,in); 
 li:=S.VAL(LONGINT   ,li); 
 li:=S.VAL(LONGINT   ,se); 
 li:=S.VAL(LONGINT   ,re); 
 li:=S.VAL(LONGINT   ,lr); 
 li:=S.VAL(LONGINT   ,pt); 
 li:=S.VAL(LONGINT   ,ar); 
 li:=S.VAL(LONGINT   ,rc); 
 li:=S.VAL(LONGINT   ,pr); 
END ToLongint;

PROCEDURE ToSet;
BEGIN (* ToSet *)
 se:=S.VAL(SET   ,'X'           ); 
 se:=S.VAL(SET   ,0X            ); 
 se:=S.VAL(SET   ,'123456789abc'); 
 se:=S.VAL(SET   ,st            ); 
 se:=S.VAL(SET   ,TRUE          ); 
 se:=S.VAL(SET   ,127           ); 
 se:=S.VAL(SET   ,32767         ); 
 se:=S.VAL(SET   ,1+MAX(INTEGER)); 
 se:=S.VAL(SET   ,{1,2,3}       ); 
 se:=S.VAL(SET   ,1.0           ); 
 se:=S.VAL(SET   ,2.0D0         ); 
 se:=S.VAL(SET   ,NIL           ); 
 se:=S.VAL(SET   ,PR            ); 

 se:=S.VAL(SET   ,by); 
 se:=S.VAL(SET   ,sp); 
 se:=S.VAL(SET   ,ch); 
 se:=S.VAL(SET   ,bo); 
 se:=S.VAL(SET   ,si); 
 se:=S.VAL(SET   ,in); 
 se:=S.VAL(SET   ,li); 
 se:=S.VAL(SET   ,se); 
 se:=S.VAL(SET   ,re); 
 se:=S.VAL(SET   ,lr); 
 se:=S.VAL(SET   ,pt); 
 se:=S.VAL(SET   ,ar); 
 se:=S.VAL(SET   ,rc); 
 se:=S.VAL(SET   ,pr); 
END ToSet;

PROCEDURE ToReal;
BEGIN (* ToReal *)
 re:=S.VAL(REAL   ,'X'           ); 
 re:=S.VAL(REAL   ,0X            ); 
 re:=S.VAL(REAL   ,'123456789abc'); 
 re:=S.VAL(REAL   ,st            ); 
 re:=S.VAL(REAL   ,TRUE          ); 
 re:=S.VAL(REAL   ,127           ); 
 re:=S.VAL(REAL   ,32767         ); 
 re:=S.VAL(REAL   ,1+MAX(INTEGER)); 
 re:=S.VAL(REAL   ,{1,2,3}       ); 
 re:=S.VAL(REAL   ,1.0           ); 
 re:=S.VAL(REAL   ,2.0D0         ); 
 re:=S.VAL(REAL   ,NIL           ); 
 re:=S.VAL(REAL   ,PR            ); 

 re:=S.VAL(REAL   ,by); 
 re:=S.VAL(REAL   ,sp); 
 re:=S.VAL(REAL   ,ch); 
 re:=S.VAL(REAL   ,bo); 
 re:=S.VAL(REAL   ,si); 
 re:=S.VAL(REAL   ,in); 
 re:=S.VAL(REAL   ,li); 
 re:=S.VAL(REAL   ,se); 
 re:=S.VAL(REAL   ,re); 
 re:=S.VAL(REAL   ,lr); 
 re:=S.VAL(REAL   ,pt); 
 re:=S.VAL(REAL   ,ar); 
 re:=S.VAL(REAL   ,rc); 
 re:=S.VAL(REAL   ,pr); 
END ToReal;

PROCEDURE ToLongreal;
BEGIN (* ToLongreal *)
 lr:=S.VAL(LONGREAL   ,'X'           ); 
 lr:=S.VAL(LONGREAL   ,0X            ); 
 lr:=S.VAL(LONGREAL   ,'123456789abc'); 
 lr:=S.VAL(LONGREAL   ,st            ); 
 lr:=S.VAL(LONGREAL   ,TRUE          ); 
 lr:=S.VAL(LONGREAL   ,127           ); 
 lr:=S.VAL(LONGREAL   ,32767         ); 
 lr:=S.VAL(LONGREAL   ,1+MAX(INTEGER)); 
 lr:=S.VAL(LONGREAL   ,{1,2,3}       ); 
 lr:=S.VAL(LONGREAL   ,1.0           ); 
 lr:=S.VAL(LONGREAL   ,2.0D0         ); 
 lr:=S.VAL(LONGREAL   ,NIL           ); 
 lr:=S.VAL(LONGREAL   ,PR            ); 

 lr:=S.VAL(LONGREAL   ,by); 
 lr:=S.VAL(LONGREAL   ,sp); 
 lr:=S.VAL(LONGREAL   ,ch); 
 lr:=S.VAL(LONGREAL   ,bo); 
 lr:=S.VAL(LONGREAL   ,si); 
 lr:=S.VAL(LONGREAL   ,in); 
 lr:=S.VAL(LONGREAL   ,li); 
 lr:=S.VAL(LONGREAL   ,se); 
 lr:=S.VAL(LONGREAL   ,re); 
 lr:=S.VAL(LONGREAL   ,lr); 
 lr:=S.VAL(LONGREAL   ,pt); 
 lr:=S.VAL(LONGREAL   ,ar); 
 lr:=S.VAL(LONGREAL   ,rc); 
 lr:=S.VAL(LONGREAL   ,pr); 
END ToLongreal;

PROCEDURE ToPointer;
BEGIN (* ToPointer *)
 pt:=S.VAL(Pointer   ,'X'           ); 
 pt:=S.VAL(Pointer   ,0X            ); 
 pt:=S.VAL(Pointer   ,'123456789abc'); 
 pt:=S.VAL(Pointer   ,st            ); 
 pt:=S.VAL(Pointer   ,TRUE          ); 
 pt:=S.VAL(Pointer   ,127           ); 
 pt:=S.VAL(Pointer   ,32767         ); 
 pt:=S.VAL(Pointer   ,1+MAX(INTEGER)); 
 pt:=S.VAL(Pointer   ,{1,2,3}       ); 
 pt:=S.VAL(Pointer   ,1.0           ); 
 pt:=S.VAL(Pointer   ,2.0D0         ); 
 pt:=S.VAL(Pointer   ,NIL           ); 
 pt:=S.VAL(Pointer   ,PR            ); 

 pt:=S.VAL(Pointer   ,by); 
 pt:=S.VAL(Pointer   ,sp); 
 pt:=S.VAL(Pointer   ,ch); 
 pt:=S.VAL(Pointer   ,bo); 
 pt:=S.VAL(Pointer   ,si); 
 pt:=S.VAL(Pointer   ,in); 
 pt:=S.VAL(Pointer   ,li); 
 pt:=S.VAL(Pointer   ,se); 
 pt:=S.VAL(Pointer   ,re); 
 pt:=S.VAL(Pointer   ,lr); 
 pt:=S.VAL(Pointer   ,pt); 
 pt:=S.VAL(Pointer   ,ar); 
 pt:=S.VAL(Pointer   ,rc); 
 pt:=S.VAL(Pointer   ,pr); 
END ToPointer;

PROCEDURE ToArray;
BEGIN (* ToArray *)
 ar:=S.VAL(Array   ,'X'           ); 
 ar:=S.VAL(Array   ,0X            ); 
 ar:=S.VAL(Array   ,'123456789abc'); 
 ar:=S.VAL(Array   ,st            ); 
 ar:=S.VAL(Array   ,TRUE          ); 
 ar:=S.VAL(Array   ,127           ); 
 ar:=S.VAL(Array   ,32767         ); 
 ar:=S.VAL(Array   ,1+MAX(INTEGER)); 
 ar:=S.VAL(Array   ,{1,2,3}       ); 
 ar:=S.VAL(Array   ,1.0           ); 
 ar:=S.VAL(Array   ,2.0D0         ); 
 ar:=S.VAL(Array   ,NIL           ); 
 ar:=S.VAL(Array   ,PR            ); 

 ar:=S.VAL(Array   ,by); 
 ar:=S.VAL(Array   ,sp); 
 ar:=S.VAL(Array   ,ch); 
 ar:=S.VAL(Array   ,bo); 
 ar:=S.VAL(Array   ,si); 
 ar:=S.VAL(Array   ,in); 
 ar:=S.VAL(Array   ,li); 
 ar:=S.VAL(Array   ,se); 
 ar:=S.VAL(Array   ,re); 
 ar:=S.VAL(Array   ,lr); 
 ar:=S.VAL(Array   ,pt); 
 ar:=S.VAL(Array   ,ar); 
 ar:=S.VAL(Array   ,rc); 
 ar:=S.VAL(Array   ,pr); 
END ToArray;

PROCEDURE ToRecord;
BEGIN (* ToRecord *)
 rc:=S.VAL(Record   ,'X'           ); 
 rc:=S.VAL(Record   ,0X            ); 
 rc:=S.VAL(Record   ,'123456789abc'); 
 rc:=S.VAL(Record   ,st            ); 
 rc:=S.VAL(Record   ,TRUE          ); 
 rc:=S.VAL(Record   ,127           ); 
 rc:=S.VAL(Record   ,32767         ); 
 rc:=S.VAL(Record   ,1+MAX(INTEGER)); 
 rc:=S.VAL(Record   ,{1,2,3}       ); 
 rc:=S.VAL(Record   ,1.0           ); 
 rc:=S.VAL(Record   ,2.0D0         ); 
 rc:=S.VAL(Record   ,NIL           ); 
 rc:=S.VAL(Record   ,PR            ); 

 rc:=S.VAL(Record   ,by); 
 rc:=S.VAL(Record   ,sp); 
 rc:=S.VAL(Record   ,ch); 
 rc:=S.VAL(Record   ,bo); 
 rc:=S.VAL(Record   ,si); 
 rc:=S.VAL(Record   ,in); 
 rc:=S.VAL(Record   ,li); 
 rc:=S.VAL(Record   ,se); 
 rc:=S.VAL(Record   ,re); 
 rc:=S.VAL(Record   ,lr); 
 rc:=S.VAL(Record   ,pt); 
 rc:=S.VAL(Record   ,ar); 
 rc:=S.VAL(Record   ,rc); 
 rc:=S.VAL(Record   ,pr); 
END ToRecord;

PROCEDURE ToProcedure;
BEGIN (* ToProcedure *)
 pr:=S.VAL(Procedure   ,'X'           ); 
 pr:=S.VAL(Procedure   ,0X            ); 
 pr:=S.VAL(Procedure   ,'123456789abc'); 
 pr:=S.VAL(Procedure   ,st            ); 
 pr:=S.VAL(Procedure   ,TRUE          ); 
 pr:=S.VAL(Procedure   ,127           ); 
 pr:=S.VAL(Procedure   ,32767         ); 
 pr:=S.VAL(Procedure   ,1+MAX(INTEGER)); 
 pr:=S.VAL(Procedure   ,{1,2,3}       ); 
 pr:=S.VAL(Procedure   ,1.0           ); 
 pr:=S.VAL(Procedure   ,2.0D0         ); 
 pr:=S.VAL(Procedure   ,NIL           ); 
 pr:=S.VAL(Procedure   ,PR            ); 

 pr:=S.VAL(Procedure   ,by); 
 pr:=S.VAL(Procedure   ,sp); 
 pr:=S.VAL(Procedure   ,ch); 
 pr:=S.VAL(Procedure   ,bo); 
 pr:=S.VAL(Procedure   ,si); 
 pr:=S.VAL(Procedure   ,in); 
 pr:=S.VAL(Procedure   ,li); 
 pr:=S.VAL(Procedure   ,se); 
 pr:=S.VAL(Procedure   ,re); 
 pr:=S.VAL(Procedure   ,lr); 
 pr:=S.VAL(Procedure   ,pt); 
 pr:=S.VAL(Procedure   ,ar); 
 pr:=S.VAL(Procedure   ,rc); 
 pr:=S.VAL(Procedure   ,pr); 
END ToProcedure;

BEGIN (* Val *)    
 ar:=S.VAL(Array,rc); 
 ar:=S.VAL(Array,"0123456789abcd"); 
 si:=S.VAL(SHORTINT,"01234567"); 
END Val.

