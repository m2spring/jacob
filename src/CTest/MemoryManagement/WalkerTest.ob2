MODULE WalkerTest;

TYPE tDummy  = ARRAY 3 OF CHAR;
     tMark*  = POINTER TO ARRAY 10 OF CHAR;
     tMark1* = RECORD 
                f:tMark;
               END;
     tMark2* = RECORD
                f,g:tMark;
               END;
     tMark4* = RECORD
                f:ARRAY 10 OF tMark;
               END;		    
     tMark8* = RECORD
                f:ARRAY 11 OF RECORD
			       g:LONGINT; 
                               f:tMark;
                              END;
               END;	       
     tMark9* = RECORD
                f:ARRAY 12 OF RECORD
			       f:LONGINT; 
                               g:tMark;
			       h:BOOLEAN; 
                              END;
               END;
     tMarkS* = RECORD
                f:ARRAY 13 OF RECORD
                               f:BOOLEAN; 
			       g:ARRAY 14 OF tMark;
                              END;
               END;	       
VAR  mark1:tMark1; dummy1:tDummy;
     mark2:tMark2; dummy2:tDummy;
     mark4:tMark4; dummy3:tDummy;
     mark8:tMark8; dummy4:tDummy;
     mark9:tMark9; dummy5:tDummy;
     markS:tMarkS; dummy6:tDummy;
     
PROCEDURE P;
BEGIN (* P *)
END P;

BEGIN (* WalkerTest *)
 P;
END WalkerTest.
