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

//    hTrackMouseEvent:TTrackMouseEvent;
    wTrackingMouse:boolean;

    wEnabled:boolean;
    wModalResult:integer;

    Win: TWindow;
    GC: TGC;
//    dc : hdc;
//    ps : paintstruct;

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
    function ReleaseCapture: BOOLEAN;
    function GetCursorPos(var lpPoint: TPoint): BOOLEAN;
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

  green:culong;

procedure InitUI;
procedure ProcessMessages;
procedure FreeUI;

implementation

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

procedure TWinHandleImpl.CreateFormStyle;
begin
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

var
//  Width, Height: Word;
//  Left, Top: Integer;
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
  FontInfo: PXFontStruct;
  DisplayName: PChar = nil;
  WindowSize: Integer = 0;
  b0,b1,b2,b3,b4:integer;

  xcolo,colorcell:TXColor;
  cmap:TColormap;

  ArrWinCount:integer=0;
  ArrWin:array[1..10000] of record
           Win:TWindow;
           Obj:TWinHandleImpl;
         end;

procedure SetWinObj(Win:TWindow; Obj:TWinHandleImpl);
begin
  inc(ArrWinCount);
  ArrWin[ArrWinCount].Win:=Win;
  ArrWin[ArrWinCount].Obj:=Obj;
end;

function GetWinObj(Win:TWindow):TWinHandleImpl;
var i:integer;
begin
  i:=1;
  while(i<=ArrWinCount) do begin
    if ArrWin[i].Win=Win
    then begin
      result:=ArrWin[i].Obj;
      exit;
    end;
    inc(i);
  end;
  result:=nil;
end;

