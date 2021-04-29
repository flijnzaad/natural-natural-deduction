% version 2.2

% This makes sure that answers are never abbreviated with "..."
:- set_prolog_flag(answer_write_options,
                    [ quoted(true),
                      portray(true),
                      spacing(next_argument)
                    ]).

currentLineNumber([], 0).

currentLineNumber(line(_, _, _, _), 1).

currentLineNumber([H|T], N) :-
    currentLineNumber(H, A),
    currentLineNumber(T, B),
    N is A + B.

nextLineNumber(L, N) :-
    currentLineNumber(L, Current),
    N is Current + 1.

% contradiction introduction:
proves(Premises, line(Next, contra, contraIntro, two(N1, N2)), [line(Next, contra, contraIntro, two(N1, N2))|Premises], _) :-
    member(line(N1, X, _, _), Premises),
    member(line(N2, neg(X), _, _), Premises),
    nextLineNumber(Premises, Next).

% contradiction elimination:
proves(Premises, line(Next, X, contraElim, N), [line(Next, X, contraElim, N)|Premises], _) :-
    member(line(N, contra, _, _), Premises),
    nextLineNumber(Premises, Next).

% conjunction elimination:
proves(Premises, line(Next, X, conjElim, N), [line(Next, X, conjElim, N)|Premises], _) :-
    member(line(N, and(X,_), _, _), Premises),
    nextLineNumber(Premises, Next).

proves(Premises, line(Next, Y, conjElim, N), [line(Next, Y, conjElim, N)|Premises], _) :-
    member(line(N, and(_,Y), _, _), Premises),
    nextLineNumber(Premises, Next).

% conjunction introduction:
proves(Premises, line(Next, and(X, Y), conjIntro, two(N1, N2)), [line(Next, and(X,Y), conjIntro, two(N1, N2))|Premises], _) :-
    member(line(N1, X, _, _), Premises),
    member(line(N2, Y, _, _), Premises),
    nextLineNumber(Premises, Next).

% disjunction introduction:
proves(Premises, line(Next, or(X, Y), disjIntro, N), [line(Next, or(X, Y), disjIntro, N)|Premises], _) :-
    member(line(N, X, _, _), Premises),
    nextLineNumber(Premises, Next).

proves(Premises, line(Next, or(X, Y), disjIntro, N), [line(Next, or(X, Y), disjIntro, N)|Premises], _) :-
    member(line(N, Y, _, _), Premises),
    nextLineNumber(Premises, Next).

% implication elimination:
proves(Premises, line(Next, Y, impElim, two(N1, N2)), [line(Next, Y, impElim, two(N1, N2))|Premises], _) :-
    member(line(N1, if(X, Y), _, _), Premises),
    member(line(N2, X, _, _), Premises),
    nextLineNumber(Premises, Next).

% bi-implication elimination:
proves(Premises, line(Next, Y, biimpElim, two(N1, N2)), [line(Next, Y, biimpElim, two(N1, N2))|Premises], _) :-
    member(line(N1, iff(X, Y), _, _), Premises),
    member(line(N2, X, _, _), Premises),
    nextLineNumber(Premises, Next).

proves(Premises, line(Next, X, biimpElim, two(N1, N2)), [line(Next, X, biimpElim, two(N1, N2))|Premises], _) :-
    member(line(N1, iff(X, Y), _, _), Premises),
    member(line(N2, Y, _, _), Premises),
    nextLineNumber(Premises, Next).

% negation elimination:
proves(Premises, line(Next, X, negElim, N), [line(Next, X, negElim, N)|Premises], _) :-
    member(line(N, neg(neg(X)), _, _), Premises),
    nextLineNumber(Premises, Next).

% reiteration:
proves(Premises, line(Next, X, reit, N), [line(Next, X, reit, N)|Premises], _) :-
    member(line(N, X, _, _), Premises),
    nextLineNumber(Premises, Next).

% transitivity:
proves(Premises, line(_, X, JustX, _), End, D) :-
    % don't exceed the current depth D
    length(Premises, N),
    N =< D,
    % derive 1 line from the premises
    proves(Premises, line(_, Y, _, _), New, D),
    % don't prove lines you already have (heuristic)
    \+ member(line(_, Y, _, _), Premises),
    % with this step added to the premises, derive line X
    proves(New, line(_, X, JustX, _), End, D), !.

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
