program LORD2;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp,
  { you can add units after this }
  MannDoor;

type

  { TLORD2 }

  TLORD2 = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

{ TLORD2 }

procedure TLORD2.DoRun;
var
  ErrorMsg: String;
begin
  { add your program here }
  mStartUp;

  // stop program loop
  Terminate;
end;

constructor TLORD2.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TLORD2.Destroy;
begin
  inherited Destroy;
end;

var
  Application: TLORD2;
begin
  Application:=TLORD2.Create(nil);
  Application.Title:='Legend of the Red Dragon II';
  Application.Run;
  Application.Free;
end.

