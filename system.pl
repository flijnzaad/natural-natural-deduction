%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 NATURAL NATURAL DEDUCTION THEOREM PROVER                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% by Flip Lijnzaad %
%   version 0.4    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: possibly add more information to the predicate?
%       that will be necessary anyways upon introduction of subproofs.
% TODO: somehow keep track of the line numbers: maybe use a list to keep track
%       of all previous proof steps (see email Malvin)
% TODO: interesting: querying provable(N, or(p, r), Justification) gives
%       a stack overflow (:
% TODO: add citation step numbers to the predicate
% TODO: add the list of all previous lines to the predicate
% TODO: add a cut to the rule bodies but justify it theoretically

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
% 4) the line numbers that need to be cited:
%       * 0 if the line is a premise (of a subproof)
%       * just the number if only 1 citation
%       * two(x, y) if two steps x, y need to be cited
%       * sub(x, y) if a subproof x - y needs to be cited
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The premises need to be asserted into the database
:- dynamic provable/4.
provable(1, and(p, q), premise, 0).
% The conclusion needs to be queried by the user like so:
% provable(LineNr, Conclusion, Justification, _).

% "X is provable by conjunction elimination if there is a previous line 
% that contains a conjunction with X as its first conjunct"
% provable(Current, X, conjElim, [H|T]) :-
provable(Current, X, conjElim, Previous) :-
    Current > 0,
    Previous is Current - 1,
    Previous > 0,
    % H = provable(Previous, and(X, _), _),
    provable(Previous, and(X, Y), _, _), !, nonvar(Y), !.

% commutativity of and: and(X, Y) <=> and(Y, X)
provable(Current, X, conjElim, Previous) :-
    % Current > Previous,
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

% turning the predicate around
:- dynamic derive/3.
% conclusion
derive(_, and(p, q), _).
% query the premises

derive(Previous, and(X, _), _) :-
    Current is Previous + 1,
    derive(Current, X, conjElim), !.

% same problem as with provable: this rule can go on forever
derive(Previous, X, _) :-
    Current is Previous + 1,
    derive(Current, or(X, _), disjIntro), !.

derive(_, X, _) :-
    derive(Previous2, Y, _),
    Current is Previous2 + 1,
    derive(Current, and(X, Y), conjIntro), !.

% problem here: a Prolog rule can only have one predicate as its rule head
