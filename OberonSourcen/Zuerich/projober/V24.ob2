MODULE V24;  (*NW 18.3.89 / 19.1.91*)
   (*interrupt-driven UART channel B*)
   IMPORT SYSTEM, Kernel;

   CONST BufLen = 512;
      UART = 0FFFFC000H; ICU = 0FFFF9000H;

   VAR in, out: INTEGER;
      buf: ARRAY BufLen OF SYSTEM.BYTE;

   PROCEDURE Int;
   BEGIN SYSTEM.GET(UART+44, buf[in]); in := (in+1) MOD BufLen
   END Int;

   PROCEDURE Start*(CSR, MR1, MR2: CHAR);
   BEGIN in := 0; out := 0;  Kernel.InstallIP(Int, 2);
      SYSTEM.PUT(UART+40, 30X); (*CRB reset transmitter*)
      SYSTEM.PUT(UART+40, 20X); (*CRB reset receiver*)
      SYSTEM.PUT(UART+36, CSR); (*CSRB clock rate*)
      SYSTEM.PUT(UART+40, 15X); (*CRB enable Tx and Rx, pointer to MR1*)
      SYSTEM.PUT(UART+32, MR1); (*MR1B, parity, nof bits*)
      SYSTEM.PUT(UART+32, MR2); (*MR2B stop bits*)
      SYSTEM.PUT(UART+20, 20X); (*IMR  RxRdy Int enable*)
      SYSTEM.PUT(ICU + 4, 1AX); (*ICU  IMR and IRR bit 2*)
   END Start;

   PROCEDURE SetOP*(s: SET);
   BEGIN SYSTEM.PUT(UART+56, s)
   END SetOP;

   PROCEDURE ClearOP*(s: SET);
   BEGIN SYSTEM.PUT(UART+60, s)
   END ClearOP;

   PROCEDURE IP*(n: INTEGER): BOOLEAN;
   BEGIN RETURN SYSTEM.BIT(UART+52, n)
   END IP;

   PROCEDURE SR*(n: INTEGER): BOOLEAN;
   BEGIN RETURN SYSTEM.BIT(UART+36, n)
   END SR;

   PROCEDURE Available*(): INTEGER;
   BEGIN RETURN (in - out) MOD BufLen
   END Available;

   PROCEDURE Receive*(VAR x: SYSTEM.BYTE);
   BEGIN
      REPEAT UNTIL in # out;
      x := buf[out]; out := (out+1) MOD BufLen
   END Receive;

   PROCEDURE Send*(x: SYSTEM.BYTE);
   BEGIN
      REPEAT UNTIL SYSTEM.BIT(UART+36, 2);
      SYSTEM.PUT(UART+44, x)
   END Send;

   PROCEDURE Break*;
      VAR i: LONGINT;
   BEGIN SYSTEM.PUT(UART+40, 60X); i := 500000;
      REPEAT DEC(i) UNTIL i = 0;
      SYSTEM.PUT(UART+40, 70X)
   END Break;

   PROCEDURE Stop*;
   BEGIN SYSTEM.PUT(UART+20, 0); (*IMR disable Rx-Int*)
      SYSTEM.PUT(ICU + 4, 3AX)  (*ICU chan 2*)
   END Stop;

END V24.
