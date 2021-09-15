include "globals.mzn";

% Parameters
%%%%%%%%%%%
int: n;                      % How many squares do we have?
set of int: SQUARES = 1..n;  % Set of the available squares

% Variables
%%%%%%%%%%%
int: max1 = sum(i in SQUARES)(i);
int: max2 = max1 - n;
var n..max1: height;    % height of the container
var n..max1: width;     % width of the conainer
var n*n..max1*max1: area = height * width; % container's area
array[SQUARES] of var 0..max2: x; % squares' coordinates in the container
array[SQUARES] of var 0..max2: y; % squares' coordinated in the container
array[SQUARES] of var SQUARES: dx; % sizes of each square's side
  
% Symmetry breaking
%%%%%%%%%%%%%%%%%%%%
constraint width >= height;
  
% Constraints 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Constraint 1: Squares should fit inside the container
constraint forall(i in SQUARES)(x[i] + i <= width /\ y[i]+i <= height);
  
% Constraint 2: Squares should not overlap
constraint diffn(x,y,dx,dx);
constraint forall(i,j in 1..n)(if i < j then x[i] + i <= x[j] endif);
constraint forall(i,j in 1..n)(if i < j then x[i] >= x[j] + j endif);
constraint forall(i,j in 1..n)(if i < j then y[i] + i <= y[j] endif);
constraint forall(i,j in 1..n)(if i < j then y[i] >= y[j] + j endif);

% Constraint 3: Squares have different sizes
constraint forall(i in 1..n-1)(dx[i] < dx[i+1]);

% Constraint 4: cumulative
constraint cumulative(x, dx, y, height);
constraint cumulative(y, dx, x, width);

% Goal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
solve 
  %::seq_search([int_search(dx, input_order, complete), int_search(dx, input_order, complete)])
minimize area; 
  

% Boring output  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output [ show(i) ++ " > (" ++ show(x[i]) ++ "," ++ show(y[i]) ++ ") size: " ++ show(dx[i]) ++"\n" | i in 1..n] ++
  ["area = " ++ show(width) ++ " * " ++ show(height) ++ " = " ++ show(area)]