program MastrMnd;

uses
  Crt, MannDoor, mCrt, mStrings, mUtils, SysUtils;

const
  PegColours: Array[0..2] of Byte =
    (DARKGRAY, LIGHTBLUE, WHITE); {Blank, Right Colour Right Place, Right Colour Wrong Place}
  PieceColours: Array[0..6] of Byte =
    (DARKGRAY, LIGHTGREEN, LIGHTCYAN, LIGHTRED, LIGHTMAGENTA, YELLOW, WHITE); {Blank, 6 Colours}
  PROG_VER  = 'Mastermind v3.08.30';

type
  TPegs = Array[1..4] of Byte;
  TPieces = Array[1..4] of Byte;

  TLine = record
    Peg: TPegs;
    Piece: TPieces;
  end;

  TStatusBar = Record
    Current: Integer; { The index (1 based) of the current status bar }
    Count: Integer;   { The number of status bars }
  end;

var
   Answer: TPieces;              {The 4 colours used in the answer}
   Colour: Byte;                 {The current colour (1..6)}
   CurLine, CurPiece: Byte;      {Current position on board}
   GameOver: Boolean;            {Did we win or lose?}
   Lines: Array[1..10] of TLine; {Our guess history}
   StatusBar: TStatusBar;        {Information about the status bar}

procedure DrawAnswer; forward;
procedure RedrawScreen; forward;

{$I AMAIN.INC}

{ Update the message line with a new MSG }
procedure ChangeMsg(Msg: String);
begin
     mGotoXY(26, 22);
     mTextAttr(31);
     mWrite(PadRight(Msg, ' ', 54));
end;

{ Check TEMPLINE against the ANSWER, looking for right colour in right spot
  Return CNT which is the number of black pegs found }
function CheckBlackPegs(var TempLine: TLine): Byte;
var
   I, Cnt: Integer;
begin
     Cnt := 0;
     for I := 1 to 4 do
     begin
          if (TempLine.Piece[I] = Answer[I]) then
          begin
               Inc(Cnt);
               TempLine.Piece[I] := 0;
               TempLine.Peg[Cnt] := 1;
          end;
     end;
     CheckBlackPegs := Cnt;
end;

{ Check to see if we ran out of guesses }
procedure CheckLost;
begin
     if (CurLine = 10) then
     begin
          GameOver := True;
          ChangeMsg('Game Over, You Lose!');
          DrawAnswer;
     end;
end;

