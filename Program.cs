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
                    DrawMap(155, 27, 7);
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

        static void DrawMap(int mapNumber, int x, int y)
        {
            // First determine which block in MAP.DAT the given map number is

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
