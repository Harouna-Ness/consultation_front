import 'package:flutter/material.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/service/consultation_service.dart';
import 'package:medstory/service/patient_service.dart';

class MyData extends ChangeNotifier {
  final patientService = PatientService();
  final consultationService = ConsultationService();
  
  int _nombrePatient = -1;
  int _nombreConsultation = -1;
  int get nombrePatient => _nombrePatient;
  int get nombreConsultation => _nombreConsultation;

  List<Patient> _patients = []; // Liste des patients
  List<Patient> get patients => _patients;

  Future<void> getNombreConsultation() async {
    _nombreConsultation = await consultationService.getConsultationCount();
    notifyListeners();
  }

  Future<void> getNombrePatient() async {
    _nombrePatient = await patientService.getPatientCount();
    notifyListeners();
  }

  Future<void> fetchPatients() async {
    // _patients = await patientService.getAllPatients();
    notifyListeners();
  }
}