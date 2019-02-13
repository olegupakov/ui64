unit uilabel;

interface

uses windows, ui, uicomp;

type
  TWinLabel=class(TWinComp)
  private
  protected
  public
    procedure CustomPaint;override;
    procedure CreatePerform;override;
  end;

implementation

procedure TWinLabel.CustomPaint;
var
  dc : hdc;
  ps : paintstruct;
  r : trect;
begin
  GetClientRect(hWindow, r);
  dc := BeginPaint(hWindow, ps);
  SelectObject(dc, fntBold);
  SetTextColor(dc, wColor);
  SetBkMode(dc, TRANSPARENT);
  DrawText(dc, pchar(wText), -1, r, DT_SINGLELINE or DT_LEFT or DT_TOP);
  EndPaint(hWindow, ps);
end;

procedure TWinLabel.CreatePerform;
begin
  inherited;
  CalcTextSize(wText, hWidth, hHeight);
  SetPosPerform;
end;

end.
