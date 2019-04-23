unit uisplit;

interface

uses ui, uimpl, uihandle, uicomp, uipanel;

type

  TWinSplit=class(TWinComp)
  private
    wSplitAlign:TAlign;
    wWin1, wWin2:TWinComp;

    wSplitActive:boolean;
  protected
    procedure SplitterPerform(deltaX,deltaY:integer);
  public
    constructor Create(Owner:TWinHandle);override;
    procedure CreatePerform;override;
    procedure SizePerform;override;
    procedure MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);override;
    procedure MouseButtonUpPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);override;
    procedure MouseMovePerform(AButtonControl:cardinal; x,y:integer);override;
    procedure MouseLeavePerform;override;
    procedure CapturePerform(AWindow:HWND);override;
    property SplitAlign:TAlign read wSplitAlign write wSplitAlign;
    property Win1:TWinComp read wWin1;
    property Win2:TWinComp read wWin2;
  end;

implementation

constructor TWinSplit.Create(Owner:TWinHandle);
begin
  inherited;
  wSplitActive:=false;
  wSplitAlign:=alTop;
end;

procedure TWinSplit.CreatePerform;
begin
  inherited;
  wWin1:=TWinPanel.Create(self);
  wWin2:=TWinPanel.Create(self);
  if (wSplitAlign=alTop)or(wSplitAlign=alBottom)
  then begin
    wCursor:=crSizeNS;
    wWin1.Align:=alTop;
    wWin2.Align:=alBottom;
    wWin1.Height:=Height div 2 - 2;
    wWin2.Height:=Height div 2 - 2;
  end
  else begin
    wCursor:=crSizeWE;
    wWin1.Align:=alLeft;
    wWin2.Align:=alRight;
    wWin1.Width:=Width div 2 - 2;
    wWin2.Width:=Width div 2 - 2;
  end;
  wWin1.CreatePerform;
  wWin2.CreatePerform;
end;

procedure TWinSplit.SizePerform;
begin
  case wSplitAlign of
    alTop:wWin2.Height:=Height - wWin1.Height - 4;
    alBottom:wWin1.Height:=Height - wWin2.Height - 4;
    alLeft:wWin2.Width:=Width - wWin1.Width - 4;
    alRight:wWin1.Width:=Width - wWin2.Width - 4;
  end;
  inherited;
end;

procedure TWinSplit.MouseButtonDownPerform(AButton:TMouseButton; AButtonControl:cardinal; x,y:integer);
begin
  inherited;
  if (AButton=mbLeft)
  then begin
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
    case wSplitAlign of
      alTop:wWin1.Height:=y - 2;
      alBottom:wWin2.Height:=Height - y - 2;
      alLeft:wWin1.Width:=x - 2;
      alRight:wWin2.Width:=Width - x - 2;
    end;
    SizePerform;
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
