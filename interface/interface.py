from pyswip import Prolog
pl = Prolog()

# load the knowledge base
pl.consult("../system.pl")

def compile_open_pdf():
    # compiling and opening a LaTeX pdf
    import os, subprocess, platform
    filepath = 'example.pdf'

    compile = 'pdflatex example.tex'
    # TODO: maybe this is also OS-specific
    os.system(compile_pdf)

    if platform.system() == 'Darwin':           # macOS
        subprocess.call(('open', filepath))
    elif platform.system() == 'Windows':        # Windows
        os.startfile(filepath)
    else:                                       # linux variants
        subprocess.call(('xdg-open', filepath))

def get_proof():
    pl.consult("../tests.pl")
    pl.consult("build_proof")
    query = "q4(X), buildProof(X, S)"
    q = list(pl.query(query))
    p = q[0]["S"].decode('UTF-8')
    print(p)

get_proof()
