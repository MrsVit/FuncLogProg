% ЗАДАНИЕ 2, ВАРИАНТ 3

% Факты имеют вид: grade(группа, фамилия, предмет, оценка).

:- set_prolog_flag(encoding, utf8).

:- ['two.pl'].

sum([], 0).
sum([H|T], S) :- sum(T, S1), S is S1 + H.

average([], 0).
average(List, Avg) :-
    sum(List, Sum),
    length(List, N),
    N > 0,
    Avg is Sum / N.

% возвращаем список всех уникальных фамилий студентов
all_students(List) :- setof(S, G^Subj^M^grade(G, S, Subj, M), List).

% возвращаем список всех оценок и средний балл конкретного студента
student_grades(Student, Grades) :-
    findall(Mark, G^Subj^grade(G, Student, Subj, Mark), Grades).
student_avg(Student, Avg) :-
    student_grades(Student, Grades),
    average(Grades, Avg).

%если есть двойка студент не сдал
student_passed(Student, 'не сдал') :-
    student_grades(Student, Grades),
    member(2, Grades), !.
student_passed(_, 'сдал').

% получаем фамилию студента,
% его средний балл и статус сдачи («сдал» / «не сдал»)
print_student_stats(Student, Avg, Status) :-
    all_students(Students),
    member(Student, Students),
    student_avg(Student, Avg),
    student_passed(Student, Status).

% коичество заваливших сессию студентов
failed_in_subject(Subject, Count) :-
    findall(S, G^grade(G, S, Subject, 2), List),
    length(List, Count).

subjects(List) :- setof(Subj, G^S^M^grade(G, S, Subj, M), List).

%  для каждого предмета выводим количество несдавших
print_failed_per_subject(Subject, Count) :-
    subjects(Subjects),
    member(Subject, Subjects),
    failed_in_subject(Subject, Count).

group_students(Group, Students) :-
    setof(S, Subj^M^grade(Group, S, Subj, M), Students).

all_groups(List) :- setof(G, S^Subj^M^grade(G, S, Subj, M), List).

student_group_avg(Group, Student, Avg) :-
    findall(M, Subj^grade(Group, Student, Subj, M), Grades),
    average(Grades, Avg).

max_avg_in_group(Group, MaxAvg) :-
    findall(Avg,
        S^(group_students(Group, Students),
           member(S, Students),
           student_group_avg(Group, S, Avg)),
        Avgs),
    max_list(Avgs, MaxAvg).

top_students_in_group(Group, Student, MaxAvg) :-
    max_avg_in_group(Group, MaxAvg),
    group_students(Group, Students),
    member(Student, Students),
    student_group_avg(Group, Student, Avg),
    Avg =:= MaxAvg.

print_group_top_students(Group, Student, MaxAvg) :-
    all_groups(Groups),
    member(Group, Groups),
    top_students_in_group(Group, Student, MaxAvg).