import 'package:medstory/models/role.dart';
import 'package:medstory/models/utilisateur.dart';

class Medecin extends Utilisateur {
  final String specialite;
  final List<String> joursIntervention;

  Medecin({
    required int super.id,
    required super.nom,
    required super.prenom,
    required super.role,
    required String super.adresse,
    required super.email,
    required super.telephone,
    required super.motDePasse,
    required super.sexe,
    required this.specialite,
    required this.joursIntervention,
  });

  factory Medecin.fromMap(Map<String, dynamic> map) {
    return Medecin(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      role: Role.fromMap(map['role']),
      adresse: map['adresse'],
      email: map['email'],
      telephone: map['telephone'],
      motDePasse: map['motDePasse'],
      sexe: map['sexe'],
      specialite: map['specialite'],
      joursIntervention: List<String>.from(map['joursIntervention']),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'role': role.toMap(),
      'adresse': adresse,
      'email': email,
      'telephone': telephone,
      'motDePasse': motDePasse,
      'sexe': sexe,
      'specialite': specialite,
      'joursIntervention': joursIntervention,
    };
  }
}
