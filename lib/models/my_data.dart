import 'package:flutter/material.dart';
import 'package:medstory/models/analyse.dart';
import 'package:medstory/models/consultation.dart';
import 'package:medstory/models/direction.dart';
import 'package:medstory/models/motif_de_consultation.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/models/site_de_tavail.dart';
import 'package:medstory/models/statut_patient.dart';
import 'package:medstory/models/type_de_consultation.dart';
import 'package:medstory/service/analyse_service.dart';
import 'package:medstory/service/consultation_service.dart';
import 'package:medstory/service/direction_service.dart';
import 'package:medstory/service/motif_de_consultation_service.dart';
import 'package:medstory/service/patient_service.dart';
import 'package:medstory/service/site_de_travail_service.dart';
import 'package:medstory/service/statut_patient_service.dart';
import 'package:medstory/service/type_consultation_service.dart.dart';

class MyData extends ChangeNotifier {
  final patientService = PatientService();
  final consultationService = ConsultationService();
  final directionService = DirectionService();
  final siteDetravailService = SiteDeTravailService();
  final statutPatientService = StatutPatientService();
  final motifDeConsultationService = MotifDeConsultationService();
  final analyseService = AnalyseService();
  final typeDeConsultationService = TypeConsultationService();

  int _nombrePatient = -1;
  int get nombrePatient => _nombrePatient;

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

  Future<void> getNombreConsultation() async {
    _nombreConsultation = await consultationService.getConsultationCount();
    notifyListeners();
  }

  Future<void> getNombrePatient() async {
    _nombrePatient = await patientService.getPatientCount();
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

  Future<void> fetchDirections() async {
    _directions = await directionService.getAllDirections();
    notifyListeners();
  }

  Future<void> fetchSiteDeTraivails() async {
    _siteDetravails = await siteDetravailService.getAllSite();
    notifyListeners();
  }

  Future<void> fetchStatutPatient() async {
    _statutPatients = await statutPatientService.getAllStatutPatient();
    notifyListeners();
  }

  Future<void> fetchMotifDeConsultion() async {
    _motifDeConsultations = await motifDeConsultationService.getAllMotifDeConsultation();
    notifyListeners();
  }

  Future<void> fetchAnalyse() async {
    _analyses = await analyseService.getAllAnalyse();
    notifyListeners();
  }
  
  Future<void> fetchTypeDeConsultation() async {
    _typeDeConsultation = await typeDeConsultationService.getAllTypeDeConsultation();
    notifyListeners();
  }

  Future<void> fetchConsultation() async {
    _consultation = await consultationService.getAllConsultation();
    notifyListeners();
  }
}