procedure TWinHandleImpl.CreateFormWindow;
begin

  Win := XCreateSimpleWindow(Display, XRootWindow(Display, ScreenNum),
    hLeft, hTop, hWidth, hHeight, BorderWidth, XBlackPixel(Display, ScreenNum),
    XWhitePixel(Display, ScreenNum));

  SetWinObj(Win, self);

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

  XSelectInput(Display, Win, ExposureMask or KeyPressMask or ButtonPressMask or ButtonReleaseMask
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

  //Left := 100; Top := 200;
  //Width := DisplayWidth div 4;  Height := DisplayHeight div 4;
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

procedure MouseCustomProc(obj:TWinHandleImpl; _type:cint; button:cuint; x, y:cint);
var b:TMouseButton;
begin
  if(button=1)or(button=2)or(button=3)
  then begin
    if button=1
    then b:=mbLeft;
    if button=2
    then b:=mbMiddle;
    if button=3
    then b:=mbRight;
    if _type = ButtonPress
    then begin
      Obj.MouseButtonDownPerform(b, 0, x, y);
    end;
    if _type = ButtonRelease
    then begin
      Obj.MouseButtonUpPerform(b, 0, x, y);
    end;
  end;
  if (_type = ButtonPress)and(button=4)
  then begin
    Obj.MouseWheelPerform(0, 1, x, y);
  end;
  if (_type = ButtonPress)and(button=5)
  then begin
    Obj.MouseWheelPerform(0, -1, x, y);
  end;
end;

procedure ProcessMessages;
var Obj:TWinHandleImpl;
begin
  while True do
     begin
       XNextEvent(Display, @Report);
       case Report._type of
         Expose:
           begin
             Writeln('Expose');
             if Report.xexpose.count =  0
             then begin
               Obj:=GetWinObj(report.xexpose.window);
               Obj.CustomPaint;
             //  PlaceText(Obj.Win, Obj.GC, FontInfo, Obj.hWidth, Obj.hHeight);
             //  PlaceGraphics(Obj.Win, Obj.GC, Obj.hWidth, Obj.hHeight);
             end;
           end;
         ConfigureNotify:
           begin
             Writeln('Configure Notify');
             Obj:=GetWinObj(report.xconfigure.window);
             Obj.hWidth := Report.xconfigure.Width;
             Obj.hHeight := Report.xconfigure.Height;
             Obj.SizePerform;
             Writeln(' Width: ', Obj.hWidth);
             Writeln(' Height: ', Obj.hHeight);
(*             if (width <= SizeHints^.min_width) and
                (Height <= SizeHints^.min_height)
             then
               WindowSize := TOO_SMALL
             else
               WindowSize := BIG_ENOUGH;*)
           end;

         ButtonPress:
           begin
             Writeln('ButtonPress ',Report.xbutton.button,' ',Report.xbutton.window);
             Obj:=GetWinObj(report.xbutton.window);
             MouseCustomProc(Obj, Report._type, Report.xbutton.button, Report.xbutton.x, Report.xbutton.y);
           end;

         ButtonRelease:
           begin
             Writeln('ButtonRelease ',Report.xbutton.button,' ',Report.xbutton.window);
             Obj:=GetWinObj(report.xbutton.window);
             MouseCustomProc(Obj, Report._type, Report.xbutton.button, Report.xbutton.x, Report.xbutton.y);
           end;

         KeyPress:
           begin
             Writeln('KeyProcess');
             Obj:=GetWinObj(report.xkey.window);
     (*        XUnloadFont(Display, FontInfo^.fid);
             XFreeGC(Display, Obj.GC);
             XCloseDisplay(Display);
             halt(0);*)
           end;
         ClientMessage:begin
//             if Report.xclient.data.l[0] = wmDeleteMessage
  //           then begin
          //     XCloseDisplay(Display);
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
end;

procedure TWinHandleImpl.CreateCompWindow;
begin
  Win := XCreateSimpleWindow(Display, wParent.Win,
    hLeft, hTop, hWidth, hHeight, 0, XBlackPixel(Display, ScreenNum),
    XWhitePixel(Display, ScreenNum));

  SetWinObj(Win, self);

  XSelectInput(Display, Win, ExposureMask or KeyPressMask or ButtonPressMask or ButtonReleaseMask);
  GetDC(win, GC, FontInfo);
  XMapWindow(Display, Win);
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
//var r:TRect;
begin
  //r:=GetClientRect;
//  XFillRectangle(Display, win, GC, r.Left, r.Top, r.Width, r.Height);
  XClearWindow(Display, win);
  CustomPaint;
//  InvalidateRect(hWindow, nil, TRUE);
end;

procedure TWinHandleImpl.SetPosPerform;
begin
  XMoveResizeWindow(display, win, hLeft, hTop, hWidth, hHeight);
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
  result:=rect(0,0,hWidth,hHeight);
end;

procedure TWinHandleImpl.BeginPaint;
begin
end;

procedure TWinHandleImpl.EndPaint;
begin
end;

procedure TWinHandleImpl.DrawText(var r:TRect; const text:string; font:HFONT; color, bkcolor:cardinal; mode:integer; style:cardinal);
var FontHeight,Width1:integer;
    L, B:cardinal;
begin
  if (win<>0)and(GC<>nil)
  then begin
    Width1 := XTextWidth(FontInfo, pchar(text), Length(Text));
    FontHeight := FontInfo^.Ascent + FontInfo^.Descent;

    L:=r.Left;
    B:=r.Bottom;
    if (style and DT_CENTER) = DT_CENTER
    then L:=r.Left+(r.Right-r.Left) div 2-Width1 div 2;
    if (style and DT_VCENTER) = DT_VCENTER
    then B:=r.Top+(r.Bottom-r.Top) div 2+FontHeight div 2;
    XDrawString(Display, Win, GC, L, B, pchar(text), Length(Text));
  end;
end;

procedure TWinHandleImpl.Polygon(color, bkcolor:cardinal; Left, Top, Right, Bottom:integer);
begin
  if (win<>0)and(GC<>nil)
  then begin
    XDrawRectangle(Display, Win, GC, Left, Top, Right, Bottom);
  end;
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

function TWinHandleImpl.GetCursorPos(var lpPoint: TPoint): BOOLEAN;
begin
  //result:=windows.GetCursorPos(lpPoint);
end;

function TWinHandleImpl.SetCapture(hWnd: HWND): HWND;
begin
 // result:=windows.SetCapture(hWnd);
end;

function TWinHandleImpl.ReleaseCapture: BOOLEAN;
begin
 // result:=windows.ReleaseCapture;
end;

function TWinHandleImpl.ShowModalWindow:integer;
//var AMessage: Msg;
  //  ret:longbool;
begin
(*
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
  result:=wModalResult*)
end;

procedure TWinHandleImpl.CloseModalWindow;
begin
  //PostMessage(hWindow, wm_close, 0, 0);
end;

procedure TWinHandleImpl.EnableWindow;
begin
 // windows.EnableWindow(hWindow, TRUE);
end;

procedure TWinHandleImpl.CloseModalPerform;
begin
(*  if wModalResult=MR_NONE
  then wModalResult:=MR_CLOSE;
  PostMessage(hWindow, WM_QUIT, 0, 0);
  wParent.wEnabled:=true;
  windows.EnableWindow(wParent.hWindow, TRUE);*)
end;

procedure TWinHandleImpl.SetFocus;
//var h:HWND;
begin
(*  h:=GetFocus;
  if h<>0
  then SendMessage(h, WM_KILLFOCUS, 0, 0);
  windows.SetFocus(hWindow);
  SetFocusPerform;*)
end;

procedure TWinHandleImpl.SetFocusPerform;
begin
end;

procedure TWinHandleImpl.HideKeyCursor;
begin
//  HideCaret(hWindow);
end;

procedure TWinHandleImpl.ShowKeyCursor;
begin
 (* HideCaret(hWindow);
  CreateCaret(hWindow, 0, 2, 17);
  SetCaretPos(KeyCursorX, KeyCursorY);
  ShowCaret(hWindow);*)
end;

procedure TWinHandleImpl.CreateImagePerform;
begin
 // wBitmap:=LoadBitmap(system.MainInstance, 'BAD');  //todo deleteobject
 // wMask:=CreateBitmapMask(wBitmap, $ffffff{clWhite});
end;

procedure TWinHandleImpl.CustomImagePaint;
//var
  //img : hdc;
begin
 (* BeginPaint;
  img:=CreateCompatibleDC(dc);

  SelectObject(img, wMask);
  BitBlt(dc,0,0,50,50,img,0,0,SRCAND);

  SelectObject(img, wBitmap);
  BitBlt(dc,0,0,50,50,img,0,0,SRCPAINT);

  DeleteDC(img);
  EndPaint;  *)
end;

procedure TWinHandleImpl.SetCursor;
begin
  //windows.SetCursor(wCursor);
end;

procedure TWinHandleImpl.CreateModalStyle;
begin
(*
wExStyle:=WS_EX_COMPOSITED or WS_EX_LAYERED or WS_EX_DLGMODALFRAME;
  wStyle:=WS_BORDER or WS_POPUP or WS_SYSMENU or WS_DLGFRAME
            or WS_SIZEBOX or WS_MINIMIZEBOX or WS_MAXIMIZEBOX;
*)
end;

procedure TWinHandleImpl.CreateModalWindow;
begin
  Win := XCreateSimpleWindow(Display, XRootWindow(Display, ScreenNum),
    hLeft, hTop, hWidth, hHeight, 0, XBlackPixel(Display, ScreenNum),
    XWhitePixel(Display, ScreenNum));

  SetWinObj(Win, self);

  XStoreName(Display, Win, pchar('Modal'));
  XSetTransientForHint(display, win, MainWinForm.win);
  XSelectInput(Display, Win, ExposureMask or KeyPressMask or ButtonPressMask or ButtonReleaseMask);
  GetDC(win, GC, FontInfo);
  XMapWindow(Display, Win);
(*
hWindow := CreateWindowEx(wExStyle, CUSTOM_WIN, pchar(wText), wStyle,
               hLeft, hTop, hWidth, hHeight,
               wParent.hWindow, 0, system.MainInstance, nil);
  SetWindowLongPtr(hWindow, GWL_USERDATA, self);
*)
end;

procedure TWinHandleImpl.CreatePopupStyle;
begin
//  wExStyle:=WS_EX_COMPOSITED or WS_EX_LAYERED;
//  wStyle:=WS_POPUP;
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
begin
  AWidth := XTextWidth(FontInfo, pchar(AText), Length(AText));
  AHeight := FontInfo^.Ascent + FontInfo^.Descent;
end;

end.
