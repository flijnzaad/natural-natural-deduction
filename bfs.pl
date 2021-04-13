%%% Test program
reachable(X) :- start(X).
reachable(X) :- edge(Y, X), reachable(Y).

start(1).
edge(1,2).
edge(2,3).
edge(3,4).
edge(1,5).

%%% Auxiliary predicates
conj_append(true,Ys,Ys).
conj_append(X,Ys,(X,Ys)) :-
    X \= true,
    X \= (_,_).
conj_append((X,Xs),Ys,(X,Zs)):-
conj_append(Xs,Ys,Zs).

myclause(A,B) :-
    A \= true,
    clause(A,B).

%%% BFS meta-interpreter
prove_bf(Goal):-
    prove_bf_a([a(Goal,Goal)],Goal).

prove_bf_a([a(true,Goal)|_],Goal).
prove_bf_a([a((A,B),G)|Agenda],Goal):- !,
    findall(a(D,G),(myclause(A,C),conj_append(C,B,D)),Children),
    append(Agenda,Children,NewAgenda),
    prove_bf_a(NewAgenda,Goal).
prove_bf_a([a(A,G)|Agenda],Goal):-
    findall(a(B,G),myclause(A,B),Children),
    append(Agenda,Children,NewAgenda),
    prove_bf_a(NewAgenda,Goal).

a.
b:- a.

%%% DFS meta-interpreter
dfs(true) :- !.
dfs((G,R)) :- !, dfs(G), dfs(R).
dfs(G) :- clause(G,Body), dfs(Body).
