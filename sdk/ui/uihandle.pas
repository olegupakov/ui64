unit uihandle;

interface

uses windows, messages, ui, datastorage;

type

  TWinHandle=class;

  TWinHandleEvent=procedure(Sender:TWinHandle) of object;

  TWinHandle=class
  private
    hTrackMouseEvent:TTrackMouseEvent;
    wTrackingMouse:boolean;

  protected
    wStyle,wExStyle:cardinal;

    // mouse
    wMouseDown:boolean;
    wMouseOverComponent:boolean;

    hWindow:HWnd;
    hLeft, hTop, hWidth, hHeight : integer;
    wName:string;
    wMinHeight:integer;

    wAlign:TAlign;
    wParent:TWinHandle;
    wText:string;
    wColor:cardinal;
    wCursor:cardinal;
    wEnabled:boolean;

    wChildHandleList:TListEx;

    fOnClick:TWinHandleEvent;

    procedure SetParent(AParent:TWinHandle);
    procedure RegisterMouseLeave;
  public
    constructor Create(Owner:TWinHandle);virtual;

    procedure Show(nCmdShow:integer = SW_SHOWNORMAL);virtual;
    function  ShowModal:integer;virtual;
    procedure Hide;virtual;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight : integer);
    procedure SetFocus;virtual;
    procedure CreatePerform;virtual;abstract;
    procedure SizePerform;virtual;
    procedure RedrawPerform;
    procedure SetPosPerform;
    procedure CustomPaint;virtual;
    procedure MouseMovePerform(AButtonControl:cardinal; x,y:integer);virtual;
    procedure MouseWheelPerform(AButtonControl:cardinal; deltawheel:integer; x, y:integer);virtual;
    procedure MouseLeavePerform;virtual;
    procedure MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);virtual;
    procedure MouseButtonUpPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);virtual;
    procedure MouseButtonDblDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);virtual;
    procedure SetFocusPerform;virtual;
    procedure KillFocusPerform;virtual;
    procedure ClosePerform;virtual;
    procedure CapturePerform(AWindow:HWND);virtual;
    procedure KeyCharPerform(keychar:cardinal);virtual;
    procedure CalcTextSize(const AText:string; var AWidth, AHeight:integer);

    property Parent:TWinHandle read wParent write SetParent;
    property Window:HWnd read hWindow;
    property Align:TAlign read wAlign write wAlign;
    property Left:integer read hLeft write hLeft;
    property Top:integer read hTop write hTop;
    property Width:integer read hWidth write hWidth;
    property Height:integer read hHeight write hHeight;
    property MinHeight:integer read wMinHeight write wMinHeight;
    property Color:cardinal read wColor write wColor;
    property Cursor:cardinal read wCursor write wCursor;
    property Text:string read wText write wText;
    property Name:string read wName write wName;
    property Style:cardinal read wStyle write wStyle;
    property ExStyle:cardinal read wExStyle write wExStyle;
    property Enabled:boolean read wEnabled write wEnabled;
    property ChildHandleList:TListEx read wChildHandleList write wChildHandleList;
    // event
    property OnClick:TWinHandleEvent read fOnClick write fOnClick;
  end;

function CreateMainWindow(AMainWinForm:TWinHandle; AText:string):TWinHandle;

var MainWinForm:TWinHandle;
    //KeyboardLanguage:cardinal;

implementation

function CreateMainWindow(AMainWinForm:TWinHandle; AText:string):TWinHandle;
begin
  MainWinForm:=AMainWinForm;
  MainWinForm.Text:=AText;
  MainWinForm.Parent := nil;
  MainWinForm.CreatePerform;
  if MainWinForm.Window = 0 then begin
    MessageBox(0, 'WinCreate failed', nil, mb_Ok);
    halt(0);
  end;
  result:=MainWinForm;
end;

procedure TWinHandle.Show(nCmdShow:integer=SW_SHOWNORMAL);
begin
  ShowWindow(hWindow, nCmdShow);
end;

procedure TWinHandle.Hide;
begin
  Show(SW_HIDE)
end;

function TWinHandle.ShowModal:integer;
begin
  result:=MR_CLOSE
end;

procedure TWinHandle.CustomPaint;
begin
end;

procedure TWinHandle.RedrawPerform;
begin
  InvalidateRect(hWindow, nil, TRUE);
end;

procedure TWinHandle.SetPosPerform;
begin
  SetWindowPos(hWindow, 0, hLeft, hTop, hWidth, hHeight, SWP_NOZORDER);
end;

procedure TWinHandle.SetParent(AParent:TWinHandle);
begin
  wParent:=AParent;
  if AParent<>nil
  then begin
    if AParent.ChildHandleList=nil
    then AParent.ChildHandleList:=TListEx.Create;
    AParent.ChildHandleList.Add(self);
  end;
end;

procedure TWinHandle.SizePerform;
var i:integer;
    r : trect;
    comp:TWinHandle;
