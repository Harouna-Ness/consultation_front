import 'package:flutter/material.dart';

class AddUserFormDialog extends StatefulWidget {
  @override
  _AddUserFormDialogState createState() => _AddUserFormDialogState();
}

class _AddUserFormDialogState extends State<AddUserFormDialog> {
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
  TextEditingController directionController = TextEditingController();
  TextEditingController siteController = TextEditingController();

  // Valeurs pour les selects
  String? selectedSexe;
  String? selectedStatut;

  // Listes des suggestions pour les champs d'auto-complétion
  List<String> directions = ['Direction 1', 'Direction 2', 'Direction 3'];
  List<String> sitesDeTravail = ['Site 1', 'Site 2', 'Site 3'];

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(child: buildTextField('Nom', nameController)),
                            SizedBox(width: 16),
                            Expanded(child: buildTextField('Prénom', surnameController)),
                          ],
                        ),
                        SizedBox(height: 16),
                        buildSelectField('Sexe', ['Masculin', 'Féminin'], selectedSexe, (value) {
                          setState(() {
                            selectedSexe = value;
                          });
                        }),
                        SizedBox(height: 16),
                        buildTextField('Date de Naissance', dobController, keyboardType: TextInputType.datetime),
                        SizedBox(height: 16),
                        buildTextField('Téléphone', phoneController, keyboardType: TextInputType.phone),
                        SizedBox(height: 16),
                        buildTextField('Email', emailController, keyboardType: TextInputType.emailAddress),
                        SizedBox(height: 16),
                        buildTextField('Adresse', addressController),
                        SizedBox(height: 16),
                        buildAutocompleteField('Direction', directionController, directions),
                        SizedBox(height: 16),
                        buildAutocompleteField('Site de Travail', siteController, sitesDeTravail),
                        SizedBox(height: 16),
                        buildTextField('Profession', professionController),
                        SizedBox(height: 16),
                        buildSelectField('Statut', ['Actif', 'Inactif'], selectedStatut, (value) {
                          setState(() {
                            selectedStatut = value;
                          });
                        }),
                        SizedBox(height: 16),
                        buildPasswordField(),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Logique pour ajouter l'utilisateur
                              Navigator.of(context).pop(); // Fermer le modal après validation
                            }
                          },
                          child: Text('Ajouter'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Text('Ajouter un Utilisateur'),
    );
  }

  // Méthode pour créer les champs de texte
  Widget buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
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

  // Méthode pour créer le champ de mot de passe
  Widget buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Mot de passe',
        border: OutlineInputBorder(),
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

  // Méthode pour créer les champs de sélection
  Widget buildSelectField(String label, List<String> options, String? selectedValue, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
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

  // Méthode pour créer les champs d'auto-complétion
  Widget buildAutocompleteField(String label, TextEditingController controller, List<String> options) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return options.where((String option) {
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        controller.text = selection;
      },
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
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

class ResponsiveUserForm extends StatelessWidget {
   ResponsiveUserForm({super.key});
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
  TextEditingController directionController = TextEditingController();
  TextEditingController siteController = TextEditingController();

  // Valeurs pour les selects
  String? selectedSexe;
  String? selectedStatut;

  // Listes des suggestions pour les champs d'auto-complétion
  List<String> directions = ['Direction 1', 'Direction 2', 'Direction 3'];
  List<String> sitesDeTravail = ['Site 1', 'Site 2', 'Site 3'];

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
