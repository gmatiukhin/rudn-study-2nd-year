% Model of a hospital

use_module(library(apply)).

% Medical professions and list of illnesses they treat
competence("Dentistry", ["Cavities", "Bad breath"]).
competence("Oncology", ["Leukemia", "Breast cancer", "Melanoma"]).
competence("Ophthalmology", ["Cataract", "Ocular trauma", "Ptosis"]).
competence("Psychiatry", ["Generalized anxiety disorder", "Post-traumatic stress disorder", "Major depressive disorder", "Bipolar disorder", "Schizofrenia", "Narcissistic personality disorder", "Dissociative identity disorder"]).
competence("Gynecology", ["Infertility", "Prolapse of pelvic organs", "Post-monopausal osteoporosis"]).
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

% utility predicate
% same as `patient`, just without the name
illnesses_by_id(PatientId, Illnesses) :-
  patient(PatientId, _, Illnesses).

% finds doctors to treat patient's illnesses
% Usage:
% appointment(11, X). X will be the doctor's Id
find_doctors(PatientId, DoctorsId) :-
  patient(PatientId, _, PatientIllnesses),
  maplist(doctor_by_illness, PatientIllnesses, DoctorsId).

doctor_by_illness(Illness, DoctorId) :-
  doctor(DoctorId, _, Specialization),
  competence(Specialization, Illnesses),
  member(Illness, Illnesses).

% adds patient to the doctor's appointments
% patients cannot appear more that one time
make_appointment(PatientId, DoctorId, Cost) :-
  patient(PatientId, _, PatientIllnesses),
  doctor(DoctorId, _, Specialization),
  member(Illness, PatientIllnesses),
  competence(Specialization, Illnesses),
  member(Illness, Illnesses),
  recorded(DoctorId, PatientsList),
  not(member(PatientId, PatientsList)),
  append(PatientsList, [PatientId], NewPatientsList),
  recorda(DoctorId, NewPatientsList),
  appointment_cost(PatientId, DoctorId, Cost).


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

% total cost of visiting a specific doctor
% it is assumed that the doctor treats all illnesses they can
appointment_cost(PatientId, DoctorId, Cost) :-
  patient(PatientId, _, PatientIllnesses),
  doctor(DoctorId, _, Specialization),
  filter_illnesses_by_specialization(Specialization, PatientIllnesses, Illnesses),
  maplist(treatment_cost, Illnesses, Costs),
  foldl(plus, Costs, 0, Cost).

% utility predicate
% reverses the order of parameters for `member` predicate
% this way it is possible to apply collection beforehand
r_member(List, El) :-
  member(El, List).

% selects only those illnesses from patient that can be trated by a doctor with a specific specialization
filter_illnesses_by_specialization(Specialization, Illnesses, FilteredIllnesses) :-
  competence(Specialization, CompetenceIllnesses),
  include(r_member(CompetenceIllnesses), Illnesses, FilteredIllnesses).

% calculates doctor's salary based on the illnesses of the patients that made an appointment
salary_of(DoctorId, Salary) :-
  doctor(DoctorId, DoctorName, Specialization),
  get_patients_of(DoctorId, Patients),
  maplist(illnesses_by_id, Patients, PIllnesses),
  maplist(filter_illnesses_by_specialization(Specialization), PIllnesses, IllnessesNested),
  flatten(IllnessesNested, IllnessesFlat),
  maplist(treatment_cost, IllnessesFlat, Costs),
  foldl(plus, Costs, 0, Cost),
  % I think it's pretty realistic that doctor's cut is about 30% of all earnings
  % And yes the longer your name is, the less money you get
  string_length(DoctorName, L),
  Salary is (0.3 + 1 / (2 * L)) * Cost.

% utility predicates to better format the ouput
say(Lst) :- is_list(Lst), writeln(Lst).
say(S)   :- say(S,[]).
say(S,P) :- string_concat(S, '~n', S1), format(S1,P).

% use this rule to run all exmaples one after the other
run_examples :-
  example1,
  example2,
  example3,
  example4.

