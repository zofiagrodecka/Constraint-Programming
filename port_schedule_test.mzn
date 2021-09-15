int: nr; % number of reclaimers
           % number of rails = nr for stages A,B,C,D,E
           % number of rails = (nr + 1) div 2 for stage F

set of int: RECLAIMER = 1..nr;
bool: stageF; % is this stage F data

int: ns; % number of stockpiles
set of int: STOCKPILE = 1..ns;
array[STOCKPILE] of int: size; % size in 10000 tonnes
array[STOCKPILE] of SHIP: ship; % which ship carries stockpile
 
int: maxtime; % time considered
set of int: TIME = 0..maxtime;

int: nsh; % number of ships
set of int: SHIP = 1..nsh;
array[SHIP] of TIME: arrival; % when ship arrives in port

int: len; % length of pad
set of int: POSITION = 0..len;

int: stack_time;
int: reclaim_time;
int: reclaim_speed;

array[STOCKPILE] of var POSITION: westend; % array of positions of westend ;
array[STOCKPILE] of var POSITION: eastend; % array of positions of eastend ;
array[STOCKPILE] of var TIME: stack; % array of stacking start times ;
array[STOCKPILE] of var TIME: endstack; % array of stacking end times ;
array[STOCKPILE] of var TIME: reclaim; % array of reclaiming start times ;
array[STOCKPILE] of var TIME: finished; % array of reclaiming end times ;
array[STOCKPILE] of var RECLAIMER: which; % array of which reclaimers used ;


% 1) what's the relation between endstack and stack times
constraint forall(s in STOCKPILE)(endstack[s] = stack[s] + size[s]*stack_time);
% 2) what's the relation between finished and stack times
constraint forall(s in STOCKPILE)(stack[s] < finished[s]);
% 3) what's the relation between reclaim and endstack times
constraint forall(s in STOCKPILE)(endstack[s] <= reclaim[s]);
% 4) what's the relation between finished and reclam times
constraint forall(s in STOCKPILE)(finished[s] = reclaim[s] + size[s]*reclaim_time);
% 5) what's the relation between eastend and westend offsets
constraint forall(s in STOCKPILE)(eastend[s] = westend[s] + size[s]);
% 6) packing problem
%    a) stockpiles should not overlap in "spacetime", treat them as rectangles
constraint forall(s1, s2 in STOCKPILE where s1>s2)(finished[s1]<=stack[s2] \/ finished[s2]<=stack[s1] \/ eastend[s1]<=westend[s2] \/ eastend[s2]<=westend[s1]);
%    b) stockpiles can't use more space than there is available
constraint forall(s in STOCKPILE)(eastend[s] <= len);
%    c) we can't go beyond the time limit
constraint forall(s in STOCKPILE)(finished[s] <= maxtime);  
 
  
% Stage B 
% Two stockpiles reclaimed by the same reclaimer do not overlap in time
%
% Tip: write your first custom predicate, i.e.
predicate not_overlap(var STOCKPILE: s1, var STOCKPILE: s2) = finished[s1]<=reclaim[s2] \/ finished[s2]<=reclaim[s1] \/ which[s1]!=which[s2];
constraint forall(s1, s2 in STOCKPILE where s1>s2)(not_overlap(s1,s2));



% Stage C
% 1) no stockpile can be reclaimed onto a ship before the arrival time of the ship
constraint forall(s in STOCKPILE)(arrival[ship[s]]<=reclaim[s]);
% 2) also no two stockpiles can be reclaimed onto the same ship at the same time. Make sure these reclaims do not overlap in time.
% TIP: reuse your "not_overlap" predicate
predicate not_overlap_ship(var STOCKPILE: s1, var STOCKPILE: s2) = finished[s1]<=reclaim[s2] \/ finished[s2]<=reclaim[s1] \/ ship[s1]!=ship[s2];
constraint forall(s1, s2 in STOCKPILE where s1>s2)(not_overlap_ship(s1,s2));

% Stage D
% Add constraints to your model to ensure that if a reclaimer finishes reclaiming a stockpile with westend at x and then has to start reclaiming a stockpile with westend at y there is at least |y − x| ∗ reclaim speed time between these two events.
% TIP: just make your "not_overlap" predicate smarter
% TIP: you can introduce local variables in the constraints/predicates
% let {
%  <local variables>
% } in <then something>
predicate not_overlap_time(var STOCKPILE: s1, var STOCKPILE: s2) = finished[s1] + abs(westend[s1] - westend[s2]) * reclaim_speed  <=reclaim[s2] \/ finished[s2] + abs(westend[s1] - westend[s2]) * reclaim_speed <= reclaim[s1] \/ which[s1]!=which[s2];

constraint forall(s1, s2 in STOCKPILE where s1>s2)(not_overlap_time(s1,s2));


% Stage E
% Add a definition of the objective to your model and change the model to minimize this value.
% You may well need to significantly change your search strategy to get good solutions for the objective.

% TIP: definetely change the line below

var int: obj = sum([max(s in STOCKPILE where ship[s] = sh)(finished[s]) - arrival[sh] | sh in SHIP]);

solve :: int_search(reclaim, input_order, indomain_min, complete) minimize obj;

% don't change the output
output 
["westend  = ", show(westend), ";\n"] ++
["eastend  = ", show(eastend), ";\n"] ++
["stack    = ", show(stack), ";\n"] ++
["endstack = ", show(endstack), ";\n"] ++
["reclaim  = ", show(reclaim), ";\n"] ++
["finish   = ", show(finished) , ";\n"] ++
["which    = ", show(which), ";\n"] ++
["obj = ",show(obj), ";\n"]
;