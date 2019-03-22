unit uilabel;

interface

uses ui, uicomp;

type
  TWinLabel=class(TWinComp)
  private
  protected
  public
    procedure CustomPaint;override;
    procedure CreatePerform;override;
    procedure SetFontPerform;override;
  end;

implementation

procedure TWinLabel.CustomPaint;
var r:trect;
begin
  r:=GetClientRect;
  BeginPaint;
  DrawText(r, text, font, color, bkcolor, TRANSPARENT, DT_SINGLELINE or DT_LEFT or DT_TOP);
  EndPaint;
end;

procedure TWinLabel.CreatePerform;
begin
  inherited;
  CalcTextSize(Text, hWidth, hHeight);
  SetPosPerform;
end;

procedure TWinLabel.SetFontPerform;
begin
  inherited;
  CalcTextSize(Text, hWidth, hHeight);
  SetPosPerform;
end;

end.
