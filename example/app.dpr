{$APPTYPE GUI}
program app;

uses
  windows,
  main,
  selectfont,
  ui,
  uihandle,
  uicheck;

//var f:TAppform;
begin
  CreateMainWindow(TAppForm.Create(nil), 'TinyUI program').Show;//(SW_SHOWMAXIMIZED);
(*  f:=TAppForm.Create(nil);
  f.Text:='new window';
  f.CreatePerform;
  f.Show();       *)
  ProcessMessages;
end.
