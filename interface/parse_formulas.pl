% concatenate the two strings
concatBinary(Connective, StringX, StringY, String) :-
    atomics_to_string(["(", StringX, Connective, StringY, ")"], " ", String).

% the cut is needed to not get the other option of "CONTRA"
stringOf(contra, "\\lfalse") :- !.

% turn an atomic sentence into a capitalized string
stringOf(X, String) :-
    % only do this for atomic sentences
    atom(X),
    % turn the atom into a string
    atom_string(X, StringLower),
    % make the string uppercase
    string_upper(StringLower, String).

% no parentheses needed around negated sentences because all binary connectives
% put parentheses around the subparts already
stringOf(neg(X), String) :-
    stringOf(X, StringX),
    atomics_to_string(["\\lnot", StringX], " ", String).

stringOf(and(X, Y), String) :-
    stringOf(X, StringX),
    stringOf(Y, StringY),
    concatBinary("\\land", StringX, StringY, String).

stringOf(or(X, Y), String) :-
    stringOf(X, StringX),
    stringOf(Y, StringY),
    concatBinary("\\lor", StringX, StringY, String).

stringOf(if(X, Y), String) :-
    stringOf(X, StringX),
    stringOf(Y, StringY),
    concatBinary("\\lif", StringX, StringY, String).

stringOf(iff(X, Y), String) :-
    stringOf(X, StringX),
    stringOf(Y, StringY),
    concatBinary("\\liff", StringX, StringY, String).
