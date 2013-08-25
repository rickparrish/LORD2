unit Compat;

interface

uses
  Dos;

{$IFDEF FPC}
type 
  SmallWord = Word;
{$ELSE}
type 
  SmallInt  = Integer;
  SmallWord = Word;
{$ENDIF}

const
  SLASH_CHAR = '\';

procedure TimeSlice;

implementation

procedure TimeSlice;
var
  Regs: Registers;
begin
     Regs.AX := $1680;
     Intr($2F, Regs);
end;

end.
