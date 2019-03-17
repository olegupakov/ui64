unit supportptr;

interface

const
  PtrSIZE=sizeof(pointer); // 32bit = 4, 64bit = 8
  PtrShiftCNT=PtrSIZE shr 1;  // 32bit = 2, 64bit = 4

type
  ppointer=^pointer;
  pint=^integer;
  pbyte=^byte;

procedure MoveMemory(Destination: Pointer; Source: Pointer; Length: integer);
procedure CopyMemory(Destination: Pointer; Source: Pointer; Length: integer);
procedure FillMemory(Destination: Pointer; Length: integer; Fill: Byte);
procedure ZeroMemory(Destination: Pointer; Length: integer);
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

procedure MoveMemory(Destination: Pointer; Source: Pointer; Length: integer);
begin
  Move(Source^, Destination^, Length);
end;

procedure CopyMemory(Destination: Pointer; Source: Pointer; Length: integer);
begin
  Move(Source^, Destination^, Length);
end;

procedure FillMemory(Destination: Pointer; Length: integer; Fill: Byte);
begin
{$IFDEF VER150}
  FillChar(Destination^, Length, Fill);
{$ELSE}
  fillbyte(Destination^, Length, Fill);
{$ENDIF}
end;

procedure ZeroMemory(Destination: Pointer; Length: integer);
begin
{$IFDEF VER150}
  FillChar(Destination^, Length, 0);
{$ELSE}
  fillbyte(Destination^, Length, 0);
{$ENDIF}
end;

end.
