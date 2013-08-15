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

        static RTReader()
        {
            // TODO Initialize stuff
            ParseRefFiles(ProcessUtils.StartupPath);
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

        static private void ParseRefFile(string fileName)
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

        static private void ParseRefFiles(string directoryName)
        {
            string[] RefFileNames = Directory.GetFiles(directoryName, "*.ref", SearchOption.TopDirectoryOnly);
            foreach (string RefFileName in RefFileNames)
            {
                ParseRefFile(RefFileName);
            }
        }
    }
}
