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
            using (FileStream FS = new FileStream(@"Z:\Programming\GameSrv\bin\Debug\doors\lord2\TRADER.DAT", FileMode.Open))
            {
                TraderDatRecord TDR = StreamExtensions.ReadStruct<TraderDatRecord>(FS);
                Crt.WriteLn("Name: " + TDR.Name);
                Crt.WriteLn("Real Name: " + TDR.RealName);
                Crt.WriteLn("Race: " + TDR.Race);
                return false;
            }
        }

        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi, Pack = 1)]
        internal struct TraderDatRecord
        {
            private byte _NameLength;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 25)]
            private byte[] _Name;
            private byte _RealNameLength;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 40)]
            private byte[] _RealName;
            public Int32 Gold;
            public Int32 Bank;
            public Int32 Experience;
            public Int16 LastDayOn;
            public Int16 Love;
            public SByte WeaponNumber;
            public SByte ArmourNumber;
            private byte _RaceLength;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 30)]
            private byte[] _Race;
            public Int16 SexMale; // 1 = male
            public Byte OnNow;
            public Byte Battle;
            public Int16 Dead; // 1 = dead
            public Int16 Busy;
            public Int16 Deleted; // 1 = deleted
            public Int16 Nice;
            public Int16 Map; // map block #
            public Int16 E6;
            public Int16 X;
            public Int16 Y;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 99)]
            public Int16[] Item;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 99)]
            public Int32[] P;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 99)]
            public byte[] B;
            public Int32 LastSaved;
            public Int32 LastDayPlayed;
            public Int16 LastMap; // last VISIBLE map player was on
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 354)]
            public char[] Extra;

            public string Name { get { return RMEncoding.Ansi.GetString(_Name, 0, _NameLength); } }
            public string Race { get { return RMEncoding.Ansi.GetString(_Race, 0, _RaceLength); } }
            public string RealName { get { return RMEncoding.Ansi.GetString(_RealName, 0, _RealNameLength); } }
        }
    }

    // Taken from http://stackoverflow.com/questions/4159184/c-read-structures-from-binary-file
    public static class StreamExtensions
    {
        public static T ReadStruct<T>(Stream stream) where T : struct
        {
            var sz = Marshal.SizeOf(typeof(T));
            var buffer = new byte[sz];
            stream.Read(buffer, 0, sz);
            var pinnedBuffer = GCHandle.Alloc(buffer, GCHandleType.Pinned);
            var structure = (T)Marshal.PtrToStructure(
                pinnedBuffer.AddrOfPinnedObject(), typeof(T));
            pinnedBuffer.Free();
            return structure;
        }
    }
}
