unit uibutton;

interface

uses windows, ui, uicomp;

type

  TWinButton=class(TWinComp)
  private
  protected
  public
    procedure CustomPaint;override;
    procedure MouseMovePerform(AButtonControl:cardinal; x,y:integer);override;
    procedure MouseLeavePerform;override;
    procedure MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);override;
    procedure MouseButtonUpPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);override;
  end;

implementation

procedure TWinButton.CustomPaint;
var
  dc : hdc;
  ps : paintstruct;
  r : trect;
  p : array[0..4] of tpoint;
begin
  GetClientRect(hWindow, r);
  dc := BeginPaint(hWindow, ps);
  SelectObject(dc, GetStockObject(DC_BRUSH));
  if wMouseDown
  then SetDCBrushColor(dc, clPanelBackground1)
  else SetDCBrushColor(dc, clPanelBackground2);
  SelectObject(dc, GetStockObject(DC_PEN));
  SetDCPenColor(dc, clDkGray);
  p[0].X:=r.Left; p[0].Y:=r.Top;
  p[1].X:=r.Right-2; p[1].Y:=r.Top;
  p[2].X:=r.Right-2; p[2].Y:=r.Bottom-2;
  p[3].X:=r.Left; p[3].Y:=r.Bottom-2;
  p[4].X:=r.Left; p[4].Y:=r.Top;
  Polygon(dc, p, 5);
  SetDCPenColor(dc, clWhite);
  p[0].X:=r.Left; p[0].Y:=r.Bottom-2;
  p[1].X:=r.Left; p[1].Y:=r.Top;
  p[2].X:=r.Right-1; p[2].Y:=r.Top;
  PolyLine(dc, p, 3);
  if wMouseOverComponent
  then SetDCPenColor(dc, clBlack)
  else SetDCPenColor(dc, clFaceBook1);
  p[0].X:=r.Left; p[0].Y:=r.Bottom-1;
  p[1].X:=r.Right-1; p[1].Y:=r.Bottom-1;
  p[2].X:=r.Right-1; p[2].Y:=r.Top-1;
  PolyLine(dc, p, 3);
  if wMouseOverComponent
  then SetTextColor(dc, clBlack)
  else SetTextColor(dc, clFaceBook1);
  SetBkMode(dc, TRANSPARENT);
  DrawText(dc, pchar(wText), -1, r, DT_SINGLELINE or DT_CENTER or DT_VCENTER);
  EndPaint(hWindow, ps);
end;

procedure TWinButton.MouseMovePerform(AButtonControl:cardinal; x,y:integer);
begin
  inherited;
//  Text:=inttostr(x)+':'+inttostr(y);
  //RedrawPerform;
end;

procedure TWinButton.MouseLeavePerform;
begin
  inherited;
//  Text:='X';
//  RedrawPerform;
end;

procedure TWinButton.MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);
begin
  inherited;
  RedrawPerform;
end;

procedure TWinButton.MouseButtonUpPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);
begin
  inherited;
  RedrawPerform;
end;

end.
 