% Model of a hospital.
% This model allows simulation of appointment proccess in a hospital.
% There are several doctors with different specializations, who can treat different illnesses.
% Some patients have only one illness;
% some have multiple, for which they need the same doctor;
% some have different illnesses whatsoever and need to be treated by several different doctors.
% This model allows patients to find doctor/doctors they need, as well as to make an appointment.
% More tangential queries are also handled, e.g. calculating the cost of the treatment or the doctor's salary.
%
% You may find several examples at the bottom of the file
%
% NOTE:
% this model employs heavy usage of SWI-Prolog's built-in rules and predicates
% as well as the `apply` library for perfoming operations on lists "in bulk".
% THERE IS NO GUARANTEE that this model will work in any other version of Prolog such as Visual Prolog.
%
% INFO:
% CHANGELOG:
% 2023-05-29:
%   Now able to load competences, doctors and patients from their respective .csv files
% 2023-06-15:
%   Now some gui

:- use_module(library(apply)).
:- use_module(library(csv)).
:- use_module(library(pce)).

% Converts illnesses string entry into a list for a given competence
split_competence_illnesses(competence(Name, IllnessesString), competence(Name, IllnessesList)) :-
  split_string(IllnessesString, ",", "", IllnessesList).

% Loads all competences from a .csv file
prepare_competences :-
  csv_read_file("./competences.csv", Data, [functor(competence), arity(2)]),
  maplist(split_competence_illnesses, Data, Competences),
  maplist(assert, Competences).

% Loads all doctors from a .csv file
prepare_doctors :-
  csv_read_file("./doctors.csv", Data, [functor(doctor), arity(3)]),
  maplist(prepare_patients_lists, Data),
  maplist(assert, Data).

% Adds an empty list entry with doctor's Id as a key to the database
% is intended to be used with maplist for every doctor
prepare_patients_lists(doctor(Id, _, _)) :-
  recorda(Id, []).

% Converts patient's illnesses string entry into a list
split_patient_illnesses(patient(Id, Name, IllnessesString), patient(Id, Name, IllnessesList)) :-
  split_string(IllnessesString, ",", "", IllnessesList).

% Loads all patients from a .csv file
prepare_patients :-
  csv_read_file("./patients.csv", Data, [functor(patient), arity(3)]),
  maplist(split_patient_illnesses, Data, Patients),
  maplist(assert, Patients).

init :-
  prepare_competences,
  prepare_doctors,
  prepare_patients.

?- initialization(init).


% utility predicate
% same as `patient`, just without the name
illnesses_by_patients_id(PatientId, Illnesses) :-
  patient(PatientId, _, Illnesses).

% finds doctors to treat patient's illnesses
find_doctors(PatientId, DoctorsId) :-
  patient(PatientId, _, PatientIllnesses),
  maplist(doctor_by_illness, PatientIllnesses, DoctorsId).

% utility predicate
% finds doctor that can treat a specified illness 
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
get_patients(DoctorId, PatientIds) :-
  recorded(DoctorId, PatientIds).

% calculates the cost of the treatment of one Illness
% works only for illnesses defined with `competence` fact
treatment_cost(Illness, Cost) :-
  competence(_, Illnesses),
  member(Illness, Illnesses),
  string_length(Illness, Length),
  % Yes, I do calculate the cost based on the length of the name. So what? You can't stop me.
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
% this way it is possible to use collection as the first argument when using with `maplist`
r_member(List, El) :-
  member(El, List).

% selects only those illnesses from patient that can be trated by a doctor with a specific specialization
filter_illnesses_by_specialization(Specialization, Illnesses, FilteredIllnesses) :-
  competence(Specialization, CompetenceIllnesses),
  include(r_member(CompetenceIllnesses), Illnesses, FilteredIllnesses).

% calculates doctor's salary based on the illnesses of the patients that made an appointment
salary(DoctorId, Salary) :-
  doctor(DoctorId, DoctorName, Specialization),
  get_patients(DoctorId, Patients),
  maplist(illnesses_by_patients_id, Patients, PIllnesses),
  maplist(filter_illnesses_by_specialization(Specialization), PIllnesses, IllnessesNested),
  flatten(IllnessesNested, IllnessesFlat),
  maplist(treatment_cost, IllnessesFlat, Costs),
  foldl(plus, Costs, 0, Cost),
  % I think it's pretty realistic that doctor's cut is about 30% of all earnings
  % And yes the longer your name is, the less money you get
  string_length(DoctorName, L),
  Salary is (0.3 + 1 / (2 * L)) * Cost.

