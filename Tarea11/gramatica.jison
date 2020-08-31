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
      exp EOF { console.log($1.C3D); }
    ;

exp :
      exp MAS exp       { var tp = new_temp(); $$ = new_nodo(tp, $1.C3D + $3.C3D + tp + " = " + $1.tmp + " + " + $3.tmp + "\r\n"); }
    | exp MENOS exp     { var tp = new_temp(); $$ = new_nodo(tp, $1.C3D + $3.C3D + tp + " = " + $1.tmp + " - " + $3.tmp + "\r\n"); }
    | exp DIV exp       { var tp = new_temp(); $$ = new_nodo(tp, $1.C3D + $3.C3D + tp + " = " + $1.tmp + " / " + $3.tmp + "\r\n"); }
    | exp MUL exp       { var tp = new_temp(); $$ = new_nodo(tp, $1.C3D + $3.C3D + tp + " = " + $1.tmp + " * " + $3.tmp + "\r\n"); }
    | LPAR exp RPAR     { $$ = new_nodo($2.tmp, $2.C3D); }
    | ENTERO            { $$ = new_nodo(Number($1), ""); }
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
    return "t" + temp;
}
