MODULE CharLen;
VAR a: ARRAY 1 OF CHAR;
BEGIN
   a := 0X;
   a := 1X;
(*        ^ err 114: string too long to be assigned *)
END CharLen.
