%{
  var nodes = require('./nodes')
%}

%%

program:
  statements EOF                   { return $1 }
;

statements:
  statement                        { $$ = new nodes.Block([ $1 ]) }
| statements NEWLINE statement     { $$ = $1.add($3) }
| statements NEWLINE               { $$ = $1 }
;

statement:
  if
| assignment
| receiver
| callWithString
| callWithBlock
| times
| every
| exit
;

expression:
  receiver
| comparison
| callWithString
| callWithBlock
;

receiver:
  call
| callWithNumber
;

call:
  NAME                           { $$ = new nodes.Call(null, $1) }  
| receiver NAME                  { $$ = new nodes.Call($1, $2) }  
;

callWithString:
  NAME COLON string              { $$ = new nodes.Call(null, $1, [ $3 ]) }
| receiver NAME COLON string     { $$ = new nodes.Call($1, $2, [ $4 ]) }
;

callWithNumber:
  NAME number                      { $$ = new nodes.Call(null, $1, [ $2 ]) }
| NAME number COLON block          { $$ = new nodes.Call(null, $1, [ $2 ], $4) }
| receiver NAME number             { $$ = new nodes.Call($1, $2, [ $3 ]) }
| receiver NAME number COLON block { $$ = new nodes.Call($1, $2, [ $3 ], $5) }
;

callWithBlock:
  NAME COLON block               { $$ = new nodes.Call(null, $1, [], $3) }
| receiver NAME COLON block      { $$ = new nodes.Call($1, $2, [], $4) }
;

string:
  stringPart                     { $$ = new nodes.String($1) }
| string stringPart              { $$ = $1.add($2) }
;

stringPart:
  STRING                         { $$ = new nodes.Literal($1) }
| STRING_NAME                    { $$ = new nodes.Call(null, $1, []) }
;

exit:
  EXIT                           { $$ = new nodes.Exit() }
;

number:
  NUMBER                         { $$ = new nodes.Literal($1) }
;

if:
  IF expression block            { $$ = new nodes.If($2, $3) }
| IF expression 
    notlastblock 
  ELSE 
    block                        { $$ = new nodes.If($2, $3, $5) }
;

times:
  number TIMES block             { $$ = new nodes.Times($1, $3) }
;

every:
  EVERY number block             { $$ = new nodes.Every($2, $3) }
;

block:
  NEWLINE
  INDENT
    statements
  DEDENT                         
  END                            { $$ = $3 }
;

notlastblock:
  NEWLINE
  INDENT
    statements
  DEDENT                         { $$ = $3 }
;

assignment:
  NAME EQ string                 { $$ = new nodes.Assignment($1, $3) }
|  NAME GETS call                { $$ = new nodes.Assignment($1, $3) }
|  NAME GETS callWithString      { $$ = new nodes.Assignment($1, $3) }
;

comparison:
  receiver COMP string           { $$ = new nodes.Comparison($1, $2, $3) }
| receiver EQ string             { $$ = new nodes.Comparison($1, '==', $3) }
;

%%

parser.lexer = require('./lexer')
