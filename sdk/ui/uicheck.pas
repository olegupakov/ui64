unit uicheck;

interface

uses ui, uimpl, uicomp;

type
  TWinCheck=class(TWinComp)
  private
    wChecked:boolean;
  protected
  public
    procedure CustomPaint;override;
    procedure CreatePerform;override;
    procedure MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);override;
    property Checked:boolean read wChecked write wChecked;
  end;

implementation

uses uihandle;

procedure TWinCheck.CustomPaint;
var r:trect;
begin
  r:=GetClientRect;
  BeginPaint;
  DrawText(r, ifthen(checked, 'X ', 'O ')+text, font, color, bkcolor, TRANSPARENT, DT_SINGLELINE or DT_LEFT or DT_TOP);
  EndPaint;
end;

procedure TWinCheck.CreatePerform;
begin
  inherited;
  CalcTextSize('XX'+Text, hWidth, hHeight);
  SetPosPerform;
end;

procedure TWinCheck.MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);
begin
  inherited;
  if AButton=mbLeft
  then begin
    Checked:=not Checked;
    RedrawPerform;
  end;
end;

end.