MODULE WriteFrames;
IMPORT Display, Texts;

CONST mm*=1; Unit*=1;
TYPE Parc* = POINTER TO RECORD
                         lsp*:INTEGER; 
                        END; 

     DisplayMsg* = RECORD(Texts.ElemMsg) 
                    prepare*:BOOLEAN; 
                    X*,Y*,X0*,Y0*,pos*:INTEGER; 
                    elemFrame*:Display.Frame;
                   END;
                   
     TrackMsg* = RECORD(Texts.ElemMsg) 
                  X*,Y*,X0*,Y0*,pos*:INTEGER; 
                  keys*:SET;
                 END;                   

PROCEDURE ParcBefore*(t:Texts.Text; p:LONGINT; pa:Parc; beg:LONGINT);
BEGIN (* ParcBefore *)
END ParcBefore;

PROCEDURE CopyToFocus*(e:Texts.Elem);
BEGIN (* CopyToFocus *)
END CopyToFocus;


END WriteFrames.
