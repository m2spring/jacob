(* Qualident-Type und Array-Type *)

MODULE pars030t;

TYPE
a = laber;
b = la.ber;
c = ARRAY OF laber;
d = ARRAY 2 OF BLA;
e = ARRAY 2 OF ARRAY 3 OF Type1;
f = ARRAY 1,2,3,4,5 OF Type2;
g = ARRAY OF ARRAY OF ARRAY OF ARRAY 1,2,3 OF ARRAY OF ARRAY OF la.ber;
h = ARRAY 3+4 OF POINTER TO laber;

END pars030t.
