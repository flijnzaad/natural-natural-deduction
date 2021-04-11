# Natural Natural Deduction
Repository for the Natural Natural Deduction system: a theorem prover for propositional logic and first-order logic that uses natural deduction and heuristics to find its proofs.

## Dependencies
This system uses [SWI Prolog](https://www.swi-prolog.org/download/stable) version >= 8.2.4.

## Running the system
### Starting, stopping and loading the system
* You can load the system by passing the program to your Prolog interpreter (`prolog`, `swipl` etc.) directly:

      $ prolog system.pl

* Within the Prolog interpreter, you can (re)load the system using `make/0`:

      ?- make.

    * `make/0` consults all source files that have been changed since they were consulted.
    * If you started the interpreter without arguments (i.e. just `prolog`), you first need to load the knowledge base using `[system].` before you can use `make.`.

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

## Predicates and functions of the knowledge base

* Propositional logic formulas are built up from the following constants and functions, which can be interpreted as prefix operators:
  * atomic constants i.e. lowercase letters `p`, `q`, `r`, etc.
  * special propositional atom `contra` for contradiction
  * unary operator: `neg(_)` (`not/1` is already defined in Prolog)
  * binary operators: 
    * `and(_, _)` for conjunction
    * `or(_, _)` for disjunction
    * `if(_, _)` for implication
    * `iff(_, _)` for bi-implication
* Justifications are as follows:
  * `[conj|disj|neg|imp|biimp|contra][Intro|Elim]` for the introduction and elimination rules
  * `premise` if the line is a premise
  * `reit` if the line is a reiteration
* Citing line numbers (experimental/for the future):
  * `0` if the line is a premise (of a subproof)
  * just the number if only 1 citation
  * `two(x, y)` if two steps `x`, `y` need to be cited
  * `sub(x, y)` if a subproof `x - y` needs to be cited
* `proves(X, Y, Z)`, where:
    * `X` is a list of the proof lines up until now;
    * `Y` is a formula that can be proven from `X`;
    * `Z` is the list you had in `X`, plus the new line `Y` added. This is important for returning the full proof in the end.
    * The justification rules are implemented in the base cases.
    * The recursive case implements the transitivity of provability:
        * `X` is provable from premises `P` if premises `P` can prove line `Y`, and premises `P` plus line `Y` can prove line `X`.
