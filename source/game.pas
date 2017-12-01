unit Game;

{$mode objfpc}{$h+}

interface

uses
  RTGlobal, RTReader, Struct,
  Ansi, Door, FileUtils, StringUtils,
  Classes, Crt, DateUtils, StrUtils, SysUtils;

var
  CurrentMap: MapDatRecord;
  ENEMY: String = '';
  IsNewDay: Boolean = false;
  ItemsDat: ItemsDatCollection;
  LastX: Integer;
  LastY: Integer;
  MorePrompt: String;
  Player: TraderDatRecord;
  PlayerNum: Integer = -1;
  RESPONSE: String = '';
  STime: Integer;
  Time: Integer = 1;
  WorldDat: WorldDatRecord;

  MapDatFileName: String;
  ItemsDatFileName: String;
  STimeDatFileName: String;
  TimeDatFileName: String;
  TraderDatFileName: String;
  UpdateTmpFileName: String;
  WorldDatFileName: String;

procedure DrawMap;
procedure Init;
function LoadDataFiles: Boolean;
procedure LoadMap(AMapNumber: Integer);
function LoadPlayerByGameName(AGameName: String; out ARecord: TraderDatRecord): Integer;
function LoadPlayerByPlayerNumber(APlayerNumber: Integer; out ARecord: TraderDatRecord): Integer;
function LoadPlayerByRealName(ARealName: String; out ARecord: TraderDatRecord): Integer;
procedure Maint;
procedure MoveBack;
procedure SavePlayer;
procedure SaveWorldDat;
procedure Start;
function TotalAccounts: Integer;
procedure Update;
procedure ViewInventory;

implementation

uses
  Helpers;

var
  OldExitProc: Pointer;

function LoadItemsDat: Boolean; forward;
function LoadMapDat: Boolean; forward;
function LoadSTimeDat: Boolean; forward;
function LoadTimeDat: Boolean; forward;
function LoadWorldDat: Boolean; forward;
procedure MovePlayer(AXOffset, AYOffset: Integer); forward;
procedure NewExitProc; forward;

procedure DrawMap;
var
  BG: Integer;
  FG: Integer;
  MI: map_info;
  ToSend: String;
  X, Y: Integer;
begin
  // Draw the map
  BG := 0;
  FG := 7;
  DoorTextAttr(FG);
  DoorClrScr;

  for Y := 1 to 20 do
  begin
    ToSend := '';

    for X := 1 to 80 do
    begin
      MI := CurrentMap.MapInfo[X][Y];

      if (BG <> MI.BackColour) then
      begin
        ToSend := ToSend + AnsiTextBackground(MI.BackColour);
        Crt.TextBackground(MI.BackColour); // Gotta do this to ensure calls to Ansi* work right
        BG := MI.BackColour;
      end;

      if (FG <> MI.ForeColour) then
      begin
        ToSend := ToSend + AnsiTextColour(MI.ForeColour);
        Crt.TextColor(MI.ForeColour); // Gotta do this to ensure calls to Ansi* work right
        FG := MI.ForeColour;
      end;

      ToSend := ToSend + MI.Ch;
    end;

    DoorGotoXY(1, Y);
    DoorWrite(ToSend);
  end;
end;

procedure Init;
begin
  LoadDataFiles;

  Player.RealName := DoorDropInfo.Alias;
  Player.LastDayOn := Game.Time;
  Player.LastDayPlayed := Game.Time;
  Player.LastSaved := Game.Time;

  RTReader.Execute('RULES.REF', 'RULES');
end;

function LoadDataFiles: Boolean;
begin
  ItemsDatFileName := Helpers.GetAbsolutePath('ITEMS.DAT');
  MapDatFileName := Helpers.GetAbsolutePath('MAP.DAT');
  STimeDatFileName := Helpers.GetAbsolutePath('STIME.DAT');
  TimeDatFileName := Helpers.GetAbsolutePath('TIME.DAT');
  TraderDatFileName := Helpers.GetAbsolutePath('TRADER.DAT');
  UpdateTmpFileName := Helpers.GetAbsolutePath('UPDATE.TMP');
  WorldDatFileName := Helpers.GetAbsolutePath('WORLD.DAT');

  Result := true;
  Result := Result AND LoadItemsDat;
  Result := Result AND LoadMapDat;
  Result := Result AND LoadSTimeDat;
  Result := Result AND LoadTimeDat;
  Result := Result AND LoadWorldDat;
