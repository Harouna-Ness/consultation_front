import 'package:flutter/material.dart';
import 'package:medstory/constantes.dart';

class AddUserForm extends StatefulWidget {
  @override
  _AddUserFormState createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  // Controllers pour récupérer les valeurs des champs
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true, // Permet un modal complet sur l'écran
          builder: (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: FractionallySizedBox(
              heightFactor: 0.9, // Prend 90% de la hauteur de l'écran
              child: ResponsiveUserForm(),
            ),
          ),
        );
      },
      child: Text('Ajouter un Utilisateur'),
    );
  }
}

class ResponsiveUserForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  // Controllers pour récupérer les valeurs des champs
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  ResponsiveUserForm({super.key});

  @override
  Widget build(BuildContext context) {
    // Utilisation de MediaQuery pour la largeur de l'écran
    final screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWideScreen = constraints.maxWidth > 600;
        return Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Les champs sont disposés en colonne ou en ligne selon la taille de l'écran
                    isWideScreen
                        ? Row(
                            children: [
                              Expanded(child: buildNameField()),
                              const SizedBox(width: defaultPadding),
                              Expanded(child: buildEmailField()),
                            ],
                          )
                        : Column(
                            children: [
                              buildNameField(),
                              const SizedBox(width: defaultPadding),
                              buildEmailField(),
                            ],
                          ),
                    const SizedBox(width: defaultPadding),
                    buildPasswordField(),
                    const SizedBox(height: 24.0),

                    // Bouton d'ajout d'utilisateur
                    SizedBox(
                      width: isWideScreen ? 200 : double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Si le formulaire est valide, affiche les valeurs saisies
                            print('Nom: ${nameController.text}');
                            print('Email: ${emailController.text}');
                            print('Mot de passe: ${passwordController.text}');

                            // Effectuer ici la logique pour ajouter l'utilisateur
                            Navigator.of(context).pop(); // Fermer le modal après validation
                          }
                        },
                        child: Text('Ajouter'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Méthode pour créer le champ de saisie du nom
  Widget buildNameField() {
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        labelText: 'Nom',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer un nom';
        }
        return null;
      },
    );
  }

  // Méthode pour créer le champ de saisie de l'email
  Widget buildEmailField() {
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer un email';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Veuillez entrer un email valide';
        }
        return null;
      },
    );
  }

  // Méthode pour créer le champ de saisie du mot de passe
  Widget buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Mot de passe',
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            _obscureText = !_obscureText;
          },
        ),
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
}
