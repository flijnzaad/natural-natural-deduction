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
    N < 3,
    % this derives 1 step from the premises, matching the simple rules.
    % New will have the new line added to the Premises
    proves(Premises, line(Y, JustY), New),
    % this either matches with the base cases or goes into transitivity again
    proves(New, line(X, JustX), End), !.

% reiteration / stop when goal reached:
proves(Premises, line(X, reit), [line(X, reit)|Premises]) :-
    member(line(X, _), Premises).

% contradiction elimination:
proves(Premises, line(X, contraElim), [line(X, contraElim)|Premises]) :-
    member(line(contra, _), Premises).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% provesWrap/3 takes care of reversing the premises,
% then calls proves/3 to do the proving,
% then reverses the final proof in the end
provesWrap(Premises, Conclusion, X) :-
    reverse(Premises, P),
    proves(P, Conclusion, Y),
    reverse(Y, X).
