MODULE ADR;








IMPORT SYSTEM, System, IO, OB,
(* line 50 "ADR.pum" *)
 LIM, T;

 TYPE   tAddress       = OB.tAddress;   (* These types are re-declared due to the fact that                              *)
               tSize          = OB.tSize;      (* qualidents are illegal in a puma specification.                               *)
               tLevel         = OB.tLevel; 
               tParMode       = OB.tParMode; 
(* line 35 "ADR.pum" *)
 CONST  GlobalVarBase*  = 8;
               ProcParBase*    = 8; 
	       GlobalTmpBase*  = -4;
        VAR    BitRangeTab*    : ARRAY 33 OF LONGINT;
               InvBitRangeTab* : ARRAY 33 OF LONGINT;

VAR yyf*	: IO.tFile;
VAR Exit*	: PROCEDURE;

PROCEDURE^LenOfsFromOpenPointerBaseType* (type: OB.tOB): tAddress;

        PROCEDURE InitBitRangeTab;
        VAR bits,i:LONGINT; 
        BEGIN (* InitBitRangeTab *)
         bits:=0FFFFFFFFH; 
         FOR i:=32 TO 0 BY -1 DO
          BitRangeTab[i]:=bits; InvBitRangeTab[i]:=SYSTEM.VAL(LONGINT,{0..31}-SYSTEM.VAL(SET,bits)); 
          bits:=bits DIV 2; 
         END; (* FOR *)
        END InitBitRangeTab;

        PROCEDURE Align4*(v:tSize):tSize; 
        BEGIN (* Align4 *)
         RETURN SYSTEM.VAL(LONGINT,SYSTEM.VAL(SET,v+3)*SYSTEM.VAL(SET,-4)); 
        END Align4;

        PROCEDURE Align8*(v:tSize):tSize; 
        BEGIN (* Align8 *)
         RETURN SYSTEM.VAL(LONGINT,SYSTEM.VAL(SET,v+7)*SYSTEM.VAL(SET,-8)); 
        END Align8;

        PROCEDURE IntLog2*(v:LONGINT; VAR r:LONGINT):BOOLEAN;
        BEGIN (* IntLog2 *)
         IF    v=00000001H THEN r :=  0;
         ELSIF v=00000002H THEN r :=  1;
         ELSIF v=00000004H THEN r :=  2;
         ELSIF v=00000008H THEN r :=  3;
         ELSIF v=00000010H THEN r :=  4;
         ELSIF v=00000020H THEN r :=  5;
         ELSIF v=00000040H THEN r :=  6;
         ELSIF v=00000080H THEN r :=  7;
         ELSIF v=00000100H THEN r :=  8;
         ELSIF v=00000200H THEN r :=  9;
         ELSIF v=00000400H THEN r := 10;
         ELSIF v=00000800H THEN r := 11;
         ELSIF v=00001000H THEN r := 12;
         ELSIF v=00002000H THEN r := 13;
         ELSIF v=00004000H THEN r := 14;
         ELSIF v=00008000H THEN r := 15;
         ELSIF v=00010000H THEN r := 16;
         ELSIF v=00020000H THEN r := 17;
         ELSIF v=00040000H THEN r := 18;
         ELSIF v=00080000H THEN r := 19;
         ELSIF v=00100000H THEN r := 20;
         ELSIF v=00200000H THEN r := 21;
         ELSIF v=00400000H THEN r := 22;
         ELSIF v=00800000H THEN r := 23;
         ELSIF v=01000000H THEN r := 24;
         ELSIF v=02000000H THEN r := 25;
         ELSIF v=04000000H THEN r := 26;
         ELSIF v=08000000H THEN r := 27;
         ELSIF v=10000000H THEN r := 28;
         ELSIF v=20000000H THEN r := 29;
         ELSIF v=40000000H THEN r := 30;
      (* ELSIF v=80000000H THEN r := 31; *) (* forget it... *)
                           ELSE RETURN FALSE;
         END; (* IF *)
         RETURN TRUE;                  
        END IntLog2;

        PROCEDURE pAligned(a:tAddress; s:tSize):tAddress; 
        BEGIN (* pAligned *)
         CASE s OF
         |0,1,3: RETURN a; 
         |2    : RETURN SYSTEM.VAL(LONGINT,SYSTEM.VAL(SET,a+1)*SYSTEM.VAL(SET,-2)); 
         ELSE    RETURN SYSTEM.VAL(LONGINT,SYSTEM.VAL(SET,a+3)*SYSTEM.VAL(SET,-4)); 
         END; (* CASE *)
        END pAligned; 

        PROCEDURE nAligned(a:tAddress; s:tSize):tAddress; 
        BEGIN (* nAligned *)
         CASE s OF
         |0,1,3: RETURN a; 
         |2    : RETURN SYSTEM.VAL(LONGINT,SYSTEM.VAL(SET,a)*SYSTEM.VAL(SET,-2)); 
         ELSE    RETURN SYSTEM.VAL(LONGINT,SYSTEM.VAL(SET,a)*SYSTEM.VAL(SET,-4)); 
         END; (* CASE *)
        END nAligned; 

        PROCEDURE MaxSize2*(a,b:tSize):tSize;
        BEGIN (* MaxSize2 *)
         IF a>b THEN RETURN a; ELSE RETURN b; END; (* IF *)
        END MaxSize2;

        PROCEDURE MaxSize3*(a,b,c:tSize):tSize;
        BEGIN (* MaxSize3 *)
         IF a>b THEN 
            IF a>c THEN RETURN a; END; (* IF *)
         ELSE 
            IF b>c THEN RETURN b; END; (* IF *)
         END; (* IF *)
         RETURN c; 
        END MaxSize3;

        PROCEDURE MinSize2*(a,b:tSize):tSize;
        BEGIN (* MinSize2 *)
         IF a<b THEN RETURN a; ELSE RETURN b; END; (* IF *)
        END MinSize2;

        PROCEDURE MinSize3*(a,b,c:tSize):tSize;
        BEGIN (* MinSize3 *)
         IF a<b THEN 
            IF a<c THEN RETURN a; END; (* IF *)
         ELSE 
            IF b<c THEN RETURN b; END; (* IF *)
         END; (* IF *)
         RETURN c; 
        END MinSize3;

        PROCEDURE MinSize4*(a,b,c,d:tSize):tSize;
        BEGIN (* MinSize4 *)
         RETURN MinSize2(MinSize2(a,b),MinSize2(c,d)); 
        END MinSize4; 






















































































































