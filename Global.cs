using RandM.RMLib;
using System;
using System.Collections.Generic;
using System.Text;

namespace LORD2
{
    public static class Global
    {
        public static string MapDatFileName = StringUtils.PathCombine(ProcessUtils.StartupPath, "MAP.DAT");
        public static string TraderDatFileName = StringUtils.PathCombine(ProcessUtils.StartupPath, "TRADER.DAT");
        public static string WorldDatFileName = StringUtils.PathCombine(ProcessUtils.StartupPath, "WORLD.DAT");
    }
}
