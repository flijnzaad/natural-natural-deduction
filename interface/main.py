#!/usr/bin/env python3

from utils.output import *
from utils.input import *
from pyswip import Prolog       # querying our knowledge bases
pl = Prolog()

USER_MODE     = True                  # debug constant
SYSTEM_PATH   = "../system.pl"        # relevant paths
QUERIES_PATH  = "../queries.pl"
PREAMBLE_PATH = "utils/preamble.tex"
BUILD_PATH    = "utils/build_proof.pl"
USAGE_PATH    = "utils/usage.txt"

pl.consult(SYSTEM_PATH)      # load the relevant knowledge bases
pl.consult(QUERIES_PATH)
pl.consult(BUILD_PATH)

# TODO: these three functions can be more general
# read a proof from the input and return a string that contains its proof
def get_proof_input():
    premises, conclusion = input_interface()
    premlist = list_py2pl(premises)
    query = "provesWrap({}, {}, X)".format(premlist, conclusion)
    q = list(pl.query(query))
    print("Solved!")
    return q[0]["S"].decode('UTF-8')

# returns a string that contains proof i
def get_proof_examples(i, labeled):
    query = "q" + str(i) + "(X), buildProof(X, S)"
    text = ""
    if labeled: text += "\\paragraph{Proof " + str(i) + "}"
    q = list(pl.query(query))
    print("Solved!")
    text += q[0]["S"].decode('UTF-8')
    return text

# returns a string that contains the proofs in the given range
def get_proof_range(numbers, labeled):
    begin, end = numbers
    text = ""
    for i in range(begin, end+1):
        # process printing to terminal
        query_name = "q" + str(i)
        print(query_name + ":")
        text += get_proof_examples(i, labeled)
    return text

# build a document with only the code of proofs
def build_only_proofs(numbers, proofs):
    with open(get_tex_name(numbers), 'w') as file:
        file.write(proofs)
    if USER_MODE:
        print_built_msg(numbers)

# build a tex file with the code of proofs: add the preamble and surround
# with begin/end document
def build_full_document(numbers, proofs):
    filename = get_tex_name(numbers)
    shutil.copy(PREAMBLE_PATH, filename)
    text = '\n\\begin{document}\n' + proofs + '\n\\end{document}\n'
    with open(filename, 'a') as file:
        file.write(text)
    if USER_MODE:
        print_built_msg(numbers)

def main(arg):
    # TODO: add clipboard functionality
    short_options = "q:r:a:i"
    long_options  = ["tex", "nolabel", "version", "help", "clean", "clip"]

    try:
        opts, _  = getopt.getopt(arg, short_options, long_options)
        # defaults
        labeled  = True
        only_tex = False
        numbers  = get_last_query_no()

        for option, argument in opts:
            if option == '--help':    print_usage()
            if option == '--version': print_version()
            if option == '--clean':   remove_all()

            if option == '-i':
                get_proof_input()
                sys.exit(0)

            if option == '-a':
                get_last_query_no()
                numbers = (1, get_last_query_no())
            if option == '-q':
                numbers = int(argument)
            if option == '-r':
                num = argument.split(',')
                numbers = (int(num[0]), int(num[1]))
            if option == '--tex':
                only_tex = True
                labeled  = False
            if option == '--clip':
                print("This option has yet to be implemented. Using default options")
            if option == '--nolabel': 
                labeled = False

        if type(numbers) == int:
            proofs = get_proof_examples(numbers, labeled)
        else:
            proofs = get_proof_range(numbers, labeled)
        if USER_MODE: print("Succesfully solved the proof(s)")

        if only_tex:
            build_only_proofs(numbers, proofs)
        else:
            build_full_document(numbers, proofs)
            compile_open_pdf(get_filename(numbers))

    except getopt.GetoptError as error:
        # if an invalid option is passed, print error message and usage info
        print("Error:", error)
        print_usage()

# handle KeyboardInterrupts
if __name__ == '__main__':
    try:
        main(sys.argv[1:])
    except KeyboardInterrupt:
        print('Interrupted')
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)
