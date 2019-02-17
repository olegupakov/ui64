unit uicombo;

interface

uses windows, ui, uihandle, uicomp, uiform, uilist;

type

  TWinCombo=class(TWinComp)
  private
    frm:TWinModal;
    c18:TWinList;
  protected
    procedure ListKillFocus(Sender:TWinHandle);
    procedure ListSelected(Sender:TWinHandle);
  public
    procedure CustomPaint;override;
    procedure CreatePerform;override;
    procedure MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);override;
    procedure KillFocusPerform(handle:HWND);override;
  end;

implementation

procedure TWinCombo.CustomPaint;
var
  dc : hdc;
  ps : paintstruct;
  r : trect;
  p : array[0..4] of tpoint;
begin
  GetClientRect(hWindow, r);
  dc := BeginPaint(hWindow, ps);
//  FillRect(dc, r, HBRUSH(COLOR_GRADIENTACTIVECAPTION+1));
  SelectObject(dc, GetStockObject(DC_BRUSH));
  SetDCBrushColor(dc, clWhite);
//  FillRect(dc, r, BRUSHES[wColor]);  // SelectObject(hdc, GetStockObject(DC_BRUSH));
  SelectObject(dc, GetStockObject(DC_PEN));
  if wMouseOverComponent
  then SetDCPenColor(dc, clFaceBook2)
  else SetDCPenColor(dc, clFaceBook1);
  p[0].X:=r.Left; p[0].Y:=r.Top;
  p[1].X:=r.Right-1; p[1].Y:=r.Top;
  p[2].X:=r.Right-1; p[2].Y:=r.Bottom-1;
  p[3].X:=r.Left; p[3].Y:=r.Bottom-1;
  //p[4].X:=r.Left; p[4].Y:=r.Top;
  Polygon(dc, p, 4);
  SelectObject(dc, fntRegular);
  SetTextColor(dc, clBlack);
  SetBkMode(dc, TRANSPARENT);
  r.Left:=r.Left+2;
  DrawText(dc, pchar(text), -1, r, DT_SINGLELINE or DT_LEFT or DT_VCENTER or DT_NOPREFIX);
  EndPaint(hWindow, ps);
end;

procedure TWinCombo.CreatePerform;
begin
  inherited;
end;

procedure TWinCombo.MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);
var p:TPoint;
begin
  inherited;
  if AButton=mbLeft
  then begin
    GetCursorPos(p);
    frm:=TWinModal.Create(self);
    frm.ExStyle:=WS_EX_COMPOSITED;
    frm.Style:=WS_POPUP or WS_VISIBLE;
    frm.SetBounds(p.X-x,p.Y-y+height,width,150);
//    frm.OnKillFocus:=ListKillFocus;
    frm.CreatePerform;
    c18:=TWinList.Create(frm);
    c18.name:='list1';
    c18.Color:=clBlack;
//    c18.SetBounds(0,0,200,135);
    c18.Align:=alClient;
    c18.OnSelected:=ListSelected;
    c18.CreatePerform;
    c18.Items.Add('item 1');
    c18.Items.Add('item 2');
    c18.Items.Add('item 3');
    c18.Items.Add('item 4');
    c18.Items.Add('item 5');
    c18.Items.Add('item 6');
    c18.Items.Add('item 7');
    c18.Items.Add('item 8');
    c18.Items.Add('item 9');
    c18.Items.Add('item 10');
    c18.Items.Add('item 11');
    c18.Items.Add('item 12');
    frm.SizePerform;
    SetFocus;
  end
end;

procedure TWinCombo.KillFocusPerform(handle:HWND);
begin
  inherited;
  if (frm<>nil)and(handle<>frm.Window)and(c18<>nil)and(handle<>c18.Window)
  then frm.hide
end;

procedure TWinCombo.ListKillFocus(Sender:TWinHandle);
begin
  //frm.Hide; // TODO destroy
  //SetFocus;
end;

procedure TWinCombo.ListSelected(Sender:TWinHandle);
var L:TWinList;
begin
  L:=TWinList(Sender);
  text:=L.Items[L.Selected];
  RedrawPerform;
  frm.hide;
  SetFocus;
end;

end.
