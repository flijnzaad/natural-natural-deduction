from pyswip import Prolog       # querying our knowledge bases
pl = Prolog()
import os, subprocess, platform # compiling and opening a LaTeX pdf
import sys                      # handling KeyboardInterrupts
import shutil                   # copying the 'preamble.tex' file

pl.consult("../system.pl")      # load the relevant knowledge bases
pl.consult("../queries.pl")
pl.consult("build_proof.pl")

# compile and open a LaTeX pdf
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

# build a document with only the code of proofs
def build_only_proofs(numbers, proofs):
    # TODO: change filename
    filename = "q" + str(numbers) + '.tex'
    with open(filename, 'w') as file:
        file.write(proofs)
    print("Succesfully made a proof for q" + str(i) + ", to be found in " +
            filename)

# build a document with the code of proofs, add the preamble and surround
# with begin/end document
def build_full_document(proofs):
    # TODO: change filename
    shutil.copy('preamble.tex', 'proofs.tex')
    text = '\n\\begin{document}\n' + proofs + '\n\\end{document}\n'
    with open('proofs.tex', 'a') as file:
        file.write(text)

# display usage information
def usage():
    print("This should display the usage information")
    sys.exit(0)

# print version information
def version():
    with open('../system.pl', 'r') as file:
        line = file.readline()
        print(line[2:-1]) # remove "% " at start and trailing \n

def main():
    # TODO: handle the argument options here
    build_only_proofs(18, get_proof_range(18, 20, False))
    compile_open_pdf('proofs')

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print('Interrupted')
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)
