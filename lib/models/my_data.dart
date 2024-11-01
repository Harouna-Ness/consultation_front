import 'package:flutter/material.dart';
import 'package:medstory/models/analyse.dart';
import 'package:medstory/models/consultation.dart';
import 'package:medstory/models/direction.dart';
import 'package:medstory/models/medecin.dart';
import 'package:medstory/models/motif_de_consultation.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/models/rendez_vous.dart';
import 'package:medstory/models/site_de_tavail.dart';
import 'package:medstory/models/statut.dart';
import 'package:medstory/models/statut_patient.dart';
import 'package:medstory/models/type_de_consultation.dart';
import 'package:medstory/models/utilisateur.dart';
import 'package:medstory/service/analyse_service.dart';
import 'package:medstory/service/consultation_service.dart';
import 'package:medstory/service/direction_service.dart';
import 'package:medstory/service/medecin_service.dart';
import 'package:medstory/service/motif_de_consultation_service.dart';
import 'package:medstory/service/patient_service.dart';
import 'package:medstory/service/rendez_vous_service.dart';
import 'package:medstory/service/site_de_travail_service.dart';
import 'package:medstory/service/statut_patient_service.dart';
import 'package:medstory/service/statut_service.dart';
import 'package:medstory/service/type_consultation_service.dart.dart';
import 'package:medstory/service/user_service.dart';

class MyData extends ChangeNotifier {
  final patientService = PatientService();
  final consultationService = ConsultationService();
  final directionService = DirectionService();
  final siteDetravailService = SiteDeTravailService();
  final statutPatientService = StatutPatientService();
  final statutService = StatutService();
  final motifDeConsultationService = MotifDeConsultationService();
  final analyseService = AnalyseService();
  final typeDeConsultationService = TypeConsultationService();
  final rendezVousService = RendezVousService();
  final medecinsService = MedecinService();
  final userService = UserService();

  Utilisateur? _currentUser;
  Utilisateur? get currentUser => _currentUser;

  int _nombrePatient = -1;
  int get nombrePatient => _nombrePatient;
  
  double _moyenneAge = -1;
  double get moyenneAge => _moyenneAge;

  int _nombreConsultation = -1;
  int get nombreConsultation => _nombreConsultation;

  List<Patient> _patients = [];
  List<Patient> get patients => _patients;

  List<Direction> _directions = [];
  List<Direction> get directions => _directions;

  List<Sitedetravail> _siteDetravails = [];
  List<Sitedetravail> get siteDetravails => _siteDetravails;

  List<StatutPatient> _statutPatients = [];
  List<StatutPatient> get statutPatients => _statutPatients;

  List<MotifDeConsultation> _motifDeConsultations = [];
  List<MotifDeConsultation> get motifDeConsultations => _motifDeConsultations;

  List<Analyse> _analyses = [];
  List<Analyse> get analyses => _analyses;

  List<TypeDeConsultation> _typeDeConsultation = [];
  List<TypeDeConsultation> get typeDeConsultations => _typeDeConsultation;

  List<Consultation> _consultation = [];
  List<Consultation> get consultations => _consultation;

  List<Statut> _statut = [];
  List<Statut> get statuts => _statut;
  
  List<RendezVous> _rendezVous = [];
  List<RendezVous> get rendezVous => _rendezVous;
  
  List<Medecin> _medecins = [];
  List<Medecin> get medecins => _medecins;

  Future<void> getCurrentUser() async {
    _currentUser = await userService.getCurrentUser();
    notifyListeners();
  }

  Future<void> getNombreConsultation() async {
    _nombreConsultation = await consultationService.getConsultationCount();
    notifyListeners();
  }

  // Crud patient
  Future<void> getNombrePatient() async {
    _nombrePatient = await patientService.getPatientCount();
    notifyListeners();
  }
  
  Future<void> getMoyenneAge() async {
    _moyenneAge = await patientService.getAllmoyenneAge();
    notifyListeners();
  }

  void addPatient(Patient patient) {
    _patients.add(patient);
    notifyListeners();
  }

  Future<void> fetchPatients() async {
    _patients = await patientService.getAllPatients();
    notifyListeners();
  }

  Future<void> updatePatients(Patient patient, int index) async {
    _patients[index] = patient;
    notifyListeners();
  }

  void deletePatients(int index) {
    _patients.removeAt(index);
    notifyListeners();
  }
 
  // Crud direction
  Future<void> fetchDirections() async {
    _directions = await directionService.getAllDirections();
    notifyListeners();
  }

  void addDirections(Direction direction) {
    _directions.add(direction);
    notifyListeners();
  }

  Future<void> updateDirections(Direction direction, int index) async {
    _directions[index] = direction;
    notifyListeners();
  }

  void deleteDirectionst(int index) {
    _directions.removeAt(index);
    notifyListeners();
  }
 
