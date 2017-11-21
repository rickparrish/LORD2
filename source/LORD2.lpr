program LORD2;

{$mode objfpc}{$h+}

uses
  Game,
  Door,
  Crt, SysUtils;

var 
  Maint: Boolean;

begin
  try
    try
      ClrScr;

      Maint := (ParamCount > 0) AND (LowerCase(ParamStr(1)) = '/maint');

      if (Game.Init) then
      begin
        // Check if maintenance was requested
        if (Maint) then
        begin
          // Yep, so run it now
          Game.Maint;
        end else
        begin
          // Nope, so initialize the doorkit
          DoorStartUp;
          DoorSession.SethWrite := true;
          DoorClrScr;

          // And start the game          
          Game.Start;
        end;
      end else
      begin
        // Unable to initialize game (likely data files missing)
        DoorWriteLn('Aborting due to game initialization failure...');
        if NOT(Maint) then
        begin
          DoorWriteLn('Hit a key to quit back to the BBS');
          DoorReadKey;
        end;
      end;
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
    if NOT(Maint) then
    begin
      DoorShutDown;
    end;
  end;
end.

