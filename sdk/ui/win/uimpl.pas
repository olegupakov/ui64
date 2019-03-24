unit uimpl;

interface

uses Types, Windows, Messages, SysUtils;

const
    { MessageBox() Flags }
  {$EXTERNALSYM MB_OK}
  MB_OK = $00000000;
  {$EXTERNALSYM MB_OKCANCEL}
  MB_OKCANCEL = $00000001;
  {$EXTERNALSYM MB_ABORTRETRYIGNORE}
  MB_ABORTRETRYIGNORE = $00000002;
  {$EXTERNALSYM MB_YESNOCANCEL}
  MB_YESNOCANCEL = $00000003;
  {$EXTERNALSYM MB_YESNO}
  MB_YESNO = $00000004;
  {$EXTERNALSYM MB_RETRYCANCEL}
  MB_RETRYCANCEL = $00000005;

  {$EXTERNALSYM MB_ICONHAND}
  MB_ICONHAND = $00000010;
  {$EXTERNALSYM MB_ICONQUESTION}
  MB_ICONQUESTION = $00000020;
  {$EXTERNALSYM MB_ICONEXCLAMATION}
  MB_ICONEXCLAMATION = $00000030;
  {$EXTERNALSYM MB_ICONASTERISK}
  MB_ICONASTERISK = $00000040;
  {$EXTERNALSYM MB_USERICON}
  MB_USERICON = $00000080;
  {$EXTERNALSYM MB_ICONWARNING}
  MB_ICONWARNING                 = MB_ICONEXCLAMATION;
  {$EXTERNALSYM MB_ICONERROR}
  MB_ICONERROR                   = MB_ICONHAND;
  {$EXTERNALSYM MB_ICONINFORMATION}
  MB_ICONINFORMATION             = MB_ICONASTERISK;
  {$EXTERNALSYM MB_ICONSTOP}
  MB_ICONSTOP                    = MB_ICONHAND;

  WS_EX_CONTROLPARENT = $10000;
  WS_CHILD = $40000000;
  WS_VISIBLE = $10000000;

  WM_XBUTTONDOWN = $020B;
  WM_XBUTTONUP = $020C;
  WM_XBUTTONDBLCLK = $020D;

  SW_SHOWNORMAL = 1;
  SW_SHOWMINIMIZED = 2;
  SW_SHOWMAXIMIZED = 3;

  CUSTOM_WIN  = 'CustomWindow';
  CUSTOM_COMP = 'CustomComponent';

  DC_BRUSH = 18;
  DC_PEN = 19;

  MR_NONE = 0; // no close
  MR_OK = 1; // ok close
  MR_CANCEL = 2; // cancel close
  MR_CLOSE = 3; // just close

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

