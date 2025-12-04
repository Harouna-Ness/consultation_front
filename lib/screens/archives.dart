import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/controllers/controller.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/service/patient_service.dart';
import 'package:medstory/utils/lodder.dart';
import 'package:provider/provider.dart';

class Archives extends StatefulWidget {
  const Archives({super.key});

  @override
  State<Archives> createState() => _ArchivesState();
}

class _ArchivesState extends State<Archives> {
  final patientService = PatientService();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: patientService.getAllArchivedPatients(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Box(
              child: const Center(
                child: Text("Oups, une s'est produite !"),
              ),
            );
          }
          if (snapshot.hasData) {
            List<Patient> patients = snapshot.data!;
            return Box(
              padding: 10,
              child: patients.isEmpty
                  ? const Center(
                      child: Text("Vide"),
                    )
                  : Column(
                      children: patients
                          .map(
                            (patient) => ListTile(
                              title: Text("${patient.nom} ${patient.prenom}"),
                              subtitle: Text(
                                patient.email,
                              ),
                              trailing: InkWell(
                                onTap: () async {
                                  // logique d'afficher une alerte avant de Restaurer.

                                  context.showConfirmation(
                                    title: "Restaurer",
                                    message:
                                        "Êtes-vous sûr de vouloir restaurer cet élément ?",
                                    onConfirm: () async {
                                      context.showLoader();
                                      final patientService = PatientService();
                                      await patientService
                                          .restaurerPatient(patient.id!)
                                          .then((value) {
                                        context
                                            .read<MyData>()
                                            .getNombrePatient();
                                        context.hideLoader();
                                        context.showSuccess(
                                            "Le patient a été Restauré avec succès.");
                                        setState(() {});
                                      }).catchError((onError) {
                                        context.hideLoader();
                                        context.showError(onError.toString());
                                      });
                                      print("Élément restauré !");
                                    },
                                  );
                                },
                                child: const Icon(
                                  Icons.restore_from_trash_outlined,
                                  color: Colors.black,
                                  size: 35,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
            );
          }
          return Box(
            child: const Center(
              child: CircularProgressIndicator(
                color: tertiaryColor,
              ),
            ),
          );
        });
  }
}
