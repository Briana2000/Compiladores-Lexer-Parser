package ParserLexer;
import java_cup.runtime.*;

%%
// esto hace referencia a una sección 

// Características de Jflex para que funcione correctamente

// define como pública la clase lexer
%public 
%class Lexer 
%unicode
// conteo de líneas con yyline
%line
// conteo de caracteres con yychar  
%char
// conteo de columnas con yycolumn 
%column 
// habilita la compatibilidad con cup 
%cup 
// Estado para manejar los strings

%{
   //Código de usuario
    StringBuffer string = new StringBuffer(); // para manejar los strings
    private SymbolTable symbolTable = new SymbolTable(null); // Tabla de símbolos

    private Symbol symbol(int type) {
        return new Symbol(type, yyline+1, yycolumn+1);
    }

    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline+1, yycolumn+1, value);
    }

    public SymbolTable getSymbolTable(){
        return this.symbolTable;
    }
%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]


EspacioBlanco = {LineTerminator} | [ \t\f]

Comentario = {ComentarioSimple} | {ComentarioEOF} | {ComentarioDocumentacion}

ComentarioSimple            = "@" {InputCharacter}* {LineTerminator}
ComentarioEOF          = "@" {InputCharacter}* {LineTerminator}? 
ComentarioDocumentacion     = "/_" ((\.|\n)*?) "_/"


////// Reg Exp ///////

Letra               = [a-zA-Z]
Id                  = [a-zA-Z_] [a-zA-Z0-9_]*
NumEntero           = [+-] [1-9] [0-9]* | [1-9][0-9]* | 0
NumEnteroPositivo   = [1-9][0-9]*
NumDecimal          = [0-9]+\.[0-9]+

%state CADENA 

%%

////// Palabras reservadas ///////

// YYINITIAL hace referencia a un estado de Jflex, en este caso un estado inicial.
// return new Symbol lo que hace es retornarnos un token o simbolo cuando ecuentra el 
// lexema "int"
// sym.INT es el nombre del token o símbolo. 
// yyline es propio de Jflex y lo que hace es que guarda como un entero el número de línea en 
// la cual se reconoció el lexema. Lo mismo con yycolumn guarda el número de columna.
// yytext() lo que hace es que me devuelve el valor del lexema, en este caso el valor 
// de "int" es el mismo: "int", por lo cual yytext() se usa para accesar al valor del lexema.  

////// Palabras reservadas ///////
// tipos de datos
<YYINITIAL> "int"     {return symbol(sym.INT);}
<YYINITIAL> "float"   {return symbol(sym.FLOAT);}
<YYINITIAL> "char"    {return symbol(sym.CHAR);}
<YYINITIAL> "string"  {return symbol(sym.STRING);}
<YYINITIAL> "boolean" {return symbol(sym.BOOLEAN);}

// operadores lógicos
<YYINITIAL> "true"    {return symbol(sym.TRUE);}
<YYINITIAL> "false"   {return symbol(sym.FALSE);}

// funciones
<YYINITIAL> "return"  {return symbol(sym.RETURN);}
<YYINITIAL> "main"    {return symbol(sym.MAIN);}

// estructuras de control
<YYINITIAL> "if"      {return symbol(sym.IF);}
<YYINITIAL> "elif"    {return symbol(sym.ELIF);}
<YYINITIAL> "else"    {return symbol(sym.ELSE);}
<YYINITIAL> "do"      {return symbol(sym.DO);}
<YYINITIAL> "while"   {return symbol(sym.WHILE);}
<YYINITIAL> "for"     {return symbol(sym.FOR);}
<YYINITIAL> "break"   {return symbol(sym.BREAK);}

// I/O
<YYINITIAL> "readInt"     {return symbol(sym.READ_INT);}
<YYINITIAL> "readFloat"   {return symbol(sym.READ_FLOAT);}
<YYINITIAL> "printInt"    {return symbol(sym.PRINT_INT);}
<YYINITIAL> "printFloat"  {return symbol(sym.PRINT_FLOAT);}
<YYINITIAL> "printString" {return symbol(sym.PRINT_STRING);}

// Operador
<YYINITIAL> "not" {return symbol(sym.NOT);}


