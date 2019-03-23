unit ui;

interface

uses SysUtils, uimpl;

const
  clWhite=$ffffff;
  clBlack=$000000;
  clGray95=$f2f2f2;
  //      $c8d0d4
  clGray98=$fafafa;
//      $e2e1e1
  clGray25=$404040;

  clButton=$7dba5f;

  clDkGray=$808080;
  clWebRoyalBlue=$E16941;
  clWebSlateGray=$908070;
  clWebLightBlue=$E6D8AD;
  clWebLightCyan=$FFFFE0;
  clWebSkyBlue=$EBCE87;

  clFaceBook1=$98593B;
  clFaceBook2=$c39d8b;
  clFaceBook3=$eee3df;
  clFaceBook4=$f7f7f7;
  clPanelBackground1=$eeeeee;
//  clPanelBackground1=$ededf1;
//  clPanelBackground1=$b4beb0;
  //clPanelBackground2=$dddddd;

  clPanelBackground2=$c8d0d4;

//  clPanelBackground2=$e5e5e5;
//  clPanelBackground2=$e5e5e5;

  clButtonInactiveBackground=$e1e1e1;
  clButtonInactiveBorder=$adadad;

(*
  panel background f0f0f0
  button inactive background e1e1e1
  button inactive border adadad
  button under mouse background e5e1fb
  button under mouse border 0078d7
*)

  TRANSPARENT = 1;
  OPAQUE = 2;

  // wm_mousemove
  MK_SHIFT=$0004;    // The SHIFT key is down.
  MK_CONTROL=$0008;  // The CTRL key is down.
  MK_LBUTTON=$0001;  // The left mouse button is down.
  MK_MBUTTON=$0010;  // The middle mouse button is down.
  MK_RBUTTON=$0002;  // The right mouse button is down.
  MK_XBUTTON1=$0020; // The first X button is down.
  MK_XBUTTON2=$0040; // The second X button is down.

  //CW_USEDEFAULT:CARDINAL=$80000000;

  VK_BACK = 8;

type

  TAlign = (alNone, alTop, alBottom, alLeft, alRight, alClient);

function ifthen(Condition: Boolean; ThenExpr, ElseExpr: cardinal):cardinal;overload;
function ifthen(Condition: Boolean; ThenExpr, ElseExpr: string):string;overload;
function muldiv(a,b,c:cardinal):cardinal;

implementation

//{$R ui.res}

function ifthen(Condition: Boolean; ThenExpr, ElseExpr: cardinal):cardinal;
begin
  if condition then result:=ThenExpr else result:=ElseExpr;
end;

function ifthen(Condition: Boolean; ThenExpr, ElseExpr: string):string;
begin
  if condition then result:=ThenExpr else result:=ElseExpr;
end;

function muldiv(a,b,c:cardinal):cardinal;
begin
  result:=(a*b) div c
end;

end.

