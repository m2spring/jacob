MODULE Input;
IMPORT SYSTEM, Display, Kernel, Keyboard:=IBMPCKey;

CONST
	EAX = 0; ECX = 1; EDX = 2; EBX = 3; 
	ESP = 4; EBP = 5; ESI = 6; EDI = 7;

PROCEDURE - MouseInt 0CDH, 33H;
PROCEDURE - ClockInt 0CDH, 1AH;

PROCEDURE Available*(): INTEGER;
BEGIN RETURN Keyboard.Available();
END Available;
PROCEDURE Read*(VAR ch: CHAR);
VAR c : INTEGER;
BEGIN Keyboard.Read(ch);
END Read;
PROCEDURE Mouse*(VAR keys: SET; VAR x, y: INTEGER);
VAR tmp, s1 : SET;
BEGIN
	SYSTEM.PUTREG(EAX, 3); MouseInt;
	SYSTEM.GETREG(EBX, tmp);
	SYSTEM.GETREG(EDX, y); y := (Display.Height - 1) - y; (* Y position, in Oberon coords *)
	SYSTEM.GETREG(ECX, x); (* X position *)
	s1 := {};
	IF 0 IN tmp THEN INCL(s1, 2); END; 
	IF 1 IN tmp THEN INCL(s1, 0); END; 
	IF 2 IN tmp THEN INCL(s1, 1); END; 

	IF Keyboard.MMEquiv THEN INCL(s1, 1); END;
	keys := s1;
END Mouse;
PROCEDURE SetMouseLimits*(w, h: INTEGER);
BEGIN 
	SYSTEM.PUTREG(ECX, 0);
	DEC(w, 16); SYSTEM.PUTREG(EDX, w); (* min/max *)
	SYSTEM.PUTREG(EAX, 7); (* Horizontal limits *)
	MouseInt;

	SYSTEM.PUTREG(ECX, 0);
	SYSTEM.PUTREG(EDX, h); (* min/max *)
	SYSTEM.PUTREG(EAX, 8); (* Vertical limit *)
	MouseInt;
END SetMouseLimits;
PROCEDURE Time*(): LONGINT;
VAR hi, lo : INTEGER; r : LONGINT;
BEGIN
	SYSTEM.PUTREG(EAX, 0); ClockInt;
	SYSTEM.GETREG(ECX, hi); SYSTEM.GETREG(EDX, lo);
	SYSTEM.MOVE(SYSTEM.ADR(lo), SYSTEM.ADR(r), SIZE(LONGINT));
	RETURN r;
END Time;
BEGIN SYSTEM.PUTREG(EAX, 0); MouseInt; (* mouse cursor init (fn 1 is on) *) 
END Input.