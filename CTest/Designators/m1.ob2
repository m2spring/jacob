MODULE m1;
VAR si:SHORTINT; 
    in:INTEGER; 
    i,j,li:LONGINT;        
    b:BOOLEAN; 
TYPE tr=
      RECORD
       i:INTEGER; 
       j:RECORD
          g:INTEGER; 
	  h:INTEGER; 
         END;
      END;
VAR r:tr;      
TYPE T7=RECORD
	 f:BOOLEAN; 
         g:ARRAY 6 OF CHAR; 
        END;
    ta1 =ARRAY 20 OF CHAR;    
    ta2 =ARRAY 20 OF RECORD f:T7; g:ARRAY 1  OF T7; END;
    ta3 =ARRAY 20 OF RECORD f:T7; g:ARRAY 2  OF T7; END;
    ta4 =ARRAY 20 OF RECORD f:T7; g:ARRAY 3  OF T7; END;
    ta5 =ARRAY 20 OF RECORD f:T7; g:ARRAY 4  OF T7; END;
    ta6 =ARRAY 20 OF RECORD f:T7; g:ARRAY 5  OF T7; END;
    ta7 =ARRAY 20 OF RECORD f:T7; g:ARRAY 6  OF T7; END;
    ta8 =ARRAY 20 OF RECORD f:T7; g:ARRAY 7  OF T7; END;
    ta9 =ARRAY 20 OF RECORD f:T7; g:ARRAY 8  OF T7; END;
    ta10=ARRAY 20 OF RECORD f:T7; g:ARRAY 9  OF T7; END;
    ta11=ARRAY 20 OF RECORD f:T7; g:ARRAY 10 OF T7; END;
    ta12=ARRAY 20 OF RECORD f:T7; g:ARRAY 11 OF T7; END;
    ta13=ARRAY 20 OF RECORD f:T7; g:ARRAY 12 OF T7; END;
    ta14=ARRAY 20 OF RECORD f:T7; g:ARRAY 13 OF T7; END;
    ta15=ARRAY 20 OF RECORD f:T7; g:ARRAY 14 OF T7; END;
    ta16=ARRAY 20 OF RECORD f:T7; g:ARRAY 15 OF T7; END;
    ta17=ARRAY 20 OF RECORD f:T7; g:ARRAY 16 OF T7; END;
    ta18=ARRAY 20 OF RECORD f:T7; g:ARRAY 17 OF T7; END;
    ta19=ARRAY 20 OF RECORD f:T7; g:ARRAY 18 OF T7; END;
VAR 
    a1 :ta1;
    a2 :ta2;
    a3 :ta3;
    a4 :ta4;
    a5 :ta5;
    a6 :ta6;
    a7 :ta7;
    a8 :ta8;
    a9 :ta9;
    a10:ta10;
    a11:ta11;
    a12:ta12;
    a13:ta13;
    a14:ta14;
    a15:ta15;
    a16:ta16;
    a17:ta17;
    a18:ta18;
    a19:ta19;

PROCEDURE P;
VAR si:SHORTINT; 
    in:INTEGER; 
    i,j,li:LONGINT;        
    b:BOOLEAN; 
    r:RECORD
       i:INTEGER; 
       j:RECORD
          g:INTEGER; 
	  h:INTEGER; 
         END;
      END;
TYPE T7=RECORD
	 f:BOOLEAN; 
         g:ARRAY 6 OF CHAR; 
        END;
