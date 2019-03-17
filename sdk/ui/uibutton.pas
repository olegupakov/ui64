unit uibutton;

interface

uses ui, uimpl, uihandle, uicomp;

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
  wFont:=fntBold;
  wColor:=clWhite;
  wBkColor:=clFaceBook1;
  wBorderColor:=clFaceBook1;
  wHoverColor:=clWhite;
  wHoverBkColor:=clFaceBook1;
  wHoverBorderColor:=clWhite;
end;

procedure TWinButton.CustomPaint;
var r:trect;
begin
  r:=GetClientRect;
  BeginPaint;
  Polygon(ifthen(wMouseOverComponent, HoverBorderColor, BorderColor),
          ifthen(wMouseOverComponent, ifthen(wMouseDown, clFaceBook2, HoverBkColor), BkColor),
          r.Left, r.Top, r.Right-1, r.Bottom-1);
  DrawText(r, text, font,
           ifthen(wMouseOverComponent, HoverColor, Color), 0,
           TRANSPARENT, DT_SINGLELINE or DT_CENTER or DT_VCENTER);
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
 