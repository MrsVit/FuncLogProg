%отцы
father(aleksey_iv).
father(fedor_sem).
father(valentin_pet).
father(grigoriy_ark).
%сфновья
son(lenya).
son(andrey).
son(tima).
son(kolya).
% проверка уникальности
one([]):-!.
one([A|B]):-
    member(A,B),!,fail;
    one(B).

% решение
answer(Answer):-
    Answer = [
        [F1, S1],  % отец и его сын
        [F2, S2],
        [F3, S3],
        [F4, S4]
    ],
    father(F1), father(F2), father(F3), father(F4),
    son(S1), son(S2), son(S3), son(S4),
    F1 \= F2, F1 \= F3, F1 \= F4,
    F2 \= F3, F2 \= F4,
    F3 \= F4,
    one([S1, S2, S3, S4]),
    % кабины как кортежики (взрослый, мальчик)
    Cabin1 = (aleksey_iv, lenya),
    Cabin2 = (FatherOfKolya, andrey),
    Cabin3 = (FatherOfAndrey, tima),
    Cabin4 = (fedor_sem, SonOfValentin),
    Cabin5 = (valentin_pet, SonOfAleksey),
    % ищем отцов
    member([FatherOfKolya, kolya], Answer),
    member([FatherOfAndrey, andrey], Answer),
    member([valentin_pet, SonOfValentin], Answer),
    member([aleksey_iv, SonOfAleksey], Answer),
    Cabins = [Cabin1, Cabin2, Cabin3, Cabin4, Cabin5],
    % проверка: ни один мальчик не катается со своим отцомм
    \+ (member((F, S), Cabins), member([F, S], Answer)),

    SonOfAleksey \= lenya,
    SonOfValentin \= andrey,
    kolya \= andrey,
    tima \= andrey,
    !.