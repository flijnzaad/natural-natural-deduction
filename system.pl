% version 3.21

:- consult('connectives.pl').

% This makes sure that answers are never abbreviated with "..."
:- set_prolog_flag(answer_write_options,
                    [ quoted(true),
                      portray(true),
                      character_escapes(false),
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

% prove a subproof
subproof(ProofLines, Available, Line, End, NewA, Premise, Concl, Next, N1, N2, D, C) :-
    nextLineNumber(Available, Dnew),
    Dnew =< D,
    % prove the subproof, the full proof is unified with S
    % TODO: maybe the anonymous variable here is already End or NewA
    proves([Premise], [Premise|Available], Concl, S, _, D, C),
    reverse(S, Subproof),
    % add the Subproof and Line to the previous lines to get End
    End  = [Line|[Subproof|ProofLines]],
    NewA = [Line|[Subproof|Available]],
    % calculate the line numbers
    nextLineNumber(Available, N1),
    currentLineNumber(NewA, Next),
    N2 is Next - 1.

% prove two subproofs
subproofs(ProofLines1, Available1, Line, End, NewA, Premise1, Premise2,
          Concl1, Concl2, Next, N1, N2, N3, N4, D, C) :-
    nextLineNumber(Available1, Dnew),
    Dnew =< D,
    % prove the first subproof, the full proof is unified with S1
    % TODO: maybe the anonymous variable here is already End or NewA
    proves([Premise1], [Premise1|Available1], Concl1, S1, _, D, C),
    reverse(S1, Subproof1),
    % add the Subproof1 to the previous ProofLines1 and Available1 to get
    % intermediate proof line lists
    ProofLines2 = [Subproof1|ProofLines1],
    Available2  = [Subproof1|Available1],
    nextLineNumber(Available2, Dnewer),
    Dnewer =< D,
    proves([Premise2], [Premise2|Available2], Concl2, S2, _, D, C),
    reverse(S2, Subproof2),
    % add the Subproof2 and Line to the previous lines to get End
    End  = [Line|[Subproof2|ProofLines2]],
    NewA = [Line|[Subproof2|Available2]],
    % calculate the line numbers
    % TODO: maybe this could be more efficient
    nextLineNumber(Available1, N1),
    currentLineNumber(Available2, N2),
    N3 is N2 + 1,
    currentLineNumber(NewA, Next),
    N4 is Next - 1.

% contradiction introduction:
proves(ProofLines, Available, Line, [Line|ProofLines], [Line|Available], _, _) :-
    Line = line(Next, contra, contraIntro, two(N1, N2)),
    member(line(N1, X, _, _), Available),
    member(line(N2, neg(X), _, _), Available),
    X \= neg(X),
    nextLineNumber(Available, Next).

% contradiction elimination:
proves(ProofLines, Available, Line, [Line|ProofLines], [Line|Available], _, _) :-
    Line = line(Next, _, contraElim, N),
    member(line(N, contra, _, _), Available),
    nextLineNumber(Available, Next).

% conjunction elimination:
proves(ProofLines, Available, Line, [Line|ProofLines], [Line|Available], _, _) :-
    Line = line(Next, X, conjElim, N),
    member(line(N, and(X, _), _, _), Available),
    X \= and(X, _),
    nextLineNumber(Available, Next).

proves(ProofLines, Available, Line, [Line|ProofLines], [Line|Available], _, _) :-
    Line = line(Next, Y, conjElim, N),
    member(line(N, and(_, Y), _, _), Available),
    Y \= and(_, Y),
    nextLineNumber(Available, Next).

% conjunction introduction:
proves(ProofLines, Available, Line, [Line|ProofLines], [Line|Available], _, C) :-
    member(and, C),
    Line = line(Next, and(X, Y), conjIntro, two(N1, N2)),
    member(line(N1, X, _, _), Available),
    member(line(N2, Y, _, _), Available),
    X \= and(X, _),
    Y \= and(_, Y),
    nextLineNumber(Available, Next).

% disjunction introduction:
proves(ProofLines, Available, Line, [Line|ProofLines], [Line|Available], _, C) :-
    member(or, C),
    Line = line(Next, or(X, _), disjIntro, N),
    member(line(N, X, _, _), Available),
    X \= or(X, _),
    nextLineNumber(Available, Next).

proves(ProofLines, Available, Line, [Line|ProofLines], [Line|Available], _, C) :-
    member(or, C),
    Line = line(Next, or(_, Y), disjIntro, N),
    member(line(N, Y, _, _), Available),
    Y \= or(_, Y),
    nextLineNumber(Available, Next).

% implication elimination:
proves(ProofLines, Available, Line, [Line|ProofLines], [Line|Available], _, _) :-
    Line = line(Next, Y, impElim, two(N1, N2)),
    member(line(N1, if(X, Y), _, _), Available),
    member(line(N2, X, _, _), Available),
    Y \= if(_, Y),
    nextLineNumber(Available, Next).

% bi-implication elimination:
proves(ProofLines, Available, Line, [Line|ProofLines], [Line|Available], _, _) :-
    Line = line(Next, Y, biimpElim, two(N1, N2)),
    member(line(N1, iff(X, Y), _, _), Available),
    member(line(N2, X, _, _), Available),
    X \= iff(X, _),
    Y \= iff(_, Y),
    nextLineNumber(Available, Next).

proves(ProofLines, Available, Line, [Line|ProofLines], [Line|Available], _, _) :-
    Line = line(Next, X, biimpElim, two(N1, N2)),
    member(line(N1, iff(X, Y), _, _), Available),
    member(line(N2, Y, _, _), Available),
    X \= iff(X, _),
    Y \= iff(_, Y),
    nextLineNumber(Available, Next).

% negation elimination:
proves(ProofLines, Available, Line, [Line|ProofLines], [Line|Available], _, _) :-
    Line = line(Next, X, negElim, N),
    member(line(N, neg(neg(X)), _, _), Available),
    X \= neg(neg(X)),
    nextLineNumber(Available, Next).

% reiteration:
proves(ProofLines, Available, Line, [Line|ProofLines], [Line|Available], _, _) :-
    Line = line(Next, X, reit, N),
    member(line(N, X, _, _), Available),
    nextLineNumber(Available, Next).

%%% subproof rules

% implication introduction:
proves(ProofLines, Available, Line, End, NewA, D, C) :-
    member(if, C),
    Line = line(Next, if(X, Y), impIntro, sub(N1, N2)),
    X \= if(X, _),
    % the premise and conclusion of the subproof
    Premise = line(N1, X, premise, 0),
    Concl   = line(N2, Y, _, _),
    subproof(ProofLines, Available, Line, End, NewA,
             Premise, Concl, Next, N1, N2, D, C).

% negation introduction:
proves(ProofLines, Available, Line, End, NewA, D, C) :-
    member(neg, C),
    Line = line(Next, neg(X), negIntro, sub(N1, N2)),
    X \= neg(X),
    % the premise and conclusion of the subproof
    Premise = line(N1, X, premise, 0),
    Concl   = line(N2, contra, _, _),
    subproof(ProofLines, Available, Line, End, NewA,
             Premise, Concl, Next, N1, N2, D, C).

% disjunction elimination:
proves(ProofLines, Available, Line, End, NewA, D, C) :-
    Line = line(Next, Z, disjElim, three(N0, sub(N1, N2), sub(N3, N4))),
    member(line(N0, or(X, Y), Justification, _), Available),
    Justification \= disjIntro,
    ground(or(X, Y)),
    Premise1 = line(N1, X, premise, 0),
    Concl1   = line(N2, Z, _, _),
    Premise2 = line(N3, Y, premise, 0),
    Concl2   = line(N4, Z, _, _),
    subproofs(ProofLines, Available, Line, End, NewA, Premise1, Premise2,
              Concl1, Concl2, Next, N1, N2, N3, N4, D, C).

% bi-implication introduction:
proves(ProofLines, Available, Line, End, NewA, D, C) :-
    member(iff, C),
    Line = line(Next, iff(X, Y), biimpIntro, two(sub(N1, N2), sub(N3, N4))),
    X \= iff(X, _),
    Y \= iff(_, Y),
    Premise1 = line(N1, X, premise, 0),
    Concl1   = line(N2, Y, _, _),
    Premise2 = line(N3, Y, premise, 0),
    Concl2   = line(N4, X, _, _),
    subproofs(ProofLines, Available, Line, End, NewA, Premise1, Premise2,
              Concl1, Concl2, Next, N1, N2, N3, N4, D, C).

% proof by contradiction
proves(ProofLines, Available, Line, End, NewA, D, C) :-
    Line    = line(Next1, X, negElim, Next),
    Premise = line(N1, neg(X), premise, 0),
    Concl   = line(N2, contra, _, _),
    DoubleN = line(Next, neg(neg(X)), negIntro, sub(N1, N2)),
    subproof(ProofLines, Available, DoubleN, End1, NewA1,
             Premise, Concl, Next, N1, N2, D, C),
    End  = [Line|End1],
    NewA = [Line|NewA1],
    Next1 is Next + 1.

%%%

% transitivity:
proves(ProofLines, Available, LineX, End, NewAvailable, MaxDepth, C) :-
    LineX = line(_, Formula, _, _),
    % the Formula to prove should be instantiated
    ground(Formula),
    % don't exceed the current search depth D of *all available lines*
    currentLineNumber(Available, D),
    D =< MaxDepth,
    % derive 1 line (LineY) from the premises
    proves(ProofLines, Available, line(_, Y, _, _), NewP, NewA, MaxDepth, C),
    % don't prove lines you already have (heuristic)
    \+ member(line(_, Y, _, _), Available),
    % with LineY added to the premises, derive line X
    proves(NewP, NewA, LineX, End, NewAvailable, MaxDepth, C), !.

% try to prove Line at the current search depth
provesIDS(Premises, Available, Line, NewP, NewA, D, C) :-
    proves(Premises, Available, Line, NewP, NewA, D, C), !.

% else do iterative deepening
provesIDS(Premises, Available, Line, NewP, NewA, D, C) :-
    % increment the search depth
    Dnew is D + 1,
    % don't exceed the maximum proof length
    Dnew < 30,
    write('Trying search depth '), write(Dnew), writeln('...'),
    % try again with the new search depth
    provesIDS(Premises, Available, Line, NewP, NewA, Dnew, C).

% provesWrap/4 reverses the premises,
% then calls provesIDS/5 to do the proving,
% then reverses the final resulting proof in the end
provesWrap(Premises, Available, Conclusion, X, C) :-
    reverse(Premises, P),
    % initial proof depth: number of premises
    currentLineNumber(Premises, D),
    provesIDS(P, Available, Conclusion, Y, _, D, C),
    % newline for neat progress printing
    reverse(Y, X).

% if you don't have the Available argument, instantiate it with Premises
provesWrap(Premises, Conclusion, X) :-
    connectives(Premises, Conclusion, Connectives),
    provesWrap(Premises, Premises, Conclusion, X, Connectives).
