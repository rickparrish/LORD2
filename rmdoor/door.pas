unit Door;

{$mode objfpc}{$h+}

interface

uses
  Ansi, Comm, DropFiles, StringUtils, VideoUtils,
  Classes, Crt, DateUtils, StrUtils, SysUtils;

const
  DOOR_INPUT_CHARS_ALL = '`1234567890-=\qwertyuiop[]asdfghjkl;''zxcvbnm,./~!@#$%^&*()_+|QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>? ';
  DOOR_INPUT_CHARS_ALPHA = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
  DOOR_INPUT_CHARS_NUMERIC = '1234567890';
  DOOR_INPUT_CHARS_FILENAME = '1234567890-=\qwertyuiop[]asdfghjkl;''zxcvbnm,.~!@#$%^&()_+QWERTYUIOP{}ASDFGHJKL:ZXCVBNM ';

type
  TDoorEmulationType = (etANSI, etASCII);

  {
    When a dropfile is read there is some useless information so it is not
    necessary to store the whole thing in memory.  Instead only certain
    parts are saved to this record

    Supported Dropfiles
    A = Found In DOOR32.SYS
    B = Found In DORINFO*.DEF
    C = Found In DOOR.SYS
    D = Found In INFO.*
    E = Supported By WINServer
  }
  TDoorDropInfo = Record
    Access    : LongInt;            {ABC--} {User's Access Level}
    Alias     : String;             {ABCDE} {User's Alias/Handle}
    Baud      : LongInt;            {ABCDE} {Connection Baud Rate}
    Clean     : Boolean;            {---D-} {Is LORD In Clean Mode?}
    ComNum    : LongInt;            {ABCD-} {Comm/Socket Number}
    ComType   : Byte;               {A----} {Comm Type (0=Local, 1=Serial, 2=Socket, 3=WC5}
    Emulation : TDoorEmulationType; {ABCDE} {User's Emulation (etANSI or etASCII)}
    Fairy     : Boolean;            {---D-} {Does LORD User Have Fairy?}
    MaxSeconds: LongInt;            {ABCDE} {User's Time Left At Start (In Seconds)}
    Node      : LongInt;            {A-C-E} {Node Number}
    RealName  : String;             {ABCDE} {User's Real Name}
    RecPos    : LongInt;            {A-CD-} {User's Userfile Record Position (Always 0 Based)}
    Registered: Boolean;            {---D-} {Is LORD Registered?}
  end;

  TDoorLastKeyType = (lkNone, lkLocal, lkRemote);

  {
    Information about the last key pressed is stored in this record.
    This should be considered read-only.
  }
  TDoorLastKey = Record
    Ch: Char;                   { Character of last key }
    Extended: Boolean;          { Was character preceded by #0 }
    Location: TDoorLastKeyType; { Location of last key }
    Time: TDateTime;            { SecToday of last key }
  end;

  {
    MORE prompts will use these two lines based on whether use has ANSI or ASCII
  }
  TDoorMOREPrompts = Record
    ASCII: String;           { Used by people with ASCII }
    ANSI: String;            { Used by people with ANSI }
    ANSITextLength: Integer; { ANSI may have non-displaying characters, we need to know the length of just the text }
  end;

  {
    Information about the current session is stored in this record.
  }
  TDoorSession = Record
    DoIdleCheck: Boolean;  { Check for idle timeout? }
    Events: Boolean;       { Run Events in mKeyPressed function }
    EventsTime: TDateTime; { MSecToday of last Events run }
    MaxIdle: LongInt;      { Max idle before kick (in seconds) }
    SethWrite: Boolean;    { Whether to interpret ` codes }
    TimeOn: TDateTime;     { SecToday program was started }
  end;

var
  DoorDropInfo: TDoorDropInfo;
  DoorLastKey: TDoorLastKey;
  DoorMOREPrompts: TDoorMOREPrompts;
  DoorProgramNameAndVersion: String;
  DoorSession: TDoorSession;

  {
    Event variables that may be called at various times throughout
    the programs execution.  Assign them to your own procedures to
    give your program a more unique look
  }
  DoorOnCLP: Procedure(AKey: Char; AValue: String);
  DoorOnHangup: Procedure;
  DoorOnLocalLogin: Procedure;
  DoorOnStatusBar: Procedure;
  DoorOnSysopKey: Function(AKey: Char): Boolean;
  DoorOnTimeOut: Procedure;
  DoorOnTimeOutWarning: Procedure(AMinutes: Byte);
  DoorOnTimeUp: Procedure;
  DoorOnTimeUpWarning: Procedure(AMinutes: Byte);
  DoorOnUsage: Procedure;

function DoorCarrier: Boolean;
procedure DoorClose(ADisconnect: Boolean);
procedure DoorClrScr;
procedure DoorCursorDown(ACount: Byte);
procedure DoorCursorLeft(ACount: Byte);
procedure DoorCursorRestore;
procedure DoorCursorRight(ACount: Byte);
procedure DoorCursorSave;
procedure DoorCursorUp(ACount: Byte);
procedure DoorGotoX(AX: Byte);
procedure DoorGotoXY(AX, AY: Byte);
procedure DoorGotoY(AY: Byte);
function DoorInput(ADefaultText, AAllowedCharacters: String; APasswordCharacter: Char; AVisibleLength, AMaxLength, AAttr: Byte): String;
function DoorKeyPressed: Boolean;
function DoorLocal: Boolean;
function DoorOpenComm: Boolean;
function DoorReadKey: Char;
function DoorSecondsIdle: LongInt;
function DoorSecondsLeft: LongInt;
procedure DoorShutDown;
procedure DoorStartUp;
procedure DoorTextAttr(AAttr: Byte);
procedure DoorTextBackground(AColour: Byte);
procedure DoorTextColour(AColour: Byte);
procedure DoorTextColourAndBlink(AColour: Byte; ABlink: Boolean);
procedure DoorWrite(AText: String);
procedure DoorWriteLn;
procedure DoorWriteLn(AText: String);

implementation

var
  OldExitProc: Pointer;

procedure DoorDoEvents; forward;
procedure NewExitProc; forward;

{
  Default action to take when user drops carrier
}
procedure DefaultOnHangup;
begin
  TextAttr := 15;
  ClrScr;
  WriteLn;
  WriteLn('   Caller Dropped Carrier.  Returning To BBS...');
  Delay(2500);
  Halt;
end;

{
  Default action to take when /L is used on the command-line
}
procedure DefaultOnLocalLogin;
var
  S: String;
begin
  DoorTextAttr(7);
  DoorClrScr;
  DoorWriteLn;
  DoorWriteLn;
  DoorWriteLn('  |1F  LOCAL LOGIN - FOR NODE ' + IntToStr(DoorDropInfo.Node) + '|07');
  DoorWriteLn;
  DoorWriteLn;
  DoorWriteLn('  |09Run ' + ExtractFileName(ParamStr(0)) + ' /? for command-line usage help|07');
  DoorWriteLn;
  DoorWrite('  |0AName or handle |0F:|07 ');
  S := DoorInput('SYSOP', DOOR_INPUT_CHARS_ALPHA + ' ', #0, 40, 40, 31);
  DoorDropInfo.RealName := S;
  DoorDropInfo.Alias := S;
end;

{
  Default status bar displays
}
procedure DefaultOnStatusBar;
begin
  FastWrite(#254 + '                           ' + #254 + '                   ' + #254 + '             ' + #254 + '                ' + #254, 1, 25, 30);
  FastWrite(PadRight(DoorDropInfo.RealName, 22), 3, 25, 31);
  FastWrite(DoorProgramNameAndVersion, 31, 25, 31);
  FastWrite(PadRight('Idle: ' + SecToMS(SecondsBetween(Now, DoorLastKey.Time)), 11), 51, 25, 31);
  FastWrite('Left: ' + SecToHMS(DoorSecondsLeft), 65, 25, 31);
end;

{
  Default action to take when the user idles too long
}
procedure DefaultOnTimeOut;
begin
  DoorTextAttr(15);
  DoorClrScr;
  DoorWriteLn;
  DoorWriteLn('  Idle Time Limit Exceeded.  Returning To BBS...');
  Delay(2500);
  Halt;
end;

{
  Default action to take when the user runs out of time
}
procedure DefaultOnTimeUp;
begin
  DoorTextAttr(15);
  DoorClrScr;
  DoorWriteLn;
  DoorWriteLn('  Your Time Has Expired.  Returning To BBS...');
  Delay(2500);
  Halt;
end;

{
  Default command-line help screen
}
procedure DefaultOnUsage;
begin
  ClrScr;
  WriteLn;
  WriteLn(' USAGE: ' + ExtractFileName(ParamStr(0)) + ' <PARAMETERS>');
  WriteLn;
  WriteLn(' Load settings from a dropfile (DOOR32.SYS, DOOR.SYS, DORINFO*.DEF or INFO.*)');
  WriteLn('  -D         PATH\FILENAME OF DROPFILE');
  WriteLn(' Example: ' + ExtractFileName(ParamStr(0)) + ' -DC:\BBS\NODE1\DOOR32.SYS');
  WriteLn;
  WriteLn(' Pass settings on command-line');
  WriteLn('  -N         NODE NUMBER (REQUIRED)');
  WriteLn('  -H         COM PORT OR SOCKET HANDLE (REQUIRED)');
  WriteLn('  -T         -H PARAMETER IS A SOCKET HANDLE NOT A COM PORT NUMBER');
  //TODO WriteLn('  -W         WINSERVER DOOR32 MODE');
  WriteLn(' Example: ' + ExtractFileName(ParamStr(0)) + ' -N1 -H4');
  WriteLn(' Example: ' + ExtractFileName(ParamStr(0)) + ' -N1 -H1000 -T');
  WriteLn;
  WriteLn(' Run in local mode');
  WriteLn('  -L         LOCAL MODE');
  WriteLn(' Example: ' + ExtractFileName(ParamStr(0)) + ' -L');
  WriteLn;
  Halt;
end;

{
  Returns TRUE unless the user has dropped carrier
}
function DoorCarrier: Boolean;
begin
  Result := DoorLocal OR CommCarrier;
end;

procedure DoorClose(ADisconnect: Boolean);
begin
  if Not(DoorLocal) then CommClose(ADisconnect);
end;

{
  Clears the entire screen and puts the cursor at (1, 1)
}
procedure DoorClrScr;
begin
  DoorWrite(AnsiClrScr);
end;

{
  Move the cursor down ACOUNT lines without changing the X position
}
procedure DoorCursorDown(ACount: Byte);
begin
  DoorWrite(AnsiCursorDown(ACount));
end;

{
  Move the cursor left ACOUNT columns without changing the Y position
}
procedure DoorCursorLeft(ACount: Byte);
begin
  DoorWrite(AnsiCursorLeft(ACount));
end;

{
  Restore the cursor position which was previously saved with mCursorSave
}
procedure DoorCursorRestore;
begin
  DoorWrite(AnsiCursorRestore);
end;

{
  Move the cursor right ACOUNT columns without changing the Y position
}
procedure DoorCursorRight(ACount: Byte);
begin
  DoorWrite(AnsiCursorRight(ACount));
end;

{
  Move the cursor up ACOUNT lines without changing the X position
}
procedure DoorCursorUp(ACount: Byte);
begin
  DoorWrite(AnsiCursorDown(ACount));
end;

{
  Save the current cursor position.  Restore it later with mCursorRestore
}
procedure DoorCursorSave;
begin
  DoorWrite(AnsiCursorSave);
end;

{
  DoorKeyPressed calls this procedure every time it is run.  This is where
  a lot of the "behind the scenes" stuff happens, such as determining how
  much time the user has left, if theyve dropped carrier, and updating the
  status bar.
  It is not recommended that you mess with anything in this procedure
}
procedure DoorDoEvents;
begin
  if (DoorSession.Events) and (SecondsBetween(Now, DoorSession.EventsTime) >= 1) then
  begin
    {Check For Hangup}
    if Not(DoorCarrier) and Assigned(DoorOnHangup) then DoorOnHangup;

    {Check For Idle Timeout}
    if (DoorSession.DoIdleCheck) and (DoorSecondsIdle > DoorSession.MaxIdle) and Assigned(DoorOnTimeOut) then DoorOnTimeOut;

    {Check For Idle Timeout Warning}
    if (DoorSession.DoIdleCheck) and ((DoorSession.MaxIdle - DoorSecondsIdle) mod 60 = 1) and ((DoorSession.MaxIdle - DoorSecondsIdle) div 60 <= 5) and (Assigned(DoorOnTimeOutWarning)) then DoorOnTimeOutWarning((DoorSession.MaxIdle - DoorSecondsIdle) div 60);

    {Check For Time Up}
    if (DoorSecondsLeft < 1) and Assigned(DoorOnTimeUp) then DoorOnTimeUp;

    {Check For Time Up Warning}
    if (DoorSecondsLeft mod 60 = 1) and (DoorSecondsLeft div 60 <= 5) and Assigned(DoorOnTimeUpWarning) then DoorOnTimeUpWarning(DoorSecondsLeft div 60);

    {Update Status Bar}
    if Assigned(DoorOnStatusBar) then DoorOnStatusBar;

    DoorSession.EventsTime := Now;
  end;
end;

{
  Go to column AX on the current line
}
procedure DoorGotoX(AX: Byte);
begin
  DoorWrite(AnsiGotoX(AX));
end;

{
  Go to column AX and line AY on the current screen
}
procedure DoorGotoXY(AX, AY: Byte);
begin
  DoorWrite(AnsiGotoXY(AX, AY));
end;

{
  Go to line AY on the current column
}
procedure DoorGotoY(AY: Byte);
begin
  DoorWrite(AnsiGotoY(AY));
end;

{
  A fancy input routine

  ADefaultText         - The text initially displayed in the edit box
  AAllowedCharacters   - The characters ALLOWED to be part of the string
                         Look in MSTRINGS.PAS for some defaults
  APasswordCharacter   - The password character shown instead of the actual text
                         Use #0 if you dont want to hide the text
  AVisibleLength       - The number of characters big the edit box should be on screen
  AMaxLength           - The number of characters the edit box should allow
                         AMaxLen can be larger than AShowLen, it will just scroll
                         if that happens.
  AAttr                - The text attribute of the editbox's text and background
                         Use formula Attr = Foreground + (Background * 16)

  If the user pressed ESCAPE then ADefaultText is returned.  If they hit enter
  the current string is returned.  They cannot hit enter on a blank line.
}
function DoorInput(ADefaultText, AAllowedCharacters: String; APasswordCharacter: Char; AVisibleLength, AMaxLength, AAttr: Byte): String;
var
   Ch: Char;
   S: String;
   SavedAttr: Byte;
   XPos: Byte;

  procedure UpdateText;
  begin
    DoorGotoX(XPos);
    if (Length(S) > AVisibleLength) then
    begin
      if (APasswordCharacter = #0) then
      begin
       DoorWrite(Copy(S, Length(S) - AVisibleLength + 1, AVisibleLength))
      end else
      begin
        DoorWrite(AddCharR(APasswordCharacter, '', AVisibleLength));
      end;
      DoorGotoX(XPos + AVisibleLength);
    end else
    begin
      if (APasswordCharacter = #0) then
      begin
       DoorWrite(S)
      end else
      begin
        DoorWrite(AddCharR(APasswordCharacter, '', Length(S)));
      end;
      DoorWrite(PadRight('', AVisibleLength - Length(S)));
      DoorGotoX(XPos + Length(S));
    end;
  end;

begin
  if (Length(ADefaultText) > AMaxLength) then ADefaultText := Copy(ADefaultText, 1, AMaxLength);
  S := ADefaultText;

  SavedAttr := TextAttr;
  DoorTextAttr(AAttr);
  XPos := WhereX;

  UpdateText;

  repeat
    Ch := DoorReadKey;
    if (Ch = #8) and (Length(S) > 0) then
    begin
     Delete(S, Length(S), 1);
     DoorWrite(#8 + ' ' + #8);
     if (Length(S) >= AVisibleLength) then UpdateText;
    end else
    if (Ch = #25) and (S <> '') then {CTRL-Y}
    begin
     S := '';
     UpdateText;
    end else
    if (Pos(Ch, AAllowedCharacters) > 0) and (Length(S) < AMaxLength) then
    begin
      S := S + Ch;
      if (Length(S) > AVisibleLength) then
      begin
         UpdateText
      end else
      if (APasswordCharacter = #0) then
      begin
         DoorWrite(Ch)
      end else
      begin
          DoorWrite(APasswordCharacter);
      end;
    end;
  until (Ch = #27) or ((Ch = #13) and (S <> ''));

  DoorTextAttr(SavedAttr);
  DoorWriteLn;

  if (Ch = #27) then S := ADefaultText;
  Result := S;
end;

{
  Returns TRUE if a character is waiting to be read
  Also calls DoEvents to make sure the "dirty work" is handled
}
function DoorKeyPressed: Boolean;
begin
  DoorDoEvents;
  Result := KeyPressed;
  if Not(DoorLocal) then Result := Result OR CommCharAvail;
end;

{
  Returns TRUE if the door is being run in local mode
}
function DoorLocal: Boolean;
begin
  Result := DoorDropInfo.ComType = 0;
end;

{
  Returns TRUE if it was able to open an existing connection
  mStartUp calls this, so you should never have to directly
}
function DoorOpenComm: Boolean;
{$IFDEF WIN32_TODO_WINSERVER}
var
  WC5User: TWC5User;
{$ENDIF}
begin
  if (DoorDropInfo.ComNum = 0) or (DoorDropInfo.ComType = 0) then
  begin
   DoorOpenComm := true;
  end else
  begin
    CommOpen(DoorDropInfo.ComNum);
    DoorOpenComm := CommCarrier;

    {$IFDEF WIN32_TODO_WINSERVER}
    if (DropInfo.ComType = 3) then
    begin
         if (InitWC5) then
         begin
              if (WC5_WildcatLoggedIn^(WC5User) = 1) then
              begin
                   DropInfo.RealName := WC5User.Info.Name;
                   DropInfo.Alias := GetFName(WC5User.Info.Name);
                   DropInfo.MaxTime := WC5User.TimeLeftToday * 60;
                   if (WC5User.TerminalType = 0) then
                      DropInfo.Emulation := etANSI
                   else
                       DropInfo.Emulation := etASCII;
                   DropInfo.Node := WC5_GetNode^();
              end else
                  mOpen := False;
         end else
             mOpen := False;
    end;
    {$ENDIF}
  end;
end;

{
  Returns the next character in the input buffer and updates the TLastKey
  record.
  At this time remote input is read as-is.  In a later version I may add
  ANSI parsing so arrow keys could be read.
}
function DoorReadKey: Char;
var
  Ch: Char;
begin
  Ch := #0;
  DoorLastKey.Location := lkNone;
  repeat
    while Not(DoorKeyPressed) do Sleep(1);

    // Check for local keypress
    if (KeyPressed) then
    begin
      Ch := ReadKey;
      if (Ch = #0) then
      begin
        Ch := ReadKey;
        if Not(DoorLocal) AND (Not(Assigned(DoorOnSysopKey)) OR (Not(DoorOnSysopKey(Ch)))) then
        begin
          DoorLastKey.Extended := True;
          DoorLastKey.Location := lkLocal;
        end;
      end else
      begin
        DoorLastKey.Extended := False;
        DoorLastKey.Location := lkLocal;
      end;
    end;

    // Check for remote keypress (if we didn't get a local keypress)
    if (Ch = #0) AND Not(DoorLocal) AND (CommCharAvail) then
    begin
      Ch := CommReadChar;
      DoorLastKey.Extended := False;
      DoorLastKey.Location := lkRemote;
    end;
  until (DoorLastKey.Location <> lkNone);

  DoorLastKey.Ch := Ch;
  DoorLastKey.Time := Now;

  Result := Ch;
end;

{
  Returns the number of seconds the user has been idle
}
function DoorSecondsIdle: LongInt;
begin
     Result := SecondsBetween(Now, DoorLastKey.Time);
end;

{
  Returns the number of seconds the user has left this session
}
function DoorSecondsLeft: LongInt;
begin
     Result := DoorDropInfo.MaxSeconds - SecondsBetween(Now, DoorSession.TimeOn);
end;

procedure DoorShutDown;
begin
  DoorClose(false);
end;

{
  This is the first call your door should make before making any other call
  to procedures in this unit.  It will parse the command line and take
  action depending on the parameters it receives.
  If a dropfile is to be read, it will happen automatically.
  If the program is not being run in local mode, the existing connection
  to the remote user will be opened.
}
procedure DoorStartUp;
var
   Ch: Char;
   DropFile: String;
   Socket: LongInt;
   I: Integer;
   Local: Boolean;
   Node: Integer;
   S: String;
   Telnet: Boolean;
   Wildcat: Boolean;
begin
  DropFile := '';
  Local := True;
  Node := 0;
  Socket := -1;
  Telnet := False;
  Wildcat := False;

  if (ParamCount > 0) then
  begin
    for I := 1 to ParamCount do
    begin
      S := ParamStr(I);
      if (Length(S) >= 2) and (S[1] in ['/', '-']) then
      begin
        Ch := UpCase(S[2]);
        Delete(S, 1, 2);
        Case UpCase(Ch) of
          '?': Local := False;
          'D': begin
                 Local := False;
                 DropFile := S;
               end;
          'H': begin
                 Local := False;
                 Socket := StrToIntDef(S, -1);
               end;
          'N': Node := StrToIntDef(S, 0);
          'T': begin
                 Local := False;
                 Telnet := True;
               end;
          {$IFDEF WIN32}
          'W': begin
                 Local := False;
                 Wildcat := True;
               end;
          {$ENDIF}
          else if Assigned(DoorOnCLP) then DoorOnCLP(Ch, S);
        end;
      end;
    end;
  end;

  if (Local) then
  begin
    DoorDropInfo.Node := Node;
    if Assigned(DoorOnLocalLogin) then
    begin
      DoorOnLocalLogin;
      DoorClrScr;
    end;
  end else
  if (Wildcat) then
  begin
    DoorDropInfo.ComNum := 1;
    DoorDropInfo.ComType := 3;
  end else
  if (Socket >= 0) and (Node > 0) then
  begin
    DoorDropInfo.ComNum := Socket;
    DoorDropInfo.Node := Node;

    if (Telnet) then
    begin
      DoorDropInfo.ComType := 2
    end else
    begin
      DoorDropInfo.ComType := 1;
    end;
  end else
  if (DropFile <> '') then
  begin
    if (FileExists(DropFile)) and (AnsiContainsText(DropFile, 'DOOR32.SYS')) then
    begin
      ReadDoor32(DropFile);
    end else
    if (FileExists(DropFile)) and (AnsiContainsText(DropFile, 'DOOR.SYS')) then
    begin
      ReadDoorSys(DropFile);
    end else
    if (FileExists(DropFile)) and (AnsiContainsText(DropFile, 'DORINFO')) then
    begin
      ReadDorinfo(DropFile);
    end else
    if (FileExists(DropFile)) and (AnsiContainsText(DropFile, 'INFO.')) then
    begin
      ReadLordInfo(DropFile);
    end else
    begin
      ClrScr;
      WriteLn;
      WriteLn('  Drop File Not Found');
      WriteLn;
      Delay(2500);
      Halt;
    end;
  end else
  begin
    if Assigned(DoorOnUsage) then DoorOnUsage;
    Halt;
  end;

  DoorLastKey.Time := Now;
  DoorSession.TimeOn := Now;

  if Not(DoorLocal) then
  begin
    if Not(DoorOpenComm) then
    begin
      ClrScr;
      WriteLn;
      WriteLn('  No Carrier Detected');
      WriteLn;
      Delay(2500);
      Halt;
    end;

    // Setup exit proc, which ensures the comm is closed properly
    OldExitProc := ExitProc;
    ExitProc := @NewExitProc;

    // Indicate we want events to happen (timeout and timeup check, status bar, etc)
    DoorSession.Events := True;
    DoorSession.EventsTime := 0;

    DoorClrScr;
    Window(1, 1, 80, 24);
  end;
end;

{
  Change the current text foreground and background to AAttr
  Formula: Attr = Foreground + (Background * 16)
}
procedure DoorTextAttr(AAttr: Byte);
begin
  DoorWrite(AnsiTextAttr(AAttr));
end;

{
  Change the current text background to AColour
}
procedure DoorTextBackground(AColour: Byte);
begin
  DoorWrite(AnsiTextBackground(AColour));
end;

{
  Change the current text colour to AColour
}
procedure DoorTextColour(AColour: Byte);
begin
  DoorWrite(AnsiTextColour(AColour));
end;

{
  Change the current text colour to AColour and turn blink on/off
}
procedure DoorTextColourAndBlink(AColour: Byte; ABlink: Boolean);
begin
  DoorWrite(AnsiTextColour(AColour));
  DoorWrite(AnsiBlink(ABlink));
end;

{
  Writes a line of text to the screen
}
procedure DoorWrite(AText: String);
var
  BackTick2: String;
  BackTick3: String;
  BeforeBackTick: String;
begin
  if (Pos('|', AText) > 0) then AText := PipeToAnsi(AText);

  if (DoorSession.SethWrite AND (Pos('`', AText) > 0) AND (Length(AText) > 1)) then
  begin
    while (Length(AText) > 0) do
    begin
      // Write everything up to the next backtick
      if (Pos('`', AText) <> 1) then
      begin
        // First check if we have another backtick
        if (Pos('`', AText) = 0) then
        begin
          // Nope, so write everything and we're done
          DoorWrite(AText);
          AText := '';
        end else
        begin
          // Yep, so only write up until the backtick
          BeforeBackTick := Copy(AText, 1, Pos('`', AText) - 1);
          DoorWrite(BeforeBackTick);
          Delete(AText, 1, Length(BeforeBackTick));
        end;
      end;

      // Now we have a backtick at the beginning of the string
      while (Pos('`', AText) = 1) do
      begin
        if (Length(AText) = 1) then
        begin
          // Only single `, so clear the string
          AText := '';
        end else
        begin
          // At least 2 characters, so run with it
          BackTick2 := Copy(AText, 1, 2);

          case BackTick2 of
            '`1': DoorTextColourAndBlink(Blue, false);
            '`2': DoorTextColourAndBlink(Green, false);
            '`3': DoorTextColourAndBlink(Cyan, false);
            '`4': DoorTextColourAndBlink(Red, false);
            '`5': DoorTextColourAndBlink(Magenta, false);
            '`6': DoorTextColourAndBlink(Brown, false);
            '`7': DoorTextColourAndBlink(LightGray, false);
            '`8': DoorTextColourAndBlink(DarkGray, false);
            '`9': DoorTextColourAndBlink(LightBlue, false);
            '`0': DoorTextColourAndBlink(LightGreen, false);
            '`!': DoorTextColourAndBlink(LightCyan, false);
            '`@': DoorTextColourAndBlink(LightRed, false);
            '`#': DoorTextColourAndBlink(LightMagenta, false);
            '`$': DoorTextColourAndBlink(Yellow, false);
            '`%': DoorTextColourAndBlink(White, false);
            '`*': DoorTextColourAndBlink(Black, false);
            '`b': DoorTextColourAndBlink(Red, true);
            '`c': begin
                    DoorTextAttr(7);
                    DoorClrScr;
                    DoorWrite(#13#10#13#10);
                end;
            '`d': DoorWrite(#8);
            '`k': begin
                    DoorWrite('`r0  `2<`0MORE`2>');
                    DoorReadKey;
                    DoorWrite(#8#8#8#8#8#8#8#8 + '        ' + #8#8#8#8#8#8#8#8);
                end;
            '`l': Delay(500);
            '`w': Delay(100);
            '`x': DoorWrite(' ');
            '`y': DoorTextColourAndBlink(Yellow, true);
            '`\': DoorWrite(#13#10);
            '`|': DoorWrite('|`w`d\`w`d-`w`d/`w`d|`w`d\`w`d-`w`d/`w`d|`w`d `d');
            else
            begin
              if (Length(AText) >= 3) then
              begin
                BackTick3 := Copy(AText, 1, 3);
                if (Pos('`r', BackTick3) = 1) then
                begin
                  case BackTick3 of
                    '`r0': DoorTextBackground(Black);
                    '`r1': DoorTextBackground(Blue);
                    '`r2': DoorTextBackground(Green);
                    '`r3': DoorTextBackground(Cyan);
                    '`r4': DoorTextBackground(Red);
                    '`r5': DoorTextBackground(Magenta);
                    '`r6': DoorTextBackground(Brown);
                    '`r7': DoorTextBackground(LightGray);
                  end;

                  // Delete 1 char from beginning of string since `r is a sequence with 3 characters (and 2 more get deleted below)
                  Delete(AText, 1, 1);
                end;
              end;
            end;
          end;

          // Delete 2 characters to remove the handled sequence from the string
          Delete(AText, 1, 2);
        end;
      end;
    end;
  end else
  begin
    AnsiWrite(AText);
    if Not(DoorLocal) then CommWrite(AText);
  end;
end;

{
  Writes a CR/LF
}
procedure DoorWriteLn;
begin
  DoorWrite(#13#10);
end;

{
  Writes a line of text to the screen, folled by a CR/LF
}
procedure DoorWriteLn(AText: String);
begin
  DoorWrite(AText + #13#10);
end;

{
  Custom exit proc to ensure mShutdown is called
}
procedure NewExitProc;
begin
     ExitProc := OldExitProc;

     DoorTextAttr(7);
     DoorCursorDown(255);
     DoorCursorLeft(255);

     if Not(DoorLocal) then DoorClose(false);
end;

begin
  DoorOnCLP := nil;
  DoorOnHangup := @DefaultOnHangup;
  DoorOnLocalLogin := @DefaultOnLocalLogin;
  DoorOnStatusBar := @DefaultOnStatusBar;
  DoorOnSysopKey := nil;
  DoorOnTimeOut := @DefaultOnTimeOut;
  DoorOnTimeOutWarning := nil;
  DoorOnTimeUp := @DefaultOnTimeUp;
  DoorOnTimeUpWarning := nil;
  DoorOnUsage := @DefaultOnUsage;

  with DoorDropInfo do
  begin
       Access := 0;
       Alias := '';
       Clean := False;
       ComNum := 0;
       ComType := 0;
       Emulation := etANSI;
       Fairy := False;
       MaxSeconds := 3600;
       Node := 0;
       RealName := '';
       RecPos := 0;
       Registered := False;
  end;

  with DoorLastKey do
  begin
       Ch := #0;
       Extended := False;
       Location := lkNone;
       Time := 0;
  end;

  with DoorMOREPrompts do
  begin
    ASCII := ' <MORE>';
    ANSI := ' |0A<|02MORE|0A>';
    ANSITextLength := 7;
  end;

  DoorProgramNameAndVersion := 'RMDoor v13.09.02';

  with DoorSession do
  begin
       DoIdleCheck := True;
       Events := False;
       EventsTime := 0;
       MaxIdle := 300;
       SethWrite := false;
       TimeOn := 0;
  end;
end.

