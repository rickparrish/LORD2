unit Comm;

{$mode objfpc}

interface

uses
  Classes, SysUtils;

function CommCarrier: Boolean;
function CommCharAvail: Boolean;
procedure CommOpen(ACommNumber: LongInt);
function CommReadChar: Char;
procedure CommWrite(AText: String);

implementation

function CommCarrier: Boolean;
begin
  // TODO
  Result := false;
end;

function CommCharAvail: Boolean;
begin
  // TODO
  Result := false;
end;

procedure CommOpen(ACommNumber: LongInt);
begin
  // TODO
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

