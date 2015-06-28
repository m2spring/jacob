MODULE Lib;
(** Inspired by TopSpeed Modula-2 library module Lib *)
IMPORT Out,SL:=SysLib;

TYPE PROC* = SL.ExitProcT;

(************************************************************************************************************************)
PROCEDURE FatalError*(s:ARRAY OF CHAR);
BEGIN (* FatalError *)
 Out.StrLn(s); 
 HALT(1); 
END FatalError;

(************************************************************************************************************************)
PROCEDURE ParamCount*():LONGINT; 
BEGIN (* ParamCount *)
 RETURN SL.argc; 
END ParamCount;

(************************************************************************************************************************)
PROCEDURE ParamStr*(VAR s:ARRAY OF CHAR; i:LONGINT);
BEGIN (* ParamStr *)
 IF (0<=i) & (i<SL.argc) THEN 
    COPY(SL.argv[i]^,s); 
 ELSE
    s[0]:=0X; 
 END; (* IF *)
END ParamStr;

(************************************************************************************************************************)
PROCEDURE EnvironmentFind*(name:ARRAY OF CHAR; VAR result:ARRAY OF CHAR);
VAR i,j,dst:LONGINT; entry:SL.stringP; c:CHAR; 
BEGIN (* EnvironmentFind *)
 i:=0; 
 WHILE SL.env[i]#NIL DO
  entry:=SL.env[i]; j:=0; 
  LOOP
   IF (j>=LEN(name)) OR (name[j]=0X) THEN 
      IF entry[j]='=' THEN 
         INC(j); dst:=0; 
	 LOOP
	  IF dst>=LEN(result) THEN result[LEN(result)-1]:=0X; EXIT; END; (* IF *)
          c:=entry[j]; INC(j); 
	  result[dst]:=c; INC(dst); 
	  IF c=0X THEN EXIT; END; (* IF *)
         END; (* LOOP *)
         RETURN;
      END; (* IF *)
      EXIT; 
   END; (* IF *)
   
   c:=entry[j]; 
   IF (c='=') OR (c=0X) OR (c#name[j]) THEN EXIT; END; (* IF *)
   INC(j); 
  END; (* LOOP *)
  INC(i); 
 END; (* WHILE *)
 
 result[0]:=0X; 
END EnvironmentFind;

(************************************************************************************************************************)
PROCEDURE RANDOM*(range:LONGINT):LONGINT; 
BEGIN (* RANDOM *)			  
 RETURN SL.random() MOD range; 
END RANDOM;

(************************************************************************************************************************)
PROCEDURE RANDOMIZE*;
BEGIN (* RANDOMIZE *)
 SL.srandom(SL.time(0)); 
END RANDOMIZE;

(************************************************************************************************************************)
PROCEDURE Terminate*(p:PROC; VAR c:PROC);
BEGIN (* Terminate *)				 
 c:=SL.ExitProc; SL.ExitProc:=p; 
END Terminate;

(************************************************************************************************************************)
END Lib.