PROCEDURE yyAbort (yyFunction: ARRAY OF CHAR);
 BEGIN
  IO.WriteS (IO.StdError, 'Error: module ADR, routine ');
  IO.WriteS (IO.StdError, yyFunction);
  IO.WriteS (IO.StdError, ' failed');
  IO.WriteNl (IO.StdError);
  Exit;
 END yyAbort;

PROCEDURE yyIsEqual (VAR yya, yyb: ARRAY OF SYSTEM.BYTE): BOOLEAN;
 VAR yyi:LONGINT; 
 BEGIN
  FOR yyi := 0 TO (LEN(yya)) DO
   IF SYSTEM.VAL(CHAR,yya [yyi]) # SYSTEM.VAL(CHAR,yyb [yyi]) THEN RETURN FALSE; END;
  END;
  RETURN TRUE;
 END yyIsEqual;

PROCEDURE ArrayOfsFromODim* (odim: LONGINT): tAddress;
 BEGIN
(* line 169 "ADR.pum" *)
(* line 169 "ADR.pum" *)
       CASE odim OF
                    |0:  ;
                    |1:  odim:=4; 
                    ELSE odim:=4*odim+4; 
                    END; ;
      RETURN odim;

 END ArrayOfsFromODim;

PROCEDURE ArrayOfs* (type: OB.tOB): tAddress;
 BEGIN
