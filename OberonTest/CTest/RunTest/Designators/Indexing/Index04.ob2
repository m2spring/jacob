MODULE Index04;
(*% Indexing: Fixed mit sehr langen Indexausdruecken *)

IMPORT O:=Out;

TYPE 
  T0  = ARRAY 5 OF INTEGER;
  T1  = ARRAY 5 OF ARRAY 5 OF INTEGER;
  T2  = ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF INTEGER;
  T3  = ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF INTEGER;
  T4  = ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF INTEGER;
  T5  = ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF INTEGER;
  T6  = ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF INTEGER;
  T7  = ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF INTEGER;
  T8  = ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF ARRAY 5 OF INTEGER;

VAR 
 a0 :T0 ;
 a1 :T1 ;
 a2 :T2 ;
 a3 :T3 ;
 a4 :T4 ;
 a5 :T5 ;
 a6 :T6 ;
 a7 :T7 ;
 a8 :T8 ;

 i, j, k, l, m, n, o, p, q:LONGINT; 

PROCEDURE P;
VAR
 i, j, k, l, m, n, o, p, q:LONGINT; 
 a0 :T0 ;
 a1 :T1 ;
 a2 :T2 ;
 a3 :T3 ;
 a4 :T4 ;
 a5 :T5 ;
 a6 :T6 ;
 a7 :T7 ;
 a8 :T8 ;

BEGIN (* P *)
 i:=0;
 j:=1;
 k:=2;
 l:=3;
 m:=4;
 n:=0;
 o:=1;
 p:=2;
 q:=3;

 a0 [i]:=4711; 
 a1 [i,j]:=4711; 
 a2 [i,j,k]:=4711; 
 a3 [i,j,k,l]:=4711; 
 a4 [i,j,k,l,m]:=4711; 
 a5 [i,j,k,l,m,n]:=4711; 
 a6 [i,j,k,l,m,n,o]:=4711; 
 a7 [i,j,k,l,m,n,o,p]:=4711; 
 a8 [i,j,k,l,m,n,o,p,q]:=4711; 
 
 O.String('a0='); O.Int(a0 [i]                     ); O.Ln;
 O.String('a1='); O.Int(a1 [i,j]                   ); O.Ln;
 O.String('a2='); O.Int(a2 [i,j,k]                 ); O.Ln;
 O.String('a3='); O.Int(a3 [i,j,k,l]               ); O.Ln;
 O.String('a4='); O.Int(a4 [i,j,k,l,m]             ); O.Ln;
 O.String('a5='); O.Int(a5 [i,j,k,l,m,n]           ); O.Ln;
 O.String('a6='); O.Int(a6 [i,j,k,l,m,n,o]         ); O.Ln;
 O.String('a7='); O.Int(a7 [i,j,k,l,m,n,o,p]       ); O.Ln;
 O.String('a8='); O.Int(a8 [i,j,k,l,m,n,o,p,q]     ); O.Ln;
END P;

BEGIN (* Index04 *)
 i:=0;
 j:=1;
 k:=2;
 l:=3;
 m:=4;
 n:=0;
 o:=1;
 p:=2;
 q:=3;

 a0 [i]:=4711; 
 a1 [i,j]:=4711; 
 a2 [i,j,k]:=4711; 
 a3 [i,j,k,l]:=4711; 
 a4 [i,j,k,l,m]:=4711; 
 a5 [i,j,k,l,m,n]:=4711; 
 a6 [i,j,k,l,m,n,o]:=4711; 
 a7 [i,j,k,l,m,n,o,p]:=4711; 
 a8 [i,j,k,l,m,n,o,p,q]:=4711; 

 O.String('a0='); O.Int(a0 [i]                     ); O.Ln;
 O.String('a1='); O.Int(a1 [i,j]                   ); O.Ln;
 O.String('a2='); O.Int(a2 [i,j,k]                 ); O.Ln;
 O.String('a3='); O.Int(a3 [i,j,k,l]               ); O.Ln;
 O.String('a4='); O.Int(a4 [i,j,k,l,m]             ); O.Ln;
 O.String('a5='); O.Int(a5 [i,j,k,l,m,n]           ); O.Ln;
 O.String('a6='); O.Int(a6 [i,j,k,l,m,n,o]         ); O.Ln;
 O.String('a7='); O.Int(a7 [i,j,k,l,m,n,o,p]       ); O.Ln;
 O.String('a8='); O.Int(a8 [i,j,k,l,m,n,o,p,q]     ); O.Ln;
 O.Ln;
 P;
END Index04.
