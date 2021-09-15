% PARAMETERS - const
int: n;  % ilosc przedmiotow
set of int: Indexes = 1..n;
array[Indexes] of int: Weights;
array[Indexes] of int: Values;
int: capasity; % pojemnosc plecaka

% VARIABLES:
array[Indexes] of var bool: Artefacts; % bool == 0..1 - zmienna o wartosciach 0-1
constraint trace("chomik", Indexes == index_set(Values));

%CONSTRAINTS:
constraint sum([Artefacts[i]*Weights[i] | i in Indexes]) <= capasity;  % dla kazdego A[i]*W[i] po i 1..n
% constraint sum(i in 1..n)(Artefacts[i]*Weights[i]) <= capasity;

%OBJECTIVE:
%var int: objective = sum([Artefacts[i]*Values[i] | i in Indexes]);
%solve maximize objective;

%output ["artifacts: \(Artefacts)\nobj: \(objective)"]; % tablica ze stringiem
output ["artefacts: \(Artefacts)\nobj: "];