%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 NATURAL NATURAL DEDUCTION THEOREM PROVER                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% by Flip Lijnzaad %
%   version 1.1    %
%%%%%%%%%%%%%%%%%%%%

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
proves(Premises, line(X, conjElim), [line(X, conjElim)|Premises], _) :-
    member(line(and(X,_), _), Premises).

proves(Premises, line(Y, conjElim), [line(Y, conjElim)|Premises], _) :-
    member(line(and(_,Y), _), Premises).

% conjunction introduction:
proves(Premises, line(and(X, Y), conjIntro), [line(and(X,Y), conjIntro)|Premises], _) :-
    member(line(X, _), Premises),
    member(line(Y, _), Premises).

% disjunction introduction:
proves(Premises, line(or(X, Y), disjIntro), [line(or(X, Y), disjIntro)|Premises], _) :-
    member(line(X, _), Premises).

proves(Premises, line(or(X, Y), disjIntro), [line(or(X, Y), disjIntro)|Premises], _) :-
    member(line(Y, _), Premises).

% implication elimination:
proves(Premises, line(Y, impElim), [line(Y, impElim)|Premises], _) :-
    member(line(if(X, Y), _), Premises),
    member(line(X, _), Premises).

% bi-implication elimination:
proves(Premises, line(Y, biimpElim), [line(Y, biimpElim)|Premises], _) :-
    member(line(iff(X, Y), _), Premises),
    member(line(X, _), Premises).

proves(Premises, line(X, biimpElim), [line(X, biimpElim)|Premises], _) :-
    member(line(iff(X, Y), _), Premises),
    member(line(Y, _), Premises).

% negation elimination:
proves(Premises, line(X, negElim), [line(X, negElim)|Premises], _) :-
    member(line(neg(neg(X)), _), Premises).

% contradiction introduction:
proves(Premises, line(contra, contraIntro), [line(contra, contraIntro)|Premises], _) :-
    member(line(X, _), Premises),
    member(line(neg(X), _), Premises).

% contradiction elimination:
proves(Premises, line(X, contraElim), [line(X, contraElim)|Premises], _) :-
    member(line(contra, _), Premises).

% reiteration:
proves(Premises, line(X, reit), [line(X, reit)|Premises], _) :-
    member(line(X, _), Premises).

% base case for iterative deepening: if maximum search depth reached,
% cut the other branches and evaluate to false
proves(_, _, _, D) :-
    D >= 10, !, fail.

% transitivity:
proves(Premises, line(X, JustX), End, D) :-
    % bound the number of proof lines
    length(Premises, N),
    N < D,
    % derive 1 line from the premises
    proves(Premises, line(_, _), New, D),
    % with this step added to the premises, derive line X
    proves(New, line(X, JustX), End, D), !.

% recursive case for iterative deepening
proves(Premises, Line, New, D) :-
    Dnew is D + 1,
    write('D = '), writeln(Dnew),
    write('Premises: '), writeln(Premises),
    proves(Premises, Line, New, Dnew).

% provesWrap/3 takes care of reversing the premises,
% then calls proves/3 to do the proving,
% then reverses the final proof in the end
provesWrap(Premises, Conclusion, X) :-
    reverse(Premises, P),
    proves(P, Conclusion, Y, 1),
    reverse(Y, X).
