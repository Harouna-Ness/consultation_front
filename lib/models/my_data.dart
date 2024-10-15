import 'package:flutter/material.dart';
import 'package:medstory/models/direction.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/models/site_de_tavail.dart';
import 'package:medstory/service/consultation_service.dart';
import 'package:medstory/service/direction_service.dart';
import 'package:medstory/service/patient_service.dart';
import 'package:medstory/service/site_de_travail_service.dart';

class MyData extends ChangeNotifier {
  final patientService = PatientService();
  final consultationService = ConsultationService();
  final directionService = DirectionService();
  final siteDetravailService = SiteDeTravailService();

  int _nombrePatient = -1;
  int _nombreConsultation = -1;
  int get nombrePatient => _nombrePatient;
  int get nombreConsultation => _nombreConsultation;

  List<Patient> _patients = [];
  List<Patient> get patients => _patients;

  List<Direction> _directions = [];
  List<Direction> get directions => _directions;

  List<Sitedetravail> _siteDetravails = [];
  List<Sitedetravail> get siteDetravails => _siteDetravails;

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
    print(_patients);
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
}
