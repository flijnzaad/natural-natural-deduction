from pyswip import Prolog       # querying our knowledge bases
pl = Prolog()
import os, subprocess, platform # compiling and opening a LaTeX pdf
import shutil                   # copying the 'preamble.tex' file

pl.consult("../system.pl")      # load the knowledge bases
pl.consult("../tests.pl")
pl.consult("build_proof.pl")

# compiling and opening a LaTeX pdf
def compile_open_pdf(name):
    compile_command = 'pdflatex ' + name + '.tex'
    # TODO: maybe this is also OS-specific
    os.system(compile_command)

    pdf_name = name + '.pdf'
    if platform.system() == 'Darwin':           # macOS
        subprocess.call(('open', pdf_name))
    elif platform.system() == 'Windows':        # Windows
        os.startfile(pdf_name)
    else:                                       # linux variants
        subprocess.call(('xdg-open', pdf_name))

def get_proofs():
    text = ""
    for i in range(1, 12):
        text += "\\paragraph{Proof " + str(i) + "}"
        query = "q" + str(i) + "(X), buildProof(X, S)"
        q = list(pl.query(query))
        text += q[0]["S"].decode('UTF-8')
    text += "\\\\ \\vspace{3mm}"
    return text

def build_file():
    shutil.copy('preamble.tex', 'proof.tex')
    text = '\n\\begin{document}\n' + get_proofs() + '\n\\end{document}\n'
    with open('proof.tex', 'a') as file:
        file.write(text)

build_file()
compile_open_pdf('proof')
