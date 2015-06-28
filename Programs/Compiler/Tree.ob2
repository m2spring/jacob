MODULE Tree;

IMPORT Idents;

TYPE 

tNode*        = POINTER TO tNodeDesc;
tModule*      = POINTER TO tModuleDesc;
tImports*     = POINTER TO tImportsDesc;
tDecls*       = POINTER TO tDeclsDesc;
tStmts*       = POINTER TO tStmtsDesc;
              
tNodeDesc*    = RECORD END;
              
tModuleDesc*  = RECORD(tNodeDesc)
 name*        : Idents.T;
 isForeign*   : BOOLEAN; 
 imports*     : tImports;
 decls*       : tDecls;
 stmts*       : tStmts;
END;             
              
tImportsDesc* = RECORD(tNodeDesc)
 next*        : tImports;
 serverId*    ,
 refId*       : Idents.T;
END;          

tDeclsDesc*   = RECORD(tNodeDesc)
END;

tStmtsDesc*   = RECORD(tNodeDesc)
END;

(*----------------------------------------------------------------------------------------------------------------------*)
PROCEDURE mModule*(name      : Idents.T; 
                   isForeign : BOOLEAN; 
                   imports   : tImports; 
                   decls     : tDecls;
                   stmts     : tStmts):tModule;
VAR p:tModule;
BEGIN (* mModule *)
 NEW(p);          
 p.name      := name; 
 p.isForeign := isForeign; 
 p.imports   := imports; 
 p.decls     := decls; 
 p.stmts     := stmts; 
 RETURN p; 
END mModule;             

(*----------------------------------------------------------------------------------------------------------------------*)
PROCEDURE mImports*(next     : tImports;
                    serverId ,
                    refId    : Idents.T):tImports;
VAR p:tImports;
BEGIN (* mImports *)
 NEW(p); 
 p.next     := next;  
 p.serverId := serverId; 
 p.refId    := refId; 
 RETURN p; 
END mImports;

(*----------------------------------------------------------------------------------------------------------------------*)
END Tree.
