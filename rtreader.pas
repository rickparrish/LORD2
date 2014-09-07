unit RTReader;

{$mode objfpc}{$h+}

interface

uses
  RTChoiceOption, RTGlobal, RTRefLabel, RTRefFile, RTRefSection, Struct,
  Ansi, Door, StringUtils, VideoUtils,
  Classes, contnrs, Crt, Math, StrUtils, SysUtils;

const
  FVersion: Integer = 99;

type
  TRTReader = class
  private
    FCurrentLabel: TRTRefLabel;
    FCurrentLineNumber: LongInt;
    FCurrentFile: TRTRefFile;
    FCurrentSection: TRTRefSection;

    FInBEGINCount: Integer;
    FInBUYMANAGER: Boolean;
    FInBUYMANAGEROptions: TStringList;
    FInCHOICE: Boolean;
    FInCHOICEOptions: TFPObjectList;
    FInCLOSESCRIPT: Boolean;
    FInDO_ADDLOG: Boolean;
    FInDO_WRITE: Boolean;
    FInFIGHT: Boolean;
    FInFIGHTLines: TStringList;
    FInIFFalse: Integer;
    FInREADFILE: String;
    FInREADFILELines: TStringList;
    FInSAY: Boolean;
    FInSAYBAR: Boolean;
    FInSELLMANAGER: Boolean;
    FInSELLMANAGEROptions: TStringList;
    FInSHOW: Boolean;
    FInSHOWLOCAL: Boolean;
    FInSHOWSCROLL: Boolean;
    FInSHOWSCROLLLines: TStringList;
    FInWRITEFILE: String;

    procedure AssignVariable(AVariable: String; AValue: String);

    procedure CommandADDCHAR(ATokens: TTokens);
    procedure CommandBEGIN(ATokens: TTokens);
    procedure CommandBITSET(ATokens: TTokens);
    procedure CommandBUSY(ATokens: TTokens);
    procedure CommandBUYMANAGER(ATokens: TTokens);
    procedure CommandCHECKMAIL(ATokens: TTokens);
    procedure CommandCHOICE(ATokens: TTokens);
    procedure CommandCHOOSEPLAYER(ATokens: TTokens);
    procedure CommandCLEAR(ATokens: TTokens);
    procedure CommandCLEARBLOCK(ATokens: TTokens);
    procedure CommandCLOSESCRIPT(ATokens: TTokens);
    procedure CommandCONVERT_FILE_TO_ANSI(ATokens: TTokens);
    procedure CommandCONVERT_FILE_TO_ASCII(ATokens: TTokens);
    procedure CommandCOPYFILE(ATokens: TTokens);
    procedure CommandDATALOAD(ATokens: TTokens);
    procedure CommandDATANEWDAY(ATokens: TTokens);
    procedure CommandDATASAVE(ATokens: TTokens);
    procedure CommandDECLARE(ATokens: TTokens);
    procedure CommandDISPLAY(ATokens: TTokens);
    procedure CommandDISPLAYFILE(ATokens: TTokens);

    procedure CommandDO_ADD(ATokens: TTokens);
    procedure CommandDO_ADDLOG(ATokens: TTokens);
    procedure CommandDO_BEEP(ATokens: TTokens);
    procedure CommandDO_COPYTONAME(ATokens: TTokens);
    procedure CommandDO_DELETE(ATokens: TTokens);
    procedure CommandDO_DIVIDE(ATokens: TTokens);
    procedure CommandDO_FRONTPAD(ATokens: TTokens);
    procedure CommandDO_GETKEY(ATokens: TTokens);
    procedure CommandDO_GOTO(ATokens: TTokens);
    procedure CommandDO_IS(ATokens: TTokens);
    procedure CommandDO_MOVE(ATokens: TTokens);
    procedure CommandDO_MOVEBACK(ATokens: TTokens);
    procedure CommandDO_MULTIPLY(ATokens: TTokens);
    procedure CommandDO_NUMRETURN(ATokens: TTokens);
    procedure CommandDO_PAD(ATokens: TTokens);
    procedure CommandDO_QUEBAR(ATokens: TTokens);
    procedure CommandDO_RANDOM(ATokens: TTokens);
    procedure CommandDO_READCHAR(ATokens: TTokens);
    procedure CommandDO_READNUM(ATokens: TTokens);
    procedure CommandDO_READSPECIAL(ATokens: TTokens);
    procedure CommandDO_READSTRING(ATokens: TTokens);
    procedure CommandDO_REPLACE(ATokens: TTokens);
    procedure CommandDO_REPLACEALL(ATokens: TTokens);
    procedure CommandDO_RENAME(ATokens: TTokens);
    procedure CommandDO_SAYBAR(ATokens: TTokens);
    procedure CommandDO_STATBAR(ATokens: TTokens);
    procedure CommandDO_STRIP(ATokens: TTokens);
    procedure CommandDO_STRIPALL(ATokens: TTokens);
    procedure CommandDO_STRIPBAD(ATokens: TTokens);
    procedure CommandDO_STRIPCODE(ATokens: TTokens);
    procedure CommandDO_SUBTRACT(ATokens: TTokens);
    procedure CommandDO_TALK(ATokens: TTokens);
    procedure CommandDO_TRIM(ATokens: TTokens);
    procedure CommandDO_UPCASE(ATokens: TTokens);
    procedure CommandDO_WRITE(ATokens: TTokens);

    procedure CommandDRAWMAP(ATokens: TTokens);
    procedure CommandDRAWPART(ATokens: TTokens);
    procedure CommandEND(ATokens: TTokens);
    procedure CommandFIGHT(ATokens: TTokens);
    procedure CommandGRAPHICS(ATokens: TTokens);
    procedure CommandHALT(ATokens: TTokens);

    function CommandIF_BITCHECK(ATokens: TTokens): Boolean;
    function CommandIF_BLOCKPASSABLE(ATokens: TTokens): Boolean;
    function CommandIF_CHECKDUPE(ATokens: TTokens): Boolean;
    function CommandIF_EXIST(ATokens: TTokens): Boolean;
    function CommandIF_INSIDE(ATokens: TTokens): Boolean;
    function CommandIF_IS(ATokens: TTokens): Boolean;
    function CommandIF_LESS(ATokens: TTokens): Boolean;
    function CommandIF_MORE(ATokens: TTokens): Boolean;
    function CommandIF_NOT(ATokens: TTokens): Boolean;

    procedure CommandITEMEXIT(ATokens: TTokens);
    procedure CommandKEY(ATokens: TTokens);
    procedure CommandLABEL(ATokens: TTokens);
    procedure CommandLOADCURSOR(ATokens: TTokens);
    procedure CommandLOADGLOBALS(ATokens: TTokens);
    procedure CommandLOADMAP(ATokens: TTokens);
    procedure CommandLOADWORLD(ATokens: TTokens);
    procedure CommandLORDRANK(ATokens: TTokens);
    procedure CommandMOREMAP(ATokens: TTokens);
    procedure CommandNAME(ATokens: TTokens);
    procedure CommandNOCHECK(ATokens: TTokens);
    procedure CommandNOP(ATokens: TTokens);
    procedure CommandOFFMAP(ATokens: TTokens);
    procedure CommandOVERHEADMAP(ATokens: TTokens);
    procedure CommandPAUSEOFF(ATokens: TTokens);
    procedure CommandPAUSEON(ATokens: TTokens);
    procedure CommandPROGNAME(ATokens: TTokens);
    procedure CommandRANK(ATokens: TTokens);
    procedure CommandREADFILE(ATokens: TTokens);
    procedure CommandROUTINE(ATokens: TTokens);
    procedure CommandRUN(ATokens: TTokens);
    procedure CommandSAVECURSOR(ATokens: TTokens);
    procedure CommandSAVEGLOBALS(ATokens: TTokens);
    procedure CommandSAVEWORLD(ATokens: TTokens);
    procedure CommandSAY(ATokens: TTokens);
    procedure CommandSELLMANAGER(ATokens: TTokens);
    procedure CommandSHOW(ATokens: TTokens);
    procedure CommandSHOWLOCAL(ATokens: TTokens);
    procedure CommandUPDATE(ATokens: TTokens);
    procedure CommandUPDATE_UPDATE(ATokens: TTokens);
    procedure CommandVERSION(ATokens: TTokens);
    procedure CommandWHOISON(ATokens: TTokens);
    procedure CommandWRITEFILE(ATokens: TTokens);

    procedure EndBUYMANAGER;
    procedure EndCHOICE;
    procedure EndFIGHT;
    procedure EndREADFILE;
    procedure EndSAYBAR(AText: String);
    procedure EndSELLMANAGER;
    procedure EndSHOWSCROLL;

    procedure Execute(AFileName: String; ASectionName: String; ALabelName: String);

    procedure LogTODO(ATokens: TTokens);

    procedure ParseCommand(ATokens: TTokens);
    procedure ParseScript(ALines: TStringList);

    function TranslateVariables(AText: String): String;
  public
    constructor Create;
    destructor Destroy; override;
  end;

procedure Execute(AFileName: String; ASectionName: String);
procedure Execute(AFileName: String; ASectionName: String; ALabelName: String);

implementation

uses
  Game;

procedure TRTReader.AssignVariable(AVariable: String; AValue: String);
var
  VariableUpper: String;
  VariableSkipTwo: String;
begin
  VariableUpper := UpperCase(Trim(AVariable));

  // Handle variables that must match exactly
  case VariableUpper of
    'BANK': Game.Player.bank := StrToInt(ExtractDelimited(1, AValue, [' ']));
    'DEAD': Game.Player.dead := StrToInt(ExtractDelimited(1, AValue, [' ']));
    'ENEMY': Game.ENEMY := AValue;
    'MAP': Game.Player.map := StrToInt(ExtractDelimited(1, AValue, [' ']));
    'MONEY': Game.Player.Money := StrToInt(ExtractDelimited(1, AValue, [' ']));
    'NARM': Game.Player.ArmourNumber := StrToInt(ExtractDelimited(1, AValue, [' ']));
    'NWEP': Game.Player.WeaponNumber := StrToInt(ExtractDelimited(1, AValue, [' ']));
    'SEXMALE': Game.Player.SexMale := StrToInt(ExtractDelimited(1, AValue, [' ']));
    'X': Game.Player.x := StrToInt(ExtractDelimited(1, AValue, [' ']));
    'Y': Game.Player.y := StrToInt(ExtractDelimited(1, AValue, [' ']));
    else
    begin
      // Handle global and player variables
      VariableSkipTwo := Copy(VariableUpper, 3, Length(VariableUpper) - 2);
      if (Pos('`I', VariableUpper) = 1) then
      begin
          // Player int
          Game.Player.I[StrToInt(VariableSkipTwo)] := StrToInt(ExtractDelimited(1, AValue, [' ']));
      end;
      if (Pos('`P', VariableUpper) = 1) then
      begin
          // Player longint
          Game.Player.P[StrToInt(VariableSkipTwo)] := StrToInt(ExtractDelimited(1, AValue, [' ']));
      end;
      if (Pos('`+', VariableUpper) = 1) then
      begin
          // Global item name
          Game.ItemsDat.Item[StrToInt(VariableSkipTwo)].name := AValue;
      end;
      if (Pos('`S', VariableUpper) = 1) then
      begin
          // Global string
          Game.WorldDat.S[StrToInt(VariableSkipTwo)] := AValue;
      end;
      if (Pos('`T', VariableUpper) = 1) then
      begin
          // Player byte
          Game.Player.T[StrToInt(VariableSkipTwo)] := StrToInt(ExtractDelimited(1, AValue, [' ']));
      end;
      if (Pos('`V', VariableUpper) = 1) then
      begin
          // Global longint
          Game.WorldDat.V[StrToInt(VariableSkipTwo)] := StrToInt(ExtractDelimited(1, AValue, [' ']));
      end;
    end;
  end;
end;

procedure Execute(AFileName: String; ASectionName: String);
begin
  Execute(AFileName, ASectionName, '');
end;

procedure Execute(AFileName: String; ASectionName: String; ALabelName: String);
var
  RTR: TRTReader;
begin
  AFileName := UpperCase(Trim(ChangeFileExt(AFileName, '')));
  ASectionName := UpperCase(Trim(ASectionName));
  ALabelName := UpperCase(Trim(ALabelName));

  RTR := TRTReader.Create();
  RTR.Execute(AFileName, ASectionName, ALabelName);
  RTR.Free;
end;

constructor TRTReader.Create;
begin
  inherited Create;

  FInBEGINCount := 0;
  FInBUYMANAGER := false;
  FInBUYMANAGEROptions := TStringList.Create;
  FInCHOICE := false;
  FInCHOICEOptions := TFPObjectList.Create;
  FInCLOSESCRIPT := false;
  FInDO_ADDLOG := false;
  FInDO_WRITE := false;
  FInFIGHT := false;
  FInFIGHTLines := TStringList.Create;
  FInIFFalse := 999;
  FInREADFILE := '';
  FInREADFILELines := TStringList.Create;
  FInSAY := false;
  FInSAYBAR := false;
  FInSELLMANAGER := false;
  FInSELLMANAGEROptions := TStringList.Create;
  FInSHOW := false;
  FInSHOWLOCAL := false;
  FInSHOWSCROLL := false;
  FInSHOWSCROLLLines := TStringList.Create;
  FInWRITEFILE := '';
end;

destructor TRTReader.Destroy;
begin
  inherited Destroy;
end;

procedure TRTReader.CommandADDCHAR(ATokens: TTokens);
var
  FTraderDat: File of TraderDatRecord;
  FUpdateTmp: File of UpdateTmpRecord;
  UTR: UpdateTmpRecord;
begin
  (* @ADDCHAR
      This command adds a new character to the TRADER.DAT file.  This command is
      used in the @#newplayer routine in gametxt.ref.  Make sure you do an
      @READSTRING, @DO COPYTONAME, set appropriate variables including the player's
      X and Y coordinates and map block number before issuing this command.  Failure
      to do this can result in a corrupted TRADER.DAT file. *)
  // TODO Retry if IOError
  Assign(FTraderDat, TraderDatFileName);
  if (FileExists(TraderDatFileName)) then
  begin
    {$I-}Reset(FTraderDat);{$I+}
  end else
  begin
    {$I-}ReWrite(FTraderDat);{$I+}
  end;
  if (IOResult = 0) then
  begin
    Seek(FTraderDat, FileSize(FTraderDat));
    Write(FTraderDat, Game.Player);
    Game.PlayerNum := FileSize(FTraderDat);
  end;
  Close(FTraderDat);

  UTR.X := Game.Player.X;
  UTR.Y := Game.Player.Y;
  UTR.Map := Game.Player.Map;
  UTR.OnNow := 1;
  UTR.Busy := 0;
  UTR.Battle := 0;
  // TODO Retry if IOError
  Assign(FUpdateTmp, UpdateTmpFileName);
  if (FileExists(UpdateTmpFileName)) then
  begin
    {$I-}Reset(FUpdateTmp);{$I+}
  end else
  begin
    {$I-}ReWrite(FUpdateTmp);{$I+}
  end;
  if (IOResult = 0) then
  begin
    Seek(FUpdateTmp, Game.PlayerNum);
    Write(FUpdateTmp, UTR);
  end;
  Close(FUpdateTmp);
