% base case for list recursion: fail
connective([], _) :-
    !, fail.

% base case for list recursion
connective([H|_], Connective) :-
    connective(H, Connective), !.

% recursively go through the list
connective([_|T], Connective) :-
    connective(T, Connective), !.

% get rid of the line/4 wrapper functor
connective(line(_, Formula, _, _), Connective) :-
    connective(Formula, Connective), !.

% base case: succeed
connective(Formula, Connective) :-
    functor(Formula, Connective, _), !.

% base case: fail
connective(Term, _) :-
    atomic(Term), !, fail.

% check in first argument
connective(Formula, Connective) :-
    arg(1, Formula, X),
    connective(X, Connective), !.

% check in second argument
connective(Formula, Connective) :-
    functor(Formula, _, 2),
    arg(2, Formula, X),
    connective(X, Connective), !.
