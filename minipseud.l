%option noyywrap
%{

#include "minipseud.h"
#include <stdlib.h>
#include "minipseudtree.h"

%}

empty    [ \t]+

num  		[0-9]
int   		{num}+
exp  		[eE][+-]?{int}
va       	[a-zA-Z]
variable    {va}+
real     	{int}("."{int})?{exp}?



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
"="   {/* yylval.node = createNode(NTEGAL);*/return(EGAL);}


"AFFICHER" {return(AFF);}
"SI"	   {return(SI);}
"ALORS"	   {return(ALORS);}
"SINON"    {return(SINON);}
"FIN"      {return(FIN);}
"TANTQUE"  {return(TANTQUE);}
"FAIRE"    {return(FAIRE);}


"=="       {return(EQ);}
"!="       {return(NEQ);}
"<"        {return(LT);}
">"        {return(GT);}
"<="       {return(LET);}
">="       {return(GET);}
"||"       {return(OR);}
"&&"       {return(AND);}
"!"		   {return(NOT);} 

";"    { return(COLON); }
{variable} {return(VARIABLE);}
"\n"   { return(EOL); }
