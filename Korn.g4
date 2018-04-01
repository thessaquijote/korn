grammar Korn;

program:
    (statement | subprogramDefinition | boxDefinition | NEWLINE)+ | (EOF)
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
    ReturnKeyword (assignmentRightOperand) NEWLINE+
;

block:
    BlockStarter statement+ blockEnd
;

unEndedBlock:
    BlockStarter statement+
;

variableBlock:
    BlockStarter (varDeclaration NEWLINE+)+ End NEWLINE
;

boxElement:
    boxname=Identifier RecordMemberOperator member=Identifier
;

boxDefinition:
    RecordKeyword boxname=Identifier variableBlock
;

arrayDeclaration:
    type=(Identifier|DataType) arrayname=Identifier ArrayRangeKeyword arraylength=number
;

statement:
    (varDeclaration
    | assignmentExpression
    | subprogramCall
    | conditionalStatement
    | iterationalStatement)
    (NEWLINE+ | EOF)
;

iterationalStatement:
    doWhileStatement
    | whileStatement
    | forEachStatement
;

doWhileStatement:
    RunKeyword unEndedBlock WhileKeyword condition
;

whileStatement:
    WhileKeyword condition block
;

forEachStatement:
    ForEachKeyword member=Identifier ArrayIteratorKeyword arrayname=Identifier block
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
    StepKeyword stepname=Identifier subprogramDefinitionArguments? stepBlock
;

taskDefinition:
    TaskKeyword taskname=Identifier subprogramDefinitionArguments? taskBlock
;

subprogramCall:
    SubprogramInvoker function=Identifier subprogramCallArguments?
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
    varname=Identifier (Separator varname=Identifier)*
;

variableList:
    variable (Separator variable)*
;

variable:
    name=Identifier
    | arrayElement
    | boxElement
;

arrayElement:
    arrayname=Identifier OpenBracket arrayindex=(DigitSequence | Identifier) CloseBracket
;

expression:
    assignmentExpression
    | relationalExpression
    | arithmeticExpression
    | logicalExpression
    | equalityExpression
;

condition:
    identifier
    | relationalExpression
    | logicalExpression
    | equalityExpression
;

assignmentExpression:
    variable AssignmentOperator assignmentRightOperand
;

assignmentRightOperand:
    variable
    | value
    | arithmeticExpression
    | relationalExpression
    | logicalExpression
    | subprogramCall
;

logicalExpression:
    (booleanValue | variable) (operator=LogicalOperator (booleanValue | variable))+
    | (operator=LogicalOperatorNot (booleanValue | variable))
;

equalityExpression:
    (value | variable) (operator=EqualityOperator (value | variable))+
;

relationalExpression:
    (number | variable) (operator=RelationalOperator (variable | number))+
;

arithmeticExpression:
    arithmeticOperand (operator=ArithmeticOperator (arithmeticOperand))+
;

arithmeticOperand:
    number
    | variable
;

varDeclaration:
    primitiveVarDeclaration
    | arrayDeclaration
    | boxDeclaration
;

primitiveVarDeclaration:
    dataType variableList
;

boxDeclaration:
    boxname=identifier varname=identifier
;

value:
    nonBooleanValue
    | booleanValue
;

nonBooleanValue:
    number
    | string
;

booleanValue:
    Boolean
;

string:
    StringLiteral
;

number:
    decimal
    | wholenumber=DigitSequence
;

decimal:
    wholenumber=DigitSequence RecordMemberOperator decimalvalue=DigitSequence
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
ArrayRangeKeyword:      'from 1 to';
AssignmentOperator:     'gets';
LogicalOperator:        'and' | 'or';
LogicalOperatorNot:     'not';
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
ForEachKeyword:         'for each';
RunKeyword:             'run';
ArrayIteratorKeyword:   'in';
RecordKeyword:          'box';
ReturnKeyword:          'return';
OpenBracket:            '[';
CloseBracket:           ']';
BlockStarter:           ':' NEWLINE+;
Quote:                  '"';
OneQuote:               '\'';
Separator:              ',';
End:                    'end';
DigitSequence:          Digit+;
Digit:                  Zero | NonZeroDigit;
NonZeroDigit:           [1-9];
RecordMemberOperator:   Dot;
Identifier:             NonDigitCharacter CharacterSequence*;
StringLiteral:          ('"' ( '\\' [\\"] | ~[\\"] )* '"') | ('\'' ( '\\' [\\"] | ~[\\"] )* '\'');
Zero:                   [0];
NonDigitCharacter:      [a-zA-Z_];
Dot:                    '.';
CharacterSequence:      Character+;
Character:              NonDigitCharacter | Digit;
NEWLINE:                [\n\r] | EOF;
Comments:               '/**' ( '\\' [\\"] | ~[\\"] )* '**/' -> skip;
Spaces:                 [ \t]+ -> skip;
GARBAGELINE:            ('\n') -> skip;
