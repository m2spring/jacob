MODULE InclExcl;
VAR se:SET;
    si:SHORTINT; 
    in:INTEGER; 
    li:LONGINT; 
BEGIN (* InclExcl *)
 si:=-1; 
 INCL(se,5); 
 INCL(se,si); 
 INCL(se,in); 
 INCL(se,li); 

 EXCL(se,31); 
 EXCL(se,si); 
 EXCL(se,in); 
 EXCL(se,li); 
END InclExcl.
