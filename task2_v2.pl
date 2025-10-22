% Факты имеют вид: grade(группа, фамилия, предмет, оценка).

:- set_prolog_flag(encoding, utf8).

:- ['two.pl'].
% --- Вспомогательные предикаты ---

sum([], 0).
sum([H|T], S) :- sum(T, S1), S is S1 + H.

average([], 0).
average(List, Avg) :-
    length(List, N),
    N > 0,
    sum(List, Sum),
    Avg is Sum / N.

% Студент считается "не сдавшим", если у него есть хотя бы одна двойка
student_has_failed(Student) :-
    once(grade(_, Student, _, 2)).

% --- 1. Средний балл по каждому предмету ---

subjects(Subjects) :-
    setof(Subj, G^S^M^grade(G, S, Subj, M), Subjects).

subject_grades(Subject, Grades) :-
    findall(Mark, G^S^grade(G, S, Subject, Mark), Grades).

subject_average(Subject, Avg) :-
    subject_grades(Subject, Grades),
    average(Grades, Avg).

print_subject_averages :-
    subjects(Subjects),
    forall(member(Subject, Subjects),
           (subject_average(Subject, Avg),
            format('Предмет: ~w, Средний балл: ~2f~n', [Subject, Avg]))).

% --- 2. Количество не сдавших студентов в каждой группе ---

all_groups(Groups) :-
    setof(G, S^Subj^M^grade(G, S, Subj, M), Groups).

group_students(Group, Students) :-
    setof(S, Subj^M^grade(Group, S, Subj, M), Students).

failed_students_in_group(Group, FailedCount) :-
    group_students(Group, Students),
    include(student_has_failed, Students, FailedList),
    length(FailedList, FailedCount).

print_group_failed_counts :-
    all_groups(Groups),
    forall(member(Group, Groups),
           (failed_students_in_group(Group, Count),
            format('Группа: ~w, Не сдавших студентов: ~d~n', [Group, Count]))).

% --- 3. Количество не сдавших по каждому предмету ---

failed_in_subject(Subject, Count) :-
    findall(S, G^grade(G, S, Subject, 2), List),
    sort(List, UniqueList),  % на случай дубликатов (если один студент получил 2 дважды по одному предмету)
    length(UniqueList, Count).

print_failed_per_subject :-
    subjects(Subjects),
    forall(member(Subject, Subjects),
           (failed_in_subject(Subject, Count),
            format('Предмет: ~w, Не сдавших студентов: ~d~n', [Subject, Count]))).