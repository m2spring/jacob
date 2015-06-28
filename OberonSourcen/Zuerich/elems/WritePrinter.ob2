MODULE WritePrinter;
IMPORT Texts;

CONST Unit*=1;

TYPE PrintMsg* = RECORD(Texts.ElemMsg)
                  X0*,Y0*,pos*:INTEGER; 
                  prepare*:BOOLEAN; 
                 END;
BEGIN (* WritePrinter *)
END WritePrinter.
