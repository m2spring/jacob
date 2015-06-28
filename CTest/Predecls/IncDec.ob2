MODULE IncDec;
VAR si:SHORTINT; 
    in:INTEGER; 
    li:LONGINT; 
BEGIN (* IncDec *)
 DEC(si); 
 DEC(in); 
 DEC(li); 
 
DEC(si,si); 
 DEC(in,si); 
 DEC(in,in); 
 DEC(li,si); 
 DEC(li,in); 
 DEC(li,li); 

 DEC(si,   -1); 
 DEC(si,    0); 
 DEC(si,    1); 
	   
 DEC(in,    1); 
 DEC(in,  128); 
 	  
 DEC(li,    1); 
 DEC(li,  128); 
 DEC(li,32768); 
END IncDec.
