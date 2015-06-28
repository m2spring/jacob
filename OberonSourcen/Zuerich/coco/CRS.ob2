(*  scanner module generated by Coco-R *)
MODULE CRS;

IMPORT Texts, SYSTEM;

CONST
        EOL = 0DX;
        EOF = 0X;
        maxLexLen = 127;
  noSym = 38;

TYPE
        ErrorProc* = PROCEDURE (n: INTEGER; pos: LONGINT);
        StartTable = ARRAY 128 OF INTEGER;

VAR
        src*: Texts.Text;  (*source text. To be set by the main pgm*)
        pos*: LONGINT;  (*position of current symbol*)
        line*, col*, len*: INTEGER;  (*line, column, length of current symbol*)
        nextPos*: LONGINT;  (*position of lookahead symbol*)
        nextLine*, nextCol*, nextLen*: INTEGER;  (*line, column, length of lookahead symbol*)
        errors*: INTEGER;  (*number of errors detected*)
        Error*: ErrorProc;

        ch: CHAR;        (*current input character*)
        r: Texts.Reader;        (*global reader*)
        chPos: LONGINT; (*position of current character*)
        chLine: INTEGER;  (*current line number*)
        lineStart: LONGINT;  (*start position of current line*)
        apx: INTEGER;     (*length of appendix*)
        oldEols: INTEGER;     (*nr. of EOLs in a comment*)

        start: StartTable;  (*start state for every character*)


PROCEDURE NextCh; (*return global variable ch*)
BEGIN
        Texts.Read(r, ch); INC(chPos);
        IF ch = EOL THEN INC(chLine); lineStart := chPos + 1 END
END NextCh;


PROCEDURE Comment(): BOOLEAN;
        VAR level, startLine: INTEGER; oldLineStart: LONGINT;
BEGIN (*Comment*)
        level := 1; startLine := chLine; oldLineStart := lineStart;
  IF (ch ="(") THEN
    NextCh;
    IF (ch ="*") THEN
      NextCh;
      LOOP
        IF (ch ="*") THEN
          NextCh;
          IF (ch =")") THEN
            DEC(level); oldEols := chLine - startLine; NextCh;
            IF level=0 THEN RETURN TRUE END
          END;
        ELSIF (ch ="(") THEN
          NextCh;
          IF (ch ="*") THEN
            INC(level); NextCh;
          END;
        ELSIF ch = EOF THEN RETURN FALSE
        ELSE NextCh END;
      END;
    ELSE
      IF ch = EOL THEN DEC(chLine); lineStart := oldLineStart END;
      DEC(chPos, 2); Texts.OpenReader(r, src, chPos+1); NextCh; RETURN FALSE
    END
  END;
END Comment;


PROCEDURE Get*(VAR sym: INTEGER);
VAR state: INTEGER; lexeme: ARRAY maxLexLen+1 OF CHAR;

        PROCEDURE CheckLiteral;
        BEGIN
                IF nextLen < maxLexLen THEN lexeme[nextLen] := 0X END;
    IF (lexeme[0] >= "A") & (lexeme[0] <= "W") THEN
      CASE lexeme[0] OF
      | "A": IF lexeme = "ANY" THEN sym := 25
        END
      | "C": IF lexeme = "CASE" THEN sym := 19
        ELSIF lexeme = "CHARACTERS" THEN sym := 11
        ELSIF lexeme = "CHR" THEN sym := 22
        ELSIF lexeme = "COMMENTS" THEN sym := 14
        ELSIF lexeme = "COMPILER" THEN sym := 4
        ELSIF lexeme = "CONTEXT" THEN sym := 33
        END
      | "E": IF lexeme = "END" THEN sym := 10
        END
      | "F": IF lexeme = "FROM" THEN sym := 15
        END
      | "I": IF lexeme = "IGNORE" THEN sym := 18
        ELSIF lexeme = "IMPORT" THEN sym := 5
        END
      | "N": IF lexeme = "NESTED" THEN sym := 17
        END
      | "P": IF lexeme = "PRAGMAS" THEN sym := 13
        ELSIF lexeme = "PRODUCTIONS" THEN sym := 7
        END
      | "S": IF lexeme = "SYNC" THEN sym := 32
        END
      | "T": IF lexeme = "TO" THEN sym := 16
        ELSIF lexeme = "TOKENS" THEN sym := 12
        END
      | "W": IF lexeme = "WEAK" THEN sym := 27
        END
      ELSE
      END
    END;

        END CheckLiteral;

