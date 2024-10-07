import 'package:flutter/material.dart';

class AddUserForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit; // Callback pour renvoyer les données du formulaire

  AddUserForm({required this.onSubmit});

  @override
  _AddUserFormState createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
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
          buildSelectField('Sexe', ['Masculin', 'Féminin'], selectedSexe, (value) {
            setState(() {
              selectedSexe = value;
            });
          }),
          const SizedBox(height: 16),
          buildTextField('Date de Naissance', dobController, keyboardType: TextInputType.datetime),
         const SizedBox(height: 16),
          buildTextField('Téléphone', phoneController, keyboardType: TextInputType.phone),
         const SizedBox(height: 16),
          buildTextField('Email', emailController, keyboardType: TextInputType.emailAddress),
         const SizedBox(height: 16),
          buildTextField('Adresse', addressController),
         const SizedBox(height: 16),
          buildAutocompleteField('Direction', directionController, directions),
          const SizedBox(height: 16),
          buildAutocompleteField('Site de Travail', siteController, sitesDeTravail),
         const  SizedBox(height: 16),
          buildTextField('Profession', professionController),
          const SizedBox(height: 16),
          buildSelectField('Statut', ['Actif', 'Inactif'], selectedStatut, (value) {
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
                  'direction': {"id":1},
                  'siteDeTravail': {"id":1},
                  // 'direction': directionController.text,
                  // 'siteDeTravail': siteController.text,
                  'profession': professionController.text,
                  'statut': {"id":1},
                  // 'statut': selectedStatut,
                  'motDePasse': passwordController.text,
                });
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  // Méthodes auxiliaires (identiques à la version précédente)
  Widget buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
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

  Widget buildSelectField(String label, List<String> options, String? selectedValue, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
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
