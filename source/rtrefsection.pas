unit RTRefSection;

{$mode objfpc}{$h+}

interface

uses
  RTRefLabel,
  Classes, fgl;

type
  TRTRefSection = class
  public
    Labels: TRTRefLabelMap;
    Name: String;
    Script: TStringList;

    constructor Create(ASectionName: String);
    destructor Destroy; override;
  end;

  TRTRefSectionMap = specialize TFPGMap<string, TRTRefSection>;

implementation

constructor TRTRefSection.Create(ASectionName: String);
begin
  inherited Create;
  Labels := TRTRefLabelMap.Create;
  Name := ASectionName;
  Script := TStringList.Create;
end;

destructor TRTRefSection.Destroy;
begin
  inherited Destroy;

  Labels.Clear;
  Labels.Free;
  Script.Free;
end;

end.

