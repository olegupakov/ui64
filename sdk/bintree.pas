unit bintree;

interface

type 
  
  PBinCell=^TBinCell;
  TBinCell=record
    value:pointer;
    count,leftheight,rightheight:integer;
    left,right:PBinCell;
  end;

  TBinTree=class
  private
    fHead:PBinCell;
    ftreeheight:integer;
    function createcell(value:pointer):PBinCell;
    function addcell(value:pointer; var head:PBinCell; var height:integer):PBinCell;
    procedure balancecell(var head:PBinCell);
  public
    constructor create;
     destructor destroy;override;
       function add(value:pointer):integer;
       function compare(valuecell, value:pointer):integer;virtual;abstract;
       function exists(value:pointer):pointer;
      procedure wrlvl;
  end;

implementation

uses math;

constructor TBinTree.create;
begin
  inherited;
  fHead:=nil;
  ftreeheight:=0;
end;

destructor TBinTree.destroy;
begin
  // TODO for all tree cells freemem
  inherited;
end;

function TBinTree.createcell(value:pointer):PBinCell;
begin
  getmem(result, sizeof(TbinCell));
  result.value:=value;
  result.count:=1;
  result.leftheight:=0;
  result.rightheight:=0;
  result.left:=nil;
  result.right:=nil;
end;

function TBinTree.add(value:pointer):integer;
begin
  result:=addcell(value, fHead, ftreeheight).count;
end;

procedure TBinTree.balancecell(var head:PBinCell);
var t:PBinCell;
begin
  t:=head;
  if head.leftheight > head.rightheight
  then begin
    head:=head.left;
    t.left:=head.right;
    head.right:=t;
    if t.left=nil 
    then t.leftheight:=0 
    else t.leftheight:=max(t.left.leftheight, t.left.rightheight);
    head.rightheight:=max(head.right.leftheight, head.right.rightheight);
  end
  else begin
    head:=head.right;
    t.right:=head.left;
    head.left:=t;
    if t.right=nil 
    then t.rightheight:=0 
    else t.rightheight:=max(t.right.leftheight, t.right.rightheight);
    head.leftheight:=max(head.left.leftheight, head.left.rightheight);
  end
end;

function TBinTree.exists(value:pointer):pointer;
var p:PBinCell;
    compresult:integer;
begin
  p:=fHead;
  while p<>nil do begin
    compresult:=compare(p.value, value);
    if compresult = 0
    then begin
      result:=p.value;
      exit
    end
    else begin
      if compresult > 0
      then p:=p.left
      else p:=p.right
    end
  end;
  result:=nil;
end;

function TBinTree.addcell(value:pointer; var head:PBinCell; var height:integer):PBinCell;
var compresult:integer;
begin
  if head=nil
  then begin
    head:=createcell(value);
    inc(height);
    result:=head
  end
  else begin
    compresult:=compare(head.value, value);
    if compresult = 0
    then begin
      inc(head.count);
      result:=head
    end
    else begin
      if compresult > 0
      then begin
        result:=addcell(value, head.left, head.leftheight);
      end
      else begin
        result:=addcell(value, head.right, head.rightheight);
      end;
      while abs(head.leftheight - head.rightheight) > 1 do
        balancecell(head);
      height:=max(head.leftheight, head.rightheight)+1;
    end
  end;
end;

procedure TBinTree.wrlvl;
  procedure _wrlvl(p:PBinCell);
  begin
    if p<>nil
    then begin
      _wrlvl(p.left);
      writeln(integer(p.value),' ',p.count{,' ',p.leftheight-p.rightheight});
      _wrlvl(p.right);
    end;
  end;
begin
   writeln('H: ', ftreeheight);
  _wrlvl(fHead);
end;

end.