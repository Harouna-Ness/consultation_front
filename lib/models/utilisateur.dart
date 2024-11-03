import 'package:medstory/models/role.dart';

class Utilisateur {
  final int? id;
  final String nom;
  final String prenom;
  final Role role;
  final String? adresse;
  final String? profileImage;
  final String email;
  final String telephone;
  final String motDePasse;
  final String sexe;

  Utilisateur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.role,
    required this.adresse,
    required this.email,
    required this.telephone,
    required this.motDePasse,
    required this.sexe,
    required this.profileImage,
  });

  factory Utilisateur.fromMap(Map<String, dynamic> map) {
    return Utilisateur(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      role: Role.fromMap(map['role']),
      adresse: map['adresse'],
      email: map['email'],
      telephone: map['telephone'],
      motDePasse: map['motDePasse'],
      sexe: map['sexe'],
      profileImage: map['profileImage'],
    );
  }

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
      'profileImage': profileImage,
    };
  }
}