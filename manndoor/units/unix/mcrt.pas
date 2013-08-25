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

{
  Write ALine at the screen coordinates AX, AY with text attribute AAttr
}
procedure FastWrite(ALine: String; AX, AY, AAttr: Byte);
var
  Attr: Byte;
  XY: Byte;
begin
     XY := WhereX or (WhereY shl 8);
     Attr := TextAttr;

     GotoXY(AX, AY);
     TextAttr := AAttr;
     Write(ALine);

     GotoXY(XY and $00FF, (XY and $FF00) shr 8);
     TextAttr := Attr;
end;

{
  Returns the text attribute at screen position AX, AY
}
function GetAttrAt(AX, AY: Byte): Byte;
begin
     GetAttrAt := 7;
end;

{
  Returns the character at screen position AX, AY
}
function GetCharAt(AX, AY: Byte): Char;
begin
     GetCharAt := #32;
end;

{
  Set the text attribute at screen coordinate AX, AY to AAttr
}
procedure SetAttrAt(AAttr, AX, AY: Byte);
begin
end;

{
  Set the character at screen coordinate AX, AY to ACH
}
procedure SetCharAt(ACh: Char; AX, AY: Byte);
begin
end;

end.
