unit Game;

{$mode objfpc}{$H+}

interface

uses
  Struct, SysUtils, RTGlobal, MannDoor, mAnsi, Crt;

var
  CurrentMap: plan_rec;
  IsNewDay: Boolean = false;
  ItemsDat: item_rec;
  MapDat: Array of plan_rec;
  Player: user_rec;
  WorldDat: world_info;

function LoadDataFiles: Boolean;
function LoadPlayerByRealName(ARealName: String; var ARecord: user_rec): Integer;
procedure Start;

implementation

procedure DrawMap; forward;
function LoadItemsDat: Boolean; forward;
function LoadMapDat: Boolean; forward;
function LoadSTimeDat: Boolean; forward;
function LoadTimeDat: Boolean; forward;
function LoadWorldDat: Boolean; forward;

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
      RTGlobal.Time := StrToInt(S);
    end;
    Close(F);
  end else
  begin
    RTGlobal.Time := 0;
  end;

  if (IsNewDay) then
  begin
    RTGlobal.Time := RTGlobal.Time + 1;

    // TODO Retry if IOError
    Assign(F, 'TIME.DAT');
    {$I-}ReWrite(F);{$I+}
    if (IOResult = 0) then
    begin
      WriteLn(F, IntToStr(RTGlobal.Time));
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

procedure Start;
var
  Ch: Char;
begin
  WriteLn(Player.map);
  CurrentMap := MapDat[WorldDat.loc[Player.map]];
  DrawMap;
  // TODO Update; // Draw players

  repeat
    Ch := UpCase(mReadKey);

  until (Ch = 'Q');
end;

end.

