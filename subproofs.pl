% implication introduction
proves(Premises, line(if(X, Y), impIntro), [S|Premises]) :-
    proves([line(X, premise)], [line(X, premise)|Premises], line(Y, _), S).
