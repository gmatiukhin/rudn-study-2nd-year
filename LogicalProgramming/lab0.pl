% Семейные отношения

person(4, "Maggy", female).
person(3, "Matt", male).

person(1, "Tom", male).
person(2, "Pam", female).

person(5, "Julia", female).
person(6, "Daemon", male).
person(7, "Tony", male).
person(8, "John", male).

% Семантика и последовательность атрибутов определяется программистом

% parent(Child, Parent) 
parent(4, 1).
parent(4, 2).

parent(3, 1).
parent(3, 2).

parent(1, 5).
parent(1, 6).

parent(2, 7).

parent(6, 8).


% строки: father("Matt", "Tom")
father(Child, Father) :-
    person(ChildId, Child, _),
    person(FatherId, Father, male),
    parent(ChildId, FatherId).

% Последующие предикаты необходимо реализовать самостоятельно 
mother(Child, Mother) :-
    person(ChildId, Child, _),
    person(MotherId, Mother, female),
    parent(ChildId, MotherId).
  
grandfather(Person, Grandfather) :-
    person(PersonId, Person, _),
    person(GrandfatherId, Grandfather, male),
    parent(PersonId, ParentId),
    parent(ParentId, GrandfatherId).

grandmother(Person, Grandmother) :- 
    person(PersonId, Person, _),
    person(GrandmotherId, Grandmother, female),
    parent(PersonId, ParentId),
    parent(ParentId, GrandmotherId).

sister(Person, Sister) :-
  person(PersonId, Person, _),
  person(SisterId, Sister, female),
  parent(PersonId, ParentId),
  parent(SisterId, ParentId),
  not(Person = Sister).

brother(Person, Brother) :-
  person(PersonId, Person, _),
  person(BrotherId, Brother, male),
  parent(PersonId, ParentId),
  parent(BrotherId, ParentId),
  not(Person = Brother).

ancestor(Person, Ancestor) :-
  person(PersonId,Person,_),
  person(AncestorId,Ancestor,_),
  parent(PersonId,AncestorId).

ancestor(Person,Ancestor) :-
  person(PersonId,Person,_),
  person(ParentId,Parent,_),
  parent(PersonId,ParentId),
  ancestor(Parent,Ancestor).
