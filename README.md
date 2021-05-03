# Natural Natural Deduction
Repository for the Natural Natural Deduction system: a theorem prover for propositional logic and first-order logic that uses natural deduction and heuristics to find its proofs.

## Dependencies
* [SWI Prolog](https://www.swi-prolog.org/download/stable) version >= 8.2.4 for finding proofs and parsing to LaTeX code
* [Python](https://www.python.org/) version >= 3.8.5 for file operations
* The Python module [PySwip](https://pypi.org/project/pyswip/) version >= 0.2.10 for connecting Prolog to Python
* [pdflatex/TeX Live 2020](https://tug.org/texlive/) for compiling a LaTeX document

## Install
```
git clone https://github.com/flijnzaad/bachelor-project.git natural-deduction
cd natural-deduction
chmod +x test.pl interface/main.py
```

## Running the interface
* `cd` to the `interface` directory and run `./main.py`. See `./main.py --help` for more information and options.

## Running the system within Prolog
### Starting, stopping and loading the system
* You can load the system by passing the program to the Prolog interpreter (`prolog` and `swipl` are equivalent commands) directly:

      $ prolog system.pl queries.pl

* Within the Prolog interpreter, you can load the knowledge bases using `make/0`:

      ?- make.

    * `make/0` consults all source files that have been changed since they were consulted.
    * If you started the interpreter without arguments (i.e. just `prolog`), you first need to load the knowledge bases using `[system].` and `[queries].` before you can use `make.`.
* To test all queries at once:

      $ prolog test.pl

    * This will exit the Prolog interpreter if it has succesfully executed all goals.
* The Prolog interpreter can be stopped with <kbd>Ctrl</kbd> + <kbd>D</kbd>, or by typing:

      ?- halt.

### Debugging

* You can turn on the trace like so:

      ?- trace.

    * You will then be able to walk through the steps of the system with each <kbd>Enter</kbd> press.
    * To abort the query in the `trace` mode, type <kbd>a</kbd> for `[a]bort`.

* You can exit `trace` mode like so:

      [trace]  ? - nodebug.

* If the system gets stuck in infinite recursion, you can stop it with <kbd>Ctrl</kbd> + <kbd>C</kbd>. Then type <kbd>a</kbd>, for `[a]bort`.

* If your query returns `true` without a full stop at the end, there are still alternative branches of the search tree to be explored. Press <kbd>;</kbd> to explore another branch, press <kbd>.</kbd> or <kbd>Enter</kbd> to terminate the search there.

* To find out how long execution of a query is taking, you may use the [`time/1`](https://www.swi-prolog.org/pldoc/man?predicate=time%2f1) predicate, e.g. `time(q5(X))`.

## Predicates and functions of `system.pl`

For more information on the system-specific syntax, see the report.

`proves(X, Y, Z, D)`, where:
* `X` is a list of the proof lines up until now;
* `Y` is a formula that can be proven from `X`;
* `Z` is the list you had in `X`, plus the new line `Y` added. This is important for returning the full proof in the end;
* `D` is the current maximum search depth in the iterative deepening.
* The justification rules are implemented in the base cases.
* The recursive case implements the transitivity of provability: `X` is provable from premises `P` if premises `P` can prove line `Y`, and premises `P` plus line `Y` can prove line `X`.

## The structure of the parsing system
`system.pl` returns proofs in a Prolog list with the line functor that's described above. The parsing system has the following components, located in the `interface/utils` directory:
* `parse_formulas.pl` contains the `stringFormula/2` predicate. When given a formula in Prolog format with prefix operators, this predicate will return the LaTeX code for this formula.
* `parse_justifications.pl` contains the `stringJust/2` predicate. When given a justification in Prolog format, this predicate will return the LaTeX code for it.
* `parse_citations.pl` contains the `stringCit/2` predicate. When given a citation in Prolog format, this predicate will return the LaTeX code for it.
* `build_proof.pl` first of all 'consults' (loads) the above three programs. When given a proof in the Prolog format (i.e. a list of lines that use the `line` functor), it returns the LaTeX code for a full Fitch-style proof.

`main.py`, located in `interface`, loads the system and `build_proof.pl`. It runs queries in `queries.pl`, 'builds' their LaTeX code and possibly combines this with the given preamble into a tex file. Lastly, it compiles the tex file using `pdflatex` and opens the resulting pdf.
