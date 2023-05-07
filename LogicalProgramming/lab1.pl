% Model of a hospital

use_module(library(apply)).

% Medical professions and list of illnesses they treat
competence("Dentistry", ["Cavities", "Bad breath"]).
competence("Oncology", ["Leukemia", "Breast cancer", "Melanoma"]).
competence("Ophthalmology", ["Cataract", "Ocular trauma", "Ptosis"]).
competence("Psychiatry", ["Generalized anxiety disorder", "Post-traumatic stress disorder", "Major depressive disorder", "Bipolar disorder", "Schizofrenia", "Narcissistic personality disorder", "Dissociative identity disorder"]).
competence("Gynecology", ["Infertility, Prolapse of pelvic organs", "Post-monopausal osteoporosis"]).
competence("Cardiology", ["Heart failure", "Coronary artery disease"]).
competence("Dermatology", ["Skin infections", "Eczema", "Skin burn"]).

% doctor(id, name, specialization) doctor's id starts with `1`
doctor(10, "Joe Schmoe", "Dentistry").
doctor(11, "Fred Nerk", "Oncology").
doctor(12, "Juan Perez", "Ophthalmology").
doctor(13, "Nigel Nigel", "Psychiatry").
doctor(14, "Garry Stu", "Gynecology").
doctor(15, "Gordon Norman", "Cardiology").
doctor(16, "Norman Gordon", "Dermatology").

% Lists of patients who made an appointment to a specific doctor
% Key = DoctorId
?- recorda(10, [], _).
?- recorda(11, [], _).
?- recorda(12, [], _).
?- recorda(13, [], _).
?- recorda(14, [], _).
?- recorda(15, [], _).
?- recorda(16, [], _).

% patient(id, name, [illnesses]) patient's id starts with `2`
patient(20, "John Q. Public", ["Narcissistic personality disorder"]).
patient(21, "John Doe", ["Cavities"]).
patient(22, "Jane Smith", ["Breast cancer", "Ptosis"]).
patient(23, "Marry Sue", ["Prolaplse of pelvic organs"]).
patient(24, "Joe Bloggs", ["Skin infections", "Skin burn"]).
patient(25, "Tom, Dick and Harry", ["Dissociative identity disorder"]).

% finds doctors to treat patient's illnesses
% Usage:
% appointment(11, X). X will be the doctor's Id
find_doctor(PatientId, DoctorId) :-
  patient(PatientId, _, PatientIllnesses),
  member(PatientIllness, PatientIllnesses),
  competence(Specialization, Illnesses),
  member(PatientIllness, Illnesses),
  doctor(DoctorId, _, Specialization).

% adds patient to the doctor's appointments
% patients cannot appear more that one time
make_appointment(PatientId, DoctorId) :-
  patient(PatientId, _, PatientIllnesses),
  doctor(DoctorId, _, Specialization),
  member(Illness, PatientIllnesses),
  competence(Specialization, Illnesses),
  member(Illness, Illnesses),
  recorded(DoctorId, PatientsList),
  not(member(PatientId, PatientsList)),
  append(PatientsList, [PatientId], NewPatientsList),
  recorda(DoctorId, NewPatientsList).


% removes patient from doctor's appointments
remove_appointment(PatientId, DoctorId) :-
  recorded(DoctorId, PatientsList),
  delete(PatientsList, PatientId, NewPatientsList),
  recorda(DoctorId, NewPatientsList).

% self-explanatory, just a wrapper around `recorded`
get_patients_of(DoctorId, PatientIds) :-
  recorded(DoctorId, PatientIds).

% calculates the cost of the treatment of one Illness
% works only for illnesses defined with `competence` fact
% Yes, I do calculate the cost based on the length of the name. So what? You can't stop me.
treatment_cost(Illness, Cost) :-
  competence(_, Illnesses),
  member(Illness, Illnesses),
  string_length(Illness, Length),
  Cost is Length * 2.

% calculates total cost of treatment
visit_cost(PatientId, Cost) :-
  patient(PatientId, _, PatientIllnesses),
  maplist(treatment_cost, PatientIllnesses, Costs),
  foldl(plus, Costs, 0, Cost).

% utility predicate
% reverses the order of parameters for `member` predicate
% this way it is possible to apply collection beforehand
r_member(List, El) :-
  member(El, List).

% selects only those illnesses from patient that can be trated by a doctor with a specific specialization
filter_illnesses_by_specialization(Specialization, PatientId, Illnesses) :-
  patient(PatientId, _, PatientIllnesses),
  competence(Specialization, CompetenceIllnesses),
  include(r_member(CompetenceIllnesses), PatientIllnesses, Illnesses).

% calculates doctor's salary based on the illnesses of the patients that made an appointment
salary_of(DoctorId, Salary) :-
  doctor(DoctorId, DoctorName, Specialization),
  get_patients_of(DoctorId, Patients),
  maplist(filter_illnesses_by_specialization(Specialization), Patients, IllnessesNested),
  flatten(IllnessesNested, IllnessesFlat),
  maplist(treatment_cost, IllnessesFlat, Costs),
  foldl(plus, Costs, 0, Cost),
  % I think it's pretty realistic that doctor's cut is about 30% of all earnings
  % And yes the longer your name is, the less money you get
  string_length(DoctorName, L),
  Salary is (0.3 + 1 / (2 * L)) * Cost.
