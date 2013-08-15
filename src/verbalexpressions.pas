{*
* ----------------------------------------------------------------------------
* "THE VODKA-WARE LICENSE" (Revision 42):
* <tim@bandenkrieg.hacked.jp> wrote this file. As long as you retain this notice you
* can do whatever you want with this stuff. If we meet some day, and you think
* this stuff is worth it, you can buy me a vodka in return. Tim Schumacher
* ----------------------------------------------------------------------------
*}

unit verbalexpressions;

interface

uses
   SysUtils
  ,System.RegularExpressions;

type
  VerbalExpressionException = class(Exception);

  TVerbalExpression = class
    private
      FstrSource : string;
      FStrPrefix : string;
      FstrSuffix : string;
      FstrModifier : string;
      function Add(astrValue : string) : TVerbalExpression;
      function getRegEx : TRegEx;
    public
      function AnyOf(astrValue : string) : TVerbalExpression;
      function Any(astrValue : string) : TVerbalExpression;
      function Range(astrValue : array of string) : TVerbalExpression;
      function Anything : TVerbalExpression;
      function Sanitize(astrValue : string) : string;
      function Multiple(astrValue : string) : TVerbalExpression;
      function StartOfLine(aboolEnable : boolean = True) : TVerbalExpression;
      function EndOfLine(aboolEnable : boolean = True) : TVerbalExpression;
      function _Then(astrValue : string) : TVerbalExpression;
      function Find(astrValue : string) : TVerbalExpression;
      function Maybe(astrValue : string) : TVerbalExpression;
      function AnythingBut(astrValue : string) : TVerbalExpression;
      function _Or(astrValue : string) : TVerbalExpression;
      function Something : TVerbalExpression;
      function SomethingBut(astrValue : string) : TVerbalExpression;
      function LineBreak : TVerbalExpression;
      function br : TVerbalExpression;
      function tab : TVerbalExpression;
      function word : TVerbalExpression;

      function AddModifier(astrModifier : string) : TVerbalExpression;
      function RemoveModifier(astrModifier : string) : TVerbalExpression;

      function WithAnyCase(aboolEnable : boolean = true) : TVerbalExpression;
      function StopAtFirst(aboolEnable : boolean = true) : TVerbalExpression;
      function SearchOneLine(aboolEnable : boolean = true) : TVerbalExpression;

      function AsString : string;
      function Clear : TVerbalExpression;

      function Test(astrValue : string) : boolean;

      property RegEx : TRegEx read getRegEx;

  end;

implementation

{ TVerbalExpression }

function TVerbalExpression.Add(astrValue: string): TVerbalExpression;
begin
  Result := self;
  FstrSource := FstrSource + astrValue;
end;

function TVerbalExpression.AddModifier(astrModifier: string): TVerbalExpression;
begin
  if (Pos(astrModifier,FstrModifier) = -1) then
    FstrModifier := FstrModifier + astrModifier;
  Result := self;
end;

function TVerbalExpression.Any(astrValue: string): TVerbalExpression;
begin
  Result := AnyOf(astrValue);
end;

function TVerbalExpression.AnyOf(astrValue: string): TVerbalExpression;
begin
  Result := Add('['+ astrValue +']');
end;

function TVerbalExpression.Anything: TVerbalExpression;
begin
  Result := Add('(.*)');
end;

function TVerbalExpression.AsString: string;
begin
  Result := FstrSource;
end;

function TVerbalExpression.br: TVerbalExpression;
begin
  Result := LineBreak;
end;

function TVerbalExpression.Clear: TVerbalExpression;
begin
  Result := self;
  FstrSource := '';
  FStrPrefix := '';
  FstrSuffix := '';
  FstrModifier := 'gm';
end;

function TVerbalExpression.getRegEx: TRegEx;
begin
  Result := TRegEx.Create(FstrSource);
end;

function TVerbalExpression.LineBreak: TVerbalExpression;
begin
  Result := Add('(\n|(\r\n))');
end;

