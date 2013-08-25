unit Crt;

interface

uses
  Windows;

type
  TKeyBuf = Record
    Ch: Char;
    Extended: Boolean;
  end;

const
  { ReadKey() Key Mappings }
  TKeys: Array[0..255] of Integer = (
       0,    0,    0,    0,    0,    0,    0,    0,    8,    9,    0,    0,    0,   13,    0,    0,  // 0..15
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,   27,    0,    0,    0,    0,  // 16..31
      32, 1073, 1081, 1079, 1071, 1075, 1072, 1077, 1080,    0,    0,    0,    0, 1082, 1083,    0,  // 32..47
      48,   49,   50,   51,   52,   53,   54,   55,   56,   57,    0,    0,    0,    0,    0,    0,  // 48..63
       0,   97,   98,   99,  100,  101,  102,  103,  104,  105,  106,  107,  108,  109,  110,  111,  // 64..79
     112,  113,  114,  115,  116,  117,  118,  119,  120,  121,  122,    0,    0,    0,    0,    0,  // 80..95
    1082, 1079, 1080, 1081, 1075, 1076, 1077, 1071, 1072, 1073,   42,   43,    0,   45,   46,   47,  // 96..111
    1059, 1060, 1061, 1062, 1063, 1064, 1065, 1066, 1067, 1068, 1133, 1134,    0,    0,    0,    0,  // 112..127
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 128..143
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 144..159
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 160..175
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,   59,   61,   44,   45,   46,   47,  // 176..191
      96,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 192..207
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,   91,   92,   93,   39,    0,  // 208..223
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 223..239
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0); // 240..255

  TAltKeys: Array[0..255] of Integer = (
       0,    0,    0,    0,    0,    0,    0,    0, 1008,    0,    0,    0,    0,    0,    0,    0,  // 0..15
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 16..31
       0, 1153, 1161, 1159, 1151, 1155, 1152, 1157, 1160,    0,    0,    0,    0, 1162, 1163,    0,  // 32..47
    1129, 1120, 1121, 1122, 1123, 1124, 1125, 1126, 1127, 1128,    0,    0,    0,    0,    0,    0,  // 48..63
       0, 1030, 1048, 1046, 1032, 1018, 1033, 1034, 1035, 1023, 1036, 1037, 1038, 1050, 1049, 1024,  // 64..79
    1025, 1016, 1019, 1031, 1020, 1022, 1047, 1017, 1045, 1021, 1044,    0,    0,    0,    0,    0,  // 80..95
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0, 1055, 1078,    0, 1074,    0, 1164,  // 96..111
    1104, 1105, 1106, 1107, 1108, 1109, 1110, 1111, 1112, 1113, 1139, 1140,    0,    0,    0,    0,  // 112..127
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 128..143
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 144..159
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 160..175
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0, 1039, 1131, 1051, 1130, 1052, 1053,  // 176..191
    1041,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 192..207
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0, 1026, 1043, 1027, 1040,    0,  // 208..223
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 223..239
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0); // 240..255

  TCtrlKeys: Array[0..255] of Integer = (
       0,    0,    0,    0,    0,    0,    0,    0,  127, 1148,    0,    0,    0,   10,    0,    0,  // 0..15
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 16..31
      32, 1132, 1118, 1117, 1119, 1115, 1141, 1116, 1145,    0,    0,    0,    0, 1004, 1006,    0,  // 32..47
       0,    0, 1003,    0,    0,    0,   30,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 48..63
       0,    1,    2,    3,    4,    5,    6,    7,    8,    9,   10,   11,   12,   13,   14,   15,  // 64..79
      16,   17,   18,   19,   20,   21,   22,   23,   24,   25,   26,    0,    0,    0,    0,    0,  // 80..95
    1004, 1117, 1145, 1118, 1115, 1143, 1116, 1119, 1141, 1132, 1150, 1144,    0, 1142, 1006, 1149,  // 96..111
    1094, 1095, 1096, 1097, 1098, 1099, 1100, 1101, 1102, 1103, 1137, 1138,    0,    0,    0,    0,  // 112..127
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 128..143
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 144..159
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 160..175
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,   31,    0,    0,  // 176..191
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 192..207
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,   27,   28,   29,    0,    0,  // 208..223
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 223..239
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0); // 240..255

  TShiftKeys: Array[0..255] of Integer = (
       0,    0,    0,    0,    0,    0,    0,    0,    8, 1015,    0,    0,    0,   13,    0,    0,  // 0..15
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,   27,    0,    0,    0,    0,  // 16..31
      32, 1073, 1081, 1079, 1071, 1075, 1072, 1077, 1080,    0,    0,    0,    0, 1005, 1007,    0,  // 32..47
      41,   33,   64,   35,   36,   37,   94,   38,   42,   40,    0,    0,    0,    0,    0,    0,  // 48..63
       0,   65,   66,   67,   68,   69,   70,   71,   72,   73,   74,   75,   76,   77,   78,   79,  // 64..79
      80,   81,   82,   83,   84,   85,   86,   87,   88,   89,   90,    0,    0,    0,    0,    0,  // 80..95
      48,   49,   50,   51,   52,   53,   54,   55,   56,   57,   42,   43,    0,   45,   46,   47,  // 96..111
    1084, 1085, 1086, 1087, 1088, 1089, 1090, 1091, 1092, 1093, 1135, 1136,    0,    0,    0,    0,  // 112..127
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 128..143
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 144..159
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 160..175
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,   58,   43,   60,   95,   62,   63,  // 176..191
     126,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 192..207
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  123,  124,  125,   34,    0,  // 208..223
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  // 223..239
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0); // 240..255

  { Dark Colour Constants }
  Black         = 0;
  Blue          = 1;
  Green         = 2;
  Cyan          = 3;
  Red           = 4;
  Magenta       = 5;
  Brown         = 6;
  LightGray     = 7;

  { Light Colour Constants }
  DarkGray      = 8;
  LightBlue     = 9;
  LightGreen    = 10;
  LightCyan     = 11;
  LightRed      = 12;
  LightMagenta  = 13;
  Yellow        = 14;
  White         = 15;

