unit RTRefSection;

{$mode objfpc}{$h+}

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
    destructor Destroy; override;
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

  Labels.Clear;
  Labels.Free;
  Script.Free;
end;

end.

