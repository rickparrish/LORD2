unit RTReader;

{$mode objfpc}{$H+}

interface

uses
  MannDoor;

procedure Execute(AFileName: string; ASection: string);

implementation

procedure Execute(AFileName: string; ASection: string);
begin
  mWriteLn('TODO Executing ' + ASection + ' in ' + AFileName);
end;

end.