end;

procedure TRTReader.CommandBEGIN(ATokens: TTokens);
begin
  FInBEGINCount += 1;
end;

procedure TRTReader.CommandBITSET(ATokens: TTokens);
var
  BitToSet: LongInt;
  EndValue: LongInt;
  StartValue: LongInt;
  ValueToSet: LongInt;
  VariableName: String;
begin
  (* @BITSET <`tX> <bit> <Y>
      Sets a certain bit in byte variable X to value Y.  Y must be 0 or 1.  This lets you
      have 8 yes/no variables to each byte variable. *)
  VariableName := ATokens[2];
  StartValue := StrToInt(TranslateVariables(VariableName));
  BitToSet := StrToInt(TranslateVariables(ATokens[3]));
  ValueToSet := StrToInt(TranslateVariables(ATokens[4]));
  EndValue := StartValue OR (ValueToSet SHL BitToSet);
  AssignVariable(VariableName, IntToStr(EndValue));
end;

procedure TRTReader.CommandBUSY(ATokens: TTokens);
begin
  (* @BUSY
      This makes the player appear 'red' to other players currently playing.  It
      also tells the Lord II engine to run @#busy in gametxt.ref if a player logs on
      and someone is attacking him or giving him an item. *)
  LogTODO(ATokens);
end;

procedure TRTReader.CommandBUYMANAGER(ATokens: TTokens);
begin
  (* @BUYMANAGER
      <item number>
      <item number>
      <ect until next @ at beginning of string is hit>
      This command offers items for sale at the price set in items.dat *)
  FInBUYMANAGEROptions.Clear;
  FInBUYMANAGER := true;
end;

procedure TRTReader.CommandCHECKMAIL(ATokens: TTokens);
begin
  (* @CHECKMAIL
      Undocumented.  Will need to determine what this does *)
  LogTODO(ATokens);
end;

procedure TRTReader.CommandCHOICE(ATokens: TTokens);
begin
  (* @CHOICE
      <A choice>
      <another choice>
      <ect..When a @ is found in the beginning of a choice it quits>
      This gives the user a choice using a lightbar.
      The responce is put into varible RESPONCE.  This may also be spelled RESPONSE.
      To set which choice the cursor starts on, put that number into `V01.
      ** EXAMPLE OF @CHOICE COMMAND **
      @DO `V01 IS 1 ;which choice should be highlighted when they start
      (now the actual choice command)
      @CHOICE
      Yes   <- Defaults to this, since it's 1
      No
      I don't know
      Who cares
      @IF RESPONCE IS 3 THEN DO
        @BEGIN
        @DO `P01 IS RESPONCE
        @SHOW

      You chose `P01!, silly boy!

        @END
      The choice command is more useful now; you can now define *IF* type statements
      so a certain choice will only be there if a conditional statement is met.
      For instance:
      @CHOICE
      Yes
      No
      =`p20 500 Hey, I have 500 exactly!
      !`p20 500 Hey, I have anything BUT 500 exactly!
      >`p20 500 Hey, I have MORE than 500!
      <`p20 100 Hey, I have LESS than 100!
      >`p20 100 <`p20 500 I have more then 100 and less than 500!
      Also:  You can check the status of individual bits in a `T player byte.  The
      bit is true or false, like this:
      +`t12 1 Hey! Byte 12's bit 1 is TRUE! (which is 1)
      -`t12 3 Hey! Byte 12's bit 3 is FALSE! (which is 0)

      The = > and < commands can be stacked as needed.  In the above example, if
      `p20 was 600, only options 1, 2, 4, and 5 would be available, and RESPONSE
      would be set to the correct option if one of those were selected.  For
      example, if `p20 was 600 and the user hit the selection:
      "Hey, I have more than 500", RESPONSE would be set to 5. *)

  FInCHOICEOptions.Clear;
  FInCHOICE := true;
end;

procedure TRTReader.CommandCHOOSEPLAYER(ATokens: TTokens);
begin
  (* @CHOOSEPLAYER `p20
      This will prompt user for another players name - its the standard 'full or
      partial name' prompt, with a 'you mean this guy?'.  It returns the players #
      or 0 if none.  If the player isn't found it will display "No one by that name
      lives 'round here" and return 0. *)
  LogTODO(ATokens);
end;

procedure TRTReader.CommandCLEAR(ATokens: TTokens);
var
  Y: Integer;
begin
  case UpperCase(ATokens[2]) of
    'ALL':
    begin
      (* @CLEAR ALL
          This clears user text, picture, game text, name and redraws screen. *)
      CommandCLEAR(StrToTok('@CLEAR USERSCREEN', ' '));
      CommandCLEAR(StrToTok('@CLEAR PICTURE', ' '));
      CommandCLEAR(StrToTok('@CLEAR TEXT', ' '));
      CommandCLEAR(StrToTok('@CLEAR NAME', ' '));
    end;
    'NAME':
    begin
      (* @CLEAR NAME
          This deletes the name line of the game window. *)
      DoorGotoXY(55, 15);
      DoorWrite(PadRight('', 22));
    end;
    'PICTURE':
    begin
      (* @CLEAR PICTURE
          This clears the picture. *)
      for Y := 3 to 13 do
      begin
          DoorGotoXY(55, y);
          DoorWrite(PadRight('', 22));
      end;
    end;
    'SCREEN':
    begin
      (* @CLEAR SCREEN
          This command clears the entire screen. *)
      DoorClrScr;
    end;
    'TEXT':
    begin
      (* @CLEAR TEXT
          This clears game text. *)
      for Y := 3 to 13 do
      begin
          DoorGotoXY(32, y);
          DoorWrite(PadRight('', 22));
      end;
    end;
    'USERSCREEN':
    begin
      (* @CLEAR USERSCREEN
          This clears user text. *)
      for Y := 16 to 23 do
      begin
          DoorGotoXY(1, y);
          DoorWrite(PadRight('', 80));
      end;
      DoorGotoXY(78, 23);
    end;
    else
      LogTODO(ATokens);
  end;
end;

procedure TRTReader.CommandCLEARBLOCK(ATokens: TTokens);
var
  Bottom: Integer;
  I: Integer;
  SavedTextAttr: Integer;
  Top: Integer;
begin
  (* @CLEARBLOCK <x> <y>
      This clears lines quick.  <x> is the first line you want to clear. <y> is the
      last line you want to clear.  Example:  @clear block 20 24   This would clear
      4 lines starting at line 20. *)
  SavedTextAttr := Crt.TextAttr;
  DoorTextAttr(7);

  Top := StrToInt(ATokens[2]);
  Bottom := StrToInt(ATokens[3]);
  for I := Top to Bottom do
  begin
      DoorGotoXY(1, i);
      DoorWrite(PadRight('', 80));
  end;

  DoorGotoXY(1, bottom);
  DoorTextColour(SavedTextAttr AND $0F);
end;

procedure TRTReader.CommandCLOSESCRIPT(ATokens: TTokens);
begin
  (* @CLOSESCRIPT
      This closes the script and returns command to the L2 movement system. *)
  FInCLOSESCRIPT := true;
end;

procedure TRTReader.CommandCONVERT_FILE_TO_ANSI(ATokens: TTokens);
begin
  (* @CONVERT_FILE_TO_ANSI <input file> <output file>
      Converts a text file of Sethansi (whatever) to regular Ansi  This is good for
      a final score output. *)
  LogTODO(ATokens);
end;

procedure TRTReader.CommandCONVERT_FILE_TO_ASCII(ATokens: TTokens);
begin
  (* @CONVERT_FILE_TO_ASCII <input file> <output file>
      Converts a text file of Sethansi (whatever) to regular ascii, ie, no colors at
      all. *)
  LogTODO(ATokens);
end;

procedure TRTReader.CommandCOPYFILE(ATokens: TTokens);
var
  DestFile: TFileStream;
  DestFileName: String;
  SourceFile: TFileStream;
  SourceFileName: String;
begin
  (* @COPYFILE <input filename> <output filename>
      This command copies a <input filename to <output filename>.           *)
  SourceFileName := Game.GetSafeAbsolutePath(TranslateVariables(ATokens[2]));
  DestFileName := Game.GetSafeAbsolutePath(TranslateVariables(ATokens[3]));
  if ((SourceFileName <> '') AND (DestFileName <> '') AND (FileExists(SourceFileName))) then
  begin
    // TODO Error handling
    SourceFile := TFileStream.Create(SourceFileName, fmOpenRead);
    DestFile := TFileStream.Create(DestFileName, fmCreate);
    DestFile.CopyFrom(SourceFile, SourceFile.Size);
    SourceFile.Free;
    DestFile.Free;
  end;
end;

procedure TRTReader.CommandDATALOAD(ATokens: TTokens);
var
  F: File of IdfRecord;
  FileName: String;
  I: Integer;
  Idf: IdfRecord;
begin
  (* @DATALOAD <filename> <record (1 to 200)> <`p variable to put it in> : This loads
      a long integer by # from a datafile.  If the file doesn't exist, it is created
      and all 200 long integers are set to 0.
      NOTE: You should specify an extension (usually .IDF) *)
  FileName := Game.GetSafeAbsolutePath(TranslateVariables(ATokens[2]));
  if (FileName <> '') then
  begin
    if (FileExists(FileName)) then
    begin
      // TODO Error handling
      Assign(F, FileName);
      {$I-}Reset(F);{$I+}
      if (IOResult = 0) then
      begin
        Read(F, Idf);
      end;
      Close(F);

      AssignVariable(ATokens[4], IntToStr(Idf.Data[StrToInt(ATokens[3])]));
    end else
    begin
      Idf.LastUsed := Game.STime;
      for I := Low(Idf.Data) to High(Idf.Data) do
      begin
        Idf.Data[I] := 0;
      end;

      // TODO Error handling
      Assign(F, FileName);
      {$I-}ReWrite(F);{$I+}
      if (IOResult = 0) then
      begin
        Write(F, Idf);
      end;
      Close(F);

      AssignVariable(ATokens[4], '0');
    end;
  end;
end;

procedure TRTReader.CommandDATANEWDAY(ATokens: TTokens);
var
  F: File of IdfRecord;
  FileName: String;
  I: Integer;
  Idf: IdfRecord;
begin
  (* @DATANEWDAY <filename> :  If it is the NEXT day since this function was
      called, all records in <filename> will be set to 0.  Check EXAMPLE.REF in the
      LORD II archive for an example of how this works.
      NOTE: You should specify an extension (usually .IDF) *)
  FileName := Game.GetSafeAbsolutePath(TranslateVariables(ATokens[2]));
  if (FileName <> '') then
  begin
    if (FileExists(FileName)) then
    begin
      // TODO Error handling
      Assign(F, FileName);
      {$I-}Reset(F);{$I+}
      if (IOResult = 0) then
      begin
        Read(F, Idf);
      end;
      Close(F);

      if (Idf.LastUsed <> Game.STime) then
      begin
        Idf.LastUsed := Game.STime;
        for I := Low(Idf.Data) to High(Idf.Data) do
        begin
          Idf.Data[I] := 0;
        end;

        // TODO Error handling
        Assign(F, FileName);
        {$I-}ReWrite(F);{$I+}
        if (IOResult = 0) then
        begin
          Write(F, Idf);
        end;
        Close(F);
      end;
    end else
    begin
      Idf.LastUsed := Game.STime;
      for I := Low(Idf.Data) to High(Idf.Data) do
      begin
        Idf.Data[I] := 0;
      end;

      // TODO Error handling
      Assign(F, FileName);
      {$I-}ReWrite(F);{$I+}
      if (IOResult = 0) then
      begin
        Write(F, Idf);
      end;
      Close(F);
    end;
  end;
end;

procedure TRTReader.CommandDATASAVE(ATokens: TTokens);
var
  F: File of IdfRecord;
  FileName: String;
  I: Integer;
  Idf: IdfRecord;
begin
  (* @DATASAVE <filename> <record (1 to 200)> <value to make it> : This SAVES
      a long integer by # to a datafile.  If the file doesn't exist, it is created
      and all 200 long integers (except the one referenced) are set to 0.  The
      record that is referenced will be set to the value of the 3rd parameter.
      NOTE: You should specify an extension (usually .IDF) *)
  FileName := Game.GetSafeAbsolutePath(TranslateVariables(ATokens[2]));
  if (FileName <> '') then
  begin
      if (FileExists(FileName)) then
      begin
        // TODO Error handling
        Assign(F, FileName);
        {$I-}Reset(F);{$I+}
        if (IOResult = 0) then
        begin
          Read(F, Idf);
        end;
        Close(F);

        Idf.Data[StrToInt(ATokens[3])] := StrToInt(TranslateVariables(ATokens[4]));

        // TODO Error handling
        Assign(F, FileName);
        {$I-}ReWrite(F);{$I+}
        if (IOResult = 0) then
        begin
          Write(F, Idf);
        end;
        Close(F);
      end else
      begin
        Idf.LastUsed := Game.STime;
        for I := Low(Idf.Data) to High(Idf.Data) do
        begin
          Idf.Data[I] := 0;
        end;

        Idf.Data[StrToInt(ATokens[3])] := StrToInt(TranslateVariables(ATokens[4]));

        // TODO Error handling
        Assign(F, FileName);
        {$I-}ReWrite(F);{$I+}
        if (IOResult = 0) then
        begin
          Write(F, Idf);
        end;
        Close(F);
      end;
  end;
end;

procedure TRTReader.CommandDECLARE(ATokens: TTokens);
begin
  (* @DECLARE <Label/header name> <offset in decimal format> *)
  // Ignore, these commands were inserted by REFINDEX, but not used here
end;

procedure TRTReader.CommandDISPLAY(ATokens: TTokens);
var
  FileName: String;
  RefFile: TRTRefFile;
  RefSection: TRTRefSection;
  SectionName: String;
begin
  (* @DISPLAY <this> IN <this file> <options>
      This is used to display a certain part of a file.  This is compatible with the
      LORDTXT.DAT format. *)
  FileName := ChangeFileExt(UpperCase(TranslateVariables(ATokens[4])), '');
  SectionName := UpperCase(TranslateVariables(ATokens[2]));

  if (RTGlobal.RefFiles.FindIndexOf(FileName) = -1) then
  begin
    DoorWriteLn('`4`b**`b `%ERROR : `2File `0' + FileName + ' `2not found. `4`b**`b`2');
    DoorReadKey;
  end else
  begin
    RefFile := TRTRefFile(RTGlobal.RefFiles.Find(FileName));

    if (RefFile.Sections.FindIndexOf(SectionName) = -1) then
    begin
      DoorWriteLn('`4`b**`b `%ERROR : Section `0' + SectionName + ' `2not found in `0' + FileName + ' `4`b**`b`2');
      DoorReadKey;
    end else
    begin
      RefSection := TRTRefSection(RefFile.Sections.Find(SectionName));
      DoorWriteLn(TranslateVariables(RefSection.Script.Text));
    end;
  end;
end;

procedure TRTReader.CommandDISPLAYFILE(ATokens: TTokens);
var
  FileName: String;
  SL: TStringList;
