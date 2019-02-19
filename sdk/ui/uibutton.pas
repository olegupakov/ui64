unit uibutton;

interface

uses windows, ui, uihandle, uicomp;

type

  TWinButton=class(TWinComp)
  private
  protected
  public
    constructor Create(Owner:TWinHandle);override;
    procedure CustomPaint;override;
    procedure MouseMovePerform(AButtonControl:cardinal; x,y:integer);override;
    procedure MouseLeavePerform;override;
    procedure MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);override;
    procedure MouseButtonUpPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);override;
  end;

implementation

constructor TWinButton.Create(Owner:TWinHandle);
begin
  inherited Create(Owner);
  wBkColor:=clPanelBackground2;
  wColor:=clBlack;
end;

procedure TWinButton.CustomPaint;
var r:trect;
begin
  r:=GetClientRect;
  BeginPaint;
  Polygon(color, bkcolor, r.Left, r.Top, r.Right-1, r.Bottom-1);
//  PolyLine(clWhite, -1, 3, r.Left, r.Top, r.Right-1, r.Bottom-2);
//  if wMouseOverComponent
//  then SetDCPenColor(dc, clBlack)
//  else SetDCPenColor(dc, clFaceBook1);
//  PolyLine(clBlack, -1, 3, r.Left, r.Top-1, r.Right-1, r.Bottom-1);
//  if wMouseOverComponent
//  then SetTextColor(dc, clBlack)
//  else SetTextColor(dc, clFaceBook1);
 // SetBkMode(dc, TRANSPARENT);
  DrawText(r, text, font, color, bkcolor, TRANSPARENT, DT_SINGLELINE or DT_CENTER or DT_VCENTER);
  EndPaint;
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
 