  // Crud medecin
  Future<void> fetchMedecins() async {
    _medecins = await medecinsService.getAllMedecin();
    notifyListeners();
  }

  void addMedecin(Medecin medecin) {
    _medecins.add(medecin);
    notifyListeners();
  }

  Future<void> updateMedecin(Medecin medecin, int index) async {
    _medecins[index] = medecin;
    notifyListeners();
  }

  void deleteMedecin(int index) {
    _medecins.removeAt(index);
    notifyListeners();
  }

  // Crud Rendez-vous
  Future<void> fetchRendezVous() async {
    _rendezVous = await rendezVousService.getAllRendezVous();
    notifyListeners();
  }

  void addRendezVous(RendezVous rdv) {
    _rendezVous.add(rdv);
    notifyListeners();
  }

  Future<void> updateRendezVous(RendezVous rdv, int index) async {
    _rendezVous[index] = rdv;
    notifyListeners();
  }

  void deleteRendezVous(int index) {
    _rendezVous.removeAt(index);
    notifyListeners();
  }

  // Crud site de travail
  Future<void> fetchSiteDeTraivails() async {
    _siteDetravails = await siteDetravailService.getAllSite();
    notifyListeners();
  }

  void addSiteDeTraivails(Sitedetravail site) {
    _siteDetravails.add(site);
    notifyListeners();
  }

  Future<void> updateSiteDeTraivails(Sitedetravail site, int index) async {
    _siteDetravails[index] = site;
    notifyListeners();
  }

  void deleteSiteDeTraivailst(int index) {
    _siteDetravails.removeAt(index);
    notifyListeners();
  }

  // Crud Statut patient
  Future<void> fetchStatutPatient() async {
    _statutPatients = await statutPatientService.getAllStatutPatient();
    notifyListeners();
  }

  void addStatutPatient(StatutPatient statut) {
    _statutPatients.add(statut);
    notifyListeners();
  }

  Future<void> updateStatutPatient(StatutPatient statut, int index) async {
    _statutPatients[index] = statut;
    notifyListeners();
  }

  void deleteStatutPatient(int index) {
    _statutPatients.removeAt(index);
    notifyListeners();
  }

  // Crud statut
  Future<void> fetchStatut() async {
    _statut = await statutService.getAllStatuts();
    notifyListeners();
  }

  void addStatut(Statut statut) {
    _statut.add(statut);
    notifyListeners();
  }

  Future<void> updateStatut(Statut statut, int index) async {
    _statut[index] = statut;
    notifyListeners();
  }

  void deleteStatut(int index) {
    _statut.removeAt(index);
    notifyListeners();
  }

  //Crud motif
  Future<void> fetchMotifDeConsultion() async {
    _motifDeConsultations =
        await motifDeConsultationService.getAllMotifDeConsultation();
    notifyListeners();
  }

  void addMotifDeConsultion(MotifDeConsultation motif) {
    _motifDeConsultations.add(motif);
    notifyListeners();
  }

  Future<void> updateMotifDeConsultion(MotifDeConsultation motif, int index) async {
    _motifDeConsultations[index] = motif;
    notifyListeners();
  }

  void deleteMotifDeConsultion(int index) {
    _motifDeConsultations.removeAt(index);
    notifyListeners();
  }

  // Crud analyse
  Future<void> fetchAnalyse() async {
    _analyses = await analyseService.getAllAnalyse();
    notifyListeners();
  }

  void addAnalyse(Analyse analyse) {
    _analyses.add(analyse);
    notifyListeners();
  }

  Future<void> updateAnalyse(Analyse analyse, int index) async {
    _analyses[index] = analyse;
    notifyListeners();
  }

  void deleteAnalyse(int index) {
    _analyses.removeAt(index);
    notifyListeners();
  }

  // Crud type
  Future<void> fetchTypeDeConsultation() async {
    _typeDeConsultation =
        await typeDeConsultationService.getAllTypeDeConsultation();
    notifyListeners();
  }

  void addTypeDeConsultation(TypeDeConsultation type) {
    _typeDeConsultation.add(type);
    notifyListeners();
  }

  Future<void> updateTypeDeConsultation(TypeDeConsultation type, int index) async {
    _typeDeConsultation[index] = type;
    notifyListeners();
  }

  void deleteTypeDeConsultationt(int index) {
    _typeDeConsultation.removeAt(index);
    notifyListeners();
  }

  // Crud consultation
  Future<void> fetchConsultation() async {
    _consultation = await consultationService.getAllConsultation();
    notifyListeners();
  }

  void addConsultation(Consultation consultation) {
    _consultation.add(consultation);
    notifyListeners();
  }

  Future<void> updateConsultation(Consultation consultation, int index) async {
    _consultation[index] = consultation;
    notifyListeners();
  }

  void deleteConsultation(int index) {
    _consultation.removeAt(index);
    notifyListeners();
  }
}
