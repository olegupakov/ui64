unit uipanel;

interface

uses sysutils, ui, uimpl, uihandle, uicomp;

type

  TWinPanel=class(TWinComp)
  private
  protected
  public
    constructor Create(Owner:TWinHandle);override;
    procedure CustomPaint;override;
  end;

implementation

constructor TWinPanel.Create(Owner:TWinHandle);
begin
  inherited Create(Owner);
  wBkColor:=clPanelBackground2;
end;

procedure TWinPanel.CustomPaint;
var r:trect;
begin
  r:=GetClientRect;
  BeginPaint;
  Polygon(clDkGray, bkcolor, r.Left, r.Top, r.Right-1, r.Bottom-1);
  PolyLine(clWhite, -1, 3, r.Left, r.Top, r.Right-1, r.Bottom-2);
  DrawText(r, name+' '+inttostr(Left)+':'+inttostr(Top), font, color, 0, TRANSPARENT, DT_SINGLELINE or DT_CENTER or DT_VCENTER);
  EndPaint;
end;

end.
 
