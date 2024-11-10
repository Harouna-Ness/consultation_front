import 'package:medstory/models/role.dart';
import 'package:medstory/models/utilisateur.dart';

class Medecin extends Utilisateur {
  final String specialite;
  final String matricule;
  final List<Map<String, dynamic>> joursIntervention;

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
    required this.matricule,
    required this.joursIntervention,
    required super.profileImage,
  });

  factory Medecin.fromMap(Map<String, dynamic> map) {
    return Medecin(
      id: map['id'] ?? 0,
      profileImage: map['profileImage'],
      nom: map['nom'] ?? 'Nom Inconnu',
      prenom: map['prenom'] ?? 'Prénom Inconnu',
      role: Role.fromMap(map['role']),
      adresse: map['adresse'] ?? '',
      email: map['email'] ?? 'email@example.com',
      telephone: map['telephone'] ?? '0000000000',
      motDePasse: map['motDePasse'] ?? '',
      sexe: map['sexe'] ?? '',
      specialite: map['specialite'] ?? 'Spécialité Inconnue',
      matricule: map['matricule'] ?? '0000000000',
      joursIntervention:
          List<Map<String, dynamic>>.from(map['joursIntervention'] ?? []),
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
      'profileImage': profileImage,
      'matricule': matricule,
      'joursIntervention': joursIntervention,
    };
  }
}
