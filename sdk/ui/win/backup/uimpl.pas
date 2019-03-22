unit uimpl;

interface

uses Types, Windows, SysUtils;

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

type

  TPoint = Types.TPoint;
  TRect = Types.TRect;

  TMouseButton = (mbLeft, mbMiddle, mbRight, mbX1, mbX2);

  HWND  = type LongWord;
  HFONT = type LongWord;
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

    hTrackMouseEvent:TTrackMouseEvent;
    wTrackingMouse:boolean;

    dc : hdc;
    ps : paintstruct;

    procedure CreateFormStyle;
    procedure CreateFormWindow;

    procedure CreateCompStyle;
    procedure CreateCompWindow;

    procedure RegisterMouseLeave;
  public
    procedure Show(nCmdShow:integer = SW_SHOWNORMAL);virtual;
    procedure Hide;virtual;
    procedure RedrawPerform;
    procedure SetPosPerform;

    function GetClientRect:TRect;
    procedure BeginPaint;
    procedure EndPaint;
    procedure DrawText(var r:TRect; const text:string; font:HFONT; color, bkcolor:cardinal; mode:integer; style:cardinal);
    procedure Polygon(color, bkcolor:cardinal; Left, Top, Right, Bottom:integer);
    procedure Polyline(color:cardinal; start, count:integer; Left, Top, Right, Bottom:integer);

  end;

var
  crArrow, crHand, crIBeam, crHourGlass, crSizeNS, crSizeWE : cardinal; // will be initialalized
  fntRegular,fntBold:HFONT; // will be initialalized


function MessageBox(hWnd: HWND; lpText, lpCaption: PChar; uType: UINT): Integer; stdcall;
function SetDCBrushColor(DC: HDC; Color: COLORREF): COLORREF; stdcall;
function SetDCPenColor(DC: HDC; Color: COLORREF): COLORREF; stdcall;
function GetWindowLongPtr(hWnd: HWND; nIndex: Integer): pointer; stdcall;
function SetWindowLongPtr(hWnd: HWND; nIndex: Integer; dwNewLong: pointer): pointer; stdcall;

procedure InitUI;
procedure ProcessMessages;
procedure FreeUI;

implementation

uses uihandle;

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
        if MainWinForm.Window <> hWindow
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

procedure TWinHandleImpl.CreateFormWindow;
begin
  hWindow := CreateWindowEx(wExStyle, CUSTOM_WIN, pchar(wText), wStyle,
               hLeft, hTop, hWidth, hHeight,
               0, 0, system.MainInstance, nil);
  SetWindowLongPtr(hWindow, GWL_USERDATA, self);
end;

procedure TWinHandleImpl.CreateCompStyle;
begin
  wExStyle:=WS_EX_CONTROLPARENT;
  wStyle:=WS_CHILD or WS_VISIBLE;
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

end.
