from lexer_parser import *

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
    print("Premises:", premises)

    conclusion = read_conclusion(parser)
    print("Conclusion:", conclusion)
    # TODO: ask for confirmation whether they are okay with those
    return premises, conclusion

input_interface()
