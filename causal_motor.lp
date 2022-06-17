%% CAUSAL MOTOR %%

% CONSEQUENCES
cons(E,T,F):- occurs(E,T), effect(E,F), holds(F,T+1).
cons(F,T,E):-  occurs(E,T), precond(F,E), holds(F,T).
cons(E1,T1,E3):- cons(E1,T1,C2), cons(C2,T2,E3), event(E1), event(E3), T2>T1.

