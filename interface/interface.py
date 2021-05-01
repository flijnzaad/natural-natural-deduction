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

# returns a strings that contains the proof(s)
def get_proofs():
    text = ""
    for i in range(16, 20+1):
        query_name = "q" + str(i)
        print(query_name + ":")
        text += "\\paragraph{Proof " + str(i) + "}"
        query = query_name + "(X), buildProof(X, S)"
        q = list(pl.query(query))
        text += q[0]["S"].decode('UTF-8')
    return text

# add the preamble to the proof(s) and surround with begin/end document
def build_file():
    shutil.copy('preamble.tex', 'proof.tex')
    text = '\n\\begin{document}\n' + get_proofs() + '\n\\end{document}\n'
    with open('proof.tex', 'a') as file:
        file.write(text)

def main():
    build_file()
    compile_open_pdf('proof')

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
