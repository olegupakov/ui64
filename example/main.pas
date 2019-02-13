unit main;

interface
uses Windows, Messages, SysUtils, ui, uihandle, uilabel, uiform, uipanel, uiedit, uipicture, uisplit, uibutton;

type
  TAppForm=class(TWinForm)
  private
    c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17:TWinHandle;
    procedure Button1Click(Sender:TWinHandle);
    procedure Button2Click(Sender:TWinHandle);
    procedure Button3Click(Sender:TWinHandle);
  public
    procedure CreatePerform;override;
  end;

implementation

procedure TAppForm.CreatePerform;
begin
  inherited;
  name:='form1';

  c1:=TWinPanel.Create(self);
  c1.SetBounds(10,10,600,550);
  c1.Align:=alNone;
  c1.CreatePerform;

  c2:=TWinPanel.Create(c1);
  c2.SetBounds(20,20,300,150);
  c2.Align:=alLeft;
  c2.CreatePerform;

  c4:=TWinLabel.Create(c2);
  c4.Color:=clBlack;
  c4.Text:='La&bel 1  ';
  c4.SetBounds(10,10,0,0);
  c4.Align:=alNone;
  c4.CreatePerform;

  c5:=TWinEdit.Create(c2);
  c5.name:='edit1';
  c5.Color:=clBlack;
  c5.Text:='Edit1';
  c5.SetBounds(10,40,200,25);
  c5.Align:=alNone;
  c5.CreatePerform;

  c16:=TWinImage.Create(c2);
  c16.SetBounds(250,50,16,16);
  c16.Align:=alNone;
  c16.CreatePerform;
  
  c3:=TWinSplit.Create(c1);
  c3.Width:=3;
  c3.Height:=3;
  c3.Align:=alLeft;
  c3.CreatePerform;

  c4:=TWinPanel.Create(c1);
  c4.SetBounds(20,20,250,150);
  c4.Align:=alClient;
  c4.CreatePerform;


  c7:=TWinPanel.Create(c1);
  c7.Color:=clPanelBackground2;
  c7.SetBounds(10,10,400,350);
  c7.Align:=alBottom;
  c7.CreatePerform;

  c10:=TWinSplit.Create(c7);
  c10.width:=3;// SetBounds(15,15,100,200);
  c10.Align:=alRight;
  c10.CreatePerform;

  c8:=TWinPanel.Create(c7);
  c8.Color:=clPanelBackground2;
  c8.SetBounds(10,10,400,250);
  c8.Align:=alRight;
  c8.CreatePerform;

  c11:=TWinPanel.Create(c8);
  c11.Color:=clPanelBackground2;
  c11.SetBounds(10,10,400,100);
  c11.Align:=alTop;
  c11.CreatePerform;

  c12:=TWinSplit.Create(c8);
  c12.Height:=3;// SetBounds(15,15,100,200);
  c12.Align:=alTop;
  c12.CreatePerform;

  c13:=TWinPanel.Create(c11);
  c13.Color:=clPanelBackground2;
  c13.SetBounds(10,10,125,100);
  c13.Align:=alLeft;
  c13.CreatePerform;

  c14:=TWinSplit.Create(c11);
  c14.Width:=3;// SetBounds(15,15,100,200);
  c14.Align:=alLeft;
  c14.CreatePerform;

  c9:=TWinEdit.Create(c13);
  c9.Color:=clBlack;
  c9.Text:='Edit2';
  c9.SetBounds(10,10,100,25);
  c9.Align:=alNone;
  c9.CreatePerform;      


  c15:=TWinPanel.Create(self);
  c15.Color:=clPanelBackground2;
  c15.SetBounds(10,10,400,150);
  c15.Align:=alTop;
  c15.CreatePerform;

  c6:=TWinSplit.Create(self);
  c6.Height:=3;
  c6.Width:=3;
  c6.Align:=alTop;
  c6.CreatePerform;

  c2:=TWinPanel.Create(self);
  c2.Color:=clPanelBackground2;
  c2.Height:=45;// SetBounds(15,15,100,200);
  c2.Align:=alBottom;
  c2.MinHeight:=45;
  c2.CreatePerform;

  c3:=TWinButton.Create(c2);
  c3.Color:=clPanelBackground1;//clButtonInactiveBackground;
  c3.SetBounds(10,10,75,25);
  c3.Align:=alNone;
  c3.Text:='Comp 3';
  c3.OnClick:=Button1Click;
  c3.CreatePerform;

  c17:=TWinButton.Create(c2);
  c17.Color:=clPanelBackground1;//clButtonInactiveBackground;
  c17.SetBounds(100,10,175,25);
  c17.Align:=alNone;
  c17.Text:='Comp 4';
  c17.OnClick:=Button2Click;
  c17.CreatePerform;
end;

procedure TAppForm.Button1Click(Sender:TWinHandle);
var f:TWinModal;
    c1,c2:TWinHandle;
begin
//  MessageBox(0, 'click', nil, mb_Ok);
  //c5.SetFocus
  f:=TWinModal.Create(self);  //todo destroy
  f.Text:='Modal Window';
  f.SetBounds(50,50,300,300);
  f.CreatePerform;

  c1:=TWinEdit.Create(f);
  c1.Color:=clBlack;
  c1.Text:='Edit3';
  c1.SetBounds(10,10,100,25);
  c1.Align:=alNone;
  c1.CreatePerform;

  c2:=TWinButton.Create(f);
  c2.Color:=clPanelBackground1;//clButtonInactiveBackground;
  c2.SetBounds(10,45,75,25);
  c2.Align:=alNone;
  c2.Text:='Cancel';
  c2.OnClick:=Button3Click;
  c2.CreatePerform;

  if f.ShowModal=MR_CLOSE
  then MessageBox(window, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer at nisl vel dolor cursus suscipit. ' +
            'Donec et massa sollicitudin, vehicula nisi a, commodo dolor. In id auctor tellus, vel bibendum ex.', 'Lorem', MB_ICONQUESTION or MB_YESNO);
  c3.Text:='Comp3!';
  c3.RedrawPerform;
end;

procedure TAppForm.Button2Click(Sender:TWinHandle);
//var dpix,dpiy:cardinal;
begin
(*  GetDpiForMonitor(
  HMONITOR         hmonitor,
  MONITOR_DPI_TYPE dpiType,
  UINT             *dpiX,
  UINT             *dpiY
  c17.text:=inttostr(dpix)+' '+inttostr(dpiy);
  c17.RedrawPerform;    *)
end;

procedure TAppForm.Button3Click(Sender:TWinHandle);
begin
  with TWinModal(Sender.Parent) do begin
    ModalResult:=MR_CANCEL;
    Close
  end;
end;

end.
