{$APPTYPE GUI}
program app;

uses
  windows,
  main,
  ui,
  uihandle,
  uilist in '..\sdk\ui\uilist.pas',
  uicombo in '..\sdk\ui\uicombo.pas';

//var f:TAppform;
begin
  CreateMainWindow(TAppForm.Create(nil), 'TinyUI program').Show;//(SW_SHOWMAXIMIZED);
(*  f:=TAppForm.Create(nil);
  f.Text:='new window';
  f.CreatePerform;
  f.Show();       *)
  ProcessMessages;
end.
