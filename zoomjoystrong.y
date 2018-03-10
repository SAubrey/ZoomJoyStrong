%{
/*
ZoomJoyStrong
Sean Aubrey
CIS 343
*/
	#include <stdio.h>
	#include "zoomjoystrong.tab.h"
	#include "zoomjoystrong.h"
	void yyerror(const char* msg);
	int yylex();
	int W = 1024;
	int H = 768;
	
%}

%error-verbose
%start statement_list

%union { int intVal; float fVal; }

%token SEPARATOR
%token END
%token END_STATEMENT
%token POINT
%token LINE
%token CIRCLE
%token RECTANGLE
%token SET_COLOR
%token INT
%token FLOAT

%type<intVal> INT
%type <fVal> FLOAT

%%
statement_list:	statement
	|	statement statement_list
;

statement:	draw_point
	|	draw_line
	|	draw_circle
	|	draw_rectangle
	|	set_color
	|	quit
; 

draw_point:	POINT INT INT END_STATEMENT
		{ printf("draw_point: x: %d y: %d\n", $2, $3); 
			if ($2 < 0 || $2 > W)
				yyerror("X coordinate not between 0-1024.");
			if ($3 < 0 || $3 > H)
				yyerror("Y coordinate not between 0-768.");
			else	
				point($2, $3);
		}
;

draw_line:	LINE INT INT INT INT END_STATEMENT
		{ printf("drawline: x: %d y: %d u: %d v: %d\n", $2, $3, $4, $5); 
			if ($2 < 0 || $2 > W)
				yyerror("X coordinate not between 0-1024.");
			if ($3 < 0 || $3 > H)
				yyerror("Y coordinate not between 0-768.");
			if ($4 < 0 || $4 > W)
				yyerror("X2 coordinate not between 0-1024.");
			if ($5 < 0 || $5 > H)
				yyerror("Y2 coordinate not between 0-768.");
			else
				line($2, $3, $4, $5);
		}

;

draw_circle:	CIRCLE INT INT INT END_STATEMENT
		{ printf("draw_circle: x: %d y: %d r: %d\n", $2, $3, $4); 
			if ($2 < 0 || $2 > W)
				yyerror("X coordinate not between 0-1024.");
			if ($3 < 0 || $3 > H)
				yyerror("Y coordinate not between 0-768.");
			if ($4 < 0 || $4 > H)
				yyerror("Radius not between 0-768.");
			else
				circle($2, $3, $4);
		}	
;

draw_rectangle:	RECTANGLE INT INT INT INT END_STATEMENT
		{ printf("draw_rectangle: x: %d y: %d w: %d h: %d\n", $2, $3, $4, $5); 
			if ($2 < 0 || $2 > W)
				yyerror("X coordinate not between 0-1024.");
			if ($3 < 0 || $3 > H)
				yyerror("Y coordinate not between 0-768.");
			if ($4 < 0 || $4 > W)
				yyerror("Width not between 0-1024.");
			if ($5 < 0 || $5 > H)
				yyerror("Height not between 0-768.");
			else
				rectangle($2, $3, $4, $5);
		}

;

set_color: 	SET_COLOR INT INT INT END_STATEMENT
		{ printf("set_color to: r: %d g: %d b: %d\n", $2, $3, $4); 
			if ($2 < 0 || $2 > 255)
				yyerror("Red value not between 0-255.");
			if ($3 < 0 || $3 > 255)
				yyerror("Green value not between 0-255.");
			if ($4 < 0 || $4 > 255)
				yyerror("Blue value not between 0-255.");
			else
				set_color($2, $3, $4);
		}
;

quit:		END END_STATEMENT
		{ printf("Goodbye.\n");
   		 	finish();
			exit(0);
		}
;

%%

int main() {
	setup();
	printf("----Welcome to ZoomJoyStrong, the world's most underrated text-to-graphics solution!----\n");
	printf("-All commands end with ';'. Use 'end;' to quit. \n");
	printf("-Ready for input:\n\n");
	yyparse();
	finish();
}

void yyerror(const char* err) {
	printf("Error: %s\n", err);
	yyparse();
}
