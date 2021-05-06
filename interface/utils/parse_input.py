import re

def connective_to_functor(connective):
    if connective != "\\lnot":
        return connective[2:]
    else:
        return "neg"

def parse_sentence(line):
    regex_atomic = r"\s*([A-Z]|\\lfalse)\s*"
    regex_unary  = r"\s*(\\lnot)\s*(\(.*\))\s*"
    regex_binary = r"\s*\((.*)\s*(\\land|\\lor|\\lif|\\liff)\s*(.*)\)\s*"
    atomic       = re.match(regex_atomic, line)
    unary        = re.match(regex_unary,  line)
    binary       = re.match(regex_binary, line)
    if atomic:
        # TODO: consider contra
        # TODO: make lowercase
        return atomic[1]
    if unary:
        connective = unary[1]
        argument   = unary[2]
        return connective_to_functor(connective) + "(" + parse_sentence(argument) + ")"
    if binary:
        argument_1 = binary[1]
        connective = binary[2]
        argument_2 = binary[3]
        return connective_to_functor(connective) + "(" + parse_sentence(argument_1) + "," + parse_sentence(argument_2) + ")"
    else:
        return False

def make_premise(line):
    print("make premise")
    # add 'line(...)' and line numbers and premise

def read_premises():
    print("Put in your premise(s) here:")
    premises = []
    for i in range(1,3):
        p = input(str(i) + ": ")
        premises.append(p)
    return premises

def read_conclusion():
    print("Put in your conclusion here:")
    conclusion = input("C: ")
    return conclusion

def input_interface():
    # p = read_premises()
    c = read_conclusion()
    # print(p)
    print(parse_sentence(c))

input_interface()