type

  TPoint = Types.TPoint;
  TRect = Types.TRect;

  TMouseButton = (mbLeft, mbMiddle, mbRight, mbX1, mbX2);

  HWND  = type LongWord;
  HFONT = type LongWord;
  HBITMAP = type LongWord;
  HDC   = type LongWord;
  UINT  = type LongWord;

  COLORREF=longword;

  TWinHandleImpl=class
  private
  protected
    hWindow:HWnd;
    wParent:TWinHandleImpl;
    wStyle,wExStyle:cardinal;

    wText:string;
    hLeft, hTop, hWidth, hHeight : integer;

    wBitmap, wMask : HBITMAP;

    wCursor:cardinal;

    KeyCursorX, KeyCursorY : integer;

    hTrackMouseEvent:TTrackMouseEvent;
    wTrackingMouse:boolean;

    wEnabled:boolean;
    wModalResult:integer;

    dc : hdc;
    ps : paintstruct;

    procedure CreateFormStyle;
    procedure CreateFormWindow;

    procedure CreateModalStyle;
    procedure CreateModalWindow;

    procedure CreateCompStyle;
    procedure CreateCompWindow;

    procedure CreatePopupStyle;

    procedure RegisterMouseLeave;
  public
    procedure Show(nCmdShow:integer = SW_SHOWNORMAL);virtual;
    procedure Hide;virtual;
    procedure RedrawPerform;
    procedure SetPosPerform;
    procedure SetFocusPerform;virtual;
    procedure CustomPaint;virtual;

    function SetCapture(hWnd: HWND): HWND;
    function ReleaseCapture: BOOL;
    function GetCursorPos(var lpPoint: TPoint): BOOL;
    function GetClientRect:TRect;
    procedure BeginPaint;
    procedure EndPaint;
    procedure DrawText(var r:TRect; const text:string; font:HFONT; color, bkcolor:cardinal; mode:integer; style:cardinal);
    procedure Polygon(color, bkcolor:cardinal; Left, Top, Right, Bottom:integer);
    procedure Polyline(color:cardinal; start, count:integer; Left, Top, Right, Bottom:integer);

    function ShowModalWindow:integer;
    procedure CloseModalWindow;
    procedure EnableWindow;
    procedure CloseModalPerform;
    procedure SetFocus;
    procedure HideKeyCursor;
    procedure ShowKeyCursor;
    procedure CreateImagePerform;
    procedure CustomImagePaint;
    procedure SetCursor;

    procedure SizePerform;virtual;
    procedure MouseMovePerform(AButtonControl:cardinal; x,y:integer);virtual;
    procedure MouseWheelPerform(AButtonControl:cardinal; deltawheel:integer; x, y:integer);virtual;
    procedure MouseLeavePerform;virtual;
    procedure MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);virtual;
    procedure MouseButtonUpPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);virtual;
    procedure MouseButtonDblDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);virtual;
    procedure KillFocusPerform(handle:HWND);virtual;
    procedure ClosePerform;virtual;
    procedure KeyCharPerform(keychar:cardinal);virtual;
    procedure CapturePerform(AWindow:HWND);virtual;

    procedure CalcTextSize(const AText:string; var AWidth, AHeight:integer);
  end;

var
  crArrow, crHand, crIBeam, crHourGlass, crSizeNS, crSizeWE : cardinal; // will be initialalized
  fntRegular,fntBold:HFONT; // will be initialalized

var MainWinForm:TWinHandleImpl;

function MessageBox(hWnd: HWND; lpText, lpCaption: PChar; uType: UINT): Integer; stdcall;
function SetDCBrushColor(DC: HDC; Color: COLORREF): COLORREF; stdcall;
function SetDCPenColor(DC: HDC; Color: COLORREF): COLORREF; stdcall;
function GetWindowLongPtr(hWnd: HWND; nIndex: Integer): pointer; stdcall;
function SetWindowLongPtr(hWnd: HWND; nIndex: Integer; dwNewLong: pointer): pointer; stdcall;

procedure InitUI;
procedure ProcessMessages;
procedure FreeUI;

function CreateBitmapMask(hbmColour:HBITMAP; crTransparent:COLORREF):HBITMAP;

implementation

{$IFDEF CPU64}
function GetWindowLongPtr; external user32 name 'GetWindowLongPtrA';
function SetWindowLongPtr; external user32 name 'SetWindowLongPtrA';
{$ELSE}
function GetWindowLongPtr; external user32 name 'GetWindowLongA';
function SetWindowLongPtr; external user32 name 'SetWindowLongA';
{$ENDIF}
function SetDCBrushColor; external gdi32 name 'SetDCBrushColor';
function SetDCPenColor; external gdi32 name 'SetDCPenColor';

function MessageBox; external user32 name 'MessageBoxA';


function MouseCustomProc(comp:TWinHandleImpl;AMessage: UINT; WParam : WPARAM; LParam: LPARAM):boolean;
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
      if(hWndUnder=0)or(comp.hWindow=hWndUnder)
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
    frm:TWinHandleImpl;
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
        if MainWinForm.hWindow <> hWindow
        then begin
          frm.Hide;
          WindowProc:=0;
          exit
        end;
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
        if MainWinForm.hWindow = hWindow
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
  comp:TWinHandleImpl;
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

function CreateBitmapMask(hbmColour:HBITMAP; crTransparent:COLORREF):HBITMAP;
var
  hdcMem, hdcMem2:HDC;
  hbmMask:HBITMAP;
  bm:BITMAP;