end;

function LoadItemsDat: Boolean;
var
  F: File of ItemsDatCollection;
begin
  if (FileExists(ItemsDatFileName)) then
  begin
    if (OpenFileForReadWrite(F, ItemsDatFileName, 2500)) then
    begin
      Read(F, ItemsDat);
      Close(F);
      Result := true;
    end else
    begin
      raise Exception.Create('Unable to open ' + ExtractFileName(ItemsDatFileName) + '.  Sorry.');
      Result := false;
    end;
  end else
  begin
    raise Exception.Create(ExtractFileName(ItemsDatFileName) + ' is missing.  Sorry.');
    Result := false;
  end;
end;

procedure LoadMap(AMapNumber: Integer);
var
  F: File of MapDatRecord;
begin
  if (FileExists(MapDatFileName)) then
  begin
    if (OpenFileForReadWrite(F, MapDatFileName, 2500)) then
    begin
      Seek(F, (Int64(WorldDat.MapDatIndex[AMapNumber]) - 1) * SizeOf(MapDatRecord));
      Read(F, CurrentMap);
      Close(F);
    end else
    begin
      raise Exception.Create('Unable to open ' + ExtractFileName(MapDatFileName) + '.  Sorry.');
    end;
  end else
  begin
    raise Exception.Create(ExtractFileName(MapDatFileName) + ' is missing.  Sorry.');
  end;
end;

function LoadMapDat: Boolean;
begin
  // We used to read the whole 4 meg file into memory, now we'll just check for its existence
  // and only load the pieces of the map that we need at any given time
  if (FileExists(MapDatFileName)) then
  begin
    Result := true;
  end else
  begin
    raise Exception.Create(ExtractFileName(MapDatFileName) + ' is missing.  Sorry.');
    Result := false;
  end;
end;

function LoadPlayerByGameName(AGameName: String; out ARecord: TraderDatRecord): Integer;
var
  F: File of TraderDatRecord;
  I: Integer;
  Rec: TraderDatRecord;
begin
  Result := -1;

  if (FileExists(TraderDatFileName)) then
  begin
    if (OpenFileForReadWrite(F, TraderDatFileName, 2500)) then
    begin
      AGameName := UpperCase(Trim(SethStrip(AGameName)));

      I := 0;
      repeat
        I := I + 1;
        Read(F, Rec);
        if (UpperCase(Trim(SethStrip(Rec.Name))) = AGameName) then
        begin
          ARecord := Rec;
          Result := I;
          break;
        end;
      until EOF(F);
      Close(F);
    end else
    begin
      raise Exception.Create('Unable to open ' + ExtractFileName(TraderDatFileName) + '.  Sorry.');
    end;
  end;
end;

function LoadPlayerByPlayerNumber(APlayerNumber: Integer; out ARecord: TraderDatRecord): Integer;
var
  F: File of TraderDatRecord;
  I: Integer;
  Rec: TraderDatRecord;
begin
  Result := -1;

  if (FileExists(TraderDatFileName)) then
  begin
    if (OpenFileForReadWrite(F, TraderDatFileName, 2500)) then
    begin
      I := 0;
      repeat
        I := I + 1;
        Read(F, Rec);
        if (I = APlayerNumber) then
        begin
          ARecord := Rec;
          Result := I;
          break;
        end;
      until EOF(F);
      Close(F);
    end else
    begin
      raise Exception.Create('Unable to open ' + ExtractFileName(TraderDatFileName) + '.  Sorry.');
    end;
  end;
end;

function LoadPlayerByRealName(ARealName: String; out ARecord: TraderDatRecord): Integer;
var
  F: File of TraderDatRecord;
  I: Integer;
  Rec: TraderDatRecord;
