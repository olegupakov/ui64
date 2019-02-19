unit ui;

interface

uses Windows, Types, Messages, SysUtils;

const
  clWhite=$ffffff;
  clBlack=$000000;
  clGray95=$f2f2f2;
  //      $c8d0d4
  clGray98=$fafafa;
//      $e2e1e1
  clButton=$7dba5f;

  clDkGray=$808080;
  clWebRoyalBlue=$E16941;
  clWebSlateGray=$908070;
  clWebLightBlue=$E6D8AD;
  clWebLightCyan=$FFFFE0;
  clWebSkyBlue=$EBCE87;

  clFaceBook1=$98593B;
  clFaceBook2=$c39d8b;
  clFaceBook3=$eee3df;
  clFaceBook4=$f7f7f7;
  clPanelBackground1=$eeeeee;
//  clPanelBackground1=$ededf1;
//  clPanelBackground1=$b4beb0;
//  clPanelBackground2=$dddddd;
  clPanelBackground2=$c8d0d4;
  clButtonInactiveBackground=$e1e1e1;
  clButtonInactiveBorder=$adadad;

(*
  panel background f0f0f0
  button inactive background e1e1e1
  button inactive border adadad
  button under mouse background e5e1fb
  button under mouse border 0078d7
*)

  DT_TOP = 0;
  DT_LEFT = 0;
  DT_CENTER = 1;
  DT_RIGHT = 2;
  DT_VCENTER = 4;
  DT_BOTTOM = 8;
  DT_WORDBREAK = $10;
  DT_SINGLELINE = $20;
  DT_EXPANDTABS = $40;
  DT_TABSTOP = $80;
  DT_NOCLIP = $100;
  DT_EXTERNALLEADING = $200;
  DT_CALCRECT = $400;
  DT_NOPREFIX = $800;
  DT_INTERNAL = $1000;
  DT_HIDEPREFIX = $00100000;
  DT_PREFIXONLY = $00200000;

  TRANSPARENT = 1;
  OPAQUE = 2;

  DC_BRUSH = 18;
  DC_PEN = 19;

  WM_XBUTTONDOWN = $020B;
  WM_XBUTTONUP = $020C;
  WM_XBUTTONDBLCLK = $020D;

  // wm_mousemove
  MK_SHIFT=$0004;    // The SHIFT key is down.
  MK_CONTROL=$0008;  // The CTRL key is down.
  MK_LBUTTON=$0001;  // The left mouse button is down.
  MK_MBUTTON=$0010;  // The middle mouse button is down.
  MK_RBUTTON=$0002;  // The right mouse button is down.
  MK_XBUTTON1=$0020; // The first X button is down.
  MK_XBUTTON2=$0040; // The second X button is down.

  MR_NONE = 0; // no close
  MR_OK = 1; // ok close
  MR_CANCEL = 2; // cancel close
  MR_CLOSE = 3; // just close

  CW_USEDEFAULT:CARDINAL=$80000000;

  CUSTOM_WIN  = 'CustomWindow';
  CUSTOM_COMP = 'CustomComponent';

var
  crArrow, crHand, crIBeam, crHourGlass, crSizeNS, crSizeWE : cardinal; // will be initialalized

  fntRegular,fntBold:HFONT; // will be initialalized

type

  TPoint = Types.TPoint;
  TRect = Types.TRect;

  TAlign = (alNone, alTop, alBottom, alLeft, alRight, alClient);
  TMouseButton = (mbLeft, mbMiddle, mbRight, mbX1, mbX2);

procedure ProcessMessages;

function SetDCBrushColor(DC: HDC; Color: COLORREF): COLORREF; stdcall;
function SetDCPenColor(DC: HDC; Color: COLORREF): COLORREF; stdcall;
function GetWindowLongPtr(hWnd: HWND; nIndex: Integer): pointer; stdcall;
function SetWindowLongPtr(hWnd: HWND; nIndex: Integer; dwNewLong: pointer): pointer; stdcall;

implementation

uses uihandle;

{$R ui.res}

{$IFDEF CPU64}
function GetWindowLongPtr; external user32 name 'GetWindowLongPtrA';
function SetWindowLongPtr; external user32 name 'SetWindowLongPtrA';
{$ELSE}
function GetWindowLongPtr; external user32 name 'GetWindowLongA';
function SetWindowLongPtr; external user32 name 'SetWindowLongA';
{$ENDIF}
function SetDCBrushColor; external gdi32 name 'SetDCBrushColor';
function SetDCPenColor; external gdi32 name 'SetDCPenColor';

function MouseCustomProc(comp:TWinHandle;AMessage: UINT; WParam : WPARAM; LParam: LPARAM):boolean;
var
  x,y,deltawheel:integer;
  mb:TMouseButton;
  p:TPoint;
  hWndUnder:HWND;
