#!/usr/bin/env python3

from utils.output import *
from utils.input import *
from pyswip import Prolog       # querying our knowledge bases
from pyswip.prolog import PrologError
pl = Prolog()

USER_MODE     = True            # debug constant
TIMEOUT       = 600             # timeout for query in seconds

SYSTEM_PATH     = "../system.pl"  # relevant filepaths
QUERIES_PATH    = "../queries.pl"
PREAMBLE_PATH   = "utils/preamble.tex"
BUILD_PATH      = "utils/build_proof.pl"
USAGE_PATH      = "utils/usage.txt"
INPUT_HELP_PATH = "utils/input-instructions.txt"

pl.consult(SYSTEM_PATH)         # load the relevant knowledge bases
pl.consult(QUERIES_PATH)
pl.consult(BUILD_PATH)

# prints the appropriate timeout message to the screen
def print_timeout_msg(query):
    if query.startswith("provesWrap"):
        name = "the manually input query"
    else:
        name = "query {}".format(query[1:-3])
    print("Timeout: the proof search for {} took longer than {} seconds and "
          "was aborted".format(name, TIMEOUT))

# solve a query within the TIMEOUT time limit;
# return the LaTeX code as made by `buildProof`
def solve_query(query):
    # call with set time limit to avoid getting stuck
    final = ( "time(call_with_time_limit({}, {})), "
              "buildProof(X, S)".format(TIMEOUT, query) )
    try:
        q = list(pl.query(final))
        if q:
            print("Solved!")
            return q[0]["S"].decode('UTF-8')
    except PrologError:
        print_timeout_msg(query)
        return None

# read a proof from the input and return a string that contains its proof
def get_proof_input():
    premises, conclusion = input_interface()
    premises   = string_premises(premises)
    conclusion = string_conclusion(conclusion)
    query = "provesWrap({}, {}, X)".format(premises, conclusion)
    proof = solve_query(query)
    if proof is None:
        sys.exit(1)
    return proof

# returns a string that contains proof i
def get_proof_examples(i, labeled):
    query = "q{}(X)".format(i)
    text = ""
    if labeled: text += "\\paragraph{{Proof {}}}".format(i)
    proof = solve_query(query)
    if proof is not None:
        text += proof
    return text

# returns a string that contains the proofs in the given range
def get_proof_range(numbers, labeled):
    begin, end = numbers
    text = ""
    for i in range(begin, end+1):
        # process printing to terminal
        query_name = "q{}".format(i)
        print(query_name + ':')
        text += get_proof_examples(i, labeled)
    return text

def main(arg):
    short_options = "q:r:a:i"
    long_options  = ["tex", "nolabel", "cliptex", "clip",
                     "version", "help", "in-help", "clean"]

    try:
        opts, _  = getopt.getopt(arg, short_options, long_options)
        # defaults
        labeled    = True
        only_tex   = False
        clip       = False
        input_mode = False
        numbers    = get_last_query_no()

        for option, argument in opts:
            if option == '--help':    print_usage()
            if option == '--in-help': print_input_help()
            if option == '--version': print_version()
            if option == '--clean':   remove_all()

            if option == '-i':
                input_mode = True
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
            if option == '--cliptex':
                clip     = True
                only_tex = True
            if option == '--clip':
                clip     = True
            if option == '--nolabel': 
                labeled = False

        if input_mode:
            proofs = get_proof_input()
            # give the file "proof_[timestamp]" as name
            from datetime import datetime
            timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
            numbers = "proof_{}".format(timestamp)
        else:
            if type(numbers) == int:
                # single query
                proofs = get_proof_examples(numbers, labeled)
            else:
                # range of queries
                proofs = get_proof_range(numbers, labeled)

        if USER_MODE: print("Succesfully solved the proof(s)")

        if clip:
            copy_proof_to_clip(proofs)

        if only_tex:
            build_only_proofs(numbers, proofs)
        elif not clip:
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
