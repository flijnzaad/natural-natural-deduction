# import the relevant path variables
from main import USER_MODE, SYSTEM_PATH, USAGE_PATH, QUERIES_PATH
import os, subprocess, platform # compiling and opening a LaTeX pdf
import sys                      # handling KeyboardInterrupts
import shutil                   # copying the 'preamble.tex' file
import getopt                   # handling command line arguments
import re                       # regular expressions

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
    if USER_MODE: 
        # TODO: and this too
        compile_command += ' -interaction=batchmode 2>&1 > /dev/null'
    if USER_MODE: print("Compiling the pdf...")
    os.system(compile_command)
    if USER_MODE: 
        print("Removing auxiliary files...")
        clean_auxiliary_files(name)
    pdf_name = name + '.pdf'
    if USER_MODE: print("Opening the pdf...")
    if platform.system() == 'Darwin':           # macOS
        subprocess.call(('open', pdf_name))
    elif platform.system() == 'Windows':        # Windows
        os.startfile(pdf_name)
    else:                                       # linux variants
        subprocess.call(('xdg-open', pdf_name))

# print usage information
def print_usage():
    with open(USAGE_PATH, 'r') as file:
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
        if file.startswith("q"):
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

# return filename with the query number(s)
def get_filename(numbers):
    if type(numbers) == int:
        num = str(numbers) 
    else:
        num = str(numbers[0]) + '-' + str(numbers[1])
    return 'q' + str(num)

# return the filename plus tex extension
def get_tex_name(numbers):
    return get_filename(numbers) + '.tex'

# print a process message that states that a file has been built succesfully
def print_built_msg(numbers):
    print("Succesfully built a proof tex file for " + get_filename(numbers) 
      + ", to be found in " + get_tex_name(numbers))
