MODULE Main;
IMPORT M1;

TYPE t=LONGINT; 

PROCEDURE P;
VAR Pv:t;

   PROCEDURE Q;
   VAR Qv:t;

      PROCEDURE R;
      VAR Rv:t;

         PROCEDURE S;
         VAR Sv:t;

            PROCEDURE T;
            VAR Tv:t;
            BEGIN (* T *)
            END T;
            
         BEGIN (* S *)
         END S;

      BEGIN (* R *)
      END R;

   BEGIN (* Q *)
   END Q;
 
BEGIN (* P *)
END P;


BEGIN (* Main *)
END Main.
