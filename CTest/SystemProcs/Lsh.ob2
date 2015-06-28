MODULE Lsh;
IMPORT S:=SYSTEM; 

CONST c1=1;
      c2=-1;
VAR ssi:SHORTINT; 
    sin:INTEGER;  
    sli:LONGINT; 
    
    si:SHORTINT; 
    in:INTEGER; 
    li:LONGINT; 
    by:S.BYTE;
    ch:CHAR; 
BEGIN (* Lsh *)
(*<<<<<<<<<<<<<<<
 si:=S.LSH(si,ssi); si:=S.LSH(si,sin); si:=S.LSH(si,sli);
 in:=S.LSH(in,ssi); in:=S.LSH(in,sin); in:=S.LSH(in,sli);
 li:=S.LSH(li,ssi); li:=S.LSH(li,sin); li:=S.LSH(li,sli);
 by:=S.LSH(by,ssi); by:=S.LSH(by,sin); by:=S.LSH(by,sli);
 ch:=S.LSH(ch,ssi); ch:=S.LSH(ch,sin); ch:=S.LSH(ch,sli);
>>>>>>>>>>>>>>>*)
 li:=S.LSH(li,-16); 
 in:=S.LSH(in,-15); 
 in:=S.LSH(in,-1); 
 in:=S.LSH(in, 0); 
 in:=S.LSH(in, 1); 
 in:=S.LSH(in, 15); 
 in:=S.LSH(in, 16); 
END Lsh.
