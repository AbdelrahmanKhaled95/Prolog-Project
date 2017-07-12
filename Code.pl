% Authors: Abdelrahman Khaled Hussen,Kareem ismail and Islam el desoky
% Date: 4/2/2017

   %=============================================================    mycheck/1   ============================================================================%
%mycheck/1 perdicate >>>It check whether l is followed by r or not.
%First we have the base case which gives true for the empty list.
%If this is not the case, this rule fails and we enter the second rule.
%Second we have the recursive call,in which we check that if the Head of the given list (H) is w or c then we contine the call with the rest of the list.
%If this is not the case, this rule fails and we enter the third rule.
%Third when we have a l in the head( H1) of the list then the following element (H2) must be r,then we contine searching the rest of the list.
%If this is not the case, this rule fails and mycheck/1 return false.

mycheck([]).
mycheck([l]).
mycheck([H|T]):-
                  (H=w;
                  H=c),
                  mycheck(T).
mycheck([H1,H2|T]):-
                    H1=l,
                    H2=r,
                    mycheck(T).
                    
   %============================================================   list_to_llists/3  ========================================================================%
%list_to_llists/3 perdicate >>>It construct a list of list and the length of each list is (W).
%First we have the base cases 1)when the user enters zero as the length of the lists inside the LLists,2)When the user enters an empty list.
%Second we have the recursive call,in which we call the helper method (list_to_llists_helper)to loop on the list until either the w is zero or list becomes empty, the result is a list which is a partial solution
    %Ih list_to_llists_helper/3 we have also two base cases :
    %1)The W is greater than zero and the list is empty.and return an empty list
    %2)The W is zero and the list is not empty.and return an empty list
    %The last rule is the recurisve call,we first check if W is greater than zero,then we decrement the W by 1.
    %and finally we contuine the call by the rest of the list,and put the head of the list in the outputed list.
    %Note:: Every time we enter the rule we bound the (L1) of the list to the output list.
%then after returning from the Helper method (list_to_llists_helper) we use the pre-build prolog predicate append/3 and put the whole as the third argument
%and the outputed list from the helper method (list_to_llists_helper) as the first argument.This gives the the rest of the elements in the first list that we didn't use them in the first iteration.
%then we contuine the call with the rest of the unused elements until we hit the second base case (the list becames empty).
list_to_llists(_,0,[]).
list_to_llists([],_,[]):-!.
list_to_llists(L,W,[L1|R]):-
                          list_to_llists_helper(L,W,L1),
                          append(L1,L2,L),
                          length(L2,N),
                          N>=W,
                          list_to_llists(L2,W,R).
                          
list_to_llists(L,W,[L1|R]):-
                          list_to_llists_helper(L,W,L1),
                          append(L1,L2,L),
                          length(L2,N),
                          N<W,
                          list_to_llists([],W,R).
                          

list_to_llists_helper([],W,[]):- W>0.
list_to_llists_helper(_,0,[]).
list_to_llists_helper([H|T],W,[H|R]):-
                                      W>0,
                                      W1 is W-1,
                                      list_to_llists_helper(T,W1,R).



     %============================================================   getZeroth/2  ========================================================================%
%getZeroth/2 perdicate >>>It takes a list and return its first element as a head (H).
getZeroth([H|_],H).
     %============================================================     rest/2     ========================================================================%
%rest/2 perdicate >>>It takes a list and return its rest list (T) as output.
rest([],[]).
rest([_|T],T).
     %============================================================     subList/4  ========================================================================%
%subList/4 perdicate >>> We call a helper perdicate subList_helper/5 and it takes a counter starts from zero.
                %-------------------------------------------------------------------------------------------------------
                 %NOTE: WE ASSUMED THAT THE INDEX STARTS FROM INDEX ZERO ,THUS WE GAVE THE COUNTER INTIAL VALUE ZERO.
                %-------------------------------------------------------------------------------------------------------
