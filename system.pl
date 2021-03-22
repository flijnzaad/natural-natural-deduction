%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 NATURAL NATURAL DEDUCTION THEOREM PROVER                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% by Flip Lijnzaad %
%   version 0.13   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: add the list of all previous lines to the predicate
% TODO: forward and backward search
% TODO: add a cut to the rule bodies but justify it theoretically
% TODO: how to get rid of lines that turned out to be unnecessary in the proof?
%       will that be a problem at all?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The provable/4 predicate has the following arguments:
% 1) the line number of the proof;
% 2) the formula in question, which is built up from the following:
%       * atomic constants p, q, r ...;
%       * special propositional atom 'contra' for contradiction (\bot);
%       * unary operator:   neg(_);         (not/1 is already predefined)
%       * binary operators: and(_, _),
%                           or(_, _),
%                           if(_, _),
%                           iff(_, _);
% 3) the justification for that formula, with choice from:
%       * [conj|disj|neg|imp|biimp|contra][Intro|Elim]
%       * premise
%       * reit
% 4) the line numbers that need to be cited:
%       * 0 if the line is a premise (of a subproof)
%       * just the number if only 1 citation
%       * two(x, y) if two steps x, y need to be cited
%       * sub(x, y) if a subproof x - y needs to be cited
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% problems of provFrom/2:
%   * no line number support
%   * no support for more than one premise

% provFrom(conclusion, premise) where each step is line(formula, justification)

% conjunction elimination: prove X from and(X, Y)
provFrom(line(X, conjElim), line(and(X, Y), _)) :-
    nonvar(Y),
    write(X),
    write(' by conjElim'), nl.

% conjunction elimination: prove X from and(Y, X) (commutativity)
provFrom(line(X, conjElim), line(and(Y, X), _)) :-
    nonvar(Y),
    write(X),
    write(' by conjElim'), nl.

% disjunction introduction: prove or(X, Y) from X
provFrom(line(or(X, Y), disjIntro), line(X, _)) :-
    nonvar(Y),
    write(X),
    write(' by disjIntro'), nl.

% disjunction introduction: prove or(Y, X) from X (commutativity)
provFrom(line(or(Y, X), disjIntro), line(X, _)) :-
    nonvar(Y),
    write(X),
    write(' by disjIntro'), nl.

% TODO: this rule sometimes causes infinite recursion: why, and how to solve?
%       it seems that it only gets into infinite recursion if the query does
%       so anyway; if you remove this rule, then it will end up in infinite
%       recursion in the transitive rule anyways.
provFrom(line(X, negElim), line(neg(neg(X)), _)).

% transitivity: X is provable from Z if X is provable from Y and Y is provable
% from Z
provFrom(X, Z) :-
    provFrom(X, Y),
    provFrom(Y, Z),
    writeln(Z).

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

% transitivity: => recursion
proves(Premises, LineX) :-
    LineX = line(X, JustX),
    LineY = line(Y, JustY),
    proves(Premises, LineY),
    printline(Y, JustY),
    \+ member(LineY, Premises),
    proves([LineY|Premises], LineX),
    printline(X, JustX).

% reiteration / stop when goal reached:
proves(Premises, Line) :-
    Line = line(X, reit),
    member(line(X, _), Premises).

printline(Formula, Justification) :-
    open('proofs.txt', append, Stream),
    write(Stream, Formula),
    nl(Stream), tab(Stream, 24),
    write(Stream, Justification),
    nl(Stream),
    close(Stream).

provesWrap(Premises, Conclusion, []) :-
    proves(Premises, Conclusion).

provesWrap(Premises, Conclusion, [H|T]) :-
    H = line(F, J),
    printline(F, J),
    provesWrap(Premises, Conclusion, T).

q1 :-
    Premises = [line(and(p, q), premise)], 
    Concl = line(or(p,q), _), 
    provesWrap(Premises, Concl, Premises).

q2 :-
    Premises = [line(and(p, q), premise), line(if(p, r), premise)], 
    Concl = line(r, _), 
    provesWrap(Premises, Concl, Premises).