function TVerbalExpression.Multiple(astrValue: string): TVerbalExpression;
begin
  astrValue := sanitize(astrValue);

  if (not ((Copy(astrValue,Length(astrValue)-1,1) = '+') or (Copy(astrValue,Length(astrValue)-1,1) = '*'))) then
    astrValue := astrValue + '+';

  Result := Add(astrValue);
end;

function TVerbalExpression.Range(astrValue: array of string): TVerbalExpression;
var
  LintCounter: Integer;
  LstrValue : string;
begin
  if (Length(astrValue) mod 2) <> 0 then
    raise VerbalExpressionException.Create('Number of args must be even');

  LstrValue := '[';
  LintCounter := 0;
  while LintCounter < Length(astrValue) do begin
    LstrValue := LstrValue + astrValue[LintCounter] + '-' + astrValue[LintCounter+1];
    Inc(LintCounter,2);
  end;
  LstrValue := LstrValue + ']';


  Result := Add(LstrValue);
end;

function TVerbalExpression.RemoveModifier(
  astrModifier: string): TVerbalExpression;
begin
  FstrModifier := StringReplace(FstrModifier,astrModifier,'',[rfReplaceAll]);
  Result := Self;
end;

function TVerbalExpression.Sanitize(astrValue: string): string;
begin
  Result := TRegEx.Escape(astrValue);
end;

function TVerbalExpression.SearchOneLine(
  aboolEnable: boolean): TVerbalExpression;
begin
  if aboolEnable then
    Result := AddModifier('m')
  else
    Result := RemoveModifier('m');
end;

function TVerbalExpression.Something: TVerbalExpression;
begin
  Result := Add('(.+)');
end;

function TVerbalExpression.SomethingBut(astrValue: string): TVerbalExpression;
begin
  Result := Add('([^'+ Sanitize(astrValue) +']+)');
end;

function TVerbalExpression.StartOfLine(aboolEnable : boolean = True) : TVerbalExpression;
begin
  if aboolEnable then
    FStrPrefix := '^'
  else
    FStrPrefix := '';
  Result := self;
end;

function TVerbalExpression.StopAtFirst(aboolEnable: boolean = true): TVerbalExpression;
begin
  if aboolEnable then
    Result := AddModifier('g')
  else
    Result := RemoveModifier('g');
end;

function TVerbalExpression.tab: TVerbalExpression;
begin
  Result := Add('\t')
end;

function TVerbalExpression.Test(astrValue: string): boolean;
begin
  Result := RegEx.Match(astrValue).Success;
end;

function TVerbalExpression.WithAnyCase(aboolEnable: boolean = true): TVerbalExpression;
begin
  if aboolEnable then
    Result := AddModifier('i')
  else
    Result := RemoveModifier('i');
end;

function TVerbalExpression.word: TVerbalExpression;
begin
  Result := Add('\w+');
end;

function TVerbalExpression.EndOfLine(aboolEnable : boolean = True) : TVerbalExpression;
begin
  if aboolEnable then
    FstrSuffix := '$'
  else
    FstrSuffix := '';
  Result := self;
end;

function TVerbalExpression.Find(astrValue: string): TVerbalExpression;
begin
  Result := _Then(astrValue);
end;

function TVerbalExpression._Or(astrValue: string): TVerbalExpression;
begin
  if (Pos('(',FstrPrefix) = -1) then begin
      FStrPrefix := FStrPrefix + '(';
  end;

  if (Pos(')',FstrSuffix) = -1) then begin
      FstrSuffix := FstrSuffix + ')';
  end;

  Add(')|(');

  if Length(astrValue) > 0 then
    Add(Sanitize(astrValue));

  Result := self;
end;

function TVerbalExpression._Then(astrValue : string) : TVerbalExpression;
begin
  Result := Add('('+ Sanitize(astrValue) +')');
end;

function TVerbalExpression.Maybe(astrValue : string) : TVerbalExpression;
begin
  Result := Add('('+ Sanitize(astrValue) +')?');
end;

function TVerbalExpression.AnythingBut(astrValue : string) : TVerbalExpression;
begin
  Result := Add('([^'+ Sanitize(astrValue) +']*)');
end;

end.
