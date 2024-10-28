import 'package:flutter/material.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/components/custom_table_med_portail.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/screens/dossier_patient.dart';
import 'package:medstory/service/patient_service.dart';

class PatientMedPortail extends StatefulWidget {
  const PatientMedPortail({super.key});

  @override
  State<PatientMedPortail> createState() => _PatientMedPortailState();
}

class _PatientMedPortailState extends State<PatientMedPortail> {
  Patient? selectedPatient;
  final patientService = PatientService();
  bool showDossier = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return !showDossier
        ? SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(defaultPadding),
              child: Box(
                padding: 10,
                child: CustomTableMedPortail(
                  changeView: (Patient patient) {
                    setState(() {
                      selectedPatient = patient;
                    });
                    if (selectedPatient != null) {
                      showDossier = true;
                    }
                  },
                ),
              ),
            ),
          )
        : DossierPatient(
            patient: selectedPatient!,
            changeView: () {
              setState(() {
                showDossier = false;
              });
            },
          );
  }
}
