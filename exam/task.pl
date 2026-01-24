% первый - попарно
swap_odd_even([], []).
swap_odd_even([A], [A]).
swap_odd_even([A, B | Tail], [B, A | New]) :- swap_odd_even(Tail, New).

% Второй вариант - все комбинаци
split_parity([], [], []).
split_parity([A], [A], []).
split_parity([A, B | T], [A | Odd], [B | Even]) :-  split_parity(T, Odd, Even).

interleave([], [], []).
interleave([O], [], [O]).
interleave([O | OT], [E | ET], [O, E | Rest]) :-
    interleave(OT, ET, Rest).

combine_permuted(Odd, Even, Result) :-
    permutation(Odd, PermOdd),
    permutation(Even, PermEven),
    interleave(PermOdd, PermEven, Result).

swap_all_parity(List, Result) :-
    split_parity(List, Odd, Even),
    combine_permuted(Odd, Even, Result).

all_parity_swaps(List, AllResults) :-
    findall(Result, swap_all_parity(List, Result), Results),
    sort(Results, AllResults).