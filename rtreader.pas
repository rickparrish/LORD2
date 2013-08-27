unit RTReader;

interface

uses
  MannDoor, mCrt, mStrings;

procedure Execute(AFileName: string; ASection: string);

implementation

procedure Execute(AFileName: string; ASection: string);
begin
  FastWrite(PadRight('TODO Executing ' + ASection + ' in ' + AFileName, ' ', 80), 1, 25, 31);
  mReadKey;
  FastWrite(PadRight('', ' ', 80), 1, 25, 7);
end;

end.

