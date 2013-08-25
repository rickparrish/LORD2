unit wc5_com;
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
** Last update : 04-Apr-1999
**
** Note: (c) 1998-1999 by Maarten Bekers
**
** Note: Same story of what we said in Win32, only we have here 2 seperate
**       threads. The Write-thread has no problems, the read-thread is run
**       max every 5 seconds, or whenever a carrier-check is performed. This
**       carrier check is run on most BBS programs each second. You can
**       optimize this by making the ReadThread a blocking select() call on
**       the fd_read socket, but this can have other issues. A better approach
**       on Win32 would be to call the WsaAsyncSelect() call, but this is
**       non portable.
**
*)

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)
 INTERFACE
(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

uses Combase, BufUnit, Threads, Windows;

Const WriteTimeout   = 5000;                              { Wait max. 5 secs }
      ReadTimeOut    = 5000;                     { General event, 5 secs max }

      InBufSize      = 1024 * 32;
      OutBufSize     = 1024 * 32;


type TWC5Obj = Object(TCommObj)
        ReadProcPtr: Pointer;             { Pointer to TX/RX handler (thread) }
        WriteProcPtr: Pointer;            { Pointer to TX/RX handler (thread) }
        ThreadsInitted : Boolean;
        TelnetCarrier  : Boolean;
        FDoor32: THandle;

        ClientRC      : Longint;

        InBuffer      : ^BufArrayObj;             { Buffer system internally used }
        OutBuffer     : ^BufArrayObj;

        DoTxEvent     : PSysEventObj; { Event manually set when we have to transmit }
        DoRxEvent     : PSysEventObj;      { Event manually set when we need data }

        TxClosedEvent : PSysEventObj;    { Event set when the Tx thread is closed }
        RxClosedEvent : PSysEventObj;    { Event set when the Rx thread is closed }

        CriticalTx    : PExclusiveObj;                        { Critical sections }
        CriticalRx    : PExclusiveObj;

        TxThread      : PThreadsObj;           { The Transmit and Receive threads }
        RxThread      : PThreadsObj;

        EndThreads    : Boolean;    { Set to true when we have to end the threads }

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
        function  Com_GetHandle: Longint; virtual;

        procedure Com_OpenQuick(Handle: Longint); virtual;
        procedure Com_Close; virtual;
        procedure Com_SendBlock(var Block; BlockLen: Longint; var Written: Longint); virtual;
        procedure Com_ReadBlock(var Block; BlockLen: Longint; var Reads: Longint); virtual;
        procedure Com_GetBufferStatus(var InFree, OutFree, InUsed, OutUsed: Longint); virtual;
        procedure Com_SetDtr(State: Boolean); virtual;
        procedure Com_GetModemStatus(var LineStatus, ModemStatus: Byte); virtual;
        procedure Com_SetLine(BpsRate: longint; Parity: Char; DataBits, Stopbits: Byte); virtual;
        procedure Com_PurgeInBuffer; virtual;
        procedure Com_PurgeOutBuffer; virtual;

        procedure Com_PauseCom(CloseCom: Boolean); virtual;
        procedure Com_ResumeCom(OpenCom: Boolean); virtual;

        procedure Com_ReadProc(var TempPtr: Pointer);
        procedure Com_WriteProc(var TempPtr: Pointer);

        procedure Com_SetDataProc(ReadPtr, WritePtr: Pointer); virtual;

        function  Com_StartThread: Boolean;
        procedure Com_InitVars;
        procedure Com_StopThread;
     end; { object TWC5Obj }

Type PWC5Obj = ^TWC5Obj;

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)
 IMPLEMENTATION
