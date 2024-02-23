[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/xwu23fyL)
# Phase II - Parser

In this phase you will undertake the modifications to the Parser phase of the PT Pascal compiler
to turn it into a Parser for Infero. These changes will be much more extensive than those in Phase 1. The following suggestions are provided to guide you in this phase, but remember - this is **not
guaranteed to be a complete list of changes**. The real goal is to implement a parser for Infero as
described in the [Infero language specification](docs/language-specs.md).

### Important - Before you start!
The code is in repository is the original PT compiler. You need to replace [`scan.ssl`](parser/scan.ssl), [`parser.pt`](parser/parser.pt), and [`stdIdentifiers`](parser/stdIdentifiers) with your phase I solution. After doing so, make sure everything is in order by building the scanner using `make scanner`.

If you're not condident with your Phase I solution, you can instead copy these files from the instructor solution, available on the CAS lab machines: `/cas/course/cisc458/instructor_solution/phase1`

We highly recommend you use your own solution though! It will feel much better at the end knowing you have built your very own Infero compiler!

### Suggestions for Implementing Phase 2

The general strategy in our Infero parser will be to emit, as much as possible, the same semantic
token stream for our Infero programs as would be emitted by the PT Pascal parser for the
equivalent PT Pascal program. In this way, we will minimize the changes necessary to the
semantic phase in Phase 3.

##### Token Definitions
Modify the parser input token list in [`parser.ssl`](parser/parser.ssl) to correspond to the new set of output tokens
emitted by your Infero Scanner/Screener. Remove the unused old parser input tokens and add
the new Infero input tokens. Make sure the two token sets ([`scan.ssl`](parser/scan.ssl) output tokens, [`parser.ssl`](parser/parser.ssl) input tokens) match exactly - this is the usual source of problems! 

Don't forget to add the string synonyms for all the new tokens of Infero (e.g. *pPlusEquals* '+=' ), and to update the string synonyms for the changed tokens of Infero (e.g. *pNotEqual* '!=' ).

Replace the old PT parser type declaration output token *sType* with *sTypeof*, since Infero doesn't
have type declarations and uses **typeof** for types instead. Add new parser output tokens for Infero
packages, *sPackage* and *sPublic*, and for the Infero string operations *sConcatenate*, *sRepeatString*, *sSubstring* and *sLength*. Finally, add a new *sInitialValue* output token for Infero variable initial values, and an *sCaseElse* output token for Infero **choose** statements.

##### Programs
Modify the parsing of programs (the *Program* rule) to meet the Infero language specification. Infero
main programs are different from PT, in that Infero makes no distinction between declarations and
statements. So you will have to change the main loop of the *Block* rule to accept a sequence of
any number of declarations or statements in any order. I suggest that you merge the alternatives in the existing *Statement* rule into the alternatives in the *Block* rule to do this.

In order to make the differences in Infero less visible to the semantic phase, we will always output
a Infero sequence of declarations and statements as if it were a PT Pascal **begin**...**end** statement - that is, emit an *sBegin* token before the sequence (i.e., at the beginning of the *Block* rule) and
an *sEnd* after it (at the end of the rule). In this way, it will look to the semantic phase like not
much about main programs has changed.

For example, the Infero main program:
<pre>
<b>using</b> output;
<i>DeclarationsAndStatements</i>
</pre>

Should yield the parser output token stream:
<pre>
sProgram
sIdentifier &ltidentifier index for 'output'&gt
sParmEnd
sBegin
    <i>DeclarationsAndStatements</i>
sEnd
</pre>

Exactly like the equivalent PT main program.

##### Declarations
Remove the parsing of PT type definitions (the *TypeDefinitions*, *TypeBody* and *SimpleType*
rules), and modify the parsing of constant and variable declarations to meet the Infero language
specification.

Modify the parsing of const declarations (*ConstantDefinitions* rule) to handle Infero's comma-separated
list of constant definitions rather than PT's semicolon-separated ones. Modify parsing of variable declarations (*VariableDeclarations* rule) to restrict to Infero's single variable declaration rather than PT's semicolon-separated list.

Infero uses either an initial value or a typeof clause to specify the variable's type, so in place of the
call to *TypeBody* for the type of the variable, call a new rule called *ValueOrTypeof*, which accepts
either an initial value (e.g. **var** x = 1; ) or a **typeof** clause (e.g., **var** x : **typeof** 1; ).

