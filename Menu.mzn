% constant parameters:
set of int: Indexes = 1..menu_length;
int: menu_length; 
int: money_limit;

array[Indexes] of int: menu_prices;
array[Indexes] of string: menu_names;
array[Indexes] of int: yumyum_factors; % the bigger the number, the more we like the meal

%variables:
array[Indexes] of var 0..infinity: order;

%constraints
constraint assert(menu_length > 0, "Incorrect value: " ++ show(menu_length) ++ "Length of the menu should be positive");
constraint assert(forall([menu_prices[i] >= 0 | i in Indexes]), "Error: price of all items should be positive!");
constraint trace("Checking if there's a correct limit of money.\n", assert(money_limit > 0, "Incorrect value: " ++ show(money_limit) ++ " Money limit should be positive"));

constraint trace ("Adding a constraint: We don't have to spend all the money we have.\n", sum([order[i] * menu_prices[i] | i in Indexes]) <= money_limit);

solve maximize sum([order[i]*yumyum_factors[i] | i in Indexes]);

output [menu_names[i] ++ ": " ++ show(order[i]) ++ "\n" | i in Indexes]; 