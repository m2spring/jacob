MODULE Bug1;
(* RUNTIME ERROR: (implicit) typeguard failed *)
(* Beim Laufenlassen eines groesseren Programms trat bei einer Zuweisung
   exakt dieser Art (Pfeil unten) ein Segmentation fault auf, kein Runtime
   Error. Im kleinen Testbeispiel kriegen wir das aber nicht hin. Vielleicht
   ist es ja aber letztlich der gleiche Fehler.
*)
(* PS: Ich denke, ich hatte Euch diesen Bug schon vor ein paar Monaten
       berichtet, habt Ihr ihn etwa noch gar nicht repariert ???????
*)

TYPE 
T2 = RECORD b: INTEGER END;
T1 = POINTER TO RECORD a: T2 END;

VAR P1: T1; P2: T2;

PROCEDURE P(VAR a,b:T2);
BEGIN (* P *)       
 a:=b; 
END P;


BEGIN
P2.b := 0;
NEW(P1); 
P1.a := P2;  (* <------- hier *)
END Bug1.

