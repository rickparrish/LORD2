using RandM.RMLib;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;

namespace LORD2
{
    class Program
    {
        static private MapDatRecord _CurrentMap;
        static private int _LastX = 0;
        static private int _LastY = 0;
        static private TraderDatRecord _Player;
        static private List<MapDatRecord> _MapDat = new List<MapDatRecord>();
        static private RTReader _RTR;
        static private WorldDatRecord _WorldDat;

        static void Main(string[] args)
        {
            if (!Debugger.IsAttached) Crt.HideCursor();
            
            // Initialize door driver
            Door.Startup(args);
            Door.ClrScr();
            Door.SethWrite = true;

            if (DataStructures.Validate())
            {
                if (LoadDataFiles())
                {
                    _RTR = new RTReader();
                    _RTR.OnMoveBack += RTR_OnMoveBack;

                    // Check if user has a player already
                    bool PlayerLoaded = LoadPlayer(out _Player);
                    if (!PlayerLoaded)
                    {
                        // Nope, so try to get them to create one
                        _RTR.RunSection("GAMETXT.REF", "NEWPLAYER");
                        PlayerLoaded = LoadPlayer(out _Player);
                    }

                    // Now check again to see if the user has a player (either because they already had one, or because they just created one)
                    if (PlayerLoaded)
                    {
                        // Player exists, so start the game
                        _RTR.RunSection("GAMETXT.REF", "STARTGAME");

                        // We're now in map mode until we hit a hotspot
                        LoadMap(_Player.Map);
                        DrawMap();

                        // Allow player to move around
                        char? Ch = null;
                        while (Ch != 'Q')
                        {
                            Ch = Door.ReadKey();
                            if (Ch != null)
                            {
                                Ch = char.ToUpper((char)Ch);
                                switch (Ch)
                                {
                                    case '8': MovePlayer(0, -1); break;
                                    case '4': MovePlayer(-1, 0); break;
                                    case '6': MovePlayer(1, 0); break;
                                    case '2': MovePlayer(0, 1); break;
                                }
                            }
                        }
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

        static void DrawMap()
        {
            // Draw the map
            int BG = 0;
            int FG = 7;
            Door.TextAttr(7);
            Door.ClrScr();
            for (int y = 0; y < 20; y++)
            {
                StringBuilder ToSend = new StringBuilder();

                for (int x = 0; x < 80; x++)
                {
                    MAP_INFO MI = _CurrentMap.W[y + (x * 20)];

                    if (BG != MI.BackgroundColour)
                    {
                        ToSend.Append(Ansi.TextBackground(MI.BackgroundColour));
                        Crt.TextBackground(MI.BackgroundColour); // Gotta do this to ensure calls to Ansi.* work right
                        BG = MI.BackgroundColour;
                    }
                    if (FG != MI.ForegroundColour)
                    {
                        ToSend.Append(Ansi.TextColor(MI.ForegroundColour));
                        Crt.TextColor(MI.ForegroundColour); // Gotta do this to ensure calls to Ansi.* work right
                        FG = MI.ForegroundColour;
                    }
                    ToSend.Append(MI.Character.ToString());
                }

                Door.Write(ToSend.ToString());
            }

            // Draw the player
            DrawPlayer(_Player.X, _Player.Y);
        }

        static void DrawPlayer(int x, int y)
        {
            // Erase the previous position
            Door.TextBackground(_CurrentMap.W[(_Player.Y - 1) + ((_Player.X - 1) * 20)].BackgroundColour);
            Door.TextColor(_CurrentMap.W[(_Player.Y - 1) + ((_Player.X - 1) * 20)].ForegroundColour);
            Door.GotoXY(_Player.X, _Player.Y);
            Door.Write(_CurrentMap.W[(_Player.Y - 1) + ((_Player.X - 1) * 20)].Character.ToString());

            // And draw the player
            Door.TextBackground(_CurrentMap.W[(y - 1) + ((x - 1) * 20)].BackgroundColour);
            Door.TextColor(Crt.White);
            Door.GotoXY(x, y);
            Door.Write("\x02");

            // Store the last position for erasing later
            _LastX = _Player.X;
            _LastY = _Player.Y;
            _Player.X = (short)x;
            _Player.Y = (short)y;
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

        static void LoadMap(int mapNumber)
        {
            // First use WORLD.DAT to determine which block in MAP.DAT the given map number is
            int MapBlockNumber = _WorldDat.Location[mapNumber - 1]; // 0 based map number

            // Then get the block from the MAP.DAT file
            _CurrentMap = _MapDat[MapBlockNumber - 1]; // 0 based block number
        }

        static bool LoadPlayer(out TraderDatRecord record)
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
                        if (TDR.RealName.ToUpper() == Door.DropInfo.Alias.ToUpper())
                        {
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

        static void MovePlayer(int xoffset, int yoffset)
        {
            int x = _Player.X + xoffset;
            int y = _Player.Y + yoffset;

            // Check for passable
            if (_CurrentMap.W[(y - 1) + ((x - 1) * 20)].Terrain != 0)
            {
                DrawPlayer(x, y);
            }

            // Check for special
            foreach (SPECIAL_STRUCT SS in _CurrentMap.Special)
            {
                if ((SS.HotSpotX == x) && (SS.HotSpotY == y))
                {
                    if ((SS.WarpMap > 0) && (SS.WarpX > 0) && (SS.WarpY > 0))
                    {
                        _Player.LastMap = _Player.Map; // TODO Only if map was visible, according to 3rdparty.doc
                        _Player.Map = SS.WarpMap;
                        _Player.X = SS.WarpX;
                        _Player.Y = SS.WarpY;

                        LoadMap(SS.WarpMap);
                        DrawMap();
                        break;
                    }
                    else if ((SS.RefFile != "") && (SS.RefName != ""))
                    {
                        _RTR.RunSection(SS.RefFile, SS.RefName);
                        break;
                    }
                }
            }
        }

        private static void RTR_OnMoveBack(object sender, System.EventArgs e)
        {
            DrawPlayer(_LastX, _LastY);
        }
    }
}
