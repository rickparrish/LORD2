unit mStrings;

interface

uses
  Compat, Crt, SysUtils, StrUtils;

type
  TTokens = Array of String;

{
  Default "allowed characters" used by Input() and mInput()
}
const
  CHARS_ALL = '`1234567890-=\qwertyuiop[]asdfghjkl;''zxcvbnm,./~!@#$%^&*()_+|QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>? ';
  CHARS_ALPHA = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
  CHARS_NUMERIC = '1234567890';
  CHARS_FILENAME = '1234567890-=\qwertyuiop[]asdfghjkl;''zxcvbnm,.~!@#$%^&()_+QWERTYUIOP{}ASDFGHJKL:ZXCVBNM ';


function AddSlash(ALine: String): String;
function BoolToStr(AValue: Boolean; ATrue, AFalse: String): String;
function Center(ALine: String): String;
function DeTokenize(ATokens: TTokens; ADelim: Char): String;
function DeTokenize(ATokens: TTokens; ADelim: Char; AStartIndex: Integer): String;
function ciPos(ASubStr, ALine: String): LongInt;
function GetFName(ALine: String): String;
function GetLName(ALine: String): String;
function IntToMoney(ANum: LongInt; APrefix: String): String;
function LoCase(ACh: Char): Char;
function NoSlash(ALine: String): String;
function PadLeft(ALine: String; ACh: Char; ALen: Integer): String;
function PadRight(ALine: String; ACh: Char; ALen: Integer): String;
function PipeToAnsi(ALine: String): String;
function Replace(ALine, AOld, ANew: String): String;
function Right(ALine: String): String;
function SecToDHMS(ASec: LongInt): String;
function SecToHM(ASec: LongInt): String;
function SecToHMS(ASec: LongInt): String;
function SecToMS(ASec: LongInt): String;
function SethToPipe(ALine: String): String;
function StripChar(ALine: String; ACh: Char): String;
function Tokenize(ALine: String; ADelim: Char): TTokens;

implementation

uses
  mAnsi;

{
  Add a trailing backslash to a string if it does not exist
}
function AddSlash(ALine: String): String;
begin
     if (ALine[Length(ALine)] <> SLASH_CHAR) then
        ALine := ALine + SLASH_CHAR;
     AddSlash := ALine;
end;

{
  Return string ATRUE or AFALSE depending on the value of AVALUE
}
function BoolToStr(AValue: Boolean; ATrue, AFalse: String): String;
begin
     if (AValue) then
        BoolToStr := ATrue
     else
         BoolToStr := AFalse;
end;

{
  Return ALINE padded on the left side so it would be centered in
  the current window
}
function Center(ALine: String): String;
var
  Width: Integer;
begin
     Width := Lo(WindMax) - Lo(WindMin) + 1;
     if (Length(ALine) < Width) then
        ALine := PadLeft(ALine, ' ', Length(ALine) + (Width - Length(ALine)) div 2);
     Center := ALine;
end;

{
  Works like Pos(), only case insensitive
}
function ciPos(ASubStr, ALine: String): LongInt;
begin
     ciPos := Pos(UpperCase(ASubStr), UpperCase(ALine));
end;

function DeTokenize(ATokens: TTokens; ADelim: Char): String;
begin
  Result := DeTokenize(ATokens, ADelim, 1);
end;

function DeTokenize(ATokens: TTokens; ADelim: Char; AStartIndex: Integer): String;
var
  I: Integer;
  S: String;
begin
  S := '';

  if (AStartIndex <= High(ATokens)) then
  begin
    S := ATokens[AStartIndex];
    for I := AStartIndex + 1 to High(ATokens) do
    begin
      S := S + ADelim + ATokens[I];
    end;
  end;

  Result := S;
end;

{
  Return all text in ALINE up to the first space
}
function GetFName(ALine: String): String;
begin
     if (Pos(' ', ALine) = 0) then
        GetFName := ALine
     else
         GetFName := Copy(ALine, 1, Pos(' ', ALine) - 1);
end;

{
  Return all text in ALINE after first space
  Return a blank line if no space exists
}
function GetLName(ALine: String): String;
begin
     if (Pos(' ', ALine) = 0) then
        GetLName := ''
     else
         GetLName := Copy(ALine, Pos(' ', ALine) + 1, Length(ALine) - Pos(' ', ALine));
end;

{
  Return ANUM as a string with comma's seperating the thousands
  ie: 10000 becomes 10,000
}
function IntToMoney(ANum: LongInt; APrefix: String): String;
var
  I, J: Integer;
  S: String;
