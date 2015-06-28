MODULE OpenArrayVarPar;

TYPE T = POINTER TO RECORD
          f:LONGINT; 
         END;
     ARRAY_1_OF_T = ARRAY 1 OF T;
     ARRAY_10_OF_T = ARRAY 10 OF T;
     ARRAY_10_OF_ARRAY_20_OF_T = ARRAY 10,20 OF T;
     ARRAY_10_OF_ARRAY_20_OF_ARRAY_30_OF_T = ARRAY 10,20,30 OF T;
     ARRAY_10_OF_ARRAY_20_OF_ARRAY_30_OF_ARRAY_40_OF_T = ARRAY 10,20,30,40 OF T;
     ARRAY_10_OF_ARRAY_20_OF_ARRAY_30_OF_ARRAY_40_OF_ARRAY_50_OF_T = ARRAY 10,20,30,40,50 OF T;
     ARRAY_10_OF_ARRAY_20_OF_ARRAY_30_OF_ARRAY_40_OF_ARRAY_50_OF_ARRAY_3_OF_T = ARRAY 10,20,30,40,50,3 OF T;
VAR i,j,k,l,m,n,o:LONGINT; 
    p1:POINTER TO ARRAY OF T;
    p2:POINTER TO ARRAY OF ARRAY OF T;
    p3:POINTER TO ARRAY OF ARRAY OF ARRAY OF T;
    p4:POINTER TO ARRAY OF ARRAY OF ARRAY OF ARRAY OF T;
    p5:POINTER TO ARRAY OF ARRAY OF ARRAY OF ARRAY OF ARRAY OF T;
    p6:POINTER TO ARRAY OF ARRAY OF ARRAY OF ARRAY OF ARRAY OF ARRAY OF T;

(************************************************************************************************************************)
PROCEDURE P1F(VAR p:ARRAY OF T);
BEGIN (* P1F *)
END P1F;

PROCEDURE P1A(VAR p:ARRAY_10_OF_T);
BEGIN (* P1A *)	  
 P1F(p); P1F(p1^); 
END P1A;

(************************************************************************************************************************)
PROCEDURE P2F(VAR p:ARRAY OF ARRAY OF T);
BEGIN (* P2F *)
END P2F;

PROCEDURE P2A1(VAR p:ARRAY_10_OF_ARRAY_20_OF_T);
BEGIN (* P2A1 *)
 P2F(p);    P2F(p2^); 
 P1F(p[i]); P1F(p2[i]); 
END P2A1;

PROCEDURE P2A2(VAR p:ARRAY OF ARRAY_10_OF_T);
BEGIN (* P2A2 *)
 P2F(p); 
 P1F(p[i]); 
END P2A2;

PROCEDURE P2A3(VAR p:ARRAY OF ARRAY_1_OF_T);
BEGIN (* P2A3 *)
 P2F(p); 
 P1F(p[i]); 
END P2A3;

(************************************************************************************************************************)
PROCEDURE P3F(VAR p:ARRAY OF ARRAY OF ARRAY OF T);
BEGIN (* P3F *)
END P3F;

PROCEDURE P3A1(VAR p:ARRAY_10_OF_ARRAY_20_OF_ARRAY_30_OF_T);
BEGIN (* P3A1 *)			      
 P3F(p); 
 P2F(p[i]);
 P1F(p[i,j]);
END P3A1;

PROCEDURE P3A2(VAR p:ARRAY OF ARRAY_10_OF_ARRAY_20_OF_T);
BEGIN (* P3A2 *)
 P3F(p); 
 P2F(p[i]);
 P1F(p[i,j]);
END P3A2;

PROCEDURE P3A3(VAR p:ARRAY OF ARRAY OF ARRAY_10_OF_T);
BEGIN (* P3A3 *)
 P3F(p); 
 P2F(p[i]);
 P1F(p[i,j]);
END P3A3;

(************************************************************************************************************************)
PROCEDURE P4F(VAR p:ARRAY OF ARRAY OF ARRAY OF ARRAY OF T);
BEGIN (* P4F *)
END P4F;

PROCEDURE P4A1(VAR p:ARRAY_10_OF_ARRAY_20_OF_ARRAY_30_OF_ARRAY_40_OF_T);
BEGIN (* P4A1 *)
 P4F(p);     
 P3F(p[i]); 
 P2F(p[i,j]); 
 P1F(p[i,j,k]); 
END P4A1;

(************************************************************************************************************************)
PROCEDURE P5F(VAR p:ARRAY OF ARRAY OF ARRAY OF ARRAY OF ARRAY OF T);
BEGIN (* P5F *)
END P5F;

PROCEDURE P5A1(VAR p:ARRAY_10_OF_ARRAY_20_OF_ARRAY_30_OF_ARRAY_40_OF_ARRAY_50_OF_T);
BEGIN (* P5A1 *)
 P5F(p);     
 P4F(p[i]); 
 P3F(p[i,j]); 
 P2F(p[i,j,k]); 
 P1F(p[i,j,k,l]); 
END P5A1;

(************************************************************************************************************************)
PROCEDURE P6F(VAR p:ARRAY OF ARRAY OF ARRAY OF ARRAY OF ARRAY OF ARRAY OF T);
BEGIN (* P6F *)
END P6F;

PROCEDURE P6A1(VAR p:ARRAY_10_OF_ARRAY_20_OF_ARRAY_30_OF_ARRAY_40_OF_ARRAY_50_OF_ARRAY_3_OF_T);
BEGIN (* P6A1 *)
 P6F(p);     
 P5F(p[i]); 
 P4F(p[i,j]); 
 P3F(p[i,j,k]); 
 P2F(p[i,j,k,l]); 
 P1F(p[i,j,k,l,m]); 

 p[i,j,k,l,m,n].f:=0; 
END P6A1;

(************************************************************************************************************************)
BEGIN (* OpenArrayVarPar *)
 p1[i].f:=0; 
END OpenArrayVarPar.
