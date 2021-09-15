int: f;
int: g;
int: c;
int: k; % max boat capacity
set of int: Cap = 0..k;
int: t; % number of trips
set of int: Trips = 1..t;
int: pf;
int: pg;
int: pc;

set of int: FOXES = 0..f;
set of int: GEESE = 0..g;
set of int: CORN = 0..c;
set of int: TripsWithZero = 0..t;

% Go crazy here

% 0 (row) - animals on the left side; 1 (row) - animals on the right side
array[0..1, TripsWithZero] of var FOXES: foxes;
array[0..1, TripsWithZero] of var GEESE: geese;
array[0..1, TripsWithZero] of var CORN: corn;

% results:
array[Trips] of var FOXES: foxBoat; % [ number of foxes taken in boat on each trip 1..t ];
array[Trips] of var GEESE: geeseBoat; %[ number of geese taken in boat on each trip 1..t ];
array[Trips] of var CORN: cornBoat; % [ number of bags of corns taken in each trip 1..t ];
var Trips: madetrips; % number of trips actually made;

% Constraints

% some symmetry breaking:
constraint madetrips mod 2 == 1;
constraint madetrips = t;

% situation at the beginning
constraint foxes[0, 0] = f /\ geese[0, 0] = g /\ corn[0, 0] = c;
constraint foxes[1, 0] = 0 /\ geese[1, 0] = 0 /\ corn[1, 0] = 0;

% number of animals in boat has to be less than boat capacity
constraint forall(i in 1..madetrips)(foxBoat[i] + geeseBoat[i] + cornBoat[i] <= k);

% number of animals cannot go higher
constraint forall(i in Trips)(foxes[0, i-1] + foxes[1,i-1] >= foxes[0,i] + foxes[1,i]	/\  geese[0,i-1] + geese[1,i-1] >= geese[0,i] + geese[1,i]	/\ corn[0,i-1] + corn[1,i-1] >=  corn[0,i] +  corn[1,i]);	

constraint forall(i in Trips)(i > madetrips -> foxBoat[i] = 0 /\ geeseBoat[i] = 0 /\ cornBoat[i] = 0);

%situation on a boat
constraint forall(i in 1..madetrips) (if i mod 2 == 1 then (
                 foxes[0,i] <= foxes[0,i-1] - foxBoat[i] /\ foxes[1,i] = foxes[1,i-1] + foxBoat[i] /\ geese[0,i] <= geese[0,i-1] - geeseBoat[i] /\ geese[1,i] = geese[1,i-1] + geeseBoat[i] /\ corn[0,i] <= corn [0,i-1] - cornBoat[i] /\ corn[1,i] = corn[1,i-1] + cornBoat[i])
                 else (foxes[1,i] <= foxes[1,i-1] - foxBoat[i] /\ foxes[0,i] = foxes[0,i-1] + foxBoat[i] /\ geese[1,i] <= geese[1,i-1] - geeseBoat[i] /\ geese[0,i] = geese[0,i-1] + geeseBoat[i] /\ corn[1,i] <= corn [1,i-1] - cornBoat[i] /\ corn[0,i] = corn[0,i-1] + cornBoat[i])
                 endif);
                 
                
predicate updateAnimals(var FOXES: prevFoxesNum, var GEESE: prevGeeseNum, var CORN: prevCornNum, var FOXES: nextFoxesNum, var GEESE: nextGeeseNum, var CORN: nextCornNum) =
  let {
    var bool: areFoxes = prevFoxesNum > 0;
    var bool: areGeese = prevGeeseNum > 0;
    var bool: isCorn = prevCornNum > 0;
   } in (
   nextFoxesNum == prevFoxesNum - if (areGeese /\ prevFoxesNum > prevGeeseNum) \/ (not areGeese /\ areFoxes /\ isCorn) then 1 else 0 endif
   /\
   nextGeeseNum == prevGeeseNum - if (not areFoxes /\ isCorn /\ prevGeeseNum > prevCornNum) then 1 elseif (areGeese /\ prevFoxesNum <= prevGeeseNum) then prevFoxesNum else 0 endif
   /\
   nextCornNum == prevCornNum - if (not areGeese /\ areFoxes /\ isCorn) \/ (not areFoxes /\ isCorn /\ prevGeeseNum > prevCornNum) then 1 elseif (not areFoxes /\ isCorn /\ prevGeeseNum <= prevCornNum) then prevGeeseNum else 0 endif
);

constraint forall(i in 1..madetrips) ( if i mod 2 == 1 then updateAnimals(foxes[0, i-1] - foxBoat[i], geese[0, i-1] - geeseBoat[i], corn[0, i-1] - cornBoat[i], foxes[0, i], geese[0, i], corn[0, i])
                                       else updateAnimals(foxes[1, i-1] - foxBoat[i], geese[1, i-1] - geeseBoat[i], corn[1, i-1] - cornBoat[i], foxes[1, i], geese[1, i], corn[1, i])
                                       endif);

% we cannot take more than we have on a shore
constraint forall(i in 1..madetrips) (if i mod 2 == 1 then (
                  foxBoat[i] <= foxes[0,i-1] /\ geeseBoat[i] <= geese[0,i-1] /\ cornBoat[i] <= corn[0,i-1])
                  else (foxBoat[i] <= foxes[1,i-1] /\ geeseBoat[i] <= geese[1,i-1] /\ cornBoat[i] <= corn[1,i-1])
                  endif);

var int: obj = pf*foxes[1, madetrips] + pg*geese[1, madetrips] + pc*corn[1, madetrips];

solve 
    :: seq_search([
        int_search([madetrips], input_order, indomain_min, complete),
        int_search([madetrips], first_fail, indomain_min, complete)
    ])          
    maximize obj;

output [
    %"foxshores[0] = \([foxes[0,i] | i in 0..madetrips]);\n",
    %"geeseshores[0] = \([geese[0,i] | i in 0..madetrips]);\n",
    %"cornshores[0] = \([corn[0,i] | i in 0..madetrips]);\n",
    %"foxshores[1] = \([foxes[1,i] | i in 0..madetrips]);\n",
    %"geeseshores[1] = \([geese[1,i] | i in 0..madetrips]);\n",
    %"cornshores[1] = \([corn[1,i] | i in 0..madetrips]);\n",
    "fox = \(foxBoat);\n",
    "geese = \(geeseBoat);\n",
    "corn = \(cornBoat);\n",
    "trips = \(madetrips);\n",
    "obj = \(obj);\n"
];
