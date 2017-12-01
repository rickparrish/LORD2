unit Helpers;

{$mode objfpc}{$H+}

interface

function GetAbsolutePath(AFileName: String): String;

implementation

uses
  Door,
  SysUtils;

function GetAbsolutePath(AFileName: String): String;
begin
  AFileName := StringReplace(AFileName, '`*', IntToStr(DoorDropInfo.Node), [rfReplaceAll, rfIgnoreCase]);
  Result := ExpandFileName(AFileName);
end;

end.

