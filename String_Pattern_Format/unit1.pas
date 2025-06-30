unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  tcp_udpport, strutils;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit5: TEdit;
    Edit6: TEdit;
    Label14: TLabel;
    Label15: TLabel;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    PopupMenu_IP: TPopupMenu;
    TCP_UDPPort1: TTCP_UDPPort;
    procedure Button1Click(Sender: TObject);
    procedure Edit5EditingDone(Sender: TObject);
    procedure Edit6EditingDone(Sender: TObject);
  private

  public
    Function RepairIPAddress(s: string):string;
  end;

var
  Form1: TForm1;
  P : Pointer;
  fmt,S : string;

implementation

{$R *.lfm}

{ TForm1 }
Function TForm1.RepairIPAddress(s: string):string;
var
  i:integer;
  k:integer;
  s2:string;
  c:integer;
  A_s: TStringArray;
begin

  //Edit1.Text:=chr(ord('0'));
  //Edit1.Text:=IntToStr(ord('9');

  s:=Trim(s);
  //s:=leftstr(s,15);

  s2:='';
  for i:=1 to length(s) do
  begin
    if (((ord(s[i]) >= 48) and (ord(s[i]) <= 57)) or (s[i] = '.')) then s2:=s2+s[i];
  end;
  s:=s2;

  if length(s) = 0 then s:=s+'0.0.0.0';

  if (s[1] = '.') then s:='0'+s;

  k:=0;
  for i:=1 to length(s) do
  begin
    if(s[i] = '.') then k:=k+1;
  end;
  if k=0 then s:=s+'.0.0.0';
  if k=1 then s:=s+'.0.0';
  if k=2 then s:=s+'.0';
  if s[length(s)]='.' then s:=s+'0';

  k:=0;
  c:=0;
  s2:='';
  for i:=1 to length(s) do
  begin
    if(s[i] = '.') then begin k:=k+1; c:=0; end;
    if (k>3) then
      begin
        s2:=s2;
      end
    else
      begin
        if not(s[i] = '.')then c:=c+1;
        if (c<=3) then s2:=s2+s[i];
      end;
  end;
  s:=s2;

  A_s:=SplitString(s,'.');

  k:=0;
  Try
    k:=StrToInt(A_s[0]);
  except
    On E : EConvertError do
      k:=0;
  end;
  if (k>255) then k:=255;
  if (k<0) then k:=0;
  s:=IntToStr(k);

  k:=0;
  Try
    k:=StrToInt(A_s[1]);
  except
    On E : EConvertError do
      k:=0;
  end;
  if (k>255) then k:=255;
  if (k<0) then k:=0;
  s:=s+'.'+IntToStr(k);

  k:=0;
  Try
    k:=StrToInt(A_s[2]);
  except
    On E : EConvertError do
      k:=0;
  end;
  if (k>255) then k:=255;
  if (k<0) then k:=0;
  s:=s+'.'+IntToStr(k);

  k:=0;
  Try
    k:=StrToInt(A_s[3]);
  except
    On E : EConvertError do
      k:=0;
  end;
  if (k>255) then k:=255;
  if (k<0) then k:=0;
  s:=s+'.'+IntToStr(k);

  result := s;
end;

procedure TForm1.Edit6EditingDone(Sender: TObject);
begin
  Edit6.Caption:=RepairIPAddress(Edit6.Caption);
  TCP_UDPPort1.Host:=Edit6.Caption;
end;

procedure TForm1.Edit5EditingDone(Sender: TObject);
var
  i:integer;
