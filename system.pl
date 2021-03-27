%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 NATURAL NATURAL DEDUCTION THEOREM PROVER                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% by Flip Lijnzaad %
%   version 0.15   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: add the list of all previous lines to the predicate
% TODO: forward and backward search
% TODO: add a cut to the rule bodies but justify it theoretically
% TODO: how to get rid of lines that turned out to be unnecessary in the proof?
%       will that be a problem at all?
% TODO: add line number support

% Current problems:
%     * some of the lines in premises have uninstantiated variables in them
%     * q4 always goes into infinite recursion, no matter the bound: why?
%     * try to make some more complex queries to check the infinite recursion

% proves(X, Y) where X is a list of previous proof lines and Y is a formula
% that can be proven from X
% line(X, Y) where X is the formula on the line, Y is the justification

% conjunction elimination:
proves(Premises, Line) :-
    Line = line(X, conjElim),
    member(line(and(X,_), _), Premises).

proves(Premises, Line) :-
    Line = line(Y, conjElim),
    member(line(and(_,Y), _), Premises).

% conjunction introduction:
proves(Premises, Line) :-
    Line = line(and(X,Y), conjIntro),
    member(line(X, _), Premises),
    member(line(Y, _), Premises).

% disjunction introduction:
proves(Premises, Line) :-
    Line = line(or(X, _), disjIntro),
    member(line(X, _), Premises).

proves(Premises, Line) :-
    Line = line(or(_, X), disjIntro),
    member(line(X, _), Premises).

% implication elimination:
proves(Premises, Line) :-
    Line = line(Y, impElim),
    member(line(if(X, Y), _), Premises),
    member(line(X, _), Premises).

% bi-implication elimination:
proves(Premises, Line) :-
    Line = line(Y, biimpElim),
    member(line(iff(X, Y), _), Premises),
    member(line(X, _), Premises).

proves(Premises, Line) :-
    Line = line(X, biimpElim),
    member(line(iff(X, Y), _), Premises),
    member(line(Y, _), Premises).

% negation elimination:
proves(Premises, Line) :-
    Line = line(X, negElim),
    member(line(neg(neg(X)), _), Premises).

% contradiction introduction:
proves(Premises, Line) :-
    Line = line(contra, contraIntro),
    member(line(X, _), Premises),
    member(line(neg(X), _), Premises).

% transitivity: => recursion
proves(Premises, LineX) :-
    length(Premises, N),
    N < 2,                               % bound the number of proof steps
    LineX = line(X, JustX),
    LineY = line(Y, JustY),
    proves(Premises, LineY),
    \+ member(line(Y, _), Premises),     % don't prove lines you already have
    printline(Premises, LineY),
    proves([LineY|Premises], LineX),
    printline(Premises, LineX).

% reiteration / stop when goal reached:
proves(Premises, Line) :-
    Line = line(X, reit),
    member(line(X, _), Premises).

% contradiction elimination:
proves(Premises, Line) :-
    Line = line(_, contraElim),
    member(line(contra, _), Premises).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

printline(Premises, Line) :-
    Line = line(Formula, Justification),
    open('proofs.txt', append, Stream),
    length(Premises, N),
    M is N + 1,
    write(Stream, M), tab(Stream, 2),
    write(Stream, Formula),
    nl(Stream), tab(Stream, 24),
    write(Stream, Justification),
    nl(Stream),
    close(Stream).

provesWrap(Premises, Conclusion, []) :-
    proves(Premises, Conclusion).

provesWrap(Premises, Conclusion, [H|T]) :-
    printline(Premises, H),
    provesWrap(Premises, Conclusion, T).

q1 :-
    Premises = [line(and(p, q), premise)], 
    Concl = line(or(p,q), _), 
    provesWrap(Premises, Concl, Premises).

q2 :-
    Premises = [line(and(p, q), premise), line(if(p, r), premise)], 
    Concl = line(r, _), 
    provesWrap(Premises, Concl, Premises).

q3 :-
    Premises = [line(p, premise), line(q, premise), line(r, premise)],
    Concl = line(and(and(p, q), r), _),
    provesWrap(Premises, Concl, Premises).

q4 :-
    Premises = [line(and(p, q), premise)],
    Concl = line(and(and(q, and(p, p)), or(r, p)), _),
    provesWrap(Premises, Concl, Premises).

