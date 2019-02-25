unit uiform;

interface

uses windows, messages, ui, uihandle;

type

  TWinForm=class(TWinHandle)
  private
  protected
  public
    constructor Create(Owner:TWinHandle);override;
    procedure CreatePerform;override;
  end;

  TWinModal=class(TWinHandle)
  private
    wModalResult:integer;
  protected
    wOnKillFocus:TWinHandleEvent;
  public
    constructor Create(Owner:TWinHandle);override;
    function ShowModal:integer;override;
    procedure Close;
    procedure CreatePerform;override;
    procedure ClosePerform;override;
    procedure KillFocusPerform(handle:HWND);override;
    property ModalResult:integer read wModalResult write wModalResult;
    property OnKillFocus:TWinHandleEvent read wOnKillFocus write wOnKillFocus;
  end;

implementation

constructor TWinForm.Create(Owner:TWinHandle);
begin
  inherited Create(Owner);
  wExStyle:=WS_EX_COMPOSITED or WS_EX_LAYERED or WS_EX_NOINHERITLAYOUT;
  wStyle:=WS_OVERLAPPEDWINDOW;
  hLeft:=50;
  hTop:=50;
  hWidth:=800;
  hHeight:=640;
end;

procedure TWinForm.CreatePerform;
begin
  inherited;
  hWindow := CreateWindowEx(wExStyle, CUSTOM_WIN, pchar(wText), wStyle,
               hLeft, hTop, hWidth, hHeight,
               0, 0, system.MainInstance, nil);
  SetWindowLongPtr(hWindow, GWL_USERDATA, self);
end;

constructor TWinModal.Create(Owner:TWinHandle);
begin
  inherited Create(Owner);
  wExStyle:=WS_EX_COMPOSITED or WS_EX_LAYERED or WS_EX_DLGMODALFRAME;
  wStyle:=WS_BORDER or WS_POPUP or WS_SYSMENU or WS_DLGFRAME
            or WS_SIZEBOX or WS_MINIMIZEBOX or WS_MAXIMIZEBOX;
end;

procedure TWinModal.CreatePerform;
begin
  inherited;
  hWindow := CreateWindowEx(wExStyle, CUSTOM_WIN, pchar(wText), wStyle,
               hLeft, hTop, hWidth, hHeight,
               Parent.Window, 0, system.MainInstance, nil);
  SetWindowLongPtr(hWindow, GWL_USERDATA, self);
end;

function TWinModal.ShowModal:integer;
var AMessage: Msg;
    ret:longbool;
begin
//  result:=inherited ShowModal;
  Parent.Enabled:=false;
  EnableWindow(Parent.Window, FALSE);
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

procedure TWinModal.Close;
begin
  PostMessage(hWindow, wm_close, 0, 0);
end;

procedure TWinModal.ClosePerform;
begin
  inherited;
  if wModalResult=MR_NONE
  then wModalResult:=MR_CLOSE;
  PostMessage(hWindow, WM_QUIT, 0, 0);
  Parent.Enabled:=true;
  EnableWindow(Parent.Window, TRUE);
end;

procedure TWinModal.KillFocusPerform;
begin
  inherited;
  if Assigned(wOnKillFocus)
  then wOnKillFocus(self)
end;

end.
