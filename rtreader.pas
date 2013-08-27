unit RTReader;

interface

uses
  MannDoor, mCrt, mStrings, SysUtils, Classes, contnrs, RTRefFile, RTRefSection,
  RTRefLabel, RTGlobal, RTChoiceOption, Crt, Math, mAnsi, StrUtils;

type
  TRTReader = class
  private
    FCurrentLabel: TRTRefLabel;
    FCurrentLineNumber: Integer;
    FCurrentFile: TRTRefFile;
    FCurrentSection: TRTRefSection;

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

    procedure CommandADDCHAR(ATokens: TTokens);
    procedure CommandBEGIN(ATokens: TTokens);
    procedure CommandBITSET(ATokens: TTokens);
    procedure CommandCHOICE(ATokens: TTokens);
    procedure CommandCLEARBLOCK(ATokens: TTokens);
    procedure CommandCLEAR(ATokens: TTokens);
    procedure CommandCLOSESCRIPT(ATokens: TTokens);
    procedure CommandCOPYFILE(ATokens: TTokens);
    procedure CommandDATALOAD(ATokens: TTokens);
    procedure CommandDATANEWDAY(ATokens: TTokens);
    procedure CommandDATASAVE(ATokens: TTokens);
    procedure CommandDECLARE(ATokens: TTokens);
    procedure CommandDISPLAY(ATokens: TTokens);
    procedure CommandDISPLAYFILE(ATokens: TTokens);

    procedure CommandDO_ADD(ATokens: TTokens);
    procedure CommandDO_ADDLOG(ATokens: TTokens);
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
    procedure CommandDO_RANDOM(ATokens: TTokens);
    procedure CommandDO_READCHAR(ATokens: TTokens);
    procedure CommandDO_READNUM(ATokens: TTokens);
    procedure CommandDO_READSPECIAL(ATokens: TTokens);
    procedure CommandDO_READSTRING(ATokens: TTokens);
    procedure CommandDO_REPLACE(ATokens: TTokens);
    procedure CommandDO_REPLACEALL(ATokens: TTokens);
    procedure CommandDO_RENAME(ATokens: TTokens);
    procedure CommandDO_SAYBAR(ATokens: TTokens);
    procedure CommandDO_STRIP(ATokens: TTokens);
    procedure CommandDO_SUBTRACT(ATokens: TTokens);
    procedure CommandDO_TRIM(ATokens: TTokens);
    procedure CommandDO_UPCASE(ATokens: TTokens);
    procedure CommandDO_WRITE(ATokens: TTokens);

    procedure CommandDRAWMAP(ATokens: TTokens);
    procedure CommandEND(ATokens: TTokens);
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

    procedure CommandKEY(ATokens: TTokens);
    procedure CommandLABEL(ATokens: TTokens);
    procedure CommandLOADMAP(ATokens: TTokens);
    procedure CommandNAME(ATokens: TTokens);
    procedure CommandNOCHECK(ATokens: TTokens);
    procedure CommandNOP(ATokens: TTokens);
    procedure CommandREADFILE(ATokens: TTokens);
    procedure CommandROUTINE(ATokens: TTokens);
    procedure CommandRUN(ATokens: TTokens);
    procedure CommandSAY(ATokens: TTokens);
    procedure CommandSHOW(ATokens: TTokens);
    procedure CommandSHOWLOCAL(ATokens: TTokens);
    procedure CommandUPDATE(ATokens: TTokens);
    procedure CommandVERSION(ATokens: TTokens);
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
    destructor Destroy;
  end;

procedure Execute(AFileName: string; ASectionName: string);

implementation

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
begin
  // TODO
end;

procedure TRTReader.CommandBEGIN(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandBITSET(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandCHOICE(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandCLEARBLOCK(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandCLEAR(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandCLOSESCRIPT(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandCOPYFILE(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDATALOAD(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDATANEWDAY(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDATASAVE(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDECLARE(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDISPLAY(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDISPLAYFILE(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_ADD(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_ADDLOG(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_COPYTONAME(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_DELETE(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_DIVIDE(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_FRONTPAD(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_GETKEY(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_GOTO(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_IS(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_MOVE(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_MOVEBACK(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_MULTIPLY(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_NUMRETURN(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_PAD(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_RANDOM(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_READCHAR(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_READNUM(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_READSPECIAL(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_READSTRING(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_REPLACE(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_REPLACEALL(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_RENAME(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_SAYBAR(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_STRIP(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_SUBTRACT(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_TRIM(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_UPCASE(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDO_WRITE(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandDRAWMAP(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandEND(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandHALT(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandIF_BITCHECK(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandIF_BLOCKPASSABLE(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandIF_CHECKDUPE(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandIF_EXIST(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandIF_INSIDE(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandIF_IS(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandIF_LESS(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandIF_MORE(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandIF_NOT(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandKEY(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandLABEL(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandLOADMAP(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandNAME(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandNOCHECK(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandNOP(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandREADFILE(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandROUTINE(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandRUN(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandSAY(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandSHOW(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandSHOWLOCAL(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandUPDATE(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandVERSION(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.CommandWRITEFILE(ATokens: TTokens);
begin
  // TODO
end;

procedure TRTReader.EndCHOICE;
begin
  // TODO
end;

procedure TRTReader.EndREADFILE;
begin
  // TODO
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
  // TODO
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
    '@CLEARBLOCK': CommandCLEARBLOCK(ATokens);
    '@CLEAR': CommandCLEAR(ATokens);
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
        {TODO
        string[] Tokens = LineTrimmed.Split(' ');
        case (Tokens[0].ToUpper()) of
            '@BEGIN':
                _InBEGINCount += 1;
            '@END':
                _InBEGINCount -= 1;
                if (_InBEGINCount == _InIFFalse) _InIFFalse = 999;
        end;
        }
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
          FileUtils.FileAppendAllText(Global.GetSafeAbsolutePath("LOGNOW.TXT"), TranslateVariables(Line));
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
begin
  Result := AText; // TODO
end;

end.

