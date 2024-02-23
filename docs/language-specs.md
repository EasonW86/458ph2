#  The Infero Language

Infero is a modular programming language with features similar to other modern languages like Ruby, Swift, Go, and Python. However, from our point of view, it is a modification and extension to PT Pascal. The main differences between PT and Infero are new syntax for programs, statements and declarations, the addition of Infero packages, the replacement of the ***char*** data type with the string data type, the removal of type declarations and the replacement of all built-in and named types with the **typeof** phrase, the addition of Infero's **elseif** to **if** statements, the replacement of the PT **repeat**-**until** statement with Infero's **repeat**-**while** statement, and the replacement of PT's **case** statement with Infero's **choose** statement.

In the following,
- [ item ] means the item is optional, and
- { item } means zero or more repeated occurrences of the item.
- Keywords are shown in **bold face**, and predefined identifiers in ***bold italics***.
- Syntactic forms (non-terminals) not defined here are as defined in original PT Pascal.

### Comments
Infero changes to C-style comments, which consist of **//** to end of line and **/\* … \*/**.
PT Pascal **{ ... }** and **(\* ... \*)** comments are deleted from Infero.

### Programs
A Infero program is :
<pre>
<b>using</b> identifier { , identifier } ;
{ <i>declarationOrStatement</i> }
</pre>

Where declaration and statement are as described below.
The **using** identifiers are the program parameters (internal names for external files) of the
program, as in PT. Execution of the Infero program consists of initializing the declarations and
executing the statements in the order that they appear.

### Sequence of Declarations and Statements
Unlike PT Pascal, Infero does not require declarations to precede statements, and statements
and declarations may be arbitrarily intermixed. The scope of declarations in a Infero statement
sequence is from the declaration itself until the end of the sequence.

