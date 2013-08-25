unit SysUtils;

interface

uses
  Dos;

function ExtractFileName(AFile: String): String;
function ExtractFilePath(AFile: String): String;
function FileExists(AFile: String): Boolean;
function IntToStr(ANum: LongInt): String;
function StrToIntDef(AStr: String; ADef: LongInt): LongInt;
function UpperCase(AStr: String): String;

implementation

{
  Returns the filename portion of a string
  IE: C:\WINDOWS\SYSTEM.INI returns SYSTEM.INI
}
function ExtractFileName(AFile: String): String;
var
  D: DirStr;
  N: NameStr;
  E: ExtStr;
begin
     FSplit(AFile, D, N, E);
     ExtractFileName := N + E;
end;

{
  Returns the path portion of a string
  IE: C:\WINDOWS\SYSTEM.INI returns C:\WINDOWS\
}
function ExtractFilePath(AFile: String): String;
var
  D: DirStr;
  N: NameStr;
  E: ExtStr;
begin
     FSplit(AFile, D, N, E);
     ExtractFilePath := D;
end;

{
  Returns TRUE or FALSE depending on if AFile exists
}
function FileExists(AFile: String): Boolean;
var
  F: File of Byte;
begin
     Assign(F, AFile);
     {$I-}Reset(F);{$I+}
     if (IOResult = 0) then
     begin
          Close(F);
          FileExists := True;
     end else
         FileExists := False;
end;

{
  Returns ANum as a string value
}
function IntToStr(ANum: LongInt): String;
var
  S: String;
begin
     Str(ANum, S);
     IntToStr := S;
end;

{
  Returns AStr as an integer value if AStr is numeric
  Returns ADef if AStr is not numeric
}
function StrToIntDef(AStr: String; ADef: LongInt): LongInt;
var
  I: LongInt;
  Err: Integer;
begin
     Val(AStr, I, Err);
     if (Err <> 0) then
        I := ADef;
     StrToIntDef := I;
end;

{
  Returns AStr in all upper case letters
}
function UpperCase(AStr: String): String;
var
  I: Integer;
begin
     for I := 1 to Length(AStr) do
         AStr[I] := UpCase(AStr[I]);
     UpperCase := AStr;
end;

end.