var
  CheckBreak: Boolean = True;  { Enable Ctrl-Break }
  CheckEOF: Boolean = False;   { Check For EOF In CrtRead }
  TextAttr: Byte = LightGray;  { Current Text Attribute }
  WindMin: Word;               { Window Upper Left Coordiantes }
  WindMax: Word;               { Window Bottom Right Coordinates }

procedure AssignCrt(var AF: Text);                       {CRT}
procedure ClrEol;                                        {CRT}
procedure ClrScr;                                        {CRT}
procedure Delay(AMS: Word);                              {CRT}
procedure DelLine;                                       {CRT}
procedure FastWrite(AText: String; AX, AY, AAttr: Byte); {CUSTOM}
function GetAttrAt(AX, AY: Byte): Byte;                  {CUSTOM}
function GetCharAt(AX, AY: Byte): Char;                  {CUSTOM}
procedure GotoXY(AX, AY: Byte);                          {CRT}
procedure HighVideo;                                     {CRT}
procedure InsLine;                                       {CRT}
function KeyPressed: Boolean;                            {CRT}
procedure LowVideo;                                      {CRT}
procedure NormVideo;                                     {CRT}
function ReadKey: Char;                                  {CRT}
procedure TextBackground(AColor: Byte);                  {CRT}
procedure TextColor(AColor: Byte);                       {CRT}
function WhereX: Byte;                                   {CRT}
function WhereXA: Byte;                                  {CUSTOM}
function WhereY: Byte;                                   {CRT}
function WhereYA: Byte;                                  {CUSTOM}
procedure Window(AX1, AY1, AX2, AY2: Byte);              {CRT}

implementation

////////////////////////////////////////////////////////////////////////////////
// Private Routine Declarations
////////////////////////////////////////////////////////////////////////////////
function CrtClose(var AF: TTextRec): Integer; forward;
function CrtOpen(var AF: TTextRec): Integer; forward;
function CrtRead(var AF: TTextRec): Integer; forward;
function CrtReturn(var AF: TTextRec): Integer; forward;
function CrtWrite(var AF: TTextRec): Integer; forward;
procedure CrtWriteString(AText: String); forward;
procedure InitCrt; forward;
procedure ScrollDown(AX1, AY1, AX2, AY2, ALines, ACell: Word); forward;
procedure ScrollUp(AX1, AY1, AX2, AY2, ALines, ACell: Word); forward;

