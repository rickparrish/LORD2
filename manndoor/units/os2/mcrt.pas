unit mCrt;

interface

uses
  OS2Base;

procedure FastWrite(ALine: String; AX, AY, AAttr: Byte);
function GetAttrAt(AX, AY: Byte): Byte;
function GetCharAt(AX, AY: Byte): Char;
procedure SetAttrAt(AAttr, AX, AY: Byte);
procedure SetCharAt(ACh: Char; AX, AY: Byte);

implementation

const
  TVVioHandle = 0;

{
  Write ALine at the screen coordinates AX, AY with text attribute AAttr
}
procedure FastWrite(ALine: String; AX, AY, AAttr: Byte);
begin
     VioWrtCharStrAtt(@ALine[1], Length(ALine), AY - 1, AX - 1, AAttr, TVVioHandle);
end;

{
  Returns the text attribute at screen position AX, AY
}
function GetAttrAt(AX, AY: Byte): Byte;
var
  Cell: SmallWord;
  Size: SmallWord;
begin
     Size := SizeOf(Cell);
     VioReadCellStr(Cell, Size, AY - 1, AX - 1, 0);
     Result := Hi(Cell);
end;

{
  Returns the character at screen position AX, AY
}
function GetCharAt(AX, AY: Byte): Char;
var
  Cell: SmallWord;
  Size: SmallWord;
begin
     Size := SizeOf(Cell);
     if (VioReadCellStr(Cell, Size, AY - 1, AX - 1, 0) = 0) then
        Result := Chr(Lo(Cell))
     else
         Result := #0;
end;

{
  Set the text attribute at screen coordinate AX, AY to AAttr
}
procedure SetAttrAt(AAttr, AX, AY: Byte);
begin
     FastWrite(GetCharAt(AX, AY), AX, AY, AAttr);
end;

{
  Set the character at screen coordinate AX, AY to ACH
}
procedure SetCharAt(ACh: Char; AX, AY: Byte);
begin
     FastWrite(ACh, AX, AY, GetAttrAt(AX, AY));
end;

end.
