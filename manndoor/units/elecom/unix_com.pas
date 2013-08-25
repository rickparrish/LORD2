unit Unix_Com;
(*
**
** Serial and TCP/IP communication routines for DOS, OS/2 and Win9x/NT.
** Tested with: TurboPascal   v7.0,    (DOS)
**              VirtualPascal v2.1,    (OS/2, Win32)
**              FreePascal    v0.99.12 (DOS, Win32)
**              Delphi        v4.0.    (Win32)
**
** Version : 1.01
** Created : 21-May-1998
** Last update : 07-Apr-1999
**
** Note: (c) 1998-1999 by Maarten Bekers
**
*)

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)
 INTERFACE
(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

uses Combase, Linux;

type TUnixObj = Object(TCommObj)
        FosPort: Byte;

        constructor Init;
        destructor Done;

        function  Com_Open(Comport: Byte; BaudRate: Longint; DataBits: Byte;
                           Parity: Char; StopBits: Byte): Boolean; virtual;
        function  Com_OpenKeep(Comport: Byte): Boolean; virtual;
        function  Com_GetChar: Char; virtual;
        function  Com_CharAvail: Boolean; virtual;
        function  Com_Carrier: Boolean; virtual;
        function  Com_SendChar(C: Char): Boolean; virtual;
        function  Com_ReadyToSend(BlockLen: Longint): Boolean; virtual;
        function  Com_GetBPSrate: Longint; virtual;
        function  Com_GetDriverInfo: String; virtual;
        function  Com_GetHandle: longint; virtual;

        procedure Com_OpenQuick(Handle: Longint); virtual;
        procedure Com_Close; virtual;
        procedure Com_SendBlock(var Block; BlockLen: Longint; var Written: Longint); virtual;
        procedure Com_SendWait(var Block; BlockLen: Longint; var Written: Longint; Slice: SliceProc); virtual;
        procedure Com_ReadBlock(var Block; BlockLen: Longint; var Reads: Longint); virtual;
        procedure Com_GetBufferStatus(var InFree, OutFree, InUsed, OutUsed: Longint); virtual;
        procedure Com_SetDtr(State: Boolean); virtual;
        procedure Com_GetModemStatus(var LineStatus, ModemStatus: Byte); virtual;
        procedure Com_SetLine(BpsRate: longint; Parity: Char; DataBits, Stopbits: Byte); virtual;
        procedure Com_PurgeInBuffer; virtual;
        procedure Com_PurgeOutBuffer; virtual;
        procedure Com_SetFlow(SoftTX, SoftRX, Hard: Boolean); virtual;
     end; { object TUnixObj }

Type PUnixObj = ^TUnixObj;

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)
 IMPLEMENTATION
(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

var
  FCarrier: Boolean;

procedure SignalHandler(ASig: LongInt); cdecl;
begin
  FCarrier := False;
end;

constructor TUnixObj.Init;
begin
  inherited Init;

  FCarrier := True;

  Signal(SIGHUP, SignalHandler);
  Signal(SIGTERM, SignalHandler);
end; { constructor Init }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

destructor TUnixObj.Done;
begin
  inherited Done;
end; { destructor Done }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

function TUnixObj.Com_Open(Comport: Byte; BaudRate: Longint; DataBits: 
Byte;
                             Parity: Char; StopBits: Byte): Boolean;
begin
  {-------------------------- Open the comport -----------------------------}
  FosPort := (ComPort - 01);

  Com_Open := True;
  InitFailed := False;
end; { func. TUnixObj.Com_OpenCom }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

function TUnixObj.Com_OpenKeep(Comport: Byte): Boolean;
begin
  FosPort := (ComPort - 01);

  Com_OpenKeep := True;
  InitFailed := False;
end; { func. Com_OpenKeep }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TUnixObj.Com_OpenQuick(Handle: Longint);
begin
  {-------------------------- Open the comport -----------------------------}
  FosPort := (Handle - 01);

  InitFailed := False;
end; { proc. Com_OpenQuick }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TUnixObj.Com_SetLine(BpsRate: longint; Parity: Char; DataBits, 
Stopbits: Byte);
begin
end; { proc. TUnixObj.Com_SetLine }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

function TUnixObj.Com_GetBPSrate: Longint;
begin
  Com_GetBPSrate := 57600;
end; { func. TUnixObj.Com_GetBpsRate }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TUnixObj.Com_Close;
begin
end; { proc. TUnixObj.Com_Close }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

function TUnixObj.Com_SendChar(C: Char): Boolean;
begin
  Com_SendChar := True;
end; { proc. TUnixObj.Com_SendChar }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

function TUnixObj.Com_GetChar: Char;
begin
  Com_GetChar := #0;
end; { proc. TUnixObj.Com_ReadChar }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TUnixObj.Com_ReadBlock(var Block; BlockLen: Longint; var Reads: Longint);
begin
  Reads := 0;
end; { proc. TUnixObj.Com_ReadBlock }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TUnixObj.Com_SendBlock(var Block; BlockLen: Longint; var Written: Longint);
begin
  Written := 0;
end; { proc. TUnixObj.Com_SendBlock }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

function TUnixObj.Com_CharAvail: Boolean;
begin
  Com_CharAvail := False;
end;  { func. TUnixObj.Com_CharAvail }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

function  TUnixObj.Com_ReadyToSend(BlockLen: Longint): Boolean;
begin
  Com_ReadyToSend := True;
end; { func. TUnixObj.Com_ReadyToSend }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

function TUnixObj.Com_Carrier: Boolean;
begin
  Com_Carrier := FCarrier;
end; { func. TUnixObj.Com_Carrier }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TUnixObj.Com_SetDtr(State: Boolean);
begin
end; { proc. TUnixObj.Com_SetDtr }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TUnixObj.Com_GetModemStatus(var LineStatus, ModemStatus: Byte);
begin
end; { proc. TUnixObj.Com_GetModemStatus }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TUnixObj.Com_GetBufferStatus(var InFree, OutFree, InUsed, OutUsed: Longint);
begin
end; { proc. TUnixObj.Com_GetBufferStatus }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

function TUnixObj.Com_GetDriverInfo: String;
begin
  Com_GetDriverInfo := '';
end; { proc. TUnixObj.Com_GetDriverInfo }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TUnixObj.Com_PurgeInBuffer;
begin
end; { proc. TUnixObj.Com_PurgeInBuffer }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TUnixObj.Com_PurgeOutBuffer;
begin
end; { proc. TUnixObj.Com_PurgeOutBuffer }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

function TUnixObj.Com_GetHandle: longint;
begin
  Com_GetHandle := FosPort;
end; { func. Com_GetHandle }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TUnixObj.Com_SendWait(var Block; BlockLen: Longint; var Written: Longint; Slice: SliceProc);
begin
  Written := 0;
end; { proc. Com_SendWait }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TUnixObj.Com_SetFlow(SoftTX, SoftRX, Hard: Boolean);
begin
end; { proc. Com_SetFlow }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

end. { unit FOS_COM }
