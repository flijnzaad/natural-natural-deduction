%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 NATURAL NATURAL DEDUCTION THEOREM PROVER                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% by Flip Lijnzaad %
%   version 0.22   %
%%%%%%%%%%%%%%%%%%%%

% TODO: implement iterative deepening
% TODO: add more cuts to the rule bodies but justify it theoretically:
%       right now it lets you take another option
% TODO: add line number support

% FIXME: q4 returns false: why?
% FIXME: q11 already returns true at N < 3 which results in a wrong proof, 
%        with lines missing
% FIXME: add more testing queries that are more elaborate (maybe substitute some,
%        because some of the current ones are nearly identical, keep the hardest
%        ones)

% This makes sure that answers are never abbreviated with "..."
:- set_prolog_flag(answer_write_options,
                    [ quoted(true),
                      portray(true),
                      spacing(next_argument)
                    ]).

% conjunction elimination:
proves(Premises, line(X, conjElim), [line(X, conjElim)|Premises]) :-
    member(line(and(X,_), _), Premises).

proves(Premises, line(Y, conjElim), [line(Y, conjElim)|Premises]) :-
    member(line(and(_,Y), _), Premises).

% conjunction introduction:
proves(Premises, line(and(X, Y), conjIntro), [line(and(X,Y), conjIntro)|Premises]) :-
    member(line(X, _), Premises),
    member(line(Y, _), Premises).

% disjunction introduction:
proves(Premises, line(or(X, Y), disjIntro), [line(or(X, Y), disjIntro)|Premises]) :-
    member(line(X, _), Premises).

proves(Premises, line(or(X, Y), disjIntro), [line(or(X, Y), disjIntro)|Premises]) :-
    member(line(Y, _), Premises).

% implication elimination:
proves(Premises, line(Y, impElim), [line(Y, impElim)|Premises]) :-
    member(line(if(X, Y), _), Premises),
    member(line(X, _), Premises).

% bi-implication elimination:
proves(Premises, line(Y, biimpElim), [line(Y, biimpElim)|Premises]) :-
    member(line(iff(X, Y), _), Premises),
    member(line(X, _), Premises).

proves(Premises, line(X, biimpElim), [line(X, biimpElim)|Premises]) :-
    member(line(iff(X, Y), _), Premises),
    member(line(Y, _), Premises).

% negation elimination:
proves(Premises, line(X, negElim), [line(X, negElim)|Premises]) :-
    member(line(neg(neg(X)), _), Premises).

% contradiction introduction:
proves(Premises, line(contra, contraIntro), [line(contra, contraIntro)|Premises]) :-
    member(line(X, _), Premises),
    member(line(neg(X), _), Premises).

% transitivity: => recursion
% End eventually contains the full proof
proves(Premises, line(X, JustX), End) :-
    % bound the number of proof lines
    length(Premises, N),
    N < 6,
    % this derives 1 step from the premises, matching the simple rules.
    % New will have the new line added to the Premises
    proves(Premises, line(Y, JustY), New),
    % don't prove lines you already have
    \+ member(line(Y, _), Premises),
    % this either matches with the base cases or goes into transitivity again
    proves(New, line(X, JustX), End), !,
    write('P: '), writeln(P),
    write('End: '), writeln(End),
    printline(N, line(Y, JustY)),
    printline(N, line(X, JustX)).

% reiteration / stop when goal reached:
proves(Premises, line(X, reit), [line(X, reit)|Premises]) :-
    member(line(X, _), Premises).

% contradiction elimination:
proves(Premises, line(X, contraElim), [line(X, contraElim)|Premises]) :-
    member(line(contra, _), Premises).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

printline(N, Line) :-
    Line = line(Formula, Justification),
    open('proofs.txt', append, Stream),
    write(Stream, N), tab(Stream, 2),
    write(Stream, Formula),
    nl(Stream), tab(Stream, 24),
    write(Stream, Justification),
    nl(Stream),
    close(Stream).

% provesWrap/4 takes care of printing the premises
% and then calls proves/3 to do the proving
provesWrap(Premises, Conclusion, [], X) :-
    reverse(Premises, P),
    proves(P, Conclusion, Y),
    reverse(Y, X).

provesWrap(Premises, Conclusion, [H|T], X) :-
    length(Premises, N),
    printline(N, H),
    provesWrap(Premises, Conclusion, T, X).

q1(X) :-                                    % needs total 3 lines
    Premises = [line(and(p, q), premise)], 
    Concl = line(or(p,q), _), 
    provesWrap(Premises, Concl, Premises, X).

q2(X) :-                                    % needs total 3 lines
    Premises = [line(and(p, q), premise), line(if(p, r), premise)], 
    Concl = line(r, _), 
    provesWrap(Premises, Concl, Premises, X).

q3(X) :-                                    % needs total 5 lines
    Premises = [line(p, premise), line(q, premise), line(r, premise)],
    Concl = line(and(and(p, q), r), _),
    provesWrap(Premises, Concl, Premises, X).

q4(X) :-                                    % needs total 7 lines
    Premises = [line(and(p, q), premise)],
    Concl = line(and(and(q, and(p, p)), or(p, p)), _),
    provesWrap(Premises, Concl, Premises, X).

q5(X) :-                                    % needs total 5 lines
    Premises = [line(and(p, q), premise)],
    Concl = line(and(q, or(r, p)), _),
    provesWrap(Premises, Concl, Premises, X).

q6(X) :-                                    % needs total 5 lines
    Premises = [line(and(p, q), premise)],
    Concl = line(and(p, or(p, q)), _),
    provesWrap(Premises, Concl, Premises, X).

q7(X) :-                                    % needs total 4 lines
    Premises = [line(and(p, q), premise)],
    Concl = line(and(or(p, q), p), _),
    provesWrap(Premises, Concl, Premises, X).

q8(X) :-                                    % needs total 7 lines
    Premises = [line(p, premise), line(q, premise), line(r, premise), line(s, premise)],
    Concl = line(and(and(and(p, q), r), s), _),
    provesWrap(Premises, Concl, Premises, X).

q9(X) :-                                    % needs total 5 lines
    Premises = [line(iff(p, q), premise), line(if(q, r), premise), line(p, premise)],
    Concl = line(r, _),
    provesWrap(Premises, Concl, Premises, X).

q10(X) :-                                   % needs total 4 lines
    Premises = [line(p, premise), line(neg(p), premise)],
    Concl = line(q, _),
    provesWrap(Premises, Concl, Premises, X).

q11(X) :-
    Premises = [line(and(and(and(and(and(p, q), r), s), t), u), premise)],
    Concl = line(p, _),
    provesWrap(Premises, Concl, Premises, X).

q12(X) :-
    Premises = [line(p, premise)],
    Concl = line(p, _),
    provesWrap(Premises, Concl, Premises, X).
