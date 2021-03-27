%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 NATURAL NATURAL DEDUCTION THEOREM PROVER                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% by Flip Lijnzaad %
%   version 0.16   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: add the list of all previous lines to the predicate
% TODO: forward and backward search
% TODO: add a cut to the rule bodies but justify it theoretically
% TODO: how to get rid of lines that turned out to be unnecessary in the proof?
%       will that be a problem at all?
% TODO: add line number support

% Current problems:
%     * q3-7 always go into infinite recursion, no matter the bound: why?

% proves(X, Y) where X is a list of previous proof lines and Y is a formula
% that can be proven from X
% line(X, Y) where X is the formula on the line, Y is the justification

% conjunction elimination:
proves(Premises, Line, _) :-
    Line = line(X, conjElim),
    member(line(and(X,_), _), Premises).

proves(Premises, Line, _) :-
    Line = line(Y, conjElim),
    member(line(and(_,Y), _), Premises).

% conjunction introduction:
proves(Premises, Line, _) :-
    Line = line(and(X,Y), conjIntro),
    member(line(X, _), Premises),
    member(line(Y, _), Premises).

% disjunction introduction:
proves(Premises, Line, _) :-
    Line = line(or(X, Y), disjIntro),
    nonvar(Y),
    member(line(X, _), Premises).

proves(Premises, Line, _) :-
    Line = line(or(X, Y), disjIntro),
    nonvar(X),
    member(line(Y, _), Premises).

% implication elimination:
proves(Premises, Line, _) :-
    Line = line(Y, impElim),
    member(line(if(X, Y), _), Premises),
    member(line(X, _), Premises).

% bi-implication elimination:
proves(Premises, Line, _) :-
    Line = line(Y, biimpElim),
    member(line(iff(X, Y), _), Premises),
    member(line(X, _), Premises).

proves(Premises, Line, _) :-
    Line = line(X, biimpElim),
    member(line(iff(X, Y), _), Premises),
    member(line(Y, _), Premises).

% negation elimination:
proves(Premises, Line, _) :-
    Line = line(X, negElim),
    member(line(neg(neg(X)), _), Premises).

% contradiction introduction:
proves(Premises, Line, _) :-
    Line = line(contra, contraIntro),
    member(line(X, _), Premises),
    member(line(neg(X), _), Premises).

% transitivity: => recursion
proves(Premises, LineX, All) :-
    length(Premises, N),
    N < 5,                               % bound the number of proof steps
    LineX = line(_, _),
    LineY = line(Y, _),
    proves(Premises, LineY, All),
    \+ member(line(Y, _), Premises),     % don't prove lines you already have
    New = [LineY|Premises],
    proves(New, LineX, All),
    printline(N, LineY),
    printline(N, LineX),
    Newer = [LineX|New],
    reverse(Newer, All).
    % write(All), nl.

% reiteration / stop when goal reached:
proves(Premises, Line, _) :-
    Line = line(X, reit),
    member(line(X, _), Premises).

% contradiction elimination:
proves(Premises, Line, _) :-
    Line = line(_, contraElim),
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

provesWrap(Premises, Conclusion, []) :-
    proves(Premises, Conclusion, []).

provesWrap(Premises, Conclusion, [H|T]) :-
    length(Premises, N),
    printline(N, H),
    provesWrap(Premises, Conclusion, T).

q1 :-
    Premises = [line(and(p, q), premise)], 
    Concl = line(or(p,q), _), 
    provesWrap(Premises, Concl, Premises).

q1(X) :-
    Premises = [line(and(p, q), premise)], 
    Concl = line(or(p,q), _), 
    proves(Premises, Concl, X).

q2 :-
    Premises = [line(and(p, q), premise), line(if(p, r), premise)], 
    Concl = line(r, _), 
    provesWrap(Premises, Concl, Premises).

q2(X) :-
    Premise = [line(and(p, q), premise), line(if(p, r), premise)], 
    Concl = line(r, _), 
    reverse(Premise, Premises),
    proves(Premises, Concl, X).

q3 :-
    Premises = [line(p, premise), line(q, premise), line(r, premise)],
    Concl = line(and(and(p, q), r), _),
    provesWrap(Premises, Concl, Premises).

q3(X) :-
    Premise = [line(p, premise), line(q, premise), line(r, premise)],
    Concl = line(and(and(p, q), r), _),
    reverse(Premise, Premises),
    proves(Premises, Concl, X).

q4 :-
    Premises = [line(and(p, q), premise)],
    Concl = line(and(and(q, and(p, p)), or(r, p)), _),
    provesWrap(Premises, Concl, Premises).

q4(X) :-
    Premises = [line(and(p, q), premise)],
    Concl = line(and(and(q, and(p, p)), or(r, p)), _),
    proves(Premises, Concl, X).

q5 :-
    Premises = [line(and(p, q), premise)],
    Concl = line(and(q, or(r, p)), _),
    provesWrap(Premises, Concl, Premises).

q5(X) :-
    Premises = [line(and(p, q), premise)],
    Concl = line(and(q, or(r, p)), _),
    proves(Premises, Concl, X).

q6 :-
    Premises = [line(and(p, q), premise)],
    Concl = line(and(p, or(p, q)), _),
    provesWrap(Premises, Concl, Premises).

q6(X) :-
    Premises = [line(and(p, q), premise)],
    Concl = line(and(p, or(p, q)), _),
    proves(Premises, Concl, X).

q7 :-
    Premises = [line(and(p, q), premise)],
    Concl = line(and(or(p, q), p), _),
    provesWrap(Premises, Concl, Premises).

q7(X) :-
    Premises = [line(and(p, q), premise)],
    Concl = line(and(or(p, q), p), _),
    proves(Premises, Concl, X).

q8(X) :-
    Premise = [line(p, premise), line(q, premise), line(r, premise), line(s, premise)],
    Concl = line(and(and(and(p, q), r), s), _),
    reverse(Premise, Premises),
    proves(Premises, Concl, X).

