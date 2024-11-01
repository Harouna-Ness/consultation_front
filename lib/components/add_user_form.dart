import 'package:flutter/material.dart';
import 'package:medstory/models/direction.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/site_de_tavail.dart';
import 'package:medstory/models/statut_patient.dart';
import 'package:provider/provider.dart';

class AddUserForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final BuildContext contexte;

  const AddUserForm({
    super.key,
    required this.onSubmit,
    required this.contexte,
  });

  @override
  _AddUserFormState createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // widget.contexte.read<MyData>().fetchDirections();
  }

  // Controllers pour récupérer les valeurs des champs
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController directionController = TextEditingController();
  TextEditingController siteController = TextEditingController();
  TextEditingController statutController = TextEditingController();

  // Valeurs pour les selects
  String? selectedSexe;
  String? selectedStatut;

  // Listes des suggestions pour les champs d'auto-complétion
  List<Direction> directions = [];
  List<Sitedetravail> sitesDeTravails = [];
  List<StatutPatient> statusPatient = [];
  Direction? selectedDirection;
  Sitedetravail? selectedsitedetravail;
  StatutPatient? statutSelected;

  @override
  Widget build(BuildContext context) {
    directions = widget.contexte.watch<MyData>().directions;
    sitesDeTravails = widget.contexte.watch<MyData>().siteDetravails;
    statusPatient = widget.contexte.watch<MyData>().statutPatients;
    print("${directions.length} liste des d");
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
            children: [
              Expanded(child: buildTextField('Nom', nameController)),
              const SizedBox(width: 16),
              Expanded(child: buildTextField('Prénom', surnameController)),
            ],
          ),
          const SizedBox(height: 16),
          buildSelectField(
            'Sexe',
            ['Masculin', 'Féminin'],
            selectedSexe,
            (value) {
              setState(() {
                selectedSexe = value;
              });
            },
          ),
          const SizedBox(height: 16),
          buildTextField('Date de Naissance', dobController,
              keyboardType: TextInputType.datetime),
          const SizedBox(height: 16),
          buildTextField('Téléphone', phoneController,
              keyboardType: TextInputType.phone),
          const SizedBox(height: 16),
          buildTextField('Email', emailController,
              keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 16),
          buildTextField('Adresse', addressController),
          const SizedBox(height: 16),
          buildAutocompleteStatutField(
              'Statut', statutController, statusPatient),
          const SizedBox(height: 16),
          buildAutocompleteDirectinField(
              'Direction', directionController, directions),
          const SizedBox(height: 16),
          buildAutocompletesitedetravailField(
              'Site de Travail', siteController, sitesDeTravails),
          const SizedBox(height: 16),
          buildTextField('Profession', professionController),
          const SizedBox(height: 16),
          buildSelectField('Statut', ['Actif', 'Inactif'], selectedStatut,
              (value) {
            setState(() {
              selectedStatut = value;
            });
          }),
          const SizedBox(height: 16),
          buildPasswordField(),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Récupérer les valeurs des champs et les passer via le callback
                widget.onSubmit({
                  'nom': nameController.text,
                  'prenom': surnameController.text,
                  'sexe': selectedSexe,
                  'dateDeNaissance': dobController.text,
                  'telephone': phoneController.text,
                  'email': emailController.text,
                  'adresse': addressController.text,
                  'siteDeTravail': selectedsitedetravail != null
                      ? {"id": selectedsitedetravail!.id}
                      : null,
                  'direction': selectedDirection != null
                      ? {'id': selectedDirection!.id}
                      : null,
                  'statut': statutSelected != null
                      ? {'id': statutSelected!.id}
                      : null,
                  'proffession': professionController.text,
                  'motDePasse': passwordController.text,
                });

                Navigator.of(context).pop();
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  // Méthodes auxiliaires (identiques à la version précédente)
  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        // border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer $label';
        }
        return null;
      },
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Mot de passe',
        // border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer un mot de passe';
        }
        if (value.length < 6) {
          return 'Le mot de passe doit comporter au moins 6 caractères';
        }
        return null;
      },
    );
  }

  Widget buildSelectField(String label, List<String> options,
      String? selectedValue, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        // border: const OutlineInputBorder(),
      ),
      value: selectedValue,
      onChanged: onChanged,
      items: options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez sélectionner $label';
        }
        return null;
      },
    );
  }

  Widget buildAutocompleteField(
      String label, TextEditingController controller, List<String> options) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return options.where((String option) {
          return option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        controller.text = selection;
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
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

  Widget buildAutocompleteStatutField(String label,
      TextEditingController controller, List<StatutPatient> statut) {
    return Autocomplete<StatutPatient>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<StatutPatient>.empty();
        }
        return statut.where((StatutPatient statu) {
          return statu.libelle
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      displayStringForOption: (StatutPatient statut) => statut.libelle,
      onSelected: (StatutPatient selection) {
        controller.text = selection.libelle;
        statutSelected = selection; // Enregistrer la direction sélectionnée
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
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