(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

uses SysUtils;

{$IFDEF VPASCAL}{&StdCall+}{$ENDIF}
type
  TDoorInitialize = function: Boolean; {$IFNDEF VPASCAL}stdcall;{$ENDIF}
  TDoorShutdown = function: Boolean; {$IFNDEF VPASCAL}stdcall;{$ENDIF}
  TDoorWrite = function(Data: PChar; Size: LongInt): Boolean; {$IFNDEF VPASCAL}stdcall;{$ENDIF}
  TDoorRead = function(Data: PChar; Size: LongInt): DWord; {$IFNDEF VPASCAL}stdcall;{$ENDIF}
  TDoorGetAvailableEventHandle = function: THandle; {$IFNDEF VPASCAL}stdcall;{$ENDIF}
  TDoorGetOfflineEventHandle = function: THandle; {$IFNDEF VPASCAL}stdcall;{$ENDIF}
{$IFDEF VPASCAL}{&StdCall-}{$ENDIF}

var
  DoorInitialize: TDoorInitialize;
  DoorShutdown: TDoorShutdown;
  DoorWrite: TDoorWrite;
  DoorRead: TDoorRead;
  DoorGetAvailableEventHandle: TDoorGetAvailableEventHandle;
  DoorGetOfflineEventHandle: TDoorGetOfflineEventHandle;

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

constructor TWC5Obj.Init;
begin
  inherited Init;

  ThreadsInitted := false;
  Com_InitVars;

  FDoor32 := LoadLibrary('DOOR32.DLL');
  if (FDoor32 = 0) then
    InitFailed := True
  else
  begin
    @DoorInitialize := GetProcAddress(FDoor32, 'DoorInitialize');
    @DoorShutdown := GetProcAddress(FDoor32, 'DoorShutdown');
    @DoorWrite := GetProcAddress(FDoor32, 'DoorWrite');
    @DoorRead := GetProcAddress(FDoor32, 'DoorRead');
    @DoorGetAvailableEventHandle := GetProcAddress(FDoor32, 'DoorGetAvailableEventHandle');
    @DoorGetOfflineEventHandle := GetProcAddress(FDoor32, 'DoorGetOfflineEventHandle');

    InitFailed := Not(DoorInitialize);
  end;
  TelnetCarrier := Not(InitFailed);
end; { constructor Init }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

destructor TWC5Obj.Done;
begin
  if Not(InitFailed) then
     DoorShutdown;

  if (FDoor32 <> 0) then
     FreeLibrary(FDoor32);

  inherited done;
end; { destructor Done }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TWC5Obj.Com_ReadProc(var TempPtr: Pointer);
var BytesRead : Longint;
    BlockLen  : Longint;
begin
  repeat
     if DoRxEvent^.WaitForEvent(ReadTimeOut) then
      if NOT EndThreads then
       begin
         CriticalRx^.EnterExclusive;

         DoRxEvent^.ResetEvent;

            {----------- Start reading the gathered date -------------------}
            if InBuffer^.BufRoom > 0 then
              begin
                BlockLen := InBuffer^.BufRoom;
                if BlockLen > 1024 then
                  BlockLen := 1024;

                if BlockLen > 00 then
                 begin
                   BytesRead := DoorRead(InBuffer^.TmpBuf, BlockLen);

                  if BytesRead > 00 then
                    begin
                      InBuffer^.Put(InBuffer^.TmpBuf, BytesRead);
                    end; { if }
                 end; { if }
              end; { if }

         CriticalRx^.LeaveExclusive;
       end; { if RxEvent }
  until EndThreads;

  RxClosedEvent^.SignalEvent;
  ExitThisThread;
end; { proc. Com_ReadProc }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TWC5Obj.Com_WriteProc(var TempPtr: Pointer);
var BlockLen    : Longint;
    Written     : Longint;
    ReturnCode  : Longint;
begin
  repeat
     if DoTxEvent^.WaitForEvent(WriteTimeOut) then
      if NOT EndThreads then
       begin
         CriticalTx^.EnterExclusive;
         DoTxEvent^.ResetEvent;

         if OutBuffer^.BufUsed > 00 then
           begin
             BlockLen := OutBuffer^.Get(OutBuffer^.TmpBuf, OutBuffer^.BufUsed, false);

             DoorWrite(OutBuffer^.TmpBuf, BlockLen);
             Written := BlockLen;
             {-- remove the data from the buffer, but only remove the data ---}
             {-- thats actually written --------------------------------------}
             ReturnCode := OutBuffer^.Get(OutBuffer^.TmpBuf, Written, true);

             if ReturnCode <> Longint(Written) then
               begin
                 { not everything is removed! }
               end; { if }

             {-- if theres data in the buffer left, run this event again -----}
             if Written <> BlockLen then
               begin
                  DoTxEvent^.SignalEvent;
               end; { if }
           end; { if }

         CriticalTx^.LeaveExclusive;
       end; { if }

  until EndThreads;

  TxClosedEvent^.SignalEvent;
  ExitThisThread;
end; { proc. Com_WriteProc }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

function TWC5Obj.Com_StartThread: Boolean;
begin
  Result := false;
  EndThreads := false;
  if ThreadsInitted then EXIT;
  ThreadsInitted := true;

  {----------------------- Create all the events ----------------------------}
  New(DoTxEvent, Init);
  if NOT DoTxEvent^.CreateEvent(false) then EXIT;

  New(DoRxEvent, Init);
  if NOT DoRxEvent^.CreateEvent(false) then EXIT;

  New(RxClosedEvent, Init);
  if NOT RxClosedEvent^.CreateEvent(false) then EXIT;

  New(TxClosedEvent, Init);
  if NOT TxClosedEvent^.CreateEvent(false) then EXIT;

  {-------------- Startup the buffers and overlapped events -----------------}
  New(InBuffer, Init(InBufSize));
  New(OutBuffer, Init(OutBufSize));

  {-------------------- Startup a seperate write thread ---------------------}
  New(CriticalTx, Init);
  CriticalTx^.CreateExclusive;

  New(TxThread, Init);
  if NOT TxThread^.CreateThread(16384,                            { Stack size }
                                WriteProcPtr,               { Actual procedure }
                                nil,                              { Parameters }
                                0)                            { Creation flags }
                                 then EXIT;

  {-------------------- Startup a seperate read thread ----------------------}
  New(CriticalRx, Init);
  CriticalRx^.CreateExclusive;

  New(RxThread, Init);
  if NOT RxThread^.CreateThread(16384,                            { Stack size }
                                ReadProcPtr,                { Actual procedure }
                                nil,                              { Parameters }
                                0)                            { Creation flags }
                                 then EXIT;

  Result := true;
end; { proc. Com_StartThread }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TWC5Obj.Com_InitVars;
begin
  DoTxEvent := nil;
  DoRxEvent := nil;
  RxClosedEvent := nil;
  TxClosedEvent := nil;
  TxThread := nil;
  RxThread := nil;

  InBuffer := nil;
  OutBuffer := nil;
  CriticalRx := nil;
  CriticalTx := nil;
end; { proc. Com_InitVars }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TWC5Obj.Com_StopThread;
begin
  EndThreads := true;
  ThreadsInitted := false;

  if DoTxEvent <> nil then DoTxEvent^.SignalEvent;
  if DoTxEvent <> nil then DoRxEvent^.SignalEvent;

  if TxThread <> nil then TxThread^.CloseThread;
  if RxThread <> nil then RxThread^.CloseThread;

  if TxClosedEvent <> nil then
   if NOT TxClosedEvent^.WaitForEvent(1000) then
     TxThread^.TerminateThread(0);

  if RxClosedEvent <> nil then
   if NOT RxClosedEvent^.WaitForEvent(1000) then
     RxThread^.TerminateThread(0);

  if TxThread <> nil then Dispose(TxThread, Done);
  if RxThread <> nil then Dispose(RxThread, Done);

  if DoTxEvent <> nil then Dispose(DoTxEvent, Done);
  if DoRxEvent <> nil then Dispose(DoRxEvent, Done);
  if RxClosedEvent <> nil then Dispose(RxClosedEvent, Done);
  if TxClosedEvent <> nil then Dispose(TxClosedEvent, Done);

  if CriticalTx <> nil then Dispose(CriticalTx, Done);
  if CriticalRx <> nil then Dispose(CriticalRx, Done);

  if InBuffer <> nil then Dispose(InBuffer, Done);
  if OutBuffer <> nil then Dispose(OutBuffer, Done);

  Com_InitVars;
end; { proc. Com_StopThread }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

function TWC5Obj.Com_GetHandle: Longint;
begin
  Result := ClientRC;
end; { func. Com_GetHandle }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TWC5Obj.Com_OpenQuick(Handle: Longint);
begin
  ClientRC := Handle;
  Com_StartThread;
end; { proc. TWC5Obj.Com_OpenQuick }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

function TWC5Obj.Com_OpenKeep(Comport: Byte): Boolean;
begin
  Com_OpenKeep := TelnetCarrier;
  Com_StartThread;
end; { func. Com_OpenKeep }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

function TWC5Obj.Com_Open(Comport: Byte; BaudRate: Longint; DataBits: Byte;
                            Parity: Char; StopBits: Byte): Boolean;
begin
  Com_Open := TelnetCarrier;
  Com_StartThread;
end; { func. TWC5Obj.Com_OpenCom }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TWC5Obj.Com_SetLine(BpsRate: longint; Parity: Char; DataBits, Stopbits: Byte);
begin
  // Duhhh ;)
end; { proc. TWC5Obj.Com_SetLine }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TWC5Obj.Com_Close;
begin
     Com_StopThread;
end; { func. TWC5Obj.Com_CloseCom }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

function TWC5Obj.Com_SendChar(C: Char): Boolean;
var Written: Longint;
begin
  Com_SendBlock(C, SizeOf(C), Written);
  Com_SendChar := (Written = SizeOf(c));
end; { proc. TWC5Obj.Com_SendChar }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

function TWC5Obj.Com_GetChar: Char;
var Reads: Longint;
begin
  Com_ReadBlock(Result, SizeOf(Result), Reads);
end; { func. TWC5Obj.Com_GetChar }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TWC5Obj.Com_SendBlock(var Block; BlockLen: Longint; var Written: Longint);
begin
  if OutBuffer^.BufRoom < BlockLen then
   repeat
    {$IFDEF WIN32}
      Sleep(1);
    {$ENDIF}

    {$IFDEF OS2}
      DosSleep(1);
    {$ENDIF}
   until (OutBuffer^.BufRoom >= BlockLen) OR (NOT Com_Carrier);

  CriticalTx^.EnterExclusive;
    Written := OutBuffer^.Put(Block, BlockLen);
  CriticalTx^.LeaveExclusive;

  DoTxEvent^.SignalEvent;
end; { proc. TWC5Obj.Com_SendBlock }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TWC5Obj.Com_ReadBlock(var Block; BlockLen: Longint; var Reads: Longint);
begin
  if InBuffer^.BufUsed < BlockLen then
    begin
      DoRxEvent^.SignalEvent;

      repeat
        {$IFDEF OS2}
          DosSleep(1);
        {$ENDIF}

        {$IFDEF WIN32}
          Sleep(1);
        {$ENDIF}

        if Com_CharAvail then
          DoRxEvent^.SignalEvent;
      until (InBuffer^.BufUsed >= BlockLen) OR (NOT Com_Carrier);
    end; { if }

  Reads := InBuffer^.Get(Block, BlockLen, true);
end; { proc. TWC5Obj.Com_ReadBlock }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

function TWC5Obj.Com_CharAvail: Boolean;
begin
  if InBuffer^.BufUsed < 1 then
    begin
      if Not(InitFailed) and (WaitForSingleObject(DoorGetAvailableEventHandle, 0) = WAIT_OBJECT_0) then
        DoRxEvent^.SignalEvent;
    end; { if }

  Result := (InBuffer^.BufUsed > 0);
end; { func. TWC5Obj.Com_CharAvail }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

function TWC5Obj.Com_Carrier: Boolean;
begin
  if Not(InitFailed) then
    TelnetCarrier := Not(WaitForSingleObject(DoorGetOfflineEventHandle, 0) = WAIT_OBJECT_0)
  else
    TelnetCarrier := False;
  Result := TelnetCarrier;
end; { func. TWC5Obj.Com_Carrier }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TWC5Obj.Com_GetModemStatus(var LineStatus, ModemStatus: Byte);
begin
  LineStatus := 00;
  ModemStatus := 08;

  if Com_Carrier then ModemStatus := ModemStatus OR (1 SHL 7);
end; { proc. TWC5Obj.Com_GetModemStatus }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TWC5Obj.Com_SetDtr(State: Boolean);
begin
  if NOT State then
    begin
      Com_Close;
    end; { if }
end; { proc. TWC5Obj.Com_SetDtr }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

function TWC5Obj.Com_GetBpsRate: Longint;
begin
  Com_GetBpsRate := 115200;
end; { func. TWC5Obj.Com_GetBpsRate }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TWC5Obj.Com_GetBufferStatus(var InFree, OutFree, InUsed, OutUsed: Longint);
begin
  DoRxEvent^.SignalEvent;
  DoTxEvent^.SignalEvent;

  InFree := InBuffer^.BufRoom;
  OutFree := OutBuffer^.BufRoom;
  InUsed := InBuffer^.BufUsed;
  OutUsed := OutBuffer^.BufUsed;
end; { proc. TWC5Obj.Com_GetBufferStatus }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TWC5Obj.Com_PurgeInBuffer;
begin
  CriticalRx^.EnterExclusive;

  InBuffer^.Clear;

  CriticalRx^.LeaveExclusive;
end; { proc. TWC5Obj.Com_PurgeInBuffer }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TWC5Obj.Com_PurgeOutBuffer;
begin
  CriticalTx^.EnterExclusive;

  OutBuffer^.Clear;

  CriticalTx^.LeaveExclusive;
end; { proc. TWC5Obj.Com_PurgeInBuffer }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

function TWC5Obj.Com_ReadyToSend(BlockLen: Longint): Boolean;
begin
  Result := OutBuffer^.BufRoom >= BlockLen;
end; { func. ReadyToSend }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TWC5Obj.Com_PauseCom(CloseCom: Boolean);
begin
  if CloseCom then Com_Close
    else Com_StopThread;
end; { proc. Com_PauseCom }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TWC5Obj.Com_ResumeCom(OpenCom: Boolean);
begin
  if OpenCom then Com_OpenKeep(0)
    else Com_StartThread;
end; { proc. Com_ResumeCom }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

procedure TWC5Obj.Com_SetDataProc(ReadPtr, WritePtr: Pointer);
begin
  ReadProcPtr := ReadPtr;
  WriteProcPtr := WritePtr;
end; { proc. Com_SetDataProc }

(*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-+-*-*)

end.