(* line 178 "ADR.pum" *)
      RETURN ArrayOfsFromODim (T.OpenDimOfArrayType(type));

 END ArrayOfs;

PROCEDURE LenOfsFromOpenParamType* (type: OB.tOB): tAddress;
 BEGIN
(* line 183 "ADR.pum" *)
      RETURN 4 + LenOfsFromOpenPointerBaseType (type);

 END LenOfsFromOpenParamType;

PROCEDURE LenOfsFromOpenPointerBaseType* (type: OB.tOB): tAddress;
 BEGIN
  IF (type^.Kind = OB.ArrayTypeRepr) THEN
  IF (type^.ArrayTypeRepr.elemTypeRepr^.Kind = OB.ArrayTypeRepr) THEN
(* line 188 "ADR.pum" *)
   LOOP
(* line 188 "ADR.pum" *)
      IF ~(((type^.ArrayTypeRepr.len = OB . OPENARRAYLEN) & (type^.ArrayTypeRepr.elemTypeRepr^.ArrayTypeRepr.len = OB . OPENARRAYLEN))) THEN EXIT; END;
      RETURN 4;
   END;

  END;
  END;
(* line 191 "ADR.pum" *)
      RETURN 0;

 END LenOfsFromOpenPointerBaseType;

PROCEDURE LenOfsFromTypeOfOpenEntry* (type: OB.tOB): tAddress;
 BEGIN
  IF (type^.Kind = OB.ArrayTypeRepr) THEN
(* line 198 "ADR.pum" *)
   LOOP
