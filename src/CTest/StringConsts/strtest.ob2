MODULE strtest;

CONST
  cm = "KonstanteVomModul";
  laber*="laberbla";
  
PROCEDURE P1;

  CONST cp1 = "KonstanteVonP1";
  PROCEDURE P2;

    CONST cp2 = "Konstante\Von\P2";
    PROCEDURE P3;

      CONST cp3 = 'KonstanteVon"P3"';
    END P3;
  END P2;
END P1;

BEGIN (* strtest *)
END strtest.
