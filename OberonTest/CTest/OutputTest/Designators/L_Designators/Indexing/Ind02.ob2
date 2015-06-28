MODULE Ind02;
(*% Nested Index *)

CONST l1 = 1;
      l2 = 2;
      l3 = 3;
      
VAR vl1, vl2, vl3:LONGINT; 

VAR a:ARRAY 10 OF RECORD
                   i:LONGINT; 
                   a:ARRAY 20 OF ARRAY 3 OF ARRAY 5 OF INTEGER; 
                   r:RECORD
                      a:ARRAY 10 OF RECORD
                                     l:LONGINT; 
                                     a:ARRAY 3 OF LONGINT; 
                                    END;
                     END;
                  END;
BEGIN (* Ind02 *)
 a[l1].i:=l2;
 a[l1].a[l1,l2,l3]:=1; 
 a[l3].r.a[l1].l:=4711; 
 a[l3].r.a[l1].a[l2]:=44; 
 
 vl1:=l1; 
 vl2:=l2; 
 vl3:=l3; 
 
 a[vl1].i:=l2;
 a[vl1].a[vl1,vl2,vl3]:=1; 
 a[vl3].r.a[vl1].l:=4711; 
 a[vl3].r.a[vl1].a[vl2]:=44; 

END Ind02.


