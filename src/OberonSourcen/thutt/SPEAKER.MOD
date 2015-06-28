MODULE Speaker;

(* Provides low level interface to IBM-PC speaker through
     hardware ports.  Platform / implementation dependent.
     This implementation for Logic Magicians Oberon-2.
     This module freely distributable for all versions of Oberon
     distributed freely.
     W. Marshall 1994.11.06 - 1994.12.05 *)

IMPORT SYSTEM;

CONST
  EAX=0; ECX=1; EDX=2;  (* register constants *)
  ON=TRUE; OFF=FALSE;  (* speaker state constants *)
  MinHz*=20; MaxHz*=20000;  (* frequency range in hertz *)

VAR
  SpeakerState: BOOLEAN; (* ON or OFF *)

PROCEDURE - BiosGetTick 0CDX, 1AX;  (* BIOS interrupt 1A *)

PROCEDURE GetTick():LONGINT;
(* returns current clock tick count since midnight *)
VAR
  hi,lo: LONGINT;
  result: LONGINT;
BEGIN
  SYSTEM.PUTREG(EAX,0);  (* service 0, Get Clock Count *)
  BiosGetTick;       (* BIOS interrupt 1A, Time of Day services *)
  SYSTEM.GETREG(ECX,hi);
  SYSTEM.GETREG(EDX,lo);
  result:=(hi * 100H) + lo;
  RETURN result;
END GetTick;

PROCEDURE  Duration*(ticks: LONGINT);
(* Low resolution timer, 18.2 ticks per second *)
VAR
  Now, Stop : LONGINT;
BEGIN
  Now:=GetTick();
  Stop:=Now + ticks;
  WHILE (Now < Stop) DO
    Now:=GetTick();
  END;
END Duration;


PROCEDURE - SpeakerInit  (* code procedure *)
  0B0X, 0B6X,	(* mov al, 0b6h ;timer 2 write initialization code *)
  0E6X, 043X;	(* out 43h, al ;out to port 43h *)

PROCEDURE - SpeakerTone (* code procedure *)
  (* assume proper timer "count" value in register AX before this call *)
  0E6X, 042X,	(* out 42h, al ;send lower byte of AX to port 42h *)
  08AX, 0C4X,	(* mov al, ah  *)
  0E6X, 042X;	(* out 42h, al ;send upper byte AX to port 42h *)

PROCEDURE - SpeakerOn (* code procedure *)
  0E4X, 061X,	(* in al, 61h ;read current settings from port 61h *)
  0CX, 03X,		(* or al, 3h ;set bits  0 and 1 *)
  0E6X, 061X;	(* out 61h, al ;turn speaker and timer gates on *)

PROCEDURE - SpeakerOff (* code procedure *)
  0E4X, 061X,	(* in al, 61h ;read current settings from port 61h *)
  024X, 0FCX,	(* and al, 0fch ;zero bits 0 and 1 *)
  0E6X, 061X;	(* out 61h, al ;turn speaker and timer gates off *)


PROCEDURE On*(freq: REAL);
CONST
  pulse=1193180.0;   (* basic clock frequency of timer chip *)
VAR
  RCount: REAL;
  Count: LONGINT;
BEGIN
  IF (freq<MinHz) OR (freq>MaxHz) THEN RETURN END;
  RCount:= pulse/freq;    (* calculate timer parameter *)
  Count:= ENTIER(RCount);  (* convert to integer *)
  SpeakerInit;   (* initialize timer for port write *)
  SYSTEM.PUTREG(EAX,Count);  (* prepare register *)
  SpeakerTone;  (* set tone *)
  IF (SpeakerState # ON) THEN
    SpeakerOn;  (* turn speaker on *)
    SpeakerState:=ON;
  END;  
END On;

PROCEDURE Off*;
BEGIN
  SpeakerOff;
  SpeakerState:=OFF;
END Off;

PROCEDURE Beep*;
(* gives a short beep using above procedures *)
BEGIN
  On(1000.0);
  Duration(3);
  Off;
END Beep;

PROCEDURE Bleep*;
BEGIN
  On(500.0); Duration(1);
  On(2000.0); Duration(1);
  On(1000.0); Duration(1);
  Off;
END Bleep;

PROCEDURE Tone1*;
(* a low tone *)
BEGIN
  On(55.0);
END Tone1;

PROCEDURE Tone2*;
(* a high tone *)
BEGIN
  On(1760.0);
END Tone2;

PROCEDURE PlayScale*;
CONST
  step=1.0594631;  (* 2^(1/12) is distance between notes *)
  (* NOTE:  for a very nice exposition on the art and math of piano tuning,
      refer to _The Seventh Dragon, The Riddle of Equal Temperment_,
      by Anita Sullivan, 1985, Metamorphous Press  *)
VAR
  note: REAL;
  i: SHORTINT;
BEGIN
  note:=440.0;
  FOR i:=1 TO 12 DO
    On(note);
    Duration(2);
    note:=note*step;
  END;
  On(note); Duration(8);
  Off; Duration(2);
  FOR i:=1 TO 12 DO
    On(note);
    Duration(2);
    note:=note/step;
  END;
  On(note); Duration(8);
  Off;
END PlayScale;


BEGIN
  SpeakerState:=OFF;
END Speaker.


(* for Speaker.Tool:  

Edit.Open ^
OP2.Compile ^

Speaker.Mod /s~
Speaker.Beep~
Speaker.Bleep~
Speaker.PlayScale~
Speaker.Tone1~ Speaker.Tone2~
Speaker.Off~
System.Free Speaker~

API
For client modules, Speaker exports the following:

  Speaker.On(freq: REAL)
    turns speaker on to given frequency
    where freq (in hertz) is in the range
       MinHz <= freq <= MaxHz
    NOTE:
      The constants MinHz and MaxHz are provided
      for export, at 20 and 20000 hertz respectively.
      The actual range of sound production with the
      PC speaker will be less.

  Speaker.Off
    turns speaker off

  Speaker.Duration(ticks: LONGINT)
    provides low resolution timing delay based on
    the system clock tick of 18.2 ticks per second;
    the services of a higher resolution timer
    module are recommended

*)

