% load the different parsing "modules"
:-  consult('parse_formulas.pl'), 
    consult('parse_justifications.pl'),
    consult('parse_citations.pl').

% don't display escape sequences when printing
:- set_prolog_flag(answer_write_options,
                    [ quoted(true),
                      portray(true),
                      spacing(next_argument),
                      character_escapes(false)
                    ]).

% return the code for one line in String
oneLine(Line, String) :-
    Line = line(N, Formula, Justification, Citation),
    stringFormula(Formula, F),
    stringJust(Justification, J),
    stringCit(Citation, C),
    atomics_to_string(["    & ", N, ". ", F, " & ", J, C], "", String).

% base case for building the last premise
buildPremises([H|T], T, Build, String) :-
    oneLine(H, Line),
    atomics_to_string([Build, Line, "\n"], "", String),
    T = [line(_, _, Just, _)|_],
    Just \= premise, !.

% recursive case for building premises
buildPremises([H|T], Rest, Build, String) :-
    oneLine(H, Line),
    atomics_to_string([Build, Line, " \\\\ \n"], "", String1),
    buildPremises(T, Rest, String1, String).

% base case for building normal lines
buildLines([H|[]], Build, String) :-
    oneLine(H, Line),
    atomics_to_string([Build, Line, "\n"], "", String), !.

% recursive case for building normal lines
buildLines([H|T], Build, String) :-
    oneLine(H, Line),
    atomics_to_string([Build, Line, " \\\\ \n"], "", String1),
    buildLines(T, String1, String).

buildProof(Lines, String) :-
    buildPremises(Lines, Rest, "", String1),
    buildLines(Rest, "", String2),
    atomics_to_string(["\n\\fitch{\n", String1, "}{\n", String2, "}\n"], "", String).
