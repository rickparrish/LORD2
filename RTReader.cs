using RandM.RMLib;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;

namespace LORD2
{
    public static class RTReader
    {
        private static int _CurrentLineNumber = 0;
        private static RTRFile _CurrentFile = null;
        private static RTRSection _CurrentSection = null;
        private static Dictionary<string, Int16> _GlobalI = new Dictionary<string, Int16>(StringComparer.OrdinalIgnoreCase);
        private static Dictionary<string, string> _GlobalOther = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        private static Dictionary<string, Int32> _GlobalP = new Dictionary<string, Int32>(StringComparer.OrdinalIgnoreCase);
        private static Dictionary<string, string> _GlobalPLUS = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        private static Dictionary<string, string> _GlobalS = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        private static Dictionary<string, byte> _GlobalT = new Dictionary<string, byte>(StringComparer.OrdinalIgnoreCase);
        private static Dictionary<string, Int32> _GlobalV = new Dictionary<string, Int32>(StringComparer.OrdinalIgnoreCase);
        private static Dictionary<string, string> _GlobalWords = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        private static int _InBEGINCount = 0;
        private static bool _InCHOICE = false;
        private static List<string> _InCHOICEOptions = new List<string>();
        private static bool _InDOWrite = false;
        private static string _InGOTOHeader = "";
        private static int _InGOTOLineNumber = 0;
        private static int _InIFFalse = 999;
        private static bool _InSAY = false;
        private static bool _InSHOW = false;
        private static bool _InSHOWLOCAL = false;
        private static string _InWRITEFILE = "";
        private static Random _R = new Random();
        private static Dictionary<string, RTRFile> _RefFiles = new Dictionary<string, RTRFile>(StringComparer.OrdinalIgnoreCase);
        private static int _SavedX = 1;
        private static int _SavedY = 1;
        private static int _Version = 2;

        static RTReader()
        {
            // Initialize stuff
            LoadRefFiles(ProcessUtils.StartupPath);

            // Init global variables
            for (int i = 1; i <= 99; i++) _GlobalI.Add("`I" + StringUtils.PadLeft(i.ToString(), '0', 2), 0);
            for (int i = 1; i <= 99; i++) _GlobalP.Add("`P" + StringUtils.PadLeft(i.ToString(), '0', 2), 0);
            for (int i = 1; i <= 99; i++) _GlobalPLUS.Add("`+" + StringUtils.PadLeft(i.ToString(), '0', 2), "");
            for (int i = 1; i <= 10; i++) _GlobalS.Add("`S" + StringUtils.PadLeft(i.ToString(), '0', 2), "");
            for (int i = 1; i <= 99; i++) _GlobalT.Add("`T" + StringUtils.PadLeft(i.ToString(), '0', 2), 0);
            for (int i = 1; i <= 40; i++) _GlobalV.Add("`V" + StringUtils.PadLeft(i.ToString(), '0', 2), 0);

            _GlobalOther.Add("`N", "SYSOP"); // TODO
            _GlobalOther.Add("`E", "ENEMY"); // TODO
            _GlobalOther.Add("`G", "3"); // TODO 3 = ANSI
            _GlobalOther.Add("`X", " ");
            _GlobalOther.Add("`D", "\x08");
            _GlobalOther.Add("`1", Ansi.TextColor(Crt.Blue));
            _GlobalOther.Add("`2", Ansi.TextColor(Crt.Green));
            _GlobalOther.Add("`3", Ansi.TextColor(Crt.Cyan));
            _GlobalOther.Add("`4", Ansi.TextColor(Crt.Red));
            _GlobalOther.Add("`5", Ansi.TextColor(Crt.Magenta));
            _GlobalOther.Add("`6", Ansi.TextColor(Crt.Brown));
            _GlobalOther.Add("`7", Ansi.TextColor(Crt.LightGray));
            _GlobalOther.Add("`8", Ansi.TextColor(Crt.White)); // Supposed to be dark gray, but actually white
            _GlobalOther.Add("`9", Ansi.TextColor(Crt.LightBlue));
            _GlobalOther.Add("`0", Ansi.TextColor(Crt.LightGreen));
            _GlobalOther.Add("`!", Ansi.TextColor(Crt.LightCyan));
            _GlobalOther.Add("`@", Ansi.TextColor(Crt.LightRed));
            _GlobalOther.Add("`#", Ansi.TextColor(Crt.LightMagenta));
            _GlobalOther.Add("`$", Ansi.TextColor(Crt.Yellow));
            _GlobalOther.Add("`%", Ansi.TextColor(Crt.White));
            _GlobalOther.Add("`^", Ansi.TextColor(15));
            _GlobalOther.Add("`W", "TODO 1/10s");
            _GlobalOther.Add("`L", "TODO 1/2s");
            _GlobalOther.Add("`\\", "\r\n");
            _GlobalOther.Add("`r0", Ansi.TextBackground(Crt.Black));
            _GlobalOther.Add("`r1", Ansi.TextBackground(Crt.Blue));
            _GlobalOther.Add("`r2", Ansi.TextBackground(Crt.Green));
            _GlobalOther.Add("`r3", Ansi.TextBackground(Crt.Cyan));
            _GlobalOther.Add("`r4", Ansi.TextBackground(Crt.Red));
            _GlobalOther.Add("`r5", Ansi.TextBackground(Crt.Magenta));
            _GlobalOther.Add("`r6", Ansi.TextBackground(Crt.Brown));
            _GlobalOther.Add("`r7", Ansi.TextBackground(Crt.LightGray));
            _GlobalOther.Add("`c", Ansi.ClrScr() + "\r\n\r\n"); // TODO only `c works in RTReader, not `C -- bug, or should `C really not work?
            _GlobalOther.Add("`k", "TODO MORE");
            // TODO `b

            _GlobalWords.Add("LOCAL", "5"); // TODO 5 = true
            _GlobalWords.Add("RESPONCE", "0");
            _GlobalWords.Add("RESPONSE", "0");
        }

