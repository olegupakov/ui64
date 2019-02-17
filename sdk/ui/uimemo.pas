unit uimemo;

interface

uses Windows, SysUtils, Math, ui, uihandle, uicomp, datastorage;

type

  TWinMemo=class(TWinComp)
  private
    wTopItem:integer;
    wLines:TStringListEx;
    KeyCursorX, KeyCursorY : integer;
  protected
  public
    constructor Create(Owner:TWinHandle);override;
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
    property Lines:TStringListEx read wLines;
  end;

implementation

constructor TWinMemo.Create(Owner:TWinHandle);
begin
  inherited;
  wLines:=TStringListEx.Create;  //TODO destroy
  wTopItem:=0;
end;

procedure TWinMemo.CreatePerform;
begin
  inherited;
  wCursor:=crIBeam;
end;

procedure TWinMemo.CustomPaint;
var
  dc : hdc;
  ps : paintstruct;
  r, rtxt : trect;
  p : array[0..4] of tpoint;
  i:integer;
begin
  GetClientRect(hWindow, r);
  dc := BeginPaint(hWindow, ps);

  rtxt:=r;
  rtxt.Left:=rtxt.Left+4;
  rtxt.Right:=rtxt.Right-1;
  rtxt.Top:=rtxt.Top+1;
  rtxt.Bottom:=rtxt.Top+18;
  i:=wTopItem;
  while(rtxt.Top<r.Bottom) do begin

    SelectObject(dc, GetStockObject(DC_BRUSH));
    SetDCBrushColor(dc, clWhite);
    SelectObject(dc, GetStockObject(DC_PEN));
    SetDCPenColor(dc, clWhite);
    p[0].X:=rtxt.Left-3; p[0].Y:=rtxt.Top;
    p[1].X:=rtxt.Right-1; p[1].Y:=rtxt.Top;
    p[2].X:=rtxt.Right-1; p[2].Y:=rtxt.Bottom-1;
    p[3].X:=rtxt.Left-3; p[3].Y:=rtxt.Bottom-1;
    p[4].X:=rtxt.Left-3; p[4].Y:=rtxt.Top;
    Polygon(dc, p, 5);

    if i<Lines.count
    then begin
      SetTextColor(dc, clBlack);
      SetBkColor(dc, clWhite);
      SetBkMode(dc, OPAQUE);
      DrawText(dc, pchar(Lines[i]), -1, rtxt, DT_SINGLELINE or DT_LEFT or DT_VCENTER);
    end;

    inc(i);
    rtxt.Top:=rtxt.Top+18;
    rtxt.Bottom:=rtxt.Bottom+18;
  end;

  SelectObject(dc, GetStockObject(DC_PEN));
  SetDCPenColor(dc, clDkGray);
  p[0].X:=r.Left; p[0].Y:=r.Top;
  p[1].X:=r.Right-1; p[1].Y:=r.Top;
  p[2].X:=r.Right-1; p[2].Y:=r.Bottom-1;
  p[3].X:=r.Left; p[3].Y:=r.Bottom-1;
  p[4].X:=r.Left; p[4].Y:=r.Top;
  Polyline(dc, p, 5);

  EndPaint(hWindow, ps);
end;

procedure TWinMemo.MouseMovePerform(AButtonControl:cardinal; x,y:integer);
begin
  inherited;
  //wText:='';
  //RedrawPerform;
end;

procedure TWinMemo.MouseLeavePerform;
begin
  inherited;
  //RedrawPerform;
end;

procedure TWinMemo.HideKeyCursor;
begin
  HideCaret(hWindow);
end;

procedure TWinMemo.ShowKeyCursor;
begin
  HideCaret(hWindow);
  CreateCaret(hWindow, 0, 2, 17);
  SetCaretPos(KeyCursorX, KeyCursorY);
  ShowCaret(hWindow);
end;

procedure TWinMemo.SetFocusPerform;
begin
  inherited;
  ShowKeyCursor;
  RedrawPerform
end;

procedure TWinMemo.KillFocusPerform;
begin
  inherited;
  HideKeyCursor;
  RedrawPerform
end;

procedure TWinMemo.MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);
begin
  if AButton=mbLeft
  then begin
    KeyCursorX:=x;
    KeyCursorY:=(y div 18)*18+2;
  end;
  inherited;
end;

procedure TWinMemo.MouseWheelPerform(AButtonControl:cardinal; deltawheel:integer; x, y:integer);
begin
  inherited;
  wTopItem:=max(wTopItem-deltawheel,0);
  KeyCursorY:=KeyCursorY+deltawheel*18;
  ShowKeyCursor;
  RedrawPerform
end;

procedure TWinMemo.KeyCharPerform(keychar:cardinal);
begin
  inherited;
  wText:=inttostr(keychar);//wText+chr(keychar);
  RedrawPerform;
end;

end.
