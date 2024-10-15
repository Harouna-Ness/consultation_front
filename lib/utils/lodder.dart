import 'package:flutter/material.dart';
import 'package:medstory/constantes.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(tertiaryColor),
              ),
              SizedBox(height: 20),
              Text(
                "Chargement en cours...",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showErrorDialog(BuildContext context, String errorMessage) {
  showDialog<void>(
    context: context,
    barrierDismissible:
        false, // Empêche de fermer en cliquant en dehors du dialog
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Erreur'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(errorMessage),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Fermer'),
            onPressed: () {
              Navigator.of(context).pop(); // Ferme le dialog
            },
          ),
        ],
      );
    },
  );
}

// Méthode pour cacher le loader
void hideLoadingDialog(BuildContext context) {
  Navigator.pop(context); // Ferme le dialog
}

void showSuccessSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.green,
    duration: const Duration(seconds: 3),
    action: SnackBarAction(
      label: 'Fermer',
      textColor: Colors.white,
      onPressed: () {
        // Si l'utilisateur veut fermer manuellement
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

// Extension pour simplifier l'appel
extension LoadingDialogExtension on BuildContext {
  void showLoader() => showLoadingDialog(this); // Affiche le loader
  void hideLoader() => hideLoadingDialog(this); // Cache le loader
  void showError(String errorMessage) => showErrorDialog(
        this,
        errorMessage,
      ); // Affiche un dialog d'erreur
      void showSuccess(String message) => showSuccessSnackBar(this, message); // Affiche un message de succès
}
