unit VideoUtils;

{$mode objfpc}{$H+}

interface

{$IFDEF UNIX}
  uses
    Crt;
{$ENDIF}
{$IFDEF WINDOWS}
  uses
    Windows;
{$ENDIF}

procedure FastWrite(ALine: String; AX, AY, AAttr: Byte);
function GetAttrAt(AX, AY: Byte): Byte;
function GetCharAt(AX, AY: Byte): Char;
procedure SetAttrAt(AAttr, AX, AY: Byte);
procedure SetCharAt(ACh: Char; AX, AY: Byte);

implementation

{$IFDEF GO32V2}
  type
    TCell = Record
      Ch: Char;
      Attr: Byte;
    end;

    TScreen = Array[1..25, 1..80] of TCell;

  var
    Screen: TScreen absolute $B800:0000;
{$ENDIF}
{$IFDEF WINDOWS}
  var
    StdOut: THandle;
{$ENDIF}

{
  Write ALine at the screen coordinates AX, AY with text attribute AAttr
}
procedure FastWrite(ALine: String; AX, AY, AAttr: Byte);
var
  {$IFDEF GO32V2}
    I: Integer;
  {$ENDIF}
  {$IFDEF UNIX}
    FullWin: Boolean;
    SavedAttr: Integer;
    SavedWindMinX: Integer;
    SavedWindMinY: Integer;
    SavedWindMaxX: Integer;
    SavedWindMaxY: Integer;
    SavedXY: Integer;
  {$ENDIF}
  {$IFDEF WINDOWS}
    Buffer: Array[0..255] of TCharInfo;
    BufferCoord: TCoord;
    BufferSize: TCoord;
    I: Integer;
    WriteRegion: TSmallRect;
  {$ENDIF}
begin
  {$IFDEF GO32V2}
    for I := 1 to Length(ALine) do
    begin
      Screen[AY, AX + (I - 1)].Ch := ALine[I];
      Screen[AY, AX + (I - 1)].Attr := AAttr;
    end;
  {$ENDIF}
  {$IFDEF UNIX}
    // Save
    FullWin := (WindMinX=1) AND (WindMinY=1) AND (WindMaxX=ScreenWidth) AND (WindMaxY=ScreenHeight);
    SavedAttr := TextAttr;
    SavedWindMinX := WindMinX;
    SavedWindMinY := WindMinY;
    SavedWindMaxX := WindMaxX;
    SavedWindMaxY := WindMaxY;
    SavedXY := WhereX + (WhereY SHL 8);

    // Update
    if Not(FullWin) then Window(1, 1, 80, 25); // TODO Assumes 80x25
    GotoXY(AX, AY);
    TextAttr := AAttr;

    // Output
    if (AY = 25) then
    begin
      // Only write up to the 79th column if on line 25
      if (Length(ALine) > (79 - AX + 1)) then
      begin
        ALine := Copy(ALine, 1, 79 - AX + 1);
      end;
    end else
    begin
      // Only write up to the 80th column if on any other line than 25
      if (Length(ALine) > (80 - AX + 1)) then
      begin
        ALine := Copy(ALine, 1, 80 - AX + 1);
      end;
    end;
    Write(ALine);

    // Restore
    TextAttr := SavedAttr;
    if Not(FullWin) then Window(SavedWindMinX, SavedWindMinY, SavedWindMaxX, SavedWindMaxY);
    GotoXY(SavedXY AND $00FF, (SavedXY AND $FF00) SHR 8);
  {$ENDIF}
  {$IFDEF WINDOWS}
    for I := 0 to Length(ALine) - 1 do
    begin
      Buffer[I].Attributes := AAttr;
      Buffer[I].AsciiChar := ALine[I + 1];
    end;
    BufferSize.X := Length(ALine);
    BufferSize.Y := 1;
    BufferCoord.X := 0;
    BufferCoord.Y := 0;
    WriteRegion.Left := AX - 1;
    WriteRegion.Top := AY - 1;
    WriteRegion.Right := AX + Length(ALine) - 2;
    WriteRegion.Bottom := AY - 1;
    WriteConsoleOutput(StdOut, @Buffer, BufferSize, BufferCoord, WriteRegion);
  {$ENDIF}
end;

{
  Returns the text attribute at screen position AX, AY
}
function GetAttrAt(AX, AY: Byte): Byte;
{$IFDEF WINDOWS}
  var
    Attr: Word;
    Coord: TCoord;
    NumRead: Cardinal;
{$ENDIF}
begin
  {$IFDEF GO32V2}
    Result := Screen[AY, AX].Attr;
  {$ENDIF}
  {$IFDEF UNIX}
  Result := ConsoleBuf^[((AY - 1) * ScreenWidth) + (AX - 1)].attr;
  {$ENDIF}
  {$IFDEF WINDOWS}
    Coord.X := AX - 1;
    Coord.Y := AY - 1;
    ReadConsoleOutputAttribute(StdOut, @Attr, 1, Coord, NumRead);
    Result := Attr;
  {$ENDIF}
end;

