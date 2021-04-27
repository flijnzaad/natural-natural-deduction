deep(_, _, N) :-
    N > 5, !, fail.

% if the list doesn't exceed length N, add an a
deep(List, X, N) :-
    length(List, M),
    M < N,
    Y = [a|List],
    deep(Y, Y, N), !.

deep(List, X, N) :-
    New is N + 1,
    deep(List, X, New).

deep(X) :-
    deep([], X, 1).
