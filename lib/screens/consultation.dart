// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/components/champs_texte.dart';
import 'package:medstory/components/customGrid.dart';
import 'package:medstory/components/empty_content.dart';
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
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;

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
                  consultations.isEmpty
                      ? const EmptyContent()
                      : Expanded(
                          child:
                              consultationListSection(context, consultations)),
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
            heightFactor: 0.85,
            // widthFactor:
            //     0.8, // Ajuster la largeur pour que le dialog soit responsive
            child: Box(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Sélection de patient",
                      style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
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
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: const Text(
                                    'Sélectionner',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
            subtitle: Text('${consultation.diagnosticRetenu}'),
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
  TextEditingController hypotheseDiagnosticController = TextEditingController();
  TextEditingController diagnosticRetenuController = TextEditingController();
  TextEditingController examenPhysiqueController = TextEditingController();
  TextEditingController histoireDeLaMaladieController = TextEditingController();
  TextEditingController prescriptionController = TextEditingController();
  List<TextEditingController> prescriptionControllers = [
    TextEditingController()
  ];

  // Valeurs pour les selects
  MotifDeConsultation? _selectedMotifDeConsultation;
  TypeDeConsultation? _selectedTypeDeConsultation;
  List<Analyse?> selectedAnalyses = [null];
  List<Analyse?> selectedRadiosAnalyses = [null];

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
              // Champ Histoire de la maladie
              ChampsTexte.buildTextField(
                  "Histoire de la maladie", histoireDeLaMaladieController),
              // Champ Examen physique
              ChampsTexte.buildTextField(
                  "Examen physique", examenPhysiqueController),
              // Champ Hypothese de Diagnostic
              ChampsTexte.buildTextField(
                  "Hypothèse de diagnostic", hypotheseDiagnosticController),

              const SizedBox(
                height: 16,
              ),

              // Bilan
              const Text(
                'Bilan demandé',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text("Biologie"),
                          const SizedBox(
                            height: 10,
                          ),
                          // Boucle pour afficher les champs dynamiques
                          for (int index = 0;
                              index < selectedAnalyses.length;
                              index++)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Autocomplete<Analyse>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text.isEmpty) {
                                      return const Iterable<Analyse>.empty();
                                    }
                                    return analyses.where((analyse) => analyse
                                        .libelle!
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase()));
                                  },
                                  displayStringForOption: (Analyse analyse) =>
                                      analyse.libelle!,
                                  onSelected: (Analyse selectedAnalyse) {
                                    setState(() {
                                      selectedAnalyses[index] = selectedAnalyse;
                                    });
                                  },
                                  fieldViewBuilder: (BuildContext context,
                                      TextEditingController
                                          textEditingController,
                                      FocusNode focusNode,
                                      VoidCallback onFieldSubmitted) {
                                    // Remplir automatiquement le champ avec l'analyse sélectionnée
                                    if (selectedAnalyses[index] != null) {
                                      textEditingController.text =
                                          selectedAnalyses[index]!.libelle!;
                                    }
                                    return TextFormField(
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      decoration: InputDecoration(
                                          labelText: "Analyse ${index + 1}"),
                                      onFieldSubmitted: (value) {
                                        if (value.isNotEmpty &&
                                            !analyses.any((analyse) =>
                                                analyse.libelle!
                                                    .toLowerCase() ==
                                                value.toLowerCase())) {
                                          // Si aucune analyse ne correspond, créer une nouvelle
                                          Analyse newAnalyse = Analyse(
                                            id: 0,
                                            libelle: value,
                                          );
                                          setState(() {
                                            selectedAnalyses[index] =
                                                newAnalyse;
                                          });
                                        }
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          const SizedBox(height: 10),
                          // Bouton pour ajouter un nouveau champ
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    selectedAnalyses
                                        .add(null); // Ajouter un nouveau champ
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
                        ],
                      ),
                    ),
                  ),
                  // Radio-analyses
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text("Radiographie"),
                          const SizedBox(
                            height: 10,
                          ),
                          // Boucle pour afficher les champs dynamiques
                          for (int index = 0;
                              index < selectedRadiosAnalyses.length;
                              index++)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Autocomplete<Analyse>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text.isEmpty) {
                                      return const Iterable<Analyse>.empty();
                                    }
                                    return analyses.where((analyse) => analyse
                                        .libelle!
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase()));
                                  },
                                  displayStringForOption: (Analyse analyse) =>
                                      analyse.libelle!,
                                  onSelected: (Analyse selectedAnalyse) {
                                    setState(() {
                                      selectedRadiosAnalyses[index] =
                                          selectedAnalyse;
                                    });
                                  },
                                  fieldViewBuilder: (BuildContext context,
                                      TextEditingController
                                          textEditingController,
                                      FocusNode focusNode,
                                      VoidCallback onFieldSubmitted) {
                                    // Remplir automatiquement le champ avec l'analyse sélectionnée
                                    if (selectedRadiosAnalyses[index] != null) {
                                      textEditingController.text =
                                          selectedRadiosAnalyses[index]!
                                              .libelle!;
                                    }
                                    return TextFormField(
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      decoration: InputDecoration(
                                          labelText: "Analyse ${index + 1}"),
                                      onFieldSubmitted: (value) {
                                        if (value.isNotEmpty &&
                                            !analyses.any((analyse) =>
                                                analyse.libelle!
                                                    .toLowerCase() ==
                                                value.toLowerCase())) {
                                          // Si aucune analyse ne correspond, créer une nouvelle
                                          Analyse newAnalyse = Analyse(
                                            id: 0,
                                            libelle: value,
                                          );
                                          setState(() {
                                            selectedRadiosAnalyses[index] =
                                                newAnalyse;
                                          });
                                        }
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          const SizedBox(height: 10),
                          // Bouton pour ajouter un nouveau champ
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    selectedRadiosAnalyses
                                        .add(null); // Ajouter un nouveau champ
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
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),

              // // Champ Analyse
              // for (int i = 0; i < selectedAnalyses.length; i++)
              //   DropdownButtonFormField<Analyse>(
              //     decoration: InputDecoration(labelText: "Analyse ${i + 1}"),
              //     value: selectedAnalyses[i],
              //     onChanged: (value) {
              //       setState(() {
              //         selectedAnalyses[i] = value;
              //       });
              //     },
              //     items: analyses
              //         .map((analyse) => DropdownMenuItem(
              //               value: analyse,
              //               child: Text(analyse.libelle!),
              //             ))
              //         .toList(),
              //     validator: (value) => value == null ? 'Champ requis' : null,
              //   ),
              // Champ Hypothese de Diagnostic
              ChampsTexte.buildTextField(
                  "Diagnostic retenu", diagnosticRetenuController),

              const SizedBox(
                height: 10,
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
                        print("object:::okok");
                      }
                      // if (_formKey.currentState!.validate()) {
                      //   context.showLoader();

                      //   // TODO: revoir le bouton de soumission d'une consultation.

                      //   List<Analyse> nonNullAnalyses = selectedAnalyses
                      //       .where((analyse) => analyse != null)
                      //       .cast<Analyse>()
                      //       .toList();

                      //   // Créer un bilan avec les analyses non nulles
                      //   Bilan bilan = Bilan(analyses: nonNullAnalyses);

                      //   print("Bilan créé : ${bilan.toMap()}");

                      //   // Données consultation.
                      //   Map<String, dynamic> consultation = {
                      //     "id": 0,
                      //     "diagnostic": diagnosticController.text,
                      //     "symptome": "sylto",
                      //     "medecin": {"id": 1},
                      //     "typeDeConsultation":
                      //         _selectedTypeDeConsultation != null
                      //             ? {"id": _selectedTypeDeConsultation!.id}
                      //             : null,
                      //     "motifDeConsultation":
                      //         _selectedMotifDeConsultation != null
                      //             ? {"id": _selectedMotifDeConsultation!.id}
                      //             : null,
                      //     "bilan": bilan.toMap(),
                      //     "prescriptions": prescriptionControllers
                      //         .map((controller) => controller.text)
                      //         .toList(),
                      //   };

                      //   print(nonNullAnalyses.toString());
                      //   print(selectedAnalyses.toString());

                      //   //Logique pour sauvegarder la consultation

                      //   await consultationService
                      //       .creerConsultation(
                      //     consultation,
                      //     widget.patient.email,
                      //   )
                      //       .then((onValue) async {
                      //     context.read<MyData>().getNombreConsultation();
                      //     context.read<MyData>().fetchConsultation();
                      //     context.hideLoader();
                      //     context.showSuccess("Ajoutée avec succès.");

                      //     // Générer les PDFs après l'enregistrement réussi

                      //     // Liste des prescriptions
                      //     List<String> prescriptions = prescriptionControllers
                      //         .map((controller) => controller.text)
                      //         .where((text) => text.isNotEmpty)
                      //         .toList();

                      //     if (prescriptions.isNotEmpty) {
                      //       await generatePdf(
                      //         title: "Ordonnance Médicale",
                      //         content: prescriptions,
                      //       );
                      //     }

                      //     // Liste des analyses
                      //     List<String> analyses = nonNullAnalyses
                      //         .map((analyse) =>
                      //             analyse.libelle ?? "Analyse inconnue")
                      //         .toList();

                      //     if (analyses.isNotEmpty) {
                      //       await generatePdf(
                      //         title: "Bulletin d'Examen",
                      //         content: analyses,
                      //       );
                      //     }
                      //   }).catchError((onError) {
                      //     context.hideLoader();
                      //     context.showError(onError.toString());
                      //   }).whenComplete(() {
                      //     setState(() {
                      //       widget.changeView();
                      //     });
                      //   });
                      // }
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

  Future<void> generatePdf(
      {required String title, required List<String> content}) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              ...content.map((item) => pw.Text("- $item")),
            ],
          );
        },
      ),
    );

    // Sauvegarder ou télécharger le PDF
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: "$title.pdf",
    );
  }
}
