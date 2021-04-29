:- set_prolog_flag(character_escapes, off).
:- set_prolog_flag(answer_write_options,
                    [ quoted(false),
                      portray(true),
                      spacing(next_argument)
                    ]).

stringCon("conj", "\land").
stringCon("disj", "\lor").
stringCon("neg", "\lnot").
stringCon("imp", "\lif").
stringCon("biimp", "\liff").
stringCon("contra", "\lfalse").

stringJust(premise, "") :- !.
stringJust(reit, "Reit") :- !.

stringJust(Justification, String) :-
    sub_string(Justification, _, 5, 0, "Intro"), !,
    sub_string(Justification, 0, _, 5, Connective),
    stringCon(Connective, C),
    atomics_to_string([C, "Intro"], " ", String).

stringJust(Justification, String) :-
    sub_string(Justification, _, 4, 0, "Elim"), !,
    sub_string(Justification, 0, _, 4, Connective),
    stringCon(Connective, C),
    atomics_to_string([C, "Elim"], " ", String).
