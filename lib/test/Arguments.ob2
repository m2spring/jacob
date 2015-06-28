FOREIGN MODULE Arguments;

CONST n       = 500000000;
TYPE  stringP = POINTER TO ARRAY n OF CHAR;
      argvT*  = POINTER TO ARRAY n OF stringP;
      envT*   = POINTER TO ARRAY n OF stringP;

PROCEDURE GetArgs*(VAR argc:LONGINT; VAR argv:argvT); END GetArgs;
PROCEDURE GetEnv*(VAR env:envT); END GetEnv;

END Arguments.
