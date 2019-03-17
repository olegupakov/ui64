program app;

uses
  main,
//  selectfont,
  ui,
  uihandle,
  uicheck,
  uimpl;

//var f:TAppform;
begin
  InitUI;
  CreateMainWindow(TAppForm.Create(nil), 'TinyUI program').Show;//(SW_SHOWMAXIMIZED);
(*  f:=TAppForm.Create(nil);
  f.Text:='new window';
  f.CreatePerform;
  f.Show();       *)
  ProcessMessages;
  FreeUI;
end.
