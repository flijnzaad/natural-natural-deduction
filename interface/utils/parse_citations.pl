% 0 encodes a premise, so nothing to cite: empty string
stringCit(0, "") :- !.

% one line cited
stringCit(Cit, String) :-
    number(Cit), !,
    string_concat(": ", Cit, String).

% two lines cited
stringCit(two(X, Y), String) :-
    atomics_to_string([": ", X, ", ", Y], "", String).

% a subproof cited
stringCit(sub(X, Y), String) :-
    atomics_to_string([": ", X, "--", Y], "", String).