The output token stream for the initial value case: **var** x = *Expression*; should be :
<pre>
sVar
sIdentifier &ltidentifier index for 'x'&gt
sInitialValue
    <i>Expression</i>
sExpnEnd
</pre>

Make a new *TypeofClause* rule, which allows for an array bound (e.g., **var** x [5] : **typeof** 1; ) followed by a colon, an optional **file** keyword (e.g. **var** x : **file** **typeof** output; ), the keyword **typeof**, and a variable or constant, which can be either an identifier or a constant value (using the existing PT *ConstantValue* rule).

Use the output token *sArray* for arrays, and *sFile* for files. For example, the Infero declaration:
<pre>
<b>var</b> x [<i>ConstantValue</i>] : <b>typeof</b> <i>VariableOrConstant</i>;
</pre>

should yield the output token stream:
<pre>
sVar
sIdentifier &ltidentifier index for 'x'&gt
sArray
    <i>ConstantValue</i>
sTypeof
    <i>VariableOrConstant</i>
</pre>

Both constant and variable declarations in Infero can optionally be declared public. For these
declarations, the *sPublic* token should be emitted following the declared identifier. For example,
the variable declaration:
<pre>
<b>public</b> <b>var</b> z : <b>typeof</b> 1;
</pre>

should yield the output token stream:
<pre>
sVar
sIdentifier &ltidentifier index for 'x'&gt
sPublic
sTypeof
sInteger 1
</pre>

##### Routines
Modify the parsing of routines (PT procedures, Infero functions) to meet the Infero language
specification. In particular, Infero uses commas instead of semicolons to separate formal
parameters, and **typeof** clauses instead of type names for parameter types. Use your new
*TypeofClause* rule for parameter types.

As much as possible, the output token stream for a Infero function should be the same as for the
equivalent PT procedure, in order to minimize the changes to the semantic phase. In particular,
you should use your modified *Block* rule as suggested above so that the declarations and
statements in the body of the function are output surrounded by *sBegin* and *sEnd*.

For example, the Infero function declaration:
<pre>
<b>fun</b> F <b>is</b>
    <i>DeclarationsAndStatements</i>
<b>end</b>;
</pre>

Should yield the parser output token stream:
<pre>
sProcedure
sIdentifier &ltidentifier index for 'P'&gt
sParmEnd
sBegin
    <i>DeclarationsAndStatements</i>
sEnd
</pre>

Infero constants and variables, Infero functions can optionally be declared **public**, and the *sPublic*
token should be emitted following the function identifier. For example:
<pre>
<b>public</b> <b>fun</b> F <b>is</b>
    <i>DeclarationsAndStatements</i>
<b>end</b>;
</pre>

Should yield the parser output token stream :
<pre>
sProcedure
sIdentifier &ltidentifier index for 'P'&gt
sPublic
sParmEnd
sBegin
    <i>DeclarationsAndStatements</i>
sEnd
</pre>

##### Packages
Add parsing of packages as specified in the Infero language specification. A package is like a
main program, but without the **using** clause. The output stream should use the token *sPackage*
to mark the beginning of the package. The body of the package should be preceded by an
*sBegin* token and ended by an *sEnd* token (i.e., you should once again use your modified *Block*
rule to handle the body of the package).

For example, the Infero package declaration:
<pre>
<b>pkg</b> M <b>is</b>
    <i>DeclarationsAndStatements</i>
<b>end</b>;
</pre>

Should yield the parser output token stream:
<pre>
sPackage
sIdentifier &ltidentifier index for 'M'&gt
sBegin
    <i>DeclarationsAndStatements</i>
sEnd
</pre>

Note that packages cannot be declared **public**.

##### Statement Sequences
PT Pascal allows only a single statement inside **if**, **case**, **while** and **repeat** statements, and the special **begin**...**end** statement (kind of like {...} in C) allows for sequences of statements. While **begin**...**end** is removed from Infero, we can save ourselves a lot of work in the Semantic phase
by outputting all declaration-or-statement sequences in Infero with *sBegin* .. *sEnd* semantic
tokens around them, so that it still thinks it's handling regular PT. We can do this very simply, by
replacing the entire PT *Statement* rule with one that just calls our new version of the *Block* rule.

