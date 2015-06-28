MODULE Users;   (*NW 2.2.89 / 25.8.91*)
   IMPORT Texts, Viewers, Oberon, MenuViewers, TextFrames, Core;

   CONST TAB = 9X;
   VAR W: Texts.Writer;

   PROCEDURE List*;
      VAR x, y, i: INTEGER;
         protected: BOOLEAN;
         count: LONGINT;
         T: Texts.Text;
         V: Viewers.Viewer;
         id: Core.ShortName; name: Core.LongName;
   BEGIN i := 0; T := TextFrames.Text("");
      Oberon.AllocateUserViewer(Oberon.Par.frame.X, x, y);
      V := MenuViewers.New(
            TextFrames.NewMenu("Users.Text", "System.Close  Edit.Store"),
            TextFrames.NewText(T, 0), TextFrames.menuH, x, y);
      WHILE i < Core.NofUsers() DO
         Core.GetUser(i, id, name, count, protected);
         Texts.WriteInt(W, i, 4); Texts.Write(W, TAB);
         IF protected THEN Texts.Write(W, "#") END ;
         Texts.WriteString(W, id); Texts.Write(W, TAB); Texts.WriteString(W, name);
         Texts.WriteInt(W, count, 8); Texts.WriteLn(W); INC(i)
      END ;
      Texts.Append(T, W.buf)
   END List;

   PROCEDURE Insert*;
      VAR id: Core.ShortName; name: Core.LongName; S: Texts.Scanner;
   BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF S.class = Texts.Name THEN
         COPY(S.s, id); Texts.Scan(S);
         IF S.class = Texts.Name THEN COPY(S.s, name); Core.InsertUser(id, name) END
      END ;
      Core.BackupUsers
   END Insert;

   PROCEDURE Delete*;
      VAR id: Core.ShortName; S: Texts.Scanner;
   BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF S.class = Texts.Name THEN COPY(S.s, id); Core.DeleteUser(id) END ;
      Core.BackupUsers
   END Delete;

   PROCEDURE ClearPassword*;
      VAR id: Core.ShortName; S: Texts.Scanner;
   BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF S.class = Texts.Name THEN COPY(S.s, id); Core.ClearPassword(id) END ;
      Core.BackupUsers
   END ClearPassword;

   PROCEDURE ClearCounts*;
   BEGIN Core.SetCounts(0); Core.BackupUsers
   END ClearCounts;

   PROCEDURE Init*;
      VAR id: Core.ShortName; name: Core.LongName; S: Texts.Scanner;
   BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos);
      Core.PurgeUsers(0);
      LOOP Texts.Scan(S);
         IF S.class # Texts.Name THEN EXIT END ;
         COPY(S.s, id); Texts.Scan(S);
         IF S.class # Texts.Name THEN EXIT END ;
         COPY(S.s, name); Core.InsertUser(id, name)
      END ;
      Core.BackupUsers
   END Init;

BEGIN Texts.OpenWriter(W)
END Users.
