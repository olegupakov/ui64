unit uisplit;

interface

uses ui, uimpl, uihandle, uicomp;

type

  TWinSplit=class(TWinComp)
  private
    wSplitActive:boolean;
    last_x_down, last_y_down:integer;
  protected
    procedure SplitterPerform(deltaX,deltaY:integer);
  public
    procedure CreatePerform;override;
    procedure MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);override;
    procedure MouseButtonUpPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);override;
    procedure MouseMovePerform(AButtonControl:cardinal; x,y:integer);override;
    procedure MouseLeavePerform;override;
    procedure CapturePerform(AWindow:HWND);override;
  end;

implementation

procedure TWinSplit.CreatePerform;
begin
  inherited;
  wSplitActive:=false;
  if (wAlign=alTop)or(wAlign=alBottom)
  then wCursor:=crSizeNS
  else wCursor:=crSizeWE;
end;

procedure TWinSplit.MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);
var p:tpoint;
begin
  inherited;
  if (AButton=mbLeft)
  then begin
    p.x:=x;
    p.y:=y;
    GetCursorPos(p);
    last_x_down:=p.x;
    last_y_down:=p.y;
    wSplitActive:=true;
    SetCapture(window);
  end;
end;

procedure TWinSplit.MouseButtonUpPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);
begin
  inherited;
  wSplitActive:=false;
  ReleaseCapture();
end;

procedure TWinSplit.CapturePerform(AWindow:HWND);
begin
  inherited;
  wSplitActive := window = AWindow;
end;

procedure TWinSplit.MouseMovePerform(AButtonControl:cardinal; x,y:integer);
var p:tpoint;
begin
  inherited;
  if wSplitActive
  then begin
    p.x:=x;
    p.y:=y;
    GetCursorPos(p);
    SplitterPerform(last_x_down-p.x, last_y_down-p.y);
    last_x_down:=p.x;
    last_y_down:=p.y;
  end;
end;

procedure TWinSplit.MouseLeavePerform;
begin
  inherited;
end;

procedure TWinSplit.SplitterPerform(deltaX,deltaY:integer);
var sp,i:integer;
    comp:TWinHandle;
begin
  sp:=-1;
  for i:=0 to Parent.ChildHandleList.Count-1 do begin
    comp:=TWinHandle(Parent.ChildHandleList[i]);
    if comp=self
    then begin
      sp:=i;
      break
    end;
  end;
  if sp>-1
  then begin
    //todo        if comp.Height-deltaY<comp.MinHeight then exit;
    case align of
      alLeft:begin
        for i:=sp-1 downto 0 do begin
          comp:=TWinHandle(Parent.ChildHandleList[i]);
          if comp.Align=alLeft
          then begin
            comp.Width:=comp.Width-deltaX;
            comp.SetPosPerform;
            comp.SizePerform;
            break
          end;
        end;
        for i:=sp+1 to Parent.ChildHandleList.Count-1 do begin
          comp:=TWinHandle(Parent.ChildHandleList[i]);
          if comp.Align=alLeft
          then begin
            comp.Left:=comp.Left-deltaX;
            comp.SetPosPerform;
            comp.SizePerform;
          end;
          if comp.Align=alClient
          then begin
            comp.Left:=comp.Left-deltaX;
            comp.Width:=comp.Width+deltaX;
            comp.SetPosPerform;
            comp.SizePerform;
            break
          end;
        end;
        Left:=Left-deltaX;
      end;
      alTop:begin
        for i:=sp-1 downto 0 do begin
          comp:=TWinHandle(Parent.ChildHandleList[i]);
          if comp.Align=alTop
          then begin
            comp.Height:=comp.Height-deltaY;
            comp.SetPosPerform;
            comp.SizePerform;
            break
          end;
        end;
        for i:=sp+1 to Parent.ChildHandleList.Count-1 do begin
          comp:=TWinHandle(Parent.ChildHandleList[i]);
          if comp.Align=alTop
          then begin
            comp.Top:=comp.Top-deltaY;
            comp.SetPosPerform;
            comp.SizePerform;
          end;
          if comp.Align=alClient
          then begin
            comp.Top:=comp.Top-deltaY;
            comp.Height:=comp.Height+deltaY;
            comp.SetPosPerform;
            comp.SizePerform;
            break
          end;
        end;
        Top:=Top-deltaY;
      end;
      alBottom:begin
        for i:=sp-1 downto 0 do begin
          comp:=TWinHandle(Parent.ChildHandleList[i]);
          if comp.Align=alBottom
          then begin
            comp.Top:=comp.Top-deltaY;
            comp.Height:=comp.Height+deltaY;
            comp.SetPosPerform;
            comp.SizePerform;
          end;
          if comp.Align=alClient
          then begin
            comp.Height:=comp.Height-deltaY;
            comp.SetPosPerform;
            comp.SizePerform;
            break
          end;
        end;
        for i:=sp+1 to Parent.ChildHandleList.Count-1 do begin
          comp:=TWinHandle(Parent.ChildHandleList[i]);
          if comp.Align=alBottom
          then begin
            comp.Top:=comp.Top-deltaY;
            comp.Height:=comp.Height+deltaY;
            comp.SetPosPerform;
            comp.SizePerform;
            break
          end;
        end;
        Top:=Top-deltaY;
      end;
      alRight:begin
        for i:=sp-1 downto 0 do begin
          comp:=TWinHandle(Parent.ChildHandleList[i]);
          if comp.Align=alRight
          then begin
            comp.Left:=comp.Left-deltaX;
            comp.SetPosPerform;
            comp.SizePerform;
          end;
          if comp.Align=alClient
          then begin
            comp.Width:=comp.Width-deltaX;
            comp.SetPosPerform;
            comp.SizePerform;
            break
          end;
        end;
        for i:=sp+1 to Parent.ChildHandleList.Count-1 do begin
          comp:=TWinHandle(Parent.ChildHandleList[i]);
          if comp.Align=alRight
          then begin
            comp.Left:=comp.Left-deltaX;
            comp.Width:=comp.Width+deltaX;
            comp.SetPosPerform;
            comp.SizePerform;
            break
          end;
        end;
        Left:=Left-deltaX;
      end;
    end;
    SetPosPerform;
    SizePerform;
  end;
end;

end.
