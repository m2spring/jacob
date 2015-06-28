DEFINITION MODULE Target;
(*
 * Provides the global frame for an assembler file, assembling and linking.
 *)
 
IMPORT LAB,OT;

PROCEDURE Module(dir,name:ARRAY OF CHAR; globalspace:LONGINT); 
(*
 * Starts a new assembler module with name 'name' in directory 'dir'.
 * Creates the assembler file.
 *)
 
PROCEDURE BeginModule(tempSpace:LONGINT; fTempLabel:LAB.T);
(*
 * Starts the module body by emitting the descriptor and the prologue of the module body.
 *)
 
PROCEDURE EndModule(fTempLabel:LAB.T; fTempSize:LONGINT);
(*
 * Ends the module body by emitting the epilogue of the module body.
 * Emits the table of the memory constants.
 * Closes the assembler file.
 *)

PROCEDURE Assemble():BOOLEAN;
(*
 * Calls the assembler script with the last assembler file created by the procedures above.
 * TRUE --> success.
 *) 

PROCEDURE ClearLinklist;
(*
 * Frees the list of objects to be linked.
 *)
 
PROCEDURE AddToLinklist(dir,name:ARRAY OF CHAR);
(*
 * Adds object file 'name' in directory 'dir' to the list of objects to be linked.
 *)
 
PROCEDURE AddToLibraryList(name:OT.oSTRING); 

PROCEDURE Link(dir,mainname:ARRAY OF CHAR):BOOLEAN; 
(*
 * Produces an executable according to the link list:
 * Creates and assembles the root module.
 * Calls the link script with the link list.
 * Removes all temporary files, if not flagged by ARG.OptionKeepTemporaries.
 *)

END Target.
