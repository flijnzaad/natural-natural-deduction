% TODO: research the difference between single and double quotes
stringOf(p,'P').
stringOf(q,'Q').
stringOf(r,'R').
stringOf(s,'S').

% no parentheses needed around negated sentences because all binary connectives
% put parentheses around the subparts already
stringOf(neg(X), String) :-
    stringOf(X, StringX),
    atomics_to_string(['\\lnot', StringX], ' ', String).

stringOf(and(X, Y), String) :-
    stringOf(X, StringX),
    stringOf(Y, StringY),
    atomics_to_string(['(', StringX, '\\land', StringY, ')'], ' ', String).
