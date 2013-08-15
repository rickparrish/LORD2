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
            RTReader.ParseRefFiles(ProcessUtils.StartupPath);
            Console.WriteLine("Press any key to quit");
            Console.ReadKey();
        }
    }
}
