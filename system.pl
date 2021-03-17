%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 NATURAL NATURAL DEDUCTION THEOREM PROVER                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% by Flip Lijnzaad %
%   version 0.9    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: add the list of all previous lines to the predicate
% TODO: forward and backward search
% TODO: add a cut to the rule bodies but justify it theoretically
% TODO: needs better line number support: more flexibility
% TODO: how to get rid of lines that turned out to be unnecessary in the proof?
%       will that be a problem at all?
% TODO: support for con- and disjunctions with more than 2 con-/disjuncts

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
% 4) the line numbers that need to be cited:
%       * 0 if the line is a premise (of a subproof)
%       * just the number if only 1 citation
%       * two(x, y) if two steps x, y need to be cited
%       * sub(x, y) if a subproof x - y needs to be cited
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The premises need to be asserted into the database by the user
:- dynamic provable/4.
provable(1, and(p, q), premise, 0).
% The conclusion needs to be queried by the user like so:
% provable(LineNr, Conclusion, Justification, _).

% "X is provable by conjunction elimination if there is a previous line 
% that contains a conjunction with X as its first conjunct"
% provable(Current, X, conjElim, [H|T]) :-
provable(Current, X, conjElim, Previous) :-
    X \= and(_, _),
    Current > 0,
    Previous is Current - 1,
    Previous > 0,
    % H = provable(Previous, and(X, _), _),
    provable(Previous, and(X, Y), _, _), nonvar(Y), !.

% commutativity of and: and(X, Y) <=> and(Y, X)
provable(Current, X, conjElim, Previous) :-
    X \= and(_, _),
    Current > 0,
    Previous is Current - 1,
    Previous > 0,
    provable(Previous, and(Y, X), _, _), nonvar(Y), !.

% "A disjunction with X as its left disjunct is provable by 
% disjunction introduction if there is a previous line that contains X"
provable(Current, or(X, _), disjIntro, Previous) :-
    % Current > Previous,
    Current > 0,
    Previous is Current -1,
    Previous > 0,
    provable(Previous, X, _, _), !.

% commutativity of or: or(X, Y) <=> or(Y, X)
provable(Current, or(_, X), disjIntro, Previous) :-
    % Current > Previous,
    Current > 0,
    Previous is Current - 1,
    Previous > 0,
    provable(Previous, X, _, _), !.

% "X is provable by negation elimination if there is a previous line
% that contains the twice negated version of X"
provable(Current, X, negElim, Previous) :-
    % Current > Previous,
    Current > 0,
    Previous is Current - 1,
    Previous > 0,
    provable(Previous, not(not(X)), _, _), !.

% "A conjunction of X and Y is provable by conjunction introduction 
% if there is a previous line that contains the first conjunct and
% a previous line that contains the second conjunct"
provable(Current, and(X, Y), conjIntro, two(Previous1, Previous2)) :-
    Previous1 is Current - 2,
    Previous2 is Current - 1,
    % Current > Previous1,
    % Current > Previous2,
    provable(Previous1, X, _, _),
    provable(Previous2, Y, _, _).

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
