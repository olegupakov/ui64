unit supportptr;

interface

const
  PtrSIZE=sizeof(pointer); // 32bit = 4, 64bit = 8
  PtrShiftCNT=PtrSIZE shr 1;  // 32bit = 2, 64bit = 4

type
  ppointer=^pointer;
  pint=^integer;
  pbyte=^byte;

procedure PtrMOVE(Source: Pointer; Destination: Pointer; Length: integer);
procedure PtrFILL(Destination: Pointer; Length: integer; Fill: Byte);
function PtrINC(addr:pointer; offset:cardinal):pointer;

implementation

function PtrINC(addr:pointer; offset:cardinal):pointer;
begin
{$IFDEF VER150}
  result:=pointer(cardinal(addr)+offset)
{$ELSE}
  result:=addr+offset
{$ENDIF}
end;

procedure PtrFILL(Destination: Pointer; Length: integer; Fill: Byte);
begin
{$IFDEF VER150}
  FillChar(Destination^, Length, Fill);
{$ELSE}
  fillbyte(Destination^, Length, Fill);
{$ENDIF}
end;

procedure PtrMOVE(Source: Pointer; Destination: Pointer; Length: integer);
begin
  Move(Source^, Destination^, Length);
end;

end.
