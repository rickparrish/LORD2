unit DropFiles;

{$mode objfpc}{$h+}

interface

uses
  Classes, SysUtils;

procedure ReadDoor32(AFileName: String);
procedure ReadDoorSys(AFileName: String);
procedure ReadDorinfo(AFileName: String);
procedure ReadLordInfo(AFileName: String);

implementation

uses
  Door;

{
  Read the DOOR32.SYS file AFILE
}
procedure ReadDoor32(AFileName: String);
var
   F: Text;
   S: String;
begin
     if (FileExists(AFileName)) then
     begin
          Assign(F, AFileName);
          {$I-}Reset(F);{$I+}
          if (IOResult = 0) then
          begin
               ReadLn(F, S); {1 - Comm Type (0=Local, 1=Serial, 2=Telnet)}
               DoorDropInfo.ComType := StrToIntDef(S, 0);

               ReadLn(F, S); {2 - Comm Or Socket Handle}
               DoorDropInfo.ComNum := StrToIntDef(S, -1);

               ReadLn(F, S); {3 - Baud Rate}
               DoorDropInfo.Baud := StrToIntDef(S, 38400);

               ReadLn(F, S); {4 - BBSID (Software Name & Version}

               ReadLn(F, S); {5 - User's Record Position (1 Based)}
               DoorDropInfo.RecPos := StrToIntDef(S, 1) - 1;

               ReadLn(F, S); {6 - User's Real Name}
               DoorDropInfo.RealName := S;

               ReadLn(F, S); {7 - User's Handle/Alias}
               DoorDropInfo.Alias := S;

               ReadLn(F, S); {8 - User's Access Level}
               DoorDropInfo.Access := StrToIntDef(S, 0);

               ReadLn(F, S); {9 - User's Time Left (In Minutes)}
               DoorDropInfo.MaxSeconds := StrToIntDef(S, 0) * 60;

               ReadLn(F, S); {10 - Emulation (0=Ascii, 1=Ansi, 2=Avatar, 3=RIP, 4=MaxGfx)}
               if (StrToIntDef(S, 1) = 0) then
                  DoorDropInfo.Emulation := etASCII
               else
                   DoorDropInfo.Emulation := etANSI;

               ReadLn(F, S); {11 - Current Node Number}
               DoorDropInfo.Node := StrToIntDef(S, 0);

               Close(F);
          end;
     end;
end;

{
  Read the DOOR.SYS file AFILE
}
procedure ReadDoorSys(AFileName: String);
var
   F: Text;
   S: String;
begin
     if (FileExists(AFileName)) then
     begin
          Assign(F, AFileName);
          {$I-}Reset(F);{$I+}
          if (IOResult = 0) then
          begin
               ReadLn(F, S); {1 - Comm Or Socket Handle}
               DoorDropInfo.ComNum := StrToIntDef(Copy(S, 4, Length(S) - 4), 0);
               if (DoorDropInfo.ComNum > 0) then
                  DoorDropInfo.ComType := 1;

               ReadLn(F, S); {2 - Line Speed}

               ReadLn(F, S); {3 - Data Bits}

               ReadLn(F, S); {4 - Current Node Number}
               DoorDropInfo.Node := StrToIntDef(S, 0);

               ReadLn(F, S); {5 - Modem Speed}
               DoorDropInfo.Baud := StrToIntDef(S, 38400);

               ReadLn(F, S); {6 - Screen Display}

               ReadLn(F, S); {7 - Syslog Printer}

               ReadLn(F, S); {8 - Page Bell}

               ReadLn(F, S); {9 - Caller Alarm}

               ReadLn(F, S); {10 - User's Real Name}
               DoorDropInfo.RealName := S;

               ReadLn(F, S); {11 - City, State}

               ReadLn(F, S); {12 - Phone Number}

               ReadLn(F, S); {13 - Data Phone Number}

               ReadLn(F, S); {14 - Password}

               ReadLn(F, S); {15 - User's Access Level}
               DoorDropInfo.Access := StrToIntDef(S, 0);

               ReadLn(F, S); {16 - Number Of Logons}

               ReadLn(F, S); {17 - Date Last Logged On}

               ReadLn(F, S); {18 - User's Time Left (In Seconds)}
               DoorDropInfo.MaxSeconds := StrToIntDef(S, 0);

               ReadLn(F, S); {19 - User's Time Left (In Minutes)}

               ReadLn(F, S); {20 - Emulation (GR=Ansi, NG=Ascii, 7E=7-Bit)}
               if (UpperCase(S) = 'GR') then
                  DoorDropInfo.Emulation := etANSI
               else
                   DoorDropInfo.Emulation := etASCII;

               ReadLn(F, S); {21 - Lines On Screen}

               ReadLn(F, S); {22 - Menu Status}

               ReadLn(F, S); {23 - Conferences}

               ReadLn(F, S); {24 - Current Conference}

               ReadLn(F, S); {25 - Expiration Date}

               ReadLn(F, S); {26 - User's Record Position (1 Based)}
               DoorDropInfo.RecPos := StrToIntDef(S, 1) - 1;

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
               DoorDropInfo.Alias := S;

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
procedure ReadDorinfo(AFileName: String);
var
   F: Text;
   S: String;
begin
     if (FileExists(AFileName)) then
     begin
          Assign(F, AFileName);
          {$I-}Reset(F);{$I+}
          if (IOResult = 0) then
          begin
               ReadLn(F, S); {1 - BBS Name}

               ReadLn(F, S); {2 - Sysop's First Name}

               ReadLn(F, S); {3 - Sysop's Last Name}

               ReadLn(F, S); {4 - Comm Number in COMxxx Form}
               DoorDropInfo.ComNum := StrToIntDef(Copy(S, 4, Length(S) - 3), 0);
               if (DoorDropInfo.ComNum > 0) then
                  DoorDropInfo.ComType := 1;

               ReadLn(F, S); {5 - Baud Rate in 57600 BAUD,N,8,1 Form}
               DoorDropInfo.Baud := StrToIntDef(Copy(S, 1, Pos(' ', S) - 1), 38400);

               ReadLn(F, S); {6 - Networked?}

               ReadLn(F, S); {7 - User's First Name / Alias}
               DoorDropInfo.Alias := S;

               ReadLn(F, S); {8 - User's Last Name}
               if (S = '') then
                  DoorDropInfo.RealName := DoorDropInfo.Alias
               else
                   DoorDropInfo.RealName := DoorDropInfo.Alias + ' ' + S;

               ReadLn(F, S); {9 - User's Location (City, State, etc.)}

               ReadLn(F, S); {10 - User's Emulation (1=Ansi)}
               if (StrToIntDef(S, 1) = 1) then
                  DoorDropInfo.Emulation := etANSI
               else
                   DoorDropInfo.Emulation := etASCII;

               ReadLn(F, S); {11 - User's Access Level}
               DoorDropInfo.Access := StrToIntDef(S, 0);

               ReadLn(F, S); {12 - User's Time Left (In Minutes)}
               DoorDropInfo.MaxSeconds := StrToIntDef(S, 0) * 60;

               ReadLn(F, S); {13 - Fossil?}

               Close(F);
          end;
     end;
end;

{
  Read the INFO.* file AFILE
}
procedure ReadLordInfo(AFileName: String);
var
   F: Text;
   S: String;
begin
     if (FileExists(AFileName)) then
     begin
          Assign(F, AFileName);
          {$I-}Reset(F);{$I+}
          if (IOResult = 0) then
          begin
               ReadLn(F, S); {1 - Account Number (0 Based)}
               DoorDropInfo.RecPos := StrToIntDef(S, 0);

               ReadLn(F, S); {2 - Emulation (3=Ansi, Other = Ascii)}
               if (StrToIntDef(S, 3) = 3) then
                  DoorDropInfo.Emulation := etANSI
               else
                   DoorDropInfo.Emulation := etASCII;

               ReadLn(F, S); {3 - RIP YES or RIP NO}

               ReadLn(F, S); {4 - FAIRY YES or FAIRY NO}
               if (UpperCase(S) = 'FAIRY YES') then
                  DoorDropInfo.Fairy := True
               else
                   DoorDropInfo.Fairy := False;

               ReadLn(F, S); {5 - User's Time Left (In Minutes)}
               DoorDropInfo.MaxSeconds := StrToIntDef(S, 0) * 60;

               ReadLn(F, S); {6 - User's Handle/Alias}
               DoorDropInfo.Alias := S;

               ReadLn(F, S); {7 - User's First Name}
               DoorDropInfo.RealName := S;

               ReadLn(F, S); {8 - User's Last Name}
               if (S <> '') then
                  DoorDropInfo.RealName := DoorDropInfo.RealName + ' ' + S;

               ReadLn(F, S); {9 - Comm Port}
               DoorDropInfo.ComNum := StrToIntDef(S, 0);

               ReadLn(F, S); {10 - Caller Baud Rate}
               DoorDropInfo.Baud := StrToIntDef(S, 38400);

               ReadLn(F, S); {11 - Port Baud Rate}

               ReadLn(F, S); {12 - FOSSIL or INTERNAL}
               if (UpperCase(S) = 'LOCAL') then
                  DoorDropInfo.ComType := 0
               else
               if (UpperCase(S) = 'TELNET') then
                  DoorDropInfo.ComType := 2
               else
               if (UpperCase(S) = 'WC5') then
                  DoorDropInfo.ComType := 3
               else
                   DoorDropInfo.ComType := 1;

               ReadLn(F, S); {13 - REGISTERED or UNREGISTERED}
               if (UpperCase(S) = 'REGISTERED') then
                  DoorDropInfo.Registered := True
               else
                   DoorDropInfo.Registered := False;

               ReadLn(F, S); {14 - CLEAN MODE ON or CLEAN MODE OFF}
               if (UpperCase(S) = 'CLEAN MODE ON') then
                  DoorDropInfo.Clean := True
               else
                   DoorDropInfo.Clean := False;

               Close(F);
          end;
     end;
end;

end.

