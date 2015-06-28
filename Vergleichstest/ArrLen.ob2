MODULE ArrLen;
VAR v: ARRAY 2,LEN(v,0) OF CHAR;
(*                  ^ err 131: LEN not applied to array *)
END ArrLen.