VAR 
    a1 :ARRAY 20 OF CHAR;    
    a2 :ARRAY 20 OF RECORD f:T7; g:ARRAY 1  OF T7; END;
    a3 :ARRAY 20 OF RECORD f:T7; g:ARRAY 2  OF T7; END;
    a4 :ARRAY 20 OF RECORD f:T7; g:ARRAY 3  OF T7; END;
    a5 :ARRAY 20 OF RECORD f:T7; g:ARRAY 4  OF T7; END;
    a6 :ARRAY 20 OF RECORD f:T7; g:ARRAY 5  OF T7; END;
    a7 :ARRAY 20 OF RECORD f:T7; g:ARRAY 6  OF T7; END;
    a8 :ARRAY 20 OF RECORD f:T7; g:ARRAY 7  OF T7; END;
    a9 :ARRAY 20 OF RECORD f:T7; g:ARRAY 8  OF T7; END;
    a10:ARRAY 20 OF RECORD f:T7; g:ARRAY 9  OF T7; END;
    a11:ARRAY 20 OF RECORD f:T7; g:ARRAY 10 OF T7; END;
    a12:ARRAY 20 OF RECORD f:T7; g:ARRAY 11 OF T7; END;
    a13:ARRAY 20 OF RECORD f:T7; g:ARRAY 12 OF T7; END;
    a14:ARRAY 20 OF RECORD f:T7; g:ARRAY 13 OF T7; END;
    a15:ARRAY 20 OF RECORD f:T7; g:ARRAY 14 OF T7; END;
    a16:ARRAY 20 OF RECORD f:T7; g:ARRAY 15 OF T7; END;
    a17:ARRAY 20 OF RECORD f:T7; g:ARRAY 16 OF T7; END;
    a18:ARRAY 20 OF RECORD f:T7; g:ARRAY 17 OF T7; END;
    a19:ARRAY 20 OF RECORD f:T7; g:ARRAY 18 OF T7; END;

 PROCEDURE Q;
 BEGIN (* Q *)
  si:=si; in:=in; li:=li; 
  
  in:=r.j.h; 
  r.j.h:=in;    
  a1[li]:=0X; 
  a1[li]:=a1[li]; 	  
  
  a2 [i].g[j].f:=b; b:=a2 [j].g[i].f; 
  a3 [i].g[j].f:=b; b:=a3 [j].g[i].f; 
  a4 [i].g[j].f:=b; b:=a4 [j].g[i].f; 
  a5 [i].g[j].f:=b; b:=a5 [j].g[i].f; 
  a6 [i].g[j].f:=b; b:=a6 [j].g[i].f; 
  a7 [i].g[j].f:=b; b:=a7 [j].g[i].f; 
  a8 [i].g[j].f:=b; b:=a8 [j].g[i].f; 
  a9 [i].g[j].f:=b; b:=a9 [j].g[i].f; 
  a10[i].g[j].f:=b; b:=a10[j].g[i].f; 
  a11[i].g[j].f:=b; b:=a11[j].g[i].f; 
  a12[i].g[j].f:=b; b:=a12[j].g[i].f; 
  a13[i].g[j].f:=b; b:=a13[j].g[i].f; 
  a14[i].g[j].f:=b; b:=a14[j].g[i].f; 
  a15[i].g[j].f:=b; b:=a15[j].g[i].f; 
  a16[i].g[j].f:=b; b:=a16[j].g[i].f; 
  a17[i].g[j].f:=b; b:=a17[j].g[i].f; 
  a18[i].g[j].f:=b; b:=a18[j].g[i].f; 
  a19[i].g[j].f:=b; b:=a19[j].g[i].f; 
 END Q;

BEGIN (* P *)
 si:=si; in:=in; li:=li; 
 
 in:=r.j.h; 
 r.j.h:=in;    
 a1[li]:=0X; 
 a1[li]:=a1[li]; 	  
 
 a2 [i].g[j].f:=b; b:=a2 [j].g[i].f; 
 a3 [i].g[j].f:=b; b:=a3 [j].g[i].f; 
 a4 [i].g[j].f:=b; b:=a4 [j].g[i].f; 
 a5 [i].g[j].f:=b; b:=a5 [j].g[i].f; 
 a6 [i].g[j].f:=b; b:=a6 [j].g[i].f; 
 a7 [i].g[j].f:=b; b:=a7 [j].g[i].f; 
 a8 [i].g[j].f:=b; b:=a8 [j].g[i].f; 
 a9 [i].g[j].f:=b; b:=a9 [j].g[i].f; 
 a10[i].g[j].f:=b; b:=a10[j].g[i].f; 
 a11[i].g[j].f:=b; b:=a11[j].g[i].f; 
 a12[i].g[j].f:=b; b:=a12[j].g[i].f; 
 a13[i].g[j].f:=b; b:=a13[j].g[i].f; 
 a14[i].g[j].f:=b; b:=a14[j].g[i].f; 
 a15[i].g[j].f:=b; b:=a15[j].g[i].f; 
 a16[i].g[j].f:=b; b:=a16[j].g[i].f; 
 a17[i].g[j].f:=b; b:=a17[j].g[i].f; 
 a18[i].g[j].f:=b; b:=a18[j].g[i].f; 
 a19[i].g[j].f:=b; b:=a19[j].g[i].f; 
END P;

