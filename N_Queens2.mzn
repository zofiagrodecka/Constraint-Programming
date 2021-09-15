include "at_most.mzn";

% VARIABLES 
int: n;
array[1..n, 1..n] of var bool: qb;
  
% CONSTRAINTS 

constraint sum(bool2int([qb[i,j] | i,j in 1..n])) == n;                           
constraint forall(i in 1..n)(at_most(1, [bool2int(qb[i,j]) | j in 1..n], true)); % wiersze
constraint forall(i in 1..n)(at_most(1, [bool2int(qb[j,i]) | j in 1..n],true)); % kolumny

constraint forall(a in 1-n..n-1)(sum(i,j in 1..n where i - j == a)(qb[i,j]) <=1);
constraint forall(a in 0..2*(n-1))(sum(i,j in 1..n where i + j == a)(qb[i,j]) <=1);
  
solve satisfy; 
  
% OUTPUT EXAMPLE  
output [ show(qb[i,j]) ++ " " | i,j in 1..n ];