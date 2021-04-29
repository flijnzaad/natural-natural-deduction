% version 2.1

% This makes sure that answers are never abbreviated with "..."
:- set_prolog_flag(answer_write_options,
                    [ quoted(true),
                      portray(true),
                      spacing(next_argument)
                    ]).

currentLineNumber([], 0).

currentLineNumber(line(_, _, _), 1).

currentLineNumber([H|T], N) :-
    currentLineNumber(H, A),
    currentLineNumber(T, B),
    N is A + B.

nextLineNumber(L, N) :-
    currentLineNumber(L, Current),
    N is Current + 1.

% contradiction introduction:
proves(Premises, line(Next, contra, contraIntro), [line(Next, contra, contraIntro)|Premises], _) :-
    member(line(_, X, _), Premises),
    member(line(_, neg(X), _), Premises),
    nextLineNumber(Premises, Next).

% contradiction elimination:
proves(Premises, line(Next, X, contraElim), [line(Next, X, contraElim)|Premises], _) :-
    member(line(_, contra, _), Premises),
    nextLineNumber(Premises, Next).

% conjunction elimination:
proves(Premises, line(Next, X, conjElim), [line(Next, X, conjElim)|Premises], _) :-
    member(line(_, and(X,_), _), Premises),
    nextLineNumber(Premises, Next).

proves(Premises, line(Next, Y, conjElim), [line(Next, Y, conjElim)|Premises], _) :-
    member(line(_, and(_,Y), _), Premises),
    nextLineNumber(Premises, Next).

% conjunction introduction:
proves(Premises, line(Next, and(X, Y), conjIntro), [line(Next, and(X,Y), conjIntro)|Premises], _) :-
    member(line(_, X, _), Premises),
    member(line(_, Y, _), Premises),
    nextLineNumber(Premises, Next).

% disjunction introduction:
proves(Premises, line(Next, or(X, Y), disjIntro), [line(Next, or(X, Y), disjIntro)|Premises], _) :-
    member(line(_, X, _), Premises),
    nextLineNumber(Premises, Next).

proves(Premises, line(Next, or(X, Y), disjIntro), [line(Next, or(X, Y), disjIntro)|Premises], _) :-
    member(line(_, Y, _), Premises),
    nextLineNumber(Premises, Next).

% implication elimination:
proves(Premises, line(Next, Y, impElim), [line(Next, Y, impElim)|Premises], _) :-
    member(line(_, if(X, Y), _), Premises),
    member(line(_, X, _), Premises),
    nextLineNumber(Premises, Next).

% bi-implication elimination:
proves(Premises, line(Next, Y, biimpElim), [line(Next, Y, biimpElim)|Premises], _) :-
    member(line(_, iff(X, Y), _), Premises),
    member(line(_, X, _), Premises),
    nextLineNumber(Premises, Next).

proves(Premises, line(Next, X, biimpElim), [line(Next, X, biimpElim)|Premises], _) :-
    member(line(_, iff(X, Y), _), Premises),
    member(line(_, Y, _), Premises),
    nextLineNumber(Premises, Next).

% negation elimination:
proves(Premises, line(Next, X, negElim), [line(Next, X, negElim)|Premises], _) :-
    member(line(_, neg(neg(X)), _), Premises),
    nextLineNumber(Premises, Next).

% reiteration:
proves(Premises, line(Next, X, reit), [line(Next, X, reit)|Premises], _) :-
    member(line(_, X, _), Premises),
    nextLineNumber(Premises, Next).

% transitivity:
proves(Premises, line(_, X, JustX), End, D) :-
    % don't exceed the current depth D
    length(Premises, N),
    N =< D,
    % derive 1 line from the premises
    proves(Premises, line(_, Y, _), New, D),
    % don't prove lines you already have (heuristic)
    \+ member(line(_, Y, _), Premises),
    % with this step added to the premises, derive line X
    proves(New, line(_, X, JustX), End, D), !.

% try to prove Line at the current depth
provesIDS(Premises, Line, New, D) :-
    proves(Premises, Line, New, D), !.

% else do iterative deepening: increment the depth and try again
provesIDS(Premises, Line, New, D) :-
    Dnew is D + 1,
    % don't exceed the maximum proof length
    Dnew < 10,
    write('Trying search depth '), write(Dnew), writeln('...'),
    provesIDS(Premises, Line, New, Dnew).

% provesWrap/3 reverses the premises,
% then calls provesIDS/4 to do the proving,
% then reverses the final resulting proof in the end
provesWrap(Premises, Conclusion, X) :-
    reverse(Premises, P),
    % initial proof depth: number of premises
    length(Premises, N),
    provesIDS(P, Conclusion, Y, N),
    % newline for neat progress printing
    reverse(Y, X), nl.
