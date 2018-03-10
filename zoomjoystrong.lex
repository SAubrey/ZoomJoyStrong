%{
/*
ZoomJoyStrong
Sean Aubrey
CIS 343
*/
	#include "zoomjoystrong.tab.h"
	#include <stdlib.h>
	
	void yyerror(char*);
	int fileno(FILE *stream);

%}

%option noyywrap

%%

[0-9]+		{ yylval.intVal = atoi(yytext); return INT; }
[0-9]*\.[0-9]+	{ yylval.fVal = atof(yytext); return FLOAT; }
point		{ return POINT; }
line		{ return LINE; }
circle		{ return CIRCLE; }
rectangle	{ return RECTANGLE; }
set_color	{ return SET_COLOR; }
end		{ return END; }
;		{ return END_STATEMENT; }
" "|\t|\n		;
[^\s]		{ yyerror("Command not recognized."); }

%%

// Works in regex simulators to return everything BUT the specified strings, but does not work with FLEX 
// (\b(?!point|line|circle|rectangle|set_color|exit|;|[0-9])\b\S)+

