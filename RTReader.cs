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
        private static Dictionary<string, Int16> _GlobalI = new Dictionary<string, Int16>(StringComparer.OrdinalIgnoreCase);
        private static Dictionary<string, Int32> _GlobalP = new Dictionary<string, Int32>(StringComparer.OrdinalIgnoreCase);
        private static Dictionary<string, string> _GlobalPLUS = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        private static Dictionary<string, string> _GlobalS = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        private static Dictionary<string, byte> _GlobalT = new Dictionary<string, byte>(StringComparer.OrdinalIgnoreCase);
        private static Dictionary<string, Int32> _GlobalV = new Dictionary<string, Int32>(StringComparer.OrdinalIgnoreCase);
        private static int _InBEGINCount = 0;
        private static bool _InDOWrite = false;
        private static int _InIFFalse = 999;
        private static bool _InSHOW = false;
        private static string _InWRITEFILE = "";
        private static Dictionary<string, Dictionary<string, string[]>> _RefFiles = new Dictionary<string, Dictionary<string, string[]>>(StringComparer.OrdinalIgnoreCase);
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
            foreach (KeyValuePair<string, Dictionary<string, string[]>> RefFile in _RefFiles)
            {
                Crt.WriteLn("Ref File Name: " + RefFile.Key);
                foreach (KeyValuePair<string, string[]> Section in RefFile.Value)
                {
                    Crt.WriteLn("  - " + Section.Key + " (" + Section.Value.Length.ToString() + " lines)");
                }
            }
        }

        private static void HandleDO(string[] tokens)
        {
            switch (tokens[1].ToUpper())
            {
                case "WRITE": // @DO WRITE next one line is written to the screen, no line wrap
                    _InDOWrite = true;
                    return;
                default:
                    switch (tokens[2].ToUpper())
                    {
                        case "IS": // @DO <Number To Change> IS <Change With What>
                            AssignVariable(tokens[1], string.Join(" ", tokens, 3, tokens.Length - 3));
                            break;
                    }
                    break;
            }

            Crt.WriteLn("TODO: " + string.Join(" ", tokens));
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

            Crt.WriteLn("TODO: " + string.Join(" ", tokens));
            return false;
        }

        private static void LoadRefFile(string fileName)
        {
            // A place to store all the sections found in this file
            Dictionary<string, string[]> Sections = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);

            // Where to store the info for the section we're currently working on
            string CurrentSectionName = "_HEADER";
            List<string> CurrentSectionScript = new List<string>();

            // Loop through the file
            string[] Lines = File.ReadAllLines(fileName);
            foreach (string Line in Lines)
            {
                string LineTrimmed = Line.Trim();

                // Check for new section
                if (LineTrimmed.StartsWith("@#"))
                {
                    // Store section in dictionary
                    Sections.Add(CurrentSectionName, CurrentSectionScript.ToArray());

                    // Get new section name (presumes only one word headers allowed, trims @# off start) and reset script block
                    CurrentSectionName = Line.Trim().Split(' ')[0].Substring(2);
                    CurrentSectionScript.Clear();
                }
                else
                {
                    CurrentSectionScript.Add(Line);
                }
            }

            // Store last open section in dictionary
            Sections.Add(CurrentSectionName, CurrentSectionScript.ToArray());

            _RefFiles.Add(Path.GetFileNameWithoutExtension(fileName), Sections);
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
            Dictionary<string, string[]> RefFile = _RefFiles[fileName];
            if (RefFile != null)
            {
                string[] Lines = RefFile[sectionName];
                if (Lines != null)
                {
                    RunScript(Lines);
                }
            }
        }

        private static void RunScript(string[] script)
        {
            int LineNumber = 0;
            while (LineNumber < script.Length)
            {
                string Line = script[LineNumber];
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
                        _InSHOW = false;
                        _InWRITEFILE = "";

                        string[] Tokens = LineTrimmed.Split(' ');
                        switch (Tokens[0].ToUpper())
                        {
                            case "@BEGIN":
                                _InBEGINCount += 1;
                                break;
                            case "@CLOSESCRIPT":
                                return;
                            case "@DISPLAYFILE": // @DISPLAYFILE <filename> <options> (options are NOPAUSE and NOSKIP, separated by space if both used)
                                // TODO As with WRITEFILE, don't allow for ..\..\blah
                                // TODO Handle variables as filename (ie `s02)
                                Crt.Write(FileUtils.FileReadAllText(StringUtils.PathCombine(ProcessUtils.StartupPath, TranslateVariables(Tokens[1]))));
                                break;
                            case "@DO": // @DO has waaaaaay too many variants
                                HandleDO(Tokens);
                                break;
                            case "@END":
                                _InBEGINCount -= 1;
                                break;
                            case "@IF": // @IF <Varible> <Math> <Thing the varible must be, or more or less then, or another varible>  (Possible math functions: EQUALS, MORE, LESS, NOT)
                                bool Result = HandleIF(Tokens);
                                if (script[LineNumber + 1].Trim().ToUpper().StartsWith("@BEGIN"))
                                {
                                    if (!Result)
                                    {
                                        _InIFFalse = _InBEGINCount;
                                        _InBEGINCount += 1;
                                        LineNumber += 1;
                                    }
                                }
                                else
                                {
                                    Crt.WriteLn("TODO: " + Line);
                                }
                                break;
                            case "@LABEL": // @LABEL <label name>
                                // Ignore
                                break;
                            case "@SHOW": // @SHOW following lines until next one starting with @ are output to screen
                                _InSHOW = true;
                                break;
                            case "@VERSION": // @VERSION <Version the script needs>
                                int RequiredVersion = Convert.ToInt32(Tokens[1]);
                                if (RequiredVersion > _Version) throw new ArgumentOutOfRangeException("VERSION", "@VERSION requested version " + RequiredVersion + ", we only support version " + _Version);
                                break;
                            case "@WRITEFILE": // @WRITEFILE <filename> following lines until next one starting with @ are output to file (append on existing, create on new)
                                // TODO Strip out any invalid filename characters?  (so for example they can't say ..\..\..\..\windows\system32\important_file.ext)
                                // TODO Handle variables as filename (ie `s02)
                                _InWRITEFILE = StringUtils.PathCombine(ProcessUtils.StartupPath, TranslateVariables(Tokens[1]));
                                break;
                            default:
                                Crt.WriteLn("TODO Unknown: " + LineTrimmed);
                                break;
                        }
                    }
                    else
                    {
                        // TODO If we're outputting something, we might need to do something here
                        if (_InDOWrite)
                        {
                            Crt.Write(LineTranslated);
                            _InDOWrite = false;
                        }
                        else if (_InSHOW)
                        {
                            Crt.WriteLn(LineTranslated);
                        }
                        else if (_InWRITEFILE != "")
                        {
                            FileUtils.FileAppendAllText(_InWRITEFILE, LineTranslated + Environment.NewLine);
                        }
                    }
                }

                LineNumber += 1;
            }
        }

        private static string TranslateVariables(string input)
        {
            if (input.Contains("`"))
            {
                string inputUpper = input.ToUpper();

                if (inputUpper.Contains("`I"))
                {
                    foreach (KeyValuePair<string, short> KVP in _GlobalI)
                    {
                        input = Regex.Replace(input, KVP.Key, KVP.Value.ToString(), RegexOptions.IgnoreCase);
                    }
                }
                if (inputUpper.Contains("`P"))
                {
                    foreach (KeyValuePair<string, int> KVP in _GlobalP)
                    {
                        input = Regex.Replace(input, KVP.Key, KVP.Value.ToString(), RegexOptions.IgnoreCase);
                    }
                }
                if (inputUpper.Contains("`+"))
                {
                    foreach (KeyValuePair<string, string> KVP in _GlobalPLUS)
                    {
                        input = Regex.Replace(input, KVP.Key, KVP.Value, RegexOptions.IgnoreCase);
                    }
                }
                if (inputUpper.Contains("`S"))
                {
                    foreach (KeyValuePair<string, string> KVP in _GlobalS)
                    {
                        input = Regex.Replace(input, KVP.Key, KVP.Value, RegexOptions.IgnoreCase);
                    }
                }
                if (inputUpper.Contains("`T"))
                {
                    foreach (KeyValuePair<string, byte> KVP in _GlobalT)
                    {
                        input = Regex.Replace(input, KVP.Key, KVP.Value.ToString(), RegexOptions.IgnoreCase);
                    }
                }
                if (inputUpper.Contains("`V"))
                {
                    foreach (KeyValuePair<string, int> KVP in _GlobalV)
                    {
                        input = Regex.Replace(input, KVP.Key, KVP.Value.ToString(), RegexOptions.IgnoreCase);
                    }
                }
            }

            // TODO also translate language variables and variable symbols
            return input;
        }
    }
}
