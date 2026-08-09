unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  strutils;

type
    Tutf16conv=record
    case byte of
    0:(C:UnicodeChar);
    1:(W:word);
    end;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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

function UStrToHex(const S: UnicodeString): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
    Result := Result + IntToHex(Ord(S[i]), 4); // 4 digits for UTF-16 code unit
end;

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

procedure TForm1.FormCreate(Sender: TObject);
begin

end;


procedure TForm1.Button1Click(Sender: TObject);
var
 T:Tutf16conv;
begin
  Memo1.Clear;
  T.w:=$06A9 ;
  Memo1.Append({$INCLUDE %LINE%} + ' String: ' +T.C);
  Memo1.Append({$INCLUDE %LINE%} + ' u-' +UStrToHex(T.C)); // prints  u-06A9 correctly
  Memo1.Append({$INCLUDE %LINE%} + ' Word: ' +T.W.ToString);
  T.w:=$28FF ;
  Memo1.Append({$INCLUDE %LINE%} + ' String: ' +T.C);
  Memo1.Append({$INCLUDE %LINE%} + ' u-' +UStrToHex(T.C));
  Memo1.Append({$INCLUDE %LINE%} + ' Word: ' +T.W.ToString);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  TB: TBytes;
  WS: WideString;
  S:  string;
  i:  Integer;
begin
  Memo1.Clear;
  WS := Edit1.Caption;
  TB := WideBytesOf(WS); // <<<----- use TBytes to access the characters' value

  // WideString to Hexadecimal
  S := '';
  for i := High(TB) DOWNTO Low(TB) do
    S := S + IntToHex(TB[i], 2)+' ';
  Memo1.Append({$INCLUDE %LINE%} + ' Hexadecimal values: ' +s);

  // WideString to Decimal
  S := '';
  for i := High(TB) DOWNTO Low(TB) do
    S := S + IntToStr(TB[i])+' ';
  Memo1.Append({$INCLUDE %LINE%} + ' Decimal values: ' +s);

  Memo1.Append({$INCLUDE %LINE%} + ' TBytes to WideString: ' + WideString(TB));
end;

end.

