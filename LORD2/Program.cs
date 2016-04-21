// For Linux, requires mono-runtime and libmono2.0-cil (on Ubuntu 13.04 anyway)
using RandM.RMLib;
using System;
using System.Diagnostics;
using System.IO;

namespace LORD2
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                if (!Debugger.IsAttached) Crt.HideCursor();

                // Initialize door driver
                Door.Startup();
                Door.ClrScr();
                Door.SethWrite = true;

                Game.Start();

                if (Debugger.IsAttached)
                {
                    Crt.FastWrite(StringUtils.PadRight("Terminating...hit a key to quit", '\0', 80), 1, 25, 31);
                    Crt.ReadKey();
                }
            }
            catch (Exception ex)
            {
                FileUtils.FileAppendAllText(Global.GetSafeAbsolutePath("ex.log"), ex.ToString() + Environment.NewLine);
                Door.WriteLn();
                Door.WriteLn($"`4`b**`% ERROR : `2{ex.Message} `4`b**`2");
                Door.Write("Hit a key to quit");
                Door.ReadKey();
            }
            finally
            {
                Door.Shutdown();
            }
        }
    }
}