begin
  Result := -1;

  if (FileExists(TraderDatFileName)) then
  begin
    if (OpenFileForReadWrite(F, TraderDatFileName, 2500)) then
    begin
      ARealName := UpperCase(Trim(ARealName));

      I := 0;
      repeat
        I := I + 1;
        Read(F, Rec);
        if (UpperCase(Trim(Rec.RealName)) = ARealName) then
        begin
          ARecord := Rec;
          Result := I;
          break;
        end;
      until EOF(F);
      Close(F);
    end else
    begin
      raise Exception.Create('Unable to open ' + ExtractFileName(TraderDatFileName) + '.  Sorry.');
    end;
  end;
end;

function LoadSTimeDat: Boolean;
var
  F: Text;
  S: String;
  Y, M, D: Word;
begin
  DecodeDate(Date, Y, M, D);
  STime := Y + M + D;
  
  if (FileExists(STimeDatFileName)) then
  begin
    if (OpenFileForRead(F, STimeDatFileName, 2500)) then
    begin
      ReadLn(F, S);
      if (StrToInt(S) <> STime) then
      begin
        IsNewDay := true;
      end;
      Close(F);
    end else
    begin
      raise Exception.Create('Unable to open ' + ExtractFileName(STimeDatFileName) + '.  Sorry.');
      Result := false;
      Exit;
    end;
  end else
  begin
    IsNewDay := true;
  end;

  if (IsNewDay) then
  begin
    if (OpenFileForOverwrite(F, STimeDatFileName, 2500)) then
    begin
      WriteLn(F, STime);
      Close(F);
      Result := true;
    end else
    begin
      raise Exception.Create('Unable to overwrite ' + ExtractFileName(STimeDatFileName) + '.  Sorry.');
      Result := false;
    end;
  end else
  begin
    Result := true;
  end;
end;

function LoadTimeDat: Boolean;
var
  F: Text;
  S: String;
begin
  if (FileExists(TimeDatFileName)) then
  begin
    if (OpenFileForRead(F, TimeDatFileName, 2500)) then
    begin
      ReadLn(F, S);
      Close(F);
      Time := StrToInt(S);
    end else
    begin
      raise Exception.Create('Unable to open ' + ExtractFileName(TimeDatFileName) + '.  Sorry.');
      Result := false;
      Exit;
    end;
  end else
  begin
    Time := 0;
  end;

  if (IsNewDay) then
  begin
    Time := Time + 1;

    if (OpenFileForOverwrite(F, TimeDatFileName, 2500)) then
    begin
      WriteLn(F, IntToStr(Time));
      Close(F);
      Result := true;
    end else
    begin
      raise Exception.Create('Unable to overwrite ' + ExtractFileName(TimeDatFileName) + '.  Sorry.');
      Result := false;
    end;
  end else
  begin
    Result := true;
  end;
end;

function LoadWorldDat: Boolean;
var
  F: File of WorldDatRecord;
begin
  if (FileExists(WorldDatFileName)) then
  begin
    if (OpenFileForReadWrite(F, WorldDatFileName, 2500)) then
    begin
      Read(F, WorldDat);
      Close(F);
      Result := true;
    end else
    begin
      raise Exception.Create('Unable to open ' + ExtractFileName(WorldDatFileName) + '.  Sorry.');
      Result := false;
    end;
  end else
  begin
    raise Exception.Create(ExtractFileName(WorldDatFileName) + ' is missing.  Sorry.');
    Result := false;
  end;
end;

procedure Maint;
begin
  RTReader.Execute('MAINT.REF', 'MAINT');
end;

procedure MoveBack;
begin
  // Erase player
  DoorTextBackground(CurrentMap.MapInfo[Player.x][Player.y].BackColour);
  DoorTextColour(CurrentMap.MapInfo[Player.x][Player.y].ForeColour);
  DoorGotoXY(Player.x, Player.y);
  DoorWrite(CurrentMap.MapInfo[Player.x][Player.y].Ch);

  // Update position and draw player
  Player.X := LastX;
  Player.Y := LastY;
  Update;
