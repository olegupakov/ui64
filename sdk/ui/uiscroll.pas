unit uiscroll;

interface

uses windows, ui, uicomp, uihandle;

type

  TWinScroll=class(TWinComp)
  private
    wScrollActive:boolean;
    last_x_down, last_y_down:integer;
  protected
  public
    procedure CreatePerform;override;
    procedure CustomPaint;override;
    procedure MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);override;
    procedure MouseButtonUpPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);override;
    procedure MouseMovePerform(AButtonControl:cardinal; x,y:integer);override;
    procedure MouseLeavePerform;override;
    procedure CapturePerform(AWindow:HWND);override;
  end;

implementation

procedure TWinScroll.CreatePerform;
begin
  inherited;
  wScrollActive:=false;
end;

procedure TWinScroll.CustomPaint;
var
  dc : hdc;
  ps : paintstruct;
  r : trect;
  p : array[0..4] of tpoint;
begin
  GetClientRect(hWindow, r);
  dc := BeginPaint(hWindow, ps);
  SelectObject(dc, GetStockObject(DC_BRUSH));
  SetDCBrushColor(dc, clPanelBackground1);
  SelectObject(dc, GetStockObject(DC_PEN));
  SetDCPenColor(dc, clPanelBackground1);
  p[0].X:=r.Left; p[0].Y:=r.Top;
  p[1].X:=r.Right-1; p[1].Y:=r.Top;
  p[2].X:=r.Right-1; p[2].Y:=r.Bottom-1;
  p[3].X:=r.Left; p[3].Y:=r.Bottom-1;
//  p[4].X:=r.Left; p[4].Y:=r.Top;
  Polygon(dc, p, 4);
  SetDCPenColor(dc, clWhite);
  p[0].X:=r.Left; p[0].Y:=r.Bottom-2;
  p[1].X:=r.Left; p[1].Y:=r.Top;
  p[2].X:=r.Right-1; p[2].Y:=r.Top;
  PolyLine(dc, p, 3);
  SetTextColor(dc, clBlack);
  SetBkMode(dc, TRANSPARENT);
//  DrawText(dc, pchar(name+' '+inttostr(Left)+':'+inttostr(Top)), -1, r, DT_SINGLELINE or DT_CENTER or DT_VCENTER);
  EndPaint(hWindow, ps);
end;

procedure TWinScroll.MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);
var p:tpoint;
begin
  inherited;
  if (AButton=mbLeft)
  then begin
    GetCursorPos(p);
    last_x_down:=p.x;
    last_y_down:=p.y;
    wScrollActive:=true;
    SetCapture(window);
  end;
end;

procedure TWinScroll.MouseButtonUpPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);
begin
  inherited;
  ReleaseCapture();
end;

procedure TWinScroll.CapturePerform(AWindow:HWND);
begin
  inherited;
  wScrollActive := window = AWindow;
end;

procedure TWinScroll.MouseMovePerform(AButtonControl:cardinal; x,y:integer);
var p:tpoint;
begin
  inherited;
  if wScrollActive
  then begin
    GetCursorPos(p);
//todo    ScrollPerform(last_x_down-p.x, last_y_down-p.y);
    last_x_down:=p.x;
    last_y_down:=p.y;
  end;
end;

procedure TWinScroll.MouseLeavePerform;
begin
  inherited;
end;

end.
