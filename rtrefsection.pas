unit RTRefSection;

interface

uses
  contnrs, Classes;

type
  TRTRefSection = class
  public
    Labels: TFPHashObjectList;
    Name: String;
    Script: TStringList;

    constructor Create(ASectionName: String);
    destructor Destroy;
  end;

implementation

constructor TRTRefSection.Create(ASectionName: String);
begin
  inherited Create;
  Labels := TFPHashObjectList.Create;
  Name := ASectionName;
  Script := TStringList.Create;
end;

destructor TRTRefSection.Destroy;
begin
  inherited Destroy;
end;

end.

