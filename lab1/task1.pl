%реализация стандартных предикатов (соответствуют по названию без частицы my)

%вычисление длины списка
my_length([], 0).
my_length([_|T], N) :-
    my_length(T, N1),
    N is N1 + 1.
%проверка вхождения элемента в список (есть)
my_member(X, [X|_]).
my_member(X, [_|T]) :-
    my_member(X, T).
%конкатенация (дописывание одного к другому) двух списков
my_append([], L, L).
my_append([H|T], L, [H|R]) :-
    my_append(T, L, R).
%удаление первого вхождения X из спискаmy
my_remove(X, [X|T], T).
my_remove(X, [H|T], [H|R]) :-
    my_remove(X, T, R).
%генерация С (всех возможных перестановок)
my_permute([], []).
my_permute(L, [H|T]) :-
    my_remove(H, L, Rest),
    my_permute(Rest, T).
%проверка является ли sub подсписком для list
my_sublist(Sub, List) :-
    my_prefix(Sub, List).
my_sublist(Sub, [_|T]) :-
    my_sublist(Sub, T).
% +Вспомогательный: префикс
my_prefix([], _).
my_prefix([H|T1], [H|T2]) :-
    my_prefix(T1, T2).


%ЗАДАНИЕ 1.1 вариант 4

% remove_first_three(List, Result) c использованием стандартного предиката append
% Удаляет первые три элемента из списка List.
% Успешен только если в списке не менее трёх элементов.

remove_first_three(List, Result) :- append([_, _, _], Result, List).


%без использования стандартного предиката

%вариант 1 - при помощи стандартного механизма сопоставления
% remove_first_three_manual(List, Result)

remove_first_three_manual([_, _, _|Tail], Tail).

% вариант 2  - при помощи рекурсии
remove_first_three_rec(List, Result) :-
    remove_one(List, L1),
    remove_one(L1, L2),
    remove_one(L2, Result).

remove_one([_|T], T).

%ЗАДАНИЕ 1.2 ВАРИАНТ 8 - вычисление среднего арифметического


%с использованием стандартных предикатов
%вурнёт false, если список пуст

average(List, Avg) :-
    sum_list(List, Sum),
    length(List, Len),
    Len > 0,
    Avg is Sum / Len.

%рекурсивно
% Рекурсивный подсчёт суммы и количества элементов.
average_rec(List, Avg) :-
    sum_length(List, Sum, Length),
    Length > 0,
    Avg is Sum / Length.
%дополнительно, для одновременного вычисления и длины списка, и суммы элементов
sum_length([], 0, 0).
sum_length([H|T], Sum, Length) :-
    sum_length(T, SumT, LengthT),
    Sum is SumT + H,
    Length is LengthT + 1.


% пример совместного использования реализованных предикатов - вычисления среднего значения
% измерений некоторого физического прибора для какого-то объекта
% при условии, что первые три замера нужны для настройки и не несут полезной информации
measurement_average_manual(Measurements, Avg) :-
    remove_first_three_manual(Measurements, CleanedMeasurements),
    average_rec(CleanedMeasurements, Avg).