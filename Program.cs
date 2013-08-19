using RandM.RMLib;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;

namespace LORD2
{
    class Program
    {
        static void Main(string[] args)
        {
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
            return false; // TODO
        }
    }
}