begin
  if ChildHandleList=nil then exit;
  //
  GetClientRect(hWindow, r);
  // none
  for i:=0 to ChildHandleList.Count-1 do begin
    comp:=TWinHandle(ChildHandleList[i]);
    if comp.Align=alNone
    then begin
       comp.SizePerform;
    end;
  end;
  // top
  for i:=0 to ChildHandleList.Count-1 do begin
    comp:=TWinHandle(ChildHandleList[i]);
    if comp.Align=alTop
    then begin
       comp.SetBounds(r.Left, r.Top, r.Right-r.Left, comp.Height);
       comp.SetPosPerform;
       comp.SizePerform;
       r.Top:=r.Top+comp.height
    end;
  end;
  // bottom
  for i:=ChildHandleList.Count-1 downto 0 do begin
    comp:=TWinHandle(ChildHandleList[i]);
    if comp.Align=alBottom
    then begin
       comp.SetBounds(r.Left, r.Bottom-comp.hHeight, r.Right-r.Left, comp.Height);
       comp.SetPosPerform;
       comp.SizePerform;
       r.Bottom:=r.Bottom-comp.height
    end;
  end;
  // left
  for i:=0 to ChildHandleList.Count-1 do begin
    comp:=TWinHandle(ChildHandleList[i]);
    if comp.Align=alLeft
    then begin
       comp.SetBounds(r.Left, r.Top, comp.Width, r.Bottom-r.Top);
       comp.SetPosPerform;
       comp.SizePerform;
       r.Left:=r.Left+comp.Width
    end;
  end;
  // right
  for i:=ChildHandleList.Count-1 downto 0 do begin
    comp:=TWinHandle(ChildHandleList[i]);
    if comp.Align=alRight
    then begin
       comp.SetBounds(r.Right-comp.Width, r.Top, comp.Width, r.Bottom-r.Top);
       comp.SetPosPerform;
       comp.SizePerform;
       r.Right:=r.Right-comp.Width
    end;
  end;
  // client
  for i:=ChildHandleList.Count-1 downto 0 do begin
    comp:=TWinHandle(ChildHandleList[i]);
    if comp.Align=alClient
    then begin
       comp.SetBounds(r.Left, r.Top, r.Right-r.Left, r.Bottom-r.Top);
       comp.SetPosPerform;
       comp.SizePerform;
       r.Left:=r.Right;
       r.Top:=r.Bottom
    end;
  end;
end;

procedure TWinHandle.CalcTextSize(const AText:string; var AWidth, AHeight:integer);
var
  dc : hdc;
  ps : paintstruct;
  r : trect;
begin
  r.Left:=0;
  r.Top:=0;
  dc := BeginPaint(hWindow, ps);
  DrawText(dc, pchar(AText), -1, r, DT_SINGLELINE or DT_LEFT or DT_TOP or DT_CALCRECT);
  EndPaint(hWindow, ps);
  AWidth:=r.Right;
  AHeight:=r.Bottom;
end;

constructor TWinHandle.Create(Owner:TWinHandle);
begin
  inherited Create;
  SetParent(Owner);
  wTrackingMouse:=false;
  wMouseOverComponent:=false;
  wMouseDown:=false;
  wCursor:=crArrow;
  fOnClick:=nil;
  wExStyle:=0;
  wStyle:=0;
  wEnabled:=true;
end;

procedure TWinHandle.RegisterMouseLeave;
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

procedure TWinHandle.MouseWheelPerform(AButtonControl:cardinal; deltawheel:integer; x, y:integer);
begin
end;

procedure TWinHandle.MouseMovePerform(AButtonControl:cardinal; x,y:integer);
begin
  RegisterMouseLeave;
  SetCursor(wCursor);
  if not wMouseOverComponent
  then begin
    wMouseOverComponent:=true;
    RedrawPerform;
  end;
end;

procedure TWinHandle.MouseLeavePerform;
begin
  wTrackingMouse:=false;
  wMouseOverComponent:=false;
  wMouseDown:=false;
end;

procedure TWinHandle.MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);
begin
  wMouseDown:=true;
  SetFocus;
  if (AButton = mbLeft)
  then begin
    if Assigned(fOnClick)
    then fOnClick(self);
  end
end;

procedure TWinHandle.MouseButtonUpPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);
begin
  wMouseDown:=false;
end;

procedure TWinHandle.MouseButtonDblDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);
begin
end;

procedure TWinHandle.KeyCharPerform(keychar:cardinal);
begin
end;

procedure TWinHandle.SetFocus;
var h:HWND;
begin
  h:=GetFocus;
  if h<>0
  then SendMessage(h, WM_KILLFOCUS, 0, 0);
  windows.SetFocus(hWindow);
  SetFocusPerform;
end;

procedure TWinHandle.SetFocusPerform;
begin
end;

procedure TWinHandle.KillFocusPerform;
begin
end;

procedure TWinHandle.CapturePerform(AWindow:HWND);
begin
end;

procedure TWinHandle.ClosePerform;
begin
end;

procedure TWinHandle.SetBounds(ALeft, ATop, AWidth, AHeight:integer);
begin
  hLeft:=ALeft;
  hTop:=ATop;
  hWidth:=AWidth;
  hHeight:=AHeight;
end;

end.