BEGIN
  WHILE (ch=20X) OR (ch=CHR(9)) OR (ch=CHR(13)) OR (ch=CHR(28)) DO NextCh END;
    IF ((ch ="(")) & Comment() THEN Get(sym); RETURN END;
        IF ch > 7FX THEN ch := " " END;
        pos := nextPos; col := nextCol; line := nextLine; len := nextLen;
        nextPos := chPos; nextCol := SHORT(chPos - lineStart); nextLine := chLine; nextLen := 0;
        state := start[ORD(ch)]; apx := 0;
        LOOP
                IF nextLen < maxLexLen THEN lexeme[nextLen] := ch END;
                INC(nextLen);
                NextCh;
                IF state > 0 THEN
                        CASE state OF
    |  1: IF (ch>="0") & (ch<="9") OR (ch>="A") & (ch<="Z") OR (ch>="a") & (ch<="z") THEN
          ELSE sym := 1; CheckLiteral; RETURN
          END;
    |  2: IF (ch<=CHR(12)) OR (ch>=CHR(14)) & (ch<="!") OR (ch>="#") THEN
          ELSIF (ch =CHR(34)) THEN state := 3;
          ELSE sym := noSym; RETURN
          END;
    |  3: sym := 2; RETURN
    |  4: IF (ch<=CHR(12)) OR (ch>=CHR(14)) & (ch<="&") OR (ch>="(") THEN
          ELSIF (ch ="'") THEN state := 3;
          ELSE sym := noSym; RETURN
          END;
    |  5: IF (ch>="0") & (ch<="9") THEN
          ELSE sym := 3; RETURN
          END;
    |  6: IF (ch>="0") & (ch<="9") THEN
          ELSE sym := 39; RETURN
          END;
    |  7: sym := 6; RETURN
    |  8: sym := 8; RETURN
    |  9: IF (ch =")") THEN state := 22;
          ELSE sym := 9; RETURN
          END;
    | 10: sym := 20; RETURN
    | 11: sym := 21; RETURN
    | 12: IF (ch =".") THEN state := 21;
          ELSE sym := 23; RETURN
          END;
    | 13: sym := 24; RETURN
    | 14: sym := 26; RETURN
    | 15: sym := 28; RETURN
    | 16: sym := 29; RETURN
    | 17: sym := 30; RETURN
    | 18: sym := 31; RETURN
    | 19: sym := 34; RETURN
    | 20: sym := 35; RETURN
    | 21: sym := 36; RETURN
    | 22: sym := 37; RETURN
    | 23: sym := 0; ch := 0X; RETURN

                        END (*CASE*)
                ELSE sym := noSym; RETURN (*NextCh already done*)
                END (*IF*)
        END (*LOOP*)
END Get;


PROCEDURE GetName*(pos: LONGINT; len: INTEGER; VAR s: ARRAY OF CHAR);
        VAR i: INTEGER; r: Texts.Reader;
BEGIN
        Texts.OpenReader(r, src, pos);
        IF len >= LEN(s) THEN len := SHORT(LEN(s)) - 1 END;
        i := 0; WHILE i < len DO Texts.Read(r, s[i]); INC(i) END;
        s[i] := 0X
END GetName;

PROCEDURE StdErrorProc* (n: INTEGER; pos: LONGINT);
BEGIN INC(errors) END StdErrorProc;

PROCEDURE Reset* (t: Texts.Text; pos: LONGINT; errProc: ErrorProc);
BEGIN
        src := t; Error := errProc;
        Texts.OpenReader(r, src, pos);
        chPos := pos - 1; chLine := 1; lineStart := 0;
        oldEols := 0; apx := 0; errors := 0;
        NextCh
END Reset;

BEGIN
  start[0]:=23; start[1]:=0; start[2]:=0; start[3]:=0;
  start[4]:=0; start[5]:=0; start[6]:=0; start[7]:=0;
  start[8]:=0; start[9]:=0; start[10]:=0; start[11]:=0;
  start[12]:=0; start[13]:=0; start[14]:=0; start[15]:=0;
  start[16]:=0; start[17]:=0; start[18]:=0; start[19]:=0;
  start[20]:=0; start[21]:=0; start[22]:=0; start[23]:=0;
  start[24]:=0; start[25]:=0; start[26]:=0; start[27]:=0;
  start[28]:=0; start[29]:=0; start[30]:=0; start[31]:=0;
  start[32]:=0; start[33]:=0; start[34]:=2; start[35]:=0;
  start[36]:=6; start[37]:=0; start[38]:=0; start[39]:=4;
  start[40]:=12; start[41]:=13; start[42]:=0; start[43]:=10;
  start[44]:=0; start[45]:=11; start[46]:=9; start[47]:=0;
  start[48]:=5; start[49]:=5; start[50]:=5; start[51]:=5;
  start[52]:=5; start[53]:=5; start[54]:=5; start[55]:=5;
  start[56]:=5; start[57]:=5; start[58]:=0; start[59]:=7;
  start[60]:=19; start[61]:=8; start[62]:=20; start[63]:=0;
  start[64]:=0; start[65]:=1; start[66]:=1; start[67]:=1;
  start[68]:=1; start[69]:=1; start[70]:=1; start[71]:=1;
  start[72]:=1; start[73]:=1; start[74]:=1; start[75]:=1;
  start[76]:=1; start[77]:=1; start[78]:=1; start[79]:=1;
  start[80]:=1; start[81]:=1; start[82]:=1; start[83]:=1;
  start[84]:=1; start[85]:=1; start[86]:=1; start[87]:=1;
  start[88]:=1; start[89]:=1; start[90]:=1; start[91]:=15;
  start[92]:=0; start[93]:=16; start[94]:=0; start[95]:=0;
  start[96]:=0; start[97]:=1; start[98]:=1; start[99]:=1;
  start[100]:=1; start[101]:=1; start[102]:=1; start[103]:=1;
  start[104]:=1; start[105]:=1; start[106]:=1; start[107]:=1;
  start[108]:=1; start[109]:=1; start[110]:=1; start[111]:=1;
  start[112]:=1; start[113]:=1; start[114]:=1; start[115]:=1;
  start[116]:=1; start[117]:=1; start[118]:=1; start[119]:=1;
  start[120]:=1; start[121]:=1; start[122]:=1; start[123]:=17;
  start[124]:=14; start[125]:=18; start[126]:=0; start[127]:=0;

END CRS.
