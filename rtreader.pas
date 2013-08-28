unit RTReader;

interface

uses
  MannDoor, mCrt, mStrings, SysUtils, Classes, contnrs, RTRefFile, RTRefSection,
  RTRefLabel, RTGlobal, RTChoiceOption, Crt, Math, mAnsi, StrUtils, Struct;

type
  TRTReader = class
  private
    FCurrentLabel: TRTRefLabel;
    FCurrentLineNumber: Integer;
    FCurrentFile: TRTRefFile;
    FCurrentSection: TRTRefSection;

    FInBEGINCount: Integer;
    FInCHOICE: Boolean;
    FInCHOICEOptions: TFPObjectList;
    FInCLOSESCRIPT: Boolean;
    FInDO_ADDLOG: Boolean;
    FInDO_WRITE: Boolean;
    FInHALT: Integer;
    FInIFFalse: Integer;
    FInREADFILE: String;
    FInREADFILELines: TStringList;
    FInSAY: Boolean;
    FInSAYBAR: Boolean;
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

    procedure CommandIF_BITCHECK(ATokens: TTokens);
    procedure CommandIF_BLOCKPASSABLE(ATokens: TTokens);
    procedure CommandIF_CHECKDUPE(ATokens: TTokens);
    procedure CommandIF_EXIST(ATokens: TTokens);
    procedure CommandIF_INSIDE(ATokens: TTokens);
    procedure CommandIF_IS(ATokens: TTokens);
    procedure CommandIF_LESS(ATokens: TTokens);
    procedure CommandIF_MORE(ATokens: TTokens);
    procedure CommandIF_NOT(ATokens: TTokens);

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

    procedure EndCHOICE;
    procedure EndREADFILE;
    procedure EndSAYBAR(AText: String);
    procedure EndSHOWSCROLL;

    procedure Execute(AFileName: String; ASectionName: String; ALabelName: String);

    procedure LogMissing(ATokens: TTokens);
    procedure LogUnimplemented(ATokens: TTokens);
    procedure LogUnused(ATokens: TTokens);

    procedure ParseCommand(ATokens: TTokens);
    procedure ParseScript(ALines: TStringList);

    function TranslateVariables(AText: String): String;
  public
    constructor Create;
    destructor Destroy; override;
  end;

procedure Execute(AFileName: string; ASectionName: string);

implementation

uses
  Game;

procedure TRTReader.AssignVariable(AVariable: String; AValue: String);
var
  VariableUpper: String;
  VariableSkipTwo: String;
begin
  // TODO Instead of translating before calling this function, maybe this function should translate and then
  //      other functions could pass in the raw string
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

procedure Execute(AFileName: string; ASectionName: string);
label
  HandleGOTO;
var
  LabelName: String;
  RTR: TRTReader;
begin
  LabelName := '';

  HandleGOTO:

  AFileName := UpperCase(Trim(ChangeFileExt(AFileName, '')));
  ASectionName := UpperCase(Trim(ASectionName));
  LabelName := UpperCase(Trim(LabelName));

  RTR := TRTReader.Create();
  RTR.Execute(AFileName, ASectionName, LabelName);
  // TODO If returned with a GOTO, goto HandleGOTO
  // TODO Also check for HALT (although maybe HALT will be handled immediately
  //      and an ExitProc in LORD2.lpr can handle saving the player data?
end;

constructor TRTReader.Create;
begin
  inherited Create;

  FInBEGINCount := 0;
  FInCHOICE := false;
  FInCHOICEOptions := TFPObjectList.Create;
  FInCLOSESCRIPT := false;
  FInDO_ADDLOG := false;
  FInDO_WRITE := false;
  FInHALT := -1;
  FInIFFalse := 999;
  FInREADFILE := '';
  FInREADFILELines := TStringList.Create;
  FInSAY := false;
  FInSAYBAR := false;
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
  // TODO a race condition could cause these two inserts to be out of sync

  // TODO Retry if IOError
  Assign(FTraderDat, TraderDatFileName);
  {$I-}Reset(FTraderDat);{$I+}
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
  UTR.OnNow := 0;
  UTR.Busy := 0;
  UTR.Battle := 0;
  // TODO Retry if IOError
  Assign(FUpdateTmp, UpdateTmpFileName);
  {$I-}Reset(FUpdateTmp);{$I+}
  if (IOResult = 0) then
  begin
    Seek(FUpdateTmp, FileSize(FUpdateTmp));
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
  // TODO Implement
end;

procedure TRTReader.CommandBUYMANAGER(ATokens: TTokens);
begin
    (* @BUYMANAGER
        <item number>
        <item number>
        <ect until next @ at beginning of string is hit>
        This command offers items for sale at the price set in items.dat *)
    // TODO Implement
end;

procedure TRTReader.CommandCHECKMAIL(ATokens: TTokens);
begin
    (* @CHECKMAIL
        Undocumented.  Will need to determine what this does *)
    // TODO Implement
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

  FInCHOICEOptions.Clear();
  FInCHOICE := true;
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
      CommandCLEAR(Tokenize('@CLEAR USERSCREEN', ' '));
      CommandCLEAR(Tokenize('@CLEAR PICTURE', ' '));
      CommandCLEAR(Tokenize('@CLEAR TEXT', ' '));
      CommandCLEAR(Tokenize('@CLEAR NAME', ' '));
      // TODO And redraws the screen
    end;
    'NAME':
    begin
      (* @CLEAR NAME
          This deletes the name line of the game window. *)
      mGotoXY(55, 15);
      mWrite(mStrings.PadRight('', ' ', 22));
    end;
    'PICTURE':
    begin
      (* @CLEAR PICTURE
          This clears the picture. *)
      for Y := 3 to 13 do
      begin
          mGotoXY(55, y);
          mWrite(mStrings.PadRight('', ' ', 22));
      end;
    end;
    'SCREEN':
    begin
      (* @CLEAR SCREEN
          This command clears the entire screen. *)
      mClrScr();
    end;
    'TEXT':
    begin
      (* @CLEAR TEXT
          This clears game text. *)
      for Y := 3 to 13 do
      begin
          mGotoXY(32, y);
          mWrite(mStrings.PadRight('', ' ', 22));
      end;
    end;
    'USERSCREEN':
    begin
      (* @CLEAR USERSCREEN
          This clears user text. *)
      for Y := 16 to 23 do
      begin
          mGotoXY(1, y);
          mWrite(mStrings.PadRight('', ' ', 80));
      end;
      mGotoXY(78, 23);
    end;
    else
      LogMissing(ATokens);
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
  mTextAttr(7);

  Top := StrToInt(ATokens[2]);
  Bottom := StrToInt(ATokens[3]);
  for I := Top to Bottom do
  begin
      mGotoXY(1, i);
      mWrite(mStrings.PadRight('', ' ', 80));
  end;

  mGotoXY(1, bottom);
  mTextColor(SavedTextAttr AND $0F);
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
        Converts a text file of Sethansi (whatever) to regular ansi.  This is good for
        a final score output. *)
    // TODO Implement
end;

procedure TRTReader.CommandCONVERT_FILE_TO_ASCII(ATokens: TTokens);
begin
    (* @CONVERT_FILE_TO_ASCII <input file> <output file>
        Converts a text file of Sethansi (whatever) to regular ascii, ie, no colors at
        all. *)
    // TODO Implement
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
    mWriteLn('`4`b**`b `%ERROR : `2File `0' + FileName + ' `2not found. `4`b**`b`2');
    mReadKey;
  end else
  begin
    RefFile := TRTRefFile(RTGlobal.RefFiles.Find(FileName));

    if (RefFile.Sections.FindIndexOf(SectionName) = -1) then
    begin
      mWriteLn('`4`b**`b `%ERROR : Section `0' + SectionName + ' `2not found in `0' + FileName + ' `4`b**`b`2');
      mReadKey;
    end else
    begin
      RefSection := TRTRefSection(RefFile.Sections.Find(SectionName));
      mWriteLn(TranslateVariables(RefSection.Script.Text));
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
    mWrite(TranslateVariables(SL.Text));
    SL.Free;
  end;
