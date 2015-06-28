MODULE SCC;  (*NW 13.11.87 / 25.8.91  Ceres-2*)
   IMPORT SYSTEM, Kernel;

   CONST BufLen = 2048;
      com = 0FFFFD008H; (*commands and status, SCC channel A*)
      dat = 0FFFFD00CH;
      DIPS   = 0FFFFFC00H;
      ICU    = 0FFFF9004H;
      RxCA = 0;  (*R0: Rx Char Available*)
      TxBE = 2;  (*R0: Tx Buffer Empty*)
      Hunt = 4;  (*R0: Sync/Hunt*)
      TxUR = 6;  (*R0: Tx UnderRun*)
      RxOR = 5;  (*R1: Rx OverRun*)
      CRC  = 6;  (*R1: CRC error*)
      EOF  = 7;  (*R1: End Of Frame*)

   TYPE Header* =
      RECORD valid*: BOOLEAN;
         dadr*, sadr*, typ*: SHORTINT;
         len*: INTEGER; (*of data following header*)
         destLink*, srcLink*: INTEGER  (*link numbers*)
      END ;

   VAR in, out: INTEGER;
      Adr: SHORTINT;
      SCCR3: CHAR;
      buf: ARRAY BufLen OF CHAR;

   PROCEDURE PUT(r: SHORTINT; x: SYSTEM.BYTE);
   BEGIN SYSTEM.PUT(com, r); SYSTEM.PUT(com, x)
   END PUT;

   PROCEDURE Int1;
      VAR del, oldin: INTEGER; stat: SET; dmy: CHAR;
   BEGIN SYSTEM.GET(dat, buf[in]);
      PUT(1, 0X); (*disable interrupts*)
      oldin := in; in := (in+1) MOD BufLen; del := 16;
      LOOP
         IF SYSTEM.BIT(com, RxCA) THEN del := 16;
            IF in # out THEN SYSTEM.GET(dat, buf[in]); in := (in+1) MOD BufLen
            ELSE SYSTEM.GET(dat, dmy)
            END
         ELSE SYSTEM.PUT(com, 1X); DEC(del);
            IF SYSTEM.BIT(com, EOF) & (del <= 0) OR (del <= -16) THEN EXIT END
         END
      END ;
      SYSTEM.PUT(com, 1X); SYSTEM.GET(com, stat);
      IF (RxOR IN stat) OR (CRC IN stat) OR (in = out) THEN
         in := oldin  (*reset buffer*)
      ELSE in := (in-2) MOD BufLen     (*remove CRC*)
      END ;
      SYSTEM.PUT(com, 30X);  (*error reset*)
      SYSTEM.PUT(com, 10X);  (*reset ext/stat interrupts*)
      PUT( 1,   8X);  (*enable Rx-Int on 1st char*)
      SYSTEM.PUT(com, 20X);  (*enable Rx-Int on next char*)
      PUT( 3, SCCR3);  (*enter hunt mode*)
   END Int1;

   PROCEDURE Start*(filter: BOOLEAN);
   BEGIN in := 0; out := 0;
      IF filter THEN SCCR3 := 0DDX ELSE SCCR3 := 0D9X END ;
      SYSTEM.GET(DIPS, Adr); Adr := Adr MOD 40H;
      Kernel.InstallIP(Int1, 1);
      PUT( 9,  80X);  (*reset A, disable all interrupts*)
      PUT( 4,  20X);  (*SDLC mode*)
      PUT( 1,   0X);  (*disable all interrupts*)
      PUT( 2,   0X);  (*interrupt vector*)
      PUT( 3, SCCR3);  (*8bit, hunt mode, Rx-CRC on, adr search, Rx off*)
      PUT( 5, 0E1X);  (*8bit, SDLC, Tx-CRC on, Tx off*)
      PUT( 6,  Adr);  (*SDLC-address*)
      PUT( 7,  7EX);  (*SDLC flag*)
      PUT( 9,   6X);  (*master int on, no vector*)
      PUT(10, 0E0X);  (*FM0*)
      PUT(11, 0F7X);  (*Xtal, RxC = DPLL TxC = rate genL*)
      PUT(12,   6X);  (*lo byte of rate gen: Xtal DIV 16*)
      PUT(13,   0X);  (*hi byte of rate gen*)
      PUT(14, 0A0X);  (*DPLL = Xtal*)
      PUT(14, 0C0X);  (*FM mode*)
      PUT( 3, SCCR3);  (*Rx enable, enter hunt mode*)
      SYSTEM.PUT(com, 80X);  (*TxCRC reset*)
      PUT(15,   0X);  (*mask ext interrupts*)
      SYSTEM.PUT(com, 10X);
      SYSTEM.PUT(com, 10X); (*reset ext/status*)
      PUT( 1,   0X);  (*Rx-Int on 1st char off*)
      PUT( 9,  0EX);  (*no A reset, enable int, disable daisy chain*)
      PUT( 1,   8X);  (*enable Rx Int*)
      PUT(14,  21X);  (*enter search mode*)
      SYSTEM.PUT(ICU, 19X);  (*clear IRR and IMR bits, channel 1*)
   END Start;

   PROCEDURE SendPacket*(VAR head, buf: ARRAY OF SYSTEM.BYTE);
      VAR i, j, len: INTEGER;
   BEGIN head[2] := Adr;
      len := SYSTEM.VAL(INTEGER,head[5])*100H + SYSTEM.VAL(INTEGER,head[4]); j := 1000;
      LOOP (*sample line*) i := 480;
         REPEAT DEC(i) UNTIL SYSTEM.BIT(com, Hunt) OR (i = 0);
         IF i > 0 THEN (*line idle*) EXIT END ;
         DEC(j);
         IF j = 0 THEN EXIT END ;
         i := LONG(Adr)*128 + 800;  (*delay*)
         REPEAT DEC(i) UNTIL i = 0
      END ;
      Kernel.SetICU(0A2X);  (*disable interrupts!*)
      PUT( 5,  63X);  (*RTS, send 1s*)
      PUT( 5,  6BX);  (*RTS, Tx enable*)
      SYSTEM.PUT(com, 80X);      (*reset Tx-CRC*)
      SYSTEM.PUT(dat, head[1]);  (*send dest*)
      SYSTEM.PUT(com, 0C0X);     (*reset underrun/EOM flag*)
      REPEAT UNTIL SYSTEM.BIT(com, TxBE);
      i := 2;
      REPEAT SYSTEM.PUT(dat, head[i]); INC(i);
         REPEAT UNTIL SYSTEM.BIT(com, TxBE)
      UNTIL i = 10;
      i := 0;
      WHILE i < len DO
         SYSTEM.PUT(dat, buf[i]); INC(i); (*send data*)
         REPEAT UNTIL SYSTEM.BIT(com, TxBE)
      END ;
      REPEAT UNTIL SYSTEM.BIT(com, TxUR) & SYSTEM.BIT(com, TxBE);
      PUT( 5,  63X);  (*RTS, Tx disable, send 1s*)
      i := 240;
      REPEAT DEC(i) UNTIL i = 0;
      PUT( 5, 0E1X);  (*~RTS*)
      PUT( 1,   8X);  (*enable Rx-Int on 1st char*)
      PUT(14,  21X);  (*enter search mode*)
      SYSTEM.PUT(com, 20X); (*enable Rx-Int on next char*)
      PUT( 3, SCCR3);  (*enter hunt mode*)
      SYSTEM.PUT(ICU, 0A1X)  (*enable interrupts*)
   END SendPacket;

   PROCEDURE Available*(): INTEGER;
   BEGIN RETURN (in - out) MOD BufLen
   END Available;

   PROCEDURE Receive*(VAR x: SYSTEM.BYTE);
   BEGIN
      REPEAT UNTIL in # out;
      x := buf[out]; out := (out+1) MOD BufLen
   END Receive;

   PROCEDURE ReceiveHead*(VAR head: ARRAY OF SYSTEM.BYTE);
      VAR i: INTEGER;
   BEGIN
      IF (in - out) MOD BufLen >= 9 THEN head[0] := 1; i := 1;
         REPEAT Receive(head[i]); INC(i) UNTIL i = 10
      ELSE head[0] := 0
      END
   END ReceiveHead;

   PROCEDURE Skip*(m: INTEGER);
   BEGIN
      IF m <= (in - out) MOD BufLen THEN out := (out+m) MOD BufLen ELSE out := in END
   END Skip;

   PROCEDURE Stop*;
   BEGIN PUT(9, 80X);  (*reset SCCA*)
      SYSTEM.PUT(ICU, 39X); SYSTEM.PUT(ICU, 59X); (*reset IMR and IRR*)
   END Stop;

BEGIN Start(TRUE)
END SCC.
