MODULE ExtLevel;

TYPE T0  = RECORD      END;
     T1  = RECORD(T0 ) END;
     T2  = RECORD(T1 ) END;
     T3  = RECORD(T2 ) END;
     T4  = RECORD(T3 ) END;
     T5  = RECORD(T4 ) END;
     T6  = RECORD(T5 ) END;
     T7  = RECORD(T6 ) END;
     T8  = RECORD(T7 ) END;
     T9  = RECORD(T8 ) END;
     T10 = RECORD(T9 ) END;
     T11 = RECORD(T10) END;
     T12 = RECORD(T11) END;
     T13 = RECORD(T12) END;

END ExtLevel.