begin
  result:=false;
  x:=lparam and $ffff;
  y:=(lparam shr 16) and $ffff;
  case AMessage of
    WM_LBUTTONDOWN,WM_LBUTTONUP,WM_LBUTTONDBLCLK,
    WM_RBUTTONDOWN,WM_RBUTTONUP,WM_RBUTTONDBLCLK,
    WM_MBUTTONDOWN,WM_MBUTTONUP,WM_MBUTTONDBLCLK,
    WM_XBUTTONUP,WM_XBUTTONDOWN,WM_XBUTTONDBLCLK:begin
      mb:=mbLeft;
      case AMessage of
        WM_LBUTTONDOWN,WM_LBUTTONUP,WM_LBUTTONDBLCLK:mb:=mbLeft;
        WM_RBUTTONDOWN,WM_RBUTTONUP,WM_RBUTTONDBLCLK:mb:=mbRight;
        WM_MBUTTONDOWN,WM_MBUTTONUP,WM_MBUTTONDBLCLK:mb:=mbMiddle;
        WM_XBUTTONUP,WM_XBUTTONDOWN,WM_XBUTTONDBLCLK:begin
          if (wparam shr 16) and $ffff = 1 then mb:=mbX1;
          if (wparam shr 16) and $ffff = 2 then mb:=mbX2;
        end;
      end;
      case AMessage of
        WM_LBUTTONDOWN,WM_RBUTTONDOWN,WM_MBUTTONDOWN,WM_XBUTTONDOWN:begin
          comp.MouseButtonDownPerform(mb, wparam, x, y);
        end;
        WM_LBUTTONUP,WM_RBUTTONUP,WM_MBUTTONUP,WM_XBUTTONUP:begin
          comp.MouseButtonUpPerform(mb, wparam, x, y);
        end;
        WM_LBUTTONDBLCLK,WM_RBUTTONDBLCLK,WM_MBUTTONDBLCLK,WM_XBUTTONDBLCLK:begin
          comp.MouseButtonDblDownPerform(mb, wparam, x, y);
        end;
      end;
      result:=true;
    end;
    WM_MOUSEMOVE:begin
      comp.MouseMovePerform(wparam, x, y);
      result:=true;
    end;
    WM_MOUSELEAVE:begin
      comp.MouseLeavePerform;
      result:=true;
    end;
    WM_MOUSEWHEEL:begin
      GetCursorPos(p);
      hWndUnder:=WindowFromPoint(p);
      if(hWndUnder=0)or(comp.Window=hWndUnder)
      then begin
(*
        deltawheel:=wparam;
        asm
          lea eax, deltawheel
          sar DWORD PTR [eax], 16
        end;
*)
        if wparam and $80000000 = $80000000
        then deltawheel := -1
        else deltawheel := 1;
        comp.MouseWheelPerform(wparam and $ffff, deltawheel, x, y);
      end
      else PostMessage(hWndUnder, WM_MOUSEWHEEL, WParam, LParam);
      result:=true;
    end;
    WM_MOUSEHOVER:begin
      //comp.WinClass.Text:=comp.WinClass.Text+'H';
      //comp.WinClass.RedrawPerform;
      //result:=0;
      //Exit;
    end;
  end;
end;

function WindowProc(hWindow: HWnd; AMessage: UINT; WParam : WPARAM; LParam: LPARAM): LRESULT; stdcall;
var r:TRect;
    frm:TWinHandle;
begin
  WindowProc := 0;

  frm:=GetWindowLongPtr(hWindow, GWL_USERDATA);
  if frm<>nil
  then begin
    if MouseCustomProc(frm, AMessage, WParam, LParam)
    then exit;
    case AMessage of
      WM_KILLFOCUS:begin
        frm.KillFocusPerform(WParam);
        WindowProc:=0;
        exit;
      end;
      WM_CLOSE:begin
        frm.ClosePerform;
      end;
 (*     WM_MOUSEACTIVATE:Begin
        if not frm.Enabled
        then begin
          WindowProc:=MA_NOACTIVATEANDEAT;
          exit;
        end;
      end;*)
      wm_char:begin
        frm.KeyCharPerform(wparam);
        WindowProc:=0;
        Exit;
      end;
      wm_keydown:begin
        // get focused comp
  //      if wparam=65
    //    then begin
      //   MessageBox(0, pchar('keyup '+inttostr(wparam)+' '+inttostr(lparam)), nil, mb_Ok);
         WindowProc:=0;
         Exit;
     //   end;
      end;
//      wm_keyup
//      WM_SYSKEYDOWN
      WM_SYSCHAR:begin
        // get focused comp
        if wparam<>18
        then begin
         MessageBox(0, pchar('keyup '+inttostr(wparam)+' '+inttostr(lparam)), nil, mb_Ok);
         WindowProc:=0;
         Exit;
        end;
      end;
  //    wm_create:begin
  //    end;
  //    wm_sizing:begin
  //      WindowProc:=0;
  //    end;
      wm_size:begin
        if (wParam = SIZE_MAXIMIZED) or(wParam = SIZE_RESTORED)
        then begin
          frm.SizePerform;
          GetWindowRect(hWindow, r);
  //todo          if r.Bottom-r.Top<500
  //          then begin
    //          SetWindowPos(hWindow, 0, r.Left, r.Top, r.Right-r.Left, 500, SWP_NOZORDER);
      //      end;
        end
      end;
      WM_EraseBkgnd:begin
       // WindowProc:=1;
       // Exit;
      end;
      wm_Destroy: begin
        if MainWinForm.Window = hWindow
        then PostQuitMessage(0);
        Exit;
      end;
    end;
  end;
  WindowProc := DefWindowProc(hWindow, AMessage, WParam, LParam);
