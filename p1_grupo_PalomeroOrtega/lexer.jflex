package cup.example;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.Symbol;
import java.lang.*;
import java.io.InputStreamReader;

%%

%class Lexer
%implements sym
%public
%unicode
%line
%column
%cup
%char
%{
	
    public Lexer(ComplexSymbolFactory sf, java.io.InputStream is){
		this(is);
        symbolFactory = sf;
    }
	public Lexer(ComplexSymbolFactory sf, java.io.Reader reader){
		this(reader);
        symbolFactory = sf;
    }
    
    private StringBuffer sb;
    private ComplexSymbolFactory symbolFactory;
    private int csline,cscolumn;

    public Symbol symbol(String name, int code){
		return symbolFactory.newSymbol(name, code,
						new Location(yyline+1,yycolumn+1, yychar), // -yylength()
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength())
				);
    }
    public Symbol symbol(String name, int code, String lexem){
	return symbolFactory.newSymbol(name, code, 
						new Location(yyline+1, yycolumn +1, yychar), 
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength()), lexem);
    }
    
    protected void emit_warning(String message){
    	System.out.println("scanner warning: " + message + " at : 2 "+ 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
    
    protected void emit_error(String message){
    	System.out.println("scanner error: " + message + " at : 2" + 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
%}

Newline    = \r | \n | \r\n
Whitespace = [ \t\f] | {Newline}
/* Numeros */
Number = {Entero} | {Real} | {Real1} | {Real2} | "INF" 
Entero = [0-9]+
Real = {Entero} \. {Entero}
Real1 = {Real}[eE] [\+\-]?{Entero} | {Entero}[eE] [\+\-]?{Entero}
Real2 = {Entero} [oO]

/* Comments */
Comment = {TraditionalComment} | {EndOfLineComment} 
NewComment = "%" {NewCommentContent} {Newline}
NewCommentContent =  [^\r\n]*
TraditionalComment = "/*" {CommentContent} \*+ "/" | 
EndOfLineComment = "//" [^\r\n]* {Newline} 
CommentContent = ( [^*] | \*+[^*/] )*

/* Identificadores*/
ID = [a-zA-Z][a-zA-Z0-9]* 


%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%state CODESEG

%%  

<YYINITIAL> {
{TraditionalComment} { } //a�adimos que si se encuentra Traditional comment no haga nada
{NewComment} { } //A�adimos para que si se encuentre un New coment no haga nada
  {Whitespace} {                              }
  ";"          { return symbolFactory.newSymbol("SEMI", SEMI); }
  "+"          { return symbolFactory.newSymbol("PLUS", PLUS); }
  "-"          { return symbolFactory.newSymbol("MINUS", MINUS); }
  "*"          { return symbolFactory.newSymbol("TIMES", TIMES); }
   "/"          { return symbolFactory.newSymbol("DIV", DIV); }
  "n"          { return symbolFactory.newSymbol("UMINUS", UMINUS); }
  "("          { return symbolFactory.newSymbol("LPAREN", LPAREN); }
  ")"          { return symbolFactory.newSymbol("RPAREN", RPAREN); }
  
  "="        {return symbolFactory.newSymbol("IGUAL", IGUAL);}
 ","          { return symbolFactory.newSymbol("COMA", COMA);}
 //COMPARADORES
 "<="       {return symbolFactory.newSymbol("MENORIGUAL", MENORIGUAL);}
 ">="       {return symbolFactory.newSymbol("MAYORIGUAL", MAYORIGUAL);}
 "=="       {return symbolFactory.newSymbol("IGUALIGUAL", IGUALIGUAL);}
  "<"       {return symbolFactory.newSymbol("MENOR", MENOR);}
  ">"       {return symbolFactory.newSymbol("MAYOR", MAYOR);}
  //BOOLEANOS
  "AND" {return symbolFactory.newSymbol("AND", AND);}
  "OR"    {return symbolFactory.newSymbol("OR", OR);}
  "NOT"   {return symbolFactory.newSymbol("NOT", NOT);}
  //BUCLES Y CONDICIONALES
  "SI"    {return symbolFactory.newSymbol("SI", SI, "L0");}
  "SINO"    {return symbolFactory.newSymbol("SINO", SINO);}
  "ENTONCES"    {return symbolFactory.newSymbol("ENTONCES", ENTONCES);}
  "FINSI"    {return symbolFactory.newSymbol("FINSI", FINSI);}
  "MIENTRAS"    {return symbolFactory.newSymbol("MIENTRAS", MIENTRAS);}
  "FINMIENTRAS"    {return symbolFactory.newSymbol("FINMIENTRAS", FINMIENTRAS);}
  
  //VARIABLES
  
  "BOOLEANO" {return symbolFactory.newSymbol("BOOLEANO", BOOLEANO);}
  "REAL"	{return symbolFactory.newSymbol("REAL", REAL);}
  "True"	{return symbolFactory.newSymbol("TRUE", TRUE);}
  "False"   {return symbolFactory.newSymbol("FALSO", FALSO);}
{ID} {		  return symbolFactory.newSymbol("ID", ID, String.valueOf(yytext()));}
 
 //"MEM"      {return symbolFactory.newSymbol("MEM", MEM);}
 "INF"		{ return symbolFactory.newSymbol("NUMBER", NUMBER, Double.POSITIVE_INFINITY); }
  {Entero}     {return symbolFactory.newSymbol("NUMBER", NUMBER, String.valueOf(Double.parseDouble(yytext()))); }
  {Real} {return symbolFactory.newSymbol("NUMBER", NUMBER, String.valueOf(Double.parseDouble(yytext()))); }
  {Real1} { return symbolFactory.newSymbol("NUMBER", NUMBER, String.valueOf(Double.parseDouble(yytext()))); }
  {Real2} { return symbolFactory.newSymbol("NUMBER", NUMBER, String.valueOf(MetodosAuxiliares.Octalconverter(yytext())));}
}



// error fallback
.|\n          { emit_warning("Unrecognized character '" +yytext()+"' -- ignored"); }