end;

procedure TRTReader.CommandDO_ADD(ATokens: TTokens);
var
  I: Integer;
  S: String;
begin
  (* @DO <Number To Change> <How To Change It> <Change With What> *)
  if (ATokens[3] = '+') then
  begin
      AssignVariable(ATokens[2], IntToStr(StrToInt(TranslateVariables(ATokens[2])) + StrToInt(TranslateVariables(ATokens[4]))));
  end else
  if (UpperCase(ATokens[3]) = 'ADD') then
  begin
    S := ATokens[4];
    for I := 5 to Length(ATokens) - 1 do
    begin
      S := S + ' ' + ATokens[I];
    end;
    AssignVariable(ATokens[2], TranslateVariables(ATokens[2] + S));
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
  StringLength: Integer;
  RequestedLength: Integer;
begin
  (* @DO FRONTPAD <string variable> <length>
      This adds spaces to the front of the string until the string is as long as
      <length>. *)
  StringLength := Length(TranslateVariables(ATokens[3])); // TODO Length(mStripSeth(TranslateVariables(ATokens[3])));
  RequestedLength := StrToInt(TranslateVariables(ATokens[4]));
  if (StringLength < RequestedLength) then
  begin
      AssignVariable(ATokens[3], mStrings.PadLeft(TranslateVariables(ATokens[3]), ' ', RequestedLength));
  end;
end;

procedure TRTReader.CommandDO_GETKEY(ATokens: TTokens);
begin
  (* @DO GETKEY <String variable to put it in>
      This command is useful, *IF* a key IS CURRENTLY being pressed, it puts that
      key into the string variable.  Otherwise, it puts a '_' in to signal no key was
      pressed.  This is a good way to stop a loop. *)
  if (mKeyPressed) then
  begin
    AssignVariable(ATokens[3], mReadKey);
  end else
  begin
    AssignVariable(ATokens[3], '_');
  end;
end;

procedure TRTReader.CommandDO_GOTO(ATokens: TTokens);
begin
  (* @DO GOTO <header or label>
      Passes control of the script to the header or label specified. *)
  (*TODO  if (_CurrentFile.Sections.ContainsKey(ATokens[3]))
  {
      // HEADER goto
      RTReader RTR = new RTReader();
      _InHALT = RTR.RunSection(_CurrentFile.Name, TranslateVariables(ATokens[3]));
      _InCLOSESCRIPT = true; // Don't want to resume this ref
  }
  else if (_CurrentSection.Labels.ContainsKey(ATokens[3]))
  {
      // LABEL goto within current section
      _CurrentLineNumber = _CurrentSection.Labels[tokens[2]];
  }
  else
  {
      foreach (KeyValuePair<string, RTRefSection> KVP in _CurrentFile.Sections)
      {
          if (KVP.Value.Labels.ContainsKey(ATokens[3]))
          {
              // LABEL goto within a different section
              RTReader RTR = new RTReader();
              _InHALT = RTR.RunSection(_CurrentFile.Name, KVP.Key, TranslateVariables(ATokens[3]));
              _InCLOSESCRIPT = true; // Don't want to resume this ref
              break;
          }
      }
  }    *)
end;

procedure TRTReader.CommandDO_IS(ATokens: TTokens);
var
  F: File of TraderDatCollection;
  I: Integer;
  PlayerNumber: Integer;
  S: String;
  TDC: TraderDatCollection;
begin
  (* @DO <Number To Change> <How To Change It> <Change With What> *)
  if (UpperCase(ATokens[4]) = 'DELETED') then
  begin
    (* @DO `p20 is deleted 8
        Puts 1 (player is deleted) or 0 (player is not deleted) in `p20.  This only
        works with `p variables.  The account number can be a `p variable. *)
    PlayerNumber := StrToInt(TranslateVariables(ATokens[5]));

    // TODO Error handling
    Assign(F, TraderDatFileName);
    {$I-}Reset(F);{$I+}
    if (IOResult = 0) then
    begin
      Read(F, TDC);
    end;
    Close(F);

    AssignVariable(ATokens[2], IntToStr(TDC.Player[PlayerNumber].Deleted));
  end else
  if (UpperCase(ATokens[4]) = 'GETNAME') then
  begin
    (* @DO `s01 is getname 8
        This would get the name of player 8 and put it in `s01.  This only works with
        `s variables.  The account number can be a `p variable. *)
    PlayerNumber := StrToInt(TranslateVariables(ATokens[5]));

    // TODO Error handling
    Assign(F, TraderDatFileName);
    {$I-}Reset(F);{$I+}
    if (IOResult = 0) then
    begin
      Read(F, TDC);
    end;
    Close(F);

    AssignVariable(ATokens[2], TDC.Player[PlayerNumber].Name);
  end else
  if (UpperCase(ATokens[4]) = 'LENGTH') then
  begin
    (* @DO <number variable> IS LENGTH <String variable>
        Gets length, smart way. *)
    //TODO AssignVariable(ATokens[2], mStripSeth(TranslateVariables(ATokens[5])).Length.ToString());
    AssignVariable(ATokens[2], IntToStr(Length(TranslateVariables(ATokens[5]))));
  end else
  if (UpperCase(ATokens[4]) = 'REALLENGTH') then
  begin
    (* @DO <number variable> IS REALLENGTH <String variable>
        Gets length dumb way. (includes '`' codes without deciphering them.) *)
    AssignVariable(ATokens[2], IntToStr(Length(TranslateVariables(ATokens[5]))));
  end else
  begin
    S := ATokens[4];
    for I := 5 to Length(ATokens) - 1 do
    begin
      S := S + ' ' + ATokens[I];
    end;
    AssignVariable(ATokens[2], TranslateVariables(S));
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
    mGotoXY(X, Y);
  end else
  if (X > 0) then
  begin
    mGotoX(X);
  end else
  if (Y > 0) then
  begin
    mGotoY(Y);
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
//TODO AssignVariable(ATokens[2], (StrToInt(TranslateVariables(ATokens[2])) * StrToInt(TranslateVariables(ATokens[4]))).ToString());
end;

procedure TRTReader.CommandDO_NUMRETURN(ATokens: TTokens);
begin
(* @DO NUMRETURN <int var> <string var>
    Undocumented.  Seems to return the number of integers in the given string
    Example "123test456" returns 6 because there are 6 numbers *)
  (*TODOstring Translated = TranslateVariables(ATokens[4]);
string TranslatedWithoutNumbers = Regex.Replace(Translated, "[0-9]", "", RegexOptions.IgnoreCase);
AssignVariable(ATokens[3], (Translated.Length - TranslatedWithoutNumbers.Length).ToString());*)
end;

procedure TRTReader.CommandDO_PAD(ATokens: TTokens);
begin
(* @DO PAD <string variable> <length>
    This adds spaces to the end of the string until string is as long as <length>. *)
  (*TODOint StringLength = mStripSeth(TranslateVariables(ATokens[3])).Length;
int RequestedLength = StrToInt(ATokens[4]);
if (StringLength < RequestedLength)
{
    AssignVariable(ATokens[3], StringUtils.PadRight(TranslateVariables(ATokens[3]), ' ', StrToInt(ATokens[4])));
}       *)
end;

