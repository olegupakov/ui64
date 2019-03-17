unit uimpl;

interface

uses types, sysutils, xlib, x, xutil;

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
    Win: TWindow;
    hWindow:HWnd;
    wParent:TWinHandleImpl;
    wStyle,wExStyle:cardinal;

    wText:string;
    hLeft, hTop, hWidth, hHeight : integer;

//    hTrackMouseEvent:TTrackMouseEvent;
    wTrackingMouse:boolean;

//    dc : hdc;
//    ps : paintstruct;

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


//function MessageBox(hWnd: HWND; lpText, lpCaption: PChar; uType: UINT): Integer; stdcall;
//function SetDCBrushColor(DC: HDC; Color: COLORREF): COLORREF; stdcall;
//function SetDCPenColor(DC: HDC; Color: COLORREF): COLORREF; stdcall;
//function GetWindowLongPtr(hWnd: HWND; nIndex: Integer): pointer; stdcall;
//function SetWindowLongPtr(hWnd: HWND; nIndex: Integer; dwNewLong: pointer): pointer; stdcall;

procedure InitUI;
procedure ProcessMessages;
procedure FreeUI;

implementation

uses uihandle;

{$IFDEF CPU64}
//function GetWindowLongPtr; external user32 name 'GetWindowLongPtrA';
//function SetWindowLongPtr; external user32 name 'SetWindowLongPtrA';
{$ELSE}
//function GetWindowLongPtr; external user32 name 'GetWindowLongA';
//function SetWindowLongPtr; external user32 name 'SetWindowLongA';
{$ENDIF}
//function SetDCBrushColor; external gdi32 name 'SetDCBrushColor';
//function SetDCPenColor; external gdi32 name 'SetDCPenColor';

//function MessageBox; external user32 name 'MessageBoxA';


var
  Display: PDisplay;
  ScreenNum: Integer;
  DisplayWidth, DisplayHeight: Word;

  Report: TXEvent;

procedure InitUI;
begin
  Display := XOpenDisplay(nil);
  ScreenNum := XDefaultScreen(Display);
  DisplayWidth := XDisplayWidth(Display, ScreenNum);
  DisplayHeight := XDisplayHeight(Display, ScreenNum);

(*
Win := XCreateSimpleWindow(Display, XRootWindow(Display, ScreenNum),
    50{hLeft}, 50{hTop}, 300{hWidth}, 400{hHeight}, 4{BorderWidth}, XBlackPixel(Display, ScreenNum),
    XWhitePixel(Display, ScreenNum));
*)

//  XMapWindow(Display, Win);
end;

procedure ProcessMessages;
begin
  while True do begin
    XNextEvent(Display, @Report);
  end;
end;

procedure FreeUI;
begin
  XCloseDisplay(Display);
end;

procedure TWinHandleImpl.CreateFormStyle;
begin
//  wExStyle:=WS_EX_COMPOSITED or WS_EX_LAYERED or WS_EX_NOINHERITLAYOUT;
//  wStyle:=WS_OVERLAPPEDWINDOW;
end;

const
  IconBitmapWidth = 20;
  IconBitmapHeight = 20;

   IconBitmapBits: packed array[1..60] of Byte = (
   $60, $00, $01, $b0, $00, $07, $0c, $03, $00, $04, $04, $00,
   $c2, $18, $00, $03, $30, $00, $01, $60, $00, $f1, $df, $00,
   $c1, $f0, $01, $82, $01, $00, $02, $03, $00, $02, $0c, $00,
   $02, $38, $00, $04, $60, $00, $04, $e0, $00, $04, $38, $00,
   $84, $06, $00, $14, $14, $00, $0c, $34, $00, $00, $00, $00
);

var
   IconPixmap: TPixmap;
   SizeHints: PXSizeHints;
   SizeList: PXIconSize;
   WMHints: PXWMHints;
   ClassHints: PXClassHint;
   Count: Integer;

procedure TWinHandleImpl.CreateFormWindow;
var
   WindowName, IconName: TXTextProperty;
   AppName:pchar='app';
begin
  Win := XCreateSimpleWindow(Display, XRootWindow(Display, ScreenNum),
    hLeft, hTop, hWidth, hHeight, 4{BorderWidth}, XBlackPixel(Display, ScreenNum),
    XWhitePixel(Display, ScreenNum));

//  XStoreName(Display, Win, pchar(wText));
//  XSetIconName(Display, Win, pchar(Appname));
//  XStringListToTextProperty(@AppName, 1, @title_property);
//  XSetWMIconName(Display, Win, @title_property);

  IconPixMap := XCreateBitmapFromData(Display, Win, @IconBitmapBits,
    IconBitmapWidth, IconBitmapHeight);

  SizeList:=XAllocIconSize;

  XGetIconSizes(Display, XRootWindow(Display, ScreenNum), @SizeList, @Count);

  SizeHints := XAllocSizeHints;
  WMHints := XAllocWMHints;
  ClassHints := XAllocClassHint;

  SizeHints^.flags := PPosition or PSize or PMinSize;
  SizeHints^.min_width := 200;
  SizeHints^.min_height:= 100;