A *declarationOrStatement* is one of:
1. [declaration](#declarations)
2. [statement](#statements)

In Infero, semicolons are part of statements and declarations rather than separators between them
as in PT. However, the null statement (consisting of a semicolon alone) allows additional
semicolons to appear between declarations and statements even when not required.

### Declarations
Infero declarations are mostly similar to PT, except that types are removed and variables may
have an initial value.

A declaration is one of:
1. *constantDeclaration*
2. *variableDeclaration*
3. routine
4. package

A *constantDeclaration* is:
<pre>
[ <b>public</b> ] <b>val</b> identifier = constant { , identifier = constant } ;
</pre>

A *variableDeclaration* is one of:
<pre>
1. [ <b>public</b> ] <b>var</b> identifier = expression ;
2. [ <b>public</b> ] <b>var</b> identifier [ <i>arrayBound</i> ] : [ <b>file</b> ] <b>typeof</b> <i>variableOrConstant</i> ;
</pre>

Where an *arrayBound* is :
<pre>
[ constant ]
</pre>

And *variableOrConstant* is one of :
1. variable_identifier
2. constant

Where constant and expression are as described in the PT Pascal syntax.

As in PT, constant (**val**) declarations take on the type of their value. Unlike PT, Infero has no
explicit types (e.g., ***integer*** and ***char***) for variables. Instead, variable (**var**) declarations in Infero take on the type of their initial value, if given, or the type of the constant or variable they are
declared to be **typeof**.

For example, `var x = 5;` declares `x` to be an integer variable with initial value `5`, and `var y : typeof x;` declares `y` to be a variable of the same type as `x`, in this case ***integer***.

The *arrayBound*, if present, declares a variable to be an array. In Infero, all arrays are indexed
starting from 1 and ending with the given upper bound.

The optional **public** before **val** and **var** declarations indicates a public constant or variable,
one that can be referenced outside of the package it is declared in. See [Packages](#packages) below.

### Packages
One of the most powerful modern software engineering tools is the concept of information
hiding. Modern programming languages include special syntactic forms for information hiding
such as classes or modules. One of the weaknesses of PT Pascal is its lack of such a feature.

Infero solves this problem by adding packages. Infero "anonymous classes" in C++ and Java, Infero packages are single-instance.

A package is:
<pre>
<b>pkg</b> identifier <b>is</b>
    { <i>declarationOrStatement</i> }
<b>end</b> ;
</pre>

The purpose of a package is to hide the internal declarations, data structures and routines
from the rest of the program. Outside of the package, only those constants, variables and
routines declared as public may be referenced.

The purpose of the statements inside the package is to initialize the package's internal data.
During execution, the statements of each package are executed once to initialize the package
before commencing execution of the statements of the main program.

### Statements
Infero replaces the syntax of PT Pascal statements with a more modern style in which any
number of statements can appear wherever one statement can, rendering PT's **begin**...**end**
statement obsolete. 

Infero replaces PT’s **repeat**-**until** statement with **repeat**-**while**, replaces
PT's **case** statement with a new **choose** statement with an **else** clause, and adds a modern **elseif** form to **if** statements. Infero also adds short form assignments `+=`, `-=`, `*=`, `/=`, and `%=` for incrementing / decrementing simple variables.

A statement is one of the following:

<pre>
1. variable = expression ;

2. variable_identifier [ += | –= | *= | /= | %= ] expression ;

3. routine_identifier [ ( [ <b>var</b> ] expression { , [ <b>var</b> ] expression } ) ] ;

4. <b>if</b> expression <b>then</b>
    &nbsp;&nbsp;&nbsp;&nbsp;{ <i>declarationOrStatement</i> }
&nbsp;{ <b>elseif</b> expression <b>then</b>
    &nbsp;&nbsp;&nbsp;&nbsp;{ <i>declarationOrStatement</i> } }
&nbsp;[ <b>else</b>
    &nbsp;&nbsp;&nbsp;&nbsp;{ <i>declarationOrStatement</i> } ]
&nbsp;&nbsp;&nbsp;<b>end</b> ;

5. <b>repeat</b> <b>while</b> expression
&nbsp;&nbsp;&nbsp;&nbsp;{ <i>declarationOrStatement</i> }
&nbsp;&nbsp;&nbsp;<b>end </b>;

6. <b>repeat</b>
&nbsp;&nbsp;&nbsp;&nbsp;{ <i>declarationOrStatement</i> }
&nbsp;&nbsp;&nbsp;<b>while</b> expression ;

7. <b>choose</b> expression <b>of</b>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>when</b> constant { , constant } <b>then</b>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{ <i>declarationOrStatement</i> }
&nbsp;&nbsp;&nbsp;{ <b>when</b> constant { , constant } <b>then</b>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{ <i>declarationOrStatement</i> } }
&nbsp;&nbsp;&nbsp;[ <b>else</b>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{ <i>declarationOrStatement</i> } ]
&nbsp;&nbsp;&nbsp;<b>end</b> ;

8. ;
</pre>

Where variable, expression and constant are as defined in the PT Pascal syntax.
As in PT, routine calls in Infero don't take an argument list if there are no arguments. Arguments
with **var** are assignable arguments, must be variables, and must be passed to **var** parameters.
Infero retains all of the PT Pascal input/output routines, but renames ***write*** to ***put***, ***writeln*** to ***putln***, ***read*** to ***get***, and ***readln*** to ***getln***.

### Character Strings
Text manipulation in standard Pascal is painful because of the necessity of shovelling
characters around one-by-one. Modern languages solve this problem by providing a built-in
varying-length string data type or library. Infero adds character strings to PT, replacing single
characters and the ***char*** data type.

A Infero character string literal is any sequence of characters except the double quote enclosed
between double quotes. For example:
```
"This is a string"
```

String variables take on the length of the last value that they were assigned. Example:
```
s = “hi"; // length of s is now 2
s = "there"; // length of s is now 5
```

There is an implementation-defined maximum length (1,023 characters) for string values.

Infero character strings are implemented by storing the string value with an extra trailing
character (ASCII NUL, the byte 0) marking the end of the string, as in C. Each string variable
is allocated a fixed amount of memory (256 bytes) within which the string value (including the
trailing 0 byte) is stored.

Strings can be input and output to/from text files and streams. On input, the string read
consists of the characters from the next input character to the end of the input line.

Unlike arrays of ***char*** in PT Pascal, character string variables cannot be subscripted, and can
be assigned and compared as a whole. Besides assignment and comparison, there are four
new operations on character strings: concatenation, repetition, substring and length.

Concatenation of strings is denoted by the `|` operator. For example:
```
"hi " | "there" == "hi there"
```
It is an error to concatenate two strings if the sum of their lengths exceeds the implementation-defined
maximum (255 characters, detected at run time).

Repetition of strings is denoted by the `||` operator. For example:
```
"hi " || 4 == "hi hi hi hi "
```
The second operand must be an integer expression. It is an error to repeat strings if the result
length exceeds the implementation-defined maximum (255 characters, detected at run time).

The precedence of `|` and `||` is the same as `+`, `-`, and **or**.

The Infero substring operation is denoted by the `/` operator. The general form is:
```
expression / expression : expression
```
The first expression must be a string expression. The second and third expressions, which
must be integer expressions, specify the (1 origin) first character position and last character
position of the substring respectively. Example:
```
"Hi there" / 4 : 6 == "the"
```
The precedence of `/` (including the `:` part) is the same as `*`, `/`, `%`, and **and**.

The string length operator has the form:
<pre>
# expression
</pre>

Where the expression must be a string expression. Example:
<pre>
# "Karim" == 5
</pre>

The precedence of `#` is the same as that of **not**.

### Operators
In Infero, many of the standard operators are changed from PT. In particular:
|PT     | Infero|
|-------|-----|
|:=     | =   |
|=      | ==  |
|<>     | !=  |
|**div**|/    |
|**mod**|%    |

### An Example Program
<pre>
// Primes: determines the primes up to maxprimes using the sieve method
<b>using</b> output;
<b>val</b> maxprimes = 100;<BR>
// Prime flags
<b>pkg</b> flags <b>is</b>
	<b>public</b> <b>val</b> prime = true;
	<b>public</b> <b>val</b> notprime = false;
	<b>var</b> flagvector[maxprimes]: <b>typeof</b> prime;<BR>
	<b>public</b> <b>fun</b> flagset(f: <b>typeof</b> 1, tf: <b>typeof</b> prime) <b>is</b>
		flagvector[f] = tf;
	<b>end</b>;<BR>
	<b>public</b> <b>fun</b> flagget(f: <b>typeof</b> 1, <b>var</b> set: <b>typeof</b> prime) <b>is</b>
		set = flagvector[f];
	<b>end</b>;<BR>
	// Everything begins as prime
	<b>var</b> i = 1;
	<b>repeat</b> <b>while</b> (i <= maxprimes)
		flagvector[i] = prime;
		i += 1;
	<b>end</b>;
<b>end</b>;<BR>
// Main program
<b>var</b> isprime = false;
// Pick out multiples of each prime factor and set these to notprime
<b>var</b> multiple = 2;
<b>var</b> factor = 2;<BR>
<b>repeat</b> <b>while</b> (factor <= maxprimes / 2)
	// Set multiples of factor to notprime
	multiple = factor + factor;
	<b>repeat</b> <b>while</b> multiple <= maxprimes
		flagset(multiple, notprime);
		multiple += factor;
	<b>end</b>;<BR>
	// Set factor = next prime
	<b>repeat</b>
		factor += 1;
		flagget(factor, isprime);
	<b>while</b> (factor <= maxprimes / 2) <b>and</b> <b>not</b> isprime;
<b>end</b>;<BR>
// Now report the results
put("The primes up to ", maxprimes:1, " are:"); putln;
factor = 2;
<b>repeat</b> <b>while</b> (factor <= maxprimes)
	flagget(factor, isprime);
	<b>if</b> isprime <b>then</b>
		put(factor:4);
	<b>end</b>;
	factor += 1;
<b>end</b>;
putln;
</pre>