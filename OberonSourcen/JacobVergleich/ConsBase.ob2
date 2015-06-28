MODULE ConsBase;

TYPE BegRegister* = SHORTINT;
CONST RegNil* = 0;
      Regal*  = 1;
      Regah*  = 2;
      Regbl*  = 3;
      Regbh*  = 4;
      Regcl*  = 5;
      Regch*  = 6;
      Regdl*  = 7;
      Regdh*  = 8;
      Regax*  = 9;
      Regbx*  = 10;
      Regcx*  = 11;
      Regdx*  = 12;
      Regsi*  = 13;
      Regdi*  = 14;
      Regeax* = 15;
      Regebx* = 16;
      Regecx* = 17;
      Regedx* = 18;
      Regesi* = 19;
      Regedi* = 20;
      Regebp* = 21;
      Regesp* = 22;
      Regst*  = 23;
      Regst1* = 24;
      Regst2* = 25;
      Regst3* = 26;
      Regst4* = 27;
      Regst5* = 28;
      Regst6* = 29;
      Regst7* = 30;
      MAX_BegRegister* = Regst7;

TYPE tSize* = SHORTINT;
CONST NoSize* = 0;
      b*      = 1;
      w*      = 2;
      l*      = 3;
      s*      = 4;
      MAX_tSize* = s;

TYPE tRelation* = SHORTINT;
CONST NoRelation*     = 0;
      equal*          = 1;
      unequal*        = 2;
      less*           = 3;
      lessORequal*    = 4;
      greater*        = 5;
      greaterORequal* = 6;
      MAX_tRelation*  = greaterORequal;
      
END ConsBase.