begin
  (* @DISPLAYFILE <filename> <options>
      This display an entire file.  Possible options are:  NOPAUSE and NOSKIP.  Put a
      space between options if you use both. *)
  FileName := Game.GetSafeAbsolutePath(TranslateVariables(ATokens[2]));
  if (FileExists(FileName)) then
  begin
    SL := TStringList.Create;
    SL.LoadFromFile(FileName);
    DoorWrite(TranslateVariables(SL.Text));
    SL.Free;
  end;
end;

procedure TRTReader.CommandDO_ADD(ATokens: TTokens);
begin
  (* @DO <Number To Change> <How To Change It> <Change With What> *)
  if (ATokens[3] = '+') then
  begin
    AssignVariable(ATokens[2], IntToStr(StrToInt(TranslateVariables(ATokens[2])) + StrToInt(TranslateVariables(ATokens[4]))));
  end else
  if (UpperCase(ATokens[3]) = 'ADD') then
  begin
    AssignVariable(ATokens[2], TranslateVariables(ATokens[2] + TokToStr(ATokens, ' ', 4)));
  end;
end;

procedure TRTReader.CommandDO_ADDLOG(ATokens: TTokens);
begin
  (* @DO addlog
      The line UNDER this command is added to the 'lognow.txt' file. *)
  FInDO_ADDLOG := true;
end;

procedure TRTReader.CommandDO_BEEP(ATokens: TTokens);
begin
  (* @DO BEEP
      Makes a weird beep noise, locally only *)
  Beep;
end;

procedure TRTReader.CommandDO_COPYTONAME(ATokens: TTokens);
begin
  (* @DO COPYTONAME
      This will put whatever is in `S10 into `N.  (name)  This is a good way to
      allow a player to change his name or to get the name a new player wants to go
      by.  It is also useful in the @#newplayer routine to get the alias the player
      wants to go by in the game. *)
  Game.Player.Name := TranslateVariables('`S10');
end;

procedure TRTReader.CommandDO_DELETE(ATokens: TTokens);
var
  FileName: String;
begin
  (* @DO DELETE <file name>
      This command deletes the file specified by <file name>.  The file name must be
      a valid DOS file name.  There can be no spaces. *)
  // TODO Error handling
  FileName := Game.GetSafeAbsolutePath(ATokens[3]);
  if (FileExists(FileName)) then
  begin
    DeleteFile(FileName);
  end;
end;

procedure TRTReader.CommandDO_DIVIDE(ATokens: TTokens);
begin
  (* @DO <Number To Change> <How To Change It> <Change With What> *)
  AssignVariable(ATokens[2], IntToStr(StrToInt(TranslateVariables(ATokens[2])) div StrToInt(TranslateVariables(ATokens[4]))));
end;

procedure TRTReader.CommandDO_FRONTPAD(ATokens: TTokens);
var
  RequestedLength: Integer;
  StrippedStringLength: Integer;
  TranslatedStringLength: Integer;
begin
  (* @DO FRONTPAD <string variable> <length>
      This adds spaces to the front of the string until the string is as long as
      <length>. *)
  RequestedLength := StrToInt(ATokens[4]);
  StrippedStringLength := Length(SethStrip(TranslateVariables(ATokens[3])));
  TranslatedStringLength := Length(TranslateVariables(ATokens[3]));
  if (StrippedStringLength < RequestedLength) then
  begin
    // NB: We add (TranslatedStringLength - StrippedStringLength) because colour codes will be in the translated
    //     string length but not the stripped string length, and that will reduce the amount of padding added,
    //     so adding this difference accounts for that
    AssignVariable(ATokens[3], PadLeft(TranslateVariables(ATokens[3]), RequestedLength + (TranslatedStringLength - StrippedStringLength)));
  end;
end;

procedure TRTReader.CommandDO_GETKEY(ATokens: TTokens);
begin
  (* @DO GETKEY <String variable to put it in>
      This command is useful, *IF* a key IS CURRENTLY being pressed, it puts that
      key into the string variable.  Otherwise, it puts a '_' in to signal no key was
      pressed.  This is a good way to stop a loop. *)
  if (DoorKeyPressed) then
  begin
    AssignVariable(ATokens[3], DoorReadKey);
  end else
  begin
    AssignVariable(ATokens[3], '_');
  end;
end;

procedure TRTReader.CommandDO_GOTO(ATokens: TTokens);
var
  I: Integer;
  LabelName: String;
  RefSection: TRTRefSection;
begin
  (* @DO GOTO <header or label>
      Passes control of the script to the header or label specified. *)
  LabelName := UpperCase(Trim(TranslateVariables(ATokens[3])));

  if (FCurrentSection.Labels.FindIndexOf(LabelName) <> -1) then
  begin
    // LABEL goto within current section
    FCurrentLineNumber := TRTRefLabel(FCurrentSection.Labels.Find(LabelName)).LineNumber;
  end else
  if (FCurrentFile.Sections.FindIndexOf(LabelName) <> -1) then
  begin
    // HEADER goto
    RTReader.Execute(FCurrentFile.Name, LabelName);
    FInCLOSESCRIPT := true; // Don't want to resume this ref
  end else
  begin
    for I := 0 to FCurrentFile.Sections.Count - 1 do
    begin
      RefSection := TRTRefSection(FCurrentFile.Sections.Items[I]);
      if (RefSection.Labels.FindIndexOf(LabelName) <> -1) then
      begin
        // LABEL goto within a different section
        RTReader.Execute(FCurrentFile.Name, RefSection.Name, LabelName);
        FInCLOSESCRIPT := true; // Don't want to resume this ref
      end;
    end;
  end;
end;

procedure TRTReader.CommandDO_IS(ATokens: TTokens);
var
  PlayerNumber: Integer;
  TDR: TraderDatRecord;
begin
  (* @DO <Number To Change> <How To Change It> <Change With What> *)
  if (UpperCase(ATokens[4]) = 'DELETED') then
  begin
    (* @DO `p20 is deleted 8
        Puts 1 (player is deleted) or 0 (player is not deleted) in `p20.  This only
        works with `p variables.  The account number can be a `p variable. *)
    PlayerNumber := StrToInt(TranslateVariables(ATokens[5]));

    if (PlayerNumber = Game.LoadPlayerByPlayerNumber(PlayerNumber, TDR)) then
    begin
      AssignVariable(ATokens[2], IntToStr(TDR.Deleted));
    end else
    begin
      AssignVariable(ATokens[2], '0');
    end;
  end else
  if (UpperCase(ATokens[4]) = 'GETNAME') then
  begin
    (* @DO `s01 is getname 8
        This would get the name of player 8 and put it in `s01.  This only works with
        `s variables.  The account number can be a `p variable. *)
    PlayerNumber := StrToInt(TranslateVariables(ATokens[5]));

    if (PlayerNumber = Game.LoadPlayerByPlayerNumber(PlayerNumber, TDR)) then
    begin
      AssignVariable(ATokens[2], TDR.Name);
    end;
  end else
  if (UpperCase(ATokens[4]) = 'LENGTH') then
  begin
    (* @DO <number variable> IS LENGTH <String variable>
        Gets length, smart way. *)
    AssignVariable(ATokens[2], IntToStr(Length(SethStrip(TranslateVariables(ATokens[5])))));
  end else
  if (UpperCase(ATokens[4]) = 'REALLENGTH') then
  begin
    (* @DO <number variable> IS REALLENGTH <String variable>
        Gets length dumb way. (includes '`' codes without deciphering them.) *)
    AssignVariable(ATokens[2], IntToStr(Length(TranslateVariables(ATokens[5]))));
  end else
  begin
    AssignVariable(ATokens[2], TranslateVariables(TokToStr(ATokens, ' ', 4)));
  end;
end;

procedure TRTReader.CommandDO_MOVE(ATokens: TTokens);
var
  X: Integer;
  Y: Integer;
begin
  (* @DO MOVE <X> <Y> : This moves the curser.  (like GOTOXY in TP) Enter 0 for
      a number will default to 'current location'. *)
  X := StrToInt(TranslateVariables(ATokens[3]));
  Y := StrToInt(TranslateVariables(ATokens[4]));
  if ((X > 0) AND (Y > 0)) then
  begin
    DoorGotoXY(X, Y);
  end else
  if (X > 0) then
  begin
    DoorGotoX(X);
  end else
  if (Y > 0) then
  begin
    DoorGotoY(Y);
  end;
end;

procedure TRTReader.CommandDO_MOVEBACK(ATokens: TTokens);
begin
  (* @DO moveback
      This moves the player back to where he moved from.  This is good for when a
      player pushes against a treasure chest or such, and you don't want them to
      appear inside of it when they are done. *)
  Game.MoveBack;
end;

procedure TRTReader.CommandDO_MULTIPLY(ATokens: TTokens);
begin
  (* @DO <Number To Change> <How To Change It> <Change With What> *)
  AssignVariable(ATokens[2], IntToStr(StrToInt(TranslateVariables(ATokens[2])) * StrToInt(TranslateVariables(ATokens[4]))));
end;

procedure TRTReader.CommandDO_NUMRETURN(ATokens: TTokens);
var
  Count: Integer;
  I: Integer;
  Translated: String;
begin
  (* @DO NUMRETURN <int var> <string var>
      Undocumented.  Seems to return the number of integers in the given string
      Example "123test456" returns 6 because there are 6 numbers *)
  Count := 0;
  Translated := TranslateVariables(ATokens[4]);
  for I := 1 to Length(Translated) do
  begin
    if (Translated[I] in ['0'..'9']) then
    begin
      Count += 1;
    end;
  end;
  AssignVariable(ATokens[3], IntToStr(Count));
end;

procedure TRTReader.CommandDO_PAD(ATokens: TTokens);
var
  RequestedLength: Integer;
  StrippedStringLength: Integer;
  TranslatedStringLength: Integer;
begin
  (* @DO PAD <string variable> <length>
      This adds spaces to the end of the string until string is as long as <length>. *)
  RequestedLength := StrToInt(ATokens[4]);
  StrippedStringLength := Length(SethStrip(TranslateVariables(ATokens[3])));
  TranslatedStringLength := Length(TranslateVariables(ATokens[3]));
  if (StrippedStringLength < RequestedLength) then
  begin
    // NB: We add (TranslatedStringLength - StrippedStringLength) because colour codes will be in the translated
    //     string length but not the stripped string length, and that will reduce the amount of padding added,
    //     so adding this difference accounts for that
    AssignVariable(ATokens[3], PadRight(TranslateVariables(ATokens[3]), RequestedLength + (TranslatedStringLength - StrippedStringLength)));
  end;
end;