(* line 198 "ADR.pum" *)
      IF ~((type^.ArrayTypeRepr.len > OB . OPENARRAYLEN)) THEN EXIT; END;
      RETURN LenOfsFromTypeOfOpenEntry (type^.ArrayTypeRepr.elemTypeRepr);
   END;

  END;
  IF (type^.Kind = OB.PointerTypeRepr) THEN
  IF (type^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
(* line 200 "ADR.pum" *)
      RETURN LenOfsFromOpenPointerBaseType (type^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr);

  END;
  END;
(* line 203 "ADR.pum" *)
      RETURN LenOfsFromOpenPointerBaseType (type);

 END LenOfsFromTypeOfOpenEntry;

PROCEDURE LocalVarBase* (level: tLevel): tAddress;
 BEGIN
(* line 207 "ADR.pum" *)
      RETURN  -4-4*(level-OB.MODULELEVEL) ;

 END LocalVarBase;

PROCEDURE NextVarAddr* (level: tLevel; oldAddr: tAddress; typesize: tSize; VAR varAddr: tAddress; VAR newAddr: tAddress);
(* line 215 "ADR.pum" *)
 VAR a:tAddress; 
 BEGIN
  IF (yyIsEqual ( level ,   OB.MODULELEVEL ) ) THEN
(* line 217 "ADR.pum" *)
(* line 219 "ADR.pum" *)
       a:=pAligned(oldAddr,typesize); ;
      varAddr := a;
      newAddr := a + typesize;
      RETURN;

  END;
  IF (yyIsEqual ( level ,   OB.FIELDLEVEL ) ) THEN
(* line 221 "ADR.pum" *)
      varAddr := oldAddr;
      newAddr := oldAddr + typesize;
      RETURN;

  END;
(* line 225 "ADR.pum" *)
(* line 227 "ADR.pum" *)
       a:=nAligned(oldAddr-typesize,typesize); ;
      varAddr := a;
      newAddr := a;
      RETURN;

 END NextVarAddr;

PROCEDURE NextParAddr* (parMode: tParMode; type: OB.tOB; oldAddr: tAddress; VAR parAddr: tAddress; VAR refMode: tParMode; VAR newAddr: tAddress);
(* line 236 "ADR.pum" *)
 VAR od:LONGINT; a:tAddress; r:tParMode; 
 BEGIN
  IF type = OB.NoOB THEN RETURN; END;
  IF (yyIsEqual ( parMode ,   OB.REFPAR ) ) THEN
  IF (type^.Kind = OB.RecordTypeRepr) THEN
(* line 238 "ADR.pum" *)
      parAddr := oldAddr + 4;
      refMode := OB.REFPAR;
      newAddr := oldAddr + 8;
      RETURN;

  END;
  END;
  IF (type^.Kind = OB.RecordTypeRepr) THEN
(* line 245 "ADR.pum" *)
(* line 250 "ADR.pum" *)
       CASE T.SizeOfType(type) OF
                            |0      : r:=OB.VALPAR; a:=oldAddr; 
                            |1,2,3,4: r:=OB.VALPAR; a:=oldAddr+4; 
                            ELSE      r:=OB.REFPAR; a:=oldAddr+4; 
                            END; ;
      parAddr := oldAddr;
      refMode := r;
      newAddr := a;
      RETURN;

  END;
  IF (type^.Kind = OB.ArrayTypeRepr) THEN
(* line 256 "ADR.pum" *)
   LOOP
(* line 261 "ADR.pum" *)
      IF ~((type^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
(* line 262 "ADR.pum" *)
       od:=T.OpenDimOfArrayType(type); a:=oldAddr+4+4*od;
			    IF od>1 THEN INC(a,4); END; ;
      parAddr := oldAddr;
      refMode := OB.REFPAR;
      newAddr := a;
      RETURN;
   END;

(* line 265 "ADR.pum" *)
(* line 270 "ADR.pum" *)
       IF parMode=OB.REFPAR THEN 
                               r:=OB.REFPAR; a:=oldAddr+4; 
                            ELSE
                               CASE T.SizeOfType(type) OF
                               |0      : r:=OB.VALPAR; a:=oldAddr; 
			       |1,2,3,4: r:=OB.VALPAR; a:=oldAddr+4; 
			       ELSE      r:=OB.REFPAR; a:=oldAddr+4; 
                               END;
                            END; ;
      parAddr := oldAddr;
      refMode := r;
      newAddr := a;
      RETURN;

  END;
  IF (yyIsEqual ( parMode ,   OB.REFPAR ) ) THEN
(* line 280 "ADR.pum" *)
      parAddr := oldAddr;
      refMode := OB.REFPAR;
      newAddr := oldAddr + 4;
      RETURN;

  END;
(* line 286 "ADR.pum" *)
      parAddr := oldAddr;
      refMode := OB.VALPAR;
      newAddr := oldAddr+Align4(T.SizeOfType(type));
      RETURN;

 END NextParAddr;

PROCEDURE TTableElemOfsInTDesc* (staticType: OB.tOB; testType: OB.tOB; VAR yyP1: tAddress): BOOLEAN;
 BEGIN
  IF (staticType^.Kind = OB.RecordTypeRepr) THEN
  IF (testType^.Kind = OB.RecordTypeRepr) THEN
(* line 295 "ADR.pum" *)
      yyP1 := (4 * (testType^.RecordTypeRepr.extLevel - LIM . MaxExtensionLevel - 3));
      RETURN (testType^.RecordTypeRepr.extLevel > staticType^.RecordTypeRepr.extLevel);

  END;
  END;
(* line 298 "ADR.pum" *)
      yyP1 := 0;
      RETURN FALSE;

 END TTableElemOfsInTDesc;

PROCEDURE BeginADR*;
 BEGIN
(* line 164 "ADR.pum" *)
  InitBitRangeTab; 
 END BeginADR;

PROCEDURE CloseADR*;
 BEGIN
 END CloseADR;

PROCEDURE yyExit;
 BEGIN
  IO.CloseIO; System.Exit (1);
 END yyExit;

BEGIN
 yyf	:= IO.StdOutput;
 Exit	:= yyExit;
 BeginADR;
END ADR.

