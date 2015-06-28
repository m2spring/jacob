MODULE M1;
VAR siA,siB:SHORTINT; 
    inA,inB:INTEGER; 
    liA,liB:LONGINT; 
    s:SET;
BEGIN (* M1 *)
 s:={siA}; s:={siA..siB}; 
 s:={inA}; s:={inA..inB}; 
 s:={liA}; s:={liA..liB}; 
END M1.
