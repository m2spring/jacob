MODULE SortDemo; (* W.Weck 21 Jan 93, SmoothSort due to E.W.Dijkstra, J.Gutknecht *)
IMPORT Oberon, MenuViewers, Viewers, TextFrames, Texts, Display, Input;

CONST
	MinLeft = 20; PerSec = 300; WaitCnt = 25; MousePollFreq = 4;
	N = 600; Size = 1; DotN = N DIV 4; DotSize = Size * 4;
	Menu = "System.Close  System.Grow ";

TYPE
	Data = POINTER TO DataDesc;
	DataDesc = RECORD
	  len: INTEGER;
  	list, lastRandom: ARRAY N OF INTEGER
	END;

	Frame = POINTER TO FrameDesc;
	FrameDesc = RECORD(Display.FrameDesc)
  	data: Data;
  	updateReorder: PROCEDURE (f: Frame);
  	updateSwap: PROCEDURE (f: Frame; i, j: INTEGER);
  	modify: PROCEDURE (f: Frame; id, dy, y, h: INTEGER)
	END;

	ReorderMsg = RECORD(Display.FrameMsg)
		data: Data
	END;

	SwapMsg = RECORD(Display.FrameMsg)
		data: Data;
		i, j: INTEGER
	END;

VAR
	seed, delay, comparisons, swaps, time: LONGINT;
	w: Texts.Writer;

(* Frames *)

PROCEDURE ReplConst(f: Display.FrameDesc; col, x, y, w, h, mode: INTEGER);
VAR a: INTEGER;
BEGIN
  a := f.X - x; IF a > 0 THEN x := f.X; w := w - a END;
  a := f.X + f.W - x; IF a < w THEN w := a END;
  a := f.Y - y; IF a > 0 THEN y := f.Y; h := h - a END;
  a := f.Y + f.H - y; IF a < h THEN h := a END;
  IF (w > 0) & (h > 0) THEN Display.ReplConst(col, x, y, w, h, mode) END
END ReplConst;

PROCEDURE* UpdateReorder(f: Frame);
VAR left, x0, y0, i: INTEGER; data: Data;
BEGIN Oberon.RemoveMarks(f.X, f.Y, f.W, f.H);
	left := (f.W - N * Size - 2) DIV 2;
	IF left < MinLeft THEN left := MinLeft END;
	x0 := f.X + left; y0 := f.Y + f.H - MinLeft - N * Size + 1;
	ReplConst(f^, Display.black, x0, y0, N * Size, N * Size, Display.replace);
	i := N; data := f.data;
	REPEAT DEC(i);
		ReplConst(f^, Display.white, x0 + i * Size, y0, Size, (data.list[i] + 1) * Size, Display.replace)
	UNTIL i = 0
END UpdateReorder;

PROCEDURE* UpdateSwap(f: Frame; i, j: INTEGER);
	VAR left, x0, y0, hi, hj, h: INTEGER;
BEGIN Oberon.RemoveMarks(f.X, f.Y, f.W, f.H);
	left := (f.W - N * Size - 2) DIV 2;
	IF left < MinLeft THEN left := MinLeft END;
	x0 := f.X + left; y0 := f.Y + f.H - MinLeft - N * Size + 1;
	hi := (f.data.list[i] + 1) * Size; hj := (f.data.list[j] + 1) * Size;
	IF hi < hj THEN y0 := y0 + hi; h := hj - hi ELSE y0 := y0 + hj; h := hi - hj END;
	ReplConst(f^, Display.white, x0 + i * Size, y0, Size, h, Display.invert);
	ReplConst(f^, Display.white, x0 + j * Size, y0, Size, h, Display.invert)
END UpdateSwap;

PROCEDURE* Modify(f: Frame; id, dy, y, h: INTEGER);
	VAR x0, y0, i, left: INTEGER; data: Data; clip: Display.FrameDesc;
