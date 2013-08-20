using RandM.RMLib;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;

namespace LORD2
{
    class Program
    {
        static void Main(string[] args)
        {
            // Initialize door driver
            Door.Startup(args);
            Door.ClrScr();

            if (DataStructures.Validate())
            {
                RTReader RTR = new RTReader();
                if (PlayerExists())
                {
                    // Player exists, so start the game
                    RTR.RunSection("GAMETXT.REF", "STARTGAME");
                }
                else
                {
                    // Player does not exist, so run the new player routine
                    RTR.RunSection("GAMETXT.REF", "NEWPLAYER");

                    // Check if user created a player
                    if (PlayerExists()) RTR.RunSection("GAMETXT.REF", "STARTGAME");
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
