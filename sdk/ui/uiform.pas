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
  public
    constructor Create(Owner:TWinHandle);override;
    function ShowModal:integer;override;
    procedure Close;
    procedure CreatePerform;override;
    procedure ClosePerform;override;
    property ModalResult:integer read wModalResult write wModalResult;
  end;

implementation

constructor TWinForm.Create(Owner:TWinHandle);
begin
  inherited Create(Owner);
  wExStyle:=WS_EX_COMPOSITED or WS_EX_LAYERED or WS_EX_NOINHERITLAYOUT;
  wStyle:=WS_OVERLAPPEDWINDOW;
  hLeft:=cw_UseDefault;
  hTop:=cw_UseDefault;
  hWidth:=cw_UseDefault;
  hHeight:=cw_UseDefault;
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
  wExStyle:=WS_EX_COMPOSITED or WS_EX_DLGMODALFRAME;
  wStyle:=WS_BORDER or WS_POPUP or WS_SYSMENU or WS_DLGFRAME;
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
  PostMessage(hWindow, wm_quit, 0, 0);
  Parent.Enabled:=true;
  EnableWindow(Parent.Window, TRUE);
end;

end.
