import 'package:flutter/material.dart';
import 'package:medstory/components/champs_texte.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/direction.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/models/role.dart';
import 'package:medstory/models/site_de_tavail.dart';
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
  final _formKey = GlobalKey<FormState>();
  final patientService = PatientService();

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  String? selectedSexe;
  // Valeurs pour les selects
  String? selectedStatut;

  // Listes des suggestions pour les champs d'auto-complétion
  List<Direction> directions = [];
  List<Sitedetravail> sitesDeTravails = [];
  Direction? selectedDirection;
  Sitedetravail? selectedsitedetravail;
  @override
  Widget build(BuildContext context) {
    directions = context.watch<MyData>().directions;
    sitesDeTravails = context.watch<MyData>().siteDetravails;

    Future<void> Soumettre() async {
      if (passwordController.text.trim() ==
          passwordConfirmeController.text.trim()) {
        context.showLoader();

        // Créer l'objet Medecin avec les données renseignées
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
          dateDeNaissance: null,
          proffession: '',
          sitedetravail: null,
          direction: null,
          dossierMedical: null,
          statut: null, profileImage: null,
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
      if (_currentStep < 2) {
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

                // Champs Téléphone
                ChampsTexte.buildTextField('Téléphone', phoneController,
                    keyboardType: TextInputType.phone),
                // Champ Adresse
                ChampsTexte.buildTextField('Adresse', addressController),
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
                ChampsTexte.buildPasswordField(passwordController),
                // Champ confirmation mdp
                ChampsTexte.buildPasswordField(passwordConfirmeController),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
