% 0 encodes a premise, so nothing to cite: empty string
stringCit(0, "") :- !.

% one line cited
stringCit(Cit, Cit) :-
    number(Cit), !.

% a subproof cited
stringCit(sub(X, Y), String) :-
    atomics_to_string([X, "--", Y], "", String).

% two lines cited
stringCit(two(X, Y), String) :-
    stringCit(X, S1),
    stringCit(Y, S2),
    atomics_to_string([S1, ", ", S2], "", String).

% three lines cited
stringCit(three(X, Y, Z), String) :-
    stringCit(X, S1),
    stringCit(Y, S2),
    stringCit(Z, S3),
    atomics_to_string([S1, ", ", S2, ", ", S3], "", String).
