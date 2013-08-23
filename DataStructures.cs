// TODO Add structure for UPDATE.TMP
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

        public static bool Validate()
        {
            int IGM_DATASize = Marshal.SizeOf(typeof(IGM_DATA));
            if (IGM_DATASize != 1004)
            {
                Crt.WriteLn("IGM_DATA is " + IGM_DATASize + ", expected 1004");
                return false;
            }

            int ItemsDatRecordSize = Marshal.SizeOf(typeof(ItemsDatRecord));
            if (ItemsDatRecordSize != 204)
            {
                Crt.WriteLn("ItemsDatRecord is " + ItemsDatRecordSize + ", expected 204");
                return false;
            }

            int MAP_INFOSize = Marshal.SizeOf(typeof(MAP_INFO));
            if (MAP_INFOSize != 6)
            {
                Crt.WriteLn("MAP_INFO is " + MAP_INFOSize + ", expected 6");
                return false;
            }
            int SPECIAL_STRUCTSize = Marshal.SizeOf(typeof(SPECIAL_STRUCT));
            if (SPECIAL_STRUCTSize != 132)
            {
                Crt.WriteLn("SPECIAL_STRUCT is " + SPECIAL_STRUCTSize + ", expected 132");
                return false;
            }
            int MapDatRecordSize = Marshal.SizeOf(typeof(MapDatRecord));
            if (MapDatRecordSize != 11451)
            {
                Crt.WriteLn("MapDatRecord is " + MapDatRecordSize + ", expected 11451");
                return false;
            }

            int TraderDatRecordSize = Marshal.SizeOf(typeof(TraderDatRecord));
            if (TraderDatRecordSize != 1193)
            {
                Crt.WriteLn("TraderDatRecord is " + TraderDatRecordSize + ", expected 1193");
                return false;
            }


            int WorldDatRecordSize = Marshal.SizeOf(typeof(WorldDatRecord));
            if (WorldDatRecordSize != 6231)
            {
                Crt.WriteLn("WorldDatRecord is " + WorldDatRecordSize + ", expected 6231");
                return false;
            }
            return true;
        }

        public static void WriteStruct<T>(Stream stream, object record) where T : struct
        {
            var sz = Marshal.SizeOf(typeof(T));
            var buffer = new byte[sz];
            var pinnedBuffer = GCHandle.Alloc(buffer, GCHandleType.Pinned);
            Marshal.StructureToPtr(record, pinnedBuffer.AddrOfPinnedObject(), false);
            stream.Write(buffer, 0, sz);
            pinnedBuffer.Free();
        }
    }

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi, Pack = 1)]
    public struct IGM_DATA
    {
        public Int32 LastUsed;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 200)]
        public Int32[] Data;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 200)]
        public Char[] Extra;
    }

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi, Pack = 1)]
    public struct ItemsDatRecord
    {
        private Byte _NameLength;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 30)]
        private Byte[] _Name;
        private Byte _ActionLength;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 40)]
        private Byte[] _Action; // String for hitting someone with it
        private Byte _UseOnce;
        private Byte _Armour;
        private Byte _Weapon;
        private Byte _Sell;
        private Byte _Used;
        public Int32 Value; // Gold value
        public Int16 Breakage; // Percent breakage per use
        public Int16 MaxBuy; // Unused for now
        public Int16 Defense; // Defense added when equipped
        public Int16 Strength; // Strength added when equipped
        public Int16 Eat; // Unused for now
        private Byte _RefNameLength;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 12)]
        private Byte[] _RefName; // Section in ITEMS.REF
        private Byte _UseActionLength;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 30)]
        private Byte[] _UseAction; // Text for using it with the .REF
        private Byte _DescriptionLength;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 30)]
        private Byte[] _Description; // Description of item that shows to the right
        private Byte _DontDrop; // True if item cannot be dropped (quest item)
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 37)]
        public Char[] Extra;

        public string Action
        {
            get
            {
                return RMEncoding.Ansi.GetString(_Action, 0, _ActionLength);
            }
            set
            {
                _ActionLength = (byte)Math.Min(value.Length, _Action.Length);
                RMEncoding.Ansi.GetBytes(value, 0, _ActionLength, _Action, 0);
            }
        }
        public bool Armour
        {
            get
            {
                return Convert.ToBoolean(_Armour);
            }
            set
            {
                _Armour = Convert.ToByte(value);
            }
        }
        public string Description
        {
            get
            {
                return RMEncoding.Ansi.GetString(_Description, 0, _DescriptionLength);
            }
            set
            {
                _DescriptionLength = (byte)Math.Min(value.Length, _Description.Length);
                RMEncoding.Ansi.GetBytes(value, 0, _DescriptionLength, _Description, 0);
            }
        }
        public bool DontDrop
        {
            get
            {
                return Convert.ToBoolean(_DontDrop);
            }
            set
            {
                _DontDrop = Convert.ToByte(value);
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
        public bool Sell
        {
            get
            {
                return Convert.ToBoolean(_Sell);
            }
            set
            {
                _Sell = Convert.ToByte(value);
            }
        }
        public string UseAction
        {
            get
            {
                return RMEncoding.Ansi.GetString(_UseAction, 0, _UseActionLength);
            }
            set
            {
                _UseActionLength = (byte)Math.Min(value.Length, _UseAction.Length);
                RMEncoding.Ansi.GetBytes(value, 0, _UseActionLength, _UseAction, 0);
            }
        }
        public bool UseOnce
        {
            get
            {
                return Convert.ToBoolean(_UseOnce);
            }
            set
            {
                _UseOnce = Convert.ToByte(value);
            }
        }
        public bool Used
        {
            get
            {
                return Convert.ToBoolean(_Used);
            }
            set
            {
                _Used = Convert.ToByte(value);
            }
        }
        public bool Weapon
        {
            get
            {
                return Convert.ToBoolean(_Weapon);
            }
            set
            {
                _Weapon = Convert.ToByte(value);
            }
        }
    }

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi, Pack = 1)]
    public struct MAP_INFO
    {
        public SByte ForegroundColour;
        public SByte BackgroundColour;
        public Char Character;
        public Int16 T; // Unknown what this is
        public SByte Terrain; // 0 = unpassable, 1 = grass, 2 = rocky, 3 = water, 4 = ocean, 5 = forest
    }

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi, Pack = 1)]
    public struct SPECIAL_STRUCT
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
    public struct MapDatRecord
    {
        private Byte _NameLength;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 30)]
        private Byte[] _Name;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1600)]
        public MAP_INFO[] W;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 10)]
        public SPECIAL_STRUCT[] Special;
        public Int32 BattleOdds; // Odds of running the "screen random" ref
        private Byte _BatFileLength; // Ref file name
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 12)]
        private Byte[] _BatFile;
        private Byte _BatNameLength; // Ref file section header
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 12)]
        private Byte[] _BatName;
        private Byte _Safe; // True if players cannot fight on this screen
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
        public bool Safe
        {
            get
            {
                return Convert.ToBoolean(_Safe);
            }
            set
            {
                _Safe = Convert.ToByte(value);
            }
        }
    }

    // TODO Setters are untested
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi, Pack = 1)]
    public struct TraderDatRecord
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

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi, Pack = 1)]
    public struct WorldDatRecord
    {
        private Byte _NameLength;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 60)]
        private Byte[] _Name;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1600)]
        public Int16[] Location;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 40)]
        public Int32[] V;
        private Byte _S1Length;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 80)]
        private Byte[] _S1;
        private Byte _S2Length;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 80)]
        private Byte[] _S2;
        private Byte _S3Length;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 80)]
        private Byte[] _S3;
        private Byte _S4Length;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 80)]
        private Byte[] _S4;
        private Byte _S5Length;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 80)]
        private Byte[] _S5;
        private Byte _S6Length;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 80)]
        private Byte[] _S6;
        private Byte _S7Length;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 80)]
        private Byte[] _S7;
        private Byte _S8Length;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 80)]
        private Byte[] _S8;
        private Byte _S9Length;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 80)]
        private Byte[] _S9;
        private Byte _S10Length;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 80)]
        private Byte[] _S10;
        public Int32 Time; // Literally yyyy+mm+dd, ie 2013+08+20 = 2041
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1600)]
        public Byte[] Show; // Show up on the player's "auto map"?
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 396)]
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

        public string S1 { get { return RMEncoding.Ansi.GetString(_S1, 0, _S1Length); } }
        public string S2 { get { return RMEncoding.Ansi.GetString(_S2, 0, _S2Length); } }
        public string S3 { get { return RMEncoding.Ansi.GetString(_S3, 0, _S3Length); } }
        public string S4 { get { return RMEncoding.Ansi.GetString(_S4, 0, _S4Length); } }
        public string S5 { get { return RMEncoding.Ansi.GetString(_S5, 0, _S5Length); } }
        public string S6 { get { return RMEncoding.Ansi.GetString(_S6, 0, _S6Length); } }
        public string S7 { get { return RMEncoding.Ansi.GetString(_S7, 0, _S7Length); } }
        public string S8 { get { return RMEncoding.Ansi.GetString(_S8, 0, _S8Length); } }
        public string S9 { get { return RMEncoding.Ansi.GetString(_S9, 0, _S9Length); } }
        public string S10 { get { return RMEncoding.Ansi.GetString(_S10, 0, _S10Length); } }
    }
}