begin
     S := IntToStr(ANum);
     J := 0;
     for I := Length(S) downto 1 do
     begin
          Inc(J);
          if (J mod 3 = 0) and (I > 1) then
          begin
               Insert(',', S, I);
               J := 0;
          end;
     end;
     IntToMoney := APrefix + S;
end;

{
  Return ACH as lower case
}
function LoCase(ACh: Char): Char;
begin
     if (ACh in ['A'..'Z']) then
        ACh := Chr(Ord(ACh) + 32);
     LoCase := ACh;
end;

{
  Return ALINE with no trailing backslash
}
function NoSlash(ALine: String): String;
begin
     if (ALine[Length(ALine)] = SLASH_CHAR) then
        Delete(ALine, Length(ALine), 1);
     NoSlash := ALine;
end;

{
  Return ALINE padded on the left side with ACH until it is ALEN characters
  long.  Cut ALINE if it is more than ALEN characters
}
function PadLeft(ALine: String; ACh: Char; ALen: Integer): String;
begin
     while (Length(ALine) < ALen) do
           ALine := ACh + ALine;
     PadLeft := Copy(ALine, 1, ALen);
end;

{
  Same as PadLeft(), but pad the right of the string
}
function PadRight(ALine: String; ACh: Char; ALen: Integer): String;
begin
     while (Length(ALine) < ALen) do
           ALine := ALine + ACh;
     PadRight := Copy(ALine, 1, ALen)
end;

{
  Convert PIPE codes to ANSI escape sequences
  Pipe codes are in format |BF
  Where B is background value and F is foreground, in base 16 (hex)
  So range is |00 .. |7F
}
function PipeToAnsi(ALine: String): String;
var
  Attr: Integer;
  I: Integer;
  S: String;
begin
     if (Length(ALine) >= 3) then
     begin
          I := 0;
          S := '';
          while (I < Length(ALine)) do
          begin
               Inc(I);
               if (ALine[I] = '|') and (Length(ALine) - I >= 2) then
               begin
                    Attr := StrToIntDef('$' + Copy(ALine, I + 1, 2), -1);
                    if (Attr <> -1) then
                    begin
                         Inc(I, 2);
                         if (Attr > 127) then
                            Dec(Attr, 128);
                         S := S + aTextAttr(Attr);
                    end else
                        S := S + '|';
               end else
                   S := S + ALine[I];
          end;
     end else
         S := ALine;

     PipeToAnsi := S;
end;

{
  Return ALINE with all occurances of AOLD replaced with ANEW
}
function Replace(ALine, AOld, ANew: String): String;
var
  MatchPos: LongInt;
begin
     if (ciPos(AOld, ANew) = 0) then
     begin
          MatchPos := ciPos(AOld, ALine);
          while (MatchPos > 0) do
          begin
               Delete(ALine, MatchPos, Length(AOld));
               Insert(ANew, ALine, MatchPos);
               MatchPos := ciPos(AOld, ALine);
          end;
     end;
     Replace := ALine;
end;

{
  Same as Center() but makes string right aligned
}
function Right(ALine: String): String;
var
  Width: Integer;
begin
     Width := Lo(WindMax) - Lo(WindMin) + 1;
     Right := PadLeft(ALine, ' ', Width);
end;

{
  Returns a number of seconds formatted as:
  1d 1h 1m 1s
  0 values are not returned, so 3601 becomes
  1h 1s
}
function SecToDHMS(ASec: LongInt): String;
var
  D, H, M, S: Integer;
begin
     D := ASec div 86400;
     ASec := ASec mod 86400;
     H := ASec div 3600;
     ASec := ASec mod 3600;
     M := ASec div 60;
     S := ASec mod 60;
     SecToDHMS := IntToStr(D) + 'd ' + IntToStr(H) + 'h ' + IntToStr(M) + 'm ' + IntToStr(S) + 's';
end;

{
  Returns a number of seconds formatted as:
  HH:MM
}
function SecToHM(ASec: LongInt): String;
var
  H, M: Integer;
begin
     H := ASec div 3600;
     ASec := ASec mod 3600;
     M := ASec div 60;
     SecToHM := PadLeft(IntToStr(H), '0', 2) + ':' + PadLeft(IntToStr(M), '0', 2);
end;

{
  Returns a number of seconds formatted as:
  HH:MM:SS
}
function SecToHMS(ASec: LongInt): String;
var
  H, M, S: Integer;
