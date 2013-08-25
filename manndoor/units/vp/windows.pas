//ÛßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßÛ
//Û                                                      Û
//Û     Virtual Pascal Runtime Library.  Version 2.1     Û
//Û     Windows API interface unit including Open32      Û
//Û     ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÛ
//Û     Copyright (C) 2000 vpascal.com                   Û
//Û                                                      Û
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

{$IFDEF Open32}
  {&cdecl+}
{$ELSE}
  {&StdCall+}
{$ENDIF Open32}
{&AlignRec+,SmartLink+,OrgName+,X+,Z+,Delphi+,Use32-}

unit Windows;

interface

{ Open32 compatibility layer }

{---[ Basic types]---}

type
  Integer       = Longint;
  Short         = SmallInt;
  PShort        = ^Short;
  LPShort       = ^Short;
  Int           = Longint;
  PInt          = ^Int;
  LPInt         = ^Int;
  Long          = Longint;
  PLong         = ^Long;
  LPLong        = ^Long;
  UChar         = Byte;
  PUChar        = ^UChar;
  LPUChar       = ^UChar;
  UShort        = SmallWord;
  PUShort       = ^Short;
  LPUShort      = ^Short;
  UInt          = Longint;
  PUInt         = ^UInt;
  LPUInt        = ^UInt;
  ULong         = Longint;
  PULong        = ^ULong;
  LPULong       = ^ULong;
  PVoid         = Pointer;
  LPVoid        = Pointer;
  Float         = Single;
  PFloat        = ^Float;
  LPFloat       = ^Float;
  PByte         = ^Byte;
  LPByte        = ^Byte;
  PWord         = ^SmallWord;
  LPWord        = ^SmallWord;
  DWord         = Longint;
  PDWord        = ^DWord;
  LPDWord       = ^DWord;
  Bool          = LongBool;
  PBool         = ^Bool;
  LPBool        = ^Bool;
  wParam        = Longint;
  lParam        = Longint;
  lResult       = Longint;
  HResult       = Longint;
  Handle        = Longint;
  THandle       = Longint;
  PHandle       = ^THandle;
  LPHandle      = ^THandle;
  SPHandle      = ^THandle;
  wchar_t       = SmallWord;
  WideChar      = Char;
  PWideChar     = ^WideChar;
  WChar         = SmallWord;
  PWChar        = ^WChar;
  PWCh          = ^WChar;
  LPWCh         = ^WChar;
  PCWCh         = ^WChar;
  LPCWCh        = ^WChar;
  NWPSTR        = ^WChar;
  LPWSTR        = ^WChar;
  PWSTR         = ^WChar;
  LPCWSTR       = ^WChar;
  PCWSTR        = ^WChar;
  PSz           = PChar;
  LPSz          = PChar;
  PCSz          = PChar;
  LPCSz         = PChar;
  LPChar        = PChar;
  LPCH          = PChar;
  PCH           = PChar;
  LPCCH         = PChar;
  PCCH          = PChar;
  NPSTR         = PChar;
  LPSTR         = PChar;
  PSTR          = PChar;
  LPTCH         = PChar;
  LPCSTR        = PChar;
  PCSTR         = PChar;
  PTCH          = PChar;
  PTSTR         = PChar;
  LPTSTR        = PChar;
  LPCTSTR       = PChar;
  TChar         = Char;
  PTCHAR        = PChar;
  TByte         = Byte;
  PTByte        = ^Byte;
  PInteger      = ^Integer;
  PLongint      = ^Longint;
  PSingle       = ^Single;

  TAtom         = SmallWord;
  Atom          = SmallWord;
  TColorRef     = Longint;
  HAccel        = THandle;
  HBitmap       = THandle;
  HBrush        = THandle;
  HCursor       = THandle;
  HDC           = THandle;
  HDWP          = THandle;
  HEnhMetafile  = THandle;
  HFile         = THandle;
  HFont         = THandle;
  HGDIObj       = THandle;
  PHGDIObj      = PHandle;
  HGlobal       = THandle;
  HHook         = THandle;
  HIcon         = THandle;
  hInst         = THandle;
  HKey          = DWord;
  PHKey         = ^DWord;
  HLocal        = THandle;
  hMenu         = THandle;
  HMetafile     = THandle;
  hModule       = THandle;
  HPalette      = THandle;
  HPen          = THandle;
  HRgn          = THandle;
  HrSrc         = THandle;
  HStr          = THandle;
  hWnd          = THandle;
  TGlobalHandle = THandle;
  TLocalHandle  = THandle;
  MMResult      = Longint;
  TFarProc      = Pointer;
  FarProc       = Pointer;
  LoByte        = Byte;
  LoWord        = SmallWord;
  MakeIntResource = PChar;
  MakeIntAtom   = PChar;

  TFNWndProc            = TFarProc;
  TFNDlgProc            = TFarProc;
  TFNThreadStartRoutine = TFarProc;
  TFNWndEnumProc        = TFarProc;
  TFNEnhMFEnumProc      = TFarProc;
  TFNFontEnumProc       = TFarProc;
  TFNMFEnumProc         = TFarProc;
  TFNGObjEnumProc       = TFarProc;
  TFNPropEnumProc       = TFarProc;
  TFNPropEnumProcEx     = TFarProc;
  TFNLineDDAProc        = TFarProc;
  TFNTimerProc          = TFarProc;
  TFNHookProc           = function (Code: Integer; WP: wParam; LP: lParam): lResult;

  TFNMain               = function(Inst,PrevInst: hInst; CmdLine: PChar; CmdShow: Integer): Integer;
  TWndProc              = function(Wnd: hWnd; Msg: UInt; WP: wParam; LP: lParam): lResult;
  TOFNHookProc          = function(Wnd: hWnd; Msg: UInt; WP: wParam; LP: lParam): Longint;
  TDlgProc              = function(Wnd: hWnd; Msg: UInt; WP: wParam; LP: lParam): Bool;
  TTimerProc            = procedure(Wnd: hWnd; Msg: UInt; WP: wParam; LP: lParam);
  TFNAbortProc          = function(DC: HDC; Code: Integer): Bool;
  TPrintHookProc        = function(Wnd: hWnd; Msg: UInt; WP: wParam; LP: lParam): UInt;
  TSetupHookProc        = function(Wnd: hWnd; Msg: UInt; WP: wParam; LP: lParam): UInt;
  TThreadStartRoutine   = function(lpThreadParameter: Pointer): Integer;
  TGObjEnumProc         = function(LogObject: Pointer; Data: lParam): Integer;
  TLineDDAProc          = procedure(X,Y: Integer; Data: lParam);
  TWndEnumProc          = function(Wnd: hWnd; LP: lParam): Bool;
  TPropEnumProc         = function(Wnd: hWnd; Str: PChar; hData: THandle): Bool;
  TFRHookProc           = function(Wnd: hWnd; Msg: UInt; WP: wParam; LP: lParam): UInt;
  TGrayStringProc       = function(DC: HDC; Data: lParam; cchData: Integer): Bool;
  TCCHookProc           = function(Wnd: hWnd; Msg: UInt; WP: wParam; LP: lParam): UInt;
  TCFHookProc           = function(Wnd: hWnd; Msg: UInt; WP: wParam; LP: lParam): UInt;
  TPropEnumProcEx       = function(Wnd: hWnd; Str: PChar; hData: THandle; Data: DWord): Bool;

{---[ Types and constants ]---}

const
  MinChar                       = $80;
  MaxChar                       = $7F;
  MinShort                      = $8000;
  MaxShort                      = $7FFF;
  MinLong                       = $80000000;
  MaxLong                       = $7FFFFFFF;
  MaxByte                       = $FF;
  MaxWord                       = $FFFF;
  MaxDWord                      = $FFFFFFFF;
  Thread_Priority_Error_Return  = MaxLong;

  invalid_Handle_Value          = Handle(-1);
  hfile_Error                   = Handle(-1);
  hwnd_Desktop                  = hWnd(0);
  hwnd_Broadcast                = hWnd($FFFF);
  std_Input_Handle              = DWord(-10);
  std_Output_Handle             = DWord(-11);
  std_Error_Handle              = DWord(-12);

{ wm_Size Types }

  size_Restored                 = 0;
  size_Minimized                = 1;
  size_Maximized                = 2;
  size_MaxShow                  = 3;
  size_MaxHide                  = 4;
  sizeFullScreen                = size_Maximized;
  sizeIconic                    = size_Minimized;
  sizeNormal                    = size_Restored;
  sizeZoomHide                  = size_MaxHide;
  sizeZoomShow                  = size_MaxShow;

{ Window Styles }

  ws_Overlapped         = $00000000;
  ws_Popup              = $80000000;
  ws_Child              = $40000000;
  ws_Minimize           = $20000000;
  ws_Visible            = $10000000;
  ws_Disabled           = $08000000;
  ws_ClipSiblings       = $04000000;
  ws_ClipChildren       = $02000000;
  ws_Maximize           = $01000000;
  ws_Border             = $00800000;
  ws_DlgFrame           = $00400000;
  ws_VScroll            = $00200000;
  ws_HScroll            = $00100000;
  ws_SysMenu            = $00080000;
  ws_ThickFrame         = $00040000;
  ws_Group              = $00020000;
  ws_TabStop            = $00010000;
  ws_MinimizeBox        = $00020000;
  ws_MaximizeBox        = $00010000;
  ws_ChildWindow        = ws_Child;
  ws_Iconic             = ws_Minimize;
  ws_SizeBox            = ws_ThickFrame;
  ws_Tiled              = ws_Overlapped;
  ws_Caption            = ws_Border or ws_DlgFrame;
  ws_OverlappedWindow   = ws_Overlapped or ws_Caption or ws_SysMenu
                          or ws_ThickFrame or ws_MinimizeBox or ws_MaximizeBox;
  ws_TiledWindow        = ws_OverlappedWindow;
  ws_PopupWindow        = ws_Popup or ws_Border or ws_SysMenu;
  ws_Ex_TopMost         = $00000008;
  ws_Ex_AcceptFiles     = $00000010;
  cw_UseDefault         = $80000000;

{ Class Styles }

  cs_VRedraw                    = $0001;
  cs_HRedraw                    = $0002;
  cs_KeyCvtWindow               = $0004;
  cs_DblClks                    = $0008;
  cs_OwnDC                      = $0020;
  cs_ClassDC                    = $0040;
  cs_ParentDC                   = $0080;
  cs_NoKeyCvt                   = $0100;
  cs_NoClose                    = $0200;
  cs_SaveBits                   = $0800;
  cs_ByteAlignClient            = $1000;
  cs_ByteAlignWindow            = $2000;
  cs_GlobalClass                = $4000;


{ Window bytes needed for private dialogs }

  dlgWindowExtra                = 30;

{ MessageBox Flags }

  mb_Ok                         = $00000000;
  mb_OkCancel                   = $00000001;
  mb_AbortRetryIgnore           = $00000002;
  mb_YesNoCancel                = $00000003;
  mb_YesNo                      = $00000004;
  mb_RetryCancel                = $00000005;
  mb_IconHand                   = $00000010;
  mb_IconQuestion               = $00000020;
  mb_IconExclamation            = $00000030;
  mb_IconAsterisk               = $00000040;
  mb_IconInformation            = mb_IconAsterisk;
  mb_IconStop                   = mb_IconHand;
  mb_DefButton1                 = $00000000;
  mb_DefButton2                 = $00000100;
  mb_DefButton3                 = $00000200;
  mb_ApplModal                  = $00000000;
  mb_SystemModal                = $00001000;
  mb_NoFocus                    = $00008000;
  mb_SetForeground              = $00010000;
  mb_Service_Notification       = $00040000;
  mb_TypeMask                   = $0000000F;
  mb_IconMask                   = $000000F0;
  mb_DefMask                    = $00000F00;
  mb_ModeMask                   = $00003000;
  mb_MiscMask                   = $0000C000;

{ Predefined Resource Types }

  rt_Cursor                     = MakeIntResource(1);
  rt_Bitmap                     = MakeIntResource(2);
  rt_Icon                       = MakeIntResource(3);
  rt_Menu                       = MakeIntResource(4);
  rt_Dialog                     = MakeIntResource(5);
  rt_String                     = MakeIntResource(6);
  rt_FontDir                    = MakeIntResource(7);
  rt_Font                       = MakeIntResource(8);
  rt_Accelerator                = MakeIntResource(9);
  rt_RcData                     = MakeIntResource(10);
  rt_MessageTable               = MakeIntResource(11);
  rt_DlgInclude                 = MakeIntResource(17);

{ System Icons }

  idi_Application               = MakeIntResource(32512);
  idi_Hand                      = MakeIntResource(32513);
  idi_Question                  = MakeIntResource(32514);
  idi_Exclamation               = MakeIntResource(32515);
  idi_Asterisk                  = MakeIntResource(32516);

{ System cursors }

  idc_Arrow                     = MakeIntResource(32512);
  idc_Ibeam                     = MakeIntResource(32513);
  idc_Wait                      = MakeIntResource(32514);
  idc_Cross                     = MakeIntResource(32515);
  idc_UpArrow                   = MakeIntResource(32516);
  idc_Size                      = MakeIntResource(32640);
  idc_Icon                      = MakeIntResource(32641);
  idc_SizeNwse                  = MakeIntResource(32642);
  idc_SizeNesw                  = MakeIntResource(32643);
  idc_SizeWe                    = MakeIntResource(32644);
  idc_SizeNs                    = MakeIntResource(32645);
  idc_SizeAll                   = MakeIntResource(32646);
  idc_No                        = MakeIntResource(32648);
  idc_AppStarting               = MakeIntResource(32650);

{ System Bitmaps }

  obm_Close                     = 32754;
  obm_Uparrow                   = 32753;
  obm_Dnarrow                   = 32752;
  obm_Rgarrow                   = 32751;
  obm_Lfarrow                   = 32750;
  obm_Reduce                    = 32749;
  obm_Zoom                      = 32748;
  obm_Restore                   = 32747;
  obm_Reduced                   = 32746;
  obm_ZoomD                     = 32745;
  obm_RestoreD                  = 32744;
  obm_UpArrowD                  = 32743;
  obm_DnArrowD                  = 32742;
  obm_RgArrowD                  = 32741;
  obm_LfArrowD                  = 32740;
  obm_MnArrow                   = 32739;
  obm_Combo                     = 32738;
  obm_UpArrowI                  = 32737;
  obm_DnArrowI                  = 32736;
  obm_RgArrowI                  = 32735;
  obm_LfArrowI                  = 32734;
  obm_Old_Close                 = 32767;
  obm_Size                      = 32766;
  obm_Old_UpArrow               = 32765;
  obm_Old_DnArrow               = 32764;
  obm_Old_RgArrow               = 32763;
  obm_Old_LfArrow               = 32762;
  obm_BtSize                    = 32761;
  obm_Check                     = 32760;
  obm_CheckBoxes                = 32759;
  obm_BtnCorners                = 32758;
  obm_Old_Reduce                = 32757;
  obm_Old_Zoom                  = 32756;
  obm_Old_Restore               = 32755;

{ Device Capabilities Indices }

  DriverVersion                 = 0;
  Technology                    = 2;
  HorzSize                      = 4;
  VertSize                      = 6;
  HorzRes                       = 8;
  VertRes                       = 10;
  BitsPixel                     = 12;
  Planes                        = 14;
  NumFonts                      = 22;
  NumColors                     = 24;
  PDeviceSize                   = 26;
  CurveCaps                     = 28;
  LineCaps                      = 30;
  PolygonalCaps                 = 32;
  TextCaps                      = 34;
  ClipCaps                      = 36;
  RasterCaps                    = 38;
  AspectX                       = 40;
  AspectY                       = 42;
  AspectXY                      = 44;
  LogPixelsX                    = 88;
  LogPixelsY                    = 90;
  SizePalette                   = 104;
  NumReserved                   = 106;
  ColorRes                      = 108;
  PhysicalWidth                 = 110;
  PhysicalHeight                = 111;
  PhysicalOffsetX               = 112;
  PhysicalOffsetY               = 113;
  ScalingFactorX                = 114;
  ScalingFactorY                = 115;

{ Device Technologies }

  dt_Plotter                    = 0;
  dt_RasDisplay                 = 1;
  dt_RasPrinter                 = 2;
  dt_RasCamera                  = 3;
  dt_Metafile                   = 5;

{ Raster Capabilities }

  rc_BitBlt                     = $0001;
  rc_Banding                    = $0002;
  rc_Scaling                    = $0004;
  rc_Bitmap64                   = $0008;
  rc_Di_Bitmap                  = $0080;
  rc_Palette                    = $0100;
  rc_DibToDev                   = $0200;
  rc_StretchBlt                 = $0800;
  rc_FloodFill                  = $1000;
  rc_StretchDib                 = $2000;

  cc_None                       = 0;
  cc_Circles                    = 1;
  cc_Pie                        = 2;
  cc_Chord                      = 4;
  cc_Ellipses                   = 8;
  cc_Wide                       = 16;
  cc_Styled                     = 32;
  cc_WideStyled                 = 64;
  cc_Interiors                  = 128;
  cc_RoundRect                  = 256;

  lc_None                       = 0;
  lc_PolyLine                   = 2;
  lc_Marker                     = 4;
  lc_PolyMarker                 = 8;
  lc_Wide                       = 16;
  lc_Styled                     = 32;
  lc_WideStyled                 = 64;
  lc_Interiors                  = 128;

  pc_None                       = 0;
  pc_Polygon                    = 1;
  pc_Rectangle                  = 2;
  pc_Windpolygon                = 4;
  pc_Trapezoid                  = 4;
  pc_Scanline                   = 8;
  pc_Wide                       = 16;
  pc_Styled                     = 32;
  pc_Widestyled                 = 64;
  pc_Interiors                  = 128;

  tc_Cr_90                      = $00000008;
  tc_Cr_Any                     = $00000010;
  tc_Sf_X_YIndep                = $00000020;
  tc_Sa_Integer                 = $00000080;
  tc_Sa_Contin                  = $00000100;
  tc_Ia_Able                    = $00000400;
  tc_Ua_Able                    = $00000800;
  tc_So_Able                    = $00001000;
  tc_Ra_Able                    = $00002000;
  tc_Va_Able                    = $00004000;
  tc_Reserved                   = $00008000;
  tc_ScrollBlt                  = $00010000;


{ GetWindow Constants }

  gw_HWndFirst                  = 0;
  gw_HWndLast                   = 1;
  gw_HWndNext                   = 2;
  gw_HWndPrev                   = 3;
  gw_Owner                      = 4;
  gw_Child                      = 5;
  gw_Max                        = 5;

{ ShowWindow() Constants }

  sw_Hide                       = 0;
  sw_Normal                     = 1;
  sw_ShowNormal                 = 1;
  sw_ShowMinimized              = 2;
  sw_Maximize                   = 3;
  sw_ShowMaximized              = 3;
  sw_ShowNoActivate             = 4;
  sw_Show                       = 5;
  sw_Minimize                   = 6;
  sw_ShowMinNoActive            = 7;
  sw_ShowNa                     = 8;
  sw_Restore                    = 9;
  sw_Max                        = 10;
  sw_ShowDefault                = 10;

  hide_Window                   = 0;
  show_OpenWindow               = 1;
  show_IconWindow               = 2;
  show_FullScreen               = 3;
  show_OpenNoActivate           = 4;

  wa_Inactive                   = 0;
  wa_Active                     = 1;
  wa_ClickActive                = 2;

{ SetWindowPos() Constants }

  swp_NoSize                    = $0001;
  swp_NoMove                    = $0002;
  swp_NoZOrder                  = $0004;
  swp_NoRedraw                  = $0008;
  swp_NoActivate                = $0010;
  swp_FrameChanged              = $0020;
  swp_ShowWindow                = $0040;
  swp_HideWindow                = $0080;
  swp_NoCopyBits                = $0100;
  swp_NoOwnerZOrder             = $0200;

  swp_DrawFrame                 = swp_FrameChanged;
  swp_NoReposition              = swp_NoOwnerZOrder;

{ TWindowPos structure sent with wm_WindowPosChanging }

type
  PWindowPos = ^TWindowPos;
  TWindowPos = packed record
    hWnd:            hWnd;
    hwndInsertAfter: hWnd;
    x:               Integer;
    y:               Integer;
    cx:              Integer;
    cy:              Integer;
    flags:           UInt;
  end;

const
  hwnd_Top                      = hWnd(0);
  hwnd_Bottom                   = hWnd(1);
  hwnd_Topmost                  = hWnd(-1);
  hwnd_NoTopmost                = hWnd(-2);

{ Menu flags for Add/Check/EnableMenuItem }

  mf_ByCommand                  = $00000000;
  mf_Enabled                    = $00000000;
  mf_Insert                     = $00000000;
  mf_String                     = $00000000;
  mf_Unchecked                  = $00000000;
  mf_Unhilite                   = $00000000;
  mf_Grayed                     = $00000001;
  mf_Disabled                   = $00000002;
  mf_Bitmap                     = $00000004;
  mf_Checked                    = $00000008;
  mf_Popup                      = $00000010;
  mf_MenubarBreak               = $00000020;
  mf_MenuBreak                  = $00000040;
  mf_Change                     = $00000080;
  mf_End                        = $00000080;
  mf_Hilite                     = $00000080;
  mf_Append                     = $00000100;
  mf_OwnerDraw                  = $00000100;
  mf_Delete                     = $00000200;
  mf_UseCheckBitmaps            = $00000200;
  mf_ByPosition                 = $00000400;
  mf_Separator                  = $00000800;
  mf_Remove                     = $00001000;
  mf_SysMenu                    = $00002000;
  mf_Help                       = $00004000;
  mf_MouseSelect                = $00008000;

{ Get/SetWindowLong Offsets }

  gwl_WndProc                   = -4;
  gwl_HInstance                 = -6;
  gwl_HWndParent                = -8;
  gwl_Id                        = -12;
  gwl_Style                     = -16;
  gwl_ExStyle                   = -20;
  gwl_UserData                  = -21;

{ Get/SetWindowWord Offsets }

  gww_HInstance                 = -6;
  gww_HWndParent                = -8;
  gww_Id                        = -12;

{ Get/SetClassLong Offsets }

  gcl_MenuName                  = -8;
  gcl_HbrBackground             = -10;
  gcl_HCursor                   = -12;
  gcl_HIcon                     = -14;
  gcl_hModule                   = -16;
  gcl_CbWndExtra                = -18;
  gcl_CbClsExtra                = -20;
  gcl_WndProc                   = -24;
  gcl_Style                     = -26;
  gcw_Atom                      = -32;

{ Get/SetClassWord Offsets }

  gcw_HbrBackground             = -10;
  gcw_HCursor                   = -12;
  gcw_HIcon                     = -13;
  gcw_hModule                   = -14;
  gcw_CbWndExtra                = -18;
  gcw_CbClsExtra                = -20;
  gcw_Style                     = -26;

{ Get/SetWindowLong Offsets for Dialog Windows }

  dwl_MsgResult                 = 0;
  dwl_DlgProc                   = 4;
  dwl_User                      = 8;

{ MDI client style bits }

  mdis_AllChildStyles           = $0001;

{ wParam Flags for wm_MdiTile and wm_MdiCascade messages. }

  mditile_Vertical              = $0000;
  mditile_Horizontal            = $0001;
  mditile_SkipDisabled          = $0002;

{ wm_MouseActivate Return Codes }

  ma_Activate                   = 1;
  ma_ActivateAndEat             = 2;
  ma_NoActivate                 = 3;
  ma_NoActivateAndEat           = 4;

{ Dialog and Message Box IDs }

  idOk                          = 1;  id_Ok     = idOk;
  idCancel                      = 2;  id_Cancel = idCancel;
  idAbort                       = 3;  id_Abort  = idAbort;
  idRetry                       = 4;  id_Retry  = idRetry;
  idIgnore                      = 5;  id_Ignore = idIgnore;
  idYes                         = 6;  id_Yes    = idYes;
  idNo                          = 7;  id_No     = idNo;
  idClose                       = 8;  id_Close  = idClose;
  idHelp                        = 9;  id_Help   = idHelp;

{ Font Families }

  ff_DontCare                   = $0000;
  ff_Roman                      = $0010;
  ff_Swiss                      = $0020;
  ff_Modern                     = $0030;
  ff_Script                     = $0040;
  ff_Decorative                 = $0050;

{ Font Bold Weight Values }

  fw_DontCare                   = 0;
  fw_Thin                       = 100;
  fw_ExtraLight                 = 200;
  fw_Light                      = 300;
  fw_Normal                     = 400;
  fw_Medium                     = 500;
  fw_SemiBold                   = 600;
  fw_Bold                       = 700;
  fw_ExtraBold                  = 800;
  fw_Heavy                      = 900;

  fw_Black                      = fw_Heavy;
  fw_DemiBold                   = fw_SemiBold;
  fw_Regular                    = fw_Normal;
  fw_UltraBold                  = fw_ExtraBold;
  fw_UltraLight                 = fw_ExtraLight;

{ Character sets }

  Ansi_CharSet                  = 0;
  Symbol_CharSet                = 2;
  Oem_CharSet                   = 255;

{ Output precision }

  out_Default_Precis            = 0;
  out_String_Precis             = 1;
  out_Character_Precis          = 2;
  out_Stroke_Precis             = 3;

{ Clip precision }

  clip_Default_Precis           = 0;
  clip_Character_Precis         = 1;
  clip_Stroke_Precis            = 2;

{ Font quality }

  Default_Quality               = 0;
  Draft_Quality                 = 1;
  Proof_Quality                 = 2;

{ Font pitch }

  Default_Pitch                 = 0;
  Fixed_Pitch                   = 1;
  Variable_Pitch                = 2;

{ GDI Escapes }

  NewFrame                      = 1;
  _AbortDoc                     = 2; // Renamed
  NextBand                      = 3;
  SetColorTable                 = 4;
  GetColorTable                 = 5;
  FlushOutput                   = 6;
  DraftMode                     = 7;
  QueryEscSupport               = 8;
  _SetAbortProc                 = 9;  // Renamed
  _StartDoc                     = 10; // Renamed
  _EndDoc                       = 11; // Renamed
  GetPhysPageSize               = 12;
  GetPrintingOffset             = 13;
  GetScalingFactor              = 14;
  MfComment                     = 15;
  GetPenWidth                   = 16;
  SetCopyCount                  = 17;
  SelectPaperSource             = 18;
  DeviceData                    = 19;
  PassThrough                   = 19;
  GetTechnolgy                  = 20;
  GetTechnology                 = 20;
  SetLineCap                    = 21;
  SetLineJoin                   = 22;
  _SetMiterLimit                = 23; // Renamed
  BandInfo                      = 24;
  DrawPatternRect               = 25;
  GetVectorPenSize              = 26;
  GetVectorBrushSize            = 27;
  EnableDuplex                  = 28;
  GetSetPaperBins               = 29;
  GetSetPrintOrient             = 30;
  EnumPaperBins                 = 31;
  SetDibScaling                 = 32;
  EpsPrinting                   = 33;
  EnumPaperMetrics              = 34;
  GetSetPaperMetrics            = 35;
  PostScript_Data               = 37;
  PostScript_Ignore             = 38;
  MouseTrails                   = 39;
  GetDeviceUnits                = 42;

  GetExtendedTextMetrics        = 256;
  GetExtentTable                = 257;
  GetPairKernTable              = 258;
  GetTrackKernTable             = 259;
  _ExtTextOut                   = 512; // Renamed
  GetFaceName                   = 513;
  DownloadFace                  = 514;
  EnableRelativeWidths          = 768;
  EnablePairKerning             = 769;
  SetKernTrack                  = 770;
  SetAllJustValues              = 771;
  SetCharSet                    = 772;
  _StretchBlt                   = 2048; // Renamed
  GetSetScreenParams            = 3072;
  QueryDibSupport               = 3073;
  Begin_Path                    = 4096;
  Clip_To_Path                  = 4097;
  End_Path                      = 4098;
  Ext_Device_Caps               = 4099;
  Restore_Ctm                   = 4100;
  Save_Ctm                      = 4101;
  Set_Arc_Direction             = 4102;
  Set_Background_Color          = 4103;
  Set_Poly_Mode                 = 4104;
  Set_Screen_Angle              = 4105;
  Set_Spread                    = 4106;
  Transform_Ctm                 = 4107;
  Set_Clip_Box                  = 4108;
  Set_Bounds                    = 4109;
  Set_Mirror_Mode               = 4110;
  OpenChannel                   = 4110;
  DownloadHeader                = 4111;
  CloseChannel                  = 4112;
  Postscript_Passthrough        = 4115;
  Encapsulated_Postscript       = 4116;
  Ds_AbsAlign                   = $001;
  Ds_SysModal                   = $002;
  Ds_LocalEdit                  = $020;
  Ds_SetFont                    = $040;
  Ds_ModalFrame                 = $080;
  Ds_NoIdleMsg                  = $100;
  Ds_SetForeground              = $200;
  Dc_HasDefId                   = $534B;
  Dlgc_WantArrows               = $0001;
  Dlgc_WantTab                  = $0002;
  Dlgc_WantAllKeys              = $0004;
  Dlgc_WantMessage              = $0004;
  Dlgc_HasSetSel                = $0008;
  Dlgc_DefPushButton            = $0010;
  Dlgc_UndefPushButton          = $0020;
  Dlgc_RadioButton              = $0040;
  Dlgc_WantChars                = $0080;
  Dlgc_Static                   = $0100;
  Dlgc_Button                   = $2000;

{ OpenFile mode flags }

  of_Read                       = $00000000;
  of_Write                      = $00000001;
  of_ReadWrite                  = $00000002;
  of_Share_Compat               = $00000000;
  of_Share_Exclusive            = $00000010;
  of_Share_Deny_Write           = $00000020;
  of_Share_Deny_Read            = $00000030;
  of_Share_Deny_None            = $00000040;
  of_Parse                      = $00000100;
  of_Delete                     = $00000200;
  of_Verify                     = $00000400;
  of_Cancel                     = $00000800;
  of_Create                     = $00001000;
  of_Prompt                     = $00002000;
  of_Exist                      = $00004000;
  of_ReOpen                     = $00008000;

{ Generic access flags for CreateFile }

  Generic_Read                  = $80000000;
  Generic_Write                 = $40000000;
  Generic_Execute               = $20000000;
  Generic_All                   = $10000000;

{ Share & Attribute flags for CreateFile }

  file_Share_Read               = $00000001;
  file_Share_Write              = $00000002;
  file_Attribute_Readonly       = $00000001;
  file_Attribute_Hidden         = $00000002;
  file_Attribute_System         = $00000004;
  file_Attribute_Directory      = $00000010;
  file_Attribute_Archive        = $00000020;
  file_Attribute_Normal         = $00000080;
  file_Attribute_Temporary      = $00000100;
  file_Attribute_Atomic_Write   = $00000200;
  file_Attribute_Xaction_Write  = $00000400;
  file_Attribute_Compressed     = $00000800;
  file_Attribute_Has_Embedding  = $00001000;

{ Create option for CreateFile }

  Create_New                    = 1;
  Create_Always                 = 2;
  Open_Existing                 = 3;
  Open_Always                   = 4;
  Truncate_Existing             = 5;

{ Access file flags }

  file_Flag_Write_Through       = $80000000;
  file_Flag_Overlapped          = $40000000;
  file_Flag_No_Buffering        = $20000000;
  file_Flag_Random_Access       = $10000000;
  file_Flag_Sequential_Scan     = $08000000;
  file_Flag_Delete_On_Close     = $04000000;
  file_Flag_Backup_Semantics    = $02000000;
  file_Flag_Posix_Semantics     = $01000000;

{ SetFilePointer Flags }

  file_Begin                    = 0;
  file_Current                  = 1;
  file_End                      = 2;

{ GetFileType Flags }

  file_Type_Unknown             = $00000000;
  file_Type_Disk                = $00000000;
  file_Type_Char                = $00000001;
  file_Type_Pipe                = $00000002;
  file_Type_Remote              = $00008000;

{ DllEntryPoint flags }

  dll_Process_Detach            = 0;
  dll_Process_Attach            = 1;

{ GetQueueStatus Flags }

  qs_Key                        = $01;
  qs_MouseMove                  = $02;
  qs_MouseButton                = $04;
  qs_PostMessage                = $08;
  qs_Timer                      = $10;
  qs_Paint                      = $20;
  qs_SendMessage                = $40;
  qs_HotKey                     = $80;
  qs_Mouse                      = qs_MouseMove or qs_MouseButton;
  qs_Input                      = qs_Mouse or qs_Key;
  qs_AllEvents                  = qs_Input or qs_PostMessage or qs_Timer or qs_Paint or qs_HotKey;
  qs_AllInput                   = qs_SendMessage or qs_Paint or qs_Timer or
                                  qs_PostMessage or qs_MouseButton or qs_MouseMove or
                                  qs_HotKey or qs_Key;
{ Maximum path length }

  Max_Path = 260;

{ PeekMessage Options }

  pm_NoRemove                   = $0000;
  pm_ReMove                     = $0001;
  pm_NoYield                    = $0002;

{ Edit Control Styles }

  es_Left                       = $0000;
  es_Center                     = $0001;
  es_Right                      = $0002;
  es_MultiLine                  = $0004;
  es_UpperCase                  = $0008;
  es_LowerCase                  = $0010;
  es_Password                   = $0020;
  es_AutoVScroll                = $0040;
  es_AutoHScroll                = $0080;
  es_NoHideSel                  = $0100;
  es_OemConvert                 = $0400;
  es_ReadOnly                   = $0800;
  es_WantReturn                 = $1000;

{ Edit Control Notification Codes }

  en_SetFocus                   = $0100;
  en_KillFocus                  = $0200;
  en_Change                     = $0300;
  en_Update                     = $0400;
  en_ErrSpace                   = $0500;
  en_MaxText                    = $0501;
  en_HScroll                    = $0601;
  en_VScroll                    = $0602;

{ Listbox Styles }

  lbs_Notify                    = $0001;
  lbs_Sort                      = $0002;
  lbs_NoRedraw                  = $0004;
  lbs_MultipleSel               = $0008;
  lbs_OwnerDrawFixed            = $0010;
  lbs_OwnerDrawVariable         = $0020;
  lbs_HasStrings                = $0040;
  lbs_UseTabStops               = $0080;
  lbs_NoIntegralHeight          = $0100;
  lbs_MultiColumn               = $0200;
  lbs_WantKeyboardInput         = $0400;
  lbs_ExtendedSel               = $0800;
  lbs_DisableNoScroll           = $1000;
  lbs_NoData                    = $2000;
  lbs_Standard                  = lbs_Notify or lbs_Sort or ws_VScroll or ws_Border;

{ Listbox Return Values }

  lb_ErrSpace                   = -2;
  lb_Err                        = -1;
  lb_OKay                       = 0;

{ Listbox Notification Codes }

  lbn_ErrSpace                  = -2;
  lbn_SelChange                 = 1;
  lbn_DblClk                    = 2;
  lbn_SelCancel                 = 3;
  lbn_SetFocus                  = 4;
  lbn_KillFocus                 = 5;

{ DlgDirList, DlgDirListComboBox flags values }

  ddl_ReadWrite                 = $0000;
  ddl_ReadOnly                  = $0001;
  ddl_Hidden                    = $0002;
  ddl_System                    = $0004;
  ddl_Directory                 = $0010;
  ddl_Archive                   = $0020;
  ddl_PostMsgs                  = $2000;
  ddl_Drives                    = $4000;
  ddl_Exclusive                 = $8000;

{ Combo Box return Values }

  cb_ErrSpace                   = -2;
  cb_Err                        = -1;
  cb_OKay                       = 0;

{ Combo Box Notification Codes }

  cbn_ErrSpace                  = -1;
  cbn_SelChange                 = 1;
  cbn_DblClk                    = 2;
  cbn_SetFocus                  = 3;
  cbn_KillFocus                 = 4;
  cbn_EditChange                = 5;
  cbn_EditUpdate                = 6;
  cbn_DropDown                  = 7;
  cbn_CloseUp                   = 8;
  cbn_SelendOk                  = 9;
  cbn_SelendCancel              = 10;

{ Combo Box styles }

  cbs_Simple                    = $0001;
  cbs_DropDown                  = $0002;
  cbs_DropDownList              = $0003;
  cbs_OwnerDrawFixed            = $0010;
  cbs_OwnerDrawVariable         = $0020;
  cbs_AutoHScroll               = $0040;
  cbs_OemConvert                = $0080;
  cbs_Sort                      = $0100;
  cbs_HasStrings                = $0200;
  cbs_NoIntegralHeight          = $0400;
  cbs_DisableNoScroll           = $0800;

{ Scroll Bar Constants }

  sb_Horz                       = 0;
  sb_Vert                       = 1;
  sb_Ctl                        = 2;
  sb_Both                       = 3;

  esb_Enable_Both               = 0;
  esb_Disable_Ltup              = 1;
  esb_Disable_Rtdn              = 2;
  esb_Disable_Both              = 3;

{ Scroll Bar Commands }

  sb_LineUp                     = 0;
  sb_LineLeft                   = 0;
  sb_LineDown                   = 1;
  sb_LineRight                  = 1;
  sb_PageUp                     = 2;
  sb_PageLeft                   = 2;
  sb_PageDown                   = 3;
  sb_PageRight                  = 3;
  sb_ThumbPosition              = 4;
  sb_ThumbTrack                 = 5;
  sb_Top                        = 6;
  sb_Left                       = 6;
  sb_Bottom                     = 7;
  sb_Right                      = 7;
  sb_EndScroll                  = 8;

{ Scroll Bar Styles }

  sbs_Horz                      = $0000;
  sbs_Vert                      = $0001;
  sbs_TopAlign                  = $0002;
  sbs_LeftAlign                 = $0002;
  sbs_BottomAlign               = $0004;
  sbs_RightAlign                = $0004;
  sbs_SizeBoxTopLeftAlign       = $0002;
  sbs_SizeBoxBottomRightAlign   = $0004;
  sbs_SizeBox                   = $0008;

{ Static Control Constants }

  ss_Left                       = $00;
  ss_Center                     = $01;
  ss_Right                      = $02;
  ss_Icon                       = $03;
  ss_BlackRect                  = $04;
  ss_GrayRect                   = $05;
  ss_WhiteRect                  = $06;
  ss_BlackFrame                 = $07;
  ss_GrayFrame                  = $08;
  ss_WhiteFrame                 = $09;
  ss_UserItem                   = $0A;
  ss_Simple                     = $0B;
  ss_LeftNowordWrap             = $0C;
  ss_NoPrefix                   = $80;

{ Button Control Styles }

  bs_PushButton                 = $00;
  bs_DefPushButton              = $01;
  bs_CheckBox                   = $02;
  bs_AutoCheckBox               = $03;
  bs_RadioButton                = $04;
  bs_3State                     = $05;
  bs_Auto3State                 = $06;
  bs_GroupBox                   = $07;
  bs_UserButton                 = $08;
  bs_AutoRadioButton            = $09;
  bs_OwnerDraw                  = $0B;
  bs_LeftText                   = $20;

{ User Button Notification Codes }

  bn_Clicked                    = 0;
  bn_Paint                      = 1;
  bn_Hilite                     = 2;
  bn_Unhilite                   = 3;
  bn_Disable                    = 4;
  bn_DoubleClicked              = 5;

{ Button Control Messages }

  bm_GetCheck                   = $00F0;
  bm_SetCheck                   = $00F1;
  bm_GetState                   = $00F2;
  bm_SetState                   = $00F3;
  bm_SetStyle                   = $00F4;

{ Owner draw control types }

  odt_Menu                      = 1;
  odt_Listbox                   = 2;
  odt_Combobox                  = 3;
  odt_Button                    = 4;
  odt_Static                    = 5;

{ Owner draw actions }

  oda_DrawEntire                = $0001;
  oda_Select                    = $0002;
  oda_Focus                     = $0004;

{ Owner draw state }

  ods_Selected                  = $0001;
  ods_Grayed                    = $0002;
  ods_Disabled                  = $0004;
  ods_Checked                   = $0008;
  ods_Focus                     = $0010;
  ods_Default                   = $0020;
  ods_ComboBoxEdit              = $1000;

{ Stock Logical Objects }

  White_Brush                   = 0;
  LtGray_Brush                  = 1;
  Gray_Brush                    = 2;
  DkGray_Brush                  = 3;
  Black_Brush                   = 4;
  Null_Brush                    = 5;
  White_Pen                     = 6;
  Black_Pen                     = 7;
  Null_Pen                      = 8;
  Oem_Fixed_Font                = 10;
  Ansi_Fixed_Font               = 11;
  Ansi_Var_Font                 = 12;
  System_Font                   = 13;
  Device_Default_Font           = 14;
  Default_Palette               = 15;
  System_Fixed_Font             = 16;
  Stock_Last                    = 16;
  Hollow_Brush                  = Null_Brush;

{ Brush Styles }

  bs_Solid                      = 0;
  bs_Null                       = 1;
  bs_Hatched                    = 2;
  bs_Pattern                    = 3;
  bs_Indexed                    = 4;
  bs_DibPattern                 = 5;
  bs_DibPatternPt               = 6;
  bs_Pattern8x8                 = 7;
  bs_DibPattern8x8              = 8;
  bs_Hollow                     = bs_Null;

{ Hatch Styles }

  hs_Horizontal                 = 0;
  hs_Vertical                   = 1;
  hs_FDiagonal                  = 2;
  hs_BDiagonal                  = 3;
  hs_Cross                      = 4;
  hs_DiagCross                  = 5;
  hs_SolidClr                   = 6;
  hs_DitheredClr                = 7;
  hs_SolidTextClr               = 8;
  hs_DitheredTextClr            = 9;
  hs_SolidBkClr                 = 10;
  hs_DitheredBkClr              = 11;
  hs_Api_Max                    = 12;

{ Pen Styles }

  ps_Solid                      = 0;
  ps_Dash                       = 1;
  ps_Dot                        = 2;
  ps_DashDot                    = 3;
  ps_DashDotDot                 = 4;
  ps_Null                       = 5;
  ps_InsideFrame                = 6;
  ps_UserStyle                  = 7;
  ps_Alternate                  = 8;
  ps_Style_Mask                 = $0000000F;
  ps_Cosmetic                   = $00000000;
  ps_Endcap_Round               = $00000000;
  ps_Join_Round                 = $00000000;
  ps_Endcap_Square              = $00000100;
  ps_Endcap_Flat                = $00000200;
  ps_Endcap_Mask                = $00000F00;
  ps_Join_Bevel                 = $00001000;
  ps_Join_Miter                 = $00002000;
  ps_Join_Mask                  = $0000F000;
  ps_Geometric                  = $00010000;
  ps_Type_Mask                  = $000F0000;

{ Region Flags }

  Error                         = 0;
  NullRegion                    = 1;
  SimpleRegion                  = 2;
  ComplexRegion                 = 3;
  Rgn_Error                     = Error;
  Gdi_Error                     = $FFFFFFFF;
  Clr_Invalid                   = $FFFFFFFF;

{ CombineRgn Styles }

  rgn_And                       = 1;
  rgn_Or                        = 2;
  rgn_Xor                       = 3;
  rgn_Diff                      = 4;
  rgn_Copy                      = 5;
  rgn_Min                       = rgn_And;
  rgn_Max                       = rgn_Copy;

{ PolyFill Modes }

  Alternate                     = 1;
  Winding                       = 2;

{ Binary Raster Operations }

  r2_Black                      = 1;
  r2_NotMergePen                = 2;
  r2_MaskNotPen                 = 3;
  r2_NotCopyPen                 = 4;
  r2_MaskPenNot                 = 5;
  r2_Not                        = 6;
  r2_XorPen                     = 7;
  r2_NotMaskPen                 = 8;
  r2_MaskPen                    = 9;
  r2_NotXorPen                  = 10;
  r2_Nop                        = 11;
  r2_MergeNotPen                = 12;
  r2_CopyPen                    = 13;
  r2_MergePenNot                = 14;
  r2_MergePen                   = 15;
  r2_White                      = 16;
  r2_Last                       = 16;

{ Ternary raster operations }

  SrcCopy                       = $00CC0020;
  SrcPaint                      = $00EE0086;
  SrcAnd                        = $008800C6;
  SrcInvert                     = $00660046;
  SrcErase                      = $00440328;
  NotSrcCopy                    = $00330008;
  NotSrcErase                   = $001100A6;
  MergeCopy                     = $00C000CA;
  MergePaint                    = $00BB0226;
  PatCopy                       = $00F00021;
  PatPaint                      = $00FB0A09;
  PatInvert                     = $005A0049;
  DstInvert                     = $00550009;
  Blackness                     = $00000042;
  Whiteness                     = $00FF0062;


{ Spooler Error Codes }

  sp_OutOfMemory                = -5;
  sp_OutOfDisk                  = -4;
  sp_UserAbort                  = -3;
  sp_AppAbort                   = -2;
  sp_Error                      = -1;
  sp_NotReported                = $4000;

{ Predefined Clipboard Formats }

  cf_Text                       = 1;
  cf_Bitmap                     = 2;
  cf_MetafilePict               = 3;
  cf_Sylk                       = 4;
  cf_Dif                        = 5;
  cf_Tiff                       = 6;
  cf_OemText                    = 7;
  cf_Dib                        = 8;
  cf_Palette                    = 9;
  cf_PenData                    = 10;
  cf_Riff                       = 11;
  cf_Wave                       = 12;
  cf_UnicodeText                = 13;
  cf_EnhMetafile                = 14;

  cf_OwnerDisplay               = $0080;
  cf_DspText                    = $0081;
  cf_DspBitmap                  = $0082;
  cf_DspMetafilePict            = $0083;
  cf_DspEnhMetafile             = $008E;
  cf_PrivateFirst               = $0200;
  cf_PrivateLast                = $02FF;
  cf_GdiObjFirst                = $0300;
  cf_GdiObjLast                 = $03FF;

{ GetSystemMetrics() codes }

  sm_CxScreen                   = 0;
  sm_CyScreen                   = 1;
  sm_CxVScroll                  = 2;
  sm_CyHScroll                  = 3;
  sm_CyCaption                  = 4;
  sm_CxBorder                   = 5;
  sm_CyBorder                   = 6;
  sm_CxDlgFrame                 = 7;
  sm_CyDlgFrame                 = 8;
  sm_CyVThumb                   = 9;
  sm_CxHThumb                   = 10;
  sm_CxIcon                     = 11;
  sm_CyIcon                     = 12;
  sm_CxCursor                   = 13;
  sm_CyCursor                   = 14;
  sm_CyMenu                     = 15;
  sm_CxFullScreen               = 16;
  sm_CyFullScreen               = 17;
  sm_CyKanjiWindow              = 18;
  sm_MousePresent               = 19;
  sm_CyVScroll                  = 20;
  sm_CxHScroll                  = 21;
  sm_Debug                      = 22;
  sm_SwapButton                 = 23;
  sm_Reserved1                  = 24;
  sm_Reserved2                  = 25;
  sm_Reserved3                  = 26;
  sm_Reserved4                  = 27;
  sm_CxMin                      = 28;
  sm_CyMin                      = 29;
  sm_CxSize                     = 30;
  sm_CySize                     = 31;
  sm_CxFrame                    = 32;
  sm_CyFrame                    = 33;
  sm_CxMinTrack                 = 34;
  sm_CyMinTrack                 = 35;
  sm_CxDoubleClk                = 36;
  sm_CyDoubleClk                = 37;
  sm_MenuDropAlignment          = 40;
  sm_CMouseButtons              = 43;
  sm_CMetrics                   = 44;

{ Flags for TrackPopupMenu }

  tpm_LeftAlign                 = $0000;
  tpm_LeftButton                = $0000;
  tpm_RightButton               = $0002;
  tpm_CenterAlign               = $0004;
  tpm_RightAlign                = $0008;

{ SetWindowsHook codes }

  wh_Min                        = -1;
  wh_MsgFilter                  = -1;
  wh_JournalRecord              = 0;
  wh_JournalPlayback            = 1;
  wh_Keyboard                   = 2;
  wh_GetMessage                 = 3;
  wh_CallWndProc                = 4;
  wh_Cbt                        = 5;
  wh_SysMsgFilter               = 6;
  wh_Mouse                      = 7;
  wh_Hardware                   = 8;
  wh_Debug                      = 9;
  wh_Shell                      = 10;
  wh_ForegroundIdle             = 11;
  wh_Max                        = 11;

{ Hook Codes }

  hc_Action                     = 0;
  hc_GetNext                    = 1;
  hc_Skip                       = 2;
  hc_NoRemove                   = 3;
  hc_SysModalOn                 = 4;
  hc_SysModalOff                = 5;
  hc_NoRem                      = hc_NoRemove;

  drive_Unknown                 = 0;
  drive_No_Root_Dir             = 1;
  drive_Removable               = 2;
  drive_Fixed                   = 3;
  drive_Remote                  = 4;
  drive_Cdrom                   = 5;
  drive_RamDisk                 = 6;

{ Color Types }

  ctlcolor_MsgBox               = 0;
  ctlcolor_Edit                 = 1;
  ctlcolor_ListBox              = 2;
  ctlcolor_Btn                  = 3;
  ctlcolor_Dlg                  = 4;
  ctlcolor_ScrollBar            = 5;
  ctlcolor_Static               = 6;
  ctlcolor_Max                  = 8;

  color_ScrollBar               = 0;
  color_Background              = 1;
  color_ActiveCaption           = 2;
  color_InactiveCaption         = 3;
  color_Menu                    = 4;
  color_Window                  = 5;
  color_WindowFrame             = 6;
  color_MenuText                = 7;
  color_WindowText              = 8;
  color_CaptionText             = 9;
  color_ActiveBorder            = 10;
  color_InactiveBorder          = 11;
  color_AppWorkSpace            = 12;
  color_Highlight               = 13;
  color_HighlightText           = 14;
  color_BtnFace                 = 15;
  color_BtnShadow               = 16;
  color_GrayText                = 17;
  color_BtnText                 = 18;
  color_InactiveCaptionText     = 19;
  color_BtnHighlight            = 20;
  color_3dDkShadow              = 21;
  color_3dLight                 = 22;
  color_InfoText                = 23;
  color_InfoBk                  = 24;
  color_Max                     = 24;

{ Draw Text flags }

  dt_Top                        = $00000000;
  dt_Left                       = $00000000;
  dt_Center                     = $00000001;
  dt_Right                      = $00000002;
  dt_VCenter                    = $00000004;
  dt_Bottom                     = $00000008;
  dt_WordBreak                  = $00000010;
  dt_SingleLine                 = $00000020;
  dt_ExpandTabs                 = $00000040;
  dt_TabStop                    = $00000080;
  dt_NoClip                     = $00000100;
  dt_ExternAlleading            = $00000200;
  dt_CalcRect                   = $00000400;
  dt_NoPrefix                   = $00000800;
  dt_ValidFlags                 = $00000FFF;

{ Text Alignment Options }

  ta_Left                       = 0;
  ta_NoUpdateCp                 = 0;
  ta_Top                        = 0;
  ta_UpdateCp                   = 1;
  ta_Right                      = 2;
  ta_Center                     = 6;
  ta_Bottom                     = 8;
  ta_BaseLine                   = 24;
  ta_Mask                       = ta_BaseLine + ta_Center + ta_UpdateCp;

  vta_BaseLine                  = ta_BaseLine;
  vta_Left                      = ta_Bottom;
  vta_Right                     = ta_Top;
  vta_Center                    = ta_Center;
  vta_Bottom                    = ta_Right;
  vta_Top                       = ta_Left;

{ Memory APIs }

  page_NoAccess                 = $00000001;
  page_ReadOnly                 = $00000002;
  page_ReadWrite                = $00000004;
  page_WriteCopy                = $00000008;
  page_Execute                  = $00000010;
  page_Execute_Read             = $00000020;
  page_Execute_ReadWrite        = $00000040;
  page_Execute_WriteCopy        = $00000080;
  page_Guard                    = $00000100;
  page_NoCache                  = $00000200;
  mem_Commit                    = $00001000;
  mem_Reserve                   = $00002000;
  mem_Decommit                  = $00004000;
  mem_Release                   = $00008000;
  mem_Free                      = $00010000;
  mem_Private                   = $00020000;
  mem_Mapped                    = $00040000;
  mem_Top_Down                  = $00100000;
  sec_File                      = $00800000;
  sec_Image                     = $01000000;
  sec_Reserve                   = $04000000;
  sec_Commit                    = $08000000;
  sec_NoCache                   = $10000000;
  mem_Image                     = sec_Image;

{ Global Memory Flags }

  gmem_Fixed                    = $0000;
  gmem_Moveable                 = $0002;
  gmem_NoCompact                = $0010;
  gmem_NoDiscard                = $0020;
  gmem_ZeroInit                 = $0040;
  gmem_Modify                   = $0080;
  gmem_LockCount                = $00FF;
  gmem_Discardable              = $0100;
  gmem_Not_Banked               = $1000;
  gmem_Share                    = $2000;
  gmem_DdeShare                 = $2000;
  gmem_Notify                   = $4000;
  gmem_Discarded                = $4000;
  gmem_Invalid_Handle           = $8000;
  gmem_Lower                    = gmem_Not_Banked;
  GHnd                          = gmem_Moveable or gmem_ZeroInit;
  GPtr                          = gmem_Fixed or gmem_ZeroInit;

{ Local Memory Flags }

  lmem_Fixed                    = $0000;
  lmem_Moveable                 = $0002;
  lmem_NoCompact                = $0010;
  lmem_NoDiscard                = $0020;
  lmem_ZeroInit                 = $0040;
  lmem_Modify                   = $0080;
  lmem_LockCount                = $00FF;
  lmem_Discardable              = $0F00;
  lmem_Valid_Flags              = $0F72;
  lmem_Discarded                = $4000;
  lmem_Invalid_Handle           = $8000;
  LHnd                          = lmem_Moveable or lmem_ZeroInit;
  LPtr                          = lmem_Fixed or lmem_ZeroInit;
  NonZeroLHnd                   = lmem_Moveable;
  NonZeroLPtr                   = lmem_Fixed;

{ constants for HeapAlloc() flags }

  heap_No_Serialize             = $00000001;
  heap_Growable                 = $00000002;
  heap_Generate_Exceptions      = $00000004;
  heap_Zero_Memory              = $00000008;
  heap_Realloc_In_Place_Only    = $00000010;
  heap_Tail_Checking_Enabled    = $00000020;
  heap_Free_Checking_Enabled    = $00000040;
  heap_Disable_Coalesce_On_Free = $00000080;

{ System API Flags }

  Infinite                      = DWord(-1);

  _Delete                       = $00010000; // Renamed
  Read_Control                  = $00020000;
  Write_Dac                     = $00040000;
  Write_Owner                   = $00080000;
  Synchronize                   = $00100000;

  Specific_Rights_All           = $0000FFFF;
  Standard_Rights_Read          = Read_Control;
  Standard_Rights_Write         = Read_Control;
  Standard_Rights_Execute       = Read_Control;
  Standard_Rights_Required      = $000F0000;
  Standard_Rights_All           = $001F0000;

{ Thread Creation Flags }

  debug_Process                 = $00000001;
  debug_Only_This_Process       = $00000002;
  create_Suspended              = $00000004;
  detached_Process              = $00000008;
  create_New_Console            = $00000010;
  normal_Priority_Class         = $00000020;
  idle_Priority_Class           = $00000040;
  high_Priority_Class           = $00000080;
  realtime_Priority_Class       = $00000100;
  create_New_Process_Group      = $00000200;
  create_Unicode_Environment    = $00000400;
  create_Separate_Wow_Vdm       = $00000800;
  create_Share_Wow_Vdm          = $00001000;
  create_Default_Error_Mode     = $04000000;
  create_No_Window              = $08000000;
  process_Terminate             = $00000001;
  process_Create_Thread         = $00000002;
  process_Vm_Operation          = $00000008;
  process_Vm_Read               = $00000010;
  process_Vm_Write              = $00000020;
  process_Dup_Handle            = $00000040;
  process_Create_Process        = $00000080;
  process_Set_Quota             = $00000100;
  process_Set_Information       = $00000200;
  process_Query_Information     = $00000400;
  process_All_Access            = Standard_Rights_Required or Synchronize or $FFF;

  thread_Terminate              = $00000001;
  thread_Suspend_Resume         = $00000002;
  thread_Get_Context            = $00000008;
  thread_Set_Context            = $00000010;
  thread_Set_Information        = $00000020;
  thread_Query_Information      = $00000040;
  thread_Set_Thread_Token       = $00000080;
  thread_Impersonate            = $00000100;
  thread_Direct_Impersonation   = $00000200;
  thread_All_Access             = Standard_Rights_Required or Synchronize or $3FF;

  tls_Minimum_Available         = 64;

  still_Active                  = $00000103;

  thread_Base_Priority_Idle     = -15;
  thread_Base_Priority_Min      = -2;
  thread_Base_Priority_Max      = 2;
  thread_Base_Priority_Lowrt    = 15;

  thread_Priority_Idle          = -15;
  thread_Priority_Lowest        = -2;
  thread_Priority_Below_Normal  = -1;
  thread_Priority_Normal        = 0;
  thread_Priority_Above_Normal  = 1;
  thread_Priority_Highest       = 2;
  thread_Priority_Time_Critical = 15;

{ Synchronization APIs }

{$IFDEF Open32}
  maximum_Wait_Objects          = 128;
{$ELSE}
  maximum_Wait_Objects          = 64;
{$ENDIF Open32}
  status_Abandoned_Wait_0       = $00000080;
  status_Timeout                = $00000102;
  status_Wait_0                 = $00000000;
  wait_Abandoned                = status_Abandoned_Wait_0;
  wait_Abandoned_0              = status_Abandoned_Wait_0;
  wait_Failed                   = DWord($FFFFFFFF);
  wait_Object_0                 = status_Wait_0;
  wait_Timeout                  = status_Timeout;

  event_Modify_State            = $00000002;
  event_All_Access              = Standard_Rights_Required or Synchronize or event_Modify_State;

  mutex_All_Access              = Standard_Rights_Required or Synchronize;

  semaphore_Modify_State        = $00000002;
  semaphore_All_Access          = Standard_Rights_Required or Synchronize or semaphore_Modify_State;

{ File IO APIs }

  file_Read_Data                = $00000001;
  file_List_Directory           = $00000001;
  file_Write_Data               = $00000002;
  file_Add_File                 = $00000002;
  file_Append_Data              = $00000004;
  file_Add_Subdirectory         = $00000004;
  file_Create_Pipe_Instance     = $00000004;
  file_Read_Ea                  = $00000008;
  file_Read_Properties          = $00000008;
  file_Write_Ea                 = $00000010;
  file_Write_Properties         = $00000010;
  file_Execute                  = $00000020;
  file_Traverse                 = $00000020;
  file_Delete_Child             = $00000040;
  file_Read_Attributes          = $00000080;
  file_Write_Attributes         = $00000100;
  file_All_Access               = Standard_Rights_Required or Synchronize or $1FF;
  file_Generic_Read             = Standard_Rights_Read or file_Read_Data or
                                  file_Read_Attributes or file_Read_Ea   or
                                  Synchronize;

  file_Generic_Write            = Standard_Rights_Write or file_Write_Data or
                                  file_Write_Attributes or file_Write_Ea   or
                                  file_Append_Data      or Synchronize;
  file_Generic_Execute          = Standard_Rights_Execute or file_Read_Attributes or
                                  file_Execute            or Synchronize;

  file_Notify_Change_File_Name  = $00000001;
  file_Notify_Change_Dir_Name   = $00000002;
  file_Notify_Change_Attributes = $00000004;
  file_Notify_Change_Size       = $00000008;
  file_Notify_Change_Last_Write = $00000010;
  file_Notify_Change_Security   = $00000100;
  file_Case_Sensitive_Search    = $00000001;
  file_Case_Preserved_Names     = $00000002;
  file_Unicode_On_Disk          = $00000004;
  file_Persistent_Acls          = $00000008;
  file_File_Compression         = $00000010;
  file_Volume_Is_Compressed     = $00008000;
  io_Completion_Modify_State    = $00000002;
  io_Completion_All_Access      = Standard_Rights_Required or Synchronize or $3;
  duplicate_Close_Source        = $00000001;
  duplicate_Same_Access         = $00000002;

{ GetVolumeInformation Flags }

  fs_Case_Is_Preserved          = file_Case_Preserved_Names;
  fs_Case_Sensitive             = file_Case_Sensitive_Search;
  fs_Unicode_Stored_On_Disk     = file_Unicode_On_Disk;

{ Exceptions }

  status_No_Memory              = $C0000017;
  status_Access_Violation       = $C0000005;

{ Virtual Keys, Standard Set }

  vk_LButton                    = $01;
  vk_RButton                    = $02;
  vk_Cancel                     = $03;
  vk_MButton                    = $04;
  vk_Back                       = $08;
  vk_Tab                        = $09;
  vk_Clear                      = $0C;
  vk_Return                     = $0D;
  vk_Shift                      = $10;
  vk_Control                    = $11;
  vk_Menu                       = $12;
  vk_Pause                      = $13;
  vk_Capital                    = $14;
  vk_Escape                     = $1B;
  vk_Space                      = $20;
  vk_Prior                      = $21;
  vk_Next                       = $22;
  vk_End                        = $23;
  vk_Home                       = $24;
  vk_Left                       = $25;
  vk_Up                         = $26;
  vk_Right                      = $27;
  vk_Down                       = $28;
  vk_Select                     = $29;
  vk_Print                      = $2A;
  vk_Execute                    = $2B;
  vk_SnapShot                   = $2C;
  vk_Insert                     = $2D;
  vk_Delete                     = $2E;
  vk_Help                       = $2F;
  vk_Lwin                       = $5B;
  vk_Rwin                       = $5C;
  vk_Apps                       = $5D;
  vk_Numpad0                    = $60;
  vk_Numpad1                    = $61;
  vk_Numpad2                    = $62;
  vk_Numpad3                    = $63;
  vk_Numpad4                    = $64;
  vk_Numpad5                    = $65;
  vk_Numpad6                    = $66;
  vk_Numpad7                    = $67;
  vk_Numpad8                    = $68;
  vk_Numpad9                    = $69;
  vk_Multiply                   = $6A;
  vk_Add                        = $6B;
  vk_Separator                  = $6C;
  vk_Subtract                   = $6D;
  vk_Decimal                    = $6E;
  vk_Divide                     = $6F;
  vk_F1                         = $70;
  vk_F2                         = $71;
  vk_F3                         = $72;
  vk_F4                         = $73;
  vk_F5                         = $74;
  vk_F6                         = $75;
  vk_F7                         = $76;
  vk_F8                         = $77;
  vk_F9                         = $78;
  vk_F10                        = $79;
  vk_F11                        = $7A;
  vk_F12                        = $7B;
  vk_F13                        = $7C;
  vk_F14                        = $7D;
  vk_F15                        = $7E;
  vk_F16                        = $7F;
  vk_F17                        = $80;
  vk_F18                        = $81;
  vk_F19                        = $82;
  vk_F20                        = $83;
  vk_F21                        = $84;
  vk_F22                        = $85;
  vk_F23                        = $86;
  vk_F24                        = $87;
  vk_NumLock                    = $90;
  vk_Scroll                     = $91;
  vk_LShift                     = $A0;
  vk_RShift                     = $A1;
  vk_LControl                   = $A2;
  vk_RControl                   = $A3;
  vk_LMenu                      = $A4;
  vk_RMenu                      = $A5;
  vk_Attn                       = $F6;
  vk_CrSel                      = $F7;
  vk_ExSel                      = $F8;
  vk_ErEof                      = $F9;
  vk_Play                       = $FA;
  vk_Zoom                       = $FB;
  vk_NoName                     = $FC;
  vk_Pa1                        = $FD;
  vk_Oem_Clear                  = $FE;

{ constants for Get/SetSystemPaletteUse() }

  syspal_Error                  = 0;
  syspal_Static                 = 1;
  syspal_NoStatic               = 2;

{ RedrawWindow() flags }

  rdw_Invalidate                = $0001;
  rdw_InternalPaint             = $0002;
  rdw_Erase                     = $0004;
  rdw_Validate                  = $0008;
  rdw_NoInternalPaint           = $0010;
  rdw_NoErase                   = $0020;
  rdw_NoChildren                = $0040;
  rdw_AllChildren               = $0080;
  rdw_UpdateNow                 = $0100;
  rdw_EraseNow                  = $0200;
  rdw_Frame                     = $0400;
  rdw_NoFrame                   = $0800;

{ Bounds Accumulation APIs }

  dcb_Reset                     = $0001;
  dcb_Accumulate                = $0002;
  dcb_Enable                    = $0004;
  dcb_Disable                   = $0008;
  dcb_Dirty                     = dcb_Accumulate;
  dcb_Set                       = dcb_Reset or dcb_Accumulate;

{ SetErrorMode() flags }

  sem_FailCriticalErrors        = $0001;
  sem_NoGpFaultErrorBox         = $0002;
  sem_NoAlignmentFaultExcept    = $0004;
  sem_NoOpenFileErrorBox        = $8000;

{ Parameter for SystemParametersInfo() }

  spi_GetBeep                   = 1;
  spi_SetBeep                   = 2;
  spi_GetMouse                  = 3;
  spi_SetMouse                  = 4;
  spi_GetBorder                 = 5;
  spi_SetBorder                 = 6;
  spi_GetKeyboardSpeed          = 10;
  spi_SetKeyboardSpeed          = 11;
  spi_LangDriver                = 12;
  spi_IconHorizontalSpacing     = 13;
  spi_GetScreenSaveTimeout      = 14;
  spi_SetScreenSaveTimeout      = 15;
  spi_GetScreenSaveActive       = 16;
  spi_SetScreenSaveActive       = 17;
  spi_GetGridGranularity        = 18;
  spi_SetGridGranularity        = 19;
  spi_Setdeskwallpaper          = 20;
  spi_SetDeskPattern            = 21;
  spi_GetKeyboardDelay          = 22;
  spi_SetKeyboardDelay          = 23;
  spi_IconVerticalSpacing       = 24;
  spi_GetIconTitleWrap          = 25;
  spi_SetIconTitleWrap          = 26;
  spi_GetMenuDropAlignment      = 27;
  spi_SetMenuDropAlignment      = 28;
  spi_SetDoubleClkWidth         = 29;
  spi_SetDoubleClkHeight        = 30;
  spi_GetIconTitleLogfont       = 31;
  spi_SetDoubleClickTime        = 32;
  spi_SetMouseButtonSwap        = 33;
  spi_SetIconTitleLogfont       = 34;
  spi_GetFastTaskSwitch         = 35;
  spi_SetFastTaskSwitch         = 36;
  spi_SetDragFullWindows        = 37;
  spi_GetDragFullWindows        = 38;
  spi_GetKeyboardLayout         = 39;
  spi_SetKeyboardLayout         = 40;
  spi_GetNonClientMetrics       = 41;
  spi_SetNonClientMetrics       = 42;
  spi_GetMinimizedMetrics       = 43;
  spi_SetMinimizedMetrics       = 44;
  spi_GetIconMetrics            = 45;
  spi_SetIconMetrics            = 46;
  spi_GetWorkArea               = 48;
  spi_SetPenWindows             = 49;
  spi_GetHighContrast           = 66;
  spi_SetHighContrast           = 67;
  spi_GetKeyBoardPref           = 68;
  spi_SetKeyboardPref           = 69;
  spi_GetScreenReader           = 70;
  spi_SetScreenReader           = 71;
  spi_GetAnimation              = 72;
  spi_SetAnimation              = 73;
  spi_GetFontSmoothing          = 74;
  spi_SetFontSmoothing          = 75;
  spi_SetDragWidth              = 76;
  spi_SetDragHeight             = 77;
  spi_SetHandHeld               = 78;
  spi_GetLowPowerTimeout        = 79;
  spi_GetPowerOffTimeout        = 80;
  spi_SetLowPowerTimeout        = 81;
  spi_SetPowerOffTimeout        = 82;
  spi_GetLowPowerActive         = 83;
  spi_GetPowerOffActive         = 84;
  spi_SetLowPowerActive         = 85;
  spi_SetPowerOffActive         = 86;
  spi_SetCursors                = 87;
  spi_SetIcons                  = 88;
  spi_GetDefaultInputLang       = 89;
  spi_SetDefaultInputLang       = 90;
  spi_Setlangtoggle             = 91;
  spi_GetWindowsExtension       = 92;
  spi_SetMouseTrails            = 93;
  spi_GetMouseTrails            = 94;
  spi_GetFilterKeys             = 50;
  spi_SetFilterKeys             = 51;
  spi_GetToggleKeys             = 52;
  spi_SetToggleKeys             = 53;
  spi_GetMouseKeys              = 54;
  spi_SetMouseKeys              = 55;
  spi_GetShowSounds             = 56;
  spi_SetShowSounds             = 57;
  spi_GetStickyKeys             = 58;
  spi_SetStickyKeys             = 59;
  spi_GetAccessTimeout          = 60;
  spi_SetAccessTimeout          = 61;
  spi_GetSerialKeys             = 62;
  spi_SetSerialKeys             = 63;
  spi_GetSoundsEntry            = 64;
  spi_SetSoundsEntry            = 65;

{ Flags }

  spif_UpdateIniFile            = $0001;
  spif_SendWinIniChange         = $0002;
  spif_SendChange               = spif_SendWinIniChange;

  dm_Update                     = 1;
  dm_Copy                       = 2;
  dm_Prompt                     = 4;
  dm_Modify                     = 8;

  dm_In_Buffer                  = dm_Modify;
  dm_In_Prompt                  = dm_Prompt;
  dm_Out_Buffer                 = dm_Copy;
  dm_Out_Default                = dm_Update;

{ device capabilities indices }

  dc_Fields                     = 1;
  dc_Papers                     = 2;
  dc_PaperSize                  = 3;
  dc_MinExtent                  = 4;
  dc_MaxExtent                  = 5;
  dc_Bins                       = 6;
  dc_Duplex                     = 7;
  dc_Size                       = 8;
  dc_Extra                      = 9;
  dc_Version                    = 10;
  dc_Driver                     = 11;
  dc_BinNames                   = 12;
  dc_EnumResolutions            = 13;
  dc_FileDependencies           = 14;
  dc_TrueType                   = 15;
  dc_PaperNames                 = 16;
  dc_Orientation                = 17;
  dc_Copies                     = 18;
  dc_BinAdjust                  = 19;
  dc_Emf_Compliant              = 20;
  dc_DataType_Produced          = 21;

{ ExtFloodFill style flags }

  FloodFillBorder               = 0;
  FloodFillSurface              = 1;

{ StretchBlt Modes }

  Stretch_AndScans              = 1;
  Stretch_OrScans               = 2;
  Stretch_DeleteScans           = 3;
  Stretch_HalfTone              = 4;
  MaxStretchBltMode             = 4;

  BlackOnWhite                  = Stretch_AndScans;
  WhiteOnBlack                  = Stretch_OrScans;
  ColorOnColor                  = Stretch_DeleteScans;
  HalfTone                      = Stretch_HalfTone;

{ PolyDraw and GetPath point types }

  pt_CloseFigure                = $01;
  pt_LineTo                     = $02;
  pt_BezierTo                   = $04;
  pt_MoveTo                     = $06;

{ color usage }

  dib_Rgb_Colors                = 0;
  dib_Pal_Colors                = 1;

{ GDI object types }

  obj_Pen                       = 1;
  obj_Brush                     = 2;
  obj_Dc                        = 3;
  obj_MetaDc                    = 4;
  obj_Pal                       = 5;
  obj_Font                      = 6;
  obj_Bitmap                    = 7;
  obj_Region                    = 8;
  obj_MetaFile                  = 9;
  obj_MemDc                     = 10;
  obj_ExtPen                    = 11;
  obj_EnhMetaDc                 = 12;
  obj_EnhMetaFile               = 13;

{ ScrollWindowEx() scroll flags }

  sw_ScrollChildren             = $0001;
  sw_Invalidate                 = $0002;
  sw_Erase                      = $0004;

{ Enhanced Metafile structures }

  enhmeta_Signature             = $464D4520;
  enhmeta_Stock_Object          = $80000000;

  emr_Header                    = 1;
  emr_PolyBezier                = 2;
  emr_Polygon                   = 3;
  emr_PolyLine                  = 4;
  emr_PolybezierTo              = 5;
  emr_PolyLineTo                = 6;
  emr_PolyPolyLine              = 7;
  emr_PolyPolygon               = 8;
  emr_SetWindowExtEx            = 9;
  emr_SetWindowOrgEx            = 10;
  emr_SetViewPortExtEx          = 11;
  emr_SetViewPortOrgEx          = 12;
  emr_SetBrushOrgEx             = 13;
  emr_Eof                       = 14;
  emr_SetPixelV                 = 15;
  emr_SetMapperFlags            = 16;
  emr_SetMapMode                = 17;
  emr_SetBkMode                 = 18;
  emr_SetPolyFillMode           = 19;
  emr_SetRop2                   = 20;
  emr_SetStretchBltMode         = 21;
  emr_SetTextAlign              = 22;
  emr_SetColorAdjustment        = 23;
  emr_SetTextColor              = 24;
  emr_SetBkColor                = 25;
  emr_OffsetClipRgn             = 26;
  emr_MoveToEx                  = 27;
  emr_SetMetaRgn                = 28;
  emr_ExcludeClipRect           = 29;
  emr_IntersectClipRect         = 30;
  emr_ScaleViewPortExtEx        = 31;
  emr_ScaleWindowExtEx          = 32;
  emr_SaveDC                    = 33;
  emr_RestoreDC                 = 34;
  emr_SetWorldTransform         = 35;
  emr_ModifyWorldTransform      = 36;
  emr_SelectObject              = 37;
  emr_CreatePen                 = 38;
  emr_CreateBrushIndirect       = 39;
  emr_DeleteObject              = 40;
  emr_AngleArc                  = 41;
  emr_Ellipse                   = 42;
  emr_Rectangle                 = 43;
  emr_RoundRect                 = 44;
  emr_Arc                       = 45;
  emr_Chord                     = 46;
  emr_Pie                       = 47;
  emr_SelectPalette             = 48;
  emr_CreatePalette             = 49;
  emr_SetPaletteEntries         = 50;
  emr_ResizePalette             = 51;
  emr_RealizePalette            = 52;
  emr_ExtFloodFill              = 53;
  emr_LineTo                    = 54;
  emr_ArcTo                     = 55;
  emr_PolyDraw                  = 56;
  emr_SetArcDirection           = 57;
  emr_SetMiterLimit             = 58;
  emr_BeginPath                 = 59;
  emr_EndPath                   = 60;
  emr_CloseFigure               = 61;
  emr_FillPath                  = 62;
  emr_StrokeAndFillPath         = 63;
  emr_StrokePath                = 64;
  emr_FlattenPath               = 65;
  emr_WidenPath                 = 66;
  emr_SelectClipPath            = 67;
  emr_AbortPath                 = 68;
  emr_GdiComment                = 70;
  emr_FillRgn                   = 71;
  emr_FrameRgn                  = 72;
  emr_InvertRgn                 = 73;
  emr_PaintRgn                  = 74;
  emr_ExtSelectClipRgn          = 75;
  emr_BitBlt                    = 76;
  emr_StretchBlt                = 77;
  emr_MaskBlt                   = 78;
  emr_PlgBlt                    = 79;
  emr_SetDibitsToDevice         = 80;
  emr_StretchDiBits             = 81;
  emr_ExtCreateFontIndirectW    = 82;
  emr_ExtTextOutA               = 83;
  emr_ExtTextOutW               = 84;
  emr_PolyBezier16              = 85;
  emr_Polygon16                 = 86;
  emr_PolyLine16                = 87;
  emr_PolyBezierTo16            = 88;
  emr_PolyLineTo16              = 89;
  emr_PolyPolyLine16            = 90;
  emr_PolyPolyGon16             = 91;
  emr_Polydraw16                = 92;
  emr_CreateMonoBrush           = 93;
  emr_CreateDibPatternBrushPt   = 94;
  emr_ExtCreatePen              = 95;
  emr_PolyTextOutA              = 96;
  emr_PolyTextOutW              = 97;
  emr_SetIcmMode                = 98;
  emr_CreateColorSpace          = 99;
  emr_SetColorSpace             = 100;
  emr_DeleteColorSpace          = 101;

  emr_Min                       = 1;
  emr_Max                       = 101;

{ Forward Declaration }

  lf_FaceSize                   = 32;

type
  PLogFont = ^TLogFont;
  PLogFontA = ^TLogFontA;
  PLogFontW = ^TLogFontW;
  TLogFont = packed record
    lfHeight:           Long;
    lfWidth:            Long;
    lfEscapement:       Long;
    lfOrientation:      Long;
    lfWeight:           Long;
    lfItalic:           Byte;
    lfUnderline:        Byte;
    lfStrikeOut:        Byte;
    lfCharSet:          Byte;
    lfOutPrecision:     Byte;
    lfClipPrecision:    Byte;
    lfQuality:          Byte;
    lfPitchAndFamily:   Byte;
    lfFaceName: array[0..lf_FaceSize-1] of Char;
  end;
  TLogFontW = packed record
    lfHeight: Longint;
    lfWidth: Longint;
    lfEscapement: Longint;
    lfOrientation: Longint;
    lfWeight: Longint;
    lfItalic: Byte;
    lfUnderline: Byte;
    lfStrikeOut: Byte;
    lfCharSet: Byte;
    lfOutPrecision: Byte;
    lfClipPrecision: Byte;
    lfQuality: Byte;
    lfPitchAndFamily: Byte;
    lfFaceName: array[0..LF_FACESIZE - 1] of WideChar;
  end;
  tLogFontA = tLogFont;

  PTextMetric = ^TTextMetric;
  PTextMetricA = ^TTextMetricA;
  PTextMetricW = ^TTextMetricW;
  TTextMetric = record
    tmHeight:           Long;
    tmAscent:           Long;
    tmDescent:          Long;
    tmInternalLeading:  Long;
    tmExternalLeading:  Long;
    tmAveCharWidth:     Long;
    tmMaxCharWidth:     Long;
    tmWeight:           Long;
    tmOverhang:         Long;
    tmDigitizedAspectX: Long;
    tmDigitizedAspectY: Long;
    tmFirstChar:        Char;
    tmLastChar:         Char;
    tmDefaultChar:      Char;
    tmBreakChar:        Char;
    tmItalic:           Byte;
    tmUnderlined:       Byte;
    tmStruckOut:        Byte;
    tmPitchAndFamily:   Byte;
    tmCharSet:          Byte;
  end;
  TTextMetricW = packed record
    tmHeight: Longint;
    tmAscent: Longint;
    tmDescent: Longint;
    tmInternalLeading: Longint;
    tmExternalLeading: Longint;
    tmAveCharWidth: Longint;
    tmMaxCharWidth: Longint;
    tmWeight: Longint;
    tmOverhang: Longint;
    tmDigitizedAspectX: Longint;
    tmDigitizedAspectY: Longint;
    tmFirstChar: WideChar;
    tmLastChar: WideChar;
    tmDefaultChar: WideChar;
    tmBreakChar: WideChar;
    tmItalic: Byte;
    tmUnderlined: Byte;
    tmStruckOut: Byte;
    tmPitchAndFamily: Byte;
    tmCharSet: Byte;
  end;
  TTextMetricA = TTextMetric;

{ Structure }

type
  PPoint = ^TPoint;
  TPoint = record
    X: Long;
    Y: Long;
  end;

  PMsg = ^TMsg;
  TMsg = packed record
    hWnd:    hWnd;
    message: UInt;
    wParam:  wParam;
    lParam:  lParam;
    time:    DWord;
    pt:      TPoint;
  end;

  PRect = ^TRect;
  TRect = record
    case Integer of
      0: (Left, Top, Right, Bottom: Integer);
      1: (TopLeft, BottomRight: TPoint);
  end;

  PWndClass = ^TWndClass;
  TWndClass = record
    style:         UInt;
    lpfnWndProc:   TFNWndProc;
    cbClsExtra:    Integer;
    cbWndExtra:    Integer;
    hInstance:     hInst;
    HIcon:         HIcon;
    HCursor:       HCursor;
    hbrBackground: HBrush;
    lpszMenuName:  PChar;
    lpszClassName: PChar;
  end;

const
  ofs_MaxPathName               = 128;

type
  POfStruct = ^TOfStruct;
  TOfStruct = record
    cBytes:     Byte;
    fFixedDisk: Byte;
    nErrCode:   SmallWord;
    Reserved1:  SmallWord;
    Reserved2:  SmallWord;
    szPathName: array[0..ofs_MaxPathName-1] of Char;
  end;

const
  cchDeviceName = 32;
  cchFormName   = 32;     // size of a form name string

type
  PDeviceMode = ^TDeviceMode;
  PDeviceModeA = ^TDeviceModeA;
  PDeviceModeW = ^TDeviceModeW;
  TDeviceMode = packed record
    dmDeviceName:       array[0..cchDeviceName-1] of Char;
    dmSpecVersion:      SmallWord;
    dmDriverVersion:    SmallWord;
    dmSize:             SmallWord;
    dmDriverExtra:      SmallWord;
    dmFields:           DWord;
    dmOrientation:      Short;
    dmPaperSize:        Short;
    dmPaperLength:      Short;
    dmPaperWidth:       Short;
    dmScale:            Short;
    dmCopies:           Short;
    dmDefaultSource:    Short;
    dmPrintQuality:     Short;
    dmColor:            Short;
    dmDuplex:           Short;
    dmYResolution:      Short;
    dmTTOption:         Short;
    dmCollate:          Short;
    dmFormName:         array[0..32-1] of Byte;
    dmLogPixels:        SmallWord;
    dmBitsPerPel:       DWord;
    dmPelsWidth:        DWord;
    dmPelsHeight:       DWord;
    dmDisplayFlags:     DWord;
    dmDisplayFrequency: DWord;
  end;
  TDeviceModeW = packed record
    dmDeviceName: array[0..CCHDEVICENAME - 1] of WideChar;
    dmSpecVersion: Word;
    dmDriverVersion: Word;
    dmSize: Word;
    dmDriverExtra: Word;
    dmFields: DWord;
    dmOrientation: Short;
    dmPaperSize: Short;
    dmPaperLength: Short;
    dmPaperWidth: Short;
    dmScale: Short;
    dmCopies: Short;
    dmDefaultSource: Short;
    dmPrintQuality: Short;
    dmColor: Short;
    dmDuplex: Short;
    dmYResolution: Short;
    dmTTOption: Short;
    dmCollate: Short;
    dmFormName: array[0..CCHFORMNAME - 1] of WideChar;
    dmLogPixels: Word;
    dmBitsPerPel: DWord;
    dmPelsWidth: DWord;
    dmPelsHeight: DWord;
    dmDisplayFlags: DWord;
    dmDisplayFrequency: DWord;
    dmICMMethod: DWord;
    dmICMIntent: DWord;
    dmMediaType: DWord;
    dmDitherType: DWord;
    dmReserved1: DWord;
    dmReserved2: DWord;
  end;
  tDeviceModeA = tDeviceMode;

  PDevMode = PDeviceMode;
  TDevMode = TDeviceMode;

  TFNDevMode = function(Wnd: hWnd; Driver: hModule; var DevModeOutput: TDeviceMode; DeciveName,Port: PChar; var DevModeInput: TDeviceMode; P7: PChar; P8: Longint): Longint;

const
  dm_SpecVersion                = $0320;
  dm_Orientation                = $00000001;
  dm_PaperSize                  = $00000002;
  dm_PaperLength                = $00000004;
  dm_PaperWidth                 = $00000008;
  dm_Scale                      = $00000010;
  dm_Copies                     = $00000100;
  dm_DefaultSource              = $00000200;
  dm_PrintQuality               = $00000400;
  dm_Color                      = $00000800;
  dm_Duplex                     = $00001000;
  dm_YResolution                = $00002000;
  dm_TTOption                   = $00004000;
  dm_Collate                    = $00008000;
  dm_FormName                   = $00010000;

  dmOrient_Portrait             = 1;
  dmOrient_Landscape            = 2;

  dmpaper_Letter                = 1;
  dmpaper_First                 = dmpaper_Letter;
  dmpaper_LetterSmall           = 2;
  dmpaper_TabLoid               = 3;
  dmpaper_Ledger                = 4;
  dmpaper_Legal                 = 5;
  dmpaper_Statement             = 6;
  dmpaper_Executive             = 7;
  dmpaper_A3                    = 8;
  dmpaper_A4                    = 9;
  dmpaper_A4Small               = 10;
  dmpaper_A5                    = 11;
  dmpaper_B4                    = 12;
  dmpaper_B5                    = 13;
  dmpaper_Folio                 = 14;
  dmpaper_QuarTo                = 15;
  dmpaper_10x14                 = 16;
  dmpaper_11x17                 = 17;
  dmpaper_Note                  = 18;
  dmpaper_Env_9                 = 19;
  dmpaper_Env_10                = 20;
  dmpaper_Env_11                = 21;
  dmpaper_Env_12                = 22;
  dmpaper_Env_14                = 23;
  dmpaper_CSheet                = 24;
  dmpaper_DSheet                = 25;
  dmpaper_ESheet                = 26;
  dmpaper_Env_Dl                = 27;
  dmpaper_Env_C5                = 28;
  dmpaper_Env_C3                = 29;
  dmpaper_Env_C4                = 30;
  dmpaper_Env_C6                = 31;
  dmpaper_Env_C65               = 32;
  dmpaper_Env_B4                = 33;
  dmpaper_Env_B5                = 34;
  dmpaper_Env_b6                = 35;
  dmpaper_Env_Italy             = 36;
  dmpaper_Env_Monarch           = 37;
  dmpaper_Env_Personal          = 38;
  dmpaper_FanFold_Us            = 39;
  dmpaper_FanFold_Std_German    = 40;
  dmpaper_FanFold_Lgl_German    = 41;
  dmpaper_Last                  = dmpaper_FanFold_Lgl_German;
  dmpaper_user                  = 256;

  dmbin_Upper                   = 1;
  dmbin_First                   = dmbin_Upper;
  dmbin_OnlyOne                 = 1;
  dmbin_Lower                   = 2;
  dmbin_Middle                  = 3;
  dmbin_Manual                  = 4;
  dmbin_Envelope                = 5;
  dmbin_EnvManual               = 6;
  dmbin_Auto                    = 7;
  dmbin_Tractor                 = 8;
  dmbin_SmallFmt                = 9;
  dmbin_LargeFmt                = 10;
  dmbin_LargeCapacity           = 11;
  dmbin_Cassette                = 14;
  dmbin_FormSource              = 15;
  dmbin_Last                    = dmbin_FormSource;

  dmbin_user                    = 256;

  dmres_Draft                   = -1;
  dmres_Low                     = -2;
  dmres_Medium                  = -3;
  dmres_High                    = -4;

  dmcolor_Monochrome            = 1;
  dmcolor_Color                 = 2;

  dmdup_Simplex                 = 1;
  dmdup_Vertical                = 2;
  dmdup_Horizontal              = 3;

  dmtt_Bitmap                   = 1;
  dmtt_DownLoad                 = 2;
  dmtt_SubDev                   = 3;

  dmcollate_False               = 0;
  dmcollate_True                = 1;

  dm_GrayScale                  = $00000001;
  dm_Interlaced                 = $00000002;

type
  PSize = ^TSize;
  TSize = record
    cx: Longint;
    cy: Longint;
  end;

  PSmallPoint = ^TSmallPoint;
  TSmallPoint = record
    x: SmallInt;
    y: SmallInt;
  end;

  PCreateStruct = ^TCreateStruct;
  TCreateStruct = packed record
    lpCreateParams: Pointer;
    hInstance:      THandle;
    hMenu:          hMenu;
    hwndParent:     hWnd;
    cy:             Longint;
    cx:             Longint;
    y:              Longint;
    x:              Longint;
    style:          Longint;
    lpszName:       PChar;
    lpszClass:      PChar;
    dwExStyle:      Longint;
  end;

  PClientCreateStruct = ^TClientCreateStruct;
  TClientCreateStruct = packed record
    hWindowMenu:  THandle;
    idFirstChild: Longint;
  end;

  PMDICreateStruct = ^TMDICreateStruct;
  TMDICreateStruct = packed record
    szClass: PChar;
    szTitle: PChar;
    hOwner:  THandle;
    x:       Longint;
    y:       Longint;
    cx:      Longint;
    cy:      Longint;
    style:   Longint;
    lParam:  lParam;
  end;

  PSecurityAttributes = ^TSecurityAttributes;
  TSecurityAttributes = record
    nLength: Longint;
    lpSecurityDescriptor: Pointer;
    bInheritHandle: Bool;
  end;

  PSecurityDescriptor = Pointer;

  PPaintStruct = ^TPaintStruct;
  TPaintStruct = packed record
    hdc:         HDC;
    fErase:      Bool;
    rcPaint:     TRect;
    fRestore:    Bool;
    fIncUpdate:  Bool;
    rgbReserved: array[0..31] of Byte;
  end;

{ Palette Entry Flags }
const
  pc_Reserved                   = $01;
  pc_Explicit                   = $02;
  pc_NoCollapse                 = $04;

type
  PPaletteEntry = ^TPaletteEntry;
  TPaletteEntry = packed record
    peRed:   Byte;
    peGreen: Byte;
    peBlue:  Byte;
    peFlags: Byte;
  end;

  PLogPalette = ^TLogPalette;
  TLogPalette = packed record
    palVersion:    SmallWord;
    palNumEntries: SmallWord;
    palPalEntry:   array[0..1] of TPaletteEntry;
  end;

  PXForm = ^TXForm;
  TXForm = packed record
    eM11: Single;
    eM12: Single;
    eM21: Single;
    eM22: Single;
    eDx:  Single;
    eDy:  Single;
  end;

  PBitmapCoreHeader = ^TBitmapCoreHeader;
  TBitmapCoreHeader = packed record
    bcSize:     Longint;
    bcWidth:    SmallWord;
    bcHeight:   SmallWord;
    bcPlanes:   SmallWord;
    bcBitCount: SmallWord;
  end;

  PBitmapInfoHeader = ^TBitmapInfoHeader;
  TBitmapInfoHeader = packed record
    biSize:          Longint;
    biWidth:         Longint;
    biHeight:        Longint;
    biPlanes:        SmallWord;
    biBitCount:      SmallWord;
    biCompression:   Longint;
    biSizeImage:     Longint;
    biXPelsPerMeter: Longint;
    biYPelsPerMeter: Longint;
    biClrUsed:       Longint;
    biClrImportant:  Longint;
  end;

  PBitmapFileHeader = ^TBitmapFileHeader;
  TBitmapFileHeader = packed record
    bfType:      SmallWord;
    bfSize:      Longint;
    bfReserved1: SmallWord;
    bfReserved2: SmallWord;
    bfOffBits:   Longint;
  end;

{ biCompression Field Constants }
const
  bi_Rgb                        = 0;
  bi_Rle8                       = 1;
  bi_Rle4                       = 2;
  bi_BitFields                  = 3;

type
  PRGBTriple = ^TRGBTriple;
  TRGBTriple = packed record
    rgbtBlue:  Byte;
    rgbtGreen: Byte;
    rgbtRed:   Byte;
  end;

  PBitmapCoreInfo = ^TBitmapCoreInfo;
  TBitmapCoreInfo = record
    bmciHeader: TBitmapCoreHeader;
    bmciColors: array[0..0] of TRGBTriple;
  end;

  PRGBQuad = ^TRGBQuad;
  TRGBQuad = packed record
    rgbBlue:     Byte;
    rgbGreen:    Byte;
    rgbRed:      Byte;
    rgbReserved: Byte;
  end;

  PBitmapInfo = ^TBitmapInfo;
  TBitmapInfo = packed record
    bmiHeader: TBitmapInfoHeader;
    bmiColors: array[0..0] of TRGBQuad;
  end;

{ Xform FLAGS }
const
  mwt_Identity                  = 1;
  mwt_LeftMultiply              = 2;
  mwt_RightMultiply             = 3;

{ Mapping Modes }
  mm_Text                       = 1;
  mm_LoMetric                   = 2;
  mm_HiMetric                   = 3;
  mm_LoEnglish                  = 4;
  mm_HiEnglish                  = 5;
  mm_TWips                      = 6;
  mm_IsoTropic                  = 7;
  mm_AnisoTropic                = 8;

type
  PDocInfo = ^TDocInfo;
  TDocInfo = packed record
    cbSize:      Longint;
    lpszDocName: PChar;
    lpszOutput:  PChar;
  end;

{ Logical Brush (or Pattern) }

type
  PLogBrush = ^TLogBrush;
  TLogBrush = packed record
    lbStyle: Longint;
    lbColor: TColorRef;
    lbHatch: Longint;
  end;

{ Logical Pen }

  PLogPen = ^TLogPen;
  TLogPen = packed record
    lopnStyle: Longint;
    lopnWidth: TPoint;
    lopnColor: TColorRef;
  end;

  PExtLogPen = ^TLogPen;
  TExtLogPen = packed record
    elpPenStyle:   Longint;
    elpWidth:      Longint;
    elpBrushStyle: Longint;
    elpColor:      TColorRef;
    elpHatch:      Longint;
    elpNumEntries: Longint;
    elpStyleEntry: array[0..0] of Longint;
  end;

{ constants for CreateDIBitmap }
const
  cbm_CreateDib                 = $02; { create DIB bitmap }
  cbm_Init                      = $04; { initialize bitmap }

{ ExtTexOut options }
  eto_Grayed                    = 1;
  eto_Opaque                    = 2;
  eto_Clipped                   = 4;

{ Background Modes }
  Transparent                   = 1;
  Opaque                        = 2;
  BkMode_Last                   = 2;

{ Bitmap Header Definition }
type
  PBitmap = ^TBitmap;
  TBitmap = packed record
    bmType:       Longint;
    bmWidth:      Longint;
    bmHeight:     Longint;
    bmWidthBytes: Longint;
    bmPlanes:     SmallWord;
    bmBitsPixel:  SmallWord;
    bmBits:       Pointer;
  end;

  PGlyphMetrics = ^TGlyphMetrics;
  TGlyphMetrics = packed record
    gmBlackBoxX:     Longint;
    gmBlackBoxY:     Longint;
    gmptGlyphOrigin: TPoint;
    gmCellIncX:      SmallInt;
    gmCellIncY:      SmallInt;
  end;

{ GetGlyphOutline constants }
const
  ggo_Metrics                   = 0;
  ggo_Bitmap                    = 1;
  ggo_Native                    = 2;

type
  TFixed = packed record
    fract: SmallWord;
    value: SmallInt;
  end;

  PMat2 = ^TMat2;
  TMat2 = packed record
    eM11: TFixed;
    eM12: TFixed;
    eM21: TFixed;
    eM22: TFixed;
  end;

{ Clipboard Metafile Picture Structure }

  PHandleTable = ^THandleTable;
  THandleTable = packed record
    objectHandle: array[0..0] of HGDIObj;
  end;

  PMetaRecord = ^TMetaRecord;
  TMetaRecord = record
    rdSize:     Longint;
    rdFunction: SmallWord;
    rdParm:     array[0..0] of SmallWord;
  end;

{ Dialog Template & Item Structures }

  PDlgTemplate = ^TDlgTemplate;
  TDlgTemplate = record
    style:           Longint;
    dwExtendedStyle: Longint;
    cdit:            SmallWord;
    x:               SmallWord;
    y:               SmallWord;
    cx:              SmallWord;
    cy:              SmallWord;
  end;

  PDlgItemTemplate = ^TDlgItemTemplate;
  TDlgItemTemplate = record
    style:           Longint;
    dwExtendedStyle: Longint;
    x:               SmallWord;
    y:               SmallWord;
    cx:              SmallWord;
    cy:              SmallWord;
    id:              SmallWord;
  end;

{ Window Placement Structure }

  PWindowPlacement = ^TWindowPlacement;
  TWindowPlacement = record
    length:           Longint;
    flags:            Longint;
    showCmd:          Longint;
    ptMinPosition:    TPoint;
    ptMaxPosition:    TPoint;
    rcNormalPosition: TRect;
  end;

{ Filetime Structure }

  PFileTime = ^TFileTime;
  TFileTime = record
    dwLowDateTime:  Longint;
    dwHighDateTime: Longint;
  end;

{ Systemtime Structure }

  PSystemTime = ^TSystemTime;
  TSystemTime = record
    wYear:         SmallWord;
    wMonth:        SmallWord;
    wDayOfWeek:    SmallWord;
    wDay:          SmallWord;
    wHour:         SmallWord;
    wMinute:       SmallWord;
    wSecond:       SmallWord;
    wMilliseconds: SmallWord;
  end;

{ Access Mask }

  Access_Mask   = Longint;
  PAccess_Mask  = ^Access_Mask;
  RegSam        = Access_Mask;

{ METAFILEPICT Structure }

  PMetafilePict = ^TMetafilePict;
  TMetafilePict = packed record
    mm:   Longint;
    xExt: Longint;
    yExt: Longint;
    hMF:  HMetafile;
  end;

  PMetaHeader = ^TMetaHeader;
  TMetaHeader = packed record
    mtType:         SmallWord;
    mtHeaderSize:   SmallWord;
    mtVersion:      SmallWord;
    mtSize:         Longint;
    mtNoObjects:    SmallWord;
    mtMaxRecord:    Longint;
    mtNoParameters: SmallWord;
  end;

  POverlapped = ^TOverlapped;
  TOverlapped = record
    Internal:     Longint;
    InternalHigh: Longint;
    Offset:       Longint;
    OffsetHigh:   Longint;
    hEvent:       THandle;
  end;

  PMemoryStatus = ^TMemoryStatus;
  TMemoryStatus = record
    dwLength:        Longint;
    dwMemoryLoad:    Longint;
    dwTotalPhys:     Longint;
    dwAvailPhys:     Longint;
    dwTotalPageFile: Longint;
    dwAvailPageFile: Longint;
    dwTotalVirtual:  Longint;
    dwAvailVirtual:  Longint;
  end;

const
  Default_Charset               = 1;
  Shiftjis_Charset              = 128;
  Hangeul_Charset               = 129;
  Gb2312_Charset                = 134;
  Chinesebig5_Charset           = 136;
  Johab_Charset                 = 130;
  Hebrew_Charset                = 177;
  Arabic_Charset                = 178;
  Greek_Charset                 = 161;
  Turkish_Charset               = 162;
  Thai_Charset                  = 222;
  Easteurope_Charset            = 238;
  Russian_Charset               = 204;

{ EnumFonts Masks }

  Raster_FontType               = $0001;
  Device_FontType               = $0002;
  TrueType_FontType             = $0004;

  out_Tt_Precis                 = 4;
  out_Device_Precis             = 5;
  out_Raster_Precis             = 6;
  out_Tt_Only_Precis            = 7;
  out_Outline_Precis            = 8;

  clip_Mask                     = $000F;
  clip_Lh_Angles                = $0010;
  clip_Tt_Always                = $0020;
  clip_Embedded                 = $0080;

{ MEASUREITEMSTRUCT for ownerdraw }
type
  PMeasureItemStruct = ^TMeasureItemStruct;
  TMeasureItemStruct = packed record
    CtlType:    Longint;
    CtlID:      Longint;
    itemID:     Longint;
    itemWidth:  Longint;
    itemHeight: Longint;
    itemData:   Longint;
  end;

{ DRAWITEMSTRUCT for ownerdraw }

  PDrawItemStruct = ^TDrawItemStruct;
  TDrawItemStruct = packed record
    CtlType:    Longint;
    CtlID:      Longint;
    itemID:     Longint;
    itemAction: Longint;
    itemState:  Longint;
    hwndItem:   hWnd;
    hDC:        HDC;
    rcItem:     TRect;
    itemData:   Longint;
  end;

{ DELETEITEMSTRUCT for ownerdraw }

  PDeleteItemStruct = ^TDeleteItemStruct;
  TDeleteItemStruct = packed record
    CtlType:  Longint;
    CtlID:    Longint;
    itemID:   Longint;
    hwndItem: hWnd;
    itemData: Longint;
  end;

{ COMPAREITEMSTUCT for ownerdraw sorting }

  PCompareItemStruct = ^TCompareItemStruct;
  TCompareItemStruct = packed record
    CtlType:   Longint;
    CtlID:     Longint;
    hwndItem:  hWnd;
    itemID1:   Longint;
    itemData1: Longint;
    itemID2:   Longint;
    itemData2: Longint;
  end;

{ Registry Definitions }
const
  regh_Sysinfo                  = $FFFFFFFD;
  regh_WinOs2Ini                = $FFFFFFFE;
  regh_IniMapping               = $FFFFFFFF;

  key_Query_Value               = $0001;
  key_Set_Value                 = $0002;
  key_Create_Sub_Key            = $0004;
  key_Enumerate_Sub_Keys        = $0008;
  key_Notify                    = $0010;
  key_Create_Link               = $0020;
  reg_Option_Non_Volatile       = $00000000;
  reg_Option_Volatile           = $00000001;
  reg_Created_New_Key           = $00000001;
  reg_Opened_Existing_Key       = $00000002;

  key_Read                      = Read_Control or key_Query_Value or key_Enumerate_Sub_Keys or key_Notify;
  key_Write                     = Read_Control or key_Set_Value or key_Create_Sub_Key;
  key_Execute                   = key_Read;

  key_All_Access                = Standard_Rights_All or key_Query_Value or
                                key_Set_Value or key_Create_Sub_Key or
                                key_Enumerate_Sub_Keys or key_Notify or
                                key_Create_Link;
  reg_None                      = 0;
  reg_Sz                        = 1;
  reg_Expand_Sz                 = 2;
  reg_Binary                    = 3;
  reg_DWord                     = 4;
  reg_DWord_Little_Endian       = 4;
  reg_DWord_Big_Endian          = 5;
  reg_Link                      = 6;
  reg_Multi_Sz                  = 7;
  reg_Resource_List             = 8;

  ewx_LogOff                    = 0;
  ewx_ShutDown                  = 1;
  ewx_Reboot                    = 2;
  ewx_Force                     = 4;
  ewx_PowerOff                  = 8;

type
  PABC = ^TABC;
  TABC = packed record
    abcA: Longint;
    abcB: Longint;
    abcC: Longint;
  end;

  PEnhMetaHeader = ^TEnhMetaHeader;
  TEnhMetaHeader = packed record
    iType:          Longint;
    nSize:          Longint;
    rclBounds:      TRect;
    rclFrame:       TRect;
    dSignature:     Longint;
    nVersion:       Longint;
    nBytes:         Longint;
    nRecords:       Longint;
    nHandles:       SmallWord;
    sReserved:      SmallWord;
    nDescription:   Longint;
    offDescription: Longint;
    nPalEntries:    Longint;
    szlDevice:      TSize;
    szlMillimeters: TSize;
  end;

  PKerningPair = ^TKerningPair;
  TKerningPair = packed record
    wFirst:      SmallWord;
    wSecond:     SmallWord;
    iKernAmount: Longint;
  end;

  PPanose = ^TPanose;
  TPanose = packed record
    bFamilyType:      Byte;
    bSerifStyle:      Byte;
    bWeight:          Byte;
    bProportion:      Byte;
    bContrast:        Byte;
    bStrokeVariation: Byte;
    bArmStyle:        Byte;
    bLetterform:      Byte;
    bMidline:         Byte;
    bXHeight:         Byte;
  end;

  POutlineTextmetric = ^TOutlineTextmetric;
  TOutlineTextmetric = record
    otmSize:                Longint;
    otmTextMetrics:         TTextMetric;
    otmFiller:              Byte;
    otmPanoseNumber:        TPanose;
    otmfsSelection:         Longint;
    otmfsType:              Longint;
    otmsCharSlopeRise:      Longint;
    otmsCharSlopeRun:       Longint;
    otmItalicAngle:         Longint;
    otmEMSquare:            Longint;
    otmAscent:              Longint;
    otmDescent:             Longint;
    otmLineGap:             Longint;
    otmsCapEmHeight:        Longint;
    otmsXHeight:            Longint;
    otmrcFontBox:           TRect;
    otmMacAscent:           Longint;
    otmMacDescent:          Longint;
    otmMacLineGap:          Longint;
    otmusMinimumPPEM:       Longint;
    otmptSubscriptSize:     TPoint;
    otmptSubscriptOffset:   TPoint;
    otmptSuperscriptSize:   TPoint;
    otmptSuperscriptOffset: TPoint;
    otmsStrikeoutSize:      Longint;
    otmsStrikeoutPosition:  Longint;
    otmsUnderscoreSize:     Longint;
    otmsUnderscorePosition: Longint;
    otmpFamilyName:         PChar;
    otmpFaceName:           PChar;
    otmpStyleName:          PChar;
    otmpFullName:           PChar;
  end;

  PRasterizerStatus = ^TRasterizerStatus;
  TRasterizerStatus = packed record
    nSize:       SmallInt;
    wFlags:      SmallInt;
    nLanguageID: SmallInt;
  end;

{ bits defined in wFlags of RASTERIZER_STATUS }
const
  tt_Available                  = $0001;
  tt_Enabled                    = $0002;

  tt_Polygon_Type               = 24;
  tt_Prim_Line                  = 1;
  tt_Prim_QSpline               = 2;

type
  PPointfx = ^TPointfx;
  TPointfx = packed record
    x: TFixed;
    y: TFixed;
  end;

  PTTPolyCurve = ^TTTPolyCurve;
  TTTPolyCurve = packed record
    wType: SmallWord;
    cpfx:  SmallWord;
    apfx:  array[0..0] of TPointFX;
  end;

  PTTPolygonHeader = ^TTTPolygonHeader;
  TTTPolygonHeader = packed record
    cb: Longint;
    dwType: Longint;
    pfxStart: TPointFX;
  end;

const
  wpf_SetMinPosition            = $0001;
  wpf_RestoreToMaximized        = $0002;

type
  PWin32FindData = ^TWin32FindData;
  TWin32FindData = record
    dwFileAttributes:   Longint;
    ftCreationTime:     TFileTime;
    ftLastAccessTime:   TFileTime;
    ftLastWriteTime:    TFileTime;
    nFileSizeHigh:      Longint;
    nFileSizeLow:       Longint;
    dwReserved0:        Longint;
    dwReserved1:        Longint;
    cFileName:          array[0..Max_Path-1] of Char;
    cAlternateFileName: array[0..13] of Char;
  end;

{ Menu item resource format }

  PMenuItemTemplateHeader = ^TMenuItemTemplateHeader;
  TMenuItemTemplateHeader = packed record
    versionNumber: SmallWord;
    offset:        SmallWord;
  end;

  PMenuItemTemplate = ^TMenuItemTemplate;
  TMenuItemTemplate = packed record
    mtOption: SmallWord;
    mtID:     SmallWord;
    mtString: array[0..0] of WChar;
  end;

const
  startf_UseShowWindow          = $00000001;
  startf_UsePosition            = $00000002;
  startf_UseSize                = $00000004;

type
  PStartupInfo = ^TStartupInfo;
  TStartupInfo = record
    cb:              Longint;
    lpReserved:      PChar;
    lpDesktop:       PChar;
    lpTitle:         PChar;
    dwX:             Longint;
    dwY:             Longint;
    dwXSize:         Longint;
    dwYSize:         Longint;
    dwXCountChars:   Longint;
    dwYCountChars:   Longint;
    dwFillAttribute: Longint;
    dwFlags:         Longint;
    wShowWindow:     SmallWord;
    cbReserved2:     SmallWord;
    lpReserved2:     PByte;
    hStdInput:       THandle;
    hStdOutput:      THandle;
    hStdError:       THandle;
  end;

  PProcessInformation = ^TProcessInformation;
  TProcessInformation = record
    hProcess:    THandle;
    hThread:     THandle;
    dwProcessId: Longint;
    dwThreadId:  Longint;
  end;

  PListEntry = ^TListEntry;
  TListEntry = record
    Flink: PListEntry;
    Blink: PListEntry;
  end;

  PRTLCriticalSection = ^TRTLCriticalSection;
  PRTLCriticalSectionDebug = ^TRTLCriticalSectionDebug;
  TRTLCriticalSectionDebug = record
    _Type:                 SmallWord;
    CreatorBackTraceIndex: SmallWord;
    CriticalSection:       PRTLCriticalSection;
    ProcessLocksList:      TListEntry;
    EntryCount:            DWord;
    ContentionCount:       DWord;
    Spare: array [0..1] of DWord;
  end;

  TRTLCriticalSection = record
{$IFDEF Open32}
    ulReserved: array[0..7] of Longint;
{$ELSE}
    DebugInfo:      PRTLCriticalSectionDebug;
    LockCount:      Longint;
    RecursionCount: Longint;
    OwningThread:   THandle;
    LockSemaphore:  THandle;
    Reserved:       DWord;
{$ENDIF Open32}
  end;

  PByHandleFileInformation = ^TByHandleFileInformation;
  TByHandleFileInformation = record
    dwFileAttributes:     Longint;
    ftCreationTime:       TFileTime;
    ftLastAccessTime:     TFileTime;
    ftLastWriteTime:      TFileTime;
    dwVolumeSerialNumber: Longint;
    nFileSizeHigh:        Longint;
    nFileSizeLow:         Longint;
    nNumberOfLinks:       Longint;
    nFileIndexHigh:       Longint;
    nFileIndexLow:        Longint;
  end;

  PAccel = ^TAccel;
  TAccel = packed record
    fVirt: Byte;
    key:   SmallWord;
    cmd:   SmallWord;
  end;

  PEMR = ^TEMR;
  TEMR = packed record
    iType: Longint;
    nSize: Longint;
  end;

  PEMRText = ^TEMRText;
  TEMRText = packed record
    ptlReference: TPoint;
    nChars:       Longint;
    offString:    Longint;
    fOptions:     Longint;
    rcl:          TRect;
    offDx:        Longint;
  end;

  PAbortPath = ^TAbortPath;
  TAbortPath = packed record
    emr: TEMR;
  end;

  PEMRSelectclippath = ^TEMRSelectClipPath;
  TEMRSelectClipPath = packed record
    emr: TEMR;
    iMode: Longint;
  end;

  PEMRSetMiterLimit = ^TEMRSetMiterLimit;
  TEMRSetMiterLimit = packed record
    emr:         TEMR;
    eMiterLimit: Single;
  end;

  PEMRRestoreDC = ^TEMRRestoreDC;
  TEMRRestoreDC = packed record
    emr:       TEMR;
    iRelative: Longint;
  end;

  PEMRSetArcDirection = ^TEMRSetArcDirection;
  TEMRSetArcDirection = packed record
    emr:           TEMR;
    iArcDirection: Longint;
  end;

  PEMRSetMapperFlags = ^TEMRSetMapperFlags;
  TEMRSetMapperFlags = packed record
    emr:     TEMR;
    dwFlags: Longint;
  end;

  PEMRSetTextColor = ^TEMRSetTextColor;
  TEMRSetTextColor = packed record
    emr:     TEMR;
    crColor: TColorRef;
  end;
  TEMRSetBkColor = TEMRSetTextColor;
  PEMRSetBkColor = PEMRSetTextColor;

  PEMRSelectObject = ^TEMRSelectObject;
  TEMRSelectObject = packed record
    emr:      TEMR;
    ihObject: Longint;
  end;
  EMRDeleteObject = TEMRSelectObject;
  PEMRDeleteObject = PEMRSelectObject;

  PEMRSelectColorSpace = ^TEMRSelectColorSpace;
  TEMRSelectColorSpace = packed record
    emr:  TEMR;
    ihCS: Longint;
  end;
  EMRDeleteColorSpace = TEMRSelectColorSpace;
  PEMRDeleteColorSpace = PEMRSelectColorSpace;

  PEMRSelectPalette = ^TEMRSelectPalette;
  TEMRSelectPalette = packed record
    emr:   TEMR;
    ihPal: Longint;
  end;

  PEMRResizePalette = ^TEMRResizePalette;
  TEMRResizePalette = packed record
    emr:      TEMR;
    ihPal:    Longint;
    cEntries: Longint;
  end;

  PEMRSetPaletteEntries = ^TEMRSetPaletteEntries;
  TEMRSetPaletteEntries = packed record
    emr:         TEMR;
    ihPal:       Longint;
    iStart:      Longint;
    cEntries:    Longint;
    aPalEntries: array[0..0] of TPaletteEntry;
  end;

  PColorAdjustment = ^TColorAdjustment;
  TColorAdjustment = packed record
    caSize:            SmallWord;
    caFlags:           SmallWord;
    caIlluminantIndex: SmallWord;
    caRedGamma:        SmallWord;
    caGreenGamma:      SmallWord;
    caBlueGamma:       SmallWord;
    caReferenceBlack:  SmallWord;
    caReferenceWhite:  SmallWord;
    caContrast:        SmallInt;
    caBrightness:      SmallInt;
    caColorfulness:    SmallInt;
    caRedGreenTint:    SmallInt;
  end;

  PEMRSetColorAdjustment = ^TEMRSetColorAdjustment;
  TEMRSetColorAdjustment = packed record
    emr:             TEMR;
    ColorAdjustment: TColorAdjustment;
  end;

  PEMRGDIComment = ^TEMRGDIComment;
  TEMRGDIComment = record
    emr:    TEMR;
    cbData: Longint;
    Data:   array[0..0] of Byte;
  end;

  PEMREOF = ^TEMREOF;
  TEMREOF = packed record
    emr:           TEMR;
    nPalEntries:   Longint;
    offPalEntries: Longint;
    nSizeLast:     Longint;
  end;

  PEMRLineTo = ^TEMRLineTo;
  TEMRLineTo = packed record
    emr: TEMR;
    ptl: TPoint;
  end;
  EMRMoveToEx = TEMRLineTo;
  PEMRMoveToEx = PEMRLineTo;

  PEMROffsetClipRgn = ^TEMROffsetClipRgn;
  TEMROffsetClipRgn = packed record
    emr:       TEMR;
    ptlOffset: TPoint;
  end;

  PEMRFillPath = ^TEMRFillPath;
  TEMRFillPath = packed record
    emr:       TEMR;
    rclBounds: TRect;
  end;
  EMRStrokeAndFillPath = TEMRFillPath;
  PEMRStrokeAndFillPath = PEMRFillPath;
  EMRStrokePath = TEMRFillPath;
  PEMRStrokePath = PEMRFillPath;

  PEMRExcludeClipRect = ^TEMRExcludeClipRect;
  TEMRExcludeClipRect = packed record
    emr:     TEMR;
    rclClip: TRect;
  end;
  EMRIntersectClipRect = TEMRExcludeClipRect;
  PEMRIntersectClipRect = PEMRExcludeClipRect;

  PEMRSetViewportOrgEx = ^TEMRSetViewportOrgEx;
  TEMRSetViewportOrgEx = packed record
    emr:       TEMR;
    ptlOrigin: TPoint;
  end;
  EMRSetWindowOrgEx = TEMRSetViewportOrgEx;
  PEMRSetWindowOrgEx = PEMRSetViewportOrgEx;
  EMRSetBrushOrgEx = TEMRSetViewportOrgEx;
  PEMRSetBrushOrgEx = PEMRSetViewportOrgEx;

  PEMRSetViewportExtEx = ^TEMRSetViewportExtEx;
  TEMRSetViewportExtEx = packed record
    emr:       TEMR;
    szlExtent: TSize;
  end;
  EMRSetWindowExtEx = TEMRSetViewportExtEx;
  PEMRSetWindowExtEx = PEMRSetViewportExtEx;

  PEMRScaleViewportExtEx = ^TEMRScaleViewportExtEx;
  TEMRScaleViewportExtEx = packed record
    emr:    TEMR;
    xNum:   Longint;
    xDenom: Longint;
    yNum:   Longint;
    yDenom: Longint;
  end;
  EMRScaleWindowExtEx = TEMRScaleViewportExtEx;
  PEMRScaleWindowExtEx = PEMRScaleViewportExtEx;

  PEMRSetWorldTransform = ^TEMRSetWorldTransform;
  TEMRSetWorldTransform = packed record
    emr:   TEMR;
    xform: TXForm;
  end;

  PEMRModifyWorldTransform = ^TEMRModifyWorldTransform;
  TEMRModifyWorldTransform = packed record
    emr:   TEMR;
    xform: TXForm;
    iMode: Longint;
  end;

  PEMRSetPixelV = ^TEMRSetPixelV;
  TEMRSetPixelV = packed record
    emr:      TEMR;
    ptlPixel: TPoint;
    crColor:  TColorRef;
  end;

  PEMRExtFloodFill = ^TEMRExtFloodFill;
  TEMRExtFloodFill = packed record
    emr:      TEMR;
    ptlStart: TPoint;
    crColor:  TColorRef;
    iMode:    Longint;
  end;


  PEMREllipse = ^TEMREllipse;
  TEMREllipse = packed record
    emr:    TEMR;
    rclBox: TRect;
  end;

  PEMRRoundRect = ^TEMRRoundRect;
  TEMRRoundRect = packed record
    emr:       TEMR;
    rclBox:    TRect;
    szlCorner: TSize;
  end;

  PEMRArc = ^TEMRArc;
  TEMRArc = packed record
    emr:      TEMR;
    rclBox:   TRect;
    ptlStart: TPoint;
    ptlEnd:   TPoint;
  end;

  PEMRAngleArc = ^TEMRAngleArc;
  TEMRAngleArc = packed record
    emr:         TEMR;
    ptlCenter:   TPoint;
    nRadius:     Longint;
    eStartAngle: Single;
    eSweepAngle: Single;
  end;

  PEMRPolyline = ^TEMRPolyline;
  TEMRPolyline = packed record
    emr: TEMR;
    rclBounds: TRect;
    cptl:      Longint;
    aptl:      array[0..0] of TPoint;
  end;
  EMRPolyBezier = TEMRPolyLine;
  PEMRPolyBezier = PEMRPolyLine;
  EMRPolyGON = TEMRPolyLine;
  PEMRPolyGON = PEMRPolyLine;
  EMRPolyBezierTo = TEMRPolyLine;
  PEMRPolyBezierTo = PEMRPolyLine;
  EMRPolyLineTo = TEMRPolyLine;
  PEMRPolyLineTo = PEMRPolyLine;

  PEMRPolyline16 = ^TEMRPolyline16;
  TEMRPolyline16 = packed record
    emr: TEMR;
    rclBounds: TRect;
    cpts:      Longint;
    apts:      array[0..0] of TPoint;
  end;
  EMRPolyBezier16 = TEMRPolyLine16;
  PEMRPolyBezier16 = PEMRPolyLine16;
  EMRPolygon16 = TEMRPolyLine16;
  PEMRPolygon16 = PEMRPolyLine16;
  EMRPolyBezierTo16 = TEMRPolyLine16;
  PEMRPolyBezierTo16 = PEMRPolyLine16;
  EMRPolyLineTo16 = TEMRPolyLine16;
  PEMRPolyLineTo16 = PEMRPolyLine16;

  PEMRPolyDraw = ^TEMRPolyDraw;
  TEMRPolyDraw = record
    emr:       TEMR;
    rclBounds: TRect;
    cptl:      Longint;
    aptl:      array[0..0] of TPoint;
    abTypes:   array[0..0] of Byte;
  end;

  PEMRPolyDraw16 = ^TEMRPolyDraw16;
  TEMRPolyDraw16 = record
    emr:        TEMR;
    rclBounds:  TRect;
    cpts:       Longint;
    apts:       array[0..0] of TPoint;
    abTypes:    array[0..0] of Byte;
  end;

  PEMRPolyPolyline = ^TEMRPolyPolyline;
  TEMRPolyPolyline = packed record
    emr:         TEMR;
    rclBounds:   TRect;
    nPolys:      Longint;
    cptl:        Longint;
    aPolyCounts: array[0..0] of Longint;
    aptl:        array[0..0] of TPoint;
  end;
  EMRPolyPolygon = TEMRPolyPolyline;
  PEMRPolyPolygon = PEMRPolyPolyline;

  PEMRPolyPolyline16 = ^TEMRPolyPolyline16;
  TEMRPolyPolyline16 = packed record
    emr:         TEMR;
    rclBounds:   TRect;
    nPolys:      Longint;
    cpts:        Longint;
    aPolyCounts: array[0..0] of Longint;
    apts:        array[0..0] of TPoint;
  end;
  EMRPolyPolygon16 = TEMRPolyPolyline16;
  PEMRPolyPolygon16 = PEMRPolyPolyline16;

  PEMRInvertRgn = ^TEMRInvertRgn;
  TEMRInvertRgn = record
    emr:       TEMR;
    rclBounds: TRect;
    cbRgnData: Longint;
    RgnData:   array[0..0] of Byte;
  end;
  EMRPaintRgn = TEMRInvertRgn;
  PEMRPaintRgn = PEMRInvertRgn;

  PEMRFillRgn = ^TEMRFillRgn;
  TEMRFillRgn = record
    emr:       TEMR;
    rclBounds: TRect;
    cbRgnData: Longint;
    ihBrush:   Longint;
    RgnData:   array[0..0] of Byte;
  end;

  PEMRFrameRgn = ^TEMRFrameRgn;
  TEMRFrameRgn = record
    emr:       TEMR;
    rclBounds: TRect;
    cbRgnData: Longint;
    ihBrush:   Longint;
    szlStroke: TSize;
    RgnData:   array[0..0] of Byte;
  end;


  PEMRExtSelectClipRgn = ^TEMRExtSelectClipRgn;
  TEMRExtSelectClipRgn = record
    emr:       TEMR;
    cbRgnData: Longint;
    iMode:     Longint;
    RgnData:   array[0..0] of Byte;
  end;

  PEMRExtTextOut = ^TEMRExtTextOut;
  TEMRExtTextOut = packed record
    emr: TEMR;
    rclBounds:     TRect;
    iGraphicsMode: Longint;
    exScale:       Single;
    eyScale:       Single;
    emrtext:       TEMRText;
  end;

  PEMRPolyTextOut = ^TEMRPolyTextOut;
  TEMRPolyTextOut = packed record
    emr:           TEMR;
    rclBounds:     TRect;
    iGraphicsMode: Longint;
    exScale:       Single;
    eyScale:       Single;
    cStrings:      Longint;
    aemrtext:      array[0..0] of TEMRText;
  end;

  PEMRBitBlt = ^TEMRBitBlt;
  TEMRBitBlt = packed record
    emr:          TEMR;
    rclBounds:    TRect;
    xDest:        Longint;
    yDest:        Longint;
    cxDest:       Longint;
    cyDest:       Longint;
    dwRop:        Longint;
    xSrc:         Longint;
    ySrc:         Longint;
    xformSrc:     TXForm;
    crBkColorSrc: TColorRef;
    iUsageSrc:    Longint;
    offBmiSrc:    Longint;
    cbBmiSrc:     Longint;
    offBitsSrc:   Longint;
    cbBitsSrc:    Longint;
  end;

  PEMRStretchBlt = ^TEMRStretchBlt;
  TEMRStretchBlt = packed record
    emr:          TEMR;
    rclBounds:    TRect;
    xDest:        Longint;
    yDest:        Longint;
    cxDest:       Longint;
    cyDest:       Longint;
    dwRop:        Longint;
    xSrc:         Longint;
    ySrc:         Longint;
    xformSrc:     TXForm;
    crBkColorSrc: TColorRef;
    iUsageSrc:    Longint;
    offBmiSrc:    Longint;
    cbBmiSrc:     Longint;
    offBitsSrc:   Longint;
    cbBitsSrc:    Longint;
    cxSrc:        Longint;
    cySrc:        Longint;
  end;

  PEMRMaskBlt = ^TEMRMaskBlt;
  TEMRMaskBlt = packed record
    emr:          TEMR;
    rclBounds:    TRect;
    xDest:        Longint;
    yDest:        Longint;
    cxDest:       Longint;
    cyDest:       Longint;
    dwRop:        Longint;
    xSrc:         Longint;
    ySrc:         Longint;
    xformSrc:     TXForm;
    crBkColorSrc: TColorRef;
    iUsageSrc:    Longint;
    offBmiSrc:    Longint;
    cbBmiSrc:     Longint;
    offBitsSrc:   Longint;
    cbBitsSrc:    Longint;
    xMask:        Longint;
    yMask:        Longint;
    iUsageMask:   Longint;
    offBmiMask:   Longint;
    cbBmiMask:    Longint;
    offBitsMask:  Longint;
    cbBitsMask:   Longint;
  end;

  PEMRPLGBlt = ^TEMRPLGBlt;
  TEMRPLGBlt = packed record
    emr:          TEMR;
    rclBounds:    TRect;
    aptlDest:     array[0..2] of TPoint;
    xSrc:         Longint;
    ySrc:         Longint;
    cxSrc:        Longint;
    cySrc:        Longint;
    xformSrc:     TXForm;
    crBkColorSrc: TColorRef;
    iUsageSrc:    Longint;
    offBmiSrc:    Longint;
    cbBmiSrc:     Longint;
    offBitsSrc:   Longint;
    cbBitsSrc:    Longint;
    xMask:        Longint;
    yMask:        Longint;
    iUsageMask:   Longint;
    offBmiMask:   Longint;
    cbBmiMask:    Longint;
    offBitsMask:  Longint;
    cbBitsMask:   Longint;
  end;

  PEMRSetDIBitsToDevice = ^TEMRSetDIBitsToDevice;
  TEMRSetDIBitsToDevice = packed record
    emr:        TEMR;
    rclBounds:  TRect;
    xDest:      Longint;
    yDest:      Longint;
    xSrc:       Longint;
    ySrc:       Longint;
    cxSrc:      Longint;
    cySrc:      Longint;
    offBmiSrc:  Longint;
    cbBmiSrc:   Longint;
    offBitsSrc: Longint;
    cbBitsSrc:  Longint;
    iUsageSrc:  Longint;
    iStartScan: Longint;
    cScans:     Longint;
  end;

  PEMRStretchDIBits = ^TEMRStretchDIBits;
  TEMRStretchDIBits = packed record
    emr:        TEMR;
    rclBounds:  TRect;
    xDest:      Longint;
    yDest:      Longint;
    xSrc:       Longint;
    ySrc:       Longint;
    cxSrc:      Longint;
    cySrc:      Longint;
    offBmiSrc:  Longint;
    cbBmiSrc:   Longint;
    offBitsSrc: Longint;
    cbBitsSrc:  Longint;
    iUsageSrc:  Longint;
    dwRop:      Longint;
    cxDest:     Longint;
    cyDest:     Longint;
  end;

  PEMRCreatePalette = ^TEMRCreatePalette;
  TEMRCreatePalette = packed record
    emr:   TEMR;
    ihPal: Longint;
    lgpl:  TLogPalette;
  end;

  PEMRCreatePen = ^TEMRCreatePen;
  TEMRCreatePen = packed record
    emr:   TEMR;
    ihPen: Longint;
    lopn:  TLogPen;
  end;


  PEMRExtCreatePen = ^TEMRExtCreatePen;
  TEMRExtCreatePen = packed record
    emr:     TEMR;
    ihPen:   Longint;
    offBmi:  Longint;
    cbBmi:   Longint;
    offBits: Longint;
    cbBits:  Longint;
    elp:     TExtLogPen;
  end;

  PEMRCreateBrushIndirect = ^TEMRCreateBrushIndirect;
  TEMRCreateBrushIndirect = packed record
    emr:     TEMR;
    ihBrush: Longint;
    lb:      TLogBrush;
  end;

  PEMRCreateMonoBrush = ^TEMRCreateMonoBrush;
  TEMRCreateMonoBrush = packed record
    emr:     TEMR;
    ihBrush: Longint;
    iUsage:  Longint;
    offBmi:  Longint;
    cbBmi:   Longint;
    offBits: Longint;
    cbBits:  Longint;
  end;

  PEMRCreateDIBPatternBrushPt = ^TEMRCreateDIBPatternBrushPt;
  TEMRCreateDIBPatternBrushPt = packed record
    emr:     TEMR;
    ihBrush: Longint;
    iUsage:  Longint;
    offBmi:  Longint;
    cbBmi:   Longint;
    offBits: Longint;
    cbBits:  Longint;
  end;

  PEMRFormat = ^TEMRFormat;
  TEMRFormat = packed record
    dSignature: Longint;
    nVersion:   Longint;
    cbData:     Longint;
    offData:    Longint;
  end;

const
  gdiComment_Identifier         = $43494447;
  gdiComment_Windows_Metafile   = $80000001;
  gdiComment_BeginGroup         = $00000002;
  gdiComment_EndGroup           = $00000003;
  gdiComment_MultiFormats       = $40000004;
  eps_Signature                 = $46535045;

type
  PEnhMetaRecord = ^TEnhMetaRecord;
  TEnhMetaRecord = packed record
    iType: Longint;
    nSize: Longint;
    dParm: array[0..0] of Longint;
  end;

  TFontEnumProc  = function(Font: PLogFont; TextMetric: PTextMetric; dwType: DWord; Data: lParam): Integer;
  TMFEnumProc    = function(DC: HDC; Table: PHandleTable; MR: PMetaRecord; P4: Longint; Data: lParam): Integer;
  TEnhMfEnumProc = function(DC: HDC; Table: PHandleTable; EMR: PEnhMetaRecord; P4: Longint; Data: lParam): Integer;

const
  rdh_Rectangles                = 1;

type
  PRgnDataHeader = ^TRgnDataHeader;
  TRgnDataHeader = packed record
    dwSize:   Longint;
    iType:    Longint;
    nCount:   Longint;
    nRgnSize: Longint;
    rcBound:  TRect;
  end;

  PRgnData = ^TRgnData;
  TRgnData = record
    rdh:    TRgnDataHeader;
    Buffer: array[0..0] of Char;
  end;

  PIconInfo = ^TIconInfo;
  TIconInfo = packed record
    fIcon:    Bool;
    xHotspot: Longint;
    yHotspot: Longint;
    hbmMask:  HBitmap;
    hbmColor: HBitmap;
  end;

{ Arc direction }
const
  ad_CounterClockwise           = 1;
  ad_Clockwise                  = 2;

{ Types for wType field in MMTIME struct }

  time_Ms                       = $0001;
  time_Samples                  = $0002;
  time_Bytes                    = $0004;
  time_Smpte                    = $0008;
  time_Midi                     = $0010;
  time_Ticks                    = $0020;

type
  PTimeZoneInformation = ^TTimeZoneInformation;
  TTimeZoneInformation = record
    Bias:         Longint;
    StandardName: array[0..31] of WChar;
    StandardDate: TSystemTime;
    StandardBias: Longint;
    DaylightName: array[0..31] of WChar;
    DaylightDate: TSystemTime;
    DaylightBias: Longint;
  end;

const
  time_Zone_Id_Unknown          = 0;
  time_Zone_Id_Standard         = 1;
  time_Zone_Id_Daylight         = 2;

  hInstance_Error               = 32;

{ LoadModule structure }
type
  PLoadParms32 = ^TLoadParms32;
  TLoadParms32 = record
    lpEnvAddress: PChar;
    lpCmdLine:    PChar;
    lpCmdShow:    PChar;
    dwReserved:   Longint;
  end;

{ DC Graphics Mode }
const
  gm_Compatible                 = 1;
  gm_Advanced                   = 2;

  dcx_Window                    = $00000001;
  dcx_Cache                     = $00000002;
  dcx_NoResetAttrs              = $00000004;
  dcx_ClipChildren              = $00000008;
  dcx_ClipSiblings              = $00000010;
  dcx_ParentClip                = $00000020;
  dcx_ExcludeRgn                = $00000040;
  dcx_IntersectRgn              = $00000080;
  dcx_ExcludeUpdate             = $00000100;
  dcx_IntersectUpdate           = $00000200;
  dcx_LockWindowUpdate          = $00000400;
  dcx_Validate                  = $00200000;

{ Defines for the fVirt field of the Accelerator table structure (ACCEL). }

  fVirtKey                      = $01;
  fNoInvert                     = $02;
  fShift                        = $04;
  fControl                      = $08;
  fAlt                          = $10;


{ Default codepage }

  cp_WinAnsi                    = 1004;

  sc_Size                       = $F000;
  sc_Move                       = $F010;
  sc_Minimize                   = $F020;
  sc_Maximize                   = $F030;
  sc_NextWindow                 = $F040;
  sc_PrevWindow                 = $F050;
  sc_Close                      = $F060;
  sc_VScroll                    = $F070;
  sc_HScroll                    = $F080;
  sc_MouseMenu                  = $F090;
  sc_KeyMenu                    = $F100;
  sc_Arrange                    = $F110;
  sc_Restore                    = $F120;
  sc_TaskList                   = $F130;
  sc_ScreenSave                 = $F140;
  sc_HotKey                     = $F150;
  sc_Icon                       = sc_Minimize;
  sc_Zoom                       = sc_Maximize;

  meta_SetBkColor               = $0201;
  meta_SetBkMode                = $0102;
  meta_SetMapMode               = $0103;
  meta_SetRop2                  = $0104;
  meta_SetRelAbs                = $0105;
  meta_SetPolyFillMode          = $0106;
  meta_SetStretchBltMode        = $0107;
  meta_SetTextCharExtra         = $0108;
  meta_SetTextColor             = $0209;
  meta_SetTextJustification     = $020A;
  meta_SetWindowOrg             = $020B;
  meta_SetWindowExt             = $020C;
  meta_SetViewportOrg           = $020D;
  meta_SetViewporText           = $020E;
  meta_OffsetWindowOrg          = $020F;
  meta_ScaleWindowExt           = $0410;
  meta_OffsetViewPortOrg        = $0211;
  meta_ScaleViewPortExt         = $0412;
  meta_LineTo                   = $0213;
  meta_MoveTo                   = $0214;
  meta_ExcludeClipRect          = $0415;
  meta_IntersectClipRect        = $0416;
  meta_Arc                      = $0817;
  meta_Ellipse                  = $0418;
  meta_FloodFill                = $0419;
  meta_Pie                      = $081A;
  meta_Rectangle                = $041B;
  meta_RoundRect                = $061C;
  meta_PatBlt                   = $061D;
  meta_SaveDC                   = $001E;
  meta_SetPixel                 = $041F;
  meta_OffsetClipRgn            = $0220;
  meta_TextOut                  = $0521;
  meta_BitBlt                   = $0922;
  meta_StretchBlt               = $0B23;
  meta_Polygon                  = $0324;
  meta_PolyLine                 = $0325;
  meta_Escape                   = $0626;
  meta_RestoreDC                = $0127;
  meta_FillRegion               = $0228;
  meta_FrameRegion              = $0429;
  meta_InvertRegion             = $012A;
  meta_PaintRegion              = $012B;
  meta_SelectClipRegion         = $012C;
  meta_SelectObject             = $012D;
  meta_SetTextAlign             = $012E;
  meta_Chord                    = $0830;
  meta_SetMapperFlags           = $0231;
  meta_ExtTextOut               = $0a32;
  meta_SetDibToDev              = $0d33;
  meta_SelectPalette            = $0234;
  meta_RealizePalette           = $0035;
  meta_AnimatePalette           = $0436;
  meta_SetPalEntries            = $0037;
  meta_PolyPolygon              = $0538;
  meta_ResizePalette            = $0139;
  meta_DibBitblt                = $0940;
  meta_DibStretchBlt            = $0b41;
  meta_DibCreatePatternBrush    = $0142;
  meta_StretchDib               = $0f43;
  meta_ExtFloodFill             = $0548;
  meta_DeleteObject             = $01f0;
  meta_CreatePalette            = $00f7;
  meta_CreatePatternBrush       = $01F9;
  meta_CreatePenIndirect        = $02FA;
  meta_CreateFontIndirect       = $02FB;
  meta_CreateBrushIndirect      = $02FC;
  meta_CreateRegion             = $06FF;

type
  PMinMaxInfo = ^TMinMaxInfo;
  TMinMaxInfo = packed record
    ptReserved:     TPoint;
    ptMaxSize:      TPoint;
    ptMaxPosition:  TPoint;
    ptMinTrackSize: TPoint;
    ptMaxTrackSize: TPoint;
  end;

const
  msgf_DialogBox                = 0;
  msgf_MessageBox               = 1;
  msgf_Menu                     = 2;
  msgf_Move                     = 3;
  msgf_Size                     = 4;
  msgf_ScrollBar                = 5;
  msgf_NextWindow               = 6;
  msgf_MainLoop                 = 8;
  msgf_Max                      = 8;
  msgf_User                     = 4096;

  help_Context                  = $0001;
  help_Quit                     = $0002;
  help_Index                    = $0003;
  help_Contents                 = $0003;
  help_HelpOnHelp               = $0004;
  help_SetIndex                 = $0005;
  help_SetContents              = $0005;
  help_ContextPopup             = $0008;
  help_ForceFile                = $0009;
  help_Key                      = $0101;
  help_Command                  = $0102;
  help_PartialKey               = $0105;
  help_MultiKey                 = $0201;
  help_SetWinPos                = $0203;

  mk_LButton                    = $0001;
  mk_RButton                    = $0002;
  mk_Shift                      = $0004;
  mk_Control                    = $0008;
  mk_MButton                    = $0010;

  st_BeginSwp                   = 0;
  st_EndSwp                     = 1;

  htError                       = -2;
  htTransparent                 = -1;
  htNoWhere                     = 0;
  htClient                      = 1;
  htCaption                     = 2;
  htSysMenu                     = 3;
  htGrowBox                     = 4;
  htSize                        = htGrowBox;
  htMenu                        = 5;
  htHScroll                     = 6;
  htVScroll                     = 7;
  htMinButton                   = 8;
  htMaxButton                   = 9;
  htLeft                        = 10;
  htRight                       = 11;
  htTop                         = 12;
  htTopLeft                     = 13;
  htTopRight                    = 14;
  htBottom                      = 15;
  htBottomLeft                  = 16;
  htBottomRight                 = 17;
  htBorder                      = 18;
  htReduce                      = htMinButton;
  htZoom                        = htMaxButton;
  htSizeFirst                   = htLeft;
  htSizeLast                    = htBottomRight;

  smto_Normal                   = $0000;
  smto_Block                    = $0001;
  smto_AbortIfHung              = $0002;

{ Hook Related structures ... }
type
  PCWPStruct = ^TCWPStruct;
  TCWPStruct = packed record
    lParam:  lParam;
    wParam:  wParam;
    message: Longint;
    hWnd:    hWnd;
  end;

  PDebugHookInfo = ^TDebugHookInfo;
  TDebugHookInfo = packed record
    idThread: Longint;
    reserved: lParam;
    lParam:   lParam;
    wParam:   wParam;
    code:     Longint;
  end;

  PEventMsg = ^TEventMsg;
  TEventMsg = packed record
    message: Longint;
    paramL:  Longint;
    paramH:  Longint;
    time:    Longint;
    hWnd:    hWnd;
  end;

  PMouseHookStruct = ^TMouseHookStruct;
  TMouseHookStruct = packed record
    pt:           TPoint;
    hWnd:         hWnd;
    wHitTestCode: Longint;
    dwExtraInfo:  Longint;
  end;

  TWOHandleArray = array[0..maximum_Wait_Objects-1] of THandle;
  PWOHandleArray = ^TWOHandleArray;

{----- WinSpool -----}

const
  PRINTER_ENUM_DEFAULT     = $00000001;
  PRINTER_ENUM_LOCAL       = $00000002;
  PRINTER_ENUM_CONNECTIONS = $00000004;
  PRINTER_ENUM_FAVORITE    = $00000004;
  PRINTER_ENUM_NAME        = $00000008;
  PRINTER_ENUM_REMOTE      = $00000010;
  PRINTER_ENUM_SHARED      = $00000020;
  PRINTER_ENUM_NETWORK     = $00000040;

  PRINTER_ENUM_EXPAND      = $00004000;
  PRINTER_ENUM_CONTAINER   = $00008000;

  PRINTER_ENUM_ICONMASK    = $00ff0000;
  PRINTER_ENUM_ICON1       = $00010000;
  PRINTER_ENUM_ICON2       = $00020000;
  PRINTER_ENUM_ICON3       = $00040000;
  PRINTER_ENUM_ICON4       = $00080000;
  PRINTER_ENUM_ICON5       = $00100000;
  PRINTER_ENUM_ICON6       = $00200000;
  PRINTER_ENUM_ICON7       = $00400000;
  PRINTER_ENUM_ICON8       = $00800000;

type
  PPrinterDefaults = ^TPrinterDefaults;
  TPrinterDefaults = record
    pDatatype: PChar;
    pDevMode: PDeviceMode;
    DesiredAccess: Access_Mask;
  end;
  PPrinterInfo4 = ^TPrinterInfo4;
  TPrinterInfo4 = record
    pPrinterName: PChar;
    pServerName: PChar;
    Attributes: Dword;
  end;
  PPrinterInfo5 = ^TPrinterInfo5;
  TPrinterInfo5 = record
    pPrinterName: PChar;
    pPortName: PChar;
    Attributes: Dword;
    DeviceNotSelectedTimeout: Dword;
    TransmissionRetryTimeout: DWord;
  end;

{---------------[ Error codes ]----------------------------------------------}
const
  facility_Null                 = 0;
  facility_Rpc                  = 1;
  facility_Dispatch             = 2;
  facility_Storage              = 3;
  facility_Itf                  = 4;
  facility_Win32                = 7;
  facility_Windows              = 8;
  facility_Control              = 10;

  no_Error                      = 0;
  error_Success                 = 0;
  error_Invalid_Function        = 1;
  error_File_Not_Found          = 2;
  error_Path_Not_Found          = 3;
  error_Too_Many_Open_Files     = 4;
  error_Access_Denied           = 5;
  error_Invalid_Handle          = 6;
  error_Arena_Trashed           = 7;
  error_Not_Enough_Memory       = 8;
  error_Invalid_Block           = 9;
  error_Bad_Environment         = 10;
  error_Bad_Format              = 11;
  error_Invalid_Access          = 12;
  error_Invalid_Data            = 13;
  error_OutOfMemory             = 14;
  error_Invalid_Drive           = 15;
  error_Current_Directory       = 16;
  error_Not_Same_Device         = 17;
  error_No_More_Files           = 18;
  error_Write_Protect           = 19;
  error_Bad_Unit                = 20;
  error_Not_Ready               = 21;
  error_Bad_Command             = 22;
  error_Crc                     = 23;
  error_Bad_Length              = 24;
  error_Seek                    = 25;
  error_Not_Dos_Disk            = 26;
  error_Sector_Not_Found        = 27;
  error_Out_Of_Paper            = 28;
  error_Write_Fault             = 29;
  error_Read_Fault              = 30;
  error_Gen_Failure             = 31;
  error_Sharing_Violation       = 32;
  error_Lock_Violation          = 33;
  error_Wrong_Disk              = 34;
  error_Sharing_Buffer_Exceeded = 36;
  error_Handle_Eof              = 38;
  error_Handle_Disk_Full        = 39;
  error_Not_Supported           = 50;
  error_Rem_Not_List            = 51;
  error_Dup_Name                = 52;
  error_Bad_NetPath             = 53;
  error_Network_Busy            = 54;
  error_Dev_Not_Exist           = 55;
  error_Too_Many_Cmds           = 56;
  error_Adap_Hdw_Err            = 57;
  error_Bad_Net_Resp            = 58;
  error_Unexp_Net_Err           = 59;
  error_Bad_Rem_Adap            = 60;
  error_Printq_Full             = 61;
  error_No_Spool_Space          = 62;
  error_Print_Cancelled         = 63;
  error_Netname_Deleted         = 64;
  error_Network_Access_Denied   = 65;
  error_Bad_Dev_Type            = 66;
  error_Bad_Net_Name            = 67;
  error_Too_Many_Names          = 68;
  error_Too_Many_Sess           = 69;
  error_Sharing_Paused          = 70;
  error_Req_Not_Accep           = 71;
  error_Redir_Paused            = 72;
  error_File_Exists             = 80;
  error_Cannot_Make             = 82;
  error_Fail_I24                = 83;
  error_Out_Of_Structures       = 84;
  error_Already_Assigned        = 85;
  error_Invalid_Password        = 86;
  error_Invalid_Parameter       = 87;
  error_Net_Write_Fault         = 88;
  error_No_Proc_Slots           = 89;
  error_Too_Many_Semaphores     = 100;
  error_Excl_Sem_Already_Owned  = 101;
  error_Sem_Is_Set              = 102;
  error_Too_Many_Sem_Requests   = 103;
  error_Invalid_At_Interrupt_Time=104;
  error_Sem_Owner_Died          = 105;
  error_Sem_User_Limit          = 106;
  error_Disk_Change             = 107;
  error_Drive_Locked            = 108;
  error_Broken_Pipe             = 109;
  error_Open_Failed             = 110;
  error_Buffer_Overflow         = 111;
  error_Disk_Full               = 112;
  error_No_More_Search_Handles  = 113;
  error_Invalid_Target_Handle   = 114;
  error_Invalid_Category        = 117;
  error_Invalid_Verify_Switch   = 118;
  error_Bad_Driver_Level        = 119;
  error_Call_Not_Implemented    = 120;
  error_Sem_Timeout             = 121;
  error_Insufficient_Buffer     = 122;
  error_Invalid_Name            = 123;
  error_Invalid_Level           = 124;
  error_No_Volume_Label         = 125;
  error_Mod_Not_Found           = 126;
  error_Proc_Not_Found          = 127;
  error_Wait_No_Children        = 128;
  error_Child_Not_Complete      = 129;
  error_Direct_Access_Handle    = 130;
  error_Negative_Seek           = 131;
  error_Seek_On_Device          = 132;
  error_Is_Join_Target          = 133;
  error_Is_Joined               = 134;
  error_Is_Substed              = 135;
  error_Not_Joined              = 136;
  error_Not_Substed             = 137;
  error_Join_To_Join            = 138;
  error_Subst_To_Subst          = 139;
  error_Join_To_Subst           = 140;
  error_Subst_To_Join           = 141;
  error_Busy_Drive              = 142;
  error_Same_Drive              = 143;
  error_Dir_Not_Root            = 144;
  error_Dir_Not_Empty           = 145;
  error_Is_Subst_Path           = 146;
  error_Is_Join_Path            = 147;
  error_Path_Busy               = 148;
  error_Is_Subst_Target         = 149;
  error_System_Trace            = 150;
  error_Invalid_Event_Count     = 151;
  error_Too_Many_Muxwaiters     = 152;
  error_Invalid_List_Format     = 153;
  error_Label_Too_Long          = 154;
  error_Too_Many_Tcbs           = 155;
  error_Signal_Refused          = 156;
  error_Discarded               = 157;
  error_Not_Locked              = 158;
  error_Bad_ThreadId_Addr       = 159;
  error_Bad_Arguments           = 160;
  error_Bad_Pathname            = 161;
  error_Signal_Pending          = 162;
  error_Max_Thrds_Reached       = 164;
  error_Lock_Failed             = 167;
  error_Busy                    = 170;
  error_Cancel_Violation        = 173;
  error_Atomic_Locks_Not_Supported=174;
  error_Invalid_Segment_Number  = 180;
  error_Invalid_Ordinal         = 182;
  error_Already_Exists          = 183;
  error_Invalid_Flag_Number     = 186;
  error_Sem_Not_Found           = 187;
  error_Invalid_Starting_Codeseg= 188;
  error_Invalid_Stackseg        = 189;
  error_Invalid_Moduletype      = 190;
  error_Invalid_Exe_Signature   = 191;
  error_Exe_Marked_Invalid      = 192;
  error_Bad_Exe_Format          = 193;
  error_Iterated_Data_Exceeds_64k=194;
  error_Invalid_MinAllocSize    = 195;
  error_Dynlink_From_Invalid_Ring=196;
  error_Iopl_Not_Enabled        = 197;
  error_Invalid_Segdpl          = 198;
  error_AutoDataSeg_Exceeds_64k = 199;
  error_Ring2seg_Must_Be_Movable= 200;
  error_Reloc_Chain_Xeeds_Seglim= 201;
  error_Infloop_In_Reloc_Chain  = 202;
  error_Envvar_Not_Found        = 203;
  error_No_Signal_Sent          = 205;
  error_Filename_Exced_Range    = 206;
  error_Ring2_Stack_In_Use      = 207;
  error_Meta_Expansion_Too_Long = 208;
  error_Invalid_Signal_Number   = 209;
  error_Thread_1_inactive       = 210;
  error_Locked                  = 212;
  error_Too_Many_Modules        = 214;
  error_Nesting_Not_Allowed     = 215;
  error_Bad_Pipe                = 230;
  error_Pipe_Busy               = 231;
  error_No_Data                 = 232;
  error_Pipe_Not_Connected      = 233;
  error_More_Data               = 234;
  error_Vc_Disconnected         = 240;
  error_Invalid_Ea_Name         = 254;
  error_Ea_List_Inconsistent    = 255;
  error_No_More_Items           = 259;
  error_Cannot_Copy             = 266;
  error_Directory               = 267;
  error_Eas_Didnt_Fit           = 275;
  error_Ea_File_Corrupt         = 276;
  error_Ea_Table_Full           = 277;
  error_Invalid_Ea_Handle       = 278;
  error_Eas_Not_Supported       = 282;
  error_Not_Owner               = 288;
  error_Too_Many_Posts          = 298;
  error_Partial_Copy            = 299;
  error_Mr_Mid_Not_Found        = 317;
  error_Invalid_Address         = 487;
  error_Arithmetic_Overflow     = 534;
  error_Pipe_Connected          = 535;
  error_Pipe_Listening          = 536;
  error_Ea_Access_Denied        = 994;
  error_Operation_Aborted       = 995;
  error_Io_Incomplete           = 996;
  error_Io_Pending              = 997;
  error_Noaccess                = 998;
  error_Swaperror               = 999;
  error_Stack_Overflow          = 1001;
  error_Invalid_Message         = 1002;
  error_Can_Not_Complete        = 1003;
  error_Invalid_Flags           = 1004;
  error_Unrecognized_Volume     = 1005;
  error_File_Invalid            = 1006;
  error_Fullscreen_Mode         = 1007;
  error_No_Token                = 1008;
  error_Baddb                   = 1009;
  error_Badkey                  = 1010;
  error_Cantopen                = 1011;
  error_Cantread                = 1012;
  error_Cantwrite               = 1013;
  error_Registry_Recovered      = 1014;
  error_Registry_Corrupt        = 1015;
  error_Registry_Io_Failed      = 1016;
  error_Not_Registry_File       = 1017;
  error_Key_Deleted             = 1018;
  error_No_Log_Space            = 1019;
  error_Key_Has_Children        = 1020;
  error_Child_Must_Be_Volatile  = 1021;
  error_Notify_Enum_Dir         = 1022;
  error_Dependent_Services_Running=1051;
  error_Invalid_Service_Control = 1052;
  error_Service_Request_Timeout = 1053;
  error_Service_No_Thread       = 1054;
  error_Service_Database_Locked = 1055;
  error_Service_Already_Running = 1056;
  error_Invalid_Service_Account = 1057;
  error_Service_Disabled        = 1058;
  error_Circular_Dependency     = 1059;
  error_Service_Does_Not_Exist  = 1060;
  error_Service_Cannot_Accept_Ctrl=1061;
  error_Service_Not_Active      = 1062;
  error_Failed_Service_Controller_Connect=1063;
  error_Exception_In_Service    = 1064;
  error_Database_Does_Not_Exist = 1065;
  error_Service_Specific_Error  = 1066;
  error_Process_Aborted         = 1067;
  error_Service_Dependency_Fail = 1068;
  error_Service_Logon_Failed    = 1069;
  error_Service_Start_Hang      = 1070;
  error_Invalid_Service_Lock    = 1071;
  error_Service_Marked_For_Delete=1072;
  error_Service_Exists          = 1073;
  error_Already_Running_Lkg     = 1074;
  error_Service_Dependency_Deleted=1075;
  error_Boot_Already_Accepted   = 1076;
  error_Service_Never_Started   = 1077;
  error_Duplicate_Service_Name  = 1078;
  error_End_Of_Media            = 1100;
  error_Filemark_Detected       = 1101;
  error_Beginning_Of_Media      = 1102;
  error_Setmark_Detected        = 1103;
  error_No_Data_Detected        = 1104;
  error_Partition_Failure       = 1105;
  error_Invalid_Block_Length    = 1106;
  error_Device_Not_Partitioned  = 1107;
  error_Unable_To_Lock_Media    = 1108;
  error_Unable_To_Unload_Media  = 1109;
  error_Media_Changed           = 1110;
  error_Bus_Reset               = 1111;
  error_No_Media_In_Drive       = 1112;
  error_No_Unicode_Translation  = 1113;
  error_Dll_Init_Failed         = 1114;
  error_Shutdown_In_Progress    = 1115;
  error_No_Shutdown_In_Progress = 1116;
  error_Io_Device               = 1117;
  error_Serial_No_Device        = 1118;
  error_Irq_Busy                = 1119;
  error_More_Writes             = 1120;
  error_Counter_Timeout         = 1121;
  error_Floppy_Id_Mark_Not_Found= 1122;
  error_Floppy_Wrong_Cylinder   = 1123;
  error_Floppy_Unknown_Error    = 1124;
  error_Floppy_Bad_Registers    = 1125;
  error_Disk_Recalibrate_Failed = 1126;
  error_Disk_Operation_Failed   = 1127;
  error_Disk_Reset_Failed       = 1128;
  error_Eom_Overflow            = 1129;
  error_Not_Enough_Server_Memory= 1130;
  error_Possible_Deadlock       = 1131;
  error_Mapped_Alignment        = 1132;
  error_Bad_Username            = 2202;
  error_Not_Connected           = 2250;
  error_Open_Files              = 2401;
  error_Active_Connections      = 2402;
  error_Device_In_Use           = 2404;
  error_Bad_Device              = 1200;
  error_Connection_Unavail      = 1201;
  error_Device_Already_Remembered=1202;
  error_No_Net_Or_Bad_Path      = 1203;
  error_Bad_Provider            = 1204;
  error_Cannot_Open_Profile     = 1205;
  error_Bad_Profile             = 1206;
  error_Not_Container           = 1207;
  error_Extended_Error          = 1208;
  error_Invalid_Groupname       = 1209;
  error_Invalid_Computername    = 1210;
  error_Invalid_Eventname       = 1211;
  error_Invalid_Domainname      = 1212;
  error_Invalid_Servicename     = 1213;
  error_Invalid_Netname         = 1214;
  error_Invalid_Sharename       = 1215;
  error_Invalid_Passwordname    = 1216;
  error_Invalid_Messagename     = 1217;
  error_Invalid_Messagedest     = 1218;
  error_Session_Credential_Conflict= 1219;
  error_Remote_Session_Limit_Exceeded=1220;
  error_Dup_Domainname          = 1221;
  error_No_Network              = 1222;
  error_Cancelled               = 1223;
  error_User_Mapped_File        = 1224;
  error_Connection_Refused      = 1225;
  error_Graceful_Disconnect     = 1226;
  error_Address_Already_Associated=1227;
  error_Address_Not_Associated  = 1228;
  error_Connection_Invalid      = 1229;
  error_Connection_Active       = 1230;
  error_Network_Unreachable     = 1231;
  error_Host_Unreachable        = 1232;
  error_Protocol_Unreachable    = 1233;
  error_Port_Unreachable        = 1234;
  error_Request_Aborted         = 1235;
  error_Connection_Aborted      = 1236;
  error_Retry                   = 1237;
  error_Connection_Count_Limit  = 1238;
  error_Login_Time_Restriction  = 1239;
  error_Login_Wksta_Restriction = 1240;
  error_Incorrect_Address       = 1241;
  error_Already_Registered      = 1242;
  error_Service_Not_Found       = 1243;
  error_Not_All_Assigned        = 1300;
  error_Some_Not_Mapped         = 1301;
  error_No_Quotas_For_Account   = 1302;
  error_Local_User_Session_Key  = 1303;
  error_Null_Lm_Password        = 1304;
  error_Unknown_Revision        = 1305;
  error_Revision_Mismatch       = 1306;
  error_Invalid_Owner           = 1307;
  error_Invalid_Primary_Group   = 1308;
  error_No_Impersonation_Token  = 1309;
  error_Cant_Disable_Mandatory  = 1310;
  error_No_Logon_Servers        = 1311;
  error_No_Such_Logon_Session   = 1312;
  error_No_Such_Privilege       = 1313;
  error_Privilege_Not_Held      = 1314;
  error_Invalid_Account_Name    = 1315;
  error_User_Exists             = 1316;
  error_No_Such_User            = 1317;
  error_Group_Exists            = 1318;
  error_No_Such_Group           = 1319;
  error_Member_In_Group         = 1320;
  error_Member_Not_In_Group     = 1321;
  error_Last_Admin              = 1322;
  error_Wrong_Password          = 1323;
  error_Ill_Formed_Password     = 1324;
  error_Password_Restriction    = 1325;
  error_Logon_Failure           = 1326;
  error_Account_Restriction     = 1327;
  error_Invalid_Logon_Hours     = 1328;
  error_Invalid_Workstation     = 1329;
  error_Password_Expired        = 1330;
  error_Account_Disabled        = 1331;
  error_None_Mapped             = 1332;
  error_Too_Many_Luids_Requested= 1333;
  error_Luids_Exhausted         = 1334;
  error_Invalid_Sub_Authority   = 1335;
  error_Invalid_Acl             = 1336;
  error_Invalid_Sid             = 1337;
  error_Invalid_Security_Descr  = 1338;
  error_Bad_Inheritance_Acl     = 1340;
  error_Server_Disabled         = 1341;
  error_Server_Not_Disabled     = 1342;
  error_Invalid_Id_Authority    = 1343;
  error_Allotted_Space_Exceeded = 1344;
  error_Invalid_Group_Attributes= 1345;
  error_Bad_Impersonation_Level = 1346;
  error_Cant_Open_Anonymous     = 1347;
  error_Bad_Validation_Class    = 1348;
  error_Bad_Token_Type          = 1349;
  error_No_Security_On_Object   = 1350;
  error_Cant_Access_Domain_Info = 1351;
  error_Invalid_Server_State    = 1352;
  error_Invalid_Domain_State    = 1353;
  error_Invalid_Domain_Role     = 1354;
  error_No_Such_Domain          = 1355;
  error_Domain_Exists           = 1356;
  error_Domain_Limit_Exceeded   = 1357;
  error_Internal_Db_Corruption  = 1358;
  error_Internal_Error          = 1359;
  error_Generic_Not_Mapped      = 1360;
  error_Bad_Descriptor_Format   = 1361;
  error_Not_Logon_Process       = 1362;
  error_Logon_Session_Exists    = 1363;
  error_No_Such_Package         = 1364;
  error_Bad_Logon_Session_State = 1365;
  error_Logon_Session_Collision = 1366;
  error_Invalid_Logon_Type      = 1367;
  error_Cannot_Impersonate      = 1368;
  error_Rxact_Invalid_State     = 1369;
  error_Rxact_Commit_Failure    = 1370;
  error_Special_Account         = 1371;
  error_Special_Group           = 1372;
  error_Special_User            = 1373;
  error_Members_Primary_Group   = 1374;
  error_Token_Already_In_Use    = 1375;
  error_No_Such_Alias           = 1376;
  error_Member_Not_In_Alias     = 1377;
  error_Member_In_Alias         = 1378;
  error_Alias_Exists            = 1379;
  error_Logon_Not_Granted       = 1380;
  error_Too_Many_Secrets        = 1381;
  error_Secret_Too_Long         = 1382;
  error_Internal_Db_Error       = 1383;
  error_Too_Many_Context_Ids    = 1384;
  error_Logon_Type_Not_Granted  = 1385;
  error_Nt_Cross_Encryption_Required= 1386;
  error_No_Such_Member          = 1387;
  error_Invalid_Member          = 1388;
  error_Too_Many_Sids           = 1389;
  error_Lm_Cross_Encryption_Required= 1390;
  error_No_Inheritance          = 1391;
  error_File_Corrupt            = 1392;
  error_Disk_Corrupt            = 1393;
  error_No_User_Session_Key     = 1394;
  error_Invalid_Window_Handle   = 1400;
  error_Invalid_Menu_Handle     = 1401;
  error_Invalid_Cursor_Handle   = 1402;
  error_Invalid_Accel_Handle    = 1403;
  error_Invalid_Hook_Handle     = 1404;
  error_Invalid_Dwp_Handle      = 1405;
  error_Tlw_With_Wschild        = 1406;
  error_Cannot_Find_Wnd_Class   = 1407;
  error_Window_Of_Other_Thread  = 1408;
  error_Hotkey_Already_Registered=1409;
  error_Class_Already_Exists    = 1410;
  error_Class_Does_Not_Exist    = 1411;
  error_Class_Has_Windows       = 1412;
  error_Invalid_Index           = 1413;
  error_Invalid_Icon_Handle     = 1414;
  error_Private_Dialog_Index    = 1415;
  error_Listbox_Id_Not_Found    = 1416;
  error_No_Wildcard_Characters  = 1417;
  error_Clipboard_Not_Open      = 1418;
  error_Hotkey_Not_Registered   = 1419;
  error_Window_Not_Dialog       = 1420;
  error_Control_Id_Not_Found    = 1421;
  error_Invalid_Combobox_Message= 1422;
  error_Window_Not_Combobox     = 1423;
  error_Invalid_Edit_Height     = 1424;
  error_Dc_Not_Found            = 1425;
  error_Invalid_Hook_Filter     = 1426;
  error_Invalid_Filter_Proc     = 1427;
  error_Hook_Needs_Hmod         = 1428;
  error_Global_Only_Hook        = 1429;
  error_Journal_Hook_Set        = 1430;
  error_Hook_Not_Installed      = 1431;
  error_Invalid_Lb_Message      = 1432;
  error_Setcount_On_Bad_Lb      = 1433;
  error_Lb_Without_Tabstops     = 1434;
  error_Destroy_Object_Of_Other_Thread=1435;
  error_Child_Window_Menu       = 1436;
  error_No_System_Menu          = 1437;
  error_Invalid_Msgbox_Style    = 1438;
  error_Invalid_Spi_Value       = 1439;
  error_Screen_Already_Locked   = 1440;
  error_Hwnds_Have_Diff_Parent  = 1441;
  error_Not_Child_Window        = 1442;
  error_Invalid_Gw_Command      = 1443;
  error_Invalid_Thread_Id       = 1444;
  error_Non_Mdichild_Window     = 1445;
  error_Popup_Already_Active    = 1446;
  error_No_Scrollbars           = 1447;
  error_Invalid_Scrollbar_Range = 1448;
  error_Invalid_Showwin_Command = 1449;
  error_Eventlog_File_Corrupt   = 1500;
  error_Eventlog_Cant_Start     = 1501;
  error_Log_File_Full           = 1502;
  error_Eventlog_File_Changed   = 1503;

  error_Invalid_User_Buffer     = 1784;
  error_Unrecognized_Media      = 1785;
  error_No_Trust_Lsa_Secret     = 1786;
  error_No_Trust_Sam_Account    = 1787;
  error_Trusted_Domain_Failure  = 1788;
  error_Trusted_Relationship_Failure=1789;
  error_Trust_Failure           = 1790;

  error_Netlogon_Not_Started    = 1792;
  error_Account_Expired         = 1793;
  error_Redirector_Has_Open_Handles=1794;
  error_Printer_Driver_Already_Installed=1795;
  error_Unknown_Port            = 1796;
  error_Unknown_Printer_Driver  = 1797;
  error_Unknown_Printprocessor  = 1798;
  error_Invalid_Separator_File  = 1799;
  error_Invalid_Priority        = 1800;
  error_Invalid_Printer_Name    = 1801;
  error_Printer_Already_Exists  = 1802;
  error_Invalid_Printer_Command = 1803;
  error_Invalid_Datatype        = 1804;
  error_Invalid_Environment     = 1805;

  error_Nologon_Interdomain_Trust_Account=1807;
  error_Nologon_Workstation_Trust_Account=1808;
  error_Nologon_Server_Trust_Account=1809;
  error_Domain_Trust_Inconsistent=1810;
  error_Server_Has_Open_Handles = 1811;
  error_Resource_Data_Not_Found = 1812;
  error_Resource_Type_Not_Found = 1813;
  error_Resource_Name_Not_Found = 1814;
  error_Resource_Lang_Not_Found = 1815;
  error_Not_Enough_Quota        = 1816;
  error_Invalid_Time            = 1901;
  error_Invalid_Form_Name       = 1902;
  error_Invalid_Form_Size       = 1903;
  error_Already_Waiting         = 1904;
  error_Printer_Deleted         = 1905;
  error_Invalid_Printer_State   = 1906;
  error_Password_Must_Change    = 1907;
  error_Domain_Controller_Not_Found=1908;
  error_Account_Locked_Out      = 1909;
  error_Invalid_Pixel_Format    = 2000;
  error_Bad_Driver              = 2001;
  error_Invalid_Window_Style    = 2002;
  error_Metafile_Not_Supported  = 2003;
  error_Transform_Not_Supported = 2004;
  error_Clipping_Not_Supported  = 2005;
  error_Unknown_Print_Monitor   = 3000;
  error_Printer_Driver_In_Use   = 3001;
  error_Spool_File_Not_Found    = 3002;
  error_Spl_No_StartDoc         = 3003;
  error_Spl_No_AddJob           = 3004;
  error_Print_Processor_Already_Installed=3005;
  error_Print_Monitor_Already_Installed=3006;
  error_Wins_Internal           = 4000;
  error_Can_Not_Del_Local_Wins  = 4001;
  error_Static_Init             = 4002;
  error_Inc_Backup              = 4003;
  error_Full_Backup             = 4004;
  error_Rec_Non_Existent        = 4005;
  error_Rpl_Not_Allowed         = 4006;

{---------------[ API Prototypes ]-------------------------------------------}

function AnsiToOem(Src,Dest: PChar): Bool;
function OemToAnsi(Src,Dest: PChar): Bool;
function AnsiToOemBuff(Src,Dest: PChar; DestLen: DWord): Bool;
function OemToAnsiBuff(Src,Dest: PChar; DestLen: DWord): Bool;
function AnsiUpper(Str: PChar): PChar;
function AnsiUpperBuff(Str: PChar; StrLen: DWord): DWord;
function AnsiLower(Str: PChar): PChar;
function AnsiLowerBuff(Str: PChar; StrLen: DWord): DWord;
function AnsiNext(Str: PChar): PChar;
function AnsiPrev(Start,Current: PChar): PChar;

function WinMain(hInst,HPrevInst: hInst; CmdLine: PChar; CmdShow: UInt): UInt;
function AbortDoc(DC: HDC): Integer;
function AbortPath(DC: HDC): Bool;
function AddAtom(Str: PChar): TAtom;
function AddFontResource(FileName: PChar): Integer;
function AdjustWindowRect(var Rect: TRect; Style: DWord; Menu: Bool): Bool;
function AdjustWindowRectEx(var Rect: TRect; Style: DWord; Menu: Bool; ExStyle: DWord): Bool;
function AngleArc(DC: HDC; X,Y: Integer; Radius: DWord; StartAngle,SweepAngle: Single): Bool;
function AnimatePalette(Pal: HPalette; StartEntry,cEntries: UInt; ppe: PPaletteEntry): Bool;
function AppendMenu(Menu: hMenu; Flags,IDNewItems: UInt; NewItem: PChar): Bool;
function Arc(DC: HDC; Left,Top,Right,Bottom,StartX,StartY,EndX,EndY: Integer): Bool;
function ArcTo(DC: HDC; RLeft,RTop,RRight,RBottom,xRad1,yRad1,xRad2,yRad2: Integer): Bool;
function ArrangeIconicWindows(Wnd: hWnd): UInt;
function Beep(Freq,Durat: UInt): Bool;
function BeginDeferWindowPos(NumWindows: Integer): HDWP;
function BeginPaint(Wnd: hWnd; var Paint: TPaintStruct): HDC;
function BeginPath(DC: HDC): Bool;
function BitBlt(DestDC: HDC; X,Y,Width,Height: Integer; SrcDC: HDC; XSrc,YSrc: Integer; Rop: DWord): Bool;
function BringWindowToTop(Wnd: hWnd): Bool;
function CallMsgFilter(var Msg: TMsg; Code: Integer): Bool;
function CallNextHookEx(Hook: HHook; Code: Integer; WP: wParam; LP: lParam): lResult;
function CallWindowProc(PrevWndFunc: TFNWndProc; Wnd: hWnd; Msg: UInt; WP: wParam; LP: lParam): lResult;
function ChangeClipboardChain(WndRemove,WndNewNext: hWnd): Bool;
function CharLower(Str: PChar): PChar;
function CharLowerBuff(Str: PChar; StrLen: DWord): DWord;
function CharUpper(Str: PChar): PChar;
function CharUpperBuff(Str: PChar; StrLen: DWord): DWord;
function CheckDlgButton(Dlg: hWnd; IDButton: Integer; Check: UInt): Bool;
function CheckMenuItem(Menu: hMenu; IDCheckItem,Check: UInt): DWord;
function CheckRadioButton(Wnd: hWnd; IDFirstButton,IDLastButton,IDCheckButton: Integer): Bool;
function ChildWindowFromPoint(WndParent: hWnd; Point: TPoint): hWnd;
function Chord(DC: HDC; X1,Y1,X2,Y2,xRadial1,yRadial1,xRadial2,yRadial2: Integer): Bool;
function ClientToScreen(Wnd: hWnd; var Point: TPoint): Bool;
function ClipCursor(Rect: PRect): Bool;
function CloseClipboard: Bool;
function CloseEnhMetaFile(DC: HDC): HEnhMetafile;
function CloseFigure(DC: HDC): Bool;
function CloseHandle(Handle: THandle): Bool;
function CloseMetaFile(DC: HDC): HMetafile;
function ClosePrinter(hPrinter: THandle): Boolean;
function CloseWindow(Wnd: hWnd): Bool;
function CombineRgn(Dest,Src1,Src2: HRgn; CombineMode: Integer): Integer;
function CompareFileTime(const FileTime1,FileTime2: TFileTime): Longint;
function CopyCursor(Cursor: HCursor): HCursor;
function CopyEnhMetaFile(Src: HEnhMetafile; FileName: PChar): HEnhMetafile;
function CopyFile(ExistingFileName,NewFileName: PChar; FailIfExists: Bool): Bool;
function CopyIcon(Icon: HIcon): HIcon;
function CopyMetaFile(MetaFile: HMetafile; FileName: PChar): HMetafile;
function CopyRect(var Dest: TRect; const Src: TRect): Bool;
function CountClipboardFormats: Integer;
function CreateAcceleratorTable(var Accel; Count: Integer): HAccel;
function CreateBitmap(Width,Height: Integer; Planes,BitCount: Longint; Bits: Pointer): HBitmap;
function CreateBitmapIndirect(const Bitmap: TBitMap): HBitmap;
function CreateBrushIndirect(const Brush: TLogBrush): HBrush;
function CreateCaret(Wnd: hWnd; Bitmap: HBitmap; Width,Height: Integer): Bool;
function CreateCompatibleBitmap(DC: HDC; Width,Height: Integer): HBitmap;
function CreateCompatibleDC(DC: HDC): HDC;
function CreateCursor(Inst: hInst; XHotSpot,YHotSpot,Width,Height: Integer; ANDPlane,XORPlane: Pointer): HCursor;
function CreateDC(Driver,Device,Output: PChar; Init: PDeviceMode): HDC;
function CreateDIBPatternBrushPt(const PackedDIB: Pointer; Usage: UInt): HBrush;
function CreateDIBitmap(DC: HDC; var InfoHeader: TBitmapInfoHeader; Usage: DWord; InitBits: PChar; var InitInfo: TBitmapInfo; wUsage: UInt): HBitmap;
function CreateDialog(Instance: hInst; TemplateName: PChar; WndParent: hWnd; DialogFunc: TFNDlgProc): hWnd;
function CreateDialogParam(Instance: hInst; TemplateName: PChar; WndParent: hWnd; DialogFunc: TFNDlgProc; Param: lParam): hWnd;
function CreateDialogIndirect(Instance: hInst; const Template: TDlgTemplate; WndParent: hWnd; DialogFunc: TFNDlgProc): hWnd;
function CreateDialogIndirectParam(Instance: hInst; const Template: TDlgTemplate; WndParent: hWnd; DialogFunc: TFNDlgProc; Param: lParam): hWnd;
function CreateDirectory(PathName: PChar; SecurityAttributes: PSecurityAttributes): Bool;
function CreateEllipticRgn(X1,Y1,X2,Y2: Integer): HRgn;
function CreateEllipticRgnIndirect(const Rect: TRect): HRgn;
function CreateEnhMetaFile(DC: HDC; FileName: PChar; Rect: PRect; Description: PChar): HEnhMetafile;
function CreateEvent(EventAttributes: PSecurityAttributes; ManualReset,InitialState: Bool; Name: PChar): THandle;
function CreateFile(FileName: PChar; DesiredAccess,ShareMode: Integer; SecurityAttributes: PSecurityAttributes; CreationDisposition,FlagsAndAttributes: DWord; TemplateFile: THandle): THandle;
function CreateFont(Height,Width,Escapement,Orientaion,Weight: Integer; Italic,Underline,StrikeOut,CharSet,OutputPrecision,ClipPrecision,Quality,PitchAndFamily: DWord; FaceName: PChar): HFont;
function CreateFontIndirect(const Font: TLogFont): HFont;
function CreateHalftonePalette(dc: Hdc): hPalette;
function CreateHatchBrush(Style: Longint; Color: TColorRef): HBrush;
function CreateIC(Driver,Device,Output: PChar; Init: PDeviceMode): HDC;
function CreateIcon(Instance: hInst; Width,Height: Integer; Planes,BitsPixel: Byte; ANDbits,XORBits: Pointer): HIcon;
function CreateIconFromResource(PresBits: PByte; ResSize: DWord; Icon: Bool; Ver: DWord): HIcon;
function CreateIconIndirect(var IconInfo: TIconInfo): HIcon;
function CreateMenu: hMenu;
function CreateMetaFile(Name: PChar): HDC;
function CreateMDIWindow(ClassName,WindowName: PChar; Style: DWord; X,Y,Width,Height: Integer; WndParent: hWnd; Instance: hInst; Param: lParam): hWnd;
function CreateMutex(MutexAttributes: PSecurityAttributes; InitialOwner: Bool; Name: PChar): THandle;
function CreatePalette(const Pal: TLogPalette): HPalette;
function CreatePatternBrush(Bitmap: HBitmap): HBrush;
function CreatePen(Style,Width: Integer; Color: TColorRef): HPen;
function CreatePenIndirect(const Pen: TLogPen): HPen;
function CreatePolyPolygonRgn(const PtStructs,pIntArray; Count,PolyFillMode: Integer): HRgn;
function CreatePolygonRgn(const Points; Count,FillMode: Integer): HRgn;
function CreatePopupMenu: hMenu;
function CreateProcess(AppName,CmdLine: PChar; ProcessAttrs,ThreadAttrs: PSecurityAttributes; InheritHandles: Bool; CreationFlags: DWord; Env: Pointer; CurDir: PChar; const SI: TStartupInfo; var PI: TProcessInformation): Bool;
function CreateRectRgn(X1,Y1,X2,Y2: Integer): HRgn;
function CreateRectRgnIndirect(const Rect: TRect): HRgn;
function CreateRoundRectRgn(X1,Y1,X2,Y2,Width,Height: Integer): HRgn;
function CreateSemaphore(SemAttr: PSecurityAttributes; InitCount,MaxCount: Longint; Name: PChar): THandle;
function CreateSolidBrush(Color: TColorRef): HBrush;
function CreateThread(hreadAttributes: Pointer; StackSize: DWord; StartAddress: TFNThreadStartRoutine; Parameter: Pointer; CreationFlags: DWord; var ThreadId: DWord): THandle;
function CreateWindowEx(ExStyle: DWord; ClassName,WindowName: PChar; Style: DWord; X,Y,Width,Height: Integer; WndParent: hWnd; Menu: hMenu; Instance: hInst; Param: Pointer): hWnd;
function DPtoLP(DC: HDC; var Points; Count: Integer): Bool;
function DefDlgProc(Dlg: hWnd; Msg: UInt; WP: wParam; LP: lParam): lResult;
function DeferWindowPos(WinPosInfo: HDWP; Wnd,WndInsertAfter: hWnd; X,Y,CX,CY: Integer; Flags: UInt): HDWP;
function DefFrameProc(Wnd,WndMDIClient: hWnd; Msg: UInt; WP: wParam; LP: lParam): lResult;
function DefMDIChildProc(Wnd: hWnd; Msg: UInt; WP: wParam; LP: lParam): lResult;
function DefWindowProc(Wnd: hWnd; Msg: UInt; WP: wParam; LP: lParam): lResult;
function DeleteAtom(Atom: TAtom): TAtom;
procedure DeleteCriticalSection(var CriticalSection: TRTLCriticalSection);
function DeleteDC(DC: HDC): Bool;
function DeleteEnhMetaFile(Metafile: HEnhMetafile): Bool;
function DeleteFile(FileName: PChar): Bool;
function DeleteMenu(Menu: hMenu; Position,Flags: UInt): Bool;
function DeleteMetaFile(Metafile: HMetafile): Bool;
function DeleteObject(GDIObject: THandle): Bool;
function DestroyAcceleratorTable(Accel: HAccel): Bool;
function DestroyCaret: Bool;
function DestroyCursor(Cursor: HCursor): Bool;
function DestroyIcon(Icon: HIcon): Bool;
function DestroyMenu(Menu: hMenu): Bool;
function DestroyWindow(Wnd: hWnd): Bool;
function DeviceCapabilities(Device,Port: PChar; Capability: SmallWord; Output: PChar; DevMode: PDeviceMode): Integer;
function DialogBox(Instance: hInst; Template: PChar; WndParent: hWnd; DialogFunc: TFNDlgProc): Integer;
function DialogBoxParam(Instance: hInst; Template: PChar; WndParent: hWnd; DialogFunc: TFNDlgProc; Param: lParam): Integer;
function DialogBoxIndirect(Instance: hInst; const DlgTemplate: TDlgTemplate; WndParent: hWnd; DialogFunc: TFNDlgProc): Integer;
function DialogBoxIndirectParam(Instance: hInst; const DlgTemplate: TDlgTemplate; WndParent: hWnd; DialogFunc: TFNDlgProc; Param: lParam): Integer;
function DispatchMessage(const Msg: TMsg): Longint;
function DlgDirList(Dlg: hWnd; PathSpec: PChar; IDListBox,IDStaticPath: Integer; FileType: UInt): Integer;
function DlgDirListComboBox(Dlg: hWnd; PathSpec: PChar; IDComboBox,IDStaticPath: Integer; FileType: UInt): Integer;
function DlgDirSelectEx(Dlg: hWnd; Str: PChar; Count,IDListBox: Integer): Bool;
function DlgDirSelectComboBoxEx(Dlg: hWnd; Str: PChar; Count,IDComboBox: Integer): Bool;
function DllEntryPoint(Instance: hInst; Reason: DWord; Reserved: Pointer): Bool;
function DocumentProperties(Wnd: hWnd; hPrinter: THandle; pDeviceName: PChar;
  const pDevModeOutput: TDeviceMode; var pDevModeInput: TDeviceMode;
  fMode: DWord): Longint;
function DosDateTimeToFileTime(FatDate,FatTime: SmallWord; var FileTime: TFileTime): Bool;
function DrawFocusRect(DC: HDC; const Rect: TRect): Bool;
function DrawIcon(DC: HDC; X,Y: Integer; Icon: HIcon): Bool;
function DrawMenuBar(Wnd: hWnd): Bool;
function DrawText(DC: HDC; Str: PChar; Count: Integer; var Rect: TRect; Format: UInt): Integer;
function DuplicateHandle(SourceProcessHandle,SourceHandle,TargetProcessHandle: THandle; TargetHandle: PHandle; DesiredAccess: DWord; InheritHandle: Bool; Options: DWord): Bool;
function Ellipse(DC: HDC; X1,Y1,X2,Y2: Integer): Bool;
function EmptyClipboard: Bool;
function EnableMenuItem(Menu: hMenu; IDEnableItem,Enable: UInt): Bool;
function EnableScrollBar(Wnd: hWnd; SBflags,Arrows: UInt): Bool;
function EnableWindow(Wnd: hWnd; Enable: Bool): Bool;
function EndDeferWindowPos(WinPosInfo: HDWP): Bool;
function EndDialog(Wnd: hWnd; Result: Integer): Bool;
function EndDoc(DC: HDC): Longint;
function EndPage(DC: HDC): Longint;
function EndPath(DC: HDC): Bool;
function EndPaint(Wnd: hWnd; const Paint: TPaintStruct): Bool;
procedure EnterCriticalSection(var CriticalSection: TRTLCriticalSection);
function EnumChildWindows(Wnd: hWnd; EnumFunc: TFNWndEnumProc; Param: lParam): Bool;
function EnumClipboardFormats(Format: Longint): Integer;
function EnumEnhMetaFile(DC: HDC; MetaFile: HEnhMetafile; EnumProc: TFNEnhMFEnumProc; Data: Pointer; const Rect: TRect): Bool;
function EnumFonts(DC: HDC; Face: PChar; EnumProc: TFNFontEnumProc; Data: PChar): Integer;
function EnumFontFamilies(DC: HDC; Family: PChar; EnumProc: TFNFontEnumProc; Param: lParam): Integer;
function EnumMetaFile(DC: HDC; Metafile: HMetafile; EnumProc: TFNMFEnumProc; Param: lParam): Bool;
function EnumObjects(DC: HDC; ObjectType: Integer; ObjectFunc: TFNGObjEnumProc; Param: lParam): Integer;
function EnumPrinters(Flags: DWord; Name: PChar; Level: DWord;
  pPrinterEnum: Pointer; cbBuf: DWord; var pcbNeeded, pcReturned: DWord): Boolean;
function EnumProps(Wnd: hWnd; EnumFunc: TFNPropEnumProc): Integer;
function EnumPropsEx(Wnd: hWnd; EnumFunc: TFNPropEnumProcEx; Param: lParam): Integer;
function EnumThreadWindows(ThreadId: DWord; EnumProc: TFNWndEnumProc; Param: lParam): Bool;
function EnumWindows(EnumProc: TFNWndEnumProc; Param: lParam): Bool;
function EqualRect(const R1,R2: TRect): Bool;
function EqualRgn(Rgn1,Rgn2: HRgn): Bool;
function Escape(DC: HDC; Escape,cbInput: Integer; InData: PChar; OutData: Pointer): Integer;
function ExcludeClipRect(DC: HDC; X1,Y1,X2,Y2: Integer): Integer;
function ExcludeUpdateRgn(DC: HDC; Wnd: hWnd): Bool;
procedure ExitProcess(ExitCode: UInt);
procedure ExitThread(ExitCode: DWord);
function ExitWindows(Reserved: DWord; Code: UInt): Bool;
function ExitWindowsEx(Flags: DWord; Rserved: UInt): Bool;
function ExtCreatePen(PenStyle,Width: DWord; const Brush: TLogBrush; StyleCount: DWord; Style: Pointer): HPen;
function ExtCreateRegion(XForm: PXForm; Ciount: DWord; const RgnData: TRgnData): HRgn;
function ExtFloodFill(DC: HDC; X,Y: Longint; Color: TColorRef; FillType: UInt): Bool;
function ExtSelectClipRgn(DC: HDC; Rgn: HRgn; Mode: Integer): Integer;
function ExtTextOut(DC: HDC; X,Y: Integer; Options: UInt; Rect: PRect; Str: PChar; Count: UInt; DX: PInteger): Bool;
procedure FatalAppExit(Action: UInt; MessageText: PChar);
procedure FatalExit(ExitCode: Integer);
function FileTimeToDosDateTime(const FileTime: TFileTime; var FatDate,FatTime: SmallWord): Bool;
function FileTimeToLocalFileTime(const FileTime: TFileTime; var LocalFileTime: TFileTime): Bool;
function FileTimeToSystemTime(const FileTime: TFileTime; var SystemTime: TSystemTime): Bool;
function FillPath(DC: HDC): Bool;
function FillRect(DC: HDC; const Rect: TRect; Brush: HBrush): Integer;
function FillRgn(DC: HDC; Rgn: HRgn; Brush: HBrush): Bool;
function FindAtom(Str: PChar): TAtom;
function FindClose(FindFile: THandle): Bool;
function FindFirstFile(FileName: PChar; var FindFileData: TWIN32FindData): THandle;
function FindNextFile(FindFile: THandle; var FindFileData: TWIN32FindData): Bool;
function FindResource(Instance: hInst; ResName,ResType: PChar): HRSRC;
function FindWindow(ClassName,WindowName: PChar): hWnd;
function FlashWindow(Wnd: hWnd; Invert: Bool): Bool;
function FlattenPath(DC: HDC): Bool;
function FlushFileBuffers(FileHandle: THandle): Bool;
function FrameRect(DC: HDC; const Rect: TRect; Brush: HBrush): Integer;
function FrameRgn(DC: HDC; Rgn: HRgn; Brush: HBrush; Width,Height: Integer): Bool;
function FreeDDElParam(Msg: UInt; Param: Longint): Bool;
function FreeLibrary(Instance: hInst): Bool;
function GdiFlush: Boolean;
function GetACP: UInt;
function GetActiveWindow: hWnd;
function GetArcDirection(DC: HDC): Integer;
function GetAspectRatioFilterEx(DC: HDC; var AspectRation: TSize): Bool;
function GetAtomName(Atom: TAtom; Buffer: PChar; Size: Integer): UInt;
function GetBitmapBits(Bitmap: HBitmap; Count: Longint; Bits: Pointer): Longint;
function GetBitmapDimensionEx(Bitmap: HBitmap; var Dimension: TSize): Bool;
function GetBkColor(DC: HDC): TColorRef;
function GetBkMode(DC: HDC): Longint;
function GetBoundsRect(DC: HDC; var Rect: TRect; Flags: UInt): UInt;
function GetBrushOrgEx(DC: HDC; var Point: TPoint): Bool;
function GetCapture: hWnd;
function GetCaretBlinkTime: UInt;
function GetCaretPos(var Point: TPoint): Bool;
function GetCharABCWidths(DC: HDC; FirstChar,LastChar: UInt; const ABC): Bool;
function GetCharWidth(DC: HDC; FirstChar,LastChar: UInt; const Buffer): Bool;
function GetClassInfo(hInst: hInst; ClassName: PChar; var WndClass: TWndClass): Bool;
function GetClassLong(Wnd: hWnd; Index: Integer): DWord;
function GetClassName(Wnd: hWnd; ClassName: PChar; MaxCount: Integer): Integer;
function GetClassWord(Wnd: hWnd; Index: Integer): SmallWord;
function GetClientRect(Wnd: hWnd; var Rect: TRect): Bool;
function GetClipboardData(Format: UInt): THandle;
function GetClipboardFormatName(Format: UInt; FormatName: PChar; MaxCount: Integer): Integer;
function GetClipboardOwner: hWnd;
function GetClipboardViewer: hWnd;
function GetClipBox(DC: HDC; var Rect: TRect): Integer;
function GetClipCursor(var Rect: TRect): Bool;
function GetClipRgn(DC: HDC; Rgn: HRgn): Integer;
function GetCommandLine: PChar;
function GetCommandLineW: LPTSTR;
function GetCurrentDirectory(BufferLength: DWord; Buffer: PChar): DWord;
function GetCurrentObject(DC: HDC; ObjectType: UInt): HGDIObj;
function GetCurrentPositionEx(DC: HDC; Point: PPoint): Bool;
function GetCurrentProcess: THandle;
function GetCurrentProcessId: DWord;
function GetCurrentThread: THandle;
function GetCurrentThreadId: DWord;
function GetCurrentTime: Longint;
function GetCursor: HCursor;
function GetCursorPos(var Point: TPoint): Bool;
function GetDC(Wnd: hWnd): HDC;
function GetDCEx(Wnd: hWnd; Rgn: HRgn; Flags: DWord): HDC;
function GetDCOrgEx(DC: HDC; var Point: TPoint): Bool;
function GetDIBits(DC: HDC; Bitmap: HBitmap; StartScan,NumScans: UInt; Bits: Pointer; var BitInfo: TBitmapInfo; Usage: UInt): Integer;
function GetDeviceCaps(DC: HDC; Index: Integer): Integer;
function GetDialogBaseUnits: Longint;
function GetDiskFreeSpace(RootPathName: PChar; var SectorsPerCluster,BytesPerSector,NumberOfFreeClusters,TotalNumberOfClusters: DWord): Bool;
function GetDlgCtrlID(Wnd: hWnd): Integer;
function GetDlgItem(Dlg: hWnd; IDDlgItem: Integer): hWnd;
function GetDlgItemInt(Dlg: hWnd; IDDlgItem: Integer; var Translated: Bool; Signed: Bool): UInt;
function GetDlgItemText(Dlg: hWnd; IDDlgItem: Integer; Str: PChar; MaxCount: Integer): UInt;
function GetDoubleClickTime: UInt;
function GetDriveType(RootPathName: PChar): UInt;
function GetEnhMetaFile(Metafile: PChar): HEnhMetafile;
function GetEnhMetaFileBits(Metafile: HEnhMetafile; BufSize: UInt; Buffer: PByte): UInt;
function GetEnhMetaFileHeader(metafile: HEnhMetafile; BufSize: UInt; Buffer: PEnhMetaHeader): UInt;
function GetEnhMetaFilePaletteEntries(Metafile: HEnhMetafile; cEntries: UInt; ppe: Pointer): UInt;
function GetEnvironmentStrings: PChar;
function GetEnvironmentVariable(Name,Buffer: PChar; Size: DWord): DWord;
function GetExitCodeProcess(Process: THandle; var ExitCode: DWord): Bool;
function GetExitCodeThread(Thread: THandle; var ExitCode: DWord): Bool;
function GetFileAttributes(FileName: PChar): DWord;
function GetFileInformationByHandle(FileHandle: THandle; var FileInformation: TByHandleFileInformation): Bool;
function GetFileSize(Filehandle: THandle; FileSizeHigh: Pointer): DWord;
function GetFileTime(FileHandle: THandle; CreationTime,LastAccessTime,LastWriteTime: PFileTime): Bool;
function GetFileType(Filehandle: THandle): DWord;
function GetFocus: hWnd;
function GetForegroundWindow: hWnd;
function GetFullPathName(FileName: PChar; BufferLength: DWord; Buffer: PChar; var FilePart: PChar): DWord;
function GetGraphicsMode(DC: HDC): Integer;
function GetIconInfo(Icon: HIcon; var IconInfo: TIconInfo): Bool;
function GetKerningPairs(DC: HDC; Count: DWord; var KerningPairs): DWord;
function GetKeyboardType(TypeFlag: Integer): Integer;
function GetKeyNameText(Param: Longint; Str: PChar; Size: Integer): Integer;
function GetKeyState(VirtKey: Integer): SmallInt;
function GetLastActivePopup(Wnd: hWnd): hWnd;
function GetLastError: DWord;
procedure GetLocalTime(var SystemTime: TSystemTime);
function GetLogicalDriveStrings(BufferLength: DWord; Buffer: PChar): DWord;
function GetLogicalDrives: DWord;
function GetMapMode(DC: HDC): DWord;
function GetMenu(Wnd: hWnd): hMenu;
function GetMenuCheckMarkDimensions: Longint;
function GetMenuItemCount(Menu: hMenu): Integer;
function GetMenuItemID(Menu: hMenu; Pos: Integer): UInt;
function GetMenuState(Menu: hMenu; Id,Flags: UInt): UInt;
function GetMenuString(Menu: hMenu; IDItem: UInt; Str: PChar; MaxCount: Integer; Flags: UInt): Integer;
function GetMessage(var Msg: TMsg; Wnd: hWnd; MsgFilterMin,MsgFilterMax: UInt): Bool;
function GetMessageExtraInfo: Longint;
function GetMessagePos: DWord;
function GetMessageTime: Longint;
function GetMetaFile(MetaFile: PChar): HMetafile;
function GetMetaFileBitsEx(Metafile: HMetafile; Size: UInt; Data: Pointer): UInt;
function GetMiterLimit(DC: HDC; var Limit: Single): Bool;
function GetModuleFileName(Instance: hInst; FileName: PChar; Size: DWord): DWord;
function GetModuleHandle(ModuleName: PChar): hModule;
function GetNearestColor(DC: HDC; Color: TColorRef): TColorRef;
function GetNearestPaletteIndex(Pal: HPalette; Color: TColorRef): UInt;
function GetNextDlgGroupItem(Dlg,Ctl: hWnd; Previous: Bool): hWnd;
function GetNextDlgTabItem(Dlg,Ctl: hWnd; Previous: Bool): hWnd;
function GetNextWindow(Wnd: hWnd; Cmd: UInt): hWnd;
function GetOEMCP: UInt;
function GetObject(GDIObj: HGDIObj; BufSize: Integer; pObject: Pointer): Integer;
function GetObjectType(GDIObj: HGDIObj): Longint;
function GetOpenClipboardWindow: hWnd;
function GetOutlineTextMetrics(DC: HDC; DataSize: UInt; OTM: Pointer): UInt;
function GetOverlappedResult(Filehandle: THandle; const Overlapped: TOverlapped; var NumberOfBytesTransferred: DWord; Wait: Bool): Bool;
function GetPaletteEntries(Palette: HPalette; StartIndex,NumEntries: UInt; var PaletteEntries): UInt;
function GetParent(Wnd: hWnd): hWnd;
function GetPath(DC: HDC; var Points,Types,Size: Integer): Integer;
function GetPixel(DC: HDC; X,Y: Integer): TColorRef;
function GetPolyFillMode(DC: HDC): Integer;
function GetPriorityClass(Process: THandle): DWord;
function GetPriorityClipboardFormat(var FormatPriorityList; cFormats: Integer): Integer;
function GetPrivateProfileInt(AppName,KeyName: PChar; Default: Integer; FileName: PChar): UInt;
function GetPrivateProfileString(AppName,KeyName,Default,ReturnedString: PChar; Size: DWord; FileName: PChar): DWord;
function GetProcAddress(Module: hModule; ProcName: PChar): TFarProc;
function GetProfileInt(AppName,KeyName: PChar; Default: Integer): UInt;
function GetProfileString(AppName,KeyName,Default,ReturnedString: PChar; Size: DWord): DWord;
function GetProp(Wnd: hWnd; Str: PChar): THandle;
function GetQueueStatus(Flags: UInt): DWord;
function GetROP2(DC: HDC): Integer;
function GetRasterizerCaps(var Status: TRasterizerStatus; Size: UInt): Bool;
function GetRgnBox(Rgn: HRgn; var Rect: TRect): Integer;
function GetRegionData(Rgn: HRgn; Count: DWord; RgnData: PRgnData): DWord;
function GetScrollPos(Wnd: hWnd; Bar: Integer): Integer;
function GetScrollRange(Wnd: hWnd; Bar: Integer; var MinPos,MaxPos: Integer): Bool;
function GetStdHandle(StdHandle: DWord): THandle;
function GetStockObject(Index: Integer): HGDIObj;
function GetStretchBltMode(DC: HDC): Integer;
function GetSubMenu(Wnd: hWnd; Pos: Integer): hMenu;
function GetSysColor(Index: Integer): DWord;
function GetSystemDirectory(Buffer: PChar; Size: UInt): UInt;
function GetSystemMenu(Wnd: hWnd; Revert: Bool): hMenu;
function GetSystemMetrics(Index: Integer): Integer;
function GetSystemPaletteEntries(DC: HDC; StartIndex,NumEntries: UInt; var PaletteEntries): UInt;
procedure GetSystemTime(var SystemTime: TSystemTime);
function GetTabbedTextExtent(DC: HDC; Str: PChar; Count,TabPositions: Integer; var TabStopPositions): DWord;
function GetTempFileName(PathName,PrefixString: PChar; Unique: UInt; TempFileName: PChar): UInt;
function GetTempPath(BufferLength: DWord; Buffer: PChar): DWord;
function GetTextAlign(DC: HDC): UInt;
function GetTextCharacterExtra(DC: HDC): Integer;
function GetTextColor(DC: HDC): TColorRef;
function GetTextExtentPoint(DC: HDC; Str: PChar; Count: Integer; var Size: TSize): Bool;
function GetTextExtentPoint32(DC: HDC; Str: PChar; Count: Integer; var Size: TSize): Bool;
function GetTextFace(DC: HDC; Count: Integer; Buffer: PChar): Integer;
function GetTextMetrics(DC: HDC; var TM: TTextMetric): Bool;
function GetThreadPriority(Thread: THandle): Integer;
function GetTickCount: DWord;
function GetTimeZoneInformation(var TimeZoneInformation: TTimeZoneInformation): DWord;
function GetTopWindow(Wnd: hWnd): hWnd;
function GetUpdateRect(Wnd: hWnd; var Rect: TRect; Erase: Bool): Bool;
function GetUpdateRgn(Wnd: hWnd; Rgn: HRgn; Erase: Bool): Integer;
function GetViewportExtEx(DC: HDC; var Size: TSize): Bool;
function GetViewportOrgEx(DC: HDC; Point: PPoint): Bool;
function GetVolumeInformation(RootPathName,VolumeNameBuffer: PChar; VolumeNameSize: DWord; VolumeSerialNumber: PDWord; var MaximumComponentLength,FileSystemFlags: DWord; FileSystemNameBuffer: PChar; FileSystemNameSize: DWord): Bool;
function GetWinMetaFileBits(Metafile: HEnhMetafile; BufSize: UInt; Buffer: PByte; MapMode: Integer; RefDC: HDC): UInt;
function GetWindow(Wnd: hWnd; Cmd: UInt): hWnd;
function GetWindowDC(Wnd: hWnd): HDC;
function GetWindowExtEx(DC: HDC; var Size: TSize): Bool;
function GetWindowLong(Wnd: hWnd; Index: Integer): Longint;
function GetWindowOrgEx(DC: HDC; var Point: TPoint): Bool;
function GetWindowPlacement(Wnd: hWnd; WindowPlacement: PWindowPlacement): Bool;
function GetWindowRect(Wnd: hWnd; var Rect: TRect): Bool;
function GetWindowsDirectory(Buffer: PChar; Size: UInt): UInt;
function GetWindowText(Wnd: hWnd; Str: PChar; MaxCount: Integer): Integer;
function GetWindowTextLength(Wnd: hWnd): Integer;
function GetWindowThreadProcessId(Wnd: hWnd; ProcessId: Pointer): DWord;
function GetWindowWord(Wnd: hWnd; Index: Integer): SmallWord;
function GetWorldTransform(DC: HDC; var XForm: TXForm): Bool;
function GlobalAddAtom(Str: PChar): TAtom;
function GlobalAlloc(Flags: UInt; Bytes: DWord): HGlobal;
function GlobalDeleteAtom(Atom: TAtom): TAtom;
function GlobalDiscard(Handle: HGlobal): HGlobal;
function GlobalFindAtom(Str: PChar): TAtom;
function GlobalFlags(Mem: HGlobal): UInt;
function GlobalFree(Mem: HGlobal): HGlobal;
function GlobalGetAtomName(Atom: TAtom; Buffer: PChar; Size: Integer): UInt;
function GlobalHandle(Mem: Pointer): HGlobal;
function GlobalLock(Mem: HGlobal): Pointer;
procedure GlobalMemoryStatus(var MemoryStatus: TMemoryStatus);
function GlobalReAlloc(Mem: HGlobal; Bytes: DWord; Flags: UInt): HGlobal;
function GlobalSize(Mem: HGlobal): DWord;
function GlobalUnlock(Mem: HGlobal): Bool;
function HeapAlloc(Heap: THandle; Flags,Bytes: DWord): Pointer;
function HeapCreate(Options,InitialSize,MaxSize: DWord): THandle;
function HeapDestroy(Heap: THandle): Bool;
function HeapFree(Heap: THandle; Flags: DWord; Mem: Pointer): Bool;
function HeapReAlloc(Heap: THandle; Flags: DWord; Mem: Pointer; Bytes: DWord): Pointer;
function HeapSize(Heap: THandle; Flags: DWord; Mem: Pointer): DWord;
function HideCaret(Wnd: hWnd): Bool;
function HiliteMenuItem(Wnd: hWnd; Menu: hMenu; IDHiliteItem,Hilite: UInt): Bool;
function InflateRect(var Rect: TRect; DX,DY: Integer): Bool;
function InSendMessage: Bool;
function InitAtomTable(Size: DWord): Bool;
procedure InitializeCriticalSection(CriticalSection: TRTLCriticalSection);
procedure InitializeCriticalSectionAndSpinCount(CriticalSection: TRTLCriticalSection; SpinCount: DWord);
function InsertMenu(Menu: hMenu; Position,Flags,IDNewItem: UInt; NewItem: PChar): Bool;
function InterlockedDecrement(var Addend: Integer): Integer;
function InterlockedExchange(var Target: Integer; Value: Integer): Integer;
function InterlockedIncrement(var Addend: Integer): Integer;
function IntersectClipRect(DC: HDC; X1,Y1,X2,Y2: Integer): Integer;
function IntersectRect(var Dest: TRect; const Src1,Src2: TRect): Bool;
function InvalidateRect(Wnd: hWnd; Rect: PRect; Erase: Bool): Bool;
function InvalidateRgn(Wnd: hWnd; Rgn: HRgn; Erase: Bool): Bool;
function InvertRect(DC: HDC; const Rect: TRect): Bool;
function InvertRgn(DC: HDC; Rgn: HRgn): Bool;
function IsBadCodePtr(Code: TFarProc): Bool;
function IsBadReadPtr(Data: Pointer; Size: UInt): Bool;
function IsBadStringPtr(Str: PChar; MaxCount: UInt): Bool;
function IsBadWritePtr(Mem: Pointer; Size: UInt): Bool;
function IsChild(WndParent,Wnd: hWnd): Bool;
function IsClipboardFormatAvailable(Format: UInt): Bool;
function IsDBCSLeadByte(TestChar: Byte): Bool;
function IsDialogMessage(Wnd: hWnd; var Msg: TMsg): Bool;
function IsDlgButtonChecked(Dlg: hWnd; IDButton: Integer): UInt;
function IsIconic(Wnd: hWnd): Bool;
function IsMenu(Menu: hMenu): Bool;
function IsRectEmpty(const Rect: TRect): Bool;
function IsWindow(Wnd: hWnd): Bool;
function IsWindowEnabled(Wnd: hWnd): Bool;
function IsWindowVisible(Wnd: hWnd): Bool;
function IsZoomed(Wnd: hWnd): Bool;
function KillTimer(Wnd: hWnd; IDEvent: UInt): Bool;
function LPtoDP(DC: HDC; var Points; Count: Integer): Bool;
procedure LeaveCriticalSection(var CriticalSection: TRTLCriticalSection);
function LineDDA(X1,Y1,X2,Y2: Integer; LineFunc: TFNLineDDAProc; Data: lParam): Bool;
function LineTo(DC: HDC; X,Y: Integer): Bool;
function LoadAccelerators(Instance: hInst; TableName: PChar): HAccel;
function LoadBitmap(Instance: hInst; BitmapName: PChar): HBitmap;
function LoadCursor(Instance: hInst; CursorName: PChar): HCursor;
function LoadIcon(Instance: hInst; IconName: PChar): HIcon;
function LoadLibrary(LibFileName: PChar): hInst;
function LoadMenu(Instance: hInst; MenuName: PChar): hMenu;
function LoadMenuIndirect(MenuTemplate: Pointer): hMenu;
function LoadModule(ModuleName: PChar; ParameterBlock: Pointer): DWord;
function LoadResource(Instance: hInst; ResInfo: HRSRC): HGlobal;
function FreeResource(hResData: HGLOBAL): Bool;
function LockResource(ResData: HGlobal): Pointer;
function UnlockResource(hResData: THandle): Bool;
function LoadString(Instance: hInst; ID: UInt; Buffer: PChar; BufferMax: Integer): Integer;
function LocalAlloc(Flags,Bytes: UInt): HLocal;
function LocalDiscard(Mem: HLocal): HLocal;
function LocalFlags(Mem: HLocal): UInt;
function LocalFileTimeToFileTime(const LocalFileTime: TFileTime; var FileTime: TFileTime): Bool;
function LocalFree(Mem: HLocal): HLocal;
function LocalHandle(Mem: Pointer): HLocal;
function LocalUnlock(Mem: HLocal): Bool;
function LocalReAlloc(Mem: HLocal; Bytes,Flags: UInt): HLocal;
function LocalSize(Mem: HLocal): UInt;
function LocalLock(Mem: HLocal): Pointer;
function LockFile(FileHandle: THandle; FileOffsetLow,FileOffsetHigh,NumberOfBytesToLockLow,NumberOfBytesToLockHigh: DWord): Bool;
function LockWindowUpdate(Wnd: hWnd): Bool;
function MapDialogRect(Wnd: hWnd; var Rect: TRect): Bool;
function MapVirtualKey(Code,MapType: UInt): UInt;
function MapWindowPoints(WndFrom,WndTo: hWnd; var Points; cPoints: UInt): Integer;
function MaskBlt(DestDC: HDC; X,Y,Width,Hight: Integer; SrcDC: HDC; XSrc,YSrc: Integer; Mask: HBitmap; XMask,YMask: Integer; Rop: DWord): Bool;
function MessageBox(Wnd: hWnd; Text,Caption: PChar; uType: UInt): Integer;
function MessageBeep(uType: UInt): Bool;
function MsgWaitForMultipleObjects(Count: DWord; var Handles; WaitAll: Bool; Milliseconds,WakeMask: DWord): DWord;
function ModifyMenu(Menu: hMenu; Pos,Flags,IDNewItem: UInt; NewItem: PChar): Bool;
function ModifyWorldTransform(DC: HDC; const XForm: TXForm; Mode: DWord): Bool;
function MoveFile(ExistingFileName,NewFileName: PChar): Bool;
function MoveToEx(DC: HDC; X,Y: Integer; OldPos: PPoint): Bool;
function MoveWindow(Wnd: hWnd; X,Y,Width,Height: Integer; Repaint: Bool): Bool;
function MulDiv(Number,Numerator,Denominator: Integer): Integer;
function OffsetClipRgn(DC: HDC; DX,DY: Integer): Integer;
function OffsetRect(var Rect: TRect; DX,DY: Integer): Bool;
function OffsetRgn(Rgn: HRgn; DX,DY: Integer): Integer;
function OffsetViewportOrgEx(DC: HDC; X,Y: Integer; var Points): Bool;
function OffsetWindowOrgEx(DC: HDC; X,Y: Integer; var Points): Bool;
function OpenClipboard(Wnd: hWnd): Bool;
function OpenEvent(DesiredAccess: DWord; InheritHandle: Bool; Name: PChar): THandle;
function OpenFile(FileName: PChar; var ReOpenBuff: TOFStruct; Style: UInt): HFile;
function OpenMutex(DesiredAccess: DWord; InheritHandle: Bool; Name: PChar): THandle;
function OpenPrinter(pPrinterName: PChar; var phPrinter: THandle; pDefault: PPrinterDefaults): Boolean;
function OpenProcess(DesiredAccess: DWord; InheritHandle: Bool; ProcessId: DWord): THandle;
function OpenSemaphore(DesiredAccess: DWord; InheritHandle: Bool; Name: PChar): THandle;
function OpenThread(dwDesiredAccess: DWord; bInheritHandle: Bool; fwThreadId: DWord): THandle;
procedure OutputDebugString(OutputString: PChar);
function PackDDElParam(Msg,Lo,Hi: UInt): Longint;
function PaintRgn(DC: HDC; Rgn: HRgn): Bool;
function PatBlt(DC: HDC; X,Y,Width,Height: Integer; Rop: DWord): Bool;
function PathToRegion(DC: HDC): HRgn;
function PeekMessage(var Msg: TMsg; Wnd: hWnd; MsgFilterMin,MsgFilterMax,RemoveMsg: UInt): Bool;
function Pie(DC: HDC; X1,Y2,X2,Y2,X3,Y3,X4,Y4: Integer): Bool;
function PlayEnhMetaFile(DC: HDC; Metafile: HEnhMetafile; const Rect: TRect): Bool;
function PlayMetaFile(DC: HDC; Metafile: HMetafile): Bool;
function PlayMetaFileRecord(DC: HDC; const HandleTable: THandleTable; const MetaRecord: TMetaRecord; cHandles: UInt): Bool;
function PolyBezier(DC: HDC; const Points; Count: DWord): Bool;
function PolyBezierTo(DC: HDC; const Points; Count: DWord): Bool;
function PolyDraw(DC: HDC; const Points,Types; cCount: Integer): Bool;
function Polygon(DC: HDC; var Points; Count: Integer): Bool;
function Polyline(DC: HDC; var Points; Count: Integer): Bool;
function PolylineTo(DC: HDC; const Points; Count: DWord): Bool;
function PolyPolygon(DC: HDC; var Points,nPoints; nCount: Integer): Bool;
function PolyPolyline(DC: HDC; const PointStructs,Points; cCount: DWord): Bool;
procedure PostQuitMessage(ExitCode: Integer);
function PostMessage(Wnd: hWnd; Msg: UInt; WP: wParam; LP: lParam): Bool;
function PostThreadMessage(Thread: DWord; Msg: UInt; WP: wParam; LP: lParam): Bool;
function PtInRect(const Rect: TRect; Point: TPoint): Bool;
function PtInRegion(Rgn: HRgn; X,Y: Integer): Bool;
function PtVisible(DC: HDC; X,Y: Integer): Bool;
function PulseEvent(Event: THandle): Bool;
function ReadFile(FileHandle: THandle; var Buffer; NumberOfBytesToRead: DWord; var NumberOfBytesRead: DWord; Overlapped: POverlapped): Bool;
function RealizePalette(DC: HDC): UInt;
function RectInRegion(Rgn: HRgn; const Rect: TRect): Bool;
function RectVisible(DC: HDC; const Rect: TRect): Bool;
function Rectangle(DC: HDC; X1,Y1,X2,Y2: Integer): Bool;
function RedrawWindow(Wnd: hWnd; UpdateRect: PRect; UpdateRgn: HRgn; Flags: UInt): Bool;
function RegCloseKey(Key: HKey): Longint;
function RegCreateKey(Key: HKey; Subkey: PChar; var Result: HKey): Longint;
function RegCreateKeyEx(Key: HKey; Subkey: PChar; Reserved: DWord; kClass: PChar; Options: DWord; Desired: REGSAM; SecurityAttributes: PSecurityAttributes; var Result: HKey; Disposition: PDWord): Longint;
function RegDeleteKey(Key: HKey; SubKey: PChar): Longint;
function RegDeleteValue(Key: HKey; ValueName: PChar): Longint;
function RegEnumKey(Key: HKey; Index: DWord; Name: PChar; cbName: DWord): Longint;
function RegEnumKeyEx(Key: HKey; Index: DWord; Name: PChar; var cbName: DWord; Reserved: Pointer; kClass: PChar; cbClass: PDWord; LastWriteTime: PFileTime): Longint;
function RegEnumValue(Key: HKey; Index: DWord; ValueName: PChar; var ValueName: DWord; Reserved: Pointer; lpType: PDWord; Data: PByte; cbData: PDWord): Longint;
function RegOpenKey(Key: HKey; Subkey: PChar; var Result: HKey): Longint;
function RegOpenKeyEx(Key: HKey; Subkey: PChar; Options: DWord; Desired: REGSAM; var Result: HKey): Longint;
function RegQueryInfoKey(Key: HKey; kClass: PChar; pcbClass: PDWord; Reserved: Pointer; ubKeys,MaxSubKeyLen,MaxClassLen,Values,MaxValueNameLen,MaxValueLen,SecurityDescriptor: PDWord; LastWriteTime: PFileTime): Longint;
function RegQueryValue(Key: HKey; SubKey,Value: PChar; var cbValue: Longint): Longint;
function RegQueryValueEx(Key: HKey; ValueName: PChar; Reserved: Pointer; lpType: PDWord; Data: PByte; cbData: PDWord): Longint;
function RegSetValue(Key: HKey; SubKey: PChar; dwType: DWord; Data: PChar; cbData: DWord): Longint;
function RegSetValueEx(Key: HKey; SubKey: PChar; Reserved,dwType: DWord; Data: Pointer; cbData: DWord): Longint;
function RegisterClass(const WndClass: TWndClass): TAtom;
function RegisterClipboardFormat(Format: PChar): UInt;
function RegisterWindowMessage(Str: PChar): UInt;
function ReleaseCapture: Bool;
function ReleaseDC(Wnd: hWnd; DC: HDC): Integer;
function ReleaseMutex(Mutex: THandle): Bool;
function ReleaseSemaphore(Semaphore: THandle; ReleaseCount: Longint; PreviousCount: Pointer): Bool;
function RemoveDirectory(PathName: PChar): Bool;
function RemoveFontResource(FileName: PChar): Bool;
function RemoveMenu(Menu: hMenu; Pos,Flags: UInt): Bool;
function RemoveProp(Wnd: hWnd; Str: PChar): THandle;
function ReplyMessage(Result: lResult): Bool;
function ResetDC(DC: HDC; const InitData: TDeviceMode): Bool;
function ResetEvent(Event: THandle): Bool;
function ResizePalette(Pal: HPalette; Entries: UInt): Bool;
function RestoreDC(DC: HDC; SavedDC: Integer): Bool;
function ResumeThread(Thread: THandle): DWord;
function ReuseDDElParam(Param: Longint; msgIn,msgOut,Lo,Hi: UInt): Longint;
function RoundRect(DC: HDC; X1,Y1,X2,Y2,X3,Y3: Integer): Bool;
function SaveDC(DC: HDC): Integer;
function ScaleViewportExtEx(DC: HDC; XM,XD,YM,YD: Integer; Size: PSize): Bool;
function ScaleWindowExtEx(DC: HDC; XM,XD,YM,YD: Integer; Size: PSize): Bool;
function ScreenToClient(Wnd: hWnd; var Point: TPoint): Bool;
function ScrollDC(DC: HDC; DX,DY: Integer; var Scroll,Clip: TRect; Rgn: HRgn; Update: PRect): Bool;
function ScrollWindow(Wnd: hWnd; X,Y: Integer; Scroll,Clip: PRect): Bool;
function ScrollWindowEx(Wnd: hWnd; X,Y: Integer; Scroll,Clip: PRect; UpdateRgn: HRgn; UpdateRect: PRect; Flags: UInt): Bool;
function SearchPath(Path,FileName,Extension: PChar; BufferLength: DWord; Buffer: PChar; const FilePart: PChar): DWord;
function SelectClipRgn(DC: HDC; Rgn: HRgn): Integer;
function SelectObject(DC: HDC; GDIObj: HGDIObj): HGDIObj;
function SelectPalette(DC: HDC; Pal: HPalette; ForceBackground: Bool): HPalette;
function SendDlgItemMessage(Wnd: hWnd; IDDlgItem: Integer; Msg: UInt; WP: wParam; LP: lParam): Longint;
function SendMessage(hWnd: hWnd; Msg: UInt; WP: wParam; LP: lParam): lResult;
function SetActiveWindow(Wnd: hWnd): hWnd;
function SetArcDirection(DC: HDC; Direction: Integer): Integer;
function SetBitmapBits(Bitmap: HBitmap; cBytes: DWord; Bits: Pointer): Longint;
function SetBitmapDimensionEx(Bitmap: HBitmap; Width,Height: Integer; Size: PSize): Bool;
function SetBkColor(DC: HDC; Color: TColorRef): TColorRef;
function SetBkMode(DC: HDC; BkMode: Integer): Integer;
function SetBoundsRect(DC: HDC; Bounds: PRect; Flags: UInt): UInt;
function SetBrushOrgEx(DC: HDC; X,Y: Integer; var Points): Bool;
function SetCapture(Wnd: hWnd): hWnd;
function SetCaretBlinkTime(MSeconds: UInt): Bool;
function SetCaretPos(X,Y: Integer): Bool;
function SetClassLong(Wnd: hWnd; Index: Integer; NewLong: Longint): DWord;
function SetClassWord(Wnd: hWnd; Index: Integer; NewWord: SmallWord): SmallWord;
function SetClipboardData(Format: UInt; Mem: THandle): THandle;
function SetClipboardViewer(Wnd: hWnd): hWnd;
function SetCurrentDirectory(PathName: PChar): Bool;
function SetCursor(Cursor: HCursor): HCursor;
function SetCursorPos(X,Y: Integer): Bool;
function SetDIBits(DC: HDC; Bitmap: HBitmap; StartScan,NumScans: UInt; Bits: Pointer; var BitsInfo: TBitmapInfo; Usage: UInt): Integer;
function SetDIBitsToDevice(DC: HDC; X,Y,Width,Height: DWord; XSrc,YSrc: Integer; StartScan,NumScans: UInt; Bits: Pointer; var BitsInfo: TBitmapInfo; Usage: UInt): Integer;
function SetDlgItemInt(Wnd: hWnd; IDDlgItem: Integer; Value: UInt; Signed: Bool): Bool;
function SetDlgItemText(Wnd: hWnd; DDlgItem: Integer; Str: PChar): Bool;
function SetDoubleClickTime(Interval: UInt): Bool;
function SetEndOfFile(FileHandle: THandle): Bool;
function SetEnhMetaFileBits(BufSize: UInt; Buffer: PChar): HEnhMetafile;
function SetEnvironmentVariable(Name,Value: PChar): Bool;
function SetEvent(Event: THandle): Bool;
function SetFileAttributes(FileName: PChar; FileAttributes: DWord): Bool;
function SetFilePointer(FileHandle: THandle; DistanceToMove: Longint; DistanceToMoveHigh: Pointer; MoveMethod: DWord): DWord;
function SetFileTime(FileHandle: THandle; CreationTime,LastAccessTime,LastWriteTime: PFileTime): Bool;
function SetFocus(Wnd: hWnd): hWnd;
function SetForegroundWindow(Wnd: hWnd): Bool;
function SetGraphicsMode(DC: HDC; Mode: Integer): Integer;
function SetHandleCount(Number: UInt): UInt;
procedure SetLastError(ErrCode: DWord);
function SetLocalTime(const SystemTime: TSystemTime): Bool;
function SetMapMode(DC: HDC; MapMode: Integer): Integer;
function SetMapperFlags(DC: HDC; Flag: DWord): DWord;
function SetMenu(Wnd: hWnd; Menu: hMenu): Bool;
function SetMenuItemBitmaps(Menu: hMenu; Position,Flags: UInt; BitmapUnchecked,BitmapChecked: HBitmap): Bool;
function SetMetaFileBitsEx(Size: UInt; const Data: PChar): HMetafile;
function SetMiterLimit(DC: HDC; NewLimit: Single; OldLimit: PSingle): Bool;
function SetPaletteEntries(Pal: HPalette; StartIndex,NumEntries: UInt; var PaletteEntries): UInt;
function SetParent(WndChild,WndNewParent: hWnd): hWnd;
function SetPixel(DC: HDC; X,Y: Integer; Color: TColorRef): TColorRef;
function SetPolyFillMode(DC: HDC; PolyFillMode: Integer): Integer;
function SetPriorityClass(Process: THandle; PriorityClass: DWord): Bool;
function SetProp(Wnd: hWnd; Str: PChar; Data: THandle): Bool;
function SetRect(var Rect: TRect; X1,Y1,X2,Y2: Integer): Bool;
function SetRectEmpty(var Rect: TRect): Bool;
function SetRectRgn(Rgn: HRgn; X1,Y1,X2,Y2: Integer): Bool;
function SetROP2(DC: HDC; DrawMode: Integer): Integer;
function SetScrollPos(Wnd: hWnd; Bar,Pos: Integer; Redraw: Bool): Integer;
function SetScrollRange(Wnd: hWnd; Bar,MinPos,MaxPos: Integer; Redraw: Bool): Bool;
function SetStdHandle(StdHandle: DWord; Handle: THandle): Bool;
function SetStretchBltMode(DC: HDC; StretchMode: Integer): Integer;
function SetSysColors(cElements: Integer; const lpaElements,lpaRgbValues): Bool;
function SetSystemTime(SystemTime: TSystemTime): Bool;
function SetTimeZoneInformation(const TimeZoneInformation: TTimeZoneInformation): Bool;
function SetTextAlign(DC: HDC; Flags: UInt): UInt;
function SetTextCharacterExtra(DC: HDC; CharExtra: Integer): Integer;
function SetTextColor(DC: HDC; Color: TColorRef): TColorRef;
function SetTextJustification(DC: HDC; BreakExtra,BreakCount: Integer): Bool;
function SetThreadPriority(Thread: THandle; Priority: Integer): Bool;
function SetTimer(Wnd: hWnd; IDEvent,Elapse: UInt; TimerFunc: TFNTimerProc): UInt;
function SetViewportExtEx(DC: HDC; XExt,YExt: Integer; Size: PSize): Bool;
function SetViewportOrgEx(DC: HDC; X,Y: Integer; Point: PPoint): Bool;
function SetVolumeLabel(RootPathName,VolumeName: PChar): Bool;
function SetWindowExtEx(DC: HDC; XExt,YExt: Integer; Size: PSize): Bool;
function SetWindowLong(Wnd: hWnd; Index: Integer; NewLong: Longint): Longint;
function SetWindowOrgEx(DC: HDC; X,Y: Integer; Point: PPoint): Bool;
function SetWindowPlacement(Wnd: hWnd; WindowPlacement: PWindowPlacement): Bool;
function SetWindowPos(Wnd,WndInsertAfter: hWnd; X,Y,CX,CY: Integer; Flags: UInt): Bool;
function SetWindowsHookEx(Hook: Longint; HookFunc: TFNHookProc; Module: hInst; ThreadId: DWord): HHook;
function SetWindowText(Wnd: hWnd; Str: PChar): Bool;
function SetWindowWord(Wnd: hWnd; Index: Integer; NewWord: SmallWord): SmallWord;
function SetWinMetaFileBits(BufSize: UInt; Buffer: PChar; RefDC: HDC; const MetaFilePict: TMetaFilePict): HEnhMetafile;
function SetWorldTransform(DC: HDC; const XForm: TXForm): Bool;
function ShowCaret(Wnd: hWnd): Bool;
function ShowCursor(Show: Bool): Integer;
function ShowOwnedPopups(Wnd: hWnd; Show: Bool): Bool;
function ShowScrollBar(Wnd: hWnd; Bar: Integer; Show: Bool): Bool;
function ShowWindow(Wnd: hWnd; CmdShow: Integer): Bool;
function SizeofResource(Instance: hInst; ResInfo: HRSRC): Longint;
procedure Sleep(Milliseconds: DWord);
function StartDoc(DC: HDC; const DocInfo: TDocInfo): Integer;
function StartPage(DC: HDC): Integer;
function StretchDIBits(DestDC: HDC; X,Y,Width,Height,XSrc,YSrc,WidthSrc,HeightSrc: Integer; Bits: Pointer; var BitsInfo: TBitmapInfo; Usage: UInt; Rop: DWord): Integer;
function StretchBlt(DestDC: HDC; X,Y,Width,Height: Integer; SrcDC: HDC; XSrc,YSrc,SrcWidth,SrcHeight: Integer; Rop: DWord): Bool;
function StrokeAndFillPath(DC: HDC): Bool;
function StrokePath(DC: HDC): Bool;
function SubtractRect(var Dest: TRect; const Src1,Src2: TRect): Bool;
function SuspendThread(Thread: THandle): Longint;
function SwapMouseButton(Swap: Bool): Bool;
function SystemParametersInfo(Action,Param: UInt; Param: Pointer; WinIni: UInt): Bool;
function SystemTimeToFileTime(const SystemTime: TSystemTime; var FileTime: TFileTime): Bool;
function SystemTimeToTzSpecificLocalTime(TimeZoneInformation: PTimeZoneInformation; var UniversalTime,LocalTime: TSystemTime): Bool;
function TabbedTextOut(DC: HDC; X,Y: Integer; Str: PChar; Count,TabPositions: Integer; TabStopPositions: Pointer; TabOrigin: Integer): Longint;
function TerminateProcess(Process: THandle; ExitCode: UInt): Bool;
function TerminateThread(Thread: THandle; ExitCode: DWord): Bool;
function TextOut(DC: HDC; X,Y: Integer; Str: PChar; Count: Integer): Bool;
function TlsAlloc: DWord;
function TlsFree(TlsIndex: DWord): Bool;
function TlsGetValue(TlsIndex: DWord): Pointer;
function TlsSetValue(TlsIndex: DWord; TlsValue: Pointer): Bool;
function TrackPopupMenu(Menu: hMenu; Flags: UInt; X,Y,Reserved: Integer; Wnd: hWnd; Rect: PRect): Bool;
function TranslateAccelerator(Wnd: hWnd; AccTable: HAccel; var Msg: TMsg): Integer;
function TranslateMDISysAccel(Wnd: hWnd; const Msg: TMsg): Bool;
function TranslateMessage(const Msg: TMsg): Bool;
function UnhookWindowsHookEx(Hook: HHook): Bool;
function UnionRect(var Dest: TRect; const Src1,Src2: TRect): Bool;
function UnlockFile(FileHandle: THandle; FileOffsetLow,FileOffsetHigh,NumberOfBytesToUnlockLow,NumberOfBytesToUnlockHigh: DWord): Bool;
function UnpackDDElParam(Msg: UInt; Param: Longint; Lo,Hi: PUINT): Bool;
function UnrealizeObject(GDIObj: HGDIObj): Bool;
function UnregisterClass(ClassName: PChar; Inst: hInst): Bool;
function UpdateWindow(Wnd: hWnd): Bool;
function ValidateRect(Wnd: hWnd; Rect: PRect): Bool;
function ValidateRgn(Wnd: hWnd; Rgn: HRgn): Bool;
function VkKeyScan(keyScan: Char): SmallInt;
function WaitForMultipleObjects(Count: DWord; Handles: PWOHandleArray; WaitAll: Bool; Milliseconds: DWord): DWord;
function WaitForSingleObject(Handle: THandle; Milliseconds: DWord): DWord;
function WaitMessage: Bool;
function WidenPath(DC: HDC): Bool;
function WinExec(CmdLine: PChar; CmdShow: UInt): UInt;
function WinHelp(WndMain: hWnd; Help: PChar; Command,Data: DWord): Bool;
function WindowFromPoint(Point: TPoint): hWnd;
function WindowFromDC(DC: HDC): hWnd;
function WriteFile(FileHandle: THandle; const Buffer; NumberOfBytesToWrite: DWord; var NumberOfBytesWritten: DWord; Overlapped: POverlapped): Bool;
function WritePrivateProfileString(AppName,KeyName,Str,FileName: PChar): Bool;
function WriteProfileString(AppName,KeyName,Str: PChar): Bool;
procedure ZeroMemory(Destination: Pointer; Length: DWord);
function _lclose(FileHandle: HFile): HFile;
function _lcreat(PathName: PChar; Attribute: Integer): HFile;
function _lopen(PathName: PChar; ReadWrite: Integer): HFile;
function _lread(FileHandle: HFile; Buffer: Pointer; Bytes: UInt): UInt;
function _llseek(FileHandle: HFile; Offset: Longint; Origin: Integer): Longint;
function _lwrite(FileHandle: HFile; const Buffer: PChar; Bytes: UInt): UInt;
function wsprintf(Output,Format: PChar): Integer;
function wvsprintf(Output,Format: PChar; var ArgList): Longint;
function CharNext(Ch: PChar): PChar;
function CharPrev(Start,Current: PChar): PChar;
function GetDesktopWindow: hWnd;
function CharToOem(Src,Dest: PChar): Bool;
function OemToChar(Src,Dest: PChar): Bool;
function CharToOemBuff(Src,Dest: PChar; DstLength: DWord): Bool;
function OemToCharBuff(Src,Dest: PChar; DstLength: DWord): Bool;
function IsBadHugeReadPtr(P: Pointer; cb: UInt): Bool;
function IsBadHugeWritePtr(P: Pointer; cb: UInt): Bool;
function FloodFill(DC: HDC; XStart,YStart: Integer; FillColor: TColorRef): Bool;
function IsCharAlpha(Ch: Char): Bool;
function IsCharAlphaNumeric(Ch: Char): Bool;
function IsCharLower(Ch: Char): Bool;
function IsCharUpper(Ch: Char): Bool;
function lstrcat(Str1,Str2: PChar): PChar;
function lstrcmp(Str1,Str2: PChar): Integer;
function lstrcmpi(Str1,Str2: PChar): Integer;
function lstrcpy(Str1,Str2: PChar): PChar;
function lstrlen(Str: PChar): Integer;

function MoveTo(DC: HDC; X,Y: Integer): Bool;
function SmallPointToPoint(const P: TSmallPoint): TPoint;
function PointToSmallPoint(const P: TPoint): TSmallPoint;

function TPointFromLong(L: Longint): TPoint;

{$IFNDEF Open32}

type
  LCID = DWord;
  LangId = Word;

type
  LONGLONG = Comp;
  PSID = Pointer;
  PLargeInteger = ^TLargeInteger;
  TLargeInteger = record
    case Integer of
    0: (
      LowPart: DWord;
      HighPart: Longint);
    1: (
      QuadPart: LONGLONG);
  end;

(*
 *  Language IDs.
 *
 *  The following two combinations of primary language ID and
 *  sublanguage ID have special semantics:
 *
 *    Primary Language ID   Sublanguage ID      Result
 *    -------------------   ---------------     ------------------------
 *    LANG_NEUTRAL          SUBLANG_NEUTRAL     Language neutral
 *    LANG_NEUTRAL          SUBLANG_DEFAULT     User default language
 *    LANG_NEUTRAL          SUBLANG_SYS_DEFAULT System default language
 *)

const
{ Primary language IDs. }

  Lang_Neutral                         = $00;

  Lang_Afrikaans                       = $36;
  Lang_Albanian                        = $1c;
  Lang_Arabic                          = $01;
  Lang_Basqur                          = $2d;
  Lang_Belarusian                      = $23;
  Lang_Bulgarian                       = $02;
  Lang_Catalan                         = $03;
  Lang_Chinese                         = $04;
  Lang_Croatian                        = $1a;
  Lang_Czech                           = $05;
  Lang_Danish                          = $06;
  Lang_Dutch                           = $13;
  Lang_English                         = $09;
  Lang_Estonian                        = $25;
  Lang_Faeroese                        = $38;
  Lang_Farsi                           = $29;
  Lang_Finnish                         = $0b;
  Lang_French                          = $0c;
  Lang_German                          = $07;
  Lang_Greek                           = $08;
  Lang_Hebrew                          = $0d;
  Lang_Hungarian                       = $0e;
  Lang_Icelandic                       = $0f;
  Lang_Indonesian                      = $21;
  Lang_Italian                         = $10;
  Lang_Japanese                        = $11;
  Lang_Korean                          = $12;
  Lang_Latvian                         = $26;
  Lang_Lithuanian                      = $27;
  Lang_Norvegian                       = $14;
  Lang_Polish                          = $15;
  Lang_Portuguese                      = $16;
  Lang_Romanian                        = $18;
  Lang_Russian                         = $19;
  Lang_Serbian                         = $1a;
  Lang_Slovak                          = $1b;
  Lang_Slovenian                       = $24;
  Lang_Spanish                         = $0a;
  Lang_Swedish                         = $1d;
  Lang_Thai                            = $1e;
  Lang_Turkish                         = $1f;
  Lang_Ukrainian                       = $22;
  Lang_Vietnamese                      = $2a;


{ Sublanguage IDs. }

  { The name immediately following SUBLANG_ dictates which primary
    language ID that sublanguage ID can be combined with to form a
    valid language ID. }

  SubLang_Neutral                      = $00;    { language neutral }
  SubLang_Default                      = $01;    { user default }
  SubLang_Sys_Default                  = $02;    { system default }

  SubLang_Arabic_Saudi_Arabia          = $01;    { Arabic (Saudi Arabia) }
  SubLang_Arabic_Iraq                  = $02;    { Arabic (Iraq) }
  SubLang_Arabic_Egypt                 = $03;    { Arabic (Egypt) }
  SubLang_Arabic_Libya                 = $04;    { Arabic (Libya) }
  SubLang_Arabic_Algeria               = $05;    { Arabic (Algeria) }
  SubLang_Arabic_Morocco               = $06;    { Arabic (Morocco) }
  SubLang_Arabic_Tunista               = $07;    { Arabic (Tunisia) }
  SubLang_Arabic_Oman                  = $08;    { Arabic (Oman) }
  SubLang_Arabic_Yemen                 = $09;    { Arabic (Yemen) }
  SubLang_Arabic_Syria                 = $0a;    { Arabic (Syria) }
  SubLang_Arabic_Jordan                = $0b;    { Arabic (Jordan) }
  SubLang_Arabic_Lebanon               = $0c;    { Arabic (Lebanon) }
  SubLang_Arabic_Kuwait                = $0d;    { Arabic (Kuwait) }
  SubLang_Arabic_UAE                   = $0e;    { Arabic (U.A.E) }
  SubLang_Arabic_Bahrain               = $0f;    { Arabic (Bahrain) }
  SubLang_Arabic_Qatar                 = $10;    { Arabic (Qatar) }
  SubLang_Chinese_Traditional          = $01;    { Chinese (Taiwan) }
  SubLang_Chinese_Simplified           = $02;    { Chinese (PR China) }
  SubLang_Chinese_Hongkong             = $03;    { Chinese (Hong Kong) }
  SubLang_Chinese_Singapore            = $04;    { Chinese (Singapore) }
  SubLang_Dutch                        = $01;    { Dutch }
  SubLang_Dutch_Belgian                = $02;    { Dutch (Belgian) }
  SubLang_English_US                   = $01;    { English (USA) }
  SubLang_English_UK                   = $02;    { English (UK) }
  SubLang_English_AUS                  = $03;    { English (Australian) }
  SubLang_English_CAN                  = $04;    { English (Canadian) }
  SubLang_English_NZ                   = $05;    { English (New Zealand) }
  SubLang_English_Eire                 = $06;    { English (Irish) }
  SubLang_English_South_Africa         = $07;    { English (South Africa) }
  SubLang_English_Jamaica              = $08;    { English (Jamaica) }
  SubLang_English_Caribbean            = $09;    { English (Caribbean) }
  SubLang_English_Belize               = $0a;    { English (Belize) }
  SubLang_English_Trinidad             = $0b;    { English (Trinidad) }
  SubLang_French                       = $01;    { French }
  SubLang_French_Belgian               = $02;    { French (Belgian) }
  SubLang_French_Canadian              = $03;    { French (Canadian) }
  SubLang_French_Swiss                 = $04;    { French (Swiss) }
  SubLang_French_Luxembourg            = $05;    { French (Luxembourg) }
  SubLang_German                       = $01;    { German }
  SubLang_German_Swiss                 = $02;    { German (Swiss) }
  SubLang_German_Austrian              = $03;    { German (Austrian) }
  SubLang_German_Luxembourg            = $04;    { German (Luxembourg) }
  SubLang_German_Liechtenstein         = $05;    { German (Liechtenstein) }
  SubLang_Italian                      = $01;    { Italian }
  SubLang_Italian_Swiss                = $02;    { Italian (Swiss) }
  SubLang_Korean                       = $01;    { Korean (Extended Wansung) }
  SubLang_Korean_Johab                 = $02;    { Korean (Johab) }
  SubLang_Norvegian_Bokmal             = $01;    { Norwegian (Bokmal) }
  SubLang_Norvegian_Nynorsk            = $02;    { Norwegian (Nynorsk) }
  SubLang_Portuguese                   = $02;    { Portuguese }
  SubLang_Portuguese_Brazilian         = $01;    { Portuguese (Brazilian) }
  SubLang_Serbian_Latin                = $02;    { Serbian (Latin) }
  SubLang_Serbian_Cyrillic             = $03;    { Serbian (Cyrillic) }
  SubLang_Spanish                      = $01;    { Spanish (Castilian) }
  SubLang_Spanish_Mexican              = $02;    { Spanish (Mexican) }
  SubLang_Spanish_Modern               = $03;    { Spanish (Modern) }
  SubLang_Spanish_Guatemala            = $04;    { Spanish (Guatemala) }
  SubLang_Spanish_Costa_Rica           = $05;    { Spanish (Costa Rica) }
  SubLang_Spanish_Panama               = $06;    { Spanish (Panama) }
  SubLang_Spanish_Dominican_Republic     = $07;  { Spanish (Dominican Republic) }
  SubLang_Spanish_Venezuela            = $08;    { Spanish (Venezuela) }
  SubLang_Spanish_Colombia             = $09;    { Spanish (Colombia) }
  SubLang_Spanish_Peru                 = $0a;    { Spanish (Peru) }
  SubLang_Spanish_Argentina            = $0b;    { Spanish (Argentina) }
  SubLang_Spanish_Ecuador              = $0c;    { Spanish (Ecuador) }
  SubLang_Spanish_Chile                = $0d;    { Spanish (Chile) }
  SubLang_Spanish_Uruguay              = $0e;    { Spanish (Uruguay) }
  SubLang_Spanish_Paraguay             = $0f;    { Spanish (Paraguay) }
  SubLang_Spanish_Bolivia              = $10;    { Spanish (Bolivia) }
  SubLang_Spanish_El_Salvador          = $11;    { Spanish (El Salvador) }
  SubLang_Spanish_Honduras             = $12;    { Spanish (Honduras) }
  SubLang_Spanish_Nicaragua            = $13;    { Spanish (Nicaragua) }
  SubLang_Spanish_Puerto_Rico          = $14;    { Spanish (Puerto Rico) }
  SUBLANG_Swedish                      = $01;    { Swedish }
  SUBLANG_Swedish_Finland              = $02;    { Swedish (Finland) }


{ Sorting IDs. }

  Sort_Default                         = $0;     { sorting default }

  Sort_Japanese_XJIS                   = $0;     { Japanese XJIS order }
  Sort_Japanese_Unicode                = $1;     { Japanese Unicode order }

  Sort_Chinese_BIG5                    = $0;     { Chinese BIG5 order }
  Sort_Chinese_PRCP                    = $0;     { PRC Chinese Phonetic order }
  Sort_Chinese_Unicode                 = $1;     { Chinese Unicode order }
  Sort_Chinese_PRC                     = $2;     { PRC Chinese Stroke Count order }

  Sort_Korean_Ksc                      = $0;     { Korean KSC order }
  Sort_Korean_Unicode                  = $1;     { Korean Unicode order }

  Sort_German_Phone_Book               = $1;     { German Phone Book order }


(*
 *  A language ID is a 16 bit value which is the combination of a
 *  primary language ID and a secondary language ID.  The bits are
 *  allocated as follows:
 *
 *       +-----------------------+-------------------------+
 *       |     Sublanguage ID    |   Primary Language ID   |
 *       +-----------------------+-------------------------+
 *        15                   10 9                       0   bit
 *
 *
 *
 *  A locale ID is a 32 bit value which is the combination of a
 *  language ID, a sort ID, and a reserved area.  The bits are
 *  allocated as follows:
 *
 *       +-------------+---------+-------------------------+
 *       |   Reserved  | Sort ID |      Language ID        |
 *       +-------------+---------+-------------------------+
 *        31         20 19     16 15                      0   bit
 *
 *)

{ Default System and User IDs for language and locale. }

  Lang_System_Default   = (SubLang_Sys_Default shl 10) or Lang_Neutral;
  Lang_User_Default     = (Sublang_Default shl 10) or Lang_Neutral;

  Locale_System_Default = (Sort_Default shl 16) or Lang_System_Default;
  Locale_User_Default   = (Sort_Default shl 16) or Lang_User_Default;


  Status_User_APC                 = $000000C0;
  Status_Pending                  = $00000103;
  Status_Segment_Notification     = $40000005;
  Status_Guard_Page_Violation     = $80000001;
  Status_Datatype_Misalignment    = $80000002;
  Status_Breakpoint               = $80000003;
  Status_Single_Step              = $80000004;
  Status_In_Page_Error            = $C0000006;
  Status_Invalid_Handle           = $C0000008;
  Status_Illegal_Instruction      = $C000001D;
  Status_Noncontinuable_Exception = $C0000025;
  Status_Invalid_Disposition      = $C0000026;
  Status_Array_Bounds_Exceeded    = $C000008C;
  Status_Float_Denormal_Operand   = $C000008D;
  Status_Float_Divide_By_Zero     = $C000008E;
  Status_Float_Inexact_Result     = $C000008F;
  Status_Float_Invalid_Operation  = $C0000090;
  Status_Float_Overflow           = $C0000091;
  Status_Float_Stack_Check        = $C0000092;
  Status_Float_Underflow          = $C0000093;
  Status_Integer_Divide_By_Zero   = $C0000094;
  Status_Integer_Overflow         = $C0000095;
  Status_Privileged_Instruction   = $C0000096;
  Status_Stack_Overflow           = $C00000FD;
  Status_Control_C_Exit           = $C000013A;

  Size_Of_80387_Registers = 80;

  { The following flags control the contents of the CONTEXT structure. }

  Context_i386 = $10000;     { this assumes that i386 and }
  Context_i486 = $10000;     { i486 have identical context records }

  Context_Control         = (Context_i386 or $00000001); { SS:SP, CS:IP, FLAGS, BP }
  Context_Integer         = (Context_i386 or $00000002); { AX, BX, CX, DX, SI, DI }
  Context_Segments        = (Context_i386 or $00000004); { DS, ES, FS, GS }
  Context_Floating_Point  = (Context_i386 or $00000008); { 387 state }
  Context_Debug_Registers = (Context_i386 or $00000010); { DB 0-3,6,7 }
  Context_Full = (Context_Control or Context_Integer or Context_Segments);

type
  PFloatingSaveArea = ^TFloatingSaveArea;
  TFloatingSaveArea = record
    ControlWord: DWord;
    StatusWord: DWord;
    TagWord: DWord;
    ErrorOffset: DWord;
    ErrorSelector: DWord;
    DataOffset: DWord;
    DataSelector: DWord;
    RegisterArea: array[0..Size_Of_80387_Registers - 1] of Byte;
    Cr0NpxState: DWord;
  end;

{ This frame has a several purposes: 1) it is used as an argument to
  NtContinue, 2) is is used to constuct a call frame for APC delivery,
  and 3) it is used in the user level thread creation routines.
  The layout of the record conforms to a standard call frame. }

  PContext = ^TContext;
  TContext = record

  { The flags values within this flag control the contents of
    a CONTEXT record.

    If the context record is used as an input parameter, then
    for each portion of the context record controlled by a flag
    whose value is set, it is assumed that that portion of the
    context record contains valid context. If the context record
    is being used to modify a threads context, then only that
    portion of the threads context will be modified.

    If the context record is used as an IN OUT parameter to capture
    the context of a thread, then only those portions of the thread's
    context corresponding to set flags will be returned.

    The context record is never used as an OUT only parameter. }

    ContextFlags: DWord;

  { This section is specified/returned if CONTEXT_DEBUG_REGISTERS is
    set in ContextFlags.  Note that CONTEXT_DEBUG_REGISTERS is NOT
    included in CONTEXT_FULL. }

    Dr0: DWord;
    Dr1: DWord;
    Dr2: DWord;
    Dr3: DWord;
    Dr6: DWord;
    Dr7: DWord;

  { This section is specified/returned if the
    ContextFlags word contians the flag CONTEXT_FLOATING_POINT. }

    FloatSave: TFloatingSaveArea;

  { This section is specified/returned if the
    ContextFlags word contians the flag CONTEXT_SEGMENTS. }

    SegGs: DWord;
    SegFs: DWord;
    SegEs: DWord;
    SegDs: DWord;

  { This section is specified/returned if the
    ContextFlags word contians the flag CONTEXT_INTEGER. }

    Edi: DWord;
    Esi: DWord;
    Ebx: DWord;
    Edx: DWord;
    Ecx: DWord;
    Eax: DWord;

  { This section is specified/returned if the
    ContextFlags word contians the flag CONTEXT_CONTROL. }

    Ebp: DWord;
    Eip: DWord;
    SegCs: DWord;
    EFlags: DWord;
    Esp: DWord;
    SegSs: DWord;
  end;

const
  { bitfield constants for Flags field of TLDTEntry }

  ldtf_BaseMid      = $FF000000;  {8}
  ldtf_Type_8       = $00F80000;  {5}
  ldtf_Dpl          = $00060000;  {2}
  ldtf_Pres         = $00010000;  {1}
  ldtf_LimitHi      = $0000F000;  {4}
  ldtf_Sys          = $00000800;  {1}
  ldtf_Reserved_0   = $00000400;  {1}
  ldtf_Default_Big  = $00000200;  {1}
  ldtf_Granularity  = $00000100;  {1}
  ldtf_BaseHi       = $000000FF;  {8}


type
  PLDTEntry = ^TLDTEntry;
  TLDTEntry = record
    LimitLow: Word;
    BaseLow: Word;
    case Integer of
      0: (
        BaseMid: Byte;
        Flags1: Byte;
        Flags2: Byte;
        BaseHi: Byte);
      1: (
        Flags: Longint);
  end;

const
  Exception_NonContinuable     = 1;    { Noncontinuable exception }
  Exception_Maximum_Parameters = 15;   { maximum number of exception parameters }

type
  PExceptionRecord = ^TExceptionRecord;
  TExceptionRecord = record
    ExceptionCode: DWord;
    ExceptionFlags: DWord;
    ExceptionRecord: PExceptionRecord;
    ExceptionAddress: Pointer;
    NumberParameters: DWord;
    ExceptionInformation: array[0..EXCEPTION_MAXIMUM_PARAMETERS - 1] of DWord;
  end;

{ Typedef for pointer returned by exception_info() }

  TExceptionPointers = record
    ExceptionRecord : PExceptionRecord;
    ContextRecord : PContext;
  end;

const
  Mutant_Query_State = $0001;
  Mutant_All_Access = (Standard_Rights_Required or Synchronize or
                       Mutant_Query_State);

type
  PMemoryBasicInformation = ^TMemoryBasicInformation;
  TMemoryBasicInformation = record
    BaseAddress : Pointer;
    AllocationBase : Pointer;
    AllocationProtect : DWord;
    RegionSize : DWord;
    State : DWord;
    Protect : DWord;
    Type_9 : DWord;
  end;

const
  Section_Query = 1;
  Section_Map_Write = 2;
  Section_Map_Read = 4;
  Section_Map_Execute = 8;
  Section_Extend_Size = $10;
  Section_All_Access = (Standard_Rights_Required or Section_Query or
    Section_Map_Write or Section_Map_Read or Section_Map_Execute or Section_Extend_Size);

  Mem_Reset = $80000;


  File_Share_Delete                   = $00000004;
  File_Atrribute_Offline              = $00001000;
  File_Notify_Change_Last_Access      = $00000020;
  File_Notify_Change_Creation         = $00000040;
  File_Action_Added                   = $00000001;
  File_Action_Removed                 = $00000002;
  File_Action_Modified                = $00000003;
  File_Action_Renamed_Old_Name        = $00000004;
  File_Action_Renamed_New_Name        = $00000005;
  Mailslot_No_Message                 = -1;
  Mailslot_Wait_Forever               = -1;

type
  PSECURITY_DESCRIPTOR = Pointer;


const
  { The following are masks for the predefined standard access types }

  ACCESS_SYSTEM_SECURITY   = $01000000;
  MAXIMUM_ALLOWED          = $02000000;

type
  { Define the generic mapping array.  This is used to denote the
    mapping of each generic access right to a specific access mask. }

  PGenericMapping = ^TGenericMapping;
  TGenericMapping = record
    GenericRead: ACCESS_MASK;
    GenericWrite: ACCESS_MASK;
    GenericExecute: ACCESS_MASK;
    GenericAll: ACCESS_MASK;
  end;

  PLUIDAndAttributes = ^TLUIDAndAttributes;
  TLUIDAndAttributes = record
    Luid: TLargeInteger;
    Attributes: DWord;
  end;

{ ////////////////////////////////////////////////////////////////////// }
{                                                                    // }
{              Security Id     (SID)                                 // }
{                                                                    // }
{ ////////////////////////////////////////////////////////////////////// }


{ Pictorially the structure of an SID is as follows: }

{         1   1   1   1   1   1 }
{         5   4   3   2   1   0   9   8   7   6   5   4   3   2   1   0 }
{      +---------------------------------------------------------------+ }
{      |      SubAuthorityCount        |Reserved1 (SBZ)|   Revision    | }
{      +---------------------------------------------------------------+ }
{      |                   IdentifierAuthority[0]                      | }
{      +---------------------------------------------------------------+ }
{      |                   IdentifierAuthority[1]                      | }
{      +---------------------------------------------------------------+ }
{      |                   IdentifierAuthority[2]                      | }
{      +---------------------------------------------------------------+ }
{      |                                                               | }
{      +- -  -  -  -  -  -  -  SubAuthority[]  -  -  -  -  -  -  -  - -+ }
{      |                                                               | }
{      +---------------------------------------------------------------+ }

  PSIDIdentifierAuthority = ^TSIDIdentifierAuthority;
  TSIDIdentifierAuthority = record
    Value: array[0..5] of Byte;
  end;

const
  SidTypeUser = 1;
  SidTypeGroup = 2;
  SidTypeDomain = 3;
  SidTypeAlias = 4;
  SidTypeWellKnownGroup = 5;
  SidTypeDeletedAccount = 6;
  SidTypeInvalid = 7;
  SidTypeUnknown = 8;
type
  SID_NAME_USE = DWord;

  PSIDAndAttributes = ^TSIDAndAttributes;
  TSIDAndAttributes = record
    Sid: PSID;
    Attributes: DWord;
  end;

  PACL = ^TACL;
  TACL = record
    AclRevision: Byte;
    Sbz1: Byte;
    AclSize: Word;
    AceCount: Word;
    Sbz2: Word;
  end;

  { The following declarations are used for setting and querying information
    about and ACL.  First are the various information classes available to
    the user. }

  TAclInformationClass = (AclInfoPad, AclRevisionInformation, AclSizeInformation);

{ Security Descriptor and related data types. }

const
  Security_Descriptor_Min_Length = 20;
  se_Owner_Defaulted = $0001;
  se_Group_Defaulted = $0002;
  se_DACL_Present    = $0004;
  se_DACL_Defaulted  = $0008;
  se_SACL_Present    = $0010;
  se_SACL_Defaulted  = $0020;
  se_SELF_Relative   = $8000;

{  Where: }

{      SE_OWNER_DEFAULTED - This boolean flag, when set, indicates that the }
{          SID pointed to by the Owner field was provided by a }
{          defaulting mechanism rather than explicitly provided by the }
{          original provider of the security descriptor.  This may }
{          affect the treatment of the SID with respect to inheritence }
{          of an owner. }

{      SE_GROUP_DEFAULTED - This boolean flag, when set, indicates that the }
{          SID in the Group field was provided by a defaulting mechanism }
{          rather than explicitly provided by the original provider of }
{          the security descriptor.  This may affect the treatment of }
{          the SID with respect to inheritence of a primary group. }

{      SE_DACL_PRESENT - This boolean flag, when set, indicates that the }
{          security descriptor contains a discretionary ACL.  If this }
{          flag is set and the Dacl field of the SECURITY_DESCRIPTOR is }
{          null, then a null ACL is explicitly being specified. }

{      SE_DACL_DEFAULTED - This boolean flag, when set, indicates that the }
{          ACL pointed to by the Dacl field was provided by a defaulting }
{          mechanism rather than explicitly provided by the original }
{          provider of the security descriptor.  This may affect the }
{          treatment of the ACL with respect to inheritence of an ACL. }
{          This flag is ignored if the DaclPresent flag is not set. }

{      SE_SACL_PRESENT - This boolean flag, when set,  indicates that the }
{          security descriptor contains a system ACL pointed to by the }
{          Sacl field.  If this flag is set and the Sacl field of the }
{          SECURITY_DESCRIPTOR is null, then an empty (but present) }
{          ACL is being specified. }

{      SE_SACL_DEFAULTED - This boolean flag, when set, indicates that the }
{          ACL pointed to by the Sacl field was provided by a defaulting }
{          mechanism rather than explicitly provided by the original }
{          provider of the security descriptor.  This may affect the }
{          treatment of the ACL with respect to inheritence of an ACL. }
{          This flag is ignored if the SaclPresent flag is not set. }

{      SE_SELF_RELATIVE - This boolean flag, when set, indicates that the }
{          security descriptor is in self-relative form.  In this form, }
{          all fields of the security descriptor are contiguous in memory }
{          and all pointer fields are expressed as offsets from the }
{          beginning of the security descriptor.  This form is useful }
{          for treating security descriptors as opaque data structures }
{          for transmission in communication protocol or for storage on }
{          secondary media. }



{ Pictorially the structure of a security descriptor is as follows: }

{       3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 }
{       1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 }
{      +---------------------------------------------------------------+ }
{      |            Control            |Reserved1 (SBZ)|   Revision    | }
{      +---------------------------------------------------------------+ }
{      |                            Owner                              | }
{      +---------------------------------------------------------------+ }
{      |                            Group                              | }
{      +---------------------------------------------------------------+ }
{      |                            Sacl                               | }
{      +---------------------------------------------------------------+ }
{      |                            Dacl                               | }
{      +---------------------------------------------------------------+ }

{ In general, this data structure should be treated opaquely to ensure future }
{ compatibility. }


type
  Security_Descriptor_Control = Word;
  pSecurity_Descriptor_Control = ^WORD;

{ Privilege Related Data Structures }

const
  { Privilege attributes }

  se_Privilege_Enabled_By_Default = $00000001;
  se_Privilege_Enabled            = $00000002;
  se_Privilege_Used_For_Access    = $80000000;

  { Privilege Set Control flags }

  Privilege_Set_All_Necessary = 1;

  {  Privilege Set - This is defined for a privilege set of one.
                   If more than one privilege is needed, then this structure
                   will need to be allocated with more space.}
  {  Note: don't change this structure without fixing the INITIAL_PRIVILEGE_SET}

type
  PPrivilegeSet = ^TPrivilegeSet;
  TPrivilegeSet = record
    PrivilegeCount: DWord;
    Control: DWord;
    Privilege: array[0..0] of TLUIDAndAttributes;
  end;

{ line 3130 }
  TSecurityImpersonationLevel = (SecurityAnonymous,
    SecurityIdentification, SecurityImpersonation, SecurityDelegation);

const
  Security_Max_Impersonation_Level     = SecurityDelegation;
  Default_Impersonation_Level     = SecurityImpersonation;

const
  Token_Assign_Primary = $0001;
  Token_Duplicate = $0002;
  Token_Impersonate = $0004;
  Token_Query = $0008;
  Token_Query_Source = $0010;
  Token_Adjust_Privileges = $0020;
  Token_Adjust_Groups = $0040;
  Token_Adjust_Default = $0080;
  Token_All_Access = (Standard_Rights_Required or Token_Assign_Primary or
    Token_Duplicate or Token_Impersonate or Token_Query or
    Token_Query_Source or Token_Adjust_Privileges or Token_Adjust_Groups or
    Token_Adjust_Default);
  Token_Read = (Standard_Rights_Read or Token_Query);
  Token_Write = (Standard_Rights_Write or Token_Adjust_Privileges or
    Token_Adjust_Groups or Token_Adjust_Default);
  Token_Execute = Standard_Rights_Execute;

type
        TTokenType = (TokenTPad, TokenPrimary, TokenImpersonation);

  TTokenInformationClass = (TokenICPad, TokenUser, TokenGroups, TokenPrivileges,
    TokenOwner, TokenPrimaryGroup, TokenDefaultDacl, TokenSource, TokenType,
    TokenImpersonationLevel, TokenStatistics);

  PTokenGroups = ^TTokenGroups;
  TTokenGroups = record
    GroupCount: DWord;
    Groups: array[0..0] of TSIDAndAttributes;
  end;

  PTokenPrivileges = ^TTokenPrivileges;
  TTokenPrivileges = record
    PrivilegeCount: DWord;
    Privileges: array[0..0] of TLUIDAndAttributes;
  end;

const
  Security_Dynamic_Tracking = True;
  Security_Static_Tracking  = False;

type
  Security_Context_Tracking_Mode = Boolean;

  PSecurityQualityOfService = ^TSecurityQualityOfService;
  TSecurityQualityOfService = record
    Length: DWord;
    ImpersonationLevel: TSecurityImpersonationLevel;
    ContextTrackingMode: SECURITY_CONTEXT_TRACKING_MODE;
    EffectiveOnly: Boolean;
  end;

  Security_Information = DWord;
  pSecurity_Information = ^DWord;

const
  Owner_Security_Information =  $00000001;
  Group_Security_Information =  $00000002;
  DACL_Security_Information  =  $00000004;
  SACL_Security_Information  =  $00000008;

const
  Image_DOS_Signature                     = $5A4D;      { MZ }
  Image_OS2_Signature                     = $454E;      { NE }
  Image_OS2_Signature_Le                  = $454C;      { LE }
  Image_VXD_Signature                     = $454C;      { LE }
  Image_NT_SIignature                     = $00004550;  { PE00 }

{ File header format. }

type
  PImageFileHeader = ^TImageFileHeader;
  TImageFileHeader = packed record
    Machine: Word;
    NumberOfSections: Word;
    TimeDateStamp: DWord;
    PointerToSymbolTable: DWord;
    NumberOfSymbols: DWord;
    SizeOfOptionalHeader: Word;
    Characteristics: Word;
  end;

const
  Image_SizeOf_File_Header                 = 20;

  Image_File_Relocs_Stripped               = $0001;  { Relocation info stripped from file. }
  Image_File_Executable_Image              = $0002;  { File is executable  (i.e. no unresolved externel references). }
  Image_File_Line_Nums_Stripped            = $0004;  { Line nunbers stripped from file. }
  Image_File_Local_Syms_Stripped           = $0008;  { Local symbols stripped from file. }
  Image_File_Aggresive_WS_Trim             = $0010;  { Agressively trim working set }
  Image_File_Bytes_Reversed_Lo             = $0080;  { Bytes of machine word are reversed. }
  Image_File_32Bit_Machine                 = $0100;  { 32 bit word machine. }
  Image_File_Debug_Stripped                = $0200;  { Debugging info stripped from file in .DBG file }
  Image_File_Removalbe_Run_From_Swap       = $0400;  { If Image is on removable media, copy and run from the swap file. }
  Image_File_Net_Run_From_Swap             = $0800;  { If Image is on Net, copy and run from the swap file. }
  Image_File_System                        = $1000;  { System File. }
  Image_File_DLL                           = $2000;  { File is a DLL. }
  Image_File_UP_System_Only                = $4000;  { File should only be run on a UP machine }
  Image_File_Bytes_Reversed_Hi             = $8000;  { Bytes of machine word are reversed. }

  Image_File_Machine_Unknown               = 0;
  Image_File_Machine_I386                  = $14c;   { Intel 386. }
  Image_File_Machine_R3000                 = $162;   { MIPS little-endian, 0x160 big-endian }
  Image_File_Machine_R4000                 = $166;   { MIPS little-endian }
  Image_File_Machine_R10000                = $168;   { MIPS little-endian }
  Image_File_Machine_Alpha                 = $184;   { Alpha_AXP }
  Image_File_Machine_PowerPC               = $1F0;   { IBM PowerPC Little-Endian }

{ Directory format. }

type
  PImageDataDirectory = ^TImageDataDirectory;
  TImageDataDirectory = record
    VirtualAddress: DWord;
    Size: DWord;
  end;

const
  Image_NumberOf_Directory_Entries        = 16;

{ Optional header format. }

type
  PimageOptionalHeader = ^TImageOptionalHeader;
  TImageOptionalHeader = packed record
    { Standard fields. }
    Magic: Word;
    MajorLinkerVersion: Byte;
    MinorLinkerVersion: Byte;
    SizeOfCode: DWord;
    SizeOfInitializedData: DWord;
    SizeOfUninitializedData: DWord;
    AddressOfEntryPoint: DWord;
    BaseOfCode: DWord;
    BaseOfData: DWord;
    { NT additional fields. }
    ImageBase: DWord;
    SectionAlignment: DWord;
    FileAlignment: DWord;
    MajorOperatingSystemVersion: Word;
    MinorOperatingSystemVersion: Word;
    MajorImageVersion: Word;
    MinorImageVersion: Word;
    MajorSubsystemVersion: Word;
    MinorSubsystemVersion: Word;
    Win32VersionValue: DWord;
    SizeOfImage: DWord;
    SizeOfHeaders: DWord;
    CheckSum: DWord;
    Subsystem: Word;
    DllCharacteristics: Word;
    SizeOfStackReserve: DWord;
    SizeOfStackCommit: DWord;
    SizeOfHeapReserve: DWord;
    SizeOfHeapCommit: DWord;
    LoaderFlags: DWord;
    NumberOfRvaAndSizes: DWord;
    DataDirectory: packed array[0..IMAGE_NUMBEROF_DIRECTORY_ENTRIES-1] of TImageDataDirectory;
  end;

  PImageRomOptionalHeader = ^TImageRomOptionalHeader;
  TImageRomOptionalHeader = packed record
    Magic: Word;
    MajorLinkerVersion: Byte;
    MinorLinkerVersion: Byte;
    SizeOfCode: DWord;
    SizeOfInitializedData: DWord;
    SizeOfUninitializedData: DWord;
    AddressOfEntryPoint: DWord;
    BaseOfCode: DWord;
    BaseOfData: DWord;
    BaseOfBss: DWord;
    GprMask: DWord;
    CprMask: packed array[0..3] of DWord;
    GpValue: DWord;
  end;

const
  Image_SizeOf_Rom_Optional_Header       = 56;
  Image_SizeOf_Std_Optional_Header       = 28;
  Image_SizeOf_NT_Optional_Header        = 224;

  Image_NT_Optional_Hdr_Magic            = $010B;
  Image_ROM_Optional_Hdr_Magic           = $0107;

type
  PImageNtHeaders = ^TImageNtHeaders;
  TImageNtHeaders = packed record
    Signature: DWord;
    FileHeader: TImageFileHeader;
    OptionalHeader: TImageOptionalHeader;
  end;

  PImageRomHeaders = ^TImageRomHeaders;
  TImageRomHeaders = packed record
    FileHeader: TImageFileHeader;
    OptionalHeader: TImageRomOptionalHeader;
  end;

{ Subsystem Values }

const
  Image_SubSystem_Unknown                  = 0;  { Unknown subsystem. }
  Image_SubSystem_Native                   = 1;  { Image doesn't require a subsystem. }
  Image_SubSystem_Windows_GUI              = 2;  { Image runs in the Windows GUI subsystem. }
  Image_SubSystem_Wubdows_CUI              = 3;  { Image runs in the Windows character subsystem. }
  Image_SubSystem_OS2_CUI                  = 5;  { image runs in the OS/2 character subsystem. }
  Image_SubSystem_Posix_CUI                = 7;  { image run  in the Posix character subsystem. }
  Image_SubSystem_Reserved8                = 8;  { image run  in the 8 subsystem. }


{ Directory Entries }

  Image_Directory_Entry_Export             = 0;  { Export Directory }
  Image_Directory_Entry_Import             = 1;  { Import Directory }
  Image_Directory_Entry_Resource           = 2;  { Resource Directory }
  Image_Directory_Entry_Exception          = 3;  { Exception Directory }
  Image_Directory_Entry_Security           = 4;  { Security Directory }
  Image_Directory_Entry_BaseReloc          = 5;  { Base Relocation Table }
  Image_Directory_Entry_Debug              = 6;  { Debug Directory }
  Image_Directory_Entry_Copyright          = 7;  { Description String }
  Image_Directory_Entry_GlobalPtr          = 8;  { Machine Value (MIPS GP) }
  Image_Directory_Entry_TLS                = 9;  { TLS Directory }
  Image_Directory_Entry_Load_Config       = 10;  { Load Configuration Directory }
  Image_Directory_Entry_Bound_Import      = 11;  { Bound Import Directory in headers }
  Image_Directory_Entry_IAT               = 12;  { Import Address Table }

{ Section header format. }

  Image_SizeOf_Short_Name                  = 8;

type
  TISHMisc = packed record
    case Integer of
      0: (PhysicalAddress: DWord);
      1: (VirtualSize: DWord);
  end;

  PImageSectionHeader = ^TImageSectionHeader;
  TImageSectionHeader = packed record
    Name: packed array[0..IMAGE_SIZEOF_SHORT_NAME-1] of Byte;
    Misc: TISHMisc;
    VirtualAddress: DWord;
    SizeOfRawData: DWord;
    PointerToRawData: DWord;
    PointerToRelocations: DWord;
    PointerToLinenumbers: DWord;
    NumberOfRelocations: Word;
    NumberOfLinenumbers: Word;
    Characteristics: DWord;
  end;

const
  Image_SizeOf_Section_Header              = 40;


{ Section characteristics. }

{      Image_Scn_Type_Reg                   0x00000000  // Reserved. }
{      Image_Scn_Type_DSect                 0x00000001  // Reserved. }
{      Image_Scn_Type_NoLoad                0x00000002  // Reserved. }
{      Image_Scn_Type_Group                 0x00000004  // Reserved. }
  Image_Scn_Type_No_Pad                    = $00000008;  { Reserved. }
{      Image_Scn_Type_Copy                  0x00000010  // Reserved. }

  Image_Scn_Cnt_Code                       = $00000020;  { Section contains code. }
  Image_Scn_Cnt_Initialized_Data           = $00000040;  { Section contains initialized data. }
  Image_Scn_Cnt_UnInitialized_Data         = $00000080;  { Section contains uninitialized data. }

  Imate_Scn_Lnk_Other                      = $00000100;  { Reserved. }
  Imate_Scn_Lnk_Info                       = $00000200;  { Section contains comments or some other type of information. }
{      IMAGE_SCN_TYPE_OVER                  0x00000400  // Reserved. }
  Imate_Scn_Lnk_Remove                     = $00000800;  { Section contents will not become part of image. }
  Imate_Scn_Lnk_Comdat                     = $00001000;  { Section contents comdat. }
{                                           0x00002000  // Reserved. }

{      Image_Scn_Mem_Protected - Obsolete   0x00004000 }
  Image_Scn_Mem_FarData                    = $00008000;
{      Image_Scn_Mem_SysHeap  - Obsolete    0x00010000 }
  Image_Scn_Mem_Pugreable                  = $00020000;
  Image_Scn_Mem_16Bit                      = $00020000;
  Image_Scn_Mem_Locked                     = $00040000;
  Image_Scn_Mem_Preload                    = $00080000;

  Image_Scn_Align_1Bytes                   = $00100000;
  Image_Scn_Align_2Bytes                   = $00200000;
  Image_Scn_Align_4Bytes                   = $00300000;
  Image_Scn_Align_8Bytes                   = $00400000;
  Image_Scn_Align_16Bytes                  = $00500000;  { Default alignment if no others are specified. }
  Image_Scn_Align_32Bytes                  = $00600000;
  Image_Scn_Align_64Bytes                  = $00700000;
{ Unused                                    0x00800000 }

  Image_Scn_Lnk_NReloc_Ovfl                = $01000000;  { Section contains extended relocations. }
  Image_Scn_Mem_Discardable                = $02000000;  { Section can be discarded. }
  Image_Scn_Mem_Not_Cached                 = $04000000;  { Section is not cachable. }
  Image_Scn_Mem_Not_Paged                  = $08000000;  { Section is not pageable. }
  Image_Scn_Mem_Shared                     = $10000000;  { Section is shareable. }
  Image_Scn_Mem_Execute                    = $20000000;  { Section is executable. }
  Image_Scn_Mem_Read                       = $40000000;  { Section is readable. }
  Image_Scn_Mem_Write                      = $80000000;  { Section is writeable. }


type
  PImageLoadConfigDirectory = ^TImageLoadConfigDirectory;
  TImageLoadConfigDirectory = packed record
    Characteristics: DWord;
    TimeDateStamp: DWord;
    MajorVersion: Word;
    MinorVersion: Word;
    GlobalFlagsClear: DWord;
    GlobalFlagsSet: DWord;
    CriticalSectionDefaultTimeout: DWord;
    DeCommitFreeBlockThreshold: DWord;
    DeCommitTotalFreeThreshold: DWord;
    LockPrefixTable: Pointer;
    MaximumAllocationSize: DWord;
    VirtualMemoryThreshold: DWord;
    ProcessHeapFlags: DWord;
    ProcessAffinityMask: DWord;
    Reserved: array[0..2] of DWord;
  end;

// Function table entry format for MIPS/ALPHA images.  Function table is
// pointed to by the IMAGE_DIRECTORY_ENTRY_EXCEPTION directory entry.
// This definition duplicates ones in ntmips.h and ntalpha.h for use
// by portable image file mungers.

  PImageRuntimeFunctionEntry = ^TImageRuntimeFunctionEntry;
  TImageRuntimeFunctionEntry = record
    BeginAddress: DWord;
    EndAddress: DWord;
    ExceptionHandler: Pointer;
    HandlerData: Pointer;
    PrologEndAddress: DWord;
  end;

//
// Debug Format
//

  PImageDebugDirectory = ^TImageDebugDirectory;
  TImageDebugDirectory = packed record
    Characteristics: DWord;
    TimeDateStamp: DWord;
    MajorVersion: Word;
    MinorVersion: Word;
    _Type: DWord;
    SizeOfData: DWord;
    AddressOfRawData: DWord;
    PointerToRawData: DWord;
  end;

const
  Image_Debug_Type_Unknown          = 0;
  Image_Debug_Type_COff             = 1;
  Image_Debug_Type_Codeview         = 2;
  Image_Debug_Type_FPO              = 3;
  Image_Debug_Type_Misc             = 4;
  Image_Debug_Type_Exception        = 5;
  Image_Debug_Type_Fixup            = 6;
  Image_Debug_Type_OMap_To_Src      = 7;
  Image_Debug_Type_OMap_From_Src    = 8;

type
  PImageCOFFSymbolsHeader = ^TImageCOFFSymbolsHeader;
  TImageCOFFSymbolsHeader = record
    NumberOfSymbols: DWord;
    LvaToFirstSymbol: DWord;
    NumberOfLinenumbers: DWord;
    LvaToFirstLinenumber: DWord;
    RvaToFirstByteOfCode: DWord;
    RvaToLastByteOfCode: DWord;
    RvaToFirstByteOfData: DWord;
    RvaToLastByteOfData: DWord;
  end;

const
  Frame_FPO       = 0;
  Frame_Trap      = 1;
  Frame_TSS       = 2;
  Frame_NonFPO    = 3;

type
  PFpoData = ^TFpoData;
  TFpoData = packed record
    ulOffStart: DWord;             // offset 1st byte of function code
    cbProcSize: DWord;             // # bytes in function
    cdwLocals: DWord;              // # bytes in locals/4
    cdwParams: Word;              // # bytes in params/4
{    WORD        cbProlog : 8;           // # bytes in prolog
     WORD        cbRegs   : 3;           // # regs saved
     WORD        fHasSEH  : 1;           // TRUE if SEH in func
     WORD        fUseBP   : 1;           // TRUE if EBP has been allocated
     WORD        reserved : 1;           // reserved for future use
     WORD        cbFrame  : 2;}           // frame type
     cbProlog: Byte;
     OtherStuff: Byte;
  end;

const
  SizeOf_RFPO_Data         = 16;
  Image_Debug_Misc_ExeName = 1;

type
  PImageDebugMisc = ^TImageDebugMisc;
  TImageDebugMisc = packed record
    DataType: DWord;               // type of misc data, see defines
    Length: DWord;                 // total length of record, rounded to four
                                   // byte multiple.
    Unicode: ByteBool;             // TRUE if data is unicode string
    Reserved: array[0..2] of Byte;
    Data: array[0..0] of Byte;     // Actual data
  end;

//
// Function table extracted from MIPS/ALPHA images.  Does not contain
// information needed only for runtime support.  Just those fields for
// each entry needed by a debugger.
//
  PImageFunctionEntry = ^TImageFunctionEntry;
  TImageFunctionEntry = record
    StartingAddress: DWord;
    EndingAddress: DWord;
    EndOfPrologue: DWord;
  end;

const
  rtl_CritSect_Type = 0;
  rtl_Resource_Type = 1;


  DLL_Thread_Attach = 2;
  DLL_Thread_Detach = 3;

  { Registry Open/Create Options }

  reg_Option_Reserved     = $00000000;    { Parameter is reserved }

  reg_Option_Create_Link  = $00000002;    { Created key is a }
                                            { symbolic link }

  reg_Option_Backup_Restore = $00000004;  { open for backup or restore }
                                            { special access rules }
                                            { privilege required   }

  reg_Legal_Option  = (reg_Option_Reserved or
                       reg_Option_Non_Volatile or
                       reg_Option_Volatile or
                       reg_Option_Create_Link or
                       reg_Option_Backup_Restore);

  { Registry Key restore flags }

  reg_Whole_Hive_Volatile = $00000001;    { Restore whole hive volatile }
  reg_Refresh_Hive        = $00000002;    { Unwind changes to last flush }

  { Registry Notify filter values }

  reg_Notify_Change_Name       = $00000001; { Create or delete (child) }
  reg_Notify_Change_Attributes = $00000002;
  reg_Notify_Change_Last_Set   = $00000004; { time stamp }
  reg_Notify_Change_Security   = $00000008;

  reg_Legal_Change_Filter = (reg_Option_Reserved or
                             reg_Notify_Change_Name or
                             reg_Notify_Change_Attributes or
                             reg_Notify_Change_Last_Set or
                             reg_Notify_Change_Security);

  { Registry Predefined Value Types }

  reg_Full_Resource_Descriptor = 9;
  reg_Resource_Requirements_List = 10;

{ END Translated from WINNT.H }

function MakeWord(A,B: Byte): SmallWord;
function MakeLong(A,B: SmallWord): Longint;
function HiWord(L: Longint): SmallWord;
function HiByte(W: SmallWord): Byte;

type
  hColorSpace = Integer;
  hGlRc = Integer;
  hDesk = Integer;
  hTask = Integer;
  hWinSta = Integer;
  hKl = Integer;

  ColorRef = DWord;

{ Compatiblity functions and procedures }

function DefineHandleTable(Offset: Word): Bool; inline;
begin
  Result := True;
end;

procedure LimitEmsPages(Kbytes: Longint); inline;
begin
end;

function SetSwapAreaSize(Size: Word): Longint; inline;
begin
  Result := Size;
end;

function CreateWindow(lpClassName: PChar; lpWindowName: PChar;
  dwStyle: DWord; X, Y, nWidth, nHeight: Integer; hWndParent: hWnd;
  hMenu: hMenu; hInstance: hInst; lpParam: Pointer): hWnd;

function Yield: Bool; inline;
begin
  Result := True;
end;


const
  Invalid_File_Size = DWord($FFFFFFFF);


  Time_Zone_Id_Invalid = DWord($FFFFFFFF);



  Wait_IO_Completion = Status_User_APC;
  Exception_Access_Violation = Status_Access_Violation;
  Exception_Datatype_Misalignment = Status_Datatype_Misalignment;
  Exception_Breakpoint = Status_Breakpoint;
  Exception_Single_Step = Status_Single_Step;
  Exception_Array_Bounds_Exceeded = Status_Array_Bounds_Exceeded;
  Exception_Flt_Denormal_Operand = Status_Float_Denormal_Operand;
  Exception_Flt_Divide_By_Zero = Status_Float_Divide_By_Zero;
  Exception_Flt_Inexact_Result = Status_Float_Inexact_Result;
  Exception_Flt_Invalid_Operation = Status_Float_Invalid_Operation;
  Exception_Flt_Overflow = Status_Float_Overflow;
  Exception_Flt_Stack_Check = Status_Float_Stack_Check;
  Exception_Flt_Underflow = Status_Float_Underflow;
  Exception_Int_Divide_By_Zero = Status_Integer_Divide_By_Zero;
  Exception_Int_Overflow = Status_Integer_Overflow;
  Exception_Priv_Instruction = Status_Privileged_Instruction;
  Exception_In_Page_Error = Status_In_Page_Error;
  Exception_Illegal_Instruction = Status_Illegal_Instruction;
  Exception_NonContinuable_Exception = Status_NonContinuable_Exception;
  Exception_Stack_Overflow = Status_Stack_Overflow;
  Exception_Invalid_Disposition = Status_Invalid_Disposition;
  Exception_Guard_Page = Status_Guard_Page_Violation;
  Exception_Invalid_Handle = Status_Invalid_Handle;
  CONTROL_C_EXIT = STATUS_CONTROL_C_EXIT;

procedure MoveMemory(Destination: Pointer; Source: Pointer; Length: DWord);
procedure CopyMemory(Destination: Pointer; Source: Pointer; Length: DWord);
procedure FillMemory(Destination: Pointer; Length: DWord; Fill: Byte);

const

{ Define possible return codes from the CopyFileEx callback routine }

  Progress_Continue = 0;
  Progress_Cancel = 1;
  Progress_Stop = 2;
  Progress_Quiet = 3;


{ Define CopyFileEx callback routine state change values }

  Callback_Chunk_Finished = $00000000;
  Callback_Stream_Switch = $00000001;


{ Define CopyFileEx option flags }

  Copy_File_Fail_If_Exists = $00000001;
  Copy_File_Restartable = $00000002;


{ Define the NamedPipe definitions}

  { Define the dwOpenMode values for CreateNamedPipe }

  Pipe_Access_Inbound = 1;
  Pipe_Access_Outbound = 2;
  Pipe_Access_Duplex = 3;

  { Define the Named Pipe End flags for GetNamedPipeInfo }

  Pipe_Client_End = 0;
  Pipe_Server_End = 1;

  { Define the dwPipeMode values for CreateNamedPipe }

  Pipe_Wait = 0;
  Pipe_NoWait = 1;
  Pipe_ReadMode_Byte = 0;
  Pipe_ReadMode_Message = 2;
  Pipe_Type_Byte = 0;
  Pipe_Type_Message = 4;

  { Define the well known values for CreateNamedPipe nMaxInstances }

  Pipe_Unlimited_Instances = 255;

  { Define the Security Quality of Service bits to be passed into CreateFile }

  Security_Anonymous = (Ord(SecurityAnonymous) shl 16);
  Security_Identification = (Ord(SecurityIdentification) shl 16);
  Security_Impersonation = (Ord(SecurityImpersonation) shl 16);
  Security_Delegation = (Ord(SecurityDelegation) shl 16);

  Security_Context_Tracking = $40000;
  Security_Effective_Only = $80000;

  Security_SQOS_Present = $100000;
  Security_Valid_SQOS_Flags = $1F0000;

{ File structures }

type
  TFNFiberStartRoutine = TFarProc;

const
  Mutex_Modify_State = Mutant_Query_State;

  { Serial provider type. }

  sp_SerialComm = $00000001;

  { Provider SubTypes }

  pst_Unspecified = $00000000;
  pst_RS232 = $00000001;
  pst_Parallelport = $00000002;
  pst_RS422 = $00000003;
  pst_RS423 = $00000004;
  pst_RS449 = $00000005;
  pst_Modem = $00000006;
  pst_Fax = $00000021;
  pst_Scanner = $00000022;
  pst_Network_Bridge = $00000100;
  pst_LAT = $00000101;
  pst_TCPIP_Telnet = $00000102;
  pst_X25 = $00000103;

  { Provider capabilities flags. }

  pcf_DtrDsr = $0001;
  pcf_RtsCts = $0002;
  pcf_RLSD = $0004;
  pcf_Parity_Check = $0008;
  pcf_XonXoff = $0010;
  pcf_SetXChar = $0020;
  pcf_TotalTimeouts = $0040;
  pcf_IntTimeouts = $0080;
  pcf_SpecialChars = $0100;
  pcf_16BitMode = $0200;

  { Comm provider settable parameters. }

  sp_Parity = $0001;
  sp_Baud = $0002;
  sp_DataBits = $0004;
  sp_StopBits = $0008;
  sp_Handshaking = $0010;
  sp_Parity_Check = $0020;
  sp_RLSD = $0040;

  { Settable baud rates in the provider. }

  Baud_075 = $00000001;
  Baud_110 = $00000002;
  Baud_134_5 = $00000004;
  Baud_150 = $00000008;
  Baud_300 = $00000010;
  Baud_600 = $00000020;
  Baud_1200 = $00000040;
  Baud_1800 = $00000080;
  Baud_2400 = $00000100;
  Baud_4800 = $00000200;
  Baud_7200 = $00000400;
  Baud_9600 = $00000800;
  Baud_14400 = $00001000;
  Baud_19200 = $00002000;
  Baud_38400 = $00004000;
  Baud_56K = $00008000;
  Baud_128K = $00010000;
  Baud_115200 = $00020000;
  Baud_57600 = $00040000;
  Baud_User = $10000000;

  { Settable Data Bits }

  DataBits_5 = $0001;
  DataBits_6 = $0002;
  DataBits_7 = $0004;
  DataBits_8 = $0008;
  DataBits_16 = $0010;
  DataBits_16X = $0020;

  { Settable Stop and Parity bits. }

  StopBits_10 = $0001;
  StopBits_15 = $0002;
  StopBits_20 = $0004;
  Parity_None = $0100;
  Parity_Odd = $0200;
  Parity_Even = $0400;
  Parity_Mark = $0800;
  Parity_Space = $1000;

type
  PCommProp = ^TCommProp;
  TCommProp = record
    wPacketLength: Word;
    wPacketVersion: Word;
    dwServiceMask: DWord;
    dwReserved1: DWord;
    dwMaxTxQueue: DWord;
    dwMaxRxQueue: DWord;
    dwMaxBaud: DWord;
    dwProvSubType: DWord;
    dwProvCapabilities: DWord;
    dwSettableParams: DWord;
    dwSettableBaud: DWord;
    wSettableData: Word;
    wSettableStopParity: Word;
    dwCurrentTxQueue: DWord;
    dwCurrentRxQueue: DWord;
    dwProvSpec1: DWord;
    dwProvSpec2: DWord;
    wcProvChar: array[0..0] of WCHAR;
  end;

  { Set dwProvSpec1 to COMMPROP_INITIALIZED to indicate that wPacketLength
    is valid before a call to GetCommProperties(). }
const
  CommProp_Initialized = $E73CF52E;

type
  TComStateFlag = (fCtlHold, fDsrHold, fRlsHold, fXoffHold, fXOffSent, fEof,
    fTxim);
  TComStateFlags = set of TComStateFlag;
  TComStat = packed record
    Flags: TComStateFlags;
    Reserved: array[0..2] of Byte;
    cbInQue: DWord;
    cbOutQue: DWord;
  end;
  PComStat = ^TComStat;

const
  { DTR Control Flow Values. }
  dtr_Control_Disable = 0;
  dtr_Control_Enable = 1;
  dtr_Control_Handshake = 2;

  { RTS Control Flow Values}
  rts_Control_Disable = 0;
  rts_Control_Enable = 1;
  rts_Control_Handshake = 2;
  rts_Control_Toggle = 3;

type
  tDCB = packed record
    DCBlength: DWord;
    BaudRate: DWord;
    Flags: Longint;
    wReserved: Word;
    XonLim: Word;
    XoffLim: Word;
    ByteSize: Byte;
    Parity: Byte;
    StopBits: Byte;
    XonChar: CHAR;
    XoffChar: CHAR;
    ErrorChar: CHAR;
    EofChar: CHAR;
    EvtChar: CHAR;
    wReserved1: Word;
  end;
  pDCB = ^tDCB;

  PCommTimeouts = ^TCommTimeouts;
  TCommTimeouts = record
    ReadIntervalTimeout: DWord;
    ReadTotalTimeoutMultiplier: DWord;
    ReadTotalTimeoutConstant: DWord;
    WriteTotalTimeoutMultiplier: DWord;
    WriteTotalTimeoutConstant: DWord;
  end;

  PCommConfig = ^TCommConfig;
  TCommConfig = record
    dwSize: DWord;
    wVersion: Word;
    wReserved: Word;
    dcb: TDCB;
    dwProviderSubType: DWord;
    dwProviderOffset: DWord;
    dwProviderSize: DWord;
    wcProviderData: array[0..0] of WCHAR;
  end;

  PSystemInfo = ^TSystemInfo;
  TSystemInfo = record
    case Integer of
      0: (
        dwOemId: DWord);
      1: (
        wProcessorArchitecture: Word;
        wReserved: Word;
        dwPageSize: DWord;
        lpMinimumApplicationAddress: Pointer;
        lpMaximumApplicationAddress: Pointer;
        dwActiveProcessorMask: DWord;
        dwNumberOfProcessors: DWord;
        dwProcessorType: DWord;
        dwAllocationGranularity: DWord;
        wProcessorLevel: Word;
        wProcessorRevision: Word);
  end;

function FreeModule(var hLibModule: hInst): Bool; inline;
begin
  Result := FreeLibrary(hLibModule);
end;

function MakeProcInstance(Proc: TFarProc; Instance: THandle): TFarProc; inline;
begin
  Result := Proc;
end;

procedure FreeProcInstance(Proc: TFarProc); inline;
begin
end;

const
  { Global Memory Flags }

  GMEM_VALID_FLAGS = $7F72;

function GlobalLRUNewest(h: THandle): THandle; inline;
begin
  Result := h;
end;

function GlobalLRUOldest(h: THandle): THandle; inline;
begin
  Result := h;
end;

function GlobalAllocPtr(Flags: Integer; Bytes: Longint): Pointer;
function GlobalReAllocPtr(P: Pointer; Bytes: Longint; Flags: Integer): Pointer;
function GlobalFreePtr(P: Pointer): THandle;

const
  Create_Shared_WOW_VDM           = $00001000;
  Create_ForceDOS                 = $00002000;

  Profile_User                    = $10000000;
  Profile_Kernel                  = $20000000;
  Profile_Server                  = $40000000;

{ Debug APIs }

  Exception_Debug_Event = 1;
  Create_Thread_Debug_Event = 2;
  Create_Process_Debug_Event = 3;
  Exit_Thread_Debug_Event = 4;
  Exit_Process_Debug_Event = 5;
  Load_DLL_Debug_Event = 6;
  Unload_DLL_Debug_Event = 7;
  Output_Debug_String_Event = 8;
  RIP_Event = 9;

type
  PExceptionDebugInfo = ^TExceptionDebugInfo;
  TExceptionDebugInfo = record
    ExceptionRecord: TExceptionRecord;
    dwFirstChance: DWord;
  end;

  PCreateThreadDebugInfo = ^TCreateThreadDebugInfo;
  TCreateThreadDebugInfo = record
    hThread: THandle;
    lpThreadLocalBase: Pointer;
    lpStartAddress: TFNThreadStartRoutine;
  end;

  PCreateProcessDebugInfo = ^TCreateProcessDebugInfo;
  TCreateProcessDebugInfo = record
    hFile: THandle;
    hProcess: THandle;
    hThread: THandle;
    lpBaseOfImage: Pointer;
    dwDebugInfoFileOffset: DWord;
    nDebugInfoSize: DWord;
    lpThreadLocalBase: Pointer;
    lpStartAddress: TFNThreadStartRoutine;
    lpImageName: Pointer;
    fUnicode: Word;
  end;

  PExitThreadDebugInfo = ^TExitThreadDebugInfo;
  TExitThreadDebugInfo = record
    dwExitCode: DWord;
  end;

  PExitProcessDebugInfo = ^TExitProcessDebugInfo;
  TExitProcessDebugInfo = record
    dwExitCode: DWord;
  end;

  PLoadDLLDebugInfo = ^TLoadDLLDebugInfo;
  TLoadDLLDebugInfo = record
    hFile: THandle;
    lpBaseOfDll: Pointer;
    dwDebugInfoFileOffset: DWord;
    nDebugInfoSize: DWord;
    lpImageName: Pointer;
    fUnicode: Word;
  end;

  PUnloadDLLDebugInfo = ^TUnloadDLLDebugInfo;
  TUnloadDLLDebugInfo = record
    lpBaseOfDll: Pointer;
  end;

  POutputDebugStringInfo = ^TOutputDebugStringInfo;
  TOutputDebugStringInfo = record
    lpDebugStringData: LPSTR;
    fUnicode: Word;
    nDebugStringLength: Word;
  end;

  PRIPInfo = ^TRIPInfo;
  TRIPInfo = record
    dwError: DWord;
    dwType: DWord;
  end;

  PDebugEvent = ^TDebugEvent;
  TDebugEvent = record
    dwDebugEventCode: DWord;
    dwProcessId: DWord;
    dwThreadId: DWord;
    case Integer of
      0: (Exception: TExceptionDebugInfo);
      1: (CreateThread: TCreateThreadDebugInfo);
      2: (CreateProcessInfo: TCreateProcessDebugInfo);
      3: (ExitThread: TExitThreadDebugInfo);
      4: (ExitProcess: TExitThreadDebugInfo);
      5: (LoadDll: TLoadDLLDebugInfo);
      6: (UnloadDll: TUnloadDLLDebugInfo);
      7: (DebugString: TOutputDebugStringInfo);
      8: (RipInfo: TRIPInfo);
  end;

function GetFreeSpace(w: Word): DWord; inline;
begin
  Result := $100000;
end;

const
  NoParity = 0;
  OddParity = 1;
  EvenParity = 2;
  MarkParity = 3;
  SpaceParity = 4;

  OneStopbit = 0;
  One5StopBits = 1;
  TwoStopBits = 2;

  Ignore = 0;               { Ignore signal }

  { Baud rates at which the communication device operates }

  cbr_110 = 110;
  cbr_300 = 300;
  cbr_600 = 600;
  cbr_1200 = 1200;
  cbr_2400 = 2400;
  cbr_4800 = 4800;
  cbr_9600 = 9600;
  cbr_14400 = 14400;
  cbr_19200 = 19200;
  cbr_38400 = 38400;
  cbr_56000 = 56000;
  cbr_57600 = 57600;
  cbr_115200 = $1C200;
  cbr_128000 = $1F400;
  cbr_256000 = $3E800;

  { Error Flags }

  ce_RxOver = 1;        { Receive Queue overflow }
  ce_Overrun = 2;       { Receive Overrun Error }
  ce_RxParity = 4;      { Receive Parity Error }
  ce_Frame = 8;         { Receive Framing error }
  ce_Break = $10;       { Break Detected }
  ce_TxFull = $100;     { TX Queue is full }
  ce_PTO = $200;        { LPTx Timeout }
  ce_IOE = $400;        { LPTx I/O Error }
  ce_DNS = $800;        { LPTx Device not selected }
  ce_OOP = $1000;       { LPTx Out-Of-Paper }
  ce_Mode = $8000;      { Requested mode unsupported }

  ie_BadId = -1;        { Invalid or unsupported id }
  ie_Open = -2;         { Device Already Open }
  ie_NOpen = -3;        { Device Not Open }
  ie_Memory = -4;       { Unable to allocate queues }
  ie_Default = -5;      { Error in default parameters }
  ie_Hardware = -10;    { Hardware Not Present }
  ie_ByteSize = -11;    { Illegal Byte Size }
  ie_Baudrate = -12;    { Unsupported BaudRate }

  { Events }

  ev_RxChar = 1;        { Any Character received }
  ev_RxFlag = 2;        { Received certain character }
  ev_TxEmpty = 4;       { Transmitt Queue Empty }
  ev_CTS = 8;           { CTS changed state }
  ev_DSR = $10;         { DSR changed state }
  ev_RLSD = $20;        { RLSD changed state }
  ev_Break = $40;       { BREAK received }
  ev_Err = $80;         { Line status error occurred }
  ev_Ring = $100;       { Ring signal detected }
  ev_PErr = $200;       { Printer error occured }
  ev_Rx80Full = $400;   { Receive buffer is 80 percent full }
  ev_Event1 = $800;     { Provider specific event 1 }
  ev_Event2 = $1000;    { Provider specific event 2 }

  { Escape functions }

  SetXOff = 1;    { Simulate XOFF received }
  SetXOn = 2;     { Simulate XON received }
  SetRTS = 3;     { Set RTS high }
  ClrRTS = 4;     { Set RTS low }
  SetDTR = 5;     { Set DTR high }
  ClrDTR = 6;     { Set DTR low }
  ResetDev = 7;   { Reset device if possible }
  SetBreak = 8;   { Set the device break line. }
  ClrBreak = 9;   { Clear the device break line. }

  { PURGE function flags. }

  Purge_TxAbort = 1;     { Kill the pending/current writes to the comm port. }
  Purge_RxAbort = 2;     { Kill the pending/current reads to the comm port. }
  Purge_TxClear = 4;     { Kill the transmit queue if there. }
  Purge_RxClear = 8;     { Kill the typeahead buffer if there. }

  LPTx = $80;     { Set if ID is for LPT device }

  { Modem Status Flags }

  ms_CTS_ON = DWord($0010);
  ms_DSR_ON = DWord($0020);
  ms_Ring_ON = DWord($0040);
  ms_RLSD_ON = DWord($0080);

  { WaitSoundState() Constants }

  s_QueueEmpty = 0;
  s_Threshold = 1;
  s_AllThreshold = 2;

  { Accent Modes }

  s_Normal = 0;
  s_Legato = 1;
  s_Staccato = 2;

  { SetSoundNoise() Sources }

  s_Period512 = 0;     { Freq = N/512 high pitch, less coarse hiss }
  s_Period1024 = 1;    { Freq = N/1024 }
  s_Period2048 = 2;    { Freq = N/2048 low pitch, more coarse hiss }
  s_PeriodVoice = 3;   { Source is frequency from voice channel (3) }
  s_White512 = 4;      { Freq = N/512 high pitch, less coarse hiss }
  s_White1024 = 5;     { Freq = N/1024 }
  s_White2048 = 6;     { Freq = N/2048 low pitch, more coarse hiss }
  s_WhiteVoice = 7;    { Source is frequency from voice channel (3) }

  s_serDvNa = -1;     { Device not available  }
  s_serOFM = -2;      { Out of memory }
  s_serMAct = -3;     { Music active }
  s_serQFul = -4;     { Queue full }
  s_serBdNt = -5;     { Invalid note }
  s_serDLN = -6;      { Invalid note length }
  s_serDCC = -7;      { Invalid note count }
  s_serDTP = -8;      { Invalid tempo }
  s_serDVL = -9;      { Invalid volume }
  s_serDMD = -10;     { Invalid mode }
  s_serDSH = -11;     { Invalid shape }
  s_serDPT = -12;     { Invalid pitch }
  s_serDFQ = -13;     { Invalid frequency }
  s_serDDR = -14;     { Invalid duration }
  s_serDSR = -15;     { Invalid source }
  s_serDST = -16;     { Invalid state }

  nmpwait_Wait_Forever = $FFFFFFFF;
  nmpwait_NoWait = 1;
  nmpwait_Use_Default_Wait = 0;

  fs_Persistent_ACLs = file_Persistent_ACLs;
  fs_Vol_is_Compressed = file_Volume_is_Compressed;
  fs_File_Compression = file_File_Compression;

  file_Map_Copy = Section_Query;
  file_Map_Write = Section_Map_Write;
  file_Map_Read = Section_Map_Read;
  file_Map_All_Access = Section_All_Access;

const
  MaxintAtom = $C000;
  Invalid_Atom = 0;

procedure FreeLibraryAndExitThread(hLibModule: hModule; dwExitCode: DWord);
function DisableThreadLibraryCalls(hLibModule: hModule): Bool;
function GetVersion: DWord;
function GlobalCompact(dwMinFree: DWord): UInt;
procedure GlobalFix(hMem: HGLOBAL);
procedure GlobalUnfix(hMem: HGLOBAL);
function GlobalWire(hMem: HGLOBAL): Pointer;
function GlobalUnWire(hMem: HGLOBAL): Bool;
function LocalShrink(hMem: HLOCAL; cbNewSize: UInt): UInt;
function LocalCompact(uMinFree: UInt): UInt;
function FlushInstructionCache(hProcess: THandle;
  const lpBaseAddress: Pointer; dwSize: DWord): Bool;
function VirtualAlloc(lpvAddress: Pointer;
  dwSize, flAllocationType, flProtect: DWord): Pointer;
function VirtualFree(lpAddress: Pointer; dwSize, dwFreeType: DWord): Bool;
function VirtualProtect(lpAddress: Pointer; dwSize, flNewProtect: DWord;
  lpflOldProtect: Pointer): Bool;
function VirtualQuery(lpAddress: Pointer;
  var lpBuffer: TMemoryBasicInformation; dwLength: DWord): DWord;
function VirtualAllocEx(hProcess: THandle; lpAddress: Pointer;
  dwSize, flAllocationType: DWord; flProtect: DWord): Pointer;
function VirtualFreeEx(hProcess: THandle; lpAddress: Pointer;
        dwSize, dwFreeType: DWord): Pointer;
function VirtualProtectEx(hProcess: THandle; lpAddress: Pointer;
  dwSize, flNewProtect: DWord; lpflOldProtect: Pointer): Bool;
function VirtualQueryEx(hProcess: THandle; lpAddress: Pointer;
  var lpBuffer: TMemoryBasicInformation; dwLength: DWord): DWord;
function HeapValidate(hHeap: THandle; dwFlags: DWord; lpMem: Pointer): Bool;
function HeapCompact(hHeap: THandle; dwFlags: DWord): UInt;
function GetProcessHeap: THandle;
function GetProcessHeaps(NumberOfHeaps: DWord; var ProcessHeaps: THandle): DWord;

procedure LockSegment(Segment: THandle); inline;
begin
  GlobalFix(Segment);
end;

procedure UnlockSegment(Segment: THandle); inline;
begin
  GlobalUnfix(Segment);
end;

type
  PProcessHeapEntry = ^TProcessHeapEntry;
  TProcessHeapEntry = record
    lpData: Pointer;
    cbData: DWord;
    cbOverhead: Byte;
    iRegionIndex: Byte;
    wFlags: Word;
    case Integer of
      0: (
        hMem: THandle);
      1: (
        dwCommittedSize: DWord;
        dwUnCommittedSize: DWord;
        lpFirstBlock: Pointer;
        lpLastBlock: Pointer);
  end;

const
  Process_Heap_Region = 1;
  Process_Heap_Uncommitted_Range = 2;
  Process_Heap_Entry_Busy = 4;
  Process_Heap_Entry_Moveable = $10;
  Process_Heap_Entry_DDEShare = $20;

function HeapLock(hHeap: THandle): Bool;
function HeapUnlock(hHeap: THandle): Bool;
function HeapWalk(hHeap: THandle; var lpEntry: TProcessHeapEntry): Bool;


{ GetBinaryType return values.}

const
  scs_32Bit_Binary = 0;
  scs_DOS_Binary = 1;
  scs_WOW_Binary = 2;
  scs_PIF_Binary = 3;
  scs_Poxix_Binary = 4;
  scs_OS216_Binary = 5;

function GetBinaryType(lpApplicationName: PChar; var lpBinaryType: DWord): Bool;
function GetShortPathName(lpszLongPath: PChar; lpszShortPath: PChar;
  cchBuffer: DWord): DWord;
function GetProcessAffinityMask(hProcess: THandle;
  var lpProcessAffinityMask, lpSystemAffinityMask: DWord): Bool;
function SetProcessAffinityMask(hProcess: THandle;
  dwProcessAffinityMask: DWord): Bool;
function GetProcessTimes(hProcess: THandle;
  var lpCreationTime, lpExitTime, lpKernelTime, lpUserTime: TFileTime): Bool;
function GetProcessWorkingSetSize(hProcess: THandle;
  var lpMinimumWorkingSetSize, lpMaximumWorkingSetSize: DWord): Bool;
function SetProcessWorkingSetSize(hProcess: THandle;
  dwMinimumWorkingSetSize, dwMaximumWorkingSetSize: DWord): Bool;
function FreeEnvironmentStrings(P1: PChar): Bool;
procedure RaiseException(dwExceptionCode, dwExceptionFlags, nNumberOfArguments: DWord;
  lpArguments: PDWORD);
function UnhandledExceptionFilter(const ExceptionInfo: TExceptionPointers): Longint;
function CreateFiber(dwStackSize: DWord; lpStartAddress: TFNFiberStartRoutine;
  lpParameter: Pointer): Bool;
function DeleteFiber(lpFiber: Pointer): Bool;
function ConvertThreadToFiber(lpParameter: Pointer): Bool;
function SwitchToFiber(lpFiber: Pointer): Bool;
function SwitchToThread: Bool;

type
  TFNTopLevelExceptionFilter = TFarProc;

function SetUnhandledExceptionFilter(lpTopLevelExceptionFilter: TFNTopLevelExceptionFilter):
  TFNTopLevelExceptionFilter;
function CreateRemoteThread(hProcess: THandle; lpThreadAttributes: Pointer;
  dwStackSize: DWord; lpStartAddress: TFNThreadStartRoutine; lpParameter: Pointer;
  dwCreationFlags: DWord; var lpThreadId: DWord): THandle;
function SetThreadAffinityMask(hThread: THandle; dwThreadAffinityMask: DWord): DWord;
function SetThreadIdealProcessor(hThread: THandle; dwIdealProcessor: DWord): Bool;
function SetProcessPriorityBoost(hThread: THandle; DisablePriorityBoost: Bool): Bool;
function GetProcessPriorityBoost(hThread: THandle; var DisablePriorityBoost: Bool): Bool;
function SetThreadPriorityBoost(hThread: THandle; DisablePriorityBoost: Bool): Bool;
function GetThreadPriorityBoost(hThread: THandle; var DisablePriorityBoost: Bool): Bool;
function GetThreadTimes(hThread: THandle;
  var lpCreationTime, lpExitTime, lpKernelTime, lpUserTime: TFileTime): Bool;
function GetThreadSelectorEntry(hThread: THandle; dwSelector: DWord;
  var lpSelectorEntry: TLDTEntry): Bool;
function CreateIoCompletionPort(FileHandle, ExistingCompletionPort: THandle;
  CompletionKey, NumberOfConcurrentThreads: DWord): THandle;
function GetQueuedCompletionStatus(CompletionPort: THandle;
  var lpNumberOfBytesTransferred, lpCompletionKey: DWord;
  var lpOverlapped: POverlapped; dwMilliseconds: DWord): Bool;
function PostQueuedCompletionStatus(CompletionPort: THandle; dwNumberOfBytesTransferred: DWord;
  dwCompletionKey: DWord; lpOverlapped: POverlapped): Bool;
function SetErrorMode(uMode: UInt): UInt;
function ReadProcessMemory(hProcess: THandle; const lpBaseAddress: Pointer; lpBuffer: Pointer;
  nSize: DWord; var lpNumberOfBytesRead: DWord): Bool;
function WriteProcessMemory(hProcess: THandle; const lpBaseAddress: Pointer; lpBuffer: Pointer;
  nSize: DWord; var lpNumberOfBytesWritten: DWord): Bool;
function GetThreadContext(hThread: THandle; var lpContext: TContext): Bool;
function SetThreadContext(hThread: THandle; const lpContext: TContext): Bool;

type
  TFNAPCProc = TFarProc;

function QueueUserAPC(pfnAPC: TFNAPCProc; hThread: THandle; dwData: DWord): Bool;
procedure DebugBreak;
function WaitForDebugEvent(var lpDebugEvent: TDebugEvent; dwMilliseconds: DWord): Bool;
function ContinueDebugEvent(dwProcessId, dwThreadId, dwContinueStatus: DWord): Bool;
function DebugActiveProcess(dwProcessId: DWord): Bool;
function TryEnterCriticalSection(var lpCriticalSection: TRTLCriticalSection): Bool;
function LockFileEx(hFile: THandle; dwFlags, dwReserved: DWord;
  nNumberOfBytesToLockLow, nNumberOfBytesToLockHigh: DWord;
  const lpOverlapped: TOverlapped): Bool;

const
  Lockfile_Fail_Immediately = 1;
  Lockfile_Exclusive_Lock = 2;

function UnlockFileEx(hFile: THandle; dwReserved, nNumberOfBytesToUnlockLow: DWord;
  nNumberOfBytesToUnlockHigh: DWord; const lpOverlapped: TOverlapped): Bool;

function DeviceIoControl(hDevice: THandle; dwIoControlCode: DWord; lpInBuffer: Pointer;
  nInBufferSize: DWord; lpOutBuffer: Pointer; nOutBufferSize: DWord;
  var lpBytesReturned: DWord; lpOverlapped: POverlapped): Bool;
function GetHandleInformation(hObject: THandle; var lpdwFlags: DWord): Bool;
function SetHandleInformation(hObject: THandle; dwMask: DWord; dwFlags: DWord): Bool;

const
  Handle_Flag_Inherit = 1;
  Handle_Flag_Protect_From_Close = 2;

function ClearCommBreak(hFile: THandle): Bool;
function ClearCommError(hFile: THandle; var lpErrors: DWord; lpStat: PComStat): Bool;
function SetupComm(hFile: THandle; dwInQueue, dwOutQueue: DWord): Bool;
function EscapeCommFunction(hFile: THandle; dwFunc: DWord): Bool;
function GetCommConfig(hCommDev: THandle; var lpCC: TCommConfig; var lpdwSize: DWord): Bool;
function GetCommMask(hFile: THandle; var lpEvtMask: DWord): Bool;
function GetCommProperties(hFile: THandle; var lpCommProp: TCommProp): Bool;
function GetCommModemStatus(hFile: THandle; var lpModemStat: DWord): Bool;
function GetCommState(hFile: THandle; var lpDCB: TDCB): Bool;
function GetCommTimeouts(hFile: THandle; var lpCommTimeouts: TCommTimeouts): Bool;
function PurgeComm(hFile: THandle; dwFlags: DWord): Bool;
function SetCommBreak(hFile: THandle): Bool;
function SetCommConfig(hCommDev: THandle; const lpCC: TCommConfig; dwSize: DWord): Bool;
function SetCommMask(hFile: THandle; dwEvtMask: DWord): Bool;
function SetCommState(hFile: THandle; const lpDCB: TDCB): Bool;
function SetCommTimeouts(hFile: THandle; const lpCommTimeouts: TCommTimeouts): Bool;
function TransmitCommChar(hFile: THandle; cChar: CHAR): Bool;
function WaitCommEvent(hFile: THandle; var lpEvtMask: DWord; lpOverlapped: POverlapped): Bool;
function SetTapePosition(hDevice: THandle; dwPositionMethod, dwPartition: DWord;
  dwOffsetLow, dwOffsetHigh: DWord; bImmediate: Bool): DWord;
function GetTapePosition(hDevice: THandle; dwPositionType: DWord;
  var lpdwPartition, lpdwOffsetLow: DWord; lpdwOffsetHigh: Pointer): DWord;
function PrepareTape(hDevice: THandle; dwOperation: DWord; bImmediate: Bool): DWord;
function EraseTape(hDevice: THandle; dwEraseType: DWord; bImmediate: Bool): DWord;
function CreateTapePartition(hDevice: THandle; dwPartitionMethod, dwCount, dwSize: DWord): DWord;
function WriteTapemark(hDevice: THandle;
  dwTapemarkType, dwTapemarkCount: DWord; bImmediate: Bool): DWord;
function GetTapeStatus(hDevice: THandle): DWord;
function GetTapeParameters(hDevice: THandle; dwOperation: DWord;
  var lpdwSize: DWord; lpTapeInformation: Pointer): DWord;

const
  Get_Tape_Media_Information = 0;
  Get_Tape_Drive_Information = 1;

function SetTapeParameters(hDevice: THandle; dwOperation: DWord;
  lpTapeInformation: Pointer): DWord;

const
  Set_Tape_Media_Information = 0;
  Set_Tape_Drive_Information = 1;

procedure GetSystemTimeAsFileTime(var lpSystemTimeAsFileTime: TFileTime);
procedure GetSystemInfo(var lpSystemInfo: TSystemInfo);
function IsProcessorFeaturePresent(ProcessorFeature: DWord): Bool;

{ Routines to convert back and forth between system time and file time }

function SetSystemTimeAdjustment(dwTimeAdjustment: DWord; bTimeAdjustmentDisabled: Bool): Bool;
function GetSystemTimeAdjustment(var lpTimeAdjustment, lpTimeIncrement: DWord;
  var lpTimeAdjustmentDisabled: Bool): Bool;
function FormatMessage(dwFlags: DWord; lpSource: Pointer; dwMessageId: DWord; dwLanguageId: DWord;
  lpBuffer: PChar; nSize: DWord; Arguments: Pointer): DWord;

const
  Format_Message_Allocate_Buffer = $100;
  Format_Message_Ignore_Inserts = $200;
  Format_Message_From_String = $400;
  Format_Message_From_HModule = $800;
  Format_Message_From_System = $1000;
  Format_Message_Argument_Array = $2000;
  Format_Message_Max_Width_Mask = 255;

function CreatePipe(var hReadPipe, hWritePipe: THandle;
  lpPipeAttributes: PSecurityAttributes; nSize: DWord): Bool;
function ConnectNamedPipe(hNamedPipe: THandle; lpOverlapped: POverlapped): Bool;
function DisconnectNamedPipe(hNamedPipe: THandle): Bool;
function SetNamedPipeHandleState(hNamedPipe: THandle; var lpMode: DWord;
  lpMaxCollectionCount, lpCollectDataTimeout: Pointer): Bool;
function GetNamedPipeInfo(hNamedPipe: THandle; var lpFlags: DWord;
  lpOutBufferSize, lpInBufferSize, lpMaxInstances: Pointer): Bool;
function PeekNamedPipe(hNamedPipe: THandle; lpBuffer: Pointer; nBufferSize: DWord;
  lpBytesRead, lpTotalBytesAvail, lpBytesLeftThisMessage: Pointer): Bool;
function TransactNamedPipe(hNamedPipe: THandle; lpInBuffer: Pointer; nInBufferSize: DWord;
  lpOutBuffer: Pointer; nOutBufferSize: DWord; var lpBytesRead: DWord;
  lpOverlapped: POverlapped): Bool;

function CreateMailslot(lpName: PChar; nMaxMessageSize: DWord;
  lReadTimeout: DWord; lpSecurityAttributes: PSecurityAttributes): THandle;
function GetMailslotInfo(hMailslot: THandle; lpMaxMessageSize: Pointer;
  var lpNextSize: DWord; lpMessageCount, lpReadTimeout: Pointer): Bool;
function SetMailslotInfo(hMailslot: THandle; lReadTimeout: DWord): Bool;
function MapViewOfFile(hFileMappingObject: THandle; dwDesiredAccess: DWord;
  dwFileOffsetHigh, dwFileOffsetLow, dwNumberOfBytesToMap: DWord): Pointer;
function FlushViewOfFile(const lpBaseAddress: Pointer; dwNumberOfBytesToFlush: DWord): Bool;
function UnmapViewOfFile(lpBaseAddress: Pointer): Bool;

{ _l Compat Functions }

function lstrcpyn(lpString1, lpString2: PChar; iMaxLength: Integer): PChar;

function _hread(hFile: HFILE; lpBuffer: Pointer; lBytes: Longint): Longint;
function _hwrite(hFile: HFILE; lpBuffer: LPCSTR; lBytes: Longint): Longint;
function IsTextUnicode(lpBuffer: Pointer; cb: Integer; lpi: PINT): Bool;

const
  tls_Out_of_Indexes = DWord($FFFFFFFF);


type
  TPROverlappedCompletionRoutine =
    procedure (dwErrorCode, dwNumberOfBytesTransfered: DWord;
    lpOverlapped: POverlapped);

function SleepEx(dwMilliseconds: DWord; bAlertable: Bool): DWord;
function WaitForSingleObjectEx(hHandle: THandle; dwMilliseconds: DWord; bAlertable: Bool): DWord;
function WaitForMultipleObjectsEx(nCount: DWord; lpHandles: PWOHandleArray;
  bWaitAll: Bool; dwMilliseconds: DWord; bAlertable: Bool): DWord;
function SignalObjectAndWait(hObjectToSignal: THandle; hObjectToWaitOn: THandle;
  dwMilliseconds: DWord; bAlertable: Bool): Bool;
function ReadFileEx(hFile: THandle; lpBuffer: Pointer; nNumberOfBytesToRead: DWord;
  lpOverlapped: POverlapped; lpCompletionRoutine: TPROverlappedCompletionRoutine): Bool;
function WriteFileEx(hFile: THandle; lpBuffer: Pointer; nNumberOfBytesToWrite: DWord;
  const lpOverlapped: TOverlapped; lpCompletionRoutine: FARPROC): Bool;
function BackupRead(hFile: THandle; lpBuffer: PByte; nNumberOfBytesToRead: DWord;
  var lpNumberOfBytesRead: DWord; bAbort: Bool;
  bProcessSecurity: Bool; var lpContext: Pointer): Bool;
function BackupSeek(hFile: THandle; dwLowBytesToSeek, dwHighBytesToSeek: DWord;
  var lpdwLowByteSeeked, lpdwHighByteSeeked: DWord; lpContext: Pointer): Bool;
function BackupWrite(hFile: THandle; lpBuffer: PByte; nNumberOfBytesToWrite: DWord;
  var lpNumberOfBytesWritten: DWord; bAbort, bProcessSecurity: Bool; var lpContext: Pointer): Bool;

type
  PWIN32StreamID = ^TWIN32StreamID;
  TWIN32StreamID = record
    dwStreamId: DWord;
    dwStreamAttributes: DWord;
    Size: TLargeInteger;
    dwStreamNameSize: DWord;
    cStreamName: array[0..0] of WCHAR;
  end;

const
  { Stream IDs }
  Backup_Invalid = 0;
  Backup_Data = 1;
  Backup_EA_Data = 2;
  Backup_Security_Data = 3;
  Backup_Alternate_Data = 4;
  Backup_Link = 5;
  Backup_Property_Data = 6;

  { Stream Attributes}
  Stream_Normal_Attribute = 0;
  Stream_Modified_When_Read = 1;
  Stream_Contains_Security = 2;
  Stream_Contains_Properties = 4;

  { Dual Mode API below this line. Dual Mode Structures also included. }
  StartF_UseCountChars = 8;
  StartF_UseFillAttribuge = $10;
  StartF_RunFullScreen = $20;  { ignored for non-x86 platforms }
  StartF_ForceOnFeedback = $40;
  StartF_ForceOffFeedback = $80;
  StartF_UseStdHandles = $100;
  StartF_UseHotKey = $200;

const
  Shutdown_NoRetry = 1;

type
  PWin32FileAttributeData = ^TWin32FileAttributeData;
  TWin32FileAttributeData = record
    dwFileAttributes: DWord;
    ftCreationTime: TFileTime;
    ftLastAccessTime: TFileTime;
    ftLastWriteTime: TFileTime;
    nFileSizeHigh: DWord;
    nFileSizeLow: DWord;
  end;

type
  TFNTimerAPCRoutine = TFarProc;

function CreateWaitableTimer(lpTimerAttributes: PSecurityAttributes;
  bManualReset: Bool; lpTimerName: PChar): Bool;
function OpenWaitableTimer(dwDesiredAccess: DWord; bInheritHandle: Bool;
  lpTimerName: PChar): Bool;
function SetWaitableTimer(hTimer: THandle; const lpDueTime: TLargeInteger;
  lPeriod: Longint; pfnCompletionRoutine: TFNTimerAPCRoutine;
  lpArgToCompletionRoutine: Pointer; fResume: Bool): Bool;
function CancelWaitableTimer(hTimer: THandle): Bool;
function CreateFileMapping(hFile: THandle; lpFileMappingAttributes: PSecurityAttributes;
  flProtect, dwMaximumSizeHigh, dwMaximumSizeLow: DWord; lpName: PChar): THandle;
function OpenFileMapping(dwDesiredAccess: DWord; bInheritHandle: Bool; lpName: PChar): THandle;
function LoadLibraryEx(lpLibFileName: PChar; hFile: THandle; dwFlags: DWord): hModule;

const
  Dont_Resolve_DLL_References = 1;
  Load_Library_as_Datafile = 2;
  Load_With_Altered_Search_Path = 8;

function SetProcessShutdownParameters(dwLevel, dwFlags: DWord): Bool;
function GetProcessShutdownParameters(var lpdwLevel, lpdwFlags: DWord): Bool;
function GetProcessVersion(ProcessId: DWord): DWord;
procedure GetStartupInfo(var lpStartupInfo: TStartupInfo);
function ExpandEnvironmentStrings(lpSrc: PChar; lpDst: PChar; nSize: DWord): DWord;
function FindResourceEx(hModule: hModule; lpType, lpName: PChar; wLanguage: Word): HRSRC;

type
  EnumResTypeProc = FarProc;
  EnumResNameproc = FarProc;
  EnumResLangProc = FarProc;

function EnumResourceTypes(hModule: hModule; lpEnumFunc: ENUMRESTYPEPROC;
  lParam: Longint): Bool;
function EnumResourceNames(hModule: hModule; lpType: PChar;
  lpEnumFunc: ENUMRESNAMEPROC; lParam: Longint): Bool;
function EnumResourceLanguages(hModule: hModule; lpType, lpName: PChar;
  lpEnumFunc: ENUMRESLANGPROC; lParam: Longint): Bool;
function BeginUpdateResource(pFileName: PChar; bDeleteExistingResources: Bool): THandle;
function UpdateResource(hUpdate: THandle; lpType, lpName: PChar;
  wLanguage: Word; lpData: Pointer; cbData: DWord): Bool;
function EndUpdateResource(hUpdate: THandle; fDiscard: Bool): Bool;
function GetProfileSection(lpAppName: PChar; lpReturnedString: PChar; nSize: DWord): DWord;
function WriteProfileSection(lpAppName, lpString: PChar): Bool;
function GetPrivateProfileSection(lpAppName: PChar;
  lpReturnedString: PChar; nSize: DWord; lpFileName: PChar): DWord;
function WritePrivateProfileSection(lpAppName, lpString, lpFileName: PChar): Bool;
function GetPrivateProfileSectionNames(lpszReturnBuffer: PChar; nSize: DWord; lpFileName: PChar): DWord;
function GetPrivateProfileStruct(lpszSection, lpszKey: PChar;
  lpStruct: Pointer; uSizeStruct: UInt; szFile: PChar): Bool;
function WritePrivateProfileStruct(lpszSection, lpszKey: PChar;
  lpStruct: Pointer; uSizeStruct: UInt; szFile: PChar): Bool;
function GetDiskFreeSpaceEx(lpDirectoryName: PChar; var lpFreeBytesAvailable, lpTotalNumberOfBytes: TLargeInteger; lpTotalNumberOfFreeBytes: PLargeInteger): Bool;
function CreateDirectoryEx(lpTemplateDirectory, lpNewDirectory: PChar;
  lpSecurityAttributes: PSecurityAttributes): Bool;

const
  ddd_Raw_Target_Path             = $00000001;
  ddd_Remove_Definition           = $00000002;
  ddd_Exact_Match_on_Remove       = $00000004;
  ddd_no_Broadcast_System         = $00000008;

function DefineDosDevice(dwFlags: DWord; lpDeviceName, lpTargetPath: PChar): Bool;
function QueryDosDevice(lpDeviceName: PChar;
  lpTargetPath: PChar; ucchMax: DWord): DWord;
type
  TGetFileExInfoLevels = (GetFileExInfoStandard, GetFileExMaxInfoLevel);
function GetFileAttributesEx(lpFileName: PChar;
  fInfoLevelId: TGetFileExInfoLevels; lpFileInformation: Pointer): Bool;
function GetCompressedFileSize(lpFileName: PChar; lpFileSizeHigh: PDWORD): DWord;
type
  TFindexInfoLevels = (FindExInfoStandard, FindExInfoMaxInfoLevel);
  TFindexSearchOps = (FindExSearchNameMatch, FindExSearchLimitToDirectories,
    FindExSearchLimitToDevices, FindExSearchMaxSearchOp);

const
  FIND_FIRST_EX_CASE_SENSITIVE = $00000001;

function FindFirstFileEx(lpFileName: PChar; fInfoLevelId: TFindexInfoLevels;
  lpFindFileData: Pointer; fSearchOp: TFindexSearchOps; lpSearchFilter: Pointer;
  dwAdditionalFlags: DWord): Bool;

type
  TFNProgressRoutine = TFarProc;

function CopyFileEx(lpExistingFileName, lpNewFileName: PChar;
  lpProgressRoutine: TFNProgressRoutine; lpData: Pointer; pbCancel: PBool;
  dwCopyFlags: DWord): Bool;
function MoveFileEx(lpExistingFileName, lpNewFileName: PChar; dwFlags: DWord): Bool;

const
  MoveFile_Replace_Existing       = $00000001;
  MoveFile_Copy_Allowed           = $00000002;
  MoveFile_Delay_Until_Reboot     = $00000004;
  MoveFile_Write_Through          = $00000008;

function CreateNamedPipe(lpName: PChar;
  dwOpenMode, dwPipeMode, nMaxInstances, nOutBufferSize, nInBufferSize, nDefaultTimeOut: DWord;
  lpSecurityAttributes: PSecurityAttributes): THandle;
function GetNamedPipeHandleState(hNamedPipe: THandle;
  lpState, lpCurInstances, lpMaxCollectionCount, lpCollectDataTimeout: PDWORD;
  lpUserName: PChar; nMaxUserNameSize: DWord): Bool;
function CallNamedPipe(lpNamedPipeName: PChar; lpInBuffer: Pointer;
  nInBufferSize: DWord; lpOutBuffer: Pointer; nOutBufferSize: DWord;
  var lpBytesRead: DWord; nTimeOut: DWord): Bool;
function WaitNamedPipe(lpNamedPipeName: PChar; nTimeOut: DWord): Bool;
procedure SetFileApisToOEM;
procedure SetFileApisToANSI;
function AreFileApisANSI: Bool;

function CancelIo(hFile: THandle): Bool;

{ Event logging APIs }

function ClearEventLog(hEventLog: THandle; lpBackupFileName: PChar): Bool;
function BackupEventLog(hEventLog: THandle; lpBackupFileName: PChar): Bool;
function CloseEventLog(hEventLog: THandle): Bool;
function DeregisterEventSource(hEventLog: THandle): Bool;
function NotifyChangeEventLog(hEventLog, hEvent: THandle): Bool;
function GetNumberOfEventLogRecords(hEventLog: THandle; var NumberOfRecords: DWord): Bool;
function GetOldestEventLogRecord(hEventLog: THandle; var OldestRecord: DWord): Bool;
function OpenEventLog(lpUNCServerName, lpSourceName: PChar): THandle;
function RegisterEventSource(lpUNCServerName, lpSourceName: PChar): THandle;
function OpenBackupEventLog(lpUNCServerName, lpFileName: PChar): THandle;
function ReadEventLog(hEventLog: THandle; dwReadFlags, dwRecordOffset: DWord;
  lpBuffer: Pointer; nNumberOfBytesToRead: DWord;
  var pnBytesRead, pnMinNumberOfBytesNeeded: DWord): Bool;
function ReportEvent(hEventLog: THandle; wType, wCategory: Word;
  dwEventID: DWord; lpUserSid: Pointer; wNumStrings: Word;
  dwDataSize: DWord; lpStrings, lpRawData: Pointer): Bool;

{ Security APIs }

function DuplicateToken(ExistingTokenHandle: THandle;
  ImpersonationLevel: TSecurityImpersonationLevel; DuplicateTokenHandle: PHandle): Bool;
function GetKernelObjectSecurity(Handle: THandle; RequestedInformation: SECURITY_INFORMATION;
  pSecurityDescriptor: PSecurityDescriptor; nLength: DWord;
  var lpnLengthNeeded: DWord): Bool;
function ImpersonateNamedPipeClient(hNamedPipe: THandle): Bool;
function ImpersonateSelf(ImpersonationLevel: TSecurityImpersonationLevel): Bool;
function RevertToSelf: Bool;
function SetThreadToken(Thread: PHandle; Token: THandle): Bool;
function AccessCheck(pSecurityDescriptor: PSecurityDescriptor;
  ClientToken: THandle; DesiredAccess: DWord; const GenericMapping: TGenericMapping;
  var PrivilegeSet: TPrivilegeSet; var PrivilegeSetLength: DWord;
  var GrantedAccess: DWord; var AccessStatus: Bool): Bool;
function OpenProcessToken(ProcessHandle: THandle; DesiredAccess: DWord;
  var TokenHandle: THandle): Bool;
function OpenThreadToken(ThreadHandle: THandle; DesiredAccess: DWord;
  OpenAsSelf: Bool; var TokenHandle: THandle): Bool;
function GetTokenInformation(TokenHandle: THandle;
  TokenInformationClass: TTokenInformationClass; TokenInformation: Pointer;
  TokenInformationLength: DWord; var ReturnLength: DWord): Bool;
function SetTokenInformation(TokenHandle: THandle;
  TokenInformationClass: TTokenInformationClass; TokenInformation: Pointer;
  TokenInformationLength: DWord): Bool;
function AdjustTokenPrivileges(TokenHandle: THandle; DisableAllPrivileges: Bool;
  const NewState: TTokenPrivileges; BufferLength: DWord;
  var PreviousState: TTokenPrivileges; var ReturnLength: DWord): Bool;
function AdjustTokenGroups(TokenHandle: THandle; ResetToDefault: Bool;
  const NewState: TTokenGroups; BufferLength: DWord;
  var PreviousState: TTokenGroups; var ReturnLength: DWord): Bool;
function PrivilegeCheck(ClientToken: THandle; const RequiredPrivileges: TPrivilegeSet;
  var pfResult: Bool): Bool;
function AccessCheckAndAuditAlarm(SubsystemName: PChar;
  HandleId: Pointer; ObjectTypeName, ObjectName: PChar;
  SecurityDescriptor: PSecurityDescriptor; DesiredAccess: DWord;
  const GenericMapping: TGenericMapping;  ObjectCreation: Bool;
  var GrantedAccess: DWord; var AccessStatus, pfGenerateOnClose: Bool): Bool;
function ObjectOpenAuditAlarm(SubsystemName: PChar; HandleId: Pointer;
  ObjectTypeName: PChar; ObjectName: PChar; pSecurityDescriptor: PSecurityDescriptor;
  ClientToken: THandle; DesiredAccess, GrantedAccess: DWord;
  var Privileges: TPrivilegeSet; ObjectCreation, AccessGranted: Bool;
  var GenerateOnClose: Bool): Bool;
function ObjectPrivilegeAuditAlarm(SubsystemName: PChar;
  HandleId: Pointer; ClientToken: THandle; DesiredAccess: DWord;
  var Privileges: TPrivilegeSet; AccessGranted: Bool): Bool;
function ObjectCloseAuditAlarm(SubsystemName: PChar;
  HandleId: Pointer; GenerateOnClose: Bool): Bool;
function ObjectDeleteAuditAlarm(SubsystemName: PChar;
  HandleId: Pointer; GenerateOnClose: Bool): Bool;
function PrivilegedServiceAuditAlarm(SubsystemName, ServiceName: PChar;
  ClientToken: THandle; var Privileges: TPrivilegeSet; AccessGranted: Bool): Bool;
function IsValidSid(pSid: Pointer): Bool;
function EqualSid(pSid1, pSid2: Pointer): Bool;
function EqualPrefixSid(pSid1, pSid2: Pointer): Bool;
function GetSidLengthRequired(nSubAuthorityCount: UCHAR): DWord;
function AllocateAndInitializeSid(const pIdentifierAuthority: TSIDIdentifierAuthority;
  nSubAuthorityCount: Byte; nSubAuthority0, nSubAuthority1: DWord;
  nSubAuthority2, nSubAuthority3, nSubAuthority4: DWord;
  nSubAuthority5, nSubAuthority6, nSubAuthority7: DWord;
  var pSid: Pointer): Bool;
function FreeSid(pSid: Pointer): Pointer;
function InitializeSid(Sid: Pointer; const pIdentifierAuthority: TSIDIdentifierAuthority;
  nSubAuthorityCount: Byte): Bool;
function GetSidIdentifierAuthority(pSid: Pointer): PSIDIdentifierAuthority;
function GetSidSubAuthority(pSid: Pointer; nSubAuthority: DWord): PDWORD;
function GetSidSubAuthorityCount(pSid: Pointer): PUCHAR;
function GetLengthSid(pSid: Pointer): DWord;
function CopySid(nDestinationSidLength: DWord;
  pDestinationSid, pSourceSid: Pointer): Bool;
function AreAllAccessesGranted(GrantedAccess, DesiredAccess: DWord): Bool;
function AreAnyAccessesGranted(GrantedAccess, DesiredAccess: DWord): Bool;
procedure MapGenericMask(var AccessMask: DWord; const GenericMapping: TGenericMapping);
function IsValidAcl(const pAcl: TACL): Bool;
function InitializeAcl(var pAcl: TACL; nAclLength, dwAclRevision: DWord): Bool;
function GetAclInformation(const pAcl: TACL; pAclInformation: Pointer;
  nAclInformationLength: DWord; dwAclInformationClass: TAclInformationClass): Bool;
function SetAclInformation(var pAcl: TACL; pAclInformation: Pointer;
  nAclInformationLength: DWord; dwAclInformationClass: TAclInformationClass): Bool;
function AddAce(var pAcl: TACL; dwAceRevision, dwStartingAceIndex: DWord; pAceList: Pointer;
  nAceListLength: DWord): Bool;
function DeleteAce(var pAcl: TACL; dwAceIndex: DWord): Bool;
function GetAce(const pAcl: TACL; dwAceIndex: DWord; var pAce: Pointer): Bool;
function AddAccessAllowedAce(var pAcl: TACL; dwAceRevision: DWord;
  AccessMask: DWord; pSid: PSID): Bool;
function AddAccessDeniedAce(var pAcl: TACL; dwAceRevision: DWord;
  AccessMask: DWord; pSid: PSID): Bool;
function AddAuditAccessAce(var pAcl: TACL; dwAceRevision: DWord;
  dwAccessMask: DWord; pSid: Pointer; bAuditSuccess, bAuditFailure: Bool): Bool;
function FindFirstFreeAce(var pAcl: TACL; var pAce: Pointer): Bool;
function InitializeSecurityDescriptor(pSecurityDescriptor: PSecurityDescriptor;
  dwRevision: DWord): Bool;
function IsValidSecurityDescriptor(pSecurityDescriptor: PSecurityDescriptor): Bool;
function GetSecurityDescriptorLength(pSecurityDescriptor: PSecurityDescriptor): DWord;
function GetSecurityDescriptorControl(pSecurityDescriptor: PSecurityDescriptor;
  var pControl: SECURITY_DESCRIPTOR_CONTROL; var lpdwRevision: DWord): Bool;
function SetSecurityDescriptorDacl(pSecurityDescriptor: PSecurityDescriptor;
  bDaclPresent: Bool; pDacl: PACL; bDaclDefaulted: Bool): Bool;
function GetSecurityDescriptorDacl(pSecurityDescriptor: PSecurityDescriptor;
  var lpbDaclPresent: Bool; var pDacl: PACL; var lpbDaclDefaulted: Bool): Bool;
function SetSecurityDescriptorSacl(pSecurityDescriptor: PSecurityDescriptor;
  bSaclPresent: Bool; pSacl: PACL; bSaclDefaulted: Bool): Bool;
function GetSecurityDescriptorSacl(pSecurityDescriptor: PSecurityDescriptor;
  var lpbSaclPresent: Bool; var pSacl: PACL; var lpbSaclDefaulted: Bool): Bool;
function SetSecurityDescriptorOwner(pSecurityDescriptor: PSecurityDescriptor;
  pOwner: PSID; bOwnerDefaulted: Bool): Bool;
function GetSecurityDescriptorOwner(pSecurityDescriptor: PSecurityDescriptor;
  var pOwner: PSID; var lpbOwnerDefaulted: Bool): Bool;
function SetSecurityDescriptorGroup(pSecurityDescriptor: PSecurityDescriptor;
  pGroup: PSID; bGroupDefaulted: Bool): Bool;
function GetSecurityDescriptorGroup(pSecurityDescriptor: PSecurityDescriptor;
  var pGroup: PSID; var lpbGroupDefaulted: Bool): Bool;
function CreatePrivateObjectSecurity(ParentDescriptor, CreatorDescriptor: PSecurityDescriptor;
  var NewDescriptor: PSecurityDescriptor; IsDirectoryObject: Bool;
  Token: THandle; const GenericMapping: TGenericMapping): Bool;
function SetPrivateObjectSecurity(SecurityInformation: SECURITY_INFORMATION;
  ModificationDescriptor: PSecurityDescriptor; var ObjectsSecurityDescriptor: PSecurityDescriptor;
  const GenericMapping: TGenericMapping; Token: THandle): Bool;
function GetPrivateObjectSecurity(ObjectDescriptor: PSecurityDescriptor;
  SecurityInformation: SECURITY_INFORMATION; ResultantDescriptor: PSecurityDescriptor;
  DescriptorLength: DWord; var ReturnLength: DWord): Bool;
function DestroyPrivateObjectSecurity(var ObjectDescriptor: PSecurityDescriptor): Bool;
function MakeSelfRelativeSD(pAbsoluteSecurityDescriptor: PSecurityDescriptor;
  pSelfRelativeSecurityDescriptor: PSecurityDescriptor; var lpdwBufferLength: DWord): Bool;
function MakeAbsoluteSD(pSelfRelativeSecurityDescriptor: PSecurityDescriptor;
  pAbsoluteSecurityDescriptor: PSecurityDescriptor; var lpdwAbsoluteSecurityDescriptorSi: DWord;
  var pDacl: TACL; var lpdwDaclSize: DWord; var pSacl: TACL;
  var lpdwSaclSize: DWord; pOwner: PSID; var lpdwOwnerSize: DWord;
  pPrimaryGroup: Pointer; var lpdwPrimaryGroupSize: DWord): Bool;

function SetFileSecurity(lpFileName: PChar; SecurityInformation: SECURITY_INFORMATION;
  pSecurityDescriptor: PSecurityDescriptor): Bool;
function GetFileSecurity(lpFileName: PChar; RequestedInformation: SECURITY_INFORMATION;
  pSecurityDescriptor: PSecurityDescriptor; nLength: DWord; var lpnLengthNeeded: DWord): Bool;
function SetKernelObjectSecurity(Handle: THandle; SecurityInformation: SECURITY_INFORMATION;
  SecurityDescriptor: PSecurityDescriptor): Bool;
function FindFirstChangeNotification(lpPathName: PChar;
  bWatchSubtree: Bool; dwNotifyFilter: DWord): THandle;
function FindNextChangeNotification(hChangeHandle: THandle): Bool;
function FindCloseChangeNotification(hChangeHandle: THandle): Bool;
function ReadDirectoryChanges(hDirectory: THandle; lpBuffer: Pointer;
  nBufferLength: DWord; bWatchSubtree: Bool; dwNotifyFilter: DWord;
  lpBytesReturned: LPDWORD; lpOverlapped: POverlapped;
  lpCompletionRoutine: FARPROC): Bool;
function VirtualLock(lpAddress: Pointer; dwSize: DWord): Bool;
function VirtualUnlock(lpAddress: Pointer; dwSize: DWord): Bool;
function MapViewOfFileEx(hFileMappingObject: THandle;
  dwDesiredAccess, dwFileOffsetHigh, dwFileOffsetLow, dwNumberOfBytesToMap: DWord;
  lpBaseAddress: Pointer): Pointer;
function LookupAccountSid(lpSystemName: PChar; Sid: PSID;
  Name: PChar; var cbName: DWord; ReferencedDomainName: PChar;
  var cbReferencedDomainName: DWord; var peUse: SID_NAME_USE): Bool;
function LookupAccountName(lpSystemName, lpAccountName: PChar;
  Sid: PSID; var cbSid: DWord; ReferencedDomainName: PChar;
  var cbReferencedDomainName: DWord; var peUse: SID_NAME_USE): Bool;
function LookupPrivilegeValue(lpSystemName, lpName: PChar;
  var lpLuid: TLargeInteger): Bool;
function LookupPrivilegeName(lpSystemName: PChar;
  var lpLuid: TLargeInteger; lpName: PChar; var cbName: DWord): Bool;
function LookupPrivilegeDisplayName(lpSystemName, lpName: PChar;
  lpDisplayName: PChar; var cbDisplayName, lpLanguageId: DWord): Bool;
function AllocateLocallyUniqueId(var Luid: TLargeInteger): Bool;
function BuildCommDCB(lpDef: PChar; var lpDCB: TDCB): Bool;
function BuildCommDCBAndTimeouts(lpDef: PChar; var lpDCB: TDCB;
  var lpCommTimeouts: TCommTimeouts): Bool;
function CommConfigDialog(lpszName: PChar; hWnd: hWnd; var lpCC: TCommConfig): Bool;
function GetDefaultCommConfig(lpszName: PChar;
  var lpCC: TCommConfig; var lpdwSize: DWord): Bool;
function SetDefaultCommConfig(lpszName: PChar; lpCC: PCommConfig; dwSize: DWord): Bool;

const
  Max_Computername_Length = 15;

function GetComputerName(lpBuffer: PChar; var nSize: DWord): Bool;
function SetComputerName(lpComputerName: PChar): Bool;
function GetUserName(lpBuffer: PChar; var nSize: DWord): Bool;

{ Logon Support APIs }

const
  Logon32_Logon_Interactive = 2;
  Logon32_Logon_Network = 3;
  Logon32_Logon_Batch = 4;
  Logon32_Logon_Service = 5;

  Logon32_Provider_Default = 0;
  Logon32_Provider_WinNt35 = 1;
  Logon32_Provider_WinNt40 = 2;

function LogonUser(lpszUsername, lpszDomain, lpszPassword: PChar;
  dwLogonType, dwLogonProvider: DWord; var phToken: THandle): Bool;
function ImpersonateLoggedOnUser(hToken: THandle): Bool;
function CreateProcessAsUser(hToken: THandle; lpApplicationName: PChar;
  lpCommandLine: PChar; lpProcessAttributes: PSecurityAttributes;
  lpThreadAttributes: PSecurityAttributes; bInheritHandles: Bool;
  dwCreationFlags: DWord; lpEnvironment: Pointer; lpCurrentDirectory: PChar;
  const lpStartupInfo: TStartupInfo; var lpProcessInformation: TProcessInformation): Bool;

function DuplicateTokenEx(hExistingToken: THandle; dwDesiredAccess: DWord;
  lpTokenAttributes: PSecurityAttributes;
  ImpersonationLevel: TSecurityImpersonationLevel; TokenType: TTokenType;
  var phNewToken: THandle): Bool;

{ Plug-and-Play API's }
const
  hw_Profile_GUIDLen = 39;                 { 36-characters plus NULL terminator }
  max_Profile_Len = 80;

  DockInfo_Undocked = $1;
  DockInfo_Docked = $2;
  DockInfo_User_Supplied = $4;
  DockInfo_User_Undocked = DockInfo_User_Supplied or DockInfo_Undocked;
  DockInfo_User_Docked = DockInfo_User_Supplied or DockInfo_Docked;

type
  PHWProfileInfo = ^THWProfileInfo;
  THWProfileInfo = packed record
    dwDockInfo: DWord;
    szHwProfileGuid: packed array[0..hw_Profile_GUIDLen-1] of Char;
    szHwProfileName: packed array[0..max_Profile_Len-1] of Char;
  end;

function GetCurrentHwProfile(var lpHwProfileInfo: THWProfileInfo): Bool;

{ Performance counter API's }

function QueryPerformanceCounter(var lpPerformanceCount: TLargeInteger): Bool;
function QueryPerformanceFrequency(var lpFrequency: TLargeInteger): Bool;

type
  POSVersionInfo = ^TOSVersionInfo;
  TOSVersionInfo = record
    dwOSVersionInfoSize: DWord;
    dwMajorVersion: DWord;
    dwMinorVersion: DWord;
    dwBuildNumber: DWord;
    dwPlatformId: DWord;
    szCSDVersion: array[0..127] of Char; { Maintenance string for PSS usage }
  end;

{ dwPlatformId defines }
const
  ver_Platform_Win32s = 0;
  ver_Platform_Win32_Windows = 1;
  ver_Platform_Win32_NT = 2;

function GetVersionEx(var lpVersionInformation: TOSVersionInfo): Bool;

{ DOS and OS/2 Compatible Error Code definitions returned by the Win32 Base
  API functions. }


{ Translated from WINERROR.H }
{ Error code definitions for the Win32 API functions }

(*
  Values are 32 bit values layed out as follows:
   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
  +---+-+-+-----------------------+-------------------------------+
  |Sev|C|R|     Facility          |               Code            |
  +---+-+-+-----------------------+-------------------------------+

  where
      Sev - is the severity code
          00 - Success
          01 - Informational
          10 - Warning
          11 - Error

      C - is the Customer code flag
      R - is a reserved bit
      Facility - is the facility code
      Code - is the facility's status code
*)

{ Define the facility codes }

const
  Facility_SSPI                        = 9;
  Facility_Internet                    = 12;
  Facility_CERT                        = 11;

  {  The image file %1 is valid, but is for a machine type other }
  {  than the current machine. }
  Error_Exe_Machine_Type_Mismatch = 216;

  {  The account specified for this service is different from the account }
  {  specified for other services running in the same process. }
  Error_Different_Service_Account = 1079;

  { An attempt to change the system power state was vetoed by another }
  { application or driver. }
  Error_Set_Power_State_Vetoed = 1140;

  { The system BIOS failed an attempt to change the system power state. }
  Error_Set_Power_State_Failed = 1141;

  {  An attempt was made to create more links on a file than }
  {  the file system supports. }
  Error_Too_Many_Links = 1142;

  { The specified program requires a newer version of Windows. }
  Error_Old_Win_Version = 1150;

  { The specified program is not a Windows or MS-DOS program. }
  Error_App_Wrong_OS = 1151;

  { Cannot start more than one instance of the specified program. }
  Error_Single_Instance_App = 1152;

  {  The specified program was written for an older version of Windows. }
  Error_RMode_Aapp= 1153;

  { One of the library files needed to run this application is damaged. }
  Error_Invalid_DLL = 1154;

  { No application is associated with the specified file for this operation. }
  Error_No_Association = 1155;

  { An error occurred in sending the command to the application. }
  Error_DDE_Fail = 1156;

  { One of the library files needed to run this application cannot be found. }
  Error_DLL_Not_Found = 1157;


{ Winnet32 Status Codes }

  { The operation being requested was not performed because the user }
  { has not been authenticated. }
  Error_Not_Authenticated = 1244;

  { The operation being requested was not performed because the user }
  { has not logged on to the network. }
  { The specified service does not exist. }
  Error_Not_Logged_On = 1245;

  { Return that wants caller to continue with work in progress. }
  Error_Continue = 1246;

  { An attempt was made to perform an initialization operation when }
  { initialization has already been completed. }
  Error_Already_Initialized = 1247;

  { No more local devices. }
  Error_No_More_Devices = 1248;


{ Security Status Codes }

  { The file or directory is corrupt and non-readable. }

  { The disk structure is corrupt and non-readable. }

  { There is no user session key for the specified logon session. }

  { The service being accessed is licensed for a particular number of connections. }
  { No more connections can be made to the service at this time }
  { because there are already as many connections as the service can accept. }
  Error_License_Quota_Exceeded = 1395;


{ WinUser Error Codes }

  { Insufficient system resources exist to complete the requested service. }
  Error_No_System_Resources = 1450;

  { Insufficient system resources exist to complete the requested service. }
  Error_NonPaged_System_Resources = 1451;

  { Insufficient system resources exist to complete the requested service. }
  Error_Paged_System_Resources = 1452;

  { Insufficient quota to complete the requested service. }
  Error_Working_Set_Quota = 1453;

  { Insufficient quota to complete the requested service. }
  Error_Pagefile_Quota = 1454;

  { The paging file is too small for this operation to complete. }
  Error_Commitment_Limit = 1455;

  { A menu item was not found. }
  Error_Menu_Item_Not_Found = 1456;

  { Invalid keyboard layout handle. }
  Error_Invalid_Keyboard_Handle = 1457;

  { Hook type not allowed. }
  Error_Hook_Type_Not_Allowed = 1458;

  { This operation requires an interactive windowstation. }
  Error_Requires_Interactive_Windowstation = 1459;

  { This operation returned because the timeout period expired. }
  Error_Timeout = 1460;


{ Eventlog Status Codes }

{ RPC Status Codes }

  { The string binding is invalid. }
  rpc_s_Invalid_String_Binding = 1700;

  { The binding handle is not the correct type. }
  rpc_s_Wrong_Kind_of_Binding = 1701;

  { The binding handle is invalid. }
  rpc_s_Invalid_Binding = 1702;

  { The RPC protocol sequence is not supported. }
  rpc_s_ProtSeq_not_Supported = 1703;

  { The RPC protocol sequence is invalid. }
  rpc_s_Invalid_rpc_ProtSeq = 1704;

  { The string universal unique identifier (UUID) is invalid. }
  rpc_s_Invalid_String_UUID = 1705;

  { The endpoint format is invalid. }
  rpc_s_Invalid_EndPoint_Format = 1706;

  { The network address is invalid. }
  rpc_s_Invalid_Net_Addr = 1707;

  { No endpoint was found. }
  rpc_s_no_EndPoint_Found = 1708;

  { The timeout value is invalid. }
  rpc_s_Invalid_Timeout = 1709;

  { The object universal unique identifier (UUID) was not found. }
  rpc_s_Object_not_Found = 1710;

  { The object universal unique identifier (UUID) has already been registered. }
  rpc_s_Already_Registered = 1711;

  { The type universal unique identifier (UUID) has already been registered. }
  rpc_s_Type_Already_Registered = 1712;

  { The RPC server is already listening. }
  rpc_s_Already_Listening = 1713;

  { No protocol sequences have been registered. }
  rpc_s_no_ProtSeqs_Registered = 1714;

  { The RPC server is not listening. }
  rpc_s_not_Listening = 1715;

  { The manager type is unknown. }
  rpc_s_Unknown_MGR_Type = 1716;

  { The interface is unknown. }
  rpc_s_Unknown_IF = 1717;

  { There are no bindings. }
  rpc_s_no_Bindings = 1718;

  { There are no protocol sequences. }
  rpc_s_no_ProtSeqs = 1719;

  { The endpoint cannot be created. }
  rpc_s_cant_Create_EndPoint = 1720;

  { Not enough resources are available to complete this operation. }
  rpc_s_Out_of_Resources = 1721;

  { The RPC server is unavailable. }
  rpc_s_Server_Unavailable = 1722;

  { The RPC server is too busy to complete this operation. }
  rpc_s_Server_too_Busy = 1723;

  { The network options are invalid. }
  rpc_s_Invalid_Network_Options = 1724;

  { There is not a remote procedure call active in this thread. }
  rpc_s_no_Call_Active = 1725;

  { The remote procedure call failed. }
  rpc_s_Call_Failed = 1726;

  { The remote procedure call failed and did not execute. }
  rpc_s_Call_Failed_DNE = 1727;

  { A remote procedure call (RPC) protocol error occurred. }
  rpc_s_Protocol_Error = 1728;

  { The transfer syntax is not supported by the RPC server. }
  rpc_s_Unsupported_Trans_Syn = 1730;

  { The universal unique identifier (UUID) type is not supported. }
  rpc_s_Unsupported_Type = 1732;

  { The tag is invalid. }
  rpc_s_Invalid_Tag = 1733;

  { The array bounds are invalid. }
  rpc_s_Invalid_Bound = 1734;

  { The binding does not contain an entry name. }
  rpc_s_no_Entry_Name = 1735;

  { The name syntax is invalid. }
  rpc_s_Invalid_Name_Syntax = 1736;

  { The name syntax is not supported. }
  rpc_s_Unsupported_Name_Syntax = 1737;

  { No network address is available to use to construct a universal }

  { unique identifier (UUID). }
  rpc_s_UUID_no_Address = 1739;

  { The endpoint is a duplicate. }
  rpc_s_Duplicate_EndPoint = 1740;

  { The authentication type is unknown. }
  rpc_s_Unknown_Authn_Type = 1741;

  { The maximum number of calls is too small. }
  rpc_s_Max_Calls_too_Small = 1742;

  { The string is too long. }
  rpc_s_String_too_Long = 1743;

  { The RPC protocol sequence was not found. }
  rpc_s_ProtSeq_not_Found = 1744;

  { The procedure number is out of range. }
  rpc_s_ProcNum_out_of_Range = 1745;

  { The binding does not contain any authentication information. }
  rpc_s_Binding_has_no_Auth = 1746;

  { The authentication service is unknown. }
  rpc_s_Unknown_Authn_Service = 1747;

  { The authentication level is unknown. }
  rpc_s_Unknown_Authn_Level = 1748;

  { The security context is invalid. }
  rpc_s_Invalid_Auth_Identity = 1749;

  { The authorization service is unknown. }
  rpc_s_Unknown_Authz_Service = 1750;

  { The entry is invalid. }
  ept_s_Invalid_Entry = 1751;

  { The server endpoint cannot perform the operation. }
  ept_s_cant_Perform_OP = 1752;

  { There are no more endpoints available from the endpoint mapper. }
  ept_s_not_Registered = 1753;

  { No interfaces have been exported. }
  rpc_s_Nothing_to_Export = 1754;

  { The entry name is incomplete. }
  rpc_s_Incomplete_Name = 1755;

  { The version option is invalid. }
  rpc_s_Invalid_Vers_Option = 1756;

  { There are no more members. }
  rpc_s_no_More_Members = 1757;

  { There is nothing to unexport. }
  rpc_s_not_all_Objs_Unexported = 1758;

  { The interface was not found. }
  rpc_s_Interface_not_Found = 1759;

  { The entry already exists. }
  rpc_s_Entry_Already_Exists = 1760;

  { The entry is not found. }
  rpc_s_Entry_not_Found = 1761;

  { The name service is unavailable. }
  rpc_s_Name_Service_Unavailable = 1762;

  { The network address family is invalid. }
  rpc_s_Invalid_NAF_ID = 1763;

  { The requested operation is not supported. }
  rpc_s_Cannot_Support = 1764;

  { No security context is available to allow impersonation. }
  rpc_s_no_Context_Available = 1765;

  { An internal error occurred in a remote procedure call (RPC). }
  rpc_s_Internal_Error = 1766;

  { The RPC server attempted an integer division by zero. }
  rpc_s_Zero_Divide = 1767;

  { An addressing error occurred in the RPC server. }
  rpc_s_Address_Error = 1768;

  { A floating-point operation at the RPC server caused a division by zero. }
  rpc_s_FP_Div_Zero = 1769;

  { A floating-point underflow occurred at the RPC server. }
  rpc_s_FP_Underflow = 1770;

  { A floating-point overflow occurred at the RPC server. }
  rpc_s_FP_Overflow = 1771;

  { The list of RPC servers available for the binding of auto handles }
  { has been exhausted. }
  rpc_x_no_More_Entries = 1772;

  { Unable to open the character translation table file. }
  rpc_x_SS_Char_Trans_Open_Fail = 1773;

  { The file containing the character translation table has fewer than }
  { 512 bytes. }
  rpc_x_SS_Char_Trans_Short_File = 1774;

  { A null context handle was passed from the client to the host during }
  { a remote procedure call. }
  rpc_x_SS_in_Null_Context = 1775;

  { The context handle changed during a remote procedure call. }
  rpc_x_SS_Context_Damaged = 1777;

  { The binding handles passed to a remote procedure call do not match. }
  rpc_x_SS_Handles_Mismatch = 1778;

  { The stub is unable to get the remote procedure call handle. }
  rpc_x_SS_Cannot_get_Call_Handle = 1779;

  { A null reference pointer was passed to the stub. }
  rpc_x_Null_Ref_Pointer = 1780;

  { The enumeration value is out of range. }
  rpc_x_Enum_Value_out_of_Range = 1781;

  { The byte count is too small. }
  rpc_x_Byte_Count_too_Small = 1782;

  { The stub received bad data. }
  rpc_x_bad_Stub_Data = 1783;

  { A remote procedure call is already in progress for this thread. }
  rpc_s_Call_in_Progress = 1791;

  { There are no more bindings. }
  rpc_s_no_More_Bindings = 1806;

  { No interfaces have been registered. }
  rpc_s_no_Interfaces = 1817;

  { The server was altered while processing this call. }
  rpc_s_Call_Cancelled = 1818;

  { The binding handle does not contain all required information. }
  rpc_s_Binding_Incomplete = 1819;

  { Communications failure. }
  rpc_s_Comm_Failure = 1820;

  { The requested authentication level is not supported. }
  rpc_s_Unsupported_Authn_Level = 1821;

  { No principal name registered. }
  rpc_s_no_Princ_Name = 1822;

  { The error specified is not a valid Windows NT RPC error code. }
  rpc_s_not_RPC_Error = 1823;

  { A UUID that is valid only on this computer has been allocated. }
  rpc_s_UUID_Local_Only = 1824;

  { A security package specific error occurred. }
  rpc_s_Sec_Pkg_Error = 1825;

  { Thread is not cancelled. }
  rpc_s_not_Cancelled = 1826;

  { Invalid operation on the encoding/decoding handle. }
  rpc_x_Invalid_ES_Action = 1827;

  { Incompatible version of the serializing package. }
  rpc_x_Wrong_ES_Version = 1828;

  { Incompatible version of the RPC stub. }
  rpc_x_Wrong_Stub_Version = 1829;

  { The idl pipe object is invalid or corrupted. }
  rpc_x_Invalid_Pipe_Object = 1830;

  { The operation is invalid for a given idl pipe object. }
  rpc_x_Invalid_Pipe_Operation = 1831;

  { The idl pipe version is not supported. }
  rpc_x_Wrong_Pipe_Version = 1832;

  { The group member was not found. }
  rpc_s_Group_Member_not_Found = 1898;

  { The endpoint mapper database could not be created. }
  rpc_s_cant_Create = 1899;

  { The object universal unique identifier (UUID) is the nil UUID. }
  rpc_s_Invalid_Object = 1900;

  { The referenced account is currently locked out and may not be logged on to. }

  { The object exporter specified was not found. }
  or_Invalid_OXID = 1910;

  { The object specified was not found. }
  or_Invalid_OID = 1911;

  { The object resolver set specified was not found. }
  or_Invalid_Set = 1912;

  { Some data remains to be sent in the request buffer. }
  rpc_s_Send_Incomplete = 1913;

  { The list of servers for this workgroup is not currently available }
  Error_no_Browser_Servers_Found = 6118;


  { The specified print monitor does not have the required functions. }
  Error_Invalid_Print_Monitor = 3007;

  { The specified print monitor is currently in use. }
  Error_Print_Monitor_in_Use = 3008;

  { The requested operation is not allowed when there are jobs queued to the printer. }
  Error_Printer_has_Jobs_Queued = 3009;

  { The requested operation is successful.  Changes will not be effective until the system is rebooted. }
  Error_Success_Reboot_Required = 3010;

  { The requested operation is successful.  Changes will not be effective until the service is restarted. }
  Error_Success_Restart_Required = 3011;

{------------------------------}
{     OLE Error Codes          }
{------------------------------}

(*
  The return value of OLE APIs and methods is an HRESULT.
  This is not a handle to anything, but is merely a 32-bit value
  with several fields encoded in the value.  The parts of an
  HRESULT are shown below.

  HRESULTs are 32 bit values layed out as follows:

   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
  +-+-+-+-+-+---------------------+-------------------------------+
  |S|R|C|N|r|    Facility         |               Code            |
  +-+-+-+-+-+---------------------+-------------------------------+

  where

      S - Severity - indicates success/fail
          0 - Success
          1 - Fail (COERROR)

      R - reserved portion of the facility code, corresponds to NT's
              second severity bit.

      C - reserved portion of the facility code, corresponds to NT's
              C field.

      N - reserved portion of the facility code. Used to indicate a
              mapped NT status value.

      r - reserved portion of the facility code. Reserved for internal
              use. Used to indicate HRESULT values that are not status
              values, but are instead message ids for display strings.

      Facility - is the facility code

      Code - is the facility's status code
*)

const
  { Severity values }
  Severity_Success = 0;
  Severity_Error = 1;

function Succeeded(Status: HRESULT): Bool;

{ and the inverse }
function Failed(Status: HRESULT): Bool;

{ Generic test for error on any status value. }
function IsError(Status: HRESULT): Bool;

{ Return the code }
function HResultCode(hr: HRESULT): Integer;

{ Return the facility }
function HResultFacility(hr: HRESULT): Integer;

{ Return the severity }
function HResultSeverity(hr: HRESULT): Integer;

{ Create an HRESULT value from component pieces }
function MakeResult(sev, fac, code: Integer): HResult;

{ Map a WIN32 error value into a HRESULT }
{ Note: This assumes that WIN32 errors fall in the range -32k to 32k. }
const
  { Define bits here so macros are guaranteed to work }
  facility_NT_Bit = $10000000;

function HResultFromWin32(x: Integer): HRESULT;

{ Map an NT status value into a HRESULT }
function HResultFromNT(x: Integer): HRESULT;

const
  { HRESULT value definitions }
  { Codes $4000-$40ff are reserved for OLE }

  { Success codes }
  s_OK    = $00000000;
  s_False = $00000001;

  NoError = 0;

  { Catastrophic failure }
  E_Unexpected = $8000FFFF;

  { Not implemented }
  E_NotImpl = $80004001;

  { Ran out of memory }
  E_OutOfMemory = $8007000E;

  { One or more arguments are invalid }
  E_InvalidArg = $80070057;

  { No such interface supported }
  E_NoInterface = $80004002;

  { Invalid pointer }
  E_Pointer = $80004003;

  { Invalid handle }
  E_Handle = $80070006;

  { Operation aborted }
  E_Abort = $80004004;

  { Unspecified error }
  E_Fail = $80004005;

  { General access denied error }
  E_AccessDenied = $80070005;

  { The data necessary to complete this operation is not yet available. }
  E_Pending = $8000000A;

  { Thread local storage failure }
  CO_E_Init_TLS = $80004006;

  { Get shared memory allocator failure }
  CO_E_Init_Shared_Allocator = $80004007;

  { Get memory allocator failure }
  CO_E_Init_Memory_Allocator = $80004008;

  { Unable to initialize class cache }
  CO_E_Init_Class_Cache = $80004009;

  { Unable to initialize RPC services }
  CO_E_Init_RPC_Channel = $8000400A;

  { Cannot set thread local storage channel control }
  CO_E_Init_TLS_Set_Channel_Contro = $8000400B;

  { Could not allocate thread local storage channel control }
  CO_E_Init_TLS_Channel_Control = $8000400C;

  { The user supplied memory allocator is unacceptable }
  CO_E_Init_Unaccepted_User_Alloca = $8000400D;

  { The OLE service mutex already exists }
  CO_E_Init_SCM_Mutex_Exists = $8000400E;

  { The OLE service file mapping already exists }
  CO_E_Init_SCM_File_Mapping_Exist = $8000400F;

  { Unable to map view of file for OLE service }
  CO_E_Init_SCM_Map_View_of_Fild = $80004010;

  { Failure attempting to launch OLE service }
  CO_E_Init_SCM_Exec_Failure = $80004011;

  { There was an attempt to call CoInitialize a second time while single threaded }
  CO_E_Init_only_Single_Threaded = $80004012;

  { A Remote activation was necessary but was not allowed }
  CO_E_cant_Remote = $80004013;

  { A Remote activation was necessary but the server name provided was invalid }
  CO_E_bad_Server_Name = $80004014;

  { The class is configured to run as a security id different from the caller }
  CO_E_Wrong_Server_Identity = $80004015;

  { Use of Ole1 services requiring DDE windows is disabled }
  CO_E_OLE1DDE_Disabled = $80004016;

  { A RunAs specification must be <domain name>\<user name> or simply <user name> }
  CO_E_RunAs_Syntax = $80004017;

  { The server process could not be started.  The pathname may be incorrect. }
  CO_E_CreateProcess_Failure = $80004018;

  { The server process could not be started as the configured identity.  The pathname may be incorrect or unavailable. }
  CO_E_RunAs_CreateProcess_Failure = $80004019;

  { The server process could not be started because the configured identity is incorrect.  Check the username and password. }
  CO_E_RunAs_Logon_Failure = $8000401A;

  { The client is not allowed to launch this server. }
  CO_E_Launch_Permssion_Denied = $8000401B;

  { The service providing this server could not be started. }
  CO_E_Start_Service_Failure = $8000401C;

  { This computer was unable to communicate with the computer providing the server. }
  CO_E_Remote_Communication_Failure = $8000401D;

  { The server did not respond after being launched. }
  CO_E_Server_Start_Timeout = $8000401E;

  { The registration information for this server is inconsistent or incomplete. }
  CO_E_ClsReg_Inconsistent = $8000401F;

  { The registration information for this interface is inconsistent or incomplete. }
  CO_E_IIdReg_Inconsistent = $80004020;

  { The operation attempted is not supported. }
  CO_E_not_Supported = $80004021;


  { FACILITY_ITF }
  { Codes $0-$01ff are reserved for the OLE group of }

  { Generic OLE errors that may be returned by many inerfaces}
  OLE_E_First = $80040000;
  OLE_E_Last  = $800400FF;
  OLE_S_First = $40000;
  OLE_S_Last  = $400FF;

  { Invalid OLEVERB structure }
  OLE_E_OleVerb = $80040000;

  { Invalid advise flags }
  OLE_E_AdvF = $80040001;

  { Can't enumerate any more, because the associated data is missing }
  OLE_E_Enum_NoMore = $80040002;

  { This implementation doesn't take advises }
  OLE_E_AdviseNotSupported = $80040003;

  { There is no connection for this connection ID }
  OLE_E_NoConnection = $80040004;

  { Need to run the object to perform this operation }
  OLE_E_NotRunning = $80040005;

  { There is no cache to operate on }
  OLE_E_NoCache = $80040006;

  { Uninitialized object }
  OLE_E_Blank = $80040007;

  { Linked object's source class has changed }
  OLE_E_ClassDiff = $80040008;

  { Not able to get the moniker of the object }
  OLE_E_Cant_GetMoniker = $80040009;

  { Not able to bind to the source }
  OLE_E_Cant_BindToSource = $8004000A;

  { Object is static; operation not allowed }
  OLE_E_Static = $8004000B;

  { User cancelled out of save dialog }
  OLE_E_PromptSaveCancelled = $8004000C;

  { Invalid rectangle }
  OLE_E_InvalidRect = $8004000D;

  { compobj.dll is too old for the ole2.dll initialized }
  OLE_E_WrongCompObj = $8004000E;

  { Invalid window handle }
  OLE_E_InvalidHWnd = $8004000F;

  { Object is not in any of the inplace active states }
  OLE_E_not_InplaceActive = $80040010;

  { Not able to convert object }
  OLE_E_CantConvert = $80040011;

  OLE_E_NoStorage = $80040012;

  { Invalid FORMATETC structure }
  DV_E_FormatEtc = $80040064;

  { Invalid DVTARGETDEVICE structure }
  DV_E_DvTargetDevice = $80040065;

  { Invalid STDGMEDIUM structure }
  DV_E_StgMedium = $80040066;

  { Invalid STATDATA structure }
  DV_E_StatData = $80040067;

  { Invalid lindex }
  DV_E_LIndex = $80040068;

  { Invalid tymed }
  DV_E_TYMED = $80040069;

  { Invalid clipboard format }
  DV_E_ClipFormat = $8004006A;

  { Invalid aspect(s) }
  DV_E_DvAspect = $8004006B;

  { tdSize parameter of the DVTARGETDEVICE structure is invalid }
  DV_E_DvTargetDevice_Size = $8004006C;

  { Object doesn't support IViewObject interface }
  DV_E_NoIViewObject = $8004006D;

  DragDrop_E_First = $80040100;
  DragDrop_E_Last  = $8004010F;
  DragDrop_S_First = $40100;

  { Trying to revoke a drop target that has not been registered }
  DragDrop_E_NotRegistered = $80040100;

  { This window has already been registered as a drop target }
  DragDrop_E_AlreadyRegistered = $80040101;

  { Invalid window handle }
  DragDrop_E_InvalidHWnd = $80040102;

  ClassFactory_E_First = $80040110;
  ClassFactory_E_LAST  = $8004011F;
  ClassFactory_S_FIRST = $40110;

  { Class does not support aggregation (or class object is remote) }
  CLASS_E_NoAggregation = $80040110;

  { ClassFactory cannot supply requested class }
  CLASS_E_ClassNotAvailable = $80040111;

  MARSHAL_E_First = $80040120;
  MARSHAL_E_Last  = $8004012F;
  MARSHAL_S_First = $40120;
  MARSHAL_S_Last  = $4012F;
  DATA_E_First    = $80040130;
  DATA_E_Last     = $8004013F;
  DATA_S_Fisrt    = $40130;
  DATA_S_Last     = $4013F;
  VIEW_E_First    = $80040140;
  VIEW_E_Last     = $8004014F;
  VIEW_S_First    = $40140;

  { Error drawing view }
  VIEW_E_Draw = $80040140;

  RegDB_E_First = $80040150;
  RegDB_E_Last  = $8004015F;
  RegDB_S_First = $40150;

  { Could not read key from registry }
  RegDB_E_ReadRegDB = $80040150;

  { Could not write key to registry }
  RegDB_E_WriteRegDB = $80040151;

  { Could not find the key in the registry }
  RegDB_E_KeyMissing = $80040152;

  { Invalid value for registry }
  RegDB_E_InvalidValue = $80040153;

  { Class not registered }
  RegDB_E_ClassNotReg = $80040154;

  { Interface not registered }
  RegDB_E_IIdNotReg = $80040155;

  CACHE_E_First = $80040170;
  CACHE_E_Last  = $8004017F;
  CACHE_S_First = $40170;

  { Cache not updated }
  CACHE_E_NoCache_Updated = $80040170;

  OleObj_E_First = $80040180;
  OleObj_E_Last  = $8004018F;
  OleObj_S_First = $40180;

  { No verbs for OLE object }
  OleObj_E_NoVerbs = $80040180;

  { Invalid verb for OLE object }
  OleObj_E_ImvalidVerb = $80040181;

  ClientSite_E_First = $80040190;
  ClientSite_E_Last = $8004019F;
  ClientSite_S_First = $40190;

  { Undo is not available }
  InPlace_E_NotUndoable = $800401A0;

  { Space for tools is not available }
  InPlace_E_NoToolSpace = $800401A1;

  InPlace_E_First = $800401A0;
  InPlace_E_Last  = $800401AF;
  InPlace_S_First = $401A0;
  InPlace_S_Last  = $401AF;
  ENUM_E_First = $800401B0;
  ENUM_E_Last  = $800401BF;
  ENUM_S_First = $401B0;
  ENUM_S_Last  = $401BF;
  Convert10_E_First = $800401C0;
  Convert10_E_Last  = $800401CF;
  Convert10_S_First = $401C0;

  { OLESTREAM Get method failed }
  Convert10_E_OleStream_Get = $800401C0;

  { OLESTREAM Put method failed }
  Convert10_E_OleStream_Put = $800401C1;

  { Contents of the OLESTREAM not in correct format }
  Convert10_E_OleStream_FMT = $800401C2;

  { There was an error in a Windows GDI call while converting the bitmap to a DIB }
  Convert10_E_OleStream_Bitmap_to_DIB = $800401C3;

  { Contents of the IStorage not in correct format }
  Convert10_E_STg_FMT = $800401C4;

  { Contents of IStorage is missing one of the standard streams }
  Convert10_E_STg_no_Std_Stream = $800401C5;

  Convert10_E_STg_DIB_to_Bitmap = $800401C6;

  ClipBrd_E_First = $800401D0;
  ClipBrd_E_Last  = $800401DF;
  ClipBrd_S_First = $401D0;

  { OpenClipboard Failed }
  ClipBrd_E_cant_Open = $800401D0;

  { EmptyClipboard Failed }
  ClipBrd_E_cant_Empty = $800401D1;

  { SetClipboard Failed }
  ClipBrd_E_cant_Set = $800401D2;

  { Data on clipboard is invalid }
  ClipBrd_E_bad_Data = $800401D3;

  { CloseClipboard Failed }
  ClipBrd_E_cant_Close = $800401D4;

  MK_E_First = $800401E0;
  MK_E_Last  = $800401EF;
  MK_S_First = $401E0;

  { Moniker needs to be connected manually }
  MK_E_ConnectManually = $800401E0;

  { Operation exceeded deadline }
  MK_E_ExceededDeadline = $800401E1;

  { Moniker needs to be generic }
  MK_E_NeedGeneric = $800401E2;

  { Operation unavailable }
  MK_E_Unavailable = $800401E3;

  { Invalid syntax }
  MK_E_Syntax = $800401E4;

  { No object for moniker }
  MK_E_NoObject = $800401E5;

  { Bad extension for file }
  MK_E_InvalidExtension = $800401E6;

  { Intermediate operation failed }
  MK_E_IntermediateInterfaceNotSup = $800401E7;

  { Moniker is not bindable }
  MK_E_NotBindable = $800401E8;

  { Moniker is not bound }
  MK_E_NotBound = $800401E9;

  { Moniker cannot open file }
  MK_E_CantOpenFile = $800401EA;

  { User input required for operation to succeed }
  MK_E_MustBotherUser = $800401EB;

  { Moniker class has no inverse }
  MK_E_NoInverse = $800401EC;

  { Moniker does not refer to storage }
  MK_E_NoStorage = $800401ED;

  { No common prefix }
  MK_E_NoPrefix = $800401EE;

  { Moniker could not be enumerated }
  MK_E_Enumeration_Failed = $800401EF;

  CO_E_First = $800401F0;
  CO_E_Last  = $800401FF;
  CO_S_First = $401F0;

  { CoInitialize has not been called. }
  CO_E_NotInitialized = $800401F0;

  { CoInitialize has already been called. }
  CO_E_AlreadyInitialized = $800401F1;

  { Class of object cannot be determined }
  CO_E_CantDetermineClass = $800401F2;

  { Invalid class string }
  CO_E_ClassString = $800401F3;

  { Invalid interface string }
  CO_E_IIdString = $800401F4;

  { Application not found }
  CO_E_AppNotFound = $800401F5;

  { Application cannot be run more than once }
  CO_E_AppSingleUse = $800401F6;

  { Some error in application program }
  CO_E_ErrorInApp = $800401F7;

  { DLL for class not found }
  CO_E_DllNotFound = $800401F8;

  { Error in the DLL }
  CO_E_ErrorInDll = $800401F9;

  { Wrong OS or OS version for application }
  CO_E_WrongOsForApp = $800401FA;

  { Object is not registered }
  CO_E_OjbNotReg = $800401FB;

  { Object is already registered }
  CO_E_ObjIsReg = $800401FC;

  { Object is not connected to server }
  CO_E_ObjNotConnected = $800401FD;

  { Application was launched but it didn't register a class factory }
  CO_E_AppDidntReg = $800401FE;

  { Object has been released }
  CO_E_Released = $800401FF;

  { Use the registry database to provide the requested information }
  OLE_S_UseReg = $40000;

  { Success, but static }
  OLE_S_Static = $40001;

  { Macintosh clipboard format }
  OLE_S_Mac_ClipFormat = $40002;

  { Successful drop took place }
  DragDrop_S_Drio = $40100;

  { Drag-drop operation canceled }
  DragDrop_S_Cancel = $40101;

  { Use the default cursor }
  DragDrop_S_UseDefaultCursors = $40102;

  { Data has same FORMATETC }
  DATA_S_SameFormatEtc = $40130;

  { View is already frozen }
  VIEW_S_Already_Frozen = $40140;

  { FORMATETC not supported }
  CACHE_S_FormatEtc_NotSupported = $40170;

  { Same cache }
  CACHE_S_SameCache = $40171;

  { Some cache(s) not updated }
  CACHE_S_SomeCaches_NotUpdated = $40172;

  { Invalid verb for OLE object }
  OleObj_S_InvalidVerb = $40180;

  { Verb number is valid but verb cannot be done now }
  OleObj_S_Cannot_DoVerb_NoW = $40181;

  { Invalid window handle passed }
  OleObj_S_InvalidHWnd = $40182;

  { Message is too long; some of it had to be truncated before displaying }
  Inplace_S_Truncated = $401A0;

  { Unable to convert OLESTREAM to IStorage }
  Convert10_S_no_Presentation = $401C0;

  { Moniker reduced to itself }
  MK_S_Reduced_to_Self = $401E2;

  { Common prefix is this moniker }
  MK_S_Me = $401E4;

  { Common prefix is input moniker }
  MK_S_Him = $401E5;

  { Common prefix is both monikers }
  MK_S_Us = $401E6;

  { Moniker is already registered in running object table }
  MK_S_MonikerAlreadyRegistered = $401E7;


  { FACILITY_WINDOWS }
  { Codes $0-$01ff are reserved for the OLE group of}

  { Attempt to create a class object failed }
  CO_E_Class_Create_Failed = $80080001;

  { OLE service could not bind object }
  CO_E_SCM_Error = $80080002;

  { RPC communication failed with OLE service }
  CO_E_SCM_RPC_Failure = $80080003;

  { Bad path to object }
  CO_E_Bad_Path = $80080004;

  { Server execution failed }
  CO_E_Server_Exec_Failure = $80080005;

  { OLE service could not communicate with the object server }
  CO_E_ObjSrv_RPC_Failure = $80080006;

  { Moniker path could not be normalized }
  MK_E_NO_Normalized = $80080007;

  { Object server is stopping when OLE service contacts it }
  CO_E_Server_Stopping = $80080008;

  { An invalid root block pointer was specified }
  Mem_E_Invalid_Root = $80080009;

  { An allocation chain contained an invalid link pointer }
  Mem_E_Invalid_Link = $80080010;

  { The requested allocation size was too large }
  MEM_E_Invalid_Size = $80080011;

  { Not all the requested interfaces were available }
  CO_S_NotAllInterfaces = $00080012;


  { FACILITY_DISPATCH }

  { Unknown interface. }
  Disp_E_UnknownInterface = $80020001;

  { Member not found. }
  Disp_E_MemberNotFound = $80020003;

  { Parameter not found. }
  Disp_E_ParamNotFound = $80020004;

  { Type mismatch. }
  Disp_E_TypeMismatch = $80020005;

  { Unknown name. }
  Disp_E_UnknownName = $80020006;

  { No named arguments. }
  Disp_E_NonamedArgs = $80020007;

  { Bad variable type. }
  Disp_E_BadVarType = $80020008;

  { Exception occurred. }
  Disp_E_Exception = $80020009;

  { Out of present range. }
  Disp_E_Overflow = $8002000A;

  { Invalid index. }
  Disp_E_BadIndex = $8002000B;

  { Unknown language. }
  Disp_E_UnknownLCId = $8002000C;

  { Memory is locked. }
  Disp_E_ArrayIsLocked = $8002000D;

  { Invalid number of parameters. }
  Disp_E_BadParamCount = $8002000E;

  { Parameter not optional. }
  Disp_E_ParamNotOptional = $8002000F;

  { Invalid callee. }
  Disp_E_BadCallee = $80020010;

  { Does not support a collection. }
  Disp_E_NotACollection = $80020011;

  { Buffer too small. }
  Type_E_BufferTooSmall = $80028016;

  { Old format or invalid type library. }
  Type_E_InvDataRead = $80028018;

  { Old format or invalid type library. }
  Type_E_UnsupFormat = $80028019;

  { Error accessing the OLE registry. }
  Type_E_RegistryAccess = $8002801C;

  { Library not registered. }
  Type_E_LibNotRegistered = $8002801D;

  { Bound to unknown type. }
  Type_E_UndefinedType = $80028027;

  { Qualified name disallowed. }
  Type_E_QualifiedNameDisallowed = $80028028;

  { Invalid forward reference, or reference to uncompiled type. }
  Type_E_InvalidState = $80028029;

  { Type mismatch. }
  Type_E_WrongTypeKind = $8002802A;

  { Element not found. }
  Type_E_ElementNotFound = $8002802B;

  { Ambiguous name. }
  Type_E_AmbiguousName = $8002802C;

  { Name already exists in the library. }
  Type_E_NameConflict = $8002802D;

  { Unknown LCID. }
  Type_E_UnknownLCID = $8002802E;

  { Function not defined in specified DLL. }
  Type_E_DllFunctionNotFound = $8002802F;

  { Wrong module kind for the operation. }
  Type_E_BadModuleKind = $800288BD;

  { Size may not exceed 64K. }
  Type_E_SizeTooBig = $800288C5;

  { Duplicate ID in inheritance hierarchy. }
  Type_E_DuplicateId = $800288C6;

  { Incorrect inheritance depth in standard OLE hmember. }
  Type_E_InvalidId = $800288CF;

  { Type mismatch. }
  Type_E_TypeMismatch = $80028CA0;

  { Invalid number of arguments. }
  Type_E_OutOfBounds = $80028CA1;

  { I/O Error. }
  Type_E_IoError = $80028CA2;

  { Error creating unique tmp file. }
  Type_E_CantCreateTmpFile = $80028CA3;

  { Error loading type library/DLL. }
  Type_E_CantLoadLibrary = $80029C4A;

  { Inconsistent property functions. }
  Type_E_InconsistentPropFuncs = $80029C83;

  { Circular dependency between types/modules. }
  Type_E_CircularType = $80029C84;


  { FACILITY_STORAGE }

  { Unable to perform requested operation. }
  STG_E_InvalidFunction = $80030001;

  { %l could not be found. }
  STG_E_FileNotFound = $80030002;

  { The path %l could not be found. }
  STG_E_PathNotFound = $80030003;

  { There are insufficient resources to open another file. }
  STG_E_TooManyOpenFiles = $80030004;

  { Access Denied. }
  STG_E_AccessDenied = $80030005;

  { Attempted an operation on an invalid object. }
  STG_E_InvalidHandle = $80030006;

  { There is insufficient memory available to complete operation. }
  STG_E_InsufficientMemory = $80030008;

  { Invalid pointer error. }
  STG_E_InvalidPointer = $80030009;

  { There are no more entries to return. }
  STG_E_NoMoreFiles = $80030012;

  { Disk is write-protected. }
  STG_E_DiskIsWriteProtected = $80030013;

  { An error occurred during a seek operation. }
  STG_E_SeekError = $80030019;

  { A disk error occurred during a write operation. }
  STG_E_WriteFault = $8003001D;

  { A disk error occurred during a read operation. }
  STG_E_ReadFault = $8003001E;

  { A share violation has occurred. }
  STG_E_ShareViolation = $80030020;

  { A lock violation has occurred. }
  STG_E_LockViolation = $80030021;

  { %l already exists. }
  STG_E_FileAlreadyExists = $80030050;

  { Invalid parameter error. }
  STG_E_InvalidParameter = $80030057;

  { There is insufficient disk space to complete operation. }
  STG_E_MediumFull = $80030070;

  { Illegal write of non-simple property to simple property set. }
  STG_E_PropSetMismatched = $800300F0;

  { An API call exited abnormally. }
  STG_E_AbnormalApiExit = $800300FA;

  { The file %l is not a valid compound file. }
  STG_E_InvalidHeader = $800300FB;

  { The name %l is not valid. }
  STG_E_InvalidName = $800300FC;

  { An unexpected error occurred. }
  STG_E_Unknown = $800300FD;

  { That function is not implemented. }
  STG_E_UnimplementedFunction = $800300FE;

  { Invalid flag error. }
  STG_E_InvalidFlag = $800300FF;

  { Attempted to use an object that is busy. }
  STG_E_InUse = $80030100;

  { The storage has been changed since the last commit. }
  STG_E_NotCurrent = $80030101;

  { Attempted to use an object that has ceased to exist. }
  STG_E_Reverted = $80030102;

  { Can't save. }
  STG_E_CantSave = $80030103;

  { The compound file %l was produced with an incompatible version of storage. }
  STG_E_OldFormat = $80030104;

  { The compound file %l was produced with a newer version of storage. }
  STG_E_OldDll = $80030105;

  { Share.exe or equivalent is required for operation. }
  STG_E_ShareRequired = $80030106;

  { Illegal operation called on non-file based storage. }
  STG_E_NotFileBasedStorage = $80030107;

  { Illegal operation called on object with extant marshallings. }
  STG_E_ExtantMarshallings = $80030108;

  { The docfile has been corrupted. }
  STG_E_DocFileCorrupt = $80030109;

  { OLE32.DLL has been loaded at the wrong address. }
  STG_E_BadBaseAddress = $80030110;

  { The file download was aborted abnormally.  The file is incomplete. }
  STG_E_Incomplete = $80030201;

  { The file download has been terminated. }
  STG_E_Terminated = $80030202;

  { The underlying file was converted to compound file format. }
  STG_S_Converted = $00030200;

  { The storage operation should block until more data is available. }
  STG_S_Block = $00030201;

  { The storage operation should retry immediately. }
  STG_S_RetryNow = $00030202;

  { The notified event sink will not influence the storage operation. }
  STG_S_Monitoring = $00030203;


  { FACILITY_RPC }

  { Call was rejected by callee. }
  RPC_E_Call_Rejected = $80010001;

  { Call was canceled by the message filter. }
  RPC_E_Call_Canceled = $80010002;

  { The caller is dispatching an intertask SendMessage call and }
  { cannot call out via PostMessage. }
  RPC_E_CantPost_InSendCall = $80010003;

  { The caller is dispatching an asynchronous call and cannot }
  { make an outgoing call on behalf of this call. }
  RPC_E_CantCallOut_InAsyncCall = $80010004;

  { It is illegal to call out while inside message filter. }
  RPC_E_CantCallOut_InExternalCall = $80010005;

  { The connection terminated or is in a bogus state }
  { and cannot be used any more. Other connections }
  { are still valid. }
  RPC_E_Connection_Terminated = $80010006;

  { The callee (server [not server application]) is not available }
  { and disappeared; all connections are invalid.  The call may }
  { have executed. }
  RPC_E_Server_Died = $80010007;

  { The caller (client) disappeared while the callee (server) was }
  { processing a call. }
  RPC_E_Client_Died = $80010008;

  { The data packet with the marshalled parameter data is incorrect. }
  RPC_E_Invalid_DataPacket = $80010009;

  { The call was not transmitted properly; the message queue }
  { was full and was not emptied after yielding. }
  RPC_E_CantTransmit_Call = $8001000A;

  { The client (caller) cannot marshall the parameter data - low memory, etc. }
  RPC_E_Client_CantMarshal_Data = $8001000B;

  { The client (caller) cannot unmarshall the return data - low memory, etc. }
  RPC_E_Client_CantUnmarshal_Data = $8001000C;

  { The server (callee) cannot marshall the return data - low memory, etc. }
  RPC_E_Server_CantMarshal_Data = $8001000D;

  { The server (callee) cannot unmarshall the parameter data - low memory, etc. }
  RPC_E_Server_CantUnmarshal_Data = $8001000E;

  { Received data is invalid; could be server or client data. }
  RPC_E_Invalid_Data = $8001000F;

  { A particular parameter is invalid and cannot be (un)marshalled. }
  RPC_E_Invalid_Parameter = $80010010;

  { There is no second outgoing call on same channel in DDE conversation. }
  RPC_E_CantCallOut_Again = $80010011;

  { The callee (server [not server application]) is not available }
  { and disappeared; all connections are invalid.  The call did not execute. }
  RPC_E_Server_Died_DNE = $80010012;

  { System call failed. }
  RPC_E_Sys_Call_Failed = $80010100;

  { Could not allocate some required resource (memory, events, ...) }
  RPC_E_Out_Of_Resources = $80010101;

  { Attempted to make calls on more than one thread in single threaded mode. }
  RPC_E_Attempted_MultiThread = $80010102;

  { The requested interface is not registered on the server object. }
  RPC_E_Not_Registered = $80010103;

  { RPC could not call the server or could not return the results of calling the server. }
  RPC_E_Fault = $80010104;

  { The server threw an exception. }
  RPC_E_ServerFault = $80010105;

  { Cannot change thread mode after it is set. }
  RPC_E_Changed_Mode = $80010106;

  { The method called does not exist on the server. }
  RPC_E_InvalidMethod = $80010107;

  { The object invoked has disconnected from its clients. }
  RPC_E_Disconnected = $80010108;

  { The object invoked chose not to process the call now.  Try again later. }
  RPC_E_Retry = $80010109;

  { The message filter indicated that the application is busy. }
  RPC_E_ServerCall_RetryLater = $8001010A;

  { The message filter rejected the call. }
  RPC_E_ServerCall_Rejected = $8001010B;

  { A call control interfaces was called with invalid data. }
  RPC_E_Invalid_CallData = $8001010C;

  { An outgoing call cannot be made since the application is dispatching an input-synchronous call. }
  RPC_E_CantCallOut_InInputSyncCal = $8001010D;

  { The application called an interface that was marshalled for a different thread. }
  RPC_E_Wrong_Thread = $8001010E;

  { CoInitialize has not been called on the current thread. }
  RPC_E_Thread_Not_Init = $8001010F;

  { The version of OLE on the client and server machines does not match. }
  RPC_E_Version_Mismatch = $80010110;

  { OLE received a packet with an invalid header. }
  RPC_E_Invalid_Header = $80010111;

  { OLE received a packet with an invalid extension. }
  RPC_E_Invalid_Extension = $80010112;

  { The requested object or interface does not exist. }
  RPC_E_Invalid_IPID = $80010113;

  { The requested object does not exist. }
  RPC_E_Invalid_Object = $80010114;

  { OLE has sent a request and is waiting for a reply. }
  RPC_S_CallPending = $80010115;

  { OLE is waiting before retrying a request. }
  RPC_S_WaitOnTimer = $80010116;

  { Call context cannot be accessed after call completed. }
  RPC_E_Call_Complete = $80010117;

  { Impersonate on unsecure calls is not supported. }
  RPC_E_Unsecure_Call = $80010118;

  { Security must be initialized before any interfaces are marshalled or }
  RPC_E_Too_Late = $80010119;

  { No security packages are installed on this machine or the user is not logged }
  RPC_E_No_Good_Security_Packages = $8001011A;

  { Access is denied. }
  RPC_E_Access_Denied = $8001011B;

  { Remote calls are not allowed for this process. }
  RPC_E_Remote_Disabled = $8001011C;

  { The marshaled interface data packet (OBJREF) has an invalid or unknown format. }
  RPC_E_Invalid_ObjRef = $8001011D;

  { An internal error occurred. }
  RPC_E_Unexpected = $8001FFFF;


{ FACILITY_SSPI }

  { Bad UID. }
  NTE_Bad_UID = $80090001;

  { Bad Hash. }
  NTE_Bad_Hash = $80090002;

  { Bad Key. }
  NTE_Bad_Key = $80090003;

  { Bad Length. }
  NTE_Bad_Len = $80090004;

  { Bad Data. }
  NTE_Bad_Data = $80090005;

  { Invalid Signature. }
  NTE_Bad_Signature = $80090006;

  { Bad Version of provider. }
  NTE_Bad_Ver = $80090007;

  { Invalid algorithm specified. }
  NTE_Bad_AlgId = $80090008;

  { Invalid flags specified. }
  NTE_Bad_Flags = $80090009;

  { Invalid type specified. }
  NTE_Bad_Type = $8009000A;

  { Key not valid for use in specified state. }
  NTE_Bad_Key_State = $8009000B;

  { Hash not valid for use in specified state. }
  NTE_Bad_Hash_State = $8009000C;

  { Key does not exist. }
  NTE_No_Key = $8009000D;

  { Insufficient memory available for the operation. }
  NTE_No_Memory = $8009000E;

  { Object already exists. }
  NTE_Exists = $8009000F;

  { Access denied. }
  NTE_Perm = $80090010;

  { Object was not found. }
  NTE_Not_Found = $80090011;

  { Data already encrypted. }
  NTE_Double_Encrypt = $80090012;

  { Invalid provider specified. }
  NTE_Bad_Provider = $80090013;

  { Invalid provider type specified. }
  NTE_Bad_Prov_Type = $80090014;

  { Provider's public key is invalid. }
  NTE_Bad_Public_Key = $80090015;

  { Keyset does not exist }
  NTE_Bad_KeySet = $80090016;

  { Provider type not defined. }
  NTE_Prov_Type_Not_Def = $80090017;

  { Provider type as registered is invalid. }
  NTE_Prov_Type_Entry_Bad = $80090018;

  { The keyset is not defined. }
  NTE_KeySet_Not_Def = $80090019;

  { Keyset as registered is invalid. }
  NTE_KeySet_Entry_Bad = $8009001A;

  { Provider type does not match registered value. }
  NTE_Prov_Type_no_Match = $8009001B;

  { The digital signature file is corrupt. }
  NTE_Signature_File_Bad = $8009001C;

  { Provider DLL failed to initialize correctly. }
  NTE_Provider_DLL_Fail = $8009001D;

  { Provider DLL could not be found. }
  NTE_Prov_DLL_not_Found = $8009001E;

  { The Keyset parameter is invalid. }
  NTE_Bad_KeySet_Param = $8009001F;

  { An internal error occurred. }
  NTE_Fail = $80090020;

  { A base error occurred. }
  NTE_Sys_Err = $80090021;

  NTE_Op_Ok = 0;

{ FACILITY_CERT }

  { The specified trust provider is not known on this system. }
  Trust_E_Provider_Unknown = $800B0001;

  { The trust verification action specified is not supported by the specified trust provider. }
  Trust_E_Action_Unknown = $800B0002;

  { The form specified for the subject is not one supported or known by the specified trust provider. }
  Trust_E_Subject_Form_Unknown = $800B0003;

  { The subject is not trusted for the specified action. }
  Trust_E_Subject_not_Trusted = $800B0004;

  { Error due to problem in ASN.1 encoding process. }
  DigSig_E_Encode = $800B0005;

  { Error due to problem in ASN.1 decoding process. }
  DigSig_E_Decode = $800B0006;

  { Reading / writing Extensions where Attributes are appropriate, and visa versa. }
  DigSig_E_Extensibility = $800B0007;

  { Unspecified cryptographic failure. }
  DigSig_E_Crypto = $800B0008;

  { The size of the data could not be determined. }
  Persist_E_SizeDefinite = $800B0009;

  { The size of the indefinite-sized data could not be determined. }
  Persist_E_SizeIndefinite = $800B000A;

  { This object does not read and write self-sizing data. }
  Persist_E_NotSelfSizing = $800B000B;

  { No signature was present in the subject. }
  Trust_E_NoSignature = $800B0100;

  { A required certificate is not within its validity period. }
  Cert_E_Expired = $800B0101;

  { The validity periods of the certification chain do not nest correctly. }
  Cert_E_ValidiyPeriodNesting = $800B0102;

  { A certificate that can only be used as an end-entity is being used as a CA or visa versa. }
  Cert_E_Role = $800B0103;

  { A path length constraint in the certification chain has been violated. }
  Cert_E_PathLenConst = $800B0104;

  { An extension of unknown type that is labeled 'critical' is present in a certificate. }
  Cert_E_Critical = $800B0105;

  { A certificate is being used for a purpose other than that for which it is permitted. }
  Cert_E_Purpose = $800B0106;

  { A parent of a given certificate in fact did not issue that child certificate. }
  Cert_E_IssuerChaining = $800B0107;

  { A certificate is missing or has an empty value for an important field, such as a subject or issuer name. }
  Cert_E_Malformed = $800B0108;

  { A certification chain processed correctly, but terminated in a root certificate which isn't trusted by the trust provider. }
  Cert_E_UntrustedRoot = $800B0109;

  { A chain of certs didn't chain as they should in a certain application of chaining. }
  Cert_E_Chaining = $800B010A;

{ End WINERROR.H }


  { Abnormal termination codes }

  TC_Normal = 0;
  TC_HardErr = 1;
  TC_GP_Trap = 2;
  TC_Signal = 3;

  { Power Management APIs }

  AC_Line_Offline = 0;
  AC_Line_Online = 1;
  AC_Line_Backup_Power = 2;
  AC_Line_Unknown = 255;

  Battery_Flag_High = 1;
  Battery_Flag_Low = 2;
  Battery_Flag_Critical = 4;
  Battery_Flag_Charging = 8;
  Battery_Flag_no_Battery = $80;
  Battery_Flag_Unknown = 255;
  Battery_Percentage_Unknown = 255;
  Battery_Life_Unknown = $FFFFFFFF;

type
  PSystemPowerStatus = ^TSystemPowerStatus;
  TSystemPowerStatus = packed record
    ACLineStatus : Byte;
    BatteryFlag : Byte;
    BatteryLifePercent : Byte;
    Reserved1 : Byte;
    BatteryLifeTime : DWord;
    BatteryFullLifeTime : DWord;
  end;

function GetSystemPowerStatus(var lpSystemPowerStatus: TSystemPowerStatus): Bool;
function SetSystemPowerState(fSuspend, fForce: Bool): Bool;


{ Win Certificate API and Structures }

{ Structures }
type
  PWinCertificate = ^TWinCertificate;
  TWinCertificate = packed record
    dwLength: DWord;
    wRevision: Word;
    wCertificateType: Word;         { WIN_CERT_TYPE_xxx }
    bCertificate: packed array[0..0] of Byte;
  end;

{ Currently, the only defined certificate revision is WIN_CERT_REVISION_1_0 }

const
  WIN_CERT_REVISION_1_0 = $0100;

{ Possible certificate types are specified by the following values }

  Win_Cert_Type_X509 = $0001;                        { bCertificate contains an X.509 Certificate }
  Win_Cert_Type_PKCS_Signed_Data = $0002;            { bCertificate contains a PKCS SignedData structure }
  Win_Cert_Type_Reserved_1 = $0003;                  { Reserved }

{ API }

function WinSubmitCertificate(var lpCertificate: TWinCertificate): Bool;

const
  HGDI_Error = $FFFFFFFF;

  { PolyFill() Modes }
  PolyFill_Last = 2;

  { Text Alignment Options }
  TA_RtlReading = $100;


  ETO_Glyph_Index = $10;
  ETO_RtlReading = $80;
  ETO_IgnoreLanguage = $1000;

  Aspect_Filtering = 1;

  { Flag returned from QUERYDIBSUPPORT }
  QDI_SetDibIts = 1;
  QDI_GetDibIts = 2;
  QDI_DibToScreen = 4;
  QDI_StretchDib = 8;


  { Spooler Error Codes }

  PR_JobStatus = 0;


  { xform stuff }

  MWT_Min = MWT_Identity;
  MWT_Max = MWT_RightMultiply;


type
  { Image Color Matching color definitions }
  LCSCSType = Longint;
const
  LCS_Calibrated_RGB = 0;
  LCS_Device_RGB = 1;
  LCS_Device_CMYK = 2;

type
  LCSGamutMatch = Longint;
const
  LCS_GM_Business = 1;
  LCS_GM_Graphics = 2;
  LCS_GM_Images = 4;


  { ICM Defines for results from CheckColorInGamut() }
  CM_out_of_Gamut = 255;
  CM_in_Gamut = 0;


{ functions to retrieve CMYK values from a COLORREF }

function GetCValue(cmyk: TColorRef): Byte;
function GetMValue(cmyk: TColorRef): Byte;
function GetYValue(cmyk: TColorRef): Byte;
function GetKValue(cmyk: TColorRef): Byte;
function CMYK(c, m, y, k: Byte): TColorRef;

type
  FxPt16Dot16 = Longint;
  LPFxPt16Dot16 = ^Longint;
  FxPt2Dot30 = Longint;
  LPFxPt2Dot30 = ^Longint;


  { ICM Color Definitions }
  { The following two structures are used for defining RGB's in terms of
    CIEXYZ. The values are fixed point 16.16. }

  PCIEXYZ = ^TCIEXYZ;
  TCIEXYZ = packed record
    ciexyzX: FXPT2DOT30;
    ciexyzY: FXPT2DOT30;
    ciexyzZ: FXPT2DOT30;
  end;

  PCIEXYZTriple = ^TCIEXYZTriple;
  TCIEXYZTriple = packed record
    ciexyzRed: TCIEXYZ;
    ciexyzGreen: TCIEXYZ;
    ciexyzBlue: TCIEXYZ;
  end;

  { The next structures the logical color space. Unlike pens and brushes,
    but like palettes, there is only one way to create a LogColorSpace.
    A pointer to it must be passed, its elements can't be pushed as
    arguments. }

type
  PLogColorSpace = ^TLogColorSpace;
  PLogColorSpaceA = ^TLogColorSpaceA;
  PLogColorSpaceW = ^TLogColorSpaceW;
  TLogColorSpace = packed record
    lcsSignature: DWord;
    lcsVersion: DWord;
    lcsSize: DWord;
    lcsCSType: LCSCSTYPE;
    lcsIntent: LCSGAMUTMATCH;
    lcsEndpoints: TCIEXYZTriple;
    lcsGammaRed: DWord;
    lcsGammaGreen: DWord;
    lcsGammaBlue: DWord;
    lcsFilename: array[0..259] of AnsiChar;
  end;
  TLogColorSpaceW = packed record
    lcsSignature: DWord;
    lcsVersion: DWord;
    lcsSize: DWord;
    lcsCSType: LCSCSTYPE;
    lcsIntent: LCSGAMUTMATCH;
    lcsEndpoints: TCIEXYZTriple;
    lcsGammaRed: DWord;
    lcsGammaGreen: DWord;
    lcsGammaBlue: DWord;
    lcsFilename: array[0..259] of WideChar;
  end;
  tLogColorSpaceA = tLogColorSpace;

  PBitmapV4Header = ^TBitmapV4Header;
  TBitmapV4Header = packed record
    bV4Size: DWord;
    bV4Width: Longint;
    bV4Height: Longint;
    bV4Planes: Word;
    bV4BitCount: Word;
    bV4V4Compression: DWord;
    bV4SizeImage: DWord;
    bV4XPelsPerMeter: Longint;
    bV4YPelsPerMeter: Longint;
    bV4ClrUsed: DWord;
    bV4ClrImportant: DWord;
    bV4RedMask: DWord;
    bV4GreenMask: DWord;
    bV4BlueMask: DWord;
    bV4AlphaMask: DWord;
    bV4CSType: DWord;
    bV4Endpoints: TCIEXYZTriple;
    bV4GammaRed: DWord;
    bV4GammaGreen: DWord;
    bV4GammaBlue: DWord;
  end;

type
  PFontSignature = ^TFontSignature;
  TFontSignature = packed record
    fsUsb: array[0..3] of DWord;
    fsCsb: array[0..1] of DWord;
  end;

  PCharsetInfo = ^TCharsetInfo;
  TCharsetInfo = packed record
    ciCharset: UInt;
    ciACP: UInt;
    fs: TFontSignature;
  end;

const
  TCI_SrcCharset = 1;
  TCI_SrcCodePage = 2;
  TCI_SrcFontSig = 3;

type
  PLocaleSignature = ^TLocaleSignature;
  TLocaleSignature = packed record
    lsUsb: array[0..3] of DWord;
    lsCsbDefault: array[0..1] of DWord;
    lsCsbSupported: array[0..1] of DWord;
  end;

const
  { tmPitchAndFamily flags }
  TMPF_Fixed_Pitch = 1;
  TMPF_Vector = 2;
  TMPF_Device = 8;
  TMPF_Truetype = 4;

const
  { ntmFlags field flags }
  NTM_Regular = $40;
  NTM_Bold = $20;
  NTM_Italic = 1;

type
  PNewTextMetric = ^TNewTextMetric;
  TNewTextMetric = record
    tmHeight: Longint;
    tmAscent: Longint;
    tmDescent: Longint;
    tmInternalLeading: Longint;
    tmExternalLeading: Longint;
    tmAveCharWidth: Longint;
    tmMaxCharWidth: Longint;
    tmWeight: Longint;
    tmOverhang: Longint;
    tmDigitizedAspectX: Longint;
    tmDigitizedAspectY: Longint;
    tmFirstChar: AnsiChar;
    tmLastChar: AnsiChar;
    tmDefaultChar: AnsiChar;
    tmBreakChar: AnsiChar;
    tmItalic: Byte;
    tmUnderlined: Byte;
    tmStruckOut: Byte;
    tmPitchAndFamily: Byte;
    tmCharSet: Byte;
    ntmFlags: DWord;
    ntmSizeEM: UInt;
    ntmCellHeight: UInt;
    ntmAvgWidth: UInt;
  end;

  PNewTextMetricEx = ^TNewTextMetricEx;
  TNewTextMetricEx = packed record
    ntmTm: TNewTextMetric;
    ntmFontSig: TFontSignature;
  end;

{ GDI Logical Objects: }

  { Pel Array }
  PPelArray = ^TPelArray;
  TPelArray = record
    paXCount: Longint;
    paYCount: Longint;
    paXExt: Longint;
    paYExt: Longint;
    paRGBs: Byte;
  end;

  PPattern = ^TPattern;
  TPattern = TLogBrush;

  PMaxLogPalette = ^TMaxLogPalette;
  TMaxLogPalette = packed record
    palVersion: Word;
    palNumEntries: Word;
    palPalEntry: array [Byte] of TPaletteEntry;
  end;

const
  LF_FullFaceSize = 64;

type
  { Structure passed to FONTENUMPROC }
  PEnumLogFont = ^TEnumLogFont;
  TEnumLogFont = packed record
    elfLogFont: TLogFont;
    elfFullName: array[0..LF_FullFaceSize - 1] of Char;
    elfStyle: array[0..LF_FaceSize - 1] of Char;
  end;

  PEnumLogFontEx = ^TEnumLogFontEx;
  TEnumLogFontEx = packed record
    elfLogFont: TLogFont;
    elfFullName: array[0..LF_FullFaceSize - 1] of Char;
    elfStyle: array[0..LF_FaceSize - 1] of Char;
    elfScript: array[0..LF_FaceSize - 1] of Char;
  end;

const
  OUT_Screen_Outline_Precis = 9;

  NonAntiAliased_Quality = 3;
  AntiAliased_Quality = 4;

  Mono_Font = 8;

  Vietnamese_Charset = 163;

  Mac_Charset = 77;
  Baltic_Charset = 186;

  FS_Latin1 = 1;
  FS_Latin2 = 2;
  FS_Cyrillic = 4;
  FS_Greek = 8;
  FS_Turkish = $10;
  FS_Hebrew = $20;
  FS_Arabic = $40;
  FS_Baltic = $80;
  FS_Vietnamese = $00000100;
  FS_Thai = $10000;
  FS_JisJapan = $20000;
  FS_ChineseSimp = $40000;
  FS_Wansung = $80000;
  FS_ChineseTrad = $100000;
  FS_Johab = $200000;
  FS_Symbol = $80000000;

  { Font Weights }

  Panose_Count = 10;
  PAN_FamilyType_Index = 0;
  PAN_SerifStyle_Index = 1;
  PAN_Weight_Index = 2;
  PAN_Proportion_Index = 3;
  PAN_Contrast_Index = 4;
  PAN_StrokeVariation_Index = 5;
  PAN_ArmStyle_Index = 6;
  PAN_LetterForm_Index = 7;
  PAN_MidLine_Index = 8;
  PAN_XHeight_Index = 9;

  PAN_Culture_Latin = 0;

const
  PAN_any = 0;
  PAN_no_fit = 1;

  PAN_Family_Text_Display = 2;
  PAN_Family_Script = 3;
  PAN_Family_Decorative = 4;
  PAN_Family_Pictorial = 5;

  PAN_Serif_Cove = 2;
  PAN_Serif_Obtuse_Cove = 3;
  PAN_Serif_Square_Cove = 4;
  PAN_Serif_Obtuse_Square_Cove = 5;
  PAN_Serif_Square = 6;
  PAN_Serif_Thin = 7;
  PAN_Serif_Bone = 8;
  PAN_Serif_Exaggerated = 9;
  PAN_Serif_Triangle = 10;
  PAN_Serif_Normal_Sans = 11;
  PAN_Serif_Obtuse_Sans = 12;
  PAN_Serif_Perp_Sans = 13;
  PAN_Serif_Flared = 14;
  PAN_Serif_Rounded = 15;

  PAN_Weight_Very_Light = 2;
  PAN_Weight_Light = 3;
  PAN_Weight_Thin = 4;
  PAN_Weight_Book = 5;
  PAN_Weight_Medium = 6;
  PAN_Weight_Demi = 7;
  PAN_Weight_Bold = 8;
  PAN_Weight_Heavy = 9;
  PAN_Weight_Black = 10;
  PAN_Weight_Nord = 11;

  PAN_Prop_Old_Style = 2;
  PAN_Prop_Modern = 3;
  PAN_Prop_Even_Width = 4;
  PAN_Prop_Expanded = 5;
  PAN_Prop_Condensed = 6;
  PAN_Prop_Very_Expanded = 7;
  PAN_Prop_Very_Condensed = 8;
  PAN_Prop_MonoSpaced = 9;

  PAN_Contrast_None = 2;
  PAN_Contrast_Very_Low = 3;
  PAN_Contrast_Low = 4;
  PAN_Contrast_Medium_Low = 5;
  PAN_Contrast_Medium = 6;
  PAN_Contrast_Medium_High = 7;
  PAN_Contrast_High = 8;
  PAN_Contrast_Very_High = 9;

  PAN_Stroke_Gradual_Diag = 2;
  PAN_Stroke_Gradual_Tran = 3;
  PAN_Stroke_Gradual_Vert = 4;
  PAN_Stroke_Gradual_Horz = 5;
  PAN_Stroke_Rapid_Vert = 6;
  PAN_Stroke_Rapid_Horz = 7;
  PAN_Stroke_Instant_Vert = 8;

  PAN_Straight_Arms_Horz = 2;
  PAN_Straight_Arms_Wedge = 3;
  PAN_Straight_Arms_Vert = 4;
  PAN_Straight_Arms_Single_Serif = 5;
  PAN_Straight_Arms_Double_Serif = 6;
  PAN_Bent_Arms_Horz = 7;
  PAN_Bent_Arms_WedgE = 8;
  PAN_Bent_Arms_Vert = 9;
  PAN_Bent_Arms_Single_Serif = 10;
  PAN_Bent_Arms_Double_Serif = 11;

  PAN_Lett_Normal_Contact = 2;
  PAN_Lett_Normal_Weighted = 3;
  PAN_Lett_Normal_Boxed = 4;
  PAN_Lett_Normal_Flattened = 5;
  PAN_Lett_Normal_Rounded = 6;
  PAN_Lett_Normal_off_Center = 7;
  PAN_Lett_Normal_Square = 8;
  PAN_Lett_Oblique_Contact = 9;
  PAN_Lett_Oblique_Weighted = 10;
  PAN_Lett_Oblique_Boxed = 11;
  PAN_Lett_Oblique_Flattened = 12;
  PAN_Lett_Oblique_Rounded = 13;
  PAN_Lett_Oblique_off_Center = 14;
  PAN_Lett_Oblique_Square = 15;

  PAN_MidLine_Standard_Trimmed = 2;
  PAN_MidLine_Standard_Pointed = 3;
  PAN_MidLine_Standard_Serifed = 4;
  PAN_MidLine_High_Trimmed = 5;
  PAN_MidLine_High_Pointed = 6;
  PAN_MidLine_High_Serifed = 7;
  PAN_MidLine_Constant_Trimmed = 8;
  PAN_MidLine_Constant_Pointed = 9;
  PAN_MidLine_Constant_Serifed = 10;
  PAN_MidLine_Low_Trimmed = 11;
  PAN_MidLine_Low_Pointed = 12;
  PAN_MidLine_Low_Serifed = 13;

  PAN_XHeight_Constant_Small = 2;
  PAN_XHeight_Constant_Std = 3;
  PAN_XHeight_Constant_Large = 4;
  PAN_XHeight_Ducking_Small = 5;
  PAN_XHeight_Ducking_Std = 6;
  PAN_XHeight_Ducking_Large = 7;

  ELF_Vendor_Size = 4;

{ The extended logical font       }
{ An extension of the ENUMLOGFONT }

type
  PExtLogFont = ^TExtLogFont;
  TExtLogFont = record
    elfLogFont: TLogFont;
    elfFullName: array[0..LF_FULLFACESIZE - 1] of Char;
    elfStyle: array[0..LF_FACESIZE - 1] of Char;
    elfVersion: DWord;     { 0 for the first release of NT }
    elfStyleSize: DWord;
    elfMatch: DWord;
    elfReserved: DWord;
    elfVendorId: array[0..ELF_VENDOR_SIZE - 1] of Byte;
    elfCulture: DWord;     { 0 for Latin }
    elfPanose: TPanose;
  end;

const
  ELF_VERSION = 0;
  ELF_CULTURE_LATIN = 0;

function RGB(r, g, b: Byte): TColorRef;
function PaletteRGB(r, g, b: Byte): TColorRef;
function PaletteIndex(i: Word): TColorRef;
function GetRValue(rgb: DWord): Byte;
function GetGValue(rgb: DWord): Byte;
function GetBValue(rgb: DWord): Byte;

const
  { Graphics Modes }
  GM_Last = 2;
  { Min and Max Mapping Mode values }
  MM_Min = MM_Text;
  MM_Max = MM_Anisotropic;
  MM_Max_FixedScale = MM_TWIPS;

  { Coordinate Modes }
  Absolute = 1;
  Relative = 2;

  { Stock Logical Objects }
  Default_GUI_Font = 17;


  { Brush Styles }
  BS_MonoPattern          = 9;

  NumBrushes    = $10;   { Number of brushes the device has          }
  NumPens       = 18;    { Number of pens the device has             }
  NumMarkers    = 20;    { Number of markers the device has          }

  { Display driver specific}
  VRefresh       = 116;     { Current vertical refresh rate of the     }
                            { display device (for displays only) in Hz}
  DesktopVertRes = 117;     { Horizontal width of entire desktop in    }
                            { pixels                                  }
  DesktopHorzRes = 118;     { Vertical height of entire desktop in     }
                            { pixels                                  }
  BltAlignment   = 119;     { Preferred blt alignment                  }


{ Device Capability Masks: }

{ Device Technologies }

  DT_CharStream = 4;     { Character-stream, PLP             }
  DT_DispFile   = 6;     { Display-file                      }

{ Polygonal Capabilities }

  PC_PolyPolygon = $100;  { Can do polypolygons               }
  PC_Paths       = $200;  { Can do paths                      }

{ Clipping Capabilities }

  CP_None      = 0;     { No clipping of output             }
  CP_Rectangle = 1;     { Output clipped to rects           }
  CP_Region    = 2;     { obsolete                          }

{ Text Capabilities }

  TC_OP_Character = 1;      { Can do OutputPrecision   CHARACTER       }
  TC_OP_Stroke    = 2;      { Can do OutputPrecision   STROKE          }
  TC_CP_Stroke    = 4;      { Can do ClipPrecision     STROKE          }
  TC_SA_Double    = $40;    { Can do ScaleAbility      DOUBLE          }
  TC_EA_Double    = $200;   { Can do EmboldenAbility   DOUBLE          }

{ Raster Capabilities }

  RC_GDI20_Output = $10;   { has 2.0 output calls          }
  RC_GDI20_State  = $20;
  RC_SaveBitmap   = $40;
  RC_BigFont      = $400;  { supports >64K fonts           }
  RC_OP_Dx_Output = $4000;
  RC_DevBits      = $8000;

const

{ field selection bits }

  DM_LogPixels = $20000;
  DM_BitsPerPel = $40000;
  DM_PelsWidth = $80000;
  DM_PelsHeight = $100000;
  DM_DisplayFlags = $200000;
  DM_DisplayFrequency = $400000;
  DM_PanningWidth = $00800000;
  DM_PanningHeight = $01000000;
  DM_IcmMethod = $2000000;
  DM_IcmIntent = $4000000;
  DM_MediaType = $8000000;
  DM_DitherType = $10000000;
  DM_IccManufacturer = $20000000;
  DM_IccModel = $40000000;

{ orientation selections }

{ paper selections }

  DmPaper_ISO_B4             = 42;  { B4 (ISO) 250 x 353 mm               }
  DmPaper_Japanese_Postcard  = 43;  { Japanese Postcard 100 x 148 mm      }
  DmPaper_9X11               = 44;  { 9 x 11 in                           }
  DmPaper_10X11              = 45;  { 10 x 11 in                          }
  DmPaper_15X11              = 46;  { 15 x 11 in                          }
  DmPaper_Env_Invite         = 47;  { Envelope Invite 220 x 220 mm        }
  DmPaper_Reserved_48        = 48;  { RESERVED--DO NOT USE                }
  DmPaper_Reserved_49        = 49;  { RESERVED--DO NOT USE                }
  DmPaper_Letter_Extra       = 50;  { Letter Extra 9 \275 x 12 in         }
  DmPaper_Legal_Extra        = 51;  { Legal Extra 9 \275 x 15 in          }
  DmPaper_Tabloid_Extra      = 52;  { Tabloid Extra 11.69 x 18 in         }
  DmPaper_A4_Extra           = 53;  { A4 Extra 9.27 x 12.69 in            }
  DmPaper_Letter_Transverse  = 54;  { Letter Transverse 8 \275 x 11 in    }
  DmPaper_A4_Transverse      = 55;  { A4 Transverse 210 x 297 mm          }
  DmPaper_Letter_Extra_Transverse = 56;     { Letter Extra Transverse 9\275 x 12 in  }
  DmPaper_A_Plus        = 57;     { SuperASuperAA4 227 x 356 mm       }
  DmPaper_B_Plus        = 58;     { SuperBSuperBA3 305 x 487 mm       }
  DmPaper_Letter_Plus   = 59;     { Letter Plus 8.5 x 12.69 in          }
  DmPaper_A4_Plus       = 60;     { A4 Plus 210 x 330 mm                }
  DmPaper_A5_Transverse = 61;     { A5 Transverse 148 x 210 mm          }
  DmPaper_B5_Transverse = 62;     { B5 (JIS) Transverse 182 x 257 mm    }
  DmPaper_A3_Extra      = 63;     { A3 Extra 322 x 445 mm               }
  DmPaper_A5_Extra      = $40;    { A5 Extra 174 x 235 mm               }
  DmPaper_B5_Extra      = 65;     { B5 (ISO) Extra 201 x 276 mm         }
  DmPaper_A2            = 66;     { A2 420 x 594 mm                     }
  DmPaper_A3_Transverse = 67;     { A3 Transverse 297 x 420 mm          }
  DmPaper_A3_Extra_Transverse = 68;     { A3 Extra Transverse 322 x 445 mm    }
{
 ** the following sizes are reserved for the Far East version of Win95.
 ** Rotated papers rotate the physical page but not the logical page.
}
  DmPaper_Dbl_Japanese_Postcard = 69; { Japanese Double Postcard 200 x 148 mm }
  DmPaper_A6                  = 70;  { A6 105 x 148 mm                 }
  DmPaper_JEnv_Kaku2          = 71;  { Japanese Envelope Kaku #2       }
  DmPaper_JEnv_Kaku3          = 72;  { Japanese Envelope Kaku #3       }
  DmPaper_JEnv_Chou3          = 73;  { Japanese Envelope Chou #3       }
  DmPaper_JEnv_Chou4          = 74;  { Japanese Envelope Chou #4       }
  DmPaper_Letter_Rotated      = 75;  { Letter Rotated 11 x 8 1/2 11 in }
  DmPaper_A3_Rotated          = 76;  { A3 Rotated 420 x 297 mm         }
  DmPaper_A4_Rotated          = 77;  { A4 Rotated 297 x 210 mm         }
  DmPaper_A5_Rotated          = 78;  { A5 Rotated 210 x 148 mm         }
  DmPaper_B4_JIS_Rotated      = 79;  { B4 (JIS) Rotated 364 x 257 mm   }
  DmPaper_B5_JIS_Rotated      = 80;  { B5 (JIS) Rotated 257 x 182 mm   }
  DmPaper_Japanese_Postcard_Rotated = 81; { Japanese Postcard Rotated 148 x 100 mm }
  DmPaper_Dbl_Japanese_Postcard_Rotated = 82; { Double Japanese Postcard Rotated 148 x 200 mm }
  DmPaper_A6_Rotated          = 83;  { A6 Rotated 148 x 105 mm         }
  DmPaper_JEnv_Kaku2_Rotated  = 84;  { Japanese Envelope Kaku #2 Rotated}
  DmPaper_JEnv_Kaku3_Rotated  = 85;  { Japanese Envelope Kaku #3 Rotated}
  DmPaper_JEnv_Chou3_Rotated  = 86;  { Japanese Envelope Chou #3 Rotated}
  DmPaper_JEnv_Chou4_Rotated  = 87;  { Japanese Envelope Chou #4 Rotated}
  DmPaper_B6_JIS              = 88;  { B6 (JIS) 128 x 182 mm           }
  DmPaper_B6_JIS_Rotated      = 89;  { B6 (JIS) Rotated 182 x 128 mm   }
  DmPaper_12X11               = 90;  { 12 x 11 in                      }
  DmPaper_JEnv_You4           = 91;  { Japanese Envelope You #4        }
  DmPaper_JEnv_You4_Rotated   = 92;  { Japanese Envelope You #4 Rotated}
  DmPaper_P16K                = 93;  { PRC 16K 146 x 215 mm            }
  DmPaper_P32K                = 94;  { PRC 32K 97 x 151 mm             }
  DmPaper_P32KBig             = 95;  { PRC 32K(Big) 97 x 151 mm        }
  DmPaper_PEnv_1              = 96;  { PRC Envelope #1 102 x 165 mm    }
  DmPaper_PEnv_2              = 97;  { PRC Envelope #2 102 x 176 mm    }
  DmPaper_PEnv_3              = 98;  { PRC Envelope #3 125 x 176 mm    }
  DmPaper_PEnv_4              = 99;  { PRC Envelope #4 110 x 208 mm    }
  DmPaper_PEnv_5              = 100; { PRC Envelope #5 110 x 220 mm    }
  DmPaper_PEnv_6              = 101; { PRC Envelope #6 120 x 230 mm    }
  DmPaper_PEnv_7              = 102; { PRC Envelope #7 160 x 230 mm    }
  DmPaper_PEnv_8              = 103; { PRC Envelope #8 120 x 309 mm    }
  DmPaper_PEnv_9              = 104; { PRC Envelope #9 229 x 324 mm    }
  DmPaper_PEnv_10             = 105; { PRC Envelope #10 324 x 458 mm   }
  DmPaper_P16K_Rotated        = 106; { PRC 16K Rotated                 }
  DmPaper_P32K_Rotated        = 107; { PRC 32K Rotated                 }
  DmPaper_P32KBig_Rotated     = 108; { PRC 32K(Big) Rotated            }
  DmPaper_PENV_1_Rotated      = 109; { PRC Envelope #1 Rotated 165 x 102 mm}
  DmPaper_PENV_2_Rotated      = 110; { PRC Envelope #2 Rotated 176 x 102 mm}
  DmPaper_PENV_3_Rotated      = 111; { PRC Envelope #3 Rotated 176 x 125 mm}
  DmPaper_PENV_4_Rotated      = 112; { PRC Envelope #4 Rotated 208 x 110 mm}
  DmPaper_PENV_5_Rotated      = 113; { PRC Envelope #5 Rotated 220 x 110 mm}
  DmPaper_PENV_6_Rotated      = 114; { PRC Envelope #6 Rotated 230 x 120 mm}
  DmPaper_PENV_7_Rotated      = 115; { PRC Envelope #7 Rotated 230 x 160 mm}
  DmPaper_PENV_8_Rotated      = 116; { PRC Envelope #8 Rotated 309 x 120 mm}
  DmPaper_PENV_9_Rotated      = 117; { PRC Envelope #9 Rotated 324 x 229 mm}
  DmPaper_PENV_10_Rotated     = 118; { PRC Envelope #10 Rotated 458 x 324 mm }

{ bin selections }

  DMTT_Download_Outline = 4;     { download TT fonts as outline soft fonts  }

  { Collation selections }

  { DEVMODE dmDisplayFlags flags }
  Dm_TextMode = $00000004;   { removed in 4.0 SDK }
  DmDisplayFlags_TextMode     = $00000004;

  { ICM methods }
  DmIcmMethod_None   = 1;     { ICM disabled  }
  DmIcmMethod_System = 2;     { ICM handled by system  }
  DmIcmMethod_Driver = 3;     { ICM handled by driver  }
  DmIcmMethod_Device = 4;     { ICM handled by device  }

  DmIcmMethod_User = $100;    { Device-specific methods start here  }

  { ICM Intents }
  DmIcm_Saturate    = 1;     { Maximize color saturation  }
  DmIcm_Contrast    = 2;     { Maximize color contrast  }
  DmIcm_ColorMetric = 3;     { Use specific color metric  }

  DmIcm_User = $100;     { Device-specific intents start here  }


  { Media types }
  DmMedia_Standard     = 1;     { Standard paper  }
  DmMedia_Transparency = 2;     { Transparency  }
  DmMedia_Glossy       = 3;     { Glossy paper  }

  DmMedia_User = $100;     { Device-specific media start here  }


  { Dither types }
  DmDither_None      = 1;     { No dithering  }
  DmDither_Coarse    = 2;     { Dither with a coarse brush  }
  DmDither_Fine      = 3;     { Dither with a fine brush  }
  DmDither_LineArt   = 4;     { LineArt dithering  }
  DmDither_GrayScale = 5;     { Device does grayscaling  }

  DmDither_User = 256;        { Device-specific dithers start here  }


{ GetRegionData / ExtCreateRegion }

//  RDH_Rectangles = 1;

type

  PABCFloat = ^TABCFloat;
  TABCFloat = packed record
    abcfA: Single;
    abcfB: Single;
    abcfC: Single;
  end;

type
  PPolyText = ^TPolyText;
  TPolyText = packed record
    x: Integer;
    y: Integer;
    n: UInt;
    PAnsiChar: PChar;
    uiFlags: UInt;
    rcl: TRect;
    pdx: PINT;
  end;

const
  { GetGlyphOutline constants }

  GGO_Gray2_Bitmap = 4;
  GGO_Gray4_Bitmap = 5;
  GGO_Gray8_Bitmap = 6;
  GGO_Glyph_Index = $80;

const
  GCP_DBCS = 1;
  GCP_Reorder = 2;
  GCP_UseKerning = 8;
  GCP_GlyphShape = $10;
  GCP_Ligate = 32;
  GCP_GlyphIndexing = $0080;

  GCP_Diacritic = $100;
  GCP_Kashida = $400;
  GCP_Error = $8000;
  FLI_Mask = 4155;

  GCP_Justify = $10000;
  GCP_NoDiacritics = $00020000;

  FLI_Glyphs = $40000;
  GCP_Classin = $80000;
  GCP_MaxExtent = $100000;
  GCP_JustifyIn = $200000;
  GCP_DisplayZwg = $400000;
  GCP_SymSwapOff = $800000;
  GCP_NumericOverride = $1000000;
  GCP_NeutralOverride = $2000000;
  GCP_NumericsLatin = $4000000;
  GCP_NumericsLocal = $8000000;

  GcpClass_Latin = 1;
  GcpClass_Hebrew = 2;
  GcpClass_Arabic = 2;
  GcpClass_Neutral = 3;
  GcpClass_LocalNumber = 4;
  GcpClass_LatinNumber = 5;
  GcpClass_LatinNumericTerminator = 6;
  GcpClass_LatinNumericSeparator = 7;
  GcpClass_NumericSeparator = 8;
  GcpClass_PreboundRtl = $80;
  GcpClass_PreboundLtr = $40;
  GcpClass_PostboundLtr        = $20;
  GcpClass_PostboundRtl        = $10;

  GcpGlyph_LinkBefore          = $8000;
  GcpGlyph_LinkAfter           = $4000;


type
  PGCPResults = ^TGCPResults;
  TGCPResults = packed record
    lStructSize: DWord;
    lpOutString: PChar;
    lpOrder: PUINT;
    lpDx: PINT;
    lpCaretPos: PINT;
    lpClass: PChar;
    lpGlyphs: PUINT;
    nGlyphs: UInt;
    nMaxFit: Integer;
  end;

type
  { Pixel format descriptor }
  PPixelFormatDescriptor = ^TPixelFormatDescriptor;
  TPixelFormatDescriptor = packed record
    nSize: Word;
    nVersion: Word;
    dwFlags: DWord;
    iPixelType: Byte;
    cColorBits: Byte;
    cRedBits: Byte;
    cRedShift: Byte;
    cGreenBits: Byte;
    cGreenShift: Byte;
    cBlueBits: Byte;
    cBlueShift: Byte;
    cAlphaBits: Byte;
    cAlphaShift: Byte;
    cAccumBits: Byte;
    cAccumRedBits: Byte;
    cAccumGreenBits: Byte;
    cAccumBlueBits: Byte;
    cAccumAlphaBits: Byte;
    cDepthBits: Byte;
    cStencilBits: Byte;
    cAuxBuffers: Byte;
    iLayerType: Byte;
    bReserved: Byte;
    dwLayerMask: DWord;
    dwVisibleMask: DWord;
    dwDamageMask: DWord;
  end;

const
  { pixel types }
  PFD_Type_RGBA = 0;
  PFD_Type_ColorIndex = 1;

  { layer types }
  PFD_Main_Plane = 0;
  PFD_Overlay_Plane = 1;
  PFD_Underlay_Plane = -1;

  { TPixelFormatDescriptor flags }
  PFD_DoubleBuffer                = $00000001;
  PFD_Stereo                      = $00000002;
  PFD_Draw_to_Window              = $00000004;
  PFD_Draw_to_Bitmap              = $00000008;
  PFD_Support_GDI                 = $00000010;
  PFD_Support_OpenGl              = $00000020;
  PFD_Generic_Format              = $00000040;
  PFD_Need_Palette                = $00000080;
  PFD_Need_System_Palette         = $00000100;
  PFD_Swap_Exchange               = $00000200;
  PFD_Swap_Copy                   = $00000400;
  PFD_Swap_Layer_Buffers          = $00000800;
  PFD_Generic_Accelerated         = $00001000;

  { TPixelFormatDescriptor flags for use in ChoosePixelFormat only }
  PFD_Depth_DontCare              = $20000000;
  PFD_DoubleBuffer_DontCare       = $40000000;
  PFD_Stereo_DontCare             = $80000000;

type
  TFNOldFontEnumProc = TFarProc;

function CancelDC(DC: HDC): Bool;
function ChoosePixelFormat(DC: HDC; P2: PPixelFormatDescriptor): Integer;
function CreateDiscardableBitmap(DC: HDC; P2, P3: Integer): HBitmap;
function CreateDIBPatternBrush(P1: HGLOBAL; P2: UInt): HBRUSH;
function CreateScalableFontResource(P1: DWord; P2,P3,P4: PChar): Bool;
function DescribePixelFormat(DC: HDC; P2: Integer; P3: UInt; var P4: TPixelFormatDescriptor): Bool;

{ define types of pointers to ExtDeviceMode() and DeviceCapabilities()
  functions for Win 3.1 compatibility }

type
  TFNDevCaps = function(DeviceName, Port: LPSTR;
    Index: UInt; Output: LPSTR; var DevMode: TDeviceMode): DWord;

const
  { device capabilities indices }
  DC_Collate = 22;


  { bit fields of the return value (DWord) for DC_TRUETYPE }
  DCTT_Bitmap = 1;
  DCTT_Download = 2;
  DCTT_SubDev = 4;
  DCTT_Download_Outline = 8;


  { return values for DC_Binadjust }
  DCBA_FaceUpNone = 0;
  DCBA_FaceUpCenter = 1;
  DCBA_FaceUpLeft = 2;
  DCBA_FaceUpRight = 3;
  DCBA_FaceDownNone = $100;
  DCBA_FaceDownCenter = 257;
  DCBA_FaceDownLeft = 258;
  DCBA_FaceDownRight = 259;


function DeviceCapabilitiesEx(pDriverName, pDeviceName, pPort: PChar;
  iIndex: Integer; pOutput: PChar; DevMode: PDeviceMode): Integer;

function DrawEscape(DC: HDC; P2, P3: Integer; P4: LPCSTR): Bool;
function EnumFontFamiliesEx(DC: HDC; var P2: TLogFont;
  P3: TFNFontEnumProc; P4: lParam; P5: DWord): Bool;
function ExtEscape(DC: HDC; P2, P3: Integer;
  const P4: LPCSTR; P5: Integer; P6: LPSTR): Integer;
function GetCharWidth32(DC: HDC; P2, P3: UInt; const Widths): Bool;
function GetCharWidthFloat(DC: HDC; P2, P3: UInt; const Widths): Bool;
function GetCharABCWidthsFloat(DC: HDC; P2, P3: UInt; const ABCFloatSturcts): Bool;
function GetMetaRgn(DC: HDC; rgn: HRGN): Integer;
function GetFontData(DC: HDC; P2, P3: DWord; P4: Pointer; P5: DWord): DWord;
function GetGlyphOutline(DC: HDC; P2, P3: UInt;
  const P4: TGlyphMetrics; P5: DWord; P6: Pointer; const P7: TMat2): DWord;
function GetPixelFormat(DC: HDC): Integer;
function GetSystemPaletteUse(DC: HDC): UInt;
function GetTextExtentExPoint(DC: HDC; P2: PChar;
  P3, P4: Integer; var P5, P6: Integer; var P7: TSize): Bool;
function GetTextCharset(hdc: HDC): Integer;
function GetTextCharsetInfo(hdc: HDC; lpSig: PFontSignature; dwFlags: DWord): Bool;
function TranslateCharsetInfo(var lpSrc: DWord; var lpCs: TCharsetInfo; dwFlags: DWord): Bool;
function GetFontLanguageInfo(DC: HDC): DWord;
function GetCharacterPlacement(DC: HDC; P2: PChar; P3, P4: Bool;
  var P5: TGCPResults; P6: DWord): DWord;
function PlgBlt(DC: HDC; const PointsArray; P3: HDC;
  P4, P5, P6, P7: Integer; P8: HBitmap; P9, P10: Integer): Bool;
function SetMetaRgn(DC: HDC): Integer;
function SetPixelV(DC: HDC; X, Y: Integer; Color: TColorRef): Bool;
function SetPixelFormat(DC: HDC; P2: Integer; P3: PPixelFormatDescriptor): Bool;
function SetSystemPaletteUse(DC: HDC; P2: UInt): UInt;
function UpdateColors(DC: HDC): Bool;

{ Enhanced Metafile Function Declarations }

function GetEnhMetaFileDescription(P1: HENHMETAFILE; P2: UInt; P3: PChar): UInt;
function GetEnhMetaFilePixelFormat(P1: HENHMETAFILE; P2: Cardinal;
  var P3: TPixelFormatDescriptor): UInt;
function PlayEnhMetaFileRecord(DC: HDC; var P2: THandleTable;
  const P3: TEnhMetaRecord; P4: UInt): Bool;
function GdiComment(DC: HDC; P2: UInt; P3: PChar): Bool;

{ new GDI }

type
  PDIBSection = ^TDIBSection;
  TDIBSection = packed record
    dsBm: TBitmap;
    dsBmih: TBitmapInfoHeader;
    dsBitfields: array[0..2] of DWord;
    dshSection: THandle;
    dsOffset: DWord;
  end;

function CombineTransform(var P1: TXForm; const P2, P3: TXForm): Bool;
function CreateDIBSection(DC: HDC; const P2: TBitmapInfo; P3: UInt;
  var P4: Pointer; P5: THandle; P6: DWord): HBitmap;
function GetDIBColorTable(DC: HDC; P2, P3: UInt; var RGBQuadStructs): UInt;
function SetDIBColorTable(DC: HDC; P2, P3: UInt; var RGBQuadSTructs): UInt;

const
  { Flags value for ColorAdjustment }
  CA_Negative = 1;
  CA_Log_Filter = 2;

  { IlluminantIndex values }
  Illuminant_Device_Default = 0;
  Illuminant_A = 1;
  Illuminant_B = 2;
  Illuminant_C = 3;
  Illuminant_D50 = 4;
  Illuminant_D55 = 5;
  Illuminant_D65 = 6;
  Illuminant_D75 = 7;
  Illuminant_F2 = 8;

  Illuminant_Max_Index = Illuminant_F2;
  Illuminant_Tungsten = Illuminant_A;
  Illuminant_Daylight = Illuminant_C;
  Illuminant_Fluorescent = Illuminant_F2;
  Illuminant_NTSC = Illuminant_C;

  { Min and max for RedGamma, GreenGamma, BlueGamma }
  RGB_Gamma_Min = 02500;
  RGB_Gamma_Max = 65000;

  { Min and max for ReferenceBlack and ReferenceWhite }
  Reference_White_Min = 6000;
  Reference_White_Max = 10000;
  Reference_Black_Min = 0;
  Reference_Black_Max = 4000;

  { Min and max for Contrast, Brightness, Colorfulness, RedGreenTint }
  Color_Adj_Min = -100;
  Color_Adj_Max = 100;

const
  DI_APPBANDING = 1;

function SetAbortProc(DC: HDC; lpAbortProc: TFNAbortProc): Integer;
function SelectClipPath(DC: HDC; Mode: Integer): Bool;
function PolyTextOut(DC: HDC; const PolyTextArray; Strings: Integer): Bool;

const
  FontMapper_Max = 10;

const
  ICM_Off = 1;
  ICM_On = 2;
  ICM_Query = 3;

  ICM_AddProfile = 1; { removed in 4.0 SDK }
  ICM_DeleteProfile = 2; { removed in 4.0 SDK }
  ICM_QueryProfile = 3; { removed in 4.0 SDK }
  ICM_SetDefaultProfile = 4; { removed in 4.0 SDK }
  ICM_RegisterIcMatcher = 5; { removed in 4.0 SDK }
  ICM_UnregisterIcMatcher = 6; { removed in 4.0 SDK }
  ICM_QueryMatch = 7; { removed in 4.0 SDK }

function SetICMMode(DC: HDC; Mode: Integer): Integer;
function CheckColorsInGamut(DC: HDC; var RGBQuads, Results; Count: DWord): Bool;
function GetColorSpace(DC: HDC): THandle;
function GetLogColorSpace(P1: HCOLORSPACE; var ColorSpace: TLogColorSpace; Size: DWord): Bool;
function CreateColorSpace(var ColorSpace: TLogColorSpace): HCOLORSPACE;
function SetColorSpace(DC: HDC; ColorSpace: HCOLORSPACE): Bool;
function DeleteColorSpace(ColorSpace: HCOLORSPACE): Bool;
function GetICMProfile(DC: HDC; var Size: DWord; Name: PChar): Bool;
function SetICMProfile(DC: HDC; Name: PChar): Bool;
function GetDeviceGammaRamp(DC: HDC; var Ramp): Bool;
function SetDeviceGammaRamp(DC: HDC; var Ramp): Bool;
function ColorMatchToTarget(DC: HDC; Target: HDC; Action: DWord): Bool;

type
  TFNICMEnumProc = TFarProc;

function EnumICMProfiles(DC: HDC; ICMProc: TFNICMEnumProc; P3: lParam): Integer;

const
  EMR_GlsRecord = 102;
  EMR_GlsBoundedRecord = 103;
  EMR_PixelFormat = 104;

type
  TEMRAbortPath = TAbortPath;
  PEMRAbortPath = PAbortPath;
  TEMRBeginPath = TAbortPath;
  PEMRBeginPath = PAbortPath;
  TEMREndPath = TAbortPath;
  PEMREndPath = PAbortPath;
  TEMRCloseFigure = TAbortPath;
  PEMRCloseFigure = PAbortPath;
  TEMRFlattenPath = TAbortPath;
  PEMRFlattenPath = PAbortPath;
  TEMRWidenPath = TAbortPath;
  PEMRWidenPath = PAbortPath;
  TEMRSetMetaRgn = TAbortPath;
  PEMRSetMetaRgn = PAbortPath;
  TEMRSaveDC = TAbortPath;
  PEMRSaveDC = PAbortPath;
  TEMRRealizePalette = TAbortPath;
  PEMRRealizePalette = PAbortPath;

  TEMRSetBkMode = TEMRSelectClipPath;
  PEMRSetBkMode = PEMRSelectClipPath;
  TEMRSetMapMode = TEMRSelectClipPath;
  PEMRSetMapMode = PEMRSelectClipPath;
  TEMRSetPolyFillMode = TEMRSelectClipPath;
  PEMRSetPolyFillMode = PEMRSelectClipPath;
  TEMRSetRop2 = TEMRSelectClipPath;
  PEMRSetRop2 = PEMRSelectClipPath;
  TEMRSetStretchBltMode = TEMRSelectClipPath;
  PEMRSetStretchBltMode = PEMRSelectClipPath;
  TEMRSetICMMode = TEMRSelectClipPath;
  PEMRSetICMMode = PEMRSelectClipPath;
  TEMRSetTextAlign = TEMRSelectClipPath;
  PEMRSetTextAlign = PEMRSelectClipPath;

  EMRRectangle = TEMREllipse;
  PEMRRectangle = PEMREllipse;

  EMRArcTo = TEMRArc;
  PEMRArcTo = PEMRArc;
  EMRChord = TEMRArc;
  PEMRChord = PEMRArc;
  EMRPie = TEMRArc;
  PEMRPie = PEMRArc;

  PEMRExtCreateFontIndirect = ^TEMRExtCreateFontIndirect;
  TEMRExtCreateFontIndirect = record
    emr: TEMR;
    ihFont: DWord;     { Font handle index}
    elfw: TExtLogFont;
  end;

  PEMRCreateColorSpace = ^TEMRCreateColorSpace;
  TEMRCreateColorSpace = packed record
    emr: TEMR;
    ihCS: DWord;          { ColorSpace handle index}
    lcs: TLogColorSpace;
  end;

  PEMRGLSRecord = ^TEMRGLSRecord;
  TEMRGLSRecord = packed record
    emr: TEMR;
    cbData: DWord;              { Size of data in bytes }
    Data: packed array[0..0] of Byte;
  end;

  PEMRGLSBoundedRecord = ^TEMRGLSBoundedRecord;
  TEMRGLSBoundedRecord = packed record
    emr: TEMR;
    rclBounds: TRect;           { Bounds in recording coordinates }
    cbData: DWord;              { Size of data in bytes }
    Data: packed array[0..0] of Byte;
  end;

  PEMRPixelFormat = ^TEMRPixelFormat;
  TEMRPixelFormat = packed record
    emr: TEMR;
    pfd: TPixelFormatDescriptor;
  end;

{ OpenGL wgl prototypes}

function wglCopyContext(P1: HGLRC; P2: HGLRC; P3: Cardinal): Bool;
function wglCreateContext(DC: HDC): HGLRC;
function wglCreateLayerContext(P1: HDC; P2: Integer): HGLRC;
function wglDeleteContext(P1: HGLRC): Bool;
function wglGetCurrentContext: HGLRC;
function wglGetCurrentDC: HDC;
function wglMakeCurrent(DC: HDC; P2: HGLRC): Bool;
function wglShareLists(P1, P2: HGLRC): Bool;
function wglUseFontBitmaps(DC: HDC; P2, P3, P4: DWord): Bool;
function SwapBuffers(DC: HDC): Bool;

type
  PPointFloat = ^TPointFloat;
  TPointFloat = packed record
    x: Single;
    y: Single;
  end;

  PGlyphMetricsFloat = ^TGlyphMetricsFloat;
  TGlyphMetricsFloat = packed record
    gmfBlackBoxX: Single;
    gmfBlackBoxY: Single;
    gmfptGlyphOrigin: TPointFloat;
    gmfCellIncX: Single;
    gmfCellIncY: Single;
  end;

const
  WGL_FONT_LINES = 0;
  WGL_FONT_POLYGONS = 1;

function wglUseFontOutlines(P1: HDC; P2, P3, P4: DWord;
  P5, P6: Single; P7: Integer; P8: PGlyphMetricsFloat): Bool;

{ Layer plane descriptor }
type
  PLayerPlaneDescriptor = ^TLayerPlaneDescriptor;
  TLayerPlaneDescriptor = packed record   { lpd }
    nSize: Word;
    nVersion: Word;
    dwFlags: DWord;
    iPixelType: Byte;
    cColorBits: Byte;
    cRedBits: Byte;
    cRedShift: Byte;
    cGreenBits: Byte;
    cGreenShift: Byte;
    cBlueBits: Byte;
    cBlueShift: Byte;
    cAlphaBits: Byte;
    cAlphaShift: Byte;
    cAccumBits: Byte;
    cAccumRedBits: Byte;
    cAccumGreenBits: Byte;
    cAccumBlueBits: Byte;
    cAccumAlphaBits: Byte;
    cDepthBits: Byte;
    cStencilBits: Byte;
    cAuxBuffers: Byte;
    iLayerPlane: Byte;
    bReserved: Byte;
    crTransparent: TColorRef;
  end;

{ TLayerPlaneDescriptor flags }
const
  LPD_DoubleBuffer = $00000001;
  LPD_Stereo = $00000002;
  LPD_Support_GDI = $00000010;
  LPD_Support_OpenGL = $00000020;
  LPD_Share_Depth = $00000040;
  LPD_Share_Stencil = $00000080;
  LPD_Share_Accum = $00000100;
  LPD_Swap_Exchange = $00000200;
  LPD_Swap_Copy = $00000400;
  LPD_Transparent = $00001000;

  LPD_TYPE_RGBA = 0;
  LPD_TYPE_COLORINDEX = 1;

{ wglSwapLayerBuffers flags }
  WGL_Swap_Main_Plane = $00000001;
  WGL_Swap_Overlay1 = $00000002;
  WGL_Swap_Overlay2 = $00000004;
  WGL_Swap_Overlay3 = $00000008;
  WGL_Swap_Overlay4 = $00000010;
  WGL_Swap_Overlay5 = $00000020;
  WGL_Swap_Overlay6 = $00000040;
  WGL_Swap_Overlay7 = $00000080;
  WGL_Swap_Overlay8 = $00000100;
  WGL_Swap_Overlay9 = $00000200;
  WGL_Swap_Overlay10 = $00000400;
  WGL_Swap_Overlay11 = $00000800;
  WGL_Swap_Overlay12 = $00001000;
  WGL_Swap_Overlay13 = $00002000;
  WGL_Swap_Overlay14 = $00004000;
  WGL_Swap_Overlay15 = $00008000;
  WGL_Swap_Underlay1 = $00010000;
  WGL_Swap_Underlay2 = $00020000;
  WGL_Swap_Underlay3 = $00040000;
  WGL_Swap_Underlay4 = $00080000;
  WGL_Swap_Underlay5 = $00100000;
  WGL_Swap_Underlay6 = $00200000;
  WGL_Swap_Underlay7 = $00400000;
  WGL_Swap_Underlay8 = $00800000;
  WGL_Swap_Underlay9 = $01000000;
  WGL_Swap_Underlay10 = $02000000;
  WGL_Swap_Underlay11 = $04000000;
  WGL_Swap_Underlay12 = $08000000;
  WGL_Swap_Underlay13 = $10000000;
  WGL_Swap_Underlay14 = $20000000;
  WGL_Swap_Underlay15 = $40000000;

function wglDescribeLayerPlane(P1: HDC; P2, P3: Integer; P4: Cardinal;
  var P5: TLayerPlaneDescriptor): Bool;
function wglSetLayerPaletteEntries(P1: HDC; P2, P3, P4: Integer;
  var pcr): Integer;
function wglGetLayerPaletteEntries(P1: HDC; P2, P3, P4: Integer;
  var pcr): Integer;
function wglRealizeLayerPalette(P1: HDC; P2: Integer; P3: Bool): Bool;
function wglSwapLayerBuffers(P1: HDC; P2: Cardinal): Bool;


{ Translated from WINUSER.H }

type
  PMENUTEMPLATE = Pointer;
  va_list = PChar;

  TFNGrayStringProc = TFarProc;
  TFNSendAsyncProc = TFarProc;
  TFNDrawStateProc = TFarProc;

type
  TFNEditWordBreakProc = TFarProc;
  TFNNameEnumProc = TFarProc;
  TFNWinStaEnumProc = TFNNameEnumProc;
  TFNDeskTopEnumProc = TFNNameEnumProc;

const
  { Predefined Resource Types }
  Difference = 11;

  RT_Group_Cursor = MakeIntResource(DWord(RT_Cursor + Difference));
  RT_Group_Icon   = MakeIntResource(DWord(RT_Icon + Difference));
  RT_Version      = MakeIntResource(16);
  RT_PlugPlay     = MakeIntResource(19);
  RT_VXD          = MakeIntResource(20);
  RT_AniCursor    = MakeIntResource(21);
  RT_AniIcon      = MakeIntResource(22);

const
  { Identifiers for the WM_ShowWindow message }
  SW_ParentClosing = 1;
  SW_OtherZoom = 2;
  SW_ParentOpening = 3;
  SW_OtherUnzoom = 4;

  { WM_KeyUpDownChar HiWord(lParam) flags }
  KF_Extended = $100;
  KF_DlgMode = $800;
  KF_MenuMode = $1000;
  KF_AltDown = $2000;
  KF_Repeat = $4000;
  KF_Up = $8000;

  { Virtual Keys, Standard Set }
  VK_Kana = 21;
  VK_Hangul = 21;
  VK_Junja = 23;
  VK_Final = 24;
  VK_Hanja = 25;
  VK_Kanji = 25;
  VK_Convert = 28;
  VK_NonConvert = 29;
  VK_Accept = 30;
  VK_ModeChange = 31;
{ VK_0 thru VK_9 are the same as ASCII '0' thru '9' ($30 - $39) }
{ VK_A thru VK_Z are the same as ASCII 'A' thru 'Z' ($41 - $5A) }
  VK_ProcessKey = 229;
  WH_CallWndProcRet = 12;
  WH_MinHook = WH_Min;
  WH_MaxHook = WH_Max;

  { CBT Hook Codes }
  HCBT_MoveSize = 0;
  HCBT_MinMax = 1;
  HCBT_QS = 2;
  HCBT_CreateWnd = 3;
  HCBT_DestroyWnd = 4;
  HCBT_Activate = 5;
  HCBT_ClickSkipped = 6;
  HCBT_KeySkipped = 7;
  HCBT_SysCommand = 8;
  HCBT_SetFocus = 9;


type
  { HCBT_CREATEWND parameters pointed to by lParam }
  PCBTCreateWnd = ^TCBTCreateWnd;
  TCBTCreateWnd = packed record
    lpcs: PCreateStruct;
    hwndInsertAfter: hWnd;
  end;

  { HCBT_ACTIVATE structure pointed to by lParam }
  PCBTActivateStruct = ^TCBTActivateStruct;
  TCBTActivateStruct = packed record
    fMouse: Bool;
    hWndActive: hWnd;
  end;

const
  { WH_MsgFilter Filter Proc Codes }

  { Shell support }
  HShell_WindowCreated = 1;
  HShell_WindowDestroyed = 2;
  HShell_ActivateShellWindow = 3;
  HShell_WindowActivated = 4;
  HShell_GetMinRect = 5;
  HShell_Redraw = 6;
  HShell_Taskman = 7;
  HShell_Language = 8;


type
  { Message structure used by WH_CallWndProcRet }
  PCWPRetStruct = ^TCWPRetStruct;
  TCWPRetStruct = packed record
    lResult: lResult;
    lParam: lParam;
    wParam: wParam;
    message: UInt;
    hWnd: hWnd;
  end;

  { Structure used by WH_Hardware }
  PHardwareHookStruct = ^THardwareHookStruct;
  THardwareHookStruct = packed record
    hWnd: hWnd;
    message: UInt;
    wParam: wParam;
    lParam: lParam;
  end;

const
  { Keyboard Layout API }
  HKL_Prev = 0;
  HKL_Next = 1;

  KLF_Activate = 1;
  KLF_Substitute_Ok = 2;
  KLF_UnloadPrevious = 4;
  KLF_Reorder = 8;
  KLF_ReplaceLang = $10;
  KLF_NoTellShell = 128;

  { Size of KeyboardLayoutName (number of characters), including nul terminator }
  KL_NameLength = 9;


function LoadKeyboardLayout(pwszKLID: PChar; Flags: UInt): HKL;
function ActivateKeyboardLayout(hkl: HKL; Flags: UInt): HKL;
function UnloadKeyboardLayout(hkl: HKL): Bool;
function ToUnicodeEx(wVirtKey, wScanCode: UInt; lpKeyState: PByte;
  pwszBuff: pChar; cchBuff: Integer; wFlags: UInt; dwhkl: HKL): Integer;
function GetKeyboardLayoutName(pwszKLID: PChar): Bool;
function GetKeyboardLayoutList(nBuff: Integer; var List): UInt;
function GetKeyboardLayout(dwLayout: DWord): HKL;


const
  { Desktop-specific access flags }
  Desktop_ReadObjects = 1;
  Desktop_CreateWindow = 2;
  Desktop_CreateMenu = 4;
  Desktop_HookControl = 8;
  Desktop_JournalRecord = $10;
  Desktop_JournalPlayback = $20;
  Desktop_Enumerate = $40;
  Desktop_WriteObjects = 128;
  Desktop_SwitchDesktop = $100;

  { Desktop-specific control flags }
  DF_AllowOtherAccountHook = 1;


function CreateDesktop(lpszDesktop, lpszDevice: PChar;
  pDevmode: PDeviceMode; dwFlags: DWord; dwDesiredAccess:
  DWord; lpsa: PSecurityAttributes): HDESK;
function OpenDesktop(lpszDesktop: PChar; dwFlags: DWord; fInherit: Bool;
  dwDesiredAccess: DWord): HDESK;
function EnumDesktops(hwinsta: HWINSTA; lpEnumFunc: TFNDeskTopEnumProc; lParam: lParam): Bool;
function OpenInputDesktop(dwFlags: DWord; fInherit: Bool; dwDesiredAccess: DWord): HDESK;
function EnumDesktopWindows(hDesktop: HDESK; lpfn: TFNWndEnumProc; lParam: lParam): Bool;
function SwitchDesktop(hDesktop: HDESK): Bool;
function SetThreadDesktop(hDesktop: HDESK): Bool;
function CloseDesktop(hDesktop: HDESK): Bool;
function GetThreadDesktop(dwThreadId: DWord): HDESK;

const
  { Windowstation-specific access flags }
  WinSta_EnumDesktops = 1;
  WinSta_ReadAttributes = 2;
  WinSta_AccessClipboard = 4;
  WinSta_CreateDesktop = 8;
  WinSta_WriteAttributes = $10;
  WinSta_AccessGlobalAtoms = $20;
  WinSta_ExitWindows = $40;
  WinSta_Enumerate = $100;
  WinSta_ReadScreen = $200;

  { Windowstation-specific attribute flags }
  WSF_Visible = 1;

function CreateWindowStation(lpwinsta: PChar; dwReserved, dwDesiredAccess: DWord;
  lpsa: PSecurityAttributes): HWINSTA;
function OpenWindowStation(lpszWinSta: PChar; fInherit: Bool;
  dwDesiredAccess: DWord): HWINSTA;
function EnumWindowStations(lpEnumFunc: TFNWinStaEnumProc; lParam: lParam): Bool;
function CloseWindowStation(hWinSta: HWINSTA): Bool;
function SetProcessWindowStation(hWinSta: HWINSTA): Bool;
function GetProcessWindowStation: HWINSTA;
function SetUserObjectSecurity(hObj: THandle; var pSIRequested: DWord;
  pSID: PSecurityDescriptor): Bool;
function GetUserObjectSecurity(hObj: THandle; var pSIRequested: DWord;
  pSID: PSecurityDescriptor; nLength: DWord; var lpnLengthNeeded: DWord): Bool;

const
  UOI_Flags = 1;
  UOI_Name = 2;
  UOI_Type = 3;
  UOI_User_SID = 4;

type
  PUserObjectFlags = ^TUserObjectFlags;
  TUserObjectFlags = packed record
    fInherit: Bool;
    fReserved: Bool;
    dwFlags: DWord;
  end;

function GetUserObjectInformation(hObj: THandle; nIndex: Integer; pvInfo: Pointer;
  nLength: DWord; var lpnLengthNeeded: DWord): Bool;
function SetUserObjectInformation(hObj: THandle; nIndex: Integer;
  pvInfo: Pointer; nLength: DWord): Bool;

type
  PWndClassEx = ^TWndClassEx;
  TWndClassEx = packed record
    cbSize: UINT;
    style: UINT;
    lpfnWndProc: TFNWndProc;
    cbClsExtra: Integer;
    cbWndExtra: Integer;
    hInstance: HINST;
    hIcon: HICON;
    hCursor: HCURSOR;
    hbrBackground: HBRUSH;
    lpszMenuName: PChar;
    lpszClassName: PChar;
    hIconSm: HICON;
  end;

function MakeWParam(L,H: SmallWord): wParam;
function MakeLParam(L,H: SmallWord): lParam;
function MakeLResult(L,H: SmallWord): lResult;

const
{ Window field offsets for GetWindowLong() }
  GCL_HIconSm = -34;

const
  { wParam for WM_Power window message and DRV_Power driver notification }
  PWR_Ok = 1;
  PWR_Fail = -1;
  PWR_SuspendRequest = 1;
  PWR_SuspendResume = 2;
  PWR_CriticalResume = 3;

type
  { lParam of WM_CopyData message points to... }
  PCopyDataStruct = ^TCopyDataStruct;
  TCopyDataStruct = packed record
    dwData: DWord;
    cbData: DWord;
    lpData: Pointer;
  end;

const
  NFR_ANSI = 1;
  NFR_UniCode = 2;
  NF_Query = 3;
  NF_Requery = 4;

  Wheel_Delta = 120;            { Value for rolling one detent }
  Wheel_PageScroll = MaxDWord;  { Scroll one page }

  MenuLoop_Window = 0;
  MenuLoop_Popup = 1;

type
  PMDINextMenu = ^TMDINextMenu;
  TMDINextMenu = packed record
    hmenuIn: hMenu;
    hmenuNext: hMenu;
    hwndNext: hWnd;
  end;

const
  { wParam for WM_NotifyWow message  }

  { wParam for WM_Sizing message  }
  WMSZ_Left = 1;
  WMSZ_Right = 2;
  WMSZ_Top = 3;
  WMSZ_TopLeft = 4;
  WMSZ_TopRight = 5;
  WMSZ_Bottom = 6;
  WMSZ_BottomLeft = 7;
  WMSZ_BottomRight = 8;

  { WM_NChitTest and MouseHookStruct Mouse Position Codes }
  HTObject = 19;
  HTClose = 20;
  HTHelp = 21;

  { WM_SetIcon / WM_GetIcon Type Codes }
  Icon_Small = 0;
  Icon_Big = 1;

type
  { WM_NcCalcSize parameter structure }
  PNCCalcSizeParams = ^TNCCalcSizeParams;
  TNCCalcSizeParams = packed record
    rgrc: array[0..2] of TRect;
    lppos: PWindowPos;
  end;

const
  { WM_NcCalcSize "window valid rect" return values }
  WVR_AlignTop = $10;
  WVR_AlignLeft = $20;
  WVR_AlignBottom = $40;
  WVR_AlignRight = $80;
  WVR_HRedraw = $100;
  WVR_VRedraw = $200;
  WVR_Redraw = (WVR_HRedraw or WVR_VRedraw);
  WVR_ValidRects = $400;

  TME_Hover           = $00000001;
  TME_Leave           = $00000002;
  TME_Query           = $40000000;
  TME_Cancel          = $80000000;

  Hover_Default       = $FFFFFFFF;

type
  PTrackMouseEvent = ^TTrackMouseEvent;
  TTrackMouseEvent = record
    cbSize: DWord;
    dwFlags: DWord;
    hwndTrack: hWnd;
    dwHoverTime: DWord;
  end;

function TrackMouseEvent(var EventTrack: TTrackMouseEvent): Bool;

const
  { Extended Window Styles }
  WS_EX_DlgModalFrame = 1;
  WS_EX_nOParentNotify = 4;
  WS_EX_Transparent = $20;
  WS_EX_MdiChild = $40;
  WS_EX_ToolWindow = $80;
  WS_EX_WindowEdge = $100;
  WS_EX_ClientEdge = $200;
  WS_EX_ContextHelp = $400;

  WS_EX_Right = $1000;
  WS_EX_Left = 0;
  WS_EX_RtlReading = $2000;
  WS_EX_LtrReading = 0;
  WS_EX_LeftScrollbar = $4000;
  WS_EX_RightScrollbar = 0;

  WS_EX_ControlParent = $10000;
  WS_EX_StaticEdge = $20000;
  WS_EX_AppWindow = $40000;
  WS_EX_OverlappedWindow = (WS_EX_WindowEdge or WS_EX_ClientEdge);
  WS_EX_PaletteWindow = (WS_EX_WindowEdge or WS_EX_ToolWindow or WS_EX_Topmost);

  { Class styles }
  CS_IME = $10000;

  { WM_Print flags }
  PRF_CheckVisible = 1;
  PRF_NonClient = 2;
  PRF_Client = 4;
  PRF_EraseBkgnd = 8;
  PRF_Children = $10;
  PRF_Owned = $20;

  { 3D border styles }
  BDR_RaisedOuter = 1;
  BDR_SunkenOuter = 2;
  BDR_RaisedInner = 4;
  BDR_SunkenInner = 8;

  BDR_Outer = 3;
  BDR_Inner = 12;
  BDR_Raised = 5;
  BDR_Sunken = 10;

  Edge_Raised = (BDR_RaisedOuter or BDR_RaisedInner);
  Edge_Sunken = (BDR_SunkenOuter or BDR_SunkenInner);
  Edge_Etched = (BDR_SunkenOuter or BDR_RaisedInner);
  Edge_Bump = (BDR_RaisedOuter or BDR_SunkenInner);

  { Border flags }
  BF_Left = 1;
  BF_Top = 2;
  BF_Right = 4;
  BF_Bottom = 8;

  BF_TopLeft = (BF_Top or BF_Left);
  BF_TopRight = (BF_Top or BF_Right);
  BF_BottomLeft = (BF_Bottom or BF_Left);
  BF_BottomRight = (BF_Bottom or BF_Right);
  BF_Rect = (BF_Left or BF_Top or BF_Right or BF_Bottom);

  BF_Diagonal = $10;

  { For diagonal lines, the BF_Rect flags specify the end point of the}
  { vector bounded by the rectangle parameter.}
  BF_Diagonal_EndTopRight = (BF_Diagonal or BF_Top or BF_Right);
  BF_Diagonal_EndTopLeft = (BF_Diagonal or BF_Top or BF_Left);
  BF_Diagonal_EndBottomLeft = (BF_Diagonal or BF_Bottom or BF_Left);
  BF_Diagonal_EndBottomRight = (BF_Diagonal or BF_Bottom or BF_Right);

  BF_Middle = $800;   { Fill in the middle }
  BF_Soft = $1000;    { For softer buttons }
  BF_Adjust = $2000;  { Calculate the space left over }
  BF_Flat = $4000;    { For flat rather than 3D borders }
  BF_Mono = $8000;    { For monochrome borders }

function DrawEdge(hdc: HDC; var qrc: TRect; edge: UInt; grfFlags: UInt): Bool;

const
  { flags for DrawFrameControl }
  DFC_Caption = 1;
  DFC_Menu = 2;
  DFC_Scroll = 3;
  DFC_Button = 4;

  DFCS_CaptionClose = 0;
  DFCS_CaptionMin = 1;
  DFCS_CaptionMax = 2;
  DFCS_CaptionRestore = 3;
  DFCS_CaptionHelp = 4;

  DFCS_MenuArrow = 0;
  DFCS_MenuCheck = 1;
  DFCS_MenuBullet = 2;
  DFCS_MenuArrowRight = 4;

  DFCS_ScrollUp = 0;
  DFCS_ScrollDown = 1;
  DFCS_ScrollLeft = 2;
  DFCS_ScrollRight = 3;
  DFCS_ScrollCombobox = 5;
  DFCS_ScrollSizeGrip = 8;
  DFCS_ScrollSizeGripRight = $10;

  DFCS_ButtonCheck = 0;
  DFCS_ButtonRadioImage = 1;
  DFCS_ButtonRadioMask = 2;
  DFCS_ButtonRadio = 4;
  DFCS_Button3State = 8;
  DFCS_ButtonPush = $10;

  DFCS_Inactive = $100;
  DFCS_Pushed = $200;
  DFCS_Checked = $400;
  DFCS_AdjustRect = $2000;
  DFCS_Flat = $4000;
  DFCS_Mono = $8000;

function DrawFrameControl(DC: HDC; const Rect: TRect; uType, uState: UInt): Bool;

const
  { flags for DrawCaption }
  DC_Active = 1;
  DC_SmallCap = 2;
  DC_Icon = 4;
  DC_Text = 8;
  DC_InButton = $10;

function DrawCaption(P1: hWnd; P2: HDC; const P3: TRect; P4: UInt): Bool;

const
  IDAni_Open = 1;
  IDAni_Close = 2;
  IDAni_Caption = 3;

function DrawAnimatedRects(hWnd: hWnd; idAni: Integer; const lprcFrom, lprcTo: TRect): Bool;

const
  { Predefined Clipboard Formats }
  CF_HDrop = 15;
  CF_Locale = 16;
  CF_Max = 17;

type
  PNMHdr = ^TNMHdr;
  TNMHdr = packed record
    hwndFrom: hWnd;
    idFrom: UInt;
    code: Integer;     { NM_ code }
  end;

  PStyleStruct = ^TStyleStruct;
  TStyleStruct = packed record
    styleOld: DWord;
    styleNew: DWord;
  end;

{ Message Function Templates }

function SetMessageQueue(cMessagesMax: Integer): Bool;

function RegisterHotKey(hWnd: hWnd; id: Integer; fsModifiers, vk: UInt): Bool;
function UnregisterHotKey(hWnd: hWnd; id: Integer): Bool;

const
  MOD_Alt = 1;
  MOD_Control = 2;
  MOD_Shift = 4;
  MOD_Win = 8;

  IdHot_SnapWindow = -1;    { Shift-PrintScrn  }
  IdHot_SnapDesktop = -2;   { PrintScrn        }

  EW_RestartWindows        = $0042;
  EW_RebootSystem          = $0043;
  EW_ExitAndExecApp        = $0044;

  EndSession_LogOff        = $80000000;

function SetMessageExtraInfo(lParam: lParam): lParam;

function SendMessageTimeout(hWnd: hWnd; Msg: UInt; wParam: wParam;
  lParam: lParam; fuFlags, uTimeout: UInt; var lpdwResult: DWord): lResult;
function SendNotifyMessage(hWnd: hWnd; Msg: UInt; wParam: wParam;
  lParam: lParam): Bool;
function SendMessageCallback(hWnd: hWnd; Msg: UInt; wParam: wParam;
  lParam: lParam; lpResultCallBack: TFNSendAsyncProc; dwData: DWord): Bool;
function BroadcastSystemMessage(Flags: DWord; Recipients: PDWORD;
  uiMessage: UInt; wParam: wParam; lParam: lParam): Longint;

const
  { Broadcast Special Message Recipient list }
  BSM_AllComponents = $00000000;
  BSM_VXDS = $00000001;
  BSM_NetDriver = $00000002;
  BSM_InstallableDrivers = $00000004;
  BSM_Applications = $00000008;
  BSM_AllDesktops = $00000010;

  { Broadcast Special Message Flags }
  BSF_Query = $00000001;
  BSF_IgnoreCurrentTask = $00000002;
  BSF_FlushDisk = $00000004;
  BSF_NoHang = $00000008;
  BSF_PostMessage = $00000010;
  BSF_ForceIfHung = $00000020;
  BSF_NoTimeoutIfNotHung = $00000040;

type
  PBroadcastSysMsg = ^TBroadcastSysMsg;
  TBroadcastSysMsg = packed record
    uiMessage: UInt;
    wParam: wParam;
    lParam: lParam;
  end;

const
  DBWF_LParamPointer = $8000;

  Broadcast_Query_Deny = $424D5144;  { Return this value to deny a query. }

function PostAppMessage(idThread: DWord; Msg: UInt; wParam: wParam; lParam: lParam): Bool;

const
  { Special hWnd value for use with PostMessage() and SendMessage() }
  wnd_Broadcast = HWND_Broadcast;

function AttachThreadInput(idAttach, idAttachTo: DWord; fAttach: Bool): Bool;
function WaitForInputIdle(hProcess: THandle; dwMilliseconds: DWord): DWord;
function RegisterClassEx(const WndClass: TWndClassEx): ATOM;
function GetClassInfoEx(Instance: hInst; Classname: PChar; var WndClass: TWndClassEx): Bool;

function ShowWindowAsync(hWnd: hWnd; nCmdShow: Integer): Bool;
function OpenIcon(hWnd: hWnd): Bool;
function AnyPopup: Bool;

const
  { SetWindowPos Flags }
  SWP_NoSendChanging = $400;  { Don't send WM_WindowPosChanging }
  SWP_DeferErase = $2000;
  SWP_AsyncWindowPos = $4000;

{ Character Translation Routines }

function CharNextEx(CodePage: Word; lpCurrentChar: LPCSTR; dwFlags: DWord): LPSTR;
function CharPrevEx(CodePage: Word; lpStart, lpCurrentChar: LPCSTR; dwFlags: DWord): LPSTR;

{ Language dependent Routines }

function GetKBCodePage: UInt;
function GetAsyncKeyState(vKey: Integer): SHORT;

type
  PKeyboardState = ^TKeyboardState;
  TKeyboardState = array[0..255] of Byte;

function GetKeyboardState(var KeyState: TKeyboardState): Bool;
function SetKeyboardState(var KeyState: TKeyboardState): Bool;
function ToAscii(uVirtKey, uScanCode: UInt; const KeyState: TKeyboardState;
  lpChar: PChar; uFlags: UInt): Integer;
function ToAsciiEx(uVirtKey: UInt; uScanCode: UInt; const KeyState: TKeyboardState;
  lpChar: PChar; uFlags: UInt; dwhkl: HKL): Integer;
function ToUnicode(wVirtKey, wScanCode: UInt; const KeyState: TKeyboardState;
  var pwszBuff; cchBuff: Integer; wFlags: UInt): Integer;
function OemKeyScan(wOemChar: Word): DWord;

function VkKeyScanEx(ch: Char; dwhkl: HKL): SHORT;

const
  KeyEventF_ExtendedKey = 1;
  KeyEventF_KeyUp = 2;

procedure keybd_event(bVk: Byte; bScan: Byte; dwFlags, dwExtraInfo: DWord);

const
  MouseEventF_Move            = $0001; { mouse move }
  MouseEventF_LeftDown        = $0002; { left button down }
  MouseEventF_LeftUp          = $0004; { left button up }
  MouseEventF_RightDown       = $0008; { right button down }
  MouseEventF_RightUp         = $0010; { right button up }
  MouseEventF_MiddleDown      = $0020; { middle button down }
  MouseEventF_MiddleUp        = $0040; { middle button up }
  MouseEventF_Wheel           = $0800; { wheel button rolled }
  MouseEventF_Absolute        = $8000; { absolute move }

procedure mouse_event(dwFlags, dx, dy, dwData, dwExtraInfo: DWord);
function MapVirtualKeyEx(uCode, uMapType: UInt; dwhkl: HKL): UInt;
function GetInputState: Bool;
function MsgWaitForMultipleObjectsEx(nCount: DWord; var pHandles;
  dwMilliseconds, dwWakeMask, dwFlags: DWord): DWord;

const
  MWMO_WaitAll = $0001;
  MWMO_Alertable = $0002;

  { Queue status flags for GetQueueStatus() and MsgWaitForMultipleObjects() }
  QS_AllPostMessage       = $0100;

{ Windows Functions }

function IsWindowUnicode(hWnd: hWnd): Bool;
function CopyAcceleratorTable(hAccelSrc: HACCEL; var lpAccelDst; cAccelEntries: Integer): Integer;

const
  { GetSystemMetrics() codes }
  SM_CxIconSpacing = 38;
  SM_CyIconSpacing = 39;
  SM_PenWindows = 41;
  SM_DBCSEnabled = 42;

  SM_CxFixedFrame = SM_CxDlgFrame; { win40 name change }
  SM_CyFixedfRame = SM_CyDlgFrame; { win40 name change }
  SM_CxSizeFrame = SM_CxFrame;     { win40 name change }
  SM_CySizeFrame = SM_CyFrame;     { win40 name change }

  SM_Secure = 44;
  SM_CxEdge = 45;
  SM_CyEdge = 46;
  SM_CxMinSpacing = 47;
  SM_CyMinSpacing = 48;
  SM_CxSmIcon = 49;
  SM_CySmIcon = 50;
  SM_CySmCaption = 51;
  SM_CxSmSize = 52;
  SM_CySmSize = 53;
  SM_CxMenuSize = 54;
  SM_CyMenuSize = 55;
  SM_ArRange = 56;
  SM_CxMinimized = 57;
  SM_CyMinimized = 58;
  SM_CxMaxTrack = 59;
  SM_CyMaxTrack = 60;
  SM_CxMaximized = 61;
  SM_CyMaximized = 62;
  SM_Network = 63;
  SM_CleanBoot = 67;
  SM_CxDrag = 68;
  SM_CyDrag = 69;
  SM_ShowSounds = 70;
  SM_CxMenuCheck = 71;     { Use instead of GetMenuCheckMarkDimensions()! }
  SM_CyMenuCheck = 72;
  SM_SlowMachine = 73;
  SM_MideastEnabled = 74;
  SM_MouseWheelPresent = 75;

function ChangeMenu(hMenu: hMenu; cmd: UInt; lpszNewItem: PChar;
  cmdInsert: UInt; flags: UInt): Bool;

const
  { return codes for WM_MENUCHAR }
  MNC_Ignore = 0;
  MNC_Close = 1;
  MNC_Execute = 2;
  MNC_Select = 3;

type
  PTPMParams = ^TTPMParams;
  TTPMParams = packed record
    cbSize: UInt;     { Size of structure }
    rcExclude: TRect; { Screen coordinates of rectangle to exclude when positioning }
  end;

function TrackPopupMenuEx(hMenu: hMenu; Flags: UInt; x, y: Integer;
  Wnd: hWnd; TPMParams: PTPMParams): Bool;

const
  MIIM_State = 1;
  MIIM_Id = 2;
  MIIM_Submenu = 4;
  MIIM_CheckMarks = 8;
  MIIM_Type = $10;
  MIIM_Data = $20;

type
  PMenuItemInfo = ^TMenuItemInfo;
  TMenuItemInfo = packed record
    cbSize: UInt;
    fMask: UInt;
    fType: UInt;             { used if MIIM_Type}
    fState: UInt;            { used if MIIM_State}
    wID: UInt;               { used if MIIM_Id}
    hSubMenu: hMenu;         { used if MIIM_Submenu}
    hbmpChecked: HBitmap;    { used if MIIM_CheckMarks}
    hbmpUnchecked: HBitmap;  { used if MIIM_CheckMarks}
    dwItemData: DWord;       { used if MIIM_Data}
    dwTypeData: PChar;       { used if MIIM_Type}
    cch: UInt;               { used if MIIM_TYPE}
  end;

function InsertMenuItem(P1: hMenu; P2: UInt; P3: Bool; const P4: TMenuItemInfo): Bool;
function GetMenuItemInfo(P1: hMenu; P2: UInt; P3: Bool; var P4: TMenuItemInfo): Bool;
function SetMenuItemInfo(P1: hMenu; P2: UInt; P3: Bool; const P4: TMenuItemInfo): Bool;

const
  GMDI_UseDisabled = 1;
  GMDI_GoIntoPopups = 2;

function GetMenuDefaultItem(hMenu: hMenu; fByPos, gmdiFlags: UInt): UInt;
function SetMenuDefaultItem(hMenu: hMenu; uItem, fByPos: UInt): Bool;
function GetMenuItemRect(hWnd: hWnd; hMenu: hMenu; uItem: UInt;
  var lprcItem: TRect): Bool;
function MenuItemFromPoint(hWnd: hWnd; hMenu: hMenu; ptScreen: TPoint): Bool;

const
  { Flags for TrackPopupMenu }
  TPM_TopAlign = 0;
  TPM_VCenteRalign = $10;
  TPM_BottomAlign = $20;

  TPM_Horizontal = 0;   { Horz alignment matters more }
  TPM_Vertical = $40;   { Vert alignment matters more }
  TPM_NoNotify = $80;   { Don't send any notification msgs }
  TPM_ReturnCmd = $100;


{ Drag-and-drop support }

type
  PDropStruct = ^TDropStruct;
  TDropStruct = packed record
    hwndSource: hWnd;
    hwndSink: hWnd;
    wFmt: DWord;
    dwData: DWord;
    ptDrop: TPoint;
    dwControlData: DWord;
  end;

const
  DOF_Executable = 32769;
  DOF_Document = 32770;
  DOF_Directory = 32771;
  DOF_Multiple = 32772;
  DOF_Progman = 1;
  DOF_Shelldata = 2;

  DO_DropFile = $454C4946;
  DO_PrintFile = $544E5250;

function DragObject(P1, P2: hWnd; P3: UInt; P4: DWord; P5: HIcon): DWord;
function DragDetect(P1: hWnd; P2: TPoint): Bool;

const
  { DrawText() Format Flags }
  DT_Internal = $1000;

  DT_EditControl = $2000;
  DT_Path_Ellipsis = $4000;
  DT_End_Ellipsis = $8000;
  DT_ModifyString = $10000;
  DT_RtlReading = $20000;
  DT_Word_Ellipsis = $40000;

type
  PDrawTextParams = ^TDrawTextParams;
  TDrawTextParams = packed record
    cbSize: UInt;
    iTabLength: Integer;
    iLeftMargin: Integer;
    iRightMargin: Integer;
    uiLengthDrawn: UInt;
  end;

function DrawTextEx(DC: HDC; lpchText: PChar; cchText: Integer; var P4: TRect;
  dwDTFormat: UInt; DTParams: PDrawTextParams): Integer;
function GrayString(hDC: HDC; hBrush: HBRUSH; lpOutputFunc: TFNGrayStringProc;
  lpData: lParam; nCount, X, Y, nWidth, nHeight: Integer): Bool;


{ Monolithic state-drawing routine }

const
  { Image type }
  DST_Complex = 0;
  DST_Text = 1;
  DST_PrefixText = 2;
  DST_Icon = 3;
  DST_Bitmap = 4;

  { State type }
  DSS_Normal = 0;
  DSS_Union = $10;     { Gray string appearance }
  DSS_Disabled = $20;
  DSS_Mono = $80;
  DSS_Right = $8000;

function DrawState(DC: HDC; P2: HBRUSH; P3: TFNDrawStateProc;
  P4: lParam; P5: wParam; P6, P7, P8, P9: Integer; P10: UInt): Bool;
function PaintDesktop(hdc: HDC): Bool;
function SetWindowRgn(hWnd: hWnd; hRgn: HRGN; bRedraw: Bool): Bool;
function GetWindowRgn(hWnd: hWnd; hRgn: HRGN): Bool;

const
  { EnableScrollBar() flags }
  ESB_Disable_Left = 1;
  ESB_Disable_Right = 2;
  ESB_Disable_Up = 1;
  ESB_Disable_Down = 2;

const
  HelpInfo_Window = 1;
  HelpInfo_MenuItem = 2;
type
  PHelpInfo = ^THelpInfo;
  THelpInfo = packed record{ Structure pointed to by lParam of WM_HELP }
    cbSize: UInt;          { Size in bytes of this struct  }
    iContextType: Integer; { Either HELPINFO_WINDOW or HELPINFO_MENUITEM }
    iCtrlId: Integer;      { Control Id or a Menu item Id. }
    hItemHandle: THandle;  { hWnd of control or hMenu.     }
    dwContextId: DWord;    { Context Id associated with this item }
    MousePos: TPoint;      { Mouse Position in screen co-ordinates }
  end;

function SetWindowContextHelpId(hWnd: hWnd; HelpID: DWord): Bool;
function GetWindowContextHelpId(hWnd: hWnd): DWord;
function SetMenuContextHelpId(hMenu: hMenu; HelpID: DWord): Bool;
function GetMenuContextHelpId(hMenu: hMenu): DWord;

const
  { MessageBox() Flags }
  MB_UserIcon = $00000080;
  MB_IconWarning                 = MB_IconExclamation;
  MB_IconError                   = MB_IconHand;
  MB_DefButton4 = $00000300;
  MB_TaskModal = $00002000;
  MB_Help = $00004000;                          { Help Button }

  MB_Default_Desktop_Only = $00020000;

  MB_Topmost = $00040000;
  MB_Right = $00080000;
  MB_RtlReading = $00100000;

  MB_Service_Notification_NT3x = $00040000;

function MessageBoxEx(hWnd: hWnd; lpText, lpCaption: PChar;
  uType: UInt; wLanguageId: Word): Integer;

type
  TPRMsgBoxCallback = procedure(var lpHelpInfo: THelpInfo);

  PMsgBoxParams = ^TMsgBoxParams;
  TMsgBoxParams = packed record
    cbSize: UInt;
    hwndOwner: hWnd;
    hInstance: hInst;
    lpszText: PChar;
    lpszCaption: PChar;
    dwStyle: DWord;
    lpszIcon: PChar;
    dwContextHelpId: DWord;
    lpfnMsgBoxCallback: TPRMsgBoxCallback;
    dwLanguageId: DWord;
  end;

function MessageBoxIndirect(const MsgBoxParams: TMsgBoxParams): Bool;

const
  CWP_All = 0;
  CWP_SkipInvisible = 1;
  CWP_SkipDisabled = 2;
  CWP_SkipTransparent = 4;

function ChildWindowFromPointEx(hWnd: hWnd; Point: TPoint; Flags: UInt): hWnd;

const
  { Color Types }
  Color_EndColors = Color_InfoBk;
  Color_Desktop = Color_Background;
  Color_3dFace = Color_BtnFace;
  Color_3dShadow = Color_BtnShadow;
  Color_3dHighlight = Color_BtnHighlight;
  Color_3dHilight = Color_BtnHighlight;
  Color_BtnHilight = Color_BtnHighlight;

function GetSysColorBrush(nIndex: Integer): HBRUSH;
function FindWindowEx(Parent, Child: hWnd; ClassName, WindowName: PChar): hWnd;
function EnumTaskWindows(hTask: THandle; lpfn: FARPROC; lParam: lParam): Bool;
function GetWindowTask(hWnd: hWnd): THandle;

function SetWindowsHook(nFilterType: Integer; pfnFilterProc: TFNHookProc): HHOOK;
function UnhookWindowsHook(nCode: Integer; pfnFilterProc: TFNHookProc): Bool;

{ Macros for source-level compatibility with old functions. }

type
  pHHook = ^HHook;

function DefHookProc(nCode: Integer; wParam: wParam; lParam: lParam; phhk: FARPROC): lResult; inline;
begin
  Result := CallNextHookEx( pHHook( phhk )^, nCode, wParam, lParam);
end;

const
{ Menu flags for AddCheckEnableMenuItem() }

  MF_Default = $1000;
  MF_RightJustify = $4000;

  MFT_String = MF_String;
  MFT_Bitmap = MF_Bitmap;
  MFT_MenubarBreak = MF_MenubarBreak;
  MFT_MenuBreak = MF_MenuBreak;
  MFT_OwnerDraw = MF_OwnerDraw;
  MFT_RadioCheck = $200;
  MFT_Separator = MF_Separator;
  MFT_RightOrder = $2000;
  MFT_RightJustify = MF_RightJustify;

  { Menu flags for AddCheckEnableMenuItem() }
  MFS_Grayed = 3;
  MFS_Disabled = MFS_Grayed;
  MFS_Checked = MF_Checked;
  MFS_Hilite = MF_Hilite;
  MFS_Enabled = MF_Enabled;
  MFS_Unchecked = MF_Unchecked;
  MFS_Unhilite = MF_Unhilite;
  MFS_Default = MF_Default;

function CheckMenuRadioItem(hMenu: hMenu; First, Last, Check, Flags: UInt): Bool;

const
  { System Menu Command Values }
  SC_Default = 61792;
  SC_MonitorPower = 61808;
  SC_ContextHelp = 61824;
  SC_Separator = 61455;

{ Resource Loading Routines }

function LoadCursorFromFile(lpFileName: PChar): HCursor;

const
  { Standard Cursor IDs }
  IDC_Help = MakeIntResource(32651);

function SetSystemCursor(hcur: HIcon; id: DWord): Bool;

//function DestroyIcon(HIcon: HIcon): Bool;
function LookupIconIdFromDirectory(presbits: PByte; fIcon: Bool): Integer;
function LookupIconIdFromDirectoryEx(presbits: PByte; fIcon: Bool;
  cxDesired, cyDesired: Integer; Flags: UInt): Integer;
function CreateIconFromResourceEx(presbits: PByte; dwResSize: DWord;
  fIcon: Bool; dwVer: DWord; cxDesired, cyDesired: Integer; Flags: UInt): HIcon;

type
  { IconCursor header }
  PCursorShape = ^TCursorShape;
  TCursorShape = record
    xHotSpot: Integer;
    yHotSpot: Integer;
    cx: Integer;
    cy: Integer;
    cbWidth: Integer;
    Planes: Byte;
    BitsPixel: Byte;
  end;

const
  Image_Bitmap = 0;
  Image_Icon = 1;
  Image_Cursor = 2;
  Image_EnhMetaFile = 3;

  LR_DefaultColor = $0000;
  LR_Monochrome = $0001;
  LR_Color = $0002;
  LR_CopyReturnOrg = $0004;
  LR_CopyDeleteOrg = $0008;
  LR_LoadFromFile = $0010;
  LR_LoadTransparent = $0020;
  LR_DefaultSize = $0040;
  LR_VgaColor = $0080;
  LR_LoadMap3dColors = $1000;
  LR_CreateDibSection = $2000;
  LR_CopyFromResource = $4000;
  LR_Shared = $8000;

function LoadImage(hInst: hInst; ImageName: PChar; ImageType: UInt; X, Y: Integer; Flags: UInt): THandle;
function CopyImage(hImage: THandle; ImageType: UInt; X, Y: Integer; Flags: UInt): THandle;

const
  DI_Mask = 1;
  DI_Image = 2;
  DI_Normal = 3;
  DI_Compat = 4;
  DI_DefaultSize = 8;

function DrawIconEx(hdc: HDC; xLeft, yTop: Integer; HIcon: HIcon;
  cxWidth, cyWidth: Integer; istepIfAniCur: UInt;
  hbrFlickerFreeDraw: HBRUSH; diFlags: UInt): Bool;

const
  OCR_Normal              = 32512;
  OCR_IBeam               = 32513;
  OCR_Wait                = 32514;
  OCR_Cross               = 32515;
  OCR_Up                  = 32516;
  OCR_Size                = 32640;  { OBSOLETE: use OCR_SizeAll }
  OCR_Icon                = 32641;  { OBSOLETE: use OCR_Normal }
  OCR_SizeNWSE            = 32642;
  OCR_SizeNESW            = 32643;
  OCR_SizeWE              = 32644;
  OCR_SizeNS              = 32645;
  OCR_SizeALL             = 32646;
  OCR_IcocUR              = 32647;  { OBSOLETE: use OIC_WinLogo }
  OCR_No                  = 32648;
  OCR_AppStarting         = 32650;

  OIC_Sample              = 32512;
  OIC_Hand                = 32513;
  OIC_Ques                = 32514;
  OIC_Bang                = 32515;
  OIC_Note                = 32516;
  OIC_WinLogo             = 32517;
  OIC_Warning             = OIC_Bang;
  OIC_Error               = OIC_Hand;
  OIC_Information         = OIC_Note;

  RES_Icon = 1;
  RES_Cursor = 2;

  { The ordinal number for the entry point of language drivers. }
  ORD_LangDriver = 1;

  { Standard Icon IDs }
  IDI_WinLogo = MakeIntResource(32517);
  IDI_Warning = IDI_Exclamation;
  IDI_Error = IDI_Hand;
  IDI_Information = IDI_Asterisk;

const
{ Control Manager Structures and Definitions }

  { Edit Control Styles }
  ES_Number = $2000;

  { Edit control EM_SetMargin parameters }
  EC_LeftMargin = 1;
  EC_RightMargin = 2;
  EC_UseFontInfo = 65535;

  { TFNEditWordBreakProc code values }
  WB_Left = 0;
  WB_Right = 1;
  WB_IsDelimiter = 2;

  { Button Control Styles }
  BS_Text = 0;
  BS_Icon = $40;
  BS_Bitmap = $80;
  BS_Left = $100;
  BS_Right = $200;
  BS_Center = 768;
  BS_Top = $400;
  BS_Bottom = $800;
  BS_VCenter = 3072;
  BS_PushLike = $1000;
  BS_Multiline = $2000;
  BS_Notify = $4000;
  BS_Flat = $8000;
  BS_RightButton = BS_LeftText;

  BST_Unchecked = 0;
  BST_Checked = 1;
  BST_InDeterminate = 2;
  BST_Pushed = 4;
  BST_Focus = 8;

  { Static Control Constants }
  SS_Bitmap = 14;
  SS_OwnerDraw = 13;
  SS_EnhMetaFiLe = 15;
  SS_EtchedHorz = $10;
  SS_EtchedVert = 17;
  SS_EtchedFrame = 18;
  SS_TypeMask = 31;
  SS_Notify = $100;
  SS_CenterImage = $200;
  SS_RightJust = $400;
  SS_RealSizeImage = $800;
  SS_Sunken = $1000;
  SS_EndEllipsis =  $4000;
  SS_PathEllipsis = $8000;
  SS_WordEllipsis = $C000;
  SS_EllipsisMask = $C000;

  { Static Control Mesages }
  STM_SetIcon = 368;
  STM_GetIcon = 369;
  STM_SetImage = 370;
  STM_GetImage = 371;
  STN_Clicked = 0;
  STN_DblClk = 1;
  STN_Enable = 2;
  STN_Disable = 3;
  STM_MsgMax = 372;

  { Dialog window class }
  WC_Dialog = MakeIntAtom($8002);

{ Dialog Manager Routines }

const
  { Dialog Styles }
  DS_3dLook = 4;
  DS_FixedSys = 8;
  DS_NoFailCreate = $10;
  DS_Control = $400;
  DS_Center = $800;
  DS_CenterMouse = $1000;
  DS_ContextHelp = $2000;

  PSI_SetActive = 1;
  PSI_KillActive = 2;
  PSI_Apply = 3;
  PSI_Reset = 4;
  PSI_HasHelp = 5;
  PSI_Help = 6;

  PSI_Changed = 1;
  PSI_GuiStart = 2;
  PSI_Reboot = 3;
  PSI_GetSiblings = 4;

  { Dialog Codes }
  LB_CtlCode = 0;

  { Listbox Styles }
  LBS_NoSel = $4000;

  CBS_UpperCase = $2000;
  CBS_LowerCase = $4000;

  SBS_SizeGrip = $10;

  SIF_Range = 1;
  SIF_Page = 2;
  SIF_POS = 4;
  SIF_DisableNoScroll = 8;
  SIF_TrackPos = $10;
  SIF_All = (SIF_Range or SIF_Page or SIF_Pos or SIF_TrackPos);

type
  TScrollInfo = packed record
    cbSize: UInt;
    fMask: UInt;
    nMin: Integer;
    nMax: Integer;
    nPage: UInt;
    nPos: Integer;
    nTrackPos: Integer;
  end;

function SetScrollInfo(hWnd: hWnd; BarFlag: Integer; const ScrollInfo: TScrollInfo; Redraw: Bool): Integer;
function GetScrollInfo(hWnd: hWnd; BarFlag: Integer; var ScrollInfo: TScrollInfo): Bool;
function TileWindows(hwndParent: hWnd; wHow: UInt; lpRect: PRect; cKids: UInt; lpKids: Pointer): Word;
function CascadeWindows(hwndParent: hWnd; wHow: UInt; lpRect: PRect; cKids: UInt; lpKids: Pointer): Word;


{ IME class support }

const
  { wParam for WM_IME_CONTROL (removed from 4.0 SDK) }
  IMC_GetCandidatePos = 7;
  IMC_SetCandidatePos = 8;
  IMC_GetCompositionFont = 9;
  IMC_SetCompositionFont = $0A;
  IMC_GetCompositionWindow = $0B;
  IMC_SetCompositionWindow = $0C;
  IMC_GetStatusWindowPos = $0F;
  IMC_SetStatusWindowPos = $10;
  IMC_CloseStatusWindow = $21;
  IMC_OpenStatusWindow = $22;

  { wParam of report message WM_IME_Notify (removed from 4.0 SDK) }
  IMN_CloseStatusWindow = 1;
  IMN_OpenStatusWindow = 2;
  IMN_ChangeCandidate = 3;
  IMN_CloseCandidate = 4;
  IMN_OpenCandidate = 5;
  IMN_SetConversionMode = 6;
  IMN_SetSentenceMode = 7;
  IMN_SetOpenStatus = 8;
  IMN_SetCandidatePos = 9;
  IMN_SetCompositionFont = 10;
  IMN_SetCompositionWindow = 11;
  IMN_SetStatusWindowPos = 12;
  IMN_Guideline = 13;
  IMN_Private = 14;

{ Help support }

type
  HelpPoly = DWord;
  PMultiKeyHelp = ^TMultiKeyHelp;
  TMultiKeyHelp = record
    mkSize: DWord;
    mkKeylist: AnsiChar;
    szKeyphrase: array[0..0] of AnsiChar;
  end;

  PHelpWinInfo = ^THelpWinInfo;
  THelpWinInfo = record
    wStructSize: Integer;
    x: Integer;
    y: Integer;
    dx: Integer;
    dy: Integer;
    wMax: Integer;
    rgchMember: array[0..1] of AnsiChar;
  end;

const
  { Commands to pass to WinHelp() }
  Help_ContextMenu = 10;
  Help_Finder = 11;
  Help_WM_Help = 12;
  Help_SetPopup_Pos = 13;

  Help_TCard = $8000;
  Help_TCard_Data = $10;
  Help_TCard_Other_Caller = 17;

  { These are in winhelp.h in Win95. }
  IDH_No_Help = 28440;
  IDH_Missing_Context = 28441;      { Control doesn't have matching help context }
  IDH_Generic_Help_Button = 28442;  { Property sheet help button }
  IDH_Ok = 28443;
  IDH_Cancel = 28444;
  IDH_Help = 28445;

const
  { Parameter for SystemParametersInfo() }
  SPI_SetWorkarea = 47;
  SPI_ScreenSaverRunning = 97;
  SPI_GetSnapToDefButton = 95;
  SPI_SetSnapToDefButton = 96;
  SPI_GetMouseHoverWidth = 98;
  SPI_SetMouseHoverWidth = 99;
  SPI_GetMouseHoverHeight = 100;
  SPI_SetMouseHoverHeight = 101;
  SPI_GetMouseHoverTime = 102;
  SPI_SetMouseHoverTime = 103;
  SPI_GetWheelScrollLines = 104;
  SPI_SetWheelScrollLines = 105;

  Metrics_UseDefault = -1;

type
  PNonClientMetrics = ^TNonClientMetrics;
  TNonClientMetrics = packed record
    cbSize: UInt;
    iBorderWidth: Integer;
    iScrollWidth: Integer;
    iScrollHeight: Integer;
    iCaptionWidth: Integer;
    iCaptionHeight: Integer;
    lfCaptionFont: TLogFont;
    iSmCaptionWidth: Integer;
    iSmCaptionHeight: Integer;
    lfSmCaptionFont: TLogFont;
    iMenuWidth: Integer;
    iMenuHeight: Integer;
    lfMenuFont: TLogFont;
    lfStatusFont: TLogFont;
    lfMessageFont: TLogFont;
  end;

const
  ARW_BottomLeft = 0;
  ARW_BottomRight = 1;
  ARW_TopLeft = 2;
  ARW_TopRight = 3;
  ARW_StartMask = 3;
  ARW_StartRight = 1;
  ARW_StartTop = 2;

  ARW_Left = 0;
  ARW_Right = 0;
  ARW_Up = 4;
  ARW_Down = 4;
  ARW_Hide = 8;
  ARW_Valid = 15;

type
  PMinimizedMetrics = ^TMinimizedMetrics;
  TMinimizedMetrics = packed record
    cbSize: UInt;
    iWidth: Integer;
    iHorzGap: Integer;
    iVertGap: Integer;
    iArrange: Integer;
  end;

  PIconMetrics = ^TIconMetrics;
  TIconMetrics = packed record
    cbSize: UInt;
    iHorzSpacing: Integer;
    iVertSpacing: Integer;
    iTitleWrap: Integer;
    lfFont: TLogFont;
  end;

  PAnimationInfo = ^TAnimationInfo;
  TAnimationInfo = packed record
    cbSize: UInt;
    iMinAnimate: Longint;
  end;

type
  PSerialKeys = ^TSerialKeys;
  TSerialKeys = packed record
    cbSize: UInt;
    dwFlags: DWord;
    lpszActivePort: PChar;
    lpszPort: PChar;
    iBaudRate: UInt;
    iPortState: UInt;
    iActive: UInt;
  end;

const
  { flags for SERIALKEYS dwFlags field }
  SERKF_SERIALKEYSON = 1;
  SERKF_AVAILABLE = 2;
  SERKF_INDICATOR = 4;

type
  PHighContrast = ^PHighContrast;
  THighContrast = packed record
    cbSize: UInt;
    dwFlags: DWord;
    lpszDefaultScheme: PChar;
  end;

const
  { flags for HIGHCONTRAST dwFlags field }
  HCF_HIGHCONTRASTON      = $00000001;
  HCF_AVAILABLE           = $00000002;
  HCF_HOTKEYACTIVE        = $00000004;
  HCF_CONFIRMHOTKEY       = $00000008;
  HCF_HOTKEYSOUND         = $00000010;
  HCF_INDICATOR           = $00000020;
  HCF_HOTKEYAVAILABLE     = $00000040;

  { Flags for ChangeDisplaySettings }
  CDS_UpdateRegistry      = $00000001;
  CDS_Test                = $00000002;
  CDS_Fullscreen          = $00000004;
  CDS_Global              = $00000008;
  CDS_Set_Primary         = $00000010;
  CDS_Reset               = $40000000;
  CDS_SetRect             = $20000000;
  CDS_NoReset             = $10000000;

  { Return values for ChangeDisplaySettings }
  Disp_Change_Successful           = 0;
  Disp_Change_Restart              = 1;
  Disp_Change_Failed              = -1;
  Disp_Change_BadMode             = -2;
  Disp_Change_NotUpdated          = -3;
  Disp_Change_BadFlags            = -4;
  Disp_Change_BadParam            = -5;

function ChangeDisplaySettings(lpDevMode: PDeviceMode; dwFlags: DWord): Longint;
function ChangeDisplaySettingsEx(lpszDeviceName: PChar; var lpDevMode: TDeviceMode;
        wnd: hWnd; dwFlags: DWord; lParam: Pointer): Longint;
function EnumDisplaySettings(lpszDeviceName: PChar; iModeNum: DWord;
  var lpDevMode: TDeviceMode): Bool;

type
  { Accessibility support }
  PFilterKeys = ^TFilterKeys;
  TFilterKeys = packed record
    cbSize: UInt;
    dwFlags: DWord;
    iWaitMSec: DWord;       { Acceptance Delay}
    iDelayMSec: DWord;      { Delay Until Repeat}
    iRepeatMSec: DWord;     { Repeat Rate}
    iBounceMSec: DWord;     { Debounce Time}
  end;


const
  { TFilterKeys dwFlags field }
  FKF_FilterKeysOn = 1;
  FKF_Available = 2;
  FKF_HotkeyActive = 4;
  FKF_ConfirmHotkey = 8;
  FKF_HotkeySound = $10;
  FKF_Indicator = $20;
  FKF_ClickOn = $40;

type
  PStickyKeys = ^TStickyKeys;
  TStickyKeys = packed record
    cbSize: UInt;
    dwFlags: DWord;
  end;

const
  { TStickyKeys dwFlags field }
  SKF_StickyKeysOn = 1;
  SKF_Available = 2;
  SKF_HotkeyActive = 4;
  SKF_ConfirmHotkey = 8;
  SKF_HotkeySound = $10;
  SKF_Indicator = $20;
  SKF_AudibleFeedback = $40;
  SKF_Tristate = $80;
  SKF_TwoKeySoff = $100;

type
  PMouseKeys = ^TMouseKeys;
  TMouseKeys = packed record
    cbSize: UInt;
    dwFlags: DWord;
    iMaxSpeed: DWord;
    iTimeToMaxSpeed: DWord;
    iCtrlSpeed: DWord;
    dwReserved1: DWord;
    dwReserved2: DWord;
  end;

const
  { TMouseKeys dwFlags field }
  MKF_MouseKeysOn = 1;
  MKF_Available = 2;
  MKF_HotKeyActive = 4;
  MKF_ConfirmHotkey = 8;
  MKF_HotkeySound = $10;
  MKF_Indicator = $20;
  MKF_Modifiers = $40;
  MKF_ReplaceNumbers = $80;

type
  PAccessTimeout = ^TAccessTimeout;
  TAccessTimeout = packed record
    cbSize: UInt;
    dwFlags: DWord;
    iTimeOutMSec: DWord;
  end;

const
  { TAccessTimeout dwFlags field }
  ATF_TimeoutOn = 1;
  ATF_OnOffFeedback = 2;

  { values for TSoundsEntry iFSGrafEffect field }
  SSGF_None = 0;
  SSGF_Display = 3;

  { values for TSoundsEntry iFSTextEffect field }
  SSTF_None = 0;
  SSTF_Chars = 1;
  SSTF_Border = 2;
  SSTF_Display = 3;

  { values for TSoundsEntry iWindowsEffect field }
  SSWF_None = 0;
  SSWF_Title = 1;
  SSWF_Window = 2;
  SSWF_Display = 3;
  SSWF_Custom = 4;

type
  PSoundsEntry = ^TSoundsEntry;
  TSoundsEntry = packed record
    cbSize: UInt;
    dwFlags: DWord;
    iFSTextEffect: DWord;
    iFSTextEffectMSec: DWord;
    iFSTextEffectColorBits: DWord;
    iFSGrafEffect: DWord;
    iFSGrafEffectMSec: DWord;
    iFSGrafEffectColor: DWord;
    iWindowsEffect: DWord;
    iWindowsEffectMSec: DWord;
    lpszWindowsEffectDLL: PChar;
    iWindowsEffectOrdinal: DWord;
  end;

const
  { SOUNDSENTRY dwFlags field }
  SSF_SoundsEntryOn = 1;
  SSF_Available = 2;
  SSF_Indicator = 4;


type
  PToggleKeys = ^TToggleKeys;
  TToggleKeys = packed record
    cbSize: UInt;
    dwFlags: DWord;
  end;

const
  { TToggleKeys dwFlags field }
  TKF_ToggleKeysOn = 1;
  TKF_Available = 2;
  TKF_HotKeyActive = 4;
  TKF_ConfirmHotkey = 8;
  TKF_HotkeySound = $10;
  TKF_Indicator = $20;

procedure SetDebugErrorLevel(dwLevel: DWord);

const
  { SetLastErrorEx() types. }
  SLE_Error = 1;
  SLE_MinorError = 2;
  SLE_Warning = 3;

procedure SetLastErrorEx(dwErrCode, dwType: DWord);


{ Translated from WINNLS.H }

const

{ String Length Maximums. }

  MAX_LeadBytes = 12; { 5 ranges, 2 bytes ea., 0 term. }
  MAX_DefaultChar = 2; { single or double byte }

{ MBCS and Unicode Translation Flags. }

  MB_PreComposed = 1; { use precomposed chars }
  MB_Composite = 2; { use composite chars }
  MB_UseGlyphChars = 4; { use glyph chars, not ctrl chars }

  WC_DefaultCheck = $100; { check for default char }
  WC_CompositeCheck = $200; { convert composite to precomposed }
  WC_DiscardNs = $10; { discard non-spacing chars }
  WC_SepChars = $20; { generate separate chars }
  WC_DefaultChar = $40; { replace w default char }

{ Character Type Flags. }

  CT_CType1 = 1; { ctype 1 information }
  CT_CType2 = 2; { ctype 2 information }
  CT_CType3 = 4; { ctype 3 information }

{ CType 1 Flag Bits. }

  C1_Upper = 1; { upper case }
  C1_Lower = 2; { lower case }
  C1_Digit = 4; { decimal digits }
  C1_Space = 8; { spacing characters }
  C1_Punct = $10; { punctuation characters }
  C1_Cntrl = $20; { control characters }
  C1_Blank = $40; { blank characters }
  C1_XDigit = $80; { other digits }
  C1_Alpha = $100; { any letter }

{ CType 2 Flag Bits. }

  C2_LeftToRight = 1; { left to right }
  C2_RightToLeft = 2; { right to left }
  C2_EuropeNumber = 3; { European number, digit }
  C2_EuropeSeparator = 4; { European numeric separator }
  C2_EuropeTerminator = 5; { European numeric terminator }
  C2_ArabicNumber = 6; { Arabic number }
  C2_CommonSeparator = 7; { common numeric separator }
  C2_BlockSeparator = 8; { block separator }
  C2_SegmentSeparator = 9; { segment separator }
  C2_WhiteSpace = 10; { white space }
  C2_OtherNeutral = 11; { other neutrals }
  C2_NotApplicable = 0; { no implicit directionality }

{ CType 3 Flag Bits. }

  C3_NonSpacing = 1; { nonspacing character }
  C3_Diacritic = 2; { diacritic mark }
  C3_VowelMark = 4; { vowel mark }
  C3_Symbol = 8; { symbols }
  C3_NotApplicable = 0; { ctype 3 is not applicable }

{ String Flags. }

  Norm_IgnoreCase = 1; { ignore case }
  Norm_IgnoreNonSpace = 2; { ignore nonspacing chars }
  Norm_IgnoreSymbols = 4; { ignore symbols }
  Norm_IgnoreKanatype = $10000;
  Norm_IgnoreWidth = $20000;

{ Locale Independent Mapping Flags. }

  Map_FoldCZone = $10; { fold compatibility zone chars }
  Map_PreComposed = $20; { convert to precomposed chars }
  Map_Composite = $40; { convert to composite chars }
  Map_FoldDigits = $80; { all digits to ASCII 0-9 }

{ Locale Dependent Mapping Flags. }

  LCMap_LowerCase = $00000100;              { lower case letters }
  LCMap_UpperCase = $00000200;              { upper case letters }
  LCMap_SortKey = $00000400;                { WC sort key (normalize) }
  LCMap_ByteRev = $00000800;                { byte reversal }

  LCMap_Hiragana = $00100000;               { map katakana to hiragana }
  LCMap_Katakana = $00200000;               { map hiragana to katakana }
  LCMap_HalfWidth = $00400000;              { map double byte to single byte }
  LCMap_FullwIdth = $00800000;              { map single byte to double byte }

  LCMap_Linguistic_Casing = $01000000;      { use linguistic rules for casing }

  LCMap_Simplified_Chinese      = $02000000;  { map traditional chinese to simplified chinese }
  LCMap_Traditional_Chinese     = $04000000;  { map simplified chinese to traditional chinese }

{ Locale Enumeration Flags. }

  LCID_Installed          = $00000001;  { installed locale ids }
  LCID_Supported          = $00000002;  { supported locale ids }

{ Code Page Enumeration Flags. }

  CP_Installed            = $00000001;  { installed code page ids }
  CP_Supported            = $00000002;  { supported code page ids }


{ Sorting Flags.

     WORD Sort:    culturally correct sort
                   hyphen and apostrophe are special cased
                   example: "coop" and "co-op" will sort together in a list

                         co_op     <-------  underscore (symbol)
                         coat
                         comb
                         coop
                         co-op     <-------  hyphen (punctuation)
                         cork
                         went
                         were
                         we're     <-------  apostrophe (punctuation)


     STRING Sort:  hyphen and apostrophe will sort with all other symbols

                         co-op     <-------  hyphen (punctuation)
                         co_op     <-------  underscore (symbol)
                         coat
                         comb
                         coop
                         cork
                         we're     <-------  apostrophe (punctuation)
                         went
                         were
 }

  Sort_StringSort = $1000; { use string sort method }

{ Code Page Default Values. }

  CP_ACP                   = 0;             { default to ANSI code page }
  CP_OemCP                 = 1;             { default to OEM  code page }
  CP_MacCP                 = 2;             { default to MAC  code page }

  CP_UTF7                  = 65000;         { UTF-7 translation }
  CP_UTF8                  = 65001;         { UTF-8 translation }

{ Country Codes. }

  Ctry_Default = 0;
  Ctry_Australia = 61; { Australia }
  Ctry_Austria = 43; { Austria }
  Ctry_Belgium = $20; { Belgium }
  Ctry_Brazil = 55; { Brazil }
  Ctry_Canada = 2; { Canada }
  Ctry_Denmark = 45; { Denmark }
  Ctry_Finland = 358; { Finland }
  Ctry_France = 33; { France }
  Ctry_Germany = 49; { Germany }
  Ctry_Iceland = 354; { Iceland }
  Ctry_Ireland = 353; { Ireland }
  Ctry_Italy = 39; { Italy }
  Ctry_Japan = 81; { Japan }
  Ctry_Mexico = 52; { Mexico }
  Ctry_Netherlands = 31; { Netherlands }
  Ctry_New_Zealand = $40; { New Zealand }
  Ctry_Norway = 47; { Norway }
  Ctry_Portugal = 351; { Portugal }
  Ctry_PrChina = 86; { PR China }
  Ctry_South_Korea = 82; { South Korea }
  Ctry_Spain = 34; { Spain }
  Ctry_Sweden = 46; { Sweden }
  Ctry_Switzerland = 41; { Switzerland }
  Ctry_Taiwan = 886; { Taiwan }
  Ctry_United_Kingdom = 44; { United Kingdom }
  Ctry_United_States = 1; { United States }

{ Locale Types.
  These types are used for the GetLocaleInfoW NLS API routine. }

{ locale_NoUserOverride is also used in GetTimeFormatW and GetDateFormatW. }

  Locale_NoUserOverride           = $80000000;   { do not use user overrides }
  Locale_Use_CP_ACP               = $40000000;   { use the system ACP }

  Locale_ILanguage                = $00000001;   { language id }
  Locale_SLanguage                = $00000002;   { localized name of language }
  Locale_SEngLanguage             = $00001001;   { English name of language }
  Locale_SAbbrevLangName          = $00000003;   { abbreviated language name }
  Locale_SNativeLangName          = $00000004;   { native name of language }

  Locale_ICountry                 = $00000005;   { country code }
  Locale_SCountry                 = $00000006;   { localized name of country }
  Locale_SEngCountry              = $00001002;   { English name of country }
  Locale_SAbbrevCtryName          = $00000007;   { abbreviated country name }
  Locale_SNativeCtryName          = $00000008;   { native name of country }

  Locale_IDefaultLanguage         = $00000009;   { default language id }
  Locale_IDefaultCountry          = $0000000A;   { default country code }
  Locale_IDefaultCodepage         = $0000000B;   { default oem code page }
  Locale_IDefaultAnsiCodepage     = $00001004;   { default ansi code page }
  Locale_IDefaultMacCodepage      = $00001011;   { default mac code page }

  Locale_SList                    = $0000000C;   { list item separator }
  Locale_IMeasure                 = $0000000D;   { 0 = metric, 1 = US }

  Locale_SDecimal                 = $0000000E;   { decimal separator }
  Locale_SThousand                = $0000000F;   { thousand separator }
  Locale_SGrouping                = $00000010;   { digit grouping }
  Locale_IDigits                  = $00000011;   { number of fractional digits }
  Locale_ILZero                   = $00000012;   { leading zeros for decimal }
  Locale_INegNumber               = $00001010;   { negative number mode }
  Locale_SNativeDigits            = $00000013;   { native ascii 0-9 }

  Locale_SCurrency                = $00000014;   { local monetary symbol }
  Locale_SIntlSymbol              = $00000015;   { intl monetary symbol }
  Locale_SMonDecimalSep           = $00000016;   { monetary decimal separator }
  Locale_SMonThousandSep          = $00000017;   { monetary thousand separator }
  Locale_SMonGrouping             = $00000018;   { monetary grouping }
  Locale_ICurrDigits              = $00000019;   { # local monetary digits }
  Locale_IIntlCurrDigits          = $0000001A;   { # intl monetary digits }
  Locale_ICurrency                = $0000001B;   { positive currency mode }
  Locale_INegCurr                 = $0000001C;   { negative currency mode }

  Locale_SDate                    = $0000001D;   { date separator }
  Locale_STime                    = $0000001E;   { time separator }
  Locale_SShortDate               = $0000001F;   { short date format string }
  Locale_SLongDate                = $00000020;   { long date format string }
  Locale_STimeFormat              = $00001003;   { time format string }
  Locale_IDate                    = $00000021;   { short date format ordering }
  Locale_ILDate                   = $00000022;   { long date format ordering }
  Locale_ITime                    = $00000023;   { time format specifier }
  Locale_ITimeMarkPosn            = $00001005;   { time marker position }
  Locale_ICentury                 = $00000024;   { century format specifier (short date) }
  Locale_ITLZero                  = $00000025;   { leading zeros in time field }
  Locale_IDayLZero                = $00000026;   { leading zeros in day field (short date) }
  Locale_IMonlZero                = $00000027;   { leading zeros in month field (short date) }
  Locale_S1159                    = $00000028;   { AM designator }
  Locale_S2359                    = $00000029;   { PM designator }

  Locale_ICalendarType            = $00001009;   { type of calendar specifier }
  Locale_IOptionalCalendar        = $0000100B;   { additional calendar types specifier }
  Locale_IFirstDayOfWeek          = $0000100C;   { first day of week specifier }
  Locale_IFirstWeekOfYear         = $0000100D;   { first week of year specifier }

  Locale_SDayName1                = $0000002A;   { long name for Monday }
  Locale_SDayName2                = $0000002B;   { long name for Tuesday }
  Locale_SDayName3                = $0000002C;   { long name for Wednesday }
  Locale_SDayName4                = $0000002D;   { long name for Thursday }
  Locale_SDayName5                = $0000002E;   { long name for Friday }
  Locale_SDayName6                = $0000002F;   { long name for Saturday }
  Locale_SDayName7                = $00000030;   { long name for Sunday }
  Locale_SAbbrevDayName1          = $00000031;   { abbreviated name for Monday }
  Locale_SAbbrevDayName2          = $00000032;   { abbreviated name for Tuesday }
  Locale_SAbbrevDayName3          = $00000033;   { abbreviated name for Wednesday }
  Locale_SAbbrevDayName4          = $00000034;   { abbreviated name for Thursday }
  Locale_SAbbrevDayName5          = $00000035;   { abbreviated name for Friday }
  Locale_SAbbrevDayName6          = $00000036;   { abbreviated name for Saturday }
  Locale_SAbbrevDayName7          = $00000037;   { abbreviated name for Sunday }
  Locale_SMonthName1              = $00000038;   { long name for January }
  Locale_SMonthName2              = $00000039;   { long name for February }
  Locale_SMonthName3              = $0000003A;   { long name for March }
  Locale_SMonthName4              = $0000003B;   { long name for April }
  Locale_SMonthName5              = $0000003C;   { long name for May }
  Locale_SMonthName6              = $0000003D;   { long name for June }
  Locale_SMonthName7              = $0000003E;   { long name for July }
  Locale_SMonthName8              = $0000003F;   { long name for August }
  Locale_SMonthName9              = $00000040;   { long name for September }
  Locale_SMonthName10             = $00000041;   { long name for October }
  Locale_SMonthName11             = $00000042;   { long name for November }
  Locale_SMonthName12             = $00000043;   { long name for December }
  Locale_SMonthName13             = $0000100E;   { long name for 13th month (if exists) }
  Locale_SAbbrevMonthName1        = $00000044;   { abbreviated name for January }
  Locale_SAbbrevMonthName2        = $00000045;   { abbreviated name for February }
  Locale_SAbbrevMonthName3        = $00000046;   { abbreviated name for March }
  Locale_SAbbrevMonthName4        = $00000047;   { abbreviated name for April }
  Locale_SAbbrevMonthName5        = $00000048;   { abbreviated name for May }
  Locale_SAbbrevMonthName6        = $00000049;   { abbreviated name for June }
  Locale_SAbbrevMonthName7        = $0000004A;   { abbreviated name for July }
  Locale_SAbbrevMonthName8        = $0000004B;   { abbreviated name for August }
  Locale_SAbbrevMonthName9        = $0000004C;   { abbreviated name for September }
  Locale_SAbbrevMonthName10       = $0000004D;   { abbreviated name for October }
  Locale_SAbbrevMonthName11       = $0000004E;   { abbreviated name for November }
  Locale_SAbbrevMonthName12       = $0000004F;   { abbreviated name for December }
  Locale_SAbbrevMonthName13       = $0000100F;   { abbreviated name for 13th month (if exists) }

  Locale_SPositiveSign            = $00000050;   { positive sign }
  Locale_SNegativeSign            = $00000051;   { negative sign }
  Locale_IPosSignPosn             = $00000052;   { positive sign position }
  Locale_INegSignPosn             = $00000053;   { negative sign position }
  Locale_IPosSymPrecedes          = $00000054;   { mon sym precedes pos amt }
  Locale_IPosSepBySpace           = $00000055;   { mon sym sep by space from pos amt }
  Locale_INegSymPrecedes          = $00000056;   { mon sym precedes neg amt }
  Locale_INegSepBySpace           = $00000057;   { mon sym sep by space from neg amt }

  Locale_FontSignature            = $00000058;   { font signature }
  Locale_SISO639LangName          = $00000059;   { ISO abbreviated language name }
  Locale_SISO3166CtryName         = $0000005A;   { ISO abbreviated country name }


{ Time Flags for GetTimeFormatW. }

  TIME_NoMinutesOrSeconds = 1; { do not use minutes or seconds }
  TIME_NoSeconds = 2; { do not use seconds }
  TIME_NoTimeMarker = 4; { do not use time marker }
  TIME_Force24HourFormat = 8; { always use 24 hour format }

{ Date Flags for GetDateFormatW. }

  DATE_ShortDate = 1; { use short date picture }
  DATE_LongDate = 2; { use long date picture }
  DATE_Use_Alt_Calendar = 4;   { use alternate calendar (if any) }

{ Calendar Types.
  These types are used for the GetALTCalendarInfoW NLS API routine. }

  CAL_ICalIntValue = 1;   { calendar type }
  CAL_SCalName = 2;   { native name of calendar }
  CAL_IYearOffsetRange = 3;   { starting years of eras }
  CAL_SEraString = 4;   { era name for IYearOffsetRanges }
  CAL_SShortDate = 5;   { short date format string }
  CAL_SLongDate = 6;   { long date format string }
  CAL_SDayName1 = 7;   { native name for Monday }
  CAL_SDayName2 = 8;   { native name for Tuesday }
  CAL_SDayName3 = 9;   { native name for Wednesday }
  CAL_SDayName4 = 10;   { native name for Thursday }
  CAL_SDayName5 = 11;   { native name for Friday }
  CAL_SDayName6 = 12;   { native name for Saturday }
  CAL_SDayName7 = 13;   { native name for Sunday }
  CAL_SAbbrevDayName1 = 14;   { abbreviated name for Monday }
  CAL_SAbbrevDayName2 = 15;   { abbreviated name for Tuesday }
  CAL_SAbbrevDayName3 = $10;   { abbreviated name for Wednesday }
  CAL_SAbbrevDayName4 = 17;   { abbreviated name for Thursday }
  CAL_SAbbrevDayName5 = 18;   { abbreviated name for Friday }
  CAL_SAbbrevDayName6 = 19;   { abbreviated name for Saturday }
  CAL_SAbbrevDayName7 = 20;   { abbreviated name for Sunday }
  CAL_SMonthNAME1 = 21;   { native name for January }
  CAL_SMonthName2 = 22;   { native name for February }
  CAL_SMonthName3 = 23;   { native name for March }
  CAL_SMonthName4 = 24;   { native name for April }
  CAL_SMonthName5 = 25;   { native name for May }
  CAL_SMonthName6 = 26;   { native name for June }
  CAL_SMonthName7 = 27;   { native name for July }
  CAL_SMonthName8 = 28;   { native name for August }
  CAL_SMonthName9 = 29;   { native name for September }
  CAL_SMonthName10 = 30;   { native name for October }
  CAL_SMonthName11 = 31;   { native name for November }
  CAL_SMonthName12 = $20;   { native name for December }
  CAL_SMonthName13 = 33;   { native name for 13th month (if any) }
  CAL_SAbbrevMonthName1 = 34;   { abbreviated name for January }
  CAL_SAbbrevMonthName2 = 35;   { abbreviated name for February }
  CAL_SAbbrevMonthName3 = 36;   { abbreviated name for March }
  CAL_SAbbrevMonthName4 = 37;   { abbreviated name for April }
  CAL_SAbbrevMonthName5 = 38;   { abbreviated name for May }
  CAL_SAbbrevMonthName6 = 39;   { abbreviated name for June }
  CAL_SAbbrevMonthName7 = 40;   { abbreviated name for July }
  CAL_SAbbrevMonthName8 = 41;   { abbreviated name for August }
  CAL_SAbbrevMonthName9 = 42;   { abbreviated name for September }
  CAL_SAbbrevMonthName10 = 43;   { abbreviated name for October }
  CAL_SAbbrevMonthName11 = 44;   { abbreviated name for November }
  CAL_SAbbrevMonthName12 = 45;   { abbreviated name for December }
  CAL_SAbbrevMonthName13 = 46;   { abbreviated name for 13th month (if any) }

{ Calendar Enumeration Value. }

  Enum_All_Calendars = $FFFFFFFF;   { enumerate all calendars }

{ Calendar ID Values. }

  CAL_Gregorian = 1;           { Gregorian (localized) calendar }
  CAL_Gregorian_US = 2;        { Gregorian (U.S.) calendar }
  CAL_Japan = 3;               { Japanese Emperor Era calendar }
  CAL_Taiwan = 4;              { Republic of China Era calendar }
  CAL_Korea = 5;               { Korean Tangun Era calendar }
  CAL_Hijri = 6;               { Hijri (Arabic Lunar) calendar }
  CAL_Thai = 7;                { Thai calendar }
  CAL_Hebrew = 8;              { Hebrew calendar }


type
  LCType = DWord;   { Locale type constant. }
  CalType = DWord;  { Calendar type constant. }
  CalId = DWord;    { Calendar ID. }

  PCPInfo = ^TCPInfo;
  TCPInfo = record
    MaxCharSize: UInt;                       { max length (bytes) of a char }
    DefaultChar: array[0..Max_DefaultChar - 1] of Byte; { default character }
    LeadByte: array[0..Max_LeadBytes - 1] of Byte;      { lead byte ranges }
  end;

type
  PNumberFmt = ^TNumberFmt;
  TNumberFmt = packed record
    NumDigits: UInt;        { number of decimal digits }
    LeadingZero: UInt;      { if leading zero in decimal fields }
    Grouping: UInt;         { group size left of decimal }
    lpDecimalSep: PChar;    { ptr to decimal separator string }
    lpThousandSep: PChar;   { ptr to thousand separator string }
    NegativeOrder: UInt;    { negative number ordering }
  end;

  PCurrencyFmt = ^TCurrencyFmt;
  TCurrencyFmt = packed record
    NumDigits: UInt;           { number of decimal digits }
    LeadingZero: UInt;         { if leading zero in decimal fields }
    Grouping: UInt;            { group size left of decimal }
    lpDecimalSep: PChar;       { ptr to decimal separator string }
    lpThousandSep: PChar;      { ptr to thousand separator string }
    NegativeOrder: UInt;       { negative currency ordering }
    PositiveOrder: UInt;       { positive currency ordering }
    lpCurrencySymbol: PChar;   { ptr to currency symbol string }
  end;

{ Enumeration function constants. }

  TFNLocaleEnumProc = TFarProc;
  TFNCodepageEnumProc = TFarProc;
  TFNDateFmtEnumProc = TFarProc;
  TFNTimeFmtEnumProc = TFarProc;
  TFNCalInfoEnumProc = TFarProc;


{ Code Page Dependent APIs. }

function IsValidCodePage(CodePage: UInt): Bool;
function GetCPInfo(CodePage: UInt; var lpCPInfo: TCPInfo): Bool;
function IsDBCSLeadByteEx(CodePage: UInt; TestChar: Byte): Bool;
function MultiByteToWideChar(CodePage: UInt; dwFlags: DWord;
  const lpMultiByteStr: LPCSTR; cchMultiByte: Integer;
  lpCharStr: LPWSTR; cchWideChar: Integer): Integer;
function WideCharToMultiByte(CodePage: UInt; dwFlags: DWord;
  lpCharStr: LPWSTR; cchWideChar: Integer; lpMultiByteStr: LPSTR;
  cchMultiByte: Integer; lpDefaultChar: LPCSTR; lpUsedDefaultChar: PBool): Integer;

{ Locale Dependent APIs. }

function CompareString(Locale: LCID; dwCmpFlags: DWord; lpString1: PChar;
  cchCount1: Integer; lpString2: PChar; cchCount2: Integer): Integer;
function LCMapString(Locale: LCID; dwMapFlags: DWord; lpSrcStr: PChar;
  cchSrc: Integer; lpDestStr: PChar; cchDest: Integer): Integer;
function GetLocaleInfo(Locale: LCID; LCType: LCTYPE; lpLCData: PChar; cchData: Integer): Integer;
function SetLocaleInfo(Locale: LCID; LCType: LCTYPE; lpLCData: PChar): Bool;
function GetTimeFormat(Locale: LCID; dwFlags: DWord; lpTime: PSystemTime;
  lpFormat: PChar; lpTimeStr: PChar; cchTime: Integer): Integer;
function GetDateFormat(Locale: LCID; dwFlags: DWord; lpDate: PSystemTime;
  lpFormat: PChar; lpDateStr: PChar; cchDate: Integer): Integer;
function GetNumberFormat(Locale: LCID; dwFlags: DWord; lpValue: PChar;
  lpFormat: PNumberFmt; lpNumberStr: PChar; cchNumber: Integer): Integer;
function GetCurrencyFormat(Locale: LCID; dwFlags: DWord; lpValue: PChar;
  lpFormat: PCurrencyFmt; lpCurrencyStr: PChar; cchCurrency: Integer): Integer;
function EnumCalendarInfo(lpCalInfoEnumProc: TFNCalInfoEnumProc; Locale: LCID;
  Calendar: CALID; CalType: CALTYPE): Bool;
function EnumTimeFormats(lpTimeFmtEnumProc: TFNTimeFmtEnumProc;
  Locale: LCID; dwFlags: DWord): Bool;
function EnumDateFormats(lpDateFmtEnumProc: TFNDateFmtEnumProc;
  Locale: LCID; dwFlags: DWord): Bool;
function IsValidLocale(Locale: LCID; dwFlags: DWord): Bool;
function ConvertDefaultLocale(Locale: LCID): LCID;
function GetThreadLocale: LCID;
function SetThreadLocale(Locale: LCID): Bool;
function GetSystemDefaultLangID: LANGID;
function GetUserDefaultLangID: LANGID;
function GetSystemDefaultLCID: LCID;
function GetUserDefaultLCID: LCID;

{ Locale Independent APIs. }

function GetStringTypeEx(Locale: LCID; dwInfoType: DWord;
  lpSrcStr: PChar; cchSrc: Integer; var lpCharType): Bool;

function GetStringTypeA(Locale: LCID; dwInfoType: DWord; const lpSrcStr: LPCSTR; cchSrc: Bool; var lpCharType: Word): Bool;

function FoldString(dwMapFlags: DWord; lpSrcStr: PChar; cchSrc: Integer;
  lpDestStr: PChar; cchDest: Integer): Integer;
function EnumSystemLocales(lpLocaleEnumProc: TFNLocaleEnumProc; dwFlags: DWord): Bool;
function EnumSystemCodePages(lpCodePageEnumProc: TFNCodepageEnumProc; dwFlags: DWord): Bool;


{ Translated from WINCON.H }

{ This module contains the public data structures, data types,
    and procedures exported by the NT console subsystem. }

type
  PCoord = ^TCoord;
  TCoord = packed record
    X: SHORT;
    Y: SHORT;
  end;

  PSmallRect = ^TSmallRect;
  TSmallRect = packed record
    Left: SHORT;
    Top: SHORT;
    Right: SHORT;
    Bottom: SHORT;
  end;

  PKeyEventRecord = ^TKeyEventRecord;
  TKeyEventRecord = packed record
    bKeyDown: Bool;
    wRepeatCount: Word;
    wVirtualKeyCode: Word;
    wVirtualScanCode: Word;
    case Integer of
      0: (
        UnicodeChar: WCHAR;
        dwControlKeyState: DWord);
      1: (
        AsciiChar: CHAR);
  end;

const
{ ControlKeyState flags }

  Right_Alt_Pressed = 1;     { the right alt key is pressed. }
  Left_Alt_Pressed = 2;     { the left alt key is pressed. }
  Right_Ctrl_Pressed = 4;     { the right ctrl key is pressed. }
  Left_Ctrl_Pressed = 8;     { the left ctrl key is pressed. }
  Shift_Pressed = $10;     { the shift key is pressed. }
  NumLock_On = $20;     { the numlock light is on. }
  ScrollLock_On = $40;     { the scrolllock light is on. }
  CapsLock_On = $80;     { the capslock light is on. }
  Enhanced_Key = $100;     { the key is enhanced. }

type
  PMouseEventRecord = ^TMouseEventRecord;
  TMouseEventRecord = packed record
    dwMousePosition: TCoord;
    dwButtonState: DWord;
    dwControlKeyState: DWord;
    dwEventFlags: DWord;
  end;

const
{ ButtonState flags }

  From_Left_1st_Button_Pressed = 1;
  Rightmost_Button_Pressed = 2;
  From_Left_2nd_Button_Pressed = 4;
  From_Left_3rd_Button_Pressed = 8;
  From_Left_4th_Button_Pressed = $10;

{ EventFlags }

  Mouse_Moved = 1;
  Double_Click = 2;

type
  PWindowBufferSizeRecord = ^TWindowBufferSizeRecord;
  TWindowBufferSizeRecord = packed record
    dwSize: TCoord;
  end;

  PMenuEventRecord = ^TMenuEventRecord;
  TMenuEventRecord = packed record
    dwCommandId: UInt;
  end;

  PFocusEventRecord = ^TFocusEventRecord;
  TFocusEventRecord = packed record
    bSetFocus: Bool;
  end;

  PInputRecord = ^TInputRecord;
  TInputRecord = record
    EventType: Word;
    case Integer of
      0: (KeyEvent: TKeyEventRecord);
      1: (MouseEvent: TMouseEventRecord);
      2: (WindowBufferSizeEvent: TWindowBufferSizeRecord);
      3: (MenuEvent: TMenuEventRecord);
      4: (FocusEvent: TFocusEventRecord);
  end;


const
{  EventType flags: }

  Key_Event = 1;       { Event contains key event record}
  _Mouse_event = 2;  { Renamed }   { Event contains mouse event record }
  Window_Buffer_Size_Event = 4;  { Event contains window change event record }
  Menu_Event = 8;     { Event contains menu event record }
  Focus_Event = $10;  { event contains focus change }

type
  PCharInfo = ^TCharInfo;
  TCharInfo = packed record
    case Integer of
      0: (
        UnicodeChar: WCHAR;
        Attributes: Word);
      1: (
        AsciiChar: CHAR);
  end;

const
{ Attributes flags:}

  Foreground_Blue = 1;    { text color contains blue.}
  Foreground_Green = 2;     { text color contains green. }
  Foreground_Red = 4;     { text color contains red. }
  Foreground_Intensity = 8;     { text color is intensified. }
  Background_Blue = $10;     { background color contains blue. }
  Background_Green = $20;     { background color contains green. }
  Background_Red = $40;     { background color contains red. }
  Background_Intensity = $80;     { background color is intensified. }

type
  PConsoleScreenBufferInfo = ^TConsoleScreenBufferInfo;
  TConsoleScreenBufferInfo = packed record
    dwSize: TCoord;
    dwCursorPosition: TCoord;
    wAttributes: Word;
    srWindow: TSmallRect;
    dwMaximumWindowSize: TCoord;
  end;

  PConsoleCursorInfo = ^TConsoleCursorInfo;
  TConsoleCursorInfo = packed record
    dwSize: DWord;
    bVisible: Bool;
  end;

  PWin32Cell = ^TWin32Cell;
  TWin32Cell = record
    Ch:     SmallWord;
    Attr:   SmallWord;
  end;

  TFNHandlerRoutine = TFarProc;

const
  Ctrl_C_Event = 0;
  Ctrl_Break_Event = 1;
  Ctrl_Close_Event = 2;
  { 3 is reserved! }
  { 4 is reserved! }

  Ctrl_LogOff_Event = 5;
  Ctrl_ShutDown_Event = 6;
  Enable_Processed_Input = 1;     {  Input Mode flags: }
  Enable_Line_Input = 2;
  Enable_Echo_Input = 4;
  Enable_Window_Input = 8;
  Enable_MOUSE_Input = $10;
  Enable_Processed_Output = 1;     { Output Mode flags: }
  Enable_Wrap_at_Eol_Output = 2;

{ direct API definitions. }
function PeekConsoleInput(hConsoleInput: THandle; var lpBuffer: TInputRecord;
  nLength: DWord; var lpNumberOfEventsRead: DWord): Bool;

function ReadConsoleInput(hConsoleInput: THandle; var lpBuffer: TInputRecord;
  nLength: DWord; var lpNumberOfEventsRead: DWord): Bool;

function WriteConsoleInput(hConsoleInput: THandle; const lpBuffer: TInputRecord;
  nLength: DWord; var lpNumberOfEventsWritten: DWord): Bool;

function ReadConsoleOutput(hConsoleOutput: THandle; lpBuffer: Pointer;
  dwBufferSize, dwBufferCoord: TCoord; var lpReadRegion: TSmallRect): Bool;

function WriteConsoleOutput(hConsoleOutput: THandle; lpBuffer: Pointer;
  dwBufferSize, dwBufferCoord: TCoord; var lpWriteRegion: TSmallRect): Bool;

function ReadConsoleOutputCharacter(hConsoleOutput: THandle; lpCharacter: PChar;
  nLength: DWord; dwReadCoord: TCoord; var lpNumberOfCharsRead: Cardinal): Bool;

function ReadConsoleOutputAttribute(hConsoleOutput: THandle; lpAttribute: Pointer;
  nLength: DWord; dwReadCoord: TCoord; var lpNumberOfAttrsRead: Cardinal): Bool;

function WriteConsoleOutputCharacter(hConsoleOutput: THandle;lpCharacter: PChar;
  nLength: DWord; dwWriteCoord: TCoord; var lpNumberOfCharsWritten: Cardinal): Bool;
function WriteConsoleOutputAttribute(hConsoleOutput: THandle; lpAttribute: Pointer;
  nLength: DWord; dwWriteCoord: TCoord; var lpNumberOfAttrsWritten: Cardinal): Bool;
function FillConsoleOutputCharacter(hConsoleOutput: THandle; cCharacter: Char;
  nLength: DWord; dwWriteCoord: TCoord; var lpNumberOfCharsWritten: DWord): Bool;
function FillConsoleOutputAttribute(hConsoleOutput: THandle; wAttribute: Word;
  nLength: DWord; dwWriteCoord: TCoord; var lpNumberOfAttrsWritten: DWord): Bool;

function GetConsoleMode(hConsoleHandle: THandle; var lpMode: DWord): Bool;

function GetNumberOfConsoleInputEvents(hConsoleInput: THandle;
  var lpNumberOfEvents: DWord): Bool;

function GetConsoleScreenBufferInfo(hConsoleOutput: THandle;
  var lpConsoleScreenBufferInfo: TConsoleScreenBufferInfo): Bool;

function GetLargestConsoleWindowSize(hConsoleOutput: THandle): TCoord;

function GetConsoleCursorInfo(hConsoleOutput: THandle;
  var lpConsoleCursorInfo: TConsoleCursorInfo): Bool;

function GetNumberOfConsoleMouseButtons(var lpNumberOfMouseButtons: DWord): Bool;

function SetConsoleMode(hConsoleHandle: THandle; dwMode: DWord): Bool;

function SetConsoleActiveScreenBuffer(hConsoleOutput: THandle): Bool;

function FlushConsoleInputBuffer(hConsoleInput: THandle): Bool;

function SetConsoleScreenBufferSize(hConsoleOutput: THandle; dwSize: TCoord): Bool;

function SetConsoleCursorPosition(hConsoleOutput: THandle; dwCursorPosition: TCoord): Bool;

function SetConsoleCursorInfo(hConsoleOutput: THandle;
  const lpConsoleCursorInfo: TConsoleCursorInfo): Bool;

function ScrollConsoleScreenBuffer(hConsoleOutput: THandle;
  const lpScrollRectangle: TSmallRect; lpClipRectangle: PSmallRect;
  dwDestinationOrigin: TCoord; var lpFill: TCharInfo): Bool;

function SetConsoleWindowInfo(hConsoleOutput: THandle; bAbsolute: Bool;
  const lpConsoleWindow: TSmallRect): Bool;

function SetConsoleTextAttribute(hConsoleOutput: THandle; wAttributes: Word): Bool;

function SetConsoleCtrlHandler(HandlerRoutine: TFNHandlerRoutine; Add: Bool): Bool;

function GenerateConsoleCtrlEvent(dwCtrlEvent: DWord; dwProcessGroupId: DWord): Bool;

function AllocConsole: Bool;

function FreeConsole: Bool;

function GetConsoleTitle(lpConsoleTitle: PChar; nSize: DWord): DWord;

function SetConsoleTitle(lpConsoleTitle: PChar): Bool;

function ReadConsole(hConsoleInput: THandle; lpBuffer: Pointer;
  nNumberOfCharsToRead: DWord; var lpNumberOfCharsRead: DWord; lpReserved: Pointer): Bool;

function WriteConsole(hConsoleOutput: THandle; const lpBuffer: Pointer;
  nNumberOfCharsToWrite: DWord; var lpNumberOfCharsWritten: DWord; lpReserved: Pointer): Bool;

const
  Console_Textmode_Buffer = 1;

function CreateConsoleScreenBuffer(dwDesiredAccess, dwShareMode: DWord;
  lpSecurityAttributes: PSecurityAttributes; dwFlags: DWord; lpScreenBufferData: Pointer): THandle;
function GetConsoleCP: UInt;
function SetConsoleCP(wCodePageID: UInt): Bool;
function GetConsoleOutputCP: UInt;
function SetConsoleOutputCP(wCodePageID: UInt): Bool;


{ Translated from WINVER.H }

{ Version management functions, types, and definitions
  Include file for VER.DLL.  This library is designed to allow version
  stamping of Windows executable files and of special .VER files for
  DOS executable files. }

const
{ Symbols }

  VS_File_Info = RT_Version;
  VS_Version_Info = 1;
  VS_User_Defined = 100;

{ VS_Version.dwFileFlags }

  VS_FFI_Signature = $FEEF04BD;
  VS_FFI_StrucVersion = $10000;
  VS_FFI_FileFlagsMask = 63;

{ VS_Version.dwFileFlags }

  VS_FF_Debug = 1;
  VS_FF_Prerelease = 2;
  VS_FF_Patched = 4;
  VS_FF_PrivateBuild = 8;
  VS_FF_InfoInferred = $10;
  VS_FF_SpecialBuild = $20;

{ VS_Version.dwFileOS }

  VOS_Unknown = 0;
  VOS_Dos = $10000;
  VOS_OS216 = $20000;
  VOS_OS232 = $30000;
  VOS_NT = $40000;

  VOS__Base = 0;
  VOS__Windows16 = 1;
  VOS__PM16 = 2;
  VOS__PM32 = 3;
  VOS__Windows32 = 4;

  VOS_Dos_Windows16 = $10001;
  VOS_Dos_Windows32 = $10004;
  VOS_OS216_PM16 = $20002;
  VOS_OS232_PM32 = $30003;
  VOS_NT_Windows32 = $40004;

{ VS_Version.dwFileType }

  VFT_Unknown = 0;
  VFT_App = 1;
  VFT_DLL = 2;
  VFT_Drv = 3;
  VFT_Font = 4;
  VFT_VXD = 5;
  VFT_Static_Lib = 7;

{ VS_Version.dwFileSubtype for VFT_Windows_Drv }

  VFT2_Unknown = 0;
  VFT2_Drv_Printer = 1;
  VFT2_Drv_Keyboard = 2;
  VFT2_Drv_Language = 3;
  VFT2_Drv_Display = 4;
  VFT2_Drv_Mouse = 5;
  VFT2_Drv_Network = 6;
  VFT2_Drv_System = 7;
  VFT2_Drv_Installable = 8;
  VFT2_Drv_Sound = 9;
  VFT2_Drv_Comm = 10;

{ VS_VERSION.dwFileSubtype for VFT_WINDOWS_FONT }

  VFT2_Font_Raster = 1;
  VFT2_Font_Vector = 2;
  VFT2_Font_Truetype = 3;

{ VerFindFile() flags }

  VFFF_IsSharedFile = 1;

  VFF_CurNeDest = 1;
  VFF_FileInUse = 2;
  VFF_BuffTooSmall = 4;

{ VerInstallFile() flags }

  VIFF_ForceInstall = 1;
  VIFF_DontDeleteOld = 2;

  VIF_TempFile = 1;
  VIF_Mismatch = 2;
  VIF_SrcOld = 4;

  VIF_DiffLang = 8;
  VIF_DiffCodepg = $10;
  VIF_DiffType = $20;

  VIF_WriteProt = $40;
  VIF_FileInUse = $80;
  VIF_OutOfSpace = $100;
  VIF_AccessViolation = $200;
  VIF_SharingViolation = $400;
  VIF_CannotCreate = $800;
  VIF_CannotDelete = $1000;
  VIF_CannotRename = $2000;
  VIF_CannotDeleteCur = $4000;
  VIF_OutOfMemory = $8000;

  VIF_CannotReadSrc = $10000;
  VIF_CannotReadDst = $20000;

  VIF_BuffTooSmall = $40000;

type
  PVSFixedFileInfo = ^TVSFixedFileInfo;
  TVSFixedFileInfo = packed record
    dwSignature: DWord;        { e.g. $feef04bd }
    dwStrucVersion: DWord;     { e.g. $00000042 = "0.42" }
    dwFileVersionMS: DWord;    { e.g. $00030075 = "3.75" }
    dwFileVersionLS: DWord;    { e.g. $00000031 = "0.31" }
    dwProductVersionMS: DWord; { e.g. $00030010 = "3.10" }
    dwProductVersionLS: DWord; { e.g. $00000031 = "0.31" }
    dwFileFlagsMask: DWord;    { = $3F for version "0.42" }
    dwFileFlags: DWord;        { e.g. VFF_Debug | VFF_Prerelease }
    dwFileOS: DWord;           { e.g. VOS_Dos_Windows16 }
    dwFileType: DWord;         { e.g. VFT_Driver }
    dwFileSubtype: DWord;      { e.g. VFT2_Drv_Keyboard }
    dwFileDateMS: DWord;       { e.g. 0 }
    dwFileDateLS: DWord;       { e.g. 0 }
  end;

function VerFindFile(uFlags: DWord; szFileName, szWinDir, szAppDir, szCurDir: PChar;
  var lpuCurDirLen: UInt; szDestDir: PChar; var lpuDestDirLen: UInt): DWord;
function VerInstallFile(uFlags: DWord;
  szSrcFileName, szDestFileName, szSrcDir, szDestDir, szCurDir, szTmpFile: PChar;
  var lpuTmpFileLen: UInt): DWord;

function GetFileVersionInfoSize(lptstrFilename: PChar; var lpdwHandle: DWord): DWord;
function GetFileVersionInfo(lptstrFilename: PChar; dwHandle, dwLen: DWord;
  lpData: Pointer): Bool;
function VerLanguageName(wLang: DWord; szLang: PChar; nSize: DWord): DWord;
function VerQueryValue(pBlock: Pointer; lpSubBlock: PChar;
  var lplpBuffer: Pointer; var puLen: UInt): Bool;

{ Translated from WINREG.H }

{ This module contains the function prototypes and constant, type and
   structure definitions for the Windows 32-Bit Registry API. }

const
{ Reserved Key Handles. }

  HKey_Classes_Root     = $80000000;
  HKey_Current_User     = $80000001;
  HKey_Local_Machine    = $80000002;
  HKey_Users            = $80000003;
  HKey_Performance_Data = $80000004;
  HKey_Current_Config   = $80000005;
  HKey_Dyn_Data         = $80000006;


  Provider_Keeps_Value_Length = 1;

type
  PValContext = ^TValContext;
  TValContext = packed record
    valuelen: Integer;       { the total length of this value }
    value_context: Pointer;  { provider's context }
    val_buff_ptr: Pointer;   { where in the ouput buffer the value is }
  end;


type
{ Provider supplied value/context.}
  PPValue = ^TPValue;
  TPValue = packed record
    pv_valuename: PChar;           { The value name pointer }
    pv_valuelen: Bool;
    pv_value_context: Pointer;
    pv_type: DWord;
  end;

  TFNQueryHandler = TFarProc;
  PFNQueryHandler = ^TFNQueryHandler;

  PProviderInfo = ^TProviderInfo;
  TProviderInfo = packed record
    pi_R0_1val: PFNQueryHandler;
    pi_R0_allvals: PFNQueryHandler;
    pi_R3_1val: PFNQueryHandler;
    pi_R3_allvals: PFNQueryHandler;
    pi_flags: DWord;              { capability flags (none defined yet). }
    pi_key_context: Pointer;
  end;
  TRegProvider = TProviderInfo;
  PProvider = PProviderInfo;

  PValueEnt = ^TValueEnt;
  TValueEnt = packed record
    ve_valuename: PChar;
    ve_valuelen: DWord;
    ve_valueptr: DWord;
    ve_type: DWord;
  end;
  TValEnt = TValueEnt;
  PValEnt = PValueEnt;


{ Default values for parameters that do not exist in the Win 3.1
  compatible APIs. }

function RegConnectRegistry(lpMachineName: PChar; hKey: HKEY;
  var phkResult: HKEY): Longint;
function RegFlushKey(hKey: HKEY): Longint;
function RegGetKeySecurity(hKey: HKEY; SecurityInformation: SECURITY_INFORMATION;
  pSecurityDescriptor: PSecurityDescriptor; var lpcbSecurityDescriptor: DWord): Longint;
function RegLoadKey(hKey: HKEY; lpSubKey, lpFile: PChar): Longint;
function RegNotifyChangeKeyValue(hKey: HKEY; bWatchSubtree: Bool;
  dwNotifyFilter: DWord; hEvent: THandle; fAsynchronus: Bool): Longint;
function RegQueryMultipleValues(hKey: HKEY; var ValList;
  NumVals: DWord; lpValueBuf: PChar; var ldwTotsize: DWord): Longint;
function RegReplaceKey(hKey: HKEY; lpSubKey: PChar;
   lpNewFile: PChar; lpOldFile: PChar): Longint;
function RegRestoreKey(hKey: HKEY; lpFile: PChar; dwFlags: DWord): Longint;
function RegSaveKey(hKey: HKEY; lpFile: PChar;
  lpSecurityAttributes: PSecurityAttributes): Longint;
function RegSetKeySecurity(hKey: HKEY; SecurityInformation: SECURITY_INFORMATION;
  pSecurityDescriptor: PSECURITY_DESCRIPTOR): Longint;
function RegUnLoadKey(hKey: HKEY; lpSubKey: PChar): Longint;

{ Remoteable System Shutdown APIs }

function InitiateSystemShutdown(lpMachineName, lpMessage: PChar;
  dwTimeout: DWord; bForceAppsClosed, bRebootAfterShutdown: Bool): Bool;
function AbortSystemShutdown(lpMachineName: PChar): Bool;

{ Translated from WINNETWK.H }

const
{ Network types }

  WNNC_Net_MsNet              = $00010000;
  WNNC_Net_LanMan             = $00020000;
  WNNC_Net_Netware            = $00030000;
  WNNC_Net_Vines              = $00040000;
  WNNC_Net_10Net              = $00050000;
  WNNC_Net_Locus              = $00060000;
  WNNC_Net_Sun_PC_NFS         = $00070000;
  WNNC_Net_LanStep            = $00080000;
  WNNC_Net_9Tiles             = $00090000;
  WNNC_Net_Lantastic          = $000A0000;
  WNNC_Net_AS400              = $000B0000;
  WNNC_Net_FTP_NFS            = $000C0000;
  WNNC_Net_Pathworks          = $000D0000;
  WNNC_Net_LifeNet            = $000E0000;
  WNNC_Net_PowerLan           = $000F0000;
  WNNC_Net_BWNFS              = $00100000;
  WNNC_Net_Cogent             = $00110000;
  WNNC_Net_Farallon           = $00120000;
  WNNC_Net_AppleTalk          = $00130000;
  WNNC_Net_InterGraph         = $00140000;
  WNNC_Net_SymfoNet           = $00150000;
  WNNC_Net_ClearCase          = $00160000;

{ Network Resources. }

  Resource_Connected = 1;
  Resource_GlobalNet = 2;
  Resource_Remembered = 3;
  Resource_Recent = 4;
  Resource_Context = 5;

  ResourceType_Any = 0;
  ResourceType_Disk = 1;
  ResourceType_Print = 2;
  ResourceType_Reserved = 8;
  ResourceType_Unknown = $FFFFFFFF;

  ResourceUsage_Connectable = 1;
  ResourceUsage_Container = 2;
  ResourceUsage_NoLocalDevice = 4;
  ResourceUsage_Sibling = 8;

  ResourceUsage_Attached = $00000010;
  ResourceUsage_All = (ResourceUsage_Connectable or ResourceUsage_Container or ResourceUsage_Attached);
  ResourceUsage_Reserved = $80000000;

  ResourceDisplayType_Generic            = $00000000;
  ResourceDisplayType_Domain             = $00000001;
  ResourceDisplayType_Server             = $00000002;
  ResourceDisplayType_Share              = $00000003;
  ResourceDisplayType_File               = $00000004;
  ResourceDisplayType_Group              = $00000005;
  ResourceDisplayType_Network            = $00000006;
  ResourceDisplayType_Root               = $00000007;
  ResourceDisplayType_ShareAdmin         = $00000008;
  ResourceDisplayType_Directory          = $00000009;
  ResourceDisplayType_Tree               = $0000000A;
  ResourceDisplayType_NDSContainer       = $0000000B;

type
  PNetResource = ^TNetResource;
  TNetResource = packed record
    dwScope: DWord;
    dwType: DWord;
    dwDisplayType: DWord;
    dwUsage: DWord;
    lpLocalName: PChar;
    lpRemoteName: PChar;
    lpComment: PChar;
    lpProvider: PChar;
  end;

const
{ Network Connections. }

  NetProperty_Persistent = 1;

  Connect_Update_Profile          = $00000001;
  Connect_Update_Recent           = $00000002;
  Connect_Temporary               = $00000004;
  Connect_Interactive             = $00000008;
  Connect_Prompt                  = $00000010;
  Connect_Need_Drive              = $00000020;
  Connect_RefCount                = $00000040;
  Connect_Redirect                = $00000080;
  Connect_LocalDrive              = $00000100;
  Connect_Current_Media           = $00000200;
  Connect_Deferred                = $00000400;
  Connect_Reserved                = $FF000000;

function WNetAddConnection(lpRemoteName, lpPassword, lpLocalName: PChar): DWord;
function WNetAddConnection2(var lpNetResource: TNetResource;
  lpPassword, lpUserName: PChar; dwFlags: DWord): DWord;
function WNetAddConnection3(hwndOwner: hWnd; var lpNetResource: TNetResource;
  lpPassword, lpUserName: PChar; dwFlags: DWord): DWord;
function WNetCancelConnection(lpName: PChar; fForce: Bool): DWord;
function WNetCancelConnection2(lpName: PChar; dwFlags: DWord; fForce: Bool): DWord;
function WNetGetConnection(lpLocalName: PChar;
  lpRemoteName: PChar; var lpnLength: DWord): DWord;
function WNetUseConnection(hwndOwner: hWnd;
  var lpNetResource: TNetResource; lpUserID: PChar;
  lpPassword: PChar; dwFlags: DWord; lpAccessName: PChar;
  var lpBufferSize: DWord; var lpResult: DWord): DWord;
function WNetSetConnection(lpName: PChar; dwProperties: DWord; pvValues: Pointer): DWord;

{ Network Connection Dialogs. }

function WNetConnectionDialog(hWnd: hWnd; dwType: DWord): DWord;
function WNetDisconnectDialog(hWnd: hWnd; dwType: DWord): DWord;

type
  PConnectDlgStruct = ^TConnectDlgStruct;
  TConnectDlgStruct = packed record
    cbStructure: DWord;          { size of this structure in bytes }
    hwndOwner: hWnd;             { owner window for the dialog }
    lpConnRes: PNetResource;     { Requested Resource info    }
    dwFlags: DWord;              { flags (see below) }
    dwDevNum: DWord;             { number of devices connected to }
  end;

const
  ConnDlg_RO_Path = 1;    { Resource path should be read-only     }
  ConnDlg_Conn_Point = 2; { Netware -style movable connection point enabled  }
  ConnDlg_use_MRU = 4;    { Use MRU combobox   }
  ConnDlg_Hide_Box = 8;   { Hide persistent connect checkbox   }

  { NOTE:  Set at most ONE of the below flags.  If neither flag is set,
           then the persistence is set to whatever the user chose during
           a previous connection }

  ConnDlg_Persist = $10;       { Force persistent connection  }
  ConnDlg_not_Persist = $20;   { Force connection NOT persistent  }

function WNetConnectionDialog1(var lpConnDlgStruct: TConnectDlgStruct): DWord;

type
  PDiscDlgStruct = ^TDiscDlgStruct;
  TDiscDlgStruct = packed record
    cbStructure: DWord;       { size of this structure in bytes }
    hwndOwner: hWnd;          { owner window for the dialog }
    lpLocalName: PChar;       { local device name }
    lpRemoteName: PChar;      { network resource name }
    dwFlags: DWord;
  end;

const
  Disc_Update_Profile = 1;
  Disc_no_Force = $40;

function WNetDisconnectDialog1(var lpConnDlgStruct: TDiscDlgStruct): DWord;

{ Network Browsing. }

function WNetOpenEnum(dwScope, dwType, dwUsage: DWord;
  lpNetResource: PNetResource; var lphEnum: THandle): DWord;
function WNetEnumResource(hEnum: THandle; var lpcCount: DWord;
  lpBuffer: Pointer; var lpBufferSize: DWord): DWord;
function WNetCloseEnum(hEnum: THandle): DWord;
function WNetGetResourceParent(lpNetResource: PNetResource;
  lpBuffer: Pointer; var cbBuffer: DWord): DWord;

const
{ Universal Naming. }

  Universal_Name_Info_Level = 1;
  Remote_Name_Info_Level = 2;

type
  PUniversalNameInfo = ^TUniversalNameInfo;
  TUniversalNameInfo = packed record
    lpUniversalName: PChar;
  end;

  PRemoteNameInfo = ^TRemoteNameInfo;
  TRemoteNameInfo = packed record
    lpUniversalName: PChar;
    lpConnectionName: PChar;
    lpRemainingPath: PChar;
  end;

function WNetGetUniversalName(lpLocalPath: PChar; dwInfoLevel: DWord;
  lpBuffer: Pointer; var lpBufferSize: DWord): DWord;

{ Authentication and Logon/Logoff }

function WNetGetUser(lpName: PChar; lpUserName: PChar; var lpnLength: DWord): DWord;

const
  WNFmt_MultiLine = 1;
  WNFmt_Abbreviated = 2;
  WNFmt_IneNum = $10;
  WNFmt_Connection = $20;

function WNetGetProviderName(dwNetType: DWord; lpProviderName: PChar;
  var lpBufferSize: DWord): DWord;

type
  PNetInfoStruct = ^TNetInfoStruct;
  TNetInfoStruct = record
    cbStructure: DWord;
    dwProviderVersion: DWord;
    dwStatus: DWord;
    dwCharacteristics: DWord;
    dwHandle: DWord;
    wNetType: Word;
    dwPrinters: DWord;
    dwDrives: DWord;
  end;

const
  NetInfo_DLL16 = 1;      { Provider running as 16 bit Winnet Driver  }
  NetInfo_DiskRed = 4;    { Provider requires disk redirections to connect  }
  NetInfo_PrinterRed = 8; { Provider requires printer redirections to connect  }

function WNetGetNetworkInformation(lpProvider: PChar;
  var lpNetInfoStruct: TNetInfoStruct): DWord;

type
{ User Profiles }
  TFNGetProfilePath = TFarProc;
  TFNReconcileProfile = TFarProc;


const
  RP_Logon = 1;    { if set, do for logon, else for logoff }
  RP_IniFile = 2;  { if set, reconcile .INI file, else reg. hive }

type
{ Policies }

  TFNProcessPolicies = TFarProc;

const
  PP_DisplayErrors = 1;  { if set, display error messages, else fail silently if error }

{ Error handling }

function WNetGetLastError(var lpError: DWord; lpErrorBuf: PChar;
  nErrorBufSize: DWord; lpNameBuf: PChar; nNameBufSize: DWord): DWord;


const
{ STATUS CODES }
{ General }

  WN_Success = No_Error;
  WN_No_Error = No_Error;
  WN_not_Supported = Error_not_Supported;
  WN_Cancel = Error_Cancelled;
  WN_Retry = Error_Retry;
  WN_Net_Error = Error_Unexp_Net_Err;
  WN_MORE_DATA = Error_More_Data;
  WN_bad_Pointer = Error_Invalid_Address;
  WN_bad_Value = Error_Invalid_Parameter;
  WN_bad_User = Error_Bad_Username;
  WN_bad_Password = Error_Invalid_Password;
  WN_Access_Denied = Error_Access_Denied;
  WN_Function_Busy = Error_Busy;
  WN_Windows_Error = Error_Unexp_Net_Err;
  WN_out_of_Memory = Error_not_Enough_Memory;
  WN_no_Network = Error_no_Network;
  WN_Extended_Error = Error_Extended_Error;
  WN_bad_Level = Error_Invalid_Level;
  WN_bad_Handle = Error_Invalid_Handle;
  WN_not_Initializing = Error_Already_Initialized;
  WN_no_More_Devices = Error_no_More_Devices;

{ Connection }

  WN_not_Connected = Error_Not_Connected;
  WN_Open_Files = Error_Open_Files;
  WN_Device_in_Use = Error_Device_in_Use;
  WN_bad_NetName = Error_Bad_Net_Name;
  WN_bad_LocalName = Error_bad_Device;
  WN_Already_Connected = Error_Already_Assigned;
  WN_Device_Error = Error_Gen_Failure;
  WN_Connection_Closed = Error_Connection_Unavail;
  WN_no_Net_or_bad_Path = Error_no_Net_or_bad_Path;
  WN_bad_Provider = Error_bad_Provider;
  WN_Cannot_Open_Profile = Error_Cannot_Open_Profile;
  WN_bad_Profile = Error_bad_Profile;
  WN_bad_Dev_Type = Error_bad_Dev_Type;
  WN_Device_Already_Remembered = Error_Device_Already_Remembered;

{ Enumeration }

  WN_no_more_Entries = Error_no_more_Items;
  WN_not_Container = Error_not_Container;

{ Authentication }

  WN_not_Authenticated = Error_not_Authenticated;
  WN_not_Logged_on = Error_not_Logged_on;
  WN_not_Validated = Error_no_Logon_Servers;

type
{ For Shell }
  PNetConnectInfoStruct = ^TNetConnectInfoStruct;
  TNetConnectInfoStruct = packed record
    cbStructure: DWord;
    dwFlags: DWord;
    dwSpeed: DWord;
    dwDelay: DWord;
    dwOptDataSize: DWord;
  end;

const
  WnCon_ForNetCard = 1;
  WnCon_NotRouted = 2;
  WnCon_SlowLink = 4;
  WnCon_Dynamic = 8;

function MultinetGetConnectionPerformance(lpNetResource: PNetResource;
  lpNetConnectInfoStruc: PNetConnectInfoStruct): DWord;

{ Translated from DDE.H }

const
  WM_DDE_First      = $03E0;
  WM_DDE_Initiate   = WM_DDE_First;
  WM_DDE_Terminate  = WM_DDE_First+1;
  WM_DDE_Advise     = WM_DDE_First+2;
  WM_DDE_Unadvise   = WM_DDE_First+3;
  WM_DDE_Ack        = WM_DDE_First+4;
  WM_DDE_Data       = WM_DDE_First+5;
  WM_DDE_Request    = WM_DDE_First+6;
  WM_DDE_Poke       = WM_DDE_First+7;
  WM_DDE_Execute    = WM_DDE_First+8;
  WM_DDE_Last       = WM_DDE_First+8;

{ Constants used for a WM_DDE_Ack message sent in responce to a WM_DDE_Data
  WM_DDE_Request, WM_DDE_Poke, WM_DDE_Advise, or WM_DDE_Unadvise message.
  For example
    if lParam and dde_Ack <> 0 then ...
}

type
  PDDEAck = ^TDDEAck;
  TDDEAck = packed record
(*
    unsigned bAppReturnCode:8,
             reserved:6,
             fBusy:1,
             fAck:1;
*)
    Flags: Word;
  end;

const
  dde_AppReturnCode = $00FF;
  dde_Busy          = $4000;
  dde_Ack           = $8000;

{ Record for the  WM_DDE_ADVISE Options parameter (LoWord(lParam)) }

type
  PDDEAdvise = ^TDDEAdvise;
  TDDEAdvise = packed record
(*
    unsigned reserved:14,
             fDeferUpd:1,
             fAckReq:1;
*)
    Flags: Word;
    cfFormat: SmallInt;
  end;

const
  dde_DeferUpd     = $4000;
  dde_AckReq       = $8000;

{ Record for the hData parameter of a WM_DDE_DATA message (LoWord(lParam)).
  The actual size of this record depends on the size of the Value
  array. }

type
  PDDEData = ^TDDEData;
  TDDEData = packed record
(*  unsigned unused:12,
             fResponse:1,
             fRelease:1,
             reserved:1,
             fAckReq:1;
*)
    Flags: Word;
    cfFormat: SmallInt;
    Value: array[0..0] of Byte;
  end;

const
  dde_Response = $1000;
  dde_Release  = $2000;

{ Record for the hData parameter of the WM_DDE_POKE record (LoWord(lParam)).
  The actual size of this record depends on the size of the Value array. }

type
  PDDEPoke = ^TDDEPoke;
  TDDEPoke = packed record
(*  unsigned unused:13,
             fRelease:1,
             fReserved:2;
*)
    Flags: Word;
    cfFormat: SmallInt;
    Value: array[0..0] of Byte;
  end;

{ DDE Security }

function DdeSetQualityOfService(hWndClient: hWnd; const pqosNew: TSecurityQualityOfService;
  pqosPrev: PSecurityQualityOfService): Bool;
function ImpersonateDdeClientWindow(hWndClient: hWnd; hWndServer: hWnd): Bool;

const
  advapi32  = 'advapi32.dll';
  kernel32  = 'kernel32.dll';
  mpr       = 'mpr.dll';
  version   = 'version.dll';
  comctl32  = 'comctl32.dll';
  gdi32     = 'gdi32.dll';
  opengl32  = 'opengl32.dll';
  user32    = 'user32.dll';
  wintrust  = 'wintrust.dll';

{$ENDIF Open32}

{---------------[ Inline functions ]-----------------------------------------}

function PointToPoints(X,Y: SmallWord): Longint; inline;
begin
  Result := X or Y shl 16;
end;

function MakeROP4(Fore,Back: DWord): DWord; inline;
begin
  Result := ((Back shl 8) and $FF000000) or Fore;
end;

{---------------[ DAPIE specific ]-------------------------------------------}
{$IFDEF Open32}
function WinCallWinMain(ParamCount: Integer; CmdLine: PChar; FnMain: TFNMain; CmdShow: Integer): Integer;

{ The following functions are used for translating data between the native }
{ Presentation Manager format and the Developer API Extensions equivalents. }

type
  TXlateDir = (WinX2PM, PM2WinX);

{ Use the GDI object type to specify the type of handle passing in }

function WinTranslateDevicePoints(DC: HDC; Wnd: hWnd; Point: PPoint; P4: Integer; P5: TXlateDir): Bool;
function WinTranslateDeviceRects(DC: HDC; Wnd: hWnd; Rect: PRect; P4: Integer; P5: TXlateDir): Bool;
function WinTranslateGraphicsObjectHandle(GDIObj: HGDIObj; P2: TXlateDir; P3: Integer): ULong;
function WinTranslateMnemonicString(Str: PChar; var DestStr: PChar; P3: Integer; P4: TXlateDir): ULong;
function WinQueryTranslateMode: DWord;
function WinSetTranslateMode(NewMode: DWord): Bool;
{$ENDIF Open32}

// In Delphi these are in messages.pas

const
  wm_Null             = $0000;
  wm_Create           = $0001;
  wm_Destroy          = $0002;
  wm_Move             = $0003;
  wm_Size             = $0005;
  wm_Activate         = $0006;
  wm_SetFocus         = $0007;
  wm_KillFocus        = $0008;
  wm_Enable           = $000A;
  wm_SetRedraw        = $000B;
  wm_SetText          = $000C;
  wm_GetText          = $000D;
  wm_GetTextLength    = $000E;
  wm_Paint            = $000F;
  wm_Close            = $0010;
  wm_QueryEndSession  = $0011;
  wm_Quit             = $0012;
  wm_QueryOpen        = $0013;
  wm_EraseBkgnd       = $0014;
  wm_SysColorChange   = $0015;
  wm_EndSession       = $0016;
  wm_SystemError      = $0017;
  wm_ShowWindow       = $0018;
  wm_CtlColor         = $0019;
  wm_WinIniChange     = $001A;
  wm_SettingChange = wm_WinIniChange;
  wm_DevModeChangE    = $001B;
  wm_ActivateApp      = $001C;
  wm_FontChange       = $001D;
  wm_TimeChange       = $001E;
  wm_CancelMode       = $001F;
  wm_SetCursor        = $0020;
  wm_MouseActivate    = $0021;
  wm_ChildActivate    = $0022;
  wm_QueueSync        = $0023;
  wm_GetMinMaxInfo    = $0024;
  wm_PaintIcon        = $0026;
  wm_IconEraseBkgnd   = $0027;
  wm_NextDlgCtl       = $0028;
  wm_SpoolerStatus    = $002A;
  wm_DrawItem         = $002B;
  wm_MeasureItem      = $002C;
  wm_DeleteItem       = $002D;
  wm_VKeyToItem       = $002E;
  wm_CharToItem       = $002F;
  wm_SetFont          = $0030;
  wm_GetFont          = $0031;
  wm_SetHotkey        = $0032;
  wm_GetHotkey        = $0033;
  wm_QueryDragIcon    = $0037;
  wm_CompareItem      = $0039;
  wm_Compacting       = $0041;

  wm_CommNotify       = $0044;    // obsolete in Win32

  wm_WindowPosChanging = $0046;
  wm_WindowPosChanged = $0047;
  wm_Power            = $0048;

  wm_CopyData         = $004A;
  wm_CancelJournal    = $004B;
  wm_Notify           = $004E;
  wm_InputLangChangeRequest = $0050;
  wm_InputLangChange  = $0051;
  wm_TCard            = $0052;
  wm_Help             = $0053;
  wm_UserChanged      = $0054;
  wm_NotifyFormat     = $0055;

  wm_ContextMenu      = $007B;
  wm_StyleChanging    = $007C;
  wm_StyleChanged     = $007D;
  wm_DisplayChange    = $007E;
  wm_GetIcon          = $007F;
  wm_SetIcon          = $0080;

  wm_NcCreate         = $0081;
  wm_NcDestroy        = $0082;
  wm_NcCalcSize       = $0083;
  wm_NcHitTest        = $0084;
  wm_NcPaint          = $0085;
  wm_NcActivate       = $0086;
  wm_GetDlgCode       = $0087;
  wm_NcMouseMove      = $00A0;
  wm_NcLButtonDown    = $00A1;
  wm_NcLButtonUp      = $00A2;
  wm_NcLButtonDblClk  = $00A3;
  wm_NcRButtonDown    = $00A4;
  wm_NcRButtonUp      = $00A5;
  wm_NcRButtonDblClk  = $00A6;
  wm_NcMButtonDown    = $00A7;
  wm_NcMButtonUp      = $00A8;
  wm_NcMButtonDblClk  = $00A9;

  wm_KeyFirst         = $0100;
  wm_KeyDown          = $0100;
  wm_KeyUp            = $0101;
  wm_Char             = $0102;
  wm_DeadChar         = $0103;
  wm_SysKeyDown       = $0104;
  wm_SysKeyUp         = $0105;
  wm_SysChar          = $0106;
  wm_SysDeadChar      = $0107;
  wm_KeyLast          = $0108;

  wm_InitDialog       = $0110;
  wm_Command          = $0111;
  wm_SysCommand       = $0112;
  wm_Timer            = $0113;
  wm_HScroll          = $0114;
  wm_VScroll          = $0115;
  wm_InitMenu         = $0116;
  wm_InitMenuPopup    = $0117;
  wm_MenuSelect       = $011F;
  wm_MenuChar         = $0120;
  wm_EnterIdle        = $0121;

  wm_CtlColorMsgbox   = $0132;
  wm_CtlColorEdit     = $0133;
  wm_CtlColorListbox  = $0134;
  wm_CtlColorBtn      = $0135;
  wm_CtlColorDlg      = $0136;
  wm_CtlColorScrollbar= $0137;
  wm_CtlColorStatic   = $0138;

  wm_MouseFirst       = $0200;
  wm_MouseMove        = $0200;
  wm_LButtonDown      = $0201;
  wm_LButtonUp        = $0202;
  wm_LButtonDblClk    = $0203;
  wm_RButtonDown      = $0204;
  wm_RButtonUp        = $0205;
  wm_RButtonDblClk    = $0206;
  wm_MButtonDown      = $0207;
  wm_MButtonUp        = $0208;
  wm_MButtonDblClk    = $0209;
  wm_MouseWheel       = $020A;
  wm_MouseLast        = $020A;

  wm_ParentNotify     = $0210;
  wm_EnterMenuLoop    = $0211;
  wm_ExitMenuLoop     = $0212;
  wm_NextMenu         = $0213;

  wm_Sizing           = 532;
  wm_CaptureChanged   = 533;
  wm_Moving           = 534;
  wm_PowerBroadcast   = 536;
  wm_DeviceChange     = 537;

  wm_IME_StartComposition        = $010D;
  wm_IME_EndComposition          = $010E;
  wm_IME_Composition             = $010F;
  wm_IME_KeyLast                 = $010F;

  wm_IME_SetContext              = $0281;
  wm_IME_Notify                  = $0282;
  wm_IME_Control                 = $0283;
  wm_IME_CompositionFull         = $0284;
  wm_IME_Select                  = $0285;
  wm_IME_Char                    = $0286;

  wm_IME_KeyDown                 = $0290;
  wm_IME_KeyUp                   = $0291;

  wm_MdiCreate        = $0220;
  wm_MdiDestroy       = $0221;
  wm_MdiActivate      = $0222;
  wm_MdiRestore       = $0223;
  wm_MdiNext          = $0224;
  wm_MdiMaximize      = $0225;
  wm_MdiTile          = $0226;
  wm_MdiCascade       = $0227;
  wm_MdiIconArrange   = $0228;
  wm_MdiGetActive     = $0229;
  wm_MdiSetMenu       = $0230;

  wm_EnterSizeMove    = $0231;
  wm_ExitSizeMove     = $0232;
  wm_DropFiles        = $0233;
  wm_MdiRefreshMenu   = $0234;

  wm_MouseHover       = $02A1;
  wm_MouseLeave       = $02A3;

  wm_Cut              = $0300;
  wm_Copy             = $0301;
  wm_Paste            = $0302;
  wm_Clear            = $0303;
  wm_Undo             = $0304;
  wm_RenderFormat     = $0305;
  wm_RenderAllFormats = $0306;
  wm_DestroyClipboard = $0307;
  wm_DrawClipboard    = $0308;
  wm_PaintClipboard   = $0309;
  wm_VScrollClipboard = $030A;
  wm_SizeClipboard    = $030B;
  wm_AskCbFormatName  = $030C;
  wm_ChangeCbChain    = $030D;
  wm_HScrollClipboard = $030E;
  wm_QueryNewPalette  = $030F;
  wm_PaletteIsChanging= $0310;
  wm_PaletteChanged   = $0311;
  wm_Hotkey           = $0312;

  wm_Print            = 791;
  wm_PrintClient      = 792;

  wm_HandHeldFirst    = 856;
  wm_HandHeldLast     = 863;

  wm_PenWinFirst      = $0380;
  wm_PenWinLast       = $038F;

  wm_Coalesce_First   = $0390;
  wm_Coalesce_Last    = $039F;

  wm_App = $8000;

// NOTE: All Message Numbers below $0400 are RESERVED

// Private Window Messages Start Here

  wm_User             = $0400; // but some are used! search for wm_User in this file

// Button Notification Codes

const
  bn_Pushed = bn_Hilite;
  bn_Unpushed = bn_Unhilite;
  bn_DblClk = bn_DoubleClicked;
  bn_SetFocus = 6;
  bn_KillFocus = 7;

// Button Control Messages
const
  bm_Click    = $00F5;
  bm_GetImage = $00F6;
  bm_SetImage = $00F7;

// Listbox messages

const
  lb_AddString            = $0180;
  lb_InsertString         = $0181;
  lb_DeleteString         = $0182;
  lb_SelItemRangeEx       = $0183;
  lb_ResetContent         = $0184;
  lb_SetSel               = $0185;
  lb_SetCurSel            = $0186;
  lb_GetSel               = $0187;
  lb_GetCurSel            = $0188;
  lb_GetText              = $0189;
  lb_GetTextLen           = $018A;
  lb_GetCount             = $018B;
  lb_SelectString         = $018C;
  lb_Dir                  = $018D;
  lb_GetTopIndex          = $018E;
  lb_FindString           = $018F;
  lb_GetSelCount          = $0190;
  lb_GetSelItems          = $0191;
  lb_SetTabStops          = $0192;
  lb_GetHorizontalExtent  = $0193;
  lb_SetHorizontalExtent  = $0194;
  lb_SetColumnWidth       = $0195;
  lb_AddFile              = $0196;
  lb_SetTopIndex          = $0197;
  lb_GetItemRect          = $0198;
  lb_GetItemData          = $0199;
  lb_SetItemData          = $019A;
  lb_SelItemRange         = $019B;
  lb_SetAnchorIndex       = $019C;
  lb_GetAnchorIndex       = $019D;
  lb_SetCaretIndex        = $019E;
  lb_GetCaretIndex        = $019F;
  lb_SetItemHeight        = $01A0;
  lb_GetItemHeight        = $01A1;
  lb_FindStringExact      = $01A2;
  lb_SetLocale            = $01A5;
  lb_GetLocale            = $01A6;
  lb_SetCount             = $01A7;
  lb_InitStorage          = $01A8;
  lb_ItemFromPoint        = $01A9;
  lb_MsgMax               = 432;

// Combo Box messages

  cb_GetEditSel            = $0140;
  cb_LimitText             = $0141;
  cb_SetEditSel            = $0142;
  cb_AddString             = $0143;
  cb_DeleteString          = $0144;
  cb_Dir                   = $0145;
  cb_GetCount              = $0146;
  cb_GetCurSel             = $0147;
  cb_GetLbText             = $0148;
  cb_GetLbTextLen          = $0149;
  cb_InsertString          = $014A;
  cb_ResetContent          = $014B;
  cb_FindString            = $014C;
  cb_SelectString          = $014D;
  cb_SetCurSel             = $014E;
  cb_ShowDropDown          = $014F;
  cb_GetItemData           = $0150;
  cb_SetItemData           = $0151;
  cb_GetDroppedControlRect = $0152;
  cb_SetItemHeight         = $0153;
  cb_GetItemHeight         = $0154;
  cb_SetExtendedUi         = $0155;
  cb_GetExtendedUi         = $0156;
  cb_GetDroppedState       = $0157;
  cb_FindStringExact       = $0158;
  cb_SetLocale             = 345;
  cb_GetLocale             = 346;
  cb_GetTopIndex           = 347;
  cb_SetTopIndex           = 348;
  cb_GetHorizontalExtent   = 349;
  cb_SetHorizontalExtent   = 350;
  cb_GetDroppedWidth       = 351;
  cb_SetDroppedWidth       = 352;
  cb_InitStorage           = 353;
  cb_MsgMax                = 354;

// Edit Control Messages

const
  em_GetSel              = $00B0;
  em_SetSel              = $00B1;
  em_GetRect             = $00B2;
  em_SetRect             = $00B3;
  em_SetRectNp           = $00B4;
  em_Scroll              = $00B5;
  em_LineScroll          = $00B6;
  em_ScrollCaret         = $00B7;
  em_GetModify           = $00B8;
  em_SetModify           = $00B9;
  em_GetLineCount        = $00BA;
  em_LineIndex           = $00BB;
  em_SetHandle           = $00BC;
  em_GetHandle           = $00BD;
  em_GetThumb            = $00BE;
  em_LineLength          = $00C1;
  em_ReplaceSel          = $00C2;
  em_GetLine             = $00C4;
  em_LimitText           = $00C5;
  em_CanUndo             = $00C6;
  em_Undo                = $00C7;
  em_FmtLines            = $00C8;
  em_LineFromChar        = $00C9;
  em_SetTabStops         = $00CB;
  em_SetPasswordChar     = $00CC;
  em_EmptyUndoBuffer     = $00CD;
  em_GetFirstVisibleLine = $00CE;
  em_SetReadOnly         = $00CF;
  em_SetWordBreakProc    = $00D0;
  em_GetWordBreakProc    = $00D1;
  em_GetPasswordChar     = $00D2;
  em_SetMargins          = 211;
  em_GetMargins          = 212;
  em_SetLimitText        = em_LimitText;    //win40 Name change
  em_GetLimitText        = 213;
  em_PosFromChar         = 214;
  em_CharFromPos         = 215;

// Scroll bar messages
const
  sbm_SetPos = 224;             // not in win3.1
  sbm_GetPos = 225;             // not in win3.1
  sbm_SetRange = 226;           // not in win3.1
  sbm_SetRangeRedraw = 230;     // not in win3.1
  sbm_GetRange = 227;           // not in win3.1
  sbm_Enable_Arrows = 228;      // not in win3.1
  sbm_SetScrollInfo = 233;
  sbm_GetScrollInfo = 234;

// Dialog messages }

  dm_GetDefId = (wm_User+0);    // That's what Microsoft means when talking about "standards"
  dm_SetDefId = (wm_User+1);
  dm_Reposition = (wm_User+2);

  psm_PageInfo = (wm_User+100);
  psm_SheetInfo = (wm_User+101);

type

// Generic window message record

  PMessage = ^TMessage;
  TMessage = record
    Msg: Longint;
    case Integer of
      0: (
        WParam: Longint;
        LParam: Longint;
        Result: Longint);
      1: (
        WParamLo: Word;
        WParamHi: Word;
        LParamLo: Word;
        LParamHi: Word;
        ResultLo: Word;
        ResultHi: Word);
  end;

// Common message format records

  TWMNoParams = record
    Msg: Longint;
    Unused: array[0..3] of Word;
    Result: Longint;
  end;

  TWMKey = record
    Msg: Longint;
    CharCode: Word;
    Unused: Word;
    KeyData: Longint;
    Result: Longint;
  end;

  TWMMouse = record
    Msg: Longint;
    Keys: Longint;
    case Integer of
      0: (
        XPos: Smallint;
        YPos: Smallint);
      1: (
        Pos: TSmallPoint;
        Result: Longint);
  end;

  TWMWindowPosMsg = record
    Msg: Longint;
    Unused: Integer;
    WindowPos: PWindowPos;
    Result: Longint;
  end;

  TWMScroll = record
    Msg: Longint;
    ScrollCode: Smallint; // sb_xxxx
    Pos: Smallint;
    ScrollBar: HWND;
    Result: Longint;
  end;

// Message records

  TWMActivate = record
    Msg: Longint;
    Active: Word; // wa_Inactive, wa_Active, wa_ClickActive
    Minimized: WordBool;
    ActiveWindow: HWND;
    Result: Longint;
  end;

  TWMActivateApp = record
    Msg: Longint;
    Active: Bool;
    ThreadId: Longint;
    Result: Longint;
  end;

  TWMAskCBFormatName = record
    Msg: Longint;
    NameLen: Word;
    Unused: Word;
    FormatName: PChar;
    Result: Longint;
  end;

  TWMCancelMode = TWMNoParams;

  TWMChangeCBChain = record
    Msg: Longint;
    Remove: HWND;
    Next: HWND;
    Result: Longint;
  end;

  TWMChar = TWMKey;

  TWMCharToItem = record
    Msg: Longint;
    Key: Word;
    CaretPos: Word;
    ListBox: HWND;
    Result: Longint;
  end;

  TWMChildActivate = TWMNoParams;

  TWMChooseFont_GetLogFont = record
    Msg: Longint;
    Unused: Longint;
    LogFont: PLogFont;
    Result: Longint;
  end;

  TWMClear = TWMNoParams;
  TWMClose = TWMNoParams;

  TWMCommand = record
    Msg: Longint;
    ItemID: Word;
    NotifyCode: Word;
    Ctl: HWND;
    Result: Longint;
  end;

  TWMCompacting = record
    Msg: Longint;
    CompactRatio: Longint;
    Unused: Longint;
    Result: Longint;
  end;

  TWMCompareItem = record
    Msg: Longint;
    Ctl: HWnd;
    CompareItemStruct: PCompareItemStruct;
    Result: Longint;
  end;

  TWMCreate = record
    Msg: Longint;
    Unused: Integer;
    CreateStruct: PCreateStruct;
    Result: Longint;
  end;

  TWMCtlColor = record
    Msg: Longint;
    ChildDC: HDC;
    ChildWnd: HWND;
    Result: Longint;
  end;

  TWMCtlColorBtn = TWMCtlColor;
  TWMCtlColorDlg = TWMCtlColor;
  TWMCtlColorEdit = TWMCtlColor;
  TWMCtlColorListbox = TWMCtlColor;
  TWMCtlColorMsgbox = TWMCtlColor;
  TWMCtlColorScrollbar = TWMCtlColor;
  TWMCtlColorStatic = TWMCtlColor;

  TWMCut = TWMNoParams;

  TWMDDE_Advise = record
    Msg: Longint;
    PostingApp: HWND;
    PackedVal: Longint;
    Result: Longint;
  end;

  TWMDDE_Data = record
    Msg: Longint;
    PostingApp: HWND;
    PackedVal: Longint;
    Result: Longint;
  end;

  TWMDDE_Execute = record
    Msg: Longint;
    PostingApp: HWND;
    Commands: THandle;
    Result: Longint;
  end;

  TWMDDE_Initiate = record
    Msg: Longint;
    PostingApp: HWND;
    App: Word;
    Topic: Word;
    Result: Longint;
  end;

  TWMDDE_Poke = record
    Msg: Longint;
    PostingApp: HWND;
    PackedVal: Longint;
    Result: Longint;
  end;

  TWMDDE_Request = record
    Msg: Longint;
    PostingApp: HWND;
    Format: Word;
    Item: Word;
    Result: Longint;
  end;

  TWMDDE_Terminate = record
    Msg: Longint;
    PostingApp: HWND;
    Unused: Longint;
    Result: Longint;
  end;

  TWMDDE_Unadvise = record
    Msg: Longint;
    PostingApp: HWND;
    Format: Word;
    Item: Word;
    Result: Longint;
  end;

  TWMDeadChar = TWMChar;

  TWMDeleteItem = record
    Msg: Longint;
    Ctl: HWND;
    DeleteItemStruct: PDeleteItemStruct;
    Result: Longint;
  end;

  TWMDestroy = TWMNoParams;
  TWMDestroyClipboard = TWMNoParams;

  TWMDevModeChange = record
    Msg: Longint;
    Unused: Integer;
    Device: PChar;
    Result: Longint;
  end;

  TWMDrawClipboard = TWMNoParams;

  TWMDrawItem = record
    Msg: Longint;
    Ctl: HWND;
    DrawItemStruct: PDrawItemStruct;
    Result: Longint;
  end;

  TWMDropFiles = record
    Msg: Longint;
    Drop: THANDLE;
    Unused: Longint;
    Result: Longint;
  end;

  TWMEnable = record
    Msg: Longint;
    Enabled: LongBool;
    Unused: Longint;
    Result: Longint;
  end;

  TWMEndSession = record
    Msg: Longint;
    EndSession: LongBool;
    Unused: Longint;
    Result: Longint;
  end;

  TWMEnterIdle = record
    Msg: Longint;
    Source: Longint; // Msgf_DialogBox, Msgf_Menu }
    IdleWnd: HWND;
    Result: Longint;
  end;

  TWMEnterMenuLoop = record
    Msg: Longint;
    IsTrackPopupMenu: LongBool;
    Unused: Longint;
    Result: Longint;
  end;

  TWMExitMenuLoop = TWMEnterMenuLoop;

  TWMEraseBkgnd = record
    Msg: Longint;
    DC: HDC;
    Unused: Longint;
    Result: Longint;
  end;

  TWMFontChange = TWMNoParams;
  TWMGetDlgCode = TWMNoParams;
  TWMGetFont = TWMNoParams;

  TWMGetIcon = record
    Msg: Longint;
    BigIcon: Longbool;
    Unused: Longint;
    Result: Longint;
  end;

  TWMGetHotKey = TWMNoParams;

  TWMGetMinMaxInfo = record
    Msg: Longint;
    Unused: Integer;
    MinMaxInfo: PMinMaxInfo;
    Result: Longint;
  end;

  TWMGetText = record
    Msg: Longint;
    TextMax: Integer;
    Text: PChar;
    Result: Longint;
  end;

  TWMGetTextLength = TWMNoParams;

  TWMHotKey = record
    Msg: Longint;
    HotKey: Longint;
    Unused: Longint;
    Result: Longint;
  end;

  TWMHScroll = TWMScroll;

  TWMHScrollClipboard = record
    Msg: Longint;
    Viewer: HWND;
    ScrollCode: Word; {sb_Bottom, sb_EndScroll, sb_LineDown, sb_LineUp,
                       sb_PageDown, SB_PageUp, sb_ThumbPosition,
                       sb_ThumbTrack, sb_Top }
    Pos: Word;
    Result: Longint;
  end;

  TWMIconEraseBkgnd = TWMEraseBkgnd;

  TWMInitDialog = record
    Msg: Longint;
    Focus: HWND;
    InitParam: Longint;
    Result: Longint;
  end;

  TWMInitMenu = record
    Msg: Longint;
    Menu: HMENU;
    Unused: Longint;
    Result: Longint;
  end;

  TWMInitMenuPopup = record
    Msg: Longint;
    MenuPopup: HMENU;
    Pos: Smallint;
    SystemMenu: WordBool;
    Result: Longint;
  end;

  TWMKeyDown = TWMKey;
  TWMKeyUp = TWMKey;

  TWMKillFocus = record
    Msg: Longint;
    FocusedWnd: HWND;
    Unused: Longint;
    Result: Longint;
  end;

  TWMLButtonDblClk = TWMMouse;
  TWMLButtonDown   = TWMMouse;
  TWMLButtonUp     = TWMMouse;
  TWMMButtonDblClk = TWMMouse;
  TWMMButtonDown   = TWMMouse;
  TWMMButtonUp     = TWMMouse;

  TWMMDIActivate = record
    Msg: Longint;
    case Integer of
      0: (
        ChildWnd: HWND);
      1: (
        DeactiveWnd: HWND;
        ActiveWnd: HWND;
        Result: Longint);
  end;

  TWMMDICascade = record
    Msg: Longint;
    Cascade: Longint; { 0, MdiTile_SkipDisabled }
    Unused: Longint;
    Result: Longint;
  end;

  TWMMDICreate = record
    Msg: Longint;
    Unused: Integer;
    MDICreateStruct: PMDICreateStruct;
    Result: Longint;
  end;

  TWMMDIDestroy = record
    Msg: Longint;
    Child: HWND;
    Unused: Longint;
    Result: Longint;
  end;

  TWMMDIGetActive = TWMNoParams;
  TWMMDIIconArrange = TWMNoParams;

  TWMMDIMaximize = record
    Msg: Longint;
    Maximize: HWND;
    Unused: Longint;
    Result: Longint;
  end;

  TWMMDINext = record
    Msg: Longint;
    Child: HWND;
    Next: Longint;
    Result: Longint;
  end;

  TWMMDIRefreshMenu = TWMNoParams;

  TWMMDIRestore = record
    Msg: Longint;
    IDChild: HWND;
    Unused: Longint;
    Result: Longint;
  end;

  TWMMDISetMenu = record
    Msg: Longint;
    MenuFrame: HMENU;
    MenuWindow: HMENU;
    Result: Longint;
  end;

  TWMMDITile = record
    Msg: Longint;
    Tile: Longint; { MdiTile_Horizontal, MdiTile_SkipDisable,
                     MdiTile_Vertical }
    Unused: Longint;
    Result: Longint;
  end;

  TWMMeasureItem = record
    Msg: Longint;
    IDCtl: HWnd;
    MeasureItemStruct: PMeasureItemStruct;
    Result: Longint;
  end;

  TWMMenuChar = record
    Msg: Longint;
    User: Char;
    Unused: Byte;
    MenuFlag: Word; { mf_Popup, mf_SysMenu }
    Menu: HMENU;
    Result: Longint;
  end;

  TWMMenuSelect = record
    Msg: Longint;
    IDItem: Word;
    MenuFlag: Word; { mf_Bitmap, mf_Checked, mf_Disabled, mf_Grayed,
                      mf_MouseSelect, mf_OwnerDraw, mf_Popup, mf_Separator,
                      mf_SysMenu }
    Menu: HMENU;
    Result: Longint;
  end;

  TWMMouseActivate = record
    Msg: Longint;
    TopLevel: HWND;
    HitTestCode: Word;
    MouseMsg: Word;
    Result: Longint;
  end;

  TWMMouseMove = TWMMouse;

  TWMMove = record
    Msg: Longint;
    Unused: Integer;
    case Integer of
      0: (
        XPos: Smallint;
        YPos: Smallint);
      1: (
        Pos: TSmallPoint;
        Result: Longint);
  end;

  TWMNCActivate = record
    Msg: Longint;
    Active: Bool;
    Unused: Longint;
    Result: Longint;
  end;

  TWMNCCreate = record
    Msg: Longint;
    Unused: Integer;
    CreateStruct: PCreateStruct;
    Result: Longint;
  end;

  TWMNCDestroy = TWMNoParams;

  TWMNCHitTest = record
    Msg: Longint;
    Unused: Longint;
    case Integer of
      0: (
        XPos: Smallint;
        YPos: Smallint);
      1: (
        Pos: TSmallPoint;
        Result: Longint);
  end;

  TWMNCHitMessage = record
    Msg: Longint;
    HitTest: Longint;
    XCursor: Smallint;
    YCursor: Smallint;
    Result: Longint;
  end;

  TWMNCLButtonDblClk = TWMNCHitMessage;
  TWMNCLButtonDown   = TWMNCHitMessage;
  TWMNCLButtonUp     = TWMNCHitMessage;
  TWMNCMButtonDblClk = TWMNCHitMessage;
  TWMNCMButtonDown   = TWMNCHitMessage;
  TWMNCMButtonUp     = TWMNCHitMessage;
  TWMNCMouseMove     = TWMNCHitMessage;

  TWMNCPaint = TWMNoParams;

  TWMNCRButtonDblClk = TWMNCHitMessage;
  TWMNCRButtonDown   = TWMNCHitMessage;
  TWMNCRButtonUp     = TWMNCHitMessage;

  TWMNextDlgCtl = record
    Msg: Longint;
    CtlFocus: Longint;
    Handle: WordBool;
    Unused: Word;
    Result: Longint;
  end;

  TWMNotify = record
    Msg: Cardinal;
    IDCtrl: Longint;
    NMHdr: PNMHdr;
    Result: Longint;
  end;

  TWMNotifyFormat = record
    Msg: Longint;
    From: HWND;
    Command: Longint;
    Result: Longint;
  end;

  TWMPaint = record
    Msg: Longint;
    DC: HDC;
    Unused: Longint;
    Result: Longint;
  end;

  TWMPaintClipboard = record
    Msg: Longint;
    Viewer: HWND;
    PaintStruct: THandle;
    Result: Longint;
  end;

  TWMPaintIcon = TWMNoParams;

  TWMPaletteChanged = record
    Msg: Longint;
    PalChg: HWND;
    Unused: Longint;
    Result: Longint;
  end;

  TWMPaletteIsChanging = record
    Msg: Longint;
    Realize: HWND;
    Unused: Longint;
    Result: Longint;
  end;

  TWMParentNotify = record
    Msg: Longint;
    case Event: Word of
      wm_Create, wm_Destroy: (
        ChildID: Word;
        ChildWnd: HWnd);
      wm_LButtonDown, wm_MButtonDown, wm_RButtonDown: (
        Value: Word;
        XPos: Smallint;
        YPos: Smallint);
      0: (
        Value1: Word;
        Value2: Longint;
        Result: Longint);
  end;

  TWMPaste = TWMNoParams;

  TWMPower = record
    Msg: Longint;
    PowerEvt: Longint; { pwr_SuspendRequest, pwr_SuspendResume,
                         pwr_CriticalResume }
    Unused: Longint;
    Result: Longint;
  end;

  TWMQueryDragIcon = TWMNoParams;

  TWMQueryEndSession = record
    Msg: Longint;
    Source: Longint;
    Unused: Longint;
    Result: Longint;
  end;

  TWMQueryNewPalette = TWMNoParams;
  TWMQueryOpen = TWMNoParams;
  TWMQueueSync = TWMNoParams;

  TWMQuit = record
    Msg: Longint;
    ExitCode: Longint;
    Unused: Longint;
    Result: Longint;
  end;

  TWMRButtonDblClk = TWMMouse;
  TWMRButtonDown = TWMMouse;
  TWMRButtonUp = TWMMouse;

  TWMRenderAllFormats = TWMNoParams;

  TWMRenderFormat = record
    Msg: Longint;
    Format: Longint;
    Unused: Longint;
    Result: Longint;
  end;

  TWMSetCursor = record
    Msg: Longint;
    CursorWnd: HWND;
    HitTest: Word;
    MouseMsg: Word;
    Result: Longint;
  end;

  TWMSetFocus = record
    Msg: Longint;
    FocusedWnd: HWND;
    Unused: Longint;
    Result: Longint;
  end;

  TWMSetFont = record
    Msg: Longint;
    Font: HFONT;
    Redraw: WordBool;
    Unused: Word;
    Result: Longint;
  end;

  TWMSetHotKey = record
    Msg: Longint;
    Key: Longint;
    Unused: Longint;
    Result: Longint;
  end;

  TWMSetIcon = record
    Msg: Longint;
    BigIcon: Longbool;
    Icon: HICON;
    Result: Longint;
  end;

  TWMSetRedraw = record
    Msg: Longint;
    Redraw: Longint;
    Unused: Longint;
    Result: Longint;
  end;

  TWMSetText = record
    Msg: Longint;
    Unused: Longint;
    Text: PChar;
    Result: Longint;
  end;

  TWMShowWindow = record
    Msg: Longint;
    Show: Bool;
    Status: Longint;
    Result: Longint;
  end;

  TWMSize = record
    Msg: Longint;
    SizeType: Longint; { Size_Maximized, Size_Minimized, Size_Restored,
                         Size_MaxHide, Size_MaxShow }
    Width: Word;
    Height: Word;
    Result: Longint;
  end;

  TWMSizeClipboard = record
    Msg: Longint;
    Viewer: HWND;
    RC: THandle;
    Result: Longint;
  end;

  TWMSpoolerStatus = record
    Msg: Longint;
    JobStatus: Longint;
    JobsLeft: Word;
    Unused: Word;
    Result: Longint;
  end;

  TWMSysChar = TWMKey;
  TWMSysColorChange = TWMNoParams;

  TWMSysCommand = record
    Msg: Longint;
    case CmdType: Longint of
      sc_Hotkey: (
        ActivateWnd: HWND);
      sc_KeyMenu: (
        Key: Word);
      sc_Close, sc_HScroll, sc_Maximize, sc_Minimize, sc_MouseMenu, sc_Move,
      sc_NextWindow, sc_PrevWindow, sc_Restore, sc_ScreenSave, sc_Size,
      sc_TaskList, sc_VScroll: (
        XPos: Smallint;
        YPos: Smallint;
        Result: Longint);
  end;

  TWMSysDeadChar = record
    Msg: Longint;
    CharCode: Word;
    Unused: Word;
    KeyData: Longint;
    Result: Longint;
  end;

  TWMSysKeyDown = TWMKey;
  TWMSysKeyUp = TWMKey;

  TWMSystemError = record
    Msg: Longint;
    ErrSpec: Word;
    Unused: Longint;
    Result: Longint;
  end;

  TWMTimeChange = TWMNoParams;

  TWMTimer = record
    Msg: Longint;
    TimerID: Longint;
    TimerProc: TFarProc;
    Result: Longint;
  end;

  TWMUndo = TWMNoParams;

  TWMVKeyToItem = TWMCharToItem;

  TWMVScroll = TWMScroll;

  TWMVScrollClipboard = record
    Msg: Longint;
    Viewer: HWND;
    ScollCode: Word;
    ThumbPos: Word;
    Result: Longint;
  end;

  TWMWindowPosChanged = TWMWindowPosMsg;
  TWMWindowPosChanging = TWMWindowPosMsg;

  TWMWinIniChange = record
    Msg: Longint;
    Unused: Integer;
    Section: PChar;
    Result: Longint;
  end;

  TWMDisplayChange = record
    Msg: Longint;
    BitsPerPixel: Integer;
    Width: Word;
    Height: Word;
  end;

{$IFNDEF Open32}

  TWMCopy = TWMNoParams;

  TWMCopyData = record
    Msg: Longint;
    From: HWND;
    CopyDataStruct: PCopyDataStruct;
    Result: Longint;
  end;

  TWMDDE_Ack = record
    Msg: Longint;
    PostingApp: HWND;
    case Word of
      wm_DDE_Initiate: (
        App: Word;
        Topic: Word;
        Result: Longint);
      wm_DDE_Execute {and all others}: (
        PackedVal: Longint);
  end;

  TWMNCCalcSize = record
    Msg: Longint;
    CalcValidRects: Bool;
    CalcSize_Params: PNCCalcSizeParams;
    Result: Longint;
  end;

  TWMStyleChange = record
    Msg: Longint;
    StyleType: Longint;
    StyleStruct: PStyleStruct;
    Result: Longint;
  end;

  TWMStyleChanged = TWMStyleChange;
  TWMStyleChanging = TWMStyleChange;

  TWMHelp = record
    Msg: Longint;
    Unused: Integer;
    HelpInfo: PHelpInfo;
    Result: Longint;
  end;

{$ENDIF}

implementation

function AbortDoc;                         external;
function AbortPath;                        external;
function AddAtom;                          external;
function AddFontResource;                  external;
function AdjustWindowRect;                 external;
function AdjustWindowRectEx;               external;
function AngleArc;                         external;
function AnimatePalette;                   external;
function AnsiLower;                        external;
function AnsiLowerBuff;                    external;
function AnsiNext;                         external;
function AnsiPrev;                         external;
function AnsiToOem;                        external;
function AnsiToOemBuff;                    external;
function AnsiUpper;                        external;
function AnsiUpperBuff;                    external;
function AppendMenu;                       external;
function Arc;                              external;
function ArcTo;                            external;
function ArrangeIconicWindows;             external;
function Beep;                             external;
function BeginDeferWindowPos;              external;
function BeginPaint;                       external;
function BeginPath;                        external;
function BitBlt;                           external;
function BringWindowToTop;                 external;
function CallMsgFilter;                    external;
function CallNextHookEx;                   external;
function CallWindowProc;                   external;
function ChangeClipboardChain;             external;
function CharLower;                        external;
function CharLowerBuff;                    external;
function CharNext;                         external;
function CharPrev;                         external;
function CharToOem;                        external;
function CharToOemBuff;                    external;
function CharUpper;                        external;
function CharUpperBuff;                    external;
function CheckDlgButton;                   external;
function CheckMenuItem;                    external;
function CheckRadioButton;                 external;
function ChildWindowFromPoint;             external;
function Chord;                            external;
function ClientToScreen;                   external;
function ClipCursor;                       external;
function CloseClipboard;                   external;
function CloseEnhMetaFile;                 external;
function CloseFigure;                      external;
function CloseHandle;                      external;
function ClosePrinter; external;
function CloseMetaFile;                    external;
function CloseWindow;                      external;
function CombineRgn;                       external;
function CompareFileTime;                  external;
function CopyCursor;                       external;
function CopyEnhMetaFile;                  external;
function CopyFile;                         external;
function CopyIcon;                         external;
function CopyMetaFile;                     external;
function CopyRect;                         external;
function CountClipboardFormats;            external;
function CreateAcceleratorTable;           external;
function CreateBitmap;                     external;
function CreateBitmapIndirect;             external;
function CreateBrushIndirect;              external;
function CreateCaret;                      external;
function CreateCompatibleBitmap;           external;
function CreateCompatibleDC;               external;
function CreateCursor;                     external;
function CreateDC;                         external;
function CreateDialogIndirectParam;        external;
function CreateDialogParam;                external;
function CreateDIBitmap;                   external;
function CreateDIBPatternBrushPt;          external;
function CreateDirectory;                  external;
function CreateEllipticRgn;                external;
function CreateEllipticRgnIndirect;        external;
function CreateEnhMetaFile;                external;
function CreateEvent;                      external;
function CreateFile;                       external;
function CreateFont;                       external;
function CreateFontIndirect;               external;
function CreateHalftonePalette;            external;
function CreateHatchBrush;                 external;
function CreateIC;                         external;
function CreateIcon;                       external;
function CreateIconFromResource;           external;
function CreateIconIndirect;               external;
function CreateMDIWindow;                  external;
function CreateMenu;                       external;
function CreateMetaFile;                   external;
function CreateMutex;                      external;
function CreatePalette;                    external;
function CreatePatternBrush;               external;
function CreatePen;                        external;
function CreatePenIndirect;                external;
function CreatePolygonRgn;                 external;
function CreatePolyPolygonRgn;             external;
function CreatePopupMenu;                  external;
function CreateProcess;                    external;
function CreateRectRgn;                    external;
function CreateRectRgnIndirect;            external;
function CreateRoundRectRgn;               external;
function CreateSemaphore;                  external;
function CreateSolidBrush;                 external;
function CreateThread;                     external;
function CreateWindowEx;                   external;
function DefDlgProc;                       external;
function DeferWindowPos;                   external;
function DefFrameProc;                     external;
function DefMDIChildProc;                  external;
function DefWindowProc;                    external;
function DeleteAtom;                       external;
procedure DeleteCriticalSection;           external;
function DeleteDC;                         external;
function DeleteEnhMetaFile;                external;
function DeleteFile;                       external;
function DeleteMenu;                       external;
function DeleteMetaFile;                   external;
function DeleteObject;                     external;
function DestroyAcceleratorTable;          external;
function DestroyCaret;                     external;
function DestroyCursor;                    external;
function DestroyIcon;                      external;
function DestroyMenu;                      external;
function DestroyWindow;                    external;
function DeviceCapabilities;               external;
function DialogBoxIndirectParam;           external;
function DialogBoxParam;                   external;
function DispatchMessage;                  external;
function DlgDirList;                       external;
function DlgDirListComboBox;               external;
function DlgDirSelectComboBoxEx;           external;
function DlgDirSelectEx;                   external;
function DllEntryPoint;                    external;
function DocumentProperties;               external;
function DosDateTimeToFileTime;            external;
function DPtoLP;                           external;
function DrawFocusRect;                    external;
function DrawIcon;                         external;
function DrawMenuBar;                      external;
function DrawText;                         external;
function DuplicateHandle;                  external;
function Ellipse;                          external;
function EmptyClipboard;                   external;
function EnableMenuItem;                   external;
function EnableScrollBar;                  external;
function EnableWindow;                     external;
function EndDeferWindowPos;                external;
function EndDialog;                        external;
function EndDoc;                           external;
function EndPage;                          external;
function EndPaint;                         external;
function EndPath;                          external;
procedure EnterCriticalSection;            external;
function EnumChildWindows;                 external;
function EnumClipboardFormats;             external;
function EnumEnhMetaFile;                  external;
function EnumFontFamilies;                 external;
function EnumFonts;                        external;
function EnumMetaFile;                     external;
function EnumObjects;                      external;
function EnumPrinters;                     external;
function EnumProps;                        external;
function EnumPropsEx;                      external;
function EnumThreadWindows;                external;
function EnumWindows;                      external;
function EqualRect;                        external;
function EqualRgn;                         external;
function Escape;                           external;
function ExcludeClipRect;                  external;
function ExcludeUpdateRgn;                 external;
procedure ExitProcess;                     external;
procedure ExitThread;                      external;
function ExitWindowsEx;                    external;
function ExtCreatePen;                     external;
function ExtCreateRegion;                  external;
function ExtFloodFill;                     external;
function ExtSelectClipRgn;                 external;
function ExtTextOut;                       external;
procedure FatalAppExit;                    external;
procedure FatalExit;                       external;
function FileTimeToDosDateTime;            external;
function FileTimeToLocalFileTime;          external;
function FileTimeToSystemTime;             external;
function FillPath;                         external;
function FillRect;                         external;
function FillRgn;                          external;
function FindAtom;                         external;
function FindClose;                        external;
function FindFirstFile;                    external;
function FindNextFile;                     external;
function FindResource;                     external;
function FindWindow;                       external;
function FlashWindow;                      external;
function FlattenPath;                      external;
function FloodFill;                        external;
function FlushFileBuffers;                 external;
function FrameRect;                        external;
function FrameRgn;                         external;
function FreeDDElParam;                    external;
function FreeLibrary;                      external;
function GdiFlush;                         external;
function GetACP;                           external;
function GetActiveWindow;                  external;
function GetArcDirection;                  external;
function GetAspectRatioFilterEx;           external;
function GetAtomName;                      external;
function GetBitmapBits;                    external;
function GetBitmapDimensionEx;             external;
function GetBkColor;                       external;
function GetBkMode;                        external;
function GetBoundsRect;                    external;
function GetBrushOrgEx;                    external;
function GetCapture;                       external;
function GetCaretBlinkTime;                external;
function GetCaretPos;                      external;
function GetCharABCWidths;                 external;
function GetCharWidth;                     external;
function GetClassInfo;                     external;
function GetClassLong;                     external;
function GetClassName;                     external;
function GetClassWord;                     external;
function GetClientRect;                    external;
function GetClipboardData;                 external;
function GetClipboardFormatName;           external;
function GetClipboardOwner;                external;
function GetClipboardViewer;               external;
function GetClipBox;                       external;
function GetClipCursor;                    external;
function GetClipRgn;                       external;
function GetCommandLine;                   external;
function GetCommandLineW;                   external;
function GetCurrentDirectory;              external;
function GetCurrentObject;                 external;
function GetCurrentPositionEx;             external;
function GetCurrentProcess;                external;
function GetCurrentProcessId;              external;
function GetCurrentThread;                 external;
function GetCurrentThreadId;               external;
function GetCursor;                        external;
function GetCursorPos;                     external;
function GetDC;                            external;
function GetDCEx;                          external;
function GetDCOrgEx;                       external;
function GetDesktopWindow;                 external;
function GetDeviceCaps;                    external;
function GetDialogBaseUnits;               external;
function GetDIBits;                        external;
function GetDiskFreeSpace;                 external;
function GetDlgCtrlID;                     external;
function GetDlgItem;                       external;
function GetDlgItemInt;                    external;
function GetDlgItemText;                   external;
function GetDoubleClickTime;               external;
function GetDriveType;                     external;
function GetEnhMetaFile;                   external;
function GetEnhMetaFileBits;               external;
function GetEnhMetaFileHeader;             external;
function GetEnhMetaFilePaletteEntries;     external;
function GetEnvironmentStrings;            external;
function GetEnvironmentVariable;           external;
function GetExitCodeProcess;               external;
function GetExitCodeThread;                external;
function GetFileAttributes;                external;
function GetFileInformationByHandle;       external;
function GetFileSize;                      external;
function GetFileTime;                      external;
function GetFileType;                      external;
function GetFocus;                         external;
function GetForegroundWindow;              external;
function GetFullPathName;                  external;
function GetGraphicsMode;                  external;
function GetIconInfo;                      external;
function GetKerningPairs;                  external;
function GetKeyboardType;                  external;
function GetKeyNameText;                   external;
function GetKeyState;                      external;
function GetLastActivePopup;               external;
function GetLastError;                     external;
procedure GetLocalTime;                    external;
function GetLogicalDrives;                 external;
function GetLogicalDriveStrings;           external;
function GetMapMode;                       external;
function GetMenu;                          external;
function GetMenuCheckMarkDimensions;       external;
function GetMenuItemCount;                 external;
function GetMenuItemID;                    external;
function GetMenuState;                     external;
function GetMenuString;                    external;
function GetMessage;                       external;
function GetMessageExtraInfo;              external;
function GetMessagePos;                    external;
function GetMessageTime;                   external;
function GetMetaFile;                      external;
function GetMetaFileBitsEx;                external;
function GetMiterLimit;                    external;
function GetModuleFileName;                external;
function GetModuleHandle;                  external;
function GetNearestColor;                  external;
function GetNearestPaletteIndex;           external;
function GetNextDlgGroupItem;              external;
function GetNextDlgTabItem;                external;
function GetNextWindow;                    external;
function GetObject;                        external;
function GetObjectType;                    external;
function GetOEMCP;                         external;
function GetOpenClipboardWindow;           external;
function GetOutlineTextMetrics;            external;
function GetOverlappedResult;              external;
function GetPaletteEntries;                external;
function GetParent;                        external;
function GetPath;                          external;
function GetPixel;                         external;
function GetPolyFillMode;                  external;
function GetPriorityClass;                 external;
function GetPriorityClipboardFormat;       external;
function GetPrivateProfileInt;             external;
function GetPrivateProfileString;          external;
function GetProcAddress;                   external;
function GetProfileInt;                    external;
function GetProfileString;                 external;
function GetProp;                          external;
function GetQueueStatus;                   external;
function GetRasterizerCaps;                external;
function GetRegionData;                    external;
function GetRgnBox;                        external;
function GetROP2;                          external;
function GetScrollPos;                     external;
function GetScrollRange;                   external;
function GetStdHandle;                     external;
function GetStockObject;                   external;
function GetStretchBltMode;                external;
function GetSubMenu;                       external;
function GetSysColor;                      external;
function GetSystemDirectory;               external;
function GetSystemMenu;                    external;
function GetSystemMetrics;                 external;
function GetSystemPaletteEntries;          external;
function GetTabbedTextExtent;              external;
procedure GetSystemTime;                   external;
function GetTempFileName;                  external;
function GetTempPath;                      external;
function GetTextAlign;                     external;
function GetTextCharacterExtra;            external;
function GetTextColor;                     external;
function GetTextExtentPoint32;             external;
function GetTextExtentPoint;               external;
function GetTextFace;                      external;
function GetTextMetrics;                   external;
function GetThreadPriority;                external;
function GetTickCount;                     external;
function GetTimeZoneInformation;           external;
function GetTopWindow;                     external;
function GetUpdateRect;                    external;
function GetUpdateRgn;                     external;
function GetViewportExtEx;                 external;
function GetViewportOrgEx;                 external;
function GetVolumeInformation;             external;
function GetWindow;                        external;
function GetWindowDC;                      external;
function GetWindowExtEx;                   external;
function GetWindowLong;                    external;
function GetWindowOrgEx;                   external;
function GetWindowPlacement;               external;
function GetWindowRect;                    external;
function GetWindowsDirectory;              external;
function GetWindowText;                    external;
function GetWindowTextLength;              external;
function GetWindowThreadProcessId;         external;
function GetWindowWord;                    external;
function GetWinMetaFileBits;               external;
function GetWorldTransform;                external;
function GlobalAddAtom;                    external;
function GlobalAlloc;                      external;
function GlobalDeleteAtom;                 external;
function GlobalFindAtom;                   external;
function GlobalFlags;                      external;
function GlobalFree;                       external;
function GlobalGetAtomName;                external;
function GlobalHandle;                     external;
function GlobalLock;                       external;
procedure GlobalMemoryStatus;              external;
function GlobalReAlloc;                    external;
function GlobalSize;                       external;
function GlobalUnlock;                     external;
function HeapAlloc;                        external;
function HeapCreate;                       external;
function HeapDestroy;                      external;
function HeapFree;                         external;
function HeapReAlloc;                      external;
function HeapSize;                         external;
function HideCaret;                        external;
function HiliteMenuItem;                   external;
function InflateRect;                      external;
function InitAtomTable;                    external;
procedure InitializeCriticalSection;       external;
procedure InitializeCriticalSectionAndSpinCount; external;
function InSendMessage;                    external;
function InsertMenu;                       external;
function InterlockedDecrement;             external;
function InterlockedExchange;              external;
function InterlockedIncrement;             external;
function IntersectClipRect;                external;
function IntersectRect;                    external;
function InvalidateRect;                   external;
function InvalidateRgn;                    external;
function InvertRect;                       external;
function InvertRgn;                        external;
function IsBadCodePtr;                     external;
function IsBadHugeReadPtr;                 external;
function IsBadHugeWritePtr;                external;
function IsBadReadPtr;                     external;
function IsBadStringPtr;                   external;
function IsBadWritePtr;                    external;
function IsCharAlpha;                      external;
function IsCharAlphaNumeric;               external;
function IsCharLower;                      external;
function IsCharUpper;                      external;
function IsChild;                          external;
function IsClipboardFormatAvailable;       external;
function IsDBCSLeadByte;                   external;
function IsDialogMessage;                  external;
function IsDlgButtonChecked;               external;
function IsIconic;                         external;
function IsMenu;                           external;
function IsRectEmpty;                      external;
function IsWindow;                         external;
function IsWindowEnabled;                  external;
function IsWindowVisible;                  external;
function IsZoomed;                         external;
function KillTimer;                        external;
procedure LeaveCriticalSection;            external;
function LineDDA;                          external;
function LineTo;                           external;
function LoadAccelerators;                 external;
function LoadBitmap;                       external;
function LoadCursor;                       external;
function LoadIcon;                         external;
function LoadLibrary;                      external;
function LoadMenu;                         external;
function LoadMenuIndirect;                 external;
function LoadModule;                       external;
function LoadResource;                     external;
function LoadString;                       external;
function LocalAlloc;                       external;
function LocalFileTimeToFileTime;          external;
function LocalFlags;                       external;
function LocalFree;                        external;
function LocalHandle;                      external;
function LocalLock;                        external;
function LocalReAlloc;                     external;
function LocalSize;                        external;
function LocalUnlock;                      external;
function LockFile;                         external;
function FreeResource;                     external;
function LockResource;                     external;
function LockWindowUpdate;                 external;
function LPtoDP;                           external;
function lstrcat;                          external;
function lstrcmp;                          external;
function lstrcmpi;                         external;
function lstrcpy;                          external;
function lstrlen;                          external;
function MapDialogRect;                    external;
function MapVirtualKey;                    external;
function MapWindowPoints;                  external;
function MaskBlt;                          external;
function MessageBeep;                      external;
function MessageBox;                       external;
function ModifyMenu;                       external;
function ModifyWorldTransform;             external;
function MoveFile;                         external;
function MoveToEx;                         external;
function MoveWindow;                       external;
function MsgWaitForMultipleObjects;        external;
function MulDiv;                           external;
function OemToAnsi;                        external;
function OemToAnsiBuff;                    external;
function OemToChar;                        external;
function OemToCharBuff;                    external;
function OffsetClipRgn;                    external;
function OffsetRect;                       external;
function OffsetRgn;                        external;
function OffsetViewportOrgEx;              external;
function OffsetWindowOrgEx;                external;
function OpenClipboard;                    external;
function OpenEvent;                        external;
function OpenFile;                         external;
function OpenMutex;                        external;
function OpenPrinter;                      external;
function OpenProcess;                      external;
function OpenSemaphore;                    external;
function OpenThread;                       external;
procedure OutputDebugString;               external;
function PackDDElParam;                    external;
function PaintRgn;                         external;
function PatBlt;                           external;
function PathToRegion;                     external;
function PeekMessage;                      external;
function Pie;                              external;
function PlayEnhMetaFile;                  external;
function PlayMetaFile;                     external;
function PlayMetaFileRecord;               external;
function PolyBezier;                       external;
function PolyBezierTo;                     external;
function PolyDraw;                         external;
function Polygon;                          external;
function Polyline;                         external;
function PolylineTo;                       external;
function PolyPolygon;                      external;
function PolyPolyline;                     external;
function PostMessage;                      external;
procedure PostQuitMessage;                 external;
function PostThreadMessage;                external;
function PtInRect;                         external;
function PtInRegion;                       external;
function PtVisible;                        external;
function PulseEvent;                       external;
function ReadFile;                         external;
function RealizePalette;                   external;
function Rectangle;                        external;
function RectInRegion;                     external;
function RectVisible;                      external;
function RedrawWindow;                     external;
function RegCloseKey;                      external;
function RegCreateKey;                     external;
function RegCreateKeyEx;                   external;
function RegDeleteKey;                     external;
function RegDeleteValue;                   external;
function RegEnumKey;                       external;
function RegEnumKeyEx;                     external;
function RegEnumValue;                     external;
function RegisterClass;                    external;
function RegisterClipboardFormat;          external;
function RegisterWindowMessage;            external;
function RegOpenKey;                       external;
function RegOpenKeyEx;                     external;
function RegQueryInfoKey;                  external;
function RegQueryValue;                    external;
function RegQueryValueEx;                  external;
function RegSetValue;                      external;
function RegSetValueEx;                    external;
function ReleaseCapture;                   external;
function ReleaseDC;                        external;
function ReleaseMutex;                     external;
function ReleaseSemaphore;                 external;
function RemoveDirectory;                  external;
function RemoveFontResource;               external;
function RemoveMenu;                       external;
function RemoveProp;                       external;
function ReplyMessage;                     external;
function ResetDC;                          external;
function ResetEvent;                       external;
function ResizePalette;                    external;
function RestoreDC;                        external;
function ResumeThread;                     external;
function ReuseDDElParam;                   external;
function RoundRect;                        external;
function SaveDC;                           external;
function ScaleViewportExtEx;               external;
function ScaleWindowExtEx;                 external;
function ScreenToClient;                   external;
function ScrollDC;                         external;
function ScrollWindow;                     external;
function ScrollWindowEx;                   external;
function SearchPath;                       external;
function SelectClipRgn;                    external;
function SelectObject;                     external;
function SelectPalette;                    external;
function SendDlgItemMessage;               external;
function SendMessage;                      external;
function SetActiveWindow;                  external;
function SetArcDirection;                  external;
function SetBitmapBits;                    external;
function SetBitmapDimensionEx;             external;
function SetBkColor;                       external;
function SetBkMode;                        external;
function SetBoundsRect;                    external;
function SetBrushOrgEx;                    external;
function SetCapture;                       external;
function SetCaretBlinkTime;                external;
function SetCaretPos;                      external;
function SetClassLong;                     external;
function SetClassWord;                     external;
function SetClipboardData;                 external;
function SetClipboardViewer;               external;
function SetCurrentDirectory;              external;
function SetCursor;                        external;
function SetCursorPos;                     external;
function SetDIBits;                        external;
function SetDIBitsToDevice;                external;
function SetDlgItemInt;                    external;
function SetDlgItemText;                   external;
function SetDoubleClickTime;               external;
function SetEndOfFile;                     external;
function SetEnhMetaFileBits;               external;
function SetEnvironmentVariable;           external;
function SetEvent;                         external;
function SetFileAttributes;                external;
function SetFilePointer;                   external;
function SetFileTime;                      external;
function SetFocus;                         external;
function SetForegroundWindow;              external;
function SetGraphicsMode;                  external;
function SetHandleCount;                   external;
procedure SetLastError;                    external;
function SetLocalTime;                     external;
function SetMapMode;                       external;
function SetMapperFlags;                   external;
function SetMenu;                          external;
function SetMenuItemBitmaps;               external;
function SetMetaFileBitsEx;                external;
function SetMiterLimit;                    external;
function SetPaletteEntries;                external;
function SetParent;                        external;
function SetPixel;                         external;
function SetPolyFillMode;                  external;
function SetPriorityClass;                 external;
function SetProp;                          external;
function SetRect;                          external;
function SetRectEmpty;                     external;
function SetRectRgn;                       external;
function SetROP2;                          external;
function SetScrollPos;                     external;
function SetScrollRange;                   external;
function SetStdHandle;                     external;
function SetStretchBltMode;                external;
function SetSysColors;                     external;
function SetSystemTime;                    external;
function SetTextAlign;                     external;
function SetTextCharacterExtra;            external;
function SetTextColor;                     external;
function SetTextJustification;             external;
function SetThreadPriority;                external;
function SetTimer;                         external;
function SetTimeZoneInformation;           external;
function SetViewportExtEx;                 external;
function SetViewportOrgEx;                 external;
function SetVolumeLabel;                   external;
function SetWindowExtEx;                   external;
function SetWindowLong;                    external;
function SetWindowOrgEx;                   external;
function SetWindowPlacement;               external;
function SetWindowPos;                     external;
function SetWindowsHookEx;                 external;
function SetWindowText;                    external;
function SetWindowWord;                    external;
function SetWinMetaFileBits;               external;
function SetWorldTransform;                external;
function ShowCaret;                        external;
function ShowCursor;                       external;
function ShowOwnedPopups;                  external;
function ShowScrollBar;                    external;
function ShowWindow;                       external;
function SizeofResource;                   external;
procedure Sleep;                           external;
function StartDoc;                         external;
function StartPage;                        external;
function StretchBlt;                       external;
function StretchDIBits;                    external;
function StrokeAndFillPath;                external;
function StrokePath;                       external;
function SubtractRect;                     external;
function SuspendThread;                    external;
function SwapMouseButton;                  external;
function SystemParametersInfo;             external;
function SystemTimeToFileTime;             external;
function SystemTimeToTzSpecificLocalTime;  external;
function TabbedTextOut;                    external;
function TerminateProcess;                 external;
function TerminateThread;                  external;
function TextOut;                          external;
function TlsAlloc;                         external;
function TlsFree;                          external;
function TlsGetValue;                      external;
function TlsSetValue;                      external;
function TrackPopupMenu;                   external;
function TranslateAccelerator;             external;
function TranslateMDISysAccel;             external;
function TranslateMessage;                 external;
function UnhookWindowsHookEx;              external;
function UnionRect;                        external;
function UnlockFile;                       external;
function UnpackDDElParam;                  external;
function UnrealizeObject;                  external;
function UnregisterClass;                  external;
function UpdateWindow;                     external;
function ValidateRect;                     external;
function ValidateRgn;                      external;
function VkKeyScan;                        external;
function WaitForMultipleObjects;           external;
function WaitForSingleObject;              external;
function WaitMessage;                      external;
function WidenPath;                        external;
function WindowFromDC;                     external;
function WindowFromPoint;                  external;
function WinExec;                          external;
function WinHelp;                          external;
function WinMain;                          external;
function WriteFile;                        external;
function WritePrivateProfileString;        external;
function WriteProfileString;               external;
function wsprintf;                         external;
function wvsprintf;                        external;
function _lclose;                          external;
function _lcreat;                          external;
function _llseek;                          external;
function _lopen;                           external;
function _lread;                           external;
function _lwrite;                          external;

{$IFDEF Open32}

function WinCallWinMain;                   external;
function WinQueryTranslateMode;            external;
function WinSetTranslateMode;              external;
function WinTranslateDevicePoints;         external;
function WinTranslateDeviceRects;          external;
function WinTranslateGraphicsObjectHandle; external;
function WinTranslateMnemonicString;       external;

{$ELSE}

function AbortSystemShutdown;           external;
function AccessCheck;                   external;
function AccessCheckAndAuditAlarm;      external;
function AddAccessAllowedAce;           external;
function AddAccessDeniedAce;            external;
function AddAce;                        external;
function AddAuditAccessAce;             external;
function AdjustTokenGroups;             external;
function AdjustTokenPrivileges;         external;
function AllocateAndInitializeSid;      external;
function AllocateLocallyUniqueId;       external;
function AreAllAccessesGranted;         external;
function AreAnyAccessesGranted;         external;
function BackupEventLog;                external;
function ClearEventLog;                 external;
function CloseEventLog;                 external;
function CopySid;                       external;
function CreatePrivateObjectSecurity;   external;
function CreateProcessAsUser;           external;
function DeleteAce;                     external;
function DeregisterEventSource;         external;
function DestroyPrivateObjectSecurity;  external;
function DuplicateToken;                external;
function EqualPrefixSid;                external;
function EqualSid;                      external;
function FindFirstFreeAce;              external;
function FreeSid;                       external;
function GetAce;                        external;
function GetAclInformation;             external;
function GetFileSecurity;               external;
function GetKernelObjectSecurity;       external;
function GetLengthSid;                  external;
function GetNumberOfEventLogRecords;    external;
function GetOldestEventLogRecord;       external;
function GetPrivateObjectSecurity;      external;
function GetSecurityDescriptorControl;  external;
function GetSecurityDescriptorDacl;     external;
function GetSecurityDescriptorGroup;    external;
function GetSecurityDescriptorLength;   external;
function GetSecurityDescriptorOwner;    external;
function GetSecurityDescriptorSacl;     external;
function GetSidIdentifierAuthority;     external;
function GetSidLengthRequired;          external;
function GetSidSubAuthority;            external;
function GetSidSubAuthorityCount;       external;
function GetTokenInformation;           external;
function GetUserName;                   external;
function ImpersonateLoggedOnUser;       external;
function ImpersonateNamedPipeClient;    external;
function ImpersonateSelf;               external;
function InitializeAcl;                 external;
function InitializeSecurityDescriptor;  external;
function InitializeSid;                 external;
function InitiateSystemShutdown;        external;
function IsTextUnicode;                 external;
function IsValidAcl;                    external;
function IsValidSecurityDescriptor;     external;
function IsValidSid;                    external;
function LogonUser;                     external;
function LookupAccountName;             external;
function LookupAccountSid;              external;
function LookupPrivilegeDisplayName;    external;
function LookupPrivilegeName;           external;
function LookupPrivilegeValue;          external;
function MakeAbsoluteSD;                external;
function MakeSelfRelativeSD;            external;
procedure MapGenericMask;               external;
function NotifyChangeEventLog;          external;
function ObjectCloseAuditAlarm;         external;
function ObjectOpenAuditAlarm;          external;
function ObjectPrivilegeAuditAlarm;     external;
function OpenBackupEventLog;            external;
function OpenEventLog;                  external;
function OpenProcessToken;              external;
function OpenThreadToken;               external;
function PrivilegeCheck;                external;
function PrivilegedServiceAuditAlarm;   external;
function ReadEventLog;                  external;
function RegConnectRegistry;            external;
function RegFlushKey;                   external;
function RegGetKeySecurity;             external;
function RegLoadKey;                    external;
function RegNotifyChangeKeyValue;       external;
function RegQueryMultipleValues;        external;
function RegReplaceKey;                 external;
function RegRestoreKey;                 external;
function RegSaveKey;                    external;
function RegSetKeySecurity;             external;
function RegUnLoadKey;                  external;
function RegisterEventSource;           external;
function ReportEvent;                   external;
function RevertToSelf;                  external;
function SetAclInformation;             external;
function SetFileSecurity;               external;
function SetKernelObjectSecurity;       external;
function SetPrivateObjectSecurity;      external;
function SetSecurityDescriptorDacl;     external;
function SetSecurityDescriptorGroup;    external;
function SetSecurityDescriptorOwner;    external;
function SetSecurityDescriptorSacl;     external;
function SetThreadToken;                external;
function SetTokenInformation;           external;

function AllocConsole;                  external;
function AreFileApisANSI;               external;
function BackupRead;                    external;
function BackupSeek;                    external;
function BackupWrite;                   external;
function BeginUpdateResource;           external;
function BuildCommDCB;                  external;
function BuildCommDCBAndTimeouts;       external;
function CallNamedPipe;                 external;
function ClearCommBreak;                external;
function ClearCommError;                external;
function CommConfigDialog;              external;
function CompareString;                 external;
function ConnectNamedPipe;              external;
function ContinueDebugEvent;            external;
function ConvertDefaultLocale;          external;
function CreateConsoleScreenBuffer;     external;
function CreateDirectoryEx;             external;
function CreateFileMapping;             external;
function CreateIoCompletionPort;        external;
function CreateMailslot;                external;
function CreateNamedPipe;               external;
function CreatePipe;                    external;
function CreateRemoteThread;            external;
function CreateTapePartition;           external;
function DebugActiveProcess;            external;
procedure DebugBreak;                   external;
function DefineDosDevice;               external;
function DeviceIoControl;               external;
function DisableThreadLibraryCalls;     external;
function DisconnectNamedPipe;           external;
function EndUpdateResource;             external;
function EnumCalendarInfo;              external;
function EnumDateFormats;               external;
function EnumResourceLanguages;         external;
function EnumResourceNames;             external;
function EnumResourceTypes;             external;
function EnumSystemCodePages;           external;
function EnumSystemLocales;             external;
function EnumTimeFormats;               external;
function EraseTape;                     external;
function EscapeCommFunction;            external;
function ExpandEnvironmentStrings;      external;
function FillConsoleOutputAttribute;    external;
function FillConsoleOutputCharacter;    external;
function FindCloseChangeNotification;   external;
function FindFirstChangeNotification;   external;
function FindNextChangeNotification;    external;
function FindResourceEx;                external;
function FlushConsoleInputBuffer;       external;
function FlushInstructionCache;         external;
function FlushViewOfFile;               external;
function FoldString;                    external;
function FormatMessage;                 external;
function FreeConsole;                   external;
function FreeEnvironmentStrings;        external;
procedure FreeLibraryAndExitThread;     external;
function GenerateConsoleCtrlEvent;      external;
function GetBinaryType;                 external;
function GetCPInfo;                     external;
function GetCommConfig;                 external;
function GetCommMask;                   external;
function GetCommModemStatus;            external;
function GetCommProperties;             external;
function GetCommState;                  external;
function GetCommTimeouts;               external;
function GetCompressedFileSize;         external;
function GetComputerName;               external;
function GetConsoleCP;                  external;
function GetConsoleCursorInfo;          external;
function GetConsoleMode;                external;
function GetConsoleOutputCP;            external;
function GetConsoleScreenBufferInfo;    external;
function GetConsoleTitle;               external;
function GetCurrencyFormat;             external;
function GetDateFormat;                 external;
function GetDefaultCommConfig;          external;
function GetHandleInformation;          external;
function GetLargestConsoleWindowSize;   external;
function GetLocaleInfo;                 external;
function GetMailslotInfo;               external;
function GetNamedPipeHandleState;       external;
function GetNamedPipeInfo;              external;
function GetNumberFormat;               external;
function GetNumberOfConsoleInputEvents; external;
function GetNumberOfConsoleMouseButtons;external;
function GetPrivateProfileSection;      external;
function GetPrivateProfileSectionNames; external;
function GetProcessAffinityMask;        external;
function SetProcessAffinityMask;        external;
function GetProcessHeap;                external;
function GetProcessHeaps;               external;
function GetProcessShutdownParameters;  external;
function GetProcessTimes;               external;
function GetProcessVersion;             external;
function GetProcessWorkingSetSize;      external;
function GetProfileSection;             external;
function GetQueuedCompletionStatus;     external;
function GetShortPathName;              external;
procedure GetStartupInfo;               external;
function GetStringTypeEx;               external;
function GetSystemDefaultLCID;          external;
function GetSystemDefaultLangID;        external;
procedure GetSystemInfo;                external;
function GetSystemPowerStatus;          external;
procedure GetSystemTimeAsFileTime;      external;
function GetSystemTimeAdjustment;       external;
function GetTapeParameters;             external;
function GetTapePosition;               external;
function GetTapeStatus;                 external;
function GetThreadContext;              external;
function GetThreadLocale;               external;
function GetThreadSelectorEntry;        external;
function GetThreadTimes;                external;
function GetTimeFormat;                 external;
function GetUserDefaultLCID;            external;
function GetUserDefaultLangID;          external;
function GetVersion;                    external;
function GetVersionEx;                  external;
function GlobalCompact;                 external;
procedure GlobalFix;                    external;
function GlobalUnWire;                  external;
procedure GlobalUnfix;                  external;
function GlobalWire;                    external;
function HeapCompact;                   external;
function HeapLock;                      external;
function HeapUnlock;                    external;
function HeapValidate;                  external;
function HeapWalk;                      external;
function IsDBCSLeadByteEx;              external;
function IsValidCodePage;               external;
function IsValidLocale;                 external;
function LCMapString;                   external;
function LoadLibraryEx;                 external;
function LocalCompact;                  external;
function LocalShrink;                   external;
function LockFileEx;                    external;
function MapViewOfFile;                 external;
function MapViewOfFileEx;               external;
function MoveFileEx;                    external;
function MultiByteToWideChar;           external;
function OpenFileMapping;               external;
function PeekConsoleInput;              external;
function PeekNamedPipe;                 external;
function PostQueuedCompletionStatus;    external;
function PrepareTape;                   external;
function PurgeComm;                     external;
function QueryDosDevice;                external;
function QueryPerformanceCounter;       external;
function QueryPerformanceFrequency;     external;
procedure RaiseException;               external;
function ReadConsole;                   external;
function ReadConsoleInput;              external;
function ReadConsoleOutput;             external;
function ReadConsoleOutputAttribute;    external;
function ReadConsoleOutputCharacter;    external;
function ReadFileEx;                    external;
function ReadProcessMemory;             external;
function ScrollConsoleScreenBuffer;     external;
function SetCommBreak;                  external;
function SetCommConfig;                 external;
function SetCommMask;                   external;
function SetCommState;                  external;
function SetCommTimeouts;               external;
function SetComputerName;               external;
function SetConsoleActiveScreenBuffer;  external;
function SetConsoleCP;                  external;
function SetConsoleCtrlHandler;         external;
function SetConsoleCursorInfo;          external;
function SetConsoleCursorPosition;      external;
function SetConsoleMode;                external;
function SetConsoleOutputCP;            external;
function SetConsoleScreenBufferSize;    external;
function SetConsoleTextAttribute;       external;
function SetConsoleTitle;               external;
function SetConsoleWindowInfo;          external;
function SetDefaultCommConfig;          external;
function SetErrorMode;                  external;
procedure SetFileApisToANSI;            external;
procedure SetFileApisToOEM;             external;
function SetHandleInformation;          external;
function SetLocaleInfo;                 external;
function SetMailslotInfo;               external;
function SetNamedPipeHandleState;       external;
function SetProcessShutdownParameters;  external;
function SetProcessWorkingSetSize;      external;
function SetSystemPowerState;           external;
function SetSystemTimeAdjustment;       external;
function SetTapeParameters;             external;
function SetTapePosition;               external;
function SetThreadAffinityMask;         external;
function SetThreadContext;              external;
function SetThreadLocale;               external;
function SetUnhandledExceptionFilter;   external;
function SetupComm;                     external;
function SleepEx;                       external;
function TransactNamedPipe;             external;
function TransmitCommChar;              external;
function UnhandledExceptionFilter;      external;
function UnlockFileEx;                  external;
function UnmapViewOfFile;               external;
function UpdateResource;                external;
function VerLanguageName;               external;
function VirtualAlloc;                  external;
function VirtualFree;                   external;
function VirtualLock;                   external;
function VirtualProtect;                external;
function VirtualProtectEx;              external;
function VirtualQuery;                  external;
function VirtualQueryEx;                external;
function VirtualUnlock;                 external;
function WaitCommEvent;                 external;
function WaitForDebugEvent;             external;
function WaitForMultipleObjectsEx;      external;
function WaitForSingleObjectEx;         external;
function WaitNamedPipe;                 external;
function WideCharToMultiByte;           external;
function WriteConsole;                  external;
function WriteConsoleInput;             external;
function WriteConsoleOutput;            external;
function WriteConsoleOutputAttribute;   external;
function WriteConsoleOutputCharacter;   external;
function WriteFileEx;                   external;
function WritePrivateProfileSection;    external;
function WriteProcessMemory;            external;
function WriteProfileSection;           external;
function WriteTapemark;                 external;
function _hread;                        external;
function _hwrite;                       external;
function lstrcpyn;                      external;

function MultinetGetConnectionPerformance;  external;
function WNetAddConnection2;            external;
function WNetAddConnection3;            external;
function WNetAddConnection;             external;
function WNetCancelConnection2;         external;
function WNetCancelConnection;          external;
function WNetCloseEnum;                 external;
function WNetConnectionDialog1;         external;
function WNetConnectionDialog;          external;
function WNetDisconnectDialog1;         external;
function WNetDisconnectDialog;          external;
function WNetEnumResource;              external;
function WNetGetConnection;             external;
function WNetGetLastError;              external;
function WNetGetNetworkInformation;     external;
function WNetGetProviderName;           external;
function WNetGetUniversalName;          external;
function WNetGetUser;                   external;
function WNetOpenEnum;                  external;
function WNetSetConnection;             external;
function WNetUseConnection;             external;

function GetFileVersionInfo;            external;
function GetFileVersionInfoSize;        external;
function VerFindFile;                   external;
function VerInstallFile;                external;
function VerQueryValue;                 external;

function GetPrivateProfileStruct;       external;
function WritePrivateProfileStruct;     external;

function CancelDC;                      external;
function CheckColorsInGamut;            external;
function ChoosePixelFormat;             external;
function ColorMatchToTarget;            external;
function CombineTransform;              external;
function CreateColorSpace;              external;
function CreateDIBPatternBrush;         external;
function CreateDIBSection;              external;
function CreateDiscardableBitmap;       external;
function CreateScalableFontResource;    external;
function DeleteColorSpace;              external;
function DescribePixelFormat;           external;
function DrawEscape;                    external;
function EnumFontFamiliesEx;            external;
function EnumICMProfiles;               external;
function ExtEscape;                     external;
function GdiComment;                    external;
function GetCharABCWidthsFloat;         external;
function GetCharWidth32;                external;
function GetCharWidthFloat;             external;
function GetCharacterPlacement;         external;
function GetColorSpace;                 external;
function GetDIBColorTable;              external;
function GetDeviceGammaRamp;            external;
function GetEnhMetaFileDescription;     external;
function GetFontData;                   external;
function GetFontLanguageInfo;           external;
function GetGlyphOutline;               external;
function GetICMProfile;                 external;
function GetLogColorSpace;              external;
function GetMetaRgn;                    external;
function GetPixelFormat;                external;
function GetSystemPaletteUse;           external;
function GetTextCharset;                external;
function GetTextCharsetInfo;            external;
function GetTextExtentExPoint;          external;
function PlayEnhMetaFileRecord;         external;
function PlgBlt;                        external;
function PolyTextOut;                   external;
function SelectClipPath;                external;
function SetAbortProc;                  external;
function SetColorSpace;                 external;
function SetDIBColorTable;              external;
function SetDeviceGammaRamp;            external;
function SetICMMode;                    external;
function SetICMProfile;                 external;
function SetMetaRgn;                    external;
function SetPixelFormat;                external;
function SetPixelV;                     external;
function SetSystemPaletteUse;           external;
function SwapBuffers;                   external;
function UpdateColors;                  external;

function wglCreateContext;              external;
function wglCopyContext;                external;
function wglCreateLayerContext;         external;
function wglDeleteContext;              external;
function wglGetCurrentContext;          external;
function wglGetCurrentDC;               external;
function wglMakeCurrent;                external;
function wglShareLists;                 external;
function wglUseFontBitmaps;             external;
function wglUseFontOutlines;            external;
function wglDescribeLayerPlane;         external;
function wglSetLayerPaletteEntries;     external;
function wglGetLayerPaletteEntries;     external;
function wglRealizeLayerPalette;        external;
function wglSwapLayerBuffers;           external;

function ActivateKeyboardLayout;        external;
function AnyPopup;                      external;
function AttachThreadInput;             external;
function BroadcastSystemMessage;        external;
function CascadeWindows;                external;
function ChangeDisplaySettings;         external;
function ChangeMenu;                    external;
function CharNextEx;                    external;
function CharPrevEx;                    external;
function CheckMenuRadioItem;            external;
function ChildWindowFromPointEx;        external;
function CloseDesktop;                  external;
function CloseWindowStation;            external;
function CopyAcceleratorTable;          external;
function CopyImage;                     external;
function CreateDesktop;                 external;
function CreateIconFromResourceEx;      external;
function CreateWindowStation;           external;
function DdeSetQualityOfService;        external;
function DragDetect;                    external;
function DragObject;                    external;
function DrawAnimatedRects;             external;
function DrawCaption;                   external;
function DrawEdge;                      external;
function DrawFrameControl;              external;
function DrawIconEx;                    external;
function DrawState;                     external;
function DrawTextEx;                    external;
function EnumDesktops;                  external;
function EnumDesktopWindows;            external;
function EnumDisplaySettings;           external;
function EnumWindowStations;            external;
function FindWindowEx;                  external;
function GetAsyncKeyState;              external;
function GetClassInfoEx;                external;
function GetInputState;                 external;
function GetKBCodePage;                 external;
function GetKeyboardLayout;             external;
function GetKeyboardLayoutList;         external;
function GetKeyboardLayoutName;         external;
function GetKeyboardState;              external;
function GetMenuContextHelpId;          external;
function GetMenuDefaultItem;            external;
function GetMenuItemInfo;               external;
function GetMenuItemRect;               external;
function GetProcessWindowStation;       external;
function GetScrollInfo;                 external;
function GetSysColorBrush;              external;
function GetThreadDesktop;              external;
function GetUserObjectInformation;      external;
function GetUserObjectSecurity;         external;
function GetWindowContextHelpId;        external;
function GetWindowRgn;                  external;
function GrayString;                    external;
function ImpersonateDdeClientWindow;    external;
function InsertMenuItem;                external;
function IsWindowUnicode;               external;
function LoadCursorFromFile;            external;
function LoadImage;                     external;
function LoadKeyboardLayout;            external;
function LookupIconIdFromDirectory;     external;
function LookupIconIdFromDirectoryEx;   external;
function MapVirtualKeyEx;               external;
function MenuItemFromPoint;             external;
function MessageBoxEx;                  external;
function MessageBoxIndirect;            external;
function OemKeyScan;                    external;
function OpenDesktop;                   external;
function OpenIcon;                      external;
function OpenInputDesktop;              external;
function OpenWindowStation;             external;
function PaintDesktop;                  external;
function RegisterClassEx;               external;
function RegisterHotKey;                external;
function SendMessageCallback;           external;
function SendMessageTimeout;            external;
function SendNotifyMessage;             external;
procedure SetDebugErrorLevel;           external;
function SetKeyboardState;              external;
procedure SetLastErrorEx;               external;
function SetMenuContextHelpId;          external;
function SetMenuDefaultItem;            external;
function SetMenuItemInfo;               external;
function SetMessageExtraInfo;           external;
function SetMessageQueue;               external;
function SetProcessWindowStation;       external;
function SetScrollInfo;                 external;
function SetSystemCursor;               external;
function SetThreadDesktop;              external;
function SetUserObjectInformation;      external;
function SetUserObjectSecurity;         external;
function SetWindowContextHelpId;        external;
function SetWindowsHook;                external;
function SetWindowRgn;                  external;
function ShowWindowAsync;               external;
function SwitchDesktop;                 external;
function TileWindows;                   external;
function ToAscii;                       external;
function ToAsciiEx;                     external;
function ToUnicode;                     external;
function ToUnicodeEx;                   external;
function TrackPopupMenuEx;              external;
function TranslateCharsetInfo;          external;
function UnhookWindowsHook;             external;
function UnloadKeyboardLayout;          external;
function UnregisterHotKey;              external;
function VkKeyScanEx;                   external;
function WaitForInputIdle;              external;
procedure keybd_event;                  external;
procedure mouse_event;                  external;
function VirtualAllocEx;                external;
function VirtualFreeEx;                 external;
function CreateFiber;                   external;
function DeleteFiber;                   external;
function ConvertThreadToFiber;          external;
function SwitchToFiber;                 external;
function SwitchToThread;                external;
function SetThreadIdealProcessor;       external;
function SetProcessPriorityBoost;       external;
function GetProcessPriorityBoost;       external;
function SetThreadPriorityBoost;        external;
function GetThreadPriorityBoost;        external;
function QueueUserAPC;                  external;
function TryEnterCriticalSection;       external;
function IsProcessorFeaturePresent;     external;
function SignalObjectAndWait;           external;
function CreateWaitableTimer;           external;
function OpenWaitableTimer;             external;
function SetWaitableTimer;              external;
function CancelWaitableTimer;           external;
function GetDiskFreeSpaceEx;            external;
function GetFileAttributesEx;           external;
function FindFirstFileEx;               external;
function CopyFileEx;                    external;
function CancelIo;                      external;
function ObjectDeleteAuditAlarm;        external;
function ReadDirectoryChanges;          external;
function DuplicateTokenEx;              external;
function GetCurrentHwProfile;           external;
function WinSubmitCertificate;          external;
function DeviceCapabilitiesEx;          external;
function GetEnhMetaFilePixelFormat;     external;
function TrackMouseEvent;               external;
function MsgWaitForMultipleObjectsEx;   external;
function ChangeDisplaySettingsEx;       external;
function WNetGetResourceParent;         external;
function GetStringTypeA;                external;

{$ENDIF Open32}

function GlobalAllocPtr(Flags: Integer; Bytes: Longint): Pointer;
begin
  Result := GlobalLock(GlobalAlloc(Flags, Bytes));
end;

function GlobalReAllocPtr(P: Pointer; Bytes: Longint; Flags: Integer): Pointer;
var
  Handle: THandle;
begin
  Handle := GlobalHandle(P);
  GlobalUnlock(Handle);
  Result := GlobalLock(GlobalReAlloc(Handle, Bytes, Flags));
end;

function GlobalFreePtr(P: Pointer): THandle;
var
  Handle: THandle;
begin
  Handle := GlobalHandle(P);
  GlobalUnlock(Handle);
  Result := GlobalFree(Handle);
end;

function TPointFromLong(L: Longint): TPoint;
begin
  Result.X := TSmallPoint(L).X;
  Result.Y := TSmallPoint(L).Y;
end;

function GetCurrentTime: Longint;
begin
  Result := GetTickCount;
end;

procedure ZeroMemory(Destination: Pointer; Length: DWord);
begin
  FillChar(Destination^, Length, 0);
end;

function GlobalDiscard(Handle: HGlobal): HGlobal;
begin
 Result := GlobalReAlloc(Handle, 0, gmem_Moveable);
end;

function LocalDiscard(Mem: HLocal): HLocal;
begin
 Result := LocalReAlloc(Mem, 0, lmem_Moveable);
end;

function UnlockResource(hResData: THandle): Bool;
begin
  Result := False;
end;

function Succeeded(Status: HResult): Bool;
begin
  Result := Status >= 0;
end;

function Failed(Status: HResult): Bool;
begin
  Result := Status < 0;
end;

function IsError(Status: HResult): Bool;
begin
  Result := (Status shr 31) = Severity_Error;
end;

function HResultCode(hr: HResult): Integer;
begin
  Result := hr and $0000FFFF;
end;

function HResultFacility(hr: HResult): Integer;
begin
  Result := (hr shr 16) and $00001FFF;
end;

function HResultSeverity(hr: HResult): Integer;
begin
  Result := (hr shr 31) and $00000001;
end;

function MakeResult(sev, fac, code: Integer): HResult;
begin
  Result := (sev shl 31) or (fac shl 16) or code;
end;

function HResultFromWin32(x: Integer): HResult;
begin
  Result := x;
  if Result <> 0 then
    Result := ((Result and $0000FFFF) or (FACILITY_WIN32 shl 16) or $80000000);
end;

function HResultFromNT(x: Integer): HResult;
begin
  Result := x or facility_NT_Bit;
end;

function GetCValue(cmyk: TColorRef): Byte;
begin
  Result := Byte(cmyk);
end;

function GetMValue(cmyk: TColorRef): Byte;
begin
  Result := Byte(cmyk shr 8);
end;

function GetYValue(cmyk: TColorRef): Byte;
begin
  Result := Byte(cmyk shr 16);
end;

function GetKValue(cmyk: TColorRef): Byte;
begin
  Result := Byte(cmyk shr 24);
end;

function CMYK(c, m, y, k: Byte): TColorRef;
begin
  Result := (c or (m shl 8) or (y shl 16) or (k shl 24));
end;

function RGB(r, g, b: Byte): TColorRef;
begin
  Result := (r or (g shl 8) or (b shl 16));
end;

function PaletteRGB(r, g, b: Byte): TColorRef;
begin
  Result := $02000000 or RGB(r,g,b);
end;

function PaletteIndex(i: Word): TColorRef;
begin
  Result := $01000000 or i;
end;

function GetRValue(rgb: DWord): Byte;
begin
  Result := Byte(rgb);
end;

function GetGValue(rgb: DWord): Byte;
begin
  Result := Byte(rgb shr 8);
end;

function GetBValue(rgb: DWord): Byte;
begin
  Result := Byte(rgb shr 16);
end;

function ExitWindows(Reserved: DWord; Code: UInt): Bool;
begin
  Result := ExitWindowsEx(ewx_LogOff, -1);
end;

function PostAppMessage(idThread: DWord; Msg: UInt; wParam: WParam; lParam: LParam): BOOL;
begin
  Result := PostThreadMessage(idThread, Msg, wParam, lParam)
end;

function CreateDialog(Instance: hInst; TemplateName: PChar; WndParent: hWnd; DialogFunc: TFNDlgProc): hWnd;
begin
  Result := CreateDialogParam(Instance, TemplateName, WndParent, DialogFunc, 0);
end;

function CreateDialogIndirect(Instance: HInst; const Template: TDlgTemplate; WndParent: HWnd; DialogFunc: TFNDlgProc): HWnd;
begin
  Result := CreateDialogIndirectParam(Instance, Template, WndParent, DialogFunc, 0);
end;

function DialogBox(Instance: HInst; Template: PChar; WndParent: HWnd; DialogFunc: TFNDlgProc): Integer;
begin
  Result := DialogBoxParam(Instance, Template, WndParent, DialogFunc, 0);
end;

function DialogBoxIndirect(Instance: hInst; const DlgTemplate: TDlgTemplate; WndParent: hWnd; DialogFunc: TFNDlgProc): Integer;
begin
  Result := DialogBoxIndirectParam(Instance, DlgTemplate, WndParent, DialogFunc, 0);
end;

function EnumTaskWindows(hTask: THandle; lpfn: TFarProc; lParam: LParam): Bool;
begin
  Result := EnumThreadWindows(DWord(hTask), lpfn, lParam);
end;

function GetWindowTask(hWnd: HWnd): THandle;
begin
  Result := THandle(GetWindowThreadProcessId(hWnd, nil));
end;

function CreateWindow(lpClassName: PChar; lpWindowName: PChar;
  dwStyle: DWord; X, Y, nWidth, nHeight: Integer; hWndParent: hWnd;
  hMenu: hMenu; hInstance: hInst; lpParam: Pointer): hWnd;
begin
  Result := CreateWindowEx(0, lpClassName, lpWindowName, dwStyle, X, Y,
    nWidth, nHeight, hWndParent, hMenu, HInstance, lpParam);
end;

function MoveTo(DC: HDC; X,Y: Integer): Bool;
var
  pt: tPoint;
begin
  MoveTo := MoveToEx(dc, X, Y, @pt);
end;

function SmallPointToPoint(const P: TSmallPoint): TPoint;
begin
  Result.X := P.X;
  Result.Y := P.Y;
end;

function PointToSmallPoint(const P: TPoint): TSmallPoint;
begin
  Result.X := P.X;
  Result.Y := P.Y;
end;

function MakeWord(A,B: Byte): SmallWord;
begin
  Result := A or B shl 8;
end;

function MakeLong(A,B: SmallWord): Longint;
begin
  Result := A or B shl 16;
end;

function HiWord(L: Longint): SmallWord;
begin
  Result := L shr 16;
end;

function HiByte(W: SmallWord): Byte;
begin
  Result := W shr 8;
end;

procedure MoveMemory(Destination: Pointer; Source: Pointer; Length: DWord);
begin
  Move(Source^, Destination^, Length);
end;

procedure CopyMemory(Destination: Pointer; Source: Pointer; Length: DWord);
begin
  Move(Source^, Destination^, Length);
end;

procedure FillMemory(Destination: Pointer; Length: DWord; Fill: Byte);
begin
  FillChar(Destination^, Length, Fill);
end;

function MakeWParam(L,H: SmallWord): wParam;
begin
  Result := L or H shl 16;
end;

function MakeLParam(L,H: SmallWord): lParam;
begin
  Result := L or H shl 16;
end;

function MakeLResult(L,H: SmallWord): lResult;
begin
  Result := L or H shl 16;
end;

end.