        private static void AssignVariable(string variable, string value)
        {
            // Split while we still have the raw input string (in case we're doing a LENGTH operation)
            string[] values = value.Split(' ');

            // Translate the input string
            value = TranslateVariables(value);

            // Check for LENGTH operator
            if ((values.Length == 2) && (values[1].StartsWith("`")))
            {
                // TODO Both of these need to be corrected to match the docs
                if (values[0].ToUpper() == "LENGTH")
                {
                    values[0] = values[1].Length.ToString();
                }
                else if (values[0].ToUpper() == "REALLENGTH")
                {
                    values[0] = values[1].Length.ToString();
                }
            }
            else
            {
                // Translate the first split input variable, which is still raw (and may be used by number variables below)
                values[0] = TranslateVariables(values[0]);
            }

            // See which variables to update
            if (_GlobalI.ContainsKey(variable))
            {
                _GlobalI[variable] = Convert.ToInt16(values[0]);
            }
            if (_GlobalP.ContainsKey(variable))
            {
                _GlobalP[variable] = Convert.ToInt32(values[0]);
            }
            if (_GlobalPLUS.ContainsKey(variable)) _GlobalPLUS[variable] = value;
            if (_GlobalS.ContainsKey(variable)) _GlobalS[variable] = value;
            if (_GlobalT.ContainsKey(variable))
            {
                _GlobalT[variable] = Convert.ToByte(values[0]);
            }
            if (_GlobalV.ContainsKey(variable))
            {
                _GlobalV[variable] = Convert.ToInt32(values[0]);
            }
        }

        public static void DisplayRefFileSections()
        {
            Crt.ClrScr();
            Crt.WriteLn("DEBUG OUTPUT");
            foreach (KeyValuePair<string, RTRFile> RefFile in _RefFiles)
            {
                Crt.WriteLn("Ref File Name: " + RefFile.Key);
                foreach (KeyValuePair<string, RTRSection> Section in RefFile.Value.Sections)
                {
                    Crt.WriteLn("  - " + Section.Key + " (" + Section.Value.Script.Count.ToString() + " lines)");
                }
            }
        }

