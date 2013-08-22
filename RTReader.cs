using RandM.RMLib;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;

namespace LORD2
{
    public class RTReader
    {
        private Dictionary<string, Action<string[]>> _Commands = new Dictionary<string, Action<string[]>>(StringComparer.OrdinalIgnoreCase);
        private Dictionary<string, Action<string[]>> _DOCommands = new Dictionary<string, Action<string[]>>(StringComparer.OrdinalIgnoreCase);

        private int _CurrentLineNumber = 0;
        private RTRFile _CurrentFile = null;
        private RTRSection _CurrentSection = null;
        private int _InBEGINCount = 0;
        private bool _InCHOICE = false;
        private List<RTChoiceOption> _InCHOICEOptions = new List<RTChoiceOption>();
        private bool _InCLOSESCRIPT = false;
        private bool _InDO_ADDLOG = false;
        private bool _InDO_WRITE = false;
        private int _InHALT = int.MinValue;
        private int _InIFFalse = 999;
        private bool _InSAY = false;
        private bool _InSAYBAR = false;
        private bool _InSHOW = false;
        private bool _InSHOWLOCAL = false;
        private bool _InSHOWSCROLL = false;
        private List<string> _InSHOWSCROLLLines = new List<string>();
        private string _InWRITEFILE = "";
        private Random _R = new Random();
        private int _Version = 99;

        public RTReader()
        {
            // Initialize the commands dictionary
            _Commands.Add("@ADDCHAR", CommandADDCHAR);
            _Commands.Add("@BEGIN", CommandBEGIN);
            _Commands.Add("@BITSET", CommandBITSET);
            _Commands.Add("@BUSY", CommandBUSY);
            _Commands.Add("@BUYMANAGER", CommandBUYMANAGER);
            _Commands.Add("@CHECKMAIL", CommandCHECKMAIL);
            _Commands.Add("@CHOICE", CommandCHOICE);
            _Commands.Add("@CHOOSEPLAYER", CommandCHOOSEPLAYER);
            _Commands.Add("@CLEARBLOCK", CommandCLEARBLOCK);
            _Commands.Add("@CLEAR", CommandCLEAR);
            _Commands.Add("@CLOSESCRIPT", CommandCLOSESCRIPT);
            _Commands.Add("@CONVERT_FILE_TO_ANSI", CommandCONVERT_FILE_TO_ANSI);
            _Commands.Add("@CONVERT_FILE_TO_ASCII", CommandCONVERT_FILE_TO_ASCII);
            _Commands.Add("@COPYFILE", CommandCOPYFILE);
            _Commands.Add("@DATALOAD", CommandDATALOAD);
            _Commands.Add("@DATANEWDAY", CommandDATANEWDAY);
            _Commands.Add("@DATASAVE", CommandDATASAVE);
            _Commands.Add("@DECLARE", CommandDECLARE);
            _Commands.Add("@DISPLAY", CommandDISPLAY);
            _Commands.Add("@DISPLAYFILE", CommandDISPLAYFILE);
            _Commands.Add("@DO", CommandDO);
            _Commands.Add("@DRAWMAP", CommandDRAWMAP);
            _Commands.Add("@DRAWPART", CommandDRAWPART);
            _Commands.Add("@END", CommandEND);
            _Commands.Add("@FIGHT", CommandFIGHT);
            _Commands.Add("@GRAPHICS", CommandGRAPHICS);
            _Commands.Add("@HALT", CommandHALT);
            _Commands.Add("@IF", CommandIF);
            _Commands.Add("@ITEMEXIT", CommandITEMEXIT);
            _Commands.Add("@KEY", CommandKEY);
            _Commands.Add("@LABEL", CommandLABEL);
            _Commands.Add("@LOADCURSOR", CommandLOADCURSOR);
            _Commands.Add("@LOADGLOBALS", CommandLOADGLOBALS);
            _Commands.Add("@LOADMAP", CommandLOADMAP);
            _Commands.Add("@LOADWORLD", CommandLOADWORLD);
            _Commands.Add("@LORDRANK", CommandLORDRANK);
            _Commands.Add("@MOREMAP", CommandMOREMAP);
            _Commands.Add("@NAME", CommandNAME);
            _Commands.Add("@NOCHECK", CommandNOCHECK);
            _Commands.Add("@OFFMAP", CommandOFFMAP);
            _Commands.Add("@OVERHEADMAP", CommandOVERHEADMAP);
            _Commands.Add("@PAUSEOFF", CommandPAUSEOFF);
            _Commands.Add("@PAUSEON", CommandPAUSEON);
            _Commands.Add("@PROGNAME", CommandPROGNAME);
            _Commands.Add("@RANK", CommandRANK);
            _Commands.Add("@READFILE", CommandREADFILE);
            _Commands.Add("@ROUTINE", CommandROUTINE);
            _Commands.Add("@RUN", CommandRUN);
            _Commands.Add("@SAVECURSOR", CommandSAVECURSOR);
            _Commands.Add("@SAVEGLOBALS", CommandSAVEGLOBALS);
            _Commands.Add("@SAVEWORLD", CommandSAVEWORLD);
            _Commands.Add("@SAY", CommandSAY);
            _Commands.Add("@SELLMANAGER", CommandSELLMANAGER);
            _Commands.Add("@SHOW", CommandSHOW);
            _Commands.Add("@SHOWLOCAL", CommandSHOWLOCAL);
            _Commands.Add("@STATBAR", CommandSTATBAR);
            _Commands.Add("@UPDATE", CommandUPDATE);
            _Commands.Add("@UPDATE_UPDATE", CommandUPDATE_UPDATE);
            _Commands.Add("@VERSION", CommandVERSION);
            _Commands.Add("@WHOISON", CommandWHOISON);
            _Commands.Add("@WRITEFILE", CommandWRITEFILE);

            // Initialize the @DO commands dictionary
            // @DO <COMMAND> COMMANDS
            _DOCommands.Add("ADDLOG", CommandDO_ADDLOG);
            _DOCommands.Add("BEEP", CommandDO_BEEP);
            _DOCommands.Add("COPYTONAME", CommandDO_COPYTONAME);
            _DOCommands.Add("DELETE", CommandDO_DELETE);
            _DOCommands.Add("FRONTPAD", CommandDO_FRONTPAD);
            _DOCommands.Add("GETKEY", CommandDO_GETKEY);
            _DOCommands.Add("GOTO", CommandDO_GOTO);
            _DOCommands.Add("MOVE", CommandDO_MOVE);
            _DOCommands.Add("MOVEBACK", CommandDO_MOVEBACK);
            _DOCommands.Add("NUMRETURN", CommandDO_NUMRETURN);
            _DOCommands.Add("PAD", CommandDO_PAD);
            _DOCommands.Add("QUEBAR", CommandDO_QUEBAR);
            _DOCommands.Add("READCHAR", CommandDO_READCHAR);
            _DOCommands.Add("READNUM", CommandDO_READNUM);
            _DOCommands.Add("READSPECIAL", CommandDO_READSPECIAL);
            _DOCommands.Add("READSTRING", CommandDO_READSTRING);
            _DOCommands.Add("REPLACE", CommandDO_REPLACE);
            _DOCommands.Add("REPLACEALL", CommandDO_REPLACEALL);
            _DOCommands.Add("RENAME", CommandDO_RENAME);
            _DOCommands.Add("SAYBAR", CommandDO_SAYBAR);
            _DOCommands.Add("STRIP", CommandDO_STRIP);
            _DOCommands.Add("STRIPALL", CommandDO_STRIPALL);
            _DOCommands.Add("STRIPBAD", CommandDO_STRIPBAD);
            _DOCommands.Add("STRIPCODE", CommandDO_STRIPCODE);
            _DOCommands.Add("TALK", CommandDO_TALK);
            _DOCommands.Add("TRIM", CommandDO_TRIM);
            _DOCommands.Add("UPCASE", CommandDO_UPCASE);
            _DOCommands.Add("WRITE", CommandDO_WRITE);
            // @DO <SOMETHING> <COMMAND> COMMANDS
            _DOCommands.Add("/", CommandDO_DIVIDE);
            _DOCommands.Add("*", CommandDO_MULTIPLY);
            _DOCommands.Add("+", CommandDO_ADD);
            _DOCommands.Add("-", CommandDO_SUBTRACT);
            _DOCommands.Add("ADD", CommandDO_ADD);
            _DOCommands.Add("IS", CommandDO_IS);
            _DOCommands.Add("RANDOM", CommandDO_RANDOM);
        }

        private void AssignVariable(string variable, string value)
        {
            // Split while we still have the raw input string (in case we're doing a LENGTH operation)
            string[] values = value.Split(' ');

            // Translate the input string
            value = TranslateVariables(value);

            // Check for LENGTH operator
            if ((values.Length == 2) && (values[1].StartsWith("`")))
            {
                if (values[0].ToUpper() == "LENGTH")
                {
                    /* @DO <number variable> IS LENGTH <String variable>
                        Gets length, smart way. */
                    values[0] = Door.StripSeth(TranslateVariables(values[1])).Length.ToString();
                }
                else if (values[0].ToUpper() == "REALLENGTH")
                {
                    /* @DO <number variable> IS REALLENGTH <String variable>
                        Gets length dumb way. (includes '`' codes without deciphering them.) */
                    values[0] = TranslateVariables(values[1]).Length.ToString();
                }
            }
            else
            {
                // Translate the first split input variable, which is still raw (and may be used by number variables below)
                values[0] = TranslateVariables(values[0]);
            }

            // See which variables to update
            if (RTGlobal.I.ContainsKey(variable))
            {
                RTGlobal.I[variable] = Convert.ToInt16(values[0]);
            }
            if (RTGlobal.P.ContainsKey(variable))
            {
                RTGlobal.P[variable] = Convert.ToInt32(values[0]);
            }
            if (RTGlobal.PLUS.ContainsKey(variable)) RTGlobal.PLUS[variable] = value;
            if (RTGlobal.S.ContainsKey(variable)) RTGlobal.S[variable] = value;
            if (RTGlobal.T.ContainsKey(variable))
            {
                RTGlobal.T[variable] = Convert.ToByte(values[0]);
            }
            if (RTGlobal.V.ContainsKey(variable))
            {
                RTGlobal.V[variable] = Convert.ToInt32(values[0]);
            }
            if (RTGlobal.LanguageVariables.ContainsKey(variable))
            {
                // TODO Depending on what got set here, other global variables may need to be set (ie is player dead, their x/y location, their map)
                // TODO Maybe they shouldn't be variables, and there should just be a long list of if variable == xyz assigning directly into the player record
                RTGlobal.LanguageVariables[variable] = values[0]; // These variables only ever hold a single value, so anything after values[0] is likely a comment
            }
        }

