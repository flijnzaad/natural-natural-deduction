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

    print("Querying the system with this argument:")
    print("    Premises: ", premises)
    print("    Conclusion: ", conclusion)

    # TODO: ask for confirmation whether they are okay with those
    return premises, conclusion

# add the arguments to a line functor and return
def string_premise(premise, n):
    return "line({}, {}, premise, 0)".format(n, premise)

# build the list of premises (incl. line functors and line numbers) as a
# string
def string_premises(premises):
    # empty premises
    if not premises: return "[]"
    n = 1
    pl_list = "[{}".format(string_premise(premises[0], n))
    n += 1
    for formula in premises[1:]:
        pl_list += ", {}".format(string_premise(formula, n))
        n += 1
    return pl_list + "]"

# add the argument to a line functor
def string_conclusion(conclusion):
    return "line(_, {}, _, _)".format(conclusion)
