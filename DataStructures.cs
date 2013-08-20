using RandM.RMLib;
using System;
using System.IO;
using System.Runtime.InteropServices;

namespace LORD2
{
    // Taken from http://stackoverflow.com/questions/4159184/c-read-structures-from-binary-file
    public static class DataStructures
    {
        public static T ReadStruct<T>(Stream stream) where T : struct
        {
            var sz = Marshal.SizeOf(typeof(T));
            var buffer = new byte[sz];
            stream.Read(buffer, 0, sz);
            var pinnedBuffer = GCHandle.Alloc(buffer, GCHandleType.Pinned);
            var structure = (T)Marshal.PtrToStructure(pinnedBuffer.AddrOfPinnedObject(), typeof(T));
            pinnedBuffer.Free();
            return structure;
        }
    }

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi, Pack = 1)]
    internal struct MAP_INFO
    {
        public SByte ForegroundColour;
        public SByte BackgroundColour;
        public Char Character;
        public Int16 T; // Unknown what this is
        public SByte Terrain; // 0 = unpassable, 1 = grass, 2 = rocky, 3 = water, 4 = ocean, 5 = forest
    }

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi, Pack = 1)]
    internal struct SPECIAL_STRUCT
    {
        public Int16 WarpMap; // Map to warp to, 0 if not a warp
        public SByte HotSpotX; // x coord of hotspot, 0 if hotspot not used
        public SByte HotSpotY; // y coord of hotspot, 0 if hotspot not used
        public SByte WarpX; // x coord of warp destination, 0 if not a warp
        public SByte WarpY; // y coord of warp destination, 0 if not a warp
        private Byte _RefNameLength; // Ref file section header
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 12)]
        private Byte[] _RefName;
        private Byte _RefFileLength; // Ref file name
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 12)]
        private Byte[] _RefFile;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 100)]
        public Char[] Extra;

        public string RefFile
        {
            get
            {
                return RMEncoding.Ansi.GetString(_RefFile, 0, _RefFileLength);
            }
            set
            {
                _RefFileLength = (byte)Math.Min(value.Length, _RefFile.Length);
                RMEncoding.Ansi.GetBytes(value, 0, _RefFileLength, _RefFile, 0);
            }
        }
        public string RefName
        {
            get
            {
                return RMEncoding.Ansi.GetString(_RefName, 0, _RefNameLength);
            }
            set
            {
                _RefNameLength = (byte)Math.Min(value.Length, _RefName.Length);
                RMEncoding.Ansi.GetBytes(value, 0, _RefNameLength, _RefName, 0);
            }
        }
    }

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi, Pack = 1)]
    internal struct MapDatRecord
    {
        private Byte _NameLength;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 30)]
        private Byte[] _Name;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1600)]
        private MAP_INFO[] _W;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 10)]
        public SPECIAL_STRUCT[] Special;
        public Int32 BattleOdds; // Odds of running the "screen random" ref
        private Byte _BatFileLength; // Ref file name
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 12)]
        private Byte[] _BatFile;
        private Byte _BatNameLength; // Ref file section header
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 12)]
        private Byte[] _BatName;
        public Byte Safe; // True if players cannot fight on this screen TODO is bool OK?
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 469)]
        public Char[] Extra;

        public string BatFile
        {
            get
            {
                return RMEncoding.Ansi.GetString(_BatFile, 0, _BatFileLength);
            }
            set
            {
                _BatFileLength = (byte)Math.Min(value.Length, _BatFile.Length);
                RMEncoding.Ansi.GetBytes(value, 0, _BatFileLength, _BatFile, 0);
            }
        }
        public string BatName
        {
            get
            {
                return RMEncoding.Ansi.GetString(_BatName, 0, _BatNameLength);
            }
            set
            {
                _BatNameLength = (byte)Math.Min(value.Length, _BatName.Length);
                RMEncoding.Ansi.GetBytes(value, 0, _BatNameLength, _BatName, 0);
            }
        }
        public string Name
        {
            get
            {
                return RMEncoding.Ansi.GetString(_Name, 0, _NameLength);
            }
            set
            {
                _NameLength = (byte)Math.Min(value.Length, _Name.Length);
                RMEncoding.Ansi.GetBytes(value, 0, _NameLength, _Name, 0);
            }
        }
    }

    // TODO Setters are untested
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi, Pack = 1)]
    internal struct TraderDatRecord
    {
        private Byte _NameLength;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 25)]
        private Byte[] _Name;
        private Byte _RealNameLength;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 40)]
        private Byte[] _RealName;
        public Int32 Gold;
        public Int32 Bank;
        public Int32 Experience;
        public Int16 LastDayOn;
        public Int16 Love;
        public SByte WeaponNumber;
        public SByte ArmourNumber;
        private Byte _RaceLength;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 30)]
        private Byte[] _Race;
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
        public Byte[] B;
        public Int32 LastSaved;
        public Int32 LastDayPlayed;
        public Int16 LastMap; // last VISIBLE map player was on
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 354)]
        public Char[] Extra;

        public string Name
        {
            get
            {
                return RMEncoding.Ansi.GetString(_Name, 0, _NameLength);
            }
            set
            {
                _NameLength = (byte)Math.Min(value.Length, _Name.Length);
                RMEncoding.Ansi.GetBytes(value, 0, _NameLength, _Name, 0);
            }
        }
        public string Race
        {
            get
            {
                return RMEncoding.Ansi.GetString(_Race, 0, _RaceLength);
            }
            set
            {
                _RaceLength = (byte)Math.Min(value.Length, _Race.Length);
                RMEncoding.Ansi.GetBytes(value, 0, _RaceLength, _Race, 0);
            }
        }
        public string RealName
        {
            get
            {
                return RMEncoding.Ansi.GetString(_RealName, 0, _RealNameLength);
            }
            set
            {
                _RealNameLength = (byte)Math.Min(value.Length, _RealName.Length);
                RMEncoding.Ansi.GetBytes(value, 0, _RealNameLength, _RealName, 0);
            }
        }
    }
}
