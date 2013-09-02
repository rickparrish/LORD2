unit StringUtils;

{$mode objfpc}{$h+}

interface

uses
  Ansi,
  Classes, StrUtils, SysUtils;

type
  TTokens = Array of String;

function PipeToAnsi(AText: String): String;
function SecToDHMS(ASec: LongInt): String;
function SecToHM(ASec: LongInt): String;
function SecToHMS(ASec: LongInt): String;
function SecToMS(ASec: LongInt): String;
function SethStrip(AText: String): String;
function StrToTok(AText: String; ADelim: Char): TTokens;
function TokToStr(ATokens: TTokens; ADelim: Char): String;
function TokToStr(ATokens: TTokens; ADelim: Char; AStartIndex: Integer): String;

implementation

{
  Convert PIPE codes to ANSI escape sequences
  Pipe codes are in format |BF
  Where B is background value and F is foreground, in base 16 (hex)
  So range is |00 .. |7F
}
function PipeToAnsi(AText: String): String;
var
  Attr: Integer;
  I: Integer;
  S: String;
begin
     if (Length(AText) >= 3) then
     begin
          I := 0;
          S := '';
          while (I < Length(AText)) do
          begin
               Inc(I);
               if (AText[I] = '|') and (Length(AText) - I >= 2) then
               begin
                    Attr := StrToIntDef('$' + Copy(AText, I + 1, 2), -1);
                    if (Attr <> -1) then
                    begin
                         Inc(I, 2);
                         if (Attr > 127) then
                            Dec(Attr, 128);
                         S := S + AnsiTextAttr(Attr);
                    end else
                        S := S + '|';
               end else
                   S := S + AText[I];
          end;
     end else
         S := AText;

     Result := S;
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
  Result := IntToStr(D) + 'd ' + IntToStr(H) + 'h ' + IntToStr(M) + 'm ' + IntToStr(S) + 's';
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
  Result := AddChar('0', IntToStr(H), 2) + ':' + AddChar('0', IntToStr(M), 2);
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
  Result := AddChar('0', IntToStr(H), 2) + ':' + AddChar('0', IntToStr(M), 2) + ':' + AddChar('0', IntToStr(S), 2);
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
  Result := AddChar('0', IntToStr(M), 2) + ':' + AddChar('0', IntToStr(S), 2);
end;

function SethStrip(AText: String): String;
begin
  while (Pos('`', AText) > 0) do
  begin
    AText := StringReplace(AText, '`1', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`2', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`3', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`4', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`5', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`6', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`7', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`8', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`9', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`0', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`!', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`@', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`#', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`$', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`%', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`*', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`b', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`c', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`d', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`k', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`l', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`w', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`x', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`\', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`|', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`.', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`r0', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`r1', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`r2', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`r3', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`r4', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`r5', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`r6', '', [rfIgnoreCase, rfReplaceAll]);
    AText := StringReplace(AText, '`r7', '', [rfIgnoreCase, rfReplaceAll]);
    // TODO ANY OTHER ` AND THE NEXT CHARACTER SHOULD ALSO BE REMOVED
  end;

  Result := AText;
end;

function StrToTok(AText: String; ADelim: Char): TTokens;
var
  I: Integer;
  TokenCount: Integer;
begin
  TokenCount := Length(AText) - Length(StringReplace(AText, ADelim, '', [rfReplaceAll])) + 1;
  SetLength(Result, TokenCount + 1);

  for I := 1 to TokenCount do
  begin
    Result[I] := ExtractDelimited(I, AText, [ADelim]);
  end;
end;

function TokToStr(ATokens: TTokens; ADelim: Char): String;
begin
  Result := TokToStr(ATokens, ADelim, 1);
end;

function TokToStr(ATokens: TTokens; ADelim: Char; AStartIndex: Integer): String;
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

end.

