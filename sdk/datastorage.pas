unit DataStorage;

interface

uses Classes, SysUtils, math, supportptr;

type
  PMemBlock=^TMemBlock;
  TMemBlock=record
              Count, MaxCount:integer;
              Addr:array[0..maxint shr PtrShiftCNT-100] of pointer;
            end;

  TListEx = class
  private
    FCount:integer;
    Mem:PMemBlock;

    Cache:record index, i, offset:integer; end;

    procedure GetCache(index:integer; var i, offset:integer);
    procedure SetCache(index, i, offset:integer);

    procedure CreateBlockMem(var mem:PMemBlock; size:integer);
    procedure FreeBlockMem(mem:PMemBlock);
    procedure ExtendBlockMem(var mem:PMemBlock; size:integer);
     function GetBlockMemItem(mem:PMemBlock; index:integer):pointer;
    procedure AddBlockItem(mem:PMemBlock; Item:pointer);
    procedure InsertBlockItem(mem:PMemBlock; index:integer; Item:pointer);
    procedure DeleteBlockItem(mem:PMemBlock; index:integer);
    procedure SplitBlockMemItem(source:PMemBlock; var destination:PMemBlock);
    function  GetMemoryAddr(index:integer):pointer;
  protected
    function  Get(index:integer):pointer;
    procedure Put(index:integer; item:pointer);
  public
    constructor Create; virtual;
     destructor Destroy; override;

    procedure Clear;
     function Add(Item:pointer):integer;
    procedure Delete(index:integer);
    procedure Insert(Index: Integer; Item: pointer);

    property Count:integer read FCount;
    property Items[index:integer]:pointer read Get write Put; default;
  end;

  TStringListEx=class
  private
    ItemList, MemList:TListEx;
    MemVolume:integer;
    MemPointer:pointer;

     function Get(Index:integer):string;
    procedure Put(Index:integer; const Value:string);
    procedure ClearValue(Index:integer);
     function GetCount:integer;
  public
    constructor Create; virtual;
     destructor Destroy; override;

    procedure Clear;
     function Add(value:string):integer;
    procedure Delete(Index:integer);
    procedure Insert(Index:integer; value:string);

    procedure Assign(List:TStringListEx);

    property Count:integer read GetCount;
    property Strings[index:integer]:string read Get write Put; default;
  end;

  TDataStorage=class
  private
    FColCount:integer;
    ItemList:TStringListEx;

     function GetValue(row, col:integer):string;
    procedure SetValue(row, col:integer; const ItemValue:string);
     function GetRowCount:integer;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Clear;
    procedure AddRow;
    procedure DeleteRow(row:integer);
    procedure InsertRow(row:integer);

    property ColCount:integer read FColCount write FColCount;
    property Value[row, col:integer]:string read GetValue write SetValue;
    property RowCount:integer read GetRowCount;
  end;

implementation

Const
  MemBlockInc=1024;
  MemBlockMaxInc=256*1024;

  BlockSize=1024*1024;
  MaxSize=255; // byte+string or getmem(byte+integer+string) 

{TListEx}

constructor TListEx.Create;
begin
  inherited;
  Cache.index:=-1;
  CreateBlockMem(mem, MemBlockInc);
  FCount:=0;
end;

destructor TListEx.Destroy;
begin
  Clear;
  FreeBlockMem(mem);
  inherited
end;

procedure TListEx.CreateBlockMem(var mem:PMemBlock; size:integer);
begin
  GetMem(mem, sizeof(integer) shl 1 + size shl PtrShiftCNT);
  mem.Count:=0;
  mem.MaxCount:=size;
end;

procedure TListEx.FreeBlockMem(mem:PMemBlock);
begin
  FreeMem(mem);
end;

procedure TListEx.ExtendBlockMem(var mem:PMemBlock; size:integer);
var m:PMemBlock;
begin
  m:=mem;
  CreateBlockMem(mem, size);
  movememory(@mem.Addr[0], @m.Addr[0], m.Count shl PtrShiftCNT);
  mem.Count:=m.Count;
  FreeBlockMem(m)
end;

procedure TListEx.AddBlockItem(mem:PMemBlock; Item:pointer);
begin
  if mem.count<mem.maxcount
  then begin
    mem.Addr[mem.count]:=Item;
    inc(mem.count)
  end
end;

procedure TListEx.InsertBlockItem(mem:PMemBlock; index:integer; Item:pointer);
begin
  if (index>=0)and(mem.count<mem.maxcount)
  then begin
    if index<mem.count
    then movememory(@mem.Addr[index+1], @mem.Addr[index], (mem.Count-index) shl PtrShiftCNT);
    mem.Addr[index]:=Item;
    inc(mem.count)
  end
