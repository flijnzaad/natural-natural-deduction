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

def get_formula():
    pl.consult("parse_formulas.pl")
    query = "stringOf(if(neg(p), and(p, or(p, iff(r, contra)))), X)"
    q = list(pl.query(query))
    # convert byte string to regular string
    f = q[0]["X"].decode('UTF-8')
    print(f)

# test query
query = "provesWrap([line(p, premise), line(q, premise), line(r, premise)], line(and(and(p, q), r), _), X)."
q = list(pl.query(query))
proof = []

for line in q[0]["X"]:
    # this may need updating once subproofs are implemented
    proof.append(line.value)

print(proof)

get_formula()
