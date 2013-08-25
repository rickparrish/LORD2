unit Dos;

interface

uses
  SysUtils;

procedure GetTime(var AHours, AMins, ASecs, AHund: Word);

implementation

procedure GetTime(var AHours, AMins, ASecs, AHund: Word);
begin
     DecodeTime(Now, AHours, AMins, ASecs, AHund);
     AHund := AHund div 10;
end;

end.
