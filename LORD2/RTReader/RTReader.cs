using RandM.RMLib;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;

namespace LORD2
{
    public partial class RTReader
    {
        private int _CurrentLineNumber = 0;
        private RTRefFile _CurrentFile = null;
        private RTRefSection _CurrentSection = null;
        private int _InBEGINCount = 0;
        private bool _InBUYMANAGER = false;
        private List<string> _InBUYMANAGEROptions = new List<string>();
        private bool _InCHOICE = false;
        private List<RTChoiceOption> _InCHOICEOptions = new List<RTChoiceOption>();
        private bool _InCLOSESCRIPT = false;
        private bool _InDO_ADDLOG = false;
        private bool _InDO_WRITE = false;
        private bool _InFIGHT = false;
        private int _InIFFalse = 999; // Maybe needs to be renamed -- lets us know when we're skipping over code because it's part of an @IF that evaluated to false
        private string _InREADFILE = "";
        private List<string> _InREADFILELines = new List<string>();
        private bool _InSAY = false;
        private bool _InSAYBAR = false;
        private bool _InSELLMANAGER = false;
        private List<string> _InSELLMANAGEROptions = new List<string>();
        private bool _InSHOW = false;
        private bool _InSHOWLOCAL = false;
        private bool _InSHOWSCROLL = false;
        private List<string> _InSHOWSCROLLLines = new List<string>();
        private string _InWRITEFILE = "";
        private Random _R = new Random();
        private int _Version = 99;

        public RTReader()
        {
            InitCommands();
        }

        private void EndBUYMANAGER()
        {
            LogUnimplemented(new string[] { "TODOX" });
        }

        // TODOX Abstract some of this out to RTChoiceOption so you can easily retrieve a list of visible options
        private void EndCHOICE()
        {
            /* @CHOICE
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
                "Hey, I have more than 500", RESPONSE would be set to 5. */


            // Determine which options are Visible and assign VisibleIndex
            int VisibleCount = 0;
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
                    Variable = RTVariables.TranslateVariables(Variable);

                    // Extract value
                    string Value = _InCHOICEOptions[i].Text.Split(' ')[0];
                    _InCHOICEOptions[i].Text = _InCHOICEOptions[i].Text.Substring(Value.Length + 1);

                    // Determine result of if
                    switch (Operator)
                    {
                        case '=':
                            MakeVisible = MakeVisible && (Convert.ToInt32(Variable) == Convert.ToInt32(Value));
                            break;
                        case '!':
                            MakeVisible = MakeVisible && (Convert.ToInt32(Variable) != Convert.ToInt32(Value));
                            break;
                        case '>':
                            MakeVisible = MakeVisible && (Convert.ToInt32(Variable) > Convert.ToInt32(Value));
                            break;
                        case '<':
                            MakeVisible = MakeVisible && (Convert.ToInt32(Variable) < Convert.ToInt32(Value));
                            break;
                        case '+':
                            MakeVisible = MakeVisible && ((Convert.ToInt32(Variable) & (1 << Convert.ToInt32(Value))) != 0);
                            break;
                        case '-':
                            MakeVisible = MakeVisible && ((Convert.ToInt32(Variable) & (1 << Convert.ToInt32(Value))) == 0);
                            break;
                    }
                }

                // Determine if option is visible
                if (MakeVisible)
                {
                    VisibleCount += 1;
                    LastVisibleLength = Door.StripSeth(_InCHOICEOptions[i].Text).Length;
                    _InCHOICEOptions[i].Visible = true;
                    _InCHOICEOptions[i].VisibleIndex = VisibleCount;
                }
                else
                {
                    _InCHOICEOptions[i].Visible = false;
                }
            }

            // Ensure `V01 specified a valid/visible selection
            int SelectedIndex = Convert.ToInt32(RTVariables.TranslateVariables("`V01"));
            if ((SelectedIndex < 1) || (SelectedIndex > _InCHOICEOptions.Count)) SelectedIndex = 1;
            while (!_InCHOICEOptions[SelectedIndex - 1].Visible) SelectedIndex += 1;

