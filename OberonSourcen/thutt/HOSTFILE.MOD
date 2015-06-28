MODULE HostFiles;
IMPORT SYSTEM, Viewers, Texts, TextFrames, MenuViewers, Oberon, OS:=MSDOS, FileDir, Files, Out;

CONST
	StandardMenu = "System.Close System.Copy System.Grow Edit.Search Edit.Store";
	BufLen = 2048;
	new = 0; old = 1;

VAR
	R	: Texts.Reader;
	S : Texts.Scanner;
	W	: Texts.Writer;
	buf : ARRAY BufLen OF SYSTEM.BYTE;

PROCEDURE ReadFilename(VAR R : Texts.Reader; VAR file : OS.Filename; VAR pos : LONGINT);
VAR i : INTEGER; ch : CHAR;
BEGIN
	ch := ' '; i := 0; WHILE ch = ' ' DO Texts.Read(R, ch); END;
	REPEAT file[i] := ch; INC(i); Texts.Read(R, ch); UNTIL (R.eot) OR (ch <= ' ') OR (i = LEN(file) - 1);
	file[i] := 0X; pos := Texts.Pos(R);
END ReadFilename;

PROCEDURE direnum(VAR info : OS.FileInfo; VAR continue : BOOLEAN);
BEGIN continue := TRUE; Texts.WriteString(W, info.name); Texts.WriteLn(W);
END direnum;

PROCEDURE Directory*; (* Directory (pathname | ^) *)
VAR 
	X, Y, i: INTEGER; ch: CHAR; 
	R: Texts.Reader; T, t: Texts.Text; V: Viewers.Viewer; beg, end, time: LONGINT;
	pat : OS.Filename;

BEGIN
	Texts.OpenReader(R, Oberon.Par.text, Oberon.Par.pos); Texts.Read(R, ch);
	WHILE ch = " " DO Texts.Read(R, ch) END;
	IF (ch = "^") OR (ch = 0DX) THEN
		Oberon.GetSelection(T, beg, end, time);
		IF time >= 0 THEN
			Texts.OpenReader(R, T, beg); Texts.Read(R, ch);
			WHILE ch <= " " DO Texts.Read(R, ch); END;
		END;
	END;
	i := 0; WHILE (ch > " ") DO pat[i] := ch; INC(i); Texts.Read(R, ch); END;
	pat[i] := 0X; i := 0;
	Oberon.AllocateUserViewer(Oberon.Par.vwr.X, X, Y); t := TextFrames.Text("");
	V := MenuViewers.New(TextFrames.NewMenu("HostFiles.Directory", StandardMenu),
											 TextFrames.NewText(t, 0), TextFrames.menuH, X, Y);
	OS.find(pat, {}, direnum); Texts.Append(t, W.buf);
END Directory;

PROCEDURE importenum(VAR info : OS.FileInfo; VAR continue : BOOLEAN);
VAR ch : CHAR; fname : FileDir.FileName; f : Files.File; hf : OS.File;
	wlen, rlen : LONGINT; r : Files.Rider; err : BOOLEAN;
