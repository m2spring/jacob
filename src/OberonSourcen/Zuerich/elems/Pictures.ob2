MODULE Pictures;
IMPORT Files;

TYPE Picture* = POINTER TO RECORD 
                            width*,height*,depth*:INTEGER; 
                            notify*:PROCEDURE;
                           END;

PROCEDURE Create*(VAR p:Picture; w,h,d:LONGINT);
BEGIN (* Create *)
END Create;

PROCEDURE CopyBlock*(pa,pb:Picture; p1,p2,p3,p4,p5,p6,p7:LONGINT);
BEGIN (* CopyBlock *)
END CopyBlock;

PROCEDURE DisplayBlock*(p:Picture; p1,p2,p3,p4,p5,p6,p7:LONGINT);
BEGIN (* DisplayBlock *)
END DisplayBlock;

PROCEDURE Copy*(pa,pb:Picture; p1,p2,p3,p4,p5,p6,p7,p8,p9:LONGINT);
BEGIN (* Copy *)
END Copy;

PROCEDURE Address*(p:Picture):LONGINT; 
BEGIN (* Address *)                    
 RETURN 0; 
END Address;

PROCEDURE Load*(p:Picture; f:Files.File; p1,p2:LONGINT);
BEGIN (* Load *)
END Load;

PROCEDURE Store*(p:Picture; f:Files.File; p1,p2:LONGINT);
BEGIN (* Store *)
END Store;

PROCEDURE Open*(p:Picture; n:ARRAY OF CHAR);
BEGIN (* Open *)
END Open;


END Pictures.
