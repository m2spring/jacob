MODULE Kernel;

   CONST
      MarkBit* = 0;

   TYPE
      Name* = ARRAY 32 OF CHAR;
      Cmd* = RECORD
         name*: Name;
         adr*: LONGINT;
      END;
      FinObject* = POINTER TO FinObjDesc;
      FinObjDesc* = RECORD END;
      Finalizer* = PROCEDURE (obj: FinObject);
      GcNotifier* = PROCEDURE;
      Module* = POINTER TO ModuleDesc;
      ModuleDesc* = RECORD
         next*: Module;
         name*: Name;
         init*: BOOLEAN;
         key*, refcnt*, sb*: LONGINT;
         varEntries*: POINTER TO ARRAY OF LONGINT;
         entries*: POINTER TO ARRAY OF LONGINT;
         cmds*: POINTER TO ARRAY OF Cmd;
         ptrTab*: POINTER TO ARRAY OF LONGINT;
         tdescs*: POINTER TO ARRAY OF LONGINT;
         imports*: POINTER TO ARRAY OF LONGINT;
         data*, code*: POINTER TO ARRAY OF CHAR;
         refs*: POINTER TO ARRAY OF CHAR;
      END;
      Tag* = POINTER TO TypeDesc;
      TypeDesc* = RECORD END;
      TerminationHandler* = PROCEDURE;

   VAR
      EventLoop*: PROCEDURE;
      GCenabled*: BOOLEAN;
      TrapHandlingLevel*: LONGINT;
      getadr-: PROCEDURE (adr, symbol, handle: LONGINT);
      heapAdr-: LONGINT;
      heapSize-: LONGINT;
      modules*: Module;
      stackBottom*: LONGINT;

   PROCEDURE Available* (): LONGINT;
   BEGIN
    RETURN 0;
   END Available;

   PROCEDURE Exit* (err: LONGINT);
   BEGIN
   END Exit;

   PROCEDURE FreeLibrary* (this: LONGINT);
   BEGIN
   END FreeLibrary;

   PROCEDURE GC*;
   BEGIN
   END GC;

   PROCEDURE GetAdr* (lib: LONGINT; symbol: ARRAY OF CHAR; VAR adr: LONGINT);
   BEGIN
   END GetAdr;

   PROCEDURE GetClock* (VAR time, date: LONGINT);
   BEGIN
   END GetClock;

   PROCEDURE InstallTermHandler* (h: TerminationHandler);
   BEGIN
   END InstallTermHandler;

   PROCEDURE LargestAvailable* (): LONGINT;
   BEGIN
    RETURN 0;
   END LargestAvailable;

   PROCEDURE LoadLibrary* (file: ARRAY OF CHAR): LONGINT;
   BEGIN
    RETURN 0;
   END LoadLibrary;

   PROCEDURE NewArr* (nofdim, nofelem: LONGINT; eltag: Tag; VAR p: LONGINT);
   BEGIN
   END NewArr;

   PROCEDURE NewRec* (tag: Tag; VAR p: LONGINT);
   BEGIN
   END NewRec;

   PROCEDURE NewSys* (size: LONGINT; VAR p: LONGINT);
   BEGIN
   END NewSys;

   PROCEDURE OpenFinalizable* (obj: FinObject; fin: Finalizer);
   BEGIN
   END OpenFinalizable;

   PROCEDURE SetClock* (time, date: LONGINT);
   BEGIN
   END SetClock;

END Kernel.
