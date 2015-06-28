MODULE LIM;

CONST 

   MaxProcedureNesting*             = 30;
   MaxCaseLabelRange*               = 4096;
   FirstNestingDepthToUseEnter*     = 4;

   MaxExtensionLevel*               = 8;
   OffsetOfProcTab*                 = -16-4*MaxExtensionLevel;

   BlocklistLoopUnrollingThreshold* = 2;
   WalkerLoopUnrollingThreshold*    = 5;
   MaxNofBytesToUseRegdMemCopy*     = 16;
   MaxLenToUseInlinedStrCmp*        = 4;
   
END LIM.

