import re

# binary connectives
def parse_binary_sentence(line):
    regex_binary = "\((.*) (\\land|\\lor|\\lif|\\liff) (.*)\)"
    x = re.match(regex_binary, line)
    if x:
        argument_1 = x[1]
        connective = x[2]
        argument_2 = x[3]
        return argument_1, connective, argument_2
    else:
        return False

def make_premise(line):
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
    p = read_premises()
    c = read_conclusion()
    print(p)
    print(c)

input_interface()