BEGIN
	IF id = MenuViewers.reduce THEN
		IF dy # 0 THEN Display.CopyBlock(f.X, f.Y + dy, f.W, h, f.X, y, Display.replace) END;
		f.Y := y; f.H := h
	ELSE
		IF dy # 0 THEN Display.CopyBlock(f.X, f.Y, f.W, f.H, f.X, f.Y + dy, Display.replace) END;
		clip.X := f.X; clip.W := f.W; clip.Y := y; clip.H := h - f.H;
		f.Y := y; f.H := h;

		left := (f.W - N * Size - 2) DIV 2;
		IF left < MinLeft THEN left := MinLeft END;
		x0 := f.X + left; y0 := f.Y + f.H - MinLeft - N * Size + 1;
		ReplConst(clip, Display.black, f.X, f.Y, f.W, f.H, Display.replace);
		ReplConst(clip, Display.white, x0 - 1, y0 - 1, N * Size + 2, 1, Display.replace);
		ReplConst(clip, Display.white, x0 - 1, y0 + N * Size, N * Size + 2, 1, Display.replace);
		ReplConst(clip, Display.white, x0 - 1, y0, 1, N * Size + 1, Display.replace);
		ReplConst(clip, Display.white, x0 + N * Size, y0, 1, N * Size + 1, Display.replace);
		i := N; data := f.data;
		REPEAT DEC(i);
			ReplConst(clip, Display.white, x0 + i * Size, y0, Size, (data.list[i] + 1) * Size, Display.replace)
		UNTIL i = 0
	END
END Modify;

PROCEDURE* UpdateReorderDotView(f: Frame);
	VAR left, x0, y0, i: INTEGER; data: Data;
BEGIN Oberon.RemoveMarks(f.X, f.Y, f.W, f.H);
	left := (f.W - DotN * DotSize - 2) DIV 2;
	IF left < MinLeft THEN left := MinLeft END;
	x0 := f.X + left; y0 := f.Y + f.H - MinLeft - DotN * DotSize + 1;
	ReplConst(f^, Display.black, x0, y0, DotN * DotSize, DotN * DotSize, Display.replace);
	i := DotN; data := f.data;
	REPEAT DEC(i);
		ReplConst(f^, Display.white, x0 + i * DotSize, y0 + data.list[i] * DotSize, DotSize, DotSize, Display.replace)
	UNTIL i = 0
END UpdateReorderDotView;

PROCEDURE* UpdateSwapDotView(f: Frame; i, j: INTEGER);
	VAR left, x0, y0, xi, yi, xj, yj: INTEGER;
BEGIN Oberon.RemoveMarks(f.X, f.Y, f.W, f.H);
	left := (f.W - DotN * DotSize - 2) DIV 2;
	IF left < MinLeft THEN left := MinLeft END;
	x0 := f.X + left; y0 := f.Y + f.H - MinLeft - DotN * DotSize + 1;
	xi := x0 + i * DotSize; yi := y0 + f.data.list[i] * DotSize;
	xj := x0 + j * DotSize; yj := y0 + f.data.list[j] * DotSize;
	ReplConst(f^, Display.white, xi, yj, DotSize, DotSize, Display.invert);
	ReplConst(f^, Display.white, xj, yi, DotSize, DotSize, Display.invert);
	ReplConst(f^, Display.white, xi, yi, DotSize, DotSize, Display.invert);
	ReplConst(f^, Display.white, xj, yj, DotSize, DotSize, Display.invert)
END UpdateSwapDotView;

PROCEDURE* ModifyDotView(f: Frame; id, dy, y, h: INTEGER);
	VAR x0, y0, i, left: INTEGER; data: Data; clip: Display.FrameDesc;
BEGIN
	IF id = MenuViewers.reduce THEN
		IF dy # 0 THEN Display.CopyBlock(f.X, f.Y + dy, f.W, h, f.X, y, Display.replace) END;
		f.Y := y; f.H := h
	ELSE
		IF dy # 0 THEN Display.CopyBlock(f.X, f.Y, f.W, f.H, f.X, f.Y + dy, Display.replace) END;
		clip.X := f.X; clip.W := f.W; clip.Y := y; clip.H := h - f.H;
		f.Y := y; f.H := h;

		left := (f.W - DotN * DotSize - 2) DIV 2;
		IF left < MinLeft THEN left := MinLeft END;
		x0 := f.X + left; y0 := f.Y + f.H - MinLeft - DotN * DotSize + 1;
		ReplConst(clip, Display.black, f.X, f.Y, f.W, f.H, Display.replace);
		ReplConst(clip, Display.white, x0 - 1, y0 - 1, DotN * DotSize + 2, 1, Display.replace);
		ReplConst(clip, Display.white, x0 - 1, y0 + DotN * DotSize, DotN * DotSize + 2, 1, Display.replace);
		ReplConst(clip, Display.white, x0 - 1, y0, 1, DotN * DotSize + 1, Display.replace);
		ReplConst(clip, Display.white, x0 + DotN * DotSize, y0, 1, DotN * DotSize + 1, Display.replace);
		i := DotN; data := f.data;
		REPEAT DEC(i);
			ReplConst(clip, Display.white, x0 + i * DotSize, y0 + data.list[i] * DotSize, DotSize, DotSize, Display.replace)
		UNTIL i = 0
	END
