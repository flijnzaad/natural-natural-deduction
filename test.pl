:- set_prolog_flag(verbose, silent).
:- initialization main.

main :-
    consult('system.pl'),
    consult('queries.pl'),
    writeln('q1: '),  q1(_1),   writelines(_1),  nl,
    writeln('q2: '),  q2(_2),   writelines(_2),  nl,
    writeln('q3: '),  q3(_3),   writelines(_3),  nl,
    writeln('q4: '),  q4(_4),   writelines(_4),  nl,
    writeln('q5: '),  q5(_5),   writelines(_5),  nl,
    writeln('q6: '),  q6(_6),   writelines(_6),  nl,
    writeln('q7: '),  q7(_7),   writelines(_7),  nl,
    writeln('q8: '),  q8(_8),   writelines(_8),  nl,
    writeln('q9: '),  q9(_9),   writelines(_9),  nl,
    writeln('q10: '), q10(_10), writelines(_10), nl,
    writeln('q11: '), q11(_11), writelines(_11), nl,
    writeln('q12: '), q12(_12), writelines(_12), nl,
    writeln('q13: '), q13(_13), writelines(_13), nl,
    writeln('q14: '), q14(_14), writelines(_14), nl,
    writeln('q15: '), q15(_15), writelines(_15), nl,
    writeln('q16: '), q16(_16), writelines(_16), nl,
    writeln('q17: '), q17(_17), writelines(_17), nl,
    writeln('q18: '), q18(_18), writelines(_18), nl,
    writeln('q19: '), q19(_19), writelines(_19), nl,
    writeln('q20: '), q20(_20), writelines(_20), nl,
    % writeln('q21: '), q21(_21), writelines(_21), nl,
    halt(0).

writelines([]).

writelines([H|T]) :-
    H = line(N, A, J, C),
    write(N), tab(2),
    write(A), tab(4), 
    write(J), tab(4), 
    write(C), nl,
    writelines(T).
