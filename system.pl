%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 NATURAL NATURAL DEDUCTION THEOREM PROVER                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% by Flip Lijnzaad %
%   version 1.2    %
%%%%%%%%%%%%%%%%%%%%

% TODO: add line number support
% TODO: see https://staff.fnwi.uva.nl/u.endriss/teaching/prolog/prolog.pdf
% page 43 for maybe defining infix operators for things

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

proves(Premises, _, _, D) :-
    % bound the number of proof lines
    length(Premises, N),
    N > D, !,
    write('D = '), write(D), writeln('; depth exceeded, backtrack'),
    tab(7), write('Premises = '), writeln(Premises),
    fail.

% base case for iterative deepening: if maximum search depth reached,
% cut the other branches and evaluate to false to force backtracking
proves(_, _, _, D) :-
    D >= 5, !, fail.

% transitivity:
proves(Premises, line(X, JustX), End, D) :-
    % bound the number of proof lines
    length(Premises, N),
    N =< D,
    % derive 1 line from the premises
    proves(Premises, line(_, _), New, D),
    % with this step added to the premises, derive line X
    proves(New, line(X, JustX), End, D), !.

% recursive case for iterative deepening
proves(Premises, Line, New, D) :-
    Dnew is D + 1,
    write('D = '), writeln(Dnew),
    write('Premises deep:  '), writeln(Premises),
    onlyPremises(Premises, P),
    proves(P, Line, New, Dnew).

% provesWrap/3 reverses the premises,
% then calls proves/3 to do the proving,
% then reverses the final resulting proof in the end
provesWrap(Premises, Conclusion, X) :-
    reverse(Premises, P),
    length(Premises, N),
    proves(P, Conclusion, Y, N),
    reverse(Y, X).

% if you don't have any lines left, you're done
onlyPremises([], R, R).

% a line that's not a premise shouldn't be included; then you're done
onlyPremises([line(_, J)|_], R, R) :-
    J \= premise.

% add each premise to the list A
onlyPremises([line(X, premise)|T], A, R) :-
    onlyPremises(T, [line(X, premise)|A], R).

onlyPremises(Premises, Result) :-
    % get the `normal' order, with the premises at the start
    reverse(Premises, P),
    onlyPremises(P, [], Result), !.
