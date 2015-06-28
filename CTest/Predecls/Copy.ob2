MODULE Copy;
IMPORT O:=Out; 
VAR a1:ARRAY 1 OF CHAR; 
    a2:ARRAY 2 OF CHAR; 
    a3:ARRAY 3 OF CHAR; 
    a4:ARRAY 4 OF CHAR; 
    a5:ARRAY 5 OF CHAR; 
    a6:ARRAY 6 OF CHAR; 
    a7:ARRAY 7 OF CHAR; 
    a8:ARRAY 8 OF CHAR; 
    a9:ARRAY 9 OF CHAR; 
    aA:ARRAY 10 OF CHAR; 
    aB:ARRAY 11 OF CHAR; 
    aC:ARRAY 12 OF CHAR; 
    aD:ARRAY 13 OF CHAR; 
    aE:ARRAY 14 OF CHAR; 
    aF:ARRAY 15 OF CHAR; 
    aG:ARRAY 16 OF CHAR; 
    aH:ARRAY 17 OF CHAR; 
    aI:ARRAY 18 OF CHAR; 
    aJ:ARRAY 19 OF CHAR; 
    aK:ARRAY 20 OF CHAR; 
    a100:ARRAY 100 OF CHAR; 
    a101:ARRAY 101 OF CHAR; 
    a10000,b10000:ARRAY 100000 OF CHAR; 
    
(************************************************************************************************************************)
PROCEDURE P1;
BEGIN (* P1 *)
 COPY(a1,aK); 
 COPY(a2,aK); 
 COPY(a3,aK); 
 COPY(a4,aK); 
 COPY(a5,aK); 
 COPY(a6,aK); 
 COPY(a7,aK); 
 COPY(a8,aK); 
 COPY(a9,aK); 
 COPY(aA,aK); 
 COPY(aB,aK); 
 COPY(aC,aK); 
 COPY(aD,aK); 
 COPY(aE,aK); 
 COPY(aF,aK); 
 COPY(aG,aK); 
 COPY(aH,aK); 
 COPY(aI,aK); 
 COPY(aJ,aK); 
 COPY(aK,aK); 
END P1;

(************************************************************************************************************************)
PROCEDURE P(s:ARRAY OF CHAR);
BEGIN (* P *)              
 COPY(s,a100); COPY(a100,a101);
 COPY(a101,a10000); 
 b10000:=a10000; 
 COPY(b10000,a101);
 O.String(a101); O.Ln;
END P;

BEGIN (* Copy *)
 COPY(0X,a1); P(a1); 
 COPY('1',a1); P(a1); 
 COPY(0X,aA); P(aA); 
 COPY('1',aA); P(aA); 

 COPY('',a1); P(a1); 
 COPY('',aA); P(aA); 

 COPY('12',a1); P(a1); 
 COPY('12',a2); P(a2); 
 COPY('12',a3); P(a3); 
 COPY('12',a4); P(a4); 
 
 COPY('123',a1); P(a1); 
 COPY('123',a2); P(a2); 
 COPY('123',a3); P(a3); 
 COPY('123',a4); P(a4); 
 
 COPY('123',a5); P(a5); 
 COPY('1234',a5); P(a5); 
 COPY('12345',a5); P(a5); 
 
 COPY('1234',a6); P(a6); 
 COPY('12345',a6); P(a6); 
 COPY('123456',a6); P(a6); 
 
 COPY('12345',a7); P(a7); 
 COPY('123456',a7); P(a7); 
 COPY('1234567',a7); P(a7); 
 
 COPY('123456',a8); P(a8); 
 COPY('1234567',a8); P(a8); 
 COPY('12345678',a8); P(a8); 
 
 COPY('1234567',a9); P(a9); 
 COPY('12345678',a9); P(a9); 
 COPY('123456789',a9); P(a9); 
 
 COPY('12345678',aA); P(aA); 
 COPY('123456789',aA); P(aA); 
 COPY('123456789A',aA); P(aA); 
 
 COPY('12345678',aA); P(aA); 
 COPY('123456789',aA); P(aA); 
 COPY('123456789A',aA); P(aA); 
 
 COPY('123456789',aB); P(aB); 
 COPY('123456789A',aB); P(aB); 
 COPY('123456789AB',aB); P(aB); 
 
 COPY('123456789A',aC); P(aC); 
 COPY('123456789AB',aC); P(aC); 
 COPY('123456789ABC',aC); P(aC); 
 
 COPY('123456789AB',aD); P(aD); 
 COPY('123456789ABC',aD); P(aD); 
 COPY('123456789ABCD',aD); P(aD); 
 
 COPY('123456789ABC',aE); P(aE); 
 COPY('123456789ABCD',aE); P(aE); 
 COPY('123456789ABCDE',aE); P(aE); 
 
 COPY('123456789ABCD',aF); P(aF); 
 COPY('123456789ABCDE',aF); P(aF); 
 COPY('123456789ABCDEF',aF); P(aF); 
 
 COPY('123456789ABCDE',aG); P(aG); 
 COPY('123456789ABCDEF',aG); P(aG); 
 COPY('123456789ABCDEFG',aG); P(aG); 
 
 COPY('123456789ABCDEF',aH); P(aH); 
 COPY('123456789ABCDEFG',aH); P(aH); 
 COPY('123456789ABCDEFGH',aH); P(aH); 
 
 COPY('123456789ABCDEFG',aI); P(aI); 
 COPY('123456789ABCDEFGH',aI); P(aI); 
 COPY('123456789ABCDEFGHI',aI); P(aI); 

 COPY('123456789ABCDEFGH',aJ); P(aJ); 
 COPY('123456789ABCDEFGHI',aJ); P(aJ); 
 COPY('123456789ABCDEFGHIJ',aJ); P(aJ); 

 COPY('123456789ABCDEFGHI',aK); P(aK); 
 COPY('123456789ABCDEFGHIJ',aK); P(aK); 
 COPY('123456789ABCDEFGHIJK',aK); P(aK); 
END Copy.
