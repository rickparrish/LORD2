unit MannDoor;

interface

uses
  {$IFDEF WIN32}WC5,{$ENDIF}
  Compat, Crt, EleNorm, SysUtils;

const
  ProgVer = 'MannDoor v6.06.12';

type
  TEmulationType = (etANSI, etASCII);

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
  TDropInfo = Record
    Access    : LongInt;        {ABC--} {User's Access Level}
    Alias     : String;         {ABCDE} {User's Alias/Handle}
    Baud      : LongInt;        {ABCDE} {Connection Baud Rate}
    Clean     : Boolean;        {---D-} {Is LORD In Clean Mode?}
    ComNum    : LongInt;        {ABCD-} {Comm/Socket Number}
    ComType   : Byte;           {A----} {Comm Type (0=Local, 1=Serial, 2=Socket, 3=WC5}
    Emulation : TEmulationType; {ABCDE} {User's Emulation (eANSI or eASCII)}
    Fairy     : Boolean;        {---D-} {Does LORD User Have Fairy?}
    MaxTime   : LongInt;        {ABCDE} {User's Time Left At Start (In Seconds)}
    Node      : LongInt;        {A-C-E} {Node Number}
    RealName  : String;         {ABCDE} {User's Real Name}
    RecPos    : LongInt;        {A-CD-} {User's Userfile Record Position (Always 0 Based)}
    Registered: Boolean;        {---D-} {Is LORD Registered?}
  end;

  TLastKeyType = (lkNone, lkLocal, lkRemote);

  {
    Information about the last key pressed is stored in this record.
    This should be considered read-only.
  }
  TLastKey = Record
    Ch: Char;               { Character of last key }
    Extended: Boolean;      { Was character preceded by #0 }
    Location: TLastKeyType; { Location of last key }
    Time: LongInt;          { SecToday of last key }
  end;

  {
    MORE prompts will use these two lines based on whether use has ANSI or ASCII
  }
  TMOREPrompts = Record
    ASCII: String;           { Used by people with ASCII }
    ANSI: String;            { Used by people with ANSI }
    ANSITextLength: Integer; { ANSI may have non-displaying characters, we need to know the length of just the text }
  end;
  
  {
    Information about the current session is stored in this record.
  }
  TSession = Record
    DoIdleCheck: Boolean; { Check for idle timeout? }
    Events: Boolean;      { Run Events in mKeyPressed function }
    EventsTime: LongInt;  { MSecToday of last Events run }
    MaxIdle: LongInt;     { Max idle before kick (in seconds) }
    TimeOn: LongInt;      { SecToday program was started }
  end;

var
   DropInfo: TDropInfo;
   LastKey: TLastKey;
   MOREPrompts: TMOREPrompts;
   Session: TSession;

   {
     Event variables that may be called at various times throughout
     the programs execution.  Assign them to your own procedures to
     give your program a more unique look
   }
   mOnCLP: Procedure(AKey: Char; AValue: String);
   mOnHangup: Procedure;
   mOnLocalLogin: Procedure;
   mOnStatusBar: Procedure;
   mOnSysopKey: Function(AKey: Char): Boolean;
   mOnTimeOut: Procedure;
   mOnTimeOutWarning: Procedure(AMinutes: Byte);
   mOnTimeUp: Procedure;
   mOnTimeUpWarning: Procedure(AMinutes: Byte);
   mOnUsage: Procedure;

{
  Standard MannDoor functions and procedures
}
function mCarrier: Boolean;
procedure mClearBuf;
procedure mClose;
procedure mClrEol;
procedure mClrScr;
procedure mCrlf;
procedure mCursorDown(ACount: Byte);
procedure mCursorLeft(ACount: Byte);
procedure mCursorRestore;
procedure mCursorRight(ACount: Byte);
procedure mCursorSave;
procedure mCursorUp(ACount: Byte);
procedure mDisplayFile(AFile: String; AMORECheck: Byte);
procedure mDoEvents;
procedure mGotoX(AX: Byte);
procedure mGotoXY(AX, AY: Byte);
procedure mGotoY(AY: Byte);
function mInput(ADefault, AChars: String; APass: Char; AShowLen, AMaxLen, AAttr: Byte): String;
function mKeyPressed: Boolean;
function mLocal: Boolean;
procedure mMore;
function mOpen: Boolean;
function mReadKey: Char;
procedure mStartUp;
procedure mTextAttr(AAttr: Byte);
procedure mTextBackground(AColour: Byte);
procedure mTextColor(AColour: Byte);
function mTimeIdle: LongInt;
function mTimeLeft: LongInt;
procedure mWrite(ALine: String);
procedure mWriteLn(ALine: String);
procedure ReadDoor32(AFile: String);
procedure ReadDoorSys(AFile: String);
procedure ReadDorinfo(AFile: String);
procedure ReadInfo(AFile: String);

{
  Default event procedures.  It is not recommended you change these, instead
  you should just reassign the above mOn* variables to your own procedures.
}
procedure OnHangup;
procedure OnLocalLogin;
procedure OnStatusBar;
procedure OnTimeOut;
procedure OnTimeUp;
procedure OnUsage;

implementation

uses
  mAnsi, mCrt, mStrings, mUtils;

var
  OldExitProc: Pointer;

{
  Returns TRUE unless the user has dropped carrier
}
function mCarrier: Boolean;
begin
     mCarrier := mLocal or Com_Carrier;
end;

{
  Empties the input buffers
}
procedure mClearBuf;
begin
     while (KeyPressed) do
           ReadKey;
     if Not(mLocal) then
        Com_PurgeInBuffer;
end;

{
  Close the communications medium
}
procedure mClose;
begin
     Com_Close;
     DropInfo.ComType := 0;
end;

{
  Clears text from the current cursor position to the end of the line
}
procedure mClrEol;
begin
     mWrite(aClrEol);
end;

{
  Clears the entire screen and puts the cursor at (1, 1)
}
procedure mClrScr;
begin
     mWrite(aClrScr);
end;

{
  Moves the cursor to the beginning of the next line
  Shortcut for mWrite(#13#10) or mWriteLn('')
}
procedure mCrlf;
begin
     mWrite(#13#10);
end;

{
  Move the cursor down ACOUNT lines without changing the X position
}
procedure mCursorDown(ACount: Byte);
begin
     mWrite(aCursorDown(ACount));
end;

{
  Move the cursor left ACOUNT columns without changing the Y position
}
procedure mCursorLeft(ACount: Byte);
begin
     mWrite(aCursorLeft(ACount));
end;

{
  Restore the cursor position which was previously saved with mCursorSave
}
procedure mCursorRestore;
begin
     mWrite(aCursorRestore);
end;

{
  Move the cursor right ACOUNT columns without changing the Y position
}
procedure mCursorRight(ACount: Byte);
begin
     mWrite(aCursorRight(ACount));
end;

{
  Save the current cursor position.  Restore it later with mCursorRestore
}
procedure mCursorSave;
begin
     mWrite(aCursorSave);
end;

{
  Move the cursor up ACOUNT lines without changing the X position
}
procedure mCursorUp(ACount: Byte);
begin
     mWrite(aCursorDown(ACount));
end;

{
  Display a TEXT/PIPE/ANSI file on screen
}
procedure mDisplayFile(AFile: String; AMORECheck: Byte);
var
   F: Text;
   I: Integer;
   S: String;
begin
     if (FileExists(AFile)) then
     begin
          Assign(F, AFile);
          {$I-}Reset(F);{$I+}
          if (IOResult = 0) then
          begin
               I := 0;
               while Not(EOF(F)) do
               begin
                    ReadLn(F, S);
                    if (EOF(F)) then
                       mWrite(S)
                    else
                        mWriteLn(S);
                    
                    if (AMORECheck > 0) and (I mod AMORECheck = 0) then
                       mMore;
               end;
               Close(F);
          end;
     end;
end;

{
  mKeyPressed calls this procedure every time it is run.  This is where
  a lot of the "behind the scenes" stuff happens, such as determining how
  much time the user has left, if theyve dropped carrier, and updating the
  status bar.
  It is not recommended that you mess with anything in this procedure
}
procedure mDoEvents;
begin
     if (Session.Events) and (MSecElapsed(Session.EventsTime, MSecToday) > 1000) then
     begin
          {Check For Hangup}
          if Not(mCarrier) and Assigned(mOnHangup) then
             mOnHangup;

          {Check For Idle Timeout}
          if (Session.DoIdleCheck) and (mTimeIdle > Session.MaxIdle) and Assigned(mOnTimeOut) then
             mOnTimeOut;

          {Check For Idle Timeout Warning}
          if (Session.DoIdleCheck) and ((Session.MaxIdle - mTimeIdle) mod 60 = 1) 
          and ((Session.MaxIdle - mTimeIdle) div 60 <= 5) and (Assigned(mOnTimeOutWarning)) then
             mOnTimeOutWarning((Session.MaxIdle - mTimeIdle) div 60);

          {Check For Time Up}
          if (mTimeLeft < 1) and Assigned(mOnTimeUp) then
             mOnTimeUp;

          {Check For Time Up Warning}
          if (mTimeLeft mod 60 = 1) and (mTimeLeft div 60 <= 5) and Assigned(mOnTimeUpWarning) then
             mOnTimeUpWarning(mTimeLeft div 60);

          {Update Status Bar}
          {$IFNDEF UNIX}
          if Assigned(mOnStatusBar) then
             mOnStatusBar;
          {$ENDIF}

          Session.EventsTime := MSecToday;
     end;
end;

{
  Go to column AX on the current line
}
procedure mGotoX(AX: Byte);
begin
     mWrite(aGotoX(AX));
end;

{
  Go to column AX and line AY on the current screen
}
procedure mGotoXY(AX, AY: Byte);
begin
     mWrite(aGotoXY(AX, AY));
end;

{
  Go to line AY on the current column
}
procedure mGotoY(AY: Byte);
begin
     mWrite(aGotoY(AY));
end;

{
  A fancy input routine

  ADefault - The text initially displayed in the edit box
  AChars   - The characters ALLOWED to be part of the string
             Look in MSTRINGS.PAS for some defaults
  APass    - The password character shown instead of the actual text
             Use #0 if you dont want to hide the text
  AShowLen - The number of characters big the edit box should be on screen
  AMaxLen  - The number of characters the edit box should allow
             AMaxLen can be larger than AShowLen, it will just scroll
             if that happens.
  AAttr    - The text attribute of the editbox's text and background
             Use formula Attr = Foreground + (Background * 16)

  If the user pressed ESCAPE then ADefault is returned.  If they hit enter
  the current string is returned.  They cannot hit enter on a blank line.
}
function mInput(ADefault, AChars: String; APass: Char; AShowLen, AMaxLen, AAttr: Byte): String;
var
   Ch: Char;
   S: String;
   SavedAttr: Byte;
   XPos: Byte;

  procedure UpdateText;
  begin
       mGotoX(XPos);
       if (Length(S) > AShowLen) then
       begin
            if (APass = #0) then
               mWrite(Copy(S, Length(S) - AShowLen + 1, AShowLen))
            else
                mWrite(PadRight('', APass, AShowLen));
            mGotoX(XPos + AShowLen);
       end else
       begin
            if (APass = #0) then
               mWrite(S)
            else
                mWrite(PadRight('', APass, Length(S)));
            mWrite(PadRight('', ' ', AShowLen - Length(S)));
            mGotoX(XPos + Length(S));
       end;
  end;

begin
     if (Length(ADefault) > AMaxLen) then
        ADefault := Copy(ADefault, 1, AMaxLen);
     S := ADefault;

     SavedAttr := TextAttr;
     mTextAttr(AAttr);
     XPos := WhereX;

     UpdateText;

     repeat
           Ch := mReadKey;
           if (Ch = #8) and (Length(S) > 0) then
           begin
                Delete(S, Length(S), 1);
                mWrite(#8 + ' ' + #8);
                if (Length(S) >= AShowLen) then
                   UpdateText;
           end else
           if (Ch = #25) and (S <> '') then {CTRL-Y}
           begin
                S := '';
                UpdateText;
           end else
           if (Pos(Ch, AChars) > 0) and (Length(S) < AMaxLen) then
           begin
                S := S + Ch;
                if (Length(S) > AShowLen) then
                   UpdateText
                else
                if (APass = #0) then
                   mWrite(Ch)
                else
                    mWrite(APass);
           end;
     until (Ch = #27) or ((Ch = #13) and (S <> ''));

     mTextAttr(SavedAttr);
     mCrlf;

     if (Ch = #27) then
        S := ADefault;
     mInput := S;
end;

{
  Returns TRUE if a character is waiting to be read
  Also calls DoEvents to make sure the "dirty work" is handled
}
function mKeyPressed: Boolean;
begin
     mDoEvents;

     if (mLocal) then
        mKeypressed := KeyPressed
     else
         mKeyPressed := KeyPressed or Com_CharAvail;
end;

{
  Returns TRUE if the door is being run in local mode
}
function mLocal: Boolean;
begin
     mLocal := DropInfo.ComType = 0;
end;

{
  Displays ALINE and waits for the user to press a key before continuing.
  When the user presses a key it erases ALINE from the screen
}
procedure mMore;
var
  Line: String;
  LineLength: Integer;
begin
     case DropInfo.Emulation of
          etASCII: 
          begin
               Line := MOREPrompts.ASCII;
               LineLength := Length(MOREPrompts.ASCII);
          end;
          etANSI: 
          begin
               Line := MOREPrompts.ANSI;
               LineLength := MOREPrompts.ANSITextLength;
          end;
          else
              Line := '';
              LineLength := 0;
     end;

     mWrite(Line);
     mReadKey;

     mCursorLeft(LineLength);
     mWrite(PadLeft('', ' ', LineLength));
     mCursorLeft(LineLength);
end;

{
  Returns TRUE if it was able to open an existing connection
  mStartUp calls this, so you should never have to directly
}
function mOpen: Boolean;
{$IFDEF WIN32}
var
  WC5User: TWC5User;
{$ENDIF}
begin
     if (DropInfo.ComNum = 0) or (DropInfo.ComType = 0) then
        mOpen := True
     else
     begin
          Com_StartUp(DropInfo.ComType);
          Com_OpenQuick(DropInfo.ComNum);
          mOpen := Com_Carrier;

          {$IFDEF WIN32}
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
function mReadKey: Char;
var
   Ch: Char;
begin
     Ch := #0;
     LastKey.Location := lkNone;
     repeat
           while Not(mKeyPressed) do
                 TimeSlice;
           if (KeyPressed) then
           begin
                Ch := ReadKey;
                if (Ch = #0) then
                begin
                     Ch := ReadKey;
                     {$IFNDEF UNIX}if Not(mLocal) and Assigned(mOnSysopKey) and Not(mOnSysopKey(Ch)) then{$ENDIF}
                     begin
                          LastKey.Extended := True;
                          LastKey.Location := lkLocal;
                     end;
                end else
                begin
                     LastKey.Extended := False;
                     LastKey.Location := lkLocal;
                end;
           end else
           if Not(mLocal) and (Com_CharAvail) then
           begin
                Ch := Com_GetChar;
                LastKey.Extended := False;
                LastKey.Location := lkRemote;
           end;
     until (LastKey.Location <> lkNone);
     LastKey.Ch := Ch;
     LastKey.Time := SecToday;

     mReadKey := Ch;
end;

{
  This is the first call your door should make before making any other call
  to procedures in this unit.  It will parse the command line and take
  action depending on the parameters it receives.
  If a dropfile is to be read, it will happen automatically.
  If the program is not being run in local mode, the existing connection
  to the remote user will be opened.
}
procedure mStartUp;
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
          if (FileExists(DropFile)) and (ciPos('DOOR.SYS', DropFile) > 0) then
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

          {$IFDEF UNIX}
          DropInfo.ComNum := 1;
          DropInfo.ComType := 1;
          {$ENDIF}
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
     end;
end;

{
  Change the current text foreground and background to AAttr
  Formula: Attr = Foreground + (Background * 16)
}
procedure mTextAttr(AAttr: Byte);
begin
     mWrite(aTextAttr(AAttr));
end;

{
  Change the current text colour to AColour
}
procedure mTextBackground(AColour: Byte);
begin
     mWrite(aTextBackground(AColour));
end;

{
  Change the current text background to AColour
}
procedure mTextColor(AColour: Byte);
begin
     mWrite(aTextColor(AColour));
end;

{
  Returns the number of seconds the user has been idle
}
function mTimeIdle: LongInt;
begin
     mTimeIdle := SecElapsed(LastKey.Time, SecToday);
end;

{
  Returns the number of seconds the user has left this session
}
function mTimeLeft: LongInt;
begin
     mTimeLeft := DropInfo.MaxTime - SecElapsed(Session.TimeOn, SecToday);
end;

{
  Writes a line of text to the screen
}
procedure mWrite(ALine: String);
var
   NumWritten: LongInt;
begin
     if (Pos('`', ALine) > 0) then
        ALine := SethToPipe(ALine);
     if (Pos('|', ALine) > 0) then
        ALine := PipeToAnsi(ALine);

     aWrite(ALine);
     if Not(mLocal) then
        Com_SendBlock(ALine[1], Length(ALine), NumWritten);
end;

{
  Writes a line of text to the screen, folled by a CR/LF
}
procedure mWriteLn(ALine: String);
begin
     mWrite(ALine + #13#10);
end;

{
  Custom exit proc to ensure mShutdown is called
}
procedure NewExitProc;
begin
     ExitProc := OldExitProc;

     mTextAttr(7);
     mCursorDown(255);
     mCursorLeft(255);

     if Not(mLocal) then
        Com_ShutDown;
end;

{
  Default action to take when user drops carrier
}
procedure OnHangup;
begin
     TextAttr := 15;
     ClrScr;
     WriteLn;
     WriteLn('   Caller Dropped Carrier.  Returning To BBS...');
     Delay(1500);
     Halt;
end;

{
  Default action to take when /L is used on the command-line
}
procedure OnLocalLogin;
var
   S: String;
begin
     ClrScr;
     WriteLn;
     WriteLn('  LOCAL LOGIN');
     WriteLn;
     Write('  Enter your name : ');
     S := mInput('SYSOP', CHARS_ALPHA + ' ', #0, 40, 40, 31);
     DropInfo.RealName := S;
     DropInfo.Alias := S;
end;

{
  Default status bar displays
}
procedure OnStatusBar;
begin
     FastWrite('þ                           þ                   þ             þ                þ', 1, 25, 30);
     FastWrite(PadRight(DropInfo.RealName, ' ', 22), 3, 25, 31);
     FastWrite(ProgVer, 31, 25, 31);
     FastWrite(PadRight('Idle: ' + SecToMS(SecElapsed(LastKey.Time, SecToday)), ' ', 11), 51, 25, 31);
     FastWrite('Left: ' + SecToHMS(mTimeLeft), 65, 25, 31);
end;

{
  Default action to take when the user idles too long
}
procedure OnTimeOut;
begin
     mTextAttr(15);
     mClrScr;
     mCrlf;
     mWriteLn('  Idle Time Limit Exceeded.  Returning To BBS...');
     Delay(1500);
     Halt;
end;

{
  Default action to take when the user runs out of time
}
procedure OnTimeUp;
begin
     mTextAttr(15);
     mClrScr;
     mCrlf;
     mWriteLn('  Your Time Has Expired.  Returning To BBS...');
     Delay(1500);
     Halt;
end;

{
  Default command-line help screen
}
procedure OnUsage;
begin
     ClrScr;
     WriteLn;
     WriteLn(' USAGE:');
     WriteLn;
     WriteLn(' ' + ExtractFileName(ParamStr(0)) + ' <PARAMETERS>');
     WriteLn;
     WriteLn('  -D         PATH\FILENAME OF DROPFILE');
     WriteLn('  -H         COM PORT (OR SOCKET HANDLE IF -T USED)');
     WriteLn('  -L         LOCAL MODE');
     WriteLn('  -N         NODE NUMBER');
     WriteLn('  -T         -H PARAMETER IS A SOCKET HANDLE');
     WriteLn('  -W         WINSERVER DOOR32 MODE');
     WriteLn;
     WriteLn(' Examples:');
     WriteLn;
     WriteLn(' ' + ExtractFileName(ParamStr(0)) + ' -L');
     WriteLn('  -  Run In Local Mode');
     WriteLn(' ' + ExtractFileName(ParamStr(0)) + ' -H1000 -N3 -T');
     WriteLn('  -  Open Socket Handle 1000 On Node #3');
     WriteLn(' ' + ExtractFileName(ParamStr(0)) + ' -DC:\GAMESRV\NODE1\DOOR32.SYS');
     WriteLn('  -  Load Settings From DOOR32.SYS');
     WriteLn(' ' + ExtractFileName(ParamStr(0)) + ' -W');
     WriteLn('     Run As A WINServer Native Door');
     Halt;
end;

{
  Read the DOOR32.SYS file AFILE
}
procedure ReadDoor32(AFile: String);
var
   F: Text;
   S: String;
begin
     if (FileExists(AFile)) then
     begin
          Assign(F, AFile);
          {$I-}Reset(F);{$I+}
          if (IOResult = 0) then
          begin          
               ReadLn(F, S); {1 - Comm Type (0=Local, 1=Serial, 2=Telnet)}
               DropInfo.ComType := StrToIntDef(S, 0);

               ReadLn(F, S); {2 - Comm Or Socket Handle}
               DropInfo.ComNum := StrToIntDef(S, -1);

               ReadLn(F, S); {3 - Baud Rate}
               DropInfo.Baud := StrToIntDef(S, 38400);

               ReadLn(F, S); {4 - BBSID (Software Name & Version}

               ReadLn(F, S); {5 - User's Record Position (1 Based)}
               DropInfo.RecPos := StrToIntDef(S, 1) - 1;

               ReadLn(F, S); {6 - User's Real Name}
               DropInfo.RealName := S;

               ReadLn(F, S); {7 - User's Handle/Alias}
               DropInfo.Alias := S;

               ReadLn(F, S); {8 - User's Access Level}
               DropInfo.Access := StrToIntDef(S, 0);

               ReadLn(F, S); {9 - User's Time Left (In Minutes)}
               DropInfo.MaxTime := StrToIntDef(S, 0) * 60;

               ReadLn(F, S); {10 - Emulation (0=Ascii, 1=Ansi, 2=Avatar, 3=RIP, 4=MaxGfx)}
               if (StrToIntDef(S, 1) = 0) then
                  DropInfo.Emulation := etASCII
               else
                   DropInfo.Emulation := etANSI;

               ReadLn(F, S); {11 - Current Node Number}
               DropInfo.Node := StrToIntDef(S, 0);

               Close(F);
          end;
     end;
end;

{
  Read the DOOR.SYS file AFILE
}
procedure ReadDoorSys(AFile: String);
var
   F: Text;
   S: String;
begin
     if (FileExists(AFile)) then
     begin
          Assign(F, AFile);
          {$I-}Reset(F);{$I+}
          if (IOResult = 0) then
          begin
               ReadLn(F, S); {1 - Comm Or Socket Handle}
               DropInfo.ComNum := StrToIntDef(Copy(S, 4, Length(S) - 4), 0);
               if (DropInfo.ComNum > 0) then
                  DropInfo.ComType := 1;

               ReadLn(F, S); {2 - Line Speed}

               ReadLn(F, S); {3 - Data Bits}

               ReadLn(F, S); {4 - Current Node Number}
               DropInfo.Node := StrToIntDef(S, 0);

               ReadLn(F, S); {5 - Modem Speed}
               DropInfo.Baud := StrToIntDef(S, 38400);

               ReadLn(F, S); {6 - Screen Display}

               ReadLn(F, S); {7 - Syslog Printer}

               ReadLn(F, S); {8 - Page Bell}

               ReadLn(F, S); {9 - Caller Alarm}

               ReadLn(F, S); {10 - User's Real Name}
               DropInfo.RealName := S;

               ReadLn(F, S); {11 - City, State}

               ReadLn(F, S); {12 - Phone Number}

               ReadLn(F, S); {13 - Data Phone Number}

               ReadLn(F, S); {14 - Password}

               ReadLn(F, S); {15 - User's Access Level}
               DropInfo.Access := StrToIntDef(S, 0);

               ReadLn(F, S); {16 - Number Of Logons}

               ReadLn(F, S); {17 - Date Last Logged On}

               ReadLn(F, S); {18 - User's Time Left (In Seconds)}
               DropInfo.MaxTime := StrToIntDef(S, 0);

               ReadLn(F, S); {19 - User's Time Left (In Minutes)}

               ReadLn(F, S); {20 - Emulation (GR=Ansi, NG=Ascii, 7E=7-Bit)}
               if (UpperCase(S) = 'GR') then
                  DropInfo.Emulation := etANSI
               else
                   DropInfo.Emulation := etASCII;

               ReadLn(F, S); {21 - Lines On Screen}

               ReadLn(F, S); {22 - Menu Status}

               ReadLn(F, S); {23 - Conferences}

               ReadLn(F, S); {24 - Current Conference}

               ReadLn(F, S); {25 - Expiration Date}

               ReadLn(F, S); {26 - User's Record Position (1 Based)}
               DropInfo.RecPos := StrToIntDef(S, 1) - 1;

               ReadLn(F, S); {27 - Default Protocol}

               ReadLn(F, S); {28 - kB Uploaded}

               ReadLn(F, S); {29 - kB Downloaded}

               ReadLn(F, S); {30 - Downloaded Today}

               ReadLn(F, S); {31 - Maximum Downloaded Today}

               ReadLn(F, S); {32 - User's Birthday}

               ReadLn(F, S); {33 - BBS Data Directory}

               ReadLn(F, S); {34 - BBS Text Files Directory}

               ReadLn(F, S); {35 - SysOp Name}

               ReadLn(F, S); {36 - User's Handle/Alias}
               DropInfo.Alias := S;

               ReadLn(F, S); {37 - Event Time}

               ReadLn(F, S); {38 - Dont Know}

               ReadLn(F, S); {39 - Ansi Ok But Disable Graphics}

               ReadLn(F, S); {40 - Record Locking}

               ReadLn(F, S); {41 - Base Text Colour}

               ReadLn(F, S); {42 - Time In Time Bank}

               ReadLn(F, S); {43 - Last New Message Scan Date}

               ReadLn(F, S); {44 - Dont Know}

               ReadLn(F, S); {45 - Time Last Call}

               ReadLn(F, S); {46 - Max Files Downloaded Per Day}

               ReadLn(F, S); {47 - Number Of Files Downloaded Today}

               ReadLn(F, S); {48 - kB Uploaded}

               ReadLn(F, S); {49 - kB Downloaded}

               ReadLn(F, S); {50 - User Note}

               ReadLn(F, S); {51 - Number Of Doors Run}

               ReadLn(F, S); {52 - Number Of Messages Posted}

               Close(F);
          end;
     end;
end;

{
  Read the DORINFO*.DEF file AFILE
}
procedure ReadDorinfo(AFile: String);
var
   F: Text;
   S: String;
begin
     if (FileExists(AFile)) then
     begin
          Assign(F, AFile);
          {$I-}Reset(F);{$I+}
          if (IOResult = 0) then
          begin
               ReadLn(F, S); {1 - BBS Name}

               ReadLn(F, S); {2 - Sysop's First Name}

               ReadLn(F, S); {3 - Sysop's Last Name}

               ReadLn(F, S); {4 - Comm Number in COMxxx Form}
               DropInfo.ComNum := StrToIntDef(Copy(S, 4, Length(S) - 3), 0);
               if (DropInfo.ComNum > 0) then
                  DropInfo.ComType := 1;

               ReadLn(F, S); {5 - Baud Rate in 57600 BAUD,N,8,1 Form}
               DropInfo.Baud := StrToIntDef(Copy(S, 1, Pos(' ', S) - 1), 38400);

               ReadLn(F, S); {6 - Networked?}

               ReadLn(F, S); {7 - User's First Name / Alias}
               DropInfo.Alias := S;

               ReadLn(F, S); {8 - User's Last Name}
               if (S = '') then
                  DropInfo.RealName := DropInfo.Alias
               else
                   DropInfo.RealName := DropInfo.Alias + ' ' + S;

               ReadLn(F, S); {9 - User's Location (City, State, etc.)}

               ReadLn(F, S); {10 - User's Emulation (1=Ansi)}
               if (StrToIntDef(S, 1) = 1) then
                  DropInfo.Emulation := etANSI
               else
                   DropInfo.Emulation := etASCII;

               ReadLn(F, S); {11 - User's Access Level}
               DropInfo.Access := StrToIntDef(S, 0);

               ReadLn(F, S); {12 - User's Time Left (In Minutes)}
               DropInfo.MaxTime := StrToIntDef(S, 0) * 60;

               ReadLn(F, S); {13 - Fossil?}

               Close(F);
          end;
     end;
end;

{
  Read the INFO.* file AFILE
}
procedure ReadInfo(AFile: String);
var
   F: Text;
   S: String;
begin
     if (FileExists(AFile)) then
     begin
          Assign(F, AFile);
          {$I-}Reset(F);{$I+}
          if (IOResult = 0) then
          begin
               ReadLn(F, S); {1 - Account Number (0 Based)}
               DropInfo.RecPos := StrToIntDef(S, 0);

               ReadLn(F, S); {2 - Emulation (3=Ansi, Other = Ascii)}
               if (StrToIntDef(S, 3) = 3) then
                  DropInfo.Emulation := etANSI
               else
                   DropInfo.Emulation := etASCII;

               ReadLn(F, S); {3 - RIP YES or RIP NO}

               ReadLn(F, S); {4 - FAIRY YES or FAIRY NO}
               if (UpperCase(S) = 'FAIRY YES') then
                  DropInfo.Fairy := True
               else
                   DropInfo.Fairy := False;

               ReadLn(F, S); {5 - User's Time Left (In Minutes)}
               DropInfo.MaxTime := StrToIntDef(S, 0) * 60;

               ReadLn(F, S); {6 - User's Handle/Alias}
               DropInfo.Alias := S;

               ReadLn(F, S); {7 - User's First Name}
               DropInfo.RealName := S;

               ReadLn(F, S); {8 - User's Last Name}
               if (S <> '') then
                  DropInfo.RealName := DropInfo.RealName + ' ' + S;

               ReadLn(F, S); {9 - Comm Port}
               DropInfo.ComNum := StrToIntDef(S, 0);

               ReadLn(F, S); {10 - Caller Baud Rate}
               DropInfo.Baud := StrToIntDef(S, 38400);

               ReadLn(F, S); {11 - Port Baud Rate}

               ReadLn(F, S); {12 - FOSSIL or INTERNAL}
               if (UpperCase(S) = 'LOCAL') then
                  DropInfo.ComType := 0
               else
               if (UpperCase(S) = 'TELNET') then
                  DropInfo.ComType := 2
               else
               if (UpperCase(S) = 'WC5') then
                  DropInfo.ComType := 3
               else
                   DropInfo.ComType := 1;

               ReadLn(F, S); {13 - REGISTERED or UNREGISTERED}
               if (UpperCase(S) = 'REGISTERED') then
                  DropInfo.Registered := True
               else
                   DropInfo.Registered := False;

               ReadLn(F, S); {14 - CLEAN MODE ON or CLEAN MODE OFF}
               if (UpperCase(S) = 'CLEAN MODE ON') then
                  DropInfo.Clean := True
               else
                   DropInfo.Clean := False;

               Close(F);
          end;
     end;
end;

{
  Program initialization
  You should leave this section alone and override the settings in your
  own program files
}
begin
     OldExitProc := ExitProc;
     ExitProc := @NewExitProc;

     mOnCLP := nil;
     mOnHangup := @OnHangup;
     mOnLocalLogin := @OnLocalLogin;
     mOnStatusBar := @OnStatusBar;
     mOnSysopKey := nil;
     mOnTimeOut := @OnTimeOut;
     mOnTimeOutWarning := nil;
     mOnTimeUp := @OnTimeUp;
     mOnTimeUpWarning := nil;
     mOnUsage := @OnUsage;

     with DropInfo do
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

     with LastKey do
     begin
          Ch := #0;
          Extended := False;
          Location := lkNone;
          Time := 0;
     end;

     with MOREPrompts do
     begin
       ASCII := ' <MORE>';
       ANSI := ' |0A<|02MORE|0A>';
       ANSITextLength := 7;
     end;
     
     with Session do
     begin
          DoIdleCheck := True;
          Events := False;
          EventsTime := 0;
          MaxIdle := 300;
          TimeOn := 0;
     end;

     {$IFDEF UNIX}WriteLn(#27 + '(U');{$ENDIF}
end.
