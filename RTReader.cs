using RandM.RMLib;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace LORD2
{
    static public class RTReader
    {
        static private Dictionary<string, Dictionary<string, string[]>> _RefFiles = new Dictionary<string, Dictionary<string, string[]>>(StringComparer.OrdinalIgnoreCase);
        static private int _InBEGINCount = 0;
        static private bool _InDOWrite = false;
        static private bool _InSHOW = false;
        static private string _InWRITEFILE = "";
        static private int _Version = 2;

        static RTReader()
        {
            // Initialize stuff
            LoadRefFiles(ProcessUtils.StartupPath);
        }

        static public void DisplayRefFileSections()
        {
            Crt.ClrScr();
            Crt.WriteLn("TODO DEBUG OUTPUT");
            foreach (KeyValuePair<string, Dictionary<string, string[]>> RefFile in _RefFiles)
            {
                Crt.WriteLn("Ref File Name: " + RefFile.Key);
                foreach (KeyValuePair<string, string[]> Section in RefFile.Value)
                {
                    Crt.WriteLn("  - " + Section.Key + " (" + Section.Value.Length.ToString() + " lines)");
                }
            }
        }

        static private void HandleDO(string[] tokens)
        {
            switch (tokens[1].ToUpper())
            {
                case "WRITE":
                    _InDOWrite = true;
                    return;
            }
            
            //TODOCrt.WriteLn("TODO: " + string.Join(" ", tokens));
        }

        static private bool HandleIF(string[] tokens)
        {
            switch (tokens[2].ToUpper())
            {
                case "EQUALS": // @IF <Varible> EQUALS <Thing the varible must be, or more or less then, or another varible>
                case "IS": // @IF <Varible> IS <Thing the varible must be, or more or less then, or another varible>
                    // TODO
                    return false;
                case "EXIST": // @IF <filename> EXIST <true or false>
                    string FileName = StringUtils.PathCombine(ProcessUtils.StartupPath, tokens[1]);
                    bool TrueFalse = Convert.ToBoolean(tokens[3].ToUpper());
                    return (File.Exists(FileName) == TrueFalse);
                case "LESS": // @IF <Varible> MORE <Thing the varible must be, or more or less then, or another varible>
                    // TODO
                    return false;
                case "MORE": // @IF <Varible> MORE <Thing the varible must be, or more or less then, or another varible>
                    // TODO
                    return false;
                case "NOT": // @IF <Varible> MORE <Thing the varible must be, or more or less then, or another varible>
                    // TODO
                    return false;
            }

            Crt.WriteLn("TODO: " + string.Join(" ", tokens));
            return false;
        }

        static private void LoadRefFile(string fileName)
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
                else if (LineTrimmed != "")
                {
                    CurrentSectionScript.Add(Line);
                }
            }

            // Store last open section in dictionary
            Sections.Add(CurrentSectionName, CurrentSectionScript.ToArray());

            _RefFiles.Add(Path.GetFileNameWithoutExtension(fileName), Sections);
        }

        static private void LoadRefFiles(string directoryName)
        {
            string[] RefFileNames = Directory.GetFiles(directoryName, "*.ref", SearchOption.TopDirectoryOnly);
            foreach (string RefFileName in RefFileNames)
            {
                LoadRefFile(RefFileName);
            }
        }

        static public void RunSection(string fileName, string sectionName)
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

        static private void RunScript(string[] script)
        {
            foreach (string Line in script)
            {
                string LineTrimmed = Line.Trim();
                
                // It's a command
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
                            //TODOreturn;
                            break;
                        case "@DISPLAYFILE": // @DISPLAYFILE <filename> <options> (options are NOPAUSE and NOSKIP, separated by space if both used)
                            // TODO As with WRITEFILE, don't allow for ..\..\blah
                            // TODO Handle variables as filename (ie `s02)
                            Crt.Write(FileUtils.FileReadAllText(StringUtils.PathCombine(ProcessUtils.StartupPath, Tokens[1])));
                            break;
                        case "@DO": // @DO has waaaaaay too many variants
                            HandleDO(Tokens);
                            break;
                        case "@END":
                            _InBEGINCount -= 1;
                            break;
                        case "@IF": // @IF <Varible> <Math> <Thing the varible must be, or more or less then, or another varible>  (Possible math functions: EQUALS, MORE, LESS, NOT)
                            if (HandleIF(Tokens))
                            {
                                // TODO Check to see if there's anything on the end of the line to process
                                // If there is, process it and don't do anything else
                                // If there isn't, set a flag indicating we want to process the following @BEGIN..@END block
                            }
                            else
                            {
                                // TODO Check to see if there's anything on the end of the line to process
                                // If there is, don't do anything else
                                // If there isn't, set a flag indicating we want to ignore the following @BEGIN..@END block
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
                            _InWRITEFILE = StringUtils.PathCombine(ProcessUtils.StartupPath, Tokens[1]);
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
                        Crt.Write(Line);
                        _InDOWrite = false;
                    }
                    else if (_InSHOW)
                    {
                        Crt.WriteLn(Line);
                    }
                    else if (_InWRITEFILE != "")
                    {
                        FileUtils.FileAppendAllText(_InWRITEFILE, Line + Environment.NewLine);
                    }
                }
            }
        }
    }
}
