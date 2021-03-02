%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 NATURAL NATURAL DEDUCTION THEOREM PROVER                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% by Flip Lijnzaad %
%   version 0.1    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: fix the arithmetic of the line numbers
% TODO: possibly add more information to the predicate?
%       that will be necessary anyways upon introduction of subproofs.
% TODO: probably need extra rules for commutativity of conjunction 
%       and disjunction; will need to test that
% TODO: maybe it would make more sense to have the operator names uniform
%       with the justification names; maybe it doesn't matter that much.
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
% The conclusion needs to be queried by the user
provable(LineNr, p, Justification).

% "X is provable by conjunction elimination if there is a previous line 
% that contains a conjunction with X as its first conjunct"
provable(N, X, conjElim) :-
    N is N+1,
    % just that N has to be lower than New, but also you want to have some
    % way to determine the exact line numbers
    provable(New, and(X, _), _).

% "A disjunction with X as its left disjunct is provable by 
% disjunction introduction if there is a previous line that contains X"
provable(N, or(X, _), disjIntro) :-
    N is N+1,
    provable(New, X, _).

% "X is provable by negation elimination if there is a previous line
% that contains the twice negated version of X"
provable(N, X, negElim) :-
    N is N+1,
    provable(New, not(not(X)), _).

% "A conjunction of X and Y is provable by conjunction introduction 
% if there is a previous line that contains the first conjunct and
% a previous line that contains the second conjunct"
provable(N, and(X, Y), conjIntro) :-
    N is N+1,
    provable(New, X, _),
    provable(New2, Y, _).
