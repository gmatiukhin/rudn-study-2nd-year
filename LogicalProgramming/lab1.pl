% Clinic
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
doctor(14, "Joe Schmoe", "Gynecology").
doctor(15, "Gordon Norman", "Cardiology").
doctor(16, "Norman Gordon", "Dermatology").

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
appointment(PatientId, DoctorId) :-
  patient(PatientId, _, PatientIllnesses),
  member(PatientIllness, PatientIllnesses),
  competence(Specialization, Illnesses),
  member(PatientIllness, Illnesses),
  doctor(DoctorId, _, Specialization).

% calculates the cost of the treatment based on the length of the illness' name
% works only for illnesses defined with `competence` fact
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
