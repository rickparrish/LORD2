using RandM.RMLib;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;

namespace LORD2
{
    public static class RTGlobal
    {
        // Events
        public static EventHandler OnDRAWMAP = null;
        public static EventHandler OnMOVEBACK = null;
        public static EventHandler OnUPDATE = null;

        // Ref files
        public static Dictionary<string, RTRefFile> RefFiles = new Dictionary<string, RTRefFile>(StringComparer.OrdinalIgnoreCase);

        // Other variables
        public static Dictionary<string, RTVariable> Variables = new Dictionary<string, RTVariable>(StringComparer.OrdinalIgnoreCase);
        public static string ENEMY = "";
        public static string RESPONSE = "";
        public static int LastX = 0;
        public static int LastY = 0;
        public static int PlayerNum = -1;
        public static int Time = 0;
        public static int TotalAccounts = -1;

        private static Dictionary<string, int> _ImplementedCommandUsage = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
        private static Dictionary<string, int> _UnimplementedCommandUsage = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
        private static Dictionary<string, int> _UnknownCommandUsage = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
        private static Dictionary<string, int> _UnusedCommandUsage = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);

        static RTGlobal()
        {
            // Load all the ref files in the current directory
            string[] RefFileNames = Directory.GetFiles(ProcessUtils.StartupPath, "*.ref", SearchOption.TopDirectoryOnly);
            foreach (string RefFileName in RefFileNames)
            {
                LoadRefFile(RefFileName);
            }

            if (Debugger.IsAttached)
            {
                SaveCommandCSV(_ImplementedCommandUsage, "Implemented");
                SaveCommandCSV(_UnimplementedCommandUsage, "Unimplemented");
                SaveCommandCSV(_UnknownCommandUsage, "Unknown");
                SaveCommandCSV(_UnusedCommandUsage, "Unused");
                if ((_UnknownCommandUsage.Count > 0) || (_UnusedCommandUsage.Count > 0))
                {
                    Crt.WriteLn("Unknown commands used: " + _UnknownCommandUsage.Count.ToString());
                    Crt.WriteLn("Unused commands used: " + _UnusedCommandUsage.Count.ToString());
                    Crt.ReadKey();
                }
            }

            // Read-only variables
            Variables.Add("LOCAL", new RTVariable(GetVariableLOCAL, null));
            Variables.Add("NIL", new RTVariable(GetVariableNIL, null));
            Variables.Add("RESPONCE", new RTVariable(GetVariableRESPONCE, null));
            Variables.Add("RESPONSE", new RTVariable(GetVariableRESPONSE, null));

            // These are all TODOs (some need to be populated when something changes, some always need to be populated before using)
            // Variable symbols (ro) (Translated during @SHOW and @DO WRITE)
            Variables.Add("`C", new RTVariable(GetVariableBacktickC, null));
            Variables.Add("`D", new RTVariable(GetVariableBacktickD, null));
            Variables.Add("`E", new RTVariable(GetVariableBacktickE, null));
            Variables.Add("`G", new RTVariable(GetVariableBacktickG, null));
            // `K: Presents the more propmt and waits for ENTER to be pressed. (handled in Door.Write)
            // `L: About a half second wait. (handled in Door.Write)
            Variables.Add("`N", new RTVariable(GetVariableBacktickN, null));
            // `R0 to 1R7: change background color. (handled in Door.Write)
            // `W: One tenth a second wait. (handled in Door.Write)
            Variables.Add("`X", new RTVariable(GetVariableBacktickX, null));
            // `1 to `%: change color. (handled in Door.Write)
            Variables.Add("`\\", new RTVariable(GetVariableBacktickBackslash, null));
            Variables.Add("&realname", new RTVariable(GetVariableAmpersandRealName, null));
            Variables.Add("&date", new RTVariable(GetVariableAmpersandDate, null));
            Variables.Add("&nicedate", new RTVariable(GetVariableAmpersandNiceDate, null));
            Variables.Add("s&armour", new RTVariable(GetVariableAmpersandArmour, null));
            //TODO ReadOnlyVariables.Add("s&armour", "ARMOUR"); // equipped armour name.
            Variables.Add("s&arm_num", new RTVariable(GetVariableAmpersandArm_Num, null));
            //TODO ReadOnlyVariables.Add("s&arm_num", "0"); // equipped armour's defensive value
            Variables.Add("s&weapon", new RTVariable(GetVariableAmpersandWeapon, null));
            //TODO ReadOnlyVariables.Add("s&weapon", "WEAPON"); // equipped weapon name.
            Variables.Add("s&wep_num", new RTVariable(GetVariableAmpersandWep_Num, null));
            //TODO ReadOnlyVariables.Add("s&wep_num", "0"); // equipped weapon's attack value.
            Variables.Add("s&son", new RTVariable(GetVariableAmpersandSon, null));
            //TODO ReadOnlyVariables.Add("s&son", "SON"); // son/daughter, depending on current users sex
            Variables.Add("s&boy", new RTVariable(GetVariableAmpersandBoy, null));
            //TODO ReadOnlyVariables.Add("s&boy", "BOY"); // boy/girl, depending on current users sex
            Variables.Add("s&man", new RTVariable(GetVariableAmpersandMan, null));
            //TODO ReadOnlyVariables.Add("s&man", "MAN"); // man/lady, depending on current users sex
            Variables.Add("s&sir", new RTVariable(GetVariableAmpersandSir, null));
            //TODO ReadOnlyVariables.Add("s&sir", "SIR"); // sir/ma'am, depending on current users sex
            Variables.Add("s&him", new RTVariable(GetVariableAmpersandHim, null));
            //TODO ReadOnlyVariables.Add("s&him", "HIM"); // him/her, depending on current users sex
            Variables.Add("s&his", new RTVariable(GetVariableAmpersandHis, null));
            //TODO ReadOnlyVariables.Add("s&his", "HIS"); // his/her, depending on current users sex
            Variables.Add("&money", new RTVariable(GetVariableAmpersandMoney, null));
            //TODO ReadOnlyVariables.Add("&money", "0"); // current users gold
            Variables.Add("&bank", new RTVariable(GetVariableAmpersandBank, null));
            //TODO ReadOnlyVariables.Add("&bank", "0"); // current users gold in bank
            Variables.Add("&lastx", new RTVariable(GetVariableAmpersandLastX, null));
            //TODO ReadOnlyVariables.Add("&lastx", "27"); // users x position before last move.
            Variables.Add("&lasty", new RTVariable(GetVariableAmpersandLastY, null));
            //TODO ReadOnlyVariables.Add("&lasty", "7"); // users y position before last move - helpfull to determine which direction they came from before the hit the ref, etc.
            Variables.Add("&map", new RTVariable(GetVariableMap, null));
            //TODO ReadOnlyVariables.Add("&map", "155"); // current map #
            Variables.Add("&lmap", new RTVariable(GetVariableAmpersandLMap, null));
            //TODO ReadOnlyVariables.Add("&lmap", "155"); // last 'visible' map the player was on.
            Variables.Add("&time", new RTVariable(GetVariableAmpersandTime, null));
            //TODO ReadOnlyVariables.Add("&time", "1"); // current age of the game in days.
            Variables.Add("&timeleft", new RTVariable(GetVariableAmpersandTimeLeft, null));
            //TODO ReadOnlyVariables.Add("&timeleft", "60"); // minutes the user has left in the door.
            Variables.Add("&sex", new RTVariable(GetVariableAmpersandSex, null));
            //TODO ReadOnlyVariables.Add("&sex", "1"); // returns 0 if player is female, 1 if player is male
            Variables.Add("&playernum", new RTVariable(GetVariableAmpersandPlayerNum, null));
            //TODO ReadOnlyVariables.Add("&playernum", "0"); // the account # of the current player.
            Variables.Add("&totalaccounts", new RTVariable(GetVariableAmpersandTotalAccounts, null));
            //TODO ReadOnlyVariables.Add("&totalaccounts", "1"); // how many player accounts exist. Includes accounts marked deleted.

            // Language variables (rw) (Not translated during @SHOW or @DO WRITE)
            Variables.Add("BANK", new RTVariable(GetVariableBANK, SetVariableBANK));
            //TODO LanguageVariables.Add("BANK", "0"); // moola in bank
            Variables.Add("DEAD", new RTVariable(GetVariableDEAD, SetVariableDEAD));
            //TODO LanguageVariables.Add("DEAD", "0"); // 1 is player is dead
            Variables.Add("ENEMY", new RTVariable(GetVariableENEMY, SetVariableENEMY));
            //TODO LanguageVariables.Add("ENEMY", "0"); // force `e (last monster faught) to equal a certain name
            Variables.Add("MAP", new RTVariable(GetVariableMAP, SetVariableMAP));
            //TODO LanguageVariables.Add("MAP", "155"); // players current block #
            Variables.Add("MONEY", new RTVariable(GetVariableMONEY, SetVariableMONEY));
            //TODO LanguageVariables.Add("MONEY", "0"); // players moola
            Variables.Add("NARM", new RTVariable(GetVariableNARM, SetVariableNARM));
            //TODO LanguageVariables.Add("NARM", "0"); // current armour #
            Variables.Add("NWEP", new RTVariable(GetVariableNWEP, SetVariableNWEP));
            //TODO LanguageVariables.Add("NWEP", "0"); // current weapon #
            Variables.Add("SEXMALE", new RTVariable(GetVariableSEXMALE, SetVariableSEXMALE));
            //TODO LanguageVariables.Add("SEXMALE", "1"); // 1 if player is male
            Variables.Add("X", new RTVariable(GetVariableX, SetVariableX));
            //TODO LanguageVariables.Add("X", "27"); // players x cordinates
            Variables.Add("Y", new RTVariable(GetVariableY, SetVariableY));
            //TODO LanguageVariables.Add("Y", "7"); // players y cordinates
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

        private static void LoadRefFile(string fileName)
        {
            RTReader RTR = new RTReader();

            // A place to store all the sections found in this file
            RTRefFile NewFile = new RTRefFile(fileName);

            // Where to store the info for the section we're currently working on
            string NewSectionName = "_HEADER";
            RTRefSection NewSection = new RTRefSection(NewSectionName);

            // Loop through the file
            string[] Lines = FileUtils.FileReadAllLines(fileName, RMEncoding.Ansi);
            foreach (string Line in Lines)
            {
                string LineTrimmed = Line.Trim().ToUpper();

                // Check for new section
                if (LineTrimmed.StartsWith("@#"))
                {
                    // Store last section we were working on in dictionary
                    if (NewFile.Sections.ContainsKey(NewSectionName))
                    {
                        // Section already exists, so we can't add it
                        // CASTLE4 has multiple DONE sections
                        // STONEB has multiple NOTHING sections
                        // Both appear harmless, but keep that in mind if either ever seems buggy
                    }
                    else
                    {
                        NewFile.Sections.Add(NewSectionName, NewSection);
                    }

                    // Get new section name (presumes only one word headers allowed, trims @# off start) and reset script block
                    NewSectionName = Line.Trim().Split(' ')[0].Substring(2);
                    NewSection = new RTRefSection(NewSectionName);
                }
                else if (LineTrimmed.StartsWith("@LABEL "))
                {
                    NewSection.Script.Add(Line);

                    string[] Tokens = LineTrimmed.Split(' ');
                    NewSection.Labels.Add(Tokens[1].ToUpper(), NewSection.Script.Count - 1);
                }
                else if (LineTrimmed.StartsWith("@"))
                {
                    NewSection.Script.Add(Line);

                    if (Debugger.IsAttached)
                    {
                        // Also record command usage
                        string[] Tokens = LineTrimmed.Split(' ');
                        if (Tokens[0] == "@DO")
                        {
                            // Get the @DO command
                            string Command = string.Join(" ", Tokens);
                            string DOName = Command;
                            if (RTR._DOCommands.ContainsKey(Tokens[1]))
                            {
                                Command = Tokens[1];
                                DOName = "@DO " + Command;
                            }
                            else if ((Tokens.Length >= 3) && (RTR._DOCommands.ContainsKey(Tokens[2])))
                            {
                                Command = Tokens[2];
                                DOName = "@DO . " + Command;
                            }

                            // Determine if @DO command is known
                            if (RTR._DOCommands.ContainsKey(Command))
                            {
                                if (RTR._DOCommands[Command].Method.Name == "LogUnimplemented")
                                {
                                    // Known, but not yet implemented
                                    if (!_UnimplementedCommandUsage.ContainsKey(DOName)) _UnimplementedCommandUsage[DOName] = 0;
                                    _UnimplementedCommandUsage[DOName] = _UnimplementedCommandUsage[DOName] + 1;
                                }
                                else if (RTR._DOCommands[Command].Method.Name == "LogUnused")
                                {
                                    // Known, but not known to be used
                                    if (!_UnusedCommandUsage.ContainsKey(DOName)) _UnusedCommandUsage[DOName] = 0;
                                    _UnusedCommandUsage[DOName] = _UnusedCommandUsage[DOName] + 1;
                                }
                                else if (RTR._DOCommands[Command].Method.Name.StartsWith("Command"))
                                {
                                    // Known and implemented
                                    if (!_ImplementedCommandUsage.ContainsKey(DOName)) _ImplementedCommandUsage[DOName] = 0;
                                    _ImplementedCommandUsage[DOName] = _ImplementedCommandUsage[DOName] + 1;
                                }
                                else
                                {
                                    // Should never happen
                                    Crt.WriteLn("What's up with this? " + string.Join(" ", Tokens));
                                    Crt.ReadKey();
                                }
                            }
                            else
                            {
                                // Unknown
                                if (!_UnknownCommandUsage.ContainsKey(DOName)) _UnknownCommandUsage[DOName] = 0;
                                _UnknownCommandUsage[DOName] = _UnknownCommandUsage[DOName] + 1;
                            }
                        }
                        else if (Tokens[0] == "@IF")
                        {
                            // Get the @IF command
                            string Command = string.Join(" ", Tokens);
                            string IFName = Command;
                            if (RTR._IFCommands.ContainsKey(Tokens[1]))
                            {
                                Command = Tokens[1];
                                IFName = "@IF " + Command;
                            }
                            else if (RTR._IFCommands.ContainsKey(Tokens[2]))
                            {
                                Command = Tokens[2];
                                IFName = "@IF . " + Command;
                            }

                            // Determine if @IF command is known
                            if (RTR._IFCommands.ContainsKey(Command))
                            {
                                if (RTR._IFCommands[Command].Method.Name == "LogUnimplementedFunc")
                                {
                                    // Known, but not yet implemented
                                    if (!_UnimplementedCommandUsage.ContainsKey(IFName)) _UnimplementedCommandUsage[IFName] = 0;
                                    _UnimplementedCommandUsage[IFName] = _UnimplementedCommandUsage[IFName] + 1;
                                }
                                else if (RTR._IFCommands[Command].Method.Name == "LogUnused")
                                {
                                    // Known, but not known to be used
                                    if (!_UnusedCommandUsage.ContainsKey(IFName)) _UnusedCommandUsage[IFName] = 0;
                                    _UnusedCommandUsage[IFName] = _UnusedCommandUsage[IFName] + 1;
                                }
                                else if (RTR._IFCommands[Command].Method.Name.StartsWith("Command"))
                                {
                                    // Known and implemented
                                    if (!_ImplementedCommandUsage.ContainsKey(IFName)) _ImplementedCommandUsage[IFName] = 0;
                                    _ImplementedCommandUsage[IFName] = _ImplementedCommandUsage[IFName] + 1;
                                }
                                else
                                {
                                    // Should never happen
                                    Crt.WriteLn("What's up with this? " + string.Join(" ", Tokens));
                                    Crt.ReadKey();
                                }
                            }
                            else
                            {
                                // Unknown
                                if (!_UnknownCommandUsage.ContainsKey(IFName)) _UnknownCommandUsage[IFName] = 0;
                                _UnknownCommandUsage[IFName] = _UnknownCommandUsage[IFName] + 1;
                            }
                        }
                        else
                        {
                            if (RTR._Commands.ContainsKey(Tokens[0]))
                            {
                                if (RTR._Commands[Tokens[0]].Method.Name == "LogUnimplemented")
                                {
                                    // Known, but not yet implemented
                                    if (!_UnimplementedCommandUsage.ContainsKey(Tokens[0])) _UnimplementedCommandUsage[Tokens[0]] = 0;
                                    _UnimplementedCommandUsage[Tokens[0]] = _UnimplementedCommandUsage[Tokens[0]] + 1;
                                }
                                else if (RTR._Commands[Tokens[0]].Method.Name == "LogUnused")
                                {
                                    // Known, but not known to be used
                                    if (!_UnusedCommandUsage.ContainsKey(Tokens[0])) _UnusedCommandUsage[Tokens[0]] = 0;
                                    _UnusedCommandUsage[Tokens[0]] = _UnusedCommandUsage[Tokens[0]] + 1;
                                }
                                else if (RTR._Commands[Tokens[0]].Method.Name.StartsWith("Command"))
                                {
                                    // Known and implemented
                                    if (!_ImplementedCommandUsage.ContainsKey(Tokens[0])) _ImplementedCommandUsage[Tokens[0]] = 0;
                                    _ImplementedCommandUsage[Tokens[0]] = _ImplementedCommandUsage[Tokens[0]] + 1;
                                }
                                else
                                {
                                    // Should never happen
                                    Crt.WriteLn("What's up with this? " + string.Join(" ", Tokens));
                                    Crt.ReadKey();
                                }
                            }
                            else
                            {
                                // Unknown
                                if (!_UnknownCommandUsage.ContainsKey(Tokens[0])) _UnknownCommandUsage[Tokens[0]] = 0;
                                _UnknownCommandUsage[Tokens[0]] = _UnknownCommandUsage[Tokens[0]] + 1;
                            }
                        }
                    }
                }
                else
                {
                    NewSection.Script.Add(Line);
                }
            }

            // Store last section we were working on in dictionary
            if (NewFile.Sections.ContainsKey(NewSectionName))
            {
                // Section already exists, so we can't add it
                // CASTLE4 has multiple DONE sections
                // STONEB has multiple NOTHING sections
                // Both appear harmless, but keep that in mind if either ever seems buggy
            }
            else
            {
                NewFile.Sections.Add(NewSectionName, NewSection);
            }

            RefFiles.Add(Path.GetFileNameWithoutExtension(fileName), NewFile);
        }

        private static void SaveCommandCSV(Dictionary<string, int> commandUsage, string group)
        {
            string FileName = Global.GetSafeAbsolutePath("CommandUsage" + group + ".csv");

            try
            {
                // Delete old file
                FileUtils.FileDelete(FileName);

                // Save new file
                if (commandUsage.Count > 0)
                {
                    StringBuilder SB = new StringBuilder();
                    SB.AppendLine("Command,Uses");
                    foreach (KeyValuePair<string, int> KVP in commandUsage)
                    {
                        SB.Append(KVP.Key);
                        SB.Append(",");
                        SB.AppendLine(KVP.Value.ToString());
                    }
                    FileUtils.FileWriteAllText(FileName, SB.ToString());
                }
            }
            catch
            {
                Crt.WriteLn("Error saving " + FileName);
                Crt.ReadKey();
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
    }
}
