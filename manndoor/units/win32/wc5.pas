unit WC5;

interface

uses
  Windows;

const NUM_USER_SECURITY = 10;
const SIZE_LANGUAGE_NAME = 12;
const SIZE_PASSWORD = 32;
const SIZE_SECURITY_NAME = 24;
const SIZE_USER_ADDRESS = 32;
const SIZE_USER_FROM = 32;
const SIZE_USER_NAME = 72;
const SIZE_USER_PHONE = 16;
const SIZE_USER_STATE = 16;
const SIZE_USER_TITLE = 12;
const SIZE_USER_ZIP = 12;

type TUserInfo = record
  Id: Dword;
  Name: array [0..SIZE_USER_NAME-1] of char;
  Title: array [0..SIZE_USER_TITLE-1] of char;
end;

type TWC5User = record
  Status: Dword;
  Info: TUserInfo;
  From: array [0..SIZE_USER_FROM-1] of char;
  Password: array [0..SIZE_PASSWORD-1] of char;
  Security: array [0..NUM_USER_SECURITY-1, 0..SIZE_SECURITY_NAME-1] of Char;
  Reserved1: Dword;
  AllowMultipleLogins: LongBool;
  Reserved2: LongBool;
  RealName: array [0..SIZE_USER_NAME-1] of char;
  PhoneNumber: array [0..SIZE_USER_PHONE-1] of char;
  Company: array [0..SIZE_USER_ADDRESS-1] of char;
  Address1: array [0..SIZE_USER_ADDRESS-1] of char;
  Address2: array [0..SIZE_USER_ADDRESS-1] of char;
  City: array [0..SIZE_USER_ADDRESS-1] of char;
  State: array [0..SIZE_USER_STATE-1] of char;
  Zip: array [0..SIZE_USER_ZIP-1] of char;
  Country: array [0..SIZE_USER_ADDRESS-1] of char;
  Sex: Dword;
  Editor: Dword;
  HelpLevel: Dword;
  Protocol: Dword;
  TerminalType: Dword;
  FileDisplay: Dword;
  MsgDisplay: Dword;
  PacketType: Dword;
  LinesPerPage: Dword;
  HotKeys: LongBool;
  QuoteOnReply: LongBool;
  SortedListings: LongBool;
  PageAvailable: LongBool;
  EraseMorePrompt: LongBool;
  Reserved3: LongBool;
  Language: array [0..SIZE_LANGUAGE_NAME-1] of char;
  LastCall: TFileTime;
  LastNewFiles: TFileTime;
  ExpireDate: TFileTime;
  FirstCall: TFileTime;
  BirthDate: TFileTime;
  Conference: Dword;
  MsgsWritten: Dword;
  Uploads: Dword;
  TotalUploadKbytes: Dword;
  Downloads: Dword;
  TotalDownloadKbytes: Dword;
  DownloadCountToday: Dword;
  DownloadKbytesToday: Dword;
  TimesOn: Dword;
  TimeLeftToday: Dword;
  MinutesLogged: Dword;
  SubscriptionBalance: Longint;
  NetmailBalance: Longint;
  AccountLockedOut: LongBool;
  PreserveMimeMessages: LongBool;
  ShowEmailHeaders: LongBool;
  LastUpdate: TFileTime;
  Reserved: array [0..28-1] of Byte;
end;

{$IFDEF VPASCAL}{&StdCall+}{$ENDIF}
type
  TWildcatLoggedIn = function(var WC5User: TWC5User): DWord; {$IFNDEF VPASCAL}stdcall;{$ENDIF}
  TGetNode = function: DWord; {$IFNDEF VPASCAL}stdcall;{$ENDIF}
{$IFDEF VPASCAL}{&StdCall-}{$ENDIF}

function InitWC5: Boolean;
procedure DeInitWC5;

var
  WC5_WildcatLoggedIn: TWildcatLoggedIn;
  WC5_GetNode: TGetNode;

implementation

var
  FWCSRV: THandle;

function InitWC5: Boolean;
begin
     InitWC5 := False;

     FWCSRV := LoadLibrary('WCSRV.DLL');
     if (FWCSRV <> 0) then
     begin
          InitWC5 := True;
          @WC5_WildcatLoggedIn := GetProcAddress(FWCSRV, 'WildcatLoggedIn');
          @WC5_GetNode := GetProcAddress(FWCSRV, 'GetNode');
     end;
end;

procedure DeInitWC5;
begin
     FreeLibrary(FWCSRV);
end;

end.
