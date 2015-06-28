MODULE Input;

   CONST
      TimeUnit* = 1000;

   PROCEDURE Available* (): INTEGER;
   BEGIN
    RETURN 0;
   END Available;

   PROCEDURE Mouse* (VAR keys: SET; VAR x, y: INTEGER);
   BEGIN
   END Mouse;

   PROCEDURE Read* (VAR ch: CHAR);
   BEGIN
   END Read;

   PROCEDURE SetMouseLimits* (w, h: INTEGER);
   BEGIN
   END SetMouseLimits;

   PROCEDURE Time* (): LONGINT;
   BEGIN
    RETURN 0;
   END Time;

END Input.