        private void CommandADDCHAR(string[] tokens)
        {
            /* @ADDCHAR
                This command adds a new character to the TRADER.DAT file.  This command is 
                used in the @#newplayer routine in gametxt.ref.  Make sure you do an 
                @READSTRING, @DO COPYTONAME, set appropriate variables including the player's 
                X and Y coordinates and map block number before issuing this command.  Failure 
                to do this can result in a corrupted TRADER.DAT file. */
            // TODO Add record to UPDATE.TMP and TRADER.DAT
            LogMissing(tokens);
        }

        private void CommandBEGIN(string[] tokens)
        {
            _InBEGINCount += 1;
        }

        private void CommandBITSET(string[] tokens)
        {
            /* @BITSET <`tX> <bit> <Y>
                Sets a certain bit in byte variable X to value Y.  Y must be 0 or 1.  This lets you 
                have 8 yes/no variables to each byte variable. */
            string VariableName = tokens[1];
            int StartValue = Convert.ToInt32(TranslateVariables(VariableName));
            int BitToSet = Convert.ToInt32(TranslateVariables(tokens[2]));
            int ValueToSet = Convert.ToInt32(TranslateVariables(tokens[3]));
            int EndValue = StartValue | (ValueToSet << BitToSet);
            AssignVariable(VariableName, EndValue.ToString());
        }

        private void CommandBUSY(string[] tokens)
        {
            /* @BUSY
                This makes the player appear 'red' to other players currently playing.  It 
                also tells the Lord II engine to run @#busy in gametxt.ref if a player logs on 
                and someone is attacking him or giving him an item. */
            LogMissing(tokens);
        }

        private void CommandBUYMANAGER(string[] tokens)
        {
            /* @BUYMANAGER
                <item number>
                <item number>
                <ect until next @ at beginning of string is hit>
                This command offers items for sale at the price set in items.dat */
            LogMissing(tokens);
        }

        private void CommandCHECKMAIL(string[] tokens)
        {
            /* @CHECKMAIL
                Undocumented.  Will need to determine what this does */
            LogMissing(tokens);
        }

        private void CommandCHOICE(string[] tokens)
        {
            /* @CHOICE
                <A choice>
                <another choice>
                <ect..When a @ is found in the beginning of a choice it quits>
                This gives the user a choice using a lightbar.
                The responce is put into varible RESPONCE.  This may also be spelled RESPONSE. 
                To set which choice the cursor starts on, put that number into `V01.
                ** EXAMPLE OF @CHOICE COMMAND **
                @DO `V01 IS 1 ;which choice should be highlighted when they start
                (now the actual choice command)
                @CHOICE
                Yes   <- Defaults to this, since it's 1
                No
                I don't know
                Who cares
                @IF RESPONCE IS 3 THEN DO
                  @BEGIN
                  @DO `P01 IS RESPONCE
                  @SHOW

                You chose `P01!, silly boy!

                  @END
                The choice command is more useful now; you can now define *IF* type statements 
                so a certain choice will only be there if a conditional statement is met.
                For instance:
                @CHOICE
                Yes
                No
                =`p20 500 Hey, I have 500 exactly!
                !`p20 500 Hey, I have anything BUT 500 exactly!
                >`p20 500 Hey, I have MORE than 500!
                <`p20 100 Hey, I have LESS than 100!
                >`p20 100 <`p20 500 I have more then 100 and less than 500!
                Also:  You can check the status of individual bits in a `T player byte.  The 
                bit is true or false, like this:
                +`t12 1 Hey! Byte 12's bit 1 is TRUE! (which is 1)
                -`t12 3 Hey! Byte 12's bit 3 is FALSE! (which is 0)

                The = > and < commands can be stacked as needed.  In the above example, if 
                `p20 was 600, only options 1, 2, 4, and 5 would be available, and RESPONSE 
                would be set to the correct option if one of those were selected.  For 
                example, if `p20 was 600 and the user hit the selection:
                "Hey, I have more than 500", RESPONSE would be set to 5. */

            _InCHOICEOptions.Clear();
            _InCHOICE = true;
        }

        private void CommandCHOOSEPLAYER(string[] tokens)
        {
            /* @CHOOSEPLAYER `p20
                This will prompt user for another players name - its the standard 'full or 
                partial name' prompt, with a 'you mean this guy?'.  It returns the players # 
                or 0 if none.  If the player isn't found it will display "No one by that name 
                lives 'round here" and return 0. */
            LogMissing(tokens);
        }

        private void CommandCLEAR(string[] tokens)
        {
            switch (tokens[1].ToUpper())
            {
                case "ALL":
                    /* @CLEAR ALL
                        This clears user text, picture, game text, name and redraws screen. */
                    CommandCLEAR("@CLEAR USERSCREEN".Split(' '));
                    CommandCLEAR("@CLEAR PICTURE".Split(' '));
                    CommandCLEAR("@CLEAR TEXT".Split(' '));
                    CommandCLEAR("@CLEAR NAME".Split(' '));
                    // TODO And redraws the screen
                    break;
                case "NAME":
                    /* @CLEAR NAME
                        This deletes the name line of the game window. */
                    Door.GotoXY(55, 15);
                    Door.Write(new string(' ', 22));
                    break;
                case "PICTURE":
                    /* @CLEAR PICTURE
                        This clears the picture. */
                    for (int y = 3; y <= 13; y++)
                    {
                        Door.GotoXY(55, y);
                        Door.Write(new string(' ', 22));
                    }
                    break;
                case "SCREEN":
                    /* @CLEAR SCREEN
                        This command clears the entire screen. */
                    Door.ClrScr();
                    break;
                case "TEXT":
                    /* @CLEAR TEXT
                        This clears game text. */
                    for (int y = 3; y <= 13; y++)
                    {
                        Door.GotoXY(32, y);
                        Door.Write(new string(' ', 22));
                    }
                    break;
                case "USERSCREEN":
                    /* @CLEAR USERSCREEN
                        This clears user text. */
                    for (int y = 16; y <= 23; y++)
                    {
                        Door.GotoXY(1, y);
                        Door.Write(new string(' ', 80));
                    }
                    Door.GotoXY(78, 23);
                    break;
                default:
                    LogUnused(tokens);
                    break;
            }
        }

        private void CommandCLEARBLOCK(string[] tokens)
        {
            /* @CLEARBLOCK <x> <y>
                This clears lines quick.  <x> is the first line you want to clear. <y> is the 
                last line you want to clear.  Example:  @clear block 20 24   This would clear 
                4 lines starting at line 20. */
            int SavedAttr = Crt.TextAttr;
            Door.TextAttr(7);

            int top = Convert.ToInt32(tokens[1]);
            int bottom = Convert.ToInt32(tokens[2]);
            for (int i = top; i <= bottom; i++)
            {
                Door.GotoXY(1, i);
                Door.Write(new string(' ', 80));
            }

            Door.GotoXY(1, bottom);
            Door.TextColor(SavedAttr & 0x0F);
        }

        private void CommandCLOSESCRIPT(string[] tokens)
        {
            /* @CLOSESCRIPT 
                This closes the script and returns command to the L2 movement system. */
            _InCLOSESCRIPT = true;
        }

        private void CommandCONVERT_FILE_TO_ANSI(string[] tokens)
        {
            /* @CONVERT_FILE_TO_ANSI <input file> <output file>
                Converts a text file of Sethansi (whatever) to regular ansi.  This is good for 
                a final score output. */
            LogMissing(tokens);
        }

        private void CommandCONVERT_FILE_TO_ASCII(string[] tokens)
        {
            /* @CONVERT_FILE_TO_ASCII <input file> <output file>
                Converts a text file of Sethansi (whatever) to regular ascii, ie, no colors at 
                all. */
            LogMissing(tokens);
        }

        private void CommandCOPYFILE(string[] tokens)
        {
            /* @COPYFILE <input filename> <output filename>
                This command copies a <input filename to <output filename>.           */
            string SourceFile = Global.GetSafeAbsolutePath(TranslateVariables(tokens[1]));
            string DestFile = Global.GetSafeAbsolutePath(TranslateVariables(tokens[2]));
            if ((SourceFile != "") && (DestFile != "") && (File.Exists(SourceFile)))
            {
                FileUtils.FileCopy(SourceFile, DestFile);
            }
        }

        private void CommandDATALOAD(string[] tokens)
        {
            /* @DATALOAD <filename> <record (1 to 200)> <`p variable to put it in> : This loads
                a long integer by # from a datafile.  If the file doesn't exist, it is created
                and all 200 long integers are set to 0.
                NOTE: You should specify an extension (usually .IDF) */
            string FileName = Global.GetSafeAbsolutePath(TranslateVariables(tokens[1]));
            if (FileName != "")
            {
                if (File.Exists(FileName))
                {
                    using (FileStream FS = new FileStream(FileName, FileMode.Open))
                    {
                        IGM_DATA IGMD = DataStructures.ReadStruct<IGM_DATA>(FS);
                        AssignVariable(tokens[3], IGMD.Data[Convert.ToInt32(TranslateVariables(tokens[2])) - 1].ToString());
                    }
                }
                else
                {
                    using (FileStream FS = new FileStream(FileName,FileMode.Create, FileAccess.Write))
                    {
                        IGM_DATA IGMD = new IGM_DATA();
                        IGMD.LastUsed = DateTime.Now.Month + DateTime.Now.Day;
                        IGMD.Data = new Int32[200];
                        for (int i = 0; i < IGMD.Data.Length; i++)
                        {
                            IGMD.Data[i] = 0;
                        }
                        IGMD.Extra = new Char[200];
                        for (int i = 0; i < IGMD.Extra.Length; i++)
                        {
                            IGMD.Extra[i] = '\0';
                        }
                        DataStructures.WriteStruct<IGM_DATA>(FS, IGMD);
                    }
                    AssignVariable(tokens[3], "0");
                }
            }
        }

