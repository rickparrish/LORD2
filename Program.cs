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
            // Validate data structures
            int TraderDatRecordSize = Marshal.SizeOf(typeof(TraderDatRecord));
            if (TraderDatRecordSize != 1193)
            {
                Crt.WriteLn("TraderDatRecord is " + TraderDatRecordSize + ", expected 1193");
                Crt.ReadKey();
                return;
            }
            int MAP_INFOSize = Marshal.SizeOf(typeof(MAP_INFO));
            if (MAP_INFOSize != 6)
            {
                Crt.WriteLn("MAP_INFO is " + MAP_INFOSize + ", expected 6");
                Crt.ReadKey();
                return;
            }
            int SPECIAL_STRUCTSize = Marshal.SizeOf(typeof(SPECIAL_STRUCT));
            if (SPECIAL_STRUCTSize != 132)
            {
                Crt.WriteLn("SPECIAL_STRUCT is " + SPECIAL_STRUCTSize + ", expected 132");
                Crt.ReadKey();
                return;
            }
            int MapDatRecordSize = Marshal.SizeOf(typeof(MapDatRecord));
            if (MapDatRecordSize != 11451)
            {
                Crt.WriteLn("MapDatRecord is " + MapDatRecordSize + ", expected 11451");
                Crt.ReadKey();
                return;
            }

            // Initialize door driver
            Door.Startup(args);

            RTReader RTR = new RTReader();
            if (!PlayerExists()) RTR.RunSection("GAMETXT.REF", "NEWPLAYER");
            if (PlayerExists()) RTR.RunSection("GAMETXT.REF", "STARTGAME");

            if (Debugger.IsAttached)
            {
                Crt.FastWrite(StringUtils.PadRight("Terminating...hit a key to quit", '\0', 80), 1, 25, 31);
                Crt.ReadKey();
            }

            Door.Shutdown();
        }

        static bool PlayerExists()
        {
            // TODO Check if TRADER.DAT contains Door.DropInfo.Alias
            string TraderDatFileName = StringUtils.PathCombine(ProcessUtils.StartupPath, "TRADER.DAT");
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
