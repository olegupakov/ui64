unit uipicture;

interface

uses ui, uimpl, uicomp;

type

  TWinImage=class(TWinComp)
  private
//    wBitmap, wMask : HBITMAP;
  protected
  public
    procedure CreatePerform;override;
    procedure CustomPaint;override;
  end;

implementation

procedure TWinImage.CreatePerform;
begin
  inherited;
  CreateImagePerform;
end;

procedure TWinImage.CustomPaint;
begin
  CustomImagePaint;
end;

end.
 