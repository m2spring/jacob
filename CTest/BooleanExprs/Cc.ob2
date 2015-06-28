MODULE Cc;
IMPORT O:=Out, S:=SYSTEM; 

VAR a:LONGINT; f:BOOLEAN; 
BEGIN (* Cc *)		
 IF S.CC(S.cf) THEN a:=1; ELSE a:=2; END; (* IF *)
 IF S.CC(S.pf) THEN a:=1; ELSE a:=2; END; (* IF *)
 IF S.CC(S.af) THEN a:=1; ELSE a:=2; END; (* IF *)
 IF S.CC(S.zf) THEN a:=1; ELSE a:=2; END; (* IF *)
 IF S.CC(S.sf) THEN a:=1; ELSE a:=2; END; (* IF *)
 IF S.CC(S.tf) THEN a:=1; ELSE a:=2; END; (* IF *)
 IF S.CC(S.if) THEN a:=1; ELSE a:=2; END; (* IF *)
 IF S.CC(S.df) THEN a:=1; ELSE a:=2; END; (* IF *)
 IF S.CC(S.of) THEN a:=1; ELSE a:=2; END; (* IF *)
 IF S.CC(S.nt) THEN a:=1; ELSE a:=2; END; (* IF *)
 IF S.CC(S.rf) THEN a:=1; ELSE a:=2; END; (* IF *)
 IF S.CC(S.vm) THEN a:=1; ELSE a:=2; END; (* IF *)
 IF S.CC(S.ac) THEN a:=1; ELSE a:=2; END; (* IF *)
 
 f:=S.CC(S.cf); 
 f:=S.CC(S.pf); 
 f:=S.CC(S.af); 
 f:=S.CC(S.zf); 
 f:=S.CC(S.sf); 
 f:=S.CC(S.tf); 
 f:=S.CC(S.if); 
 f:=S.CC(S.df); 
 f:=S.CC(S.of); 
 f:=S.CC(S.nt); 
 f:=S.CC(S.rf); 
 f:=S.CC(S.vm); 
 f:=S.CC(S.ac); 
END Cc.
