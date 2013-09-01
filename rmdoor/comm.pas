unit Comm;

{$mode objfpc}{$h+}

interface

uses
  {$IFDEF UNIX}
  BaseUnix,
  {$ENDIF}
  {$IFDEF WINDOWS}
  Winsock,
  {$ENDIF}
  Classes, Sockets, SysUtils;

function CommCarrier: Boolean;
function CommCharAvail: Boolean;
procedure CommClose(ADisconnect: Boolean);
procedure CommOpen(ACommNumber: LongInt);
function CommReadChar: Char;
procedure CommWrite(AText: String);

implementation

var
  FBuffer: String = '';
  FCarrier: Boolean = true;
  FCommNumber: Integer = -1;

procedure CommWriteRaw(AText: String); forward;
procedure ReceiveData; forward;

function CommCarrier: Boolean;
begin
  // TODO DOS should check the FOSSIL to assign FCarrier
  Result := FCarrier;
end;

function CommCharAvail: Boolean;
begin
  if (Length(FBuffer) = 0) then ReceiveData;
  Result := Length(FBuffer) > 0;
end;

procedure CommClose(ADisconnect: Boolean);
begin
  if (ADisconnect) then fpShutdown(FCommNumber, 2);
  {$IFDEF UNIX}
  fpClose(FCommNumber);
  {$ENDIF}
  {$IFDEF WINDOWS}
  CloseSocket(FCommNumber);
  {$ENDIF}
end;

procedure CommOpen(ACommNumber: LongInt);
var
  Arg: Integer;
  {$IFDEF WINDOWS}
  WSAData: TWSAData;
  {$ENDIF}
begin
  FCommNumber := ACommNumber;

  {$IFDEF UNIX}
  // Set blocking mode
  Arg := fpFcntl(FCommNumber, F_GETFL);
  Arg := Arg AND NOT(O_NONBLOCK);
  fpFcntl(FCommNumber, F_SETFL, Arg);
  {$ENDIF}
  {$IFDEF WIN32}
  // Set blocking mode
  Arg := 0;
  IOCtlSocket(FCommNumber, FIONBIO, Arg);
  {$ENDIF}

  // TODO For socket communications, send will binary and will echo
  CommWriteRaw(#255#251#0); // Will binary
  CommWriteRaw(#255#251#1); // Will echo
end;

function CommReadChar: Char;
begin
  while (Length(FBuffer) = 0) do
  begin
    Sleep(1);
    ReceiveData;
  end;

  Result := FBuffer[1];
  Delete(FBuffer, 1, 1);
end;

procedure CommWrite(AText: String);
begin
  // TODO Probably a better way to do this, works for now
  // TODO Also, only for Telnet mode
  CommWriteRaw(StringReplace(AText, #255, #255#255, [rfReplaceAll]));
end;

procedure CommWriteRaw(AText: String);
begin
  fpSend(FCommNumber, @AText[1], Length(AText), 0);
end;

procedure ReceiveData;
var
  CanRead: Boolean;
  NumRead: Integer;
  ReadArray: Array[1..255] of Char;
  FDSet: TFDSet;
  Timeout: TTimeVal;
begin
  Timeout.tv_sec := 0;
  Timeout.tv_usec := 0;

  {$IFDEF UNIX}
  fpFD_ZERO(FDSet);
  fpFD_SET(FCommNumber, FDSet);
  CanRead := (fpSelect(FCommNumber + 1, @FDSet, nil, nil, @Timeout) > 0);
  {$ENDIF}
  {$IFDEF WIN32}
  FD_ZERO(FDSet);
  FD_SET(FCommNumber, FDSet);
  CanRead := (Select(0, @FDSet, nil, nil, @Timeout) > 0);
  {$ENDIF}

  if (CanRead) then
  begin
    {$IFDEF UNIX}
    NumRead := fpRecv(FCommNumber, @ReadArray, SizeOf(ReadArray), 0);
    {$ENDIF}
    {$IFDEF WINDOWS}
    NumRead := fpRecv(FCommNumber, @ReadArray, SizeOf(ReadArray), 0);
    {$ENDIF}
    if (NumRead = -1) then
    begin
      FCarrier := false;
      // TODO Get error
    end else
    if (NumRead = 0) then
    begin
      FCarrier := false;
    end else
    begin
      FBuffer := ReadArray;
      SetLength(FBuffer, NumRead);

      // TODO Probably a better way to do this, works for now
      FBuffer := StringReplace(FBuffer, #13#10, #13, [rfReplaceAll]);
      FBuffer := StringReplace(FBuffer, #13#0, #13, [rfReplaceAll]);
      FBuffer := StringReplace(FBuffer, #10, #13, [rfReplaceAll]);
    end;
  end;
end;

end.

