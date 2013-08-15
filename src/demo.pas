{*
* ----------------------------------------------------------------------------
* "THE VODKA-WARE LICENSE" (Revision 42):
* <tim@bandenkrieg.hacked.jp> wrote this file. As long as you retain this notice you
* can do whatever you want with this stuff. If we meet some day, and you think
* this stuff is worth it, you can buy me a vodka in return. Tim Schumacher
* ----------------------------------------------------------------------------
*}

unit demo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

uses
  verbalexpressions;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  LobjVerbalExpression : TVerbalExpression;
begin
  LobjVerbalExpression := TVerbalExpression.Create
    .StartOfLine()
    ._Then('http')
    .Maybe('s')
    ._Then('://')
    .Maybe('www.')
    .anythingBut(' ')
    .endOfLine();

  ListBox1.Items.Add(LobjVerbalExpression.AsString);

  if LobjVerbalExpression.Test('https://github.com') then
    ListBox1.Items.Add('valid url')
  else
    ListBox1.Items.Add('invalid url');

end;

end.
