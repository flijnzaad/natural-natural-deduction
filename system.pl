%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 NATURAL NATURAL DEDUCTION THEOREM PROVER                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% by Flip Lijnzaad %
%   version 0.17   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: add the list of all previous lines to the predicate
%       --> FIXME: make it better, this implementation doesn't really work
% TODO: add a cut to the rule bodies but justify it theoretically
% TODO: how to get rid of lines that turned out to be unnecessary in the proof?
%       will that be a problem at all?
% TODO: add line number support

% FIXME: q3-7 always go into infinite recursion, no matter the bound: why?
%        --> only when the reverse/2 at the end is included; else only q4.
%        when reverse/2 is included, the conclusion and all needed proof lines
%        are in proofs.txt, but the program never exits recursion.
% FIXME: q4 always goes into infinite recursion: or(p, p) is never introduced,
%        only "higher-level" disjunctions are present

% proves(X, Y) where X is a list of previous proof lines and Y is a formula
% that can be proven from X
% line(X, Y) where X is the formula on the line, Y is the justification

% conjunction elimination:
proves(Premises, line(X, conjElim), _) :-
    member(line(and(X,_), _), Premises).

proves(Premises, line(Y, conjElim), _) :-
    member(line(and(_,Y), _), Premises).

% conjunction introduction:
proves(Premises, line(and(X,Y), conjIntro), _) :-
    member(line(X, _), Premises),
    member(line(Y, _), Premises).

% disjunction introduction:
proves(Premises, line(or(X, _), disjIntro), _) :-
    member(line(X, _), Premises).

proves(Premises, line(or(_, Y), disjIntro), _) :-
    member(line(Y, _), Premises).

% implication elimination:
proves(Premises, line(Y, impElim), _) :-
    member(line(if(X, Y), _), Premises),
    member(line(X, _), Premises).

% bi-implication elimination:
proves(Premises, line(Y, biimpElim), _) :-
    member(line(iff(X, Y), _), Premises),
    member(line(X, _), Premises).

proves(Premises, line(X, biimpElim), _) :-
    member(line(iff(X, Y), _), Premises),
    member(line(Y, _), Premises).

% negation elimination:
proves(Premises, line(X, negElim), _) :-
    member(line(neg(neg(X)), _), Premises).

% contradiction introduction:
proves(Premises, line(contra, contraIntro), _) :-
    member(line(X, _), Premises),
    member(line(neg(X), _), Premises).

% transitivity: => recursion
proves(Premises, line(X, JustX), All) :-
    length(Premises, N),
    N < 8,                               % bound the number of proof steps
    proves(Premises, line(Y, JustY), All),
    \+ member(line(Y, _), Premises),     % don't prove lines you already have
    New = [line(Y, JustY)|Premises],
    proves(New, line(X, JustX), All), !,
    printline(N, line(Y, JustY)),
    printline(N, line(X, JustX)),
    Newer = [line(X, JustX)|New],
    reverse(Newer, All).
    % writeln(All).

% reiteration / stop when goal reached:
proves(Premises, line(X, reit), _) :-
    member(line(X, _), Premises).

% contradiction elimination:
proves(Premises, line(_, contraElim), _) :-
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

provesWrap(Premises, Conclusion, [], X) :-
    proves(Premises, Conclusion, X).

provesWrap(Premises, Conclusion, [H|T], X) :-
    length(Premises, N),
    printline(N, H),
    provesWrap(Premises, Conclusion, T, X).

q1(X) :-                                    % needs total 3 lines
    Premises = [line(and(p, q), premise)], 
    Concl = line(or(p,q), _), 
    provesWrap(Premises, Concl, Premises, X).

q2(X) :-                                    % needs total 3 lines
    Premise = [line(and(p, q), premise), line(if(p, r), premise)], 
    Concl = line(r, _), 
    reverse(Premise, Premises),
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

