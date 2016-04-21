using RandM.RMLib;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;

namespace LORD2
{
    public static class Game
    {
        private static void DrawMap()
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
                    MAP_INFO MI = Global.CurrentMap.W[y + (x * 20)];

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

            // Draw the Global.Player
            DrawPlayer(Global.Player.X, Global.Player.Y);

            // TODO Draw other players
        }

        private static void DrawPlayer(int x, int y)
        {
            int OldPosition = (Global.Player.Y - 1) + ((Global.Player.X - 1) * 20);
            int NewPosition = (y - 1) + ((x - 1) * 20);

            // Erase the previous position
            Door.TextBackground(Global.CurrentMap.W[OldPosition].BackgroundColour);
            Door.TextColor(Global.CurrentMap.W[OldPosition].ForegroundColour);
            Door.GotoXY(Global.Player.X, Global.Player.Y);
            Door.Write(Global.CurrentMap.W[OldPosition].Character.ToString());

            // And draw the Global.Player
            Door.TextBackground(Global.CurrentMap.W[NewPosition].BackgroundColour);
            Door.TextColor(Crt.White);
            Door.GotoXY(x, y);
            Door.Write("\x02");

            // Store the last position for erasing later
            RTGlobal.LastX = Global.Player.X;
            RTGlobal.LastY = Global.Player.Y;
            Global.Player.X = (short)x;
            Global.Player.Y = (short)y;
        }

        private static void MoveBack()
        {
            // Update position and draw player
            DrawPlayer(RTGlobal.LastX, RTGlobal.LastY);
        }

        private static void MovePlayer(int xoffset, int yoffset)
        {
            int x = Global.Player.X + xoffset;
            int y = Global.Player.Y + yoffset;
            bool Moved = false;

            // Check for movement to a new screen
            if (x == 0)
            {
                Global.Player.Map -= 1;
                Global.Player.X = 80;
                // TODOX Rename Show to Hide to match Pascal version?
                if (Global.WorldDat.Show[Global.Player.Map] == 0) Global.Player.LastMap = Global.Player.Map;

                Global.LoadMap(Global.Player.Map);
                DrawMap();
            }
            else if (x == 81)
            {
                Global.Player.Map += 1;
                Global.Player.X = 1;
                // TODOX Rename Show to Hide to match Pascal version?
                if (Global.WorldDat.Show[Global.Player.Map] == 0) Global.Player.LastMap = Global.Player.Map;

                Global.LoadMap(Global.Player.Map);
                DrawMap();
            }
            else if (y == 0)
            {
                Global.Player.Map -= 80;
                Global.Player.Y = 20;
                // TODOX Rename Show to Hide to match Pascal version?
                if (Global.WorldDat.Show[Global.Player.Map] == 0) Global.Player.LastMap = Global.Player.Map;

                Global.LoadMap(Global.Player.Map);
                DrawMap();
            }
            else if (y == 21)
            {
                Global.Player.Map += 80;
                Global.Player.Y = 1;
                // TODOX Rename Show to Hide to match Pascal version?
                if (Global.WorldDat.Show[Global.Player.Map] == 0) Global.Player.LastMap = Global.Player.Map;

                Global.LoadMap(Global.Player.Map);
                DrawMap();
            }
            else
            {
                if (Global.CurrentMap.W[(y - 1) + ((x - 1) * 20)].Terrain == 1)
                {
                    DrawPlayer(x, y);
                    Moved = true;
                }
            }

            // Check for special
            bool Special = false;
            foreach (SPECIAL_STRUCT SS in Global.CurrentMap.Special)
            {
                if ((SS.HotSpotX == x) && (SS.HotSpotY == y))
                {
                    Special = true;

                    if ((SS.WarpMap > 0) && (SS.WarpX > 0) && (SS.WarpY > 0))
                    {
                        Global.Player.Map = SS.WarpMap;
                        Global.Player.X = SS.WarpX;
                        Global.Player.Y = SS.WarpY;
                        // TODOX Rename Show to Hide to match Pascal version?
                        if (Global.WorldDat.Show[Global.Player.Map] == 0) Global.Player.LastMap = Global.Player.Map;

                        Global.LoadMap(Global.Player.Map);
                        DrawMap();
                        break;
                    }
                    else if ((SS.RefFile != "") && (SS.RefName != ""))
                    {
                        RTReader RTR = new RTReader();
                        RTR.RunSection(SS.RefFile, SS.RefName);
                        break;
                    }
                }
            }

            // Check if need to run random event
            if (Moved && !Special && (Global.CurrentMap.BattleOdds > 0) && (Global.CurrentMap.BatFile != "") && (Global.CurrentMap.BatName != ""))
            {
                if (new Random().Next(Global.CurrentMap.BattleOdds) == 0)
                {
                    RTReader RTR = new RTReader();
                    RTR.RunSection(Global.CurrentMap.BatFile, Global.CurrentMap.BatName);
                }
            }
        }

        private static void RTR_OnDRAWMAP(object sender, System.EventArgs e)
        {
            DrawMap();
        }

        private static void RTR_OnMOVEBACK(object sender, System.EventArgs e)
        {
            DrawPlayer(RTGlobal.LastX, RTGlobal.LastY);
        }

        private static void RTR_OnUPDATE(object sender, System.EventArgs e)
        {
            // TODO Draw all Global.Players on this screen
        }