% utility predicates for better output formatting
say(Lst)  :- is_list(Lst), writeln(Lst).
say(S)    :- say(S, []).
say(S, P) :- string_concat(S, '~n', S1), format(S1, P).

% use this rule to run all examples one after the other
run_examples :-
  example1,
  example2,
  example3,
  example4.

% basic hospital operations
% patient makes an appointment to a doctor
% we calculate both the sum that the patient has to pay and the salary of the doctor
example1 :-
  say("\nThis is example 1."),
  P is 21,
  patient(P, PN, PI),
  say("Patient ~w is ~w. Their illnesses are: ~w.", [P, PN, PI]),
  find_doctors(P, Ds),
  say("Doctors that can treat their illnesses have Ids: ~w", [Ds]),
  member(D, Ds),
  doctor(D, DN, DS),
  say("Their doctor will be: ~w. Their specialization is ~w.", [DN, DS]),
  get_patients(D, Ps1),
  say("Patients with these Ids are being treated by doctor ~w: ~w.", [DN, Ps1]),
  make_appointment(P, D, C),
  say("Patient ~w made an appointment to doctor ~w. It will cost them ~w imaginary units.", [PN, DN, C]),
  get_patients(D, Ps2),
  say("After this appointment patients with these Ids are being treated by doctor ~w: ~w.", [DN, Ps2]),
  salary(D, S),
  say("Doctor ~w will receive ~w imaginary units after treating patient ~w.", [DN, S, PN]),
  remove_appointment(P, D),
  get_patients(D, Ps3),
  say("Now patients with these Ids are being treated by doctor ~w: ~w.", [DN, Ps3]),
  say("End of example 1.").

% in this example two patients have the same doctor
example2 :-
  say("\nThis is example 2."),
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
  get_patients(D, Ps),
  say("Patients with these Ids are being treated by doctor ~w: ~w.", [DN, Ps]),
  salary(D, S),
  say("Doctor ~w will be pleased to receive ~w imaginary units after treating both patients.", [DN, S]),
  remove_appointment(P1, D),
  remove_appointment(P2, D),
  say("End of example 2.").

% in this example one patient has several illnesses that can be treated by the same doctor
example3 :-
  say("\nThis is example 3."),
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
  salary(D, S),
  say("Doctor ~w will receive ~w imaginary units after treating both illnesses of ~w.", [DN, S, PN]),
  remove_appointment(P, D),
  say("End of example 3.").

% in this example one patient has several illnesses.
% they are treated by different doctors
example4 :-
  say("\nThis is example 4."),
  P is 22,
  patient(P, PN, PI),
  say("Patient ~w is ~w. Their illnesses are: ~w.", [P, PN, PI]),
  find_doctors(P, Ds),
  maplist(doctor, Ds, DNs, DSs),
  say("Patient ~w has several illnesses. Doctors ~w can help them. Their respective medical fields are ~w", [PN, DNs, DSs]),
  maplist(make_appointment(P), Ds, Cs),
  foldl(plus, Cs, 0, C),
  say("~w made appointments to both of the doctors. Each appointment costs ~w respectively, together: ~w.", [PN, Cs, C]),
  maplist(salary, Ds, Ss),
  say("Doctors ~w will receive ~w imaginary units respectively after treating patient ~w.", [DNs, Ss, PN]),
  maplist(remove_appointment(P), Ds),
  say("End of example 4.").


search_by_illness_gui(Doctor) :-
  new(D, dialog('Search by illness')),
  send(D, append(new(IllnessItem, text_item(illness)))),
  send(D, append(button(ok, message(D, return,
                                    IllnessItem?selection)))),
  send(D, append(button(cancel, message(D, return, @nil)))),
  send(D, default_button(ok)),
  get(D, confirm, Rval),
  free(D),
  doctor_by_illness(Illness, DoctorId),
  doctor(DoctorId, Doctor, _).
