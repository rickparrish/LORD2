unit RTRefLabel;

{$mode objfpc}{$h+}

interface

uses
  Classes, fgl;

type
  TRTRefLabel = class
  public
    LineNumber: Integer;
    Name: String;

    constructor Create(ALabelName: String; ALineNumber: Integer);
    destructor Destroy; override;
  end;

  TRTRefLabelMap = specialize TFPGMap<string, TRTRefLabel>;

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

