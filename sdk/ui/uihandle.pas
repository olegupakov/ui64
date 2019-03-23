unit uihandle;

interface

uses ui, uimpl, datastorage;

type

  TWinHandle=class;

  TWinHandleEvent=procedure(Sender:TWinHandle) of object;

  TWinHandle=class(TWinHandleImpl)
  private
  protected

    wFont:HFONT;
    wColor, wBkColor, wHoverColor, wHoverBkColor, wBorderColor, wHoverBorderColor:cardinal;

    // mouse
    wMouseDown:boolean;
    wMouseOverComponent:boolean;

    wName:string;
    wMinHeight:integer;

    wAlign:TAlign;

    wChildHandleList:TListEx;

    fOnClick:TWinHandleEvent;

    procedure SetParent(AParent:TWinHandle);
    function GetParent:TWinHandle;
    procedure SetFont(AValue:HFONT);
  public
    constructor Create(Owner:TWinHandle);virtual;

    function  ShowModal:integer;virtual;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight : integer);
//    procedure SetFocus;virtual;
    procedure CreatePerform;virtual;abstract;
    procedure SetFontPerform;virtual;
    procedure MouseMovePerform(AButtonControl:cardinal; x,y:integer);override;
    procedure MouseWheelPerform(AButtonControl:cardinal; deltawheel:integer; x, y:integer);override;
    procedure MouseLeavePerform;override;
    procedure MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);override;
    procedure MouseButtonUpPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);override;
    procedure MouseButtonDblDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);override;
    procedure KillFocusPerform(handle:HWND);override;
    procedure ClosePerform;override;
    procedure CapturePerform(AWindow:HWND);override;
    procedure KeyCharPerform(keychar:cardinal);override;
    procedure SizePerform;override;

    property Window:HWnd read hWindow;
    property Parent:TWinHandle read GetParent write SetParent;
    property Align:TAlign read wAlign write wAlign;
    property Left:integer read hLeft write hLeft;
    property Top:integer read hTop write hTop;
    property Width:integer read hWidth write hWidth;
    property Height:integer read hHeight write hHeight;
    property MinHeight:integer read wMinHeight write wMinHeight;
    property Cursor:cardinal read wCursor write wCursor;
    property Text:string read wText write wText;
    property Name:string read wName write wName;
    property Style:cardinal read wStyle write wStyle;
    property ExStyle:cardinal read wExStyle write wExStyle;
    property Enabled:boolean read wEnabled write wEnabled;
    property ChildHandleList:TListEx read wChildHandleList write wChildHandleList;
    property Font:HFONT read wFont write SetFont;
    property Color:cardinal read wColor write wColor;
    property BkColor:cardinal read wBkColor write wBkColor;
    property BorderColor:cardinal read wBorderColor write wBorderColor;
    property HoverColor:cardinal read wHoverColor write wHoverColor;
    property HoverBkColor:cardinal read wBkColor write wHoverBkColor;
    property HoverBorderColor:cardinal read wHoverBorderColor write wHoverBorderColor;
    // event
    property OnClick:TWinHandleEvent read fOnClick write fOnClick;
  end;

function CreateMainWindow(AMainWinForm:TWinHandle; AText:string):TWinHandle;

//var MainWinForm:TWinHandle;
    //KeyboardLanguage:cardinal;

implementation

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
  wFont:=fntRegular;
  wColor:=clBlack;
  wBkColor:=clWhite;
  wHoverColor:=clBlack;
  wHoverBkColor:=clWhite;
end;

function CreateMainWindow(AMainWinForm:TWinHandle; AText:string):TWinHandle;
begin
  MainWinForm:=AMainWinForm;
  AMainWinForm.Text:=AText;
  AMainWinForm.Parent := nil;
  AMainWinForm.CreatePerform;
  if AMainWinForm.Window = 0 then begin
    //MessageBox(0, 'WinCreate failed', nil, mb_Ok);
    //halt(0);
  end;
  result:=AMainWinForm;
end;

function TWinHandle.ShowModal:integer;
begin
  result:=MR_CLOSE
end;

function TWinHandle.GetParent:TWinHandle;
begin
  result:=TWinHandle(wParent)
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
  r:=GetClientRect;
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

procedure TWinHandle.MouseWheelPerform(AButtonControl:cardinal; deltawheel:integer; x, y:integer);
begin
end;

procedure TWinHandle.MouseMovePerform(AButtonControl:cardinal; x,y:integer);
begin
  RegisterMouseLeave;
  SetCursor;
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
    RedrawPerform;
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

procedure TWinHandle.SetFont(AValue:HFONT);
begin
  wFont:=AValue;
  SetFontPerform;
end;

procedure TWinHandle.SetFontPerform;
begin
end;

end.
