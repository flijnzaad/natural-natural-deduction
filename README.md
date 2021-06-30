# "Natural" Natural Deduction
Repository for the "Natural" Natural Deduction system: a theorem prover for
propositional logic that uses natural deduction and heuristics to find its
proofs.

## Dependencies
* [SWI Prolog](https://www.swi-prolog.org/download/stable) version >= 8.2.4
  for finding proofs and parsing to LaTeX code
* [Python](https://www.python.org/) version >= 3.8.5 for file operations and
  parsing input to Prolog code
* The Python module [PySwip](https://pypi.org/project/pyswip/) version >=
  0.2.10 for connecting Prolog to Python
* [pdflatex/TeX Live 2020](https://tug.org/texlive/) for compiling a LaTeX
  document

## Install
```
git clone https://github.com/flijnzaad/natural-natural-deduction.git
cd natural-natural-deduction
chmod +x interface/main.py
```

## Run
* `cd` to the `interface` directory and run `./main.py`. See `./main.py
  --help` for more information and options. Note that while using the program
  via its interface, it can only be aborted by using `killall python3`. This
  is because of a limitation in PySwip. The interface has a set time limit of
  10 minutes, after which it aborts the search.

## Running the system within Prolog
One may also run the system from within Prolog.

### Starting, stopping and loading the system
* You can load the system by passing the program to the Prolog interpreter
  (`prolog` and `swipl` are equivalent commands) directly:

      $ prolog system.pl queries.pl

* Within the Prolog interpreter, you can load the knowledge bases using
  `make/0`:

      ?- make.

    * `make/0` consults all source files that have been changed since they
      were consulted.
    * If you started the interpreter without arguments (i.e. just `prolog`),
      you first need to load the knowledge bases using `[system].` and
      `[queries].` before you can use `make.`.

* To test all queries at once:

      $ prolog test.pl

    * This will exit the Prolog interpreter if it has succesfully executed all
      goals.

* The Prolog interpreter can be stopped with <kbd>Ctrl</kbd> + <kbd>D</kbd>,
  or by typing:

      ?- halt.

### Debugging

* If the system gets stuck in infinite recursion, you can stop it with
  <kbd>Ctrl</kbd> + <kbd>C</kbd>. Then type <kbd>a</kbd>, for `[a]bort`.
* To find out how long execution of a query is taking, you may use the
  [`time/1`](https://www.swi-prolog.org/pldoc/man?predicate=time%2f1)
  predicate, e.g. `time(q5(X))`.

## To do
(Note to supervisor and second reader: I will not change these things in the
`main` branch until after I have received a grade for my thesis.)
* Fix the issues with completeness and the search strategy
* Add input file functionality
* Add option to change the timeout time via command line
* Add documentation (i.e. thesis report) for developing
* Make this README more extensive in describing the options etc. for user
* Catch syntax errors in parsing input formulas before starting to query
