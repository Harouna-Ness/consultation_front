import 'package:flutter/material.dart';
import 'package:medstory/models/direction.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/models/site_de_tavail.dart';
import 'package:provider/provider.dart';

class EditPatientModal extends StatefulWidget {
  final Patient patient;
  final BuildContext contexte;
  final Function(Map<String, dynamic>) onSubmit;

  const EditPatientModal(
      {super.key,
      required this.patient,
      required this.onSubmit,
      required this.contexte});

  @override
  _EditPatientModalState createState() => _EditPatientModalState();
}

class _EditPatientModalState extends State<EditPatientModal> {
  final _formKey = GlobalKey<FormState>();

  // Controllers pour pré-remplir le formulaire
  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController dobController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController professionController;
  late TextEditingController siteController;
  late TextEditingController directionController;
  late TextEditingController passwordController = TextEditingController();
  String? selectedSexe;
  Direction? selectedDirection;
  List<Direction> directions = [];
  Sitedetravail? selectedsitedetravail;
  List<Sitedetravail> sitesDeTravails = [];

  @override
  void initState() {
    super.initState();
    // Initialiser les controllers avec les données du patient
    nameController = TextEditingController(text: widget.patient.nom);
    surnameController = TextEditingController(text: widget.patient.prenom);
    passwordController = TextEditingController(text: widget.patient.motDePasse);
    dobController = TextEditingController(
        text: widget.patient.dateDeNaissance?.day
            .toString()); // à adapter selon le format
    phoneController = TextEditingController(text: widget.patient.telephone);
    emailController = TextEditingController(text: widget.patient.email);
    addressController = TextEditingController(text: widget.patient.adresse);
    professionController =
        TextEditingController(text: widget.patient.proffession?? '');
    siteController =
        TextEditingController(text: widget.patient.sitedetravail?.nom ?? '');
    directionController =
        TextEditingController(text: widget.patient.direction?.nom ?? '');

    selectedSexe = widget.patient.sexe;
    selectedDirection = widget.patient.direction;
    selectedsitedetravail = widget.patient.sitedetravail;
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    dobController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    professionController.dispose();
    siteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    directions = widget.contexte.watch<MyData>().directions;
    sitesDeTravails =  widget.contexte.watch<MyData>().siteDetravails;
    return Dialog(
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: AlertDialog(
          title: const Text('Modifier le Patient'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nom
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nom'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le nom';
                      }
                      return null;
                    },
                  ),
                  // Prénom
                  TextFormField(
                    controller: surnameController,
                    decoration: const InputDecoration(labelText: 'Prénom'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le prénom';
                      }
                      return null;
                    },
                  ),
                  // Sexe
                  DropdownButtonFormField<String>(
                    value: selectedSexe,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSexe = newValue!;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Sexe'),
                    items: <String>['Masculin', 'Féminin']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez sélectionner le sexe';
                      }
                      return null;
                    },
                  ),
                  // Date de Naissance
                  TextFormField(
                    controller: dobController,
                    decoration:
                        const InputDecoration(labelText: 'Date de Naissance'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer la date de naissance';
                      }
                      return null;
                    },
                  ),
                  // Téléphone
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Téléphone'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le téléphone';
                      }
                      return null;
                    },
                  ),
                  // Email
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer l\'email';
                      }
                      return null;
                    },
                  ),
                  // Adresse
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Adresse'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer l\'adresse';
                      }
                      return null;
                    },
                  ),
                  // Profession
                  TextFormField(
                    controller: professionController,
                    decoration: const InputDecoration(labelText: 'Profession'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer la profession';
                      }
                      return null;
                    },
                  ),
                  // Site de Travail
                  buildAutocompletesitedetravailField(
                      'Site de Travail', siteController, sitesDeTravails),
                  // Direction (Autocomplete)
                  buildAutocompleteDirectinField(
                      'Direction', directionController, directions),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Récupérer les valeurs des champs et appeler la méthode de modification
                  final updatedPatient = {
                    'id': widget.patient.id,
                    'nom': nameController.text,
                    'prenom': surnameController.text,
                    'sexe': selectedSexe,
                    'dateDeNaissance': dobController.text,
                    'telephone': phoneController.text,
                    'email': emailController.text,
                    'adresse': addressController.text,
                    'direction': selectedDirection != null
                        ? {'id': selectedDirection!.id}
                        : null,
                    'siteDeTravail': selectedsitedetravail != null
                        ? {'id': selectedsitedetravail!.id}
                        : null,
                    'proffession': professionController.text,
                    'statut': {"id": widget.patient.statut!.id},
                    'motDePasse': passwordController.text,
                  };
                  widget.onSubmit(updatedPatient);
                  Navigator.pop(context);
                }
              },
              child: const Text('Sauvegarder'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAutocompleteDirectinField(String label,
      TextEditingController controller, List<Direction> directions) {
    return Autocomplete<Direction>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Direction>.empty();
        }
        return directions.where((Direction direction) {
          return direction.nom
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      displayStringForOption: (Direction direction) => direction.nom,
      onSelected: (Direction selection) {
        controller.text = selection.nom;
        selectedDirection = selection; // Enregistrer la direction sélectionnée
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer ou sélectionner $label';
            }
            return null;
          },
        );
      },
    );
  }

  Widget buildAutocompletesitedetravailField(String label,
      TextEditingController controller, List<Sitedetravail> sitedetravails) {
    return Autocomplete<Sitedetravail>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Sitedetravail>.empty();
        }
        return sitedetravails.where((Sitedetravail site) {
          return site.nom
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      displayStringForOption: (Sitedetravail site) => site.nom,
      onSelected: (Sitedetravail selection) {
        controller.text = selection.nom;
        selectedsitedetravail = selection;
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer ou sélectionner $label';
            }
            return null;
          },
        );
      },
    );
  }
}