%First base case is that the counter (N) is bigger or equal to I1 and the list is empty it return empty list.
%Second base case is when counter (N) is bigger than I2.It returns empty list.
%Third recursive rule is when counter (N) is smaller than I1 we ignore the head and increment the counter (N) and countine the rest list.
%fourth recursive rule is when counter (N) is equal or bigger than I1 and smaller or equal to I2 (meaning we are in the specified range).Here we take the head (H) of the list and countine the rest list.
%Finally we keep calling the  recursive rule until we hit the base case.
subList(I1,I2,L,Sub) :-
                       subList_helper(I1,I2,0,L,Sub).
subList_helper(I1,_,N,[],[]):-N>=I1.
subList_helper(_,I2,N,_,[]):-N>I2,!.
subList_helper(I1,I2,N,[_|T],Sub):-
                                  N<I1,
                                  N1 is N+1,
                                  subList_helper(I1,I2,N1,T,Sub).
subList_helper(I1,I2,N,[H|T],[H|Sub]):-
                                  N>=I1,
                                  N=<I2,
                                  N1 is N+1,
                                  subList_helper(I1,I2,N1,T,Sub).

               %===============================================     collect_hints/1   =============================================================%
%collect_hints/1 perdicate >>>Here we call the set_of/3 proplog pre-build perdicate.
%set_of/3 takes the first argument as a list of three variables ,while the second argument is the perdicate at which it is our (Hints or Facts).And ...
%the Last argument is the list that consists of lists (bag) carring our facts.
collect_hints(H):-
     setof(at(X,Y,Z), at(X, Y, Z), H).
              %=====================================================     ensure_hints/4    ======================================================%
%ensure_hints/4 perdicate >>>It takes a full grid (L) with its width (W) and its Height (H) and a collection of hints.
%First it multiply the (w) and (H) to get their product (N) and construct a list with (N) elements using the pre-defined prolog length/2 perdicate.
%Second it calls the  list_to_llists/3 perdicate.we can imagine the row to be the lists and the elements inside each list represents the the column number.
%Third we call the remove_unused/4 which takes the Hints according to the given grid size.(see the details below).
%Fourth we call the surf_grid/2 predicate which takes the grid as list of lists and a list of hints and does the following:
                        %First rule is the base case,in which the list of hints is empty and it returns true.
                        %Second rule is the recursive rule,in which we check every list in list of hints with the X-cordinate and Y-cordinate and Z as element in this cell,...
                        %and compare it with the element found in the corsponding place in the lists of lists of a grid.
                        %We used the build in prolog predicate nth0/3 which takes first argument as index to search and the second argument is the list to search in and the third argument is the output object.
                        %For example "nth0(1,[1,3,5,7],E)"the E is 3 as the index starts from zero.
                        %So the first nth0/3 perdicate is used to get the correct list of hint
                        %While the second nth0/3 perdicate is used to get the element from the chosen list.
                        %then, we compare the chosen element with the element from the list of hints.
                        %then we contuine the search until the list of hints becames empty.
ensure_hints(L,Hints,W,H):-
                           N is W*H,
                           length(L,N),
                           list_to_llists(L,W,LLists),
                           surf_grid(LLists,Hints).

surf_grid(_,[]).
surf_grid(LLists,[at(X,Y,Z)|T]):-
                             nth0(Y,LLists,List),
                             nth0(X,List,O),
                             Z=O,
                             surf_grid(LLists,T).
                             

           %=====================================================     random_assignment/1    =======================================================%
%random_assignment/1 perdicate >>>It fills the empty location of a grid with any random possible value (C,W,L,r).
%Base Case is when the list is empty it returns true.
%First Recursive Case is when the list is not empty and we fill the head element with water (w) and continue with the rest list.
%Second Recursive Case is when the list is not empty and we fill the head element with left vessel (l) and continue with the rest list.
%Third Recursive Case is when the list is not empty and we fill the head element with right vessel (r) and continue with the rest list.
%Fourth Recursive Case is when the list is not empty and we fill the head element with submarine (c) and continue with the rest list.
%Finally we keep calling using the rest of the ist until we hit the base case.

