using RandM.RMLib;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace LORD2
{
    public static class Global
    {
        public static string ItemsDatFileName = Global.GetSafeAbsolutePath("items.dat");
        public static string MapDatFileName = Global.GetSafeAbsolutePath("map.dat");
        public static string STimeDatFileName = Global.GetSafeAbsolutePath("stime.dat");
        public static string TimeDatFileName = Global.GetSafeAbsolutePath("time.dat");
        public static string TraderDatFileName = Global.GetSafeAbsolutePath("trader.dat");
        public static string UpdateTmpFileName = Global.GetSafeAbsolutePath("update.tmp");
        public static string WorldDatFileName = Global.GetSafeAbsolutePath("world.dat");

        public static MapDatRecord CurrentMap;
        public static List<ItemsDatRecord> ItemsDat = new List<ItemsDatRecord>();
        public static TraderDatRecord Player;
        public static List<MapDatRecord> MapDat = new List<MapDatRecord>();
        public static int STime = DateTime.Now.Year + DateTime.Now.Month + DateTime.Now.Day;
        public static WorldDatRecord WorldDat;

        public static string GetSafeAbsolutePath(string relativeFileName)
        {
            string Result = "";

            try
            {
                // Get absolute path for the given relative path
                string SavedCurrentDirectory = Environment.CurrentDirectory;
                Environment.CurrentDirectory = ProcessUtils.StartupPath;
                string AbsoluteFileName = new FileInfo(relativeFileName).FullName;
                Environment.CurrentDirectory = SavedCurrentDirectory;

                if (AbsoluteFileName.Contains(ProcessUtils.StartupPath))
                {
                    // Path is in the LORD2 directory (or a subdirectory), so lowercase the filename so we don't have mixed case usage (for Linux)
                    string Directory = Path.GetDirectoryName(AbsoluteFileName);
                    string FileName = Path.GetFileName(AbsoluteFileName).ToLower();
                    Result = StringUtils.PathCombine(Directory, FileName);
                }
            }
            catch
            {
                // Ignore, we'll return the default ""
            }

            return Result;
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
            }
            else
            {
                Door.WriteLn("Missing " + Global.ItemsDatFileName);
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
                Door.WriteLn("Missing " + Global.MapDatFileName);
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
                RTGlobal.Time = Convert.ToInt32(FileUtils.FileReadAllText(Global.TimeDatFileName));
                if (IsNewDay) {
                    RTGlobal.Time += 1;
                    FileUtils.FileWriteAllText(Global.TimeDatFileName, RTGlobal.Time.ToString());
                }
            }
            else
            {
                FileUtils.FileWriteAllText(Global.TimeDatFileName, "1");
                RTGlobal.Time = 1;
            }

            // Load WORLD.DAT
            if (!File.Exists(Global.WorldDatFileName))
            {
                // TODO Generate the file
                // TODO When this is implemented, remove world.dat from SupportFiles?
            }
            if (File.Exists(Global.WorldDatFileName))
            {
                using (FileStream FS = new FileStream(Global.WorldDatFileName, FileMode.Open))
                {
                    WorldDat = DataStructures.ReadStruct<WorldDatRecord>(FS);
                }
            }
            else
            {
                Door.WriteLn("Missing " + Global.WorldDatFileName);
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

        public static int LoadPlayerByGameName(string name, out TraderDatRecord record)
        {
            int PlayerNumber = 0;

            if (File.Exists(Global.TraderDatFileName))
            {
                using (FileStream FS = new FileStream(Global.TraderDatFileName, FileMode.Open))
                {
                    long FSLength = FS.Length;
                    while (FS.Position < FSLength)
                    {
                        PlayerNumber += 1;
                        TraderDatRecord TDR = DataStructures.ReadStruct<TraderDatRecord>(FS);
                        if (Door.StripSeth(TDR.Name.Trim().ToUpper()) == Door.StripSeth(name.Trim().ToUpper()))
                        {
                            record = TDR;
                            return PlayerNumber;
                        }
                    }
                }
            }

            // If we get here, user doesn't have an account yet
            record = new TraderDatRecord(true);
            return -1;
        }

        public static int LoadPlayerByPlayerNumber(int requestedPlayerNumber, out TraderDatRecord record)
        {
            int PlayerNumber = 0;

            if (File.Exists(Global.TraderDatFileName))
            {
                using (FileStream FS = new FileStream(Global.TraderDatFileName, FileMode.Open))
                {
                    long FSLength = FS.Length;
                    while (FS.Position < FSLength)
                    {
                        PlayerNumber += 1;
                        TraderDatRecord TDR = DataStructures.ReadStruct<TraderDatRecord>(FS);
                        if (PlayerNumber == requestedPlayerNumber)
                        {
                            record = TDR;
                            return PlayerNumber;
                        }
                    }
                }
            }

            // If we get here, user doesn't have an account yet
            record = new TraderDatRecord(true);
            return -1;
        }

        public static int LoadPlayerByRealName(string name, out TraderDatRecord record)
        {
            int PlayerNumber = 0;

            if (File.Exists(Global.TraderDatFileName))
            {
                using (FileStream FS = new FileStream(Global.TraderDatFileName, FileMode.Open))
                {
                    long FSLength = FS.Length;
                    while (FS.Position < FSLength)
                    {
                        PlayerNumber += 1;
                        TraderDatRecord TDR = DataStructures.ReadStruct<TraderDatRecord>(FS);
                        if (TDR.RealName.Trim().ToUpper() == name.Trim().ToUpper())
                        {
                            record = TDR;
                            return PlayerNumber;
                        }
                    }
                }
            }

            // If we get here, user doesn't have an account yet
            record = new TraderDatRecord(true);
            return -1;
        }
    }
}
