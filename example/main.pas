unit main;

interface
uses Windows, Messages, SysUtils,
     ui, uihandle, uilabel, uiform, uipanel, uiedit, uipicture, uisplit,
     uibutton, uilist, uicombo, uimemo, uiscroll;

type
  TAppForm=class(TWinForm)
  private
    c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c21,c22:TWinHandle;
    c18:TWinList;
    c19:TWinCombo;
    c20:TWinMemo;
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
  c1.Name:='c1';
  c1.SetBounds(10,10,600,550);
  c1.Align:=alNone;
  c1.CreatePerform;

  c2:=TWinPanel.Create(c1);
  c2.Name:='c2';
  c2.SetBounds(20,20,300,250);
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

  c18:=TWinList.Create(c2);
  c18.name:='list1';
  c18.Color:=clBlack;
  c18.SetBounds(10,75,200,135);
  c18.Align:=alNone;
  c18.CreatePerform;
  c18.Items.Add('item1');
  c18.Items.Add('item2');
  c18.Items.Add('item3');
  c18.Items.Add('item4');
  c18.Items.Add('item5');
  c18.Items.Add('item6');
  c18.Items.Add('item7');
  c18.Items.Add('item8');
  c18.Items.Add('item9');
  c18.Items.Add('item10');
  c18.Items.Add('item11');
  c18.Items.Add('item12');
  c18.Selected:=2;

  c19:=TWinCombo.Create(c2);
  c19.name:='combo1';
  c19.Color:=clBlack;
  c19.SetBounds(10,215,200,25);
  c19.Align:=alNone;
  c19.CreatePerform;

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
  c4.Name:='c4';
  c4.SetBounds(20,20,250,150);
  c4.Align:=alClient;
  c4.CreatePerform;


  c7:=TWinPanel.Create(c1);
  c7.Name:='c7';
  c7.Color:=clPanelBackground2;
  c7.SetBounds(10,10,400,250);
  c7.Align:=alBottom;
  c7.CreatePerform;

  c10:=TWinSplit.Create(c7);
  c10.width:=3;// SetBounds(15,15,100,200);
  c10.Align:=alRight;
  c10.CreatePerform;

  c8:=TWinPanel.Create(c7);
  c8.Name:='c8';
  c8.Color:=clPanelBackground2;
  c8.SetBounds(10,10,200,100);
  c8.Align:=alRight;
  c8.CreatePerform;

  c11:=TWinPanel.Create(c8);
  c11.Name:='c11';
  c11.Color:=clPanelBackground2;
  c11.SetBounds(10,10,400,100);
  c11.Align:=alTop;
  c11.CreatePerform;

  c12:=TWinSplit.Create(c8);
  c12.Height:=3;// SetBounds(15,15,100,200);
  c12.Align:=alTop;
  c12.CreatePerform;

  c13:=TWinPanel.Create(c11);
  c13.Name:='c13';
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
  c15.Name:='c15';
  c15.Color:=clPanelBackground2;
  c15.SetBounds(10,10,400,150);
  c15.Align:=alTop;
  c15.CreatePerform;

  c6:=TWinSplit.Create(self);
  c6.Height:=3;
  c6.Width:=3;
  c6.Align:=alTop;
  c6.CreatePerform;

  c21:=TWinPanel.Create(self);
  c21.Name:='c21';
  c21.Color:=clPanelBackground2;
  c21.Height:=45;// SetBounds(15,15,100,200);
  c21.Align:=alBottom;
  c21.MinHeight:=45;
  c21.CreatePerform;

  c3:=TWinButton.Create(c21);
  c3.Color:=clPanelBackground1;//clButtonInactiveBackground;
  c3.SetBounds(10,10,75,25);
  c3.Align:=alNone;
  c3.Text:='Comp 3';
  c3.OnClick:=Button1Click;
  c3.CreatePerform;

  c17:=TWinButton.Create(c21);
  c17.Color:=clPanelBackground1;//clButtonInactiveBackground;
  c17.SetBounds(100,10,175,25);
  c17.Align:=alNone;
  c17.Text:='Comp 4';
  c17.OnClick:=Button2Click;
  c17.CreatePerform;

  c20:=TWinMemo.Create(c7);
