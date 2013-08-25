unit mCrt;

interface

uses
  Crt, Windows;

procedure FastWrite(ALine: String; AX, AY, AAttr: Byte);
function GetAttrAt(AX, AY: Byte): Byte;
function GetCharAt(AX, AY: Byte): Char;
procedure SetAttrAt(AAttr, AX, AY: Byte);
procedure SetCharAt(ACh: Char; AX, AY: Byte);

implementation

var
  OutHandle: THandle;

{
  Write ALine at the screen coordinates AX, AY with text attribute AAttr
}
procedure FastWrite(ALine: String; AX, AY, AAttr: Byte);
var
  I: Integer;
  Buffer: Array[0..255] of TCharInfo;
  BufferCoord: TCoord;
  BufferSize: TCoord;
  WriteRegion: TSmallRect;
begin
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
     WriteConsoleOutput(OutHandle, @Buffer, BufferSize, BufferCoord, WriteRegion);
end;

{
  Returns the text attribute at screen position AX, AY
}
function GetAttrAt(AX, AY: Byte): Byte;
var
  Attr: Word;
  Coord: TCoord;
  NumRead: Cardinal;
begin
     Coord.X := AX - 1;
     Coord.Y := AY - 1;
     ReadConsoleOutputAttribute(OutHandle, @Attr, 1, Coord, NumRead);
     GetAttrAt := Attr;
end;

{
  Returns the character at screen position AX, AY
}
function GetCharAt(AX, AY: Byte): Char;
var
  Ch: Char;
  Coord: TCoord;
  NumRead: Cardinal;
begin
     Coord.X := AX - 1;
     Coord.Y := AY - 1;
     ReadConsoleOutputCharacter(OutHandle, @Ch, 1, Coord, NumRead);
     if (NumRead = 0) then
        GetCharAt := #32
     else
         GetCharAt := Ch;
end;

{
  Set the text attribute at screen coordinate AX, AY to AAttr
}
procedure SetAttrAt(AAttr, AX, AY: Byte);
var
  WriteCoord: TCoord;
  NumWritten: Cardinal;
begin
     WriteCoord.X := AX - 1;
     WriteCoord.Y := AY - 1;
     WriteConsoleOutputAttribute(OutHandle, @AAttr, 1, WriteCoord, NumWritten);
end;

{
  Set the character at screen coordinate AX, AY to ACH
}
procedure SetCharAt(ACh: Char; AX, AY: Byte);
var
  WriteCoord: TCoord;
  NumWritten: Cardinal;
begin
     WriteCoord.X := AX - 1;
     WriteCoord.Y := AY - 1;
     WriteConsoleOutputCharacter(OutHandle, @ACh, 1, WriteCoord, NumWritten);
end;

{
  Initialization stuff
}
begin
     OutHandle := GetStdHandle(STD_OUTPUT_HANDLE);
end.
