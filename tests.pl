#!/usr/bin/swipl -f

:- set_prolog_flag(verbose, silent).
:- initialization main.

main :-
    consult('system.pl'),
    q1(X), writeln(X),
    q2(Y), writeln(Y),
    halt(0).

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