//  c17.Color:=clPanelBackground1;//clButtonInactiveBackground;
  c20.SetBounds(100,10,250,25);
  c20.Align:=alLeft;
  c20.Lines.Add('line 0');
  c20.Lines.Add('line 1');
  c20.Lines.Add('line 2');
  c20.Lines.Add('line 3');
  c20.Lines.Add('line 4');
  c20.Lines.Add('line 5');
  c20.Lines.Add('line 6');
  c20.Lines.Add('line 7');
  c20.Lines.Add('line 8');
  c20.Lines.Add('line 9');
  c20.Lines.Add('line 10');
  c20.Lines.Add('line 11');
  c20.Lines.Add('line 12');
  c20.Lines.Add('line 13');
  c20.Lines.Add('line 14');
  c20.CreatePerform;

  c22:=TWinScroll.Create(c7);
  c22.Width:=20;
//  c22.Height:=10;
  c22.Align:=alLeft;
  c22.CreatePerform;
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
  then MessageBox(window, 'close qwe qw eq we qw eq weqweqwe qew eqwewe         qqqqqwe qweqweqweqweqeqweqweqweqweqweqeqweqwe'+
  'qwe close qwe qw eq we qw eq weqweqwe qew eqwewe         qqqqqwe qweqweqweqweqeqweqweqweqweqweqeqweqweqwe 5 eqweqeqweqweqwe 5eqwe'+
  'qeqweqweqwe 5eqweqeqweqweqwe 5', 'n n n', MB_ICONQUESTION or MB_YESNO);
  c3.Text:='Comp3!';
  c3.RedrawPerform;
end;

procedure TAppForm.Button2Click(Sender:TWinHandle);
//var dpix,dpiy:cardinal;
var v:integer;
    dc:HDC;
    ps:PAINTSTRUCT;
begin
  v:=GetSystemMetrics(SM_CMONITORS);
  c20.Lines.Insert(0, 'SM_CMONITORS '+inttostr(v));
  v:=GetSystemMetrics(SM_CXCURSOR);
  c20.Lines.Insert(0, 'SM_CXCURSOR '+inttostr(v));
  v:=GetSystemMetrics(SM_CYCURSOR);
  c20.Lines.Insert(0, 'SM_CYCURSOR '+inttostr(v));
  v:=GetSystemMetrics(SM_CXFULLSCREEN);
  c20.Lines.Insert(0, 'SM_CXFULLSCREEN '+inttostr(v));
  v:=GetSystemMetrics(SM_CYFULLSCREEN);
  c20.Lines.Insert(0, 'SM_CYFULLSCREEN '+inttostr(v));
  v:=GetSystemMetrics(SM_CXHSCROLL);
  c20.Lines.Insert(0, 'SM_CXHSCROLL '+inttostr(v));
  v:=GetSystemMetrics(SM_CYHSCROLL);
  c20.Lines.Insert(0, 'SM_CYHSCROLL '+inttostr(v));

  dc:=BeginPaint(window, ps);
  v:=GetDeviceCaps(dc, HORZSIZE);
  c20.Lines.Insert(0, 'HORZSIZE '+inttostr(v));
  v:=GetDeviceCaps(dc, VERTSIZE);
  c20.Lines.Insert(0, 'VERTSIZE '+inttostr(v));
  v:=GetDeviceCaps(dc, LOGPIXELSX);
  c20.Lines.Insert(0, 'LOGPIXELSX '+inttostr(v));
  v:=GetDeviceCaps(dc, LOGPIXELSY);
  c20.Lines.Insert(0, 'LOGPIXELSY '+inttostr(v));
  EndPaint(window, ps);

//  EnumDisplayDevices(

  c20.RedrawPerform;
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