begin
  i:=0;
  Try
    i:=StrToInt(Edit5.Caption);
  except
    On E : EConvertError do
      i:=502;
  end;
  Edit5.Caption:= IntToStr(i);
  TCP_UDPPort1.Port:=i;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  P:=Pointer(1234567);
  Memo1.Clear;
  Try
    Fmt:='[%s.%s.%s.%s]';S:=Format(fmt,['192','168','0','150']);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%d.%d.%d.%d]';S:=Format(fmt,[192,168,0,150]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%.3d.%.3d.%.3d.%.3d]';S:=Format(fmt,[192,168,0,150]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%3d.%3d.%3d.%3d]';S:=Format(fmt,[192,168,0,150]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%s]';S:=Format(fmt,['192.168.0.1']);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:s]';s:=Format(fmt,[' 192 .168.0.1']);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%3s]';S:=Format(fmt,['192.168.0.1']);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:3s]';s:=Format(fmt,[' 192 .168.0.1']);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%3s]';S:=Format(fmt,['19']);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:s]';S:=Format(fmt,[' 19']);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%s3]';S:=Format(fmt,['19']);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%s3]';S:=Format(fmt,['19 ']);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%s:s]';S:=Format(fmt,['19 ']);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%ss]';S:=Format(fmt,['19 ']);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%s:%s]';S:=Format(fmt,[' 19 ','168']);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:s.%s]';S:=Format(fmt,[' 19 ','168']);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0s:%s]';S:=Format(fmt,[' 19 ','168']);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0s.%s]';S:=Format(fmt,[' 19 ','168']);Memo1.Append(Fmt+' = '+s);

    Fmt:='[%d]';S:=Format (Fmt,[10]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%%]';S:=Format (Fmt,[10]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%10d]';S:=Format (Fmt,[10]);Memo1.Append(Fmt+' = '+s);
    fmt:='[%.4d]';S:=Format (fmt,[10]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%10.4d]';S:=Format (Fmt,[10]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:d]';S:=Format (Fmt,[10]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:10d]';S:=Format (Fmt,[10]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:10.4d]';S:=Format (Fmt,[10]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:-10d]';S:=Format (Fmt,[10]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:-10.4d]';S:=Format (fmt,[10]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%-*.*d]';S:=Format (fmt,[4,5,10]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%x]';S:=Format (Fmt,[10]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%10x]';S:=Format (Fmt,[10]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%10.4x]';S:=Format (Fmt,[10]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:x]';S:=Format (Fmt,[10]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:10x]';S:=Format (Fmt,[10]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:10.4x]';S:=Format (Fmt,[10]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:-10x]';S:=Format (Fmt,[10]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:-10.4x]';S:=Format (fmt,[10]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%-*.*x]';S:=Format (fmt,[4,5,10]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[0x%p]';S:=Format (Fmt,[P]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[0x%10p]';S:=Format (Fmt,[P]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[0x%10.4p]';S:=Format (Fmt,[P]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[0x%0:p]';S:=Format (Fmt,[P]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[0x%0:10p]';S:=Format (Fmt,[P]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[0x%0:10.4p]';S:=Format (Fmt,[P]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[0x%0:-10p]';S:=Format (Fmt,[P]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[0x%0:-10.4p]';S:=Format (fmt,[P]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%-*.*p]';S:=Format (fmt,[4,5,P]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%s]';S:=Format(fmt,['This is a string']);Memo1.Append(Fmt+' = '+s);
    fmt:='[%0:s]';s:=Format(fmt,['This is a string']);Memo1.Append(Fmt+' = '+s);
    fmt:='[%0:18s]';s:=Format(fmt,['This is a string']);Memo1.Append(Fmt+' = '+s);
    fmt:='[%0:-18s]';s:=Format(fmt,['This is a string']);Memo1.Append(Fmt+' = '+s);
    fmt:='[%0:18.12s]';s:=Format(fmt,['This is a string']);Memo1.Append(Fmt+' = '+s);
    fmt:='[%-*.*s]';s:=Format(fmt,[18,12,'This is a string']);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%e]';S:=Format (Fmt,[1.234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%10e]';S:=Format (Fmt,[1.234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%10.4e]';S:=Format (Fmt,[1.234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:e]';S:=Format (Fmt,[1.234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:10e]';S:=Format (Fmt,[1.234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:10.4e]';S:=Format (Fmt,[1.234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:-10e]';S:=Format (Fmt,[1.234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:-10.4e]';S:=Format (fmt,[1.234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%-*.*e]';S:=Format (fmt,[4,5,1.234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%e]';S:=Format (Fmt,[-1.234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%10e]';S:=Format (Fmt,[-1.234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%10.4e]';S:=Format (Fmt,[-1.234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:e]';S:=Format (Fmt,[-1.234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:10e]';S:=Format (Fmt,[-1.234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:10.4e]';S:=Format (Fmt,[-1.234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:-10e]';S:=Format (Fmt,[-1.234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:-10.4e]';S:=Format (fmt,[-1.234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%-*.*e]';S:=Format (fmt,[4,5,-1.234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%e]';S:=Format (Fmt,[0.01234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%10e]';S:=Format (Fmt,[0.01234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%10.4e]';S:=Format (Fmt,[0.01234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:e]';S:=Format (Fmt,[0.01234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:10e]';S:=Format (Fmt,[0.01234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:10.4e]';S:=Format (Fmt,[0.01234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:-10e]';S:=Format (Fmt,[0.0123]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:-10.4e]';S:=Format (fmt,[0.01234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%-*.*e]';S:=Format (fmt,[4,5,0.01234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%e]';S:=Format (Fmt,[-0.01234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%10e]';S:=Format (Fmt,[-0.01234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%10.4e]';S:=Format (Fmt,[-0.01234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:e]';S:=Format (Fmt,[-0.01234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:10e]';S:=Format (Fmt,[-0.01234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:10.4e]';S:=Format (Fmt,[-0.01234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:-10e]';S:=Format (Fmt,[-0.01234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%0:-10.4e]';S:=Format (fmt,[-0.01234]);Memo1.Append(Fmt+' = '+s);
    Fmt:='[%-*.*e]';S:=Format (fmt,[4,5,-0.01234]);Memo1.Append(Fmt+' = '+s);
  except
    On E : Exception do
      begin
      Memo1.Append('Exception caught : '+E.Message);
      end;
  end;

end;

end.

