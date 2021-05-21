from utils.lexer_parser import *

# provide interface, read in the premises that the user puts in
def read_premises(parser):
    premises = []
    i = 1
    # read premises until semicolon is encountered
    while True:
        premise = input("Premise {}: ".format(i))
        if premise == ";": break
        result = parser.parse(premise)
        premises.append(result)
        i += 1
    return premises

# provide interface, read in the conclusion that the user puts in
def read_conclusion(parser):
    conclusion = input("Conclusion: ")
    return parser.parse(conclusion)

def input_interface():
    lex.lex()
    parser = yacc.yacc()

    premises = read_premises(parser)
    conclusion = read_conclusion(parser)

    print("Premises:", premises)
    print("Conclusion:", conclusion)

    # TODO: ask for confirmation whether they are okay with those
    return premises, conclusion

# turn a Python list of Python strings into one Prolog list as a string
def list_py2pl(pylist):
    pl_list = "[{}".format(pylist[0])
    for formula in pylist[1:]:
        pl_list += ", {}".format(formula)
    return pl_list + "]"
