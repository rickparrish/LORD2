program LORD2;

{$mode objfpc}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp,
  { you can add units after this }
  Game, RTChoiceOption, RTGlobal, RTReader, RTRefLabel, RTRefFile, RTRefSection, StringUtils, Struct,
  Ansi, Comm, Door, DropFiles;

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
begin
  { add your program here }
  try
    try
      DoorStartUp;
      DoorSession.SethWrite := true;
      DoorClrScr;

      // Start the game
      Game.Start;

      // stop program loop
      if (DoorLocal) then
      begin
        //TODO FastWrite(PadRight('Hit a key to quit', ' ', 80), 1, 25, 31);
        DoorReadKey;
      end;
    except on E: Exception do
    begin
      if (DoorLocal) then
      begin
        WriteLn('Exception: ' + E.ToString);
        ReadLn;
      end;
    end;
    end;
  finally
    DoorShutDown;
  end;

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

