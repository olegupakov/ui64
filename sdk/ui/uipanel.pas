unit uipanel;

interface

uses windows, sysutils, ui, uicomp;

type

  TWinPanel=class(TWinComp)
  private
  protected
  public
    procedure CustomPaint;override;
  end;

implementation

procedure TWinPanel.CustomPaint;
var
  dc : hdc;
  ps : paintstruct;
  r : trect;
  p : array[0..4] of tpoint;
begin
  GetClientRect(hWindow, r);
  dc := BeginPaint(hWindow, ps);
  SelectObject(dc, GetStockObject(DC_BRUSH));
  SetDCBrushColor(dc, clPanelBackground2);
  SelectObject(dc, GetStockObject(DC_PEN));
  SetDCPenColor(dc, clDkGray);
  p[0].X:=r.Left; p[0].Y:=r.Top;
  p[1].X:=r.Right-1; p[1].Y:=r.Top;
  p[2].X:=r.Right-1; p[2].Y:=r.Bottom-1;
  p[3].X:=r.Left; p[3].Y:=r.Bottom-1;
  p[4].X:=r.Left; p[4].Y:=r.Top;
  Polygon(dc, p, 5);
  SetDCPenColor(dc, clWhite);
  p[0].X:=r.Left; p[0].Y:=r.Bottom-2;
  p[1].X:=r.Left; p[1].Y:=r.Top;
  p[2].X:=r.Right-1; p[2].Y:=r.Top;
  PolyLine(dc, p, 3);
  SetTextColor(dc, clBlack);
  SetBkMode(dc, TRANSPARENT);
  DrawText(dc, pchar(inttostr(Left)+':'+inttostr(Top)), -1, r, DT_SINGLELINE or DT_CENTER or DT_VCENTER);
  EndPaint(hWindow, ps);
end;

end.
 