procedure TRTReader.CommandDO_QUEBAR(ATokens: TTokens);
begin
  (* @DO quebar
      <message>
      This adds a message to the saybar que.  This will ensure that the message is
      displayed at it's proper time instead of immediately. *)
  LogTODO(ATokens);
  // TODO Quebar items only last 1 second or so
end;

procedure TRTReader.CommandDO_RANDOM(ATokens: TTokens);
begin
  (* @DO <Varible to put # in> RANDOM <Highest number> <number to add to it>
      RANDOM 5 1 will pick a number between 0 (inclusive) and 5 (exclusive) and add 1 to it, resulting in 1-5
      RANDOM 100 200 will pick a number between 0 (inclusive) and 100 (exclusive) and add 200 to it, resulting in 200-299 *)
  AssignVariable(ATokens[2], IntToStr(Random(StrToInt(ATokens[4])) + StrToInt(ATokens[5])));
end;

procedure TRTReader.CommandDO_READCHAR(ATokens: TTokens);
begin
  (* @DO READCHAR <string variable to put it in>
                 Waits for a key to be pressed.  This uses DV and Windows time slicing while
                 waiting.  `S10 doesn't seem to work with this command.  All the other `S
                 variables do though. *)
  AssignVariable(ATokens[3], DoorReadKey);
end;

procedure TRTReader.CommandDO_READNUM(ATokens: TTokens);
var
  Default: String;
  ReadNum: String;
begin
(* @DO READNUM <MAX LENGTH> <DEFAULT> (Optional: <FOREGROUND COLOR> <BACKGROUND COLOR>
    The number is put into `V40.
    The READNUM procedure is a very nice string editer to get a number in. It
    supports arrow keys and such. *)
  Default := '';
  if (High(ATokens) >= 4) then
  begin
    Default := TranslateVariables(ATokens[4]);
  end;

  ReadNum := DoorInput(Default, DOOR_INPUT_CHARS_NUMERIC, #0, StrToInt(TranslateVariables(ATokens[3])), StrToInt(TranslateVariables(ATokens[3])), 31);
  AssignVariable('`V40', ReadNum);
end;

procedure TRTReader.CommandDO_READSPECIAL(ATokens: TTokens);
var
  Ch: Char;
begin
(* @DO READSPECIAL (String variable to put it in> <legal chars, 1st is default>
    Example:
    @do write
    Would you like to kill the monster? Y/N :
    @DO READSPECIAL `s01 YN
    if `s01 is Y then do
     @begin
     @show
    You killed him!
     @end
    The above would ONLY allow the person to hit Y or N - if he hit ENTER, it
    would be the same as hitting Y, because that was listed first.   *)
  Ch := #0;
  repeat
    Ch := UpCase(DoorReadKey);
    if (Ch = #13) then
    begin
      // Assign first option when enter is hit
      AssignVariable(ATokens[3], ATokens[4][1]);
    end else
    if (Pos(Ch, UpperCase(ATokens[4])) > 0) then
    begin
      // Assign selected character
      AssignVariable(ATokens[3], Ch);
    end else
    begin
      // Not a valid character
      Ch := #0
    end;
  until (Ch <> #0);
end;

procedure TRTReader.CommandDO_READSTRING(ATokens: TTokens);
var
  ReadString: String;
begin
(* @DO READSTRING <MAX LENGTH> <DEFAULT> <variable TO PUT IT IN>
    Get a string.  Uses same string editer as READNUM.
    Note:  You can only use the `S01 through `S10 vars for READSTRING.  You can
    also use these vars for the default.  (or `N)  Use NIL if you want the default
    to be nothing.  (if no variable to put it in is specified, it will be put into `S10
    for compatibilty with old .REF's) *)
  ReadString := DoorInput(TranslateVariables(ATokens[4]), DOOR_INPUT_CHARS_ALL, #0, StrToInt(TranslateVariables(ATokens[3])), StrToInt(TranslateVariables(ATokens[3])), 31);
  if (High(ATokens) >= 5) then
  begin
    AssignVariable(ATokens[5], ReadString);
  end else
  begin
    AssignVariable('`S10', ReadString);
  end;
end;

procedure TRTReader.CommandDO_REPLACE(ATokens: TTokens);
begin
  (* @DO REPLACE <X> <Y> <in `S10>
      Replaces X with Y in an `s variable. *)
  // Identified as @REPLACE not @DO REPLACE in the docs
  AssignVariable(ATokens[5], StringReplace(TranslateVariables(ATokens[5]), TranslateVariables(ATokens[3]), TranslateVariables(ATokens[4]), [rfIgnoreCase]));
end;

procedure TRTReader.CommandDO_REPLACEALL(ATokens: TTokens);
begin
  (* @DO REPLACEALL <X> <Y> <in `S10>:
      Same as above but replaces all instances. *)
  // Identified as @REPLACEALL not @DO REPLACEALL in the docs
  AssignVariable(ATokens[5], StringReplace(TranslateVariables(ATokens[5]), TranslateVariables(ATokens[3]), TranslateVariables(ATokens[4]), [rfIgnoreCase, rfReplaceAll]));
end;

procedure TRTReader.CommandDO_RENAME(ATokens: TTokens);
var
  NewFile: String;
  OldFile: String;
begin
  (* @DO RENAME <old name> <new name>
      Undocumented.  Renames a file *)
  OldFile := Game.GetSafeAbsolutePath(TranslateVariables(ATokens[3]));
  NewFile := Game.GetSafeAbsolutePath(TranslateVariables(ATokens[4]));
  if ((OldFile <> '') AND (NewFile <> '') AND (FileExists(OldFile))) then
  begin
    RenameFile(OldFile, NewFile);
  end;
end;

procedure TRTReader.CommandDO_SAYBAR(ATokens: TTokens);
begin
  (* @DO saybar
      <message>
      This is like @do quebar except it displays the message instantly without
      taking into consideration that a message might have just been displayed.  This
      will overwrite any current message on the saybar unconditionally. *)
  FInSAYBAR := true;
end;

procedure TRTReader.CommandDO_STATBAR(ATokens: TTokens);
begin
    (* @DO STATBAR
        This draws the statbar. *)
    // Identified as @STATBAR not @DO STATBAR in the docs
  LogTODO(ATokens);
end;

procedure TRTReader.CommandDO_STRIP(ATokens: TTokens);
begin
  (* @DO STRIP <string variable>
      This strips beginning and end spaces of a string. *)
  AssignVariable(ATokens[3], Trim(TranslateVariables(ATokens[3])));
end;

procedure TRTReader.CommandDO_STRIPALL(ATokens: TTokens);
begin
  (* @DO STRIPALL
      This command strips out all ` codes.  This is good for passwords, etc. *)
  LogTODO(ATokens); // Unused
end;

procedure TRTReader.CommandDO_STRIPBAD(ATokens: TTokens);
begin
  (* @DO STRIPBAD
      This strips out illegal ` codes, and replaces badwords with the standard
      badword.dat file. *)
  LogTODO(ATokens);
end;

procedure TRTReader.CommandDO_STRIPCODE(ATokens: TTokens);
begin
  (* @STRIPCODE <any `s variable>
      This will remove ALL ` codes from a string. *)
  LogTODO(ATokens); // Unused
end;

procedure TRTReader.CommandDO_SUBTRACT(ATokens: TTokens);
begin
  (* @DO <Number To Change> <How To Change It> <Change With What> *)
  AssignVariable(ATokens[2], IntToStr(StrToInt(TranslateVariables(ATokens[2])) - StrToInt(TranslateVariables(ATokens[4]))));
end;

procedure TRTReader.CommandDO_TALK(ATokens: TTokens);
begin
  (* @DO TALK <message> [recipients]
      Undocumented. Looks like recipients is usually ALL, which sends a global message
      Lack of recipients value means message is only displayed to those on the same screen *)
  LogTODO(ATokens);
end;

procedure TRTReader.CommandDO_TRIM(ATokens: TTokens);
var
  FileName: String;
  MaxLines: Integer;
  SL: TStringList;
begin
  (* @DO TRIM <file name> <number to trim to>
                  This nifty command makes text file larger than <number to trim to> get
                  smaller.  (It deletes lines from the top until the file is correct # of lines,
                  if smaller than <number to trim to>, it doesn't change the file) *)
  // TODO Error handling
  FileName := Game.GetSafeAbsolutePath(TranslateVariables(ATokens[3]));
  if (FileExists(FileName)) then
  begin
    MaxLines := StrToInt(TranslateVariables(ATokens[4]));
    SL := TStringList.Create;
    SL.LoadFromFile(FileName);
    if (SL.Count > MaxLines) then
    begin
      while (SL.Count > MaxLines) do
      begin
        SL.Delete(0);
      end;
      SL.SaveToFile(FileName);
      SL.Free;
    end;
  end;
end;

procedure TRTReader.CommandDO_UPCASE(ATokens: TTokens);
begin
  (* @DO UPCASE <string variable>
      This makes a string all capitals. *)
 AssignVariable(ATokens[3], UpperCase(TranslateVariables(ATokens[3])));
end;

procedure TRTReader.CommandDO_WRITE(ATokens: TTokens);
begin
  (* @DO WRITE
      <Stuff to write>
      Same thing as regular @SHOW, but does only one line, without a line feed.
      Used with @DO MOVE this is good for putting prompts, right in front of READNUM
      and READSTRING's.
      NOTE:  You can use variables mixed with text, ansi and color codes in the
      <stuff to write> part.  Works this way with most stuff. *)
  FInDO_WRITE := true;
end;

procedure TRTReader.CommandDRAWMAP(ATokens: TTokens);
begin
  (* @DRAWMAP
      This draws the current map the user is on.  This command does NOT update the
      screen.  See the @update command below concerning updating the scren. *)
  Game.DrawMap;
end;

procedure TRTReader.CommandDRAWPART(ATokens: TTokens);
begin
  (* @DRAWPART <x> <y>
      This command will draw one block of the current map as defined by <x> and <y>
      with whatever is supposed to be there, including any people. *)
  LogTODO(ATokens);
end;

procedure TRTReader.CommandEND(ATokens: TTokens);
begin
  FInBEGINCount -= 1;
end;

procedure TRTReader.CommandFIGHT(ATokens: TTokens);
begin
    (* @FIGHT  : Causes the L2 engine to go into fight mode.
        <Monster name>
        <String said when you see him>
        <Power Move Kill String>
        <Weapon 1|strength>
        <Weapon 2|strength or NONE|NONE>
        <Weapon 3|strength or NONE|NONE>
        <Weapon 4|strength or NONE|NONE>
        <Weapon 5|strength or NONE|NONE>
        <Defense>
        <Experience Points rewarded for victory>
        <Gold rewarded for victory>
        <Hitpoints the monster has>
        <REFFILENAME|REFNAME or NONE|NONE> player victory
        <REFFILENAME|REFNAME or NONE|NONE> player defeat
        <REFFILENAME|REFNAME or NONE|NONE> player runs

        As with any of the other commands you may have comment lines and inline
        comments within this command.
        It is also important to note here that while this can be in a standard routine
        it will not execute until after the script has completed execution and the
        player returned to the map screen.  This is usually used for the random fights
        as players walk around.  Below is an example of how it is used in this way.
        In the map attributes (edited by pressing z while editing a screen in the
        world editor of L2CFG) you specify a fight file name and a fight ref name.
        The ref name is the routine the L2 engine calls.  Let's say your ref name is
        fight.  The file name can be anything you choose so long as the following
        routine is in that file.  The following routine shows how random fighting is
        accomplished:

        @#fight
        @do `p20 random 6 1
        @do goto monster`p20
        @#monster1
        @fight
        ;name
        Tiny Scorpion
        ;string said when you see him
        Something crawls up your leg...
        ;power move kill string
        You laugh as the tiny thing burns in the sand.
        ;sex - 1 is male, 2 is female, 3 is it
        3
        ;weapon and strength for the weapon, up to 5
        stings you|44
        pinches you|25
        NONE|NONE
        NONE|NONE
        NONE|NONE
        ;defense
        15
        ;gold reward
        89
        ;experience
        54
        ;hit points
        64
        ;if win: ref file|name or NONE
        NONE|NONE
        ;if lose: ref file|name or NONE
        GAMETXT.REF|DIE
        ;if runs: ref file|name or NONE
        NONE|NONE
        @#monster2
        @fight
        (parameters for fight command until you have as many monster commands as the
        highest random number

        You might also have a hotspot defined that calls a routine that will be a
        fight.  Make sure you DON'T clear the screen.  It won't hurt anything if you
        do, but it won't look very good. *)
  FInFIGHTLines.Clear;
  FInFIGHT := true;
end;

procedure TRTReader.CommandGRAPHICS(ATokens: TTokens);
begin
  (* @GRAPHICS IS <Num>
      3 or more enable remote Ansi  If you never wanted to send ANSI, you could set
      this to 1. You will probably never touch this one. *)
  LogTODO(ATokens); // Unused
end;

procedure TRTReader.CommandHALT(ATokens: TTokens);
begin
  (* @HALT <error level>
      This command closes the door and returns the specified error level. *)
  if (High(ATokens) = 1) then
  begin
    Halt;
  end else
  begin
    Halt(StrToInt(ATokens[2]));
  end;
end;

function TRTReader.CommandIF_BITCHECK(ATokens: TTokens): Boolean;
begin
  (* @IF bitcheck <`t variable> <bit number> <0 or 1>
      Check if the given bit is set or not in the given `t variable *)
  // TODO Untested
  Result := ((StrToInt(TranslateVariables(ATokens[3])) AND (1 SHL StrToInt(TranslateVariables(ATokens[4])))) = StrToInt(TranslateVariables(ATokens[5])));
end;

function TRTReader.CommandIF_BLOCKPASSABLE(ATokens: TTokens): Boolean;
begin
  (* @if blockpassable <is or not> <0 or 1> *)
  Result := (Game.CurrentMap.MapInfo[Game.Player.X][Game.Player.Y].Terrain = 1);
end;

function TRTReader.CommandIF_CHECKDUPE(ATokens: TTokens): Boolean;
var
  Exists: Boolean;
  Name: String;
  TDR: TraderDatRecord;
  TrueFalse: Boolean;
begin
  (* @if checkdupe <`s variable> <true or false>
      Check if the given player name already exists *)

  Name := TranslateVariables(ATokens[3]);
  TrueFalse := StrToBool(TranslateVariables(ATokens[4]));

  Exists := (Game.LoadPlayerByGameName(Name, TDR) <> -1);

  Result := (Exists = TrueFalse);
end;

function TRTReader.CommandIF_EXIST(ATokens: TTokens): Boolean;
var
  FileName: String;
  TrueFalse: Boolean;
begin
  (* @IF <filename> EXIST <true or false>
      Undocumented.  Checks if given file exists *)
  FileName := Game.GetSafeAbsolutePath(TranslateVariables(ATokens[2]));
  TrueFalse := StrToBool(TranslateVariables(ATokens[4]));
  Result := (FileExists(FileName) = TrueFalse);
end;

function TRTReader.CommandIF_INSIDE(ATokens: TTokens): Boolean;
begin
  (* @IF <Word or variable> INSIDE <Word or variable>
      This allows you to search a string for something inside of it.  Not case
      sensitive. *)
  Result := (Pos(UpperCase(TranslateVariables(ATokens[2])), UpperCase(TranslateVariables(ATokens[4]))) > 0);
end;

function TRTReader.CommandIF_IS(ATokens: TTokens): Boolean;
var
  Left: String;
  LeftInt: LongInt;
  Right: String;
  RightInt: LongInt;
begin
  Left := TranslateVariables(ATokens[2]);
  Right := TranslateVariables(ATokens[4]);
  LeftInt := StrToIntDef(Left, -999);
  RightInt := StrToIntDef(Right, -999);

  if (LeftInt = -999) OR (RightInt = -999) then
  begin
    Result := (Left = Right);
  end else
  begin
    Result := (LeftInt = RightInt);
  end;
end;

function TRTReader.CommandIF_LESS(ATokens: TTokens): Boolean;
var
  Left: String;
  LeftInt: LongInt;
  Right: String;
  RightInt: LongInt;
begin
  Left := TranslateVariables(ATokens[2]);
  Right := TranslateVariables(ATokens[4]);
  LeftInt := StrToIntDef(Left, -999);
  RightInt := StrToIntDef(Right, -999);

  if (LeftInt = -999) OR (RightInt = -999) then
  begin
    Result := false;
  end else
  begin
    Result := (LeftInt < RightInt);
  end;
end;

function TRTReader.CommandIF_MORE(ATokens: TTokens): Boolean;
var
  Left: String;
  LeftInt: LongInt;
  Right: String;
  RightInt: LongInt;
begin
  Left := TranslateVariables(ATokens[2]);
  Right := TranslateVariables(ATokens[4]);
  LeftInt := StrToIntDef(Left, -999);
  RightInt := StrToIntDef(Right, -999);

  if (LeftInt = -999) OR (RightInt = -999) then
  begin
    Result := false;
  end else
  begin
    Result := (LeftInt > RightInt);
  end;
end;

function TRTReader.CommandIF_NOT(ATokens: TTokens): Boolean;
var
  Left: String;
  LeftInt: LongInt;
  Right: String;
  RightInt: LongInt;
begin
  Left := TranslateVariables(ATokens[2]);
  Right := TranslateVariables(ATokens[4]);
  LeftInt := StrToIntDef(Left, -999);
  RightInt := StrToIntDef(Right, -999);

  if (LeftInt = -999) OR (RightInt = -999) then
  begin
    Result := (Left <> Right);
  end else
  begin
    Result := (LeftInt <> RightInt);
  end;
end;

procedure TRTReader.CommandITEMEXIT(ATokens: TTokens);
begin
  (* @ITEMEXIT
      This tells the item editor to automatically return the player to the map
      screen after the item is used.  It is up to you to use the @drawmap and
      @update commands as usual though. *)
  LogTODO(ATokens);
end;

procedure TRTReader.CommandKEY(ATokens: TTokens);
var
  SavedTextAttr: Integer;
begin
  // Save text attribute
  SavedTextAttr := Crt.TextAttr;

  if (High(ATokens) = 1) then
  begin
      (* @KEY
          Does a [MORE] prompt, centered on current line.
          NOTE: Actually indents two lines, not centered *)
      DoorWrite(TranslateVariables('`r0  `2<`0MORE`2>'));
      DoorReadKey;
      DoorWrite(#8#8#8#8#8#8#8#8 + '        ' + #8#8#8#8#8#8#8#8);
  end else
  if (UpperCase(ATokens[2]) = 'BOTTOM') then
  begin
      (* @KEY BOTTOM
          This does <MORE> prompt at user text window. *)
      DoorGotoXY(35, 24);
      DoorWrite(TranslateVariables('`r0`2<`0MORE`2>'));
      DoorReadKey;
      DoorWrite(#8#8#8#8#8#8 + '      ' + #8#8#8#8#8#8);
  end else
  if (UpperCase(ATokens[2]) = 'NODISPLAY') then
  begin
      (* @KEY NODISPLAY
          Waits for keypress without saying anything. *)
      DoorReadKey;
  end else
  if (UpperCase(ATokens[2]) = 'TOP') then
  begin
      (* @KEY TOP
          This does <MORE> prompt at game text window. *)
      DoorGotoXY(40, 15);
      DoorWrite(TranslateVariables('`r0`2<`0MORE`2>'));
      DoorReadKey;
      DoorWrite(#8#8#8#8#8#8 + '      ' + #8#8#8#8#8#8);
  end else
  begin
    LogTODO(ATokens);
  end;

  // Restore text attribute
  DoorWrite(AnsiTextAttr(SavedTextAttr));
end;

procedure TRTReader.CommandLABEL(ATokens: TTokens);
begin
  (* @LABEL <label name>
      Mark a spot where @DO GOTO <label name> can be used *)
  // Ignore, nothing to do here
end;

procedure TRTReader.CommandLOADCURSOR(ATokens: TTokens);
begin
  (* @LOADCURSOR
      This command restores the cursor to the position before the last @SAVECURSOR
      was issued.  This is good for creative graphics and text positioning with a
      minimum of calculations.  See @SAVECURSOR below. *)
  LogTODO(ATokens);
end;

procedure TRTReader.CommandLOADGLOBALS(ATokens: TTokens);
begin
  (* @LOADGLOBALS
      This command loads the last value of all global variables as existed when the
      last @SAVEGLOBALS command was issued.  See @SAVEGLOBALS below. *)
  LogTODO(ATokens); // Unused
end;

procedure TRTReader.CommandLOADMAP(ATokens: TTokens);
begin
  (* @LOADMAP <map #>
      This is a very handy command.  It lets you change someones map location in a
      ref file.  This is the 'block #' not the physical map location, so it could be
      1 to 1600.  Be sure it exists in l2cfg.exe.  If the map block does not exist,
      The L2 engine will display a runtime error and close the m   Be SURE to
      change the map variable too!!  Using this and changing the X and Y coordinates
      effectivly lets you do a 'warp' from a .ref file. *)
  Game.LoadMap(StrToInt(TranslateVariables(ATokens[2])));
end;

procedure TRTReader.CommandLOADWORLD(ATokens: TTokens);
begin
  (* @LOADWORLD
      This command loads globals and world data.  It has never been used but is
      included just in case it becomes necessary to do this.  See @SAVEWORLD below. *)
  LogTODO(ATokens); // Unused
end;

procedure TRTReader.CommandLORDRANK(ATokens: TTokens);
begin
  (* @LORDRANK <filename> <`p variable to rank by>
      This command produces a file as specified by <filename>.  It uses the `p
      variable specified for the order of the ranking.  This parameter must be a
      number without the `p.  The file that is created contains no headers and is
      not deleted before writing.  If a file of the same name already exists, the
      procedure will append the file.  The following table is the column numbers
      where @LORDRANK places the ranking information.
        COLUMN     STAT
        1          Sex if female
        3          Name
        37         Stat to rank by (right justified) (Usually Experience)
        42         Level
        48         Status
        60         Alignment
        65         Quests completed *)
  LogTODO(ATokens);
end;

procedure TRTReader.CommandMOREMAP(ATokens: TTokens);
begin
  (* @MOREMAP
      The line UNDER this will be the new <more> prompt.  30 characters maximum. *)
  LogTODO(ATokens); // Used in CNW
end;

procedure TRTReader.CommandNAME(ATokens: TTokens);
var
  Name: String;
begin
  (* @NAME <name to put under picture>
      Undocumented. Puts a name under the picture window *)
  Name := TranslateVariables(TokToStr(ATokens, ' ', 2));
  DoorGotoXY(55 + ((22 - Length(SethStrip(Name))) div 2), 15);
  DoorWrite(Name);
end;

procedure TRTReader.CommandNOCHECK(ATokens: TTokens);
begin
  (* @NOCHECK
      Tell the original RTReader to stop scanning for sections/labels
      Not implemented here, we always scan all files in their entirety *)
  // Ignore
end;

procedure TRTReader.CommandNOP(ATokens: TTokens);
begin
  (* @
      Undocumented.  Seth appears to use a single @ to signify the end of @CHOICE, @READFILE, @WRITEFILE, etc *)
  // Ignore
end;

procedure TRTReader.CommandOFFMAP(ATokens: TTokens);
begin
  (* @OFFMAP
      This takes the player's symbol off the map.  This makes the player appear to
      disappear to other players currently playing.  This is usful to make it look
      like they actually went into the hut, building, ect. *)
  LogTODO(ATokens);
end;

procedure TRTReader.CommandOVERHEADMAP(ATokens: TTokens);
var
  BG: Integer;
  I: Integer;
  NewBG: Integer;
  ToSend: String;
  X, Y: Integer;
begin
  (* @OVERHEADMAP
      This command displays the visible portion of the map as defined in the world
      editor of L2CFG.  All maps marked as no show and all unused maps will be
      blue signifying ocean.  No marks or legend will be written on the map.  This
      is your responsibility.  If you wish to mark the map you must do this in
      help.ref under the @#M routine.  Be sure to include a legend so people have
      some reference concerning what the marks mean. *)
  // Draw the map
  DoorTextAttr(7);
  DoorClrScr;

  for Y := 1 to 20 do
  begin
    BG := 1;
    ToSend := AnsiTextBackground(1);

    for X := 1 to 80 do
    begin
      I := X + ((Y - 1) * 80);
      if (WorldDat.MapDatIndex[I] <> 0) AND (WorldDat.HideOnMap[I] = 0) then
      begin
        NewBG := 2;
      end else
      begin
        NewBG := 1;
      end;

      if (BG <> NewBG) then
      begin
        ToSend += AnsiTextBackground(NewBG);
        BG := NewBG;
      end;

      ToSend += ' ';
    end;

    DoorGotoXY(1, Y);
    DoorWrite(ToSend);
  end;

  DoorTextAttr(7);
end;

procedure TRTReader.CommandPAUSEOFF(ATokens: TTokens);
begin
  (* @PAUSEOFF
      This turns the 24 line pause off so you can show long ansis etc and it won't
      pause every 24 lines. *)
  LogTODO(ATokens);
end;

procedure TRTReader.CommandPAUSEON(ATokens: TTokens);
begin
  (* @PAUSEON
      Just the opposite of the above command.  This turns the pause back on. *)
  LogTODO(ATokens);
end;

procedure TRTReader.CommandPROGNAME(ATokens: TTokens);
begin
  (* @PROGNAME
      The line UNDER this will be the status bar name of the game. *)
  LogTODO(ATokens); // Used in CNW
end;

procedure TRTReader.CommandRANK(ATokens: TTokens);
begin
  (* @RANK <filename> <`p variable to rank by> <procedure to format the ranking>
      This command is the same as above with the exception it uses a procedure to
      format the ranking.  This procedure needs to be in the same file as the @RANK
      command.  It is preferable to use the @LORDRANK command rather than this one,
      if feasible.  This one works, but @LORDRANK uses a preset formatting
      procedure and is therefore quicker.  There may be occasion, however, if you
      write your own world to use this command rather than @LORDRANK. *)
  LogTODO(ATokens); // Used in CNW
end;

procedure TRTReader.CommandREADFILE(ATokens: TTokens);
begin
  (* @READFILE <file name>
      <variable to read into>
      <variable to read into>
      <Ect until next @ at beginning of string is hit>
      This works just like @WRITEFILE.  You can use String and Number variables,
      just be warned if a number variable attempts to read a string, you will always
      get 0.
      NOTE:  @READFILE is a smart procedure - It will not run-time error or
      anything, even if you try to read past the end of the file. It simply won't
      change the variables if the file isn't long enough. *)
  FInREADFILELines.Clear;
  FInREADFILE := Game.GetSafeAbsolutePath(TranslateVariables(ATokens[2]));
end;

procedure TRTReader.CommandROUTINE(ATokens: TTokens);
begin
  (* @ROUTINE <Header or label name> IN <Filename of .REF file>
      The @ROUTINE command is useful - You can use it jump to a completely new .REF
      file - when it's finished there, instead of closing the script, it will load
      back up the original .REF file and continue where it left off.  One note.  I
      have found that @ROUTINE cannot be nested.  That is if you use an @ROUTINE
      command inside of a routine called by @ROUTINE, the reader cannot return to
      the first procedure that ran @ROUTINE. *)
  if (High(ATokens) < 4) then
  begin
    RTReader.Execute(FCurrentFile.Name, TranslateVariables(ATokens[2]));
  end else
  begin
    RTReader.Execute(TranslateVariables(ATokens[4]), TranslateVariables(ATokens[2]));
  end;
end;

procedure TRTReader.CommandRUN(ATokens: TTokens);
begin
  (* @RUN <Header or label name> IN <Filename of .REF file>
      Same thing as ROUTINE, but doesn't come back to the original .REF. *)
  RTReader.Execute(TranslateVariables(ATokens[4]), TranslateVariables(ATokens[2]));
  FInCLOSESCRIPT := true; // Don't want to resume this ref
end;

procedure TRTReader.CommandSAVECURSOR(ATokens: TTokens);
begin
  (* @SAVECURSOR
      This command saves the current cursor positioning for later retrieval. *)
  LogTODO(ATokens);
end;

procedure TRTReader.CommandSAVEGLOBALS(ATokens: TTokens);
begin
  (* @SAVEGLOBALS
      This command saves the current global variables for later retrieval *)
  LogTODO(ATokens);
end;

procedure TRTReader.CommandSAVEWORLD(ATokens: TTokens);
begin
  (* @SAVEWORLD
      This command saves stats and world data.  The only use yet is right after
      @#maint is called to save random stats set for that day and such. *)
  LogTODO(ATokens); // Unused
end;

procedure TRTReader.CommandSAY(ATokens: TTokens);
begin
  (* @SAY
      All text UNDER this will be put in the 'talk window' until a @ is hit. *)
  FInSAY := true;
end;

procedure TRTReader.CommandSELLMANAGER(ATokens: TTokens);
begin
  (* @SELLMANAGER
      This command presents a menu of the player's current inventory.  The player
      can then sell his items at 1/2 the price in items.dat.  Any item that has the
      "Can be sold" field in the items.dat file set to 'no' will be greyed and if
      the player chooses that item a box will appear saying "They don't seem
      interested in that".  It is highly recommended that there be a routine such as
      @clear screen
      @do write
      `cSo what do you want to sell?
      @SELLMANAGER
      OR
      @clear screen
      @show
      `cSo what do you want to sell
      @SELLMANAGER
      The `c is included so that there will be two carriage returns issued.  This is
      important for cosmetic purposes only.  I have found that if the @sellmanager
      is issued at the top of the screen, the boxes don't dissapear as they should. *)
  FInSELLMANAGEROptions.Clear;
  FInSELLMANAGER := true;
end;

procedure TRTReader.CommandSHOW(ATokens: TTokens);
begin
  if ((High(ATokens) > 1) AND (UpperCase(ATokens[2]) = 'SCROLL')) then
  begin
    (* @SHOW SCROLL
        Same thing, but puts all the text in a nifty scroll window. (scroll window has
        commands line Next Screen, Previous Screen, Start, and End. *)
    FInSHOWSCROLLLines.Clear;
    FInSHOWSCROLL := true;
  end else
  begin
    (* @SHOW
        Shows following text/Ansi  Stops when a @ is hit on beginning of line. *)
    FInSHOW := true;
  end;
end;

procedure TRTReader.CommandSHOWLOCAL(ATokens: TTokens);
begin
  (* @SHOWLOCAL
      Undocumented.  Same as @SHOW, but only outputs to local window *)
  FInSHOWLOCAL := true;
end;

procedure TRTReader.CommandUPDATE(ATokens: TTokens);
begin
  (* @UPDATE
      Draws all the people on the screen. *)
  Game.Update;
end;

procedure TRTReader.CommandUPDATE_UPDATE(ATokens: TTokens);
begin
  (* @UPDATE_UPDATE
      This command writes current player data to UPDATE.TMP file.  This is useful
      when you just can't wait until the script is finished for some reason. *)
  LogTODO(ATokens);
end;

procedure TRTReader.CommandVERSION(ATokens: TTokens);
var
  RequiredVersion: Integer;
begin
  (* @VERSION  <Version it needs>
      For instance, you would put @VERSION 2 for this version of RTREADER.  (002) If
      it is run on Version 1, (could happen) a window will pop up warning the person
      he had better get the latest version. *)
  RequiredVersion := StrToInt(ATokens[2]);
  if (RequiredVersion > FVersion) then
  begin
    DoorWriteLn;
    DoorWriteLn('  File requested version ' + IntToStr(RequiredVersion) + ', we only support ' + IntToStr(FVersion));
    DoorWriteLn('  I''ll continue to run, but unexpected results may occur');
    DoorWriteLn;
    DoorWrite('`k');
  end;
end;

procedure TRTReader.CommandWHOISON(ATokens: TTokens);
begin
  (* @WHOISON
      Undocumented.  Will need to find out what this does *)
  LogTODO(ATokens);
end;

procedure TRTReader.CommandWRITEFILE(ATokens: TTokens);
begin
  (* @WRITEFILE <file name>
      <Thing to write>
      <Thing to write>
      <ect until next @ at beginning of string is hit>
      <Thing to write> can be a varible, (string or num) or it can be a word you
      write - or a combination of the two.
      Note:  @WRITEFILE appends the lines if the file exists, otherwise it creates
      it.  File locking techniques are used. *)
  FInWRITEFILE := Game.GetSafeAbsolutePath(TranslateVariables(ATokens[2]));
end;

procedure TRTReader.EndBUYMANAGER;

  procedure DrawBottomLine;
  begin
    DoorGotoXY(1, 24);
    DoorWrite('`r5                                                                               ');
    DoorGotoX(1);
    DoorWrite('  `$Q `2to quit, `$ENTER `2to buy item.        You have `$' + IntToStr(Game.Player.Money) + ' `2gold.`r0');
  end;

var
  Ch: Char;
  I: Integer;
  Item: ItemsDatRecord;
  ItemIndex: Integer;
  SelectedIndex: Integer;
  SelectedItem: ItemsDatRecord;
  StrippedStringLength: Integer;
begin
  SelectedIndex := 0;
  ItemIndex := StrToInt(FInBUYMANAGEROptions[SelectedIndex]);
  SelectedItem := Game.ItemsDat.Item[ItemIndex];

  // Draw top and bottom lines
  DoorCursorSave;
  DoorWrite('`r5`%  Item To Buy                         Price                                     ');
  DrawBottomLine;

  // Draw items for sale
  DoorCursorRestore;
  DoorCursorDown(1);
  for I := 0 to FInBUYMANAGEROptions.Count - 1 do
  begin
    Item := Game.ItemsDat.Item[StrToInt(FInBUYMANAGEROptions[I])];
    StrippedStringLength := Length(SethStrip(Item.Name));

    if (I = 0) then DoorWrite('`r1');
    DoorWrite('`2  ' + Item.Name);
    if (I = 0) then DoorWrite('`r0`2');
    DoorWrite(AddCharR(' ', '', 35 - StrippedStringLength));
    DoorWrite('`2 $`$' + AddCharR(' ', IntToStr(Item.Value), 8));
    DoorWriteLn('`2 ' + Item.Description);
  end;

  // Get input
  repeat
    // TODO Handle arrow keys for lightbar
    Ch := UpCase(DoorReadKey);
    if (DoorLastKey.Extended) then
    begin
      case Ch of
        'H':
        begin
          if (SelectedIndex > 0) then
          begin
            // Erase old highlight
            DoorCursorRestore;
            DoorCursorDown(SelectedIndex + 1);
            DoorWrite('`2  ' + SelectedItem.Name);

            // Move up
            SelectedIndex -= 1;
            ItemIndex := StrToInt(FInBUYMANAGEROptions[SelectedIndex]);
            SelectedItem := Game.ItemsDat.Item[ItemIndex];

            // Draw new highlight
            DoorCursorRestore;
            DoorCursorDown(SelectedIndex + 1);
            DoorWrite('`r1  ' + SelectedItem.Name + '`r0`2');
          end;
        end;

        'P':
        begin
          if (SelectedIndex < (FInBUYMANAGEROptions.Count - 1)) then
          begin
            // Erase old highlight
            DoorCursorRestore;
            DoorCursorDown(SelectedIndex + 1);
            DoorWrite('`2  ' + SelectedItem.Name);

            // Move down
            SelectedIndex += 1;
            ItemIndex := StrToInt(FInBUYMANAGEROptions[SelectedIndex]);
            SelectedItem := Game.ItemsDat.Item[ItemIndex];

            // Draw new highlight
            DoorCursorRestore;
            DoorCursorDown(SelectedIndex + 1);
            DoorWrite('`r1  ' + SelectedItem.Name + '`r0`2');
          end;
        end;
      end;
    end else
    begin
      if (Ch = #13) then
      begin
        DoorGotoXY(1, 24);
        DoorWrite('`r4                                                                               ');
        DoorGotoX(1);
        if (SelectedItem.Value > Game.Player.Money) then
        begin
          DoorWrite('`* ITEM NOT BOUGHT! `%You don''t have enough gold.  `2(`0press a key to continue`2)`r0');
        end else
        begin
          Game.Player.Money -= SelectedItem.Value;
          Game.Player.I[ItemIndex] += 1;
          DoorWrite('`* ITEM BOUGHT! `%You now have ' + IntToStr(Game.Player.I[ItemIndex]) + ' of ''em.  `2(`0press a key to continue`2)`r0');
        end;
        DoorReadKey;
        DrawBottomLine;
      end;
    end;
  until (Ch = 'Q');

  // TODO Erase buy manager
  DoorCursorRestore;
end;

procedure TRTReader.EndCHOICE;
const
  IfChars = '=!><+-';
var
  Ch: Char;
  I: Integer;
//  LastVisibleLength: Integer;
  MakeVisible: Boolean;
  Option: TRTChoiceOption; // TODO Potentially ditch RTCHoiceOption
  OptionIndexes: TStringList;
  IfChar: Char;
//  OldSelectedIndex: Integer;
//  SelectedIndex: Integer;
//  Spaces: String;
  Value: String;
  Variable: String;
//  VisibleCount: Integer;
begin
  (* @CHOICE
      <A choice>
      <another choice>
      <ect..When a @ is found in the beginning of a choice it quits>
      This gives the user a choice using a lightbar.
      The responce is put into varible RESPONCE.  This may also be spelled RESPONSE.
      To set which choice the cursor starts on, put that number into `V01.
      ** EXAMPLE OF @CHOICE COMMAND **
      @DO `V01 IS 1 ;which choice should be highlighted when they start
      (now the actual choice command)
      @CHOICE
      Yes   <- Defaults to this, since it's 1
      No
      I don't know
      Who cares
      @IF RESPONCE IS 3 THEN DO
        @BEGIN
        @DO `P01 IS RESPONCE
        @SHOW

      You chose `P01!, silly boy!

        @END
      The choice command is more useful now; you can now define *IF* type statements
      so a certain choice will only be there if a conditional statement is met.
      For instance:
      @CHOICE
      Yes
      No
      =`p20 500 Hey, I have 500 exactly!
      !`p20 500 Hey, I have anything BUT 500 exactly!
      >`p20 500 Hey, I have MORE than 500!
      <`p20 100 Hey, I have LESS than 100!
      >`p20 100 <`p20 500 I have more then 100 and less than 500!
      Also:  You can check the status of individual bits in a `T player byte.  The
      bit is true or false, like this:
      +`t12 1 Hey! Byte 12's bit 1 is TRUE! (which is 1)
      -`t12 3 Hey! Byte 12's bit 3 is FALSE! (which is 0)

      The = > and < commands can be stacked as needed.  In the above example, if
      `p20 was 600, only options 1, 2, 4, and 5 would be available, and RESPONSE
      would be set to the correct option if one of those were selected.  For
      example, if `p20 was 600 and the user hit the selection:
      "Hey, I have more than 500", RESPONSE would be set to 5. *)


  // Determine which options are Visible and assign VisibleIndex
//  VisibleCount := 0;
//  LastVisibleLength := 0;

  DoorLiteBarOptions.Clear;
  OptionIndexes := TStringList.Create;

  for I := 0 to FInCHOICEOptions.Count - 1 do
  begin
    Option := TRTChoiceOption(FInCHOICEOptions.Items[I]);
    MakeVisible := true;

    // Parse out the IF statements
    while (Pos(Option.Text[1], IfChars) > 0) do
    begin
        // Extract operator
        IfChar := Option.Text[1];
        Delete(Option.Text, 1, 1);

        // Extract variable and translate
        Variable := StrToTok(Option.Text, ' ')[1];
        Delete(Option.Text, 1, Length(Variable) + 1);
        Variable := TranslateVariables(Variable);

        // Extract value
        Value := StrToTok(Option.Text, ' ')[1];
        Delete(Option.Text, 1, Length(Value) + 1);
        Value := TranslateVariables(Value);

        // Determine result of if
        case ifChar of
          '=': MakeVisible := MakeVisible AND (StrToInt(Variable) = StrToInt(Value));
          '!': MakeVisible := MakeVisible AND (StrToInt(Variable) <> StrToInt(Value));
          '>': MakeVisible := MakeVisible AND (StrToInt(Variable) > StrToInt(Value));
          '<': MakeVisible := MakeVisible AND (StrToInt(Variable) < StrToInt(Value));
          '+': MakeVisible := MakeVisible AND ((StrToInt(Variable) AND (1 SHL StrToInt(Value))) <> 0);
          '-': MakeVisible := MakeVisible AND ((StrToInt(Variable) AND (1 SHL StrToInt(Value))) = 0);
        end;
    end;

    // Determine if option is visible
    if (MakeVisible) then
    begin
      DoorLiteBarOptions.Add(TranslateVariables(Option.Text));
      OptionIndexes.Add(IntToStr(I + 1)); // This will map the return value of DoorLiteBar to the index in the FInCHOICEOptions array
    end;
  end;

  // Ensure `V01 specified a valid/visible selection
  DoorLiteBarIndex := StrToInt(TranslateVariables('`V01'));
  if ((DoorLiteBarIndex < 1) OR (DoorLiteBarIndex > DoorLiteBarOptions.Count)) then
  begin
    DoorLiteBarIndex := 1;
  end;
  DoorLiteBarIndex -= 1; // Turn 1 based to 0 based
  while Not(DoorLiteBar) do DoorCursorRestore; // TODO Dumb, but avoids user hitting Q.  Maybe add parameter to disable Q

  // TODO Is `V01 the index of the visible elements, or all elements?
  //      For example if `V01 is 3, and the first item is hidden, does the 3rd item in the list
  //      or the 3rd visible item (which would be the 4th item in the list) get defaulted?

  // Update global variable responses
  AssignVariable('`V01', OptionIndexes[DoorLiteBarIndex]);
  Game.RESPONSE := OptionIndexes[DoorLiteBarIndex];

  // Move cursor below choice statement
  DoorCursorRestore;
  DoorCursorDown(DoorLiteBarOptions.Count - 1);
  DoorCursorRight(Length(SethStrip(DoorLiteBarOptions[DoorLiteBarOptions.Count - 1])));

  OptionIndexes.Free;
end;

procedure TRTReader.EndFIGHT;
var
  Action: Char;
  ExitLoop: Boolean;
  FightRec: FightRecord;
  I: Integer;

  procedure UpdateHitPointLine; forward;

  procedure AddWeapon(AText: String);
  var
    Weapon: FIGHT_WEAPON;
  begin
    if (UpperCase(Trim(AText)) <> 'NONE|NONE') then
    begin
      Weapon.Text := TranslateVariables(ExtractDelimited(1, AText, ['|']));
      Weapon.Strength := StrToInt(ExtractDelimited(2, AText, ['|']));

      SetLength(FightRec.Weapons, Length(FightRec.Weapons) + 1);
      FightRec.Weapons[High(FightRec.Weapons)] := Weapon;
    end;
  end;

  procedure AttackByMonster;
  var
    HitAmount: Integer;
    Weapon: FIGHT_WEAPON;
  begin
    // Pick random monster weapon
    Weapon := FightRec.Weapons[Random(Length(FightRec.Weapons))];

    // Determine hit amount (copied from RTSoft LORD FAQ, may not be accurate for LORD2)
    HitAmount := (Weapon.Strength div 2) + Random(Weapon.Strength div 2) - Game.Player.P[5];
    if (Game.Player.ArmourNumber > 0) then HitAmount -= ItemsDat.Item[Game.Player.ArmourNumber].Defence;

    // Check for miss or hit
    if (HitAmount <= 0) then
    begin
      (*
        You laugh as Chihuahua misses and strikes the ground.
        You dodge Chihuahua's attack easily.
        Chihuahua misses as you jump to one side!
        Your armour absorbs Chihuahua's blow!
        You are forced to grin as Armored Hedge Hog's puny strike bounces off you.
      *)
      // Display miss message
      DoorGotoXY(3, 23);
      DoorWrite('`2You laugh as `0' + FightRec.MonsterName + '`2 misses and strikes the ground.');
    end else
    begin
      // Display hit message
      DoorGotoXY(3, 23);
      DoorWrite('`0' + FightRec.MonsterName + '`2 ' + Weapon.Text + '`2 for `4' + IntToStr(HitAmount) + '`2 damage.');

      // Reduce player hit points
      Game.Player.P[2] -= HitAmount;
      if (Game.Player.P[2] < 0) then Game.Player.P[2] := 0;
      UpdateHitPointLine;

      // Check for player death
      if (Game.Player.P[2] <= 0) then
      begin
        // Defeat!
        if (FightRec.RefFileDefeat <> '') AND (FightRec.RefSectionDefeat <> '') then
        begin
          RTReader.Execute(FightRec.RefFileDefeat, FightRec.RefSectionDefeat);
        end;

        ExitLoop := true;
      end;
    end;
  end;

  procedure AttackByPlayer;
  var
    AttackPower: Integer;
    HitAmount: Integer;
    SuperStrike: Boolean;
  begin
    // Determine hit amount (copied from RTSoft LORD FAQ, may not be accurate for LORD2)
    AttackPower := Game.Player.P[4];
    if (Game.Player.WeaponNumber > 0) then AttackPower += ItemsDat.Item[Game.Player.WeaponNumber].Strength;
    HitAmount := (AttackPower div 2) + Random(AttackPower div 2) - FightRec.Defense;

    // 8% chance of super strike (testing 100 attacks resulted in 8 super strikes with original L2.EXE)
    SuperStrike := false;
    I := Random(100) + 1;
    if (I <= 8) then
    begin
      SuperStrike := true;
      HitAmount *= 2; // TODO Unknown if this is correct
    end;

    // Check for miss or hit
    if (HitAmount <= 0) then
    begin
      // Display miss message
      DoorGotoXY(3, 22);
      if (SuperStrike) then
      begin
        DoorWrite('`2Your `%SUPER STRIKE`2 misses!');
      end else
      begin
        DoorWrite('`4You completely miss!');
      end;
    end else
    begin
      DoorGotoXY(3, 22);
      if (SuperStrike) then
      begin
        DoorWrite('`2You `%SUPER STRIKE`2 for `0' + IntToStr(HitAmount) + '`2 damage!');
      end else
      begin
        // TODO Display random? hit message
        // You slap Wild Boar a good one for 3 damage!
        // You kick Wild Boar hard as you can for 3 damage!
        // You trip Angry Hen for 3 damage!
        DoorWrite('`2You trip `0' + FightRec.MonsterName + '`2 for `4' + IntToStr(HitAmount) + '`2 damage!');
      end;

      // Reduce monster hit points
      FightRec.HitPoints -= HitAmount;
      if (FightRec.HitPoints < 0) then FightRec.HitPoints := 0;
      UpdateHitPointLine;

      // Check for monster death
      if (FightRec.HitPoints <= 0) then
      begin
        // Victory!
        DoorGotoXY(3, 23);
        DoorWrite('`0You killed ' + FightRec.HimHerIt + '!');
        DoorGotoXY(3, 24);
        DoorWrite('`2You find `$$' + IntToStr(FightRec.Gold) + '`2 and gain `%' + IntToStr(FightRec.Experience) + '`2 in this battle.`k');

        // Rewards
        Game.Player.P[1] += FightRec.Experience; // TODO Why do we have P[1] and Experience?
        Game.Player.Experience += FightRec.Experience; // TODO Why do we have P[1] and Experience?
        Game.Player.Money += FightRec.Gold;

        if (FightRec.RefFileVictory <> '') AND (FightRec.RefSectionVictory <> '') then
        begin
          RTReader.Execute(FightRec.RefFileVictory, FightRec.RefSectionVictory);
        end;

        ExitLoop := true;
      end;
    end;
  end;

  function ChooseToAttackOrRun(ADefault: Char): Char;
  var
    Ch: Char;
  begin
    Result := ADefault;

    repeat
      DoorGotoXY(3, 24);

      if (Result = 'A') then
      begin
        // Highlight attack option
        DoorWrite('`%`r1Attack`r0  Run for it');
      end else
      begin
        // Highlight run option
        DoorWrite('`%`r0Attack  `r1Run for it');
      end;

      Ch := DoorReadKey;
      if (Ch in ['4', '6']) then
      begin
        if (Result = 'A') then
        begin
          // Switch to run option
          Result := 'R';
        end else
        begin
          // Switch to attack option
          Result := 'A';
        end;
      end;
    until (Ch = #13);
  end;

  procedure UpdateHitPointLine;
  begin
    DoorGotoXY(3, 21);
    DoorTextAttr(2 + (1 SHL 4));
    DoorWrite(PadRight('', 76));
    DoorGotoXY(3, 21);
    DoorWrite('Your hitpoints: (`0' + IntToStr(Game.Player.P[2]) + '`2/`0' + IntToStr(Game.Player.P[3]) + '`2)');
    DoorGotoXY(35, 21);
    if (FightRec.HitPoints <= 0) then
    begin
      DoorWrite('`0' + FightRec.MonsterName + '''s`2`r1 hitpoints: `bDead`2`r0');
    end else
    begin
      DoorWrite('`0' + FightRec.MonsterName + '''s`2`r1 hitpoints: (`0' + IntToStr(FightRec.HitPoints) + '`2/`0' + IntToStr(FightRec.HitPointsMax) + '`2)`r0');
    end;
  end;

begin
  FightRec.MonsterName := Trim(TranslateVariables(FInFIGHTLines[0]));
  FightRec.SightingText := Trim(TranslateVariables(FInFIGHTLines[1]));
  FightRec.PowerKillText := Trim(TranslateVariables(FInFIGHTLines[2]));
  case StrToInt(TranslateVariables(FInFIGHTLines[3])) of
    1: FightRec.HimHerIt := 'him';
    2: FightRec.HimHerIt := 'her';
    3: FightRec.HimHerIt := 'it';
    else FightRec.HimHerIt := 'it';
  end;
  AddWeapon(FInFIGHTLines[4]);
  AddWeapon(FInFIGHTLines[5]);
  AddWeapon(FInFIGHTLines[6]);
  AddWeapon(FInFIGHTLines[7]);
  AddWeapon(FInFIGHTLines[8]);
  FightRec.Defense := StrToInt(TranslateVariables(FInFIGHTLines[9]));
  FightRec.Experience := StrToInt(TranslateVariables(FInFIGHTLines[10]));
  FightRec.Gold := StrToInt(TranslateVariables(FInFIGHTLines[11]));
  FightRec.HitPoints := StrToInt(TranslateVariables(FInFIGHTLines[12]));
  FightRec.HitPointsMax := FightRec.HitPoints;
  if (UpperCase(Trim(FInFIGHTLines[13])) = 'NONE|NONE') then
  begin
    FightRec.RefFileVictory := '';
    FightRec.RefSectionVictory := '';
  end else
  begin
    FightRec.RefFileVictory := ExtractDelimited(1, FInFIGHTLines[13], ['|']);
    FightRec.RefSectionVictory := ExtractDelimited(2, FInFIGHTLines[13], ['|']);
  end;
  if (UpperCase(Trim(FInFIGHTLines[14])) = 'NONE|NONE') then
  begin
    FightRec.RefFileDefeat := '';
    FightRec.RefSectionDefeat := '';
  end else
  begin
    FightRec.RefFileDefeat := ExtractDelimited(1, FInFIGHTLines[14], ['|']);
    FightRec.RefSectionDefeat := ExtractDelimited(2, FInFIGHTLines[14], ['|']);
  end;
  if (UpperCase(Trim(FInFIGHTLines[15])) = 'NONE|NONE') then
  begin
    FightRec.RefFileRun := '';
    FightRec.RefSectionRun := '';
  end else
  begin
    FightRec.RefFileRun := ExtractDelimited(1, FInFIGHTLines[15], ['|']);
    FightRec.RefSectionRun := ExtractDelimited(2, FInFIGHTLines[15], ['|']);
  end;

  Game.ENEMY := FightRec.MonsterName;

  // Setup "action" area
  DoorTextAttr(2);
  CommandCLEARBLOCK(StrToTok('@CLEARBLOCK 21 24', ' '));
  UpdateHitPointLine;

  // Write "sighting" text
  DoorTextAttr(2);
  DoorGotoXY(3, 22);
  DoorWrite(FightRec.SightingText);

  Action := 'A';
  ExitLoop := false;
  repeat
    Action := ChooseToAttackOrRun(Action);

    CommandCLEARBLOCK(StrToTok('@CLEARBLOCK 22 24', ' '));
    DoorGotoXY(3, 22);

    if (Action = 'A') then
    begin
      AttackByPlayer;
      if Not(ExitLoop) then AttackByMonster;
    end else
    if (Action = 'R') then
    begin
      I := Random(100) + 1;
      if (I <= 17) then
      begin
        // 17% chance of failing to run (testing 100 attempts resulted in 17 failures with original L2.EXE)
        DoorGotoXY(3, 22);
        DoorWrite('`0' + FightRec.MonsterName + '`4`r0 blocks your path!');
        Sleep(1000);
        AttackByMonster;
      end else
      begin
        // Run!
        if (FightRec.RefFileRun <> '') AND (FightRec.RefSectionRun <> '') then
        begin
          RTReader.Execute(FightRec.RefFileRun, FightRec.RefSectionRun);
        end;

        ExitLoop := true;
      end;
    end;
  until ExitLoop;

  // Clear "action" area
  DoorTextAttr(2);
  CommandCLEARBLOCK(StrToTok('@CLEARBLOCK 21 24', ' '));
end;

procedure TRTReader.EndREADFILE;
var
  I: Integer;
  LoopMax: Integer;
  SL: TStringList;
begin
  // TODO _InWRITEFILE could be handled like this, so no need for multiple writes per writefile
  if (FileExists(FInREADFILE)) then
  begin
    // TODO Error handling
    SL := TStringList.Create;
    SL.LoadFromFile(FInREADFILE);

    LoopMax := Min(SL.Count, FInREADFILELines.Count) - 1;
    for I := 0 to LoopMax do
    begin
      AssignVariable(FInREADFILELines[I], TranslateVariables(SL[I]));
    end;

    SL.Free;
  end;
end;

procedure TRTReader.EndSAYBAR(AText: String);
var
  SavedTextAttr: Integer;
  SpacesLeft: Integer;
  SpacesRight: Integer;
  StrippedLength: Integer;
begin
  // Save cursor and text attr
  SavedTextAttr := Crt.TextAttr;
  DoorCursorSave;

  // Output new bar
  DoorGotoXY(3, 21);
  DoorTextAttr(31);
  StrippedLength := Length(SethStrip(TranslateVariables(AText)));
  SpacesLeft := Max(0, (76 - StrippedLength) div 2);
  SpacesRight := Max(0, 76 - StrippedLength - SpacesLeft);
  DoorWrite(PadRight('', SpacesLeft) + TranslateVariables(AText) + PadRight('', SpacesRight));
  // TODO say bar should be removed after 5 seconds or so

  // Restore
  DoorCursorRestore;
  DoorTextAttr(SavedTextAttr);
end;

procedure TRTReader.EndSELLMANAGER;
begin
  LogTODO(StrToTok('EndSELLMANAGER', ' '));
end;

procedure TRTReader.EndSHOWSCROLL;
var
  Ch: Char;
  I: Integer;
  LineEnd: Integer;
  LineStart: Integer;
  MaxPage: Integer;
  Page: Integer;
  SavedTextAttr: Integer;
begin
  Page := 1;

  MaxPage := FInSHOWSCROLLLines.Count div 22;
  if (FInSHOWSCROLLLines.Count mod 22 <> 0) then
  begin
    MaxPage += 1;
  end;

  SavedTextAttr := 7;

  Ch := #0;
  repeat
    DoorTextAttr(SavedTextAttr);
    DoorClrScr;

    LineStart := (Page - 1) * 22;
    LineEnd := LineStart + 21;
    for I := LineStart to LineEnd do
    begin
      if (I >= FInSHOWSCROLLLines.Count) then
      begin
        break;
      end;
      DoorWriteLn(FInSHOWSCROLLLines[I]);
    end;
    SavedTextAttr := Crt.TextAttr;

    DoorGotoXY(1, 23);
    DoorTextAttr(31);
    DoorWrite(PadRight('', 79));
    DoorGotoXY(3, 23);
    DoorWrite('(' + IntToStr(Page) + ')');
    DoorGotoXY(9, 23);
    DoorWrite('[N]ext Page, [P]revious Page, [Q]uit, [S]tart, [E]nd');

    Ch := UpCase(DoorReadKey);
    case Ch of
      'E': Page := MaxPage;
      'N': Page := Math.Min(MaxPage, Page + 1);
      'P': Page := Math.Max(1, Page - 1);
      'S': Page := 1;
    end;
  until (Ch = 'Q');
end;

procedure TRTReader.Execute(AFileName: String; ASectionName: String; ALabelName: String);
begin
  if (RTGlobal.RefFiles.FindIndexOf(AFileName) = -1) then
  begin
    DoorWriteLn('`4`b**`% ERROR : `2File `0' + AFileName + ' `2not found. `4`b**`2');
    DoorReadKey;
  end else
  begin
    FCurrentFile := TRTRefFile(RTGlobal.RefFiles.Find(AFileName));

    if (FCurrentFile.Sections.FindIndexOf(ASectionName) = -1) then
    begin
      DoorWriteLn('`4`b**`% ERROR : Section `0' + ASectionName + ' `2not found in `0' + AFileName + ' `4`b**`2');
      DoorReadKey;
    end else
    begin
      FCurrentSection := TRTRefSection(FCurrentFile.Sections.Find(ASectionName));

      if (ALabelName <> '') then
      begin
        if (FCurrentSection.Labels.FindIndexOf(ALabelName) = -1) then
        begin
          DoorWriteLn('`4`b**`% ERROR : Label `0' + ASectionName + ' `2not found in `0' + AFileName + ' `4`b**`2');
          DoorReadKey;
        end else
        begin
          FCurrentLabel := TRTRefLabel(FCurrentSection.Labels.Find(ALabelName));
          FCurrentLineNumber := FCurrentLabel.LineNumber;
        end;
      end;

      ParseScript(FCurrentSection.Script);
    end;
  end;
end;

procedure TRTReader.LogTODO(ATokens: TTokens);
begin
  if (DoorLocal) then
  begin
    FastWrite(PadRight('TODO: ' + TokToStr(ATokens, ' '), 80), 1, 25, 31);
    DoorReadKey;
    FastWrite(PadRight('', 80), 1, 25, 7);
  end;
end;

procedure TRTReader.ParseCommand(ATokens: TTokens);
var
  IFResult: Boolean;
begin
  IFResult := false;

  case UpperCase(ATokens[1]) of
    '@': CommandNOP(ATokens);
    '@ADDCHAR': CommandADDCHAR(ATokens);
    '@BEGIN': CommandBEGIN(ATokens);
    '@BITSET': CommandBITSET(ATokens);
    '@BUSY': CommandBUSY(ATokens);
    '@BUYMANAGER': CommandBUYMANAGER(ATokens);
    '@CHECKMAIL': CommandCHECKMAIL(ATokens);
    '@CHOICE': CommandCHOICE(ATokens);
    '@CHOOSEPLAYER': CommandCHOOSEPLAYER(ATokens);
    '@CLEAR': CommandCLEAR(ATokens);
    '@CLEARBLOCK': CommandCLEARBLOCK(ATokens);
    '@CLOSESCRIPT': CommandCLOSESCRIPT(ATokens);
    '@CONVERT_FILE_TO_ANSI': CommandCONVERT_FILE_TO_ANSI(ATokens);
    '@CONVERT_FILE_TO_ASCII': CommandCONVERT_FILE_TO_ASCII(ATokens);
    '@COPYFILE': CommandCOPYFILE(ATokens);
    '@DATALOAD': CommandDATALOAD(ATokens);
    '@DATANEWDAY': CommandDATANEWDAY(ATokens);
    '@DATASAVE': CommandDATASAVE(ATokens);
    '@DECLARE': CommandDECLARE(ATokens);
    '@DISPLAY': CommandDISPLAY(ATokens);
    '@DISPLAYFILE': CommandDISPLAYFILE(ATokens);
    '@DO':
    begin
      // Check for @DO <COMMAND> commands
      case UpperCase(ATokens[2]) of
        'ADDLOG': CommandDO_ADDLOG(ATokens);
        'BEEP': CommandDO_BEEP(ATokens);
        'COPYTONAME': CommandDO_COPYTONAME(ATokens);
        'DELETE': CommandDO_DELETE(ATokens);
        'FRONTPAD': CommandDO_FRONTPAD(ATokens);
        'GETKEY': CommandDO_GETKEY(ATokens);
        'GOTO': CommandDO_GOTO(ATokens);
        'MOVE': CommandDO_MOVE(ATokens);
        'MOVEBACK': CommandDO_MOVEBACK(ATokens);
        'NUMRETURN': CommandDO_NUMRETURN(ATokens);
        'PAD': CommandDO_PAD(ATokens);
        'QUEBAR': CommandDO_QUEBAR(ATokens);
        'READCHAR': CommandDO_READCHAR(ATokens);
        'READNUM': CommandDO_READNUM(ATokens);
        'READSPECIAL': CommandDO_READSPECIAL(ATokens);
        'READSTRING': CommandDO_READSTRING(ATokens);
        'REPLACE': CommandDO_REPLACE(ATokens);
        'REPLACEALL': CommandDO_REPLACEALL(ATokens);
        'RENAME': CommandDO_RENAME(ATokens);
        'SAYBAR': CommandDO_SAYBAR(ATokens);
        'STATBAR': CommandDO_STATBAR(ATokens);
        'STRIP': CommandDO_STRIP(ATokens);
        'STRIPALL': CommandDO_STRIPALL(ATokens);
        'STRIPBAD': CommandDO_STRIPBAD(ATokens);
        'STRIPCODE': CommandDO_STRIPCODE(ATokens);
        'TALK': CommandDO_TALK(ATokens);
        'TRIM': CommandDO_TRIM(ATokens);
        'UPCASE': CommandDO_UPCASE(ATokens);
        'WRITE': CommandDO_WRITE(ATokens);
        else
        begin
          // Check for @DO <SOMETHING> <COMMAND> commands
          if (High(ATokens) >= 3) then
          begin
            case UpperCase(ATokens[3]) of
              '/': CommandDO_DIVIDE(ATokens);
              '*': CommandDO_MULTIPLY(ATokens);
              '+': CommandDO_ADD(ATokens);
              '-': CommandDO_SUBTRACT(ATokens);
              '=': CommandDO_IS(ATokens);
              'ADD': CommandDO_ADD(ATokens);
              'IS': CommandDO_IS(ATokens);
              'RANDOM': CommandDO_RANDOM(ATokens);
              else LogTODO(ATokens);
            end;
          end else
          begin
            LogTODO(ATokens);
          end;
        end;
      end;
    end;
    '@DRAWMAP': CommandDRAWMAP(ATokens);
    '@DRAWPART': CommandDRAWPART(ATokens);
    '@END': CommandEND(ATokens);
    '@FIGHT': CommandFIGHT(ATokens);
    '@GRAPHICS': CommandGRAPHICS(ATokens);
    '@HALT': CommandHALT(ATokens);
    '@IF':
    begin
      // Check for @IF <COMMAND> commands
      case UpperCase(ATokens[2]) of
        'BITCHECK': IFResult := CommandIF_BITCHECK(ATokens);
        'BLOCKPASSABLE': IFResult := CommandIF_BLOCKPASSABLE(ATokens);
        'CHECKDUPE': IFResult := CommandIF_CHECKDUPE(ATokens);
        else
        begin
          // Check for @IF <SOMETHING> <COMMAND> commands
          case UpperCase(ATokens[3]) of
            'EQUALS': IFResult := CommandIF_IS(ATokens);
            'EXIST': IFResult := CommandIF_EXIST(ATokens);
            'EXISTS': IFResult := CommandIF_EXIST(ATokens);
            'INSIDE': IFResult := CommandIF_INSIDE(ATokens);
            'IS': IFResult := CommandIF_IS(ATokens);
            'LESS': IFResult := CommandIF_LESS(ATokens);
            'MORE': IFResult := CommandIF_MORE(ATokens);
            'NOT': IFResult := CommandIF_NOT(ATokens);
            '=': IFResult := CommandIF_IS(ATokens);
            '<': IFResult := CommandIF_LESS(ATokens);
            '>': IFResult := CommandIF_MORE(ATokens);
            else LogTODO(ATokens);
          end;
        end;
      end;

      // Check if it's an IF block, or inline IF
      if (Pos('THEN DO', UpperCase(TokToStr(ATokens, ' '))) > 0) then
      begin
        // @BEGIN..@END coming, so skip it if our result was false
        if Not(IFResult) then
        begin
          FInIFFalse := FInBEGINCount;
        end;
      end else
      begin
        // Inline DO, so execute it
        if (IFResult) then
        begin
          if (UpperCase(ATokens[6]) = 'THEN') then
          begin
            ParseCommand(StrToTok('@DO ' + TokToStr(ATokens, ' ', 7), ' '));
          end else
          begin
            ParseCommand(StrToTok('@DO ' + TokToStr(ATokens, ' ', 6), ' '));
          end;
        end;
      end;
    end;
    '@ITEMEXIT': CommandITEMEXIT(ATokens);
    '@KEY': CommandKEY(ATokens);
    '@LABEL': CommandLABEL(ATokens);
    '@LOADCURSOR': CommandLOADCURSOR(ATokens);
    '@LOADGLOBALS': CommandLOADGLOBALS(ATokens);
    '@LOADMAP': CommandLOADMAP(ATokens);
    '@LOADWORLD': CommandLOADWORLD(ATokens);
    '@LORDRANK': CommandLORDRANK(ATokens);
    '@MOREMAP': CommandMOREMAP(ATokens);
    '@NAME': CommandNAME(ATokens);
    '@NOCHECK': CommandNOCHECK(ATokens);
    '@OFFMAP': CommandOFFMAP(ATokens);
    '@OVERHEADMAP': CommandOVERHEADMAP(ATokens);
    '@PAUSEOFF': CommandPAUSEOFF(ATokens);
    '@PAUSEON': CommandPAUSEON(ATokens);
    '@PROGNAME': CommandPROGNAME(ATokens);
    '@RANK': CommandRANK(ATokens);
    '@READFILE': CommandREADFILE(ATokens);
    '@ROUTINE': CommandROUTINE(ATokens);
    '@RUN': CommandRUN(ATokens);
    '@SAVECURSOR': CommandSAVECURSOR(ATokens);
    '@SAVEGLOBALS': CommandSAVEGLOBALS(ATokens);
    '@SAVEWORLD': CommandSAVEWORLD(ATokens);
    '@SAY': CommandSAY(ATokens);
    '@SELLMANAGER': CommandSELLMANAGER(ATokens);
    '@SHOW': CommandSHOW(ATokens);
    '@SHOWLOCAL': CommandSHOWLOCAL(ATokens);
    '@UPDATE': CommandUPDATE(ATokens);
    '@UPDATE_UPDATE': CommandUPDATE_UPDATE(ATokens);
    '@VERSION': CommandVERSION(ATokens);
    '@WHOISON': CommandWHOISON(ATokens);
    '@WRITEFILE': CommandWRITEFILE(ATokens);
    else LogTODO(ATokens);
  end;
end;

procedure TRTReader.ParseScript(ALines: TStringList);
var
  F: Text;
  Line: String;
  LineTrimmed: String;
  ScriptLength: LongInt;
  Tokens: Array of String;
begin
  ScriptLength := ALines.Count;
  while (FCurrentLineNumber < ScriptLength) do
  begin
    Line := ALines[FCurrentLineNumber];
    LineTrimmed := Trim(Line);

    if (FInCLOSESCRIPT) then
    begin
      Exit;
    end else
    if (FInIFFalse < 999) then
    begin
      if (Pos('@', LineTrimmed) = 1) then
      begin
        Tokens := StrToTok(LineTrimmed, ' ');
        case UpperCase(Tokens[1]) of
          '@BEGIN':
            FInBEGINCount += 1;
          '@END':
          begin
            FInBEGINCount -= 1;
            if (FInBEGINCount = FInIFFalse) then
            begin
              FInIFFalse := 999;
            end;
          end;
        end;
      end;
    end else
    begin
      if (Pos('@', LineTrimmed) = 1) then
      begin
        if (FInBUYMANAGER) then EndBUYMANAGER;
        if (FInCHOICE) then EndCHOICE;
        if (FInREADFILE <> '') then EndREADFILE;
        if (FInSELLMANAGER) then EndSELLMANAGER;
        if (FInSHOWSCROLL) then EndSHOWSCROLL;
        FInBUYMANAGER := false;
        FInCHOICE := false;
        FInREADFILE := '';
        FInSAY := false;
        FInSAYBAR := false;
        FInSELLMANAGER := false;
        FInSHOW := false;
        FInSHOWLOCAL := false;
        FInSHOWSCROLL := false;
        FInWRITEFILE := '';

        Tokens := StrToTok(LineTrimmed, ' ');
        ParseCommand(Tokens);
      end else
      begin
        if (FInBUYMANAGER) then
        begin
          FInBUYMANAGEROptions.Add(Line);
        end else
        if (FInCHOICE) then
        begin
          FInCHOICEOptions.Add(TRTChoiceOption.Create(Line));
        end else
        if (FInDO_ADDLOG) then
        begin
          // TODO Error handling
          Assign(F, Game.GetSafeAbsolutePath('LOGNOW.TXT'));
          if (FileExists(Game.GetSafeAbsolutePath('LOGNOW.TXT'))) then
          begin
            {$I-}Append(F);{$I+}
          end else
          begin
            {$I-}ReWrite(F);{$I+}
          end;
          if (IOResult = 0) then
          begin
            WriteLn(F, TranslateVariables(Line));
          end;
          Close(F);

          FInDO_ADDLOG := false;
        end else
        if (FInDO_WRITE) then
        begin
          DoorWrite(TranslateVariables(Line));
          FInDO_WRITE := false;
        end else
        if (FInFIGHT) then
        begin
          if ((LineTrimmed <> '') AND NOT(AnsiStartsText(';', LineTrimmed))) then
          begin
            FInFIGHTLines.Add(Line);
            if (FInFIGHTLines.Count = 16) then
            begin
              EndFIGHT;
              FInFIGHT := false;
            end;
          end;
        end else
        if (FInREADFILE <> '') then
        begin
          FInREADFILELines.Add(Line);
        end else
        if (FInSAY) then
        begin
          // TODO SHould be in TEXT window (but since LORD2 doesn't use @SAY, not a high priority)
          DoorWrite(TranslateVariables(Line));
        end else
        if (FInSAYBAR) then
        begin
          EndSAYBAR(Line);
          FInSAYBAR := false;
        end else
        if (FInSELLMANAGER) then
        begin
          FInSELLMANAGEROptions.Add(Line);
        end else
        if (FInSHOW) then
        begin
          DoorWriteLn(TranslateVariables(Line));
        end else
        if (FInSHOWLOCAL) then
        begin
          AnsiWrite(TranslateVariables(Line) + #13#10);
        end else
        if (FInSHOWSCROLL) then
        begin
          FInSHOWSCROLLLines.Add(TranslateVariables(Line));
        end else
        if (FInWRITEFILE <> '') then
        begin
          // TODO Error handling
          Assign(F, FInWRITEFILE);
          if (FileExists(FInWRITEFILE)) then
          begin
            {$I-}Append(F);{$I+}
          end else
          begin
            {$I-}ReWrite(F);{$I+}
          end;
          if (IOResult = 0) then
          begin
            WriteLn(F, TranslateVariables(Line));
          end;
          Close(F);
        end;
      end;
    end;

    FCurrentLineNumber += 1;
  end;
end;

function TRTReader.TranslateVariables(AText: String): String;
var
  I: Integer;
  TextUpper: String;
begin
  // TODO commas get added to numbers (ie 123456 is 123,456)
  TextUpper := UpperCase(Trim(AText));

  // Handle variables that must match exactly
  case TextUpper of
    'BANK': AText := IntToStr(Game.Player.bank);
    'DEAD': AText := IntToStr(Game.Player.dead);
    'ENEMY': AText := Game.ENEMY;
    'GOLD': AText := IntToStr(Game.Player.Money);
    'LOCAL':
    begin
      if (DoorLocal) then
      begin
        AText := '5';
      end else
      begin
        AText := '0';
      end;
    end;
    'MAP': AText := IntToStr(Game.Player.map);
    'MONEY': AText := IntToStr(Game.Player.Money);
    'NARM': AText := IntToStr(Game.Player.ArmourNumber);
    'NIL': AText := '';
    'NWEP': AText := IntToStr(Game.Player.WeaponNumber);
    'RESPONCE', 'RESPONSE': AText := Game.RESPONSE;
    'SEXMALE': AText := IntToStr(Game.Player.SexMale);
    'X': AText := IntToStr(Game.Player.x);
    'Y': AText := IntToStr(Game.Player.y);
    else
    begin
      if (Pos('&', TextUpper) > 0) then
      begin
        // Handle "ampersand" codes
        AText := StringReplace(AText, '&realname', DoorDropInfo.Alias, [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '&nicedate', FormatDateTime('h:nn', Now) + ' on ' + FormatDateTime('yyyy/mm/dd', Now), [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '&date', FormatDateTime('yyyy/mm/dd', Now), [rfReplaceAll, rfIgnoreCase]);
        if (Game.Player.ArmourNumber = 0) then
        begin
          AText := StringReplace(AText, 's&armour', '', [rfReplaceAll, rfIgnoreCase]);
          AText := StringReplace(AText, 's&arm_num', '0', [rfReplaceAll, rfIgnoreCase]);
        end else
        begin
          AText := StringReplace(AText, 's&armour', Game.ItemsDat.Item[Game.Player.ArmourNumber].Name, [rfReplaceAll, rfIgnoreCase]);
          AText := StringReplace(AText, 's&arm_num', IntToStr(Game.ItemsDat.Item[Game.Player.ArmourNumber].Defence), [rfReplaceAll, rfIgnoreCase]);
        end;
        if (Game.Player.WeaponNumber = 0) then
        begin
          AText := StringReplace(AText, 's&weapon', '', [rfReplaceAll, rfIgnoreCase]);
          AText := StringReplace(AText, 's&wep_num', '0', [rfReplaceAll, rfIgnoreCase]);
        end else
        begin
          AText := StringReplace(AText, 's&weapon', Game.ItemsDat.Item[Game.Player.WeaponNumber].Name, [rfReplaceAll, rfIgnoreCase]);
          AText := StringReplace(AText, 's&wep_num', IntToStr(Game.ItemsDat.Item[Game.Player.WeaponNumber].Strength), [rfReplaceAll, rfIgnoreCase]);
        end;
        if (Game.Player.SexMale = 1) then
        begin
          AText := StringReplace(AText, 's&son', 'son', [rfReplaceAll, rfIgnoreCase]);
          AText := StringReplace(AText, 's&boy', 'boy', [rfReplaceAll, rfIgnoreCase]);
          AText := StringReplace(AText, 's&man', 'man', [rfReplaceAll, rfIgnoreCase]);
          AText := StringReplace(AText, 's&sir', 'sir', [rfReplaceAll, rfIgnoreCase]);
          AText := StringReplace(AText, 's&him', 'him', [rfReplaceAll, rfIgnoreCase]);
          AText := StringReplace(AText, 's&his', 'his', [rfReplaceAll, rfIgnoreCase]);
        end else
        begin
          AText := StringReplace(AText, 's&son', 'daughter', [rfReplaceAll, rfIgnoreCase]);
          AText := StringReplace(AText, 's&boy', 'girl', [rfReplaceAll, rfIgnoreCase]);
          AText := StringReplace(AText, 's&man', 'lady', [rfReplaceAll, rfIgnoreCase]);
          AText := StringReplace(AText, 's&sir', 'ma''am', [rfReplaceAll, rfIgnoreCase]);
          AText := StringReplace(AText, 's&him', 'her', [rfReplaceAll, rfIgnoreCase]);
          AText := StringReplace(AText, 's&his', 'hers', [rfReplaceAll, rfIgnoreCase]);
        end;
        AText := StringReplace(AText, '&money', IntToStr(Game.Player.WeaponNumber), [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '&bank', IntToStr(Game.Player.bank), [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '&lastx', IntToStr(Game.LastX), [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '&lasty', IntToStr(Game.LastY), [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '&map', IntToStr(Game.Player.map), [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '&lmap', IntToStr(Game.Player.LastMap), [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '&timeleft', IntToStr(DoorSecondsLeft div 60), [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '&time', IntToStr(Game.Time), [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '&sex', IntToStr(Game.Player.SexMale), [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '&playernum', IntToStr(Game.PlayerNum), [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '&totalaccounts', IntToStr(Game.TotalAccounts), [rfReplaceAll, rfIgnoreCase]);
      end;

      if (Pos('`', TextUpper) > 0) then
      begin
        // Handle "Seth" codes
        AText := StringReplace(AText, '`N', Game.Player.name, [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '`E', Game.ENEMY, [rfReplaceAll, rfIgnoreCase]);
        if (DoorDropInfo.Emulation = etANSI) then
        begin
          AText := StringReplace(AText, '`G', '3', [rfReplaceAll, rfIgnoreCase]);
        end else
        begin
          AText := StringReplace(AText, '`G', '0', [rfReplaceAll, rfIgnoreCase]);
        end;
        AText := StringReplace(AText, '`X', ' ', [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '`D', #8, [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '`\', #13#10, [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '`c', AnsiClrScr + #13#10#13#10, [rfReplaceAll, rfIgnoreCase]);

        // Handle player and global variables
        if (Pos('`I', TextUpper) > 0) then
        begin
          for I := Low(Game.Player.I) to High(Game.Player.I) do
          begin
            AText := StringReplace(AText, '`I' + AddChar('0', IntToStr(I), 2), IntToStr(Game.Player.I[I]), [rfReplaceAll, rfIgnoreCase]);
          end;
        end;
        if (Pos('`P', TextUpper) > 0) then
        begin
          for I := Low(Game.Player.p) to High(Game.Player.p) do
          begin
            AText := StringReplace(AText, '`P' + AddChar('0', IntToStr(I), 2), IntToStr(Game.Player.p[I]), [rfReplaceAll, rfIgnoreCase]);
          end;
        end;
        if (Pos('`+', TextUpper) > 0) then
        begin
          for I := Low(Game.ItemsDat.Item) to High(Game.ItemsDat.Item) do
          begin
            AText := StringReplace(AText, '`+' + AddChar('0', IntToStr(I), 2), Game.ItemsDat.Item[I].name, [rfReplaceAll, rfIgnoreCase]);
          end;
        end;
        if (Pos('`S', TextUpper) > 0) then
        begin
          for I := Low(Game.WorldDat.s) to High(Game.WorldDat.s) do
          begin
            AText := StringReplace(AText, '`S' + AddChar('0', IntToStr(I), 2), Game.WorldDat.s[I], [rfReplaceAll, rfIgnoreCase]);
          end;
        end;
        if (Pos('`T', TextUpper) > 0) then
        begin
          for I := Low(Game.Player.T) to High(Game.Player.T) do
          begin
            AText := StringReplace(AText, '`T' + AddChar('0', IntToStr(I), 2), IntToStr(Game.Player.T[I]), [rfReplaceAll, rfIgnoreCase]);
          end;
        end;
        if (Pos('`V', TextUpper) > 0) then
        begin
          for I := Low(Game.WorldDat.v) to High(Game.WorldDat.v) do
          begin
            AText := StringReplace(AText, '`V' + AddChar('0', IntToStr(I), 2), IntToStr(Game.WorldDat.v[I]), [rfReplaceAll, rfIgnoreCase]);
          end;
        end;
      end;
    end;
  end;

  Result := AText;
end;

begin
  Randomize;
end.