<YYINITIAL> {

    ////// Literales ///////
    {NumEntero}  {return symbol(sym.ENTERO, Integer.parseInt(yytext()));}
    {NumDecimal} {return symbol(sym.DECIMAL, new Float(yytext().substring(0,yylength()-1)));}
    {NumEnteroPositivo}  {return symbol(sym.ENTERO_POSITIVO, Integer.parseInt(yytext()));}
    \" {string.setLength(0); yybegin(CADENA);}

    ////// Operadores ///////


    "!"   {return symbol(sym.EXCLAMACION);}
    "="   {return symbol(sym.EQUIV);}
    "=="  {return symbol(sym.DEQUIV);} // DEQUIV  de doble equiv
    "+"   {return symbol(sym.PLUS);}
    "-"   {return symbol(sym.MINUS);}
    "*"   {return symbol(sym.TIMES);}
    "/"   {return symbol(sym.DIV);}
    "**"  {return symbol(sym.POWER);}
    "~"   {return symbol(sym.MODULE);}
    "--"  {return symbol(sym.MINUS_UN);} // UN de unario
    "++"  {return symbol(sym.PLUS_UN);}  // UN de unario
    ">"   {return symbol(sym.MAYOR_QUE);}
    ">="  {return symbol(sym.MAYOR_IGUAL);}
    "<"   {return symbol(sym.MENOR_QUE);}
    "<="  {return symbol(sym.MENOR_IGUAL);}
    "!="  {return symbol(sym.DIF);}
    "#"   {return symbol(sym.OR);}
    "^"   {return symbol(sym.AND);}
    "("   {return symbol(sym.LPARENT);}
    ")"   {return symbol(sym.RPARENT);}
    "["   {return symbol(sym.LPARENT_CUAD);} // CUAD de cuadrados
    "]"   {return symbol(sym.RPARENT_CUAD);}
    "{"   {return symbol(sym.INIBLOQUE);}
    "}"   {return symbol(sym.FINBLOQUE);}

    ////// Extras ///////

    "$"     {return symbol(sym.FINEXP);}
    ","     {return symbol(sym.COMA);}
    <<EOF>> { return symbol(sym.EOF);}

    //{Letra} {return symbol(sym.CARACTER, yytext());}
    ////// Identificador ///////
    {Id} {return symbol(sym.ID, yytext());}
    ////// Ignorar ///////

    {EspacioBlanco}  { /* Ignorar */ }
    {Comentario}     { /* Ignorar */ }

    ////// Identificador ///////
    {Id} /*{
        Object value = symbolTable.get(yytext());
        if (value == null) {
            //El símbolo no está en la tabla actual
            value = "undefined";
        }
        // Retorne un nuevo símbolo
        return new Symbol(sym.ID, value);
    }*/
    {return symbol(sym.ID, yytext());}
}

/*Esto es para el manejo de errores.
  En este caso si el Jflex no encuentra ninguna producción con la que coincida el caracter 
  entonces lo considera como error y lo imprime, por eso este YYINITIAL va de último */

/*
<YYINITIAL> . {
    String errLex = "Error léxico : "yytext()+" en la línea: "+(yyline+1)+" y columna: "+(yycolumn+1);
    System.out.println(errLex);
}*/

<CADENA> {
    /* Si encuentra un fin de cadena entonces concatenamos la comilla doble, vaciamos la variable global 
    y que regrese al estado inicial para que siga reconociendo lexemas y que nos retorne la cadena */
    \"              { yybegin(YYINITIAL); return symbol(sym.CADENA, string.toString());}
    // si reconoce un enter significa que no tiene cierre de cadena entonces es un error
    [^\n\r\"\\]+    {string.append(yytext());} // Si no es un caracter especial entonces lo agrega a la variable global
    \\t             {string.append("\t");}
    \\n             {string.append("\n");}
    \\r             {string.append("\r");}
    \\\"            {string.append("\"");}
    \\              {string.append("\\");}
}

///// Manejo de errores

[^]     {System.out.println("Error léxico: "+yytext()+" en la línea: "+(yyline+1)+" y columna: "+(yycolumn+1));}
