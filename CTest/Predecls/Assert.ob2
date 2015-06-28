MODULE Assert;

PROCEDURE P(b:BOOLEAN);
BEGIN (* P *)	     
 ASSERT(b,1); 
END P;

BEGIN (* Assert *)
(*<<<<<<<<<<<<<<<
 ASSERT(FALSE,2); 
 ASSERT(TRUE,3); 
>>>>>>>>>>>>>>>*)
 P(FALSE);
END Assert.