        private void CommandDATANEWDAY(string[] tokens)
        {
            /* @DATANEWDAY <filename> :  If it is the NEXT day since this function was
                called, all records in <filename> will be set to 0.  Check EXAMPLE.REF in the 
                LORD II archive for an example of how this works.
                NOTE: You should specify an extension (usually .IDF) */
            string FileName = Global.GetSafeAbsolutePath(TranslateVariables(tokens[1]));
            if (FileName != "")
            {
                if (File.Exists(FileName))
                {
                    using (FileStream FS = new FileStream(FileName, FileMode.Open))
                    {
                        IGM_DATA IGMD = DataStructures.ReadStruct<IGM_DATA>(FS);
                        if (IGMD.LastUsed != (DateTime.Now.Month + DateTime.Now.Day))
                        {
                            IGMD.LastUsed = (DateTime.Now.Month + DateTime.Now.Day);
                            for (int i = 0; i < IGMD.Data.Length; i++)
                            {
                                IGMD.Data[i] = 0;
                            }
                            for (int i = 0; i < IGMD.Extra.Length; i++)
                            {
                                IGMD.Extra[i] = '\0';
                            }
                            DataStructures.WriteStruct<IGM_DATA>(FS, IGMD);
                        }
                    }
                }
                else
                {
                    using (FileStream FS = new FileStream(FileName, FileMode.Create, FileAccess.Write))
                    {
                        IGM_DATA IGMD = new IGM_DATA();
                        IGMD.LastUsed = DateTime.Now.Month + DateTime.Now.Day;
                        IGMD.Data = new Int32[200];
                        for (int i = 0; i < IGMD.Data.Length; i++)
                        {
                            IGMD.Data[i] = 0;
                        }
                        IGMD.Extra = new Char[200];
                        for (int i = 0; i < IGMD.Extra.Length; i++)
                        {
                            IGMD.Extra[i] = '\0';
                        }
                        DataStructures.WriteStruct<IGM_DATA>(FS, IGMD);
                    }
                }
            }
        }

        private void CommandDATASAVE(string[] tokens)
        {
            /* @DATASAVE <filename> <record (1 to 200)> <value to make it> : This SAVES
                a long integer by # to a datafile.  If the file doesn't exist, it is created
                and all 200 long integers (except the one referenced) are set to 0.  The 
                record that is referenced will be set to the value of the 3rd parameter.
                NOTE: You should specify an extension (usually .IDF) */
            string FileName = Global.GetSafeAbsolutePath(TranslateVariables(tokens[1]));
            if (FileName != "")
            {
                if (File.Exists(FileName))
                {
                    using (FileStream FS = new FileStream(FileName, FileMode.Open, FileAccess.ReadWrite))
                    {
                        // Read file
                        IGM_DATA IGMD = DataStructures.ReadStruct<IGM_DATA>(FS);
                        IGMD.Data[Convert.ToInt32(TranslateVariables(tokens[2])) - 1] = Convert.ToInt32(TranslateVariables(tokens[3]));
                        
                        // Write file
                        FS.Position = 0;
                        DataStructures.WriteStruct<IGM_DATA>(FS, IGMD);
                    }
                }
                else
                {
                    using (FileStream FS = new FileStream(FileName, FileMode.Create, FileAccess.Write))
                    {
                        IGM_DATA IGMD = new IGM_DATA();
                        IGMD.LastUsed = DateTime.Now.Month + DateTime.Now.Day;
                        IGMD.Data = new Int32[200];
                        for (int i = 0; i < IGMD.Data.Length; i++)
                        {
                            IGMD.Data[i] = 0;
                        }
                        IGMD.Data[Convert.ToInt32(TranslateVariables(tokens[2])) - 1] = Convert.ToInt32(TranslateVariables(tokens[3]));
                        IGMD.Extra = new Char[200];
                        for (int i = 0; i < IGMD.Extra.Length; i++)
                        {
                            IGMD.Extra[i] = '\0';
                        }
                        DataStructures.WriteStruct<IGM_DATA>(FS, IGMD);
                    }
                }
            }
        }

        private void CommandDECLARE(string[] obj)
        {
            /* @DECLARE <Label/header name> <offset in decimal format> */
            // Ignore, these commands were inserted by REFINDEX, but not used here
        }

        private void CommandDISPLAY(string[] tokens)
        {
            /* @DISPLAY <this> IN <this file> <options>
                This is used to display a certain part of a file.  This is compatible with the 
                LORDTXT.DAT format. */
            Door.WriteLn(TranslateVariables(string.Join("\r\n", RTGlobal.RefFiles[Path.GetFileNameWithoutExtension(tokens[3])].Sections[tokens[1]].Script.ToArray())));
        }

        private void CommandDISPLAYFILE(string[] tokens)
        {
            /* @DISPLAYFILE <filename> <options> 
                This display an entire file.  Possible options are:  NOPAUSE and NOSKIP.  Put a
                space between options if you use both. */
            string FileName = Global.GetSafeAbsolutePath(TranslateVariables(tokens[1]));
            if (File.Exists(FileName))
            {
                Door.Write(TranslateVariables(FileUtils.FileReadAllText(FileName, RMEncoding.Ansi)));
            }
        }

        private void CommandDO(string[] tokens)
        {
            if (_DOCommands.ContainsKey(tokens[1]))
            {
                _DOCommands[tokens[1]](tokens);
            }
            else if ((tokens.Length >= 3) && (_DOCommands.ContainsKey(tokens[2])))
            {
                _DOCommands[tokens[2]](tokens);
            }
            else
            {
                LogMissing(tokens);
            }
        }

        private void CommandDO_ADD(string[] tokens)
        {
            /* @DO <Number To Change> <How To Change It> <Change With What> */
            if (tokens[2] == "+")
            {
                AssignVariable(tokens[1], (Convert.ToInt32(TranslateVariables(tokens[1])) + Convert.ToInt32(TranslateVariables(tokens[3]))).ToString());
            }
            else if (tokens[2].ToUpper() == "ADD")
            {
                AssignVariable(tokens[1], TranslateVariables(tokens[1] + string.Join(" ", tokens, 3, tokens.Length - 3)));
            }
        }

        private void CommandDO_ADDLOG(string[] tokens)
        {
            /* @DO addlog
                The line UNDER this command is added to the 'lognow.txt' file. */
            _InDO_ADDLOG = true;
        }

        private void CommandDO_BEEP(string[] tokens)
        {
            /* @DO BEEP
                Makes a weird beep noise, locally only */
            LogUnused(tokens);
        }

        private void CommandDO_COPYTONAME(string[] tokens)
        {
            /* @DO COPYTONAME  
                This will put whatever is in `S10 into `N.  (name)  This is a good way to 
                allow a player to change his name or to get the name a new player wants to go 
                by.  It is also useful in the @#newplayer routine to get the alias the player 
                wants to go by in the game. */
            RTGlobal.ReadOnlyVariables["`N"] = TranslateVariables("`S10");
        }

        private void CommandDO_DELETE(string[] tokens)
        {
            /* @DO DELETE <file name>
                This command deletes the file specified by <file name>.  The file name must be 
                a valid DOS file name.  There can be no spaces. */
            string FileName = Global.GetSafeAbsolutePath(tokens[2]);
            if (File.Exists(FileName))
            {
                FileUtils.FileDelete(FileName);
            }
        }

        private void CommandDO_DIVIDE(string[] tokens)
        {
            /* @DO <Number To Change> <How To Change It> <Change With What> */
            AssignVariable(tokens[1], Math.Truncate(Convert.ToDouble(TranslateVariables(tokens[1])) / Convert.ToDouble(TranslateVariables(tokens[3]))).ToString());
        }

        private void CommandDO_FRONTPAD(string[] tokens)
        {
            /* @DO FRONTPAD <string variable> <length>
                This adds spaces to the front of the string until the string is as long as 
                <length>. */
            int StringLength = Door.StripSeth(TranslateVariables(tokens[2])).Length;
            int RequestedLength = Convert.ToInt32(tokens[3]);
            if (StringLength < RequestedLength)
            {
                AssignVariable(tokens[2], StringUtils.PadLeft(TranslateVariables(tokens[2]), ' ', Convert.ToInt32(tokens[3])));
            }
        }

        private void CommandDO_GETKEY(string[] tokens)
        {
            /* @DO GETKEY <String variable to put it in>
                This command is useful, *IF* a key IS CURRENTLY being pressed, it puts that 
                key into the string variable.  Otherwise, it puts a '_' in to signal no key was 
                pressed.  This is a good way to stop a loop. */
            if (Door.KeyPressed())
            {
                char? Ch = Door.ReadKey();
                if (Ch == null)
                {
                    AssignVariable(tokens[2], "_");
                }
                else
                {
                    AssignVariable(tokens[2], Ch.ToString());
                }
            }
            else
            {
                AssignVariable(tokens[2], "_");
            }
        }

        private void CommandDO_GOTO(string[] tokens)
        {
            /* @DO GOTO <header or label>
                Passes control of the script to the header or label specified. */
            if (_CurrentFile.Sections.ContainsKey(tokens[2]))
            {
                // HEADER goto
                RTReader RTR = new RTReader();
                _InHALT = RTR.RunSection(_CurrentFile.Name, TranslateVariables(tokens[2]));
                _InCLOSESCRIPT = true; // Don't want to resume this ref
            }
            else if (_CurrentSection.Labels.ContainsKey(tokens[2]))
            {
                // LABEL goto within current section
                _CurrentLineNumber = _CurrentSection.Labels[tokens[2]];
            }
            else
            {
                foreach (KeyValuePair<string, RTRSection> KVP in _CurrentFile.Sections)
                {
                    if (KVP.Value.Labels.ContainsKey(tokens[2]))
                    {
                        // LABEL goto within a different section
                        RTReader RTR = new RTReader();
                        _InHALT = RTR.RunSection(_CurrentFile.Name, KVP.Key, TranslateVariables(tokens[2]));
                        _InCLOSESCRIPT = true; // Don't want to resume this ref
                        break;
                    }
                }
            }
        }

