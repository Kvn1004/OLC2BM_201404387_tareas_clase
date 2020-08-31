%lex

%options case-insensitive

%%

"+"                 return 'MAS';
"-"                 return 'MENOS';
"*"                 return 'MUL';
"/"                 return 'DIV';
"("                 return 'LPAR';
")"                 return 'RPAR';

[ \r\t]+            {}
\n                  {}

[0-9]+\b                return 'ENTERO';

<<EOF>>                 return 'EOF';

.                       { console.error('Error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }

/lex


%left 'MAS' 'MENOS'
%left 'MUL' 'DIV'
%left UMENOS

%start ini

%%

ini : 
      exp EOF { console.log($1); }
    ;

exp :
      exp MAS exp       { $$ = new_nodo(new_temp(), $1.C3D + $3.C3D + $$.tmp + " = " + $1.tmp + " + " + $3.tmp); }
    | exp MENOS exp     { $$ = new_nodo(new_temp(), $1.C3D + $3.C3D + $$.tmp + " = " + $1.tmp + " - " + $3.tmp); }
    | exp DIV exp       { $$ = new_nodo(new_temp(), $1.C3D + $3.C3D + $$.tmp + " = " + $1.tmp + " / " + $3.tmp); }
    | exp MUL exp       { $$ = new_nodo(new_temp(), $1.C3D + $3.C3D + $$.tmp + " = " + $1.tmp + " * " + $3.tmp); }
    | LPAR exp RPAR     { $$ = new_nodo($2.tmp, $2.C3D); }
    | ENTERO            { $$ = new_nodo(Number($1), " "); }
    ;

%%

const NODO = {
    tmp:    'val_tmp',
    C3D:    'val_C3D',
}

var temp = 0;

function new_nodo(tmp, C3D){
    return {
        tmp: tmp,
        C3D: C3D,
    }
}

function new_temp(){
    temp = temp + 1; 
    return temp;
}
