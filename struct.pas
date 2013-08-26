unit Struct;

{$mode objfpc}{$H+}

interface

uses
  Compat;

type igm_data = packed record {format of the @data commands when saved}
last_used: longint; {used for the @datanewday feature, this is how it tells
                   if it should reset the data because it is a new day
                   or not}
data: array[1..200] of longint; {the real data is kept here}
extra: array[1..200] of char; {reserved for gracefull upgrades..
                             hey, you never know}
end;

// The above is the format for the new *.IDF files.

type world_info = packed record {For the world.dat file -  this is kind of
the index for the MAP.REF file.  It tells LORD2 how each screen hooks
to each other.  loc is each screen - starting at x1,y1 is 1, then this
goes right until 80 is reached, then starts at x1,y2 for 81 etc.}
name: string[60];
loc: array[1..1600] of SmallInt; {holds the physical map # of the
record for this screen from the MAP.DAT file.. If # is 0, there is
no screen here. }
v: array[1..40] of longint; {used by `v}
s: array[1..10] of string[80]; {used by `s}
time: longint; {year+month+day?.. not sure can't remember}
show: array[1..1600] of byte; {show up on the players auto 'map'?}
extra: array[1..396] of char; {extra for me}
end;




type user_rec = packed record
name : string[25]; {handle they choose for LORD2}
real_names: string[40]; {name from BBS}
gold,bank,exp: longint; {exp isn't used but reserved}
last_day_on,love: SmallInt; {love isn't used but reserved}
wep,arm: shortint; {item # of wep/arm they have equipped}
race: string[30]; {reserved}
sex_male: SmallInt; {1 if male.. yes there is a reason I didn't use
                   a byte!! <G> }
on_now,battle: byte; {these will be OFF when a player is offline}
dead,busy,deleted,nice,map,e6: SmallInt;
{If dead, dead is 1, if deleted, deleted is 1.  Map is map block #.}
x,y: SmallInt; {current cordinates of player}
item: array[1..99] of SmallInt; {items.  used by `i}
p: array[1..99] of longint;  {longints.  used by `i}
b: array[1..99] of byte;  {bytes.  Used by `t}
last_saved: longint; {last day saved}
last_day_played: longint; {duh}
lmap: SmallInt; {last map player was on that was 'visable'}
extra: array[1..354] of char; {reserved for me}
end;

type all_players = packed record
p: array[1..200] of user_rec;
end;


{The update.tmp file is made up of this record, one for each player
in order.  Just in case you wanted to write an ap that needed to know
what was going on realtime.}

    type q_update = packed record
x,y: shortint;
map: SmallInt;
on_now: byte;
busy: byte;   {these are all 0 or 1 if true}
battle: byte;
end;





type item_struct = packed record  {used by item.ref}
name: string[30]; {name of item}
action: string[40];  {string for hitting someone with it}
use_once,armour,weapon,sell,used: boolean;
value: longint;   {gold value}
breakage: SmallInt;  {break percentage per use}
max_buy: SmallInt;  {unused for now}
def,strength: SmallInt;  {strength/defence added if equipped}
eat: SmallInt;    {unused for now}
ref: string[12]; {label of .ref procedure in ITEMS.REF}
use_action: string[30]; {text for using it with the .ref}
descrip: string[30]; {description of item that shows to the right}
drop: boolean; {if true, item cannot be dropped, it is a quest item}
extra: array[1..37] of char;  {reserved}
end;

type item_rec = packed record {the entire ITEMS.DAT file is ONE of this
record format}
i: array[1..99] of item_struct;
end;


type map_info = packed record {used by plan_rec, which is for each
                        screen}
fc: shortint; {foreground color of square}
bc: shortint; {background color of square}
c: char; {actual char}
t: SmallInt; {can't remember}
s: shortint; {what type so it knows if you can walk through it or
not.. here is the list:

if map^.w[x,y].s = 0 then ter := 'Unpassable';
if map^.w[x,y].s = 1 then ter := 'Grass';
if map^.w[x,y].s = 2 then ter := 'Rocky';
if map^.w[x,y].s = 3 then ter := 'Water';
if map^.w[x,y].s = 4 then ter := 'Ocean';
if map^.w[x,y].s = 5 then ter := 'Forest';   }

end;


type special_struct = packed record {also used by plan_rec, the ten
hotspots available all use this format}
move_place: SmallInt; {map to move to, 0 if not a warp}
dx,dy: shortint; {xy cords of hotspot, 0 if hotspot not used}
x,y: shortint;  {xy cords of warp destination, 0 if not a warp}
refname: string[12]; {label of ref procedure to run, if not a warp}
reffile: string[12]; {filename of .ref to run if not a warp}
extra: array[1..100] of char; {reserved by me}
end;


type plan_rec = packed record {record for the MAP.DAT file, which is
screen info}
name: string[30]; {name of screen}
w: array[1..80] of array[1..20] of map_info; {each block on screen}
special: array[1..10] of special_struct; {the 10 hotspots}
battle_odds: longint; {odds of running the 'screen random ref'}
batfile: string[12]; {ref file name}
batname: string[12]; {label of ref procedure}
safe: boolean; {true if players cannot fight on this screen}
extra: array[1..469] of char; {reserved by me}
end;

implementation

end.