BEGIN
	continue := TRUE;
	rlen := 0; WHILE info.name[rlen] # 0X DO INC(rlen); END;
	REPEAT DEC(rlen); ch := info.name[rlen]; UNTIL (ch = '/') OR (ch = '\');
	wlen := 0; INC(rlen);
	REPEAT ch := info.name[rlen]; fname[wlen] := ch; INC(rlen); INC(wlen); UNTIL ch = 0X;
	f := Files.New(fname); OS.open(info.name, hf, err);
	IF (f # NIL) & (hf.name[0] # 0X) THEN
		Files.Set(r, f, 0);
		LOOP
			OS.readbytes(hf, buf, LEN(buf), rlen); Files.WriteBytes(r, buf, rlen);
			IF rlen # LEN(buf) THEN EXIT; END;
		END;
		OS.close(hf); Files.Register(f);
	END;
END importenum;

PROCEDURE ImportFile(VAR R : Texts.Reader; VAR pos : LONGINT);
VAR fname : OS.Filename;
BEGIN ReadFilename(R, fname, pos); OS.find(fname, {}, importenum);
END ImportFile;

PROCEDURE ImportList(s : Texts.Text);
VAR R : Texts.Reader; pos, len : LONGINT;
BEGIN
	Texts.OpenReader(R, s, 0); len := s.len; pos := Texts.Pos(R);
	WHILE (pos < len) & ~R.eot DO ImportFile(R, pos); END;
END ImportList;

PROCEDURE Import*; (* Import (pathname ~ | * | ^) *)
VAR v : Viewers.Viewer; input : Texts.Text; pos, beg, end, time : LONGINT;
BEGIN
	Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
	IF S.class = Texts.Char THEN
		IF S.c = '*' THEN
			v := Oberon.MarkedViewer();
			IF (v.dsc # NIL) & (v.dsc.next IS TextFrames.Frame) THEN
				input := v.dsc.next(TextFrames.Frame).text; ImportList(input);
			END;
		ELSIF S.c = '^' THEN
			Oberon.GetSelection(input, beg, end, time);
			IF time >= 0 THEN
				Texts.OpenReader(R, input, beg); pos := Texts.Pos(R);
				WHILE pos < end DO ImportFile(R, pos); END;
			END
		END;
	ELSE
		pos := Oberon.Par.pos;
		LOOP
			Texts.OpenReader(R, Oberon.Par.text, pos); ImportFile(R, pos);
			IF R.eot THEN EXIT; END;
			Texts.OpenScanner(S, Oberon.Par.text, pos); Texts.Scan(S);
			IF (S.class = Texts.Inval) OR (S.class = Texts.Char) & (S.c = '~') THEN EXIT; END;
		END;
	END;
END Import;

PROCEDURE ExportFile(VAR dir : OS.Filename; VAR R : Texts.Reader; VAR pos : LONGINT);
VAR hf : OS.File; fileN, fname : OS.Filename; f : Files.File; r : Files.Rider;
	i,j : LONGINT; res : INTEGER; ch : CHAR; err : BOOLEAN; file : FileDir.FileName;
BEGIN 
	ReadFilename(R, fname, pos); fileN := dir;
	i := 0; REPEAT ch := fname[i]; file[i] := ch; INC(i); UNTIL ch = 0X; (* create Oberon filename *)
	i := 0; REPEAT INC(i); UNTIL fileN[i] = 0X; (* find end of directory name *)
	IF i > 0 THEN
		ch := fileN[i - 1]; IF (ch # '/') & (ch # '\') THEN fileN[i] := '\'; INC(i); END;
	END;
	j := 0; REPEAT ch := fname[j]; fileN[i] := ch; INC(j); INC(i); UNTIL (ch = 0X) OR (i = LEN(fileN));
	ASSERT(ch = 0X, 20);

	f := Files.Old(file); OS.create(fileN, {}, hf, err);

	IF (f # NIL) & (hf.name[0] # 0X) THEN
		Files.Set(r, f, 0);
		LOOP
			i := LEN(buf); Files.ReadBytes(r, buf, i);
			IF r.eof THEN DEC(i, r.res); END;
			OS.writebytes(hf, buf, i, res); 
			IF r.eof OR (res # 0) THEN EXIT; END;
		END;
		OS.close(hf); Files.Close(f);
	END;
	IF err OR (res # 0) & ~r.eof THEN Out.String("Export failure: "); Out.String(fname); END;
END ExportFile;

PROCEDURE ExportList(VAR dir : OS.Filename; s : Texts.Text);
VAR R : Texts.Reader; pos, len : LONGINT;
BEGIN
	Texts.OpenReader(R, s, 0); len := s.len; pos := Texts.Pos(R);
	WHILE (pos < len) & ~R.eot DO ExportFile(dir, R, pos); END;
END ExportList;

PROCEDURE Export*; (* Export destdir (filename ~ | * | ^) *)
VAR 
	R : Texts.Reader; v : Viewers.Viewer; input : Texts.Text; 
	pos, beg, end, time : LONGINT; ch : CHAR; dir : OS.Filename;
BEGIN
	pos := Oberon.Par.pos; Texts.OpenReader(R, Oberon.Par.text, pos); ReadFilename(R, dir, pos);
	Texts.OpenScanner(S, Oberon.Par.text, pos); Texts.Scan(S);
	IF S.class = Texts.Char THEN
		IF S.c = '*' THEN
			v := Oberon.MarkedViewer();
			IF (v.dsc # NIL) & (v.dsc.next IS TextFrames.Frame) THEN
				input := v.dsc.next(TextFrames.Frame).text; ExportList(dir, input);
			END;
		ELSIF S.c = '^' THEN
			Oberon.GetSelection(input, beg, end, time);
			IF time >= 0 THEN
				Texts.OpenReader(R, input, beg); pos := Texts.Pos(R);
				WHILE pos < end DO ExportFile(dir, R, pos); END;
			END
		END;
	ELSE
		LOOP
			Texts.OpenReader(R, Oberon.Par.text, pos); ExportFile(dir, R, pos);
			IF R.eot THEN EXIT; END;
			Texts.OpenScanner(S, Oberon.Par.text, pos); Texts.Scan(S);
			IF (S.class = Texts.Inval) OR (S.class = Texts.Char) & (S.c = '~') THEN EXIT; END;
		END;
	END;
END Export;

BEGIN Texts.OpenWriter(W);
END HostFiles.
