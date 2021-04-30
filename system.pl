% version 3.4

% This makes sure that answers are never abbreviated with "..."
:- set_prolog_flag(answer_write_options,
                    [ quoted(true),
                      portray(true),
                      spacing(next_argument)
                    ]).

% calculate the current line number of the list of proof lines
currentLineNumber([], 0).

currentLineNumber(line(_, _, _, _), 1).

currentLineNumber([H|T], N) :-
    currentLineNumber(H, A),
    currentLineNumber(T, B),
    N is A + B.

% calculate the next line number of the list of proof lines
nextLineNumber(L, N) :-
    currentLineNumber(L, Current),
    N is Current + 1.

% contradiction introduction:
proves(ProofLines, Available, Line, [Line|ProofLines], _) :-
    Line = line(Next, contra, contraIntro, two(N1, N2)),
    member(line(N1, X, _, _), Available),
    member(line(N2, neg(X), _, _), Available),
    nextLineNumber(ProofLines, Next).

% contradiction elimination:
proves(ProofLines, Available, Line, [Line|ProofLines], _) :-
    Line = line(Next, _, contraElim, N),
    member(line(N, contra, _, _), Available),
    nextLineNumber(ProofLines, Next).

% conjunction elimination:
proves(ProofLines, Available, Line, [Line|ProofLines], _) :-
    Line = line(Next, X, conjElim, N),
    member(line(N, and(X,_), _, _), Available),
    nextLineNumber(ProofLines, Next).

proves(ProofLines, Available, Line, [Line|ProofLines], _) :-
    Line = line(Next, Y, conjElim, N),
    member(line(N, and(_,Y), _, _), Available),
    nextLineNumber(ProofLines, Next).

% conjunction introduction:
proves(ProofLines, Available, Line, [Line|ProofLines], _) :-
    Line = line(Next, and(X, Y), conjIntro, two(N1, N2)),
    member(line(N1, X, _, _), Available),
    member(line(N2, Y, _, _), Available),
    nextLineNumber(ProofLines, Next).

% disjunction introduction:
proves(ProofLines, Available, Line, [Line|ProofLines], _) :-
    Line = line(Next, or(X, _), disjIntro, N),
    member(line(N, X, _, _), Available),
    nextLineNumber(ProofLines, Next).

proves(ProofLines, Available, Line, [Line|ProofLines], _) :-
    Line = line(Next, or(_, Y), disjIntro, N),
    member(line(N, Y, _, _), Available),
    nextLineNumber(ProofLines, Next).

% implication elimination:
proves(ProofLines, Available, Line, [Line|ProofLines], _) :-
    Line = line(Next, Y, impElim, two(N1, N2)),
    member(line(N1, if(X, Y), _, _), Available),
    member(line(N2, X, _, _), Available),
    nextLineNumber(ProofLines, Next).

% bi-implication elimination:
proves(ProofLines, Available, Line, [Line|ProofLines], _) :-
    Line = line(Next, Y, biimpElim, two(N1, N2)),
    member(line(N1, iff(X, Y), _, _), Available),
    member(line(N2, X, _, _), Available),
    nextLineNumber(ProofLines, Next).

proves(ProofLines, Available, Line, [Line|ProofLines], _) :-
    Line = line(Next, X, biimpElim, two(N1, N2)),
    member(line(N1, iff(X, Y), _, _), Available),
    member(line(N2, Y, _, _), Available),
    nextLineNumber(ProofLines, Next).

% negation elimination:
proves(ProofLines, Available, Line, [Line|ProofLines], _) :-
    Line = line(Next, X, negElim, N),
    member(line(N, neg(neg(X)), _, _), Available),
    nextLineNumber(ProofLines, Next).

% reiteration:
proves(ProofLines, Available, Line, [Line|ProofLines], _) :-
    Line = line(Next, X, reit, N),
    member(line(N, X, _, _), Available),
    nextLineNumber(ProofLines, Next).

% implication introduction
proves(ProofLines, Available, Line, End, _) :-
    Line    = line(Next, if(X, Y), impIntro, sub(N1, N2)),
    % the premise and conclusion of the subproof
    Premise = line(N1, X, premise, 0),
    Concl   = line(N2, Y, _, _),
    % prove the subproof, the full proof is unified with Subproof
    provesWrap([Premise], [Premise|Available], Concl, Subproof),
    % add the Subproof and Line to the previous lines to get End
    End  = [Line|[Subproof|ProofLines]],
    % calculate the line numbers
    nextLineNumber(ProofLines, N1),
    nextLineNumber([Subproof|ProofLines], Next),
    N2 is Next - 1.

% transitivity:
proves(ProofLines, Available, line(_, X, JustX, _), End, D) :-
    % don't exceed the current depth D
    currentLineNumber(ProofLines, N),
    N =< D,
    % derive 1 line from the premises
    proves(ProofLines, Available, line(Ln, Y, J, C), New, D),
    % don't prove lines you already have (heuristic)
    \+ member(line(_, Y, _, _), ProofLines),
    NewAvailable = [line(Ln, Y, J, C)|Available],
    % with this step added to the premises, derive line X
    proves(New, NewAvailable, line(_, X, JustX, _), End, D), !,
    writeln(End).

% try to prove Line at the current depth
provesIDS(Premises, Available, Line, New, D) :-
    proves(Premises, Available, Line, New, D), !.

% else do iterative deepening: increment the depth and try again
provesIDS(Premises, Available, Line, New, D) :-
    Dnew is D + 1,
    % don't exceed the maximum proof length
    Dnew < 12,
    write('Trying search depth '), write(Dnew), writeln('...'),
    provesIDS(Premises, Available, Line, New, Dnew).

% provesWrap/4 reverses the premises,
% then calls provesIDS/5 to do the proving,
% then reverses the final resulting proof in the end
provesWrap(Premises, Available, Conclusion, X) :-
    reverse(Premises, P),
    % initial proof depth: number of premises
    currentLineNumber(Premises, D),
    provesIDS(P, Available, Conclusion, Y, D),
    % newline for neat progress printing
    reverse(Y, X), nl.

% if you don't have the Available argument, instantiate it with Premises
provesWrap(Premises, Conclusion, X) :-
    provesWrap(Premises, Premises, Conclusion, X).
