MODULE iOPO;

   CONST
      ADC* = 16;
      ADD* = 0;
      AH* = 20;
      AL* = 16;
      AND* = 32;
      AX* = 8;
      Abs* = 16;
      BH* = 23;
      BL* = 19;
      BP* = 13;
      BX* = 11;
      Bit16* = 8;
      Bit32* = 0;
      Bit64* = 8;
      Bit8* = 16;
      CBW* = 152;
      CH* = 21;
      CL* = 17;
      CLD* = 252;
      CMP* = 56;
      CMPS* = 83;
      CWD* = 153;
      CX* = 9;
      Coc* = 18;
      CodeLength* = 65000;
      ConstLength* = 8192;
      DH* = 22;
      DI* = 15;
      DL* = 18;
      DX* = 10;
      Disp32* = 2;
      Disp8* = 1;
      EAX* = 0;
      EBP* = 5;
      EBX* = 3;
      ECX* = 1;
      EDI* = 7;
      EDX* = 2;
      ESI* = 6;
      ESP* = 4;
      FABS* = 4;
      FCHS* = 5;
      FCOMPP* = 0;
      FDECSTP* = 8;
      FINCSTP* = 7;
      FLD1* = 3;
      FLDZ* = 2;
      FSTSW* = 6;
      FTST* = 1;
      INS* = 54;
      ImmMem* = 4;
      ImmReg* = 3;
      Imme* = 3;
      JA* = 7;
      JAE* = 3;
      JB* = 2;
      JBE* = 6;
      JC* = 2;
      JE* = 4;
      JG* = 15;
      JGE* = 13;
      JL* = 12;
      JLE* = 14;
      JNA* = 6;
      JNAE* = 2;
      JNB* = 3;
      JNBE* = 7;
      JNC* = 3;
      JNE* = 5;
      JNG* = 14;
      JNGE* = 12;
      JNL* = 13;
      JNLE* = 15;
      JNO* = 1;
      JNP* = 11;
      JNS* = 9;
      JNZ* = 5;
      JO* = 0;
      JP* = 10;
      JPE* = 10;
      JPO* = 11;
      JS* = 8;
      JZ* = 4;
      LODS* = 86;
      MOVS* = 82;
      Mem* = 2;
      MemReg* = 2;
      MemSt* = 8;
      OUTS* = 55;
      Or* = 8;
      RCL* = 2;
      RCR* = 3;
      ROL* = 0;
      ROR* = 1;
      Reg* = 15;
      RegMem* = 1;
      RegReg* = 0;
      RegRel* = 17;
      RegSt* = 5;
      Regs* = 0;
      SAHF* = 158;
      SAL* = 4;
      SAR* = 7;
      SBB* = 24;
      SCAS* = 87;
      SHL* = 4;
      SHR* = 5;
      SI* = 14;
      SP* = 12;
      STOS* = 85;
      SUB* = 40;
      Scale1* = 0;
      Scale2* = 1;
      Scale4* = 2;
      Scale8* = 3;
      StReg* = 6;
      StRegP* = 7;
      WAIT* = 155;
      XOR* = 48;
      eReal* = 4;
      lReal* = 2;
      noBase* = -1;
      noDisp* = 0;
      noImm* = 0;
      noInx* = -1;
      noScale* = 0;
      sInt* = 1;
      sReal* = 0;

   VAR
      CodeErr*: BOOLEAN;
      code*: ARRAY 65000 OF CHAR;
      constant*: ARRAY 8192 OF CHAR;
      csize*: LONGINT;
      dsize*: LONGINT;
      lastImmSize*: SHORTINT;
      pc*: LONGINT;

   PROCEDURE GenBT* (mode: SHORTINT; reg, base, inx: INTEGER; scale: SHORTINT; disp, imm: LONGINT);
   BEGIN
   END GenBT;

   PROCEDURE GenBTR* (mode: SHORTINT; reg, base, inx: INTEGER; scale: SHORTINT; disp, imm: LONGINT);
   BEGIN
   END GenBTR;

   PROCEDURE GenBTS* (mode: SHORTINT; reg, base, inx: INTEGER; scale: SHORTINT; disp, imm: LONGINT);
   BEGIN
   END GenBTS;

   PROCEDURE GenCALL* (mode: SHORTINT; reg, base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenCALL;

   PROCEDURE GenDEC* (mode: SHORTINT; reg, base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenDEC;

   PROCEDURE GenFADD* (mode, size: SHORTINT; base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenFADD;

   PROCEDURE GenFCOM* (mode, size: SHORTINT; base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenFCOM;

   PROCEDURE GenFCOMP* (mode, size: SHORTINT; base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenFCOMP;

   PROCEDURE GenFDIV* (mode, size: SHORTINT; base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenFDIV;

   PROCEDURE GenFDIVR* (mode, size: SHORTINT; base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenFDIVR;

   PROCEDURE GenFFREE* (freg: INTEGER);
   BEGIN
   END GenFFREE;

   PROCEDURE GenFLD* (mode, size: SHORTINT; base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenFLD;

   PROCEDURE GenFLDCW* (base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenFLDCW;

   PROCEDURE GenFMUL* (mode, size: SHORTINT; base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenFMUL;

   PROCEDURE GenFST* (mode, size: SHORTINT; base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenFST;

   PROCEDURE GenFSTCW* (base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenFSTCW;

   PROCEDURE GenFSTP* (mode, size: SHORTINT; base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenFSTP;

   PROCEDURE GenFSUB* (mode, size: SHORTINT; base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenFSUB;

   PROCEDURE GenFSUBR* (mode, size: SHORTINT; base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenFSUBR;

   PROCEDURE GenFop1* (op: INTEGER);
   BEGIN
   END GenFop1;

   PROCEDURE GenFtyp1* (op, mode, size: SHORTINT; base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenFtyp1;

   PROCEDURE GenIDIV* (mode: SHORTINT; reg, base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenIDIV;

   PROCEDURE GenIMUL* (mode: SHORTINT; shortform: BOOLEAN; reg, base, inx: INTEGER; scale: SHORTINT; disp, imm: LONGINT);
   BEGIN
   END GenIMUL;

   PROCEDURE GenINC* (mode: SHORTINT; reg, base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenINC;

   PROCEDURE GenINT* (intNumber: INTEGER);
   BEGIN
   END GenINT;

   PROCEDURE GenJMP* (mode: SHORTINT; reg, base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenJMP;

   PROCEDURE GenJcc* (op: SHORTINT; disp: LONGINT);
   BEGIN
   END GenJcc;

   PROCEDURE GenLEA* (reg, base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenLEA;

   PROCEDURE GenMOV* (mode: SHORTINT; reg, base, inx: INTEGER; scale: SHORTINT; disp, imm: LONGINT);
   BEGIN
   END GenMOV;

   PROCEDURE GenMOVSX* (mode, s: SHORTINT; reg, base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenMOVSX;

   PROCEDURE GenMOVZX* (mode, s: SHORTINT; reg, base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenMOVZX;

   PROCEDURE GenNEG* (mode: SHORTINT; reg, base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenNEG;

   PROCEDURE GenNOT* (mode: SHORTINT; reg, base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenNOT;

   PROCEDURE GenPOP* (mode: SHORTINT; reg, base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenPOP;

   PROCEDURE GenPUSH* (mode: SHORTINT; reg, base, inx: INTEGER; scale: SHORTINT; disp, imm: LONGINT);
   BEGIN
   END GenPUSH;

   PROCEDURE GenRET* (size: LONGINT);
   BEGIN
   END GenRET;

   PROCEDURE GenRepCmpsScas* (op, size: INTEGER);
   BEGIN
   END GenRepCmpsScas;

   PROCEDURE GenRepString* (op, size: INTEGER);
   BEGIN
   END GenRepString;

   PROCEDURE GenSetcc* (op, mode: SHORTINT; base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenSetcc;

   PROCEDURE GenShiftRot* (op, mode: SHORTINT; reg, base, inx: INTEGER; scale: SHORTINT; disp, imm: LONGINT);
   BEGIN
   END GenShiftRot;

   PROCEDURE GenString* (op, size: INTEGER);
   BEGIN
   END GenString;

   PROCEDURE GenTyp1* (op, mode: SHORTINT; reg, base, inx: INTEGER; scale: SHORTINT; disp, imm: LONGINT);
   BEGIN
   END GenTyp1;

   PROCEDURE GenXCHG* (mode: SHORTINT; reg, base, inx: INTEGER; scale: SHORTINT; disp: LONGINT);
   BEGIN
   END GenXCHG;

   PROCEDURE GetConsDWord* (pos: LONGINT; VAR dw: LONGINT);
   BEGIN
   END GetConsDWord;

   PROCEDURE GetDWord* (pos: LONGINT; VAR dw: LONGINT);
   BEGIN
   END GetDWord;

   PROCEDURE InlineCode* (VAR code: ARRAY OF CHAR; parSize: INTEGER);
   BEGIN
   END InlineCode;

   PROCEDURE Prefix* (reg: INTEGER; VAR w: SHORTINT);
   BEGIN
   END Prefix;

   PROCEDURE PutByte* (b: INTEGER);
   BEGIN
   END PutByte;

   PROCEDURE PutByteAt* (pos: LONGINT; byte: INTEGER);
   BEGIN
   END PutByteAt;

   PROCEDURE PutConsDWord* (pos, dw: LONGINT);
   BEGIN
   END PutConsDWord;

   PROCEDURE PutDWord* (dw: LONGINT);
   BEGIN
   END PutDWord;

   PROCEDURE PutDWordAt* (pos, dw: LONGINT);
   BEGIN
   END PutDWordAt;

END iOPO.
