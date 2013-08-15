{*
* ----------------------------------------------------------------------------
* "THE VODKA-WARE LICENSE" (Revision 42):
* <tim@bandenkrieg.hacked.jp> wrote this file. As long as you retain this notice you
* can do whatever you want with this stuff. If we meet some day, and you think
* this stuff is worth it, you can buy me a vodka in return. Tim Schumacher
* ----------------------------------------------------------------------------
*}

unit unittests;

interface

 uses
   TestFramework, verbalexpressions;

 type
   // Test methods for class TCalc
   TestTVerbalExpression = class(TTestCase)
   strict private
     aTVerbalExpression: TVerbalExpression;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestMultiple;
  end;

implementation

procedure TestTVerbalExpression.SetUp;
begin
 aTVerbalExpression := TVerbalExpression.Create;
end;

procedure TestTVerbalExpression.TearDown;
begin
 aTVerbalExpression := nil;
end;

procedure TestTVerbalExpression.TestMultiple;
begin
  aTVerbalExpression.Multiple('abc');
  CheckEquals(aTVerbalExpression.AsString,'abc+');
end;

initialization
 // Register any test cases with the test runner
 RegisterTest(TestTVerbalExpression.Suite);

end.
