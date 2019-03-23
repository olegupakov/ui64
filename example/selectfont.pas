unit selectfont;

interface

uses sysutils, ui, uimpl, uihandle, uiform, uilabel, uiedit, uibutton, uilist, uicheck;

type

  TSelectFontForm=class(TWinModal)
  private
    fnt:HFONT;

    lbl:TWinLabel;
    edt,edt1,edt2,edt3:TWinEdit;
    b1:TWinButton;
    b2:TWinButton;
    lst:TWinList;
    ch,ch1,ch20,ch21,ch22,ch4,ch5,ch6:TWinCheck;
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
  lbl.SetBounds(10,10,10,10);
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

  edt3:=TWinEdit.Create(self);
  edt3.SetBounds(10, 130, 100, 25);
  edt3.Text:='';
  edt3.CreatePerform;

  ch:=TWinCheck.Create(self);
  ch.SetBounds(130, 130, 100, 25);
  ch.Text:='Monospace only';
  ch.CreatePerform;

  lst:=TWinList.Create(self);
  lst.SetBounds(10, 160, 300, 430);
  lst.CreatePerform;

  ch1:=TWinCheck.Create(self);
  ch1.SetBounds(325, 160, 100, 25);
  ch1.Text:='antialiased';
  ch1.CreatePerform;

  ch20:=TWinCheck.Create(self);
  ch20.SetBounds(325, 190, 100, 25);
  ch20.Text:='light';
  ch20.CreatePerform;

  ch21:=TWinCheck.Create(self);
  ch21.SetBounds(325, 215, 100, 25);
  ch21.Text:='regular';
  ch21.CreatePerform;

  ch22:=TWinCheck.Create(self);
  ch22.SetBounds(325, 240, 100, 25);
  ch22.Text:='bold';
  ch22.CreatePerform;

  ch4:=TWinCheck.Create(self);
  ch4.SetBounds(325, 340, 100, 25);
  ch4.Text:='italic';
  ch4.CreatePerform;

  ch5:=TWinCheck.Create(self);
  ch5.SetBounds(325, 365, 100, 25);
  ch5.Text:='underline';
  ch5.CreatePerform;

  ch6:=TWinCheck.Create(self);
  ch6.SetBounds(325, 390, 100, 25);
  ch6.Text:='strikeout';
  ch6.CreatePerform;

  edt1:=TWinEdit.Create(self);
  edt1.SetBounds(325, 415, 100, 25);
  edt1.Text:='12';
  edt1.CreatePerform;

  edt2:=TWinEdit.Create(self);
  edt2.SetBounds(325, 445, 100, 25);
  edt2.Text:='';
  edt2.CreatePerform;
end;

(*
function EnumFontsProc(var LogFont: ENUMLOGFONTEX; var TextMetric: TEXTMETRIC; FontType: Integer; data: LPARAM): Integer; stdcall;
var s:string;
begin
  with TSelectFontForm(data) do begin
    s:=LogFont.elfLogFont.lfFaceName;
    if ((not ch.Checked)or(ch.Checked)and((LogFont.elfLogFont.lfPitchAndFamily and 3) = 1))
      and ((edt3.text='')or(pos(uppercase(edt3.text), uppercase(s))>0))
    then begin
      if (lst.Items.Count=0)or(lst.Items[lst.Items.Count-1]<>s)
      then lst.items.add(s);
    end;
  end;
  result:=1;
end;
*)

procedure TSelectFontForm.Button1Click(Sender:TWinHandle);
//var
  //LFont: TLogFont;
begin
(*
lst.Items.Clear;
  lst.TopItem:=0;
  FillChar(LFont, sizeof(LFont), 0);
  LFont.lfCharset := DEFAULT_CHARSET;

  BeginPaint;
  EnumFontFamiliesEx(dc, LFont, @EnumFontsProc, integer(self), 0);
  EndPaint;

  lst.RedrawPerform
*)
end;

procedure TSelectFontForm.Button2Click(Sender:TWinHandle);
//var q:cardinal;
  //  w,i,u,s,h:integer;
begin
(*
if fnt<>0 then DeleteObject(fnt);
  if ch1.Checked then q:=ANTIALIASED_QUALITY else q:=NONANTIALIASED_QUALITY;
  w:=0;
  if ch20.Checked then w:=w+FW_LIGHT;
  if ch21.Checked then w:=w+FW_REGULAR;
  if ch22.Checked then w:=w+FW_BOLD;
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
*)
end;

end.
