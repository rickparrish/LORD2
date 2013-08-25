unit Compat;

interface

uses
  Linux;

type
  SmallWord = Word;

const
  SLASH_CHAR = '/';

procedure TimeSlice;

implementation

procedure TimeSlice;
begin
     select(0, nil, nil, nil, 1);
end;

end.
