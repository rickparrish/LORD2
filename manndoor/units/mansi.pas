unit mAnsi;

interface

uses
  Crt, SysUtils;

const
  AnsiColours: Array[0..7] of Integer = (0, 4, 2, 6, 1, 5, 3, 7);

function aClrEol: String;
function aClrScr: String;
function aCursorDown(ACount: Byte): String;
function aCursorLeft(ACount: Byte): String;
function aCursorRestore: String;
function aCursorRight(ACount: Byte): String;
function aCursorSave: String;
function aCursorUp(ACount: Byte): String;
procedure aDisplayFile(AFile: String);
function aGotoX(AX: Byte): String;
function aGotoXY(AX, AY: Byte): String;
function aGotoY(AY: Byte): String;
function aTextAttr(AAttr: Byte): String;
function aTextBackground(AColour: Byte): String;
function aTextColor(AColour: Byte): String;
procedure aWrite(ALine: String);
procedure aWriteLn(ALine: String);

implementation

var
  AnsiBracket: Boolean;
  AnsiBuffer: String;
  AnsiCnt: Byte;
  AnsiEscape: Boolean;
  AnsiParams: Array[1..10] of Integer;
  AnsiXY: Word;

procedure AnsiCommand(Cmd: Char);
var
  I: Integer;
  Colour: Integer;
begin
     case Cmd of
          'A': begin { Cursor Up }
                    if (AnsiParams[1] < 1) then
                       AnsiParams[1] := 1;
                    I := WhereY - AnsiParams[1];
                    if (I < 1) then
                       I := 1;
                    GotoXY(WhereX, I);
               end;
          'B': begin { Cursor Down }
                    if (AnsiParams[1] < 1) then
                       AnsiParams[1] := 1;
                    I := WhereY + AnsiParams[1];
                    if (I > Hi(WindMax) - Hi(WindMin)) then
                       I := Hi(WindMax) - Hi(WindMin) + 1;
                    GotoXY(WhereX, I);
               end;
          'C': begin { Cursor Right }
                    if (AnsiParams[1] < 1) then
                       AnsiParams[1] := 1;
                    I := WhereX + AnsiParams[1];
                    if (I > Lo(WindMax) - Lo(WindMin)) then
                       I := Lo(WindMax) - Lo(WindMin) + 1;
                    GotoXY(I, WhereY);
               end;
          'D': begin { Cursor Left }
                    if (AnsiParams[1] < 1) then
                       AnsiParams[1] := 1;
                    I := WhereX - AnsiParams[1];
                    if (I < 1) then
                       I := 1;
                    GotoXY(I, WhereY);
               end;
     'f', 'H': begin { Cursor Placement }
                    if (AnsiParams[1] < 1) then
                       AnsiParams[1] := 1;
                    if (AnsiParams[2] < 1) then
                       AnsiParams[2] := 1;
                    GotoXY(AnsiParams[2], AnsiParams[1]);
               end;
          'J': if (AnsiParams[1] = 2) then { Clear Screen }
                  ClrScr;
          'K': ClrEol; { Clear To End Of Line }
          'm': begin { Change Text Appearance }
                    if (AnsiParams[1] < 1) then
                       AnsiParams[1] := 0;
                    I := 0;
                    while (AnsiParams[I + 1] <> -1) do
                    begin
                         Inc(I);
                         case AnsiParams[I] of
                              0: TextAttr := 7; { Normal Video }
                              1: HighVideo; { High Video }
                              7: TextAttr := ((TextAttr and $70) shr 4) + ((TextAttr and $07) shl 4); { Reverse Video }
                              8: TextAttr := 0; { Video Off }
                         30..37: begin
                                      Colour := AnsiColours[AnsiParams[I] - 30];
                                      if (TextAttr mod 16 > 7) then
                                         Inc(Colour, 8);
                                      TextColor(Colour);
                                 end;
                         40..47: TextBackground(AnsiColours[AnsiParams[I] - 40]);
                         end;
                    end;
               end;
          's': AnsiXY := WhereX + (WhereY shl 8);
          'u': GotoXY(AnsiXY and $00FF, (AnsiXY and $FF00) shr 8);
     end;
end;

function aClrEol: String;
begin
     aClrEol := #27 + '[K';
end;

function aClrScr: String;
begin
     aClrScr := #27 + '[2J' + aGotoXY(1, 1);
end;

function aCursorDown(ACount: Byte): String;
begin
     aCursorDown := #27 + '[' + IntToStr(ACount) + 'B';
