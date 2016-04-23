// TODOX Create an RTVariables
using RandM.RMLib;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;

namespace LORD2
{
    public static class RTGlobal
    {
        // Events
        public static EventHandler OnDRAWMAP = null;
        public static EventHandler OnMOVEBACK = null;
        public static EventHandler OnUPDATE = null;

        // Ref files
        public static Dictionary<string, RTRefFile> RefFiles = new Dictionary<string, RTRefFile>(StringComparer.OrdinalIgnoreCase);

        // Other variables
        public static string ENEMY = "";
        public static string RESPONSE = "";
        public static int LastX = 0;
        public static int LastY = 0;
        public static int PlayerNum = -1;
        public static int Time = 0;
        public static int TotalAccounts = -1;

        private static Dictionary<string, int> _ImplementedCommandUsage = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
        private static Dictionary<string, int> _UnimplementedCommandUsage = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
        private static Dictionary<string, int> _UnknownCommandUsage = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
        private static Dictionary<string, int> _UnusedCommandUsage = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);

        static RTGlobal()
        {
            // Load all the ref files in the current directory
            string[] RefFileNames = Directory.GetFiles(ProcessUtils.StartupPath, "*.ref", SearchOption.TopDirectoryOnly);
            foreach (string RefFileName in RefFileNames)
            {
                LoadRefFile(RefFileName);
            }

            if (Debugger.IsAttached)
            {
                SaveCommandCSV(_ImplementedCommandUsage, "Implemented");
                SaveCommandCSV(_UnimplementedCommandUsage, "Unimplemented");
                SaveCommandCSV(_UnknownCommandUsage, "Unknown");
                SaveCommandCSV(_UnusedCommandUsage, "Unused");
                if ((_UnknownCommandUsage.Count > 0) || (_UnusedCommandUsage.Count > 0))
                {
                    Crt.WriteLn("Unknown commands used: " + _UnknownCommandUsage.Count.ToString());
                    Crt.WriteLn("Unused commands used: " + _UnusedCommandUsage.Count.ToString());
                    Crt.ReadKey();
                }
            }

            // Read-only variables
            RTVariables.Init();
        }

