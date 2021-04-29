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
    writeln('q13: '), q13(_13), writelines(_13), nl,
    writeln('q14: '), q14(_14), writelines(_14), nl,
    writeln('q15: '), q15(_15), writelines(_15), nl,
    writeln('q16: '), q16(_16), writelines(_16), nl,
    writeln('q17: '), q17(_17), writelines(_17), nl,
    halt(0).

writelines([]).

writelines([H|T]) :-
    H = line(N, A, J),
    write(N), tab(2), write(A), tab(4), write(J), nl,
    writelines(T).

q1(X) :-                                    % needs total 3 lines
    Premises = [line(1, and(p, q), premise)],
    Concl = line(_, or(p,q), _),
    provesWrap(Premises, Concl, X).

q2(X) :-                                    % needs total 3 lines
    Premises = [line(1, and(p, q), premise),
                line(2, if(p, r), premise)],
    Concl = line(_, r, _),
    provesWrap(Premises, Concl, X).

q3(X) :-                                    % needs total 5 lines
    Premises = [line(1, p, premise),
                line(2, q, premise), 
                line(3, r, premise)],
    Concl = line(_, and(and(p, q), r), _),
    provesWrap(Premises, Concl, X).

q4(X) :-                                    % needs total 7 lines
    Premises = [line(1, and(p, q), premise)],
    Concl = line(_, and(and(q, and(p, p)), or(p, p)), _),
    provesWrap(Premises, Concl, X).

q5(X) :-                                    % needs total 5 lines
    Premises = [line(1, and(p, q), premise)],
    Concl = line(_, and(q, or(r, p)), _),
    provesWrap(Premises, Concl, X).

q6(X) :-                                    % needs total 4 lines
    Premises = [line(1, and(p, q), premise)],
    Concl = line(_, and(p, or(p, q)), _),
    provesWrap(Premises, Concl, X).

q7(X) :-                                    % needs total 4 lines
    Premises = [line(1, and(p, q), premise)],
    Concl = line(_, and(or(p, q), p), _),
    provesWrap(Premises, Concl, X).

q8(X) :-                                    % needs total 7 lines
    Premises = [line(1, p, premise),
                line(2, q, premise),
                line(3, r, premise),
                line(4, s, premise)],
    Concl = line(_, and(and(and(p, q), r), s), _),
    provesWrap(Premises, Concl, X).

q9(X) :-                                    % needs total 5 lines
    Premises = [line(1, iff(p, q), premise),
                line(2, if(q, r), premise), 
                line(3, p, premise)],
    Concl = line(_, r, _),
    provesWrap(Premises, Concl, X).

q10(X) :-                                   % needs total 4 lines
    Premises = [line(1, p, premise),
                line(2, neg(p), premise)],
    Concl = line(_, q, _),
    provesWrap(Premises, Concl, X).

q11(X) :-                                   % needs total 6 lines
    Premises = [line(1, and(and(and(and(and(p, q), r), s), t), u), premise)],
    Concl = line(_, p, _),
    provesWrap(Premises, Concl, X).

q12(X) :-                                   % needs total 2 lines
    Premises = [line(1, p, premise)],
    Concl = line(_, p, _),
    provesWrap(Premises, Concl, X).

q13(X) :-                                   % needs total 7 lines
    Premises = [line(1, and(b, c), premise),
                line(2, neg(a), premise),
                line(3, if(neg(a), neg(c)), premise)],
    Concl = line(_, neg(b), _),
    provesWrap(Premises, Concl, X).

q14(X) :-                                   % needs total 3 lines
    Premises = [line(1, b, premise),
                line(2, neg(b), premise)],
    Concl = line(_, or(b, neg(b)), _),
    provesWrap(Premises, Concl, X).

q15(X) :-                                   % needs total 4 lines
    Premises = [line(1, b, premise),
                line(2, neg(b), premise)],
    Concl = line(_, and(b, or(b, neg(b))), _),
    provesWrap(Premises, Concl, X).

q16(X) :-                                   % needs total 9 lines
    Premises = [line(1, if(a, b), premise),
                line(2, neg(and(c, b)), premise),
                line(3, and(a, c), premise)],
    Concl = line(_, neg(and(a, c)), _),
    provesWrap(Premises, Concl, X).

q17(X) :-                                   % needs total 8 lines
    Premises = [line(1, and(a, b), premise),
                line(2, and(if(b, c), if(c, d)), premise)],
    Concl = line(_, or(d, f), _),
    provesWrap(Premises, Concl, X).
