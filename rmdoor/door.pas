unit Door;

{$mode objfpc}

interface

uses
  Ansi, Comm, StringUtils,
  Classes, Crt, StrUtils, SysUtils;

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
    MaxTime   : LongInt;            {ABCDE} {User's Time Left At Start (In Seconds)}
    Node      : LongInt;            {A-C-E} {Node Number}
    RealName  : String;             {ABCDE} {User's Real Name}
    RecPos    : LongInt;            {A-CD-} {User's Userfile Record Position (Always 0 Based)}
    Registered: Boolean;            {---D-} {Is LORD Registered?}
  end;

  TLastKeyType = (lkNone, lkLocal, lkRemote);

  {
    Information about the last key pressed is stored in this record.
    This should be considered read-only.
  }
  TDoorLastKey = Record
    Ch: Char;               { Character of last key }
    Extended: Boolean;      { Was character preceded by #0 }
    Location: TLastKeyType; { Location of last key }
    Time: TDateTime;        { SecToday of last key }
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
    DoIdleCheck: Boolean; { Check for idle timeout? }
    Events: Boolean;      { Run Events in mKeyPressed function }
    EventsTime: LongInt;  { MSecToday of last Events run }
    LocalIO: Boolean;     { Whether to enable local i/o }
    MaxIdle: LongInt;     { Max idle before kick (in seconds) }
    SethWrite: Boolean;   { Whether to interpret ` codes }
    TimeOn: LongInt;      { SecToday program was started }
  end;

var
  DoorDropInfo: TDoorDropInfo;
  DoorLastKey: TDoorLastKey;
  DoorMOREPrompts: TDoorMOREPrompts;
  DoorSession: TDoorSession;

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
function DoorReadKey: Char;
function DoorSecondsLeft: LongInt;
procedure DoorStartUp;
procedure DoorTextAttr(AAttr: Byte);
procedure DoorTextBackground(AColour: Byte);
procedure DoorTextColour(AColour: Byte);
procedure DoorWrite(AText: String);
procedure DoorWriteLn;
procedure DoorWriteLn(AText: String);

implementation

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
  //TODO DoorDoEvents;
  Result := KeyPressed;
  if Not(DoorLocal) then Result := Result OR CommCharAvail;
end;

{
  Returns TRUE if the door is being run in local mode
}
function DoorLocal: Boolean;
begin
  Result := true; // TODO DropInfo.ComType = 0;
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
    if (DoorSession.LocalIO) then
    begin
      if (KeyPressed) then
      begin
        Ch := ReadKey;
        if (Ch = #0) then
        begin
          Ch := ReadKey;
          //TODOif Not(DoorLocal) and Assigned(mOnSysopKey) and Not(mOnSysopKey(Ch)) then
          //TODObegin
            DoorLastKey.Extended := True;
            DoorLastKey.Location := lkLocal;
          //TODOend;
        end else
        begin
          DoorLastKey.Extended := False;
          DoorLastKey.Location := lkLocal;
        end;
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
  Returns the number of seconds the user has left this session
}
function DoorSecondsLeft: LongInt;
begin
     Result := 60; // TODO DropInfo.MaxTime - SecElapsed(Session.TimeOn, SecToday);
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
     (*TODODropFile := '';
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
                         else
                             if Assigned(mOnCLP) then
                                mOnCLP(Ch, S);
                    end;
               end;
          end;
     end;

     if (Local) then
     begin
          DropInfo.Node := Node;
          if Assigned(mOnLocalLogin) then
          begin
               mOnLocalLogin;
               mClrScr;
          end;
     end else
     if (Wildcat) then
     begin
          DropInfo.ComNum := 1;
          DropInfo.ComType := 3;
     end else
     if (Socket >= 0) and (Node > 0) then
     begin
          DropInfo.ComNum := Socket;
          DropInfo.Node := Node;

          if (Telnet) then
             DropInfo.ComType := 2
          else
              DropInfo.ComType := 1;
     end else
     if (DropFile <> '') then
     begin
          if (FileExists(DropFile)) and (ciPos('DOOR32.SYS', DropFile) > 0) then
             ReadDoor32(DropFile)
          else
          if (FileExists(DropFile)) and (ciPos('DoorSYS', DropFile) > 0) then
             ReadDoorSys(DropFile)
          else
          if (FileExists(DropFile)) and (ciPos('DORINFO', DropFile) > 0) then
             ReadDorinfo(DropFile)
          else
          if (FileExists(DropFile)) and (ciPos('INFO.', DropFile) > 0) then
             ReadInfo(DropFile)
          else
          begin
               ClrScr;
               WriteLn;
               WriteLn('  Drop File Not Found');
               WriteLn;
               Delay(1500);
               Halt;
          end;
     end else
     if Assigned(mOnUsage) then
        mOnUsage;

     if Not(mLocal) then
     begin
          if Not(mOpen) then
          begin
               ClrScr;
               WriteLn;
               WriteLn('  No Carrier Detected');
               WriteLn;
               Delay(1500);
               Halt;
          end;

          LastKey.Time := SecToday;
          Session.Events := True;
          Session.EventsTime := MSecToday - 500;
          Session.TimeOn := SecToday;

          mClrScr;
          {$IFNDEF UNIX}Window(1, 1, 80, 24);{$ENDIF}
     end;*)
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
  Change the current text colour to AColour
}
procedure DoorTextBackground(AColour: Byte);
begin
  DoorWrite(AnsiTextBackground(AColour));
end;

{
  Change the current text background to AColour
}
procedure DoorTextColour(AColour: Byte);
begin
  DoorWrite(AnsiTextColour(AColour));
end;

{
  Writes a line of text to the screen
}
procedure DoorWrite(AText: String);
var
  BackTick2: String;
  BackTick3: String;
  BeforeBackTick: String;
  NumWritten: LongInt;
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
        if (Length(AText) >= 2) then
        begin
          BackTick2 := Copy(AText, 1, 2);
        end else
        begin
          BackTick2 := '';
        end;

        case BackTick2 of
          '``':
          begin
            DoorWrite('`');
            Delete(AText, 1, 2);
          end;
          '`1':
          begin
              DoorTextColour(Blue);
              Delete(AText, 1, 2);
          end;
          '`2':
          begin
              DoorTextColour(Green);
              Delete(AText, 1, 2);
          end;
          '`3':
          begin
              DoorTextColour(Cyan);
              Delete(AText, 1, 2);
          end;
          '`4':
          begin
              DoorTextColour(Red);
              Delete(AText, 1, 2);
          end;
          '`5':
          begin
              DoorTextColour(Magenta);
              Delete(AText, 1, 2);
          end;
          '`6':
          begin
              DoorTextColour(Brown);
              Delete(AText, 1, 2);
          end;
          '`7':
          begin
              DoorTextColour(LightGray);
              Delete(AText, 1, 2);
          end;
          '`8':
          begin
              DoorTextColour(White); // Supposed to be dark gray, but a bug has this as white (TODO Check if this is still accurate)
              Delete(AText, 1, 2);
          end;
          '`9':
          begin
              DoorTextColour(LightBlue);
              Delete(AText, 1, 2);
          end;
          '`0':
          begin
              DoorTextColour(LightGreen);
              Delete(AText, 1, 2);
          end;
          '`!':
          begin
              DoorTextColour(LightCyan);
              Delete(AText, 1, 2);
          end;
          '`@':
          begin
              DoorTextColour(LightRed);
              Delete(AText, 1, 2);
          end;
          '`#':
          begin
              DoorTextColour(LightMagenta);
              Delete(AText, 1, 2);
          end;
          '`$':
          begin
              DoorTextColour(Yellow);
              Delete(AText, 1, 2);
          end;
          '`%':
          begin
              DoorTextColour(White);
              Delete(AText, 1, 2);
          end;
          '`*':
          begin
              DoorTextColour(Black);
              Delete(AText, 1, 2);
          end;
          '`b': // TODO Case sensitive?
          begin
              // TODO
              Delete(AText, 1, 2);
          end;
          '`c': // TODO Case sensitive?
          begin
              DoorTextAttr(7);
              DoorClrScr;
              DoorWrite(#13#10#13#10);
              Delete(AText, 1, 2);
          end;
          '`d': // TODO Case sensitive?
          begin
              DoorWrite(#8);
              Delete(AText, 1, 2);
          end;
          '`k': // TODO Case sensitive?
          begin
              DoorWrite('  `2<`0MORE`2>');
              DoorReadKey;
              DoorWrite(#8#8#8#8#8#8#8#8 + '        ' + #8#8#8#8#8#8#8#8);
              Delete(AText, 1, 2);
          end;
          '`l': // TODO Case sensitive?
          begin
              Delay(500);
              Delete(AText, 1, 2);
          end;
          '`w': // TODO Case sensitive?
          begin
              Delay(100);
              Delete(AText, 1, 2);
          end;
          '`x': // TODO Case sensitive?
          begin
              DoorWrite(' ');
              Delete(AText, 1, 2);
          end;
          '`\':
          begin
              DoorWrite(#13#10);
              Delete(AText, 1, 2);
          end;
          '`|':
          begin
              // TODO Unknown what this does, but it's used once in LORD2
              Delete(AText, 1, 2);
          end;
          '`.':
          begin
              // TODO Also unknown, used by RTNEWS
              Delete(AText, 1, 2);
          end;
          else
          begin
            if (Length(AText) >= 3) then
            begin
              BackTick3 := Copy(AText, 1, 3);
            end else
            begin
              BackTick3 := '';
            end;

            case BackTick3 of
              '`r0':
              begin
                  DoorTextBackground(Black);
                  Delete(AText, 1, 3);
              end;
              '`r1':
              begin
                  DoorTextBackground(Blue);
                  Delete(AText, 1, 3);
              end;
              '`r2':
              begin
                  DoorTextBackground(Green);
                  Delete(AText, 1, 3);
              end;
              '`r3':
              begin
                  DoorTextBackground(Cyan);
                  Delete(AText, 1, 3);
              end;
              '`r4':
              begin
                  DoorTextBackground(Red);
                  Delete(AText, 1, 3);
              end;
              '`r5':
              begin
                  DoorTextBackground(Magenta);
                  Delete(AText, 1, 3);
              end;
              '`r6':
              begin
                  DoorTextBackground(Brown);
                  Delete(AText, 1, 3);
              end;
              '`r7':
              begin
                  DoorTextBackground(LightGray);
                  Delete(AText, 1, 3);
              end;
              else
              begin
                  // No match, so output the backtick
                  DoorWrite('`');
                  Delete(AText, 1, 1);
              end;
            end;
          end;
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

begin
  //TODO  OldExitProc := ExitProc;
  //TODO  ExitProc := @NewExitProc;

(*TODO  mOnCLP := nil;
  mOnHangup := @OnHangup;
  mOnLocalLogin := @OnLocalLogin;
  mOnStatusBar := @OnStatusBar;
  mOnSysopKey := nil;
  mOnTimeOut := @OnTimeOut;
  mOnTimeOutWarning := nil;
  mOnTimeUp := @OnTimeUp;
  mOnTimeUpWarning := nil;
  mOnUsage := @OnUsage;*)

  with DoorDropInfo do
  begin
       Access := 0;
       Alias := '';
       Clean := False;
       ComNum := 0;
       ComType := 0;
       Emulation := etANSI;
       Fairy := False;
       MaxTime := 3600;
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

  with DoorSession do
  begin
       DoIdleCheck := True;
       Events := False;
       EventsTime := 0;
       LocalIO := true;
       MaxIdle := 300;
       SethWrite := false;
       TimeOn := 0;
  end;
end.