        private static void HandleCHOICE()
        {
            // @CHOICE next lines until next @ command are choice options in listbox.  RESPONCE and RESPONSE hold result, `V01 defines initial selected index
            /*The choice command is more useful now; you can now define *IF* type statements 
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
            "Hey, I have more than 500", RESPONSE would be set to 5.*/

            // Output options
            Crt.GotoXY(1, 16);
            int FirstKey = 65;
            for (int i = 0; i < _InCHOICEOptions.Count; i++)
            {
                Ansi.Write(TranslateVariables("   `2(`0" + ((char)(FirstKey + i)).ToString() + "`2)`7 " + _InCHOICEOptions[i] + "\r\n"));
            }

            // Get response
            char Choice = '\0';
            while (((byte)Choice < FirstKey) || ((byte)Choice > (FirstKey + _InCHOICEOptions.Count - 1)))
            {
                Choice = Crt.ReadKey().ToString().ToUpper()[0];
            }

            _GlobalWords["RESPONCE"] = (Choice - 64).ToString();
            _GlobalWords["RESPONSE"] = (Choice - 64).ToString();
        }

        private static void HandleCLEAR(string[] tokens)
        {
            // @CLEAR <screen or name or userscreen or text or picture or all>
            // TODO None of these will work remotely
            switch (tokens[1].ToUpper())
            {
                case "ALL":
                    HandleCLEAR("@CLEAR USERSCREEN".Split(' '));
                    HandleCLEAR("@CLEAR PICTURE".Split(' '));
                    HandleCLEAR("@CLEAR TEXT".Split(' '));
                    HandleCLEAR("@CLEAR NAME".Split(' '));
                    // TODO And redraws the screen
                    return;
                case "NAME":
                    _SavedX = Crt.WhereX();
                    _SavedY = Crt.WhereY();
                    Crt.GotoXY(54, 15);
                    Ansi.Write(new string(' ', 23));
                    Crt.GotoXY(_SavedX, _SavedY);
                    return;
                case "PICTURE":
                    _SavedX = Crt.WhereX();
                    _SavedY = Crt.WhereY();
                    Crt.Window(55, 3, 76, 13);
                    Crt.ClrScr();
                    Crt.Window(1, 1, 80, 25);
                    Crt.GotoXY(_SavedX, _SavedY);
                    return;
                case "SCREEN":
                    Crt.ClrScr();
                    return;
                case "TEXT":
                    _SavedX = Crt.WhereX();
                    _SavedY = Crt.WhereY();
                    Crt.Window(33, 3, 33 + 19, 3 + 11);
                    Crt.ClrScr();
                    Crt.Window(1, 1, 80, 25);
                    Crt.GotoXY(_SavedX, _SavedY);
                    return;
                case "USERSCREEN":
                    _SavedX = Crt.WhereX();
                    _SavedY = Crt.WhereY();
                    Crt.Window(1, 16, 80, 23);
                    Crt.ClrScr();
                    Crt.Window(1, 1, 80, 25);
                    Crt.GotoXY(_SavedX, _SavedY);
                    return;
            }

            Crt.WriteLn("TODO (hit a key): " + string.Join(" ", tokens));
            Crt.ReadKey();
        }

