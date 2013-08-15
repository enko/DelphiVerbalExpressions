program verbalexpressiontests;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  vcl.forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  unittests in '..\src\tests\unittests.pas',
  verbalexpressions in '..\src\verbalexpressions.pas';

{R *.RES}

begin
  Application.Initialize;
  if IsConsole then
    with TextTestRunner.RunRegisteredTests do
      Free
  else
    GUITestRunner.RunRegisteredTests;
end.