//  WMHints^.initial_state := NormalState;
//  WMHints^.input := 1; //True;
//  WMHints^.icon_pixmap := IconPixmap;
  WMHints^.flags := StateHint or IconPixmapHint;// or InputHint;

  WMHints^.initial_state := IconicState or NormalState;
  WMHints^.icon_pixmap := IconPixmap;
  WMHints^.icon_x:=0;
  WMHints^.icon_y:=0;

//  XSetWMHints(display, win, @WMHints);

  ClassHints^.res_name := PChar('appname');
  ClassHints^.res_class := pchar(paramstr(0));

  XStringListToTextProperty(@wText, 1, @WindowName);
  XStringListToTextProperty(@AppName, 1, @IconName);
  XSetWMProperties(Display, Win, @WindowName, @IconName, nil, 0, SizeHints,
    WMHints, ClassHints);

  XMapWindow(Display, Win);
(*
hWindow := CreateWindowEx(wExStyle, CUSTOM_WIN, pchar(wText), wStyle,
               hLeft, hTop, hWidth, hHeight,
               0, 0, system.MainInstance, nil);
  SetWindowLongPtr(hWindow, GWL_USERDATA, self);
*)
end;

procedure TWinHandleImpl.CreateCompStyle;
begin
//  wExStyle:=WS_EX_CONTROLPARENT;
//  wStyle:=WS_CHILD or WS_VISIBLE;
end;

procedure TWinHandleImpl.CreateCompWindow;
begin
(*
hWindow := CreateWindowEx(wExStyle, CUSTOM_COMP, nil, wStyle,
                          hLeft, hTop, hWidth, hHeight,
                          wParent.hWindow, 0, 0, nil);
  SetWindowLongPtr(hWindow, GWL_USERDATA, self);
*)
end;

procedure TWinHandleImpl.Show(nCmdShow:integer=SW_SHOWNORMAL);
begin
//  ShowWindow(hWindow, nCmdShow);
end;

procedure TWinHandleImpl.Hide;
begin
//  Show(SW_HIDE)
end;

procedure TWinHandleImpl.RedrawPerform;
begin
//  InvalidateRect(hWindow, nil, TRUE);
end;

procedure TWinHandleImpl.SetPosPerform;
begin
//  SetWindowPos(hWindow, 0, hLeft, hTop, hWidth, hHeight, SWP_NOZORDER);
end;

procedure TWinHandleImpl.RegisterMouseLeave;
begin
(*  if not wTrackingMouse
  then begin
    wTrackingMouse:=true;
    hTrackMouseEvent.cbSize:=SizeOf(hTrackMouseEvent);
    hTrackMouseEvent.dwFlags:=TME_LEAVE or TME_HOVER;
    hTrackMouseEvent.hwndTrack:=hWindow;
    hTrackMouseEvent.dwHoverTime:=HOVER_DEFAULT;
    if not TrackMouseEvent(hTrackMouseEvent)
    then wTrackingMouse:=false
  end;
*)
end;

// custompaint support

function TWinHandleImpl.GetClientRect:TRect;
begin
//  windows.GetClientRect(hWindow, result)
end;

procedure TWinHandleImpl.BeginPaint;
begin
//  dc:=windows.BeginPaint(hWindow, ps)
end;

procedure TWinHandleImpl.EndPaint;
begin
//  windows.EndPaint(hWindow, ps)
end;

procedure TWinHandleImpl.DrawText(var r:TRect; const text:string; font:HFONT; color, bkcolor:cardinal; mode:integer; style:cardinal);
begin
(*
SelectObject(dc, font);
  SetTextColor(dc, color);
  SetBkColor(dc, bkcolor);
  SetBkMode(dc, mode);
  windows.DrawText(dc, pchar(text), -1, r, style);
*)
end;

procedure TWinHandleImpl.Polygon(color, bkcolor:cardinal; Left, Top, Right, Bottom:integer);
//var p : array[0..3] of tpoint;
begin
(*
SelectObject(dc, GetStockObject(DC_PEN));
  SetDCPenColor(dc, color);
  SelectObject(dc, GetStockObject(DC_BRUSH));
  SetDCBrushColor(dc, bkcolor);
  p[0].X:=Left;  p[0].Y:=Top;
  p[1].X:=Right; p[1].Y:=Top;
  p[2].X:=Right; p[2].Y:=Bottom;
  p[3].X:=Left;  p[3].Y:=Bottom;
  windows.Polygon(dc, p, 4);
*)
end;

procedure TWinHandleImpl.Polyline(color:cardinal; start, count:integer; Left, Top, Right, Bottom:integer);
//var p : array[-1..4] of tpoint;
begin
(*
SelectObject(dc, GetStockObject(DC_PEN));
  SetDCPenColor(dc, color);
  p[-1].X:=Left; p[-1].Y:=Bottom;
  p[0].X:=Left;  p[0].Y:=Top;
  p[1].X:=Right; p[1].Y:=Top;
  p[2].X:=Right; p[2].Y:=Bottom;
  p[3].X:=Left;  p[3].Y:=Bottom;
  p[4].X:=Left;  p[4].Y:=Top;
  windows.Polyline(dc, p[start], count);
*)
end;

end.
