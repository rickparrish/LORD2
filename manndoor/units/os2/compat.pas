unit Compat;

interface

uses
  OS2Base;

{$IFNDEF VPASCAL}
type
  SmallWord = Word;
{$ENDIF}

const
  SLASH_CHAR = '\';

procedure TimeSlice;

implementation

procedure TimeSlice;
begin
     DosSleep(1);
end;

end.
