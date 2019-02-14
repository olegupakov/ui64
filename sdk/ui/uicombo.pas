unit uicombo;

interface

uses windows, ui, uihandle, uicomp, uiform;

type

  TWinCombo=class(TWinComp)
  private
    frm:TWinModal;
  protected
  public
    procedure CustomPaint;override;
    procedure CreatePerform;override;
    procedure MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);override;
    procedure KillFocusPerform;override;
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
  p[4].X:=r.Left; p[4].Y:=r.Top;
  Polygon(dc, p, 5);
  SelectObject(dc, fntRegular);
  SetTextColor(dc, clBlack);
  SetBkMode(dc, TRANSPARENT);
  r.Left:=r.Left+2;
  DrawText(dc, pchar('Combobox'), -1, r, DT_SINGLELINE or DT_LEFT or DT_VCENTER or DT_NOPREFIX);
  EndPaint(hWindow, ps);
end;

procedure TWinCombo.CreatePerform;
begin
  inherited;
  frm:=TWinModal.Create(self);
  frm.ExStyle:=WS_EX_COMPOSITED;
  frm.Style:=WS_POPUP;
  frm.CreatePerform;
end;

procedure TWinCombo.MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);
var p:TPoint;
begin
  inherited;
  if AButton=mbLeft
  then begin
    GetCursorPos(p);
    frm.SetBounds(p.X-x,p.Y-y+height,width,150);
    frm.SetPosPerform;
    frm.Show;
  end
end;

procedure TWinCombo.KillFocusPerform;
begin
  inherited;
  frm.Hide;
end;

end.
