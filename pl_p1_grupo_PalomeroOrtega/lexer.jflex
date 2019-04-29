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
//Notas
//Usar el infinito de java
//EN EL manual de cup hay prioridades
//minus o algo asi no se usa para nada

Newline    = \r | \n | \r\n
Whitespace = [ \t\f] | {Newline}
//Number     = [0-9]+
/* Numeros */
Number = {Entero} | {Real} | {Real1} | {Real2} | "INF" 
Entero = [0-9]+
Real = {Entero} \. {Entero}
Real1 = {Real}[eE] [\+\-]?{Entero} | {Entero}[eE] [\+\-]?{Entero}
Real2 = {Entero} [oO]
//Funcion para convertir de octales a numeros normales


/* Comments */
Comment = {TraditionalComment} | {EndOfLineComment} 
NewComment = "%" {NewCommentContent} {Newline}
NewCommentContent =  [^\r\n]*
TraditionalComment = "/*" {CommentContent} \*+ "/" | 
EndOfLineComment = "//" [^\r\n]* {Newline} 
CommentContent = ( [^*] | \*+[^*/] )*



ident = ([:jletter:] | "_" ) ([:jletterdigit:] | [:jletter:] | "_" )*


%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%state CODESEG

%%  

<YYINITIAL> {
{TraditionalComment} { } //añadimos que si se encuentra Traditional comment no haga nada
{NewComment} { } //Añadimos para que si se encuentre un New coment no haga nada
  {Whitespace} {                              }
  ";"          { return symbolFactory.newSymbol("SEMI", SEMI); }
  "+"          { return symbolFactory.newSymbol("PLUS", PLUS); }
  "-"          { return symbolFactory.newSymbol("MINUS", MINUS); }
  "*"          { return symbolFactory.newSymbol("TIMES", TIMES); }
  "/"          { return symbolFactory.newSymbol("DIV", DIV); }
  "("          { return symbolFactory.newSymbol("LPAREN", LPAREN); }
  ")"          { return symbolFactory.newSymbol("RPAREN", RPAREN); }
 "sin"      { return symbolFactory.newSymbol("SIN", SIN); }
 "cos"    	{ return symbolFactory.newSymbol("COS", COS); }
 "exp"    	{ return symbolFactory.newSymbol("EXP", EXP); }
 "log"    	{ return symbolFactory.newSymbol("LOG", LOG); }
 "="        {return symbolFactory.newSymbol("IGUAL", IGUAL);}
 "MEM"      {return symbolFactory.newSymbol("MEM", MEM);}
 "INF"		{ return symbolFactory.newSymbol("NUMBER", NUMBER, Double.POSITIVE_INFINITY); }
  {Entero}     {return symbolFactory.newSymbol("NUMBER", NUMBER, Double.parseDouble(yytext())); }
  {Real} {return symbolFactory.newSymbol("NUMBER", NUMBER, Double.parseDouble(yytext())); }
  {Real1} { return symbolFactory.newSymbol("NUMBER", NUMBER, Double.parseDouble(yytext())); }
  {Real2} { return symbolFactory.newSymbol("NUMBER", NUMBER, MetodosAuxiliares.Octalconverter(yytext()));}
  /*{Number} { return symbolFactory.newSymbol("NUMBER", NUMBER, Double.parseDouble(yytext())); }*/
}



// error fallback
.|\n          { emit_warning("Unrecognized character '" +yytext()+"' -- ignored"); }