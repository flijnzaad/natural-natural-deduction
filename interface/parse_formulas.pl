% the cut is needed to not consider the other option with capitalization
stringOf(contra, "\\lfalse") :- !.

% parse an atomic sentence to a capitalized string
stringOf(X, String) :-
    % only do this for atomic sentences
    atom(X),
    % make the string uppercase
    string_upper(X, String).

% parse negation
stringOf(neg(X), String) :-
    stringOf(X, StringX),
    % no parentheses needed around negated sentences because binary connectives
    % put parentheses around the subparts already
    atomics_to_string(["\\lnot", StringX], " ", String).

% parse binary connectives
stringOf(Formula, String) :-
    % get the name of the binary connective
    functor(Formula, Name, 2),
    % put \l in front of it (\land, \lor, etc.)
    string_concat("\\l", Name, Connective),
    % get the arguments of the connective
    arg(1, Formula, X),
    arg(2, Formula, Y),
    stringOf(X, StringX),
    stringOf(Y, StringY),
    % concatenate the two strings with the connective in between,
    % surrounded by disambiguating parentheses
    atomics_to_string(["(", StringX, Connective, StringY, ")"], " ", String).
