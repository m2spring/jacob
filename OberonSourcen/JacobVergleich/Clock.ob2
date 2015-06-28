(******************************************************************************)
(* Copyright (c) 1988 by GMD Karlruhe, Germany				      *)
(* Gesellschaft fuer Mathematik und Datenverarbeitung			      *)
(* (German National Research Center for Computer Science)		      *)
(* Forschungsstelle fuer Programmstrukturen an Universitaet Karlsruhe	      *)
(* All rights reserved.							      *)
(******************************************************************************)

MODULE Clock;
IMPORT SysLib;

   VAR t0: SysLib.tms;

   PROCEDURE ResetClock*;
   BEGIN
      SysLib.times(t0);
   END ResetClock;

   PROCEDURE UserTime*() :LONGINT; 
      VAR t: SysLib.tms;
   BEGIN
      SysLib.times(t);
      RETURN t.utime - t0.utime
   END UserTime;

   PROCEDURE SystemTime*() :LONGINT; 
      VAR t: SysLib.tms;
   BEGIN
      SysLib.times(t);
      RETURN t.stime - t0.stime
   END SystemTime;

BEGIN
   ResetClock;
END Clock.
