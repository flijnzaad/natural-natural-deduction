from pyswip import Prolog       # querying our knowledge bases
pl = Prolog()
import os, subprocess, platform # compiling and opening a LaTeX pdf
import sys                      # handling keyboardinterrupts
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

# returns a string that contains proof i
def get_proof(i):
    query = "q" + str(i) + "(X), buildProof(X, S)"
    q = list(pl.query(query))
    return q[0]["S"].decode('UTF-8')

# returns a string that contains the proofs in the given range
def get_proofs(begin, end):
    all = ""
    for i in range(begin, end+1):
        query_name = "q" + str(i)
        print(query_name + ":")
        text += "\\paragraph{Proof " + str(i) + "}"
        all += get_proof(i)
    return all

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

def main():
    # build_doc_complete(16, 20)
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

# TODO: add commands that remove the aux and log files (comment it out because
# of debugging purposes, you want to be able to view the .log file) 
# TODO: add argument functionality: "--all" solves all proofs in tests.pl, an
# integer argument only solves that numbered query
