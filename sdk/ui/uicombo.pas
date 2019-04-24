unit uicombo;

interface

uses ui, uimpl, uihandle, uicomp, uiform, uilist, datastorage;

type

  TWinPopupListForm=class(TWinModal)
  private
    wItems:TWinList;
  protected
  public
    constructor Create(Owner:TWinHandle);override;
    procedure CreatePerform;override;
    procedure Show(nCmdShow:integer = SW_SHOWNORMAL);override;
  end;

  TWinCombo=class(TWinComp)
  private
    ComboList:TWinPopupListForm;
  protected
    procedure ListSelected(Sender:TWinHandle);
    function GetItems:TStringListEx;
    function GetSelected:integer;
    procedure SetSelected(AValue:integer);
  public
    constructor Create(Owner:TWinHandle);override;
    procedure CustomPaint;override;
    procedure CreatePerform;override;
    procedure MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);override;
    procedure KillFocusPerform(handle:HWND);override;
    property Items:TStringListEx read GetItems;
    property Selected:integer read GetSelected write SetSelected;
  end;

implementation

constructor TWinPopupListForm.Create(Owner:TWinHandle);
begin
  inherited;
  CreatePopupStyle;
end;

procedure TWinPopupListForm.CreatePerform;
begin
  inherited;
  wItems:=TWinList.Create(self);
  wItems.SetBounds(0,0,10,10);
  wItems.Align:=alClient;
  wItems.CreatePerform;
end;

procedure TWinPopupListForm.Show(nCmdShow:integer = SW_SHOWNORMAL);
begin
  inherited;
end;

constructor TWinCombo.Create(Owner:TWinHandle);
begin
  inherited;
  ComboList:=TWinPopupListForm.Create(self);
end;

procedure TWinCombo.CustomPaint;
var r:trect;
begin
  r:=GetClientRect;
  BeginPaint;
  Polygon(color, bkcolor, r.Left, r.Top, r.Right-1, r.Bottom-1);
  r.Left:=r.Left+2;
  DrawText(r, text, font, color, bkcolor, TRANSPARENT, DT_SINGLELINE or DT_LEFT or DT_VCENTER or DT_NOPREFIX);
  EndPaint;
end;

procedure TWinCombo.CreatePerform;
begin
  inherited;
  ComboList.SetBounds(50,50,300,300);
  ComboList.CreatePerform;
  ComboList.wItems.OnSelected:=ListSelected;
end;

function TWinCombo.GetItems:TStringListEx;
begin
  result:=Combolist.wItems.Items;
end;

function TWinCombo.GetSelected:integer;
begin
  result:=Combolist.wItems.Selected
end;

procedure TWinCombo.SetSelected(AValue:integer);
begin
  Combolist.wItems.Selected:=AValue
end;

procedure TWinCombo.MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);
var p:TPoint;
begin
  inherited;
  if AButton=mbLeft
  then begin
    p.x:=0;
    p.y:=0;
    GetCursorPos(p);
    ComboList.SetBounds(p.x-x,p.y-y+height,width,150);
    ComboList.SetPosPerform;
    ComboList.SizePerform;
    combolist.Show;
  end
end;

procedure TWinCombo.KillFocusPerform(handle:HWND);
begin
  inherited;
  if (ComboList<>nil)and(handle<>ComboList.Window)
    and(ComboList.wItems<>nil)and(handle<>ComboList.wItems.Window)
  then begin
    ComboList.hide;
  end;
end;

procedure TWinCombo.ListSelected(Sender:TWinHandle);
var L:TWinList;
begin
  L:=TWinList(Sender);
  text:=L.Items[L.Selected];
  RedrawPerform;
  ComboList.hide;
//  SetFocus;
end;

end.
