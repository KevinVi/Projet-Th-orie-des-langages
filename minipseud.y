%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "minipseudtree.h"
#include "minipseudeval.h"

extern int  yyparse();
extern FILE *yyin;

 
 

%}

%union {
	struct Node *node;
}


%token   <node> NUM 
%token   <node> PLUS MIN MULT DIV POW
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
    Inst { $$ = nodeChildren(createNode(NTinstList),$1,createNode(NTempty)); } 
  | Instlist Inst { $$ = nodeChildren(createNode(NTinstList),$1,$2) ; }
  ;

Inst:
    Expr COLON {  ; } 
  ;


Expr:
  NUM			{ $$=nodeChildren($1,NULL,NULL) ; }
  | Expr PLUS Expr     {  $$=nodeChildren($2,$1,$3); }
  | Expr MIN Expr      {  $$=nodeChildren($2,$1,$3); }
  | Expr MULT Expr     {  $$=nodeChildren($2,$1,$3); }
  | Expr DIV Expr      {  $$=nodeChildren($2,$1,$3); }
  | MIN Expr %prec NEG {  ; }
  | Expr POW Expr      {  $$=nodeChildren($2,$1,$3); }
  | OP_PAR Expr CL_PAR {  $$=nodeChildren($2,$1,$3); }
  ;


%%

 
 

int exec(Node *node) {
   /*printGraph(node);*/
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
