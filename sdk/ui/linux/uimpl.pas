unit uimpl;

interface

uses types, ctypes, sysutils, xlib, x, xutil;

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

  green:culong;

//function MessageBox(hWnd: HWND; lpText, lpCaption: PChar; uType: UINT): Integer; stdcall;
//function SetDCBrushColor(DC: HDC; Color: COLORREF): COLORREF; stdcall;
//function SetDCPenColor(DC: HDC; Color: COLORREF): COLORREF; stdcall;
//function GetWindowLongPtr(hWnd: HWND; nIndex: Integer): pointer; stdcall;
//function SetWindowLongPtr(hWnd: HWND; nIndex: Integer; dwNewLong: pointer): pointer; stdcall;

procedure InitUI;
procedure ProcessMessages;
procedure FreeUI;

implementation


procedure TWinHandleImpl.CreateFormStyle;
begin
//  wExStyle:=WS_EX_COMPOSITED or WS_EX_LAYERED or WS_EX_NOINHERITLAYOUT;
//  wStyle:=WS_OVERLAPPEDWINDOW;
end;

const
  IconBitmapWidth = 16;
  IconBitmapHeight = 16;

   IconBitmapBits: packed array[1..32] of Byte = ($1f, $f8, $1f, $88, $1f, $88, $1f, $88, $1f, $88, $1f, $f8,
   $1f, $f8, $1f, $f8, $1f, $f8, $1f, $f8, $1f, $f8, $ff, $ff,
   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff);


  BITMAPDEPTH = 1;
  TOO_SMALL = 0;
  BIG_ENOUGH = 1;

var
  Display: PDisplay;
  ScreenNum: Integer;
  ProgName: String;

procedure CheckMemory(P: Pointer);
begin
  if P = nil then
    begin
      Writeln(ProgName,': Failure Allocating Memory');
      Halt(0);
    end;
end;

procedure GetDC(Win: TWindow;var GC: TGC; FontInfo: PXFontStruct);
const
  DashList: packed array[1..2] of Byte = (12, 24);
var
  ValueMask: Cardinal;
  Values: TXGCValues;
  LineWidth: Cardinal;
  LineStyle: Integer;
  CapStyle: Integer;
  JoinStyle: Integer;
  DashOffset: Integer;
  ListLength: Integer;
begin
  ValueMask := 0;
  LineWidth := 1;
  LineStyle := LineSolid; //LineOnOffDash;
  CapStyle := CapRound;
  JoinStyle := JoinRound;
  DashOffset := 0;
  ListLength := 2;

  FillChar(Values, SizeOf(Values), 0);
  GC :=  XCreateGC(Display, Win, ValueMask, @Values);
  XSetFont(Display, GC, FontInfo^.fid);
  XSetForeground(Display, GC, green);//XBlackPixel(Display, ScreenNum));
  XSetLineAttributes(Display, GC, LineWidth, LineStyle, CapStyle, JoinStyle);
  XSetDashes(Display, GC, DashOffSet, @DashList, ListLength);
end;

procedure LoadFont(var FontInfo: PXFontStruct);
const
  FontName: PChar = '9x18';
begin
  Writeln('Font Struct:', SizeOf(TXFontStruct));
  FontInfo := XLoadQueryFont(Display, FontName);
  if FontInfo = nil then
    begin
      Writeln(Progname, ': Cannot open '+FontName+' font.');
      Halt(1);
    end;
end;

procedure PlaceText(Win: TWindow; GC: TGC; FontInfo: PXFontStruct;
  WinWidth, WinHeight: Cardinal);
const
  String1: PChar = 'Hi! I''m a window, who are you?';
  String2: PChar = 'To terminate program; Press any key';
  String3: PChar = 'or button while in this window.';
  String4: PChar = 'Screen dimensions:';

var
  Len1, Len2, Len3, Len4: Integer;
  Width1, Width2, Width3: Integer;
  CDHeight, CDWidth, CDDepth: PChar; // array[0..49] of Char;
  FontHeight: Integer;
  InitialYOffset, XOffset: Integer;
  Top, Left: Integer;

begin
Writeln('#1');
  Len1 := StrLen(String1);
  Len2 := StrLen(String2);
  Len3 := StrLen(String3);

Writeln('#2');
  Width1 := XTextWidth(FontInfo, String1, Len1);
  Width2 := XTextWidth(FontInfo, String2, Len2);
  Width3 := XTextWidth(FontInfo, String3, Len3);

  FontHeight := FontInfo^.Ascent + FontInfo^.Descent;
  XDrawString(Display, Win, GC, (WinWidth - Width1) div 2, FontHeight+10, String1,
    Len1);
Writeln('#2.2 ', Len2, ' ', String2);
  Left := (WinWidth - Width2);
Writeln('#2.2.5 Here');
  Left := Left div 2;
  Top := WinHeight - FontHeight * 2;
Writeln('#2.3  Top:', Top, ' Left:', Left);
  XDrawString(Display, Win, GC, Left, Top, String2, Len2);
