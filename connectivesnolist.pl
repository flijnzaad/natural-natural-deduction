connectives(Premises, Conclusion, Connective) :-
    connList(Premises, Connective),
    % obtain list of connectives in the conclusion
    connLine(Conclusion, Connective).

% base case to stop recursion
connList([], _).

% recursively go through the list
connList([H|T], List) :-
    connLine(H, L1),
    connList(T, L2).

% get rid of the line/4 wrapper functor
connLine(line(_, Formula, _, _), List) :-
    connLine(Formula, List), !.

% stop when at atomic term
connLine(Term, []) :-
    atomic(Term), !.

% binary functors: add the connective to the list, process both arguments
connLine(Term, [Connective|Tail]) :-
    functor(Term, Connective, N),
    N =:= 2, !,
    arg(1, Term, X),
    arg(2, Term, Y),
    connLine(X, L1),
    connLine(Y, L2),
    append(L1, L2, Tail).

% unary functor: add the connective to the list, process the argument
connLine(Term, [Connective|Tail]) :-
    functor(Term, Connective, N),
    N =:= 1, !,
    arg(1, Term, X),
    connLine(X, Tail).
