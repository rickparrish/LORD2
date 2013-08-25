unit LordStrc;

interface

uses
  Compat;

{
  Seth Able liked to use Integer values of 0 and 5 instead of Boolean values
  of TRUE and FALSE.  These constants are (imo) easier to remember than 0/5.
}
const
  LordFalse  = 0;
  LordTrue   = 5;
  LordMale   = 0;
  LordFemale = 5;

type
  {
    This is a record for reading to/writing from PLAYER.DAT
    It is a modified version of the original one which comes with LORD.
    It employs what I like to call "Sane Naming".  If you are used to
    using the original structure, I have left the original names in brackets.
    So for example, what I now call Alias would have been called Names in
    the original structure.
  }
  TLordPlayerDat = packed record
    Alias:        {Names}           String[20];
    RealName:     {Real_Names}      String[50];
    HP:           {Hit_Points}      SmallInt;
    Unknown1:     {Bad}             SmallInt;
    Unknown2:     {Rate}            SmallInt;
    MaxHP:        {HitMax}          SmallInt;
    WeaponNum:    {Weapon_Num}      SmallInt;
    Weapon:       {Weapon}          String[20];
    SeenMaster:   {Seen_Master}     SmallInt; {5 = True, 0 = False}
    ForestFights: {Fights_Left}     SmallInt;
    HumanFights:  {Human_Left}      SmallInt;
    GoldInHand:   {Gold}            LongInt;
    GoldInBank:   {Bank}            LongInt;
    Defense:      {Def}             SmallInt;
    Strength:     {Strength}        SmallInt;
    Charm:        {Charm}           SmallInt;
    SeenDragon:   {Seen_Dragon}     SmallInt; {5 = True, 0 = False}
    SeenViolet:   {Seen_Violet}     SmallInt; {5 = True, 0 = False}
    Level:        {Level}           SmallInt;
    LastPlayDay:  {Time}            SmallWord;     
    Armour:       {Arm}             String[20];
    ArmourNum:    {Arm_Num}         SmallInt;
    Dead:         {Dead}            ShortInt; {5 = True, 0 = False}
    Inn:          {Inn}             ShortInt; {5 = True, 0 = False}
    Gems:         {Gem}             SmallInt;
    EXP:          {Exp}             LongInt;
    Sex:          {Sex}             ShortInt; {5 = Female, 0 = Male}
    SeenSeth:     {Seen_Bard}       ShortInt; {5 = True, 0 = False}
    LastAliveDay: {Last_Alive_Time} SmallInt;
    Lays:         {Lays}            SmallInt;
    Unknown3:     {Why}             SmallInt;
    OnNow:        {On_Now}          Boolean;
    OnNowTime:    {M_Time}          SmallInt;
    TimeOn:       {Time_On}         String[5];
    UserClass:    {Class}           ShortInt;
    Horse:        {Extra}           SmallInt;
    Unknown4:     {Love}            String[25];
    Married:      {Married}         SmallInt;
    Kids:         {Kids}            SmallInt;
    WinCount:     {King}            SmallInt;
    SkillD:       {SkillW}          ShortInt;
    SkillM:       {SkillM}          ShortInt;
    SkillT:       {SkillT}          ShortInt;
    SkillDUses:   {LevelW}          ShortInt;
    SkillMUses:   {LevelM}          ShortInt;
    SkillTUses:   {LevelT}          ShortInt;
    Unknown5:     {Inn_Random}      Boolean;
    MarriedTo:    {Married_To}      SmallInt;
    Unknown6:     {V1}              LongInt;
    PlayerKills:  {V2}              SmallInt;
    WeirdEvent:   {V3}              SmallInt; {5 = True, 0 = False}
    DoneSpecial:  {V4}              Boolean;
    HasFlirted:   {V5}              ShortInt; {5 = True, 0 = False}
    Unknown7:     {New_Stat1}       ShortInt;
    Unknown8:     {New_Stat2}       ShortInt;
    Unknown9:     {New_Stat3}       ShortInt;
  end;

  {
    This is a record for reading to/writing from MONSTER.DAT
    Same notes from above apply here
  }
  TLordMonsterDat = packed record
    Name:     {Name}       String[60];
    Strength: {Strength}   LongInt;
    Gold:     {Gold}       LongInt;
    Weapon:   {Weapon}     String[60];
    EXP:      {Exp_Points} LongInt;
    HP:       {Hit_Points} LongInt;
    Saying:   {Death}      String[100];
  end;

function ReadLordPlayerDat(AFile: String; ARecord: Integer; var ALordPlayerDat: TLordPlayerDat): Boolean;
function SaveLordPlayerDat(AFile: String; ARecord: Integer; ALordPlayerDat: TLordPlayerDat): Boolean;

implementation

uses
  mUtils;

{
  Use ReadLordPlayerDat to read a record from Lord's PLAYER.DAT file

  AFile - Path\FileName to the PLAYER.DAT you want to read
  ARecord - Record number you want to read (0 Based)
  ALordPlayerDat - TLordPlayerDat variable you want the record read into
}
function ReadLordPlayerDat(AFile: String; ARecord: Integer; var ALordPlayerDat: TLordPlayerDat): Boolean;
var
  F: File of TLordPlayerDat;
  Time: LongInt;
begin
     ReadLordPlayerDat := False;

     FileMode := $12;
     Assign(F, AFile);
     Time := MSecToday;
     repeat
           {$I-}Reset(F);{$I+}
           TimeSlice;
     until (IOResult = 0) or (MSecElapsed(Time, MSecToday) > 5000);
     if (IOResult = 0) then
     begin
          if (ARecord < FileSize(F)) then
          begin
               ReadLordPlayerDat := True;
               Seek(F, ARecord);
               Read(F, ALordPlayerDat);
          end;
          Close(F);
     end;
     FileMode := $42;
end;

{
  Use SaveLordPlayerDat to write a record to Lord's PLAYER.DAT file

  AFile - Path\FileName to the PLAYER.DAT you want to write to
  ARecord - Record number you want to write to (0 Based)
  ALordPlayerDat - TLordPlayerDat variable you want to write from
}
function SaveLordPlayerDat(AFile: String; ARecord: Integer; ALordPlayerDat: TLordPlayerDat): Boolean;
var
  F: File of TLordPlayerDat;
  Time: LongInt;
begin
     SaveLordPlayerDat := False;

     FileMode := $12;
     Assign(F, AFile);
     Time := MSecToday;
     repeat
           {$I-}Reset(F);{$I+}
           TimeSlice;
     until (IOResult = 0) or (MSecElapsed(Time, MSecToday) > 5000);
     if (IOResult = 0) then
     begin
          if (ARecord <= FileSize(F)) then
          begin
               SaveLordPlayerDat := True;
               Seek(F, ARecord);
               Write(F, ALordPlayerDat);
          end;
          Close(F);
     end;
     FileMode := $42;
end;

end.
