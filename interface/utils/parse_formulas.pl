% the cut is needed to not consider the other option with capitalization
stringForm(contra, "\\lfalse") :- !.

% parse an atomic sentence to a capitalized string
stringForm(X, String) :-
    % only do this for atomic sentences i.e propositional atoms
    atom(X), !,
    % make the string uppercase
    string_upper(X, String).

% parse negation
stringForm(neg(X), String) :-
    !, stringForm(X, StringX),
    % no parentheses needed around negated sentences, because binary
    % connectives put parentheses around the subparts already
    % atomics_to_string(["\\lnot", StringX], " ", String).
    string_concat("\\lnot ", StringX, String).

% parse binary connectives
stringForm(Formula, String) :-
    % get the name of the binary connective
    functor(Formula, Name, 2),
    % put \\l in front of it (\\land, \\lor, etc.)
    string_concat("\\l", Name, Connective),
    % get the arguments of the connective
    arg(1, Formula, X),
    arg(2, Formula, Y),
    % recursively parse those two formulas
    stringForm(X, StringX),
    stringForm(Y, StringY),
    % concatenate the two strings with the connective in between,
    % surrounded by disambiguating parentheses
    atomics_to_string(["(", StringX, Connective, StringY, ")"], " ", String).

% wrapper predicate to surround the formula with math mode
stringFormula(Formula, String) :-
    stringForm(Formula, StringMath),
    atomics_to_string(["$", StringMath, "$"], "", String).