            // Determine how many spaces to indent by (all lines should be indented same as first line)
            string Spaces = "\r\n" + new string(' ', Crt.WhereX() - 1);

            // Output options
            Door.CursorSave();
            Door.TextAttr(15);
            for (int i = 0; i < _InCHOICEOptions.Count; i++)
            {
                if (_InCHOICEOptions[i].Visible)
                {
                    if (_InCHOICEOptions[i].VisibleIndex > 1) Door.Write(Spaces);
                    if (i == (SelectedIndex - 1)) Door.TextBackground(Crt.Blue);
                    Door.Write(RTVariables.TranslateVariables(_InCHOICEOptions[i].Text));
                    if (i == (SelectedIndex - 1)) Door.TextBackground(Crt.Black);
                }
            }

            // Get response
            char? Ch = null;
            while (Ch != '\r')
            {
                int OldSelectedIndex = SelectedIndex;

                Ch = Door.ReadKey();
                switch (Ch)
                {
                    case Door.ExtendedKeys.LeftArrow:
                    case Door.ExtendedKeys.UpArrow:
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

                    case Door.ExtendedKeys.RightArrow:
                    case Door.ExtendedKeys.DownArrow:
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
                    RTVariables.SetVariable("`V01", SelectedIndex.ToString());

                    // Redraw old selection without blue highlight
                    Door.CursorRestore();
                    if (_InCHOICEOptions[OldSelectedIndex - 1].VisibleIndex > 1) Door.CursorDown(_InCHOICEOptions[OldSelectedIndex - 1].VisibleIndex - 1);
                    Door.Write(RTVariables.TranslateVariables(_InCHOICEOptions[OldSelectedIndex - 1].Text));

                    // Draw new selection with blue highlight
                    Door.CursorRestore();
                    if (_InCHOICEOptions[SelectedIndex - 1].VisibleIndex > 1) Door.CursorDown(_InCHOICEOptions[SelectedIndex - 1].VisibleIndex - 1);
                    Door.TextBackground(Crt.Blue);
                    Door.Write(RTVariables.TranslateVariables(_InCHOICEOptions[SelectedIndex - 1].Text));
                    Door.TextBackground(Crt.Black);
                }
            }

            // Move cursor below choice statement
            Door.CursorRestore();
            Door.CursorDown(VisibleCount - 1);
            Door.CursorRight(LastVisibleLength);

