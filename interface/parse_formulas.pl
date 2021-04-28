stringOf(p,"p").
stringOf(q,"q").
stringOf(r,"r").
stringOf(s,"s").

stringOf(neg(X),S) :-
    stringOf(X,SX),
    string_concat(" \\lnot ", SX, S).

stringOf(and(X,Y),S) :-
    stringOf(X,SX),
    stringOf(Y,SY),
    string_concat(SX, " \\land ", S2),
    string_concat(S2, SY, S).