        private static void SavePlayer()
        {
            if (RTGlobal.PlayerNum != -1)
            {
                using (FileStream FS = new FileStream(Global.TraderDatFileName, FileMode.OpenOrCreate, FileAccess.Write))
                {
                    FS.Position = RTGlobal.PlayerNum * Marshal.SizeOf(typeof(TraderDatRecord));
                    DataStructures.WriteStruct<TraderDatRecord>(FS, Global.Player);
                }
            }
        }

        public static void Start()
        {
            // Ensure the platform/architecture we're running on has the right data type sizes
            DataStructures.Validate();

            // Load the game data files into memory
            Global.LoadDataFiles();

            // Initialize the RTReader engine
            RTReader RTR = new RTReader();
            RTGlobal.OnDRAWMAP += RTR_OnDRAWMAP;
            RTGlobal.OnMOVEBACK += RTR_OnMOVEBACK;
            RTGlobal.OnUPDATE += RTR_OnUPDATE;

            try
            {
                // TODOX Pascal did this -- needed?
                //Global.Player.RealName = Door.DropInfo.RealName;
                //Global.Player.LastDayOn = (short)RTGlobal.Time;
                //Global.Player.LastDayPlayed = RTGlobal.Time;
                //Global.Player.LastSaved = RTGlobal.Time;

                // Load the rules and run maint, if it's a new day
                RTR.RunSection("RULES.REF", "RULES");
                if (Global.IsNewDay) RTR.RunSection("MAINT.REF", "MAINT");

                // Check if user has a Global.Player already
                RTGlobal.PlayerNum = Global.LoadPlayerByRealName(Door.DropInfo.RealName, out Global.Player);
                if (RTGlobal.PlayerNum == -1)
                {
                    if (Global.TotalPlayerAccounts() < 200)
                    {
                        // Nope, so try to get them to create one
                        RTR.RunSection("GAMETXT.REF", "NEWPLAYER");
                        RTGlobal.PlayerNum = Global.LoadPlayerByRealName(Door.DropInfo.RealName, out Global.Player);
                    }
                    else
                    {
                        RTR.RunSection("GAMETXT.REF", "FULL");
                    }
                }

                // Now check again to see if the user has a Global.Player (either because they already had one, or because they just created one)
                if (RTGlobal.PlayerNum != -1)
                {
                    // Global.Player exists, so start the game
                    RTR.RunSection("GAMETXT.REF", "STARTGAME");

                    // We're now in map mode until we hit a hotspot
                    Global.LoadMap(Global.Player.Map);
                    DrawMap();

                    /*TODO W Write mail to another player
                        H Interact with another player.The player pressing this key must be on the
                            same map square as the player they are trying to interact with.
                        B Show the log of messages.
                        F Show the last three messages.
                        Q Quit the game.  Confirmation will be requested.*/
                    // Allow Global.Player to move around
                    char? Ch = null;
                    while (Ch != 'Q')
                    {
                        Ch = Door.ReadKey();
                        if (Ch != null)
                        {
                            Ch = char.ToUpper((char)Ch);
                            switch (Ch)
                            {
                                case Door.ExtendedKeys.UpArrow:
                                case '8':
                                    MovePlayer(0, -1);
                                    break;

                                case Door.ExtendedKeys.LeftArrow:
                                case '4':
                                    MovePlayer(-1, 0);
                                    break;

                                case Door.ExtendedKeys.RightArrow:
                                case '6':
                                    MovePlayer(1, 0);
                                    break;

                                case Door.ExtendedKeys.DownArrow:
                                case '2':
                                    MovePlayer(0, 1);
                                    break;

                                case 'L':
                                    RTR.RunSection("HELP", "LISTPLAYERS");
                                    break;

                                case 'M':
                                    RTR.RunSection("HELP", "MAP");
                                    break;

                                case 'P':
                                    RTR.RunSection("HELP", "WHOISON");
                                    break;

                                case 'Q':
                                    // Confirm exit
                                    Door.GotoXY(1, 23);
                                    Door.Write("`r0`2  Are you sure you want to quit back to the BBS? [`%Y`2] : ");

                                    bool KeepLooping = true;
                                    while (KeepLooping)
                                    {
                                        // Repeat until we have a valid selection
                                        Ch = Door.ReadKey();
                                        if (Ch != null)
                                        {
                                            Ch = char.ToUpper((char)Ch);
                                            switch (Ch)
                                            {
                                                case 'N':
                                                    Ch = null;
                                                    Door.GotoXY(1, 23);
                                                    Door.Write(StringUtils.PadRight("", ' ', 79));
                                                    Door.GotoXY(Global.Player.X, Global.Player.Y);
                                                    KeepLooping = false;
                                                    break;
                                                case '\r':
                                                case 'Y':
                                                    Ch = 'Q';
                                                    KeepLooping = false;
                                                    break;
                                            }
                                        }

                                    }
                                    break;

                                case 'T':
                                    RTR.RunSection("HELP", "TALK");
                                    break;

                                case 'V':
                                    RTR.RunSection("GAMETXT", "STATS");
                                    //TODOX ViewInventory();
                                    RTR.RunSection("GAMETXT", "CLOSESTATS");
                                    break;

                                case 'Y':
                                    RTR.RunSection("HELP", "YELL");
                                    break;

                                case 'Z':
                                    RTR.RunSection("HELP", "Z");
                                    break;

                                case '?':
                                    RTR.RunSection("HELP", "HELP");
                                    break;
                            }
                        }
                    }

                    // TODO Clear status bar and disable events so its not redrawn
                    RTR.RunSection("GAMETXT", "ENDGAME");
                    Thread.Sleep(2500);
                }
            }
            finally
            {
                // Ensure the player gets saved even if we run into an exception above
                SavePlayer();
            }
        }
    }
}
