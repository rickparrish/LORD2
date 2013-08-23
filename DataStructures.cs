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

            int UpdateTmpRecordSize = Marshal.SizeOf(typeof(UpdateTmpRecord));
            if (UpdateTmpRecordSize != 7)
            {
                Crt.WriteLn("UpdateTmpRecord is " + UpdateTmpRecordSize + ", expected 7");
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

        public IGM_DATA(bool unused)
        {
            Data = new Int32[200];
            Extra = new Char[200];
            LastUsed = 0;
        }
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

        public ItemsDatRecord(bool unused)
        {
            _Action = new Byte[40];
            _ActionLength = 0;
            _Armour = 0;
            _Description = new Byte[30];
            _DescriptionLength = 0;
            _DontDrop = 0;
            _Name = new Byte[30];
            _NameLength = 0;
            _RefName = new Byte[12];
            _RefNameLength = 0;
            _Sell = 0;
            _UseAction = new Byte[30];
            _UseActionLength = 0;
            _Used = 0;
            _UseOnce = 0;
            _Weapon = 0;
            Breakage = 0;
            Defense = 0;
            Eat = 0;
            Extra = new Char[37];
            MaxBuy = 0;
            Strength = 0;
            Value = 0;
        }

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

        public MAP_INFO(bool unused)
        {
            BackgroundColour = 0;
            Character = '\0';
            ForegroundColour = 0;
            T = 0;
            Terrain = 0;
        }
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

        public SPECIAL_STRUCT(bool unused)
        {
            _RefFile = new Byte[12];
            _RefFileLength = 0;
            _RefName = new Byte[12];
            _RefNameLength = 0;
            Extra = new Char[100];
            HotSpotX = 0;
            HotSpotY = 0;
            WarpMap = 0;
            WarpX = 0;
            WarpY = 0;
        }

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

        public MapDatRecord(bool unused)
        {
            _BatFile = new Byte[12];
            _BatFileLength = 0;
            _BatName = new Byte[12];
            _BatNameLength = 0;
            _Name = new Byte[30];
            _NameLength = 0;
            _Safe = 0;
            BattleOdds = 0;
            Extra = new Char[469];
            Special = new SPECIAL_STRUCT[10];
            W = new MAP_INFO[1600];
        }

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
        public Int16[] I;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 99)]
        public Int32[] P;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 99)]
        public Byte[] T;
        public Int32 LastSaved;
        public Int32 LastDayPlayed;
        public Int16 LastMap; // last VISIBLE map player was on
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 354)]
        public Char[] Extra;

        public TraderDatRecord(bool unused)
        {
            _Name = new Byte[25];
            _NameLength = 0;
            _Race = new Byte[30];
            _RaceLength = 0;
            _RealName = new Byte[40];
            _RealNameLength = 0;
            ArmourNumber = 0;
            T = new Byte[99];
            Bank = 0;
            Battle = 0;
            Busy = 0;
            Dead = 0;
            Deleted = 0;
            E6 = 0;
            Experience = 0;
            Extra = new Char[354];
            Gold = 0;
            I = new Int16[99];
            LastDayOn = 0;
            LastDayPlayed = 0;
            LastMap = 155;
            LastSaved = 0;
            Love = 0;
            Map = 0;
            Nice = 0;
            OnNow = 0;
            P = new Int32[99];
            SexMale = 0;
            WeaponNumber = 0;
            X = 0;
            Y = 0;
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
    public struct UpdateTmpRecord
    {
        public SByte X;
        public SByte Y;
        public Int16 Map;
        public Byte OnNow;
        public Byte Busy;
        public Byte Battle;

        public UpdateTmpRecord(bool unused)
        {
            Battle = 0;
            Busy = 0;
            Map = 0;
            OnNow = 0;
            X = 0;
            Y = 0;
        }
    }

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi, Pack = 1)]
    public struct STRING80
    {
        private Byte _Length;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 80)]
        private Byte[] _Value;

        public STRING80(bool unused)
        {
            _Length = 0;
            _Value = new Byte[80];
        }

        public string Value
        {
            get
            {
                return RMEncoding.Ansi.GetString(_Value, 0, _Length);
            }
            set
            {
                _Length = (byte)Math.Min(value.Length, _Value.Length);
                RMEncoding.Ansi.GetBytes(value, 0, _Length, _Value, 0);
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
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 10)]
        public STRING80[] S;
        public Int32 Time; // Literally yyyy+mm+dd, ie 2013+08+20 = 2041
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1600)]
        public Byte[] Show; // Show up on the player's "auto map"?
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 396)]
        public Char[] Extra;

        public WorldDatRecord(bool unused)
        {
            _Name = new Byte[60];
            _NameLength = 0;
            S = new STRING80[10];
            Extra = new Char[396];
            Location = new Int16[1600];
            Show = new Byte[1600];
            Time = 0;
            V = new Int32[40];
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
}