        private void CommandDO_IS(string[] tokens)
        {
            /* @DO <Number To Change> <How To Change It> <Change With What> */
            /* TODO @DO `s01 is getname 8
                This would get the name of player 8 and put it in `s01.  This only works with 
                `s variables.  The account number can be a `p variable. */
            /* TODO @DO `p20 is deleted 8
                Puts 1 (player is deleted) or 0 (player is not deleted) in `p20.  This only 
                works with `p variables.  The account number can be a `p variable. */
            /* TODO @DO <number variable> IS LENGTH <String variable>
                Gets length, smart way. */
            /* TODO @DO <number variable> IS REALLENGTH <String variable>
                Gets length dumb way. (includes '`' codes without deciphering them.) */
            AssignVariable(tokens[1], string.Join(" ", tokens, 3, tokens.Length - 3));
        }

        private void CommandDO_MOVE(string[] tokens)
        {
            /* @DO MOVE <X> <Y> : This moves the curser.  (like GOTOXY in TP) Enter 0 for
                a number will default to 'current location'. */
            int X = Convert.ToInt32(TranslateVariables(tokens[2]));
            int Y = Convert.ToInt32(TranslateVariables(tokens[3]));
            if ((X > 0) && (Y > 0))
            {
                Door.GotoXY(X, Y);
            }
            else if (X > 0)
            {
                Door.GotoX(X);
            }
            else if (Y > 0)
            {
                Door.GotoY(Y);
            }
        }

        private void CommandDO_MOVEBACK(string[] tokens)
        {
            /* @DO moveback
                This moves the player back to where he moved from.  This is good for when a 
                player pushes against a treasure chest or such, and you don't want them to 
                appear inside of it when they are done. */
            EventHandler Handler = RTGlobal.OnMOVEBACK;
            if (Handler != null) Handler(null, EventArgs.Empty);
        }

        private void CommandDO_MULTIPLY(string[] tokens)
        {
            /* @DO <Number To Change> <How To Change It> <Change With What> */
            AssignVariable(tokens[1], (Convert.ToInt32(TranslateVariables(tokens[1])) * Convert.ToInt32(TranslateVariables(tokens[3]))).ToString());
        }

        private void CommandDO_NUMRETURN(string[] tokens)
        {
            /* @DO NUMRETURN <int var> <string var>
                Undocumented.  Seems to return the number of integers in the given string
                Example "123test456" returns 6 because there are 6 numbers */
            string Translated = TranslateVariables(tokens[3]);
            string TranslatedWithoutNumbers = Regex.Replace(Translated, "[0-9]", "", RegexOptions.IgnoreCase);
            AssignVariable(tokens[2], (Translated.Length - TranslatedWithoutNumbers.Length).ToString());
        }

        private void CommandDO_PAD(string[] tokens)
        {
            /* @DO PAD <string variable> <length>
                This adds spaces to the end of the string until string is as long as <length>. */
            int StringLength = Door.StripSeth(TranslateVariables(tokens[2])).Length;
            int RequestedLength = Convert.ToInt32(tokens[3]);
            if (StringLength < RequestedLength)
            {
                AssignVariable(tokens[2], StringUtils.PadRight(TranslateVariables(tokens[2]), ' ', Convert.ToInt32(tokens[3])));
            }
        }

        private void CommandDO_QUEBAR(string[] tokens)
        {
            /* @DO quebar
                <message>
                This adds a message to the saybar que.  This will ensure that the message is 
                displayed at it's proper time instead of immediately. */
            LogMissing(tokens);
        }

        private void CommandDO_RANDOM(string[] tokens)
        {
            /* @DO <Varible to put # in> RANDOM <Highest number> <number to add to it>
                RANDOM 5 1 will pick a number between 0 (inclusive) and 5 (exclusive) and add 1 to it, resulting in 1-5
                RANDOM 100 200 will pick a number between 0 (inclusive) and 100 (exclusive) and add 200 to it, resulting in 200-299 */
            int Min = Convert.ToInt32(tokens[4]);
            int Max = Min + Convert.ToInt32(tokens[3]);
            AssignVariable(tokens[1], _R.Next(Min, Max).ToString());
        }

        private void CommandDO_READCHAR(string[] tokens)
        {
            /* @DO READCHAR <string variable to put it in> 
                Waits for a key to be pressed.  This uses DV and Windows time slicing while 
                waiting.  `S10 doesn't seem to work with this command.  All the other `S 
                variables do though. */
            char? Ch = Door.ReadKey();
            if (Ch == null)
            {
                AssignVariable(tokens[2], "\0");
            }
            else
            {
                AssignVariable(tokens[2], Ch.ToString());
            }
        }

        private void CommandDO_READNUM(string[] tokens)
        {
            /* @DO READNUM <MAX LENGTH> <DEFAULT> (Optional: <FOREGROUND COLOR> <BACKGROUND COLOR>
                The number is put into `V40.
                The READNUM procedure is a very nice string editer to get a number in. It
                supports arrow keys and such. */
            string Default = "";
            if (tokens.Length >= 4) Default = TranslateVariables(tokens[3]);

            string ReadNum = Door.Input(Default, CharacterMask.Numeric, '\0', Convert.ToInt32(TranslateVariables(tokens[2])), Convert.ToInt32(TranslateVariables(tokens[2])), 31);
            int AnswerInt = 0;
            if (!int.TryParse(ReadNum, out AnswerInt)) AnswerInt = 0;

            AssignVariable("`V40", AnswerInt.ToString());
        }

        private void CommandDO_READSPECIAL(string[] tokens)
        {
            /* @DO READSPECIAL (String variable to put it in> <legal chars, 1st is default>
                Example:
                @do write
                Would you like to kill the monster? Y/N :
                @DO READSPECIAL `s01 YN
                if `s01 is Y then do
                 @begin
                 @show
                You killed him!
                 @end
                The above would ONLY allow the person to hit Y or N - if he hit ENTER, it
                would be the same as hitting Y, because that was listed first.   */
            char? Ch = null;
            while (true)
            {
                Ch = Door.ReadKey();
                if (Ch != null)
                {
                    Ch = char.ToUpper((char)Ch);
                    if (Ch == '\r')
                    {
                        // Assign first option when enter is hit
                        AssignVariable(tokens[2], tokens[3][0].ToString());
                        break;
                    }
                    else if (tokens[3].ToUpper().Contains(Ch.ToString()))
                    {
                        // Assign selected character
                        AssignVariable(tokens[2], Ch.ToString());
                        break;
                    }
                }
            }
        }

        private void CommandDO_READSTRING(string[] tokens)
        {
            /* @DO READSTRING <MAX LENGTH> <DEFAULT> <variable TO PUT IT IN>
                Get a string.  Uses same string editer as READNUM.
                Note:  You can only use the `S01 through `S10 vars for READSTRING.  You can 
                also use these vars for the default.  (or `N)  Use NIL if you want the default 
                to be nothing.  (if no variable to put it in is specified, it will be put into `S10 
                for compatibilty with old .REF's) */
            string ReadString = Door.Input(Regex.Replace(TranslateVariables(tokens[3]), "NIL", "", RegexOptions.IgnoreCase), CharacterMask.All, '\0', Convert.ToInt32(TranslateVariables(tokens[2])), Convert.ToInt32(TranslateVariables(tokens[2])), 31);
            if (tokens.Length >= 5)
            {
                AssignVariable(tokens[4], ReadString);
            }
            else
            {
                AssignVariable("`S10", ReadString);
            }
        }

        private void CommandDO_REPLACE(string[] tokens)
        {
            /* @REPLACE <X> <Y> <in `S10>
                Replaces X with Y in an `s variable. */
            // The following regex matches only the first instance of the word foo: (?<!foo.*)foo (from http://stackoverflow.com/a/148561/342378)
            AssignVariable(tokens[4], Regex.Replace(TranslateVariables(tokens[4]), "(?<!" + Regex.Escape(TranslateVariables(tokens[2])) + ".*)" + Regex.Escape(TranslateVariables(tokens[2])), TranslateVariables(tokens[3]), RegexOptions.IgnoreCase));
        }

        private void CommandDO_REPLACEALL(string[] tokens)
        {
            /* @REPLACEALL <X> <Y> <in `S10>:
                Same as above but replaces all instances. */
            AssignVariable(tokens[4], Regex.Replace(TranslateVariables(tokens[4]), Regex.Escape(TranslateVariables(tokens[2])), TranslateVariables(tokens[3]), RegexOptions.IgnoreCase));
        }

        private void CommandDO_RENAME(string[] tokens)
        {
            /* @DO RENAME <old name> <new name>
                Undocumented.  Renames a file */
            string OldFile = Global.GetSafeAbsolutePath(TranslateVariables(tokens[2]));
            string NewFile = Global.GetSafeAbsolutePath(TranslateVariables(tokens[3]));
            if ((OldFile != "") && (NewFile != "") && (File.Exists(OldFile)))
            {
                FileUtils.FileMove(OldFile, NewFile);
            }
        }

        private void CommandDO_SAYBAR(string[] tokens)
        {
            /* @DO saybar
                <message>
                This is like @do quebar except it displays the message instantly without
                taking into consideration that a message might have just been displayed.  This 
                will overwrite any current message on the saybar unconditionally. */
            _InSAYBAR = true;
        }

        private void CommandDO_STRIP(string[] tokens)
        {
            /* @DO STRIP <string variable>
                This strips beginning and end spaces of a string. */
            AssignVariable(tokens[2], TranslateVariables(tokens[2]).Trim());
        }

        private void CommandDO_STRIPALL(string[] tokens)
        {
            /* @DO STRIPALL
                This command strips out all ` codes.  This is good for passwords, etc. */
            LogUnused(tokens);
        }

        private void CommandDO_STRIPBAD(string[] tokens)
        {
            /* @DO STRIPBAD
                This strips out illegal ` codes, and replaces badwords with the standard 
                badword.dat file. */
            LogMissing(tokens);
        }

        private void CommandDO_STRIPCODE(string[] tokens)
        {
            /* @STRIPCODE <any `s variable>
                This will remove ALL ` codes from a string. */
            LogUnused(tokens);
        }

        private void CommandDO_SUBTRACT(string[] tokens)
        {
            /* @DO <Number To Change> <How To Change It> <Change With What> */
            AssignVariable(tokens[1], (Convert.ToInt32(TranslateVariables(tokens[1])) - Convert.ToInt32(TranslateVariables(tokens[3]))).ToString());
        }

