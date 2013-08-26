unit Game;

{$mode objfpc}{$H+}

interface

uses
  Struct, SysUtils, RTGlobal;

var
  IsNewDay: Boolean = false;
  ItemsDat: item_rec;
  MapDat: Array of plan_rec;
  Player: user_rec;
  WorldDat: world_info;

function LoadDataFiles: Boolean;
function LoadPlayerByRealName(ARealName: String; var ARecord: user_rec): Integer;

implementation

function LoadItemsDat: Boolean; forward;
function LoadMapDat: Boolean; forward;
function LoadSTimeDat: Boolean; forward;
function LoadTimeDat: Boolean; forward;
function LoadWorldDat: Boolean; forward;

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

end.