{
  Returns the character at screen position AX, AY
}
function GetCharAt(AX, AY: Byte): Char;
{$IFDEF WINDOWS}
  var
    Ch: Char;
    Coord: TCoord;
    NumRead: Cardinal;
{$ENDIF}
begin
  {$IFDEF GO32V2}
    Result := Screen[AY, AX].Ch;
  {$ENDIF}
  {$IFDEF UNIX}
    Result := ConsoleBuf^[((AY - 1) * ScreenWidth) + (AX - 1)].ch;
  {$ENDIF}
  {$IFDEF WINDOWS}
    Coord.X := AX - 1;
    Coord.Y := AY - 1;
    ReadConsoleOutputCharacter(StdOut, @Ch, 1, Coord, NumRead);
    if (NumRead = 0) then
    begin
      Result := #32
    end else
    begin
      Result := Ch;
    end;
  {$ENDIF}
end;

{
  Set the text attribute at screen coordinate AX, AY to AAttr
}
procedure SetAttrAt(AAttr, AX, AY: Byte);
{$IFDEF UNIX}
  var
    FullWin: Boolean;
    SavedAttr: Integer;
    SavedWindMinX: Integer;
    SavedWindMinY: Integer;
    SavedWindMaxX: Integer;
    SavedWindMaxY: Integer;
    SavedXY: Integer;
{$ENDIF}
{$IFDEF WINDOWS}
  var
    WriteCoord: TCoord;
    NumWritten: Cardinal;
{$ENDIF}
begin
  {$IFDEF GO32V2}
    Screen[AY, AX].Attr := AAttr;
  {$ENDIF}
  {$IFDEF UNIX}
    // Save
    FullWin := (WindMinX=1) AND (WindMinY=1) AND (WindMaxX=ScreenWidth) AND (WindMaxY=ScreenHeight);
    SavedAttr := TextAttr;
    SavedWindMinX := WindMinX;
    SavedWindMinY := WindMinY;
    SavedWindMaxX := WindMaxX;
    SavedWindMaxY := WindMaxY;
    SavedXY := WhereX + (WhereY SHL 8);

    // Update
    if Not(FullWin) then Window(1, 1, 80, 25); // TODO Assumes 80x25
    GotoXY(AX, AY);
    TextAttr := AAttr;

    // Output
    Write(GetCharAt(AX, AY));

    // Restore
    TextAttr := SavedAttr;
    if Not(FullWin) then Window(SavedWindMinX, SavedWindMinY, SavedWindMaxX, SavedWindMaxY);
    GotoXY(SavedXY AND $00FF, (SavedXY AND $FF00) SHR 8);
  {$ENDIF}
  {$IFDEF WINDOWS}
    WriteCoord.X := AX - 1;
    WriteCoord.Y := AY - 1;
    WriteConsoleOutputAttribute(StdOut, @AAttr, 1, WriteCoord, NumWritten);
  {$ENDIF}
end;

{
  Set the character at screen coordinate AX, AY to ACH
}
procedure SetCharAt(ACh: Char; AX, AY: Byte);
{$IFDEF UNIX}
  var
    FullWin: Boolean;
    SavedAttr: Integer;
    SavedWindMinX: Integer;
    SavedWindMinY: Integer;
    SavedWindMaxX: Integer;
    SavedWindMaxY: Integer;
    SavedXY: Integer;
{$ENDIF}
{$IFDEF WINDOWS}
  var
    WriteCoord: TCoord;
    NumWritten: Cardinal;
{$ENDIF}
begin
  {$IFDEF GO32V2}
    Screen[AY, AX].Ch := ACh;
  {$ENDIF}
  {$IFDEF UNIX}
    // Save
    FullWin := (WindMinX=1) AND (WindMinY=1) AND (WindMaxX=ScreenWidth) AND (WindMaxY=ScreenHeight);
    SavedAttr := TextAttr;
    SavedWindMinX := WindMinX;
    SavedWindMinY := WindMinY;
    SavedWindMaxX := WindMaxX;
    SavedWindMaxY := WindMaxY;
    SavedXY := WhereX + (WhereY SHL 8);

    // Update
    if Not(FullWin) then Window(1, 1, 80, 25); // TODO Assumes 80x25
    GotoXY(AX, AY);
    TextAttr := GetAttrAt(AX, AY);

    // Output
    Write(ACh);

    // Restore
    TextAttr := SavedAttr;
    if Not(FullWin) then Window(SavedWindMinX, SavedWindMinY, SavedWindMaxX, SavedWindMaxY);
    GotoXY(SavedXY AND $00FF, (SavedXY AND $FF00) SHR 8);
  {$ENDIF}
  {$IFDEF WINDOWS}
    WriteCoord.X := AX - 1;
    WriteCoord.Y := AY - 1;
    WriteConsoleOutputCharacter(StdOut, @ACh, 1, WriteCoord, NumWritten);
  {$ENDIF}
end;

{
  Initialization stuff
}
begin
  {$IFDEF WINDOWS}
    StdOut := GetStdHandle(STD_OUTPUT_HANDLE);
  {$ENDIF}
end.

