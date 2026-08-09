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
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
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
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Edit5EditingDone(Sender: TObject);
    procedure Edit6EditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public
    Function RepairIPAddress(s: string):string;
  end;

const
  TAB = #9;

var
  Form1: TForm1;
  P : Pointer;
  fmt,S : string;
  FormatStrings : Array[1..9] of string = (
        '',
        '0',
        '0.00',
        '#.##',
        '#,##0.00',
        '#,##0.00;(#,##0.00)',
        '#,##0.00;;Zero',
        '0.000E+00',
        '#.###E-0');

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

procedure TForm1.FormCreate(Sender: TObject);
begin

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
    Memo1.Append(Format('OnReceive: %d %d %d %s = %s',[1, 2, 3, '##', '$$']));
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

procedure TForm1.Button2Click(Sender: TObject);
var
  s: string;
  Float_:extended;
begin
  Memo1.Clear;
  // Format with 2 decimal places in scientific notation
  s := Format('%.2e', [0.1]);
  Memo1.Append(s); // Outputs: 1.00e-01

  s := FloatToStrF(0.1, ffExponent, 2, 3);
  Memo1.Append(s); // Outputs: 1.00e-01

  Float_:=-2000;
  s := Format('%.2e', [Float_]);
  Memo1.Append(s); // Outputs: -2.0E+003

  Float_:=-3000;
  s := FloatToStrF(Float_, ffExponent, 2, 2);
  Memo1.Append(s); // Outputs: -2.0E+03

  Float_:=1.1E-5;
  s := FloatToStrF(Float_, ffExponent, 2, 2);
  Memo1.Append(s); // Outputs: 1.1E-05

  s:=FormatFloat(FormatStrings[9],-0.5);
  Memo1.Append(s); // Outputs: -5E-1
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  title,  title2,
  underline,
  line, row1, row2, row3,
  fmt : string;
  i : integer;
begin
  Memo1.Clear;

  fmt := '%-12s';
  title := format(fmt,['Column 1']) + format(fmt,['Column 2']);
  for i := 1 to 12 do underline := underline + '-';
  underline := underline + underline ;
  fmt := '%-12d';
  line := format(fmt,[15]) + format(fmt,[8]) ;
  fmt := '%12s';
  title2 := format(fmt,['Column 1']) + format(fmt,['Column 2']);
  fmt := '%12d';
  row1 := format(fmt,[15]) + format(fmt,[8]);
  row2 := format(fmt,[1005]) + format(fmt,[809]);
  fmt := '%12.5d';
  row3 := format(fmt,[1005]) + format(fmt,[809]);
  Memo1.Lines.Add( title );
  Memo1.Lines.Add( underline );
  Memo1.Lines.Add( line );

  Memo1.Lines.Add( '' );
  Memo1.Lines.Add( title2 );
  Memo1.Lines.Add( underline );
  Memo1.Lines.Add( row1 );
  Memo1.Lines.Add( row2 );
  Memo1.Lines.Add( row3 );

  Memo1.Lines.Add( '' );
  Memo1.Lines.Add( 'Tab to string [#9]:' );
  fmt := '%s';
  title := format(fmt,['Column 1']) +#9+ format(fmt,['Column 2']);
  fmt := '%-12d';
  line := format(fmt,[15]) +#9+ format(fmt,[8]) ;
  Memo1.Lines.Add( title );
  Memo1.Lines.Add( underline );
  Memo1.Lines.Add( line );

  Memo1.Lines.Add( '' );
  Memo1.Lines.Add( 'Tab to string [^I]:' );
  fmt := '%s';
  title := format(fmt,['Column 1']) +^I+ format(fmt,['Column 2']);
  fmt := '%-12d';
  line := format(fmt,[15]) +^I+ format(fmt,[8]) ;
  Memo1.Lines.Add( title );
  Memo1.Lines.Add( underline );
  Memo1.Lines.Add( line );

  Memo1.Lines.Add( '' );
  Memo1.Lines.Add( 'Tab to string [TAB]:' );
  fmt := '%s';
  title := format(fmt,['Column 1']) +TAB+ format(fmt,['Column 2']);
  fmt := '%-12d';
  line := format(fmt,[15]) +TAB+ format(fmt,[8]) ;
  Memo1.Lines.Add( title );
  Memo1.Lines.Add( underline );
  Memo1.Lines.Add( line );
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  fmt,line : string;
begin
  Memo1.Clear;

  fmt := '%-5s';
  line := format(fmt,['d']) + format(fmt,['Decimal (integer)']);
  Memo1.Lines.Add( line );
  line := format(fmt,['e']) + format(fmt,['Scientific']);
  Memo1.Lines.Add( line );
  line := format(fmt,['f']) + format(fmt,['Fixed']);
  Memo1.Lines.Add( line );
  line := format(fmt,['g']) + format(fmt,['General']);
  Memo1.Lines.Add( line );
  line := format(fmt,['m']) + format(fmt,['Money']);
  Memo1.Lines.Add( line );
  line := format(fmt,['n']) + format(fmt,['Number (floating)']);
  Memo1.Lines.Add( line );
  line := format(fmt,['p']) + format(fmt,['Pointer']);
  Memo1.Lines.Add( line );
  line := format(fmt,['s']) + format(fmt,['String']);
  Memo1.Lines.Add( line );
  line := format(fmt,['u']) + format(fmt,['Unsigned decimal']);
  Memo1.Lines.Add( line );
  line := format(fmt,['x']) + format(fmt,['Hexadecimal']);
  Memo1.Lines.Add( line );
  Memo1.Lines.Add('');
  Memo1.Lines.Add('Integer formatting');
  line := format(fmt,['%d']) + format(fmt,['Will print the integer as it is.']);
  Memo1.Lines.Add( line );
  line := format(fmt,['%8d']) + format(fmt,['Will print the integer as it is. If the number of digits is less than 8, the output will be padded on the left.']);
  Memo1.Lines.Add( line );
  line := format(fmt,['%-8d']) + format(fmt,['Will print the integer as it is. If the number of digits is less than 8, the output will be padded on the right.']);
  Memo1.Lines.Add( line );
  line := format(fmt,['%.8d']) + format(fmt,['Will print the integer as it is. If the number of digits is less than 8, the output will be padded on the left with zeroes.']);
  Memo1.Lines.Add( line );
  Memo1.Lines.Add('');
  Memo1.Lines.Add('String formatting');
  line := format(fmt,['%s']) + format(fmt,['Will print the string as it is.']);
  Memo1.Lines.Add( line );
  line := format(fmt,['%8s']) + format(fmt,['Will print the string as it is. If the string has less than 8 characters, the output will be space-padded on the left (right-justified).']);
  Memo1.Lines.Add( line );
  line := format(fmt,['%-8s']) + format(fmt,['Will print the string as it is. If the string has less than 8 characters, the output will be space-padded on the right (left-justified).']);
  Memo1.Lines.Add( line );
end;

end.

