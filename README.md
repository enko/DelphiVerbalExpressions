# Delphi implementation of VerbalExpression

This is a implementation of [VerbalExpression](http://verbalexpressions.github.io/) for Delphi.

# Example

```Delphi
var
  LobjVerbalExpression : TVerbalExpression;
begin
  LobjVerbalExpression := TVerbalExpression.Create
    .StartOfLine()
    .Then('http')
    .Maybe('s')
    .Then('://')
    .Maybe('www.')
    .anythingBut(' ')
    .endOfLine();

  ListBox1.Items.Add(LobjVerbalExpression.AsString);

  if LobjVerbalExpression.Test('https://github.com') then
    ListBox1.Items.Add('valid url')
  else
    ListBox1.Items.Add('invalid url');

end;

```
