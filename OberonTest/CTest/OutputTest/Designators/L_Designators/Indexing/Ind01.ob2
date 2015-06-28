MODULE Ind01;
(*% Nonterminals *)

VAR s:BOOLEAN;
    r1:RECORD
        s:BOOLEAN;
        a1:ARRAY 10 OF RECORD
                        s:SET;
                        a2:ARRAY 10 OF BOOLEAN;
                       END;
       END;

    r2:RECORD
        a1:ARRAY 10 OF CHAR;
       END;

    l1,l2:LONGINT; 
    
BEGIN (* Ind01 *)
 s:=TRUE;                   (* GV *)
 r1.s:=FALSE;               (* GV Selecting *)
 r1.a1[l1].s:={};           (* GV Selecting Index Selecting => Ireg *)
 r1.a1[l1].a2[l2]:=TRUE;    (* GV Selecting Index Selecting Index=> BregIreg *)

 r2.a1[l1]:=0X;             (* GV Selecting Index(CHAR) => Breg *)
END Ind01.
