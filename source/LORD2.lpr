program LORD2;

{$mode objfpc}{$h+}

uses
  Game,
  Door,
  SysUtils;

begin
  try
    try
      DoorStartUp;
      DoorSession.SethWrite := true;
      DoorClrScr;

      // TODO RUN MAINT IN MAINT.REF IF /MAINT IS PASSED

      // Start the game
      Game.Start;
    except
      on E: Exception do
      begin
        // TODO Log to file as well as to screen that an abnormal exit occurred
        // TODO Log to file instead of screen
        DoorWriteLn;
        DoorWriteLn('`4`b**`% ERROR : `2' + E.Message + ' `4`b**`2');
        DoorWrite('Hit a key to quit');
        DoorReadKey;
      end;
    end;
  finally
    DoorShutDown;
  end;
end.

