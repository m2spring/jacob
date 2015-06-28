MODULE Diskette;

   IMPORT SYSTEM;

   CONST
      NoError* = 0;
      NoFloppyInDrive* = 1;
      Not720kFloppy* = 2;
      OtherError* = 3;

   TYPE
      ProgressNotifier* = PROCEDURE (state: INTEGER);

   VAR
      res-: INTEGER;

   PROCEDURE Close*;
   BEGIN
   END Close;

   PROCEDURE Format* (drive: CHAR; notify: ProgressNotifier);
   BEGIN
   END Format;

   PROCEDURE GetSector* (sec: LONGINT; VAR buf: ARRAY OF SYSTEM.BYTE; off: LONGINT);
   BEGIN
   END GetSector;

   PROCEDURE Open* (drive: CHAR);
   BEGIN
   END Open;

   PROCEDURE PutSector* (sec: LONGINT; VAR buf: ARRAY OF SYSTEM.BYTE; off: LONGINT);
   BEGIN
   END PutSector;

END Diskette.
