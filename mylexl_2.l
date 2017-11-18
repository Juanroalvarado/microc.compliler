%{
#include <stdio.h>
#include "myparser.tab.h"

int column, line = 1;
int intval;
%}

%x comment

LETTER 	[a-zA-Z_]
DIGIT	[0-9]
CHAR_CONST	'[\x20-\xFF]'
STR_CONST	\"([ -[]*[\]-~]*(\\[\\\"n])*)*\"

ID		{LETTER}({LETTER}|{DIGIT})*
HEXA	0[xX][0-9a-fA-F]{1,4}
NUMBER	{DIGIT}{DIGIT}*

NEWLINE		[\n]
SPACE		[ ]
TAB			[\t]
CR			[\r]

%%
{TAB}		{ column += 4; printf("\t");}
{SPACE}		{ ++column; printf(" ");}
{NEWLINE}	|
{CR}		{ column = 1; ++line; printf("\n");}

"/*"	{ column = yyleng; BEGIN(comment);}

<comment>"/*"	{printf("\nCOMMENT_WITHIN_ERROR \nline:%d \n", line);
				yyterminate();}
<comment><<EOF>>	{printf("\n EOFCOMMENT_ERROR \n");
					yyterminate();}
<comment>{NEWLINE}	{ column = 1; ++line;}
<comment>{SPACE}	{ ++column; }

<comment>"*/"	{BEGIN(INITIAL);}
<comment>.		{ ++column; }

if		{ column += 2; return(IF_TOK);}
else	{ column += 4; return(ELSE_TOK);}
while	{ column += 5; return(WHILE_TOK);}
return	{ column += 6; return(RETURN_TOK);}
void	{ column += 4; return(VOID_TOK);}
break	{ column += 5; return(BREAK_TOK);}
puts	{ column += 4; return(PUTS_TOK);}
int		{ column += 3; return(INT_TOK);}
char	{ column += 4; return(CHAR_TOK);}

continue	{ column += 8; return(CONTINUE_TOK);}

writeint	{ column += 8; return(WRITEINT_TOK);}
readint		{ column += 7; return(READINT_TOK);}

{CHAR_CONST}	{ column += yyleng; return(CHAR_CONST_TOK);}
{STR_CONST}		{ column += yyleng; return(STR_CONST_TOK);}
{NUMBER}		{ 
				intval = atoi(yytext);
				if (intval > 65536){
					printf("\nNUMLEN_ERROR \nline:%d col:%d \n", line, column);
					yyterminate();
				}
				else {
					column += yyleng; 
					return(NUMBER_TOK);}
				}

{ID}			{
				if (yyleng > 12){
					printf("\nIDLEN_ERROR \nline:%d col:%d \n", line, column);
					yyterminate();
				}
				else {
				 	column += yyleng; 
					return(ID_TOK);}
				}
{NUMBER}{ID}	{
				printf("\nERR_LEXICAL \nline:%d col:%d \n", line, column);
				yyterminate();
				}

"=="	{ column += 2; return(SAME);}
"!="	{ column += 2; return(DIFFERENT);}

"&&"	{ column += 2; return(AND);}
"||"	{ column += 2; return(OR);}

"("		{ ++column; return(yytext[0]);}
")"		{ ++column; return(yytext[0]);}
","		{ ++column; return(yytext[0]);}
"{"		{ ++column; return(yytext[0]);}
"}"		{ ++column; return(yytext[0]);}
"["		{ ++column; return(yytext[0]);}
"]"		{ ++column; return(yytext[0]);}
";"		{ ++column; return(yytext[0]);}

"="		{ ++column; return(ASIGN);}
"%"		{ ++column; return(MODULO);}
"+"		{ ++column; return(SUM);}
"-"		{ ++column; return(MINUS);}
"*"		{ ++column; return(STAR);}
"/"		{ ++column; return(DIVIDE);}
"!"		{ ++column; return(NOT);}

"<"			{ ++column; return(LESS_THAN);}
"<="		{ column += 2; return(LESS_THAN_EQUAL);}
">="		{ column += 2; return(GREATER_THAN_EQUAL);}
">"			{ ++column; return(GREATER_THAN);}	

.			{
			  printf("\n ERR_LEXICAL(%s) \nline:%d col:%d \n",yytext, line, column);
			  yyterminate();
			}

%%