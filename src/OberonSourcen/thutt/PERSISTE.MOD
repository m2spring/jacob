MODULE Persistent; (* Files1 example program; TWH 940524 *)
IMPORT Out, Files1, Files;

CONST DataFile = "Persistent.Data";

TYPE
	Animal = POINTER TO AnimalDesc;
	AnimalDesc = RECORD (Files1.ObjectDesc)
		name : ARRAY 11 OF CHAR;
		attr : SET;
		legs : SHORTINT;
		next : Animal;
	END;

	FarmAnimal = POINTER TO FarmAnimalDesc;
	FarmAnimalDesc = RECORD (AnimalDesc)
		worker: BOOLEAN;
	END;

	DomesticAnimal = POINTER TO DomesticAnimalDesc;
	DomesticAnimalDesc = RECORD (AnimalDesc)
		trainable: BOOLEAN;
		furry : BOOLEAN;
	END;

VAR head : Animal;

PROCEDURE WriteBool(VAR R : Files.Rider; b : BOOLEAN);
BEGIN IF b THEN Files.Write(R, 1); ELSE Files.Write(R, 0); END;
END WriteBool;

PROCEDURE ReadBool(VAR R : Files.Rider; VAR b : BOOLEAN);
VAR i : SHORTINT;
BEGIN Files.Read(R, i); IF i = 1 THEN b := TRUE; ELSE b := FALSE; END;
END ReadBool;

PROCEDURE (o : Animal) Store(VAR R : Files.Rider);
BEGIN Files1.WriteString(R, o.name); Files1.WriteSet(R, o.attr); Files.Write(R, o.legs);
END Store;

PROCEDURE (o : Animal) Load(VAR R : Files.Rider);
BEGIN	Files1.ReadString(R, o.name); Files1.ReadSet(R, o.attr); Files.Read(R, o.legs);
END Load;

PROCEDURE (o : Animal) Print;
BEGIN Out.String(o.name); Out.Char(' '); Out.Set(o.attr); Out.Char(' '); Out.Int(o.legs, 3); Out.Char(' ');
END Print;

PROCEDURE (o : FarmAnimal) Store(VAR R : Files.Rider);
BEGIN o.Store^(R); WriteBool(R, o.worker);
END Store;

PROCEDURE (o : FarmAnimal) Load(VAR R : Files.Rider);
BEGIN o.Load^(R); ReadBool(R, o.worker);
END Load;

PROCEDURE (o : FarmAnimal) Print;
BEGIN Out.String('FarmAnimal: '); o.Print^; Out.Boolean(o.worker); Out.Ln;
END Print;

PROCEDURE (o : DomesticAnimal) Store(VAR R : Files.Rider);
BEGIN o.Store^(R); WriteBool(R, o.trainable); WriteBool(R, o.furry);
END Store;

PROCEDURE (o : DomesticAnimal) Load(VAR R : Files.Rider);
BEGIN o.Load^(R); ReadBool(R, o.trainable); ReadBool(R, o.furry);
END Load;

PROCEDURE (o : DomesticAnimal) Print;
BEGIN	Out.String('DomesticAnimal: '); o.Print^;
	Out.Boolean(o.trainable); Out.Char(' '); Out.Boolean(o.furry); Out.Ln;
END Print;

PROCEDURE BaseAssign(animal : Animal; name : ARRAY OF CHAR; attr : SET; legs : SHORTINT);
BEGIN COPY(name, animal.name); animal.attr := attr; animal.legs := legs; animal.next := NIL;
END BaseAssign;

PROCEDURE NewFarm(VAR head : Animal; name : ARRAY OF CHAR; attr : SET; legs : SHORTINT; worker : BOOLEAN);
VAR fa : FarmAnimal;
BEGIN NEW(fa); ASSERT(fa # NIL, 20); BaseAssign(fa, name, attr, legs);
	fa.worker := worker; fa.next := head; head := fa;
END NewFarm;

PROCEDURE NewDomestic(VAR head : Animal; name : ARRAY OF CHAR; attr : SET; legs : SHORTINT; train, furry : BOOLEAN);
VAR da : DomesticAnimal;
BEGIN NEW(da); ASSERT(da # NIL, 20); BaseAssign(da, name, attr, legs);
	da.trainable := train; da.furry := furry; da.next := head; head := da;
END NewDomestic;

PROCEDURE Create*;
BEGIN
	NewDomestic(head, "Boa", {}, 0, FALSE, FALSE); NewFarm(head, "Cow", {10..12}, 4, FALSE);
	NewDomestic(head, "Parakeet", {4,5}, 2, TRUE, FALSE); NewFarm(head, "Horse", {2}, 4, TRUE);
	NewDomestic(head, "Kitty", {4,5,6}, 4, FALSE, TRUE); NewFarm(head, "Chicken", {1}, 2, TRUE);
	NewDomestic(head, "Dog", {4..12}, 4, TRUE, TRUE); 
END Create;

PROCEDURE Store*;
VAR R : Files.Rider; f : Files.File; animal : Animal;
BEGIN
	f := Files.New(DataFile); ASSERT(f # NIL, 21); Files.Set(R, f, 0);
	Files1.Reset; animal := head;
	WHILE animal # NIL DO Files1.WriteObj(R, animal); animal := animal.next; END;
	Files1.WriteObj(R, NIL); Files.Register(f);
END Store;

PROCEDURE Load*;
VAR R : Files.Rider; f : Files.File; obj : Files1.Object; v, last : Animal;
BEGIN
	f := Files.Old(DataFile); ASSERT(f # NIL, 23); Files.Set(R, f, 0); Files1.Reset;

	REPEAT Files1.ReadObj(R, obj); 
		IF obj = NIL THEN v := NIL ELSE v := obj(Animal); END;
		IF last = NIL THEN head := v; ELSE last.next := v; END;
		last := v;
	UNTIL obj = NIL;
END Load;

PROCEDURE Delete*;
BEGIN head := NIL;
END Delete;

PROCEDURE Print*;
VAR c : Animal;
BEGIN c := head; WHILE c # NIL DO c.Print; c := c.next; END;
END Print;
END Persistent.