##### Statements
Modify the parsing of **if**, **while**, **repeat** and **case** statements to instead meet the language specification for Infero **if**, **repeat while** and **choose** statements. Remove the old PT **begin**...**end** statement. The goal is to have the output token stream for the Infero parser be, as much as possible, the same as the output token stream for the corresponding statements in the PT
parser. In this way, we will minimize the changes necessary in the semantic phase.

For example, the Infero if statement :
<pre>
<b>if</b> x == y <b>then</b>
    <i>DeclarationsAndStatements1</i>
<b>else</b>
    <i>DeclarationsAndStatements2</i>
<b>end</b>;
</pre>

Should yield the parser output token stream :
<pre>
sIfStmt
sIdentifier &ltidentifier index for 'x'&gt
sIdentifier &ltidentifier index for 'y'&gt
sEq
sExpnEnd
sThen
sBegin
    <i>DeclarationsAndStatements1</i>
sEnd
sElse
sBegin
    <i>DeclarationsAndStatements2</i>
sEnd
</pre>

##### Else-if Clauses
The handling of **elseif** in the Infero **if** statement presents us with a choice. We can either:
1. use a new semantic token *sElseIf* to represent **elseif**, and modify the semantic phase of the compiler to handle it in the next phase, or
2. not use any new semantic tokens, and simply output the token stream corresponding to the equivalent PT Pascal nested if statements, so that the semantic phase will not have to be modified to handle **elseif** at all.

The first alternative would add a new *sElseIf* semantic token to the output token stream for the **if**
statement, and handle it in the semantic phase. If instead we choose the second alternative, the
parser output token stream for an **if** statement with an **elseif**, such as this one:
<pre>
<b>if</b> x == 42 <b>then</b>
    <i>DeclarationsAndStatements1</i>
<b>elseif</b> y == 71 <b>then</b>
    <i>DeclarationsAndStatements2</i>
<b>else</b>
    <i>DeclarationsAndStatements3</i>
</pre>

Should be the same as the output stream for the equivalent nested if statement:
<pre>
<b>if</b> x == 42 <b>then</b>
    <i>DeclarationsAndStatements1</i>
<b>else</b>
    <b>if</b> y == 71 <b>then</b>
        <i>DeclarationsAndStatements2</i>
    <b>else</b>
        <i>DeclarationsAndStatements3</i>
    <b>end</b>;
<b>end</b>;
</pre>

That is to say:
<pre>
sIfStmt
sIdentifier &ltidentifier index for 'x'&gt
sInteger 42
sEq
sExpnEnd
sThen
sBegin
    <i>DeclarationsAndStatements1</i>
sEnd
sElse
sBegin
    sIfStmt
    sIdentifier &ltidentifier index for 'y'&gt
    sInteger 71
    sEq
    sExpnEnd
    sThen
    sBegin
        <i>DeclarationsAndStatements2</i>
    sEnd
    sElse
    sBegin
        <i>DeclarationsAndStatements3</i>
    sEnd
sEnd
</pre>

This way, you won't have to implement **elseif** in the semantic phase at all, because it will never
see it! This is typical of decisions made by compiler writers - many language features can be
implemented either in one phase or in the next. In this case, we can either implement **elseif** in
the parser (this phase) or in the semantic analyzer (next phase).

Neither decision is strictly the right one, and neither is wrong. The amount of work to implement
the feature is about the same either way. It is up to you to decide which you want to do.

##### Choose Statement
The output for Infero **choose** statements should be the same as the corresponding **case**
statements of PT Pascal, using the old PT *sCase* and *sCaseEnd* semantic tokens. The
meaning of the Infero **choose** statement and the PT **case** statement is identical, except for the
addition of the Infero optional **else** alternative - so the semantic token stream can be the same.

The Infero optional **else** alternative in choose statements is new, and we must handle it specially.
But what we will do is simple - just check for an **else** following the other alternatives in the case
statement, and output the *sCaseElse* output token followed by the statements of the **else**
clause, using the modified *Statement* rule to enclose them in *sBegin .. sEnd*. The old
*sCaseEnd* token should be output before the else clause, so that the output for **case** statements
is exactly the same as it was in PT, except that it may optionally be followed by the *sCaseElse*.

