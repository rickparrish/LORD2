unit RTGlobal;

{$mode objfpc}

interface

uses
  RTRefLabel, RTRefFile, RTRefSection,
  Classes, contnrs, SysUtils;

var
  RefFiles: TFPHashObjectList;

implementation

uses
  Game;

procedure LoadRefFile(AFileName: String); forward;

procedure LoadRefFile(AFileName: String);
var
  I: Integer;
  LineTrimmed: String;
  NewFile: TRTRefFile;
  NewSection: TRTRefSection;
  NewSectionName: String;
  SL: TStringList;
begin
  // A place to store all the sections found in this file
  NewFile := TRTRefFile.Create(ChangeFileExt(ExtractFileName(AFileName), ''));

  // Where to store the info for the section we're currently working on
  NewSectionName := '_HEADER';
  NewSection := TRTRefSection.Create(NewSectionName);

  // Loop through the file
  SL := TStringList.Create;
  SL.LoadFromFile(AFileName);
  for I := 0 to SL.Count - 1 do
  begin
    LineTrimmed := UpperCase(Trim(Sl[I]));

    // Check for new section
    if (Pos('@#', LineTrimmed) = 1) then
    begin
      // Store last section we were working on in dictionary
      if (NewFile.Sections.FindIndexOf(NewSectionName) <> -1) then
      begin
        // Section already exists, so we can't add it
        // CASTLE4 has multiple DONE sections
        // STONEB has multiple NOTHING sections
        // Both appear harmless, but keep that in mind if either ever seems buggy
      end else
      begin
        NewFile.Sections.Add(NewSectionName, NewSection);
      end;

      // Get new section name (presumes only one word headers allowed, trims @# off start) and reset script block
      NewSectionName := Copy(LineTrimmed, 3, Length(LineTrimmed) - 2);
      if (Pos(' ', NewSectionName) > 0) then
      begin
        NewSectionName := Copy(NewSectionName, 1, Pos(' ', NewSectionName) - 1);
      end;
      NewSection := TRTRefSection.Create(NewSectionName);
    end else
    if (Pos('@LABEL ', LineTrimmed) = 1) then
    begin
      NewSection.Script.Add(SL[I]);

      LineTrimmed := Copy(LineTrimmed, 8, Length(LineTrimmed) - 7);
      if (Pos(' ', LineTrimmed) > 0) then
      begin
        LineTrimmed := Copy(LineTrimmed, 1, Pos(' ', LineTrimmed) - 1);
      end;
      NewSection.Labels.Add(LineTrimmed, TRTRefLabel.Create(LineTrimmed, NewSection.Script.Count - 1));
    end else
    begin
        NewSection.Script.Add(SL[I]);
    end;
  end;
  SL.Free;

  // Store last section we were working on in dictionary
  if (NewFile.Sections.FindIndexOf(NewSectionName) <> -1) then
  begin
    // Section already exists, so we can't add it
    // CASTLE4 has multiple DONE sections
    // STONEB has multiple NOTHING sections
    // Both appear harmless, but keep that in mind if either ever seems buggy
  end else
  begin
    NewFile.Sections.Add(NewSectionName, NewSection);
  end;

  RefFiles.Add(NewFile.Name, NewFile);
end;

var
  SR: TSearchRec;
begin
  RefFiles := TFPHashObjectList.Create();

  if (FindFirst(Game.GetSafeAbsolutePath('*.REF'), faAnyFile, SR) = 0) then
  begin
    repeat
      LoadRefFile(Game.GetSafeAbsolutePath(SR.Name));
    until (FindNext(SR) <> 0);
  end;
end.

