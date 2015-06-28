MODULE PictureFrames;

IMPORT Display, Objects, Pictures, Oberon, Fonts, Texts;

TYPE
	FocusMsg = RECORD (Display.FrameMsg) END;
	Frame* = POINTER TO FrameDesc;
	Location = POINTER TO LocDesc;
	FrameDesc* = RECORD (Display.FrameDesc)
		state: SET;
		l, t: INTEGER;
		pict*: Pictures.Picture;
		car*, sel, zoom: INTEGER;
		time: LONGINT;
		caret: Location;
		selx, sely, selw, selh: INTEGER;
	END;
	LocDesc = RECORD
		x, y: INTEGER;
		next: Location;
	END;

VAR
	color: INTEGER;
	grid: INTEGER;
	lineWidth: INTEGER;
	menuString*: ARRAY 100 OF CHAR;
        height*:INTEGER; 

PROCEDURE Handle* (F: Objects.Object; VAR msg: Objects.ObjMsg); END Handle;
PROCEDURE Open* (F: Frame; H: Objects.Handler; P: Pictures.Picture; l, t: INTEGER); END Open;
PROCEDURE NotifyDisplay*; END NotifyDisplay;

END PictureFrames.