Writeln('#2.3');
  XDrawString(Display, Win, GC, (WinWidth - Width3) div 2,
    WinHeight - FontHeight, String3, Len3);

Writeln('#3');
  CDHeight := PChar(Format(' Height = %d pixels', [XDisplayHeight(Display,
    ScreenNum)]));
  CDWidth := PChar(Format(' Width = %d pixels', [XDisplayWidth(Display,
    ScreenNum)]));
  CDDepth := PChar(Format(' Depth = %d plane(s)', [XDefaultDepth(Display,
    ScreenNum)]));

  Len4 := StrLen(String4);
  Len1 := StrLen(CDHeight);
  Len2 := StrLen(CDWidth);
  Len3 := StrLen(CDDepth);

Writeln('#4');
  InitialYOffset := WinHeight div 2 - FontHeight - FontInfo^.descent;
  XOffset := WinWidth div 4;

  XDrawString(Display, Win, GC, XOffset, InitialYOffset, String4, Len4);
  XDrawString(Display, Win, GC, XOffset, InitialYOffset + FontHeight,
    CDHeight, Len1);
  XDrawString(Display, Win, GC, XOffset, InitialYOffset + 2 * FontHeight,
    CDWidth, Len2);
  XDrawString(Display, Win, GC, XOffset, InitialYOffset + 3 * FontHeight,
    CDDepth, Len3);
Writeln('#5');
end;

procedure PlaceGraphics(Win: TWindow; GC: TGC;
  WindowWidth, WindowHeight: Cardinal);
var
  X, Y: Integer;
  Width, Height: Integer;
begin
  Writeln('Window: ', Integer(Win));
  Writeln('GC: ', INteger(GC));
  Height := WindowHeight div 2;
  Width := 3 * WindowWidth div 4;
  X := WindowWidth div 2 - Width div 2;
  Y := WindowHeight div 2 - Height div 2;
  //XDrawRectangle(Display, Win, GC, X, Y, Width, Height);
  XDrawRectangle(Display, Win, GC, 0, 0, WindowWidth-1, WindowHeight-1);
end;

procedure TooSmall(Win: TWindow; GC: TGC; FontInfo: PXFontStruct);
const
  String1: PChar = 'Too Small';
var
  YOffset, XOffset: Integer;
begin
  YOffset := FontInfo^.Ascent + 10;
  XOffset := 10;

  XDrawString(Display, Win, GC, XOffset, YOffset, String1, StrLen(String1));
end;

var
  Win: TWindow;
  Width, Height: Word;
  Left, Top: Integer;
  BorderWidth: Word = 4;
  DisplayWidth, DisplayHeight: Word;
//  IconWidth, IconHeight: Word;
  WindowNameStr: PChar = 'Basic Window Program';
  IconNameStr: PChar = 'basicWin';
  IconPixmap: TPixmap;
  SizeHints: PXSizeHints;
  SizeList: PXIconSize;
  WMHints: PXWMHints;
  ClassHints: PXClassHint;
  WindowName, IconName: TXTextProperty;
  Count: Integer;
  Report: TXEvent;
  GC: TGC;
  FontInfo: PXFontStruct;
  DisplayName: PChar = nil;
  WindowSize: Integer = 0;
  b0,b1,b2,b3,b4:integer;

  xcolo,colorcell:TXColor;
  cmap:TColormap;

procedure TWinHandleImpl.CreateFormWindow;
begin

  Win := XCreateSimpleWindow(Display, XRootWindow(Display, ScreenNum),
    Left, Top, Width, Height, BorderWidth, XBlackPixel(Display, ScreenNum),
    XWhitePixel(Display, ScreenNum));

  IconPixMap := XCreateBitmapFromData(Display, XRootWindow(Display, ScreenNum), @IconBitmapBits,
    IconBitmapWidth, IconBitmapHeight);

  //IconPixMap:=XCreatePixmap(Display, Win, 16, 16, 8);
  //b0:=16; b1:=16;
  //b4:=XReadBitmapFile(Display, XRootWindow(Display, ScreenNum), pchar('bad.bmp'), @b0, @b1, @IconPixMap, @b2, @b3);

  SizeHints^.flags := PPosition or PSize or PMinSize;
  SizeHints^.min_width := 400;
  SizeHints^.min_height:= 300;

  if XStringListToTextProperty(@WindowNameStr, 1, @WindowName) = 0 then
    begin
      Writeln(Progname, ': structure allocation for window name failed.');
      Halt(1);
    end;

  if XStringListToTextProperty(@IconNameStr, 1, @IconName) = 0 then
    begin
      Writeln(Progname, ': structure allocqation for icon name failed.');
      Halt(1);
    end;


  WMHints^.flags := StateHint or InputHint or IconWindowHint;
  WMHints^.initial_state := NormalState;
  WMHints^.input := 1; //True;
  //WMHints^.icon_pixmap := IconPixmap;
  WMHints^.icon_window := IconPixmap;
  WMHints^.icon_x:=0;
  WMHints^.icon_y:=0;
  ClassHints^.res_name := PChar(ProgName);
  ClassHints^.res_class := 'BasicWin!';

  XSetWMProperties(Display, Win, @WindowName, @IconName, nil, 0, SizeHints,
    WMHints, ClassHints);

  XSelectInput(Display, Win, ExposureMask or KeyPressMask or ButtonPressMask
    or StructureNotifyMask);

  LoadFont(FontInfo);

  GetDC(win, GC, FontInfo);

  XMapWindow(Display, Win);
