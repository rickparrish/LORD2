unit VideoUtils;

{$mode objfpc}{$H+}

interface

uses
  Crt {$IFDEF WINDOWS}, Windows{$ENDIF};

type
  {$IFNDEF WINDOWS}
    TCharInfo = Record
      Ch: Char;
      Attr: Byte;
    end;
  {$ENDIF}
  TScreenBuffer = Array[1..25, 1..80] of TCharInfo;

procedure FastWrite(ALine: String; AX, AY, AAttr: Byte);
function GetAttrAt(AX, AY: Byte): Byte;
function GetCharAt(AX, AY: Byte): Char;
procedure SetAttrAt(AAttr, AX, AY: Byte);
procedure SetCharAt(ACh: Char; AX, AY: Byte);

implementation

{$IFDEF GO32V2}
  var
    Screen: TScreenBuffer absolute $B800:0000;
{$ENDIF}
{$IFDEF WINDOWS}
  var
    StdOut: THandle;
{$ENDIF}

{
  Write ALine at the screen coordinates AX, AY with text attribute AAttr
}
{$IFDEF GO32V2}
procedure FastWrite(ALine: String; AX, AY, AAttr: Byte);
var
  I: Integer;
begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then Exit;

  { Trim to fit within 80 columns }
  if (Length(ALine) > (80 - AX + 1)) then ALine := Copy(ALine, 1, 80 - AX + 1);

  for I := 1 to Length(ALine) do
  begin
    Screen[AY, AX + (I - 1)].Ch := ALine[I];
    Screen[AY, AX + (I - 1)].Attr := AAttr;
  end;
end;
{$ENDIF}
{$IFDEF UNIX}
procedure FastWrite(ALine: String; AX, AY, AAttr: Byte);
var
  NeedWindow: Boolean;
  SavedAttr: Integer;
  SavedWindMinX: Integer;
  SavedWindMinY: Integer;
  SavedWindMaxX: Integer;
  SavedWindMaxY: Integer;
  SavedXY: Integer;
begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then Exit;

  { Trim to fit within 80 columns }
  if (Length(ALine) > (80 - AX + 1)) then ALine := Copy(ALine, 1, 80 - AX + 1);

  // Save
  NeedWindow := ((WindMinX > 1) OR (WindMinY > 1) OR (WindMaxX < 80) OR (WindmaxY < 25));
  SavedAttr := TextAttr;
  SavedWindMinX := WindMinX;
  SavedWindMinY := WindMinY;
  SavedWindMaxX := WindMaxX;
  SavedWindMaxY := WindMaxY;
  SavedXY := WhereX + (WhereY SHL 8);

  // Update
  if (NeedWindow) then Window(1, 1, 80, 25);
  GotoXY(AX, AY);
  TextAttr := AAttr;

  // Trim to fit within 79 columns if on line 25
  if ((AY = 25) AND (Length(ALine) > (79 - AX + 1))) then ALine := Copy(ALine, 1, 79 - AX + 1);

  // Output
  Write(ALine);

  // Restore
  TextAttr := SavedAttr;
  if (NeedWindow) then Window(SavedWindMinX, SavedWindMinY, SavedWindMaxX, SavedWindMaxY);
  GotoXY(SavedXY AND $00FF, (SavedXY AND $FF00) SHR 8);
end;
{$ENDIF}
{$IFDEF WINDOWS}
procedure FastWrite(ALine: String; AX, AY, AAttr: Byte);
var
  Buffer: Array[0..255] of TCharInfo;
  BufferCoord: TCoord;
  BufferSize: TCoord;
  I: Integer;
  WriteRegion: TSmallRect;
begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then Exit;

  { Trim to fit within 80 columns }
  if (Length(ALine) > (80 - AX + 1)) then ALine := Copy(ALine, 1, 80 - AX + 1);

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
end;
{$ENDIF}

{
  Returns the text attribute at screen position AX, AY
}
{$IFDEF GO32V2}
function GetAttrAt(AX, AY: Byte): Byte;
begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then
  begin
    GetAttrAt := 7;
    Exit;
  end;

  GetAttrAt := Screen[AY, AX].Attr;
end;
{$ENDIF}
{$IFDEF UNIX}
function GetAttrAt(AX, AY: Byte): Byte;
begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then
  begin
    GetAttrAt := 7;
    Exit;
  end;

  Result := ConsoleBuf^[((AY - 1) * ScreenWidth) + (AX - 1)].attr;
end;
{$ENDIF}
{$IFDEF WINDOWS}
function GetAttrAt(AX, AY: Byte): Byte;
var
  Attr: Word;
  Coord: TCoord;
  NumRead: Cardinal;
begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then
  begin
    GetAttrAt := 7;
    Exit;
  end;

  Coord.X := AX - 1;
  Coord.Y := AY - 1;
  ReadConsoleOutputAttribute(StdOut, @Attr, 1, Coord, NumRead);
  Result := Attr;
end;
{$ENDIF}

