unit uicomp;

interface

uses windows, ui, uihandle;

type

  TWinComp=class(TWinHandle)
  private
  protected
  public
    constructor Create(Owner:TWinHandle);override;
    procedure CustomPaint;override;
    procedure CreatePerform;override;
  end;

implementation

constructor TWinComp.Create(Owner:TWinHandle);
begin
  inherited Create(Owner);
  wExStyle:=WS_EX_CONTROLPARENT;
  wStyle:=WS_CHILD or WS_VISIBLE;
end;

procedure TWinComp.CreatePerform;
begin
  inherited;
  hWindow := CreateWindowEx(wExStyle, CUSTOM_COMP, nil, wStyle,
                          hLeft, hTop, hWidth, hHeight,
                          Parent.Window, 0, 0, nil);
  SetWindowLongPtr(hWindow, GWL_USERDATA, self);
end;

procedure TWinComp.CustomPaint;
(*
var
  dc : hdc;
  ps : paintstruct;
  r : trect;
  p : array[0..4] of tpoint;
*)
begin
(*
  GetClientRect(hWindow, r);
  dc := BeginPaint(hWindow, ps);
//  FillRect(dc, r, HBRUSH(COLOR_GRADIENTACTIVECAPTION+1));
  FillRect(dc, r, BRUSHES[wColor]);
  p[0].X:=r.Left; p[0].Y:=r.Top;
  p[1].X:=r.Right-1; p[1].Y:=r.Top;
  p[2].X:=r.Right-1; p[2].Y:=r.Bottom-1;
  p[3].X:=r.Left; p[3].Y:=r.Bottom-1;
  p[4].X:=r.Left; p[4].Y:=r.Top;
  Polyline(dc, p, 5);
  SetTextColor(dc, RGB(59,89,152));
  SetBkMode(dc, TRANSPARENT);
  DrawText(dc, pchar(wCaption), -1, r, DT_SINGLELINE or DT_CENTER or DT_VCENTER);
  EndPaint(hWindow, ps);
*)
end;

// end

end.
 