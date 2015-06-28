MODULE MSDOS;
IMPORT SYSTEM;

CONST
	PathLength* = 128;

CONST (* 80386 register information *)
	EAX = 0;	ECX = 1; 	EDX = 2;	EBX = 3; 
	ESP = 4;	EBP = 5; 	ESI = 6;	EDI = 7;

CONST  (* file attributes *)
	ReadOnly* = 0; Hidden* = 1; System* = 2; VolLabel* = 3; SubDir* = 4; Archive* = 5;

TYPE
	Filename* = ARRAY PathLength OF CHAR; (* must be ASCIIZ *)
	File* = RECORD
		handle	: INTEGER;
		name-		: Filename;
	END;

	FileInfo* = RECORD
		attr* : SET;
		time*, date* : LONGINT;
		length* : LONGINT;
		name* : Filename;
	END;

	EntryHandler* = PROCEDURE(VAR fileinfo : FileInfo; VAR continue: BOOLEAN);

VAR
	DTA : ARRAY 128 OF SYSTEM.BYTE;

PROCEDURE - DosInterrupt 0CDH, 21H;

PROCEDURE create*(name : Filename; attr : SET; VAR file : File; VAR err : BOOLEAN);
BEGIN
	file.name := name;
	SYSTEM.PUTREG(ECX, attr);
	SYSTEM.PUTREG(EDX, SYSTEM.ADR(name));
	SYSTEM.PUTREG(EAX, 3C00H);
	DosInterrupt;
	SYSTEM.GETREG(EAX, file.handle); err := SYSTEM.CC(2);
	IF err THEN file.name[0] := 0X; END;
END create;

PROCEDURE open*(name : Filename; VAR file : File; VAR err : BOOLEAN);
BEGIN
	file.name := name;
	SYSTEM.PUTREG(EDX, SYSTEM.ADR(name));
	SYSTEM.PUTREG(EAX, 3D82H); (* no inherit, compatibility, r/w *)
	DosInterrupt;	SYSTEM.GETREG(EAX, file.handle); err := SYSTEM.CC(2);
	IF err THEN file.name[0] := 0X; END;
END open;

PROCEDURE close*(VAR file : File);
VAR res : INTEGER; err : BOOLEAN;
BEGIN 
	SYSTEM.PUTREG(EBX, LONG(file.handle)); 
	SYSTEM.PUTREG(EAX, 3E00H); 
	DosInterrupt; SYSTEM.GETREG(EAX, res); err := SYSTEM.CC(2);
END close;

PROCEDURE readbytes*(file : File; VAR buf : ARRAY OF SYSTEM.BYTE; size : LONGINT; VAR read : LONGINT);
VAR err : BOOLEAN;
BEGIN
	IF size > LEN(buf) THEN HALT(25); END;
	read := 0;
	SYSTEM.PUTREG(ECX, size);
	SYSTEM.PUTREG(EDX, SYSTEM.ADR(buf));
	SYSTEM.PUTREG(EBX, file.handle);
	SYSTEM.PUTREG(EAX, 3F00H);
	DosInterrupt; err := SYSTEM.CC(2);
	IF ~err THEN SYSTEM.GETREG(EAX, read); END;
END readbytes;

PROCEDURE writebytes*(file : File; VAR buf : ARRAY OF SYSTEM.BYTE; size : LONGINT; VAR res : INTEGER);
VAR err : BOOLEAN;
BEGIN
	IF size > LEN(buf) THEN HALT(25); END;
	res := 0;
	SYSTEM.PUTREG(ECX, size);
	SYSTEM.PUTREG(EDX, SYSTEM.ADR(buf));
	SYSTEM.PUTREG(EBX, file.handle);
	SYSTEM.PUTREG(EAX, 4000H);
	DosInterrupt; err := SYSTEM.CC(2);
	IF err THEN SYSTEM.GETREG(EAX, res); END;
END writebytes;

PROCEDURE setinfo(VAR info : FileInfo; VAR path : Filename; found : BOOLEAN);
VAR i, j, k : INTEGER; ch : CHAR;
BEGIN
	IF found THEN
		i := 0;
		WHILE path[i] # 0X DO INC(i); END; (* must be 0X terminated *)
		LOOP
			IF i < 0 THEN EXIT; END;
			ch := path[i];
			IF (ch = '/') OR (ch = '\') THEN EXIT; END;
			DEC(i);
		END;
		j := 0; k := 0; WHILE j <= i DO info.name[k] := path[j]; INC(j); INC(k); END;
		SYSTEM.MOVE(SYSTEM.ADR(DTA[1EH]), SYSTEM.ADR(info.name[k]), 13); (* filename *)
	END;
END setinfo;

PROCEDURE findfirst*(attr : SET; VAR wildname : Filename; VAR info : FileInfo; VAR found : BOOLEAN);
BEGIN
	SYSTEM.PUTREG(EDI, SYSTEM.ADR(DTA));
	SYSTEM.PUTREG(EDX, SYSTEM.ADR(wildname));
	SYSTEM.PUTREG(ECX, attr);
	SYSTEM.PUTREG(EAX, 4E00H);
	DosInterrupt; found := ~SYSTEM.CC(2); setinfo(info, wildname, found);
END findfirst;

PROCEDURE findnext*(VAR wildname : Filename; VAR info : FileInfo; VAR found : BOOLEAN);
BEGIN
	SYSTEM.PUTREG(EDI, SYSTEM.ADR(DTA));
	SYSTEM.PUTREG(EAX, 4F00H);
	DosInterrupt; found := ~SYSTEM.CC(2); setinfo(info, wildname, found);
END findnext;

PROCEDURE find*(wildname : Filename; attr : SET; handler : EntryHandler);
VAR info : FileInfo; found, continue : BOOLEAN;
BEGIN 
	findfirst(attr, wildname, info, found);
	IF found THEN
		handler(info, continue);
		WHILE found & continue DO findnext(wildname, info, found);
			IF found THEN handler(info, continue); END;
		END;
	END;
END find;
END MSDOS.
