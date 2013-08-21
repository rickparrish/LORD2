using RandM.RMLib;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace LORD2
{
    public static class RTGlobal
    {
        // Events
        public static EventHandler OnDRAWMAP = null;
        public static EventHandler OnMOVEBACK = null;
        public static EventHandler OnUPDATE = null;

        // Ref files
        public static Dictionary<string, RTRFile> RefFiles = new Dictionary<string, RTRFile>(StringComparer.OrdinalIgnoreCase);

        // Variables
        public static Dictionary<string, Int16> I = new Dictionary<string, Int16>(StringComparer.OrdinalIgnoreCase);
        public static Dictionary<string, string> Other = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        public static Dictionary<string, Int32> P = new Dictionary<string, Int32>(StringComparer.OrdinalIgnoreCase);
        public static Dictionary<string, string> PLUS = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        public static Dictionary<string, string> S = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        public static Dictionary<string, byte> T = new Dictionary<string, byte>(StringComparer.OrdinalIgnoreCase);
        public static Dictionary<string, Int32> V = new Dictionary<string, Int32>(StringComparer.OrdinalIgnoreCase);
        public static Dictionary<string, string> Words = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

        static RTGlobal()
        {
            // Load all the ref files in the current directory
            string[] RefFileNames = Directory.GetFiles(ProcessUtils.StartupPath, "*.ref", SearchOption.TopDirectoryOnly);
            foreach (string RefFileName in RefFileNames)
            {
                LoadRefFile(RefFileName);
            }

            // Init global variables
            for (int i = 1; i <= 99; i++) I.Add("`I" + StringUtils.PadLeft(i.ToString(), '0', 2), 0);
            for (int i = 1; i <= 99; i++) P.Add("`P" + StringUtils.PadLeft(i.ToString(), '0', 2), 0);
            for (int i = 1; i <= 99; i++) PLUS.Add("`+" + StringUtils.PadLeft(i.ToString(), '0', 2), "");
            for (int i = 1; i <= 10; i++) S.Add("`S" + StringUtils.PadLeft(i.ToString(), '0', 2), "");
            for (int i = 1; i <= 99; i++) T.Add("`T" + StringUtils.PadLeft(i.ToString(), '0', 2), 0);
            for (int i = 1; i <= 40; i++) V.Add("`V" + StringUtils.PadLeft(i.ToString(), '0', 2), 0);
            // TODO Some need to be tied to player variables?

            Other.Add("`N", Door.DropInfo.Alias);
            Other.Add("`E", "ENEMY"); // TODO
            Other.Add("`G", (Door.DropInfo.Emulation == DoorEmulationType.ANSI ? "3" : "0"));
            Other.Add("`X", " ");
            Other.Add("`D", "\x08");

            // TODO On all of these probably
            Words.Add("DEAD", "0");
            Words.Add("LOCAL", (Door.Local() ? "5" : "0"));
            Words.Add("MAP", "155");
            Words.Add("MONEY", "0");
            Words.Add("NIL", "");
            Words.Add("RESPONCE", "0");
            Words.Add("RESPONSE", "0");
            Words.Add("SEX", "0"); // Male
            Words.Add("SEXMALE", "1"); // True for male
            Words.Add("SON", "son"); // son or daughter?
            Words.Add("TIME", "1"); // Should be value from TIME.DAT, which is the number of days the game has been running
            Words.Add("WEP_NUM", "0");
            Words.Add("X", "27");
            Words.Add("Y", "7");
        }

        private static void LoadRefFile(string fileName)
        {
            // A place to store all the sections found in this file
            RTRFile NewFile = new RTRFile(fileName);

            // Where to store the info for the section we're currently working on
            string NewSectionName = "_HEADER";
            RTRSection NewSection = new RTRSection();

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
    }
}
