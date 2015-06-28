MODULE Input;   (*NW 5.10.86 / 15.11.90   Ceres-2*)
   IMPORT SYSTEM, Kernel;

   CONST N = 32;
      MOUSE = 0FFFFB000H; UART = 0FFFFC000H; ICU = 0FFFF9000H;

   VAR MW, MH: INTEGER; (*mouse limits*)
      T: LONGINT;  (*time counter*)
      n, in, out: INTEGER;
      buf: ARRAY N OF CHAR;

   PROCEDURE Available*(): INTEGER;
   BEGIN RETURN n
   END Available;

   PROCEDURE Read*(VAR ch: CHAR);
   BEGIN
      REPEAT UNTIL n > 0;
      DEC(n); ch := buf[out]; out := (out+1) MOD N
   END Read;

   PROCEDURE Mouse*(VAR keys: SET; VAR x, y: INTEGER);
      VAR u: LONGINT;
   BEGIN SYSTEM.GET(MOUSE, u);
      keys := {0,1,2} - SYSTEM.VAL(SET, u DIV 1000H MOD 8);
      x := SHORT(u MOD 1000H) MOD MW;
      y := SHORT(u DIV 10000H) MOD 819;
      IF y >= MH THEN y := 0 END
   END Mouse;

   PROCEDURE SetMouseLimits*(w, h: INTEGER);
   BEGIN MW := w; MH := h
   END SetMouseLimits;

   PROCEDURE Time*(): LONGINT;
      VAR lo, lo1, hi: CHAR; t: LONGINT;
   BEGIN
      REPEAT SYSTEM.GET(UART+28, lo); SYSTEM.GET(UART+24, hi);
         t := T - LONG(ORD(hi))*256 - ORD(lo); SYSTEM.GET(UART+28, lo1)
      UNTIL lo1 = lo;
      RETURN t
   END Time;

   PROCEDURE KBINT;
      VAR ch: CHAR;
   BEGIN SYSTEM.GET(UART+12, ch);  (*RHRA*)
      IF ch = 0FFX THEN HALT(24) END ;
      IF (n < N) & ((ch < 0C8X) OR (ch > 0CCX)) THEN
         buf[in] := ch; in := (in+1) MOD N; INC(n)
      END
   END KBINT;

   PROCEDURE CTInt;
      VAR dmy: CHAR;
   BEGIN SYSTEM.GET(UART+60, dmy); (*stop timer*)
      INC(T, 0FFFFH); SYSTEM.GET(UART+56, dmy)
   END CTInt;

BEGIN MW := 1024; MH := 800;
   n := 0; in := 0; out := 0; T := 0FFFFH;
   Kernel.InstallIP(KBINT, 4); Kernel.InstallIP(CTInt, 0);
   SYSTEM.PUT(UART+16, 10X);  (*ACR*)
   SYSTEM.PUT(UART+ 8, 15X);  (*CRA enable*)
   SYSTEM.PUT(UART,    13X);  (*MR1A, RxRdy -Int, no parity, 8 bits*)
   SYSTEM.PUT(UART,     7X);  (*MR2A  1 stop bit*)
   SYSTEM.PUT(UART+ 4, 44X);  (*CSRA, rate = 300 bps*)
   SYSTEM.PUT(UART+52, 14X);  (*OPCR  OP4 = KB and OP3 = C/T int*)
   SYSTEM.PUT(UART+28, 0FFX); (*CTLR*)
   SYSTEM.PUT(UART+24, 0FFX); (*CTUR*)
   SYSTEM.GET(UART+56, buf[0]);  (*start timer*)
   SYSTEM.PUT(ICU + 4, 18X);  (*clear ICU IMR and IRR bits 0*)
   SYSTEM.PUT(ICU + 4, 1CX);  (*clear ICU IMR and IRR bits 4*)
END Input.