random_assignment([]).
random_assignment([w|L]):- random_assignment(L).
random_assignment([l|L]):- random_assignment(L).
random_assignment([r|L]):- random_assignment(L).
random_assignment([c|L]):- random_assignment(L).

          %=====================================================     check_rows/4          ==========================================================%
%check_rows/4 perdicate >>>It converts the Whole big List of grid unto a list of lists by list_to_llists/3 perdicate.
%It has a helper method check_rows_helper/4 .
%In the helper method check_rows_helper/4 we have the following:
        %the base case with an empty list ,it returns true.
        %the recursive call is :
        %1)getZeroth/2 to get the first list in the list of lists (as each list represents a row and each element inside the list represents the columns).
        %2)rest /2 to get the rest lists.
        %3)we defined a helper perdicate get_sum_row/2 to count the occurrence of specific elements like (l,r,c) in each row.
        %4)check the sum of the list with the corsponding number in the Totals list.
        %5)continue the recursive call with rest of list of lists until it is empty.


check_rows(L,W,Hei,Totals):-
                           list_to_llists(L,W,LLists),
                           check_rows_helper(LLists,W,Hei,Totals).
check_rows_helper([],_,_,_).
check_rows_helper(L,W,Hei,[H|T]):-
                           getZeroth(L,Head),
                           rest(L,Tail),
                           get_sum_row(Head,Sum),
                           H=Sum,
                           check_rows_helper(Tail,W,Hei,T).

%get_sum_row/2 perdicate >>>It just counts the occurrence of some elements like (c,l,r) in the list.
get_sum_row([],0).
get_sum_row([H|T],Sum):-
                        H\=w,
                        get_sum_row(T,S),
                        Sum is S +1.
get_sum_row([H|T],Sum):-
                        H=w,
                        get_sum_row(T,Sum).

         %=====================================================     check_columns/4          ==========================================================%
%check_columns/4 perdicate >>>It first convert the whole grid list into a list of lists then we call a helper method check_columns_helper/4:
                 %Base Case is called when the list is a list of empty lists and we flatten it by using the pre-build prolog perdicate flatten/2 .
                 %Recursive call,in which we 1)call get_sum_column/4 (see its description below) and we take the new grid after removing the first column (Tail).
                                            %2)Check if the sum of the first column is equal to the number in the first element of Totals List.
                                            %3)we countine to the calling with (Tail) until the list empty and we hit the base case.

check_columns(L,W,H,Totals):-
                             list_to_llists(L,W,LLists),
                             check_columns_helper(LLists,W,H,Totals).
                          
check_columns_helper(L,_,_,_):-flatten(L,[]).
check_columns_helper(L,W,Hei,[H|T]):-
                                   get_sum_column(L,Hei,Sum,Tail),
                                    H=Sum,
                                   check_columns_helper(Tail,W,Hei,T).

%get_sum_column/4 perdicate >>>Its  function is to check every first element of the lists in the list of lists,And return the rest of each list in the list if lists
%for example if we have a list of lists consisting of [[1,2,3],[4,5,6],[7,8,9]],the perdicate we always check 1,4,7 because each one of them represents a column.
%First base case is called when we have the list of lists empty and the height is zero we return the rest of each list as empty list and zero as a sum.
%Second base case is when the list becomes empty and the height is not zero yet,thus partial grid was given and it return empty tail.
%Third in recursive call:1)we check that handle every list (Row)in the list of lists.
                         %2)we get the first element of each list and see whether it is (l,r,c) to count it or (w) to ignore it.
                         %3)then,we decrement the number of lists after each list we finsh.
                         %4)we keep going until the rows are equal to zero and the list of lists are zero.
get_sum_column([],0,0,[]).
get_sum_column([],_,0,[]).
get_sum_column([H|T],Height,Sum,[Tail|L]):-
                              Height>0,
                              getZeroth(H,Head),
                              rest(H,Tail),
                              Head\=w,
                              H1 is Height-1,
                              get_sum_column(T,H1,S,L),
                              Sum is S+1.
