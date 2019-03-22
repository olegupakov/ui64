unit uimemo;

interface

uses SysUtils, Math, ui, uimpl, uihandle, uicomp, datastorage;

type

  TWinMemo=class(TWinComp)
  private
    wTopItem:integer;
    wLines:TStringListEx;
  protected
  public
    constructor Create(Owner:TWinHandle);override;
    procedure CustomPaint;override;
    procedure CreatePerform;override;
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
  r, rtxt : trect;
  i:integer;
begin
  r:=GetClientRect;
  BeginPaint;

  rtxt:=r;
  rtxt.Left:=rtxt.Left+3;
  rtxt.Right:=rtxt.Right-1;
  rtxt.Top:=rtxt.Top+1;
  rtxt.Bottom:=rtxt.Top+18;
  i:=wTopItem;
  while(rtxt.Top<r.Bottom) do begin

    Polygon(bkcolor, bkcolor, rtxt.Left-2, rtxt.Top, rtxt.Right-1, rtxt.Bottom-1);

    if i<Lines.count
    then begin
      DrawText(rtxt, Lines[i], font, color, bkcolor, OPAQUE, DT_SINGLELINE or DT_LEFT or DT_TOP);
    end;

    inc(i);
    rtxt.Top:=rtxt.Top+18;
    rtxt.Bottom:=rtxt.Bottom+18;
  end;

  Polyline(clFaceBook1, 0, 5, r.Left, r.Top, r.Right-1, r.Bottom-1);

  EndPaint;
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
