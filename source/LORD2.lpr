program LORD2;

{$mode objfpc}{$h+}

uses
  Game,
  Door, FileUtils,
  Crt, SysUtils;

var 
  CrashLogFile: Text;
  Maint: Boolean;

begin
  try
    try
      ClrScr;
      DoorSession.SethWrite := true;

      // Check if maintenance was requested
      Maint := (ParamCount > 0) AND (LowerCase(ParamStr(1)) = '/maint');
      if (Maint) then
      begin
        // Maintenance was requested
        Game.Init;
        Game.Maint;
      end else
      begin
        // Not asking for maintenance, so start the game
        DoorStartUp;
        DoorClrScr;
        Game.Init;
        Game.Start;
      end;
    except
      on E: Exception do
      begin
        if (OpenFileForAppend(CrashLogFile, Game.GetSafeAbsolutePath('CrashLog.txt'), 100)) then
        begin
          WriteLn(CrashLogFile, DateTimeToStr(Now));
          DumpExceptionCallStack(CrashLogFile, E);
          WriteLn(CrashLogFile, '');
          Close(CrashLogFile);
        end;
        
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

