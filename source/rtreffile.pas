unit RTRefFile;

{$mode objfpc}{$h+}

interface

uses
  RTRefSection,
  fgl;

type
  TRTRefFile = class
  public
    Name: String;
    Sections: TRTRefSectionMap;

    constructor Create(AFileName: String);
    destructor Destroy; override;
  end;

  TRTRefFileMap = specialize TFPGMap<string, TRTRefFile>;

implementation

constructor TRTRefFile.Create(AFileName: String);
begin
  inherited Create;
  Name := AFileName;
  Sections := TRTRefSectionMap.Create;
end;

destructor TRTRefFile.Destroy;
begin
  inherited Destroy;

  Sections.Clear;
  Sections.Free;
end;

end.