{ Check to see that the current line is valid
  It isn't if there are duplicate or blank pieces }
function CheckValid: Boolean;
var
   I, J: Integer;
begin
     CheckValid := True;
     for I := 1 to 4 do
     begin
          if (Lines[CurLine].Piece[I] = 0) then
          begin
               ChangeMsg('You Must Pick Four Colours');
               CheckValid := False;
               Exit;
          end;
          for J := 1 to 4 do
          begin
               if (Lines[CurLine].Piece[I] = Lines[CurLine].Piece[J]) and (I <> J) then
               begin
                    ChangeMsg('You Must Pick Four Unique Colours');
                    CheckValid := False;
                    Exit;
               end;
          end;
     end;
end;


{ Check TEMPLINE against the ANSWER, looking for right colour in wrong spot
  Return CNT - BLACK which is the number of white pegs found }
function CheckWhitePegs(var TempLine: TLine): Byte;
var
   I, J, Black, Cnt: Integer;
begin
     Cnt := 4;
     for I := 1 to 4 do
     begin
          if (TempLine.Peg[I] = 0) then
          begin
               Cnt := I - 1;
               Break;
          end;
     end;

     Black := Cnt;
     if (Cnt < 4) then
     begin
          for I := 1 to 4 do
          begin
               for J := 1 to 4 do
               begin
                    if (TempLine.Piece[I] = Answer[J]) then
                    begin
                         Inc(Cnt);
                         TempLine.Piece[I] := 0;
                         TempLine.Peg[Cnt] := 2;
                    end;
               end;
          end;
     end;
     CheckWhitePegs := Cnt - Black;
end;

{ Check to see if all four pegs are black }
function CheckWon: Boolean;
var
   I: Integer;
   Res: Boolean;
begin
     Res := True;
     for I := 1 to 4 do
     begin
          if (Lines[CurLine].Peg[I] <> 1) then
             Res := False;
     end;
     if (Res) then
     begin
          GameOver := True;
          ChangeMsg('Congratulations, You Win!');
          DrawAnswer;
     end;
     CheckWon := Res;
end;

{ Draw the answer line }
procedure DrawAnswer;
var
   I: Integer;
begin
     for I := 1 to 4 do
     begin
          mGotoXY(4 + ((I - 1) * 4), 2);
          mTextAttr(PieceColours[Answer[I]]);
          mWrite(#219#219);
     end;
end;

{ Highlight the currently selected colour }
procedure DrawColour;
begin
     mGotoXY(32, 8 + Colour);
     mTextAttr(PieceColours[Colour] + (7 * 16));
     mWrite(#254#254);
end;

{ Draw the pegs for the current line }
procedure DrawPegs;
var
   I: Integer;
begin
     for I := 1 to 4 do
     begin
          mGotoXY(14 + (I - 1), 22 - ((CurLine - 1) * 2));
          mTextAttr(PegColours[Lines[CurLine].Peg[I]]);
          mWrite(#249);
     end;
end;

{ Highlight the currently selected piece }
procedure DrawPiece;
begin
     mGotoXY(3 + ((CurPiece - 1) * 2), 22 - ((CurLine - 1) * 2));
     mTextAttr(7);
     mWrite('[ ]');
     mGotoXY(4 + ((CurPiece - 1) * 2), 22 - ((CurLine - 1) * 2));
     mTextAttr(PieceColours[Lines[CurLine].Piece[CurPiece]]);
     mWrite(#254);
end;

{ Un-highlight the current colour }
procedure EraseColour;
begin
     mGotoXY(32, 8 + Colour);
     mTextAttr(PieceColours[Colour]);
     mWrite(#254#254);
end;

{ Un-highlight the current piece }
procedure ErasePiece;
begin
     mGotoXY(3 + ((CurPiece - 1) * 2), 22 - ((CurLine - 1) * 2));
     mTextAttr(0);
     mWrite('   ');
     mGotoXY(4 + ((CurPiece - 1) * 2), 22 - ((CurLine - 1) * 2));
     mTextAttr(PieceColours[Lines[CurLine].Piece[CurPiece]]);
     mWrite(#254);
end;

{ Generate a random ANSWER line }
procedure GenerateAnswer;
var
   A: Array[1..6] of Byte;
   I, Num: Integer;
begin
     for I := 1 to 6 do
         A[I] := I;

     for I := 1 to 4 do
     begin
          repeat
                Num := Random(6) + 1;
          until (A[Num] <> 0);
          A[Num] := 0;
          Answer[I] := Num;
     end;
end;

{ Guess the current line
  First validate, then check for black pegs, then white pegs, then
  check for a win, then for a loss }
procedure GuessLine;
var
   Black, White: Byte;
   TempLine: TLine;
begin
     if (CheckValid) then
     begin
          TempLine := Lines[CurLine];
          Black := CheckBlackPegs(TempLine);
          White := CheckWhitePegs(TempLine);
          Lines[CurLine].Peg := TempLine.Peg;
          if Not(CheckWon) then
             CheckLost;
          DrawPegs;
          if (GameOver) then
          begin
               EraseColour;
               ErasePiece;
          end else
          begin
               ChangeMsg('You Scored ' + IntToStr(Black) + ' Black Peg(s) and ' + IntToStr(White) + ' White Peg(s)');
               ErasePiece;
               CurPiece := 1;
               Inc(CurLine);
               DrawPiece;
          end;
     end;
end;

{ Move the current colour up or down (negative = up, positive = down) }
procedure MoveColour(Offset: ShortInt);
begin
     EraseColour;
     Colour := Colour + Offset;
     if (Colour > 6) then
        Colour := 1;
     if (Colour < 1) then
        Colour := 6;
     DrawColour;
end;

{ Move the current piece left or right (negative=left, positive = right) }
procedure MovePiece(Offset: ShortInt);
begin
     ErasePiece;
     CurPiece := CurPiece + Offset;
     if (CurPiece > 4) then
        CurPiece := 1;
     if (CurPiece < 1) then
        CurPiece := 4;
     DrawPiece;
end;

{ Start a new game }
procedure NewGame;
begin
     Colour := 1;
     GameOver := False;
     CurLine := 1;
     CurPiece := 1;
     FillChar(Lines, SizeOf(Lines), 0);
     RedrawScreen;
     GenerateAnswer;
end;

{ Place the currently selected colour at the current place on the board }
procedure PlacePiece;
begin
     Lines[CurLine].Piece[CurPiece] := Colour;
     MovePiece(+1);
end;

{ Redraw the pieces and pegs on the board }
procedure RedrawBoard;
var
   X, Y: Integer;
begin
     for Y := 1 to 10 do
     begin
          for X := 1 to 4 do
          begin
               mGotoXY(4 + ((X - 1) * 2), 22 - ((Y - 1) * 2));
               mTextAttr(PieceColours[Lines[Y].Piece[X]]);
               mWrite(#254);
               mGotoXY(14 + (X - 1), 22 - ((Y - 1) * 2));
               mTextAttr(PegColours[Lines[Y].Peg[X]]);
               mWrite(#249);
          end;
     end;
end;

{ Redraw the entire screen }
procedure RedrawScreen;
begin
     ShowMainAns;
     RedrawBoard;
     DrawPiece;
     DrawColour;
end;

{ Event for when an unknown command-line parameter is found }
procedure _OnCLP(AKey: Char; AValue: String); far;
begin
     { This function is useless in this program, but I included it so you
       could see how it's used.  In something like an IRC client where you
       want to be able to specify what server to connect to, it would be
       useful.  The user could pass -Slocalhost, and then this function
       would get an AKey value of "S" and an AValue value of "localhost" }
     case AKey of
          'X': WriteLn('Parameter -X passed with value of: ' + AValue);
     end;
end;

{ Event for when the user drops carrier }
procedure _OnHangup; far;
begin
     ChangeMsg('Caller Dropped Carrier');
     Delay(2500);
     Halt;
end;

{ Event for when the status bar needs updating }
procedure _OnStatusBar; far;
begin
     case StatusBar.Current of
          1: begin
                  FastWrite('þ                        þ           þ          þ             þ                þ', 1, 25, 30);
                  FastWrite(PadRight(DropInfo.RealName, ' ', 22), 3, 25, 31);
                  FastWrite('F1 = HELP', 28, 25, 31);
                  FastWrite('MASTRMND', 40, 25, 31);
                  FastWrite(PadRight('Idle: ' + SecToMS(SecElapsed(LastKey.Time, SecToday)), ' ', 11), 51, 25, 31);
                  FastWrite('Left: ' + SecToHMS(mTimeLeft), 65, 25, 31);
             end;
          2: begin
                  FastWrite('þ                        þ                      þ                þ             þ', 1, 25, 30);
                  FastWrite(PadRight(DropInfo.RealName, ' ', 22), 3, 25, 31);
                  FastWrite('F1: Toggle StatusBar', 28, 25, 31);
                  FastWrite('Alt-H: Hang-Up', 51, 25, 31);
                  FastWrite('Alt-K: Kick', 68, 25, 31);
             end;
          3: begin
                  FastWrite(PadRight('', ' ', 80), 1, 25, 31);
                  FastWrite(PROG_VER + ' Is A MannDoor Example Program - http://www.mannsoft.ca/', 2, 25, 31);
             end;
     end;
end;

{ Event for when the sysop hits a key locally }
function _OnSysopKey(AKey: Char): Boolean; far;
begin
     _OnSysopKey := False;

     case AKey of
          #35: begin {ALT-H}
                    _OnSysopKey := True;
                    ChangeMsg('You Are Unworthy (The SysOp Has Disconnected You)');
                    Delay(2500);
                    mClose;
                    Halt;
               end;
          #37: begin {ALT-K}
                    _OnSysopKey := True;
                    ChangeMsg('You Are Unworthy (The SysOp Has Kicked You)');
                    Delay(2500);
                    Halt;
               end;
          #59: begin {F1}
                    _OnSysopKey := True;
                    if (StatusBar.Current = StatusBar.Count) then
                       StatusBar.Current := 1
                    else
                        Inc(StatusBar.Current);
                    if Assigned(mOnStatusBar) then
                       mOnStatusBar;
               end;
     end;
end;

{ Event for when the user idles too long }
procedure _OnTimeOut; far;
begin
     ChangeMsg('Come Back When You''re Awake (Idle Limit Exceeded)');
     Delay(2500);
     Halt;
end;

{ Event for when the user needs an idle warning }
procedure _OnTimeOutWarning(AMinutes: Byte); far;
begin
     ChangeMsg(IntToStr(AMinutes) + ' Minutes Until You''re Kicked For Idling');
end;

{ Event for when the user runs out of time }
procedure _OnTimeUp; far;
begin
     ChangeMsg('Come Back When You Have More Time (Ran Out Of Time');
     Delay(2500);
     Halt;
end;

{ Event for when the user needs a time warning }
procedure _OnTimeUpWarning(AMinutes: Byte); far;
begin
     ChangeMsg(IntToStr(AMinutes) + ' Minutes Remaining This Call');
end;

{ The start of the program }
var
   Ch: Char;
begin
     Randomize;
     StatusBar.Count := 3;
     StatusBar.Current := 1;

     mOnCLP := _OnCLP;
     mOnHangup := _OnHangup;
     mOnStatusBar := _OnStatusBar;
     mOnSysopKey := _OnSysopKey;
     mOnTimeOut := _OnTimeOut;
     mOnTimeOutWarning := _OnTimeOutWarning;
     mOnTimeUp := _OnTimeUp;
     mOnTimeUpWarning := _OnTimeUpWarning;
     mStartUp;

     NewGame;
     ChangeMsg('Welcome to ' + PROG_VER);
     repeat
           Ch := UpCase(mReadKey);
           if (GameOver) and Not(Ch in ['N', 'Q']) then
              Continue;
           case Ch of
                '2': MoveColour(+1);
                '4': MovePiece(-1);
                '6': MovePiece(+1);
                '8': MoveColour(-1);
                'N': if (GameOver) then
                        NewGame
                     else
                         ChangeMsg('Finish This Game First');
                #13: PlacePiece;
                #32: GuessLine;
           end;
     until (Ch = 'Q');
end.
