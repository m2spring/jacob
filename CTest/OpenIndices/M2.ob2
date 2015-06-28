MODULE M2;
IMPORT O:=Out, S:=SYSTEM; 

VAR s5:ARRAY 5 OF CHAR; 
    a:ARRAY 6,10 OF CHAR; 
    i:LONGINT; 
(*<<<<<<<<<<<<<<<

PROCEDURE P1(a:ARRAY OF ARRAY OF CHAR);

 PROCEDURE Q;
 BEGIN (* Q *)
  COPY(a[i],s5);
 END Q;

BEGIN (* P1 *)
 Q;
END P1;
>>>>>>>>>>>>>>>*)

VAR p:POINTER TO ARRAY OF ARRAY OF CHAR;
    q:ARRAY 10 OF RECORD
                   f:LONGINT; 
                   g:ARRAY 29 OF RECORD
                                  f:SHORTINT; 
                                  p:POINTER TO ARRAY OF ARRAY OF CHAR;
                                 END;
                  END;
    j,k,l:SHORTINT; 
PROCEDURE P2;
BEGIN (* P2 *)
(*<<<<<<<<<<<<<<<
 COPY(p[i],s5);     
 COPY(q[j].g[k].p[l],p[i]);
>>>>>>>>>>>>>>>*)
 i:=S.ADR(q[j].g[k].p[l]);
END P2;

BEGIN (* M2 *) 
(*<<<<<<<<<<<<<<<
 a[0]:=''; 
 a[1]:='1'; 
 a[2]:='12'; 
 a[3]:='123'; 
 a[4]:='1234'; 
 a[5]:='12345'; 
 
 i:=-1; 
 INC(i); P1(a); O.String('"'); O.String(s5); O.String('"'); O.Ln;
 INC(i); P1(a); O.String('"'); O.String(s5); O.String('"'); O.Ln;
 INC(i); P1(a); O.String('"'); O.String(s5); O.String('"'); O.Ln;
 INC(i); P1(a); O.String('"'); O.String(s5); O.String('"'); O.Ln;
 INC(i); P1(a); O.String('"'); O.String(s5); O.String('"'); O.Ln;
 INC(i); P1(a); O.String('"'); O.String(s5); O.String('"'); O.Ln;
>>>>>>>>>>>>>>>*)
END M2.