end;

function aCursorLeft(ACount: Byte): String;
begin
     aCursorLeft := #27 + '[' + IntToStr(ACount) + 'D';
end;

function aCursorRestore: String;
begin
     aCursorRestore := #27 + '[u';
end;

function aCursorRight(ACount: Byte): String;
begin
     aCursorRight := #27 + '[' + IntToStr(ACount) + 'C';
end;

function aCursorSave: String;
begin
     aCursorSave := #27 + '[s';
end;

function aCursorUp(ACount: Byte): String;
begin
     aCursorUp := #27 + '[' + IntToStr(ACount) + 'A';
end;

procedure aDisplayFile(AFile: String);
var
  F: Text;
  S: String;
begin
     if (FileExists(AFile)) then
     begin
          Assign(F, AFile);
          {$I-}Reset(F);{$I+}
          if (IOResult = 0) then
          begin
               while Not(EOF(F)) do
               begin
                    ReadLn(F, S);
                    if (EOF(F)) then
                       aWrite(S)
                    else
                        aWriteLn(S);
               end;
               Close(F);
          end;
     end;
end;

function aGotoX(AX: Byte): String;
begin
     if (AX = 1) then
        aGotoX := aCursorLeft(255)
     else
         aGotoX := aCursorLeft(255) + aCursorRight(AX - 1);
end;

function aGotoXY(AX, AY: Byte): String;
begin
     aGotoXY := #27 + '[' + IntToStr(AY) + ';' + IntToStr(AX) + 'f';
end;

function aGotoY(AY: Byte): String;
begin
     if (AY = 1) then
        aGotoY := aCursorUp(255)
     else
         aGotoY := aCursorUp(255) + aCursorDown(AY - 1);
end;

function aTextAttr(AAttr: Byte): String;
begin
     aTextAttr := aTextColor(AAttr mod 16) + aTextBackground(AAttr div 16);
end;

function aTextBackground(AColour: Byte): String;
begin
     while (AColour > 7) do
           Dec(AColour, 8);
     aTextBackground := #27 + '[' + IntToStr(40 + AnsiColours[AColour]) + 'm';
end;

function aTextColor(AColour: Byte): String;
begin
     while (AColour > 15) do
           Dec(AColour, 16);
     case AColour of
          0..7: aTextColor := #27 + '[0;' + IntToStr(30 + AnsiColours[AColour]) + 'm' + aTextBackground(TextAttr div 16);
         8..15: aTextColor := #27 + '[1;' + IntToStr(30 + AnsiColours[AColour - 8]) + 'm';
     end;
end;

procedure aWrite(ALine: String);
var
  Buf: String;
  I, J: Integer;
begin
     Buf := '';
     for I := 1 to Length(ALine) do
     begin
          if (ALine[I] = #27) then
          begin
               AnsiBracket := False;
               AnsiEscape := True;
          end else
          if (AnsiEscape) and (ALine[I] = '[') then
          begin
               AnsiBracket := True;
               AnsiBuffer := '';
               AnsiCnt := 1;
               AnsiEscape := False;
               for J := Low(AnsiParams) to High(AnsiParams) do
                   AnsiParams[J] := -1;
          end else
          if (AnsiBracket) then
          begin
               if (ALine[I] in ['?', '=', '<', '>', ' ']) then
                  { ignore these characters }
               else
               if (ALine[I] in ['0'..'9']) then
                  AnsiBuffer := AnsiBuffer + ALine[I]
               else
               if (ALine[I] = ';') then
               begin
                    AnsiParams[AnsiCnt] := StrToIntDef(AnsiBuffer, 0);
                    AnsiBuffer := '';
                    Inc(AnsiCnt);
                    if (AnsiCnt > High(AnsiParams)) then
                       AnsiCnt := High(AnsiParams);
               end else
               begin
                    Write(Buf);
                    Buf := '';
                    
                    AnsiParams[AnsiCnt] := StrToIntDef(AnsiBuffer, 0);
                    AnsiCommand(ALine[I]);
                    AnsiBracket := False;
               end;
          end else
              Buf := Buf + ALine[I];
     end;
     Write(Buf);
end;

procedure aWriteLn(ALine: String);
begin
     aWrite(ALine + #13#10);
end;

begin
     AnsiBracket := False;
     AnsiBuffer := '';
     AnsiCnt := 1;
     AnsiEscape := False;
     AnsiXY := $0101;
end.
