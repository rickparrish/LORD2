unit RTRefFile;

interface

uses
  contnrs;

type
  TRTRefFile = class
  public
    Name: String;
    Sections: TFPHashObjectList;

    constructor Create(AFileName: String);
    destructor Destroy; override;
  end;

implementation

constructor TRTRefFile.Create(AFileName: String);
begin
  inherited Create;
  Name := AFileName;
  Sections := TFPHashObjectList.Create;
end;

destructor TRTRefFile.Destroy;
begin
  inherited Destroy;

  Sections.Clear;
  Sections.Free;
end;

end.

