unit Compat;

interface

uses
  Windows;

{$IFNDEF VPASCAL}
type 
  SmallWord = Word;
{$ENDIF}

const SLASH_CHAR = '\';

procedure TimeSlice;

implementation

procedure TimeSlice;
begin
     Sleep(1);
end;

end.