end;

procedure InitUI;
begin
  ProgName := ParamStr(0);
//  ProgName := 'BasicWin';  //JJS Remove when 80999 is fixed.
  SizeHints := XAllocSizeHints;
  CheckMemory(SizeHints);

  WMHints := XAllocWMHints;
  CheckMemory(WMHints);

  ClassHints := XAllocClassHint;
  CheckMemory(ClassHints);

  Display := XOpenDisplay(DisplayName);
  if Display = nil then
    begin
      Writeln(ProgName,': cannot connect to XServer',
        XDisplayName(DisplayName));
      Halt(1);
    end;

  ScreenNum := XDefaultScreen(Display);
  DisplayWidth := XDisplayWidth(Display, ScreenNum);
  DisplayHeight := XDisplayHeight(Display, ScreenNum);

  Left := 100; Top := 200;
  Width := DisplayWidth div 4;  Height := DisplayHeight div 4;
  if XGetIconSizes(Display, XRootWindow(Display, ScreenNum), @SizeList,
    @Count) = 0
  then
    Writeln('Window Manager didn''t set icon sizes - using default')
  else
    begin
    end;

  cmap:=DefaultColormap(Display, ScreenNum);
  XAllocNamedColor(display,cmap,'salmon',@colorcell,@xcolo);
  XAllocNamedColor(display,cmap,'wheat',@colorcell,@xcolo);
  XAllocNamedColor(display,cmap,'red',@colorcell,@xcolo);
  XAllocNamedColor(display,cmap,'blue',@colorcell,@xcolo);
  green:=colorcell.pixel;
  XAllocNamedColor(display,cmap,'green',@colorcell,@xcolo);
  XAllocNamedColor(display,cmap,'cyan',@colorcell,@xcolo);
  XAllocNamedColor(display,cmap,'orange',@colorcell,@xcolo);
  XAllocNamedColor(display,cmap,'purple',@colorcell,@xcolo);
  XAllocNamedColor(display,cmap,'yellow',@colorcell,@xcolo);
  XAllocNamedColor(display,cmap,'pink',@colorcell,@xcolo);
  XAllocNamedColor(display,cmap,'brown',@colorcell,@xcolo);
  XAllocNamedColor(display,cmap,'grey',@colorcell,@xcolo);
  XAllocNamedColor(display,cmap,'turquoise',@colorcell,@xcolo);
  XAllocNamedColor(display,cmap,'gold',@colorcell,@xcolo);
  XAllocNamedColor(display,cmap,'magenta',@colorcell,@xcolo);
  XAllocNamedColor(display,cmap,'navy',@colorcell,@xcolo);
  XAllocNamedColor(display,cmap,'tan',@colorcell,@xcolo);
  XAllocNamedColor(display,cmap,'violet',@colorcell,@xcolo);
  XAllocNamedColor(display,cmap,'white',@colorcell,@xcolo);
  XAllocNamedColor(display,cmap,'black',@colorcell,@xcolo);
end;

procedure ProcessMessages;
begin
  while True do
     begin
       XNextEvent(Display, @Report);
       case Report._type of
         Expose:
           begin
             Writeln('Expose');
             if Report.xexpose.count =  0 then
               begin
                 if WindowSize = TOO_SMALL then
                    TooSmall(Win, GC, FontInfo)
                 else
                   begin
                     PlaceText(Win, GC, FontInfo, Width, Height); //*** Fails
                     PlaceGraphics(Win, GC, Width, Height);
                   end;
               end;
           end;
         ConfigureNotify:
           begin
             Writeln('Configure Notify');
             Width := Report.xconfigure.Width;
             Height := Report.xconfigure.Height;
             Writeln(' Width: ', Width);
             Writeln(' Height: ', Height);
             if (width <= SizeHints^.min_width) and
                (Height <= SizeHints^.min_height)
             then
               WindowSize := TOO_SMALL
             else
               WindowSize := BIG_ENOUGH;
           end;

         ButtonPress:
           begin
             Writeln('ButtonPress');
           end;

         KeyPress:
           begin
             Writeln('KeyProcess');
             XUnloadFont(Display, FontInfo^.fid);
             XFreeGC(Display, GC);
             XCloseDisplay(Display);
             halt(0);
           end;
         ClientMessage:begin
//             if Report.xclient.data.l[0] = wmDeleteMessage
  //           then begin
               XCloseDisplay(Display);
    //         end;
         end
       else
       end;

     end;

   Writeln('End.');
end;

procedure FreeUI;
begin
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
