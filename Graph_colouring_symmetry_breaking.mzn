% PARAMETERS
int: minColorsNumber;
set of int: clique = 1..minColorsNumber;
array[clique] of int: maxClique;
int: nodesNumber;
set of int: graph = 1..nodesNumber;
array[graph, graph] of bool: edges;

% VARIABLES         
array[graph] of var graph: nodes;
var graph: colorsNumber = max([nodes[i] | i in graph]);

% CONSTRAINTS
constraint forall(i,j in graph)(if edges[i, j] = true then nodes[i] != nodes[j] endif);
constraint forall(i in clique)(nodes[maxClique[i]] = i) ;

solve minimize colorsNumber;

% OUTPUT
output [show(colorsNumber), " colors\n",] ++
       [show(nodes[i]) ++ " " | i in graph]
