#!/usr/bin/env python3

from utils import *
from pyswip import Prolog       # querying our knowledge bases
pl = Prolog()

pl.consult("../system.pl")      # load the relevant knowledge bases
pl.consult("../queries.pl")
pl.consult("build_proof.pl")

USER_MODE = True                # debug constant

# returns a string that contains proof i
def get_proof(i, labeled):
    query = "q" + str(i) + "(X), buildProof(X, S)"
    text = ""
    if labeled: text += "\\paragraph{Proof " + str(i) + "}"
    q = list(pl.query(query))
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
        text += get_proof(i, labeled)
    return text

# build a document with only the code of proofs
def build_only_proofs(numbers, proofs):
    with open(get_tex_name(numbers), 'w') as file:
        file.write(proofs)
    print("Succesfully built a proof tex file for " + get_filename(numbers) 
          + ", to be found in " + get_tex_name(numbers))

# build a tex file with the code of proofs: add the preamble and surround
# with begin/end document
def build_full_document(numbers, proofs):
    filename = get_tex_name(numbers)
    shutil.copy('preamble.tex', filename)
    text = '\n\\begin{document}\n' + proofs + '\n\\end{document}\n'
    with open(filename, 'a') as file:
        file.write(text)
    print("Succesfully built a proof tex file for " + get_filename(numbers) 
          + ", to be found in " + get_tex_name(numbers))

def main(arg):
    # TODO: add clipboard functionality
    short_options = "q:r:a"
    long_options  = ["tex", "nolabel", "version", "help", "remove"]
    try:
        opts, _ = getopt.getopt(arg, short_options, long_options)
        # defaults
        labeled = True
        only_tex = False
        numbers = get_last_query_no()
        # TODO: make switch?
        for option, argument in opts:
            if option == '--help':
                print_usage()
            if option == '--version':
                print_version()
            if option == '--remove':
                remove_all()
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
            if option == '--nolabel': 
                labeled = False
        if type(numbers) == int:
            proofs = get_proof(numbers, labeled)
        else:
            proofs = get_proof_range(numbers, labeled)
        if USER_MODE: print("Succesfully solved all proofs")
        if only_tex:
            build_only_proofs(numbers, proofs)
        else:
            build_full_document(numbers, proofs)
            compile_open_pdf(get_filename(numbers))

    except getopt.GetoptError:
        # if no valid options are passed, print error message
        # and usage information
        # TODO: make more elaborate with the offending option
        print("Unknown option used", arg)
        # print_usage()

# TODO: use pdflatex quiet mode and instead print progress messages to
# the terminal
# TODO: split this up into multiple files (i.e. util etc)

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