begin
     H := ASec div 3600;
     ASec := ASec mod 3600;
     M := ASec div 60;
     S := ASec mod 60;
     SecToHMS := PadLeft(IntToStr(H), '0', 2) + ':' + PadLeft(IntToStr(M), '0', 2) + ':' + PadLeft(IntToStr(S), '0', 2);
end;

{
  Returns a number of seconds formatted as:
  MM:SS
}
function SecToMS(ASec: LongInt): String;
var
  M, S: Integer;
begin
     M := ASec div 60;
     S := ASec mod 60;
     SecToMS := PadLeft(IntToStr(M), '0', 2) + ':' + PadLeft(IntToStr(S), '0', 2);
end;

{
  Converts Seth ` codes to PIPE codes
}
function SethToPipe(ALine: String): String;
const
  HEX: array[0..15] of Char = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');
var
  BG: Byte;
  FG: Byte;
  I: Integer;
  S: String;
begin
     BG := TextAttr div 16;
     FG := TextAttr mod 16;

     if (Length(ALine) >= 2) then
     begin
          I := 0;
          S := '';
          while (I < Length(ALine)) do
          begin
               Inc(I);
               if (ALine[I] = '`') and (Length(ALine) - I >= 1) then
               begin
                    Inc(I);
                    case ALine[I] of
                         '`': S := S + '`';
                         '1': begin
                                   FG := 1;
                                   S := S + '|' + HEX[BG] + HEX[FG];
                              end;
                         '2': begin
                                   FG := 2;
                                   S := S + '|' + HEX[BG] + HEX[FG];
                              end;
                         '3': begin
                                   FG := 3;
                                   S := S + '|' + HEX[BG] + HEX[FG];
                              end;
                         '4': begin
                                   FG := 4;
                                   S := S + '|' + HEX[BG] + HEX[FG];
                              end;
                         '5': begin
                                   FG := 5;
                                   S := S + '|' + HEX[BG] + HEX[FG];
                              end;
                         '6': begin
                                   FG := 6;
                                   S := S + '|' + HEX[BG] + HEX[FG];
                              end;
                         '7': begin
                                   FG := 7;
                                   S := S + '|' + HEX[BG] + HEX[FG];
                              end;
                         '8': begin
                                   FG := 8;
                                   S := S + '|' + HEX[BG] + HEX[FG];
                              end;
                         '9': begin
                                   FG := 9;
                                   S := S + '|' + HEX[BG] + HEX[FG];
                              end;
                         '0': begin
                                   FG := 10;
                                   S := S + '|' + HEX[BG] + HEX[FG];
                              end;
                         '!': begin
                                   FG := 11;
                                   S := S + '|' + HEX[BG] + HEX[FG];
                              end;
                         '@': begin
                                   FG := 12;
                                   S := S + '|' + HEX[BG] + HEX[FG];
                              end;
                         '#': begin
                                   FG := 13;
                                   S := S + '|' + HEX[BG] + HEX[FG];
                              end;
                         '$': begin
                                   FG := 14;
                                   S := S + '|' + HEX[BG] + HEX[FG];
                              end;
                         '%': begin
                                   FG := 15;
                                   S := S + '|' + HEX[BG] + HEX[FG];
                              end;
                         'r': begin
                                   Inc(I);
                                   if (I <= Length(ALine)) and (ALine[I] in ['0'..'7']) then
                                   begin
                                        BG := StrToIntDef(ALine[I] + '', 0); { + '' needed for VPascal 2.1b279 }
                                        S := S + '|' + HEX[BG] + HEX[FG];
                                   end;
                              end;
                    end;
               end else
                   S := S + ALine[I];
          end;
     end else
         S := ALine;

     SethToPipe := S;
end;

{
  Returns ALINE with all occurances of ACH stripped
}
function StripChar(ALine: String; ACh: Char): String;
begin
     while (Pos(ACh, ALine) > 0) do
           Delete(ALine, Pos(ACh, ALine), 1);
     StripChar := ALine;
end;

function Tokenize(ALine: String; ADelim: Char): TTokens;
var
  I: Integer;
  TokenCount: Integer;
begin
  TokenCount := Length(ALine) - Length(Replace(ALine, ADelim, '')) + 1;
  SetLength(Result, TokenCount + 1);

  for I := 1 to TokenCount do
  begin
    Result[I] := ExtractDelimited(I, ALine, [ADelim]);
  end;
end;

end.
