%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "minipseudtree.h"
#include "minipseudeval.h"

extern int  yyparse();
extern FILE *yyin;

 double tabval[26] ;
 

%}

%union {
	struct Node *node;
}


%token   <node> NUM 
%token   <node> PLUS MIN MULT DIV POW 
%token   <char> VARIABLE
%token   AFF 
%token   SI ALORS SINON FIN TANTQUE FAIRE
%token   EGAL
%token   OP_PAR CL_PAR COLON
%token   EOL


%type   <node> Instlist
%type   <node> Inst
%type   <node> Expr


%left OR
%left AND
%left EQ NEQ
%left GT LT GET LET
%left PLUS  MIN
%left MULT  DIV
%left NEG NOT
%right  POW

%start Input
%%

Input:
      {/* Nothing ... */ }
  | Line Input { /* Nothing ... */ }


Line:
    EOL {  }
  | Instlist EOL { exec($1); /*printf("exec");*/  }
  ; 

Instlist:
    Inst { $$ = nodeChildren(createNode(NTINSTLIST),$1,createNode(NTEMPTY)); } 
  | Instlist Inst { $$ = nodeChildren(createNode(NTINSTLIST),$1,$2) ; }
  ;

Inst:
    Expr COLON {  ; } 
  ;


Expr:
  NUM			{ $$=nodeChildren($1,NULL,NULL); }
  | Expr PLUS Expr     {  $$=nodeChildren($2,$1,$3); }
  | Expr MIN Expr      {  $$=nodeChildren($2,$1,$3); }
  | Expr MULT Expr     {  $$=nodeChildren($2,$1,$3); }
  | Expr DIV Expr      {  $$=nodeChildren($2,$1,$3); }
  | MIN Expr %prec NEG {  $2->val=-($2->val);$$=nodeChildren($2,NULL,NULL) ; }
  | Expr POW Expr      {  $$=nodeChildren($2,$1,$3); }
  | OP_PAR Expr CL_PAR {  $$=$2; }
  | AFF Expr           {  $$=$2; }
  | VARIABLE EGAL Expr     { tabval[(int)($1[0] - 'a')]=$3->val; $$=nodeChildren($2,$1,$3);}
  | SI EB ALORS Instlist SINON Instlist FIN {;}
  | TANTQUE EB FAIRE Instlist FIN {;}
  ;

TERM:
  VARIABLE {;}
  | NUM    {;}
  ;

EB:
  TERM OPB TERM {;}
  | NOT TERM {;}
  | EB OPB EB {;}
  ;

OPB:
  EQ {;}
  | NEQ {;}
  | GET {;}
  | LET {;}
  | GT {;}
  | LT {;}
  | AND {;}
  | OR {;}
  ;



%%

 
 

int exec(Node *node) {
   printGraph(node);
  eval(node);
}

 

int yyerror(char *s) {
  printf("%s\n", s);
}

 

int main(int arc, char **argv) {
   if ((arc == 3) && (strcmp(argv[1], "-f") == 0)) {
    
    FILE *fp=fopen(argv[2],"r");
    if(!fp) {
      printf("Impossible d'ouvrir le fichier à executer.\n");
      exit(0);
    }      
    yyin=fp;
    yyparse();
		  
    fclose(fp);
  }  
  exit(0);
}
