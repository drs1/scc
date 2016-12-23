D 							[0-9]
O_LITERAL					0+ [D]
L							[a-zA-Z_]
H        					[a-fA-F0-9]
E							[eE][+-]?{D}+
FS							(f|F|l|L)
IS							(u|U|l|L)*

%{
#include <stdio.h>
#include <stdlib.h>

//void count();
%}

%option 					yylineno
%option						noyywrap
%x							INSTRING INCOMMENT

%%
<INITIAL>"/*"				{ printf("begin comment..."); BEGIN(INCOMMENT); }
<INCOMMENT>"*/"				{ printf("...end comment\n"); BEGIN(INITIAL); }
<INCOMMENT>.|\n  			{  ;  }
<INITIAL>\"					{ printf("begin string..."); BEGIN(INSTRING); } /* initial -> string */
<INSTRING>\\\"				{ ; } /* escaped quote in string, do nohting */
<INSTRING>\"				{ printf("...end string\n"); BEGIN(INITIAL) ; } /* string -> initial */
<INSTRING>.|\n 				{ ECHO; } /* match string literal */


<INITIAL>['](\\)?\"['] 		{ ; } /* quote ASCII char */

<INITIAL>"//".|\n 			{ ; } /* do nothing, EOLComment */


<INITIAL>.|\n 				{ ; } /* do nothing with everything else for now */ 
<<EOF>>						{ return 0; }

%%

int main(int argc, char* argv[]){

	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);
	
}