begin
  // Create monochrome (1 bit) mask bitmap.
  GetObject(hbmColour, sizeof(BITMAP), @bm);
  hbmMask := CreateBitmap(bm.bmWidth, bm.bmHeight, 1, 1, nil);

  // Get some HDCs that are compatible with the display driver
  hdcMem := CreateCompatibleDC(0);
  hdcMem2 := CreateCompatibleDC(0);

  SelectObject(hdcMem, hbmColour);
  SelectObject(hdcMem2, hbmMask);

  crTransparent:=GetPixel(hdcMem,0,0);

  // Set the background colour of the colour image to the colour
  // you want to be transparent.
  SetBkColor(hdcMem, crTransparent);

  // Copy the bits from the colour image to the B+W mask... everything
  // with the background colour ends up white while everythig else ends up
  // black...Just what we wanted.
  BitBlt(hdcMem2, 0, 0, bm.bmWidth, bm.bmHeight, hdcMem, 0, 0, SRCCOPY);

  // Take our new mask and use it to turn the transparent colour in our
  // original colour image to black so the transparency effect will
  // work right.
  BitBlt(hdcMem, 0, 0, bm.bmWidth, bm.bmHeight, hdcMem2, 0, 0, SRCINVERT);

  // Clean up.
  DeleteDC(hdcMem);
  DeleteDC(hdcMem2);

  result:=hbmMask;
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
  fntRegular:=CreateFont(-muldiv(12,96,72),0,0,0,FW_REGULAR,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,NONANTIALIASED_QUALITY,DEFAULT_PITCH,'Courier New');
  fntBold:=CreateFont(-muldiv(12,96,72),0,0,0,FW_BOLD,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,NONANTIALIASED_QUALITY,DEFAULT_PITCH,'Courier New');
end;

procedure DeleteFonts;
begin
  DeleteObject(fntRegular);
  DeleteObject(fntBold);
end;

procedure InitUI;
begin
  LoadCursors;
  CreateFonts;
  CustomRegister;
  if not WinRegister then begin
    MessageBox(0, 'WinRegister failed', nil, mb_Ok);
    halt(0);
  end;
end;

procedure FreeUI;
begin
  CustomUnregister;
  DeleteFonts;
end;

procedure TWinHandleImpl.CreateFormStyle;
begin
  wExStyle:=WS_EX_COMPOSITED or WS_EX_LAYERED or WS_EX_NOINHERITLAYOUT;
  wStyle:=WS_OVERLAPPEDWINDOW;
end;

procedure TWinHandleImpl.CreateModalStyle;
begin
  wExStyle:=WS_EX_COMPOSITED or WS_EX_LAYERED or WS_EX_DLGMODALFRAME;
  wStyle:=WS_BORDER or WS_POPUP or WS_SYSMENU or WS_DLGFRAME
            or WS_SIZEBOX or WS_MINIMIZEBOX or WS_MAXIMIZEBOX;
end;

procedure TWinHandleImpl.CreateFormWindow;
begin
  hWindow := CreateWindowEx(wExStyle, CUSTOM_WIN, pchar(wText), wStyle,
               hLeft, hTop, hWidth, hHeight,
               0, 0, system.MainInstance, nil);
  SetWindowLongPtr(hWindow, GWL_USERDATA, self);
end;

procedure TWinHandleImpl.CreateModalWindow;
begin
  hWindow := CreateWindowEx(wExStyle, CUSTOM_WIN, pchar(wText), wStyle,
               hLeft, hTop, hWidth, hHeight,
               wParent.hWindow, 0, system.MainInstance, nil);
  SetWindowLongPtr(hWindow, GWL_USERDATA, self);
end;

procedure TWinHandleImpl.CreateCompStyle;
begin
  wExStyle:=WS_EX_CONTROLPARENT;
  wStyle:=WS_CHILD or WS_VISIBLE;
end;

procedure TWinHandleImpl.CreatePopupStyle;
begin
  wExStyle:=WS_EX_COMPOSITED or WS_EX_LAYERED;
  wStyle:=WS_POPUP;
end;

