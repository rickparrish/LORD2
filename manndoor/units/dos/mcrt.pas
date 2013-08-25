unit mCrt;

interface

uses
  Crt;

procedure FastWrite(ALine: String; AX, AY, AAttr: Byte);
function GetAttrAt(AX, AY: Byte): Byte;
function GetCharAt(AX, AY: Byte): Char;
procedure SetAttrAt(AAttr, AX, AY: Byte);
procedure SetCharAt(ACh: Char; AX, AY: Byte);

implementation

type
  TCell = Record
    Ch: Char;
    Attr: Byte;
  end;

  TScreen = Array[1..25, 1..80] of TCell;

var
  Screen: TScreen absolute $B800:0000;

{
  Write ALine at the screen coordinates AX, AY with text attribute AAttr
}
procedure FastWrite(ALine: String; AX, AY, AAttr: Byte);
var
  Ch: Char;
  I: Integer;
begin
     for I := 1 to Length(ALine) do
     begin
          Ch := ALine[I]; { Hack For FPC }
          Screen[AY, AX + (I - 1)].Ch := Ch;
          Screen[AY, AX + (I - 1)].Attr := AAttr;
     end;
end;

{
  Returns the text attribute at screen position AX, AY
}
function GetAttrAt(AX, AY: Byte): Byte;
begin
     GetAttrAt := Screen[AY, AX].Attr;
end;

{
  Returns the character at screen position AX, AY
}
function GetCharAt(AX, AY: Byte): Char;
begin
     GetCharAt := Screen[AY, AX].Ch;
end;

{
  Set the text attribute at screen coordinate AX, AY to AAttr
}
procedure SetAttrAt(AAttr, AX, AY: Byte);
begin
     Screen[AY, AX].Attr := AAttr;
end;

{
  Set the character at screen coordinate AX, AY to ACh
}
procedure SetCharAt(ACh: Char; AX, AY: Byte);
begin
     Screen[AY, AX].Ch := ACh;
end;

end.
