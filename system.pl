% version 1.4

% This makes sure that answers are never abbreviated with "..."
:- set_prolog_flag(answer_write_options,
                    [ quoted(true),
                      portray(true),
                      spacing(next_argument)
                    ]).

% contradiction introduction:
proves(Premises, line(contra, contraIntro), [line(contra, contraIntro)|Premises], _) :-
    member(line(X, _), Premises),
    member(line(neg(X), _), Premises).

% contradiction elimination:
proves(Premises, line(X, contraElim), [line(X, contraElim)|Premises], _) :-
    member(line(contra, _), Premises).

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

% reiteration:
proves(Premises, line(X, reit), [line(X, reit)|Premises], _) :-
    member(line(X, _), Premises).

% transitivity:
proves(Premises, line(X, JustX), End, D) :-
    % don't exceed the current depth D
    length(Premises, N),
    N =< D,
    % derive 1 line from the premises
    proves(Premises, line(_, _), New, D),
    % with this step added to the premises, derive line X
    proves(New, line(X, JustX), End, D), !.

% try to prove Line at the current depth
provesIDS(Premises, Line, New, D) :-
    proves(Premises, Line, New, D), !.

% else do iterative deepening: increment the depth and try again
provesIDS(Premises, Line, New, D) :-
    Dnew is D + 1,
    % don't exceed the maximum proof length
    Dnew < 10,
    provesIDS(Premises, Line, New, Dnew).

% provesWrap/3 reverses the premises,
% then calls provesIDS/4 to do the proving,
% then reverses the final resulting proof in the end
provesWrap(Premises, Conclusion, X) :-
    reverse(Premises, P),
    % initial proof depth: number of premises
    length(Premises, N),
    provesIDS(P, Conclusion, Y, N),
    reverse(Y, X).
