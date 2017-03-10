import java_cup.runtime.*;

%%

%class Lexer
%unicode
%cup
%line
%column


%{
	StringBuilder string = new StringBuilder();

	private boolean debug_mode;
      public  boolean debug()            { return debug_mode; }
      public  void    debug(boolean mode){ debug_mode = mode; }


    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }

%}

LineTerminator = \r|\n|\r\n
WhiteSpace = {LineTerminator} | [ \t\f] | " "
InputCharacter = [^LineTerminator]


/* Comments */
EndOfLineComment = #.*{LineTerminator}
HashComment = \/#[^#]*#+([^#/][^#]*#+)*\/
Comment = {EndOfLineComment} | {HashComment}

/* types */
identifier = [A-Za-z][A-Za-z_0-9]*
character = '[A-Za-z0-9!\"#$%&\'()*+,\-./:;<=>?@\[\\\]\^_`{|}~]'
string = \"[^\r\n\"\\]*\"
boolean = T | F
integer = 0 | [1-9][0-9]*
rational = ({integer}_)?{integer}\/{integer}
float = {integer}\.{integer}

%%

<YYINITIAL> {

//--------- FUNDAMENTALS ---------------------------------------------------------------

"main"				{return symbol(sym.MAIN);        }
"return"            {return symbol(sym.RETURN);      }
"fdef"              {return symbol(sym.DEFINE_F);    }
"tdef"              {return symbol(sym.DEFINE_TYPE); }

//--------- OTHER FEATURES ---------------------------------------------------------------

"alias"             {return symbol(sym.ALIAS);       }
"if"                {return symbol(sym.IF);          }
"then"              {return symbol(sym.THEN);        }
"else"              {return symbol(sym.ELSE);        }
"fi"                {return symbol(sym.FI);          }
"top"               {return symbol(sym.TOP);         }
"read"              {return symbol(sym.READ_INPUT);  }
"print"             {return symbol(sym.PRINT);       }
"in"                {return symbol(sym.IN);          }
"len"               {return symbol(sym.LEN);         }
"loop"              {return symbol(sym.LOOP);        }
"pool"              {return symbol(sym.POOL);        }
"break"             {return symbol(sym.BREAK);       }

//--------- TYPES----------------------------------------------------------------------

"bool"              {return symbol(sym.BOOL);            }
"int"               {return symbol(sym.INTEGER);         }
"float"             {return symbol(sym.FLOAT);           }
"rat"               {return symbol(sym.RAT);             }
"char"              {return symbol(sym.CHARACTER);       }
"dict"              {return symbol(sym.DICTIONARY_LIST); }
"seq"               {return symbol(sym.SEQUENCE_LIST);   }

//--------- TYPE VALUES ---------------------------------------------------------------------

"T"                 { return symbol(sym.TRUE);               }
"F"                 { return symbol(sym.FALSE);              }
{identifier}        {return symbol(sym.IDENTIFIER);          }
{float}             {return symbol(sym.VALUES_OF_FLOAT);     }
{integer}           {return symbol(sym.VALUES_OF_INTEGER);   }
{string}		    {return symbol(sym.VALUES_OF_STRING);    }
{character}         {return symbol(sym.VALUES_OF_CHARACTER); }
{rational}          {return symbol(sym.VALUES_OF_RAT);       }



//--------- SYMBOLS -----------------------------------------------------------------------

"("                 {return symbol(sym.L_BRACKET);        }
")"                 {return symbol(sym.R_BRACKET);        }
"{"                 {return symbol(sym.LC_BRACKET);       }
"}"                 {return symbol(sym.RC_BRACKET);       }
"["                 {return symbol(sym.LSQ_BRACKET);      }
"]"                 {return symbol(sym.RSQ_BRACKET);      }
"<"                 {return symbol(sym.INFERIOR);         }
">"                 {return symbol(sym.SUPERIOR);         }
":"                 {return symbol(sym.COLON);            }
";"                 {return symbol(sym.SEMICOLON);        }
","                 {return symbol(sym.COMMA);            }
"."                 {return symbol(sym.DOT);              }
"_"                 {return symbol(sym.UNDERSCORE);       }


//--------- OPERATORS ---------------------------------------------------------------------

"?"                 {return symbol(sym.INTERROGATION);       }
"!"                 {return symbol(sym.NEGATION);            }
"&&"                {return symbol(sym.AND);                 }
"||"                {return symbol(sym.OR);                  }
"+"                 {return symbol(sym.ADDITION);            }
"-"                 {return symbol(sym.SUBSTRACTION);        }
"*"                 {return symbol(sym.MULTIPLY);            }
"/"                 {return symbol(sym.DIVIDE);              }
"^"                 {return symbol(sym.EXP);                 }
"::"                {return symbol(sym.CONCATENATE);         }
"=>"                {return symbol(sym.IMPLICATION);         }
"<="                {return symbol(sym.INF_OR_EQUAL);        }
"="                 {return symbol(sym.EQUAL);               }
"!="                {return symbol(sym.DIFFERENT);           }
":="                {return symbol(sym.ASSIGNMENT);          }

{Comment}           { /*ignore*/ }
{WhiteSpace}        { /* ignore */ }
}

[^]                    { throw new Error("Illegal character <"+yytext()+">"); }