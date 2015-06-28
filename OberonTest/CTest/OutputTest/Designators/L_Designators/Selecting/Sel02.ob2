MODULE Sel02;
(*% Nested Record Variables *)

TYPE tRec1 = RECORD
              s1:SET;
              r1:RECORD
                  s2:SET;
                  r2:RECORD
                      s3:SET;
                      r3:RECORD
                          s4:SET;
                          r4:RECORD
                              s5:SET;
                              r5:RECORD
                                  s6:SET;
                                  r6:RECORD
                                      s7:SET
                                     END;
                                 END;
                             END;
                         END;
                     END;
                 END;
             END;

VAR r:tRec1;

BEGIN (* Sel02 *)
 r.s1:={};
 r.r1.s2:={};
 r.r1.r2.s3:={};
 r.r1.r2.r3.s4:={};
 r.r1.r2.r3.r4.s5:={};
 r.r1.r2.r3.r4.r5.s6:={};
 r.r1.r2.r3.r4.r5.r6.s7:={};
END Sel02.
