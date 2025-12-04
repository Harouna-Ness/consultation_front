// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/components/champs_texte.dart';
import 'package:medstory/components/empty_content.dart';
import 'package:medstory/components/select_patient_widget.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/analyse.dart';
import 'package:medstory/models/bilan.dart';
import 'package:medstory/models/consultation.dart';
import 'package:medstory/models/examen_biologique.dart';
import 'package:medstory/models/motif_de_consultation.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/models/radiographie.dart';
import 'package:medstory/models/type_de_consultation.dart';
import 'package:medstory/service/consultation_service.dart';
import 'package:medstory/service/pdf_service.dart';
import 'package:medstory/utils/lodder.dart';
import 'package:pdf/pdf.dart';
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
  final consultationService = ConsultationService();
  List<Consultation> consultations = [];

  int _page = 0;
  @override
  Widget build(BuildContext context) {
    List<Patient> patients = context.watch<MyData>().patients;

    return !showForm
        ? SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // const Text(
                    //   "Mes consultation",
                    //   style: TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
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
                  child: Box(
                    child: FutureBuilder(
                        future: consultationService.getAllConsultations(
                          medecinId: context.watch<MyData>().currentUser!.id!,
                          page: _page,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            consultations = snapshot.data!['consultations'];
                            int totalPages = snapshot.data!['totalPages'];
                            if (snapshot.data!.isNotEmpty) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Wrap(
                                      spacing: 12,
                                      runSpacing: 16,
                                      // carte consultation design
                                      children: consultations.isNotEmpty
                                          ? consultations
                                              .map(
                                                (consultation) => InkWell(
                                                  onTap: () =>
                                                      _showConsultationModal(
                                                    context: context,
                                                    consultationData:
                                                        consultation,
                                                  ),
                                                  child: Container(
                                                    height: 170,
                                                    width: 140,
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey[400]!),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          "Fait par",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          "Dr ${consultation.medecin!.nom}",
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                        const Spacer(),
                                                        Center(
                                                          child:
                                                              SvgPicture.asset(
                                                            "assets/icons/Report.svg",
                                                            height: 65,
                                                            width: 70,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Text(
                                                          "Le ${consultation.creationDate!.day}/${consultation.creationDate!.month}/${consultation.creationDate!.year}",
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList()
                                          : [],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    // Pagination
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.arrow_back),
                                          onPressed: _page > 0
                                              ? () {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    setState(() {
                                                      _page--;
                                                    });
                                                  });
                                                }
                                              : null,
                                        ),
                                        Text("Page ${_page + 1} / $totalPages"),
                                        IconButton(
                                          icon: const Icon(Icons.arrow_forward),
                                          onPressed: _page + 1 < totalPages
                                              ? () {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    setState(() {
                                                      _page++;
                                                    });
                                                  });
                                                }
                                              : null,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return const EmptyContent();
                            }
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: SizedBox(
                                // height: 50,
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            print(snapshot.error
                                .toString()); // TODO: Montrer un pop-up contenant l'erreur.
                            return const Center(
                              child: SizedBox(
                                // height: 50,
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else {
                            return const Center(
                              child: SizedBox(
                                // height: 50,
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        }),
                  ),
                ),
                const SizedBox(
                  height: 16,
                )
              ],
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

  // Modal pour afficher les données d'une consultation.
  Future<void> _showConsultationModal({
    BuildContext? context,
    required Consultation consultationData,
  }) {
    return showDialog(
        context: context!,
        builder: (context) {
          return Dialog(
            child: FractionallySizedBox(
              heightFactor: 0.85,
              child: Box(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .8, // Largeur
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: const Text(
                                  "Fermer",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          const Text(
                            "Type de consultation:",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            consultationData.typeDeConsultation!.libelle,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Motif de la consultation:",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            consultationData.motifDeConsultation!.motif!,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Histoire de la maladie:",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            consultationData.histoireDeLaMaladie!,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Symptômes:",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            consultationData.symptome!,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Examen physique:",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            consultationData.histoireDeLaMaladie!,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Hypothèse de diagnostic:",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            consultationData.hypotheseDiagnostic!,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Diagnostic retenu:",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            consultationData.diagnosticRetenu!,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Bilan Biologique:",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            consultationData
                                    .bilan!.examensBiologique!.analyses!.isEmpty
                                ? " - "
                                : consultationData
                                    .bilan!.examensBiologique!.analyses!
                                    .map((toElement) => toElement.libelle)
                                    .toList()
                                    .join(', '),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Bilan Radiographique:",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            consultationData
                                    .bilan!.radiographie!.analyses!.isEmpty
                                ? " - "
                                : consultationData
                                    .bilan!.examensBiologique!.analyses!
                                    .map((toElement) => toElement.libelle)
                                    .toList()
                                    .join(', '),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Prescription:",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            consultationData.prescriptions!.isEmpty
                                ? " - "
                                : consultationData.prescriptions!
                                    .map((toElement) => toElement)
                                    .toList()
                                    .join(', '),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
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
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Patient: ${widget.patient.prenom} ${widget.patient.nom}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const Divider(
                color: Colors.grey,
              ),
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
                        context.showLoader();

                        List<Analyse> nonNullAnalyses = selectedAnalyses
                            .where((analyse) => analyse != null)
                            .cast<Analyse>()
                            .toList();

                        //Création des examens biologiques
                        ExamenBiologique examenBiologique = ExamenBiologique(
                          id: 0,
                          analyses: nonNullAnalyses,
                        );

                        List<Analyse> nonNullRadiosAnalyses =
                            selectedRadiosAnalyses
                                .where((analyse) => analyse != null)
                                .cast<Analyse>()
                                .toList();

                        Radiographie radiographie = Radiographie(
                          id: 0,
                          analyses: nonNullRadiosAnalyses,
                        );

                        // Créer un bilan avec les analyses non nulles
                        Bilan bilan = Bilan(
                          examensBiologique: examenBiologique,
                          radiographie: radiographie,
                        );
                        print("Bilan créé : ${bilan.toMap()}");

                        //   // Données consultation.
                        Map<String, dynamic> consultation = {
                          "id": 0,
                          "hypotheseDiagnostic":
                              hypotheseDiagnosticController.text,
                          "diagnosticRetenu": diagnosticRetenuController.text,
                          "examenPhysique": examenPhysiqueController.text,
                          "histoireDeLaMaladie":
                              histoireDeLaMaladieController.text,
                          "symptome": symptomeController.text,
                          "medecin": {"id": 0},
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

                        print(consultation);

                        String calculerAge(DateTime dateDeNaissance) {
                          final DateTime aujourdHui = DateTime.now();
                          int age = aujourdHui.year - dateDeNaissance.year;

                          // Vérifie si l'anniversaire de cette année est déjà passé
                          if (aujourdHui.month < dateDeNaissance.month ||
                              (aujourdHui.month == dateDeNaissance.month &&
                                  aujourdHui.day < dateDeNaissance.day)) {
                            age--;
                          }

                          return "$age";
                        }

                        //Logique pour sauvegarder la consultation
                        await consultationService
                            .creerConsultation(
                          consultation,
                          widget.patient.email,
                        )
                            .then((onValue) async {
                          context.read<MyData>().getNombreConsultation();
                          // context.read<MyData>().fetchConsultation();
                          context.hideLoader();
                          context.showSuccess("Ajoutée avec succès.");

                          // Génération des PDFs
                          await generateConsultationPdfs(
                            prescriptions: prescriptionControllers
                                .map((controller) => controller.text)
                                .where((text) => text.isNotEmpty)
                                .toList(),
                            examenAnalyses: bilan.examensBiologique?.analyses
                                    ?.map((analyse) => analyse.libelle ?? "")
                                    .toList() ??
                                [],
                            radiographieAnalyses: bilan.radiographie?.analyses
                                    ?.map((analyse) => analyse.libelle ?? "")
                                    .toList() ??
                                [],
                            nom: widget.patient.nom,
                            prenom: widget.patient.prenom,
                            age: calculerAge(widget.patient.dateDeNaissance!),
                            sexe: widget.patient.sexe[0],
                            profession: widget.patient.proffession ?? '',
                            domicile: '',
                          );

                          // // Générer les PDFs après l'enregistrement réussi

                          // // Liste des prescriptions
                          // List<String> prescriptions = prescriptionControllers
                          //     .map((controller) => controller.text)
                          //     .where((text) => text.isNotEmpty)
                          //     .toList();

                          // if (prescriptions.isNotEmpty) {
                          //   await generatePdf(
                          //     title: "Ordonnance Médicale",
                          //     content: prescriptions,
                          //   );
                          // }

                          // // Liste des analyses
                          // List<String> analyses = nonNullAnalyses
                          //     .map((analyse) =>
                          //         analyse.libelle ?? "Analyse inconnue")
                          //     .toList();

                          // if (analyses.isNotEmpty) {
                          //   await generatePdf(
                          //     title: "Bulletin d'Examen",
                          //     content: analyses,
                          //   );
                          // }
                        }).catchError((onError) {
                          context.hideLoader();
                          context.showError(onError.toString());
                        }).whenComplete(() {
                          setState(() {
                            widget.changeView();
                          });
                        });
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

  // ________________________________________________________________________

  Future<void> generateDynamicPdf({
    required String nom,
    required String prenom,
    required String age,
    required String sexe,
    required String profession,
    required String domicile,
    required String title,
    required List<String> content,
    bool isHorizontal = false,
  }) async {
    final pdf = pw.Document();
    // final image = (await rootBundle.load('assets/images/orange.png'))
    //     .buffer
    //     .asUint8List();
    final svgData = await rootBundle.loadString('assets/icons/logo_boite.svg');

    pdf.addPage(
      pw.MultiPage(
        pageFormat:
            isHorizontal ? PdfPageFormat.a5.landscape : PdfPageFormat.a5,
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      height: 70,
                      width: 70,
                      child: pw.SvgImage(
                        svg: svgData,
                        height: 70,
                        width: 70,
                      ),
                    ),
                    if (!title.contains('Ordonnance'))
                      pw.Text(
                        "Service Médecine d'Entreprise",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    if (title.contains('Ordonnance'))
                      pw.Text(
                        "Service Médecine\nd'Entreprise",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                if (title.contains('Ordonnance'))
                  pw.Text(
                    "$nom $prenom",
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
              ],
            ),
            if (title.contains('Ordonnance')) pw.SizedBox(height: 12.0),
            if (title.contains('Ordonnance'))
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    "Ordonnance médicale",
                    style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
            if (!title.contains('Ordonnance'))
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    "Bulletin D'Examen Médical",
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
            if (!title.contains('Ordonnance'))
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      "Nom: $nom",
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      "Prénom: $prenom",
                    ),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text(
                      "Age: $age",
                    ),
                  ),
                ],
              ),
            if (!title.contains('Ordonnance')) pw.SizedBox(height: 10.0),
            if (!title.contains('Ordonnance'))
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text(
                      "Sexe: $sexe",
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      "Profession: $profession",
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      "Domicile: $domicile",
                    ),
                  ),
                ],
              ),
          ],
        ),
        footer: (context) => pw.Column(
          children: [
            if (title.contains('Ordonnance'))
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    "Avec tous nos voeux de prompt rétablissement",
                    style: const pw.TextStyle(
                      fontSize: 10,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
            if (title.contains('Ordonnance'))
              pw.SizedBox(
                height: 16,
              ),
            if (title.contains('Ordonnance'))
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Date: ${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year.toString().padLeft(2, '0')}",
                        textAlign: pw.TextAlign.start,
                      ),
                      pw.SizedBox(
                        height: 16,
                      ),
                      pw.Text(
                        "Signature et cachet",
                        textAlign: pw.TextAlign.start,
                      ),
                    ],
                  ),
                ],
              ),
            if (!title.contains('Ordonnance'))
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      "Bamako, le ${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year.toString().padLeft(2, '0')}",
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      "Bamako, le .......................20..",
                    ),
                  ),
                ],
              ),
            if (!title.contains('Ordonnance')) pw.SizedBox(height: 10.0),
            if (!title.contains('Ordonnance'))
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      "Le Médecin traitant",
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      "Le Praticien sollicité",
                    ),
                  ),
                ],
              ),
          ],
        ),
        build: (context) {
          return [
            pw.SizedBox(
              height: 10,
            ),
            if (title.contains('Ordonnance'))
              pw.ListView.separated(
                separatorBuilder: (context, index) => pw.SizedBox(
                  height: 10,
                ),
                itemBuilder: (context, index) => pw.Text(
                  textAlign: pw.TextAlign.start,
                  "${index + 1}° - ${content[index]}",
                ),
                itemCount: content.length,
              ),
            if (title.contains("Bulletin d'Examen Biologique"))
              // Content (Table)
              pw.Flexible(
                child: pw.Container(
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        width: 0.5,
                      ),
                      right: pw.BorderSide(
                        width: 0.5,
                      ),
                      top: pw.BorderSide(
                        width: 0.5,
                      ),
                      left: pw.BorderSide(
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: pw.Row(children: [
                    pw.Expanded(
                      child: pw.Column(
                          //Coté droite
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Container(
                              height: 67,
                              width: double.infinity,
                              decoration: const pw.BoxDecoration(
                                border: pw.Border(
                                  bottom: pw.BorderSide(
                                    width: 0.5,
                                  ),
                                  right: pw.BorderSide(
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              padding: const pw.EdgeInsets.only(left: 10),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    'Nature de l\'examen',
                                    textAlign: pw.TextAlign.center,
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.Text(
                                    content.join(', '),
                                    textAlign: pw.TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                            pw.Container(
                              height: 45,
                              width: double.infinity,
                              decoration: const pw.BoxDecoration(
                                border: pw.Border(
                                  right: pw.BorderSide(
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              padding: const pw.EdgeInsets.only(left: 10),
                              child: pw.Text(
                                'Renseignement Clinique',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ]),
                    ),
                    pw.Expanded(
                      child: pw.Column(//Coté gauche
                          children: [
                        pw.Text(
                          'Résultat',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ]),
                    ),
                  ]),
                ),
              ),
            if (title.contains("Bulletin de Radiographie"))
              // Content (Table)
              pw.Flexible(
                child: pw.Container(
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        width: 0.5,
                      ),
                      right: pw.BorderSide(
                        width: 0.5,
                      ),
                      top: pw.BorderSide(
                        width: 0.5,
                      ),
                      left: pw.BorderSide(
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: pw.Row(children: [
                    pw.Expanded(
                      child: pw.Column(
                          //Coté droite
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Container(
                              height: 67,
                              width: double.infinity,
                              decoration: const pw.BoxDecoration(
                                border: pw.Border(
                                  bottom: pw.BorderSide(
                                    width: 0.5,
                                  ),
                                  right: pw.BorderSide(
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              padding: const pw.EdgeInsets.only(left: 10),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    'Nature de l\'examen',
                                    textAlign: pw.TextAlign.center,
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.Text(
                                    content.join(', '),
                                    textAlign: pw.TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                            pw.Container(
                              height: 45,
                              width: double.infinity,
                              decoration: const pw.BoxDecoration(
                                border: pw.Border(
                                  right: pw.BorderSide(
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              padding: const pw.EdgeInsets.only(left: 10),
                              child: pw.Text(
                                'Renseignement Clinique',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ]),
                    ),
                    pw.Expanded(
                      child: pw.Column(//Coté gauche
                          children: [
                        pw.Text(
                          'Résultat',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ]),
                    ),
                  ]),
                ),
              ),
            pw.SizedBox(
              height: 10,
            ),
          ];
        },
      ),
    );

    // Sauvegarde ou partage du PDF
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: "$title.pdf",
    );
  }

  // ________________________________________________________________________

  Future<void> generateConsultationPdfs({
    required List<String> prescriptions,
    required String nom,
    required String prenom,
    required String age,
    required String sexe,
    required String profession,
    required String domicile,
    required List<String> examenAnalyses,
    required List<String> radiographieAnalyses,
  }) async {
    // Générer l'ordonnance si des prescriptions existent
    if (prescriptions.isNotEmpty) {
      await generateDynamicPdf(
        nom: nom,
        prenom: prenom,
        age: age,
        sexe: sexe,
        profession: profession,
        domicile: domicile,
        title: "Ordonnance",
        content: prescriptions,
        isHorizontal: false, // Verticale
      );
    }

    // Générer un bulletin d'examen biologique si des analyses existent
    if (examenAnalyses.isNotEmpty) {
      await generateDynamicPdf(
        nom: nom,
        prenom: prenom,
        age: age,
        sexe: sexe,
        profession: profession,
        domicile: domicile,
        title: "Bulletin d'Examen Biologique",
        content: examenAnalyses,
        isHorizontal: true, // Horizontale
      );
    }

    // Générer un bulletin de radiographie si des analyses existent
    if (radiographieAnalyses.isNotEmpty) {
      await generateDynamicPdf(
        nom: nom,
        prenom: prenom,
        age: age,
        sexe: sexe,
        profession: profession,
        domicile: domicile,
        title: "Bulletin de Radiographie",
        content: radiographieAnalyses,
        isHorizontal: true, // Horizontale
      );
    }
  }
}
