using RandM.RMLib;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace LORD2
{
    public static class Global
    {
        public static string ItemsDatFileName = StringUtils.PathCombine(ProcessUtils.StartupPath, "ITEMS.DAT");
        public static string MapDatFileName = StringUtils.PathCombine(ProcessUtils.StartupPath, "MAP.DAT");
        public static string STimeDatFileName = StringUtils.PathCombine(ProcessUtils.StartupPath, "STIME.DAT");
        public static string TimeDatFileName = StringUtils.PathCombine(ProcessUtils.StartupPath, "TIME.DAT");
        public static string TraderDatFileName = StringUtils.PathCombine(ProcessUtils.StartupPath, "TRADER.DAT");
        public static string WorldDatFileName = StringUtils.PathCombine(ProcessUtils.StartupPath, "WORLD.DAT");

        public static MapDatRecord CurrentMap;
        public static List<ItemsDatRecord> ItemsDat = new List<ItemsDatRecord>();
        public static int LastX = 0;
        public static int LastY = 0;
        public static TraderDatRecord Player;
        public static List<MapDatRecord> MapDat = new List<MapDatRecord>();
        public static int STime = DateTime.Now.Year + DateTime.Now.Month + DateTime.Now.Day;
        public static WorldDatRecord WorldDat;

        public static string GetSafeAbsolutePath(string fileName)
        {
            string Result = "";

            try
            {
                // Get absolute path for the given relative path
                string SavedCurrentDirectory = Environment.CurrentDirectory;
                Environment.CurrentDirectory = ProcessUtils.StartupPath;
                string AbsoluteFileName = new FileInfo(fileName).FullName;
                Environment.CurrentDirectory = SavedCurrentDirectory;

                if (AbsoluteFileName.Contains(ProcessUtils.StartupPath)) Result = AbsoluteFileName;
            }
            catch
            {
                // Ignore, we'll return the default ""
            }

            return "";
        }

        public static bool LoadDataFiles()
        {
            // Load ITEMS.DAT
            if (File.Exists(Global.ItemsDatFileName))
            {
                using (FileStream FS = new FileStream(Global.ItemsDatFileName, FileMode.Open))
                {
                    long FSLength = FS.Length;
                    while (FS.Position < FSLength)
                    {
                        ItemsDat.Add(DataStructures.ReadStruct<ItemsDatRecord>(FS));
                    }
                }

                // Assign global PLUS values
                for (int i = 0; i < ItemsDat.Count; i++)
                {
                    RTGlobal.PLUS["`+" + StringUtils.PadLeft((i + 1).ToString(), '0', 2)] = ItemsDat[i].Name;
                }
            }
            else
            {
                return false;
            }

            // Load MAP.DAT
            if (File.Exists(Global.MapDatFileName))
            {
                using (FileStream FS = new FileStream(Global.MapDatFileName, FileMode.Open))
                {
                    long FSLength = FS.Length;
                    while (FS.Position < FSLength)
                    {
                        MapDat.Add(DataStructures.ReadStruct<MapDatRecord>(FS));
                    }
                }
            }
            else
            {
                return false;
            }

            // Load STIME.DAT
            bool IsNewDay = false;
            if (File.Exists(Global.STimeDatFileName))
            {
                if (Convert.ToInt32(FileUtils.FileReadAllText(Global.STimeDatFileName)) != STime) {
                    FileUtils.FileWriteAllText(Global.STimeDatFileName, STime.ToString());
                    IsNewDay = true;
                }
            }
            else
            {
                IsNewDay = true;
                FileUtils.FileWriteAllText(Global.STimeDatFileName, STime.ToString());
            }

            // Load TIME.DAT
            if (File.Exists(Global.TimeDatFileName))
            {
                int Time = Convert.ToInt32(FileUtils.FileReadAllText(Global.TimeDatFileName));
                if (IsNewDay) {
                    Time += 1;
                    FileUtils.FileWriteAllText(Global.TimeDatFileName, Time.ToString());
                }
                RTGlobal.ReadOnlyVariables["&time"] = Time.ToString();
            }
            else
            {
                FileUtils.FileWriteAllText(Global.TimeDatFileName, "1");
                RTGlobal.ReadOnlyVariables["&time"] = "1";
            }

            // Load WORLD.DAT
            if (!File.Exists(Global.WorldDatFileName))
            {
                // TODO Generate the file
            }
            if (File.Exists(Global.WorldDatFileName))
            {
                using (FileStream FS = new FileStream(Global.WorldDatFileName, FileMode.Open))
                {
                    WorldDat = DataStructures.ReadStruct<WorldDatRecord>(FS);

                    // Assign global S values
                    RTGlobal.S["`S1"] = WorldDat.S1;
                    RTGlobal.S["`S2"] = WorldDat.S2;
                    RTGlobal.S["`S3"] = WorldDat.S3;
                    RTGlobal.S["`S4"] = WorldDat.S4;
                    RTGlobal.S["`S5"] = WorldDat.S5;
                    RTGlobal.S["`S6"] = WorldDat.S6;
                    RTGlobal.S["`S7"] = WorldDat.S7;
                    RTGlobal.S["`S8"] = WorldDat.S8;
                    RTGlobal.S["`S9"] = WorldDat.S9;
                    RTGlobal.S["`S10"] = WorldDat.S10;

                    // Assign global V values
                    for (int i = 0; i < WorldDat.V.Length; i++)
                    {
                        RTGlobal.V["`V" + StringUtils.PadLeft((i + 1).ToString(), '0', 2)] = WorldDat.V[i];
                    }
                }
            }
            else
            {
                return false;
            }

            // Run maintenance, if required
            if (IsNewDay)
            {
                // This will create a new LOGNOW.TXT and L2TREE.DAT (amongst other things)
                RTReader RTR = new RTReader();
                RTR.RunSection("MAINT.REF", "MAINT"); 
            }

            return true;
        }

        public static void LoadMap(int mapNumber)
        {
            // First use WORLD.DAT to determine which block in MAP.DAT the given map number is
            int MapBlockNumber = WorldDat.Location[mapNumber - 1]; // 0 based array access

            // Then get the block from the MAP.DAT file
            CurrentMap = MapDat[MapBlockNumber - 1]; // 0 based array access
        }

        public static bool LoadPlayer(out TraderDatRecord record)
        {
            if (File.Exists(Global.TraderDatFileName))
            {
                using (FileStream FS = new FileStream(Global.TraderDatFileName, FileMode.Open))
                {
                    long FSLength = FS.Length;
                    while (FS.Position < FSLength)
                    {
                        TraderDatRecord TDR = DataStructures.ReadStruct<TraderDatRecord>(FS);
                        if (TDR.RealName.ToUpper() == Door.DropInfo.Alias.ToUpper())
                        {
                            // Assign player I values
                            for (int i = 0; i < TDR.Item.Length; i++)
                            {
                                RTGlobal.I["`I" + StringUtils.PadLeft((i + 1).ToString(), '0', 2)] = TDR.Item[i];
                            }

                            // Assign player P values
                            for (int i = 0; i < TDR.P.Length; i++)
                            {
                                RTGlobal.P["`P" + StringUtils.PadLeft((i + 1).ToString(), '0', 2)] = TDR.P[i];
                            }

                            // Assign player T values
                            for (int i = 0; i < TDR.B.Length; i++)
                            {
                                RTGlobal.T["`T" + StringUtils.PadLeft((i + 1).ToString(), '0', 2)] = TDR.B[i];
                            }

                            record = TDR;
                            return true;
                        }
                    }
                }
            }

            // If we get here, user doesn't have an account yet
            record = new TraderDatRecord();
            return false;
        }
    }
}