end;

function CustomProc(hWindow: HWnd; AMessage: UINT; WParam : WPARAM;
                    LParam: LPARAM): LRESULT; stdcall;
var
  comp:TWinHandle;
begin
  comp:=GetWindowLongPtr(hWindow, GWL_USERDATA);
  if comp<>nil
  then begin
    if MouseCustomProc(comp, AMessage, WParam, LParam)
    then begin
      result:=0;
      exit;
    end;
    case AMessage of
      WM_CAPTURECHANGED:begin
        comp.CapturePerform(lparam);
        result:=0;
        exit;
      end;
      WM_KILLFOCUS:begin
        comp.KillFocusPerform(wparam);
        result:=0;
        exit;
      end;
      WM_INPUTLANGCHANGE:begin
        //MessageBox(0, pchar('WM_INPUTLANGCHANGE '+inttostr(wparam)+' '+inttostr(lparam)), nil, mb_Ok);
      end;
      wm_char:begin
        comp.KeyCharPerform(wparam);
        result:=0;
        Exit;
      end;
      wm_paint:begin
        comp.CustomPaint;
        Result:=0;
        exit
      end;
    end;
  end;
  CustomProc := DefWindowProc(hWindow, AMessage, WParam, LParam);
end;

procedure CustomRegister;
var
  wc: WndClass;
begin
    wc.style := CS_GLOBALCLASS or CS_HREDRAW or CS_VREDRAW or CS_DBLCLKS;
    wc.lpfnWndProc := @CustomProc;
    wc.cbClsExtra := 0;
    wc.cbWndExtra := 0;
    wc.hInstance := 0;
    wc.hIcon := 0;
    wc.hCursor := 0; //crArrow;
    wc.hbrBackground := 0; //COLOR_BACKGROUND;
    wc.lpszMenuName := nil;
    wc.lpszClassName := CUSTOM_COMP;
    RegisterClass(wc);
end;

procedure CustomUnregister;
begin
    UnregisterClass(CUSTOM_COMP, 0);
end;

function WinRegister: Boolean;
var
  WindowClass: WndClass;
begin
  WindowClass.Style := cs_hRedraw or cs_vRedraw;
  WindowClass.lpfnWndProc := @WindowProc;
  WindowClass.cbClsExtra := 0;
  WindowClass.cbWndExtra := 0;
  WindowClass.hInstance := system.MainInstance;
  WindowClass.hIcon := LoadIcon(system.MainInstance, 'APP');
//  WindowClass.hIcon := LoadIcon(0, IDI_INFORMATION);
  WindowClass.hCursor := crArrow;
  WindowClass.hbrBackground := COLOR_BTNFACE + 1;
  WindowClass.lpszMenuName := nil;
  WindowClass.lpszClassName := CUSTOM_WIN;

  Result := RegisterClass(WindowClass) <> 0;
end;

procedure ProcessMessages;
var AMessage: Msg;
    ret:longbool;
begin
  repeat
    ret:=GetMessage(AMessage, 0, 0, 0);
    if integer(ret) = -1 then break;
    TranslateMessage(AMessage);
    DispatchMessage(AMessage)
  until not ret
end;

procedure LoadCursors;
begin
  crArrow:=LoadCursor(0, IDC_ARROW);
  crHand:=LoadCursor(0, IDC_HAND);
  crIBeam:=LoadCursor(0, IDC_IBEAM);
  crHourGlass:=LoadCursor(0, IDC_WAIT);
  crSizeNS:=LoadCursor(0, IDC_SIZENS);
  crSizeWE:=LoadCursor(0, IDC_SIZEWE);
end;

procedure CreateFonts;
begin
  fntRegular:=CreateFont(-16,0,0,0,FW_REGULAR,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,NONANTIALIASED_QUALITY,DEFAULT_PITCH,'Courier New');
  fntBold:=CreateFont(-16,0,0,0,FW_BOLD,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,NONANTIALIASED_QUALITY,DEFAULT_PITCH,'Courier New');
end;

procedure DeleteFonts;
begin
  DeleteObject(fntRegular);
  DeleteObject(fntBold);
end;

initialization
  LoadCursors;
  CreateFonts;
  CustomRegister;
  if not WinRegister then begin
    MessageBox(0, 'WinRegister failed', nil, mb_Ok);
    halt(0);
  end;
finalization
  CustomUnregister;
  DeleteFonts;
end.

