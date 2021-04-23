deep(_, _, N) :-
    N > 5, !, fail.

% if the list doesn't exceed length N, add an a
deep(List, X, N) :-
    length(List, M),
    M < N,
    Y = [a|List],
    deep(Y, X, N), !.

deep(List, X, N) :-
    New is N + 1,
    deep(List, X, New).

deep(X) :-
    deep([], X, 1).

id(S, Path) :-
    from(Limit, 1, 5),
    id1(S, 0, Limit, Path).

id1(S, Depth, Limit, [S]) :-
    Depth < Limit,
    goal(S).

id1(S, Depth, Limit, [S|Rest]) :-
    Depth < Limit,
    Depth2 is Depth + 1,
    arc(S, S2),
    id1(S2, Depth2, Limit, Rest).

from(X, X, Inc).
from(X, N, Inc) :-
    N2 is N + Inc,
    from(X, N2, Inc).
