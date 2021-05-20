tokens = (
    'PROP',
    'NOT',
    'AND',
    'OR',
    'IF',
    'IFF',
    'FALSE',
    'LPAREN',
    'RPAREN'
    )

# Tokens

# TODO: add other options for the operators
t_PROP   = r'[A-Z]'
t_NOT    = r'\\lnot'
t_AND    = r'\\land'
t_OR     = r'\\lor'
t_IF     = r'\\lif'
t_IFF    = r'\\liff'
t_FALSE  = r'\\lfalse'
t_LPAREN = r'\('
t_RPAREN = r'\)'

# Ignored characters
t_ignore = " \t"

# for tracking linenumbers
def t_newline(t):
    r'\n+'
    t.lexer.lineno += t.value.count("\n")

def t_error(t):
    print(f"Illegal character {t.value[0]!r}")
    t.lexer.skip(1)

# Build the lexer
import ply.lex as lex
lex.lex()

data = '''((P \land Q )   \lif ( R \lfalse  S))
'''

lex.input(data)

while True:
    tok = lex.token()
    if not tok:
        break
    print(tok)
