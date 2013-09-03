unit Ansi;

{$mode objfpc}{$h+}

interface

uses
  Classes, Crt, Math, SysUtils;

const
  AnsiColours: Array[0..7] of Integer = (0, 4, 2, 6, 1, 5, 3, 7);

function AnsiBlink(ABlink: Boolean): String;
function AnsiClrScr: String;
function AnsiCursorDown(ACount: Byte): String;
function AnsiCursorLeft(ACount: Byte): String;
function AnsiCursorRestore: String;
function AnsiCursorRight(ACount: Byte): String;
function AnsiCursorSave: String;
function AnsiCursorUp(ACount: Byte): String;
function AnsiGotoX(AX: Byte): String;
function AnsiGotoXY(AX, AY: Byte): String;
function AnsiGotoY(AY: Byte): String;
function AnsiTextBackground(AColour: Byte): String;
function AnsiTextColour(AColour: Byte): String;
function AnsiTextAttr(AAttr: Byte): String;
procedure AnsiWrite(AText: String);
procedure AnsiWriteLn(AText: String);

implementation

type
  TAnsiParserState = (None, HaveEscape, HaveBracket);

var
  AnsiAttr: Byte = 7;
  AnsiBuffer: String = '';
  AnsiParams: Array of Integer;
  AnsiParserState: TAnsiParserState = None;
  AnsiXY: Integer = 1 + (1 SHL 8);

procedure AddAnsiParam(AValue: Integer); forward;
procedure HandleCode(ACode: Char); forward;

procedure AddAnsiParam(AValue: Integer);
begin
  SetLength(AnsiParams, Length(AnsiParams) + 1);
  AnsiParams[High(AnsiParams)] := AValue;
end;

function AnsiBlink(ABlink: Boolean): String;
begin
  if (ABlink) then
  begin
    Result := #27 + '[5m';
  end else
  begin
    Result := #27 + '[0m' + AnsiTextBackground(TextAttr div 16) + AnsiTextColour(TextAttr mod 16);
  end;
end;

function AnsiClrScr: String;
begin
  Result := #27 + '[2J' + AnsiGotoXY(1, 1);
end;

function AnsiCursorDown(ACount: Byte): String;
begin
     Result := #27 + '[' + IntToStr(ACount) + 'B';
end;

function AnsiCursorLeft(ACount: Byte): String;
begin
     Result := #27 + '[' + IntToStr(ACount) + 'D';
end;

function AnsiCursorRestore: String;
begin
     Result := #27 + '[u';
end;

function AnsiCursorRight(ACount: Byte): String;
begin
     Result := #27 + '[' + IntToStr(ACount) + 'C';
end;

function AnsiCursorSave: String;
begin
     Result := #27 + '[s';
end;

function AnsiCursorUp(ACount: Byte): String;
begin
     Result := #27 + '[' + IntToStr(ACount) + 'A';
end;

function AnsiGotoX(AX: Byte): String;
begin
  Result := AnsiCursorLeft(255);
  if (AX > 1) then Result := Result + AnsiCursorRight(AX - 1);
end;

function AnsiGotoXY(AX, AY: Byte): String;
begin
  Result := #27 + '[' + IntToStr(AY) + ';' + IntToStr(AX) + 'f';
end;

function AnsiGotoY(AY: Byte): String;
begin
  Result := AnsiCursorUp(255);
  if (AY > 1) then Result := Result + AnsiCursorDown(AY - 1);
end;

function AnsiTextAttr(AAttr: Byte): String;
begin
  Result := AnsiTextColour(AAttr mod 16) + AnsiTextBackground(AAttr div 16);
end;

function AnsiTextBackground(AColour: Byte): String;
begin
  while (AColour > 7) do AColour -= 8;
  Result := #27 + '[' + IntToStr(40 + AnsiColours[AColour]) + 'm';
end;

function AnsiTextColour(AColour: Byte): String;
begin
  while (AColour > 15) do AColour -= 16;
  case AColour of
     0..7: Result := #27 + '[0;' + IntToStr(30 + AnsiColours[AColour]) + 'm' + AnsiTextBackground(TextAttr div 16);
    8..15: Result := #27 + '[1;' + IntToStr(30 + AnsiColours[AColour - 8]) + 'm';
  end;
end;

procedure AnsiWrite(AText: String);
var
  Buffer: String;
  I: Integer;