END ModifyDotView;

PROCEDURE CopyOf(f: Frame): Frame;
	VAR c: Frame;
BEGIN NEW(c); c.data := f.data;
	c.handle := f.handle;
	c.updateReorder := f.updateReorder; c.updateSwap := f.updateSwap; c.modify := f.modify;
	RETURN c
END CopyOf;

PROCEDURE* Handler(f: Display.Frame; VAR m: Display.FrameMsg);
	VAR self: Frame;
BEGIN self := f(Frame);
	IF m IS ReorderMsg THEN
		IF m(ReorderMsg).data = self.data THEN self.updateReorder(self) END
	ELSIF m IS SwapMsg THEN
		WITH m: SwapMsg DO
			IF m.data = self.data THEN self.updateSwap(self, m.i, m.j) END
		END
	ELSIF m IS MenuViewers.ModifyMsg THEN
		WITH m: MenuViewers.ModifyMsg DO self.modify(self, m.id, m.dY, m.Y, m.H) END
	ELSIF m IS Oberon.CopyMsg THEN m(Oberon.CopyMsg).F := CopyOf(self)
	ELSIF m IS Oberon.InputMsg THEN
		WITH m: Oberon.InputMsg DO
			IF m.id = Oberon.track THEN Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, m.X, m.Y) END
		END
	END
END Handler;

(* Data manipulations *)

PROCEDURE Less(data: Data; i, j: INTEGER): BOOLEAN;
VAR x, y: INTEGER; keys: SET;
BEGIN
	x := SHORT(delay);
	WHILE x # 0 DO
		DEC(x); y := WaitCnt * N DIV data.len;
		REPEAT DEC(y) UNTIL y = 0;
	END;
	IF comparisons MOD MousePollFreq = 0 THEN
		REPEAT Input.Mouse(keys, x, y) UNTIL keys = {}
	END;
	INC(comparisons);
	RETURN data.list[i] < data.list[j]
END Less;

PROCEDURE Swap(data: Data; i, j: INTEGER);
	VAR x: INTEGER; msg: SwapMsg;
BEGIN x := data.list[i]; data.list[i] := data.list[j]; data.list[j] := x;
	INC(swaps);
	msg.data := data; msg.i := i; msg.j := j; Viewers.Broadcast(msg);
END Swap;

(* auxiliary *)

PROCEDURE ParameterData(): Data;
	VAR l: Data; v: Viewers.Viewer;