        private static void HandleDO(string[] tokens)
        {
            switch (tokens[1].ToUpper())
            {
                case "COPYTONAME": // @DO COPYTONAME store `S10 in `N
                    _GlobalOther["`N"] = TranslateVariables("`S10");
                    return;
                case "GOTO": // @DO GOTO <header or label>
                    if (_CurrentFile.Sections.ContainsKey(tokens[2]))
                    {
                        // HEADER goto
                        _InGOTOHeader = tokens[2];
                    }
                    else if (_CurrentSection.Labels.ContainsKey(tokens[2]))
                    {
                        // LABEL goto within current section
                        _CurrentLineNumber = _CurrentSection.Labels[tokens[2]];
                    }
                    else
                    {
                        foreach (KeyValuePair<string, RTRSection> KVP in _CurrentFile.Sections)
                        {
                            if (KVP.Value.Labels.ContainsKey(tokens[2]))
                            {
                                // LABEL goto within a different section
                                _InGOTOHeader = KVP.Key; // Section name
                                _InGOTOLineNumber = KVP.Value.Labels[tokens[2]];
                                break;
                            }
                        }
                    }
                    return;
                case "NUMRETURN": // @DO NUMRETURN <int var> <string var>
                    string Translated = TranslateVariables(tokens[3]);
                    string TranslatedWithoutNumbers = Regex.Replace(Translated, "[0-9]", "", RegexOptions.IgnoreCase);
                    AssignVariable(tokens[2], (Translated.Length - TranslatedWithoutNumbers.Length).ToString());
                    return;
                case "READSTRING": // @DO READSTRING <MAX LENGTH> <DEFAULT> <variable TO PUT IT IN> (variable may be left off, in which case store in `S10)
                    // TODO Doesn't take max length or default into account
                    // TODO Maybe need an AssignVariable parameter that tells it not to translate?  Otherwise user input will be translated
                    string Input = "";
                    Crt.ReadLn(out Input);
                    if (tokens.Length >= 5)
                    {
                        AssignVariable(tokens[4], Input);
                    }
                    else
                    {
                        AssignVariable("`S10", Input);
                    }
                    return;
                case "REPLACEALL": // @DO REPLACEALL <find> <replace> <in>
                    AssignVariable(tokens[4], Regex.Replace(TranslateVariables(tokens[4]), Regex.Escape(TranslateVariables(tokens[2])), TranslateVariables(tokens[3]), RegexOptions.IgnoreCase));
                    return;
                case "STRIP": // @DO STRIP <string variable> (really trim)
                    AssignVariable(tokens[2], TranslateVariables(tokens[2]).Trim());
                    return;
                case "STRIPBAD": // @DO STRIPBAD <string variable> (strip illegal ` and replaces via badwords.dat)
                    // TODO
                    return;
                case "TRIM": // @DO TRIM <file name> <number to trim to> (remove lines from file until less than number in length)
                    string FileName = StringUtils.PathCombine(ProcessUtils.StartupPath, TranslateVariables(tokens[2]));
                    int MaxLines = Convert.ToInt32(TranslateVariables(tokens[3]));
                    List<string> Lines = new List<string>();
                    Lines.AddRange(FileUtils.FileReadAllLines(FileName, RMEncoding.Ansi));
                    if (Lines.Count > MaxLines)
                    {
                        while (Lines.Count > MaxLines) Lines.RemoveAt(0);
                        FileUtils.FileWriteAllLines(FileName, Lines.ToArray(), RMEncoding.Ansi);
                    }
                    return;
                case "UPCASE": // @DO UPCASE <string variable>
                    AssignVariable(tokens[2], TranslateVariables(tokens[2]).ToUpper());
                    return;
                case "WRITE": // @DO WRITE next one line is written to the screen, no line wrap
                    _InDOWrite = true;
                    return;
                default:
                    switch (tokens[2].ToUpper())
                    {
                        case "/": // @DO <number to change> / <change with what>
                            // TODO How to round?
                            AssignVariable(tokens[1], (Convert.ToInt32(TranslateVariables(tokens[1])) / Convert.ToInt32(TranslateVariables(tokens[3]))).ToString());
                            return;
                        case "*": // @DO <number to change> * <change with what>
                            AssignVariable(tokens[1], (Convert.ToInt32(TranslateVariables(tokens[1])) * Convert.ToInt32(TranslateVariables(tokens[3]))).ToString());
                            return;
                        case "-": // @DO <number to change> - <change with what>
                            AssignVariable(tokens[1], (Convert.ToInt32(TranslateVariables(tokens[1])) - Convert.ToInt32(TranslateVariables(tokens[3]))).ToString());
                            return;
                        case "+": // @DO <number to change> + <change with what>
                            AssignVariable(tokens[1], (Convert.ToInt32(TranslateVariables(tokens[1])) + Convert.ToInt32(TranslateVariables(tokens[3]))).ToString());
                            return;
                        case "ADD": // DO <string var> ADD <string var or text>
                            AssignVariable(tokens[1], TranslateVariables(tokens[1] + string.Join(" ", tokens, 3, tokens.Length - 3)));
                            return;
                        case "IS": // @DO <Number To Change> IS <Change With What>
                            AssignVariable(tokens[1], string.Join(" ", tokens, 3, tokens.Length - 3));
                            return;
                        case "RANDOM": // @DO <Varible to put # in> RANDOM <Highest number> <number to add to it>
                            int Min = Convert.ToInt32(tokens[4]);
                            int Max = Min + Convert.ToInt32(tokens[3]);
                            AssignVariable(tokens[1], _R.Next(Min, Max).ToString());
                            return;
                    }
                    break;
            }

            Crt.WriteLn("TODO (hit a key): " + string.Join(" ", tokens));
            Crt.ReadKey();
        }

