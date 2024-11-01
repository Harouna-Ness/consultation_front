// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/components/champs_texte.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/controllers/controller.dart';
import 'package:medstory/models/analyse.dart';
import 'package:medstory/models/bilan.dart';
import 'package:medstory/models/consultation.dart';
import 'package:medstory/models/direction.dart';
import 'package:medstory/models/motif_de_consultation.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/models/site_de_tavail.dart';
import 'package:medstory/models/statut_patient.dart';
import 'package:medstory/models/type_de_consultation.dart';
import 'package:medstory/service/consultation_service.dart';
import 'package:medstory/service/patient_service.dart';
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

class ConsultationForm extends StatefulWidget {
  final BuildContext contexte;

  const ConsultationForm({super.key, required this.contexte});

  @override
  _ConsultationFormState createState() => _ConsultationFormState();
}

class _ConsultationFormState extends State<ConsultationForm> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Controllers pour récupérer les valeurs des champs
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  TextEditingController motifController = TextEditingController();
  TextEditingController typeConsultationController = TextEditingController();
  TextEditingController symptomeController = TextEditingController();
  TextEditingController diagnosticController = TextEditingController();

  // Valeurs pour les selects
  String? selectedSexe;
  String? selectedStatut;

  DateTime? _selectedDate;
  Direction? _selectedDirection;
  Sitedetravail? _selectedSite;
  MotifDeConsultation? _selectedMotifDeConsultation;
  StatutPatient? _selectedStatutPatient;
  TypeDeConsultation? _selectedTypeDeConsultation;

  List<Analyse?> selectedAnalyses = [null];

  Patient? _selectedPatient;

  @override
  Widget build(BuildContext context) {
    final patientService = PatientService();
    final consultationService = ConsultationService();
    List<Direction> directions = widget.contexte.watch<MyData>().directions;
    List<Sitedetravail> sitesDeTravails =
        widget.contexte.watch<MyData>().siteDetravails;
    List<MotifDeConsultation> motifDeConsultations =
        widget.contexte.watch<MyData>().motifDeConsultations;
    List<StatutPatient> statutPatients =
        widget.contexte.watch<MyData>().statutPatients;
    List<Analyse> analyses = widget.contexte.watch<MyData>().analyses;
    List<TypeDeConsultation> typeDeConsultations =
        widget.contexte.watch<MyData>().typeDeConsultations;
    List<Patient> patients = widget.contexte.watch<MyData>().patients;

    return Form(
      key: _formKey,
      child: Stepper(
        currentStep: _currentStep,
        onStepTapped: (step) => setState(() => _currentStep = step),
        onStepContinue: () async {
          if (_currentStep < 1) {
            setState(() => _currentStep += 1);
          } else {
            if (_formKey.currentState!.validate()) {
              bool callConsultationApi = false;

              context.showLoader();

              List<Analyse> nonNullAnalyses = selectedAnalyses
                  .where((analyse) => analyse != null)
                  .cast<Analyse>()
                  .toList();

              // Créer un bilan avec les analyses non nulles
              Bilan bilan = Bilan(analyses: nonNullAnalyses);

              // Données patient.
              Map<String, dynamic> patientData = {
                'nom': nameController.text,
                'prenom': surnameController.text,
                'sexe': selectedSexe,
                'dateDeNaissance':
                    "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}",
                'telephone': phoneController.text,
                'email': emailController.text,
                'adresse': addressController.text,
                'siteDeTravail':
                    _selectedSite != null ? {"id": _selectedSite!.id} : null,
                'direction': _selectedDirection != null
                    ? {'id': _selectedDirection!.id}
                    : null,
                'proffession': professionController.text,
                'statut': _selectedStatutPatient != null
                    ? {"id": _selectedStatutPatient!.id}
                    : null,
                'motDePasse': passwordController.text,
              };

              // Données consultation.
              Map<String, dynamic> consultation = {
                "id": 0,
                "diagnostic": motifController.text,
                "symptome": "sylto",
                "medecin": {"id": 1},
                "typeDeConsultation": _selectedTypeDeConsultation != null
                    ? {"id": _selectedTypeDeConsultation!.id}
                    : null,
                "motifDeConsultation": _selectedMotifDeConsultation != null
                    ? {"id": _selectedMotifDeConsultation!.id}
                    : null,
                "bilan": bilan.toMap(),
                // }
              };

              // Soumission données patient.
              await patientService.addPatient(patientData).then((value) {
                context.read<MyData>().getNombrePatient();
                callConsultationApi = true;
              }).catchError((onError) {
                context.hideLoader();
                context.showError(onError.toString());
              });

              //TODO Logique pour sauvegarder la consultation
              if (callConsultationApi) {
                await consultationService
                    .creerConsultation(consultation, emailController.text)
                    .then((onValue) {
                  context.read<MyData>().getNombreConsultation();
                  context.hideLoader();
                  context.showSuccess("Ajoutée avec succès.");
                }).whenComplete(() {
                  context.read<MyMenuController>().changePage(1);
                });
              }
            }
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          }
        },
        controlsBuilder: (context, details) {
          return Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      "Continuer",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: details.onStepCancel,
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
          );
        },
        steps: [
          Step(
            state: _currentStep >= 1 ? StepState.complete : StepState.indexed,
            stepStyle: _currentStep >= 0
                ? const StepStyle(
                    color: primaryColor,
                  )
                : const StepStyle(
                    color: Colors.black,
                  ),
            isActive: _currentStep >= 0,
            title: const Text("Patient"),
            content: Column(
              children: [
                // Champ Nom
                Row(
                  children: [
                    Expanded(
                      child: _selectedPatient != null
                          ? Text("Nom : ${_selectedPatient!.nom}")
                          : ChampsTexte.buildTextField("Nom", nameController),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: logique de selection d'un patient afin de preremplir le formulaire.
                        // selectionModal(context);
                        selectionModal(context, patients);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        "Selectionner",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                // Champ Prénom
                ChampsTexte.buildTextField("Prénom", surnameController),
                // Champ Sexe
                ChampsTexte.buildSelectField(
                    'Sexe', ['Masculin', 'Féminin'], selectedSexe, (value) {
                  setState(() {
                    selectedSexe = value;
                  });
                }),
                // Champ Date de naissance
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: "Date de naissance"),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                        dobController.text;
                      });
                    }
                  },
                  readOnly: true,
                  validator: (value) =>
                      _selectedDate == null ? 'Champ requis' : null,
                  controller: TextEditingController(
                      text: _selectedDate != null
                          ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                          : ""),
                ),

                // Champ Adresse
                ChampsTexte.buildTextField('Adresse', addressController),

                // Champ Statut
                DropdownButtonFormField<StatutPatient>(
                  decoration: const InputDecoration(labelText: "Statut"),
                  value: _selectedStatutPatient,
                  onChanged: (value) =>
                      setState(() => _selectedStatutPatient = value),
                  items: statutPatients
                      .map((statut) => DropdownMenuItem(
                            value: statut,
                            child: Text(statut.libelle),
                          ))
                      .toList(),
                  validator: (value) => value == null ? 'Champ requis' : null,
                ),
                // Champs Téléphone
                ChampsTexte.buildTextField('Téléphone', phoneController,
                    keyboardType: TextInputType.phone),
                // Champ Profession
                ChampsTexte.buildTextField("Profession", professionController),
                // Champ Direction
                DropdownButtonFormField<Direction>(
                  decoration: const InputDecoration(labelText: "Direction"),
                  value: _selectedDirection,
                  onChanged: (value) =>
                      setState(() => _selectedDirection = value),
                  items: directions
                      .map((direction) => DropdownMenuItem(
                            value: direction,
                            child: Text(direction.nom),
                          ))
                      .toList(),
                  validator: (value) => value == null ? 'Champ requis' : null,
                ),
                // Champ Site de Travail
                DropdownButtonFormField<Sitedetravail>(
                  decoration:
                      const InputDecoration(labelText: "Site de Travail"),
                  value: _selectedSite,
                  onChanged: (value) => setState(() => _selectedSite = value),
                  items: sitesDeTravails
                      .map((site) => DropdownMenuItem(
                            value: site,
                            child: Text(site.nom),
                          ))
                      .toList(),
                  validator: (value) => value == null ? 'Champ requis' : null,
                ),
                // Champ Email
                ChampsTexte.buildTextField('Email', emailController,
                    keyboardType: TextInputType.emailAddress),
                // Champ mot de passe
                ChampsTexte.buildPasswordField(passwordController),
                // Champ confirmation mdp
              ],
            ),
          ),
          Step(
            stepStyle: _currentStep >= 1
                ? const StepStyle(
                    color: primaryColor,
                  )
                : const StepStyle(
                    color: Colors.black,
                  ),
            isActive: _currentStep >= 1,
            title: const Text("Consultation"),
            content: Column(
              children: [
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
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            selectedAnalyses
                                .add(null); // Ajouter un nouveau champ
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 125, 123, 129),
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
            child: Padding(
              padding: const EdgeInsets.all(16.0 * 2),
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
                                    nameController.text = patients[index].nom;
                                    surnameController.text =
                                        patients[index].prenom;
                                    phoneController.text =
                                        patients[index].telephone;
                                    selectedSexe = patients[index].sexe;
                                    _selectedDate =
                                        patients[index].dateDeNaissance;
                                    _selectedSite =
                                        patients[index].sitedetravail;
                                    _selectedDirection =
                                        patients[index].direction;
                                    professionController.text =
                                        patients[index].proffession ?? '';
                                    _selectedStatutPatient =
                                        patients[index].statut;
                                  });
                                  Navigator.of(context)
                                      .pop(); // Fermer le modal
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

// le formulaire complet de la partie consultation......................................................
// Step(
//   title: const Text('Consultation'),
//   content: Column(
//     children: [
//       // Champ pour le diagnostic
//       TextFormField(
//         decoration: const InputDecoration(
//           labelText: 'Diagnostic',
//           border: OutlineInputBorder(),
//         ),
//         onSaved: (value) {
//           consultation.diagnostic = value;
//         },
//       ),
//       const SizedBox(height: 16),

//       // Champ pour le symptôme
//       TextFormField(
//         decoration: const InputDecoration(
//           labelText: 'Symptômes',
//           border: OutlineInputBorder(),
//         ),
//         onSaved: (value) {
//           consultation.symptome = value;
//         },
//       ),
//       const SizedBox(height: 16),

//       // Sélection du motif de consultation
//       DropdownButtonFormField<MotifDeConsultation>(
//         decoration: const InputDecoration(
//           labelText: 'Motif de consultation',
//           border: OutlineInputBorder(),
//         ),
//         items: motifsDeConsultation.map((MotifDeConsultation motif) {
//           return DropdownMenuItem<MotifDeConsultation>(
//             value: motif,
//             child: Text(motif.motif ?? ''),
//           );
//         }).toList(),
//         onChanged: (MotifDeConsultation? newValue) {
//           setState(() {
//             consultation.motifDeConsultation = newValue;
//           });
//         },
//         value: consultation.motifDeConsultation,
//       ),
//       const SizedBox(height: 16),

//       // Sélection du type de consultation
//       DropdownButtonFormField<TypeDeConsultation>(
//         decoration: const InputDecoration(
//           labelText: 'Type de consultation',
//           border: OutlineInputBorder(),
//         ),
//         items: typesDeConsultation.map((TypeDeConsultation type) {
//           return DropdownMenuItem<TypeDeConsultation>(
//             value: type,
//             child: Text(type.libelle),
//           );
//         }).toList(),
//         onChanged: (TypeDeConsultation? newValue) {
//           setState(() {
//             consultation.typeDeConsultation = newValue;
//           });
//         },
//         value: consultation.typeDeConsultation,
//       ),
//       const SizedBox(height: 16),

//       // Sélection des analyses pour le bilan
//       DropdownButtonFormField<List<Analyse>>(
//         decoration: const InputDecoration(
//           labelText: 'Analyses (Bilan)',
//           border: OutlineInputBorder(),
//         ),
//         items: analyses.map((Analyse analyse) {
//           return DropdownMenuItem<Analyse>(
//             value: analyse,
//             child: Text(analyse.libelle ?? ''),
//           );
//         }).toList(),
//         onChanged: (List<Analyse>? selectedAnalyses) {
//           setState(() {
//             consultation.bilan?.analyses = selectedAnalyses ?? [];
//           });
//         },
//         value: consultation.bilan?.analyses,
//       ),
//     ],
//   ),
// ),..............................................................................

// class ConsultationStepper extends StatefulWidget {
//   @override
//   _ConsultationStepperState createState() => _ConsultationStepperState();
// }

// class _ConsultationStepperState extends State<ConsultationStepper> {
//   int _currentStep = 0;
//   final _formKey = GlobalKey<FormState>();

//   // Controllers for patient information
//   TextEditingController prenomController = TextEditingController();
//   TextEditingController nomController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//   TextEditingController professionController = TextEditingController();

//   // Controllers for consultation information
//   TextEditingController motifController = TextEditingController();
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;

//   // Fonction pour valider les données du patient
//   bool validatePatientInfo() {
//     return prenomController.text.isNotEmpty &&
//         nomController.text.isNotEmpty &&
//         ageController.text.isNotEmpty &&
//         professionController.text.isNotEmpty;
//   }

//   // Fonction pour valider les données de la consultation
//   bool validateConsultationInfo() {
//     return motifController.text.isNotEmpty && selectedDate != null && selectedTime != null;
//   }

//   // Fonction pour choisir la date
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }

