% Факты имеют вид: grade(группа, фамилия, предмет, оценка).

:- set_prolog_flag(encoding, utf8).

:- ['two.pl'].
sum([], 0).
sum([H|T], S) :- sum(T, S1), S is S1 + H.

average([], 0).
average(List, Avg) :-
    length(List, N),
    N > 0,
    sum(List, Sum),
    Avg is Sum / N.

% Студент считается "не сдавшим", если у него есть хотя бы одна двойка
has_failed(Student) :-
    once(grade(_, Student, _, 2)).

% Средний балл по каждому предмету
subjects(Subjects) :-
    setof(Subj, G^S^M^grade(G, S, Subj, M), Subjects).

subject_grades(Subject, Grades) :-
    findall(Mark, grade(_, _, Subject, Mark), Grades).  

subject_average(Subject, Avg) :-
    subject_grades(Subject, Grades),
    average(Grades, Avg).

print_sub_averages :-
    subjects(Subjects),
    forall(member(Subject, Subjects),
           (subject_average(Subject, Avg),
            format('~w : ~2f~n', [Subject, Avg]))).

%Количество не сдавших студентов в каждой группе

groups(Groups) :-
    setof(G, S^Subj^M^grade(G, S, Subj, M), Groups).

group_students(Group, Students) :-
    setof(S, Subj^M^grade(Group, S, Subj, M), Students).

failed_in_group(Group, FailedCount) :-
    group_students(Group, Students),
    include(has_failed, Students, FailedList),
    length(FailedList, FailedCount).

p_group_failed_st :-
    groups(Groups),
    forall(member(Group, Groups),
           (failed_in_group(Group, Count),
            format('~w : ~d~n', [Group, Count]))).

%Количество не сдавших по каждому предмету
failed_in_subj(Subject, Count) :-
    findall(S, grade(_, S, Subject, 2), List),  
    sort(List, UniqueList),  % на случfq нескольких провалов
    length(UniqueList, Count).

p_failed_subj :-
    subjects(Subjects),
    forall(member(Subject, Subjects),
           (failed_in_subj(Subject, Count),
            format('~w : ~d~n', [Subject, Count]))).