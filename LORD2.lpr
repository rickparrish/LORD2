program LORD2;

{$mode objfpc}{$h+}

uses
  Game, RTChoiceOption, RTGlobal, RTReader, RTRefLabel, RTRefFile, RTRefSection, StringUtils, Struct,
  Ansi, Comm, Door, DropFiles,
  SysUtils;

begin
  { add your program here }
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
        // TODO Log to file instead of screen
        if (DoorLocal) then
        begin
          WriteLn;
          WriteLn('Exception: ' + E.ToString);
          Write('Hit a key to quit');
          ReadLn;
        end;
      end;
    end;
  finally
    DoorShutDown;
  end;
end.