procedure TRTReader.CommandDO_QUEBAR(ATokens: TTokens);
begin
    (* @DO quebar
        <message>
        This adds a message to the saybar que.  This will ensure that the message is
        displayed at it's proper time instead of immediately. *)
    // TODO Implement
end;

procedure TRTReader.CommandDO_RANDOM(ATokens: TTokens);
begin
  (* @DO <Varible to put # in> RANDOM <Highest number> <number to add to it>
      RANDOM 5 1 will pick a number between 0 (inclusive) and 5 (exclusive) and add 1 to it, resulting in 1-5
      RANDOM 100 200 will pick a number between 0 (inclusive) and 100 (exclusive) and add 200 to it, resulting in 200-299 *)
  (*TODO  int Min = StrToInt(ATokens[5]);
  int Max = Min + StrToInt(ATokens[4]);
  AssignVariable(ATokens[2], _R.Next(Min, Max).ToString());*)
end;

procedure TRTReader.CommandDO_READCHAR(ATokens: TTokens);
begin
  (* @DO READCHAR <string variable to put it in>
                 Waits for a key to be pressed.  This uses DV and Windows time slicing while
                 waiting.  `S10 doesn't seem to work with this command.  All the other `S
                 variables do though. *)
  (*TODO             char? Ch = mReadKey();
             if (Ch == null)
             {
                 AssignVariable(ATokens[3], "\0");
             }
             else
             {
                 AssignVariable(ATokens[3], Ch.ToString());
             }*)
end;

procedure TRTReader.CommandDO_READNUM(ATokens: TTokens);
begin
(* @DO READNUM <MAX LENGTH> <DEFAULT> (Optional: <FOREGROUND COLOR> <BACKGROUND COLOR>
    The number is put into `V40.
    The READNUM procedure is a very nice string editer to get a number in. It
    supports arrow keys and such. *)
  (*TODOstring Default = "";
if (tokens.Length >= 4) Default = TranslateVariables(ATokens[4]);

string ReadNum = mInput(Default, CharacterMask.Numeric, '\0', StrToInt(TranslateVariables(ATokens[3])), StrToInt(TranslateVariables(ATokens[3])), 31);
int AnswerInt = 0;
if (!int.TryParse(ReadNum, out AnswerInt)) AnswerInt = 0;

AssignVariable("`V40", AnswerInt.ToString());*)
end;

procedure TRTReader.CommandDO_READSPECIAL(ATokens: TTokens);
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
  (*TODOchar? Ch = null;
while (true)
{
    Ch = mReadKey();
    if (Ch != null)
    {
        Ch = char.ToUpper((char)Ch);
        if (Ch == '\r')
        {
            // Assign first option when enter is hit
            AssignVariable(ATokens[3], tokens[3][0].ToString());
            break;
        }
        else if (UpperCase(ATokens[4]).Contains(Ch.ToString()))
        {
            // Assign selected character
            AssignVariable(ATokens[3], Ch.ToString());
            break;
        }
    }
}       *)
end;

procedure TRTReader.CommandDO_READSTRING(ATokens: TTokens);
begin
(* @DO READSTRING <MAX LENGTH> <DEFAULT> <variable TO PUT IT IN>
    Get a string.  Uses same string editer as READNUM.
    Note:  You can only use the `S01 through `S10 vars for READSTRING.  You can
    also use these vars for the default.  (or `N)  Use NIL if you want the default
    to be nothing.  (if no variable to put it in is specified, it will be put into `S10
    for compatibilty with old .REF's) *)
  (*TODOstring ReadString = mInput(Regex.Replace(TranslateVariables(ATokens[4]), "NIL", "", RegexOptions.IgnoreCase), CharacterMask.All, '\0', StrToInt(TranslateVariables(ATokens[3])), StrToInt(TranslateVariables(ATokens[3])), 31);
if (tokens.Length >= 5)
{
    AssignVariable(ATokens[5], ReadString);
}
else
{
    AssignVariable("`S10", ReadString);
}       *)
end;

procedure TRTReader.CommandDO_REPLACE(ATokens: TTokens);
begin
  (* @DO REPLACE <X> <Y> <in `S10>
      Replaces X with Y in an `s variable. *)
  // Identified as @REPLACE not @DO REPLACE in the docs
  // The following regex matches only the first instance of the word foo: (?<!foo.*)foo (from http://stackoverflow.com/a/148561/342378)
//TODO  AssignVariable(ATokens[5], Regex.Replace(TranslateVariables(ATokens[5]), "(?<!" + Regex.Escape(TranslateVariables(ATokens[3])) + ".*)" + Regex.Escape(TranslateVariables(ATokens[3])), TranslateVariables(ATokens[4]), RegexOptions.IgnoreCase));
end;

procedure TRTReader.CommandDO_REPLACEALL(ATokens: TTokens);
begin
  (* @DO REPLACEALL <X> <Y> <in `S10>:
      Same as above but replaces all instances. *)
  // Identified as @REPLACEALL not @DO REPLACEALL in the docs
//TODO  AssignVariable(ATokens[5], Regex.Replace(TranslateVariables(ATokens[5]), Regex.Escape(TranslateVariables(ATokens[3])), TranslateVariables(ATokens[4]), RegexOptions.IgnoreCase));
end;

procedure TRTReader.CommandDO_RENAME(ATokens: TTokens);
begin
  (* @DO RENAME <old name> <new name>
      Undocumented.  Renames a file *)
  (*TODO  string OldFile = Game.GetSafeAbsolutePath(TranslateVariables(ATokens[3]));
  string NewFile = Game.GetSafeAbsolutePath(TranslateVariables(ATokens[4]));
  if ((OldFile <> '') && (NewFile <> '') && (File.Exists(OldFile)))
  {
      FileUtils.FileMove(OldFile, NewFile);
  }*)
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
    // TODO Unused
end;

procedure TRTReader.CommandDO_STRIP(ATokens: TTokens);
begin
  (* @DO STRIP <string variable>
      This strips beginning and end spaces of a string. *)
//TODO  AssignVariable(ATokens[3], TranslateVariables(ATokens[3]).Trim());
end;

procedure TRTReader.CommandDO_STRIPALL(ATokens: TTokens);
begin
    (* @DO STRIPALL
        This command strips out all ` codes.  This is good for passwords, etc. *)
    // TODO Unused
end;

procedure TRTReader.CommandDO_STRIPBAD(ATokens: TTokens);
begin
    (* @DO STRIPBAD
        This strips out illegal ` codes, and replaces badwords with the standard
        badword.dat file. *)
    // TODO Implement
end;

procedure TRTReader.CommandDO_STRIPCODE(ATokens: TTokens);
begin
    (* @STRIPCODE <any `s variable>
        This will remove ALL ` codes from a string. *)
    // TODO Unused
end;

procedure TRTReader.CommandDO_SUBTRACT(ATokens: TTokens);
begin
  (* @DO <Number To Change> <How To Change It> <Change With What> *)
//TODO  AssignVariable(ATokens[2], (StrToInt(TranslateVariables(ATokens[2])) - StrToInt(TranslateVariables(ATokens[4]))).ToString());
end;

procedure TRTReader.CommandDO_TALK(ATokens: TTokens);
begin
    (* @DO TALK <message> [recipients]
        Undocumented. Looks like recipients is usually ALL, which sends a global message
        Lack of recipients value means message is only displayed to those on the same screen *)
    // TODO Implement
end;

procedure TRTReader.CommandDO_TRIM(ATokens: TTokens);
begin
  (* @DO TRIM <file name> <number to trim to>
                  This nifty command makes text file larger than <number to trim to> get
                  smaller.  (It deletes lines from the top until the file is correct # of lines,
                  if smaller than <number to trim to>, it doesn't change the file) *)
  (*TODO              string FileName = Game.GetSafeAbsolutePath(TranslateVariables(ATokens[3]));
              if (File.Exists(FileName))
              {
                  int MaxLines = StrToInt(TranslateVariables(ATokens[4]));
                  List<string> Lines = new List<string>();
                  Lines.AddRange(FileUtils.FileReadAllLines(FileName, RMEncoding.Ansi));
                  if (Lines.Count > MaxLines)
                  {
                      while (Lines.Count > MaxLines) Lines.RemoveAt(0);
                      FileUtils.FileWriteAllLines(FileName, Lines.ToArray(), RMEncoding.Ansi);
                  }
              }    *)
end;

procedure TRTReader.CommandDO_UPCASE(ATokens: TTokens);
begin
(* @DO UPCASE <string variable>
    This makes a string all capitals. *)
//TODO AssignVariable(ATokens[3], TranslateVariables(ATokens[3]).ToUpper());
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
(*TODO  EventHandler Handler = RTGlobal.OnDRAWMAP;
  if (Handler != null) Handler(null, EventArgs.Empty);*)
end;

procedure TRTReader.CommandDRAWPART(ATokens: TTokens);
begin
    (* @DRAWPART <x> <y>
        This command will draw one block of the current map as defined by <x> and <y>
        with whatever is supposed to be there, including any people. *)
    // TODO Implement
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
    // TODO Implement
end;

procedure TRTReader.CommandGRAPHICS(ATokens: TTokens);
begin
    (* @GRAPHICS IS <Num>
        3 or more enable remote ANSI.  If you never wanted to send ANSI, you could set
        this to 1. You will probably never touch this one. *)
    // TODO Unused
end;

procedure TRTReader.CommandHALT(ATokens: TTokens);
begin
  (* @HALT <error level>
      This command closes the door and returns the specified error level. *)
  (*TODO  if (tokens.Length == 1)
  {
      _InHALT = 0;
  }
  else
  {
      _InHALT = StrToInt(ATokens[2]);
  }       *)
end;

procedure TRTReader.CommandIF_BITCHECK(ATokens: TTokens);
begin
  (* @IF bitcheck <`t variable> <bit number> <0 or 1>
      Check if the given bit is set or not in the given `t variable *)
  // TODO Untested
//TODO  return ((StrToInt(TranslateVariables(ATokens[3])) & (1 << StrToInt(TranslateVariables(ATokens[4])))) == StrToInt(TranslateVariables(ATokens[5])));
end;

procedure TRTReader.CommandIF_BLOCKPASSABLE(ATokens: TTokens);
begin
  (* @if blockpassable <is or not> <0 or 1> *)
//TODO  return (Global.CurrentMap.W[(Global.Player.Y - 1) + ((Global.Player.X - 1) * 20)].Terrain == 1);
end;

procedure TRTReader.CommandIF_CHECKDUPE(ATokens: TTokens);
begin
  (* @if checkdupe <`s variable> <true or false>
      Check if the given player name already exists *)
  (*TODO  string GameName = TranslateVariables(ATokens[3]);
  bool TrueFalse = Convert.ToBoolean(TranslateVariables(ATokens[4]));

  TraderDatRecord TDR;
  bool Exists = (Global.LoadPlayerByGameName(GameName, out TDR) != -1);
  return (Exists == TrueFalse);*)
end;

procedure TRTReader.CommandIF_EXIST(ATokens: TTokens);
begin
  (* @IF <filename> EXIST <true or false>
      Undocumented.  Checks if given file exists *)
  (*TODO  string Left = TranslateVariables(ATokens[2]);
  string Right = TranslateVariables(ATokens[4]);

  string FileName = Game.GetSafeAbsolutePath(Left);
  bool TrueFalse = Convert.ToBoolean(Right.ToUpper());
  return (File.Exists(FileName) == TrueFalse);*)
end;

procedure TRTReader.CommandIF_INSIDE(ATokens: TTokens);
begin
  (* @IF <Word or variable> INSIDE <Word or variable>
      This allows you to search a string for something inside of it.  Not case
      sensitive. *)
  (*TODO  string Left = TranslateVariables(ATokens[2]);
  string Right = TranslateVariables(ATokens[4]);

  return Right.ToUpper().Contains(Left.ToUpper());*)
end;

procedure TRTReader.CommandIF_IS(ATokens: TTokens);
begin
  (*TODO  string Left = TranslateVariables(ATokens[2]);
  string Right = TranslateVariables(ATokens[4]);
  int LeftInt;
  int RightInt;

  if (int.TryParse(Left, out LeftInt) && int.TryParse(Right, out RightInt))
  {
      return (LeftInt == RightInt);
  }
  else
  {
      return (Left == Right);
  }*)
end;

procedure TRTReader.CommandIF_LESS(ATokens: TTokens);
begin
  (*TODO  string Left = TranslateVariables(ATokens[2]);
  string Right = TranslateVariables(ATokens[4]);
  int LeftInt;
  int RightInt;

  if (int.TryParse(Left, out LeftInt) && int.TryParse(Right, out RightInt))
  {
      return (LeftInt < RightInt);
  }
  else
  {
      throw new ArgumentException("@IF LESS arguments were not numeric");
  }*)
end;

procedure TRTReader.CommandIF_MORE(ATokens: TTokens);
begin
  (*TODO  string Left = TranslateVariables(ATokens[2]);
  string Right = TranslateVariables(ATokens[4]);
  int LeftInt;
  int RightInt;

  if (int.TryParse(Left, out LeftInt) && int.TryParse(Right, out RightInt))
  {
      return (LeftInt > RightInt);
  }
  else
  {
      throw new ArgumentException("@IF MORE arguments were not numeric");
  }*)
end;

procedure TRTReader.CommandIF_NOT(ATokens: TTokens);
begin
  (*TODO  string Left = TranslateVariables(ATokens[2]);
          string Right = TranslateVariables(ATokens[4]);
          int LeftInt;
          int RightInt;

          if (int.TryParse(Left, out LeftInt) && int.TryParse(Right, out RightInt))
          {
              return (LeftInt != RightInt);
          }
          else
          {
              return (Left != Right);
          }*)
end;

procedure TRTReader.CommandITEMEXIT(ATokens: TTokens);
begin
    (* @ITEMEXIT
        This tells the item editor to automatically return the player to the map
        screen after the item is used.  It is up to you to use the @drawmap and
        @update commands as usual though. *)
    // TODO Implement
end;

procedure TRTReader.CommandKEY(ATokens: TTokens);
begin
// Save text attribute
(*TODO int SavedAttr = Crt.TextAttr;

if (tokens.Length == 1)
{
    (* @KEY
        Does a [MORE] prompt, centered on current line.
        NOTE: Actually indents two lines, not centered *)
    mWrite(TranslateVariables("  `2<`0MORE`2>"));
    mReadKey();
    mWrite("\b\b\b\b\b\b\b\b        \b\b\b\b\b\b\b\b");
}
else if (ATokens[2].ToUpper() == "BOTTOM")
{
    (* @KEY BOTTOM
        This does <MORE> prompt at user text window. *)
    mGotoXY(35, 24);
    mWrite(TranslateVariables("`2<`0MORE`2>"));
    mReadKey();
    mWrite("\b\b\b\b\b\b      \b\b\b\b\b\b");
}
else if (ATokens[2].ToUpper() == "NODISPLAY")
{
    (* @KEY NODISPLAY
        Waits for keypress without saying anything. *)
    mReadKey();
}
else if (ATokens[2].ToUpper() == "TOP")
{
    (* @KEY TOP
        This does <MORE> prompt at game text window. *)
    mGotoXY(40, 15);
    mWrite(TranslateVariables("`2<`0MORE`2>"));
    mReadKey();
    mWrite("\b\b\b\b\b\b      \b\b\b\b\b\b");
}
else
{
    // TODO Implement
}

// Restore text attribute
Door.Write(Ansi.TextAttr(SavedAttr));*)
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
    // TODO Implement
end;

procedure TRTReader.CommandLOADGLOBALS(ATokens: TTokens);
begin
    (* @LOADGLOBALS
        This command loads the last value of all global variables as existed when the
        last @SAVEGLOBALS command was issued.  See @SAVEGLOBALS below. *)
    // TODO Unused
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
//TODO  Global.LoadMap(StrToInt(TranslateVariables(ATokens[2])));
end;

procedure TRTReader.CommandLOADWORLD(ATokens: TTokens);
begin
    (* @LOADWORLD
        This command loads globals and world data.  It has never been used but is
        included just in case it becomes necessary to do this.  See @SAVEWORLD below. *)
    // TODO Unused
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
    // TODO Implement
end;

procedure TRTReader.CommandMOREMAP(ATokens: TTokens);
begin
    (* @MOREMAP
        The line UNDER this will be the new <more> prompt.  30 characters maximum. *)
    // TODO Unused
end;

procedure TRTReader.CommandNAME(ATokens: TTokens);
begin
  (* @NAME <name to put under picture>
      Undocumented. Puts a name under the picture window *)
(*TODO  string Name = TranslateVariables(string.Join(" ", tokens, 1, tokens.Length - 1));
  mGotoXY(55 + StrToInt(Math.Truncate((22 - mStripSeth(Name).Length) / 2.0)), 15);
  mWrite(Name);*)
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
    // TODO Implement
end;

procedure TRTReader.CommandOVERHEADMAP(ATokens: TTokens);
begin
    (* @OVERHEADMAP
        This command displays the visible portion of the map as defined in the world
        editor of L2CFG.  All maps marked as no show and all unused maps will be
        blue signifying ocean.  No marks or legend will be written on the map.  This
        is your responsibility.  If you wish to mark the map you must do this in
        help.ref under the @#M routine.  Be sure to include a legend so people have
        some reference concerning what the marks mean. *)
    // TODO Implement
end;

procedure TRTReader.CommandPAUSEOFF(ATokens: TTokens);
begin
    (* @PAUSEOFF
        This turns the 24 line pause off so you can show long ansis etc and it won't
        pause every 24 lines. *)
    // TODO Implement
end;

procedure TRTReader.CommandPAUSEON(ATokens: TTokens);
begin
    (* @PAUSEON
        Just the opposite of the above command.  This turns the pause back on. *)
    // TODO Implement
end;

procedure TRTReader.CommandPROGNAME(ATokens: TTokens);
begin
    (* @PROGNAME
        The line UNDER this will be the status bar name of the game. *)
    // TODO Unused
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
    // TODO Unused
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
  FInREADFILE := Game.GetSafeAbsolutePath(TranslateVariables(ATokens[2]));
  FInREADFILELines.Clear();
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
(*TODO  RTReader RTR = new RTReader();
  if (tokens.Length < 4)
  {
      _InHALT = RTR.RunSection(_CurrentFile.Name, TranslateVariables(ATokens[2]));
  }
  else
  {
      _InHALT = RTR.RunSection(TranslateVariables(ATokens[4]), TranslateVariables(ATokens[2]));
  }*)
end;

procedure TRTReader.CommandRUN(ATokens: TTokens);
begin
(* @RUN <Header or label name> IN <Filename of .REF file>
    Same thing as ROUTINE, but doesn't come back to the original .REF. *)
  (*TODORTReader RTR = new RTReader();
_InHALT = RTR.RunSection(TranslateVariables(ATokens[4]), TranslateVariables(ATokens[2]));
_InCLOSESCRIPT = true; // Don't want to resume this ref*)
end;

procedure TRTReader.CommandSAVECURSOR(ATokens: TTokens);
begin
    (* @SAVECURSOR
        This command saves the current cursor positioning for later retrieval. *)
    // TODO Implement
end;

procedure TRTReader.CommandSAVEGLOBALS(ATokens: TTokens);
begin
    (* @SAVEGLOBALS
        This command saves the current global variables for later retrieval *)
    // TODO Implement
end;

procedure TRTReader.CommandSAVEWORLD(ATokens: TTokens);
begin
    (* @SAVEWORLD
        This command saves stats and world data.  The only use yet is right after
        @#maint is called to save random stats set for that day and such. *)
    // TODO Unused
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
    // TODO Implement
end;

procedure TRTReader.CommandSHOW(ATokens: TTokens);
begin
(*TODO if ((tokens.Length > 1) && (ATokens[2].ToUpper() == "SCROLL"))
{
    (* @SHOW SCROLL
        Same thing, but puts all the text in a nifty scroll window. (scroll window has
        commands line Next Screen, Previous Screen, Start, and End. *)
    _InSHOWSCROLLLines.Clear();
    _InSHOWSCROLL = true;
}
else
{
    (* @SHOW
        Shows following text/ansi.  Stops when a @ is hit on beginning of line. *)
    _InSHOW = true;
}     *)
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
  (*TODO   EventHandler Handler = RTGlobal.OnUPDATE;
  if (Handler != null) Handler(null, EventArgs.Empty);*)
end;

procedure TRTReader.CommandUPDATE_UPDATE(ATokens: TTokens);
begin
    (* @UPDATE_UPDATE
        This command writes current player data to UPDATE.TMP file.  This is useful
        when you just can't wait until the script is finished for some reason. *)
    // TODO Implement
end;

procedure TRTReader.CommandVERSION(ATokens: TTokens);
begin
  (* @VERSION  <Version it needs>
      For instance, you would put @VERSION 2 for this version of RTREADER.  (002) If
      it is run on Version 1, (could happen) a window will pop up warning the person
      he had better get the latest version. *)
(*TODO  int RequiredVersion = StrToInt(ATokens[2]);
  if (RequiredVersion > _Version) throw new ArgumentOutOfRangeException("VERSION", "@VERSION requested version " + RequiredVersion + ", we only support version " + _Version);*)
end;

procedure TRTReader.CommandWHOISON(ATokens: TTokens);
begin
    (* @WHOISON
        Undocumented.  Will need to find out what this does *)
    // TODO Implement
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

procedure TRTReader.EndCHOICE;
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
  (*TODO  int VisibleCount = 0;
  int LastVisibleLength = 0;

  char[] IfChars = { '=', '!', '>', '<', '+', '-' };
  for (int i = 0; i < _InCHOICEOptions.Count; i++)
  {
      bool MakeVisible = true;

      // Parse out the IF statements
      while (Array.IndexOf(IfChars, _InCHOICEOptions[i].Text[0]) != -1)
      {
          // Extract operator
          char Operator = _InCHOICEOptions[i].Text[0];
          _InCHOICEOptions[i].Text = _InCHOICEOptions[i].Text.Substring(1);

          // Extract variable and translate
          string Variable = _InCHOICEOptions[i].Text.Split(' ')[0];
          _InCHOICEOptions[i].Text = _InCHOICEOptions[i].Text.Substring(Variable.Length + 1);
          Variable = TranslateVariables(Variable);

          // Extract value
          string Value = _InCHOICEOptions[i].Text.Split(' ')[0];
          _InCHOICEOptions[i].Text = _InCHOICEOptions[i].Text.Substring(Value.Length + 1);

          // Determine result of if
          switch (Operator)
          {
              case '=':
                  MakeVisible = MakeVisible && (StrToInt(Variable) == StrToInt(Value));
                  break;
              case '!':
                  MakeVisible = MakeVisible && (StrToInt(Variable) != StrToInt(Value));
                  break;
              case '>':
                  MakeVisible = MakeVisible && (StrToInt(Variable) > StrToInt(Value));
                  break;
              case '<':
                  MakeVisible = MakeVisible && (StrToInt(Variable) < StrToInt(Value));
                  break;
              case '+':
                  MakeVisible = MakeVisible && ((StrToInt(Variable) & (1 << StrToInt(Value))) != 0);
                  break;
              case '-':
                  MakeVisible = MakeVisible && ((StrToInt(Variable) & (1 << StrToInt(Value))) == 0);
                  break;
          }
      }

      // Determine if option is visible
      if (MakeVisible)
      {
          VisibleCount += 1;
          LastVisibleLength = mStripSeth(_InCHOICEOptions[i].Text).Length;
          _InCHOICEOptions[i].Visible = true;
          _InCHOICEOptions[i].VisibleIndex = VisibleCount;
      }
      else
      {
          _InCHOICEOptions[i].Visible = false;
      }
  }

  // Ensure `V01 specified a valid/visible selection
  int SelectedIndex = StrToInt(TranslateVariables("`V01"));
  if ((SelectedIndex < 1) || (SelectedIndex > _InCHOICEOptions.Count)) SelectedIndex = 1;
  while (!_InCHOICEOptions[SelectedIndex - 1].Visible) SelectedIndex += 1;

  // Determine how many spaces to indent by (all lines should be indented same as first line)
  string Spaces = "\r\n" + new string(' ', Crt.WhereX() - 1);

  // Output options
  mCursorSave();
  mTextAttr(15);
  for (int i = 0; i < _InCHOICEOptions.Count; i++)
  {
      if (_InCHOICEOptions[i].Visible)
      {
          if (_InCHOICEOptions[i].VisibleIndex > 1) mWrite(Spaces);
          if (i == (SelectedIndex - 1)) mTextBackground(Crt.Blue);
          mWrite(TranslateVariables(_InCHOICEOptions[i].Text));
          if (i == (SelectedIndex - 1)) mTextBackground(Crt.Black);
      }
  }

  // Get response
  char? Ch = null;
  while (Ch != '\r')
  {
      int OldSelectedIndex = SelectedIndex;

      Ch = mReadKey();
      switch (Ch)
      {
          case '8':
          case '4':
              while (true)
              {
                  // Go to previous item
                  SelectedIndex -= 1;

                  // Wrap to bottom if we were at the top item
                  if (SelectedIndex < 1) SelectedIndex = _InCHOICEOptions.Count;

                  // Check if new selected item is visible (and break if so)
                  if (_InCHOICEOptions[SelectedIndex - 1].Visible) break;
              }
              break;
          case '6':
          case '2':
              while (true)
              {
                  // Go to previous item
                  SelectedIndex += 1;

                  // Wrap to bottom if we were at the top item
                  if (SelectedIndex > _InCHOICEOptions.Count) SelectedIndex = 1;

                  // Check if new selected item is visible (and break if so)
                  if (_InCHOICEOptions[SelectedIndex - 1].Visible) break;
              }
              break;
      }

      if (OldSelectedIndex != SelectedIndex)
      {
          // Store new selection
          AssignVariable("`V01", SelectedIndex.ToString());

          // Redraw old selection without blue highlight
          mCursorRestore();
          if (_InCHOICEOptions[OldSelectedIndex - 1].VisibleIndex > 1) mCursorDown(_InCHOICEOptions[OldSelectedIndex - 1].VisibleIndex - 1);
          mWrite(TranslateVariables(_InCHOICEOptions[OldSelectedIndex - 1].Text));

          // Draw new selection with blue highlight
          mCursorRestore();
          if (_InCHOICEOptions[SelectedIndex - 1].VisibleIndex > 1) mCursorDown(_InCHOICEOptions[SelectedIndex - 1].VisibleIndex - 1);
          mTextBackground(Crt.Blue);
          mWrite(TranslateVariables(_InCHOICEOptions[SelectedIndex - 1].Text));
          mTextBackground(Crt.Black);
      }
  }

  // Move cursor below choice statement
  mCursorRestore();
  mCursorDown(VisibleCount - 1);
  mCursorRight(LastVisibleLength);

  // Update global variable responses
  RTGlobal.RESPONSE = SelectedIndex.ToString();*)
end;

procedure TRTReader.EndREADFILE;
begin
  // TODO _InWRITEFILE could be handled like this, so no need for multiple writes per writefile
  if (FileExists(FInREADFILE)) then
  begin
      (*TODO      string[] Lines = FileUtils.FileReadAllLines(_InREADFILE, RMEncoding.Ansi);

      int LoopMax = Math.Min(Lines.Length, _InREADFILELines.Count);
      for (int i = 0; i < LoopMax; i++)
      {
          AssignVariable(_InREADFILELines[i], TranslateVariables(Lines[i]));
      }*)
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
  mCursorSave();

  // Output new bar
  mGotoXY(3, 21);
  mTextAttr(31);
  StrippedLength := Length(AText); // TODO Length(mStripSeth(TranslateVariables(AText)));
  SpacesLeft := Max(0, (76 - StrippedLength) div 2);
  SpacesRight := Max(0, 76 - StrippedLength - SpacesLeft);
  mWrite(mStrings.PadLeft('', ' ', SpacesLeft) + TranslateVariables(AText) + mStrings.PadRight('', ' ', SpacesRight));
  // TODO say bar should be removed after 3 seconds or so

  // Restore
  mCursorRestore();
  mTextAttr(SavedTextAttr);
end;

procedure TRTReader.EndSHOWSCROLL;
begin
  (*TODO  char? Ch = null;
  int Page = 1;
  int MaxPage = StrToInt(Math.Truncate(_InSHOWSCROLLLines.Count / 22.0));
  if (_InSHOWSCROLLLines.Count % 22 != 0) MaxPage += 1;
  int SavedAttr = 7;

  while (Ch != 'Q')
  {
      mTextAttr(SavedAttr);
      mClrScr();

      int LineStart = (Page - 1) * 22;
      int LineEnd = LineStart + 21;
      for (int i = LineStart; i <= LineEnd; i++)
      {
          if (i >= _InSHOWSCROLLLines.Count) break;
          mWriteLn(_InSHOWSCROLLLines[i]);
      }
      SavedAttr = Crt.TextAttr;

      mGotoXY(1, 23);
      mTextAttr(31);
      mWrite(new string(' ', 79));
      mGotoXY(3, 23);
      mWrite("(" + Page + ")");
      mGotoXY(9, 23);
      mWrite("[N]ext Page, [P]revious Page, [Q]uit, [S]tart, [E]nd");

      Ch = mReadKey();
      if (Ch != null)
      {
          Ch = char.ToUpper((char)Ch);
          switch (Ch)
          {
              case 'E': Page = MaxPage; break;
              case 'N': Page = Math.Min(MaxPage, Page + 1); break;
              case 'P': Page = Math.Max(1, Page - 1); break;
              case 'S': Page = 1; break;
          }
      }
  }    *)
end;

procedure TRTReader.Execute(AFileName: String; ASectionName: String; ALabelName: String);
begin
  if (RTGlobal.RefFiles.FindIndexOf(AFileName) = -1) then
  begin
    mWriteLn('`4`b**`b `%ERROR : `2File `0' + AFileName + ' `2not found. `4`b**`b`2');
    mReadKey;
  end else
  begin
    FCurrentFile := TRTRefFile(RTGlobal.RefFiles.Find(AFileName));

    if (FCurrentFile.Sections.FindIndexOf(ASectionName) = -1) then
    begin
      mWriteLn('`4`b**`b `%ERROR : Section `0' + ASectionName + ' `2not found in `0' + AFileName + ' `4`b**`b`2');
      mReadKey;
    end else
    begin
      FCurrentSection := TRTRefSection(FCurrentFile.Sections.Find(ASectionName));

      if (ALabelName <> '') then
      begin
        if (FCurrentSection.Labels.FindIndexOf(ALabelName) = -1) then
        begin
          mWriteLn('`4`b**`b `%ERROR : Label `0' + ASectionName + ' `2not found in `0' + AFileName + ' `4`b**`b`2');
          mReadKey;
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

procedure TRTReader.LogMissing(ATokens: TTokens);
begin
  FastWrite(mStrings.PadRight('TODO Missing: ' + ATokens[1], ' ', 80), 1, 25, 31);
  ReadLn;
  FastWrite(mStrings.PadRight('', ' ', 80), 1, 25, 7);
end;

procedure TRTReader.LogUnimplemented(ATokens: TTokens);
begin
  FastWrite(mStrings.PadRight('TODO Unimplemented: ' + ATokens[1], ' ', 80), 1, 25, 31);
  ReadLn;
  FastWrite(mStrings.PadRight('', ' ', 80), 1, 25, 7);
end;

procedure TRTReader.LogUnused(ATokens: TTokens);
begin
  FastWrite(mStrings.PadRight('TODO Unused: ' + ATokens[1], ' ', 80), 1, 25, 31);
  ReadLn;
  FastWrite(mStrings.PadRight('', ' ', 80), 1, 25, 7);
end;

procedure TRTReader.ParseCommand(ATokens: TTokens);
begin
  case UpperCase(ATokens[1]) of
    '@': CommandNOP(ATokens);
    '@ADDCHAR': CommandADDCHAR(ATokens);
    '@BEGIN': CommandBEGIN(ATokens);
    '@BITSET': CommandBITSET(ATokens);
    '@BUSY': LogUnimplemented(ATokens);
    '@BUYMANAGER': LogUnimplemented(ATokens);
    '@CHECKMAIL': LogUnimplemented(ATokens);
    '@CHOICE': CommandCHOICE(ATokens);
    '@CHOOSEPLAYER': LogUnimplemented(ATokens);
    '@CLEAR': CommandCLEAR(ATokens);
    '@CLEARBLOCK': CommandCLEARBLOCK(ATokens);
    '@CLOSESCRIPT': CommandCLOSESCRIPT(ATokens);
    '@CONVERT_FILE_TO_ANSI': LogUnimplemented(ATokens);
    '@CONVERT_FILE_TO_ASCII': LogUnimplemented(ATokens);
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
        'BEEP': LogUnused(ATokens);
        'COPYTONAME': CommandDO_COPYTONAME(ATokens);
        'DELETE': CommandDO_DELETE(ATokens);
        'FRONTPAD': CommandDO_FRONTPAD(ATokens);
        'GETKEY': CommandDO_GETKEY(ATokens);
        'GOTO': CommandDO_GOTO(ATokens);
        'MOVE': CommandDO_MOVE(ATokens);
        'MOVEBACK': CommandDO_MOVEBACK(ATokens);
        'NUMRETURN': CommandDO_NUMRETURN(ATokens);
        'PAD': CommandDO_PAD(ATokens);
        'QUEBAR': LogUnimplemented(ATokens);
        'READCHAR': CommandDO_READCHAR(ATokens);
        'READNUM': CommandDO_READNUM(ATokens);
        'READSPECIAL': CommandDO_READSPECIAL(ATokens);
        'READSTRING': CommandDO_READSTRING(ATokens);
        'REPLACE': CommandDO_REPLACE(ATokens);
        'REPLACEALL': CommandDO_REPLACEALL(ATokens);
        'RENAME': CommandDO_RENAME(ATokens);
        'SAYBAR': CommandDO_SAYBAR(ATokens);
        'STATBAR': LogUnimplemented(ATokens);
        'STRIP': CommandDO_STRIP(ATokens);
        'STRIPALL': LogUnused(ATokens);
        'STRIPBAD': LogUnimplemented(ATokens);
        'STRIPCODE': LogUnused(ATokens);
        'TALK': LogUnimplemented(ATokens);
        'TRIM': CommandDO_TRIM(ATokens);
        'UPCASE': CommandDO_UPCASE(ATokens);
        'WRITE': CommandDO_WRITE(ATokens);
        else
        begin
          // Check for @DO <SOMETHING> <COMMAND> commands
          if (Length(ATokens) >= 4) then // ATokens[0] is ignored, but must be included in count
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
              else LogMissing(ATokens);
            end;
          end else
          begin
            LogMissing(ATokens);
          end;
        end;
      end;
    end;
    '@DRAWMAP': CommandDRAWMAP(ATokens);
    '@DRAWPART': LogUnimplemented(ATokens);
    '@END': CommandEND(ATokens);
    '@FIGHT': LogUnimplemented(ATokens);
    '@GRAPHICS': LogUnused(ATokens);
    '@HALT': CommandHALT(ATokens);
    '@IF':
    begin
      // Check for @IF <COMMAND> commands
      case UpperCase(ATokens[2]) of
        'BITCHECK': CommandIF_BITCHECK(ATokens);
        'BLOCKPASSABLE': CommandIF_BLOCKPASSABLE(ATokens);
        'CHECKDUPE': CommandIF_CHECKDUPE(ATokens);
        else
        begin
          // Check for @IF <SOMETHING> <COMMAND> commands
          case UpperCase(ATokens[3]) of
            'EQUALS': CommandIF_IS(ATokens);
            'EXIST': CommandIF_EXIST(ATokens);
            'EXISTS': CommandIF_EXIST(ATokens);
            'INSIDE': CommandIF_INSIDE(ATokens);
            'IS': CommandIF_IS(ATokens);
            'LESS': CommandIF_LESS(ATokens);
            'MORE': CommandIF_MORE(ATokens);
            'NOT': CommandIF_NOT(ATokens);
            '=': CommandIF_IS(ATokens);
            '<': CommandIF_LESS(ATokens);
            '>': CommandIF_MORE(ATokens);
          end;
        end;
      end;

                  // Check if it's an IF block, or inline IF
                  (*TODO            if (string.Join(" ", tokens).ToUpper().Contains("THEN DO"))
            {
                // @BEGIN..@END coming, so skip it if our result was false
                if (!Result) _InIFFalse = _InBEGINCount;
            }
            else
            {
                // Inline DO, so execute it
                if (Result)
                {
                    int DOOffset = (ATokens[6].ToUpper() == "THEN") ? 6 : 5;
                    string[] DOtokens = ("@DO " + string.Join(" ", tokens, DOOffset, tokens.Length - DOOffset)).Split(' ');
                    CommandDO(DOtokens);
                }
            }      *)
    end;
    '@ITEMEXIT': LogUnimplemented(ATokens);
    '@KEY': CommandKEY(ATokens);
    '@LABEL': CommandLABEL(ATokens);
    '@LOADCURSOR': LogUnimplemented(ATokens);
    '@LOADGLOBALS': LogUnused(ATokens);
    '@LOADMAP': CommandLOADMAP(ATokens);
    '@LOADWORLD': LogUnused(ATokens);
    '@LORDRANK': LogUnimplemented(ATokens);
    '@MOREMAP': LogUnused(ATokens);
    '@NAME': CommandNAME(ATokens);
    '@NOCHECK': CommandNOCHECK(ATokens);
    '@OFFMAP': LogUnimplemented(ATokens);
    '@OVERHEADMAP': LogUnimplemented(ATokens);
    '@PAUSEOFF': LogUnimplemented(ATokens);
    '@PAUSEON': LogUnimplemented(ATokens);
    '@PROGNAME': LogUnused(ATokens);
    '@RANK': LogUnused(ATokens);
    '@READFILE': CommandREADFILE(ATokens);
    '@ROUTINE': CommandROUTINE(ATokens);
    '@RUN': CommandRUN(ATokens);
    '@SAVECURSOR': LogUnimplemented(ATokens);
    '@SAVEGLOBALS': LogUnimplemented(ATokens);
    '@SAVEWORLD': LogUnused(ATokens);
    '@SAY': CommandSAY(ATokens);
    '@SELLMANAGER': LogUnimplemented(ATokens);
    '@SHOW': CommandSHOW(ATokens);
    '@SHOWLOCAL': CommandSHOWLOCAL(ATokens);
    '@UPDATE': CommandUPDATE(ATokens);
    '@UPDATE_UPDATE': LogUnimplemented(ATokens);
    '@VERSION': CommandVERSION(ATokens);
    '@WHOISON': LogUnimplemented(ATokens);
    '@WRITEFILE': CommandWRITEFILE(ATokens);
    else LogMissing(ATokens);
  end;
end;

procedure TRTReader.ParseScript(ALines: TStringList);
var
  Line: String;
  LineTrimmed: String;
  ScriptLength: Integer;
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
    if (FInHALT <> -1) then
    begin
      Exit;
    end else
    if (FInIFFalse < 999) then
    begin
      if (Pos('@', LineTrimmed) = 1) then
      begin
        Tokens := Tokenize(LineTrimmed, ' ');
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
        if (FInCHOICE) then EndCHOICE;
        if (FInREADFILE <> '') then EndREADFILE;
        if (FInSHOWSCROLL) then EndSHOWSCROLL;
        FInCHOICE := false;
        FInREADFILE := '';
        FInSAY := false;
        FInSAYBAR := false;
        FInSHOW := false;
        FInSHOWLOCAL := false;
        FInSHOWSCROLL := false;
        FInWRITEFILE := '';

        Tokens := Tokenize(LineTrimmed, ' ');
        ParseCommand(Tokens);
      end else
      begin
        if (FInCHOICE) then
        begin
          FInCHOICEOptions.Add(TRTChoiceOption.Create(Line));
        end else
        if (FInDO_ADDLOG) then
        begin
          { TODO
          FileUtils.FileAppendAllText(Game.GetSafeAbsolutePath("LOGNOW.TXT"), TranslateVariables(Line));
            }
          FInDO_ADDLOG := false;
        end else
        if (FInDO_WRITE) then
        begin
          mWrite(TranslateVariables(Line));
          FInDO_WRITE := false;
        end else
        if (FInREADFILE <> '') then
        begin
          FInREADFILELines.Add(Line);
        end else
        if (FInSAY) then
        begin
          // TODO SHould be in TEXT window (but since LORD2 doesn't use @SAY, not a high priority)
          mWrite(TranslateVariables(Line));
        end else
        if (FInSAYBAR) then
        begin
          EndSAYBAR(Line);
          FInSAYBAR := false;
        end else
        if (FInSHOW) then
        begin
          mWriteLn(TranslateVariables(Line));
        end else
        if (FInSHOWLOCAL) then
        begin
          mAnsi.aWrite(TranslateVariables(Line) + #13#10);
        end else
        if (FInSHOWSCROLL) then
        begin
          FInSHOWSCROLLLines.Add(TranslateVariables(Line));
        end else
        if (FInWRITEFILE <> '') then
        begin
          // TODOFileUtils.FileAppendAllText(_InWRITEFILE, TranslateVariables(Line) + Environment.NewLine, RMEncoding.Ansi);
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
    'LOCAL':
    begin
      if (mLocal()) then
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
      // Handle player and global variables
      if (Pos('`', TextUpper) > 0) then
      begin
        if (Pos('`I', TextUpper) > 0) then
        begin
          for I := Low(Game.Player.I) to High(Game.Player.I) do
          begin
            AText := StringReplace(AText, '`I' + mStrings.PadLeft(IntToStr(I), '0', 2), IntToStr(Game.Player.I[I]), [rfReplaceAll, rfIgnoreCase]);
          end;
        end;
        if (Pos('`P', TextUpper) > 0) then
        begin
          for I := Low(Game.Player.p) to High(Game.Player.p) do
          begin
            AText := StringReplace(AText, '`P' + mStrings.PadLeft(IntToStr(I), '0', 2), IntToStr(Game.Player.p[I]), [rfReplaceAll, rfIgnoreCase]);
          end;
        end;
        if (Pos('`+', TextUpper) > 0) then
        begin
          for I := Low(Game.ItemsDat.Item) to High(Game.ItemsDat.Item) do
          begin
            AText := StringReplace(AText, '`+' + mStrings.PadLeft(IntToStr(I), '0', 2), Game.ItemsDat.Item[I].name, [rfReplaceAll, rfIgnoreCase]);
          end;
        end;
        if (Pos('`S', TextUpper) > 0) then
        begin
          for I := Low(Game.WorldDat.s) to High(Game.WorldDat.s) do
          begin
            AText := StringReplace(AText, '`S' + mStrings.PadLeft(IntToStr(I), '0', 2), Game.WorldDat.s[I], [rfReplaceAll, rfIgnoreCase]);
          end;
        end;
        if (Pos('`T', TextUpper) > 0) then
        begin
          for I := Low(Game.Player.T) to High(Game.Player.T) do
          begin
            AText := StringReplace(AText, '`T' + mStrings.PadLeft(IntToStr(I), '0', 2), IntToStr(Game.Player.T[I]), [rfReplaceAll, rfIgnoreCase]);
          end;
        end;
        if (Pos('`V', TextUpper) > 0) then
        begin
          for I := Low(Game.WorldDat.v) to High(Game.WorldDat.v) do
          begin
            AText := StringReplace(AText, '`V' + mStrings.PadLeft(IntToStr(I), '0', 2), IntToStr(Game.WorldDat.v[I]), [rfReplaceAll, rfIgnoreCase]);
          end;
        end;

        // Handle "Seth" codes
        AText := StringReplace(AText, '`N', Game.Player.name, [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '`E', Game.ENEMY, [rfReplaceAll, rfIgnoreCase]);
        if (DropInfo.Emulation = etANSI) then
        begin
          AText := StringReplace(AText, '`G', '3', [rfReplaceAll, rfIgnoreCase]);
        end else
        begin
          AText := StringReplace(AText, '`G', '0', [rfReplaceAll, rfIgnoreCase]);
        end;
        AText := StringReplace(AText, '`X', ' ', [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '`D', #8, [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '`\', #13#10, [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '`c', mAnsi.aClrScr + #13#10#13#10, [rfReplaceAll, rfIgnoreCase]);
      end;

      if (Pos('&', TextUpper) > 0) then
      begin
        // Handle "ampersand" codes
        AText := StringReplace(AText, '&realname', DropInfo.Alias, [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '&date', 'TODO &date', [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '&nicedate', 'TODO &nicedate', [rfReplaceAll, rfIgnoreCase]);
        if (Game.Player.ArmourNumber = 0) then
        begin
          AText := StringReplace(AText, 's&armour', '', [rfReplaceAll, rfIgnoreCase]);
        end else
        begin
          AText := StringReplace(AText, 's&armour', Game.ItemsDat.Item[Game.Player.ArmourNumber].name, [rfReplaceAll, rfIgnoreCase]);
        end;
        AText := StringReplace(AText, 's&arm_num', IntToStr(Game.Player.ArmourNumber), [rfReplaceAll, rfIgnoreCase]);
        if (Game.Player.WeaponNumber = 0) then
        begin
          AText := StringReplace(AText, 's&weapon', '', [rfReplaceAll, rfIgnoreCase]);
        end else
        begin
          AText := StringReplace(AText, 's&weapon', Game.ItemsDat.Item[Game.Player.WeaponNumber].name, [rfReplaceAll, rfIgnoreCase]);
        end;
        AText := StringReplace(AText, 's&wep_num', IntToStr(Game.Player.WeaponNumber), [rfReplaceAll, rfIgnoreCase]);
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
        AText := StringReplace(AText, '&time', IntToStr(Game.Time), [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '&timeleft', IntToStr(mTimeLeft div 60), [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '&sex', IntToStr(Game.Player.SexMale), [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '&playernum', IntToStr(Game.PlayerNum), [rfReplaceAll, rfIgnoreCase]);
        AText := StringReplace(AText, '&totalaccounts', IntToStr(Game.TotalAccounts), [rfReplaceAll, rfIgnoreCase]);
      end;
    end;
  end;

  Result := AText;
end;

end.