        private static bool HandleIF(string[] tokens)
        {
            string Left = TranslateVariables(tokens[1]);
            string Right = TranslateVariables(tokens[3]);
            int LeftInt = 0;
            int RightInt = 0;

            switch (tokens[2].ToUpper())
            {
                case "EQUALS": // @IF <Varible> EQUALS <Thing the varible must be, or more or less then, or another varible>
                case "IS": // @IF <Varible> IS <Thing the varible must be, or more or less then, or another varible>
                    if (int.TryParse(Left, out LeftInt) && int.TryParse(Right, out RightInt))
                    {
                        return (LeftInt == RightInt);
                    }
                    else
                    {
                        return (Left == Right);
                    }
                case "EXIST": // @IF <filename> EXIST <true or false>
                    string FileName = StringUtils.PathCombine(ProcessUtils.StartupPath, Left);
                    bool TrueFalse = Convert.ToBoolean(Right.ToUpper());
                    return (File.Exists(FileName) == TrueFalse);
                case "INSIDE": // @IF <Word or variable> INSIDE <Word or variable>
                    return Right.ToUpper().Contains(Left.ToUpper());
                case "LESS": // @IF <Varible> LESS <Thing the varible must be, or more or less then, or another varible>
                    if (int.TryParse(Left, out LeftInt) && int.TryParse(Right, out RightInt))
                    {
                        return (LeftInt < RightInt);
                    }
                    else
                    {
                        throw new ArgumentException("@IF LESS arguments were not numeric");
                    }
                case "MORE": // @IF <Varible> MORE <Thing the varible must be, or more or less then, or another varible>
                    if (int.TryParse(Left, out LeftInt) && int.TryParse(Right, out RightInt))
                    {
                        return (LeftInt > RightInt);
                    }
                    else
                    {
                        throw new ArgumentException("@IF MORE arguments were not numeric");
                    }
                case "NOT": // @IF <Varible> NOT <Thing the varible must be, or more or less then, or another varible>
                    if (int.TryParse(Left, out LeftInt) && int.TryParse(Right, out RightInt))
                    {
                        return (LeftInt != RightInt);
                    }
                    else
                    {
                        return (Left != Right);
                    }
            }

            Crt.WriteLn("TODO (hit a key): " + string.Join(" ", tokens));
            Crt.ReadKey();
            return false;
        }

