unit Game;

{$mode objfpc}{$H+}

interface

uses
  Struct, SysUtils, RTGlobal, MannDoor, mAnsi, Crt, RTReader;

var
  CurrentMap: plan_rec;
  IsNewDay: Boolean = false;
  ItemsDat: item_rec;
  LastX: Integer;
  LastY: Integer;
  MapDat: Array of plan_rec;
  Player: user_rec;
  PlayerNum: Integer = -1;
  Time: Integer = 1;
  WorldDat: world_info;

procedure DrawMap;
function LoadDataFiles: Boolean;
procedure LoadMap(AMapNumber: Integer);
function LoadPlayerByRealName(ARealName: String; var ARecord: user_rec): Integer;
procedure Start;
procedure Update;

implementation

function LoadItemsDat: Boolean; forward;
function LoadMapDat: Boolean; forward;
function LoadSTimeDat: Boolean; forward;
function LoadTimeDat: Boolean; forward;
function LoadWorldDat: Boolean; forward;
procedure MovePlayer(AXOffset, AYOffset: Integer); forward;

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
  mTextAttr(FG);
  mClrScr;

  for Y := 1 to 20 do
  begin
    ToSend := '';

    for X := 1 to 80 do
    begin
      MI := CurrentMap.W[X][Y];

      if (BG <> MI.bc) then
      begin
        ToSend := ToSend + mAnsi.aTextBackground(MI.bc);
        Crt.TextBackground(MI.bc); // Gotta do this to ensure calls to Ansi.* work right
        BG := MI.bc;
      end;

      if (FG <> MI.fc) then
      begin
        ToSend := ToSend + mAnsi.aTextColor(MI.fc);
        Crt.TextColor(MI.fc); // Gotta do this to ensure calls to Ansi.* work right
        FG := MI.fc;
      end;

      ToSend := ToSend + MI.c;
    end;

    mWrite(ToSend);
  end;
end;

function LoadDataFiles: Boolean;
begin
  Result := true;
  Result := Result AND LoadItemsDat;
  Result := Result AND LoadMapDat;
  Result := Result AND LoadSTimeDat;
  Result := Result AND LoadTimeDat;
  Result := Result AND LoadWorldDat;
end;

function LoadItemsDat: Boolean;
var
  F: File of item_rec;
begin
  // TODO Retry if IOError
  Assign(F, 'ITEMS.DAT');
  {$I-}Reset(F);{$I+}
  if (IOResult = 0) then
  begin
    Read(F, ItemsDat);
    Result := true;
  end else
  begin
    Result := false;
  end;
  Close(F);
end;

procedure LoadMap(AMapNumber: Integer);
begin
  CurrentMap := MapDat[WorldDat.loc[AMapNumber]];
end;

function LoadMapDat: Boolean;
var
  F: File of plan_rec;
  I: Integer;
begin
  // TODO Retry if IOError
  Assign(F, 'MAP.DAT');
  {$I-}Reset(F);{$I+}
  if (IOResult = 0) then
  begin
    SetLength(MapDat, FileSize(F) + 1); // + 1 since we want a 1-based MapDat
    I := 0;
    repeat
      I := I + 1;
      Read(F, MapDat[I]);
    until EOF(F);
    Result := true;
  end else
  begin
    Result := false;
  end;
  Close(F);
end;

function LoadPlayerByRealName(ARealName: String; var ARecord: user_rec): Integer;
var
  F: File of user_rec;
  I: Integer;
  Rec: user_rec;
begin
  Result := -1;

  // TODO Retry if IOError
  Assign(F, 'TRADER.DAT');
  {$I-}Reset(F);{$I+}
  if (IOResult = 0) then
  begin
    I := 0;
    repeat
      I := I + 1;
      Read(F, Rec);
      if (UpperCase(Rec.real_names) = UpperCase(ARealName)) then
      begin
        ARecord := Rec;
        Result := I;
        break;
      end;
    until EOF(F);
  end;
  Close(F);
end;

function LoadSTimeDat: Boolean;
var
  F: Text;
  S: String;
  STime: String;
  Y, M, D, DOW: Word;
begin
  DecodeDate(Date, Y, M, D);
  STime := IntToStr(Y + M + D);

  if (FileExists('STIME.DAT')) then
  begin
    // TODO Retry if IOError
    Assign(F, 'STIME.DAT');
    {$I-}Reset(F);{$I+}
    if (IOResult = 0) then
    begin
      ReadLn(F, S);
      if (S <> STime) then
      begin
        IsNewDay := true;
      end;
    end;
    Close(F);
  end else
  begin
    IsNewDay := true;
  end;

  if (IsNewDay) then
  begin
    // TODO Retry if IOError
    Assign(F, 'STIME.DAT');
    {$I-}ReWrite(F);{$I+}
    if (IOResult = 0) then
    begin
      WriteLn(F, STime);
    end;
    Close(F);
  end;

  Result := true;
