import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medstory/components/champs_texte.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/direction.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/models/role.dart';
import 'package:medstory/models/site_de_tavail.dart';
import 'package:medstory/models/statut_patient.dart';
import 'package:medstory/service/patient_service.dart';
import 'package:medstory/utils/lodder.dart';
import 'package:provider/provider.dart';

class PatientForm extends StatefulWidget {
  final void Function() changeView;
  const PatientForm({super.key, required this.changeView});

  @override
  State<PatientForm> createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  int _currentStep = 0;

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final _formKey = GlobalKey<FormState>();
  final patientService = PatientService();

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController professionController = TextEditingController();

  // Listes des suggestions pour les champs d'auto-complétion
  List<Direction> directions = [];
  List<Sitedetravail> sitesDeTravails = [];
  List<StatutPatient> statutPatients = [];

  // Valeurs pour les selects
  String? selectedSexe;
  StatutPatient? selectedStatut;
  Direction? selectedDirection;
  Sitedetravail? selectedsitedetravail;
  DateTime? _selectedDate;
  @override
  Widget build(BuildContext context) {
    directions = context.watch<MyData>().directions;
    sitesDeTravails = context.watch<MyData>().siteDetravails;
    statutPatients = context.watch<MyData>().statutPatients;

    Future<void> Soumettre() async {
      if (passwordController.text.trim() ==
          passwordConfirmeController.text.trim()) {
        context.showLoader();

        // Créer l'objet Patient avec les données renseignées
        final patient = Patient(
          nom: nameController.text,
          prenom: surnameController.text,
          sexe: selectedSexe ?? '',
          adresse: addressController.text,
          telephone: phoneController.text,
          email: emailController.text,
          id: 0,
          role: Role(id: 0, libelle: 'libelle'),
          motDePasse: passwordController.text.trim(),
          dateDeNaissance: _selectedDate,
          proffession: professionController.text,
          sitedetravail: selectedsitedetravail,
          direction: selectedDirection,
          dossierMedical: null,
          statut: selectedStatut,
          profileImage: null,
        );
        // Soumission données patient.
        await patientService.addPatient(patient.toMap()).then((value) {
          context.read<MyData>().fetchPatients();
          context.hideLoader();
          setState(() {
            widget.changeView();
          });
          context.showSuccess("Ajoutée avec succès.");
        }).catchError((onError) {
          context.hideLoader();
          context.showError(onError.toString());
        });
      } else {
        context.showSnackError("Les mots de passe ne correspondent pas");
      }
    }

    void nextStep() {
      if (_currentStep < 1) {
        setState(() => _currentStep += 1);
      } else {
        if (_formKey.currentState!.validate()) {
          // Soumettre le formulaire
          Soumettre();
        }
      }
    }

    void previousStep() {
      if (_currentStep > 0) {
        setState(() => _currentStep -= 1);
      } else if (_currentStep == 0) {
        widget.changeView();
      }
    }

    return Form(
      key: _formKey,
      child: Stepper(
        currentStep: _currentStep,
        onStepTapped: (step) => setState(() => _currentStep = step),
        onStepContinue: nextStep,
        onStepCancel: previousStep,
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
            title: const Text("Information personnelle"),
            content: Column(
              children: [
                // Champ Nom
                ChampsTexte.buildTextField("Nom", nameController),
                // Champ Prénom
                ChampsTexte.buildTextField("Prénom", surnameController),
                // Champ Sexe
                ChampsTexte.buildSelectField(
                    'Sexe', ['Masculin', 'Féminin'], selectedSexe, (value) {
                  setState(() {
                    selectedSexe = value;
                  });
                }),
                // champ date de naissace
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Champ requis';
                        }
                        return null;
                      },
                      controller: TextEditingController(
                        text: _selectedDate != null
                            ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                            : '',
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Date de naissance',
                      ),
                    ),
                  ),
                ),
                // Champs Téléphone
                ChampsTexte.buildTextField('Téléphone', phoneController,
                    keyboardType: TextInputType.phone),
                // Champ Adresse
                ChampsTexte.buildTextField('Adresse', addressController),
                // champ statut
                DropdownButtonFormField<StatutPatient>(
                  decoration:
                      const InputDecoration(labelText: "Statut du patient"),
                  value: selectedStatut,
                  onChanged: (value) => setState(() => selectedStatut = value),
                  items: statutPatients
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.libelle),
                          ))
                      .toList(),
                  validator: (value) => value == null ? 'Champ requis' : null,
                ),
                // champ direction
                DropdownButtonFormField<Direction>(
                  decoration: const InputDecoration(labelText: "Direction"),
                  value: selectedDirection,
                  onChanged: (value) =>
                      setState(() => selectedDirection = value),
                  items: directions
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.nom),
                          ))
                      .toList(),
                  validator: (value) => value == null ? 'Champ requis' : null,
                ),
                // champ site de travail
                DropdownButtonFormField<Sitedetravail>(
                  decoration:
                      const InputDecoration(labelText: "Site de travail"),
                  value: selectedsitedetravail,
                  onChanged: (value) =>
                      setState(() => selectedsitedetravail = value),
                  items: sitesDeTravails
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.nom),
                          ))
                      .toList(),
                  validator: (value) => value == null ? 'Champ requis' : null,
                ),
                // champ profession
                ChampsTexte.buildTextField("Profession", professionController),
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
            isActive: _currentStep >= 0,
            title: const Text("Identifiants du compte"),
            content: Column(
              children: [
                // Champ Email
                ChampsTexte.buildTextField('Email', emailController,
                    keyboardType: TextInputType.emailAddress),
                // Champ mot de passe
                ChampsTexte.buildPasswordField(
                  passwordController,
                  _obscureText,
                  _togglePasswordVisibility,
                ),
                // Champ confirmation mdp
                ChampsTexte.buildPasswordField(
                  passwordConfirmeController,
                  _obscureText,
                  _togglePasswordVisibility,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1874),
      lastDate: initialDate,
    );
    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
    }
  }
}