procedure TWinHandleImpl.CreateCompWindow;
begin
  hWindow := CreateWindowEx(wExStyle, CUSTOM_COMP, nil, wStyle,
                          hLeft, hTop, hWidth, hHeight,
                          wParent.hWindow, 0, 0, nil);
  SetWindowLongPtr(hWindow, GWL_USERDATA, self);
end;

procedure TWinHandleImpl.Show(nCmdShow:integer=SW_SHOWNORMAL);
begin
  ShowWindow(hWindow, nCmdShow);
end;

procedure TWinHandleImpl.Hide;
begin
  Show(SW_HIDE)
end;

procedure TWinHandleImpl.RedrawPerform;
begin
  InvalidateRect(hWindow, nil, TRUE);
end;

procedure TWinHandleImpl.SetPosPerform;
begin
  SetWindowPos(hWindow, 0, hLeft, hTop, hWidth, hHeight, SWP_NOZORDER);
end;

procedure TWinHandleImpl.RegisterMouseLeave;
begin
  if not wTrackingMouse
  then begin
    wTrackingMouse:=true;
    hTrackMouseEvent.cbSize:=SizeOf(hTrackMouseEvent);
    hTrackMouseEvent.dwFlags:=TME_LEAVE or TME_HOVER;
    hTrackMouseEvent.hwndTrack:=hWindow;
    hTrackMouseEvent.dwHoverTime:=HOVER_DEFAULT;
    if not TrackMouseEvent(hTrackMouseEvent)
    then wTrackingMouse:=false
  end;
end;

// custompaint support

function TWinHandleImpl.GetClientRect:TRect;
begin
  windows.GetClientRect(hWindow, result)
end;

procedure TWinHandleImpl.BeginPaint;
begin
  dc:=windows.BeginPaint(hWindow, ps)
end;

procedure TWinHandleImpl.EndPaint;
begin
  windows.EndPaint(hWindow, ps)
end;

procedure TWinHandleImpl.DrawText(var r:TRect; const text:string; font:HFONT; color, bkcolor:cardinal; mode:integer; style:cardinal);
begin
  SelectObject(dc, font);
  SetTextColor(dc, color);
  SetBkColor(dc, bkcolor);
  SetBkMode(dc, mode);
  windows.DrawText(dc, pchar(text), -1, r, style);
end;

procedure TWinHandleImpl.Polygon(color, bkcolor:cardinal; Left, Top, Right, Bottom:integer);
var p : array[0..3] of tpoint;
begin
  SelectObject(dc, GetStockObject(DC_PEN));
  SetDCPenColor(dc, color);
  SelectObject(dc, GetStockObject(DC_BRUSH));
  SetDCBrushColor(dc, bkcolor);
  p[0].X:=Left;  p[0].Y:=Top;
  p[1].X:=Right; p[1].Y:=Top;
  p[2].X:=Right; p[2].Y:=Bottom;
  p[3].X:=Left;  p[3].Y:=Bottom;
  windows.Polygon(dc, p, 4);
end;

procedure TWinHandleImpl.Polyline(color:cardinal; start, count:integer; Left, Top, Right, Bottom:integer);
var p : array[-1..4] of tpoint;
begin
  SelectObject(dc, GetStockObject(DC_PEN));
  SetDCPenColor(dc, color);
  p[-1].X:=Left; p[-1].Y:=Bottom;
  p[0].X:=Left;  p[0].Y:=Top;
  p[1].X:=Right; p[1].Y:=Top;
  p[2].X:=Right; p[2].Y:=Bottom;
  p[3].X:=Left;  p[3].Y:=Bottom;
  p[4].X:=Left;  p[4].Y:=Top;
  windows.Polyline(dc, p[start], count);
end;

function TWinHandleImpl.GetCursorPos(var lpPoint: TPoint): BOOL;
begin
  result:=windows.GetCursorPos(lpPoint);
end;

function TWinHandleImpl.SetCapture(hWnd: HWND): HWND;
begin
  result:=windows.SetCapture(hWnd);
end;

function TWinHandleImpl.ReleaseCapture: BOOL;
begin
  result:=windows.ReleaseCapture;
end;

function TWinHandleImpl.ShowModalWindow:integer;
var AMessage: Msg;
    ret:longbool;
