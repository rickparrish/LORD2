unit mUtils;

interface

uses
  Crt, Dos, SysUtils;

function AppName: String;
function AppPath: String;
function GetParamStr(AFirst: Integer): String;
function Input(ADefault, AChars: String; APass: Char; AShowLen, AMaxLen, AAttr: Byte): String;
function MSecElapsed(AFirst, ASecond: LongInt): LongInt;
function MSecToday: LongInt;
function SecElapsed(AFirst, ASecond: LongInt): LongInt;
function SecToday: LongInt;

implementation

uses
  mStrings;

{
  Return the filename of the currently running application
}
function AppName: String;
begin
     AppName := ExtractFileName(ParamStr(0));
end;

{
  Return the path name with trailing backslash of the currently running app.
}
function AppPath: String;
begin
     AppPath := AddSlash(ExtractFilePath(ParamStr(0)));
end;

{
  Returns the command-line parameters starting with AFIRST as a space
  seperated string.
  So GetParamStr(2) in a program started like:
  C:\TEST.EXE THIS IS A TEST
  would return:
  'IS A TEST'
}
function GetParamStr(AFirst: Integer): String;
var
  I: Integer;
  S: String;
begin
     S := '';
     if (ParamCount > 0) and (AFirst <= ParamCount) then
     begin
          for I := AFirst to ParamCount do
              S := S + ' ' + ParamStr(I);
          Delete(S, 1, 1);
     end;
     GetParamStr := S;
end;

{
  A fancy input routine

  ADefault - The text initially displayed in the edit box
  AChars   - The characters ALLOWED to be part of the string
             Look in MSTRINGS.PAS for some defaults
  APass    - The password character shown instead of the actual text
             Use #0 if you dont want to hide the text
  AShowLen - The number of characters big the edit box should be on screen
  AMaxLen  - The number of characters the edit box should allow
             AMaxLen can be larger than AShowLen, it will just scroll
             if that happens.
  AAttr    - The text attribute of the editbox's text and background
             Use formula Attr = Foreground + (Background * 16)

  If the user pressed ESCAPE then ADefault is returned.  If they hit enter
  the current string is returned.  They cannot hit enter on a blank line.
}
function Input(ADefault, AChars: String; APass: Char; AShowLen, AMaxLen, AAttr: Byte): String;
var
  Ch: Char;
  Attr: Byte;
  S: String;
  XPos: Byte;

  procedure UpdateText;
  begin
       GotoXY(XPos, WhereY);
       if (Length(S) > AShowLen) then
       begin
            if (APass = #0) then
               Write(Copy(S, Length(S) - AShowLen + 1, AShowLen))
            else
                Write(PadRight('', APass, AShowLen));
            GotoXY(XPos + AShowLen, WhereY);
       end else
       begin
            if (APass = #0) then
               Write(S)
            else
                Write(PadRight('', APass, Length(S)));
            Write(PadRight('', ' ', AShowLen - Length(S)));
            GotoXY(XPos + Length(S), WhereY);
       end;
  end;

begin
     if (Length(ADefault) > AMaxLen) then
        ADefault := Copy(ADefault, 1, AMaxLen);
     S := ADefault;

     Attr := TextAttr;
     TextAttr := AAttr;
     XPos := WhereX;

     UpdateText;

     repeat
           Ch := ReadKey;
           if (Ch = #8) and (Length(S) > 0) then
           begin
                Delete(S, Length(S), 1);
                Write(#8 + ' ' + #8);
                if (Length(S) >= AShowLen) then
                   UpdateText;
           end else
           if (Ch = #25) and (S <> '') then {CTRL-Y}
           begin
                S := '';
                UpdateText;
           end else
           if (Pos(Ch, AChars) > 0) and (Length(S) < AMaxLen) then
           begin
                S := S + Ch;
                if (Length(S) > AShowLen) then
                   UpdateText
                else
                if (APass = #0) then
                   Write(Ch)
                else
                    Write(APass);
           end;
     until (Ch = #27) or ((Ch = #13) and (S <> ''));

     TextAttr := Attr;
     WriteLn;

     if (Ch = #27) then
        S := ADefault;
     Input := S;
end;

{
  Returns the number of milliseconds elapsed between AFIRST and ASECOND
  Handles midnight rollover
}
function MSecElapsed(AFirst, ASecond: LongInt): LongInt;
begin
     if (ASecond < AFirst) then
        Inc(ASecond, 86400 * 1000);
     MSecElapsed := ASecond - AFirst;
end;

{
  Returns the number of milliseconds which have elapsed since midnight
}
function MSecToday: LongInt;
var
  H, M, S, Hund: Word;
  H2, M2, S2, Hund2: LongInt;
begin
     GetTime(H, M, S, Hund);
     H2 := H;
     M2 := M;
     S2 := S;
     Hund2 := Hund;
     MSecToday := (((H2 * 3600) + (M2 * 60) + S2) * 1000) + (Hund2 * 10);
end;

{
  Same as MSecElapsed(), but returns value in seconds
}
function SecElapsed(AFirst, ASecond: LongInt): LongInt;
begin
     if (ASecond < AFirst) then
        Inc(ASecond, 86400);
     SecElapsed := ASecond - AFirst;
end;

{
  Same as SecToday(), but returns value in seconds
}
function SecToday: LongInt;
begin
     SecToday := MSecToday div 1000;
end;

end.