        private static void LoadRefFile(string fileName)
        {
            // A place to store all the sections found in this file
            RTRefFile NewFile = new RTRefFile(fileName);

            // Where to store the info for the section we're currently working on
            string NewSectionName = "_HEADER";
            RTRefSection NewSection = new RTRefSection(NewSectionName);

            // Loop through the file
            string[] Lines = FileUtils.FileReadAllLines(fileName, RMEncoding.Ansi);
            foreach (string Line in Lines)
            {
                string LineTrimmed = Line.Trim().ToUpper();

                // Check for new section
                if (LineTrimmed.StartsWith("@#"))
                {
                    // Store last section we were working on in dictionary
                    if (NewFile.Sections.ContainsKey(NewSectionName))
                    {
                        // Section already exists, so we can't add it
                        // CASTLE4 has multiple DONE sections
                        // STONEB has multiple NOTHING sections
                        // Both appear harmless, but keep that in mind if either ever seems buggy
                    }
                    else
                    {
                        NewFile.Sections.Add(NewSectionName, NewSection);
                    }

                    // Get new section name (presumes only one word headers allowed, trims @# off start) and reset script block
                    NewSectionName = Line.Trim().Split(' ')[0].Substring(2);
                    NewSection = new RTRefSection(NewSectionName);
                }
                else if (LineTrimmed.StartsWith("@LABEL "))
                {
                    NewSection.Script.Add(Line);

                    string[] Tokens = LineTrimmed.Split(' ');
                    NewSection.Labels.Add(Tokens[1].ToUpper(), NewSection.Script.Count - 1);
                }
                else if (LineTrimmed.StartsWith("@"))
                {
                    NewSection.Script.Add(Line);

                    #region Debug crap
                    //if (Debugger.IsAttached)
                    //{
                    //    // Also record command usage
                    //    string[] Tokens = LineTrimmed.Split(' ');
                    //    if (Tokens[0] == "@DO")
                    //    {
                    //        // Get the @DO command
                    //        string Command = string.Join(" ", Tokens);
                    //        string DOName = Command;
                    //        if (RTR._DOCommands.ContainsKey(Tokens[1]))
                    //        {
                    //            Command = Tokens[1];
                    //            DOName = "@DO " + Command;
                    //        }
                    //        else if ((Tokens.Length >= 3) && (RTR._DOCommands.ContainsKey(Tokens[2])))
                    //        {
                    //            Command = Tokens[2];
                    //            DOName = "@DO . " + Command;
                    //        }

                    //        // Determine if @DO command is known
                    //        if (RTR._DOCommands.ContainsKey(Command))
                    //        {
                    //            if (RTR._DOCommands[Command].Method.Name == "LogUnimplemented")
                    //            {
                    //                // Known, but not yet implemented
                    //                if (!_UnimplementedCommandUsage.ContainsKey(DOName)) _UnimplementedCommandUsage[DOName] = 0;
                    //                _UnimplementedCommandUsage[DOName] = _UnimplementedCommandUsage[DOName] + 1;
                    //            }
                    //            else if (RTR._DOCommands[Command].Method.Name == "LogUnused")
                    //            {
                    //                // Known, but not known to be used
                    //                if (!_UnusedCommandUsage.ContainsKey(DOName)) _UnusedCommandUsage[DOName] = 0;
                    //                _UnusedCommandUsage[DOName] = _UnusedCommandUsage[DOName] + 1;
                    //            }
                    //            else if (RTR._DOCommands[Command].Method.Name.StartsWith("Command"))
                    //            {
                    //                // Known and implemented
                    //                if (!_ImplementedCommandUsage.ContainsKey(DOName)) _ImplementedCommandUsage[DOName] = 0;
                    //                _ImplementedCommandUsage[DOName] = _ImplementedCommandUsage[DOName] + 1;
                    //            }
                    //            else
                    //            {
                    //                // Should never happen
                    //                Crt.WriteLn("What's up with this? " + string.Join(" ", Tokens));
                    //                Crt.ReadKey();
                    //            }
                    //        }
                    //        else
                    //        {
                    //            // Unknown
                    //            if (!_UnknownCommandUsage.ContainsKey(DOName)) _UnknownCommandUsage[DOName] = 0;
                    //            _UnknownCommandUsage[DOName] = _UnknownCommandUsage[DOName] + 1;
                    //        }
                    //    }
                    //    else if (Tokens[0] == "@IF")
                    //    {
                    //        // Get the @IF command
                    //        string Command = string.Join(" ", Tokens);
                    //        string IFName = Command;
                    //        if (RTR._IFCommands.ContainsKey(Tokens[1]))
                    //        {
                    //            Command = Tokens[1];
                    //            IFName = "@IF " + Command;
                    //        }
                    //        else if (RTR._IFCommands.ContainsKey(Tokens[2]))
                    //        {
                    //            Command = Tokens[2];
                    //            IFName = "@IF . " + Command;
                    //        }

                    //        // Determine if @IF command is known
                    //        if (RTR._IFCommands.ContainsKey(Command))
                    //        {
                    //            if (RTR._IFCommands[Command].Method.Name == "LogUnimplementedFunc")
                    //            {
                    //                // Known, but not yet implemented
                    //                if (!_UnimplementedCommandUsage.ContainsKey(IFName)) _UnimplementedCommandUsage[IFName] = 0;
                    //                _UnimplementedCommandUsage[IFName] = _UnimplementedCommandUsage[IFName] + 1;
                    //            }
                    //            else if (RTR._IFCommands[Command].Method.Name == "LogUnused")
                    //            {
                    //                // Known, but not known to be used
                    //                if (!_UnusedCommandUsage.ContainsKey(IFName)) _UnusedCommandUsage[IFName] = 0;
                    //                _UnusedCommandUsage[IFName] = _UnusedCommandUsage[IFName] + 1;
                    //            }
                    //            else if (RTR._IFCommands[Command].Method.Name.StartsWith("Command"))
                    //            {
                    //                // Known and implemented
                    //                if (!_ImplementedCommandUsage.ContainsKey(IFName)) _ImplementedCommandUsage[IFName] = 0;
                    //                _ImplementedCommandUsage[IFName] = _ImplementedCommandUsage[IFName] + 1;
                    //            }
                    //            else
                    //            {
                    //                // Should never happen
                    //                Crt.WriteLn("What's up with this? " + string.Join(" ", Tokens));
                    //                Crt.ReadKey();
                    //            }
                    //        }
                    //        else
                    //        {
                    //            // Unknown
                    //            if (!_UnknownCommandUsage.ContainsKey(IFName)) _UnknownCommandUsage[IFName] = 0;
                    //            _UnknownCommandUsage[IFName] = _UnknownCommandUsage[IFName] + 1;
                    //        }
                    //    }
                    //    else
                    //    {
                    //        if (RTR._Commands.ContainsKey(Tokens[0]))
                    //        {
                    //            if (RTR._Commands[Tokens[0]].Method.Name == "LogUnimplemented")
                    //            {
                    //                // Known, but not yet implemented
                    //                if (!_UnimplementedCommandUsage.ContainsKey(Tokens[0])) _UnimplementedCommandUsage[Tokens[0]] = 0;
                    //                _UnimplementedCommandUsage[Tokens[0]] = _UnimplementedCommandUsage[Tokens[0]] + 1;
                    //            }
                    //            else if (RTR._Commands[Tokens[0]].Method.Name == "LogUnused")
                    //            {
                    //                // Known, but not known to be used
                    //                if (!_UnusedCommandUsage.ContainsKey(Tokens[0])) _UnusedCommandUsage[Tokens[0]] = 0;
                    //                _UnusedCommandUsage[Tokens[0]] = _UnusedCommandUsage[Tokens[0]] + 1;
                    //            }
                    //            else if (RTR._Commands[Tokens[0]].Method.Name.StartsWith("Command"))
                    //            {
                    //                // Known and implemented
                    //                if (!_ImplementedCommandUsage.ContainsKey(Tokens[0])) _ImplementedCommandUsage[Tokens[0]] = 0;
                    //                _ImplementedCommandUsage[Tokens[0]] = _ImplementedCommandUsage[Tokens[0]] + 1;
                    //            }
                    //            else
                    //            {
                    //                // Should never happen
                    //                Crt.WriteLn("What's up with this? " + string.Join(" ", Tokens));
                    //                Crt.ReadKey();
                    //            }
                    //        }
                    //        else
                    //        {
                    //            // Unknown
                    //            if (!_UnknownCommandUsage.ContainsKey(Tokens[0])) _UnknownCommandUsage[Tokens[0]] = 0;
                    //            _UnknownCommandUsage[Tokens[0]] = _UnknownCommandUsage[Tokens[0]] + 1;
                    //        }
                    //    }
                    //}
                    #endregion
                }
                else
                {
                    NewSection.Script.Add(Line);
                }
            }

            // Store last section we were working on in dictionary
            if (NewFile.Sections.ContainsKey(NewSectionName))
            {
                // Section already exists, so we can't add it
                // CASTLE4 has multiple DONE sections
                // STONEB has multiple NOTHING sections
                // Both appear harmless, but keep that in mind if either ever seems buggy
            }
            else
            {
                NewFile.Sections.Add(NewSectionName, NewSection);
            }

            RefFiles.Add(Path.GetFileNameWithoutExtension(fileName), NewFile);
        }

        private static void SaveCommandCSV(Dictionary<string, int> commandUsage, string group)
        {
            string FileName = Global.GetSafeAbsolutePath("CommandUsage" + group + ".csv");

            try
            {
                // Delete old file
                FileUtils.FileDelete(FileName);

                // Save new file
                if (commandUsage.Count > 0)
                {
                    StringBuilder SB = new StringBuilder();
                    SB.AppendLine("Command,Uses");
                    foreach (KeyValuePair<string, int> KVP in commandUsage)
                    {
                        SB.Append(KVP.Key);
                        SB.Append(",");
                        SB.AppendLine(KVP.Value.ToString());
                    }
                    FileUtils.FileWriteAllText(FileName, SB.ToString());
                }
            }
            catch
            {
                Crt.WriteLn("Error saving " + FileName);
                Crt.ReadKey();
            }
        }
    }
}
