%% EVENT MOTOR %%

% ACTION
event(A):- action(A).
event(U):- auto(U).
event(A) :- act(A).


% FLUENTS
neg(neg(F)) :- fluent(F), holds(F). 
initiates(E,F,T):- effect(E,F), occurs(E,T).
terminates(E,F,T):- effect(E,neg(F)), occurs(E,T).
holds(F,0):- initially(F).
holds(F,T):- initiates(E,F,T-1), time(T).
holds(F,T):- holds(F,T-1), not clipped(F,T-1), not nonInertial(F), time(T).
clipped(F,T):- terminates(E,F,T).
clipped(neg(F), T) :- holds(F, T+1), time(T), fluent(F). 

% EVENTS
incomplete(E,T):- precond(F,E), not holds(F,T), time(T). 
possible(E,T):- not incomplete(E,T), event(E), time(T).
occurs(U,T):- possible(U,T), auto(U). 
occurs(A,T):- possible(A,T), performs(D,A,T), action(A).

