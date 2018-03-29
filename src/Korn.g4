grammar Korn;

program:
    (statement | subprogramDefinition | boxDefinition)* EOF
;

stepBlock:
    BlockStarter statement+ blockEnd
;

taskBlock:
    BlockStarter statement* returnStatement blockEnd
;

blockEnd:
    End
;

returnStatement:
    ReturnKeyword (value | variable) NEWLINE
;

block:
    BlockStarter statement+ blockEnd
;

variableBlock:
    BlockStarter (varDeclaration NEWLINE)+ End
;

boxElement:
    Identifier RecordMemberOperator Identifier
;

boxDefinition:
    RecordKeyword Identifier variableBlock
;

arrayDeclaration:
    DataType Identifier ArrayRangeKeyword number
;

arrayElement:
    Identifier OpenBracket NonZeroDigit CloseBracket
;

statement:
    (varDeclaration
    | expression
    | subprogramCall
    | conditionalStatement
    | iterationalStatement)
    NEWLINE+
;

iterationalStatement:
    doWhileStatement
    | whileStatement
;

doWhileStatement:
    DoKeyword block WhileKeyword condition
;

whileStatement:
    (WhileKeyword condition | WhileKeyword Identifier ArrayIteratorKeyword Identifier) block
;

conditionalStatement:
    whenStatement
    | ifStatement
;

whenStatement:
    WhenKeyword condition block (IsKeyword nonBooleanValue block)* (NoneKeyword block)?
;

ifStatement:
    IfKeyword condition block (ElseIfKeyword condition block)* (ElseIfKeyword block)?
;

subprogramDefinition:
     stepDefinition
     | taskDefinition
;

stepDefinition:
    StepKeyword Identifier subprogramDefinitionArguments? stepBlock
;

taskDefinition:
    TaskKeyword Identifier subprogramDefinitionArguments? taskBlock
;

subprogramCall:
    SubprogramInvoker Identifier subprogramCallArguments?
;

subprogramDefinitionArguments:
    ArgumentOperator noArrayVariableList
;

subprogramCallArguments:
    ArgumentOperator (variableList | valueList)
;

valueList:
    value (Separator value)*
;

noArrayVariableList:
    Identifier (Separator Identifier)*
;

variableList:
    variable (Separator variable)*
;

variable:
    Identifier
    | arrayElement
    | boxElement
;

expression:
    (assignmentExpression
    | relationalExpression
    | arithmeticExpression
    | logicalExpression
    | equalityExpression)
;

condition:
    identifier
    | relationalExpression
    | logicalExpression
    | equalityExpression
;

assignmentExpression:
    variable AssignmentOperator (expression | variable | value | subprogramCall)
;

logicalExpression:
    (Boolean | variable) (LogicalOperator (Boolean | variable))+
;

equalityExpression:
    (value | variable) (EqualityOperator (value | variable))+
;

relationalExpression:
    (number | variable) (RelationalOperator (variable | number))+
;

arithmeticExpression:
    (number | variable) (ArithmeticOperator (number | variable))+
;

varDeclaration:
    dataType variableList
    | arrayDeclaration
    | boxDeclaration
;

boxDeclaration:
    identifier identifier
;

value:
    nonBooleanValue
    | boolean
;

nonBooleanValue:
    number
    | string
;

string:
    StringLiteral
;

boolean:
    Boolean
;

number:
    DigitSequence
    | decimal
;

decimal:
    DigitSequence Dot DigitSequence
;

identifier:
    Identifier
;

dataType:
    DataType
;



DataType:               'letter' | 'number' | 'decimal' | 'sentence' | 'boolean';
Boolean:                'true' | 'false';
ArithmeticOperator:     '*' | 'multiply with' | '+' | 'add with' | '-' | 'subtract with' | '/' | 'divide with';
RelationalOperator:     '>' | '>=' | '<' | '<=';
EqualityOperator:       'is equal to' | 'is not equal to';
AssignmentOperator:     'gets';
LogicalOperator:        'and' | 'or';
TaskKeyword:            'task';
StepKeyword:            'step';
ArgumentOperator:       'with';
SubprogramInvoker:      'do';
IfKeyword:              'if';
ElseKeyword:            'else';
ElseIfKeyword:          'else if';
WhenKeyword:            'when';
IsKeyword:              'is';
NoneKeyword:            'none';
WhileKeyword:           'while';
DoKeyword:              'do';
ArrayIteratorKeyword:   'in';
ArrayRangeKeyword:      'from 1 to';
RecordKeyword:          'Box';
ReturnKeyword:          'return';
BlockStarter:           ':' NEWLINE;
OpenBracket:            '[';
CloseBracket:           ']';
Quote:                  '"';
OneQuote:               '\'';
Separator:              ',';
End:                    'end';
DigitSequence:          Digit+;
Digit:                  Zero | NonZeroDigit;
RecordMemberOperator:   Dot;
Identifier:             NonDigitCharacter CharacterSequence*;
StringLiteral:          ('"' ( '\\' [\\"] | ~[\\"] )* '"') | ('\'' ( '\\' [\\"] | ~[\\"] )* '\'');
NonZeroDigit:           [1-9];
Zero:                   [0];
NonDigitCharacter:      [a-zA-Z_];
Dot:                    '.';
CharacterSequence:      Character+;
Character:              NonDigitCharacter | Digit;
Comments:               '/**' ( '\\' [\\"] | ~[\\"] )* '**/' -> skip;
Spaces:                 [ \t]+ -> skip;
NEWLINE:                ('\r' | '\n');
GARBAGELINE:            ('\n') -> skip;