        private void CommandDO_TALK(string[] tokens)
        {
            /* @DO TALK <message> [recipients]
                Undocumented. Looks like recipients is usually ALL, which sends a global message
                Lack of recipients value means message is only displayed to those on the same screen */
            LogMissing(tokens);
        }

        private void CommandDO_TRIM(string[] tokens)
        {
            /* @DO TRIM <file name> <number to trim to>
                This nifty command makes text file larger than <number to trim to> get 
                smaller.  (It deletes lines from the top until the file is correct # of lines, 
                if smaller than <number to trim to>, it doesn't change the file) */
            string FileName = Global.GetSafeAbsolutePath(TranslateVariables(tokens[2]));
            if (File.Exists(FileName))
            {
                int MaxLines = Convert.ToInt32(TranslateVariables(tokens[3]));
                List<string> Lines = new List<string>();
                Lines.AddRange(FileUtils.FileReadAllLines(FileName, RMEncoding.Ansi));
                if (Lines.Count > MaxLines)
                {
                    while (Lines.Count > MaxLines) Lines.RemoveAt(0);
                    FileUtils.FileWriteAllLines(FileName, Lines.ToArray(), RMEncoding.Ansi);
                }
            }
        }

        private void CommandDO_UPCASE(string[] tokens)
        {
            /* @DO UPCASE <string variable>
                This makes a string all capitals. */
            AssignVariable(tokens[2], TranslateVariables(tokens[2]).ToUpper());
        }

        private void CommandDO_WRITE(string[] tokens)
        {
            /* @DO WRITE
                <Stuff to write>
                Same thing as regular @SHOW, but does only one line, without a line feed.  
                Used with @DO MOVE this is good for putting prompts, right in front of READNUM 
                and READSTRING's.
                NOTE:  You can use variables mixed with text, ansi and color codes in the 
                <stuff to write> part.  Works this way with most stuff. */
            _InDO_WRITE = true;
        }

        private void CommandDRAWMAP(string[] tokens)
        {
            /* @DRAWMAP
                This draws the current map the user is on.  This command does NOT update the 
                screen.  See the @update command below concerning updating the scren. */
            EventHandler Handler = RTGlobal.OnDRAWMAP;
            if (Handler != null) Handler(null, EventArgs.Empty);
        }

        private void CommandDRAWPART(string[] tokens)
        {
            /* @DRAWPART <x> <y>
                This command will draw one block of the current map as defined by <x> and <y> 
                with whatever is supposed to be there, including any people. */
            LogMissing(tokens);
        }

        private void CommandEND(string[] tokens)
        {
            _InBEGINCount -= 1;
        }

        private void CommandFIGHT(string[] tokens)
        {
            /* @FIGHT  : Causes the L2 engine to go into fight mode.
                <Monster name>
                <String said when you see him>
                <Power Move Kill String>
                <Weapon 1|strength>
                <Weapon 2|strength or NONE|NONE>
                <Weapon 3|strength or NONE|NONE>
                <Weapon 4|strength or NONE|NONE>      
                <Weapon 5|strength or NONE|NONE>
                <Defense>
                <Experience Points rewarded for victory>
                <Gold rewarded for victory>
                <Hitpoints the monster has>
                <REFFILENAME|REFNAME or NONE|NONE> player victory
                <REFFILENAME|REFNAME or NONE|NONE> player defeat
                <REFFILENAME|REFNAME or NONE|NONE> player runs

                As with any of the other commands you may have comment lines and inline 
                comments within this command.
                It is also important to note here that while this can be in a standard routine 
                it will not execute until after the script has completed execution and the 
                player returned to the map screen.  This is usually used for the random fights 
                as players walk around.  Below is an example of how it is used in this way.  
                In the map attributes (edited by pressing z while editing a screen in the 
                world editor of L2CFG) you specify a fight file name and a fight ref name.  
                The ref name is the routine the L2 engine calls.  Let's say your ref name is 
                fight.  The file name can be anything you choose so long as the following 
                routine is in that file.  The following routine shows how random fighting is 
                accomplished:

                @#fight
                @do `p20 random 6 1
                @do goto monster`p20
                @#monster1
                @fight
                ;name
                Tiny Scorpion
                ;string said when you see him
                Something crawls up your leg...
                ;power move kill string
                You laugh as the tiny thing burns in the sand.
                ;sex - 1 is male, 2 is female, 3 is it
                3
                ;weapon and strength for the weapon, up to 5
                stings you|44
                pinches you|25
                NONE|NONE
                NONE|NONE
                NONE|NONE
                ;defense
                15
                ;gold reward
                89
                ;experience
                54
                ;hit points
                64
                ;if win: ref file|name or NONE
                NONE|NONE
                ;if lose: ref file|name or NONE
                GAMETXT.REF|DIE
                ;if runs: ref file|name or NONE
                NONE|NONE
                @#monster2
                @fight
                (parameters for fight command until you have as many monster commands as the 
                highest random number

                You might also have a hotspot defined that calls a routine that will be a 
                fight.  Make sure you DON'T clear the screen.  It won't hurt anything if you 
                do, but it won't look very good. */
            LogMissing(tokens);
        }

        private void CommandGRAPHICS(string[] tokens)
        {
            /* @GRAPHICS IS <Num> 
                3 or more enable remote ANSI.  If you never wanted to send ANSI, you could set 
                this to 1. You will probably never touch this one. */
            LogUnused(tokens);
        }

        private void CommandHALT(string[] tokens)
        {
            /* @HALT <error level>
                This command closes the door and returns the specified error level. */
            if (tokens.Length == 1)
            {
                _InHALT = 0;
            }
            else
            {
                _InHALT = Convert.ToInt32(tokens[1]);
            }
        }

        private void CommandIF(string[] tokens)
        {
            /* @IF <Varible> <Math> <Thing the varible must be, or more or less then, or
                another varible>  (Possible math functions: EQUALS, MORE, LESS, NOT) */
            /* TODO You can also use @if checkdupe `S10 is TRUE(or FALSE) then do
                                 @begin
                                   code to execute
                                 @end
                This will check all the accounts for a name as specified in `S10.  If a match 
                is found, then checkdupe will be true.  Othewise checkdupe will be false.  `S10
                is used for example only.  `S10 can be substituted for any of the `S variables. */
            bool Result = false;
            string Left = TranslateVariables(tokens[1]);
            string Right = TranslateVariables(tokens[3]);
            int LeftInt = 0;
            int RightInt = 0;

            // TODO This is to try to detect unknown variables in the variable position (if the before and after translation are the same, it's probably an unknown variable)
            if (tokens[1] == Left)
            {
                if (tokens[2].ToUpper() == "EXIST")
                {
                    // Ignore, tokens[1] was a literal filename
                }
                else
                {
                    LogMissing(tokens);
                }
            }

            /* TODO @IF bitcheck `t12 1 1 then do
                  @BEGIN
                  @SHOW
                  Yeah!  Bit 1 of t12 is TRUE!!! Yay.
                  @END */
            /* Sample code for bitcheck
                if (x & (1<<n)) {
                  n-th bit is set
                }
                else {
                  n-th bit is not set
                }*/
            switch (tokens[2].ToUpper())
            {
                case "EQUALS":
                case "IS":
                    if (int.TryParse(Left, out LeftInt) && int.TryParse(Right, out RightInt))
                    {
                        Result = (LeftInt == RightInt);
                    }
                    else
                    {
                        Result = (Left == Right);
                    }
                    break;
                case "EXIST":
                    /* Undocumented.  Checks if given file exists */
                    string FileName = Global.GetSafeAbsolutePath(Left);
                    bool TrueFalse = Convert.ToBoolean(Right.ToUpper());
                    Result = (File.Exists(FileName) == TrueFalse);
                    break;
                case "INSIDE":
                    /* @IF <Word or variable> INSIDE <Word or variable>
                        This allows you to search a string for something inside of it.  Not case 
                        sensitive. */
                    Result = Right.ToUpper().Contains(Left.ToUpper());
                    break;
                case "LESS":
                case "<":
                    if (int.TryParse(Left, out LeftInt) && int.TryParse(Right, out RightInt))
                    {
                        Result = (LeftInt < RightInt);
                    }
                    else
                    {
                        throw new ArgumentException("@IF LESS arguments were not numeric");
                    }
                    break;
                case "MORE":
                case ">":
                    if (int.TryParse(Left, out LeftInt) && int.TryParse(Right, out RightInt))
                    {
                        Result = (LeftInt > RightInt);
                    }
                    else
                    {
                        throw new ArgumentException("@IF MORE arguments were not numeric");
                    }
                    break;
                case "NOT":
                    if (int.TryParse(Left, out LeftInt) && int.TryParse(Right, out RightInt))
                    {
                        Result = (LeftInt != RightInt);
                    }
                    else
                    {
                        Result = (Left != Right);
                    }
                    break;
                default:
                    LogMissing(tokens);
                    break;
            }

            // Check if it's an IF block, or inline IF
            if (string.Join(" ", tokens).ToUpper().Contains("THEN DO"))
            {
                // @BEGIN..@END coming, so skip it if our result was false
                if (!Result) _InIFFalse = _InBEGINCount;
            }
            else
            {
                // Inline DO, so execute it
                if (Result)
                {
                    int DOOffset = (tokens[5].ToUpper() == "THEN") ? 6 : 5;
                    string[] DOtokens = ("@DO " + string.Join(" ", tokens, DOOffset, tokens.Length - DOOffset)).Split(' ');
                    CommandDO(DOtokens);
                }
            }
        }

        private void CommandITEMEXIT(string[] tokens)
        {
            /* @ITEMEXIT
                This tells the item editor to automatically return the player to the map 
                screen after the item is used.  It is up to you to use the @drawmap and 
                @update commands as usual though. */
            LogMissing(tokens);
        }

