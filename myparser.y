%{
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>

union YYSTYPE;
int yylex();
void yyerror(const char *);

%}

%token MAIN_TOK

%token IF_TOK 
%token ELSE_TOK 
%token WHILE_TOK 
%token RETURN_TOK 
%token VOID_TOK 
%token BREAK_TOK 
%token PUTS_TOK 

%token INT_TOK 
%token CHAR_TOK 


%token CONTINUE_TOK 
%token WRITEINT_TOK 
%token READINT_TOK 
%token CHAR_CONST_TOK 
%token STR_CONST_TOK 
%token NUMBER_TOK
%token ID_TOK 

%token SAME
%token DIFFERENT

%token AND
%token OR

%token ASIGN
%token MODULO
%token PLUS
%token MINUS
%token STAR
%token DIVIDE
%token NOT
%token UNARY_MINUS_TOK

%token LESS_THAN
%token LESS_THAN_EQUAL
%token GREATER_THAN_EQUAL
%token GREATER_THAN


%nonassoc NOT LESS_THAN LESS_THAN_EQUAL GREATER_THAN GREATER_THAN_EQUAL  

%left ASIGN
%left STAR DIVIDE	OR
%left PLUS MINUS 	AND
%left UNARY_MINUS_TOK 


%expect 1

%start main_prog	

%%

main_prog	:
					type_specifier
					MAIN_TOK
					'('
					param_decl_list
					')'
					compound_stmt
					elements_rep
					;


micro_c_program	:
					type_specifier
					ID_TOK 
					'('
					param_decl_list
					')'
					compound_stmt
					
					;
					
program_call :
					type_specifier
					ID_TOK 
					'('
					param_decl_list
					')'
					';'
					
					;
		



elements_rep :
				elements_rep
				elements
				|
				
elements	: 
				micro_c_program |
				program_call 
				;
							

type_specifier :
					INT_TOK 
					|CHAR_TOK
					;

param_decl_list : 
			parameter_decl 
			parameter_decl_rep 
			|
		;

parameter_decl_rep :
			parameter_decl_rep
			','
			parameter_decl
			| 
		;

parameter_decl :
			type_specifier 
			ID_TOK
		;

compound_stmt : 
			'{' 
			compound_stmt_opt 
			'}'
		;

compound_stmt_opt : 
			 stmt_rep
			;	
			
stmt_rep: 
			stmt_rep
			stmt
			|
			;
			
var_decl :
			type_specifier 	
			var_decl_list
			';'
			|type_specifier
			var_decl_array
			';'
		;

var_decl_list : 
			variable_id 
			variable_id_rep 
		;

variable_id_rep : 
			variable_id_rep
			','
			 variable_id 
			| 
		;

variable_id : 
			ID_TOK
			opt_expr
		;

opt_expr : 
			ASIGN
			expr 
			|
		;


stmt : 
	var_decl |
	compound_stmt |
	cond_stmt |
	while_stmt |
	BREAK_TOK ';' |
	CONTINUE_TOK ';'|
	RETURN_TOK expr ';' |
	READINT_TOK '(' ID_TOK ')' ';' |
	WRITEINT_TOK '(' expr ')' ';' |
	PUTS_TOK '(' expr ')' ';'
	;	

while_stmt:
		WHILE_TOK
		'('
		expr
		')'
		stmt
		;

cond_stmt:

		IF_TOK '(' expr ')' stmt opt_else
	  	   ;	


opt_else:

		ELSE_TOK
		stmt
		|
		;	

expr : 
	ID_TOK ASIGN expr 
	| condition
	; 

condition: 

	disjunction
	| disjunction '?' expr ':' condition

; 

disjunction: 

	conjunction
	| disjunction OR conjunction

;


conjunction: 

	comparison
	|conjunction AND comparison
	
;

comparison:

	relation
	| relation SAME relation
	| relation DIFFERENT relation

;

relation : 

	sum 
	| sum op_list sum

;

op_list: 

	LESS_THAN
	| GREATER_THAN
	| LESS_THAN_EQUAL
	| GREATER_THAN_EQUAL

;

sum:
	sum PLUS term
	| sum MINUS term
	| term
;

term: 

	term STAR factor
	| term DIVIDE factor
	| term MODULO factor
	| factor

;

factor: 
	NOT factor
	| UNARY_MINUS_TOK factor 
	| primary

;

primary: 

	NUMBER_TOK 
	| CHAR_CONST_TOK
	| STR_CONST_TOK
	| ID_TOK
	| READINT_TOK '(' ')' ';'
	| '(' expr ')'	

;



var_decl_array: 
 
	ID_TOK 
	'[' NUMBER_TOK ']' 
	dimension_rep
	';'
	| ID_TOK
	'[' NUMBER_TOK ']' 
	dimension_rep
	ASIGN
	'{' NUMBER_TOK  num_rep '}'
	keys_rep
	';'
;


dimension_rep :
	
	num_rep
	'[' NUMBER_TOK ']' 
	|
;

keys_rep : keys_rep ',' '{' NUMBER_TOK  num_rep '}' | ;

num_rep: num_rep ',' NUMBER_TOK | ;

%% 

extern int line,column;

int main(int argc, char **argv)
{
	yyparse();
}

void yyerror(char const *s)
{
	fprintf(stderr, "Error: %s in line %d, column %d\n", s, line,column);
	exit(1);
}