{
  Returns the character at screen position AX, AY
}
{$IFDEF GO32V2}
function GetCharAt(AX, AY: Byte): Char;
begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then
  begin
    GetCharAt := ' ';
    Exit;
  end;

  GetCharAt := Screen[AY, AX].Ch;
end;
{$ENDIF}
{$IFDEF UNIX}
function GetCharAt(AX, AY: Byte): Char;
begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then
  begin
    Result := ' ';
    Exit;
  end;

  Result := ConsoleBuf^[((AY - 1) * ScreenWidth) + (AX - 1)].ch;
end;
{$ENDIF}
{$IFDEF WINDOWS}
function GetCharAt(AX, AY: Byte): Char;
var
  Ch: Char;
  Coord: TCoord;
  NumRead: Cardinal;
begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then
  begin
    Result := ' ';
    Exit;
  end;

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
end;
{$ENDIF}

{
  Set the text attribute at screen coordinate AX, AY to AAttr
}
{$IFDEF GO32V2}
procedure SetAttrAt(AAttr, AX, AY: Byte);
begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then Exit;

  Screen[AY, AX].Attr := AAttr;
end;
{$ENDIF}
{$IFDEF UNIX}
procedure SetAttrAt(AAttr, AX, AY: Byte);
var
  NeedWindow: Boolean;
  SavedAttr: Integer;
  SavedWindMinX: Integer;
  SavedWindMinY: Integer;
  SavedWindMaxX: Integer;
  SavedWindMaxY: Integer;
  SavedXY: Integer;
begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then Exit;

  // Save
  NeedWindow := ((WindMinX > 1) OR (WindMinY > 1) OR (WindMaxX < 80) OR (WindmaxY < 25));
  SavedAttr := TextAttr;
  SavedWindMinX := WindMinX;
  SavedWindMinY := WindMinY;
  SavedWindMaxX := WindMaxX;
  SavedWindMaxY := WindMaxY;
  SavedXY := WhereX + (WhereY SHL 8);

  // Update
  if (NeedWindow) then Window(1, 1, 80, 25);
  GotoXY(AX, AY);
  TextAttr := AAttr;

  // Output
  Write(GetCharAt(AX, AY));

  // Restore
  TextAttr := SavedAttr;
  if (NeedWindow) then Window(SavedWindMinX, SavedWindMinY, SavedWindMaxX, SavedWindMaxY);
  GotoXY(SavedXY AND $00FF, (SavedXY AND $FF00) SHR 8);
end;
{$ENDIF}
{$IFDEF WINDOWS}
procedure SetAttrAt(AAttr, AX, AY: Byte);
var
  WriteCoord: TCoord;
  NumWritten: Cardinal;
begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then Exit;

  WriteCoord.X := AX - 1;
  WriteCoord.Y := AY - 1;
  WriteConsoleOutputAttribute(StdOut, @AAttr, 1, WriteCoord, NumWritten);
end;
{$ENDIF}

{
  Set the character at screen coordinate AX, AY to ACH
}
{$IFDEF GO32V2}
procedure SetCharAt(ACh: Char; AX, AY: Byte);
begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then Exit;

  Screen[AY, AX].Ch := ACh;
end;
{$ENDIF}
{$IFDEF UNIX}
procedure SetCharAt(ACh: Char; AX, AY: Byte);
var
  NeedWindow: Boolean;
  SavedAttr: Integer;
  SavedWindMinX: Integer;
  SavedWindMinY: Integer;
  SavedWindMaxX: Integer;
  SavedWindMaxY: Integer;
  SavedXY: Integer;
begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then Exit;

  // Save
  NeedWindow := ((WindMinX > 1) OR (WindMinY > 1) OR (WindMaxX < 80) OR (WindmaxY < 25));
  SavedAttr := TextAttr;
  SavedWindMinX := WindMinX;
  SavedWindMinY := WindMinY;
  SavedWindMaxX := WindMaxX;
  SavedWindMaxY := WindMaxY;
  SavedXY := WhereX + (WhereY SHL 8);

  // Update
  if (NeedWindow) then Window(1, 1, 80, 25);
  GotoXY(AX, AY);
  TextAttr := GetAttrAt(AX, AY);

  // Output
  Write(ACh);

  // Restore
  TextAttr := SavedAttr;
  if (NeedWindow) then Window(SavedWindMinX, SavedWindMinY, SavedWindMaxX, SavedWindMaxY);
  GotoXY(SavedXY AND $00FF, (SavedXY AND $FF00) SHR 8);
end;
{$ENDIF}
{$IFDEF WINDOWS}
procedure SetCharAt(ACh: Char; AX, AY: Byte);
var
  WriteCoord: TCoord;
  NumWritten: Cardinal;
begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then Exit;

  WriteCoord.X := AX - 1;
  WriteCoord.Y := AY - 1;
  WriteConsoleOutputCharacter(StdOut, @ACh, 1, WriteCoord, NumWritten);
end;
{$ENDIF}

{
  Initialization stuff
}
begin
  {$IFDEF WINDOWS}
    StdOut := GetStdHandle(STD_OUTPUT_HANDLE);
  {$ENDIF}
end.

