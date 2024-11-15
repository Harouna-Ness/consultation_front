import 'package:flutter/material.dart';

class ChampsTexte {
  // champs de saisie
  static Widget buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Champ requis';
        }
        return null;
      },
    );
  }

  // champs de saisie pour mot de passe.
  static Widget buildPasswordField(TextEditingController mdpController,
      bool obscureText, VoidCallback toggleVisibility) {
    return TextFormField(
      controller: mdpController,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: 'Mot de passe',
        suffixIcon: IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: toggleVisibility,
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

  // Champs multiSelection
  static Widget buildSelectField(String label, List<String> options,
      String? selectedValue, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
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
}
