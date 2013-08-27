unit RTReader;

interface

uses
  MannDoor, mCrt, mStrings, SysUtils, Classes, contnrs, RTRefFile, RTRefSection,
  RTRefLabel;

type
  TRTReader = class
  private
    procedure Execute(AFileName: String; ASectionName: String; ALineNumber: Integer);
  public
    constructor Create;
    destructor Destroy;
  end;

procedure Execute(AFileName: string; ASectionName: string);

implementation

procedure Execute(AFileName: string; ASectionName: string);
label
  HandleGOTO;
var
  LineNumber: Integer;
  RTR: TRTReader;
begin
  LineNumber := 0;

  HandleGOTO:

  AFileName := UpperCase(Trim(ChangeFileExt(AFileName, '')));
  ASectionName := UpperCase(Trim(ASectionName));

  RTR := TRTReader.Create();
  RTR.Execute(AFileName, ASectionName, LineNumber);
  // TODO If returned with a GOTO, goto HandleGOTO
end;

constructor TRTReader.Create;
begin
  inherited Create;
end;

destructor TRTReader.Destroy;
begin
  inherited Destroy;
end;

procedure TRTReader.Execute(AFileName: String; ASectionName: String; ALineNumber: Integer);
begin
  FastWrite(PadRight('TODO Executing ' + ASectionName + ' in ' + AFileName + ' (line number ' + IntToStr(ALineNumber) + ')', ' ', 80), 1, 25, 31);
  mReadKey;
  FastWrite(PadRight('', ' ', 80), 1, 25, 7);
end;

end.