        private static void LoadRefFile(string fileName)
        {
            // A place to store all the sections found in this file
            RTRFile NewFile = new RTRFile();

            // Where to store the info for the section we're currently working on
            string NewSectionName = "_HEADER";
            RTRSection NewSection = new RTRSection();

            // Loop through the file
            string[] Lines = FileUtils.FileReadAllLines(fileName, RMEncoding.Ansi);
            foreach (string Line in Lines)
            {
                string LineTrimmed = Line.Trim();

                // Check for new section
                if (LineTrimmed.StartsWith("@#"))
                {
                    // Store section in dictionary
                    NewFile.Sections.Add(NewSectionName, NewSection);

                    // Get new section name (presumes only one word headers allowed, trims @# off start) and reset script block
                    NewSectionName = Line.Trim().Split(' ')[0].Substring(2);
                    NewSection = new RTRSection();
                }
                else if (LineTrimmed.StartsWith("@LABEL "))
                {
                    NewSection.Script.Add(Line);

                    string[] Tokens = LineTrimmed.Split(' ');
                    NewSection.Labels.Add(Tokens[1].ToUpper(), NewSection.Script.Count - 1);
                }
                else
                {
                    // TODO Filter out comment lines, which should make the @IF followed by @BEGIN check more reliable, since @IF will never be followed by a comment if we filter it
                    // TODO Need to keep track of @DO DISPLAY and @SHOW and @CHOICE and @SAY statements though, so we don't filter out legitimate text!
                    NewSection.Script.Add(Line);
                }
            }

            // Store last open section in dictionary
            NewFile.Sections.Add(NewSectionName, NewSection);

            _RefFiles.Add(Path.GetFileNameWithoutExtension(fileName), NewFile);
        }

        private static void LoadRefFiles(string directoryName)
        {
            string[] RefFileNames = Directory.GetFiles(directoryName, "*.ref", SearchOption.TopDirectoryOnly);
            foreach (string RefFileName in RefFileNames)
            {
                LoadRefFile(RefFileName);
            }
        }

        public static void RunSection(string fileName, string sectionName)
        {
            // TODO What happens if invalid file and/or section name is given

            // Run the selected script
            _CurrentFile = _RefFiles[fileName];
            _CurrentSection = _CurrentFile.Sections[sectionName];
            _CurrentLineNumber = _InGOTOLineNumber;
            _InGOTOLineNumber = 0;
            RunScript(_CurrentSection.Script.ToArray());

            // If we exit this script with _InGOTOHeader set, it means we want to GOTO a different section
            if (_InGOTOHeader != "")
            {
                string TempGOTOHeader = _InGOTOHeader;
                _InGOTOHeader = "";
                RunSection(fileName, TempGOTOHeader);
            }
        }

