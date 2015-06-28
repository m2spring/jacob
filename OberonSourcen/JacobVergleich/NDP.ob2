MODULE NDP;
IMPORT ARG, ASM, ASMOP, ERR, O;

CONST ebp=ASM.ebp; l=ASM.l;
CONST fdecstp=ASMOP.fdecstp; fstp=ASMOP.fstp;

CONST MaxNofRegs               = 8;
      TempSize                 = 8;
VAR   Top, MaxSavedTop         ,
      NofFTemps, MaxNofFTemps  ,
      FTempOfs                 : LONGINT; 

(************************************************************************************************************************)
PROCEDURE Init*(ftempOfs:LONGINT); 
BEGIN (* Init *)     
 Top:=0; MaxSavedTop:=0; NofFTemps:=0; MaxNofFTemps:=0; FTempOfs:=ftempOfs; 
END Init;

(************************************************************************************************************************)
PROCEDURE SetTop*(top:LONGINT); 
BEGIN (* SetTop *)
 Top:=top; 
END SetTop;

(************************************************************************************************************************)
PROCEDURE UsedTempSize*():LONGINT; 
BEGIN (* UsedTempSize *)	  
 RETURN TempSize*MaxNofFTemps; 
END UsedTempSize;

PROCEDURE^CS1(oper:ASMOP.tOper; s:ASM.tSize; op:ASM.tOp); 

(************************************************************************************************************************)
PROCEDURE C0*(oper:ASMOP.tOper); 
BEGIN (* C0 *)
 CS1(oper,ASM.NoSize,ASM.EmptyOp); 
END C0;

(************************************************************************************************************************)
PROCEDURE C1*(oper:ASMOP.tOper; op:ASM.tOp); 
BEGIN (* C1 *)
 CS1(oper,ASM.NoSize,op); 
END C1;

(************************************************************************************************************************)
PROCEDURE CS1*(oper:ASMOP.tOper; s:ASM.tSize; op:ASM.tOp); 
VAR change:LONGINT; 
BEGIN (* CS1 *)
 IF (oper<ASMOP.FirstFOP) OR (ASMOP.LastFOP<oper) THEN ERR.Fatal('NDP: invalid op code'); END; (* IF *)

 change:=ASMOP.FloatChangeTab[oper]; 
 
 IF change=1 THEN 
    IF Top<MaxNofRegs THEN 
       INC(Top); 
    ELSE 
       ASM.C0 ( fdecstp                                        ); 
       ASM.CS1( fstp,l  ,  ASM.oB(FTempOfs-NofFTemps*TempSize,ebp) ); 
       INC(NofFTemps); 
       IF NofFTemps>MaxNofFTemps THEN MaxNofFTemps:=NofFTemps; END; (* IF *)
       IF ARG.OptionCommentsInAsm THEN ASM.CmtS('FTEMP '); ASM.CmtI(NofFTemps); END; (* IF *)
    END; (* IF *)

 ELSIF (change=-1) OR (change=-2) THEN 
    IF ASMOP.FloatDyOpTab[oper] & (op=ASM.EmptyOp) & (Top=1) THEN 
       IF NofFTemps<=0 THEN ERR.Fatal('NDP: stack empty'); END; (* IF *)
       DEC(NofFTemps); 
       oper:=ASMOP.UnpopFloatTab[oper]; s:=ASM.l; op:=ASM.oB(FTempOfs-NofFTemps*TempSize,ASM.ebp); 
       IF change=-2 THEN DEC(Top); END; (* IF *)
    ELSE 
       IF Top<=0 THEN ERR.Fatal('NDP: stack empty'); END; (* IF *)
       INC(Top,change); 
    END; (* IF *)

 ELSE 
    INC(Top,change);    
 END; (* IF *)

 ASM.CS1(oper,s,op); 
 IF ARG.OptionCommentsInAsm THEN ASM.CmtI(Top); END; (* IF *)
END CS1;

(************************************************************************************************************************)
PROCEDURE Save*;
BEGIN (* Save *)
 IF Top=0 THEN RETURN; END; (* IF *)
 
 IF ARG.OptionCommentsInAsm THEN ASM.CmtLnS('	save NDP stack'); END; (* IF *)

 WHILE Top>0 DO
  ASM.CS1( fstp,l  ,  ASM.oB(FTempOfs-NofFTemps*TempSize,ebp) ); 
  INC(NofFTemps); 
  IF ARG.OptionCommentsInAsm THEN ASM.CmtS('FTEMP '); ASM.CmtI(NofFTemps); END; (* IF *)
  DEC(Top); 
 END; (* WHILE *)
 IF NofFTemps>MaxNofFTemps THEN MaxNofFTemps:=NofFTemps; END; (* IF *)
END Save;

(************************************************************************************************************************)
END NDP.

