unit W32sock;
{&Orgname+}
(*
**
** WINDOWS TCP/IP routines
**
** Copyright (c) 1998 by Thomas W. Mueller
**
** Created : 24-Oct-1998
** Last update : 20-Feb-2000
**
**
*)

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)
 INTERFACE
(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

uses
  Windows,
  SockDef;

type
  u_char = Char;
  u_short = Word;
  u_int = Integer;
  u_long = Longint;

{$IFDEF FPC}
  type pInteger = ^Integer;
{$ENDIF}


{ Socket function prototypes }

function accept(_s: ULONG; _addr: pSockAddr; _addrlen: PInteger): ULONG;                                  stdcall;
function bind(_s: ULONG; _addr: pSockAddr; _namelen: Integer): Integer;                                   stdcall;
function connect(_s: ULONG; _name: pSockAddr; _namelen: Integer): Integer;                                stdcall;
function closesocket(s: ULONG): Integer;                                                                  stdcall;
function select(nfds: Integer; readfds, writefds, exceptfds: PFDSet;
  timeout: PTimeVal): Longint;                                                                            stdcall;
function ioctlsocket(_s: ULONG; _cmd: Longint; var _arg: ULONG): Integer;                                 stdcall;
function getpeername(_s: ULONG; _name: pSockAddr; var _namelen: Integer): Integer;                        stdcall;
function getsockname(_s: ULONG; _name: pSockAddr; var _namelen: Integer): Integer;                        stdcall;
function getsockopt(_s: ULONG; _level, _optname: Integer; _optval: PChar; var _optlen: Integer): Integer; stdcall;
function htonl(_hostlong: ULONG): ULONG;                                                                  stdcall;
function htons(_hostshort: Integer): Integer;                                                             stdcall;
function inet_addr(_cp: PChar): ULONG;                                                                    stdcall;
function inet_ntoa(_inaddr: tIn_Addr): PChar;                                                             stdcall;
function listen(_s: ULONG; _backlog: Integer): Integer;                                                   stdcall;
function ntohl(_netlong: ULONG): ULONG;                                                                   stdcall;
function ntohs(_netshort: Integer): Integer;                                                              stdcall;
function recv(_s: ULONG; _Buf: pointer; _len, _flags: Integer): Integer;                                  stdcall;

function recvfrom(s: ULONG; _Buf: pointer; _len, _flags: Integer;
                  var _from: TSockAddr; var _fromlen: Integer): Integer;                                  stdcall;
function send(_s: ULONG; _Buf: pointer; _len, _flags: Integer): Integer;                                  stdcall;
function sendto(_s: ULONG; _Buf: pointer; _len, _flags: Integer; var _addrto: TSockAddr;
                _tolen: Integer): Integer;                                                                stdcall;
function setsockopt(_s: ULONG; _level, _optname: Integer; _optval: PChar;
                    _optlen: Integer): Integer;                                                           stdcall;
function shutdown(_s: ULONG; _how: Integer): Integer;                                                     stdcall;
function socket(_af, _struct, _protocol: Integer): ULONG;                                                 stdcall;

function gethostbyaddr(_addr: Pointer; _len, _struct: Integer): PHostEnt;                                 stdcall;
function gethostbyname(_name: PChar): PHostEnt;                                                           stdcall;
function gethostname(_name: PChar; _len: Integer): Integer;                                               stdcall;
function getservbyport(_port: Integer; _proto: PChar): PServEnt;                                          stdcall;
function getservbyname(_name, _proto: PChar): PServEnt;                                                   stdcall;
function getprotobynumber(_proto: Integer): PProtoEnt;                                                    stdcall;
function getprotobyname(_name: PChar): PProtoEnt;                                                         stdcall;

function WSAStartup(wVersionRequired: word; var WSData: TWSAData): Integer;               stdcall;
function WSACleanup: Integer;                                                             stdcall;
procedure WSASetLastError(iError: Integer);                                               stdcall;
function WSAGetLastError: Integer;                                                        stdcall;
function WSAIsBlocking: BOOL;                                                             stdcall;
function WSAUnhookBlockingHook: Integer;                                                  stdcall;
function WSASetBlockingHook(lpBlockFunc: TFarProc): TFarProc;                             stdcall;
function WSACancelBlockingCall: Integer;                                                  stdcall;
function WSAAsyncGetServByName(HWindow: HWND; wMsg: u_int;
  name, proto, buf: PChar; buflen: Integer): THandle;                                     stdcall;
function WSAAsyncGetServByPort( HWindow: HWND; wMsg, port: u_int;
  proto, buf: PChar; buflen: Integer): THandle;                                           stdcall;
function WSAAsyncGetProtoByName(HWindow: HWND; wMsg: u_int;
  name, buf: PChar; buflen: Integer): THandle;                                            stdcall;
function WSAAsyncGetProtoByNumber(HWindow: HWND; wMsg: u_int; number: Integer;
  buf: PChar; buflen: Integer): THandle;                                                  stdcall;
function WSAAsyncGetHostByName(HWindow: HWND; wMsg: u_int;
  name, buf: PChar; buflen: Integer): THandle;                                            stdcall;
function WSAAsyncGetHostByAddr(HWindow: HWND; wMsg: u_int; addr: PChar;
  len, struct: Integer; buf: PChar; buflen: Integer): THandle;                            stdcall;
function WSACancelAsyncRequest(hAsyncTaskHandle: THandle): Integer;                       stdcall;
function WSAAsyncSelect(s: ULONG; HWindow: HWND; wMsg: u_int; lEvent: Longint): Integer;  stdcall;
function WSARecvEx(s: ULONG; var buf; len: Integer; var flags: Integer): Integer;         stdcall;

function WSAMakeSyncReply(Buflen, Error: Word): Longint;
function WSAMakeSelectReply(Event, Error: Word): Longint;
function WSAGetAsyncBuflen(Param: Longint): Word;
function WSAGetAsyncError(Param: Longint): Word;
function WSAGetSelectEvent(Param: Longint): Word;
function WSAGetSelectError(Param: Longint): Word;

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)
 IMPLEMENTATION
