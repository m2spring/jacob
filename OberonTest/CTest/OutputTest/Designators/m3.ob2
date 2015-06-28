MODULE m3;
VAR a:ARRAY 20 OF LONGINT;
    i,j,k:LONGINT; 
BEGIN (* m3 *) 
 i:=j+k; 
 a[a[i]+a[i]+a[i]+a[i]+a[i]+a[i]+a[i]+a[i]+a[i]+a[i]]:=1; 
 a[a[a[a[a[i]]]]]:=1; 
END m3.