get_sum_column([H|T],Height,Sum,[Tail|L]):-
                              Height>0,
                              getZeroth(H,Head),
                              rest(H,Tail),
                              Head=w,
                              H1 is Height-1,
                              get_sum_column(T,H1,Sum,L).
       %=====================================================       check_destroyer/4       ==========================================================%
%check_destroyer/4 perdicate >>> It is used to count the destroyers vessels (l,r) in the grid.
%First Base case is when the list is empty and Height of grid is zero,we just return zero as the count of destroyers in the empty list.
%Second base case is when the list is empty and Height of grid is bigger than zero,we just return one as as the count of destroyers.
%Recursive Case :
%we check if the height of the grid is bigger than zero and we decrement the Width of the grid by 1 to take a sublist from the grid by using subList/4 perdicate ....
%which returns a sub list corrsponding to the width,then we call a helper method check_destroyer_helper/2 (see discription below),and we get the rest of the grid ...'
%By using append/3 ,Finally we decrement the Height of the grid and  count the sum which comes from the helper list.
check_destroyer([],_,0,0).
check_destroyer([],_,H,1):-H>0.
check_destroyer(L,W,H,TotalDestroyer):-
                                             H>0,
                                            W1 is W-1,
                                            subList(0,W1,L,Sub),
                                            check_destroyer_helper(Sub,Sum),
                                            append(Sub,L2,L),
                                            H1 is H-1,
                                            check_destroyer(L2,W,H1,S),
                                            TotalDestroyer is S+Sum.
                                            
%check_destroyer_helper/2 perdicate >>> to count the object in the grid.
%Base Case :empty list returns zero.
%First Recursive rule:if we hit (l) followed by any object (w,c,r) we count it.
%Second Recursive rule:if we hit any object (w,c,r) .we ignore it.
check_destroyer_helper([],0).
check_destroyer_helper([l,_|T],S):-
                               check_destroyer_helper(T,Sum),
                               S is Sum+1.

check_destroyer_helper(L,S):-
                               getZeroth(L,Head),
                                (Head=w;Head=c;Head=r),
                               rest(L,Tail),
                               check_destroyer_helper(Tail,S).
      %=====================================================       check_submarines/4       ==========================================================%
%check_submarines/4  perdicate >>> It is used to count the submarines  (c) in the grid.
%Frist Base case is when the list is empty and the height of the grid is zero we just return zero as the count of submarines in the empty list.
%Second Base case is when the list is empty and the height of the grid is bigger than zero we just return zero as the count of submarines in the empty list.
%Recursive Case :
%we check if the height of the grid is bigger than zero and we decrement the Width of the grid by 1 to take a sublist from the grid by using subList/4 perdicate ....
%which returns a sub list corrsponding to the width,then we call a helper method check_submarines_helper/2 (see discription below),and we get the rest of the grid ...'
%By using append/3 ,Finally we decrement the Height of the grid and  count the sum which comes from the helper list.
check_submarines([],_,0,0).
check_submarines([],_,H,1):-H>0.
check_submarines(L,W,H,TotalSub):-
                                  H>0,
                                  W1 is W-1,
                                  subList(0,W1,L,Sub),
                                  check_submarines_helper(Sub,Sum),
                                  append(Sub,L2,L),
                                  H1 is H-1,
                                  check_submarines(L2,W,H1,S),
                                  TotalSub is S+Sum.

%check_submarines_helper/2 perdicate >>> to count the object in the grid.
%Base Case :empty list returns zero.
%First Recursive rule:we call the perdicate getZeroth/2 to check the first element of the list .
%if we hit (c), we count it.
%calling the rest/2 perdicate to get the tail of the list and countine recursive calling.
%Second Recursive rule:we call the perdicate getZeroth/2 to check the first element of the list .
%if we hit any object other than (c), we ignore it.
%calling the rest/2 perdicate to get the tail of the list and countine recursive calling.
check_submarines_helper([],0).
check_submarines_helper(L,S):-
                               getZeroth(L,c),
                               rest(L,Tail),
                               check_submarines_helper(Tail,Sum),
                               S is Sum+1.
                               
