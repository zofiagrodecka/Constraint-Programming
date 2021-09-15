include "alldifferent.mzn";

int: N = 1000;
set of int: indexes = 1..N;

array[indexes] of var indexes: rows;

constraint alldifferent(rows);
constraint alldifferent([rows[i] + i | i in indexes]);
constraint alldifferent([rows[i] - i | i in indexes]);

solve 
  %::int_search(rows, input_order, indomain_min, complete)
  %::int_search(rows, input_order, indomain_median, complete)
  %::int_search(rows, first_fail, indomain_min, complete)
  %::int_search(rows, first_fail, indomain_median, complete)
  ::int_search(rows, most_constrained, indomain_min, complete) % the fastest for N=450, time: 900msec; for N=400 time: 719msec
  %::int_search(rows, first_fail, indomain_random, complete) % for N=450, time: 1s 198msec; for N=400 time: 965msec
  %::int_search(rows, occurrence, indomain_split, complete)  % for N=450, time: 989msec; for N=400 time: too long
  %::int_search(rows, most_constrained, indomain_reverse_split, complete) % for N=450, time: 1s 132msec; for N=400 time: 915msec
satisfy; 
  
output [ if fix(rows[j]) == i then "|Q" else "|_" endif ++
  if j == N then "\n" else "" endif | i,j in 1..N];