end;

procedure MovePlayer(AXOffset, AYOffset: Integer);
var
  i, x, y: Integer;
  Moved, NewMap, Special: Boolean;
begin
  x := Player.x + AXOffset;
  y := Player.y + AYOffset;
  Moved := false;
  NewMap := false;
  Special := false;

  // Check for movement to new screen
  NewMap := (x = 0) OR (x = 81) OR (y = 0) OR (y = 21);
  if (NewMap) then
  begin
    if (x = 0) then
    begin
      Player.Map -= 1;
      Player.X := 80;
    end else
    if (x = 81) then
    begin
      Player.Map += 1;
      Player.X := 1;
    end else
    if (y = 0) then
    begin
      Player.Map -= 80;
      Player.Y := 20;
    end else
    if (y = 21) then
    begin
      Player.Map += 80;
      Player.Y := 1;
    end;

    if (WorldDat.HideOnMap[Player.Map] = 0) then Player.LastMap := Player.Map;
    LoadMap(Player.Map);
    DrawMap;
    Update;
  end else
  begin
    if (CurrentMap.MapInfo[x][y].Terrain = 1) then
    begin
      // Erase player
      DoorTextBackground(CurrentMap.MapInfo[Player.x][Player.y].BackColour);
      DoorTextColour(CurrentMap.MapInfo[Player.x][Player.y].ForeColour);
      DoorGotoXY(Player.x, Player.y);
      DoorWrite(CurrentMap.MapInfo[Player.x][Player.y].Ch);

      // Update position and draw player
      LastX := Player.X;
      LastY := Player.Y;
      Player.X := x;
      Player.Y := y;
      Update;

      Moved := true;
    end;
  end;

  // Check for special
  for I := Low(CurrentMap.HotSpots) to High(CurrentMap.HotSpots) do
  begin
    if (CurrentMap.HotSpots[I].HotSpotX = x) AND (CurrentMap.HotSpots[I].HotSpotY = y) then
    begin
      Special := true;

      if (CurrentMap.HotSpots[I].WarpToMap > 0) AND (CurrentMap.HotSpots[I].WarpToX > 0) AND (CurrentMap.HotSpots[I].WarpToY > 0) then
      begin
        Player.Map := CurrentMap.HotSpots[I].WarpToMap;
        Player.X := CurrentMap.HotSpots[I].WarpToX;
        Player.Y := CurrentMap.HotSpots[I].WarpToY;
        if (WorldDat.HideOnMap[Player.Map] = 0) then Player.LastMap := Player.Map;

        LoadMap(Player.Map);
        DrawMap;
        Update;
      end else
      if (CurrentMap.HotSpots[I].RefFile <> '') AND (CurrentMap.HotSpots[I].RefSection <> '') then
      begin
        RTReader.Execute(CurrentMap.HotSpots[I].RefFile, CurrentMap.HotSpots[I].RefSection);
      end;
    end;
  end;

  // Check if need to run random event
  if (Moved AND NOT(Special) AND (CurrentMap.BattleOdds > 0) AND (CurrentMap.RefFile <> '') AND (CurrentMap.RefSection <> '')) then
  begin
    if (Random(CurrentMap.BattleOdds) = 0) then
    begin
      RTReader.Execute(CurrentMap.RefFile, CurrentMap.RefSection);
    end;
  end;
end;

{
  Custom exit proc to ensure player is saved
}
procedure NewExitProc;
begin
  ExitProc := OldExitProc;
  SavePlayer;
end;

procedure SavePlayer;
var
  F: File of TraderDatRecord;
begin
  if (PlayerNum <> -1) then
  begin
    if (OpenFileForReadWrite(F, TraderDatFileName, 2500)) then
    begin
      Seek(F, (Int64(PlayerNum) - 1) * SizeOf(TraderDatRecord));
      Write(F, Player);
      Close(F);
    end else
    begin
      raise Exception.Create('Unable to open ' + ExtractFileName(TraderDatFileName) + '.  Sorry.');
    end;
  end;
end;

