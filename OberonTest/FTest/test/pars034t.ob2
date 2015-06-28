(* IF-Statement *)

MODULE pars034t;

BEGIN

IF A
THEN B
END;

IF A
THEN B
ELSE C
END;

IF A
THEN B
ELSIF C
THEN D
END;

IF A
THEN B
ELSIF C
THEN D
ELSE E
END;

IF A
THEN B
ELSIF C
THEN D
ELSIF E
THEN F
ELSE G
END;

IF A
THEN IF B THEN C END
END;

IF A
THEN IF B THEN C ELSIF D THEN E ELSE F END
ELSE G
END;

IF A
THEN B
ELSIF C
THEN IF D THEN E ELSE F END
END;

IF A    THEN IF B    THEN C
             ELSIF D THEN E
             ELSIF F THEN G
             END
ELSIF H THEN IF I    THEN J
             END
        ELSE IF K    THEN IF L    THEN M
                          ELSIF N THEN O
                          ELSIF P THEN Q
                                  ELSE R
                          END


             ELSIF S THEN T
                     ELSE U
             END
END;

IF A    THEN B
ELSIF C THEN IF D THEN E
                  ELSE F
             END
ELSIF G THEN IF H THEN IF I THEN IF J THEN IF G THEN H
                                                ELSE I
                                           END
                                 END
                       END
             END
        ELSE G
END;

END pars034t.
