unit RTRefLabel;

interface

uses
  contnrs, Classes;

type
  TRTRefLabel = class
  public
    LineNumber: Integer;
    Name: String;

    constructor Create(ALabelName: String; ALineNumber: Integer);
    destructor Destroy; override;
  end;

implementation

constructor TRTRefLabel.Create(ALabelName: String; ALineNumber: Integer);
begin
  inherited Create;
  LineNumber := ALineNumber;
  Name := ALabelName;
end;

destructor TRTRefLabel.Destroy;
begin
  inherited Destroy;
end;

end.

