unit Comm;

{$mode objfpc}

interface

uses
  Classes, SysUtils;

function CommCharAvail: Boolean;
function CommReadChar: Char;
procedure CommWrite(AText: String);

implementation

function CommCharAvail: Boolean;
begin
  // TODO
  Result := false;
end;

function CommReadChar: Char;
begin
  // TODO
  Result := #0;
end;

procedure CommWrite(AText: String);
begin
  // TODO
end;

end.

