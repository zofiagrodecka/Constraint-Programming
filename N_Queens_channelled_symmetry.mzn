include "alldifferent.mzn";
include "lex_lesseq.mzn";
include "at_most.mzn";

% Model 1
int: N;
array[1..N] of var 1..N: rows;

constraint alldifferent(rows);
constraint alldifferent([rows[i] + i | i in 1..N]);
constraint alldifferent([rows[i] - i | i in 1..N]);

% Model 2
array[1..N,1..N] of var bool: qb;

constraint sum(bool2int([qb[i,j] | i,j in 1..N])) == N;                           
constraint forall(i in 1..N)(at_most(1, [bool2int(qb[i,j]) | j in 1..N], true)); % wiersze
constraint forall(i in 1..N)(at_most(1, [bool2int(qb[j,i]) | j in 1..N],true)); % kolumny
constraint forall(a in 1-N..N-1)(sum(i,j in 1..N where i - j == a)(qb[i,j]) <=1);
constraint forall(a in 2..2*N)(sum(i,j in 1..N where i + j == a)(qb[i,j]) <=1);

% Channeling constraint
constraint forall (i,j in 1..N) ( qb[i,j] <-> (rows[i]=j) );

% Symmetry breaking constraints
constraint
    lex_lesseq(array1d(qb), [ qb[j,i] | i,j in 1..N ])
/\  lex_lesseq(array1d(qb), [ qb[i,j] | i in reverse(1..N), j in 1..N ])
/\  lex_lesseq(array1d(qb), [ qb[j,i] | i in 1..N, j in reverse(1..N) ])
/\  lex_lesseq(array1d(qb), [ qb[i,j] | i in 1..N, j in reverse(1..N) ])
/\  lex_lesseq(array1d(qb), [ qb[j,i] | i in reverse(1..N), j in 1..N ])
/\  lex_lesseq(array1d(qb), [ qb[i,j] | i,j in reverse(1..N) ])
/\  lex_lesseq(array1d(qb), [ qb[j,i] | i,j in reverse(1..N) ]);

solve satisfy; 

output [ if fix(rows[j]) == i then "|Q" else "|_" endif ++
  if j == N then "\n" else "" endif | i,j in 1..N];