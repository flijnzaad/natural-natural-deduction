# import the relevant path variables
from main import USER_MODE, USAGE_PATH, INPUT_HELP_PATH
from main import SYSTEM_PATH, QUERIES_PATH, PREAMBLE_PATH
import os, subprocess, platform # compiling and opening a LaTeX pdf
import sys                      # handling KeyboardInterrupts
import shutil                   # copying the 'preamble.tex' file
import getopt                   # handling command line arguments
import re                       # regular expressions
import signal                   # timing out the Prolog search
from contextlib import contextmanager

# remove the .aux and .log files produced by the LaTeX compilation
def clean_auxiliary_files(name):
    # TODO: maybe this is also OS-specific
    aux = name + ".aux"
    log = name + ".log"
    if os.path.exists(aux): os.remove(aux)
    if os.path.exists(log): os.remove(log)

# compile and open a LaTeX pdf
def compile_open_pdf(name):
    # TODO: maybe this is also OS-specific
    compile_command = "pdflatex {}.tex".format(name)
    if USER_MODE:
        # TODO: and this too
        compile_command += ' -interaction=batchmode 2>&1 > /dev/null'
    if USER_MODE: print("Compiling the pdf...")
    os.system(compile_command)

    if USER_MODE: 
        print("Removing auxiliary files...")
        clean_auxiliary_files(name)

    pdf_name = name + ".pdf"
    if USER_MODE: print("Opening the pdf...")
    if platform.system() == "Darwin":           # macOS
        subprocess.call(("open", pdf_name))
    elif platform.system() == "Windows":        # Windows
        os.startfile(pdf_name)
    else:                                       # linux variants
        subprocess.call(("xdg-open", pdf_name))

# print usage information
def print_usage():
    with open(USAGE_PATH, 'r') as file:
        print(file.read(), end='') # no newline at end
    sys.exit(0)

# print input help information
def print_input_help():
    with open(INPUT_HELP_PATH, 'r') as file:
        print(file.read(), end='') # no newline at end
    sys.exit(0)

# print version information
def print_version():
    with open(SYSTEM_PATH, 'r') as file:
        line = file.readline()
        # remove "% " at start and trailing \n
        print("System", line[2:-1])
    sys.exit(0)

# remove all tex proofs, compiled documents and auxiliary files
def remove_all():
    # TODO: maybe this is also OS-specific
    files = os.listdir()
    for file in files:
        if file.startswith('q') or file.startswith("proof_"):
            os.remove(file)
            print("Removed", file)
    sys.exit(0)

# get the last query number from the queries.pl file
def get_last_query_no():
    with open(QUERIES_PATH, 'r') as file:
        for line in reversed(list(file)):
            match = re.match("q([0-9]+)\(X\) :-", line)
            if match: break
    n = match.groups()[0]
    return int(n)

# return filename with the query number(s) in case of an example query,
# and a timestamp in case of manual input
def get_filename(numbers):
    if type(numbers) == str:
        return numbers
    if type(numbers) == int:
        num = str(numbers)
    else:
        num = "{}-{}".format(numbers[0], numbers[1])
    return "q{}".format(num)

# return the filename plus tex extension
def get_tex_name(numbers):
    return get_filename(numbers) + ".tex"

# print a process message that states that a file has been built succesfully
def print_built_msg(numbers):
    msg = "Succesfully built a proof tex file for {}, to be found in {}"
    if type(numbers) == str:
        name = "the manually input proof"
    else:
        name = get_filename(numbers)
    msg = msg.format(name, get_tex_name(numbers))
    print(msg)

# build a document with only the code of proofs
def build_only_proofs(numbers, proofs):
    with open(get_tex_name(numbers), 'w') as file:
        file.write(proofs)
    if USER_MODE: print_built_msg(numbers)

# build a tex file with the code of proofs: add the preamble and surround
# with begin/end document
def build_full_document(numbers, proofs):
    filename = get_tex_name(numbers)
    shutil.copy(PREAMBLE_PATH, filename)
    text = "\n\\begin{{document}}\n{}\n\\end{{document}}\n".format(proofs)
    with open(filename, 'a') as file:
        file.write(text)
    if USER_MODE: print_built_msg(numbers)

# copy the string in the argument to the clipboard
def copy_proof_to_clip(proofs):
    # cross-platform clipboard functionality without extra installs
    from tkinter import Tk
    r = Tk()
    r.withdraw()
    r.clipboard_clear()
    r.clipboard_append(proofs)
    r.update()
    r.destroy()
    if USER_MODE: print("Copied to the system clipboard")