begin
  Buffer := '';

  for I := 1 to Length(AText) do
  begin
    case AnsiParserState of
      None:
      begin
        if (AText[I] = #27) then
        begin
          Write(Buffer);
          Buffer := '';

          AnsiParserState := HaveEscape;
        end else
        begin
          Buffer += AText[I];
        end;
      end;

      HaveEscape:
      begin
        if (AText[I] = '[') then
        begin
          AnsiBuffer := '0';
          SetLength(AnsiParams, 1);
          AnsiParserState := HaveBracket;
        end else
        begin
          AnsiParserState := None;
        end;
      end;

      HaveBracket:
      begin
        if (AText[I] in ['?', '=', '<', '>', ' ']) then
        begin
           { ignore these characters }
        end else
        if (AText[I] in ['0'..'9']) then
        begin
          AnsiBuffer += AText[I];
        end else
        if (AText[I] = ';') then
        begin
          AddAnsiParam(StrToIntDef(AnsiBuffer, 0));
          AnsiBuffer := '0';
        end else
        begin
          AddAnsiParam(StrToIntDef(AnsiBuffer, 0));
          AnsiBuffer := '0';

          HandleCode(AText[I]);

          AnsiParserState := None;
        end;
      end;
    end;
  end;

  Write(Buffer);
end;

procedure AnsiWriteLn(AText: String);
begin
  AnsiWrite(AText + #13#10);
end;

procedure HandleCode(ACode: Char);
var
  Colour, I, X, Y: Integer;
begin
  case ACode of
    'A': begin // CSI n A - Moves the cursor n (default 1) cells up. If the cursor is already at the edge of the screen, this has no effect.
           Y := Max(1, AnsiParams[1]);
           Y := Max(1, WhereY - Y);
           GotoXY(WhereX, Y);
         end;
    'B': begin // CSI n B - Moves the cursor n (default 1) cells down. If the cursor is already at the edge of the screen, this has no effect.
           Y := Max(1, AnsiParams[1]);
           Y := Min(Hi(WindMax) - Hi(WindMin) + 1, WhereY + Y);
           GotoXY(WhereX, Y);
         end;
    'C': begin // CSI n C - Moves the cursor n (default 1) cells right. If the cursor is already at the edge of the screen, this has no effect.
           X := Max(1, AnsiParams[1]);
           X := Min(Lo(WindMax) - Lo(WindMin) + 1, WhereX + X);
           GotoXY(X, WhereY);
         end;
    'D': begin // CSI n D - Moves the cursor n (default 1) cells left. If the cursor is already at the edge of the screen, this has no effect.
           X := Max(1, AnsiParams[1]);
           X := Max(1, WhereX - X);
           GotoXY(X, WhereY);
         end;
    'E': begin // CSI n E - Moves cursor to beginning of the line n (default 1) lines down.
           Y := Max(1, AnsiParams[1]);
           Y := Min(Hi(WindMax) - Hi(WindMin) + 1, WhereY + Y);
           GotoXY(1, Y);
         end;
    'F': begin // CSI n F - Moves cursor to beginning of the line n (default 1) lines up.
           Y := Math.Max(1, AnsiParams[1]);
           Y := Math.Max(1, WhereY - Y);
           GotoXY(1, Y);
         end;
    'f',
    'H': begin // CSI y ; x f or CSI ; x f or CSI y ; f - Moves the cursor to row y, column x. The values are 1-based, and default to 1 (top left corner) if omitted. A sequence such as CSI ;5f is a synonym for CSI 1;5f as well as CSI 17;f is the same as CSI 17f and CSI 17;1f
           while (High(AnsiParams) < 2) do AddAnsiParam(0); // Make sure we have enough parameters
           Y := Max(1, AnsiParams[1]);
           X := Max(1, AnsiParams[2]);
           GotoXY(X, Y);
         end;
    'G': begin // CSI n G - Moves the cursor to column n.
           X := Max(1, AnsiParams[1]);
           if ((X >= 1) AND (X <= (Lo(WindMax) - Lo(WindMin) + 1))) then GotoXY(X, WhereY);
         end;
    'h': begin // CSI n h
               // n = 7 enables auto line wrap when writing to last column of screen (which is on by default so we ignore the sequence)
           case AnsiParams[1] of
             7: ; // Ignore
             25: cursoron;
           end;
         end;
    'J': begin // CSI n J - Clears part of the screen. If n is zero (or missing), clear from cursor to end of screen. If n is one, clear from cursor to beginning of the screen. If n is two, clear entire screen (and moves cursor to upper left on MS-DOS ANSI.SYS).
           case AnsiParams[1] of
             0: ; // TODO ClrEos
             1: ; // TODO ClrBos
             2: ClrScr;
           end;
         end;
    'K': begin // CSI n K - Erases part of the line. If n is zero (or missing), clear from cursor to the end of the line. If n is one, clear from cursor to beginning of the line. If n is two, clear entire line. Cursor position does not change.
           case AnsiParams[1] of
             0: ClrEol;
             1: ; // TODO ClrBol
             2: ; // TODO ClrLine
           end;
         end;
    'L': begin // CSI n L - Insert n new lines, pushing the current line and those below it down
           Y := Max(1, AnsiParams[1]);
           for I := 1 to Y do InsLine;
         end;
    'l': begin // CSI n l
               // n = 7 disables auto line wrap when writing to last column of screen (we dont support this)
           case AnsiParams[1] of
             7: ; // Ignore
             25: cursoroff;
           end;
         end;
    'M': begin // CSI n M - Delete n lines, pulling the lines below the deleted lines up
           Y := Max(1, AnsiParams[1]);
           for I := 1 to Y do DelLine;
         end;
    'm': begin { Change Text Appearance }
           for I := 1 to High(AnsiParams) do
           begin
             case AnsiParams[I] of
               0: NormVideo; // Reset / Normal (all attributes off)
               1: HighVideo; // Intensity: Bold
               2: ; // Intensity: Faint (not widely supported)
               3: ; // Italic: on (not widely supported)
               4: ; // Underline: Single
               5: TextAttr := TextAttr OR Blink; // Blink: Slow (< 150 per minute)
               6: TextAttr := TextAttr OR Blink; // Blink: Rapid (>= 150 per minute)
               7: TextAttr := ((TextAttr AND $70) SHR 4) + ((TextAttr AND $07) SHL 4); // Image: Negative (swap foreground and background)
               8: begin // Conceal (not widely supported)
                    AnsiAttr := TextAttr;
                    TextAttr := 0;
                  end;
               21: ; // Underline: Double (not widely supported)
               22: LowVideo; //	Intensity: Normal (not widely supported)
               24: ; // Underline: None
               25: TextAttr := TextAttr AND NOT(Blink); // Blink: off
               27: TextAttr := ((TextAttr AND $70) SHR 4) + ((TextAttr AND $07) SHL 4); // Image: Positive (handle the same as negative
               28: TextAttr := AnsiAttr; // Reveal (conceal off)
               30..37: begin // Set foreground color, normal intensity
                         Colour := AnsiColours[AnsiParams[I] - 30];
                         if (TextAttr mod 16 > 7) then Inc(Colour, 8);
                         TextColor(Colour);
                       end;
               40..47: TextBackground(AnsiColours[AnsiParams[I] - 40]); // Set background color, normal intensity
             end;
           end;
         end;
    'n': begin // CSI X n
               //       n = 5 Device status report (reply with \x1B[0n to report "ready, no malfunction detected")
               //       n = 6 Reports the cursor position to the application as (as though typed at the keyboard) ESC[n;mR, where n is the row and m is the column. (May not work on MS-DOS.)
               //       n = 255 Reports the bottom right cursor position (essentially the screen size)
           case AnsiParams[1] of
             5: ; // TODO Raise ESC[5n event
             6: ; // TODO Raise ESC[6n event
             255: // TODO Raise ESC[255n event
           end;
         end;
    'S': begin // CSI n S - Scroll whole page up by n (default 1) lines. New lines are added at the bottom. (not ANSI.SYS)
           Y := Max(1, AnsiParams[1]);
           //TODO ScrollUpScreen(Y);
         end;
    's': begin // CSI s - Saves the cursor position.
           AnsiXY := WhereX + (WhereY SHL 8);
         end;
    'T': begin // CSI n T - Scroll whole page down by n (default 1) lines. New lines are added at the top. (not ANSI.SYS)
           Y := Max(1, AnsiParams[1]);
           //TODO ScrollDownWindow(Y);
         end;
    'u': begin // CSI u - Restores the cursor position.
           GotoXY(AnsiXY AND $00FF, (AnsiXY AND $FF00) SHR 8);
         end;
  end;
end;

begin
  SetLength(AnsiParams, 1);
  AnsiParams[0] := 0; // Never access [0] directly
end.