        private void CommandKEY(string[] tokens)
        {
            // Save text attribute
            int SavedAttr = Crt.TextAttr;

            if (tokens.Length == 1)
            {
                /* @KEY 
                    Does a [MORE] prompt, centered on current line.
                    NOTE: Actually indents two lines, not centered */
                Door.Write(TranslateVariables("  `2<`0MORE`2>"));
                Door.ReadKey();
                Door.Write("\b\b\b\b\b\b\b\b        \b\b\b\b\b\b\b\b");
            }
            else if (tokens[1].ToUpper() == "BOTTOM")
            {
                /* @KEY BOTTOM
                    This does <MORE> prompt at user text window. */
                Door.GotoXY(35, 24);
                Door.Write(TranslateVariables("`2<`0MORE`2>"));
                Door.ReadKey();
                Door.Write("\b\b\b\b\b\b      \b\b\b\b\b\b");
            }
            else if (tokens[1].ToUpper() == "NODISPLAY")
            {
                /* @KEY NODISPLAY
                    Waits for keypress without saying anything. */
                Door.ReadKey();
            }
            else if (tokens[1].ToUpper() == "TOP")
            {
                /* @KEY TOP
                    This does <MORE> prompt at game text window. */
                Door.GotoXY(40, 15);
                Door.Write(TranslateVariables("`2<`0MORE`2>"));
                Door.ReadKey();
                Door.Write("\b\b\b\b\b\b      \b\b\b\b\b\b");
            }
            else
            {
                LogMissing(tokens);
            }

            // Restore text attribute
            Door.Write(Ansi.TextAttr(SavedAttr));
        }

        private void CommandLABEL(string[] tokens)
        {
            /* @LABEL <label name>
                Mark a spot where @DO GOTO <label name> can be used */
            // Ignore, nothing to do here
        }

        private void CommandLOADCURSOR(string[] tokens)
        {
            /* @LOADCURSOR
                This command restores the cursor to the position before the last @SAVECURSOR 
                was issued.  This is good for creative graphics and text positioning with a 
                minimum of calculations.  See @SAVECURSOR below. */
            LogMissing(tokens);
        }

        private void CommandLOADGLOBALS(string[] tokens)
        {
            /* @LOADGLOBALS
                This command loads the last value of all global variables as existed when the 
                last @SAVEGLOBALS command was issued.  See @SAVEGLOBALS below. */
            LogUnused(tokens);
        }

        private void CommandLOADMAP(string[] tokens)
        {
            /* @LOADMAP <map #>
                This is a very handy command.  It lets you change someones map location in a 
                ref file.  This is the 'block #' not the physical map location, so it could be 
                1 to 1600.  Be sure it exists in l2cfg.exe.  If the map block does not exist, 
                The L2 engine will display a runtime error and close the door.   Be SURE to 
                change the map variable too!!  Using this and changing the X and Y coordinates 
                effectivly lets you do a 'warp' from a .ref file. */
            LogMissing(tokens);
        }

        private void CommandLOADWORLD(string[] tokens)
        {
            /* @LOADWORLD
                This command loads globals and world data.  It has never been used but is 
                included just in case it becomes necessary to do this.  See @SAVEWORLD below. */
            LogUnused(tokens);
        }

        private void CommandLORDRANK(string[] tokens)
        {
            /* @LORDRANK <filename> <`p variable to rank by>
                This command produces a file as specified by <filename>.  It uses the `p 
                variable specified for the order of the ranking.  This parameter must be a 
                number without the `p.  The file that is created contains no headers and is 
                not deleted before writing.  If a file of the same name already exists, the 
                procedure will append the file.  The following table is the column numbers
                where @LORDRANK places the ranking information.
                  COLUMN     STAT
                  1          Sex if female
                  3          Name
                  37         Stat to rank by (right justified) (Usually Experience)
                  42         Level 
                  48         Status 
                  60         Alignment
                  65         Quests completed */
            LogMissing(tokens);
        }

        private void CommandMOREMAP(string[] tokens)
        {
            /* @MOREMAP
                The line UNDER this will be the new <more> prompt.  30 characters maximum. */
            LogUnused(tokens);
        }

        private void CommandNAME(string[] tokens)
        {
            /* @NAME <name to put under picture>
                Undocumented. Puts a name under the picture window */
            string Name = TranslateVariables(string.Join(" ", tokens, 1, tokens.Length - 1));
            Door.GotoXY(55 + Convert.ToInt32(Math.Truncate((22 - Door.StripSeth(Name).Length) / 2.0)), 15);
            Door.Write(Name);
        }

        private void CommandNOCHECK(string[] obj)
        {
            /* @NOCHECK
                Tell the original RTReader to stop scanning for sections/labels
                Not implemented here, we always scan all files in their entirety */
            // Ignore
        }

        private void CommandOFFMAP(string[] tokens)
        {
            /* @OFFMAP
                This takes the player's symbol off the map.  This makes the player appear to 
                disappear to other players currently playing.  This is usful to make it look
                like they actually went into the hut, building, ect. */
            LogMissing(tokens);
        }

        private void CommandOVERHEADMAP(string[] tokens)
        {
            /* @OVERHEADMAP
                This command displays the visible portion of the map as defined in the world 
                editor of L2CFG.  All maps marked as no show and all unused maps will be 
                blue signifying ocean.  No marks or legend will be written on the map.  This 
                is your responsibility.  If you wish to mark the map you must do this in 
                help.ref under the @#M routine.  Be sure to include a legend so people have 
                some reference concerning what the marks mean. */
            LogMissing(tokens);
        }

        private void CommandPAUSEOFF(string[] tokens)
        {
            /* @PAUSEOFF
                This turns the 24 line pause off so you can show long ansis etc and it won't 
                pause every 24 lines. */
            LogMissing(tokens);
        }

        private void CommandPAUSEON(string[] tokens)
        {
            /* @PAUSEON
                Just the opposite of the above command.  This turns the pause back on. */
            LogMissing(tokens);
        }

        private void CommandPROGNAME(string[] tokens)
        {
            /* @PROGNAME
                The line UNDER this will be the status bar name of the game. */
            LogUnused(tokens);
        }

        private void CommandRANK(string[] tokens)
        {
            /* @RANK <filename> <`p variable to rank by> <procedure to format the ranking>
                This command is the same as above with the exception it uses a procedure to 
                format the ranking.  This procedure needs to be in the same file as the @RANK 
                command.  It is preferable to use the @LORDRANK command rather than this one,
                if feasible.  This one works, but @LORDRANK uses a preset formatting
                procedure and is therefore quicker.  There may be occasion, however, if you
                write your own world to use this command rather than @LORDRANK. */
            LogUnused(tokens);
        }

        private void CommandREADFILE(string[] tokens)
        {
            /* @READFILE <file name>
                <variable to read into>
                <variable to read into>
                <Ect until next @ at beginning of string is hit>
                This works just like @WRITEFILE.  You can use String and Number variables, 
                just be warned if a number variable attempts to read a string, you will always 
                get 0.
                NOTE:  @READFILE is a smart procedure - It will not run-time error or 
                anything, even if you try to read past the end of the file. It simply won't 
                change the variables if the file isn't long enough. */
            LogMissing(tokens);
        }

        private void CommandROUTINE(string[] tokens)
        {
            /* @ROUTINE <Header or label name> IN <Filename of .REF file>
                The @ROUTINE command is useful - You can use it jump to a completely new .REF 
                file - when it's finished there, instead of closing the script, it will load 
                back up the original .REF file and continue where it left off.  One note.  I 
                have found that @ROUTINE cannot be nested.  That is if you use an @ROUTINE 
                command inside of a routine called by @ROUTINE, the reader cannot return to 
                the first procedure that ran @ROUTINE. */
            RTReader RTR = new RTReader();
            if (tokens.Length < 4)
            {
                _InHALT = RTR.RunSection(_CurrentFile.Name, TranslateVariables(tokens[1]));
            }
            else
            {
                _InHALT = RTR.RunSection(TranslateVariables(tokens[3]), TranslateVariables(tokens[1]));
            }
        }

        private void CommandRUN(string[] tokens)
        {
            /* @RUN <Header or label name> IN <Filename of .REF file>
                Same thing as ROUTINE, but doesn't come back to the original .REF. */
            RTReader RTR = new RTReader();
            _InHALT = RTR.RunSection(TranslateVariables(tokens[3]), TranslateVariables(tokens[1]));
            _InCLOSESCRIPT = true; // Don't want to resume this ref
        }

        private void CommandSAVECURSOR(string[] tokens)
        {
            /* @SAVECURSOR
                This command saves the current cursor positioning for later retrieval. */
            LogMissing(tokens);
        }

        private void CommandSAVEGLOBALS(string[] tokens)
        {
            /* @SAVEGLOBALS
                This command saves the current global variables for later retrieval */
            LogMissing(tokens);
        }

        private void CommandSAVEWORLD(string[] tokens)
        {
            /* @SAVEWORLD
                This command saves stats and world data.  The only use yet is right after 
                @#maint is called to save random stats set for that day and such. */
            LogUnused(tokens);
        }

        private void CommandSAY(string[] tokens)
        {
            /* @SAY
                All text UNDER this will be put in the 'talk window' until a @ is hit. */
            _InSAY = true;
        }

        private void CommandSELLMANAGER(string[] tokens)
        {
            /* @SELLMANAGER
                This command presents a menu of the player's current inventory.  The player 
                can then sell his items at 1/2 the price in items.dat.  Any item that has the 
                "Can be sold" field in the items.dat file set to 'no' will be greyed and if 
                the player chooses that item a box will appear saying "They don't seem 
                interested in that".  It is highly recommended that there be a routine such as
                @clear screen
                @do write
                `cSo what do you want to sell?
                @SELLMANAGER
                OR
                @clear screen
                @show
                `cSo what do you want to sell
                @SELLMANAGER
                The `c is included so that there will be two carriage returns issued.  This is 
                important for cosmetic purposes only.  I have found that if the @sellmanager
                is issued at the top of the screen, the boxes don't dissapear as they should. */
            LogMissing(tokens);
        }

        private void CommandSHOW(string[] tokens)
        {
            if ((tokens.Length > 1) && (tokens[1].ToUpper() == "SCROLL"))
            {
                /* @SHOW SCROLL          
                    Same thing, but puts all the text in a nifty scroll window. (scroll window has 
                    commands line Next Screen, Previous Screen, Start, and End. */
                _InSHOWSCROLLLines.Clear();
                _InSHOWSCROLL = true;
            }
            else
            {
                /* @SHOW           
                    Shows following text/ansi.  Stops when a @ is hit on beginning of line. */
                _InSHOW = true;
            }
        }

        private void CommandSHOWLOCAL(string[] tokens)
        {
            /* @SHOWLOCAL
                Undocumented.  Same as @SHOW, but only outputs to local window */
            _InSHOWLOCAL = true;
        }

