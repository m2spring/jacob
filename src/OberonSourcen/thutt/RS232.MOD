MODULE RS232; (* BW 08.6.94 *) (* interrupt-driven 8250/8259 UART Handler *)
IMPORT S:=SYSTEM, Kernel, DPMI, Modules, Out, Oberon;

(* Module        :  RS232
   Functionality :  Low Level Driver for IBM UART Controller *)

CONST
   ModuleName = "RS232"; (* used to lock code region *)

   (* BAUD RATES *)

   bps50* = 0900H; bps110* = 0417H; bps300* = 0180H; bps1200* = 0060H;
   bps2400* = 0030H; bps4800* = 0018H; bps9600* = 000CH; bps19200* = 0006H;
   bps38400* = 0003H; bps56000* = 0009H;

   (* PARITIES *)

   parEven* = {3,4}; parOdd* = {3}; parNone* = {};
   parOne* = {3,5};  parZero* = {3..5};

   (* STOP BITS *)

   stopOne* = {}; stopTwo* = {2};

   (* DATA BITS *)

   data8* = {0,1}; data7* = {1}; data6* = {0}; data5* = {};

   (* DEFAULT BAUD *)

   setbaud = {7};

   (* BUFFER SIZE *)

   BufLen = 512;

   (* Com port constants *)

   COM1 = 03F8H;
   COM1PICMASK = {0..1,3..7};  (* FBH *)
   COM1INT = 0CH;
   COM2 = 02F8H;
   COM2PICMASK = {0..2,4..7};  (* F7H *)
   COM2INT = 0BH;

   (* COM PORT REGISTER OFFSETS *)

   RWR = 0; (* Read/Write Register *)
   IER = 1; (* Interrupt Enable Register *)
   IID = 2; (* Interrupt ID Register *)
   LCR = 3; (* Line Control Register *)
   MCR = 4; (* Modem Control Register *)
   LSR = 5; (* Line Status Register *)
   MSR = 6; (* Modem Status Register *)

  (* Buffer control members for COM1 and COM2 *)

VAR
   PortData : SHORTINT; (* for use by interrupt handler only *)
   InCom1, OutCom1 : INTEGER;
   InCom2, OutCom2 : INTEGER;
   BufCom1    : ARRAY BufLen OF S.BYTE;
   BufCom2    : ARRAY BufLen OF S.BYTE;

   (* Procedure code for non-language supported functions *)

PROCEDURE - LoadCXWithCS 8CH, 0C9H;
PROCEDURE - LoadDS 66H, 0B8H, 0FH, 00H, 8EH, 0D8H; (* MOV AX, 0FH (data selector for Oberon); MOV DS, AX *)
PROCEDURE - LEAVE 0C9H;
PROCEDURE - PUSHAD 60H;
PROCEDURE - POPAD 61H;
PROCEDURE - IRET 0CFH;
PROCEDURE - STI 0FBH;
PROCEDURE - ENTER 0C8H, 08H, 00H, 00H;

(*************************************************************************)
(* Procedure  : Com1Handler                                              *)
(* Arguments  : None.  Interrupt driven.                                 *)
(* Return     : None.                                                    *)
(* Description: Interrupt handler for all COM1 activity.  Incoming data  *)
(*              is buffered for this port MOD BufLen.                    *)
(*************************************************************************)
PROCEDURE+ Com1Handler;
BEGIN
   LEAVE; PUSHAD; ENTER; LoadDS;

   S.PORTIN(COM1 + IID, PortData);

   IF 2 IN S.VAL(SET, PortData) (* byte received? *) THEN
      S.PORTIN(COM1 + RWR, BufCom1[InCom1]);  InCom1 := (InCom1 + 1) MOD BufLen;
   END;

   (* REQUIRED:   Re-enable hardware interrupts before exiting. *)

   STI;
   S.PORTOUT(20H, 20H);
   LEAVE; POPAD; IRET;
END Com1Handler;

