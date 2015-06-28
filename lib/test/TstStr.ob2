MODULE TstStr;
IMPORT O:=Out,S:=Str;

(************************************************************************************************************************)
PROCEDURE Delete;
VAR s:ARRAY 6 OF CHAR; p,l:LONGINT; 
BEGIN (* Delete *)		    
 FOR p:=0 TO LEN(s) DO
  FOR l:=0 TO LEN(s) DO
   s:='01234'; 
   O.Str('Delete("'); O.Str(s); O.Str('",'); 
   O.Int(p); O.Str(','); O.Int(l); O.Str(') --> "'); 
   S.Delete(s,p,l); 
   O.Str(s); O.Str('"'); O.Ln;
  END; (* FOR *)
 END; (* FOR *)
END Delete;

(************************************************************************************************************************)
PROCEDURE FixRealToStr;

 PROCEDURE P(v:LONGREAL);
 VAR s:ARRAY 100 OF CHAR; ok:BOOLEAN; 
 BEGIN (* P *)
  S.FixRealToStr(v,5,s,ok); 
  O.Str(s); O.Ln;
 END P;

BEGIN (* FixRealToStr *)
 O.Str('  1.0D90  '); P(1.0D90); 
 O.Str('100.0     '); P(100.0); 
 O.Str(' 10.0     '); P(10.0); 
 O.Str('  1.0     '); P(1.0); 
 O.Str('  0.1     '); P(0.1); 
 O.Str('  0.01    '); P(0.01); 
 O.Str('  0.001   '); P(0.001); 
 O.Str('  1.0D-90 '); P(1.0D-90); 
END FixRealToStr;

(************************************************************************************************************************)
BEGIN (* TstStr *)
 FixRealToStr;
END TstStr.
