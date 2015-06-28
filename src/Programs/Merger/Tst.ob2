MODULE Tst;
VAR e:POINTER TO RECORD
		  f:BOOLEAN; 
                  msg:POINTER TO ARRAY OF CHAR; 
                 END;
    len:LONGINT; 
BEGIN (* Tst *)
 NEW(e.msg,len+1); 
END Tst.
