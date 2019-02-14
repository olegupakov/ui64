unit uilist;

interface

uses windows, ui, uihandle, uicomp, datastorage;

type

  TWinList=class(TWinComp)
  private
    wItems:TStringListEx;
    wTopItem:integer;
    wSelected:integer; // TODO multi
    wOnSelected:TWinHandleEvent;
  protected
    procedure SetSelected(AValue:integer);
  public
    constructor Create(Owner:TWinHandle);override;
    procedure CustomPaint;override;
    procedure CreatePerform;override;
    procedure MouseWheelPerform(AButtonControl:cardinal; deltawheel:integer; x, y:integer);override;
    procedure MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);override;
    property Items:TStringListEx read wItems;
    property Selected:integer read wSelected write SetSelected;
    property OnSelected:TWinHandleEvent read wOnSelected write wOnSelected;
  end;

implementation

uses Types, math;

constructor TWinList.Create(Owner:TWinHandle);
begin
  inherited;
  wItems:=TStringListEx.Create;  //TODO destroy
  wTopItem:=0;
  wSelected:=-1;
end;

procedure TWinList.CreatePerform;
begin
  inherited;
end;

procedure TWinList.CustomPaint;
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
    if i=Selected
    then SetDCBrushColor(dc, clFaceBook1)
    else SetDCBrushColor(dc, clWhite);
    SelectObject(dc, GetStockObject(DC_PEN));
    if i=Selected
    then SetDCPenColor(dc, clFaceBook1)
    else SetDCPenColor(dc, clWhite);
    p[0].X:=rtxt.Left-3; p[0].Y:=rtxt.Top;
    p[1].X:=rtxt.Right-1; p[1].Y:=rtxt.Top;
    p[2].X:=rtxt.Right-1; p[2].Y:=rtxt.Bottom-1;
    p[3].X:=rtxt.Left-3; p[3].Y:=rtxt.Bottom-1;
    p[4].X:=rtxt.Left-3; p[4].Y:=rtxt.Top;
    Polygon(dc, p, 5);

    if i<Items.count
    then begin
      if i=Selected
      then begin
        SetTextColor(dc, clWhite);
        SetBkColor(dc, clFaceBook1)
      end
      else begin
        SetTextColor(dc, clBlack);
        SetBkColor(dc, clWhite)
      end;
      SetBkMode(dc, OPAQUE);
      DrawText(dc, pchar(Items[i]), -1, rtxt, DT_SINGLELINE or DT_LEFT or DT_VCENTER);
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

procedure TWinList.MouseWheelPerform(AButtonControl:cardinal; deltawheel:integer; x, y:integer);
begin
  inherited;
  wTopItem:=max(wTopItem-deltawheel,0);
  RedrawPerform
end;

procedure TWinList.SetSelected(AValue:integer);
begin
  if (AValue<Items.count)and(wSelected<>AValue)
  then begin
    wSelected:=AValue;
    RedrawPerform;
    if Assigned(wOnSelected)
    then wOnSelected(self)
  end
end;

procedure TWinList.MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);
begin
  inherited;
  if AButton=mbLeft
  then begin
    SetSelected(wTopItem+(y div 18));
  end
end;

end.
