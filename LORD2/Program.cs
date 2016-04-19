// For Linux, requires mono-runtime and libmono2.0-cil (on Ubuntu 13.04 anyway)
using RandM.RMLib;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;

namespace LORD2
{
    class Program
    {
        private static RMDoor Door;

        static void Main(string[] args)
        {
            try
            {
                using (Door = new RMDoor())
                {
                    // TODOX I don't like this, but I do like the using to avoid stupidity leaks of not calling Door.Shutdown...maybe refactor to a try..finally though
                    Global.Door = Door;
                    RTGlobal.Door = Door;
                    RTReader.Door = Door;

                    if (!Debugger.IsAttached) Crt.HideCursor();

                    // Initialize door driver
                    Door.ClrScr();
                    Door.SethWrite = true;

                    if (DataStructures.Validate())
                    {
                        if (Global.LoadDataFiles())
                        {
                            RTReader RTR = new RTReader();

                            RTGlobal.OnDRAWMAP += RTR_OnDRAWMAP;
                            RTGlobal.OnMOVEBACK += RTR_OnMOVEBACK;
                            RTGlobal.OnUPDATE += RTR_OnUPDATE;

                            // Check if user has a Global.Player already
                            RTGlobal.PlayerNum = Global.LoadPlayerByRealName(Door.DropInfo.RealName, out Global.Player);
                            if (RTGlobal.PlayerNum == -1)
                            {
                                // Nope, so try to get them to create one
                                RTR.RunSection("GAMETXT.REF", "NEWPLAYER");
                                RTGlobal.PlayerNum = Global.LoadPlayerByRealName(Door.DropInfo.RealName, out Global.Player);
                            }

                            // Now check again to see if the user has a Global.Player (either because they already had one, or because they just created one)
                            if (RTGlobal.PlayerNum != -1)
                            {
                                // Global.Player exists, so start the game
                                RTR.RunSection("GAMETXT.REF", "STARTGAME");

                                // We're now in map mode until we hit a hotspot
                                Global.LoadMap(Global.Player.Map);
                                DrawMap();

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
                }
            }
            catch (Exception ex)
            {
                File.AppendAllText("ex.log", ex.ToString() + Environment.NewLine);
            }
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
        }

        static void DrawPlayer(int x, int y)
        {
            // Erase the previous position
            Door.TextBackground(Global.CurrentMap.W[(Global.Player.Y - 1) + ((Global.Player.X - 1) * 20)].BackgroundColour);
            Door.TextColor(Global.CurrentMap.W[(Global.Player.Y - 1) + ((Global.Player.X - 1) * 20)].ForegroundColour);
            Door.GotoXY(Global.Player.X, Global.Player.Y);
            Door.Write(Global.CurrentMap.W[(Global.Player.Y - 1) + ((Global.Player.X - 1) * 20)].Character.ToString());

            // And draw the Global.Player
            Door.TextBackground(Global.CurrentMap.W[(y - 1) + ((x - 1) * 20)].BackgroundColour);
            Door.TextColor(Crt.White);
            Door.GotoXY(x, y);
            Door.Write("\x02");

            // Store the last position for erasing later
            RTGlobal.LastX = Global.Player.X;
            RTGlobal.LastY = Global.Player.Y;
            Global.Player.X = (short)x;
            Global.Player.Y = (short)y;
        }

        static void MovePlayer(int xoffset, int yoffset)
        {
            int x = Global.Player.X + xoffset;
            int y = Global.Player.Y + yoffset;

            // Check for movement
            if (x == 0)
            {
                Global.Player.LastMap = Global.Player.Map; // TODO Only if map was visible, according to 3rdparty.doc
                Global.Player.Map -= 1;
                Global.Player.X = 80;

                Global.LoadMap(Global.Player.Map);
                DrawMap();
            }
            else if (x == 81)
            {
                Global.Player.LastMap = Global.Player.Map; // TODO Only if map was visible, according to 3rdparty.doc
                Global.Player.Map += 1;
                Global.Player.X = 1;

                Global.LoadMap(Global.Player.Map);
                DrawMap();
            }
            else if (y == 0)
            {
                Global.Player.LastMap = Global.Player.Map; // TODO Only if map was visible, according to 3rdparty.doc
                Global.Player.Map -= 80;
                Global.Player.Y = 20;

                Global.LoadMap(Global.Player.Map);
                DrawMap();
            }
            else if (y == 21)
            {
                Global.Player.LastMap = Global.Player.Map; // TODO Only if map was visible, according to 3rdparty.doc
                Global.Player.Map += 80;
                Global.Player.Y = 1;

                Global.LoadMap(Global.Player.Map);
                DrawMap();
            }
            else
            {
                if (Global.CurrentMap.W[(y - 1) + ((x - 1) * 20)].Terrain == 1)
                {
                    DrawPlayer(x, y);
                }
            }

            // Check for special
            foreach (SPECIAL_STRUCT SS in Global.CurrentMap.Special)
            {
                if ((SS.HotSpotX == x) && (SS.HotSpotY == y))
                {
                    if ((SS.WarpMap > 0) && (SS.WarpX > 0) && (SS.WarpY > 0))
                    {
                        Global.Player.LastMap = Global.Player.Map; // TODO Only if map was visible, according to 3rdparty.doc
                        Global.Player.Map = SS.WarpMap;
                        Global.Player.X = SS.WarpX;
                        Global.Player.Y = SS.WarpY;

                        Global.LoadMap(SS.WarpMap);
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
    }
}
