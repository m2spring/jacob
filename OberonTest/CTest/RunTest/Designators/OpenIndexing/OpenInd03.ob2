MODULE OpenInd03;
IMPORT O:=Out;

TYPE 
   TOpen1 = ARRAY OF INTEGER;
   TOpen2 = ARRAY OF ARRAY OF INTEGER;
   
     
VAR
   po1 : POINTER TO TOpen1;
   po2 : POINTER TO TOpen2;
   
   a1 : ARRAY 5 OF INTEGER;
   a2 : ARRAY 2,5 OF INTEGER; 
   

PROCEDURE Print(a:ARRAY OF INTEGER);
BEGIN (* Print *)
 O.String("a[0]="); O.Int(a[0]); O.Ln;
 O.String("a[1]="); O.Int(a[1]); O.Ln;
 O.String("a[2]="); O.Int(a[2]); O.Ln;
 O.String("a[3]="); O.Int(a[3]); O.Ln;
 O.String("a[4]="); O.Int(a[4]); O.Ln;
 O.String('-----------------'); O.Ln;
END Print;



PROCEDURE POpen(a1:TOpen1; a2:TOpen2);

  PROCEDURE Q;
  BEGIN (* Q *)
   Print(a2[0]);
   Print(a2[1]);
  END Q;

BEGIN (* POpen *)
 Print(a1);
 Q;
END POpen;


BEGIN (* OpenInd03 *)
 a1[0]:=MIN(INTEGER);
 a1[1]:=a1[0]+1;
 a1[2]:=a1[1]+1;
 a1[3]:=a1[2]+1;
 a1[4]:=a1[3]+1;
 
 a2[0,0]:=1;
 a2[0,1]:=2; 
 a2[0,2]:=3; 
 a2[0,3]:=4; 
 a2[0,4]:=5;
 
 a2[1,0]:=6; 
 a2[1,1]:=7; 
 a2[1,2]:=8; 
 a2[1,3]:=9; 
 a2[1,4]:=10;

 POpen(a1,a2);
 
 NEW(po1,5);
 NEW(po2,2,5);
 po1[0]:=4711;
 po1[1]:=4712;
 po1[2]:=4713;
 po1[3]:=4714;
 po1[4]:=4715;
 
 po2[0,0]:=11; 
 po2[0,1]:=12; 
 po2[0,2]:=13; 
 po2[0,3]:=14; 
 po2[0,4]:=15;

 po2[1,0]:=16; 
 po2[1,1]:=17; 
 po2[1,2]:=18; 
 po2[1,3]:=19; 
 po2[1,4]:=20;

 Print(po1^);
 Print(po2[0]);
 Print(po2[1]);
END OpenInd03.
