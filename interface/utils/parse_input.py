import re

DEBUG_MODE = True

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
    # TODO: make these more generalized and less of a character dump
    regex_atomic = r"\s*([A-Z]|\\lfalse)\s*"
    regex_unary  = r"\s*\((\\lnot)\s*(\(.*\))\)\s*"
    regex_binary = r"\s*\((\(.*\)|[A-Z]|\\lfalse)\s+(\\land|\\lor|\\liff|\\lif)\s+(\(.*\)|[A-Z]|\\lfalse)\)\s*"
    atomic       = re.match(regex_atomic, line)
    unary        = re.match(regex_unary,  line)
    binary       = re.match(regex_binary, line)
    if atomic:
        atom = atomic[1]
        if DEBUG_MODE: print("Atom:", atom)
        if atom == "\\lfalse":
            return "contra"
        else:
            return atom.lower()
    if unary:
        connective, argument = unary.groups()
        if DEBUG_MODE: print("Unary:", unary.groups())
        return "{}({})".format(connective_to_functor(connective),
                               parse_sentence(argument) )
    if binary:
        argument_1, connective, argument_2 = binary.groups()
        if DEBUG_MODE: print("Binary:", binary.groups())
        return "{}({}, {})".format(connective_to_functor(connective),
                                   parse_sentence(argument_1),
                                   parse_sentence(argument_2) )
    else:
        print("None of the above")
        # TODO: throw an exception here and catch it in the relevant places
        return ""

# make the premise lines and return as list
def make_premises(lines):
    premises = []
    i = 1
    for line in lines:
        formula = parse_sentence(line)
        string = "line({}, {}, premise, 0)".format(i, formula)
        premises.append(string)
        i +=1
    return premises

# make the conclusion line
def make_conclusion(line):
    formula = parse_sentence(line)
    conclusion = "line(_, {}, _, _)".format(formula)
    return conclusion

# provide interface, read in the premises that the user puts in
# TODO: you're not able to do backspace here
def read_premises():
    print("Put in your premise(s) here:")
    premises = []
    # TODO: this should run until a double \n is encountered
    for i in range(1,3):
        p = input("{}: ".format(i))
        premises.append(p)
    return premises

# provide interface, read in the conclusion that the user puts in
def read_conclusion():
    print("Put in your conclusion here:")
    conclusion = input("C: ")
    return conclusion

# TODO: add function to possibly add outer parentheses
def input_interface():
    p = read_premises()
    c = read_conclusion()
    premises = make_premises(p)
    conclusion = make_conclusion(c)
    print("Premises:", premises)
    print("Conclusion:", conclusion)
    # TODO: ask for confirmation whether they are okay with those
    return premises, conclusion

# input_interface()
print(parse_sentence("((P \land R) \liff (\lfalse \lif Q))"))
print(parse_sentence("((P \land R) \lif (\lnot (A \lor Q)))"))
