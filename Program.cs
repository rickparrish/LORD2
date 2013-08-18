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
            //RTReader.DisplayRefFileSections();
            RTReader.RunSection("RTNEWS02", "START");
            if (Debugger.IsAttached)
            {
                Crt.FastWrite(StringUtils.PadRight("Terminating...hit a key to quit", '\0', 80), 1, 25, 31);
                Crt.ReadKey();
            }
            Door.Shutdown();
        }
    }
}
