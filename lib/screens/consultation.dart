// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/components/champs_texte.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/controllers/controller.dart';
import 'package:medstory/models/direction.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/site_de_tavail.dart';
import 'package:medstory/service/consultation_service.dart';
import 'package:medstory/service/patient_service.dart';
import 'package:medstory/utils/lodder.dart';
import 'package:provider/provider.dart';

class Consultation extends StatefulWidget {
  const Consultation({super.key});

  @override
  State<Consultation> createState() => _ConsultationState();
}

class _ConsultationState extends State<Consultation> {
  @override
  Widget build(BuildContext context) {
    return Box(
      child: ConsultationForm(
        contexte: context,
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

  // Champs du formulaire
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

  @override
  Widget build(BuildContext context) {
    final patientService = PatientService();
    final consultationService = ConsultationService();
    List<Direction> directions = widget.contexte.watch<MyData>().directions;
    List<Sitedetravail> sitesDeTravails =
        widget.contexte.watch<MyData>().siteDetravails;

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

              // Données patient.
              Map<String, dynamic> patientData = {
                'nom': nameController.text,
                'prenom': surnameController.text,
                'sexe': selectedSexe,
                'dateDeNaissance':
                    "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}",
                'telephone': phoneController.text,
                'email': emailController.text,
                'adresse': addressController.text,
                'siteDeTravail':
                    _selectedSite != null ? {"id": _selectedSite!.id} : null,
                'direction': _selectedDirection != null
                    ? {'id': _selectedDirection!.id}
                    : null,
                'proffession': professionController.text,
                'statut': {"id": 1, "libelle": "Nouveau"},
                'motDePasse': passwordController.text,
              };

              // Données consultation.
              Map<String, dynamic> consultation = {
                "id": 0,
                "diagnostic": motifController.text,
                "symptome": "sylto",
                "medecin": {"id": 1},
                "typeDeConsultation": {"id": 1},
                "motifDeConsultation": {"id": 1},
                "bilan": {
                  "id": 0,
                  "analyses": [
                    {"id": 2, "libelle": "analyse A"},
                    {"id": 1, "libelle": "analyse b"}
                  ]
                }
              };

              // Soumission données patient.
              await patientService.addPatient(patientData).then((value) {
                context.read<MyData>().getNombrePatient();
                callConsultationApi = true;
              }).catchError((onError) {
                context.hideLoader();
                context.showError(onError.toString());
              });

              // Logique pour sauvegarder la consultation
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
                      child: ChampsTexte.buildTextField("Nom", nameController),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: logique de selection d'un patient afin de preremplir le formulaire.
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
                ChampsTexte.buildSelectField(
                    'Statut', ['Celibataire', 'Marié'], selectedStatut,
                    (value) {
                  setState(() {
                    selectedStatut = value;
                  });
                }),
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
                // Champ Motif
                ChampsTexte.buildTextField(
                    "Motif de la consultation", motifController),
                // TODO: le reste ici.
              ],
            ),
          ),
        ],
      ),
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
