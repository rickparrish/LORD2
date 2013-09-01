unit Struct;

{$mode objfpc}{$h+}

interface

type
  // The format for the new *.IDF files.
  IdfRecord = packed record {format of the @data commands when saved}
    LastUsed: longint; {used for the @datanewday feature, this is how it tells
                        if it should reset the data because it is a new day
                        or not}
    Data: array[1..200] of longint; {the real data is kept here}
    Extra: array[1..200] of char; {reserved for gracefull upgrades..
                                   hey, you never know}
  end;

type
  ItemsDatRecord = packed record  {used by item.ref}
    Name: string[30]; {name of item}
    HitAction: string[40];  {string for hitting someone with it}
    UseOnce,
    Armour,
    Weapon,
    Sell,
    Used: boolean;
    Value: longint;   {gold value}
    Breakage: SmallInt;  {break percentage per use}
    MaxBuy: SmallInt;  {unused for now}
    Defence,
    Strength: SmallInt;  {strength/defence added if equipped}
    Eat: SmallInt;    {unused for now}
    RefSection: string[12]; {label of .ref procedure in ITEMS.REF}
    UseAction: string[30]; {text for using it with the .ref}
    Description: string[30]; {description of item that shows to the right}
    QuestItem: boolean; {if true, item cannot be dropped, it is a quest item}
    Extra: array[1..37] of char;  {reserved}
end;

type
  ItemsDatCollection = packed record {the entire ITEMS.DAT file is ONE of this
                                         record format}
    Item: array[1..99] of ItemsDatRecord;
  end;

type
  MAP_INFO = packed record {used by plan_rec, which is for each screen}
    ForeColour: shortint; {foreground color of square}
    BackColour: shortint; {background color of square}
    Ch: char; {actual char}
    T: SmallInt; {can't remember}
    Terrain: shortint; {what type so it knows if you can walk through it or
                        not.. here is the list:
                        if map^.w[x,y].s = 0 then ter := 'Unpassable';
                        if map^.w[x,y].s = 1 then ter := 'Grass';
                        if map^.w[x,y].s = 2 then ter := 'Rocky';
                        if map^.w[x,y].s = 3 then ter := 'Water';
                        if map^.w[x,y].s = 4 then ter := 'Ocean';
                        if map^.w[x,y].s = 5 then ter := 'Forest';   }

  end;

type
  HOT_SPOT = packed record {also used by plan_rec, the ten
                                hotspots available all use this format}
    WarpToMap: SmallInt; {map to move to, 0 if not a warp}
    HotSpotX,
    HotSpotY: shortint; {xy cords of hotspot, 0 if hotspot not used}
    WarpToX,
    WarpToY: shortint;  {xy cords of warp destination, 0 if not a warp}
    RefSection: string[12]; {label of ref procedure to run, if not a warp}
    RefFile: string[12]; {filename of .ref to run if not a warp}
    Extra: array[1..100] of char; {reserved by me}
  end;


type
  MapDatRecord = packed record {record for the MAP.DAT file, which is screen info}
    Name: string[30]; {name of screen}
    MapInfo: array[1..80] of array[1..20] of MAP_INFO; {each block on screen}
    HotSpots: array[1..10] of HOT_SPOT; {the 10 hotspots}
    BattleOdds: longint; {odds of running the 'screen random ref'}
    RefFile: string[12]; {ref file name}
    RefSection: string[12]; {label of ref procedure}
    NoFighting: boolean; {true if players cannot fight on this screen}
    Extra: array[1..469] of char; {reserved by me}
end;

type
  TraderDatRecord = packed record
    Name : string[25]; {handle they choose for LORD2}
    RealName: string[40]; {name from BBS}
    Money,
    Bank,
    Experience: longint; {exp isn't used but reserved}
    LastDayOn,
    Love: SmallInt; {love isn't used but reserved}
    WeaponNumber,
    ArmourNumber: shortint; {item # of wep/arm they have equipped}
    Race: string[30]; {reserved}
    SexMale: SmallInt; {1 if male.. yes there is a reason I didn't use
                        a byte!! <G> }
    OnNow,
    Battle: byte; {these will be OFF when a player is offline}
    Dead,
    Busy,
    Deleted,
    Nice,
    Map,
    E6: SmallInt; {If dead, dead is 1, if deleted, deleted is 1.  Map is map block #.}
    X,
    Y: SmallInt; {current cordinates of player}
    I: array[1..99] of SmallInt; {items.  used by `i}
    P: array[1..99] of longint;  {longints.  used by `i}
    T: array[1..99] of byte;  {bytes.  Used by `t}
    LastSaved: longint; {last day saved}
    LastDayPlayed: longint; {duh}
    LastMap: SmallInt; {last map player was on that was 'visable'}
    Extra: array[1..354] of char; {reserved for me}
end;

{The update.tmp file is made up of this record, one for each player
in order.  Just in case you wanted to write an ap that needed to know
what was going on realtime.}
type
  UpdateTmpRecord = packed record
    X,
    Y: shortint;
    Map: SmallInt;
    OnNow: byte;
    Busy: byte;   {these are all 0 or 1 if true}
    Battle: byte;
  end;

type
  WorldDatRecord = packed record {For the world.dat file -  this is kind of
                                  the index for the MAP.REF file.  It tells LORD2 how each screen hooks
                                  to each other.  loc is each screen - starting at x1,y1 is 1, then this
                                  goes right until 80 is reached, then starts at x1,y2 for 81 etc.}
    Name: string[60];
    MapDatIndex: array[1..1600] of SmallInt; {holds the physical map # of the
                                              record for this screen from the MAP.DAT file.. If # is 0, there is
                                              no screen here. }
    V: array[1..40] of longint; {used by `v}
    S: array[1..10] of string[80]; {used by `s}
    Time: longint; {year+month+day?.. not sure can't remember}
    ShowOnMap: array[1..1600] of byte; {show up on the players auto 'map'?}
    Extra: array[1..396] of char; {extra for me}
  end;

implementation

end.

