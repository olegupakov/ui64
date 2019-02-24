unit uiedit;

interface

uses windows, sysutils, ui, uicomp;

type

  TWinEdit=class(TWinComp)
  private
    KeyCursorX, KeyCursorY : integer;
    wSelStart, wSelEnd : integer;
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
  wSelStart:=0;
  wSelEnd:=0;
end;

procedure TWinEdit.CustomPaint;
var r:trect;
begin
  r:=GetClientRect;
  BeginPaint;
  Polygon(clDkGray, bkcolor, r.Left, r.Top, r.Right-1, r.Bottom-1);
  r.Left:=r.Left+2;
  r.Right:=r.Right-3;
  DrawText(r, text, font, color, bkcolor, TRANSPARENT, DT_SINGLELINE or DT_LEFT or DT_VCENTER or DT_NOPREFIX);
  EndPaint;
end;

procedure TWinEdit.MouseMovePerform(AButtonControl:cardinal; x,y:integer);
begin
  inherited;
end;

procedure TWinEdit.MouseLeavePerform;
begin
  inherited;
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
    wSelStart:=length(wText);
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
  if keychar = vk_back
  then begin
    if(wSelStart>0)and(wSelStart<=length(wText))
    then begin
      wText:=copy(wText,1,wSelStart-1)+copy(wText, wSelStart+1, length(wText));
      wSelStart:=wSelStart-1;
    end;
  end
  else begin
    if wSelStart = 0
    then begin
      wText:=chr(keychar)+wText;
      wSelStart:=1;
    end
    else
    if wSelStart >= length(wText)
    then begin
      wText:=wText+chr(keychar);
      wSelStart:=length(wText);
    end
    else begin
      wText:=copy(wText,1,wSelStart)+chr(keychar)+copy(wText, wSelStart+1, length(wText));
      wSelStart:=wSelStart+1;
    end
  end;
  RedrawPerform;
end;

end.
