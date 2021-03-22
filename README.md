# Natural Natural Deduction
Repository for the Natural Natural Deduction system: a theorem prover for propositional logic and first-order logic that uses natural deduction and heuristics to find its proofs.

## Dependencies
This system uses [SWI Prolog](https://www.swi-prolog.org/download/stable) version >= 8.2.4.

## Running the system
### Starting, stopping and loading the system
* You can load the system by passing the program to your Prolog interpreter (`prolog`, `swipl` etc.) directly:

      $ prolog system.pl

* You can also start up your Prolog interpreter and load the system there using `make/0`, like so:

      $ prolog

      ?- make.

    * `make/0` consults all source files that have been changed since they were consulted.
    * This way of loading the knowledge base is also useful if you have made changes to the system and want to reload the knowledge base without restarting the interpreter.

* The Prolog interpreter can be stopped like so:

      ?- halt.

### Debugging

* You can turn on the trace like so:

      ?- trace.

    * You will then be able to walk through the steps of the system with each `<Enter>` press.
    * To abort the query in the `trace` mode, type `a` for `[a]bort`.

* You can exit `trace` mode like so:

      [trace]  ? - nodebug.

* If the system gets stuck in infinite recursion, you can stop it with `Ctrl-C`. Then type `a`, for `[a]bort`.

* If your query returns `true` without a full stop at the end, there are still alternative branches of the search tree to be explored. Press `;` to explore another branch, press `.` or `<Enter>` to terminate the search there.
