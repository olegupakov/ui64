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


    if i<Items.count
    then begin
      if i=Selected
      then begin
        Polygon(clFaceBook1, clFaceBook1, rtxt.Left-2, rtxt.Top, rtxt.Right-1, rtxt.Bottom-1);
        DrawText(rtxt, Items[i], font, clWhite, clFaceBook1, OPAQUE, DT_SINGLELINE or DT_LEFT or DT_VCENTER);
      end
      else begin
        Polygon(bkcolor, bkcolor, rtxt.Left-2, rtxt.Top, rtxt.Right-1, rtxt.Bottom-1);
        DrawText(rtxt, Items[i], font, color, bkcolor, OPAQUE, DT_SINGLELINE or DT_LEFT or DT_VCENTER);
      end;
    end;

    inc(i);
    rtxt.Top:=rtxt.Top+18;
    rtxt.Bottom:=rtxt.Bottom+18;
  end;

  PolyLine(clDkGray, 0, 5, r.Left, r.Top, r.Right-1, r.Bottom-1);

  EndPaint;
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
