from pyswip import Prolog       # querying our knowledge bases
pl = Prolog()
import os, subprocess, platform # compiling and opening a LaTeX pdf
import sys                      # handling KeyboardInterrupts
import shutil                   # copying the 'preamble.tex' file

pl.consult("../system.pl")      # load the relevant knowledge bases
pl.consult("../queries.pl")
pl.consult("build_proof.pl")

# compiling and opening a LaTeX pdf
def compile_open_pdf(name):
    # TODO: maybe this command is also OS-specific
    compile_command = 'pdflatex ' + name + '.tex'
    os.system(compile_command)

    pdf_name = name + '.pdf'
    if platform.system() == 'Darwin':           # macOS
        subprocess.call(('open', pdf_name))
    elif platform.system() == 'Windows':        # Windows
        os.startfile(pdf_name)
    else:                                       # linux variants
        subprocess.call(('xdg-open', pdf_name))

# remove the .aux and .log files produced by the LaTeX compilation
def clean_auxiliary_files():
    if os.path.exists("*.aux"):
        os.remove("*.aux")
    if os.path.exists("*.log"):
        os.remove("*.log")

# returns a string that contains proof i
def get_proof(i):
    query = "q" + str(i) + "(X), buildProof(X, S)"
    q = list(pl.query(query))
    return q[0]["S"].decode('UTF-8')

# returns a string that contains the proofs in the given range
def get_proofs(begin, end):
    text = ""
    for i in range(begin, end+1):
        query_name = "q" + str(i)
        print(query_name + ":")
        text += "\\paragraph{Proof " + str(i) + "}"
        text += get_proof(i)
    return text

# build a document with only the code of one proof
def build_doc_proof(i):
    filename = "q" + str(i) + '.tex'
    with open(filename, 'w') as file:
        file.write(get_proof(i))
    print("Succesfully made a proof for q" + str(i) + ", to be found in " +
            filename)

# build a document with all proofs in the range, add the preamble and surround
# with begin/end document
def build_doc_complete(begin, end):
    shutil.copy('preamble.tex', 'proofs.tex')
    text = '\n\\begin{document}\n' + get_proofs(begin, end) + '\n\\end{document}\n'
    with open('proofs.tex', 'a') as file:
        file.write(text)

# print version information
def version():
    with open('../system.pl', 'r') as file:
        line = file.readline()
        print(line[2:-1]) # remove "% " at start and trailing \n

def main():
    build_doc_complete(22, 22)
    # compile_open_pdf('proofs')
    build_doc_proof(19)

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print('Interrupted')
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)