////////////////////////////////////////////////////////////////////////////////
// Private Variables
////////////////////////////////////////////////////////////////////////////////
var
  FKeyBuf: TKeyBuf;
  FNormAttr: Byte;
  FScreenSize: COORD;
  FStdInHandle: THandle;
  FStdOutHandle: THandle;
  FTextAttr: Byte;
  FX: Integer;
  FY: Integer;

////////////////////////////////////////////////////////////////////////////////
// Private Routines
////////////////////////////////////////////////////////////////////////////////

function CrtClose(var AF: TTextRec): Integer;
begin
     AF.Mode := fmClosed;
     Result := 0;
end;

function CrtOpen(var AF: TTextRec): Integer;
begin
     AF.CloseFunc := @CrtClose;
     if (AF.Mode = fmInput) then
     begin
          AF.FlushFunc := @CrtReturn;
          AF.InOutFunc := @CrtRead;
     end else
     begin
          AF.Mode := fmOutput;
          AF.FlushFunc := @CrtWrite;
          AF.InOutFunc := @CrtWrite;
     end;
     Result := 0;
end;

function CrtRead(var AF: TTextRec): Integer;
var
  Ch: Char;
  CurPos: Cardinal;
begin
     CurPos := 0;
     repeat
           FlushConsoleInputBuffer(FStdInHandle);
           Ch := ReadKey;
           case Ch of
                #0: ReadKey;
                #8: begin
                         if (CurPos > 0) then
                         begin
                              CrtWriteString(#8#32#8);
                              Dec(CurPos);
                         end;
                    end;
                #32..#255: begin
                                if (CurPos < AF.BufSize - 2) then
                                begin
                                     AF.Buffer[CurPos] := Ch;
                                     CrtWriteString(Ch);
                                     Inc(CurPos);
                                end;
                           end;
           end;
     until (Ch = #13) or (CheckEOF and (Ch = #26));

     AF.Buffer[CurPos] := Ch;
     Inc(CurPos);

     if (Ch = #13) then
     begin
          AF.Buffer[CurPos] := #10;
          Inc(CurPos);
          Write(#13#10);
     end;

     AF.BufPos := 0;
     AF.BufEnd := CurPos;
     Result := 0;
end;

function CrtReturn(var AF: TTextRec): Integer;
begin
     Result := 0;
end;

function CrtWrite(var AF: TTextRec): Integer;
begin
     CrtWriteString(Copy(AF.Buffer, 1, AF.BufPos));
     AF.BufPos := 0;
     Result := 0;
end;

procedure CrtWriteString(AText: String);
var
  Buf: String;
  I: Integer;

  procedure FlushBuf;
  begin
       FastWrite(Buf, WhereXA, WhereYA, TextAttr);
       Inc(FX, Length(Buf));
       Buf := '';
  end;

begin
     if (TextAttr <> FTextAttr) then
     begin
          FTextAttr := TextAttr;
          if (FStdOutHandle > 0) then
             SetConsoleTextAttribute(FStdOutHandle, TextAttr);
     end;

     Buf := '';
     for I := 1 to Length(AText) do
     begin
          case AText[I] of
               #07: MessageBeep(0);
               #08: begin
                         FlushBuf;
                         if (FX > 1) then
                            Dec(FX, 1);
                    end;
               #10: begin
                         FlushBuf;
                         if (FY = Hi(WindMax) - Hi(WindMin) + 1) then
                            ScrollUp(Lo(WindMin), Hi(WindMin), Lo(WindMax), Hi(WindMax), 1, 32 + TextAttr shl 8)
                         else
                             Inc(FY, 1);
                    end;
               #13: begin
                         FlushBuf;
                         FX := 1;
                    end;
               else
                   begin
                        Buf := Buf + AText[I];
                        if (FX + Length(Buf) > Lo(WindMax) - Lo(WindMin) + 1) then
                        begin
                             FlushBuf;
                             FX := 1;
                             if (FY = Hi(WindMax) - Hi(WindMin) + 1) then
                                ScrollUp(Lo(WindMin), Hi(WindMin), Lo(WindMax), Hi(WindMax), 1, 32 + TextAttr shl 8)
                             else
                                 Inc(FY, 1);
                        end;
                   end;
          end;
     end;
     FlushBuf;
     GotoXY(FX, FY);
end;

procedure InitCRT;
var
  ConsoleScreenBufferInfo: CONSOLE_SCREEN_BUFFER_INFO;
  Mode: Cardinal;
begin
     // Get input/output handles
     FStdInHandle := GetStdHandle(STD_INPUT_HANDLE);
     FStdOutHandle := GetStdHandle(STD_OUTPUT_HANDLE);

     // Disable processed input and mouse input
     if (GetConsoleMode(FStdInHandle, Mode)) then
     begin
          Mode := Mode and Not(ENABLE_PROCESSED_INPUT) and Not(ENABLE_MOUSE_INPUT);
          SetConsoleMode(FStdInHandle, Mode);
     end;

     // Initialize the key buffer
     FKeyBuf.Ch := #0;
     FKeyBuf.Extended := False;

     // Get the console screen buffer info
     GetConsoleScreenBufferInfo(FStdOutHandle, ConsoleScreenBufferInfo);

     // Get starting X/Y coordinates
     FX := ConsoleScreenBufferInfo.dwCursorPosition.X + 1;
     FY := ConsoleScreenBufferInfo.dwCursorPosition.Y + 1;

     // Determine the starting text attribute
     FNormAttr := GetAttrAt(WhereX, WhereY);

     // Initialize the text attribute
     NormVideo;

     // Fill the screensize record
     FScreenSize.X := ConsoleScreenBufferInfo.dwSize.X;
     FScreenSize.Y := ConsoleScreenBufferInfo.dwSize.Y;

     // Find the WindMin/WindMax records
     WindMin := 0;
     WindMax := FScreenSize.X - 1 + (FScreenSize.Y - 1) shl 8;

     // Make ReadLn work with our input routines
     AssignCrt(Input);
     Reset(Input);
     TTextRec(Input).Handle := FStdInHandle;

     // Make Write/WriteLn work with our output routines
     AssignCrt(Output);
     ReWrite(Output);
     TTextRec(Output).Handle := FStdOutHandle;
end;

procedure ScrollDown(AX1, AY1, AX2, AY2, ALines, ACell: Word);
var
  DestinationOrigin: COORD;
  Fill: CHAR_INFO;
  ScrollRectangle: SMALL_RECT;
begin
     DestinationOrigin.X := AX1;
     DestinationOrigin.Y := AY1 + ALines;

     Fill.AsciiChar := Chr(Lo(ACell));
     Fill.Attributes := Hi(ACell);

     ScrollRectangle.Bottom := AY2 - ALines;
     ScrollRectangle.Left := AX1;
     ScrollRectangle.Right := AX2;
     ScrollRectangle.Top := AY1;

     ScrollConsoleScreenBuffer(FStdOutHandle, ScrollRectangle, nil, DestinationOrigin, Fill);
end;

procedure ScrollUp(AX1, AY1, AX2, AY2, ALines, ACell: Word);
var
  ClipRectangle: SMALL_RECT;
  DestinationOrigin: COORD;
  Fill: CHAR_INFO;
  I: Integer;
  ScrollRectangle: SMALL_RECT;
begin
     ClipRectangle.Bottom := AY2;
     ClipRectangle.Left := AX1;
     ClipRectangle.Right := AX2;
     ClipRectangle.Top := AY1;

     Fill.AsciiChar := Chr(Lo(ACell));
     Fill.Attributes := Hi(ACell);

     ScrollRectangle := ClipRectangle;

     // Win9x sucks so we only scroll half the screen at a time
     if (ALines > 1) then
     begin
          for I := 1 to 2 do
          begin
               DestinationOrigin.X := AX1;
               DestinationOrigin.Y := AY1 - ALines div 2;
               ScrollConsoleScreenBuffer(FStdOutHandle, ScrollRectangle, @ClipRectangle, DestinationOrigin, Fill);
          end;
     end;
     DestinationOrigin.X := AX1;
     DestinationOrigin.Y := AY1 - 1;
     ScrollConsoleScreenBuffer(FStdOutHandle, ScrollRectangle, @ClipRectangle, DestinationOrigin, Fill);
end;

////////////////////////////////////////////////////////////////////////////////
// Standard CRT and Custom routines
////////////////////////////////////////////////////////////////////////////////
procedure AssignCrt(var AF: Text);
begin
     Assign(AF, '');
     with TTextRec(AF) do
     begin
          BufPtr := @Buffer;
          BufSize := SizeOf(Buffer);
          Handle := $7FFFFFFF;
          Mode := fmClosed;
          Name[0] := #0;
          OpenFunc := @CrtOpen;
     end;
end;

procedure ClrEol;
var
  Len: Byte;
begin
     Len := Lo(WindMax) - WhereX + 2;
     FastWrite(StringOfChar(' ', Len), WhereXA, WhereYA, TextAttr);
end;

procedure ClrScr;
begin
     ScrollUp(Lo(WindMin), Hi(WindMin), Lo(WindMax), Hi(WindMax), Hi(WindMax) - Hi(WindMin) + 1, 32 + TextAttr shl 8);
     GotoXY(1, 1);
end;

procedure Delay(AMS: Word);
begin
     Sleep(AMS);
end;

procedure DelLine;
begin
     ScrollUp(Lo(WindMin), WhereYA - 1, Lo(WindMax), Hi(WindMax), 1, 32 + TextAttr shl 8);
end;

procedure FastWrite(AText: String; AX, AY, AAttr: Byte);
var
  Buffer: Array[0..255] of CHAR_INFO;
  BufferCoord: COORD;
  BufferSize: COORD;
  I: Integer;
  WriteRegion: SMALL_RECT;
begin
     for I := 1 to Length(AText) do
     begin
          Buffer[I - 1].Attributes := AAttr;
          Buffer[I - 1].AsciiChar := AText[I];
     end;

     BufferCoord.X := 0;
     BufferCoord.Y := 0;

     BufferSize.X := Length(AText);
     BufferSize.Y := 1;

     WriteRegion.Bottom := AY - 1;
     WriteRegion.Left := AX - 1;
     WriteRegion.Right := (AX - 1) + Length(AText);
     WriteRegion.Top := AY - 1;

     WriteConsoleOutput(FStdOutHandle, @Buffer, BufferSize, BufferCoord, WriteRegion);
end;

function GetAttrAt(AX, AY: Byte): Byte;
var
  Attribute: Word;
  ReadCoord: COORD;
  NumberOfAttrsRead: DWORD;
begin
     ReadCoord.X := AX - 1;
     ReadCoord.Y := AY - 1;
     ReadConsoleOutputAttribute(FStdOutHandle, @Attribute, 1, ReadCoord, NumberOfAttrsRead);
     Result := Attribute;
end;

function GetCharAt(AX, AY: Byte): Char;
var
  Character: Char;
  ReadCoord: COORD;
  NumberOfCharsRead: DWORD;
begin
     ReadCoord.X := AX - 1;
     ReadCoord.Y := AY - 1;
     ReadConsoleOutputAttribute(FStdOutHandle, @Character, 1, ReadCoord, NumberOfCharsRead);
     Result := Character;
end;

procedure GotoXY(AX, AY: Byte);
var
  CursorPosition: COORD;
  X, Y: Byte;
begin
     if (AX > 0) and (AY > 0) then
     begin
          X := AX - 1 + Lo(WindMin);
          Y := AY - 1 + Hi(WindMin);
          if (X <= Lo(WindMax)) and (Y <= Hi(WindMax)) then
          begin
               FX := AX;
               FY := AY;
               CursorPosition.X := X;
               CursorPosition.Y := Y;
               SetConsoleCursorPosition(FStdOutHandle, CursorPosition);
          end;
     end;
end;

procedure HighVideo;
begin
     TextAttr := TextAttr or $08;
end;

procedure InsLine;
begin
     ScrollDown(Lo(WindMin), WhereYA - 1, Lo(WindMax), Hi(WindMax), 1, 32 + TextAttr shl 8);
end;

function KeyPressed: Boolean;
var
  Alt: Boolean;
  Buffer: INPUT_RECORD;
  CapsLock: Boolean;
  Ctrl: Boolean;
  Key: Integer;
  NumberOfEvents: DWORD;
  NumberOfEventsRead: DWORD;
  NumLock: Boolean;
  Shift: Boolean;
begin
     if (FKeyBuf.Ch <> #0) then
     begin
          Result := True;
          Exit;
     end;

     repeat
           GetNumberOfConsoleInputEvents(FStdInHandle, NumberOfEvents);
           if (NumberOfEvents > 0) then
           begin
                if (PeekConsoleInput(FStdInHandle, Buffer, 1, NumberOfEventsRead)) then
                begin
                     if ((Buffer.EventType = KEY_EVENT) and (Buffer.Event.KeyEvent.bKeyDown)) then//and Not(Buffer.Event.KeyEvent.wVirtualKeyCode in [VK_SHIFT, VK_MENU, VK_CONTROL, VK_CAPITAL, VK_NUMLOCK, VK_SCROLL])) then
                     begin
                          ReadConsoleInput(FStdInHandle, Buffer, 1, NumberOfEventsRead);

                          Alt := GetKeyState(VK_MENU) and $8000 = $8000;
                          Ctrl := GetKeyState(VK_CONTROL) and $8000 = $8000;
                          Shift := GetKeyState(VK_SHIFT) and $8000 = $8000;

                          if (Buffer.Event.KeyEvent.wVirtualKeyCode in [65..90]) then
                          begin
                               CapsLock := GetKeyState(VK_CAPITAL) and $0001 = $0001;
                               Shift := Shift xor CapsLock;
                          end;

                          if (Buffer.Event.KeyEvent.wVirtualKeyCode in [96..105]) then
                          begin
                               NumLock := GetKeyState(VK_NUMLOCK) and $0001 = $0001;
                               Shift := Shift or NumLock;
                          end;

                          if (Alt) then
                             Key := TAltKeys[Buffer.Event.KeyEvent.wVirtualKeyCode]
                          else
                          if (Ctrl) then
                             Key := TCtrlKeys[Buffer.Event.KeyEvent.wVirtualKeyCode]
                          else
                          if (Shift) then
                             Key := TShiftKeys[Buffer.Event.KeyEvent.wVirtualKeyCode]
                          else
                              Key := TKeys[Buffer.Event.KeyEvent.wVirtualKeyCode];

                          if (Key > 0) then
                          begin
                               if (Key >= 1000) then
                               begin
                                    FKeyBuf.Ch := Chr(Key - 1000);
                                    FKeyBuf.Extended := True;
                               end else
                               begin
                                    FKeyBuf.Ch := Chr(Key);
                                    FKeyBuf.Extended := False;
                               end;
                               Result := True;
                               Exit;
                          end;
                     end else
                         ReadConsoleInput(FStdInHandle, Buffer, 1, NumberOfEventsRead);
                end;
           end;
     until (NumberOfEvents = 0);
     Result := False;
end;

procedure LowVideo;
begin
     TextAttr := TextAttr and $F7;
end;

procedure NormVideo;
begin
     TextAttr := FNormAttr;
end;

function ReadKey: Char;
begin
     while Not(KeyPressed) do
           Sleep(1);

     if (FKeyBuf.Extended) then
     begin
          Result := #0;
          FKeyBuf.Extended := False;
     end else
     begin
          Result := FKeyBuf.Ch;
          FKeyBuf.Ch := #0;
     end;
end;

procedure TextBackground(AColor: Byte);
begin
     TextAttr := (TextAttr and $0F) or ((AColor and $0F) shl 4);
end;

procedure TextColor(AColor: Byte);
begin
     TextAttr := (TextAttr and $F0) or (AColor and $0F);
end;

function WhereX: Byte;
begin
     Result := FX;
end;

function WhereXA: Byte;
begin
     Result := FX + Lo(WindMin);
end;

function WhereY: Byte;
begin
     Result := FY;
end;

function WhereYA: Byte;
begin
     Result := FY + Hi(WindMin);
end;

procedure Window(AX1, AY1, AX2, AY2: Byte);
begin
     if (AX1 > 0) and (AY1 > 0) and (AX1 <= AX2) and (AY1 <= AY2) then
     begin
          Dec(AX1);
          Dec(AY1);
          Dec(AX2);
          Dec(AY2);
          if (AX2 < FScreenSize.X) and (AY2 < FScreenSize.Y) then
          begin
               WindMin := AX1 + AY1 shl 8;
               WindMax := AX2 + AY2 shl 8;
               GotoXY(1, 1);
          end;
     end;
end;

begin
     InitCrt;
end.

