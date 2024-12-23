import 'package:medstory/models/direction.dart';
import 'package:medstory/models/dossier_medical.dart';
import 'package:medstory/models/role.dart';
import 'package:medstory/models/site_de_tavail.dart';
import 'package:medstory/models/statut_patient.dart';
import 'package:medstory/models/utilisateur.dart';

class Patient extends Utilisateur {
  final DateTime? dateDeNaissance;
  final String? proffession;
  final Sitedetravail? sitedetravail;
  final Direction? direction;
  final StatutPatient? statut;
  final DossierMedical? dossierMedical;

  Patient({
    required super.id,
    required super.nom,
    required super.prenom,
    required super.role,
    required super.adresse,
    required super.email,
    required super.telephone,
    required super.motDePasse,
    required super.sexe,
    required this.dateDeNaissance,
    required this.proffession,
    required this.sitedetravail,
    required this.direction,
    required this.dossierMedical,
    required this.statut,
    required super.profileImage,
  });

  int? calculateAge() {
    if (dateDeNaissance == null) return null;
    final today = DateTime.now();
    int age = today.year - dateDeNaissance!.year;
    if (today.month < dateDeNaissance!.month ||
        (today.month == dateDeNaissance!.month &&
            today.day < dateDeNaissance!.day)) {
      age--;
    }
    return age;
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      role: Role.fromMap(map['role']),
      adresse: map['adresse'],
      email: map['email'],
      telephone: map['telephone'],
      motDePasse: map['motDePasse'],
      sexe: map['sexe'],
      profileImage: map['profileImage'] ?? '',
      dateDeNaissance: map['dateDeNaissance'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateDeNaissance'])
          : null,
      proffession: map['proffession'],
      sitedetravail: map['siteDeTravail'] != null
          ? Sitedetravail.fromMap(map['siteDeTravail'])
          : null,
      direction: Direction.fromMap(map['direction']),
      statut: StatutPatient.fromMap(map['statut']),
      dossierMedical: map['dossierMedical'] != null
          ? DossierMedical.fromMap(map['dossierMedical'])
          : null,
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
      'profileImage': profileImage,
      'dateDeNaissance': dateDeNaissance!.toIso8601String(),
      'proffession': proffession,
      'Sitedetravail': sitedetravail?.toMap(),
      'direction': direction?.toMap(),
      'statut': statut?.toMap(),
    };
  }
}
