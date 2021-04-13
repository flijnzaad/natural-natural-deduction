% implication introduction
proves(Premises, line(if(X, Y), impIntro, [S|Premises]) :-
    % Here S will be a list which is the whole subproof.
    % Problem: the existing rules will tag the new lines on at the end of the
    % Premises, which they shouldn't do in this case: we want S to only contain
    % the subproof's lines. But the Premises in the first argument do need
    % to contain the previous lines of the proof to make the inferences of the
    % subproof. You could manually remove the lines from Premises at the end
    % maybe, but that's hardly an elegant solution (and I don't know if it 
    % would work).
    proves([line(X, premise)|Premises], line(Y, _), S).