begin
//  result:=inherited ShowModal;
  wParent.wEnabled:=false;
  windows.EnableWindow(wParent.hWindow, FALSE);
  Show;
  // ProcessMessages;
  wModalResult:=MR_NONE;
  repeat
    ret:=GetMessage(AMessage, 0, 0, 0);
    if integer(ret) = -1 then break;
    TranslateMessage(AMessage);
    DispatchMessage(AMessage)
  until not ret and (wModalResult<>MR_NONE);
  result:=wModalResult
end;

procedure TWinHandleImpl.CloseModalWindow;
begin
  PostMessage(hWindow, wm_close, 0, 0);
end;

procedure TWinHandleImpl.EnableWindow;
begin
  windows.EnableWindow(hWindow, TRUE);
end;

procedure TWinHandleImpl.CloseModalPerform;
begin
  if wModalResult=MR_NONE
  then wModalResult:=MR_CLOSE;
  PostMessage(hWindow, WM_QUIT, 0, 0);
  wParent.wEnabled:=true;
  windows.EnableWindow(wParent.hWindow, TRUE);
end;

procedure TWinHandleImpl.SetFocus;
var h:HWND;
begin
  h:=GetFocus;
  if h<>0
  then SendMessage(h, WM_KILLFOCUS, 0, 0);
  windows.SetFocus(hWindow);
  SetFocusPerform;
end;

procedure TWinHandleImpl.SetFocusPerform;
begin
end;

procedure TWinHandleImpl.HideKeyCursor;
begin
  HideCaret(hWindow);
end;

procedure TWinHandleImpl.ShowKeyCursor;
begin
  HideCaret(hWindow);
  CreateCaret(hWindow, 0, 2, 17);
  SetCaretPos(KeyCursorX, KeyCursorY);
  ShowCaret(hWindow);
end;

procedure TWinHandleImpl.CreateImagePerform;
begin
  wBitmap:=LoadBitmap(system.MainInstance, 'BAD');  //todo deleteobject
  wMask:=CreateBitmapMask(wBitmap, $ffffff{clWhite});
end;

procedure TWinHandleImpl.CustomImagePaint;
var
  img : hdc;
begin
  BeginPaint;
  img:=CreateCompatibleDC(dc);

  SelectObject(img, wMask);
  BitBlt(dc,0,0,50,50,img,0,0,SRCAND);

  SelectObject(img, wBitmap);
  BitBlt(dc,0,0,50,50,img,0,0,SRCPAINT);

  DeleteDC(img);
  EndPaint;
end;

procedure TWinHandleImpl.SetCursor;
begin
  windows.SetCursor(wCursor);
end;

procedure TWinHandleImpl.CustomPaint;
begin
end;

procedure TWinHandleImpl.SizePerform;
begin
end;

procedure TWinHandleImpl.MouseMovePerform(AButtonControl:cardinal; x,y:integer);
begin
end;

procedure TWinHandleImpl.MouseWheelPerform(AButtonControl:cardinal; deltawheel:integer; x, y:integer);
begin
end;

procedure TWinHandleImpl.MouseLeavePerform;
begin
end;

procedure TWinHandleImpl.MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);
begin
end;

procedure TWinHandleImpl.MouseButtonUpPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);
begin
end;

procedure TWinHandleImpl.MouseButtonDblDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);
begin
end;

procedure TWinHandleImpl.KillFocusPerform(handle:HWND);
begin
end;

procedure TWinHandleImpl.ClosePerform;
begin
end;

procedure TWinHandleImpl.KeyCharPerform(keychar:cardinal);
begin
end;

procedure TWinHandleImpl.CapturePerform(AWindow:HWND);
begin
end;

procedure TWinHandleImpl.CalcTextSize(const AText:string; var AWidth, AHeight:integer);
var r:trect;
begin
  r.Left:=0;
  r.Top:=0;
  BeginPaint;
  DrawText(r, AText, 0, 0, 0, TRANSPARENT,  DT_SINGLELINE or DT_LEFT or DT_TOP or DT_CALCRECT);
  EndPaint;
  AWidth:=r.Right;
  AHeight:=r.Bottom;
end;

end.
