unit uiform;

interface

uses ui, uimpl, uihandle;

type

  TWinForm=class(TWinHandle)
  private
  protected
  public
    constructor Create(Owner:TWinHandle);override;
    procedure CreatePerform;override;
    procedure CustomPaint;override;
  end;


  TWinModal=class(TWinHandle)
  private
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
  CreateFormStyle;
  hLeft:=50;
  hTop:=50;
  hWidth:=800;
  hHeight:=640;
end;

procedure TWinForm.CreatePerform;
begin
  inherited;
  CreateFormWindow;
end;

procedure TWinForm.CustomPaint;
//var r:trect;
begin
(*  inherited;
  r:=GetClientRect;
  BeginPaint;
  Polygon(color,
          0,
          r.Left, r.Top, r.Right-1, r.Bottom-1);
  DrawText(r, 'form', font,
           0, 0,
           TRANSPARENT, DT_SINGLELINE or DT_CENTER or DT_VCENTER);
  EndPaint;*)
end;

constructor TWinModal.Create(Owner:TWinHandle);
begin
  inherited Create(Owner);
  CreateModalStyle;
end;

procedure TWinModal.CreatePerform;
begin
  inherited;
  CreateModalWindow;
end;

function TWinModal.ShowModal:integer;
begin
  result:=ShowModalWindow;
end;

procedure TWinModal.Close;
begin
  CloseModalWindow;
end;

procedure TWinModal.ClosePerform;
begin
  inherited;
  CloseModalPerform;
end;

procedure TWinModal.KillFocusPerform;
begin
  inherited;
  if Assigned(wOnKillFocus)
  then wOnKillFocus(self)
end;

end.
