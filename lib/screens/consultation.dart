// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/components/champs_texte.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/analyse.dart';
import 'package:medstory/models/bilan.dart';
import 'package:medstory/models/consultation.dart';
import 'package:medstory/models/motif_de_consultation.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/models/type_de_consultation.dart';
import 'package:medstory/service/consultation_service.dart';
import 'package:medstory/utils/lodder.dart';
import 'package:provider/provider.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  State<ConsultationScreen> createState() => _ConsultationState();
}

class _ConsultationState extends State<ConsultationScreen> {
  Patient? _selectedPatient;
  bool showForm = false;
  @override
  Widget build(BuildContext context) {
    List<Consultation> consultations = context.watch<MyData>().consultations;
    List<Patient> patients = context.watch<MyData>().patients;

    return !showForm
        ? SafeArea(
            child: Box(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Mes consultation",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          selectionModal(context, patients);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
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
                          child: const Text(
                            "Nouvelle consultation",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: consultationListSection(context, consultations)),
                ],
              ),
            ),
          )
        : Box(
            child: FormConsultation(
            patient: _selectedPatient!,
            changeView: () {
              setState(() {
                showForm = false;
              });
            },
          ));
  }

  Future<dynamic> selectionModal(
      BuildContext contexte, List<Patient> patients) {
    return showDialog(
      context: contexte,
      builder: (contexte) {
        return Dialog(
          child: FractionallySizedBox(
            widthFactor:
                0.8, // Ajuster la largeur pour que le dialog soit responsive
            child: Box(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Sélection de patient",
                      style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: DataTable(
                      headingTextStyle:
                          const TextStyle(fontWeight: FontWeight.bold),
                      columns: const [
                        DataColumn(label: Text("Prénom")),
                        DataColumn(label: Text("Nom")),
                        DataColumn(label: Text("Matricule")),
                        DataColumn(label: Text("Proffession")),
                        DataColumn(label: Text("Site de Travail")),
                        DataColumn(label: Text("Actions")),
                      ],
                      rows: List.generate(
                        patients.length,
                        (index) => DataRow(
                          cells: [
                            DataCell(Text(patients[index].prenom)),
                            DataCell(Text(patients[index].nom)),
                            DataCell(Text(patients[index].telephone)),
                            DataCell(patients[index].proffession != null
                                ? Text(patients[index].proffession!)
                                : const Text("Néant")),
                            DataCell(patients[index].sitedetravail != null
                                ? Text(patients[index].sitedetravail!.nom)
                                : const Text("Néant")),
                            DataCell(
                              ElevatedButton(
                                onPressed: () {
                                  // Remplir les champs du formulaire avec les infos du patient sélectionné
                                  setState(() {
                                    _selectedPatient = patients[index];
                                    print(
                                        "::::: le patient: ${_selectedPatient!.email}.");
                                  });
                                  Navigator.of(context).pop();
                                  if (_selectedPatient != null) {
                                    showForm = true;
                                  }
                                },
                                child: const Text('Sélectionner'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget consultationListSection(
    BuildContext context, List<Consultation> consultations) {
  return ListView.separated(
    itemCount: consultations.length,
    itemBuilder: (context, index) {
      final consultation = consultations[index];
      return ExpansionTile(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide.none,
        ),
        title: Text(
            'Consultation du ${consultations[index].creationDate!.day}-${consultations[index].creationDate!.month}-${consultations[index].creationDate!.year}'),
        children: [
          ListTile(
            title: const Text('Patient'),
            subtitle: Text('${consultation.patientFullName}'),
          ),
          ListTile(
            title: const Text('Diagnostic'),
            subtitle: Text('${consultation.diagnostic}'),
          ),
        ],
      );
    },
    separatorBuilder: (BuildContext context, int index) {
      return const Divider(color: Colors.grey);
    },
  );
}

class FormConsultation extends StatefulWidget {
  final void Function() changeView;
  final Patient patient;
  const FormConsultation(
      {super.key, required this.patient, required this.changeView});

  @override
  State<FormConsultation> createState() => _FormConsultationState();
}

class _FormConsultationState extends State<FormConsultation> {
  final _formKey = GlobalKey<FormState>();
  // Controllers pour récupérer les valeurs des champs de la consultation
  TextEditingController motifController = TextEditingController();
  TextEditingController typeConsultationController = TextEditingController();
  TextEditingController symptomeController = TextEditingController();
  TextEditingController diagnosticController = TextEditingController();
  TextEditingController prescriptionController = TextEditingController();
  List<TextEditingController> prescriptionControllers = [
    TextEditingController()
  ];

  // Valeurs pour les selects
  MotifDeConsultation? _selectedMotifDeConsultation;
  TypeDeConsultation? _selectedTypeDeConsultation;
  List<Analyse?> selectedAnalyses = [null];

  @override
  void dispose() {
    for (var controller in prescriptionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final consultationService = ConsultationService();
    List<MotifDeConsultation> motifDeConsultations =
        context.watch<MyData>().motifDeConsultations;
    List<Analyse> analyses = context.watch<MyData>().analyses;
    List<TypeDeConsultation> typeDeConsultations =
        context.watch<MyData>().typeDeConsultations;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Nouvelle consultation',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Champ Type
              DropdownButtonFormField<TypeDeConsultation>(
                decoration:
                    const InputDecoration(labelText: "Type de consultation"),
                value: _selectedTypeDeConsultation,
                onChanged: (value) =>
                    setState(() => _selectedTypeDeConsultation = value),
                items: typeDeConsultations
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.libelle),
                        ))
                    .toList(),
                validator: (value) => value == null ? 'Champ requis' : null,
              ),
              // Champ Motif
              DropdownButtonFormField<MotifDeConsultation>(
                decoration: const InputDecoration(
                    labelText: "Motif de la consultation"),
                value: _selectedMotifDeConsultation,
                onChanged: (value) =>
                    setState(() => _selectedMotifDeConsultation = value),
                items: motifDeConsultations
                    .map((motif) => DropdownMenuItem(
                          value: motif,
                          child: Text(motif.motif!),
                        ))
                    .toList(),
                validator: (value) => value == null ? 'Champ requis' : null,
              ),
              // Champ Symptôme
              ChampsTexte.buildTextField("Symptômes", symptomeController),
              // Champ Diagnostic
              ChampsTexte.buildTextField("Diagnostic", diagnosticController),
              // Champ Analyse
              for (int i = 0; i < selectedAnalyses.length; i++)
                DropdownButtonFormField<Analyse>(
                  decoration: InputDecoration(labelText: "Analyse ${i + 1}"),
                  value: selectedAnalyses[i],
                  onChanged: (value) {
                    setState(() {
                      selectedAnalyses[i] = value;
                    });
                  },
                  items: analyses
                      .map((analyse) => DropdownMenuItem(
                            value: analyse,
                            child: Text(analyse.libelle!),
                          ))
                      .toList(),
                  validator: (value) => value == null ? 'Champ requis' : null,
                ),

              const SizedBox(height: 10),

              // Bouton pour ajouter un nouveau champ
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedAnalyses.add(null); // Ajouter un nouveau champ
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Ajouter une autre analyse",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              for (int i = 0; i < prescriptionControllers.length; i++)
                ChampsTexte.buildTextField(
                    "Prescription ${i + 1}", prescriptionControllers[i]),
              const SizedBox(
                height: 10,
              ),
              // Bouton pour ajouter un nouveau champ
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        prescriptionControllers.add(
                            TextEditingController()); // Ajouter un nouveau champ
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tertiaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Ajouter une prescription",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        context.showLoader();

                        List<Analyse> nonNullAnalyses = selectedAnalyses
                            .where((analyse) => analyse != null)
                            .cast<Analyse>()
                            .toList();

                        // Créer un bilan avec les analyses non nulles
                        Bilan bilan = Bilan(analyses: nonNullAnalyses);

                        // Données consultation.
                        Map<String, dynamic> consultation = {
                          "id": 0,
                          "diagnostic": diagnosticController.text,
                          "symptome": "sylto",
                          "medecin": {"id": 1},
                          "typeDeConsultation":
                              _selectedTypeDeConsultation != null
                                  ? {"id": _selectedTypeDeConsultation!.id}
                                  : null,
                          "motifDeConsultation":
                              _selectedMotifDeConsultation != null
                                  ? {"id": _selectedMotifDeConsultation!.id}
                                  : null,
                          "bilan": bilan.toMap(),
                          "prescriptions": prescriptionControllers
                              .map((controller) => controller.text)
                              .toList(),
                        };

                        //Logique pour sauvegarder la consultation

                        await consultationService
                            .creerConsultation(
                          consultation,
                          widget.patient.email,
                        )
                            .then((onValue) {
                          context.read<MyData>().getNombreConsultation();
                          context.read<MyData>().fetchConsultation();
                          context.hideLoader();
                          context.showSuccess("Ajoutée avec succès.");
                        }).catchError((onError) {
                          context.hideLoader();
                          context.showError(onError.toString());
                        }).whenComplete(() {
                          setState(() {
                            // context.read<MyMenuController>().changePage(2);
                            widget.changeView();
                          });
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      "Enregistrer",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.changeView();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      "Annuler",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
