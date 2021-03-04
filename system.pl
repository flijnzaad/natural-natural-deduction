%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 NATURAL NATURAL DEDUCTION THEOREM PROVER                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% by Flip Lijnzaad %
%   version 0.2    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: possibly add more information to the predicate?
%       that will be necessary anyways upon introduction of subproofs.
% TODO: maybe it would make more sense to have the operator names uniform
%       with the justification names; maybe it doesn't matter that much.
% TODO: somehow keep track of the line numbers: maybe use a list (see email
%       Malvin)
% TODO: interesting: querying provable(N, or(p, r), Justification) gives
%       a stack overflow (:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The provable/3 predicate has the following arguments:
% 1) the line number of the proof;
% 2) the formula in question, which is built up from the following:
%       * atomic constants p, q, r ...;
%       * special propositional atom 'contra' for contradiction (\bot);
%       * unary operator:   not(_);
%       * binary operators: and(_, _),
%                           or(_, _),
%                           imp(_, _),
%                           biimp(_, _);
% 3) the justification for that formula, with choice from:
%       * [conj|disj|neg|imp|biimp][Intro|Elim]
%       * premise
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The premises need to be asserted into the database
provable(1, and(p, q), premise).
% The conclusion needs to be queried by the user like so:
% provable(LineNr, Conclusion, Justification).

% "X is provable by conjunction elimination if there is a previous line 
% that contains a conjunction with X as its first conjunct"
provable(Current, X, conjElim) :-
    % but also you want to have some way to determine the exact line numbers
    Current > Previous,
    provable(Previous, and(X, _), _).

% commutativity of and: and(X, Y) <=> and(Y, X)
provable(Current, X, conjElim) :-
    Current > Previous,
    provable(Previous, and(_, X), _).

% "A disjunction with X as its left disjunct is provable by 
% disjunction introduction if there is a previous line that contains X"
provable(Current, or(X, _), disjIntro) :-
    Current > Previous,
    provable(Previous, X, _).

% commutativity of or: or(X, Y) <=> or(Y, X)
provable(Current, or(_, X), disjIntro) :-
    Current > Previous,
    provable(Previous, X, _).

% "X is provable by negation elimination if there is a previous line
% that contains the twice negated version of X"
provable(Current, X, negElim) :-
    Current > Previous,
    provable(Previous, not(not(X)), _).

% "A conjunction of X and Y is provable by conjunction introduction 
% if there is a previous line that contains the first conjunct and
% a previous line that contains the second conjunct"
provable(Current, and(X, Y), conjIntro) :-
    Current > Previous1,
    Current > Previous2,
    provable(Previous1, X, _),
    provable(Previous2, Y, _).
