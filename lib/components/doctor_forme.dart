import 'package:flutter/material.dart';
import 'package:medstory/components/champs_texte.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/medecin.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/role.dart';
import 'package:medstory/service/medecin_service.dart';
import 'package:medstory/utils/lodder.dart';
import 'package:provider/provider.dart';

class DoctorForm extends StatefulWidget {
  final void Function() changeView;
  const DoctorForm({super.key, required this.changeView});

  @override
  State<DoctorForm> createState() => DoctorStateForm();
}

class DoctorStateForm extends State<DoctorForm> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final medecinService = MedecinService();

  // Controllers pour récupérer les valeurs des champs
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController specialiteController = TextEditingController();
  TextEditingController matriculeController = TextEditingController();

  String? selectedSexe;
  final List<Map<String, String>> joursIntervention = [{}];

  final Map<String, String> joursFrancaisAnglais = {
    'Lundi': 'MONDAY',
    'Mardi': 'TUESDAY',
    'Mercredi': 'WEDNESDAY',
    'Jeudi': 'THURSDAY',
    'Vendredi': 'FRIDAY',
    'Samedi': 'SATURDAY',
    'Dimanche': 'SUNDAY'
  };

  Future<void> _selectTime(BuildContext context, int index, String key) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final hour = picked.hour
          .toString()
          .padLeft(2, '0'); // Convert hour to 24-hour format
      final minute = picked.minute
          .toString()
          .padLeft(2, '0'); // Add leading zero if needed
      setState(() {
        joursIntervention[index][key] = "$hour:$minute"; // Set in HH:mm format
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> Soumettre() async {
      if (passwordController.text.trim() ==
          passwordConfirmeController.text.trim()) {
        context.showLoader();

        // Traduire les jours en anglais et retirer les maps vides ou null de la liste des jours d'intervention
        final List<Map<String, String>> joursInterventionFiltres =
            joursIntervention
                .where((jour) =>
                    jour.isNotEmpty &&
                    jour.values.any((v) => v != null && v.isNotEmpty))
                .map((jour) {
          final jourTraduit =
              jour['jour'] != null ? joursFrancaisAnglais[jour['jour']] : null;
          return {
            'jour': jourTraduit!.toUpperCase() ?? '',
            'heureDebut': jour['heureDebut'] ?? '',
            'heureFin': jour['heureFin'] ?? '',
          };
        }).toList();

        // Créer l'objet Medecin avec les données renseignées
        final medecin = Medecin(
          nom: nameController.text,
          prenom: surnameController.text,
          sexe: selectedSexe ?? '',
          adresse: addressController.text,
          telephone: phoneController.text,
          email: emailController.text,
          matricule: matriculeController.text,
          specialite: specialiteController.text,
          joursIntervention: joursInterventionFiltres,
          id: 0,
          role: Role(id: 0, libelle: 'libelle'),
          motDePasse: passwordController.text.trim(),
          profileImage: null,
        );

        // Soumission données medecin.
        await medecinService.createMedecin(medecin).then((value) {
          context.read<MyData>().fetchMedecins();
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
                // Champ Matricule
                ChampsTexte.buildTextField('Matricule', matriculeController),
                // Champ Adresse
                ChampsTexte.buildTextField('Adresse', addressController),
                // Champ Spécialité
                ChampsTexte.buildTextField("Spécialité", specialiteController),
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
            title: const Text("Disponibilités"),
            content: Column(
              children: [
                for (int i = 0; i < joursIntervention.length; i++)
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration:
                              InputDecoration(labelText: 'Jour ${i + 1}'),
                          value: joursIntervention[i]['jour'],
                          items: [
                            'Lundi',
                            'Mardi',
                            'Mercredi',
                            'Jeudi',
                            'Vendredi',
                            'Samedi',
                            'Dimanche'
                          ].map((jour) {
                            return DropdownMenuItem(
                              value: jour,
                              child: Text(jour),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              joursIntervention[i]['jour'] = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          decoration:
                              const InputDecoration(labelText: "Heure Début"),
                          onTap: () => _selectTime(context, i, 'heureDebut'),
                          controller: TextEditingController(
                            text: joursIntervention[i]['heureDebut'],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          decoration:
                              const InputDecoration(labelText: "Heure Fin"),
                          onTap: () => _selectTime(context, i, 'heureFin'),
                          controller: TextEditingController(
                            text: joursIntervention[i]['heureFin'],
                          ),
                        ),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            joursIntervention.removeAt(i);
                          });
                        },
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          joursIntervention.add({});
                        });
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        "Ajouter un jour d'intervention",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Step(
            stepStyle: _currentStep >= 2
                ? const StepStyle(
                    color: primaryColor,
                  )
                : const StepStyle(
                    color: Colors.black,
                  ),
            isActive: _currentStep >= 1,
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
                // // Champ confirmation mdp
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
}
