%% MODALITY SPECIFICATION %%

%modality(I;V) :- right(I), value(V).
modality(I) :- right(I).
m_Weight(M,1) :- modality(M).
t_Weight(E,1) :- effect(E,involves(X)).
%value(helpfulness).
right(life).


%% ETHICAL EVENT SPECIFICATION %%

% VALUES
%effect(cure(X,G), displays(helpfulness)):- auto(cure(X,G)).
%effect(kill(X,G), neg(displays(helpfulness))):- auto(kill(X,G)).

% RIGHTS:
effect(kill(X), neg(life)) :- event(kill(X)).
effect(dies(X), neg(life)) :- event(dies(X)).
effect(shoot(X), neg(life)) :- event(shoot(X)).

% BELIEVES
believes(X, cons(A, B)) :- cons(A, T, B), time(T), agent(X).



%% THEORY OF THE GOOD %%

% VALUES
%good(E,X,M):- effect(E,involves(X)), effect(E,displays(M)), value(M).
%bad(E,X,M):- effect(E,involves(X)), effect(E,neg(displays(M))), value(M).

% RIGHTS
bad(E,X,M):- effect(E,involves(X)), effect(E,neg(M)), right(M).
good(E,X,M):- effect(E,involves(X)), not effect(E,neg(M)), right(M).

% WEIGHT
weightedGood(E,N1*N2,M) :- good(E,X,M), m_Weight(M,N1), t_Weight(E,N2).
weightedBad(E,N1*N2,M) :- bad(E,X,M), m_Weight(M,N1), t_Weight(E,N2).
weight(E,1) :- good(E,X,M).
weight(E,1) :- bad(E,X,M).
final_weight(E,N1-N3) :- event(E), N1=#sum{N2 : weightedGood(E,N2,M1)}, N3=#sum{N4 : weightedBad(E,N4,M2)}.

%% THEORIES OF THE RIGHT %%

%% INTENTIONS
holds(intention(X,B), T) :- holds(intention(X, A), T), holds(believes(X, cons(A, B)), T).
holds(badintention(X, A), T) :- holds(intention(X, A), T), bad(A,Y,M), time(T). 
holds(goodintention(X, A), T) :- holds(intention(X, A), T), good(A,Y,M), time(T). 

%%% the good or bad intention terminates when the intention terminates.
terminates(A, badintention(X,A), T) :- terminates(A, intention(X,A), T).
terminates(A, goodintention(X, A), T) :- terminates(A, intention(X,A), T).


%% CONSEQUENTIALISM

%%% PRINCIPLE OF BENEFITS VS COSTS
weightCons(A,T,E,N):- event(A), cons(A,T,E), final_weight(E,N).
weightAct(A,N):- event(A), N=#sum{N1 : weightCons(A,T,E,N1)}.
imp(benefitsCosts,A):- weightAct(A,N), N<0.
per(benefitsCosts,A):- event(A), not imp(benefitsCosts,A).

%% DEONTOLOGY 

%%% DDE (doctrine of double effect)
imp(dde1,A) :- event(A), bad(A,Y,M).
imp(dde2,A) :- event(A), holds(badintention(X, A), T). 
imp(dde3,A) :- event(A), cons(A,T,E1), cons(E1,T2,E2), bad(E1,Y1,M1), good(E2,Y2,M2).
imp(dde4,A) :- imp(benefitsCosts,A).
per(dde,A) :-  event(A), not imp(dde1,A), not imp(dde2,A), not imp(dde3,A), not imp(dde4,A). 


effect(kill(X), involves(X)) :- event(kill(X)).
effect(dies(X), involves(X)) :- event(dies(X)).
effect(shoot(X), involves(X)) :- event(shoot(X)).
