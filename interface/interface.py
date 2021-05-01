from pyswip import Prolog       # querying our knowledge bases
pl = Prolog()
import os, subprocess, platform # compiling and opening a LaTeX pdf
import sys                      # handling KeyboardInterrupts
import shutil                   # copying the 'preamble.tex' file
import getopt                   # handling command line arguments

pl.consult("../system.pl")      # load the relevant knowledge bases
pl.consult("../queries.pl")
pl.consult("build_proof.pl")

# remove the .aux and .log files produced by the LaTeX compilation
def clean_auxiliary_files(name):
    # TODO: maybe this is also OS-specific
    if os.path.exists(name + ".aux"):
        os.remove(name + ".aux")
    if os.path.exists(name + ".log"):
        os.remove(name + ".log")

# compile and open a LaTeX pdf
def compile_open_pdf(name):
    # TODO: maybe this is also OS-specific
    compile_command = 'pdflatex ' + name + '.tex'
    os.system(compile_command)
    clean_auxiliary_files(name)

    pdf_name = name + '.pdf'
    if platform.system() == 'Darwin':           # macOS
        subprocess.call(('open', pdf_name))
    elif platform.system() == 'Windows':        # Windows
        os.startfile(pdf_name)
    else:                                       # linux variants
        subprocess.call(('xdg-open', pdf_name))

# returns a string that contains proof i
def get_proof(i, labeled):
    query = "q" + str(i) + "(X), buildProof(X, S)"
    text = ""
    if labeled: text += "\\paragraph{Proof " + str(i) + "}"
    q = list(pl.query(query))
    text += q[0]["S"].decode('UTF-8')
    return text

# returns a string that contains the proofs in the given range
def get_proof_range(begin, end, labeled):
    text = ""
    for i in range(begin, end+1):
        # process printing to terminal
        query_name = "q" + str(i)
        print(query_name + ":")
        text += get_proof(i, labeled)
    return text

# return filename with the query number(s)
def get_filename(numbers):
    if type(numbers) == int:
        num = str(numbers) 
    else:
        num = str(numbers[0]) + '-' + str(numbers[1])
    return 'q' + str(num)

def get_tex_name(numbers):
    return get_filename(numbers) + '.tex'

# build a document with only the code of proofs
def build_only_proofs(numbers, proofs):
    with open(get_tex_name(numbers), 'w') as file:
        file.write(proofs)
    print("Succesfully made a proof for " + get_filename(numbers) 
          + ", to be found in " + get_tex_name(numbers))

# build a tex file with the code of proofs: add the preamble and surround
# with begin/end document
def build_full_document(numbers, proofs):
    filename = get_tex_name(numbers)
    shutil.copy('preamble.tex', filename)
    text = '\n\\begin{document}\n' + proofs + '\n\\end{document}\n'
    with open(filename, 'a') as file:
        file.write(text)

# print usage information
def print_usage():
    with open('usage.txt', 'r') as file:
        print(file.read(), end='') # no newline at end
    sys.exit(0)

# print version information
def print_version():
    with open('../system.pl', 'r') as file:
        line = file.readline()
        print(line[2:-1]) # remove "% " at start and trailing \n
    sys.exit(0)

# remove all tex proofs and compiled documents
def remove_all():
    # TODO: maybe this is also OS-specific
    if os.path.exists("q*"):
        os.remove("q*")
    sys.exit(0)

def get_last_query_no():
    with open('../queries.pl', 'r') as file:
        for line in reversed(list(file)):
            print(line.rstrip())
    return 22

def main(arg):
    # TODO: add clipboard functionality
    # build_full_document((18,20), get_proof_range(18, 20, True))
    # compile_open_pdf(get_filename((18,20)))
    # usage()
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
                numbers = (1, 22)
            if option == '-q':
                numbers = int(argument)
            if option == '-r':
                num = argument.split(',')
                numbers = (int(num[0]), int(num[1]))
            if option == '--tex':
                only_tex = True
            if option == '--nolabel': 
                labeled = False
        if int(numbers):
            proofs = get_proof(numbers, labeled)
        else:
            proofs = get_proof_range(numbers, labeled)
        if only_tex:
            build_only_proofs(numbers, proofs)
        else:
            build_full_document(numbers, proofs)
            compile_open_pdf(get_filename(numbers))

    except:
        # if no valid options are passed, print error message
        # and usage information
        # TODO: make more elaborate with the offending option
        print("Unknown option used", arg)
        print_usage()

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