//   // Fonction pour choisir l'heure
//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null && picked != selectedTime) {
//       setState(() {
//         selectedTime = picked;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Nouvelle Consultation"),
//       ),
//       body: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             Expanded(
//               child: Stepper(
//                 currentStep: _currentStep,
//                 onStepTapped: (step) => setState(() => _currentStep = step),
//                 onStepContinue: () {
//                   if (_currentStep == 0 && validatePatientInfo()) {
//                     setState(() => _currentStep += 1);
//                   } else if (_currentStep == 1 && validateConsultationInfo()) {
//                     // Soumettre les données ici ou continuer
//                     // Par exemple: envoyer les données au backend ou autre
//                     print("Consultation soumise");
//                   }
//                 },
//                 onStepCancel: () {
//                   if (_currentStep > 0) {
//                     setState(() => _currentStep -= 1);
//                   }
//                 },
//                 steps: [
//                   // Step 1: Informations du patient
//                   Step(
//                     title: Text("Informations Patient"),
//                     isActive: _currentStep >= 0,
//                     state: _currentStep > 0
//                         ? StepState.complete
//                         : StepState.indexed,
//                     content: Column(
//                       children: [
//                         TextFormField(
//                           controller: prenomController,
//                           decoration: InputDecoration(labelText: "Prénom"),
//                         ),
//                         TextFormField(
//                           controller: nomController,
//                           decoration: InputDecoration(labelText: "Nom"),
//                         ),
//                         TextFormField(
//                           controller: ageController,
//                           decoration: InputDecoration(labelText: "Âge"),
//                           keyboardType: TextInputType.number,
//                         ),
//                         TextFormField(
//                           controller: professionController,
//                           decoration: InputDecoration(labelText: "Profession"),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Step 2: Informations de la consultation
//                   Step(
//                     title: Text("Informations Consultation"),
//                     isActive: _currentStep >= 1,
//                     state: _currentStep > 1
//                         ? StepState.complete
//                         : StepState.indexed,
//                     content: Column(
//                       children: [
//                         TextFormField(
//                           controller: motifController,
//                           decoration: InputDecoration(labelText: "Motif"),
//                         ),
//                         ListTile(
//                           title: Text(selectedDate == null
//                               ? "Sélectionner une date"
//                               : "Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
//                           trailing: Icon(Icons.calendar_today),
//                           onTap: () => _selectDate(context),
//                         ),
//                         ListTile(
//                           title: Text(selectedTime == null
//                               ? "Sélectionner une heure"
//                               : "Heure: ${selectedTime!.format(context)}"),
//                           trailing: Icon(Icons.access_time),
//                           onTap: () => _selectTime(context),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Bouton de navigation entre les étapes
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_currentStep == 0) {
//                       if (validatePatientInfo()) {
//                         setState(() => _currentStep += 1);
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                                 "Veuillez remplir les informations du patient."),
//                           ),
//                         );
//                       }
//                     } else if (_currentStep == 1) {
//                       if (validateConsultationInfo()) {
//                         // Soumission finale
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                                 "Consultation soumise avec succès !"),
//                           ),
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                                 "Veuillez remplir les informations de la consultation."),
//                           ),
//                         );
//                       }
//                     }
//                   },
//                   child: Text(_currentStep == 0 ? "Continuer" : "Soumettre"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
