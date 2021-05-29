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
    Line = line(N, Formula, Justification, Citation), !,
    stringFormula(Formula, F),
    stringJust(Justification, J),
    stringCit(Citation, C),
    atomics_to_string(["    & ", N, ". ", F, " & ", J, C], "", String).

% build the subproof using buildProof
oneLine(Line, String) :-
    is_list(Line), !,
    buildProof(Line, String).

% base case for building empty premise: then next line is always subproof in PL
buildPremises([H|T], [H|T], Build, String) :-
    is_list(H), !,
    atomics_to_string([Build, "\n}{\n"], "", String).

% base case for building the last premise
% when the next line is a regular line
buildPremises([H|T], T, Build, String) :-
    T = [line(_, _, Just, _)|_],
    Just \= premise, !,
    oneLine(H, Line),
    atomics_to_string([Build, Line, "\n}{\n"], "", String).

% base case for building the last premise
% when the next line is a subproof
buildPremises(Lines, T, Build, String) :-
    Lines = [H|T],
    T = [Subproof|_],
    is_list(Subproof), !,
    oneLine(H, Line),
    atomics_to_string([Build, Line, "\n}{"], "", String).

% recursive case for building premises
buildPremises([H|T], Rest, Build, String) :-
    compound(H), !,
    oneLine(H, Line),
    atomics_to_string([Build, Line, " \\\\ \n"], "", String1),
    buildPremises(T, Rest, String1, String).

% base case for building normal lines
buildLines([H|[]], Build, String) :-
    oneLine(H, Line),
    atomics_to_string([Build, Line, "\n}\n"], "", String), !.

% recursive case for building normal lines
buildLines([H|T], Build, String) :-
    oneLine(H, Line),
    atomics_to_string([Build, Line, " \\\\ \n"], "", String1),
    buildLines(T, String1, String).

buildProof(Lines, String) :-
    buildPremises(Lines, Rest, "", String1), % start with empty string
    buildLines(Rest, "", String2),           % idem
    atomics_to_string(["\n\\fitch{\n", String1, String2], "", String).
