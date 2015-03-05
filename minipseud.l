%option noyywrap
%{

#include "minipseud.h"
#include <stdlib.h>
#include "minipseudtree.h"

%}

empty    [ \t]+

num   [0-9]
int    {num}+
exp  [eE][+-]?{int}

real      {int}("."{int})?{exp}?



%%

{empty}  { /* Nothing */ }

 

"("   return(OP_PAR);
")"   return(CL_PAR);


{real}    {
    yylval.node = createNode(NTNUM);
    yylval.node->val = atof(yytext);
    return(NUM);
    }

"+"   { yylval.node = createNode(NTPLUS); return(PLUS); }
"-"   { yylval.node = createNode(NTMIN); return(MIN); }
"*"   { yylval.node = createNode(NTMULT); return(MULT); }
"/"   { yylval.node = createNode(NTDIV); return(DIV); }
"^"   { yylval.node = createNode(NTPOW); return(POW); }




 
 

";"    { return(COLON); }

"\n"   { return(EOL); }