end;

procedure TListEx.DeleteBlockItem(mem:PMemBlock; index:integer);
begin
  if (index>=0)and(index<mem.count)
  then begin
    if index<mem.Count-1
    then movememory(@mem.Addr[index], @mem.Addr[index+1], (mem.Count-index) shl PtrShiftCNT);
    dec(mem.count)
  end
end;

procedure TListEx.SplitBlockMemItem(source:PMemBlock; var destination:PMemBlock);
var cnt:integer;
begin
  cnt:=source.Count div 2;
  CreateBlockMem(destination, source.MaxCount);
  movememory(@destination.Addr[0], @source.Addr[cnt+1], cnt shl PtrShiftCNT);
  dec(source.Count, cnt);
  destination.Count:=cnt;
end;

function TListEx.GetBlockMemItem(mem:PMemBlock; index:integer):pointer;
begin
  if (index>=0)and(index<mem.Count)
  then result:=mem.Addr[index]
  else result:=nil
end;

procedure TListEx.GetCache(index:integer; var i, offset:integer);
begin
  if (Cache.index=-1) or (Cache.index>index)
  then begin
    i:=0; offset:=0
  end
  else begin
    i:=Cache.i; offset:=Cache.offset
  end
end;

procedure TListEx.SetCache(index, i, offset:integer);
begin
  Cache.index:=index; Cache.i:=i; Cache.offset:=offset
end;

function TListEx.GetMemoryAddr(index:integer):pointer;
var m:PMemBlock;
    i,offset:integer;
begin
  GetCache(index, i, offset);
  while i<mem.Count do begin
    m:=GetBlockMemItem(mem, i);
    if (index>=offset)and(index<offset+m.Count)
    then begin
      SetCache(index, i, offset);
      result:=@m.Addr[index-offset];
      exit
    end;
    inc(offset, m.count);
    inc(i);
  end;
  result:=nil
end;

procedure TListEx.Clear;
var i:integer;
    m:PMemBlock;
begin
  for i:=0 to mem.Count-1 do begin
    m:=GetBlockMemItem(mem, i);
    FreeBlockMem(m);
  end;
  Cache.index:=-1;
  mem.Count:=0;
  FCount:=0;
end;

function TListEx.Get(index:integer):pointer;
var p:pointer;
begin
  p:=GetMemoryAddr(index);
  if p<>nil
  then result:=ppointer(p)^
end;

procedure TListEx.Put(index:integer; item:pointer);
var p:pointer;
begin
  p:=GetMemoryAddr(index);
  if p<>nil
  then ppointer(p)^:=item
end;

function TListEx.Add(Item:pointer):integer;
var m:PMemBlock;
begin
  m:=GetBlockMemItem(mem, mem.Count-1);
  if m=nil
  then begin
    CreateBlockMem(m, MemBlockInc);
    AddBlockItem(mem, m);
  end
  else 
  if m.Count>m.MaxCount-64
  then begin
    CreateBlockMem(m, min(m.MaxCount shl 1, MemBlockMaxInc));
    if mem.Count=mem.MaxCount
    then ExtendBlockMem(mem, mem.MaxCount+MemBlockInc);
    AddBlockItem(mem, m);
  end;
  AddBlockItem(m, Item);
  result:=FCount;
  inc(FCount);
end;

procedure TListEx.Insert(Index: Integer; Item: Pointer);
var m,ms:PMemBlock;
    i,offset:integer;
begin
  GetCache(index, i, offset);
  while i<mem.Count do begin
    m:=GetBlockMemItem(mem, i);
    if (index>=offset)and(index<offset+m.Count)
    then begin
      if m.Count<m.MaxCount
      then InsertBlockItem(m, index-offset, Item)
      else begin
        SplitBlockMemItem(m, ms);
        if mem.Count=mem.MaxCount
        then ExtendBlockMem(mem, mem.MaxCount+MemBlockInc);
        InsertBlockItem(mem, i+1, ms);
        continue
      end;
      SetCache(index, i, offset);
      inc(FCount);
      exit
    end;
    inc(offset, m.count);
    inc(i);
  end;
  Add(Item)
end;

procedure TListEx.Delete(index:integer);
var m:PMemBlock;
    i,offset:integer;
begin
  GetCache(index, i, offset);
  while i<mem.Count do begin
    m:=GetBlockMemItem(mem, i);
    if (index>=offset)and(index<offset+m.Count)
    then begin
      SetCache(index, i, offset);
      DeleteBlockItem(m, index-offset);
      dec(FCount);
      exit
    end;
    inc(offset, m.count);
    inc(i);
  end;
