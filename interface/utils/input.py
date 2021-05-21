from lexer_parser import *
from lexer_parser import result

# provide interface, read in the premises that the user puts in
def read_premises(parser):
    print("Put in your premise(s) here:")
    premises = []
    # TODO: this should run until a double \n is encountered
    for i in range(1,3):
        premise = input("{}: ".format(i))
        result = parser.parse(premise)
        premises.append(result)
    return premises

# provide interface, read in the conclusion that the user puts in
def read_conclusion(parser):
    print("Put in your conclusion here:")
    conclusion = input("C: ")
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
