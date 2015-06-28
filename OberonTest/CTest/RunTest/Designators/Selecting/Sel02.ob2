MODULE Sel02;
(*% Selecting: Komplexe Designatoren mit fixed COPY und ORD *)

IMPORT O:=Out;

TYPE 
  T0 = RECORD
        s1:ARRAY 3 OF CHAR;
        s2:ARRAY 3 OF CHAR;
        e:RECORD
           s:ARRAY 5 OF CHAR; 
          END;
       END;

  T1 = RECORD
        s: ARRAY 5 OF CHAR; 
       END;

VAR 
  r0:T0;   
  r1:T1;
  
BEGIN (* Sel02 *)
 r0.s1:='AB';
 r0.s2:='CD';
 r0.e.s[0]:=r0.s1[0];
 r0.e.s[1]:=r0.s1[1];
 r0.e.s[2]:=r0.s2[0];
 r0.e.s[3]:=r0.s2[1];
 
 O.String(r0.s1); O.Ln;
 O.String(r0.s2); O.Ln;
 O.String(r0.e.s); O.Ln;

 COPY(r0.e.s,r1.s);
 
 O.Char(r1.s[ ORD(r1.s[3])-ORD('A')-3 ]);
 O.Char(r1.s[ ORD(r1.s[2])-ORD('A')-1 ]);
 O.Char(r1.s[ ORD(r1.s[1])-ORD('A')+1 ]);
 O.Char(r1.s[ ORD(r1.s[0])-ORD('A')+3 ]); O.Ln;
END Sel02.