procedure SaveWorldDat;
var
  F: File of WorldDatRecord;
begin
  if (FileExists(WorldDatFileName)) then
  begin
    if (OpenFileForReadWrite(F, WorldDatFileName, 2500)) then
    begin
      Write(F, WorldDat);
      Close(F);
    end else
    begin
      raise Exception.Create('Unable to open ' + ExtractFileName(WorldDatFileName) + '.  Sorry.');
    end;
  end else
  begin
    raise Exception.Create(ExtractFileName(WorldDatFileName) + ' is missing.  Sorry.');
  end;
end;

procedure Start;
var
  Ch: Char;
begin
  // Setup exit proc, which ensures the player is saved properly if a HALT is performed
  OldExitProc := ExitProc;
  ExitProc := @NewExitProc;

  if (IsNewDay) then
  begin
    Maint;
  end;

  PlayerNum := LoadPlayerByRealName(DoorDropInfo.RealName, Player);
  if (PlayerNum = -1) then
  begin
    if (TotalAccounts < 200) then
    begin
      RTReader.Execute('GAMETXT.REF', 'NEWPLAYER');
    end else
    begin
      RTReader.Execute('GAMETXT.REF', 'FULL');
    end;
  end;

  if (PlayerNum <> -1) then
  begin
    RTReader.Execute('GAMETXT.REF', 'STARTGAME');

    LoadMap(Player.Map);
    DrawMap;
    Update;

    repeat
      Ch := UpCase(DoorReadKey);
      if (DoorLastKey.Extended) then
      begin
        case Ch of
          'H': MovePlayer(0, -1);
          'K': MovePlayer(-1, 0);
          'M': MovePlayer(1, 0);
          'P': MovePlayer(0, 1);
        end;
      end else
      begin
        case Ch of
          '8': MovePlayer(0, -1);
          '4': MovePlayer(-1, 0);
          '6': MovePlayer(1, 0);
          '2': MovePlayer(0, 1);
          'B': begin
                 // TODOY Show the log of messages.
                 //       Clears the screen, on third line centers "BACK BUFFER" in dark green on blue text
                 //       Skips one line then says "Ree: text here" in gray text
                 //       Line 24 says "Press a key to return to the game." centered white on blue text
               end;
          'D': begin
                 // Show daily happenings
                 RTReader.Execute('LOGSTUFF', 'READLOG');
                 DrawMap;
                 Update;
               end;
          'F': begin
                 // TODOY Show the last three messages.
                 //       Shows the three lines below the status bar, then changes status bar to "Fast Backbuffer - Press a key to continue."
               end;
          'H': begin
                 // TODOY Interact with another player.  The player pressing this key must be on the same map square as the player they are trying to interact with.
               end;
          'L': RTReader.Execute('HELP', 'LISTPLAYERS');
          'M': RTReader.Execute('HELP', 'MAP');
          'P': RTReader.Execute('HELP', 'WHOISON');
          'Q': begin
                  // Confirm exit
                  DoorGotoXY(1, 23);
                  DoorWrite('`r0`2  Are you sure you want to quit back to the BBS? [`%Y`2] : ');

                  repeat
                    // Repeat until we have a valid selection
                    Ch := UpCase(DoorReadKey);
                  until (Ch in ['Y', 'N', #13]);

                  // Translate selection into either #0 to abort quit, or Q to confirm quit
                  if (Ch = 'N') then
                  begin
                    Ch := #0;
                    GotoXY(1, 23);
                    DoorWrite(PadRight('', 79));
                    DoorGotoXY(Player.X, Player.Y);
                  end else
                  begin
                    Ch := 'Q';
                  end;
                end;
          'R': begin
                 // Redraw the screen
                 DrawMap;
                 Update;
               end;
          'S': begin
                 // TODOY Show names of everybody on the current screen
                 //       Names appear to the right of the player, and a "Press a key to continue." message appears on the status line
               end;
          'T': RTReader.Execute('HELP', 'TALK');
          'V': begin
                  RTReader.Execute('GAMETXT', 'STATS');
                  ViewInventory;
                  RTReader.Execute('GAMETXT', 'CLOSESTATS');
                end;
          'W': begin
                 // TODOY Write mail to another player
               end;
          'Y': RTReader.Execute('HELP', 'YELL');
          'Z': RTReader.Execute('HELP', 'Z');
          '?': RTReader.Execute('HELP', 'HELP');
        end;
      end;
    until (Ch = 'Q');

    // TODOX Clear status bar and disable events so its not redrawn
    RTReader.Execute('GAMETXT', 'ENDGAME');
    Sleep(2500);
  end;

  RTGlobal.RefFiles.Clear;
  RTGlobal.RefFiles.Free;
end;

function TotalAccounts: Integer;
var
  F: File of TraderDatRecord;
begin
  if (FileExists(TraderDatFileName)) then
  begin
    if (OpenFileForReadWrite(F, TraderDatFileName, 2500)) then
    begin
      Result := FileSize(F) div SizeOf(TraderDatRecord);
      Close(F);
    end else
    begin
      raise Exception.Create('Unable to open ' + ExtractFileName(TraderDatFileName) + '.  Sorry.');
    end;
  end else
  begin
    Result := 0;
  end;
end;

procedure Update;
begin
  // Draw the Player
  DoorTextBackground(CurrentMap.MapInfo[Player.x][Player.y].BackColour);
  DoorTextColour(White);
  DoorGotoXY(Player.x, Player.y);
  DoorWrite(#02);

  // TODOY Draw the other players
end;

procedure ViewInventory;
var
  Ch: Char;
  I: Integer;
  InventoryItems: TStringList;
  Item: ItemsDatRecord;
  ItemName: String;
  Option: String;
begin
  DoorCursorSave;
  DoorCursorDown(1);

  InventoryItems := TStringList.Create;
  for I := 1 to 99 do
  begin
    if (Player.I[I] > 0) then InventoryItems.Add(IntToStr(I));
  end;

  if (InventoryItems.Count = 0) then
  begin
    InventoryItems.Free;

    DoorWrite('`2  You are carrying nothing!  (press `%Q`2 to continue)');
    repeat
      Ch := UpCase(DoorReadKey);
    until (Ch = 'Q');
  end else
  begin
    // Setup inventory items
    DoorLiteBarIndex := 0;
    DoorLiteBarOptions.Clear;
    for I := 0 to InventoryItems.Count - 1 do
    begin
      Item := Game.ItemsDat.Item[StrToInt(InventoryItems[I])];
      ItemName := Item.Name; // Item.Name can only hold 30, so we need a temp variable
      if (Item.Armour) then ItemName += ' `0A`2';
      if (Item.Weapon) then ItemName += ' `4W`2';
      if (Item.UseOnce) then ItemName += ' `51`2';

      Option := '';
      Option += '`2  ' + ItemName;
      Option += AddCharR(' ', '', 35 - Length(SethStrip(ItemName)));
      Option += '`2 (`0' + IntToStr(Player.I[StrToInt(InventoryItems[I])]) + '`2)' + AddCharR(' ', '', 7 - Length(IntToStr(Player.I[StrToInt(InventoryItems[I])])));
      Option += '`2 ' + Item.Description;
      Option += AddCharR(' ', '', 31 - Length(SethStrip(Item.Description)));

      DoorLiteBarOptions.Add(Option);
    end;

    // Repeatedly display litebar until user quits
    repeat
      if (DoorLiteBar(11)) then
      begin
        Item := Game.ItemsDat.Item[StrToInt(InventoryItems[DoorLiteBarIndex])];

        // TODOX Equip/use/whatever the item
        DoorGotoXY(1, 24);
        DoorWrite('`r4                                                                               ');
        DoorGotoX(1);
        DoorWrite('`* ' + Item.Name + '  `2(`0press a key to continue`2)`r0');
        DoorReadKey;
        DoorCursorRestore;
      end else
      begin
        Break;
      end;
    until False;

    // Exit inventory
    DoorCursorRestore;
    InventoryItems.Free;
  end;
end;

begin
end.

