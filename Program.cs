using RandM.RMLib;
using System;
using System.Collections.Generic;
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
            Crt.Write("Press any key to quit");
            Crt.ReadKey();
            Door.Shutdown();
        }
    }
}