For example, the Infero **choose** statement:
<pre>
<b>choose</b> i <b>of</b>
    <b>when</b> 42, 43 <b>then</b>
        <i>DeclarationsAndStatements1</i>
    <b>when</b> 44 <b>then</b>
        <i>DeclarationsAndStatements2</i>
    <b>else</b>
        <i>DeclarationsAndStatements3</i>
<b>end</b>;
</pre>

Should yield the parser output token stream:
<pre>
sCaseStmt
sIdentifier &ltidentifier index for i&gt
sExpnEnd
sInteger 42
sInteger 43
sLabelEnd
sBegin
    <i>DeclarationsAndStatements1</i>
sEnd
sInteger 44
sLabelEnd
sBegin
    <i>DeclarationsAndStatements2</i>
sEnd
sCaseEnd
sCaseElse
sBegin
    <i>DeclarationsAndStatements3</i>
sEnd
</pre>

##### Repeat While Statement
Modify the parsing of **while** and **repeat** statements to use the new Infero **repeat while** syntax. The
**repeat while** ... **end** form is the equivalent of the PT **while** statement, and the **repeat** ... **while** form is the equivalent of the PT repeat statement, so simply reuse the existing *WhileStmt* and
*RepeatStmt* rules to handle them. Make sure that you get the new syntax right!

The Infero **repeat** ... **while** loop looks like a PT **repeat** ... **until** loop, but it has the opposite meaning - it repeats its body while the condition is true, rather than while it is false. To adapt to this and save us work in the Semantic phase, we can just output an *sNot* operation following the
conditional expression in the *RepeatStmt* rule to invert the condition, and we won't have to
change anything in the Semantic phase!


##### Short Form Assignments
Add the parsing of the Infero short form assignment statements `+=`, `–=`, `*=`, `/=`, and `%=`. This is
another case where we can save ourselves work in the Semantic phase by simply outputting
the semantic token stream for a regular assignment, so that the Semantic phase doesn’t really
have to handle short form assignments at all.

For example, for the short form assignment `i += 10`, we will output the semantic token
stream for the equivalent regular assignment `i = i + 10`, that is:
<pre>
sAssignmentStmt
sIdentifier &ltidentifier index for 'i'&gt
sIdentifier &ltidentifier index for 'i'&gt
sInteger 10
sAdd
sExpnEnd
</pre>

##### The String type
Infero replaces the old PT ***char*** data type with a varying length string type. Add handling of the
new Infero string operators concatenate ( `s | s` ), repeat string ( `s || n` ), substring ( `s / n : m` )
and length ( `# s` ). Modify the parsing of expressions to recognize and emit the corresponding
semantic tokens (*sConcatenate*, *sRepeatString*, *sSubstring*, *sLength* ) for each of these new
operators.

The precedence of the concatenate and repeat string operators is the same as integer addition,
the precedence of the substring operator `string / expression : expression` is the same as integer `/`, and
the precedence of the length operator `#` is the same as the precedence of boolean **not**. All of
the new operators should be converted to postfix by your parser, using the corresponding new
output semantic tokens.

The `string / expression : expression` operator is somewhat unusual, in that it takes three
operands (the string and two integer expressions), but this does not affect the form of the postfix
output, which should consist of the three operands followed by the operator.

For example, the substring operation:
```
"Hi there" / 1 : 2
```

Should yield the parser output stream:
<pre>
sStringLiteral "Hi there"
sInteger 1
sInteger 2
sSubstring
</pre>

##### Operator Syntax
Change the syntax of the PT operators to the corresponding Infero operators described in the
Infero language specification. For example, PT **div** and **mod** are `/` and `%` in Infero, and PT `:=`, `=`,
and `<>` are `=`, `==`, and `!=` respectively.

##### Other Syntactic Details
Watch out for other minor syntactic differences between PT Pascal and Infero - for example,
semicolon is a separator between statements in PT, but it is part of the statements (including the
null statement) in Infero.

##### Language Specification
Whenever you have any questions about what is allowed or not allowed in Infero, refer to the [Infero language specification](docs/language-specs.md). Any forms not explicitly defined there retain their original PT Pascal form and meaning.

No modifications, extensions or changes to the Infero language are allowed in your compiler; you
must implement the language exactly as specified. If you have any doubts about what is
intended ask your TA for an interpretation.