BEGIN
	IF Oberon.Par.vwr.dsc = Oberon.Par.frame THEN
		IF (Oberon.Par.frame # NIL) & (Oberon.Par.frame.next # NIL) & (Oberon.Par.frame.next IS Frame) THEN
			l := Oberon.Par.frame.next(Frame).data
		END
	ELSE v := Oberon.MarkedViewer();
		IF (v.dsc # NIL) & (v.dsc.next # NIL) & (v.dsc.next IS Frame) THEN l := v.dsc.next(Frame).data END
	END;
	RETURN l
END ParameterData;

PROCEDURE ParInteger(): LONGINT;
	VAR text: Texts.Text; beg, end, time: LONGINT; s: Texts.Scanner;
BEGIN Texts.OpenScanner(s, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(s);
	IF (s.line = 0) & (s.class = Texts.Char) & (s.c = "^") THEN Oberon.GetSelection(text, beg, end, time);
		IF time >= 0 THEN Texts.OpenScanner(s, text, beg); Texts.Scan(s) END
	END;
	IF (s.line = 0) & (s.class = Texts.Int) THEN RETURN s.i ELSE RETURN -1 END
END ParInteger;


PROCEDURE Start;
BEGIN comparisons := 0; swaps := 0; time := Oberon.Time()
END Start;

PROCEDURE Stop(name: ARRAY OF CHAR);
	VAR t: LONGINT;
BEGIN t := Oberon.Time();
	Texts.WriteString(w, name); Texts.WriteString(w, ": ");
	Texts.WriteInt(w, comparisons, 0); Texts.WriteString(w, " comparisons, ");
	Texts.WriteInt(w, swaps , 0); Texts.WriteString(w, " swaps, ");
	t := (t - time) * 100 DIV PerSec;
	Texts.WriteInt(w, t DIV 100, 0); Texts.Write(w, "."); Texts.WriteInt(w, t DIV 10 MOD 10, 0);
	Texts.WriteInt(w, t MOD 10, 0); Texts.WriteString(w, " sec");
	Texts.WriteLn(w); Texts.Append(Oberon.Log, w.buf)
END Stop;

(* commands *)

PROCEDURE NewData(size: INTEGER): Data;
	VAR i: INTEGER; data: Data;
BEGIN NEW(data); data.len := size; i := size;
	REPEAT DEC(i); data.list[i] := i UNTIL i = 0;
	data.lastRandom := data.list;
	RETURN data
END NewData;

PROCEDURE Open*;
	VAR x, y: INTEGER; f: Frame; v: MenuViewers.Viewer;
BEGIN NEW(f); f.handle := Handler; f.data := NewData(N);
	f.updateReorder := UpdateReorder; f.updateSwap := UpdateSwap; f.modify := Modify;
	Oberon.AllocateUserViewer(Oberon.Mouse.X, x, y);
	v := MenuViewers.New(TextFrames.NewMenu("SortDemo", Menu), f, TextFrames.menuH, x, y)
END Open;

PROCEDURE OpenDotView*;
	VAR x, y: INTEGER; f: Frame; v: MenuViewers.Viewer;
BEGIN NEW(f); f.handle := Handler; f.data := NewData(DotN);
	f.updateReorder := UpdateReorderDotView; f.updateSwap := UpdateSwapDotView; f.modify := ModifyDotView;
	Oberon.AllocateUserViewer(Oberon.Mouse.X, x, y);
	v := MenuViewers.New(TextFrames.NewMenu("SortDemo", Menu), f, TextFrames.menuH, x, y)
END OpenDotView;

PROCEDURE SetCompareCost*;
	VAR x: LONGINT;
BEGIN x := ParInteger();
	IF x >= 0 THEN delay := x END;
	Texts.WriteString(w, "SortDemo.SetCompareCost "); Texts.WriteInt(w, delay, 0); Texts.WriteLn(w);
	Texts.Append(Oberon.Log, w.buf)
END SetCompareCost;

(* pre ordering *)

PROCEDURE Randomize*;
	CONST a = 16807; m = 2147483647; q = m DIV a; r = m MOD a;
	VAR i, n: LONGINT; k, l, x, len: INTEGER; data: Data; msg: SwapMsg;
BEGIN data := ParameterData();
	IF data # NIL THEN len := data.len; n := ParInteger();
		IF n > 0 THEN
			REPEAT DEC(n);
				i := a * (seed MOD q) - r * (seed DIV q);
				IF i > 0 THEN seed := i ELSE seed := i + m END;
				k := SHORT(seed MOD len); l := SHORT((seed DIV len) MOD len);
				x := data.list[k]; data.list[k] := data.list[l]; data.list[l] := x;
				msg.data := data; msg.i := k; msg.j := l; Viewers.Broadcast(msg)
			UNTIL n = 0;
			data.lastRandom := data.list
		END
	END
END Randomize;

PROCEDURE Recall*;
	VAR data: Data; msg: ReorderMsg;
BEGIN data := ParameterData();
	IF data # NIL THEN data.list := data.lastRandom;
		msg.data := data; Viewers.Broadcast(msg)
	END
END Recall;

PROCEDURE ReverseOrder*;
	VAR i, len: INTEGER; data: Data; msg: ReorderMsg;
BEGIN data := ParameterData();
	IF data # NIL THEN len := data.len; i := len;
		REPEAT DEC(i); data.list[i] := len - 1 - i UNTIL i = 0;
		msg.data := data; Viewers.Broadcast(msg)
	END
END ReverseOrder;

PROCEDURE QuickWorstOrder*;
	VAR i, j, m, x, len: INTEGER; data: Data; msg: ReorderMsg;
BEGIN data := ParameterData();
	IF data # NIL THEN len := data.len; i := len;
		REPEAT DEC(i); data.list[i] := i UNTIL i = 0;
		i := (len - 1) DIV 2; j := i;
		WHILE j < len - 1 DO INC(j); m := (i + j) DIV 2;
			x := data.list[j]; data.list[j] := data.list[m]; data.list[m] := x;
			IF i > 0 THEN DEC(i); m := (i + j) DIV 2;
				x := data.list[i]; data.list[i] := data.list[m]; data.list[m] := x
			END
		END;
		msg.data := data; Viewers.Broadcast(msg)
	END
END QuickWorstOrder;

(* sorters *)

PROCEDURE Bubble*;
	VAR swapped: BOOLEAN; i, n: INTEGER; data: Data;
BEGIN data := ParameterData();
	IF data # NIL THEN Start;
		 n := data.len;
		 REPEAT swapped := FALSE; i := 1;
			 WHILE i < n DO
				 IF Less(data, i, i - 1) THEN Swap(data, i, i - 1); swapped := TRUE END;
				 INC(i)
			 END
		 UNTIL ~swapped;
		Stop("SortDemo.Bubble")
	END
END Bubble;

PROCEDURE MinSearch*;
	VAR i, j, min, len: INTEGER; data: Data;
BEGIN data := ParameterData();
	IF data # NIL THEN len := data.len; Start;
		i := 0;
		WHILE i < len DO min := i; j := i + 1;
			WHILE j < len DO
				IF Less(data, j, min) THEN min := j END;
				INC(j)
			END;
			IF i # min THEN Swap(data, i, min) END;
			INC(i)
		END;
		Stop("SortDemo.MinSearch")
	END
END MinSearch;

PROCEDURE Insert*;
	VAR i, lo, hi, m: INTEGER; data: Data;
BEGIN data := ParameterData();
	IF data # NIL THEN Start;
		i := 1;
		WHILE i < data.len DO lo := 0; hi := i;
			WHILE lo # hi DO m := (lo + hi) DIV 2;
				IF ~Less(data, i, m) THEN lo := m + 1 ELSE hi := m END
			END;
			m := i;
			WHILE m > hi DO Swap(data, m - 1, m); DEC(m) END;
			INC(i)
		END;
		Stop("SortDemo.Insert")
	END
END Insert;

PROCEDURE Shell*;
	VAR i, j, h, len: INTEGER; data: Data;
BEGIN data := ParameterData();
	IF data # NIL THEN len := data.len; Start;
		i := 4; h := 1;
		WHILE i < len DO i := i * 2; h := 2 * h + 1 END;
		WHILE h # 0 DO i := h;
			WHILE i < len DO j := i - h;
				WHILE (j >= 0) & Less(data, j + h, j) DO Swap(data, j, j + h); j := j - h END;
				INC(i)
			END;
			h := (h - 1) DIV 2
		END;
		Stop("SortDemo.Shell")
	END
END Shell;

PROCEDURE Quick*;
	VAR data: Data;

	PROCEDURE Sort(lo, hi: INTEGER);
		VAR i, j, m: INTEGER;
	BEGIN
		IF lo < hi THEN i := lo; j := hi; m := (lo + hi) DIV 2;
			REPEAT
				WHILE Less(data, i, m) DO INC(i) END;
				WHILE Less(data, m, j) DO DEC(j) END;
				IF i <= j THEN
					IF m = i THEN m := j ELSIF m = j THEN m := i END;
					Swap(data, i, j); INC(i); DEC(j)
				END
			UNTIL i > j;
			Sort(lo, j); Sort(i, hi)
		END
	END Sort;

BEGIN data := ParameterData();
	IF data # NIL THEN Start; Sort(0, data.len - 1); Stop("SortDemo.Quick") END
END Quick;

PROCEDURE Heap*;
VAR l, r: INTEGER; data: Data;

	PROCEDURE Sift(l, r: INTEGER);
		VAR i, j: INTEGER;
	BEGIN
		i := l; j := 2 * l + 1;
		IF (j + 1 < r) & Less(data, j, j + 1) THEN INC(j) END;
		WHILE (j < r) & ~Less(data, j, i) DO Swap(data, i, j); i := j; j := 2 * j + 1;
			IF (j + 1 < r) & Less(data, j, j + 1) THEN INC(j) END
		END
	END Sift;

BEGIN data := ParameterData();
	IF data # NIL THEN Start;
		r := data.len; l := r DIV 2;
		WHILE l > 0 DO DEC(l); Sift(l, r) END;
		WHILE r > 0 DO DEC(r); Swap(data, 0, r); Sift(0, r) END;
		Stop("SortDemo.Heap")
	END
END Heap;

PROCEDURE Smooth*;
	VAR q, r, p, b, c, len: INTEGER; data: Data;

	PROCEDURE Up(VAR b, c: INTEGER);
		VAR b1: INTEGER;
	BEGIN b1 := b; b := b + c + 1; c := b1
	END Up;

	PROCEDURE Down(VAR b, c: INTEGER);
		VAR c1: INTEGER;
	BEGIN c1 := c; c := b - c - 1; b := c1
	END Down;

	PROCEDURE Sift(r, b, c: INTEGER);
		VAR r1: INTEGER;
	BEGIN
		WHILE b >= 3 DO r1 := r - b + c;
			IF Less(data, r1, r - 1) THEN r1 := r - 1; Down(b, c) END;
			IF Less(data, r, r1) THEN Swap(data, r, r1); r := r1; Down(b, c)
			ELSE b := 1
			END
		END
	END Sift;

	PROCEDURE Trinkle(r, p, b, c: INTEGER);
		VAR r1, r2: INTEGER;
	BEGIN
		WHILE p > 0 DO
			WHILE ~ODD(p) DO p := p DIV 2; Up(b, c) END;
			r2 := r - b;
			IF (p = 1) OR ~Less(data, r, r2) THEN p := 0
			ELSE p := p - 1;
				IF b = 1 THEN Swap(data, r, r2); r := r2
				ELSE r1 := r - b + c;
					IF Less(data, r1, r - 1) THEN r1 := r - 1; Down(b, c); p := p * 2 END;
					IF ~Less(data, r2, r1) THEN Swap(data, r, r2); r := r2
					ELSE Swap(data, r, r1); r := r1; Down(b, c); p := 0
					END
				END
			END
		END;
		Sift(r, b, c)
	END Trinkle;

	PROCEDURE SemiTrinkle(r, p, b, c: INTEGER);
		VAR r1: INTEGER;
	BEGIN r1 := r - c;
		IF Less(data, r, r1) THEN Swap(data, r, r1); Trinkle(r1, p, b, c) END
	END SemiTrinkle;

BEGIN data := ParameterData();
	IF data # NIL THEN len := data.len; Start;
		q := 1; r := 0; p := 1; b := 1; c := 1;
		WHILE q # len DO
			IF p MOD 8 = 3 (* p = ... 011 *) THEN Sift(r, b, c);
				p := (p + 1) DIV 4; Up(b, c); Up(b, c) (* b >= 3 *)
			ELSE (* p = ... 01 *)
				IF (q + c) < len THEN Sift(r, b, c) ELSE Trinkle(r, p, b, c) END;
				Down(b, c); p := p * 2;
				WHILE b # 1 DO Down(b, c); p := p * 2 END;
				p := p + 1
			END;
			q := q + 1; r := r + 1
		END;
		Trinkle(r, p, b, c);
		WHILE q # 1 DO q := q - 1; p := p - 1;
			IF b = 1 THEN r := r - 1;
				WHILE ~ODD(p) DO p := p DIV 2; Up(b, c) END
			ELSE (* b >= 3 *) r := r - b + c;
				IF p > 0 THEN SemiTrinkle(r, p, b, c) END;
				Down(b, c); p := p * 2 + 1; r := r + c;
				SemiTrinkle(r, p, b, c); Down(b, c); p := p * 2 + 1
			END
		END;
		Stop("SortDemo.Smooth")
	END
END Smooth;

BEGIN seed := Oberon.Time(); Texts.OpenWriter(w); delay := 100
END SortDemo.


SortDemo.Tool
SortDemo.Open							 open new viewer for demonstrations
SortDemo.OpenDotView

SortDemo.SetCompareCost ^	0	10	100	400	1000
													set delay for comparisons

SortDemo.Randomize ^ *		1	10	50	200	500	1000	1500
												 transpose a certain number of elements

SortDemo.Recall *					 reestablish disorder generated by last
												 call to SortDemo.Randomize
SortDemo.ReverseOrder *			bring into reverse order
SortDemo.QuickWorstOrder *	 bring into worst order for quick sort

several standard sorting algorithms:
(the animation freezes while any mouse key is held down)

	SortDemo.Bubble *
	SortDemo.MinSearch *

	SortDemo.Insert *

	SortDemo.Shell *
	SortDemo.Quick *
	SortDemo.Heap *
	SortDemo.Smooth *

