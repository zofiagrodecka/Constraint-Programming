include "count.mzn";

% PARAMETERS        
int: n;
set of int: Indexes = 0..n-1;

% VARIABLES        
array[Indexes] of var int: magic;

% Constraints 

constraint forall(i in Indexes)(count(magic, i, magic[i]));
constraint sum(i in Indexes)(magic[i]) = n;
constraint sum(i in Indexes)(magic[i]*i) = n;
    
solve satisfy;

% EXAMPLE OUTPUT  
output [ "magic sequence = ", show(magic),";\n"];