end;

{TStringListEx}

constructor TStringListEx.Create;
begin
  inherited;
  ItemList:=TListEx.Create;
  MemList:=TListEx.Create;
  MemVolume:=0;
end;

destructor TStringListEx.Destroy;
begin
  Clear;
  ItemList.Free;
  MemList.Free;
  inherited
end;

function TStringListEx.Get(index:integer):string;
var p:pointer;
    len:integer;
begin
  p:=ItemList[index];
  if p=nil
  then result:=''
  else begin
    if pbyte(p)^ = MaxSize
    then begin
      len:=pint(PtrINC(p, sizeof(byte)))^;
      SetLength(result, len);
      CopyMemory(pchar(result), PtrINC(p, sizeof(byte)+sizeof(integer)), len);
    end 
    else begin
      len:=pbyte(p)^;
      SetLength(result, len);
      CopyMemory(pchar(result), PtrINC(p, sizeof(byte)), len);
    end
  end
end;

procedure TStringListEx.ClearValue(Index:integer);
var p:pointer;
begin
  p:=ItemList[Index];
  if (p <> nil) and (pbyte(p)^ = MaxSize)
  then freemem(p)
end;

procedure TStringListEx.Put(index:integer; const Value:string);
var p:pointer;
    len:integer;
begin
  ClearValue(index);
  len:=length(Value);
  if len=0
  then ItemList[index]:=nil
  else begin
    if len>=MaxSize
    then begin
      getmem(p, sizeof(byte)+sizeof(integer)+len);
      pbyte(p)^:=MaxSize;
      pint(PtrINC(p, sizeof(byte)))^:=len;
      CopyMemory(PtrINC(p, sizeof(byte)+sizeof(integer)), pchar(Value), len);
    end
    else begin
      if len+sizeof(byte) > MemVolume
      then begin
        getmem(MemPointer, BlockSize);
        MemList.Add(MemPointer);
        MemVolume:=BlockSize;
      end;
      p:=MemPointer;
      MemPointer:=PtrINC(MemPointer, sizeof(byte)+len);
      MemVolume:=MemVolume-(sizeof(byte)+len);
      pbyte(p)^:=len;
      CopyMemory(PtrINC(p, sizeof(byte)), pchar(Value), len);
    end;
    ItemList[index]:=p;
  end
end;

procedure TStringListEx.Clear;
var i:integer;
begin
  for i:=0 to ItemList.Count-1 do ClearValue(i);
  ItemList.Clear;
  for i:=0 to MemList.Count-1 do freemem(MemList[i]);
  MemList.Clear;
  MemVolume:=0;
end;

function TStringListEx.Add(value:string):integer;
begin
  result:=ItemList.Add(nil);
  Put(result, value)
end;

procedure TStringListEx.Delete(index:integer);
begin
  ClearValue(index);
  ItemList.Delete(index)
end;

procedure TStringListEx.Insert(index:integer; value:string);
begin
  ItemList.Insert(index, nil);
  Put(index, value);
end;

procedure TStringListEx.Assign(List:TStringListEx);
var i:integer;
begin
  Clear;
  for i:=0 to List.Count-1 do Add(List[i]);
end;

function TStringListEx.GetCount:integer;
begin
  result:=ItemList.Count
end;

{TDataStorage}

constructor TDataStorage.Create;
begin
  inherited;
  ItemList:=TStringListEx.Create;
end;

destructor TDataStorage.Destroy;
begin
  ItemList.Free;
  inherited
end;

function TDataStorage.GetValue(row, col:integer):string;
begin
  result:=ItemList[row*FColCount+col];
end;

procedure TDataStorage.SetValue(row, col:integer; const ItemValue:string);
begin
  ItemList[row*FColCount+col]:=ItemValue;
end;

procedure TDataStorage.Clear;
begin
  ItemList.Clear;
end;

procedure TDataStorage.AddRow;
var i:integer;
begin
  for i:=0 to FColCount-1 do ItemList.Add('')
end;

procedure TDataStorage.DeleteRow(row:integer);
var i:integer;
begin
  for i:=0 to FColCount-1 do ItemList.Delete(row*FColCount)
end;

procedure TDataStorage.InsertRow(row:integer);
var i:integer;
begin
  for i:=0 to FColCount-1 do ItemList.Insert(row*FColCount+i, '')
end;

function TDataStorage.GetRowCount:integer;
begin
  result:=ItemList.Count div FColCount
end;

end.
