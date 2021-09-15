%%%%%%%%%%%
% REMINDER 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% There's something missing here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
include "alldifferent.mzn";

%%%%%%%%%%%
% PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial state of the board
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
int: S=3;
int: N = S*S;
set of int: PuzzleRange = 1..N;
array[PuzzleRange, PuzzleRange] of var 0..N: board;

%%%%%%%%%%% 
% VARIABLES  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You know...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
array[PuzzleRange, PuzzleRange] of var PuzzleRange: puzzle;

%%%%%%%%%%%%%%%%
% Constraints 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - you know the sudoku rules
% - remember, that you have to preserve the initial state of the board  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constraint forall(i,j in PuzzleRange)(if board[i,j] > 0 then puzzle[i,j] = board[i,j] endif ); 
constraint forall (i in PuzzleRange)(alldifferent(j in PuzzleRange)(puzzle[i,j])); 
constraint forall(j in PuzzleRange)(alldifferent(i in PuzzleRange)(puzzle[i,j])); 
constraint forall (i,j in 1..S)(alldifferent(w,k in 1..S)(puzzle[(i-1)*S + w, (j-1)*S + k]));

solve satisfy;

%%%%%%%%%%%%%%%%%%%%
% OUTPUT EXAMPLE  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - puzzle - 2d array of nxn variables
% - N - size of the board, equal S*S         
% - S - size of a single sector            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

output [ show(puzzle[i,j]) ++ " " ++
  if j mod S == 0 then " " else "" endif ++ if j == N /\ i != N then
  if i mod S == 0 then "\n\n" else "\n" endif else "" endif
    | i,j in PuzzleRange ] ++ ["\n"];