            // Update global variable responses
            RTGlobal.RESPONSE = SelectedIndex.ToString();
        }

        private void EndREADFILE()
        {
            // TODO _InWRITEFILE could be handled like this, so no need for multiple writes per writefile
            if (File.Exists(_InREADFILE))
            {
                string[] Lines = FileUtils.FileReadAllLines(_InREADFILE, RMEncoding.Ansi);

                int LoopMax = Math.Min(Lines.Length, _InREADFILELines.Count);
                for (int i = 0; i < LoopMax; i++)
                {
                    RTVariables.SetVariable(_InREADFILELines[i], RTVariables.TranslateVariables(Lines[i]));
                }
            }
        }

        private void EndSAYBAR(string line)
        {
            // Save cursor and text attr
            int SavedTextAttr = Crt.TextAttr;
            Door.CursorSave();

            // Output new bar
            Door.GotoXY(3, 21);
            Door.TextAttr(31);
            int StrippedLength = Door.StripSeth(RTVariables.TranslateVariables(line)).Length;
            int LeftSpaces = Math.Max(0, (76 - StrippedLength) / 2);
            int RightSpaces = Math.Max(0, 76 - StrippedLength - LeftSpaces);
            Door.Write(new string(' ', LeftSpaces) + RTVariables.TranslateVariables(line) + new string(' ', RightSpaces));
            // TODO say bar should be removed after 3 seconds or so

            // Restore
            Door.CursorRestore();
            Door.TextAttr(SavedTextAttr);
        }

        private void EndSELLMANAGER()
        {
            LogUnimplemented(new string[] { "TODOX" });
        }

        private void EndSHOWSCROLL()
        {
            char? Ch = null;
            int Page = 1;
            int MaxPage = Convert.ToInt32(Math.Truncate(_InSHOWSCROLLLines.Count / 22.0));
            if (_InSHOWSCROLLLines.Count % 22 != 0) MaxPage += 1;
            int SavedAttr = 7;

            while (Ch != 'Q')
            {
                Door.TextAttr(SavedAttr);
                Door.ClrScr();

                int LineStart = (Page - 1) * 22;
                int LineEnd = LineStart + 21;
                for (int i = LineStart; i <= LineEnd; i++)
                {
                    if (i >= _InSHOWSCROLLLines.Count) break;
                    Door.WriteLn(_InSHOWSCROLLLines[i]);
                }
                SavedAttr = Crt.TextAttr;

                Door.GotoXY(1, 23);
                Door.TextAttr(31);
                Door.Write(new string(' ', 79));
                Door.GotoXY(3, 23);
                Door.Write("(" + Page + ")");
                Door.GotoXY(9, 23);
                Door.Write("[N]ext Page, [P]revious Page, [Q]uit, [S]tart, [E]nd");

                Ch = Door.ReadKey();
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
            }
        }

        public static void Execute(string fileName, string sectionName, string labelName = "")
        {
            (new RTReader()).RunSection(fileName, sectionName, labelName);
        }

        private void LogMissing(string[] tokens)
        {
            string Output = "MISSING!!! (hit a key): " + string.Join(" ", tokens);
            Crt.FastWrite(StringUtils.PadRight(Output, ' ', 80), 1, 25, 31);
            Crt.ReadKey();
            Crt.FastWrite(new string(' ', 80), 1, 25, 0);
        }

        private void LogUnused(string[] tokens)
        {
            string Output = "UNUSED?!? (hit a key): " + string.Join(" ", tokens);
            Crt.FastWrite(StringUtils.PadRight(Output, ' ', 80), 1, 25, 31);
            Crt.ReadKey();
            Crt.FastWrite(new string(' ', 80), 1, 25, 0);
        }

        private void LogUnimplemented(string[] tokens)
        {
            string Output = "UNIMPLEMENTED (hit a key): " + string.Join(" ", tokens);
            Crt.FastWrite(StringUtils.PadRight(Output, ' ', 80), 1, 25, 31);
            Crt.ReadKey();
            Crt.FastWrite(new string(' ', 80), 1, 25, 0);
        }

        public void RunSection(string fileName, string sectionName)
        {
            RunSection(fileName, sectionName, "");
        }

        public void RunSection(string fileName, string sectionName, string labelName)
        {
            // Run the selected script
            string FileNameWithoutExtension = Path.GetFileNameWithoutExtension(fileName);
            if (RTGlobal.RefFiles.ContainsKey(FileNameWithoutExtension))
            {
                _CurrentFile = RTGlobal.RefFiles[FileNameWithoutExtension];
                if (_CurrentFile.Sections.ContainsKey(sectionName))
                {
                    _CurrentSection = _CurrentFile.Sections[sectionName];

                    if (labelName != "")
                    {
                        if (_CurrentSection.Labels.ContainsKey(labelName))
                        {
                            _CurrentLineNumber = _CurrentSection.Labels[labelName];
                        }
                        else
                        {
                            Door.WriteLn(RTVariables.TranslateVariables("`4`b**`b `%ERROR : `2Label `0" + sectionName + " `2not found in `0" + Path.GetFileName(fileName) + " `4`b**`b`2"));
                            Door.ReadKey();
                            return;
                        }
                    }

                    RunScript(_CurrentSection.Script.ToArray());
                    return;
                }
                else
                {
                    Door.WriteLn(RTVariables.TranslateVariables("`4`b**`b `%ERROR : `2Section `0" + sectionName + " `2not found in `0" + Path.GetFileName(fileName) + " `4`b**`b`2"));
                    Door.ReadKey();
                    return;
                }
            }
            else
            {
                Door.WriteLn(RTVariables.TranslateVariables("`4`b**`b `%ERROR : `2File `0" + Path.GetFileName(fileName) + " `2not found. `4`b**`b`2"));
                Door.ReadKey();
                return;
            }
        }

        private void RunScript(string[] script)
        {
            while (_CurrentLineNumber < script.Length)
            {
                string Line = script[_CurrentLineNumber];
                string LineTrimmed = Line.Trim();

                if (_InCLOSESCRIPT)
                {
                    return;
                }
                else if (_InIFFalse < 999)
                {
                    if (LineTrimmed.StartsWith("@"))
                    {
                        string[] Tokens = LineTrimmed.Split(' ');
                        switch (Tokens[0].ToUpper())
                        {
                            case "@BEGIN":
                                _InBEGINCount += 1;
                                break;
                            case "@END":
                                _InBEGINCount -= 1;
                                if (_InBEGINCount == _InIFFalse) _InIFFalse = 999;
                                break;
                        }
                    }
                }
                else
                {
                    if (LineTrimmed.StartsWith("@"))
                    {
                        if (_InBUYMANAGER) EndBUYMANAGER();
                        if (_InCHOICE) EndCHOICE();
                        if (_InREADFILE != "") EndREADFILE();
                        if (_InSELLMANAGER) EndSELLMANAGER();
                        if (_InSHOWSCROLL) EndSHOWSCROLL();
                        _InBUYMANAGER = false;
                        _InCHOICE = false;
                        _InREADFILE = "";
                        _InSAY = false;
                        _InSAYBAR = false;
                        _InSELLMANAGER = false;
                        _InSHOW = false;
                        _InSHOWLOCAL = false;
                        _InSHOWSCROLL = false;
                        _InWRITEFILE = "";

                        string[] Tokens = LineTrimmed.Split(' ');
                        if (_Commands.ContainsKey(Tokens[0]))
                        {
                            _Commands[Tokens[0]](Tokens);
                        }
                        else
                        {
                            LogMissing(Tokens);
                        }
                    }
                    else
                    {
                        if (_InBUYMANAGER)
                        {
                            _InBUYMANAGEROptions.Add(Line);
                        }
                        else if (_InCHOICE)
                        {
                            _InCHOICEOptions.Add(new RTChoiceOption(Line));
                        }
                        else if (_InDO_ADDLOG)
                        {
                            FileUtils.FileAppendAllText(Global.GetSafeAbsolutePath("LOGNOW.TXT"), RTVariables.TranslateVariables(Line));
                            _InDO_ADDLOG = false;
                        }
                        else if (_InDO_WRITE)
                        {
                            Door.Write(RTVariables.TranslateVariables(Line));
                            _InDO_WRITE = false;
                        }
                        else if (_InFIGHT)
                        {
//                            if ((LineTrimmed <> '') AND NOT(AnsiStartsText(';', LineTrimmed))) then
//begin
//            FInFIGHTLines.Add(Line);
//                            if (FInFIGHTLines.Count = 16) then
//                            begin
//              EndFIGHT;
//                            FInFIGHT:= false;
//                            end;
//                            end;

                        }
                        else if (_InREADFILE != "")
                        {
                            _InREADFILELines.Add(Line);
                        }
                        else if (_InSAY)
                        {
                            // TODO SHould be in TEXT window (but since LORD2 doesn't use @SAY, not a high priority)
                            Door.Write(RTVariables.TranslateVariables(Line));
                        }
                        else if (_InSAYBAR)
                        {
                            EndSAYBAR(Line);
                            _InSAYBAR = false;
                        }
                        else if (_InSELLMANAGER)
                        {
                            _InSELLMANAGEROptions.Add(Line);
                        }
                        else if (_InSHOW)
                        {
                            Door.WriteLn(RTVariables.TranslateVariables(Line));
                        }
                        else if (_InSHOWLOCAL)
                        {
                            Ansi.Write(RTVariables.TranslateVariables(Line) + "\r\n");
                        }
                        else if (_InSHOWSCROLL)
                        {
                            _InSHOWSCROLLLines.Add(RTVariables.TranslateVariables(Line));
                        }
                        else if (_InWRITEFILE != "")
                        {
                            FileUtils.FileAppendAllText(_InWRITEFILE, RTVariables.TranslateVariables(Line) + Environment.NewLine, RMEncoding.Ansi);
                        }
                    }
                }

                _CurrentLineNumber += 1;
            }
        }
    }
}
