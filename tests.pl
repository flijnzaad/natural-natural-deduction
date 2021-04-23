#!/usr/bin/swipl -f

:- set_prolog_flag(verbose, silent).
:- initialization main.

main :-
    consult('system.pl'),
    writeln('q1: '), q1(_1), writelines(_1), nl,
    writeln('q2: '), q2(_2), writelines(_2), nl,
    writeln('q3: '), q3(_3), writelines(_3), nl,
    writeln('q4: '), q4(_4), writelines(_4), nl,
    writeln('q5: '), q5(_5), writelines(_5), nl,
    writeln('q6: '), q6(_6), writelines(_6), nl,
    writeln('q7: '), q7(_7), writelines(_7), nl,
    writeln('q8: '), q8(_8), writelines(_8), nl,
    writeln('q9: '), q9(_9), writelines(_9), nl,
    writeln('q10: '), q10(_10), writelines(_10), nl,
    writeln('q11: '), q11(_11), writelines(_11), nl,
    writeln('q12: '), q12(_12), writelines(_12), nl,
    halt(0).

writelines([]).

writelines([H|T]) :-
    H = line(A, J),
    write(A), tab(4), write(J), nl,
    writelines(T).

q1(X) :-                                    % needs total 3 lines
    Premises = [line(and(p, q), premise)],
    Concl = line(or(p,q), _),
    provesWrap(Premises, Concl, X).

q2(X) :-                                    % needs total 3 lines
    Premises = [line(and(p, q), premise), line(if(p, r), premise)],
    Concl = line(r, _),
    provesWrap(Premises, Concl, X).

q3(X) :-                                    % needs total 5 lines
    Premises = [line(p, premise), line(q, premise), line(r, premise)],
    Concl = line(and(and(p, q), r), _),
    provesWrap(Premises, Concl, X).

q4(X) :-                                    % needs total 7 lines
    Premises = [line(and(p, q), premise)],
    Concl = line(and(and(q, and(p, p)), or(p, p)), _),
    provesWrap(Premises, Concl, X).

q5(X) :-                                    % needs total 5 lines
    Premises = [line(and(p, q), premise)],
    Concl = line(and(q, or(r, p)), _),
    provesWrap(Premises, Concl, X).

q6(X) :-                                    % needs total 5 lines
    Premises = [line(and(p, q), premise)],
    Concl = line(and(p, or(p, q)), _),
    provesWrap(Premises, Concl, X).

q7(X) :-                                    % needs total 4 lines
    Premises = [line(and(p, q), premise)],
    Concl = line(and(or(p, q), p), _),
    provesWrap(Premises, Concl, X).

q8(X) :-                                    % needs total 7 lines
    Premises = [line(p, premise), line(q, premise), line(r, premise), line(s, premise)],
    Concl = line(and(and(and(p, q), r), s), _),
    provesWrap(Premises, Concl, X).

q9(X) :-                                    % needs total 5 lines
    Premises = [line(iff(p, q), premise), line(if(q, r), premise), line(p, premise)],
    Concl = line(r, _),
    provesWrap(Premises, Concl, X).

q10(X) :-                                   % needs total 4 lines
    Premises = [line(p, premise), line(neg(p), premise)],
    Concl = line(q, _),
    provesWrap(Premises, Concl, X).

q11(X) :-
    Premises = [line(and(and(and(and(and(p, q), r), s), t), u), premise)],
    Concl = line(p, _),
    provesWrap(Premises, Concl, X).

q12(X) :-
    Premises = [line(p, premise)],
    Concl = line(p, _),
    provesWrap(Premises, Concl, X).
