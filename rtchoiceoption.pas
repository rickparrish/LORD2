unit RTChoiceOption;

{$mode objfpc}

interface

uses
  Classes, SysUtils;

type
  TRTChoiceOption = class
  public
    Text: String;
    Visible: Boolean;
    VisibleIndex: Integer;

    constructor Create(AText: String);
    destructor Destroy; override;
  end;

implementation

constructor TRTChoiceOption.Create(AText: String);
begin
  inherited Create;
  Text := AText;
  Visible := true;
  VisibleIndex := 0;
end;

destructor TRTChoiceOption.Destroy;
begin
  inherited Destroy;
end;

end.

