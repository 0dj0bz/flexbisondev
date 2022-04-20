%{

// bison file: parser.y
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE* yyin;

extern int yylineno;
extern char* yytext;
int yylex();
void yyerror(const char *s);

// gives good debug information
int yydebug=1;

%}

%token LCURLY RCURLY LBRAC RBRAC COMMA COLON
%token VTRUE VFALSE VNULL
%token <string> STRING;
%token <decimal> DECIMAL;

%union {
  char *string;
  double decimal;
}

%start json

%%

json:
    | value
    ;

value: object
     | STRING
     | DECIMAL
     | array
     | VTRUE
     | VFALSE
     | VNULL
     ;

object: LCURLY RCURLY
      | LCURLY members RCURLY
      ;

members: member
       | members COMMA member
       ;

member: STRING COLON value
      ;

array: LBRAC RBRAC
     | LBRAC values RBRAC
     ;

values: value
      | values COMMA value
      ;

%%

int
main(int argc, char *argv[])
{
  // if a file is given read from it
  // otherwise we'll read from STDIN
  if(argc == 2)
  {
    if(!(yyin = fopen(argv[1],"r")))
    {
      perror(argv[1]);
      return EXIT_FAILURE;
    }
  }
  return yyparse();
}

void
yyerror(const char *s)
{
  fprintf(stderr,"error: %s on line %d\n", s, yylineno);
}