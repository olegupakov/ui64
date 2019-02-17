unit uiedit;

interface

uses windows, sysutils, ui, uicomp;

type

  TWinEdit=class(TWinComp)
  private
    KeyCursorX, KeyCursorY : integer;
  protected
  public
    procedure CustomPaint;override;
    procedure CreatePerform;override;
    procedure HideKeyCursor;
    procedure ShowKeyCursor;
    procedure MouseMovePerform(AButtonControl:cardinal; x,y:integer);override;
    procedure MouseLeavePerform;override;
    procedure MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);override;
    procedure MouseWheelPerform(AButtonControl:cardinal; deltawheel:integer; x, y:integer);override;
    procedure KeyCharPerform(keychar:cardinal);override;
    procedure SetFocusPerform;override;
    procedure KillFocusPerform(handle:HWND);override;
  end;

implementation

procedure TWinEdit.CreatePerform;
begin
  inherited;
  wCursor:=crIBeam;
end;

procedure TWinEdit.CustomPaint;
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
  DrawText(dc, pchar(wText), -1, r, DT_SINGLELINE or DT_LEFT or DT_VCENTER or DT_NOPREFIX);
  EndPaint(hWindow, ps);
end;

procedure TWinEdit.MouseMovePerform(AButtonControl:cardinal; x,y:integer);
begin
  inherited;
  //wText:='';
  //RedrawPerform;
end;

procedure TWinEdit.MouseLeavePerform;
begin
  inherited;
  //RedrawPerform;
end;

procedure TWinEdit.HideKeyCursor;
begin
  HideCaret(hWindow);
end;

procedure TWinEdit.ShowKeyCursor;
begin
  HideCaret(hWindow);
  CreateCaret(hWindow, 0, 2, 17);
  SetCaretPos(KeyCursorX, KeyCursorY);
  ShowCaret(hWindow);
end;

procedure TWinEdit.SetFocusPerform;
begin
  inherited;
  ShowKeyCursor;
  RedrawPerform
end;

procedure TWinEdit.KillFocusPerform;
begin
  inherited;
  HideKeyCursor;
  RedrawPerform
end;

procedure TWinEdit.MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);
begin
  if AButton=mbLeft
  then begin
    KeyCursorX:=x;
    KeyCursorY:=4;
  end;
  inherited;
end;

procedure TWinEdit.MouseWheelPerform(AButtonControl:cardinal; deltawheel:integer; x, y:integer);
begin
  inherited;
  wText:=inttostr(deltawheel);
  RedrawPerform;
end;

procedure TWinEdit.KeyCharPerform(keychar:cardinal);
begin
  inherited;
  wText:=inttostr(keychar);//wText+chr(keychar);
  RedrawPerform;
end;

end.
 