check_submarines_helper(L,S):-
                               getZeroth(L,Head),
                                (Head=w;Head=l;Head=r),
                               rest(L,Tail),
                               check_submarines_helper(Tail,S).

                               
     %=====================================================             battleship/7          ==========================================================%
%battleship/7 perdicate >>>It is the main program perdicate.It is here where all is called and we begin the game.
%First we call collect_hints/1 perdicate to list all the facts given to put them in bag collection and use them later on.
%then,we called remove_unused/4 see description below.and pass the variable (NewHints) to perdicate ensure_hints/4.
%Second we call ensure_hints/4 perdicate to assign the battleship vessels given by the facts in their correct position in the grid.
%Third we call the random_assignment/1 perdicate to fill the empty places in the grid.
%Fourth we call mycheck/1 to check that the grid resulted from both ensure_hints/4 and random_assignment/1 is satisfied and every (l) is followed by (r).
%Finally we check the count in the rows and columns and if they satisfied by the given inputs by using check_rows/4 and check_columns/4.
%And the same holds for check_destroyer/4 to check the count given for destroyers and check_submarines/4  to check the count given for submarines.

%================================================================   Hints   ===============================================================================%
%at(0,0,w).
at(2,0,c).
aat(2,1,r).
%at(2,3,w).
%at(3,5,c).
%at(5,0,w).
%at(9,6,c).
%=========================================================================================================================================================%
battleship(L,W,H,TotalSub,TotalDes,TotalRows,TotalColumns):-
                                                            collect_hints(Hints),
                                                            remove_unused(Hints,W,H,NewHints),  % See description below.
                                                            ensure_hints(L,NewHints,W,H),
                                                            random_assignment(L),
                                                            mycheck(L),
                                                            check_rows(L,W,H,TotalRows),
                                                            check_columns(L,W,H,TotalColumns),
                                                            check_destroyer(L,W,H,TotalDes),
                                                            check_submarines(L,W,H,TotalSub),
                                                            pretty_print(L,W,H).
                                                            
                                                            
                                                            
%remove_unused/4 perdicate >>> It takes the full List of Hints and returns only the needed Hints according to the length of the grid.
%Base Case:we have an empty list and we return an empty list.
%First recursive call we check the head of the list, if the X-coordinate (x) smaller than the width of grid (w) and also the  Y-coordinate (y) smaller than the height of grid .....
%we thus take this Hint with us and then,countine the search the rest list.
%Second Recursive call is if the if either the X-coordinate (x) bigger than or equal the width of grid (w) or the  Y-coordinate (y) bigger than or equal the height of grid ....
%we thus do not take thisHint with us and countine searching the rest of the list.
remove_unused([],_,_,[]):-!.
remove_unused([H|T],W,Hei,[H|NewHints]):-
                                   H=at(X,Y,_),
                                   X<W,
                                   Y<Hei,
                                   remove_unused(T,W,Hei,NewHints).
remove_unused([H|T],W,Hei,NewHints):-
                                   H=at(X,Y,_),
                                   (X>=W;
                                   Y>=Hei),
                                   remove_unused(T,W,Hei,NewHints).
                                   
%==============================================================================================================================================================
                                   
maplist(_, [], []).
maplist(P, [X|Xs], [Y|Ys]) :-
        call(P, X, Y),
        maplist(P, Xs, Ys).

pretty_print([],_,_).
pretty_print([Head|Tail],W,H):-
                        %print(pretty_print_h(W,[Head|Tail],L1)),
                        pretty_print_h([Head|Tail],W,L1),
                        pretty_print(L1,W,H).

pretty_print_h(Rest,0,Rest):-nl.
pretty_print_h([],N,[]):-N>0,nl.
pretty_print_h([H|T],W,Rest):-
                            W>0,
                            print(H),print(' '),
                            W1 is W -1 ,
                            pretty_print_h(T,W1,Rest).