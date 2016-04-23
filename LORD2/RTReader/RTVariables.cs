using RandM.RMLib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace LORD2
{
    public class RTVariables
    {
        private static Dictionary<string, RTVariable> _Variables = new Dictionary<string, RTVariable>(StringComparer.OrdinalIgnoreCase);

        public RTVariable this[string key]
        {
            get { return _Variables[key]; }
        }

        private static string GetVariableRESPONCE(string input)
        {
            if (input.ToUpper() == "RESPONCE")
            {
                return RTGlobal.RESPONSE;
            }
            else
            {
                return input;
            }
        }

        private static string GetVariableRESPONSE(string input)
        {
            if (input.ToUpper() == "RESPONSE")
            {
                return RTGlobal.RESPONSE;
            }
            else
            {
                return input;
            }
        }

        private static string GetVariableNIL(string input)
        {
            return Regex.Replace(input, "NIL", "", RegexOptions.IgnoreCase);
        }

        private static string GetVariableLOCAL(string input)
        {
            if (input.ToUpper() == "LOCAL")
            {
                return (Door.Local ? "5" : "0");
            }
            else
            {
                return input;
            }
        }

        private static string GetVariableBacktickC(string input)
        {
            return Regex.Replace(input, "`C", Ansi.ClrScr() + "\r\n\r\n", RegexOptions.IgnoreCase);
        }

        private static string GetVariableBacktickD(string input)
        {
            return Regex.Replace(input, "`D", "\x08", RegexOptions.IgnoreCase);
        }

        private static string GetVariableBacktickE(string input)
        {
            return Regex.Replace(input, "`E", RTGlobal.ENEMY, RegexOptions.IgnoreCase);
        }

        private static string GetVariableBacktickG(string input)
        {
            return Regex.Replace(input, "`G", (Door.DropInfo.Emulation == DoorEmulationType.ANSI ? "3" : "0"), RegexOptions.IgnoreCase);
        }

        private static string GetVariableBacktickN(string input)
        {
            return Regex.Replace(input, "`N", Global.Player.Name, RegexOptions.IgnoreCase);
        }

        private static string GetVariableBacktickX(string input)
        {
            return Regex.Replace(input, "`X", " ", RegexOptions.IgnoreCase);
        }

        private static string GetVariableBacktickBackslash(string input)
        {
            return Regex.Replace(input, "`\\\\", "\r\n", RegexOptions.IgnoreCase);
        }

        private static string GetVariableAmpersandRealName(string input)
        {
            return Regex.Replace(input, "&realname", Door.DropInfo.RealName, RegexOptions.IgnoreCase);

        }

        private static string GetVariableAmpersandDate(string input)
        {
            return Regex.Replace(input, "&date", DateTime.Now.ToShortDateString(), RegexOptions.IgnoreCase);
        }

        private static string GetVariableAmpersandNiceDate(string input)
        {
            return Regex.Replace(input, "&nicedate", DateTime.Now.ToShortTimeString() + " on " + DateTime.Now.ToShortDateString(), RegexOptions.IgnoreCase);
        }

        private static string GetVariableAmpersandArmour(string input)
        {
            if (Global.Player.ArmourNumber == 0) return input;
            return Regex.Replace(input, "s&armour", Global.ItemsDat[Global.Player.ArmourNumber - 1].Name, RegexOptions.IgnoreCase);
        }

        private static string GetVariableAmpersandArm_Num(string input)
        {
            return Regex.Replace(input, "s&arm_num", Global.Player.ArmourNumber.ToString(), RegexOptions.IgnoreCase);
        }

        private static string GetVariableAmpersandWeapon(string input)
        {
            if (Global.Player.WeaponNumber == 0) return input;
            return Regex.Replace(input, "s&weapon", Global.ItemsDat[Global.Player.WeaponNumber - 1].Name, RegexOptions.IgnoreCase);
        }

        private static string GetVariableAmpersandWep_Num(string input)
        {
            return Regex.Replace(input, "s&wep_num", Global.Player.WeaponNumber.ToString(), RegexOptions.IgnoreCase);
        }

        private static string GetVariableAmpersandSon(string input)
        {
            return Regex.Replace(input, "s&son", (Global.Player.SexMale == 1) ? "son" : "daughter", RegexOptions.IgnoreCase);
        }

        private static string GetVariableAmpersandBoy(string input)
        {
            return Regex.Replace(input, "s&boy", (Global.Player.SexMale == 1) ? "boy" : "girl", RegexOptions.IgnoreCase);
        }

        private static string GetVariableAmpersandMan(string input)
        {
            return Regex.Replace(input, "s&man", (Global.Player.SexMale == 1) ? "man" : "lady", RegexOptions.IgnoreCase);
        }

        private static string GetVariableAmpersandSir(string input)
        {
            return Regex.Replace(input, "s&sir", (Global.Player.SexMale == 1) ? "sir" : "ma'am", RegexOptions.IgnoreCase);
        }

        private static string GetVariableAmpersandHim(string input)
        {
            return Regex.Replace(input, "s&him", (Global.Player.SexMale == 1) ? "him" : "her", RegexOptions.IgnoreCase);
        }

        private static string GetVariableAmpersandHis(string input)
        {
            return Regex.Replace(input, "s&his", (Global.Player.SexMale == 1) ? "his" : "hers", RegexOptions.IgnoreCase);
        }

        private static string GetVariableAmpersandMoney(string input)
        {
            return Regex.Replace(input, "&money", Global.Player.Gold.ToString(), RegexOptions.IgnoreCase);
        }

        private static string GetVariableAmpersandBank(string input)
        {
            return Regex.Replace(input, "&bank", Global.Player.Bank.ToString(), RegexOptions.IgnoreCase);
        }

        private static string GetVariableAmpersandLastX(string input)
        {
            return Regex.Replace(input, "&lastx", RTGlobal.LastX.ToString(), RegexOptions.IgnoreCase);
        }

        private static string GetVariableAmpersandLastY(string input)
        {
            return Regex.Replace(input, "&lasty", RTGlobal.LastY.ToString(), RegexOptions.IgnoreCase);
        }

        private static string GetVariableMap(string input)
        {
            return Regex.Replace(input, "&map", Global.Player.Map.ToString(), RegexOptions.IgnoreCase);
        }

        private static string GetVariableAmpersandLMap(string input)
        {
            return Regex.Replace(input, "&lmap", Global.Player.LastMap.ToString(), RegexOptions.IgnoreCase);
        }

        private static string GetVariableAmpersandTime(string input)
        {
            return Regex.Replace(input, "&time", RTGlobal.Time.ToString(), RegexOptions.IgnoreCase);
        }

        private static string GetVariableAmpersandTimeLeft(string input)
        {
            return Regex.Replace(input, "&timeleft", Math.Ceiling(Door.SecondsLeft / 60.0).ToString(), RegexOptions.IgnoreCase);
        }

        private static string GetVariableAmpersandSex(string input)
        {
            return Regex.Replace(input, "&sex", Global.Player.SexMale.ToString(), RegexOptions.IgnoreCase);
        }

        private static string GetVariableAmpersandPlayerNum(string input)
        {
            return Regex.Replace(input, "&playernum", RTGlobal.PlayerNum.ToString(), RegexOptions.IgnoreCase);
        }

        private static string GetVariableAmpersandTotalAccounts(string input)
        {
            return Regex.Replace(input, "&totalaccounts", RTGlobal.TotalAccounts.ToString(), RegexOptions.IgnoreCase);
        }

        private static string GetVariableBANK(string input)
        {
            if (input.ToUpper() == "BANK")
            {
                return Global.Player.Bank.ToString();
            }
            else
            {
                return input;
            }
        }

        private static string GetVariableDEAD(string input)
        {
            if (input.ToUpper() == "DEAD")
            {
                return Global.Player.Dead.ToString();
            }
            else
            {
                return input;
            }
        }

        private static string GetVariableENEMY(string input)
        {
            if (input.ToUpper() == "ENEMY")
            {
                return RTGlobal.ENEMY;
            }
            else
            {
                return input;
            }
        }

        private static string GetVariableMAP(string input)
        {
            if (input.ToUpper() == "MAP")
            {
                return Global.Player.Map.ToString();
            }
            else
            {
                return input;
            }
        }

        private static string GetVariableMONEY(string input)
        {
            if (input.ToUpper() == "MONEY")
            {
                return Global.Player.Gold.ToString();
            }
            else
            {
                return input;
            }
        }

        private static string GetVariableNARM(string input)
        {
            if (input.ToUpper() == "NARM")
            {
                return Global.Player.ArmourNumber.ToString();
            }
            else
            {
                return input;
            }
        }

        private static string GetVariableNWEP(string input)
        {
            if (input.ToUpper() == "NWEP")
            {
                return Global.Player.WeaponNumber.ToString();
            }
            else
            {
                return input;
            }
        }

        private static string GetVariableSEXMALE(string input)
        {
            if (input.ToUpper() == "SEXMALE")
            {
                return Global.Player.SexMale.ToString();
            }
            else
            {
                return input;
            }
        }
        private static string GetVariableX(string input)
        {
            if (input.ToUpper() == "X")
            {
                return Global.Player.X.ToString();
            }
            else
            {
                return input;
            }
        }

        private static string GetVariableY(string input)
        {
            if (input.ToUpper() == "Y")
            {
                return Global.Player.Y.ToString();
            }
            else
            {
                return input;
            }
        }

        public static void Init()
        {
            _Variables.Add("LOCAL", new RTVariable(GetVariableLOCAL, null));
            _Variables.Add("NIL", new RTVariable(GetVariableNIL, null));
            _Variables.Add("RESPONCE", new RTVariable(GetVariableRESPONCE, null));
            _Variables.Add("RESPONSE", new RTVariable(GetVariableRESPONSE, null));

            // These are all TODOs (some need to be populated when something changes, some always need to be populated before using)
            // Variable symbols (ro) (Translated during @SHOW and @DO WRITE)
            _Variables.Add("`C", new RTVariable(GetVariableBacktickC, null));
            _Variables.Add("`D", new RTVariable(GetVariableBacktickD, null));
            _Variables.Add("`E", new RTVariable(GetVariableBacktickE, null));
            _Variables.Add("`G", new RTVariable(GetVariableBacktickG, null));
            // `K: Presents the more propmt and waits for ENTER to be pressed. (handled in Door.Write)
            // `L: About a half second wait. (handled in Door.Write)
            _Variables.Add("`N", new RTVariable(GetVariableBacktickN, null));
            // `R0 to 1R7: change background color. (handled in Door.Write)
            // `W: One tenth a second wait. (handled in Door.Write)
            _Variables.Add("`X", new RTVariable(GetVariableBacktickX, null));
            // `1 to `%: change color. (handled in Door.Write)
            _Variables.Add("`\\", new RTVariable(GetVariableBacktickBackslash, null));
            _Variables.Add("&realname", new RTVariable(GetVariableAmpersandRealName, null));
            _Variables.Add("&date", new RTVariable(GetVariableAmpersandDate, null));
            _Variables.Add("&nicedate", new RTVariable(GetVariableAmpersandNiceDate, null));
            _Variables.Add("s&armour", new RTVariable(GetVariableAmpersandArmour, null));
            //TODO ReadOnlyVariables.Add("s&armour", "ARMOUR"); // equipped armour name.
            _Variables.Add("s&arm_num", new RTVariable(GetVariableAmpersandArm_Num, null));
            //TODO ReadOnlyVariables.Add("s&arm_num", "0"); // equipped armour's defensive value
            _Variables.Add("s&weapon", new RTVariable(GetVariableAmpersandWeapon, null));
            //TODO ReadOnlyVariables.Add("s&weapon", "WEAPON"); // equipped weapon name.
            _Variables.Add("s&wep_num", new RTVariable(GetVariableAmpersandWep_Num, null));
            //TODO ReadOnlyVariables.Add("s&wep_num", "0"); // equipped weapon's attack value.
            _Variables.Add("s&son", new RTVariable(GetVariableAmpersandSon, null));
            //TODO ReadOnlyVariables.Add("s&son", "SON"); // son/daughter, depending on current users sex
            _Variables.Add("s&boy", new RTVariable(GetVariableAmpersandBoy, null));
            //TODO ReadOnlyVariables.Add("s&boy", "BOY"); // boy/girl, depending on current users sex
            _Variables.Add("s&man", new RTVariable(GetVariableAmpersandMan, null));
            //TODO ReadOnlyVariables.Add("s&man", "MAN"); // man/lady, depending on current users sex
            _Variables.Add("s&sir", new RTVariable(GetVariableAmpersandSir, null));
            //TODO ReadOnlyVariables.Add("s&sir", "SIR"); // sir/ma'am, depending on current users sex
            _Variables.Add("s&him", new RTVariable(GetVariableAmpersandHim, null));
            //TODO ReadOnlyVariables.Add("s&him", "HIM"); // him/her, depending on current users sex
            _Variables.Add("s&his", new RTVariable(GetVariableAmpersandHis, null));
            //TODO ReadOnlyVariables.Add("s&his", "HIS"); // his/her, depending on current users sex
            _Variables.Add("&money", new RTVariable(GetVariableAmpersandMoney, null));
            //TODO ReadOnlyVariables.Add("&money", "0"); // current users gold
            _Variables.Add("&bank", new RTVariable(GetVariableAmpersandBank, null));
            //TODO ReadOnlyVariables.Add("&bank", "0"); // current users gold in bank
            _Variables.Add("&lastx", new RTVariable(GetVariableAmpersandLastX, null));
            //TODO ReadOnlyVariables.Add("&lastx", "27"); // users x position before last move.
            _Variables.Add("&lasty", new RTVariable(GetVariableAmpersandLastY, null));
            //TODO ReadOnlyVariables.Add("&lasty", "7"); // users y position before last move - helpfull to determine which direction they came from before the hit the ref, etc.
            _Variables.Add("&map", new RTVariable(GetVariableMap, null));
            //TODO ReadOnlyVariables.Add("&map", "155"); // current map #
            _Variables.Add("&lmap", new RTVariable(GetVariableAmpersandLMap, null));
            //TODO ReadOnlyVariables.Add("&lmap", "155"); // last 'visible' map the player was on.
            _Variables.Add("&time", new RTVariable(GetVariableAmpersandTime, null));
            //TODO ReadOnlyVariables.Add("&time", "1"); // current age of the game in days.
            _Variables.Add("&timeleft", new RTVariable(GetVariableAmpersandTimeLeft, null));
            //TODO ReadOnlyVariables.Add("&timeleft", "60"); // minutes the user has left in the door.
            _Variables.Add("&sex", new RTVariable(GetVariableAmpersandSex, null));
            //TODO ReadOnlyVariables.Add("&sex", "1"); // returns 0 if player is female, 1 if player is male
            _Variables.Add("&playernum", new RTVariable(GetVariableAmpersandPlayerNum, null));
            //TODO ReadOnlyVariables.Add("&playernum", "0"); // the account # of the current player.
            _Variables.Add("&totalaccounts", new RTVariable(GetVariableAmpersandTotalAccounts, null));
            //TODO ReadOnlyVariables.Add("&totalaccounts", "1"); // how many player accounts exist. Includes accounts marked deleted.

            // Language variables (rw) (Not translated during @SHOW or @DO WRITE)
            _Variables.Add("BANK", new RTVariable(GetVariableBANK, SetVariableBANK));
            //TODO LanguageVariables.Add("BANK", "0"); // moola in bank
            _Variables.Add("DEAD", new RTVariable(GetVariableDEAD, SetVariableDEAD));
            //TODO LanguageVariables.Add("DEAD", "0"); // 1 is player is dead
            _Variables.Add("ENEMY", new RTVariable(GetVariableENEMY, SetVariableENEMY));
            //TODO LanguageVariables.Add("ENEMY", "0"); // force `e (last monster faught) to equal a certain name
            _Variables.Add("MAP", new RTVariable(GetVariableMAP, SetVariableMAP));
            //TODO LanguageVariables.Add("MAP", "155"); // players current block #
            _Variables.Add("MONEY", new RTVariable(GetVariableMONEY, SetVariableMONEY));
            //TODO LanguageVariables.Add("MONEY", "0"); // players moola
            _Variables.Add("NARM", new RTVariable(GetVariableNARM, SetVariableNARM));
            //TODO LanguageVariables.Add("NARM", "0"); // current armour #
            _Variables.Add("NWEP", new RTVariable(GetVariableNWEP, SetVariableNWEP));
            //TODO LanguageVariables.Add("NWEP", "0"); // current weapon #
            _Variables.Add("SEXMALE", new RTVariable(GetVariableSEXMALE, SetVariableSEXMALE));
            //TODO LanguageVariables.Add("SEXMALE", "1"); // 1 if player is male
            _Variables.Add("X", new RTVariable(GetVariableX, SetVariableX));
            //TODO LanguageVariables.Add("X", "27"); // players x cordinates
            _Variables.Add("Y", new RTVariable(GetVariableY, SetVariableY));
            //TODO LanguageVariables.Add("Y", "7"); // players y cordinates
        }

        public static void SetVariable(string variable, string value)
        {
            // TODO Instead of translating before calling this function, maybe this function should translate and then
            //      other functions could pass in the raw string

            // See which variables to update
            string VariableUpper = variable.Trim().ToUpper();
            if (VariableUpper.StartsWith("`P"))
            {
                // Player longint
                Global.Player.P[Convert.ToInt32(VariableUpper.Replace("`P", "")) - 1] = Convert.ToInt32(value.Split(' ')[0]);
                return;
            }
            if (VariableUpper.StartsWith("`T"))
            {
                // Player byte
                Global.Player.T[Convert.ToInt32(VariableUpper.Replace("`T", "")) - 1] = Convert.ToByte(value.Split(' ')[0]);
                return;
            }
            if (VariableUpper.StartsWith("`S"))
            {
                // Global string
                Global.WorldDat.S[Convert.ToInt32(VariableUpper.Replace("`S", "")) - 1].Value = value;
                return;
            }
            if (VariableUpper.StartsWith("`V"))
            {
                // Global longint
                Global.WorldDat.V[Convert.ToInt32(VariableUpper.Replace("`V", "")) - 1] = Convert.ToInt32(value.Split(' ')[0]);
                return;
            }
            if (VariableUpper.StartsWith("`I"))
            {
                // Player int
                Global.Player.I[Convert.ToInt32(VariableUpper.Replace("`I", "")) - 1] = Convert.ToInt16(value.Split(' ')[0]);
                return;
            }
            if (VariableUpper.StartsWith("`+"))
            {
                // Global item name
                ItemsDatRecord IDR = Global.ItemsDat[Convert.ToInt32(VariableUpper.Replace("`+", "")) - 1];
                IDR.Name = value;
                Global.ItemsDat[Convert.ToInt32(VariableUpper.Replace("`+", "")) - 1] = IDR;
                return;
            }
            if (_Variables.ContainsKey(variable))
            {
                _Variables[variable].Set?.Invoke(value.Split(' ')[0]); // These variables only ever hold a single value, so anything after values[0] is likely a comment
                return;
            }
        }

        private static void SetVariableBANK(string value)
        {
            Global.Player.Bank = Convert.ToInt32(value);
        }

        private static void SetVariableDEAD(string value)
        {
            Global.Player.Dead = Convert.ToInt16(value);
        }

        private static void SetVariableENEMY(string value)
        {
            // TODO
        }

        private static void SetVariableMAP(string value)
        {
            Global.Player.Map = Convert.ToInt16(value);
        }

        private static void SetVariableMONEY(string value)
        {
            Global.Player.Gold = Convert.ToInt32(value);
        }

        private static void SetVariableNARM(string value)
        {
            Global.Player.ArmourNumber = Convert.ToSByte(value);
        }

        private static void SetVariableNWEP(string value)
        {
            Global.Player.WeaponNumber = Convert.ToSByte(value);
        }

        private static void SetVariableSEXMALE(string value)
        {
            Global.Player.SexMale = Convert.ToInt16(value);
        }

        private static void SetVariableX(string value)
        {
            Global.Player.X = Convert.ToInt16(value);
        }

        private static void SetVariableY(string value)
        {
            Global.Player.Y = Convert.ToInt16(value);
        }

        public static string TranslateVariables(string input)
        {
            // TODO commas get added to numbers (ie 123456 is 123,456)
            string inputUpper = input.ToUpper();

            if (input.Contains("`"))
            {
                if (inputUpper.Contains("`I"))
                {
                    for (int i = 0; i < Global.Player.I.Length; i++)
                    {
                        input = Regex.Replace(input, Regex.Escape("`I" + StringUtils.PadLeft((i + 1).ToString(), '0', 2)), Global.Player.I[i].ToString(), RegexOptions.IgnoreCase);
                    }
                }
                if (inputUpper.Contains("`P"))
                {
                    for (int i = 0; i < Global.Player.P.Length; i++)
                    {
                        input = Regex.Replace(input, Regex.Escape("`P" + StringUtils.PadLeft((i + 1).ToString(), '0', 2)), Global.Player.P[i].ToString(), RegexOptions.IgnoreCase);
                    }
                }
                if (inputUpper.Contains("`+"))
                {
                    for (int i = 0; i < Global.ItemsDat.Count; i++)
                    {
                        input = Regex.Replace(input, Regex.Escape("`+" + StringUtils.PadLeft((i + 1).ToString(), '0', 2)), Global.ItemsDat[i].Name, RegexOptions.IgnoreCase);
                    }
                }
                if (inputUpper.Contains("`S"))
                {
                    for (int i = 0; i < Global.WorldDat.S.Length; i++)
                    {
                        input = Regex.Replace(input, Regex.Escape("`S" + StringUtils.PadLeft((i + 1).ToString(), '0', 2)), Global.WorldDat.S[i].Value, RegexOptions.IgnoreCase);
                    }
                }
                if (inputUpper.Contains("`T"))
                {
                    for (int i = 0; i < Global.Player.T.Length; i++)
                    {
                        input = Regex.Replace(input, Regex.Escape("`T" + StringUtils.PadLeft((i + 1).ToString(), '0', 2)), Global.Player.T[i].ToString(), RegexOptions.IgnoreCase);
                    }
                }
                if (inputUpper.Contains("`V"))
                {
                    for (int i = 0; i < Global.WorldDat.V.Length; i++)
                    {
                        input = Regex.Replace(input, Regex.Escape("`V" + StringUtils.PadLeft((i + 1).ToString(), '0', 2)), Global.WorldDat.V[i].ToString(), RegexOptions.IgnoreCase);
                    }
                }
            }
            foreach (KeyValuePair<string, RTVariable> KVP in _Variables)
            {
                // Returns the original string if no translation is needed/required, or the translated string if keyword was found
                if (inputUpper.Contains(KVP.Key.ToUpper()))
                {
                    input = KVP.Value.Get(input);
                }
            }

            return input;
        }
    }
}
