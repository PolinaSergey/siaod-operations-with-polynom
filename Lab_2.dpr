program Lab_2;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  Multi=^elem;
  elem = record
            n:Integer;
            a:Integer;
            Next:Multi;
         end;
var
  p,q,r:Multi;
  x:integer;


function ReadPoly(): Multi;
var
  ListHead,x:Multi;
  i,a,n:integer;
begin
  write('Enter the power of first polynomial: ');
  readln(n);
  write('Enter the coefficients: ');

  ListHead:=nil;
  x:=nil;
  for i := 0 to n do
  begin
    readln(a);
    if a<>0 then
    begin
      if ListHead=nil then
      begin
        new(x);
        x^.n:=n;
        x^.a:=a;
        x^.next:=nil;
        ListHead:=x;
      end
      else
      begin
        new(x^.Next);
        x:=x^.Next;
        x^.n:=n;
        x^.a:=a;
        x^.Next:=nil;
      end;
    end;
    dec(n);
  end;  

  Result:=ListHead;
end;


procedure WritePoly(Ch:Multi);
var
  fl:boolean;
begin
  Fl:=true;
  while fl do
  begin
    if (Ch^.Next<>nil) and (Ch^.n<>1) then
      write(IntToStr(Ch^.a)+'x^'+IntToStr(Ch^.n)+' + ');
    if (Ch^.Next<>nil) and (Ch^.n=1) then
      write(IntToStr(Ch^.a)+'x'+' + ');
    if (Ch^.Next=nil) then
      write(IntToStr(Ch^.a));
    if Ch^.Next<>nil then
      ch:=ch^.Next
    else
      Fl:=false;
  end;
  writeln;
end;

function Equality(p,q:Multi):boolean;
var
  fl:boolean;
begin
  fl:=true;
  Result:=true;
  while (p<>nil) and (q<>nil) and fl do
  begin
    if (p^.n <> q^.n) or (p^.a <> q^.a) then
      fl:=false;
    p:=p^.Next;
    q:=q^.Next;
  end;
  if fl=false then
    Result:=false;
end;

function Meaning(p:Multi;x:integer):integer;
var
  rez: integer;
  fl:boolean;
begin
  rez:=0;
  fl:=true;
  while fl do
  begin
    rez:=rez + p^.a * round(exp(p^.n * ln(x)));
    if p^.Next<>nil then    
      p:=p^.Next
    else
      fl:=false
  end;

  Result:=rez;
end;

procedure Add (p,q:Multi; out r:Multi);
var
  Ch,ListHead:Multi;
  fl:boolean;
begin
  new(Ch);
  ListHead:=Ch;
  Ch^.Next:=nil;
  fl:=true;
  while fl do
  begin
    if q^.n > p^.n then
    begin
      Ch^.n := q^.n;
      Ch^.a := q^.a;
      if (q^.Next<>nil) then
        q:=q^.Next
      else
        Fl:=false;
    end
    else
    begin
      if q^.n < p^.n then
      begin
        Ch^.n := p^.n;
        Ch^.a := p^.a;
        if (p^.Next<>nil) then
          p:=p^.Next
        else
          Fl:=false;
      end
      else
      begin
        Ch^.n := q^.n;
        Ch^.a := p^.a + q^.a;
        if (p^.Next<>nil) and (q^.Next<>nil) then
        begin
          q:=q^.Next;
          p:=p^.Next;
        end
        else
          Fl:=false
      end;
    end;
    if Fl then
    begin
      new(Ch^.Next);
      Ch:=Ch^.Next;
      Ch^.Next := nil
    end

  end;
  r:=ListHead;
end;


procedure Delete(Ch:Multi);
var
  ListHead:Multi;
begin
  while Ch <> nil do
  begin
    ListHead := Ch^.Next;
    Dispose(Ch);
    Ch := ListHead
  end
end;

begin
  p:=ReadPoly;
  write('Your 1 polynomial: ');
  WritePoly(p);
  writeln;

  q:=ReadPoly;
  write('Your 2 polynomial: ');
  WritePoly(q);
  writeln;
  writeln;


  if Equality(p,q) then
    writeln('Polinomilas are equal')
  else
    writeln('Polinomilas are not equal');
  writeln;

  write('Enter x for the first polynomial: ');
  readln(x);
  writeln('The value of the first polynomial is ',Meaning(p,x));
  writeln;

  Add(p,q,r);
  write('Polynomial sum: ');
  WritePoly(r);

  Delete(p);
  Delete(q);
  Delete(r);
  readln;
end.
