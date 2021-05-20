import re                # regular expressions
import ply.lex as lex    # lexer
import ply.yacc as yacc  # parser

# LEXER

tokens = (
    'PROP', 'FALSE',
    'NOT',
    'AND', 'OR', 'IFF', 'IF',
    'LPAREN', 'RPAREN'
)

# the IFF regular expression needs to be longer than that of IF, since they
# are evaluated from longest to shortest
t_PROP   = r'[A-Z]|[a-z]'
t_FALSE  = r'\\lfalse|contra|false|\\bot'
t_NOT    = r'\\lnot|not|\\neg|~|!'
t_AND    = r'\\land|and|\\wedge|\^|&{1,2}'
t_OR     = r'\\lor|or|\\vee|v|\|{1,2}'
t_IFF    = r'\\liff|iff|\\leftrightarrow|\\equiv|<->|<=>'
t_IF     = r'\\lif|if|implies|\\to|\\rightarrow|->'
t_LPAREN = r'\('
t_RPAREN = r'\)'

t_ignore = " \t"

def t_error(t):
    print(f"Illegal character {t.value[0]!r}")
    t.lexer.skip(1)

# PARSER

# negation has highest precedence
precedence = (
    ('right', 'AND', 'OR', 'IFF', 'IF'),
    ('right', 'NOT')
)

def p_statement_expr(p):
    'statement : expression'
    print(p[1])

def p_expression_binary(p):
    '''expression : expression AND expression
                  | expression OR  expression
                  | expression IF  expression
                  | expression IFF expression'''
    if   re.match(t_AND, p[2]): p[0] = "and({}, {})".format(p[1], p[3])
    elif re.match(t_OR,  p[2]): p[0] =  "or({}, {})".format(p[1], p[3])
    elif re.match(t_IFF, p[2]): p[0] = "iff({}, {})".format(p[1], p[3])
    elif re.match(t_IF,  p[2]): p[0] =  "if({}, {})".format(p[1], p[3])

def p_expression_not(p):
    'expression : NOT expression'
    p[0] = "neg({})".format(p[2])

def p_expression_group(p):
    'expression : LPAREN expression RPAREN'
    p[0] = p[2]

def p_expression_prop(p):
    'expression : PROP'
    p[0] = p[1].lower()

def p_expression_false(p):
    'expression : FALSE'
    p[0] = 'contra'

def p_error(p):
    print(f"Syntax error at {p.value!r}")

# Build the lexer and the parser
lex.lex()
yacc.yacc()
