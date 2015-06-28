MODULE Configuration;
IMPORT Oberon, Texts, TextFrames, System, Viewers, MenuViewers;


CONST	StandardMenu = "System.Close System.Copy System.Grow Edit.Search Edit.Store";

PROCEDURE OpenCompiler;
CONST CompilerTool = "Compiler.Tool";
VAR tool : Viewers.Viewer; X, Y : INTEGER; toolText : Texts.Text;
BEGIN
	Oberon.AllocateSystemViewer(0, X, Y);
	toolText := TextFrames.Text(CompilerTool);
	tool := MenuViewers.New(TextFrames.NewMenu(CompilerTool, StandardMenu),
		TextFrames.NewText(toolText, 0), TextFrames.menuH, X, Y);
END OpenCompiler;

PROCEDURE OpenReadme;
CONST Filename = "Readme.Text";
VAR tool : Viewers.Viewer; X, Y : INTEGER; toolText : Texts.Text;
BEGIN
	Oberon.AllocateUserViewer(0, X, Y);
	toolText := TextFrames.Text(Filename);
	tool := MenuViewers.New(TextFrames.NewMenu(Filename, StandardMenu),
		TextFrames.NewText(toolText, 0), TextFrames.menuH, X, Y);
END OpenReadme;

BEGIN OpenCompiler; OpenReadme;
END Configuration.
