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
STR_CONST	\"([ -[][\]-~](\\[\\\"n]))\"

ID		{LETTER}({LETTER}|{DIGIT})*
HEXA	0[xX][0-9a-fA-F]{1,4}
NUMBER	{DIGIT}{DIGIT}*

NEWLINE		[\n|\r]
SPACE		[ ]
TAB			[\t]

%%
{TAB}		{ column += 4; printf("\t");}
{SPACE}		{ ++column;}
{NEWLINE}	{ column = 1; ++line; printf("\n");}

"/*"	{ column = yyleng; BEGIN(comment);}

<comment>"/*"	{printf("\nCOMMENT_WITHIN_ERROR \nline:%d \n", line);
				yyterminate();}
<comment><<EOF>>	{printf("\n EOFCOMMENT_ERROR \n");
					yyterminate();}
<comment>{NEWLINE}	{ column = 1; ++line;}
<comment>{SPACE}	{ ++column; }

<comment>"*/"	{BEGIN(INITIAL);}
<comment>.		{ ++column; }

if		{ column += 2; printf("IF_TOK "); return(IF_TOK);}
else	{ column += 4; printf("ELSE_TOK "); return(ELSE_TOK);}
while	{ column += 5; printf("WHILE_TOK "); return(WHILE_TOK);}
return	{ column += 6; printf("RETURN_TOK "); return(RETURN_TOK);}
void	{ column += 4; printf("VOID_TOK "); return(VOID_TOK);}
break	{ column += 5; printf("BREAK_TOK "); return(BREAK_TOK);}
puts	{ column += 4; printf("PUTS_TOK "); return(PUTS_TOK);}
int		{ column += 3; printf("INT_TOK "); return(INT_TOK);}
char	{ column += 4; printf("CHAR_TOK "); return(CHAR_TOK);}
main	{ column += 5; printf("MAIN_TOK "); return(MAIN_TOK);}

continue	{ column += 8; printf("CONTINUE_TOK "); return(CONTINUE_TOK);}

writeint	{ column += 8; printf("WRITEINT_TOK "); return(WRITEINT_TOK);}
readint		{ column += 7; printf("READINT_TOK "); return(READINT_TOK);}

{CHAR_CONST}	{ column += yyleng; printf("CHAR_CONST_TOK "); return(CHAR_CONST_TOK);}
{STR_CONST}		{ column += yyleng; printf("STR_CONST_TOK "); return(STR_CONST_TOK);}
{NUMBER}		{ 
				intval = atoi(yytext);
				if (intval > 65536){
					printf("\nNUMLEN_ERROR \nline:%d col:%d \n", line, column);
					yyterminate();
				}
				else {
					column += yyleng; 
                    printf("NUMBER_TOK "); 
					return(NUMBER_TOK);}
				}

{ID}			{
				if (yyleng > 12){
					printf("\nIDLEN_ERROR \nline:%d col:%d \n", line, column);
					yyterminate();
				}
				else {
				 	column += yyleng; 
                    printf("ID_TOK "); 
					return(ID_TOK);}
				}
{NUMBER}{ID}	{
				printf("\nERR_LEXICAL \nline:%d col:%d \n", line, column);
				yyterminate();
				}

"=="	{ column += 2; printf("SAME "); return(SAME);}
"!="	{ column += 2; printf("DIFFERENT "); return(DIFFERENT);}

"&&"	{ column += 2; printf("AND "); return(AND);}
"||"	{ column += 2; printf("OR "); return(OR);}

"("		{ ++column; printf("( "); return(yytext[0]);}
")"		{ ++column; printf(") "); return(yytext[0]);}
","		{ ++column; printf(", "); return(yytext[0]);}
"{"		{ ++column; printf("{ "); return(yytext[0]);}
"}"		{ ++column; printf("} "); return(yytext[0]);}
"["		{ ++column; printf("[ "); return(yytext[0]);}
"]"		{ ++column; printf("] "); return(yytext[0]);}
";"		{ ++column; printf("; "); return(yytext[0]);}

"="		{ ++column; printf("= "); return(ASIGN);}
"%"		{ ++column; printf("MODULO "); return(MODULO);}
"+"		{ ++column; printf("+ "); return(PLUS);}
"-"		{ ++column; printf("- "); return(MINUS);}
"*"		{ ++column; printf("* "); return(STAR);}
"/"		{ ++column; printf("/ "); return(DIVIDE);}
"!"		{ ++column; printf("! "); return(NOT);}

"<"			{ ++column; printf("< "); return(LESS_THAN);}
"<="		{ column += 2; printf("<= ");  return(LESS_THAN_EQUAL);}
">="		{ column += 2; printf(">= "); return(GREATER_THAN_EQUAL);}
">"			{ ++column; printf("> "); return(GREATER_THAN);}	

<<EOF>>		{ printf("\n"); yyterminate();}

.			{
			  printf("\n ERR_LEXICAL(%s) \nline:%d col:%d \n",yytext, line, column);
			  yyterminate();
			}

%%

int yywrap(void){
		return 1;
}