%option yylineno  

%{
    #include "parser.tab.h"
    #include <string.h>
    #include "def.h"
    int yycolumn = 1;
    #define YY_USER_ACTION yylloc.first_line=yylloc.last_line=yylineno; yylloc.first_column=yycolumn; yylloc.last_column=yycolumn+yyleng-1; yycolumn+=yyleng;
    typedef union{
        int type_int;
        float type_float;
        char type_string[32];
        char type_id[32];
        struct node *ptr;
    }YYLVAL;
    #define YYSTYPE YYLVAL
%}

id [A-Za-z][A-Za-z0-9]*
int [0-9]+
float ([0-9]*\.[0-9]+)|([0-9]+\.)
string (\")[a-zA-Z0-9]*(\")
white [ \n\t]+

%%
 /*注释处理 单行+多行*/
\/\/[^\n]*  {;}//匹配注释的正则表达式
\/\*(\s|.)*?\*\/ {;}//匹配注释的正则表达式
{int} {yylval.type_int=atoi(yytext);return INT;}
{float} {yylval.type_float=atof(yytext); return FLOAT;}
{string} {strcpy(yylval.type_string,yytext); return STRING;}
"int" {strcpy(yylval.type_id,yytext); return TYPE;}
"float" {strcpy(yylval.type_id,yytext); return TYPE;}
"String" {strcpy(yylval.type_id,yytext); return TYPE;}
"return" {return RETURN;}
"if" {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
"for" {return FOR;}
"Struct" {return STRUCT;}
{id} {strcpy(yylval.type_id,yytext); return ID;}

";" {return SEMI;}
"," {return COMMA;}
">"|"<"|">="|"<="|"=="|"!=" {strcpy(yylval.type_id,yytext); return RELOP;}
"=" {return ASSIGNOP;}
"+" {return PLUS;}
"-" {return MINUS;}
"+=" {return COMADD;}
"-=" {return COMSUB;}
"++" {return AUTOADD;}
"--" {return AUTOSUB;}
"*" {return STAR;}
"/" {return DIV;}
"&&" {return AND;}
"||" {return OR;}
"!" {return NOT;}
"(" {return LP;}
")" {return RP;}
"[" {return LB;}
"]" {return RB;}
"{" {return LC;}
"}" {return RC;}
[\n] {yycolumn=1;}
[ \r\t] {;}
.   {printf("Error type A: Mysterious character\"%s\" at line %d,column %d\n",yytext,yylineno,yycolumn);}


%%

int yywrap(){
    return 1;
}