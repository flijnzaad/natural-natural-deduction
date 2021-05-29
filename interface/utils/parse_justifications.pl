% connective names and their LaTeX operator code
stringCon("conj",   "$\\land$").
stringCon("disj",   "$\\lor$").
stringCon("neg",    "$\\lnot$").
stringCon("imp",    "$\\lif$").
stringCon("biimp",  "$\\liff$").
stringCon("contra", "$\\lfalse$").

% strings for premises and reiteration; cut to discard other options
stringJust(premise, "") :- !.
stringJust(reit, "Reit: ") :- !.

% get justification for introduction rule
stringJust(Justification, String) :-
    % if the last 5 chars are "Intro"
    sub_string(Justification, _, 5, 0, "Intro"), !,
    % strip everything but the last 5 characters to obtain connective
    sub_string(Justification, 0, _, 5, Connective),
    % obtain LaTeX code for connective
    stringCon(Connective, C),
    % combine connective and "Intro" to final String
    atomics_to_string([C, "~", "Intro: "], "", String).

% get justification for elimination rule
stringJust(Justification, String) :-
    % if the last 4 chars are "Elim"
    sub_string(Justification, _, 4, 0, "Elim"), !,
    % strip everything but the last 4 characters to obtain connective
    sub_string(Justification, 0, _, 4, Connective),
    % obtain LaTeX code for connective
    stringCon(Connective, C),
    % combine connective and "Intro" to final String
    atomics_to_string([C, "~", "Elim: "], "", String).
