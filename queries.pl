q1(X) :-                                    % needs total 3 lines
    Premises = [line(1, and(p, q), premise, 0)],
    Concl    = line(_, or(p,q), _, _),
    provesWrap(Premises, Concl, X).

q2(X) :-                                    % needs total 4 lines
    Premises = [line(1, and(p, q), premise, 0),
                line(2, if(p, r), premise, 0)],
    Concl    = line(_, r, _, _),
    provesWrap(Premises, Concl, X).

q3(X) :-                                    % needs total 5 lines
    Premises = [line(1, p, premise, 0),
                line(2, q, premise, 0), 
                line(3, r, premise, 0)],
    Concl    = line(_, and(and(p, q), r), _, _),
    provesWrap(Premises, Concl, X).

q4(X) :-                                    % needs total 7 lines
    Premises = [line(1, and(p, q), premise, 0)],
    Concl    = line(_, and(and(q, and(p, p)), or(p, p)), _, _),
    provesWrap(Premises, Concl, X).

q5(X) :-                                    % needs total 5 lines
    Premises = [line(1, and(p, q), premise, 0)],
    Concl    = line(_, and(q, or(r, p)), _, _),
    provesWrap(Premises, Concl, X).

q6(X) :-                                    % needs total 4 lines
    Premises = [line(1, and(p, q), premise, 0)],
    Concl    = line(_, and(p, or(p, q)), _, _),
    provesWrap(Premises, Concl, X).

q7(X) :-                                    % needs total 4 lines
    Premises = [line(1, and(p, q), premise, 0)],
    Concl    = line(_, and(or(p, q), p), _, _),
    provesWrap(Premises, Concl, X).

q8(X) :-                                    % needs total 7 lines
    Premises = [line(1, p, premise, 0),
                line(2, q, premise, 0),
                line(3, r, premise, 0),
                line(4, s, premise, 0)],
    Concl    = line(_, and(and(and(p, q), r), s), _, _),
    provesWrap(Premises, Concl, X).

q9(X) :-                                    % needs total 5 lines
    Premises = [line(1, iff(p, q), premise, 0),
                line(2, if(q, r), premise, 0), 
                line(3, p, premise, 0)],
    Concl    = line(_, r, _, _),
    provesWrap(Premises, Concl, X).

q10(X) :-                                   % needs total 4 lines
    Premises = [line(1, p, premise, 0),
                line(2, neg(p), premise, 0)],
    Concl    = line(_, q, _, _),
    provesWrap(Premises, Concl, X).

q11(X) :-                                   % needs total 6 lines
    Premises = [line(1, and(and(and(and(and(p, q), r), s), t), u), premise, 0)],
    Concl    = line(_, p, _, _),
    provesWrap(Premises, Concl, X).

q12(X) :-                                   % needs total 2 lines
    Premises = [line(1, p, premise, 0)],
    Concl    = line(_, p, _, _),
    provesWrap(Premises, Concl, X).

q13(X) :-                                   % needs total 7 lines
    Premises = [line(1, and(b, c), premise, 0),
                line(2, neg(a), premise, 0),
                line(3, if(neg(a), neg(c)), premise, 0)],
    Concl    = line(_, neg(b), _, _),
    provesWrap(Premises, Concl, X).

q14(X) :-                                   % needs total 3 lines
    Premises = [line(1, b, premise, 0),
                line(2, neg(b), premise, 0)],
    Concl    = line(_, or(b, neg(b)), _, _),
    provesWrap(Premises, Concl, X).

q15(X) :-                                   % needs total 4 lines
    Premises = [line(1, b, premise, 0),
                line(2, neg(b), premise, 0)],
    Concl    = line(_, and(b, or(b, neg(b))), _, _),
    provesWrap(Premises, Concl, X).

q16(X) :-                                   % needs total 9 lines
    Premises = [line(1, if(a, b), premise, 0),
                line(2, neg(and(c, b)), premise, 0),
                line(3, and(a, c), premise, 0)],
    Concl    = line(_, neg(and(a, c)), _, _),
    provesWrap(Premises, Concl, X).

q17(X) :-                                   % needs total 8 lines
    Premises = [line(1, and(a, b), premise, 0),
                line(2, and(if(b, c), if(c, d)), premise, 0)],
    Concl    = line(_, or(d, f), _, _),
    provesWrap(Premises, Concl, X).

