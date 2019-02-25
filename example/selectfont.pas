unit selectfont;

interface

uses windows, sysutils, ui, uihandle, uiform, uilabel, uiedit, uibutton, uilist, uicheck;

type

  TSelectFontForm=class(TWinModal)
  private
    fnt:HFONT;

    lbl:TWinLabel;
    edt,edt1,edt2:TWinEdit;
    b1:TWinButton;
    b2:TWinButton;
    lst:TWinList;
    ch,ch1,ch2,ch3,ch4,ch5,ch6:TWinCheck;
    procedure Button1Click(Sender:TWinHandle);
    procedure Button2Click(Sender:TWinHandle);
  public
    procedure CreatePerform;override;
  end;

implementation

procedure TSelectFontForm.CreatePerform;
begin
  inherited;
  lbl:=TWinLabel.Create(self);
  lbl.Left:=10;
  lbl.Top:=10;
  lbl.Text:='procedure CreatePerform;override; // éöóêåíãøùçõú ôûâàïðîëäæý';
  lbl.CreatePerform;

  edt:=TWinEdit.Create(self);
  edt.SetBounds(10, 55, 600, 25);
  edt.Text:='procedure CreatePerform;override;';
  edt.CreatePerform;

  b1:=TWinButton.Create(self);
  b1.SetBounds(10, 95, 135, 25);
  b1.Text:='list';
  b1.OnClick:=Button1Click;
  b1.CreatePerform;

  b2:=TWinButton.Create(self);
  b2.SetBounds(150, 95, 135, 25);
  b2.Text:='create';
  b2.OnClick:=Button2Click;
  b2.CreatePerform;

  ch:=TWinCheck.Create(self);
  ch.Left:=10;
  ch.Top:=130;
  ch.Text:='Monospace only';
  ch.CreatePerform;

  lst:=TWinList.Create(self);
  lst.SetBounds(10, 160, 300, 430);
  lst.CreatePerform;

  ch1:=TWinCheck.Create(self);
  ch1.Left:=325;
  ch1.Top:=160;
  ch1.Text:='antialiased';
  ch1.CreatePerform;

  ch2:=TWinCheck.Create(self);
  ch2.Left:=325;
  ch2.Top:=190;
  ch2.Text:='regular';
  ch2.CreatePerform;

  ch3:=TWinCheck.Create(self);
  ch3.Left:=325;
  ch3.Top:=215;
  ch3.Text:='bold';
  ch3.CreatePerform;

  ch4:=TWinCheck.Create(self);
  ch4.Left:=325;
  ch4.Top:=240;
  ch4.Text:='italic';
  ch4.CreatePerform;

  ch5:=TWinCheck.Create(self);
  ch5.Left:=325;
  ch5.Top:=265;
  ch5.Text:='underline';
  ch5.CreatePerform;

  ch6:=TWinCheck.Create(self);
  ch6.Left:=325;
  ch6.Top:=290;
  ch6.Text:='strikeout';
  ch6.CreatePerform;

  edt1:=TWinEdit.Create(self);
  edt1.SetBounds(325, 315, 100, 25);
  edt1.Text:='12';
  edt1.CreatePerform;

  edt2:=TWinEdit.Create(self);
  edt2.SetBounds(325, 345, 100, 25);
  edt2.Text:='';
  edt2.CreatePerform;
end;

function EnumFontsProc(var LogFont: ENUMLOGFONTEX; var TextMetric: TEXTMETRIC; FontType: Integer; data: LPARAM): Integer; stdcall;
var s:string;
begin
  with TSelectFontForm(data) do begin
    if (not ch.Checked)or(ch.Checked)and((LogFont.elfLogFont.lfPitchAndFamily and 3) = 1)
    then begin
      s:=LogFont.elfLogFont.lfFaceName;
      if (lst.Items.Count=0)or(lst.Items[lst.Items.Count-1]<>s)
      then lst.items.add(s);
    end;
  end;
  result:=1;
end;

procedure TSelectFontForm.Button1Click(Sender:TWinHandle);
var
  LFont: TLogFont;
begin
  lst.Items.Clear;
  lst.TopItem:=0;
  FillChar(LFont, sizeof(LFont), 0);
  LFont.lfCharset := DEFAULT_CHARSET;

  BeginPaint;
  EnumFontFamiliesEx(dc, LFont, @EnumFontsProc, integer(self), 0);
  EndPaint;

  lst.RedrawPerform
end;

procedure TSelectFontForm.Button2Click(Sender:TWinHandle);
var q:cardinal;
    w,i,u,s,h:integer;
begin
  if fnt<>0 then DeleteObject(fnt);
  if ch1.Checked then q:=ANTIALIASED_QUALITY else q:=NONANTIALIASED_QUALITY;
  w:=0;
  if ch2.Checked then w:=w+FW_REGULAR;
  if ch3.Checked then w:=w+FW_BOLD;
  i:=0;
  if ch4.Checked then i:=1;
  u:=0;
  if ch5.Checked then u:=1;
  s:=0;
  if ch6.Checked then s:=1;
  if edt1.text<>''
  then h:=-muldiv(strtointdef(edt1.text, 0),96,72)
  else h:=strtointdef(edt2.text, 0);
  fnt:=CreateFont(h,0,0,0,w,i,u,s,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,q,FIXED_PITCH,pchar(lst.Items[lst.selected]));
  lbl.Font:=fnt;
  lbl.RedrawPerform;
  edt.Font:=fnt;
  edt.RedrawPerform;
end;

end.