end;

function LoadTimeDat: Boolean;
var
  F: Text;
  S: String;
begin
  if (FileExists('TIME.DAT')) then
  begin
    // TODO Retry if IOError
    Assign(F, 'TIME.DAT');
    {$I-}Reset(F);{$I+}
    if (IOResult = 0) then
    begin
      ReadLn(F, S);
      Time := StrToInt(S);
    end;
    Close(F);
  end else
  begin
    Time := 0;
  end;

  if (IsNewDay) then
  begin
    Time := Time + 1;

    // TODO Retry if IOError
    Assign(F, 'TIME.DAT');
    {$I-}ReWrite(F);{$I+}
    if (IOResult = 0) then
    begin
      WriteLn(F, IntToStr(Time));
    end;
    Close(F);
  end;

  Result := true;
end;

function LoadWorldDat: Boolean;
var
  F: File of world_info;
begin
  // TODO Retry if IOError
  Assign(F, 'WORLD.DAT');
  {$I-}Reset(F);{$I+}
  if (IOResult = 0) then
  begin
    Read(F, WorldDat);
    Result := true;
  end else
  begin
    Result := false;
  end;
  Close(F);
end;

procedure MovePlayer(AXOffset, AYOffset: Integer);
var
  i, x, y: Integer;
begin
  x := Player.x + AXOffset;
  y := Player.y + AYOffset;

  // Check for movement to new screen
  if (x = 0) then
  begin
    Player.lmap := Player.map; // TODO Only if map was visible, according to 3rdparty.doc
    Player.map -= 1;
    Player.X := 80;

    LoadMap(Player.map);
    DrawMap;
    Update;
  end else
  if (x = 81) then
  begin
    Player.lmap := Player.map; // TODO Only if map was visible, according to 3rdparty.doc
    Player.map += 1;
    Player.X := 1;

    LoadMap(Player.map);
    DrawMap;
    Update;
  end else
  if (y = 0) then
  begin
    Player.lmap := Player.map; // TODO Only if map was visible, according to 3rdparty.doc
    Player.map -= 80;
    Player.Y := 20;

    LoadMap(Player.map);
    DrawMap;
    Update;
  end else
  if (y = 21) then
  begin
    Player.lmap := Player.map; // TODO Only if map was visible, according to 3rdparty.doc
    Player.map += 80;
    Player.Y := 1;

    LoadMap(Player.map);
    DrawMap;
    Update;
  end else
  begin
    if (CurrentMap.w[x][y].s = 1) then
    begin
      // Erase player
      mTextBackground(CurrentMap.w[Player.x][Player.y].bc);
      mTextColor(CurrentMap.w[Player.x][Player.y].fc);
      mGotoXY(Player.x, Player.y);
      mWrite(CurrentMap.w[Player.x][Player.y].c);

      // Update position and draw player
      LastX := Player.x;
      LastY := Player.y;
      Player.x := x;
      Player.y := y;
      Update;
    end;
  end;

  // Check for special
  for I := Low(CurrentMap.special) to High(CurrentMap.special) do
  begin
    if (CurrentMap.special[I].dx = x) AND (CurrentMap.special[I].dy = y) then
    begin
      if (CurrentMap.special[I].move_place > 0) AND (CurrentMap.special[I].x > 0) AND (CurrentMap.special[I].y > 0) then
      begin
        Player.lmap := Player.map; // TODO Only if map was visible, according to 3rdparty.doc
        Player.map := CurrentMap.special[I].move_place;
        Player.x := CurrentMap.special[I].x;
        Player.y := CurrentMap.special[I].y;

        LoadMap(Player.map);
        DrawMap;
        Update;
      end else
      if (CurrentMap.special[I].reffile <> '') AND (CurrentMap.special[I].refname <> '') then
      begin
        RTReader.Execute(CurrentMap.special[I].reffile, CurrentMap.special[I].refname);
      end;
    end;
  end;
end;

procedure Start;
var
  Ch: Char;
begin
  LoadMap(Player.map);
  DrawMap;
  Update;

  repeat
    Ch := UpCase(mReadKey);
    case Ch of
      '8': MovePlayer(0, -1);
      '4': MovePlayer(-1, 0);
      '6': MovePlayer(1, 0);
      '2': MovePlayer(0, 1);
    end;
  until (Ch = 'Q');
end;

procedure Update;
begin
  // Draw the Player
  mTextBackground(CurrentMap.w[Player.x][Player.y].bc);
  mTextColor(Crt.White);
  mGotoXY(Player.x, Player.y);
  mWrite(#02);

  // TODO Draw the other players
end;

end.

