from pyswip import Prolog
pl = Prolog()

# load the knowledge base
pl.consult("../system.pl")

def compile_open_pdf(name):
    # compiling and opening a LaTeX pdf
    import os, subprocess, platform

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

def get_proof():
    pl.consult("../tests.pl")
    pl.consult("build_proof")
    query = "q4(X), buildProof(X, S)"
    q = list(pl.query(query))
    return q[0]["S"].decode('UTF-8')

def build_file():
    import shutil
    shutil.copy('preamble.tex', 'proof.tex')
    text = '\n\\begin{document}\n' + get_proof() + '\n\\end{document}\n'
    with open('proof.tex', 'a') as file:
        file.write(text)

build_file()
compile_open_pdf('proof')
