program verbalexpressiondemo;

uses
  Vcl.Forms,
  demo in '..\src\demo.pas' {Form1},
  verbalexpressions in '..\src\verbalexpressions.pas',
  unittests in '..\src\tests\unittests.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
