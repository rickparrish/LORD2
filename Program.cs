using RandM.RMLib;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;

namespace LORD2
{
    class Program
    {
        static private int _LastX = 27; // TODO
        static private int _LastY = 7; // TODO
        static private List<MapDatRecord> _MapDat = new List<MapDatRecord>();
        static private WorldDatRecord _WorldDat;

        static void Main(string[] args)
        {
            // Initialize door driver
            Door.Startup(args);
            Door.ClrScr();

            if (DataStructures.Validate())
            {
                if (LoadDataFiles())
                {
                    RTReader RTR = new RTReader();

                    // Check if user has a player already
                    bool PE = PlayerExists();

                    // Nope, so try to get them to create one
                    if (!PE) RTR.RunSection("GAMETXT.REF", "NEWPLAYER");

                    // Now check again to see if the user has a player (either because they already had one, or because they just created one)
                    if (PE || PlayerExists())
                    {
                        // Player exists, so start the game
                        RTR.RunSection("GAMETXT.REF", "STARTGAME");

                        // We're now in map mode until we hit a hotspot
                        DrawMap(155);
                        DrawPlayer(155, 27, 7);
                        Door.ReadKey();
                        DrawPlayer(155, 28, 7);
                        Door.ReadKey();
                        DrawPlayer(155, 28, 8);
                    }
                }
                else
                {
                    Door.WriteLn("ERROR: Unable to load data files.  Please inform your SysOp");
                    Door.WriteLn();
                    Door.WriteLn("Hit a key to quit");
                    Door.ReadKey();
                }
            }
            else
            {
                Door.WriteLn("ERROR: Data structure size mismatch.  Please inform your SysOp");
                Door.WriteLn();
                Door.WriteLn("Hit a key to quit");
                Door.ReadKey();
            }


            if (Debugger.IsAttached)
            {
                Crt.FastWrite(StringUtils.PadRight("Terminating...hit a key to quit", '\0', 80), 1, 25, 31);
                Crt.ReadKey();
            }

            Door.Shutdown();
        }

        static void DrawMap(int mapNumber)
        {
            // TODO Store MapDatRecord in private variable so we don't have to look up with each player movement
            
            // First use WORLD.DAT to determine which block in MAP.DAT the given map number is
            int MapBlockNumber = _WorldDat.Location[mapNumber - 1]; // 0 based map number

            // Then get the block from the MAP.DAT file
            MapDatRecord MDR = _MapDat[MapBlockNumber - 1]; // 0 based block number

            // Then draw the screen
            int BG = 0;
            int FG = 7;
            Door.TextAttr(7);
            Door.ClrScr();
            for (int y = 0; y < 20; y++)
            {
                for (int x = 0; x < 80; x++)
                {
                    MAP_INFO MI = MDR.W[y + (x * 20)];

                    if (BG != MI.BackgroundColour)
                    {
                        Door.TextBackground(MI.BackgroundColour);
                        BG = MI.BackgroundColour;
                    }
                    if (FG != MI.ForegroundColour)
                    {
                        Door.TextColor(MI.ForegroundColour);
                        FG = MI.ForegroundColour;
                    }
                    Door.Write(MI.Character.ToString());
                }
            }
        }

        static void DrawPlayer(int mapNumber, int x, int y)
        {
            // TODO Store MapDatRecord in private variable so we don't have to look up with each player movement

            // First use WORLD.DAT to determine which block in MAP.DAT the given map number is
            int MapBlockNumber = _WorldDat.Location[mapNumber - 1]; // 0 based map number

            // Then get the block from the MAP.DAT file
            MapDatRecord MDR = _MapDat[MapBlockNumber - 1]; // 0 based block number
            
            // Erase the previous position
            Door.TextBackground(MDR.W[(_LastY - 1) + ((_LastX - 1) * 20)].BackgroundColour);
            Door.TextColor(MDR.W[(_LastY - 1) + ((_LastX - 1) * 20)].ForegroundColour);
            Door.GotoXY(_LastX, _LastY);
            Door.Write(MDR.W[(_LastY - 1) + ((_LastX - 1) * 20)].Character.ToString());

            // And draw the player
            Door.TextBackground(MDR.W[(y - 1) + ((x - 1) * 20)].BackgroundColour);
            Door.TextColor(Crt.White);
            Door.GotoXY(x, y);
            Door.Write("\x02");

            // Store the last position for erasing later
            _LastX = x;
            _LastY = y;
        }

        static bool LoadDataFiles()
        {
            // Load MAP.DAT
            string MapDatFileName = StringUtils.PathCombine(ProcessUtils.StartupPath, "MAP.DAT"); // TODO Move filenames to another class as constants
            if (File.Exists(MapDatFileName))
            {
                using (FileStream FS = new FileStream(MapDatFileName, FileMode.Open))
                {
                    long FSLength = FS.Length;
                    while (FS.Position < FSLength)
                    {
                        _MapDat.Add(DataStructures.ReadStruct<MapDatRecord>(FS));
                    }
                }
            }
            else
            {
                return false;
            }

            // Load WORLD.DAT
            string WorldDatFileName = StringUtils.PathCombine(ProcessUtils.StartupPath, "WORLD.DAT"); // TODO Move filenames to another class as constants
            if (!File.Exists(WorldDatFileName))
            {
                // TODO Generate the file
            }
            if (File.Exists(WorldDatFileName))
            {
                using (FileStream FS = new FileStream(WorldDatFileName, FileMode.Open))
                {
                    _WorldDat = DataStructures.ReadStruct<WorldDatRecord>(FS);
                }
            }
            else
            {
                return false;
            }

            return true;
        }

        static bool PlayerExists()
        {
            string TraderDatFileName = StringUtils.PathCombine(ProcessUtils.StartupPath, "TRADER.DAT"); // TODO Move filenames to another class as constants
            if (File.Exists(TraderDatFileName))
            {
                using (FileStream FS = new FileStream(TraderDatFileName, FileMode.Open))
                {
                    long FSLength = FS.Length;
                    while (FS.Position < FSLength)
                    {
                        TraderDatRecord TDR = DataStructures.ReadStruct<TraderDatRecord>(FS);
                        if (TDR.RealName.ToUpper() == Door.DropInfo.Alias.ToUpper()) return true;
                    }
                }
            }

            // If we get here, user doesn't have an account yet
            return false;
        }
    }
}
