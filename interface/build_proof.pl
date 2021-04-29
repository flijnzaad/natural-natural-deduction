:- consult('parse_formulas.pl'), consult('parse_justifications.pl').
:- set_prolog_flag(answer_write_options,
                    [ quoted(true),
                      portray(true),
                      spacing(next_argument),
                      character_escapes(false)
                    ]).

% return the code for one line in String
oneLine(N, Formula, Justification, String) :-
    stringFormula(Formula, F),
    stringJust(Justification, J),
    atomics_to_string(["    & ", N, ". ", F, " & ", J], "", String).

% base case for building the last premise
buildPremises([line(N, X, J)|T], T, Build, String) :-
    oneLine(N, X, J, Line),
    atomics_to_string([Build, Line, "\n"], "", String),
    T = [line(_, _, Just)|_],
    Just \= premise, !.

% recursive case for building premises
buildPremises([line(N, X, J)|T], Rest, Build, String) :-
    oneLine(N, X, J, Line),
    atomics_to_string([Build, Line, " \\\\ \n"], "", String1),
    buildPremises(T, Rest, String1, String).

% base case for building normal lines
buildLines([line(N, X, J)|[]], Build, String) :-
    oneLine(N, X, J, Line),
    atomics_to_string([Build, Line, "\n"], "", String), !.

% recursive case for building normal lines
buildLines([line(N, X, J)|T], Build, String) :-
    oneLine(N, X, J, Line),
    atomics_to_string([Build, Line, " \\\\ \n"], "", String1),
    buildLines(T, String1, String).

buildProof(Lines, String) :-
    buildPremises(Lines, Rest, "", String1),
    buildLines(Rest, "", String2),
    atomics_to_string(["\n\\fitch{\n", String1, "}{\n", String2, "}\n"], "", String).
