unit uipicture;

interface

uses windows, ui, uicomp;

type

  TWinImage=class(TWinComp)
  private
    wBitmap, wMask : HBITMAP;
  protected
  public
    procedure CreatePerform;override;
    procedure CustomPaint;override;
  end;

implementation

function CreateBitmapMask(hbmColour:HBITMAP; crTransparent:COLORREF):HBITMAP;
var
  hdcMem, hdcMem2:HDC;
  hbmMask:HBITMAP;
  bm:BITMAP;
begin
  // Create monochrome (1 bit) mask bitmap.
  GetObject(hbmColour, sizeof(BITMAP), @bm);
  hbmMask := CreateBitmap(bm.bmWidth, bm.bmHeight, 1, 1, nil);

  // Get some HDCs that are compatible with the display driver
  hdcMem := CreateCompatibleDC(0);
  hdcMem2 := CreateCompatibleDC(0);

  SelectObject(hdcMem, hbmColour);
  SelectObject(hdcMem2, hbmMask);

  crTransparent:=GetPixel(hdcMem,0,0);

  // Set the background colour of the colour image to the colour
  // you want to be transparent.
  SetBkColor(hdcMem, crTransparent);

  // Copy the bits from the colour image to the B+W mask... everything
  // with the background colour ends up white while everythig else ends up
  // black...Just what we wanted.
  BitBlt(hdcMem2, 0, 0, bm.bmWidth, bm.bmHeight, hdcMem, 0, 0, SRCCOPY);

  // Take our new mask and use it to turn the transparent colour in our
  // original colour image to black so the transparency effect will
  // work right.
  BitBlt(hdcMem, 0, 0, bm.bmWidth, bm.bmHeight, hdcMem2, 0, 0, SRCINVERT);

  // Clean up.
  DeleteDC(hdcMem);
  DeleteDC(hdcMem2);

  result:=hbmMask;
end;

procedure TWinImage.CreatePerform;
begin
  inherited;
  wBitmap:=LoadBitmap(system.MainInstance, 'BAD');  //todo deleteobject
  wMask:=CreateBitmapMask(wBitmap, clWhite);
end;

procedure TWinImage.CustomPaint;
var
  img : hdc;
begin
  BeginPaint;
  img:=CreateCompatibleDC(dc);

  SelectObject(img, wMask);
  BitBlt(dc,0,0,50,50,img,0,0,SRCAND);

  SelectObject(img, wBitmap);
  BitBlt(dc,0,0,50,50,img,0,0,SRCPAINT);

  DeleteDC(img);
  EndPaint;
end;

end.
 