        private static void RunScript(string[] script)
        {
            while (_CurrentLineNumber < script.Length)
            {
                string Line = script[_CurrentLineNumber];
                string LineTranslated = TranslateVariables(Line);
                string LineTrimmed = Line.Trim();

                if (_InBEGINCount > _InIFFalse)
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
                                break;
                        }
                    }
                }
                else
                {
                    _InIFFalse = 999;

                    if (LineTrimmed.StartsWith("@"))
                    {
                        if (_InCHOICE) HandleCHOICE();
                        if (_InSAY)
                        {
                            Crt.Window(1, 1, 80, 25);
                            Crt.GotoXY(_SavedX, _SavedY);
                        }
                        _InCHOICE = false;
                        _InSAY = false;
                        _InSHOW = false;
                        _InSHOWLOCAL = false;
                        _InWRITEFILE = "";

                        string[] Tokens = LineTrimmed.Split(' ');
                        switch (Tokens[0].ToUpper())
                        {
                            case "@BEGIN":
                                _InBEGINCount += 1;
                                break;
                            case "@CHOICE": // @CHOICE next lines until next @ command are choice options in listbox.  RESPONCE and RESPONSE hold result, `V01 defines initial selected index
                                _InCHOICEOptions.Clear();
                                _InCHOICE = true;
                                break;
                            case "@CLEAR": // @CLEAR <screen or name or userscreen or text or picture or all> 
                                HandleCLEAR(Tokens);
                                break;
                            case "@CLOSESCRIPT":
                                return;
                            case "@DISPLAYFILE": // @DISPLAYFILE <filename> <options> (options are NOPAUSE and NOSKIP, separated by space if both used)
                                // TODO As with WRITEFILE, don't allow for ..\..\blah
                                // TODO Handle NOPAUSE and NOSKIP parameters
                                Ansi.Write(FileUtils.FileReadAllText(StringUtils.PathCombine(ProcessUtils.StartupPath, TranslateVariables(Tokens[1])), RMEncoding.Ansi));
                                break;
                            case "@DO": // @DO has waaaaaay too many variants
                                HandleDO(Tokens);
                                break;
                            case "@END":
                                _InBEGINCount -= 1;
                                break;
                            case "@IF": // @IF <Varible> <Math> <Thing the varible must be, or more or less then, or another varible>  (Possible math functions: EQUALS, MORE, LESS, NOT)
                                bool Result = HandleIF(Tokens);

                                // Check if it's an IF block, or inline IF
                                // TODO This isn't ideal -- what if the next line is a blank or a comment or something
                                if (script[_CurrentLineNumber + 1].Trim().ToUpper().StartsWith("@BEGIN"))
                                {
                                    if (!Result)
                                    {
                                        _InIFFalse = _InBEGINCount;
                                        _InBEGINCount += 1;
                                        _CurrentLineNumber += 1;
                                    }
                                }
                                else
                                {
                                    if (Result)
                                    {
                                        // TODO Everything in here is incredibly hackish, just want a working POC
                                        string[] THEN = string.Join(" ", Tokens, 5, Tokens.Length - 5).Split(' ');
                                        if (THEN[0].ToUpper() == "GOTO")
                                        {
                                            HandleDO(("@DO GOTO " + THEN[1]).Split(' '));
                                        }
                                        else
                                        {
                                            Crt.WriteLn("TODO (hit a key): " + Line);
                                            Crt.ReadKey();
                                        }
                                    }
                                }
                                break;
                            case "@KEY": // @KEY <bottom or top or nodisplay> does a [MORE] prompt centered on current line
                                // TODO Handle positioning
                                // TODO Also, does it erase after a keypress?
                                // @KEY = "  `1[`!MORE`1]`7" from current cursor position
                                // @KEY BOTTOM = "                                   `!<MORE>`7" on line 24
                                // @KEY TOP =    "                                       `![`1MORE`!]`7" on line 15
                                Ansi.Write(TranslateVariables("                                   `!<MORE>`7"));
                                // TODO Erase after drawing
                                Crt.ReadKey();
                                break;
                            case "@LABEL": // @LABEL <label name>
                                // Ignore
                                break;
                            case "@NAME": // @NAME <new name> sets the name below the picture window on the right
                                // TODO Name.Length is going to include the ANSI sequences, so not be the correct length
                                string Name = TranslateVariables(string.Join(" ", Tokens, 1, Tokens.Length - 1));
                                if (Name.Length > 23) Name = Name.Substring(0, 23);
                                _SavedX = Crt.WhereX();
                                _SavedY = Crt.WhereY();
                                Crt.GotoXY(54 + ((23 - Name.Length) / 2), 15);
                                Ansi.Write(Name);
                                Crt.GotoXY(_SavedX, _SavedY);
                                break;
                            case "@SAY": // @SAY All text UNDER this will be put in the 'talk window' until a @ is hit.
                                _SavedX = Crt.WhereX();
                                _SavedY = Crt.WhereY();
                                Crt.Window(33, 3, 33 + 19, 3 + 11);
                                _InSAY = true;
                                break;
                            case "@SHOW": // @SHOW following lines until next one starting with @ are output to screen
                                _InSHOW = true;
                                break;
                            case "@SHOWLOCAL": // Same as above, but output locally only
                                _InSHOWLOCAL = true;
                                break;
                            case "@VERSION": // @VERSION <Version the script needs>
                                int RequiredVersion = Convert.ToInt32(Tokens[1]);
                                if (RequiredVersion > _Version) throw new ArgumentOutOfRangeException("VERSION", "@VERSION requested version " + RequiredVersion + ", we only support version " + _Version);
                                break;
                            case "@WRITEFILE": // @WRITEFILE <filename> following lines until next one starting with @ are output to file (append on existing, create on new)
                                // TODO Strip out any invalid filename characters?  (so for example they can't say ..\..\..\..\windows\system32\important_file.ext)
                                _InWRITEFILE = StringUtils.PathCombine(ProcessUtils.StartupPath, TranslateVariables(Tokens[1]));
                                break;
                            default:
                                Crt.WriteLn("TODO (hit a key): " + LineTrimmed);
                                Crt.ReadKey();
                                break;
                        }
                    }
                    else
                    {
                        // TODO If we're outputting something, we might need to do something here
                        if (_InCHOICE)
                        {
                            _InCHOICEOptions.Add(Line);
                        }
                        else if (_InDOWrite)
                        {
                            // TODO Remotely
                            Ansi.Write(LineTranslated);
                            _InDOWrite = false;
                        }
                        else if (_InSAY)
                        {
                            // TODO Remotely
                            Ansi.Write(LineTranslated);
                        }
                        else if (_InSHOW)
                        {
                            // TODO Remotely
                            Ansi.Write(LineTranslated + "\r\n");
                        }
                        else if (_InSHOWLOCAL)
                        {
                            Ansi.Write(LineTranslated + "\r\n");
                        }
                        else if (_InWRITEFILE != "")
                        {
                            FileUtils.FileAppendAllText(_InWRITEFILE, LineTranslated + Environment.NewLine, RMEncoding.Ansi);
                        }
                    }
                }