        private void CommandSTATBAR(string[] tokens)
        {
            /* @STATBAR
                This draws the statbar. */
            LogUnused(tokens);
        }

        private void CommandUPDATE(string[] tokens)
        {
            /* @UPDATE
                Draws all the people on the screen. */
            EventHandler Handler = RTGlobal.OnUPDATE;
            if (Handler != null) Handler(null, EventArgs.Empty);
        }

        private void CommandUPDATE_UPDATE(string[] tokens)
        {
            /* @UPDATE_UPDATE
                This command writes current player data to UPDATE.TMP file.  This is useful 
                when you just can't wait until the script is finished for some reason. */
            LogMissing(tokens);
        }

        private void CommandVERSION(string[] tokens)
        {
            /* @VERSION  <Version it needs>  
                For instance, you would put @VERSION 2 for this version of RTREADER.  (002) If 
                it is run on Version 1, (could happen) a window will pop up warning the person 
                he had better get the latest version. */
            int RequiredVersion = Convert.ToInt32(tokens[1]);
            if (RequiredVersion > _Version) throw new ArgumentOutOfRangeException("VERSION", "@VERSION requested version " + RequiredVersion + ", we only support version " + _Version);
        }

        private void CommandWHOISON(string[] tokens)
        {
            /* @WHOISON
                Undocumented.  Will need to find out what this does */
            LogMissing(tokens);
        }

        private void CommandWRITEFILE(string[] tokens)
        {
            /* @WRITEFILE <file name>
                <Thing to write>
                <Thing to write>
                <ect until next @ at beginning of string is hit>
                <Thing to write> can be a varible, (string or num) or it can be a word you 
                write - or a combination of the two.
                Note:  @WRITEFILE appends the lines if the file exists, otherwise it creates 
                it.  File locking techniques are used. */
            _InWRITEFILE = Global.GetSafeAbsolutePath(TranslateVariables(tokens[1]));
        }

        private void EndCHOICE()
        {
            /* @CHOICE
                <A choice>
                <another choice>
                <ect..When a @ is found in the beginning of a choice it quits>
                This gives the user a choice using a lightbar.
                The responce is put into varible RESPONCE.  This may also be spelled RESPONSE. 
                To set which choice the cursor starts on, put that number into `V01.
                ** EXAMPLE OF @CHOICE COMMAND **
                @DO `V01 IS 1 ;which choice should be highlighted when they start
                (now the actual choice command)
                @CHOICE
                Yes   <- Defaults to this, since it's 1
                No
                I don't know
                Who cares
                @IF RESPONCE IS 3 THEN DO
                  @BEGIN
                  @DO `P01 IS RESPONCE
                  @SHOW

                You chose `P01!, silly boy!

                  @END
                The choice command is more useful now; you can now define *IF* type statements 
                so a certain choice will only be there if a conditional statement is met.
                For instance:
                @CHOICE
                Yes
                No
                =`p20 500 Hey, I have 500 exactly!
                !`p20 500 Hey, I have anything BUT 500 exactly!
                >`p20 500 Hey, I have MORE than 500!
                <`p20 100 Hey, I have LESS than 100!
                >`p20 100 <`p20 500 I have more then 100 and less than 500!
                Also:  You can check the status of individual bits in a `T player byte.  The 
                bit is true or false, like this:
                +`t12 1 Hey! Byte 12's bit 1 is TRUE! (which is 1)
                -`t12 3 Hey! Byte 12's bit 3 is FALSE! (which is 0)

                The = > and < commands can be stacked as needed.  In the above example, if 
                `p20 was 600, only options 1, 2, 4, and 5 would be available, and RESPONSE 
                would be set to the correct option if one of those were selected.  For 
                example, if `p20 was 600 and the user hit the selection:
                "Hey, I have more than 500", RESPONSE would be set to 5. */


            // Determine which options are Visible and assign VisibleIndex
            int VisibleCount = 0;
            int LastVisibleLength = 0;

            char[] IfChars = { '=', '!', '>', '<', '+', '-' };
            for (int i = 0; i < _InCHOICEOptions.Count; i++)
            {
                bool MakeVisible = true;

                // Parse out the IF statements
                while (Array.IndexOf(IfChars, _InCHOICEOptions[i].Text[0]) != -1)
                {
                    // Extract operator
                    char Operator = _InCHOICEOptions[i].Text[0];
                    _InCHOICEOptions[i].Text = _InCHOICEOptions[i].Text.Substring(1);

                    // Extract variable and translate
                    string Variable = _InCHOICEOptions[i].Text.Split(' ')[0];
                    _InCHOICEOptions[i].Text = _InCHOICEOptions[i].Text.Substring(Variable.Length + 1);
                    Variable = TranslateVariables(Variable);

                    // Extract value
                    string Value = _InCHOICEOptions[i].Text.Split(' ')[0];
                    _InCHOICEOptions[i].Text = _InCHOICEOptions[i].Text.Substring(Value.Length + 1);

                    // Determine result of if
                    switch (Operator)
                    {
                        case '=':
                            MakeVisible = MakeVisible && (Convert.ToInt32(Variable) == Convert.ToInt32(Value));
                            break;
                        case '!':
                            MakeVisible = MakeVisible && (Convert.ToInt32(Variable) != Convert.ToInt32(Value));
                            break;
                        case '>':
                            MakeVisible = MakeVisible && (Convert.ToInt32(Variable) > Convert.ToInt32(Value));
                            break;
                        case '<':
                            MakeVisible = MakeVisible && (Convert.ToInt32(Variable) < Convert.ToInt32(Value));
                            break;
                        case '+':
                            MakeVisible = MakeVisible && ((Convert.ToInt32(Variable) & (1 << Convert.ToInt32(Value))) != 0);
                            break;
                        case '-':
                            MakeVisible = MakeVisible && ((Convert.ToInt32(Variable) & (1 << Convert.ToInt32(Value))) == 0);
                            break;
                    }
                }

                // Determine if option is visible
                if (MakeVisible)
                {
                    VisibleCount += 1;
                    LastVisibleLength = Door.StripSeth(_InCHOICEOptions[i].Text).Length;
                    _InCHOICEOptions[i].Visible = true;
                    _InCHOICEOptions[i].VisibleIndex = VisibleCount;
                }
                else
                {
                    _InCHOICEOptions[i].Visible = false;
                }
            }

            // Ensure `V01 specified a valid/visible selection
            int SelectedIndex = Convert.ToInt32(TranslateVariables("`V01"));
            if ((SelectedIndex < 1) || (SelectedIndex > _InCHOICEOptions.Count)) SelectedIndex = 1;
            while (!_InCHOICEOptions[SelectedIndex - 1].Visible) SelectedIndex += 1;

            // Determine how many spaces to indent by (all lines should be indented same as first line)
            string Spaces = "\r\n" + new string(' ', Crt.WhereX() - 1);

            // Output options
            Door.CursorSave();
            Door.TextAttr(15);
            for (int i = 0; i < _InCHOICEOptions.Count; i++)
            {
                if (_InCHOICEOptions[i].Visible)
                {
                    if (_InCHOICEOptions[i].VisibleIndex > 1) Door.Write(Spaces);
                    if (i == (SelectedIndex - 1)) Door.TextBackground(Crt.Blue);
                    Door.Write(TranslateVariables(_InCHOICEOptions[i].Text));
                    if (i == (SelectedIndex - 1)) Door.TextBackground(Crt.Black);
                }
            }

            // Get response
            char? Ch = null;
            while (Ch != '\r')
            {
                int OldSelectedIndex = SelectedIndex;

                Ch = Door.ReadKey();
                switch (Ch)
                {
                    case '8':
                    case '4':
                        while (true)
                        {
                            // Go to previous item
                            SelectedIndex -= 1;

                            // Wrap to bottom if we were at the top item
                            if (SelectedIndex < 1) SelectedIndex = _InCHOICEOptions.Count;

                            // Check if new selected item is visible (and break if so)
                            if (_InCHOICEOptions[SelectedIndex - 1].Visible) break;
                        }
                        break;
                    case '6':
                    case '2':
                        while (true)
                        {
                            // Go to previous item
                            SelectedIndex += 1;

                            // Wrap to bottom if we were at the top item
                            if (SelectedIndex > _InCHOICEOptions.Count) SelectedIndex = 1;

                            // Check if new selected item is visible (and break if so)
                            if (_InCHOICEOptions[SelectedIndex - 1].Visible) break;
                        }
                        break;
                }

                if (OldSelectedIndex != SelectedIndex)
                {
                    // Store new selection
                    AssignVariable("`V01", SelectedIndex.ToString());

                    // Redraw old selection without blue highlight
                    Door.CursorRestore();
                    if (_InCHOICEOptions[OldSelectedIndex - 1].VisibleIndex > 1) Door.CursorDown(_InCHOICEOptions[OldSelectedIndex - 1].VisibleIndex - 1);
                    Door.Write(TranslateVariables(_InCHOICEOptions[OldSelectedIndex - 1].Text));

                    // Draw new selection with blue highlight
                    Door.CursorRestore();
                    if (_InCHOICEOptions[SelectedIndex - 1].VisibleIndex > 1) Door.CursorDown(_InCHOICEOptions[SelectedIndex - 1].VisibleIndex - 1);
                    Door.TextBackground(Crt.Blue);
                    Door.Write(TranslateVariables(_InCHOICEOptions[SelectedIndex - 1].Text));
                    Door.TextBackground(Crt.Black);
                }
            }

            // Move cursor below choice statement
            Door.CursorRestore();
            Door.CursorDown(VisibleCount - 1);
            Door.CursorRight(LastVisibleLength);

            // Update global variable responses
            RTGlobal.ReadOnlyVariables["RESPONCE"] = SelectedIndex.ToString();
            RTGlobal.ReadOnlyVariables["RESPONSE"] = SelectedIndex.ToString();
        }

