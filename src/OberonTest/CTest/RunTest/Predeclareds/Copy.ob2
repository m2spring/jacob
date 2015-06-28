(* $! oc -it -cmt -kt Copy && Copy # *)
MODULE Copy;
IMPORT O:=Out;


CONST c="Const-String";
VAR   Sfixed,
      Dfixed : ARRAY 20 OF CHAR;
      Sopen1,
      Dopen1 : POINTER TO ARRAY OF CHAR; 
      Sopen2,
      Dopen2 : POINTER TO ARRAY OF ARRAY OF CHAR;
BEGIN (* Copy *)
 NEW(Sopen1,20);
 NEW(Sopen2,10,20);
 NEW(Dopen1,20);
 NEW(Dopen2,10,20);

 Sfixed:="Fixed String";
 COPY('Open1-String',Sopen1^);
 COPY('Open2_String',Sopen2[5]);
 O.StrLn(c);
 O.StrLn(Sfixed);
 O.StrLn(Sopen1^);
 O.StrLn(Sopen2[5]);
 O.StrLn('**********');
 COPY(c,Dfixed);
 O.Str('Const->Fixed: '); O.StrLn(Dfixed);
 COPY(c,Dopen1^);
 O.Str('Const->Open1: '); O.StrLn(Dopen1^);
 COPY(c,Dopen2[1]);
 O.Str('Const->Open2: '); O.StrLn(Dopen2[1]);
 O.StrLn('**********');
 COPY(Sfixed,Dfixed);
 O.Str('Fixed->Fixed: '); O.StrLn(Dfixed);
 COPY(Sfixed,Dopen1^);
 O.Str('Fixed->Open1: '); O.StrLn(Dfixed);
 COPY(Sfixed,Dopen2[3]);
 O.Str('Fixed->Open2: '); O.StrLn(Dopen2[3]);
 O.StrLn('**********');
 COPY(Sopen1^,Dfixed);
 O.Str('Open1->Fixed: '); O.StrLn(Dfixed);
 COPY(Sopen1^,Dopen1^);
 O.Str('Open1->Open1: '); O.StrLn(Dopen1^);
 COPY(Sopen1^,Dopen2[4]);
 O.Str('Open1->Open2: '); O.StrLn(Dopen2[4]);
 O.StrLn('**********');
 COPY(Sopen2[5],Dfixed);
 O.Str('Open2->Fixed: '); O.StrLn(Dfixed);
 COPY(Sopen2[5],Dopen1^);
 O.Str('Open2->Open1: '); O.StrLn(Dopen1^);
 COPY(Sopen2[5],Dopen2[8]);
 O.Str('Open2->Open2: '); O.StrLn(Dopen2[8]);
END Copy.