                // Check if we need to GOTO a header (and stop processing this script)
                if (_InGOTOHeader != "") return;

                _CurrentLineNumber += 1;
            }
        }

        private static string TranslateVariables(string input)
        {
            string inputUpper = input.ToUpper();

            if (inputUpper.Contains("`I"))
            {
                foreach (KeyValuePair<string, short> KVP in _GlobalI)
                {
                    input = Regex.Replace(input, Regex.Escape(KVP.Key), KVP.Value.ToString(), RegexOptions.IgnoreCase);
                }
            }
            if (inputUpper.Contains("`P"))
            {
                foreach (KeyValuePair<string, int> KVP in _GlobalP)
                {
                    input = Regex.Replace(input, Regex.Escape(KVP.Key), KVP.Value.ToString(), RegexOptions.IgnoreCase);
                }
            }
            if (inputUpper.Contains("`+"))
            {
                foreach (KeyValuePair<string, string> KVP in _GlobalPLUS)
                {
                    input = Regex.Replace(input, Regex.Escape(KVP.Key), KVP.Value, RegexOptions.IgnoreCase);
                }
            }
            if (inputUpper.Contains("`S"))
            {
                foreach (KeyValuePair<string, string> KVP in _GlobalS)
                {
                    input = Regex.Replace(input, Regex.Escape(KVP.Key), KVP.Value, RegexOptions.IgnoreCase);
                }
            }
            if (inputUpper.Contains("`T"))
            {
                foreach (KeyValuePair<string, byte> KVP in _GlobalT)
                {
                    input = Regex.Replace(input, Regex.Escape(KVP.Key), KVP.Value.ToString(), RegexOptions.IgnoreCase);
                }
            }
            if (inputUpper.Contains("`V"))
            {
                foreach (KeyValuePair<string, int> KVP in _GlobalV)
                {
                    input = Regex.Replace(input, Regex.Escape(KVP.Key), KVP.Value.ToString(), RegexOptions.IgnoreCase);
                }
            }
            foreach (KeyValuePair<string, string> KVP in _GlobalOther)
            {
                input = Regex.Replace(input, Regex.Escape(KVP.Key), KVP.Value, RegexOptions.IgnoreCase);
            }
            foreach (KeyValuePair<string, string> KVP in _GlobalWords)
            {
                // TODO This isn't correct, since for example one of the global words is LOCAL, and so if a message says "my local calling area is 519" it'll be replaced with "my 5 calling area is 519"
                // TODO It's good enough for now for me to test with though
                if (input.ToUpper() == KVP.Key.ToUpper())
                {
                    input = KVP.Value;
                }
                else
                {
                    input = Regex.Replace(input, Regex.Escape(" " + KVP.Key + " "), KVP.Value, RegexOptions.IgnoreCase);
                }
            }

            // TODO also translate language variables and variable symbols
            return input;
        }
    }
}