        private void EndSHOWSCROLL()
        {
            char? Ch = null;
            int Page = 1;
            int MaxPage = Convert.ToInt32(Math.Truncate(_InSHOWSCROLLLines.Count / 22.0));
            if (_InSHOWSCROLLLines.Count % 22 != 0) MaxPage += 1;
            int SavedAttr = 7;

            while (Ch != 'Q')
            {
                Door.TextAttr(SavedAttr);
                Door.ClrScr();

                int LineStart = (Page - 1) * 22;
                int LineEnd = LineStart + 21;
                for (int i = LineStart; i <= LineEnd; i++)
                {
                    if (i >= _InSHOWSCROLLLines.Count) break;
                    Door.WriteLn(_InSHOWSCROLLLines[i]);
                }
                SavedAttr = Crt.TextAttr;

                Door.GotoXY(1, 23);
                Door.TextAttr(31);
                Door.Write(new string(' ', 79));
                Door.GotoXY(3, 23);
                Door.Write("(" + Page + ")");
                Door.GotoXY(9, 23);
                Door.Write("[N]ext Page, [P]revious Page, [Q]uit, [S]tart, [E]nd");

                Ch = Door.ReadKey();
                if (Ch != null)
                {
                    Ch = char.ToUpper((char)Ch);
                    switch (Ch)
                    {
                        case 'E': Page = MaxPage; break;
                        case 'N': Page = Math.Min(MaxPage, Page + 1); break;
                        case 'P': Page = Math.Max(1, Page - 1); break;
                        case 'S': Page = 1; break;
                    }
                }
            }
        }

        private void LogMissing(string[] tokens)
        {
            string Output = "MISSING (hit a key): " + string.Join(" ", tokens);
            Crt.FastWrite(StringUtils.PadRight(Output, ' ', 80), 1, 25, 31);
            Crt.ReadKey();
            Crt.FastWrite(new string(' ', 80), 1, 25, 0);
        }

        private void LogUnused(string[] tokens)
        {
            string Output = "UNUSED?!? (hit a key): " + string.Join(" ", tokens);
            Crt.FastWrite(StringUtils.PadRight(Output, ' ', 80), 1, 25, 31);
            Crt.ReadKey();
            Crt.FastWrite(new string(' ', 80), 1, 25, 0);
        }

        public int RunSection(string fileName, string sectionName)
        {
            return RunSection(fileName, sectionName, "");
        }

        public int RunSection(string fileName, string sectionName, string labelName)
        {
            // Run the selected script
            string FileNameWithoutExtension = Path.GetFileNameWithoutExtension(fileName);
            if (RTGlobal.RefFiles.ContainsKey(FileNameWithoutExtension))
            {
                _CurrentFile = RTGlobal.RefFiles[FileNameWithoutExtension];
                if (_CurrentFile.Sections.ContainsKey(sectionName))
                {
                    // Load section, check if requested label exists, and run script
                    _CurrentSection = _CurrentFile.Sections[sectionName];
                    if (_CurrentSection.Labels.ContainsKey(labelName)) _CurrentLineNumber = _CurrentSection.Labels[labelName];
                    RunScript(_CurrentSection.Script.ToArray());

                    // Return the errorcode from _InHALT (which is int.MinValue if no error code)
                    return _InHALT;
                }
                else
                {
                    Door.WriteLn(TranslateVariables("`4`b**`b `%ERROR : `0" + sectionName + " `2not found in `0" + Path.GetFileName(fileName) + " `4`b**`b`2"));
                    Door.ReadKey();
                    return 1;
                }
            }
            else
            {
                Door.WriteLn(TranslateVariables("`4`b**`b `%ERROR : `2File `0" + Path.GetFileName(fileName) + " `2not found. `4`b**`b`2"));
                Door.ReadKey();
                return 2;
            }
        }

        private void RunScript(string[] script)
        {
            while (_CurrentLineNumber < script.Length)
            {
                string Line = script[_CurrentLineNumber];
                string LineTrimmed = Line.Trim();

                if (_InCLOSESCRIPT)
                {
                    return;
                }
                else if (_InHALT != int.MinValue)
                {
                    return;
                }
                else if (_InIFFalse < 999)
                {
                    if (LineTrimmed.StartsWith("@"))
                    {
                        string[] Tokens = LineTrimmed.Split(' ');
                        switch (Tokens[0].ToUpper())
                        {
                            case "@BEGIN":
                                _InBEGINCount += 1;
                                break;
                            case "@END":
                                _InBEGINCount -= 1;
                                if (_InBEGINCount == _InIFFalse) _InIFFalse = 999;
                                break;
                        }
                    }
                }
                else
                {
                    if (LineTrimmed.StartsWith("@"))
                    {
                        if (_InCHOICE) EndCHOICE();
                        if (_InSHOWSCROLL) EndSHOWSCROLL();
                        _InCHOICE = false;
                        _InSAY = false;
                        _InSAYBAR = false;
                        _InSHOW = false;
                        _InSHOWLOCAL = false;
                        _InSHOWSCROLL = false;
                        _InWRITEFILE = "";

                        string[] Tokens = LineTrimmed.Split(' ');
                        if (_Commands.ContainsKey(Tokens[0]))
                        {
                            _Commands[Tokens[0]](Tokens);
                        }
                        else
                        {
                            LogMissing(Tokens);
                        }
                    }
                    else
                    {
                        if (_InCHOICE)
                        {
                            _InCHOICEOptions.Add(new RTChoiceOption(Line));
                        }
                        else if (_InDO_ADDLOG)
                        {
                            FileUtils.FileAppendAllText(Global.GetSafeAbsolutePath("LOGNOW.TXT"), TranslateVariables(Line));
                            _InDO_ADDLOG = false;
                        }
                        else if (_InDO_WRITE)
                        {
                            Door.Write(TranslateVariables(Line));
                            _InDO_WRITE = false;
                        }
                        else if (_InSAY)
                        {
                            // TODO SHould be in TEXT window (but since LORD2 doesn't use @SAY, not a high priority)
                            Door.Write(TranslateVariables(Line));
                        }
                        else if (_InSAYBAR)
                        {
                            // Save cursor and text attr
                            int SavedTextAttr = Crt.TextAttr;
                            Door.CursorSave();

                            // Output new bar
                            Door.GotoXY(3, 21);
                            Door.TextAttr(31);
                            int StrippedLength = Door.StripSeth(TranslateVariables(Line)).Length;
                            int LeftSpaces = Math.Max(0, (76 - StrippedLength) / 2);
                            int RightSpaces = Math.Max(0, 76 - StrippedLength - LeftSpaces);
                            Door.Write(new string(' ', LeftSpaces) + TranslateVariables(Line) + new string(' ', RightSpaces));
                            // TODO say bar should be removed after 3 seconds or so

                            // Restore
                            Door.CursorRestore();
                            Door.TextAttr(SavedTextAttr);

                            _InSAYBAR = false;
                        }
                        else if (_InSHOW)
                        {
                            Door.WriteLn(TranslateVariables(Line));
                        }
                        else if (_InSHOWLOCAL)
                        {
                            Ansi.Write(TranslateVariables(Line) + "\r\n");
                        }
                        else if (_InSHOWSCROLL)
                        {
                            _InSHOWSCROLLLines.Add(TranslateVariables(Line));
                        }
                        else if (_InWRITEFILE != "")
                        {
                            FileUtils.FileAppendAllText(_InWRITEFILE, TranslateVariables(Line) + Environment.NewLine, RMEncoding.Ansi);
                        }
                    }
                }

                _CurrentLineNumber += 1;
            }
        }

        private string TranslateVariables(string input)
        {
            string inputUpper = input.ToUpper();

            if (input.Contains("`"))
            {
                if (inputUpper.Contains("`I"))
                {
                    foreach (KeyValuePair<string, short> KVP in RTGlobal.I)
                    {
                        input = Regex.Replace(input, Regex.Escape(KVP.Key), KVP.Value.ToString(), RegexOptions.IgnoreCase);
                    }
                }
                if (inputUpper.Contains("`P"))
                {
                    foreach (KeyValuePair<string, int> KVP in RTGlobal.P)
                    {
                        input = Regex.Replace(input, Regex.Escape(KVP.Key), KVP.Value.ToString(), RegexOptions.IgnoreCase);
                    }
                }
                if (inputUpper.Contains("`+"))
                {
                    foreach (KeyValuePair<string, string> KVP in RTGlobal.PLUS)
                    {
                        input = Regex.Replace(input, Regex.Escape(KVP.Key), KVP.Value, RegexOptions.IgnoreCase);
                    }
                }
                if (inputUpper.Contains("`S"))
                {
                    foreach (KeyValuePair<string, string> KVP in RTGlobal.S)
                    {
                        input = Regex.Replace(input, Regex.Escape(KVP.Key), KVP.Value, RegexOptions.IgnoreCase);
                    }
                }
                if (inputUpper.Contains("`T"))
                {
                    foreach (KeyValuePair<string, byte> KVP in RTGlobal.T)
                    {
                        input = Regex.Replace(input, Regex.Escape(KVP.Key), KVP.Value.ToString(), RegexOptions.IgnoreCase);
                    }
                }
                if (inputUpper.Contains("`V"))
                {
                    foreach (KeyValuePair<string, int> KVP in RTGlobal.V)
                    {
                        input = Regex.Replace(input, Regex.Escape(KVP.Key), KVP.Value.ToString(), RegexOptions.IgnoreCase);
                    }
                }
            }
            foreach (KeyValuePair<string, string> KVP in RTGlobal.LanguageVariables)
            {
                // TODO This shouldn't happen for @SHOW and @DO WRITE, so maybe we need a TranslateVariables() that excludes this, and TranslateVariablesForLogic() that includes this (then any non-output code would use the logic call)
                // TODO Since we look for an exact match, it may not matter anyway (since what are the odds a @SHOW only has the word MAP on a line, for example)
                // TODO These need to be kept in sync (for example if c# code changes Global.Player.Bank)
                // TODO Maybe they shouldn't be variables, and there should just be a long list of Regex.Replaces for each variable, linking directly into the player record
                if (inputUpper == KVP.Key.ToUpper()) input = KVP.Value;
            }
            foreach (KeyValuePair<string, string> KVP in RTGlobal.ReadOnlyVariables)
            {
                // TODO s& should be lowercasing the first letter, S& uppercasing
                // TODO These need to be kept in sync (for example if c# code changes Global.Player.Bank)
                // TODO Maybe they shouldn't be variables, and there should just be a long list of Regex.Replaces for each variable, linking directly into the player record
                input = Regex.Replace(input, Regex.Escape(KVP.Key), KVP.Value.ToString(), RegexOptions.IgnoreCase);
            }

            return input;
        }
    }
}
