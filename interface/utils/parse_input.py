import re

# returns the functor of the LaTeX code of a connector 
# TODO: add more options for connectives here
def connective_to_functor(connective):
    if connective != "\\lnot":
        return connective[2:]
    else:
        return "neg"

# recursively parse the sentence using regex
# TODO: add more options for connectives here
def parse_sentence(line):
    regex_atomic = r"\s*([A-Z]|\\lfalse)\s*"
    regex_unary  = r"\s*(\\lnot)\s*(\(.*\))\s*"
    regex_binary = r"\s*\((.*)\s*(\\land|\\lor|\\lif|\\liff)\s*(.*)\)\s*"
    atomic       = re.match(regex_atomic, line)
    unary        = re.match(regex_unary,  line)
    binary       = re.match(regex_binary, line)
    if atomic:
        atom = atomic[1]
        if atom == "\\lfalse":
            return "contra"
        else:
            return atom.lower()
    if unary:
        connective, argument = unary.groups()
        # TODO: make this code less ugly
        return connective_to_functor(connective) + "(" + parse_sentence(argument) + ")"
    if binary:
        argument_1, connective, argument_2 = binary.groups()
        # TODO: make this code less ugly
        return connective_to_functor(connective) + "(" + parse_sentence(argument_1) + ", " + parse_sentence(argument_2) + ")"
    else:
        # TODO: should you throw an exception here or not always?
        return ""

# make the premise lines and return as list
def make_premises(lines):
    premises = []
    i = 1
    for line in lines:
        formula = parse_sentence(line)
        # TODO: make this code less ugly
        string = "line(" + str(i) + ", " + formula + ", premise, 0)"
        premises.append(string)
        i +=1
    return premises

# make the conclusion line
def make_conclusion(line):
    formula = parse_sentence(line)
    # TODO: make this code less ugly
    conclusion = "line(_, " + formula + ", _, _)"
    return conclusion

def read_premises():
    print("Put in your premise(s) here:")
    premises = []
    # TODO: this should run until a double \n is encountered
    for i in range(1,3):
        p = input(str(i) + ": ")
        premises.append(p)
    return premises

def read_conclusion():
    print("Put in your conclusion here:")
    conclusion = input("C: ")
    return conclusion

# TODO: add function to possibly add outer parentheses
# FIXME: see bug in instructions
def input_interface():
    p = read_premises()
    c = read_conclusion()
    premises = make_premises(p)
    conclusion = make_conclusion(c)
    print("Premises:", premises)
    print("Conclusion:", conclusion)
    # TODO: ask for confirmation whether they are okay with those
    return premises, conclusion

input_interface()
