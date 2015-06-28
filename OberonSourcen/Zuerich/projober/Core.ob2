MODULE Core;  (*NW 17.4.89 / 6.1.90*)
   IMPORT Kernel, Files;

   CONST
      UTsize = 64;  (*max nof registered users*)
      UTsec0 = 60*29;  (*adr of user table on disk*)
      UTsec1 = 61*29;

   TYPE
      ShortName* = ARRAY 8 OF CHAR;
      LongName* = ARRAY 16 OF CHAR;
      Name* = ARRAY 32 OF CHAR;

      MailEntry* = RECORD
            pos*, next*: INTEGER;
            len*: LONGINT;
            time*, date*: INTEGER;
            originator*: ARRAY 20 OF CHAR
         END ;

      MResTab* = ARRAY 8 OF SET;
      MailDir* = ARRAY 31 OF MailEntry;

      User = RECORD
            id: ShortName;
            name: LongName;
            password, count: LONGINT
         END ;

      SectorBuf = RECORD (Kernel.Sector)
            u: ARRAY 32 OF User
         END ;

      Task = POINTER TO TaskDesc;

      TaskDesc = RECORD
            file: Files.File;
            uno, class: INTEGER;
            name: ShortName;
            next: Task
         END ;

      Queue = RECORD n*: INTEGER;
            first, last: Task
         END ;

   VAR
      PrintQueue*, MailQueue*, LineQueue*: Queue;
      NUsers: INTEGER;
      UT:  ARRAY UTsize OF User;

   PROCEDURE RestoreUsers*;
      VAR i: INTEGER; SB: SectorBuf;
   BEGIN i := 0; Kernel.GetSector(UTsec0, SB);
      WHILE (i < 32) & (SB.u[i].id[0] > 0X) DO UT[i] := SB.u[i]; INC(i) END ;
      IF i = 32 THEN
         Kernel.GetSector(UTsec1, SB);
         WHILE (i < 64) & (SB.u[i-32].id[0] > 0X) DO UT[i] := SB.u[i-32]; INC(i) END
      END ;
      NUsers := i
   END RestoreUsers;

   PROCEDURE BackupUsers*;
      VAR i: INTEGER; SB: SectorBuf;
   BEGIN i := NUsers;
      IF i >= 32 THEN
         IF i < 64 THEN SB.u[i-32].id[0] := 0X END ;
         WHILE i > 32 DO DEC(i); SB.u[i-32] := UT[i] END ;
         Kernel.PutSector(UTsec1, SB)
      END ;
      IF i < 32 THEN SB.u[i].id[0] := 0X END ;
      WHILE i > 0 DO DEC(i); SB.u[i] := UT[i] END ;
      Kernel.PutSector(UTsec0, SB)
   END BackupUsers;

   PROCEDURE Uno(VAR id: ShortName): INTEGER;
      VAR i: INTEGER;
   BEGIN i := 0;
      WHILE (i < NUsers) & (UT[i].id # id) DO INC(i) END ;
      RETURN i
   END Uno;

   PROCEDURE NofUsers*(): INTEGER;
   BEGIN RETURN NUsers
   END NofUsers;

   PROCEDURE UserNo*(VAR id: ShortName; pw: LONGINT): INTEGER;
      VAR i: INTEGER;  (* -1 = user is protected or not registered*)
   BEGIN i := Uno(id);
      IF (i = NUsers) OR (UT[i].password # pw) & (UT[i].password # 0) THEN i := -1 END ;
      RETURN i
   END UserNo;

   PROCEDURE UserNum*(VAR name: ARRAY OF CHAR): INTEGER;
      VAR i, j: INTEGER;
   BEGIN i := 0;
      LOOP
         IF i = UTsize THEN i := -1; EXIT END ;
         j := 0;
         WHILE (j < 4) & (CAP(name[j]) = CAP(UT[i].name[j])) DO INC(j) END ;
         IF j = 4 THEN EXIT END ;
         INC(i)
      END ;
      RETURN i
   END UserNum;

   PROCEDURE GetUserName*(uno: INTEGER; VAR name: LongName);
   BEGIN name := UT[uno].name
   END GetUserName;

   PROCEDURE GetFileName*(uno: INTEGER; VAR name: ARRAY OF CHAR);
      VAR i: INTEGER; ch: CHAR;
   BEGIN i := 0;
      LOOP ch := UT[uno].name[i];
         IF ch = 0X THEN EXIT END ;
         name[i] := ch; INC(i)
      END ;
      name[i] := "."; name[i+1] := "M"; name[i+2] := "a"; name[i+3] := "i"; name[i+4] := "l";
      name[i+5] := 0X
   END GetFileName;

   PROCEDURE GetUser*(uno: INTEGER; VAR id: ShortName; VAR name: LongName;
            VAR count: LONGINT; VAR protected: BOOLEAN);
   BEGIN id := UT[uno].id; name := UT[uno].name; count := UT[uno].count;
      protected := UT[uno].password # 0
   END GetUser;

   PROCEDURE InsertUser*(VAR id: ShortName; VAR name: LongName);
      VAR i: INTEGER;
   BEGIN i := Uno(id);
      IF (i = NUsers) & (i < UTsize-1) THEN
         UT[i].id := id; UT[i].name := name; UT[i].password := 0; UT[i].count := 0; INC(NUsers)
      END
   END InsertUser;

   PROCEDURE DeleteUser*(VAR id: ShortName);
      VAR i: INTEGER;
   BEGIN i := Uno(id);
      IF i < NUsers THEN DEC(NUsers);
         WHILE i < NUsers DO UT[i] := UT[i+1]; INC(i) END
      END
   END DeleteUser;

   PROCEDURE ClearPassword*(VAR id: ShortName);
   BEGIN UT[Uno(id)].password := 0
   END ClearPassword;

   PROCEDURE SetPassword*(uno: INTEGER; npw: LONGINT);
   BEGIN UT[uno].password := npw; BackupUsers
   END SetPassword;

   PROCEDURE IncPageCount*(uno: INTEGER; n: LONGINT);
   BEGIN INC(UT[uno].count, n); BackupUsers
   END IncPageCount;

   PROCEDURE SetCounts*(n: LONGINT);
      VAR i: INTEGER;
   BEGIN i := 0;
      WHILE i < NUsers DO UT[i].count := n; INC(i) END
   END SetCounts;

   PROCEDURE PurgeUsers*(n: INTEGER);
   BEGIN NUsers := 0
   END PurgeUsers;


   PROCEDURE InsertTask*(VAR Q: Queue; F: Files.File; VAR id: ARRAY OF CHAR; uno: INTEGER);
      VAR T: Task;
   BEGIN NEW(T); T.file := F; COPY(id, T.name); T.uno := uno; T.next := NIL;
      IF Q.last # NIL THEN Q.last.next := T ELSE Q.first := T END ;
      Q.last := T; INC(Q.n)
   END InsertTask;

   PROCEDURE GetTask*(VAR Q: Queue; VAR F: Files.File; VAR id: ShortName; VAR uno: INTEGER);
   BEGIN (*Q.first # NIL*)
      F := Q.first.file; id := Q.first.name; uno := Q.first.uno
   END GetTask;

   PROCEDURE RemoveTask*(VAR Q: Queue);
   BEGIN (*Q.first # NIL*)
      Files.Purge(Q.first.file); Q.first := Q.first.next; DEC(Q.n);
      IF Q.first = NIL THEN Q.last := NIL END
   END RemoveTask;

   PROCEDURE Reset(VAR Q: Queue);
   BEGIN Q.n := 0; Q.first := NIL; Q.last := NIL
   END Reset;

   PROCEDURE Collect*;
      VAR n: LONGINT;
   BEGIN
      IF Kernel.allocated > 300000 THEN Kernel.GC END
   END Collect;

BEGIN RestoreUsers; Reset(PrintQueue); Reset(MailQueue); Reset(LineQueue)
END Core.