(*************************************************************************)
(* Procedure  : Com2Handler                                              *)
(* Arguments  : None.  Interrupt driven.                                 *)
(* Return     : None.                                                    *)
(* Description: Interrupt handler for all COM2 activity.  Incoming data  *)
(*              is buffered for this port MOD BufLen.                    *)
(*************************************************************************)
PROCEDURE+ Com2Handler;
BEGIN
   LEAVE; PUSHAD; ENTER; LoadDS;

   S.PORTIN(COM2 + IID, PortData);

   IF 2 IN S.VAL(SET, PortData) (* byte received? *) THEN
      S.PORTIN(COM2 + RWR, BufCom2[InCom2]);  InCom2 := (InCom2 + 1) MOD BufLen;
   END;

   (* REQUIRED:   Re-enable hardware interrupts before exiting. *)

   STI;
   S.PORTOUT(20H, 20H);
   LEAVE; POPAD; IRET;
END Com2Handler;

(*************************************************************************)
(* Procedure  : Close                                                    *)
(* Arguments  : port : INTEGER (1 >= port <= 2)                          *)
(* Return     : None.                                                    *)
(* Description: Disengages specified port from interrupt vector handling.*)
(*              In effect, closes the COM port specified.                *)
(*************************************************************************)
PROCEDURE Close*(port : INTEGER);
VAR p : LONGINT;
BEGIN
   (* Turn off UART *)

   IF port = 1 THEN
      S.PORTOUT(COM1+IER, 00H);
      S.PORTOUT(COM1+MCR, 00H);
   ELSIF port = 2 THEN
      S.PORTOUT(COM2+IER, 00H);
      S.PORTOUT(COM2+MCR, 00H);
   END;

   (* Now disattach interrupt handler from COM interrupt! *)

END Close;

(*************************************************************************)
(* Procedure  : Start                                                    *)
(* Arguments  : port : INTEGER (1 >= port <= 2)                          *)
(*              baud : INTEGER (internal defines)                        *)
(*              databits: SET  (internal defines)                        *)
(*              parity:   SET  (internal defines)                        *)
(*              stopbits: SET  (internal defines)                        *)
(* Return     : None.                                                    *)
(* Description: Initializes and initiates the specified COM port for     *)
(*              transceiving data using the given parameters. Baud,      *)
(*              Parity, and Stopbits are defines located at the top      *)
(*              of this code or in associated files.                     *)
(*************************************************************************)

PROCEDURE Start*(port, baud : INTEGER; databits, parity, stopbits : SET);
VAR		m : SET;
    CS : INTEGER;
		desc : DPMI.SegmentDesc;
		this : Modules.Module;
	handler : PROCEDURE;
		 err : INTEGER;
  ByteData : S.BYTE;
CONST 		 ECX = 1;