q18(X) :-                                   % needs total 4 lines
    Premises = [line(1, q, premise, 0)],
    Concl    = line(_, if(p, q), _, _),
    provesWrap(Premises, Concl, X).

q19(X) :-                                   % needs total 6 lines
    Premises = [line(1, if(p, q), premise, 0),
                line(2, if(q, r), premise, 0)],
    Concl    = line(_, if(p, r), _, _),
    provesWrap(Premises, Concl, X).

q20(X) :-                                   % needs total 5 lines
    Premises = [line(1, if(or(p, q), r), premise, 0)],
    Concl    = line(_, if(p, r), _, _),
    provesWrap(Premises, Concl, X).

q21(X) :-                                   % needs total 10 lines
    Premises = [line(1, if(or(p, q), r), premise, 0)],
    Concl    = line(_, and(if(p, r), if(q, r)), _, _),
    provesWrap(Premises, Concl, X).

q22(X) :-                                   % needs total 4 lines
    Premises = [line(1, p, premise, 0)],
    Concl    = line(_, neg(neg(p)), _, _),
    provesWrap(Premises, Concl, X).

q23(X) :-                                   % needs total 3 lines
    Premises = [],
    Concl    = line(_, if(p, p), _, _),
    provesWrap(Premises, Concl, X).

q24(X) :-                                   % needs total 6 lines
    Premises = [line(1, or(a, a), premise, 0)],
    Concl    = line(_, a, _, _),
    provesWrap(Premises, Concl, X).

q25(X) :-                                   % needs total 5 lines
    Premises = [],
    Concl    = line(_, iff(a, a), _, _),
    provesWrap(Premises, Concl, X).

q26(X) :-                                   % needs total 8 lines
    Premises = [line(1, or(p, q), premise, 0),
                line(2, neg(p), premise, 0)],
    Concl    = line(_, q, _, _),
    provesWrap(Premises, Concl, X).

q27(X) :-                                   % needs total 9 lines
    Premises = [],
    Concl    = line(_, or(p, neg(p)), _, _),
    provesWrap(Premises, Concl, X).

q28(X) :-                                   % needs total 11 lines
    Premises = [],
    Concl    = line(_, iff(if(a, contra), if(a, neg(a))), _, _),
    provesWrap(Premises, Concl, X).

q29(X) :-                                   % needs total 7 lines
    Premises = [],
    Concl    = line(_, iff(iff(a, b), iff(b, a)), _, _),
    provesWrap(Premises, Concl, X).

q30(X) :-
    Premises = [line(1, if(a, contra), premise, 0)],
    Concl    = line(_, if(a, neg(a)), _, _),
    provesWrap(Premises, Concl, X).

q31(X) :-
    Premises = [line(1, if(a, neg(a)), premise, 0)],
    Concl    = line(_, if(a, contra), _, _),
    provesWrap(Premises, Concl, X).

q32(X) :-
    Premises = [line(1, if(neg(or(p, q)), p), premise, 0)],
    Concl    = line(_, or(p, q), _, _),
    provesWrap(Premises, Concl, X).

q33(X) :-
    Premises = [line(1, if(or(neg(p), q), p), premise, 0)],
    Concl    = line(_, p, _, _),
    provesWrap(Premises, Concl, X).

q34(X) :-
    Premises = [line(1, if(a, neg(a)), premise, 0),
                line(2, if(or(neg(a), b), c), premise, 0)],
    Concl    = line(_, c, _, _),
    provesWrap(Premises, Concl, X).

q35(X) :-
    Premises = [line(1, if(neg(b), neg(a)), premise, 0)],
    Concl    = line(_, if(a, b), _, _),
    provesWrap(Premises, Concl, X).

q36(X) :-
    Premises = [line(1, if(a, b), premise, 0)],
    Concl    = line(_, if(neg(b), neg(a)), _, _),
    provesWrap(Premises, Concl, X).

q37(X) :-
    Premises = [],
    Concl    = line(_, iff(if(neg(b), neg(a)), if(a, b)), _, _),
    provesWrap(Premises, Concl, X).

q38(X) :-
    Premises = [line(1, or(a, b), premise, 0),
                line(2, if(a, neg(c)), premise, 0)],
    Concl    = line(_, if(neg(b), neg(c)), _, _),
    provesWrap(Premises, Concl, X).