(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

const
  winsocket = 'wsock32.dll';

function WSAMakeSyncReply(Buflen, Error: Word): Longint;
begin
  WSAMakeSyncReply:= MakeLong(Buflen, Error);
end;

function WSAMakeSelectReply(Event, Error: Word): Longint;
begin
  WSAMakeSelectReply:= MakeLong(Event, Error);
end;

function WSAGetAsyncBuflen(Param: Longint): Word;
begin
  WSAGetAsyncBuflen:= LOWORD(Param);
end;

function WSAGetAsyncError(Param: Longint): Word;
begin
  WSAGetAsyncError:= HIWORD(Param);
end;

function WSAGetSelectEvent(Param: Longint): Word;
begin
  WSAGetSelectEvent:= LOWORD(Param);
end;

function WSAGetSelectError(Param: Longint): Word;
begin
  WSAGetSelectError:= HIWORD(Param);
end;

function accept(_s: ULONG; _addr: pSockAddr; _addrlen: PInteger): ULONG;                                    external    winsocket name 'accept';
function bind(_s: ULONG; _addr: pSockAddr; _namelen: Integer): Integer;                                     external    winsocket name 'bind';
function connect(_s: ULONG; _name: pSockAddr; _namelen: Integer): Integer;                                  external    winsocket name 'connect';
function closesocket(s: ULONG): Integer;                                                                    external    winsocket name 'closesocket';
function select(nfds: Integer; readfds, writefds, exceptfds: PFDSet;
  timeout: PTimeVal): Longint;                                                                              external    winsocket name 'select';
function ioctlsocket(_s: ULONG; _cmd: Longint; var _arg: ULONG): Integer;                                   external    winsocket name 'ioctlsocket';
function getpeername(_s: ULONG; _name: pSockAddr; var _namelen: Integer): Integer;                          external    winsocket name 'getpeername';
function getsockname(_s: ULONG; _name: pSockAddr; var _namelen: Integer): Integer;                          external    winsocket name 'getsockname';
function getsockopt(_s: ULONG; _level, _optname: Integer; _optval: PChar; var _optlen: Integer): Integer;   external    winsocket name 'getsockopt';
function htonl(_hostlong: ULONG): ULONG;                                                                    external    winsocket name 'htonl';
function htons(_hostshort: Integer): Integer;                                                               external    winsocket name 'htons';
function inet_addr(_cp: PChar): ULONG;                                                                      external    winsocket name 'inet_addr';
function inet_ntoa(_inaddr: tIn_Addr): PChar;                                                               external    winsocket name 'inet_ntoa';
function listen(_s: ULONG; _backlog: Integer): Integer;                                                     external    winsocket name 'listen';
function ntohl(_netlong: ULONG): ULONG;                                                                     external    winsocket name 'ntohl';
function ntohs(_netshort: Integer): Integer;                                                                external    winsocket name 'ntohs';
function recv(_s: ULONG; _Buf: pointer; _len, _flags: Integer): Integer;                                    external    winsocket name 'recv';


function recvfrom(s: ULONG; _Buf: pointer; _len, _flags: Integer;
                  var _from: TSockAddr; var _fromlen: Integer): Integer;                                    external    winsocket name 'recvfrom';
function send(_s: ULONG; _Buf: pointer; _len, _flags: Integer): Integer;                                    external    winsocket name 'send';
function sendto(_s: ULONG; _Buf: pointer; _len, _flags: Integer; var _addrto: TSockAddr;
                _tolen: Integer): Integer;                                                                  external    winsocket name 'sendto';
function setsockopt(_s: ULONG; _level, _optname: Integer; _optval: PChar;
                    _optlen: Integer): Integer;                                                             external    winsocket name 'setsockopt';
function shutdown(_s: ULONG; _how: Integer): Integer;                                                       external    winsocket name 'shutdown';
function socket(_af, _struct, _protocol: Integer): ULONG;                                                   external    winsocket name 'socket';


function gethostbyaddr(_addr: Pointer; _len, _struct: Integer): PHostEnt;                                 external    winsocket name 'gethostbyaddr';
function gethostbyname(_name: PChar): PHostEnt;                                                           external    winsocket name 'gethostbyname';
function gethostname(_name: PChar; _len: Integer): Integer;                                               external    winsocket name 'gethostname';
function getservbyport(_port: Integer; _proto: PChar): PServEnt;                                          external    winsocket name 'getservbyport';
function getservbyname(_name, _proto: PChar): PServEnt;                                                   external    winsocket name 'getservbyname';
function getprotobynumber(_proto: Integer): PProtoEnt;                                                    external    winsocket name 'getprotobynumber';
function getprotobyname(_name: PChar): PProtoEnt;                                                         external    winsocket name 'getprotobyname';


function WSAStartup(wVersionRequired: word; var WSData: TWSAData): Integer;                external   winsocket name 'WSAStartup';
function WSACleanup: Integer;                                                              external   winsocket name 'WSACleanup';
procedure WSASetLastError(iError: Integer);                                                external   winsocket name 'WSASetLastError';
function WSAGetLastError: Integer;                                                         external   winsocket name 'WSAGetLastError';
function WSAIsBlocking: BOOL;                                                              external   winsocket name 'WSAIsBlocking';
function WSAUnhookBlockingHook: Integer;                                                   external   winsocket name 'WSAUnhookBlockingHook';
function WSASetBlockingHook(lpBlockFunc: TFarProc): TFarProc;                              external   winsocket name 'WSASetBlockingHook';
function WSACancelBlockingCall: Integer;                                                   external   winsocket name 'WSACancelBlockingCall';
function WSAAsyncGetServByName(HWindow: HWND; wMsg: u_int;
  name, proto, buf: PChar; buflen: Integer): THandle;                                      external   winsocket name 'WSAAsyncGetServByName';
function WSAAsyncGetServByPort( HWindow: HWND; wMsg, port: u_int;
  proto, buf: PChar; buflen: Integer): THandle;                                            external   winsocket name 'WSAAsyncGetServByPort';
function WSAAsyncGetProtoByName(HWindow: HWND; wMsg: u_int;
  name, buf: PChar; buflen: Integer): THandle;                                             external   winsocket name 'WSAAsyncGetProtoByName';
function WSAAsyncGetProtoByNumber(HWindow: HWND; wMsg: u_int; number: Integer;
  buf: PChar; buflen: Integer): THandle;                                                   external   winsocket name 'WSAAsyncGetProtoByNumber';
function WSAAsyncGetHostByName(HWindow: HWND; wMsg: u_int;
  name, buf: PChar; buflen: Integer): THandle;                                             external   winsocket name 'WSAAsyncGetHostByName';
function WSAAsyncGetHostByAddr(HWindow: HWND; wMsg: u_int; addr: PChar;
  len, struct: Integer; buf: PChar; buflen: Integer): THandle;                             external   winsocket name 'WSAAsyncGetHostByAddr';
function WSACancelAsyncRequest(hAsyncTaskHandle: THandle): Integer;                        external   winsocket name 'WSACancelAsyncRequest';
function WSAAsyncSelect(s: ULONG; HWindow: HWND; wMsg: u_int; lEvent: Longint): Integer;   external   winsocket name 'WSAAsyncSelect';
function WSARecvEx(s: ULONG; var buf; len: Integer; var flags: Integer): Integer;          external   winsocket name 'WSARecvEx';

end.