BEGIN

   IF port = 1 THEN
      m    := COM1PICMASK;
      InCom1  := 0;
      OutCom1 := 0;
   ELSIF port = 2 THEN
      m    := COM2PICMASK;
      InCom2  := 0;
      OutCom2 := 0;
   END;

   (* Turn on UART interrupt in Peripherial Interrupt Controller *)

   S.PORTIN(21H, ByteData);
   S.PORTOUT(21H, S.VAL(S.BYTE, S.VAL(SET, ByteData) * m));

   IF port = 1 THEN

      (* Turn on READ interrupt in UART/COM1 *)

      S.PORTOUT(COM1 + IER, 01H);  (* XMIT RECEIVE *)
      S.PORTOUT(COM1 + MCR, 0BH);  (* OUT2 *)

      (* Clear Com Port *)

      REPEAT
         S.PORTIN(COM1 + LSR, ByteData);
         S.PORTIN(COM1 + RWR, ByteData);
         S.PORTIN(COM1 + MSR, ByteData);
         S.PORTIN(COM1 + IID, ByteData);
         S.PORTIN(COM1 + IID, ByteData);
      UNTIL (~(2 IN S.VAL(SET, ByteData)));

      (* Make BAUD0 Interrupt Addressable *)

      S.PORTOUT(COM1 + LCR, 80X);

      (* Write Baud *)

      S.PORTOUT(COM1 + RWR, SHORT(baud MOD 100H));
      S.PORTOUT(COM1 + RWR+1, SHORT(baud DIV 100H));

      (* Write Parity, Stopbit, Databit, and DLAB0 *)

      S.PORTOUT(COM1 + LCR, S.VAL(S.BYTE, (parity + stopbits + databits) * {0..6}));
   ELSIF port = 2 THEN

      (* Turn on READ interrupt in UART/COM2 *)

      S.PORTOUT(COM2 + IER, 01H);  (* XMIT RECEIVE *)
      S.PORTOUT(COM2 + MCR, 0BH);  (* OUT2 *)

      (* Clear Com Port *)

      REPEAT
         S.PORTIN(COM2 + LSR, ByteData);
         S.PORTIN(COM2 + RWR, ByteData);
         S.PORTIN(COM2 + MSR, ByteData);
         S.PORTIN(COM2 + IID, ByteData);
         S.PORTIN(COM2 + IID, ByteData);
      UNTIL (~(2 IN S.VAL(SET, ByteData)));

      (* Make BAUD0 Interrupt Addressable *)

      S.PORTOUT(COM2 + LCR, 80X);

      (* Write Baud *)

      S.PORTOUT(COM2 + RWR, SHORT(baud MOD 100H));
      S.PORTOUT(COM2 + RWR+1, SHORT(baud DIV 100H));

      (* Write Parity, Stopbit, Databit, and DLAB0 *)

      S.PORTOUT(COM2 + LCR, S.VAL(S.BYTE, (parity + stopbits + databits) * {0..6}));
   END;

   (* Now attach interrupt to vector *)

   this := Modules.ThisMod(ModuleName); ASSERT(this # NIL, 30);
   LoadCXWithCS; S.GETREG(ECX, CS);
   DPMI.DecodeSelector(CS, desc);
   DPMI.LockRegion(desc.base + this.BB, this.size, err); (* Hardware interrupt handlers must be locked *)

   IF port = 1 THEN
      handler := Com1Handler;
      DPMI.SetPMInterrupt(COM1INT, CS, S.VAL(LONGINT, handler), err);
      ASSERT(err = 0, 20);
   ELSE
      handler := Com2Handler;
      DPMI.SetPMInterrupt(COM2INT, CS, S.VAL(LONGINT, handler), err);
      ASSERT(err = 0, 20);
   END;

END Start;

(*************************************************************************)
(* Procedure  : SetOP (Set Modem Control Register Bit)                   *)
(* Arguments  : port : INTEGER (1 >= port <= 2)                          *)
(*                 n : SET   (0 <= set <= 255)                           *)
(* Return     : None.                                                    *)
(* Description: Sets a mask in the modem control register.               *)
(*              Where n = 1 Sets DTR output to RS232C connector          *)
(*                    n = 2 Sets RTS output to RS232C connector          *)
(*                    n = 3 Resets Hayes 1200b internal modem (User1 Out)*)
(*                    n = 4 Control 8250/8259 int signals (User 2 Output)*)
(*                    n = 5  Turns on UART self-test configuration       *)
(*                    n = 6, 7, 8 Are Not Available                      *)
(*************************************************************************)

PROCEDURE SetOP*(port:INTEGER; s:SET);
VAR ByteData : S.BYTE;
BEGIN
   IF port = 1 THEN
      S.PORTIN(COM1 + MCR, ByteData);
      S.PORTOUT(COM1 + MCR, S.VAL(S.BYTE, s + S.VAL(SET, ByteData)));
   ELSIF port = 2 THEN
      S.PORTIN(COM2 + MCR, ByteData);
      S.PORTOUT(COM2 + MCR, S.VAL(S.BYTE, s + S.VAL(SET, ByteData)));
   END;
END SetOP;

(*************************************************************************)
(* Procedure  : ClearOP (Clears Modem Status Register Bit)               *)
(* Arguments  : port : INTEGER (1 >= port <= 2)                          *)
(*                 n : SET   (0 <= set <= 255)                           *)
(* Return     : None.                                                    *)
(* Description: Clears the a modem control register bit in the UART.     *)
(*              Where n = 1 Sets DTR output to RS232C connector          *)
(*                    n = 2 Sets RTS output to RS232C connector          *)
(*                    n = 3 Resets Hayes 1200b internal modem (User1 Out)*)
(*                    n = 4 Control 8250/8259 int signals (User2 Out)    *)
(*                    n = 5  Turns on UART self-test configuration       *)
(*                    n = 6, 7, 8 Are Not Available                      *)
(*************************************************************************)

PROCEDURE ClearOP*(port : INTEGER; s : SET);
VAR ByteData : S.BYTE;							(* Serial byte *)
BEGIN
   IF port = 1 THEN
      S.PORTIN(COM1 + MCR, ByteData);
      S.PORTOUT(COM1 + MCR, S.VAL(S.BYTE, (-s) * S.VAL(SET, ByteData)));
   ELSIF port = 2 THEN
      S.PORTIN(COM2 + MCR, ByteData);
      S.PORTOUT(COM2 + MCR, S.VAL(S.BYTE, (-s) * S.VAL(SET, ByteData)));
   END;
END ClearOP;

(*************************************************************************)
(* Procedure  : IP (Line Status Register)                                *)
(* Arguments  : port : INTEGER (1 >= port <= 2)                          *)
(*                 n : INTEGER (1 <= bit <= 8)                           *)
(* Return     : BOOLEAN    (TRUE | FALSE)                                *)
(* Description: Returns boolean setting of selected bit from the UART.   *)
(*               Where n = 1 Received Data Ready                         *)
(*                     n = 2 Overrun Error                               *)
(*                     n = 3 Parity Error                                *)
(*                     n = 4 Framing Error                               *)
(*                     n = 5 BREAK Received                              *)
(*                     n = 6 Transmit Holding Register Empty             *)
(*                     n = 7 Transmit Shift Register Empty               *)
(*                     n = 8 Always Zero (FALSE)                         *)
(*************************************************************************)

PROCEDURE IP*(port, n:INTEGER): BOOLEAN;
VAR ByteData : S.BYTE;	  (* Serial byte *)
BEGIN
   IF port = 1 THEN
      S.PORTIN(COM1 + LSR, ByteData);
   ELSIF port = 2 THEN
      S.PORTIN(COM2 + LSR, ByteData);
   END;

   RETURN n IN S.VAL(SET, ByteData);
END IP;

(*************************************************************************)
(* Procedure  : SR (Status Register)                                     *)
(* Arguments  : port : INTEGER (1 >= port <= 2)                          *)
(*                 n : INTEGER (1 <= bit <= 8)                           *)
(* Return     : BOOLEAN    (TRUE | FALSE)                                *)
(* Description: Returns boolean setting of selected bit from the UART.   *)
(*              Where n = 1 CTS changed since last read                  *)
(*                    n = 2 DSR changed since last read                  *)
(*                    n = 3 RI changed since last read                   *)
(*                    n = 4 DCD changed since last read                  *)
(*                    n = 5 Clear To Send (CTS) Level (hi/lo)            *)
(*                    n = 6 Data Set Ready (DSR) Level (hi/lo)           *)
(*                    n = 7 Ring Indicator (RI) Level (hi/lo)            *)
(*                    n = 8 Data Carrier Detect (DCD) Level (hi/lo)      *)
(*************************************************************************)

PROCEDURE SR*(port, n:INTEGER): BOOLEAN;
VAR ByteData : S.BYTE;	  (* Serial byte *)
BEGIN

   ByteData := 0;

   IF port = 1 THEN
      S.PORTIN(COM1 + MSR, ByteData);
   ELSIF port = 2 THEN
      S.PORTIN(COM2 + MSR, ByteData);
   END;

   RETURN S.BIT(S.ADR(ByteData), n);
END SR;

(*************************************************************************)
(* Procedure  : Available                                                *)
(* Arguments  : port : INTEGER (1 >= port <= 2)                          *)
(* Return     : INTEGER    (0 <= available <= BufLen                     *)
(* Description: Returns bytes available COM buffer.                      *)
(*************************************************************************)

(* Return number of bytes used in buffer *)

PROCEDURE Available*(port:INTEGER): INTEGER;
VAR bufamt : INTEGER;
BEGIN

   IF port = 1 THEN
      bufamt := (InCom1 - OutCom1) MOD BufLen;
   ELSIF port = 2 THEN
      bufamt := (InCom2 - OutCom2) MOD BufLen;
   ELSE
      bufamt := 0;
   END;

   RETURN bufamt;
END Available;

(*************************************************************************)
(* Procedure  : Receive                                                  *)
(* Arguments  : port : INTEGER (1 >= port <= 2)                          *)
(*                 X : VAR S.BYTE (0 <= X <= 255)                        *)
(* Return     : None.                                                    *)
(* Description: Non-Blocking method to receive byte, returning it in X.  *)
(*************************************************************************)

PROCEDURE Receive*(port : INTEGER; VAR x: S.BYTE);
BEGIN
   x := 0;

   IF port = 1 THEN
      x  := BufCom1[OutCom1];
      OutCom1 := (OutCom1 + 1) MOD BufLen;
   ELSIF port = 2 THEN
      x  := BufCom2[OutCom2];
      OutCom2 := (OutCom2 + 1) MOD BufLen;
   END;
END Receive;

(*************************************************************************)
(* Procedure  : Send                                                     *)
(* Arguments  : port : INTEGER (1 >= port <= 2)                          *)
(*                 X : S.BYTE  (0 <= X <= 255)                           *)
(* Return     : None.                                                    *)
(* Description: Sends byte out to UART directly.                         *)
(*************************************************************************)

PROCEDURE Send*(port : INTEGER; x: S.BYTE);
VAR ByteData : S.BYTE;				(* Serial byte *)
BEGIN  (* Wait for UART to clear *)
   IF port = 1 THEN
      REPEAT
         S.PORTIN(COM1 + LSR, ByteData); (* Wait for SEND READY *)
      UNTIL (5 IN S.VAL(SET, ByteData));

      S.PORTOUT(COM1 + RWR, x);    (* Send *)
   ELSIF port = 2 THEN
      REPEAT
         S.PORTIN(COM2 + LSR, ByteData); (* Wait for SEND READY *)
      UNTIL (5 IN S.VAL(SET, ByteData));

      S.PORTOUT(COM2 + RWR, x);    (* Send *)
   END;
END Send;

(*************************************************************************)
(* Procedure  : Break                                                    *)
(* Arguments  : port : INTEGER (1 >= port <= 2)                          *)
(* Return     : None.                                                    *)
(* Description: Turns breaking signal on for approx. 150 ms.             *)
(*************************************************************************)

PROCEDURE Break*(port : INTEGER);
VAR i : LONGINT;
CONST ApproxTime = 500000; (* ~150 milliseconds *)
BEGIN
   IF port = 1 THEN
      S.PORTOUT(COM1 + LCR, 40H); (* LCR Break Control ON *)
   ELSIF port = 2 THEN
      S.PORTOUT(COM2 + LCR, 40H); (* LCR Break Control ON *)
   END;

   (* XXX should use timer module for this XXX *)

   i := ApproxTime; REPEAT DEC(i) UNTIL i = 0;

   IF port = 1 THEN
      S.PORTOUT(COM1 + LCR, 00H); (* Turn BREAK signal OFF *)
   ELSIF port = 2 THEN
      S.PORTOUT(COM2 + LCR, 00H); (* Turn BREAK signal OFF *)
   END;
END Break;

(*************************************************************************)
(* Procedure  : Stop                                                     *)
(* Arguments  : port : INTEGER (1 >= port <= 2)                          *)
(* Return     : None.                                                    *)
(* Description: Stops the specified port from receiving interrupts.      *)
(*              In effect, this is turning off the UART for that port.   *)
(*              DTR is also set off as we're no longer in ready state.   *)
(*************************************************************************)

PROCEDURE Stop*(port : INTEGER);
BEGIN
   IF port = 1 THEN
      S.PORTOUT(COM1 + IER, 00H); (* Turn UART interrupts off *)
      S.PORTOUT(COM1 + MCR, 00H); (* Turn DTR off *)
      InCom1  := 0;
      OutCom1 := 0;
   ELSE
      S.PORTOUT(COM2 + IER, 00H); (* Turn UART interrupts off *)
      S.PORTOUT(COM2 + MCR, 00H); (* Turn DTR off *)
      InCom2  := 0;
      OutCom2 := 0;
   END;
END Stop;

BEGIN;
END RS232.