% basic hospital operations
% patient makes an appointment to a doctor
% we calculate both the sum that the patient has to pay and the salary of the doctor
example1 :-
  say("\nThis is example 1.\n"),
  P is 21,
  patient(P, PN, PI),
  say("Patient ~w is ~w. Their illnesses are: ~w.", [P, PN, PI]),
  find_doctors(P, Ds),
  say("Doctors that can treat their illnesses have Ids: ~w", [Ds]),
  member(D, Ds),
  doctor(D, DN, DS),
  say("Their doctor will be: ~w. Their specialization is ~w.", [DN, DS]),
  get_patients_of(D, Ps1),
  say("Patients with these Ids are being treated by doctor ~w: ~w.", [DN, Ps1]),
  make_appointment(P, D, C),
  say("Patient ~w made an appointment to doctor ~w. It will cost them ~w imaginary units.", [PN, DN, C]),
  get_patients_of(D, Ps2),
  say("After this appointment patients with these Ids are being treated by doctor ~w: ~w.", [DN, Ps2]),
  salary_of(D, S),
  say("Doctor ~w will receive ~w imaginary units after treating patient ~w.", [DN, S, PN]),
  remove_appointment(P, D),
  get_patients_of(D, Ps3),
  say("Now patients with these Ids are being treated by doctor ~w: ~w.", [DN, Ps3]),
  say("\nEnd of example 1.").

% in this example two patients have the same doctor
example2 :-
  say("\nThis is example 2.\n"),
  P1 is 20,
  P2 is 25,
  patient(P1, P1N, P1I),
  patient(P2, P2N, P2I),
  say("Patient ~w is ~w. Their illnesses are: ~w.", [P1, P1N, P1I]),
  say("Patient ~w is ~w. Their illnesses are: ~w.", [P2, P2N, P2I]),
  find_doctors(P1, D1),
  find_doctors(P2, D2),
  D1 == D2,
  member(D, D1),
  doctor(D, DN, DS),
  say("Both patients have the same doctor. Their name is ~w, they are specialized in ~w.", [DN, DS]),
  make_appointment(P1, D, C1),
  make_appointment(P2, D, C2),
  say("Both patients made an appointment to doctor ~w. Their respective treatment costs are ~w and ~w.", [DN, C1, C2]),
  get_patients_of(D, Ps),
  say("Patients with these Ids are being treated by doctor ~w: ~w.", [DN, Ps]),
  salary_of(D, S),
  say("Doctor ~w will be pleased to receive ~w imaginary units after treating both patients.", [DN, S]),
  remove_appointment(P1, D),
  remove_appointment(P2, D),
  say("\nEnd of example 2.").

% in this example one patient has several illnesses that can be treated by the same doctor
example3 :-
  say("\nThis is example 3.\n"),
  P is 24,
  patient(P, PN, PI),
  say("Patient ~w is ~w. Their illnesses are: ~w.", [P, PN, PI]),
  find_doctors(P, Ds),
  sort(Ds, DsS),
  member(D, DsS),
  doctor(D, DN, DS),
  say("Their doctor will be: ~w. Their specialization is ~w.", [DN, DS]),
  make_appointment(P, D, C),
  say("Patient ~w made an appointment to doctor ~w. It will cost them ~w imaginary units.", [PN, DN, C]),
  salary_of(D, S),
  say("Doctor ~w will receive ~w imaginary units after treating both illnesses of ~w.", [DN, S, PN]),
  remove_appointment(P, D),
  say("\nEnd of example 3.").

% in this example one patient has several illnesses.
% they are treated by different doctors
example4 :-
  say("\nThis is example 4.\n"),
  P is 22,
  patient(P, PN, PI),
  say("Patient ~w is ~w. Their illnesses are: ~w.", [P, PN, PI]),
  find_doctors(P, Ds),
  maplist(doctor, Ds, DNs, DSs),
  say("Patient ~w has several illnesses. Doctors ~w can help them. Their respective medical fields are ~w", [PN, DNs, DSs]),
  maplist(make_appointment(P), Ds, Cs),
  foldl(plus, Cs, 0, C),
  say("~w made appointments to both of the doctors. Each appointment costs ~w respectively, together: ~w.", [PN, Cs, C]),
  maplist(salary_of, Ds, Ss),
  say("Doctors ~w will receive ~w imaginary units respectively after treating patient ~w.", [DNs, Ss, PN]),
  maplist(remove_appointment(P), Ds),
  say("\nEnd of example 4.").