PROCEDURE P2(
VAR si:SHORTINT; 
VAR in:INTEGER; 
VAR li:LONGINT;        
VAR r:tr;
VAR     a1 :ta1 ;
VAR     a2 :ta2 ;
VAR     a3 :ta3 ;
VAR     a4 :ta4 ;
VAR     a5 :ta5 ;
VAR     a6 :ta6 ;
VAR     a7 :ta7 ;
VAR     a8 :ta8 ;
VAR     a9 :ta9 ;
VAR     a10:ta10;
VAR     a11:ta11;
VAR     a12:ta12;
VAR     a13:ta13;
VAR     a14:ta14;
VAR     a15:ta15;
VAR     a16:ta16;
VAR     a17:ta17;
VAR     a18:ta18;
VAR     a19:ta19);

 PROCEDURE Q;
 BEGIN (* Q *)
  si:=si; in:=in; li:=li; 
  
  in:=r.j.h; 
  r.j.h:=in;    
  a1[li]:=0X; 
  a1[li]:=a1[li]; 	  
  
  a2 [i].g[j].f:=b; b:=a2 [j].g[i].f; 
  a3 [i].g[j].f:=b; b:=a3 [j].g[i].f; 
  a4 [i].g[j].f:=b; b:=a4 [j].g[i].f; 
  a5 [i].g[j].f:=b; b:=a5 [j].g[i].f; 
  a6 [i].g[j].f:=b; b:=a6 [j].g[i].f; 
  a7 [i].g[j].f:=b; b:=a7 [j].g[i].f; 
  a8 [i].g[j].f:=b; b:=a8 [j].g[i].f; 
  a9 [i].g[j].f:=b; b:=a9 [j].g[i].f; 
  a10[i].g[j].f:=b; b:=a10[j].g[i].f; 
  a11[i].g[j].f:=b; b:=a11[j].g[i].f; 
  a12[i].g[j].f:=b; b:=a12[j].g[i].f; 
  a13[i].g[j].f:=b; b:=a13[j].g[i].f; 
  a14[i].g[j].f:=b; b:=a14[j].g[i].f; 
  a15[i].g[j].f:=b; b:=a15[j].g[i].f; 
  a16[i].g[j].f:=b; b:=a16[j].g[i].f; 
  a17[i].g[j].f:=b; b:=a17[j].g[i].f; 
  a18[i].g[j].f:=b; b:=a18[j].g[i].f; 
  a19[i].g[j].f:=b; b:=a19[j].g[i].f; 
 END Q;

BEGIN (* P2 *)
 si:=si; in:=in; li:=li; 
 
 in:=r.j.h; 
 r.j.h:=in;    
 a1[li]:=0X; 
 a1[li]:=a1[li]; 	  
 
 a2 [i].g[j].f:=b; b:=a2 [j].g[i].f; 
 a3 [i].g[j].f:=b; b:=a3 [j].g[i].f; 
 a4 [i].g[j].f:=b; b:=a4 [j].g[i].f; 
 a5 [i].g[j].f:=b; b:=a5 [j].g[i].f; 
 a6 [i].g[j].f:=b; b:=a6 [j].g[i].f; 
 a7 [i].g[j].f:=b; b:=a7 [j].g[i].f; 
 a8 [i].g[j].f:=b; b:=a8 [j].g[i].f; 
 a9 [i].g[j].f:=b; b:=a9 [j].g[i].f; 
 a10[i].g[j].f:=b; b:=a10[j].g[i].f; 
 a11[i].g[j].f:=b; b:=a11[j].g[i].f; 
 a12[i].g[j].f:=b; b:=a12[j].g[i].f; 
 a13[i].g[j].f:=b; b:=a13[j].g[i].f; 
 a14[i].g[j].f:=b; b:=a14[j].g[i].f; 
 a15[i].g[j].f:=b; b:=a15[j].g[i].f; 
 a16[i].g[j].f:=b; b:=a16[j].g[i].f; 
 a17[i].g[j].f:=b; b:=a17[j].g[i].f; 
 a18[i].g[j].f:=b; b:=a18[j].g[i].f; 
 a19[i].g[j].f:=b; b:=a19[j].g[i].f; 
END P2;

BEGIN (* m1 *)  
 si:=si; in:=in; li:=li; 
 
 in:=r.j.h; 
 r.j.h:=in;    
 a1[li]:=0X; 
 a1[li]:=a1[li]; 	  
 
 a2 [i].g[j].f:=b; b:=a2 [j].g[i].f; 
 a3 [i].g[j].f:=b; b:=a3 [j].g[i].f; 
 a4 [i].g[j].f:=b; b:=a4 [j].g[i].f; 
 a5 [i].g[j].f:=b; b:=a5 [j].g[i].f; 
 a6 [i].g[j].f:=b; b:=a6 [j].g[i].f; 
 a7 [i].g[j].f:=b; b:=a7 [j].g[i].f; 
 a8 [i].g[j].f:=b; b:=a8 [j].g[i].f; 
 a9 [i].g[j].f:=b; b:=a9 [j].g[i].f; 
 a10[i].g[j].f:=b; b:=a10[j].g[i].f; 
 a11[i].g[j].f:=b; b:=a11[j].g[i].f; 
 a12[i].g[j].f:=b; b:=a12[j].g[i].f; 
 a13[i].g[j].f:=b; b:=a13[j].g[i].f; 
 a14[i].g[j].f:=b; b:=a14[j].g[i].f; 
 a15[i].g[j].f:=b; b:=a15[j].g[i].f; 
 a16[i].g[j].f:=b; b:=a16[j].g[i].f; 
 a17[i].g[j].f:=b; b:=a17[j].g[i].f; 
 a18[i].g[j].f:=b; b:=a18[j].g[i].f; 
 a19[i].g[j].f:=b; b:=a19[j].g[i].f; 
END m1.


