MODULE Objects;

IMPORT Files;

CONST
	Bool = 7;
	Char = 6;
	Int = 3;
	Inval = 0;
	LongReal = 5;
	Real = 4;
	String = 2;
	deep = 1;
	enum = 0;
	get = 1;
	load = 0;
	set = 2;
	shallow = 0;
	store = 1;

TYPE
	Name = ARRAY 32 OF CHAR;
	Object* = POINTER TO ObjDesc;
	Library = POINTER TO LibDesc;
	ObjMsg* = RECORD
		stamp: LONGINT;
		dlink: Object;
	END;
	AttrMsg = RECORD (ObjMsg)
		id: INTEGER;
		Enum: PROCEDURE (name: ARRAY OF CHAR);
		name: Name;
		res, class: INTEGER;
		i: LONGINT;
		x: REAL;
		y: LONGREAL;
		c: CHAR;
		b: BOOLEAN;
		s: ARRAY 64 OF CHAR;
	END;
	BindMsg = RECORD (ObjMsg)
		lib: Library;
	END;
	Handler* = PROCEDURE (obj: Object; VAR M: ObjMsg);
	ObjDesc = RECORD
		stamp: LONGINT;
		dlink, slink: Object;
		lib: Library;
		ref: INTEGER;
		handle: Handler;
	END;
	CopyMsg = RECORD (ObjMsg)
		id: INTEGER;
		obj: Object;
	END;
	Dictionary = RECORD
	END;
	Dummy = POINTER TO DummyDesc;
	DummyDesc = RECORD (ObjDesc)
		GName: Name;
	END;
	EnumProc = PROCEDURE (L: Library);
	FileMsg = RECORD (ObjMsg)
		id: INTEGER;
		len: LONGINT;
		R: Files.Rider;
	END;
	FindMsg = RECORD (ObjMsg)
		name: Name;
		obj: Object;
	END;
	Index = POINTER TO IndexDesc;
	IndexDesc = RECORD END;
	LibDesc = RECORD
		ind: Index;
		name: Name;
		dict: Dictionary;
		maxref: INTEGER;
		GenRef: PROCEDURE (L: Library; VAR ref: INTEGER);
		GetObj: PROCEDURE (L: Library; ref: INTEGER; VAR obj: Object);
		PutObj: PROCEDURE (L: Library; ref: INTEGER; obj: Object);
		FreeObj: PROCEDURE (L: Library; ref: INTEGER);
		Load: PROCEDURE (L: Library);
		Store: PROCEDURE (L: Library);
	END;
	LinkMsg = RECORD (ObjMsg)
		id: INTEGER;
		Enum: PROCEDURE (name: ARRAY OF CHAR);
		name: Name;
		res: INTEGER;
		obj: Object;
	END;
	NewProc = PROCEDURE (): Library;

VAR
	LibBlockId: CHAR;
	NewObj: Object;

PROCEDURE Enumerate (P: EnumProc); END Enumerate;
PROCEDURE FreeLibrary (name: ARRAY OF CHAR); END FreeLibrary;
PROCEDURE GetKey (VAR D: Dictionary; name: ARRAY OF CHAR; VAR key: INTEGER); END GetKey;
PROCEDURE GetName (VAR D: Dictionary; key: INTEGER; VAR name: ARRAY OF CHAR); END GetName;
PROCEDURE GetRef (VAR D: Dictionary; name: ARRAY OF CHAR; VAR ref: INTEGER); END GetRef;
PROCEDURE LoadLibrary (L: Library; f: Files.File; pos: LONGINT; VAR len: LONGINT); END LoadLibrary;
PROCEDURE OpenLibrary (L: Library); END OpenLibrary;
PROCEDURE PutName (VAR D: Dictionary; key: INTEGER; name: ARRAY OF CHAR); END PutName;
PROCEDURE Register (ext: ARRAY OF CHAR; new: NewProc); END Register;
PROCEDURE Stamp (VAR M: ObjMsg); END Stamp;
PROCEDURE StoreLibrary (L: Library; f: Files.File; pos: LONGINT; VAR len: LONGINT); END StoreLibrary;
PROCEDURE ThisLibrary (name: ARRAY OF CHAR): Library; END ThisLibrary;

END Objects.

