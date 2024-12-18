import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/components/ajout_patient_grouper.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/components/customTable.dart';
import 'package:medstory/components/patient_form.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/screens/dossier_patient.dart';
import 'package:medstory/service/dio_client.dart';
import 'package:medstory/service/patient_service.dart';

// ignore: must_be_immutable
class Patients extends StatefulWidget {
  bool showForm;
  Patients({super.key, required this.showForm});

  @override
  State<Patients> createState() => _PatientsState();
}

class _PatientsState extends State<Patients> {
  // bool showFrom = false;
  Patient? selectedPatient;
  final patientService = PatientService();
  bool showDossier = false;
  final List<Color> colors = [
    primaryColor,
    tertiaryColor,
    Colors.red,
    Colors.blue,
    Colors.purple,
    Colors.cyan
  ];
  final apiService = ApiService(DioClient.dio);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    Future<dynamic> selectionFichierModal(BuildContext contexte) {
      return showDialog(
        context: contexte,
        builder: (contexte) {
          return const Dialog(
            child: FractionallySizedBox(
              heightFactor: 0.85,
              child: AjoutPatientGrouper(),
            ),
          );
        },
      );
    }

    if (widget.showForm == true) {
      return Box(
        child: PatientForm(
          changeView: () {
            setState(() {
              widget.showForm = false;
            });
          },
        ),
      );
    } else {
      return !showDossier
          ? SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 170,
                          child: PopupMenuButton<String>(
                            tooltip: "Ouvrir le menu !",
                            onSelected: (value) {
                              if (value == 'Un patient') {
                                // Changer la vue.
                                setState(() {
                                  widget.showForm = true;
                                });
                              } else if (value ==
                                  'Plusieurs patients via excel') {
                                // ouvrir le modal de selection de fichier.
                                selectionFichierModal(context);
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return {
                                'Un patient',
                                'Plusieurs patients via excel'
                              }.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList();
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: .1,
                                    spreadRadius: .1,
                                    offset: Offset(0, 1),
                                    blurStyle: BlurStyle.outer,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(defaultPadding),
                                child: size.width >= 310
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/personAdd.svg",
                                            height: 20,
                                          ),
                                          const SizedBox(
                                            width: defaultPadding,
                                          ),
                                          Text(
                                            "Ajouter",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      )
                                    : SvgPicture.asset(
                                        "assets/icons/personAdd.svg"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    Box(
                      padding: 10,
                      child: Customtable(
                        changeView: (Patient patient) {
                          setState(() {
                            selectedPatient = patient;
                          });
                          if (selectedPatient != null) {
                            showDossier = true;
                          }
                        },
                      ),
                    )
                  ],
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
}
