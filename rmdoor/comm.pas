unit Comm;

{$mode objfpc}

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
  {$IFDEF UNIX}
  fpSend(FCommNumber, @AText[1], Length(AText), 0);
  {$ENDIF}
  {$IFDEF WINDOWS}
  fpSend(FCommNumber, @AText[1], Length(AText), 0);
  {$ENDIF}
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
    end;
  end;
end;

end.

